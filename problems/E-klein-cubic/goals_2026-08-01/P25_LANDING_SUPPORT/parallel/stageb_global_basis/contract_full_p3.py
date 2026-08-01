#!/usr/bin/env python3
"""Contract all 10,767 systematic syzygies against the six M1 blocks.

Input syzygies have shape (10767,690,37).  The output is the complete
degree-three row module

    P3(C) = C(q) M1(q) in F_89[q0,...,q36]^6

with shape (10767,6,9139).  The calculation is blocked by the first q index:
37 exact floating-point GEMMs are safe because every unreduced dot product is
below 2^53.  The 590-MiB output is a disk-backed uint8 array, so peak working
memory stays below one GiB.  No CAS process is launched.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import time

import numpy as np

from produce_full_basis import (
    FM,
    NQ,
    NULLITY,
    P,
    RELATION,
    free_gib_from_vm_stat,
    sha256,
    weak_compositions,
)


HERE = Path(__file__).resolve().parent
BASIS = HERE / "full_linear_syzygy_basis.npy"
OUTPUT = HERE / "full_p3_contractions.npy"


def multiplication_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: i for i, monomial in enumerate(target)}
    answer = np.empty((NQ, len(source)), dtype=np.int32)
    for variable in range(NQ):
        for source_index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            answer[variable, source_index] = target_index[tuple(exponent)]
    return answer


def sha256_array_data(path: Path, shape: tuple[int, ...], chunk: int = 64) -> str:
    array = np.load(path, mmap_mode="r")
    if array.shape != shape or array.dtype != np.uint8:
        raise AssertionError("unexpected array while hashing")
    digest = hashlib.sha256()
    for start in range(0, shape[0], chunk):
        digest.update(np.ascontiguousarray(array[start : start + chunk]).tobytes())
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--min-free-gib", type=float, default=8.0)
    args = parser.parse_args()
    observed_free = free_gib_from_vm_stat()
    if observed_free is not None and observed_free < args.min_free_gib:
        raise SystemExit(
            f"resource guard: free+speculative={observed_free:.2f} GiB "
            f"< required {args.min_free_gib:.2f} GiB"
        )
    if not BASIS.is_file():
        raise FileNotFoundError(BASIS)
    basis = np.load(BASIS, mmap_mode="r")
    if basis.shape != (NULLITY, 690, NQ) or basis.dtype != np.uint8:
        raise AssertionError(f"unexpected basis {basis.shape} {basis.dtype}")

    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime mismatch")
    q2 = weak_compositions(2, NQ)
    q3 = weak_compositions(3, NQ)
    product_map = multiplication_map(q2, q3)
    blocks = np.concatenate(
        [
            seeds[:, int(offsets[1 + j]) : int(offsets[2 + j])]
            for j in range(6)
        ],
        axis=1,
    ).astype(np.float64)
    if blocks.shape != (690, 6 * len(q2)):
        raise AssertionError(f"unexpected concatenated M1 shape {blocks.shape}")

    started = time.monotonic()
    p3 = np.lib.format.open_memmap(
        OUTPUT,
        mode="w+",
        dtype=np.uint8,
        shape=(NULLITY, 6, len(q3)),
    )
    p3[:] = 0
    p3.flush()
    for variable in range(NQ):
        # Exact modular-double GEMM: max absolute integer sum is
        # 690*88*88 = 5,343,360, far below the 2^53 exactness boundary.
        left = np.ascontiguousarray(basis[:, :, variable], dtype=np.float64)
        product = left @ blocks
        del left
        np.remainder(product, float(P), out=product)
        addition = product.astype(np.uint8).reshape(NULLITY, 6, len(q2))
        del product
        targets = product_map[variable]
        for component in range(6):
            updated = p3[:, component, targets].astype(np.uint16)
            updated += addition[:, component]
            np.remainder(updated, P, out=updated)
            p3[:, component, targets] = updated.astype(np.uint8)
        del addition
        p3.flush()
        print(f"contracted q index {variable + 1}/37", flush=True)
    del p3

    full = np.load(OUTPUT, mmap_mode="r")
    nnz = np.empty(NULLITY, dtype=np.int32)
    component_nnz = np.empty((NULLITY, 6), dtype=np.int32)
    for start in range(0, NULLITY, 64):
        chunk = full[start : start + 64]
        component_nnz[start : start + len(chunk)] = np.count_nonzero(
            chunk, axis=2
        )
        nnz[start : start + len(chunk)] = np.count_nonzero(chunk, axis=(1, 2))
    data_sha = sha256_array_data(OUTPUT, (NULLITY, 6, len(q3)))
    statistics_path = HERE / "full_p3_statistics.npz"
    np.savez_compressed(
        statistics_path,
        p3_nnz=nnz,
        component_nnz=component_nnz,
        prime=np.int32(P),
        full_p3_data_sha256=np.asarray(data_sha),
        full_basis_sha256=np.asarray(sha256(BASIS)),
        relation_matrix_sha256=np.asarray(sha256(RELATION)),
    )
    manifest = {
        "status": "PASS_FULL_P3_CONTRACTION",
        "prime": P,
        "shape": [NULLITY, 6, len(q3)],
        "dtype": "uint8",
        "file": OUTPUT.name,
        "file_bytes": OUTPUT.stat().st_size,
        "file_sha256": sha256(OUTPUT),
        "canonical_data_sha256": data_sha,
        "p3_nnz": {
            "min": int(nnz.min()),
            "max": int(nnz.max()),
            "mean": float(nnz.mean()),
            "quantiles": {
                str(q): float(np.quantile(nnz, q))
                for q in (0.0, 0.1, 0.25, 0.5, 0.75, 0.9, 1.0)
            },
        },
        "source": {
            "full_basis": BASIS.name,
            "full_basis_sha256": sha256(BASIS),
            "relation_matrix": str(RELATION),
            "relation_matrix_sha256": sha256(RELATION),
        },
        "statistics": {
            "file": statistics_path.name,
            "sha256": sha256(statistics_path),
        },
        "observed_free_plus_speculative_gib_before_run": observed_free,
        "no_singular_launched": True,
        "elapsed_seconds": round(time.monotonic() - started, 6),
    }
    manifest_path = HERE / "full_p3_manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n")
    print(json.dumps(manifest, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
