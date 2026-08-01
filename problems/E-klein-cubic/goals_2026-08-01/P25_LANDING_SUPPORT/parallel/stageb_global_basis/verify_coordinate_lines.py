#!/usr/bin/env python3
"""Independent replay of the new r43 coordinate-line gcd certificates."""

from __future__ import annotations

from itertools import combinations
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
STRUCTURE = HERE.parent / "stageb_structure"
sys.path.insert(0, str(STRUCTURE))
from certify_coordinate_lines import (  # type: ignore  # noqa: E402
    DEGREE_BOUND,
    determinant_polynomial,
    matrix_inverse,
    polynomial_gcd,
    sha256,
)
from verify_structure import rank_mod, weak_compositions  # type: ignore  # noqa: E402


SOURCE = HERE / "support_balanced_r43_stageB.npz"
ARTIFACT = HERE / "support_balanced_coordinate_line_minors.npz"
RESULT = HERE / "verify_coordinate_lines_result.json"
P = 89


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
    vandermonde = np.asarray(
        [
            [pow(point, degree, P) for degree in range(DEGREE_BOUND + 1)]
            for point in range(DEGREE_BOUND + 1)
        ],
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
        if rank_mod(coefficients[:, :, 0]) != 6:
            raise AssertionError(f"zero endpoint rank failure on {left},{right}")
        if rank_mod(coefficients[:, :, 3]) != 6:
            raise AssertionError(f"infinity endpoint rank failure on {left},{right}")
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
                    f"determinant mismatch on {left},{right}, slot {slot}"
                )
            gcd = polynomial if not np.any(gcd) else polynomial_gcd(gcd, polynomial)
        if not (len(gcd) == 1 and int(gcd[0]) != 0):
            raise AssertionError(f"nonunit gcd on {left},{right}")

    unique, frequency = np.unique(counts, return_counts=True)
    distribution = {
        str(int(value)): int(count) for value, count in zip(unique, frequency)
    }
    result = {
        "status": "PASS_REPLAY_ALL_666_COORDINATE_LINES",
        "prime": P,
        "coordinate_lines": int(len(pairs)),
        "minor_count_distribution": distribution,
        "source_sha256": sha256(SOURCE),
        "artifact_sha256": sha256(ARTIFACT),
        "conclusion_scope": "no new-r43 contraction point with q-support <= 2",
    }
    RESULT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS: replayed all 666 new-r43 coordinate-line certificates")


if __name__ == "__main__":
    main()
