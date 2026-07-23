#!/usr/bin/env python3
"""Exact replay for the combined k=2 cubic exclusions."""

from math import comb


def h0_plane(degree: int) -> int:
    if degree < 0:
        return 0
    return comb(degree + 2, 2)


def h0_line(degree: int) -> int:
    return max(degree + 1, 0)


# The two proper-center adjoint clusters both have length ten.
profile_42222_length = comb(4, 2) + 4 * comb(2, 2)
profile_3332_length = 3 * comb(3, 2) + comb(2, 2)
cubic_dimension = h0_plane(3)
assert (profile_42222_length, profile_3332_length) == (10, 10)
assert cubic_dimension == 10
print("two length-ten cubic adjoint clusters: PASS")

# 0 -> 3 O(2) -> 6 O(4) -> Q_2 -> 0 and its -3 twist.
h0_q = 6 * h0_plane(4) - 3 * h0_plane(2)
h0_q_minus_3 = 6 * h0_plane(1) - 3 * h0_plane(-1)
three_line_image = h0_q - h0_q_minus_3
assert (h0_q, h0_q_minus_3, three_line_image) == (72, 18, 54)
print("three-line restriction image 72-18=54: PASS")

# Balanced and unbalanced line spaces; the fixed determinant fiber bounds
# are the exact binary-UFD bounds used in the profile-[5] certificate.
balanced_domain = 3 * h0_line(6)
unbalanced_domain = h0_line(8) + h0_line(6) + h0_line(4)
determinant_target = h0_line(12)
balanced_fiber = 8
unbalanced_fiber = 9
contact = 12
contact_target = determinant_target - contact
balanced_bad = balanced_fiber + contact_target
unbalanced_bad = unbalanced_fiber + contact_target
assert (balanced_domain, unbalanced_domain) == (21, 21)
assert (determinant_target, contact_target) == (13, 1)
assert (balanced_bad, unbalanced_bad) == (9, 10)
three_line_bad = 3 * unbalanced_bad
three_line_codim = three_line_image - three_line_bad
assert (three_line_bad, three_line_codim) == (30, 24)
print("worst three-line determinant codimension 54-30=24: PASS")

# Four-jets of a symmetric 2 x 2 matrix have dimension twelve.  The unit
# stratum has dimension 4+4=8.  In the all-nonunit stratum, a nonzero first
# coefficient gives dimensions 2+2+3=7, while a zero first coefficient has
# dimension six.  Thus the contact locus has dimension eight and codim four.
jet_ambient = 3 * 4
jet_unit_stratum = 4 + 4
jet_nonzero_first = 2 + 2 + 3
jet_zero_first = 3 * 2
jet_locus_dimension = max(
    jet_unit_stratum, jet_nonzero_first, jet_zero_first
)
jet_codim = jet_ambient - jet_locus_dimension
assert (jet_ambient, jet_locus_dimension, jet_codim) == (12, 8, 4)
print("univariate determinant four-jet codimension 4: PASS")

# The omitted point contributes 4 conditions and 2 parameters.  In the
# all-unbalanced-pencil stratum, (sigma,z) has dimension 15 rather than 19.
sigma_dimension = 17
point_dimension = 2
ordinary_pair_dimension = sigma_dimension + point_dimension
exceptional_pair_dimension = 15
ordinary_q_codim = three_line_codim + jet_codim
assert ordinary_q_codim == 28
assert ordinary_pair_dimension - exceptional_pair_dimension == 4

rows = {
    "[4,2^4]": 8,
    "[3^3,2]": 6,
}
expected = {"[4,2^4]": 1, "[3^3,2]": 3}
for profile, selected_root_dimension in rows.items():
    ordinary_margin = ordinary_q_codim - (
        selected_root_dimension + point_dimension + sigma_dimension
    )
    exceptional_margin = three_line_codim - (
        selected_root_dimension + exceptional_pair_dimension
    )
    assert ordinary_margin == expected[profile]
    assert exceptional_margin == expected[profile]
    assert ordinary_margin > 0 and exceptional_margin > 0
    print(
        f"{profile}: ordinary margin={ordinary_margin}, "
        f"all-unbalanced margin={exceptional_margin}"
    )

print("proper-center cubic margins: PASS")

# Uniform [4,2^4] subcluster Hilbert functions.  The t=4 center contributes
# a triple point of colength six, and each t=2 center contributes one.
subcluster_hilbert = []
for selected_t2 in range(5):
    colength = comb(4, 2) + selected_t2
    cubic_kernel = cubic_dimension - colength
    subcluster_hilbert.append((selected_t2, colength, cubic_kernel))
assert subcluster_hilbert == [
    (0, 6, 4),
    (1, 7, 3),
    (2, 8, 2),
    (3, 9, 1),
    (4, 10, 0),
]
print("uniform [4,2^4] cubic subcluster Hilbert function: PASS")

# Restriction to the union of four distinct selected lines.
h0_q_minus_4 = 6 * h0_plane(0) - 3 * h0_plane(-2)
four_line_image = h0_q - h0_q_minus_4
assert (h0_q_minus_4, four_line_image) == (6, 66)

# If j lines are unbalanced, each adds one to the product bad dimension but
# removes one direction parameter.  The fixed-sigma margin stays 20.
for jumping_lines in range(5):
    product_bad = (4 - jumping_lines) * balanced_bad + (
        jumping_lines * unbalanced_bad
    )
    restriction_codim = four_line_image - product_bad
    cluster_dimension = 10 - jumping_lines
    fixed_sigma_codim = restriction_codim - cluster_dimension
    equation_margin = fixed_sigma_codim - sigma_dimension
    assert restriction_codim == 30 - jumping_lines
    assert fixed_sigma_codim == 20
    assert equation_margin == 3

# If the whole pencil is unbalanced, (sigma,p) has dimension fifteen and
# the four residual paths have at most two parameters each.
all_unbalanced_product_bad = 4 * unbalanced_bad
all_unbalanced_restriction_codim = (
    four_line_image - all_unbalanced_product_bad
)
all_unbalanced_margin = all_unbalanced_restriction_codim - (
    exceptional_pair_dimension + 4 * 2
)
assert (all_unbalanced_restriction_codim, all_unbalanced_margin) == (26, 3)
print("uniform [4,2^4] four-line margins all equal 3: PASS")

# Integral selected cubic in the all-proper [3,2^7] row.  The normalized
# kernel splitting has a>=1, so the largest diagonal boundary is degree22.
nonzero_fiber_bounds = []
for splitting_a in (1, 2, 3):
    low_degree = 12 + 2 * splitting_a
    high_degree = 24 - 2 * splitting_a
    nonzero_low_diagonal = (low_degree + 1) + (19 - low_degree)
    zero_low_diagonal = high_degree + 1
    fixed_nonzero_fiber = max(
        nonzero_low_diagonal, zero_low_diagonal
    )
    nonzero_fiber_bounds.append(
        (
            splitting_a,
            low_degree,
            high_degree,
            fixed_nonzero_fiber,
        )
    )
assert nonzero_fiber_bounds == [
    (1, 14, 22, 23),
    (2, 16, 20, 21),
    (3, 18, 18, 20),
]
integral_cubic_bad = 23 + 1
integral_cubic_codim = three_line_image - integral_cubic_bad
assert (integral_cubic_bad, integral_cubic_codim) == (24, 30)

integral_selected_roots = 2 * 7
integral_ordinary_margin = (integral_cubic_codim + jet_codim) - (
    integral_selected_roots + point_dimension + sigma_dimension
)
integral_exceptional_margin = integral_cubic_codim - (
    integral_selected_roots + exceptional_pair_dimension
)
assert (integral_ordinary_margin, integral_exceptional_margin) == (1, 1)
print("integral-cubic [3,2^7] margins both equal 1: PASS")
print("combined cubic exclusions: PASS")
