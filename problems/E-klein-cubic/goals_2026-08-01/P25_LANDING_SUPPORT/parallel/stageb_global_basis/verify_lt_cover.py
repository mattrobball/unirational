#!/usr/bin/env python3
"""Independent replay of the pure-cube projection obstruction."""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path

import numpy as np

from produce_full_basis import NQ, NULLITY, P, sha256, weak_compositions


HERE = Path(__file__).resolve().parent
FULL_P3 = HERE / "full_p3_contractions.npy"
PROFILE = HERE / "lt_cover_nonpure_minor.npz"


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def rank_fflas(matrix: np.ndarray) -> int:
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


def main() -> None:
    p3 = np.load(FULL_P3, mmap_mode="r")
    with np.load(PROFILE, allow_pickle=False) as frozen:
        columns = frozen["minor_columns"].astype(np.int32)
        stored_pure = frozen["pure_columns"].astype(np.int32)
        stored_sha = str(frozen["minor_uint8_sha256"])
        stored_rank = int(frozen["minor_rank"])
        if int(frozen["prime"]) != P:
            raise AssertionError("profile prime mismatch")
        if str(frozen["full_p3_sha256"]) != sha256(FULL_P3):
            raise AssertionError("full P3 hash mismatch")
    q3 = weak_compositions(3, NQ)
    q3_index = {monomial: index for index, monomial in enumerate(q3)}
    pure_monomials: list[int] = []
    for variable in range(NQ):
        exponent = [0] * NQ
        exponent[variable] = 3
        pure_monomials.append(q3_index[tuple(exponent)])
    pure = np.asarray(
        [
            component * len(q3) + monomial
            for component in range(6)
            for monomial in pure_monomials
        ],
        dtype=np.int32,
    )
    if not np.array_equal(pure, stored_pure):
        raise AssertionError("pure-cube coordinate enumeration mismatch")
    if len(columns) != NULLITY or np.intersect1d(columns, pure).size:
        raise AssertionError("minor columns are not a non-pure square")
    flattened = p3.reshape(NULLITY, 6 * len(q3))
    minor = np.ascontiguousarray(flattened[:, columns], dtype=np.uint8)
    if sha256_array(minor) != stored_sha:
        raise AssertionError("minor coefficient hash mismatch")
    rank = rank_fflas(minor)
    if rank != stored_rank or rank != NULLITY:
        raise AssertionError(f"non-pure minor rank {rank} is not {NULLITY}")
    result = {
        "status": "PASS_REPLAY_LT_COVER_OBSTRUCTION",
        "prime": P,
        "minor_rank": rank,
        "minor_uint8_sha256": stored_sha,
        "pure_cube_columns_deleted": int(len(pure)),
        "full_p3_sha256": sha256(FULL_P3),
        "profile_sha256": sha256(PROFILE),
        "conclusion": (
            "N3 contains no nonzero pure-cube-supported vector, so no admissible "
            "degree-three leading-term cover can cover every degree-five term."
        ),
        "limitation": "The full degree-five Macaulay map and Stage B remain open.",
    }
    result_path = HERE / "verify_lt_cover_result.json"
    result_path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS: replayed order-independent degree-three LT-cover obstruction")


if __name__ == "__main__":
    main()
