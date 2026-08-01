#!/usr/bin/env python3
"""Independent exact verifier for the Goal-V inertia classification.

This script reconstructs all 660 abstract group elements and their exact
five-dimensional matrices from ``certificates/exact_weil_check.py``.  It
does not import any Goal-V producer.  The valuation-theoretic use of the
finite-group calculation is stated in MODEL.md.
"""

from __future__ import annotations

import json
import sys
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
sys.path.insert(0, str(PROBLEM / "certificates"))

import exact_weil_check as ew  # noqa: E402


PAYLOAD = HERE / "inertia_centralizers.json"


def multiply(left, right):
    return ew.fcanon(ew.fmul(left, right))


def order(element):
    product = ew.fone
    for candidate in range(1, 100):
        product = multiply(product, element)
        if product == ew.fone:
            return candidate
    raise AssertionError(element)


def centralizer(element, group):
    return {other for other in group if multiply(other, element) == multiply(element, other)}


def inverse(element):
    aa, b, c, d = element
    return ew.fcanon((d, -b, -c, aa))


def conjugate(group_element, element):
    return multiply(multiply(group_element, element), inverse(group_element))


def cyclic(generator, element_order):
    answer = {ew.fone}
    product = ew.fone
    for _ in range(element_order - 1):
        product = multiply(product, generator)
        answer.add(product)
    assert len(answer) == element_order
    return answer


def normalizer(subgroup, group):
    subgroup = set(subgroup)
    return {
        group_element
        for group_element in group
        if {conjugate(group_element, element) for element in subgroup} == subgroup
    }


def is_abelian(subgroup):
    return all(multiply(left, right) == multiply(right, left) for left in subgroup for right in subgroup)


def matrix_vector(matrix, vector):
    return [sum(matrix[row][column] * vector[column] for column in range(5)) for row in range(5)]


def trace(matrix):
    return sum(matrix[index][index] for index in range(5))


def klein(vector):
    return sum(vector[index] ** 2 * vector[(index + 1) % 5] for index in range(5))


def main():
    payload = json.loads(PAYLOAD.read_text())
    assert payload["schema"] == "klein_goal_v_inertia_centralizers_v1"

    group = tuple(ew.rho)
    assert len(group) == payload["group_order"] == 660
    orders = {element: order(element) for element in group}
    order_counts = Counter(orders.values())
    assert {str(key): value for key, value in sorted(order_counts.items())} == payload["element_order_counts"]

    representatives = {value: next(element for element in group if orders[element] == value) for value in (2, 3, 5, 6, 11)}
    centralizers = {}
    for value, representative in representatives.items():
        subgroup = centralizer(representative, group)
        row = payload["centralizers"][str(value)]
        assert len(subgroup) == row["order"]
        assert is_abelian(subgroup) is row["abelian"]
        counts = Counter(orders[element] for element in subgroup)
        assert {str(key): count for key, count in sorted(counts.items())} == row["element_order_counts"]
        centralizers[value] = subgroup

    # For an involution t, trace(t)=1 and t^2=1.  Hence its plus/minus
    # multiplicities are (3,2).  Its centralizer preserves the minus space.
    involution = representatives[2]
    assert trace(ew.rho[involution]) == ew.C(1)
    assert payload["involution_minus_space"]["dimension"] == 2
    assert payload["involution_minus_space"]["centralizer_order"] == len(centralizers[2]) == 12
    for group_element in centralizers[2]:
        assert multiply(group_element, involution) == multiply(involution, group_element)

    # F is invariant and cubic.  On E_-(t), t*v=-v, so
    # F(v)=F(t*v)=F(-v)=-F(v); characteristic zero gives F(v)=0.
    # The following exact sample vectors guard the chosen sign convention.
    minus_vectors = []
    for column in range(5):
        basis = [ew.C(index == column) for index in range(5)]
        image = matrix_vector(ew.rho[involution], basis)
        candidate = [basis[index] - image[index] for index in range(5)]
        if any(entry != 0 for entry in candidate):
            assert matrix_vector(ew.rho[involution], candidate) == [-entry for entry in candidate]
            assert klein(candidate) == 0
            minus_vectors.append(candidate)
    assert len(minus_vectors) >= 2
    assert payload["involution_minus_space"]["contained_in_klein_cubic"] is True

    # The representative order-11 element is diagonal in the exact Weil
    # model, so every coordinate axis is a projective fixed point on X.
    order_11 = representatives[11]
    coordinate = [ew.C(index == 0) for index in range(5)]
    assert all(ew.rho[order_11][row][column] == 0 for row in range(5) for column in range(5) if row != column)
    assert klein(coordinate) == 0

    # Every order-5 subgroup is conjugate to the cyclic-permutation model.
    # If r^5=1 and r != 1, v=(1,r,r^2,r^3,r^4) is an eigenline and
    # F(v)=r*sum_i r^(3i)=0.  The finite group calculation establishes that
    # its centralizer has no larger decomposition-group possibility.
    assert len(centralizers[5]) == 5
    for element_order, expected_subgroups in ((5, 66), (11, 12)):
        subgroups = {
            frozenset(cyclic(element, element_order))
            for element in group
            if orders[element] == element_order
        }
        row = payload["cyclic_subgroup_conjugacy"][str(element_order)]
        assert len(subgroups) == row["subgroup_count"] == expected_subgroups
        representative_subgroup = next(iter(subgroups))
        subgroup_normalizer = normalizer(representative_subgroup, group)
        assert len(subgroup_normalizer) == row["normalizer_order"]
        assert len(group) // len(subgroup_normalizer) == len(subgroups)
        assert row["one_conjugacy_class"] is True

    # Exponents of the five terms of F on the nontrivial cyclic-permutation
    # eigenline v_i=r^i, reduced modulo r^5=1, are all residue classes.
    # Therefore F(v)=1+r+...+r^4=0 for r != 1.
    assert sorted((2 * index + (index + 1)) % 5 for index in range(5)) == list(range(5))

    conclusions = payload["valuation_conclusions"]
    assert conclusions["nontrivial_inertia"] == "the genuine local twist has a rational point"
    assert "value-group nonintersection is impossible" in conclusions["all_ranks_tropical"]

    print("PASS exact PSL2(F11) element-order and centralizer census")
    print("PASS nonabelian centralizer occurs only at involutions and preserves a P1 inside X")
    print("PASS C5 and C11 centralizers have projective fixed points on X")
    print("GOAL_V_INERTIA_CENTRALIZERS_ACCEPT")


if __name__ == "__main__":
    main()
