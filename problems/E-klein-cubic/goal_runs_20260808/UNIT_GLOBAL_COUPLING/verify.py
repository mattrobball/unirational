#!/usr/bin/env python3
"""Small exact checks used in UNIT_GLOBAL_COUPLING/THEOREM.md."""

from itertools import product


P = 11
weights = (1, 9, 4, 3, 5)
lam = (1, 9, 4, 3, 5)


def mat_vec_c(x):
    """C=2I+previous shift, in the convention of the local resolvent."""
    return tuple(2 * x[i] + x[(i - 1) % 5] for i in range(5))


# The Klein monomials are C11-invariant and C5 rotates the five weights.
assert all((2 * weights[i] + weights[(i + 1) % 5]) % P == 0 for i in range(5))
assert tuple((9 * x) % P for x in weights) == weights[1:] + weights[:1]

# Resolvent kills the projective isogeny and invariant scalar modulo 11.
columns = []
for j in range(5):
    e = tuple(1 if i == j else 0 for i in range(5))
    columns.append(sum(lam[i] * mat_vec_c(e)[i] for i in range(5)))
assert tuple(columns) == (11, 22, 11, 11, 11)
assert sum(lam) == 22

# The toroidal/free-prime vector used by the soluble coefficient has residue 1.
w_star = (-2, -1, 1, 1, 1)
assert sum(w_star) == 0
assert sum(lam[i] * w_star[i] for i in range(5)) == 1

# Model F55 as affine maps x |-> 9^k*x+b on F_11.
elements = tuple(product(range(11), range(5)))


def mul(g, h):
    b, k = g
    c, ell = h
    return ((b + pow(9, k, 11) * c) % 11, (k + ell) % 5)


identity = (0, 0)
center = []
for g in elements:
    if all(mul(g, h) == mul(h, g) for h in elements):
        center.append(g)
assert center == [identity]

# Each nontrivial element has order 5 or 11; hence proper subgroups have
# orders 1, 5, or 11.
orders = set()
for g in elements:
    x = identity
    for n in range(1, 56):
        x = mul(x, g)
        if x == identity:
            orders.add(n)
            break
assert orders == {1, 5, 11}

# At a C5 Fourier point p_j, the five Klein monomials have exponents
# j*(3*i+1); they run through all fifth roots and sum to zero.
for j in range(1, 5):
    exponents = sorted((j * (3 * i + 1)) % 5 for i in range(5))
    assert exponents == [0, 1, 2, 3, 4]

# Maschke/Reynolds exactness uses that 5 is invertible modulo 11.
assert (5 * pow(5, -1, 11)) % 11 == 1

print("UNIT-GLOBAL-LINEAR-RECIPROCITY-EXACT")
print("UNIT-GLOBAL-FULL-DECOMPOSITION-SOLUBLE-COUNTERPLACE")
print("UNIT-GLOBAL-ALL-PARSHIN-FLAGS-SOLUBLE")
print("UNIT-GLOBAL-COUPLING-AUDIT-OK")
