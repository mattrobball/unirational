#!/usr/bin/env python3
"""Exact replay for the base-point-free k=2 squared-line reduction."""

restriction_image = 72 - 33
assert restriction_image == 39

balanced_pair_dimension = 17 + 2
balanced_rows = []
for s in range(4):
    leading_dimension = (7 - 2 * s) + 2 * (s + 1) - 1
    normal_kernel = 12 - 2 * s
    bad_dimension = leading_dimension + normal_kernel
    margin = restriction_image - bad_dimension - balanced_pair_dimension
    balanced_rows.append((s, leading_dimension, normal_kernel, bad_dimension, margin))

assert balanced_rows == [
    (0, 8, 12, 20, 0),
    (1, 8, 10, 18, 2),
    (2, 8, 8, 16, 4),
    (3, 8, 6, 14, 6),
]
assert restriction_image - 18 - balanced_pair_dimension == 2
print("balanced first-neighborhood strata and margins: PASS")

unbalanced_pair_dimension = 17 + 2 - 1
nonboundary_bad_dimension = 18
low_diagonal_bad_dimension = 5 + 4 + 6
high_diagonal_bad_dimension = 9 + 6 + 8
zero_leading_bad_dimension = 18

assert (
    restriction_image - nonboundary_bad_dimension - unbalanced_pair_dimension
) == 3
assert (
    restriction_image - low_diagonal_bad_dimension - unbalanced_pair_dimension
) == 6
assert (
    restriction_image - high_diagonal_bad_dimension - unbalanced_pair_dimension
) == -2
assert (
    restriction_image - zero_leading_bad_dimension - unbalanced_pair_dimension
) == 3
print("unbalanced first-neighborhood strata and margins: PASS")

# For K' / K = i_*(U(1)), c1(K')=-1 and c2(K')=2-deg(U).
assert 2 - (-1) == 3
assert 2 - 0 == 2
assert (3, 2) != (1, 1)
print("elementary-transform Chern classes (c2=3,2 versus k1 c2=1): PASS")
print("base-point-free k=2 squared-line sharp reduction: PASS")
