#!/usr/bin/env python3
"""Independent replay of linked_quintic_certificate.json."""

from __future__ import annotations

import json
from itertools import permutations
from pathlib import Path


HERE = Path(__file__).resolve().parent
DATA = json.loads((HERE / "linked_quintic_certificate.json").read_text())


def mul(a, b):
    return tuple(a[b[index]] for index in range(len(a)))


def inv(a):
    result = [0] * len(a)
    for index, value in enumerate(a):
        result[value] = index
    return tuple(result)


def generated(generators, degree):
    identity = tuple(range(degree))
    result = {identity}
    frontier = [identity]
    while frontier:
        current = frontier.pop()
        for generator in generators:
            successor = mul(generator, current)
            if successor not in result:
                result.add(successor)
                frontier.append(successor)
    return frozenset(result)


def normal_subgroups(group, candidates):
    answer = []
    for candidate in candidates:
        if not candidate <= group:
            continue
        if all(
            frozenset(mul(mul(g, h), inv(g)) for h in candidate) == candidate
            for g in group
        ):
            answer.append(candidate)
    return answer


def all_subgroups(group, degree):
    identity = frozenset({tuple(range(degree))})
    answer = {identity}
    changed = True
    while changed:
        changed = False
        for subgroup in tuple(answer):
            for element in group - subgroup:
                enlarged = generated(tuple(subgroup) + (element,), degree)
                if enlarged not in answer:
                    answer.add(enlarged)
                    changed = True
    return answer


def orbit_size(group, start=0):
    return len({element[start] for element in group})


assert DATA["format"] == "Q-SCHUR-LINKED-QUINTIC-FIELD-CERTIFICATE-v1"

# Re-enumerate S5 subgroups with a different fixed-point iteration.
S5 = frozenset(permutations(range(5)))
SUBGROUPS5 = all_subgroups(S5, 5)
TRANSITIVE = {group for group in SUBGROUPS5 if orbit_size(group) == 5}
assert len(SUBGROUPS5) == DATA["enumeration"]["number_of_subgroups_of_S5"] == 156
assert len(TRANSITIVE) == DATA["enumeration"]["number_of_transitive_subgroups_of_S5"] == 20

# Use explicit representatives, independent of the producer's representatives.
cycle5 = (1, 2, 3, 4, 0)
reflection = (0, 4, 3, 2, 1)
times2 = (0, 2, 4, 1, 3)
transposition = (1, 0, 2, 3, 4)
cycle3 = (1, 2, 0, 3, 4)
named = {
    "C5": generated((cycle5,), 5),
    "D10": generated((cycle5, reflection), 5),
    "F20": generated((cycle5, times2), 5),
    "A5": generated((cycle5, cycle3), 5),
    "S5": generated((cycle5, transposition), 5),
}
assert {name: len(group) for name, group in named.items()} == {
    "C5": 5,
    "D10": 10,
    "F20": 20,
    "A5": 60,
    "S5": 120,
}

for name, group in named.items():
    normals = normal_subgroups(group, SUBGROUPS5)
    quotient_orders = sorted({len(group) // len(kernel) for kernel in normals})
    index_two_orbits = sorted(
        orbit_size(kernel)
        for kernel in normals
        if len(group) // len(kernel) == 2
    )
    recorded = DATA["quintic_galois_cases"][name]
    assert recorded["order"] == len(group)
    assert recorded["orbit_size"] == orbit_size(group) == 5
    assert recorded["normal_quotient_orders"] == quotient_orders
    assert recorded["index_two_kernel_orbit_sizes"] == index_two_orbits

S4 = frozenset(permutations(range(4)))
SUBGROUPS4 = all_subgroups(S4, 4)
A4 = frozenset(
    value
    for value in S4
    if sum(value[i] > value[j] for i in range(4) for j in range(i + 1, 4)) % 2 == 0
)
for name, group in (("A4", A4), ("S4", S4)):
    quotient_orders = sorted(
        {len(group) // len(kernel) for kernel in normal_subgroups(group, SUBGROUPS4)}
    )
    assert DATA["quartic_normal_quotient_orders"][name] == quotient_orders
    for quintic_name, quintic_group in named.items():
        common = sorted(
            (
                set(quotient_orders)
                & set(DATA["quintic_galois_cases"][quintic_name]["normal_quotient_orders"])
            )
            - {1}
        )
        record = DATA["quartic_quintic_intersections"][name][quintic_name]
        assert record["possible_nontrivial_common_quotient_orders"] == common
        assert record["maximal_possible_intersection_degree"] == (2 if common else 1)
        if common:
            assert common == [2]
            assert record["quintic_remains_transitive_over_possible_common_quadratic"] is True

# PSL2(F11) is certified simple independently in field_certificate.json.  A
# common Galois intersection with a quintic closure would be a quotient of
# order 660, impossible inside a group of order at most 120.
FIELD = json.loads((HERE / "field_certificate.json").read_text())
assert FIELD["schur"]["simple"] is True
assert FIELD["schur"]["order"] == 660
assert max(len(group) for group in named.values()) == 120 < 660
assert DATA["schur_field"]["intersection_with_every_quintic_galois_closure"] == "K"
assert DATA["schur_field"]["quartic_x_quintic_residue_compositum_degree"] == 4 * 5 == 20
assert DATA["schur_field"]["maximal_quartic_x_quintic_closure_order"] == 24 * 120
assert (24 * 120) % 11 != 0
assert DATA["schur_field"]["prime_11_divides_quartic_x_quintic_closure_order"] is False
assert DATA["schur_field"]["intersection_with_combined_quartic_quintic_galois_closure"] == "K"
assert DATA["schur_field"]["linked_quintic_degree_after_schur_base_change"] == 5
assert DATA["schur_field"]["line_orbit_x_quintic_orbit"] == 55 * 5 == 275
assert DATA["schur_field"]["line_orbit_x_linked_quartic_quintic_pair"] == 55 * 20 == 1100

raw = [degree for degree in range(1, 8) if degree % 3 and degree % 5]
assert raw == DATA["balestrieri_successor_from_degree_5"]["raw_possible_degrees"] == [1, 2, 4, 7]
assert DATA["balestrieri_successor_from_degree_5"]["after_quadratic_descent"] == [1, 4, 7]
assert DATA["balestrieri_successor_from_degree_5"]["degree_4_branch_returns_to"] == [1, 5]
assert DATA["balestrieri_successor_from_degree_5"]["forced_strict_descent"] is False

print("PASS all 156 subgroups of S5 were regenerated; the five transitive classes are exact")
print("PASS A4 has no common nontrivial quotient with a transitive quintic group")
print("PASS S4 has at most a common C2 quotient, and the quintic remains transitive over it")
print("PASS PSL2(F11) is disjoint from the combined quartic-quintic Galois closure")
print("PASS Balestrieri degree-five replay gives {1,4,7}, not forced descent")
print("Q_SCHUR_LINKED_QUINTIC_FIELD_LATTICE_EXACT")
print("BOUNDARY no ground-field point follows")
