#!/usr/bin/env python3
"""Exact local rank checks for the quartic special-seed multijet frontier.

This checker is deliberately narrower than a global transversality proof.  It
checks, over QQ, the two-point O(2) first-jet obstruction and a collection of
singularity-specific coefficient matrices in the flat 2p+r frame.  It also
replays the displayed ranks modulo two primes.

Coordinates are

    x = [1:A:B],  p = (u=v=0),  ell = {v=L*u},  r = (T,L*T).

The 90 coefficient columns are A^a B^b u^i v^j with a+b <= 2 and
i+j <= 4.  The length-three remainder is taken modulo u^2(u-T).
"""

from fractions import Fraction
from math import comb


MONOMIALS = [
    (a, b, i, j)
    for a in range(3)
    for b in range(3 - a)
    for i in range(5)
    for j in range(5 - i)
]
assert len(MONOMIALS) == 90


def falling(exponent, order):
    if exponent < order:
        return 0
    answer = 1
    for offset in range(order):
        answer *= exponent - offset
    return answer


def power_derivative(exponent, order, value):
    if exponent < order:
        return 0
    return falling(exponent, order) * value ** (exponent - order)


def remainder_derivative(power, component, order, t_value):
    """Derivative of a flat length-three remainder coefficient."""
    if component < 2:
        return int(power == component and order == 0)
    if component == 2 and power >= 2:
        return power_derivative(power - 2, order, t_value)
    return 0


def section_derivative_row(component, orders, point):
    """One coefficient row for a derivative of a remainder component."""
    a_order, b_order, l_order, t_order = orders
    a_value, b_value, l_value, t_value = point
    row = []
    for a, b, i, j in MONOMIALS:
        row.append(
            power_derivative(a, a_order, a_value)
            * power_derivative(b, b_order, b_value)
            * power_derivative(j, l_order, l_value)
            * remainder_derivative(i + j, component, t_order, t_value)
        )
    return row


def linear_combination(rows, scalars):
    return [
        sum(scalar * row[column] for scalar, row in zip(scalars, rows))
        for column in range(len(rows[0]))
    ]


def row_subtract(left, right, right_scalar=1):
    return [a - right_scalar * b for a, b in zip(left, right)]


UNIT_ORDERS = [
    tuple(int(index == variable) for index in range(4))
    for variable in range(4)
]


def directional_row(component, direction, order, point):
    rows = []
    scalars = []
    for orders in _orders_of_total(order):
        coefficient = _multinomial(order, orders)
        for index, exponent in enumerate(orders):
            coefficient *= direction[index] ** exponent
        if coefficient:
            rows.append(section_derivative_row(component, orders, point))
            scalars.append(coefficient)
    if not rows:
        return [0] * len(MONOMIALS)
    return linear_combination(rows, scalars)


def mixed_directional_row(component, direction, variable, point):
    rows = []
    for direction_index in range(4):
        orders = [0, 0, 0, 0]
        orders[direction_index] += 1
        orders[variable] += 1
        rows.append(section_derivative_row(component, tuple(orders), point))
    return linear_combination(rows, direction)


def _orders_of_total(total):
    for first in range(total + 1):
        for second in range(total - first + 1):
            for third in range(total - first - second + 1):
                fourth = total - first - second - third
                yield first, second, third, fourth


def _multinomial(total, orders):
    answer = 1
    remaining = total
    for order in orders:
        answer *= comb(remaining, order)
        remaining -= order
    return answer


def critical_rows(point, multiplier):
    """s=0 and lambda*D_vertical(s)=0: seven rows."""
    section_rows = [
        section_derivative_row(component, (0, 0, 0, 0), point)
        for component in range(3)
    ]
    first_rows = [
        [section_derivative_row(component, orders, point)
         for orders in UNIT_ORDERS]
        for component in range(3)
    ]
    lagrange_rows = [
        linear_combination(
            [first_rows[component][variable] for component in range(3)],
            multiplier,
        )
        for variable in range(4)
    ]
    return section_rows + lagrange_rows


def radical_rows(point, multiplier, direction, auxiliary):
    """Critical rows plus Jk=0 and q(k,-)=mu J."""
    answer = critical_rows(point, multiplier)
    first_rows = [
        [section_derivative_row(component, orders, point)
         for orders in UNIT_ORDERS]
        for component in range(3)
    ]
    answer.extend(
        linear_combination(first_rows[component], direction)
        for component in range(3)
    )
    for variable in range(4):
        hessian_row = linear_combination(
            [mixed_directional_row(component, direction, variable, point)
             for component in range(3)],
            multiplier,
        )
        auxiliary_jacobian_row = linear_combination(
            [first_rows[component][variable] for component in range(3)],
            auxiliary,
        )
        answer.append(row_subtract(hessian_row, auxiliary_jacobian_row))
    return answer


def cubic_row(point, multiplier, direction, auxiliary):
    """Intrinsic cubic after eliminating the three constraints.

    If q(k,-)=mu J and Ja=-s''(k,k), the reduced cubic is
    lambda*s'''(k,k,k)-3*mu*s''(k,k).
    """
    third = linear_combination(
        [directional_row(component, direction, 3, point)
         for component in range(3)],
        multiplier,
    )
    second = linear_combination(
        [directional_row(component, direction, 2, point)
         for component in range(3)],
        auxiliary,
    )
    return row_subtract(third, second, right_scalar=3)


def exact_rank(matrix):
    work = [[Fraction(entry) for entry in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (candidate for candidate in range(row, len(work))
             if work[candidate][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        pivot_value = work[row][column]
        work[row] = [entry / pivot_value for entry in work[row]]
        for other in range(row + 1, len(work)):
            if not work[other][column]:
                continue
            scalar = work[other][column]
            work[other] = [
                entry - scalar * pivot_entry
                for entry, pivot_entry in zip(work[other], work[row])
            ]
        row += 1
        if row == len(work):
            break
    return row


def rank_mod_prime(matrix, prime):
    work = [[entry % prime for entry in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (candidate for candidate in range(row, len(work))
             if work[candidate][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, prime)
        work[row] = [entry * inverse % prime for entry in work[row]]
        for other in range(row + 1, len(work)):
            if not work[other][column]:
                continue
            scalar = work[other][column]
            work[other] = [
                (entry - scalar * pivot_entry) % prime
                for entry, pivot_entry in zip(work[other], work[row])
            ]
        row += 1
        if row == len(work):
            break
    return row


def assert_exact_rank(label, matrix, expected):
    rational_rank = exact_rank(matrix)
    assert rational_rank == expected, (label, rational_rank, expected)
    modular_ranks = tuple(rank_mod_prime(matrix, prime) for prime in (101, 103))
    assert modular_ranks == (expected, expected), (label, modular_ranks)
    print(f"{label}: rank {expected} over QQ (and F101,F103)")


# ---------------------------------------------------------------------------
# The full two-point J^1 evaluation obstruction in the x-plane.


def quadratic_two_jet_matrix():
    # Basis 1,A,B,A^2,AB,B^2; points (0,0) and (1,0).
    basis = [(0, 0), (1, 0), (0, 1), (2, 0), (1, 1), (0, 2)]
    rows = []
    for a_value, b_value in ((0, 0), (1, 0)):
        rows.append([
            a_value ** a * b_value ** b for a, b in basis
        ])
        rows.append([
            power_derivative(a, 1, a_value) * b_value ** b
            for a, b in basis
        ])
        rows.append([
            a_value ** a * power_derivative(b, 1, b_value)
            for a, b in basis
        ])
    return rows


two_jet_matrix = quadratic_two_jet_matrix()
assert_exact_rank("O(2) at two first jets", two_jet_matrix, 5)
kernel_vector = [0, 0, 0, 0, 0, 1]  # B^2, the joining line squared.
assert all(
    sum(entry * coefficient for entry, coefficient in zip(row, kernel_vector)) == 0
    for row in two_jet_matrix
)
assert 5 * 15 == 75
print("tensoring with H0(O_y(4)) gives rank 75, not 90: PASS")


# ---------------------------------------------------------------------------
# One-point critical, boundary, and fold/cusp-specific rows.


MULTIPLIER = (2, 3, 1)
AUXILIARY = (1, 4, 2)


def coefficient_evaluation_row(x_order_a, x_order_b, y_i, y_j):
    return [
        int(a == x_order_a and b == x_order_b and i == y_i and j == y_j)
        * falling(a, x_order_a) * falling(b, x_order_b)
        for a, b, i, j in MONOMIALS
    ]


for t_value in (0, 1):
    point = (0, 0, 0, t_value)
    critical = critical_rows(point, MULTIPLIER)
    assert_exact_rank(f"critical rows T={t_value}", critical, 7)

    tangent_gradient = [
        coefficient_evaluation_row(0, 0, 0, 0),
        coefficient_evaluation_row(0, 0, 1, 0),
        coefficient_evaluation_row(0, 0, 0, 1),
    ]
    assert_exact_rank(
        f"critical plus tangent-base gradient T={t_value}",
        critical + tangent_gradient,
        8,
    )

    conic_gradient = [
        coefficient_evaluation_row(0, 0, 0, 0),
        coefficient_evaluation_row(1, 0, 0, 0),
        coefficient_evaluation_row(0, 1, 0, 0),
    ]
    assert_exact_rank(
        f"critical plus conic-fiber gradient T={t_value}",
        critical + conic_gradient,
        9,
    )


direction_cases = {
    "x-supported generic": (1, 2, 3, 4),
    "pure x-plane": (1, 1, 0, 0),
    "no-x mixed L,T": (0, 0, 1, 1),
    "pure L": (0, 0, 1, 0),
    "pure T": (0, 0, 0, 1),
}

expected_direction_ranks = {
    0: {
        "x-supported generic": (13, 14),
        "pure x-plane": (13, 14),
        "no-x mixed L,T": (12, 13),
        "pure L": (12, 12),
        "pure T": (11, 11),
    },
    1: {
        "x-supported generic": (13, 14),
        "pure x-plane": (13, 14),
        "no-x mixed L,T": (12, 13),
        "pure L": (12, 13),
        "pure T": (11, 11),
    },
}

for t_value in (0, 1):
    point = (0, 0, 0, t_value)
    for label, direction in direction_cases.items():
        radical = radical_rows(point, MULTIPLIER, direction, AUXILIARY)
        with_cubic = radical + [
            cubic_row(point, MULTIPLIER, direction, AUXILIARY)
        ]
        expected_radical, expected_cubic = expected_direction_ranks[t_value][label]
        assert_exact_rank(
            f"radical rows T={t_value}, {label}",
            radical,
            expected_radical,
        )
        assert_exact_rank(
            f"radical+cubic T={t_value}, {label}",
            with_cubic,
            expected_cubic,
        )


# ---------------------------------------------------------------------------
# Two residual critical points over one marked base point p.


def two_point_rows(first, second):
    return critical_rows(first[0], first[1]) + critical_rows(second[0], second[1])


two_point_cases = {
    "distinct x, distinct lines": (
        ((0, 0, 0, 1), (2, 3, 1)),
        ((1, 0, 1, 1), (4, 5, 1)),
        14,
    ),
    "distinct x, same line, distinct r": (
        ((0, 0, 0, 1), (2, 3, 1)),
        ((1, 0, 0, 2), (4, 5, 1)),
        14,
    ),
    "distinct x, identical y-flag and multiplier": (
        ((0, 0, 0, 1), (2, 3, 1)),
        ((1, 0, 0, 1), (2, 3, 1)),
        13,
    ),
    "same x, distinct lines": (
        ((0, 0, 0, 1), (2, 3, 1)),
        ((0, 0, 1, 1), (4, 5, 1)),
        13,
    ),
    "same x, distinct lines, both diagonal": (
        ((0, 0, 0, 0), (2, 3, 1)),
        ((0, 0, 1, 0), (4, 5, 1)),
        12,
    ),
    "same x and line, distinct residual points": (
        ((0, 0, 0, 1), (2, 3, 1)),
        ((0, 0, 0, 2), (4, 5, 1)),
        11,
    ),
}

for label, (first, second, expected) in two_point_cases.items():
    assert_exact_rank(
        f"two critical points: {label}",
        two_point_rows(first, second),
        expected,
    )


# Three representative points: this is only a diagnostic for the remaining
# triple-coincidence audit, not a global projective-stratum proof.
triple_generic = sum(
    (
        critical_rows(point, multiplier)
        for point, multiplier in (
            ((0, 0, 0, 1), (2, 3, 1)),
            ((1, 0, 1, 2), (4, 5, 1)),
            ((0, 1, 2, 3), (6, 7, 1)),
        )
    ),
    [],
)
assert_exact_rank("three critical points: generic representative", triple_generic, 21)

triple_same_x = sum(
    (
        critical_rows(point, multiplier)
        for point, multiplier in (
            ((0, 0, 0, 1), (2, 3, 1)),
            ((0, 0, 1, 2), (4, 5, 1)),
            ((0, 0, 2, 3), (6, 7, 1)),
        )
    ),
    [],
)
assert_exact_rank("three critical points: same x representative", triple_same_x, 18)

print("special-seed multijet reduction checks: PASS")
