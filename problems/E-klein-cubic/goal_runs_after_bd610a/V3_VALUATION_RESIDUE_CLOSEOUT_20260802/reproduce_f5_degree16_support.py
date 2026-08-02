#!/usr/bin/env python3
"""Reproduce the exact F_67 sparse-support certificate at f5, degree 16.

The script reconstructs the 660-element Weil representation, the primitive
Hilbert--90 frame, the nineteen quotient-basis coefficient functions, and the
151 independent necessary landing equations.  Quick mode exhausts supports
of size at most four and checks every deficient support of size five.  Full
mode additionally re-enumerates all 11,628 size-five supports.

No sampled survivor is promoted.  The only conclusion is projective emptiness
of the named coefficient-support strata in the degree-16 polynomial ansatz.
"""

from __future__ import annotations

import argparse
import base64
import hashlib
import itertools
import json
import math
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PAYLOAD_PATH = HERE / "f5_degree16_support_payload.json"
P = 67
ZETA = 9
JS = (1, 3, 2, 5, 4)
SIGNS = (1, 1, -1, 1, 1)
QR = {1, 3, 4, 5, 9}


def matrix_key(matrix: np.ndarray) -> bytes:
    return bytes((matrix % P).astype(np.uint8).flat)


def matrix_product(left: np.ndarray, right: np.ndarray) -> np.ndarray:
    return left @ right % P


def matrix_power(matrix: np.ndarray, exponent: int) -> np.ndarray:
    result = np.eye(5, dtype=np.int64) % P
    base = matrix.copy()
    while exponent:
        if exponent & 1:
            result = matrix_product(result, base)
        base = matrix_product(base, base)
        exponent //= 2
    return result


def representation_generators() -> tuple[np.ndarray, np.ndarray]:
    gamma = sum(
        (1 if exponent in QR else -1) * pow(ZETA, exponent, P)
        for exponent in range(1, 11)
    ) % P
    gamma_inverse = pow(gamma, -1, P)
    generator_a = np.array(
        [
            [
                SIGNS[column]
                * pow(SIGNS[row], -1, P)
                * (
                    pow(ZETA, 9 * JS[row] * JS[column], P)
                    - pow(ZETA, -9 * JS[row] * JS[column], P)
                )
                * gamma_inverse
                % P
                for column in range(5)
            ]
            for row in range(5)
        ],
        dtype=np.int64,
    )
    generator_b = np.diag([pow(ZETA, value * value, P) for value in JS]).astype(np.int64)
    return generator_a, generator_b


def generate_group(generator_a: np.ndarray, generator_b: np.ndarray) -> np.ndarray:
    identity = np.eye(5, dtype=np.int64) % P
    seen = {matrix_key(identity): identity}
    queue = [identity]
    while queue:
        current = queue.pop()
        for generator in (generator_a, generator_b):
            product = matrix_product(current, generator)
            key = matrix_key(product)
            if key not in seen:
                seen[key] = product
                queue.append(product)
    return np.stack(list(seen.values()))


def weak_compositions(total: int, length: int) -> list[tuple[int, ...]]:
    result: list[tuple[int, ...]] = []

    def recurse(prefix: tuple[int, ...], remaining: int, slots: int) -> None:
        if slots == 1:
            result.append(prefix + (remaining,))
            return
        for first in range(remaining + 1):
            recurse(prefix + (first,), remaining - first, slots - 1)

    recurse((), total, length)
    return result


def determinant_mod(matrix: np.ndarray, prime: int = P) -> int:
    work = np.array(matrix, dtype=np.int64, copy=True) % prime
    size = work.shape[0]
    determinant = 1
    for column in range(size):
        pivot = next((row for row in range(column, size) if work[row, column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[[column, pivot]] = work[[pivot, column]]
            determinant = -determinant
        value = int(work[column, column])
        determinant = determinant * value % prime
        work[column] = work[column] * pow(value, -1, prime) % prime
        for row in range(column + 1, size):
            if work[row, column]:
                work[row] = (work[row] - work[row, column] * work[column]) % prime
    return determinant % prime


def row_rank_mod(matrix: np.ndarray, prime: int = P) -> int:
    work = np.array(matrix, dtype=np.int64, copy=True) % prime
    rows, columns = work.shape
    rank = 0
    for column in range(columns):
        nonzero = np.flatnonzero(work[rank:, column])
        if not len(nonzero):
            continue
        pivot = rank + int(nonzero[0])
        if pivot != rank:
            work[[rank, pivot]] = work[[pivot, rank]]
        work[rank] = work[rank] * pow(int(work[rank, column]), -1, prime) % prime
        below = np.flatnonzero(work[rank + 1 :, column]) + rank + 1
        if len(below):
            work[below] = (work[below] - work[below, column, None] * work[rank]) % prime
        rank += 1
        if rank == rows:
            break
    return rank


def rref_and_nullspace(matrix: np.ndarray, prime: int = P) -> tuple[np.ndarray, list[int], list[np.ndarray]]:
    work = np.array(matrix, dtype=np.int64, copy=True) % prime
    rows, columns = work.shape
    rank = 0
    pivots: list[int] = []
    for column in range(columns):
        nonzero = np.flatnonzero(work[rank:, column])
        if not len(nonzero):
            continue
        pivot = rank + int(nonzero[0])
        if pivot != rank:
            work[[rank, pivot]] = work[[pivot, rank]]
        work[rank] = work[rank] * pow(int(work[rank, column]), -1, prime) % prime
        nonzero_rows = np.flatnonzero(work[:, column])
        nonzero_rows = nonzero_rows[nonzero_rows != rank]
        if len(nonzero_rows):
            work[nonzero_rows] = (
                work[nonzero_rows] - work[nonzero_rows, column, None] * work[rank]
            ) % prime
        pivots.append(column)
        rank += 1
        if rank == rows:
            break
    reduced = work[:rank]
    free = [column for column in range(columns) if column not in pivots]
    kernel: list[np.ndarray] = []
    for free_column in free:
        vector = np.zeros(columns, dtype=np.int64)
        vector[free_column] = 1
        for row, pivot_column in enumerate(pivots):
            vector[pivot_column] = -reduced[row, free_column] % prime
        assert np.all(np.asarray(matrix, dtype=np.int64) @ vector % prime == 0)
        kernel.append(vector)
    return reduced, pivots, kernel


def hessian(point: np.ndarray) -> np.ndarray:
    matrix = np.zeros((5, 5), dtype=np.int64)
    for index in range(5):
        matrix[index, index] = 2 * point[(index + 1) % 5]
        matrix[index, (index + 1) % 5] = 2 * point[index]
        matrix[(index + 1) % 5, index] = 2 * point[index]
    return matrix % P


def f5_value(point: np.ndarray) -> int:
    return determinant_mod(hessian(point))


def klein(point: np.ndarray) -> int:
    return sum(
        int(point[index]) ** 2 * int(point[(index + 1) % 5])
        for index in range(5)
    ) % P


def monomial_value(point: tuple[int, ...] | np.ndarray, exponents: tuple[int, ...]) -> int:
    value = 1
    for coordinate, exponent in zip(point, exponents):
        value = value * pow(int(coordinate), exponent, P) % P
    return value


def cyclic_covariant(
    point: np.ndarray,
    terms: tuple[tuple[tuple[int, ...], int], ...],
) -> np.ndarray:
    coordinates = tuple(map(int, point))
    answer = []
    for shift in range(5):
        shifted = tuple(coordinates[(index + shift) % 5] for index in range(5))
        answer.append(sum(coefficient * monomial_value(shifted, exponent) for exponent, coefficient in terms) % P)
    return np.array(answer, dtype=np.int64)


def covariant_c(point: np.ndarray) -> np.ndarray:
    coordinates = list(map(int, point))
    gradient = [
        (2 * coordinates[index] * coordinates[(index + 1) % 5] + coordinates[(index - 1) % 5] ** 2) % P
        for index in range(5)
    ]
    return np.array(
        [
            (2 * gradient[index] * gradient[(index + 1) % 5] + gradient[(index - 1) % 5] ** 2) % P
            for index in range(5)
        ],
        dtype=np.int64,
    )


D_TERMS = tuple(
    {
        (0, 0, 2, 0, 3): -5,
        (0, 1, 0, 3, 1): -5,
        (0, 3, 1, 1, 0): 5,
        (0, 5, 0, 0, 0): -1,
        (1, 1, 0, 1, 2): 10,
        (1, 1, 2, 0, 1): -5,
        (2, 0, 1, 2, 0): -5,
        (2, 2, 0, 1, 0): -5,
        (3, 0, 1, 0, 1): 5,
    }.items()
)
E_EXPONENTS = (
    (0, 0, 1, 3, 2), (0, 0, 3, 2, 1), (0, 0, 5, 1, 0), (0, 1, 0, 0, 5),
    (0, 2, 0, 2, 2), (0, 2, 2, 1, 1), (0, 2, 4, 0, 0), (0, 4, 1, 0, 1),
    (1, 0, 1, 1, 3), (1, 0, 3, 0, 2), (1, 1, 1, 3, 0), (1, 2, 0, 0, 3),
    (1, 3, 0, 2, 0), (2, 1, 1, 1, 1), (2, 1, 3, 0, 0), (2, 3, 0, 0, 1),
    (3, 0, 0, 3, 0), (4, 0, 0, 1, 1), (4, 0, 2, 0, 0),
)
E_COEFFICIENTS = (-2, 1, 0, 1, 3, 3, -1, -1, 0, 0, 4, 2, 1, 0, 3, -3, -1, -1, 0)
E_TERMS = tuple(zip(E_EXPONENTS, E_COEFFICIENTS))
K_EXPONENTS = (
    (0, 0, 0, 6, 1), (0, 0, 1, 0, 6), (0, 0, 2, 5, 0), (0, 1, 1, 2, 3),
    (0, 1, 3, 1, 2), (0, 1, 5, 0, 1), (0, 2, 1, 4, 0), (0, 3, 0, 1, 3),
    (0, 3, 2, 0, 2), (0, 4, 0, 3, 0), (1, 0, 0, 4, 2), (1, 0, 2, 3, 1),
    (1, 0, 4, 2, 0), (1, 1, 1, 0, 4), (1, 2, 1, 2, 1), (1, 2, 3, 1, 0),
    (1, 4, 0, 1, 1), (1, 4, 2, 0, 0), (2, 0, 0, 2, 3), (2, 0, 2, 1, 2),
    (2, 0, 4, 0, 1), (2, 1, 0, 4, 0), (2, 2, 1, 0, 2), (3, 0, 0, 0, 4),
    (3, 1, 0, 2, 1), (3, 1, 2, 1, 0), (3, 3, 1, 0, 0), (4, 1, 0, 0, 2),
    (5, 0, 1, 1, 0), (5, 2, 0, 0, 0),
)
K_COEFFICIENTS = (
    0, -1, -1, -4, 0, -2, -1, -4, 2, -1, 0, 0, 3, -16, 28,
    0, -18, 0, -6, 22, -11, -10, 16, 3, 20, 12, -8, -9, -12, 4,
)
K_TERMS = tuple(zip(K_EXPONENTS, K_COEFFICIENTS))


def frame(point: np.ndarray) -> list[np.ndarray]:
    return [
        np.array(point, dtype=np.int64) % P,
        covariant_c(point),
        cyclic_covariant(point, D_TERMS),
        cyclic_covariant(point, E_TERMS),
        cyclic_covariant(point, K_TERMS),
    ]


def invariant_seed_values(
    group: np.ndarray,
    points: np.ndarray,
    seeds: list[tuple[int, ...]],
) -> np.ndarray:
    """Return the Reynolds sums, with rows indexed by points and columns by seeds."""
    result = np.zeros((len(points), len(seeds)), dtype=np.int64)
    for point_index, point in enumerate(points):
        transformed = np.einsum("gij,j->gi", group, point) % P
        powers = np.ones((len(group), 5, 16), dtype=np.int64)
        for exponent in range(1, 16):
            powers[:, :, exponent] = powers[:, :, exponent - 1] * transformed % P
        for seed_index, seed in enumerate(seeds):
            values = np.ones(len(group), dtype=np.int64)
            for coordinate, exponent in enumerate(seed):
                values = values * powers[:, coordinate, exponent] % P
            result[point_index, seed_index] = int(np.sum(values, dtype=np.int64) % P)
    return result


def add_echelon_row(
    basis: list[tuple[int, np.ndarray]],
    row: np.ndarray,
) -> bool:
    reduced = np.asarray(row, dtype=np.int64) % P
    for pivot, old_row in basis:
        if reduced[pivot]:
            reduced = (reduced - reduced[pivot] * old_row) % P
    nonzero = np.flatnonzero(reduced)
    if not len(nonzero):
        return False
    pivot = int(nonzero[0])
    reduced = reduced * pow(int(reduced[pivot]), -1, P) % P
    basis.append((pivot, reduced))
    return True


def cubic_equation_matrix(candidate_values: list[np.ndarray]) -> np.ndarray:
    cubic_monomials = weak_compositions(3, 19)
    monomial_index = {exponents: index for index, exponents in enumerate(cubic_monomials)}
    left_indices: list[int] = []
    middle_indices: list[int] = []
    right_indices: list[int] = []
    slots: list[int] = []
    for left, middle, right in itertools.product(range(19), repeat=3):
        exponents = [0] * 19
        exponents[left] += 1
        exponents[middle] += 1
        exponents[right] += 1
        left_indices.append(left)
        middle_indices.append(middle)
        right_indices.append(right)
        slots.append(monomial_index[tuple(exponents)])
    left_array = np.array(left_indices, dtype=np.int64)
    middle_array = np.array(middle_indices, dtype=np.int64)
    right_array = np.array(right_indices, dtype=np.int64)
    slot_array = np.array(slots, dtype=np.int64)

    echelon: list[tuple[int, np.ndarray]] = []
    for values in candidate_values:
        row = np.zeros(len(cubic_monomials), dtype=np.int64)
        for coordinate in range(5):
            following = (coordinate + 1) % 5
            contributions = (
                values[left_array, coordinate]
                * values[middle_array, coordinate]
                * values[right_array, following]
            ) % P
            np.add.at(row, slot_array, contributions)
            row %= P
        add_echelon_row(echelon, row)
    return np.stack([row for _, row in echelon])


def local_columns(
    support: tuple[int, ...],
    global_monomials: list[tuple[int, ...]],
) -> tuple[list[int], list[tuple[int, ...]]]:
    support_set = set(support)
    indices: list[int] = []
    local_monomials: list[tuple[int, ...]] = []
    for index, exponents in enumerate(global_monomials):
        if all(exponents[position] == 0 for position in range(19) if position not in support_set):
            indices.append(index)
            local_monomials.append(tuple(exponents[position] for position in support))
    assert set(local_monomials) == set(weak_compositions(3, len(support)))
    return indices, local_monomials


def first_catalecticant_minor(
    vector: np.ndarray,
    local_monomials: list[tuple[int, ...]],
) -> dict[str, object] | None:
    coefficients = {monomial: int(value) % P for monomial, value in zip(local_monomials, vector)}
    degree_two = weak_compositions(2, 5)
    catalecticant = np.zeros((5, len(degree_two)), dtype=np.int64)
    for row in range(5):
        for column, monomial in enumerate(degree_two):
            exponent = list(monomial)
            exponent[row] += 1
            catalecticant[row, column] = coefficients[tuple(exponent)]
    for row_one in range(5):
        for row_two in range(row_one + 1, 5):
            for column_one in range(len(degree_two)):
                for column_two in range(column_one + 1, len(degree_two)):
                    determinant = (
                        int(catalecticant[row_one, column_one]) * int(catalecticant[row_two, column_two])
                        - int(catalecticant[row_one, column_two]) * int(catalecticant[row_two, column_one])
                    ) % P
                    if determinant:
                        return {
                            "rows": [row_one, row_two],
                            "degree2_columns": [list(degree_two[column_one]), list(degree_two[column_two])],
                            "entries": [
                                [int(catalecticant[row_one, column_one]), int(catalecticant[row_one, column_two])],
                                [int(catalecticant[row_two, column_one]), int(catalecticant[row_two, column_two])],
                            ],
                            "determinant_mod_67": determinant,
                        }
    return None


def quotient_dimension(degree: int) -> int:
    """Dimension in the Hironaka quotient by the degree-five primary."""
    secondary_degrees = (0, 7, 9, 10, 12, 14, 14, 16, 18, 19, 21, 28)
    weights = (3, 6, 8, 11)
    answer = 0
    for secondary_degree in secondary_degrees:
        remainder = degree - secondary_degree
        if remainder < 0:
            continue
        for a in range(remainder // weights[0] + 1):
            for b in range(remainder // weights[1] + 1):
                for c in range(remainder // weights[2] + 1):
                    residual = remainder - weights[0] * a - weights[1] * b - weights[2] * c
                    if residual >= 0 and residual % weights[3] == 0:
                        answer += 1
    return answer


def reproduce(full: bool) -> None:
    payload = json.loads(PAYLOAD_PATH.read_text())
    assert payload["schema"] == "klein-v-f5-degree16-support-v2"
    assert payload["prime"] == P and payload["zeta11"] == ZETA
    assert pow(ZETA, 11, P) == 1 and all(pow(ZETA, divisor, P) != 1 for divisor in (1,))

    generator_a, generator_b = representation_generators()
    identity = np.eye(5, dtype=np.int64) % P
    assert np.array_equal(matrix_power(generator_a, 2), identity)
    assert np.array_equal(matrix_power(generator_b, 11), identity)
    assert np.array_equal(matrix_power(matrix_product(generator_a, generator_b), 3), identity)
    group = generate_group(generator_a, generator_b)
    assert len(group) == payload["group_order"] == 660

    points = np.frombuffer(
        base64.b64decode(payload["equation_points_f67_uint8_base64"]), dtype=np.uint8
    ).astype(np.int64).reshape(payload["equation_points_shape"])
    seed_array = np.frombuffer(
        base64.b64decode(payload["reynolds_seed_exponents_uint8_base64"]), dtype=np.uint8
    ).astype(np.int64).reshape(payload["reynolds_seed_shape"])
    seeds = [tuple(map(int, seed)) for seed in seed_array]
    assert points.shape == (151, 5)
    assert len(seeds) == 19
    assert all(f5_value(point) == 0 for point in points)

    # The four nontrivial frame columns are checked independently against both
    # group generators at every certificate point.
    for point in points:
        for generator in (generator_a, generator_b):
            transformed = generator @ point % P
            original_frame = frame(point)
            transformed_frame = frame(transformed)
            for original, transformed_column in zip(original_frame, transformed_frame):
                assert np.array_equal(generator @ original % P, transformed_column % P)

    seed_values = invariant_seed_values(group, points, seeds)
    block_dimensions = [block["dimension"] for block in payload["frame_blocks"]]
    coefficient_degrees = [block["coefficient_degree"] for block in payload["frame_blocks"]]
    assert block_dimensions == [7, 5, 2, 2, 3]
    assert [quotient_dimension(degree) for degree in coefficient_degrees] == block_dimensions
    offset = 0
    for dimension in block_dimensions:
        assert row_rank_mod(seed_values[:, offset : offset + dimension]) == dimension
        offset += dimension

    candidate_values: list[np.ndarray] = []
    for point_index, point in enumerate(points):
        columns = frame(point)
        values: list[np.ndarray] = []
        offset = 0
        for frame_index, dimension in enumerate(block_dimensions):
            for local_index in range(dimension):
                scalar = int(seed_values[point_index, offset + local_index])
                values.append(scalar * columns[frame_index] % P)
            offset += dimension
        candidate_values.append(np.stack(values))

    equations = cubic_equation_matrix(candidate_values)
    assert equations.shape == (payload["necessary_equation_rank"], payload["cubic_monomial_count"])
    assert row_rank_mod(equations) == 151
    digest = hashlib.sha256(equations.astype(np.uint8).tobytes()).hexdigest()
    assert digest == payload["row_matrix_uint8_sha256"]

    global_monomials = weak_compositions(3, 19)
    histograms: list[dict[str, object]] = []
    maximum_support = 5 if full else 4
    for support_size in range(1, maximum_support + 1):
        histogram: dict[int, int] = {}
        for support in itertools.combinations(range(19), support_size):
            columns, _ = local_columns(support, global_monomials)
            rank = row_rank_mod(equations[:, columns])
            histogram[rank] = histogram.get(rank, 0) + 1
        histograms.append(
            {
                "support_size": support_size,
                "total": math.comb(19, support_size),
                "cubic_dimension": math.comb(support_size + 2, 3),
                "ranks": {str(rank): count for rank, count in sorted(histogram.items())},
            }
        )
    expected = payload["support_rank_histograms"][:maximum_support]
    assert histograms == expected

    # Every size-five support with deficient linear rank is explicitly listed.
    # Seven have one-dimensional kernels which fail a Veronese catalecticant
    # minor.  The C-only support is killed by five direct F(C)=f12 evaluations.
    deficient = payload["deficient_size5_supports"]
    assert len(deficient) == 8
    for record in deficient:
        support = tuple(record["support"])
        columns, local_monomials = local_columns(support, global_monomials)
        _, pivots, kernel = rref_and_nullspace(equations[:, columns])
        assert len(pivots) == record["rank"]
        assert len(kernel) == record["nullity"]
        if "kernel_vector" in record:
            assert len(kernel) == 1
            assert [int(value) for value in kernel[0]] == record["kernel_vector"]
            minor = first_catalecticant_minor(kernel[0], local_monomials)
            assert minor == record["nonveronese_minor"]
            assert minor is not None and minor["determinant_mod_67"] != 0

    q_witness = payload["c_only_support_witness"]
    q_indices = q_witness["point_indices"]
    q_matrix = seed_values[np.array(q_indices), 7:12] % P
    q_f12 = [klein(covariant_c(points[index])) for index in q_indices]
    assert q_matrix.tolist() == q_witness["coefficient_evaluation_matrix"]
    assert q_f12 == q_witness["f12_values"]
    assert all(value != 0 for value in q_f12)
    assert determinant_mod(q_matrix) == q_witness["determinant_mod_67"] != 0

    if full:
        full_histogram = histograms[-1]
        assert full_histogram == payload["support_rank_histograms"][4]
        print("V_F5_DEGREE16_SMALL_SUPPORT_FULL_OK")
    else:
        print("V_F5_DEGREE16_SMALL_SUPPORT_QUICK_OK")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--full", action="store_true", help="re-enumerate all size-five supports")
    args = parser.parse_args()
    reproduce(full=args.full)


if __name__ == "__main__":
    main()
