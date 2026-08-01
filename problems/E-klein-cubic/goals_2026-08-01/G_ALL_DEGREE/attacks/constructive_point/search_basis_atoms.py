#!/usr/bin/env python3
"""Bounded discovery search for a point with three basis-atom coordinates.

This is deliberately *not* a theorem-level exhaustive search for a
K_proj-point.  It tests the finite ansatz in which exactly three normalized
frame coordinates are signed members of the certified 12-element field
basis.  Several parameter specializations are used only as exact rejection
filters.  A survivor would then require characteristic-zero reconstruction.
"""

from __future__ import annotations

from fractions import Fraction
import hashlib
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[3]
GENERIC = PROBLEM / "goals_2026-08-01" / "G_ALL_DEGREE" / "generic_cubic.json"
TABLE = PROBLEM / "tmp" / "kproj_arithmetic" / "normalized_kproj_table.json"
MODEL = PROBLEM / "tmp" / "kproj_arithmetic" / "model.py"


SPECIALIZATIONS = (
    (101, (2, 3, 5, 7)),
    (103, (3, 4, 7, 9)),
    (107, (5, 2, 8, 11)),
)


def mod_fraction(numerator: int, denominator: int, prime: int) -> int:
    return numerator * pow(denominator, -1, prime) % prime


def scalar(rows: list[dict], prime: int, values: tuple[int, ...]) -> int:
    answer = 0
    for row in rows:
        term = mod_fraction(row["numerator"], row["denominator"], prime)
        for value, exponent in zip(values, row["exponents"]):
            term = term * pow(value, exponent, prime) % prime
        answer += term
    return answer % prime


def specialize_products(prime: int, values: tuple[int, ...]):
    payload = json.loads(TABLE.read_text())
    products = {}
    for row in payload["products"]:
        result = [0] * 12
        for entry in row["entries"]:
            result[entry["basis"]] = scalar(entry["coefficient"], prime, values)
        products[(row["left"], row["right"])] = tuple(result)
    return products


def add(left, right, prime):
    return tuple((a + b) % prime for a, b in zip(left, right))


def multiply(left, right, products, prime):
    answer = [0] * 12
    for i, a in enumerate(left):
        if not a:
            continue
        for j, b in enumerate(right):
            if not b:
                continue
            for k, c in enumerate(products[tuple(sorted((i, j)))]):
                answer[k] = (answer[k] + a * b * c) % prime
    return tuple(answer)


def basis(index):
    return tuple(1 if i == index else 0 for i in range(12))


def specialize_coefficients(prime: int, values: tuple[int, ...]):
    payload = json.loads(GENERIC.read_text())
    answer = {}
    for item in payload["coefficients"]:
        vector = [0] * 12
        for entry in item["normalized_entries"]:
            term = mod_fraction(entry["numerator"], entry["denominator"], prime)
            for value, exponent in zip(values, entry["projective_exponents"]):
                term = term * pow(value, exponent, prime) % prime
            vector[entry["secondary"]] = (vector[entry["secondary"]] + term) % prime
        answer[tuple(item["triple"])] = tuple(vector)
    return answer


def evaluate(support, atoms, signs, coefficients, products, prime):
    coordinates = {frame: basis(atom) for frame, atom in zip(support, atoms)}
    sign_map = dict(zip(support, signs))
    answer = (0,) * 12
    for triple in itertools.combinations_with_replacement(support, 3):
        value = coefficients[triple]
        for frame in triple:
            value = multiply(value, coordinates[frame], products, prime)
        sign = 1
        for frame in triple:
            sign *= sign_map[frame]
        if sign == -1:
            value = tuple((-x) % prime for x in value)
        answer = add(answer, value, prime)
    return answer


def main() -> None:
    states = [
        (support, atoms, signs)
        for support in itertools.combinations(range(5), 3)
        for atoms in itertools.product(range(12), repeat=3)
        for signs in itertools.product((1, -1), repeat=3)
    ]
    initial = len(states)
    stages = []
    for prime, values in SPECIALIZATIONS:
        products = specialize_products(prime, values)
        coefficients = specialize_coefficients(prime, values)
        states = [
            state
            for state in states
            if not any(evaluate(*state, coefficients, products, prime))
        ]
        stages.append(
            {
                "prime": prime,
                "parameters": list(values),
                "survivors": len(states),
            }
        )
        if not states:
            break
    result = {
        "schema": "G_CONSTRUCTIVE_BASIS_ATOM_SEARCH_V1",
        "scope": "bounded discovery only; exactly three signed field-basis atoms",
        "authoritative_inputs": {
            str(GENERIC.relative_to(PROBLEM)): hashlib.sha256(GENERIC.read_bytes()).hexdigest(),
            str(TABLE.relative_to(PROBLEM)): hashlib.sha256(TABLE.read_bytes()).hexdigest(),
            str(MODEL.relative_to(PROBLEM)): hashlib.sha256(MODEL.read_bytes()).hexdigest(),
        },
        "initial_candidates": initial,
        "stages": stages,
        "survivors": [
            {"support": list(s), "atoms": list(a), "signs": list(e)}
            for s, a, e in states
        ],
    }
    (HERE / "basis_atom_search.json").write_text(json.dumps(result, indent=2) + "\n")
    print(
        "BASIS_ATOM_DISCOVERY_DONE "
        f"initial={initial} survivors={len(states)} bounded_scope=TRUE"
    )


if __name__ == "__main__":
    main()
