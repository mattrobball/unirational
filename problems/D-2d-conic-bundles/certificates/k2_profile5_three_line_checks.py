#!/usr/bin/env python3
"""Exact dimension replay for the base-point-free k=2 profile [5]."""

from math import comb


def h0_line(degree: int) -> int:
    return max(degree + 1, 0)


# From 0 -> 3 O(2) -> 6 O(4) -> Q_2 -> 0.
h0_q = 6 * comb(4 + 2, 2) - 3 * comb(2 + 2, 2)
h0_q_minus_3 = 6 * comb(1 + 2, 2)
restriction_image = h0_q - h0_q_minus_3
assert (h0_q, h0_q_minus_3, restriction_image) == (72, 18, 54)
print("three-line restriction image 72-18=54: PASS")

# Balanced and unbalanced line section dimensions are both 21.
balanced_domain = 3 * h0_line(6)
unbalanced_domain = h0_line(8) + h0_line(6) + h0_line(4)
target = h0_line(12)
assert (balanced_domain, unbalanced_domain, target) == (21, 21, 13)
print("balanced/unbalanced line domains and determinant target: PASS")

# Fiber bounds from the binary UFD calculation.
balanced_fiber = 8
unbalanced_fiber = 9
assert balanced_fiber + target == 21
assert unbalanced_fiber + target == 22

# A 3 x 3 rank-one matrix has affine dimension 3+3-1=5.
rank_one_jet_dimension = 3 + 3 - 1
higher_coefficient_dimension = 3 * 3
exceptional_sigma_projective = (
    rank_one_jet_dimension + higher_coefficient_dimension - 1
)
exceptional_pair_dimension = exceptional_sigma_projective + 2
assert (rank_one_jet_dimension, exceptional_sigma_projective) == (5, 13)
assert exceptional_pair_dimension == 15
print("all-unbalanced rank-one first-jet stratum dimension 15: PASS")

for r in (10, 11):
    balanced_bad_per_line = balanced_fiber + (target - r)
    balanced_fixed_codim = restriction_image - 3 * balanced_bad_per_line
    balanced_moving_codim = balanced_fixed_codim - (17 + 2)

    unbalanced_bad_per_line = unbalanced_fiber + (target - r)
    unbalanced_fixed_codim = restriction_image - 3 * unbalanced_bad_per_line
    unbalanced_moving_codim = (
        unbalanced_fixed_codim - exceptional_pair_dimension
    )

    assert balanced_fixed_codim == 3 * r - 9
    assert balanced_moving_codim == 3 * r - 28
    assert unbalanced_fixed_codim == 3 * r - 12
    assert unbalanced_moving_codim == 3 * r - 27
    assert balanced_moving_codim > 0
    assert unbalanced_moving_codim > 0

    print(
        f"r={r}: balanced remaining codim={balanced_moving_codim}, "
        f"all-unbalanced remaining codim={unbalanced_moving_codim}"
    )

print("base-point-free [5] three-line exclusion: PASS")
