#!/usr/bin/env python3
"""Certify rank six on all 666 coordinate lines for the new r43 packet."""

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
    row_basis,
    sha256,
)
from verify_structure import rank_mod, weak_compositions  # type: ignore  # noqa: E402


SOURCE = HERE / "support_balanced_r43_stageB.npz"
ARTIFACT = HERE / "support_balanced_coordinate_line_minors.npz"
SUMMARY = HERE / "support_balanced_coordinate_line_certificate.json"
P = 89
MAX_MINORS = 8


def main() -> None:
    with np.load(SOURCE, allow_pickle=False) as frozen:
        p3 = frozen["p3"].astype(np.int64)
        if int(frozen["prime"]) != P:
            raise AssertionError("prime mismatch")
    if p3.shape != (43, 6, 9139):
        raise AssertionError(f"unexpected P3 shape {p3.shape}")
    q3 = weak_compositions(3, 37)
    q3_index = {monomial: index for index, monomial in enumerate(q3)}

    points = np.arange(DEGREE_BOUND + 1, dtype=np.int64)
    vandermonde = np.asarray(
        [
            [pow(int(point), degree, P) for degree in range(DEGREE_BOUND + 1)]
            for point in points
        ],
        dtype=np.int64,
    )
    interpolation_inverse = matrix_inverse(vandermonde)
    pairs = np.asarray(list(combinations(range(37), 2)), dtype=np.int16)
    row_subsets = np.full((len(pairs), MAX_MINORS, 6), -1, dtype=np.int16)
    determinant_coefficients = np.zeros(
        (len(pairs), MAX_MINORS, DEGREE_BOUND + 1), dtype=np.uint8
    )
    minor_counts = np.zeros(len(pairs), dtype=np.uint8)
    base_order = np.arange(43, dtype=np.int16)

    for line_index, (left, right) in enumerate(pairs):
        coefficients = np.empty((43, 6, 4), dtype=np.int64)
        for right_power in range(4):
            exponent = [0] * 37
            exponent[int(left)] = 3 - right_power
            exponent[int(right)] = right_power
            coefficients[:, :, right_power] = p3[:, :, q3_index[tuple(exponent)]]
        at_zero = coefficients[:, :, 0]
        at_one = np.sum(coefficients, axis=2) % P
        at_infinity = coefficients[:, :, 3]
        if rank_mod(at_zero) != 6 or rank_mod(at_infinity) != 6:
            raise AssertionError(f"endpoint rank failure on {left},{right}")

        candidates: list[tuple[int, ...]] = []
        for shift in range(43):
            order = np.roll(base_order, -shift)
            candidates.extend(
                [
                    row_basis(at_zero, order),
                    row_basis(at_infinity, order),
                    row_basis(at_one, order),
                ]
            )
        used: list[tuple[int, ...]] = []
        gcd = np.zeros(1, dtype=np.int64)
        for rows in candidates:
            if rows in used:
                continue
            if len(used) == MAX_MINORS:
                break
            used.append(rows)
            polynomial = determinant_polynomial(
                coefficients, rows, interpolation_inverse
            )
            gcd = polynomial if not np.any(gcd) else polynomial_gcd(gcd, polynomial)
            slot = len(used) - 1
            row_subsets[line_index, slot] = np.asarray(rows, dtype=np.int16)
            determinant_coefficients[line_index, slot, : len(polynomial)] = (
                polynomial.astype(np.uint8)
            )
            if len(gcd) == 1 and int(gcd[0]) != 0:
                break
        if not (len(gcd) == 1 and int(gcd[0]) != 0):
            raise AssertionError(
                f"maximal-minor gcd nonunit on coordinate line {left},{right}"
            )
        minor_counts[line_index] = len(used)

    unique, frequency = np.unique(minor_counts, return_counts=True)
    distribution = {
        str(int(value)): int(count) for value, count in zip(unique, frequency)
    }
    np.savez_compressed(
        ARTIFACT,
        pairs=pairs,
        minor_counts=minor_counts,
        row_subsets=row_subsets,
        determinant_coefficients=determinant_coefficients,
        prime=np.int32(P),
        determinant_degree_bound=np.int32(DEGREE_BOUND),
        source_sha256=np.asarray(sha256(SOURCE)),
    )
    summary = {
        "status": "PASS_ALL_666_COORDINATE_LINES",
        "prime": P,
        "field_scope": "algebraic closure of F_89",
        "source": SOURCE.name,
        "source_sha256": sha256(SOURCE),
        "artifact": ARTIFACT.name,
        "artifact_sha256": sha256(ARTIFACT),
        "coordinate_lines": int(len(pairs)),
        "minor_count_distribution": distribution,
        "maximum_minors_per_line": int(np.max(minor_counts)),
        "determinant_degree_bound": DEGREE_BOUND,
        "interpolation_points": list(range(DEGREE_BOUND + 1)),
        "holdout_evaluation_point": DEGREE_BOUND + 1,
        "conclusion": (
            "The new r43 P3 matrix has rank six over the algebraic closure at "
            "every point of every q-coordinate line, excluding q-support <= 2."
        ),
        "limitation": "No global conclusion for q-support at least three.",
    }
    SUMMARY.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print("PASS: new r43 has rank six on all 666 coordinate lines")
    print(f"minor counts {distribution}; artifact {ARTIFACT.name}")


if __name__ == "__main__":
    main()
