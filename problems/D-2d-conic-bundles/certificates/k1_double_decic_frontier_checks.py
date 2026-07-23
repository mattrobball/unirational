#!/usr/bin/env python3
"""Arithmetic checks for the class-(1,1) double-decic frontier."""

from math import comb


def h0_plane(degree, multiplicity=0):
    """Forms of a given degree vanishing to a given order at one point."""
    if degree < 0:
        return 0
    return comb(degree + 2, 2) - comb(multiplicity + 1, 2)


def rank_one_bound(bundle_degree, twist_degree):
    """The genus-free bound R(f,n) from equation (5.1)."""
    lower = -(twist_degree // 2)
    values = []
    for m in range(lower, bundle_degree + 1):
        values.append(
            max(bundle_degree - 2 * m + 1, 0)
            + max(2 * m + twist_degree + 1, 0)
        )
    return max(values)


def rank_one_binary_form_dimension(degrees):
    """UFD upper dimension for ac=b^2, including diagonal boundaries."""
    a_degree, b_degree, c_degree = degrees
    assert a_degree + c_degree == 2 * b_degree
    dimensions = [a_degree + 1, c_degree + 1, 0]
    for v_degree in range(c_degree // 2 + 1):
        h_degree = c_degree - 2 * v_degree
        u_degree = b_degree - h_degree - v_degree
        if u_degree < 0 or h_degree + 2 * u_degree != a_degree:
            continue
        dimensions.append(
            (h_degree + 1) + (u_degree + 1) + (v_degree + 1) - 1
        )
    return max(dimensions)


def partitions_by_correction(total, minimum=2):
    """Nonincreasing essential t-profiles with sum binom(t,2)=total."""
    out = []

    def rec(remaining, maximum, prefix):
        if remaining == 0:
            out.append(tuple(prefix))
            return
        for t in range(min(maximum, 1 + remaining), minimum - 1, -1):
            cost = comb(t, 2)
            if cost <= remaining:
                rec(remaining - cost, t, prefix + [t])

    rec(total, 10, [])
    return out


assert partitions_by_correction(6) == [
    (4,),
    (3, 3),
    (3, 2, 2, 2),
    (2, 2, 2, 2, 2, 2),
]
assert partitions_by_correction(3) == [(3,), (2, 2, 2)]
assert partitions_by_correction(1) == [(2,)]
print("canonical-resolution correction profiles: PASS")

rows = []
for e in range(5):
    m = 5 - e
    rows.append(
        (
            e,
            2 * m,
            comb(m - 1, 2),
            m - 3,
            2 * m - 6,
        )
    )
assert rows == [
    (0, 10, 6, 2, 4),
    (1, 8, 3, 1, 2),
    (2, 6, 1, 0, 0),
    (3, 4, 0, -1, -2),
    (4, 2, 0, -2, -4),
]
print("factor-degree and adjoint-system table: PASS")

K2 = 2 * (5 - 3) ** 2
chi = 2 + 5 * (5 - 3) // 2
pg = comb(2 + 2, 2)
q = 1 + pg - chi
P2 = comb(4 + 2, 2)
assert (K2, chi, pg, q, P2) == (8, 7, 6, 0, 15)
print("smooth double-decic invariants: PASS")

assert 11 - 2 == 9 > 8
assert 9 > 7
assert 8 > 7
assert (60, 18 + 18 - 3, 18 + 15 - 3, 15 + 15 - 1) == (60, 33, 30, 29)
print("proper multiplicity-six orbit margins: PASS")

assert 33 - 18 - 2 == 13 > 8
assert 37 - 23 - 1 == 13 > 7
print("squared-line orbit margins: PASS")

conic_rows = [
    ((10, 10, 10), 33, 5, 8, 16),
    ((12, 10, 8), 33, 5, 7, 15),
    ((10, 9, 8), 30, 4, 7, 15),
]
for degrees, target, moving, orbit, expected_margin in conic_rows:
    rank_one = rank_one_binary_form_dimension(degrees)
    margin = target - rank_one - moving
    assert margin == expected_margin > orbit
print("irreducible-conic orbit margins: PASS")

assert [
    rank_one_bound(3, 12),
    rank_one_bound(2, 12),
    rank_one_bound(1, 12),
] == [19, 17, 15]
assert [
    rank_one_bound(4, 16),
    rank_one_bound(3, 16),
    rank_one_bound(2, 16),
    rank_one_bound(1, 16),
] == [25, 23, 21, 19]
print("rank-one cone bounds: PASS")

cubic_image_ranks = [
    60 - 15,
    60 - (h0_plane(3, 1) + h0_plane(2) + h0_plane(1)),
    60 - (h0_plane(3) + h0_plane(2) + h0_plane(1)),
]
assert cubic_image_ranks == [45, 42, 41]
assert 45 - 19 - 9 == 17 > 8
assert 42 - 17 - 8 == 17 > 7
assert 41 - 15 - 6 == 20 > 7
print("integral-cubic restriction ranks and margins: PASS")

assert [
    h0_plane(6, 2),
    h0_plane(5, 1),
    h0_plane(4),
] == [25, 20, 15]
quartic_image_ranks = [
    60 - 6,
    60 - (h0_plane(2, 1) + h0_plane(1) + 1),
    60 - (h0_plane(2) + h0_plane(1) + 1),
    60 - (h0_plane(2) + h0_plane(1) + 1),
]
assert quartic_image_ranks == [54, 51, 50, 50]
assert 54 - 25 - 14 == 15 > 8
assert 51 - 23 - 13 == 15 > 7
assert 50 - 21 - 11 == 18 > 7
assert 50 - 19 - 8 == 23 > 7
print("integral-quartic restriction ranks and margins: PASS")

raw_nested_cases = []
for r_predecessor in (4, 5):
    predecessor_parity = r_predecessor % 2
    for r_nested in (6, 7):
        for predecessor_exceptionals in range(3):
            for other_branch_exceptional in (0, 1):
                if (
                    other_branch_exceptional > predecessor_exceptionals
                    or predecessor_parity + other_branch_exceptional > 2
                ):
                    continue
                m_predecessor = r_predecessor - predecessor_exceptionals
                m_nested = (
                    r_nested
                    - predecessor_parity
                    - other_branch_exceptional
                )
                if m_predecessor >= m_nested:
                    raw_nested_cases.append(
                        (
                            r_predecessor,
                            r_nested,
                            predecessor_exceptionals,
                            other_branch_exceptional,
                            m_predecessor,
                            m_nested,
                        )
                    )
assert raw_nested_cases == [
    (5, 6, 0, 0, 5, 5),
    (5, 6, 1, 1, 4, 4),
]
assert raw_nested_cases[1][-2] + raw_nested_cases[1][-1] == 8
print("nested profile forced local type: PASS")

rank_two_nested_images = [
    (25 - 12) + (20 - 9) + (15 - 6),
    (25 - 14) + (20 - 10) + (15 - 6),
    (25 - 15) + (20 - 10) + (15 - 6),
]
assert rank_two_nested_images == [33, 30, 29]

v654_fixed_fiber = 7
v444_fixed_fiber = 6
rank_three_nested_bad = (
    (v654_fixed_fiber + 1) + (v654_fixed_fiber + 6)
)
assert rank_three_nested_bad == 21
assert 33 - rank_three_nested_bad - 3 == 9 > 8

rank_two_away_bad = rank_three_nested_bad
assert 33 - rank_two_away_bad - 3 == 9 > 7
rank_two_through_bad = v444_fixed_fiber + (v654_fixed_fiber + 6)
assert rank_two_through_bad == 19
assert 30 - rank_two_through_bad - 2 == 9 > 7
rank_two_base_bad = (
    (v444_fixed_fiber + 1) + (v444_fixed_fiber + 6)
)
assert rank_two_base_bad == 19
assert 29 - rank_two_base_bad - 1 == 9 > 7
print("nested profile restriction ranks and orbit margins: PASS")
