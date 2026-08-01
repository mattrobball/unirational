#!/usr/bin/env python3
"""Independent semantic and linear-algebra audit of the global modules."""

from __future__ import annotations

import importlib.util
import json
import math
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]
RECONSTRUCTOR = E_ROOT / "tmp/degree13_opt/reconstruct_large_prime.py"
ZETAS = {89: 78, 199: 61}
EXPECTED = {
    25: (189, 59, 16, 43),
    31: (410, 198, 22, 176),
    35: (637, 361, 26, 335),
}

import verify_ansatz as linear  # noqa: E402


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def module_at(prime):
    wrapper = load(f"verify_cov_reconstructor_{prime}", RECONSTRUCTOR)
    return wrapper.load_module(prime, ZETAS[prime])


def batch_evaluate(module, seeds, points, prime, chunk=40):
    pieces = []
    for start in range(0, len(points), chunk):
        block = np.asarray(points[start:start + chunk], dtype=np.int64) % prime
        transformed = np.einsum("gij,pj->pgi", module.GROUP, block) % prime
        cache = {}

        def power(coordinate, exponent):
            key = (coordinate, exponent)
            if key not in cache:
                value = np.ones(transformed.shape[:2], dtype=np.int64)
                for _ in range(exponent):
                    value = value * transformed[:, :, coordinate] % prime
                cache[key] = value
            return cache[key]

        columns = []
        for seed in seeds:
            values = np.ones(transformed.shape[:2], dtype=np.int64)
            for coordinate, exponent in enumerate(seed.exponents):
                if exponent:
                    values = values * power(coordinate, exponent) % prime
            columns.append((values @ module.INVERSES[:, :, seed.output] % prime).reshape(-1))
        pieces.append(np.column_stack(columns).astype(np.int32))
    return np.vstack(pieces)


def nullspace_small(matrix, prime):
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    pivots = []
    row = 0
    for column in range(value.shape[1]):
        choices = np.flatnonzero(value[row:, column])
        if not len(choices):
            continue
        pivot = row + int(choices[0])
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, prime) % prime
        for other in range(value.shape[0]):
            if other != row and value[other, column]:
                value[other] = (value[other] - value[other, column] * value[row]) % prime
        pivots.append(column)
        row += 1
    free = [column for column in range(value.shape[1]) if column not in pivots]
    result = []
    for column in free:
        vector = np.zeros(value.shape[1], dtype=np.int64)
        vector[column] = 1
        for r, pivot in enumerate(pivots):
            vector[pivot] = -value[r, column] % prime
        result.append(vector)
    return np.asarray(result, dtype=np.int64)


def inverse_mod(matrix, prime):
    n = len(matrix)
    value = np.concatenate(
        [np.asarray(matrix, dtype=np.int64) % prime, np.eye(n, dtype=np.int64)], axis=1
    )
    for column in range(n):
        pivot = next(row for row in range(column, n) if value[row, column])
        value[[column, pivot]] = value[[pivot, column]]
        value[column] = value[column] * pow(int(value[column, column]), -1, prime) % prime
        for row in range(n):
            if row != column and value[row, column]:
                value[row] = (value[row] - value[row, column] * value[column]) % prime
    return value[:, n:]


def joint_basis(module, prime):
    identity = np.eye(5, dtype=np.int64)
    first = module.A % prime
    candidates = []
    for matrix in module.GROUP:
        matrix = np.asarray(matrix, dtype=np.int64) % prime
        if (
            not np.array_equal(matrix, identity)
            and not np.array_equal(matrix, first)
            and np.array_equal(matrix @ matrix % prime, identity)
            and np.array_equal(matrix @ first % prime, first @ matrix % prime)
        ):
            candidates.append(matrix)
    assert len(candidates) == 6
    second = min(candidates, key=lambda matrix: bytes(matrix.astype(np.uint8).flat))
    spaces = []
    for s1, s2 in ((1, 1), (1, -1), (-1, 1), (-1, -1)):
        spaces.append(nullspace_small(np.vstack((first - s1 * identity, second - s2 * identity)), prime))
    assert [len(space) for space in spaces] == [2, 1, 1, 1]
    basis = np.column_stack([vector for space in spaces for vector in space]) % prime
    return basis, inverse_mod(basis, prime)


def order2_subset_by_interpolation(module, seeds, degree, prime):
    basis, basis_inverse = joint_basis(module, prime)
    records = (((0, 1, 1), 2), ((1, 0, 1), 3), ((1, 1, 0), 4))
    vandermonde = np.asarray(
        [[pow(value, exponent, prime) for exponent in range(degree + 1)] for value in range(degree + 1)],
        dtype=np.int64,
    )
    weight2 = inverse_mod(vandermonde, prime)[2]
    blocks = []
    for direction, target in records:
        points = []
        for t in range(degree - 1):
            for scalar in range(degree + 1):
                local = np.asarray([1, t, *(scalar * entry for entry in direction)], dtype=np.int64)
                points.append(basis @ local % prime)
        evaluated = batch_evaluate(module, seeds, np.asarray(points), prime).reshape(
            degree - 1, degree + 1, 5, len(seeds)
        )
        adapted = np.einsum("ab,tsbc->tsac", basis_inverse, evaluated) % prime
        coefficient = np.einsum("s,tsac->tac", weight2, adapted) % prime
        blocks.append(coefficient[:, target, :])
    return np.vstack(blocks).astype(np.int32)


def higher_subset_by_interpolation(
    module, seeds, plus, minus, bases_coeff, normal_coeff, degree, prime
):
    bases = bases_coeff @ plus % prime
    normals = normal_coeff @ minus % prime
    points = np.asarray(
        [
            (base + scalar * normal) % prime
            for base, normal in zip(bases, normals)
            for scalar in range(degree + 1)
        ],
        dtype=np.int64,
    )
    evaluated = batch_evaluate(module, seeds, points, prime).reshape(
        len(bases), degree + 1, 5, len(seeds)
    )
    vandermonde = np.asarray(
        [[pow(value, exponent, prime) for exponent in range(degree + 1)] for value in range(degree + 1)],
        dtype=np.int64,
    )
    weights = inverse_mod(vandermonde, prime)
    first = np.einsum("s,nsvc->nvc", weights[1], evaluated) % prime
    second = np.einsum("s,nsvc->nvc", weights[2], evaluated) % prime
    return np.concatenate((first.reshape(-1, len(seeds)), second.reshape(-1, len(seeds)))).astype(np.int32)


def main() -> None:
    summary = json.loads((HERE / "global_modules_summary.json").read_text())
    for degree, expected in EXPECTED.items():
        seed_path = HERE / f"degree_{degree}/covariant_basis_seeds.json"
        records = json.loads(seed_path.read_text())
        assert len(records) == expected[0]
        assert all(sum(map(int, record["exponents"])) == degree for record in records)
        for result in summary[str(degree)]["prime_results"]:
            prime = int(result["prime"])
            module = module_at(prime)
            seeds = [
                module.ReynoldsSeed(int(record["output"]), tuple(map(int, record["exponents"])))
                for record in records
            ]
            path = HERE / f"degree_{degree}/{result['payload']}"
            assert linear.sha256(path) == result["payload_sha256"]
            with np.load(path) as data:
                arrays = {name: data[name].astype(np.int64) for name in data.files}

            rebuilt_generic = batch_evaluate(module, seeds, arrays["generic_points"], prime)
            assert np.array_equal(rebuilt_generic, arrays["basis_evaluations"])
            assert linear.rank_mod(rebuilt_generic, prime) == expected[0]

            plus = arrays["plus_basis"]
            minus = arrays["minus_basis"]
            assert not np.any((module.A - np.eye(5, dtype=np.int64)) @ plus.T % prime)
            assert not np.any((module.A + np.eye(5, dtype=np.int64)) @ minus.T % prime)
            plane_points = np.asarray(
                [
                    (plus[0] + i * plus[1] + j * plus[2]) % prime
                    for i in range(degree + 1)
                    for j in range(degree + 1 - i)
                ],
                dtype=np.int64,
            )
            rebuilt_restriction = batch_evaluate(module, seeds, plane_points, prime)
            assert np.array_equal(rebuilt_restriction, arrays["restriction"])
            restriction_rank = linear.rank_mod(rebuilt_restriction, prime)
            arrangement = arrays["arrangement_basis"]
            assert restriction_rank == result["restriction_rank"]
            assert linear.rank_mod(arrangement, prime) == expected[1]
            assert not np.any(rebuilt_restriction @ arrangement.T % prime)

            # Semantically rebuild 12 spread columns of the common-order-two map.
            selected = np.unique(np.linspace(0, len(seeds) - 1, 12, dtype=int))
            rebuilt_order2 = order2_subset_by_interpolation(
                module, [seeds[index] for index in selected], degree, prime
            )
            assert np.array_equal(rebuilt_order2, arrays["order2_seed_map"][:, selected] % prime)
            order2_arr = arrays["order2_arrangement_map"]
            assert np.array_equal(order2_arr % prime, arrays["order2_seed_map"] @ arrangement.T % prime)
            assert linear.rank_mod(order2_arr, prime) == expected[2]
            strict_arr = arrays["strict_in_arrangement"]
            strict_cov = arrays["strict_in_covariants"]
            assert linear.rank_mod(strict_arr, prime) == expected[3]
            assert not np.any(order2_arr @ strict_arr.T % prime)
            assert np.array_equal(strict_cov % prime, strict_arr @ arrangement % prime)

            selected_higher = np.unique(np.linspace(0, len(seeds) - 1, 12, dtype=int))
            rebuilt_higher = higher_subset_by_interpolation(
                module,
                [seeds[index] for index in selected_higher],
                plus,
                minus,
                arrays["higher_jet_base_coefficients"],
                arrays["higher_jet_normal_coefficients"],
                degree,
                prime,
            )
            assert np.array_equal(
                rebuilt_higher,
                arrays["higher_jet_seed_map"][:, selected_higher] % prime,
            )
            higher_arr = arrays["higher_jet_arrangement_map"]
            assert np.array_equal(
                higher_arr % prime,
                arrays["higher_jet_seed_map"] @ arrangement.T % prime,
            )
            assert linear.rank_mod(higher_arr, prime) == expected[1]
            assert result["plane_order_at_least_3_dimension"] == 0
            print(
                f"verified module degree={degree} prime={prime} "
                f"M={expected[0]} Arr={expected[1]} strict={expected[3]}",
                flush=True,
            )
    print("COV_GLOBAL_MODULES_VERIFIED")


if __name__ == "__main__":
    main()
