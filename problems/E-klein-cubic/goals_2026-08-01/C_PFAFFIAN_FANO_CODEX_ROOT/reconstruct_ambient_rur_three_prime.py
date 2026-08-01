#!/usr/bin/env python3
"""Reconstruct every coefficient of the auxiliary chart RUR over Q(c).

The reconstruction primes are 23, 67, and 89.  Prime 199 is deliberately not
read here so it remains a coefficient-by-coefficient holdout.
"""

from __future__ import annotations

import ast
import json
from pathlib import Path

from sympy import QQ, Rational
from sympy.polys.modulargcd import _integer_rational_reconstruction


HERE = Path(__file__).resolve().parent
SIBLING = HERE.parent / "C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3"


def parse(path: Path, prime: int):
    data = ast.literal_eval(path.read_text().strip().rstrip(":"))
    assert data[0] == 0
    stored_prime, nvars, degree, names, linear, tail = data[1]
    assert stored_prime == prime and nvars == 48 and degree == 3
    assert linear == [0] * 47 + [1] and tail[0] == 1
    eliminant, denominator, blocks = tail[1]
    assert eliminant[0] == 3 and denominator == [0, [1]] and len(blocks) == 47
    padded = []
    for block in blocks:
        assert len(block) == 1
        block_degree, coefficients = block[0]
        assert block_degree == len(coefficients) - 1 and block_degree <= 2
        padded.append([int(value) for value in coefficients] + [0] * (3 - len(coefficients)))
    return names, [int(value) for value in eliminant[1]], padded


def period(zeta: int, prime: int) -> int:
    return sum(pow(zeta, exponent, prime) for exponent in (1, 3, 4, 5, 9)) % prime


def quadratic_coordinates(value: int, conjugate: int, c: int, cbar: int, prime: int):
    b = (value - conjugate) * pow((c - cbar) % prime, -1, prime) % prime
    return (value - b * c) % prime, b


def crt_pair(left: int, left_modulus: int, right: int, right_modulus: int) -> int:
    multiplier = (right - left) * pow(left_modulus, -1, right_modulus) % right_modulus
    return (left + left_modulus * multiplier) % (left_modulus * right_modulus)


def reconstruct(value: int, modulus: int) -> Rational | None:
    answer = _integer_rational_reconstruction(value, modulus, QQ.get_ring())
    if answer is None:
        return None
    return Rational(answer.numerator, answer.denominator)


def reduce_rational(value: Rational, prime: int) -> int:
    assert int(value.q) % prime
    return int(value.p) * pow(int(value.q) % prime, -1, prime) % prime


def main() -> None:
    fibres = [
        (23, 2, 4, SIBLING / "ambient_degree12_a47_chart.rur", HERE / "ambient_degree12_p23_zeta4_a47.rur"),
        (67, 9, 14, HERE / "ambient_degree12_p67_a47.rur", HERE / "ambient_degree12_p67_zeta14_a47.rur"),
        (89, 2, 4, HERE / "ambient_degree12_p89_a47.rur", HERE / "ambient_degree12_p89_zeta4_a47.rur"),
    ]
    records = []
    reference_names = None
    for prime, zeta, zeta_bar, first_path, second_path in fibres:
        names, first_eliminant, first_blocks = parse(first_path, prime)
        second_names, second_eliminant, second_blocks = parse(second_path, prime)
        assert second_names == names
        if reference_names is None:
            reference_names = names
        else:
            assert names == reference_names
        c, cbar = period(zeta, prime), period(zeta_bar, prime)
        assert (c + cbar + 1) % prime == 0 and c * cbar % prime == 3
        first_flat = first_eliminant + [value for block in first_blocks for value in block]
        second_flat = second_eliminant + [value for block in second_blocks for value in block]
        coordinates = [
            quadratic_coordinates(value, conjugate, c, cbar, prime)
            for value, conjugate in zip(first_flat, second_flat)
        ]
        records.append({
            "prime": prime,
            "zeta11": zeta,
            "conjugate_zeta11": zeta_bar,
            "c": c,
            "conjugate_c": cbar,
            "A_B_residues": coordinates,
        })

    scalar_count = 4 + 47 * 3
    assert all(len(record["A_B_residues"]) == scalar_count for record in records)
    modulus = 1
    combined = [[0, 0] for _ in range(scalar_count)]
    for record in records:
        prime = record["prime"]
        for index, pair in enumerate(record["A_B_residues"]):
            for coordinate in range(2):
                combined[index][coordinate] = crt_pair(
                    combined[index][coordinate], modulus, pair[coordinate], prime
                )
        modulus *= prime

    exact = [[reconstruct(pair[0], modulus), reconstruct(pair[1], modulus)] for pair in combined]
    for index, pair in enumerate(exact):
        for coordinate, candidate in enumerate(pair):
            if candidate is None:
                continue
            if any(
                reduce_rational(candidate, record["prime"])
                != record["A_B_residues"][index][coordinate]
                for record in records
            ):
                pair[coordinate] = None
    failures = [
        {"scalar_pair_index": index, "crt_residues_A_B": pair}
        for index, (pair, candidate) in enumerate(zip(combined, exact))
        if any(value is None for value in candidate)
    ]
    for record in records:
        prime = record["prime"]
        for pair, expected in zip(exact, record["A_B_residues"]):
            for coordinate, value in enumerate(pair):
                if value is not None:
                    assert reduce_rational(value, prime) == expected[coordinate]

    def encode(pair):
        return [None if value is None else [int(value.p), int(value.q)] for value in pair]

    payload = {
        "format": "ambient-rur-three-prime-rational-reconstruction-v1",
        "scope": "auxiliary degree-12 chart candidate; unused-prime holdout required",
        "quadratic_field": "Q(c), c^2+c+3=0",
        "variable_order": reference_names,
        "coordinate_convention": "a_name = -numerator_name(T), denominator 1, modulo eliminant",
        "reconstruction_primes": [record["prime"] for record in records],
        "crt_modulus": modulus,
        "eliminant_coefficients_ascending_A_plus_Bc": [encode(pair) for pair in exact[:4]],
        "coordinate_numerators_padded_degree2_A_plus_Bc": [
            [encode(pair) for pair in exact[4 + 3 * index: 4 + 3 * (index + 1)]]
            for index in range(47)
        ],
        "unreconstructed_scalar_pairs": failures,
        "maximum_numerator_or_denominator": max(
            max(abs(int(value.p)), int(value.q))
            for pair in exact for value in pair if value is not None
        ),
        "theorem_boundary": (
            "rational reconstruction is not accepted as an exact RUR until all "
            "coefficients pass at an unused split prime"
        ),
    }
    (HERE / "ambient_rur_three_prime.json").write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps({
        "scalar_pairs": scalar_count,
        "unreconstructed_scalar_pair_count": len(failures),
        "crt_modulus": modulus,
        "maximum_numerator_or_denominator": payload["maximum_numerator_or_denominator"],
    }, indent=2))
    print(
        "AMBIENT-RUR-THREE-PRIME-RATIONAL-RECONSTRUCTED"
        if not failures else "AMBIENT-RUR-THREE-PRIME-INSUFFICIENT"
    )


if __name__ == "__main__":
    main()
