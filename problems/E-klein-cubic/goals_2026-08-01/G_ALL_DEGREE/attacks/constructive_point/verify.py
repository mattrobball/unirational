#!/usr/bin/env python3
"""Independent replay of the constructive attack's exact deductions."""

from __future__ import annotations

from fractions import Fraction
import hashlib
import itertools
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
CERTIFICATE = HERE / "structural_exclusions.json"

sys.path.insert(0, str(PROBLEM / "tmp" / "generic_twist"))
sys.path.insert(0, str(HERE))
from phi_coefficients import all_coefficients  # noqa: E402
import build_frame_line_inputs  # noqa: E402


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rebuild_matrix():
    payload = json.loads(GENERIC.read_text())
    assert payload["coefficient_count"] == 35
    assert [tuple(item["triple"]) for item in payload["coefficients"]] == list(
        itertools.combinations_with_replacement(range(5), 3)
    )
    keys = sorted(
        {
            (entry["secondary"], tuple(entry["projective_exponents"]))
            for item in payload["coefficients"]
            for entry in item["normalized_entries"]
        }
    )
    location = {key: index for index, key in enumerate(keys)}
    rows = [[Fraction(0) for _ in range(35)] for _ in keys]
    for column, item in enumerate(payload["coefficients"]):
        for entry in item["normalized_entries"]:
            key = (entry["secondary"], tuple(entry["projective_exponents"]))
            rows[location[key]][column] += Fraction(
                entry["numerator"], entry["denominator"]
            )
    return keys, sp.Matrix(rows)


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    assert certificate["schema"] == "G_CONSTRUCTIVE_STRUCTURAL_EXCLUSIONS_V1"

    current_inputs = {
        str(GENERIC.relative_to(PROBLEM)): sha256(GENERIC),
        str(PHI_SOURCE.relative_to(PROBLEM)): sha256(PHI_SOURCE),
        str(COVARIANT_SOURCE.relative_to(PROBLEM)): sha256(COVARIANT_SOURCE),
    }
    assert certificate["authoritative_inputs"] == current_inputs

    # Reconstruct all four binary coefficients for each line directly from
    # the original covariants.  Nonzero endpoint coefficients exclude the
    # two points at t=0,infinity before factorization is considered.
    names, _, coefficients = all_coefficients()
    assert all(coefficients[(index, index, index)] for index in range(5))
    expected_labels = [
        f"{names[left]}_{names[right]}"
        for left in range(5)
        for right in range(left + 1, 5)
    ]
    build_frame_line_inputs.main()
    saved_lines = {row["label"]: row for row in certificate["frame_lines"]}
    assert list(saved_lines) == expected_labels
    for label in expected_labels:
        row = saved_lines[label]
        path = HERE / row["input"]
        assert sha256(path) == row["input_sha256"]
        completed = subprocess.run(
            ["/opt/homebrew/bin/Singular", "-q", str(path)],
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
        output = completed.stdout
        ordinary = int(re.search(r"ORDINARY_FACTORS=(\d+)", output).group(1))
        classes = int(re.search(r"ABSOLUTE_FACTOR_CLASSES=(\d+)", output).group(1))
        absolute = int(re.search(r"ABSOLUTE_FACTOR_COUNT=(\d+)", output).group(1))
        assert ordinary == 2
        assert classes == absolute == 1
        assert ordinary == row["ordinary_factor_list_length_including_unit"]
        assert classes == row["absolute_factor_classes"]
        assert absolute == row["absolute_nonconstant_factor_count"]
    print("PASS ten exact frame binary cubics are absolutely irreducible")

    keys, matrix = rebuild_matrix()
    saved = certificate["constant_coordinate_matrix"]
    assert (matrix.rows, matrix.cols, matrix.rank()) == (
        saved["rows"],
        saved["columns"],
        saved["rank"],
    ) == (98, 35, 35)
    assert saved["row_keys"] == [
        {"secondary": secondary, "projective_exponents": list(exponents)}
        for secondary, exponents in keys
    ]
    pivots = tuple(saved["pivot_rows"])
    determinant = sp.factor(matrix[list(pivots), :].det())
    numerator, denominator = map(int, sp.fraction(determinant))
    assert saved["minor_determinant"] == {
        "numerator": numerator,
        "denominator": denominator,
    }
    assert numerator != 0
    print(
        "PASS constant normalized-coordinate locus empty "
        f"rows={matrix.rows} rank={matrix.rank()}"
    )
    print("STRICT SCOPE no K_proj point found; arbitrary >=3-support coordinates remain")
    print("G_CONSTRUCTIVE_POINT_ATTACK_VERIFY_OK")


if __name__ == "__main__":
    main()
