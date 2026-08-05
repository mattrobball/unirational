#!/usr/bin/env python3
"""FIX-H1 producer, Part A -- the exact sigma-frame at the D12-point c_sigma.

ALGEBRAIC-RECOMPUTE: PSL(2,11) in its 5-dim Weil representation over
Q(zeta_11) is rebuilt from generators; nothing is read from any sibling
packet except the shared exact-arithmetic library `klein_exact.py`.

Produces (payloads/h1_frame.json + payloads/PAYLOAD_frame.txt):

  A1  sigma, W^+ (3), W^- (2), C_G(sigma) = D12, c_sigma = P(W^{D12}),
      F(c_sigma) != 0, the three V4's through sigma, their triple lines,
      concurrency at c_sigma.
  A2  the A_4-adapted frame (E_a,E_b,E_x,E_y,E_z) of the representative V4,
      rescaled so that F is EXACTLY the V4-packet normal form (1.1);
      kp, km read off and checked against kp+km = 13/8, kp*km = -1/2.
  A3  c_sigma in the (a,b) coordinates of the triple line: [alpha : beta],
      and (beta/alpha)^3.
  A4  the residual S3 = C_G(sigma)/<sigma>: the 3-cycle rho and the
      transposition tau = image of K_1, as exact matrices on
      W^- = <E_y,E_z> and on W^+ = <E_a,E_b,E_x>.
"""
import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
H0 = ('/Users/worker/unirational/problems/E-klein-cubic/'
      'goal_runs_after_6519c0b/FIX_H0_GLOBAL_SECTIONS')
sys.path.insert(0, H0)

from klein_exact import (Cyc, Cyc3, ZERO, ONE, C3ZERO, C3ONE, Grp, klein_eval,
                         mat_vec, nullspace, rref, rank)          # noqa: E402

T0 = time.time()
LOG = []


def log(s):
    print(s, flush=True)
    LOG.append(s)


OM = Cyc3(ZERO, ONE)
OM2 = Cyc3(-ONE, -ONE)
NAMES = ['a', 'b', 'x', 'y', 'z']


def c3(x):
    return Cyc3.lift(x)


def c3int(k):
    return Cyc3.lift(Cyc.from_int(k))


def lift_mat(M):
    return [[c3(v) for v in row] for row in M]


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


# --------------------------------------------------- tiny exact poly in 5 vars
def pzero():
    return {}


def pvar(i):
    e = [0] * 5
    e[i] = 1
    return {tuple(e): C3ONE}


def padd(p, q):
    o = dict(p)
    for e, v in q.items():
        w = o.get(e)
        w = v if w is None else w + v
        if w.is_zero():
            o.pop(e, None)
        else:
            o[e] = w
    return o


def pmul(p, q):
    o = {}
    for e1, v1 in p.items():
        for e2, v2 in q.items():
            e = tuple(i + j for i, j in zip(e1, e2))
            w = o.get(e)
            w = v1 * v2 if w is None else w + v1 * v2
            if w.is_zero():
                o.pop(e, None)
            else:
                o[e] = w
    return o


def pscal(p, c):
    o = {}
    for e, v in p.items():
        w = v * c
        if not w.is_zero():
            o[e] = w
    return o


def klein_poly(vecs):
    """F(sum_k t_k vecs[k]) as a polynomial in the 5 frame variables."""
    comp = []
    for i in range(5):                       # ambient coordinate i
        p = pzero()
        for k in range(5):
            p = padd(p, pscal(pvar(k), vecs[k][i]))
        comp.append(p)
    out = pzero()
    for i in range(5):
        out = padd(out, pmul(pmul(comp[i], comp[i]), comp[(i + 1) % 5]))
    return out


def mono(*e):
    return tuple(e)


def solve_coords(basis, v):
    n = len(basis)
    rows = [[basis[k][i] for k in range(n)] + [v[i]] for i in range(5)]
    R, _piv = rref(rows, Cyc3)
    sol = [C3ZERO] * n
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
    for i in range(5):
        acc = C3ZERO
        for k in range(n):
            acc = acc + basis[k][i] * sol[k]
        assert acc == v[i], 'solve_coords failed'
    return sol


def cube_roots(c):
    """all Cyc3 cube roots of c, if any (searched in Q(zeta_33) by
    solving t^3 = c on the 20-dim Q-basis is hard; instead we only need
    roots of the special elements arising below -- handled by the caller)."""
    raise NotImplementedError


def main():
    log('# FIX-H1 producer A -- the exact sigma-frame at the D12-point')
    G = Grp()
    invs = [i for i in range(G.n) if G.ord[i] == 2]
    assert G.n == 660 and len(invs) == 55
    log('A1  |G| = 660, 55 involutions')

    sg = invs[0]
    Ms = G.mats[sg]
    Wp, Wm = eig(Ms, 1), eig(Ms, -1)
    assert (len(Wp), len(Wm)) == (3, 2)
    C = G.centralizer(sg)
    assert len(C) == 12
    fx = joint_fix([G.mats[g] for g in C])
    assert len(fx) == 1
    cS = fx[0]
    assert klein_eval(cS) != ZERO
    log('A1  sigma = g[%d];  dim W^+ = 3, dim W^- = 2;  |C_G(sigma)| = 12;'
        % sg)
    log('A1  dim W^{D12} = 1  ->  c_sigma ;  F(c_sigma) != 0  (off X)')

    V4s = set()
    for a in invs:
        for b in invs:
            if a < b and G.mul(a, b) == G.mul(b, a) and G.mul(a, b) != 0:
                V4s.add(tuple(sorted((a, b, G.mul(a, b)))))
    V4s = sorted(V4s)
    assert len(V4s) == 55
    thru = [V for V in V4s if sg in V]
    assert len(thru) == 3
    for V in thru:
        Av = joint_fix([G.mats[g] for g in V])
        assert len(Av) == 2
        assert rank([list(v) for v in Wp] + [list(v) for v in Av]) == 3
        assert rank([list(v) for v in Av] + [list(cS)]) == 2
    log('A1  sigma lies in exactly 3 V4s %s;  their triple lines lie in P_sigma'
        % (thru,))
    log('A1  and are CONCURRENT at c_sigma  (each contains c_sigma)')

    # the three D12-points on the representative triple line
    K1 = thru[0]
    A = joint_fix([G.mats[g] for g in K1])
    d12_on_line = []
    for t in K1:
        if t == 0:
            continue
        Ct = G.centralizer(t)
        ft = joint_fix([G.mats[g] for g in Ct])
        assert len(ft) == 1
        d12_on_line.append((t, ft[0]))
        assert rank([list(v) for v in A] + [list(ft[0])]) == 2
    log('A1  ell_V carries exactly 3 D12-points, one per involution of K_1')

    others = [t for t in K1 if t != sg and t != 0]
    s2, s3 = others

    Lx = joint_eig([(G.mats[sg], 1), (G.mats[s2], -1)])
    Ly = joint_eig([(G.mats[sg], -1), (G.mats[s2], 1)])
    Lz = joint_eig([(G.mats[sg], -1), (G.mats[s2], -1)])
    assert len(Lx) == len(Ly) == len(Lz) == 1

    NG = [g for g in range(G.n) if {G.conj(t, g) for t in K1} == set(K1)]
    assert len(NG) == 12
    psi = next(g for g in NG if G.ord[g] == 3)
    Mp = G.mats[psi]

    Ex = list(Lx[0])
    Ey = mat_vec(Mp, Ex)
    Ez = mat_vec(Mp, Ey)
    assert mat_vec(Mp, Ez) == Ex

    Mp3 = lift_mat(Mp)
    A3 = [[c3(t) for t in v] for v in A]

    def eigvec_in_A(lam):
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

    def comb(co, bas):
        out = [C3ZERO] * 5
        for k, ck in enumerate(co):
            for i in range(5):
                out[i] = out[i] + ck * bas[k][i]
        return out

    va, vb = eigvec_in_A(OM), eigvec_in_A(OM2)
    assert len(va) == 1 and len(vb) == 1
    Eom, Eom2 = comb(va[0], A3), comb(vb[0], A3)
    Ex3 = [c3(t) for t in Ex]
    Ey3 = [c3(t) for t in Ey]
    Ez3 = [c3(t) for t in Ez]

    # ------------------------------------------------------ F in the raw frame
    # Four admissible labelings: which A-eigenvector is `a`, and whether the
    # cyclic orientation of (y,z) is psi or psi^2.  Exactly one gives the
    # V4-packet normal form's om-pattern.
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
            ok = (Fp[mono(1, 0, 0, 2, 0)] == Fp[mono(1, 0, 2, 0, 0)] * OM and
                  Fp[mono(1, 0, 0, 0, 2)] == Fp[mono(1, 0, 2, 0, 0)] * OM2 and
                  Fp[mono(0, 1, 0, 2, 0)] == Fp[mono(0, 1, 2, 0, 0)] * OM2 and
                  Fp[mono(0, 1, 0, 0, 2)] == Fp[mono(0, 1, 2, 0, 0)] * OM)
            if ok:
                chosen = (sw_ab, sw_yz, fr, Fp)
                break
        if chosen:
            break
    assert chosen is not None, 'no admissible labeling gives the om-pattern'
    sw_ab, sw_yz, frame, Fp = chosen
    log('A2  labeling: a = %s-eigenvector of psi, (y,z) orientation = psi^%d'
        % ('om' if not sw_ab else 'om^2', 1 if not sw_yz else 2))
    log('A2  F in the raw A_4-frame has %d monomials; support = normal-form '
        'support' % len(Fp))
    log('A2  om-pattern verified: a-row (1,om,om^2), b-row (1,om^2,om)')
    # psi acts on the frame as Theta: (x,y,z) -> cyclic, a -> om^{+-1} a
    c_ax2 = Fp[mono(1, 0, 2, 0, 0)]
    c_bx2 = Fp[mono(0, 1, 2, 0, 0)]
    c_xyz = Fp[mono(0, 0, 1, 1, 1)]

    # -------------------------------------------------------------- rescale
    # The normal form is reached by  a -> A a, b -> Bb b, (x,y,z) -> X(x,y,z),
    #   A X^2 c_ax2 = 1 ,   Bb X^2 c_bx2 = 1 ,   X^3 c_xyz = 1 ,
    # so  kp = c_a3 A^3 = c_a3 c_xyz^2 / c_ax2^3 ,   km = c_b3 c_xyz^2/c_bx2^3.
    # X itself is a cube root of 1/c_xyz and need NOT lie in Q(zeta_33); it is
    # never needed:
    #   * rho|_{W^-} and tau|_{W^-} are conjugated by diag(X,X) = scalar, hence
    #     UNCHANGED by the rescaling;
    #   * the (a:b) ratio of c_sigma is unchanged because A = Bb is forced?  no:
    #     A != Bb in general, so the ratio DOES change by A/Bb = c_bx2/c_ax2.
    # Both corrections are applied explicitly below.
    c_a3 = Fp[mono(3, 0, 0, 0, 0)]
    c_b3 = Fp[mono(0, 3, 0, 0, 0)]
    kp = c_a3 * c_xyz * c_xyz / (c_ax2 * c_ax2 * c_ax2)
    km = c_b3 * c_xyz * c_xyz / (c_bx2 * c_bx2 * c_bx2)
    s = kp + km
    p = kp * km
    assert s == Cyc3.lift(Cyc.from_frac(13, 8)), 'kp+km != 13/8 (got %r)' % s
    assert p == Cyc3.lift(Cyc.from_frac(-1, 2)), 'kp*km != -1/2 (got %r)' % p
    log('A2  kp = c_a3 c_xyz^2 / c_ax2^3 , km = c_b3 c_xyz^2 / c_bx2^3')
    log('A2  kp + km = 13/8 and kp*km = -1/2  (so 8k^2-13k-4 = 0)  VERIFIED')

    kpn = c3_to_complex(kp)
    kmn = c3_to_complex(km)
    log('A2  numerically kp = %.12f%+.12fi , km = %.12f%+.12fi'
        % (kpn.real, kpn.imag, kmn.real, kmn.imag))
    log('A2  (13+3*sqrt33)/16 = %.12f , (13-3*sqrt33)/16 = %.12f'
        % ((13 + 3 * 33 ** .5) / 16, (13 - 3 * 33 ** .5) / 16))

    # ------------------------------------------- c_sigma in (a,b)-coordinates
    # normal-form coordinates: a_nf = a_raw / A , b_nf = b_raw / Bb ; so the
    # ratio (b/a)_nf = (A/Bb) (b/a)_raw = (c_bx2/c_ax2) (b/a)_raw.
    ABrat = c_bx2 / c_ax2
    frame2 = frame
    cS3 = [c3(t) for t in cS]
    co = solve_coords(frame2, cS3)
    assert all(co[k].is_zero() for k in (2, 3, 4)), 'c_sigma not on ell_V'
    al, be = co[0], co[1] * ABrat
    assert not al.is_zero() and not be.is_zero(), \
        'c_sigma is a C3-fixed point of ell_V (unexpected)'
    ratio = be / al
    r3 = ratio * ratio * ratio
    log('A3  c_sigma = [a:b] = [1 : %s]' % fmt(ratio))
    log('A3  (b/a)^3 at c_sigma = %s   (numerically %s)'
        % (fmt(r3), c3_to_complex(r3)))

    # the three D12-points on ell_V, as (a,b)-ratios
    ratios = []
    for t, v in d12_on_line:
        cc = solve_coords(frame2, [c3(u) for u in v])
        ratios.append((t, cc[1] * ABrat / cc[0]))
    log('A3  the three D12-points on ell_V: b/a = %s'
        % ', '.join(fmt(r) for _, r in ratios))
    rr = [r for _, r in ratios]
    assert all((r * r * r) == r3 for r in rr), 'not one C3-orbit'
    log('A3  they form ONE free C3-orbit (same (b/a)^3)  '
        '-> one computation serves all three')

    # ------------------------------------------------- residual S3 matrices
    rho = next(g for g in C if G.ord[g] == 3)
    # tau = image of K_1 in the residual S3 : take s2 (or s3)
    tau = s2
    Mrho = mat_in_frame(G.mats[rho], frame2)
    Mtau = mat_in_frame(G.mats[tau], frame2)
    Msig = mat_in_frame(G.mats[sg], frame2)
    assert is_diag(Msig, [1, 1, 1, -1, -1])
    log('A4  sigma = diag(1,1,1,-1,-1) in the frame  ->  W^- = <E_y,E_z>')
    # rho preserves W^+ and W^-
    for (M, nm) in ((Mrho, 'rho'), (Mtau, 'tau')):
        for i in (0, 1, 2):
            assert M[3][i].is_zero() and M[4][i].is_zero(), nm
        for i in (3, 4):
            assert M[0][i].is_zero() and M[1][i].is_zero() and \
                   M[2][i].is_zero(), nm
    Rm = [[Mrho[3][3], Mrho[3][4]], [Mrho[4][3], Mrho[4][4]]]
    Tm = [[Mtau[3][3], Mtau[3][4]], [Mtau[4][3], Mtau[4][4]]]
    Rp = [[Mrho[i][j] for j in range(3)] for i in range(3)]
    Tp = [[Mtau[i][j] for j in range(3)] for i in range(3)]
    log('A4  rho|_{W^-} = %s' % mat_str(Rm))
    log('A4  tau|_{W^-} = %s' % mat_str(Tm))
    log('A4  rho|_{W^+} = %s' % mat_str(Rp))
    log('A4  tau|_{W^+} = %s' % mat_str(Tp))
    assert Tm[0][1].is_zero() and Tm[1][0].is_zero()
    log('A4  tau|_{W^-} is diagonal  (tau = image of an involution of K_1)')
    tr = Rm[0][0] + Rm[1][1]
    assert tr == -C3ONE, 'trace(rho|W^-) should be -1, got %r' % tr
    det = Rm[0][0] * Rm[1][1] - Rm[0][1] * Rm[1][0]
    assert det == C3ONE, 'det(rho|W^-) should be 1'
    log('A4  trace(rho|_{W^-}) = -1, det = 1  ->  W^- = std as an S3-rep')
    assert not Rm[0][1].is_zero() and not Rm[1][0].is_zero()
    log('A4  rho|_{W^-} has NONZERO off-diagonal entries (W^- is D12-irreducible)')

    # ---- closed forms over Q(sqrt(-11), om) -------------------------------
    sQR = ZERO
    for a in (1, 3, 4, 5, 9):                      # quadratic residues mod 11
        sQR = sQR + Cyc.zeta(a)
    nu = Cyc.from_int(2) * sQR + ONE               # nu = 2s+1 = sqrt(-11)
    assert nu * nu == Cyc.from_int(-11)
    NU = c3(nu)
    half = Cyc3.lift(Cyc.from_frac(1, 2))
    qtr = Cyc3.lift(Cyc.from_frac(1, 4))
    Rcf = [[-half, (C3ONE - NU) * qtr], [(-C3ONE - NU) * qtr, -half]]
    assert Rm == Rcf, 'closed form of rho|_{W^-} failed'
    log('A4  CLOSED FORM   rho|_{W^-} = [[-1/2, (1-nu)/4], [(-1-nu)/4, -1/2]],'
        '  nu = sqrt(-11)')
    Tcf = [[C3ONE, C3ZERO], [C3ZERO, -C3ONE]]
    assert Tm == Tcf, 'closed form of tau|_{W^-} failed'
    log('A4  CLOSED FORM   tau|_{W^-} = diag(1,-1)')

    # ---- the D12-point ratio: closed form ---------------------------------
    # beta := (b/a)(c_sigma) satisfies  beta^3 + 3 beta^2 + kp = 0,
    # equivalently beta = -(1 + c) with c^3 - 3c = kp + 2 (the SAME Chebyshev
    # cubic that uniformises both surviving branches -- FIX-H0 finding D-1).
    chk = ratio * ratio * ratio + Cyc3.lift(Cyc.from_int(3)) * ratio * ratio \
        + kp
    assert chk.is_zero(), 'beta^3+3beta^2+kp != 0'
    cc = -C3ONE - ratio
    chk2 = cc * cc * cc - Cyc3.lift(Cyc.from_int(3)) * cc - (kp + c3int(2))
    assert chk2.is_zero(), 'c = -(1+beta) does not satisfy the Chebyshev cubic'
    log('A3  CLOSED FORM   beta^3 + 3 beta^2 + kp = 0   at the D12-point,')
    log('A3  i.e. beta = -(1+c) with c^3 - 3c = kp+2 : the D12-point is the')
    log('A3  Chebyshev point of the trace curve  (numerically c = %.12f)'
        % c3_to_complex(cc).real)

    out = dict(
        sigma=sg, K1=list(K1), psi=psi, rho=rho, tau=tau,
        kp=str(kp), km=str(km),
        kp_numeric=[kpn.real, kpn.imag], km_numeric=[kmn.real, kmn.imag],
        c_sigma_ab=[jc(al), jc(be)], c_sigma_ratio=jc(ratio),
        c_sigma_ratio_cubed=jc(r3),
        d12_ratios=[jc(r) for _, r in ratios],
        rho_Wminus=[[jc(v) for v in row] for row in Rm],
        tau_Wminus=[[jc(v) for v in row] for row in Tm],
        rho_Wplus=[[jc(v) for v in row] for row in Rp],
        tau_Wplus=[[jc(v) for v in row] for row in Tp],
        frame=[[jc(v) for v in col] for col in frame2],
    )
    os.makedirs(os.path.join(HERE, 'payloads'), exist_ok=True)
    with open(os.path.join(HERE, 'payloads', 'h1_frame.json'), 'w') as fh:
        json.dump(out, fh, indent=1)
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_frame.txt'), 'w') as fh:
        fh.write('\n'.join(LOG) + '\n')
    return out


# ------------------------------------------------------------------ utilities
def mat_in_frame(M, frame):
    """matrix of M in the given basis (frame[k] = k-th basis vector)."""
    cols = []
    for k in range(5):
        img = [C3ZERO] * 5
        for i in range(5):
            acc = C3ZERO
            for j in range(5):
                acc = acc + c3(M[i][j]) * frame[k][j]
            img[i] = acc
        cols.append(solve_coords(frame, img))
    return [[cols[k][i] for k in range(5)] for i in range(5)]


def is_diag(M, d):
    for i in range(5):
        for j in range(5):
            want = Cyc3.lift(Cyc.from_int(d[i])) if i == j else C3ZERO
            if M[i][j] != want:
                return False
    return True


def cube_root_c3(c):
    """a cube root of c inside Q(zeta_33), by exact linear algebra on the
    20-dimensional Q-basis: solve t^3 = c by trying t in a generating set.
    We use the structure: Q(zeta_33)^* / (Q(zeta_33)^*)^3 -- rather than a
    general algorithm, do a direct search over t = u * zeta_33^k * (small
    rationals) is hopeless; instead use the resolvent: c is a cube iff
    the polynomial T^3 - c has a root, which we detect by factoring over
    the 20-dim Q-algebra via linear algebra on the multiplication map."""
    # Solve t^3 = c with t in Q(zeta_33) by Newton in the 20-dim Q-vector
    # space is nonlinear.  Practical exact route: Q(zeta_33) = Q(z11, om);
    # write t = sum over the Q-basis and solve -- degree 3 system.  Instead
    # we exploit that every element we need a cube root of here turns out to
    # be a cube of an explicit element; we search a structured family.
    from itertools import product
    cands = []
    for k in range(11):
        for j in range(3):
            for num in range(-6, 7):
                for den in range(1, 7):
                    if num == 0:
                        continue
                    t = Cyc3.lift(Cyc.zeta(k) * Cyc.from_frac(num, den))
                    if j:
                        t = t * (OM if j == 1 else OM2)
                    cands.append(t)
    for t in cands:
        if t * t * t == c:
            return t
    return None


def fmt(v):
    return str(v)


def jc(v):
    """JSON encoding of a Cyc3 element."""
    a, b = v.a, v.b
    return {'1': {'n': list(a.n), 'd': a.d}, 'om': {'n': list(b.n), 'd': b.d}}


def mat_str(M):
    return '[' + '; '.join(', '.join(str(v) for v in row) for row in M) + ']'


def c3_to_complex(v):
    import cmath
    z = cmath.exp(2j * cmath.pi / 11)
    om = cmath.exp(2j * cmath.pi / 3)

    def ev(c):
        return sum(c.n[i] * z ** i for i in range(10)) / c.d
    return ev(v.a) + om * ev(v.b)


if __name__ == '__main__':
    main()
    log('elapsed %.1f s' % (time.time() - T0))
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_frame.txt'), 'w') as fh:
        fh.write('\n'.join(LOG) + '\n')
    print('FIX_H1_FRAME_OK')
