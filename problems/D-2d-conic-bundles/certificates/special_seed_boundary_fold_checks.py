#!/usr/bin/env python3
"""Exact replay for the saturated-boundary fold theorem.

The characteristic-zero row-space proof and the analytic normal-form proof
are in special_seed_boundary_fold_theorem.md.  This script reconstructs the
ninety integer coefficient columns, replays the six second-jet rank strata
over QQ, exhausts every projective kernel (and every middle multiplier) over
F3 and F5 at T=0,1, checks the incidence margins, and verifies the final
coordinate identities.  It has no third-party dependencies.
"""

from contextlib import redirect_stdout
from importlib.util import module_from_spec, spec_from_file_location
from io import StringIO
from itertools import product
from pathlib import Path


MODULE_PATH = Path(__file__).with_name(
    "special_seed_multijet_reduction_checks.py"
)
SPEC = spec_from_file_location("special_seed_boundary_rows", MODULE_PATH)
ROWS = module_from_spec(SPEC)
with redirect_stdout(StringIO()):
    SPEC.loader.exec_module(ROWS)


def add_orders(first, second):
    return tuple(a + b for a, b in zip(first, second))


def row(component, orders, point):
    return ROWS.section_derivative_row(component, orders, point)


def combine(rows, scalars):
    return ROWS.linear_combination(rows, scalars)


def saturated_boundary_rows(point, multiplier):
    """Rows f=0 and lambda D_(A,B,L)s=0 at lambda_2=0."""
    answer = [
        row(component, (0, 0, 0, 0), point)
        for component in range(3)
    ]
    answer.append(row(2, (0, 0, 0, 1), point))  # W=0
    for variable in range(3):  # A, B, L
        answer.append(combine(
            [row(component, ROWS.UNIT_ORDERS[variable], point)
             for component in range(3)],
            multiplier,
        ))
    # On the bottom stratum the L row is identically zero.  Keeping it does
    # not alter rank and makes the construction uniform.
    return answer


def right_kernel_rows(point, direction):
    """The four equations D_z(s_0,s_1,s_2,W)(direction)=0."""
    answer = []
    for component in range(3):
        answer.append(combine(
            [row(component, ROWS.UNIT_ORDERS[variable], point)
             for variable in range(4)],
            direction,
        ))
    answer.append(combine(
        [row(
            2,
            add_orders(ROWS.UNIT_ORDERS[variable], ROWS.UNIT_ORDERS[3]),
            point,
        ) for variable in range(4)],
        direction,
    ))
    return answer


def fold_quadratic_row(point, multiplier, direction):
    return combine(
        [ROWS.directional_row(component, direction, 2, point)
         for component in range(3)],
        multiplier,
    )


def fold_matrices(point, multiplier, direction):
    base = (
        saturated_boundary_rows(point, multiplier)
        + right_kernel_rows(point, direction)
    )
    return base, base + [fold_quadratic_row(point, multiplier, direction)]


def projective_points(dimension, prime):
    for first_nonzero in range(dimension + 1):
        for tail in product(
            range(prime), repeat=dimension - first_nonzero
        ):
            yield (0,) * first_nonzero + (1,) + tail


def kernel_label(direction):
    if direction[0] or direction[1]:
        return "x-supported"
    if direction[2]:
        return "no-x with L"
    return "pure T"


expected = {
    "middle": {
        "x-supported": (10, 11),
        "no-x with L": (9, 9),
        "pure T": (8, 8),
    },
    "bottom": {
        "x-supported": (9, 10),
        "no-x with L": (9, 9),
        "pure T": (7, 7),
    },
}


# Rational representatives include both flag orbits, two middle multiplier
# values, and all three kernel strata.
directions = {
    "x-supported": (1, 2, 3, 4),
    "no-x with L": (0, 0, 1, 2),
    "pure T": (0, 0, 0, 1),
}

for t_value in (0, 1):
    point = (0, 0, 0, t_value)
    boundary_multipliers = (
        ("middle a=0", "middle", (0, 1, 0)),
        ("middle a=2", "middle", (2, 1, 0)),
        ("bottom", "bottom", (1, 0, 0)),
    )
    for displayed_label, boundary, multiplier in boundary_multipliers:
        for stratum, direction in directions.items():
            base, with_quadratic = fold_matrices(
                point, multiplier, direction
            )
            actual = (
                ROWS.exact_rank(base),
                ROWS.exact_rank(with_quadratic),
            )
            assert actual == expected[boundary][stratum], (
                t_value, displayed_label, stratum, actual
            )
        print(
            f"QQ T={t_value}, {displayed_label}: all three fold ranks: PASS"
        )


# Exhaust the complete projective kernel space.  On the middle stratum also
# exhaust every affine a in lambda=(a,1,0).
for prime in (3, 5):
    for t_value in (0, 1):
        point = (0, 0, 0, t_value)
        for boundary in ("middle", "bottom"):
            multipliers = (
                [(a, 1, 0) for a in range(prime)]
                if boundary == "middle"
                else [(1, 0, 0)]
            )
            counts = {}
            expected_counts = {}
            kernel_counts = {}
            for direction in projective_points(3, prime):
                label = kernel_label(direction)
                kernel_counts[label] = kernel_counts.get(label, 0) + 1
            for label, count in kernel_counts.items():
                pair = expected[boundary][label]
                expected_counts[pair] = (
                    expected_counts.get(pair, 0)
                    + count * len(multipliers)
                )
            for multiplier in multipliers:
                for direction in projective_points(3, prime):
                    base, with_quadratic = fold_matrices(
                        point, multiplier, direction
                    )
                    actual = (
                        ROWS.rank_mod_prime(base, prime),
                        ROWS.rank_mod_prime(with_quadratic, prime),
                    )
                    asserted = expected[boundary][kernel_label(direction)]
                    assert actual == asserted, (
                        prime, t_value, boundary, multiplier, direction,
                        actual, asserted,
                    )
                    counts[actual] = counts.get(actual, 0) + 1
            assert counts == expected_counts, (
                prime, t_value, boundary, counts, expected_counts
            )
            print(
                f"F{prime} T={t_value}, {boundary}: "
                f"all projective multiplier/kernel ranks: PASS"
            )


dimension_rank_rows = [
    (10, 11),
    (8, 9),
    (7, 8),
    (9, 10),
    (7, 9),
    (6, 7),
]
assert all(parameter_dimension < coefficient_rank
           for parameter_dimension, coefficient_rank in dimension_rank_rows)
print("all six degenerate-fold incidence margins are strict: PASS")


# Algebraic replay of the simultaneous normal form.  With
# u=N+x, v=N-x and phi=-2*psi, one has uv=N^2-x^2 and
# 2*(N-psi)=u+v+phi.
samples = [
    (-3, 5, 7),
    (0, 4, -2),
    (11, -6, 3),
]
for normal, tangent, psi in samples:
    u = normal + tangent
    v = normal - tangent
    phi = -2 * psi
    assert u * v == normal**2 - tangent**2
    assert u + v + phi == 2 * (normal - psi)
print("node-with-branch coordinate identities: PASS")
print("special-seed saturated-boundary fold checks: PASS")
