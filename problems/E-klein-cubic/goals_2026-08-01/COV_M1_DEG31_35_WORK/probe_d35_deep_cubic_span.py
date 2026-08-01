#!/usr/bin/env python3
"""Test the complete degree-35 landing cubics on the 5D quartic-mixed gate."""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np

import probe_c3_constant_gate as c3
import probe_c3_fourth_normal_gate as fourth
from probe_d31_deep_cubic_span import cubic_coefficients


HERE = Path(__file__).resolve().parent
DEGREE = 35
DIMENSION = 361


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime

    # The all-lower-jets-zero branch, followed by both pure quartic gates.
    deep_gate = fourth.fifth_based_matrix(prime)
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_35/c3_fourth_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            deep_gate = np.concatenate([
                deep_gate,
                frozen["fourth_normal_values"].astype(np.int64).reshape(-1, DIMENSION),
            ]) % prime
    assert c3.rank_mod(deep_gate, prime) == 331

    # The first mixed block has one-dimensional target and hence must vanish.
    # The second mixed block is the five-chart fixed-root-or-zero gate.
    with np.load(
        HERE / f"degree_35/c3_fourth_mixed_p{prime}.npz", allow_pickle=False
    ) as frozen:
        b1 = frozen["b1_values"].astype(np.int64)
        b2_gate = frozen["b2_extra_gate_matrix"].astype(np.int64)
    deep_gate = np.concatenate([
        deep_gate, b1.reshape(-1, DIMENSION), b2_gate
    ], axis=0) % prime
    assert c3.rank_mod(deep_gate, prime) == 356
    kernel = c3.nullspace_mod(deep_gate, prime).T
    assert kernel.shape == (DIMENSION, 5)

    with np.load(
        HERE / f"degree_35/landing_circuits_p{prime}.npz", allow_pickle=False
    ) as frozen:
        points = frozen["fixed_source_points"].copy()
        old_values = frozen["basis_values"].astype(np.int64)
    reduced = np.einsum("pjn,nk->pjk", old_values, kernel) % prime
    monomials, coefficients = cubic_coefficients(reduced, prime)
    rank = c3.rank_mod(coefficients, prime)

    rows = []
    current = np.empty((0, len(monomials)), dtype=np.int64)
    for row in range(len(coefficients)):
        candidate = np.vstack([current, coefficients[row]])
        if c3.rank_mod(candidate, prime) > len(rows):
            rows.append(row)
            current = candidate
            if len(rows) == len(monomials):
                break

    output = HERE / f"degree_35/d35_deep_cubic_span_p{prime}.npz"
    np.savez_compressed(
        output,
        source_points=points,
        deep_gate_kernel_basis=kernel.astype(np.uint16),
        reduced_basis_values=reduced.astype(np.uint16),
        cubic_monomials=np.asarray(monomials, dtype=np.uint16),
        cubic_coefficient_matrix=coefficients.astype(np.uint16),
        fixed_minor_rows=np.asarray(rows, dtype=np.uint16),
    )
    print(
        f"p={prime}: deepKernel=5 cubicMonomials={len(monomials)} "
        f"cubicSpanRank={rank} minorRows={len(rows)}",
        flush=True,
    )


if __name__ == "__main__":
    main()
