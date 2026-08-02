#!/usr/bin/env python3
"""Probe the three mixed quartic-normal blocks in degree 35."""

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
import probe_c3_fourth_normal_gate as fourth  # noqa: E402


DEGREE = 35
DIMENSION = 361


def solve_weights(frame: np.ndarray, target: np.ndarray, prime: int):
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


def quartic_row(coordinates, prime: int):
    a, b = map(int, coordinates)
    return np.asarray([a ** 4, a ** 3 * b, a * a * b * b,
                       a * b ** 3, b ** 4], dtype=np.int64) % prime


def extract_coefficients(samples, prime: int):
    # samples[lambda-1] = lambda*B1 + lambda^2*B2 + lambda^3*B3.
    frame = np.asarray([[pow(value, order, prime) for order in (1, 2, 3)]
                        for value in (1, 2, 3)], dtype=np.int64)
    answer = []
    for order in range(3):
        target = np.asarray([int(index == order) for index in range(3)])
        weights = solve_weights(frame, target, prime)
        answer.append(sum((weights[index] * samples[index]
                           for index in range(3)),
                          np.zeros_like(samples[0])) % prime)
    return answer


def gate_for(values: np.ndarray, root: np.ndarray | None, prime: int):
    if root is None:
        return values.reshape(-1, DIMENSION) % prime
    return c3.landing_constant_matrix(values, root)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    parser.add_argument("--zeta", type=int, default=15)
    parser.add_argument("--v-index", type=int, choices=(0, 1, 2, 3))
    parser.add_argument("--assemble-partials", action="store_true")
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    c3.ZETA = args.zeta
    module = basis.module_at(prime, args.zeta)
    omega, generator, eigenspaces, stabilizer, roots, fixed_roots = c3.c3_geometry(module)
    e0 = c3.nullspace_mod(generator - np.eye(5, dtype=np.int64), prime)[0]
    e20, e21 = eigenspaces[2]
    source = eigenspaces[1]
    points = np.asarray([
        (source[0] + parameter * source[1]) % prime
        for parameter in range(DEGREE - 3)
    ], dtype=np.int64)
    v_coordinates = [(1, 0), (0, 1), (1, 1), (1, 2)]
    v_vectors = [e20, e21, (e20 + e21) % prime, (e20 + 2 * e21) % prime]
    with np.load(
        HERE / f"degree_35/c3_fourth_normal_exp0_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        pure0 = frozen["fourth_normal_values"].astype(np.int64)[0:DEGREE - 3]
    with np.load(
        HERE / f"degree_35/c3_fourth_normal_exp2_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        pure_frame_coordinates = frozen["direction_coordinates"].astype(np.int64)
        pure4_frame = frozen["fourth_normal_values"].astype(np.int64).reshape(
            len(pure_frame_coordinates), DEGREE - 3, 5, DIMENSION
        )
    frame = np.asarray([quartic_row(item, prime) for item in pure_frame_coordinates])
    if args.assemble_partials:
        partials = []
        for index in range(4):
            with np.load(
                HERE / f"degree_35/c3_fourth_mixed_v{index}_p{prime}.npz",
                allow_pickle=False,
            ) as frozen:
                partials.append({key: frozen[key].astype(np.int64)
                                 for key in frozen.files})
        b1_values = np.concatenate([partials[index]["b1_values"] for index in (0, 1)])
        b2_values = np.concatenate([partials[index]["b2_values"] for index in (0, 1, 2)])
        b3_values = np.concatenate([partials[index]["b3_values"] for index in range(4)])
    else:
        if args.v_index is None:
            raise ValueError("use --v-index or --assemble-partials")
        index = args.v_index
        coordinates, vector = v_coordinates[index], v_vectors[index]
        weights = solve_weights(frame, quartic_row(coordinates, prime), prime)
        pure4 = np.einsum("a,apjk->pjk", weights, pure4_frame) % prime
        records = json.loads(
            (HERE / "degree_35/m1_cross_basis_circuits.json").read_text()
        )["basis"]
        dual_records = json.loads(
            (HERE / "dual_hironaka_generators.json").read_text()
        )["generators"]
        evaluator = basis.DualEvaluator(module, points, prime)
        samples = []
        for scalar in (1, 2, 3):
            print(f"v={index+1}/4 lambda={scalar}", flush=True)
            direction = (e0 + scalar * vector) % prime
            dual_values = jets.dual_jets(evaluator, dual_records, direction, 4)
            diagonal = jets.cross_coefficient_values(
                records, dual_values, points, direction, prime, 4
            )
            samples.append((diagonal - pure0 - pow(scalar, 4, prime) * pure4) % prime)
        b1, b2, b3 = extract_coefficients(samples, prime)
        partial = HERE / f"degree_35/c3_fourth_mixed_v{index}_p{prime}.npz"
        np.savez_compressed(
            partial,
            b1_values=b1.astype(np.uint16),
            b2_values=b2.astype(np.uint16),
            b3_values=b3.astype(np.uint16),
        )
        print(f"wrote {partial.name}")
        return
    exponents = [(DEGREE - 4 + 2 * block) % 3 for block in (1, 2, 3)]
    values_blocks = [b1_values, b2_values, b3_values]
    roots_blocks = []
    gates = []
    for exponent, values in zip(exponents, values_blocks):
        assert np.array_equal(
            np.einsum("ij,pjk->pik", generator, values) % prime,
            pow(omega, exponent, prime) * values % prime,
        )
        target_space = (c3.nullspace_mod(generator - np.eye(5, dtype=np.int64), prime)
                        if exponent == 0 else eigenspaces[exponent])
        root = None if len(target_space) == 1 else fixed_roots[exponent][0]
        roots_blocks.append(root)
        gates.append(gate_for(values, root, prime))
    base = fourth.fifth_based_matrix(prime)
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_35/c3_fourth_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            base = np.concatenate([
                base,
                frozen["fourth_normal_values"].astype(np.int64).reshape(-1, DIMENSION),
            ]) % prime
    assert c3.rank_mod(base, prime) == 331
    stage = base
    ledger = []
    for block, (values, root, gate) in enumerate(zip(values_blocks, roots_blocks, gates), 1):
        gated = np.concatenate([stage, gate], axis=0) % prime
        gate_rank = c3.rank_mod(gated, prime)
        print(f"block {block}: gate rank {gate_rank}", flush=True)
        scalar_rank = 0
        if gate_rank == DIMENSION:
            ledger.append((gate_rank, 0, gate_rank))
            stage = gated
            break
        if root is None:
            zero_stage = gated
        else:
            kernel = c3.nullspace_mod(gated, prime).T
            restricted = np.einsum("pjn,nk->pjk", values, kernel) % prime
            pivot = int(np.flatnonzero(root)[0])
            scalar = pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
            scalar_rank = c3.rank_mod(scalar, prime)
            zero_stage = np.concatenate([stage, values.reshape(-1, DIMENSION)]) % prime
        zero_rank = c3.rank_mod(zero_stage, prime)
        assert zero_rank == gate_rank + scalar_rank
        ledger.append((gate_rank, scalar_rank, zero_rank))
        stage = zero_stage
    output = HERE / f"degree_35/c3_fourth_mixed_p{prime}.npz"
    np.savez_compressed(
        output,
        source_points=points.astype(np.uint16),
        b1_values=b1_values.astype(np.uint16),
        b1_extra_gate_matrix=gates[0].astype(np.uint16),
        b1_target_root=np.asarray([], dtype=np.uint16),
        b2_values=b2_values.astype(np.uint16),
        b2_extra_gate_matrix=gates[1].astype(np.uint16),
        b2_target_root=roots_blocks[1].astype(np.uint16),
        b3_values=b3_values.astype(np.uint16),
        b3_extra_gate_matrix=gates[2].astype(np.uint16),
        b3_target_root=roots_blocks[2].astype(np.uint16),
    )
    print(f"p={prime}: stages={ledger} seventhBased={DIMENSION-ledger[-1][2]}")


if __name__ == "__main__":
    main()
