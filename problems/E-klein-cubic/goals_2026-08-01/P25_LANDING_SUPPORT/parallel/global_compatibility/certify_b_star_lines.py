#!/usr/bin/env python3
"""Exact algebraic-closure certificate on the five b-lines through e_0.

Write A_j for the 10,767 by 9,139 coefficient matrix of the j-th full P3
component.  A common 9,139-row profile makes every pivot block invertible.
For the pencil A_0*s+A_j*t, constant row and column operations normalize the
transpose to

    [ I*s + T^T*t | U^T*t ].

The degree-six homogeneous Macaulay map is onto exactly when the constant
block-Krylov matrix

    [ U^T, T^T U^T, ..., (T^T)^5 U^T ]

has rank 9,139.  In row orientation we rank the vertical stack
[U; U*T; ...; U*T^5].  Surjectivity makes the graded cokernel zero from
degree six onward, hence proves full column rank at every geometric point of
the projective pencil.  No sampling in t is used.
"""

from __future__ import annotations

import ctypes
import gc
import hashlib
import json
from pathlib import Path
import subprocess
import time

import numpy as np


HERE = Path(__file__).resolve().parent
P3_PATH = HERE.parent / "stageb_global_basis" / "full_p3_contractions.npy"
MINORS = HERE / "single_b_support_minors.npz"
ARTIFACT = HERE / "b_star_line_krylov_profiles.npz"
CERTIFICATE = HERE / "b_star_line_certificate.json"
P = 89
M = 10767
N = 9139
R = M - N
BLOCKS = 6
CHUNK = 128


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def array_sha256(array: np.ndarray) -> str:
    digest = hashlib.sha256()
    view = np.ascontiguousarray(array).view(np.uint8).reshape(-1)
    for start in range(0, view.size, 1 << 20):
        digest.update(view[start : start + (1 << 20)])
    return digest.hexdigest()


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


def library() -> ctypes.CDLL:
    return ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")


def invert(matrix: np.ndarray) -> np.ndarray:
    if matrix.shape[0] != matrix.shape[1] or matrix.dtype != np.float64:
        raise AssertionError("invert needs a square float64 matrix")
    output = np.ascontiguousarray(matrix).copy()
    nullity = ctypes.c_int(-1)
    function = library().Invertin_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_int),
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_void_p
    returned = function(
        float(P), output.shape[0], output, output.shape[1],
        ctypes.byref(nullity), False,
    )
    if not returned or nullity.value != 0:
        raise AssertionError(f"FFLAS inversion failed with nullity {nullity.value}")
    return (np.rint(output).astype(np.int64) % P).astype(np.float64)


def rank_profile(matrix: np.ndarray) -> tuple[int, np.ndarray]:
    matrix = np.ascontiguousarray(matrix, dtype=np.float64)
    function = library().RowRankProfile_modular_double
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
    value = int(function(
        float(P), rows, columns, matrix, columns,
        ctypes.byref(pointer), 2, False,
    ))
    profile = np.ctypeslib.as_array(pointer, shape=(value,)).copy().astype(np.int32)
    return value, profile


def multiply_mod(left: np.ndarray, right_float: np.ndarray) -> np.ndarray:
    if left.shape[1] != right_float.shape[0] or right_float.dtype != np.float64:
        raise AssertionError("multiply shape/dtype mismatch")
    output = np.empty((left.shape[0], right_float.shape[1]), dtype=np.uint8)
    for start in range(0, left.shape[0], CHUNK):
        stop = min(start + CHUNK, left.shape[0])
        product = np.ascontiguousarray(left[start:stop], dtype=np.float64) @ right_float
        output[start:stop] = (np.rint(product).astype(np.int64) % P).astype(np.uint8)
    return output


def assert_inverse(pivot_uint8: np.ndarray, inverse_float: np.ndarray) -> None:
    identity_columns = np.arange(N)
    for start in range(0, N, CHUNK):
        stop = min(start + CHUNK, N)
        product = (
            np.ascontiguousarray(pivot_uint8[start:stop], dtype=np.float64)
            @ inverse_float
        )
        residues = (np.rint(product).astype(np.int64) % P).astype(np.uint8)
        expected = np.zeros((stop - start, N), dtype=np.uint8)
        expected[np.arange(stop - start), identity_columns[start:stop]] = 1.0
        if not np.array_equal(residues, expected):
            bad = int(np.count_nonzero(residues != expected))
            raise AssertionError(
                f"inverse verification failed in rows {start}:{stop}; bad={bad}"
            )


def main() -> None:
    observed = free_gib()
    if observed is not None and observed < 6.0:
        raise SystemExit(f"resource guard: free+speculative={observed:.2f} GiB < 6")
    # Exercise the C ABI before allocating the full pivot matrix.
    test = np.asarray([[1.0, 2.0], [3.0, 5.0]])
    test_inverse = invert(test)
    if not np.array_equal((test @ test_inverse) % P, np.eye(2)):
        raise AssertionError("small inversion ABI test failed")

    p3 = np.load(P3_PATH, mmap_mode="r")
    with np.load(MINORS, allow_pickle=False) as frozen:
        profile = frozen["row_profiles"][0].astype(np.int32)
    if p3.shape != (M, 6, N) or profile.shape != (N,):
        raise AssertionError("input shape mismatch")
    mask = np.ones(M, dtype=bool)
    mask[profile] = False
    free_rows = np.flatnonzero(mask).astype(np.int32)
    if free_rows.shape != (R,):
        raise AssertionError("free row count mismatch")

    pivot0_uint8 = np.ascontiguousarray(p3[profile, 0, :], dtype=np.uint8)
    started = time.monotonic()
    pivot0_inverse = invert(pivot0_uint8.astype(np.float64))
    inversion_seconds = time.monotonic() - started
    assert_inverse(pivot0_uint8, pivot0_inverse)
    inverse_hash = array_sha256(pivot0_inverse.astype(np.uint8))
    del pivot0_uint8
    gc.collect()
    q_normalized = multiply_mod(p3[free_rows, 0, :], pivot0_inverse)

    profiles = np.empty((5, N), dtype=np.int32)
    ranks: list[int] = []
    minor_hashes: list[str] = []
    line_seconds: list[float] = []
    for slot, component in enumerate(range(1, 6)):
        line_started = time.monotonic()
        top = multiply_mod(p3[profile, component, :], pivot0_inverse)
        top_float = top.astype(np.float64)
        bottom = multiply_mod(p3[free_rows, component, :], pivot0_inverse)
        correction = multiply_mod(q_normalized, top_float)
        u = ((bottom.astype(np.int16) - correction.astype(np.int16)) % P).astype(np.uint8)
        del bottom, correction

        krylov = np.empty((BLOCKS * R, N), dtype=np.uint8)
        current = u
        krylov[:R] = current
        for power in range(1, BLOCKS):
            current = multiply_mod(current, top_float)
            krylov[power * R : (power + 1) * R] = current
        del current, u, top, top_float
        dense = krylov.astype(np.float64)
        value, selected = rank_profile(dense)
        del dense
        if value != N or selected.shape != (N,):
            raise AssertionError(f"line (0,{component}) Krylov rank {value} != {N}")
        profiles[slot] = selected
        minor_hash = array_sha256(krylov[selected, :])
        ranks.append(value)
        minor_hashes.append(minor_hash)
        line_seconds.append(time.monotonic() - line_started)
        del krylov
        gc.collect()
        print(
            f"line=(0,{component}) krylov_rank={value} minor_sha={minor_hash} "
            f"seconds={line_seconds[-1]:.3f}",
            flush=True,
        )

    np.savez_compressed(
        ARTIFACT,
        row_profiles=profiles,
        ranks=np.asarray(ranks, dtype=np.int32),
        minor_uint8_sha256=np.asarray(minor_hashes),
        lines=np.asarray([[0, j] for j in range(1, 6)], dtype=np.int32),
        prime=np.int32(P),
        pivot_profile=profile,
        pivot_inverse_uint8_sha256=np.asarray(inverse_hash),
        full_p3_sha256=np.asarray(sha256(P3_PATH)),
    )
    payload = {
        "status": "PASS_STAGEB_B_STAR_LINES_CONSTANT_FULL_RANK",
        "prime": P,
        "field_scope": "algebraic closure of F_89",
        "lines": [[0, j] for j in range(1, 6)],
        "macaulay_target_degree": 6,
        "krylov_blocks": BLOCKS,
        "krylov_shape": [BLOCKS * R, N],
        "krylov_ranks": ranks,
        "minor_uint8_sha256": minor_hashes,
        "pivot_inverse_uint8_sha256": inverse_hash,
        "inversion_seconds": inversion_seconds,
        "line_seconds": line_seconds,
        "artifact": {"file": ARTIFACT.name, "sha256": sha256(ARTIFACT)},
        "full_p3_sha256": sha256(P3_PATH),
        "theorem": (
            "For every geometric b on one of the five coordinate lines "
            "P<e_0,e_j>, A(b) has column rank 9,139."
        ),
        "criterion": (
            "Exact full rank of [U;UT;...;UT^5] is equivalent to surjectivity "
            "of the homogeneous degree-six pencil Macaulay map; no F_89-point "
            "sampling is used."
        ),
        "limitation": (
            "Five lines do not cover P^5. This is not a global Stage-B or P25 "
            "emptiness certificate."
        ),
    }
    CERTIFICATE.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
