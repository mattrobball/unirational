#!/usr/bin/env python3
"""Pair residue projectors across the two roots of c^2+c+3."""

from __future__ import annotations

import argparse
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def centered(value: int, prime: int) -> int:
    value %= prime
    return value if value <= prime // 2 else value - prime


def period(zeta: int, prime: int) -> int:
    return sum(pow(zeta, exponent, prime) for exponent in (1, 3, 4, 5, 9)) % prime


def load_vectors(path: Path) -> list[list[int]]:
    payload = json.loads(path.read_text())
    return [row["coefficient_vector"] for row in payload["checks"]]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=23)
    parser.add_argument("--zeta", type=int, required=True)
    parser.add_argument("--conjugate-zeta", type=int, required=True)
    parser.add_argument("--first", type=Path, required=True)
    parser.add_argument("--second", type=Path, required=True)
    args = parser.parse_args()
    prime = args.prime
    c = period(args.zeta % prime, prime)
    conjugate = period(args.conjugate_zeta % prime, prime)
    assert (c + conjugate + 1) % prime == 0
    assert c * conjugate % prime == 3 % prime and c != conjugate
    first = load_vectors(args.first)
    second = load_vectors(args.second)
    assert len(first) == len(second) == 3

    records = []
    inverse_difference = pow((c - conjugate) % prime, -1, prime)
    for permutation in itertools.permutations(range(3)):
        branches = []
        all_values = []
        for left_index, right_index in enumerate(permutation):
            coefficients = []
            for value, conjugate_value in zip(first[left_index], second[right_index]):
                b = (value - conjugate_value) * inverse_difference % prime
                a = (value - b * c) % prime
                pair = [centered(a, prime), centered(b, prime)]
                coefficients.append(pair)
                all_values.extend(abs(entry) for entry in pair)
            branches.append({
                "first_index": left_index,
                "second_index": right_index,
                "coefficients_A_plus_Bc_centered": coefficients,
            })
        records.append({
            "permutation": list(permutation),
            "maximum_centered_height": max(all_values),
            "sum_centered_height": sum(all_values),
            "small_entries_le_3": sum(value <= 3 for value in all_values),
            "branches": branches,
        })
    records.sort(key=lambda row: (row["maximum_centered_height"], row["sum_centered_height"]))
    payload = {
        "format": "quadratic-projector-residue-pairing-v1",
        "scope": "one-prime pairing heuristic only; not rational reconstruction",
        "prime": prime,
        "zeta11": args.zeta % prime,
        "conjugate_zeta11": args.conjugate_zeta % prime,
        "c": c,
        "conjugate_c": conjugate,
        "pairings": records,
        "theorem_boundary": (
            "centered representatives at one prime do not determine rational "
            "coefficients; multiprime CRT and exact substitution remain required"
        ),
    }
    out = HERE / f"ambient_degree12_pairing_p{prime}.json"
    out.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps([
        {key: row[key] for key in (
            "permutation", "maximum_centered_height", "sum_centered_height", "small_entries_le_3"
        )}
        for row in records
    ], indent=2))
    print("QUADRATIC-PROJECTOR-RESIDUES-PAIRED-SCOPED")


if __name__ == "__main__":
    main()
