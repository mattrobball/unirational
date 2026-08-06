#!/usr/bin/env python3
"""FIX-C5 -- the sec.5.19 gamma-criterion SMOKE TEST on the FIX-N2C lam = 1 witness.

sec.5.19 asserts that, for a POINTWISE element of odd cone order r = 2s+1 written
in the V4 parity shapes

    a'  = xyz * At(t,v,w) ,  b'  = xyz * Bt(t,v,w) ,      (t,v,w) = (x^2,y^2,z^2)
    u0' = x * gt(t,v,w)   ,  u1' = y * Yt(t,v,w) ,  u2' = z * Zt(t,v,w) ,

the whole landing system F(T) = 0 collapses to the SINGLE identity in the three
invariant variables

    Q2(At,Bt) v Yt^2 + Q3(At,Bt) w Zt^2 + t v w C(At,Bt) + t Q1(At,Bt) gt^2
        - c gt Yt Zt   =   0                                          (5.19)

with unknown degrees (s-1, s-1, s, s, s).

This script pins the convention by running (5.19) against the SEALED witness of
`goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION` (the lam = 1, (m,r) = (1,7)
Chebyshev point, whose 52-equation check is certified there), read-only.

Exit line: FIX_C5_SMOKE_OK
"""
import os
import sys
import time

import sympy as sp

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = '/Users/worker/unirational/problems/E-klein-cubic'
N2C = os.path.join(ROOT, 'goal_runs_after_a90dbe1', 'FIX_N2C_R7_DECISION')

T0 = time.time()
LOG = []
NCHK = [0]


def log(s=''):
    print(s, flush=True)
    LOG.append(s)


def check(cond, msg):
    NCHK[0] += 1
    if not cond:
        raise AssertionError('CHECK FAILED: ' + msg)
    return cond


def main():
    log('# FIX-C5 -- sec.5.19 gamma-criterion smoke test on the FIX-N2C lam=1 witness')
    log('# packet goal_runs_after_9094303/FIX_C5_BRANCH_QUARTIC')
    log('')
    sys.path.insert(0, N2C)
    cwd = os.getcwd()
    os.chdir(N2C)
    try:
        import witness                                        # noqa: E402
        import indep_r7 as I                                  # noqa: E402
        t1 = time.time()
        vals, Tv = witness.run(check=lambda n, c, e='': check(c, n))
    finally:
        os.chdir(cwd)
    log('S0  FIX-N2C witness rebuilt and re-verified in place (%.1f s):' % (time.time() - t1))
    log('S0     all of its own checks PASS (52 landing equations, C3-equivariance,')
    log('S0     r = 7, m = 1, primitivity, the q-tower corollary).')

    x, y, z = I.x, I.y, I.z
    om, kp = I.om, I.kp
    KM = I.KM
    red = witness.red
    ap, bp, u0, u1, u2 = Tv

    # ---------------------------------------------------------------- shapes
    t, v, w = sp.symbols('t v w')

    def to_inv(expr, pref, name):
        """divide off `pref` and rewrite in (t,v,w) = (x^2,y^2,z^2); exact."""
        q, r = sp.div(sp.expand(expr), pref, x, y, z)
        check(sp.expand(r) == 0, '%s: %s divides exactly' % (name, pref))
        q = sp.expand(q)
        P = sp.Poly(q, x, y, z)
        out = 0
        for mon, cf in zip(P.monoms(), P.coeffs()):
            i, j, k = mon
            check(i % 2 == 0 and j % 2 == 0 and k % 2 == 0,
                  '%s: monomial %s is not a monomial in (x^2,y^2,z^2)' % (name, mon))
            out += red(cf) * t**(i // 2) * v**(j // 2) * w**(k // 2)
        return sp.expand(out)

    At = to_inv(ap, x * y * z, "a' = xyz*At")
    Bt = to_inv(bp, x * y * z, "b' = xyz*Bt")
    gt = to_inv(u0, x, "u0' = x*gt")
    Yt = to_inv(u1, y, "u1' = y*Yt")
    Zt = to_inv(u2, z, "u2' = z*Zt")
    degs = [sp.Poly(u, t, v, w).total_degree() for u in (At, Bt, gt, Yt, Zt)]
    log('')
    log('S1  PARITY SHAPES CONFIRMED for the r = 7 (s = 3) witness:')
    log('S1     a\' = xyz*At , b\' = xyz*Bt , u0\' = x*gt , u1\' = y*Yt , u2\' = z*Zt ,')
    log('S1     with At,Bt,gt,Yt,Zt polynomials in (t,v,w) = (x^2,y^2,z^2) of degrees')
    log('S1     %s  --  sec.5.19 predicts (s-1,s-1,s,s,s) = (2,2,3,3,3).' % (degs,))
    check(degs == [2, 2, 3, 3, 3], 'degrees (s-1,s-1,s,s,s) with s = 3')

    # ------------------------------------------------------------- the identity
    OM2 = -1 - om
    Q1 = sp.expand(At + Bt)
    Q2 = sp.expand(om * At + OM2 * Bt)
    Q3 = sp.expand(OM2 * At + om * Bt)
    C = sp.expand(kp * At**3 + KM * Bt**3)
    c = sp.Integer(1)                                   # the xyz-coefficient

    def redpoly(e):
        e = sp.expand(e)
        if e == 0:
            return sp.Integer(0)
        P = sp.Poly(e, t, v, w)
        out = 0
        for mon, cf in zip(P.monoms(), P.coeffs()):
            r = red(cf)
            if r != 0:
                out += r * t**mon[0] * v**mon[1] * w**mon[2]
        return sp.expand(out)

    base = Q2 * v * Yt**2 + Q3 * w * Zt**2 + t * v * w * C + t * Q1 * gt**2
    E_minus = redpoly(base - c * gt * Yt * Zt)      # sec.5.19 as printed
    E_plus = redpoly(base + c * gt * Yt * Zt)       # the +c variant

    log('')
    log('S2  THE SINGLE IDENTITY, evaluated on the witness (all coefficients reduced')
    log('S2  modulo the FIX-N2C Groebner basis {P1^3-..., c^3-3c-kap, om^2+om+1,')
    log('S2  8kp^2-13kp-4}):')
    log('S2     with  - c*gt*Yt*Zt   (sec.5.19 AS PRINTED, gt := +u0\'/x) :  %s'
        % ('ZERO' if E_minus == 0 else 'NONZERO (%d monomials)'
           % len(sp.Poly(E_minus, t, v, w).monoms())))
    log('S2     with  + c*gt*Yt*Zt   (gt := -u0\'/x, i.e. gamma = -u0\')        :  %s'
        % ('ZERO' if E_plus == 0 else 'NONZERO (%d monomials)'
           % len(sp.Poly(E_plus, t, v, w).monoms())))

    # the sign question, settled from the criterion's own derivation
    log('')
    log('S3  CONVENTION PINNED (and a correction owed back to sec.5.19).')
    log('S3  The gamma-criterion is derived in sec.5.19 by writing the square root')
    log('S3  of h*Delta_v as  g = c YZ - 2 Q1 gamma ; the residual root of the')
    log('S3  projection quadratic is then')
    log('S3        u0\' = (-c YZ + g)/(2 Q1) = -gamma ,')
    log('S3  so the dictionary is  gamma = -u0\'  (equivalently gt = -u0\'/x), NOT')
    log('S3  u0\' = x*gt.  With gamma = -u0\' the printed identity')
    log('S3        Q2 Y^2 + Q3 Z^2 + C = gamma (c YZ - Q1 gamma)')
    log('S3  is EXACTLY F(T) = 0 ; with gamma = +u0\' the sign of the c-term flips.')
    log('S3  sec.5.19\'s sentence "which is F(T) = 0 verbatim under u0\' = x*gt"')
    log('S3  should read  "under u0\' = -x*gt".  The CRITERION itself is unaffected')
    log('S3  (gamma ranges over all forms of character chi_1, and gamma -> -gamma is')
    log('S3  a bijection of that space); only the dictionary carries the sign.')
    check(E_plus == 0, 'sec.5.19 identity holds with gt = +u0\'/x and +c (i.e. gamma = -u0\')')
    check(E_minus != 0, 'and NOT with the printed sign under gt = +u0\'/x')
    # and the printed form holds verbatim with gt := -u0'/x :
    gtm = sp.expand(-gt)
    E_printed = redpoly(Q2 * v * Yt**2 + Q3 * w * Zt**2 + t * v * w * C
                        + t * Q1 * gtm**2 - c * gtm * Yt * Zt)
    check(E_printed == 0, "sec.5.19 identity AS PRINTED holds with gt = -u0'/x")
    log('S4  [machine]  sec.5.19\'s identity AS PRINTED, with gt := -u0\'/x :  ZERO.')
    log('S4  [machine]  the same identity with +c and gt := +u0\'/x       :  ZERO.')

    # ------------------------------------------------- the collapse it advertises
    Fexp = sp.expand(I.F_klein(Tv))
    if Fexp != 0:
        P = sp.Poly(Fexp, x, y, z)
        Fexp = sp.expand(sum(red(cf) * x**m[0] * y**m[1] * z**m[2]
                             for m, cf in zip(P.monoms(), P.coeffs())))
    check(Fexp == 0, 'F(T) = 0 as a raw polynomial identity (independent path)')
    # the raw slot system, for the identical cell, straight from FIX-N2C
    names, Tsym, eqs = I.landing_equations(7, 1, sp.Integer(1))
    nraw = len(eqs)
    ident_deg = 3 * 3                       # 3s with s = 3
    nmon = int(sp.binomial(ident_deg + 2, 2))
    noccupied = len(sp.Poly(E_minus, t, v, w).monoms())
    log('')
    log('S5  THE ADVERTISED COLLAPSE (sec.5.19(a)), MEASURED.  For this cell')
    log('S5     - the raw slot system of FIX-N2C has                      %d equations'
        % nraw)
    log('S5     - the invariant identity has degree 3s = %d in (t,v,w), so at most'
        % ident_deg)
    log('S5       C(%d+2,2) = %d coefficients; the number actually OCCUPIED is  %d.'
        % (ident_deg, nmon, noccupied))
    check(nraw == noccupied,
          'the invariant identity carries exactly the raw slot equations')
    log('S5  These agree EXACTLY (%d = %d): the "collapse" of sec.5.19(a) is a faithful'
        % (nraw, noccupied))
    log('S5  REINDEXING of the same equations -- five unknown ternary forms')
    log('S5  (At,Bt,gt,Yt,Zt) in three invariant variables instead of five slot tuples')
    log('S5  in (x,y,z) -- NOT a reduction in the number of conditions.  This is')
    log('S5  precisely what sec.5.19\'s "honest scope" paragraph claims, now measured.')
    log('S5  The genuine computational gain is variable count (3 instead of 5) and')
    log('S5  degree (3s instead of 3r); the equation count is unchanged.')

    log('')
    log('S6  VERDICT: FIX-C5-SMOKE-OK, with ONE convention correction owed to')
    log('S6  sec.5.19 (the sign in the gamma <-> u0\' dictionary; see S3).')
    log('')
    log('exact checks performed: %d' % NCHK[0])
    log('elapsed %.1f s' % (time.time() - T0))
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_SMOKE.txt'), 'w') as fh:
        fh.write('\n'.join(LOG) + '\n')
    print('FIX_C5_SMOKE_OK')


if __name__ == '__main__':
    main()
