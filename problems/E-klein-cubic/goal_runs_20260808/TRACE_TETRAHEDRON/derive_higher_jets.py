#!/usr/bin/env python3
"""Small symbolic derivation of the untwisted degree-4 and degree-5 jets.

The analytic reduction v in V1+V4 is imposed before expansion.  The conjugate
branch v in V2+V3 is obtained by Galois symmetry.  This script is a formula
deriver, not a support or collision search.
"""

import sympy as sp


z = sp.symbols("z")
phi5 = z**4 + z**3 + z**2 + z + 1
x = {q: sp.symbols(f"x{q}") for q in range(1, 5)}
va, vb = sp.symbols("a b", nonzero=True)
v = {1: va, 4: vb}

qvars = {
    (i, j): sp.symbols(f"q{i}{j}")
    for i in range(1, 5)
    for j in range(i, 5)
}
rvars = {
    (i, j, k): sp.symbols(f"r{i}{j}{k}")
    for i in range(1, 5)
    for j in range(i, 5)
    for k in range(j, 5)
}


def reduce_z(expr):
    return sp.Poly(sp.expand(expr), z, domain="EX").rem(
        sp.Poly(phi5, z, domain="EX")
    ).as_expr()


def shift_factor(weight, i):
    return z ** ((weight * i) % 5)


def linear(i):
    return sum(v[q] * shift_factor(q, i) * x[q] for q in v)


def quadratic(i):
    return sum(
        symbol * shift_factor((p + q) % 5, i) * x[p] * x[q]
        for (p, q), symbol in qvars.items()
    )


def cubic(i):
    return sum(
        symbol * shift_factor((p + q + r) % 5, i) * x[p] * x[q] * x[r]
        for (p, q, r), symbol in rvars.items()
    )


def x_coefficients(expr, degree):
    reduced = sp.expand(reduce_z(expr))
    poly = sp.Poly(reduced, *(x[q] for q in range(1, 5)), domain="EX")
    answer = {}
    for powers, coefficient in poly.terms():
        if sum(powers) == degree and coefficient != 0:
            answer[powers] = sp.factor(reduce_z(coefficient))
    return answer


def main():
    L = [linear(i) for i in range(5)]
    Q = [quadratic(i) for i in range(5)]
    R = [cubic(i) for i in range(5)]

    jet4 = sum(
        L[i] * Q[i] * L[(i + 1) % 5]
        + sp.Rational(1, 2) * L[i] ** 2 * Q[(i + 1) % 5]
        for i in range(5)
    )
    equations4 = x_coefficients(jet4, 4)

    jet5 = sum(
        sp.Rational(1, 3) * L[i] * R[i] * L[(i + 1) % 5]
        + sp.Rational(1, 4) * Q[i] ** 2 * L[(i + 1) % 5]
        + sp.Rational(1, 2) * L[i] * Q[i] * Q[(i + 1) % 5]
        + sp.Rational(1, 6) * L[i] ** 2 * R[(i + 1) % 5]
        for i in range(5)
    )
    equations5 = x_coefficients(jet5, 5)

    print("DEGREE4_EQUATION_COUNT", len(equations4))
    for powers, equation in sorted(equations4.items()):
        print("J4", powers, equation)
    print("DEGREE5_EQUATION_COUNT", len(equations5))
    for powers, equation in sorted(equations5.items()):
        print("J5", powers, equation)


if __name__ == "__main__":
    main()
