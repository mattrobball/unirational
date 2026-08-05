#!/usr/bin/env python3
"""FIX-N2: produce the pointwise landing systems for the Note II cells and hand
them to Macaulay2 for exact ideal-theoretic decision.

For each cell (m,r) we build the general K-equivariant tuple of degree r lying in
J_m (see cell_lib.py for conventions), expand F(tuple) and collect the coefficient
equations.  We then decide whether the affine variety has a point at which the
common plane order is EXACTLY m, i.e. whether some coefficient of a monomial with
max exponent r-m can be nonzero.  That is the saturation test  I : c^infty != (1).

Coefficient fields:
  mode='exact'  KK = QQ[om,kp]/(om^2+om+1, 8kp^2-13kp-4), km = 13/8-kp   (Klein)
  mode='ff'     KK = ZZ/100057 with om=1140, kp=74361, km=63219 (same relations)
  mode='generic'KK = frac(QQ(om)[kp,km])                                (kappa free)

Usage:  python3 produce_cells.py MODE CELLS...   e.g. python3 produce_cells.py ff 1,4 1,5
"""

import os
import subprocess
import sys

import sympy as sp

import cell_lib as CL

M2 = "/opt/homebrew/bin/M2"
HERE = os.path.dirname(os.path.abspath(__file__))
FF_P, FF_OM, FF_KP, FF_KM = 100057, 1140, 74361, 63219


def preamble(mode):
    if mode == 'exact':
        return ('kkbase = toField(QQ[om,kp]/ideal(om^2+om+1, 8*kp^2-13*kp-4));\n'
                'kpv = kp; kmv = 13/8 - kp; omv = om;\n')
    if mode == 'ff':
        return ('kkbase = ZZ/%d;\n'
                'omv = %d_kkbase; kpv = %d_kkbase; kmv = %d_kkbase;\n'
                % (FF_P, FF_OM, FF_KP, FF_KM))
    if mode == 'generic':
        return ('kk0 = toField(QQ[om]/ideal(om^2+om+1));\n'
                'kkbase = frac(kk0[kp,km]);\n'
                'omv = sub(om,kkbase); kpv = kkbase_0; kmv = kkbase_1;\n')
    raise ValueError(mode)


def build(m, r):
    eqs, coeffs, bases, forms = CL.landing_system(r, m)
    slots = CL.slot_coeffs(r, m)
    ren = {c: sp.Symbol('c%d' % i) for i, c in enumerate(coeffs)}
    eqs = [sp.expand(e.subs(ren)) for e in eqs]
    exact = [ren[c] for c in CL.exact_m_conditions(r, m, bases, slots)]
    return eqs, [ren[c] for c in coeffs], exact, ren


def m2(expr):
    """sympy expression -> Macaulay2 syntax."""
    return str(expr).replace('**', '^')


def m2_source(m, r, mode, extra='', rabinowitsch=True):
    eqs, cvars, exact, ren = build(m, r)
    body = [preamble(mode)]
    body.append('R = kkbase[%s];\n'
                % ','.join([str(v) for v in cvars] + ['w']))
    body.append('om = omv; kp = kpv; km = kmv;\n')
    body.append('I = ideal(%s);\n' % ','.join(m2(e) for e in eqs))
    body.append('print("CELL m=%d r=%d nvars=%d neqs=%d");\n'
                % (m, r, len(cvars), len(eqs)))
    body.append('print("dimI=" | toString dim I);\n')
    for i, c in enumerate(exact):
        if rabinowitsch:
            body.append('J = I + ideal(1 - w*%s);\n' % c)
            body.append('print("EXACT-m coeff %s -> " | (if J == ideal(1_R) then '
                        '"cannot be nonzero (EMPTY)" else '
                        '("CAN be nonzero: dim=" | toString dim J)));\n' % c)
        else:
            body.append('J = saturate(I, %s);\n' % c)
            body.append('print("SAT %s -> " | (if J == ideal(1_R) then "EMPTY" '
                        'else ("NONEMPTY dim=" | toString dim J)));\n' % c)
    body.append(extra)
    return ''.join(body), cvars, exact


def run(m, r, mode='ff', extra='', timeout=3000):
    src, cvars, exact = m2_source(m, r, mode, extra)
    os.makedirs(os.path.join(HERE, 'm2'), exist_ok=True)
    path = os.path.join(HERE, 'm2', 'cell_%d_%d_%s.m2' % (m, r, mode))
    with open(path, 'w') as fh:
        fh.write(src)
    out = subprocess.run([M2, '--script', path], capture_output=True, text=True,
                         timeout=timeout)
    return out.stdout + out.stderr


if __name__ == '__main__':
    mode = sys.argv[1]
    for spec in sys.argv[2:]:
        m, r = (int(v) for v in spec.split(','))
        print('#' * 64)
        print(run(m, r, mode))
        sys.stdout.flush()
