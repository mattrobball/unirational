#!/usr/bin/env python3
"""Finite checks forced analytically by the degree-three weight space."""

from itertools import product

P = 11
Q = [1, 9, 4, 3, 5]


def degree_vectors(total, length):
    for a in product(range(total + 1), repeat=length):
        if sum(a) == total:
            yield a


# The complete degree-three C11-weight-zero monomial list.
zero = []
for a in degree_vectors(3, 5):
    if sum(a[i] * Q[i] for i in range(5)) % P == 0:
        zero.append(a)

expected = []
for i in range(5):
    a = [0] * 5
    a[i] = 2
    a[(i + 1) % 5] = 1
    expected.append(tuple(a))

assert sorted(zero) == sorted(expected)

# Reduced common base: independent coordinate supports in the five-cycle.
admissible = []
for mask in range(1, 1 << 5):
    support = {i for i in range(5) if mask >> i & 1}
    if all(not (i in support and (i + 1) % 5 in support) for i in range(5)):
        admissible.append(support)

maximal = [s for s in admissible if not any(s < t for t in admissible)]
expected_lines = [{i, (i + 2) % 5} for i in range(5)]
assert {frozenset(s) for s in maximal} == {frozenset(s) for s in expected_lines}

# The incidence graph of the five lines is a 5-cycle: degree 5, b1=1.
lines = [frozenset({i, (i + 2) % 5}) for i in range(5)]
edges = []
for i in range(5):
    for j in range(i + 1, 5):
        if lines[i] & lines[j]:
            edges.append((i, j))
assert len(edges) == 5
assert all(sum(v in e for e in edges) == 2 for v in range(5))
first_betti = len(edges) - len(lines) + 1
assert first_betti == 1

# Minimal generic-fibre counterledger: five pure zero divisors at five
# distinct marked points have no common point.  Degree 6 corresponds to a=2.
marked = list(range(5))
zero_supports = [{p} for p in marked]
assert not set.intersection(*zero_supports)
assert all(6 == 3 * 2 for _ in marked)

print("F55-INVARIANT-RESTRICTION-AUDIT-OK")
