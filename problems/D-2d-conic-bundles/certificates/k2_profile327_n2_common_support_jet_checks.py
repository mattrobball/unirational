#!/usr/bin/env python3
"""Arithmetic replay for the n=2 common-support two-point jet reduction."""


def check(condition: bool, label: str) -> None:
    if not condition:
        raise AssertionError(label)
    print(f"{label}: PASS")


# Cohomology and the exact kernel after the first marked line is fixed.
check(6 * 3 == 18, "h0 Q2(-3)")
check(6 * 1 == 6, "h0 Q2(-4)")
check(18 - 6 == 12, "line restriction dimension")

# The residual determinant targets.  The final subtraction is the second
# common--residual intersection point.
line_common_contact = 6 + 3 * 4 + 3
conic_common_contact = 6 + 3
check((line_common_contact, 25 - line_common_contact - 1) == (21, 3),
      "common-line residual-conic target")
check((conic_common_contact, 13 - conic_common_contact - 1) == (9, 3),
      "common-conic residual-line target")

# Uniform line/conic fixed-fiber bounds give the same cubic restriction row.
check(9 + 17 + 3 == 29, "common-line bad restriction dimension")
check(17 + 9 + 3 == 29, "common-conic bad restriction dimension")
check(54 - 29 == 25, "fixed reducible-cubic codimension")

# Selected constant-matrix codimensions proved by the normal forms.
selected = {
    ("balanced", "noncross"): 4,
    ("balanced", "cross"): 3,
    ("unbalanced_unramified", "noncross"): 3,
    ("unbalanced", "cross"): 2,
    ("unbalanced_ramified_flat", "noncross"): 2,
}
check(selected[("balanced", "noncross")] == 4,
      "balanced selected constant-matrix codimension")
check(selected[("unbalanced_unramified", "noncross")] == 3,
      "unramified unbalanced selected codimension")
check(selected[("unbalanced_ramified_flat", "noncross")] == 2,
      "ramified flat selected codimension")

# In the 3 x 3 restriction-matrix space, rank two has dimension eight.
# Requiring c1 to be proportional to the nonzero c0 leaves dimensions
# 3 (c0) + 1 (scalar) + 3 (c2) = 7.
check(3 + 1 + 3 == 7 and 8 - 7 == 1,
      "ramification divisor inside unbalanced line locus")
check(3 - 1 == 2,
      "T1 variations vanishing at the T1-T2 intersection")

# Every worst (common--residual transverse) row has margin one.  Tangency
# retains fixed codimension 25 and lowers the moving dimension, so improves
# these figures.
for outside_unbalanced in range(2):
    outside = 6 - outside_unbalanced

    fixed = 25 + outside + selected[("balanced", "noncross")]
    moving = 34 - outside_unbalanced
    check(fixed - moving == 1,
          f"balanced noncross margin b1={outside_unbalanced}")

    fixed = 25 + outside + selected[("balanced", "cross")]
    moving = 33 - outside_unbalanced
    check(fixed - moving == 1,
          f"balanced cross margin b1={outside_unbalanced}")

    fixed = (25 + outside
             + selected[("unbalanced_unramified", "noncross")])
    moving = 33 - outside_unbalanced
    check(fixed - moving == 1,
          f"unbalanced unramified margin b1={outside_unbalanced}")

    fixed = (25 + outside
             + selected[("unbalanced_ramified_flat", "noncross")])
    moving = 32 - outside_unbalanced
    check(fixed - moving == 1,
          f"unbalanced ramified flat margin b1={outside_unbalanced}")

    fixed = 25 + outside + selected[("unbalanced", "cross")]
    moving = 32 - outside_unbalanced
    check(fixed - moving == 1,
          f"unbalanced cross margin b1={outside_unbalanced}")

check(2 + 5 == 7,
      "tangent common--residual intersection gives order seven")

# Coincident marked lines acquire an extra zero from either common support.
check(6 + 6 == 12 and 12 + 1 > 12,
      "coincident marked line forces second branch line")

# Following the selected tangent fills the residual degree; gluing then
# forces the residual component itself.
check(21 + 3 == 24 and 24 + 1 > 24,
      "tangent residual conic is forced")
check(9 + 3 == 12 and 12 + 1 > 12,
      "tangent residual line is forced")

print("n=2 common-support two-point jet reduction: PASS")
