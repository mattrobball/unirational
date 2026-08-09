#!/usr/bin/env python3
"""Exact semantic search for the n=5 two-residue support condition.

This is a development generator.  It uses only integer bit masks and the
standard library; in particular it does not trust a floating MILP status.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import time
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
LANDING = HERE.parent / "CHAR5_PROGRESSION_LOW_DEGREE" / "verify.py"


def load_landing():
    spec = importlib.util.spec_from_file_location("landing_low_degree", LANDING)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def boolean_rows(equations):
    """Return each row as ((support_mask, multiplicity), ...).

    A coefficient monomial is active exactly when all distinct coefficient
    variables occurring in it are nonzero.  Different monomials having the
    same Boolean support retain their multiplicity.
    """
    rows = []
    for polynomial in equations:
        counts = Counter()
        for coefficient_monomial in polynomial:
            mask = 0
            for variable in set(coefficient_monomial):
                mask |= 1 << variable
            counts[mask] += 1
        rows.append(tuple(sorted(counts.items())))
    return tuple(rows)


class Search:
    def __init__(self, n_h, n_k, rows, deadline=None):
        self.n_h = n_h
        self.n_k = n_k
        self.n = n_h + n_k
        self.all_mask = (1 << self.n) - 1
        self.h_mask = (1 << n_h) - 1
        self.k_mask = self.all_mask ^ self.h_mask
        self.rows = rows
        self.nodes = 0
        self.leaves = 0
        self.cache = {}
        self.deadline = deadline
        occurrence = [0] * self.n
        for row in rows:
            for support, multiplicity in row:
                for v in range(self.n):
                    if support >> v & 1:
                        occurrence[v] += multiplicity
        self.occurrence = occurrence

    def propagate(self, true_mask, false_mask):
        """Sound fixed-point propagation for the no-singleton constraints."""
        while True:
            if true_mask & false_mask:
                return None
            changed = False
            unknown = self.all_mask ^ (true_mask | false_mask)

            # H and K must each have a nonzero coefficient.
            for group in (self.h_mask, self.k_mask):
                if true_mask & group:
                    continue
                candidates = unknown & group
                if candidates == 0:
                    return None
                if candidates & (candidates - 1) == 0:
                    true_mask |= candidates
                    changed = True

            for row in self.rows:
                active = 0
                possible_nonactive = []
                possible_total = 0
                for support, multiplicity in row:
                    if support & false_mask:
                        continue
                    possible_total += multiplicity
                    if support & ~true_mask == 0:
                        active += multiplicity
                    else:
                        possible_nonactive.append((support, multiplicity))

                if active >= 2:
                    continue
                if active == 1:
                    if possible_total == 1:
                        return None
                    distinct = {support for support, _ in possible_nonactive}
                    if len(distinct) == 1:
                        force = next(iter(distinct)) & unknown
                        if force:
                            true_mask |= force
                            changed = True
                elif possible_total == 1:
                    # Exactly one term can still activate.  It must be killed.
                    support = possible_nonactive[0][0]
                    candidates = support & unknown
                    if candidates == 0:
                        raise AssertionError("possible term was neither active nor unknown")
                    if candidates & (candidates - 1) == 0:
                        false_mask |= candidates
                        changed = True

            if not changed:
                return true_mask, false_mask

    def solve(self, true_mask=0, false_mask=0):
        if self.deadline is not None and time.monotonic() >= self.deadline:
            raise TimeoutError
        state = self.propagate(true_mask, false_mask)
        if state is None:
            self.leaves += 1
            return None
        true_mask, false_mask = state
        key = (true_mask, false_mask)
        if key in self.cache:
            return self.cache[key]
        self.nodes += 1
        unknown = self.all_mask ^ (true_mask | false_mask)
        if unknown == 0:
            # No row has exactly one active term (propagate would reject it).
            return true_mask

        variables = [v for v in range(self.n) if unknown >> v & 1]
        variable = max(variables, key=self.occurrence.__getitem__)
        bit = 1 << variable
        result = self.solve(true_mask, false_mask | bit)
        if result is None:
            result = self.solve(true_mask | bit, false_mask)
        self.cache[key] = result
        return result

    def prove(self, true_mask=0, false_mask=0):
        """Return ``(witness, tree)`` from exact DPLL search.

        ``"X"`` denotes a propagated contradiction.  A list
        ``[v, zero, nonzero]`` exhausts the two values of variable ``v``.
        Exactly one of ``witness`` and ``tree`` is non-None.
        """
        if self.deadline is not None and time.monotonic() >= self.deadline:
            raise TimeoutError
        state = self.propagate(true_mask, false_mask)
        if state is None:
            self.leaves += 1
            return None, "X"
        true_mask, false_mask = state
        unknown = self.all_mask ^ (true_mask | false_mask)
        if unknown == 0:
            return true_mask, None
        self.nodes += 1
        variables = [v for v in range(self.n) if unknown >> v & 1]
        variable = max(variables, key=self.occurrence.__getitem__)
        bit = 1 << variable
        witness, zero_tree = self.prove(true_mask, false_mask | bit)
        if witness is not None:
            return witness, None
        witness, nonzero_tree = self.prove(true_mask | bit, false_mask)
        if witness is not None:
            return witness, None
        return None, [variable, zero_tree, nonzero_tree]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--root-degree", type=int, default=5)
    parser.add_argument(
        "--seconds", type=float, default=0.0,
        help="global wall-clock budget; zero means unlimited",
    )
    parser.add_argument(
        "--cases", default="",
        help="semicolon-separated d,r pairs; empty means all 16",
    )
    parser.add_argument(
        "--emit-proof", action="store_true",
        help="print the completed semantic-DPLL trees as one JSON object",
    )
    args = parser.parse_args()
    landing = load_landing()
    if args.cases:
        cases = [tuple(map(int, item.split(","))) for item in args.cases.split(";")]
    else:
        cases = [(d, r) for d in range(1, 5) for r in range(1, 5)]
    started = time.monotonic()
    deadline = started + args.seconds if args.seconds else None
    proofs = {}
    for d, r in cases:
        if deadline is not None and time.monotonic() >= deadline:
            print("GLOBAL_TIMEOUT BEFORE_CASE", d, r, flush=True)
            break
        *_, basis_h, basis_k, equations = landing.landing_system(
            d, r, args.root_degree
        )
        rows = boolean_rows(equations)
        search = Search(len(basis_h), len(basis_k), rows, deadline)
        case_started = time.monotonic()
        try:
            if args.emit_proof:
                answer, tree = search.prove()
                if tree is not None:
                    proofs[f"{d},{r}"] = tree
            else:
                answer = search.solve()
        except TimeoutError:
            print("GLOBAL_TIMEOUT DURING_CASE", d, r, flush=True)
            break
        print(
            "CASE", d, r,
            "ROOT_DEGREE", args.root_degree,
            "VARS", search.n,
            "ROWS", len(rows),
            "NODES", search.nodes,
            "LEAVES", search.leaves,
            "CACHE", len(search.cache),
            "RESULT", "SAT" if answer is not None else "UNSAT",
            "SUPPORT", answer,
            "SECONDS", round(time.monotonic() - case_started, 3),
            flush=True,
        )
    print("TOTAL_SECONDS", round(time.monotonic() - started, 3), flush=True)
    if args.emit_proof:
        print("PROOF_JSON", json.dumps(proofs, separators=(",", ":"), sort_keys=True))


if __name__ == "__main__":
    main()
