#!/usr/bin/env python3
"""Exact coefficient-space infinity contact ledger for target H and Delta."""
from __future__ import annotations

import json
from collections import defaultdict
from fractions import Fraction
from math import comb
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
H_PATH = PROBLEM / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
D_PATH = HERE / "fixed_frame_discriminant_T.tsv"

A, B, Y, T, L, c = sp.symbols("A B Y T L c")

# Exact polynomial change Z=T+11*A^2/18.
h = defaultdict(Fraction)
with H_PATH.open() as stream:
    next(stream)
    for line in stream:
        a, b, y, z, coefficient = map(int, line.split())
        for j in range(z + 1):
            h[(a + 2 * (z - j), b, y, j)] += (
                Fraction(coefficient) * comb(z, j) * Fraction(11, 18) ** (z - j)
            )
h = {monomial: coefficient for monomial, coefficient in h.items() if coefficient}
h_degree = max(sum(monomial) for monomial in h)
assert h_degree == 39

d = {}
with D_PATH.open() as stream:
    next(stream)
    for line in stream:
        a, b, y, t, coefficient = map(int, line.split())
        d[(a, b, y, t)] = coefficient
d_degree = max(sum(monomial) for monomial in d)
assert d_degree == 11


def expr_from(terms):
    return sum(
        sp.Rational(value.numerator, value.denominator)
        * A**monomial[0]
        * B**monomial[1]
        * Y**monomial[2]
        * T**monomial[3]
        for monomial, value in terms.items()
    )


h_top = {
    monomial: value for monomial, value in h.items() if sum(monomial) == h_degree
}
d_top = {
    monomial: Fraction(value)
    for monomial, value in d.items()
    if sum(monomial) == d_degree
}
h_top_expr = expr_from(h_top)
d_top_expr = expr_from(d_top)
h_unit, h_factors = sp.factor_list(h_top_expr)
d_unit, d_factors = sp.factor_list(d_top_expr)

h_summary = [(str(factor), int(exponent)) for factor, exponent in h_factors]
d_summary = [(str(factor), int(exponent)) for factor, exponent in d_factors]
assert [(sp.Poly(f, A, B, Y, T).total_degree(), e) for f, e in h_factors] == [
    (1, 28), (1, 2), (1, 6), (3, 1)
]
assert [(sp.Poly(f, A, B, Y, T).total_degree(), e) for f, e in d_factors] == [
    (1, 4), (1, 3), (4, 1)
]
top_gcd = sp.gcd(sp.Poly(h_top_expr, A, B, Y, T), sp.Poly(d_top_expr, A, B, Y, T))
top_gcd_monic = top_gcd.monic().as_expr()
assert top_gcd_monic == A**4

# Newton polygon at the only common boundary support E_A=(L=A=0).
pairs = {(monomial[0], h_degree - sum(monomial)) for monomial in h}
min_l = {
    a: min(ll for aa, ll in pairs if aa == a)
    for a in sorted({a for a, _ in pairs})
}
points = sorted(min_l.items())


def cross(o, p, q):
    return (p[0] - o[0]) * (q[1] - o[1]) - (p[1] - o[1]) * (q[0] - o[0])


lower = []
for point in points:
    while len(lower) >= 2 and cross(lower[-2], lower[-1], point) <= 0:
        lower.pop()
    lower.append(point)
assert lower[:3] == [(0, 11), (10, 6), (28, 0)]
order_h_at_a_zero = min(
    h_degree - sum(monomial)
    for monomial, coefficient in h.items()
    if monomial[0] == 0 and coefficient
)
assert order_h_at_a_zero == 11


def h_edge(weight_l: int, value: int):
    answer = 0
    for (a, b, y, t), coefficient in h.items():
        ll = h_degree - (a + b + y + t)
        if a + weight_l * ll == value:
            answer += (
                sp.Rational(coefficient.numerator, coefficient.denominator)
                * c**a * B**b * Y**y * T**t
            )
    return sp.expand(answer)


edge2 = h_edge(2, 22)
edge3 = h_edge(3, 28)
edge2_unit, edge2_factors = sp.factor_list(edge2)
edge3_unit, edge3_factors = sp.factor_list(edge3)


def d_initial(weight_l: int):
    weighted = []
    for (a, b, y, t), coefficient in d.items():
        ll = d_degree - (a + b + y + t)
        weighted.append((a + weight_l * ll, a, b, y, t, coefficient))
    minimum = min(row[0] for row in weighted)
    expression = sum(
        coefficient * c**a * B**b * Y**y * T**t
        for value, a, b, y, t, coefficient in weighted
        if value == minimum
    )
    return minimum, sp.expand(expression)


m2, d_init2 = d_initial(2)
m3, d_init3 = d_initial(3)
assert m2 == m3 == 4
assert sp.factor(d_init2) == 2985984 * Y**7 * (c**2 + 4 * Y) ** 2

frac = sp.QQ.frac_field(B, Y, T)
edge2_poly = sp.Poly(edge2, c, domain=frac)
d2_poly = sp.Poly(d_init2, c, domain=frac)
assert sp.gcd(edge2_poly, d2_poly).degree() == 0
# On the slope -1/3 branches c is nonzero; d_init3 is a nonzero scalar times c^4*Y^7.
assert sp.Poly(d_init3, c, domain=frac).degree() == 4

payload = {
    "schema": "t3-fixed-frame-boundary-contact-v1",
    "compactification": "coefficient-space P4 with coordinates [L:A:B:Y:T]",
    "target_degree": 39,
    "discriminant_residual_degree": 11,
    "target_top_factors": h_summary,
    "discriminant_top_factors": d_summary,
    "top_gcd": "A^4",
    "only_common_boundary_support": "E_A=(L=A=0)",
    "newton_vertices": [[0, 11], [10, 6], [28, 0]],
    "slopes": ["-1/2", "-1/3"],
    "edge_weight_2_factors": [(str(factor), int(exponent)) for factor, exponent in edge2_factors],
    "edge_weight_2_D_initial": str(sp.factor(d_init2)),
    "edge_weight_2_gcd_degree": 0,
    "edge_weight_3_factors": [(str(factor), int(exponent)) for factor, exponent in edge3_factors],
    "edge_weight_3_D_initial": str(sp.factor(d_init3)),
    "normalization_contact_orders": [
        {"ramification_index_of_L": 2, "v_A": 1, "v_Delta": 4, "mod_3": 1},
        {"ramification_index_of_L": 3, "v_A": 1, "v_Delta": 4, "mod_3": 1},
    ],
    "intersection_cycle_check": {
        "ord_L_H_at_A_zero": order_h_at_a_zero,
        "Delta_is_A4_times_a_unit_on_every_normalized_edge_branch": True,
        "ambient_complete_intersection_multiplicity_at_E_A": 4 * order_h_at_a_zero,
        "explanation": "i_E(H,Delta)=4*i_E(H,A)=4*ord_L(H(L,0))=44; this cycle multiplicity is not the per-normalization-branch valuation, which is 4",
    },
    "conclusion": "every normalized branch above the sole boundary support has contact 4; no boundary 3-primary contact",
}
(HERE / "boundary_contact_payload.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
print("T3_BOUNDARY_CONTACTS_PRODUCED")
