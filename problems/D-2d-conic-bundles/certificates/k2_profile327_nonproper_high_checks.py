#!/usr/bin/env python3
"""Replay the nonproper-high proximity and unloading ledger."""

from math import comb


def check(condition: bool, label: str) -> None:
    if not condition:
        raise AssertionError(label)
    print(f"{label}: PASS")


rows = []
for r_q in (6, 7):
    for e_q in (0, 1, 2):
        m_q = r_q - e_q
        for r_w in (2, 3, 4, 5):
            for e_w in range(3):
                m_w = r_w - e_w
                if m_w >= m_q:
                    rows.append((r_q, e_q, m_q, r_w, e_w, m_w))
check(rows == [(6, 1, 5, 5, 0, 5),
               (6, 2, 4, 4, 0, 4),
               (6, 2, 4, 5, 0, 5),
               (6, 2, 4, 5, 1, 4),
               (7, 2, 5, 5, 0, 5)],
      "numerical predecessor candidates")

check(5 + 5 > 5 and 2 * 4 > 5,
      "satellite candidates violate older-parent proximity")

def length(weights: tuple[int, ...]) -> int:
    return sum(comb(weight + 1, 2) for weight in weights)


check(length((2, 1)) == 4, "cubic unloaded length")
check(length((3, 3)) == 12 and length((2, 4)) == 13,
      "doubled unloaded defect one")
check([n for n in range(7) if 1 + n <= 31 - 28] == [0, 1, 2],
      "remaining singleton bound n<=2")

print("nonproper-high [3,2^7] reduction: PASS")
