#!/usr/bin/env python3
"""Exact probes for the quartic-to-cubic-resolvent secant construction.

This is a discovery/audit script, not a headline certificate.  It builds
deterministic cubic surfaces through the four coordinate vertices, performs
the six chord residuals and the three pairing residuals over QQ, and tests
whether the latter are forced to be collinear.  A single smooth counterexample
with rank three refutes that universal degree-lowering shortcut.
"""

from __future__ import annotations

import itertools
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
X = sp.symbols("x0:4")
U, V = sp.symbols("u v")


def monomials_degree_three():
    result = []
    for exponents in itertools.product(range(4), repeat=4):
        if sum(exponents) != 3 or 3 in exponents:
            continue
        monomial = sp.Integer(1)
        for variable, exponent in zip(X, exponents):
            monomial *= variable**exponent
        result.append((exponents, monomial))
    return sorted(result)


MONOMIALS = monomials_degree_three()
assert len(MONOMIALS) == 16


def evaluate(form, point):
    return sp.expand(form.subs(dict(zip(X, point))))


def third_point(form, left, right):
    pullback = sp.Poly(
        sp.expand(evaluate(form, [U * a + V * b for a, b in zip(left, right)])),
        U,
        V,
    )
    assert pullback.coeff_monomial(U**3) == 0
    assert pullback.coeff_monomial(V**3) == 0
    a = pullback.coeff_monomial(U**2 * V)
    b = pullback.coeff_monomial(U * V**2)
    assert a != 0 or b != 0
    point = tuple(sp.expand(b * p - a * q) for p, q in zip(left, right))
    assert any(point)
    assert evaluate(form, point) == 0
    return point


def projective_rank(points):
    return int(sp.Matrix.hstack(*(sp.Matrix(point) for point in points)).rank())


def smooth_affine_chart(form, chart):
    variables = [X[index] for index in range(4) if index != chart]
    specialized = sp.expand(form.subs(X[chart], 1))
    ideal = [specialized] + [sp.diff(specialized, variable) for variable in variables]
    basis = sp.groebner(ideal, *variables, domain=sp.QQ)
    return basis.contains(sp.Integer(1))


def one_example(seed):
    coefficients = [((seed + 3) * (index + 5) ** 2 + 7 * index + 1) % 29 - 14
                    for index in range(len(MONOMIALS))]
    coefficients = [value if value else index + 1 for index, value in enumerate(coefficients)]
    form = sp.expand(sum(coefficient * monomial for coefficient, (_, monomial)
                         in zip(coefficients, MONOMIALS)))
    vertices = [tuple(sp.Integer(index == j) for index in range(4)) for j in range(4)]
    assert all(evaluate(form, point) == 0 for point in vertices)

    chords = {}
    for left, right in itertools.combinations(range(4), 2):
        chords[(left, right)] = third_point(form, vertices[left], vertices[right])

    pairings = (((0, 1), (2, 3)), ((0, 2), (1, 3)), ((0, 3), (1, 2)))
    residuals = [third_point(form, chords[first], chords[second])
                 for first, second in pairings]
    return {
        "seed": seed,
        "coefficients": coefficients,
        "smooth": all(smooth_affine_chart(form, chart) for chart in range(4)),
        "pairing_residual_rank": projective_rank(residuals),
        "pairing_residuals": [[str(value) for value in point] for point in residuals],
    }


def main():
    rows = [one_example(seed) for seed in range(1, 6)]
    assert any(row["smooth"] and row["pairing_residual_rank"] == 3 for row in rows)
    payload = {
        "schema": "q-schur-cubic-resolvent-probe-v1",
        "examples": rows,
        "conclusion": (
            "pairing residuals are not universally collinear; the cubic-resolvent "
            "cycle does not automatically become a line section"
        ),
        "headline": "OPEN",
    }
    (HERE / "resolvent_geometry_probe.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    for row in rows:
        print(
            f"seed={row['seed']} smooth={row['smooth']} "
            f"pairingResidualRank={row['pairing_residual_rank']}"
        )
    print("Q_SCHUR_RESOLVENT_NONCOLLINEAR_COUNTEREXAMPLE_EXACT")
    print("BOUNDARY this refutes a shortcut and does not decide the Schur quartic")


if __name__ == "__main__":
    main()
