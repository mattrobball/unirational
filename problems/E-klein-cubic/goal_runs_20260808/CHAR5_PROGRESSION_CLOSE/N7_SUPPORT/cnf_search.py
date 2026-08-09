#!/usr/bin/env python3
"""Exact CNF search generator for n=7; SymPy is not the final verifier."""

import importlib.util
from collections import Counter
from pathlib import Path

from sympy.logic.algorithms.dpll2 import SATSolver


HERE = Path(__file__).resolve().parent
LOW = HERE.parents[1] / "CHAR5_PROGRESSION_LOW_DEGREE" / "verify.py"


def load_low():
    spec = importlib.util.spec_from_file_location("low", LOW)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def cnf_groups(d, r):
    low = load_low()
    *_, hb, kb, equations = low.landing_system(d, r, 7)
    n = len(hb) + len(kb)
    rows = []
    supports = set()
    for polynomial in equations:
        counts = Counter(frozenset(monomial) for monomial in polynomial)
        rows.append(counts)
        supports.update(counts)
    support_var = {support: n + 1 + i
                   for i, support in enumerate(sorted(supports,
                                                       key=lambda s: (len(s), tuple(s))))}
    base_clauses = []
    for support, y in support_var.items():
        for x in support:
            base_clauses.append({-y, x + 1})
        base_clauses.append({y, *(-(x + 1) for x in support)})
    row_groups = []
    for counts in rows:
        row_vars = [support_var[support] for support in counts]
        group = []
        for support, multiplicity in counts.items():
            if multiplicity == 1:
                y = support_var[support]
                group.append({-y, *(other for other in row_vars if other != y)})
        row_groups.append(group)
    base_clauses.append(set(range(1, len(hb) + 1)))
    base_clauses.append(set(range(len(hb) + 1, n + 1)))
    return n, len(rows), support_var, base_clauses, row_groups


def cnf_case(d, r):
    n, nrows, support_var, base, groups = cnf_groups(d, r)
    clauses = list(base)
    for group in groups:
        clauses.extend(group)
    return n, nrows, support_var, clauses


def solve(d, r):
    n, nrows, support_var, clauses = cnf_case(d, r)
    nvars = n + len(support_var)
    solver = SATSolver(clauses, set(range(1, nvars + 1)), set(),
                       clause_learning="simple")
    models = solver._find_model()
    try:
        model = next(models)
    except StopIteration:
        model = None
    mask = None
    if model is not None:
        mask = sum(1 << (i - 1) for i in range(1, n + 1)
                   if model.get(i, False))
    print("CASE", d, r, "X_VARS", n, "Y_VARS", len(support_var),
          "ROWS", nrows, "CLAUSES", len(clauses),
          "DECISIONS", solver.num_decisions,
          "LEARNED", solver.num_learned_clauses,
          "RESULT", "UNSAT" if model is None else "SAT", "MASK", mask,
          flush=True)
    return mask


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("d", type=int)
    parser.add_argument("r", type=int)
    args = parser.parse_args()
    solve(args.d, args.r)
