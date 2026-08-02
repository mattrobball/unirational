#!/usr/bin/env python3
"""Build K'=ker(W->F_89^690) and quotient by all-free Segre minors.

This is the first exact block in the faithful outer-Segre strategy.  It does
not claim that the remaining pivot-containing minors have full residual rank.
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
RELATION = Path(
    "/Users/worker/unirational/problems/E-klein-cubic/certificates/"
    "degree25_finite_module/relation_matrix.npz"
)
P = 89
NW = 4995
NK = 4305
NOUTER_ROWS = 37
NOUTER_COLS = 243


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def fflas_right_nullspace(matrix: np.ndarray) -> tuple[np.ndarray, int]:
    if matrix.dtype != np.float64 or not matrix.flags.c_contiguous:
        raise TypeError("FFLAS input must be contiguous float64")
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    symbol = (
        "_Z29NullSpaceBasis_modular_doubledN5FFLAS10FFLAS_SIDEEmm"
        "PdmPS1_PmS3_b"
    )
    function = getattr(library, symbol)
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_int,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.POINTER(ctypes.c_double)),
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    pointer = ctypes.POINTER(ctypes.c_double)()
    leading = ctypes.c_size_t()
    nullity = ctypes.c_size_t()
    rows, columns = matrix.shape
    returned = function(
        float(P), 142, rows, columns, matrix, columns,
        ctypes.byref(pointer), ctypes.byref(leading), ctypes.byref(nullity), False
    )
    if returned != nullity.value or leading.value != nullity.value:
        raise AssertionError("unexpected FFLAS nullspace layout")
    raw = np.ctypeslib.as_array(pointer, shape=(columns * nullity.value,))
    return raw.reshape(columns, nullity.value), int(nullity.value)


def main() -> None:
    started = time.monotonic()
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        assert int(frozen["prime"]) == P
    assert seeds.shape == (690, 14134)
    assert int(offsets[1]) == 9139 and int(offsets[-1]) == 14134
    coefficient = np.ascontiguousarray(seeds[:, int(offsets[1]) :], dtype=np.float64)
    basis_float, nullity = fflas_right_nullspace(coefficient)
    assert nullity == NK and basis_float.shape == (NW, NK)
    basis = np.asarray(np.rint(basis_float), dtype=np.int64) % P
    basis = basis.astype(np.uint8)
    # Exact streamed kernel check.  Each unreduced dot product is bounded by
    # 4995*88^2 < 2^53, so modular-double GEMM is integer-exact here.
    coefficient_check = np.ascontiguousarray(
        seeds[:, int(offsets[1]) :], dtype=np.float64
    )
    for lo in range(0, NK, 512):
        hi = min(NK, lo + 512)
        product = coefficient_check @ np.asarray(basis[:, lo:hi], dtype=np.float64)
        if np.count_nonzero(np.asarray(np.rint(product), dtype=np.int64) % P):
            raise AssertionError(f"kernel identity failed in columns {lo}:{hi}")

    free_ids = np.full(NW, -1, dtype=np.int32)
    seen = np.zeros(NK, dtype=bool)
    for row in range(NW):
        nonzero = np.flatnonzero(basis[row])
        if len(nonzero) == 1 and int(basis[row, nonzero[0]]) == 1:
            column = int(nonzero[0])
            if not seen[column]:
                free_ids[row] = column
                seen[column] = True
    if not np.all(seen) or np.count_nonzero(free_ids >= 0) != NK:
        raise AssertionError("FFLAS basis did not expose one distinct identity row per variable")

    q1 = weak_compositions(1, 37)
    q2 = weak_compositions(2, 37)
    q1_index = {monomial: index for index, monomial in enumerate(q1)}
    q2_index = {monomial: index for index, monomial in enumerate(q2)}
    cell_w = np.empty((NOUTER_ROWS, NOUTER_COLS), dtype=np.int32)
    for a in range(37):
        for alpha in range(NOUTER_COLS):
            if alpha < 6 * 37:
                block, b = divmod(alpha, 37)
                exponent = [0] * 37
                exponent[a] += 1
                exponent[b] += 1
                cell_w[a, alpha] = block * 703 + q2_index[tuple(exponent)]
            else:
                block = alpha - 6 * 37
                exponent = [0] * 37
                exponent[a] = 1
                cell_w[a, alpha] = 6 * 703 + block * 37 + q1_index[tuple(exponent)]
    if int(cell_w.min()) != 0 or int(cell_w.max()) != NW - 1:
        raise AssertionError("outer-to-W cell map is not onto the coefficient basis")
    cell_free = free_ids[cell_w]

    basis_path = HERE / "faithful_kernel_basis.npy"
    cell_path = HERE / "faithful_cell_free_ids.raw"
    labels_path = HERE / "faithful_free_minor_components.raw"
    np.save(basis_path, basis)
    cell_free.tofile(cell_path)
    binary = HERE / "free_minor_union"
    subprocess.run(
        ["clang++", "-O3", "-std=c++17", str(HERE / "free_minor_union.cpp"), "-o", str(binary)],
        check=True,
    )
    completed = subprocess.run(
        [str(binary), str(cell_path), str(labels_path)],
        check=True, text=True, capture_output=True,
    )
    ledger = {}
    for line in completed.stdout.splitlines():
        key, value = line.split("=", 1)
        ledger[key] = int(value)
    nquad = NK * (NK + 1) // 2
    assert ledger["nquad"] == nquad
    assert labels_path.stat().st_size == 4 * nquad
    payload = {
        "status": "PASS_FAITHFUL_SEGRE_FREE_BLOCK_NONVERDICT",
        "prime": P,
        "coefficient_map_shape": [690, NW],
        "coefficient_map_rank": 690,
        "kernel_dimension": NK,
        "quadratic_target_dimension": nquad,
        "relation_sha256": sha256(RELATION),
        "kernel_basis": {"path": basis_path.name, "sha256": sha256(basis_path)},
        "cell_free_ids": {"path": cell_path.name, "sha256": sha256(cell_path)},
        "component_labels": {"path": labels_path.name, "sha256": sha256(labels_path)},
        "free_minor_block": ledger,
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "scope_guard": (
            "This quotients by every restricted outer minor whose four W coordinates "
            "are systematic free coordinates. Pivot-containing minors remain to be "
            "projected and ranked; no Stage-B conclusion follows yet."
        ),
    }
    (HERE / "faithful_segre_free_block.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps(payload, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
