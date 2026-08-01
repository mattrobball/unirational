#!/usr/bin/env python3
"""Independent p=89 reconstruction of the selected global jet kernels.

This verifier does not import the split-p=67 jet implementation.  It builds
the order-660 group at another cyclotomic specialization, evaluates the
saved exact Reynolds seed circuits, and reconstructs every normal Taylor
coefficient by the multinomial formula.
"""

from __future__ import annotations

import argparse
import importlib.util
import itertools
import json
import math
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PRIME = 89
ZETA = 78
SELECTED = {25: (3, 7), 31: (5, 1), 35: (5, 5)}


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def load_group():
    builder = load(
        "cov_structured_holdout_group_builder",
        PROBLEM / "tmp" / "degree13_opt" / "reconstruct_large_prime.py",
    )
    return builder.load_module(PRIME, ZETA)


def rref(matrix: np.ndarray) -> tuple[np.ndarray, list[int]]:
    value = np.asarray(matrix, dtype=np.int64).copy() % PRIME
    rows, columns = value.shape
    pivots: list[int] = []
    pivot_row = 0
    for column in range(columns):
        candidates = np.flatnonzero(value[pivot_row:, column])
        if not len(candidates):
            continue
        selected = pivot_row + int(candidates[0])
        value[[pivot_row, selected]] = value[[selected, pivot_row]]
        value[pivot_row] = (
            value[pivot_row] * pow(int(value[pivot_row, column]), -1, PRIME)
        ) % PRIME
        active = np.flatnonzero(value[:, column])
        active = active[active != pivot_row]
        if len(active):
            value[active] = (
                value[active]
                - value[active, column, None] * value[pivot_row][None, :]
            ) % PRIME
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    return value, pivots


def rank(matrix: np.ndarray) -> int:
    return len(rref(matrix)[1])


def right_nullspace(matrix: np.ndarray) -> np.ndarray:
    reduced, pivots = rref(matrix)
    columns = matrix.shape[1]
    free = [column for column in range(columns) if column not in pivots]
    if not free:
        return np.zeros((0, columns), dtype=np.int64)
    answer = []
    for free_column in free:
        vector = np.zeros(columns, dtype=np.int64)
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row, free_column] % PRIME
        answer.append(vector)
    result = np.stack(answer)
    assert not np.any(np.asarray(matrix, dtype=np.int64) @ result.T % PRIME)
    return result


def eigenspace(matrix: np.ndarray, eigenvalue: int) -> np.ndarray:
    return right_nullspace(
        (np.asarray(matrix, dtype=np.int64) - eigenvalue * np.eye(5, dtype=np.int64))
        % PRIME
    )


def triangular_grid(plus: np.ndarray, degree: int):
    parameters = np.array(
        [(i, j) for i in range(degree + 1) for j in range(degree + 1 - i)],
        dtype=np.int64,
    )
    points = np.array(
        [(plus[0] + i * plus[1] + j * plus[2]) % PRIME for i, j in parameters],
        dtype=np.int64,
    )
    return parameters, points


def weak_compositions(total: int, slots: int):
    if slots == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for tail in weak_compositions(total - first, slots - 1):
            yield (first,) + tail


def prove_unisolvent(parameters: np.ndarray, degree: int) -> None:
    monomials = tuple(weak_compositions(degree, 3))
    matrix = np.array(
        [
            [
                pow(int(i), exponents[1], PRIME)
                * pow(int(j), exponents[2], PRIME)
                % PRIME
                for exponents in monomials
            ]
            for i, j in parameters
        ],
        dtype=np.int64,
    )
    assert matrix.shape == (math.comb(degree + 2, 2),) * 2
    assert rank(matrix) == len(monomials)


def batch_seed_evaluations(module, seeds, points: np.ndarray) -> np.ndarray:
    transformed = np.einsum("gij,pj->pgi", module.GROUP, points) % PRIME
    powers: dict[tuple[int, int], np.ndarray] = {}

    def power(coordinate: int, exponent: int):
        key = (coordinate, exponent)
        if key not in powers:
            value = np.ones(transformed.shape[:2], dtype=np.int64)
            for _ in range(exponent):
                value = value * transformed[:, :, coordinate] % PRIME
            powers[key] = value
        return powers[key]

    columns = []
    for seed in seeds:
        values = np.ones(transformed.shape[:2], dtype=np.int64)
        for coordinate, exponent in enumerate(seed.exponents):
            if exponent:
                values = values * power(coordinate, exponent) % PRIME
        columns.append((values @ module.INVERSES[:, :, seed.output] % PRIME).reshape(-1))
    return np.column_stack(columns).astype(np.int64) % PRIME


def normal_directions(minus: np.ndarray, order: int) -> np.ndarray:
    return np.array(
        [(minus[0] + scalar * minus[1]) % PRIME for scalar in range(order + 1)],
        dtype=np.int64,
    )


def jet_matrix(module, seeds, plus, minus, degree: int, order: int) -> np.ndarray:
    if order == 0:
        parameters, points = triangular_grid(plus, degree)
        prove_unisolvent(parameters, degree)
        return batch_seed_evaluations(module, seeds, points)

    parameters, base_points = triangular_grid(plus, degree - order)
    prove_unisolvent(parameters, degree - order)
    directions = normal_directions(minus, order)
    vandermonde = np.array(
        [[pow(s, exponent, PRIME) for exponent in range(order + 1)] for s in range(order + 1)],
        dtype=np.int64,
    )
    assert rank(vandermonde) == order + 1

    transformed_base = np.einsum("gij,pj->pgi", module.GROUP, base_points) % PRIME
    transformed_normal = np.einsum("gij,nj->ngi", module.GROUP, directions) % PRIME
    base_powers: dict[tuple[int, int], np.ndarray] = {}
    normal_powers: dict[tuple[int, int], np.ndarray] = {}

    def base_power(coordinate: int, exponent: int):
        key = (coordinate, exponent)
        if key not in base_powers:
            value = np.ones(transformed_base.shape[:2], dtype=np.int64)
            for _ in range(exponent):
                value = value * transformed_base[:, :, coordinate] % PRIME
            base_powers[key] = value
        return base_powers[key]

    def normal_power(coordinate: int, exponent: int):
        key = (coordinate, exponent)
        if key not in normal_powers:
            value = np.ones(transformed_normal.shape[:2], dtype=np.int64)
            for _ in range(exponent):
                value = value * transformed_normal[:, :, coordinate] % PRIME
            normal_powers[key] = value
        return normal_powers[key]

    splittings = tuple(weak_compositions(order, 5))
    columns = []
    for seed in seeds:
        coefficient = np.zeros(
            (len(base_points), len(directions), len(module.GROUP)), dtype=np.int64
        )
        for picked in splittings:
            if any(k > exponent for k, exponent in zip(picked, seed.exponents)):
                continue
            scalar = 1
            term = np.ones_like(coefficient)
            for coordinate, (exponent, k) in enumerate(zip(seed.exponents, picked)):
                scalar = scalar * math.comb(exponent, k) % PRIME
                term = term * base_power(coordinate, exponent - k)[:, None, :] % PRIME
                term = term * normal_power(coordinate, k)[None, :, :] % PRIME
            coefficient = (coefficient + scalar * term) % PRIME
        evaluated = np.einsum(
            "png,gk->pnk", coefficient, module.INVERSES[:, :, seed.output]
        ) % PRIME
        columns.append(evaluated.reshape(-1))
    return np.column_stack(columns).astype(np.int64) % PRIME


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("degree", type=int, choices=tuple(SELECTED))
    args = parser.parse_args()
    degree = args.degree
    plane_order, residual = SELECTED[degree]
    discovery = json.loads(
        (HERE / f"degree_{degree}" / "global_jets_p67.json").read_text()
    )
    records = json.loads(
        (HERE / f"degree_{degree}" / "covariant_basis_seeds.json").read_text()
    )

    module = load_group()
    assert len(module.GROUP) == 660
    seeds = [
        module.ReynoldsSeed(int(item["output"]), tuple(map(int, item["exponents"])))
        for item in records
    ]
    assert len(seeds) == discovery["self_covariant_dimension"]
    plus = eigenspace(module.A, 1)
    minus = eigenspace(module.A, -1)
    assert (len(plus), len(minus)) == (3, 2)

    rng = np.random.default_rng(202608018900 + degree)
    points = np.array(
        [
            rng.integers(0, PRIME, size=5, dtype=np.int64)
            for _ in range(math.ceil(len(seeds) / 5) + 14)
        ],
        dtype=np.int64,
    )
    basis_rank = rank(batch_seed_evaluations(module, seeds, points))
    assert basis_rank == len(seeds)

    remaining = np.eye(len(seeds), dtype=np.int64)
    holdout_records = []
    for order in range(plane_order):
        matrix = jet_matrix(module, seeds, plus, minus, degree, order)
        restricted = matrix @ remaining.T % PRIME
        jet_rank = rank(restricted)
        relative = right_nullspace(restricted)
        remaining = relative @ remaining % PRIME
        record = {
            "order": order,
            "input_dimension": int(restricted.shape[1]),
            "jet_rank": int(jet_rank),
            "kernel_dimension": int(len(remaining)),
            "unisolvent_rows": int(matrix.shape[0]),
        }
        holdout_records.append(record)
        print(
            f"p=89 d={degree} jet={order} input={record['input_dimension']} "
            f"rank={jet_rank} kernel={len(remaining)}",
            flush=True,
        )
        assert record == discovery["orders"][order]
        if not len(remaining):
            break

    assert not len(remaining)
    payload = {
        "schema": "COV_GLOBAL_JETS_HOLDOUT_V1",
        "prime": PRIME,
        "zeta11": ZETA,
        "degree": degree,
        "plane_order": plane_order,
        "residual_degree": residual,
        "group_order": len(module.GROUP),
        "basis_rank": basis_rank,
        "orders": holdout_records,
        "agrees_with_p67": True,
        "selected_symbolic_kernel_dimension": 0,
    }
    (HERE / f"degree_{degree}" / "global_jets_p89.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print(f"COV_GLOBAL_JETS_HOLDOUT_VERIFIED degree={degree}")


if __name__ == "__main__":
    main()
