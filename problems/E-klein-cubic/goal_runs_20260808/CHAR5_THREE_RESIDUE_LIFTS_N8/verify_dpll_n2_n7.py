#!/usr/bin/env python3
"""Dependency-free exact support obstruction for root degrees two through seven.

The verifier reconstructs every coefficient row over F_5.  A geometric
landing support must meet all three residue blocks and every coefficient row
must contain either zero or at least two active coefficient monomials.  The
binary semantic DPLL below exhausts precisely those Boolean assignments.
"""

from __future__ import annotations

from pathlib import Path
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parent))
import reconstruct as model


EXPECTED = {
    2: ((2, 1, 2), 320, 35,
        "2685af6af23d31eeeed358f89927bed435623e71b7b9696a0b4daa91751dec34",
        "02a5435480bbb553f2b9958dd506b4439d6cd76fb64a4fc42a334b9abc942c26"),
    3: ((3, 3, 3), 1105, 182,
        "ffa632b73c7c7b37c7b16fcca40452801fa068af0121eed74987a55a4c19b6c3",
        "0421f5fe5607eaccfb401cd00d7c8e7201a1dcfd6931aec3d4c3f39061fafe9e"),
    4: ((6, 7, 6), 4155, 798,
        "9898dc2de38bf2fda59b3733669b4993e00e4f1f121dcf8bdcc233ee3b988a0f",
        "5d180e18d3c2eea248b07a1d1bd95e7ba86153b8b283204e8e90d6584712019f"),
    5: ((12, 11, 12), 10595, 2093,
        "94cdd8629e7895272d72e37bc6203770000014c8f392fec61e4386cf032f589d",
        "c8cb6c147fc8f1b3f3e09b07f5487b0bb3459a72051cade0e068c07b2004f523"),
    6: ((19, 19, 19), 20825, 4148,
        "1fb069740e874f5f68339f06c76d3177ee31ebf3624370cfdb0a925a432b82c3",
        "d540ac5b4e442a7959e196f0f72c4aa16ff44ca243e1c305d5d997724e566b2c"),
    7: ((30, 30, 30), 37070, 7394,
        "8da48650e938e57d02da8d7e82c9636a7e018a4af5469a2813bdfb4e7199cf95",
        "48b5391188c19c36814849fcfe4fcf1aedb7b1567a5d5bc1ffe43a5c7716c7d8"),
}


class ExactSearch:
    def __init__(self, rows, groups, nvars):
        self.rows = rows
        self.groups = tuple(sum(1 << j for j in group) for group in groups)
        self.nvars = nvars
        self.all_mask = (1 << nvars) - 1
        self.nodes = 0
        self.leaves = 0
        self.max_depth = 0
        self.unsat_cache = set()
        self.occurrence = [0] * nvars
        for row in rows:
            for term in row:
                support = term
                while support:
                    bit = support & -support
                    self.occurrence[bit.bit_length() - 1] += 1
                    support ^= bit

    def propagate(self, yes, no):
        """Apply only logically forced group and no-singleton consequences."""
        while True:
            if yes & no:
                return None
            changed = False
            unknown = self.all_mask ^ (yes | no)

            # Every residue block must be nonempty.  A sole remaining
            # candidate is therefore forced true; exhaustion is a conflict.
            for group in self.groups:
                if yes & group:
                    continue
                candidates = unknown & group
                if not candidates:
                    return None
                if candidates & (candidates - 1) == 0:
                    yes |= candidates
                    unknown &= ~candidates
                    changed = True

            for row in self.rows:
                active = 0
                possible = 0
                common = self.all_mask
                only = 0
                for term in row:
                    if term & no:
                        continue
                    possible += 1
                    if term & ~yes == 0:
                        active += 1
                        if active >= 2:
                            break
                    else:
                        common &= term
                        only = term
                if active >= 2 or possible == 0:
                    continue
                if active == 1:
                    if possible == 1:
                        return None
                    # At least one inactive possible term must activate.  Any
                    # still-unknown variable common to all of them is forced.
                    forced = common & unknown
                    if forced:
                        yes |= forced
                        unknown &= ~forced
                        changed = True
                elif possible == 1:
                    # The sole possible term must be killed.  If it has only
                    # one unknown factor, that factor is forced false.
                    kill = only & unknown
                    if not kill:
                        return None
                    if kill & (kill - 1) == 0:
                        no |= kill
                        unknown &= ~kill
                        changed = True
            if not changed:
                return yes, no

    def choose(self, yes, no):
        unknown = self.all_mask ^ (yes | no)
        critical = 0
        for row in self.rows:
            active = 0
            candidates = 0
            for term in row:
                if term & no:
                    continue
                if term & ~yes == 0:
                    active += 1
                    if active >= 2:
                        break
                else:
                    candidates |= term & unknown
            if active == 1:
                critical |= candidates
        pool = critical or unknown
        return max(
            (j for j in range(self.nvars) if pool & (1 << j)),
            key=lambda j: (self.occurrence[j], j),
        )

    def solve(self):
        sys.setrecursionlimit(max(1000, 4 * self.nvars))

        def visit(yes, no):
            self.nodes += 1
            state = self.propagate(yes, no)
            if state is None:
                self.leaves += 1
                return None
            yes, no = state
            self.max_depth = max(self.max_depth, (yes | no).bit_count())
            if yes | no == self.all_mask:
                return yes
            if state in self.unsat_cache:
                return None
            variable = self.choose(yes, no)
            bit = 1 << variable
            answer = visit(yes, no | bit)
            if answer is not None:
                return answer
            answer = visit(yes | bit, no)
            if answer is not None:
                return answer
            self.unsat_cache.add(state)
            return None

        return visit(0, 0)


def verify_degree(degree):
    variable_data, groups = model.variables(degree)
    dimensions = tuple(map(len, groups))
    polynomial_rows = model.unordered_expansion(variable_data)
    all_rows, rows = model.support_rows(polynomial_rows)
    polynomial_hash = model.polynomial_digest(polynomial_rows)
    support_hash = model.support_digest(rows)
    expected = EXPECTED[degree]
    assert (
        dimensions,
        len(polynomial_rows),
        len(rows),
        polynomial_hash,
        support_hash,
    ) == expected
    assert len(all_rows) == len(polynomial_rows)

    if degree == 2:
        # Stronger coefficient-level audit of the first lift: every parameter
        # cube is an isolated coefficient equation (in five cyclic sources).
        for variable in range(len(variable_data)):
            cube = ((variable, variable, variable), 1)
            matches = [
                source
                for source, polynomial in polynomial_rows.items()
                if polynomial == (cube,)
            ]
            assert len(matches) == 5

    search = ExactSearch(rows, groups, len(variable_data))
    witness = search.solve()
    assert witness is None
    print(
        "ROOT_DEGREE", degree,
        "ORDINARY_DEGREE", 10 + 5 * degree,
        "DIMS", dimensions,
        "SOURCE_ROWS", len(polynomial_rows),
        "UNIQUE_SUPPORT_ROWS", len(rows),
        "NODES", search.nodes,
        "LEAVES", search.leaves,
        "MAX_DEPTH", search.max_depth,
        "UNSAT",
    )


def main():
    # Root degrees zero and one cannot meet all three required blocks.
    assert tuple(map(len, model.variables(0)[1])) == (0, 0, 0)
    assert tuple(map(len, model.variables(1)[1])) == (0, 1, 0)
    print("ROOT_DEGREES_0_1_THREE_BLOCK_SUPPORT_UNAVAILABLE")
    for degree in range(2, 8):
        verify_degree(degree)
    print("F55-CHAR5-FIXED-THREE-RESIDUE-N2-N7-SUPPORT-UNSAT-EXACT-DPLL")


if __name__ == "__main__":
    main()
