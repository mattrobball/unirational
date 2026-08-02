#!/usr/bin/env python3
"""Probe second-normal landing gates where p vanishes to order two on C3 line."""

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


def monomial_jet(values: np.ndarray, directions: np.ndarray, exponents,
                 prime: int, max_order: int = 2):
    def power_array(array: np.ndarray, exponent: int):
        result = np.ones_like(array, dtype=np.int64)
        for _ in range(exponent):
            result = result * array % prime
        return result

    shape = values.shape[:-1]
    answer = [np.ones(shape, dtype=np.int64)] + [
        np.zeros(shape, dtype=np.int64) for _ in range(max_order)
    ]
    for coordinate, exponent in enumerate(map(int, exponents)):
        if not exponent:
            continue
        a = values[..., coordinate]
        b = directions[..., coordinate]
        factor = [np.zeros(shape, dtype=np.int64) for _ in range(max_order + 1)]
        for order in range(min(exponent, max_order) + 1):
            factor[order] = (
                math.comb(exponent, order)
                * power_array(a, exponent - order)
                * power_array(b, order)
            ) % prime
        old = answer
        answer = [
            sum(
                (old[left] * factor[total - left] for left in range(total + 1)),
                np.zeros(shape, dtype=np.int64),
            ) % prime
            for total in range(max_order + 1)
        ]
    return answer


def dual_jets(evaluator: basis.DualEvaluator, records, direction: np.ndarray,
              max_order: int = 2):
    prime = evaluator.prime
    transformed_direction = np.einsum(
        "gij,j->gi", evaluator.module.GROUP, direction
    ) % prime
    directions = np.broadcast_to(
        transformed_direction, evaluator.transformed.shape
    )
    group_rows = np.asarray(evaluator.module.GROUP, dtype=np.int64)
    answer = [[] for _ in range(max_order + 1)]
    for record in records:
        jets = monomial_jet(
            evaluator.transformed, directions,
            tuple(map(int, record["reynolds_exponents"])), prime, max_order,
        )
        output = int(record["reynolds_output"])
        for order in range(max_order + 1):
            answer[order].append(jets[order] @ group_rows[:, output, :] % prime)
    return np.asarray(answer)


def polynomial_jets(polynomial, points: np.ndarray, direction: np.ndarray,
                    prime: int, max_order: int = 2):
    directions = np.broadcast_to(direction, points.shape)
    answer = [np.zeros(len(points), dtype=np.int64)
              for _ in range(max_order + 1)]
    for exponents, coefficient in polynomial.items():
        jets = monomial_jet(points, directions, exponents, prime, max_order)
        for order in range(max_order + 1):
            answer[order] = (
                answer[order] + int(coefficient) * jets[order]
            ) % prime
    return answer


def cross_jets(selected: np.ndarray, prime: int):
    # selected has shape (jet orders, 4 rows, points, 5).
    answer = []
    max_order = selected.shape[0] - 1
    for total in range(max_order + 1):
        value = np.zeros((selected.shape[2], 5), dtype=np.int64)
        for orders in itertools.product(range(max_order + 1), repeat=4):
            if sum(orders) != total:
                continue
            rows = np.asarray([selected[orders[row], row] for row in range(4)])
            value = (value + basis.cross4(rows, range(4), prime)) % prime
        answer.append(value)
    return answer


def cross_coefficient_values(records, dual_values: np.ndarray, points: np.ndarray,
                             direction: np.ndarray, prime: int, order: int):
    cross_cache = {}
    scalar_cache = {}
    columns = []
    for record in records:
        indices = tuple(map(int, record["dual_generator_indices"]))
        if indices not in cross_cache:
            cross_cache[indices] = cross_jets(
                dual_values[:, list(indices)], prime
            )
        multiplier = record["multiplier"]
        label = (
            int(multiplier["secondary_index"]),
            tuple(map(int, multiplier["primary_exponents"])),
        )
        if label not in scalar_cache:
            scalar_cache[label] = polynomial_jets(
                basis.invariant_polynomial(label), points, direction, prime, order
            )
        cross = cross_cache[indices]
        scalar = scalar_cache[label]
        columns.append(sum(
            (scalar[left][:, None] * cross[order - left]
             for left in range(order + 1)),
            np.zeros_like(cross[0]),
        ) % prime)
    return np.asarray(columns).transpose(1, 2, 0)


def second_cross_values(records, dual_values: np.ndarray, points: np.ndarray,
                        direction: np.ndarray, prime: int):
    return cross_coefficient_values(
        records, dual_values, points, direction, prime, 2
    )


def first_derivative_paths(degree: int, prime: int):
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
    parser.add_argument("--normal-exponent", type=int, required=True, choices=(0, 2))
    args = parser.parse_args()
    prime = args.prime
    degree = args.degree
    c3.P = prime
    c3.ZETA = args.zeta
    module = basis.module_at(prime, args.zeta)
    omega, generator, eigenspaces, stabilizer, roots, fixed_roots = c3.c3_geometry(module)
    eigenspaces[0] = c3.nullspace_mod(
        generator - np.eye(5, dtype=np.int64), prime
    )
    dimension = {31: 198, 35: 361}[degree]
    records = json.loads(
        (HERE / f"degree_{degree}/m1_cross_basis_circuits.json").read_text()
    )["basis"]
    dual_records = json.loads(
        (HERE / "dual_hironaka_generators.json").read_text()
    )["generators"]
    source = eigenspaces[1]
    points = np.asarray([
        (source[0] + parameter * source[1]) % prime
        for parameter in range(degree - 1)
    ], dtype=np.int64)
    if args.normal_exponent == 0:
        directions = eigenspaces[0]
    else:
        left, right = eigenspaces[2]
        directions = np.asarray([left, right, (left + right) % prime])
    target_exponent = (degree - 2 + 2 * args.normal_exponent) % 3
    target_space = eigenspaces[target_exponent]
    if len(target_space) == 1:
        assert c3.klein(target_space[0]) != 0
        target_kind = "zero"
        target_root = None
    else:
        target_kind = "fixed-root"
        target_root = fixed_roots[target_exponent][0]
    values = []
    gate_rows = []
    evaluator = basis.DualEvaluator(module, points, prime)
    for index, direction in enumerate(directions):
        print(f"direction {index+1}/{len(directions)}", flush=True)
        dual_values = dual_jets(evaluator, dual_records, direction)
        second = second_cross_values(records, dual_values, points, direction, prime)
        assert np.array_equal(
            np.einsum("ij,pjk->pik", generator, second) % prime,
            pow(omega, target_exponent, prime) * second % prime,
        )
        values.append(second)
        if target_kind == "zero":
            gate_rows.append(second.reshape(-1, dimension))
        else:
            gate_rows.append(c3.landing_constant_matrix(second, target_root))
    values = np.concatenate(values, axis=0)
    second_gate = np.concatenate(gate_rows, axis=0) % prime

    c3_path = HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz"
    with np.load(c3_path, allow_pickle=False) as frozen:
        line_values = frozen["basis_values"].astype(np.int64).reshape(-1, dimension)
    first_values = []
    for path in first_derivative_paths(degree, prime):
        with np.load(path, allow_pickle=False) as frozen:
            first_values.append(
                frozen["derivative_values"].astype(np.int64).reshape(-1, dimension)
            )
    second_based = np.concatenate([line_values, *first_values], axis=0) % prime
    based_rank = c3.rank_mod(second_based, prime)
    combined_rank = c3.rank_mod(
        np.concatenate([second_based, second_gate], axis=0), prime
    )
    expected_based = {31: 68, 35: 72}[degree]
    assert based_rank == expected_based
    output = (
        HERE / f"degree_{degree}/c3_second_normal_exp{args.normal_exponent}_p{prime}.npz"
    )
    np.savez_compressed(
        output,
        source_points=points.astype(np.uint16),
        normal_directions=directions.astype(np.uint16),
        second_normal_values=values.astype(np.uint16),
        extra_gate_matrix=second_gate.astype(np.uint16),
        target_eigenspace=target_space.astype(np.uint16),
        target_root=(np.asarray([], dtype=np.uint16) if target_root is None
                     else target_root.astype(np.uint16)),
    )
    print(
        f"p={prime} d={degree} exp={args.normal_exponent}: "
        f"secondBasedRank={based_rank} extra={combined_rank-based_rank} "
        f"combined={combined_rank} kernel={dimension-combined_rank} "
        f"target={target_kind}",
        flush=True,
    )


if __name__ == "__main__":
    main()
