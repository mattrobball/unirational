#!/usr/bin/env python3
"""Recompute and persist the complete degree-one FFLAS syzygy basis.

The exact syzygy problem is

    C(q) M2(q) = 0,

where M2 is the 690 by 21 block linear in 37 q variables.  Its coefficient
matrix has shape 14763 by 25530 over F_89.  This producer recomputes the full
10,767-column right-nullspace basis with FFLAS-FFPACK, writes it as a uint8
NumPy array, and records global sparsity, q-support, and coordinate-axis P3
evaluations.  No Singular process is launched.

The large arrays are written in small chunks.  The only high-memory step is
the already established FFLAS nullspace call (about 5.5 GiB of resident dense
arrays at its peak).  A conservative free-page guard runs before allocation.
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import re
import subprocess
import time

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
ROOT = HERE.parents[3]
FM = ROOT / "certificates" / "degree25_finite_module"
RELATION = FM / "relation_matrix.npz"
P = 89
NROWS = 690
NQ = 37
NB2 = 21
NULLITY = 10767


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    out: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            out.append((first,) + tail)
    return out


def free_gib_from_vm_stat() -> float | None:
    """Return macOS free+speculative pages, or None off macOS."""
    try:
        output = subprocess.check_output(["vm_stat"], text=True)
    except (FileNotFoundError, subprocess.CalledProcessError):
        return None
    page_match = re.search(r"page size of (\d+) bytes", output)
    free_match = re.search(r"Pages free:\s+(\d+)\.", output)
    speculative_match = re.search(r"Pages speculative:\s+(\d+)\.", output)
    if not page_match or not free_match:
        return None
    pages = int(free_match.group(1))
    if speculative_match:
        pages += int(speculative_match.group(1))
    return pages * int(page_match.group(1)) / 2**30


def fflas_right_nullspace(matrix: np.ndarray) -> tuple[np.ndarray, int]:
    """Return the FFLAS-owned N x nullity right-nullspace basis."""
    if matrix.dtype != np.float64 or not matrix.flags.c_contiguous:
        raise TypeError("FFLAS input must be C-contiguous float64")
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    symbol = (
        "_Z29NullSpaceBasis_modular_doubledN5FFLAS10FFLAS_SIDEEmm"
        "PdmPS1_PmS3_b"
    )
    function = getattr(library, symbol)
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_int,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.POINTER(ctypes.c_double)),
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    pointer = ctypes.POINTER(ctypes.c_double)()
    leading = ctypes.c_size_t()
    nullity = ctypes.c_size_t()
    rows, columns = matrix.shape
    returned = function(
        float(P),
        142,  # FflasRight
        rows,
        columns,
        matrix,
        columns,
        ctypes.byref(pointer),
        ctypes.byref(leading),
        ctypes.byref(nullity),
        False,
    )
    if returned != nullity.value or leading.value != nullity.value:
        raise AssertionError("unexpected FFLAS nullspace layout")
    raw = np.ctypeslib.as_array(pointer, shape=(columns * nullity.value,))
    return raw.reshape(columns, nullity.value), int(nullity.value)


def build_problem() -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray, str]:
    """Return coefficient uint8, M2, M1 axis values, seeds, coefficient hash."""
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime mismatch")
    if seeds.shape != (690, 14134):
        raise AssertionError(f"unexpected relation storage {seeds.shape}")

    q1 = weak_compositions(1, NQ)
    q2 = weak_compositions(2, NQ)
    q2_index = {monomial: i for i, monomial in enumerate(q2)}
    variable_of = [monomial.index(1) for monomial in q1]
    m2 = np.empty((NROWS, NB2, NQ), dtype=np.uint8)
    for j in range(NB2):
        block = seeds[:, int(offsets[7 + j]) : int(offsets[8 + j])]
        for monomial_index, variable in enumerate(variable_of):
            m2[:, j, variable] = block[:, monomial_index]

    # Axis values M1_j(e_u), used later for all 10,767 coordinate evaluations.
    pure2: list[int] = []
    for variable in range(NQ):
        exponent = [0] * NQ
        exponent[variable] = 2
        pure2.append(q2_index[tuple(exponent)])
    m1_axis = np.empty((NQ, NROWS, 6), dtype=np.uint8)
    for j in range(6):
        block = seeds[:, int(offsets[1 + j]) : int(offsets[2 + j])]
        m1_axis[:, :, j] = block[:, pure2].T

    q2_index = {monomial: i for i, monomial in enumerate(q2)}
    coefficient = np.zeros((NB2 * len(q2), NROWS * NQ), dtype=np.uint8)
    row_for_pair = np.empty((NQ, NQ), dtype=np.int32)
    for u in range(NQ):
        for v in range(NQ):
            exponent = [0] * NQ
            exponent[u] += 1
            exponent[v] += 1
            row_for_pair[u, v] = q2_index[tuple(exponent)]
    base_columns = np.arange(NROWS, dtype=np.int32) * NQ
    for j in range(NB2):
        row_base = j * len(q2)
        for u in range(NQ):
            columns = base_columns + u
            for v in range(NQ):
                row = coefficient[row_base + int(row_for_pair[u, v])]
                row[columns] = (
                    row[columns].astype(np.int16) + m2[:, j, v]
                ) % P
    return coefficient, m2, m1_axis, seeds, sha256_array(coefficient)


def histogram(values: np.ndarray) -> dict[str, int]:
    keys, counts = np.unique(values, return_counts=True)
    return {str(int(key)): int(count) for key, count in zip(keys, counts)}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--min-free-gib",
        type=float,
        default=14.0,
        help="refuse the dense FFLAS allocation below this free+speculative margin",
    )
    parser.add_argument("--chunk", type=int, default=64)
    args = parser.parse_args()
    observed_free = free_gib_from_vm_stat()
    if observed_free is not None and observed_free < args.min_free_gib:
        raise SystemExit(
            f"resource guard: free+speculative={observed_free:.2f} GiB "
            f"< required {args.min_free_gib:.2f} GiB"
        )

    started = time.monotonic()
    coefficient, _m2, m1_axis, seeds, coefficient_sha = build_problem()
    coefficient_shape = list(coefficient.shape)
    print(
        f"coefficient={coefficient.shape} bytes={coefficient.nbytes} "
        f"sha256={coefficient_sha}",
        flush=True,
    )
    dense = coefficient.astype(np.float64)
    del coefficient
    fflas_started = time.monotonic()
    basis, nullity = fflas_right_nullspace(dense)
    fflas_elapsed = time.monotonic() - fflas_started
    expected = NROWS * NQ - NB2 * len(weak_compositions(2, NQ))
    if nullity != expected or nullity != NULLITY:
        raise AssertionError(f"nullity {nullity} != {expected}")
    print(
        f"rank={coefficient_shape[0]} nullity={nullity} "
        f"fflas_seconds={fflas_elapsed:.3f}",
        flush=True,
    )
    del dense

    # FFLAS returns a systematic basis.  Record an exact identity submatrix,
    # which independently certifies that all 10,767 stored columns are distinct.
    row_nnz = np.count_nonzero(basis, axis=1)
    candidate_rows = np.flatnonzero(row_nnz == 1)
    identity_rows = np.full(NULLITY, -1, dtype=np.int32)
    for row in candidate_rows:
        column = int(np.flatnonzero(basis[row])[0])
        value = int(round(float(basis[row, column]))) % P
        if value == 1 and identity_rows[column] < 0:
            identity_rows[column] = int(row)
    if np.any(identity_rows < 0):
        missing = np.flatnonzero(identity_rows < 0)[:20].tolist()
        raise AssertionError(f"systematic identity rows missing for columns {missing}")
    for start in range(0, NULLITY, args.chunk):
        end = min(NULLITY, start + args.chunk)
        strip = np.rint(basis[identity_rows[start:end], :]).astype(np.int64) % P
        expected_strip = np.zeros((end - start, NULLITY), dtype=np.int64)
        expected_strip[np.arange(end - start), np.arange(start, end)] = 1
        if not np.array_equal(strip, expected_strip):
            raise AssertionError(
                f"recorded systematic rows {start}:{end} do not form identity"
            )

    basis_path = HERE / "full_linear_syzygy_basis.npy"
    stored = np.lib.format.open_memmap(
        basis_path,
        mode="w+",
        dtype=np.uint8,
        shape=(NULLITY, NROWS, NQ),
    )
    nnz = np.empty(NULLITY, dtype=np.int32)
    nonzero_rows = np.empty(NULLITY, dtype=np.int16)
    q_support_masks = np.empty(NULLITY, dtype=np.uint64)
    q_support_cardinality = np.empty(NULLITY, dtype=np.uint8)
    axis_evaluations = np.empty((NULLITY, NQ, 6), dtype=np.uint8)
    data_digest = hashlib.sha256()
    bit_weights = (np.uint64(1) << np.arange(NQ, dtype=np.uint64))

    for start in range(0, NULLITY, args.chunk):
        end = min(NULLITY, start + args.chunk)
        chunk = np.rint(basis[:, start:end].T).astype(np.int64) % P
        chunk = chunk.reshape(end - start, NROWS, NQ).astype(np.uint8)
        stored[start:end] = chunk
        data_digest.update(np.ascontiguousarray(chunk).tobytes())
        nnz[start:end] = np.count_nonzero(chunk, axis=(1, 2))
        nonzero_rows[start:end] = np.count_nonzero(
            np.any(chunk != 0, axis=2), axis=1
        )
        support = np.any(chunk != 0, axis=1)
        q_support_masks[start:end] = np.sum(
            support.astype(np.uint64) * bit_weights[None, :], axis=1
        )
        q_support_cardinality[start:end] = np.count_nonzero(support, axis=1)
        for variable in range(NQ):
            axis_evaluations[start:end, variable] = (
                chunk[:, :, variable].astype(np.int64)
                @ m1_axis[variable].astype(np.int64)
            ) % P
        if end == NULLITY or end % 1024 == 0:
            print(f"stored/analyzed {end}/{NULLITY}", flush=True)
    stored.flush()
    del stored

    statistics_path = HERE / "global_basis_statistics.npz"
    np.savez_compressed(
        statistics_path,
        nnz=nnz,
        nonzero_relation_rows=nonzero_rows,
        q_support_masks=q_support_masks,
        q_support_cardinality=q_support_cardinality,
        coordinate_p3_evaluations=axis_evaluations,
        systematic_identity_rows=identity_rows,
        prime=np.int32(P),
        coefficient_shape=np.asarray(coefficient_shape, dtype=np.int32),
        coefficient_sha256=np.asarray(coefficient_sha),
        relation_matrix_sha256=np.asarray(sha256(RELATION)),
        seed_F3_sha256=np.asarray(sha256_array(seeds)),
        full_basis_data_sha256=np.asarray(data_digest.hexdigest()),
    )

    q_frequency = np.zeros(NQ, dtype=np.int32)
    for variable in range(NQ):
        q_frequency[variable] = np.count_nonzero(
            q_support_masks & (np.uint64(1) << np.uint64(variable))
        )
    quantiles = {
        str(q): float(np.quantile(nnz, q))
        for q in (0.0, 0.1, 0.25, 0.5, 0.75, 0.9, 1.0)
    }
    manifest = {
        "status": "PASS_FULL_FFLAS_BASIS",
        "prime": P,
        "construction": "complete degree-one left syzygy basis C(q)M2(q)=0",
        "coefficient_matrix_shape": coefficient_shape,
        "coefficient_matrix_rank": coefficient_shape[0],
        "coefficient_matrix_sha256": coefficient_sha,
        "nullity": NULLITY,
        "fflas_seconds": round(fflas_elapsed, 6),
        "observed_free_plus_speculative_gib_before_run": observed_free,
        "full_basis": {
            "path": basis_path.name,
            "shape": [NULLITY, NROWS, NQ],
            "dtype": "uint8",
            "file_bytes": basis_path.stat().st_size,
            "file_sha256": sha256(basis_path),
            "canonical_data_sha256": data_digest.hexdigest(),
            "systematic_identity_rows": True,
        },
        "global_sparsity": {
            "nnz_min": int(nnz.min()),
            "nnz_max": int(nnz.max()),
            "nnz_mean": float(nnz.mean()),
            "nnz_quantiles": quantiles,
            "q_support_cardinality_histogram": histogram(q_support_cardinality),
            "q_coordinate_basis_column_frequencies": q_frequency.astype(int).tolist(),
        },
        "statistics": {
            "path": statistics_path.name,
            "sha256": sha256(statistics_path),
        },
        "source": {
            "relation_matrix": str(RELATION.relative_to(ROOT)),
            "relation_matrix_sha256": sha256(RELATION),
            "seed_F3_sha256": sha256_array(seeds),
        },
        "no_singular_launched": True,
        "elapsed_seconds": round(time.monotonic() - started, 6),
    }
    manifest_path = HERE / "full_basis_manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n")
    print(json.dumps(manifest, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
