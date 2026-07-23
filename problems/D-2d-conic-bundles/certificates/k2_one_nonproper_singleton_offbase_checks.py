#!/usr/bin/env python3
"""Arithmetic replay for the off-base isolated singleton reduction."""


def check(condition: bool, label: str) -> None:
    if not condition:
        raise AssertionError(label)
    print(f"{label}: PASS")


def h0(degree: int) -> int:
    return (degree + 2) * (degree + 1) // 2 if degree >= 0 else 0


restriction_ranks = tuple(
    72 - (6 * h0(4 - degree) - 3 * h0(2 - degree))
    for degree in range(1, 5)
)
check(restriction_ranks == (21, 39, 54, 66),
      "off-base restriction ranks")
check(39 - (9 + 9) - (4 + 16) == 1,
      "two-line isolated-base margin")
check(54 - (9 + 17) - (2 + 5 + 16) == 5,
      "line-conic isolated-base margin")
check(66 - (17 + 17) - (10 + 16) == 6,
      "two-conic isolated-base margin")

print("off-base one-nonproper-singleton reduction: PASS")
