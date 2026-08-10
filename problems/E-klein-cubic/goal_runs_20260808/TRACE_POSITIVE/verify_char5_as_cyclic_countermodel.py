#!/usr/bin/env python3
"""Exact cyclic-field countermodels for the four progression systems.

This is a fixed calculation in the 3125-element field

    L = F_5[t]/(t^5-t-1),    sigma(x) = x^5.

It does not enumerate polynomial degrees or Laurent supports.  The complete
field enumeration is used only to count the zero locus of each of the four
fixed 5 by 5 determinant systems.  The stronger multiplicatively compatible
countermodels are then checked by direct substitution from four stored pairs
(z,u).
"""

from itertools import product


P = 5
ZERO = (0, 0, 0, 0, 0)
ONE = (1, 0, 0, 0, 0)
T = (0, 1, 0, 0, 0)
FIELD_ORDER = P**5


def add(a, b):
    return tuple((x + y) % P for x, y in zip(a, b))


def neg(a):
    return tuple((-x) % P for x in a)


def sub(a, b):
    return add(a, neg(b))


def scale(n, a):
    return tuple((n * x) % P for x in a)


def mul(a, b):
    coefficients = [0] * 9
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            coefficients[i + j] = (
                coefficients[i + j] + x * y
            ) % P

    # t^5=t+1, hence t^n=t^(n-4)+t^(n-5) for n>=5.
    for n in range(8, 4, -1):
        coefficients[n - 4] = (
            coefficients[n - 4] + coefficients[n]
        ) % P
        coefficients[n - 5] = (
            coefficients[n - 5] + coefficients[n]
        ) % P
    return tuple(coefficients[:5])


def power(a, exponent):
    result = ONE
    while exponent:
        if exponent & 1:
            result = mul(result, a)
        a = mul(a, a)
        exponent //= 2
    return result


def inverse(a):
    assert a != ZERO
    return power(a, FIELD_ORDER - 2)


def sigma(a):
    return power(a, P)


def orbit(a):
    values = [a]
    for _ in range(4):
        values.append(sigma(values[-1]))
    return values


def field_sum(values):
    result = ZERO
    for value in values:
        result = add(result, value)
    return result


def progression_matrix(c, z):
    matrix = [[ZERO for _ in range(5)] for _ in range(5)]
    for row in range(5):
        i0 = row
        i1 = (row + c) % 5
        i2 = (row + 2 * c) % 5
        i3 = (row + 3 * c) % 5

        matrix[row][i0] = add(matrix[row][i0], ONE)
        matrix[row][i1] = add(
            matrix[row][i1],
            add(z[(i1 + 1) % 5], scale(2, z[i1])),
        )
        matrix[row][i2] = add(
            matrix[row][i2],
            add(
                scale(2, mul(z[i2], z[(i2 + 1) % 5])),
                mul(z[i2], z[i2]),
            ),
        )
        matrix[row][i3] = add(
            matrix[row][i3],
            mul(mul(z[i3], z[i3]), z[(i3 + 1) % 5]),
        )
    return matrix


def matrix_vector_product(matrix, vector):
    return [
        field_sum(mul(entry, value) for entry, value in zip(row, vector))
        for row in matrix
    ]


def rank_and_determinant(matrix):
    matrix = [row[:] for row in matrix]
    rank = 0
    determinant = ONE
    for column in range(5):
        pivot = next(
            (row for row in range(rank, 5) if matrix[row][column] != ZERO),
            None,
        )
        if pivot is None:
            determinant = ZERO
            continue
        if pivot != rank:
            matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
            determinant = neg(determinant)
        pivot_value = matrix[rank][column]
        determinant = mul(determinant, pivot_value)
        pivot_inverse = inverse(pivot_value)
        matrix[rank] = [mul(pivot_inverse, x) for x in matrix[rank]]
        for row in range(rank + 1, 5):
            if matrix[row][column] == ZERO:
                continue
            factor = matrix[row][column]
            matrix[row] = [
                sub(x, mul(factor, y))
                for x, y in zip(matrix[row], matrix[rank])
            ]
        rank += 1
    if rank < 5:
        determinant = ZERO
    return rank, determinant


# Coefficients are in the basis (1,t,t^2,t^3,t^4).
WITNESSES = {
    1: {
        "z": (0, 0, 0, 0, 1),
        "u": (1, 1, 1, 4, 0),
        "K_u": ONE,
        "K_v": (2, 0, 0, 0, 0),
    },
    2: {
        "z": (0, 0, 0, 0, 2),
        "u": (1, 1, 3, 0, 2),
        "K_u": (3, 0, 0, 0, 0),
        "K_v": (3, 0, 0, 0, 0),
    },
    3: {
        "z": (0, 0, 0, 0, 2),
        "u": (1, 0, 4, 1, 3),
        "K_u": ONE,
        "K_v": (2, 0, 0, 0, 0),
    },
    4: {
        "z": (0, 0, 0, 0, 1),
        "u": (1, 4, 0, 3, 4),
        "K_u": (3, 0, 0, 0, 0),
        "K_v": (3, 0, 0, 0, 0),
    },
}

EXPECTED_NONINVARIANT_DETERMINANT_ZEROS = {
    1: 800,
    2: 840,
    3: 840,
    4: 800,
}


def main():
    # This verifies both the defining Artin--Schreier relation and that t has
    # degree exactly five over F_5.
    assert sub(power(T, 5), T) == ONE
    assert power(T, FIELD_ORDER) == T
    assert all(power(T, P**degree) != T for degree in range(1, 5))
    assert sigma(T) == add(T, ONE)

    elements = list(product(range(P), repeat=5))

    for c in range(1, 5):
        witness = WITNESSES[c]
        z = orbit(witness["z"])
        u = orbit(witness["u"])
        assert len(set(z)) == 5
        assert len(set(u)) == 5

        a = [mul(mul(u[i], u[i]), u[(i + 1) % 5]) for i in range(5)]
        v = [mul(u[i], z[i]) for i in range(5)]
        a_v = [mul(mul(v[i], v[i]), v[(i + 1) % 5]) for i in range(5)]
        matrix = progression_matrix(c, z)

        rank, determinant = rank_and_determinant(matrix)
        assert rank == 4
        assert determinant == ZERO
        assert matrix_vector_product(matrix, a) == [ZERO] * 5
        assert field_sum(a) == witness["K_u"] != ZERO
        assert field_sum(a_v) == witness["K_v"] != ZERO

        zero_count = 0
        for element in elements:
            conjugates = orbit(element)
            if len(set(conjugates)) == 1:
                continue
            _, value = rank_and_determinant(progression_matrix(c, conjugates))
            if value == ZERO:
                zero_count += 1
        assert zero_count == EXPECTED_NONINVARIANT_DETERMINANT_ZEROS[c]

        print(
            f"c={c} rank={rank} noninvariant_det_zeros={zero_count} "
            f"K_u={field_sum(a)} K_v={field_sum(a_v)}"
        )

    print("F55-CHAR5-AS-CYCLIC-PROGRESSION-COUNTERMODEL-OK")


if __name__ == "__main__":
    main()
