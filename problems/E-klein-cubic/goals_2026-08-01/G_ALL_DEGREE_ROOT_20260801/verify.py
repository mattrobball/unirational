#!/usr/bin/env python3
"""Independent verifier for the isolated all-order structural theorem."""

from __future__ import annotations

import hashlib
import importlib.util
import json
import sys
from pathlib import Path

import numpy as np
import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
SOURCE = PROBLEM / "tmp" / "symbolic_compatibility_complex" / "line_landing_bigraded.py"
EXPECTED_INPUT_HASHES = {
    "tmp/degree14_structural/core.py":
        "2e6e0a27843478361916266883488bd662627447af3c2cb57e235e53ec626372",
    "tmp/symbolic_compatibility_complex/line_landing_bigraded.py":
        "efaa3975152bf03a80e691a7521638cdeba01dc7ad80e46981ec1608780d4a62",
    "tmp/symbolic_compatibility_complex/line_post_gate_landing.py":
        "60a69b32eabb7421b368063012a5135b8e9216c420f980284024594d0e08ee71",
    "tmp/symbolic_compatibility_complex/triple_line_symbolic/verify.py":
        "f8dc05b012e1c2981ed854389d25ae32d9de51ced6f6c160f064518fe3986416",
}


def check_input_hashes():
    for relative, expected in EXPECTED_INPUT_HASHES.items():
        actual = hashlib.sha256((PROBLEM / relative).read_bytes()).hexdigest()
        assert actual == expected, (relative, expected, actual)


def check_seal():
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["exit"] == "G-STRUCTURAL-UNDECIDED"
    for relative, expected in seal["files"].items():
        actual = hashlib.sha256((HERE / relative).read_bytes()).hexdigest()
        assert actual == expected, (relative, expected, actual)


def weak_compositions(total, variables):
    result = []

    def visit(prefix, remaining, slots):
        if slots == 1:
            result.append(prefix + (remaining,))
        else:
            for exponent in range(remaining + 1):
                visit(prefix + (exponent,), remaining - exponent, slots - 1)

    visit((), total, variables)
    return result


def symbolic_monomials(order, degree):
    return {
        (a, b, degree - a - b)
        for a in range(degree + 1)
        for b in range(degree - a + 1)
        if b + degree - a - b >= order
        and a + degree - a - b >= order
        and a + b >= order
    }


def check_recurrence():
    base = symbolic_monomials(3, 6)
    for r in range(1, 81):
        shift = r - 1
        expected = {(a + shift, b + shift, c + shift) for a, b, c in base}
        assert symbolic_monomials(2 * r + 1, 3 * r + 3) == expected


def chart_unit(rows, dimension):
    variables = sp.symbols(f"a0:{dimension}")
    monomials = weak_compositions(3, dimension)
    equations = []
    for row in rows:
        expression = sum(
            int(coefficient)
            * sp.prod(variable**exponent for variable, exponent in zip(variables, powers))
            for coefficient, powers in zip(row, monomials)
        )
        equations.append(sp.Poly(expression, *variables, modulus=67).as_expr())
    for chart in range(dimension):
        remaining = [v for i, v in enumerate(variables) if i != chart]
        affine = [
            sp.Poly(f.subs(variables[chart], 1), *remaining, modulus=67).as_expr()
            for f in equations
        ]
        basis = sp.groebner(affine, *remaining, modulus=67, order="lex")
        assert len(basis.polys) == 1 and basis.polys[0].as_expr() == 1


def reconstruct_rows():
    spec = importlib.util.spec_from_file_location("goal_g_root_verifier", SOURCE)
    assert spec and spec.loader
    source = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = source
    spec.loader.exec_module(source)
    reynolds = source.audit.load(source.audit.REYNOLDS, "goal_g_root_verify_reynolds")
    module = reynolds.load_reynolds_module()
    source.base.module_global = module
    _, records = source.line_records(module)
    rng = np.random.default_rng(20260801)
    return [
        (order, source.compute_case(module, records, order, degree, 0, rng))
        for order, degree in ((1, 3), (3, 6))
    ]


def main() -> None:
    check_input_hashes()
    check_seal()
    check_recurrence()
    expected = {
        1: np.array([[1, 13, 0, 53], [0, 1, 61, 0], [0, 0, 1, 0]]),
        3: np.array(
            [
                [1, 13, 0, 53, 0, 24, 47, 14, 0, 59],
                [0, 1, 61, 0, 31, 11, 50, 32, 9, 0],
                [0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
                [0, 0, 1, 0, 6, 0, 0, 0, 32, 0],
            ]
        ),
    }
    for order, (record, rows) in reconstruct_rows():
        rows %= 67
        assert np.array_equal(rows, expected[order])
        dimension = record["equivariant_parameter_dimension"]
        assert dimension == (2 if order == 1 else 3)
        chart_unit(rows, dimension)
        print(f"PASS m={order} exact coefficient span and geometric emptiness")
    print("PASS authoritative input hashes")
    print("PASS isolated packet seal")
    print("PASS all-order monomial recurrence (proof is in THEOREM.md)")
    print("SCOPE positive line degree and generic twisted cubic remain undecided")
    print("G_ALL_DEGREE_ROOT_STRUCTURAL_VERIFY_OK")


if __name__ == "__main__":
    main()
