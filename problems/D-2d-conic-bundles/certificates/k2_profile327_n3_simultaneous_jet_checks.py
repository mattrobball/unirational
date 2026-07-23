#!/usr/bin/env python3
"""Arithmetic replay for the n=3 simultaneous-jet frontier."""


def check(condition: bool, label: str) -> None:
    if not condition:
        raise AssertionError(label)
    print(f"{label}: PASS")


# Shared extension space and exact first-line kernel.
check(6 * 3 == 18, "h0 Q2(-3)")
check(18 - 6 == 12, "single-line restriction dimension")
check(18 < 2 * 12, "two-line restrictions are coupled")

# Full selected-line bounds by value rank and splitting.
full_selected = {
    (1, "balanced"): 4,
    (1, "unbalanced"): 3,
    (0, "balanced"): 4,
    (0, "unbalanced"): 4,
}
check(min(full_selected.values()) == 3,
      "full selected-line raw minimum")

# Constant-matrix bounds after the first line has been fixed.
constant_selected = {
    (1, "balanced", "ordinary"): 4,
    (1, "balanced", "cross"): 3,
    (1, "unbalanced_unramified", "ordinary"): 3,
    (1, "unbalanced_unramified", "cross"): 2,
    (1, "unbalanced_ramified", "ordinary"): 2,
    (1, "unbalanced_ramified", "cross"): 2,
    (0, "balanced", "ordinary"): 3,
    (0, "balanced", "cross"): 2,
    (0, "unbalanced_unramified", "ordinary"): 3,
    (0, "unbalanced_unramified", "cross"): 2,
    (0, "unbalanced_ramified", "ordinary"): 2,
    (0, "unbalanced_ramified", "cross"): 1,
}
check(min(value for key, value in constant_selected.items()
          if key[0] == 1) == 2,
      "rank-one constant-matrix raw minimum")
check(min(value for key, value in constant_selected.items()
          if key[0] == 0) == 1,
      "rank-zero constant-matrix raw minimum")

# Raw two-line jet codimension c, splitting codimension e, and ancillary
# ramification/cross cost d are disjoint.  The target is c+d >= 8-e.
def meets_three_point_target(c_raw: int, e_split: int,
                             d_ancillary: int) -> bool:
    return c_raw + d_ancillary >= 8 - e_split


check(meets_three_point_target(8, 0, 0),
      "raw ledger balanced rank-one pair")
check(meets_three_point_target(7, 1, 0),
      "raw ledger one unbalanced rank-one pair")
check(meets_three_point_target(6, 2, 0),
      "raw ledger two unbalanced rank-one pair")
check(meets_three_point_target(6, 1, 1),
      "raw ledger ramified-flat rank-one second line")
check(meets_three_point_target(7, 0, 1),
      "raw ledger balanced cross rank-one second line")
check(meets_three_point_target(8, 0, 0),
      "raw ledger rank-zero then balanced rank-one")
check(meets_three_point_target(7, 1, 0),
      "raw ledger rank-zero then unbalanced rank-one")
check(meets_three_point_target(6, 1, 1),
      "raw ledger rank-zero then ramified rank-one")
check(4 + 3 == 7, "balanced rank-zero pair")
check(4 + 2 + 1 == 7, "ramified rank-zero second line")
check(4 + 2 + 1 == 7, "cross rank-zero second line")
check(4 + 3 + 1 == 8,
      "reverse-ordered rank-zero pair plus unused directed cross")

# Required simultaneous codimensions.
for unbalanced_codim in range(3):
    check(7 >= 6 - unbalanced_codim,
          f"two-point threshold e={unbalanced_codim}")
check(7 >= 8 - 1, "rank-zero pair with an unbalanced line")
check(7 < 8, "balanced rank-zero pair is one condition short")

# Coincidence costs.
check(4 + 2 == 6, "two balanced coincident lines")
check(3 + 2 == 6 - 1, "two unbalanced coincident lines")
check(4 + 4 == 8, "three balanced coincident lines")
check(3 + 4 == 8 - 1, "three unbalanced coincident lines")

# Deleted-cubic incidence margins.
check(30 - 2 == 28, "nonproper-deleted fixed cubic codimension")
check(16 + 3 + 17 == 36, "n=3 full moving dimension")
check(28 + 6 + 3 - 36 == 1,
      "nonproper-deleted integral cubic margin")
check((30 - 2) + 7 - (31 + 2) == 2,
      "two-selected proper-deleted margin")
check((30 - 3) + 8 - (31 + 3) == 1,
      "three-selected generic margin")
check((30 - 3) + 7 - (31 + 3) == 0,
      "three-balanced-rank-zero local zero margin")

# The flat dependency has a three-dimensional constant rank-one cone.
ambient_constant_matrices = 6
rank_one_symmetric_cone = 3
check(ambient_constant_matrices - rank_one_symmetric_cone == 3,
      "flat constant rank-one cone codimension")

# Fixed integral-cubic fiber repair.  The c=0 boundary has the higher
# diagonal entry in degrees 24-2*alpha, and rank zero cuts evaluation once.
splitting_rows = []
for alpha in (1, 2, 3):
    lower_degree = 12 + 2 * alpha
    middle_degree = 18
    higher_degree = 24 - 2 * alpha
    c_zero_fiber = higher_degree + 1
    rank_zero_c_zero_fiber = c_zero_fiber - 1
    splitting_rows.append(
        (alpha, lower_degree, middle_degree, higher_degree,
         c_zero_fiber, rank_zero_c_zero_fiber)
    )
check(splitting_rows == [
    (1, 14, 18, 22, 23, 22),
    (2, 16, 18, 20, 21, 20),
    (3, 18, 18, 18, 19, 18),
], "integral-cubic splitting and rank-zero fibers")
check(max(20, max(row[-1] for row in splitting_rows)) == 22,
      "uniform fixed rank-zero fiber bound")
check(22 + 4 == 26 and 54 - 26 == 28,
      "rank-zero fixed cubic codimension")
check(28 + 7 - 34 == 1,
      "three-balanced-rank-zero repaired margin")

print("n=3 simultaneous-jet and fixed-fiber reduction: PASS")
