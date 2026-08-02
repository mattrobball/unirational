#!/usr/bin/env python3
"""Replay the prepared r43/r64 augmented P4|P3 module inputs."""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
GB = HERE.parent / "stageb_global_basis"
FM = ROOT / "certificates" / "degree25_finite_module"
RELATION = FM / "relation_matrix.npz"
FULL_BASIS = GB / "full_linear_syzygy_basis.npy"
FULL_P3 = GB / "full_p3_contractions.npy"
R43 = GB / "support_balanced_r43_stageBC.npz"
R64 = HERE / "support_balanced_r64_stageBC.npz"
P = 89
NQ = 37


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def rank_fflas(matrix: np.ndarray) -> int:
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


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    answer: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            answer.append((first,) + tail)
    return answer


def multiplication_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: index for index, monomial in enumerate(target)}
    answer = np.empty((NQ, len(source)), dtype=np.int32)
    for variable in range(NQ):
        for index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            answer[variable, index] = target_index[tuple(exponent)]
    return answer


def recompute_p4(
    syzygies: np.ndarray, b0: np.ndarray, product_map: np.ndarray, target: int
) -> np.ndarray:
    output = np.zeros((len(syzygies), target), dtype=np.uint8)
    for variable in range(NQ):
        product = (
            np.ascontiguousarray(syzygies[:, :, variable], dtype=np.float64)
            @ np.asarray(b0, dtype=np.float64)
        )
        np.remainder(product, float(P), out=product)
        addition = product.astype(np.uint8)
        indices = product_map[variable]
        updated = output[:, indices].astype(np.uint16) + addition
        output[:, indices] = (updated % P).astype(np.uint8)
    return output


def main() -> None:
    metadata = json.loads((HERE / "augmented_module_jobs.json").read_text())
    if metadata["status"] != "PASS_AUGMENTED_MODULE_JOBS_PREPARED":
        raise AssertionError("prepared-job status mismatch")
    if not metadata["not_run"] or not metadata["no_singular_launched"]:
        raise AssertionError("prepared-job metadata does not record unlaunched state")

    for label in ("r43", "r64"):
        job = metadata["jobs"][label]
        script = HERE / job["script"]
        if sha256_file(script) != job["script_sha256"]:
            raise AssertionError(f"{label} script hash mismatch")
        if script.stat().st_size != job["script_bytes"]:
            raise AssertionError(f"{label} script size mismatch")
        if (HERE / job["result"]).exists():
            raise AssertionError(f"{label} result exists although job is sealed unlaunched")

    r64 = np.load(R64, allow_pickle=False)
    columns = r64["full_basis_columns"].astype(np.int32)
    stored_p3 = r64["p3"].astype(np.uint8)
    stored_p4 = r64["p4"].astype(np.uint8)
    stored_syzygies = r64["syzygies"].astype(np.uint8)
    if int(r64["prime"]) != P or len(columns) != 64:
        raise AssertionError("r64 packet header mismatch")
    full_basis = np.load(FULL_BASIS, mmap_mode="r")
    full_p3 = np.load(FULL_P3, mmap_mode="r")
    if not np.array_equal(stored_syzygies, np.asarray(full_basis[columns])):
        raise AssertionError("r64 syzygy selection byte mismatch")
    if not np.array_equal(stored_p3, np.asarray(full_p3[columns])):
        raise AssertionError("r64 P3 selection byte mismatch")
    component_ranks = [rank_fflas(stored_p3[:, component]) for component in range(6)]
    total_rank = rank_fflas(stored_p3.reshape(64, -1))
    if component_ranks != [64] * 6 or total_rank != 64:
        raise AssertionError("r64 P3 rank replay failed")

    relation = np.load(RELATION, allow_pickle=False)
    seeds = relation["seed_F3"].astype(np.uint8)
    offsets = relation["off3"].astype(np.int32)
    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    product_map = multiplication_map(q3, q4)
    b0 = seeds[:, int(offsets[0]) : int(offsets[1])]
    rebuilt_p4 = recompute_p4(stored_syzygies, b0, product_map, len(q4))
    if not np.array_equal(rebuilt_p4, stored_p4):
        raise AssertionError("r64 P4 contraction byte mismatch")

    if sha256_file(R64) != metadata["jobs"]["r64"]["packet_sha256"]:
        raise AssertionError("r64 packet hash mismatch")
    if sha256_file(R43) != metadata["jobs"]["r43"]["packet_sha256"]:
        raise AssertionError("r43 packet hash mismatch")
    source_hashes = metadata["r64_selection"]["source_hashes"]
    for key, path in (
        ("full_basis", FULL_BASIS),
        ("full_p3", FULL_P3),
        ("relation_matrix", RELATION),
        ("r43_source", R43),
    ):
        if sha256_file(path) != source_hashes[key]:
            raise AssertionError(f"r64 source hash mismatch: {key}")

    output = {
        "status": "PASS_AUGMENTED_MODULE_JOBS_REPLAY",
        "r64_rows": 64,
        "r64_p3_component_ranks": component_ranks,
        "r64_p3_total_rank": total_rank,
        "r64_p4_recomputed_byte_equal": True,
        "r43_script_sha256": metadata["jobs"]["r43"]["script_sha256"],
        "r64_script_sha256": metadata["jobs"]["r64"]["script_sha256"],
        "jobs_unlaunched": True,
        "exact_implication_checked": True,
    }
    result = HERE / "verify_augmented_module_jobs_result.json"
    result.write_text(json.dumps(output, indent=2, sort_keys=True) + "\n")
    print(json.dumps(output, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
