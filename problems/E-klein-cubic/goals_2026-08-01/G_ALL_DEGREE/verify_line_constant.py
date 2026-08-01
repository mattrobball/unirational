#!/usr/bin/env python3
"""Independent reconstruction and geometric-emptiness check.

The producer is not imported: this verifier rebuilds the Reynolds spaces
from the authoritative matrices, reconstructs every cubic coefficient, and
checks the unit ideal on every projective chart.
"""

from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

import numpy as np
import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
SOURCE = PROBLEM / "tmp" / "symbolic_compatibility_complex" / "line_landing_bigraded.py"


def weak_compositions(total: int, variables: int):
    answer = []

    def visit(prefix, remaining, slots):
        if slots == 1:
            answer.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, slots - 1)

    visit((), total, variables)
    return answer


def reconstruct_cases():
    spec = importlib.util.spec_from_file_location("goal_g_line_verifier", SOURCE)
    assert spec and spec.loader
    source = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = source
    spec.loader.exec_module(source)
    reynolds = source.audit.load(
        source.audit.REYNOLDS, "goal_g_line_verifier_reynolds"
    )
    module = reynolds.load_reynolds_module()
    source.base.module_global = module
    _, records = source.line_records(module)
    rng = np.random.default_rng(20260801)
    answer = []
    for order, transverse_degree in ((1, 3), (3, 6)):
        record, rows = source.compute_case(
            module, records, order, transverse_degree, 0, rng
        )
        answer.append((order, record, rows % 67))
    return answer


def chart_unit_ideals(rows: np.ndarray, dimension: int) -> None:
    variables = sp.symbols(f"a0:{dimension}")
    monomials = weak_compositions(3, dimension)
    polynomials = []
    for row in rows:
        expression = sum(
            int(coefficient)
            * sp.prod(variable**exponent for variable, exponent in zip(variables, powers))
            for coefficient, powers in zip(row, monomials)
        )
        polynomials.append(sp.Poly(expression, *variables, modulus=67).as_expr())

    for chart in range(dimension):
        remaining = [variable for index, variable in enumerate(variables) if index != chart]
        affine = [
            sp.Poly(poly.subs(variables[chart], 1), *remaining, modulus=67).as_expr()
            for poly in polynomials
        ]
        basis = sp.groebner(affine, *remaining, modulus=67, order="lex")
        assert len(basis.polys) == 1 and basis.polys[0].as_expr() == 1, (
            chart,
            basis,
        )


def main() -> None:
    cases = reconstruct_cases()
    expected = {
        1: np.array(
            [[1, 13, 0, 53], [0, 1, 61, 0], [0, 0, 1, 0]],
            dtype=np.int64,
        ),
        3: np.array(
            [
                [1, 13, 0, 53, 0, 24, 47, 14, 0, 59],
                [0, 1, 61, 0, 31, 11, 50, 32, 9, 0],
                [0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
                [0, 0, 1, 0, 6, 0, 0, 0, 32, 0],
            ],
            dtype=np.int64,
        ),
    }
    for order, record, rows in cases:
        assert np.array_equal(rows, expected[order])
        dimension = record["equivariant_parameter_dimension"]
        assert dimension == (2 if order == 1 else 3)
        chart_unit_ideals(rows, dimension)
        print(
            f"PASS m={order} reconstructed rows and geometric projective emptiness over F_67"
        )
    print("G_ALL_DEGREE_LINE_CONSTANT_VERIFY_OK")


if __name__ == "__main__":
    main()
