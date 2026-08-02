#!/usr/bin/env python3
"""Sequential tangent cover for the degree-35 pure third-normal branch."""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

import probe_c3_constant_gate as c3
import combine_c3_third_normal_gate as third
from combine_c3_first_normal_nonbased_tangent_gate import klein_gradient


HERE = Path(__file__).resolve().parent
DEGREE = 35
DIMENSION = 361


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime

    base_parts = [third.lower_matrix(DEGREE, prime, DIMENSION)]
    leading_blocks = []
    next_blocks = []
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_35/c3_third_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            base_parts.append(frozen["extra_gate_matrix"].astype(np.int64))
            leading_blocks.append((
                exponent,
                frozen["third_normal_values"].astype(np.int64),
                frozen["target_root"].astype(np.int64),
            ))
        with np.load(
            HERE / f"degree_35/c3_fourth_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            next_blocks.append(frozen["fourth_normal_values"].astype(np.int64))
    base = np.concatenate(base_parts) % prime
    assert c3.rank_mod(base, prime) == 221

    records = []
    prior = base
    for (exponent, leading, root), next_values in zip(
        leading_blocks, next_blocks
    ):
        base_rank = c3.rank_mod(prior, prime)
        gradient = klein_gradient(root, prime)
        tangent = np.einsum("i,pin->pn", gradient, next_values) % prime
        combined = np.concatenate([prior, tangent]) % prime
        tangent_rank = c3.rank_mod(combined, prime)
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
        records.append((
            exponent, base_rank, tangent_rank,
            DIMENSION - tangent_rank, scalar_rank,
        ))
        # The next chart family is the scalar-zero complement of this family.
        prior = np.concatenate([prior, leading.reshape(-1, DIMENSION)]) % prime

    output = HERE / (
        f"degree_35/c3_third_pure_nonbased_tangent_p{prime}.npz"
    )
    np.savez_compressed(
        output,
        records=np.asarray(records, dtype=np.int64),
        final_scalar_zero_matrix=prior.astype(np.uint16),
    )
    print(f"p={prime} records={records}", flush=True)


if __name__ == "__main__":
    main()
