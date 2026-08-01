#!/usr/bin/env python3
"""Build row-reduced complete degree-six 11:5 landing systems."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
from collections import Counter

import probe_f55_covariants as model


HERE = Path(__file__).resolve().parent
PRIME = 331
DEGREE = 6


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sparse_echelon(polynomials, prime: int = PRIME):
    """Return a deterministic sparse row-echelon basis over the given field."""
    pivots = {}
    for polynomial in polynomials:
        row = {term: value % prime for term, value in polynomial.items() if value % prime}
        while row:
            pivot = max(row)
            if pivot not in pivots:
                inverse = pow(row[pivot], -1, prime)
                row = {term: value * inverse % prime for term, value in row.items()}
                pivots[pivot] = row
                break
            scale = row[pivot]
            old = pivots[pivot]
            for term, value in old.items():
                new_value = (row.get(term, 0) - scale * value) % prime
                if new_value:
                    row[term] = new_value
                elif term in row:
                    del row[term]
    return [pivots[pivot] for pivot in sorted(pivots, reverse=True)]


def polynomial_text(polynomial):
    terms = []
    for indices, coefficient in sorted(polynomial.items(), reverse=True):
        powers = Counter(indices)
        monomial = "*".join(
            f"c{i}" if exponent == 1 else f"c{i}^{exponent}"
            for i, exponent in sorted(powers.items())
        )
        if coefficient == 1:
            terms.append(monomial)
        else:
            terms.append(f"{coefficient}*{monomial}")
    return "+".join(terms) or "0"


def main() -> None:
    records = []
    for character in range(5):
        basis, coefficient_equations = model.equations(
            DEGREE, character=character, prime=PRIME
        )
        rows = sparse_echelon(coefficient_equations.values())
        variables = ",".join(f"c{i}" for i in range(len(basis)))
        path = HERE / f"degree6_chi{character}_p331.in"
        lines = [variables, str(PRIME)]
        for index, row in enumerate(rows):
            suffix = "," if index + 1 < len(rows) else ""
            lines.append(polynomial_text(row) + suffix)
        path.write_text("\n".join(lines) + "\n")
        record = {
            "degree": DEGREE,
            "character_mod_5": character,
            "prime": PRIME,
            "covariant_dimension": len(basis),
            "covariant_basis": [list(exponents) for exponents in basis],
            "raw_coefficient_equations": len(coefficient_equations),
            "coefficient_row_rank": len(rows),
            "msolve_input": path.name,
            "msolve_input_sha256": sha256(path),
            "msolve_input_bytes": path.stat().st_size,
        }
        records.append(record)
        print(
            f"chi={character} variables={len(basis)} "
            f"raw={len(coefficient_equations)} rank={len(rows)} "
            f"bytes={path.stat().st_size}"
        )
    payload = {
        "schema": "klein-f55-degree6-msolve-inputs-v1",
        "normal_form": {
            "weights_mod_11": list(model.WEIGHTS),
            "klein_cubic": "sum_i x_i^2*x_(i+1)",
        },
        "records": records,
    }
    (HERE / "degree6_inputs.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("Q_F55_DEGREE6_MSOLVE_INPUTS_EXACT")


if __name__ == "__main__":
    main()
