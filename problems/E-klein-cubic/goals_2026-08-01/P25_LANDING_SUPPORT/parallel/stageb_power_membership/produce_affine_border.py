#!/usr/bin/env python3
"""Produce exact low-jet affine border rules for one q-coordinate chart.

After q_axis=1, the full cubic contraction matrix has 4,218 columns of
outside degree at most two.  If that block has full column rank, select an
invertible 4,218-row minor and normalize it.  Every normalized row then has
the form

    (one affine module monomial of degree <= 2) + (pure degree-3 tail).

The output is an exact binary border packet.  It is useful for a triangular
degree-five membership reduction and is independently replayable from the
full P3 tensor.  It is not by itself a membership or emptiness certificate.
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
P3_PATH = HERE.parent / "stageb_global_basis" / "full_p3_contractions.npy"


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


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def row_rank_profile(dense: np.ndarray) -> tuple[int, np.ndarray]:
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
    rows, columns = dense.shape
    rank = int(
        function(
            float(P), rows, columns, dense, columns,
            ctypes.byref(pointer), 2, False,
        )
    )
    profile = np.ctypeslib.as_array(pointer, shape=(rank,)).copy()
    return rank, profile.astype(np.int32)


def right_solve_inplace(a: np.ndarray, b: np.ndarray) -> int:
    """Replace B by X solving X*A = B over F_89; return rank(A)."""
    if a.dtype != np.float64 or b.dtype != np.float64:
        raise TypeError("FFLAS solve requires float64")
    if not a.flags.c_contiguous or not b.flags.c_contiguous:
        raise TypeError("FFLAS solve requires contiguous arrays")
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    symbol = "_Z22fgesvin_modular_doubledN5FFLAS10FFLAS_SIDEEmmPdmS1_mPib"
    function = getattr(library, symbol)
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_int,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_int),
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    info = ctypes.c_int()
    # Side=Right: A is N x N and B is M x N.
    rank = int(
        function(
            float(P), 142, b.shape[0], a.shape[0], a, a.shape[1],
            b, b.shape[1], ctypes.byref(info), False,
        )
    )
    if info.value != 0:
        raise RuntimeError(f"FFLAS right solve info={info.value}")
    return rank


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--axis", type=int, default=0)
    parser.add_argument("--chunk", type=int, default=512)
    parser.add_argument("--resume", action="store_true")
    args = parser.parse_args()
    axis = args.axis
    if axis < 0 or axis >= NQ:
        raise SystemExit("axis outside 0,...,36")

    started = time.monotonic()
    p3 = np.load(P3_PATH, mmap_mode="r")
    q3 = weak_compositions(3, NQ)
    if p3.shape != (R, 6, len(q3)) or p3.dtype != np.uint8:
        raise AssertionError(f"unexpected P3 tensor {p3.shape} {p3.dtype}")
    degree = np.asarray([3 - monomial[axis] for monomial in q3], dtype=np.int8)
    low_monomials = np.flatnonzero(degree <= 2).astype(np.int32)
    high_monomials = np.flatnonzero(degree == 3).astype(np.int32)
    if len(low_monomials) != 703 or len(high_monomials) != 8436:
        raise AssertionError("affine monomial census changed")
    low_columns = np.asarray(
        [component * len(q3) + int(m) for component in range(6) for m in low_monomials],
        dtype=np.int32,
    )
    high_columns = np.asarray(
        [component * len(q3) + int(m) for component in range(6) for m in high_monomials],
        dtype=np.int32,
    )
    flat = p3.reshape(R, -1)
    low = np.ascontiguousarray(flat[:, low_columns], dtype=np.uint8)
    low_sha = sha256_array(low)
    inverse_path = HERE / f"axis{axis}_low_inverse.npy"
    selected_path = HERE / f"axis{axis}_selected_rows.npy"
    if args.resume and inverse_path.is_file() and selected_path.is_file():
        selected = np.load(selected_path).astype(np.int32)
        inverse_u8 = np.load(inverse_path).astype(np.uint8)
        rank = len(selected)
        solve_seconds = 0.0
        if selected.shape != (4218,) or inverse_u8.shape != (4218, 4218):
            raise RuntimeError("invalid resume artifacts")
        minor_u8 = np.ascontiguousarray(low[selected], dtype=np.uint8)
        print("resuming from stored selected rows and inverse", flush=True)
    else:
        print(f"low block {low.shape} sha={low_sha}; row profile", flush=True)
        rank, selected = row_rank_profile(low.astype(np.float64))
        if rank != len(low_columns):
            raise RuntimeError(f"low block rank {rank}, expected {len(low_columns)}")
        minor_u8 = np.ascontiguousarray(low[selected], dtype=np.uint8)
        # Invert the selected low minor exactly with one FFLAS factorization.
        a = minor_u8.astype(np.float64)
        inverse = np.eye(len(low_columns), dtype=np.float64)
        solve_started = time.monotonic()
        solve_rank = right_solve_inplace(a, inverse)
        solve_seconds = time.monotonic() - solve_started
        if solve_rank != len(low_columns):
            raise RuntimeError(f"selected minor solve rank {solve_rank}")
        inverse_i64 = np.rint(inverse).astype(np.int64) % P
        inverse_u8 = inverse_i64.astype(np.uint8)
        del inverse_i64, inverse, a
        np.save(inverse_path, inverse_u8)
        np.save(selected_path, selected)
    minor_sha = sha256_array(minor_u8)
    inverse_sha = sha256_array(inverse_u8)
    del low
    # Cheap but exact full verification.  The integer dot bound is
    # 4218*88^2 < 2^53, hence modular-double GEMM is exact.
    check = inverse_u8.astype(np.float64) @ minor_u8.astype(np.float64)
    np.remainder(check, float(P), out=check)
    if not np.array_equal(check.astype(np.uint8), np.eye(len(low_columns), dtype=np.uint8)):
        raise RuntimeError("inverse times selected minor is not identity")
    del check

    # Normalize the pure affine-cubic tails in bounded column chunks.
    tails_path = HERE / f"axis{axis}_border_tails.npy"
    start_column = 0
    if args.resume and tails_path.is_file():
        tails = np.lib.format.open_memmap(tails_path, mode="r+")
        if tails.shape != (len(low_columns), len(high_columns)) or tails.dtype != np.uint8:
            raise RuntimeError("invalid tail resume artifact")
        populated = np.any(tails != 0, axis=0)
        missing = np.flatnonzero(~populated)
        # A genuinely all-zero normalized cubic column is possible in
        # principle, so round down to a chunk boundary and safely recompute.
        if len(missing):
            start_column = max(0, (int(missing[0]) // args.chunk - 1) * args.chunk)
        else:
            start_column = len(high_columns)
        print(f"tail resume starts at column {start_column}", flush=True)
    else:
        tails = np.lib.format.open_memmap(
            tails_path, mode="w+", dtype=np.uint8,
            shape=(len(low_columns), len(high_columns)),
        )
    left = inverse_u8.astype(np.float64)
    for chunk_number, start in enumerate(range(start_column, len(high_columns), args.chunk)):
        end = min(len(high_columns), start + args.chunk)
        right = np.ascontiguousarray(flat[selected][:, high_columns[start:end]], dtype=np.float64)
        product = left @ right
        np.remainder(product, float(P), out=product)
        tails[:, start:end] = product.astype(np.uint8)
        tails.flush()
        if chunk_number % 4 == 0 or end == len(high_columns):
            print(f"tails {end}/{len(high_columns)}", flush=True)
        del right, product
    del tails, left
    tails_array = np.load(tails_path, mmap_mode="r")
    tails_sha = hashlib.sha256()
    for start in range(0, len(low_columns), 32):
        tails_sha.update(np.ascontiguousarray(tails_array[start:start+32]).tobytes())
    tails_data_sha = tails_sha.hexdigest()

    packet_path = HERE / f"axis{axis}_border_packet.npz"
    np.savez_compressed(
        packet_path,
        axis=np.int32(axis),
        prime=np.int32(P),
        low_monomials=low_monomials,
        high_monomials=high_monomials,
        low_columns=low_columns,
        high_columns=high_columns,
        selected_rows=selected,
        low_block_sha256=np.asarray(low_sha),
        minor_sha256=np.asarray(minor_sha),
        inverse_data_sha256=np.asarray(inverse_sha),
        tails_data_sha256=np.asarray(tails_data_sha),
    )
    manifest = {
        "status": "PASS_EXACT_AFFINE_BORDER",
        "prime": P,
        "axis": axis,
        "full_p3": {"path": str(P3_PATH), "sha256": sha256(P3_PATH)},
        "low_block": {"shape": [R, 4218], "rank": rank, "sha256": low_sha},
        "selected_minor": {"shape": [4218, 4218], "sha256": minor_sha},
        "selected_rows": {"file": selected_path.name, "sha256": sha256(selected_path)},
        "inverse": {
            "file": inverse_path.name,
            "sha256": sha256(inverse_path),
            "canonical_data_sha256": inverse_sha,
            "verified_product_is_identity": True,
        },
        "pure_cubic_tails": {
            "file": tails_path.name,
            "shape": [4218, 50616],
            "sha256": sha256(tails_path),
            "canonical_data_sha256": tails_data_sha,
        },
        "packet": {"file": packet_path.name, "sha256": sha256(packet_path)},
        "fflas_solve_seconds": round(solve_seconds, 6),
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "scope": (
            "These are exact normalized border rules. They do not decide the "
            "degree-five pure-power memberships until the terminal cubic-to-quintic "
            "remainders are reduced by all pure-cubic relations."
        ),
    }
    manifest_path = HERE / f"axis{axis}_border_manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n")
    print(json.dumps(manifest, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
