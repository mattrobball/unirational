#!/usr/bin/env python3
"""Exact local checks for the quartic tangent-residual covariant.

For a degree-d binary form the sign in the covariant identity is

    Res(g, P) - (-1)^(d(d-1)/2) Delta(g) F = W^2 q_F.

Thus the quartic identity uses ``Res - Delta*F`` (unlike the quadratic
and cubic cases, which use a plus sign).  Besides checking the universal
identity, this script checks primitivity before and after a deterministic
quadratic specialization and a smooth quartic witness with eight distinct
residual points and no points at infinity.
"""

from __future__ import annotations

from functools import reduce
import random

import sympy as sp


def universal_covariant():
    z, U, V, W = sp.symbols("z U V W")
    coefficients = sp.symbols("a b c d e f g h i j k l m n o")
    a, b, c, d, e, f, g, h, i, j, k, l, m, n, o = coefficients

    binary_quartic = a * z**4 + b * z**3 + c * z**2 + d * z + e
    derivative_u = 4 * a * z**3 + 3 * b * z**2 + 2 * c * z + d
    # This is the second homogeneous derivative, evaluated at (z, 1).
    derivative_v = b * z**3 + 2 * c * z**2 + 3 * d * z + 4 * e
    w_linear = f * z**3 + g * z**2 + h * z + i
    polar = U * derivative_u + V * derivative_v + W * w_linear

    quartic = (
        a * U**4
        + b * U**3 * V
        + c * U**2 * V**2
        + d * U * V**3
        + e * V**4
        + W * (f * U**3 + g * U**2 * V + h * U * V**2 + i * V**3)
        + W**2 * (j * U**2 + k * U * V + l * V**2)
        + W**3 * (m * U + n * V)
        + o * W**4
    )

    resultant = sp.expand(sp.resultant(binary_quartic, polar, z))
    discriminant = sp.discriminant(binary_quartic, z)
    degree = 4
    all_d_sign = (-1) ** (degree * (degree - 1) // 2)
    assert all_d_sign == 1

    numerator = sp.expand(resultant - all_d_sign * discriminant * quartic)
    numerator_in_w = sp.Poly(numerator, W)
    assert numerator_in_w.coeff_monomial(1) == 0
    assert numerator_in_w.coeff_monomial(W) == 0
    q = sp.expand(numerator / W**2)
    assert sp.expand(numerator - W**2 * q) == 0

    # The opposite sign really fails already in the constant and linear terms.
    wrong_sign = sp.Poly(sp.expand(resultant + discriminant * quartic), W)
    assert wrong_sign.coeff_monomial(1) != 0
    assert wrong_sign.coeff_monomial(W) != 0

    q_poly = sp.Poly(q, U, V, W)
    monomials = (U**2, U * V, V**2, U * W, V * W, W**2)
    assert q_poly.total_degree() == 2
    assert all(sum(exponents) == 2 for exponents in q_poly.monoms())
    assert len(q_poly.monoms()) == 6
    q_coefficients = [q_poly.coeff_monomial(monomial) for monomial in monomials]
    assert all(
        sp.Poly(coefficient, *coefficients).total_degree() == 7
        for coefficient in q_coefficients
    )
    assert [len(sp.Poly(coefficient, *coefficients).terms()) for coefficient in q_coefficients] == [
        87,
        104,
        87,
        103,
        103,
        92,
    ]
    assert reduce(sp.gcd, q_coefficients) == 1

    return coefficients, q_coefficients, quartic, (U, V, W)


def check_quadratic_substitution(coefficients, q_coefficients):
    x0, x1, x2 = sp.symbols("x0 x1 x2")
    monomials = (x0**2, x0 * x1, x0 * x2, x1**2, x1 * x2, x2**2)
    rng = random.Random(17)
    quadrics = [
        sum(rng.randint(-2, 2) * monomial for monomial in monomials)
        for _ in coefficients
    ]
    specialized = [
        sp.expand(coefficient.subs(dict(zip(coefficients, quadrics))))
        for coefficient in q_coefficients
    ]
    specialized_polys = [sp.Poly(coefficient, x0, x1, x2) for coefficient in specialized]
    assert [polynomial.total_degree() for polynomial in specialized_polys] == [14] * 6
    assert [len(polynomial.terms()) for polynomial in specialized_polys] == [
        120,
        120,
        120,
        120,
        119,
        120,
    ]
    assert reduce(sp.gcd, specialized) == 1


def check_smooth_no_junk_witness(coefficients, q_coefficients, quartic, coordinates):
    U, V, W = coordinates
    witness_values = (1, 1, 1, 2, 3, -3, -2, 0, -2, -1, -3, -2, -3, 1, -3)
    witness = dict(zip(coefficients, witness_values))
    F = sp.expand(quartic.subs(witness))
    q = sp.expand(
        q_coefficients[0].subs(witness) * U**2
        + q_coefficients[1].subs(witness) * U * V
        + q_coefficients[2].subs(witness) * V**2
        + q_coefficients[3].subs(witness) * U * W
        + q_coefficients[4].subs(witness) * V * W
        + q_coefficients[5].subs(witness) * W**2
    )
    expected_q = (
        19578 * U**2
        + 17925 * U * V
        + 6406 * V**2
        + 4895 * U * W
        - 4887 * V * W
        + 14716 * W**2
    )
    assert q == expected_q

    derivatives = [sp.diff(F, coordinate) for coordinate in coordinates]
    for chart_coordinate in coordinates:
        chart_coordinates = tuple(
            coordinate for coordinate in coordinates if coordinate != chart_coordinate
        )
        basis = sp.groebner(
            [derivative.subs(chart_coordinate, 1) for derivative in derivatives],
            *chart_coordinates,
        )
        assert list(basis) == [1]

    z = sp.symbols("z")
    binary = sp.expand(F.subs({U: z, V: 1, W: 0}))
    assert sp.discriminant(binary, z) == 4345
    q_on_line = sp.expand(q.subs({U: z, V: 1, W: 0}))
    assert sp.resultant(binary, q_on_line, z) == 715478656310289025

    affine_F = sp.expand(F.subs(W, 1))
    affine_q = sp.expand(q.subs(W, 1))
    eliminant = sp.Poly(sp.resultant(affine_F, affine_q, V), U)
    assert eliminant.degree() == 8
    assert sp.gcd(eliminant, eliminant.diff()) == 1


def main():
    coefficients, q_coefficients, quartic, coordinates = universal_covariant()
    print("universal quartic identity with corrected sign: PASS")
    print("six quadric coefficients: degree 7 and gcd 1: PASS")

    check_quadratic_substitution(coefficients, q_coefficients)
    print("seed-17 quadratic specialization: six degree-14 coefficients, gcd 1: PASS")

    check_smooth_no_junk_witness(coefficients, q_coefficients, quartic, coordinates)
    print("smooth quartic/no junk/eight distinct residual points: PASS")

    resultant_class = (14, 4)
    twice_source_class = (0, 2)
    residual_class = tuple(
        resultant_class[index] - twice_source_class[index] for index in range(2)
    )
    assert residual_class == (14, 2)
    assert 2 * residual_class[0] == 28
    print("divisor arithmetic: (14,4)-2(0,1)=(14,2), base degree 28: PASS")
    print("all quartic tangent-residual checks passed")


if __name__ == "__main__":
    main()
