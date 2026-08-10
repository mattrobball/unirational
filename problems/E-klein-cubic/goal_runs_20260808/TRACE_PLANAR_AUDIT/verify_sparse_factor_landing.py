#!/usr/bin/env python3
"""Tiny exact audit of the analytic rank-two factor argument.

This expands two forced two-variable normal forms and one Fourier
coefficient.  It performs no support or collision-hyperplane search.
"""

import sympy as sp


def cyclic_landing(values, coefficients):
    b = (*coefficients, sp.Integer(0))
    moments = [
        sum(b[k] * values[(i + k) % 5] for k in range(5))
        for i in range(5)
    ]
    q = [sp.expand(values[i] * moments[i]) for i in range(5)]
    return sp.factor(sum(q[i] ** 2 * q[(i + 1) % 5] for i in range(5)))


def reduce_zeta(expression, zeta):
    phi5 = zeta**4 + zeta**3 + zeta**2 + zeta + 1
    return sp.Poly(sp.expand(expression), zeta, domain="EX").rem(
        sp.Poly(phi5, zeta, domain="EX")
    ).as_expr()


def main():
    x, y = sp.symbols("x y")
    b0, b1, b2, b3 = sp.symbols("b0 b1 b2 b3")
    coefficients = (b0, b1, b2, b3)

    first = cyclic_landing((x, y, 0, -x - y, 0), coefficients)
    first_expected = (
        x**2
        * y
        * ((b0 - b3) * x + (b1 - b3) * y) ** 2
        * (-b2 * x + (b0 - b2) * y)
    )
    assert sp.expand(first - first_expected) == 0

    second = cyclic_landing((x, y, -x - y, 0, 0), coefficients)

    case_i = sp.factor(second.subs({b0: 0, b2: 0}))
    case_i_expected = -b1**2 * x * y**2 * (x + y) * (
        b1 * x * y + b3 * (x + y) ** 2
    )
    assert sp.expand(case_i - case_i_expected) == 0

    t, u = sp.symbols("t u")
    case_ii = sp.factor(second.subs({b0: t, b1: t, b2: u, b3: t}))
    case_ii_expected = -t * x**2 * y * (x + y) * (
        (t - u) ** 2 * x * (x + y) - t**2 * y**2
    )
    assert sp.expand(case_ii - case_ii_expected) == 0

    b3_only = cyclic_landing((1, 1, 0, 1, -3), (0, 0, 0, b3))
    b2_only = cyclic_landing((1, 1, 1, -3, 0), (0, 0, b2, 0))
    assert b3_only == -3 * b3**3
    assert b2_only == -3 * b2**3

    zeta = sp.symbols("zeta")
    x1, x2, x3, x4 = sp.symbols("x1 x2 x3 x4")
    a, b, c, d = sp.symbols("a b c d")
    linear_l = [
        a * zeta ** (i % 5) * x1 + b * zeta ** ((4 * i) % 5) * x4
        for i in range(5)
    ]
    linear_m = [
        c * zeta ** ((2 * i) % 5) * x2 + d * zeta ** ((3 * i) % 5) * x3
        for i in range(5)
    ]
    q = [sp.expand(linear_l[i] * linear_m[i]) for i in range(5)]
    spectral = reduce_zeta(
        sum(q[i] ** 2 * q[(i + 1) % 5] for i in range(5)), zeta
    )
    coefficient = sp.Poly(
        spectral, x1, x2, x3, x4, domain="EX"
    ).coeff_monomial(x1**3 * x2**2 * x3)
    coefficient = sp.factor(reduce_zeta(coefficient, zeta))
    expected_coefficient = 5 * a**3 * c**2 * d * (
        zeta**3 - zeta**2 - zeta - 1
    )
    assert sp.expand(coefficient - expected_coefficient) == 0

    # The remaining cyclotomic factor has degree below Phi_5 and is nonzero.
    assert reduce_zeta(zeta**3 - zeta**2 - zeta - 1, zeta) != 0

    print("CYCLIC_FACTOR_SPARSE_NORMAL_FORMS_OK")
    print("SPECTRAL_FACTOR_SINGLE_COEFFICIENT_OK")
    print("F55-TRACE-FOUR-TERM-PLANAR-EXCLUSION-AUDIT-OK")


if __name__ == "__main__":
    main()
