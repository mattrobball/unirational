#!/usr/bin/env python3
"""Find exact one-parameter Newton certificates for binary Kummer cubics."""

from __future__ import annotations

from itertools import product
from math import gcd
from math import comb

from factor_binary_kummer_singular import trace


def order_at(coefficients, center):
    if center is None:
        return -max(coefficients)
    for order in range(max(coefficients)+1):
        value = trace.ZERO
        for power, coefficient in coefficients.items():
            if power >= order:
                value += coefficient * comb(power, order) * center**(power-order)
        if value:
            return order
    return None


def specialized_valuations(parts, retained: int, constants: tuple[int, int, int], center=0):
    assignments = {}
    cursor = 0
    for index in range(4):
        if index != retained:
            assignments[index] = constants[cursor]
            cursor += 1
    valuations = []
    specialized = []
    for part in parts:
        coefficients = {}
        for exponent, coefficient in part.items():
            if any(assignments[index] == 0 and exponent[index] > 0
                   for index in assignments):
                continue
            for index, value in assignments.items():
                coefficient *= value ** exponent[index]
            power = exponent[retained]
            coefficients[power] = coefficients.get(power, trace.ZERO) + coefficient
            if not coefficients[power]:
                del coefficients[power]
        valuations.append(order_at(coefficients, center) if coefficients else None)
        specialized.append(coefficients)
    return tuple(valuations), specialized


def single_coprime_segment(valuations):
    if any(value is None for value in valuations):
        return False
    v0, v1, v2, v3 = valuations
    height = v3-v0
    if gcd(abs(height), 3) != 1:
        return False
    return 3*(v1-v0) >= height and 3*(v2-v0) >= 2*height


def main() -> None:
    certificates = {
        (0, 1): (0, (-2, -2, -2), 0, (0, 1, 1, 1)),
        (0, 2): (0, (-2, 0, -2), None, (-2, -2, -2, -3)),
        (0, 3): (0, (-2, -2, -2), 0, (0, 1, 2, 2)),
        (1, 2): (0, (-2, -2, 0), None, (-2, -2, -2, -3)),
        (1, 3): (0, (-2, -2, -2), None, (-3, -3, -3, -4)),
        (1, 4): (0, (-2, 0, -2), None, (-3, -3, -3, -4)),
        (2, 3): (0, (-2, 0, 0), None, (-2, -2, -2, -3)),
        (2, 4): (0, (-2, -2, 0), None, (-3, -3, -3, -4)),
        (3, 4): (1, (-2, -2, -2), None, (-3, -2, -2, -2)),
    }
    for pair, (retained, constants, center, expected) in certificates.items():
        valuations, specialized = specialized_valuations(
            trace.components(*pair), retained, constants, center=center
        )
        assert valuations == expected
        assert all(specialized)
        assert single_coprime_segment(valuations)
        print(
            f"PAIR {pair[0]} {pair[1]} RETAINED_U {retained+1} "
            f"CONSTANTS {constants} CENTER {center} VALUATIONS {valuations}"
        )
    assert set(certificates) == {
        (p, q) for p in range(5) for q in range(p+1, 5) if (p, q) != (0, 4)
    }
    print("PAIR_0_4_USES_ABSOLUTE_NORM_SPECIALIZATION")
    print("H_TRACE_FOURIER_BINARY_NEWTON_ABSOLUTE_OK")


if __name__ == "__main__":
    main()
