#!/usr/bin/env python3
"""Exact checks for the residual-multiplier saturation normal form.

The quartic coefficient columns are

    A^a B^b u^i v^j,  a+b <= 2,  i+j <= 4.

At x=[1:A:B], p=(0,0), ell={v=L*u}, and r=(T,L*T), restriction to
2p+r is written in the flat remainder frame (1,u,u^2).  The script checks
the coefficient-row splitting used in the saturation proof at T=0 and T=1,
then exhausts every multiplier in P^2(F_q) for q=5,7.
"""

from fractions import Fraction
from itertools import product


MONOMIALS = [
    (a, b, i, j)
    for a in range(3)
    for b in range(3 - a)
    for i in range(5)
    for j in range(5 - i)
]
assert len(MONOMIALS) == 90


def power_derivative(exponent, order, value):
    if exponent < order:
        return 0
    coefficient = 1
    for offset in range(order):
        coefficient *= exponent - offset
    return coefficient * value ** (exponent - order)


def remainder_derivative(power, component, t_order, t_value):
    if component < 2:
        return int(power == component and t_order == 0)
    if component == 2 and power >= 2:
        return power_derivative(power - 2, t_order, t_value)
    return 0


def section_row(component, orders, t_value):
    """Coefficient row of one A,B,L,T derivative of a remainder layer."""
    a_order, b_order, l_order, t_order = orders
    row = []
    for a, b, i, j in MONOMIALS:
        row.append(
            power_derivative(a, a_order, 0)
            * power_derivative(b, b_order, 0)
            * power_derivative(j, l_order, 0)
            * remainder_derivative(i + j, component, t_order, t_value)
        )
    return row


def linear_combination(rows, scalars):
    return [
        sum(scalar * row[column] for scalar, row in zip(scalars, rows))
        for column in range(len(rows[0]))
    ]


def exact_rank(matrix):
    matrix = [row for row in matrix if any(row)]
    if not matrix:
        return 0
    work = [[Fraction(entry) for entry in row] for row in matrix]
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(pivot_row, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        value = work[pivot_row][column]
        work[pivot_row] = [entry / value for entry in work[pivot_row]]
        for row in range(pivot_row + 1, len(work)):
            if not work[row][column]:
                continue
            scalar = work[row][column]
            work[row] = [
                entry - scalar * pivot_entry
                for entry, pivot_entry in zip(work[row], work[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == len(work):
            break
    return pivot_row


def rank_mod_prime(matrix, prime):
    matrix = [row for row in matrix if any(entry % prime for entry in row)]
    if not matrix:
        return 0
    work = [[entry % prime for entry in row] for row in matrix]
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(pivot_row, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, prime)
        work[pivot_row] = [entry * inverse % prime for entry in work[pivot_row]]
        for row in range(pivot_row + 1, len(work)):
            if not work[row][column]:
                continue
            scalar = work[row][column]
            work[row] = [
                (entry - scalar * pivot_entry) % prime
                for entry, pivot_entry in zip(work[row], work[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == len(work):
            break
    return pivot_row


def projective_points(dimension, prime):
    for first_nonzero in range(dimension + 1):
        for tail in product(range(prime), repeat=dimension - first_nonzero):
            yield tuple([0] * first_nonzero + [1] + list(tail))


def row_data(t_value):
    zero = (0, 0, 0, 0)
    a_order = (1, 0, 0, 0)
    b_order = (0, 1, 0, 0)
    l_order = (0, 0, 1, 0)
    t_order = (0, 0, 0, 1)
    return {
        "S": [section_row(component, zero, t_value) for component in range(3)],
        "A": [section_row(component, a_order, t_value) for component in range(3)],
        "B": [section_row(component, b_order, t_value) for component in range(3)],
        "L": [section_row(component, l_order, t_value) for component in range(3)],
        "T": [section_row(component, t_order, t_value) for component in range(3)],
    }


for t_value in (0, 1):
    data = row_data(t_value)
    section = data["S"]
    a_rows = data["A"]
    b_rows = data["B"]
    l_rows = data["L"]
    t_rows = data["T"]

    assert exact_rank(section) == 3
    assert exact_rank(a_rows) == 3
    assert exact_rank(b_rows) == 3
    assert exact_rank(l_rows) == 2
    assert exact_rank(t_rows) == 1
    assert not any(l_rows[0])
    assert not any(t_rows[0]) and not any(t_rows[1])

    # S0,S1,S2,W,A0,A1,A2,B0,B1,B2,L1,L2 are independent.
    active_t = t_rows[2]
    normal_form_rows = (
        section + [active_t] + a_rows + b_rows + [l_rows[1], l_rows[2]]
    )
    assert exact_rank(normal_form_rows) == 12
    assert all(rank_mod_prime(normal_form_rows, q) == 12 for q in (101, 103))

    for prime in (5, 7):
        unsaturated_counts = {5: 0, 6: 0, 7: 0}
        saturated_counts = {6: 0, 7: 0}
        for multiplier in projective_points(2, prime):
            a_lambda = linear_combination(a_rows, multiplier)
            b_lambda = linear_combination(b_rows, multiplier)
            l_lambda = linear_combination(l_rows, multiplier)
            unsaturated = section + [
                a_lambda,
                b_lambda,
                l_lambda,
                [multiplier[2] * entry for entry in active_t],
            ]
            saturated = section + [active_t, a_lambda, b_lambda, l_lambda]
            unsaturated_rank = rank_mod_prime(unsaturated, prime)
            saturated_rank = rank_mod_prime(saturated, prime)
            unsaturated_counts[unsaturated_rank] += 1
            saturated_counts[saturated_rank] += 1

            if multiplier[2] != 0:
                assert (unsaturated_rank, saturated_rank) == (7, 7)
            elif multiplier != (1, 0, 0):
                assert (unsaturated_rank, saturated_rank) == (6, 7)
            else:
                assert (unsaturated_rank, saturated_rank) == (5, 6)

        assert unsaturated_counts == {5: 1, 6: prime, 7: prime**2}
        assert saturated_counts == {6: 1, 7: prime**2 + prime}

    # At [lambda]=[1:0:0], the transverse-node locus adds L1=L2=0.
    singular_rows = (
        section
        + [active_t, a_rows[0], b_rows[0], l_rows[1], l_rows[2]]
    )
    assert exact_rank(singular_rows) == 8
    assert all(rank_mod_prime(singular_rows, q) == 8 for q in (101, 103))
    print(
        f"T={t_value}: row splitting, unsaturated/saturated ranks, "
        "and eight-row node locus: PASS"
    )


# On the lambda_0 chart the only nonlinear transverse equation is
# lambda_1*l_1 + lambda_2*l_2.  Twice this quadratic has the symmetric matrix
# below.  Full rank four proves that it is not a product of linear forms and
# identifies its origin as an ordinary quadric-cone singularity.
quadric_matrix = [
    [0, 0, 1, 0],
    [0, 0, 0, 1],
    [1, 0, 0, 0],
    [0, 1, 0, 0],
]
assert exact_rank(quadric_matrix) == 4
assert all(rank_mod_prime(quadric_matrix, q) == 4 for q in (5, 7, 101, 103))
print("lambda1*l1 + lambda2*l2 is an irreducible rank-four quadric: PASS")

print("special-seed residual saturation checks: PASS")
