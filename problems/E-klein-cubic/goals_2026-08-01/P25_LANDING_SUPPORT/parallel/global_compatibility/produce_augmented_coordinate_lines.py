#!/usr/bin/env python3
"""Certify augmented rank seven on every q-coordinate line.

The existing support-balanced r43 and r64 packets both have augmented rank
only six at q4,q5,q6,q7.  This producer deterministically extends r64 by the
two full-basis rows 8740 and 9490.  The resulting r66 packet has rank seven at
all 37 coordinate axes.

For each of the 666 coordinate lines, every 7 by 7 maximal minor has degree at
most 4+6*3=22.  We interpolate selected determinants at 23 exact F_89 values,
check them at a holdout value, and store enough minors to have gcd one.  This
proves rank seven over the algebraic closure at every point of every
coordinate line.  It is only a support-at-most-two certificate, not a global
rank theorem.
"""

from __future__ import annotations

import ctypes
import hashlib
from itertools import combinations
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
GB = HERE.parent / "stageb_global_basis"
EC = HERE.parent / "enlarged_closure"
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
FULL_BASIS = GB / "full_linear_syzygy_basis.npy"
FULL_P3 = GB / "full_p3_contractions.npy"
R64 = EC / "support_balanced_r64_stageBC.npz"
PACKET = HERE / "support_augmented_r66_stageBC.npz"
ARTIFACT = HERE / "augmented_coordinate_line_minors.npz"
SUMMARY = HERE / "augmented_coordinate_line_certificate.json"

P = 89
NQ = 37
ADDED_COLUMNS = np.asarray([8740, 9490], dtype=np.int32)
DEGREE_BOUND = 22
MAX_MINORS = 10


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def array_sha256(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def multiplication_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: index for index, monomial in enumerate(target)}
    answer = np.empty((NQ, len(source)), dtype=np.int32)
    for variable in range(NQ):
        for index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            answer[variable, index] = target_index[tuple(exponent)]
    return answer


def contract_p4(
    syzygies: np.ndarray,
    block: np.ndarray,
    product_map: np.ndarray,
    target_count: int,
) -> np.ndarray:
    output = np.zeros((len(syzygies), target_count), dtype=np.uint8)
    right = np.asarray(block, dtype=np.float64)
    for variable in range(NQ):
        product = np.ascontiguousarray(
            syzygies[:, :, variable], dtype=np.float64
        ) @ right
        # 690*88^2 < 2^53, so this modular-double product is exact.
        np.remainder(product, float(P), out=product)
        addition = product.astype(np.uint8)
        indices = product_map[variable]
        updated = output[:, indices].astype(np.uint16)
        updated += addition
        np.remainder(updated, P, out=updated)
        output[:, indices] = updated.astype(np.uint8)
    return output


def rank_mod(matrix: np.ndarray) -> int:
    dense = np.ascontiguousarray(matrix, dtype=np.float64)
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.Rank_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rows, columns = dense.shape
    return int(function(float(P), rows, columns, dense, columns, False))


def matrix_inverse(matrix: np.ndarray) -> np.ndarray:
    n = len(matrix)
    work = np.concatenate(
        [np.asarray(matrix, dtype=np.int64) % P, np.eye(n, dtype=np.int64)],
        axis=1,
    )
    for column in range(n):
        candidates = np.flatnonzero(work[column:, column])
        if not len(candidates):
            raise AssertionError("singular interpolation matrix")
        pivot = column + int(candidates[0])
        work[[column, pivot]] = work[[pivot, column]]
        work[column] = (
            work[column] * pow(int(work[column, column]), -1, P)
        ) % P
        for row in range(n):
            if row != column and work[row, column]:
                work[row] = (
                    work[row] - work[row, column] * work[column]
                ) % P
    return work[:, n:]


def determinant(matrix: np.ndarray) -> int:
    work = np.asarray(matrix, dtype=np.int64).copy() % P
    answer = 1
    for column in range(len(work)):
        candidates = np.flatnonzero(work[column:, column])
        if not len(candidates):
            return 0
        pivot = column + int(candidates[0])
        if pivot != column:
            work[[column, pivot]] = work[[pivot, column]]
            answer = -answer
        value = int(work[column, column])
        answer = answer * value % P
        inverse = pow(value, -1, P)
        for row in range(column + 1, len(work)):
            if work[row, column]:
                work[row] = (
                    work[row]
                    - work[row, column] * inverse % P * work[column]
                ) % P
    return answer % P


def trim(polynomial: np.ndarray) -> np.ndarray:
    value = np.asarray(polynomial, dtype=np.int64) % P
    support = np.flatnonzero(value)
    return (
        np.zeros(1, dtype=np.int64)
        if not len(support)
        else value[: int(support[-1]) + 1]
    )


def remainder(dividend: np.ndarray, divisor: np.ndarray) -> np.ndarray:
    left = trim(dividend).copy()
    right = trim(divisor)
    inverse = pow(int(right[-1]), -1, P)
    while np.any(left) and len(left) >= len(right):
        shift = len(left) - len(right)
        coefficient = int(left[-1]) * inverse % P
        left[shift : shift + len(right)] = (
            left[shift : shift + len(right)] - coefficient * right
        ) % P
        left = trim(left)
    return left


def polynomial_gcd(left: np.ndarray, right: np.ndarray) -> np.ndarray:
    left = trim(left)
    right = trim(right)
    while np.any(right):
        left, right = right, remainder(left, right)
    if not np.any(left):
        return left
    return left * pow(int(left[-1]), -1, P) % P


def evaluate(coefficients: np.ndarray, value: int) -> np.ndarray:
    powers = np.asarray([pow(value % P, degree, P) for degree in range(5)])
    return np.einsum("rck,k->rc", coefficients, powers) % P


def row_basis(matrix: np.ndarray, order: np.ndarray) -> tuple[int, ...]:
    selected: list[int] = []
    current = 0
    for raw in order:
        candidate = selected + [int(raw)]
        new = rank_mod(matrix[candidate])
        if new > current:
            selected = candidate
            current = new
        if current == 7:
            return tuple(selected)
    raise AssertionError("augmented matrix did not have row rank seven")


def determinant_polynomial(
    coefficients: np.ndarray,
    rows: tuple[int, ...],
    interpolation_inverse: np.ndarray,
) -> np.ndarray:
    values = np.asarray(
        [
            determinant(evaluate(coefficients[list(rows)], value))
            for value in range(DEGREE_BOUND + 1)
        ],
        dtype=np.int64,
    )
    polynomial = trim(interpolation_inverse @ values % P)
    holdout = DEGREE_BOUND + 1
    expected = determinant(evaluate(coefficients[list(rows)], holdout))
    actual = sum(
        int(coefficient) * pow(holdout, degree, P)
        for degree, coefficient in enumerate(polynomial)
    ) % P
    if actual != expected:
        raise AssertionError("determinant interpolation holdout failed")
    return polynomial


def main() -> None:
    for required in (RELATION, FULL_BASIS, FULL_P3, R64):
        if not required.is_file():
            raise FileNotFoundError(required)
    basis = np.load(FULL_BASIS, mmap_mode="r")
    full_p3 = np.load(FULL_P3, mmap_mode="r")
    with np.load(R64, allow_pickle=False) as frozen:
        r64_p4 = frozen["p4"].astype(np.uint8)
        r64_p3 = frozen["p3"].astype(np.uint8)
        r64_syzygies = frozen["syzygies"].astype(np.uint8)
        r64_columns = frozen["full_basis_columns"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("r64 prime mismatch")
    added_syzygies = np.asarray(basis[ADDED_COLUMNS], dtype=np.uint8)
    added_p3 = np.asarray(full_p3[ADDED_COLUMNS], dtype=np.uint8)
    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime mismatch")
    added_p4 = contract_p4(
        added_syzygies,
        seeds[:, int(offsets[0]) : int(offsets[1])],
        multiplication_map(q3, q4),
        len(q4),
    )
    p3 = np.concatenate([r64_p3, added_p3], axis=0)
    p4 = np.concatenate([r64_p4, added_p4], axis=0)
    syzygies = np.concatenate([r64_syzygies, added_syzygies], axis=0)
    columns = np.concatenate([r64_columns, ADDED_COLUMNS])
    if p3.shape != (66, 6, 9139) or p4.shape != (66, 91390):
        raise AssertionError("r66 tensor shape mismatch")
    np.savez_compressed(
        PACKET,
        p4=p4,
        p3=p3,
        syzygies=syzygies,
        full_basis_columns=columns,
        added_columns=ADDED_COLUMNS,
        prime=np.int32(P),
        full_basis_sha256=np.asarray(sha256(FULL_BASIS)),
        full_p3_sha256=np.asarray(sha256(FULL_P3)),
        relation_matrix_sha256=np.asarray(sha256(RELATION)),
        r64_source_sha256=np.asarray(sha256(R64)),
    )

    q3_index = {monomial: index for index, monomial in enumerate(q3)}
    q4_index = {monomial: index for index, monomial in enumerate(q4)}
    r43_axis_ranks: list[int] = []
    r64_axis_ranks: list[int] = []
    r66_axis_ranks: list[int] = []
    for variable in range(NQ):
        exponent3 = [0] * NQ
        exponent4 = [0] * NQ
        exponent3[variable] = 3
        exponent4[variable] = 4
        m3 = q3_index[tuple(exponent3)]
        m4 = q4_index[tuple(exponent4)]
        augmented = np.column_stack([p4[:, m4], p3[:, :, m3]])
        r43_axis_ranks.append(rank_mod(augmented[:43]))
        r64_axis_ranks.append(rank_mod(augmented[:64]))
        r66_axis_ranks.append(rank_mod(augmented))
    if r43_axis_ranks != r64_axis_ranks:
        raise AssertionError("expected identical r43/r64 augmented axis profile")
    if [i for i, value in enumerate(r64_axis_ranks) if value < 7] != [4, 5, 6, 7]:
        raise AssertionError("r64 deficient-axis profile changed")
    if r66_axis_ranks != [7] * NQ:
        raise AssertionError("r66 does not cover all coordinate axes")

    vandermonde = np.asarray(
        [
            [pow(point, degree, P) for degree in range(DEGREE_BOUND + 1)]
            for point in range(DEGREE_BOUND + 1)
        ],
        dtype=np.int64,
    )
    interpolation_inverse = matrix_inverse(vandermonde)
    pairs = np.asarray(list(combinations(range(NQ), 2)), dtype=np.int16)
    row_subsets = np.full((len(pairs), MAX_MINORS, 7), -1, dtype=np.int16)
    determinant_coefficients = np.zeros(
        (len(pairs), MAX_MINORS, DEGREE_BOUND + 1), dtype=np.uint8
    )
    minor_counts = np.zeros(len(pairs), dtype=np.uint8)
    base_order = np.arange(len(p3), dtype=np.int16)
    evaluation_values = (0, 1, 2, 3, DEGREE_BOUND + 1)

    for line_index, (left_raw, right_raw) in enumerate(pairs):
        left, right = int(left_raw), int(right_raw)
        coefficients = np.zeros((len(p3), 7, 5), dtype=np.int64)
        for right_power in range(5):
            exponent = [0] * NQ
            exponent[left] = 4 - right_power
            exponent[right] = right_power
            coefficients[:, 0, right_power] = p4[
                :, q4_index[tuple(exponent)]
            ]
        for right_power in range(4):
            exponent = [0] * NQ
            exponent[left] = 3 - right_power
            exponent[right] = right_power
            coefficients[:, 1:, right_power] = p3[
                :, :, q3_index[tuple(exponent)]
            ]
        finite = {value: evaluate(coefficients, value) for value in evaluation_values}
        infinity = np.column_stack([coefficients[:, 0, 4], coefficients[:, 1:, 3]])
        if rank_mod(finite[0]) != 7 or rank_mod(infinity) != 7:
            raise AssertionError(f"endpoint rank failure on line {left},{right}")
        candidates: list[tuple[int, ...]] = []
        for shift in range(len(p3)):
            order = np.roll(base_order, -shift)
            candidates.extend(row_basis(finite[value], order) for value in evaluation_values)
            candidates.append(row_basis(infinity, order))
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
            row_subsets[line_index, slot] = rows
            determinant_coefficients[line_index, slot, : len(polynomial)] = (
                polynomial.astype(np.uint8)
            )
            if len(gcd) == 1 and int(gcd[0]) != 0:
                break
        if not (len(gcd) == 1 and int(gcd[0]) != 0):
            raise AssertionError(
                f"no unit maximal-minor gcd on line {left},{right}"
            )
        minor_counts[line_index] = len(used)
        if (line_index + 1) % 100 == 0:
            print(f"certified lines {line_index + 1}/{len(pairs)}", flush=True)

    unique, counts = np.unique(minor_counts, return_counts=True)
    distribution = {
        str(int(value)): int(count) for value, count in zip(unique, counts)
    }
    np.savez_compressed(
        ARTIFACT,
        pairs=pairs,
        minor_counts=minor_counts,
        row_subsets=row_subsets,
        determinant_coefficients=determinant_coefficients,
        prime=np.int32(P),
        determinant_degree_bound=np.int32(DEGREE_BOUND),
        packet_sha256=np.asarray(sha256(PACKET)),
    )
    summary = {
        "status": "PASS_AUGMENTED_RANK7_ALL_666_COORDINATE_LINES",
        "prime": P,
        "field_scope": "algebraic closure of F_89",
        "source": {
            "full_basis_sha256": sha256(FULL_BASIS),
            "full_p3_sha256": sha256(FULL_P3),
            "relation_matrix_sha256": sha256(RELATION),
            "r64_sha256": sha256(R64),
        },
        "r43_augmented_axis_ranks": r43_axis_ranks,
        "r64_augmented_axis_ranks": r64_axis_ranks,
        "r64_deficient_axes": [4, 5, 6, 7],
        "r66_added_full_basis_columns": ADDED_COLUMNS.astype(int).tolist(),
        "r66_augmented_axis_ranks": r66_axis_ranks,
        "r66_packet": {
            "file": PACKET.name,
            "sha256": sha256(PACKET),
            "p3_sha256": array_sha256(p3),
            "p4_sha256": array_sha256(p4),
        },
        "coordinate_lines": len(pairs),
        "determinant_degree_bound": DEGREE_BOUND,
        "minor_count_distribution": distribution,
        "maximum_minors_per_line": int(np.max(minor_counts)),
        "certificate": {"file": ARTIFACT.name, "sha256": sha256(ARTIFACT)},
        "conclusion": (
            "The exact r66 augmented contraction has rank seven over the "
            "algebraic closure at every point with q-support at most two."
        ),
        "limitation": (
            "Coordinate lines do not cover P^36. This is not a global Stage-B, "
            "Stage-C, or degree-25 emptiness certificate."
        ),
    }
    SUMMARY.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print("PASS: augmented r66 rank seven on all 666 coordinate lines")
    print(f"minor counts {distribution}")


if __name__ == "__main__":
    main()

