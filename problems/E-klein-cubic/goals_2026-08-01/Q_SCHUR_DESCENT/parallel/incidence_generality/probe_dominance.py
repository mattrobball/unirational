#!/usr/bin/env python3
"""Exact differential certificate for the quartic-to-resolvent map.

The script checks one rational quartet on the split Klein cubic and measures
the differential ranks of

    X^4 --> X^3,              P |--> (R_01|23,R_02|13,R_03|12),
    X^4 --> I,                P |--> (span(P),R_01|23,...),

where I parametrizes a hyperplane and three points in its cubic-surface
section.  All calculations use exact rational arithmetic.
"""

from __future__ import annotations

import itertools
import sympy as sp


N = 5
X = sp.symbols("x0:5")
F = sum(X[i] ** 2 * X[(i + 1) % N] for i in range(N))
GRAD = [sp.diff(F, x) for x in X]
EPS = sp.symbols("eps")


def evaluate(poly, point):
    return sp.expand(poly.subs(dict(zip(X, point))))


def third(left, right):
    a = sum(evaluate(g, left) * right[i] for i, g in enumerate(GRAD))
    b = sum(evaluate(g, right) * left[i] for i, g in enumerate(GRAD))
    out = tuple(sp.expand(b * left[i] - a * right[i]) for i in range(N))
    if not any(out):
        raise ValueError("contained or degenerate chord")
    return out


PAIRINGS = (((0, 1), (2, 3)), ((0, 2), (1, 3)), ((0, 3), (1, 2)))


def resolvents(points):
    chords = {}
    for i, j in itertools.combinations(range(4), 2):
        chords[(i, j)] = third(points[i], points[j])
    return tuple(third(chords[a], chords[b]) for a, b in PAIRINGS)


def tangent_basis(point, hyperplane=None):
    rows = [[evaluate(g, point) for g in GRAD]]
    if hyperplane is not None:
        rows.append(list(hyperplane))
    kernel = sp.Matrix(rows).nullspace()
    p = sp.Matrix(point)
    basis = []
    running = sp.Matrix.hstack(p)
    for vector in kernel:
        candidate = sp.Matrix.hstack(running, vector)
        if candidate.rank() > running.rank():
            basis.append(tuple(vector))
            running = candidate
    expected = 2 if hyperplane is not None else 3
    assert len(basis) == expected, (point, hyperplane, basis)
    return basis


def normalize_derivative(value, derivative):
    chart = next(i for i, entry in enumerate(value) if entry != 0)
    denominator = value[chart] ** 2
    return tuple(
        sp.cancel((derivative[i] * value[chart] - value[i] * derivative[chart]) / denominator)
        for i in range(N)
        if i != chart
    )


def hyperplane(points):
    matrix = sp.Matrix(points)
    kernel = matrix.nullspace()
    if len(kernel) != 1:
        raise ValueError("quartet is not full-span")
    return tuple(kernel[0])


def outputs_with_span(points):
    h = hyperplane(points)
    return (h,) + resolvents(points)


def directional_derivative(function, points, point_index, direction):
    deformed = [tuple(p) for p in points]
    deformed[point_index] = tuple(
        points[point_index][i] + EPS * direction[i] for i in range(N)
    )
    outputs = function(tuple(deformed))
    result = []
    for output in outputs:
        result.append(tuple(sp.diff(entry, EPS).subs(EPS, 0) for entry in output))
    return tuple(result)


def differential_rank(points, include_span=False, fixed_hyperplane=False):
    function = outputs_with_span if include_span else resolvents
    base_outputs = function(points)
    h = hyperplane(points) if fixed_hyperplane else None
    columns = []
    for point_index, point in enumerate(points):
        for direction in tangent_basis(point, hyperplane=h):
            derivative = directional_derivative(function, points, point_index, direction)
            local = []
            for value, velocity in zip(base_outputs, derivative):
                local.extend(normalize_derivative(value, velocity))
            columns.append(sp.Matrix(local))
    return sp.Matrix.hstack(*columns).rank()


def smooth_section(h):
    pivot = next(i for i, entry in enumerate(h) if entry)
    solved = -sum(h[i] * X[i] for i in range(N) if i != pivot) / h[pivot]
    variables = [X[i] for i in range(N) if i != pivot]
    section = sp.expand(F.subs(X[pivot], solved))
    for chart, chart_variable in enumerate(variables):
        affine_variables = [v for v in variables if v != chart_variable]
        affine = sp.expand(section.subs(chart_variable, 1))
        ideal = [affine] + [sp.diff(affine, v) for v in affine_variables]
        basis = sp.groebner(ideal, *affine_variables, domain=sp.QQ)
        if not basis.contains(sp.Integer(1)):
            return False
    return True


def main():
    quartet = tuple(
        tuple(sp.Integer(value) for value in point)
        for point in (
            (2, 0, -1, -1, -1),
            (1, -2, 1, -2, 0),
            (2, -1, 2, 0, 1),
            (0, 1, 0, 0, 1),
        )
    )
    assert all(evaluate(F, point) == 0 for point in quartet)
    h = hyperplane(quartet)
    assert h == (
        sp.Rational(1, 6), -1, sp.Rational(-7, 6), sp.Rational(1, 2), 1
    )
    assert smooth_section(h)
    rs = resolvents(quartet)
    assert all(evaluate(F, point) == 0 for point in rs)
    rank_res = differential_rank(quartet)
    rank_joint = differential_rank(quartet, include_span=True)
    rank_fixed = differential_rank(quartet, fixed_hyperplane=True)
    assert (rank_res, rank_joint, rank_fixed) == (9, 10, 6)
    print("hyperplane=", h)
    print("section_smooth=True")
    print("differential_ranks=resolvent:9 joint:10 fixed_section:6")
    print("Q_SCHUR_RESOLVENT_DOMINANCE_EXACT")
    print("BOUNDARY generic quartets are good; Voisin does not select a generic quartic")


if __name__ == "__main__":
    main()
