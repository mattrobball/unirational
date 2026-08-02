#!/usr/bin/env python3
"""Combine the pure third-normal C3 blocks and their scalar-zero branch."""

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


def lower_matrix(degree: int, prime: int, dimension: int):
    arrays = []
    with np.load(
        HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        arrays.append(frozen["basis_values"].astype(np.int64).reshape(-1, dimension))
    for path in first_paths(degree, prime):
        with np.load(path, allow_pickle=False) as frozen:
            arrays.append(
                frozen["derivative_values"].astype(np.int64).reshape(-1, dimension)
            )
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_{degree}/c3_second_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            arrays.append(
                frozen["second_normal_values"].astype(np.int64).reshape(-1, dimension)
            )
    with np.load(
        HERE / f"degree_{degree}/c3_second_mixed_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        arrays.append(
            frozen["mixed_second_values"].astype(np.int64).reshape(-1, dimension)
        )
    return np.concatenate(arrays, axis=0) % prime


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    for degree, dimension in ((31, 198), (35, 361)):
        lower = lower_matrix(degree, prime, dimension)
        gates = []
        values = []
        roots = []
        for exponent in (0, 2):
            with np.load(
                HERE / f"degree_{degree}/c3_third_normal_exp{exponent}_p{prime}.npz",
                allow_pickle=False,
            ) as frozen:
                gates.append(frozen["extra_gate_matrix"].astype(np.int64))
                values.append(frozen["third_normal_values"].astype(np.int64))
                roots.append(frozen["target_root"].astype(np.int64))
        cumulative = [
            c3.rank_mod(np.concatenate([lower, *gates[:end]]), prime)
            for end in (1, 2)
        ]
        combined = np.concatenate([lower, *gates], axis=0) % prime
        kernel = c3.nullspace_mod(combined, prime).T
        scalar_blocks = []
        for value, root in zip(values, roots):
            restricted = np.einsum("pjn,nk->pjk", value, kernel) % prime
            pivot = int(np.flatnonzero(root)[0])
            scalar = pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
            assert all(np.array_equal(
                restricted[:, output, :] % prime, root[output] * scalar % prime
            ) for output in range(5))
            scalar_blocks.append(scalar)
        scalar_rank = c3.rank_mod(np.concatenate(scalar_blocks), prime)
        pure_zero = np.concatenate([
            lower, *[value.reshape(-1, dimension) for value in values]
        ], axis=0) % prime
        pure_zero_rank = c3.rank_mod(pure_zero, prime)
        assert pure_zero_rank == cumulative[-1] + scalar_rank
        print(
            f"p={prime} d={degree}: cumulative={cumulative} "
            f"gateKernel={dimension-cumulative[-1]} scalarRank={scalar_rank} "
            f"fourthBased={dimension-pure_zero_rank}"
        )


if __name__ == "__main__":
    main()
