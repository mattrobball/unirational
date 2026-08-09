#!/usr/bin/env python3
"""Dependency-free checker for the root-degree-seven support certificate.

The checker reconstructs every coefficient row of the characteristic-five
Klein landing identity.  It then checks a static semantic-DPLL proof.  Each
forced literal carries either its nonzero-group justification or the exact
target-row index that forces it; each leaf carries an exact conflicting group
or row.  No stored SAT/CAS status is trusted.
"""

from __future__ import annotations

from collections import Counter, defaultdict
from itertools import combinations_with_replacement
from pathlib import Path


P = 5
W = (1, 9, 4, 3, 5)
ROOT_DEGREE = 7
PROOF = Path(__file__).with_name("proof.bin")


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
    """Reconstruct canonically ordered Boolean-support rows over F_5."""
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
    for target, polynomial in sorted(equations.items()):
        terms = []
        for monomial, coefficient in polynomial.items():
            if coefficient == 0:
                continue
            mask = 0
            for variable in set(monomial):
                mask |= 1 << variable
            terms.append(mask)
        if terms:
            rows.append((target, tuple(terms)))
    return basis_h, basis_k, tuple(rows)


class Reader:
    def __init__(self, data: bytes):
        self.data = data
        self.position = 0

    def take(self) -> int:
        assert self.position < len(self.data), "truncated certificate"
        value = self.data[self.position]
        self.position += 1
        return value

    def u16(self) -> int:
        return self.take() | self.take() << 8

    def u64(self) -> int:
        value = 0
        for shift in range(0, 64, 8):
            value |= self.take() << shift
        return value


class Checker:
    def __init__(self, n_h, n_k, rows, reader):
        self.n_h = n_h
        self.n_k = n_k
        self.n = n_h + n_k
        self.all_mask = (1 << self.n) - 1
        self.h_mask = (1 << n_h) - 1
        self.k_mask = self.all_mask ^ self.h_mask
        self.rows = tuple(row for _, row in rows)
        self.reader = reader
        self.nodes = 0
        self.leaves = 0
        self.opcodes = Counter()

    def analyze(self, row_id, true_mask, false_mask):
        assert 0 <= row_id < len(self.rows), "row index outside reconstruction"
        active = 0
        possible = 0
        common = self.all_mask
        only = 0
        for support in self.rows[row_id]:
            if support & false_mask:
                continue
            possible += 1
            if support & ~true_mask == 0:
                active += 1
            else:
                common &= support
                only = support
        return active, possible, common, only

    def tree(self, true_mask=0, false_mask=0):
        self.nodes += 1
        assert not true_mask & false_mask
        while True:
            opcode = self.reader.take()
            self.opcodes[opcode] += 1
            unknown = self.all_mask ^ (true_mask | false_mask)

            if opcode == 1:
                group_id = self.reader.take()
                variable = self.reader.take()
                assert group_id in (0, 1)
                assert 0 <= variable < self.n
                group = self.h_mask if group_id == 0 else self.k_mask
                candidates = unknown & group
                assert true_mask & group == 0
                assert candidates and candidates & (candidates - 1) == 0
                assert candidates == 1 << variable
                true_mask |= candidates
                continue

            if opcode == 2:
                row_id = self.reader.u16()
                claimed = self.reader.u64()
                active, possible, common, _ = self.analyze(
                    row_id, true_mask, false_mask
                )
                forced = common & unknown
                assert active == 1 and possible > 1
                assert claimed == forced and forced
                true_mask |= forced
                continue

            if opcode == 3:
                row_id = self.reader.u16()
                variable = self.reader.take()
                assert 0 <= variable < self.n
                active, possible, _, only = self.analyze(
                    row_id, true_mask, false_mask
                )
                kill = only & unknown
                assert active == 0 and possible == 1
                assert kill and kill & (kill - 1) == 0
                assert kill == 1 << variable
                false_mask |= kill
                continue

            if opcode == 4:
                group_id = self.reader.take()
                assert group_id in (0, 1)
                group = self.h_mask if group_id == 0 else self.k_mask
                assert true_mask & group == 0
                assert unknown & group == 0
                self.leaves += 1
                return

            if opcode == 5:
                row_id = self.reader.u16()
                active, possible, _, _ = self.analyze(
                    row_id, true_mask, false_mask
                )
                assert active == 1 and possible == 1
                self.leaves += 1
                return

            if opcode == 7:
                variable = self.reader.take()
                assert 0 <= variable < self.n
                bit = 1 << variable
                assert bit & unknown, "branch variable is already forced"
                self.tree(true_mask, false_mask | bit)
                self.tree(true_mask | bit, false_mask)
                return

            raise AssertionError(f"unknown proof opcode {opcode}")


def main():
    reader = Reader(PROOF.read_bytes())
    assert bytes(reader.take() for _ in range(4)) == b"N7P1"
    total_nodes = 0
    total_leaves = 0
    total_ops = Counter()
    for wanted_d in range(1, 5):
        for wanted_r in range(1, 5):
            d = reader.take()
            r = reader.take()
            stored_h = reader.take()
            stored_k = reader.take()
            assert (d, r) == (wanted_d, wanted_r)
            basis_h, basis_k, rows = landing_system(d, r)
            assert (stored_h, stored_k) == (len(basis_h), len(basis_k))
            checker = Checker(len(basis_h), len(basis_k), rows, reader)
            checker.tree()
            total_nodes += checker.nodes
            total_leaves += checker.leaves
            total_ops.update(checker.opcodes)
            assert checker.nodes == 2 * checker.leaves - 1
            print(
                f"CASE {d} {r} VARS {checker.n} ROWS {len(rows)} "
                f"BRANCH_NODES {checker.leaves - 1} "
                f"CONFLICT_LEAVES {checker.leaves} UNSAT"
            )
    assert reader.take() == 255
    assert reader.position == len(reader.data), "trailing certificate bytes"
    print(f"TOTAL_NODES {total_nodes} TOTAL_CONFLICT_LEAVES {total_leaves}")
    print("OPCODE_COUNTS", dict(sorted(total_ops.items())))
    print("F55-CHAR5-DEGREE45-SUPPORT-UNSAT-CERTIFICATE-OK")


if __name__ == "__main__":
    main()
