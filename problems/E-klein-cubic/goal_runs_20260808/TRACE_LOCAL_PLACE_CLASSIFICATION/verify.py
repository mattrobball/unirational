#!/usr/bin/env python3
"""Finite checks for the analytic local-place classification."""

from itertools import product


def mul(g, h):
    """F55 as pairs (a,b): tau^a sigma^b, sigma*tau*sigma^-1=tau^5."""
    a, b = g
    c, d = h
    return ((a + pow(5, b, 11) * c) % 11, (b + d) % 5)


H = list(product(range(11), range(5)))
one = (0, 0)
tau = (1, 0)
sigma = (0, 1)

assert mul(tau, one) == tau == mul(one, tau)
assert mul(sigma, sigma) != one


def centralizer(g):
    return [h for h in H if mul(g, h) == mul(h, g)]


assert len(centralizer(tau)) == 11
assert len(centralizer(sigma)) == 5

# The four nontrivial Fourier eigenpoints lie on the Klein cubic: the five
# exponents in F(p_j) are j*(3*i+1), whose multiplicities mod 5 cancel.
for j in range(1, 5):
    counts = [0] * 5
    for i in range(5):
        counts[(j * (3 * i + 1)) % 5] += 1
    assert counts == [1, 1, 1, 1, 1]

# The only cyclically fixed cocharacter with coordinate sum zero is zero.
for n in product(range(-3, 4), repeat=5):
    if sum(n) == 0 and all(n[i] == n[(i + 1) % 5] for i in range(5)):
        assert n == (0, 0, 0, 0, 0)

# Kummer compatibility at an invariant valuation:
# v(sigma(b))=v(b) and sigma(b)=r2^-11*b^-2 give 3*v(b)=-11*v(r2).
for vr2 in range(-30, 31):
    for vb in range(-110, 111):
        if 3 * vb == -11 * vr2:
            assert vb % 11 == 0
            assert vr2 % 3 == 0

print("F55-TRACE-LOCAL-PLACE-CLASSIFICATION-OK")
