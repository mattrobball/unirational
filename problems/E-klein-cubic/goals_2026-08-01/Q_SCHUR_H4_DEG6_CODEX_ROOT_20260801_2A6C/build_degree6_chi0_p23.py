#!/usr/bin/env python3
"""Build the integral character-zero degree-six system modulo the split prime 23."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import build_degree6_msolve as builder
import probe_f55_covariants as model


HERE = Path(__file__).resolve().parent
PRIME = 23
DEGREE = 6
CHARACTER = 0


def main() -> None:
    assert PRIME % 11 == 1 and PRIME % 5 != 1
    basis, equations = model.equations(DEGREE, character=CHARACTER, prime=PRIME)
    rows = builder.sparse_echelon(equations.values(), prime=PRIME)
    variables = ",".join(f"c{index}" for index in range(len(basis)))
    lines = [variables, str(PRIME)]
    for index, row in enumerate(rows):
        lines.append(
            builder.polynomial_text(row) + ("," if index + 1 < len(rows) else "")
        )
    source = HERE / "degree6_chi0_p23.in"
    source.write_text("\n".join(lines) + "\n")
    record = {
        "schema": "klein-f55-degree6-chi0-p23-input-v1",
        "degree": DEGREE,
        "character_mod_5": CHARACTER,
        "prime": PRIME,
        "prime_splits_c11": PRIME % 11 == 1,
        "covariant_dimension": len(basis),
        "covariant_basis": [list(exponents) for exponents in basis],
        "raw_coefficient_equations": len(equations),
        "coefficient_row_rank": len(rows),
        "msolve_input": source.name,
        "msolve_input_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
        "msolve_input_bytes": source.stat().st_size,
        "role": (
            "Empty special fibre proves the integral character-zero generic fibre "
            "empty; the formal degree-six fifth-root diagonal isomorphism then "
            "covers all projective characters."
        ),
    }
    (HERE / "degree6_chi0_p23_input.json").write_text(
        json.dumps(record, indent=2, sort_keys=True) + "\n"
    )
    print(
        f"prime={PRIME} variables={len(basis)} raw={len(equations)} "
        f"rank={len(rows)} bytes={source.stat().st_size}"
    )
    print("Q_F55_DEGREE6_CHI0_P23_MSOLVE_INPUT_EXACT")


if __name__ == "__main__":
    main()
