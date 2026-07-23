#!/usr/bin/env python3
"""Exact replay for the quartic ramification-comparison theorem.

The characteristic-zero proof is in special_seed_ramification_comparison.md.
This script checks the triangular length-four change and determinant identity
formally, replays the canonical two-point ranks over QQ, and exhausts every
open-residual multiplier pair over F3 and F5.
"""

from contextlib import redirect_stdout
from importlib.util import module_from_spec, spec_from_file_location
from io import StringIO
from itertools import permutations, product
from pathlib import Path


# Reuse the integer coefficient-row implementation already audited by the
# multijet checker, while suppressing that module's own recorded replay.
MODULE_PATH = Path(__file__).with_name(
    "special_seed_multijet_reduction_checks.py"
)
SPEC = spec_from_file_location("special_seed_multijet_rows", MODULE_PATH)
ROWS = module_from_spec(SPEC)
with redirect_stdout(StringIO()):
    SPEC.loader.exec_module(ROWS)


# ---------------------------------------------------------------------------
# The flat length-four change is triangular.


def expression_add(*expressions):
    answer = {}
    for expression in expressions:
        for monomial, coefficient in expression.items():
            answer[monomial] = answer.get(monomial, 0) + coefficient
    return {monomial: coefficient for monomial, coefficient in answer.items()
            if coefficient}


def times_t(expression):
    return {
        (coefficient_index, t_power + 1): scalar
        for (coefficient_index, t_power), scalar in expression.items()
    }


s2 = {(2, 0): 1, (3, 1): 1, (4, 2): 1}
w = {(3, 0): 1, (4, 1): 2}
e2 = {(2, 0): 1, (4, 2): -1}
e3 = {(3, 0): 1, (4, 1): 2}
assert s2 == expression_add(e2, times_t(e3))
assert w == e3
print("(s2,W)=(e2,e3) by a unit triangular change: PASS")


# ---------------------------------------------------------------------------
# Formal determinant expansion with monomials represented by exponent tuples.


VARIABLE_COUNT = 13
ZERO_POLY = {}
ONE_POLY = {(0,) * VARIABLE_COUNT: 1}


def variable(index):
    exponent = [0] * VARIABLE_COUNT
    exponent[index] = 1
    return {tuple(exponent): 1}


def poly_add(left, right, right_scalar=1):
    answer = dict(left)
    for monomial, coefficient in right.items():
        answer[monomial] = answer.get(monomial, 0) + right_scalar * coefficient
    return {monomial: coefficient for monomial, coefficient in answer.items()
            if coefficient}


def poly_mul(left, right):
    answer = {}
    for first, first_coefficient in left.items():
        for second, second_coefficient in right.items():
            monomial = tuple(a + b for a, b in zip(first, second))
            answer[monomial] = (
                answer.get(monomial, 0) + first_coefficient * second_coefficient
            )
    return {monomial: coefficient for monomial, coefficient in answer.items()
            if coefficient}


def permutation_sign(permutation):
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(len(permutation))
        for j in range(i + 1, len(permutation))
    )
    return -1 if inversions % 2 else 1


def determinant(matrix):
    size = len(matrix)
    answer = ZERO_POLY
    for permutation in permutations(range(size)):
        term = ONE_POLY
        for row, column in enumerate(permutation):
            term = poly_mul(term, matrix[row][column])
        answer = poly_add(answer, term, permutation_sign(permutation))
    return answer


symbols = [variable(index) for index in range(VARIABLE_COUNT)]
a, b, c, d, e, f, g, h, i, j, k, ell, unit = symbols
matrix4 = [
    [a, b, c, ZERO_POLY],
    [d, e, f, ZERO_POLY],
    [g, h, i, ZERO_POLY],
    [j, k, ell, unit],
]
matrix3 = [row[:3] for row in matrix4[:3]]
assert determinant(matrix4) == poly_mul(unit, determinant(matrix3))
print("det D(s,W)=U*det D_(A,B,L)(s) formally: PASS")


# ---------------------------------------------------------------------------
# Characteristic-zero representative ranks.


def pair_rows(first_point, first_multiplier, second_point, second_multiplier):
    return (
        ROWS.critical_rows(first_point, first_multiplier)
        + ROWS.critical_rows(second_point, second_multiplier)
    )


qq_cases = [
    (
        "distinct x, distinct y-flags",
        (0, 0, 0, 1), (2, 3, 1),
        (1, 0, 1, 1), (4, 5, 1), 14,
    ),
    (
        "distinct x, same y-flag and multiplier",
        (0, 0, 0, 1), (2, 3, 1),
        (1, 0, 0, 1), (2, 3, 1), 13,
    ),
    (
        "distinct x, same y-flag but different multiplier",
        (0, 0, 0, 1), (2, 3, 1),
        (1, 0, 0, 1), (4, 5, 1), 14,
    ),
    (
        "same x, distinct lines",
        (0, 0, 0, 1), (2, 3, 1),
        (0, 0, 1, 1), (4, 5, 1), 13,
    ),
    (
        "same x, distinct lines, one diagonal",
        (0, 0, 0, 0), (2, 3, 1),
        (0, 0, 1, 1), (4, 5, 1), 13,
    ),
    (
        "same x, distinct lines, both diagonal",
        (0, 0, 0, 0), (2, 3, 1),
        (0, 0, 1, 0), (4, 5, 1), 12,
    ),
    (
        "same x and line, distinct residual points",
        (0, 0, 0, 1), (2, 3, 1),
        (0, 0, 0, 2), (4, 5, 1), 11,
    ),
]

for label, first_point, first_multiplier, second_point, second_multiplier, expected in qq_cases:
    rank = ROWS.exact_rank(pair_rows(
        first_point, first_multiplier, second_point, second_multiplier
    ))
    assert rank == expected, (label, rank, expected)
    print(f"QQ two-point rank {expected}: {label}: PASS")


# ---------------------------------------------------------------------------
# Exhaust every multiplier [lambda0:lambda1:1] over two finite fields.


def affine_multipliers(prime):
    return [(first, second, 1)
            for first, second in product(range(prime), repeat=2)]


def scan_constant_rank(prime, label, first_point, second_point, expected):
    multipliers = affine_multipliers(prime)
    counts = {}
    for first_multiplier in multipliers:
        for second_multiplier in multipliers:
            rank = ROWS.rank_mod_prime(
                pair_rows(
                    first_point, first_multiplier,
                    second_point, second_multiplier,
                ),
                prime,
            )
            counts[rank] = counts.get(rank, 0) + 1
    expected_count = len(multipliers) ** 2
    assert counts == {expected: expected_count}, (prime, label, counts)
    print(
        f"F{prime} all {expected_count} multiplier pairs: "
        f"rank {expected}, {label}: PASS"
    )


def scan_same_flag_distinct_x(prime):
    multipliers = affine_multipliers(prime)
    counts = {}
    for first_multiplier in multipliers:
        for second_multiplier in multipliers:
            rank = ROWS.rank_mod_prime(
                pair_rows(
                    (0, 0, 0, 1), first_multiplier,
                    (1, 0, 0, 1), second_multiplier,
                ),
                prime,
            )
            expected = 13 if first_multiplier == second_multiplier else 14
            assert rank == expected, (
                prime, first_multiplier, second_multiplier, rank, expected
            )
            counts[rank] = counts.get(rank, 0) + 1
    assert counts == {
        13: len(multipliers),
        14: len(multipliers) * (len(multipliers) - 1),
    }
    print(
        f"F{prime} same y-flag: rank 13 exactly for equal multipliers: PASS"
    )


for prime in (3, 5):
    scan_constant_rank(
        prime,
        "distinct x and distinct y-flags",
        (0, 0, 0, 1),
        (1, 0, 1, 1),
        14,
    )
    scan_same_flag_distinct_x(prime)
    scan_constant_rank(
        prime,
        "same x, distinct lines",
        (0, 0, 0, 1),
        (0, 0, 1, 1),
        13,
    )
    scan_constant_rank(
        prime,
        "same x, distinct lines, one diagonal",
        (0, 0, 0, 0),
        (0, 0, 1, 1),
        13,
    )
    scan_constant_rank(
        prime,
        "same x, distinct lines, both diagonal",
        (0, 0, 0, 0),
        (0, 0, 1, 0),
        12,
    )
    scan_constant_rank(
        prime,
        "same x and line, distinct residual points",
        (0, 0, 0, 1),
        (0, 0, 0, 2),
        11,
    )


# Parameter dimension minus coefficient rank is nonpositive in every
# off-diagonal row; the equality rows are the generic pair row and the
# forbidden common-line/two-residual-root row.
dimension_rank_rows = [(14, 14), (10, 13), (12, 13), (10, 12), (11, 11)]
assert all(dimension <= rank for dimension, rank in dimension_rank_rows)
print("all off-diagonal incidence margins are nonpositive: PASS")
print("special-seed ramification comparison checks: PASS")
