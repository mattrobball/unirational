#!/usr/bin/env python3
"""FIX-N2B: decide the C3-equivariant pointwise landing cones at triple-line
order r, and their plane-order stratification.

Two independent decision engines, both driven from `n2b_lib`:

  M2  : Macaulay2 over the EXACT number field K = QQ[om,kp]/(om^2+om+1,
        8kp^2-13kp-4)  -- characteristic zero, rigorous;
  MS  : msolve, either over F_p with the reduced Klein values (fast filter) or
        over QQ with om,kp carried as variables subject to their minimal
        polynomials (characteristic zero, rigorous).

Questions answered per (r, lam):
  Q1  is the cone {0}?                          [dim I / saturation]
  Q2  can a plane-order-1 parameter be nonzero? [saturation by that parameter]
  Q3  what is the cone, explicitly?             [dim, degree, decomposition]

Usage:
  python3 produce_cones.py m2   <mode> <r> [<r> ...]      mode in {exact, ff}
  python3 produce_cones.py ms   <mode> <r> [<r> ...]      mode in {qq, ff}
"""
import os
import subprocess
import sys

import n2b_lib as L
from n2b_lib import ONE, OM, OM2

M2 = "/opt/homebrew/bin/M2"
MSOLVE = "/opt/homebrew/bin/msolve"
HERE = os.path.dirname(os.path.abspath(__file__))
FF_P, FF_OM, FF_KP, FF_KM = 100057, 1140, 74361, 63219
TAG = {ONE: 'one', OM: 'om', OM2: 'om2'}

assert (FF_OM ** 2 + FF_OM + 1) % FF_P == 0
assert (8 * FF_KP ** 2 - 13 * FF_KP - 4) % FF_P == 0
assert (FF_KP + FF_KM - 13 * pow(8, FF_P - 2, FF_P)) % FF_P == 0
assert (FF_KP * FF_KM + pow(2, FF_P - 2, FF_P)) % FF_P == 0


def m2_preamble(mode):
    if mode == 'exact':
        return ('kk = toField(QQ[om,kp]/ideal(om^2+om+1, 8*kp^2-13*kp-4));\n')
    return ('kk = ZZ/%d;\nom = %d_kk; kp = %d_kk;\n' % (FF_P, FF_OM, FF_KP))


def eqs_for(block, mode, orbit_reduce=True):
    eqs = L.equations(block, orbit_reduce=orbit_reduce)
    if mode in ('exact', 'qq'):
        return [L.eq_str(e, block.names) for e in eqs]
    return [L.eq_str(e, block.names, mod=True, p=FF_P, omp=FF_OM, kpp=FF_KP)
            for e in eqs]


def run_m2(r, mode, timeout=7200):
    out = []
    for lam in (ONE, OM, OM2):
        b = L.Block(r, 1, lam)
        po = b.param_plane_orders()
        eqs = eqs_for(b, mode)
        src = [m2_preamble(mode)]
        src.append('R = kk[%s,w, MonomialOrder=>GRevLex];\n' % ','.join(b.names))
        src.append('I = ideal(%s);\n' % ','.join(eqs))
        src.append('print("### r=%d lam=%s free=%d eqs=%d");\n'
                   % (r, TAG[lam], b.n, len(eqs)))
        src.append('J = I + ideal(w);\n')
        src.append('d = dim J;\n')
        src.append('print("CONE-DIM " | toString d | '
                   '(if d == 0 then "  ZERO-ONLY" else "  NONTRIVIAL"));\n')
        src.append('if d > 0 then (\n'
                   '  print("CONE-DEGREE " | toString degree J);\n')
        for i, nm in enumerate(b.names):
            src.append('  print("PO%d %s : " | (if (I + ideal(1-w*%s)) '
                       '== ideal(1_R) then "forced-zero" else "CAN-BE-NONZERO"));\n'
                       % (po[i], nm, nm))
        src.append(');\n')
        path = os.path.join(HERE, 'm2', 'cone_r%d_%s_%s.m2' % (r, TAG[lam], mode))
        open(path, 'w').write(''.join(src))
        print('--- M2 [%s] r=%d lam=%s  (free=%d, eqs=%d)'
              % (mode, r, TAG[lam], b.n, len(eqs)))
        sys.stdout.flush()
        try:
            p = subprocess.run([M2, '--script', path], capture_output=True,
                               text=True, timeout=timeout)
            txt = (p.stdout + p.stderr).rstrip()
        except subprocess.TimeoutExpired:
            txt = 'TIMEOUT after %ds' % timeout
        print(txt)
        sys.stdout.flush()
        out.append((r, TAG[lam], txt))
    return out


def run_ms(r, mode, timeout=7200, only_lam=None, extra=None, tagsuffix=''):
    """msolve: for each coordinate v, decide whether I + (v-1) has a solution.

    A homogeneous cone is {0} iff every such system is inconsistent.
    """
    res = {}
    for lam in (ONE, OM, OM2):
        if only_lam is not None and lam != only_lam:
            continue
        b = L.Block(r, 1, lam)
        po = b.param_plane_orders()
        eqs = eqs_for(b, mode)
        if mode == 'qq':
            variables = b.names + ['om', 'kp']
            char = 0
            base = eqs + ['om^2+om+1', '8*kp^2-13*kp-4']
        else:
            variables = list(b.names)
            char = FF_P
            base = eqs
        if extra:
            base = base + list(extra)
        for i, nm in enumerate(b.names):
            polys = base + ['%s-1' % nm]
            src = '%s\n%d\n%s\n' % (','.join(variables), char, ',\n'.join(polys))
            tg = 'cone_r%d_%s_%s%s_%s' % (r, TAG[lam], mode, tagsuffix, nm)
            inp = os.path.join(HERE, 'msolve', tg + '.ms')
            outp = os.path.join(HERE, 'msolve', tg + '.out')
            open(inp, 'w').write(src)
            try:
                subprocess.run([MSOLVE, '-t', '6', '-f', inp, '-o', outp],
                               capture_output=True, text=True, timeout=timeout)
                txt = open(outp).read().strip() if os.path.exists(outp) else ''
                v = 'forced-zero' if txt.startswith('[-1]') else (
                    'CAN-BE-NONZERO' if txt else 'no-output')
            except subprocess.TimeoutExpired:
                v = 'TIMEOUT'
            res[(TAG[lam], nm)] = (po[i], v)
            print('MS[%s] r=%d lam=%-4s %-4s (plane order %d) : %s'
                  % (mode, r, TAG[lam], nm, po[i], v))
            sys.stdout.flush()
    return res


if __name__ == '__main__':
    engine, mode = sys.argv[1], sys.argv[2]
    for r in (int(v) for v in sys.argv[3:]):
        if engine == 'm2':
            run_m2(r, mode)
        else:
            run_ms(r, mode)
