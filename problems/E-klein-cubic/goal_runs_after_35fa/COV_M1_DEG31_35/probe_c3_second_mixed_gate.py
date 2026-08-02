#!/usr/bin/env python3
"""Probe the mixed E0*E2 second-normal gate on the pure-zero branch."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as basis  # noqa: E402
import probe_c3_constant_gate as c3  # noqa: E402
import probe_c3_second_normal_gate as second  # noqa: E402


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
    parser.add_argument("--zeta", type=int, default=15)
    parser.add_argument("--degree", type=int, required=True, choices=(31, 35))
    args = parser.parse_args()
    prime = args.prime
    degree = args.degree
    dimension = {31: 198, 35: 361}[degree]
    c3.P = prime
    c3.ZETA = args.zeta
    module = basis.module_at(prime, args.zeta)
    omega, generator, eigenspaces, stabilizer, roots, fixed_roots = c3.c3_geometry(module)
    eigenspaces[0] = c3.nullspace_mod(
        generator - np.eye(5, dtype=np.int64), prime
    )
    source = eigenspaces[1]
    points = np.asarray([
        (source[0] + parameter * source[1]) % prime
        for parameter in range(degree - 1)
    ], dtype=np.int64)
    records = json.loads(
        (HERE / f"degree_{degree}/m1_cross_basis_circuits.json").read_text()
    )["basis"]
    dual_records = json.loads(
        (HERE / "dual_hironaka_generators.json").read_text()
    )["generators"]
    evaluator = basis.DualEvaluator(module, points, prime)
    e0 = eigenspaces[0][0]
    mixed_values = []
    with np.load(
        HERE / f"degree_{degree}/c3_second_normal_exp0_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        pure0 = frozen["second_normal_values"].astype(np.int64)[0:degree - 1]
    with np.load(
        HERE / f"degree_{degree}/c3_second_normal_exp2_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        pure2 = frozen["second_normal_values"].astype(np.int64)
    for index, e2 in enumerate(eigenspaces[2]):
        direction = (e0 + e2) % prime
        print(f"mixed direction {index+1}/2", flush=True)
        dual_values = second.dual_jets(evaluator, dual_records, direction)
        diagonal = second.second_cross_values(
            records, dual_values, points, direction, prime
        )
        mixed = (diagonal - pure0 - pure2[
            index * (degree - 1):(index + 1) * (degree - 1)
        ]) % prime
        assert np.array_equal(
            np.einsum("ij,pjk->pik", generator, mixed) % prime,
            pow(omega, degree % 3, prime) * mixed % prime,
        )
        mixed_values.append(mixed)
    mixed_values = np.concatenate(mixed_values, axis=0)
    root = fixed_roots[degree % 3][0]
    mixed_gate = c3.landing_constant_matrix(mixed_values, root)

    with np.load(
        HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        line_values = frozen["basis_values"].astype(np.int64).reshape(-1, dimension)
    lower = [line_values]
    for path in first_paths(degree, prime):
        with np.load(path, allow_pickle=False) as frozen:
            lower.append(
                frozen["derivative_values"].astype(np.int64).reshape(-1, dimension)
            )
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_{degree}/c3_second_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            lower.append(
                frozen["second_normal_values"].astype(np.int64).reshape(-1, dimension)
            )
    pure_zero = np.concatenate(lower, axis=0) % prime
    pure_zero_rank = c3.rank_mod(pure_zero, prime)
    expected = {31: 106, 35: 138}[degree]
    assert pure_zero_rank == expected
    combined_rank = c3.rank_mod(
        np.concatenate([pure_zero, mixed_gate], axis=0), prime
    )
    combined = np.concatenate([pure_zero, mixed_gate], axis=0) % prime
    kernel = c3.nullspace_mod(combined, prime).T
    restricted = np.einsum("pjn,nk->pjk", mixed_values, kernel) % prime
    pivot = int(np.flatnonzero(root)[0])
    scalar = pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
    assert all(np.array_equal(
        restricted[:, output, :] % prime,
        root[output] * scalar % prime,
    ) for output in range(5))
    scalar_rank = c3.rank_mod(scalar, prime)
    output = HERE / f"degree_{degree}/c3_second_mixed_p{prime}.npz"
    np.savez_compressed(
        output,
        source_points=points.astype(np.uint16),
        mixed_normal_directions=np.asarray([
            (e0 + e2) % prime for e2 in eigenspaces[2]
        ], dtype=np.uint16),
        mixed_second_values=mixed_values.astype(np.uint16),
        extra_gate_matrix=mixed_gate.astype(np.uint16),
        target_root=root.astype(np.uint16),
    )
    print(
        f"p={prime} d={degree}: pureZeroRank={pure_zero_rank} "
        f"mixedExtra={combined_rank-pure_zero_rank} combined={combined_rank} "
        f"kernel={dimension-combined_rank} scalarRank={scalar_rank} "
        f"thirdBased={dimension-combined_rank-scalar_rank}",
        flush=True,
    )


if __name__ == "__main__":
    main()
