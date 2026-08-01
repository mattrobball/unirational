#!/usr/bin/env python3
"""Verify the diagonal isomorphism among all degree-six character systems."""

from __future__ import annotations

import json
from pathlib import Path

import probe_f55_covariants as model


HERE = Path(__file__).resolve().parent
PRIME = 331
DEGREE = 6
ROOT5 = next(
    value
    for value in range(2, PRIME)
    if pow(value, 5, PRIME) == 1 and value != 1
)


def index_weight(exponents: tuple[int, ...]) -> int:
    return sum(index * exponent for index, exponent in enumerate(exponents)) % 5


def main() -> None:
    assert DEGREE % 5 == 1
    basis0, equations0 = model.equations(DEGREE, character=0, prime=PRIME)
    assert len(basis0) == 19 and len(equations0) == 640
    checks = 0
    for character in range(5):
        basis, equations = model.equations(
            DEGREE, character=character, prime=PRIME
        )
        assert basis == basis0 and equations.keys() == equations0.keys()
        coefficient_scales = [
            pow(ROOT5, -character * index_weight(exponents), PRIME)
            for exponents in basis
        ]
        for source_monomial, polynomial0 in equations0.items():
            equation_scale = pow(
                ROOT5, character * index_weight(source_monomial), PRIME
            )
            polynomial = equations[source_monomial]
            assert polynomial.keys() == polynomial0.keys()
            for coefficient_monomial, coefficient0 in polynomial0.items():
                expected = equation_scale * coefficient0
                for coordinate in coefficient_monomial:
                    expected *= coefficient_scales[coordinate]
                assert polynomial[coefficient_monomial] % PRIME == expected % PRIME
                checks += 1

    metadata = json.loads((HERE / "degree6_inputs.json").read_text())
    assert metadata["schema"] == "klein-f55-degree6-msolve-inputs-v1"
    assert len(metadata["records"]) == 5
    for character, record in enumerate(metadata["records"]):
        assert record["degree"] == DEGREE
        assert record["character_mod_5"] == character
        assert record["prime"] == PRIME
        assert record["covariant_dimension"] == 19
        assert record["raw_coefficient_equations"] == 640
        assert record["coefficient_row_rank"] == 128

    print(f"prime={PRIME} primitive_fifth_root={ROOT5} coefficient_checks={checks}")
    print("PASS all five degree-six projective-character systems are diagonally isomorphic")
    print("Q_F55_DEGREE6_ALL_CHARACTER_ISOMORPHISM_EXACT")


if __name__ == "__main__":
    main()
