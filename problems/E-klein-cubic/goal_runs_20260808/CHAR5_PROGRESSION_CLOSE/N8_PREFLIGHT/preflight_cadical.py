#!/usr/bin/env python3
"""Fast root-degree-eight support preflight; UNSAT is not a certificate.

For a SAT answer, the coefficient mask is checked directly against every
reconstructed landing row.  For an UNSAT answer, this script reports only a
solver preflight and deliberately emits no theorem marker.
"""

from __future__ import annotations

import argparse
import importlib.util
import subprocess
import sys
import time
from collections import Counter
from pathlib import Path


ROOT_DEGREE = 8
HERE = Path(__file__).resolve().parent
LOW = HERE.parents[1] / "CHAR5_PROGRESSION_LOW_DEGREE" / "verify.py"


def load_low():
    spec = importlib.util.spec_from_file_location("char5_low", LOW)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def reconstruct(d: int, r: int):
    low = load_low()
    *_, basis_h, basis_k, equations = low.landing_system(d, r, ROOT_DEGREE)
    rows = []
    supports = set()
    for polynomial in equations:
        # The Counter is essential: distinct coefficient monomials can have
        # the same squarefree support, and they remain distinct active terms.
        counts = Counter(frozenset(monomial) for monomial in polynomial)
        rows.append(counts)
        supports.update(counts)
    return basis_h, basis_k, tuple(rows), supports


def make_cnf(n_h: int, n_k: int, rows, supports):
    n_x = n_h + n_k
    ordered_supports = sorted(supports, key=lambda s: (len(s), tuple(s)))
    support_var = {
        support: n_x + 1 + index
        for index, support in enumerate(ordered_supports)
    }
    clauses = []

    # y_S iff every coefficient variable in S is active.
    for support, y in support_var.items():
        for x in support:
            clauses.append([-y, x + 1])
        clauses.append([y, *(-(x + 1) for x in support)])

    # A landing row may not have exactly one active coefficient monomial.
    # If support S occurs with multiplicity >1, its activation alone already
    # contributes at least two monomials, so only multiplicity-one supports
    # require a clause.
    for counts in rows:
        row_variables = [support_var[support] for support in counts]
        for support, multiplicity in counts.items():
            if multiplicity == 1:
                y = support_var[support]
                clauses.append([-y, *(other for other in row_variables if other != y)])

    # Both Frobenius-residue components must be nonzero.
    clauses.append(list(range(1, n_h + 1)))
    clauses.append(list(range(n_h + 1, n_x + 1)))
    return support_var, clauses


def direct_check(mask: int, n_h: int, n_k: int, rows):
    assert mask & ((1 << n_h) - 1), "H support is empty"
    assert mask & (((1 << n_k) - 1) << n_h), "K support is empty"
    bad_rows = []
    for row_index, counts in enumerate(rows):
        active = 0
        for support, multiplicity in counts.items():
            support_mask = sum(1 << variable for variable in support)
            if support_mask & ~mask == 0:
                active += multiplicity
        if active == 1:
            bad_rows.append(row_index)
    assert not bad_rows, f"singleton landing rows: {bad_rows[:20]}"


def solve_case(d: int, r: int, pysat_path: Path):
    if str(pysat_path) not in sys.path:
        sys.path.insert(0, str(pysat_path))
    from pysat.solvers import Cadical195

    start = time.monotonic()
    basis_h, basis_k, rows, supports = reconstruct(d, r)
    support_var, clauses = make_cnf(len(basis_h), len(basis_k), rows, supports)
    built = time.monotonic()
    solver = Cadical195(bootstrap_with=clauses)
    is_sat = solver.solve()
    solved = time.monotonic()
    n_x = len(basis_h) + len(basis_k)
    if is_sat:
        model = solver.get_model()
        assert model is not None
        mask = sum(1 << (literal - 1) for literal in model if 1 <= literal <= n_x)
        direct_check(mask, len(basis_h), len(basis_k), rows)
        selected_h = [basis_h[i] for i in range(len(basis_h)) if mask & (1 << i)]
        selected_k = [
            basis_k[i]
            for i in range(len(basis_k))
            if mask & (1 << (len(basis_h) + i))
        ]
        print(
            "CASE", d, r,
            "DIMS", len(basis_h), len(basis_k),
            "ROWS", len(rows),
            "AUX", len(support_var),
            "CLAUSES", len(clauses),
            "RESULT SAT",
            "MASK", mask,
            "DIRECT_CHECK PASS",
            "BUILD_SECONDS", f"{built - start:.3f}",
            "SOLVE_SECONDS", f"{solved - built:.3f}",
            flush=True,
        )
        print("SELECTED_H", selected_h, flush=True)
        print("SELECTED_K", selected_k, flush=True)
        return True, mask

    print(
        "CASE", d, r,
        "DIMS", len(basis_h), len(basis_k),
        "ROWS", len(rows),
        "AUX", len(support_var),
        "CLAUSES", len(clauses),
        "RESULT UNSAT_PREFLIGHT_ONLY",
        "BUILD_SECONDS", f"{built - start:.3f}",
        "SOLVE_SECONDS", f"{solved - built:.3f}",
        flush=True,
    )
    return False, None


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("d", type=int, nargs="?")
    parser.add_argument("r", type=int, nargs="?")
    parser.add_argument("--pysat-path", type=Path, default=Path("/private/tmp/n7pysat"))
    parser.add_argument("--jobs", type=int, default=1)
    parser.add_argument(
        "--skip",
        action="append",
        default=[],
        help="case already checked, written d,r; may be repeated",
    )
    args = parser.parse_args()
    assert (args.d is None) == (args.r is None), "give both d and r, or neither"
    cases = (
        [(args.d, args.r)]
        if args.d is not None
        else [(d, r) for d in range(1, 5) for r in range(1, 5)]
    )
    skipped = {tuple(map(int, item.split(","))) for item in args.skip}
    cases = [case for case in cases if case not in skipped]
    for d, r in cases:
        assert 1 <= d <= 4 and 1 <= r <= 4
    if args.jobs == 1:
        for d, r in cases:
            solve_case(d, r, args.pysat_path)
    else:
        assert args.jobs > 0
        pending = iter(cases)
        running = []

        def launch(case):
            d, r = case
            command = [
                sys.executable,
                str(Path(__file__).resolve()),
                str(d),
                str(r),
                "--pysat-path",
                str(args.pysat_path),
            ]
            return case, subprocess.Popen(
                command,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
            )

        for _ in range(min(args.jobs, len(cases))):
            running.append(launch(next(pending)))
        while running:
            case, process = running.pop(0)
            output, _ = process.communicate()
            print(output, end="", flush=True)
            assert process.returncode == 0, f"child preflight failed: {case}"
            try:
                running.append(launch(next(pending)))
            except StopIteration:
                pass
    print("N8-SUPPORT-PREFLIGHT-COMPLETE-NO-THEOREM", flush=True)


if __name__ == "__main__":
    main()
