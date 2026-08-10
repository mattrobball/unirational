#!/usr/bin/env python3
"""Exact good-reduction certificate for new Problem-E dominant-map bounds.

At the split prime 67 this script:
  * reconstructs the 660-element PSL(2,11) action;
  * verifies that no scalar invariant of degree <=22 vanishes on an
    involution plus-plane (the first special-fibre kernel is degree 23);
  * computes the plus-plane restriction kernels of self-covariants in
    degrees 15,...,21;
  * imposes the exact cubic landing equations on those kernels; and
  * proves projective emptiness in degrees 17,...,21, using the full cubic
    coefficient span in degrees 17--19 and the full degree-four Macaulay span
    in degrees 20--21.

The characteristic-zero consequences use the standard projective
specialization/properness argument and exact Molien dimensions already sealed
in certificates/exact_molien.py.
"""
from __future__ import annotations

from itertools import permutations
import math
import numpy as np

P = 67
ZETA = 64
JS = (1, 3, 2, 5, 4)
SIGNS = (1, 1, -1, 1, 1)
QR = {1, 3, 4, 5, 9}
PRIMARY_DEGREES = (3, 5, 6, 8, 11)
SECONDARY_DEGREES = (0, 7, 9, 10, 12, 14, 14, 16, 18, 19, 21, 28)
COV_DIMS = {
    15: 32, 16: 41, 17: 49, 18: 59, 19: 73, 20: 86, 21: 100,
}
EXPECTED_KERNELS = {15: 0, 16: 0, 17: 2, 18: 3, 19: 7, 20: 11, 21: 16}
EXPECTED_CUBIC_RANKS = {17: 4, 18: 10, 19: 84, 20: 169, 21: 269}


def matmul(a: np.ndarray, b: np.ndarray) -> np.ndarray:
    return a @ b % P


def matpow(a: np.ndarray, n: int) -> np.ndarray:
    out = np.eye(5, dtype=np.int64)
    while n:
        if n & 1:
            out = matmul(out, a)
        a = matmul(a, a)
        n //= 2
    return out


gamma = sum(
    (1 if exponent in QR else -1) * pow(ZETA, exponent, P)
    for exponent in range(1, 11)
) % P
assert gamma * gamma % P == -11 % P
S = np.array(
    [
        [
            SIGNS[column]
            * pow(SIGNS[row], -1, P)
            * (
                pow(ZETA, 9 * JS[row] * JS[column], P)
                - pow(ZETA, -9 * JS[row] * JS[column], P)
            )
            * pow(gamma, -1, P)
            % P
            for column in range(5)
        ]
        for row in range(5)
    ],
    dtype=np.int64,
)
T = np.diag([pow(ZETA, value * value, P) for value in JS]).astype(np.int64)
IDENTITY = np.eye(5, dtype=np.int64) % P


def matrix_key(a: np.ndarray) -> bytes:
    return bytes((a % P).astype(np.uint8).flat)


def generate_group() -> tuple[np.ndarray, np.ndarray]:
    seen = {matrix_key(IDENTITY): IDENTITY}
    queue = [IDENTITY]
    while queue:
        current = queue.pop()
        for generator in (S, T):
            candidate = matmul(current, generator)
            key = matrix_key(candidate)
            if key not in seen:
                seen[key] = candidate
                queue.append(candidate)
    group = np.stack(list(seen.values()))
    inverses = np.stack([matpow(g, 659) for g in group])
    assert len(group) == 660
    return group, inverses


GROUP, INVERSES = generate_group()


def compositions(total: int, slots: int):
    if slots == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, slots - 1):
            yield (first,) + rest


def comps5(total: int):
    return compositions(total, 5)


def add_echelon(basis: list[tuple[int, np.ndarray]], row: np.ndarray) -> bool:
    row = np.array(row, dtype=np.int64) % P
    for pivot, old in basis:
        if row[pivot]:
            row = (row - row[pivot] * old) % P
    nonzero = np.flatnonzero(row)
    if not len(nonzero):
        return False
    pivot = int(nonzero[0])
    row = row * pow(int(row[pivot]), -1, P) % P
    basis.append((pivot, row))
    return True


def rref(a: np.ndarray) -> tuple[np.ndarray, list[int]]:
    a = np.array(a, dtype=np.int64) % P
    rows, columns = a.shape
    pivots: list[int] = []
    row = 0
    for column in range(columns):
        pivot = next((r for r in range(row, rows) if a[r, column]), None)
        if pivot is None:
            continue
        if pivot != row:
            a[[row, pivot]] = a[[pivot, row]]
        a[row] = a[row] * pow(int(a[row, column]), -1, P) % P
        for r in range(rows):
            if r != row and a[r, column]:
                a[r] = (a[r] - a[r, column] * a[row]) % P
        pivots.append(column)
        row += 1
        if row == rows:
            break
    return a, pivots


def nullspace(a: np.ndarray) -> np.ndarray:
    reduced, pivots = rref(a)
    columns = reduced.shape[1]
    pivot_set = set(pivots)
    free = [column for column in range(columns) if column not in pivot_set]
    answer = []
    for f in free:
        vector = np.zeros(columns, dtype=np.int64)
        vector[f] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row, f] % P
        answer.append(vector)
    if not answer:
        return np.zeros((0, columns), dtype=np.int64)
    return np.stack(answer)


def kernel_basis(a: np.ndarray) -> np.ndarray:
    return nullspace(a)


def fixed_space(matrix: np.ndarray, eigenvalue: int) -> np.ndarray:
    return kernel_basis((matrix - eigenvalue * IDENTITY) % P)


involution = next(
    g for g in GROUP
    if not np.array_equal(g, IDENTITY) and np.array_equal(matmul(g, g), IDENTITY)
)
PLUS = fixed_space(involution, 1)
MINUS = fixed_space(involution, -1 % P)
assert PLUS.shape == (3, 5) and MINUS.shape == (2, 5)


def inv_dim(degree: int) -> int:
    total = 0
    for secondary in SECONDARY_DEGREES:
        remainder = degree - secondary
        if remainder < 0:
            continue
        counts = [0] * (remainder + 1)
        counts[0] = 1
        for parameter in PRIMARY_DEGREES:
            for value in range(parameter, remainder + 1):
                counts[value] += counts[value - parameter]
        total += counts[remainder]
    return total


def transformed_context(points: np.ndarray, degree: int):
    transformed = np.einsum("gij,pj->pgi", GROUP, points, dtype=np.int64) % P
    powers = []
    for coordinate in range(5):
        coordinate_powers = [np.ones(transformed.shape[:2], dtype=np.int64)]
        for exponent in range(1, degree + 1):
            coordinate_powers.append(
                coordinate_powers[-1] * transformed[:, :, coordinate] % P
            )
        powers.append(coordinate_powers)
    return powers


def invariant_seed_basis(degree: int) -> list[tuple[int, ...]]:
    dimension = inv_dim(degree)
    if not dimension:
        return []
    rng = np.random.default_rng(670000 + degree)
    points = rng.integers(0, P, size=(dimension + 8, 5), dtype=np.int64)
    powers = transformed_context(points, degree)
    echelon: list[tuple[int, np.ndarray]] = []
    seeds = []
    for exponents in comps5(degree):
        values = np.ones_like(powers[0][0])
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                values = values * powers[coordinate][exponent] % P
        row = values.sum(axis=1, dtype=np.int64) % P
        if add_echelon(echelon, row):
            seeds.append(exponents)
            if len(seeds) == dimension:
                return seeds
    raise AssertionError((degree, len(seeds), dimension))


def evaluate_invariant_seeds(
    seeds: list[tuple[int, ...]], degree: int, points: np.ndarray
) -> np.ndarray:
    powers = transformed_context(points, degree)
    columns = []
    for exponents in seeds:
        values = np.ones_like(powers[0][0])
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                values = values * powers[coordinate][exponent] % P
        columns.append(values.sum(axis=1, dtype=np.int64) % P)
    return np.column_stack(columns)


def covariant_seed_basis(degree: int, dimension: int):
    rng = np.random.default_rng(680000 + degree)
    points = rng.integers(
        0, P, size=(math.ceil(dimension / 5) + 8, 5), dtype=np.int64
    )
    powers = transformed_context(points, degree)
    echelon: list[tuple[int, np.ndarray]] = []
    seeds: list[tuple[int, tuple[int, ...]]] = []
    for exponents in comps5(degree):
        values = np.ones_like(powers[0][0])
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                values = values * powers[coordinate][exponent] % P
        averaged = np.einsum(
            "pg,gik->pik", values, INVERSES, dtype=np.int64
        ) % P
        for output in range(5):
            row = averaged[:, :, output].reshape(-1)
            if add_echelon(echelon, row):
                seeds.append((output, exponents))
                if len(seeds) == dimension:
                    return seeds
    raise AssertionError((degree, len(seeds), dimension))


def evaluate_covariant_seeds(seeds, degree: int, points: np.ndarray):
    powers = transformed_context(points, degree)
    cache = {}
    outputs = []
    for output, exponents in seeds:
        if exponents not in cache:
            values = np.ones_like(powers[0][0])
            for coordinate, exponent in enumerate(exponents):
                if exponent:
                    values = values * powers[coordinate][exponent] % P
            cache[exponents] = np.einsum(
                "pg,gik->pik", values, INVERSES, dtype=np.int64
            ) % P
        outputs.append(cache[exponents][:, :, output])
    return outputs


def triangular_plane_points(degree: int) -> np.ndarray:
    coefficients = np.array(
        [
            (1, first, second)
            for first in range(degree + 1)
            for second in range(degree + 1 - first)
        ],
        dtype=np.int64,
    )
    return coefficients @ PLUS % P


def covariant_plane_kernel(degree: int, seeds) -> np.ndarray:
    points = triangular_plane_points(degree)
    values = evaluate_covariant_seeds(seeds, degree, points)
    restriction = np.column_stack([value.reshape(-1) for value in values])
    return kernel_basis(restriction)


def cubic_monomial_data(dimension: int):
    monomials = list(compositions(3, dimension))
    data = []
    for exponents in monomials:
        indices = []
        for variable, exponent in enumerate(exponents):
            indices.extend([variable] * exponent)
        data.append(tuple(sorted(set(permutations(indices, 3)))))
    return monomials, data


def cubic_coefficient_row(values: np.ndarray, data) -> np.ndarray:
    row = np.zeros(len(data), dtype=np.int64)
    for monomial, perms in enumerate(data):
        coefficient = 0
        for coordinate in range(5):
            successor = (coordinate + 1) % 5
            for first, second, third in perms:
                coefficient += (
                    int(values[first, coordinate])
                    * int(values[second, coordinate])
                    * int(values[third, successor])
                )
        row[monomial] = coefficient % P
    return row


def landing_equations(degree: int, seeds, kernel: np.ndarray):
    dimension = kernel.shape[0]
    monomials, data = cubic_monomial_data(dimension)
    rng = np.random.default_rng(690000 + degree)
    sample_count = {17: 30, 18: 50, 19: 180, 20: 350, 21: 600}[degree]
    points = rng.integers(0, P, size=(sample_count, 5), dtype=np.int64)
    seed_values = np.stack(
        evaluate_covariant_seeds(seeds, degree, points), axis=1
    )
    candidate_values = np.einsum(
        "kj,pji->pki", kernel, seed_values, dtype=np.int64
    ) % P
    echelon: list[tuple[int, np.ndarray]] = []
    rows = []
    for values in candidate_values:
        row = cubic_coefficient_row(values, data)
        if add_echelon(echelon, row):
            rows.append(row)
    return np.stack(rows), monomials


# Exact modular row reduction for the two theorem-forced Macaulay matrices.
# numba is used only for this dense finite-field rank kernel.
from numba import njit

@njit(cache=False)
def rank_mod_prime(matrix, prime):
    matrix = matrix.copy()
    rows, columns = matrix.shape
    inverses = np.zeros(prime, dtype=np.int64)
    for value in range(1, prime):
        for candidate in range(1, prime):
            if value * candidate % prime == 1:
                inverses[value] = candidate
                break
    rank = 0
    for column in range(columns):
        pivot = -1
        for row in range(rank, rows):
            if matrix[row, column] % prime:
                pivot = row
                break
        if pivot == -1:
            continue
        if pivot != rank:
            temporary = matrix[rank].copy()
            matrix[rank] = matrix[pivot]
            matrix[pivot] = temporary
        inverse = inverses[matrix[rank, column] % prime]
        for c in range(column, columns):
            matrix[rank, c] = matrix[rank, c] * inverse % prime
        for row in range(rank + 1, rows):
            factor = matrix[row, column] % prime
            if factor:
                matrix[row, column] = 0
                for c in range(column + 1, columns):
                    matrix[row, c] = (
                        matrix[row, c] - factor * matrix[rank, c]
                    ) % prime
        rank += 1
        if rank == rows or rank == columns:
            break
    return rank


def macaulay_degree_four(equations: np.ndarray, cubic_monomials, variables: int):
    quartics = list(compositions(4, variables))
    quartic_index = {exponents: index for index, exponents in enumerate(quartics)}
    matrix = np.zeros(
        (equations.shape[0] * variables, len(quartics)), dtype=np.int16
    )
    row = 0
    for equation in equations:
        nonzero = np.flatnonzero(equation)
        for variable in range(variables):
            columns = []
            coefficients = []
            for monomial in nonzero:
                exponents = list(cubic_monomials[monomial])
                exponents[variable] += 1
                columns.append(quartic_index[tuple(exponents)])
                coefficients.append(int(equation[monomial]))
            matrix[row, columns] = coefficients
            row += 1
    return rank_mod_prime(matrix.astype(np.int64), P), len(quartics)


def main() -> None:
    print("group_order=660 plus_dimension=3 minus_dimension=2")

    scalar_kernels = {}
    for degree in range(23):
        dimension = inv_dim(degree)
        if not dimension:
            scalar_kernels[degree] = 0
            continue
        seeds = invariant_seed_basis(degree)
        values = evaluate_invariant_seeds(
            seeds, degree, triangular_plane_points(degree)
        )
        scalar_kernels[degree] = dimension - len(rref(values)[1])
        assert scalar_kernels[degree] == 0
    seeds23 = invariant_seed_basis(23)
    values23 = evaluate_invariant_seeds(
        seeds23, 23, triangular_plane_points(23)
    )
    kernel23 = inv_dim(23) - len(rref(values23)[1])
    assert kernel23 == 1
    print("scalar_plus_plane_kernel_degrees_0_22=0")
    print("scalar_plus_plane_kernel_degree_23=1")

    all_data = {}
    for degree in range(15, 22):
        seeds = covariant_seed_basis(degree, COV_DIMS[degree])
        kernel = covariant_plane_kernel(degree, seeds)
        assert kernel.shape[0] == EXPECTED_KERNELS[degree]
        print(
            f"degree={degree} covariant_dimension={COV_DIMS[degree]} "
            f"plus_plane_kernel={kernel.shape[0]}"
        )
        if degree >= 17:
            equations, monomials = landing_equations(degree, seeds, kernel)
            assert equations.shape[0] == EXPECTED_CUBIC_RANKS[degree]
            print(
                f"degree={degree} cubic_equation_rank={equations.shape[0]} "
                f"cubic_coefficient_dimension={len(monomials)}"
            )
            all_data[degree] = (equations, monomials, kernel.shape[0])

    for degree in (17, 18, 19):
        equations, monomials, _ = all_data[degree]
        assert equations.shape[0] == len(monomials)
        print(f"degree={degree} projective_landing_locus=EMPTY_AT_CUBIC_LEVEL")

    for degree in (20, 21):
        equations, monomials, variables = all_data[degree]
        rank, quartic_dimension = macaulay_degree_four(
            equations, monomials, variables
        )
        assert rank == quartic_dimension
        print(
            f"degree={degree} quartic_macaulay_rank={rank} "
            f"quartic_dimension={quartic_dimension} "
            "projective_landing_locus=EMPTY"
        )

    print("LANDING_COVARIANTS_DEGREES_15_THROUGH_21_EXCLUDED")
    print("INVARIANT_PLUS_PLANE_RESTRICTION_INJECTIVE_THROUGH_DEGREE_22")
    print("DOMINANT_MAP_LOW_DEGREE_CERTIFICATE_OK")


if __name__ == "__main__":
    main()
