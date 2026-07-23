#!/usr/bin/env python3
"""Exact replay for the two transformed-bundle squared-line strata."""

from math import comb


def chi_sym2_f(t: int, c2: int) -> int:
    """RR for Sym^2(F)(t), where rank(F)=2 and c1(F)=1."""
    numerator = 3 * t * t + 15 * t + 20 - 8 * c2
    assert numerator % 2 == 0
    return numerator // 2


# For t >= 1, H^1 vanishes.  At t=0 the quotient presentations give
# h0=3,1 in the c2=2,3 rows, respectively.
h0_tables = {}
for c2, h0_at_zero in ((2, 3), (3, 1)):
    h0 = {0: h0_at_zero}
    for t in range(1, 5):
        h0[t] = chi_sym2_f(t, c2)
    h0_tables[c2] = h0

assert [h0_tables[2][t] for t in range(4, -1, -1)] == [56, 38, 23, 11, 3]
assert [h0_tables[3][t] for t in range(4, -1, -1)] == [52, 34, 19, 7, 1]

# Explicit c2=3 long-exact-sequence ledger for t=1,2,3:
# (h0 A, h1 A, h0 B, h1 B, h0 C, h1 C), where
# A=G3(t-2), B=Sym^2(G3)(t), C=Sym^2(F3)(t).
c2_3_long_exact = {
    1: (0, 1, 6, 0, 7, 0),
    2: (1, 0, 20, 0, 19, 0),
    3: (6, 0, 40, 0, 34, 0),
}
for values in c2_3_long_exact.values():
    h0_a, h1_a, h0_b, h1_b, h0_c, h1_c = values
    assert h1_b == h1_c == 0
    assert h0_c == h0_b - h0_a + h1_a

restriction_ranks = {}
for c2 in (2, 3):
    total = h0_tables[c2][4]
    restriction_ranks[c2] = [total - h0_tables[c2][4 - d] for d in range(1, 5)]

assert restriction_ranks[2] == [18, 33, 45, 53]
assert restriction_ranks[3] == [18, 33, 45, 51]
print("transformed-bundle cohomology and restriction ranks: PASS")


def rank_one_bound(d: int) -> int:
    values = []
    for m in range(-2 * d, 2 * d + 1):
        quot_tangent = max(d - 2 * m + 1, 0)
        scalar = max(2 * m + 4 * d + 1, 0)
        values.append(quot_tangent + scalar)
    return max(values)


assert [rank_one_bound(d) for d in range(1, 5)] == [9, 17, 25, 33]

factor_margins = {}
for c2 in (2, 3):
    rows = []
    for d, rank in enumerate(restriction_ranks[c2], start=1):
        curve_dimension = comb(d + 2, 2) - 1
        margin = rank - rank_one_bound(d) - curve_dimension
        rows.append(margin)
    factor_margins[c2] = rows

assert factor_margins[2] == [7, 11, 11, 6]
assert factor_margins[3] == [7, 11, 11, 4]
assert min(factor_margins[2] + factor_margins[3]) > 2
print("degree-one-through-four factor margins: PASS")

# Two nonjumping branches through a moving point: common rank-one constant
# costs one and two tail coefficients vanish on each branch.  The zero
# constant stratum gives the same fixed-point codimension.
fixed_two_branch_codimension = min(1 + 2 + 2, 3 + 1 + 1)
moving_point_codimension = fixed_two_branch_codimension - 2
assert fixed_two_branch_codimension == 5
assert moving_point_codimension == 3

# At the finitely many exceptional points, one line and no moving-point
# allowance give codimension three.
fixed_exceptional_codimension = min(1 + 2, 3)
assert fixed_exceptional_codimension == 3
print("proper-triple-point residual codimension: PASS")

# Conditional-space and parameter ledgers.
original_form_dimension = 72
balanced_conditional_dimension = 33 + (7 + 12)
balanced_parameter_dimension = 17 + 2 + 1
balanced_first_margin = (
    original_form_dimension
    - balanced_conditional_dimension
    - balanced_parameter_dimension
)

unbalanced_conditional_dimension = 33 + 23
unbalanced_parameter_dimension = 17 + 2 - 1
unbalanced_first_margin = (
    original_form_dimension
    - unbalanced_conditional_dimension
    - unbalanced_parameter_dimension
)

assert (balanced_conditional_dimension, balanced_first_margin) == (52, 0)
assert (unbalanced_conditional_dimension, unbalanced_first_margin) == (56, -2)
assert moving_point_codimension + balanced_first_margin > 0
assert moving_point_codimension + unbalanced_first_margin > 0
print("conditional-space and final incidence margins: PASS")
print("base-point-free k=2 squared-line transformed-bundle exclusion: PASS")
