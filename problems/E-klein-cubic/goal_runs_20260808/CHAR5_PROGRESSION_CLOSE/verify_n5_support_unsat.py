#!/usr/bin/env python3
"""Dependency-free exact support-SAT audit at root degree five.

Any algebraic solution has a Boolean support of nonzero H/K coefficients.
For every output coefficient row of the Klein landing identity, the number
of active cubic coefficient monomials is either zero or at least two.  This
script reconstructs all rows over F5 and exhausts that Boolean condition by
an exact DPLL search; it uses no MILP, floating point, CAS, or SAT package.
"""

from collections import defaultdict
from functools import lru_cache
from itertools import combinations_with_replacement
import argparse


P = 5
W = (1, 9, 4, 3, 5)


def exponent_basis(degree, wanted_weight):
    out = []
    for indices in combinations_with_replacement(range(5), degree):
        exponent = [0] * 5
        for index in indices:
            exponent[index] += 1
        if sum(e * w for e, w in zip(exponent, W)) % 11 == wanted_weight:
            out.append(tuple(exponent))
    return tuple(out)


def rho(exponent, power=1):
    power %= 5
    return tuple(exponent[(j - power) % 5] for j in range(5))


def add3(a, b, c):
    return tuple(x + y + z for x, y, z in zip(a, b, c))


def support_rows(d, r, root_degree=5):
    a = tuple((d * j) % 5 for j in range(5))
    b = tuple((entry + r) % 5 for entry in a)
    wa = sum(x * w for x, w in zip(a, W)) % 11
    wb = sum(x * w for x, w in zip(b, W)) % 11
    wh = 9 * (1 - wa) % 11
    wk = 9 * (1 - wb) % 11
    hb = exponent_basis(root_degree, wh)
    kb = exponent_basis(root_degree, wk)
    support = []
    for index, u in enumerate(hb):
        support.append((tuple(a[j] + 5 * u[j] for j in range(5)), index))
    offset = len(hb)
    for index, u in enumerate(kb):
        support.append((tuple(b[j] + 5 * u[j] for j in range(5)), offset + index))

    equations = defaultdict(lambda: defaultdict(int))
    for shift in range(5):
        fi = [(rho(e, shift), c) for e, c in support]
        fn = [(rho(e, shift + 1), c) for e, c in support]
        for e1, c1 in fi:
            for e2, c2 in fi:
                for e3, c3 in fn:
                    target = add3(e1, e2, e3)
                    monomial = tuple(sorted((c1, c2, c3)))
                    equations[target][monomial] = (
                        equations[target][monomial] + 1
                    ) % P

    rows = []
    for polynomial in equations.values():
        terms = []
        for monomial, coefficient in polynomial.items():
            if coefficient:
                mask = 0
                for variable in set(monomial):
                    mask |= 1 << variable
                terms.append(mask)
        if terms:
            # Distinct coefficient monomials with the same variable support
            # remain distinct active terms and therefore remain duplicated.
            rows.append(tuple(terms))
    return len(hb), len(kb), tuple(rows)


class ExactSupportDPLL:
    def __init__(self, hdim, kdim, rows):
        self.hdim = hdim
        self.kdim = kdim
        self.nvars = hdim + kdim
        self.rows = rows
        self.hmask = (1 << hdim) - 1
        self.kmask = ((1 << kdim) - 1) << hdim
        occurrence = [0] * self.nvars
        for row in rows:
            for term in row:
                for variable in range(self.nvars):
                    if term >> variable & 1:
                        occurrence[variable] += 1
        self.occurrence = tuple(occurrence)
        self.nodes = 0

    def propagate(self, true_mask, false_mask):
        full = (1 << self.nvars) - 1
        while True:
            if true_mask & false_mask:
                return None
            changed_true = 0
            changed_false = 0

            for group in (self.hmask, self.kmask):
                if true_mask & group:
                    continue
                available = group & ~false_mask
                if not available:
                    return None
                if available & (available - 1) == 0:
                    changed_true |= available

            for row in self.rows:
                true_terms = []
                possible_terms = []
                for term in row:
                    if term & false_mask:
                        continue
                    possible_terms.append(term)
                    if term & ~true_mask == 0:
                        true_terms.append(term)
                true_count = len(true_terms)
                if true_count >= 2:
                    continue
                if true_count == 1:
                    candidates = [term for term in possible_terms
                                  if term & ~true_mask]
                    if not candidates:
                        return None
                    common = candidates[0]
                    for term in candidates[1:]:
                        common &= term
                    changed_true |= common & ~true_mask
                    if len(candidates) == 1:
                        changed_true |= candidates[0] & ~true_mask
                elif len(possible_terms) == 1:
                    # The sole possible term must be made inactive.
                    undecided = possible_terms[0] & ~(true_mask | false_mask)
                    if not undecided:
                        return None
                    if undecided & (undecided - 1) == 0:
                        changed_false |= undecided

            changed_true &= ~true_mask
            changed_false &= ~false_mask
            if changed_true & (false_mask | changed_false):
                return None
            if changed_false & true_mask:
                return None
            if not changed_true and not changed_false:
                return true_mask & full, false_mask & full
            true_mask |= changed_true
            false_mask |= changed_false

    def choose_variable(self, true_mask, false_mask):
        unassigned = ((1 << self.nvars) - 1) & ~(true_mask | false_mask)
        best = None
        best_score = -1
        # Prioritize variables occurring in a row with exactly one active
        # term, then fall back to total occurrence count.
        critical = 0
        for row in self.rows:
            true_count = 0
            candidate_union = 0
            for term in row:
                if term & false_mask:
                    continue
                if term & ~true_mask == 0:
                    true_count += 1
                else:
                    candidate_union |= term & unassigned
            if true_count == 1:
                critical |= candidate_union
        pool = critical or unassigned
        while pool:
            bit = pool & -pool
            variable = bit.bit_length() - 1
            score = self.occurrence[variable]
            if score > best_score:
                best = variable
                best_score = score
            pool ^= bit
        return best

    @lru_cache(maxsize=None)
    def search(self, true_mask, false_mask):
        self.nodes += 1
        state = self.propagate(true_mask, false_mask)
        if state is None:
            return None
        true_mask, false_mask = state
        if true_mask | false_mask == (1 << self.nvars) - 1:
            return true_mask
        variable = self.choose_variable(true_mask, false_mask)
        bit = 1 << variable
        result = self.search(true_mask | bit, false_mask)
        if result is not None:
            return result
        return self.search(true_mask, false_mask | bit)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--degree", type=int, default=5,
                        help="root degree to audit (default: 5)")
    args = parser.parse_args()
    root_degree = args.degree
    total_nodes = 0
    for d in range(1, 5):
        for r in range(1, 5):
            hdim, kdim, rows = support_rows(d, r, root_degree)
            solver = ExactSupportDPLL(hdim, kdim, rows)
            witness = solver.search(0, 0)
            total_nodes += solver.nodes
            print("D_R", d, r, "DIMS", hdim, kdim, "ROWS", len(rows),
                  "NODES", solver.nodes,
                  "STATUS", "UNSAT" if witness is None else "SAT",
                  "WITNESS", witness, flush=True)
            assert witness is None
    print("TOTAL_NODES", total_nodes)
    print(f"F55-CHAR5-PROGRESSION-N{root_degree}-SUPPORT-UNSAT-EXACT")


if __name__ == "__main__":
    main()
