#!/usr/bin/env python3
"""Dimension replay for the base-point-free k=2, e=2 exclusion."""

from math import comb


def h0_p2(degree: int) -> int:
    return comb(degree + 2, 2) if degree >= 0 else 0


def h0_p1(degree: int) -> int:
    return degree + 1 if degree >= 0 else 0


# Global section space and restriction to every degree-four Cartier divisor.
h0_q = 6 * h0_p2(4) - 3 * h0_p2(2)
h0_q_minus_4 = 6 * h0_p2(0)
image_degree_4 = h0_q - h0_q_minus_4
assert (h0_q, h0_q_minus_4, image_degree_4) == (72, 6, 66)
print("degree-four restriction image 66: PASS")

# First neighborhoods of balanced and unbalanced lines.
balanced_2l_target = 3 * h0_p1(6) + 3 * h0_p1(5)
unbalanced_2l_target = sum(h0_p1(d) for d in (4, 6, 8, 3, 5, 7))
assert balanced_2l_target == unbalanced_2l_target == 39
balanced_2l_bad = 20
unbalanced_2l_bad = 23
assert image_degree_4 - (balanced_2l_bad + unbalanced_2l_bad) - (17 + 4) == 2
assert image_degree_4 - 2 * unbalanced_2l_bad - ((17 - 2) + 4) == 1
print("two-distinct-line square margins 2/1: PASS")

# Integral conic first-neighborhood rows.
conic_rows = []
for alpha in range(3):
    q0_degrees = (2 * alpha + 8, 12, 16 - 2 * alpha)
    q1_degrees = (2 * alpha + 4, 8, 12 - 2 * alpha)
    assert sum(h0_p1(d) for d in q0_degrees) == 39
    assert sum(h0_p1(d) for d in q1_degrees) == 27
    nonboundary = 28 + 2 * alpha  # maximum occurs at s=0
    high_boundary = 39 - 4 * alpha
    low_boundary = 23 + 4 * alpha
    maximum = max(nonboundary, high_boundary, low_boundary)
    conic_rows.append((alpha, nonboundary, high_boundary, low_boundary, maximum))
assert conic_rows == [
    (0, 28, 39, 23, 39),
    (1, 30, 35, 27, 35),
    (2, 32, 31, 31, 32),
]
conic_zero_leading = 27
assert conic_zero_leading < max(row[-1] for row in conic_rows)
assert image_degree_4 - max(row[-1] for row in conic_rows) - (17 + 5) == 5
print("doubled-integral-conic margin 5: PASS")

# Fourth-order line rows.
balanced_rows = []
for d in (0, 2, 4, 6):
    kernels = (6 + d, 4 + d, 2 + d)
    balanced_rows.append((d, *kernels, 8 + sum(kernels)))
assert balanced_rows[-1] == (6, 12, 10, 8, 38)
assert max(row[-1] for row in balanced_rows) == 38

unbalanced_nonboundary = [32 - 6 * s for s in range(3)]
unbalanced_high_boundary = 9 + 14 + 12 + 10
unbalanced_low_boundary = 5 + 10 + 8 + 6
balanced_zero_leading = 7 + 10 + 12
unbalanced_zero_leading = 8 + 12 + 12
assert max(unbalanced_nonboundary) == 32
assert (unbalanced_high_boundary, unbalanced_low_boundary) == (45, 29)
assert balanced_zero_leading == 29 < 38
assert unbalanced_zero_leading == 32 < 45
assert image_degree_4 - 38 - (17 + 2) == 9
assert image_degree_4 - 45 - (17 + 2 - 1) == 3
print("fourth-order-line margins 9/3: PASS")

print("base-point-free degree-two square-factor exclusion: PASS")
