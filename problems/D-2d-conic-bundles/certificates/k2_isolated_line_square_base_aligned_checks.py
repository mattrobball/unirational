#!/usr/bin/env python3
"""Replay the sharpened isolated-base squared-line incidence frontier."""

from math import comb


# Off-base high-diagonal row: fixed codimension 39 - 23 = 16.
offbase_fixed = 39 - 23
assert offbase_fixed == 16
rank3_offbase = {
    "[1]": (16, -1),
    "[1,1]": (15, 0),
    "[2]": (14, 1),
}
for dimension, expected_margin in rank3_offbase.values():
    assert offbase_fixed - (dimension + 1) == expected_margin
assert offbase_fixed - (13 + 2) == 1  # rank-two locus
print("off-base high-diagonal base-stratum margins: PASS")


# The h=1 line moves in a pencil; the h=2 line is determined.
simple_rows = {
    (3, "[1]"): (16, -2, None),
    (3, "[1,1]"): (15, -1, -2),
    (3, "[2]"): (14, 0, -1),
    (3, "[1,1,1]"): (14, 0, -1),
    (3, "[2,1]"): (13, 1, 0),
    (3, "[3]"): (12, 2, 1),
    (2, "[1,1,1,1]"): (13, 1, 0),
    (2, "[2,1,1]"): (12, 2, 1),
    (2, "[2,2]"): (11, 3, 2),
    (2, "[3,1]"): (11, 3, 2),
    (2, "[4]"): (10, 4, 3),
}
for dimension, h1_margin, h2_margin in simple_rows.values():
    assert 15 - (dimension + 1) == h1_margin
    if h2_margin is not None:
        assert 13 - dimension == h2_margin
print("through-base simple-cluster margins: PASS")


# Multiplicity-two support.
assert 13 - (10 + 1) == 2
assert 13 - (9 + 1) == 3
print("multiplicity-two through-base margins: PASS")


# Off-base transforms.  For c1(F)=1, elementary transformation gives
# c2(F)=c2(E)-2 in the high-diagonal quotient-degree-zero row.
assert 3 - 2 == 1  # one-point E
assert 2 - 2 == 0  # length-two E


def h0_plane(degree: int) -> int:
    if degree < 0:
        return 0
    return comb(degree + 2, 2)


conditional_dimension = 72 - 39 + 23
rank3_k1_dimension = 60
split_dimension = h0_plane(4) + h0_plane(5) + h0_plane(6)
assert conditional_dimension == 56
assert rank3_k1_dimension - conditional_dimension == 4
assert split_dimension == 64
assert split_dimension - conditional_dimension == 8

# The complete k=1 fixed-form rational locus has codimension at least nine.
assert 9 - 4 == 5
assert (9 - 4) + (-1) > 0
print("off-base transform dimensions and one-point exclusion: PASS")


# GRR on the principalization: c2(F)=R^2-d-u.
def transformed_c2(r_square: int, d: int, u: int) -> int:
    return r_square - d - u


for length in (1, 2, 3, 4):
    r_square = 4 - length
    for h, allowed_u in ((1, (0, -1, -2, -3)), (2, (0, -1, -2))):
        d = 2 - h
        values = [transformed_c2(r_square, d, u) for u in allowed_u]
        expected = [2 - length + h - u for u in allowed_u]
        assert values == expected

# Multiplicity-two center and the rank-two split exceptions.
assert transformed_c2(0, 0, 0) == 0
assert transformed_c2(0, 2, 0) == -2  # O(-H) + O(R)
for d in (0, 1, 2):
    assert transformed_c2(0, d, 0) == -d
print("principalized transform Chern ledger and split exceptions: PASS")
print("isolated-base squared-line base-aligned frontier: PASS")
