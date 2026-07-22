#!/usr/bin/env python3
"""Exact checks for the tangent-residual unirationality theorem.

The geometry is proved in ``tangent_residual_theorem.md``.  This script
checks the universal cubic--quadratic resultant identity, its coefficient
degrees and primitive nature, one base-factor-free substitution by ten
quadrics, and a smooth cubic on which the three residual tangent points are
distinct and collinear.
"""

from __future__ import annotations

import random

import sympy as sp


def universal_covariant():
    z, U, V, W = sp.symbols("z U V W")
    a, b, c, d, e, f, h, i, j, k = sp.symbols("a b c d e f h i j k")

    g = a * z**3 + b * z**2 + c * z + d
    g_u = 3 * a * z**2 + 2 * b * z + c
    # This is the second homogeneous derivative g_v evaluated at (z,1).
    g_v = b * z**2 + 2 * c * z + 3 * d
    h2 = e * z**2 + f * z + h
    polar = U * g_u + V * g_v + W * h2

    resultant = sp.expand(sp.resultant(g, polar, z))
    discriminant = sp.discriminant(g, z)
    cubic = (
        a * U**3
        + b * U**2 * V
        + c * U * V**2
        + d * V**3
        + W * (e * U**2 + f * U * V + h * V**2)
        + W**2 * (i * U + j * V)
        + k * W**3
    )

    numerator = sp.Poly(sp.expand(resultant + discriminant * cubic), W)
    assert numerator.coeff_monomial(1) == 0
    assert numerator.coeff_monomial(W) == 0
    q = sp.expand(numerator.as_expr() / W**2)
    q_poly = sp.Poly(q, U, V, W)
    assert q_poly.total_degree() == 1

    coefficient_symbols = (a, b, c, d, e, f, h, i, j, k)
    q_coefficients = [
        q_poly.coeff_monomial(U),
        q_poly.coeff_monomial(V),
        q_poly.coeff_monomial(W),
    ]
    assert all(
        sp.Poly(coefficient, *coefficient_symbols).total_degree() == 5
        for coefficient in q_coefficients
    )
    assert sp.gcd(sp.gcd(q_coefficients[0], q_coefficients[1]), q_coefficients[2]) == 1

    return coefficient_symbols, q_coefficients, cubic, (U, V, W)


def check_quadratic_substitution(coefficient_symbols, q_coefficients):
    x0, x1, x2 = sp.symbols("x0 x1 x2")
    monomials = (x0**2, x0 * x1, x0 * x2, x1**2, x1 * x2, x2**2)
    rng = random.Random(11)
    quadrics = [
        sum(rng.randint(-2, 2) * monomial for monomial in monomials)
        for _ in coefficient_symbols
    ]
    substitution = dict(zip(coefficient_symbols, quadrics))
    specialized = [sp.expand(coefficient.subs(substitution)) for coefficient in q_coefficients]

    specialized_polys = [sp.Poly(coefficient, x0, x1, x2) for coefficient in specialized]
    assert [polynomial.total_degree() for polynomial in specialized_polys] == [10, 10, 10]
    assert [len(polynomial.terms()) for polynomial in specialized_polys] == [66, 66, 66]
    assert sp.gcd(sp.gcd(specialized[0], specialized[1]), specialized[2]) == 1


def check_smooth_example(coefficient_symbols, q_coefficients, cubic, coordinates):
    U, V, W = coordinates
    a, b, c, d, e, f, h, i, j, k = coefficient_symbols
    example = {
        a: 0,
        b: 1,
        c: -1,
        d: 0,
        e: 1,
        f: 2,
        h: 3,
        i: 2,
        j: -1,
        k: 1,
    }
    F = sp.expand(cubic.subs(example))
    q_line = sp.expand(
        q_coefficients[0].subs(example) * U
        + q_coefficients[1].subs(example) * V
        + q_coefficients[2].subs(example) * W
    )
    assert q_line == -U + 14 * V + 19 * W

    derivatives = [sp.diff(F, variable) for variable in (U, V, W)]
    # The three standard affine charts cover projective space; unit Groebner
    # ideals in all three verify that this cubic is smooth.
    for chart_variable in (U, V, W):
        chart_coordinates = tuple(variable for variable in (U, V, W) if variable != chart_variable)
        basis = sp.groebner(
            [derivative.subs(chart_variable, 1) for derivative in derivatives],
            *chart_coordinates,
        )
        assert list(basis) == [1]

    points = ((1, 0, 0), (0, 1, 0), (1, 1, 0))
    residuals = ((5, -1, 1), (21, -8, 7), (-103, -25, 13))
    for first_index in range(len(residuals)):
        for second_index in range(first_index + 1, len(residuals)):
            first = residuals[first_index]
            second = residuals[second_index]
            cross_product = (
                first[1] * second[2] - first[2] * second[1],
                first[2] * second[0] - first[0] * second[2],
                first[0] * second[1] - first[1] * second[0],
            )
            assert cross_product != (0, 0, 0)
    for point, residual in zip(points, residuals):
        tangent = tuple(
            derivative.subs(dict(zip((U, V, W), point))) for derivative in derivatives
        )
        residual_substitution = dict(zip((U, V, W), residual))
        assert F.subs(residual_substitution) == 0
        assert sum(tangent[index] * residual[index] for index in range(3)) == 0
        assert q_line.subs(residual_substitution) == 0
        assert residual[2] != 0


def main():
    coefficient_symbols, q_coefficients, cubic, coordinates = universal_covariant()
    print("universal resultant identity: PASS")
    print("residual line coefficients: degree 5 and primitive: PASS")

    check_quadratic_substitution(coefficient_symbols, q_coefficients)
    print("general-quadratic specialization: degrees (10,10,10), gcd 1: PASS")

    check_smooth_example(coefficient_symbols, q_coefficients, cubic, coordinates)
    print("smooth cubic with three distinct collinear residuals: PASS")

    resultant_class = (10, 3)
    source_twice = (0, 2)
    residual_class = tuple(
        resultant_class[index] - source_twice[index] for index in range(2)
    )
    assert residual_class == (10, 1)
    assert 2 * residual_class[0] == 20
    print("divisor arithmetic: (10,3)-2(0,1)=(10,1), base degree 20: PASS")
    print("all tangent-residual local checks passed")


if __name__ == "__main__":
    main()
