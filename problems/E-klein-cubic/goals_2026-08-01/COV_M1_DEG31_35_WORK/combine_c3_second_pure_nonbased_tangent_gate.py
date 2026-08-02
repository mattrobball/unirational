#!/usr/bin/env python3
"""Necessary tangent gate on the pure second-normal nonbased branches.

After the line and first-normal coefficients vanish, the surviving pure
second-normal coefficient is a nonzero scalar polynomial times a fixed smooth
Klein root R.  Along that same pure normal direction, the next coefficient of
F(p) is s^2*dF_R(q3), so dF_R(q3)=0.  This script imposes that exact linear
condition and recomputes the remaining scalar cover at two good primes.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

import probe_c3_constant_gate as c3
from combine_c3_first_normal_nonbased_tangent_gate import first_paths
from combine_c3_first_normal_nonbased_tangent_gate import klein_gradient


HERE = Path(__file__).resolve().parent


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
            base_parts = [
                frozen["basis_values"].astype(np.int64).reshape(-1, dimension)
            ]
        for path in first_paths(degree, prime):
            with np.load(path, allow_pickle=False) as frozen:
                base_parts.append(
                    frozen["derivative_values"].astype(np.int64).reshape(
                        -1, dimension
                    )
                )
        for exponent in (0, 2):
            with np.load(
                HERE / f"degree_{degree}/c3_second_normal_exp{exponent}_p{prime}.npz",
                allow_pickle=False,
            ) as frozen:
                base_parts.append(frozen["extra_gate_matrix"].astype(np.int64))
        base = np.concatenate(base_parts) % prime
        expected_base_rank = {31: 99, 35: 114}[degree]
        assert c3.rank_mod(base, prime) == expected_base_rank

        exponent = 0 if degree == 31 else 2
        with np.load(
            HERE / f"degree_{degree}/c3_second_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            leading = frozen["second_normal_values"].astype(np.int64)
            root = frozen["target_root"].astype(np.int64)
        with np.load(
            HERE / f"degree_{degree}/c3_third_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            next_values = frozen["third_normal_values"].astype(np.int64)
        gradient = klein_gradient(root, prime)
        tangent = np.einsum("i,pin->pn", gradient, next_values) % prime
        combined = np.concatenate([base, tangent]) % prime
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
            f"degree_{degree}/c3_second_pure_nonbased_tangent_p{prime}.npz"
        )
        np.savez_compressed(
            output,
            base_gate_matrix=base.astype(np.uint16),
            tangent_gate_matrix=tangent.astype(np.uint16),
            combined_kernel_basis=kernel.astype(np.uint16),
            leading_scalar_forms=scalar.astype(np.uint16),
            leading_target_root=root.astype(np.uint16),
            leading_normal_exponent=np.asarray(exponent, dtype=np.int64),
        )
        print(
            f"p={prime} d={degree}: baseRank={expected_base_rank} "
            f"tangentRank={rank} kernel={dimension-rank} "
            f"scalarRank={scalar_rank}",
            flush=True,
        )


if __name__ == "__main__":
    main()
