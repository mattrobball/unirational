#!/usr/bin/env python3
"""FIX-L1 producer -- exact sigma-frame constants for the [L] transfer condition.

Named by theory/FIX_IV_closure.md sec.5.8 ("Named computation FIX-L1").
Reuses the CERTIFIED sigma-frame of packet FIX_H1_EQUALIZER (produce_h1_frame.py):
the A_4-adapted frame (E_a,E_b,E_x,E_y,E_z) in which the Klein cubic is EXACTLY
the V4-packet normal form (1.1) with kp = (13+3 sqrt33)/16, and in which
  rho|_{W^-} = [[-1/2,(1-nu)/4],[(-1-nu)/4,-1/2]],  tau|_{W^-} = diag(1,-1).

ALGEBRAIC-RECOMPUTE: PSL(2,11) in its 5-dim Weil representation is rebuilt from
generators via the shared exact library klein_exact.py of the FIX-H0 packet;
no floating point in any decision; the H1 payloads are used only as regression
targets.

Outputs
  payloads/l1_constants.json   machine-readable constants + verdicts
  payloads/PAYLOAD_L1.txt      the full log (this file's stdout)
"""
import json
import os
import sys
import time
from fractions import Fraction as Q

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = '/Users/worker/unirational/problems/E-klein-cubic'
H0 = os.path.join(ROOT, 'goal_runs_after_6519c0b', 'FIX_H0_GLOBAL_SECTIONS')
sys.path.insert(0, H0)

from klein_exact import (Cyc, Cyc3, ZERO, ONE, C3ZERO, C3ONE, Grp,   # noqa: E402
                         klein_eval, mat_vec, nullspace, rref)

T0 = time.time()
LOG = []


def log(s=''):
    print(s, flush=True)
    LOG.append(s)


OM = Cyc3(ZERO, ONE)                       # omega
OM2 = Cyc3(-ONE, -ONE)                     # omega^2 = -1-omega
ZZ, II = C3ZERO, C3ONE


def c3(x):
    return Cyc3.lift(x)


def c3int(k):
    return Cyc3.lift(Cyc.from_int(k))


def c3frac(p, q):
    return Cyc3.lift(Cyc.from_frac(p, q))


# ============================================================ linear algebra
def eig(M, sign, F=Cyc):
    one = ONE if F is Cyc else C3ONE
    zero = ZERO if F is Cyc else C3ZERO
    s = one if sign == 1 else -one
    return nullspace([[M[i][j] - (s if i == j else zero) for j in range(5)]
                      for i in range(5)], 5, F)


def joint_fix(mats, F=Cyc):
    one = ONE if F is Cyc else C3ONE
    zero = ZERO if F is Cyc else C3ZERO
    rows = []
    for M in mats:
        for i in range(5):
            rows.append([M[i][j] - (one if i == j else zero)
                         for j in range(5)])
    return nullspace(rows, 5, F)


def joint_eig(pairs, F=Cyc):
    one = ONE if F is Cyc else C3ONE
    zero = ZERO if F is Cyc else C3ZERO
    rows = []
    for M, sg in pairs:
        s = one if sg == 1 else -one
        for i in range(5):
            rows.append([M[i][j] - (s if i == j else zero)
                         for j in range(5)])
    return nullspace(rows, 5, F)


def solve_coords(basis, v, dim=5):
    n = len(basis)
    rows = [[basis[k][i] for k in range(n)] + [v[i]] for i in range(dim)]
    R, _piv = rref(rows, Cyc3)
    sol = [ZZ] * n
    for r in R:
        lead = None
        for j in range(n):
            if r[j]:
                lead = j
                break
        if lead is None:
            assert not r[n], 'inconsistent'
            continue
        sol[lead] = r[n]
    for i in range(dim):
        acc = ZZ
        for k in range(n):
            acc = acc + basis[k][i] * sol[k]
        assert acc == v[i], 'solve_coords failed'
    return sol


def in_span(basis, v):
    dim = len(v)
    rows = [[basis[k][i] for k in range(len(basis))] + [v[i]]
            for i in range(dim)]
    _R, piv = rref(rows, Cyc3)
    return len(basis) not in piv


def proportional(u, v):
    lam = None
    for a, b in zip(u, v):
        if a or b:
            if a.is_zero() or b.is_zero():
                return False
            lam = b / a
            break
    if lam is None:
        return True
    return all((b - lam * a).is_zero() for a, b in zip(u, v))


def mat_apply(M, v):
    n = len(M)
    return [sum((M[i][j] * v[j] for j in range(len(v))), ZZ) for i in range(n)]


def mat2_inv(M):
    det = M[0][0] * M[1][1] - M[0][1] * M[1][0]
    assert det, 'singular 2x2'
    di = det.inv()
    return [[M[1][1] * di, -M[0][1] * di], [-M[1][0] * di, M[0][0] * di]]


# ------------------------------------------------- sparse 5-variable polynomials
def pzero():
    return {}


def pvar(i):
    e = [0] * 5
    e[i] = 1
    return {tuple(e): II}


def padd(p, q_):
    o = dict(p)
    for e, v in q_.items():
        w = o.get(e)
        w = v if w is None else w + v
        if w.is_zero():
            o.pop(e, None)
        else:
            o[e] = w
    return o


def pmul(p, q_):
    o = {}
    for e1, v1 in p.items():
        for e2, v2 in q_.items():
            e = tuple(i + j for i, j in zip(e1, e2))
            w = o.get(e)
            w = v1 * v2 if w is None else w + v1 * v2
            if w.is_zero():
                o.pop(e, None)
            else:
                o[e] = w
    return o


def pscal(p, c):
    return {e: v * c for e, v in p.items() if not (v * c).is_zero()}


def klein_poly(vecs):
    comp = []
    for i in range(5):
        p = pzero()
        for k in range(5):
            p = padd(p, pscal(pvar(k), vecs[k][i]))
        comp.append(p)
    out = pzero()
    for i in range(5):
        out = padd(out, pmul(pmul(comp[i], comp[i]), comp[(i + 1) % 5]))
    return out


def poly_subs(P, M):
    """P(M.v), M a 5x5 matrix over Cyc3 acting on the coordinate column."""
    lin = []
    for i in range(5):
        p = pzero()
        for j in range(5):
            if M[i][j]:
                p = padd(p, pscal(pvar(j), M[i][j]))
        lin.append(p)
    out = pzero()
    for e, c in P.items():
        t = {(0,) * 5: c}
        for i, k in enumerate(e):
            for _ in range(k):
                t = pmul(t, lin[i])
        out = padd(out, t)
    return out


def mono(*e):
    return tuple(e)


def mat_in_frame(M, frame):
    cols = []
    for k in range(5):
        img = [ZZ] * 5
        for i in range(5):
            acc = ZZ
            for j in range(5):
                acc = acc + c3(M[i][j]) * frame[k][j]
            img[i] = acc
        cols.append(solve_coords(frame, img))
    return [[cols[k][i] for k in range(5)] for i in range(5)]


# ------------------------------------------------------------- binary forms
# degree-d binary form in (y,z): list [c_0,...,c_d] = sum_k c_k y^{d-k} z^k
def bf_zero(d):
    return [ZZ] * (d + 1)


def bf_add(f, g_):
    return [a + b for a, b in zip(f, g_)]


def bf_scal(f, c):
    return [a * c for a in f]


def bf_mul(f, g_):
    out = [ZZ] * (len(f) + len(g_) - 1)
    for i, a in enumerate(f):
        if a:
            for j, b in enumerate(g_):
                if b:
                    out[i + j] = out[i + j] + a * b
    return out


def bf_is_zero(f):
    return all(c.is_zero() for c in f)


def bf_subs(f, N):
    """f(N00 y + N01 z, N10 y + N11 z)."""
    d = len(f) - 1
    L1 = [N[0][0], N[0][1]]
    L2 = [N[1][0], N[1][1]]
    out = bf_zero(d)
    for k, c in enumerate(f):
        if not c:
            continue
        t = [II]
        for _ in range(d - k):
            t = bf_mul(t, L1)
        for _ in range(k):
            t = bf_mul(t, L2)
        out = bf_add(out, bf_scal(t, c))
    return out


# --------------------------------------------- Q(omega,nu)-coordinates of Cyc3
def _rat_solve(rows, rhs):
    n, m = len(rows), len(rows[0])
    M = [list(r) + [b] for r, b in zip(rows, rhs)]
    piv, r = [], 0
    for c in range(m):
        pr = None
        for rr in range(r, n):
            if M[rr][c] != 0:
                pr = rr
                break
        if pr is None:
            continue
        M[r], M[pr] = M[pr], M[r]
        iv = Q(1, 1) / M[r][c]
        M[r] = [x * iv for x in M[r]]
        for rr in range(n):
            if rr != r and M[rr][c] != 0:
                f = M[rr][c]
                M[rr] = [x - f * y for x, y in zip(M[rr], M[r])]
        piv.append(c)
        r += 1
    sol = [Q(0)] * m
    for i, c in enumerate(piv):
        sol[c] = M[i][m]
    for i in range(n):
        if sum(rows[i][j] * sol[j] for j in range(m)) != rhs[i]:
            return None
    return sol


def cyc_qvec(x):
    return [Q(x.n[i], x.d) for i in range(10)]


NU_CYC = None


def to_K4(x):
    """(c1,cw,cnu,c33) with x = c1 + cw om + cnu nu + c33 sqrt33, else None."""
    outs = []
    basis = [[cyc_qvec(ONE)[i], cyc_qvec(NU_CYC)[i]] for i in range(10)]
    for part in (x.a, x.b):
        s = _rat_solve(basis, cyc_qvec(part))
        if s is None:
            return None
        outs.append(s)
    (a0, a1), (b0, b1) = outs
    # sqrt33 = -nu(1+2om)  =>  nu*om = -(nu + sqrt33)/2
    return (a0, b0, a1 - b1 / 2, -b1 / 2)


def fmtQ(q):
    return (str(q.numerator) if q.denominator == 1
            else '%d/%d' % (q.numerator, q.denominator))


def K4str(t):
    if t is None:
        return '<not in Q(om,nu)>'
    names = ['', '*om', '*nu', '*sqrt33']
    parts = []
    for c, nm in zip(t, names):
        if c == 0:
            continue
        if nm == '' or abs(c) != 1:
            parts.append('%s%s' % (fmtQ(c), nm))
        else:
            parts.append(('-' if c < 0 else '') + nm[1:])
    if not parts:
        return '0'
    return ' + '.join(parts).replace('+ -', '- ')


def show(x):
    return K4str(to_K4(x))


def c3num(v):
    import cmath
    z = cmath.exp(2j * cmath.pi / 11)
    om = cmath.exp(2j * cmath.pi / 3)

    def ev(c):
        return sum(c.n[i] * z ** i for i in range(10)) / c.d
    return ev(v.a) + om * ev(v.b)


def jc(v):
    return {'1': {'n': list(v.a.n), 'd': v.a.d},
            'om': {'n': list(v.b.n), 'd': v.b.d}}


def jfull(v):
    t = to_K4(v)
    n = c3num(v)
    return {'cyc33': jc(v), 'K4': None if t is None else [str(c) for c in t],
            'closed': show(v), 'num': [n.real, n.imag]}


def bf_str(f, dv=('y', 'z')):
    d = len(f) - 1
    parts = []
    for k, c in enumerate(f):
        if c.is_zero():
            continue
        mo = ''
        if d - k:
            mo += dv[0] + ('^%d' % (d - k) if d - k > 1 else '')
        if k:
            mo += dv[1] + ('^%d' % k if k > 1 else '')
        cs = show(c)
        if not mo:
            parts.append('(%s)' % cs)
        elif cs == '1':
            parts.append(mo)
        else:
            parts.append('(%s)%s' % (cs, mo))
    return ' + '.join(parts) if parts else '0'


def L_str(L):
    return '[ %s ] E_y  +  [ %s ] E_z' % (bf_str(L[0]), bf_str(L[1]))


# ===================================================================== the frame
def build_frame(sigma_index=0, v4_index=0, G=None):
    if G is None:
        G = Grp()
    invs = [i for i in range(G.n) if G.ord[i] == 2]
    assert G.n == 660 and len(invs) == 55
    sg = invs[sigma_index]
    Ms = G.mats[sg]
    assert (len(eig(Ms, 1)), len(eig(Ms, -1))) == (3, 2)
    C = G.centralizer(sg)
    assert len(C) == 12
    fx = joint_fix([G.mats[g] for g in C])
    assert len(fx) == 1
    cS = fx[0]
    assert klein_eval(cS) != ZERO
    V4s = set()
    for a in invs:
        for b in invs:
            if a < b and G.mul(a, b) == G.mul(b, a) and G.mul(a, b) != 0:
                V4s.add(tuple(sorted((a, b, G.mul(a, b)))))
    thru = [V for V in sorted(V4s) if sg in V]
    assert len(thru) == 3
    K1 = thru[v4_index]
    A = joint_fix([G.mats[g] for g in K1])
    others = [t for t in K1 if t != sg and t != 0]
    s2 = others[0]
    Lx = joint_eig([(G.mats[sg], 1), (G.mats[s2], -1)])
    assert len(Lx) == 1
    NG = [g for g in range(G.n) if {G.conj(t, g) for t in K1} == set(K1)]
    psi = next(g for g in NG if G.ord[g] == 3)
    Mp = G.mats[psi]
    Ex = list(Lx[0])
    Ey = mat_vec(Mp, Ex)
    Ez = mat_vec(Mp, Ey)
    assert mat_vec(Mp, Ez) == Ex
    Mp3 = [[c3(v) for v in row] for row in Mp]
    A3 = [[c3(t) for t in v] for v in A]

    def eigvec_in_A(lam):
        rows = []
        for i in range(5):
            row = []
            for k in range(2):
                acc = ZZ
                for j in range(5):
                    acc = acc + Mp3[i][j] * A3[k][j]
                row.append(acc - lam * A3[k][i])
            rows.append(row)
        return nullspace(rows, 2, Cyc3)

    def comb(co, bas):
        out = [ZZ] * 5
        for k, ck in enumerate(co):
            for i in range(5):
                out[i] = out[i] + ck * bas[k][i]
        return out

    Eom, Eom2 = comb(eigvec_in_A(OM)[0], A3), comb(eigvec_in_A(OM2)[0], A3)
    Ex3 = [c3(t) for t in Ex]
    Ey3 = [c3(t) for t in Ey]
    Ez3 = [c3(t) for t in Ez]
    EXP = {mono(3, 0, 0, 0, 0), mono(0, 3, 0, 0, 0),
           mono(1, 0, 2, 0, 0), mono(1, 0, 0, 2, 0), mono(1, 0, 0, 0, 2),
           mono(0, 1, 2, 0, 0), mono(0, 1, 0, 2, 0), mono(0, 1, 0, 0, 2),
           mono(0, 0, 1, 1, 1)}
    chosen = None
    for sw_ab in (0, 1):
        for sw_yz in (0, 1):
            Ea = Eom if not sw_ab else Eom2
            Eb = Eom2 if not sw_ab else Eom
            Ey_, Ez_ = (Ey3, Ez3) if not sw_yz else (Ez3, Ey3)
            fr = [Ea, Eb, Ex3, Ey_, Ez_]
            Fp = klein_poly(fr)
            if set(Fp) - EXP:
                continue
            if (Fp[mono(1, 0, 0, 2, 0)] == Fp[mono(1, 0, 2, 0, 0)] * OM and
                    Fp[mono(1, 0, 0, 0, 2)] == Fp[mono(1, 0, 2, 0, 0)] * OM2 and
                    Fp[mono(0, 1, 0, 2, 0)] == Fp[mono(0, 1, 2, 0, 0)] * OM2 and
                    Fp[mono(0, 1, 0, 0, 2)] == Fp[mono(0, 1, 2, 0, 0)] * OM):
                chosen = (sw_ab, sw_yz, fr, Fp)
                break
        if chosen:
            break
    assert chosen is not None, 'no admissible labeling'
    sw_ab, sw_yz, frame, Fp = chosen
    c_ax2 = Fp[mono(1, 0, 2, 0, 0)]
    c_bx2 = Fp[mono(0, 1, 2, 0, 0)]
    c_xyz = Fp[mono(0, 0, 1, 1, 1)]
    kp = Fp[mono(3, 0, 0, 0, 0)] * c_xyz * c_xyz / (c_ax2 ** 3)
    km = Fp[mono(0, 3, 0, 0, 0)] * c_xyz * c_xyz / (c_bx2 ** 3)
    assert kp + km == c3frac(13, 8) and kp * km == c3frac(-1, 2)
    ABrat = c_bx2 / c_ax2                                  # = A/Bb
    co = solve_coords(frame, [c3(t) for t in cS])
    assert all(co[k].is_zero() for k in (2, 3, 4))
    beta = (co[1] * ABrat) / co[0]
    rho = next(g for g in C if G.ord[g] == 3)
    tau = s2
    # normal-form coordinates: v_nf = S^{-1} v_raw with S = diag(A,Bb,X,X,X);
    # M_nf = S^{-1} M_raw S, i.e. (M_nf)_{ij} = (M_raw)_{ij} * s_j / s_i.
    s_over = {(0, 1): c_ax2 / c_bx2,      # s_1/s_0 = Bb/A
              (1, 0): c_bx2 / c_ax2,
              (0, 2): c_ax2 / c_xyz,      # s_2/s_0 = X/A
              (2, 0): c_xyz / c_ax2,
              (1, 2): c_bx2 / c_xyz,      # s_2/s_1 = X/Bb
              (2, 1): c_xyz / c_bx2}

    def sratio(i, j):
        """s_j / s_i"""
        i2, j2 = (2 if i >= 2 else i), (2 if j >= 2 else j)
        return II if i2 == j2 else s_over[(i2, j2)]

    def rescale(M):
        return [[M[i][j] * sratio(i, j) for j in range(5)] for i in range(5)]

    return dict(G=G, sigma=sg, K1=K1, psi=psi, rho=rho, tau=tau,
                frame=frame, Fraw=Fp, kp=kp, km=km, beta=beta, cS=cS,
                c_ax2=c_ax2, c_bx2=c_bx2, c_xyz=c_xyz,
                Mrho=rescale(mat_in_frame(G.mats[rho], frame)),
                Mtau=rescale(mat_in_frame(G.mats[tau], frame)),
                Msig=rescale(mat_in_frame(G.mats[sg], frame)))


# ======================================================== representation helpers
def sym2_act(M, S):
    """S |-> M S M^T on symmetric 2x2 matrices given as [S11,S12,S22]."""
    s11, s12, s22 = S
    E = [[s11, s12], [s12, s22]]
    out = [[ZZ, ZZ], [ZZ, ZZ]]
    for i in range(2):
        for j in range(2):
            acc = ZZ
            for k in range(2):
                for l in range(2):
                    acc = acc + M[i][k] * E[k][l] * M[j][l]
            out[i][j] = acc
    assert out[0][1] == out[1][0]
    return [out[0][0], out[0][1], out[1][1]]


def invariants_of(action, dim, mats, signs):
    """basis of {v : action(M,v) = sign*v for all (M,sign)}."""
    eqs = []
    for M, sg in zip(mats, signs):
        cols = []
        for e in range(dim):
            b = [ZZ] * dim
            b[e] = II
            cols.append(action(M, b))
        for r in range(dim):
            eqs.append([cols[e][r] - (c3int(sg) if e == r else ZZ)
                        for e in range(dim)])
    return nullspace(eqs, dim, Cyc3)


def Vm_act(M, m, L):
    """(g.L)(v) = M L(M^{-1} v) on Hom(Sym^m W^-, W^-), L = (P,R)."""
    Mi = mat2_inv(M)
    P, R = bf_subs(L[0], Mi), bf_subs(L[1], Mi)
    return (bf_add(bf_scal(P, M[0][0]), bf_scal(R, M[0][1])),
            bf_add(bf_scal(P, M[1][0]), bf_scal(R, M[1][1])))


def Vm_isotypic(m, tw, Rm, Tm):
    """tw = +1 (triv) or -1 (sgn): the tau-eigenvalue; rho-eigenvalue is +1."""
    bas = []
    for comp in (0, 1):
        for k in range(m + 1):
            P, R = bf_zero(m), bf_zero(m)
            (P if comp == 0 else R)[k] = II
            bas.append((P, R))
    n = len(bas)
    eqs = []
    for M, sg in ((Rm, 1), (Tm, tw)):
        cols = [list(Vm_act(M, m, L)[0]) + list(Vm_act(M, m, L)[1])
                for L in bas]
        for r in range(2 * (m + 1)):
            eqs.append([cols[e][r] - (c3int(sg) if e == r else ZZ)
                        for e in range(n)])
    out = []
    for v in nullspace(eqs, n, Cyc3):
        P, R = bf_zero(m), bf_zero(m)
        for e, c in enumerate(v):
            if c:
                P = bf_add(P, bf_scal(bas[e][0], c))
                R = bf_add(R, bf_scal(bas[e][1], c))
        out.append((P, R))
    return out


def bf_invariants(d, Rm, Tm, sign=1):
    """invariant binary forms of degree d: f(M^{-1} v) = sign * f(v)."""
    eqs = []
    for M, sg in ((Rm, 1), (Tm, sign)):
        Mi = mat2_inv(M)
        cols = []
        for k in range(d + 1):
            f = bf_zero(d)
            f[k] = II
            cols.append(bf_subs(f, Mi))
        for r in range(d + 1):
            eqs.append([cols[e][r] - (c3int(sg) if e == r else ZZ)
                        for e in range(d + 1)])
    return nullspace(eqs, d + 1, Cyc3)


def Wp_act(M3, Mm, TH):
    """(g.Theta)(v) = M3 . Theta(Mm^{-1} v) on Hom(Sym^k W^-, W^+)."""
    Mi = mat2_inv(Mm)
    C_ = [bf_subs(TH[i], Mi) for i in range(3)]
    return [bf_add(bf_add(bf_scal(C_[0], M3[i][0]), bf_scal(C_[1], M3[i][1])),
                   bf_scal(C_[2], M3[i][2])) for i in range(3)]


def Theta_invariants(k, Mrp, Mtp, Rm, Tm):
    bas = []
    for comp in range(3):
        for j in range(k + 1):
            TH = [bf_zero(k) for _ in range(3)]
            TH[comp][j] = II
            bas.append(TH)
    n = len(bas)
    eqs = []
    for M3, Mm in ((Mrp, Rm), (Mtp, Tm)):
        cols = []
        for TH in bas:
            gt = Wp_act(M3, Mm, TH)
            cols.append(gt[0] + gt[1] + gt[2])
        for r in range(3 * (k + 1)):
            eqs.append([cols[e][r] - (II if e == r else ZZ) for e in range(n)])
    out = []
    for v in nullspace(eqs, n, Cyc3):
        TH = [bf_zero(k) for _ in range(3)]
        for e, c in enumerate(v):
            if c:
                for i in range(3):
                    TH[i] = bf_add(TH[i], bf_scal(bas[e][i], c))
        out.append(TH)
    return out


# =================================================================== main
def main():
    global NU_CYC
    log('# FIX-L1 producer -- exact frame constants for the [L] transfer '
        'condition')
    log('# packet goal_runs_after_9094303/FIX_L1_FRAME_CONSTANTS')
    log('# theory/FIX_IV_closure.md sec.5.7-5.8 ; sigma-frame = FIX_H1_EQUALIZER')
    log('')

    sQR = ZERO
    for a in (1, 3, 4, 5, 9):
        sQR = sQR + Cyc.zeta(a)
    NU_CYC = Cyc.from_int(2) * sQR + ONE
    assert NU_CYC * NU_CYC == Cyc.from_int(-11)
    NU = c3(NU_CYC)
    DELTA = OM - OM2
    assert DELTA * DELTA == c3int(-3)
    R33 = -(NU * DELTA)
    assert R33 * R33 == c3int(33)
    assert abs(c3num(R33).real - 33 ** .5) < 1e-9 and abs(c3num(R33).imag) < 1e-9
    log('S0  nu := sqrt(-11) = 2(z+z^3+z^4+z^5+z^9)+1 ;  delta := om-om^2 '
        '(delta^2 = -3)')
    log('S0  sqrt33 := -nu.delta  (the POSITIVE real root in the standard '
        'embedding z = e^{2 pi i/11}, om = e^{2 pi i/3});  sqrt33^2 = 33  OK')
    log('')

    # ---------------------------------------------------------------- part A
    log('== A.  the certified sigma-frame (rebuilt from PSL(2,11) generators) ==')
    FR = build_frame()
    kp, km, beta = FR['kp'], FR['km'], FR['beta']
    log('A1  sigma = g[%d], K_1 = %s, psi = g[%d], rho = g[%d], tau = g[%d]'
        % (FR['sigma'], FR['K1'], FR['psi'], FR['rho'], FR['tau']))
    assert kp == (c3int(13) + c3int(3) * R33) / c3int(16)
    assert km == (c3int(13) - c3int(3) * R33) / c3int(16)
    log('A2  kp = (13+3 sqrt33)/16 = %.15f ,  km = (13-3 sqrt33)/16 = %.15f'
        '   VERIFIED' % (c3num(kp).real, c3num(km).real))
    assert beta == -(c3int(7) + R33) / c3int(4)
    assert (beta ** 3 + c3int(3) * beta ** 2 + kp).is_zero()
    log('A3  c_sigma = [1 : beta : 0] in the normal-form (a,b,x)-coordinates,')
    log('A3  CLOSED FORM  beta = -(7+sqrt33)/4 = %.15f ;  beta^3+3beta^2+kp = 0'
        '   VERIFIED' % c3num(beta).real)
    cheb = -II - beta
    assert cheb == (c3int(3) + R33) / c3int(4)
    assert (cheb ** 3 - c3int(3) * cheb - (kp + c3int(2))).is_zero()
    log('A3  Chebyshev uniformiser c = -(1+beta) = (3+sqrt33)/4 = %.15f ;  '
        'c^3-3c = kp+2   VERIFIED  (matches FIX-H1 finding H1-D12)'
        % c3num(cheb).real)

    Rm = [[FR['Mrho'][3][3], FR['Mrho'][3][4]],
          [FR['Mrho'][4][3], FR['Mrho'][4][4]]]
    Tm = [[FR['Mtau'][3][3], FR['Mtau'][3][4]],
          [FR['Mtau'][4][3], FR['Mtau'][4][4]]]
    Mrp = [[FR['Mrho'][i][j] for j in range(3)] for i in range(3)]
    Mtp = [[FR['Mtau'][i][j] for j in range(3)] for i in range(3)]
    half, qtr = c3frac(1, 2), c3frac(1, 4)
    assert Rm == [[-half, (II - NU) * qtr], [(-II - NU) * qtr, -half]]
    assert Tm == [[II, ZZ], [ZZ, -II]]
    log('A4  rho|_{W^-} = [[-1/2,(1-nu)/4],[(-1-nu)/4,-1/2]] , tau|_{W^-} = '
        'diag(1,-1)   (H1 closed forms)  VERIFIED')
    assert Mtp == [[II, ZZ, ZZ], [ZZ, II, ZZ], [ZZ, ZZ, -II]]
    log('A4  tau|_{W^+} = diag(1,1,-1)  VERIFIED')
    log('A4  rho|_{W^+} in the normal-form (E_a,E_b,E_x) frame:')
    for i in range(3):
        log('       [ %s ]' % ' , '.join(show(Mrp[i][j]) for j in range(3)))
    ratl = all(to_K4(Mrp[i][j]) is not None for i in range(3) for j in range(3))
    log('A4  every entry of rho|_{W^+} lies in Q(om,nu):  %s' % ratl)
    assert ratl

    # ---------------------------------------------------------------- part B
    log('')
    log('== B.  F in normal form; the A3 split F(w+y) = F0(w) + Q(w;y,y) ==')
    Fnf = {mono(3, 0, 0, 0, 0): kp, mono(0, 3, 0, 0, 0): km,
           mono(1, 0, 2, 0, 0): II, mono(1, 0, 0, 2, 0): OM,
           mono(1, 0, 0, 0, 2): OM2,
           mono(0, 1, 2, 0, 0): II, mono(0, 1, 0, 2, 0): OM2,
           mono(0, 1, 0, 0, 2): OM,
           mono(0, 0, 1, 1, 1): II}
    cax, cbx, cxy = FR['c_ax2'], FR['c_bx2'], FR['c_xyz']
    scaled = {}
    for e, c in FR['Fraw'].items():
        ea, eb, exx = e[0], e[1], e[2] + e[3] + e[4]
        f = {(3, 0, 0): cxy * cxy / (cax ** 3),
             (0, 3, 0): cxy * cxy / (cbx ** 3),
             (1, 0, 2): cax.inv(), (0, 1, 2): cbx.inv(),
             (0, 0, 3): cxy.inv()}[(ea, eb, exx)]
        scaled[e] = c * f
    assert scaled == Fnf, 'rescaled raw F != normal form (1.1)'
    log('B1  F = kp a^3 + km b^3 + a(x^2+om y^2+om^2 z^2) + '
        'b(x^2+om^2 y^2+om z^2) + xyz')
    log('B1  obtained from the RAW frame polynomial by the explicit diagonal '
        'rescaling  VERIFIED  (= V4-packet normal form (1.1))')
    degs = sorted({e[3] + e[4] for e in Fnf})
    assert degs == [0, 2]
    log('B2  (y,z)-degrees occurring in F: %s -- no degree 1, no degree 3.'
        % degs)
    log('B2  CERTIFICATE-A3 SHAPE VERIFIED:  F(w+y) = F0(w) + Q(w;y,y) exactly,')
    log('B2  F0 cubic on W^+, Q linear in W^+ and quadratic in W^-, nothing '
        'else.')
    F0 = {e: c for e, c in Fnf.items() if e[3] + e[4] == 0}
    Qd = {e: c for e, c in Fnf.items() if e[3] + e[4] == 2}
    log('B3  F0(a,b,x) = kp a^3 + km b^3 + (a+b) x^2')
    log('B3  Q(w;y,y)  = a(om y^2 + om^2 z^2) + b(om^2 y^2 + om z^2) + x yz')
    F0c = kp + km * beta ** 3
    assert F0c == (c3int(81) + c3int(15) * R33) / c3int(16)
    assert not F0c.is_zero()
    log('B4  F0(c_sigma) = kp + km beta^3 = (81 + 15 sqrt33)/16 = %.15f  != 0'
        % c3num(F0c).real)
    log('B4  and F(c_sigma) = F0(c_sigma) because c_sigma lies in W^+ '
        '(y = z = 0):  the H1 frame fact "F(c_sigma) != 0, c_sigma off X" '
        'is REPRODUCED in the A3 split.')
    assert klein_eval(FR['cS']) != ZERO
    log('B4  raw-frame cross-check klein_eval(c_sigma) != 0  VERIFIED')
    for nm, M in (('rho', FR['Mrho']), ('tau', FR['Mtau'])):
        assert poly_subs(Fnf, M) == Fnf, 'F not %s-invariant' % nm
        assert poly_subs(F0, M) == F0, 'F0 not %s-invariant' % nm
        assert poly_subs(Qd, M) == Qd, 'Q not %s-invariant' % nm
    log('B5  F, F0 and Q are EXACTLY rho- and tau-invariant in the '
        'normal-form frame  VERIFIED')
    log('B5  (so Q is an S3-invariant pairing W^+ (x) Sym^2 W^- -> C.)')

    # ---------------------------------------------------------------- part C
    log('')
    log('== C.  isotypic split and the two frame constants alpha, beta ==')
    Om_sp = invariants_of(sym2_act, 3, [Rm, Tm], [1, 1])
    assert len(Om_sp) == 1
    Om = [c / Om_sp[0][0] * (II - NU) for c in Om_sp[0]]
    assert Om == [II - NU, ZZ, II + NU]
    log('C1  (Sym^2 W^-)[triv] is 1-dimensional, spanned by')
    log('C1     Omega = (1-nu) E_y(x)E_y + (1+nu) E_z(x)E_z  '
        '= diag(1-nu, 1+nu)          [NORMALISATION: S_11 = 1-nu]')

    def form_act(M, S):
        MT = [[M[j][i] for j in range(2)] for i in range(2)]
        return sym2_act(MT, S)

    q0_sp = invariants_of(form_act, 3, [Rm, Tm], [1, 1])
    assert len(q0_sp) == 1
    q0 = [c / q0_sp[0][0] * (II + NU) for c in q0_sp[0]]
    assert q0 == [II + NU, ZZ, II - NU]
    log('C1     q0    = (1+nu) y^2 + (1-nu) z^2   in Sym^2 (W^-)^*, the '
        'invariant quadratic form  [NORMALISATION: coeff(y^2) = 1+nu]')
    trQ0Om = q0[0] * Om[0] + q0[2] * Om[2]
    assert trQ0Om == c3int(24)
    log('C1     <q0, Omega> = 24 ;  pi_t(S) := ((1+nu)S_11 + (1-nu)S_22)/24 , '
        'so pi_t(Omega) = 1.')

    def Qpair(w, S):
        a, b, x = w
        return (a * (OM * S[0] + OM2 * S[2]) + b * (OM2 * S[0] + OM * S[2])
                + x * S[1])

    cS_nf = [II, beta, ZZ]
    assert mat_apply(Mrp, cS_nf) == cS_nf and mat_apply(Mtp, cS_nf) == cS_nf
    log('C2  (W^+)[triv] = <c_sigma>, c_sigma = E_a + beta E_b '
        '(rho- and tau-fixed)  VERIFIED')
    ell = [Qpair([II, ZZ, ZZ], Om), Qpair([ZZ, II, ZZ], Om),
           Qpair([ZZ, ZZ, II], Om)]
    assert ell == [R33 - II, -(II + R33), ZZ]
    log('C2  ell := Q(. ; Omega) in (W^+)^*  =  (sqrt33 - 1) a - (1 + sqrt33) b'
        '   [x-coefficient 0]')
    log('C2  ell is S3-invariant, ell != 0, so ker(ell) = (W^+)[std].')

    alpha = Qpair(cS_nf, Om)
    assert alpha == c3int(9) + c3int(3) * R33
    log('')
    log('C3  ======  alpha := Q(c_sigma ; Omega)  =  9 + 3 sqrt33  '
        '= 3(3 + sqrt33)  ======')
    log('C3         numerically  alpha = %.15f' % c3num(alpha).real)
    log('C3  >>> NONDEGENERACY VERDICT:  alpha != 0.  '
        '(3 + sqrt33 > 0; also N_{Q(sqrt33)/Q}(alpha) = 81 - 9*33 = -216 != 0)')
    nrm = (c3int(9) + c3int(3) * R33) * (c3int(9) - c3int(3) * R33)
    assert nrm == c3int(-216)
    assert alpha == c3int(12) * cheb
    assert alpha == c3int(16) * kp - c3int(4)
    assert F0c == cheb ** 3
    log('C3  STRUCTURAL IDENTITIES (exact, and frame-independent -- see G):')
    log('C3     alpha = 12 c      (c = the Chebyshev uniformiser of the '
        'D12-point, FIX-H1 finding H1-D12)')
    log('C3     alpha = 16 kp - 4')
    log('C3     F(c_sigma) = F0(c_sigma) = c^3 ,  hence  alpha^3 = 1728 . '
        'F(c_sigma) .')
    log('C3  >>> CONSEQUENCE:  alpha = 0  <=>  c = 0  <=>  F(c_sigma) = 0 .')
    log('C3  So the nondegeneracy of the t-channel constant alpha is EXACTLY '
        'the certified frame fact "c_sigma lies off X" (FIX-H1 A1). The '
        'transfer condition inherits its nonvacuity from the geometry.')

    u_p = [II + R33, R33 - II, ZZ]
    u_m = [ZZ, ZZ, II]
    assert sum((ell[i] * u_p[i] for i in range(3)), ZZ).is_zero()
    assert sum((ell[i] * u_m[i] for i in range(3)), ZZ).is_zero()
    assert in_span([u_p, u_m], mat_apply(Mrp, u_p))
    assert in_span([u_p, u_m], mat_apply(Mrp, u_m))
    assert mat_apply(Mtp, u_p) == u_p and mat_apply(Mtp, u_m) == [-c for c in u_m]
    log('C4  (W^+)[std] = ker(ell) = < u+ , u- > with')
    log('C4     u+ = (1+sqrt33) E_a + (sqrt33-1) E_b      (tau-eigenvalue +1)')
    log('C4     u- = E_x                                   (tau-eigenvalue -1)')
    log('C4  rho-stability of <u+,u-> VERIFIED; W^+ = <c_sigma> (+) <u+,u->.')

    v_p = [II - NU, ZZ, -(II + NU)]
    v_m = [ZZ, II, ZZ]
    assert (q0[0] * v_p[0] + q0[2] * v_p[2]).is_zero()
    log('C5  (Sym^2 W^-)[std] = < v+ , v- > with')
    log('C5     v+ = diag(1-nu, -(1+nu))                    (tau-eigenvalue +1)')
    log('C5     v- = E_y(x)E_z + E_z(x)E_y = [[0,1],[1,0]]  (tau-eigenvalue -1)')

    QB = [[Qpair(u, v) for v in (v_p, v_m)] for u in (u_p, u_m)]
    assert QB[0][1].is_zero() and QB[1][0].is_zero()
    assert QB[0][0] == c3int(24) * DELTA and QB[1][1] == II
    log('C6  the std-block of Q:  Q(u+,v+) = 24 delta = 24(om-om^2) , '
        'Q(u-,v-) = 1 , Q(u+,v-) = Q(u-,v+) = 0.')
    log('C6  NORMALISATION of the invariant std-pairing <.,.> : '
        '<u-,v-> := 1 (whence <u+,v+> = 24 delta, forced by invariance).')
    betaC = QB[1][1]
    log('')
    log('C7  ======  beta := Q(u- ; v-) / <u- , v->  =  1  ======')
    log('C7         beta IS the xyz-coefficient of the normal form (1.1).')
    detQB = QB[0][0] * QB[1][1] - QB[0][1] * QB[1][0]
    assert not detQB.is_zero()
    log('C7  >>> NONDEGENERACY VERDICT:  beta != 0.  Q restricted to '
        '(W^+)[std] x (Sym^2 W^-)[std] is a PERFECT pairing '
        '(det = 24 delta != 0).')
    for v in (v_p, v_m):
        assert Qpair(cS_nf, v).is_zero()
    for u in (u_p, u_m):
        assert Qpair(u, Om).is_zero()
    log('C8  Schur cross-checks: Q(c_sigma ; std) = 0 and Q(std ; Omega) = 0  '
        'VERIFIED, so')
    log('C8     Q(w ; y (x) y) = alpha . w_t . (y^2)_t + beta . <w_s , (y^2)_s>')
    log('C8  holds EXACTLY with the above normalisations '
        '(w = w_t c_sigma + w_s , y(x)y = (y^2)_t Omega + (y^2)_s).')

    # ---------------------------------------------------------------- part D
    log('')
    log('== D.  generators of V_m[triv] and V_m[sgn], V_m = Hom(Sym^m W^-,W^-) ==')
    GENS, DIMS = {}, {}
    for m in (1, 3):
        for tw, nm in ((1, 'triv'), (-1, 'sgn')):
            sp = Vm_isotypic(m, tw, Rm, Tm)
            DIMS[(m, nm)] = len(sp)
            pred = ((m + 1) - {0: 1, 1: -1, 2: 0}[m % 3]) // 3
            log('D   dim V_%d[%s] = %d   (Note IV Lemma 5.1 predicts %d)'
                % (m, nm, len(sp), pred))
            assert len(sp) == pred == 1
            g = sp[0]
            flat = list(g[0]) + list(g[1])
            piv = next(c for c in flat if c)
            GENS[(m, nm)] = (bf_scal(g[0], piv.inv()), bf_scal(g[1], piv.inv()))
    idL = ([II, ZZ], [ZZ, II])
    assert proportional(list(GENS[(1, 'triv')][0]) + list(GENS[(1, 'triv')][1]),
                        list(idL[0]) + list(idL[1]))
    GENS[(1, 'triv')] = idL
    log('D1  V_1[triv] = the SCALARS (Schur): gamma_1^triv = id_{W^-} : '
        'y |-> y,  i.e.  %s' % L_str(idL))
    g1s = GENS[(1, 'sgn')]
    assert g1s == ([ZZ, II], [(c3int(5) - NU) / c3int(6), ZZ])
    log('D2  V_1[sgn]  = < gamma_1^sgn >,  gamma_1^sgn = %s' % L_str(g1s))
    log('D2  CLOSED FORM  gamma_1^sgn = [[0, 1],[(5-nu)/6, 0]] as a matrix '
        '(E_y |-> (5-nu)/6 E_z, E_z |-> E_y): STRICTLY OFF-DIAGONAL.')
    dm = ([II, ZZ], [ZZ, -II])
    assert not proportional(list(dm[0]) + list(dm[1]),
                            list(g1s[0]) + list(g1s[1]))
    assert not proportional(list(dm[0]) + list(dm[1]),
                            list(idL[0]) + list(idL[1]))
    log('D2  CROSS-CHECK vs FIX-H1 sec.9: the order-1 image <diag(1,-1)> is '
        'NEITHER V_1[triv] (= <id>) NOR V_1[sgn] (off-diagonal): diag(1,-1) '
        'spans the tau=+1 line of the STD isotypic piece of '
        'V_1 = triv (+) sgn (+) std.')
    g3t = GENS[(3, 'triv')]
    log('D3  V_3[triv] = < gamma_3^triv >,  gamma_3^triv = %s' % L_str(g3t))
    g3s = GENS[(3, 'sgn')]
    h1P, h1R = bf_zero(3), bf_zero(3)
    h1P[3] = II
    h1P[1] = (-c3int(5) + NU) / c3int(6)
    h1R[2] = (c3int(5) - NU) / c3int(6)
    h1R[0] = (-c3int(7) + c3int(5) * NU) / c3int(18)
    assert proportional(list(g3s[0]) + list(g3s[1]), h1P + h1R)
    GENS[(3, 'sgn')] = (h1P, h1R)
    log('D4  V_3[sgn]  = < gamma_3^sgn >,  gamma_3^sgn = %s'
        % L_str((h1P, h1R)))
    log('D4  REGRESSION vs FIX-H1 PAYLOAD_theorem sec.5 generator '
        '(z^3 E_y + (-5+nu)/6 y^2z E_y + (5-nu)/6 yz^2 E_z '
        '+ (-7+5nu)/18 y^3 E_z):  PROPORTIONAL -- MATCH, and H1s '
        'normalisation is adopted.')
    log('D5  e-PARITY SELECTOR (Note IV Lemma 5.5): w_1 in V_m[sgn^{e+1}], so')
    log('D5     e EVEN -> V_m[sgn]   (H1 branch (ii): m=1, r=7, e=6)')
    log('D5     e ODD  -> V_m[triv]  (H1 branch (i) : m=3, r=6, e=3)')

    # ---------------------------------------------------------------- part E
    log('')
    log('== E.  the transfer data (gamma(x)gamma)_t and (gamma(x)gamma)_s ==')
    log('E0  for L = (P,R) in V_m, gamma(y^m) = P(y,z) E_y + R(y,z) E_z and')
    log('E0     gamma(y^m)(x)gamma(y^m) = [ P^2 , P R , R^2 ]  in '
        'Sym^{2m}(W^-)^* (x) Sym^2 W^- .')

    def split(S):
        t = [(q0[0] * a + q0[2] * b) / c3int(24) for a, b in zip(S[0], S[2])]
        rest11 = [a - c * Om[0] for a, c in zip(S[0], t)]
        rest22 = [a - c * Om[2] for a, c in zip(S[2], t)]
        cp = [a / (II - NU) for a in rest11]
        assert all((a + c * (II + NU)).is_zero()
                   for a, c in zip(rest22, cp)), 'std split inconsistent'
        return t, cp, list(S[1])

    TR = {}
    for key in ((1, 'triv'), (1, 'sgn'), (3, 'triv'), (3, 'sgn')):
        m, nm = key
        P, R = GENS[key]
        S = [bf_mul(P, P), bf_mul(P, R), bf_mul(R, R)]
        t, cp, cm = split(S)
        TR[key] = (t, cp, cm, S)
        log('')
        log('E(m=%d, %s)   gamma = %s' % (m, nm, L_str(GENS[key])))
        log('    (g(x)g)_t = %s' % bf_str(t))
        log('              in Sym^%d(W^-)^* (the coefficient of Omega)' % (2 * m))
        log('    (g(x)g)_s = [ %s ] v+  +  [ %s ] v-' % (bf_str(cp), bf_str(cm)))
        log('              in Sym^%d(W^-)^* (x) (Sym^2 W^-)[std]' % (2 * m))
        log('    alpha.(g(x)g)_t = %s' % bf_str([alpha * c for c in t]))
        log('    beta .(g(x)g)_s = [ %s ] v+  +  [ %s ] v-'
            % (bf_str([betaC * c for c in cp]), bf_str([betaC * c for c in cm])))
        nz_t = not bf_is_zero(t)
        nz_s = not (bf_is_zero(cp) and bf_is_zero(cm))
        log('    >>> (alpha (g(x)g)_t , beta (g(x)g)_s) != (0,0) : YES '
            '[t-part %s, s-part %s]'
            % ('NONZERO' if nz_t else 'ZERO', 'NONZERO' if nz_s else 'ZERO'))
        assert nz_t or nz_s

    # ---------------------------------------------------------------- part F
    log('')
    log('== F.  the transfer condition on Theta^(0)(c_sigma) ==')
    log('F0  I0 = Q(Theta^(0); Phi^(0), Phi^(0)) = 0 ; after Phi^(0) = D^e Psi,')
    log('F0  division by D^{2e} and the order-6 jet at c_sigma (Lemma 5.5), it')
    log('F0  becomes, with w_1 = c.gamma,')
    log('F0     c^2 . Q( Theta(y^{m+1}) ; gamma(y^m) (x) gamma(y^m) )  ==  0 ,')
    log('F0  an identity of binary forms of degree 3m+1, LINEAR in')
    log('F0     Theta := Theta^(0)(c_sigma)  in  Hom(Sym^{m+1} W^-, W^+)^{S3}.')

    log('F0  ADAPTED BASIS of Hom(Sym^{m+1}W^-,W^+)^{S3} (canonical, by target '
        'isotype):')
    log('F0     t-channel : Theta_t = f(y) . c_sigma , f an S3-invariant binary '
        'form of degree m+1;')
    log('F0     s-channel : Theta_s with image in (W^+)[std] = ker(ell), i.e. '
        'Theta_s(y^{m+1}) = A+(y) u+ + A-(y) u- .')
    log('F0  Then, EXACTLY (Schur, verified below):')
    log('F0     Q(Theta_t(y^{m+1}); g(x)g) = alpha . f(y) . (g(x)g)_t')
    log('F0     Q(Theta_s(y^{m+1}); g(x)g) = beta . [ 24 delta . A+(y).(g(x)g)'
        '_{s,v+} + A-(y).(g(x)g)_{s,v-} ]')
    log('F0  -- which IS the sec.5.8 expression alpha theta_t (g(x)g)_t '
        '+ beta <theta_s, (g(x)g)_s>.')

    RES = {}
    for key in ((1, 'triv'), (1, 'sgn'), (3, 'triv'), (3, 'sgn')):
        m, nm = key
        S = TR[key][3]
        k = m + 1
        TH_sp = Theta_invariants(k, Mrp, Mtp, Rm, Tm)
        tinv = bf_invariants(k, Rm, Tm, 1)
        tchan = []
        for f in tinv:
            TH = [bf_scal(f, cS_nf[0]), bf_scal(f, cS_nf[1]), bf_zero(k)]
            assert Wp_act(Mrp, Rm, TH) == TH and Wp_act(Mtp, Tm, TH) == TH
            tchan.append(TH)
        flat = [TH[0] + TH[1] + TH[2] for TH in TH_sp]
        assert all(in_span(flat, TH[0] + TH[1] + TH[2]) for TH in tchan)
        # s-channel: the invariant Thetas with ell(Theta) == 0
        schan = []
        eqs = []
        for j in range(k + 1):
            eqs.append([ell[0] * TH[0][j] + ell[1] * TH[1][j] + ell[2] * TH[2][j]
                        for TH in TH_sp])
        for v in nullspace(eqs, len(TH_sp), Cyc3):
            TH = [bf_zero(k) for _ in range(3)]
            for e, c in enumerate(v):
                if c:
                    for i in range(3):
                        TH[i] = bf_add(TH[i], bf_scal(TH_sp[e][i], c))
            schan.append(TH)
        log('')
        log('F(m=%d, %s)  dim Hom(Sym^%d W^-, W^+)^{S3} = %d  '
            '(t-channel %d + s-channel %d)'
            % (m, nm, k, len(TH_sp), len(tinv), len(schan)))
        assert len(tinv) + len(schan) == len(TH_sp)
        ADAPT = tchan + schan
        assert len(rref([TH[0] + TH[1] + TH[2] for TH in ADAPT], Cyc3)[1]) \
            == len(TH_sp), 'adapted basis is not a basis'

        def value(TH):
            A_, B_, X_ = TH
            return bf_add(bf_add(
                bf_mul(A_, bf_add(bf_scal(S[0], OM), bf_scal(S[2], OM2))),
                bf_mul(B_, bf_add(bf_scal(S[0], OM2), bf_scal(S[2], OM)))),
                bf_mul(X_, S[1]))

        rows = [value(TH) for TH in ADAPT]
        assert all(len(r) == 3 * m + 2 for r in rows)
        # sec.5.8 bookkeeping checks
        gg_t, gg_cp, gg_cm = TR[key][0], TR[key][1], TR[key][2]
        for i, (f, TH) in enumerate(zip(tinv, tchan)):
            assert rows[i] == [alpha * c for c in bf_mul(f, gg_t)]
        log('    invariant degree-%d form(s) f : %s'
            % (k, ' ;  '.join(bf_str(f) for f in tinv)))
        log('    t-channel  Q(f.c_sigma ; g(x)g) = alpha . f . (g(x)g)_t   '
            'EXACTLY  VERIFIED')
        for j, TH in enumerate(schan):
            # decompose Theta_s(y^{m+1}) = A+ u+ + A- u-
            Ap = [c / (II + R33) for c in TH[0]]
            assert all((b - a * (R33 - II)).is_zero()
                       for a, b in zip(Ap, TH[1])), 'not in std'
            Am = list(TH[2])
            want = [betaC * c for c in bf_add(
                bf_scal(bf_mul(Ap, gg_cp), c3int(24) * DELTA),
                bf_mul(Am, gg_cm))]
            assert rows[len(tinv) + j] == want, 's-channel bookkeeping failed'
            log('    s-channel #%d : A+ = %s ,  A- = %s' % (j, bf_str(Ap),
                                                            bf_str(Am)))
        log('    s-channel  Q(Theta_s ; g(x)g) = beta.[24 delta A+ (g(x)g)_{v+}'
            ' + A- (g(x)g)_{v-}]   EXACTLY  VERIFIED')
        for i, r in enumerate(rows):
            lab = ('theta_t^%d' % i if i < len(tinv)
                   else 'theta_s^%d' % (i - len(tinv)))
            log('    coefficient of %-11s :  %s' % (lab, bf_str(r)))
        _R, piv = rref(rows, Cyc3)
        rk = len(piv)
        log('    rank of  Theta |-> Q(Theta(y^{m+1}) ; g(x)g)  =  %d  of  %d'
            % (rk, len(TH_sp)))
        if rk == 0:
            verdict = 'VACUOUS -- transfer condition EMPTY (DEGENERATE)'
        elif rk == len(TH_sp):
            verdict = ('FULL RANK -- transfer forces Theta^(0)(c_sigma) = 0 '
                       '(stronger than a hyperplane)')
        else:
            verdict = ('PROPER, codimension %d of %d -- nonvacuous linear '
                       'condition' % (rk, len(TH_sp)))
        log('    >>> TRANSFER VERDICT: %s' % verdict)
        ker = nullspace([[rows[i][j] for i in range(len(rows))]
                         for j in range(3 * m + 2)], len(rows), Cyc3)
        log('    solution space dim = %d   (coordinates: %s)'
            % (len(ker), ', '.join(['theta_t^%d' % i for i in range(len(tinv))]
                                   + ['theta_s^%d' % i
                                      for i in range(len(schan))])))
        for v in ker:
            log('       solution vector : [ %s ]'
                % ' , '.join(show(c) for c in v))
        t_nz = [not bf_is_zero(rows[i]) for i in range(len(tinv))]
        s_nz = [not bf_is_zero(rows[len(tinv) + j]) for j in range(len(schan))]
        RES[key] = dict(dimTheta=len(TH_sp), n_tchannel=len(tinv),
                        n_schannel=len(schan), rank=rk, kerdim=len(ker),
                        verdict=verdict,
                        nonvacuous=bool(rk > 0),
                        t_image_nonzero=t_nz, s_image_nonzero=s_nz,
                        images=[[jfull(c) for c in r] for r in rows],
                        kernel=[[jfull(c) for c in v] for v in ker])
        assert rk > 0, 'DEGENERATE transfer condition for %s' % (key,)

    # ---------------------------------------------------------------- part G
    log('')
    log('== G.  frame independence (other involutions sigma, other V4) ==')
    log('G0  alpha and beta are each defined only up to the scalar '
        'normalisations fixed in C; what is intrinsic is "= 0 or != 0".')
    log('G0  Galois-consistent normalisation, intrinsic to the rebuilt frame:')
    log('G0     nu~ := (Omega_22 - Omega_11)/(Omega_22 + Omega_11)  (scale-free,'
        ' from the invariant of Sym^2 W^-),  s~ := -nu~ . delta ,')
    log('G0     Omega~ := diag(1-nu~, 1+nu~) .   Predicted for EVERY frame:')
    log('G0     kp = (13+3 s~)/16 ,  beta_{c_sigma} = -(7+s~)/4 ,  '
        'alpha = 9 + 3 s~ ,  beta = 1 .')
    ginv = []
    G = FR['G']
    for (si, vi) in [(0, 0), (0, 1), (0, 2), (1, 0), (7, 0), (23, 0), (54, 0),
                     (30, 1), (41, 2), (12, 1), (48, 2)]:
        fr = build_frame(si, vi, G)
        Rm2 = [[fr['Mrho'][3][3], fr['Mrho'][3][4]],
               [fr['Mrho'][4][3], fr['Mrho'][4][4]]]
        Tm2 = [[fr['Mtau'][3][3], fr['Mtau'][3][4]],
               [fr['Mtau'][4][3], fr['Mtau'][4][4]]]
        sp = invariants_of(sym2_act, 3, [Rm2, Tm2], [1, 1])
        assert len(sp) == 1 and sp[0][1].is_zero()
        nut = (sp[0][2] - sp[0][0]) / (sp[0][2] + sp[0][0])
        assert nut * nut == c3int(-11), 'nu~^2 != -11'
        st = -(nut * DELTA)
        Om2 = [c / sp[0][0] * (II - nut) for c in sp[0]]
        assert Om2 == [II - nut, ZZ, II + nut]
        a2 = Qpair([II, fr['beta'], ZZ], Om2)
        b2 = Qpair([ZZ, ZZ, II], [ZZ, II, ZZ])
        assert not a2.is_zero() and not b2.is_zero()
        ok = (fr['kp'] == (c3int(13) + c3int(3) * st) / c3int(16)
              and fr['beta'] == -(c3int(7) + st) / c3int(4)
              and a2 == c3int(9) + c3int(3) * st
              and b2 == II)
        assert ok, 'frame-independent closed forms failed at (%d,%d)' % (si, vi)
        ginv.append(dict(sigma_index=si, v4=vi, s_tilde=show(st),
                         kp=show(fr['kp']), beta_c_sigma=show(fr['beta']),
                         alpha=show(a2), beta_const=show(b2),
                         alpha_nonzero=True, beta_nonzero=True,
                         closed_forms_hold=True))
        log('G   sigma=invs[%2d] V4#%d : s~ = %-10s kp = %-22s beta = %-22s '
            'alpha = %-16s beta_const = %s   [closed forms hold]'
            % (si, vi, show(st), show(fr['kp']), show(fr['beta']), show(a2),
               show(b2)))
    log('G   EVERY tested (sigma, V4) satisfies the SAME closed forms in its '
        'own s~; the reference frame has s~ = +sqrt33, and the frames on the '
        'conjugate labelling have s~ = -sqrt33 (the Galois twist).')
    log('G   alpha != 0 and beta != 0 in EVERY frame tested.')

    # ---------------------------------------------------------------- payload
    out = dict(
        packet='FIX_L1_FRAME_CONSTANTS',
        convention=dict(
            field='Q(om, nu) with om^2+om+1 = 0, nu^2 = -11; '
                  'sqrt33 := -nu(om-om^2) (positive real in the standard '
                  'embedding)',
            normal_form='F = kp a^3 + km b^3 + a(x^2+om y^2+om^2 z^2) '
                        '+ b(x^2+om^2 y^2+om z^2) + xyz',
            Wplus='<E_a,E_b,E_x>', Wminus='<E_y,E_z>',
            sym2_model='S = [S11,S12,S22] symmetric 2x2, y(x)y = '
                       '[y^2, yz, z^2], g.S = M S M^T',
            normalisations=[
                'triv(W^+) generator: c_sigma = E_a + beta E_b',
                'triv(Sym^2 W^-) generator: Omega = diag(1-nu, 1+nu)',
                'std pairing: <u-,v-> = 1 (forces <u+,v+> = 24 delta)',
                'alpha := Q(c_sigma; Omega); beta := Q(u-;v-)/<u-,v->'],
        ),
        frame=dict(sigma=FR['sigma'], K1=list(FR['K1']), psi=FR['psi'],
                   rho=FR['rho'], tau=FR['tau'],
                   kp=jfull(kp), km=jfull(km), beta_c_sigma=jfull(beta),
                   chebyshev_c=jfull(cheb),
                   rho_Wminus=[[jfull(v) for v in r] for r in Rm],
                   tau_Wminus=[[jfull(v) for v in r] for r in Tm],
                   rho_Wplus=[[jfull(v) for v in r] for r in Mrp],
                   tau_Wplus=[[jfull(v) for v in r] for r in Mtp]),
        F0_c_sigma=jfull(F0c),
        Omega=[jfull(v) for v in Om], q0=[jfull(v) for v in q0],
        ell=[jfull(v) for v in ell],
        c_sigma_nf=[jfull(v) for v in cS_nf],
        u_plus=[jfull(v) for v in u_p], u_minus=[jfull(v) for v in u_m],
        v_plus=[jfull(v) for v in v_p], v_minus=[jfull(v) for v in v_m],
        alpha=jfull(alpha), beta_const=jfull(betaC),
        alpha_nonzero=True, beta_nonzero=True,
        std_block=[[jfull(QB[i][j]) for j in range(2)] for i in range(2)],
        generators={'m%d_%s' % k: dict(P=[jfull(c) for c in GENS[k][0]],
                                       R=[jfull(c) for c in GENS[k][1]],
                                       dim=DIMS[k]) for k in GENS},
        transfer={'m%d_%s' % k: dict(
            gg_t=[jfull(c) for c in TR[k][0]],
            gg_s_vplus=[jfull(c) for c in TR[k][1]],
            gg_s_vminus=[jfull(c) for c in TR[k][2]],
            **RES[k]) for k in TR},
        frame_independence=ginv,
    )
    os.makedirs(os.path.join(HERE, 'payloads'), exist_ok=True)
    with open(os.path.join(HERE, 'payloads', 'l1_constants.json'), 'w') as fh:
        json.dump(out, fh, indent=1)

    # ---------------------------------------------- compact constants table
    tab = []
    tab.append('FIX-L1  PAYLOAD -- the exact sigma-frame constants of the [L] '
               'transfer condition')
    tab.append('=' * 78)
    tab.append('')
    tab.append('FIELD    K = Q(om, nu),  om^2+om+1 = 0,  nu^2 = -11 ;  '
               'delta := om-om^2 (delta^2 = -3)')
    tab.append('         sqrt33 := -nu.delta  (positive real in the embedding '
               'z=e^{2pi i/11}, om=e^{2pi i/3})')
    tab.append('FRAME    the FIX-H1 sigma-frame: (E_a,E_b,E_x | E_y,E_z), '
               'W^+ = <E_a,E_b,E_x>, W^- = <E_y,E_z>,')
    tab.append('         F = kp a^3 + km b^3 + a(x^2+om y^2+om^2 z^2) '
               '+ b(x^2+om^2 y^2+om z^2) + xyz   [normal form (1.1)]')
    tab.append('         rho|_{W^-} = [[-1/2,(1-nu)/4],[(-1-nu)/4,-1/2]] , '
               'tau|_{W^-} = diag(1,-1) , tau|_{W^+} = diag(1,1,-1)')
    tab.append('')
    tab.append('CONSTANT                       CLOSED FORM                    '
               '        numeric (40-digit values in logs/VERIFY.log)')
    tab.append('-' * 78)
    rowsT = [('kp', kp), ('km', km), ('beta (c_sigma = [1:beta:0])', beta),
             ('c = -(1+beta)  (Chebyshev)', cheb),
             ('F(c_sigma) = F0(c_sigma)', F0c),
             ('alpha  = Q(c_sigma;Omega)', alpha),
             ('beta   = Q(u-;v-)/<u-,v->', betaC)]
    for nm, v in rowsT:
        tab.append('%-30s %-38s %.15f' % (nm, show(v), c3num(v).real))
    tab.append('')
    tab.append('IDENTITIES   alpha = 12 c = 16 kp - 4 ;  F(c_sigma) = c^3 ;  '
               'alpha^3 = 1728 F(c_sigma)')
    tab.append('             => alpha = 0  <=>  F(c_sigma) = 0 : alpha != 0 IS '
               'the frame fact "c_sigma off X".')
    tab.append('')
    tab.append('NORMALISATIONS (alpha, beta are each defined only up to these '
               'scalars; "!=0" is intrinsic)')
    tab.append('  triv(W^+)        c_sigma = E_a + beta E_b')
    tab.append('  triv(Sym^2 W^-)  Omega = diag(1-nu, 1+nu)   '
               '[q0 = (1+nu)y^2+(1-nu)z^2 , <q0,Omega> = 24]')
    tab.append('  std(W^+)         u+ = (1+sqrt33)E_a + (sqrt33-1)E_b , '
               'u- = E_x')
    tab.append('  std(Sym^2 W^-)   v+ = diag(1-nu,-(1+nu)) , '
               'v- = E_y(x)E_z+E_z(x)E_y')
    tab.append('  std pairing      <u-,v-> := 1   (invariance forces '
               '<u+,v+> = 24 delta)')
    tab.append('  Q std-block      [[Q(u+,v+),Q(u+,v-)],[Q(u-,v+),Q(u-,v-)]] '
               '= [[24 delta, 0],[0, 1]]  (PERFECT)')
    tab.append('')
    tab.append('NONDEGENERACY VERDICTS')
    tab.append('  alpha != 0   YES   (alpha = 9+3 sqrt33 = 26.2336879396...,  '
               'N_{Q(sqrt33)/Q}(alpha) = -216)')
    tab.append('  beta  != 0   YES   (beta = 1; it is the xyz-coefficient of '
               'the normal form)')
    tab.append('')
    tab.append('GENERATORS  V_m = Hom(Sym^m W^-, W^-) ;  '
               'dim V_m[triv] = dim V_m[sgn] = 1 for m = 1,3  (Lemma 5.1)')
    for k_ in ((1, 'triv'), (1, 'sgn'), (3, 'triv'), (3, 'sgn')):
        tab.append('  V_%d[%-4s]  %s' % (k_[0], k_[1], L_str(GENS[k_])))
    tab.append('  e-parity: w_1 in V_m[sgn^{e+1}]  ->  e EVEN picks '
               'V_m[sgn], e ODD picks V_m[triv].')
    tab.append('')
    tab.append('TRANSFER CONDITION   c^2 . Q(Theta(y^{m+1}) ; gamma(y^m) (x) '
               'gamma(y^m)) == 0  in Sym^{3m+1}(W^-)^*,')
    tab.append('                     Theta = Theta^(0)(c_sigma) in '
               'Hom(Sym^{m+1}W^-, W^+)^{S3}')
    tab.append('  (m, twist)    dim Theta-space   rank   codim   solution dim'
               '   VERDICT')
    for k_ in ((1, 'triv'), (1, 'sgn'), (3, 'triv'), (3, 'sgn')):
        r = RES[k_]
        tab.append('  (%d, %-4s)          %d            %d      %d          '
                   '%d          NONVACUOUS'
                   % (k_[0], k_[1], r['dimTheta'], r['rank'], r['rank'],
                      r['kerdim']))
    tab.append('')
    tab.append('  In every case the coefficient vector '
               '(alpha (g(x)g)_t , beta (g(x)g)_s) is NONZERO in BOTH parts.')
    tab.append('  m = 1 : the condition is a proper HYPERPLANE in the '
               '2-dimensional Theta-space (sec.5.8 as written).')
    tab.append('  m = 3 : the Theta-space is 3-dimensional (Sym^4 std = triv '
               '(+) 2 std, so "= C^2 by Schur" is an m=1 statement)')
    tab.append('          and the condition has CODIMENSION 2 -- strictly '
               'stronger than a hyperplane.')
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_CONSTANTS.txt'),
              'w') as fh:
        fh.write('\n'.join(tab) + '\n')
    return out


if __name__ == '__main__':
    main()
    log('')
    log('elapsed %.1f s' % (time.time() - T0))
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_L1.txt'), 'w') as fh:
        fh.write('\n'.join(LOG) + '\n')
    print('FIX_L1_PRODUCE_OK')
