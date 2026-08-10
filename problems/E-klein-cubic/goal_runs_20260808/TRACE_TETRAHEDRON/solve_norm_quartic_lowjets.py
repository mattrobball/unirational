#!/usr/bin/env python3
"""Exact Groebner check of the analytically reduced quartic low-jet system."""

import importlib.util
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
SPEC = importlib.util.spec_from_file_location(
    "quartic_constraints", HERE / "derive_norm_quartic_constraints.py"
)
QC = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(QC)


def main():
    S = QC.barycentric_sums()
    rows = {
        (4, 4): QC.cleared_constraint(4, 4, S),
        (2, 7): QC.cleared_constraint(2, 7, S),
        (7, 2): QC.cleared_constraint(7, 2, S),
    }
    # Homogeneity permits e4=1 over the algebraic closure because e4!=0.
    equations = [
        sp.expand(value.subs({QC.e4: 1}))
        for value in rows.values()
    ]
    basis = sp.groebner(
        [QC.NM.phi5, *equations],
        QC.NM.z,
        QC.e1,
        QC.e2,
        QC.e3,
        order="grevlex",
    )
    print("LOWJET_INPUT_ROWS", sorted(rows))
    print("LOWJET_GROEBNER_ZERO_DIMENSIONAL", basis.is_zero_dimensional)
    print("LOWJET_GROEBNER_SIZE", len(basis.polys))
    for polynomial in basis.polys:
        print("G", polynomial.as_expr())

    targets = {
        "E1_MINUS_E2E3_SQUARED": (QC.e1 - QC.e2 * QC.e3) ** 2,
        "E2_MINUS_E3SQ_SQUARED": (QC.e2 - QC.e3**2) ** 2,
        "E3_BRANCH": (3 * QC.NM.z + 2) * QC.e3**2 * (QC.e3**4 - 1),
    }
    for name, target in targets.items():
        remainder = basis.reduce(target)[1]
        print("TARGET_REMAINDER", name, sp.factor(remainder))

    # The displayed basis contains (e1-e2*e3)^2,
    # (e2-e3^2)^2, and then e3^2*(e3^4-1) up to a nonzero
    # cyclotomic factor.  Test the resulting two normal forms against the
    # next three (total-degree ten) trace coefficients.
    t = sp.symbols("t")
    next_rows = {
        (P, 10 - P): QC.cleared_constraint(P, 10 - P, S)
        for P in (0, 5, 10)
    }
    for row, value in next_rows.items():
        square = sp.factor(QC.NM.reduce_z(value.subs({QC.e1: 0, QC.e2: 0, QC.e3: 0, QC.e4: 1})))
        pentagon = QC.NM.reduce_z(
            value.subs({QC.e1: t**3, QC.e2: t**2, QC.e3: t, QC.e4: 1})
        )
        pentagon = sp.Poly(sp.expand(pentagon), t, domain="EX").rem(
            sp.Poly(t**4 - 1, t, domain="EX")
        ).as_expr()
        pentagon = sp.factor(QC.NM.reduce_z(pentagon))
        print("NEXT_ROW", row, "SQUARE", square, "PENTAGON", pentagon)


if __name__ == "__main__":
    main()
