#!/usr/bin/env python3
"""Exact remaining noncyclic factor case for a rational rank-two form."""

import sympy as sp


z = sp.symbols("z")
phi5 = z**4 + z**3 + z**2 + z + 1
x1, x2, x3, x4 = sp.symbols("x1 x2 x3 x4")
a, b, c, d = sp.symbols("a b c d")


def reduce_z(expression):
    return sp.Poly(sp.expand(expression), z, domain="EX").rem(
        sp.Poly(phi5, z, domain="EX")
    ).as_expr()


def landing_equations():
    L = [a * z ** (i % 5) * x1 + b * z ** ((4 * i) % 5) * x4 for i in range(5)]
    M = [c * z ** ((2 * i) % 5) * x2 + d * z ** ((3 * i) % 5) * x3 for i in range(5)]
    Q = [sp.expand(L[i] * M[i]) for i in range(5)]
    landing = reduce_z(sum(Q[i] ** 2 * Q[(i + 1) % 5] for i in range(5)))
    polynomial = sp.Poly(sp.expand(landing), x1, x2, x3, x4, domain="EX")
    equations = {}
    for powers, coefficient in polynomial.terms():
        coefficient = sp.factor(reduce_z(coefficient))
        equations[powers] = coefficient
    return equations


def main():
    equations = landing_equations()
    for powers, coefficient in equations.items():
        print("SPECTRAL_RANK2_ROW", powers, coefficient)
    basis = sp.groebner(equations.values(), a, b, c, d, order="grevlex")
    print("SPECTRAL_RANK2_ROWS", len(equations))
    print("SPECTRAL_RANK2_GROEBNER_SIZE", len(basis.polys))
    print("SPECTRAL_RANK2_ZERO_DIMENSIONAL", basis.is_zero_dimensional)
    for polynomial in basis.polys:
        print("G", sp.factor(polynomial.as_expr()))


if __name__ == "__main__":
    main()
