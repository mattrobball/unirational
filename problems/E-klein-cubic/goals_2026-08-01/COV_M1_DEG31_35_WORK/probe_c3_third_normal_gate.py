#!/usr/bin/env python3
"""Probe the complete cubic-normal gate on the true C3 order-three branch."""

from __future__ import annotations

import argparse
import itertools
import json
import math
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as basis  # noqa: E402
import probe_c3_constant_gate as c3  # noqa: E402
import probe_c3_second_normal_gate as jets  # noqa: E402


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


def cubic_directions(normal_basis: np.ndarray, prime: int):
    dimension = len(normal_basis)
    monomials = [item for item in itertools.product(range(4), repeat=dimension)
                 if sum(item) == 3]
    selected = []
    rows = []
    if dimension == 1:
        candidates = [(1,)]
    else:
        candidates = [(1, value) for value in range(6)] + [(0, 1)]
    for candidate in candidates:
        row = np.asarray([
            math.prod(pow(candidate[index], exponent[index], prime)
                      for index in range(dimension)) % prime
            for exponent in monomials
        ], dtype=np.int64)
        if c3.rank_mod(np.asarray(rows + [row.tolist()]), prime) > len(rows):
            rows.append(row.tolist())
            selected.append(candidate)
            if len(rows) == len(monomials):
                break
    assert len(selected) == len(monomials)
    directions = np.asarray([
        sum((coefficient * normal_basis[index]
             for index, coefficient in enumerate(candidate)),
            np.zeros(5, dtype=np.int64)) % prime
        for candidate in selected
    ])
    return np.asarray(selected, dtype=np.int64), directions


def lower_paths(degree: int, prime: int):
    return (
        first_paths(degree, prime)
        + [HERE / f"degree_{degree}/c3_second_normal_exp0_p{prime}.npz",
           HERE / f"degree_{degree}/c3_second_normal_exp2_p{prime}.npz",
           HERE / f"degree_{degree}/c3_second_mixed_p{prime}.npz"]
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    parser.add_argument("--zeta", type=int, default=15)
    parser.add_argument("--degree", type=int, required=True, choices=(31, 35))
    parser.add_argument("--normal-exponent", type=int, required=True, choices=(0, 2))
    args = parser.parse_args()
    prime = args.prime
    degree = args.degree
    dimension = {31: 198, 35: 361}[degree]
    c3.P = prime
    c3.ZETA = args.zeta
    module = basis.module_at(prime, args.zeta)
    omega, generator, eigenspaces, stabilizer, roots, fixed_roots = c3.c3_geometry(module)
    e0 = c3.nullspace_mod(generator - np.eye(5, dtype=np.int64), prime)[0]
    normal_basis = (np.asarray([e0]) if args.normal_exponent == 0
                    else eigenspaces[2])
    direction_coordinates, directions = cubic_directions(normal_basis, prime)
    source = eigenspaces[1]
    points = np.asarray([
        (source[0] + parameter * source[1]) % prime
        for parameter in range(degree - 2)
    ], dtype=np.int64)
    records = json.loads(
        (HERE / f"degree_{degree}/m1_cross_basis_circuits.json").read_text()
    )["basis"]
    dual_records = json.loads(
        (HERE / "dual_hironaka_generators.json").read_text()
    )["generators"]
    evaluator = basis.DualEvaluator(module, points, prime)
    values = []
    for index, direction in enumerate(directions):
        print(f"cubic direction {index+1}/{len(directions)}", flush=True)
        dual_values = jets.dual_jets(evaluator, dual_records, direction, 3)
        value = jets.cross_coefficient_values(
            records, dual_values, points, direction, prime, 3
        )
        assert np.array_equal(
            np.einsum("ij,pjk->pik", generator, value) % prime,
            pow(omega, degree % 3, prime) * value % prime,
        )
        values.append(value)
    values = np.concatenate(values, axis=0)
    root = fixed_roots[degree % 3][0]
    third_gate = c3.landing_constant_matrix(values, root)

    with np.load(
        HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        lower = [frozen["basis_values"].astype(np.int64).reshape(-1, dimension)]
    for path in lower_paths(degree, prime):
        with np.load(path, allow_pickle=False) as frozen:
            if "derivative_values" in frozen:
                array = frozen["derivative_values"]
            elif "second_normal_values" in frozen:
                array = frozen["second_normal_values"]
            else:
                array = frozen["mixed_second_values"]
            lower.append(array.astype(np.int64).reshape(-1, dimension))
    third_based = np.concatenate(lower, axis=0) % prime
    third_based_rank = c3.rank_mod(third_based, prime)
    assert third_based_rank == {31: 133, 35: 177}[degree]
    combined = np.concatenate([third_based, third_gate], axis=0) % prime
    combined_rank = c3.rank_mod(combined, prime)
    kernel = c3.nullspace_mod(combined, prime).T
    restricted = np.einsum("pjn,nk->pjk", values, kernel) % prime
    pivot = int(np.flatnonzero(root)[0])
    scalar = pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
    assert all(np.array_equal(
        restricted[:, output, :] % prime, root[output] * scalar % prime
    ) for output in range(5))
    scalar_rank = c3.rank_mod(scalar, prime)
    output = HERE / (
        f"degree_{degree}/c3_third_normal_exp{args.normal_exponent}_p{prime}.npz"
    )
    np.savez_compressed(
        output,
        source_points=points.astype(np.uint16),
        normal_basis=normal_basis.astype(np.uint16),
        direction_coordinates=direction_coordinates.astype(np.uint16),
        normal_directions=directions.astype(np.uint16),
        third_normal_values=values.astype(np.uint16),
        extra_gate_matrix=third_gate.astype(np.uint16),
        target_root=root.astype(np.uint16),
    )
    print(
        f"p={prime} d={degree}: thirdBasedRank={third_based_rank} "
        f"thirdExtra={combined_rank-third_based_rank} combined={combined_rank} "
        f"kernel={dimension-combined_rank} scalarRank={scalar_rank} "
        f"fourthBased={dimension-combined_rank-scalar_rank}",
        flush=True,
    )


if __name__ == "__main__":
    main()
