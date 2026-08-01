#!/usr/bin/env python3
"""Restrict p=463 landing circuits to the true C3 third-based branch."""

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


def first_paths(degree: int):
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
        "schema": "cov-m1-c3-third-based-reduced-landing-v1",
        "prime": PRIME,
        "scope": (
            "complete p=463 landing circuits after vanishing of the C3 line, "
            "first normal jet, and all pure and mixed second normal jets"
        ),
        "degrees": {},
    }
    for degree, dimension in DIMENSIONS.items():
        c3_path = HERE / f"degree_{degree}/c3_constant_gate_p{PRIME}.npz"
        with np.load(c3_path, allow_pickle=False) as frozen:
            matrices = [frozen["basis_values"].astype(np.int64).reshape(-1, dimension)]
        input_records = [{"payload": str(c3_path.relative_to(HERE)),
                          "payload_sha256": sha256(c3_path)}]
        for path in first_paths(degree):
            with np.load(path, allow_pickle=False) as frozen:
                matrices.append(
                    frozen["derivative_values"].astype(np.int64).reshape(-1, dimension)
                )
            input_records.append({"payload": str(path.relative_to(HERE)),
                                  "payload_sha256": sha256(path)})
        for exponent in (0, 2):
            path = HERE / f"degree_{degree}/c3_second_normal_exp{exponent}_p{PRIME}.npz"
            with np.load(path, allow_pickle=False) as frozen:
                matrices.append(
                    frozen["second_normal_values"].astype(np.int64).reshape(-1, dimension)
                )
            input_records.append({"payload": str(path.relative_to(HERE)),
                                  "payload_sha256": sha256(path)})
        mixed_path = HERE / f"degree_{degree}/c3_second_mixed_p{PRIME}.npz"
        with np.load(mixed_path, allow_pickle=False) as frozen:
            matrices.append(
                frozen["mixed_second_values"].astype(np.int64).reshape(-1, dimension)
            )
        input_records.append({"payload": str(mixed_path.relative_to(HERE)),
                              "payload_sha256": sha256(mixed_path)})
        combined = np.concatenate(matrices, axis=0) % PRIME
        pivots, free, kernel = linear.rref_kernel(combined, PRIME)
        expected = {31: 65, 35: 184}[degree]
        assert len(free) == expected
        landing_path = HERE / f"degree_{degree}/landing_circuits_p{PRIME}.npz"
        with np.load(landing_path, allow_pickle=False) as frozen:
            points = frozen["fixed_source_points"].copy()
            values = frozen["basis_values"].astype(np.uint16)
        reduced = linear.restrict_forms(
            values.reshape(-1, dimension), pivots, free, kernel, PRIME
        ).reshape(len(points), 5, expected)
        assert linear.rank_mod(
            reduced.reshape(-1, expected)[:2 * expected], PRIME
        ) == expected
        payload_path = (
            HERE / f"degree_{degree}/c3_third_based_reduced_landing_p{PRIME}.npz"
        )
        np.savez_compressed(
            payload_path,
            source_points=points,
            reduced_basis_values=reduced,
            third_based_kernel_basis=kernel.astype(np.uint16),
            third_based_pivot_columns=pivots.astype(np.uint16),
            third_based_free_columns=free.astype(np.uint16),
        )
        record = {
            "prime": PRIME,
            "original_parameter_dimension": dimension,
            "third_based_gate_rank": dimension - expected,
            "third_based_parameter_dimension": expected,
            "complete_equation_count": len(points),
            "gate_inputs": input_records,
            "landing_payload": str(landing_path.relative_to(HERE)),
            "landing_payload_sha256": sha256(landing_path),
            "payload": str(payload_path.relative_to(HERE)),
            "payload_sha256": sha256(payload_path),
            "decision_status": "complete reduced equations; saturation open",
        }
        metadata_path = (
            HERE / f"degree_{degree}/c3_third_based_reduced_landing_p{PRIME}.json"
        )
        metadata_path.write_text(json.dumps(record, indent=2, sort_keys=True) + "\n")
        aggregate["degrees"][str(degree)] = {
            "metadata": str(metadata_path.relative_to(HERE)),
            "metadata_sha256": sha256(metadata_path),
            **record,
        }
        print(f"d={degree}: complete cubics on third-based dimension {expected}")
    output = HERE / "c3_third_based_reduced_landing.json"
    output.write_text(json.dumps(aggregate, indent=2, sort_keys=True) + "\n")
    print("COV_M1_C3_THIRD_BASED_REDUCED_LANDING_OK")


if __name__ == "__main__":
    main()
