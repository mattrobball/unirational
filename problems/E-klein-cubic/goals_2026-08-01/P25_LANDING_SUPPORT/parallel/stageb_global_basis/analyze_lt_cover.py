#!/usr/bin/env python3
"""Low-memory exact obstruction test for a degree-three LT cover.

Let N_3 be the row span of the complete 10,767 by (6*9139) P3 matrix.  Delete
the 222 module coordinates q_i^3 e_j.  If the remaining projection has rank
10,767, then N_3 contains no nonzero vector supported on pure-cube module
coordinates.

This rules out a degree-three leading-term cover for *every* admissible module
term order.  Indeed, such an order has an absolute least degree-three module
term q_min^3 e_min.  Covering q_min^5 e_min in degree five requires that exact
degree-three leading term.  Since it is already the absolute least term, the
corresponding row-space vector would have to be the pure vector itself.

The test only materializes a deterministic 10,767-square non-pure minor
(about 0.93 GiB as modular doubles), not the 4.7-GiB full coefficient matrix.
Failure of this shortcut is not a Stage-B nonemptiness statement.
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import time

import numpy as np

from produce_full_basis import (
    NQ,
    NULLITY,
    P,
    free_gib_from_vm_stat,
    sha256,
    weak_compositions,
)


HERE = Path(__file__).resolve().parent
FULL_P3 = HERE / "full_p3_contractions.npy"
PROFILE = HERE / "lt_cover_nonpure_minor.npz"


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def rank_fflas_inplace(dense: np.ndarray) -> int:
    if dense.dtype != np.float64 or not dense.flags.c_contiguous:
        raise TypeError("FFLAS rank input must be contiguous float64")
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
    parser = argparse.ArgumentParser()
    parser.add_argument("--min-free-gib", type=float, default=5.0)
    args = parser.parse_args()
    observed_free = free_gib_from_vm_stat()
    if observed_free is not None and observed_free < args.min_free_gib:
        raise SystemExit(
            f"resource guard: free+speculative={observed_free:.2f} GiB "
            f"< required {args.min_free_gib:.2f} GiB"
        )
    if not FULL_P3.is_file():
        raise FileNotFoundError(FULL_P3)
    p3 = np.load(FULL_P3, mmap_mode="r")
    q3 = weak_compositions(3, NQ)
    if p3.shape != (NULLITY, 6, len(q3)):
        raise AssertionError(f"unexpected P3 shape {p3.shape}")
    q3_index = {monomial: index for index, monomial in enumerate(q3)}
    pure_monomials: list[int] = []
    for variable in range(NQ):
        exponent = [0] * NQ
        exponent[variable] = 3
        pure_monomials.append(q3_index[tuple(exponent)])
    pure_columns = np.asarray(
        [component * len(q3) + monomial for component in range(6) for monomial in pure_monomials],
        dtype=np.int32,
    )
    is_pure = np.zeros(6 * len(q3), dtype=bool)
    is_pure[pure_columns] = True
    nonpure_columns = np.flatnonzero(~is_pure).astype(np.int32)
    if len(nonpure_columns) != 6 * len(q3) - 6 * NQ:
        raise AssertionError("wrong pure/non-pure split")
    flattened = p3.reshape(NULLITY, 6 * len(q3))
    # Try deterministic square minors one at a time.  The first is balanced
    # across module components; the later fallbacks make a deficient first
    # square harmless without ever materializing the full 10,767 x 54,612
    # non-pure projection.
    pure_set = set(pure_columns.astype(int).tolist())
    term_major = np.asarray(
        [
            component * len(q3) + monomial
            for monomial in range(len(q3))
            for component in range(6)
            if component * len(q3) + monomial not in pure_set
        ],
        dtype=np.int32,
    )
    rng = np.random.default_rng(2026080137)
    candidate_minors = [
        ("term-major balanced prefix", term_major[:NULLITY]),
        ("component-major prefix", nonpure_columns[:NULLITY]),
        (
            "seed-2026080137 non-pure sample",
            np.sort(rng.choice(nonpure_columns, size=NULLITY, replace=False)).astype(
                np.int32
            ),
        ),
    ]
    attempts: list[dict] = []
    minor_columns = candidate_minors[0][1]
    minor_sha = ""
    rank = -1
    elapsed = 0.0
    for rule, columns in candidate_minors:
        minor_uint8 = np.ascontiguousarray(flattened[:, columns], dtype=np.uint8)
        this_sha = sha256_array(minor_uint8)
        started = time.monotonic()
        dense = minor_uint8.astype(np.float64)
        this_rank = rank_fflas_inplace(dense)
        this_elapsed = time.monotonic() - started
        del dense, minor_uint8
        attempts.append(
            {
                "column_rule": rule,
                "rank": this_rank,
                "uint8_sha256": this_sha,
                "fflas_seconds": round(this_elapsed, 6),
            }
        )
        minor_columns = columns
        minor_sha = this_sha
        rank = this_rank
        elapsed = this_elapsed
        if rank == NULLITY:
            break

    projection_injective = rank == NULLITY
    np.savez_compressed(
        PROFILE,
        minor_columns=minor_columns,
        pure_columns=pure_columns,
        minor_uint8_sha256=np.asarray(minor_sha),
        minor_rank=np.int32(rank),
        prime=np.int32(P),
        full_p3_sha256=np.asarray(sha256(FULL_P3)),
    )
    payload = {
        "status": (
            "PASS_LT_COVER_OBSTRUCTED"
            if projection_injective
            else "NONVERDICT_NONPURE_MINOR_NOT_FULL_RANK"
        ),
        "prime": P,
        "full_p3": {
            "file": FULL_P3.name,
            "sha256": sha256(FULL_P3),
            "shape": [NULLITY, 6, len(q3)],
        },
        "pure_cube_module_columns": int(len(pure_columns)),
        "nonpure_module_columns": int(len(nonpure_columns)),
        "tested_minor": {
            "rows": NULLITY,
            "columns": NULLITY,
            "column_rule": attempts[-1]["column_rule"],
            "rank": rank,
            "uint8_sha256": minor_sha,
            "fflas_seconds": round(elapsed, 6),
        },
        "minor_attempts": attempts,
        "nonpure_projection_injective": projection_injective,
        "no_nonzero_pure_cube_supported_vector_in_N3": projection_injective,
        "degree3_leading_term_cover_possible": (
            False if projection_injective else None
        ),
        "argument": (
            "Every admissible module order has an absolute least degree-three "
            "term q_min^3 e_min. Covering q_min^5 e_min requires that term in "
            "in(N3), which would require the pure vector itself. Injectivity of "
            "projection to the non-pure coordinates excludes every such vector."
            if projection_injective
            else "This one minor does not decide the non-pure projection rank."
        ),
        "profile_artifact": {
            "file": PROFILE.name,
            "sha256": sha256(PROFILE),
        },
        "observed_free_plus_speculative_gib_before_run": observed_free,
        "scope": (
            "This only decides availability of the proposed degree-three LT-cover "
            "certificate. It neither decides the full degree-five Macaulay map nor "
            "proves a Stage-B point."
        ),
    }
    result = HERE / "lt_cover_analysis.json"
    result.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()
