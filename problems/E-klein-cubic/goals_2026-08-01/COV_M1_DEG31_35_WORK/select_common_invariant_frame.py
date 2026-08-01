#!/usr/bin/env python3
"""Select one degree-105 invariant evaluation frame good at 419 and 463."""

from __future__ import annotations

import ctypes
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as base  # noqa: E402
import produce_landing_circuits as landing  # noqa: E402


FFPACK = landing.FFPACK
DEGREE = 105
DIMENSION = 8555
CANDIDATES = 9000


def row_profile_inplace(matrix: np.ndarray, prime: int):
    assert matrix.dtype == np.int32 and matrix.flags.c_contiguous
    row_lapack = np.empty(matrix.shape[0], dtype=np.uintp)
    col_lapack = np.empty(matrix.shape[1], dtype=np.uintp)
    library = ctypes.CDLL(FFPACK)
    function = library.RowEchelonForm_modular_int32_t
    function.argtypes = [
        ctypes.c_int32, ctypes.c_size_t, ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_int32), ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_size_t), ctypes.POINTER(ctypes.c_size_t),
        ctypes.c_bool, ctypes.c_int, ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rank = int(function(
        prime, matrix.shape[0], matrix.shape[1],
        matrix.ctypes.data_as(ctypes.POINTER(ctypes.c_int32)), matrix.shape[1],
        row_lapack.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        col_lapack.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        False, 2, True,
    ))
    row_order = np.empty_like(row_lapack)
    convert = library.LAPACKPerm2MathPerm
    convert.argtypes = [
        ctypes.POINTER(ctypes.c_size_t), ctypes.POINTER(ctypes.c_size_t),
        ctypes.c_size_t,
    ]
    convert(
        row_order.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        row_lapack.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        len(row_order),
    )
    return rank, row_order.astype(np.int64)


def main() -> None:
    labels = landing.invariant_labels(DEGREE)
    assert len(labels) == DIMENSION
    candidates = base.fixed_points(CANDIDATES)
    matrix = landing.invariant_evaluation_matrix(labels, candidates % 463, 463)
    rank, order = row_profile_inplace(matrix, 463)
    del matrix
    print(f"p463 candidate rank={rank}/{DIMENSION}", flush=True)
    assert rank == DIMENSION
    selected = order[:DIMENSION]
    points = candidates[selected]
    matrix = landing.invariant_evaluation_matrix(labels, points % 419, 419)
    rank419 = landing.rank_inplace_int32(matrix, 419)
    del matrix
    print(f"p419 fixed selected rank={rank419}/{DIMENSION}", flush=True)
    assert rank419 == DIMENSION
    output = HERE / "degree_35/invariant_frame_points.json"
    output.write_text(json.dumps({
        "schema": "cov-degree105-common-invariant-frame-v1",
        "degree": DEGREE,
        "dimension": DIMENSION,
        "candidate_count": CANDIDATES,
        "selected_candidate_indices": selected.tolist(),
        "points": points.tolist(),
        "ranks": {"419": rank419, "463": rank},
    }, indent=2, sort_keys=True) + "\n")
    print("COV_DEGREE105_COMMON_INVARIANT_FRAME_SELECTED")


if __name__ == "__main__":
    main()
