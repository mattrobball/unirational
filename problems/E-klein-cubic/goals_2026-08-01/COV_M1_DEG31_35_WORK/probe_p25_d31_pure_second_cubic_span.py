#!/usr/bin/env python3
"""Certify emptiness of the deepest degree-31 P25 multiplier branch."""

from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path

import numpy as np

from probe_c3_constant_gate import nullspace_mod, rank_mod
from produce_p25_dependency_localization import hierarchy


HERE = Path(__file__).resolve().parent
PRIME = 463


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def cubic_coefficients(values: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    monomials = np.asarray(
        list(itertools.combinations_with_replacement(range(3), 3)),
        dtype=np.int64,
    )
    index = {tuple(map(int, item)): position
             for position, item in enumerate(monomials)}
    matrix = np.zeros((len(values), len(monomials)), dtype=np.int64)
    for node, linear in enumerate(values.astype(np.int64)):
        for target in range(5):
            successor = (target + 1) % 5
            for left in range(3):
                for right in range(3):
                    factor = linear[target, left] * linear[target, right] % PRIME
                    if not factor:
                        continue
                    for last in range(3):
                        monomial = tuple(sorted((left, right, last)))
                        matrix[node, index[monomial]] += (
                            factor * linear[successor, last]
                        )
        matrix[node] %= PRIME
    return monomials, matrix


def independent_rows(matrix: np.ndarray) -> np.ndarray:
    selected = []
    current = np.empty((0, matrix.shape[1]), dtype=np.int64)
    for index, row in enumerate(matrix):
        candidate = np.vstack([current, row])
        if rank_mod(candidate, PRIME) > len(selected):
            selected.append(index)
            current = candidate
            if len(selected) == matrix.shape[1]:
                break
    assert len(selected) == matrix.shape[1]
    return np.asarray(selected, dtype=np.int64)


def main() -> None:
    embedding_path = HERE / "degree_31/p25_multiplier_embedding_p463.npz"
    with np.load(embedding_path, allow_pickle=False) as frozen:
        embedding = frozen["multiplier_embedding"].astype(np.int64) % PRIME
    gates = dict(hierarchy(31, 198, PRIME))
    allowed = gates["pure_second_allowed"] @ embedding % PRIME
    kernel = nullspace_mod(allowed, PRIME).T
    assert kernel.shape == (59, 3)
    target_kernel = embedding @ kernel % PRIME
    scalar_zero = gates["pure_second_scalar_zero"] @ target_kernel % PRIME
    assert rank_mod(scalar_zero, PRIME) == 3

    landing_path = HERE / "degree_31/landing_circuits_p463.npz"
    with np.load(landing_path, allow_pickle=False) as frozen:
        old_values = frozen["basis_values"].astype(np.int64)
    reduced = np.einsum("pjn,nk->pjk", old_values, target_kernel) % PRIME
    monomials, coefficients = cubic_coefficients(reduced)
    rows = independent_rows(coefficients)
    assert len(rows) == 10 and rank_mod(coefficients[rows], PRIME) == 10

    payload_path = HERE / "degree_31/p25_pure_second_cubic_span_p463.npz"
    np.savez_compressed(
        payload_path,
        degree25_preimage_kernel=kernel.astype(np.uint16),
        target_kernel_basis=target_kernel.astype(np.uint16),
        scalar_zero_restriction=scalar_zero.astype(np.uint16),
        reduced_basis_values=reduced.astype(np.uint16),
        cubic_monomials=monomials.astype(np.uint16),
        cubic_coefficient_matrix=coefficients.astype(np.uint16),
        fixed_minor_rows=rows.astype(np.uint16),
    )
    output = HERE / "p25_d31_pure_second_cubic_span.json"
    output.write_text(json.dumps({
        "schema": "cov-m1-p25-d31-pure-second-span-v1",
        "prime": PRIME,
        "degree25_input_dimension": 59,
        "projective_gate_vector_dimension": 3,
        "pure_second_scalar_zero_rank": 3,
        "complete_landing_equation_count": len(reduced),
        "cubic_monomial_count": 10,
        "cubic_span_rank": 10,
        "embedding_payload": str(embedding_path.relative_to(HERE)),
        "embedding_payload_sha256": sha256(embedding_path),
        "landing_payload": str(landing_path.relative_to(HERE)),
        "landing_payload_sha256": sha256(landing_path),
        "payload": str(payload_path.relative_to(HERE)),
        "payload_sha256": sha256(payload_path),
        "conclusion": (
            "the scalar-zero intersection is only the affine origin and the "
            "complete landing cubics span all cubics on the remaining P2; "
            "hence the degree-31 f6(K1_25) pure-second branch is projectively "
            "empty over F_463 and in characteristic zero by proper specialization"
        ),
        "scope": (
            "fixed-circuit degree-25 multiplier image inside the degree-31 "
            "pure-second allowed C3 Taylor gate; earlier nonbased branches and "
            "P25.2 remain undecided"
        ),
    }, indent=2, sort_keys=True) + "\n")
    print("P25_D31_PURE_SECOND_CUBIC_SPAN_10_OF_10")


if __name__ == "__main__":
    main()
