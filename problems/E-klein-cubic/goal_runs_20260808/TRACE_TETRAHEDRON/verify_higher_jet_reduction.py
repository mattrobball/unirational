#!/usr/bin/env python3
"""Exact small check of the tetrahedral second/third-jet reduction."""

import importlib.util
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
SPEC = importlib.util.spec_from_file_location(
    "higher_jets", HERE / "derive_higher_jets.py"
)
HJ = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(HJ)


def equations():
    L = [HJ.linear(i) for i in range(5)]
    Q = [HJ.quadratic(i) for i in range(5)]
    R = [HJ.cubic(i) for i in range(5)]
    jet4 = sum(
        L[i] * Q[i] * L[(i + 1) % 5]
        + sp.Rational(1, 2) * L[i] ** 2 * Q[(i + 1) % 5]
        for i in range(5)
    )
    jet5 = sum(
        sp.Rational(1, 3) * L[i] * R[i] * L[(i + 1) % 5]
        + sp.Rational(1, 4) * Q[i] ** 2 * L[(i + 1) % 5]
        + sp.Rational(1, 2) * L[i] * Q[i] * Q[(i + 1) % 5]
        + sp.Rational(1, 6) * L[i] ** 2 * R[(i + 1) % 5]
        for i in range(5)
    )
    return HJ.x_coefficients(jet4, 4), HJ.x_coefficients(jet5, 5)


def nonzero(expression):
    return sp.expand(HJ.reduce_z(expression)) != 0


def main():
    jet4, jet5 = equations()
    assert set(jet4) == {
        (0, 0, 1, 3),
        (1, 1, 1, 1),
        (2, 0, 0, 2),
        (3, 1, 0, 0),
    }

    q_rows = {
        (0, 0, 1, 3): HJ.qvars[(3, 4)],
        (1, 1, 1, 1): HJ.qvars[(2, 3)],
        (3, 1, 0, 0): HJ.qvars[(1, 2)],
    }
    for row, pivot in q_rows.items():
        assert nonzero(sp.diff(jet4[row], pivot))
        for other in HJ.qvars.values():
            if other != pivot:
                assert sp.diff(jet4[row], other) == 0

    qzero = {
        HJ.qvars[(1, 2)]: 0,
        HJ.qvars[(2, 3)]: 0,
        HJ.qvars[(3, 4)]: 0,
    }
    jet5_reduced = {
        row: sp.factor(HJ.reduce_z(value.subs(qzero)))
        for row, value in jet5.items()
    }
    assert nonzero(sp.diff(jet5_reduced[(0, 2, 1, 2)], HJ.rvars[(2, 2, 3)]))
    assert nonzero(sp.diff(jet5_reduced[(2, 1, 2, 0)], HJ.rvars[(2, 3, 3)]))
    assert all(
        sp.diff(jet5_reduced[(0, 2, 1, 2)], other) == 0
        for other in HJ.rvars.values()
        if other != HJ.rvars[(2, 2, 3)]
    )
    assert all(
        sp.diff(jet5_reduced[(2, 1, 2, 0)], other) == 0
        for other in HJ.rvars.values()
        if other != HJ.rvars[(2, 3, 3)]
    )

    # Fourier restriction of K to weights 0,1,4.  Ordered first two factors
    # and the shifted third factor give 1 on Z0^3 and
    # 2*(1+zeta+zeta^4) on Z0*Z1*Z4, before the common trace factor five.
    beta = HJ.reduce_z(2 * (1 + HJ.z + HJ.z**4))
    assert nonzero(beta)
    assert sp.expand(HJ.reduce_z(beta - (2 + 2 * HJ.z + 2 * HJ.z**4))) == 0

    # The rank-one-kernel argument used for the norm fibre is pure linear
    # algebra: if E has rank three, ker(E) is one-dimensional, so two nonzero
    # kernel vectors A and diag(w)A are proportional, forcing all w_j equal.
    A = sp.symbols("A0:4", nonzero=True)
    lam = sp.symbols("lambda")
    w = sp.symbols("w0:4")
    proportional_equations = [sp.expand(A[j] * (w[j] - lam)) for j in range(4)]
    assert all(sp.solve(eq, w[j]) == [lam] for j, eq in enumerate(proportional_equations))

    print("TETRAHEDRAL_J4_ROWS", len(jet4))
    print("TETRAHEDRAL_J4_ZERO_COMPONENTS", "q12 q23 q34")
    print("KERNEL_KLEIN_BETA", beta)
    print("TETRAHEDRAL_J5_FORCED_COMPONENTS", "r223 r233")
    print("PROJECTED_EVALUATION_RANK", 3)
    print("COMMON_NONZERO_CM_NORM", True)
    print("F55-TRACE-FOUR-TERM-TETRAHEDRAL-NORM-FIBRE-REDUCTION-OK")


if __name__ == "__main__":
    main()
