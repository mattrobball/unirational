#!/usr/bin/env python3
"""FIX-C1 -- the ladder library.

Self-contained rebuild of the V4-frame landing calculus of Note II
(`theory/FIX_II_jets.md` sec. 2) at a representative V4 triple line, together
with the exact ring arithmetic needed by the (1,7) Chebyshev seed.

CONVENTIONS (identical to FIX-N2C / the V4 packet (1.1)).

    W = A + B + C + D, coordinates (a, b, u0, u1, u2);
    A = W^K is the 2-plane of K = V4-invariants, so the triple line is
    ell_V = P(A) = {u0 = u1 = u2 = 0} in the SOURCE P(W).
    x, y, z are the normal coordinates of ell_V, of K-characters B, C, D.
    The three plus-planes P_1, P_2, P_3 through ell_V have ideals
    (y,z), (x,z), (x,y).

    F(a,b,u0,u1,u2) = kp a^3 + km b^3
                      + a (u0^2 + om u1^2 + om^2 u2^2)
                      + b (u0^2 + om^2 u1^2 + om u2^2)
                      + u0 u1 u2 ,        km = 13/8 - kp,
    with om^2+om+1 = 0 and 8 kp^2 - 13 kp - 4 = 0  (kp = kappa_+).

    A germ of a landing covariant along ell_V expands in the (x,y,z)-adic
    filtration as  T = sum_{n >= r} T_n,  T_n homogeneous of degree n in
    (x,y,z) (coefficients binary forms on ell_V -- the "line degree").
    Level ell of the ladder is the (x,y,z)-degree-(3r+ell) part of F(T):

        3 Phi(T_r, T_r, T_{r+ell})  =  - sum_{i+j+k=ell, i,j,k<ell}
                                          Phi(T_{r+i}, T_{r+j}, T_{r+k}).

    D_{p0} : e |-> 3 Phi(p0, p0, e) is the ladder differential.

The graded pieces are constrained by:
  * V4-equivariance  -> one parity pattern per slot (Note II Lemma 2.2);
  * residual C3      -> psi(T) = lam g(T) with a single lam^3 = 1,
                        psi = ((x,y,z) -> (y,z,x)),
                        g = ((a,b,u0,u1,u2) -> (om a, om^2 b, u1, u2, u0));
  * multi-order      -> ord_{P_i}(T_n) >= m for every n and every i
                        (because ord_{P_i}(T) = min_n ord_{P_i}(T_n)).
The FIX-H0 refinement ord(T^-_sigma) < ord(T^+_sigma) is then AUTOMATIC by
parity -- proved in `verify_c1.py`, check H0-AUTO.
"""
import itertools

import sympy as sp

x, y, z = sp.symbols('x y z')
om, kp = sp.symbols('om kp')
c, P1s = sp.symbols('c P1')

KAP = kp + 2                       # kappa = kp + 2 = B^3 + B^-3
KM = sp.Rational(13, 8) - kp       # kappa_-
DL = 2*om + 1                      # dl^2 = -3

# Groebner basis of the ground ring R = QQ[P1,c,om,kp]/(...)  (lex, gens below).
# Leading monomials P1^3, c^3, om^2, kp^2 are pairwise coprime => Groebner
# (Buchberger's first criterion).  dim_QQ R = 3*3*2*2 = 36.
REL = [P1s**3 - sp.Rational(8, 9)*om*KAP*P1s**2 + sp.Rational(32, 27)*KAP,
       c**3 - 3*c - KAP,
       om**2 + om + 1,
       8*kp**2 - 13*kp - 4]
GENS = (P1s, c, om, kp)

# Ground ring for the control (3,6) D_B seed.  kappa = (B^3-1)^2/B^3 = kp, i.e.
# B^3 + B^-3 = kp + 2 = KAP, i.e.  B^6 - KAP B^3 + 1 = 0;  then
# B^-1 = KAP B^2 - B^5.  Leading monomials B^6, om^2, kp^2 pairwise coprime.
Bs = sp.Symbol('B')
REL_B = [Bs**6 - KAP*Bs**3 + 1,
         om**2 + om + 1,
         8*kp**2 - 13*kp - 4]
GENS_B = (Bs, om, kp)
BINV = sp.expand(KAP*Bs**2 - Bs**5)          # = B^-1 modulo REL_B


def make_red(rel, gens):
    """exact reduction modulo a Groebner basis, memoised."""
    cache = {}

    def red(e):
        e = sp.expand(e)
        if e == 0:
            return sp.Integer(0)
        key = sp.srepr(e)
        got = cache.get(key)
        if got is None:
            _, r = sp.reduced(e, rel, *gens, order='lex')
            got = sp.expand(r)
            cache[key] = got
        return got
    return red


red = make_red(REL, GENS)


def red_poly(expr, rd=None):
    """reduce every (x,y,z)-coefficient of a polynomial modulo the GB."""
    rd = rd or red
    expr = sp.expand(expr)
    if expr == 0:
        return sp.Integer(0)
    P = sp.Poly(expr, x, y, z)
    out = sp.Integer(0)
    for mono, cf in zip(P.monoms(), P.coeffs()):
        r = rd(cf)
        if r != 0:
            out += r*x**mono[0]*y**mono[1]*z**mono[2]
    return sp.expand(out)


def psi(e):
    """the source residual C3: (x,y,z) -> (y,z,x)."""
    return e.subs({x: y, y: z, z: x}, simultaneous=True)


def F_klein(T):
    """the Klein normal form, V4 packet (1.1)."""
    a, b, u0, u1, u2 = T
    return sp.expand(kp*a**3 + KM*b**3
                     + a*(u0**2 + om*u1**2 + om**2*u2**2)
                     + b*(u0**2 + om**2*u1**2 + om*u2**2)
                     + u0*u1*u2)


def Phi(A, B, C):
    """the symmetric trilinear polarization: Phi(v,v,v) = F(v).

    Computed as (1/6) * [s t u] F(sA + tB + uC) -- no hand-expanded formula.
    """
    s, t, u = sp.symbols('c1_s c1_t c1_u')
    V = [sp.expand(s*A[i] + t*B[i] + u*C[i]) for i in range(5)]
    E = sp.expand(F_klein(V))
    Q = sp.Poly(E, s, t, u)
    out = sp.Integer(0)
    for mono, cf in zip(Q.monoms(), Q.coeffs()):
        if mono == (1, 1, 1):
            out += cf
    return sp.expand(out/6)


def D_op(p0, e):
    """the ladder differential  e |-> 3 Phi(p0, p0, e)."""
    return sp.expand(3*Phi(p0, p0, e))


# ---------------------------------------------------------------------------
# graded pieces of an A4-equivariant germ
# ---------------------------------------------------------------------------
def slot_parities(n):
    """V4-characters of the five slots as parity patterns of (A,B,C).

    a', b' carry the trivial V4-character (all exponents congruent mod 2);
    u_0' the character of x, etc.  For n odd the trivial character forces all
    exponents odd, for n even all even; the u-slots follow.
    """
    if n % 2:
        return [(1, 1, 1), (1, 1, 1), (1, 0, 0), (0, 1, 0), (0, 0, 1)]
    return [(0, 0, 0), (0, 0, 0), (0, 1, 1), (1, 0, 1), (1, 1, 0)]


def monomials_xyz(n, m, parity):
    """degree-n monomials with the given exponent parities and min plane
    order >= m, i.e. n - max(A,B,C) >= m."""
    out = []
    for A in range(n + 1):
        for B in range(n + 1 - A):
            C = n - A - B
            if (A % 2, B % 2, C % 2) != tuple(parity):
                continue
            if n - max(A, B, C) < m:
                continue
            out.append((A, B, C))
    return sorted(out, reverse=True)


def mono(t):
    return x**t[0] * y**t[1] * z**t[2]


def graded_piece(n, m, lam, prefix, rd=None):
    """basis of V_n(m, lam): A4-equivariant tuples of (x,y,z)-degree n with
    ord_{P_i} >= m for all i, residual-C3 scalar lam.

    Returns (names, T) where T = [a', b', u0', u1', u2'] is the general
    element with symbolic coefficients named prefix+index.
    """
    rd = rd or red
    par = slot_parities(n)
    Ma = monomials_xyz(n, m, par[0])
    M0 = monomials_xyz(n, m, par[2])
    lam = rd(sp.expand(lam))
    lami = rd(sp.expand(lam**2))                     # lam^{-1}

    def eig_block(monos, nu, tag):
        nu = rd(nu)
        nui = rd(nu**2)                              # nu^{-1} (nu^3 = 1)
        seen, out, names = set(), [], []
        k = 0
        for M in monos:
            if M in seen:
                continue
            o1 = (M[2], M[0], M[1])                  # psi(x^A y^B z^C)
            o2 = (o1[2], o1[0], o1[1])
            seen |= {M, o1, o2}
            if o1 == M:
                if rd(nu - 1) == 0:
                    out.append(mono(M))
                    names.append('%s_%s%d' % (prefix, tag, k))
                    k += 1
                continue
            out.append(sp.expand(mono(M) + nui*mono(o1) + rd(nui**2)*mono(o2)))
            names.append('%s_%s%d' % (prefix, tag, k))
            k += 1
        return names, out

    nP, bP = eig_block(Ma, rd(lam*om), 'P')
    nR, bR = eig_block(Ma, rd(lam*om**2), 'R')
    nB = ['%s_B%d' % (prefix, i) for i in range(len(M0))]
    names = nP + nR + nB
    syms = [sp.Symbol(s) for s in names]
    it = iter(syms)
    ap = sum(next(it)*v for v in bP) if bP else sp.Integer(0)
    bp = sum(next(it)*v for v in bR) if bR else sp.Integer(0)
    u0 = sum(next(it)*mono(M) for M in M0) if M0 else sp.Integer(0)
    u1 = red_poly(sp.expand(lami*psi(u0)), rd)
    u2 = red_poly(sp.expand(lami*psi(u1)), rd)
    return names, [sp.expand(ap), sp.expand(bp), u0, u1, u2]


def check_equivariance(T, lam, rd=None):
    """psi(T) = lam * g(T) with g = (a,b,u0,u1,u2) -> (om a, om^2 b, u1,u2,u0)."""
    rd = rd or red
    ap, bp, u0, u1, u2 = T
    tgt = [sp.expand(lam*om*ap), sp.expand(lam*om**2*bp),
           sp.expand(lam*u1), sp.expand(lam*u2), sp.expand(lam*u0)]
    for got, want in zip([psi(t) for t in T], tgt):
        if red_poly(sp.expand(got - want), rd) != 0:
            return False
    return True


def orders(T, rd=None):
    """(triple-line order r, (ord_P1, ord_P2, ord_P3), set of total degrees)."""
    rd = rd or red
    ords, degs = [], set()
    for comp in T:
        comp = sp.expand(comp)
        if comp == 0:
            continue
        P = sp.Poly(comp, x, y, z)
        for mn, cf in zip(P.monoms(), P.coeffs()):
            if rd(cf) == 0:
                continue
            A, B, C = mn
            degs.add(A + B + C)
            ords.append((B + C, A + C, A + B))
    if not ords:
        return None, None, set()
    ordP = tuple(min(o[i] for o in ords) for i in range(3))
    return min(degs), ordP, degs


def sigma_split_orders(T, rd=None):
    """(ord_{P_1} T^+ , ord_{P_1} T^-) for sigma_1 (W^+ = <a,b,u0>)."""
    rd = rd or red
    def o(comps):
        best = None
        for comp in comps:
            comp = sp.expand(comp)
            if comp == 0:
                continue
            P = sp.Poly(comp, x, y, z)
            for mn, cf in zip(P.monoms(), P.coeffs()):
                if rd(cf) == 0:
                    continue
                v = mn[1] + mn[2]
                best = v if best is None else min(best, v)
        return best
    return o([T[0], T[1], T[2]]), o([T[3], T[4]])


# ---------------------------------------------------------------------------
# the two seeds
# ---------------------------------------------------------------------------
def ring_m1(j):
    """ground ring of the lam = om^j Chebyshev block, uniformised in c.

    FIX-N2C Thm N2C-1': the plane-order-1 locus of the r = 7, lam = om^j cone
    is (normalisation P0 = 1)
        B2^3 + 9 om^j B2 + 3 dl kap = 0            with  B2 = dl om^{-j} c,
                                                   equivalently c^3 - 3c = kap
        P1^3 - (8/9) om^{j+1} kap P1^2 + (32/27) kap = 0
        B5 = om + ((om+2)/6) B2 P1 .
    Leading monomials P1^3, c^3, om^2, kp^2 pairwise coprime => Groebner.
    """
    rel = [P1s**3 - sp.Rational(8, 9)*(om**(j + 1))*KAP*P1s**2
           + sp.Rational(32, 27)*KAP,
           c**3 - 3*c - KAP,
           om**2 + om + 1,
           8*kp**2 - 13*kp - 4]
    rel = [sp.expand(r) for r in rel]
    return rel, GENS, make_red(rel, GENS)


def seed_m1_coords(j, rd):
    """the 13 block coordinates of the (1,7) witness in eigenblock lam = om^j.

    j = 0 : FIX-N2C `witness.py`;  j = 1 : `witness_om.py`;
    j = 2 : `witness_om2.py`  --  all with B2 = dl om^{-j} c.
    """
    OM2 = -1 - om
    P0 = sp.Integer(1)
    B2 = rd(DL*om**(-j % 3)*c) if j else rd(DL*c)
    B2 = rd(sp.expand(DL*(om**((3 - j) % 3))*c))
    B5 = rd(om + sp.Rational(1, 6)*(om + 2)*B2*P1s)
    v = {'P0': P0, 'P1': P1s, 'B2': B2, 'B5': B5}
    if j == 0:
        v['R0'] = rd(om*B5 - OM2*P0)
        v['R1'] = rd(-om*P1s)
        v['B0'] = rd(-OM2*B5 - (OM2 - 1)*P0)
        v['B1'] = rd(-B5)
        v['B3'] = rd(-2*om*B5 - (2*om + 4)*P0)
        v['B4'] = rd(-B2)
        v['B6'] = rd(om*B5 - (OM2 - 1)*P0 - (OM2 + 2)*P1s)
        v['B7'] = rd(om*B5 - (OM2 - 1)*P0 - (om - 1)*P1s)
        v['B8'] = rd(OM2*B5 + (OM2 - 1)*P0)
    elif j == 1:
        v['R0'] = rd(om*B5 - OM2*P0)
        v['R1'] = rd(-om*P1s)
        v['B0'] = rd(-B5 + (om - 1)*P0)
        v['B1'] = rd(-OM2*B5)
        v['B3'] = rd(-2*om*B5 - (2*om + 4)*P0)
        v['B4'] = rd(-OM2*B2)
        v['B6'] = rd(OM2*B5 + (om - 1)*(P0 + P1s))
        v['B7'] = rd(B5 - DL*(P0 - P1s))
        v['B8'] = rd(OM2*B5 - (om + 2)*P0)
    else:
        v['R0'] = rd(om*B5 - OM2*P0)
        v['R1'] = rd(-om*P1s)
        v['B0'] = rd(-om*B5 - DL*P0)
        v['B1'] = rd(-om*B5)
        v['B3'] = rd(-2*om*B5 - (2*om + 4)*P0)
        v['B4'] = rd(-om*B2)
        v['B6'] = rd(B5 - DL*P0 + (om - 1)*P1s)
        v['B7'] = rd(OM2*B5 + (om - 1)*P0 - (om + 2)*P1s)
        v['B8'] = rd(OM2*B5 - (om + 2)*P0)
    return v


def seed_m1(j=0):
    """(names, T, lam, rel, rd) for the (1,7) Chebyshev seed, block lam = om^j."""
    rel, gens, rd = ring_m1(j)
    lam = rd(om**j)
    names, Tgen = graded_piece(7, 1, lam, 'S', rd)
    vals = seed_m1_coords(j, rd)
    sub = {}
    for nm in names:
        key = nm.split('_', 1)[1]
        sub[sp.Symbol(nm)] = vals[key]
    T = [red_poly(sp.expand(comp.subs(sub)), rd) for comp in Tgen]
    return names, T, lam, rel, rd


def seed_control():
    """the (m,r) = (3,6) D_B seed -- the T5 witness, V4 packet (4.1).

        kappa = (B^3-1)^2/B^3 = kp,   X = yz, Y = zx, Z = xy
        w  = -XYZ
        U0 = X(X^2 + B Y^2 + B^-1 Z^2)   (cyclically)
    transported into the (1.1) frame by  a = w, b = 0,
    u0 = U0, u1 = om U1, u2 = om^2 U2.  Residual scalar lam = om^2.
    """
    rdB = make_red(REL_B, GENS_B)
    Bi = BINV
    X, Y, Z = y*z, z*x, x*y
    U0 = sp.expand(X*(X**2 + Bs*Y**2 + Bi*Z**2))
    U1 = sp.expand(Y*(Y**2 + Bs*Z**2 + Bi*X**2))
    U2 = sp.expand(Z*(Z**2 + Bs*X**2 + Bi*Y**2))
    T = [sp.expand(-X*Y*Z), sp.Integer(0), U0, sp.expand(om*U1),
         sp.expand(om**2*U2)]
    T = [red_poly(t, rdB) for t in T]
    return T, rdB(om**2), REL_B, rdB


# ---------------------------------------------------------------------------
# Taylor data of F at a seed (exact, no polarisation identity needed)
#     F(p + e) = F(p) + sum_i e_i dF_i(p) + 1/2 sum_ij e_i e_j ddF_ij(p) + F(e)
#     3 Phi(p,p,e) = sum_i e_i dF_i(p) ;  3 Phi(p,e,e) = 1/2 sum e_i e_j ddF_ij(p)
# ---------------------------------------------------------------------------
V5 = sp.symbols('v0 v1 v2 v3 v4')
F_SYM = F_klein(list(V5))
DF_SYM = [sp.expand(sp.diff(F_SYM, v)) for v in V5]
DDF_SYM = [[sp.expand(sp.diff(F_SYM, V5[i], V5[j])) for j in range(5)]
           for i in range(5)]


def _sub5(expr, T):
    return sp.expand(expr.subs({V5[i]: T[i] for i in range(5)}, simultaneous=True))


def dF_at(p0):
    return [_sub5(e, p0) for e in DF_SYM]


def ddF_at(p0):
    return [[_sub5(DDF_SYM[i][j], p0) for j in range(5)] for i in range(5)]


def _pmul(*args):
    """expanded product of polynomials in x,y,z, via sympy Poly arithmetic
    (accumulating Expr and expanding at the end is a performance trap)."""
    P = None
    for a in args:
        a = sp.expand(a)
        if a == 0:
            return None
        Pa = sp.Poly(a, x, y, z)
        P = Pa if P is None else P*Pa
    return P


def _psum(parts):
    P = None
    for p in parts:
        if p is None:
            continue
        P = p if P is None else P + p
    return sp.Integer(0) if P is None else P.as_expr()


def D_apply(dfp, e):
    """3 Phi(p0, p0, e) = sum_i e_i dF_i(p0)."""
    return _psum([_pmul(e[i], dfp[i]) for i in range(5)])


def H_apply(ddfp, e, f):
    """3 Phi(p0, e, f) + 3 Phi(p0, f, e) polarised:  sum_ij e_i f_j ddF_ij(p0).
    In particular 3 Phi(p0,e,e) = 1/2 * H_apply(ddfp, e, e)."""
    return _psum([_pmul(e[i], f[j], ddfp[i][j])
                  for i in range(5) for j in range(5)])


# third derivative tensor of the cubic F (constant): Phi(A,B,C) = (1/6) sum
DDDF_SYM = [[[sp.expand(sp.diff(F_SYM, V5[i], V5[j], V5[k]))
              for k in range(5)] for j in range(5)] for i in range(5)]


def Phi_fast(A, B, C):
    """Phi(A,B,C) via the constant third-derivative tensor of F."""
    parts = []
    for i in range(5):
        if A[i] == 0:
            continue
        for j in range(5):
            if B[j] == 0:
                continue
            for k in range(5):
                t = DDDF_SYM[i][j][k]
                if t == 0 or C[k] == 0:
                    continue
                parts.append(_pmul(A[i], B[j], sp.expand(C[k]*t)))
    return sp.expand(_psum(parts)/6)


# ---------------------------------------------------------------------------
# THE SPLIT OF THE CHEBYSHEV PARAMETER SCHEME (FIX-C1 finding)
#
# Both defining cubics of the nine-point scheme are REDUCIBLE over
# K = QQ(om, kp): each has exactly one K-rational root,
#
#     c_0  = (4 kp - 1)/3          ( = B + B^-1 , the untwisted Chebyshev root)
#     P1_0 = (4/3) om^{j+1} c_0    (block lam = om^j)
#
# so the nine points of each eigenblock split, Galois-stably, as
#
#     1  (c_0, P1_0)          "A"   -- the K-rational point
#   + 2  (c_0, g_P1)          "B"
#   + 2  (g_c, P1_0)          "C"
#   + 4  (g_c, g_P1)          "D"
#
# with  g_c(c)  = c^2 + c_0 c + (c_0^2 - 3)
#       g_P1(t) = t^2 + (A + P1_0) t + (P1_0^2 + A P1_0),
#       A = -(8/9) om^{j+1} (kp+2).
# ---------------------------------------------------------------------------
C0 = (4*kp - 1)/sp.Integer(3)


def P10(j):
    return sp.expand(sp.Rational(4, 3)*om**((j + 1) % 3)*C0)


def ring_m1_split(j, part):
    """ground ring of one Galois-stable part of the block-j parameter scheme.

    part in {'A','B','C','D'} as above; returns (rel, gens, degs, red).
    """
    A = sp.expand(-sp.Rational(8, 9)*om**((j + 1) % 3)*KAP)
    p10 = P10(j)
    gc = sp.expand(c**2 + C0*c + C0**2 - 3)
    gP = sp.expand(P1s**2 + (A + p10)*P1s + (p10**2 + A*p10))
    relc = {'A': c - C0, 'B': c - C0, 'C': gc, 'D': gc}[part]
    relp = {'A': P1s - p10, 'B': gP, 'C': P1s - p10, 'D': gP}[part]
    degc = 1 if part in ('A', 'B') else 2
    degp = 1 if part in ('A', 'C') else 2
    rel = [sp.expand(relp), sp.expand(relc), om**2 + om + 1,
           8*kp**2 - 13*kp - 4]
    return rel, GENS, (degp, degc, 2, 2), make_red(rel, GENS)


def seed_m1_split(j, part):
    """(names, T, lam, rel, degs, rd) for the (1,7) seed on one part."""
    rel, gens, degs, rd = ring_m1_split(j, part)
    lam = rd(om**j)
    names, Tgen = graded_piece(7, 1, lam, 'S', rd)
    vals = seed_m1_coords(j, rd)
    sub = {sp.Symbol(nm): vals[nm.split('_', 1)[1]] for nm in names}
    T = [red_poly(sp.expand(comp.subs(sub)), rd) for comp in Tgen]
    return names, T, lam, rel, degs, rd
