#!/usr/bin/env python3
"""Arithmetic replay for one nonproper singleton in [3^2,2^4]."""


def check(condition: bool, label: str) -> None:
    if not condition:
        raise AssertionError(label)
    print(f"{label}: PASS")


check(2 * 3 + 4 == 10, "cubic adjoint colength")
check(12 + 3 * 4 == 24, "integral conic contact with N omitted")
check(54 - (10 + 18) == 26, "full-contact line-conic codimension")
check(26 + 5 - (10 + 3 + 17) == 1, "N-omitted worst margin")

check(12 + 2 * 4 + 3 == 23, "transverse selected-N conic contact")
check(54 - (10 + 17 + 2) == 25, "selected-N line-conic codimension")
check(25 + 4 - (10 + 1 + 17) == 1,
      "selected-N balanced margin")
check(25 + 3 - (10 + 1 + 16) == 1,
      "selected-N unbalanced margin")

check(12 + 2 * 4 + 6 > 24, "tangent selected-N conic is a component")
check(54 - (10 + 17) == 27, "line plus conic-component codimension")
check(27 + 4 - (10 + 2 + 17) == 2,
      "tangent conic ordinary omitted-point margin")
check(27 - (10 + 15) == 2,
      "tangent conic all-unbalanced omitted-point margin")

check(6 + 4 + 3 > 12, "non-L split conic supplies a branch line")
check(2 < 4, "one fixed branch-line pair cannot cover four omissions")

print("one-nonproper-singleton [3^2,2^4] exclusion: PASS")
