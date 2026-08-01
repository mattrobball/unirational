#!/usr/bin/env python3
"""Independent verifier for the plane-cubic/dP3 link payload."""

from __future__ import annotations

import json
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
PAYLOAD = json.loads((HERE / "intersection_payload.json").read_text())

# Minimal literal formulas needed for the center.  These are deliberately not
# imported from produce.py or phi_coefficients.py.
C0 = {
    (0, 0, 0, 4, 0): 1,
    (0, 1, 1, 0, 2): 4,
    (1, 0, 0, 2, 1): 4,
    (1, 2, 1, 0, 0): 8,
    (2, 0, 0, 0, 2): 6,
    (3, 1, 0, 0, 0): 4,
}
D0 = {
    (0, 0, 2, 0, 3): -5,
    (0, 1, 0, 3, 1): -5,
    (0, 3, 1, 1, 0): 5,
    (0, 5, 0, 0, 0): -1,
    (1, 1, 0, 1, 2): 10,
    (1, 1, 2, 0, 1): -5,
    (2, 0, 1, 2, 0): -5,
    (2, 2, 0, 1, 0): -5,
    (3, 0, 1, 0, 1): 5,
}


def shift(exponents, amount):
    return tuple(exponents[(index - amount) % 5] for index in range(5))


def cyclic(first):
    return [
        {shift(exponents, index): coefficient for exponents, coefficient in first.items()}
        for index in range(5)
    ]


def evaluate(polynomial, point):
    total = 0
    for exponents, coefficient in polynomial.items():
        term = coefficient
        for value, exponent in zip(point, exponents):
            term *= value**exponent
        total += term
    return total


def klein(vector):
    return sum(vector[i] ** 2 * vector[(i + 1) % 5] for i in range(5))


def triple(a, b, c, ring):
    result = 0
    for choose_e in range(8):
        coefficient = 1
        e_count = 0
        for index, pair in enumerate((a, b, c)):
            use_e = (choose_e >> index) & 1
            coefficient *= pair[use_e]
            e_count += use_e
        result += coefficient * ring[e_count]
    return result


def main():
    assert PAYLOAD["schema"] == "m-sarkisov-plane-cubic-dp3-v1"
    point = tuple(PAYLOAD["witness"]["point"])
    x_vector = [
        {tuple(1 if j == i else 0 for j in range(5)): 1}
        for i in range(5)
    ]
    frame = (x_vector, cyclic(C0), cyclic(D0))
    columns = [[evaluate(component, point) for component in vector] for vector in frame]
    assert columns == PAYLOAD["witness"]["frame_columns"][:3]

    variables = sp.symbols("a0:3")
    image = [sum(variables[j] * columns[j][i] for j in range(3)) for i in range(5)]
    polynomial = sp.Poly(sp.expand(klein(image)), *variables)
    observed_terms = [
        {"exponents": list(monomial), "coefficient": int(coefficient)}
        for monomial, coefficient in polynomial.terms()
    ]
    assert observed_terms == PAYLOAD["center"]["plane_cubic_terms"]

    gradient = [sp.diff(polynomial.as_expr(), variable) for variable in variables]
    for chart in range(3):
        remaining = tuple(variable for i, variable in enumerate(variables) if i != chart)
        equations = [derivative.subs(variables[chart], 1) for derivative in gradient]
        basis = sp.groebner(equations, *remaining, order="grevlex", domain=sp.QQ)
        assert basis.contains(sp.Integer(1)), (chart, basis)

    data = PAYLOAD["intersection_ring"]
    ring = (data["H3"], data["H2E"], data["HE2"], data["E3"])
    minus_k = tuple(data["minus_K"])
    fibre = tuple(data["fibre_L"])
    h = (1, 0)
    e = (0, 1)
    assert ring == (3, 0, -3, -6)
    assert triple(minus_k, minus_k, minus_k, ring) == data["minus_K_cube"] == 12
    assert triple(fibre, fibre, h, ring) == data["L2H"] == 0
    assert triple(fibre, fibre, e, ring) == data["L2E"] == 0
    assert triple(fibre, fibre, fibre, ring) == data["L3"] == 0

    for curve in PAYLOAD["curve_intersections"].values():
        assert curve["L"] == curve["H"] - curve["E"]
        assert curve["minus_K"] == 2 * curve["H"] - curve["E"]
        assert curve["minus_K"] > 0

    print("PASS literal x,C,D formulas reproduce the certified plane cubic")
    print("PASS gradient ideals are the unit ideal in all three projective charts")
    print("PASS blowup intersections, fibre identities, and ray pairings")


if __name__ == "__main__":
    main()
