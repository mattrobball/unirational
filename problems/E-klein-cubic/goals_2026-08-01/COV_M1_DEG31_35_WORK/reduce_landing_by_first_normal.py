#!/usr/bin/env python3
"""Restrict p=463 landing circuits to the C3 first-normal based gate."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np

import reduce_landing_by_c3 as linear


HERE = Path(__file__).resolve().parent
PRIME = 463
DIMENSIONS = {31: 198, 35: 361}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def block_paths(degree: int):
    paths = [HERE / f"degree_{degree}/c3_first_normal_exp0_p{PRIME}.npz"]
    if degree == 31:
        paths.append(HERE / f"degree_{degree}/c3_first_normal_exp2_p{PRIME}.npz")
    else:
        paths.extend([
            HERE / f"degree_{degree}/c3_first_normal_exp2_dir0_p{PRIME}.npz",
            HERE / f"degree_{degree}/c3_first_normal_exp2_dir1_p{PRIME}.npz",
        ])
    return paths


def main() -> None:
    aggregate = {
        "schema": "cov-m1-c3-first-normal-reduced-landing-v1",
        "prime": PRIME,
        "scope": (
            "complete p=463 landing circuits on the C3-based first-normal "
            "necessary gate; residual branch saturations are open"
        ),
        "degrees": {},
    }
    for degree, dimension in DIMENSIONS.items():
        c3_path = HERE / f"degree_{degree}/c3_constant_gate_p{PRIME}.npz"
        with np.load(c3_path, allow_pickle=False) as frozen:
            based_gate = frozen["basis_values"].astype(np.int64).reshape(
                -1, dimension
            )
        matrices = [based_gate]
        paths = block_paths(degree)
        for path in paths:
            with np.load(path, allow_pickle=False) as frozen:
                matrices.append(frozen["extra_gate_matrix"].astype(np.int64))
        combined_gate = np.concatenate(matrices, axis=0) % PRIME
        pivots, free, kernel = linear.rref_kernel(combined_gate, PRIME)
        expected_dimension = {31: 147, 35: 300}[degree]
        assert len(free) == expected_dimension
        landing_path = HERE / f"degree_{degree}/landing_circuits_p{PRIME}.npz"
        with np.load(landing_path, allow_pickle=False) as frozen:
            points = frozen["fixed_source_points"].copy()
            values = frozen["basis_values"].astype(np.uint16)
        reduced = linear.restrict_forms(
            values.reshape(-1, dimension), pivots, free, kernel, PRIME
        ).reshape(len(points), 5, expected_dimension)
        del values
        assert linear.rank_mod(
            reduced.reshape(-1, expected_dimension)[:2 * expected_dimension], PRIME
        ) == expected_dimension

        # The only first-normal target block allowed to remain nonzero is the
        # fixed-root block: exponent 2 in d=31 and exponent 0 in d=35.
        scalar_path = paths[1] if degree == 31 else paths[0]
        with np.load(scalar_path, allow_pickle=False) as frozen:
            derivative = frozen["derivative_values"].astype(np.int64)
            root = frozen["target_root"].astype(np.int64)
        derivative_reduced = linear.restrict_forms(
            derivative.reshape(-1, dimension), pivots, free, kernel, PRIME
        ).reshape(derivative.shape[0], 5, expected_dimension)
        root_pivot = int(np.flatnonzero(root)[0])
        scalar_forms = (
            pow(int(root[root_pivot]), -1, PRIME)
            * derivative_reduced[:, root_pivot, :].astype(np.int64)
        ) % PRIME
        assert all(np.array_equal(
            derivative_reduced[:, output, :].astype(np.int64) % PRIME,
            root[output] * scalar_forms % PRIME,
        ) for output in range(5))
        scalar_rank = linear.rank_mod(scalar_forms, PRIME)
        scalar_pivots, scalar_free, second_based_kernel = linear.rref_kernel(
            scalar_forms, PRIME
        )
        assert len(scalar_free) == expected_dimension - scalar_rank
        payload_path = (
            HERE / f"degree_{degree}/c3_first_normal_reduced_landing_p{PRIME}.npz"
        )
        np.savez_compressed(
            payload_path,
            source_points=points,
            reduced_basis_values=reduced,
            first_normal_kernel_basis=kernel.astype(np.uint16),
            first_normal_pivot_columns=pivots.astype(np.uint16),
            first_normal_free_columns=free.astype(np.uint16),
            surviving_derivative_values=derivative_reduced,
            first_normal_scalar_forms=scalar_forms.astype(np.uint16),
            second_based_kernel_basis=second_based_kernel.astype(np.uint16),
            scalar_pivot_columns=scalar_pivots.astype(np.uint16),
            scalar_free_columns=scalar_free.astype(np.uint16),
        )
        record = {
            "prime": PRIME,
            "original_parameter_dimension": dimension,
            "combined_first_normal_gate_rank": dimension - expected_dimension,
            "first_normal_parameter_dimension": expected_dimension,
            "complete_equation_count": len(points),
            "first_normal_scalar_rank": scalar_rank,
            "second_based_dimension": expected_dimension - scalar_rank,
            "first_normal_nonbased_chart_count": scalar_rank,
            "landing_payload": str(landing_path.relative_to(HERE)),
            "landing_payload_sha256": sha256(landing_path),
            "c3_gate_payload": str(c3_path.relative_to(HERE)),
            "c3_gate_payload_sha256": sha256(c3_path),
            "first_normal_block_payloads": [
                {"payload": str(path.relative_to(HERE)), "payload_sha256": sha256(path)}
                for path in paths
            ],
            "payload": str(payload_path.relative_to(HERE)),
            "payload_sha256": sha256(payload_path),
            "decision_status": "complete reduced equations; saturation open",
        }
        metadata_path = (
            HERE / f"degree_{degree}/c3_first_normal_reduced_landing_p{PRIME}.json"
        )
        metadata_path.write_text(json.dumps(record, indent=2, sort_keys=True) + "\n")
        aggregate["degrees"][str(degree)] = {
            "metadata": str(metadata_path.relative_to(HERE)),
            "metadata_sha256": sha256(metadata_path),
            **record,
        }
        print(
            f"d={degree}: first-normal {expected_dimension}, "
            f"second-based {expected_dimension-scalar_rank}, "
            f"nonbased charts {scalar_rank}",
            flush=True,
        )
    output = HERE / "c3_first_normal_reduced_landing.json"
    output.write_text(json.dumps(aggregate, indent=2, sort_keys=True) + "\n")
    print("COV_M1_C3_FIRST_NORMAL_REDUCED_LANDING_OK")


if __name__ == "__main__":
    main()
