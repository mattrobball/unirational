#!/usr/bin/env python3
"""Produce exact certificates for a structured high-degree covariant family.

The family and its strict scope are documented in README.md.  The decisive
certificate is a rank-10 evaluation minor for the ten ternary-cubic polar
coefficients of every ansatz.  A nonzero evaluation minor modulo a good prime
is an exact characteristic-zero nonvanishing statement because all installed
frame and invariant formulas are integral.
"""

from __future__ import annotations

import hashlib
import itertools
import json
import math
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
assert len(PARAMETER_MONOMIALS) == 10
PARAMETER_EXPONENTS = tuple(
    tuple(indices.count(variable) for variable in range(3))
    for indices in PARAMETER_MONOMIALS
)


def weighted_monomials(total: int) -> tuple[tuple[int, ...], ...]:
    answer: list[tuple[int, ...]] = []

    def visit(index: int, remainder: int, prefix: list[int]) -> None:
        if index == len(PRIMARY_DEGREES):
            if remainder == 0:
                answer.append(tuple(prefix))
            return
        weight = PRIMARY_DEGREES[index]
        for exponent in range(remainder // weight + 1):
            prefix.append(exponent)
            visit(index + 1, remainder - exponent * weight, prefix)
            prefix.pop()

    visit(0, total, [])
    return tuple(answer)


def monomial_values(
    primary_values: np.ndarray, exponents: tuple[int, ...], prime: int
) -> np.ndarray:
    value = np.ones(len(primary_values), dtype=np.int64)
    for column, exponent in enumerate(exponents):
        if exponent:
            value = value * np.array(
                [pow(int(x), exponent, prime) for x in primary_values[:, column]],
                dtype=np.int64,
            ) % prime
    return value


def primitive_tuple(exponents: tuple[tuple[int, ...], ...]) -> bool:
    """No common displayed primary-invariant monomial factor."""

    return all(min(row[column] for row in exponents) == 0 for column in range(5))


def rank_and_row_witness(matrix: np.ndarray, prime: int) -> tuple[int, tuple[int, ...], int]:
    """Rank plus the first pivot-row minor and its determinant modulo prime."""

    transposed = np.asarray(matrix, dtype=np.int64).T.copy() % prime
    rows, columns = transposed.shape
    rank = 0
    pivot_columns: list[int] = []
    determinant = 1
    for column in range(columns):
        pivot = next((row for row in range(rank, rows) if transposed[row, column]), None)
        if pivot is None:
            continue
        if pivot != rank:
            transposed[[rank, pivot]] = transposed[[pivot, rank]]
            determinant = -determinant
        pivot_value = int(transposed[rank, column]) % prime
        determinant = determinant * pivot_value % prime
        inverse = pow(pivot_value, -1, prime)
        transposed[rank] = transposed[rank] * inverse % prime
        for row in range(rank + 1, rows):
            if transposed[row, column]:
                transposed[row] = (
                    transposed[row] - transposed[row, column] * transposed[rank]
                ) % prime
        pivot_columns.append(column)
        rank += 1
        if rank == rows:
            break
    if rank < rows:
        return rank, tuple(pivot_columns), 0
    # The elimination determinant above is for the selected columns of M^T,
    # hence the selected rows of M.  Normalize the sign modulo p.
    return rank, tuple(pivot_columns), determinant % prime


def kernel_line(matrix: np.ndarray, prime: int) -> tuple[int, ...]:
    """Return the normalized one-dimensional right kernel of a rank-9 matrix."""

    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    row = 0
    pivots: list[int] = []
    for column in range(value.shape[1]):
        pivot = next((index for index in range(row, value.shape[0]) if value[index, column]), None)
        if pivot is None:
            continue
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, prime) % prime
        for index in range(value.shape[0]):
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
    """Return a violated binomial of the ternary degree-three Veronese ideal."""

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


def choose_points(
    frame, primary_forms, prime: int, count: int
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    rng = random.Random(202608010000 + prime)
    points: list[tuple[int, ...]] = []
    primary_rows: list[list[int]] = []
    frame_rows: list[list[list[int]]] = []
    while len(points) < count:
        point = tuple(rng.randrange(prime) for _ in range(5))
        if point == (0, 0, 0, 0, 0):
            continue
        invariant_values = [evaluate(form, point) % prime for form in primary_forms]
        if not all(invariant_values):
            continue
        points.append(point)
        primary_rows.append(invariant_values)
        frame_rows.append(
            [[entry % prime for entry in evaluate_vector(vector, point)] for vector in frame]
        )
    return (
        np.asarray(points, dtype=np.int64),
        np.asarray(primary_rows, dtype=np.int64),
        np.asarray(frame_rows, dtype=np.int64),
    )


def canonical_json(payload: dict) -> str:
    return json.dumps(payload, indent=2, sort_keys=True) + "\n"


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_prime(
    degree: int,
    prime: int,
    frame,
    polar_coefficients,
    primary_forms,
) -> dict:
    points, primary_values, _frame_values = choose_points(
        frame, primary_forms, prime, POINT_COUNT
    )
    option_lists = tuple(
        weighted_monomials(degree - frame_degree) for frame_degree in FRAME_DEGREES
    )
    option_values = {
        (coordinate, option): monomial_values(primary_values, option, prime)
        for coordinate in range(5)
        for option in option_lists[coordinate]
    }
    polar_values = {
        triple: np.asarray(
            [evaluate(polynomial, tuple(map(int, point))) % prime for point in points],
            dtype=np.int64,
        )
        for triple, polynomial in polar_coefficients.items()
    }

    digest = hashlib.sha256()
    tested = 0
    imprimitive = 0
    minimum_rank = 10
    rank_histogram: dict[str, int] = {}
    geometric_survivors: list[dict] = []
    rank9_nonveronese = 0
    triple_counts: dict[str, int] = {}
    for frame_triple in itertools.combinations(range(5), 3):
        local_tested = 0
        for option_tuple in itertools.product(*(option_lists[index] for index in frame_triple)):
            if not primitive_tuple(option_tuple):
                imprimitive += 1
                continue
            scaled = [
                option_values[(frame_index, option)]
                for frame_index, option in zip(frame_triple, option_tuple)
            ]
            columns = []
            for local_indices in PARAMETER_MONOMIALS:
                global_indices = tuple(sorted(frame_triple[index] for index in local_indices))
                value = polar_values[global_indices].copy()
                for local_index in local_indices:
                    value = value * scaled[local_index] % prime
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
                geometric_survivors.append(
                    {
                        "frame_triple": frame_triple,
                        "primary_exponents": option_tuple,
                        "rank": rank,
                        "kernel": kernel,
                    }
                )
            record = (
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
            digest.update(repr(record).encode())
            tested += 1
            local_tested += 1
        triple_counts["-".join(map(str, frame_triple))] = local_tested

    point_path = HERE / f"degree_{degree}" / f"points_p{prime}.json"
    point_path.parent.mkdir(parents=True, exist_ok=True)
    point_path.write_text(canonical_json({"prime": prime, "points": points.tolist()}))
    return {
        "prime": prime,
        "point_count": len(points),
        "points_sha256": sha256_file(point_path),
        "tested_primitive_ansaetze": tested,
        "skipped_common_primary_factor": imprimitive,
        "triple_counts": triple_counts,
        "minimum_polar_rank": minimum_rank,
        "rank_histogram": rank_histogram,
        "rank9_nonveronese": rank9_nonveronese,
        "geometric_survivors": geometric_survivors,
        "witness_digest_sha256": digest.hexdigest(),
    }


def main() -> None:
    names, frame, polar_coefficients = all_coefficients()
    assert names == ("x", "C", "D", "E", "K")
    assert len(polar_coefficients) == 35 and all(polar_coefficients.values())
    forms = invariant_core.forms()
    primary_forms = tuple(forms[degree] for degree in PRIMARY_DEGREES)

    summary = {
        "schema": "COV_SPARSE_PRIMARY_FRAME_V1",
        "selected_degrees": list(DEGREES),
        "frame_names": list(names),
        "frame_degrees": list(FRAME_DEGREES),
        "primary_degrees": list(PRIMARY_DEGREES),
        "family": (
            "all three-element frame subsets; one primary-hsop monomial per "
            "selected frame vector; tuples with a common displayed primary factor removed"
        ),
        "proof": (
            "rank 10 gives a nonzero minor; rank 9 gives a unique kernel line "
            "with a violated ternary-Veronese binomial. Either certificate "
            "proves projective landing emptiness over the algebraic closure"
        ),
        "degrees": {},
    }
    for degree in DEGREES:
        records = [
            run_prime(
                degree,
                prime,
                frame,
                polar_coefficients,
                primary_forms,
            )
            for prime in PRIMES
        ]
        assert all(record["minimum_polar_rank"] >= 9 for record in records), records
        assert all(not record["geometric_survivors"] for record in records), records
        assert len({record["tested_primitive_ansaetze"] for record in records}) == 1
        degree_payload = {
            "degree": degree,
            "residual_class": {25: "e>=7", 31: "e=1", 35: "e=5"}[degree],
            "option_counts": [
                len(weighted_monomials(degree - value)) for value in FRAME_DEGREES
            ],
            "prime_records": records,
            "exit": "STRUCTURED_FAMILY_EMPTY",
        }
        path = HERE / f"degree_{degree}" / "search.json"
        path.write_text(canonical_json(degree_payload))
        summary["degrees"][str(degree)] = {
            "payload": str(path.relative_to(HERE)),
            "payload_sha256": sha256_file(path),
            "tested_primitive_ansaetze": records[0]["tested_primitive_ansaetze"],
            "minimum_rank": min(record["minimum_polar_rank"] for record in records),
        }
        print(
            f"degree={degree} tested={records[0]['tested_primitive_ansaetze']} "
            f"minrank={records[0]['minimum_polar_rank']} "
            f"geometric_survivors=0 p89+p199",
            flush=True,
        )

    out = HERE / "sparse_frame_summary.json"
    out.write_text(canonical_json(summary))
    print(f"summary_sha256={sha256_file(out)}")
    print("COV_SPARSE_PRIMARY_FRAME_PRODUCED")


if __name__ == "__main__":
    main()
