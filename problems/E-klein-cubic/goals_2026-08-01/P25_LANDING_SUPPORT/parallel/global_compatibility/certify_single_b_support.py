#!/usr/bin/env python3
"""Exact global exclusion for Stage-B vectors with b1-support one.

For component j, regard the complete cubic contraction block as a coefficient
matrix

    A_j : Sym^3(F_89^37) -> F_89^10767.

If A_j has full column rank 9,139, then A_j v_3(q) is nonzero for every
projective q.  Thus P3(q)b1 cannot vanish when b1 has exactly one nonzero
coordinate.  The calculation is stronger than evaluation on q-points: it
proves injectivity for every nonzero polarized cubic coefficient vector.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path
import subprocess
import time

import numpy as np


HERE = Path(__file__).resolve().parent
FULL_P3 = HERE.parent / "stageb_global_basis" / "full_p3_contractions.npy"
ARTIFACT = HERE / "single_b_support_minors.npz"
CERTIFICATE = HERE / "single_b_support_certificate.json"
P = 89
ROWS = 10767
MONOMIALS = 9139


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def array_sha256(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def free_gib() -> float | None:
    try:
        output = subprocess.check_output(["vm_stat"], text=True)
    except (FileNotFoundError, subprocess.CalledProcessError):
        return None
    page_size = 16384
    free = speculative = None
    for line in output.splitlines():
        if line.startswith("Mach Virtual Memory Statistics") and "page size of" in line:
            page_size = int(line.split("page size of", 1)[1].split("bytes", 1)[0])
        elif line.startswith("Pages free:"):
            free = int(line.split(":", 1)[1].strip().rstrip("."))
        elif line.startswith("Pages speculative:"):
            speculative = int(line.split(":", 1)[1].strip().rstrip("."))
    if free is None or speculative is None:
        return None
    return (free + speculative) * page_size / 2**30


def row_rank_profile(matrix: np.ndarray) -> tuple[int, np.ndarray]:
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
            float(P), rows, columns, matrix, columns,
            ctypes.byref(pointer), 2, False,
        )
    )
    profile = np.ctypeslib.as_array(pointer, shape=(rank,)).copy()
    return rank, profile.astype(np.int32)


def main() -> None:
    observed = free_gib()
    if observed is not None and observed < 5.0:
        raise SystemExit(f"resource guard: free+speculative={observed:.2f} GiB < 5")
    p3 = np.load(FULL_P3, mmap_mode="r")
    if p3.shape != (ROWS, 6, MONOMIALS) or p3.dtype != np.uint8:
        raise AssertionError("unexpected full P3 tensor")
    profiles = np.empty((6, MONOMIALS), dtype=np.int32)
    ranks: list[int] = []
    minor_hashes: list[str] = []
    seconds: list[float] = []
    for component in range(6):
        dense = np.ascontiguousarray(p3[:, component, :], dtype=np.float64)
        started = time.monotonic()
        rank, profile = row_rank_profile(dense)
        seconds.append(time.monotonic() - started)
        del dense
        if rank != MONOMIALS or profile.shape != (MONOMIALS,):
            raise AssertionError(f"component {component} rank {rank} != {MONOMIALS}")
        profiles[component] = profile
        minor = np.ascontiguousarray(p3[profile, component, :], dtype=np.uint8)
        minor_hashes.append(array_sha256(minor))
        ranks.append(rank)
        print(
            f"component {component}: rank={rank}, minor_sha={minor_hashes[-1]}",
            flush=True,
        )
    np.savez_compressed(
        ARTIFACT,
        row_profiles=profiles,
        ranks=np.asarray(ranks, dtype=np.int32),
        minor_uint8_sha256=np.asarray(minor_hashes),
        prime=np.int32(P),
        full_p3_sha256=np.asarray(sha256(FULL_P3)),
    )
    payload = {
        "status": "PASS_STAGEB_SINGLE_B_SUPPORT_EXCLUDED",
        "prime": P,
        "field_scope": "algebraic closure of F_89",
        "full_p3": {
            "path": str(FULL_P3),
            "sha256": sha256(FULL_P3),
            "shape": list(p3.shape),
        },
        "component_coefficient_ranks": ranks,
        "component_minor_uint8_sha256": minor_hashes,
        "fflas_seconds": seconds,
        "artifact": {"file": ARTIFACT.name, "sha256": sha256(ARTIFACT)},
        "theorem": (
            "For every projective q and every b1 with exactly one nonzero "
            "coordinate, P3(q)b1 is nonzero."
        ),
        "stronger_linearized_statement": (
            "Each of the six maps from the full 9,139-dimensional cubic "
            "coefficient space to the 10,767 contraction rows is injective."
        ),
        "limitation": (
            "This does not treat b1-support at least two, nor the augmented "
            "Stage-C equation involving P4."
        ),
        "observed_free_plus_speculative_gib": observed,
    }
    CERTIFICATE.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS: Stage-B b1-support one excluded globally")


if __name__ == "__main__":
    main()

