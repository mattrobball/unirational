#!/usr/bin/env python3
"""FIX-N2C: build the EXACT (m,r) = (1,7) plane-order-1 cone point and verify it.

The point is described by the lex Groebner basis (shape position) of the
reduced system over K = QQ(om, kp):

    f(P0) = 0        (degree 9, irreducible factor unknown -- not needed)
    P1 = h(P0),  B2 = g(P0)

together with the nine linear relations of `reduce_linear.py`.  Writing
`th` for the chosen root of f, EVERY block coordinate becomes an explicit
polynomial of degree <= 8 in `th` with coefficients in K.

Verification is exact: the 52 coefficient equations of F(T) = 0 (rebuilt from
the RAW Klein normal form by `indep_r7.py`, which never sees FIX-N2B's engine)
are reduced modulo the Groebner basis

    { f(th), om^2+om+1, 8kp^2-13kp-4 }

whose leading monomials th^9, om^2, kp^2 are pairwise coprime, so the set is a
Groebner basis and the remainder is a canonical normal form.
"""
import re
import sys

import sympy as sp

import indep_r7 as I
from indep_r7 import om, kp, x, y, z

th = sp.Symbol('th')
GENS = (th, om, kp)


def parse_m2(s):
    """M2 polynomial text -> sympy expression in P0, om, kp."""
    s = s.replace('^', '**')
    return sp.sympify(s, locals={'P0': th, 'om': om, 'kp': kp})


def load_gb(path):
    f = h = g = None
    for line in open(path):
        if not line.startswith('GB '):
            continue
        e = sp.expand(parse_m2(line[3:].strip()))
        d = sp.Poly(e, th).degree()
        if d == 9:
            f = e
        elif e.coeff(th, 0) is not None and _has_lead(e, 'B2', line):
            pass
    # simpler: re-read and classify by the leading variable printed by M2
    f = h = g = None
    for line in open(path):
        if not line.startswith('GB '):
            continue
        body = line[3:].strip()
        if body.startswith('P0^9'):
            f = sp.expand(parse_m2(body))
        elif body.startswith('B2+'):
            g = sp.expand(parse_m2(body[3:]))          # B2 = -g
            g = -g
        elif body.startswith('P1+'):
            h = sp.expand(parse_m2(body[3:]))
            h = -h
    assert f is not None and g is not None and h is not None
    return f, h, g


def _has_lead(*a):
    return False


REL = None


def kred(e):
    e = sp.expand(e)
    if e == 0:
        return sp.Integer(0)
    _, r = sp.reduced(e, REL, *GENS, order='lex')
    return sp.expand(r)


def build(path):
    global REL
    f, h, g = load_gb(path)
    REL = [f, om**2 + om + 1, 8*kp**2 - 13*kp - 4]
    P0 = th
    P1 = kred(h)
    B2 = kred(g)
    B5 = sp.Integer(1)
    om2 = -1 - om
    vals = {
        'B5': B5,
        'P0': P0,
        'P1': P1,
        'B2': B2,
        'R0': kred(om*B5 - om2*P0),
        'R1': kred(-om*P1),
        'B0': kred(-om2*B5 - (om2 - 1)*P0),
        'B1': kred(-B5),
        'B3': kred(-2*om*B5 - (2*om + 4)*P0),
        'B4': kred(-B2),
        'B6': kred(om*B5 - (om2 - 1)*P0 - (om2 + 2)*P1),
        'B7': kred(om*B5 - (om2 - 1)*P0 - (om - 1)*P1),
        'B8': kred(om2*B5 + (om2 - 1)*P0),
    }
    return f, vals


def verify(vals, f, lam=sp.Integer(1)):
    names, T, eqs = I.landing_equations(7, 1, lam)
    sub = {sp.Symbol(n): vals[n] for n in names}
    bad = []
    for mono, c in eqs:
        v = kred(sp.expand(c.subs(sub)))
        if v != 0:
            bad.append((mono, v))
    return names, T, bad


if __name__ == '__main__':
    path = sys.argv[1] if len(sys.argv) > 1 else 'logs/RED_nf_one_P0b.log'
    f, vals = build(path)
    print('minimal polynomial of P0 over K (degree %d):'
          % sp.Poly(f, th).degree())
    print('  ', sp.factor(sp.expand(f*430615*3)))
    print()
    names, T, bad = verify(vals, f)
    print('52 coefficient equations of F(T)=0 : %d nonzero remainders'
          % len(bad))
    for mono, v in bad[:3]:
        print('   ', mono, v)
    print('LANDING-EXACT', len(bad) == 0)
