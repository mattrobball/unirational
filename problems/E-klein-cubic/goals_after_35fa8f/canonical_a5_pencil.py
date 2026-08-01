#!/usr/bin/env python3
"""Construct a rational 5-dimensional A5 model and pull back both cubics.

This is an exact characteristic-zero preflight for Goal H3.  It realizes the
unique 5-dimensional irreducible representation as the augmentation module
of A5 acting on its six Sylow-5 subgroups, constructs the two-dimensional
space of invariant cubics over Q, and expresses the two restricted Klein
cubics in that pencil over Q(zeta_11).
"""

from __future__ import annotations

from collections import deque
import importlib.util
import itertools
from pathlib import Path
import sys

import sympy as sp
from sympy.polys.domains import QQ


HERE = Path(__file__).resolve().parent
PACKET = HERE.parent / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
sys.path.insert(0, str(PACKET))
spec = importlib.util.spec_from_file_location("h3_base", PACKET / "produce.py")
assert spec and spec.loader
base = importlib.util.module_from_spec(spec)
spec.loader.exec_module(base)


def p_inverse(p):
    out = [0] * len(p)
    for i, image in enumerate(p):
        out[image] = i
    return tuple(out)


def p_power(p, n):
    out = tuple(range(len(p)))
    for _ in range(n):
        out = base.pc(out, p)
    return out


def p_conjugate(g, h):
    return base.pc(base.pc(g, h), p_inverse(g))


def sylow_five_subgroups():
    groups = set()
    for g in base.PERMS:
        if base.po(g) == 5:
            groups.add(frozenset(p_power(g, n) for n in range(5)))
    result = tuple(sorted(groups, key=lambda group: tuple(sorted(group))))
    assert len(result) == 6
    return result


SYLOW5 = sylow_five_subgroups()


def six_permutation(g):
    return tuple(
        SYLOW5.index(frozenset(p_conjugate(g, h) for h in subgroup))
        for subgroup in SYLOW5
    )


def augmentation_matrix(g):
    """Matrix on the basis e_0-e_5,...,e_4-e_5."""
    perm = six_permutation(g)
    out = [[0] * 5 for _ in range(5)]
    for column in range(5):
        positive, negative = perm[column], perm[5]
        if positive < 5:
            out[positive][column] += 1
        if negative < 5:
            out[negative][column] -= 1
    return out


U = {g: augmentation_matrix(g) for g in base.PERMS}
assert all(
    sp.Matrix(U[base.pc(g, h)]) == sp.Matrix(U[g]) * sp.Matrix(U[h])
    for g in base.PERMS for h in base.PERMS
)


def monomials(variables, degree):
    if variables == 1:
        return ((degree,),)
    return tuple(
        (first,) + tail
        for first in range(degree + 1)
        for tail in monomials(variables - 1, degree - first)
    )


def poly_mul(left, right):
    out = {}
    for ea, ca in left.items():
        for eb, cb in right.items():
            exponent = tuple(a + b for a, b in zip(ea, eb))
            out[exponent] = out.get(exponent, 0) + ca * cb
    return {e: c for e, c in out.items() if c != 0}


def poly_pow(poly, n, variables):
    out = {(0,) * variables: 1}
    for _ in range(n):
        out = poly_mul(out, poly)
    return out


def symmetric_action(matrix, degree):
    mons = monomials(len(matrix), degree)
    index = {exponent: i for i, exponent in enumerate(mons)}
    forms = []
    for row in matrix:
        forms.append({
            tuple(int(i == j) for i in range(len(matrix))): value
            for j, value in enumerate(row) if value
        })
    out = [[0] * len(mons) for _ in mons]
    for column, exponent in enumerate(mons):
        poly = {(0,) * len(matrix): 1}
        for form, power in zip(forms, exponent):
            poly = poly_mul(poly, poly_pow(form, power, len(matrix)))
        for output, coefficient in poly.items():
            out[index[output]][column] = coefficient
    return mons, out


def invariant_cubics():
    rows = []
    for generator in base.PA, base.PB:
        mons, action = symmetric_action(U[generator], 3)
        rows.extend(
            [action[i][j] - int(i == j) for j in range(len(mons))]
            for i in range(len(mons))
        )
    basis = sp.Matrix(rows).nullspace()
    assert len(basis) == 2
    return mons, [
        {exponent: int(vector[i]) for i, exponent in enumerate(mons) if vector[i]}
        for vector in basis
    ]


MONS3, CUBIC_BASIS = invariant_cubics()


x = sp.symbols("x")
K = QQ.alg_field_from_poly(sp.Poly(sp.cyclotomic_poly(11, x), x, domain=QQ), "zeta11")
ZETA = K.unit


def import_c(value):
    return sum(
        K.convert(coefficient.numerator) / K.convert(coefficient.denominator) * ZETA**i
        for i, coefficient in enumerate(value.a)
    )


def field_nullspace(rows):
    work = [[K.convert(value) for value in row] for row in rows]
    row_count, column_count = len(work), len(work[0])
    pivots = []
    pivot_row = 0
    for column in range(column_count):
        pivot = next((i for i in range(pivot_row, row_count) if work[i][column]), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = K.one / work[pivot_row][column]
        work[pivot_row] = [inverse * value for value in work[pivot_row]]
        for row in range(row_count):
            if row == pivot_row or not work[row][column]:
                continue
            scale = work[row][column]
            work[row] = [a - scale * b for a, b in zip(work[row], work[pivot_row])]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == row_count:
            break
    free = [column for column in range(column_count) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [K.zero] * column_count
        vector[free_column] = K.one
        for row, pivot in reversed(list(enumerate(pivots))):
            vector[pivot] = -sum(
                (work[row][column] * vector[column] for column in free), K.zero
            )
        basis.append(vector)
    return basis


def intertwiner(a, b):
    mapping = base.iso(a, b, base.closure((a, b)))
    rows = []
    for h in (a, b):
        rho = [[import_c(value) for value in row] for row in base.ew.rho[h]]
        abstract = U[mapping[h]]
        for i in range(5):
            for j in range(5):
                equation = [K.zero] * 25
                for k in range(5):
                    equation[5 * k + j] += rho[i][k]
                    equation[5 * i + k] -= K.convert(abstract[k][j])
                rows.append(equation)
    kernel = field_nullspace(rows)
    assert len(kernel) == 1
    vector = kernel[0]
    matrix = [[vector[5 * i + j] for j in range(5)] for i in range(5)]
    determinant = sp.Matrix([
        [K.to_sympy(value) for value in row] for row in matrix
    ]).det()
    assert determinant != 0
    return matrix


def klein_pullback(matrix):
    linear = []
    for row in matrix:
        linear.append({
            tuple(int(i == j) for i in range(5)): value
            for j, value in enumerate(row) if value
        })
    out = {}
    for i in range(5):
        term = poly_mul(poly_mul(linear[i], linear[i]), linear[(i + 1) % 5])
        for exponent, coefficient in term.items():
            out[exponent] = out.get(exponent, K.zero) + coefficient
    return {e: c for e, c in out.items() if c}


def pencil_coordinates(poly):
    rows = []
    values = []
    for exponent in MONS3:
        rows.append([basis.get(exponent, 0) for basis in CUBIC_BASIS])
        values.append(poly.get(exponent, K.zero))
    pair = next(
        (i, j) for i in range(len(rows)) for j in range(i + 1, len(rows))
        if rows[i][0] * rows[j][1] - rows[i][1] * rows[j][0]
    )
    i, j = pair
    determinant = rows[i][0] * rows[j][1] - rows[i][1] * rows[j][0]
    first = (values[i] * rows[j][1] - values[j] * rows[i][1]) / determinant
    second = (rows[i][0] * values[j] - rows[j][0] * values[i]) / determinant
    assert all(
        K.convert(row[0]) * first + K.convert(row[1]) * second == value
        for row, value in zip(rows, values)
    )
    return first, second


def main():
    print("invariant_cubic_basis")
    variables = sp.symbols("u0:5")
    for poly in CUBIC_BASIS:
        print(sp.factor(sum(c * sp.prod(v**e for v, e in zip(variables, exponent)) for exponent, c in poly.items())))
    for label, (a, b, _) in zip(("A5_class_1", "A5_class_2"), base.two_a5_classes()):
        matrix = intertwiner(a, b)
        coordinates = pencil_coordinates(klein_pullback(matrix))
        print(label)
        print("pencil_first=", K.to_sympy(coordinates[0]))
        print("pencil_second=", K.to_sympy(coordinates[1]))
        print("ratio=", K.to_sympy(coordinates[1] / coordinates[0]))
    print("CANONICAL_A5_PENCIL_OK")


if __name__ == "__main__":
    main()
