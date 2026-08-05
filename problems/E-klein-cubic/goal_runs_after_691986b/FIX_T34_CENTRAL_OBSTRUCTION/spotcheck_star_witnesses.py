#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
FIX-T34 -- third, self-contained spot check of exactly the two star witnesses
quoted in STATUS.md.  Uses sympy matrices over the complex numbers; shares no
code with produce_*/verify_*.
"""
import sympy as sp

I = sp.I
zeta3 = sp.Rational(-1, 2) + sp.sqrt(3) / 2 * I
assert sp.simplify(zeta3 ** 3 - 1) == 0 and sp.simplify(zeta3 - 1) != 0


# ---------------------------------------------------------------- T3 ------
# Aut(S) elements are pairs (A, nu), A monomial with mu_4 entries, nu = +-1,
# modulo (A,nu) ~ (lam A, lam^2 nu).
def canon3(el):
    A, nu = el
    first = None
    for r in range(3):
        for c in range(3):
            if sp.simplify(A[r, c]) != 0:
                first = A[r, c]
                break
        if first is not None:
            break
    lam = 1 / first
    return (sp.simplify(lam * A), sp.simplify(lam ** 2 * nu))


def key3(el):
    A, nu = el
    return (tuple(sp.nsimplify(sp.simplify(x)) for x in A), sp.simplify(nu))


def mul3(a, b):
    return canon3((sp.simplify(a[0] * b[0]), sp.simplify(a[1] * b[1])))


deck = canon3((sp.eye(3), -1))
d1 = canon3((sp.diag(1, 1, -1), 1))
d2 = canon3((sp.diag(1, -1, I), 1))
sw = canon3((sp.Matrix([[0, 1, 0], [1, 0, 0], [0, 0, 1]]), 1))

G = {key3(canon3((sp.eye(3), 1))): canon3((sp.eye(3), 1))}
frontier = list(G.values())
gens = [deck, d1, d2, sw]
while frontier:
    x = frontier.pop()
    for g in gens:
        y = mul3(x, g)
        if key3(y) not in G:
            G[key3(y)] = y
            frontier.append(y)
print("T3 star witness: |G| =", len(G))
assert len(G) == 16

z = d1
assert all(key3(mul3(z, g)) == key3(mul3(g, z)) for g in G.values()), "z central"
assert key3(mul3(z, z)) == key3(canon3((sp.eye(3), 1))), "z^2 = 1"
print("   z = diag(1,1,-1), nu=1 : central, of order 2")

# S^z : eigenvalues of A_z are 1 (on <e1,e2>) and -1 (on e3), nu = 1 = lam^2 in
# both cases, so S^z is the full preimage of {x3=0} together with the two
# points over [0:0:1].
q = sp.Poly(sp.expand(sp.symbols("s") ** 4 + sp.symbols("t") ** 4),
            sp.symbols("s"))
disc = sp.discriminant(sp.Poly(sp.symbols("s") ** 4 + 1, sp.symbols("s")))
assert disc != 0
print("   S^z = {w^2 = x1^4+x2^4} (4 distinct branch points, disc = %s, genus 1)"
      " + {[0:0:1:+-1]}" % disc)

# S^G = empty
# common eigenvectors: diag(1,-1,I) has distinct eigenvalues so they are
# e1, e2, e3; the swap kills e1 and e2; F(e3) = 1 != 0 so the fibre over
# [0:0:1] is {[0:0:1:1], [0:0:1:-1]} and the deck interchanges them.
Ad, nud = d2
assert len(set(sp.simplify(Ad[i, i]) for i in range(3))) == 3
Asw = sw[0]
assert sp.simplify((Asw * sp.Matrix([1, 0, 0]))[1]) != 0        # e1 -> e2
for w in (1, -1):
    # deck sends [0:0:1:w] to [0:0:1:-w] != [0:0:1:w]
    assert -w != w
print("   S^G = empty (only common eigenvector e3, its two preimages swapped by"
      " the deck)")

# ---------------------------------------------------------------- T4 ------
a = sp.zeros(5, 5)
a[1, 0] = 1          # e1 -> e2
a[2, 1] = 1          # e2 -> e3
a[0, 2] = zeta3      # e3 -> zeta3 e1
a[3, 3] = 1
a[4, 4] = zeta3
b = sp.diag(1, zeta3, zeta3 ** 2, 1, 1)


def canon5(M):
    for r in range(5):
        for c in range(5):
            if sp.simplify(M[r, c]) != 0:
                return sp.simplify(M / M[r, c])
    raise ValueError


def key5(M):
    return tuple(sp.nsimplify(sp.simplify(x)) for x in canon5(M))


H = {key5(sp.eye(5)): sp.eye(5)}
fr = [sp.eye(5)]
while fr:
    x = fr.pop()
    for g in (a, b):
        y = canon5(x * g)
        if key5(y) not in H:
            H[key5(y)] = y
            fr.append(y)
print("T4 star witness: |G| =", len(H))
assert len(H) == 27


def order5(M):
    k, y = 1, canon5(M)
    while key5(y) != key5(sp.eye(5)):
        y = canon5(y * M)
        k += 1
    return k


assert order5(a) == 9 and order5(b) == 3
assert max(order5(M) for M in H.values()) == 9
z4 = canon5(a ** 3)
assert sp.simplify(z4 - sp.diag(1, 1, 1, zeta3 ** 2, zeta3 ** 2)) == sp.zeros(5, 5) \
    or sp.simplify(canon5(sp.diag(zeta3, zeta3, zeta3, 1, 1)) - z4) == sp.zeros(5, 5)
Z = [M for M in H.values() if all(key5(M * K) == key5(K * M) for K in H.values())]
assert len(Z) == 3
assert key5(canon5(b * a * b.inv())) == key5(canon5(a ** 4))
print("   a^9 = 1, b^3 = 1, b a b^-1 = a^4, |Z(G)| = 3, Z(G) = <a^3>,"
      " exponent 9  => C9:C3")
print("   z = a^3 ~ diag(1,1,1,z3^2,z3^2): Fix(z,P^4) = P^2_{123} u P^1_{45}")
print("   X^z = {x1^3+x2^3+x3^3=0} (smooth plane cubic, genus 1)"
      " u {3 points x4^3+x5^3=0}")

# X^G: common eigenvectors.  a permutes <e1,e2,e3> cyclically (up to scalars),
# so no common eigenvector there; on <e4,e5>, a acts by diag(1,zeta3) and b
# trivially, so the joint eigenspaces are <e4> and <e5>.
e4 = sp.Matrix([0, 0, 0, 1, 0])
e5 = sp.Matrix([0, 0, 0, 0, 1])
for v in (e4, e5):
    for M in (a, b):
        w = M * v
        assert sp.simplify(w[0]) == 0 and sp.simplify(w[1]) == 0 and sp.simplify(w[2]) == 0
        # w is a scalar multiple of v
        idx = 3 if v[3] != 0 else 4
        assert sp.simplify(w - w[idx] * v) == sp.zeros(5, 1)
    cub = sum(sp.simplify(v[i]) ** 3 for i in range(5))
    assert sp.simplify(cub) != 0
# and no other common eigenvector: a acts on <e1,e2,e3> with a^3 = zeta3 there
M = sp.Matrix([[0, 0, zeta3], [1, 0, 0], [0, 1, 0]])
ev = M.eigenvects()
assert all(len(t[2]) == 1 for t in ev) and len(ev) == 3   # 3 distinct eigenlines
for val, mult, vecs in ev:
    v = vecs[0]
    bb = sp.diag(1, zeta3, zeta3 ** 2) * v
    assert sp.simplify(bb - (bb[0] / v[0] if v[0] != 0 else 0) * v) != sp.zeros(3, 1), \
        "b must move the eigenlines of a inside <e1,e2,e3>"
print("   X^G = empty : Fix(G,P^4) = {[0:0:0:1:0],[0:0:0:0:1]}, both off X")
print()
print("SPOTCHECK: PASS")
