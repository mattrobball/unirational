#!/usr/bin/env python3
"""Exact fixed-line checks for A4, D12, and D10 subgroups.

Uses the exact Q(zeta_11) matrices already certified in
``certificates/exact_weil_check.py``.  For A4 we adjoin a root w of
w^2+w+1; no floating-point decisions enter the assertions.
"""

from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import exact_weil_check as ew


def mul(a, b):
    return ew.fcanon(ew.fmul(a, b))


def inv(a):
    aa, b, c, d = a
    return ew.fcanon((d, -b, -c, aa))


def power(a, n):
    r = ew.fone
    for _ in range(n):
        r = mul(r, a)
    return r


def order(a):
    r = ew.fone
    for n in range(1, 100):
        r = mul(r, a)
        if r == ew.fone:
            return n
    raise AssertionError


keys = list(ew.rho)
orders = {a: order(a) for a in keys}


def cyclic(a):
    return {power(a, i) for i in range(orders[a])}


def conjugate(g, h):
    return mul(mul(g, h), inv(g))


def normalizer(H):
    return {g for g in keys if {conjugate(g, h) for h in H} == H}


def closure(generators):
    H = {ew.fone}
    queue = [ew.fone]
    while queue:
        h = queue.pop()
        for g in generators:
            candidate = mul(h, g)
            if candidate not in H:
                H.add(candidate)
                queue.append(candidate)
    return H


def index_two_overgroups(H):
    """All index-two overgroups, using normality to search in N_G(H)."""

    result = set()
    for g in normalizer(H) - H:
        candidate = closure((*H, g))
        if len(candidate) == 2 * len(H):
            result.add(frozenset(candidate))
    return result


def mv(M, v):
    return [sum(M[i][j] * v[j] for j in range(5)) for i in range(5)]


def vadd(*vectors):
    return [sum(v[i] for v in vectors) for i in range(5)]


def proportional(v, w):
    return all(v[i] * w[j] == v[j] * w[i]
               for i in range(5) for j in range(i + 1, 5))


def klein(v):
    return sum(v[i] * v[i] * v[(i + 1) % 5] for i in range(5))


def trace(M):
    return sum(M[i][i] for i in range(5))


def character_norm(H):
    # sum chi(g) chi(g^-1) / |H|, equal to the usual complex character norm.
    return sum(trace(ew.rho[g]) * trace(ew.rho[inv(g)]) for g in H) / len(H)


# D12 = N(C3).  The C3-invariant line is the image of its averaging
# projector.  It is the unique one-dimensional D12-subrepresentation.
c3gen = mul(ew.fs, ew.ft)
c3 = cyclic(c3gen)
d12 = normalizer(c3)
assert len(c3) == 3 and len(d12) == 12
e0 = [ew.C(i == 0) for i in range(5)]
v_d12 = vadd(*(mv(ew.rho[h], e0) for h in c3))
assert any(x != 0 for x in v_d12)
assert all(proportional(mv(ew.rho[h], v_d12), v_d12) for h in d12)
f_d12 = klein(v_d12)
assert f_d12 != 0


# D10 = N(C5), using the exact cyclic permutation P.  Its unique fixed
# projective line is [1:1:1:1:1], which is not on X since F=5.
pkey = next(k for k, M in ew.rho.items() if M == ew.P)
c5 = cyclic(pkey)
d10 = normalizer(c5)
assert len(c5) == 5 and len(d10) == 10
v_d10 = [ew.C(1) for _ in range(5)]
assert all(proportional(mv(ew.rho[h], v_d10), v_d10) for h in d10)
assert klein(v_d10) == 5


# Exact binary-block chains for the four subgroup-fixed configurations.
# An invariant pairing of G/H is equivalent to an index-two overgroup of H.
c11 = cyclic(ew.ft)
assert index_two_overgroups(c11) == set()
assert index_two_overgroups(c5) == {frozenset(d10)}
assert index_two_overgroups(d10) == set()


# A4 = N(V4).  W|A4 = 1' + 1'' + 3.  Construct the two character lines
# exactly after adjoining w^2+w+1=0.
involutions = [g for g in keys if orders[g] == 2]
v4 = None
for i, left in enumerate(involutions):
    for right in involutions[i + 1:]:
        if mul(left, right) == mul(right, left):
            v4 = {ew.fone, left, right, mul(left, right)}
            break
    if v4 is not None:
        break
assert v4 is not None and len(v4) == 4
a4 = normalizer(v4)
assert len(a4) == 12
assert index_two_overgroups(v4) == set()
r = next(g for g in a4 if orders[g] == 3)
u = vadd(*(mv(ew.rho[h], e0) for h in v4))
if not any(x != 0 for x in u):
    e1 = [ew.C(i == 1) for i in range(5)]
    u = vadd(*(mv(ew.rho[h], e1) for h in v4))
ru = mv(ew.rho[r], u)
r2u = mv(ew.rho[r], ru)


class D:
    """a+b*w with a,b in Q(zeta_11), w^2=-w-1."""
    __slots__ = ("a", "b")

    def __init__(self, a=0, b=0):
        if isinstance(a, D):
            self.a, self.b = a.a, a.b
        else:
            self.a, self.b = ew.C(a), ew.C(b)

    def __add__(self, other):
        other = D(other)
        return D(self.a + other.a, self.b + other.b)

    __radd__ = __add__

    def __neg__(self):
        return D(-self.a, -self.b)

    def __sub__(self, other):
        return self + (-D(other))

    def __mul__(self, other):
        other = D(other)
        return D(self.a * other.a - self.b * other.b,
                 self.a * other.b + self.b * other.a - self.b * other.b)

    __rmul__ = __mul__

    def __eq__(self, other):
        other = D(other)
        return self.a == other.a and self.b == other.b

    def __repr__(self):
        return f"D({self.a!r}, {self.b!r})"


# w^2 = -1-w.  Projectors for eigenvalues w and w^2 respectively.
v_w = [D(u[i]) + D(-ru[i], -ru[i]) + D(0, r2u[i]) for i in range(5)]
v_w2 = [D(u[i]) + D(0, ru[i]) + D(-r2u[i], -r2u[i]) for i in range(5)]
assert any(x != 0 for x in v_w) and any(x != 0 for x in v_w2)
f_a4_w = klein(v_w)
f_a4_w2 = klein(v_w2)
assert f_a4_w != 0 and f_a4_w2 != 0


def dihedral_linear_multiplicities(H, rotation):
    R = cyclic(rotation)
    reflection = next(g for g in H if g not in R and orders[g] == 2)
    n = orders[rotation]
    positions = {power(rotation, i): (0, i) for i in range(n)}
    positions.update({mul(reflection, power(rotation, i)): (1, i)
                      for i in range(n)})
    assert set(positions) == H
    possibilities = ((1, 1), (1, -1)) if n % 2 else (
        (1, 1), (1, -1), (-1, 1), (-1, -1))
    multiplicities = []
    for epsilon, delta in possibilities:
        total = ew.C(0)
        for g, (is_reflection, exponent) in positions.items():
            value = (delta if is_reflection else 1) * epsilon**exponent
            total += trace(ew.rho[g]) * value
        multiplicity = total / len(H)
        assert all(q.denominator == 1 for q in multiplicity.a)
        multiplicities.append(multiplicity.a[0])
    return tuple(multiplicities)


r6 = next(g for g in d12 if orders[g] == 6)
assert dihedral_linear_multiplicities(d12, r6).count(1) == 1
assert dihedral_linear_multiplicities(d12, r6).count(0) == 3
assert dihedral_linear_multiplicities(d10, pkey).count(1) == 1
assert dihedral_linear_multiplicities(d10, pkey).count(0) == 1


# The other two maximal subgroup types have irreducible restrictions, hence
# no projectively fixed line at all.  Verify irreducibility by exact character
# norm one.  N(C11) is the Frobenius group 11:5.  An A5 is generated by a
# (2,3,5) pair.
frob55 = normalizer(c11)
assert len(frob55) == 55 and character_norm(frob55) == 1
a5 = None
for left in involutions:
    for right in (g for g in keys if orders[g] == 3):
        if orders[mul(left, right)] != 5:
            continue
        candidate = closure((left, right))
        if len(candidate) == 60:
            a5 = candidate
            break
    if a5 is not None:
        break
assert a5 is not None and character_norm(a5) == 1

c6_overgroups = index_two_overgroups(c3)
assert len(c6_overgroups) == 3
assert sorted(max(orders[g] for g in subgroup) for subgroup in c6_overgroups) == [
    3,
    3,
    6,
]
for order_six_subgroup in c6_overgroups:
    assert index_two_overgroups(set(order_six_subgroup)) == {frozenset(d12)}
assert index_two_overgroups(d12) == set()

print("PASS D12 unique character line is off X; F coordinates=", f_d12.a)
print("PASS D10 unique character line is off X; F=5")
print("PASS both A4 character lines are off X")
print("PASS W restricts irreducibly to A5 and 11:5 (exact character norm 1)")
print("PASS exact index-two block chains: C11 none; C5<D10 stops; V4 none; C3 has C6/two S3 choices, all fold to D12 and stop")
print("A4 F(line_w)=", f_a4_w)
print("A4 F(line_w2)=", f_a4_w2)
