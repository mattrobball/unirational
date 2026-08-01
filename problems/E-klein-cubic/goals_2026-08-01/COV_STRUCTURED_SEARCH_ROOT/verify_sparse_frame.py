#!/usr/bin/env python3
"""Independent replay of the structured sparse-frame search.

Unlike the producer, this verifier never reads the pre-expanded 35 polar
coefficient polynomials.  It expands the Klein cubic directly from the three
scaled vector values at every source point and then recomputes every rank and
witness digest.
"""

from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path
import random
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
sys.path.insert(0, str(PROBLEM / "tmp/generic_twist"))
sys.path.insert(0, str(PROBLEM / "tmp/kproj_arithmetic"))

from phi_coefficients import all_coefficients, evaluate, evaluate_vector  # noqa: E402
import core as invariant_core  # noqa: E402


DEGREES = (25, 31, 35)
FRAME_DEGREES = (1, 4, 5, 6, 7)
PRIMARY_DEGREES = (3, 5, 6, 8, 11)
PRIMES = (89, 199)
POINT_COUNT = 24
PARAMETER_MONOMIALS = tuple(itertools.combinations_with_replacement(range(3), 3))
PARAMETER_EXPONENTS = tuple(
    tuple(indices.count(variable) for variable in range(3))
    for indices in PARAMETER_MONOMIALS
)


def weighted_monomials(total: int) -> tuple[tuple[int, ...], ...]:
    answer: list[tuple[int, ...]] = []

    def visit(index: int, remaining: int, prefix: list[int]) -> None:
        if index == len(PRIMARY_DEGREES):
            if remaining == 0:
                answer.append(tuple(prefix))
            return
        weight = PRIMARY_DEGREES[index]
        for exponent in range(remaining // weight + 1):
            prefix.append(exponent)
            visit(index + 1, remaining - exponent * weight, prefix)
            prefix.pop()

    visit(0, total, [])
    return tuple(answer)


def primitive_tuple(rows: tuple[tuple[int, ...], ...]) -> bool:
    return all(min(row[column] for row in rows) == 0 for column in range(5))


def rank_and_row_witness(matrix: np.ndarray, prime: int) -> tuple[int, tuple[int, ...], int]:
    value = np.asarray(matrix, dtype=np.int64).T.copy() % prime
    rank = 0
    pivots: list[int] = []
    determinant = 1
    for column in range(value.shape[1]):
        pivot = next((row for row in range(rank, value.shape[0]) if value[row, column]), None)
        if pivot is None:
            continue
        if pivot != rank:
            value[[rank, pivot]] = value[[pivot, rank]]
            determinant = -determinant
        entry = int(value[rank, column]) % prime
        determinant = determinant * entry % prime
        value[rank] = value[rank] * pow(entry, -1, prime) % prime
        for row in range(rank + 1, value.shape[0]):
            if value[row, column]:
                value[row] = (value[row] - value[row, column] * value[rank]) % prime
        pivots.append(column)
        rank += 1
        if rank == value.shape[0]:
            break
    return (rank, tuple(pivots), determinant % prime if rank == value.shape[0] else 0)


def kernel_line(matrix: np.ndarray, prime: int) -> tuple[int, ...]:
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    row = 0
    pivots: list[int] = []
    for column in range(10):
        pivot = next((index for index in range(row, len(value)) if value[index, column]), None)
        if pivot is None:
            continue
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, prime) % prime
        for index in range(len(value)):
            if index != row and value[index, column]:
                value[index] = (value[index] - value[index, column] * value[row]) % prime
        pivots.append(column)
        row += 1
        if row == 9:
            break
    assert len(pivots) == 9
    free = next(column for column in range(10) if column not in pivots)
    vector = np.zeros(10, dtype=np.int64)
    vector[free] = 1
    for index, pivot in enumerate(pivots):
        vector[pivot] = -value[index, free] % prime
    assert not np.any(np.asarray(matrix, dtype=np.int64) @ vector % prime)
    return tuple(map(int, vector))


def nonveronese_witness(vector: tuple[int, ...], prime: int):
    products: dict[tuple[int, ...], tuple[int, int, int]] = {}
    for left in range(10):
        for right in range(left, 10):
            exponent_sum = tuple(
                PARAMETER_EXPONENTS[left][index] + PARAMETER_EXPONENTS[right][index]
                for index in range(3)
            )
            product = vector[left] * vector[right] % prime
            if exponent_sum in products:
                old_left, old_right, old_product = products[exponent_sum]
                difference = (old_product - product) % prime
                if difference:
                    return {
                        "first_pair": [old_left, old_right],
                        "second_pair": [left, right],
                        "exponent_sum": list(exponent_sum),
                        "difference": difference,
                    }
            else:
                products[exponent_sum] = (left, right, product)
    return None


def direct_cubic_coefficients(vectors: np.ndarray, prime: int) -> np.ndarray:
    """Coefficients of F(a*U+b*V+c*W) by literal ordered expansion."""

    coefficients = []
    for multiset in PARAMETER_MONOMIALS:
        total = 0
        for coordinate in range(5):
            following = (coordinate + 1) % 5
            for left in range(3):
                for right in range(3):
                    for tail in range(3):
                        if tuple(sorted((left, right, tail))) == multiset:
                            total += (
                                int(vectors[left, coordinate])
                                * int(vectors[right, coordinate])
                                * int(vectors[tail, following])
                            )
        coefficients.append(total % prime)
    return np.asarray(coefficients, dtype=np.int64)


def points_and_values(frame, primary_forms, prime: int):
    rng = random.Random(202608010000 + prime)
    points = []
    invariant_rows = []
    vector_rows = []
    while len(points) < POINT_COUNT:
        point = tuple(rng.randrange(prime) for _ in range(5))
        if point == (0, 0, 0, 0, 0):
            continue
        inv = [evaluate(form, point) % prime for form in primary_forms]
        if not all(inv):
            continue
        points.append(point)
        invariant_rows.append(inv)
        vector_rows.append(
            [[entry % prime for entry in evaluate_vector(vector, point)] for vector in frame]
        )
    return (
        points,
        np.asarray(invariant_rows, dtype=np.int64),
        np.asarray(vector_rows, dtype=np.int64),
    )


def option_values(invariants: np.ndarray, exponents: tuple[int, ...], prime: int):
    result = np.ones(len(invariants), dtype=np.int64)
    for column, exponent in enumerate(exponents):
        if exponent:
            result = result * np.array(
                [pow(int(value), exponent, prime) for value in invariants[:, column]],
                dtype=np.int64,
            ) % prime
    return result


def replay_record(degree: int, prime: int, expected: dict, frame, primary_forms) -> dict:
    points, invariants, vector_values = points_and_values(frame, primary_forms, prime)
    stored_points = json.loads(
        (HERE / f"degree_{degree}/points_p{prime}.json").read_text()
    )["points"]
    assert stored_points == [list(point) for point in points]
    options = tuple(weighted_monomials(degree - value) for value in FRAME_DEGREES)
    evaluated = {
        (index, option): option_values(invariants, option, prime)
        for index in range(5)
        for option in options[index]
    }
    digest = hashlib.sha256()
    tested = 0
    skipped = 0
    minimum_rank = 10
    rank_histogram: dict[str, int] = {}
    rank9_nonveronese = 0
    geometric_survivors = 0
    triple_counts: dict[str, int] = {}
    for frame_triple in itertools.combinations(range(5), 3):
        local_count = 0
        base_vectors = vector_values[:, frame_triple, :]
        # Reconstruct the ten unscaled polar columns once by literal ordered
        # expansion.  Scaling a frame vector then multiplies a polar column
        # by the corresponding product of three scalar monomials.
        base_coefficients = np.asarray(
            [direct_cubic_coefficients(vectors, prime) for vectors in base_vectors],
            dtype=np.int64,
        )
        for option_tuple in itertools.product(*(options[index] for index in frame_triple)):
            if not primitive_tuple(option_tuple):
                skipped += 1
                continue
            scalars = np.column_stack(
                [evaluated[(index, option)] for index, option in zip(frame_triple, option_tuple)]
            )
            columns = []
            for column, local_indices in enumerate(PARAMETER_MONOMIALS):
                value = base_coefficients[:, column].copy()
                for local_index in local_indices:
                    value = value * scalars[:, local_index] % prime
                columns.append(value)
            matrix = np.column_stack(columns) % prime
            rank, pivot_rows, determinant = rank_and_row_witness(matrix, prime)
            minimum_rank = min(minimum_rank, rank)
            rank_histogram[str(rank)] = rank_histogram.get(str(rank), 0) + 1
            kernel = None
            veronese_witness = None
            if rank == 9:
                kernel = kernel_line(matrix, prime)
                veronese_witness = nonveronese_witness(kernel, prime)
                if veronese_witness is not None:
                    rank9_nonveronese += 1
            if rank < 9 or (rank == 9 and veronese_witness is None):
                geometric_survivors += 1
            digest.update(
                repr(
                    (
                        degree,
                        prime,
                        frame_triple,
                        option_tuple,
                        pivot_rows,
                        determinant,
                        rank,
                        kernel,
                        veronese_witness,
                    )
                ).encode()
            )
            tested += 1
            local_count += 1
        triple_counts["-".join(map(str, frame_triple))] = local_count
    actual = {
        "tested_primitive_ansaetze": tested,
        "skipped_common_primary_factor": skipped,
        "triple_counts": triple_counts,
        "minimum_polar_rank": minimum_rank,
        "rank_histogram": rank_histogram,
        "rank9_nonveronese": rank9_nonveronese,
        "geometric_survivors": [],
        "witness_digest_sha256": digest.hexdigest(),
    }
    for key, value in actual.items():
        assert expected[key] == value, (degree, prime, key, expected[key], value)
    assert minimum_rank >= 9 and geometric_survivors == 0
    return actual


def main() -> None:
    summary = json.loads((HERE / "sparse_frame_summary.json").read_text())
    names, frame, producer_polar_coefficients = all_coefficients()
    # Semantic independence: the verifier only checks that the producer-side
    # object exists; it never evaluates these polar polynomials.
    assert names == ("x", "C", "D", "E", "K")
    assert len(producer_polar_coefficients) == 35
    forms = invariant_core.forms()
    primary_forms = tuple(forms[degree] for degree in PRIMARY_DEGREES)
    for degree in DEGREES:
        payload = json.loads((HERE / f"degree_{degree}/search.json").read_text())
        for record in payload["prime_records"]:
            replay_record(degree, record["prime"], record, frame, primary_forms)
        assert summary["degrees"][str(degree)]["tested_primitive_ansaetze"] == payload[
            "prime_records"
        ][0]["tested_primitive_ansaetze"]
        print(f"verified degree={degree} at p=89,199", flush=True)
    print("COV_SPARSE_PRIMARY_FRAME_VERIFIED")


if __name__ == "__main__":
    main()
