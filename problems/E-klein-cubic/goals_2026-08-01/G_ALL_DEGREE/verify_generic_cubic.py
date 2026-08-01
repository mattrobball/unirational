#!/usr/bin/env python3
"""Independently verify every coefficient in generic_cubic.json."""

from __future__ import annotations

from fractions import Fraction
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
sys.path.insert(0, str(PROBLEM / "tmp/generic_twist"))
sys.path.insert(0, str(PROBLEM / "tmp/kproj_arithmetic"))

from phi_coefficients import all_coefficients, verify_expansion  # noqa: E402
from core import (  # noqa: E402
    PRIMARY_DEGREES,
    SECONDARY_DEGREES,
    multiply,
    primary_monomial,
    secondary_polynomials,
)


def add_scaled(target: dict, polynomial: dict, scalar: Fraction) -> None:
    for exponent, coefficient in polynomial.items():
        value = target.get(exponent, Fraction(0)) + scalar * coefficient
        if value:
            target[exponent] = value
        elif exponent in target:
            del target[exponent]


def main() -> None:
    payload = json.loads((HERE / "generic_cubic.json").read_text())
    assert payload["schema"] == "G_GENERIC_KLEIN_CUBIC_V1"
    assert payload["coefficient_count"] == 35
    assert payload["primary_degrees"] == list(PRIMARY_DEGREES)
    assert payload["secondary_degrees"] == list(SECONDARY_DEGREES)

    _, frame, authoritative = all_coefficients()
    verify_expansion(frame, authoritative)
    seen = set()
    for item in payload["coefficients"]:
        triple = tuple(item["triple"])
        assert triple in authoritative and triple not in seen
        seen.add(triple)
        degree = item["degree"]
        assert degree == sum(payload["frame_degrees"][index] for index in triple)
        reconstructed = {}
        for entry, normalized in zip(item["entries"], item["normalized_entries"]):
            secondary = entry["secondary"]
            primary = tuple(entry["primary_exponents"])
            scalar = Fraction(entry["numerator"], entry["denominator"])
            assert normalized["secondary"] == secondary
            assert Fraction(normalized["numerator"], normalized["denominator"]) == scalar
            a3, a5, a6, a8, a11 = primary
            assert normalized["projective_exponents"] == [a3 + 2 * a5, a6, a8, a11]
            weighted = sum(a * d for a, d in zip(primary, PRIMARY_DEGREES))
            assert weighted + SECONDARY_DEGREES[secondary] == degree
            polynomial = multiply(primary_monomial(primary), secondary_polynomials()[secondary])
            add_scaled(reconstructed, polynomial, scalar)
        expected = {exponent: Fraction(coefficient) for exponent, coefficient in authoritative[triple].items()}
        assert reconstructed == expected, item["label"]
    assert seen == set(authoritative)
    print("G_GENERIC_CUBIC_35_COEFFICIENT_IDENTITIES_OK")
    print("G_PROJECTIVE_NORMALIZATION_35_COEFFICIENTS_OK")
    print("G_GENERIC_CUBIC_SUPPORT_UNDECIDED")


if __name__ == "__main__":
    main()
