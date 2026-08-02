#!/usr/bin/env python3
"""Independent exact rank replay for the six single-b support minors."""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
FULL_P3 = HERE.parent / "stageb_global_basis" / "full_p3_contractions.npy"
ARTIFACT = HERE / "single_b_support_minors.npz"
CERTIFICATE = HERE / "single_b_support_certificate.json"
RESULT = HERE / "verify_single_b_support_result.json"
P = 89


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def array_sha256(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def rank(matrix: np.ndarray) -> int:
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
    with np.load(ARTIFACT, allow_pickle=False) as frozen:
        profiles = frozen["row_profiles"].astype(np.int32)
        ranks = frozen["ranks"].astype(np.int32)
        hashes = frozen["minor_uint8_sha256"].astype(str)
        if int(frozen["prime"]) != P:
            raise AssertionError("artifact prime mismatch")
        if str(frozen["full_p3_sha256"]) != sha256(FULL_P3):
            raise AssertionError("full-P3 hash mismatch")
    if profiles.shape != (6, 9139) or ranks.tolist() != [9139] * 6:
        raise AssertionError("rank-profile shape/value mismatch")
    replayed: list[int] = []
    for component in range(6):
        profile = profiles[component]
        if len(np.unique(profile)) != 9139 or np.any(profile < 0) or np.any(profile >= 10767):
            raise AssertionError("invalid row profile")
        minor = np.ascontiguousarray(p3[profile, component, :], dtype=np.uint8)
        if array_sha256(minor) != hashes[component]:
            raise AssertionError(f"component {component} minor hash mismatch")
        replayed.append(rank(minor))
        if replayed[-1] != 9139:
            raise AssertionError(f"component {component} selected minor singular")
        print(f"component {component}: selected minor rank 9139", flush=True)
    result = {
        "status": "PASS_INDEPENDENT_SINGLE_B_SUPPORT_REPLAY",
        "prime": P,
        "component_ranks": replayed,
        "full_p3_sha256": sha256(FULL_P3),
        "artifact_sha256": sha256(ARTIFACT),
        "certificate_sha256": sha256(CERTIFICATE),
        "scope": "Global Stage-B exclusion only for b1-support exactly one.",
    }
    RESULT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS: independently replayed Stage-B b1-support-one exclusion")


if __name__ == "__main__":
    main()

