#!/usr/bin/env python3
"""Tangent gate on the degree-35 mixed-third nonbased C3 branch."""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

import probe_c3_constant_gate as c3
import combine_c3_third_normal_gate as lower
from combine_c3_first_normal_nonbased_tangent_gate import klein_gradient


HERE = Path(__file__).resolve().parent
DEGREE = 35
DIMENSION = 361


def base_gate(prime: int):
    matrix = lower.lower_matrix(DEGREE, prime, DIMENSION)
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_35/c3_third_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            matrix = np.concatenate([
                matrix,
                frozen["third_normal_values"].astype(np.int64).reshape(
                    -1, DIMENSION
                ),
            ]) % prime
    with np.load(
        HERE / f"degree_35/c3_third_mixed_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        leading = frozen["b1_values"].astype(np.int64)
        root = frozen["b1_target_root"].astype(np.int64)
        matrix = np.concatenate([
            matrix,
            frozen["b1_extra_gate_matrix"].astype(np.int64),
            frozen["b2_extra_gate_matrix"].astype(np.int64),
        ]) % prime
    assert c3.rank_mod(matrix, prime) == 288
    return matrix, leading, root


def quartic_blocks(prime: int):
    values = []
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_35/c3_fourth_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            values.append(frozen["fourth_normal_values"].astype(np.int64))
    with np.load(
        HERE / f"degree_35/c3_fourth_mixed_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        values.extend([
            frozen[f"b{block}_values"].astype(np.int64)
            for block in (1, 2, 3)
        ])
    return values


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    gate, leading, root = base_gate(prime)
    gradient = klein_gradient(root, prime)
    tangent = np.concatenate([
        np.einsum("i,pin->pn", gradient, values) % prime
        for values in quartic_blocks(prime)
    ], axis=0)
    combined = np.concatenate([gate, tangent], axis=0) % prime
    rank = c3.rank_mod(combined, prime)
    assert rank == 322
    kernel = c3.nullspace_mod(combined, prime).T
    restricted = np.einsum("pjn,nk->pjk", leading, kernel) % prime
    pivot = int(np.flatnonzero(root)[0])
    scalar = (
        pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :]
    ) % prime
    assert all(np.array_equal(
        restricted[:, output, :] % prime,
        root[output] * scalar % prime,
    ) for output in range(5))
    scalar_rank = c3.rank_mod(scalar, prime)
    assert scalar_rank == 9
    output = (
        HERE / f"degree_35/c3_third_mixed_nonbased_tangent_p{prime}.npz"
    )
    np.savez_compressed(
        output,
        base_gate_matrix=gate.astype(np.uint16),
        tangent_gate_matrix=tangent.astype(np.uint16),
        combined_kernel_basis=kernel.astype(np.uint16),
        leading_scalar_forms=scalar.astype(np.uint16),
        leading_target_root=root.astype(np.uint16),
    )
    print(
        f"p={prime}: baseRank=288 tangentRank={rank} "
        f"kernel={DIMENSION-rank} scalarRank={scalar_rank}",
        flush=True,
    )


if __name__ == "__main__":
    main()
