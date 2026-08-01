#!/usr/bin/env python3
"""Exact low-memory Fitting probes for the P25 Stage B stratum.

This is deliberately not a global saturation.  It verifies:

* the exact 690 x 27 matrix formulation [M1(q)|M2(q)];
* full rank on all coordinate axes and coordinate projective lines;
* the same line exclusion for a support-balanced 15-row subsystem of the
  sealed 256 syzygy contractions;
* a deterministic 42-row compression which does not inherit the known
  prefix systems' missing-coordinate subspaces; and
* the absence of a degree-zero pure-power module certificate in the span of
  the 256 contraction rows.

All arithmetic is exact over F_89.  No conclusion is drawn away from the
tested coordinate-line union.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
CONTRACTED = P25 / "syzygy_r256_q0_contracted.npz"
LINEAR_SYZYGIES = P25 / "linear_syzygies.npz"
R48_SYZYGIES = P25 / "linear_syzygies_r48_reconstructed.npz"
R48_CONTRACTED = P25 / "syzygy_r48_q0_contracted.npz"
R96_CONTRACTED = P25 / "syzygy_r96_q0_contracted.npz"
P = 89
EXPECTED_CONTRACTED_SHA256 = (
    "2e718c491172480e3aa3f055d5806d28a9414db2627e6daf3f0204bdc3b840ea"
)
EXPECTED_LINEAR_SHA256 = (
    "f3787f317d851900de76da85ecb67018de5b48b0177d4e6e517634312f1c86a9"
)
EXPECTED_R48_SYZYGIES_SHA256 = (
    "95fb1405584468b6e327fa36617f8daafd32e7630d29526f9d09ae5f3820d5e8"
)
EXPECTED_R48_CONTRACTED_SHA256 = (
    "ba6d0533ab7fdb8bd93fb9309ce5b7d615f0a4799b22aa5e502e2dfec0bc21bb"
)
EXPECTED_R96_CONTRACTED_SHA256 = (
    "7bfa9b41cabbb2446041ac0fb561b4fa6b35b5a7c00f7e843598de543878c979"
)
AXIS_COVER_ROWS = [
    242, 243, 244, 225, 226, 228, 142, 143, 144, 145, 146, 227, 245, 246, 247
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def rank_mod(matrix: np.ndarray) -> int:
    a = matrix.astype(np.int64, copy=True) % P
    rows, columns = a.shape
    rank = 0
    for column in range(columns):
        nonzero = np.flatnonzero(a[rank:, column])
        if len(nonzero) == 0:
            continue
        pivot = rank + int(nonzero[0])
        if pivot != rank:
            a[[rank, pivot]] = a[[pivot, rank]]
        a[rank] = a[rank] * pow(int(a[rank, column]), -1, P) % P
        targets = np.flatnonzero(a[rank + 1 :, column]) + rank + 1
        if len(targets):
            a[targets] = (
                a[targets] - a[targets, column, None] * a[rank]
            ) % P
        rank += 1
        if rank == rows:
            break
    return rank


def determinant_mod(matrix: np.ndarray) -> int:
    a = matrix.astype(np.int64, copy=True) % P
    assert a.shape[0] == a.shape[1]
    size = a.shape[0]
    determinant = 1
    for column in range(size):
        nonzero = np.flatnonzero(a[column:, column])
        if len(nonzero) == 0:
            return 0
        pivot = column + int(nonzero[0])
        if pivot != column:
            a[[column, pivot]] = a[[pivot, column]]
            determinant = -determinant
        value = int(a[column, column])
        determinant = determinant * value % P
        a[column, column:] = (
            a[column, column:] * pow(value, -1, P)
        ) % P
        targets = np.flatnonzero(a[column + 1 :, column]) + column + 1
        if len(targets):
            a[targets, column:] = (
                a[targets, column:]
                - a[targets, column, None] * a[column, column:]
            ) % P
    return determinant % P


def inverse_mod(matrix: np.ndarray) -> np.ndarray:
    size = matrix.shape[0]
    assert matrix.shape == (size, size)
    augmented = np.concatenate(
        [matrix.astype(np.int64) % P, np.eye(size, dtype=np.int64)], axis=1
    )
    for column in range(size):
        nonzero = np.flatnonzero(augmented[column:, column])
        if len(nonzero) == 0:
            raise RuntimeError("singular interpolation matrix")
        pivot = column + int(nonzero[0])
        augmented[[column, pivot]] = augmented[[pivot, column]]
        augmented[column] = (
            augmented[column]
            * pow(int(augmented[column, column]), -1, P)
        ) % P
        for row in range(size):
            if row != column and augmented[row, column]:
                augmented[row] = (
                    augmented[row]
                    - augmented[row, column] * augmented[column]
                ) % P
    return augmented[:, size:]


def trim_polynomial(polynomial: np.ndarray) -> np.ndarray:
    answer = np.asarray(polynomial, dtype=np.int64) % P
    while len(answer) > 1 and answer[-1] == 0:
        answer = answer[:-1]
    return answer


def polynomial_gcd(left: np.ndarray, right: np.ndarray) -> np.ndarray:
    left = trim_polynomial(left)
    right = trim_polynomial(right)
    while not (len(right) == 1 and right[0] == 0):
        while len(left) >= len(right) and not (
            len(left) == 1 and left[0] == 0
        ):
            shift = len(left) - len(right)
            scalar = int(left[-1]) * pow(int(right[-1]), -1, P) % P
            left = trim_polynomial(
                left - scalar * np.pad(right, (shift, 0))
            )
        left, right = right, left
    return trim_polynomial(left * pow(int(left[-1]), -1, P))


def deterministic_matrix(tag: str, rows: int, columns: int) -> np.ndarray:
    raw = hashlib.shake_256(tag.encode("ascii")).digest(rows * columns)
    return (np.frombuffer(raw, dtype=np.uint8).reshape(rows, columns) % P).astype(
        np.int64
    )


def exponent_index(
    index: dict[tuple[int, ...], int], powers: dict[int, int]
) -> int:
    exponent = [0] * 37
    for variable, power in powers.items():
        exponent[variable] = power
    return index[tuple(exponent)]


def interpolate_determinant(
    coefficients: list[np.ndarray], inverse_vandermonde: np.ndarray
) -> np.ndarray:
    degree = len(inverse_vandermonde) - 1
    values = []
    for x in range(degree + 1):
        matrix = np.zeros_like(coefficients[0], dtype=np.int64)
        power = 1
        for coefficient in coefficients:
            matrix = (matrix + power * coefficient) % P
            power = power * x % P
        values.append(determinant_mod(matrix))
    return trim_polynomial(
        inverse_vandermonde @ np.asarray(values, dtype=np.int64) % P
    )


def line_gcd_histogram_full(
    compressed_b1: list[np.ndarray],
    compressed_b2: list[np.ndarray],
    q2_index: dict[tuple[int, ...], int],
) -> dict[int, int]:
    degree = 33
    vandermonde = np.asarray(
        [[pow(x, power, P) for power in range(degree + 1)] for x in range(degree + 1)],
        dtype=np.int64,
    )
    inverse_vandermonde = inverse_mod(vandermonde)
    histogram: dict[int, int] = {}
    for i in range(37):
        for j in range(i + 1, 37):
            ii = exponent_index(q2_index, {i: 2})
            ij = exponent_index(q2_index, {i: 1, j: 1})
            jj = exponent_index(q2_index, {j: 2})
            gcd = np.asarray([0], dtype=np.int64)
            used = 0
            for rb1, rb2 in zip(compressed_b1, compressed_b2):
                # q = x e_i + e_j.  The first six columns have degree two;
                # the final 21 columns have degree one.
                coefficients = [
                    np.concatenate([rb1[:, :, jj], rb2[:, :, j]], axis=1),
                    np.concatenate([rb1[:, :, ij], rb2[:, :, i]], axis=1),
                    np.concatenate(
                        [rb1[:, :, ii], np.zeros((27, 21), dtype=np.int64)],
                        axis=1,
                    ),
                ]
                polynomial = interpolate_determinant(
                    coefficients, inverse_vandermonde
                )
                gcd = (
                    polynomial
                    if len(gcd) == 1 and gcd[0] == 0
                    else polynomial_gcd(gcd, polynomial)
                )
                used += 1
                if len(gcd) == 1:
                    break
            if len(gcd) != 1:
                raise RuntimeError(f"full matrix line ({i},{j}) gcd has degree {len(gcd)-1}")
            histogram[used] = histogram.get(used, 0) + 1
    return histogram


def line_gcd_histogram_contracted(
    compressed: list[np.ndarray], q3_index: dict[tuple[int, ...], int]
) -> dict[int, int]:
    degree = 18
    vandermonde = np.asarray(
        [[pow(x, power, P) for power in range(degree + 1)] for x in range(degree + 1)],
        dtype=np.int64,
    )
    inverse_vandermonde = inverse_mod(vandermonde)
    histogram: dict[int, int] = {}
    for i in range(37):
        for j in range(i + 1, 37):
            iii = exponent_index(q3_index, {i: 3})
            iij = exponent_index(q3_index, {i: 2, j: 1})
            ijj = exponent_index(q3_index, {i: 1, j: 2})
            jjj = exponent_index(q3_index, {j: 3})
            gcd = np.asarray([0], dtype=np.int64)
            used = 0
            for matrix in compressed:
                coefficients = [
                    matrix[:, :, jjj],
                    matrix[:, :, ijj],
                    matrix[:, :, iij],
                    matrix[:, :, iii],
                ]
                polynomial = interpolate_determinant(
                    coefficients, inverse_vandermonde
                )
                gcd = (
                    polynomial
                    if len(gcd) == 1 and gcd[0] == 0
                    else polynomial_gcd(gcd, polynomial)
                )
                used += 1
                if len(gcd) == 1:
                    break
            if len(gcd) != 1:
                raise RuntimeError(
                    f"contracted matrix line ({i},{j}) gcd has degree {len(gcd)-1}"
                )
            histogram[used] = histogram.get(used, 0) + 1
    return histogram


def main() -> None:
    if sha256(CONTRACTED) != EXPECTED_CONTRACTED_SHA256:
        raise RuntimeError("sealed r256 contraction hash mismatch")
    with np.load(RELATION) as frozen:
        seeds = frozen["seed_F3"].astype(np.int64) % P
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise RuntimeError("relation prime mismatch")
    with np.load(CONTRACTED) as frozen:
        p3 = frozen["p3"].astype(np.int64) % P
        chosen_syzygies = frozen["chosen_syzygies"].astype(np.int32)
        if p3.shape != (256, 6, 9139) or int(frozen["prime"]) != P:
            raise RuntimeError("unexpected r256 contraction shape or prime")
    if sha256(LINEAR_SYZYGIES) != EXPECTED_LINEAR_SHA256:
        raise RuntimeError("sealed linear-syzygy hash mismatch")
    with np.load(LINEAR_SYZYGIES) as frozen:
        all_syzygies = frozen["syzygies"].astype(np.int64) % P
        if all_syzygies.shape != (256, 690, 37) or int(frozen["prime"]) != P:
            raise RuntimeError("unexpected linear-syzygy shape or prime")
    ordered_syzygies = all_syzygies[chosen_syzygies]
    missing_variables: dict[int, list[int]] = {}
    expected_missing = {
        43: list(range(4, 23)),
        48: list(range(4, 23)),
        96: list(range(4, 15)),
        256: [],
    }
    for prefix, expected in expected_missing.items():
        missing = np.flatnonzero(
            np.count_nonzero(ordered_syzygies[:prefix], axis=(0, 1)) == 0
        ).astype(int).tolist()
        if missing != expected:
            raise RuntimeError(
                f"prefix {prefix} missing-variable set {missing} != {expected}"
            )
        missing_variables[prefix] = missing
    if sha256(R48_SYZYGIES) != EXPECTED_R48_SYZYGIES_SHA256:
        raise RuntimeError("reconstructed r48 syzygy hash mismatch")
    with np.load(R48_SYZYGIES) as frozen:
        actual_r48_syzygies = frozen["syzygies"].astype(np.int64) % P
        actual_r96_syzygies = frozen["old_syzygies"].astype(np.int64) % P
    actual_r48_missing = np.flatnonzero(
        np.count_nonzero(actual_r48_syzygies, axis=(0, 1)) == 0
    ).astype(int).tolist()
    if actual_r48_missing != list(range(4, 12)):
        raise RuntimeError(
            f"actual r48 missing-variable set {actual_r48_missing} != q4,...,q11"
        )
    actual_r96_missing = np.flatnonzero(
        np.count_nonzero(actual_r96_syzygies, axis=(0, 1)) == 0
    ).astype(int).tolist()
    if actual_r96_missing:
        raise RuntimeError(
            f"actual old r96 unexpectedly misses variables {actual_r96_missing}"
        )

    q1 = weak_compositions(1, 37)
    q2 = weak_compositions(2, 37)
    q3 = weak_compositions(3, 37)
    q2_index = {monomial: index for index, monomial in enumerate(q2)}
    q3_index = {monomial: index for index, monomial in enumerate(q3)}
    variable_of = [monomial.index(1) for monomial in q1]

    def restricted_monomial_indices(variables: list[int]) -> list[int]:
        allowed = set(variables)
        return [
            index
            for index, exponent in enumerate(q3)
            if all(power == 0 or variable in allowed for variable, power in enumerate(exponent))
        ]

    if np.any(p3[:43, :, restricted_monomial_indices(list(range(4, 23)))]):
        raise RuntimeError("r256-prefix-43 equations do not vanish on q4,...,q22")
    if sha256(R48_CONTRACTED) != EXPECTED_R48_CONTRACTED_SHA256:
        raise RuntimeError("actual r48 contracted hash mismatch")
    with np.load(R48_CONTRACTED) as frozen:
        actual_r48_p3 = frozen["p3"].astype(np.int64) % P
    if np.any(actual_r48_p3[:, :, restricted_monomial_indices(list(range(4, 12)))]):
        raise RuntimeError("actual r48 equations do not vanish on q4,...,q11")
    if sha256(R96_CONTRACTED) != EXPECTED_R96_CONTRACTED_SHA256:
        raise RuntimeError("r96 contracted hash mismatch")
    with np.load(R96_CONTRACTED) as frozen:
        actual_r96_p3 = frozen["p3"].astype(np.int64) % P
    if actual_r96_p3.shape != (96, 6, 9139):
        raise RuntimeError("actual r96 contraction shape mismatch")

    b1 = np.stack(
        [
            seeds[:, int(offsets[1 + j]) : int(offsets[2 + j])]
            for j in range(6)
        ],
        axis=1,
    )
    b2 = np.empty((690, 21, 37), dtype=np.int64)
    for j in range(21):
        block = seeds[:, int(offsets[7 + j]) : int(offsets[8 + j])]
        for monomial_index, variable in enumerate(variable_of):
            b2[:, j, variable] = block[:, monomial_index]
    if b1.shape != (690, 6, 703) or b2.shape != (690, 21, 37):
        raise RuntimeError("bad M1/M2 tensor shape")
    flatten_rank = rank_mod(b2.reshape(690, 21 * 37))
    if flatten_rank != 690:
        raise RuntimeError(f"M2 coefficient flattening rank {flatten_rank} != 690")

    full_axis_ranks = []
    contracted_axis_ranks = []
    cover_axis_ranks = []
    cover = p3[AXIS_COVER_ROWS]
    for variable in range(37):
        q2_pure = exponent_index(q2_index, {variable: 2})
        q3_pure = exponent_index(q3_index, {variable: 3})
        full_axis_ranks.append(
            rank_mod(
                np.concatenate(
                    [b1[:, :, q2_pure], b2[:, :, variable]], axis=1
                )
            )
        )
        contracted_axis_ranks.append(rank_mod(p3[:, :, q3_pure]))
        cover_axis_ranks.append(rank_mod(cover[:, :, q3_pure]))
    if full_axis_ranks != [27] * 37:
        raise RuntimeError("full Stage B matrix loses rank on a coordinate axis")
    if contracted_axis_ranks != [6] * 37 or cover_axis_ranks != [6] * 37:
        raise RuntimeError("contraction subsystem loses rank on a coordinate axis")

    # Four exact, deterministic constant row compressions suffice for all
    # coordinate-line gcds (the verifier fails if they do not).
    full_compressed_b1 = []
    full_compressed_b2 = []
    for attempt in range(4):
        matrix = deterministic_matrix(f"stageb-full-line-{attempt}", 27, 690)
        full_compressed_b1.append(
            (matrix @ b1.reshape(690, -1) % P).reshape(27, 6, 703)
        )
        full_compressed_b2.append(
            (matrix @ b2.reshape(690, -1) % P).reshape(27, 21, 37)
        )
    full_line_histogram = line_gcd_histogram_full(
        full_compressed_b1, full_compressed_b2, q2_index
    )

    cover_compressed = []
    for attempt in range(4):
        matrix = deterministic_matrix(
            f"stageb-cover-line-{attempt}", 6, len(AXIS_COVER_ROWS)
        )
        cover_compressed.append(
            np.einsum("ar,rjm->ajm", matrix, cover, optimize=True) % P
        )
    cover_line_histogram = line_gcd_histogram_contracted(
        cover_compressed, q3_index
    )

    # A non-pure 256 x 256 minor simultaneously proves row independence and
    # rules out q_i^3 e_j in the constant span of the contraction rows.
    flat = p3.reshape(256, 6 * len(q3))
    pure_columns = {
        component * len(q3) + exponent_index(q3_index, {variable: 3})
        for component in range(6)
        for variable in range(37)
    }
    raw = hashlib.shake_256(b"stageb-nonpure-0").digest(8 * 400)
    candidates = np.frombuffer(raw, dtype="<u8") % flat.shape[1]
    nonpure_columns: list[int] = []
    seen: set[int] = set()
    for candidate in candidates:
        column = int(candidate)
        if column not in pure_columns and column not in seen:
            nonpure_columns.append(column)
            seen.add(column)
        if len(nonpure_columns) == 256:
            break
    if len(nonpure_columns) != 256 or rank_mod(flat[:, nonpure_columns]) != 256:
        raise RuntimeError("non-pure 256-square is not invertible")

    # Keep the proven 15-row axis/line cover, then add 27 dense exact linear
    # combinations.  This gives the boundary-format 42 x 6 cubic matrix for a
    # future determinantal-resultant or saturation calculation without the
    # coordinate-support defect of the old prefix systems.
    compression = np.zeros((42, 256), dtype=np.int64)
    for row, source in enumerate(AXIS_COVER_ROWS):
        compression[row, source] = 1
    compression[15:] = deterministic_matrix("stageb-balanced42", 27, 256)
    if rank_mod(compression) != 42:
        raise RuntimeError("balanced42 compression has rank below 42")
    balanced = np.einsum("ar,rjm->ajm", compression, p3, optimize=True) % P
    if rank_mod(balanced.reshape(42, -1)) != 42:
        raise RuntimeError("balanced42 polynomial rows have rank below 42")
    balanced_path = HERE / "balanced42.npz"
    np.savez_compressed(
        balanced_path,
        p3=balanced.astype(np.uint8),
        compression=compression.astype(np.uint8),
        axis_cover_rows=np.asarray(AXIS_COVER_ROWS, dtype=np.int32),
        prime=np.int32(P),
        source_sha256=np.asarray(EXPECTED_CONTRACTED_SHA256),
    )

    result = {
        "status": "PASS_BOUNDED_NONVERDICT",
        "prime": P,
        "sources": {
            "relation_matrix": str(RELATION),
            "relation_matrix_sha256": sha256(RELATION),
            "r256_contracted": str(CONTRACTED),
            "r256_contracted_sha256": sha256(CONTRACTED),
            "p3_array_sha256": sha256_array(p3.astype(np.uint8)),
            "linear_syzygies_sha256": sha256(LINEAR_SYZYGIES),
            "r48_reconstructed_syzygies_sha256": sha256(R48_SYZYGIES),
            "r48_contracted_sha256": sha256(R48_CONTRACTED),
            "r96_contracted_sha256": sha256(R96_CONTRACTED),
        },
        "exact_full_matrix": {
            "shape": [690, 27],
            "column_degrees": [2] * 6 + [1] * 21,
            "M2_coefficient_flattening_rank": flatten_rank,
            "coordinate_axis_ranks": full_axis_ranks,
            "coordinate_lines_checked": 666,
            "line_gcd_compression_histogram": {
                str(key): value for key, value in sorted(full_line_histogram.items())
            },
        },
        "r256_contractions": {
            "shape": list(p3.shape),
            "coordinate_axis_ranks": contracted_axis_ranks,
            "constant_row_rank": 256,
            "nonpure_invertible_minor_columns": nonpure_columns,
            "pure_q_i_cubed_basis_vectors_in_constant_row_span": False,
            "r256_order_prefix_missing_variables": {
                str(key): value for key, value in missing_variables.items()
            },
            "actual_r48_missing_variables": actual_r48_missing,
            "actual_old_r96_missing_variables": actual_r96_missing,
        },
        "axis_line_cover": {
            "rows": AXIS_COVER_ROWS,
            "row_count": len(AXIS_COVER_ROWS),
            "coordinate_axis_ranks": cover_axis_ranks,
            "coordinate_lines_checked": 666,
            "line_gcd_compression_histogram": {
                str(key): value for key, value in sorted(cover_line_histogram.items())
            },
        },
        "balanced42": {
            "artifact": balanced_path.name,
            "artifact_sha256": sha256(balanced_path),
            "shape": list(balanced.shape),
            "compression_rank": 42,
            "polynomial_row_rank": 42,
            "logical_scope": (
                "Every r256 zero is a balanced42 zero. Empty projective rank-drop "
                "locus of balanced42 would prove Stage B empty; a balanced42 "
                "survivor would not prove a true Stage B point."
            ),
        },
        "proved_scope": (
            "The exact Stage B locus and the r256 necessary rank-drop locus miss "
            "all 37 coordinate axes and all 666 coordinate projective lines. "
            "Thus a Stage B point, if any, has q-support at least three in this basis."
        ),
        "global_verdict": None,
    }
    result_path = HERE / "result.json"
    result_path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS_BOUNDED_NONVERDICT")
    print(f"full line histogram: {full_line_histogram}")
    print(f"15-row line histogram: {cover_line_histogram}")
    print(f"balanced42 sha256: {sha256(balanced_path)}")


if __name__ == "__main__":
    main()
