#!/usr/bin/env python3
"""FIX-N2: decide the C3-equivariant pointwise cones with msolve (third engine).

For a HOMOGENEOUS ideal I in QQbar[v_0..v_k], the solution cone is {0} iff for
every i the affine system  I + (v_i - 1)  has no solution in the algebraic
closure (scaling).  msolve prints `[-1]` exactly in that case.  Running the test
for every coordinate is therefore a rigorous decision procedure, not a
probabilistic one.

Two coefficient regimes:
  mode 'ff'     : characteristic 100057 with om,kp,km the reduced Klein values.
  mode 'qq'     : characteristic 0, with om,kp,km carried as extra variables
                  subject to om^2+om+1, 8kp^2-13kp-4, 8km+8kp-13.  Rigorous
                  over QQ.

Usage: python3 produce_msolve.py MODE m r1 r2 ...
"""

import os
import subprocess
import sys

import sympy as sp

import produce_c3_equivariant as EQ
from cell_lib import om, kp, km

MSOLVE = "/opt/homebrew/bin/msolve"
HERE = os.path.dirname(os.path.abspath(__file__))
FF_P, FF_OM, FF_KP, FF_KM = 100057, 1140, 74361, 63219


def poly_str(e):
    return str(sp.expand(e)).replace('**', '^').replace(' ', '')


def decide(r, m, lam, mode='ff', timeout=1800):
    res = EQ.equivariant_tuple(r, m, lam)
    if res is None:
        return 'empty linear space', []
    forms, free = res
    if not free:
        return 'empty linear space', []
    eqs = EQ.landing_eqs(forms)
    if not eqs:
        return 'NONTRIVIAL (no landing equations at all)', free
    verdicts = {}
    os.makedirs(os.path.join(HERE, 'msolve'), exist_ok=True)
    for v in free:
        if mode == 'ff':
            sub = {om: FF_OM, kp: FF_KP, km: FF_KM}
            variables = [str(u) for u in free]
            char = FF_P
            polys = [poly_str(sp.expand(e.subs(sub))) for e in eqs]
        else:
            variables = [str(u) for u in free] + ['om', 'kp', 'km']
            char = 0
            polys = [poly_str(e) for e in eqs] + [
                'om^2+om+1', '8*kp^2-13*kp-4', '8*km+8*kp-13']
        polys.append('%s-1' % v)
        src = '%s\n%d\n%s\n' % (','.join(variables), char, ',\n'.join(polys))
        tag = 'c3_%d_%d_%s_%s_%s' % (m, r, {1: 'one', om: 'om', om**2: 'om2'}[lam],
                                     mode, v)
        inp = os.path.join(HERE, 'msolve', tag + '.ms')
        outp = os.path.join(HERE, 'msolve', tag + '.out')
        with open(inp, 'w') as fh:
            fh.write(src)
        subprocess.run([MSOLVE, '-t', '6', '-f', inp, '-o', outp], capture_output=True,
                       text=True, timeout=timeout)
        txt = open(outp).read().strip() if os.path.exists(outp) else ''
        verdicts[str(v)] = 'no solution' if txt.startswith('[-1]') else txt[:60]
    trivial = all(w == 'no solution' for w in verdicts.values())
    return ('cone = {0}' if trivial else 'NONTRIVIAL'), verdicts


if __name__ == '__main__':
    mode = sys.argv[1]
    m = int(sys.argv[2])
    for r in (int(v) for v in sys.argv[3:]):
        for lam, tag in ((1, 'lam=1'), (om, 'lam=om'), (om**2, 'lam=om^2')):
            verdict, det = decide(r, m, lam, mode)
            print('msolve[%s] m=%d r=%d %-9s : %s' % (mode, m, r, tag, verdict))
            if verdict == 'NONTRIVIAL' and isinstance(det, dict):
                for k, v in det.items():
                    if v != 'no solution':
                        print('        %s can be nonzero' % k)
            sys.stdout.flush()
