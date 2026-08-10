#!/usr/bin/env python3
"""Exact checks for the O_{Q(sqrt(-11))} norm sieve.

Only Python integer arithmetic is used.  The positive-definite identity
  x^2 + x y + 3 y^2 = (2x+y)^2/4 + 11 y^2/4
makes each bounded search rigorous.
"""
from __future__ import annotations

from math import isqrt


def norm(x: int, y: int) -> int:
    return x * x + x * y + 3 * y * y


def representations(n: int) -> list[tuple[int, int]]:
    if n < 0:
        return []
    # 4Q=(2x+y)^2+11y^2.  Hence |y| <= sqrt(4n/11), and
    # |2x+y| <= 2sqrt(n).  The bounds below are deliberately inclusive.
    y_bound = isqrt((4 * n) // 11) + 1
    t_bound = 2 * isqrt(n) + 2
    out: list[tuple[int, int]] = []
    for y in range(-y_bound, y_bound + 1):
        for t in range(-t_bound, t_bound + 1):
            if (t - y) % 2:
                continue
            x = (t - y) // 2
            if norm(x, y) == n:
                out.append((x, y))
    return sorted(set(out))


def main() -> None:
    required = {
        1: True,
        2: False,
        3: True,
        5: True,
        25: True,
    }
    for n, expected in required.items():
        reps = representations(n)
        assert bool(reps) is expected, (n, reps, expected)

    # Named witnesses used in the theorem packet.
    assert norm(1, 0) == 1
    assert norm(0, 1) == 3
    assert norm(1, 1) == 5
    assert norm(5, 0) == 25

    # The FULL_G_SELFMAP_CLASSIFICATION ledger contains degree 1, excludes
    # degree 2, permits an unspecified delta >= 3 and its powers, and audits
    # degree 3 separately.  The concrete entries are therefore compatible.
    ledger = {
        "identity": 1,
        "degree_two_excluded": 2,
        "degree_three_audited": 3,
        "elliptic_minus_five_scalar_norm": 25,
    }
    assert representations(ledger["identity"])
    assert not representations(ledger["degree_two_excluded"])
    assert representations(ledger["degree_three_audited"])
    assert representations(ledger["elliptic_minus_five_scalar_norm"])

    print("CM_NORM_FORM_EXACT_OK")
    print("DEGREE_1_REPRESENTED_OK")
    print("DEGREE_2_NOT_REPRESENTED_OK")
    print("DEGREE_3_REPRESENTED_OK")
    print("DEGREE_5_REPRESENTED_OK")
    print("MINUS_5_SCALAR_NORM_25_OK")
    print("FULL_G_SELFMAP_DEGREE_LEDGER_COMPATIBLE_OK")


if __name__ == "__main__":
    main()
