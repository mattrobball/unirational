#!/usr/bin/env python3
"""Identify the canonical pieces of the exact all-free-minor quotient."""

from __future__ import annotations

from math import comb
import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
BASIS = HERE / "faithful_kernel_basis.npy"
LABELS = HERE / "faithful_free_minor_components.raw"
N = 4305


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def quadratic_ids(a: int, bs: np.ndarray) -> np.ndarray:
    left = np.minimum(a, bs).astype(np.int64)
    right = np.maximum(a, bs).astype(np.int64)
    return left * N - left * (left - 1) // 2 + (right - left)


def main() -> None:
    basis = np.load(BASIS, mmap_mode="r", allow_pickle=False)
    assert basis.shape == (4995, N) and basis.dtype == np.uint8
    free_w = np.full(N, -1, dtype=np.int32)
    seen: set[int] = set()
    for w, row in enumerate(basis):
        nonzero = np.flatnonzero(row)
        if len(nonzero) == 1 and int(row[nonzero[0]]) == 1:
            variable = int(nonzero[0])
            if variable not in seen:
                free_w[variable] = w
                seen.add(variable)
    assert len(seen) == N and np.all(free_w >= 0)
    special = np.flatnonzero(free_w < 703)
    main = np.flatnonzero(free_w >= 703)
    assert np.array_equal(free_w[special], np.arange(690, 703, dtype=np.int32))
    assert len(special) == 13 and len(main) == 4292

    labels = np.memmap(LABELS, dtype=np.int32, mode="r")
    assert len(labels) == N * (N + 1) // 2
    components = int(labels.max()) + 1
    flags = np.zeros(components, dtype=np.uint8)
    for offset, a in enumerate(main):
        ids = quadratic_ids(int(a), main[offset:])
        flags[labels[ids]] |= 1
    for a in special:
        flags[labels[quadratic_ids(int(a), main)]] |= 2
    for offset, a in enumerate(special):
        flags[labels[quadratic_ids(int(a), special[offset:])]] |= 4
    unique, counts = np.unique(flags, return_counts=True)
    distribution = {str(int(key)): int(value) for key, value in zip(unique, counts)}
    expected_core_terms = {
        "S4V_tensor_Sym2_of_five_B1_blocks": comb(40, 4) * comb(6, 2),
        "S3V_tensor_five_B1_tensor_B2": comb(39, 3) * 5 * 21,
        "S2V_tensor_Sym2_B2": comb(38, 2) * comb(22, 2),
    }
    expected_core = sum(expected_core_terms.values())
    assert distribution == {"1": expected_core, "2": 41158, "4": 91}
    assert expected_core == 2_492_838 and components == 2_534_087
    payload = {
        "status": "PASS_CANONICAL_FREE_QUOTIENT_NONVERDICT",
        "kernel_basis_sha256": sha256(BASIS),
        "component_labels_sha256": sha256(LABELS),
        "systematic_pivot_W_coordinates": list(range(690)),
        "special_free_W_coordinates": list(range(690, 703)),
        "main_free_W_coordinates": [703, 4994],
        "quotient_dimension": components,
        "canonical_core_terms": expected_core_terms,
        "canonical_core_dimension": expected_core,
        "special_times_main_dimension": 41158,
        "Sym2_special_dimension": 91,
        "partition_flags": distribution,
        "scope_guard": (
            "This is the quotient by all-free minors only.  Pivot-containing "
            "minors remain, and the independent Hilbert count proves that at "
            "least 24252 degree-two classes survive even after all minors."
        ),
    }
    (HERE / "canonical_free_quotient_result.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("PASS_CANONICAL_FREE_QUOTIENT_NONVERDICT")


if __name__ == "__main__":
    main()
