#!/usr/bin/env python3
"""Test whether one exact axis-0 row profile pivots all six b-components.

This is a low-memory preflight for a polynomial-matrix pencil certificate.  It
does not claim constant rank away from the six coordinate points.
"""

from __future__ import annotations

import ctypes
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P3 = HERE.parent / "stageb_global_basis" / "full_p3_contractions.npy"
PROFILES = HERE / "single_b_support_minors.npz"
OUTPUT = HERE / "b_pencil_common_profile.json"
P = 89
N = 9139


def rank(matrix: np.ndarray) -> int:
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


def main() -> None:
    p3 = np.load(P3, mmap_mode="r")
    with np.load(PROFILES, allow_pickle=False) as frozen:
        profile = frozen["row_profiles"][0].astype(np.int32)
    if p3.shape != (10767, 6, N) or profile.shape != (N,):
        raise AssertionError("input shape mismatch")
    ranks: list[int] = []
    for component in range(6):
        matrix = np.ascontiguousarray(p3[profile, component, :], dtype=np.float64)
        value = rank(matrix)
        ranks.append(value)
        print(f"component={component} common_profile_rank={value}", flush=True)
        del matrix
    payload = {
        "status": "PASS_COMMON_PROFILE" if ranks == [N] * 6 else "COMMON_PROFILE_DEFICIENT",
        "prime": P,
        "profile_source_component": 0,
        "profile_size": N,
        "component_ranks": ranks,
        "scope": "Preflight only; full ranks at six b-axes do not prove constant rank on P5.",
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
