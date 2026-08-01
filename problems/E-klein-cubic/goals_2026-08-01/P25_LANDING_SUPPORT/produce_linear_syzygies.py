#!/usr/bin/env python3
"""Produce exact degree-one left syzygies of the Stage-A linear block.

Write the sealed lower-presentation matrix as

    M(q) = [M0(q) | M1(q) | M2(q)],

where the 21 columns of M2 are linear in q.  A row vector C(q), linear in q,
with C(q) M2(q) = 0 eliminates all 21 quadratic-basis kernel variables from
the incidence.  This script constructs the coefficient matrix of that exact
linear-syzygy problem over F_89 and uses FFLAS-FFPACK only for finite-field
linear algebra.  The saved syzygies are checked directly against the sealed
M2 tensor after the nullspace computation.

Only sealed inputs are read.  Every output is written beside this script.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path
import time

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FM = ROOT / "certificates" / "degree25_finite_module"
P = 89
N_SAVED = 256
SELECT_SEED = 2026080126


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    result: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            result.append((first,) + tail)
    return result


def fflas_right_nullspace(matrix: np.ndarray) -> tuple[np.ndarray, int]:
    """Return FFLAS-owned N x nullity basis view; valid until process exit."""
    assert matrix.dtype == np.float64 and matrix.flags.c_contiguous
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    # Homebrew's C interface exports this instantiated routine with C++ linkage.
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
        float(P),
        142,  # FflasRight
        rows,
        columns,
        matrix,
        columns,
        ctypes.byref(pointer),
        ctypes.byref(leading),
        ctypes.byref(nullity),
        False,
    )
    assert returned == nullity.value
    assert leading.value == nullity.value
    raw = np.ctypeslib.as_array(pointer, shape=(columns * nullity.value,))
    return raw.reshape(columns, nullity.value), int(nullity.value)


def direct_syzygy_check(syzygy: np.ndarray, m2: np.ndarray) -> bool:
    """Check C(q)M2(q)=0 after symmetrizing the two q indices."""
    # raw[u,j,v] is the coefficient of q_u q_v in column j before symmetry.
    raw = np.einsum(
        "au,ajv->ujv", syzygy.astype(np.int64), m2.astype(np.int64), optimize=True
    ) % P
    for u in range(37):
        if np.any(raw[u, :, u] % P):
            return False
        for v in range(u + 1, 37):
            if np.any((raw[u, :, v] + raw[v, :, u]) % P):
                return False
    return True


def main() -> None:
    started = time.monotonic()
    relation_path = FM / "relation_matrix.npz"
    with np.load(relation_path) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        assert int(frozen["prime"]) == P
    assert seeds.shape == (690, 14134)

    linear_monomials = weak_compositions(1, 37)
    variable_of = [monomial.index(1) for monomial in linear_monomials]
    quadratic_monomials = weak_compositions(2, 37)
    quadratic_index = {monomial: i for i, monomial in enumerate(quadratic_monomials)}
    assert len(linear_monomials) == 37 and len(quadratic_monomials) == 703

    # M2[a,j,v] is the q_v coefficient of row a, quadratic-basis column j.
    m2 = np.empty((690, 21, 37), dtype=np.uint8)
    for j in range(21):
        block = seeds[:, int(offsets[7 + j]) : int(offsets[8 + j])]
        for monomial_index, variable in enumerate(variable_of):
            m2[:, j, variable] = block[:, monomial_index]

    # Unknowns are c[a,u] in C_a(q)=sum_u c[a,u]q_u.  Equations are the
    # coefficients of all 21 components and all 703 quadratic q monomials.
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

    coefficient_sha = sha256_array(coefficient)
    print(
        f"linear-syzygy matrix={coefficient.shape} bytes={coefficient.nbytes} "
        f"sha256={coefficient_sha}",
        flush=True,
    )

    # FFLAS uses exact modular double arithmetic here (p=89 is safely small).
    dense = coefficient.astype(np.float64)
    del coefficient
    basis, nullity = fflas_right_nullspace(dense)
    expected_nullity = 690 * 37 - 21 * 703
    assert nullity == expected_nullity == 10767
    print(f"rank=14763 nullity={nullity}", flush=True)

    rng = np.random.default_rng(SELECT_SEED)
    selected = np.sort(rng.choice(nullity, size=N_SAVED, replace=False)).astype(np.int32)
    # basis has shape (690*37, nullity); its selected columns are syzygies.
    saved = np.rint(basis[:, selected]).astype(np.int64) % P
    saved = saved.T.reshape(N_SAVED, 690, 37).astype(np.uint8)
    del dense

    for index, syzygy in enumerate(saved):
        if not direct_syzygy_check(syzygy, m2):
            raise AssertionError(f"saved syzygy {index} failed direct contraction check")
    assert np.linalg.matrix_rank(saved.reshape(N_SAVED, -1).astype(np.float64)) == N_SAVED

    output = HERE / "linear_syzygies.npz"
    np.savez_compressed(
        output,
        syzygies=saved,
        selected_basis_columns=selected,
        prime=np.int32(P),
        coefficient_shape=np.asarray([21 * 703, 690 * 37], dtype=np.int32),
        coefficient_sha256=np.asarray(coefficient_sha),
        relation_matrix_sha256=np.asarray(sha256(relation_path)),
        seed_F3_sha256=np.asarray(sha256_array(seeds)),
        select_seed=np.int64(SELECT_SEED),
    )
    metadata = {
        "prime": P,
        "construction": "degree-one left syzygies C(q) of the 690x21 linear M2 block",
        "coefficient_matrix_shape": [21 * 703, 690 * 37],
        "coefficient_matrix_rank": 21 * 703,
        "coefficient_matrix_sha256": coefficient_sha,
        "nullity": nullity,
        "saved_syzygies": N_SAVED,
        "selection_seed": SELECT_SEED,
        "selected_basis_columns": selected.tolist(),
        "all_saved_syzygies_directly_verified": True,
        "source": {
            "relation_matrix": str(relation_path.relative_to(ROOT)),
            "relation_matrix_sha256": sha256(relation_path),
            "seed_F3_sha256": sha256_array(seeds),
        },
        "artifact": output.name,
        "artifact_sha256": sha256(output),
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "logical_scope": (
            "Every full lower-presentation kernel-incidence point satisfies all "
            "saved syzygy contractions. Emptiness after retaining any subset of "
            "these necessary equations therefore proves lower-presentation emptiness."
        ),
    }
    metadata_path = HERE / "linear_syzygies.json"
    metadata_path.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(json.dumps(metadata, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
