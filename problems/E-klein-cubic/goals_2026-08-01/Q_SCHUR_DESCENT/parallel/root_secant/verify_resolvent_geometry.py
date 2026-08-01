#!/usr/bin/env python3
"""Independent replay for the exact cubic-resolvent noncollinearity witness.

This verifier deliberately does not import the producer.  It reconstructs the
first cubic from the JSON coefficient vector, recomputes all nine residual
intersections, proves smoothness chart by chart over QQ, and checks that the
three pairing residuals span a projective plane rather than a line.
"""

from __future__ import annotations

import itertools
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
DATA = json.loads((HERE / "resolvent_geometry_probe.json").read_text())
x = sp.symbols("x0:4")
u, v = sp.symbols("u v")


def degree_three_monomials_without_cubes():
    terms = []
    for exponents in itertools.product(range(4), repeat=4):
        if sum(exponents) == 3 and max(exponents) < 3:
            terms.append(sp.prod(variable**power for variable, power in zip(x, exponents)))
    return sorted(terms, key=lambda term: sp.Poly(term, *x).monoms()[0])


def value(form, point):
    return sp.expand(form.subs(dict(zip(x, point))))


def residual(form, first, second):
    line = [u * a + v * b for a, b in zip(first, second)]
    restriction = sp.Poly(value(form, line), u, v, domain=sp.QQ)
    assert restriction.coeff_monomial(u**3) == 0
    assert restriction.coeff_monomial(v**3) == 0
    alpha = restriction.coeff_monomial(u**2 * v)
    beta = restriction.coeff_monomial(u * v**2)
    assert (alpha, beta) != (0, 0), "the connecting line is contained in the surface"
    answer = tuple(sp.expand(beta * a - alpha * b) for a, b in zip(first, second))
    assert any(answer) and value(form, answer) == 0
    return answer


def proportional(first, second):
    matrix = sp.Matrix.hstack(sp.Matrix(first), sp.Matrix(second))
    return matrix.rank() == 1


row = DATA["examples"][0]
monomials = degree_three_monomials_without_cubes()
assert len(monomials) == 16
form = sp.expand(sum(sp.Integer(c) * term for c, term in zip(row["coefficients"], monomials)))
vertices = [tuple(sp.Integer(i == j) for i in range(4)) for j in range(4)]
assert all(value(form, point) == 0 for point in vertices)

# Exact projective smoothness: the four standard affine charts cover P^3.
for chart in range(4):
    variables = [x[i] for i in range(4) if i != chart]
    affine_form = sp.expand(form.subs(x[chart], 1))
    jacobian_ideal = [affine_form] + [sp.diff(affine_form, variable) for variable in variables]
    assert sp.groebner(jacobian_ideal, *variables, domain=sp.QQ).contains(sp.Integer(1))

chords = {}
for i, j in itertools.combinations(range(4), 2):
    chords[(i, j)] = residual(form, vertices[i], vertices[j])

partitions = (((0, 1), (2, 3)), ((0, 2), (1, 3)), ((0, 3), (1, 2)))
pairing_residuals = [residual(form, chords[a], chords[b]) for a, b in partitions]
recorded = [tuple(sp.Integer(entry) for entry in point) for point in row["pairing_residuals"]]
assert all(proportional(actual, expected) for actual, expected in zip(pairing_residuals, recorded))
assert sp.Matrix.hstack(*(sp.Matrix(point) for point in pairing_residuals)).rank() == 3
assert row["smooth"] is True and row["pairing_residual_rank"] == 3
assert DATA["headline"] == "OPEN"

print("Q_SCHUR_RESOLVENT_GEOMETRY_INDEPENDENT_REPLAY_OK")
print("smooth cubic surface; three pairing residuals have projective rank 3")
print("BOUNDARY universal shortcut refuted; the Schur twist remains undecided")
