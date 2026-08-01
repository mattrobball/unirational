#!/usr/bin/env python3
"""Produce the exact finite-group/field-lattice certificate for quartic descent.

The two permutation groups are reconstructed from elementary generators:

* PSL(2,11) on P^1(F_11), with the D12 centralizer of an involution;
* A4 or S4 on the four embeddings of a primitive quartic point.

No CAS-specific group database is used.
"""

from __future__ import annotations

import json
from collections import deque
from itertools import permutations
from pathlib import Path


HERE = Path(__file__).resolve().parent


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    """Composition left after right."""

    return tuple(left[right[index]] for index in range(len(left)))


def inverse(value: tuple[int, ...]) -> tuple[int, ...]:
    result = [0] * len(value)
    for source, target in enumerate(value):
        result[target] = source
    return tuple(result)


def closure(generators: tuple[tuple[int, ...], ...]) -> set[tuple[int, ...]]:
    identity = tuple(range(len(generators[0])))
    result = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            successor = compose(generator, current)
            if successor not in result:
                result.add(successor)
                queue.append(successor)
    return result


def parity(value: tuple[int, ...]) -> int:
    inversions = sum(
        value[left] > value[right]
        for left in range(len(value))
        for right in range(left + 1, len(value))
    )
    return inversions % 2


def orbit(
    start,
    generators,
    action,
):
    result = {start}
    queue = deque([start])
    while queue:
        current = queue.popleft()
        for generator in generators:
            successor = action(generator, current)
            if successor not in result:
                result.add(successor)
                queue.append(successor)
    return result


def psl_2_11():
    prime = 11
    infinity = prime

    translation = tuple(
        infinity if value == infinity else (value + 1) % prime
        for value in range(prime + 1)
    )

    inversion_values = []
    for value in range(prime + 1):
        if value == infinity:
            inversion_values.append(0)
        elif value == 0:
            inversion_values.append(infinity)
        else:
            inversion_values.append((-pow(value, -1, prime)) % prime)
    inversion = tuple(inversion_values)

    group = closure((translation, inversion))
    identity = tuple(range(prime + 1))
    assert len(group) == 660
    assert compose(inversion, inversion) == identity

    centralizer = {
        element
        for element in group
        if compose(element, inversion) == compose(inversion, element)
    }
    assert len(centralizer) == 12

    # Verify simplicity directly: the normal closure of every nonidentity
    # conjugacy-class representative is the whole group.
    remaining = set(group)
    remaining.remove(identity)
    conjugacy_class_sizes = []
    normal_closure_orders = []
    while remaining:
        representative = next(iter(remaining))
        conjugates = {
            compose(compose(element, representative), inverse(element))
            for element in group
        }
        remaining.difference_update(conjugates)
        conjugacy_class_sizes.append(len(conjugates))
        normal_closure = closure(tuple(conjugates))
        normal_closure_orders.append(len(normal_closure))
        assert len(normal_closure) == 660

    # Left cosets gH and the induced 55-point action.
    unseen = set(group)
    cosets = []
    while unseen:
        representative = next(iter(unseen))
        coset = frozenset(compose(representative, member) for member in centralizer)
        cosets.append(coset)
        unseen.difference_update(coset)
    assert len(cosets) == 55
    coset_index = {coset: index for index, coset in enumerate(cosets)}

    def coset_permutation(generator):
        values = []
        for coset in cosets:
            image = frozenset(compose(generator, member) for member in coset)
            values.append(coset_index[image])
        return tuple(values)

    coset_generators = tuple(coset_permutation(value) for value in (translation, inversion))
    assert len(orbit(0, coset_generators, lambda g, x: g[x])) == 55

    return {
        "group": group,
        "generators": (translation, inversion),
        "coset_generators": coset_generators,
        "centralizer": centralizer,
        "conjugacy_class_sizes": sorted(conjugacy_class_sizes),
        "normal_closure_orders": sorted(normal_closure_orders),
    }


def quartic_group(name: str):
    symmetric = set(permutations(range(4)))
    group = symmetric if name == "S4" else {value for value in symmetric if parity(value) == 0}
    assert len(group) == (24 if name == "S4" else 12)

    if name == "S4":
        generators = ((1, 0, 2, 3), (1, 2, 3, 0))
    else:
        generators = ((1, 2, 0, 3), (1, 0, 3, 2))
    assert closure(generators) == group

    pairings = (
        frozenset((frozenset((0, 1)), frozenset((2, 3)))),
        frozenset((frozenset((0, 2)), frozenset((1, 3)))),
        frozenset((frozenset((0, 3)), frozenset((1, 2)))),
    )
    edges = tuple(frozenset((left, right)) for left in range(4) for right in range(left + 1, 4))

    def act_set(permutation, value):
        if value and isinstance(next(iter(value)), frozenset):
            return frozenset(
                frozenset(permutation[item] for item in block)
                for block in value
            )
        return frozenset(permutation[item] for item in value)

    vertex_stabilizer = {element for element in group if element[0] == 0}
    pairing_stabilizer = {element for element in group if act_set(element, pairings[0]) == pairings[0]}
    intersection = vertex_stabilizer & pairing_stabilizer

    assert len(orbit(0, generators, lambda g, x: g[x])) == 4
    assert len(orbit(edges[0], generators, act_set)) == 6
    assert len(orbit(pairings[0], generators, act_set)) == 3

    return {
        "name": name,
        "group": group,
        "generators": generators,
        "vertex_stabilizer_order": len(vertex_stabilizer),
        "pairing_stabilizer_order": len(pairing_stabilizer),
        "stabilizer_intersection_order": len(intersection),
        "vertex_orbit_size": 4,
        "edge_orbit_size": 6,
        "pairing_orbit_size": 3,
        "quartic_resolvent_compositum_degree": len(group) // len(intersection),
    }


def product_orbit_size(
    schur_generators: tuple[tuple[int, ...], ...],
    quartic_generators: tuple[tuple[int, ...], ...],
    second_start,
    second_action,
) -> int:
    identity_schur = tuple(range(55))
    identity_quartic = tuple(range(4))
    generators = tuple((value, identity_quartic) for value in schur_generators) + tuple(
        (identity_schur, value) for value in quartic_generators
    )

    def action(generator, value):
        first_generator, second_generator = generator
        first, second = value
        return first_generator[first], second_action(second_generator, second)

    return len(orbit((0, second_start), generators, action))


def main() -> None:
    schur = psl_2_11()
    results = {}
    for name in ("A4", "S4"):
        quartic = quartic_group(name)
        pairings = (
            frozenset((frozenset((0, 1)), frozenset((2, 3)))),
            frozenset((frozenset((0, 2)), frozenset((1, 3)))),
            frozenset((frozenset((0, 3)), frozenset((1, 2)))),
        )
        edge = frozenset((0, 1))

        def act_nested(permutation, value):
            if value and isinstance(next(iter(value)), frozenset):
                return frozenset(
                    frozenset(permutation[item] for item in block)
                    for block in value
                )
            return frozenset(permutation[item] for item in value)

        product_sizes = {
            "lines_x_vertices": product_orbit_size(
                schur["coset_generators"], quartic["generators"], 0, lambda g, x: g[x]
            ),
            "lines_x_edges": product_orbit_size(
                schur["coset_generators"], quartic["generators"], edge, act_nested
            ),
            "lines_x_pairings": product_orbit_size(
                schur["coset_generators"], quartic["generators"], pairings[0], act_nested
            ),
        }
        assert product_sizes == {
            "lines_x_vertices": 220,
            "lines_x_edges": 330,
            "lines_x_pairings": 165,
        }

        results[name] = {
            key: value
            for key, value in quartic.items()
            if key not in {"group", "generators"}
        }
        results[name]["product_orbit_sizes"] = product_sizes
        results[name]["galois_closure_order"] = len(quartic["group"])
        results[name]["cubic_resolvent_galois_closure"] = "C3" if name == "A4" else "S3"
        results[name]["common_quotient_with_PSL2_11"] = "trivial"

    certificate = {
        "format": "Q-SCHUR-PRIMITIVE-QUARTIC-FIELD-CERTIFICATE-v1",
        "schur": {
            "group": "PSL2(F11)",
            "order": len(schur["group"]),
            "involution_centralizer_order": len(schur["centralizer"]),
            "line_orbit_size": 55,
            "nonidentity_conjugacy_class_sizes": schur["conjugacy_class_sizes"],
            "normal_closure_orders": schur["normal_closure_orders"],
            "simple": all(value == 660 for value in schur["normal_closure_orders"]),
        },
        "primitive_quartic_cases": results,
        "deductions": {
            "schur_and_quartic_galois_closures_are_linearly_disjoint": True,
            "quartic_degree_after_adjoining_schur_splitting_field": 4,
            "quartic_degree_after_adjoining_D12_line_field": 4,
            "resolvent_degree_after_adjoining_schur_splitting_field": 3,
            "D12_line_data_selects_no_vertex_or_pairing": True,
        },
        "boundary": (
            "The product-action certificate proves independence of the known Schur line data; "
            "it does not decide whether the cubic surface has a ground-field point."
        ),
    }
    (HERE / "field_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")


if __name__ == "__main__":
    main()
