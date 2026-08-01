#!/usr/bin/env python3
"""Probe pure fourth-normal blocks on the degree-35 C3 order-four branch."""

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
import combine_c3_third_normal_gate as lower  # noqa: E402


DEGREE = 35
DIMENSION = 361


def veronese_directions(normal_basis: np.ndarray, prime: int):
    block_dimension = len(normal_basis)
    monomials = [item for item in itertools.product(range(5), repeat=block_dimension)
                 if sum(item) == 4]
    candidates = ([(1,)] if block_dimension == 1 else
                  [(1, value) for value in range(7)] + [(0, 1)])
    selected = []
    rows = []
    for candidate in candidates:
        row = [math.prod(pow(candidate[index], exponent[index], prime)
                         for index in range(block_dimension)) % prime
               for exponent in monomials]
        if c3.rank_mod(np.asarray(rows + [row]), prime) > len(rows):
            rows.append(row)
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


def fifth_based_matrix(prime: int):
    matrix = lower.lower_matrix(DEGREE, prime, DIMENSION)
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_35/c3_third_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            matrix = np.concatenate([
                matrix,
                frozen["third_normal_values"].astype(np.int64).reshape(-1, DIMENSION),
            ]) % prime
    with np.load(
        HERE / f"degree_35/c3_third_mixed_p{prime}.npz", allow_pickle=False
    ) as frozen:
        matrix = np.concatenate([
            matrix,
            frozen["b1_values"].astype(np.int64).reshape(-1, DIMENSION),
            frozen["b2_values"].astype(np.int64).reshape(-1, DIMENSION),
        ]) % prime
    assert c3.rank_mod(matrix, prime) == 301
    return matrix


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    parser.add_argument("--zeta", type=int, default=15)
    parser.add_argument("--normal-exponent", type=int, required=True, choices=(0, 2))
    parser.add_argument("--direction-index", type=int, choices=(0, 1, 2, 3, 4))
    parser.add_argument("--assemble-partials", action="store_true")
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    c3.ZETA = args.zeta
    module = basis.module_at(prime, args.zeta)
    omega, generator, eigenspaces, stabilizer, roots, fixed_roots = c3.c3_geometry(module)
    e0 = c3.nullspace_mod(generator - np.eye(5, dtype=np.int64), prime)[0]
    normal_basis = (np.asarray([e0]) if args.normal_exponent == 0
                    else eigenspaces[2])
    direction_coordinates, directions = veronese_directions(normal_basis, prime)
    source = eigenspaces[1]
    points = np.asarray([
        (source[0] + parameter * source[1]) % prime
        for parameter in range(DEGREE - 3)
    ], dtype=np.int64)
    records = json.loads(
        (HERE / "degree_35/m1_cross_basis_circuits.json").read_text()
    )["basis"]
    dual_records = json.loads(
        (HERE / "dual_hironaka_generators.json").read_text()
    )["generators"]
    target_exponent = (DEGREE - 4 + 4 * args.normal_exponent) % 3
    target_space = (c3.nullspace_mod(generator - np.eye(5, dtype=np.int64), prime)
                    if target_exponent == 0 else eigenspaces[target_exponent])
    target_root = (None if len(target_space) == 1
                   else fixed_roots[target_exponent][0])
    if args.assemble_partials:
        partial_values = []
        for index in range(len(directions)):
            with np.load(
                HERE / f"degree_35/c3_fourth_normal_exp{args.normal_exponent}"
                f"_dir{index}_p{prime}.npz",
                allow_pickle=False,
            ) as frozen:
                partial_values.append(frozen["fourth_normal_values"].astype(np.int64))
        values = np.concatenate(partial_values, axis=0)
    else:
        evaluator = basis.DualEvaluator(module, points, prime)
        values = []
        indices = ([args.direction_index] if args.direction_index is not None
                   else range(len(directions)))
        for index in indices:
            direction = directions[index]
            print(f"quartic direction {index+1}/{len(directions)}", flush=True)
            dual_values = jets.dual_jets(evaluator, dual_records, direction, 4)
            value = jets.cross_coefficient_values(
                records, dual_values, points, direction, prime, 4
            )
            assert np.array_equal(
                np.einsum("ij,pjk->pik", generator, value) % prime,
                pow(omega, target_exponent, prime) * value % prime,
            )
            values.append(value)
        if args.direction_index is not None:
            partial = HERE / (
                f"degree_35/c3_fourth_normal_exp{args.normal_exponent}"
                f"_dir{args.direction_index}_p{prime}.npz"
            )
            np.savez_compressed(
                partial,
                fourth_normal_values=values[0].astype(np.uint16),
            )
            print(f"wrote {partial.name}", flush=True)
            return
        values = np.concatenate(values, axis=0)
    if target_root is None:
        assert c3.klein(target_space[0]) != 0
        gate = values.reshape(-1, DIMENSION) % prime
        target_kind = "zero"
    else:
        gate = c3.landing_constant_matrix(values, target_root)
        target_kind = "fixed-root"
    fifth = fifth_based_matrix(prime)
    combined = np.concatenate([fifth, gate], axis=0) % prime
    combined_rank = c3.rank_mod(combined, prime)
    scalar_rank = 0
    next_based_rank = combined_rank
    if target_root is not None:
        kernel = c3.nullspace_mod(combined, prime).T
        restricted = np.einsum("pjn,nk->pjk", values, kernel) % prime
        pivot = int(np.flatnonzero(target_root)[0])
        scalar = pow(int(target_root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
        scalar_rank = c3.rank_mod(scalar, prime)
        next_based_rank = c3.rank_mod(np.concatenate([
            fifth, values.reshape(-1, DIMENSION)
        ]), prime)
    output = (
        HERE / f"degree_35/c3_fourth_normal_exp{args.normal_exponent}_p{prime}.npz"
    )
    np.savez_compressed(
        output,
        source_points=points.astype(np.uint16),
        normal_basis=normal_basis.astype(np.uint16),
        direction_coordinates=direction_coordinates.astype(np.uint16),
        normal_directions=directions.astype(np.uint16),
        fourth_normal_values=values.astype(np.uint16),
        extra_gate_matrix=gate.astype(np.uint16),
        target_eigenspace=target_space.astype(np.uint16),
        target_root=(np.asarray([], dtype=np.uint16) if target_root is None
                     else target_root.astype(np.uint16)),
    )
    print(
        f"p={prime} exp={args.normal_exponent}: fifthRank=301 "
        f"gateRank={combined_rank} kernel={DIMENSION-combined_rank} "
        f"scalarRank={scalar_rank} nextBased={DIMENSION-next_based_rank} "
        f"target={target_kind}",
        flush=True,
    )


if __name__ == "__main__":
    main()
