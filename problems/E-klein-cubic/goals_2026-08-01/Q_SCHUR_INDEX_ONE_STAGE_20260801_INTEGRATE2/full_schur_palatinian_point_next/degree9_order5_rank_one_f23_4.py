#!/usr/bin/env python3
"""Exact order-5/order-10 rank-one eigenlines over F_(23^4)."""
from __future__ import annotations

import json
from pathlib import Path

import numpy as np

import degree9_full_landing as landing
import eigenline_rank_one_probe as eigen


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "degree9_order5_rank_one_f23_4.json"
P = 23
ZERO = (0, 0, 0, 0)
ONE = (1, 0, 0, 0)


def f2_add(x, y):
    return ((x[0] + y[0]) % P, (x[1] + y[1]) % P)


def f2_neg(x):
    return ((-x[0]) % P, (-x[1]) % P)


def f2_mul(x, y):
    return ((x[0] * y[0] + 5 * x[1] * y[1]) % P,
            (x[0] * y[1] + x[1] * y[0]) % P)


DELTA = (1, 1)  # nonsquare in F_529; v^2=1+u.


def split(x):
    return (x[:2], x[2:])


def join(a, b):
    return (a[0], a[1], b[0], b[1])


def add(x, y):
    a, b = split(x); c, d = split(y)
    return join(f2_add(a, c), f2_add(b, d))


def neg(x):
    a, b = split(x)
    return join(f2_neg(a), f2_neg(b))


def mul(x, y):
    a, b = split(x); c, d = split(y)
    return join(
        f2_add(f2_mul(a, c), f2_mul(DELTA, f2_mul(b, d))),
        f2_add(f2_mul(a, d), f2_mul(b, c)),
    )


def power(x, exponent):
    answer = ONE
    base = x
    while exponent:
        if exponent & 1:
            answer = mul(answer, base)
        exponent //= 2
        if exponent:
            base = mul(base, base)
    return answer


def inverse(x):
    assert x != ZERO
    return power(x, P**4 - 2)


def kernel(matrix):
    rows = [list(row) for row in matrix]
    pivots = []
    pivot_row = 0
    for column in range(len(rows[0])):
        chosen = next((i for i in range(pivot_row, len(rows))
                       if rows[i][column] != ZERO), None)
        if chosen is None:
            continue
        rows[pivot_row], rows[chosen] = rows[chosen], rows[pivot_row]
        scale = inverse(rows[pivot_row][column])
        rows[pivot_row] = [mul(scale, value) for value in rows[pivot_row]]
        for i in range(len(rows)):
            if i == pivot_row or rows[i][column] == ZERO:
                continue
            scale = neg(rows[i][column])
            rows[i] = [add(a, mul(scale, b))
                       for a, b in zip(rows[i], rows[pivot_row])]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(rows):
            break
    free = [i for i in range(len(rows[0])) if i not in pivots]
    answer = []
    for free_column in free:
        vector = [ZERO] * len(rows[0])
        vector[free_column] = ONE
        for row_index, pivot in enumerate(pivots):
            vector[pivot] = neg(rows[row_index][free_column])
        answer.append(vector)
    return answer


def matrix_minus_scalar(matrix, scalar):
    return [
        [add((int(matrix[i, j]), 0, 0, 0), neg(scalar) if i == j else ZERO)
         for j in range(6)]
        for i in range(6)
    ]


def rank(matrix):
    return len(matrix[0]) - len(kernel(matrix))


def normalize(vector):
    scale = inverse(next(value for value in vector if value != ZERO))
    return tuple(mul(scale, value) for value in vector)


def primitive_fifth_root():
    candidates = [
        (a, b, c, d)
        for a in range(3) for b in range(3)
        for c in range(3) for d in range(3)
        if (a, b, c, d) not in (ZERO, ONE)
    ]
    for candidate in candidates:
        root = power(candidate, (P**4 - 1) // 5)
        if root != ONE:
            assert power(root, 5) == ONE
            return root
    raise AssertionError("no fifth root")


def evaluate_seeds(probe, basis, point):
    transformed = []
    for group_matrix in probe.group:
        transformed.append([
            sum_field(mul((int(group_matrix[i, j]), 0, 0, 0), point[j])
                      for j in range(6))
            for i in range(6)
        ])
    answer = []
    for output, exponents in basis:
        values = []
        for row in transformed:
            value = ONE
            for coordinate, exponent in enumerate(exponents):
                if exponent:
                    value = mul(value, power(row[coordinate], exponent))
            values.append(value)
        answer.append([
            sum_field(mul(value, (int(probe.inverse[g, i, output]), 0, 0, 0))
                      for g, value in enumerate(values))
            for i in range(6)
        ])
    return answer


def sum_field(values):
    answer = ZERO
    for value in values:
        answer = add(answer, value)
    return answer


def quartic_value(quartic, point):
    answer = ZERO
    for alpha, coefficient in quartic.items():
        term = (coefficient, 0, 0, 0)
        for value, exponent in zip(point, alpha):
            if exponent:
                term = mul(term, power(value, exponent))
        answer = add(answer, term)
    return answer


def representative(probe, order):
    return next(matrix for matrix in probe.group if eigen.element_order(matrix) == order)


def main():
    probe = landing.probe_core.Probe()
    basis = probe.basis(9, 19)
    quartic, _ = landing.pencil_core.reconstruct()
    root = primitive_fifth_root()
    records = []
    forms = []
    for order in (5, 10):
        matrix = representative(probe, order)
        eigenvalues = [power(root, k) for k in range(5)]
        if order == 10:
            minus_one = neg(ONE)
            eigenvalues += [mul(minus_one, value) for value in eigenvalues]
        for eigenvalue in eigenvalues:
            source = kernel(matrix_minus_scalar(matrix, eigenvalue))
            if not source:
                continue
            for eigenvector in source:
                outputs = evaluate_seeds(probe, basis, eigenvector)
                output_rank = rank([[outputs[column][row] for column in range(19)]
                                    for row in range(6)])
                record = {
                    "group_order": order,
                    "eigenvalue": list(eigenvalue),
                    "source_eigenspace_dimension": len(source),
                    "evaluation_rank": output_rank,
                    "eigenvector": [list(value) for value in eigenvector],
                }
                if output_rank == 1:
                    coordinate = next(
                        j for j in range(6)
                        if any(outputs[i][j] != ZERO for i in range(19))
                    )
                    raw_form = [outputs[i][coordinate] for i in range(19)]
                    form = normalize(raw_form)
                    pivot_index = next(i for i, value in enumerate(raw_form) if value != ZERO)
                    scale = inverse(raw_form[pivot_index])
                    direction = [mul(scale, value) for value in outputs[pivot_index]]
                    endpoint = quartic_value(quartic, direction)
                    record.update({
                        "normalized_coefficient_form": [list(value) for value in form],
                        "common_direction_I4": list(endpoint),
                        "nonzero_fourth_power_equation": endpoint != ZERO,
                    })
                    if endpoint != ZERO:
                        forms.append(form)
                records.append(record)
    unique = list(dict.fromkeys(forms))
    form_rank = rank([list(form) for form in unique]) if unique else 0
    # Components of all F_(23^4)-forms give the F_23 row space cutting out
    # their common kernel.
    component_rows = np.asarray(
        [[entry[component] for entry in form]
         for form in unique for component in range(4)], dtype=np.int64
    ) % P
    component_rank = landing.probe_core.fano.rank(component_rows)
    payload = {
        "field": "F_23[u,v]/(u^2-5,v^2-(1+u))",
        "primitive_fifth_root": list(root),
        "records": records,
        "unique_nonzero_fourth_power_forms": len(unique),
        "form_rank_over_F23_4": form_rank,
        "component_row_rank_over_F23": component_rank,
        "component_rows_over_F23": component_rows.tolist(),
    }
    OUTPUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(
        f"records={len(records)} uniqueForms={len(unique)} "
        f"formRank={form_rank} componentRank={component_rank}"
    )
    print("ORDER5_RANK_ONE_F23_4_PROBE_OK")


if __name__ == "__main__":
    main()
