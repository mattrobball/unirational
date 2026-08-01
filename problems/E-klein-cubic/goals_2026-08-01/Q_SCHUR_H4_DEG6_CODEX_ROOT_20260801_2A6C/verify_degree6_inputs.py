#!/usr/bin/env python3
"""Rebuild and verify the complete degree-six msolve inputs."""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path

import build_degree6_msolve as builder
import probe_f55_covariants as model


HERE = Path(__file__).resolve().parent
PRIME = 331
DEGREE = 6


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def monomial_degree(value: str) -> int:
    factors = re.findall(r"c\d+(?:\^(\d+))?", value)
    assert factors
    return sum(int(exponent) if exponent else 1 for exponent in factors)


def main() -> None:
    payload = json.loads((HERE / "degree6_inputs.json").read_text())
    assert payload["schema"] == "klein-f55-degree6-msolve-inputs-v1"
    assert payload["normal_form"]["weights_mod_11"] == list(model.WEIGHTS)
    assert len(payload["records"]) == 5
    for character, record in enumerate(payload["records"]):
        assert record["degree"] == DEGREE
        assert record["character_mod_5"] == character
        assert record["prime"] == PRIME
        basis, coefficient_equations = model.equations(
            DEGREE, character=character, prime=PRIME
        )
        rows = builder.sparse_echelon(coefficient_equations.values())
        variables = ",".join(f"c{index}" for index in range(len(basis)))
        lines = [variables, str(PRIME)]
        for index, row in enumerate(rows):
            lines.append(
                builder.polynomial_text(row) + ("," if index + 1 < len(rows) else "")
            )
        regenerated = ("\n".join(lines) + "\n").encode()
        path = HERE / record["msolve_input"]
        assert path.read_bytes() == regenerated
        assert sha256_bytes(regenerated) == record["msolve_input_sha256"]
        assert len(regenerated) == record["msolve_input_bytes"]
        assert record["covariant_basis"] == [list(value) for value in basis]
        assert record["covariant_dimension"] == len(basis) == 19
        assert record["raw_coefficient_equations"] == len(coefficient_equations) == 640
        assert record["coefficient_row_rank"] == len(rows) == 128
        assert all(
            monomial_degree(monomial) == 3
            for line in lines[2:]
            for monomial in re.findall(r"c\d+(?:\^\d+)?(?:\*c\d+(?:\^\d+)?)*", line)
        )
        print(
            f"PASS character={character} variables=19 raw=640 rank=128 "
            f"sha256={record['msolve_input_sha256']}"
        )
    p23_record = json.loads((HERE / "degree6_chi0_p23_input.json").read_text())
    assert p23_record["schema"] == "klein-f55-degree6-chi0-p23-input-v1"
    basis, coefficient_equations = model.equations(DEGREE, character=0, prime=23)
    rows = builder.sparse_echelon(coefficient_equations.values(), prime=23)
    lines = [",".join(f"c{index}" for index in range(len(basis))), "23"]
    for index, row in enumerate(rows):
        lines.append(
            builder.polynomial_text(row) + ("," if index + 1 < len(rows) else "")
        )
    regenerated = ("\n".join(lines) + "\n").encode()
    p23_path = HERE / p23_record["msolve_input"]
    assert p23_path.read_bytes() == regenerated
    assert sha256_bytes(regenerated) == p23_record["msolve_input_sha256"]
    assert p23_record["prime"] == 23 and p23_record["prime_splits_c11"]
    assert p23_record["covariant_dimension"] == len(basis) == 19
    assert p23_record["raw_coefficient_equations"] == len(coefficient_equations) == 640
    assert p23_record["coefficient_row_rank"] == len(rows) == 128
    print(
        "PASS character=0 prime=23 variables=19 raw=640 rank=128 "
        f"sha256={p23_record['msolve_input_sha256']}"
    )
    print("Q_F55_DEGREE6_MSOLVE_INPUTS_INDEPENDENT_REPLAY_OK")


if __name__ == "__main__":
    main()
