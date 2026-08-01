#!/usr/bin/env python3
"""Test the complete degree-31 landing cubics on the 5D third-mixed gate."""

from __future__ import annotations

import argparse
import itertools
from pathlib import Path

import numpy as np

import probe_c3_constant_gate as c3
import combine_c3_third_normal_gate as lower


HERE = Path(__file__).resolve().parent
DEGREE = 31
DIMENSION = 198


def cubic_coefficients(values: np.ndarray, prime: int):
    variables = values.shape[2]
    monomials = list(itertools.combinations_with_replacement(range(variables), 3))
    index = {monomial: position for position, monomial in enumerate(monomials)}
    matrix = np.zeros((len(values), len(monomials)), dtype=np.int64)
    for node, linear in enumerate(values.astype(np.int64)):
        for target in range(5):
            successor = (target + 1) % 5
            for left in range(variables):
                for right in range(variables):
                    coefficient = linear[target, left] * linear[target, right] % prime
                    if not coefficient:
                        continue
                    for last in range(variables):
                        matrix[node, index[tuple(sorted((left, right, last)))]] += (
                            coefficient * linear[successor, last]
                        )
        matrix[node] %= prime
    return monomials, matrix % prime


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    fourth = lower.lower_matrix(DEGREE, prime, DIMENSION)
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_31/c3_third_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            fourth = np.concatenate([
                fourth,
                frozen["third_normal_values"].astype(np.int64).reshape(-1, DIMENSION),
            ]) % prime
    with np.load(
        HERE / f"degree_31/c3_third_mixed_p{prime}.npz", allow_pickle=False
    ) as frozen:
        b1 = frozen["b1_values"].astype(np.int64)
        b2_gate = frozen["b2_extra_gate_matrix"].astype(np.int64)
    deep_gate = np.concatenate([
        fourth, b1.reshape(-1, DIMENSION), b2_gate
    ], axis=0) % prime
    assert c3.rank_mod(deep_gate, prime) == 193
    kernel = c3.nullspace_mod(deep_gate, prime).T
    assert kernel.shape == (DIMENSION, 5)
    with np.load(
        HERE / f"degree_31/landing_circuits_p{prime}.npz", allow_pickle=False
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
    output = HERE / f"degree_31/d31_deep_cubic_span_p{prime}.npz"
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
