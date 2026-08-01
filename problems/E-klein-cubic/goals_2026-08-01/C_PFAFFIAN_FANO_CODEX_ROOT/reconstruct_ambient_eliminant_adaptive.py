#!/usr/bin/env python3
"""Adaptive rational reconstruction of the auxiliary degree-12 eliminant."""

from __future__ import annotations

import argparse
import json
import runpy
from pathlib import Path

from sympy import Poly, QQ, Rational, Symbol, sqrt
from sympy.polys.modulargcd import _integer_rational_reconstruction


HERE = Path(__file__).resolve().parent
SIBLING = HERE.parent / "C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3"
BASE = runpy.run_path(str(HERE / "reconstruct_ambient_eliminant_three_prime.py"))
T = Symbol("T")
FIBRES = (
    (23, 2, 4, SIBLING / "ambient_degree12_a47_chart.rur", HERE / "ambient_degree12_p23_zeta4_a47.rur"),
    (67, 9, 14, HERE / "ambient_degree12_p67_a47.rur", HERE / "ambient_degree12_p67_zeta14_a47.rur"),
    (89, 2, 4, HERE / "ambient_degree12_p89_a47.rur", HERE / "ambient_degree12_p89_zeta4_a47.rur"),
    (199, 18, 125, HERE / "ambient_degree12_p199_a47.rur", HERE / "ambient_degree12_p199_zeta125_a47.rur"),
    (331, 74, 180, HERE / "ambient_degree12_p331_a47.rur", HERE / "ambient_degree12_p331_zeta180_a47.rur"),
    (353, 22, 131, HERE / "ambient_degree12_p353_a47.rur", HERE / "ambient_degree12_p353_zeta131_a47.rur"),
    (397, 16, 256, HERE / "ambient_degree12_p397_a47.rur", HERE / "ambient_degree12_p397_zeta256_a47.rur"),
    (419, 13, 169, HERE / "ambient_degree12_p419_a47.rur", HERE / "ambient_degree12_p419_zeta169_a47.rur"),
)


def reduce_rational(value: Rational, prime: int) -> int:
    denominator = int(value.q) % prime
    assert denominator
    return int(value.p) * pow(denominator, -1, prime) % prime


def reconstruct(value: int, modulus: int) -> Rational | None:
    answer = _integer_rational_reconstruction(value, modulus, QQ.get_ring())
    return None if answer is None else Rational(answer.numerator, answer.denominator)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--through-prime", type=int, default=10**9)
    parser.add_argument("--predict-prime", type=int)
    parser.add_argument("--predict-zeta", type=int)
    parser.add_argument("--predict-conjugate-zeta", type=int)
    args = parser.parse_args()

    records = []
    for prime, zeta, zeta_bar, first_path, second_path in FIBRES:
        if prime > args.through_prime:
            continue
        assert first_path.is_file() and first_path.stat().st_size > 0
        assert second_path.is_file() and second_path.stat().st_size > 0
        c, cbar = BASE["period"](zeta, prime), BASE["period"](zeta_bar, prime)
        first, second = BASE["eliminant"](first_path), BASE["eliminant"](second_path)
        coordinates = [
            BASE["quadratic_coordinates"](value, conjugate, c, cbar, prime)
            for value, conjugate in zip(first, second)
        ]
        records.append({
            "prime": prime, "zeta11": zeta, "conjugate_zeta11": zeta_bar,
            "c": c, "conjugate_c": cbar,
            "first_eliminant": first, "conjugate_eliminant": second,
            "A_B_residues": coordinates,
        })
    assert records

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
            if candidate is not None and any(
                reduce_rational(candidate, record["prime"])
                != record["A_B_residues"][index][coordinate]
                for record in records
            ):
                pair[coordinate] = None
    complete = all(value is not None for pair in coefficients for value in pair)
    factor_degrees = []
    if complete:
        c_exact = (-1 + sqrt(-11)) / 2
        polynomial = Poly(
            sum((a + b * c_exact) * T**index for index, (a, b) in enumerate(coefficients)),
            T, extension=sqrt(-11),
        )
        factor_degrees = [
            factor_poly.degree() for factor_poly, multiplicity in polynomial.factor_list()[1]
            for _ in range(multiplicity)
        ]

    def encode(value):
        return None if value is None else [int(value.p), int(value.q)]

    payload = {
        "format": "ambient-eliminant-adaptive-rational-reconstruction-v1",
        "scope": "auxiliary degree-12 chart candidate; holdout required",
        "reconstruction_primes": [record["prime"] for record in records],
        "crt_modulus": modulus,
        "coefficients_ascending_A_plus_Bc": [
            [encode(value) for value in pair] for pair in coefficients
        ],
        "complete_rational_reconstruction": complete,
        "factor_degrees_over_quadratic_field": factor_degrees,
        "maximum_reconstructed_height": max(
            max(abs(int(value.p)), int(value.q))
            for pair in coefficients for value in pair if value is not None
        ),
        "theorem_boundary": "no candidate is accepted without a frozen unused-prime holdout",
    }
    last_prime = records[-1]["prime"]
    (HERE / f"ambient_eliminant_adaptive_through_p{last_prime}.json").write_text(
        json.dumps(payload, indent=2) + "\n"
    )
    print(json.dumps(payload, indent=2))

    if args.predict_prime is not None:
        if not complete:
            print("AMBIENT-ELIMINANT-HOLDOUT-PREDICTION-UNAVAILABLE")
            print("AMBIENT-ELIMINANT-ADAPTIVE-RECONSTRUCTION-INSUFFICIENT")
            return
        assert args.predict_zeta is not None and args.predict_conjugate_zeta is not None
        predictions = []
        for zeta in (args.predict_zeta, args.predict_conjugate_zeta):
            c = BASE["period"](zeta, args.predict_prime)
            predicted = [
                (reduce_rational(a, args.predict_prime) + c * reduce_rational(b, args.predict_prime))
                % args.predict_prime
                for a, b in coefficients
            ]
            roots = [
                value for value in range(args.predict_prime)
                if sum(coefficient * pow(value, exponent, args.predict_prime)
                       for exponent, coefficient in enumerate(predicted)) % args.predict_prime == 0
            ]
            predictions.append({"zeta11": zeta, "c": c, "eliminant": predicted, "roots": roots})
        frozen = {
            "format": "ambient-eliminant-frozen-holdout-prediction-v1",
            "source_reconstruction_primes": payload["reconstruction_primes"],
            "holdout_prime": args.predict_prime,
            "predictions": predictions,
        }
        (HERE / f"ambient_eliminant_frozen_prediction_p{args.predict_prime}.json").write_text(
            json.dumps(frozen, indent=2) + "\n"
        )
        print(json.dumps(frozen, indent=2))
        print("AMBIENT-ELIMINANT-HOLDOUT-PREDICTION-FROZEN")
    print("AMBIENT-ELIMINANT-ADAPTIVE-RECONSTRUCTION-COMPLETE" if complete
          else "AMBIENT-ELIMINANT-ADAPTIVE-RECONSTRUCTION-INSUFFICIENT")


if __name__ == "__main__":
    main()
