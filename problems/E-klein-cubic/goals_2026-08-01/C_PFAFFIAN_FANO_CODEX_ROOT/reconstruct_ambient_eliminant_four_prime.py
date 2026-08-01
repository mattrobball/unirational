#!/usr/bin/env python3
"""Extend the auxiliary eliminant reconstruction through prime 199."""

from __future__ import annotations

import json
import runpy
from pathlib import Path

from sympy import Poly, QQ, Rational, Symbol, sqrt
from sympy.polys.modulargcd import _integer_rational_reconstruction


HERE = Path(__file__).resolve().parent
SIBLING = HERE.parent / "C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3"
BASE = runpy.run_path(str(HERE / "reconstruct_ambient_eliminant_three_prime.py"))
T = Symbol("T")


def reconstruct(value: int, modulus: int) -> Rational | None:
    answer = _integer_rational_reconstruction(value, modulus, QQ.get_ring())
    if answer is None:
        return None
    candidate = Rational(answer.numerator, answer.denominator)
    return candidate


def reduce_rational(value: Rational, prime: int) -> int:
    denominator = int(value.q) % prime
    assert denominator
    return int(value.p) * pow(denominator, -1, prime) % prime


def main() -> None:
    fibres = [
        (23, 2, 4, SIBLING / "ambient_degree12_a47_chart.rur", HERE / "ambient_degree12_p23_zeta4_a47.rur"),
        (67, 9, 14, HERE / "ambient_degree12_p67_a47.rur", HERE / "ambient_degree12_p67_zeta14_a47.rur"),
        (89, 2, 4, HERE / "ambient_degree12_p89_a47.rur", HERE / "ambient_degree12_p89_zeta4_a47.rur"),
        (199, 18, 125, HERE / "ambient_degree12_p199_a47.rur", HERE / "ambient_degree12_p199_zeta125_a47.rur"),
    ]
    records = []
    for prime, zeta, zeta_bar, first_path, second_path in fibres:
        c, cbar = BASE["period"](zeta, prime), BASE["period"](zeta_bar, prime)
        assert (c + cbar + 1) % prime == 0 and c * cbar % prime == 3
        first, second = BASE["eliminant"](first_path), BASE["eliminant"](second_path)
        coordinates = [
            BASE["quadratic_coordinates"](value, conjugate, c, cbar, prime)
            for value, conjugate in zip(first, second)
        ]
        records.append({
            "prime": prime,
            "zeta11": zeta,
            "conjugate_zeta11": zeta_bar,
            "c": c,
            "conjugate_c": cbar,
            "first_eliminant": first,
            "conjugate_eliminant": second,
            "A_B_residues": coordinates,
        })

    modulus = 1
    combined = [[0, 0] for _ in range(4)]
    for record in records:
        prime = record["prime"]
        for index, pair in enumerate(record["A_B_residues"]):
            for coordinate in range(2):
                combined[index][coordinate] = BASE["crt_pair"](
                    combined[index][coordinate], modulus, pair[coordinate], prime
                )
        modulus *= prime
    coefficients = [[reconstruct(value, modulus) for value in pair] for pair in combined]
    for index, pair in enumerate(coefficients):
        for coordinate, candidate in enumerate(pair):
            if candidate is None:
                continue
            if any(
                reduce_rational(candidate, record["prime"])
                != record["A_B_residues"][index][coordinate]
                for record in records
            ):
                pair[coordinate] = None
    for record in records:
        prime = record["prime"]
        for pair, expected in zip(coefficients, record["A_B_residues"]):
            for coordinate, value in enumerate(pair):
                if value is not None:
                    assert reduce_rational(value, prime) == expected[coordinate]

    complete = all(value is not None for pair in coefficients for value in pair)
    factor_degrees = []
    if complete:
        c_exact = (-1 + sqrt(-11)) / 2
        polynomial = Poly(
            sum((a + b * c_exact) * T**index for index, (a, b) in enumerate(coefficients)),
            T,
            extension=sqrt(-11),
        )
        factor_degrees = [
            factor_poly.degree()
            for factor_poly, multiplicity in polynomial.factor_list()[1]
            for _ in range(multiplicity)
        ]
    def encode(value):
        return None if value is None else [int(value.p), int(value.q)]
    payload = {
        "format": "ambient-eliminant-four-prime-rational-reconstruction-v1",
        "scope": "auxiliary degree-12 chart candidate; unused-prime holdout required",
        "quadratic_field": "Q(c), c^2+c+3=0",
        "fibres": records,
        "crt_modulus": modulus,
        "coefficients_ascending_A_plus_Bc": [
            [encode(value) for value in pair] for pair in coefficients
        ],
        "complete_rational_reconstruction": complete,
        "factor_degrees_over_quadratic_field": factor_degrees,
        "irreducible_over_quadratic_field": complete and factor_degrees == [3],
        "maximum_numerator_or_denominator": max(
            max(abs(int(value.p)), int(value.q))
            for pair in coefficients for value in pair if value is not None
        ),
        "theorem_boundary": (
            "the four-prime candidate is rejected unless an unused split-prime "
            "holdout matches coefficient-by-coefficient"
        ),
    }
    (HERE / "ambient_eliminant_four_prime.json").write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps({
        "modulus": modulus,
        "coefficients": payload["coefficients_ascending_A_plus_Bc"],
        "factor_degrees": factor_degrees,
        "maximum_numerator_or_denominator": payload["maximum_numerator_or_denominator"],
    }, indent=2))
    print(
        "AMBIENT-ELIMINANT-FOUR-PRIME-CANDIDATE-RECONSTRUCTED"
        if complete else "AMBIENT-ELIMINANT-FOUR-PRIME-INSUFFICIENT"
    )


if __name__ == "__main__":
    main()
