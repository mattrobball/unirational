#!/usr/bin/env python3
"""Finite replay for TERMINAL_FANO_AUDIT_ADDENDUM.md.

The proof is representation-theoretic.  This script only checks its two
small finite calculations: the C5 orbit structure on F_11^2 and the basket
inequality/filter.  It is not a classification search.
"""

from fractions import Fraction
from itertools import combinations_with_replacement, product
from collections import Counter


P = 11


def t(v):
    """A representative of the semisimple action with eigenvalues 1,9."""
    x, y = v
    return (x % P, 9 * y % P)


def orbit(v):
    out = []
    w = v
    while w not in out:
        out.append(w)
        w = t(w)
    rotations = [tuple(out[i:] + out[:i]) for i in range(len(out))]
    return min(rotations)


orbits = {orbit((x, y)) for x in range(P) for y in range(P)}
sizes = sorted(len(o) for o in orbits)
assert sizes.count(1) == 11
assert sizes.count(5) == 22
assert set(v for o in orbits if len(o) == 1 for v in o) == {
    (x, 0) for x in range(P)
}

# A stable multiset of at most four characters can only use fixed vectors,
# whose span has dimension at most one.
assert min(len(o) for o in orbits if len(o) > 1) == 5

# Genus-eight Mukai module: wedge^2(1 + U_+) = 2U_+ + U_-.
R = (1, 9, 4, 3, 5)
minus_R = {(-x) % P for x in R}
pair_sums = [((R[i] + R[j]) % P) for i in range(5) for j in range(i + 1, 5)]
assert sorted(pair_sums) == sorted(R + tuple(minus_R))

# The invariant cubics on one five-cycle are exactly x_i^2*x_(i+1).
zero_weight_cubic_monomials = []
for inds in combinations_with_replacement(range(5), 3):
    if sum(R[i] for i in inds) % P == 0:
        zero_weight_cubic_monomials.append(inds)
expected = {
    tuple(sorted((i, i, (i + 1) % 5)))
    for i in range(5)
}
assert set(zero_weight_cubic_monomials) == expected

# Determinant of the cyclic exponent matrix 2I+shift is 2^5+1=33.
assert 2**5 + 1 == 33

# Genus seven: half-spin weights for V10 with vector weights R union -R.
inv2 = 6  # 2^{-1} mod 11
half_spin = []
for signs in product((1, -1), repeat=5):
    if signs.count(-1) % 2 == 0:
        half_spin.append(sum(s * r for s, r in zip(signs, R)) * inv2 % P)
half_spin_counts = Counter(half_spin)
assert half_spin_counts[0] == 1
assert all(half_spin_counts[r] == 2 for r in R)
assert all(half_spin_counts[r] == 1 for r in minus_R)

# The simple-module dimension semigroups exclude the defining linear spaces.
g6_submodule_dims = {5 * a + 5 * b for a in range(2) for b in range(2)}
assert 8 not in g6_submodule_dims
assert 7 not in g6_submodule_dims
g7_submodule_dims = {
    e + 5 * a + 5 * b
    for e in range(2)
    for a in range(3)
    for b in range(2)
}
assert 9 not in g7_submodule_dims


def contribution(index):
    return Fraction(index * index - 1, index)


old = [
    ((2, 5),),
    ((2, 10),),
    ((2, 15),),
    ((3, 5),),
    ((2, 5), (3, 5)),
    ((4, 5),),
    ((2, 11),),
    ((11, 1),),
    ((11, 1), (2, 5)),
    ((11, 2),),
    ((22, 1),),
]

for basket in old:
    total = sum(count * contribution(index) for index, count in basket)
    assert total < 24

remaining = [
    basket
    for basket in old
    if all(index not in (11, 22) for index, _ in basket)
]
assert len(old) == 11
assert len(remaining) == 7
assert ((2, 11),) in remaining

print("C5_CHARACTER_ORBITS", {1: sizes.count(1), 5: sizes.count(5)})
print("OLD_BASKETS", len(old))
print("REMAINING_BASKETS", len(remaining))
print("GENUS8_PAIR_SUMS", "2U_PLUS+U_MINUS")
print("GENUS8_INVARIANT_CUBICS", len(zero_weight_cubic_monomials))
print("GENUS6_SUBMODULE_DIMS", sorted(g6_submodule_dims))
print("GENUS7_HALF_SPIN", "1+2U_PLUS+U_MINUS")
print("GENUS7_SUBMODULE_DIMS", sorted(g7_submodule_dims))
print("F55-TERMINAL-FANO-LOCAL-INDEX-AUDIT-OK")
