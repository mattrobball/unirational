#!/usr/bin/env python3
"""Exact coefficient certificate for short-Weierstrass residual-map rigidity.

This script derives the base residual quartics and their first-order cross-products directly from
the universal residual covariant used elsewhere in the project.  The ten asserted coefficients
are exactly the hypotheses of Lean theorem
``WeierstrassResidualInfinitesimalCertificate.tangent_eq_smul_of_cross_equations``.

It is an algebraic certificate for the local tangent calculation, not a proof of the projective
normal-form, density, or integration bridges needed for the global good-line theorem.
"""

from __future__ import annotations

import sympy as sp

from residual_line_pencil_probe import affine_residual_map


def coefficient(expression: sp.Expr, s: sp.Symbol, t: sp.Symbol, i: int, j: int) -> sp.Expr:
    """Return the coefficient of ``s**i * t**j`` in a bivariate expression."""

    return sp.Poly(sp.expand(expression), s, t).coeff_monomial(s**i * t**j)


def main() -> None:
    coefficients, (s, t), residual = affine_residual_map()
    a, b, c, d, e, f, h, i, j, k = coefficients
    A, B, eps = sp.symbols("A B eps")
    da, db, dc, dd, de, df, dh, di, dj, dk = sp.symbols(
        "da db dc dd de df dh di dj dk"
    )

    base = {a: -1, b: 0, c: 0, d: 0, e: 0, f: 0, h: 1, i: -A, j: 0, k: -B}
    base_residual = tuple(sp.expand(q.subs(base, simultaneous=True)) for q in residual)
    expected_base = (
        -4
        * (
            A**2 * s**2 * t**2
            + A * s**3
            - 3 * A * t**2
            + B * s**4
            - 9 * B * s * t**2
            + s
        ),
        8 * t * (A * s**2 + B * s**3 + 1),
        -4 * A**3 * t**4
        + A**2 * s**4
        - 8 * A**2 * s * t**2
        - 6 * A * B * s**2 * t**2
        - 2 * A * s**2
        - 27 * B**2 * t**4
        - 8 * B * s**3
        + 18 * B * t**2
        + 1,
    )
    assert all(
        sp.expand(actual - expected) == 0
        for actual, expected in zip(base_residual, expected_base)
    )
    print("short-Weierstrass residual quartics: PASS")

    perturbation = {
        a: -1 + eps * da,
        b: eps * db,
        c: eps * dc,
        d: eps * dd,
        e: eps * de,
        f: eps * df,
        h: 1 + eps * dh,
        i: -A + eps * di,
        j: eps * dj,
        k: -B + eps * dk,
    }
    slopes = tuple(
        sp.expand(sp.diff(q.subs(perturbation, simultaneous=True), eps).subs(eps, 0))
        for q in residual
    )
    ru, rv, rw = base_residual
    du, dv, dw = slopes
    cross_uv = sp.expand(ru * dv - rv * du)
    cross_uw = sp.expand(ru * dw - rw * du)
    cross_vw = sp.expand(rv * dw - rw * dv)

    selected = (
        (coefficient(cross_uv, s, t, 0, 1), 24 * dc),
        (coefficient(cross_uv, s, t, 1, 0), -36 * dd),
        (coefficient(cross_uv, s, t, 2, 0), -16 * db),
        (coefficient(cross_uw, s, t, 2, 0), 4 * (4 * A * dc - de)),
        (coefficient(cross_uw, s, t, 0, 1), -6 * (6 * A * dd + df)),
        (coefficient(cross_uw, s, t, 0, 2), 12 * (A * dh + 3 * B * dc + di)),
        (coefficient(cross_uw, s, t, 3, 0), 12 * (A * da + 5 * B * dc - di)),
        (coefficient(cross_uw, s, t, 1, 1), -2 * (A * db + 135 * B * dd + 9 * dj)),
        (coefficient(cross_vw, s, t, 3, 1), -8 * (2 * A * de + 9 * B * da - 9 * dk)),
        (
            coefficient(cross_vw, s, t, 0, 3),
            -16 * (2 * A**2 * dc - A * de + 9 * B * dh + 9 * dk),
        ),
    )
    assert all(sp.expand(actual - expected) == 0 for actual, expected in selected)
    print("ten infinitesimal cross-product coefficients: PASS")

    # The asserted coefficient equations have a one-dimensional kernel, namely scalar change of
    # the cubic.  Check this independently at one point on each of the charts A != 0 and B != 0.
    tangent_variables = (da, db, dc, dd, de, df, dh, di, dj, dk)
    expressions = [expected for _, expected in selected]
    matrix = sp.Matrix([[sp.diff(q, variable) for variable in tangent_variables] for q in expressions])
    for point in ({A: 1, B: 0}, {A: 0, B: 1}, {A: 2, B: 3}):
        assert matrix.subs(point).rank() == 9
    print("selected-equation rank on both parameter charts: 9: PASS")


if __name__ == "__main__":
    main()
