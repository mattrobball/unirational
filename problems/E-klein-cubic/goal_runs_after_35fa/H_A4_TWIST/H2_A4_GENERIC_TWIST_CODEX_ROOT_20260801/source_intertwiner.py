#!/usr/bin/env python3
"""Exact change of source coordinates for the installed A4 twist.

The installed source is the restriction of the icosahedral model in
H_SUBGROUP_TWISTS_ROOT_019FBE10/produce.py.  This script constructs its
matrices over Q(sqrt(5)) and an exact intertwiner from the canonical
tetrahedral model used by exact_degree3_map.py.
"""

from __future__ import annotations

from collections import deque
import json
from pathlib import Path
import sys

import sympy as sp
from sympy.polys.domains import QQ


HERE = Path(__file__).resolve().parent
REPO = next(
    parent for parent in HERE.parents
    if (parent / "certificates" / "exact_weil_check.py").is_file()
    and (parent / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json").is_file()
)
UPSTREAM = REPO / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
sys.path.insert(0, str(UPSTREAM))
import produce as base  # noqa: E402


Q5 = QQ.algebraic_field(sp.sqrt(5))
ROOT5 = Q5.unit
ZERO, ONE = Q5.zero, Q5.one


def mm(left, right):
    return [
        [sum((left[i][k] * right[k][j] for k in range(len(right))), ZERO)
         for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def det(matrix):
    work = [list(row) for row in matrix]
    out = ONE
    for column in range(len(work)):
        pivot = next((row for row in range(column, len(work)) if work[row][column] != ZERO), None)
        if pivot is None:
            return ZERO
        if pivot != column:
            work[pivot], work[column] = work[column], work[pivot]
            out = -out
        unit = work[column][column]
        out *= unit
        for row in range(column + 1, len(work)):
            scale = work[row][column] / unit
            work[row] = [left - scale * right for left, right in zip(work[row], work[column])]
    return out


def nullspace(rows):
    work = [[Q5.convert(value) for value in row] for row in rows]
    row_count, column_count = len(work), len(work[0])
    pivots = []
    pivot_row = 0
    for column in range(column_count):
        pivot = next((row for row in range(pivot_row, row_count) if work[row][column] != ZERO), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        work[pivot_row] = [value / work[pivot_row][column] for value in work[pivot_row]]
        for row in range(row_count):
            if row != pivot_row and work[row][column] != ZERO:
                scale = work[row][column]
                work[row] = [left - scale * right for left, right in zip(work[row], work[pivot_row])]
        pivots.append(column)
        pivot_row += 1
    free = [column for column in range(column_count) if column not in pivots]
    output = []
    for free_column in free:
        vector = [ZERO] * column_count
        vector[free_column] = ONE
        for row, pivot in reversed(list(enumerate(pivots))):
            vector[pivot] = -sum((work[row][column] * vector[column] for column in free), ZERO)
        output.append(vector)
    return output


def installed_a5_source():
    alpha = -(ONE + ROOT5) / Q5.convert(2)
    g5, g3 = (1, 2, 3, 4, 0), (0, 1, 3, 4, 2)
    m5 = [[alpha, -alpha, -ONE], [alpha, ONE, ZERO], [alpha, -alpha, ZERO]]
    m3 = [[ZERO, -ONE, -alpha], [ZERO, ZERO, ONE], [-ONE, -alpha, ZERO]]
    identity = tuple(range(5))
    reps = {identity: [[ONE, ZERO, ZERO], [ZERO, ONE, ZERO], [ZERO, ZERO, ONE]]}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator, matrix in ((g5, m5), (g3, m3)):
            nxt = base.pc(current, generator)
            value = mm(reps[current], matrix)
            if nxt in reps:
                assert reps[nxt] == value
            else:
                reps[nxt] = value
                queue.append(nxt)
    assert len(reps) == 60
    return reps


def a4_data():
    first, _ = base.two_a5_classes()
    a, b, a5 = first
    mapping = base.iso(a, b, a5)
    involutions = [g for g in a5 if base.ORDERS[g] == 2]
    v4 = next(
        frozenset({base.ew.fone, x, y, base.gmul(x, y)})
        for index, x in enumerate(involutions)
        for y in involutions[index + 1:]
        if base.gmul(x, y) == base.gmul(y, x)
    )
    a4 = base.normalizer(v4, a5)
    ga, gb = base.gens(a4)
    installed_all = installed_a5_source()
    installed = {g: installed_all[mapping[g]] for g in a4}
    canonical_generators = {
        ga: [[-ONE, ZERO, ZERO], [ZERO, -ONE, ZERO], [ZERO, ZERO, ONE]],
        gb: [[ZERO, ONE, ZERO], [ZERO, ZERO, ONE], [ONE, ZERO, ZERO]],
    }
    identity = base.ew.fone
    canonical = {identity: [[ONE, ZERO, ZERO], [ZERO, ONE, ZERO], [ZERO, ZERO, ONE]]}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in (ga, gb):
            nxt = base.gmul(current, generator)
            value = mm(canonical[current], canonical_generators[generator])
            if nxt in canonical:
                assert canonical[nxt] == value
            else:
                canonical[nxt] = value
                queue.append(nxt)
    assert set(canonical) == set(a4)
    return (ga, gb), installed, canonical


def intertwiner(installed_generators, canonical_generators):
    rows = []
    for installed, canonical in zip(installed_generators, canonical_generators):
        for i in range(3):
            for j in range(3):
                row = [ZERO] * 9
                for k in range(3):
                    row[3 * i + k] += canonical[k][j]
                    row[3 * k + j] -= installed[i][k]
                rows.append(row)
    basis = nullspace(rows)
    assert len(basis) == 1
    vector = basis[0]
    leading = next(value for value in vector if value != ZERO)
    vector = [value / leading for value in vector]
    matrix = [vector[3 * i:3 * i + 3] for i in range(3)]
    assert det(matrix) != ZERO
    return matrix


def serialize(value):
    output = [[0, 1], [0, 1]]
    for (exponent,), coefficient in value.to_dict().items():
        output[exponent] = [int(coefficient.numerator), int(coefficient.denominator)]
    return output


def matrix_payload(matrix):
    return [[[list(pair) for pair in serialize(value)] for value in row] for row in matrix]


def main():
    generators, installed, canonical = a4_data()
    ga, gb = generators
    p = intertwiner([installed[ga], installed[gb]], [canonical[ga], canonical[gb]])
    for g in installed:
        assert mm(p, canonical[g]) == mm(installed[g], p)
    payload = {
        "format": "H2-A4-SOURCE-INTERTWINER-v1",
        "constant_field": "Q(sqrt(5)) embedded in C",
        "coefficient_encoding": "each scalar is [[a_num,a_den],[b_num,b_den]] for a+b*sqrt(5)",
        "subgroup_generators_psl2_f11": [list(ga), list(gb)],
        "canonical_generators": [matrix_payload(canonical[ga]), matrix_payload(canonical[gb])],
        "installed_generators": [matrix_payload(installed[ga]), matrix_payload(installed[gb])],
        "P_canonical_to_installed": matrix_payload(p),
        "determinant_P": serialize(det(p)),
        "identity": "P*sigma_can(h)=sigma_inst(h)*P for every one of the 12 elements h",
    }
    (HERE / "source_intertwiner.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("H2_A4_SOURCE_INTERTWINER_OK")


if __name__ == "__main__":
    main()
