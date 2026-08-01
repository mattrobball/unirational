#!/usr/bin/env python3
"""Independently verify selected Molien coefficients by modular group sums."""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
TARGETS = (25, 31, 35, 75, 93, 105)
PRIMES = ((199, 61), (353, 58))


def load_module(prime: int, zeta: int):
    path = PROBLEM / "tmp/degree13_opt/reconstruct_large_prime.py"
    spec = importlib.util.spec_from_file_location(f"ranking_recon_{prime}", path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module.load_module(prime, zeta)


def inverse(matrix: np.ndarray, prime: int) -> np.ndarray:
    n = len(matrix)
    value = np.column_stack((matrix.astype(np.int64) % prime, np.eye(n, dtype=np.int64)))
    for column in range(n):
        pivot = next(row for row in range(column, n) if value[row, column])
        value[[column, pivot]] = value[[pivot, column]]
        value[column] = value[column] * pow(int(value[column, column]), -1, prime) % prime
        for row in range(n):
            if row != column and value[row, column]:
                value[row] = (value[row] - value[row, column] * value[column]) % prime
    return value[:, n:]


def denominator(matrix: np.ndarray, prime: int) -> list[int]:
    """det(I-tA) via Newton identities only through degree five."""

    traces = [0] * 6
    power = np.eye(5, dtype=np.int64)
    for degree in range(1, 6):
        power = power @ matrix % prime
        traces[degree] = int(np.trace(power) % prime)
    elementary = [0] * 6
    elementary[0] = 1
    for degree in range(1, 6):
        total = sum(
            (-1) ** (index - 1) * elementary[degree - index] * traces[index]
            for index in range(1, degree + 1)
        )
        elementary[degree] = total * pow(degree, -1, prime) % prime
    return [elementary[degree] * ((-1) ** degree) % prime for degree in range(6)]


def inverse_series(denominator_coefficients: list[int], limit: int, prime: int) -> list[int]:
    values = [0] * (limit + 1)
    values[0] = 1
    for degree in range(1, limit + 1):
        values[degree] = -sum(
            denominator_coefficients[index] * values[degree - index]
            for index in range(1, min(5, degree) + 1)
        ) % prime
    return values


def group_sum(prime: int, zeta: int) -> tuple[list[int], list[int]]:
    module = load_module(prime, zeta)
    limit = max(TARGETS)
    invariants = np.zeros(limit + 1, dtype=np.int64)
    covariants = np.zeros(limit + 1, dtype=np.int64)
    for matrix in module.GROUP:
        matrix = np.asarray(matrix, dtype=np.int64) % prime
        series = np.asarray(inverse_series(denominator(matrix, prime), limit, prime), dtype=np.int64)
        invariants = (invariants + series) % prime
        trace_inverse = int(np.trace(inverse(matrix, prime)) % prime)
        covariants = (covariants + trace_inverse * series) % prime
    scale = pow(660, -1, prime)
    return (invariants * scale % prime).tolist(), (covariants * scale % prime).tolist()


def main() -> None:
    payload = json.loads((HERE / "degree_ranking.json").read_text())
    expected_inv = {
        record["degree"]: record["invariant_dimension"] for record in payload["ranking"]
    }
    expected_inv.update(
        {3 * record["degree"]: record["landing_target_invariant_dimension"] for record in payload["ranking"]}
    )
    expected_cov = {
        record["degree"]: record["self_covariant_dimension"] for record in payload["ranking"]
    }
    for prime, zeta in PRIMES:
        invariants, covariants = group_sum(prime, zeta)
        for degree, value in expected_inv.items():
            assert invariants[degree] == value % prime, (prime, degree, invariants[degree], value)
        for degree, value in expected_cov.items():
            assert covariants[degree] == value % prime, (prime, degree, covariants[degree], value)
        print(f"verified Molien residues at p={prime}", flush=True)
    print("COV_DEGREE_RANKING_VERIFIED")


if __name__ == "__main__":
    main()

