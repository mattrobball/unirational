#!/usr/bin/env python3
"""Combine degree-35 pure fourth-normal blocks."""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

import probe_c3_constant_gate as c3
import probe_c3_fourth_normal_gate as fourth


HERE = Path(__file__).resolve().parent
DIMENSION = 361


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    lower = fourth.fifth_based_matrix(prime)
    gates = []
    values = []
    roots = []
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_35/c3_fourth_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            gates.append(frozen["extra_gate_matrix"].astype(np.int64))
            values.append(frozen["fourth_normal_values"].astype(np.int64))
            roots.append(frozen["target_root"].astype(np.int64))
    cumulative = [
        c3.rank_mod(np.concatenate([lower, *gates[:end]]), prime)
        for end in (1, 2)
    ]
    combined = np.concatenate([lower, *gates], axis=0) % prime
    kernel = c3.nullspace_mod(combined, prime).T
    root = roots[0]
    restricted = np.einsum("pjn,nk->pjk", values[0], kernel) % prime
    pivot = int(np.flatnonzero(root)[0])
    scalar = pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
    scalar_rank = c3.rank_mod(scalar, prime)
    pure_zero = np.concatenate([
        lower, values[0].reshape(-1, DIMENSION), values[1].reshape(-1, DIMENSION)
    ]) % prime
    pure_zero_rank = c3.rank_mod(pure_zero, prime)
    assert pure_zero_rank == cumulative[-1] + scalar_rank
    print(
        f"p={prime}: cumulative={cumulative} gateKernel={DIMENSION-cumulative[-1]} "
        f"scalarRank={scalar_rank} sixthBased={DIMENSION-pure_zero_rank}"
    )


if __name__ == "__main__":
    main()
