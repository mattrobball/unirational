#!/usr/bin/env python3
"""Exact finite probe of a normalized ten-variable osculating slice.

This is *not* a degree or support sweep.  It starts with the theorem-forced
degree-nine ansatz

    x_i = ell_i q_i,
    q_i = (T-r_(i-1)) H_i,
    deg(H_i) <= 4,

after splitting the cyclic degree-five coefficient algebra.  A degree-four
polynomial H_i is represented by its five values y[i,k]=H_i(r_k).

At r_k we normalize the leading local coefficients of x_k and x_(k-1) to
one.  The J2 equation then forces the leading coefficient of x_(k+1).
This fixes three cyclic diagonals of the 5 by 5 value matrix and leaves only
the ten entries

    d_k = H_(k+2)(r_k), e_k = H_(k+3)(r_k).

The script derives the remaining ten J3/J4 equations exactly and emits an
msolve input after a rational-root specialization.  Any point found is only
a point on this normalized slice; emptiness is scoped to the slice.
"""

from __future__ import annotations

import argparse
from fractions import Fraction
from pathlib import Path

import sympy as sp


def lagrange_interpolate(values, roots, T):
    out = 0
    for k, value in enumerate(values):
        numerator = 1
        denominator = 1
        for j, root in enumerate(roots):
            if j == k:
                continue
            numerator *= T - root
            denominator *= roots[k] - root
        out += value * numerator / denominator
    return sp.Poly(sp.cancel(out), T).as_expr()


def shifted_coefficient(poly, T, root, order):
    return sp.expand(poly).coeff(T, order) if root == 0 else sp.expand(
        sp.diff(poly, T, order).subs(T, root) / sp.factorial(order)
    )


def build_system(roots=None, A_values=None, f_values=None):
    T = sp.Symbol("T")
    if roots is None:
        roots = (
            sp.Rational(2),
            sp.Rational(3),
            sp.Rational(5),
            sp.Rational(7),
            sp.Rational(1, 210),
        )
    roots = tuple(map(sp.Rational, roots))
    assert sp.prod(roots) == 1
    assert len(set(roots)) == 5
    if A_values is None:
        A_values = (1,) * 5
    if f_values is None:
        f_values = (1,) * 5
    A_values = tuple(map(sp.Rational, A_values))
    f_values = tuple(map(sp.Rational, f_values))
    assert len(A_values) == len(f_values) == 5

    d = sp.symbols("d0:5")
    e = sp.symbols("e0:5")
    variables = d + e

    p = sp.prod(T - root for root in roots)
    pprime = [sp.diff(p, T).subs(T, root) for root in roots]

    # y[i][k] = H_i(r_k).  The cases are indexed by i-k modulo five.
    y = [[None for _ in range(5)] for _ in range(5)]
    for k in range(5):
        rk = roots[k]
        delta_m1 = rk - roots[(k - 1) % 5]
        delta_m2 = rk - roots[(k - 2) % 5]
        delta_p1 = rk - roots[(k + 1) % 5]

        # Prescribe A_k=[z^0]x_k and f_k=[z^1]x_(k-1).
        y[k][k] = A_values[k] / (pprime[k] * delta_m1)
        y[(k - 1) % 5][k] = (
            f_values[k] * delta_m1 / (pprime[k] * delta_m2)
        )

        # J2: c_k A_k^2 b_k + c_(k-1) A_k f_k^2=0.
        # Thus b_k=-(c_(k-1)/c_k) f_k^2/A_k.
        b_leading = (
            -roots[(k + 2) % 5]
            * f_values[k] ** 2
            / (roots[(k + 1) % 5] * A_values[k])
        )
        y[(k + 1) % 5][k] = b_leading * delta_p1 / pprime[k]

        y[(k + 2) % 5][k] = d[k]
        y[(k + 3) % 5][k] = e[k]

    H = [lagrange_interpolate(y[i], roots, T) for i in range(5)]
    ell = [sp.cancel(p / (T - roots[i])) for i in range(5)]
    x = [
        sp.expand(ell[i] * (T - roots[(i - 1) % 5]) * H[i])
        for i in range(5)
    ]
    c = [1 / roots[(i + 2) % 5] for i in range(5)]
    S = sp.expand(sum(c[i] * x[i] ** 2 * x[(i + 1) % 5] for i in range(5)))

    equations = []
    checks = []
    for k, root in enumerate(roots):
        coefficients = [
            sp.factor(shifted_coefficient(S, T, root, order))
            for order in range(5)
        ]
        assert coefficients[0] == 0
        assert coefficients[1] == 0  # J1, forced by q=(T-r_4)h.
        assert coefficients[2] == 0  # J2, forced by the normalization above.
        checks.append(coefficients)
        equations.extend(sp.Poly(coefficients[order], *variables, domain=sp.QQ)
                         for order in (3, 4))

    return variables, equations, roots, H, x, S, checks


def polynomial_mod_prime(poly, prime):
    terms = []
    for monomial, coefficient in poly.terms():
        q = Fraction(int(coefficient.p), int(coefficient.q))
        value = (q.numerator * pow(q.denominator, -1, prime)) % prime
        if value:
            terms.append((monomial, value))
    return terms


def term_to_string(monomial, coefficient, names):
    factors = []
    if coefficient != 1 or not any(monomial):
        factors.append(str(coefficient))
    for name, exponent in zip(names, monomial):
        if exponent == 1:
            factors.append(name)
        elif exponent:
            factors.append(f"{name}^{exponent}")
    return "*".join(factors) if factors else "0"


def write_msolve(path, variables, equations, prime):
    names = [str(variable) for variable in variables]
    lines = [",".join(names), str(prime)]
    rendered = []
    for poly in equations:
        terms = polynomial_mod_prime(poly, prime)
        rendered.append("+".join(
            term_to_string(monomial, coefficient, names)
            for monomial, coefficient in terms
        ) or "0")
    lines.append(",\n".join(rendered))
    path.write_text("\n".join(lines) + "\n")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=101)
    parser.add_argument("--msolve-output", type=Path)
    args = parser.parse_args()

    variables, equations, roots, H, x, S, checks = build_system()
    print("roots", roots)
    print("variables", len(variables))
    print("equations", len(equations))
    print("term_counts", [len(poly.terms()) for poly in equations])
    print("degrees", [poly.total_degree() for poly in equations])
    print("J0_J1_J2_zero", all(all(row[j] == 0 for j in range(3))
                                 for row in checks))
    if args.msolve_output:
        write_msolve(args.msolve_output, variables, equations, args.prime)
        print("wrote", args.msolve_output)


if __name__ == "__main__":
    main()
