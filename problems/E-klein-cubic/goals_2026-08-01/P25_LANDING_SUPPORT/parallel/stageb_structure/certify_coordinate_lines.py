#!/usr/bin/env python3
"""Certify full Stage-B contraction rank on every q-coordinate line.

For each of the 666 lines P<e_i,e_j>, restrict the selected 43x6 cubic
matrix to q=e_i+t e_j.  Its entries have degree at most three, so every 6x6
minor has degree at most eighteen.  Determinants are reconstructed from 19
exact F_89 evaluations and checked at a twentieth point.  Two or three
determinants with gcd one certify that the matrix has rank six at every finite
point over the algebraic closure; rank at infinity is checked separately.

This excludes q-support <= 2 for the necessary Stage-B contraction system.
It is not a global Stage-B emptiness certificate.
"""

from __future__ import annotations

import hashlib
from itertools import combinations
import json
from pathlib import Path

import numpy as np

from verify_structure import rank_mod, weak_compositions


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "support_cover_r43_stageB.npz"
ARTIFACT = HERE / "coordinate_line_minors.npz"
SUMMARY = HERE / "coordinate_line_certificate.json"
P = 89
DEGREE_BOUND = 18


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            h.update(chunk)
    return h.hexdigest()


def matrix_inverse(matrix: np.ndarray) -> np.ndarray:
    n = len(matrix)
    a = np.concatenate(
        [np.asarray(matrix, dtype=np.int64) % P, np.eye(n, dtype=np.int64)], axis=1
    )
    for column in range(n):
        candidates = np.flatnonzero(a[column:, column])
        if not len(candidates):
            raise AssertionError("singular interpolation matrix")
        pivot = column + int(candidates[0])
        a[[column, pivot]] = a[[pivot, column]]
        a[column] = (a[column] * pow(int(a[column, column]), -1, P)) % P
        for row in range(n):
            if row != column and a[row, column]:
                a[row] = (a[row] - a[row, column] * a[column]) % P
    return a[:, n:]


def determinant(matrix: np.ndarray) -> int:
    a = np.asarray(matrix, dtype=np.int64).copy() % P
    n = len(a)
    answer = 1
    for column in range(n):
        candidates = np.flatnonzero(a[column:, column])
        if not len(candidates):
            return 0
        pivot = column + int(candidates[0])
        if pivot != column:
            a[[column, pivot]] = a[[pivot, column]]
            answer = -answer
        value = int(a[column, column])
        answer = answer * value % P
        inverse = pow(value, -1, P)
        for row in range(column + 1, n):
            if a[row, column]:
                a[row] = (
                    a[row] - a[row, column] * inverse % P * a[column]
                ) % P
    return answer % P


def trim(polynomial: np.ndarray) -> np.ndarray:
    polynomial = np.asarray(polynomial, dtype=np.int64) % P
    support = np.flatnonzero(polynomial)
    if not len(support):
        return np.zeros(1, dtype=np.int64)
    return polynomial[: int(support[-1]) + 1]


def remainder(dividend: np.ndarray, divisor: np.ndarray) -> np.ndarray:
    dividend = trim(dividend).copy()
    divisor = trim(divisor)
    divisor_degree = len(divisor) - 1
    inverse_lead = pow(int(divisor[-1]), -1, P)
    while len(dividend) - 1 >= divisor_degree and np.any(dividend):
        shift = len(dividend) - 1 - divisor_degree
        coefficient = int(dividend[-1]) * inverse_lead % P
        dividend[shift : shift + len(divisor)] = (
            dividend[shift : shift + len(divisor)] - coefficient * divisor
        ) % P
        dividend = trim(dividend)
    return dividend


def polynomial_gcd(left: np.ndarray, right: np.ndarray) -> np.ndarray:
    left = trim(left)
    right = trim(right)
    while np.any(right):
        left, right = right, remainder(left, right)
    if not np.any(left):
        return left
    return left * pow(int(left[-1]), -1, P) % P


def row_basis(matrix: np.ndarray, order: np.ndarray) -> tuple[int, ...]:
    selected: list[int] = []
    current_rank = 0
    for raw_row in order:
        row = int(raw_row)
        new_rank = rank_mod(matrix[selected + [row]])
        if new_rank > current_rank:
            selected.append(row)
            current_rank = new_rank
        if current_rank == 6:
            return tuple(selected)
    raise AssertionError("matrix did not have row rank six")


def evaluate_matrix(coefficients: np.ndarray, value: int) -> np.ndarray:
    powers = np.asarray(
        [1, value % P, value * value % P, value * value * value % P],
        dtype=np.int64,
    )
    return np.einsum("rck,k->rc", coefficients, powers) % P


def determinant_polynomial(
    coefficients: np.ndarray,
    rows: tuple[int, ...],
    interpolation_inverse: np.ndarray,
) -> np.ndarray:
    values = np.empty(DEGREE_BOUND + 1, dtype=np.int64)
    for value in range(DEGREE_BOUND + 1):
        values[value] = determinant(evaluate_matrix(coefficients[list(rows)], value))
    polynomial = trim(interpolation_inverse @ values % P)
    # Independent twentieth-point check of the degree-bound interpolation.
    check_value = DEGREE_BOUND + 1
    expected = determinant(evaluate_matrix(coefficients[list(rows)], check_value))
    actual = sum(
        int(coefficient) * pow(check_value, exponent, P)
        for exponent, coefficient in enumerate(polynomial)
    ) % P
    if actual != expected:
        raise AssertionError("determinant interpolation check failed")
    return polynomial


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
        [[pow(int(point), degree, P) for degree in range(DEGREE_BOUND + 1)] for point in points],
        dtype=np.int64,
    )
    interpolation_inverse = matrix_inverse(vandermonde)

    pairs = np.asarray(list(combinations(range(37), 2)), dtype=np.int16)
    row_subsets = np.full((len(pairs), 3, 6), -1, dtype=np.int16)
    determinant_coefficients = np.zeros(
        (len(pairs), 3, DEGREE_BOUND + 1), dtype=np.uint8
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
            raise AssertionError(f"coordinate endpoint rank failure on {left},{right}")

        candidate_subsets: list[tuple[int, ...]] = []
        for shift in range(43):
            order = np.roll(base_order, -shift)
            candidate_subsets.extend(
                [
                    row_basis(at_zero, order),
                    row_basis(at_infinity, order),
                    row_basis(at_one, order),
                ]
            )

        used: list[tuple[int, ...]] = []
        gcd = np.zeros(1, dtype=np.int64)
        for rows in candidate_subsets:
            if rows in used:
                continue
            used.append(rows)
            polynomial = determinant_polynomial(
                coefficients, rows, interpolation_inverse
            )
            gcd = polynomial if not np.any(gcd) else polynomial_gcd(gcd, polynomial)
            slot = len(used) - 1
            if slot >= 3:
                raise AssertionError("more than three minors unexpectedly required")
            row_subsets[line_index, slot] = np.asarray(rows, dtype=np.int16)
            determinant_coefficients[line_index, slot, : len(polynomial)] = (
                polynomial.astype(np.uint8)
            )
            if len(gcd) == 1 and int(gcd[0]) != 0:
                break
        if not (len(gcd) == 1 and int(gcd[0]) != 0):
            raise AssertionError(f"maximal-minor gcd nonunit on line {left},{right}")
        minor_counts[line_index] = len(used)

    unique_counts, frequencies = np.unique(minor_counts, return_counts=True)
    count_distribution = {
        str(int(count)): int(frequency)
        for count, frequency in zip(unique_counts, frequencies)
    }
    if count_distribution != {"2": 639, "3": 27}:
        raise AssertionError(f"unexpected minor count distribution {count_distribution}")

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
        "status": "PASS",
        "prime": P,
        "field_scope": "algebraic closure of F_89",
        "source": SOURCE.name,
        "source_sha256": sha256(SOURCE),
        "artifact": ARTIFACT.name,
        "artifact_sha256": sha256(ARTIFACT),
        "coordinate_lines": int(len(pairs)),
        "minor_count_distribution": count_distribution,
        "maximum_minors_per_line": int(np.max(minor_counts)),
        "determinant_degree_bound": DEGREE_BOUND,
        "interpolation_points": list(range(DEGREE_BOUND + 1)),
        "holdout_evaluation_point": DEGREE_BOUND + 1,
        "conclusion": (
            "The selected necessary Stage-B contraction matrix has rank six at "
            "every point of every q-coordinate line. Hence the original Stage-B "
            "incidence has no point whose q-vector has support at most two."
        ),
        "limitation": (
            "Coordinate lines do not cover P^36. No statement is made for q with "
            "three or more nonzero coordinates, and no global emptiness follows."
        ),
    }
    SUMMARY.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print("PASS: all 666 q-coordinate lines have contraction rank six")
    print(f"minor counts {count_distribution}; artifact {ARTIFACT.name}")


if __name__ == "__main__":
    main()
