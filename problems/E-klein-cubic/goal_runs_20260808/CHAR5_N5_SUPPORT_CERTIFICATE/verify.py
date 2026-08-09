#!/usr/bin/env python3
"""Dependency-free checker for the degree-35 support UNSAT certificate.

The certificate is a small semantic DPLL tree.  ``X`` is a leaf at which
sound fixed-point propagation finds a contradiction.  ``[v,left,right]``
branches on coefficient variable ``v`` being zero and nonzero.  The checker
reconstructs all landing rows over F_5 from the formulas, so no MILP status or
CAS output is trusted.
"""

from __future__ import annotations

import json
from collections import Counter, defaultdict
from itertools import combinations_with_replacement
from pathlib import Path


P = 5
W = (1, 9, 4, 3, 5)
ROOT_DEGREE = 5
PROOF = Path(__file__).with_name("proof.json")


def exponent_basis(degree: int, wanted_weight: int):
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


def landing_system(d: int, r: int):
    """Reconstruct the coefficient rows of the degree-35 landing identity."""
    a = tuple((d * j) % 5 for j in range(5))
    b = tuple((entry + r) % 5 for entry in a)
    weight_a = sum(x * w for x, w in zip(a, W)) % 11
    weight_b = sum(x * w for x, w in zip(b, W)) % 11
    weight_h = 9 * (1 - weight_a) % 11
    weight_k = 9 * (1 - weight_b) % 11
    basis_h = exponent_basis(ROOT_DEGREE, weight_h)
    basis_k = exponent_basis(ROOT_DEGREE, weight_k)

    # The renamed fifth powers of the H and K coefficients are variables.
    support = []
    for index, u in enumerate(basis_h):
        support.append((tuple(a[j] + 5 * u[j] for j in range(5)), index))
    offset = len(basis_h)
    for index, u in enumerate(basis_k):
        support.append((tuple(b[j] + 5 * u[j] for j in range(5)), offset + index))

    # Expand sum_i rho^i(f)^2 rho^(i+1)(f), combining equal coefficient
    # monomials modulo 5.  Target exponent keys are retained until the end.
    equations = defaultdict(lambda: defaultdict(int))
    for shift in range(5):
        current = [(rho(e, shift), c) for e, c in support]
        following = [(rho(e, shift + 1), c) for e, c in support]
        for e1, c1 in current:
            for e2, c2 in current:
                for e3, c3 in following:
                    target = tuple(x + y + z for x, y, z in zip(e1, e2, e3))
                    monomial = tuple(sorted((c1, c2, c3)))
                    equations[target][monomial] = (
                        equations[target][monomial] + 1
                    ) % P

    rows = []
    for polynomial in equations.values():
        counts = Counter()
        for monomial, coefficient in polynomial.items():
            if coefficient == 0:
                continue
            mask = 0
            for variable in set(monomial):
                mask |= 1 << variable
            # Distinct coefficient monomials with the same zero/nonzero
            # support remain distinct active terms.
            counts[mask] += 1
        if counts:
            rows.append(tuple(sorted(counts.items())))
    return basis_h, basis_k, tuple(rows)


class Semantics:
    def __init__(self, n_h, n_k, rows):
        self.n_h = n_h
        self.n_k = n_k
        self.n = n_h + n_k
        self.all_mask = (1 << self.n) - 1
        self.h_mask = (1 << n_h) - 1
        self.k_mask = self.all_mask ^ self.h_mask
        self.rows = rows

    def propagate(self, true_mask, false_mask):
        """Return the forced closure, or None for an exact contradiction.

        A term is active when its support is contained in ``true_mask`` and
        possible when its support avoids ``false_mask``.  Each row is required
        to have a number of active coefficient monomials different from one.
        """
        while True:
            if true_mask & false_mask:
                return None
            changed = False
            unknown = self.all_mask ^ (true_mask | false_mask)

            # Both summands H and K must be nonzero.
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
                possible_total = 0
                possible_nonactive = []
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
                    alternatives = {support for support, _ in possible_nonactive}
                    if len(alternatives) == 1:
                        # The only kind of surviving alternative must activate.
                        forced = next(iter(alternatives)) & unknown
                        if forced:
                            true_mask |= forced
                            changed = True
                elif possible_total == 1:
                    # The only possible term must be killed.  A one-variable
                    # killing clause gives a forced zero.
                    support = possible_nonactive[0][0]
                    candidates = support & unknown
                    if candidates == 0:
                        raise AssertionError("internal activity classification error")
                    if candidates & (candidates - 1) == 0:
                        false_mask |= candidates
                        changed = True

            if not changed:
                return true_mask, false_mask


def check_tree(semantics, tree, true_mask=0, false_mask=0):
    state = semantics.propagate(true_mask, false_mask)
    if tree == "X":
        assert state is None, "certificate claims a conflict where none propagates"
        return 0, 1
    assert state is not None, "certificate branches after an already forced conflict"
    assert isinstance(tree, list) and len(tree) == 3
    variable, zero_branch, nonzero_branch = tree
    assert isinstance(variable, int) and 0 <= variable < semantics.n
    true_mask, false_mask = state
    bit = 1 << variable
    assert not (bit & (true_mask | false_mask)), "branch variable is already forced"
    n0, l0 = check_tree(semantics, zero_branch, true_mask, false_mask | bit)
    n1, l1 = check_tree(semantics, nonzero_branch, true_mask | bit, false_mask)
    return 1 + n0 + n1, l0 + l1


def main():
    proof = json.loads(PROOF.read_text())
    assert set(proof) == {f"{d},{r}" for d in range(1, 5) for r in range(1, 5)}
    total_nodes = 0
    total_leaves = 0
    for d in range(1, 5):
        for r in range(1, 5):
            basis_h, basis_k, rows = landing_system(d, r)
            semantics = Semantics(len(basis_h), len(basis_k), rows)
            nodes, leaves = check_tree(semantics, proof[f"{d},{r}"])
            total_nodes += nodes
            total_leaves += leaves
            print(
                f"CASE {d} {r} VARS {semantics.n} ROWS {len(rows)} "
                f"BRANCH_NODES {nodes} CONFLICT_LEAVES {leaves} UNSAT"
            )
    print(f"TOTAL BRANCH_NODES {total_nodes} CONFLICT_LEAVES {total_leaves}")
    print("F55-CHAR5-DEGREE35-SUPPORT-UNSAT-CERTIFICATE-OK")


if __name__ == "__main__":
    main()
