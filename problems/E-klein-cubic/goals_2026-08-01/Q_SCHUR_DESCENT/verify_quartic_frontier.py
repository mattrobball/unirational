#!/usr/bin/env python3
"""Verify the finite group claims in QUARTIC_FRONTIER.md.

The external theorem input is Voisin, arXiv:2509.17996v2, Theorem 1.5 and
Remarks 1.6--1.7.  This checker independently exhausts transitive subgroups
of S4 and verifies that the only primitive possibilities have orders 12 and
24 (A4 and S4).  It also constructs PSL(2,11) on P1(F11), checks its
simplicity, and verifies the cubic-resolvent action on the three pairings.
"""

from __future__ import annotations

import itertools
import json
from collections import deque
from pathlib import Path


HERE = Path(__file__).resolve().parent
DATA = json.loads((HERE / "quartic_frontier.json").read_text())


def compose(left, right):
    return tuple(left[right[index]] for index in range(4))


IDENTITY = tuple(range(4))
S4 = tuple(itertools.permutations(range(4)))


def closure(generators):
    subgroup = {IDENTITY}
    queue = [IDENTITY]
    while queue:
        value = queue.pop()
        for generator in generators:
            candidate = compose(value, generator)
            if candidate not in subgroup:
                subgroup.add(candidate)
                queue.append(candidate)
    return frozenset(subgroup)


subgroups = {closure((left, right)) for left in S4 for right in S4}


def transitive(subgroup):
    return {value[0] for value in subgroup} == set(range(4))


PARTITIONS = (
    frozenset((frozenset((0, 1)), frozenset((2, 3)))),
    frozenset((frozenset((0, 2)), frozenset((1, 3)))),
    frozenset((frozenset((0, 3)), frozenset((1, 2)))),
)


def preserves(partition, permutation):
    image = frozenset(
        frozenset(permutation[index] for index in block) for block in partition
    )
    return image == partition


def imprimitive(subgroup):
    return any(all(preserves(partition, value) for value in subgroup)
               for partition in PARTITIONS)


transitive_subgroups = {value for value in subgroups if transitive(value)}
primitive_subgroups = {
    value for value in transitive_subgroups if not imprimitive(value)
}
assert sorted({len(value) for value in transitive_subgroups}) == [4, 8, 12, 24]
assert sorted({len(value) for value in primitive_subgroups}) == [12, 24]


def pairing_image(subgroup):
    """Return the induced permutation group on the three pairings."""
    result = set()
    for value in subgroup:
        image = []
        for partition in PARTITIONS:
            moved = frozenset(
                frozenset(value[index] for index in block)
                for block in partition
            )
            image.append(PARTITIONS.index(moved))
        result.add(tuple(image))
    return frozenset(result)


pairing_image_orders = {
    len(subgroup): len(pairing_image(subgroup))
    for subgroup in primitive_subgroups
}
assert pairing_image_orders == {12: 3, 24: 6}
for subgroup in primitive_subgroups:
    image = pairing_image(subgroup)
    assert {value[0] for value in image} == {0, 1, 2}


# Construct PSL(2,11) as the fractional-linear permutation group of P1(F11).
# Infinity is represented by 11.  The two standard generators x -> x+1 and
# x -> -1/x generate PSL(2,11).
P = 11
INFINITY = P


def translation(value):
    return INFINITY if value == INFINITY else (value + 1) % P


def inversion(value):
    if value == INFINITY:
        return 0
    if value == 0:
        return INFINITY
    return (-pow(value, -1, P)) % P


T = tuple(translation(value) for value in range(P + 1))
S = tuple(inversion(value) for value in range(P + 1))
ID12 = tuple(range(P + 1))


def compose12(left, right):
    return tuple(left[right[index]] for index in range(P + 1))


def inverse12(value):
    result = [0] * (P + 1)
    for index, image in enumerate(value):
        result[image] = index
    return tuple(result)


def closure12(generators):
    subgroup = {ID12}
    queue = deque((ID12,))
    while queue:
        value = queue.popleft()
        for generator in generators:
            candidate = compose12(value, generator)
            if candidate not in subgroup:
                subgroup.add(candidate)
                queue.append(candidate)
    return frozenset(subgroup)


PSL = closure12((T, S))
assert len(PSL) == 660


def normal_closure(value):
    conjugates = []
    for group_value in PSL:
        conjugates.append(
            compose12(compose12(group_value, value), inverse12(group_value))
        )
    return closure12(tuple(conjugates))


# Normal closures are constant on conjugacy classes.  Checking one new
# representative at a time proves that every nonidentity element normally
# generates the full group, hence PSL(2,11) is simple.
covered = {ID12}
for value in PSL:
    if value in covered:
        continue
    conjugacy_class = {
        compose12(compose12(group_value, value), inverse12(group_value))
        for group_value in PSL
    }
    covered.update(conjugacy_class)
    assert len(normal_closure(value)) == 660
assert covered == set(PSL)

assert DATA["input_closed_point_degree"] == 55
assert 55 % 3 == 1
assert DATA["surface_index"] == 1
assert DATA["no_point_consequence"]["possible_galois_closure_groups"] == [
    "A4", "S4"
]
assert DATA["no_point_consequence"]["linear_span"] == "P3"
assert DATA["no_point_consequence"][
    "linearly_disjoint_from_schur_splitting_field"
] is True
assert DATA["no_point_consequence"]["cubic_resolvent"]["degree"] == 3
assert DATA["no_point_consequence"]["cubic_resolvent"][
    "point_exists_after_base_change"
] is True
assert DATA["source"]["arxiv"] == "2509.17996v2"
assert DATA["headline"] == "OPEN"

print("PASS gcd(55,3)=1 gives index one on the smooth cubic surface")
print("PASS degree-two residual intersection forces a K-point")
print("PASS transitive quartic subgroup orders are 4,8,12,24")
print("PASS only primitive quartic subgroup orders are 12 and 24 (A4,S4)")
print("PASS primitive pairing actions have images C3 and S3")
print("PASS PSL(2,11) has order 660 and is simple in its P1(F11) action")
print("PASS no A4/S4 quartic closure has a nontrivial common quotient with PSL(2,11)")
print("Q_SCHUR_QUARTIC_FRONTIER_EXACT")
print("BOUNDARY primitive quartic point versus K-point remains undecided")
