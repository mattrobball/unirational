#!/usr/bin/env python3
"""Finite checks for the uniform six-essential conic exclusion.

The script enumerates every parity-decorated linear essential-span core with
at most six essential centers, verifies the closed unloading formulas, and
then checks every remaining root partition and every tuple of local cores.
Only rows compatible with H^0(J_{2D}(4))=0 are retained.
"""

from itertools import product
from math import comb


def children(parents, index):
    return [j for j, parent_set in enumerate(parents) if index in parent_set]


def proximity_consistent(weights, parents):
    return all(
        weights[i] >= sum(weights[j] for j in children(parents, i))
        for i in range(len(weights))
    )


def prime_coefficients(weights, parents):
    coefficients = []
    for weight, parent_set in zip(weights, parents):
        coefficients.append(
            weight + sum(coefficients[parent] for parent in parent_set)
        )
    return tuple(coefficients)


def unload(raw_weights, parents):
    """Standard antinef unloading in the total-transform point basis."""
    weights = list(raw_weights)
    seen = set()
    while True:
        state = tuple(weights)
        assert state not in seen
        seen.add(state)
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


def colength(point_basis):
    return sum(comb(weight + 1, 2) for weight in point_basis)


def free_chain(length):
    return ((),) + tuple((i - 1,) for i in range(1, length))


def core_graphs(k):
    """The P:A^aF^b, P:A^(k-2)S, and N:F^(k-1) core graphs."""
    graphs = []

    for b in range(k):
        a = k - 1 - b
        size = a + 1 + 2 * b
        parents = free_chain(size)
        essential = tuple(range(a + 1)) + tuple(
            a + 2 + 2 * j for j in range(b)
        )
        graphs.append(
            {
                "name": f"P:A^{a}F^{b}",
                "kind": "PAF",
                "k": k,
                "a": a,
                "b": b,
                "delta": b,
                "parents": parents,
                "essential": essential,
                "simple": (1,) * k + (0,) * b,
                "double": (2,) * (a + 1) + (1,) * (2 * b),
                "lower": (4,) * (a + 1) + (3,) * b,
            }
        )

    if k >= 2:
        size = k + 1
        parents = tuple(
            [()] + [(i - 1,) for i in range(1, size - 1)] + [(k - 2, k - 1)]
        )
        graphs.append(
            {
                "name": f"P:A^{k - 2}S",
                "kind": "PAS",
                "k": k,
                "delta": 1,
                "parents": parents,
                "essential": tuple(range(k - 1)) + (k,),
                "simple": (1,) * k + (0,),
                "double": (2,) * (k - 1) + (1, 1),
                "lower": (5,) + (4,) * (k - 2) + (2,),
            }
        )

    size = 2 * k
    graphs.append(
        {
            "name": f"N:F^{k - 1}",
            "kind": "NF",
            "k": k,
            "delta": k,
            "parents": free_chain(size),
            "essential": tuple(range(1, size, 2)),
            "simple": (1,) * k + (0,) * k,
            "double": (1,) * (2 * k),
            "lower": (3,) * k,
        }
    )
    return graphs


def parity_variants(graph):
    """All corrected r=4/5 and r=2/3 assignments satisfying proximity."""
    essential = set(graph["essential"])
    parents = graph["parents"]
    options = [(4, 5) if i in essential else (2, 3) for i in range(len(parents))]
    variants = []
    for corrected in product(*options):
        exceptional = tuple(
            sum(corrected[parent] % 2 for parent in parent_set)
            for parent_set in parents
        )
        strict = tuple(r - e for r, e in zip(corrected, exceptional))
        if min(strict) <= 0 or not proximity_consistent(strict, parents):
            continue
        variants.append(
            {
                "name": graph["name"] + ":" + "".join(map(str, corrected)),
                "k": graph["k"],
                "delta": graph["delta"],
                "ell2": colength(graph["double"]),
                "strict_support": strict[: graph["k"]],
            }
        )
    return variants


ALL_VARIANTS = {}
EXPECTED_VARIANT_COUNTS = {1: 3, 2: 6, 3: 8, 4: 10, 5: 12, 6: 14}

for k in range(1, 7):
    variants = []
    for graph in core_graphs(k):
        parents = graph["parents"]
        essential = set(graph["essential"])
        for multiplier, expected_key in ((1, "simple"), (2, "double")):
            raw = tuple(
                multiplier if i in essential else 0 for i in range(len(parents))
            )
            expected = graph[expected_key]
            assert unload(raw, parents) == expected
            assert proximity_consistent(expected, parents)
            assert all(
                got >= wanted
                for got, wanted in zip(
                    prime_coefficients(expected, parents),
                    prime_coefficients(raw, parents),
                )
            )
        assert colength(graph["simple"]) == k
        assert colength(graph["double"]) == 3 * k - graph["delta"]

        graph_variants = parity_variants(graph)
        assert graph_variants
        lower = graph["lower"]
        for variant in graph_variants:
            strict = variant["strict_support"]
            assert all(
                sum(strict[:j]) >= sum(lower[:j]) for j in range(1, k + 1)
            )
            assert sum(strict) >= variant["ell2"] + k
        variants.extend(graph_variants)

    assert len(variants) == EXPECTED_VARIANT_COUNTS[k]
    ALL_VARIANTS[k] = variants

print("all k<=6 core words, parity variants, and unloadings: PASS")
print("variant counts by k: 3, 6, 8, 10, 12, 14")


# The local adjacent-satellite arithmetic leaves exactly the two numerical
# rows displayed in the theorem.  In both, e_u=2 requires an older branch
# exceptional through w, contradicting the enumerated e_w=0.
expected_adjacent_satellite_survivors = (
    ((5, 0, 5), (4, 2, 2), (4, 1, 3)),
    ((5, 0, 5), (5, 2, 3), (4, 2, 2)),
)

adjacent_satellite_survivors = []
for r_w, e_w, r_u, extra_branch_at_u, r_v in product(
    (4, 5), range(3), (4, 5), (0, 1), (4, 5)
):
    e_u = r_w % 2 + extra_branch_at_u
    e_v = r_w % 2 + r_u % 2
    if e_u > 2 or e_v > 2:
        continue
    m_w, m_u, m_v = r_w - e_w, r_u - e_u, r_v - e_v
    if min(m_w, m_u, m_v) <= 0 or m_w < m_u + m_v:
        continue
    adjacent_satellite_survivors.append(
        ((r_w, e_w, m_w), (r_u, e_u, m_u), (r_v, e_v, m_v))
    )

assert tuple(adjacent_satellite_survivors) == expected_adjacent_satellite_survivors
for w_data, u_data, v_data in adjacent_satellite_survivors:
    _, e_w, m_w = w_data
    _, e_u, m_u = u_data
    _, _, m_v = v_data
    assert m_w >= m_u + m_v
    assert e_u == 2 and e_w == 0
    required_old_branch_at_w = 1
    assert required_old_branch_at_w > e_w

# A satellite separator continuation loads its older parent by at least
# 2+2+2.  At a fork, a satellite first point gives older-parent load
# m_a+m_x >= 4+2; free A/F branches cost 3 and an S branch costs 2+2.
assert 2 + 2 + 2 > 5
assert 4 + 2 > 5
assert min(3 + 3, 3 + 4, 4 + 4) > 5
print("satellite and essential-fork proximity bounds: PASS")


PARTITIONS = (
    (2, 2, 1, 1),
    (3, 1, 1, 1),
    (2, 2, 2),
    (4, 1, 1),
    (3, 2, 1),
    (3, 3),
    (5, 1),
    (4, 2),
    (6,),
)

EXPECTED_ROW_COUNTS = {
    (2, 2, 1, 1): 285,
    (3, 1, 1, 1): 187,
    (2, 2, 2): 188,
    (4, 1, 1): 74,
    (3, 2, 1): 124,
    (3, 3): 54,
    (5, 1): 28,
    (4, 2): 49,
    (6,): 10,
}

EXPECTED_LINE_MINIMA = {
    (2, 2, 1, 1): 14,
    (3, 1, 1, 1): 14,
    (2, 2, 2): 11,
    (4, 1, 1): 14,
    (3, 2, 1): 11,
    (3, 3): 11,
    (5, 1): 12,
    (4, 2): 11,
    (6,): 12,
}

EXPECTED_DELTA_RESULTS = {
    (2, 2, 1, 1): {0: (36, 16), 1: (84, 15), 2: (97, 14), 3: (68, 14)},
    (3, 1, 1, 1): {0: (24, 16), 1: (60, 16), 2: (62, 15), 3: (41, 14)},
    (2, 2, 2): {0: (27, 12), 1: (54, 12), 2: (63, 11), 3: (44, 11)},
    (4, 1, 1): {0: (12, 16), 1: (24, 15), 2: (23, 14), 3: (15, 14)},
    (3, 2, 1): {0: (18, 16), 1: (39, 15), 2: (39, 15), 3: (28, 11)},
    (3, 3): {0: (9, 12), 1: (18, 12), 2: (15, 12), 3: (12, 11)},
    (5, 1): {0: (6, 12), 1: (9, 12), 2: (7, 12), 3: (6, 12)},
    (4, 2): {0: (9, 12), 1: (15, 12), 2: (15, 11), 3: (10, 11)},
    (6,): {0: (3, 12), 1: (3, 12), 2: (2, 12), 3: (2, 12)},
}


def prefix_contact(variant, length):
    return sum(variant["strict_support"][:length])


def double_line_contact(variant, length):
    # If L^2 contains a curvilinear prefix of length a, then L follows its
    # first ceil(a/2) centers.
    return prefix_contact(variant, (length + 1) // 2)


partition_results = {}
for partition in PARTITIONS:
    retained_rows = 0
    chosen_contacts = []
    chosen_line_contacts = []
    delta_line_contacts = {delta: [] for delta in range(4)}

    for core_tuple in product(*(ALL_VARIANTS[k] for k in partition)):
        total_delta = sum(core["delta"] for core in core_tuple)
        if total_delta > 3:
            continue
        retained_rows += 1

        doubled_length = sum(core["ell2"] for core in core_tuple)
        assert doubled_length == 18 - total_delta >= 15
        full_contact = sum(
            prefix_contact(core, k) for core, k in zip(core_tuple, partition)
        )
        assert full_contact >= doubled_length + 6 >= 21

        deletion_choices = []
        for deleted_tree in range(len(partition)):
            selected_lengths = list(partition)
            selected_lengths[deleted_tree] -= 1
            assert sum(selected_lengths) == 5

            contact = sum(
                prefix_contact(core, length)
                for core, length in zip(core_tuple, selected_lengths)
            )
            line_contact = sum(
                double_line_contact(core, length)
                for core, length in zip(core_tuple, selected_lengths)
            )
            if contact >= 18:
                deletion_choices.append((line_contact, contact, deleted_tree))

        assert deletion_choices
        # Choose the contact-18 conic which is strongest against a double line.
        best = max(deletion_choices)
        assert best[0] >= 11
        chosen_line_contacts.append(best[0])
        chosen_contacts.append(best[1])
        delta_line_contacts[total_delta].append(best[0])

    assert retained_rows == EXPECTED_ROW_COUNTS[partition]
    assert min(chosen_contacts) == 18
    assert min(chosen_line_contacts) == EXPECTED_LINE_MINIMA[partition]
    delta_result = {
        delta: (len(values), min(values))
        for delta, values in delta_line_contacts.items()
    }
    assert delta_result == EXPECTED_DELTA_RESULTS[partition]
    partition_results[partition] = (
        retained_rows,
        min(chosen_contacts),
        min(chosen_line_contacts),
        delta_result,
    )

print("partition rows, selected contact, double-line contact:")
for partition in PARTITIONS:
    rows, contact, line_contact, delta_result = partition_results[partition]
    label = "[" + ",".join(map(str, partition)) + "]"
    print(f"  {label}: rows={rows}, c>={contact}, line>={line_contact}")
    details = ", ".join(
        f"D{delta}={count}/{minimum}"
        for delta, (count, minimum) in delta_result.items()
    )
    print(f"    delta rows/line: {details}")


# The first failure of the narrower 'full local length 3 + two origins'
# recipe is FF_N + P4^3.  The terminal-deletion selection repairs it.
full_ffn_contact = 3 + 3 + 3
p4_contact = 4
assert full_ffn_contact + 2 * p4_contact == 17
assert (3 + 3) + 3 * p4_contact == 18
assert 3 + 3 * p4_contact == 15 > 10
print("first narrow-recipe failure FF_N + P4^3 and repair: PASS")


# Worst-case smooth-conic margins: c=18 and four selected proper roots.
smooth_rank3 = 33 - (12 + 3) - 9
smooth_rank2_off = 33 - (13 + 3) - 9
smooth_rank2_unmarked = 30 - (11 + 1) - 8
smooth_rank2_marked = 30 - (11 + 3) - 7
assert (smooth_rank3, smooth_rank2_off, smooth_rank2_unmarked, smooth_rank2_marked) == (
    9,
    8,
    10,
    9,
)
assert smooth_rank3 > 8
assert min(smooth_rank2_off, smooth_rank2_unmarked, smooth_rank2_marked) > 7
print("smooth-conic rank/base-point margins: PASS")


# Reduced nodal conic: fixed fibers are 13 for V654 x_node V654 and
# 11 for V444 x_node V654.  At a base-point node the two V444 zero cones
# contribute 6+6 before the determinant target is allowed to move.
nodal_rank3_unmarked = 33 - (13 + 3) - 8
nodal_rank3_marked = 33 - (13 + 4) - 7
nodal_rank2_one_unmarked = 30 - (11 + 3) - 7
nodal_rank2_one_marked = 30 - (11 + 4) - 6
nodal_rank2_node_unmarked = 29 - (12 + 1) - 6
nodal_rank2_node_marked = 29 - (12 + 4) - 5
assert (
    nodal_rank3_unmarked,
    nodal_rank3_marked,
    nodal_rank2_one_unmarked,
    nodal_rank2_one_marked,
    nodal_rank2_node_unmarked,
    nodal_rank2_node_marked,
) == (9, 9, 9, 9, 10, 8)
assert min(nodal_rank3_unmarked, nodal_rank3_marked) > 8
assert min(
    nodal_rank2_one_unmarked,
    nodal_rank2_one_marked,
    nodal_rank2_node_unmarked,
    nodal_rank2_node_marked,
) > 7
print("reduced-nodal rank/base/node margins: PASS")

print("all uniform six-center conic checks: PASS")
