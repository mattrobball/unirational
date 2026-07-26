#!/usr/bin/env python3
"""Exact specialization diagnostics for the ten three-column frame planes.

This does *not* test rationality over C(W)^G.  It is used only to rule out
identities such as a generically singular or generically reducible section:
one smooth absolutely irreducible specialization is enough for those scoped
purposes.  All arithmetic in this file is over QQ.
"""

from itertools import combinations
import math
import sympy as sp


KPARAMS = [
    (0,0,0,6,1),(0,0,1,0,6),(0,0,2,5,0),(0,1,1,2,3),
    (0,1,3,1,2),(0,1,5,0,1),(0,2,1,4,0),(0,3,0,1,3),
    (0,3,2,0,2),(0,4,0,3,0),(1,0,0,4,2),(1,0,2,3,1),
    (1,0,4,2,0),(1,1,1,0,4),(1,2,1,2,1),(1,2,3,1,0),
    (1,4,0,1,1),(1,4,2,0,0),(2,0,0,2,3),(2,0,2,1,2),
    (2,0,4,0,1),(2,1,0,4,0),(2,2,1,0,2),(3,0,0,0,4),
    (3,1,0,2,1),(3,1,2,1,0),(3,3,1,0,0),(4,1,0,0,2),
    (5,0,1,1,0),(5,2,0,0,0),
]
KCO = [
    0,-1,-1,-4,0,-2,-1,-4,2,-1,0,0,3,-16,28,0,-18,0,
    -6,22,-11,-10,16,3,20,12,-8,-9,-12,4,
]
D0 = {
    (0,0,2,0,3):-5,(0,1,0,3,1):-5,(0,3,1,1,0):5,
    (0,5,0,0,0):-1,(1,1,0,1,2):10,(1,1,2,0,1):-5,
    (2,0,1,2,0):-5,(2,2,0,1,0):-5,(3,0,1,0,1):5,
}
EPARAMS = [
    (0,0,1,3,2),(0,0,3,2,1),(0,0,5,1,0),(0,1,0,0,5),
    (0,2,0,2,2),(0,2,2,1,1),(0,2,4,0,0),(0,4,1,0,1),
    (1,0,1,1,3),(1,0,3,0,2),(1,1,1,3,0),(1,2,0,0,3),
    (1,3,0,2,0),(2,1,1,1,1),(2,1,3,0,0),(2,3,0,0,1),
    (3,0,0,3,0),(4,0,0,1,1),(4,0,2,0,0),
]
ECO = [-2,1,0,1,3,3,-1,-1,0,0,4,2,1,0,3,-3,-1,-1,0]


def monomial(x, e):
    return math.prod(x[i] ** e[i] for i in range(5))


def cyclic_covariant(x, terms):
    # ``zip`` is a one-shot iterator; all five cyclic components need the
    # same coefficient table.
    terms = tuple(terms)
    def p0(y):
        return sum(c * monomial(y, e) for e, c in terms)
    return [p0(tuple(x[(j + i) % 5] for j in range(5))) for i in range(5)]


def klein(x):
    return sum(x[i] ** 2 * x[(i + 1) % 5] for i in range(5))


def cov_c(x):
    q = [2*x[i]*x[(i+1) % 5] + x[(i-1) % 5]**2 for i in range(5)]
    return [2*q[i]*q[(i+1) % 5] + q[(i-1) % 5]**2 for i in range(5)]


def cov_d(x):
    return cyclic_covariant(x, D0.items())


def cov_e(x):
    return cyclic_covariant(x, zip(EPARAMS, ECO))


def cov_k(x):
    return cyclic_covariant(x, zip(KPARAMS, KCO))


def plane_cubic(columns):
    a, b, c = sp.symbols("a b c")
    y = [a*columns[0][i] + b*columns[1][i] + c*columns[2][i]
         for i in range(5)]
    return sp.Poly(sp.expand(klein(y)), a, b, c, domain=sp.QQ)


def projectively_smooth(poly):
    """Check the three standard affine charts by exact Groebner bases."""
    a, b, c = poly.gens
    f = poly.as_expr()
    derivs = [sp.diff(f, v) for v in (a, b, c)]
    for v in (a, b, c):
        others = tuple(w for w in (a, b, c) if w != v)
        eqs = [g.subs(v, 1) for g in (f, *derivs)]
        gb = sp.groebner(eqs, *others, order="grevlex", domain=sp.QQ)
        if not gb.contains(sp.Integer(1)):
            return False
    return True


def main():
    # This point gives a nonzero frame determinant (-4400) with the corrected
    # reusable E/K coefficient tables.
    x = (-1, -1, -1, -1, 0)
    named = {
        "x": x,
        "C": cov_c(x),
        "D": cov_d(x),
        "E": cov_e(x),
        "K": cov_k(x),
    }
    determinant = sp.Matrix.hstack(
        *(sp.Matrix(named[name]) for name in named)
    ).det()
    assert determinant == -4400
    print("source", x, "frame_determinant", determinant)
    for triple in combinations(named, 3):
        poly = plane_cubic([named[t] for t in triple])
        coeffs = poly.terms()
        factors = sp.factor_list(poly.as_expr())
        smooth = projectively_smooth(poly)
        factor_degrees = [
            (sp.Poly(q, *poly.gens).total_degree(), exponent)
            for q, exponent in factors[1]
        ]
        assert len(coeffs) == 10
        assert smooth
        assert factor_degrees == [(3, 1)]
        print("".join(triple), "terms", len(coeffs), "smooth", smooth,
              "factor_degrees", factor_degrees)
        print(" ", poly.as_expr())


if __name__ == "__main__":
    main()
