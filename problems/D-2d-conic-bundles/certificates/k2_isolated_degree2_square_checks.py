#!/usr/bin/env python3
"""Exact arithmetic replay for k2_isolated_degree2_square_exclusion.md."""

from itertools import product


def h0(degree):
    return max(degree + 1, 0)


def deltas(A, C):
    return [d for d in range(min(A, C) + 1) if (A - d) % 2 == 0 and (C - d) % 2 == 0]


def first_bad(A, B, C, k):
    """Bad dimension for q0+t*q1 modulo t^2."""
    nonboundary = max(
        (B + 2) + (B + d + 2 * k + 2) for d in deltas(A, C)
    )
    high_diagonal = (C + 1) + (B + k + 1) + (C + k + 1)
    low_diagonal = (A + 1) + (A + k + 1) + (B + k + 1)
    zero = (A + k + 1) + (B + k + 1) + (C + k + 1)
    return max(nonboundary, high_diagonal, low_diagonal, zero)


def fourth_bad(A, B, C, k):
    """Bad dimension for four layers; includes the zero-leading boundary."""
    nonboundary = max(
        (B + 2)
        + sum(B + d + 2 * i * k + 2 for i in (1, 2, 3))
        for d in deltas(A, C)
    )
    high_diagonal = (C + 1) + sum(
        (B + i * k + 1) + (C + i * k + 1) for i in (1, 2, 3)
    )
    low_diagonal = (A + 1) + sum(
        (A + i * k + 1) + (B + i * k + 1) for i in (1, 2, 3)
    )

    # If q0=0, q1 and q2 obey the first-neighborhood condition and q3 is free.
    shifted_first = first_bad(A + k, B + k, C + k, k)
    q3 = h0(A + 3 * k) + h0(B + 3 * k) + h0(C + 3 * k)
    zero = shifted_first + q3
    return max(nonboundary, high_diagonal, low_diagonal, zero)


first_rows = [
    ((6, 6, 6, -1), 20),
    ((4, 6, 8, -1), 23),
    ((4, 5, 6, 0), 20),
    ((4, 4, 4, 1), 18),
    ((4, 4, 4, 0), 16),
]
fourth_rows = [
    ((6, 6, 6, -1), 38),
    ((4, 6, 8, -1), 45),
    ((4, 5, 6, 0), 46),
    ((4, 4, 4, 1), 48),
    ((4, 4, 4, 0), 36),
]

assert [first_bad(*row) for row, _ in first_rows] == [answer for _, answer in first_rows]
assert [fourth_bad(*row) for row, _ in fourth_rows] == [answer for _, answer in fourth_rows]


# Plane-coefficient fourth-line filtration.
# h=1: leading codimension 11; the worst nonboundary has delta=4.
assert 11 + (10 - 4) + (9 - 4) == 22
assert 11 + 4 + 3 == 18  # largest diagonal
# h=2 or a multiplicity-two point.
assert 9 + (8 - 4) + (7 - 4) == 16
assert 10 + 4 + 3 == 17

fourth_fixed = {"off": 21, "h1": 18, "h2": 16, "m2": 16}
fourth_pairs = {"off": 18, "h1": 17, "h2": 15, "m2": 11}
fourth_margins = {key: fourth_fixed[key] - fourth_pairs[key] for key in fourth_fixed}
assert fourth_margins == {"off": 3, "h1": 1, "h2": 1, "m2": 5}


lower_twist_rows = [
    ((4, 4, 4, -1), 14),
    ((2, 4, 6, -1), 17),
    ((2, 3, 4, 0), 14),
    ((2, 2, 2, 1), 12),
    ((2, 2, 2, 0), 10),
]
assert [first_bad(*row) for row, _ in lower_twist_rows] == [
    answer for _, answer in lower_twist_rows
]

# Single-line codimensions and twist-two gains.
single_c = {0: 16, 1: 15, 2: 13}
assert {
    "off": 27 - 17,
    "h1_terminal": (27 - 4) - 14,
    "h1_nonterminal": (27 - 6) - 14,
    "h2_TT": (27 - 8) - 12,
    "h2_NT": (27 - 10) - 12,
    "h2_NN": (27 - 12) - 12,
} == {
    "off": 10,
    "h1_terminal": 9,
    "h1_nonterminal": 7,
    "h2_TT": 7,
    "h2_NT": 5,
    "h2_NN": 3,
}


def line_types(lengths):
    types = [("off", (), 0, 2)]
    for i, _ in enumerate(lengths):
        types.append((f"p{i}", ((i, 0),), 1, 1))
    for i, n in enumerate(lengths):
        if n >= 2:
            types.append((f"t{i}", ((i, 0), (i, 1)), 2, 0))
    for i in range(len(lengths)):
        for j in range(i + 1, len(lengths)):
            types.append((f"c{i}{j}", ((i, 0), (j, 0)), 2, 0))
    return types


def cluster_rows(lengths, sigma_dimension):
    nonterminal = {}
    for i, n in enumerate(lengths):
        nonterminal[(i, 0)] = n >= 2
        if n >= 2:
            nonterminal[(i, 1)] = n >= 3

    def gain(line):
        if line[2] == 0:
            return 10
        count = sum(nonterminal[center] for center in line[1])
        if line[2] == 1:
            return 7 if count else 9
        return {0: 7, 1: 5, 2: 3}[count]

    types = line_types(lengths)
    rows = []
    for ia, first in enumerate(types):
        for ib in range(ia, len(types)):
            second = types[ib]
            # A fixed tangent or chord cannot be chosen twice as two distinct lines.
            if ia == ib and first[2] == 2 and first[0] != "off":
                continue

            fixed = max(
                single_c[first[2]] + gain(second),
                single_c[second[2]] + gain(first),
            )
            moving = sigma_dimension + first[3] + second[3]
            rows.append((fixed - moving, first[0], second[0], fixed, moving))
    return rows


cluster_specs = [
    ("3:[1]", [1], 16, 6),
    ("3:[1,1]", [1, 1], 15, 6),
    ("3:[2]", [2], 14, 5),
    ("3:[1,1,1]", [1, 1, 1], 14, 6),
    ("3:[2,1]", [2, 1], 13, 5),
    ("3:[3]", [3], 12, 7),
    ("2:[1,1,1,1]", [1, 1, 1, 1], 13, 7),
    ("2:[2,1,1]", [2, 1, 1], 12, 6),
    ("2:[2,2]", [2, 2], 11, 7),
    ("2:[3,1]", [3, 1], 11, 7),
    ("2:[4]", [4], 10, 9),
]

observed_minima = []
for name, lengths, sigma_dimension, expected_minimum in cluster_specs:
    rows = cluster_rows(lengths, sigma_dimension)
    minimum = min(row[0] for row in rows)
    assert minimum == expected_minimum, (name, minimum, expected_minimum)
    observed_minima.append(minimum)

assert observed_minima == [6, 6, 5, 6, 5, 7, 7, 6, 7, 7, 9]


# Multiplicity-two rows: 0, 1, or 2 root lines through the base point.
m2_rows = [
    (16 + 10, 10 + 4, 12),
    (13 + 10, 10 + 1 + 2, 10),
    (13 + 5, 10 + 1 + 1, 6),
]
for fixed, moving, expected_margin in m2_rows:
    assert fixed - moving == expected_margin


print("k=2 isolated-base degree-two square-root exclusion checks: PASS")
print("first-neighborhood bad dimensions: 20, 23, 20, 18, 16")
print("fourth-neighborhood ambient bad dimensions: 38, 45, 46, 48, 36")
print("fourth-line moving margins (off, h=1, h=2, m=2): 3, 1, 1, 5")
print("lower-twist bad dimensions: 14, 17, 14, 12, 10")
print("simple-cluster sequential margins: 6, 6, 5, 6, 5, 7, 7, 6, 7, 7, 9")
print("multiplicity-two two-line margins (0, 1, 2 incident lines): 12, 10, 6")
