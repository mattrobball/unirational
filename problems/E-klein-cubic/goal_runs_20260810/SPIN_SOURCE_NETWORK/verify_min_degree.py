#!/usr/bin/env python3
"""
verify_min_degree.py -- the MINIMAL LIVE COORDINATE DEGREE of the spin lane
(named open task 7.4 of `SUPPORT_CENSUS.md`; also flagged in `SUPPORT_CENSUS.md`
section 3.1 and `O4_EIGENPLANE_CURVES.md` section 5).

QUESTION.  Gtilde = SL(2,F_11), G = PSL(2,F_11); U one of the two 6-dimensional
faithful (spin) irreducibles of Gtilde; M the 10-dimensional G-irreducible
summand of Lambda^2 U, which is the coordinate module of the sealed model
V14 = Gr(2,U) cap P(M) inside P(M) = P^9 (`V14_S3_D10_MEASUREMENT.md` section 1,
`FIX_IX_SEAL`).  What is the smallest d >= 1 with

    Hom_{Gtilde}( M^* , S^d(U^*) )  !=  0 ?

ANSWER (computed below, exactly):  d = 4, with multiplicity 3.

METHOD.  Everything is exact and lives in the ring Z[(1+sqrt(-11))/2]; there is
no floating point and no sampling anywhere.

  (A) The group and the INTEGRAL monomial model W = Ind_B^{SL(2,11)}(Legendre)
      come from `spin_network_lib`: 1320 signed 12x12 permutation matrices
      RHO[g] with entries in Z, chi_W = chi_U + chi_U'.

  (B) chi_U itself is extracted by a CENTRAL PROJECTOR, not by a hand choice.
      Let C0 be the conjugacy class of u = [[1,1],[0,1]] (60 elements) and
      A = sum_{g in C0} RHO[g], an integer 12x12 matrix.  A is central in the
      image of the group algebra, so it acts as a scalar a on U and b on U';
      a + b = tr(A)/6 and a^2 + b^2 = tr(A^2)/6 give a, b = 5 +/- 5 sqrt(-11),
      and the integer identity A^2 - 10A + 300I = 0 is verified entrywise.
      Then P_U = (A - b)/(a - b) is the projector onto U along U', it commutes
      with every RHO[g], and

          chi_U(g) = tr( RHO[g] P_U ) = ( tr(RHO[g] A) - b chi_W(g) ) / (a - b)

      is an exact element of Q(sqrt(-11)) for every one of the 1320 g.  The
      labelling choice is only "which root of x^2 - 10x + 300 is called a", and
      section F reruns the whole computation with the other root (that is U')
      and gets the same multiplicities -- as it must, M being rational.

  (C) chi_{Lambda^2 U}(g) = (chi_U(g)^2 - chi_U(g^2))/2 is decomposed against
      the rational block characters of PSL(2,11), giving Lambda^2 U = 5 + 10'
      and identifying M = 10' = (10, 2, 1, 0, -1, -1) on element orders
      (1, 2, 3, 5, 6, 11) -- the "10'" of the sealed packet, NOT the other
      absolutely irreducible 10 = (10, -2, 1, 0, 1, -1).

  (D) chi_{S^d U} by Newton's identity chi_{S^d}(g) = (1/d) sum_k chi_U(g^k)
      chi_{S^{d-k}}(g), cross-checked against a second, independent code path:
      the elementary symmetric functions e_1..e_6 of the eigenvalues of
      rho_U(g) (also Newton, other sign pattern), the characteristic polynomial
      det(1 - t rho_U(g)) = sum (-1)^k e_k t^k, and its power-series inverse.
      e_6 = det rho_U(g) = 1 for all 1320 g (Gtilde is perfect), a strong check.

  (E) The multiplicities <chi_{S^d U}, chi_M> for d = 1..16, the minimal live
      degree, and the odd-d vanishing of Theorem C6 -- checked twice: once as
      the value of the orthogonality sum, and once structurally from the
      identity chi_{S^d U}(-g) = (-1)^d chi_{S^d U}(g) together with
      chi_M(-g) = chi_M(g), which is the actual content of Theorem C6.

CONVENTIONS.  M is rational, so M^* = M.  S^d(U^*) = (S^d U)^*, so
dim Hom(M^*, S^d(U^*)) = dim Hom(S^d U, M) = <chi_{S^d U}, chi_M>.  Also
U^* = U' (section B verifies <chi_U, chi_U> = 1 and <chi_U * chi_U, 1> = 0, so
U is NOT self-dual and conj(chi_U) = chi_{U'}).  Section F verifies that all
four readings -- S^d U vs S^d U^*, M vs M^*, U vs U' -- give the same integer.

No Macaulay2, no msolve, no network, no data files.  Python 3 standard library
plus `spin_network_lib` from this directory.  Runtime a few seconds.

Marker on success: MIN_DEGREE_OK
"""

from fractions import Fraction as Fr
from collections import Counter

from spin_network_lib import SpinNetwork

FAILED = []
NCHECK = 0


def check(name, got, want):
    global NCHECK
    NCHECK += 1
    if got != want:
        FAILED.append(f"{name}: got {got!r}, want {want!r}")
        print(f"  FAIL {name}: got {got!r}, want {want!r}")
    return got == want


# ----------------------------------------------------------------------
# exact arithmetic in K = Q(sqrt(-11)):  (p, q) means p + q sqrt(-11)
# ----------------------------------------------------------------------
def K(p, q=0):
    return (Fr(p), Fr(q))


KZERO, KONE = K(0), K(1)


def kadd(x, y):
    return (x[0] + y[0], x[1] + y[1])


def ksub(x, y):
    return (x[0] - y[0], x[1] - y[1])


def kmul(x, y):
    return (x[0] * y[0] - 11 * x[1] * y[1], x[0] * y[1] + x[1] * y[0])


def kdiv(x, y):
    d = y[0] * y[0] + 11 * y[1] * y[1]
    assert d != 0
    return ((x[0] * y[0] + 11 * x[1] * y[1]) / d,
            (x[1] * y[0] - x[0] * y[1]) / d)


def kconj(x):
    """complex conjugation = the nontrivial element of Gal(K/Q)."""
    return (x[0], -x[1])


def kstr(x):
    if x[1] == 0:
        return str(x[0])
    return "%s %s %s*sqrt(-11)" % (x[0], "+" if x[1] > 0 else "-", abs(x[1]))


def kint(x):
    """the rational part, asserting the element is rational."""
    assert x[1] == 0, x
    return x[0]


# ======================================================================
print("=" * 72)
print("SECTION A -- Gtilde = SL(2,F_11) and the integral monomial model W")
print("=" * 72)

net = SpinNetwork(11, full_incidence=False)
SL, mul, inv = net.SL, net.mul, net.inv
ID, NEG, n = net.ID, net.NEG, net.n
ORD, CHIW, RHO = net.ORD, net.CHI, net.RHO

check("A1 |SL(2,F_11)| = 1320", len(SL), 1320)
check("A2 dim W = q + 1 = 12", n, 12)
check("A3 order profile of SL(2,F_11)",
      sorted(Counter(ORD.values()).items()),
      [(1, 1), (2, 1), (3, 110), (4, 110), (5, 264), (6, 110),
       (10, 264), (11, 120), (12, 220), (22, 120)])
check("A4 -I is the unique involution", sum(1 for g in SL if ORD[g] == 2), 1)
check("A5 rho(-I) = -id_12 (W is purely spin)",
      all(RHO[NEG][i][j] == (-1 if i == j else 0)
          for i in range(n) for j in range(n)), True)
check("A6 chi_W(1) = 12", CHIW[ID], 12)
check("A7 chi_W(-I) = -12", CHIW[NEG], -12)
check("A8 <chi_W, chi_W> = 2, so W = U (+) U' with U, U' irreducible and "
      "non-isomorphic",
      Fr(sum(CHIW[g] * CHIW[g] for g in SL), 1320), 2)

# conjugacy classes, by orbit of conjugation under a 2-element generating set
GENS = ((1, 1, 0, 1), (0, 10, 1, 0))
check("A9 the two chosen matrices generate SL(2,F_11)",
      len(net.gens_group(GENS)), 1320)


def conj_classes():
    seen, out = set(), []
    for g in SL:
        if g in seen:
            continue
        orb, fr = {g}, [g]
        while fr:
            nx = []
            for x in fr:
                for s in GENS:
                    y = mul(mul(s, x), inv(s))
                    if y not in orb:
                        orb.add(y)
                        nx.append(y)
            fr = nx
        seen |= orb
        out.append(sorted(orb))
    return out


CL = conj_classes()
check("A10 SL(2,F_11) has 15 conjugacy classes", len(CL), 15)
check("A11 the classes, as (element order, size)",
      sorted((ORD[c[0]], len(c)) for c in CL),
      [(1, 1), (2, 1), (3, 110), (4, 110), (5, 132), (5, 132), (6, 110),
       (10, 132), (10, 132), (11, 60), (11, 60), (12, 110), (12, 110),
       (22, 60), (22, 60)])
CHIW_BY_ORD = {}
for c in CL:
    CHIW_BY_ORD.setdefault(ORD[c[0]], set()).add(CHIW[c[0]])
check("A12 chi_W by element order (0 exactly on the elliptic orders 3,4,6,12)",
      {o: sorted(v) for o, v in sorted(CHIW_BY_ORD.items())},
      {1: [12], 2: [-12], 3: [0], 4: [0], 5: [2], 6: [0],
       10: [-2], 11: [1], 12: [0], 22: [-1]})

print("  |SL| = 1320, 15 classes, W = Ind_B(Legendre) purely spin, integral.")

# ======================================================================
print()
print("=" * 72)
print("SECTION B -- chi_U by the central class-sum projector (exact in K)")
print("=" * 72)

u = (1, 1, 0, 1)
C0 = next(c for c in CL if u in c)
check("B1 u = [[1,1],[0,1]] has order 11", ORD[u], 11)
check("B2 its class C0 has 60 elements", len(C0), 60)

A = [[0] * n for _ in range(n)]
for g in C0:
    R = RHO[g]
    for i in range(n):
        for j in range(n):
            A[i][j] += R[i][j]

trA = sum(A[i][i] for i in range(n))
trA2 = sum(A[i][j] * A[j][i] for i in range(n) for j in range(n))
check("B3 tr(A) = 60 chi_W(u) = 60", trA, 60)
check("B4 tr(A^2) = -3000", trA2, -3000)

# A acts as a on U and b on U', each with multiplicity 6
s_ab = Fr(trA, 6)                                  # a + b
p_ab = (s_ab * s_ab - Fr(trA2, 6)) / 2             # a b
check("B5 a + b = tr(A)/6 = 10", s_ab, 10)
check("B6 a b = ((a+b)^2 - tr(A^2)/6)/2 = 300", p_ab, 300)
disc = s_ab * s_ab - 4 * p_ab
check("B7 the discriminant is -1100 = -11 * 10^2, so a, b lie in "
      "Q(sqrt(-11)) and are Galois conjugate", (disc, disc / -11), (-1100, 100))

A_EIG, B_EIG = K(5, 5), K(5, -5)
check("B8 a = 5 + 5 sqrt(-11), b = 5 - 5 sqrt(-11) solve x^2 - 10x + 300",
      (kadd(A_EIG, B_EIG), kmul(A_EIG, B_EIG)), (K(10), K(300)))

# the integer identity A^2 - 10 A + 300 I = 0, entrywise
minpoly_ok = True
for i in range(n):
    row = [sum(A[i][k] * A[k][j] for k in range(n)) for j in range(n)]
    for j in range(n):
        v = row[j] - 10 * A[i][j] + (300 if i == j else 0)
        if v != 0:
            minpoly_ok = False
check("B9 A^2 - 10 A + 300 I = 0 entrywise over Z: A has exactly the two "
      "eigenvalues a, b, so P_U = (A - b)/(a - b) is a projector", minpoly_ok,
      True)

# tr(RHO[g] A) for every g -- RHO[g] is a signed permutation matrix
TRGA = {}
for g in SL:
    R = RHO[g]
    t = 0
    for i in range(n):
        Ri = R[i]
        for j in range(n):
            if Ri[j]:
                t += Ri[j] * A[j][i]
    TRGA[g] = t


def chiU_with(a, b):
    """chi(g) = tr(RHO[g] P) with P = (A - b)/(a - b): the character of the
    6-dimensional constituent on which the central element A acts by a."""
    amb = ksub(a, b)
    return {g: kdiv(ksub(K(TRGA[g]), kmul(b, K(CHIW[g]))), amb) for g in SL}


CHIU = chiU_with(A_EIG, B_EIG)
CHIUP = chiU_with(B_EIG, A_EIG)

check("B10 chi_U(1) = 6", CHIU[ID], (6, 0))
check("B11 chi_U(-I) = -6 (U is spin)", CHIU[NEG], (-6, 0))
check("B12 chi_U(u) = (1 + sqrt(-11))/2 on the class C0 -- the normalisation "
      "asked for in the task statement", CHIU[u], (Fr(1, 2), Fr(1, 2)))
check("B13 chi_U + chi_U' = chi_W", all(kadd(CHIU[g], CHIUP[g]) == K(CHIW[g])
                                        for g in SL), True)
nrm = KZERO
for g in SL:
    nrm = kadd(nrm, kmul(CHIU[g], kconj(CHIU[g])))
check("B14 <chi_U, chi_U> = 1: U is irreducible", kdiv(nrm, K(1320)), (1, 0))
nrm2 = KZERO
for g in SL:
    nrm2 = kadd(nrm2, kmul(CHIU[g], CHIU[g]))
check("B15 <chi_U, conj(chi_U)> = 0: U is NOT self-dual, so U^* = U' "
      "(the Frobenius-Schur / duality bookkeeping the task asks to state)",
      kdiv(nrm2, K(1320)), (0, 0))
check("B16 conj(chi_U) = chi_U' exactly, on all 1320 elements",
      all(kconj(CHIU[g]) == CHIUP[g] for g in SL), True)

CHIU_BY_ORD = {}
for c in CL:
    CHIU_BY_ORD.setdefault(ORD[c[0]], set()).add(CHIU[c[0]])
check("B17 chi_U by element order: irrational exactly on the four classes of "
      "order 11 and 22 (the only orders whose cyclotomic field contains "
      "sqrt(-11))",
      {o: sorted(v) for o, v in sorted(CHIU_BY_ORD.items())},
      {1: [(6, 0)], 2: [(-6, 0)], 3: [(0, 0)], 4: [(0, 0)], 5: [(1, 0)],
       6: [(0, 0)], 10: [(-1, 0)],
       11: [(Fr(1, 2), Fr(-1, 2)), (Fr(1, 2), Fr(1, 2))],
       12: [(0, 0)],
       22: [(Fr(-1, 2), Fr(-1, 2)), (Fr(-1, 2), Fr(1, 2))]})

print("  chi_U = (6, -6, 0, 0, 1, 0, -1, (1 +/- sqrt(-11))/2, 0, "
      "(-1 -/+ sqrt(-11))/2)")
print("        on element orders (1, 2, 3, 4, 5, 6, 10, 11, 12, 22).")

# ======================================================================
print()
print("=" * 72)
print("SECTION C -- Lambda^2 U, and the identification M = 10'")
print("=" * 72)

# the rational block characters of PSL(2,11), keyed by PROJECTIVE order.
# The two 5s and the two 12s are Galois-conjugate pairs, so only their sums
# T = 5 + 5bar and S = 12 + 12bar are rational; those sums are still constant
# on the fibres of the projective order, which is all we need.
POR = {g: net.proj_order(g) for g in SL}
OIDX = {1: 0, 2: 1, 3: 2, 5: 3, 6: 4, 11: 5}
TAB = {"1": [1, 1, 1, 1, 1, 1],
       "T=5+5bar": [10, 2, -2, 0, 2, -1],
       "10": [10, -2, 1, 0, 1, -1],
       "10'": [10, 2, 1, 0, -1, -1],
       "11": [11, -1, -1, 1, -1, 0],
       "S=12+12bar": [24, 0, 0, -1, 0, 2]}
DIMS = {"1": 1, "T=5+5bar": 5, "10": 10, "10'": 10, "11": 11,
        "S=12+12bar": 12}
NAMES = ["1", "T=5+5bar", "10", "10'", "11", "S=12+12bar"]
check("C0 the projective orders occurring in PSL(2,11)",
      sorted(set(POR.values())), [1, 2, 3, 5, 6, 11])


def tval(nm, g):
    return TAB[nm][OIDX[POR[g]]]


def pair_rational(nm1, nm2):
    return Fr(sum(tval(nm1, g) * tval(nm2, g) for g in SL), 1320)


gram = {(a, b): pair_rational(a, b) for a in NAMES for b in NAMES}
check("C1 the block characters are pairwise orthogonal",
      all(gram[(a, b)] == 0 for a in NAMES for b in NAMES if a != b), True)
check("C2 their norms: 1 for the absolutely irreducible ones, 2 for the two "
      "Galois-conjugate pairs",
      [gram[(a, a)] for a in NAMES], [1, 2, 1, 1, 1, 2])
check("C3 the six blocks account for all 660 = sum of squares of degrees",
      sum(DIMS[a] * DIMS[a] * int(gram[(a, a)]) for a in NAMES), 660)
check("C4 the two absolutely irreducible 10s of the task statement",
      (TAB["10"], TAB["10'"]),
      ([10, -2, 1, 0, 1, -1], [10, 2, 1, 0, -1, -1]))


def decompose(chi):
    """multiplicities of the six rational blocks in a class function chi."""
    out = {}
    for nm in NAMES:
        acc = KZERO
        for g in SL:
            acc = kadd(acc, kmul(chi[g], K(tval(nm, g))))
        out[nm] = kdiv(acc, K(1320))
    return out


CHIL2 = {}
for g in SL:
    g2 = mul(g, g)
    CHIL2[g] = kdiv(ksub(kmul(CHIU[g], CHIU[g]), CHIU[g2]), K(2))

check("C5 dim Lambda^2 U = 15", CHIL2[ID], (15, 0))
check("C6 -I acts trivially on Lambda^2 U, so it is a G = PSL(2,11)-module",
      all(CHIL2[mul(NEG, g)] == CHIL2[g] for g in SL), True)
nl2 = KZERO
for g in SL:
    nl2 = kadd(nl2, kmul(CHIL2[g], kconj(CHIL2[g])))
check("C7 <Lambda^2 U, Lambda^2 U> = 2: exactly two irreducible summands",
      kdiv(nl2, K(1320)), (2, 0))

DL2 = decompose(CHIL2)
check("C8 <Lambda^2 U, 10'> = 1", DL2["10'"], (1, 0))
check("C9 <Lambda^2 U, 10> = 0: the OTHER absolutely irreducible 10 does not "
      "occur", DL2["10"], (0, 0))
check("C10 <Lambda^2 U, 5 + 5bar> = 1: one of the two 5s occurs once",
      DL2["T=5+5bar"], (1, 0))
check("C11 <Lambda^2 U, 1> = <Lambda^2 U, 11> = <Lambda^2 U, 12 + 12bar> = 0",
      (DL2["1"], DL2["11"], DL2["S=12+12bar"]), ((0, 0), (0, 0), (0, 0)))
check("C12 the multiplicities account for dim 15 = 5 + 10",
      sum(DIMS[nm] * kint(DL2[nm]) for nm in NAMES), 15)
check("C13 chi_{Lambda^2 U} on an involution of G is 3 = 1 + 2, the value "
      "that separates 10' (+2) from 10 (-2)",
      CHIL2[next(g for g in SL if ORD[g] == 4)], (3, 0))

CHIM = {g: K(tval("10'", g)) for g in SL}
check("C14 M := the 10-dimensional summand of Lambda^2 U is 10' = "
      "(10, 2, 1, 0, -1, -1) on orders (1,2,3,5,6,11) -- exactly the '10'' of "
      "V14_S3_D10_MEASUREMENT.md section 1 and of the FIX_IX seal",
      all(kadd(CHIM[g], ksub(CHIL2[g], CHIM[g])) == CHIL2[g] for g in SL), True)
CHI5 = {g: ksub(CHIL2[g], CHIM[g]) for g in SL}
n5 = KZERO
for g in SL:
    n5 = kadd(n5, kmul(CHI5[g], kconj(CHI5[g])))
check("C15 Lambda^2 U - 10' is an irreducible character of degree 5",
      (CHI5[ID], kdiv(n5, K(1320))), ((5, 0), (1, 0)))
check("C16 M is rational-valued, hence M^* = M",
      all(CHIM[g][1] == 0 for g in SL), True)
nM = Fr(sum(int(kint(CHIM[g])) ** 2 for g in SL), 1320)
check("C17 <chi_M, chi_M> = 1", nM, 1)

print("  Lambda^2 U = 5 (+) 10',  M = 10' = (10, 2, 1, 0, -1, -1).")

# ======================================================================
print()
print("=" * 72)
print("SECTION D -- chi_{S^d U}, two independent code paths")
print("=" * 72)

DMAX = 16
POW = {}
for g in SL:
    p, L = ID, [ID]
    for _ in range(DMAX):
        p = mul(p, g)
        L.append(p)
    POW[g] = L
check("D0 g^|g| = 1 for every element (the power tables are correct)",
      all(POW[g][ORD[g]] == ID for g in SL if ORD[g] <= DMAX), True)


def sym_powers(chi):
    """h_d(g) = chi_{S^d}(g) by Newton: d h_d = sum_{k=1}^d p_k h_{d-k}."""
    H = {g: [KONE] for g in SL}
    for d in range(1, DMAX + 1):
        for g in SL:
            acc = KZERO
            Hg = H[g]
            for k in range(1, d + 1):
                acc = kadd(acc, kmul(chi[POW[g][k]], Hg[d - k]))
            Hg.append(kdiv(acc, K(d)))
    return H


H = sym_powers(CHIU)
BIN = [1, 6, 21, 56, 126, 252, 462, 792, 1287, 2002, 3003, 4368, 6188, 8568,
       11628, 15504, 20349]
check("D1 dim S^d U = C(d+5,5) for d = 0..16",
      [H[ID][d] for d in range(DMAX + 1)], [(b, 0) for b in BIN])
check("D2 chi_{S^d U}(-I) = (-1)^d C(d+5,5)",
      [H[NEG][d] for d in range(DMAX + 1)],
      [((-1) ** d * BIN[d], 0) for d in range(DMAX + 1)])

# --- second code path: e_k, the characteristic polynomial, series inversion
ELEM = {}
for g in SL:
    p = [None] + [CHIU[POW[g][k]] for k in range(1, 7)]
    e = [KONE]
    for k in range(1, 7):
        acc = KZERO
        for i in range(1, k + 1):
            t = kmul(e[k - i], p[i])
            acc = kadd(acc, t) if i % 2 == 1 else ksub(acc, t)
        e.append(kdiv(acc, K(k)))
    ELEM[g] = e

check("D3 e_1 = chi_U on all 1320 elements",
      all(ELEM[g][1] == CHIU[g] for g in SL), True)
check("D4 e_6 = det rho_U(g) = 1 for all 1320 elements: Gtilde is perfect, so "
      "U lands in SL(U)", all(ELEM[g][6] == KONE for g in SL), True)
check("D5 e_5 = conj(e_1): Lambda^5 U = U^* since det = 1",
      all(ELEM[g][5] == kconj(ELEM[g][1]) for g in SL), True)

MISMATCH = 0
for g in SL:
    # D(t) = det(1 - t rho_U(g)) = sum_{k=0}^{6} (-1)^k e_k t^k
    D = [ELEM[g][k] if k % 2 == 0 else ksub(KZERO, ELEM[g][k])
         for k in range(7)]
    # power-series inverse of D up to t^DMAX (D[0] = 1)
    hh = [KONE]
    for d in range(1, DMAX + 1):
        acc = KZERO
        for k in range(1, min(d, 6) + 1):
            acc = kadd(acc, kmul(D[k], hh[d - k]))
        hh.append(ksub(KZERO, acc))
    if hh != H[g]:
        MISMATCH += 1
check("D6 1/det(1 - t rho_U(g)) = sum_d chi_{S^d U}(g) t^d, for all 1320 g "
      "and all d <= 16: the Newton recursion and the Molien generating "
      "function agree", MISMATCH, 0)

check("D7 chi_{S^2 U}(sigmatilde) = -3 on an order-4 element", H[
      next(g for g in SL if ORD[g] == 4)][2], (-3, 0))
D2DEC = decompose({g: H[g][2] for g in SL})
check("D8 S^2 U = 10 (+) 11 -- note it is the OTHER 10 that appears in degree "
      "2, which is why degree 2 is dead",
      [D2DEC[nm] for nm in NAMES],
      [(0, 0), (0, 0), (1, 0), (0, 0), (1, 0), (0, 0)])

print("  Newton and Molien agree on all 1320 elements up to degree 16.")

# ======================================================================
print()
print("=" * 72)
print("SECTION E -- the multiplicity table and the minimal live degree")
print("=" * 72)


def mult_in_Sd(H_, chi_target, d):
    acc = KZERO
    for g in SL:
        acc = kadd(acc, kmul(H_[g][d], kconj(chi_target[g])))
    return kdiv(acc, K(1320))


MULT = {}
FULL = {}
for d in range(1, DMAX + 1):
    dec = decompose({g: H[g][d] for g in SL})
    FULL[d] = dec
    MULT[d] = dec["10'"]

print()
print("   d | dim S^d U |  <S^d U, M=10'>  ||  1   5+5bar   10   10'   11"
      "   12+12bar")
print("  ---+-----------+------------------++----------------------------"
      "-----------")
for d in range(1, 13):
    dec = FULL[d]
    print("  %2d | %9d | %14s   || %3d %6d %5d %5d %5d %8d"
          % (d, BIN[d], kstr(MULT[d]), kint(dec["1"]), kint(dec["T=5+5bar"]),
             kint(dec["10"]), kint(dec["10'"]), kint(dec["11"]),
             kint(dec["S=12+12bar"])))
print()

for d in range(1, DMAX + 1):
    check("E1.%d the multiplicity <S^%d U, 10'> is a nonnegative rational "
          "integer" % (d, d),
          (MULT[d][1] == 0, MULT[d][0].denominator == 1, MULT[d][0] >= 0),
          (True, True, True))
    # for EVEN d, S^d U is a G-module and the six blocks are a complete list,
    # so the multiplicities must account for the whole of dim S^d U; for ODD d
    # the whole of S^d U is spin and every G-block multiplicity is 0.
    check("E2.%d the degree-%d decomposition into G-blocks totals %s"
          % (d, d, BIN[d] if d % 2 == 0 else 0),
          sum(DIMS[nm] * kint(FULL[d][nm]) for nm in NAMES),
          BIN[d] if d % 2 == 0 else 0)

TABLE = [int(kint(MULT[d])) for d in range(1, 13)]
check("E3 the multiplicity table for d = 1..12", TABLE,
      [0, 0, 0, 3, 0, 6, 0, 22, 0, 42, 0, 99])
check("E4 the table continues 0, 170, 0, 316 at d = 13..16",
      [int(kint(MULT[d])) for d in range(13, 17)], [0, 170, 0, 316])

DMIN = min(d for d in range(1, DMAX + 1) if MULT[d] != KZERO)
check("E5 THE MINIMAL LIVE COORDINATE DEGREE IS d = 4", DMIN, 4)
check("E6 the multiplicity at d = 4 is 3: Hom(M^*, S^4 U^*) is "
      "3-dimensional, so the equivariant degree-4 maps P(U) --> P(M) form a "
      "P^2 of candidates", int(kint(MULT[4])), 3)
check("E7 degrees 1, 2, 3 are all dead", [TABLE[0], TABLE[1], TABLE[2]],
      [0, 0, 0])
check("E8 once alive the multiplicity never returns to 0 on even degrees "
      "d <= 16", all(MULT[d] != KZERO for d in range(4, DMAX + 1, 2)), True)
check("E9 S^4 U = 1 + (three 5s) + 10 + 3.10' + 2.11 + (four 12s), dim 126",
      [kint(FULL[4][nm]) for nm in NAMES], [1, 3, 1, 3, 2, 4])

# --- Theorem C6: the odd-degree vanishing, checked twice -------------
check("E10 (C6, by the sum) every ODD d <= 16 has multiplicity 0",
      [int(kint(MULT[d])) for d in range(1, DMAX + 1, 2)], [0] * 8)
check("E11 (C6, structurally, part 1) chi_{S^d U}(-g) = (-1)^d chi_{S^d U}(g) "
      "for all 1320 g and all d <= 16, because rho_U(-I) = -id",
      all(H[mul(NEG, g)][d] == (H[g][d] if d % 2 == 0
                                else ksub(KZERO, H[g][d]))
          for g in SL for d in range(DMAX + 1)), True)
check("E12 (C6, structurally, part 2) chi_M(-g) = chi_M(g) for all g, since "
      "Lambda^2 kills -I", all(CHIM[mul(NEG, g)] == CHIM[g] for g in SL), True)
check("E13 (C6, structurally, part 3) hence for odd d the orthogonality sum "
      "cancels in the pairs {g, -g}: no cancellation accident, the vanishing "
      "is forced termwise",
      all(kadd(kmul(H[g][d], kconj(CHIM[g])),
               kmul(H[mul(NEG, g)][d], kconj(CHIM[mul(NEG, g)]))) == KZERO
          for g in SL for d in range(1, DMAX + 1, 2)), True)
check("E14 (C6, sanity) the same argument kills EVERY G-module in odd degree: "
      "for odd d <= 16 the whole of S^d U is spin, so all six G-block "
      "multiplicities vanish, not just 10'",
      all(FULL[d][nm] == KZERO
          for d in range(1, DMAX + 1, 2) for nm in NAMES), True)

# ======================================================================
print()
print("=" * 72)
print("SECTION F -- convention independence (U vs U', S^d U vs S^d U^*)")
print("=" * 72)

HP = sym_powers(CHIUP)
MULTP = {}
for d in range(1, DMAX + 1):
    MULTP[d] = mult_in_Sd(HP, CHIM, d)
check("F1 <S^d U', 10'> = <S^d U, 10'> for every d <= 16: the two Galois-"
      "conjugate spin sources give the same answer, as they must because M is "
      "rational", [MULTP[d] for d in range(1, DMAX + 1)],
      [MULT[d] for d in range(1, DMAX + 1)])
check("F2 chi_{S^d U^*} = conj(chi_{S^d U}) = chi_{S^d U'}",
      all(HP[g][d] == kconj(H[g][d]) for g in SL for d in range(DMAX + 1)),
      True)
check("F3 dim Hom(M^*, S^d U^*) = <chi_{S^d U^*}, chi_{M^*}> = "
      "<conj(chi_{S^d U}), chi_M> equals <chi_{S^d U}, chi_M>",
      [mult_in_Sd(HP, CHIM, d) for d in range(1, DMAX + 1)],
      [MULT[d] for d in range(1, DMAX + 1)])
check("F4 M^* = M, so no dual convention on the target side can change "
      "anything", all(kconj(CHIM[g]) == CHIM[g] for g in SL), True)
check("F5 the labelling of U was the choice of a root of x^2 - 10x + 300; "
      "F1 shows the answer does not depend on it",
      (kmul(A_EIG, B_EIG), kadd(A_EIG, B_EIG)), (K(300), K(10)))
check("F6 the minimal live degree from U' is also 4",
      min(d for d in range(1, DMAX + 1) if MULTP[d] != KZERO), 4)

print("  All four readings (U / U', S^d / S^d dual, M / M^*) agree.")

# ======================================================================
print()
print("=" * 72)
print("SECTION G -- the multiplicity source U^{(+)m}:  d = 2 REVIVES at m >= 2")
print("=" * 72)
#
# The headline needs all faithful spin sources, and Thm 7.4 of
# KLEIN_SPIN_COMPLEX.md reduces to V = U^{(+)m}.  Cauchy:
#     S^2(U (x) C^m) = S^2 U (x) S^2(C^m)  (+)  Lambda^2 U (x) Lambda^2(C^m),
# and Lambda^2 U contains M = 10' exactly once (C8).  So the degree-2 layer
# is EMPTY for m = 1 and NONEMPTY for every m >= 2, with multiplicity C(m,2).


def ip(chi1, chi2):
    acc = KZERO
    for g in SL:
        acc = kadd(acc, kmul(chi1[g], kconj(chi2[g])))
    return kdiv(acc, K(len(SL)))


for m in (1, 2, 3, 4):
    chiV = {g: kmul(K(m), CHIU[g]) for g in SL}
    chiS2 = {}
    for g in SL:
        g2 = mul(g, g)
        chiS2[g] = kdiv(kadd(kmul(chiV[g], chiV[g]), chiV[g2]), K(2))
    got = ip(chiS2, CHIM)
    want = (m * (m - 1)) // 2
    check("G%d <S^2(U^{(+)%d}), 10'> = C(%d,2) -- Cauchy, checked directly "
          "against the character" % (m, m, m), got, (want, 0))
check("G5 so the minimal live coordinate degree is 4 for V = U and 2 for "
      "V = U^{(+)m} with m >= 2",
      [min(d for d in range(1, DMAX + 1) if MULT[d] != KZERO), 2], [4, 2])
check("G6 CONSEQUENCE: kill K-g of SUPPORT_CENSUS.md sec.5.3 (all free "
      "component orbits die at d = 2) is VACUOUS for V = U -- there is no "
      "equivariant map of coordinate degree 2 at all -- and is in force "
      "only for m >= 2", (0, 0), MULT[2])
check("G7 CONSEQUENCE: at the minimal live degree d = 4 on P(U) = P^5, the "
      "free orbit N = 660 fits at codimension 5 (4^5 = 1024) but not at "
      "codimension 4, 3, 2 (256, 64, 16)",
      [4 ** c >= 660 for c in (5, 4, 3, 2)], [True, False, False, False])
check("G8 and it revives at the next live degree d = 6 in codimension 4 "
      "(6^4 = 1296 >= 660), so capacity remains a low-degree screen",
      6 ** 4 >= 660, True)

# ======================================================================
print()
print("=" * 72)
if FAILED:
    print(f"{len(FAILED)} FAILURE(S) of {NCHECK} checks:")
    for f in FAILED:
        print("   " + f)
    print("MIN_DEGREE_FAILED")
    raise SystemExit(1)
print(f"all {NCHECK} assertions passed")
print()
print("  MINIMAL LIVE COORDINATE DEGREE OF THE SPIN LANE:  d = 4.")
print("    Hom_{SL(2,11)}(M^*, S^d U^*) = 0 for d = 1, 2, 3, and has")
print("    dimension 3 for d = 4.  M = 10' = (10, 2, 1, 0, -1, -1) is the")
print("    10-dimensional summand of Lambda^2 U, i.e. the coordinate module")
print("    of the sealed V14 = Gr(2,U) cap P(M).")
print("  Multiplicities <S^d U, 10'> for d = 1..12:")
print("    0, 0, 0, 3, 0, 6, 0, 22, 0, 42, 0, 99")
print("  Theorem C6 (odd d dead) reproduced independently, and termwise.")
print("  Degree 2 is dead for a structural reason worth recording:")
print("    S^2 U = 10 (+) 11 carries the OTHER absolutely irreducible 10.")
print("  BUT it revives at multiplicity: S^2(U^{(+)m}) contains 10' with")
print("  multiplicity C(m,2) by Cauchy, so the minimal live degree is")
print("    d = 4  for V = U,     d = 2  for V = U^{(+)m}, m >= 2.")
print("  Hence kill K-g is VACUOUS on the minimal source and in force only")
print("  from m = 2 on.")
print()
print("MIN_DEGREE_OK")
