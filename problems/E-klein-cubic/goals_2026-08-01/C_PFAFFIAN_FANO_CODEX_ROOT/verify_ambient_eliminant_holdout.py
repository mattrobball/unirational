#!/usr/bin/env python3
"""Verify the reconstructed auxiliary eliminant at the unused prime 199."""

from __future__ import annotations

import ast
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent


def eliminant(path: Path, prime: int) -> list[int]:
    data = ast.literal_eval(path.read_text().strip().rstrip(":"))
    assert data[0] == 0
    stored_prime, nvars, degree, _names, _linear, tail = data[1]
    assert stored_prime == prime and nvars == 48 and degree == 3 and tail[0] == 1
    coefficients = [int(value) for value in tail[1][0][1]]
    assert len(coefficients) == 4 and coefficients[-1] == 1
    return coefficients


def reduce_fraction(value: Fraction, prime: int) -> int:
    denominator = value.denominator % prime
    assert denominator
    return value.numerator * pow(denominator, -1, prime) % prime


def period(zeta: int, prime: int) -> int:
    return sum(pow(zeta, exponent, prime) for exponent in (1, 3, 4, 5, 9)) % prime


def roots(coefficients: list[int], prime: int) -> list[int]:
    return [
        value for value in range(prime)
        if sum(coefficient * pow(value, exponent, prime)
               for exponent, coefficient in enumerate(coefficients)) % prime == 0
    ]


def main() -> None:
    prime = 199
    record = json.loads((HERE / "ambient_eliminant_three_prime.json").read_text())
    exact_pairs = [
        tuple(Fraction(numerator, denominator) for numerator, denominator in pair)
        for pair in record["coefficients_ascending_A_plus_Bc"]
    ]
    fibres = [
        (18, HERE / "ambient_degree12_p199_a47.rur"),
        (125, HERE / "ambient_degree12_p199_zeta125_a47.rur"),
    ]
    checks = []
    for zeta, path in fibres:
        if not path.is_file() or path.stat().st_size == 0:
            continue
        c = period(zeta, prime)
        predicted = [
            (reduce_fraction(a, prime) + c * reduce_fraction(b, prime)) % prime
            for a, b in exact_pairs
        ]
        observed = eliminant(path, prime)
        checks.append({
            "zeta11": zeta,
            "c": c,
            "predicted_eliminant": predicted,
            "observed_eliminant": observed,
            "matches_prediction": observed == predicted,
            "rational_roots": roots(observed, prime),
        })
    passed = len(checks) == 2 and all(check["matches_prediction"] for check in checks)
    payload = {
        "format": "ambient-eliminant-unused-prime-holdout-v1",
        "scope": "auxiliary degree-12 chart only",
        "reconstruction_primes": [23, 67, 89],
        "holdout_prime": prime,
        "checks": checks,
        "three_prime_candidate_passes_holdout": passed,
        "theorem_boundary": (
            "a failed holdout rejects the three-prime rational reconstruction; "
            "a pass would still not reconstruct the RUR coordinate functions"
        ),
    }
    (HERE / "ambient_eliminant_holdout_p199.json").write_text(
        json.dumps(payload, indent=2) + "\n"
    )
    print(json.dumps(payload, indent=2))
    print(
        "AMBIENT-ELIMINANT-UNUSED-PRIME-HOLDOUT-PASS"
        if passed else "AMBIENT-ELIMINANT-UNUSED-PRIME-HOLDOUT-FAIL"
    )


if __name__ == "__main__":
    main()
