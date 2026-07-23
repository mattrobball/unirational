#!/usr/bin/env python3
"""Exact arithmetic checks for the special-seed stability frontier.

This script has no third-party dependencies.  It checks

* the Chow-ring arithmetic of the marked double-residual surface; and
* the flat length-three and length-four first-jet rank strata at a
  distinct pair and on the diagonal, exhaustively over two finite fields.

The finite-field calculation is a replay of integer matrices.  The theorem
note gives the characteristic-zero row-space proof; this script makes the
diagonal and the stated stratum counts mechanically reproducible.
"""

from collections import defaultdict
from itertools import product


# ---------------------------------------------------------------------------
# Truncated Chow ring of four projective planes.
# Monomials are H^a P^b J^c R^d, with every exponent at most two.


ZERO = (0, 0, 0, 0)
TOP = (2, 2, 2, 2)


def poly_add(left, right):
    out = defaultdict(int)
    out.update(left)
    for monomial, coefficient in right.items():
        out[monomial] += coefficient
    return {monomial: coefficient for monomial, coefficient in out.items()
            if coefficient}


def poly_mul(left, right):
    out = defaultdict(int)
    for first, first_coefficient in left.items():
        for second, second_coefficient in right.items():
            monomial = tuple(first[i] + second[i] for i in range(4))
            if all(exponent <= 2 for exponent in monomial):
                out[monomial] += first_coefficient * second_coefficient
    return dict(out)


def linear(h=0, p=0, j=0, r=0):
    return {
        (1, 0, 0, 0): h,
        (0, 1, 0, 0): p,
        (0, 0, 1, 0): j,
        (0, 0, 0, 1): r,
    }


def multiply_all(factors):
    answer = {ZERO: 1}
    for factor in factors:
        answer = poly_mul(answer, factor)
    return answer


def integral(class_):
    return class_.get(TOP, 0)


d = 4
evaluation_roots = [
    linear(h=2, p=d),
    linear(h=2, p=d - 2, j=1),
    linear(h=2, p=-2, j=2, r=d - 2),
    linear(h=2, p=-2, j=3, r=d - 4),
]
incidence_class = poly_mul(
    poly_add(linear(p=1), linear(j=1)),
    poly_add(linear(r=1), linear(j=1)),
)
marked_surface = multiply_all(evaluation_roots + [incidence_class])

H = linear(h=1)
P = linear(p=1)
J = linear(j=1)
K = linear(h=5, j=5)
RAMIFICATION = linear(h=5, p=3, j=5)


def intersection(first, second):
    return integral(multiply_all([first, second, marked_surface]))


assert intersection(P, P) == 32
assert intersection(H, H) == 56
assert intersection(K, K) == 5400
assert intersection(K, RAMIFICATION) == 7740
assert intersection(RAMIFICATION, RAMIFICATION) == 10368
assert intersection(P, RAMIFICATION) == 876
assert 1 + (intersection(K, RAMIFICATION)
            + intersection(RAMIFICATION, RAMIFICATION)) // 2 == 9055
print("double-residual Chow and ramification arithmetic: PASS")


# ---------------------------------------------------------------------------
# Flat first-jet matrices.


MONOMIALS = [
    (a, b, i, j)
    for a in range(3)
    for b in range(3 - a)
    for i in range(5)
    for j in range(5 - i)
]
assert len(MONOMIALS) == 90


def projective_points(dimension, prime):
    """Normalized points of P^dimension(F_prime)."""
    for first_nonzero in range(dimension + 1):
        tail_length = dimension - first_nonzero
        for tail in product(range(prime), repeat=tail_length):
            yield tuple([0] * first_nonzero + [1] + list(tail))


def power_value(exponent, value, prime):
    if exponent < 0:
        return 0
    return pow(value, exponent, prime)


def power_derivative(exponent, value, prime):
    if exponent <= 0:
        return 0
    return exponent * pow(value, exponent - 1, prime) % prime


def length_three_terms(power, component):
    if component < 2 and power == component:
        return ((1, 0),)
    if component == 2 and power >= 2:
        return ((1, power - 2),)
    return ()


def length_four_terms(power, component):
    if component < 2 and power == component:
        return ((1, 0),)
    if component == 2 and power >= 2:
        return ((3 - power, power - 2),)
    if component == 3 and power >= 3:
        return ((power - 2, power - 3),)
    return ()


def matrix_entry(monomial, component, derivative, t_value, prime,
                 remainder_terms):
    """Coefficient or one vertical derivative in the flat remainder."""
    a, b, i, j = monomial
    restricted_power = i + j
    answer = 0
    for scalar, t_exponent in remainder_terms(restricted_power, component):
        exponents = {"A": a, "B": b, "L": j, "T": t_exponent}
        values = {"A": 0, "B": 0, "L": 0, "T": t_value}
        term = scalar % prime
        for variable, exponent in exponents.items():
            if variable == derivative:
                term *= power_derivative(exponent, values[variable], prime)
            else:
                term *= power_value(exponent, values[variable], prime)
            term %= prime
        answer = (answer + term) % prime
    return answer


def matrix_rank_mod_prime(matrix, prime):
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
        for other in range(len(work)):
            if other == row or not work[other][column]:
                continue
            multiplier = work[other][column]
            work[other] = [
                (entry - multiplier * pivot_entry) % prime
                for entry, pivot_entry in zip(work[other], work[row])
            ]
        row += 1
        if row == len(work):
            break
    return row


def lagrange_matrix(length, multiplier, t_value, prime):
    if length == 3:
        remainder_terms = length_three_terms
    elif length == 4:
        remainder_terms = length_four_terms
    else:
        raise ValueError(length)

    rows = [
        [matrix_entry(monomial, component, None, t_value, prime,
                      remainder_terms)
         for monomial in MONOMIALS]
        for component in range(length)
    ]
    for derivative in ("A", "B", "L", "T"):
        rows.append([
            sum(
                multiplier[component]
                * matrix_entry(monomial, component, derivative, t_value,
                               prime, remainder_terms)
                for component in range(length)
            ) % prime
            for monomial in MONOMIALS
        ])
    return rows


def expected_length_three_rank(multiplier, _t_value, _prime):
    if multiplier == (1, 0, 0):
        return 5
    if multiplier[2] == 0:
        return 6
    return 7


def expected_length_four_rank(multiplier, t_value, prime):
    if multiplier == (1, 0, 0, 0):
        return 6
    if t_value == 0:
        in_quotient_plane = multiplier[3] == 0
    else:
        # The checker uses T=1.  This is the dual plane of the quotient
        # from 2p+2r to 2p+r in the flat remainder frame.
        in_quotient_plane = (multiplier[2] - multiplier[3]) % prime == 0
    return 7 if in_quotient_plane else 8


for prime in (5, 7):
    for t_value in (0, 1):
        counts_three = defaultdict(int)
        for multiplier in projective_points(2, prime):
            rank = matrix_rank_mod_prime(
                lagrange_matrix(3, multiplier, t_value, prime), prime
            )
            assert rank == expected_length_three_rank(
                multiplier, t_value, prime
            )
            counts_three[rank] += 1
        assert dict(counts_three) == {5: 1, 6: prime, 7: prime**2}

        counts_four = defaultdict(int)
        for multiplier in projective_points(3, prime):
            rank = matrix_rank_mod_prime(
                lagrange_matrix(4, multiplier, t_value, prime), prime
            )
            assert rank == expected_length_four_rank(
                multiplier, t_value, prime
            )
            counts_four[rank] += 1
        assert dict(counts_four) == {
            6: 1,
            7: prime**2 + prime,
            8: prime**3,
        }

print("flat length-3/4 ranks at distinct and diagonal flags (F5,F7): PASS")
print("special-seed stability frontier checks: PASS")
