#!/usr/bin/env python3
"""Intersect modular denominator spaces for selected compressed L_a entries.

This is a p=353 structural probe.  It identifies whether the degree-four
rational fits seen by ``probe_la_rational_degree.py`` share a denominator;
it is not a characteristic-zero reconstruction certificate.
"""

from __future__ import annotations

import json
from pathlib import Path

import numpy as np

from probe_la_rational_degree import DATA, P, monomial_values, monoms


def nullspace_mod(matrix, p=P):
    a = np.asarray(matrix, dtype=np.int64).copy() % p
    nrows, ncols = a.shape
    pivot_columns = []
    row = 0
    for column in range(ncols):
        candidates = np.flatnonzero(a[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        if pivot != row:
            a[[row, pivot]] = a[[pivot, row]]
        a[row, column:] = a[row, column:] * pow(int(a[row, column]), -1, p) % p
        active = np.flatnonzero(a[row + 1 :, column]) + row + 1
        if len(active):
            factors = a[active, column].copy()
            for start in range(0, len(active), 128):
                rows = active[start : start + 128]
                fac = factors[start : start + 128]
                a[rows, column:] = (a[rows, column:] - fac[:, None] * a[row, column:]) % p
        pivot_columns.append(column)
        row += 1
        if row == nrows:
            break

    pivot_set = set(pivot_columns)
    free_columns = [column for column in range(ncols) if column not in pivot_set]
    basis = np.zeros((ncols, len(free_columns)), dtype=np.int64)
    for basis_column, free in enumerate(free_columns):
        vector = np.zeros(ncols, dtype=np.int64)
        vector[free] = 1
        for pivot_row in range(len(pivot_columns) - 1, -1, -1):
            pivot = pivot_columns[pivot_row]
            vector[pivot] = -int(np.dot(a[pivot_row, pivot + 1 :], vector[pivot + 1 :])) % p
        basis[:, basis_column] = vector
    assert np.all(np.asarray(matrix, dtype=np.int64) @ basis % p == 0)
    return basis


def column_basis(matrix, p=P):
    matrix = np.asarray(matrix, dtype=np.int64) % p
    chosen = []
    rank = 0
    for column in range(matrix.shape[1]):
        trial = matrix[:, chosen + [column]]
        nullity = nullspace_mod(trial, p).shape[1]
        new_rank = trial.shape[1] - nullity
        if new_rank > rank:
            chosen.append(column)
            rank = new_rank
    return matrix[:, chosen]


def intersection(left, right, p=P):
    equation = np.concatenate([left, -right], axis=1) % p
    kernel = nullspace_mod(equation, p)
    candidates = left @ kernel[: left.shape[1], :] % p
    return column_basis(candidates, p)


def denominator_space(numerator, monomial_matrix, values):
    denominator = -(values[:, None] * monomial_matrix) % P
    augmented = np.concatenate([numerator, denominator], axis=1) % P
    kernel = nullspace_mod(augmented, P)
    den = kernel[numerator.shape[1] :, :] % P
    # No numerator-only kernel: the Hironaka free-basis design has full rank.
    assert den.shape[1] == kernel.shape[1]
    return column_basis(den, P)


def main():
    packet = np.load(DATA)
    ts = packet["ts"].astype(np.int64) % P
    betas = packet["betas"].astype(np.int64) % P
    la = packet["La_E"].astype(np.int64) % P
    exponents = monoms(4)
    mv = monomial_values(ts, exponents)
    numerator = np.concatenate([betas[:, s : s + 1] * mv % P for s in range(12)], axis=1)

    entries = [(0, 1, 0), (0, 1, 1), (1, 1, 0), (2, 3, 4), (5, 5, 5)]
    common = None
    dimensions = []
    for entry in entries:
        space = denominator_space(numerator, mv, la[:, entry[0], entry[1], entry[2]])
        common = space if common is None else intersection(common, space)
        dimensions.append({
            "entry": list(entry),
            "entry_denominator_dimension": int(space.shape[1]),
            "running_common_dimension": int(common.shape[1]),
        })

    degree_counts = []
    for max_degree in range(5):
        allowed = sum(1 for exponent in exponents if sum(exponent) <= max_degree)
        tail = common[allowed:, :]
        kernel = nullspace_mod(tail, P)
        degree_counts.append({
            "max_degree": max_degree,
            "common_vectors_with_degree_at_most_D": int(kernel.shape[1]),
        })

    print(json.dumps({
        "scope": "one-prime common-denominator probe only",
        "prime": P,
        "degree": 4,
        "monomial_order": [list(exponent) for exponent in exponents],
        "dimensions": dimensions,
        "final_common_dimension": int(common.shape[1]),
        "degree_filtration": degree_counts,
    }, indent=2))


if __name__ == "__main__":
    main()
