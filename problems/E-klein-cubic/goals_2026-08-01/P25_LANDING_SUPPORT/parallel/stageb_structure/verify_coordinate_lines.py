#!/usr/bin/env python3
"""Replay the stored coordinate-line maximal-minor certificates."""

from __future__ import annotations

from itertools import combinations
import json
from pathlib import Path

import numpy as np

from certify_coordinate_lines import (
    ARTIFACT,
    DEGREE_BOUND,
    P,
    SOURCE,
    determinant_polynomial,
    matrix_inverse,
    polynomial_gcd,
    sha256,
)
from verify_structure import rank_mod, weak_compositions


HERE = Path(__file__).resolve().parent
RESULT = HERE / "verify_coordinate_lines_result.json"


def main() -> None:
    with np.load(SOURCE, allow_pickle=False) as frozen:
        p3 = frozen["p3"].astype(np.int64)
        if int(frozen["prime"]) != P:
            raise AssertionError("source prime mismatch")
    with np.load(ARTIFACT, allow_pickle=False) as frozen:
        pairs = frozen["pairs"].astype(np.int16)
        counts = frozen["minor_counts"].astype(np.uint8)
        rows = frozen["row_subsets"].astype(np.int16)
        stored = frozen["determinant_coefficients"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("certificate prime mismatch")
        if int(frozen["determinant_degree_bound"]) != DEGREE_BOUND:
            raise AssertionError("degree-bound mismatch")
        if str(frozen["source_sha256"]) != sha256(SOURCE):
            raise AssertionError("source hash mismatch")
    expected_pairs = np.asarray(list(combinations(range(37), 2)), dtype=np.int16)
    if not np.array_equal(pairs, expected_pairs):
        raise AssertionError("coordinate-line enumeration mismatch")

    q3 = weak_compositions(3, 37)
    q3_index = {monomial: index for index, monomial in enumerate(q3)}
    points = np.arange(DEGREE_BOUND + 1, dtype=np.int64)
    vandermonde = np.asarray(
        [[pow(int(point), degree, P) for degree in range(DEGREE_BOUND + 1)] for point in points],
        dtype=np.int64,
    )
    interpolation_inverse = matrix_inverse(vandermonde)

    for line_index, (left, right) in enumerate(pairs):
        coefficients = np.empty((43, 6, 4), dtype=np.int64)
        for right_power in range(4):
            exponent = [0] * 37
            exponent[int(left)] = 3 - right_power
            exponent[int(right)] = right_power
            coefficients[:, :, right_power] = p3[:, :, q3_index[tuple(exponent)]]
        if rank_mod(coefficients[:, :, 0]) != 6 or rank_mod(coefficients[:, :, 3]) != 6:
            raise AssertionError(f"endpoint rank failure on line {left},{right}")
        gcd = np.zeros(1, dtype=np.int64)
        for slot in range(int(counts[line_index])):
            row_subset = tuple(int(value) for value in rows[line_index, slot])
            polynomial = determinant_polynomial(
                coefficients, row_subset, interpolation_inverse
            )
            padded = np.zeros(DEGREE_BOUND + 1, dtype=np.uint8)
            padded[: len(polynomial)] = polynomial.astype(np.uint8)
            if not np.array_equal(padded, stored[line_index, slot]):
                raise AssertionError(
                    f"stored determinant mismatch on line {left},{right}, slot {slot}"
                )
            gcd = polynomial if not np.any(gcd) else polynomial_gcd(gcd, polynomial)
        if not (len(gcd) == 1 and int(gcd[0]) != 0):
            raise AssertionError(f"nonunit minor gcd on line {left},{right}")

    unique, frequency = np.unique(counts, return_counts=True)
    distribution = {
        str(int(value)): int(number) for value, number in zip(unique, frequency)
    }
    result = {
        "status": "PASS",
        "prime": P,
        "coordinate_lines": int(len(pairs)),
        "minor_count_distribution": distribution,
        "source_sha256": sha256(SOURCE),
        "artifact_sha256": sha256(ARTIFACT),
        "conclusion_scope": "no selected-contraction point with q-support <= 2",
    }
    RESULT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS: replayed 666 coordinate-line unit-gcd certificates")


if __name__ == "__main__":
    main()
