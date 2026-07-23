#!/usr/bin/env python3
"""Arithmetic checks for exclusion of root partition [2,1,1,1,1]."""

from math import comb


def children(parents, index):
    """Centers proximate to the center with the given index."""
    return [j for j, parent_set in enumerate(parents) if index in parent_set]


def unload(raw_weights, parents):
    """Antinef unloading by adding a violated prime exceptional curve."""
    weights = list(raw_weights)
    while True:
        violated = next(
            (
                i
                for i in range(len(weights))
                if weights[i] < sum(weights[j] for j in children(parents, i))
            ),
            None,
        )
        if violated is None:
            return tuple(weights)
        weights[violated] += 1
        for child in children(parents, violated):
            weights[child] -= 1
        assert all(weight >= 0 for weight in weights)


def cluster_length(point_basis):
    return sum(comb(weight + 1, 2) for weight in point_basis)


chain2 = ((), (0,))
chain3 = ((), (0,), (1,))
chain4 = ((), (0,), (1,), (2,))
satellite = ((), (0,), (0, 1))

core_rows = {
    "A": (chain2, (1, 1), (2, 2), (1, 1), (2, 2), 6, 8, 3),
    "F-P": (chain3, (1, 0, 1), (2, 0, 2), (1, 1, 0), (2, 1, 1), 5, 7, 2),
    "S": (satellite, (1, 0, 1), (2, 0, 2), (1, 1, 0), (2, 1, 1), 5, 7, 2),
    "F-N": (
        chain4,
        (0, 1, 0, 1),
        (0, 2, 0, 2),
        (1, 1, 0, 0),
        (1, 1, 1, 1),
        4,
        6,
        1,
    ),
}

for (
    parents,
    simple_raw,
    double_raw,
    simple_expected,
    double_expected,
    length_expected,
    _,
    _,
) in core_rows.values():
    assert unload(simple_raw, parents) == simple_expected
    assert unload(double_raw, parents) == double_expected
    assert cluster_length(simple_expected) == 2
    assert cluster_length(double_expected) == length_expected

assert unload((0, 1), chain2) == (1, 0)
assert unload((0, 2), chain2) == (1, 1)
assert cluster_length((1, 0)) == 1
assert cluster_length((1, 1)) == 2
assert cluster_length((1,)) == 1
assert cluster_length((2,)) == 3
print("two-essential and singleton unloadings: PASS")

for name, row in core_rows.items():
    doubled_length, n_max = row[5], row[7]
    admissible = [n for n in range(5) if doubled_length + 12 - n >= 15]
    assert admissible == list(range(n_max + 1)), (name, admissible)
print("quartic-colength bounds on N singletons: PASS")


def smooth_margins(contact):
    target_20 = max(21 - contact, 0)
    target_18 = max(19 - contact, 0)
    return (
        33 - (12 + target_20) - 9,
        33 - (13 + target_20) - 9,
        30 - (11 + target_18) - 8,
        30 - (11 + target_20) - 7,
    )


smooth_rows = []
for name, row in core_rows.items():
    contact_root, n_max = row[6], row[7]
    for n in range(n_max + 1):
        selected_n = max(n - 1, 0)
        contact = contact_root + 12 - selected_n
        margins = smooth_margins(contact)
        smooth_rows.append((name, n, selected_n, contact, margins))
        assert contact >= 18
        assert margins[0] >= 9
        assert min(margins[1:]) >= 8
print("smooth-conic fixed-rank margins: PASS")


def rank_one_zero_dimension(degrees):
    """UFD dimension of ac=b^2, including diagonal boundaries."""
    a_degree, b_degree, c_degree = degrees
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


assert rank_one_zero_dimension((6, 5, 4)) == 7
assert rank_one_zero_dimension((5, 4, 3)) == 6
assert rank_one_zero_dimension((4, 4, 4)) == 6
assert rank_one_zero_dimension((3, 3, 3)) == 5

two_off_base_zero = max(6 + 6, 2 + 5 + 5, 1 + 6 + 6)
mixed_zero = max(5 + 6, 2 + 4 + 5, 1 + 4 + 6)
assert (two_off_base_zero, mixed_zero) == (13, 11)
print("nodal-conic fixed-fiber bounds: PASS")

rank_three_nodal = 33 - (13 + 3) - 8
rank_two_nodal_rows = [
    33 - (13 + 3) - 8,
    30 - (11 + 2) - 7,
    30 - (11 + 1) - 7,
    30 - (11 + 3) - 6,
    29 - 13 - 6,
]
assert rank_three_nodal == 9 > 8
assert rank_two_nodal_rows == [9, 10, 11, 10, 10]
assert min(rank_two_nodal_rows) > 7
print("exceptional nodal-conic base-point margins: PASS")

print("all two-essential-partition checks: PASS")
