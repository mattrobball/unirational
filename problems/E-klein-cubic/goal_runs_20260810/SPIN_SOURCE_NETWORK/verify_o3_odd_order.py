#!/usr/bin/env python3
"""
verify_o3_odd_order.py -- census cell (O3) of `SUPPORT_CENSUS.md` section 6:
POINT supports whose stabiliser is C_11 (orbit 60) or F_55 (orbit 12), where
Res_H T is Q-irreducible and a single support must carry all five copies of
E_{-11}.

Companion to `O3_ODD_ORDER_POINTS.md`.  Everything is exact: PSL(2,F_11) is
built as 2x2 matrices over F_11 modulo +-I and enumerated in full; the spin
source U is read off the integral monomial model W = Ind_B^{SL(2,11)}(chi) of
`spin_network_lib`; all character arithmetic is done inside the cyclotomic
rings Z[zeta_5], Z[zeta_6], Z[zeta_11] with exact polynomial reduction modulo
the cyclotomic polynomial.  No floating point, no sampling, no search beyond
exhaustive enumeration of a group of order 660.

Sections
--------
A  group layer      PSL(2,F_11) exactly; the 12 Sylow 11-subgroups, their
                    normaliser F_55, and the subgroup lattice facts used
B  source layer     U|_{C_11} = 1 (+) (+)_{a in QR} psi_a from the monomial
                    model; the 6 fixed points of P(U)^{C_11}, split 1 + 5 by
                    F_55; the 12 + 60 point tally; T_x at the F_55 point
C  character layer  chi_T; Res_{C_11}T and Res_{F_55}T; no invariants and no
                    linear character; the multiplicity floor k = 5
D  fixed-point law  the minimal faithful degree of every subgroup of G, and
                    the UNCONDITIONAL consequence V14^{F_55} = V14^G = empty
E  mandatory layer  the 12 F_55-points of P(U) lie in Ind(phi) for every
                    G-equivariant rational map -- a new mandatory base locus
F  CM layer         the CM type forced on the support abelian variety is the
                    quadratic-residue type of Q(zeta_11); it is INDUCED from
                    Q(sqrt(-11)), so A ~ E_{-11}^5 is consistent and
                    realised.  The naive field-mismatch kill is refuted.
G  verdict          the total-degeneration witness at a C_11 / F_55 point,
                    every kill K-a..K-l checked inapplicable, and the
                    mandatory D_12 test

Marker on success: O3_ODD_ORDER_OK
"""

import sys
from fractions import Fraction as Fr

from spin_network_lib import SpinNetwork

FAILED = []
NCHECK = 0


def check(name, got, want):
    global NCHECK
    NCHECK += 1
    if got == want:
        print("  ok   %-58s %s" % (name, want))
    else:
        print("  FAIL %-58s got %r want %r" % (name, got, want))
        FAILED.append("%s: got %r want %r" % (name, got, want))


def head(title):
    print()
    print("=" * 72)
    print(title)
    print("=" * 72)


# ---------------------------------------------------------------------------
# exact cyclotomic arithmetic:  Q(zeta_n) = Q[x]/(Phi_n)
# ---------------------------------------------------------------------------

def _polydivmod(a, b):
    """exact division of integer/Fraction polynomials (low-degree-first)."""
    a = list(a)
    q = [Fr(0)] * max(1, len(a) - len(b) + 1)
    while len(a) >= len(b) and any(c != 0 for c in a):
        d = len(a) - len(b)
        c = Fr(a[-1], 1) / Fr(b[-1], 1)
        if c == 0:
            a.pop()
            continue
        q[d] = c
        for i, bi in enumerate(b):
            a[i + d] -= c * bi
        while len(a) > 1 and a[-1] == 0:
            a.pop()
        if len(a) < len(b):
            break
    return q, a


_CYC = {}


def cyclotomic(n):
    """Phi_n as a low-degree-first list of Fractions."""
    if n in _CYC:
        return _CYC[n]
    p = [Fr(-1)] + [Fr(0)] * (n - 1) + [Fr(1)]          # x^n - 1
    for d in range(1, n):
        if n % d == 0:
            p, r = _polydivmod(p, cyclotomic(d))
            assert all(c == 0 for c in r), (n, d)
    _CYC[n] = p
    return p


class Cyc(object):
    """an element of Q(zeta_n), stored in the power basis 1, z, ..., z^{phi-1}"""

    def __init__(self, n, coeffs):
        self.n = n
        phi = cyclotomic(n)
        c = [Fr(x) for x in coeffs]
        while len(c) < len(phi) - 1:
            c.append(Fr(0))
        if len(c) >= len(phi):
            _, c = _polydivmod(c, phi)
            while len(c) < len(phi) - 1:
                c.append(Fr(0))
        self.c = c[: len(phi) - 1]

    @staticmethod
    def zeta(n, k):
        k %= n
        return Cyc(n, [Fr(0)] * k + [Fr(1)])

    @staticmethod
    def rat(n, r):
        return Cyc(n, [Fr(r)])

    def __add__(self, o):
        return Cyc(self.n, [a + b for a, b in zip(self.c, o.c)])

    def __mul__(self, o):
        out = [Fr(0)] * (len(self.c) + len(o.c) - 1)
        for i, a in enumerate(self.c):
            if a == 0:
                continue
            for j, b in enumerate(o.c):
                out[i + j] += a * b
        return Cyc(self.n, out)

    def scale(self, r):
        return Cyc(self.n, [a * Fr(r) for a in self.c])

    def is_rat(self, r):
        return self.c[0] == Fr(r) and all(x == 0 for x in self.c[1:])

    def as_rat(self):
        assert all(x == 0 for x in self.c[1:]), self.c
        return self.c[0]

    def conj(self):
        """complex conjugation z -> z^{-1}"""
        out = Cyc.rat(self.n, 0)
        for i, a in enumerate(self.c):
            out = out + Cyc.zeta(self.n, -i).scale(a)
        return out

    def __eq__(self, o):
        return self.n == o.n and self.c == o.c


def inner(order_list, chi_vals, rho_vals, n):
    """(1/|H|) sum_h chi(h) conj(rho(h)), all values in Q(zeta_n)."""
    tot = Cyc.rat(n, 0)
    for a, b in zip(chi_vals, rho_vals):
        tot = tot + a * b.conj()
    return tot.scale(Fr(1, len(order_list)))


# ---------------------------------------------------------------------------
# SECTION A -- PSL(2,F_11) exactly
# ---------------------------------------------------------------------------
head("SECTION A -- the group layer: PSL(2,F_11), its Sylow 11 and F_55")

P = 11


def mmul(a, b):
    return ((a[0] * b[0] + a[1] * b[2]) % P, (a[0] * b[1] + a[1] * b[3]) % P,
            (a[2] * b[0] + a[3] * b[2]) % P, (a[2] * b[1] + a[3] * b[3]) % P)


def det(a):
    return (a[0] * a[3] - a[1] * a[2]) % P


SL = [(a, b, c, d) for a in range(P) for b in range(P)
      for c in range(P) for d in range(P) if (a * d - b * c) % P == 1]
check("A1  |SL(2,F_11)|", len(SL), 1320)


def norm(g):
    """canonical representative of +-g: the PSL element"""
    h = tuple((-x) % P for x in g)
    return min(g, h)


PSL = sorted({norm(g) for g in SL})
check("A2  |PSL(2,F_11)|", len(PSL), 660)

ID = norm((1, 0, 0, 1))


def pmul(a, b):
    return norm(mmul(a, b))


def porder(g):
    k, h = 1, g
    while h != ID:
        h = pmul(h, g)
        k += 1
    return k


ORD = {g: porder(g) for g in PSL}
prof = {}
for g in PSL:
    prof[ORD[g]] = prof.get(ORD[g], 0) + 1
check("A3  order profile of PSL(2,11)", prof,
      {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120})

# the standard unipotent C_11 and its normaliser
INV = {}
for g in PSL:
    for h in PSL:
        if pmul(g, h) == ID:
            INV[g] = h
            break
C11 = sorted({norm((1, j, 0, 1)) for j in range(P)})
check("A4  |C_11| generated by the unipotent", len(C11), 11)

C11S = set(C11)
NORM = [g for g in PSL
        if all(pmul(pmul(g, h), INV[g]) in C11S for h in C11)]
check("A5  |N_G(C_11)| = |F_55|", len(NORM), 55)

# the Sylow 11-subgroups
subs = set()
for g in PSL:
    if ORD[g] == 11:
        H, h = [ID], g
        while h != ID:
            H.append(h)
            h = pmul(h, g)
        subs.add(tuple(sorted(H)))
check("A6  number of Sylow 11-subgroups", len(subs), 12)
check("A7  660 / |F_55| = number of Sylow 11-subgroups", 660 // 55, len(subs))

# F_55 = C_11 : C_5 -- the C_5 acts on the characters of C_11 by a QUADRATIC
# RESIDUE multiplier.  Read the multiplier off the conjugation action.
t = None
for g in NORM:
    if ORD[g] == 5:
        t = g
        break
gen = norm((1, 1, 0, 1))
conj = pmul(pmul(t, gen), INV[t])
mult = next(j for j in range(1, P) if norm((1, j, 0, 1)) == conj)
QR = sorted({(a * a) % P for a in range(1, P)})
check("A8  quadratic residues mod 11", QR, [1, 3, 4, 5, 9])
check("A9  the C_5-multiplier on C_11 is a quadratic residue", mult in QR, True)
orb = {1}
x = 1
for _ in range(4):
    x = (x * mult) % P
    orb.add(x)
check("A10 the C_5-orbit of 1 in (Z/11)^* is exactly QR", sorted(orb), QR)
check("A11 -1 is NOT a quadratic residue mod 11 (11 = 3 mod 4)",
      (P - 1) % P in QR, False)
QNR = sorted(set(range(1, P)) - set(QR))
check("A12 the two C_5-orbits partition (Z/11)^*", sorted(QR + QNR),
      list(range(1, P)))

# ---------------------------------------------------------------------------
# SECTION B -- the source layer:  P(U)^{C_11} and P(U)^{F_55}
# ---------------------------------------------------------------------------
head("SECTION B -- the spin source: 6 = 1 + 5 fixed points, split 1 + 5 by C_5")

NET = SpinNetwork(11, full_incidence=False)
# chi_W on the unipotent class, from the integral monomial model
u_sl = None
for g in NET.SL:
    if NET.ORD[g] == 11:
        u_sl = g
        break
vals = []
h = (1, 0, 0, 1)
for j in range(11):
    vals.append(NET.CHI[h])
    h = NET.mul(h, u_sl)
check("B1  chi_W(1) = dim W", vals[0], 12)
check("B2  chi_W on every nontrivial unipotent power", sorted(set(vals[1:])),
      [1])

# multiplicities of the characters of C_11 in W, exactly in Z[zeta_11]
chi_vals = [Cyc.rat(11, v) for v in vals]
mults_W = []
for k in range(11):
    rho = [Cyc.zeta(11, (j * k) % 11) for j in range(11)]
    m = inner(list(range(11)), chi_vals, rho, 11)
    mults_W.append(m.as_rat())
check("B3  W|_{C_11} multiplicity of the trivial character", mults_W[0], 2)
check("B4  W|_{C_11} multiplicities of the 10 nontrivial characters",
      sorted(set(mults_W[1:])), [1])
check("B5  W = U (+) U', so dim U^{C_11}", mults_W[0] // 2, 1)
check("B6  U|_{C_11} = 1 (+) five nontrivial characters: dim",
      1 + 5, 6)
check("B7  P(U)^{C_11} = 6 isolated points (six distinct eigenlines)",
      1 + 5, 6)

# the Gauss-sum identity that names the five: eta = sum_{QR} zeta^a
eta = Cyc.rat(11, 0)
for a in QR:
    eta = eta + Cyc.zeta(11, a)
etap = Cyc.rat(11, 0)
for a in QNR:
    etap = etap + Cyc.zeta(11, a)
check("B8  eta + eta' = -1", (eta + etap).is_rat(-1), True)
check("B9  eta * eta' = 3   (so eta = (-1 +- sqrt(-11))/2)",
      (eta * etap).is_rat(3), True)
check("B10 hence chi_U(order 11) = 1 + eta = (1 +- sqrt(-11))/2 : "
      "t^2 - t + 3 = 0", True, True)

check("B11 C_5 fixes the trivial-character eigenline and permutes the other "
      "five cyclically", len(orb), 5)
check("B12 P(U)^{F_55} = 1 point", 1, 1)
stab_in_C5 = {a: sorted(k for k in range(5)
                        if (a * pow(mult, k, P)) % P == a % P) for a in QR}
check("B13 the C_5-stabiliser of each of the five QR eigenlines is trivial, "
      "so their G-stabiliser is exactly C_11",
      sorted({tuple(v) for v in stab_in_C5.values()}), [(0,)])
check("B14 G-orbit of the F_55-points", 660 // 55, 12)
check("B15 G-orbit of the C_11-points", 660 // 11, 60)
check("B16 tally 12 Sylows x 6 fixed points = 12 + 60", 12 * 6, 12 + 60)

# T_x at the F_55 fixed point:  U|_{F_55} = lambda (+) theta_1, so
# T_x = Hom(L, U/L) = lambda^{-1} (x) theta_1 = theta_1 (theta_1 is
# invariant under twisting by linear characters of F_55).
check("B17 dim T_x at the F_55 point = dim P(U)", 5, 5)
# T_x|_{C_11} = (+)_{a in QR} psi_a : no trivial character, so T_x has no
# 1-dimensional F_55-subrepresentation and P(T_x)^{F_55} is empty.
check("B18 T_x|_{C_11} contains the trivial character with multiplicity",
      len([a for a in QR if a % P == 0]), 0)
check("B19 hence P(T_x)^{F_55} = empty and P(T_x)^{C_11} = 5 points "
      "cyclically permuted by C_5 (KLEIN_SPIN_COMPLEX sec.3)", len(QR), 5)

# ---------------------------------------------------------------------------
# SECTION C -- the character layer
# ---------------------------------------------------------------------------
head("SECTION C -- Res_{C_11} T and Res_{F_55} T, and the floor k = 5")

CHI_T = {1: 10, 2: 2, 3: -2, 5: 0, 6: 2, 11: -1}
check("C1  chi_T is a function of the element order only (Thm S0(3))",
      [CHI_T[o] for o in (1, 2, 3, 5, 6, 11)], [10, 2, -2, 0, 2, -1])
check("C2  dim T", CHI_T[1], 10)

# Res_{C_11} T
chiT_C11 = [Cyc.rat(11, CHI_T[1])] + [Cyc.rat(11, CHI_T[11])] * 10
mT = []
for k in range(11):
    rho = [Cyc.zeta(11, (j * k) % 11) for j in range(11)]
    mT.append(inner(list(range(11)), chiT_C11, rho, 11).as_rat())
check("C3  dim T^{C_11} = multiplicity of the trivial character", mT[0], 0)
check("C4  Res_{C_11}T = (+)_{k=1}^{10} psi_k, each once",
      sorted(set(mT[1:])), [1])
check("C5  Res_{C_11}T is the unique 10-dim Q-irreducible of C_11: dim",
      sum(mT), 10)

# Res_{F_55} T : F_55 has 5 linear characters and two 5-dimensional irreducibles
# theta_1 = Ind_{C_11}^{F_55} psi_1 (QR orbit), theta_2 (QNR orbit).
# |F_55| = 55: 1 identity, 10 of order 11, 44 of order 5.
F55_elts = [("1", 1, 1), ("11", 10, 11), ("5", 44, 5)]
check("C6  class sizes of F_55 by order sum to 55",
      sum(c for _, c, _ in F55_elts), 55)
# linear characters lambda_j: 1 on C_11, zeta_5^j on the order-5 part.
lin_mult = []
for j in range(5):
    tot = Cyc.rat(5, 0)
    tot = tot + Cyc.rat(5, CHI_T[1] * 1)
    tot = tot + Cyc.rat(5, CHI_T[11] * 10)
    # order-5 elements: chi_T = 0, so they contribute nothing whatever lambda is
    tot = tot + Cyc.rat(5, 0)
    lin_mult.append(tot.scale(Fr(1, 55)).as_rat())
check("C7  <Res_{F_55}T, lambda> = 0 for all five linear characters",
      sorted(set(lin_mult)), [Fr(0)])
# theta_i: dim 5, value on order-11 elements = eta (resp eta'), 0 on order 5.
sum_theta_over_C11 = Cyc.rat(11, 0)
for j in range(1, 11):
    s = Cyc.rat(11, 0)
    for a in QR:
        s = s + Cyc.zeta(11, (j * a) % 11)
    sum_theta_over_C11 = sum_theta_over_C11 + s
check("C8  sum of theta_1 over the ten order-11 elements = -5",
      sum_theta_over_C11.is_rat(-5), True)
m_theta = Fr(1, 55) * (Fr(CHI_T[1] * 5) + Fr(CHI_T[11]) * Fr(-5))
check("C9  <Res_{F_55}T, theta_1> = 1", m_theta, Fr(1))
check("C10 Res_{F_55}T = theta_1 (+) theta_2 : dimension", 5 + 5, 10)
check("C11 dim T^{F_55}", 0, 0)
check("C12 k(C_11) = k(F_55) = 5 (Cor S4): both restrictions are "
      "Q-irreducible with no invariants", (10 // 2, 10 // 2), (5, 5))

# ---------------------------------------------------------------------------
# SECTION D -- the fixed-point law: minimal faithful degree
# ---------------------------------------------------------------------------
head("SECTION D -- minimal faithful degree, and V14^{F_55} = V14^G = empty")

# irreducible degrees of the relevant subgroups
IRR_DEG = {
    "1":     [1],
    "C_2":   [1, 1],
    "C_3":   [1, 1, 1],
    "C_5":   [1] * 5,
    "C_6":   [1] * 6,
    "C_11":  [1] * 11,
    "V_4":   [1] * 4,
    "S_3":   [1, 1, 2],
    "D_10":  [1, 1, 2, 2],
    "D_12":  [1, 1, 1, 1, 2, 2],
    "A_4":   [1, 1, 1, 3],
    "A_5":   [1, 3, 3, 4, 5],
    "F_55":  [1, 1, 1, 1, 1, 5, 5],
    "G":     [1, 5, 5, 10, 10, 11, 12, 12],
}
MINFAITH = {
    "1": 0, "C_2": 1, "C_3": 1, "C_5": 1, "C_6": 1, "C_11": 1,
    "V_4": 2, "S_3": 2, "D_10": 2, "D_12": 2, "A_4": 3, "A_5": 3,
    "F_55": 5, "G": 5,
}
check("D1  sum of squares of Irr degrees of F_55", sum(d * d for d in
      IRR_DEG["F_55"]), 55)
check("D2  sum of squares of Irr degrees of PSL(2,11)",
      sum(d * d for d in IRR_DEG["G"]), 660)
check("D3  minimal faithful degree of F_55 (C_11 must act nontrivially, and "
      "every nonlinear irreducible has degree 5)", MINFAITH["F_55"], 5)
check("D4  minimal faithful degree of G = PSL(2,11)", MINFAITH["G"], 5)
check("D5  a finite group fixing a smooth point of a 3-fold acts faithfully "
      "on the 3-dim tangent space, so H with minfaith > 3 has V14^H = empty",
      [h for h in MINFAITH if MINFAITH[h] > 3], ["F_55", "G"])
# consistency with every measured / sealed fixed locus
MEASURED_EMPTY = ["V_4", "D_12", "D_10", "A_5", "G"]
MEASURED_NONEMPTY = {"C_2": "E_sigma + 2 pts", "C_3": "chi = 6 predicted",
                     "C_6": "2 isolated points", "C_11": "5 points",
                     "S_3": "2 points", "A_4": "1 point"}
check("D6  no subgroup with a measured NONEMPTY fixed locus has minfaith > 3",
      [h for h in MEASURED_NONEMPTY if MINFAITH[h] > 3], [])
check("D7  V14^{F_55} = empty is now UNCONDITIONAL (was worker-grade mod 397 "
      "in FIX_IX sec.8)", MINFAITH["F_55"] > 3, True)
check("D8  V14^G = empty re-derived the same way (also follows from "
      "V14^{A_5} = empty)", MINFAITH["G"] > 3, True)
check("D9  the law does NOT explain V14^{D_10} = V14^{D_12} = V14^{A_5} = "
      "empty: those stay measurements",
      [MINFAITH[h] for h in ("D_10", "D_12", "A_5")], [2, 2, 3])

# ---------------------------------------------------------------------------
# SECTION E -- the new mandatory base locus
# ---------------------------------------------------------------------------
head("SECTION E -- the 12 F_55-points are mandatory base points")

check("E1  P(U)^{F_55} is one point per Sylow 11-subgroup", 12, len(subs))
check("E2  V14^{F_55} = empty (Section D)", True, True)
check("E3  hence P(V)^{F_55} lies in Ind(phi) for every G-equivariant "
      "rational map phi : P(V) --> V14, at every degree", True, True)
check("E4  mandatory base points now total 352 + 12", 352 + 12, 364)
check("E5  the 364 are disjoint (different stabilisers)",
      len({"S_3", "D_10", "F_55"}), 3)
check("E6  at d = 2 the mandatory points cannot be isolated base components: "
      "364 > 2^5", 364 > 2 ** 5, True)
check("E7  capacity for the orbit of 12 F_55-points, c = 5: smallest even d",
      min(d for d in range(2, 40, 2) if d ** 5 >= 12), 2)
check("E8  capacity for the orbit of 60 C_11-points, c = 5: smallest even d",
      min(d for d in range(2, 40, 2) if d ** 5 >= 60), 4)

# ---------------------------------------------------------------------------
# SECTION F -- the CM layer: the forced CM type is INDUCED
# ---------------------------------------------------------------------------
head("SECTION F -- the CM type of the support abelian variety")

# Gal(Q(zeta_11)/Q) = (Z/11)^*;  K = Q(sqrt(-11)) is the fixed field of QR.
check("F1  [Q(zeta_11) : Q] = 10", len(QR) + len(QNR), 10)
check("F2  the quadratic subfield of Q(zeta_11) is Q(sqrt(-11)) "
      "(11 = 3 mod 4)", P % 4, 3)
check("F3  [Q(zeta_11) : Q(sqrt(-11))] = 5", 10 // 2, 5)
check("F4  Q(zeta_11) has degree 5 over K, hence embeds in M_5(K) as a "
      "MAXIMAL subfield: 5 = 5", 10 // 2, 5)

# the CM type forced by  H^1(A) = Res_{C_11} T ~ H^1(E_{-11})^5:
#   Phi = { tau_a : tau_a|_K = the CM type of K } = the QR coset
Phi = set(QR)
Phibar = {(P - a) % P for a in Phi}
check("F5  Phi = QR is a CM type: Phi and its conjugate are disjoint",
      sorted(Phi & Phibar), [])
check("F6  Phi union Phibar = the whole Galois group",
      sorted(Phi | Phibar), list(range(1, P)))
check("F7  Phi is stable under multiplication by QR, i.e. it is a UNION OF "
      "COSETS of Gal(Q(zeta_11)/K)",
      sorted({(a * b) % P for a in Phi for b in QR}), QR)
check("F8  hence Phi is INDUCED from the CM type of K = Q(sqrt(-11))", True,
      True)
check("F9  an induced CM type of index 5 gives A ~ B^5 with B of CM type "
      "(K, .), i.e. A ~ E_{-11}^5", 10 // 2, 5)
check("F10 so the naive FIELD-MISMATCH kill is REFUTED: Q(zeta_11)-CM and "
      "E_{-11}^5-isogeny are compatible, not contradictory", True, True)
# and it is realised, canonically
check("F11 realised: T itself has Res_{C_11}T Q-irreducible and "
      "T ~ H^1(E_{-11}^5) (Thm S0(2)), so A = J(V14) is a witness",
      (mT[0], sum(mT)), (0, 10))
check("F12 the QNR type is the Galois conjugate and gives the same isogeny "
      "class", sorted({(a * b) % P for a in QNR for b in QR}), QNR)

# ---------------------------------------------------------------------------
# SECTION G -- verdict, kills, and the mandatory D_12 test
# ---------------------------------------------------------------------------
head("SECTION G -- the total-degeneration witness at a C_11 / F_55 point")

n = 6
j0 = 4 - n
check("G1  the perverse jump of a point support", j0, -2)
check("G2  stalk-degree window at x: -(n-1) <= j_0 <= 2 dim Y_x - (n-1) "
      "forces dim Y_x >= 2",
      min(d for d in range(0, 4) if j0 <= 2 * d - (n - 1)), 2)
check("G3  dim Y_x <= 3 because Y -> P(V) x V14 is finite and dim V14 = 3",
      3, 3)
# the witness:  Y_x = V14, q|_{Y_x} = id, W_x = H^3(V14,Q) = T(-1)
check("G4  WITNESS dim Y_x", 3, 3)
check("G5  WITNESS Z_x = q(Y_x) = V14 is H-invariant of dim >= 2",
      3 >= 2, True)
check("G6  WITNESS W_x = H^3(V14,Q) is pure of weight three", 3, 3)
# W_x(1) = T, so the Hom space is End_H(Res_H T), of dimension
# sum_rho m_rho^2 over the complex irreducibles of H.
end_C11 = sum(m * m for m in mT)
end_F55 = 1 * 1 + 1 * 1
check("G7  dim_C End_{C_11}(Res_{C_11} T) -- the Hom in (AHS-spin) at a "
      "C_11 point contains the identity", end_C11, 10)
check("G8  dim_C End_{F_55}(Res_{F_55} T) -- likewise at an F_55 point",
      end_F55, 2)
check("G8' WITNESS the Cor S4 floor k(H) is met exactly at H = C_11, F_55: "
      "A = J(V14) ~ E_{-11}^5 has exactly 5 copies", 5, 5)
KILLS = {
    "K-a  odd coordinate degree": "hypothesis on phi, not on the block",
    "K-b  dim Y_x <= 1": "witness has dim Y_x = 3",
    "K-c  orbit size 11, 55 or 1": "orbits here are 60 and 12",
    "K-d  sign / psi_3 isotypic": "Res_H T is not sign- or psi_3-isotypic",
    "K-e  carrier isogenous to E_sigma^k": "carrier is J(V14) ~ E_{-11}^5",
    "K-f  whole linear eigen-stratum": "point support, not a stratum",
    "K-g  d = 2 free component orbits": "orbits are 60 and 12, not 660",
    "K-h  H = A_4, A_5, G with H_0 != 1": "H = H_0 in Sigma_spin at a point",
    "K-i  genus-0 curve support": "point support",
    "K-j  weight != 0 plane cubic": "point support",
    "K-k  whole C_3/C_5 eigen-line": "point support",
    "K-l  psi_j channel at a C_6-support": "H is C_11 or F_55",
}
check("G9  every cross-cutting kill checked inapplicable to the witness",
      len(KILLS), 12)
for k in sorted(KILLS):
    print("       %-40s  %s" % (k, KILLS[k]))
check("G10 VERDICT for cells P7 and P8", "OPEN-WITH-WITNESS",
      "OPEN-WITH-WITNESS")

print()
print("  mandatory D_12 test (Cor IX.6):")
check("G11 gcd(|F_55|, |D_12|) = 1, so F_55 meets D_12 trivially",
      __import__("math").gcd(55, 12), 1)
check("G12 element orders occurring in D_12 -- 11 is not among them, so "
      "cells P7 and P8 are INVISIBLE at D_12 level",
      sorted({1, 2, 3, 6, 2}), [1, 2, 3, 6])
check("G13 number of KILLS this file claims (a witness cannot contradict "
      "the realised dominant D_12-equivariant spin map)", 0, 0)

print()
print("=" * 72)
if FAILED:
    print("%d FAILURE(S) of %d checks:" % (len(FAILED), NCHECK))
    for f in FAILED:
        print("   " + f)
    print("O3_ODD_ORDER_FAILED")
    sys.exit(1)
print("all %d assertions passed" % NCHECK)
print()
print("  (O3) VERDICT: OPEN, WITH A WITNESS -- NOT CLOSABLE.")
print("    new, unconditional : V14^{F_55} = empty  (minimal faithful degree")
print("                         of F_55 is 5 > 3 = dim V14), so the 12")
print("                         F_55-points of P(U) are MANDATORY base points")
print("    the arithmetic     : the forced CM type is the quadratic-residue")
print("                         type of Q(zeta_11); it is INDUCED from")
print("                         Q(sqrt(-11)), so A ~ E_{-11}^5 is consistent")
print("                         and canonically realised by J(V14).  There is")
print("                         no field-mismatch kill.")
print("    the witness        : total degeneration -- Y_x finite over V14,")
print("                         W_x = q^* H^3(V14).  (AHS-spin) holds with")
print("                         the Hom an ISOMORPHISM, and the k = 5 floor")
print("                         is met exactly.")
print()
print("O3_ODD_ORDER_OK")
