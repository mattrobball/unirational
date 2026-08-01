#!/usr/bin/env python3
"""Independently replay the selected full-rank minor for closed L.

The producer computes a row-rank profile of the complete rectangular degree-6
Macaulay map.  This verifier separately rebuilds only the resulting square
10296 x 10296 minor and computes its determinant over F_89.  A nonzero exact
determinant independently verifies the producer's full-rank claim.
"""

from __future__ import annotations

import ctypes
import hashlib
from itertools import combinations_with_replacement
import json
from pathlib import Path
import resource
import time

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
SOURCE = P25 / "syzygy_r256_q0_contracted.npz"
CERTIFICATE = HERE / "closed_L_degree6_certificate.json"
RESULT = HERE / "verify_closed_L_degree6_result.json"
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


def monomials_by_multisets(total: int, variables: int) -> list[tuple[int, ...]]:
    """Independent monomial constructor, returned in lexicographic order."""
    result = []
    for multiset in combinations_with_replacement(range(variables), total):
        exponent = [0] * variables
        for variable in multiset:
            exponent[variable] += 1
        result.append(tuple(exponent))
    return sorted(result)


def local_global_indices(
    local_cubics: list[tuple[int, ...]],
    global_cubics: list[tuple[int, ...]],
) -> np.ndarray:
    lookup = {exponent: index for index, exponent in enumerate(global_cubics)}
    answer = []
    for local in local_cubics:
        global_exponent = [0] * 37
        for local_variable, global_variable in enumerate(L_COORDINATES):
            global_exponent[global_variable] = local[local_variable]
        answer.append(lookup[tuple(global_exponent)])
    return np.asarray(answer, dtype=np.int32)


def multiplication_table(
    local_cubics: list[tuple[int, ...]],
    local_sextics: list[tuple[int, ...]],
) -> np.ndarray:
    sextic_lookup = {exponent: index for index, exponent in enumerate(local_sextics)}
    table = np.empty((len(local_cubics), len(local_cubics)), dtype=np.int32)
    for multiplier_index, multiplier in enumerate(local_cubics):
        for cubic_index, cubic in enumerate(local_cubics):
            exponent = tuple(x + y for x, y in zip(multiplier, cubic))
            table[multiplier_index, cubic_index] = sextic_lookup[exponent]
    return table


def build_selected_minor(
    restricted: np.ndarray,
    table: np.ndarray,
    profile: np.ndarray,
    sextic_count: int,
) -> np.ndarray:
    cubic_count = restricted.shape[2]
    target_dimension = 6 * sextic_count
    if len(profile) != target_dimension:
        raise RuntimeError("rank profile does not select a square target minor")
    matrix = np.zeros((target_dimension, target_dimension), dtype=np.float64)
    for output_row, source_ordinal in enumerate(profile.astype(int)):
        generator, multiplier = divmod(source_ordinal, cubic_count)
        for component in range(6):
            columns = component * sextic_count + table[multiplier]
            matrix[output_row, columns] = restricted[generator, component]
        if (output_row + 1) % 1000 == 0 or output_row + 1 == len(profile):
            print(f"minor rows={output_row + 1}/{len(profile)}", flush=True)
    return matrix


def streamed_uint8_sha256(matrix: np.ndarray, block_rows: int = 128) -> str:
    digest = hashlib.sha256()
    for start in range(0, matrix.shape[0], block_rows):
        stop = min(matrix.shape[0], start + block_rows)
        digest.update(np.asarray(matrix[start:stop], dtype=np.uint8).tobytes())
    return digest.hexdigest()


def fflas_determinant(matrix: np.ndarray) -> int:
    if matrix.dtype != np.float64 or not matrix.flags.c_contiguous:
        raise TypeError("FFLAS determinant input must be C-contiguous float64")
    if matrix.shape[0] != matrix.shape[1]:
        raise ValueError("determinant input must be square")
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.Det_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_double
    raw = function(float(P), matrix.shape[0], matrix, matrix.shape[1], False)
    return int(round(raw)) % P


def main() -> None:
    started = time.monotonic()
    certificate = json.loads(CERTIFICATE.read_text())
    source_hash = sha256_file(SOURCE)
    if source_hash != EXPECTED_SOURCE_SHA256:
        raise RuntimeError(f"sealed source hash changed: {source_hash}")
    if certificate["source"]["sha256"] != source_hash:
        raise RuntimeError("certificate source hash mismatch")
    if certificate["prime"] != P:
        raise RuntimeError("certificate prime mismatch")

    # This construction is intentionally separate from the producer's
    # recursive weak-composition routine.
    global_cubics = monomials_by_multisets(3, 37)
    local_cubics = monomials_by_multisets(3, 8)
    local_sextics = monomials_by_multisets(6, 8)
    if (len(global_cubics), len(local_cubics), len(local_sextics)) != (
        9139,
        120,
        1716,
    ):
        raise RuntimeError("independent monomial census failed")
    restriction_indices = local_global_indices(local_cubics, global_cubics)
    table = multiplication_table(local_cubics, local_sextics)

    with np.load(SOURCE) as frozen:
        all_restricted = frozen["p3"][:, :, restriction_indices].astype(np.uint8)
        chosen_syzygies = frozen["chosen_syzygies"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise RuntimeError("source prime mismatch")
    row_ordinals = np.flatnonzero(np.any(all_restricted != 0, axis=(1, 2))).astype(
        np.int32
    )
    restricted = np.ascontiguousarray(all_restricted[row_ordinals])
    restriction_certificate = certificate["restriction"]
    if row_ordinals.astype(int).tolist() != restriction_certificate["global_row_ordinals"]:
        raise RuntimeError("independent nonzero-row census disagrees with certificate")
    if (
        chosen_syzygies[row_ordinals].astype(int).tolist()
        != restriction_certificate["source_syzygy_indices"]
    ):
        raise RuntimeError("source-syzygy index list mismatch")
    if sha256_array(restricted) != restriction_certificate["restricted_tensor_uint8_sha256"]:
        raise RuntimeError("restricted tensor hash mismatch")
    if sha256_array(restriction_indices) != restriction_certificate[
        "restriction_indices_int32_sha256"
    ]:
        raise RuntimeError("restriction-index hash mismatch")
    monomial_certificate = certificate["monomial_bases"]
    checks = {
        "local_cubics_uint8_sha256": sha256_array(
            np.asarray(local_cubics, dtype=np.uint8)
        ),
        "local_sextics_uint8_sha256": sha256_array(
            np.asarray(local_sextics, dtype=np.uint8)
        ),
        "multiplication_map_int32_sha256": sha256_array(table),
    }
    for key, value in checks.items():
        if value != monomial_certificate[key]:
            raise RuntimeError(f"independent {key} mismatch")

    degree_map = certificate["degree_six_map"]
    profile = np.asarray(degree_map["row_rank_profile_source_ordinals"], dtype=np.int32)
    if sha256_array(profile) != degree_map["row_rank_profile_int32_sha256"]:
        raise RuntimeError("rank-profile hash mismatch")
    if len(profile) != 10296 or len(np.unique(profile)) != len(profile):
        raise RuntimeError("rank profile is not a 10296-row selection")
    if np.any(profile < 0) or np.any(profile >= 114 * 120):
        raise RuntimeError("rank-profile ordinal out of range")

    minor = build_selected_minor(restricted, table, profile, len(local_sextics))
    matrix_hash = streamed_uint8_sha256(minor)
    expected_nnz = 0
    for source_ordinal in profile.astype(int):
        generator, _ = divmod(source_ordinal, len(local_cubics))
        expected_nnz += int(np.count_nonzero(restricted[generator]))
    actual_nnz = int(np.count_nonzero(minor))
    if actual_nnz != expected_nnz:
        raise RuntimeError(f"selected-minor nnz mismatch {actual_nnz} != {expected_nnz}")
    print(
        f"minor shape={minor.shape} nnz={actual_nnz}; starting exact determinant",
        flush=True,
    )
    determinant_started = time.monotonic()
    determinant = fflas_determinant(minor)
    determinant_seconds = time.monotonic() - determinant_started
    if determinant == 0:
        raise RuntimeError("selected row-profile minor has zero determinant")

    result = {
        "status": "PASS",
        "prime": P,
        "source_sha256": source_hash,
        "certificate_sha256": sha256_file(CERTIFICATE),
        "independent_construction": "multiset monomial bases and selected-minor rebuild",
        "selected_minor_shape": [10296, 10296],
        "selected_minor_nonzero_entries": actual_nnz,
        "selected_minor_uint8_rowmajor_sha256": matrix_hash,
        "determinant_mod_89": determinant,
        "determinant_nonzero": True,
        "backend": "FFLAS-FFPACK 2.5.0 Det_modular_double",
        "determinant_seconds": determinant_seconds,
        "total_seconds": time.monotonic() - started,
        "max_rss_raw": resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
        "max_rss_note": "ru_maxrss units are platform-dependent; on macOS this is bytes",
        "verified_conclusion": (
            "the selected 10296-row minor is invertible over F_89, hence the "
            "closed-L degree-six map is surjective and the r256 Stage-B "
            "rank-drop locus is empty on L"
        ),
        "scope_guard": "No claim is made for the complement of L or global Stage B.",
    }
    RESULT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(
        f"PASS determinant={determinant} mod {P}; wrote {RESULT.name}",
        flush=True,
    )


if __name__ == "__main__":
    main()
