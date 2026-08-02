#!/usr/bin/env python3
"""Exact Q(zeta_11) arithmetic helpers for C6 residual point search.

Shared by residual producer and independent residual verifier.  Does not claim
any geometric theorem by itself.
"""

from __future__ import annotations

from fractions import Fraction
from typing import Iterable, Sequence

from c6_core import PAIRS, SECTION_NAMES

ZDim = 10


def z_zero_list() -> list[Fraction]:
    return [Fraction(0)] * ZDim


def z_add(a: Sequence[Fraction], b: Sequence[Fraction]) -> list[Fraction]:
    return [a[i] + b[i] for i in range(ZDim)]


def z_sub(a: Sequence[Fraction], b: Sequence[Fraction]) -> list[Fraction]:
    return [a[i] - b[i] for i in range(ZDim)]


def z_scal(a: Sequence[Fraction], s) -> list[Fraction]:
    scale = Fraction(s)
    return [a[i] * scale for i in range(ZDim)]


def z_is_zero(a: Sequence[Fraction]) -> bool:
    return all(x == 0 for x in a)


def z_eq(a: Sequence[Fraction], b: Sequence[Fraction]) -> bool:
    return z_is_zero(z_sub(a, b))


def z_from_coeff(qcoeff: Sequence[Sequence[int]]) -> list[Fraction]:
    return [Fraction(int(numerator), int(denominator)) for numerator, denominator in qcoeff]


def z_to_json(a: Sequence[Fraction]) -> list[list[int]]:
    return [[int(x.numerator), int(x.denominator)] for x in a]


def z_from_json(payload: Sequence[Sequence[int]]) -> list[Fraction]:
    return [Fraction(int(numerator), int(denominator)) for numerator, denominator in payload]


def z_mul(a: Sequence[Fraction], b: Sequence[Fraction]) -> list[Fraction]:
    """Multiply in Q(zeta_11) with zeta^11=1 and Phi_11(zeta)=0."""

    coeffs = [Fraction(0)] * 19
    for i in range(ZDim):
        if not a[i]:
            continue
        ai = a[i]
        for j in range(ZDim):
            if b[j]:
                coeffs[i + j] += ai * b[j]
    for power in range(18, 10, -1):
        if coeffs[power]:
            coeffs[power - 11] += coeffs[power]
            coeffs[power] = Fraction(0)
    if coeffs[10]:
        carry = coeffs[10]
        coeffs[10] = Fraction(0)
        for index in range(ZDim):
            coeffs[index] -= carry
    return coeffs[:ZDim]


def z_inv(a: Sequence[Fraction]) -> list[Fraction]:
    """Invert a nonzero element of Q(zeta_11) via the regular representation."""

    basis = [
        [Fraction(1 if i == j else 0) for i in range(ZDim)] for j in range(ZDim)
    ]
    columns = [z_mul(a, basis[k]) for k in range(ZDim)]
    matrix = [[columns[k][i] for k in range(ZDim)] for i in range(ZDim)]
    rhs = [Fraction(1)] + [Fraction(0)] * 9
    for col in range(ZDim):
        pivot = next(row for row in range(col, ZDim) if matrix[row][col] != 0)
        matrix[col], matrix[pivot] = matrix[pivot], matrix[col]
        rhs[col], rhs[pivot] = rhs[pivot], rhs[col]
        inverse = 1 / matrix[col][col]
        matrix[col] = [entry * inverse for entry in matrix[col]]
        rhs[col] *= inverse
        for row in range(ZDim):
            if row != col and matrix[row][col] != 0:
                factor = matrix[row][col]
                matrix[row] = [
                    matrix[row][c] - factor * matrix[col][c] for c in range(ZDim)
                ]
                rhs[row] -= factor * rhs[col]
    return rhs


def z_mod(a: Sequence[Fraction], prime: int, zeta: int) -> int:
    total = 0
    for power, coeff in enumerate(a):
        total = (
            total
            + (coeff.numerator % prime)
            * pow(coeff.denominator % prime, -1, prime)
            * pow(zeta, power, prime)
        ) % prime
    return total


def eval_frame_vector(vector, point: Sequence[int]) -> list[int]:
    out = []
    for poly in vector:
        value = 0
        for term in poly:
            mon = int(term["coefficient"])
            for exponent, coordinate in zip(term["exponents"], point):
                mon *= int(coordinate) ** int(exponent)
            value += mon
        out.append(value)
    return out


def forms_at_exact(q_linear, frame_vectors, point: Sequence[int]):
    """Return the five skew 6x6 matrices over Q(zeta_11) at a rational x-point."""

    forms = []
    for name in SECTION_NAMES:
        section = eval_frame_vector(frame_vectors[name], point)
        matrix = [[z_zero_list() for _ in range(6)] for _ in range(6)]
        for row in range(6):
            for column in range(6):
                acc = z_zero_list()
                for index in range(5):
                    acc = z_add(
                        acc,
                        z_scal(z_from_coeff(q_linear[row][column][index]), section[index]),
                    )
                matrix[row][column] = acc
        forms.append(matrix)
    return forms


def M_of_exact(forms, u: Sequence[int]):
    matrix = []
    for form in forms:
        row = []
        for column in range(6):
            acc = z_zero_list()
            for index, coordinate in enumerate(u):
                if coordinate:
                    acc = z_add(acc, z_scal(form[index][column], coordinate))
            row.append(acc)
        matrix.append(row)
    return matrix


def z_det(matrix: Sequence[Sequence[Sequence[Fraction]]]) -> list[Fraction]:
    n = len(matrix)
    work = [[matrix[row][column][:] for column in range(n)] for row in range(n)]
    det = [Fraction(1)] + [Fraction(0)] * 9
    for col in range(n):
        pivot = next(
            (row for row in range(col, n) if not z_is_zero(work[row][col])),
            None,
        )
        if pivot is None:
            return z_zero_list()
        if pivot != col:
            work[col], work[pivot] = work[pivot], work[col]
            det = z_scal(det, -1)
        det = z_mul(det, work[col][col])
        inverse = z_inv(work[col][col])
        for row in range(col + 1, n):
            if z_is_zero(work[row][col]):
                continue
            factor = z_mul(work[row][col], inverse)
            for column in range(col, n):
                work[row][column] = z_sub(
                    work[row][column], z_mul(factor, work[col][column])
                )
    return det


def signed_minors_exact(matrix) -> list[list[Fraction]]:
    minors = []
    for deleted in range(6):
        columns = [column for column in range(6) if column != deleted]
        sub = [[matrix[row][column] for column in columns] for row in range(5)]
        value = z_det(sub)
        if deleted % 2:
            value = z_scal(value, -1)
        minors.append(value)
    return minors


def minors_all_zero(forms, u: Sequence[int]) -> bool:
    return all(z_is_zero(value) for value in signed_minors_exact(M_of_exact(forms, u)))


def nullspace_exact(matrix) -> tuple[list[list[list[Fraction]]], int]:
    rows, cols = 5, 6
    work = [[matrix[row][column][:] for column in range(cols)] for row in range(rows)]
    rank = 0
    col_pivot = [-1] * cols
    for column in range(cols):
        pivot = next(
            (row for row in range(rank, rows) if not z_is_zero(work[row][column])),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = z_inv(work[rank][column])
        work[rank] = [z_mul(entry, inverse) for entry in work[rank]]
        for row in range(rows):
            if row != rank and not z_is_zero(work[row][column]):
                factor = work[row][column]
                work[row] = [
                    z_sub(work[row][c], z_mul(factor, work[rank][c])) for c in range(cols)
                ]
        col_pivot[column] = rank
        rank += 1
        if rank == rows:
            break
    free = [column for column in range(cols) if col_pivot[column] < 0]
    basis = []
    for free_column in free:
        vector = [z_zero_list() for _ in range(cols)]
        vector[free_column] = [Fraction(1)] + [Fraction(0)] * 9
        for column, pivot_row in enumerate(col_pivot):
            if pivot_row >= 0:
                vector[column] = z_scal(work[pivot_row][free_column], -1)
        basis.append(vector)
    return basis, rank


def plucker_field(
    left: Sequence[Sequence[Fraction]], right: Sequence[Sequence[Fraction]]
) -> list[list[Fraction]]:
    return [
        z_sub(z_mul(left[i], right[j]), z_mul(left[j], right[i])) for i, j in PAIRS
    ]


def normalize_plucker(vector: Sequence[Sequence[Fraction]]) -> list[list[Fraction]]:
    scale = next(entry for entry in vector if not z_is_zero(entry))
    inverse = z_inv(scale)
    return [z_mul(entry, inverse) for entry in vector]


def omega_mixed(form, u: Sequence[int], v: Sequence[Sequence[Fraction]]) -> list[Fraction]:
    acc = z_zero_list()
    for row, u_value in enumerate(u):
        if not u_value:
            continue
        for column in range(6):
            term = z_mul(form[row][column], v[column])
            acc = z_add(acc, z_scal(term, u_value))
    return acc


def standard_plucker_quadrics(plucker: Sequence[Sequence[Fraction]]) -> list[list[Fraction]]:
    index = {pair: position for position, pair in enumerate(PAIRS)}
    relations = []
    from itertools import combinations

    for a, b, c, d in combinations(range(6), 4):
        t1 = z_mul(plucker[index[(a, b)]], plucker[index[(c, d)]])
        t2 = z_mul(plucker[index[(a, c)]], plucker[index[(b, d)]])
        t3 = z_mul(plucker[index[(a, d)]], plucker[index[(b, c)]])
        relations.append(z_add(z_sub(t1, t2), t3))
    return relations


def pluecker_linear_form_buckets(linear_form, plucker: Sequence[Sequence[Fraction]]):
    """Return x-monomial -> Q(zeta_11) coefficient for a sealed Plucker hyperplane."""

    from collections import defaultdict

    buckets: dict[tuple[int, ...], list[Fraction]] = defaultdict(z_zero_list)
    for term in linear_form["terms"]:
        mon = tuple(int(exponent) for exponent in term["x_exponents"])
        coeff = z_from_coeff(term["coefficient_Qzeta11"])
        contribution = z_mul(coeff, plucker[int(term["pluecker_index"])])
        buckets[mon] = z_add(buckets[mon], contribution)
    return dict(buckets)


def pluecker_hyperplanes_identically_zero(linear_forms, plucker) -> bool:
    for linear_form in linear_forms:
        buckets = pluecker_linear_form_buckets(linear_form, plucker)
        if any(not z_is_zero(value) for value in buckets.values()):
            return False
    return True
