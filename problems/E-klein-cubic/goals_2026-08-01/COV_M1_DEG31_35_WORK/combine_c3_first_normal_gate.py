#!/usr/bin/env python3
"""Combine saved C3 based and first-normal gate blocks."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import numpy as np

import probe_c3_constant_gate as c3


HERE = Path(__file__).resolve().parent
PRIMES = {463: 15, 727: 46}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def block_paths(degree: int, prime: int):
    paths = [HERE / f"degree_{degree}/c3_first_normal_exp0_p{prime}.npz"]
    if degree == 31:
        paths.append(HERE / f"degree_{degree}/c3_first_normal_exp2_p{prime}.npz")
    else:
        paths.extend([
            HERE / f"degree_{degree}/c3_first_normal_exp2_dir0_p{prime}.npz",
            HERE / f"degree_{degree}/c3_first_normal_exp2_dir1_p{prime}.npz",
        ])
    return paths


def process_prime(prime: int, verbose: bool):
    c3.P = prime
    prime_record = {"prime": prime, "zeta11": PRIMES[prime], "degrees": {}}
    for degree in (31, 35):
        dimension = {31: 198, 35: 361}[degree]
        gate_path = HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz"
        with np.load(gate_path, allow_pickle=False) as frozen:
            based = frozen["basis_values"].astype(np.int64).reshape(-1, dimension)
        paths = block_paths(degree, prime)
        matrices = [based]
        block_records = []
        for path in paths:
            with np.load(path, allow_pickle=False) as frozen:
                matrix = frozen["extra_gate_matrix"].astype(np.int64)
                target_space = frozen["target_eigenspace"].astype(np.int64)
                target_root = frozen["target_root"].astype(np.int64)
                normal_directions = frozen["normal_directions"].astype(np.int64)
            matrices.append(matrix)
            block_records.append({
                "payload": str(path.relative_to(HERE)),
                "payload_sha256": sha256(path),
                "row_count": len(matrix),
                "normal_direction_count": len(normal_directions),
                "target_eigenspace_dimension": len(target_space),
                "target_kind": "zero" if not len(target_root) else "fixed-root",
            })
        ranks = []
        for end in range(1, len(matrices) + 1):
            ranks.append(c3.rank_mod(np.concatenate(matrices[:end]), prime))
        expected = {31: [21, 32, 51], 35: [25, 38, 61, 61]}[degree]
        assert ranks == expected
        if verbose:
            print(
                f"p={prime} d={degree}: cumulativeRanks={ranks} "
                f"finalKernel={dimension-ranks[-1]}"
            )
        prime_record["degrees"][str(degree)] = {
            "input_dimension": dimension,
            "based_restriction_rank": ranks[0],
            "cumulative_ranks": ranks,
            "combined_gate_rank": ranks[-1],
            "combined_kernel_dimension": dimension - ranks[-1],
            "c3_gate_payload": str(gate_path.relative_to(HERE)),
            "c3_gate_payload_sha256": sha256(gate_path),
            "blocks": block_records,
        }
    return prime_record


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    args = parser.parse_args()
    process_prime(args.prime, True)
    if all(path.is_file() for prime in PRIMES for degree in (31, 35)
           for path in block_paths(degree, prime)):
        result = {
            "schema": "cov-m1-c3-first-normal-gate-v1",
            "mathematical_gate": (
                "On the C3-based stratum p|_L=0, the first transverse Taylor "
                "coefficient Dp must land in the Klein cubic. Its C3 target "
                "eigenblock is either the non-Klein one-dimensional fixed "
                "space, forcing Dp=0, or a line meeting the Klein cubic in "
                "three reduced points, forcing projective constancy at the "
                "unique C6-fixed root. These are necessary linear equations."
            ),
            "scope": (
                "special-fibre necessary pre-elimination on the based branch; "
                "residual projective saturation is not decided"
            ),
            "prime_records": [process_prime(prime, False) for prime in PRIMES],
            "degrees": {
                "31": {"based_dimension": 177, "first_normal_dimension": 147},
                "35": {"based_dimension": 336, "first_normal_dimension": 300},
            },
            "decision_status": "necessary first-normal reduction proved; saturation open",
        }
        (HERE / "c3_first_normal_gate.json").write_text(
            json.dumps(result, indent=2, sort_keys=True) + "\n"
        )
        print("COV_M1_C3_FIRST_NORMAL_GATE_OK")


if __name__ == "__main__":
    main()
