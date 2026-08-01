#!/usr/bin/env python3
"""Produce exact certificates for two failed constructive subfamilies.

The results are structural exclusions, not a pointlessness theorem for the
generic cubic.  They cover (i) the ten coordinate lines of the normalized
five-vector frame and (ii) constant normalized frame coordinates.
"""

from __future__ import annotations

from fractions import Fraction
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[3]
GENERIC = PROBLEM / "goals_2026-08-01" / "G_ALL_DEGREE" / "generic_cubic.json"
PHI_SOURCE = PROBLEM / "tmp" / "generic_twist" / "phi_coefficients.py"
COVARIANT_SOURCE = PROBLEM / "certificates" / "exact_covariants_check.py"

sys.path.insert(0, str(HERE))
import build_frame_line_inputs  # noqa: E402


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def coefficient_matrix():
    payload = json.loads(GENERIC.read_text())
    keys = sorted(
        {
            (entry["secondary"], tuple(entry["projective_exponents"]))
            for coefficient in payload["coefficients"]
            for entry in coefficient["normalized_entries"]
        }
    )
    key_index = {key: index for index, key in enumerate(keys)}
    rows = [
        [Fraction(0) for _ in payload["coefficients"]]
        for _ in keys
    ]
    for column, coefficient in enumerate(payload["coefficients"]):
        for entry in coefficient["normalized_entries"]:
            key = (entry["secondary"], tuple(entry["projective_exponents"]))
            rows[key_index[key]][column] += Fraction(
                entry["numerator"], entry["denominator"]
            )
    return payload, keys, sp.Matrix(rows)


def main() -> None:
    build_frame_line_inputs.main()
    line_results = []
    for row in (HERE / "frame_lines.index").read_text().splitlines():
        label, filename = row.split()
        path = HERE / filename
        completed = subprocess.run(
            ["/opt/homebrew/bin/Singular", "-q", str(path)],
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
        output = completed.stdout
        ordinary = int(re.search(r"ORDINARY_FACTORS=(\d+)", output).group(1))
        absolute = int(re.search(r"ABSOLUTE_FACTOR_COUNT=(\d+)", output).group(1))
        classes = int(re.search(r"ABSOLUTE_FACTOR_CLASSES=(\d+)", output).group(1))
        assert ordinary == 2, (label, ordinary)
        assert absolute == 1 and classes == 1, (label, classes, absolute)
        line_results.append(
            {
                "label": label,
                "input": filename,
                "input_sha256": sha256(path),
                "ordinary_factor_list_length_including_unit": ordinary,
                "absolute_factor_classes": classes,
                "absolute_nonconstant_factor_count": absolute,
            }
        )

    payload, keys, matrix = coefficient_matrix()
    rank = matrix.rank()
    assert matrix.cols == 35 and rank == 35
    _, pivot_rows = matrix.T.rref()
    minor = matrix[list(pivot_rows), :]
    determinant = sp.factor(minor.det())
    numerator, denominator = map(int, sp.fraction(determinant))
    assert numerator != 0

    certificate = {
        "schema": "G_CONSTRUCTIVE_STRUCTURAL_EXCLUSIONS_V1",
        "scope": (
            "No point is produced. Excludes only the ten two-frame coordinate "
            "lines and the constant normalized-coordinate locus."
        ),
        "authoritative_inputs": {
            str(GENERIC.relative_to(PROBLEM)): sha256(GENERIC),
            str(PHI_SOURCE.relative_to(PROBLEM)): sha256(PHI_SOURCE),
            str(COVARIANT_SOURCE.relative_to(PROBLEM)): sha256(COVARIANT_SOURCE),
        },
        "frame_lines": line_results,
        "constant_coordinate_matrix": {
            "rows": matrix.rows,
            "columns": matrix.cols,
            "rank": rank,
            "row_keys": [
                {"secondary": secondary, "projective_exponents": list(exponents)}
                for secondary, exponents in keys
            ],
            "pivot_rows": list(pivot_rows),
            "minor_determinant": {
                "numerator": numerator,
                "denominator": denominator,
            },
        },
        "deduction": {
            "two_frame": (
                "Each F(U+tV) is absolutely irreducible over QQbar[x]. "
                "Gauss therefore gives no root in C(x0,...,x4), hence none "
                "in K_proj. Endpoints are also off the cubic."
            ),
            "constant_coordinates": (
                "The 98 coefficient rows span all 35 cubic monomials, so a "
                "constant normalized vector satisfying Phi has every degree-3 "
                "monomial zero and is the zero vector."
            ),
        },
    }
    output = HERE / "structural_exclusions.json"
    output.write_text(json.dumps(certificate, indent=2, sort_keys=True) + "\n")
    print(
        "G_CONSTRUCTIVE_STRUCTURAL_EXCLUSIONS_PRODUCED "
        f"frameLines={len(line_results)} constantRank={rank}"
    )


if __name__ == "__main__":
    main()
