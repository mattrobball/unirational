#!/usr/bin/env python3
"""Invariant and covariant multiplicities for PSL(2,11) on the Weil 5-dim W.

Exact arithmetic in Q(sqrt(-11)) via the power-sum (Newton) recurrence:
d*h_d = sum_{k=1..d} p_k h_{d-k}, with p_k(class c) = chi_W(g_c^k) read off
the power maps. No external dependencies.

  I(d) = mult of the trivial rep in Sym^d W
  A(d) = mult of W  in Sym^d W   (= dim of the self-covariant space by
         conjugation symmetry; anchors: sealed dims of M_d)
  J(d) = mult of W* in Sym^d W   (the polar ladder)

Anchors (must all pass): I(3)=1, I(1)=I(2)=0; A(3)=0, A(4)=2, A(5)=1,
A(25)=189, A(34)=576; J(2)=1, J(4)=1.
"""
from fractions import Fraction as Fr

DMAX = 126


class Q11:  # a + b*sqrt(-11), a, b rational
    __slots__ = ("a", "b")

    def __init__(self, a, b=0):
        self.a, self.b = Fr(a), Fr(b)

    def __add__(s, o):
        return Q11(s.a + o.a, s.b + o.b)

    def __mul__(s, o):
        return Q11(s.a * o.a - 11 * s.b * o.b, s.a * o.b + s.b * o.a)

    def conj(s):
        return Q11(s.a, -s.b)

    def scal(s, r):
        return Q11(s.a * r, s.b * r)


LAM = Q11(Fr(-1, 2), Fr(1, 2))   # (-1+sqrt(-11))/2 = chi_W(11A)
LBR = LAM.conj()
QR11 = {1, 3, 4, 5, 9}

# class order: 1A 2A 3A 5A 5B 6A 11A 11B
SIZES = [1, 55, 110, 132, 132, 110, 60, 60]
CHI_W = [Q11(5), Q11(1), Q11(-1), Q11(0), Q11(0), Q11(1), LAM, LBR]


def power_sum(ci, k):
    """p_k on class ci = chi_W(g^k), by the power maps."""
    if ci == 0:
        return Q11(5)
    if ci == 1:                          # order 2
        return Q11(5) if k % 2 == 0 else Q11(1)
    if ci == 2:                          # order 3
        return Q11(5) if k % 3 == 0 else Q11(-1)
    if ci in (3, 4):                     # order 5 (both classes: chi = 0)
        return Q11(5) if k % 5 == 0 else Q11(0)
    if ci == 5:                          # order 6
        r = k % 6
        return [Q11(5), Q11(1), Q11(-1), Q11(1), Q11(-1), Q11(1)][r]
    # order 11: g^k in same class iff k is a QR mod 11
    r = k % 11
    if r == 0:
        return Q11(5)
    same = (r in QR11)
    if ci == 6:
        return LAM if same else LBR
    return LBR if same else LAM


def h_series(ci):
    h = [Q11(1)]
    for d in range(1, DMAX + 1):
        acc = Q11(0)
        for k in range(1, d + 1):
            acc = acc + power_sum(ci, k) * h[d - k]
        h.append(acc.scal(Fr(1, d)))
    return h


H = [h_series(ci) for ci in range(8)]


def mult(d, weight):
    acc = Q11(0)
    for ci in range(8):
        acc = acc + (H[ci][d] * weight[ci]).scal(SIZES[ci])
    acc = acc.scal(Fr(1, 660))
    assert acc.b == 0, (d, "irrational")
    assert acc.a.denominator == 1, (d, "non-integer", acc.a)
    return int(acc.a)


TRIV = [Q11(1)] * 8
W_CONJ = [c.conj() for c in CHI_W]

I = [mult(d, TRIV) for d in range(DMAX + 1)]
A = [mult(d, W_CONJ) for d in range(DMAX + 1)]
J = [mult(d, CHI_W) for d in range(DMAX + 1)]

anchors = {
    "I(1)=0": I[1] == 0, "I(2)=0": I[2] == 0, "I(3)=1": I[3] == 1,
    "A(3)=0": A[3] == 0, "A(4)=2": A[4] == 2, "A(5)=1": A[5] == 1,
    "A(25)=189": A[25] == 189, "A(34)=576": A[34] == 576,
    "J(2)=1": J[2] == 1, "J(4)=1": J[4] == 1,
}
print(" d :  I    A    J")
for d in range(DMAX + 1):
    print(f"{d:3d}: {I[d]:4d} {A[d]:4d} {J[d]:4d}")
E = [d for d in range(1, DMAX + 1) if I[d] > 0]
print("\nE (invariant degrees, 1..40):", E)
cop = [e for e in E if e % 3 != 0]
print("elements of E coprime to 3:", cop[:8], "... first =",
      cop[0] if cop else "NONE")
print("4 in E:", 4 in E, "| 5 in E:", 5 in E, "| 11 in E:", 11 in E)
print("\nanchors:", "ALL PASS" if all(anchors.values()) else
      {k: v for k, v in anchors.items() if not v})
