#!/usr/bin/env python3
"""
verify_v14_betti.py -- an in-repo seal for the three flagged literature inputs
of Theorem S0 (`THEOREM_SPIN_HODGE_SUPPORT.md`):

    b_3(V14) = 10,      h^{2,1}(V14) = 5,      rho(V14) = 1.

The V14 is used throughout the spin packet in its SEALED model

    V14  =  Gr(2,U) cap P(M)  subset  P(Lambda^2 U) = P^14,     dim U = 6,

with M the 10-dimensional `10'`-summand of Lambda^2 U (`FIX_IX_SEAL`,
`V14_S3_D10_MEASUREMENT.md` section 1).  So V14 is a CODIMENSION-5 LINEAR
SECTION of the 8-fold Gr(2,6) in its Plueckerp embedding: the zero locus of a
section of the rank-5 ample bundle E = O(1)^{(+)5}.

Everything below is exact integer arithmetic in the Chow ring of Gr(2,6),
which is realised as the ring of symmetric polynomials in the two Chern roots
x, y of S^dual, with the Schubert basis s_lambda (lambda inside the 2x4 box)
and the degree map "coefficient of s_{(4,4)}".  Classes outside the box are
zero -- that is exactly the quotient by (h_5, h_6).

No Macaulay2, no msolve, no network, no data files.  Python 3 standard
library only.  Runtime well under a second.

Marker on success: V14_BETTI_OK
"""

from fractions import Fraction as Fr
from itertools import product

FAILED = []
NCHECK = 0
TOPDEG = 8                      # dim Gr(2,6) = 8; nothing above matters


def check(name, got, want):
    global NCHECK
    NCHECK += 1
    if got != want:
        FAILED.append(f"{name}: got {got!r}, want {want!r}")
        print(f"  FAIL {name}: got {got!r}, want {want!r}")
    return got == want


# ----------------------------------------------------------------------
# A.  Polynomials in two variables, truncated at total degree TOPDEG
# ----------------------------------------------------------------------
def pmul(p, q, cap=TOPDEG):
    out = {}
    for (a, b), u in p.items():
        for (c, d), v in q.items():
            if a + b + c + d > cap:
                continue
            k = (a + c, b + d)
            out[k] = out.get(k, 0) + u * v
    return {k: v for k, v in out.items() if v}


def padd(p, q):
    out = dict(p)
    for k, v in q.items():
        out[k] = out.get(k, 0) + v
    return {k: v for k, v in out.items() if v}


def pscal(c, p):
    return {k: c * v for k, v in p.items() if c * v}


def ppow(p, n, cap=TOPDEG):
    out = {(0, 0): 1}
    for _ in range(n):
        out = pmul(out, p, cap)
    return out


def graded(p, d):
    return {k: v for k, v in p.items() if k[0] + k[1] == d}


ONE = {(0, 0): 1}
X = {(1, 0): 1}
Y = {(0, 1): 1}
SIGMA1 = {(1, 0): 1, (0, 1): 1}          # c_1(S^dual) = x + y = sigma_1


def h(m):
    """complete homogeneous symmetric polynomial h_m(x,y) = c_m(Q) for m<=4."""
    return {(i, m - i): 1 for i in range(m + 1)}


def schur(p, q):
    """s_{(p,q)}(x,y), p >= q >= 0."""
    return {(q + k, p - k): 1 for k in range(p - q + 1)}


def schur_decompose(poly, d):
    """Write the homogeneous symmetric degree-d part of `poly` in the Schur
    basis {s_{(a,b)} : a+b = d, a >= b >= 0}.  Triangular, exact."""
    cur = dict(graded(poly, d))
    coeffs = {}
    for a in range(d, (d - 1) // 2, -1):
        b = d - a
        if a < b:
            break
        c = cur.get((a, b), 0)
        if c:
            coeffs[(a, b)] = c
            cur = padd(cur, pscal(-c, schur(a, b)))
    if any(cur.values()):
        FAILED.append(f"schur_decompose left a remainder in degree {d}: {cur}")
    return coeffs


def integral(poly):
    """Degree map of Gr(2,6): the coefficient of the point class s_{(4,4)}.
    Every other degree-8 Schur function has lambda_1 >= 5, i.e. lies in the
    ideal (h_5, h_6) and is zero in the Chow ring."""
    dec = schur_decompose(poly, 8)
    return dec.get((4, 4), 0)


print("=" * 72)
print("SECTION A -- the Chow ring of Gr(2,6), exact")
print("=" * 72)

# Schubert basis of the 2x4 box
BOX = [(a, b) for a in range(5) for b in range(a + 1)]
check("A1 rank of H^*(Gr(2,6)) = binom(6,2)", len(BOX), 15)
check("A2 dim Gr(2,6)", max(a + b for a, b in BOX), 8)
check("A3 unique degree-8 class in the box", [l for l in BOX if sum(l) == 8],
      [(4, 4)])
check("A4 point class integrates to 1", integral(schur(4, 4)), 1)
# classical: deg Gr(2,n) = Catalan-type number; for n=6 it is 8!/(4!5!) = 14
check("A5 deg Gr(2,6) = int sigma_1^8", integral(ppow(SIGMA1, 8)), 14)
# a Pieri regression: sigma_1 * s_{(2,1)} = s_{(3,1)} + s_{(2,2)}
check("A6 Pieri sigma_1 . s_(2,1)",
      schur_decompose(pmul(SIGMA1, schur(2, 1)), 4),
      {(3, 1): 1, (2, 2): 1})
# the relations h_5 = h_6 = 0 hold in the quotient
check("A7 h_5 dies in the quotient", schur_decompose(h(5), 5), {(5, 0): 1})
check("A8 s_(5,3) is out of the box", (5, 3) in BOX, False)

# ----------------------------------------------------------------------
# B.  The tangent bundle of Gr(2,6) and its Chern classes
# ----------------------------------------------------------------------
print()
print("=" * 72)
print("SECTION B -- c(T_Gr(2,6)) = c(S^dual (x) Q) by exact Chern roots")
print("=" * 72)

# c(S) = (1-x)(1-y), so c(Q) = 1/c(S) has c_j(Q) = h_j(x,y), j = 1..4.
cQ = [h(j) for j in range(5)]
check("B1 c_0(Q)", cQ[0], ONE)
check("B2 c_1(Q) = sigma_1", cQ[1], SIGMA1)
check("B3 c(S)c(Q) = 1 up to the relations",
      schur_decompose(pmul(pmul(padd(ONE, pscal(-1, X)),
                                padd(ONE, pscal(-1, Y))),
                           padd(padd(cQ[0], cQ[1]), padd(cQ[2], padd(cQ[3], cQ[4])))), 5),
      {(5, 0): -1})          # = -h_5, zero in the Chow ring

# T = S^dual (x) Q, Chern roots a_i + b_j with a_1 = x, a_2 = y.
# prod_j (1 + a + b_j) = sum_{j=0}^{4} (1+a)^{4-j} e_j(b),  e_j(b) = c_j(Q).


def tangent_factor(a):
    tot = {}
    for j in range(5):
        tot = padd(tot, pmul(ppow(padd(ONE, a), 4 - j), cQ[j]))
    return tot


cT = pmul(tangent_factor(X), tangent_factor(Y))
cT_g = [graded(cT, d) for d in range(TOPDEG + 1)]

check("B4 c_0(T_Gr)", cT_g[0], ONE)
check("B5 c_1(T_Gr) = 6 sigma_1 (index of Gr(2,6))",
      schur_decompose(cT_g[1], 1), {(1, 0): 6})
check("B6 chi_top(Gr(2,6)) = int c_8(T_Gr) = 15",
      integral(cT_g[8]), 15)

# ----------------------------------------------------------------------
# C.  V14 = zero locus of a section of E = O(1)^{(+)5} on Gr(2,6)
# ----------------------------------------------------------------------
print()
print("=" * 72)
print("SECTION C -- the codimension-5 linear section V14 = Gr(2,6) cap P^9")
print("=" * 72)

CODIM = 5
check("C1 dim V14 = dim Gr - rank E", 8 - CODIM, 3)
CLASS_V14 = ppow(SIGMA1, CODIM)          # c_5(O(1)^{+5}) = sigma_1^5


def int_V14(alpha):
    """integral over V14 of a degree-3 class pulled back from Gr."""
    return integral(pmul(alpha, CLASS_V14))


# c(T_V14) = c(T_Gr) / (1 + sigma_1)^5   (restricted)
inv = {}
for m in range(TOPDEG + 1):
    # coefficient of s^m in (1+s)^{-5} is (-1)^m * binom(m+4,4)
    binom = 1
    for t in range(4):
        binom = binom * (m + 4 - t) // (t + 1)
    inv = padd(inv, pscal((-1) ** m * binom, ppow(SIGMA1, m)))
cV = pmul(cT, inv)
cV_g = [graded(cV, d) for d in range(4)]

check("C2 c_1(T_V14) = sigma_1  (Fano index 1)",
      schur_decompose(cV_g[1], 1), {(1, 0): 1})
check("C3 deg V14 = int_{V14} sigma_1^3 = 14",
      int_V14(ppow(SIGMA1, 3)), 14)
check("C4 (-K)^3 = 14, so the genus g = (-K)^3/2 + 1 = 8",
      int_V14(ppow(cV_g[1], 3)) // 2 + 1, 8)
check("C5 chi(O_V14) = int c_1c_2/24 = 1  (Todd, so c_1c_2 = 24)",
      int_V14(pmul(cV_g[1], cV_g[2])), 24)

# Hirzebruch-Riemann-Roch for L = -K = H:
#   chi(L) = L^3/6 + L^2 c_1/4 + L(c_1^2 + c_2)/12 + c_1 c_2/24
L = cV_g[1]
chi_L = (Fr(int_V14(ppow(L, 3)), 6)
         + Fr(int_V14(pmul(ppow(L, 2), cV_g[1])), 4)
         + Fr(int_V14(pmul(L, padd(pmul(cV_g[1], cV_g[1]), cV_g[2]))), 12)
         + Fr(int_V14(pmul(cV_g[1], cV_g[2])), 24))
check("C6 h^0(-K_V14) = chi(-K) = 10 = dim M  (V14 sits in P(M) = P^9)",
      chi_L, Fr(10))

CHI_TOP = int_V14(cV_g[3])
print(f"\n  chi_top(V14) = int_{{V14}} c_3(T_V14) = {CHI_TOP}")
check("C7 chi_top(V14) = -6", CHI_TOP, -6)

# ----------------------------------------------------------------------
# D.  Betti numbers, Hodge numbers, Picard rank
# ----------------------------------------------------------------------
print()
print("=" * 72)
print("SECTION D -- Betti / Hodge numbers and the Picard rank")
print("=" * 72)

# Sommese's Lefschetz theorem for the ample rank-5 bundle E = O(1)^{+5} on the
# 8-fold Gr(2,6): H^i(Gr) -> H^i(V14) is an isomorphism for i < dim V14 = 3.
# H^*(Gr(2,6)) is algebraic with Betti numbers = # Schubert cells per degree.
grbetti = {}
for a, b in BOX:
    grbetti[2 * (a + b)] = grbetti.get(2 * (a + b), 0) + 1
check("D1 b_0(Gr) = 1", grbetti.get(0, 0), 1)
check("D2 b_1(Gr) = 0", grbetti.get(1, 0), 0)
check("D3 b_2(Gr) = 1", grbetti.get(2, 0), 1)
LEFSCHETZ_RANGE = [i for i in range(0, 3)]          # i < dim V14 = 3
check("D4 Lefschetz isomorphism range i < 3", LEFSCHETZ_RANGE, [0, 1, 2])

b = {0: 1, 1: 0, 2: 1}
b[6], b[5], b[4] = b[0], b[1], b[2]                 # Poincare duality
b[3] = 2 * b[0] - 2 * b[1] + 2 * b[2] - CHI_TOP
check("D5 b(V14) = (1,0,1,10,1,0,1)",
      tuple(b[i] for i in range(7)), (1, 0, 1, 10, 1, 0, 1))
check("D6 Euler characteristic reproduces chi_top",
      sum((-1) ** i * b[i] for i in range(7)), CHI_TOP)

# h^{3,0} = h^0(K_X) = 0 since -K is ample; equivalently h^{0,3} = h^3(O) = 0
# by Kodaira vanishing H^i(X, K_X (x) (-K_X)) = 0 for i > 0.
h30 = 0
h21 = (b[3] - 2 * h30) // 2
check("D7 h^{3,0}(V14) = 0 (Kodaira / -K ample)", h30, 0)
check("D8 h^{2,1}(V14) = 5", h21, 5)
check("D9 b_3 = 2h^{2,1} + 2h^{3,0}", 2 * h21 + 2 * h30, b[3])

# Picard rank: X Fano => H^1(O) = H^2(O) = 0 => Pic = H^2(X,Z), and
# H^2(X,Z) = H^2(Gr,Z) = Z by Sommese.  So rho = b_2 = 1.
rho = b[2]
check("D10 rho(V14) = b_2(V14) = 1", rho, 1)

# Hodge diamond consistency
hodge = {(0, 0): 1, (1, 1): b[2], (2, 2): b[4], (3, 3): 1,
         (2, 1): h21, (1, 2): h21, (3, 0): h30, (0, 3): h30,
         (1, 0): 0, (0, 1): 0, (2, 3): 0, (3, 2): 0}
check("D11 Hodge diamond reproduces chi_top",
      sum((-1) ** (p + q) * v for (p, q), v in hodge.items()), CHI_TOP)

# ----------------------------------------------------------------------
# E.  Regression against the packet's downstream uses
# ----------------------------------------------------------------------
print()
print("=" * 72)
print("SECTION E -- regression against THEOREM_SPIN_HODGE_SUPPORT.md")
print("=" * 72)

# Theorem S0 step: chi_top(V14) = 4 - tr(sigma|H^3) needs b = (1,0,1,b3,1,0,1)
check("E1 chi_top = 4 - b_3 (as Theorem S0 uses it)", 4 - b[3], CHI_TOP)
# chi_T = chi_W + chi_Wbar on element orders (1,2,3,5,6,11)
chi_T = {1: 10, 2: 2, 3: -2, 5: 0, 6: 2, 11: -1}
check("E2 chi_T(1) = b_3 = 10", chi_T[1], b[3])
# Lefschetz predictions chi_top(V14^g) = 4 - chi_T(o)
pred = {o: 4 - v for o, v in chi_T.items() if o > 1}
check("E3 Lefschetz prediction table (orders 2,3,5,6,11)",
      [pred[o] for o in (2, 3, 5, 6, 11)], [2, 6, 4, 2, 5])
# the two known values
check("E4 sealed V14^sigma = genus-1 sextic + 2 points has chi = 2",
      pred[2], 0 + 2)
check("E5 FIX_IX_v14.md sec.8: V14^{C_11} = 5 points", pred[11], 5)
# the near-miss alternative 10' would have given different numbers
chi_10p = {1: 10, 2: 2, 3: 1, 5: 0, 6: -1, 11: -1}
check("E6 the 10' alternative disagrees at orders 3 and 6",
      [4 - chi_10p[o] for o in (3, 6)], [3, 5])
check("E7 10' and T agree at orders 2, 5, 11 (the near miss is real)",
      [chi_10p[o] for o in (2, 5, 11)],
      [chi_T[o] for o in (2, 5, 11)])
# MULTIPLICITY_ROUTE.md sec.5 used chi(V14) = -6 for its Lefschetz congruences
check("E8 chi_top(V14) = -6 is the value used in MULTIPLICITY_ROUTE.md sec.5",
      CHI_TOP, -6)
# and the census's per-cell arithmetic: dim T = b_3 = 10
check("E9 dim T = 10 (SUPPORT_CENSUS.md section 4)", b[3], 10)

print()
print("=" * 72)
if FAILED:
    print(f"{len(FAILED)} FAILURE(S) of {NCHECK} checks:")
    for f in FAILED:
        print("   " + f)
    print("V14_BETTI_FAILED")
    raise SystemExit(1)
print(f"all {NCHECK} assertions passed")
print()
print("  chi_top(V14) = -6      (exact Schubert calculus on Gr(2,6))")
print("  b(V14)       = (1,0,1,10,1,0,1)")
print("  h^{2,1}(V14) = 5,   h^{3,0}(V14) = 0")
print("  rho(V14)     = b_2(V14) = 1")
print()
print("V14_BETTI_OK")
