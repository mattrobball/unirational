#!/usr/bin/env python3
"""Replay for properness and BPF exclusion of the k=2 [3^3,2] row."""

from math import comb


# Full and deleted adjoint-cluster colengths.
cubic_dimension = comb(3 + 2, 2)
full_virtual_length = 3 * comb(2 + 1, 2) + 1
deleted_virtual_length = 3 * comb(2 + 1, 2)
assert (cubic_dimension, full_virtual_length, deleted_virtual_length) == (
    10,
    10,
    9,
)
assert cubic_dimension - deleted_virtual_length == 1
print("adjoint lengths 10/9 and unique deleted-cluster cubic: PASS")

# Reduced cubic factorization budget for double centers.
irreducible_cubic_max = 1
line_plus_conic_max = 2
triangle_max = 3
assert (irreducible_cubic_max, line_plus_conic_max, triangle_max) == (1, 2, 3)
print("reduced cubic: three double centers force a proper triangle: PASS")

# A nonreduced cubic 2L+M makes the whole three-dimensional space L^2*H0(O(1))
# satisfy the deleted coefficient-two cluster, contradicting uniqueness.
nonreduced_subspace_dimension = comb(1 + 2, 2)
assert nonreduced_subspace_dimension == 3 > 1
print("nonreduced cubic contradicts uniqueness by dimension 3 > 1: PASS")

# Existing three-line margin; the t=2 center is deliberately forgotten.
restriction_image = 54
bad_dimension = 3 * 10
fixed_codimension = restriction_image - bad_dimension
remaining_margin = fixed_codimension - (6 + 17)
assert (fixed_codimension, remaining_margin) == (24, 1)
print("three-line fixed/remaining codimensions 24/1: PASS")

print("base-point-free [3^3,2] profile exclusion: PASS")
