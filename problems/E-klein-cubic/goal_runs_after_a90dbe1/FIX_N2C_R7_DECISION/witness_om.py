#!/usr/bin/env python3
"""FIX-N2C -- the lam = om witness (same shape as `witness.py`, om -> om^2).

Exact ideal of the plane-order-1 locus of the r = 7, lam = om cone, in the
normalisation P0 = 1 (Macaulay2 over K, m2/RED_nf_om_P0eq1_P1.m2):

    B2^3 + 9 om B2 + 3 dl kap  = 0          ( dl = 2om+1,  kap = kp+2 )
    P1^3 - (8/9) om^2 kap P1^2 + (32/27) kap = 0
    B5   = om + ((om+2)/6) B2 P1

with the nine linear relations reconstructed exactly by `lam_om.py`:

    R0 =  om B5 - om^2 P0        B1 = -om^2 B5
    R1 = -om P1                  B3 = -2 om B5 - (2om+4) P0
    B0 = -B5 + (om-1) P0         B4 = -om^2 B2
    B6 =  om^2 B5 + (om-1)(P0+P1)
    B7 =  B5 - dl (P0 - P1)
    B8 =  om^2 B5 - (om+2) P0
"""
import sympy as sp

import indep_r7 as I
from indep_r7 import om, kp, x, y, z

B2s, P1s = sp.symbols('B2 P1')
KAP = kp + 2
DL = 2*om + 1
OM2 = -1 - om

REL = [P1s**3 - sp.Rational(8, 9)*OM2*KAP*P1s**2 + sp.Rational(32, 27)*KAP,
       B2s**3 + 9*om*B2s + 3*DL*KAP,
       om**2 + om + 1,
       8*kp**2 - 13*kp - 4]
GENS = (P1s, B2s, om, kp)


def red(e):
    e = sp.expand(e)
    if e == 0:
        return sp.Integer(0)
    _, r = sp.reduced(e, REL, *GENS, order='lex')
    return sp.expand(r)


def coordinates():
    P0 = sp.Integer(1)
    B5 = red(om + sp.Rational(1, 6)*(om + 2)*B2s*P1s)
    v = {'P0': P0, 'P1': P1s, 'B2': B2s, 'B5': B5}
    v['R0'] = red(om*B5 - OM2*P0)
    v['R1'] = red(-om*P1s)
    v['B0'] = red(-B5 + (om - 1)*P0)
    v['B1'] = red(-OM2*B5)
    v['B3'] = red(-2*om*B5 - (2*om + 4)*P0)
    v['B4'] = red(-OM2*B2s)
    v['B6'] = red(OM2*B5 + (om - 1)*(P0 + P1s))
    v['B7'] = red(B5 - DL*(P0 - P1s))
    v['B8'] = red(OM2*B5 - (om + 2)*P0)
    return v


def run(check=None):
    def ck(name, cond, extra=''):
        if check:
            check(name, cond, extra)
        else:
            print('%-58s %s %s' % (name, 'OK ' if cond else 'FAIL', extra))
        return cond
    vals = coordinates()
    lam = om
    names, T, eqs = I.landing_equations(7, 1, lam)
    sub = {sp.Symbol(n): vals[n] for n in names}
    bad = [m for m, cf in eqs if red(sp.expand(cf.subs(sub))) != 0]
    ck('  lam=om witness: F(T) = 0, all 52 coefficient equations', not bad,
       '(%d nonzero)' % len(bad))
    Tv = [red(sp.expand(cc.subs(sub))) for cc in T]
    tgt = [red(lam*om*Tv[0]), red(lam*om**2*Tv[1]),
           red(lam*Tv[3]), red(lam*Tv[4]), red(lam*Tv[2])]
    ck('  lam=om witness: psi(T) = om g(T)   (residual C3, lam = om)',
       all(red(sp.expand(I.psi(cc) - tt)) == 0 for cc, tt in zip(Tv, tgt)))
    orders, degs = [], set()
    for comp in Tv:
        if comp == 0:
            continue
        P = sp.Poly(comp, x, y, z)
        for mono, cf in zip(P.monoms(), P.coeffs()):
            if red(cf) == 0:
                continue
            a, b, c2 = mono
            degs.add(a + b + c2)
            orders.append((b + c2, a + c2, a + b))
    ordP = tuple(min(o[i] for o in orders) for i in range(3))
    ck('  lam=om witness: r = 7 and m = 1 exactly',
       degs == {7} and min(ordP) == 1, '(ordP1,ordP2,ordP3) = %s' % (ordP,))
    ck("  lam=om witness: a' != 0 and b' != 0", Tv[0] != 0 and Tv[1] != 0)
    return vals, Tv


if __name__ == '__main__':
    vals, Tv = run()
    print()
    for k in ['P0', 'P1', 'R0', 'R1', 'B0', 'B1', 'B2', 'B3', 'B4',
              'B5', 'B6', 'B7', 'B8']:
        print('   %-3s = %s' % (k, sp.factor(vals[k])))
