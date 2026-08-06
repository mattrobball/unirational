#!/usr/bin/env python3
"""FIX-D2  INDEPENDENT VERIFIER.

Shares NOTHING with produce_d2.py:
  * different field model -- K = Q[x]/(x^4+2x^3+25x^2+24x+111), the minimal
    polynomial of the primitive element  theta = om + nu ; om and nu are
    RECOVERED inside K, not posited.  Inversion by extended Euclid.
  * different frame construction -- ONLY rho|W-, tau|W- and the normal-form
    Q are taken as input; rho|W+, tau|W+, c_sigma, kp, km, the V_m[twist]
    generators are all DERIVED here.
  * different algorithms -- every contraction/identity is expanded as a
    DENSE MULTIVARIATE POLYNOMIAL in (s1,s2,y,z) over K (dict of exponent
    tuples), not as graded coefficient arrays.
Exact rational arithmetic only.  Self-tests (must-fail controls) included.
"""
import json
import os
import sys
from fractions import Fraction as Fr

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = []
FAIL = []


def log(s=""):
    print(s)
    OUT.append(s)


def chk(name, cond):
    if not cond:
        FAIL.append(name)
    log("  [%s] %s" % ("PASS" if cond else "FAIL", name))
    return bool(cond)


# ===================================================================== field
# K = Q[x]/(MP),  MP = x^4 + 2x^3 + 25x^2 + 24x + 111  (minpoly of om+nu)
MP = [Fr(111), Fr(24), Fr(25), Fr(2), Fr(1)]     # ascending coefficients


def pnorm(p):
    while len(p) > 1 and p[-1] == 0:
        p.pop()
    return p


def padd(a, b):
    n = max(len(a), len(b))
    return pnorm([(a[i] if i < len(a) else Fr(0)) +
                  (b[i] if i < len(b) else Fr(0)) for i in range(n)])


def psub(a, b):
    n = max(len(a), len(b))
    return pnorm([(a[i] if i < len(a) else Fr(0)) -
                  (b[i] if i < len(b) else Fr(0)) for i in range(n)])


def pmulraw(a, b):
    out = [Fr(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        if x == 0:
            continue
        for j, y in enumerate(b):
            if y:
                out[i + j] += x * y
    return pnorm(out)


def pmod(a, mo):
    a = a[:]
    while len(a) >= len(mo) and not (len(a) == 1 and a[0] == 0):
        d = len(a) - len(mo)
        c = a[-1] / mo[-1]
        if c:
            for i in range(len(mo)):
                a[d + i] -= c * mo[i]
        pnorm(a)
        if len(a) < len(mo):
            break
        if a[-1] == 0:
            a.pop()
    return pnorm(a)


class F:
    __slots__ = ("p",)

    def __init__(self, p):
        if isinstance(p, (int, Fr)):
            p = [Fr(p)]
        self.p = pmod(pnorm([Fr(t) for t in p]), MP)

    def __add__(s, o):
        return F(padd(s.p, o.p))

    def __sub__(s, o):
        return F(psub(s.p, o.p))

    def __neg__(s):
        return F([-t for t in s.p])

    def __mul__(s, o):
        if isinstance(o, (int, Fr)):
            return F([t * Fr(o) for t in s.p])
        return F(pmod(pmulraw(s.p, o.p), MP))

    __rmul__ = __mul__

    def __eq__(s, o):
        return s.p == (o.p if isinstance(o, F) else F(o).p)

    def __hash__(s):
        return hash(tuple(s.p))

    def iszero(s):
        return len(s.p) == 1 and s.p[0] == 0

    def inv(s):
        # extended Euclid in Q[x]
        r0, r1 = MP[:], s.p[:]
        t0, t1 = [Fr(0)], [Fr(1)]
        while not (len(r1) == 1 and r1[0] == 0):
            # divide r0 by r1
            q = [Fr(0)] * max(1, len(r0) - len(r1) + 1)
            rr = r0[:]
            while len(rr) >= len(r1) and not (len(rr) == 1 and rr[0] == 0):
                d = len(rr) - len(r1)
                c = rr[-1] / r1[-1]
                q[d] += c
                for i in range(len(r1)):
                    rr[d + i] -= c * r1[i]
                pnorm(rr)
                if len(rr) < len(r1):
                    break
            r0, r1 = r1, pnorm(rr)
            t0, t1 = t1, psub(t0, pmulraw(q, t1))
        if len(r0) != 1:
            raise ZeroDivisionError("MP not irreducible or a not invertible")
        return F([t / r0[0] for t in t0])

    def __truediv__(s, o):
        return s * o.inv()

    def __repr__(s):
        return "F(%s)" % s.p


ZE, ON = F(0), F(1)
TH = F([0, 1])                                    # theta = om + nu
OM = (TH * TH + F(10)) / (TH * 2 + ON)            # om = (th^2+10)/(2th+1)
NU = TH - OM
OM2 = OM * OM
DELTA = OM - OM2
S33 = -(NU * DELTA)


# ================================================================ lin alg
def rref(rows, ncols):
    R = [list(r) for r in rows]
    piv, pivots = 0, []
    for c in range(ncols):
        r = None
        for i in range(piv, len(R)):
            if not R[i][c].iszero():
                r = i
                break
        if r is None:
            continue
        R[piv], R[r] = R[r], R[piv]
        ip = R[piv][c].inv()
        R[piv] = [x * ip for x in R[piv]]
        for i in range(len(R)):
            if i != piv and not R[i][c].iszero():
                f = R[i][c]
                R[i] = [x - f * y for x, y in zip(R[i], R[piv])]
        pivots.append(c)
        piv += 1
        if piv == len(R):
            break
    return R, pivots


def rank(rows, ncols=None):
    if not rows:
        return 0
    return len(rref(rows, ncols or len(rows[0]))[1])


def nullspace(rows, ncols):
    if not rows:
        rows = [[ZE] * ncols]
    R, pivots = rref(rows, ncols)
    out = []
    for f in [j for j in range(ncols) if j not in pivots]:
        v = [ZE] * ncols
        v[f] = ON
        for i, p in enumerate(pivots):
            v[p] = -R[i][f]
        out.append(v)
    return out


def mm(A, B):
    return [[sum((A[i][t] * B[t][j] for t in range(len(B))), ZE)
             for j in range(len(B[0]))] for i in range(len(A))]


def mv(A, v):
    return [sum((A[i][j] * v[j] for j in range(len(v))), ZE)
            for i in range(len(A))]


def minv(A):
    n = len(A)
    R, piv = rref([A[i][:] + [ON if i == j else ZE for j in range(n)]
                   for i in range(n)], n)
    assert piv == list(range(n)), "singular"
    return [[R[i][n + j] for j in range(n)] for i in range(n)]


def tr(A):
    return [[A[j][i] for j in range(len(A))] for i in range(len(A[0]))]


# ============================================ multivariate polys over K
# monomial = (e_s1, e_s2, e_y, e_z) ; poly = dict monomial -> F
def mpmul(a, b):
    out = {}
    for ma, ca in a.items():
        if ca.iszero():
            continue
        for mb, cb in b.items():
            if cb.iszero():
                continue
            m = (ma[0] + mb[0], ma[1] + mb[1], ma[2] + mb[2], ma[3] + mb[3])
            out[m] = out.get(m, ZE) + ca * cb
    return {m: c for m, c in out.items() if not c.iszero()}


def mpadd(a, b):
    out = dict(a)
    for m, c in b.items():
        out[m] = out.get(m, ZE) + c
    return {m: c for m, c in out.items() if not c.iszero()}


def mpscal(k, a):
    return {m: k * c for m, c in a.items() if not (k * c).iszero()}


# =================================================== POSITED INPUT (L1 only)
RHO_M = [[F(Fr(-1, 2)), (ON - NU) * Fr(1, 4)],
         [(-ON - NU) * Fr(1, 4), F(Fr(-1, 2))]]
TAU_M = [[ON, ZE], [ZE, -ON]]
# the normal-form Q, as its Gram matrix (rows a,b,x ; cols S11,S12,S22)
G = [[OM, ZE, OM2], [OM2, ZE, OM], [ZE, ON, ZE]]


def sym2_act(M):
    cols = []
    for e in ((ON, ZE, ZE), (ZE, ON, ZE), (ZE, ZE, ON)):
        S = [[e[0], e[1]], [e[1], e[2]]]
        T = mm(mm(M, S), tr(M))
        cols.append([T[0][0], T[0][1], T[1][1]])
    return tr(cols)


def plus_from_minus(MM):
    """the unique MP with MP^T G MS = G  (Q-invariance), MS = Sym^2 MM."""
    MS = sym2_act(MM)
    # MP^T = G MS^{-1} G^{-1}
    return tr(mm(mm(G, minv(MS)), minv(G)))


RHO_P = plus_from_minus(RHO_M)
TAU_P = plus_from_minus(TAU_M)


def ident(n):
    return [[ON if i == j else ZE for j in range(n)] for i in range(n)]


def mateq(A, B):
    return all((A[i][j] - B[i][j]).iszero()
               for i in range(len(A)) for j in range(len(A[0])))


# ---- c_sigma : the joint fixed vector of rho_+, tau_+
def joint_fixed(mats, n):
    rows = []
    for M in mats:
        for i in range(n):
            rows.append([M[i][j] - (ON if i == j else ZE) for j in range(n)])
    return nullspace(rows, n)


# ---- kp, km : forced by S3-invariance of F0 = kp a^3 + km b^3 + (a+b)x^2
def cubic_coeffs(vec_of_lin, kp_km_slot):
    pass


def f0_poly(kp, km, MP_=None):
    """F0 as a dict of monomials in (a,b,x) -> F."""
    return {(3, 0, 0): kp, (0, 3, 0): km, (1, 0, 2): ON, (0, 1, 2): ON}


def subst_linear(poly3, M):
    """substitute (a,b,x) -> M.(a,b,x) into a dict-poly in 3 vars."""
    out = {}
    for mon, c in poly3.items():
        # expand prod_i (sum_j M[i][j] var_j)^{mon[i]}
        acc = {(0, 0, 0): c}
        for i in range(3):
            for _ in range(mon[i]):
                nxt = {}
                for j in range(3):
                    if M[i][j].iszero():
                        continue
                    for mm_, cc in acc.items():
                        k = list(mm_)
                        k[j] += 1
                        k = tuple(k)
                        nxt[k] = nxt.get(k, ZE) + cc * M[i][j]
                acc = nxt
        for mm_, cc in acc.items():
            out[mm_] = out.get(mm_, ZE) + cc
    return {m: c for m, c in out.items() if not c.iszero()}


def derive_kp_km():
    """solve the linear system 'F0 o rho_+ = F0' for (kp,km)."""
    # F0 = kp*A + km*B + C with A=a^3, B=b^3, C=(a+b)x^2
    pieces = [{(3, 0, 0): ON}, {(0, 3, 0): ON}, {(1, 0, 2): ON, (0, 1, 2): ON}]
    sp = [subst_linear(p, RHO_P) for p in pieces]
    mons = sorted(set(list(sp[0]) + list(sp[1]) + list(sp[2]) +
                      list(pieces[0]) + list(pieces[1]) + list(pieces[2])))
    rows, rhs = [], []
    for mo in mons:
        rows.append([sp[0].get(mo, ZE) - pieces[0].get(mo, ZE),
                     sp[1].get(mo, ZE) - pieces[1].get(mo, ZE)])
        rhs.append(-(sp[2].get(mo, ZE) - pieces[2].get(mo, ZE)))
    aug = [rows[i] + [rhs[i]] for i in range(len(rows))]
    R, piv = rref(aug, 3)
    assert piv[:2] == [0, 1] and 2 not in piv, "kp,km not determined"
    return R[0][2], R[1][2]


# ---------- dense-polynomial contraction  (monomials (0,0,ey,ez))
def yz(e, f):
    return (0, 0, e, f)


def theta_poly(T, n):
    """T = list of (n+1) triples of F -> three dict-polys (a,b,x components)."""
    comp = [{}, {}, {}]
    for i in range(n + 1):
        for k in range(3):
            if not T[i][k].iszero():
                comp[k][yz(n - i, i)] = comp[k].get(yz(n - i, i), ZE) + T[i][k]
    return comp


def psi_poly(Psi, m):
    comp = [{}, {}]
    for i in range(m + 1):
        for k in range(2):
            if not Psi[i][k].iszero():
                comp[k][yz(m - i, i)] = comp[k].get(yz(m - i, i), ZE) + Psi[i][k]
    return comp


def kappa_poly(T, n, Psi, m):
    """Q(Theta(y); Psi(y)(x)Psi(y)) as a dense poly in (y,z)."""
    a, b, x = theta_poly(T, n)
    Py, Pz = psi_poly(Psi, m)
    S11, S12, S22 = mpmul(Py, Py), mpmul(Py, Pz), mpmul(Pz, Pz)
    t1 = mpmul(a, mpadd(mpscal(OM, S11), mpscal(OM2, S22)))
    t2 = mpmul(b, mpadd(mpscal(OM2, S11), mpscal(OM, S22)))
    t3 = mpmul(x, S12)
    return mpadd(mpadd(t1, t2), t3)


def kappa_matrix_v(n, Psi):
    m = len(Psi) - 1
    tgt = n + 2 * m
    cols = []
    for i in range(n + 1):
        for k in range(3):
            T = [[ZE, ZE, ZE] for _ in range(n + 1)]
            T[i][k] = ON
            P = kappa_poly(T, n, Psi, m)
            cols.append([P.get(yz(tgt - t, t), ZE) for t in range(tgt + 1)])
    return [[cols[c][r] for c in range(len(cols))] for r in range(tgt + 1)]


# ---------- the V_m[twist] generators, DERIVED here (not posited)
def bf_subst_v(f, M):
    n = len(f) - 1
    acc = [ZE] * (n + 1)
    for i, c in enumerate(f):
        if c.iszero():
            continue
        # (M00 y + M01 z)^{n-i} (M10 y + M11 z)^i
        term = {(0, 0): ON}
        for _ in range(n - i):
            nx = {}
            for (p, q), cc in term.items():
                nx[(p + 1, q)] = nx.get((p + 1, q), ZE) + cc * M[0][0]
                nx[(p, q + 1)] = nx.get((p, q + 1), ZE) + cc * M[0][1]
            term = nx
        for _ in range(i):
            nx = {}
            for (p, q), cc in term.items():
                nx[(p + 1, q)] = nx.get((p + 1, q), ZE) + cc * M[1][0]
                nx[(p, q + 1)] = nx.get((p, q + 1), ZE) + cc * M[1][1]
            term = nx
        for (p, q), cc in term.items():
            acc[q] = acc[q] + c * cc
    return acc


def act_form(T, MM, MPl, valdim, sign):
    Mi = minv(MM)
    n = len(T) - 1
    comps = [bf_subst_v([T[i][k] for i in range(n + 1)], Mi)
             for k in range(valdim)]
    out = []
    for i in range(n + 1):
        v = [comps[k][i] for k in range(valdim)]
        v = mv(MPl, v) if MPl is not None else v
        out.append([sign * t for t in v])
    return out


def isotypic(n, valdim, MPl_r, MPl_t, sr, st):
    dim = valdim * (n + 1)
    rows = []
    for MM, MPl, sg in ((RHO_M, MPl_r, sr), (TAU_M, MPl_t, st)):
        cols = []
        for idx in range(dim):
            T = [[ZE] * valdim for _ in range(n + 1)]
            T[idx // valdim][idx % valdim] = ON
            gT = act_form(T, MM, MPl, valdim, sg)
            cols.append([gT[i][k] - T[i][k]
                         for i in range(n + 1) for k in range(valdim)])
        for r in range(dim):
            rows.append([cols[c][r] for c in range(dim)])
    return [[list(v[i:i + valdim]) for i in range(0, dim, valdim)]
            for v in nullspace(rows, dim)]


def main():
    log("FIX-D2 INDEPENDENT VERIFIER")
    log("=" * 68)
    log()
    log("1. field + frame DERIVED (only rho|W-, tau|W-, normal-form Q posited)")
    chk("om^2+om+1 = 0", (OM * OM + OM + ON).iszero())
    chk("nu^2 = -11", (NU * NU + F(11)).iszero())
    chk("sqrt33^2 = 33", (S33 * S33 - F(33)).iszero())
    chk("rho|W+ derived: order 3", mateq(mm(RHO_P, mm(RHO_P, RHO_P)), ident(3)))
    chk("tau|W+ derived: order 2", mateq(mm(TAU_P, TAU_P), ident(3)))
    chk("S3 relation on W+",
        mateq(mm(TAU_P, mm(RHO_P, TAU_P)), mm(RHO_P, RHO_P)))
    chk("rho|W+ matches FIX-L1 entry (1,1) = 1/4 - sqrt33/12",
        (RHO_P[0][0] - (F(Fr(1, 4)) - S33 * Fr(1, 12))).iszero())
    chk("tau|W+ = diag(1,1,-1)", mateq(TAU_P, [[ON, ZE, ZE], [ZE, ON, ZE],
                                               [ZE, ZE, -ON]]))
    dG = (G[0][0] * (G[1][1] * G[2][2] - G[1][2] * G[2][1])
          - G[0][1] * (G[1][0] * G[2][2] - G[1][2] * G[2][0])
          + G[0][2] * (G[1][0] * G[2][1] - G[1][1] * G[2][0]))
    chk("Q-ISOMORPHY: det Gram != 0", not dG.iszero())
    chk("det Gram = delta", (dG - DELTA).iszero())
    fx = joint_fixed([RHO_P, TAU_P], 3)
    chk("dim (W+)^{S3} = 1", len(fx) == 1)
    bcs = fx[0][1] / fx[0][0]
    chk("beta_{c_sigma} = -(7+sqrt33)/4",
        (bcs + (F(7) + S33) * Fr(1, 4)).iszero())
    chk("c_sigma x-coordinate = 0", fx[0][2].iszero())
    kp, km = derive_kp_km()
    chk("kp = (13+3 sqrt33)/16", (kp - (F(13) + S33 * 3) * Fr(1, 16)).iszero())
    chk("km = (13-3 sqrt33)/16", (km - (F(13) - S33 * 3) * Fr(1, 16)).iszero())
    CS = [ON, bcs, ZE]
    OMEGA = [ON - NU, ZE, ON + NU]
    alpha = sum((CS[i] * sum((G[i][j] * OMEGA[j] for j in range(3)), ZE)
                 for i in range(3)), ZE)
    chk("alpha = 9 + 3 sqrt33", (alpha - (F(9) + S33 * 3)).iszero())
    chk("alpha satisfies a^2-18a-216 = 0",
        (alpha * alpha - alpha * 18 - F(216)).iszero())
    chk("alpha != 0", not alpha.iszero())
    chk("beta = Q(E_x;v_-) = 1  (the xyz-coefficient)", (G[2][1] - ON).iszero())
    log()

    log("2. V_m[twist] generators DERIVED, and the m=3 FACTORISATION")
    gens = {}
    for m, tw, sg in ((1, "triv", ON), (1, "sgn", -ON),
                      (3, "triv", ON), (3, "sgn", -ON)):
        B = isotypic(m, 2, RHO_M, TAU_M, ON, sg)
        chk("dim V_%d[%s] = 1" % (m, tw), len(B) == 1)
        gens[(m, tw)] = B[0]
    for tw in ("triv", "sgn"):
        g1, g3 = gens[(1, tw)], gens[(3, tw)]
        # is g3 = h * g1 for some binary quadratic h ?
        rows = []
        for i in range(4):
            for k in range(2):
                rows.append([(g1[i - j][k] if 0 <= i - j <= 1 else ZE)
                             for j in range(3)] + [g3[i][k]])
        R, piv = rref(rows, 4)
        ok = 3 not in piv
        chk("V_3[%s] = (quadratic) . V_1[%s]  -- forced degeneracy" % (tw, tw),
            ok)
    log()

    log("3. the contraction ranks  (THE decisive table)")
    tbl = []
    for lab, n, m, key in (("m=1 I0", 2, 1, (1, "triv")),
                           ("m=1 I0", 2, 1, (1, "sgn")),
                           ("m=1 I1", 4, 1, (1, "triv")),
                           ("m=1 I2", 6, 1, (1, "triv")),
                           ("m=3 I0", 4, 3, (3, "triv")),
                           ("m=3 I0", 4, 3, (3, "sgn")),
                           ("m=3 I1", 6, 3, (3, "sgn"))):
        M = kappa_matrix_v(n, gens[key])
        src, tg = 3 * (n + 1), n + 2 * m + 1
        rk = rank(M, src)
        tbl.append((lab, "V%d[%s]" % key, src, tg, rk, src - rk))
        log("   %-8s Psi=V%d[%-4s]  dim %2d -> tgt %2d : rank %2d , KERNEL %2d"
            % (lab, key[0], key[1], src, tg, rk, src - rk))
    # generic Psi controls
    import random
    rnd = random.Random(20260806)
    for lab, n, m in (("m=1 I0 gen", 2, 1), ("m=3 I0 gen", 4, 3)):
        Pg = [[F(rnd.randint(-9, 9)) + OM * rnd.randint(-9, 9)
               + NU * rnd.randint(-9, 9) for _ in range(2)] for _ in range(m + 1)]
        M = kappa_matrix_v(n, Pg)
        src, tg = 3 * (n + 1), n + 2 * m + 1
        rk = rank(M, src)
        log("   %-11s generic Psi   dim %2d -> tgt %2d : rank %2d , KERNEL %2d"
            % (lab, src, tg, rk, src - rk))
    chk("I0 (m=1) kernel is 4-dimensional, NOT zero",
        3 * 3 - rank(kappa_matrix_v(2, gens[(1, "triv")]), 9) == 4)
    chk("I1 (m=1): rank 7 = full target (Thm 5.26-A)",
        rank(kappa_matrix_v(4, gens[(1, "triv")]), 15) == 7)
    chk("I1 (m=1): kernel 8 = 5+3 (Clebsch-Gordan 4(x)2 = 6+4+2)",
        15 - rank(kappa_matrix_v(4, gens[(1, "triv")]), 15) == 8)
    log()

    log("4. the S3-equivariant transfer condition at c_sigma (FIX-L1 regression)")
    for m, n, tw, exp_dim, exp_rk in ((1, 2, "triv", 2, 1), (1, 2, "sgn", 2, 1),
                                      (3, 4, "triv", 3, 2), (3, 4, "sgn", 3, 2)):
        BT = isotypic(n, 3, RHO_P, TAU_P, ON, ON)
        M = kappa_matrix_v(n, gens[(m, tw)])
        cols = []
        for T in BT:
            v = [T[i][k] for i in range(n + 1) for k in range(3)]
            cols.append([sum((M[r][c] * v[c] for c in range(len(v))), ZE)
                         for r in range(len(M))])
        rows = [[cols[c][r] for c in range(len(cols))] for r in range(len(M))]
        rk = rank(rows, len(BT))
        ker = nullspace(rows, len(BT))
        chk("m=%d %s : dim Theta^{S3} = %d , transfer rank = %d , KERNEL = %d"
            % (m, tw, len(BT), rk, len(ker)),
            len(BT) == exp_dim and rk == exp_rk and len(ker) == 1)
        # the survivor is NONZERO and really satisfies the identity
        v = ker[0]
        T = [[ZE, ZE, ZE] for _ in range(n + 1)]
        for j, cf in enumerate(v):
            for i in range(n + 1):
                for k in range(3):
                    T[i][k] = T[i][k] + cf * BT[j][i][k]
        chk("   -> survivor Theta^(0)(c_sigma) is NONZERO",
            any(not T[i][k].iszero() for i in range(n + 1) for k in range(3)))
        P = kappa_poly(T, n, gens[(m, tw)], m)
        chk("   -> and satisfies kappa(Theta) == 0 identically",
            all(c.iszero() for c in P.values()) or not P)
    log()

    log("5. MUST-FAIL CONTROLS")
    def mustfail(name, cond):
        chk("control correctly fails: %s" % name, not cond)
    mustfail("kappa injective at I0 (m=1)",
             rank(kappa_matrix_v(2, gens[(1, "triv")]), 9) == 9)
    mustfail("kappa injective at I1 (m=1)",
             rank(kappa_matrix_v(4, gens[(1, "triv")]), 15) == 15)
    mustfail("a bogus [1:1:0] is S3-fixed",
             all((mv(RHO_P, [ON, ON, ZE])[i] - [ON, ON, ZE][i]).iszero()
                 for i in range(3)))
    mustfail("dim V_1[sgn] = 2", len(isotypic(1, 2, RHO_M, TAU_M, ON, -ON)) == 2)
    mustfail("V_3[triv] = (quadratic) . V_1[sgn]",
             (lambda: (lambda R, piv: 3 not in piv)(
                 *rref([[(gens[(1, "sgn")][i - j][k] if 0 <= i - j <= 1 else ZE)
                         for j in range(3)] + [gens[(3, "triv")][i][k]]
                        for i in range(4) for k in range(2)], 4)))())
    log()
    log("=" * 68)
    log("VERIFIER: %d checks, %d FAILURES" % (len(OUT), len(FAIL)))
    if FAIL:
        for f in FAIL:
            log("   FAILED: %s" % f)
    return len(FAIL)


if __name__ == "__main__":
    nf = main()
    open(os.path.join(HERE, "payloads", "PAYLOAD_VERIFY.txt"), "w").write(
        "\n".join(OUT) + "\n")
    sys.exit(1 if nf else 0)
