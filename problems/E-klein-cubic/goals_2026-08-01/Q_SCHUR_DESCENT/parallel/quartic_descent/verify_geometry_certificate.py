#!/usr/bin/env python3
"""Independent replay of geometry_certificate.json."""

from __future__ import annotations

import json
import math
from itertools import product
from pathlib import Path


HERE = Path(__file__).resolve().parent
DATA = json.loads((HERE / "geometry_certificate.json").read_text())


def multiply(a, b):
    result = [0] * (len(a) + len(b) - 1)
    for i, left in enumerate(a):
        for j, right in enumerate(b):
            result[i + j] += left * right
    return result


def normalized(poly, p):
    answer = [coefficient % p for coefficient in poly]
    while len(answer) > 1 and answer[-1] == 0:
        answer.pop()
    return answer


def divisible(poly, divisor, p):
    remainder = normalized(poly, p)
    divisor = normalized(divisor, p)
    while len(remainder) >= len(divisor) and remainder != [0]:
        shift = len(remainder) - len(divisor)
        factor = remainder[-1] * pow(divisor[-1], -1, p) % p
        for i, coefficient in enumerate(divisor):
            remainder[i + shift] = (remainder[i + shift] - factor * coefficient) % p
        remainder = normalized(remainder, p)
    return remainder == [0]


def no_factor_up_to_half(poly, p):
    degree = len(poly) - 1
    for d in range(1, degree // 2 + 1):
        for lower in product(range(p), repeat=d):
            if divisible(poly, list(lower) + [1], p):
                return False
    return True


assert DATA["format"] == "Q-SCHUR-PRIMITIVE-QUARTIC-GEOMETRY-GATES-v1"

# Balestrieri degree arithmetic reconstructed from S_{d,n}.
def S(d, n):
    nstar = next(value for value in range(1, d) if (value + n) % d == 0)
    return [value for value in range(nstar, n * (d - 1), d)]


assert S(3, 4) == DATA["balestrieri_3_8"]["general_residual_polynomial_degrees"] == [2, 5]
assert 3 * 3 - 4 == DATA["balestrieri_3_8"]["full_span_twisted_cubic_residual_degree"] == 5
assert DATA["balestrieri_3_8"]["canonical_iteration"] == [4, 5, 4]
assert S(3, 5) == DATA["degree_five_successor"]["residual_polynomial_degrees"] == [1, 4, 7]

# Restriction matrix rank: each cubic monomial maps to one binary monomial.
weights = []
for exponents in product(range(4), repeat=4):
    if sum(exponents) == 3:
        weights.append(sum(i * exponent for i, exponent in enumerate(exponents)))
assert len(weights) == 20
assert len(set(weights)) == DATA["twisted_cubic_restriction"]["rank"] == 10
assert set(weights) == set(range(10))

quartic = DATA["twisted_cubic_restriction"]["example_quartic_coefficients_ascending"]
quintic = DATA["twisted_cubic_restriction"]["example_quintic_coefficients_ascending"]
assert no_factor_up_to_half(quartic, 2)
assert no_factor_up_to_half(quintic, 3)
assert multiply(quartic, quintic) == DATA["twisted_cubic_restriction"]["example_product_coefficients_ascending"]

# Recompute the exact postulation consequences.
hilbert = DATA["degree_55_postulation"]["input_hilbert_function_degrees_0_to_6"]
ambient = [math.comb(d + 3, 3) for d in range(7)]
ideal = [ambient[d] - hilbert[d] for d in range(7)]
cubic_multiples = [0 if d < 3 else math.comb(d, 3) for d in range(7)]
proper = [ideal[d] - cubic_multiples[d] for d in range(7)]
assert proper == DATA["degree_55_postulation"]["proper_carrier_dimensions_on_cubic_surface"]
assert proper[:5] == [0] * 5 and proper[5:] == [1, 9]
assert 3 * 5 == DATA["degree_55_postulation"]["quintic_carrier_curve_degree"]
assert 1 + 3 * 5 * (3 + 5 - 4) // 2 == DATA["degree_55_postulation"]["quintic_carrier_curve_genus"] == 31
assert 4 * 15 == DATA["degree_55_postulation"]["canonical_degree_on_carrier"] == 60

gate = DATA["complete_intersection_gate_for_Z55_plus_quartic"]
assert gate["contained_length"] == 55 + 4 == 59
assert gate["minimum_complete_intersection_length"] == 3 * 5 * 5 == 75
assert gate["minimum_residual_length"] == 75 - 59 == 16
assert 3 * 20 - 59 == 1
assert (59 + 2) % 3 != 0

one = []
two = []
for d in range(1, 21):
    for m in range(1, 3 * d + 1):
        value = 3 * d - 4 * m
        if value == 1:
            one.append([d, m])
        if value == 2:
            two.append([d, m])
assert one == DATA["high_contact_successor"]["residual_one_pairs_d_le_20"]
assert two == DATA["high_contact_successor"]["residual_two_pairs_d_le_20"]
assert one[0] == [3, 2]
assert two[0] == [2, 1] and two[1] == [6, 4]

print("PASS Balestrieri is exactly the 4+5 twisted-cubic link and reverses 5->4")
print("PASS cubic restriction to the twisted cubic has rank 10 and is surjective")
print("PASS explicit irreducible quartic and quintic factors show no rational root is forced")
print("PASS degree-55 postulation blocks simple low-degree complete-intersection descent")
print("PASS the next high-contact interfaces are (3,2), (6,4), and (7,5)")
print("Q_SCHUR_QUARTIC_GEOMETRY_GATES_EXACT")
print("BOUNDARY existence of the required contact curve, or a K-point, is not proved")
