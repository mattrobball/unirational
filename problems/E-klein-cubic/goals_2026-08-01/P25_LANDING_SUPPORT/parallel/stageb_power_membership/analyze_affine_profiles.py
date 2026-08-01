#!/usr/bin/env python3
"""Exact low-memory affine rank profiles of the full cubic module.

For every distinguished homogeneous coordinate q_i, dehomogenize by q_i=1
and order columns by total degree in the remaining 36 variables.  The columns
of affine degree at most two have dimension

    6 * (1 + 36 + binom(37,2)) = 4218.

Their exact rank is a first preflight for a filtered border-basis membership
test.  Only one 10767 x 4218 modular-double matrix (about 347 MiB) exists at a
time.  This script is diagnostic: no sampled statement is promoted to a
membership verdict.
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import time

import numpy as np


P = 89
NQ = 37
R = 10767
HERE = Path(__file__).resolve().parent
P3 = HERE.parent / "stageb_global_basis" / "full_p3_contractions.npy"
OUT = HERE / "affine_rank_profiles.json"


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    answer: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            answer.append((first,) + tail)
    return answer


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def rank_fflas(matrix: np.ndarray) -> int:
    if matrix.dtype != np.float64 or not matrix.flags.c_contiguous:
        raise TypeError("rank input must be contiguous float64")
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
    rows, columns = matrix.shape
    return int(function(float(P), rows, columns, matrix, columns, False))


def data_sha(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--axis", type=int, action="append")
    args = parser.parse_args()
    axes = args.axis if args.axis is not None else list(range(NQ))
    if any(i < 0 or i >= NQ for i in axes):
        raise SystemExit("axis outside 0,...,36")

    p3 = np.load(P3, mmap_mode="r")
    q3 = weak_compositions(3, NQ)
    if p3.shape != (R, 6, len(q3)) or p3.dtype != np.uint8:
        raise AssertionError(f"unexpected tensor {p3.shape} {p3.dtype}")
    profiles = []
    for axis in axes:
        degree = np.asarray([3 - m[axis] for m in q3], dtype=np.int8)
        ranks: dict[str, int] = {}
        hashes: dict[str, str] = {}
        timings: dict[str, float] = {}
        # Test cumulative degrees separately, freeing the modular doubles each
        # time.  Degree <=2 is the only moderately sized case.
        for bound in (0, 1, 2):
            monomials = np.flatnonzero(degree <= bound)
            columns = np.asarray(
                [component * len(q3) + int(m) for component in range(6) for m in monomials],
                dtype=np.int32,
            )
            small = np.ascontiguousarray(p3.reshape(R, -1)[:, columns], dtype=np.uint8)
            hashes[str(bound)] = data_sha(small)
            dense = small.astype(np.float64)
            started = time.monotonic()
            ranks[str(bound)] = rank_fflas(dense)
            timings[str(bound)] = round(time.monotonic() - started, 6)
            del dense, small
        profile = {
            "axis": axis,
            "columns_by_bound": {"0": 6, "1": 222, "2": 4218},
            "rank_by_bound": ranks,
            "uint8_sha256_by_bound": hashes,
            "fflas_seconds_by_bound": timings,
            "all_affine_degree_at_most_two_columns_independent": ranks["2"] == 4218,
        }
        profiles.append(profile)
        print(json.dumps(profile, sort_keys=True), flush=True)

    payload = {
        "status": "PASS_EXACT_AFFINE_RANK_PROFILES",
        "prime": P,
        "full_p3": {"path": str(P3), "sha256": sha256(P3)},
        "profiles": profiles,
        "scope": (
            "Exact rank preflight only. Full low-degree pivot coverage enables a "
            "filtered border computation but does not itself decide pure-power membership."
        ),
    }
    OUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
