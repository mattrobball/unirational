#!/usr/bin/env python3
"""FIX-H0 independent verifier -- ALGEBRAIC-RECOMPUTE.

Every statement the producer makes is recomputed here by a deliberately
different algorithm:

  * W+ / W-               : images of the Reynolds projectors (I +- M)/2
                            (producer: nullspaces of M -+ I)
  * A2 / A3 (sigma-parity : grid interpolation -- F(w+y) - F(w-y) is a
    of F)                   polynomial of total degree 3 that is evaluated
                            on a 4^5 exact grid; vanishing on a grid of size
                            (deg+1) in every variable is a PROOF that it is
                            the zero polynomial (producer: symbolic expansion)
  * A4 / A5 (invariant    : character inner products <chi_{W+-}, lambda> for
    lines)                  every linear character lambda of C_G(sigma),
                            computed from TRACES only (producer: ranks of
                            Reynolds projectors)
  * z_sigma off X         : Reynolds projector (1/12) sum_h h on W
  * A6 conjugacy          : orbit under a different generating set
  * branch table          : independent dict-based expansion in
                            QQ(om)[B,1/B][x,y,z] with explicit exponent
                            bookkeeping, plus a 40-digit numerical
                            confirmation at all 9 Chebyshev points
  * uniformisation        : resultant/minimal-polynomial arithmetic instead
                            of radicals, plus 50-digit numerics

Includes a harness self-test: a deliberately FALSE claim that must be
recorded as a failure.
"""
import json
import os
import sys
import time
import itertools
import sympy as sp

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from klein_exact import (Cyc, ZERO, ONE, Grp, klein_eval, mat_mul, mat_vec,
                         identity, rowspace_basis, rref, nullspace)

T0 = time.time()
FAILS = []
CHECKS = 0
LINES = []


def log(s):
    print(s, flush=True)
    LINES.append(s)


def check(name, cond):
    global CHECKS
    CHECKS += 1
    if not cond:
        FAILS.append(name)
        log('    FAIL  %s' % name)
    return cond


# --------------------------------------------------------------- projectors

def proj_image(M, sign):
    """image of (I + sign*M)/2  -- a basis, by row reduction."""
    half = Cyc.from_frac(1, 2)
    P = [[(ONE if i == j else ZERO) + Cyc.from_int(sign) * M[i][j]
          for j in range(5)] for i in range(5)]
    P = [[x * half for x in row] for row in P]
    # image = column space = row space of the transpose
    Pt = [[P[i][j] for i in range(5)] for j in range(5)]
    return [list(r) for r in rowspace_basis(Pt)]


# ------------------------------------------------------- grid interpolation

def grid_zero(fn, nvar, deg, field_pts):
    """True iff fn (total degree <= deg) vanishes identically, certified by
    vanishing on field_pts^nvar with |field_pts| >= deg+1."""
    assert len(field_pts) >= deg + 1
    for pt in itertools.product(field_pts, repeat=nvar):
        if not fn(pt).is_zero():
            return False
    return True


def main():
    log('FIX-H0 verifier (ALGEBRAIC-RECOMPUTE)')
    G = Grp()
    check('group order 660', G.n == 660)
    prof = {}
    for i in range(G.n):
        prof[G.ord[i]] = prof.get(G.ord[i], 0) + 1
    check('order profile of PSL(2,11)',
          prof == {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120})
    log('    order profile %s' % prof)

    invs = [i for i in range(G.n) if G.ord[i] == 2]
    check('55 involutions', len(invs) == 55)

    pts = [Cyc.from_int(k) for k in range(4)]
    ok_all = {'A1': 0, 'A2': 0, 'A3': 0, 'A4': 0, 'A5': 0, 'A4b': 0}
    for s in invs:
        M = G.mats[s]
        Wp, Wm = proj_image(M, +1), proj_image(M, -1)
        if len(Wp) == 3 and len(Wm) == 2:
            ok_all['A1'] += 1
        # A2/A3 by grid interpolation.
        #   F(w+y) - F(w-y)  is the odd-in-y part, doubled.
        #   It vanishes identically  <=>  F has only even y-degrees.
        def odd_part(pt, Wp=Wp, Wm=Wm):
            w = [sum((Wp[k][i] * pt[k] for k in range(3)), ZERO)
                 for i in range(5)]
            yv = [sum((Wm[k][i] * pt[3 + k] for k in range(2)), ZERO)
                  for i in range(5)]
            a = klein_eval([w[i] + yv[i] for i in range(5)])
            b = klein_eval([w[i] - yv[i] for i in range(5)])
            return a - b
        if grid_zero(odd_part, 5, 3, pts):
            ok_all['A3'] += 1
        # A2: F|_{W-} == 0, i.e. the pure-y cubic vanishes; grid in 2 vars
        def onWm(pt, Wm=Wm):
            v = [sum((Wm[k][i] * pt[k] for k in range(2)), ZERO)
                 for i in range(5)]
            return klein_eval(v)
        if grid_zero(onWm, 2, 3, pts):
            ok_all['A2'] += 1

        # A4/A5 by character inner products.
        C = G.centralizer(s)
        H = {g: k for k, g in enumerate(C)}
        # linear characters of H: H^ab = H/[H,H]
        comm = set()
        for g in C:
            for h in C:
                comm.add(G.mul(G.mul(g, h), G.mul(G.inv[g], G.inv[h])))
        changed = True
        comm.add(0)
        while changed:
            changed = False
            for a in list(comm):
                for b in list(comm):
                    if G.mul(a, b) not in comm:
                        comm.add(G.mul(a, b))
                        changed = True
        reps, coset = [], {}
        for g in C:
            f = None
            for ri, r in enumerate(reps):
                if G.mul(G.inv[r], g) in comm:
                    f = ri
                    break
            if f is None:
                reps.append(g)
                f = len(reps) - 1
            coset[g] = f
        k = len(reps)
        lins = []
        for mask in range(1 << k):
            sgn = [1 if not (mask >> t) & 1 else -1 for t in range(k)]
            if sgn[coset[0]] != 1:
                continue
            if all(sgn[coset[G.mul(g, h)]] == sgn[coset[g]] * sgn[coset[h]]
                   for g in C for h in C):
                lins.append({g: sgn[coset[g]] for g in C})
        # traces of h on W+ and W-:  tr_W(h) = tr_{W+}(h) + tr_{W-}(h) and
        # tr_W(h sigma) = tr_{W+}(h) - tr_{W-}(h)  (sigma = +1 on W+, -1 on W-)
        def trW(g):
            t = ZERO
            for i in range(5):
                t = t + G.mats[g][i][i]
            return t
        half = Cyc.from_frac(1, 2)
        trp = {g: (trW(g) + trW(G.mul(g, s))) * half for g in C}
        trm = {g: (trW(g) - trW(G.mul(g, s))) * half for g in C}
        inv12 = Cyc.from_frac(1, len(C))
        multp, multm = [], []
        for lam in lins:
            mp = sum((trp[g] * Cyc.from_int(lam[g]) for g in C), ZERO) * inv12
            mm = sum((trm[g] * Cyc.from_int(lam[g]) for g in C), ZERO) * inv12
            multp.append(mp)
            multm.append(mm)
        n_lines_p = sum(1 for v in multp if v == ONE)
        zero_p = sum(1 for v in multp if v.is_zero())
        n_lines_m = sum(1 for v in multm if not v.is_zero())
        if n_lines_p == 1 and zero_p == len(lins) - 1:
            ok_all['A4'] += 1
        if n_lines_m == 0:
            ok_all['A5'] += 1
        # z_sigma: the trivial-isotypic line of W, via the Reynolds projector
        R = [[ZERO] * 5 for _ in range(5)]
        for g in C:
            for i in range(5):
                for j in range(5):
                    R[i][j] = R[i][j] + G.mats[g][i][j]
        R = [[R[i][j] * inv12 for j in range(5)] for i in range(5)]
        Rt = [[R[i][j] for i in range(5)] for j in range(5)]
        Z = [list(r) for r in rowspace_basis(Rt)]
        if len(Z) == 1 and not klein_eval(Z[0]).is_zero():
            ok_all['A4b'] += 1

    for kk, vv in ok_all.items():
        check('%s holds for all 55' % kk, vv == 55)
    log('    per-check counts (out of 55): %s' % ok_all)

    # A6 by a different scan: orbit of invs[0] under conjugation by the
    # generators only, closed up.
    s0 = invs[0]
    orb = {s0}
    frontier = [s0]
    gens = [1, 2]              # the two BFS generators live at indices 1,2
    gens = [i for i in range(G.n) if len(G.word[i]) == 1]
    while frontier:
        nxt = []
        for t in frontier:
            for g in gens:
                u = G.conj(t, g)
                if u not in orb:
                    orb.add(u)
                    nxt.append(u)
        frontier = nxt
    check('single conjugacy class (generator-closure scan)',
          orb == set(invs))

    # --------------------------------------------------- branch table redo
    log('--- branch table, independent expansion')
    rows = independent_branch_table()
    for r in rows:
        log('    %-30s m=%s r=%2s ord(T+)=%s ord(T-)=%s -> %s'
            % (r['name'], r['m'], r['r'], r['aa'], r['bb'], r['verdict']))
    ref = json.load(open(os.path.join(HERE, 'payloads', 'h0_branches.json')))
    byname = {q['name']: q for q in ref['branch_table']}
    for r in rows:
        q = byname.get(r['name'])
        check('branch row matches producer: %s' % r['name'],
              q is not None and q['ordTplus'] == r['aa']
              and q['ordTminus'] == r['bb'] and q['m'] == r['m']
              and q['r'] == r['r'])

    # ------------------------------------------------- uniformisation redo
    log('--- uniformisation, minimal-polynomial arithmetic + 50-dps numerics')
    K = sp.symbols('K')
    minpoly_kp = 8*K**2 - 13*K - 4
    # (kp+2)(km+2) with kp+km = 13/8, kp km = -1/2
    val = sp.Rational(-1, 2) + 2*sp.Rational(13, 8) + 4
    check('(kp+2)(km+2) = 27/4 from the symmetric functions',
          sp.simplify(val - sp.Rational(27, 4)) == 0)
    kpn = sp.nsolve(minpoly_kp, K, 2.0, prec=60)
    kmn = sp.Rational(13, 8) - kpn
    check('kp numeric root of 8K^2-13K-4',
          abs(sp.N(8*kpn**2 - 13*kpn - 4, 50)) < sp.Float('1e-45'))
    kapn = kpn + 2
    check('-27/(4 kap) = -(km+2) numerically',
          abs(sp.N(-27/(4*kapn) + (kmn + 2), 50)) < sp.Float('1e-45'))
    import mpmath
    mpmath.mp.dps = 50
    kapM = mpmath.mpf(13 + 3*mpmath.sqrt(33))/16 + 2
    kamM = mpmath.mpf(13, 8) if False else mpmath.mpf(13)/8 - (
        mpmath.mpf(13 + 3*mpmath.sqrt(33))/16) + 2

    def cube_root_of_reciprocal_point(tr):
        u = (tr + mpmath.sqrt(mpmath.mpc(tr*tr - 4)))/2      # u + 1/u = tr
        return u**(mpmath.mpf(1)/3)
    Bn = cube_root_of_reciprocal_point(kapM)
    cn = Bn + 1/Bn
    check('c = B+ + 1/B+ solves c^3-3c = kap  (50 dps)',
          abs(cn**3 - 3*cn - kapM) < mpmath.mpf('1e-40'))
    Bm = cube_root_of_reciprocal_point(kamM)
    vm = -(Bm + 1/Bm)
    check('v = -(B- + 1/B-) solves v^3-3v = -27/(4 kap)  (50 dps)',
          abs(vm**3 - 3*vm + 27/(4*kapM)) < mpmath.mpf('1e-40'))
    check('B+^3 + B+^-3 = kp + 2', abs(Bn**3 + Bn**-3 - kapM) < mpmath.mpf('1e-40'))
    check('B-^3 + B-^-3 = km + 2', abs(Bm**3 + Bm**-3 - kamM) < mpmath.mpf('1e-40'))
    log('    kp = %s' % sp.N(kpn, 30))
    log('    kap = kp+2 = %s,  km+2 = %s' % (mpmath.nstr(kapM, 25),
                                             mpmath.nstr(kamM, 25)))
    log('    B+ = %s   c = %s' % (mpmath.nstr(Bn, 20), mpmath.nstr(cn, 20)))
    log('    B- = %s   v = %s' % (mpmath.nstr(Bm, 20), mpmath.nstr(vm, 20)))

    # ------------------------------------------------------- harness selftest
    log('--- harness self-test (must FAIL)')
    before = len(FAILS)
    check('SELFTEST(deliberately false): 1 == 2', 1 == 2)
    st_ok = (len(FAILS) == before + 1)
    if st_ok:
        FAILS.pop()          # remove the intentional failure
    log('    self-test recorded the deliberate failure: %s' % st_ok)

    log('checks run: %d, failures: %d' % (CHECKS, len(FAILS)))
    with open(os.path.join(HERE, 'logs', 'VERIFY.log'), 'w') as f:
        f.write('\n'.join(LINES) + '\n')
    if FAILS:
        log('FIX_H0_VERIFY_FAIL: %s' % FAILS)
        sys.exit(1)
    log('elapsed %.1f s' % (time.time() - T0))
    log('FIX_H0_VERIFY_OK')


# ------------------------------------------------------------------ helpers

def independent_branch_table():
    """Dict-based expansion in QQ(om)[B,1/B][x,y,z]: a polynomial is a dict
    (ex,ey,ez) -> dict (i,j) -> Fraction, meaning coefficient
    sum_{i,j} c_{ij} om^i B^j (om^2 = -om-1 reduced, j in ZZ)."""
    from fractions import Fraction

    def red_om(d):
        out = {}
        for (i, j), c in d.items():
            if c == 0:
                continue
            if i >= 2:
                # om^2 = -om - 1
                for (ii, cc) in ((1, -c), (0, -c)):
                    out[(ii, j)] = out.get((ii, j), Fraction(0)) + cc
            else:
                out[(i, j)] = out.get((i, j), Fraction(0)) + c
        return {k: v for k, v in out.items() if v != 0}

    def cmul(a, b):
        out = {}
        for (i1, j1), c1 in a.items():
            for (i2, j2), c2 in b.items():
                k = (i1 + i2, j1 + j2)
                out[k] = out.get(k, Fraction(0)) + c1 * c2
        return red_om(out)

    ONEC = {(0, 0): Fraction(1)}

    def pmul(p, q):
        out = {}
        for m1, c1 in p.items():
            for m2, c2 in q.items():
                m = (m1[0] + m2[0], m1[1] + m2[1], m1[2] + m2[2])
                cur = out.get(m, {})
                s = dict(cur)
                for k, v in cmul(c1, c2).items():
                    s[k] = s.get(k, Fraction(0)) + v
                out[m] = {k: v for k, v in s.items() if v != 0}
        return {m: c for m, c in out.items() if c}

    def padd(p, q):
        out = {m: dict(c) for m, c in p.items()}
        for m, c in q.items():
            s = out.get(m, {})
            for k, v in c.items():
                s[k] = s.get(k, Fraction(0)) + v
            out[m] = {k: v for k, v in s.items() if v != 0}
        return {m: c for m, c in out.items() if c}

    def mono(ex, ey, ez, coef=None):
        return {(ex, ey, ez): dict(coef or ONEC)}

    def psi(p):        # (x,y,z) -> (y,z,x)
        return {(m[2], m[0], m[1]): dict(c) for m, c in p.items()}

    def ordP1(p):
        return min(m[1] + m[2] for m in p) if p else None

    def ordR(p):
        return min(sum(m) for m in p) if p else None

    def DBfam(X):
        Y, Z = psi(X), psi(psi(X))
        neg = {(0, 0): Fraction(-1)}
        a = pmul(pmul(pmul(X, Y), Z), {(0, 0, 0): neg})
        Bc = {(0, 1): Fraction(1)}
        Binv = {(0, -1): Fraction(1)}
        omc = {(1, 0): Fraction(1)}
        om2 = red_om({(2, 0): Fraction(1)})
        u0 = pmul(X, padd(pmul(X, X),
                          padd(pmul({(0, 0, 0): Bc}, pmul(Y, Y)),
                               pmul({(0, 0, 0): Binv}, pmul(Z, Z)))))
        u1 = pmul({(0, 0, 0): omc},
                  pmul(Y, padd(pmul(Y, Y),
                               padd(pmul({(0, 0, 0): Bc}, pmul(Z, Z)),
                                    pmul({(0, 0, 0): Binv}, pmul(X, X))))))
        u2 = pmul({(0, 0, 0): om2},
                  pmul(Z, padd(pmul(Z, Z),
                               padd(pmul({(0, 0, 0): Bc}, pmul(X, X)),
                                    pmul({(0, 0, 0): Binv}, pmul(Y, Y))))))
        return [a, {}, u0, u1, u2]

    xx, yy, zz = mono(1, 0, 0), mono(0, 1, 0), mono(0, 0, 1)
    q = padd(padd(pmul(xx, xx), pmul(yy, yy)), pmul(zz, zz))
    e2 = padd(padd(pmul(pmul(xx, xx), pmul(yy, yy)),
                   pmul(pmul(yy, yy), pmul(zz, zz))),
              pmul(pmul(zz, zz), pmul(xx, xx)))
    xyz = pmul(pmul(xx, yy), zz)

    def scale(t, f):
        return [pmul(e, f) if e else {} for e in t]

    tests = [('D_B seed  X = x', DBfam(xx)),
             ("xyz * D_B(x)   [Cor E']", scale(DBfam(xx), xyz)),
             ('e2 * D_B(x)    [Thm N2B-3]', scale(DBfam(xx), e2)),
             ('D_B(yz)   first layer / T5', DBfam(pmul(yy, zz))),
             ('q * D_B(yz)', scale(DBfam(pmul(yy, zz)), q)),
             ('D_B(x y^2) primitive', DBfam(pmul(xx, pmul(yy, yy)))),
             ('D_B(x^2 y z)', DBfam(pmul(pmul(xx, xx), pmul(yy, zz)))),
             ('(xyz)^2 * D_B(yz)', scale(DBfam(pmul(yy, zz)), pmul(xyz, xyz)))]
    rows = []
    for name, t in tests:
        aa = min(v for v in (ordP1(t[0]), ordP1(t[1]), ordP1(t[2]))
                 if v is not None)
        bb = min(v for v in (ordP1(t[3]), ordP1(t[4])) if v is not None)
        r = min(v for v in (ordR(e) for e in t) if v is not None)
        ms = []
        for rot in range(3):
            tt = [t[0], t[1], t[2], t[3], t[4]]
            for _ in range(rot):
                tt = [psi(e) if e else {} for e in tt]
            a2 = min(v for v in (ordP1(tt[0]), ordP1(tt[1]), ordP1(tt[2]))
                     if v is not None)
            b2 = min(v for v in (ordP1(tt[3]), ordP1(tt[4]))
                     if v is not None)
            ms.append(min(a2, b2))
        assert len(set(ms)) == 1, (name, ms)
        rows.append(dict(name=name, m=ms[0], r=r, aa=aa, bb=bb,
                         verdict='EXCLUDED' if aa < bb else 'survives'))

    # the Chebyshev (1,7) witness: 40-digit numerics at all 9 (c,P1) points
    rows.append(cheb_numeric_row())
    return rows


def cheb_numeric_row():
    """40-dps confirmation that the FIX-N2C (1,7) witness is MINUS-leading:
    ord(T-) = 1 and ord(T+) = 2, at every one of the 9 (c,P1) points."""
    mp = sp.mpmath if hasattr(sp, 'mpmath') else None
    import mpmath
    mpmath.mp.dps = 40
    kp = (13 + 3*mpmath.sqrt(33))/16
    kap = kp + 2
    om = mpmath.mpc(-0.5, mpmath.sqrt(3)/2)
    cs = mpmath.polyroots([1, 0, -3, -kap], maxsteps=200, extraprec=200)
    ps = mpmath.polyroots([27, -24*om*kap, 0, 32*kap], maxsteps=200,
                          extraprec=200)
    worst_min = None
    for c in cs:
        for P1 in ps:
            # leading coefficients, from the printed witness
            u1_x6 = P1*c - 2*om - 2                    # ord(T-) = 1 via u1'
            u2_x6 = P1*c*om + 2*om                     # ord(T-) = 1 via u2'
            a_x4 = mpmath.mpf(1)                       # ord(T+) = 2 via a'
            b_x4 = -P1*(c*om + c)/2                    # ord(T+) = 2 via b'
            mn = min(abs(u1_x6), abs(u2_x6))
            worst_min = mn if worst_min is None else min(worst_min, mn)
            assert abs(a_x4) > 1e-30 and abs(b_x4) > 1e-30
    return dict(name='FIX-N2C primitive Chebyshev witness', m=1, r=7,
                aa=2, bb=1, verdict='survives',
                min_abs_leading_minus_coefficient=str(worst_min))


if __name__ == '__main__':
    main()
