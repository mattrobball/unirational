#!/usr/bin/env python3
"""Linear tangent gate on the first-normal nonbased C3 branch.

On this branch the first normal coefficient is a nonzero scalar polynomial
times one fixed smooth Klein root R.  The next coefficient of F(p)=0 is
s^2*dF_R(q2), hence dF_R(q2)=0 in the integral source polynomial ring.
The saved pure and mixed second-normal tensors span every quadratic normal
coefficient, so their contractions give the complete linear tangent gate.
"""

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
        with np.load(
            HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            line_zero = frozen["basis_values"].astype(np.int64).reshape(
                -1, dimension
            )
        first_gates = [line_zero]
        for path in first_paths(degree, prime):
            with np.load(path, allow_pickle=False) as frozen:
                first_gates.append(
                    frozen["extra_gate_matrix"].astype(np.int64)
                )
        first_gate = np.concatenate(first_gates, axis=0) % prime
        expected_first_rank = {31: 51, 35: 61}[degree]
        assert c3.rank_mod(first_gate, prime) == expected_first_rank

        leading_path = (
            HERE / f"degree_31/c3_first_normal_exp2_p{prime}.npz"
            if degree == 31 else
            HERE / f"degree_35/c3_first_normal_exp0_p{prime}.npz"
        )
        with np.load(leading_path, allow_pickle=False) as frozen:
            leading = frozen["derivative_values"].astype(np.int64)
            root = frozen["target_root"].astype(np.int64)
        assert len(root) == 5
        gradient = klein_gradient(root, prime)

        second_values = []
        for exponent in (0, 2):
            with np.load(
                HERE / f"degree_{degree}/c3_second_normal_exp{exponent}_p{prime}.npz",
                allow_pickle=False,
            ) as frozen:
                second_values.append(
                    frozen["second_normal_values"].astype(np.int64)
                )
        with np.load(
            HERE / f"degree_{degree}/c3_second_mixed_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            second_values.append(
                frozen["mixed_second_values"].astype(np.int64)
            )
        tangent_gate = np.concatenate([
            np.einsum("i,pin->pn", gradient, values) % prime
            for values in second_values
        ], axis=0)
        combined = np.concatenate([first_gate, tangent_gate], axis=0) % prime
        combined_rank = c3.rank_mod(combined, prime)
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
        print(
            f"p={prime} d={degree}: firstGate={expected_first_rank} "
            f"tangentExtra={combined_rank-expected_first_rank} "
            f"combined={combined_rank} kernel={dimension-combined_rank} "
            f"leadingScalarRank={scalar_rank}",
            flush=True,
        )


if __name__ == "__main__":
    main()
