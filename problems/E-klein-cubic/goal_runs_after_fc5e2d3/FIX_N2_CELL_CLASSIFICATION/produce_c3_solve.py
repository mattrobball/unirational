#!/usr/bin/env python3
"""FIX-N2 decision engine: C3-equivariant POINTWISE landing tuples in J_m.

SPECIALISATION LEMMA (proved in CELL_TABLE.md Section 2).
Let T be a nonzero A4-equivariant simultaneous landing family over the triple
line, primitive (common binary divisor cancelled), of triple-line order r and
common plane order >= m.  Expand T in the t-adic grading at the C3-fixed point
[1:0] of the line: T = sum_j t^j T_j.  Then every T_j is a C3-equivariant
pointwise K-tuple of degree r lying in J_m, T_0 != 0, and F(T_0) = 0.  Hence

    if the ONLY C3-equivariant pointwise tuple of degree r in J_m with F = 0 is
    the zero tuple, then NO A4-equivariant landing family with triple-line order
    r and common plane order >= m exists, in ANY line degree.

The variety of C3-equivariant pointwise solutions is a cone (the equations are
homogeneous), so it is trivial iff its affine dimension is 0.  When it is not
trivial we report which exact common plane orders occur on it.

Usage: python3 produce_c3_solve.py MODE m r1 r2 ...      MODE in {ff, exact}
"""

import os
import subprocess
import sys

import sympy as sp

import cell_lib as CL
import produce_c3_equivariant as EQ
from cell_lib import om, x, y, z

M2 = "/opt/homebrew/bin/M2"
HERE = os.path.dirname(os.path.abspath(__file__))
FF_P, FF_OM, FF_KP, FF_KM = 100057, 1140, 74361, 63219
PRE = {
    'exact': ('kkbase = toField(QQ[om,kp]/ideal(om^2+om+1, 8*kp^2-13*kp-4));\n'
              'kmv = 13/8 - kp; kpv = kp; omv = om;\n'),
    'ff': ('kkbase = ZZ/%d;\n'
           'omv = %d_kkbase; kpv = %d_kkbase; kmv = %d_kkbase;\n'
           % (FF_P, FF_OM, FF_KP, FF_KM)),
}


def to_m2(e):
    return str(sp.expand(e)).replace('**', '^')


def monomial_data(forms):
    """{max exponent -> list of coefficient expressions} over all five slots."""
    out = {}
    for f in forms:
        f = sp.sympify(f)
        if f == 0:
            continue
        P = sp.Poly(f, x, y, z)
        for mono, coeff in P.terms():
            out.setdefault(max(mono), []).append(CL.reduce_om(coeff))
    return out


def analyse(r, m, lam, mode='ff', timeout=3600):
    res = EQ.equivariant_tuple(r, m, lam)
    if res is None:
        return {'free': 0, 'trivial': True}
    forms, free = res
    if not free:
        return {'free': 0, 'trivial': True}
    eqs = EQ.landing_eqs(forms)
    md = monomial_data(forms)
    lines = [PRE[mode]]
    lines.append('R = kkbase[%s,w];\n' % ','.join(str(v) for v in free))
    lines.append('om = omv; kp = kpv; km = kmv;\n')
    lines.append('I = ideal(%s);\n'
                 % (','.join(to_m2(e) for e in eqs) if eqs else '0_R'))
    lines.append('I = I + ideal(w);\n')      # w is a dummy slack coordinate
    lines.append('d = dim I;\n')
    lines.append('print("SOLUTION CONE dim = " | toString d | '
                 '(if d == 0 then "  => ZERO TUPLE ONLY" else "  => NONTRIVIAL"));\n')
    lines.append('J0 = ideal(%s);\n'
                 % (','.join(to_m2(e) for e in eqs) if eqs else '0_R'))
    lines.append('if d > 0 then (\n')
    for E in sorted(md, reverse=True):
        for i, g in enumerate(md[E]):
            lines.append('  print("  plane order %d (maxexp %d) coef %d : " | '
                         '(if (J0 + ideal(1-w*(%s))) == ideal(1_R)'
                         ' then "forced zero" else "CAN BE NONZERO"));\n'
                         % (r - E, E, i, to_m2(g)))
    lines.append(');\n')
    src = ''.join(lines)
    os.makedirs(os.path.join(HERE, 'm2'), exist_ok=True)
    tag = {1: 'one', om: 'om', om**2: 'om2'}[lam]
    path = os.path.join(HERE, 'm2', 'c3_%d_%d_%s_%s.m2' % (m, r, tag, mode))
    with open(path, 'w') as fh:
        fh.write(src)
    out = subprocess.run([M2, '--script', path], capture_output=True, text=True,
                         timeout=timeout)
    return {'free': len(free), 'raw': out.stdout + out.stderr,
            'neqs': len(eqs), 'forms': forms}


if __name__ == '__main__':
    mode = sys.argv[1]
    m = int(sys.argv[2])
    for r in (int(v) for v in sys.argv[3:]):
        for lam, tag in ((1, 'lam=1'), (om, 'lam=om'), (om**2, 'lam=om^2')):
            res = analyse(r, m, lam, mode)
            print('#### m=%d r=%d %s  (free=%d, eqs=%s)'
                  % (m, r, tag, res['free'], res.get('neqs', 0)))
            if res.get('trivial'):
                print('   no nonzero C3-equivariant tuple in the linear space')
            else:
                print(res['raw'].rstrip())
            sys.stdout.flush()
