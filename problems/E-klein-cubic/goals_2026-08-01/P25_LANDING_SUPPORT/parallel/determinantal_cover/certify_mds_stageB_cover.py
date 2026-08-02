#!/usr/bin/env python3
"""Certify a 34-open MDS cover of the unresolved Stage-B complement.

Let h=(q0,q1,q2,q3,q12,...,q36), the 29 coordinates cutting out L8.
Systematic [34,29,6] and [34,6,29] Reed--Solomon codes give linear forms
l_k(h), m_k(b1).  Every nonzero l-codeword has at least six nonzero entries
and every nonzero m-codeword at least 29, so the two supports intersect in a
34-element universe.  Hence D(l_k m_k), k=0,...,33, covers
D(H8) x P^5_b1.

This is Stage B only.  Mixing b0 with b1 would violate the grading and is
explicitly excluded.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P = 89
N = 34
H8 = (0, 1, 2, 3) + tuple(range(12, 37))
ARTIFACT = HERE / "stageB_mds34_cover.npz"
CERTIFICATE = HERE / "stageB_mds34_cover_certificate.json"


def array_sha256(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def inverse_mod(matrix: np.ndarray) -> np.ndarray:
    size = matrix.shape[0]
    work = np.concatenate(
        [matrix.astype(np.int64) % P, np.eye(size, dtype=np.int64)], axis=1
    )
    for column in range(size):
        candidates = np.flatnonzero(work[column:, column])
        if not len(candidates):
            raise AssertionError("singular systematic block")
        pivot = column + int(candidates[0])
        work[[column, pivot]] = work[[pivot, column]]
        work[column] = work[column] * pow(int(work[column, column]), -1, P) % P
        factors = work[:, column].copy()
        factors[column] = 0
        work = (work - factors[:, None] * work[column]) % P
    return work[:, size:]


def systematic_rs(dimension: int, points: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    vandermonde = np.asarray(
        [[pow(int(point), degree, P) for point in points] for degree in range(dimension)],
        dtype=np.int64,
    )
    transform = inverse_mod(vandermonde[:, :dimension])
    generator = transform @ vandermonde % P
    if not np.array_equal(generator[:, :dimension], np.eye(dimension, dtype=np.int64)):
        raise AssertionError("systematic conversion failed")
    return generator.astype(np.uint8), transform.astype(np.uint8)


def main() -> None:
    points = np.arange(N, dtype=np.int16)
    if len(set(map(int, points))) != N or np.any(points >= P):
        raise AssertionError("evaluation points are not distinct in F_89")
    q_generator, q_transform = systematic_rs(29, points)
    b_generator, b_transform = systematic_rs(6, points)

    # The first 29 q forms and first six b forms are coordinate projections.
    if not np.array_equal(q_generator[:, :29], np.eye(29, dtype=np.uint8)):
        raise AssertionError("q code is not systematic")
    if not np.array_equal(b_generator[:, :6], np.eye(6, dtype=np.uint8)):
        raise AssertionError("b code is not systematic")

    np.savez_compressed(
        ARTIFACT,
        prime=np.int32(P),
        evaluation_points=points,
        H8_coordinates=np.asarray(H8, dtype=np.int16),
        q_generator=q_generator,
        b1_generator=b_generator,
        q_systematic_transform=q_transform,
        b1_systematic_transform=b_transform,
    )
    payload = {
        "status": "PASS_EXACT_STAGEB_MDS34_COVER",
        "prime": P,
        "length": N,
        "H8_coordinates": list(H8),
        "q_code": {
            "parameters": [34, 29, 6],
            "generator_shape": list(q_generator.shape),
            "generator_sha256": array_sha256(q_generator),
            "systematic_coordinate_forms": 29,
            "dense_forms": 5,
        },
        "b1_code": {
            "parameters": [34, 6, 29],
            "generator_shape": list(b_generator.shape),
            "generator_sha256": array_sha256(b_generator),
            "systematic_coordinate_forms": 6,
            "dense_forms": 28,
        },
        "cover_proof": {
            "q_support_lower_bound": 6,
            "b1_support_lower_bound": 29,
            "universe_size": 34,
            "intersection_lower_bound": 1,
            "reason": (
                "A nonzero polynomial of degree below k has at most k-1 roots. "
                "Thus the two Reed-Solomon codewords have supports of sizes at "
                "least 6 and 29; their supports intersect because 6+29>34."
            ),
            "opens": "D(l_k(h)*m_k(b1)), k=0,...,33",
            "covered_locus": "D(H8) x P^5_b1",
        },
        "artifact": ARTIFACT.name,
        "artifact_sha256": sha256(ARTIFACT),
        "scope_guard": (
            "This certifies only a finite Stage-B affine cover. It proves no "
            "chart empty. It does not cover Stage C and never mixes b0 with b1."
        ),
    }
    CERTIFICATE.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS_EXACT_STAGEB_MDS34_COVER")


if __name__ == "__main__":
    main()
