#!/usr/bin/env python3
"""Probe infinitesimal residual-map rigidity in tangent-point normal form.

After sending a smooth point to ``[0:1:0]`` and its tangent to ``W=0``, a
ternary cubic has coefficients ``c=d=0`` and ``h != 0`` in the ordering used
by ``tangent_residual_local_checks.universal_covariant``.  Dividing the cubic
by ``h`` gives ``h=1``.  This script looks for a symbolic 9 by 9 minor proving
that an infinitesimal deformation which preserves the projective residual-line
map is pure scaling.

This is a probe, not a Lean proof.  It prints the selected coefficient rows
and the factored determinant so that a compact identity can be internalized.
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import tempfile
from pathlib import Path

import sympy as sp

from residual_line_pencil_probe import affine_residual_map


def m2(expression: sp.Expr) -> str:
    return str(sp.expand(expression)).replace("**", "^")


def macaulay2_determinant(matrix: sp.Matrix) -> None:
    executable = shutil.which("M2")
    if executable is None:
        raise RuntimeError("Macaulay2 executable `M2` was not found on PATH")
    rows = [
        "{" + ",".join(m2(matrix[row, column]) for column in range(matrix.cols)) + "}"
        for row in range(matrix.rows)
    ]
    program = "\n".join(
        (
            "R=QQ[a,b,e,f,i,j,k,MonomialOrder=>GRevLex];",
            "M=matrix{" + ",\n".join(rows) + "};",
            "D=det M;",
            "assert(D != 0);",
            '<< "determinant factorization:" << endl;',
            "<< factor D << endl;",
        )
    )
    with tempfile.TemporaryDirectory(prefix="tangent_normal_form_minor_") as directory:
        script = Path(directory) / "minor.m2"
        script.write_text(program, encoding="utf-8")
        result = subprocess.run(
            [executable, "--script", str(script)],
            check=False,
            capture_output=True,
            text=True,
            timeout=120,
        )
    print(result.stdout, end="")
    if result.returncode != 0:
        print(result.stderr, end="")
        raise RuntimeError(f"Macaulay2 determinant failed with code {result.returncode}")


def rank_mod_prime(matrix: list[list[int]], prime: int) -> tuple[int, list[int]]:
    rows = [[entry % prime for entry in row] for row in matrix]
    labels = list(range(len(rows)))
    rank = 0
    pivots: list[int] = []
    for column in range(len(rows[0])):
        pivot = next(
            (row for row in range(rank, len(rows)) if rows[row][column] % prime), None
        )
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        labels[rank], labels[pivot] = labels[pivot], labels[rank]
        pivots.append(labels[rank])
        inverse = pow(rows[rank][column], -1, prime)
        rows[rank] = [(entry * inverse) % prime for entry in rows[rank]]
        for row in range(len(rows)):
            if row == rank:
                continue
            multiple = rows[row][column] % prime
            if multiple:
                rows[row] = [
                    (rows[row][index] - multiple * rows[rank][index]) % prime
                    for index in range(len(rows[row]))
                ]
        rank += 1
    return rank, pivots


def sparse_independent_rows(
    symbolic_rows: list[list[sp.Expr]], numeric_rows: list[list[int]], prime: int
) -> list[int]:
    order = sorted(
        range(len(symbolic_rows)),
        key=lambda row: (
            sum(entry != 0 for entry in symbolic_rows[row]),
            sum(sp.count_ops(entry) for entry in symbolic_rows[row]),
        ),
    )
    selected: list[int] = []
    rank = 0
    for row in order:
        candidate = selected + [row]
        new_rank, _ = rank_mod_prime([numeric_rows[index] for index in candidate], prime)
        if new_rank > rank:
            selected.append(row)
            rank = new_rank
            if rank == len(numeric_rows[0]):
                return selected
    return selected


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--determinant",
        action="store_true",
        help="attempt the expensive symbolic determinant of the selected minor",
    )
    args = parser.parse_args()
    coefficients, (s, t), residual = affine_residual_map()
    a, b, c, d, e, f, h, i, j, k = coefficients
    tangent_substitution = {c: 0, d: 0, h: 1}
    residual_dicts = tuple(
        dict(sp.Poly(q, s, t).terms())
        for q in residual
    )

    def specialize_dict(values: dict[tuple[int, int], sp.Expr]):
        result = {}
        for monomial, value in values.items():
            specialized = value.subs(tangent_substitution, simultaneous=True)
            if specialized != 0:
                result[monomial] = specialized
        return result

    base = tuple(specialize_dict(values) for values in residual_dicts)
    # Quotient out the pure-scaling direction by imposing delta_h=0.  Since
    # h=1, every deformation differs from a unique such normalized one by a
    # multiple of the base cubic.
    unknowns = (a, b, c, d, e, f, i, j, k)
    directions = tuple(
        tuple(specialize_dict({m: sp.diff(value, variable) for m, value in values.items()})
              for values in residual_dicts)
        for variable in unknowns
    )

    def mul_dict(
        left: dict[tuple[int, int], sp.Expr],
        right: dict[tuple[int, int], sp.Expr],
    ) -> dict[tuple[int, int], sp.Expr]:
        result: dict[tuple[int, int], sp.Expr] = {}
        for (ls, lt), lv in left.items():
            for (rs, rt), rv in right.items():
                monomial = (ls + rs, lt + rt)
                result[monomial] = result.get(monomial, 0) + lv * rv
        return result

    equations: list[tuple[tuple[int, int, int], list[sp.Expr]]] = []
    for pair_index, (left, right) in enumerate(((0, 2), (1, 2), (0, 1))):
        linear_forms: list[dict[tuple[int, int], sp.Expr]] = []
        for direction in directions:
            first = mul_dict(direction[left], base[right])
            second = mul_dict(direction[right], base[left])
            monomials = set(first) | set(second)
            linear_forms.append({
                monomial: first.get(monomial, 0) - second.get(monomial, 0)
                for monomial in monomials
            })
        monomials = sorted(set().union(*(set(q) for q in linear_forms)), reverse=True)
        for monomial in monomials:
            row = [q.get(monomial, 0) for q in linear_forms]
            if any(entry != 0 for entry in row):
                equations.append(((pair_index, monomial[0], monomial[1]), row))

    sample = {a: 2, b: 3, e: 5, f: 7, i: 11, j: 13, k: 17}
    prime = 1000003
    numeric = [
        [int(sp.sympify(entry).subs(sample)) % prime for entry in row]
        for _, row in equations
    ]
    rank, _ = rank_mod_prime(numeric, prime)
    print(f"normalized tangent-form infinitesimal rank mod {prime}: {rank}")
    if rank != 9:
        raise RuntimeError("expected full normalized rank 9")

    selected_indices = sparse_independent_rows(
        [row for _, row in equations], numeric, prime
    )
    selected = [equations[index] for index in selected_indices]
    matrix = sp.Matrix([row for _, row in selected])
    print("unknowns:", ", ".join(map(str, unknowns)))
    print("selected rows:")
    for label, _ in selected:
        print(" ", label)
    print("selected nonzero counts:", [sum(entry != 0 for entry in row) for _, row in selected])
    if args.determinant:
        print("computing determinant in Macaulay2", flush=True)
        macaulay2_determinant(matrix)
    else:
        selected_numeric = [numeric[index] for index in selected_indices]
        selected_rank, _ = rank_mod_prime(selected_numeric, prime)
        assert selected_rank == 9
        print("selected 9 by 9 minor is nonzero at the modular sample: PASS")


if __name__ == "__main__":
    main()
