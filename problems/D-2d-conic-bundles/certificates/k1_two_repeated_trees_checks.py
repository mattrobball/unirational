#!/usr/bin/env python3
"""Arithmetic checks for exclusion of root partition [2,2,1,1]."""

from itertools import combinations_with_replacement
from math import comb


def children(parents, index):
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

CORES = {
    "A44": {
        "parents": chain2,
        "m": (4, 4),
        "simple_raw": (1, 1),
        "double_raw": (2, 2),
        "simple": (1, 1),
        "double": (2, 2),
        "ell": 6,
        "rho": 4,
        "tangent": 8,
    },
    "A54": {
        "parents": chain2,
        "m": (5, 3),
        "simple_raw": (1, 1),
        "double_raw": (2, 2),
        "simple": (1, 1),
        "double": (2, 2),
        "ell": 6,
        "rho": 5,
        "tangent": 8,
    },
    "A55": {
        "parents": chain2,
        "m": (5, 4),
        "simple_raw": (1, 1),
        "double_raw": (2, 2),
        "simple": (1, 1),
        "double": (2, 2),
        "ell": 6,
        "rho": 5,
        "tangent": 9,
    },
    "FP": {
        "parents": chain3,
        "m": (4, 3, 3),
        "simple_raw": (1, 0, 1),
        "double_raw": (2, 0, 2),
        "simple": (1, 1, 0),
        "double": (2, 1, 1),
        "ell": 5,
        "rho": 4,
        "tangent": 7,
    },
    "FN": {
        "parents": chain4,
        "m": (3, 3, 3, 3),
        "simple_raw": (0, 1, 0, 1),
        "double_raw": (0, 2, 0, 2),
        "simple": (1, 1, 0, 0),
        "double": (1, 1, 1, 1),
        "ell": 4,
        "rho": 3,
        "tangent": 6,
    },
    "S": {
        "parents": satellite,
        "m": (5, 2, 2),
        "simple_raw": (1, 0, 1),
        "double_raw": (2, 0, 2),
        "simple": (1, 1, 0),
        "double": (2, 1, 1),
        "ell": 5,
        "rho": 5,
        "tangent": 7,
    },
}

for data in CORES.values():
    assert unload(data["simple_raw"], data["parents"]) == data["simple"]
    assert unload(data["double_raw"], data["parents"]) == data["double"]
    assert cluster_length(data["simple"]) == 2
    assert cluster_length(data["double"]) == data["ell"]
    assert data["rho"] == data["m"][0]
    assert data["tangent"] == data["m"][0] + data["m"][1]
    assert 2 * data["rho"] >= data["tangent"]
print("six repeated-tree cores, unloadings, and node contacts: PASS")


SINGLETONS = {
    "P4": {"ell": 3, "contact": 4},
    "P5": {"ell": 3, "contact": 5},
    "N": {"ell": 2, "contact": 3},
}
assert all(data["contact"] >= data["ell"] + 1 for data in SINGLETONS.values())
print("singleton doubled lengths and proper contacts: PASS")


for name, data in CORES.items():
    data["alpha"] = data["tangent"] - data["ell"]
    data["beta"] = data["rho"] - data["ell"]

assert {name: data["alpha"] for name, data in CORES.items()} == {
    "A44": 2,
    "A54": 2,
    "A55": 3,
    "FP": 2,
    "FN": 2,
    "S": 2,
}
assert {name: data["beta"] for name, data in CORES.items()} == {
    "A44": -2,
    "A54": -1,
    "A55": -1,
    "FP": -1,
    "FN": -1,
    "S": 0,
}

for first, second in combinations_with_replacement(CORES, 2):
    a = CORES[first]
    b = CORES[second]
    best = max(a["tangent"] + b["rho"], b["tangent"] + a["rho"])
    excess = best - a["ell"] - b["ell"]
    assert excess >= 0
    assert (excess == 0) == (first == second == "A44")
print("paired-core orientation inequality: PASS")


admissible_rows = []
for first, second in combinations_with_replacement(CORES, 2):
    a = CORES[first]
    b = CORES[second]
    best = max(a["tangent"] + b["rho"], b["tangent"] + a["rho"])
    for singleton_first, singleton_second in combinations_with_replacement(
        SINGLETONS, 2
    ):
        x = SINGLETONS[singleton_first]
        y = SINGLETONS[singleton_second]
        doubled_length = a["ell"] + b["ell"] + x["ell"] + y["ell"]
        if doubled_length < 15:
            continue
        contact = best + x["contact"] + y["contact"]
        assert contact >= 18
        support_line_contact = a["rho"] + b["rho"] + x["contact"] + y["contact"]
        assert support_line_contact >= 12 > 10
        admissible_rows.append(
            (
                first,
                second,
                singleton_first,
                singleton_second,
                doubled_length,
                contact,
            )
        )

assert len(admissible_rows) == 108
assert min(row[5] for row in admissible_rows) == 18
assert all(2 + 2 + 1 + 1 == 6 for _ in admissible_rows)
print("108 quartic-admissible parity rows have conic contact at least 18: PASS")
print("double-line support contact is always greater than 10: PASS")


def smooth_margins(contact):
    target_20 = max(21 - contact, 0)
    target_18 = max(19 - contact, 0)
    return (
        33 - (12 + target_20) - 9,
        33 - (13 + target_20) - 9,
        30 - (11 + target_18) - 8,
        30 - (11 + target_20) - 7,
    )


for row in admissible_rows:
    margins = smooth_margins(row[5])
    assert margins[0] >= 9
    assert min(margins[1:]) >= 8
print("smooth-conic fixed-rank margins: PASS")


def rank_one_zero_dimension(degrees):
    """UFD dimension of AC=B^2, including diagonal boundaries."""
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
print("nodal fixed-fiber bounds: PASS")


contact_pairs = [
    (first, second)
    for first in range(11)
    for second in range(11)
    if first + second >= 18
]
assert contact_pairs
assert all(8 <= first <= 10 and 8 <= second <= 10 for first, second in contact_pairs)

node_unmarked_target = max(21 - first - second for first, second in contact_pairs)
node_marked_target = max(22 - first - second for first, second in contact_pairs)
one_base_unmarked_target = max(
    max(9 - first, 0) + (11 - second) for first, second in contact_pairs
)
one_base_marked_target = max(22 - first - second for first, second in contact_pairs)
base_node_unmarked_target = max(
    max(9 - first, 0) + max(9 - second, 0)
    for first, second in contact_pairs
)
base_node_marked_target = max(22 - first - second for first, second in contact_pairs)

assert (
    node_unmarked_target,
    node_marked_target,
    one_base_unmarked_target,
    one_base_marked_target,
    base_node_unmarked_target,
    base_node_marked_target,
) == (3, 4, 3, 4, 1, 4)
print("all nodal determinant-target bounds: PASS")


rank_three_nodal = [
    33 - (13 + node_unmarked_target) - 8,
    33 - (13 + node_marked_target) - 7,
]
rank_two_nodal = [
    33 - (13 + node_unmarked_target) - 8,
    33 - (13 + node_marked_target) - 7,
    30 - (11 + one_base_unmarked_target) - 7,
    30 - (11 + one_base_marked_target) - 6,
    29 - (12 + base_node_unmarked_target) - 6,
    29 - (12 + base_node_marked_target) - 5,
]
assert rank_three_nodal == [9, 9]
assert rank_two_nodal == [9, 9, 9, 9, 10, 8]
assert min(rank_three_nodal) > 8
assert min(rank_two_nodal) > 7
print("all nodal and rank-two base-point margins: PASS")

print("all [2,2,1,1] exclusion checks: PASS")
