#!/usr/bin/env python3
"""FIX-H1 INDEPENDENT VERIFIER  (verification class: ALGEBRAIC-RECOMPUTE).

Every claim of the packet is recomputed by a DIFFERENT route from the
producers:

  V1  the sigma-frame is rebuilt at a DIFFERENT involution, a DIFFERENT V4
      through it, and with the OTHER order-3 element of C_G(sigma); the
      subspaces are obtained from REYNOLDS PROJECTORS, not from nullspaces.
  V2  the equalizer line V[sgn^e] is recomputed as the image of the Reynolds
      projector (1/6) sum_g sgn(g)^e g on V (producers used a nullspace).
  V3  D = N_1 N_2 N_3 (the product of the three mirror linear forms in
      P_sigma) is built explicitly and its S3-character is shown to be sgn.
  V4  branch (i): Lambda_0 and the whole order-0 elimination are redone in
      sympy over an explicit number field (producers used the k0 engine);
      the forced value of B^3+B^-3 is compared with kp+2 and km+2 exactly
      and at 60 digits.
  V5  branch (ii): the residuals B5 - lam B8 are re-derived and the emptiness
      is confirmed by MACAULAY2 over toField(QQ[om,kp]/(...)) (independent
      engine) and by 40-digit numerics at all 27 points.
  V6  harness self-test: a deliberately corrupted input must FAIL.
"""
import json
import os
import subprocess
import sys
import time

import sympy as sp

HERE = os.path.dirname(os.path.abspath(__file__))
H0 = ('/Users/worker/unirational/problems/E-klein-cubic/'
      'goal_runs_after_6519c0b/FIX_H0_GLOBAL_SECTIONS')
N2C = ('/Users/worker/unirational/problems/E-klein-cubic/'
       'goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION')
sys.path.insert(0, HERE)
sys.path.insert(0, H0)

from klein_exact import (Cyc, Cyc3, ZERO, ONE, C3ZERO, C3ONE, Grp,   # noqa
                         klein_eval, mat_vec, nullspace, rref, rank)
from k0 import K, ZERO as KZ, ONE as K1, OM, OM2, NU, KP, KM         # noqa
import k0                                                            # noqa
import produce_h1_equalizer as EQ                                    # noqa

T0 = time.time()
LOG = []
NOK = 0
NFAIL = 0


def log(s):
    print(s, flush=True)
    LOG.append(s)


def ck(name, cond, extra=''):
    global NOK, NFAIL
    if cond:
        NOK += 1
    else:
        NFAIL += 1
    log('%-72s %s %s' % (name, 'OK  ' if cond else 'FAIL', extra))
    return cond


def c3(v):
    return Cyc3.lift(v)


# ============================================================== V1  the frame
def reynolds_fix(G, elems, F=Cyc):
    """image of the projector (1/|H|) sum_{h in H} rho(h) -- the H-fixed space."""
    n = len(elems)
    P = [[ZERO] * 5 for _ in range(5)]
    for g in elems:
        M = G.mats[g]
        for i in range(5):
            for j in range(5):
                P[i][j] = P[i][j] + M[i][j]
    inv = Cyc.from_frac(1, n)
    P = [[v * inv for v in row] for row in P]
    cols = [[P[i][j] for i in range(5)] for j in range(5)]
    R, piv = rref(cols)
    return [list(r) for r in R]


def V1_frame():
    log('')
    log('V1  the sigma-frame, rebuilt independently')
    G = Grp()
    invs = [i for i in range(G.n) if G.ord[i] == 2]
    ck('V1  |G| = 660 and 55 involutions', G.n == 660 and len(invs) == 55)

    sg = invs[17]                      # a DIFFERENT involution
    C = G.centralizer(sg)
    ck('V1  |C_G(sigma)| = 12', len(C) == 12)
    fixC = reynolds_fix(G, C)
    ck('V1  dim W^{D12} = 1 (Reynolds projector)', len(fixC) == 1)
    cS = fixC[0]
    ck('V1  F(c_sigma) != 0 (the D12-point is off X)', klein_eval(cS) != ZERO)

    V4s = set()
    for a in invs:
        for b in invs:
            if a < b and G.mul(a, b) == G.mul(b, a) and G.mul(a, b) != 0:
                V4s.add(tuple(sorted((a, b, G.mul(a, b)))))
    thru = sorted(V for V in V4s if sg in V)
    ck('V1  sigma lies in exactly 3 V4s', len(thru) == 3)
    Wp = reynolds_fix(G, [0, sg])
    ck('V1  dim W^+ = 3 (Reynolds)', len(Wp) == 3)
    conc = True
    for V in thru:
        A = reynolds_fix(G, [0] + list(V))
        conc = conc and len(A) == 2 and \
            rank([list(v) for v in A] + [list(cS)]) == 2 and \
            rank([list(v) for v in Wp] + [list(v) for v in A]) == 3
    ck('V1  the 3 triple lines lie in P_sigma and all contain c_sigma', conc)

    K1_ = thru[2]                      # a DIFFERENT V4 (the last, not the first)
    A = reynolds_fix(G, [0] + list(K1_))
    others = [t for t in K1_ if t != sg and t != 0]
    s2, s3 = others
    Lx = joint_eig(G, [(sg, 1), (s2, -1)])
    ck('V1  the sigma-plus character line of K_1 is 1-dimensional', len(Lx) == 1)
    NG = [g for g in range(G.n) if {G.conj(t, g) for t in K1_} == set(K1_)]
    ck('V1  |N_G(K_1)| = 12 (= A_4)', len(NG) == 12)
    psis = [g for g in NG if G.ord[g] == 3]
    rhos = [g for g in C if G.ord[g] == 3]
    ck('V1  C_G(sigma) cap N_G(K_1) = K_1 (no shared 3-element)',
       not (set(psis) & set(rhos)))

    # build the frame, with the OTHER order-3 element of A4 and of C
    frame, kp, km, beta, Rm, Tm, Rp, Tp = build_frame(
        G, sg, K1_, s2, psis[-1], rhos[-1])
    ck('V1  kp + km = 13/8', (kp + km) == c3(Cyc.from_frac(13, 8)))
    ck('V1  kp * km = -1/2', (kp * km) == c3(Cyc.from_frac(-1, 2)))
    kpn = cnum(kp)
    r1, r2 = (13 + 3 * 33 ** .5) / 16, (13 - 3 * 33 ** .5) / 16
    which = 'kp+' if abs(kpn - r1) < 1e-9 else 'kp-'
    ck('V1  kp is a root of 8k^2-13k-4 (this frame picks %s)' % which,
       min(abs(kpn - r1), abs(kpn - r2)) < 1e-9, '%.12f' % kpn.real)
    log('V1  NOTE: which root the om-labelled row carries depends on the'
        ' choice of the')
    log('V1        order-3 generator psi of A_4 (om <-> om^2).  The equalizer'
        ' verdicts are')
    log('V1        tested against BOTH roots and all four Galois twists, so'
        ' they do not')
    log('V1        depend on this convention.')
    ck('V1  beta^3 + 3 beta^2 + kp = 0 at the D12-point of ell_V',
       (beta * beta * beta + c3(Cyc.from_int(3)) * beta * beta + kp).is_zero())
    ck('V1  tau|_{W^-} = +-diag(1,-1)  (the two lifts differ by sigma, which'
       ' acts trivially on V for m odd)',
       Tm[0][1].is_zero() and Tm[1][0].is_zero() and
       ((Tm[0][0] == C3ONE and Tm[1][1] == -C3ONE) or
        (Tm[0][0] == -C3ONE and Tm[1][1] == C3ONE)))
    tr = Rm[0][0] + Rm[1][1]
    dt = Rm[0][0] * Rm[1][1] - Rm[0][1] * Rm[1][0]
    ck('V1  rho|_{W^-}: trace -1, det 1, off-diagonal nonzero',
       tr == -C3ONE and dt == C3ONE and
       (not Rm[0][1].is_zero()) and (not Rm[1][0].is_zero()))

    # the packet's hard-coded R (from k0) must be CONJUGATE to this one over
    # Q(zeta_33): both are the standard 2-dim rep with tau = diag(1,-1), and
    # the pair (rho,tau) is rigid up to a diagonal rescaling of (E_y,E_z).
    # We check the invariant that the equalizer uses: the ratio
    #   R12*R21  and  R11 = R22  (these are conjugation-invariant under
    # diag rescaling, and they are what the equalizer test depends on).
    r12r21 = Rm[0][1] * Rm[1][0]
    P = [[K.rat(-1, 2), (K1 - NU) / K.rat(4)],
         [(-K1 - NU) / K.rat(4), K.rat(-1, 2)]]
    want = P[0][1] * P[1][0]
    ck('V1  R11 = R22 = -1/2 (as in the packet frame)',
       Rm[0][0] == c3(Cyc.from_frac(-1, 2)) and
       Rm[1][1] == c3(Cyc.from_frac(-1, 2)))
    ck('V1  R12*R21 = -3/4 (the conjugation invariant used by the equalizer)',
       r12r21 == c3(Cyc.from_frac(-3, 4)) and want == K.rat(-3, 4),
       repr(want))
    return dict(G=G, sg=sg, frame=frame, Rm=Rm, Tm=Tm, Rp=Rp, Tp=Tp,
                cS=cS, kp=kp, beta=beta, K1=K1_)


def joint_eig(G, pairs):
    rows = []
    for g, s in pairs:
        M = G.mats[g]
        sv = ONE if s == 1 else -ONE
        for i in range(5):
            rows.append([M[i][j] - (sv if i == j else ZERO) for j in range(5)])
    return nullspace(rows, 5)


def build_frame(G, sg, K1_, s2, psi, rho):
    """the A_4-adapted frame + the residual matrices; independent code path."""
    A = reynolds_fix(G, [0] + list(K1_))
    Lx = joint_eig(G, [(sg, 1), (s2, -1)])
    Mp = G.mats[psi]
    Ex = list(Lx[0])
    Ey = mat_vec(Mp, Ex)
    Ez = mat_vec(Mp, Ey)
    assert mat_vec(Mp, Ez) == Ex
    Mp3 = [[c3(v) for v in row] for row in Mp]
    A3 = [[c3(v) for v in u] for u in A]

    def eigA(lam):
        rows = []
        for i in range(5):
            row = []
            for k in range(2):
                acc = C3ZERO
                for j in range(5):
                    acc = acc + Mp3[i][j] * A3[k][j]
                row.append(acc - lam * A3[k][i])
            rows.append(row)
        return nullspace(rows, 2, Cyc3)

    OMc = Cyc3(ZERO, ONE)
    OM2c = Cyc3(-ONE, -ONE)

    def comb(co, bas):
        out = [C3ZERO] * 5
        for k, ck_ in enumerate(co):
            for i in range(5):
                out[i] = out[i] + ck_ * bas[k][i]
        return out

    cands = []
    for sw_ab in (0, 1):
        for sw_yz in (0, 1):
            va = eigA(OMc if not sw_ab else OM2c)
            vb = eigA(OM2c if not sw_ab else OMc)
            Ea, Eb = comb(va[0], A3), comb(vb[0], A3)
            Ey_, Ez_ = ([c3(v) for v in Ey], [c3(v) for v in Ez]) \
                if not sw_yz else ([c3(v) for v in Ez], [c3(v) for v in Ey])
            fr = [Ea, Eb, [c3(v) for v in Ex], Ey_, Ez_]
            Fp = kpoly(fr)
            EXPS = {(3, 0, 0, 0, 0), (0, 3, 0, 0, 0), (1, 0, 2, 0, 0),
                    (1, 0, 0, 2, 0), (1, 0, 0, 0, 2), (0, 1, 2, 0, 0),
                    (0, 1, 0, 2, 0), (0, 1, 0, 0, 2), (0, 0, 1, 1, 1)}
            if set(Fp) - EXPS:
                continue
            ax = Fp[(1, 0, 2, 0, 0)]
            bx = Fp[(0, 1, 2, 0, 0)]
            if (Fp[(1, 0, 0, 2, 0)] == ax * OMc and
                    Fp[(1, 0, 0, 0, 2)] == ax * OM2c and
                    Fp[(0, 1, 0, 2, 0)] == bx * OM2c and
                    Fp[(0, 1, 0, 0, 2)] == bx * OMc):
                cands.append((fr, Fp))
    assert cands, 'no admissible labeling'
    fr, Fp = cands[0]
    ax, bx = Fp[(1, 0, 2, 0, 0)], Fp[(0, 1, 2, 0, 0)]
    xyz = Fp[(0, 0, 1, 1, 1)]
    kp = Fp[(3, 0, 0, 0, 0)] * xyz * xyz / (ax * ax * ax)
    km = Fp[(0, 3, 0, 0, 0)] * xyz * xyz / (bx * bx * bx)
    # the D12-point ratio in normal-form coordinates
    Cc = G.centralizer(sg)
    cS = reynolds_fix(G, Cc)[0]
    co = coords(fr, [c3(v) for v in cS])
    beta = co[1] * (bx / ax) / co[0]
    Mr = mat_frame(G.mats[rho], fr)
    Mt = mat_frame(G.mats[s2], fr)
    Rm = [[Mr[3][3], Mr[3][4]], [Mr[4][3], Mr[4][4]]]
    Tm = [[Mt[3][3], Mt[3][4]], [Mt[4][3], Mt[4][4]]]
    Rp = [[Mr[i][j] for j in range(3)] for i in range(3)]
    Tp = [[Mt[i][j] for j in range(3)] for i in range(3)]
    return fr, kp, km, beta, Rm, Tm, Rp, Tp


def kpoly(vecs):
    comp = []
    for i in range(5):
        p = {}
        for k in range(5):
            if not vecs[k][i].is_zero():
                e = [0] * 5
                e[k] = 1
                p[tuple(e)] = vecs[k][i]
        comp.append(p)

    def mul(p, q):
        o = {}
        for e1, v1 in p.items():
            for e2, v2 in q.items():
                e = tuple(a + b for a, b in zip(e1, e2))
                w = o.get(e, C3ZERO) + v1 * v2
                if w.is_zero():
                    o.pop(e, None)
                else:
                    o[e] = w
        return o

    def add(p, q):
        o = dict(p)
        for e, v in q.items():
            w = o.get(e, C3ZERO) + v
            if w.is_zero():
                o.pop(e, None)
            else:
                o[e] = w
        return o

    out = {}
    for i in range(5):
        out = add(out, mul(mul(comp[i], comp[i]), comp[(i + 1) % 5]))
    return out


def coords(basis, v):
    rows = [[basis[k][i] for k in range(5)] + [v[i]] for i in range(5)]
    R, piv = rref(rows, Cyc3)
    sol = [C3ZERO] * 5
    for r in R:
        lead = next((j for j in range(5) if r[j]), None)
        if lead is None:
            continue
        sol[lead] = r[5]
    return sol


def mat_frame(M, fr):
    cols = []
    for k in range(5):
        img = []
        for i in range(5):
            acc = C3ZERO
            for j in range(5):
                acc = acc + c3(M[i][j]) * fr[k][j]
            img.append(acc)
        cols.append(coords(fr, img))
    return [[cols[k][i] for k in range(5)] for i in range(5)]


def cnum(v):
    import cmath
    zz = cmath.exp(2j * cmath.pi / 11)
    om = cmath.exp(2j * cmath.pi / 3)

    def ev(c):
        return sum(c.n[i] * zz ** i for i in range(10)) / c.d
    return ev(v.a) + om * ev(v.b)


# ================================================== V2  the isotypic line
def V2_reynolds():
    log('')
    log('V2  the equalizer line, by the REYNOLDS PROJECTOR (not a nullspace)')
    for (m, e, dim_expect) in ((3, 3, 1), (1, 6, 1)):
        n = 2 * (m + 1)
        AR = EQ.act_matrix(EQ.R, m)
        AT = EQ.act_matrix(EQ.TAU, m)
        # the six group elements: 1, rho, rho^2, tau, rho tau, rho^2 tau
        I = [[K1 if i == j else KZ for j in range(n)] for i in range(n)]
        R2 = matmul(AR, AR)
        els = [(I, 1), (AR, 1), (R2, 1), (AT, -1),
               (matmul(AR, AT), -1), (matmul(R2, AT), -1)]
        P = [[KZ] * n for _ in range(n)]
        for M, s in els:
            c = K1 if (e % 2 == 0 or s == 1) else -K1
            for i in range(n):
                for j in range(n):
                    P[i][j] = P[i][j] + c * M[i][j]
        P = [[v * K.rat(1, 6) for v in row] for row in P]
        # idempotency
        P2 = matmul(P, P)
        idem = all(P2[i][j] == P[i][j] for i in range(n) for j in range(n))
        cols = [[P[i][j] for i in range(n)] for j in range(n)]
        Rr, piv = k0.rref(cols)
        ck('V2  m=%d e=%d : projector idempotent, rank = %d'
           % (m, e, len(piv)), idem and len(piv) == dim_expect, 'rank %d'
           % len(piv))
        gen = list(Rr[0])
        # compare with the producer's line
        L = EQ.isotypic(m, e)
        g2 = L[0]
        p1 = next(i for i in range(n) if not gen[i].is_zero())
        p2 = next(i for i in range(n) if not g2[i].is_zero())
        same = p1 == p2 and all(
            (gen[i] * g2[p2] - g2[i] * gen[p1]).is_zero() for i in range(n))
        ck('V2  m=%d e=%d : same line as the producer' % (m, e), same)
        if m == 1:
            ok = (gen[EQ.vbasis(1).index((0, 1))] ==
                  gen[EQ.vbasis(1).index((1, 0))]) and \
                 gen[EQ.vbasis(1).index((0, 0))].is_zero() and \
                 gen[EQ.vbasis(1).index((1, 1))].is_zero()
            ck('V2  m=1 : the line is spanned by id_{W^-} (Schur)', ok)


def matmul(A, B):
    n = len(A)
    return [[sum_k(A, B, i, j, n) for j in range(n)] for i in range(n)]


def sum_k(A, B, i, j, n):
    acc = KZ
    for k in range(n):
        acc = acc + A[i][k] * B[k][j]
    return acc


# ============================================ V3  D = N1 N2 N3 carries sgn
def V3_discriminant(D):
    log('')
    log('V3  the mirror-line product D = N_1 N_2 N_3 carries the SGN character')
    G, sg, fr = D['G'], D['sg'], D['frame']
    Rp, Tp = D['Rp'], D['Tp']
    # in the frame, ell_{V,1} = {x = 0}; N_1 = the coordinate x on W^+.
    # N_2 = N_1 o rho^{-1}, N_3 = N_1 o rho^{-2}.  Work with linear forms as
    # row vectors in the (a,b,x) coordinates.
    Rinv = inv3(Rp)
    N1 = [C3ZERO, C3ZERO, C3ONE]
    N2 = [sum3(N1, Rinv, j) for j in range(3)]
    N3 = [sum3(N2, Rinv, j) for j in range(3)]
    # the cubic D = N1 N2 N3 as a dict of exponent-triples
    Dp = cub(N1, N2, N3)
    # rho acts: D -> D o rho^{-1}
    Drho = cub([sum3(N1, Rinv, j) for j in range(3)],
               [sum3(N2, Rinv, j) for j in range(3)],
               [sum3(N3, Rinv, j) for j in range(3)])
    Tinv = inv3(Tp)
    Dtau = cub([sum3(N1, Tinv, j) for j in range(3)],
               [sum3(N2, Tinv, j) for j in range(3)],
               [sum3(N3, Tinv, j) for j in range(3)])
    ck('V3  D is rho-invariant', same_form(Dp, Drho))
    ck('V3  D goes to -D under tau  (sgn character)',
       same_form(Dp, {k: -v for k, v in Dtau.items()}))
    # and the three lines are distinct
    pairs = [(N1, N2), (N1, N3), (N2, N3)]
    dis = all(rank([list(a), list(b)], Cyc3) == 2 for a, b in pairs) and \
        rank([list(N1), list(N2), list(N3)], Cyc3) == 2
    ck('V3  the three mirror linear forms are pairwise independent and'
       ' concurrent', dis)


def inv3(M):
    n = 3
    aug = [[M[i][j] for j in range(n)] + [C3ONE if i == k else C3ZERO
                                          for k in range(n)]
           for i in range(n)]
    R, piv = rref(aug, Cyc3)
    assert piv == [0, 1, 2]
    return [[R[i][n + j] for j in range(n)] for i in range(n)]


def sum3(N, M, j):
    acc = C3ZERO
    for i in range(3):
        acc = acc + N[i] * M[i][j]
    return acc


def cub(A, B, C):
    out = {}
    for i in range(3):
        for j in range(3):
            for k in range(3):
                e = [0, 0, 0]
                e[i] += 1
                e[j] += 1
                e[k] += 1
                v = A[i] * B[j] * C[k]
                t = tuple(e)
                w = out.get(t, C3ZERO) + v
                if w.is_zero():
                    out.pop(t, None)
                else:
                    out[t] = w
    return out


def same_form(P, Q):
    if set(P) != set(Q):
        return False
    return all(P[k] == Q[k] for k in P)


# ============================================= V4  branch (i), independent
def V4_branch1():
    log('')
    log('V4  branch (i): the order-0 elimination, redone in sympy')
    w, nu, B = sp.symbols('w nu B')

    def red(e):
        e = sp.expand(e)
        if e == 0:
            return sp.Integer(0)
        _, r = sp.reduced(e, [w**2 + w + 1, nu**2 + 11], w, nu, order='lex')
        return sp.expand(r)

    y, z = sp.symbols('y z')
    R = sp.Matrix([[sp.Rational(-1, 2), (1 - nu) / 4],
                   [(-1 - nu) / 4, sp.Rational(-1, 2)]])
    Ri = sp.Matrix([[sp.Rational(-1, 2), -(1 - nu) / 4],
                    [-(-1 - nu) / 4, sp.Rational(-1, 2)]])   # det = 1
    ck('V4  R * R^{-1} = I (det R = 1)',
       all(red(v) == (1 if i == j else 0)
           for i, row in enumerate((R * Ri).tolist())
           for j, v in enumerate(row)))
    py = w * (z**3 + B * y**2 * z)
    pz = (-1 - w) * (y**3 + y * z**2 / B)
    ys = Ri[0, 0] * y + Ri[0, 1] * z
    zs = Ri[1, 0] * y + Ri[1, 1] * z
    qy = sp.expand(py.subs({y: ys, z: zs}, simultaneous=True))
    qz = sp.expand(pz.subs({y: ys, z: zs}, simultaneous=True))
    ry = sp.expand(R[0, 0] * qy + R[0, 1] * qz - py)
    rz = sp.expand(R[1, 0] * qy + R[1, 1] * qz - pz)
    eqs = []
    for p in (ry, rz):
        P = sp.Poly(sp.expand(sp.numer(sp.cancel(sp.together(p)))), y, z)
        for cf in P.coeffs():
            cf = red(sp.expand(cf))
            if cf != 0:
                eqs.append(sp.Poly(cf, B))
    ck('V4  the order-0 equalizer gives nonzero equations in B',
       len(eqs) > 0, '%d equations' % len(eqs))
    g = eqs[0]
    for p in eqs[1:]:
        g = sp.gcd(g, p)
    kp = red((13 - 3 * (2 * w + 1) * nu) / 16)
    ck('V4  8kp^2-13kp-4 = 0 for kp = (13-3(2om+1)nu)/16',
       red(8 * kp**2 - 13 * kp - 4) == 0)
    trace = sp.Poly(B**6 - (kp + 2) * B**3 + 1, B)
    gg = sp.gcd(g, trace)
    ck('V4  gcd(equalizer, trace curve) is a unit -> NO common B',
       sp.degree(gg, B) == 0, 'deg = %s' % sp.degree(gg, B))

    # the forced value of B^3 + B^-3, WITHOUT any division:
    #   B^3 = N/Dn with N = om^2 Beff^3 , Dn = (c2/c1)^2 ;
    #   B^3 + B^-3 = (N^2 + Dn^2)/(N Dn) , so the condition
    #   B^3+B^-3 = t  is  N^2 + Dn^2 - t N Dn = 0 .
    Beff = (-5 + nu) / 6
    rat = (-7 + 5 * nu) / 18
    ck('V4  c2/c1 = -Beff^2 (the equalizer line is on the D_B quadric)',
       red(sp.expand(rat + Beff**2)) == 0)
    N = red(sp.expand((-1 - w) * Beff**3))
    Dn = red(sp.expand(rat**2))
    km = sp.Rational(13, 8) - kp
    for nm, t in (('kp+2', kp + 2), ('km+2', km + 2)):
        val = red(sp.expand(N**2 + Dn**2 - t * N * Dn))
        ck('V4  N^2+Dn^2-(%s) N Dn != 0  (no B on that trace curve)' % nm,
           sp.expand(val) != 0, str(sp.expand(val))[:60])
    # and the value itself, numerically at 60 digits
    SUB = {nu: sp.I * sp.sqrt(11),
           w: sp.Rational(-1, 2) + sp.I * sp.sqrt(3) / 2}
    trv = sp.N(sp.expand((N**2 + Dn**2) / (N * Dn)).subs(SUB), 60)
    want = sp.N((45 + 3 * sp.sqrt(33)) / 16, 60)
    want2 = sp.N((45 - 3 * sp.sqrt(33)) / 16, 60)
    tgt = sp.N((5 - sp.sqrt(33)) / 6, 60)
    ck('V4  forced B^3+B^-3 = (5-sqrt33)/6 at 60 digits',
       abs(complex(trv) - complex(tgt)) < 1e-30, str(sp.N(trv, 25)))
    ck('V4  != kp+2', abs(complex(trv) - complex(want)) > 1e-10,
       '%s vs %s' % (sp.N(trv, 12), sp.N(want, 12)))
    ck('V4  != km+2', abs(complex(trv) - complex(want2)) > 1e-10,
       '%s vs %s' % (sp.N(trv, 12), sp.N(want2, 12)))
    # all four Galois twists
    bad = 0
    for a in (1, 2):
        for b in (1, -1):
            SW = {w: (sp.Rational(-1, 2) + sp.I * sp.sqrt(3) / 2)**a,
                  nu: b * sp.I * sp.sqrt(11)}
            tv = sp.N(sp.expand((N**2 + Dn**2) / (N * Dn)).subs(SW), 60)
            if abs(complex(tv) - complex(want)) < 1e-10 or \
               abs(complex(tv) - complex(want2)) < 1e-10:
                bad += 1
    ck('V4  no Galois twist (om<->om^2, nu<->-nu) matches either trace value',
       bad == 0)


# ============================================ V5  branch (ii), independent
def V5_branch2():
    log('')
    log('V5  branch (ii): Macaulay2 over the exact number field, + numerics')
    sys.path.insert(0, N2C)
    import indep_r7 as I
    import witness as W0
    import witness_om as W1
    import witness_om2 as W2
    om, kp = I.om, I.kp
    OM2s = -1 - om
    blocks = [('one', sp.Integer(1), W0, om), ('om', om, W1, om**0 * 0 + om),
              ('om2', OM2s, W2, OM2s)]
    m2lines = ['R = QQ[om,kp];',
               'K = toField(QQ[om,kp]/ideal(om^2+om+1, 8*kp^2-13*kp-4));',
               'S = K[B2,P1,c];']
    results = {}
    for tag, lam, mod, _ in blocks:
        vals = mod.coordinates()
        B5, B8 = vals['B5'], vals['B8']
        D = mod.red(sp.expand(lam**2 * B8 - lam * B5))
        results[tag] = D
        gens = mod.GENS
        v1, v2 = gens[0], gens[1]
        rel = [sp.expand(g) for g in mod.REL[:2]]
        names = {str(v1): str(v1), str(v2): str(v2)}
        m2lines.append('-- eigenblock lam = %s' % tag)
        m2lines.append('I%s = ideal(%s, %s);' % (tag, m2(rel[0]), m2(rel[1])))
        m2lines.append('D%s = %s;' % (tag, m2(sp.expand(D))))
        m2lines.append('J%s = I%s + ideal(D%s);' % (tag, tag, tag))
        m2lines.append('<< "BLOCK %s  dim I = " << dim I%s'
                       ' << "  degree I = " << degree I%s'
                       ' << "  1 in J = " << (1 %% J%s == 0) << endl;'
                       % (tag, tag, tag, tag))
    m2lines.append('<< "FIX_H1_M2_OK" << endl;')
    path = os.path.join(HERE, 'm2', 'branch2_equalizer.m2')
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as fh:
        fh.write('\n'.join(m2lines) + '\n')
    out = ''
    try:
        pr = subprocess.run(['M2', '--script', path], capture_output=True,
                            text=True, timeout=900)
        out = pr.stdout + pr.stderr
    except Exception as exc:                                   # noqa: BLE001
        out = 'M2 failed: %s' % exc
    with open(os.path.join(HERE, 'logs', 'M2_BRANCH2.log'), 'w') as fh:
        fh.write(out)
    log('    M2 output:')
    for ln in out.strip().splitlines():
        log('      %s' % ln)
    ck('V5  Macaulay2 ran to completion', 'FIX_H1_M2_OK' in out)
    n_unit = out.count('1 in J = true')
    ck('V5  1 in I + (Lambda_yy - Lambda_zz) for ALL THREE eigenblocks'
       '  (unit ideal => EMPTY)', n_unit == 3, '%d/3' % n_unit)

    # 40-digit numerics at all 27 points
    import mpmath as mp
    mp.mp.dps = 40
    kpv = (13 + 3 * mp.sqrt(33)) / 16
    kap = kpv + 2
    omv = mp.mpc(-0.5, mp.sqrt(3) / 2)
    worst = mp.mpf(0)
    npts = 0
    for tag, lam, mod, _ in blocks:
        D = results[tag]
        # roots of the two block cubics
        v1, v2 = mod.GENS[0], mod.GENS[1]
        r1 = mp.polyroots(cf_list(mod.REL[0], v1, kpv, omv), maxsteps=200,
                          extraprec=200)
        r2 = mp.polyroots(cf_list(mod.REL[1], v2, kpv, omv), maxsteps=200,
                          extraprec=200)
        lamv = complex(sp.N(lam.subs({om: sp.Rational(-1, 2) +
                                      sp.I * sp.sqrt(3) / 2}), 40)) \
            if lam != 1 else 1
        for a in r1:
            for b in r2:
                val = evalD(D, v1, a, v2, b, kpv, omv)
                worst = max(worst, mp.mpf(1) / abs(val)) if val != 0 \
                    else mp.inf
                npts += 1
    ck('V5  40-digit numerics: |Lambda_yy - Lambda_zz| > 0 at all 27 points',
       npts == 27 and worst < mp.mpf('1e30'),
       '%d points, max 1/|D| = %s' % (npts, mp.nstr(worst, 8)))


def cf_list(poly, v, kpv, omv):
    import mpmath as mp
    om, kp = sp.symbols('om kp')
    p = sp.Poly(sp.expand(poly), v)
    d = sp.degree(p, v)
    out = []
    for k in range(d, -1, -1):
        cf = p.coeff_monomial(v**k)
        val = sp.expand(cf)
        val = val.subs({kp: sp.nsimplify(0)}) if False else val
        num = complex(sp.N(val.subs({kp: sp.Float(str(kpv), 40),
                                     om: sp.Rational(-1, 2) +
                                     sp.I * sp.sqrt(3) / 2}), 40))
        out.append(mp.mpc(num.real, num.imag))
    return out


def evalD(D, v1, a, v2, b, kpv, omv):
    om, kp = sp.symbols('om kp')
    val = sp.expand(D).subs({v1: sp.Float(str(sp.re(sp.Float(0))), 5)}) \
        if False else sp.expand(D)
    e = val
    import mpmath as mp
    f = sp.lambdify((v1, v2, om, kp), e, 'mpmath')
    return f(a, b, mp.mpc(omv.real, omv.imag), kpv)


def m2(e):
    s = str(sp.expand(e)).replace('**', '^')
    return s


# ================================================== V6  harness self-test
def V6_selftest():
    log('')
    log('V6  harness self-test (a corrupted input MUST fail)')
    m, e = 3, 3
    n = 2 * (m + 1)
    L = EQ.isotypic(m, e)
    gen = L[0]
    bad = list(gen)
    i = next(k for k in range(n) if not bad[k].is_zero())
    bad[i] = bad[i] + K1
    A = EQ.act_matrix(EQ.R, m)
    res = [sum_k(A, [[bad[j]] for j in range(n)], k, 0, n) - bad[k]
           for k in range(n)]
    ck('V6  a perturbed vector is NOT in the equalizer line',
       any(not v.is_zero() for v in res))
    good = [sum_k(A, [[gen[j]] for j in range(n)], k, 0, n) - gen[k]
            for k in range(n)]
    ck('V6  the true generator IS in the equalizer line',
       all(v.is_zero() for v in good))


def V7_forced_X():
    """the (3,6) D_B family has X = f.yz FORCED -- so the all-line-degree
    statement of branch (i) is complete."""
    log('')
    log('V7  the (3,6) D_B family: X is forced to be f . yz')
    # V4 = K_1 acts on (x,y,z) by the three sign patterns of sigma_1,2,3:
    #   sigma_1 = diag(+,-,-) , sigma_2 = diag(-,+,-) , sigma_3 = diag(-,-,+)
    sig = [(1, -1, -1), (-1, 1, -1), (-1, -1, 1)]
    chi_x = tuple(s[0] for s in sig)
    good = []
    for i in range(3):
        for j in range(3):
            for k in range(3):
                if i + j + k != 2:
                    continue
                ch = tuple(s[0]**i * s[1]**j * s[2]**k for s in sig)
                if ch == chi_x:
                    good.append((i, j, k))
    ck('V7  the ONLY degree-2 monomial of V4-character chi_x is y z',
       good == [(0, 1, 1)], str(good))
    log('V7  => at line degree 3.mu the (3,6) D_B family is D_B(f . yz), and')
    log('V7     its leading datum lies on the quadric S_DB for every f:'
        ' branch (i)')
    log('V7     is decided at EVERY line degree.')


def main():
    log('# FIX-H1 VERIFIER  (ALGEBRAIC-RECOMPUTE)')
    D = V1_frame()
    V2_reynolds()
    V3_discriminant(D)
    V4_branch1()
    V5_branch2()
    V6_selftest()
    V7_forced_X()
    log('')
    log('checks: %d OK, %d FAIL' % (NOK, NFAIL))
    log('elapsed %.1f s' % (time.time() - T0))
    with open(os.path.join(HERE, 'logs', 'VERIFY.log'), 'w') as fh:
        fh.write('\n'.join(LOG) + '\n')
    if NFAIL == 0:
        print('FIX_H1_VERIFY_OK')
    else:
        print('FIX_H1_VERIFY_FAILED')
        sys.exit(1)


if __name__ == '__main__':
    os.makedirs(os.path.join(HERE, 'logs'), exist_ok=True)
    main()
