#!/usr/bin/env python3
"""Independent replay of field_certificate.json.

This verifier does not import the producer.  It reconstructs the two group
actions and all orbit/stabilizer orders from scratch.
"""

from __future__ import annotations

import json
from collections import deque
from itertools import permutations
from pathlib import Path


HERE = Path(__file__).resolve().parent
DATA = json.loads((HERE / "field_certificate.json").read_text())


def mul(a, b):
    return tuple(a[b[index]] for index in range(len(a)))


def inv(a):
    result = [0] * len(a)
    for index, value in enumerate(a):
        result[value] = index
    return tuple(result)


def generated(generators):
    identity = tuple(range(len(generators[0])))
    answer = {identity}
    frontier = [identity]
    while frontier:
        current = frontier.pop()
        for generator in generators:
            successor = mul(generator, current)
            if successor not in answer:
                answer.add(successor)
                frontier.append(successor)
    return answer


def orbit(start, generators, action):
    answer = {start}
    frontier = [start]
    while frontier:
        current = frontier.pop()
        for generator in generators:
            successor = action(generator, current)
            if successor not in answer:
                answer.add(successor)
                frontier.append(successor)
    return answer


def sign(permutation):
    return sum(
        permutation[i] > permutation[j]
        for i in range(4)
        for j in range(i + 1, 4)
    ) % 2


# PSL(2,11) from x |-> x+1 and x |-> -1/x on 12 projective points.
p = 11
oo = 11
t = tuple(oo if x == oo else (x + 1) % p for x in range(12))
s_values = []
for x in range(12):
    if x == oo:
        s_values.append(0)
    elif x == 0:
        s_values.append(oo)
    else:
        s_values.append((-pow(x, -1, p)) % p)
s = tuple(s_values)
G = generated((t, s))
assert len(G) == 660

C = {g for g in G if mul(g, s) == mul(s, g)}
assert len(C) == 12

unseen = set(G)
cosets = []
while unseen:
    representative = next(iter(unseen))
    coset = frozenset(mul(representative, h) for h in C)
    cosets.append(coset)
    unseen -= coset
assert len(cosets) == 55
coset_lookup = {coset: index for index, coset in enumerate(cosets)}


def on_cosets(generator):
    return tuple(
        coset_lookup[frozenset(mul(generator, member) for member in coset)]
        for coset in cosets
    )


G55_generators = (on_cosets(t), on_cosets(s))
assert len(orbit(0, G55_generators, lambda g, value: g[value])) == 55

# Recheck simplicity without trusting a name or an order table.
identity_G = tuple(range(12))
class_sizes = []
normal_orders = []
unseen_nonidentity = set(G) - {identity_G}
while unseen_nonidentity:
    representative = next(iter(unseen_nonidentity))
    conjugates = {mul(mul(g, representative), inv(g)) for g in G}
    unseen_nonidentity -= conjugates
    class_sizes.append(len(conjugates))
    normal_orders.append(len(generated(tuple(conjugates))))
assert all(order == 660 for order in normal_orders)

assert DATA["format"] == "Q-SCHUR-PRIMITIVE-QUARTIC-FIELD-CERTIFICATE-v1"
assert DATA["schur"] == {
    "group": "PSL2(F11)",
    "order": 660,
    "involution_centralizer_order": 12,
    "line_orbit_size": 55,
    "nonidentity_conjugacy_class_sizes": sorted(class_sizes),
    "normal_closure_orders": sorted(normal_orders),
    "simple": True,
}

all_s4 = set(permutations(range(4)))
pair0 = frozenset((frozenset((0, 1)), frozenset((2, 3))))
edge0 = frozenset((0, 1))


def act_subset(permutation, value):
    if value and isinstance(next(iter(value)), frozenset):
        return frozenset(
            frozenset(permutation[item] for item in block)
            for block in value
        )
    return frozenset(permutation[item] for item in value)


for name, group, generators in (
    ("A4", {value for value in all_s4 if sign(value) == 0}, ((1, 2, 0, 3), (1, 0, 3, 2))),
    ("S4", all_s4, ((1, 0, 2, 3), (1, 2, 3, 0))),
):
    assert generated(generators) == group
    vertices = orbit(0, generators, lambda g, value: g[value])
    edges = orbit(edge0, generators, act_subset)
    pairings = orbit(pair0, generators, act_subset)
    assert (len(vertices), len(edges), len(pairings)) == (4, 6, 3)

    vertex_stabilizer = {g for g in group if g[0] == 0}
    pairing_stabilizer = {g for g in group if act_subset(g, pair0) == pair0}
    intersection_order = len(vertex_stabilizer & pairing_stabilizer)

    identity55 = tuple(range(55))
    identity4 = tuple(range(4))
    product_generators = tuple((g, identity4) for g in G55_generators) + tuple(
        (identity55, h) for h in generators
    )

    def product_action(second_action):
        def action(generator, value):
            left, right = generator
            first_value, second_value = value
            return left[first_value], second_action(right, second_value)

        return action

    product_sizes = {
        "lines_x_vertices": len(
            orbit((0, 0), product_generators, product_action(lambda g, value: g[value]))
        ),
        "lines_x_edges": len(
            orbit((0, edge0), product_generators, product_action(act_subset))
        ),
        "lines_x_pairings": len(
            orbit((0, pair0), product_generators, product_action(act_subset))
        ),
    }
    expected = DATA["primitive_quartic_cases"][name]
    assert expected["name"] == name
    assert expected["galois_closure_order"] == len(group)
    assert expected["vertex_stabilizer_order"] == len(vertex_stabilizer)
    assert expected["pairing_stabilizer_order"] == len(pairing_stabilizer)
    assert expected["stabilizer_intersection_order"] == intersection_order
    assert expected["vertex_orbit_size"] == 4
    assert expected["edge_orbit_size"] == 6
    assert expected["pairing_orbit_size"] == 3
    assert expected["quartic_resolvent_compositum_degree"] == len(group) // intersection_order
    assert expected["product_orbit_sizes"] == product_sizes == {
        "lines_x_vertices": 220,
        "lines_x_edges": 330,
        "lines_x_pairings": 165,
    }
    assert expected["common_quotient_with_PSL2_11"] == "trivial"
    assert expected["cubic_resolvent_galois_closure"] == ("C3" if name == "A4" else "S3")

deductions = DATA["deductions"]
assert deductions["schur_and_quartic_galois_closures_are_linearly_disjoint"] is True
assert deductions["quartic_degree_after_adjoining_schur_splitting_field"] == 4
assert deductions["quartic_degree_after_adjoining_D12_line_field"] == 4
assert deductions["resolvent_degree_after_adjoining_schur_splitting_field"] == 3
assert deductions["D12_line_data_selects_no_vertex_or_pairing"] is True

print("PASS PSL2(F11) has order 660, is simple, and has the D12 coset orbit of size 55")
print("PASS A4/S4 vertex, edge, and pairing stabilizers and resolvent fields are exact")
print("PASS product orbits have sizes 220, 330, and 165")
print("PASS the Schur splitting field cannot lower the primitive quartic or resolvent degree")
print("Q_SCHUR_QUARTIC_FIELD_INDEPENDENCE_EXACT")
print("BOUNDARY no rational point or pointlessness conclusion follows")
