#!/usr/bin/env python3
"""Exact minimal degree-10 model for both maximal-A5 Klein twists.

This verifier consumes only the authoritative Goal-H packet
``H_SUBGROUP_TWISTS_ROOT_019FBE10``.  It rebuilds the faithful icosahedral
three-space over Q(sqrt(5)) and the rational five-space obtained from the
six Sylow-5 subgroups of A5.  Five Reynolds circuits of degree ten form a
generic frame.  Their determinant is certified by good reduction at 89.

The script also reduces all 35 coefficients of each of the two canonical
invariant cubics S and D to the thirteen degree-30 monomials in the primary
icosahedral invariants f2,f6,f10.  The reduction is exact: a thirteen-point
evaluation map is proved injective, the coefficients are solved in
Q(sqrt(5)), and independent holdout evaluations are checked.  Consequently
the two twists over C(P^2)^A5=C(u,v) are

    sum_e (A_e(u,v) + t_i B_e(u,v)) z^e = 0,
    t_i=(4 +/- sqrt(-11))/9.

No claim about existence or nonexistence of a rational point is made.
"""

from __future__ import annotations

from collections import deque
import contextlib
from fractions import Fraction
import hashlib
import importlib.util
import io
import itertools
import json
from pathlib import Path
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
AUTHORITATIVE = (
    PROBLEM / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
)
AUTH_PRODUCER = AUTHORITATIVE / "produce.py"
AUTH_TWISTS = AUTHORITATIVE / "twists.json"
OUTPUT = HERE / "minimal_model_payload.json"


def load_authoritative_packet():
    assert AUTH_PRODUCER.is_file() and AUTH_TWISTS.is_file()
    spec = importlib.util.spec_from_file_location(
        "h3_authoritative_subgroup_packet", AUTH_PRODUCER
    )
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    # exact_weil_check prints its own certificate markers on import.  They are
    # not part of this verifier's stable transcript.
    with contextlib.redirect_stdout(io.StringIO()):
        spec.loader.exec_module(module)
    assert module.HERE.resolve() == AUTHORITATIVE.resolve()
    return module


auth = load_authoritative_packet()
P = 89
SQRT5_MOD = 19


# Q5 is Q[s]/(s^2-5), represented by a+b*s.
Q5 = tuple[Fraction, Fraction]
ZERO: Q5 = (Fraction(0), Fraction(0))
ONE: Q5 = (Fraction(1), Fraction(0))


def q5(a=0, b=0) -> Q5:
    return Fraction(a), Fraction(b)


def qadd(x: Q5, y: Q5) -> Q5:
    return x[0] + y[0], x[1] + y[1]


def qneg(x: Q5) -> Q5:
    return -x[0], -x[1]


def qsub(x: Q5, y: Q5) -> Q5:
    return qadd(x, qneg(y))


def qmul(x: Q5, y: Q5) -> Q5:
    return x[0] * y[0] + 5 * x[1] * y[1], x[0] * y[1] + x[1] * y[0]


def qinv(x: Q5) -> Q5:
    denominator = x[0] * x[0] - 5 * x[1] * x[1]
    assert denominator
    return x[0] / denominator, -x[1] / denominator


def qdiv(x: Q5, y: Q5) -> Q5:
    return qmul(x, qinv(y))


def qpow(x: Q5, exponent: int) -> Q5:
    out = ONE
    while exponent:
        if exponent & 1:
            out = qmul(out, x)
        x = qmul(x, x)
        exponent //= 2
    return out


def qsum(values) -> Q5:
    out = ZERO
    for value in values:
        out = qadd(out, value)
    return out


def fraction_mod(value: Fraction) -> int:
    return value.numerator * pow(value.denominator, -1, P) % P


def qmod(value: Q5) -> int:
    return (fraction_mod(value[0]) + SQRT5_MOD * fraction_mod(value[1])) % P


def qjson(value: Q5):
    return [str(value[0]), str(value[1])]


def mmul(left, right):
    return [
        [
            qsum(qmul(left[i][k], right[k][j]) for k in range(len(right)))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def midentity(size):
    return [[q5(int(i == j)) for j in range(size)] for i in range(size)]


def as_q5(value):
    return value if isinstance(value, tuple) else q5(value)


def matvec(matrix, vector):
    return [
        qsum(qmul(entry, as_q5(value)) for entry, value in zip(row, vector))
        for row in matrix
    ]


def determinant(matrix):
    work = [row[:] for row in matrix]
    out = ONE
    for column in range(len(work)):
        pivot = next(
            (row for row in range(column, len(work)) if work[row][column] != ZERO),
            None,
        )
        if pivot is None:
            return ZERO
        if pivot != column:
            work[pivot], work[column] = work[column], work[pivot]
            out = qneg(out)
        value = work[column][column]
        out = qmul(out, value)
        inverse = qinv(value)
        for row in range(column + 1, len(work)):
            scalar = qmul(work[row][column], inverse)
            work[row] = [
                qsub(x, qmul(scalar, y))
                for x, y in zip(work[row], work[column])
            ]
    return out


def pinverse(permutation):
    return tuple(permutation.index(i) for i in range(len(permutation)))


def pclosure(generators):
    found = {auth.PID}
    queue = deque([auth.PID])
    while queue:
        current = queue.popleft()
        for generator in generators:
            candidate = auth.pc(current, generator)
            if candidate not in found:
                found.add(candidate)
                queue.append(candidate)
    return frozenset(found)


def exact_source_representation():
    alpha = q5(Fraction(-1, 2), Fraction(-1, 2))
    m5 = [
        [alpha, qneg(alpha), q5(-1)],
        [alpha, ONE, ZERO],
        [alpha, qneg(alpha), ZERO],
    ]
    m3 = [
        [ZERO, q5(-1), qneg(alpha)],
        [ZERO, ZERO, ONE],
        [q5(-1), qneg(alpha), ZERO],
    ]
    p5 = (1, 2, 3, 4, 0)
    p3 = (0, 1, 3, 4, 2)
    assert p5 in auth.PERMS and p3 in auth.PERMS
    out = {auth.PID: midentity(3)}
    queue = deque([auth.PID])
    while queue:
        current = queue.popleft()
        for generator, matrix in ((p5, m5), (p3, m3)):
            candidate = auth.pc(current, generator)
            candidate_matrix = mmul(out[current], matrix)
            if candidate in out:
                assert out[candidate] == candidate_matrix
            else:
                out[candidate] = candidate_matrix
                queue.append(candidate)
    assert set(out) == set(auth.PERMS)
    # This anchors the exact representation to the authoritative packet's
    # literal good reduction, rather than to a sibling exploratory script.
    assert all(
        [[qmod(entry) for entry in row] for row in out[g]] == auth.SOURCE_A5[g]
        for g in auth.PERMS
    )
    return out


SOURCE = exact_source_representation()


def sylow_five_subgroups():
    subgroups = {
        pclosure((g,)) for g in auth.PERMS if auth.po(g) == 5
    }
    assert len(subgroups) == 6
    return tuple(sorted(subgroups, key=lambda group: tuple(sorted(group))))


SYLOW5 = sylow_five_subgroups()
SYLOW5_INDEX = {group: i for i, group in enumerate(SYLOW5)}


def action_six(g):
    inverse = pinverse(g)
    return tuple(
        SYLOW5_INDEX[frozenset(
            auth.pc(auth.pc(g, h), inverse) for h in subgroup
        )]
        for subgroup in SYLOW5
    )


def target_matrix(g):
    permutation = action_six(g)
    inverse = [0] * 6
    for source, image in enumerate(permutation):
        inverse[image] = source
    matrix = []
    for row in range(5):
        source = inverse[row]
        if source < 5:
            matrix.append([int(column == source) for column in range(5)])
        else:
            matrix.append([-1] * 5)
    return matrix


TARGET_INT = {g: target_matrix(g) for g in auth.PERMS}
TARGET = {
    g: [[q5(entry) for entry in row] for row in matrix]
    for g, matrix in TARGET_INT.items()
}
assert all(
    mmul(TARGET[g], TARGET[h]) == TARGET[auth.pc(g, h)]
    for g in (auth.PA, auth.PB)
    for h in auth.PERMS
)
character_norm = sum(
    sum(TARGET_INT[g][i][i] for i in range(5)) ** 2 for g in auth.PERMS
) // 60
assert character_norm == 1


SEEDS = (
    (0, (0, 0, 10)),
    (1, (0, 0, 10)),
    (0, (0, 1, 9)),
    (1, (0, 1, 9)),
    (1, (0, 2, 8)),
)


def monomial_value(values, exponent):
    out = ONE
    for value, power in zip(values, exponent):
        out = qmul(out, qpow(value, power))
    return out


def reynolds_column(seed, point):
    """Evaluate sum_g R(g^-1)e_r m_e(sigma(g)y)."""
    output_coordinate, exponent = seed
    out = [ZERO] * 5
    for g in auth.PERMS:
        scalar = monomial_value(matvec(SOURCE[g], point), exponent)
        inverse_target = TARGET[pinverse(g)]
        for row in range(5):
            out[row] = qadd(
                out[row], qmul(inverse_target[row][output_coordinate], scalar)
            )
    return out


def frame_at(point):
    columns = [reynolds_column(seed, point) for seed in SEEDS]
    return [[columns[column][row] for column in range(5)] for row in range(5)]


FRAME_POINT = (1, 2, 3)
FRAME_EXACT = frame_at(FRAME_POINT)
FRAME_DETERMINANT = determinant(FRAME_EXACT)
FRAME_MOD = [[qmod(entry) for entry in row] for row in FRAME_EXACT]
FRAME_COLUMNS_MOD = [
    [FRAME_MOD[row][column] for row in range(5)] for column in range(5)
]
assert FRAME_COLUMNS_MOD == [
    [62, 59, 63, 81, 52],
    [12, 5, 61, 16, 47],
    [41, 48, 87, 17, 55],
    [63, 12, 14, 49, 75],
    [63, 44, 39, 79, 0],
]
assert qmod(FRAME_DETERMINANT) == auth.det(FRAME_MOD) == 39
# Direct exact checks of the covariance convention used by the Reynolds
# circuit.  The general identity follows by the reindexing g -> g*h^-1.
for covariance_point in (FRAME_POINT, (1, 2, 4)):
    covariance_frame = frame_at(covariance_point)
    for generator in (auth.PA, auth.PB):
        assert frame_at(matvec(SOURCE[generator], covariance_point)) == mmul(
            TARGET[generator], covariance_frame
        )


# Molien series.  The target character is [5,1,-1,0,0] on orders
# 1,2,3,5,5, so the two fifth-order classes make no contribution.
t = sp.symbols("t")
covariant_molien = sp.Rational(1, 60) * (
    5 / (1 - t) ** 3
    + 15 / ((1 - t) * (1 + t) ** 2)
    - 20 / (1 - t ** 3)
)
secondary_numerator = sp.expand(sp.cancel(
    covariant_molien * (1 - t ** 2) * (1 - t ** 6) * (1 - t ** 10)
))
SECONDARY_DEGREES = (2, 4, 5, 6, 7, 8, 9, 10, 11, 13)
assert secondary_numerator == sum(t ** degree for degree in SECONDARY_DEGREES)


def primary_semigroup_contains(degree):
    return any(
        2 * a + 6 * b + 10 * c == degree
        for a in range(degree // 2 + 1)
        for b in range(degree // 6 + 1)
        for c in range(degree // 10 + 1)
    )


evaluation_rank_bounds = {
    degree: sum(
        secondary <= degree and primary_semigroup_contains(degree - secondary)
        for secondary in SECONDARY_DEGREES
    )
    for degree in range(11)
}
assert max(evaluation_rank_bounds[degree] for degree in range(10)) == 4
assert evaluation_rank_bounds[10] == 5


def invariant_value(degree, point):
    return qsum(
        qpow(matvec(SOURCE[g], point)[2], degree) for g in auth.PERMS
    )


def invariant_derivative_value(degree, point, coordinate):
    return qsum(
        qmul(
            q5(degree),
            qmul(
                qpow(matvec(SOURCE[g], point)[2], degree - 1),
                SOURCE[g][2][coordinate],
            ),
        )
        for g in auth.PERMS
    )


JACOBIAN = [
    [invariant_derivative_value(degree, FRAME_POINT, coordinate) for coordinate in range(3)]
    for degree in (2, 6, 10)
]
JACOBIAN_DETERMINANT = determinant(JACOBIAN)
assert JACOBIAN_DETERMINANT != ZERO and qmod(JACOBIAN_DETERMINANT) == 88


sqrt5 = sp.sqrt(5)
phi = (1 + sqrt5) / 2
phi_conjugate = (1 - sqrt5) / 2
invariant_molien = sp.Rational(1, 60) * (
    1 / (1 - t) ** 3
    + 15 / ((1 - t) * (1 + t) ** 2)
    + 20 / (1 - t ** 3)
    + 12 / ((1 - t) * (1 - (phi - 1) * t + t ** 2))
    + 12 / ((1 - t) * (1 - (phi_conjugate - 1) * t + t ** 2))
)
invariant_molien_target = (
    (1 + t ** 15) / ((1 - t ** 2) * (1 - t ** 6) * (1 - t ** 10))
)
assert sp.cancel(invariant_molien - invariant_molien_target) == 0


# Degree 30 has precisely these thirteen primary monomials.  Dividing by
# f2^15 turns them into the listed u^b v^c, where u=f6/f2^3 and
# v=f10/f2^5.
PRIMARY_EXPONENTS = tuple(
    (15 - 3 * b - 5 * c, b, c)
    for c in range(4)
    for b in range(6)
    if 15 - 3 * b - 5 * c >= 0
)
assert len(PRIMARY_EXPONENTS) == 13
UV_EXPONENTS = tuple((b, c) for _a, b, c in PRIMARY_EXPONENTS)


EVALUATION_POINTS = tuple(
    [(1, 1, value) for value in range(1, 13)] + [(1, 2, 3)]
)
HOLDOUT_POINTS = ((1, 2, 4), (1, 2, 5), (1, 3, 2), (2, 3, 1))


def invariant_basis_row(point):
    f2, f6, f10 = (invariant_value(degree, point) for degree in (2, 6, 10))
    return [
        qmul(qmul(qpow(f2, a), qpow(f6, b)), qpow(f10, c))
        for a, b, c in PRIMARY_EXPONENTS
    ]


def rank_mod(matrix):
    work = [[qmod(value) for value in row] for row in matrix]
    rank = 0
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(rank, len(work)) if work[row][column] % P),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = pow(work[rank][column], -1, P)
        work[rank] = [value * inverse % P for value in work[rank]]
        for row in range(len(work)):
            if row != rank and work[row][column]:
                scalar = work[row][column]
                work[row] = [
                    (x - scalar * y) % P for x, y in zip(work[row], work[rank])
                ]
        rank += 1
    return rank


EVALUATION_MATRIX = [invariant_basis_row(point) for point in EVALUATION_POINTS]
assert rank_mod(EVALUATION_MATRIX) == 13


O_PLUS = (
    (0, 1, 2), (0, 1, 3), (0, 2, 4), (0, 3, 5), (0, 4, 5),
    (1, 2, 5), (1, 3, 4), (1, 4, 5), (2, 3, 4), (2, 3, 5),
)
O_MINUS = (
    (0, 1, 4), (0, 1, 5), (0, 2, 3), (0, 2, 5), (0, 3, 4),
    (1, 2, 3), (1, 2, 4), (1, 3, 5), (2, 4, 5), (3, 4, 5),
)
Z_EXPONENTS = tuple(
    exponent for exponent in itertools.product(range(4), repeat=5)
    if sum(exponent) == 3
)


def poly_add(left, right, scale=ONE):
    out = dict(left)
    for exponent, coefficient in right.items():
        out[exponent] = qadd(
            out.get(exponent, ZERO), qmul(scale, coefficient)
        )
        if out[exponent] == ZERO:
            del out[exponent]
    return out


def poly_mul(left, right):
    out = {}
    for left_exp, left_coeff in left.items():
        for right_exp, right_coeff in right.items():
            exponent = tuple(a + b for a, b in zip(left_exp, right_exp))
            out[exponent] = qadd(
                out.get(exponent, ZERO), qmul(left_coeff, right_coeff)
            )
    return {e: c for e, c in out.items() if c != ZERO}


def poly_pow(polynomial, exponent):
    out = {(0, 0, 0, 0, 0): ONE}
    while exponent:
        if exponent & 1:
            out = poly_mul(out, polynomial)
        polynomial = poly_mul(polynomial, polynomial)
        exponent //= 2
    return out


def six_linear_forms(frame):
    forms = []
    for row in frame:
        forms.append({
            tuple(int(i == column) for i in range(5)): coefficient
            for column, coefficient in enumerate(row)
            if coefficient != ZERO
        })
    last = {}
    for form in forms:
        last = poly_add(last, form, q5(-1))
    return forms + [last]


def canonical_cubic_coefficients(frame):
    forms = six_linear_forms(frame)
    segre = {}
    for form in forms:
        segre = poly_add(segre, poly_pow(form, 3))
    plus = {}
    minus = {}
    for triple in O_PLUS:
        plus = poly_add(plus, poly_mul(poly_mul(forms[triple[0]], forms[triple[1]]), forms[triple[2]]))
    for triple in O_MINUS:
        minus = poly_add(minus, poly_mul(poly_mul(forms[triple[0]], forms[triple[1]]), forms[triple[2]]))
    difference = poly_add(plus, minus, q5(-1))
    return (
        [segre.get(exponent, ZERO) for exponent in Z_EXPONENTS],
        [difference.get(exponent, ZERO) for exponent in Z_EXPONENTS],
    )


# Verify that S and D are invariant under the rational target representation.
IDENTITY_CUBICS = canonical_cubic_coefficients(midentity(5))
for generator in (auth.PA, auth.PB):
    assert canonical_cubic_coefficients(TARGET[generator]) == IDENTITY_CUBICS


def solve_many(matrix, right_hand_sides):
    """Solve M*X=R over Q(sqrt5), with many RHS columns at once."""
    size = len(matrix)
    width = len(right_hand_sides[0])
    work = [matrix[row][:] + right_hand_sides[row][:] for row in range(size)]
    for column in range(size):
        pivot = next(
            (row for row in range(column, size) if work[row][column] != ZERO),
            None,
        )
        assert pivot is not None
        work[column], work[pivot] = work[pivot], work[column]
        inverse = qinv(work[column][column])
        work[column] = [qmul(inverse, value) for value in work[column]]
        for row in range(size):
            if row == column:
                continue
            scalar = work[row][column]
            if scalar != ZERO:
                work[row] = [
                    qsub(x, qmul(scalar, y))
                    for x, y in zip(work[row], work[column])
                ]
    assert all(
        work[row][column] == q5(int(row == column))
        for row in range(size) for column in range(size)
    )
    # Return one coefficient vector for each RHS column.
    return [
        [work[row][size + rhs] for row in range(size)]
        for rhs in range(width)
    ]


evaluation_rhs = []
for point in EVALUATION_POINTS:
    segre_values, difference_values = canonical_cubic_coefficients(frame_at(point))
    evaluation_rhs.append(segre_values + difference_values)

solutions = solve_many(EVALUATION_MATRIX, evaluation_rhs)
SEGRE_REDUCTIONS = solutions[:35]
DIFFERENCE_REDUCTIONS = solutions[35:]


def evaluate_reduction(coefficients, point):
    row = invariant_basis_row(point)
    return qsum(qmul(coefficient, value) for coefficient, value in zip(coefficients, row))


for point in HOLDOUT_POINTS:
    segre_values, difference_values = canonical_cubic_coefficients(frame_at(point))
    assert all(
        evaluate_reduction(coefficients, point) == value
        for coefficients, value in zip(SEGRE_REDUCTIONS, segre_values)
    )
    assert all(
        evaluate_reduction(coefficients, point) == value
        for coefficients, value in zip(DIFFERENCE_REDUCTIONS, difference_values)
    )


def sparse_uv(coefficients):
    return [
        {
            "u_power": b,
            "v_power": c,
            "coefficient_q_sqrt5": qjson(coefficient),
        }
        for (b, c), coefficient in zip(UV_EXPONENTS, coefficients)
        if coefficient != ZERO
    ]


authoritative_twists = json.loads(AUTH_TWISTS.read_text())
assert [record["label"] for record in authoritative_twists["records"][:2]] == [
    "A5_class_1", "A5_class_2"
]
expected_generators = [
    [[0, 1, 10, 0], [0, 2, 5, 1]],
    [[0, 1, 10, 0], [0, 2, 5, 10]],
]
assert [record["generators"] for record in authoritative_twists["records"][:2]] == expected_generators


coefficient_records = []
for exponent, segre, difference in zip(
    Z_EXPONENTS, SEGRE_REDUCTIONS, DIFFERENCE_REDUCTIONS
):
    coefficient_records.append({
        "z_exponent": list(exponent),
        "A_for_S": sparse_uv(segre),
        "B_for_D": sparse_uv(difference),
    })


payload = {
    "format": "klein-h3-a5-minimal-degree10-v1",
    "scope": (
        "Exact common minimal homogeneous frame and invariant-field coefficient "
        "models for both maximal A5 classes; no point or pointlessness verdict."
    ),
    "authoritative_dependency": {
        "packet": "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10",
        "producer_sha256": hashlib.sha256(AUTH_PRODUCER.read_bytes()).hexdigest(),
        "twists_sha256": hashlib.sha256(AUTH_TWISTS.read_bytes()).hexdigest(),
    },
    "representations": {
        "source": "faithful icosahedral 3 over Q(sqrt(5)) from authoritative packet",
        "target": "augmentation of permutation action on six Sylow-5 subgroups",
        "target_character_norm": character_norm,
        "target_generator_matrices": [TARGET_INT[auth.PA], TARGET_INT[auth.PB]],
    },
    "covariant_molien": {
        "series": "(t^2+t^4+t^5+t^6+t^7+t^8+t^9+t^10+t^11+t^13)/((1-t^2)(1-t^6)(1-t^10))",
        "secondary_degrees": list(SECONDARY_DEGREES),
        "evaluation_rank_upper_bounds_through_10": evaluation_rank_bounds,
        "minimal_frame_degree": 10,
    },
    "degree10_frame": {
        "reynolds_formula": "Phi_(r,e)(y)=sum_g R(g^-1)e_r product_k((sigma(g)y)_k)^e_k",
        "seeds": [[row, list(exponent)] for row, exponent in SEEDS],
        "degree": 10,
        "witness_point": list(FRAME_POINT),
        "witness_columns_mod_89": FRAME_COLUMNS_MOD,
        "witness_determinant_q_sqrt5": qjson(FRAME_DETERMINANT),
        "witness_determinant_mod_89": 39,
    },
    "invariant_field": {
        "f_d_definition": "f_d(y)=sum_g ((sigma(g)y)_2)^d for d=2,6,10",
        "f15_definition": "det(d(f2,f6,f10)/d(y0,y1,y2))",
        "jacobian_witness_point": list(FRAME_POINT),
        "jacobian_witness_q_sqrt5": qjson(JACOBIAN_DETERMINANT),
        "jacobian_witness_mod_89": 88,
        "ring": "C[f2,f6,f10,f15]/(f15^2-R30(f2,f6,f10))",
        "field": "C(u,v)",
        "u": "f6/f2^3",
        "v": "f10/f2^5",
    },
    "coefficient_reduction": {
        "evaluation_points": [list(point) for point in EVALUATION_POINTS],
        "evaluation_rank_mod_89": 13,
        "holdout_points": [list(point) for point in HOLDOUT_POINTS],
        "basis_uv_exponents": [list(exponent) for exponent in UV_EXPONENTS],
        "normalization": "all degree-30 coefficients divided by f2^15",
        "canonical_cubics": {
            "S": "sum_i X_i^3 with sum_i X_i=0",
            "D": "sum_(I in O_plus) X_I - sum_(I in O_minus) X_I",
        },
        "coefficients": coefficient_records,
    },
    "classes": [
        {
            "label": "A5_class_1",
            "authoritative_generators": expected_generators[0],
            "parameter": "(4+sqrt(-11))/9",
            "equation": "sum_e (A_e(u,v)+((4+sqrt(-11))/9)B_e(u,v)) z^e=0",
        },
        {
            "label": "A5_class_2",
            "authoritative_generators": expected_generators[1],
            "parameter": "(4-sqrt(-11))/9",
            "equation": "sum_e (A_e(u,v)+((4-sqrt(-11))/9)B_e(u,v)) z^e=0",
        },
    ],
    "equivalence_to_installed_frames": (
        "If J_i identifies the installed restricted ambient representation with R, "
        "B_i=J_i^-1 A_i is the authoritative Hilbert-90 frame and C is the degree-10 "
        "Reynolds frame above, then T_i=C^-1 B_i is A5-invariant.  Thus z->T_i z "
        "is the exact C(u,v)-coordinate change from the installed twist to this model."
    ),
}

OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
print("PASS authoritative ROOT_019FBE10 dependency")
print("PASS exact Q(sqrt5) Reynolds frame determinant mod89=39")
print("PASS covariant Molien minimal homogeneous frame degree=10")
print("PASS all 35 S/D coefficients reduced exactly to 13 u,v monomials")
print("H3_A5_MINIMAL_DEGREE10_OK")
