#!/usr/bin/env python3
"""Produce the exact finite-group certificate for the linked quintic.

In the hypothetical no-point branch, Balestrieri's degree-four construction
gives an integral degree-five residual point on the same K-rational twisted
cubic.  This script exhaustively enumerates the transitive subgroups of S5
and computes their normal-quotient orders.  It then compares those quotients
with A4 and S4, the two possible quartic Galois groups.

The computation is deliberately database-free: every subgroup of S5 is
generated and every normal subgroup is tested directly.
"""

from __future__ import annotations

import json
from collections import deque
from itertools import permutations
from pathlib import Path


HERE = Path(__file__).resolve().parent


def mul(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(len(left)))


def inv(value: tuple[int, ...]) -> tuple[int, ...]:
    result = [0] * len(value)
    for source, target in enumerate(value):
        result[target] = source
    return tuple(result)


def generated(generators: tuple[tuple[int, ...], ...], degree: int) -> frozenset[tuple[int, ...]]:
    identity = tuple(range(degree))
    answer = {identity}
    frontier = [identity]
    while frontier:
        current = frontier.pop()
        for generator in generators:
            successor = mul(generator, current)
            if successor not in answer:
                answer.add(successor)
                frontier.append(successor)
    return frozenset(answer)


def orbit(start: int, group: frozenset[tuple[int, ...]]) -> frozenset[int]:
    return frozenset(element[start] for element in group)


def parity(value: tuple[int, ...]) -> int:
    return sum(
        value[left] > value[right]
        for left in range(len(value))
        for right in range(left + 1, len(value))
    ) % 2


def conjugate_subgroup(
    subgroup: frozenset[tuple[int, ...]],
    element: tuple[int, ...],
) -> frozenset[tuple[int, ...]]:
    element_inverse = inv(element)
    return frozenset(mul(mul(element, member), element_inverse) for member in subgroup)


def all_subgroups(group: frozenset[tuple[int, ...]], degree: int):
    """Breadth-first generation of every subgroup of a small permutation group."""

    identity_group = frozenset({tuple(range(degree))})
    result = {identity_group}
    frontier = deque([identity_group])
    while frontier:
        subgroup = frontier.popleft()
        for element in group - subgroup:
            enlarged = generated(tuple(subgroup) + (element,), degree)
            if enlarged not in result:
                result.add(enlarged)
                frontier.append(enlarged)
    return result


def quotient_orders(
    group: frozenset[tuple[int, ...]],
    subgroups: set[frozenset[tuple[int, ...]]],
) -> tuple[list[int], list[int]]:
    """Return all quotient orders and index-two-kernel orbit sizes."""

    normal_subgroups = []
    for subgroup in subgroups:
        if not subgroup <= group:
            continue
        if all(conjugate_subgroup(subgroup, element) == subgroup for element in group):
            normal_subgroups.append(subgroup)
    orders = sorted({len(group) // len(subgroup) for subgroup in normal_subgroups})
    index_two_kernel_orbits = sorted(
        len(orbit(0, subgroup))
        for subgroup in normal_subgroups
        if len(group) // len(subgroup) == 2
    )
    return orders, index_two_kernel_orbits


def main() -> None:
    s5 = frozenset(permutations(range(5)))
    subgroups_s5 = all_subgroups(s5, 5)
    assert len(subgroups_s5) == 156

    transitive = {subgroup for subgroup in subgroups_s5 if len(orbit(0, subgroup)) == 5}
    remaining = set(transitive)
    conjugacy_classes = []
    while remaining:
        representative = next(iter(remaining))
        conjugates = {conjugate_subgroup(representative, element) for element in s5}
        one_class = transitive & conjugates
        conjugacy_classes.append(one_class)
        remaining -= one_class

    representatives = [next(iter(one_class)) for one_class in conjugacy_classes]
    assert sorted(len(group) for group in representatives) == [5, 10, 20, 60, 120]

    names_by_order = {5: "C5", 10: "D10", 20: "F20", 60: "A5", 120: "S5"}
    quintic_cases = {}
    for group in sorted(representatives, key=len):
        name = names_by_order[len(group)]
        orders, index_two_kernel_orbits = quotient_orders(group, subgroups_s5)
        quintic_cases[name] = {
            "order": len(group),
            "orbit_size": len(orbit(0, group)),
            "normal_quotient_orders": orders,
            "index_two_kernel_orbit_sizes": index_two_kernel_orbits,
        }

    assert {name: value["normal_quotient_orders"] for name, value in quintic_cases.items()} == {
        "C5": [1, 5],
        "D10": [1, 2, 10],
        "F20": [1, 2, 4, 20],
        "A5": [1, 60],
        "S5": [1, 2, 120],
    }
    assert all(
        value["index_two_kernel_orbit_sizes"] in ([], [5])
        for value in quintic_cases.values()
    )

    # Compute A4/S4 quotient orders independently inside S4.
    s4 = frozenset(permutations(range(4)))
    subgroups_s4 = all_subgroups(s4, 4)
    assert len(subgroups_s4) == 30
    a4 = frozenset(value for value in s4 if parity(value) == 0)
    quartic_groups = {"A4": a4, "S4": s4}
    quartic_quotients = {
        name: quotient_orders(group, subgroups_s4)[0]
        for name, group in quartic_groups.items()
    }
    assert quartic_quotients == {"A4": [1, 3, 12], "S4": [1, 2, 6, 24]}

    intersections = {}
    for quartic_name, q_orders in quartic_quotients.items():
        intersections[quartic_name] = {}
        for quintic_name, quintic in quintic_cases.items():
            common = sorted((set(q_orders) & set(quintic["normal_quotient_orders"])) - {1})
            assert common in ([], [2])
            intersections[quartic_name][quintic_name] = {
                "possible_nontrivial_common_quotient_orders": common,
                "maximal_possible_intersection_degree": 2 if common else 1,
                "quintic_remains_transitive_over_possible_common_quadratic": (
                    quintic["index_two_kernel_orbit_sizes"] == [5] if common else None
                ),
            }

    assert all(
        value["maximal_possible_intersection_degree"] == 1
        for value in intersections["A4"].values()
    )
    assert {
        name
        for name, value in intersections["S4"].items()
        if value["maximal_possible_intersection_degree"] == 2
    } == {"D10", "F20", "S5"}

    # Balestrieri n=5,d=3 successor arithmetic.  The prime-degree theorem
    # gives degree coprime to 15 and at most 7; quadratic points descend.
    successor_raw = [degree for degree in range(1, 8) if degree % 3 and degree % 5]
    successor_after_quadratic = [degree for degree in successor_raw if degree != 2]
    assert successor_raw == [1, 2, 4, 7]
    assert successor_after_quadratic == [1, 4, 7]

    certificate = {
        "format": "Q-SCHUR-LINKED-QUINTIC-FIELD-CERTIFICATE-v1",
        "enumeration": {
            "number_of_subgroups_of_S5": len(subgroups_s5),
            "number_of_transitive_subgroups_of_S5": len(transitive),
            "number_of_transitive_conjugacy_classes": len(conjugacy_classes),
            "class_orders": sorted(len(group) for group in representatives),
        },
        "quintic_galois_cases": quintic_cases,
        "quartic_normal_quotient_orders": quartic_quotients,
        "quartic_quintic_intersections": intersections,
        "schur_field": {
            "group": "PSL2(F11)",
            "order": 660,
            "simple": True,
            "maximal_quintic_closure_order": 120,
            "quartic_x_quintic_residue_compositum_degree": 20,
            "maximal_quartic_x_quintic_closure_order": 24 * 120,
            "prime_11_divides_quartic_x_quintic_closure_order": False,
            "intersection_with_every_quintic_galois_closure": "K",
            "intersection_with_combined_quartic_quintic_galois_closure": "K",
            "linked_quintic_degree_after_schur_base_change": 5,
            "line_orbit_x_quintic_orbit": 275,
            "line_orbit_x_linked_quartic_quintic_pair": 1100,
        },
        "balestrieri_successor_from_degree_5": {
            "raw_possible_degrees": successor_raw,
            "after_quadratic_descent": successor_after_quadratic,
            "degree_4_branch_returns_to": [1, 5],
            "forced_strict_descent": False,
        },
        "deductions": {
            "A4_quartic_and_linked_quintic_closures_are_linearly_disjoint": True,
            "S4_quartic_and_linked_quintic_intersection_degree_at_most_2": True,
            "S4_nontrivial_intersection_is_the_quartic_discriminant_field": True,
            "linked_quintic_stays_degree_5_over_that_possible_quadratic": True,
            "schur_lines_do_not_split_the_linked_quintic": True,
            "combined_linked_pair_is_linearly_disjoint_from_schur_splitting_field": True,
        },
        "boundary": (
            "The certificate classifies field intersections and the Balestrieri successor set. "
            "It supplies no effective degree-one point on the cubic surface."
        ),
    }
    (HERE / "linked_quintic_certificate.json").write_text(
        json.dumps(certificate, indent=2) + "\n"
    )


if __name__ == "__main__":
    main()
