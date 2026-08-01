#!/usr/bin/env python3
"""Reconstruct the overwritten deterministic 96-syzygy packet in memory.

This is a compatibility/replay helper for the r48/r96 contracted artifacts,
whose metadata seals the earlier packet hash.  It never overwrites either
syzygy packet; it checks the contractions directly and writes only the 48
syzygies actually used by the exact saturation input.
"""

from __future__ import annotations

import ctypes
import hashlib
from pathlib import Path

import numpy as np

import verify_syzygy_empty as verifier


HERE = Path(__file__).resolve().parent
P = 89
OLD_SAVED = 96
SEED = 2026080126


def fflas_right_nullspace(matrix: np.ndarray) -> tuple[np.ndarray, int]:
    """Return the exact modular right-nullspace basis owned by FFLAS."""
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
        ctypes.byref(pointer), ctypes.byref(leading), ctypes.byref(nullity), False,
    )
    if returned != nullity.value or leading.value != nullity.value:
        raise RuntimeError("FFLAS nullspace metadata mismatch")
    raw = np.ctypeslib.as_array(pointer, shape=(columns * nullity.value,))
    return raw.reshape(columns, nullity.value), int(nullity.value)


def main() -> None:
    with np.load(verifier.RELATION) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)

    linear = verifier.weak_compositions(1, 37)
    variable_of = [monomial.index(1) for monomial in linear]
    quadratic = verifier.weak_compositions(2, 37)
    quadratic_index = {monomial: i for i, monomial in enumerate(quadratic)}
    m2 = np.empty((690, 21, 37), dtype=np.uint8)
    for j in range(21):
        block = seeds[:, int(offsets[7 + j]):int(offsets[8 + j])]
        for monomial_index, variable in enumerate(variable_of):
            m2[:, j, variable] = block[:, monomial_index]

    coefficient = np.zeros((21 * 703, 690 * 37), dtype=np.uint8)
    row_for_pair = np.empty((37, 37), dtype=np.int32)
    for u in range(37):
        for v in range(37):
            exponent = [0] * 37
            exponent[u] += 1
            exponent[v] += 1
            row_for_pair[u, v] = quadratic_index[tuple(exponent)]
    base_columns = np.arange(690, dtype=np.int32) * 37
    for j in range(21):
        row_base = j * 703
        for u in range(37):
            columns = base_columns + u
            for v in range(37):
                row = coefficient[row_base + int(row_for_pair[u, v])]
                row[columns] = (row[columns].astype(np.int16) + m2[:, j, v]) % P

    expected_coefficient_sha = "d813f7b59057c939577faa0f22184b9fa9cce8a7d63af9c321514be9437b3f8f"
    actual_sha = hashlib.sha256(np.ascontiguousarray(coefficient).tobytes()).hexdigest()
    if actual_sha != expected_coefficient_sha:
        raise RuntimeError("linear-syzygy coefficient matrix did not reconstruct")
    dense = coefficient.astype(np.float64)
    del coefficient
    basis, nullity = fflas_right_nullspace(dense)
    if nullity != 10767:
        raise RuntimeError(f"unexpected syzygy nullity {nullity}")
    rng = np.random.default_rng(SEED)
    selected = np.sort(rng.choice(nullity, size=OLD_SAVED, replace=False))
    old = np.rint(basis[:, selected]).astype(np.int64) % P
    old = old.T.reshape(OLD_SAVED, 690, 37).astype(np.uint8)
    del dense

    with np.load(verifier.CONTRACTED) as frozen:
        chosen = frozen["chosen_syzygies"].astype(np.int32)
        stored_p4 = frozen["p4"].astype(np.uint8)
        stored_p3 = frozen["p3"].astype(np.uint8)
    syzygies = old[chosen]
    for row, syzygy in enumerate(syzygies):
        if not verifier.direct_syzygy_check(syzygy, m2):
            raise RuntimeError(f"old syzygy {row} failed direct check")

    q2 = verifier.weak_compositions(2, 37)
    q3 = verifier.weak_compositions(3, 37)
    q4 = verifier.weak_compositions(4, 37)
    map23 = verifier.multiplication_map(q2, q3)
    map34 = verifier.multiplication_map(q3, q4)
    b0 = seeds[:, int(offsets[0]):int(offsets[1])]
    for row, syzygy in enumerate(syzygies):
        rebuilt = verifier.contract(syzygy, b0, map34, len(q4))
        if not np.array_equal(rebuilt, stored_p4[row]):
            raise RuntimeError(f"old syzygy {row} P4 contraction mismatch")
        for j in range(6):
            block = seeds[:, int(offsets[1 + j]):int(offsets[2 + j])]
            rebuilt = verifier.contract(syzygy, block, map23, len(q3))
            if not np.array_equal(rebuilt, stored_p3[row, j]):
                raise RuntimeError(f"old syzygy {row}, P3 block {j} mismatch")

    target = HERE / "linear_syzygies_r48_reconstructed.npz"
    np.savez_compressed(
        target,
        syzygies=syzygies,
        old_syzygies=old,
        old_selected_basis_columns=selected,
        chosen_syzygies=chosen,
        prime=np.int32(P),
        coefficient_sha256=np.asarray(actual_sha),
        selection_seed=np.int64(SEED),
        old_saved_count=np.int32(OLD_SAVED),
    )
    print(
        f"PASS: reconstructed and checked 48 old contractions; output={target.name}",
        flush=True,
    )


if __name__ == "__main__":
    main()
