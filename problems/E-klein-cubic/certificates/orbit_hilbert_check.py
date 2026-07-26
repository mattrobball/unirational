#!/usr/bin/env python3
"""Replay the good-reduction Hilbert audit for the 220-point C3 orbit.

The characteristic-zero Klein representation is imported from the existing
exact cyclotomic certificate and evaluated at zeta_11 = 74 in F_331.  All
linear algebra below is deterministic and exact over the prime field.
"""

from functools import reduce
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "certificates"))

import exact_weil_check as ew  # noqa: E402


PRIME = 331
ZETA = 74
EIGENVALUE = 31
SEED = (1, 127, 279, 301, 132)
EXPECTED_RANKS = [1, 5, 15, 34, 65, 110, 165, 220]
EXPECTED_X_SECTIONS = [1, 5, 15, 34, 65, 111, 175, 260]


def reduce_fraction(value):
    numerator = value.numerator % PRIME
    denominator = value.denominator % PRIME
    assert denominator
    return numerator * pow(denominator, -1, PRIME) % PRIME


def reduce_cyclotomic(value):
    """Evaluate an ew.C element at zeta_11 = 74 modulo 331."""

    return sum(
        reduce_fraction(coefficient) * pow(ZETA, exponent, PRIME)
        for exponent, coefficient in enumerate(value.a)
    ) % PRIME


def reduce_matrix(matrix):
    return [[reduce_cyclotomic(entry) for entry in row] for row in matrix]


def matrix_multiply(left, right):
    return [[
        sum(left[i][k] * right[k][j] for k in range(5)) % PRIME
        for j in range(5)
    ] for i in range(5)]


IDENTITY = [[int(i == j) for j in range(5)] for i in range(5)]


def matrix_power(matrix, exponent):
    result = IDENTITY
    base = matrix
    while exponent:
        if exponent & 1:
            result = matrix_multiply(result, base)
        base = matrix_multiply(base, base)
        exponent //= 2
    return result


def matrix_vector(matrix, vector):
    return [
        sum(matrix[i][j] * vector[j] for j in range(5)) % PRIME
        for i in range(5)
    ]


def projective_normalize(vector):
    pivot = next(entry for entry in vector if entry % PRIME)
    inverse = pow(pivot, -1, PRIME)
    return tuple(entry * inverse % PRIME for entry in vector)


def klein(vector):
    return sum(
        vector[i] * vector[i] * vector[(i + 1) % 5]
        for i in range(5)
    ) % PRIME


def klein_gradient(vector):
    return [
        (2 * vector[i] * vector[(i + 1) % 5]
         + vector[(i - 1) % 5] ** 2) % PRIME
        for i in range(5)
    ]


def monomial_exponents(total, variables=5, prefix=()):
    if variables == 1:
        return [prefix + (total,)]
    output = []
    for exponent in range(total + 1):
        output.extend(monomial_exponents(
            total - exponent, variables - 1, prefix + (exponent,)
        ))
    return output


def matrix_rank(rows):
    """Sparse-pivot Gauss elimination over F_331."""

    pivots = {}
    for original in rows:
        row = list(original)
        while True:
            column = next((i for i, entry in enumerate(row) if entry), None)
            if column is None:
                break
            if column in pivots:
                scalar = row[column]
                row = [
                    (entry - scalar * pivot_entry) % PRIME
                    for entry, pivot_entry in zip(row, pivots[column])
                ]
            else:
                inverse = pow(row[column], -1, PRIME)
                pivots[column] = [entry * inverse % PRIME for entry in row]
                break
    return len(pivots)


def evaluation_rank(points, degree):
    exponents = monomial_exponents(degree)
    rows = []
    for point in points:
        powers = [
            [pow(point[i], exponent, PRIME) for exponent in range(degree + 1)]
            for i in range(5)
        ]
        rows.append([
            reduce(
                lambda product, item: (
                    product * powers[item[0]][item[1]] % PRIME
                ),
                enumerate(monomial),
                1,
            )
            for monomial in exponents
        ])
    return matrix_rank(rows)


def main():
    assert pow(ZETA, 11, PRIME) == 1
    assert all(pow(ZETA, exponent, PRIME) != 1 for exponent in range(1, 11))
    assert pow(EIGENVALUE, 3, PRIME) == 1 and EIGENVALUE != 1

    s_matrix = reduce_matrix(ew.S)
    t_matrix = reduce_matrix(ew.T)
    st_matrix = matrix_multiply(s_matrix, t_matrix)

    assert matrix_power(s_matrix, 2) == IDENTITY
    assert matrix_power(t_matrix, 11) == IDENTITY
    assert matrix_power(st_matrix, 3) == IDENTITY

    # Good reduction preserves all 660 distinct matrices of the exact action.
    reduced_group = {
        tuple(entry for row in reduce_matrix(matrix) for entry in row)
        for matrix in ew.rho.values()
    }
    assert len(ew.rho) == 660
    assert len(reduced_group) == 660

    # The primitive C3 eigenspace and a simple point of its cubic section.
    basis_zero = (276, 234, 330, 1, 0)
    basis_one = (316, 172, 205, 0, 1)
    assert matrix_vector(st_matrix, basis_zero) == [
        EIGENVALUE * entry % PRIME for entry in basis_zero
    ]
    assert matrix_vector(st_matrix, basis_one) == [
        EIGENVALUE * entry % PRIME for entry in basis_one
    ]

    parameter = 128
    raw_point = tuple(
        (left + parameter * right) % PRIME
        for left, right in zip(basis_zero, basis_one)
    )
    assert projective_normalize(raw_point) == SEED
    assert klein(raw_point) == 0
    derivative = sum(
        gradient_entry * direction_entry
        for gradient_entry, direction_entry
        in zip(klein_gradient(raw_point), basis_one)
    ) % PRIME
    assert derivative == 28

    assert matrix_vector(st_matrix, SEED) == [
        EIGENVALUE * entry % PRIME for entry in SEED
    ]
    assert klein(SEED) == 0

    # Projective orbit generated by S and T.
    orbit = {SEED}
    queue = [SEED]
    while queue:
        point = queue.pop()
        for generator in (s_matrix, t_matrix):
            candidate = projective_normalize(matrix_vector(generator, point))
            if candidate not in orbit:
                orbit.add(candidate)
                queue.append(candidate)
    assert len(orbit) == 220
    assert all(klein(point) == 0 for point in orbit)

    ranks = [evaluation_rank(orbit, degree) for degree in range(8)]
    assert ranks == EXPECTED_RANKS

    section_dimensions = []
    for degree in range(8):
        ambient = len(monomial_exponents(degree))
        multiples_of_f = (
            len(monomial_exponents(degree - 3)) if degree >= 3 else 0
        )
        section_dimensions.append(ambient - multiples_of_f)
    assert section_dimensions == EXPECTED_X_SECTIONS

    print("PASS reduced Klein action has 660 distinct matrices over F_331")
    print("PASS primitive C3 eigenpoint is simple and has projective orbit 220")
    print("PASS orbit lies on the Klein cubic")
    print("PASS evaluation ranks degrees 0..7:", ranks)
    print("PASS X section dimensions degrees 0..7:", section_dimensions)


if __name__ == "__main__":
    main()
