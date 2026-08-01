#!/usr/bin/env python3
"""Combine saved C3 second-based and second-normal gate blocks."""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

import probe_c3_constant_gate as c3


HERE = Path(__file__).resolve().parent


def first_paths(degree: int, prime: int):
    paths = [HERE / f"degree_{degree}/c3_first_normal_exp0_p{prime}.npz"]
    if degree == 31:
        paths.append(HERE / f"degree_{degree}/c3_first_normal_exp2_p{prime}.npz")
    else:
        paths.extend([
            HERE / f"degree_{degree}/c3_first_normal_exp2_dir0_p{prime}.npz",
            HERE / f"degree_{degree}/c3_first_normal_exp2_dir1_p{prime}.npz",
        ])
    return paths


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    for degree, dimension in ((31, 198), (35, 361)):
        with np.load(
            HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            line_values = frozen["basis_values"].astype(np.int64).reshape(
                -1, dimension
            )
        first_values = []
        for path in first_paths(degree, prime):
            with np.load(path, allow_pickle=False) as frozen:
                first_values.append(
                    frozen["derivative_values"].astype(np.int64).reshape(-1, dimension)
                )
        matrices = [np.concatenate([line_values, *first_values], axis=0)]
        for exponent in (0, 2):
            with np.load(
                HERE / f"degree_{degree}/c3_second_normal_exp{exponent}_p{prime}.npz",
                allow_pickle=False,
            ) as frozen:
                matrices.append(frozen["extra_gate_matrix"].astype(np.int64))
        ranks = [c3.rank_mod(np.concatenate(matrices[:end]), prime)
                 for end in range(1, len(matrices) + 1)]
        combined = np.concatenate(matrices, axis=0) % prime
        kernel = c3.nullspace_mod(combined, prime).T
        surviving_exponent = 0 if degree == 31 else 2
        with np.load(
            HERE / f"degree_{degree}/c3_second_normal_exp{surviving_exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            surviving_values = frozen["second_normal_values"].astype(np.int64)
            root = frozen["target_root"].astype(np.int64)
        restricted = np.einsum("pjn,nk->pjk", surviving_values, kernel) % prime
        pivot = int(np.flatnonzero(root)[0])
        scalar = pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
        require_proportional = all(np.array_equal(
            restricted[:, output, :] % prime,
            root[output] * scalar % prime,
        ) for output in range(5))
        assert require_proportional
        scalar_rank = c3.rank_mod(scalar, prime)
        print(
            f"p={prime} d={degree}: cumulativeRanks={ranks} "
            f"finalKernel={dimension-ranks[-1]} scalarRank={scalar_rank} "
            f"thirdBased={dimension-ranks[-1]-scalar_rank}"
        )


if __name__ == "__main__":
    main()
