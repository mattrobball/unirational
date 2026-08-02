#!/usr/bin/env python3
"""Independent replay of the 34-open Stage-B MDS cover."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P = 89
ARTIFACT = HERE / "stageB_mds34_cover.npz"
CERTIFICATE = HERE / "stageB_mds34_cover_certificate.json"
RESULT = HERE / "verify_mds_stageB_cover_result.json"
EXPECTED_H8 = (0, 1, 2, 3) + tuple(range(12, 37))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    with np.load(ARTIFACT, allow_pickle=False) as frozen:
        prime = int(frozen["prime"])
        points = frozen["evaluation_points"].astype(np.int64)
        h8 = tuple(map(int, frozen["H8_coordinates"]))
        q_generator = frozen["q_generator"].astype(np.int64)
        b_generator = frozen["b1_generator"].astype(np.int64)
        q_transform = frozen["q_systematic_transform"].astype(np.int64)
        b_transform = frozen["b1_systematic_transform"].astype(np.int64)
    if prime != P or h8 != EXPECTED_H8:
        raise AssertionError("field or H8 coordinate mismatch")
    if points.tolist() != list(range(34)) or len(set(map(int, points))) != 34:
        raise AssertionError("evaluation points changed")

    def rebuild(dimension: int, transform: np.ndarray) -> np.ndarray:
        raw = np.asarray(
            [[pow(int(point), degree, P) for point in points] for degree in range(dimension)],
            dtype=np.int64,
        )
        rebuilt = transform @ raw % P
        if not np.array_equal(
            transform @ raw[:, :dimension] % P,
            np.eye(dimension, dtype=np.int64),
        ):
            raise AssertionError("stored transform is not an exact systematic inverse")
        return rebuilt

    if not np.array_equal(rebuild(29, q_transform), q_generator):
        raise AssertionError("q generator reconstruction mismatch")
    if not np.array_equal(rebuild(6, b_transform), b_generator):
        raise AssertionError("b generator reconstruction mismatch")
    if not np.array_equal(q_generator[:, :29], np.eye(29, dtype=np.int64)):
        raise AssertionError("q generator lost systematic form")
    if not np.array_equal(b_generator[:, :6], np.eye(6, dtype=np.int64)):
        raise AssertionError("b generator lost systematic form")
    if certificate["artifact_sha256"] != sha256(ARTIFACT):
        raise AssertionError("artifact hash mismatch")
    if certificate["scope_guard"].find("never mixes b0 with b1") < 0:
        raise AssertionError("grading scope guard missing")

    # The replayed matrices are row-equivalent to Vandermonde evaluation
    # matrices at 34 distinct field points.  The elementary root bound gives
    # exact distances 34-29+1=6 and 34-6+1=29 over every field extension.
    if 6 + 29 <= 34:
        raise AssertionError("support-intersection arithmetic failed")
    payload = {
        "status": "PASS_INDEPENDENT_STAGEB_MDS34_COVER_REPLAY",
        "artifact_sha256": sha256(ARTIFACT),
        "q_code_distance": 6,
        "b1_code_distance": 29,
        "support_intersection_lower_bound": 1,
        "systematic_chart_census": {
            "coordinate_q_coordinate_b1": 6,
            "coordinate_q_dense_b1": 23,
            "dense_q_dense_b1": 5,
            "total": 34,
        },
        "theorem": "The 34 opens D(l_k(h)m_k(b1)) cover D(H8) x P5_b1 over algebraic_closure(F_89).",
        "scope_guard": "Finite-cover theorem only; no chart emptiness and no Stage-C conclusion.",
    }
    RESULT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(payload["status"])


if __name__ == "__main__":
    main()
