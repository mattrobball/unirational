#!/usr/bin/env python3
"""Produce the exact optimal Reed--Solomon paired cover for Stage B on D(H8)."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P = 89
N = 34
H8_COORDINATES = [0, 1, 2, 3, *range(12, 37)]
PACKET = HERE / "stageB_H8_mds_cover.npz"
MANIFEST = HERE / "stageB_H8_mds_cover.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def array_sha256(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def immutable(path: Path, data: bytes) -> None:
    if path.exists():
        if path.read_bytes() != data:
            raise RuntimeError(f"refusing to overwrite mismatching artifact: {path}")
        return
    path.write_bytes(data)


def vandermonde(nodes: np.ndarray, dimension: int) -> np.ndarray:
    out = np.empty((len(nodes), dimension), dtype=np.uint8)
    for row, node_u8 in enumerate(nodes):
        node = int(node_u8)
        value = 1
        for column in range(dimension):
            out[row, column] = value
            value = value * node % P
    return out


def main() -> None:
    nodes = np.arange(N, dtype=np.uint8)
    q_generator = vandermonde(nodes, 29)
    b_generator = vandermonde(nodes, 6)
    h8 = np.asarray(H8_COORDINATES, dtype=np.int16)
    if len(set(H8_COORDINATES)) != 29:
        raise AssertionError("H8 coordinate list is not a 29-set")
    if len(set(map(int, nodes))) != N:
        raise AssertionError("evaluation nodes are not distinct")

    # np.savez_compressed is used only for a tiny exact data packet.  Refuse
    # to replace an existing packet; the independent verifier reconstructs it.
    if not PACKET.exists():
        np.savez_compressed(
            PACKET,
            prime=np.int32(P),
            nodes=nodes,
            h8_coordinates=h8,
            q_generator=q_generator,
            b_generator=b_generator,
        )
    else:
        with np.load(PACKET, allow_pickle=False) as frozen:
            expected = {
                "prime": np.asarray(P, dtype=np.int32),
                "nodes": nodes,
                "h8_coordinates": h8,
                "q_generator": q_generator,
                "b_generator": b_generator,
            }
            for key, value in expected.items():
                if not np.array_equal(frozen[key], value):
                    raise RuntimeError(f"refusing mismatching packet: {key}")

    payload = {
        "status": "PASS_EXACT_STAGEB_H8_MDS_COVER_CONSTRUCTION",
        "prime": P,
        "field_scope": "algebraic closure of F_89",
        "closed_stratum": "L8=P<span(q4,...,q11)>",
        "open_complement": "D(H8), H8=(q0,q1,q2,q3,q12,...,q36)",
        "h8_coordinates": H8_COORDINATES,
        "nodes": list(map(int, nodes)),
        "q_code": {
            "parameters": [34, 29, 6],
            "linear_form": "ell_a(q)=sum_{j=0}^{28} a^j q_{H8[j]}",
            "generator_sha256": array_sha256(q_generator),
        },
        "b1_code": {
            "parameters": [34, 6, 29],
            "linear_form": "m_a(b1)=sum_{j=0}^{5} a^j b1_j",
            "generator_sha256": array_sha256(b_generator),
        },
        "cover": {
            "charts": 34,
            "chart_a": "D(ell_a) intersect D(m_a)",
            "normalization": "ell_a(q)=1 and m_a(b1)=1",
            "q_support_lower_bound": 6,
            "b1_support_lower_bound": 29,
            "intersection_reason": "6+29=35>34",
            "affine_variables_per_direct_chart": 62,
            "eliminated_coordinates": ["q0", "b1_0"],
        },
        "optimality_scope": (
            "34 is minimal for a paired linear-code cover with dimensions "
            "29 and 6: Singleton gives support bounds at most n-28 and n-5, "
            "whose guaranteed intersection requires n>=34."
        ),
        "closed_L8_stageB_certificate": {
            "file": "../stageb_strata/closed_L_degree6_certificate.json",
            "sha256": "89ec13bb2672a8b26e5e3e5beed74dfa21bf4374c4d6d57721b0d475f5f9a41a",
        },
        "packet": {
            "file": PACKET.name,
            "sha256": sha256(PACKET),
        },
        "limitation": (
            "This is an exact cover reduction only. No one of the 34 direct "
            "all-690 affine systems has been decided, and no tensor symmetry "
            "identifying the chart coefficient systems is asserted."
        ),
    }
    immutable(
        MANIFEST,
        (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode(),
    )
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()

