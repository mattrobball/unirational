#!/usr/bin/env python3
"""Exact finite residue check for CHAR5_MINIMAL_REDUCTION.md, Lemma 6.1.

This uses only tuples and integer arithmetic modulo five.  It does not
enumerate polynomial degrees, monomials, or coefficients.
"""

from collections import Counter
from itertools import product

P = 5
ONE = (1, 1, 1, 1, 1)
V = (0, 1, 2, 3, 4)


def add(*vectors):
    return tuple(sum(v[j] for v in vectors) % P for j in range(5))


def scale(c, vector):
    return tuple(c * z % P for z in vector)


def rho(vector, power=1):
    power %= 5
    return tuple(vector[(j - power) % 5] for j in range(5))


def buckets(a, delta):
    rd = rho(delta)
    c = add(scale(2, a), rho(a))
    offsets = (
        (0, 0, 0, 0, 0),
        rd,
        delta,
        add(delta, rd),
        scale(2, delta),
        add(scale(2, delta), rd),
    )
    return Counter(rho(add(c, offset), i)
                   for i in range(5) for offset in offsets)


all_a = ((0,) + tail for tail in product(range(P), repeat=4))
all_delta = []
for head in product(range(P), repeat=4):
    delta = head + ((-sum(head)) % P,)
    if any(delta):
        all_delta.append(delta)
assert len(all_delta) == 624

survivors = set()
patterns = Counter()
for a in all_a:
    for delta in all_delta:
        counts = buckets(a, delta)
        if min(counts.values()) >= 2:
            survivors.add((a, delta))
            patterns[tuple(sorted(counts.values()))] += 1

expected = {
    (scale(d, V), scale(r, ONE))
    for d in range(P) for r in range(1, P)
}
assert survivors == expected
assert patterns == Counter({(6, 6, 6, 6, 6): 16,
                            (5, 5, 10, 10): 4})

print("PAIR_COUNT=390000")
print("SURVIVOR_COUNT=20")
print("D0_BUCKET_PATTERN=5,5,10,10")
print("DNONZERO_BUCKET_PATTERN=6,6,6,6,6")
print("F55-CHAR5-TWO-FROBENIUS-RESIDUE-CLASSIFICATION-OK")
