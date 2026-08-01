#!/usr/bin/env python3
"""Compute the linear tangent gate on the nonbased C3 branch."""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

import probe_c3_constant_gate as c3


HERE = Path(__file__).resolve().parent


def derivative_paths(degree: int, prime: int):
    paths = [HERE / f"degree_{degree}/c3_first_normal_exp0_p{prime}.npz"]
    if degree == 31:
        paths.append(HERE / f"degree_{degree}/c3_first_normal_exp2_p{prime}.npz")
    else:
        paths.extend([
            HERE / f"degree_{degree}/c3_first_normal_exp2_dir0_p{prime}.npz",
            HERE / f"degree_{degree}/c3_first_normal_exp2_dir1_p{prime}.npz",
        ])
    return paths


def klein_gradient(root: np.ndarray, prime: int):
    return np.asarray([
        2 * int(root[index]) * int(root[(index + 1) % 5])
        + int(root[(index - 1) % 5]) ** 2
        for index in range(5)
    ], dtype=np.int64) % prime


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    for degree, dimension in ((31, 198), (35, 361)):
        gate_path = HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz"
        with np.load(gate_path, allow_pickle=False) as frozen:
            constant_gate = frozen["gate_matrix"].astype(np.int64)
            line_values = frozen["basis_values"].astype(np.int64)
            root = frozen["unique_c6_root"].astype(np.int64)
        gradient = klein_gradient(root, prime)
        tangent_rows = []
        for path in derivative_paths(degree, prime):
            with np.load(path, allow_pickle=False) as frozen:
                derivative = frozen["derivative_values"].astype(np.int64)
            tangent_rows.append(
                np.einsum("i,pik->pk", gradient, derivative) % prime
            )
        tangent_gate = np.concatenate(tangent_rows, axis=0) % prime
        combined = np.concatenate([constant_gate, tangent_gate], axis=0) % prime
        base_rank = c3.rank_mod(constant_gate, prime)
        combined_rank = c3.rank_mod(combined, prime)
        pivots = c3.nullspace_mod(combined, prime)
        kernel = pivots.T
        root_pivot = int(np.flatnonzero(root)[0])
        scalar = (
            pow(int(root[root_pivot]), -1, prime)
            * np.einsum("pjn,nk->pjk", line_values, kernel)[:, root_pivot, :]
        ) % prime
        scalar_rank = c3.rank_mod(scalar, prime)
        print(
            f"p={prime} d={degree}: constantRank={base_rank} "
            f"tangentExtra={combined_rank-base_rank} combined={combined_rank} "
            f"kernel={dimension-combined_rank} scalarRank={scalar_rank}",
            flush=True,
        )


if __name__ == "__main__":
    main()
