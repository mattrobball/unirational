#!/usr/bin/env python3
"""Extend the selected r43 Stage-B packet by its exact scalar P4 block."""

from __future__ import annotations

import json
from pathlib import Path
import time

import numpy as np

from produce_full_basis import NQ, P, RELATION, sha256, weak_compositions


HERE = Path(__file__).resolve().parent
STAGEB = HERE / "support_balanced_r43_stageB.npz"
OUTPUT = HERE / "support_balanced_r43_stageBC.npz"


def multiplication_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: index for index, monomial in enumerate(target)}
    answer = np.empty((NQ, len(source)), dtype=np.int32)
    for variable in range(NQ):
        for source_index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            answer[variable, source_index] = target_index[tuple(exponent)]
    return answer


def contract_selected_p4(
    syzygies: np.ndarray, block: np.ndarray, product_map: np.ndarray, target: int
) -> np.ndarray:
    """Batch the 43 contractions by the linear q index."""
    output = np.zeros((len(syzygies), target), dtype=np.uint8)
    block_double = np.asarray(block, dtype=np.float64)
    for variable in range(NQ):
        product = (
            np.ascontiguousarray(syzygies[:, :, variable], dtype=np.float64)
            @ block_double
        )
        np.remainder(product, float(P), out=product)
        addition = product.astype(np.uint8)
        indices = product_map[variable]
        updated = output[:, indices].astype(np.uint16)
        updated += addition
        np.remainder(updated, P, out=updated)
        output[:, indices] = updated.astype(np.uint8)
    return output


def main() -> None:
    if not STAGEB.is_file():
        raise FileNotFoundError(STAGEB)
    with np.load(STAGEB, allow_pickle=False) as frozen:
        p3 = frozen["p3"].astype(np.uint8)
        syzygies = frozen["syzygies"].astype(np.uint8)
        columns = frozen["full_basis_columns"].astype(np.int32)
        p3_term_counts = frozen["p3_term_counts"].astype(np.int32)
        syzygy_nnz = frozen["syzygy_nnz"].astype(np.int32)
        coordinate_ranks = frozen["coordinate_ranks"].astype(np.int8)
        q_support_masks = frozen["q_support_masks"].astype(np.uint64)
        if int(frozen["prime"]) != P:
            raise AssertionError("Stage-B packet prime mismatch")
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime mismatch")
    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    product_map = multiplication_map(q3, q4)
    b0_block = seeds[:, int(offsets[0]) : int(offsets[1])]
    if b0_block.shape != (690, len(q3)):
        raise AssertionError(f"unexpected b0 block shape {b0_block.shape}")
    started = time.monotonic()
    p4 = contract_selected_p4(syzygies, b0_block, product_map, len(q4))
    if p4.shape != (43, len(q4)) or np.any(~np.any(p4 != 0, axis=1)):
        raise AssertionError("invalid selected P4 contraction")
    p4_term_counts = np.count_nonzero(p4, axis=1).astype(np.int32)
    np.savez_compressed(
        OUTPUT,
        p4=p4,
        p3=p3,
        syzygies=syzygies,
        full_basis_columns=columns,
        p4_term_counts=p4_term_counts,
        p3_term_counts=p3_term_counts,
        syzygy_nnz=syzygy_nnz,
        coordinate_ranks=coordinate_ranks,
        q_support_masks=q_support_masks,
        prime=np.int32(P),
        stageb_packet_sha256=np.asarray(sha256(STAGEB)),
        relation_matrix_sha256=np.asarray(sha256(RELATION)),
    )
    payload = {
        "status": "PASS_SELECTED_P4_CONTRACTION",
        "prime": P,
        "rows": 43,
        "stageb_source": STAGEB.name,
        "stageb_source_sha256": sha256(STAGEB),
        "relation_matrix_sha256": sha256(RELATION),
        "p3_shape": list(p3.shape),
        "p3_terms": int(np.count_nonzero(p3)),
        "p4_shape": list(p4.shape),
        "p4_terms": int(np.count_nonzero(p4)),
        "p4_term_counts": p4_term_counts.astype(int).tolist(),
        "artifact": OUTPUT.name,
        "artifact_sha256": sha256(OUTPUT),
        "elapsed_seconds": round(time.monotonic() - started, 6),
        "scope": (
            "Exact selected contractions P4(q)b0+P3(q)b1. These are necessary "
            "equations; only completed exact Stage-B/Stage-C jobs can decide strata."
        ),
    }
    metadata = HERE / "support_balanced_r43_stageBC.json"
    metadata.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()
