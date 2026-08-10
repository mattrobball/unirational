#!/usr/bin/env python3
"""Exact dependency-free support obstruction at progression root degree five.

For each of the sixteen (d,r) progression families, reconstruct the complete
coefficient rows of the Klein landing identity.  A Boolean support can occur
at a geometric landing point only if H and K are both nonzero and no row has
exactly one active coefficient monomial.  The proof-producing search below
exhausts those Boolean conditions using integer bit masks only.
"""

from __future__ import annotations

from collections import Counter, defaultdict
from functools import lru_cache
from itertools import combinations_with_replacement
from hashlib import sha256


P = 5
W = (1, 9, 4, 3, 5)
ROOT_DEGREE = 5
EXPECTED_FAMILY_RECORD_SHA256 = (
    "26320813bd93445e535af7547fb9998d6f5f8cb966598b30e420f8f10f5d66f7"
)


def exponent_basis(degree: int, wanted_weight: int):
    out = []
    for indices in combinations_with_replacement(range(5), degree):
        exponent = tuple(indices.count(j) for j in range(5))
        if sum(e * w for e, w in zip(exponent, W)) % 11 == wanted_weight:
            out.append(exponent)
    return tuple(out)


def rho(exponent, power=1):
    power %= 5
    return tuple(exponent[(j - power) % 5] for j in range(5))


def add3(a, b, c):
    return tuple(x + y + z for x, y, z in zip(a, b, c))


def landing_rows(d: int, r: int):
    a = tuple((d * j) % 5 for j in range(5))
    b = tuple((entry + r) % 5 for entry in a)
    weight_a = sum(x * w for x, w in zip(a, W)) % 11
    weight_b = sum(x * w for x, w in zip(b, W)) % 11
    weight_h = 9 * (1 - weight_a) % 11
    weight_k = 9 * (1 - weight_b) % 11
    basis_h = exponent_basis(ROOT_DEGREE, weight_h)
    basis_k = exponent_basis(ROOT_DEGREE, weight_k)

    support = []
    for index, u in enumerate(basis_h):
        support.append((tuple(a[j] + 5 * u[j] for j in range(5)), index))
    offset = len(basis_h)
    for index, u in enumerate(basis_k):
        support.append((tuple(b[j] + 5 * u[j] for j in range(5)), offset + index))

    # Ordered multiplication automatically supplies coefficient two on the
    # off-diagonal square terms.  The coefficient monomial is a sorted triple.
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

    polynomial_rows = []
    support_rows = []
    for polynomial in equations.values():
        clean = tuple(sorted((m, c) for m, c in polynomial.items() if c))
        if not clean:
            continue
        polynomial_rows.append(clean)
        # Repetitions are intentional: a^2*b and a*b^2 are distinct active
        # monomials although they have the same Boolean support {a,b}.
        masks = tuple(sorted(sum(1 << v for v in set(m)) for m, _ in clean))
        support_rows.append(masks)

    # The five cyclic source shifts repeat each coefficient polynomial.  It is
    # logically harmless, and much faster, to retain one copy of each row.
    unique_rows = tuple(sorted(set(support_rows)))
    polynomial_digest = sha256(repr(sorted(polynomial_rows)).encode()).hexdigest()
    return basis_h, basis_k, tuple(support_rows), unique_rows, polynomial_digest


class ExactSupportSearch:
    def __init__(self, rows, hdim, kdim):
        self.rows = rows
        self.hdim = hdim
        self.kdim = kdim
        self.nvars = hdim + kdim
        self.all_mask = (1 << self.nvars) - 1
        self.hmask = (1 << hdim) - 1
        self.kmask = self.all_mask ^ self.hmask
        self.nodes = 0
        self.cache_hits = 0
        self.contradictions = Counter()
        self.branch_kinds = Counter()
        self.max_depth = 0

    def solve(self):
        @lru_cache(maxsize=None)
        def visit(true_mask, false_mask):
            self.nodes += 1
            self.max_depth = max(
                self.max_depth, (true_mask | false_mask).bit_count()
            )
            assert not true_mask & false_mask

            # Every allowed support must meet both coefficient blocks.
            choices = []
            for label, group in (("H_NONEMPTY", self.hmask), ("K_NONEMPTY", self.kmask)):
                if true_mask & group:
                    continue
                available = group & ~false_mask
                if not available:
                    self.contradictions[label] += 1
                    return None
                bits = tuple(1 << j for j in range(self.nvars) if available >> j & 1)
                choices.append((len(bits), label, bits, "TRUE_BITS"))

            # Inspect the exact 0-or-at-least-2 condition row by row.
            for row_index, row in enumerate(self.rows):
                possible = []
                active_count = 0
                for monomial_mask in row:
                    if monomial_mask & false_mask:
                        continue
                    possible.append(monomial_mask)
                    if not monomial_mask & ~true_mask:
                        active_count += 1
                        if active_count >= 2:
                            break
                if active_count >= 2 or not possible:
                    continue
                if active_count == 1:
                    candidates = [
                        m for m in possible if m & ~true_mask
                    ]
                    if not candidates:
                        self.contradictions["FORCED_SINGLETON"] += 1
                        return None
                    # If candidate support m contains candidate support n, then
                    # activating m also activates n.  Inclusion-minimal masks
                    # therefore give a complete (usually smaller) disjunction.
                    candidates = sorted(set(candidates), key=lambda m: (m.bit_count(), m))
                    minimal = []
                    for m in candidates:
                        if not any(n & m == n for n in minimal):
                            minimal.append(m)
                    forces = tuple(m & ~true_mask for m in minimal)
                    choices.append((len(forces), f"ROW_ACTIVE_{row_index}", forces, "TRUE_MASKS"))
                else:
                    # If exactly one coefficient monomial can still activate,
                    # it must be killed by setting at least one missing variable
                    # false.  Branching over those variables is exhaustive.
                    if len(possible) == 1:
                        missing = possible[0] & ~true_mask
                        assert missing
                        bits = tuple(
                            1 << j for j in range(self.nvars) if missing >> j & 1
                        )
                        choices.append((len(bits), f"ROW_LONE_{row_index}", bits, "FALSE_BITS"))

            if not choices:
                # Setting every remaining variable false produces a valid
                # support, so this is an exact SAT witness.
                return true_mask

            # Choose the smallest exact disjunction, with deterministic ties.
            _, label, branches, kind = min(choices, key=lambda item: (item[0], item[1]))
            self.branch_kinds[kind] += 1
            for forced in branches:
                if kind in ("TRUE_BITS", "TRUE_MASKS"):
                    if forced & false_mask:
                        continue
                    witness = visit(true_mask | forced, false_mask)
                else:
                    if forced & true_mask:
                        continue
                    witness = visit(true_mask, false_mask | forced)
                if witness is not None:
                    return witness
            return None

        witness = visit(0, 0)
        info = visit.cache_info()
        self.cache_hits = info.hits
        return witness, info.currsize


def support_is_valid(rows, hdim, kdim, support_mask):
    hmask = (1 << hdim) - 1
    kmask = ((1 << (hdim + kdim)) - 1) ^ hmask
    if not support_mask & hmask or not support_mask & kmask:
        return False
    for row in rows:
        active = sum(1 for m in row if m & support_mask == m)
        if active == 1:
            return False
    return True


def main():
    family_records = []
    for d in range(1, 5):
        for r in range(1, 5):
            basis_h, basis_k, all_rows, rows, digest = landing_rows(d, r)
            search = ExactSupportSearch(rows, len(basis_h), len(basis_k))
            witness, cached_states = search.solve()
            if witness is not None:
                assert support_is_valid(rows, len(basis_h), len(basis_k), witness)
                raise AssertionError(
                    f"support survivor for {(d, r)}: mask={witness}"
                )
            record = (
                d,
                r,
                len(basis_h),
                len(basis_k),
                len(all_rows),
                len(rows),
                search.nodes,
                search.cache_hits,
                cached_states,
                search.max_depth,
                digest,
            )
            family_records.append(record)
            print(
                "FAMILY", (d, r),
                "DIMS", (len(basis_h), len(basis_k)),
                "ROWS", (len(all_rows), len(rows)),
                "NODES", search.nodes,
                "CACHE_HITS", search.cache_hits,
                "MAX_DEPTH", search.max_depth,
                "UNSAT",
            )

    certificate_digest = sha256(repr(family_records).encode()).hexdigest()
    assert certificate_digest == EXPECTED_FAMILY_RECORD_SHA256
    print("FAMILY_RECORD_SHA256", certificate_digest)
    print("F55-CHAR5-PROGRESSION-DEGREE35-SUPPORT-UNSAT-EXACT")
    print("F55-CHAR5-PROGRESSION-DEGREE35-LANDING-EMPTY")


if __name__ == "__main__":
    main()
