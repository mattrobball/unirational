#!/usr/bin/env python3
"""Floating MILP preflight for n=7 support masks; never a verdict."""

import importlib.util
from collections import Counter
from pathlib import Path

import numpy as np
from scipy.optimize import Bounds, LinearConstraint, milp
from scipy.sparse import lil_matrix


HERE = Path(__file__).resolve().parent
LOW = HERE.parents[1] / "CHAR5_PROGRESSION_LOW_DEGREE" / "verify.py"


def load_low():
    spec = importlib.util.spec_from_file_location("low", LOW)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def rows_from(equations):
    rows = []
    for polynomial in equations:
        counts = Counter()
        for monomial in polynomial:
            counts[frozenset(monomial)] += 1
        rows.append(tuple(counts.items()))
    return rows


def solve_case(d, r):
    low = load_low()
    *_, hb, kb, equations = low.landing_system(d, r, 7)
    rows = rows_from(equations)
    n = len(hb) + len(kb)

    # Variables: coefficient activity x; one AND activity y per distinct
    # Boolean support in each row; row switch z (0 terms versus >=2 terms).
    occurrences = []
    for row_index, row in enumerate(rows):
        for support, multiplicity in row:
            occurrences.append((row_index, support, multiplicity))
    ny = len(occurrences)
    nz = len(rows)
    total = n + ny + nz
    constraints = []

    # Store sparse rows as dictionaries first.
    lower = []
    upper = []
    for yi, (_, support, _) in enumerate(occurrences):
        y = n + yi
        for variable in support:
            constraints.append({y: 1.0, variable: -1.0})
            lower.append(-np.inf)
            upper.append(0.0)  # y <= x_v
        row = {y: 1.0}
        for variable in support:
            row[variable] = row.get(variable, 0.0) - 1.0
        constraints.append(row)
        lower.append(1.0 - len(support))
        upper.append(np.inf)  # y >= sum x - (k-1)

    by_row = [[] for _ in rows]
    for yi, (row_index, _, multiplicity) in enumerate(occurrences):
        by_row[row_index].append((n + yi, multiplicity))
    for row_index, entries in enumerate(by_row):
        z = n + ny + row_index
        count = {yi: float(mult) for yi, mult in entries}
        row = dict(count)
        row[z] = -2.0
        constraints.append(row)
        lower.append(0.0)
        upper.append(np.inf)  # count >= 2z
        row = dict(count)
        row[z] = -float(sum(mult for _, mult in entries))
        constraints.append(row)
        lower.append(-np.inf)
        upper.append(0.0)  # count <= Mz

    constraints.append({i: 1.0 for i in range(len(hb))})
    lower.append(1.0)
    upper.append(np.inf)
    constraints.append({len(hb) + i: 1.0 for i in range(len(kb))})
    lower.append(1.0)
    upper.append(np.inf)

    matrix = lil_matrix((len(constraints), total), dtype=float)
    for i, row in enumerate(constraints):
        for j, value in row.items():
            matrix[i, j] = value
    result = milp(
        np.zeros(total),
        integrality=np.ones(total),
        bounds=Bounds(np.zeros(total), np.ones(total)),
        constraints=LinearConstraint(matrix.tocsr(), np.array(lower), np.array(upper)),
        options={"time_limit": 120.0},
    )
    mask = None
    if result.x is not None:
        mask = sum((int(round(result.x[i])) << i) for i in range(n))
    print("CASE", d, r, "DIMS", len(hb), len(kb), "ROWS", len(rows),
          "MILP_STATUS", result.status, result.message, "MASK", mask, flush=True)
    return mask


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("d", type=int)
    parser.add_argument("r", type=int)
    args = parser.parse_args()
    solve_case(args.d, args.r)
