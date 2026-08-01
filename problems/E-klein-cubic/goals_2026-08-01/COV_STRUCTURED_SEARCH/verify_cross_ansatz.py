#!/usr/bin/env python3
"""Independent replay of the invariant-gradient cross-product ansatz."""

from __future__ import annotations

import itertools
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]
sys.path.insert(0, str(E_ROOT / "tmp/generic_twist"))
sys.path.insert(0, str(E_ROOT / "tmp/kproj_arithmetic"))

import phi_coefficients as phi  # noqa: E402
import core as invcore  # noqa: E402
import verify_ansatz as base  # noqa: E402


def derivative(polynomial, variable):
    answer = {}
    for exponents, coefficient in polynomial.items():
        if exponents[variable]:
            lowered = list(exponents)
            lowered[variable] -= 1
            answer[tuple(lowered)] = coefficient * exponents[variable]
    return answer


def gradient_data():
    forms = invcore.forms()
    return {
        f"I{degree}": [derivative(forms[degree], variable) for variable in range(5)]
        for degree in (3, 5, 6, 7, 8, 9)
    }


def determinant(matrix, prime):
    answer = 0
    for permutation in itertools.permutations(range(4)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(4) for j in range(i + 1, 4)
        )
        term = 1
        for row, column in enumerate(permutation):
            term = term * matrix[row][column] % prime
        answer += -term if inversions % 2 else term
    return answer % prime


def cross(names, gradients, point, prime):
    rows = [
        [base.eval_poly(polynomial, point, prime) for polynomial in gradients[name]]
        for name in names
    ]
    values = []
    for omitted in range(5):
        minor = [[row[column] for column in range(5) if column != omitted] for row in rows]
        value = determinant(minor, prime)
        values.append(value if omitted % 2 == 0 else -value)
    return np.asarray(values, dtype=np.int64) % prime


def multiplier(record):
    secondary = int(record["secondary_index"])
    exponents = tuple(map(int, record["primary_exponents"]))
    assert record["secondary_name"] == invcore.SECONDARY_NAMES[secondary]
    assert record["secondary_degree"] == invcore.SECONDARY_DEGREES[secondary]
    return phi.multiply(
        invcore.primary_monomial(exponents),
        invcore.secondary_polynomials()[secondary],
    )


def direction_values(payload, gradients, point, prime):
    answer = []
    for record in payload["directions"]:
        vector = cross(record["gradient_invariants"], gradients, point, prime)
        scalar = base.eval_poly(multiplier(record["multiplier"]), point, prime)
        answer.append(vector * scalar % prime)
    return np.asarray(answer, dtype=np.int64)


def cubic_row(vectors, prime):
    n = len(vectors)
    answer = []
    for triple in itertools.combinations_with_replacement(range(n), 3):
        counts = {index: triple.count(index) for index in set(triple)}
        if len(counts) == 1:
            u = vectors[triple[0]]
            value = sum(int(u[i]) ** 2 * int(u[(i + 1) % 5]) for i in range(5))
        elif len(counts) == 2:
            repeated = next(index for index, count in counts.items() if count == 2)
            singleton = next(index for index, count in counts.items() if count == 1)
            u, v = vectors[repeated], vectors[singleton]
            value = sum(
                int(u[i]) ** 2 * int(v[(i + 1) % 5])
                + 2 * int(u[i]) * int(v[i]) * int(u[(i + 1) % 5])
                for i in range(5)
            )
        else:
            u, v, w = (vectors[index] for index in triple)
            value = 2 * sum(
                int(u[i]) * int(v[i]) * int(w[(i + 1) % 5])
                + int(u[i]) * int(w[i]) * int(v[(i + 1) % 5])
                + int(v[i]) * int(w[i]) * int(u[(i + 1) % 5])
                for i in range(5)
            )
        answer.append(value % prime)
    return np.asarray(answer, dtype=np.int32)


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
    return np.asarray(result)


def main() -> None:
    summary = json.loads((HERE / "cross_ansatz_summary.json").read_text())
    gradients = gradient_data()
    for degree in (25, 31, 35):
        path = HERE / f"degree_{degree}/cross_ansatz.json"
        payload = json.loads(path.read_text())
        assert payload == summary[str(degree)]
        for record in payload["prime_records"]:
            prime = int(record["prime"])
            data_path = path.parent / record["payload"]
            assert base.sha256(data_path) == record["payload_sha256"]
            with np.load(data_path) as frozen:
                points = frozen["points"].astype(np.int64)
                stored = frozen["rows"].astype(np.int32)
            rebuilt = np.vstack(
                [cubic_row(direction_values(payload, gradients, point, prime), prime) for point in points]
            )
            assert np.array_equal(rebuilt, stored)
            assert base.rank_mod(rebuilt, prime) == record["rank"] == payload["symmetric_cube_dimension"]

            # Independent fixed-plane check on three points of the plus-space.
            S, _T = base.generators(prime)
            plus = nullspace_small(S - np.eye(5, dtype=np.int64), prime)
            assert plus.shape == (3, 5)
            rng = np.random.default_rng(2026082000 + degree + prime)
            for _ in range(3):
                point = rng.integers(0, prime, size=3, dtype=np.int64) @ plus % prime
                assert not np.any(direction_values(payload, gradients, point, prime))
            print(f"verified cross degree={degree} prime={prime} rank={record['rank']}", flush=True)
        assert payload["characteristic_zero_conclusion"] == "empty_projective_arrangement_ansatz"
    print("COV_CROSS_ANSATZ_VERIFIED")


if __name__ == "__main__":
    main()
