#!/usr/bin/env python3
"""Independently reconstruct and verify the 34-open Stage-B cover."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P = 89
PACKET = HERE / "stageB_H8_mds_cover.npz"
MANIFEST = HERE / "stageB_H8_mds_cover.json"
RESULT = HERE / "verify_mds_cover_result.json"
CLOSED = HERE.parent / "stageb_strata" / "closed_L_degree6_certificate.json"
H8 = [0, 1, 2, 3, *range(12, 37)]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def vandermonde(nodes: np.ndarray, dimension: int) -> np.ndarray:
    matrix = np.empty((len(nodes), dimension), dtype=np.uint8)
    for i, a_u8 in enumerate(nodes):
        a = int(a_u8)
        value = 1
        for j in range(dimension):
            matrix[i, j] = value
            value = value * a % P
    return matrix


def main() -> None:
    manifest = json.loads(MANIFEST.read_text())
    if manifest["packet"]["sha256"] != sha256(PACKET):
        raise AssertionError("packet hash mismatch")
    if manifest["closed_L8_stageB_certificate"]["sha256"] != sha256(CLOSED):
        raise AssertionError("closed-L8 Stage-B certificate hash mismatch")
    nodes = np.arange(34, dtype=np.uint8)
    expected_q = vandermonde(nodes, 29)
    expected_b = vandermonde(nodes, 6)
    with np.load(PACKET, allow_pickle=False) as frozen:
        checks = {
            "prime": np.asarray(P, dtype=np.int32),
            "nodes": nodes,
            "h8_coordinates": np.asarray(H8, dtype=np.int16),
            "q_generator": expected_q,
            "b_generator": expected_b,
        }
        for key, expected in checks.items():
            if not np.array_equal(frozen[key], expected):
                raise AssertionError(f"packet reconstruction mismatch: {key}")

    # Reed--Solomon proof over every extension of F_89: the 34 nodes are
    # distinct, so a nonzero polynomial of degree <=28 (respectively <=5)
    # vanishes at at most 28 (respectively 5) nodes.
    differences = [
        (int(nodes[j]) - int(nodes[i])) % P
        for i in range(34)
        for j in range(i + 1, 34)
    ]
    if len(differences) != 561 or any(value == 0 for value in differences):
        raise AssertionError("evaluation-node distinctness failed")
    q_support = 34 - 28
    b_support = 34 - 5
    if q_support + b_support <= 34:
        raise AssertionError("support intersection inequality failed")

    # Minimality inside the paired linear-code strategy follows directly from
    # Singleton: d_q<=n-29+1 and d_b<=n-6+1.  For n=33 the sum is at most 33.
    singleton_sum_n33 = (33 - 29 + 1) + (33 - 6 + 1)
    if singleton_sum_n33 != 33:
        raise AssertionError("Singleton arithmetic mismatch")

    payload = {
        "status": "PASS_INDEPENDENT_STAGEB_H8_MDS_COVER",
        "prime": P,
        "field_scope": "algebraic closure of F_89",
        "nodes_distinct": True,
        "pairwise_differences_checked": len(differences),
        "q_code": [34, 29, 6],
        "b1_code": [34, 6, 29],
        "support_sum": q_support + b_support,
        "charts": 34,
        "closed_L8_certificate_bound": True,
        "minimal_among_paired_linear_code_covers": True,
        "stageB_decided": False,
        "stageC_decided_by_this_packet": False,
        "scope": (
            "Exact finite-cover reduction only; each all-690 affine chart "
            "still requires a unit-ideal certificate."
        ),
    }
    RESULT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()

