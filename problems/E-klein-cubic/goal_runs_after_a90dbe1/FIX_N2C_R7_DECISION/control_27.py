#!/usr/bin/env python3
"""FIX-N2C positive control: FIX-N2B's independently-known (2,7) witness
`e_2 * D_B(x)` must satisfy the 52 equations rebuilt here for lam = om^2.

FIX-N2B STATUS.md 2.7 records its lam = om^2 block coordinates as
(P1, B0..B8) = (-1, 1, 1, B, 1+B+B^-1, B^-1, 0, B, B^-1, 0), P0 = R0 = R1 = 0,
with kp = (B^3-1)^2/B^3.  If this packet's independent build were wrong, the
control would fail.
"""
import sympy as sp
import indep_r7 as I
from indep_r7 import om, kp, x, y, z

B = sp.Symbol('B')


def run(check=None):
    def ck(name, cond, extra=''):
        if check:
            check(name, cond, extra)
        else:
            print('%-58s %s %s' % (name, 'OK ' if cond else 'FAIL', extra))
        return cond
    lam = I.kred(om**2)
    names, T, eqs = I.landing_equations(7, 1, lam)
    vals = {'P0': 0, 'P1': -1, 'R0': 0, 'R1': 0,
            'B0': 1, 'B1': 1, 'B2': B, 'B3': 1 + B + 1/B, 'B4': 1/B,
            'B5': 0, 'B6': B, 'B7': 1/B, 'B8': 0}
    sub = {sp.Symbol(n): sp.sympify(vals[n]) for n in names}
    kpv = (B**3 - 1)**2/B**3
    bad = []
    for mono, cf in eqs:
        v = sp.simplify(sp.together(sp.expand(cf.subs(sub).subs(kp, kpv)
                                              .subs(om**2, -1-om))))
        v = sp.simplify(sp.expand(sp.numer(sp.cancel(v))))
        v = sp.expand(v.subs(om**2, -1-om))
        # reduce modulo om^2+om+1 in the numerator
        _, r = sp.reduced(sp.expand(v), [om**2+om+1], om, order='lex')
        if sp.simplify(r) != 0:
            bad.append((mono, sp.simplify(r)))
    ck('  control: (2,7) witness e_2*D_B(x) satisfies all 52 equations',
       not bad, '(%d nonzero)' % len(bad))
    # and its plane order is 2, not 1
    Tv = [sp.expand(cc.subs(sub)) for cc in T]
    orders = []
    for cc in Tv:
        if cc == 0:
            continue
        P = sp.Poly(sp.expand(sp.numer(sp.together(cc))), x, y, z)
        for mono, cf in zip(P.monoms(), P.coeffs()):
            if sp.simplify(cf) == 0:
                continue
            A, Bq, C = mono
            orders.append(min(Bq+C, A+C, A+Bq))
    ck('  control: that witness has m = 2 (so B5 = B8 = 0 is right)',
       min(orders) == 2, 'm = %d' % min(orders))
    return not bad


if __name__ == '__main__':
    run()
