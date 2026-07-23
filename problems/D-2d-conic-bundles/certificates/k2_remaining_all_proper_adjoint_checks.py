#!/usr/bin/env python3
"""Exact replay for the remaining all-proper k=2 adjoint reduction."""

from itertools import combinations
from math import comb


def h0_plane(degree: int) -> int:
    return comb(degree + 2, 2) if degree >= 0 else 0


# The [3^2,2^4] adjoint cluster and every one-point deletion.
cubic_dimension = h0_plane(3)
full_length = 2 * comb(3, 2) + 4
deleted_length = full_length - 1
assert (cubic_dimension, full_length, deleted_length) == (10, 10, 9)
assert cubic_dimension - deleted_length == 1
print("[3^2,2^4] adjoint lengths 10/9 and unique cubics: PASS")

# Deleting all four low summands leaves two double centers, colength six,
# and a four-dimensional cubic system.  Forbidden Enriques positions would
# put it inside the three-dimensional double-line system.
high_cluster_length = 2 * comb(3, 2)
high_cubic_dimension = cubic_dimension - high_cluster_length
double_line_system_dimension = h0_plane(1)
assert (high_cluster_length, high_cubic_dimension) == (6, 4)
assert double_line_system_dimension == 3 < high_cubic_dimension
print("two-high-center dichotomy 4-dimensional versus double-line 3-space: PASS")

# The common degree-three restriction image.
h0_q = 6 * h0_plane(4) - 3 * h0_plane(2)
h0_q_minus_3 = 6 * h0_plane(1) - 3 * h0_plane(-1)
cubic_image = h0_q - h0_q_minus_3
assert (h0_q, h0_q_minus_3, cubic_image) == (72, 18, 54)
print("degree-three restriction image 72-18=54: PASS")

# Integral selected conic: every fixed determinant fiber is at most 17,
# and the full-contact target is one-dimensional.  The line contributes
# at most ten.  The omitted determinant four-jet has codimension four.
conic_splittings = []
for a in range(3):
    degrees = (8 + 2 * a, 12, 16 - 2 * a)
    assert sum(d + 1 for d in degrees) == 39
    conic_splittings.append(degrees)
assert conic_splittings == [(8, 12, 16), (10, 12, 14), (12, 12, 12)]
conic_fixed_fiber = 17
conic_full_contact_target = 1
conic_bad = conic_fixed_fiber + conic_full_contact_target
line_worst_bad = 10
integral_fixed_codim = cubic_image - (conic_bad + line_worst_bad)
jet_codim = 4
integral_ordinary_margin = integral_fixed_codim + jet_codim - (12 + 17)
integral_pencil_margin = integral_fixed_codim - (10 + 15)
assert (conic_bad, integral_fixed_codim) == (18, 26)
assert (integral_ordinary_margin, integral_pencil_margin) == (1, 1)
print("integral-conic ordinary/all-pencil margins 1/1: PASS")

# If the high centers are proper plus free first-near, their movement drops
# by one.  Every split tangent conic contains the marked line, so one of the
# four selected conics is integral; the resulting margins are 2/2.
first_near_ordinary_margin = integral_fixed_codim + jet_codim - (11 + 17)
first_near_pencil_margin = integral_fixed_codim - (9 + 15)
assert (first_near_ordinary_margin, first_near_pencil_margin) == (2, 2)
print("free-first-near high-center integral-conic margins 2/2: PASS")

# For a line with contact R, these are the balanced and unbalanced bad
# dimensions.  The max is needed when R > 12 and the target is just zero.
def line_bad(contact: int, unbalanced: bool) -> int:
    fiber = 9 if unbalanced else 8
    target = max(13 - contact, 0)
    return fiber + target


assert line_bad(12, False) == 9
assert line_bad(12, True) == 10
assert line_bad(14, False) == 8
assert line_bad(14, True) == 9
assert line_bad(10, False) == 11
assert line_bad(10, True) == 12

# Split Q patterns allowed by squarefreeness.  The worst is (high+2 low)
# on one component and (high+1 low) on the other.  A duplicated low gives
# two (high+2 low) components and is smaller.
for jumping in range(4):
    # Put the jumping lines first.  Since each unbalanced line adds exactly
    # one to the displayed uniform bound, identities are independent of
    # which selected lines jump.
    split_bad_bound = 28 + jumping
    fixed_codim = cubic_image - split_bad_bound
    ordinary_codim = fixed_codim + jet_codim
    sigma_saving = 1 if jumping else 0
    moving_dimension = 10 + 17 - sigma_saving
    ordinary_margin = ordinary_codim - moving_dimension
    expected = (3, 3, 2, 1)[jumping]
    assert fixed_codim == 26 - jumping
    assert ordinary_margin == expected

    pencil_moving = 23
    if jumping == 3:
        # One selected-line equation cuts the irreducible rank-one-jet
        # pair stratum; all selected lines avoid the omitted point.
        pencil_moving -= 1
    pencil_margin = fixed_codim - pencil_moving
    expected_pencil = (3, 2, 1, 1)[jumping]
    assert pencil_margin == expected_pencil

print("split-conic balanced/unbalanced/all-pencil margins: PASS")

# Four reducible complementary conics need at least two collinearity
# witnesses: a high+two-low triple covers at most two omissions, and a
# three-low triple covers at most one.
omissions = set(range(4))
witness_covers = []
for pair in combinations(range(4), 2):
    witness_covers.append(omissions - set(pair))  # p or q plus this pair
for triple in combinations(range(4), 3):
    witness_covers.append(omissions - set(triple))  # three low points
assert max(map(len, witness_covers)) == 2
assert all(cover != omissions for cover in witness_covers)
assert any(a | b == omissions for a, b in combinations(witness_covers, 2))
configuration_dimension = 12 - 2
assert configuration_dimension == 10
print("four split adjoint conics require two collinearities: PASS")

# The [3,2^7] block cover.  P_ab covers the complement of {a,b}; Q_ab
# covers {a,b}.  Exhaust all unordered pairs of the forty-two blocks.
labels = frozenset(range(7))
blocks = []
for a, b in combinations(range(7), 2):
    pair = frozenset((a, b))
    blocks.append(("P", pair, labels - pair))
    blocks.append(("Q", pair, pair))

assert len(blocks) == 42
two_block_covers = []
for left, right in combinations(blocks, 2):
    if left[2] | right[2] == labels:
        two_block_covers.append((left, right))

pp = [row for row in two_block_covers if row[0][0] == row[1][0] == "P"]
pq = [row for row in two_block_covers if {row[0][0], row[1][0]} == {"P", "Q"}]
qq = [row for row in two_block_covers if row[0][0] == row[1][0] == "Q"]
assert len(pp) == comb(7, 4) * 3 == 105
assert all(left[1].isdisjoint(right[1]) for left, right in pp)
assert len(pq) == comb(7, 2) == 21
assert all(left[1] == right[1] for left, right in pq)
assert len(qq) == 0
assert len(two_block_covers) == 126
print("42 blocks and 105+21 exact two-block covers: PASS")

# Integral matched P+Q: zero determinant on a line and integral conic.
matched_zero_bad = 9 + 17
matched_fixed_codim = cubic_image - matched_zero_bad
matched_moving_dimension = 2 + 5 + 17
matched_margin = matched_fixed_codim - matched_moving_dimension
assert (matched_fixed_codim, matched_margin) == (28, 4)
print("integral matched line-conic block margin 4: PASS")

# No two distinct branch components of degrees at most two.  For two
# lines, each unbalanced line adds one to the bad dimension and removes one
# sigma parameter.  Line-conic and conic-conic rows have uniform margin 5.
for jumping in range(3):
    two_line_bad = 16 + jumping
    two_line_fixed_codim = 39 - two_line_bad
    two_line_moving = (17 - jumping) + 4
    assert two_line_fixed_codim - two_line_moving == 2

line_conic_balanced_margin = 54 - (8 + 17) - (17 + 2 + 5)
line_conic_unbalanced_margin = 54 - (9 + 17) - (16 + 2 + 5)
two_conic_margin = 66 - 2 * 17 - (17 + 2 * 5)
assert (
    line_conic_balanced_margin,
    line_conic_unbalanced_margin,
    two_conic_margin,
) == (5, 5, 5)
print("low-degree branch-component pair margins 2/5/5: PASS")

print("remaining proper-low/all-proper squarefree rows excluded: PASS")
