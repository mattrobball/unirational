#!/usr/bin/env python3
"""Independent replay of the augmented r66 coordinate-line certificate."""

from __future__ import annotations

import ctypes
import hashlib
from itertools import combinations
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
GB = HERE.parent / "stageb_global_basis"
EC = HERE.parent / "enlarged_closure"
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
FULL_BASIS = GB / "full_linear_syzygy_basis.npy"
FULL_P3 = GB / "full_p3_contractions.npy"
R64 = EC / "support_balanced_r64_stageBC.npz"
PACKET = HERE / "support_augmented_r66_stageBC.npz"
ARTIFACT = HERE / "augmented_coordinate_line_minors.npz"
RESULT = HERE / "verify_augmented_coordinate_lines_result.json"

P = 89
NQ = 37
DEGREE_BOUND = 22
EXPECTED_ADDED = np.asarray([8740, 9490], dtype=np.int32)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    answer: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            answer.append((first,) + tail)
    return answer


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


def inverse_mod(matrix: np.ndarray) -> np.ndarray:
    n = matrix.shape[0]
    augmented = np.concatenate(
        [matrix.astype(np.int64) % P, np.eye(n, dtype=np.int64)], axis=1
    )
    for column in range(n):
        candidates = np.flatnonzero(augmented[column:, column])
        if not len(candidates):
            raise AssertionError("singular Vandermonde matrix")
        pivot = column + int(candidates[0])
        augmented[[column, pivot]] = augmented[[pivot, column]]
        augmented[column] = (
            augmented[column]
            * pow(int(augmented[column, column]), -1, P)
        ) % P
        factors = augmented[:, column].copy()
        factors[column] = 0
        augmented = (augmented - factors[:, None] * augmented[column]) % P
    return augmented[:, n:]


def det_mod(matrix: np.ndarray) -> int:
    work = np.asarray(matrix, dtype=np.int64).copy() % P
    value = 1
    for column in range(work.shape[0]):
        candidates = np.flatnonzero(work[column:, column])
        if not len(candidates):
            return 0
        pivot = column + int(candidates[0])
        if pivot != column:
            work[[column, pivot]] = work[[pivot, column]]
            value = -value
        diagonal = int(work[column, column])
        value = value * diagonal % P
        inverse = pow(diagonal, -1, P)
        factors = work[column + 1 :, column] * inverse % P
        work[column + 1 :] = (
            work[column + 1 :] - factors[:, None] * work[column]
        ) % P
    return value % P


def trim(value: np.ndarray) -> np.ndarray:
    value = np.asarray(value, dtype=np.int64) % P
    support = np.flatnonzero(value)
    if not len(support):
        return np.zeros(1, dtype=np.int64)
    return value[: int(support[-1]) + 1]


def polynomial_remainder(left: np.ndarray, right: np.ndarray) -> np.ndarray:
    left = trim(left).copy()
    right = trim(right)
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
        left, right = right, polynomial_remainder(left, right)
    if not np.any(left):
        return left
    return left * pow(int(left[-1]), -1, P) % P


def evaluate(coefficients: np.ndarray, value: int) -> np.ndarray:
    powers = np.asarray([pow(value, degree, P) for degree in range(5)])
    return np.einsum("rck,k->rc", coefficients, powers) % P


def interpolate_determinant(
    coefficients: np.ndarray, rows: np.ndarray, inverse: np.ndarray
) -> np.ndarray:
    values = np.asarray(
        [
            det_mod(evaluate(coefficients[rows], value))
            for value in range(DEGREE_BOUND + 1)
        ],
        dtype=np.int64,
    )
    result = trim(inverse @ values % P)
    holdout = DEGREE_BOUND + 1
    if det_mod(evaluate(coefficients[rows], holdout)) != sum(
        int(coefficient) * pow(holdout, degree, P)
        for degree, coefficient in enumerate(result)
    ) % P:
        raise AssertionError("holdout determinant mismatch")
    return result


def product_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: index for index, monomial in enumerate(target)}
    result = np.empty((NQ, len(source)), dtype=np.int32)
    for variable in range(NQ):
        for source_index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            result[variable, source_index] = target_index[tuple(exponent)]
    return result


def recompute_added_p4(
    syzygies: np.ndarray,
    b0: np.ndarray,
    multiplication: np.ndarray,
    target_count: int,
) -> np.ndarray:
    result = np.zeros((len(syzygies), target_count), dtype=np.uint8)
    for variable in range(NQ):
        # This implementation deliberately uses integer einsum rather than the
        # producer's modular-double helper.
        contracted = np.einsum(
            "ar,rm->am",
            syzygies[:, :, variable].astype(np.int64),
            b0.astype(np.int64),
        ) % P
        targets = multiplication[variable]
        updated = result[:, targets].astype(np.int64) + contracted
        result[:, targets] = (updated % P).astype(np.uint8)
    return result


def main() -> None:
    for required in (RELATION, FULL_BASIS, FULL_P3, R64, PACKET, ARTIFACT):
        if not required.is_file():
            raise FileNotFoundError(required)
    basis = np.load(FULL_BASIS, mmap_mode="r")
    full_p3 = np.load(FULL_P3, mmap_mode="r")
    with np.load(R64, allow_pickle=False) as frozen:
        r64_columns = frozen["full_basis_columns"].astype(np.int32)
        r64_syzygies = frozen["syzygies"].astype(np.uint8)
        r64_p3 = frozen["p3"].astype(np.uint8)
        r64_p4 = frozen["p4"].astype(np.uint8)
    with np.load(PACKET, allow_pickle=False) as frozen:
        p3 = frozen["p3"].astype(np.uint8)
        p4 = frozen["p4"].astype(np.uint8)
        syzygies = frozen["syzygies"].astype(np.uint8)
        columns = frozen["full_basis_columns"].astype(np.int32)
        added = frozen["added_columns"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("packet prime mismatch")
        if str(frozen["full_basis_sha256"]) != sha256(FULL_BASIS):
            raise AssertionError("full-basis hash mismatch")
        if str(frozen["full_p3_sha256"]) != sha256(FULL_P3):
            raise AssertionError("full-P3 hash mismatch")
        if str(frozen["relation_matrix_sha256"]) != sha256(RELATION):
            raise AssertionError("relation hash mismatch")
        if str(frozen["r64_source_sha256"]) != sha256(R64):
            raise AssertionError("r64 hash mismatch")
    if not np.array_equal(added, EXPECTED_ADDED):
        raise AssertionError("unexpected extension rows")
    if not np.array_equal(columns, np.concatenate([r64_columns, added])):
        raise AssertionError("r66 column ledger mismatch")
    if not np.array_equal(syzygies[:64], r64_syzygies):
        raise AssertionError("r64 syzygies changed")
    if not np.array_equal(p3[:64], r64_p3) or not np.array_equal(p4[:64], r64_p4):
        raise AssertionError("r64 contractions changed")
    if not np.array_equal(syzygies[64:], np.asarray(basis[added])):
        raise AssertionError("added full syzygies mismatch")
    if not np.array_equal(p3[64:], np.asarray(full_p3[added])):
        raise AssertionError("added full P3 rows mismatch")

    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
    rebuilt_p4 = recompute_added_p4(
        syzygies[64:],
        seeds[:, int(offsets[0]) : int(offsets[1])],
        product_map(q3, q4),
        len(q4),
    )
    if not np.array_equal(rebuilt_p4, p4[64:]):
        raise AssertionError("independently rebuilt P4 rows mismatch")

    with np.load(ARTIFACT, allow_pickle=False) as frozen:
        pairs = frozen["pairs"].astype(np.int16)
        counts = frozen["minor_counts"].astype(np.uint8)
        rows = frozen["row_subsets"].astype(np.int16)
        stored = frozen["determinant_coefficients"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("artifact prime mismatch")
        if int(frozen["determinant_degree_bound"]) != DEGREE_BOUND:
            raise AssertionError("degree bound mismatch")
        if str(frozen["packet_sha256"]) != sha256(PACKET):
            raise AssertionError("packet hash mismatch")
    expected_pairs = np.asarray(list(combinations(range(NQ), 2)), dtype=np.int16)
    if not np.array_equal(pairs, expected_pairs):
        raise AssertionError("line enumeration mismatch")
    q3_index = {monomial: index for index, monomial in enumerate(q3)}
    q4_index = {monomial: index for index, monomial in enumerate(q4)}
    vandermonde = np.asarray(
        [
            [pow(point, degree, P) for degree in range(DEGREE_BOUND + 1)]
            for point in range(DEGREE_BOUND + 1)
        ],
        dtype=np.int64,
    )
    interpolation_inverse = inverse_mod(vandermonde)
    for line_index, pair in enumerate(pairs):
        left, right = map(int, pair)
        coefficients = np.zeros((66, 7, 5), dtype=np.int64)
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
        infinity = np.column_stack([coefficients[:, 0, 4], coefficients[:, 1:, 3]])
        if rank_mod(coefficients[:, :, 0]) != 7 or rank_mod(infinity) != 7:
            raise AssertionError(f"endpoint rank mismatch on {left},{right}")
        gcd = np.zeros(1, dtype=np.int64)
        for slot in range(int(counts[line_index])):
            selected = rows[line_index, slot].astype(np.intp)
            polynomial = interpolate_determinant(
                coefficients, selected, interpolation_inverse
            )
            padded = np.zeros(DEGREE_BOUND + 1, dtype=np.uint8)
            padded[: len(polynomial)] = polynomial.astype(np.uint8)
            if not np.array_equal(padded, stored[line_index, slot]):
                raise AssertionError(
                    f"stored determinant mismatch on {left},{right}, slot {slot}"
                )
            gcd = polynomial if not np.any(gcd) else polynomial_gcd(gcd, polynomial)
        if not (len(gcd) == 1 and int(gcd[0]) != 0):
            raise AssertionError(f"nonunit gcd on line {left},{right}")

    unique, frequencies = np.unique(counts, return_counts=True)
    distribution = {
        str(int(value)): int(frequency)
        for value, frequency in zip(unique, frequencies)
    }
    result = {
        "status": "PASS_INDEPENDENT_AUGMENTED_COORDINATE_LINE_REPLAY",
        "prime": P,
        "coordinate_lines": len(pairs),
        "minor_count_distribution": distribution,
        "r66_packet_sha256": sha256(PACKET),
        "certificate_sha256": sha256(ARTIFACT),
        "full_basis_sha256": sha256(FULL_BASIS),
        "full_p3_sha256": sha256(FULL_P3),
        "relation_matrix_sha256": sha256(RELATION),
        "scope": (
            "Exact augmented rank seven for q-support at most two only; no "
            "global emptiness conclusion."
        ),
    }
    RESULT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS: independently replayed all 666 augmented coordinate lines")


if __name__ == "__main__":
    main()

