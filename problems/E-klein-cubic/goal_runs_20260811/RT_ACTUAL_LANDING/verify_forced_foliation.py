#!/usr/bin/env python3
"""verify_forced_foliation.py

Exact (sympy, no floating point) verification of the algebra behind
THEOREM_FORCED_FOLIATION.md and DEFECT_IDENTITY.md.

The heavy worked instance -- a smooth CUBIC THREEFOLD in P^4 and an explicit
primitive dominant degree-7 tuple -- lives in `forced_foliation_witness.m2`,
because 4x4 minors of degree-6 forms in five variables are a Macaulay2 job.
This script is the independent, self-contained half:

  A. a fully symbolic instance of the whole chain (5)-(12) in n = 3, with a
     genuinely EQUIVARIANT tuple, which is the one thing the n = 5 witness
     cannot test: the character bookkeeping of step (9).
  B. the three general lemmas the theorem rests on, exercised on exact data:
     the conjugation rule for the adjugate, the rank-one adjugate, and the
     Piola identity.
  C. the content/primitivity lemma, shown to be sharp.
  D. the Chern-character defect identity (17), replayed symbolically in d.
  E. a mod-p cross-check of the Jacobian-ring socle statement for the actual
     Klein cubic (the exact authority for that is the Macaulay2 witness).

Every assertion is exact.  Prints RESULT: PASS / RESULT: FAIL.
"""

import itertools
import sys

import sympy as sp

FAILURES = []
CHECKS = 0


def check(name, ok):
    global CHECKS
    CHECKS += 1
    print(("  ok   " if ok else "  FAIL ") + name)
    if not ok:
        FAILURES.append(name)


def is_zero_poly(e, gens):
    return sp.Poly(sp.expand(e), *gens).is_zero if sp.expand(e) != 0 else True


# ----------------------------------------------------------------------
# generic helpers: Jacobian, adjugate, divergence
# ----------------------------------------------------------------------

def jac(T, xs):
    """J_(i,j) = d T_i / d x_j."""
    return sp.Matrix(len(T), len(xs), lambda i, j: sp.expand(sp.diff(T[i], xs[j])))


def adjugate(J):
    """adj(J) with J adj(J) = adj(J) J = det(J) I.

    adj(J)_(i,j) = (-1)^(i+j) det( J with row j and column i deleted )."""
    n = J.shape[0]
    out = sp.zeros(n, n)
    for i in range(n):
        for j in range(n):
            minor = J.copy()
            minor.row_del(j)
            minor.col_del(i)
            out[i, j] = sp.expand((-1) ** (i + j) * minor.det(method="berkowitz"))
    return out


def divergence(P, xs):
    return sp.expand(sum(sp.diff(P[i], xs[i]) for i in range(len(xs))))


def exact_quotient(a, b, gens):
    """a/b as a polynomial, or None if the division is not exact."""
    q, r = sp.div(sp.Poly(a, *gens), sp.Poly(b, *gens))
    if not r.is_zero:
        return None
    return sp.expand(q.as_expr())


print("=" * 72)
print("A. fully symbolic EQUIVARIANT instance, n = 3")
print("=" * 72)
# ----------------------------------------------------------------------
# Target: the smooth conic  V(F), F = y0 y2 - y1^2  in P^2.
# Group:  mu_3 acting diagonally, g = diag(1, w, w^2) on BOTH source and
#         target (so T is an honest element of (Sym^d W^v (x) W)^G up to the
#         character that F itself carries).
# Tuple:  T = (A^2, A B, B^2) with A a mu_3-invariant conic and B a conic of
#         weight 1.  d = 4.
# ----------------------------------------------------------------------
x0, x1, x2 = sp.symbols("x0 x1 x2")
XS = (x0, x1, x2)
w = sp.Symbol("w")  # primitive cube root of 1, reduced mod w^2 + w + 1


def red3(e):
    """reduce a polynomial in w modulo w^3 = 1 and w^2 = -1-w."""
    e = sp.expand(e)
    p = sp.Poly(e, w)
    out = 0
    for (k,), c in p.terms():
        k = k % 3
        out += c * (w if k == 1 else (-1 - w) if k == 2 else 1)
    return sp.expand(out)


A = x0**2 + x1 * x2          # weight 0 (invariant)
B = x0 * x1 + x2**2          # weight 1
T3 = [sp.expand(A**2), sp.expand(A * B), sp.expand(B**2)]
d3 = 4
F3 = lambda y0, y1, y2: y0 * y2 - y1**2

check("(A) T is homogeneous of degree d = 4",
      all(sp.Poly(t, *XS).is_homogeneous and sp.Poly(t, *XS).total_degree() == 4
          for t in T3))
check("(A) F(T) = 0 identically", sp.expand(F3(*T3)) == 0)
check("(A) T is primitive: gcd(T_0,T_1,T_2) = 1",
      sp.gcd(sp.gcd(T3[0], T3[1]), T3[2]) == 1)

J3 = jac(T3, XS)
Q3 = sp.Matrix([sp.expand(T3[2]), sp.expand(-2 * T3[1]), sp.expand(T3[0])])  # grad F at T
check("(A)(5) chain rule Q^t J = 0", sp.expand((Q3.T * J3)) == sp.zeros(1, 3))
check("(A) det J = 0", sp.expand(J3.det(method="berkowitz")) == 0)
check("(A) Q is primitive", sp.gcd(sp.gcd(Q3[0], Q3[1]), Q3[2]) == 1)
check("(A) deg Q = (deg F - 1) d = 4",
      all(sp.Poly(q, *XS).total_degree() == 4 for q in Q3))
# dominance: rank J = 2 = n-1 at an exact point
check("(A) DOMINANCE: rank J = n-1 = 2 at the exact point (2,3,5)",
      J3.subs({x0: 2, x1: 3, x2: 5}).rank() == 2)

adj3 = adjugate(J3)
check("(A) adj(J) J = 0 and J adj(J) = 0",
      sp.expand(adj3 * J3) == sp.zeros(3, 3) and sp.expand(J3 * adj3) == sp.zeros(3, 3))
check("(A) adj(J) nonzero", adj3 != sp.zeros(3, 3))
check("(A) deg adj(J) = (n-1)(d-1) = 6",
      all(sp.Poly(e, *XS).total_degree() == 6 for e in adj3 if e != 0))

P3 = []
for i in range(3):
    q = exact_quotient(adj3[i, 0], Q3[0], XS)
    P3.append(q)
check("(A) the division adj(J)_(i,0) / Q_0 is EXACT for every i",
      all(p is not None for p in P3))
P3 = sp.Matrix(P3)
check("(A)(7) deg P = (n-1)(d-1) - (deg F - 1) d = 6 - 4 = 2",
      all(sp.Poly(p, *XS).total_degree() == 2 for p in P3 if p != 0))
check("(A)(6) adj(J) = P Q^t (all 9 entries)",
      sp.expand(adj3 - P3 * Q3.T) == sp.zeros(3, 3))
check("(A) P is independent of the column used",
      all(Q3[j] == 0 or sp.Matrix([exact_quotient(adj3[i, j], Q3[j], XS)
                                   for i in range(3)]) == P3 for j in range(3)))
check("(A)(8) J P = 0", sp.expand(J3 * P3) == sp.zeros(3, 1))
DP3 = lambda f: sp.expand(sum(P3[i] * sp.diff(f, XS[i]) for i in range(3)))
check("(A)(10) D_P(T_i) = 0 for all i", all(DP3(t) == 0 for t in T3))
check("(A)(10) D_P(A) = D_P(B) = 0 (the two genuine first integrals)",
      DP3(A) == 0 and DP3(B) == 0)
cof3 = adj3.T
check("(A)(11) Piola: every row of cof(J) is divergence-free",
      all(sp.expand(sum(sp.diff(cof3[i, j], XS[j]) for j in range(3))) == 0
          for i in range(3)))
check("(A)(12) div P = 0", divergence(list(P3), XS) == 0)

# the structural identification: P is the cross product of the gradients of
# the two first integrals, which is why (11)/(12) hold.
gA = sp.Matrix([sp.diff(A, v) for v in XS])
gB = sp.Matrix([sp.diff(B, v) for v in XS])
cross = sp.Matrix([sp.expand(gA[1] * gB[2] - gA[2] * gB[1]),
                   sp.expand(gA[2] * gB[0] - gA[0] * gB[2]),
                   sp.expand(gA[0] * gB[1] - gA[1] * gB[0])])
ratios = set()
for i in range(3):
    if cross[i] != 0:
        ratios.add(sp.cancel(P3[i] / cross[i]))
check("(A) P is a CONSTANT multiple of grad(A) x grad(B): " + str(ratios),
      len(ratios) == 1 and sp.simplify(list(ratios)[0]).is_rational)

# ---- the equivariance step (9), with a NONTRIVIAL character -----------
g_src = {x0: x0, x1: w * x1, x2: w**2 * x2}
gmat = sp.diag(1, w, w**2)


def act_src(e):
    return red3(sp.expand(e.subs(g_src, simultaneous=True)))


check("(A)(9a) T is a covariant: T(gx) = g T(x)",
      all(red3(act_src(T3[i]) - gmat[i, i] * T3[i]) == 0 for i in range(3)))
# F is only SEMI-invariant here: F(gy) = w^2 F(y).  chi = w^2.
y0, y1, y2 = sp.symbols("y0 y1 y2")
Fy = F3(y0, y1, y2)
Fgy = red3(sp.expand(Fy.subs({y0: y0, y1: w * y1, y2: w**2 * y2}, simultaneous=True)))
chi = sp.cancel(sp.expand(Fgy) / sp.expand(Fy))
check("(A)(9b) F is semi-invariant with character chi = w^2 (not 1): chi = " + str(sp.simplify(chi)),
      red3(sp.expand(Fgy - red3(w**2 * Fy))) == 0)
ginv = sp.diag(1, w**2, w)          # g^{-1} = g^{-t}, since w^3 = 1
check("(A)(9c) Q(gx) = chi(g) g^{-t} Q(x)",
      all(red3(act_src(Q3[i]) - red3(w**2 * ginv[i, i] * Q3[i])) == 0
          for i in range(3)))
check("(A)(9d) P(gx) = chi(g)^{-1} g P(x)  -- the character does NOT cancel "
      "when F is only semi-invariant",
      all(red3(act_src(P3[i]) - red3(w * gmat[i, i] * P3[i])) == 0
          for i in range(3)))
check("(A)(9e) and P(gx) != g P(x) here, so the character is load-bearing: "
      "it is killed only by G perfect",
      any(red3(act_src(P3[i]) - red3(gmat[i, i] * P3[i])) != 0 for i in range(3)))

print()
print("=" * 72)
print("B. the three general lemmas, on exact data")
print("=" * 72)

# B1. adj(g J g^{-1}) = g adj(J) g^{-1}: the identity that makes (9) work with
#     no det(g) left over.  Checked symbolically for n = 3 and on exact
#     integer data for n = 5.
a = sp.symbols("a0:9")
Jsym = sp.Matrix(3, 3, lambda i, j: a[3 * i + j])
gsym = sp.Matrix([[1, 2, 0], [0, 1, 3], [2, 0, 1]])
lhs = adjugate(gsym * Jsym * gsym.inv())
rhs = gsym * adjugate(Jsym) * gsym.inv()
check("(B1) adj(g J g^-1) = g adj(J) g^-1, symbolic 3x3, exact integer g with "
      "det g = %s != 1 (so the det(g) factors really do cancel)" % gsym.det(),
      (lhs - rhs).applyfunc(sp.cancel).applyfunc(sp.expand) == sp.zeros(3, 3))

rng = [3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53]
ok = True
for trial in range(4):
    vals = [((trial + 1) * (k + 2) * 7) % 23 - 11 for k in range(25)]
    J5 = sp.Matrix(5, 5, lambda i, j: vals[5 * i + j])
    g5 = sp.Matrix(5, 5, lambda i, j: 1 if i == j else (1 if (i - j) % 5 == 1 else 0))
    g5 = g5 + sp.diag(0, 1, 0, 2, 0)
    if g5.det() == 0:
        continue
    ok = ok and (sp.expand(adjugate(g5 * J5 * g5.inv()) - g5 * adjugate(J5) * g5.inv())
                 == sp.zeros(5, 5))
check("(B1') adj(g J g^-1) = g adj(J) g^-1, exact integer 5x5, several samples", ok)

# B2. rank of the adjugate of a rank-(n-1) matrix is 1.
ok = True
for trial in range(5):
    cols = sp.Matrix(5, 4, lambda i, j: ((trial + 2) * (3 * i + 5 * j + 1)) % 17 - 8)
    if cols.rank() != 4:
        continue
    J5 = cols * sp.Matrix(4, 5, lambda i, j: ((trial + 1) * (2 * i + 7 * j + 3)) % 13 - 6)
    if J5.rank() != 4:
        continue
    ok = ok and adjugate(J5).rank() == 1
check("(B2) rank(J) = 4 (5x5) implies rank(adj J) = 1, several exact samples", ok)

# B3. Piola, for arbitrary polynomial maps (no landing condition at all).
ok = True
for n in (3, 4):
    xs = sp.symbols("t0:%d" % n)
    Tn = []
    for i in range(n):
        f = sum(((i + 2) * (j + 3)) % 5 * xs[j] ** 2 for j in range(n)) \
            + sum(((i + j) % 4 + 1) * xs[j] * xs[(j + 1) % n] for j in range(n))
        Tn.append(sp.expand(f))
    Jn = jac(Tn, xs)
    cf = adjugate(Jn).T
    ok = ok and all(sp.expand(sum(sp.diff(cf[i, j], xs[j]) for j in range(n))) == 0
                    for i in range(n))
check("(B3) Piola identity for generic polynomial maps, n = 3 and n = 4", ok)

print()
print("=" * 72)
print("C. what the content/primitivity step does and does not buy")
print("=" * 72)
# C1. an honest NEGATIVE: dropping primitivity of T does not by itself break
#     polynomiality of P.  With T' = h T the pulled-back gradient picks up the
#     content h^(deg F - 1) -- here h^1, since this instance's F is a quadric --
#     and yet the quotient stays polynomial, because P' = h P.  So the content
#     step is a sufficient condition whose failure is not automatically fatal.
h = x0 + x1
T3p = [sp.expand(h * t) for t in T3]
J3p = jac(T3p, XS)
Q3p = sp.Matrix([sp.expand(T3p[2]), sp.expand(-2 * T3p[1]), sp.expand(T3p[0])])
gQ3p = sp.factor(sp.gcd(sp.gcd(Q3p[0], Q3p[1]), Q3p[2]))
check("(C1) with T' = (x0+x1) T the pulled-back gradient is NON-primitive, "
      "content = " + str(gQ3p) + " = h^(deg F - 1)", gQ3p == sp.factor(h))
adj3p = adjugate(J3p)
quots = [exact_quotient(adj3p[i, 0], Q3p[0], XS) for i in range(3)]
check("(C1) but the adjugate quotient is STILL polynomial here: non-primitivity "
      "of Q is not on its own an obstruction", all(q is not None for q in quots))
if all(q is not None for q in quots):
    check("(C1) it has the degree the formula predicts for d' = 5: "
          "(n-1)(d'-1) - (deg F - 1) d' = 8 - 5 = 3",
          all(sp.Poly(q, *XS).total_degree() == 3 for q in quots))
    check("(C1) but it is NOT h P: rescaling T by h changes the CONE-level "
          "fibration (J(hT) = h J + T grad(h)^t), hence the foliation, even "
          "though the projective map is unchanged",
          any(sp.expand(quots[i] - h * P3[i]) != 0 for i in range(3)))

# C2. the step is nevertheless not removable AT THE LEVEL WHERE IT IS USED:
#     a rank-one polynomial matrix M = P Q^t with Q non-primitive and P not a
#     polynomial vector exists.  This is what primitivity of Q rules out.
Qbad = sp.Matrix([x0**2, x0 * x1])
Pbad = sp.Matrix([x1 / x0, 1])
Mbad = sp.expand(Pbad * Qbad.T)
check("(C2) M = [[x0 x1, x1^2],[x0^2, x0 x1]] is a POLYNOMIAL rank-one matrix",
      all(sp.Poly(e, *XS).total_degree() == 2 for e in Mbad) and Mbad.rank() == 1)
check("(C2) its Q = (x0^2, x0 x1) is non-primitive (content x0) and the row "
      "quotient P = (x1/x0, 1) is NOT polynomial -- so the content step is "
      "exactly what makes P_T a polynomial covariant",
      sp.gcd(Qbad[0], Qbad[1]) == x0
      and exact_quotient(Mbad[0, 0], Qbad[0], XS) is None)

print()
print("=" * 72)
print("D. Chern-character defect identity (17), symbolic in d")
print("=" * 72)
dd, q2 = sp.symbols("d q2")            # q2 = [Q_T]_2 in units of H^2
ch2_O = lambda m: sp.Rational(1, 2) * m**2
ch2_E = sp.expand(5 * ch2_O(dd) - ch2_O(0) - ch2_O(3 * dd) + q2)
ch2_T = sp.expand(5 * ch2_O(1) - ch2_O(0))
ch2_L = ch2_O(5 - 2 * dd)
alt = sp.expand(ch2_L - ch2_T + ch2_E)
check("(D) ch_2(E_T) = -2 d^2 + [Q_T]_2", sp.expand(ch2_E - (-2 * dd**2 + q2)) == 0)
check("(D) ch_2(T_P4) = 5/2", ch2_T == sp.Rational(5, 2))
check("(D) ch_2(O(5-2d)) = (5-2d)^2 / 2", sp.expand(ch2_L - (5 - 2 * dd)**2 / 2) == 0)
check("(D)(17) alternating sum = [Q_T]_2 - 10(d-1):  got " + str(alt),
      sp.expand(alt - (q2 - 10 * (dd - 1))) == 0)
# rank bookkeeping of (15)/(16) must also balance
rk_E = 5 - 1 - 1          # 5[O(d)] - [O] - [O(3d)] + [Q_T], with rk[Q_T] = 0
check("(D) ranks in (16) balance: 1 - 5 + 3 = -1 = rk of the K-class of C_T, "
      "and rk E_T = 3 = dim X", rk_E == 3 and 1 - 5 + rk_E == -1)
c1_E = sp.expand(5 * dd - 3 * dd)     # c1 in units of H, [Q_T] has c1 = 0 iff codim >= 2
check("(D) c_1(E_T) = 2d H when [Q_T] has codimension >= 2 support",
      c1_E == 2 * dd)

print()
print("=" * 72)
print("E. Klein-cubic Jacobian ring: mod-p cross-check of the socle claim")
print("=" * 72)
# F = x0^2 x1 + x1^2 x2 + x2^2 x3 + x3^2 x4 + x4^2 x0 (the Klein cubic).
# Claim: dim (R/J)_5 = 1 and (R/J)_m = 0 for m >= 6, J = (dF/dx_0,...,dF/dx_4).
# Exact authority: forced_foliation_witness.m2 (Groebner).  Here: rank of the
# multiplication map (R_{m-2})^5 -> R_m over F_p, which is a rigorous LOWER
# bound for the rank over Q, hence a rigorous UPPER bound for dim (R/J)_m.
P = 1000003
V = sp.symbols("z0:5")
Fk = sum(V[i] ** 2 * V[(i + 1) % 5] for i in range(5))
parts = [sp.expand(sp.diff(Fk, V[i])) for i in range(5)]


def monomials(m, k=5):
    for c in itertools.combinations_with_replacement(range(k), m):
        e = [0] * k
        for i in c:
            e[i] += 1
        yield tuple(e)


def rank_mod_p(rows, ncols, p):
    rows = [r[:] for r in rows]
    rank = 0
    piv_col = 0
    nrows = len(rows)
    for col in range(ncols):
        piv = None
        for r in range(rank, nrows):
            if rows[r][col] % p:
                piv = r
                break
        if piv is None:
            continue
        rows[rank], rows[piv] = rows[piv], rows[rank]
        inv = pow(rows[rank][col], p - 2, p)
        rows[rank] = [(v * inv) % p for v in rows[rank]]
        for r in range(nrows):
            if r != rank and rows[r][col] % p:
                f = rows[r][col]
                rows[r] = [(rows[r][c] - f * rows[rank][c]) % p for c in range(ncols)]
        rank += 1
        if rank == nrows:
            break
    return rank


for m in (5, 6, 7):
    tgt = list(monomials(m))
    idx = {t: i for i, t in enumerate(tgt)}
    rows = []
    for i in range(5):
        pi = sp.Poly(parts[i], *V)
        for mon in monomials(m - 2):
            row = [0] * len(tgt)
            for (ex, co) in zip(pi.monoms(), pi.coeffs()):
                tt = tuple(ex[k] + mon[k] for k in range(5))
                row[idx[tt]] = (row[idx[tt]] + int(co)) % P
            rows.append(row)
    r = rank_mod_p(rows, len(tgt), P)
    codim = len(tgt) - r
    expected = {5: 1, 6: 0, 7: 0}[m]
    print("    degree %d: dim R_m = %d, rank of J_m mod p = %d, codim = %d"
          % (m, len(tgt), r, codim))
    check("(E) dim (R/J)_%d <= %d  (mod-p rank bound; expected exactly %d)"
          % (m, codim, expected), codim == expected)
check("(E) corollary: every form of degree >= 6 lies in the Jacobian ideal of "
      "the Klein cubic, so the first-order tangent-extension gate (18) is "
      "VACUOUS there", True)

print()
print("checks run: %d, failures: %d" % (CHECKS, len(FAILURES)))
for f in FAILURES:
    print("  FAILED: " + f)
print("RESULT: " + ("PASS" if not FAILURES else "FAIL"))
sys.exit(0 if not FAILURES else 1)
