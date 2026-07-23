#!/usr/bin/env python3
"""Arithmetic replay for the one-nonproper-singleton [3,2^7] exclusion."""

from math import ceil


def check(condition: bool, label: str) -> None:
    if not condition:
        raise AssertionError(label)
    print(f"{label}: PASS")


# Adjoint colength and local contact.
check(3 + 7 == 10, "cubic adjoint colength")
check(3 + 3 == 6, "nonproper singleton tangent contact")
check([10 + 3 * (7 - n) + 2 * n for n in range(8)]
      == [31 - n for n in range(8)]
      and [n for n in range(8) if 31 - n >= 28] == [0, 1, 2, 3],
      "doubled-adjoint singleton bound n<=3")

# Section 2.1, unbalanced affine six-jet valuation table.
unbalanced_outside = []
for s in range(6):
    c_dim = max(2 - min(s, 2), 0)
    b_dim = max(4 - ceil(s / 2), 0)
    unbalanced_outside.append(c_dim + b_dim + s)
check(unbalanced_outside == [6, 5, 5, 5, 6, 6],
      "unbalanced outside-cubic valuation table")
check(6 + 1 == 7 and 12 - 7 == 5,
      "unbalanced outside-cubic zero boundary")

# For ord(C)=1,...,5 the three summands in (2.3) give these totals;
# C=0 has dimension 5.  The separate unit/unit Jacobian audit has
# dimension 6, including its e1=e2=0 exceptional locus.
balanced_nonunit = []
for s in range(1, 6):
    c_dim = max(4 - s, 0)
    b_dim = 4 - ceil(s / 2)
    kernel_dim = max(s - 2, 0)
    balanced_nonunit.append(c_dim + b_dim + kernel_dim)
check(balanced_nonunit == [6, 5, 4, 4, 4]
      and max(6, 5, *balanced_nonunit) == 6 and 12 - 6 == 6,
      "balanced outside-cubic six-jet codimension")

# Transverse-cubic jet bounds.
check(12 - 8 == 4, "balanced transverse six-jet codimension")
check(11 - 8 == 3, "unbalanced transverse six-jet codimension")

# Integral-cubic contacts and margins.
check(2 * 6 + 6 * 4 == 36, "cubic contact with nonproper label omitted")
check(30 + 6 - (14 + 3 + 17) == 2,
      "omitted nonproper balanced margin")
check(30 + 5 - (14 + 3 + 16) == 2,
      "omitted nonproper unbalanced margin")
check(2 * 6 + 5 * 4 + 3 == 35, "transverse selected-nonproper contact")
check(2 * 6 + 5 * 4 + 6 == 38, "tangent selected-nonproper contact")
check(54 - (23 + 2) == 29, "selected-nonproper cubic codimension")
check(29 + 4 - (14 + 1 + 17) == 1,
      "selected-nonproper balanced margin")
check(29 + 3 - (14 + 1 + 16) == 1,
      "selected-nonproper unbalanced margin")

# Block capacities and distinct-component tests.
check(6 + 4 + 3 > 12, "every P block is a branch line")
check(6 + 4 * 4 + 3 > 24, "every integral Q block is a branch conic")
check(5 + 5 * 3 + 2 > 20, "six-low conic would be doubled")
check(6 + 3 * 4 + 3 > 12, "exceptional four-low line is a component")
check(max(5, 3, 2) < 7, "one component cannot cover seven labels")

print("one-nonproper-singleton [3,2^7] exclusion: PASS")
