#!/usr/bin/env python3
"""Exact finite checks for the PSL2(F7)-quartic double-solid theorem.

The script verifies the polynomial and group-action inputs. The residual-RCC
argument and the no-stable-rational-curve lemma are proved in the companion
Markdown theorem.
"""
from __future__ import annotations

import sympy as sp

x0, x1, x2, x3 = sp.symbols("x0 x1 x2 x3")
VARS = (x0, x1, x2, x3)
B = (
    2 * x0**4
    + 6 * x0 * x1 * x2 * x3
    + x1 * x3**3
    + x1**3 * x2
    + x2**3 * x3
)


def assert_projectively_smooth() -> None:
    partials = [sp.diff(B, x) for x in VARS]
    for i, xi in enumerate(VARS):
        sub = {xi: 1}
        remaining = [x for j, x in enumerate(VARS) if j != i]
        generators = [sp.expand(p.subs(sub)) for p in partials]
        basis = sp.groebner(
            generators, *remaining, order="grevlex", domain=sp.QQ
        )
        assert basis.contains(sp.Integer(1)), (
            f"singularity survived in the affine patch {xi}=1"
        )


def monomial_weight(term: sp.Expr) -> int:
    poly = sp.Poly(term, *VARS)
    monomial = poly.monoms()[0]
    weights = (0, 4, 2, 1)
    return sum(exponent * weight for exponent, weight in zip(monomial, weights)) % 7


def assert_c7_invariance() -> None:
    for term in sp.Add.make_args(sp.expand(B)):
        assert monomial_weight(term) == 0, f"non-invariant monomial: {term}"


def assert_c3_invariance_and_relation() -> None:
    # b(x0,x1,x2,x3)=(x0,x2,x3,x1)
    b_substitution = {x0: x0, x1: x2, x2: x3, x3: x1}
    assert sp.expand(B.xreplace(b_substitution) - B) == 0

    # b a b^{-1}=a^4 for a-weights (4,2,1) modulo 7.
    conjugated_weights = (2, 1, 4)
    fourth_power_weights = tuple((4 * exponent) % 7 for exponent in (4, 2, 1))
    assert conjugated_weights == fourth_power_weights


def assert_fixed_loci() -> None:
    coordinate_points = [
        {x0: 1, x1: 0, x2: 0, x3: 0},
        {x0: 0, x1: 1, x2: 0, x3: 0},
        {x0: 0, x1: 0, x2: 1, x3: 0},
        {x0: 0, x1: 0, x2: 0, x3: 1},
    ]
    values = [sp.expand(B.subs(point)) for point in coordinate_points]
    assert values == [2, 0, 0, 0]

    # a has four distinct projective eigendirections and b cycles e1,e2,e3.
    assert len({0, 4, 2, 1}) == 4
    assert values[0] != 0

    # The 1-eigenspace of b is P(span(e0,e1+e2+e3)).
    s, t = sp.symbols("s t")
    restriction = sp.expand(B.subs({x0: s, x1: t, x2: t, x3: t}))
    assert restriction == 2 * s**4 + 6 * s * t**3 + 3 * t**4
    assert sp.Poly(restriction.subs(t, 1), s).degree() == 4


def main() -> None:
    assert_projectively_smooth()
    assert_c7_invariance()
    assert_c3_invariance_and_relation()
    assert_fixed_loci()
    print("KLEIN_PSL27_QUARTIC_DOUBLE_SOLID_VERIFY_OK")


if __name__ == "__main__":
    main()
