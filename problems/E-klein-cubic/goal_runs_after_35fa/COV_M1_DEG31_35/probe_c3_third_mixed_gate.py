#!/usr/bin/env python3
"""Probe the E0^2E2 and E0E2^2 cubic-normal blocks sequentially."""

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
import probe_c3_second_normal_gate as jets  # noqa: E402
import combine_c3_third_normal_gate as lower  # noqa: E402


def solve_weights(frame: np.ndarray, target: np.ndarray, prime: int):
    # Solve weights * frame = target.
    matrix = np.column_stack([frame.T, target]) % prime
    for column in range(len(frame)):
        pivot = column + int(np.flatnonzero(matrix[column:, column])[0])
        matrix[[column, pivot]] = matrix[[pivot, column]]
        matrix[column] = matrix[column] * pow(int(matrix[column, column]), -1, prime) % prime
        factors = matrix[:, column].copy()
        indices = np.flatnonzero(factors)
        indices = indices[indices != column]
        matrix[indices] = matrix[indices] - factors[indices, None] * matrix[column]
        matrix %= prime
    return matrix[:, -1] % prime


def cubic_row(coordinates, prime: int):
    a, b = map(int, coordinates)
    return np.asarray([a ** 3, a * a * b, a * b * b, b ** 3], dtype=np.int64) % prime


def gate_for(values: np.ndarray, target_space: np.ndarray, root: np.ndarray | None,
             dimension: int, prime: int):
    if root is None:
        assert len(target_space) == 1 and c3.klein(target_space[0]) != 0
        return values.reshape(-1, dimension) % prime
    return c3.landing_constant_matrix(values, root)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    parser.add_argument("--zeta", type=int, default=15)
    parser.add_argument("--degree", type=int, required=True, choices=(31, 35))
    parser.add_argument("--v-index", type=int, choices=(0, 1, 2))
    parser.add_argument("--assemble-partials", action="store_true")
    args = parser.parse_args()
    prime = args.prime
    degree = args.degree
    dimension = {31: 198, 35: 361}[degree]
    c3.P = prime
    c3.ZETA = args.zeta
    module = basis.module_at(prime, args.zeta)
    omega, generator, eigenspaces, stabilizer, roots, fixed_roots = c3.c3_geometry(module)
    e0 = c3.nullspace_mod(generator - np.eye(5, dtype=np.int64), prime)[0]
    e20, e21 = eigenspaces[2]
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
    with np.load(
        HERE / f"degree_{degree}/c3_third_normal_exp0_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        pure0 = frozen["third_normal_values"].astype(np.int64)[0:degree - 2]
    with np.load(
        HERE / f"degree_{degree}/c3_third_normal_exp2_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        frame_coordinates = frozen["direction_coordinates"].astype(np.int64)
        pure2_frame = frozen["third_normal_values"].astype(np.int64).reshape(
            len(frame_coordinates), degree - 2, 5, dimension
        )
    frame = np.asarray([cubic_row(item, prime) for item in frame_coordinates])
    v_coordinates = [(1, 0), (0, 1), (1, 1)]
    v_vectors = [e20, e21, (e20 + e21) % prime]
    if args.assemble_partials:
        partials = []
        for index in range(3):
            with np.load(
                HERE / f"degree_{degree}/c3_third_mixed_v{index}_p{prime}.npz",
                allow_pickle=False,
            ) as frozen:
                partials.append({key: frozen[key].astype(np.int64)
                                 for key in frozen.files})
        b1_values = np.concatenate([
            partials[index]["b1_values"] for index in (0, 1)
        ], axis=0)
        b2_values = np.concatenate([
            partials[index]["b2_values"] for index in range(3)
        ], axis=0)
    else:
        evaluator = basis.DualEvaluator(module, points, prime)
        b1_values = []
        b2_values = []
        inverse_two = pow(2, -1, prime)
        selected_indices = ([args.v_index] if args.v_index is not None else range(3))
        for index in selected_indices:
            coordinates, vector = v_coordinates[index], v_vectors[index]
            weights = solve_weights(frame, cubic_row(coordinates, prime), prime)
            pure2 = np.einsum("a,apjk->pjk", weights, pure2_frame) % prime
            mixed_diagonal = []
            for scalar in (1, 2):
                direction = (e0 + scalar * vector) % prime
                print(f"v={index+1}/3 lambda={scalar}", flush=True)
                dual_values = jets.dual_jets(evaluator, dual_records, direction, 3)
                mixed_diagonal.append(jets.cross_coefficient_values(
                    records, dual_values, points, direction, prime, 3
                ))
            s1 = (mixed_diagonal[0] - pure0 - pure2) % prime
            s2 = (mixed_diagonal[1] - pure0 - 8 * pure2) % prime
            b2 = (s2 - 2 * s1) * inverse_two % prime
            b1 = (s1 - b2) % prime
            if index < 2:
                b1_values.append(b1)
            b2_values.append(b2)
        if args.v_index is not None:
            partial_path = (
                HERE / f"degree_{degree}/c3_third_mixed_v{args.v_index}_p{prime}.npz"
            )
            np.savez_compressed(
                partial_path,
                source_points=points.astype(np.uint16),
                b1_values=(np.asarray([], dtype=np.uint16) if not b1_values
                           else b1_values[0].astype(np.uint16)),
                b2_values=b2_values[0].astype(np.uint16),
            )
            print(f"wrote {partial_path.name}", flush=True)
            return
        b1_values = np.concatenate(b1_values, axis=0)
        b2_values = np.concatenate(b2_values, axis=0)
    b1_exponent = (degree + 2) % 3
    b2_exponent = (degree + 1) % 3
    assert np.array_equal(
        np.einsum("ij,pjk->pik", generator, b1_values) % prime,
        pow(omega, b1_exponent, prime) * b1_values % prime,
    )
    assert np.array_equal(
        np.einsum("ij,pjk->pik", generator, b2_values) % prime,
        pow(omega, b2_exponent, prime) * b2_values % prime,
    )
    b1_space = (c3.nullspace_mod(generator - np.eye(5, dtype=np.int64), prime)
                if b1_exponent == 0 else eigenspaces[b1_exponent])
    b2_space = (c3.nullspace_mod(generator - np.eye(5, dtype=np.int64), prime)
                if b2_exponent == 0 else eigenspaces[b2_exponent])
    b1_root = None if len(b1_space) == 1 else fixed_roots[b1_exponent][0]
    b2_root = None if len(b2_space) == 1 else fixed_roots[b2_exponent][0]
    b1_gate = gate_for(b1_values, b1_space, b1_root, dimension, prime)
    b2_gate = gate_for(b2_values, b2_space, b2_root, dimension, prime)

    fourth_based = lower.lower_matrix(degree, prime, dimension)
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_{degree}/c3_third_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            fourth_based = np.concatenate([
                fourth_based,
                frozen["third_normal_values"].astype(np.int64).reshape(-1, dimension),
            ]) % prime
    fourth_rank = c3.rank_mod(fourth_based, prime)
    assert fourth_rank == {31: 168, 35: 252}[degree]
    b1_combined = np.concatenate([fourth_based, b1_gate], axis=0) % prime
    b1_rank = c3.rank_mod(b1_combined, prime)
    if b1_root is None:
        b1_zero = b1_combined
        b1_scalar_rank = 0
    else:
        kernel = c3.nullspace_mod(b1_combined, prime).T
        restricted = np.einsum("pjn,nk->pjk", b1_values, kernel) % prime
        pivot = int(np.flatnonzero(b1_root)[0])
        scalar_forms = pow(int(b1_root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
        b1_scalar_rank = c3.rank_mod(scalar_forms, prime)
        b1_zero = np.concatenate([fourth_based, b1_values.reshape(-1, dimension)]) % prime
    b1_zero_rank = c3.rank_mod(b1_zero, prime)
    b2_combined = np.concatenate([b1_zero, b2_gate], axis=0) % prime
    b2_rank = c3.rank_mod(b2_combined, prime)
    if b2_root is None:
        b2_scalar_rank = 0
        fifth_based_rank = b2_rank
    else:
        kernel = c3.nullspace_mod(b2_combined, prime).T
        restricted = np.einsum("pjn,nk->pjk", b2_values, kernel) % prime
        pivot = int(np.flatnonzero(b2_root)[0])
        scalar_forms = pow(int(b2_root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
        b2_scalar_rank = c3.rank_mod(scalar_forms, prime)
        fifth_based_rank = c3.rank_mod(np.concatenate([
            b1_zero, b2_values.reshape(-1, dimension)
        ]), prime)
    output = HERE / f"degree_{degree}/c3_third_mixed_p{prime}.npz"
    np.savez_compressed(
        output,
        source_points=points.astype(np.uint16),
        b1_values=b1_values.astype(np.uint16),
        b1_extra_gate_matrix=b1_gate.astype(np.uint16),
        b1_target_eigenspace=b1_space.astype(np.uint16),
        b1_target_root=(np.asarray([], dtype=np.uint16) if b1_root is None
                        else b1_root.astype(np.uint16)),
        b2_values=b2_values.astype(np.uint16),
        b2_extra_gate_matrix=b2_gate.astype(np.uint16),
        b2_target_eigenspace=b2_space.astype(np.uint16),
        b2_target_root=(np.asarray([], dtype=np.uint16) if b2_root is None
                        else b2_root.astype(np.uint16)),
    )
    print(
        f"p={prime} d={degree}: fourthRank={fourth_rank} "
        f"b1Gate={b1_rank} b1Scalar={b1_scalar_rank} b1Zero={b1_zero_rank} "
        f"b2Gate={b2_rank} b2Scalar={b2_scalar_rank} "
        f"fifthBased={dimension-fifth_based_rank}",
        flush=True,
    )


if __name__ == "__main__":
    main()
