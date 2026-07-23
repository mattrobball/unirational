#!/usr/bin/env python3
"""Arithmetic checks for the class-(1,2) double-dodecic frontier."""

from math import comb


def h0_plane(degree):
    return comb(degree + 2, 2) if degree >= 0 else 0


def correction_profiles(total):
    """Nonincreasing essential t-profiles with sum binom(t,2)=total."""
    out = []

    def rec(remaining, maximum, prefix):
        if remaining == 0:
            out.append(tuple(prefix))
            return
        for t in range(min(maximum, remaining + 1), 1, -1):
            cost = comb(t, 2)
            if cost <= remaining:
                rec(remaining - cost, t, prefix + [t])

    rec(total, 20, [])
    return out


def rank_one_bound(bundle_degree, twist_degree):
    lower = -(twist_degree // 2)
    return max(
        max(bundle_degree - 2 * a + 1, 0)
        + max(2 * a + twist_degree + 1, 0)
        for a in range(lower, bundle_degree + 1)
    )


profiles_10 = correction_profiles(10)
assert profiles_10 == [
    (5,),
    (4, 3, 2),
    (4, 2, 2, 2, 2),
    (3, 3, 3, 2),
    (3, 3, 2, 2, 2, 2),
    (3, 2, 2, 2, 2, 2, 2, 2),
    (2, 2, 2, 2, 2, 2, 2, 2, 2, 2),
]
assert correction_profiles(6) == [
    (4,),
    (3, 3),
    (3, 2, 2, 2),
    (2, 2, 2, 2, 2, 2),
]
assert correction_profiles(3) == [(3,), (2, 2, 2)]
assert correction_profiles(1) == [(2,)]
print("canonical-resolution correction profiles: PASS")

rows = []
for e in range(6):
    m = 6 - e
    rows.append((e, 2 * m, comb(m - 1, 2), m - 3, 2 * m - 6, m - 6))
assert rows == [
    (0, 12, 10, 3, 6, 0),
    (1, 10, 6, 2, 4, -1),
    (2, 8, 3, 1, 2, -2),
    (3, 6, 1, 0, 0, -3),
    (4, 4, 0, -1, -2, -4),
    (5, 2, 0, -2, -4, -5),
]
print("square-factor and adjoint-system table: PASS")

K2 = 2 * (6 - 3) ** 2
chi = 2 + 6 * (6 - 3) // 2
pg = comb(3 + 2, 2)
q = 1 + pg - chi
P2_invariant = comb(6 + 2, 2)
P2_anti = 1
assert (K2, chi, pg, q, P2_invariant + P2_anti) == (18, 11, 10, 0, 29)
print("smooth double-dodecic invariants: PASS")

# In the all-t=2 profile the anti-invariant degree-zero divisor is effective.
assert profiles_10[-1] == (2,) * 10
assert all(any(t >= 3 for t in profile) for profile in profiles_10[:-1])
print("anti-invariant exclusion of [2^10]: PASS")

assert 3 * h0_plane(2) - 1 == 17
assert 6 * h0_plane(4) - 3 * h0_plane(2) == 72

factor_rows = []
for j in range(1, 7):
    kernel = 6 * h0_plane(4 - j) - 3 * h0_plane(2 - j)
    image = 72 - kernel
    rank_one = rank_one_bound(2 * j, 4 * j)
    moving = h0_plane(j) - 1
    margin = image - rank_one - moving
    factor_rows.append((j, image, rank_one, moving, margin))
assert factor_rows == [
    (1, 21, 9, 2, 10),
    (2, 39, 17, 5, 17),
    (3, 54, 25, 9, 20),
    (4, 66, 33, 14, 19),
    (5, 72, 41, 20, 11),
    (6, 72, 49, 27, -4),
]
assert [row[0] for row in factor_rows if row[-1] > 17] == [3, 4]
print("base-point-free factor-incidence margins: PASS")

proper_rows = []
for t in (3, 4, 5):
    for r in (2 * t, 2 * t + 1):
        proper_rows.append((t, r, 2 * r - 5))
assert proper_rows == [
    (3, 6, 7),
    (3, 7, 9),
    (4, 8, 11),
    (4, 9, 13),
    (5, 10, 15),
    (5, 11, 17),
]
assert max(row[-1] for row in proper_rows) == 17
print("two-line proper-multiplicity margins: PASS")

assert 21 + 21 - 3 == 39
assert 39 - 20 - 2 == 17
print("balanced doubled-line margin: PASS")
