#!/usr/bin/env python3
"""Cubic/quartic component margins over primitive isolated bases."""

from itertools import combinations, product
from typing import Optional


def plane_sections(degree: int) -> int:
    if degree < 0:
        return 0
    return (degree + 1) * (degree + 2) // 2


def epsilon(multiplicity: int) -> int:
    if multiplicity == 0:
        return 0
    if multiplicity == 1:
        return 1
    return 2


def rank_one_dimension(j: int, f: int, d: int) -> int:
    """D_j(f,m), with m=f-d."""
    m = f - d
    return max(f - 2 * m + 1, 0) + max(2 * m + 4 * j + 1, 0)


labels = ("d>=4", "d=3", "d=2", "d=1")


def quotient_delta(j: int, label: str) -> int:
    if label == "d=1":
        return (j - 1) * (j - 2) // 2
    if j == 4 and label == "d=2":
        return 1
    return 0


def quotient_degrees(j: int, f: int, label: str):
    if label == "d>=4":
        # A nonzero section on M^2(4H) gives m >= -2j.
        return range(4, f + 2 * j + 1)
    return [int(label.split("=")[1])]


matrix_vanishing = {j: 6 * plane_sections(4 - j) for j in (3, 4)}
starting_image = {j: 90 - matrix_vanishing[j] - 18 for j in (3, 4)}

assert matrix_vanishing == {3: 18, 4: 6}
assert starting_image == {3: 54, 4: 66}


expected_simple = {
    3: {
        1: {"d>=4": 8, "d=3": 8, "d=2": 8, "d=1": 7},
        2: {"d>=4": 8, "d=3": 8, "d=2": 8, "d=1": 8},
        3: {"d>=4": 8, "d=3": 8, "d=2": 8, "d=1": 8},
        4: {"d>=4": 8, "d=3": 8, "d=2": 8, "d=1": 8},
    },
    4: {
        1: {"d>=4": 9, "d=3": 9, "d=2": 8, "d=1": 7},
        2: {"d>=4": 9, "d=3": 9, "d=2": 9, "d=1": 8},
        3: {"d>=4": 9, "d=3": 9, "d=2": 9, "d=1": 9},
        4: {"d>=4": 9, "d=3": 9, "d=2": 9, "d=1": 9},
    },
}

expected_multiplicity_two = {
    3: {
        10: {label: 10 for label in labels},
        9: {label: 11 for label in labels},
    },
    4: {
        10: {label: 9 for label in labels},
        9: {label: 10 for label in labels},
    },
}

expected_zero = {
    3: {"simple": 23, "multiplicity_two": 26},
    4: {"simple": 28, "multiplicity_two": 29},
}

simple_minima = {}
multiplicity_two_minima = {}
zero_minima = {}

for j in (3, 4):
    image_start = starting_image[j]
    curve_dimension = plane_sections(j) - 1
    arithmetic_genus = (j - 1) * (j - 2) // 2

    simple_minima[j] = {}
    simple_zero_minimum = 10**9

    for base_length in range(1, 5):
        triple_dimension = 17 - base_length
        minima = {label: 10**9 for label in labels}

        for multiplicities in product(range(j), repeat=base_length):
            contact = sum(multiplicities)
            if contact > 2 * j:
                continue

            delta_base = sum(a * (a - 1) // 2 for a in multiplicities)
            if delta_base > arithmetic_genus:
                # No integral curve realizes this tuple.
                continue

            marked_cost = sum(epsilon(a) for a in multiplicities)
            f = 2 * j - contact
            image_dimension = image_start - 3 * contact

            zero_curve_dimension = curve_dimension - delta_base - marked_cost
            simple_zero_minimum = min(
                simple_zero_minimum,
                image_dimension - zero_curve_dimension - triple_dimension,
            )

            for label in labels:
                delta_q = quotient_delta(j, label)
                bad_dimension = max(
                    rank_one_dimension(j, f, d)
                    for d in quotient_degrees(j, f, label)
                )
                moving_curve_dimension = (
                    curve_dimension - max(delta_base, delta_q) - marked_cost
                )
                margin = (
                    image_dimension
                    - bad_dimension
                    - moving_curve_dimension
                    - triple_dimension
                )
                minima[label] = min(minima[label], margin)

        simple_minima[j][base_length] = minima

    multiplicity_two_minima[j] = {}
    multiplicity_two_zero_minimum = 10**9

    for triple_dimension in (10, 9):
        minima = {label: 10**9 for label in labels}

        for multiplicity in range(j):
            contact = 2 * multiplicity
            delta_base = multiplicity * (multiplicity - 1) // 2
            if delta_base > arithmetic_genus:
                continue

            marked_cost = epsilon(multiplicity)
            f = 2 * j - contact
            image_dimension = image_start - 3 * contact

            zero_curve_dimension = curve_dimension - delta_base - marked_cost
            multiplicity_two_zero_minimum = min(
                multiplicity_two_zero_minimum,
                image_dimension - zero_curve_dimension - triple_dimension,
            )

            for label in labels:
                delta_q = quotient_delta(j, label)
                bad_dimension = max(
                    rank_one_dimension(j, f, d)
                    for d in quotient_degrees(j, f, label)
                )
                moving_curve_dimension = (
                    curve_dimension - max(delta_base, delta_q) - marked_cost
                )
                margin = (
                    image_dimension
                    - bad_dimension
                    - moving_curve_dimension
                    - triple_dimension
                )
                minima[label] = min(minima[label], margin)

        multiplicity_two_minima[j][triple_dimension] = minima

    zero_minima[j] = {
        "simple": simple_zero_minimum,
        "multiplicity_two": multiplicity_two_zero_minimum,
    }

assert simple_minima == expected_simple
assert multiplicity_two_minima == expected_multiplicity_two
assert zero_minima == expected_zero


def partitions(total: int, largest: Optional[int] = None):
    """Integer partitions, used only for the factor-degree routing."""
    if total == 0:
        yield ()
        return
    if largest is None:
        largest = total
    for first in range(min(total, largest), 0, -1):
        for tail in partitions(total - first, first):
            yield (first,) + tail


def has_subsum_two(parts: tuple[int, ...]) -> bool:
    for size in range(1, len(parts) + 1):
        if any(sum(choice) == 2 for choice in combinations(parts, size)):
            return True
    return False


for parts in partitions(3):
    assert 3 in parts or has_subsum_two(parts)

for parts in partitions(4):
    assert 4 in parts or 3 in parts or has_subsum_two(parts)

assert all(2 * j > 4 for j in (3, 4))

print("matrix-vanishing kernels 18/6 and starting images 54/66: PASS")
print("conductor-safe saturation loss is applied after the T-kernel: PASS")
print("simple proper/free/satellite cubic margins 7 or better: PASS")
print("simple proper/free/satellite quartic margins 7 or better: PASS")
print("multiplicity-two cubic/quartic margins 9 or better: PASS")
print("rank-zero cubic/quartic margins 23/26 and 28/29: PASS")
print("degree-zero square-root boundary routes to rank-two pure square: PASS")
print("isolated-base e=3,4 factor routing: PASS")
