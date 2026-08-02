#!/usr/bin/env python3
"""Exact rank-one eigenline probe for the full degree-nine coefficient space.

For an eigenvector x of a Schur group element h with eigenvalue lambda,
equivariance forces every degree-nine self-covariant q_i(x) into the
lambda^9 eigenspace.  When the resulting 19-by-6 evaluation matrix has rank
one and its common image direction is off I4=0, the landing equation at x is
a nonzero fourth power L_x(a)^4.  Enough independent L_x would therefore
give an immediate projective-emptiness certificate without Groebner bases.

This probe exhausts eigenvalues in F_529 for one representative of every
(order, trace) type.  It is theorem-producing only if the reported rank of
the collected coefficient forms is 19; otherwise it is a scoped exact
nonverdict.
"""
from __future__ import annotations

from collections import Counter
import json
from pathlib import Path

import numpy as np

import degree9_full_landing as landing


HERE = Path(__file__).resolve().parent
P = 23
D = 5
OUTPUT = HERE / "degree9_rank_one_eigenlines_f529.json"


def add(left, right):
    return ((left[0] + right[0]) % P, (left[1] + right[1]) % P)


def neg(value):
    return ((-value[0]) % P, (-value[1]) % P)


def mul(left, right):
    return (
        (left[0] * right[0] + D * left[1] * right[1]) % P,
        (left[0] * right[1] + left[1] * right[0]) % P,
    )


def inverse(value):
    denominator = (value[0] * value[0] - D * value[1] * value[1]) % P
    assert denominator
    scale = pow(denominator, -1, P)
    return (value[0] * scale % P, -value[1] * scale % P)


def power(value, exponent):
    answer = (1, 0)
    base = value
    while exponent:
        if exponent & 1:
            answer = mul(answer, base)
        exponent //= 2
        if exponent:
            base = mul(base, base)
    return answer


def is_zero(value):
    return value[0] % P == 0 and value[1] % P == 0


def kernel(matrix):
    """Return a basis for the right kernel over F_529."""
    rows = [
        [(int(entry[0]) % P, int(entry[1]) % P) for entry in row]
        for row in matrix
    ]
    row_count = len(rows)
    column_count = len(rows[0])
    pivots = []
    pivot_row = 0
    for column in range(column_count):
        chosen = next(
            (index for index in range(pivot_row, row_count)
             if not is_zero(rows[index][column])),
            None,
        )
        if chosen is None:
            continue
        rows[pivot_row], rows[chosen] = rows[chosen], rows[pivot_row]
        scale = inverse(rows[pivot_row][column])
        rows[pivot_row] = [mul(scale, value) for value in rows[pivot_row]]
        for index in range(row_count):
            if index == pivot_row or is_zero(rows[index][column]):
                continue
            scale = neg(rows[index][column])
            rows[index] = [
                add(left, mul(scale, right))
                for left, right in zip(rows[index], rows[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == row_count:
            break
    free = [column for column in range(column_count) if column not in pivots]
    answer = []
    for free_column in free:
        vector = [(0, 0)] * column_count
        vector[free_column] = (1, 0)
        for row_index, pivot in reversed(list(enumerate(pivots))):
            value = (0, 0)
            for column in free:
                value = add(value, mul(rows[row_index][column], vector[column]))
            vector[pivot] = neg(value)
        answer.append(vector)
    return answer


def matrix_minus_scalar(matrix, scalar):
    answer = np.zeros((6, 6, 2), dtype=np.int64)
    answer[:, :, 0] = matrix
    for index in range(6):
        answer[index, index, 0] = (answer[index, index, 0] - scalar[0]) % P
        answer[index, index, 1] = (-scalar[1]) % P
    return answer


def rank(matrix):
    return matrix.shape[1] - len(kernel(matrix))


def element_order(matrix):
    identity = np.eye(6, dtype=np.int64)
    power_matrix = identity.copy()
    for order in range(1, 100):
        power_matrix = power_matrix @ matrix % P
        if np.array_equal(power_matrix, identity):
            return order
    raise AssertionError("order > 99")


def projective_test_vectors(basis):
    # Exact deterministic representatives.  All eigenspaces encountered in
    # the rank-one branch are one-dimensional, but include pair sums so the
    # scope stays explicit if a larger source eigenspace occurs.
    answer = list(basis)
    for left in range(len(basis)):
        for right in range(left + 1, len(basis)):
            answer.append([add(a, b) for a, b in zip(basis[left], basis[right])])
    return answer


def main():
    probe = landing.probe_core.Probe()
    basis = probe.basis(9, 19)
    quartic, _ = landing.pencil_core.reconstruct()
    representatives = {}
    type_counts = Counter()
    for matrix in probe.group:
        key = (element_order(matrix), int(np.trace(matrix) % P))
        type_counts[key] += 1
        representatives.setdefault(key, matrix)

    field_elements = [(a, b) for a in range(P) for b in range(P)]
    records = []
    coefficient_forms = []
    for key in sorted(representatives):
        matrix = representatives[key]
        for eigenvalue in field_elements:
            source_basis = kernel(matrix_minus_scalar(matrix, eigenvalue))
            if not source_basis:
                continue
            target_value = power(eigenvalue, 9)
            target_dimension = len(kernel(matrix_minus_scalar(matrix, target_value)))
            for vector_index, vector in enumerate(projective_test_vectors(source_basis)):
                point = np.asarray(vector, dtype=np.int64)
                outputs = landing.extension_seed_values(probe, basis, point)
                output_rank = rank(outputs.transpose(1, 0, 2))
                record = {
                    "group_type": {"order": key[0], "trace": key[1],
                                   "count": type_counts[key]},
                    "eigenvalue": list(eigenvalue),
                    "source_eigenspace_dimension": len(source_basis),
                    "target_eigenvalue_lambda9": list(target_value),
                    "target_eigenspace_dimension": target_dimension,
                    "test_vector_index": vector_index,
                    "eigenvector": point.tolist(),
                    "evaluation_rank": output_rank,
                }
                if output_rank == 1:
                    nonzero = np.argwhere(np.any(outputs != 0, axis=2))
                    assert len(nonzero)
                    output_coordinate = int(nonzero[0, 1])
                    form = outputs[:, output_coordinate, :]
                    form_index = int(np.flatnonzero(np.any(form != 0, axis=1))[0])
                    scale = inverse(tuple(int(v) for v in form[form_index]))
                    normalized_form = np.asarray(
                        [mul(scale, tuple(int(v) for v in entry)) for entry in form],
                        dtype=np.int64,
                    )
                    direction = np.asarray(
                        [
                            mul(
                                tuple(int(v) for v in outputs[form_index, coordinate]),
                                scale,
                            )
                            for coordinate in range(6)
                        ],
                        dtype=np.int64,
                    )
                    direction_i4 = landing.gf529_quartic_value(quartic, direction)
                    record.update(
                        {
                            "normalized_coefficient_form": normalized_form.tolist(),
                            "common_direction": direction.tolist(),
                            "common_direction_I4": direction_i4.tolist(),
                            "nonzero_fourth_power_equation": bool(
                                np.any(direction_i4 != 0)
                            ),
                        }
                    )
                    if np.any(direction_i4 != 0):
                        coefficient_forms.append(normalized_form)
                records.append(record)

    unique = []
    seen = set()
    for form in coefficient_forms:
        key = tuple(int(value) for value in form.reshape(-1))
        if key not in seen:
            seen.add(key)
            unique.append(form)
    form_matrix = np.stack(unique) if unique else np.zeros((0, 19, 2), dtype=np.int64)
    form_rank = rank(form_matrix) if len(unique) else 0
    payload = {
        "field": "F_23[u]/(u^2-5)",
        "complete_group_type_counts": [
            {"order": key[0], "trace": key[1], "count": count}
            for key, count in sorted(type_counts.items())
        ],
        "eigenvalue_search": "all 529 field elements for every group type representative",
        "record_count": len(records),
        "rank_one_nonzero_fourth_power_records": len(coefficient_forms),
        "unique_normalized_coefficient_forms": len(unique),
        "coefficient_form_rank_over_F529": form_rank,
        "projective_emptiness_from_fourth_powers": form_rank == 19,
        "records": records,
    }
    OUTPUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(
        f"records={len(records)} rankOneForms={len(coefficient_forms)} "
        f"uniqueForms={len(unique)} formRank={form_rank}/19"
    )
    if form_rank == 19:
        print("FULL_DEGREE9_PROJECTIVE_EMPTINESS_FROM_EIGENLINES_OK")
    else:
        print("SCOPE exact F_529 eigenline probe; no projective-emptiness verdict")


if __name__ == "__main__":
    main()
