#!/usr/bin/env python3
"""Produce an exact degree-six module certificate on the closed stratum L.

Let L = P<span(q_4,...,q_11)> over F_89 and let A_L(q) be the restriction of
the sealed 256 x 6 matrix of cubic Stage-B contractions.  Its nonzero vector
rows generate a graded submodule N of S^6, where S=F_89[q_4,...,q_11].

This script constructs the exact Macaulay map

    N_3 tensor S_3  ->  S_6^6

as a 13680 x 10296 matrix and computes its row-rank profile with the installed
FFLAS-FFPACK finite-field backend.  Rank 10296 proves N_6=S_6^6.  In
particular q_i^6 e_j is in N for every 4 <= i <= 11 and every basis vector
e_j, so the localized module is all of S^6 on each D(q_i).  This is a global
projective emptiness certificate on L; it is not a global Stage-B certificate.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path
import resource
import time

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
SOURCE = P25 / "syzygy_r256_q0_contracted.npz"
CERTIFICATE = HERE / "closed_L_degree6_certificate.json"
P = 89
EXPECTED_SOURCE_SHA256 = (
    "2e718c491172480e3aa3f055d5806d28a9414db2627e6daf3f0204bdc3b840ea"
)
L_COORDINATES = tuple(range(4, 12))


def sha256_file(path: Path) -> str:
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


def local_to_global_indices(
    local_basis: list[tuple[int, ...]],
    global_index: dict[tuple[int, ...], int],
) -> np.ndarray:
    answer = []
    for local in local_basis:
        exponent = [0] * 37
        for coordinate, power in zip(L_COORDINATES, local):
            exponent[coordinate] = power
        answer.append(global_index[tuple(exponent)])
    return np.asarray(answer, dtype=np.int32)


def product_map(
    left: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: index for index, monomial in enumerate(target)}
    answer = np.empty((len(left), len(left)), dtype=np.int32)
    for i, multiplier in enumerate(left):
        for j, cubic in enumerate(left):
            answer[i, j] = target_index[
                tuple(a + b for a, b in zip(multiplier, cubic))
            ]
    return answer


def build_dense_macaulay(
    restricted: np.ndarray, multiplication: np.ndarray, target_monomials: int
) -> np.ndarray:
    generators, components, cubic_monomials = restricted.shape
    if multiplication.shape != (cubic_monomials, cubic_monomials):
        raise RuntimeError("unexpected multiplication-map shape")
    rows = generators * cubic_monomials
    columns = components * target_monomials
    dense = np.zeros((rows, columns), dtype=np.float64)
    local_rows = np.arange(cubic_monomials, dtype=np.intp)[:, None]
    for generator in range(generators):
        rows_here = generator * cubic_monomials + local_rows
        for component in range(components):
            columns_here = component * target_monomials + multiplication
            dense[rows_here, columns_here] = restricted[
                generator, component
            ][None, :]
        if (generator + 1) % 10 == 0 or generator + 1 == generators:
            print(
                f"build generators={generator + 1}/{generators}",
                flush=True,
            )
    return dense


def fflas_row_rank_profile(matrix: np.ndarray) -> tuple[int, np.ndarray]:
    if matrix.dtype != np.float64 or not matrix.flags.c_contiguous:
        raise TypeError("FFLAS input must be C-contiguous float64")
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.RowRankProfile_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.POINTER(ctypes.c_size_t)),
        ctypes.c_int,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    pointer = ctypes.POINTER(ctypes.c_size_t)()
    rows, columns = matrix.shape
    rank = int(
        function(
            float(P),
            rows,
            columns,
            matrix,
            columns,
            ctypes.byref(pointer),
            2,  # FfpackTileRecursive: PLUQ rank profile.
            False,
        )
    )
    profile = np.ctypeslib.as_array(pointer, shape=(rank,)).copy()
    return rank, profile.astype(np.int32)


def main() -> None:
    started = time.monotonic()
    source_hash = sha256_file(SOURCE)
    if source_hash != EXPECTED_SOURCE_SHA256:
        raise RuntimeError(f"sealed source hash changed: {source_hash}")

    global_cubics = weak_compositions(3, 37)
    local_cubics = weak_compositions(3, 8)
    local_sextics = weak_compositions(6, 8)
    if len(global_cubics) != 9139 or len(local_cubics) != 120:
        raise RuntimeError("monomial census changed")
    if len(local_sextics) != 1716:
        raise RuntimeError("sextic monomial census changed")
    global_index = {monomial: index for index, monomial in enumerate(global_cubics)}
    restriction_indices = local_to_global_indices(local_cubics, global_index)

    with np.load(SOURCE) as frozen:
        if int(frozen["prime"]) != P or frozen["p3"].shape != (256, 6, 9139):
            raise RuntimeError("unexpected sealed contraction metadata")
        all_restricted = frozen["p3"][:, :, restriction_indices].astype(np.uint8)
        chosen_syzygies = frozen["chosen_syzygies"].astype(np.int32)
    nonzero_mask = np.any(all_restricted != 0, axis=(1, 2))
    nonzero_rows = np.flatnonzero(nonzero_mask).astype(np.int32)
    restricted = np.ascontiguousarray(all_restricted[nonzero_mask])
    if nonzero_rows.tolist() != list(range(142, 256)):
        raise RuntimeError(f"closed-L nonzero row set changed: {nonzero_rows.tolist()}")
    if restricted.shape != (114, 6, 120):
        raise RuntimeError(f"unexpected restricted tensor shape {restricted.shape}")

    multiplication = product_map(local_cubics, local_sextics)
    dense = build_dense_macaulay(restricted, multiplication, len(local_sextics))
    expected_shape = (114 * 120, 6 * 1716)
    if dense.shape != expected_shape:
        raise RuntimeError(f"bad Macaulay shape {dense.shape} != {expected_shape}")
    expected_nnz = int(np.count_nonzero(restricted)) * len(local_cubics)
    actual_nnz = int(np.count_nonzero(dense))
    if actual_nnz != expected_nnz:
        raise RuntimeError(f"Macaulay nnz mismatch {actual_nnz} != {expected_nnz}")
    print(
        f"macaulay shape={dense.shape} nnz={actual_nnz}; starting exact PLUQ",
        flush=True,
    )

    rank_started = time.monotonic()
    rank, profile = fflas_row_rank_profile(dense)
    rank_seconds = time.monotonic() - rank_started
    if len(np.unique(profile)) != len(profile) or np.any(profile < 0):
        raise RuntimeError("invalid row-rank profile")
    if np.any(profile >= dense.shape[0]):
        raise RuntimeError("row-rank profile outside source range")
    full_target_rank = rank == dense.shape[1]
    if not full_target_rank:
        raise RuntimeError(
            f"closed-L degree-six map has rank {rank} < {dense.shape[1]}; "
            "this is only a contraction survivor"
        )

    profile_generator = profile // len(local_cubics)
    profile_multiplier = profile % len(local_cubics)
    payload = {
        "certificate_kind": "closed-L degree-six graded-module surjectivity",
        "prime": P,
        "closed_stratum": {
            "definition": "q_i=0 for i outside {4,...,11}",
            "projective_space": "P^7 over F_89",
            "retained_q_coordinates": list(L_COORDINATES),
        },
        "source": {
            "path_from_P25": SOURCE.relative_to(P25).as_posix(),
            "sha256": source_hash,
            "p3_shape": [256, 6, 9139],
        },
        "restriction": {
            "global_row_ordinals": nonzero_rows.astype(int).tolist(),
            "source_syzygy_indices": chosen_syzygies[nonzero_rows].astype(int).tolist(),
            "nonzero_vector_cubics": len(restricted),
            "restricted_tensor_shape": list(restricted.shape),
            "restricted_tensor_uint8_sha256": sha256_array(restricted),
            "restricted_tensor_nonzero_coefficients": int(np.count_nonzero(restricted)),
            "restriction_indices_int32_sha256": sha256_array(restriction_indices),
        },
        "monomial_bases": {
            "local_cubic_count": len(local_cubics),
            "local_sextic_count": len(local_sextics),
            "local_cubics_uint8_sha256": sha256_array(
                np.asarray(local_cubics, dtype=np.uint8)
            ),
            "local_sextics_uint8_sha256": sha256_array(
                np.asarray(local_sextics, dtype=np.uint8)
            ),
            "multiplication_map_int32_sha256": sha256_array(multiplication),
        },
        "degree_six_map": {
            "source_dimension": dense.shape[0],
            "target_dimension": dense.shape[1],
            "nonzero_entries": actual_nnz,
            "rank_over_F89": rank,
            "full_target_rank": full_target_rank,
            "row_rank_profile_source_ordinals": profile.astype(int).tolist(),
            "row_rank_profile_generator_ordinals": profile_generator.astype(int).tolist(),
            "row_rank_profile_multiplier_ordinals": profile_multiplier.astype(int).tolist(),
            "row_rank_profile_int32_sha256": sha256_array(profile),
            "backend": "FFLAS-FFPACK 2.5.0 RowRankProfile_modular_double, PLUQ",
            "rank_seconds": rank_seconds,
        },
        "theorem": {
            "module_statement": "N_6 = S_6^6 for S=F_89[q_4,...,q_11]",
            "irrelevant_power_statement": "q_i^6 e_j is in N for 4<=i<=11 and 0<=j<6",
            "conclusion": "the r256 Stage-B contraction rank-drop locus is empty on L",
            "implication": "the true special-fibre Stage-B locus is empty on L",
            "scope_guard": "No conclusion is made on P^36 minus L or on global Stage B.",
        },
        "timing": {
            "total_seconds": time.monotonic() - started,
            "max_rss_raw": resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
            "max_rss_note": "ru_maxrss units are platform-dependent; on macOS this is bytes",
        },
    }
    CERTIFICATE.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(
        f"PASS rank={rank}/{dense.shape[1]} wrote {CERTIFICATE.name}",
        flush=True,
    )


if __name__ == "__main__":
    main()
