#!/usr/bin/env python3
"""Formula self-tests, run on curves whose answers are known independently.

  (a) j from the invariants I, J of a binary quartic, against the cross-ratio
      formula j = 256 (l^2-l+1)^3 / (l^2 (l-1)^2) for the branch divisor
      {0, oo, 1, l}.
  (b) j from a Weierstrass cubic y^2 = c3 x^3 + c2 x^2 + c1 x + c0, against
      1728*4a^3/(4a^3+27b^2) after reduction to short form.
  (c) the WHOLE branch-quartic extraction (odd quadrics -> the 3x2 matrix A(v)
      -> Cramer parametrisation nu(s,t) -> R(s,t)) run on the degree-6 model of
      a KNOWN elliptic curve y^2 = x^3 + a x + b embedded by |6.O|, checked
      against that curve's j.
  (d) the classical modular polynomial Phi_2 quoted in the brief, checked to
      vanish on genuinely 2-isogenous pairs produced by the standard
      2-isogeny  y^2 = x^3+Ax^2+Bx  ->  y^2 = x^3-2Ax^2+(A^2-4B)x.
"""
from fractions import Fraction as F
from itertools import combinations

ck = []
def CHECK(name, ok, detail):
    ck.append(bool(ok))
    print(f"CHECK {name} {'PASS' if ok else 'FAIL'} {detail}")

# ---------- (a) binary quartic invariants ----------
def j_quartic(a, b, c, d, e):
    I = 12*a*e - 3*b*d + c*c
    J = 72*a*c*e + 9*b*c*d - 27*a*d*d - 27*e*b*b - 2*c**3
    return F(6912*I**3, 4*I**3 - J*J), I, J

def poly_mul(P, Q):
    R = [F(0)]*(len(P)+len(Q)-1)
    for i, x in enumerate(P):
        for j, y in enumerate(Q): R[i+j] += x*y
    return R

for lam in (F(2), F(3), F(-5), F(7,3), F(1,4), F(11,2)):
    # R(s,t) = t*(s-t)*(s - lam t)*s  -> branch points s/t = 0, oo, 1, lam
    # write as a quartic in s with t = 1: s*(s-1)*(s-lam)  ... plus the root at
    # infinity, encoded by a vanishing leading coefficient.
    q = poly_mul(poly_mul([F(0), F(1)], [-F(1), F(1)]), [-lam, F(1)])   # s(s-1)(s-lam)
    # coefficients c_k of s^{4-k} t^k: leading (s^4) coefficient is 0
    cf = [F(0)]*5
    for k, v in enumerate(q): cf[4-k] = v
    a, b, c, d, e = cf
    jq, _, _ = j_quartic(a, b, c, d, e)
    jx = F(256*(lam*lam - lam + 1)**3, (lam*lam*(lam-1)**2))
    CHECK(f"j_quartic_vs_crossratio_lam_{lam}", jq == jx, f"{jq} == {jx}")

# ---------- (b) Weierstrass cubic ----------
def j_cubic(c3, c2, c1, c0):
    a2, a4, a6 = c2, c1*c3, c0*c3*c3
    b2, b4, b6 = 4*a2, 2*a4, 4*a6
    C4 = b2*b2 - 24*b4
    C6 = -b2**3 + 36*b2*b4 - 216*b6
    return F(1728*C4**3, C4**3 - C6*C6)
def j_short(a, b):
    return F(1728*4*a**3, 4*a**3 + 27*b*b)

for (a, b) in ((F(1), F(2)), (F(-3), F(5)), (F(7,2), F(1,3)), (F(0), F(1)), (F(1), F(0))):
    if 4*a**3 + 27*b*b == 0: continue
    CHECK(f"j_cubic_short_a{a}_b{b}", j_cubic(F(1), F(0), a, b) == j_short(a, b),
          f"{j_cubic(F(1), F(0), a, b)}")
# general leading/quadratic coefficients: y^2 = c3 x^3 + c2 x^2 + c1 x + c0
for (c3, c2, c1, c0) in ((F(2), F(3), F(4), F(5)), (F(-1), F(1), F(-1), F(1)),
                         (F(5,3), F(-2), F(7), F(1,2))):
    a2, a4, a6 = c2, c1*c3, c0*c3*c3
    A = a4 - F(a2*a2, 3); B = F(2*a2**3, 27) - F(a2*a4, 3) + a6
    CHECK(f"j_cubic_general_{c3}_{c2}_{c1}_{c0}", j_cubic(c3, c2, c1, c0) == j_short(A, B),
          f"{j_cubic(c3, c2, c1, c0)}")
CHECK("j_cubic_1728", j_cubic(F(1), F(0), F(1), F(0)) == 1728, "y^2 = x^3 + x has j = 1728")
CHECK("j_cubic_0", j_cubic(F(1), F(0), F(0), F(1)) == 0, "y^2 = x^3 + 1 has j = 0")

# ---------- (c) the branch-quartic extraction on a known curve ----------
def extraction_test(a, b):
    """y^2 = x^3 + a x + b embedded by |6.O| as
       P |-> (1 : x : x^2 : x^3 : y : x y) in P^5, tau = [-1] acting by
       (+,+,+,+,-,-).  Recompute R(s,t) with the packet's algorithm."""
    MONS = [(i, j) for i in range(6) for j in range(i, 6)]
    # each monomial as an element of Q[x] + y Q[x], reduced by y^2 = x^3+ax+b
    def mono(i, j):
        deg = [0, 1, 2, 3, 0, 1]          # x-degree of each coordinate
        ny = [0, 0, 0, 0, 1, 1]           # y-degree
        dx = deg[i] + deg[j]; dy = ny[i] + ny[j]
        if dy == 0: return ([F(0)]*dx + [F(1)], [])
        if dy == 1: return ([], [F(0)]*dx + [F(1)])
        # y^2 = x^3 + a x + b
        base = [b, a, F(0), F(1)]
        return ([F(0)]*dx + base, [])
    rows = []
    for (i, j) in MONS:
        px, py = mono(i, j)
        v = [F(0)]*20
        for k, cv in enumerate(px): v[k] += cv
        for k, cv in enumerate(py): v[10+k] += cv
        rows.append(v)
    # kernel of the 21 x 20 matrix (columns = monomials)
    M = [[rows[m][r] for m in range(21)] for r in range(20)]
    # gaussian elimination for the kernel
    R = [row[:] for row in M]; piv = []; rr = 0
    for c in range(21):
        pr = next((r for r in range(rr, len(R)) if R[r][c] != 0), None)
        if pr is None: continue
        R[rr], R[pr] = R[pr], R[rr]
        iv = F(1, 1)/R[rr][c]; R[rr] = [x*iv for x in R[rr]]
        for r in range(len(R)):
            if r != rr and R[r][c] != 0:
                f = R[r][c]; R[r] = [x - f*y for x, y in zip(R[r], R[rr])]
        piv.append(c); rr += 1
    free = [i for i in range(21) if i not in piv]
    ker = []
    for f in free:
        v = [F(0)]*21; v[f] = F(1)
        for r, pc in zip(R, piv): v[pc] = -r[f]
        ker.append(v)
    if len(ker) != 9: return None, f"expected 9 quadrics, got {len(ker)}"
    MI = {m: k for k, m in enumerate(MONS)}
    odd = [v for v in ker if any(v[MI[m]] != 0 for m in MONS if (m[0] < 4) != (m[1] < 4))]
    # split by parity
    def evenpart(v): return [v[k] if ((MONS[k][0] < 4) == (MONS[k][1] < 4)) else F(0) for k in range(21)]
    def oddpart(v): return [v[k] if ((MONS[k][0] < 4) != (MONS[k][1] < 4)) else F(0) for k in range(21)]
    def rank_basis(vs):
        B = []
        for v in vs:
            w = v[:]
            for bb, pc in B:
                if w[pc] != 0:
                    f = w[pc]; w = [x - f*y for x, y in zip(w, bb)]
            nz = next((k for k in range(21) if w[k] != 0), None)
            if nz is None: continue
            iv = F(1, 1)/w[nz]; w = [x*iv for x in w]
            B.append((w, nz))
        return [bb for bb, _ in B]
    EV = rank_basis([evenpart(v) for v in ker])
    OD = rank_basis([oddpart(v) for v in ker])
    if (len(EV), len(OD)) != (6, 3): return None, f"parity split {(len(EV), len(OD))}"
    # A(v) and the Cramer parametrisation
    def bmul(P, Q):
        Rr = {}
        for e1, c1 in P.items():
            for e2, c2 in Q.items():
                e = (e1[0]+e2[0], e1[1]+e2[1]); Rr[e] = Rr.get(e, F(0)) + c1*c2
        return {e: c for e, c in Rr.items() if c != 0}
    def badd(P, Q):
        Rr = dict(P)
        for e, c in Q.items():
            Rr[e] = Rr.get(e, F(0)) + c
        return {e: c for e, c in Rr.items() if c != 0}
    def bsub(P, Q): return badd(P, {e: -c for e, c in Q.items()})
    Bm = [[badd({(1, 0): OD[r][MI[(i, 4)]]}, {(0, 1): OD[r][MI[(i, 5)]]}) for i in range(4)]
          for r in range(3)]
    Bm = [[{e: c for e, c in col.items() if c != 0} for col in row] for row in Bm]
    def det3(Mx):
        A_, B_, C_ = Mx[0]; D_, E_, Ff = Mx[1]; G_, H_, I_ = Mx[2]
        return badd(bsub(bmul(A_, bsub(bmul(E_, I_), bmul(Ff, H_))),
                         bmul(B_, bsub(bmul(D_, I_), bmul(Ff, G_)))),
                    bmul(C_, bsub(bmul(D_, H_), bmul(E_, G_))))
    nu = []
    for i in range(4):
        cols = [c for c in range(4) if c != i]
        d = det3([[Bm[r][c] for c in cols] for r in range(3)])
        nu.append(d if i % 2 == 0 else {e: -c for e, c in d.items()})
    # even quadric with ww-part = w0^2
    A3 = [[EV[r][MI[(4, 4)]] for r in range(6)],
          [EV[r][MI[(4, 5)]] for r in range(6)],
          [EV[r][MI[(5, 5)]] for r in range(6)]]
    # solve A3 . coeff = (1,0,0)
    Aug = [A3[i][:] + [F(1) if i == 0 else F(0)] for i in range(3)]
    pv = []; rr2 = 0
    for c in range(6):
        pr = next((r for r in range(rr2, 3) if Aug[r][c] != 0), None)
        if pr is None: continue
        Aug[rr2], Aug[pr] = Aug[pr], Aug[rr2]
        iv = F(1, 1)/Aug[rr2][c]; Aug[rr2] = [x*iv for x in Aug[rr2]]
        for r in range(3):
            if r != rr2 and Aug[r][c] != 0:
                f = Aug[r][c]; Aug[r] = [x - f*y for x, y in zip(Aug[r], Aug[rr2])]
        pv.append(c); rr2 += 1
    coeff = [F(0)]*6
    for r, c in enumerate(pv): coeff[c] = Aug[r][6]
    vec = [sum((coeff[r]*EV[r][k] for r in range(6)), F(0)) for k in range(21)]
    P = {}
    for k, m in enumerate(MONS):
        if m[0] < 4 and m[1] < 4 and vec[k] != 0:
            P = badd(P, {e: vec[k]*c for e, c in bmul(nu[m[0]], nu[m[1]]).items()})
    Rq = {}
    for (i, j), c in P.items():
        if i < 2: return None, "division by s^2 not exact"
        Rq[(i-2, j)] = -c
    cf = [F(0)]*5
    for (i, j), c in Rq.items(): cf[j] = c
    return j_quartic(*cf)[0], cf

for (a, b) in ((F(1), F(2)), (F(-3), F(5)), (F(2), F(-7)), (F(5), F(1))):
    got, cf = extraction_test(a, b)
    want = j_short(a, b)
    CHECK(f"extraction_pipeline_a{a}_b{b}", got == want,
          f"recovered j = {got}, true j = {want}, R = {cf}")

# ---------- (d) the modular polynomial Phi_2 ----------
def Phi2(x, y):
    return (x**3 + y**3 - x*x*y*y + 1488*(x*x*y + x*y*y) - 162000*(x*x + y*y)
            + 40773375*x*y + 8748000000*(x + y) - 157464000000000)
for (A, B) in ((F(1), F(1)), (F(3), F(1)), (F(-2), F(5)), (F(1), F(-6)), (F(7), F(2))):
    if B == 0 or A*A - 4*B == 0: continue
    j1 = j_cubic(F(1), A, B, F(0))
    j2 = j_cubic(F(1), -2*A, A*A - 4*B, F(0))
    CHECK(f"Phi2_on_2isogeny_A{A}_B{B}", Phi2(j1, j2) == 0, f"j = {j1}, j' = {j2}")
J0 = F(8192, 11)
CHECK("Phi2_at_klein_j_pair", Phi2(J0, J0) != 0,
      f"Phi_2(8192/11, 8192/11) = {Phi2(J0, J0)} != 0 (the relation is Phi_1: j = j')")
CHECK("klein_j_not_0_or_1728", J0 != 0 and J0 != 1728,
      "j = 8192/11 is neither 0 nor 1728, so Aut of the curve is {+-1}")
CHECK("klein_j_not_integral", F(8192, 11).denominator != 1,
      "8192/11 is not an algebraic integer, so the curve has no CM")

print("ALLGREEN" if all(ck) else "FAILURES PRESENT")
