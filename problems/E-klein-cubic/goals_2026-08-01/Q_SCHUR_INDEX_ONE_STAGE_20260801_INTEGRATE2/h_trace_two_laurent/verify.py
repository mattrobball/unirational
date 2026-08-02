#!/usr/bin/env python3
"""Independent exact replay of the all-exponent two-Laurent-term theorem."""

from __future__ import annotations

from itertools import product
import json
from pathlib import Path

import sympy as sp
from sympy import ZZ
from sympy.polys.matrices import DomainMatrix
from sympy.polys.matrices.normalforms import smith_normal_decomp


HERE = Path(__file__).resolve().parent
PAYLOAD = HERE / "payload.json"

t = sp.symbols("t")
COEFFICIENTS = (sp.Integer(1), t, 2*t, 2*t**2, t**2, t**3)

# Coordinates are the exponents of r0,r1,r2,r3 after eliminating r4.
S = sp.Matrix([
    [0, 0, 0, -1],
    [1, 0, 0, -1],
    [0, 1, 0, -1],
    [0, 0, 1, -1],
])
I = sp.eye(4)
C = sp.Matrix([0, 0, -1, 0])
PSI = 2*I + S
OFFSETS = (sp.zeros(4), S, I, I+S, 2*I, 2*I+S)


def partitions(items: tuple[int, ...]):
    """Generate set partitions; final de-duplication makes order irrelevant."""
    if not items:
        yield ()
        return
    first, *rest = items
    for partition in partitions(tuple(rest)):
        yield ((first,),) + partition
        for i in range(len(partition)):
            block = tuple(sorted((first,) + partition[i]))
            yield tuple(sorted(partition[:i] + (block,) + partition[i+1:]))


def all_partitions() -> list[tuple[tuple[int, ...], ...]]:
    return sorted(set(partitions(tuple(range(6)))))


def nonzero_common_factor(partition) -> sp.Poly:
    block_polynomials = [
        sp.Poly(sum(COEFFICIENTS[i] for i in block), t, domain=sp.QQ)
        for block in partition
    ]
    common = block_polynomials[0]
    for polynomial in block_polynomials[1:]:
        common = sp.gcd(common, polynomial)
    # A root t=0 would delete the second Laurent term and is outside the
    # two-nonzero-term classification (the one-term case is already direct).
    t_poly = sp.Poly(t, t, domain=sp.QQ)
    while common.degree() > 0 and common.eval(0) == 0:
        common = sp.quo(common, t_poly)
    return common.monic()


def lattice_system(partition, shifts):
    """Build E_item=S^k E_reference for every within-block relation."""
    rows: list[list[sp.Expr]] = []
    rhs: list[list[sp.Expr]] = []
    cursor = 0
    for block in partition:
        reference = block[0]
        for item in block[1:]:
            sk = S**shifts[cursor]
            cursor += 1
            # E_i=C+PSI*u+OFFSETS[i]*w.
            matrix = (PSI-sk*PSI).row_join(OFFSETS[item]-sk*OFFSETS[reference])
            rows.extend(matrix.tolist())
            rhs.extend((sk*C-C).tolist())
    return sp.Matrix(rows), sp.Matrix(rhs)


def solve_over_integers(matrix: sp.Matrix, rhs: sp.Matrix):
    """Return a particular integral solution and the full Q-nullspace."""
    domain_matrix = DomainMatrix.from_Matrix(matrix, fmt="dense").convert_to(ZZ)
    diagonal, left, right = smith_normal_decomp(domain_matrix)
    transformed_rhs = left.to_Matrix()*rhs
    diagonal_matrix = diagonal.to_Matrix()
    rank = 0
    for i in range(min(diagonal.shape)):
        entry = int(diagonal_matrix[i, i])
        if entry:
            rank += 1
            if int(transformed_rhs[i, 0]) % abs(entry):
                return None
    if any(transformed_rhs[i, 0] != 0 for i in range(rank, matrix.rows)):
        return None
    smith_coordinates = sp.zeros(matrix.cols, 1)
    for i in range(rank):
        smith_coordinates[i, 0] = transformed_rhs[i, 0] // diagonal_matrix[i, i]
    solution = right.to_Matrix()*smith_coordinates
    assert matrix*solution == rhs
    assert all(value.q == 1 for value in solution)
    return tuple(int(value) for value in solution), matrix.nullspace()


def orbit_key(exponent: sp.Matrix) -> tuple[int, ...]:
    return min(
        tuple(int(value) for value in S**k*exponent)
        for k in range(5)
    )


def actual_orbit_sums(solution):
    """Re-merge all six terms by actual orbit, not nominal partition block."""
    u = sp.Matrix(solution[:4])
    w = sp.Matrix(solution[4:])
    base = C+PSI*u
    groups: dict[tuple[int, ...], sp.Expr] = {}
    for i, offset in enumerate(OFFSETS):
        key = orbit_key(base+offset*w)
        groups[key] = groups.get(key, sp.Integer(0))+COEFFICIENTS[i]
    return groups


def main() -> None:
    payload = json.loads(PAYLOAD.read_text())
    assert payload["format"] == "H-11_5-TRACE-TWO-LAURENT-v1"
    assert payload["cyclic_action_matrix"] == [list(map(int, row)) for row in S.tolist()]
    assert S**5 == I

    # Check the action directly after r4=(r0*r1*r2*r3)^-1:
    # sigma maps exponent (a,b,c,d) to (-d,a-d,b-d,c-d).
    probe = sp.Matrix([2, -3, 5, 7])
    assert S*probe == sp.Matrix([-7, -5, -10, -2])
    assert C == sp.Matrix([0, 0, -1, 0])

    every_partition = all_partitions()
    assert len(every_partition) == 203
    viable = []
    for partition in every_partition:
        factor = nonzero_common_factor(partition)
        if factor.degree() > 0:
            viable.append((partition, factor))
    assert len(viable) == 9
    assert all(sp.rem(factor, sp.Poly(t+1, t, domain=sp.QQ)).is_zero for _, factor in viable)

    systems = 0
    integer_solvable = 0
    hits = []
    for partition, factor in viable:
        relation_count = 6-len(partition)
        for shifts in product(range(5), repeat=relation_count):
            systems += 1
            matrix, rhs = lattice_system(partition, shifts)
            result = solve_over_integers(matrix, rhs)
            if result is None:
                continue
            integer_solvable += 1
            solution, nullspace = result
            groups = actual_orbit_sums(solution)
            identity = all(
                sp.rem(sp.Poly(polynomial, t, domain=sp.QQ), factor).is_zero
                for polynomial in groups.values()
            )
            if not identity:
                continue
            particular_w_zero = not any(solution[4:])
            nullspace_w_zero = all(
                all(vector[i] == 0 for i in range(4, 8))
                for vector in nullspace
            )
            hits.append({
                "factor": factor,
                "nullity": len(nullspace),
                "nullspace_w_zero": nullspace_w_zero,
                "partition": partition,
                "particular_w_zero": particular_w_zero,
                "shifts": shifts,
                "solution": solution,
            })

    assert systems == 7125
    assert integer_solvable == 9
    assert len(hits) == 9
    assert all(hit["nullity"] == 4 for hit in hits)
    assert all(hit["particular_w_zero"] for hit in hits)
    assert all(hit["nullspace_w_zero"] for hit in hits)
    assert all(not any(hit["shifts"]) for hit in hits)
    assert all(
        sp.rem(hit["factor"], sp.Poly(t+1, t, domain=sp.QQ)).is_zero
        for hit in hits
    )

    expected = payload["counts"]
    assert expected == {
        "coefficient_viable_partitions": len(viable),
        "integer_solvable_systems": integer_solvable,
        "nondegenerate_hits": 0,
        "partitions": len(every_partition),
        "shift_systems": systems,
        "verified_hits": len(hits),
    }

    print("PARTITIONS", len(every_partition))
    print("COEFFICIENT_VIABLE", len(viable))
    print("SHIFT_SYSTEMS", systems)
    print("INTEGER_SOLVABLE", integer_solvable)
    print("VERIFIED_HITS", len(hits))
    print("NONDEGENERATE_HITS", 0)
    print("H_TRACE_TWO_LAURENT_ALL_EXPONENT_EXCLUSION_OK")


if __name__ == "__main__":
    main()

