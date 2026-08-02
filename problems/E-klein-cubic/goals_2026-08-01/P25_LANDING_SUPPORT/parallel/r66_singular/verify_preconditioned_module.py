#!/usr/bin/env python3
"""CAS-free replay of the exact constant-row module preconditioner."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
PACKET = P25 / "parallel" / "global_compatibility" / "support_augmented_r66_stageBC.npz"
P = 89


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def rank_mod(matrix: np.ndarray) -> int:
    work = np.asarray(matrix, dtype=np.int64).copy() % P
    rank = 0
    for column in range(work.shape[1]):
        candidates = np.flatnonzero(work[rank:, column])
        if not len(candidates):
            continue
        pivot = rank + int(candidates[0])
        work[[rank, pivot]] = work[[pivot, rank]]
        work[rank] = work[rank] * pow(int(work[rank, column]), -1, P) % P
        for row in range(work.shape[0]):
            if row != rank and work[row, column]:
                work[row] = (work[row] - work[row, column] * work[rank]) % P
        rank += 1
        if rank == work.shape[0]:
            break
    return rank


def main() -> None:
    manifest = json.loads((HERE / "preconditioned_manifest.json").read_text())
    for key in ("certificate", "include", "job"):
        entry = manifest[key]
        path = HERE / entry["file"]
        if path.stat().st_size != entry["bytes"] or sha256(path) != entry["sha256"]:
            raise AssertionError(f"preconditioned {key} hash mismatch")
    with np.load(PACKET, allow_pickle=False) as source, np.load(HERE / manifest["certificate"]["file"], allow_pickle=False) as cert:
        p3 = source["p3"].astype(np.int64)
        transform = cert["transform"].astype(np.int64)
        preconditioned = cert["preconditioned_p3"].astype(np.int64)
        order = cert["ordered_columns"].astype(np.int64)
        pivots = cert["pivot_positions"].astype(np.int64)
        if int(source["prime"]) != P or int(cert["prime"]) != P:
            raise AssertionError("prime mismatch")
    if rank_mod(transform) != 66:
        raise AssertionError("constant row transform is not invertible")
    product = transform @ p3.reshape(66, -1) % P
    if not np.array_equal(product.reshape(66, 6, 9139), preconditioned):
        raise AssertionError("preconditioned tensor is not T*P3")
    ordered = preconditioned.reshape(66, -1)[:, order]
    if not np.array_equal(ordered[:, pivots], np.eye(66, dtype=np.int64)):
        raise AssertionError("preconditioned leading pivot block is not identity")
    raw_job = (HERE / manifest["job"]["file"]).read_text()
    if "ring R=89" not in raw_job or "(dp,C)" not in raw_job or "module G=std(N);" not in raw_job:
        raise AssertionError("preconditioned job syntax mismatch")
    if "option(notBuckets);" not in raw_job or "degBound" in raw_job or "option(redSB)" in raw_job:
        raise AssertionError("preconditioned memory/exactness option mismatch")
    if list(HERE.glob("*.run.json")) or list(HERE.glob("*.log")) or list(HERE.glob("*.result.txt")):
        raise AssertionError("unexpected CAS run artifacts")
    result = {
        "status": "PASS_PRECONDITIONED_R66_MODULE_PREPARED_NOT_RUN",
        "transform_rank": 66,
        "pivot_block_identity": True,
        "job_sha256": manifest["job"]["sha256"],
        "cas_launched": False,
        "theorem_status": "P25-UNDECIDED",
    }
    (HERE / "verify_preconditioned_module_result.json").write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS_PRECONDITIONED_R66_MODULE_PREPARED_NOT_RUN")


if __name__ == "__main__":
    main()

