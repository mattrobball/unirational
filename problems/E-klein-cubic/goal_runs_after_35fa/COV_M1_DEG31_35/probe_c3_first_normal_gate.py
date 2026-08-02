#!/usr/bin/env python3
"""Probe first-normal landing gates on the C3-line based stratum."""

from __future__ import annotations

import argparse
import gc
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as basis  # noqa: E402
import probe_c3_constant_gate as c3  # noqa: E402


def polynomial_derivative(polynomial, points: np.ndarray, direction: np.ndarray,
                          prime: int) -> np.ndarray:
    answer = np.zeros(len(points), dtype=np.int64)
    for exponents, coefficient in polynomial.items():
        for differentiated, exponent in enumerate(exponents):
            exponent = int(exponent)
            if not exponent or not int(direction[differentiated]) % prime:
                continue
            value = np.full(
                len(points),
                int(coefficient) * exponent * int(direction[differentiated]) % prime,
                dtype=np.int64,
            )
            for coordinate, power in enumerate(exponents):
                power = int(power) - (coordinate == differentiated)
                if power:
                    value = value * np.asarray([
                        pow(int(item), power, prime)
                        for item in points[:, coordinate]
                    ], dtype=np.int64) % prime
            answer = (answer + value) % prime
    return answer


def dual_derivatives(evaluator: basis.DualEvaluator, records, direction: np.ndarray):
    prime = evaluator.prime
    transformed_direction = np.einsum(
        "gij,j->gi", evaluator.module.GROUP, direction
    ) % prime
    group_rows = np.asarray(evaluator.module.GROUP, dtype=np.int64)
    answer = []
    for record in records:
        exponents = tuple(map(int, record["reynolds_exponents"]))
        derivative = np.zeros(evaluator.transformed.shape[:2], dtype=np.int64)
        for differentiated, exponent in enumerate(exponents):
            if not exponent:
                continue
            term = np.full(
                evaluator.transformed.shape[:2], exponent, dtype=np.int64
            )
            term = term * transformed_direction[None, :, differentiated] % prime
            for coordinate, power in enumerate(exponents):
                power -= coordinate == differentiated
                if power:
                    term = term * evaluator.power(coordinate, power) % prime
            derivative = (derivative + term) % prime
        output = int(record["reynolds_output"])
        answer.append(derivative @ group_rows[:, output, :] % prime)
    return np.asarray(answer)


def cross_derivatives(records, dual_values: np.ndarray,
                      dual_derivative_values: np.ndarray,
                      points: np.ndarray, direction: np.ndarray, prime: int):
    columns = []
    for record in records:
        indices = tuple(map(int, record["dual_generator_indices"]))
        selected = dual_values[list(indices)]
        cross = basis.cross4(selected, range(4), prime)
        derivative_cross = np.zeros_like(cross)
        for replaced in range(4):
            differentiated = selected.copy()
            differentiated[replaced] = dual_derivative_values[indices[replaced]]
            derivative_cross = (
                derivative_cross
                + basis.cross4(differentiated, range(4), prime)
            ) % prime
        multiplier = record["multiplier"]
        label = (
            int(multiplier["secondary_index"]),
            tuple(map(int, multiplier["primary_exponents"])),
        )
        polynomial = basis.invariant_polynomial(label)
        scalar = basis.evaluate_polynomial(polynomial, points, prime)
        derivative_scalar = polynomial_derivative(
            polynomial, points, direction, prime
        )
        columns.append(
            (derivative_scalar[:, None] * cross
             + scalar[:, None] * derivative_cross) % prime
        )
    return np.asarray(columns).transpose(1, 2, 0)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    parser.add_argument("--zeta", type=int, default=15)
    parser.add_argument("--degree", type=int, choices=(31, 35))
    parser.add_argument("--normal-exponent", type=int, choices=(0, 2))
    parser.add_argument("--direction-index", type=int, choices=(0, 1))
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    c3.ZETA = args.zeta
    module = basis.module_at(prime, args.zeta)
    omega, generator, eigenspaces, stabilizer, roots, fixed_roots = (
        c3.c3_geometry(module)
    )
    eigenspaces[0] = c3.nullspace_mod(
        generator - np.eye(5, dtype=np.int64), prime
    )
    assert eigenspaces[0].shape == (1, 5)
    print(
        f"p={prime}: E0 Klein value={c3.klein(eigenspaces[0][0])}; "
        f"normal dimensions E0={len(eigenspaces[0])}, E2={len(eigenspaces[2])}"
    )
    dual_records = json.loads(
        (HERE / "dual_hironaka_generators.json").read_text()
    )["generators"]
    source = eigenspaces[1]
    for degree in ((args.degree,) if args.degree else (31, 35)):
        records = json.loads(
            (HERE / f"degree_{degree}/m1_cross_basis_circuits.json").read_text()
        )["basis"]
        points = np.asarray([
            (source[0] + parameter * source[1]) % prime
            for parameter in range(degree)
        ], dtype=np.int64)
        evaluator = basis.DualEvaluator(module, points, prime)
        dual_values = basis.evaluate_fixed_dual_generators(evaluator, dual_records)
        base_gate_path = HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz"
        with np.load(base_gate_path, allow_pickle=False) as frozen:
            base_gate = frozen["gate_matrix"].astype(np.int64)
            based_gate = frozen["basis_values"].astype(np.int64).reshape(
                -1, len(records)
            )
        extra_rows = []
        block_ledger = []
        normal_exponents = ((args.normal_exponent,) if args.normal_exponent is not None
                            else (0, 2))
        for normal_exponent in normal_exponents:
            block_values = []
            block_gate_rows = []
            target_exponent = (degree - 1 + normal_exponent) % 3
            target_space = eigenspaces[target_exponent]
            if len(target_space) == 1:
                target_kind = (
                    "automatic-point" if c3.klein(target_space[0]) == 0
                    else "zero"
                )
                target_root = None
            else:
                target_kind = "fixed-root"
                target_root = fixed_roots[target_exponent][0]
            directions = eigenspaces[normal_exponent]
            if args.direction_index is not None:
                if args.direction_index >= len(directions):
                    raise ValueError("direction index outside the normal block")
                directions = directions[[args.direction_index]]
            for direction in directions:
                print(
                    f"degree={degree} normalExponent={normal_exponent} "
                    "evaluating derivative",
                    flush=True,
                )
                dual_d = dual_derivatives(evaluator, dual_records, direction)
                derivative = cross_derivatives(
                    records, dual_values, dual_d, points, direction, prime
                )
                print(
                    f"degree={degree} normalExponent={normal_exponent} "
                    "derivative evaluated",
                    flush=True,
                )
                expected_scalar = pow(omega, target_exponent, prime)
                assert np.array_equal(
                    np.einsum("ij,pjk->pik", generator, derivative) % prime,
                    expected_scalar * derivative % prime,
                )
                block_values.append(derivative)
                if target_kind == "zero":
                    rows = derivative.reshape(-1, len(records))
                    extra_rows.append(rows)
                    block_gate_rows.append(rows)
                elif target_kind == "fixed-root":
                    rows = c3.landing_constant_matrix(derivative, target_root)
                    extra_rows.append(rows)
                    block_gate_rows.append(rows)
            block = np.concatenate(block_values, axis=0)
            block_gate = np.concatenate(block_gate_rows, axis=0) % prime
            direction_suffix = (
                "" if args.direction_index is None else f"_dir{args.direction_index}"
            )
            block_path = HERE / (
                f"degree_{degree}/c3_first_normal_exp{normal_exponent}"
                f"{direction_suffix}_p{prime}.npz"
            )
            np.savez_compressed(
                block_path,
                source_points=points.astype(np.uint16),
                normal_directions=directions.astype(np.uint16),
                derivative_values=block.astype(np.uint16),
                extra_gate_matrix=block_gate.astype(np.uint16),
                target_eigenspace=target_space.astype(np.uint16),
                target_root=(np.asarray([], dtype=np.uint16) if target_root is None
                             else target_root.astype(np.uint16)),
            )
            block_ledger.append({
                "normal_exponent": normal_exponent,
                "target_exponent": target_exponent,
                "target_kind": target_kind,
                "derivative_rank": c3.rank_mod(
                    block.reshape(-1, len(records)), prime
                ),
                "payload": str(block_path.relative_to(HERE)),
            })
        extra_gate = np.concatenate(extra_rows, axis=0) % prime
        combined = np.concatenate([based_gate, extra_gate], axis=0) % prime
        base_rank = c3.rank_mod(base_gate, prime)
        based_rank = c3.rank_mod(based_gate, prime)
        combined_rank = c3.rank_mod(combined, prime)
        print(
            f"degree={degree} constantBase={base_rank} based={based_rank} "
            f"firstNormalExtra={combined_rank-based_rank} "
            f"combinedBased={combined_rank} "
            f"kernel={len(records)-combined_rank} blocks={block_ledger}",
            flush=True,
        )
        del (evaluator, dual_values, base_gate, based_gate, extra_rows,
             extra_gate, combined, block_values, block, derivative, dual_d)
        gc.collect()


if __name__ == "__main__":
    main()
