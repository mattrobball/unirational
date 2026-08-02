#!/usr/bin/env python3
"""Reduce the mixed-second nonbased C3 branches by their third-jet tangent gate."""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

import probe_c3_constant_gate as c3
from combine_c3_first_normal_nonbased_tangent_gate import klein_gradient
from combine_c3_first_normal_nonbased_tangent_gate import first_paths


HERE = Path(__file__).resolve().parent


def prior_pure_zero_matrix(degree: int, dimension: int, prime: int):
    """Stop after the two pure second-normal scalars vanish.

    In particular, do not use combine_c3_third_normal_gate.lower_matrix here:
    that matrix already imposes the mixed-second scalar-zero condition and
    would make the nonbased-branch test circular.
    """
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
    return np.concatenate(arrays) % prime


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    for degree, dimension in ((31, 198), (35, 361)):
        pure_zero = prior_pure_zero_matrix(degree, dimension, prime)
        with np.load(
            HERE / f"degree_{degree}/c3_second_mixed_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            leading = frozen["mixed_second_values"].astype(np.int64)
            leading_gate = frozen["extra_gate_matrix"].astype(np.int64)
            root = frozen["target_root"].astype(np.int64)
        base_gate = np.concatenate([pure_zero, leading_gate], axis=0) % prime
        expected_base = {31: 120, 35: 157}[degree]
        assert c3.rank_mod(base_gate, prime) == expected_base
        gradient = klein_gradient(root, prime)
        third_values = []
        for exponent in (0, 2):
            with np.load(
                HERE / f"degree_{degree}/c3_third_normal_exp{exponent}_p{prime}.npz",
                allow_pickle=False,
            ) as frozen:
                third_values.append(
                    frozen["third_normal_values"].astype(np.int64)
                )
        with np.load(
            HERE / f"degree_{degree}/c3_third_mixed_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            third_values.extend([
                frozen["b1_values"].astype(np.int64),
                frozen["b2_values"].astype(np.int64),
            ])
        tangent = np.concatenate([
            np.einsum("i,pin->pn", gradient, values) % prime
            for values in third_values
        ], axis=0)
        combined = np.concatenate([base_gate, tangent], axis=0) % prime
        rank = c3.rank_mod(combined, prime)
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
        output = HERE / (
            f"degree_{degree}/c3_second_mixed_nonbased_tangent_p{prime}.npz"
        )
        np.savez_compressed(
            output,
            base_gate_matrix=base_gate.astype(np.uint16),
            tangent_gate_matrix=tangent.astype(np.uint16),
            combined_kernel_basis=kernel.astype(np.uint16),
            leading_scalar_forms=scalar.astype(np.uint16),
            leading_target_root=root.astype(np.uint16),
        )
        print(
            f"p={prime} d={degree}: baseRank={expected_base} "
            f"tangentRank={rank} kernel={dimension-rank} "
            f"scalarRank={scalar_rank}",
            flush=True,
        )


if __name__ == "__main__":
    main()
