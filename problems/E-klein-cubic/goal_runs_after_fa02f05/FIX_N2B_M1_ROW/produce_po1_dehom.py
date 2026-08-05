#!/usr/bin/env python3
"""FIX-N2B: same question as produce_po1.py (can a plane-order-1 parameter be
nonzero on the cone?) but DEHOMOGENISED -- the parameter is set to 1 instead of
being inverted by a slack variable.  The cone is homogeneous, so

    v vanishes on the cone   <=>   I|_{v=1} = (1) ,

and the dehomogenised ideal has one variable fewer, which is what makes r >= 7
reachable.
"""
import os, sys
import re
import n2b_lib as L
from n2b_lib import ONE, OM, OM2
from produce_gb import build, run_msolve, is_unit_ideal


def _sub(poly, name):
    return re.sub(r'\b%s\b' % re.escape(name), '1', poly)
TAG = {ONE: 'one', OM: 'om', OM2: 'om2'}
mode = sys.argv[1]
TO = int(os.environ.get('N2B_TIMEOUT', '5400'))
for r in (int(v) for v in sys.argv[2:]):
    for lam in (ONE, OM, OM2):
        b, variables, char, polys = build(r, lam, mode)
        po = b.param_plane_orders()
        for i, nm in enumerate(b.names):
            if po[i] != 1:
                continue
            vs = [v for v in variables if v != nm]
            ps = []
            for q in polys:
                # textual substitution nm -> 1 is safe: names are P#,R#,B#,om,kp
                ps.append(_sub(q, nm))
            t, dt = run_msolve(vs, char, ps,
                               'po1d_r%d_%s_%s_%s' % (r, TAG[lam], mode, nm),
                               gmode=1, timeout=TO)
            v = 'TIMEOUT' if t is None else ('forced-zero' if is_unit_ideal(t)
                                             else 'CAN-BE-NONZERO')
            print('PO1d[%s] r=%d lam=%-4s %-5s : %-15s (%.1fs)'
                  % (mode, r, TAG[lam], nm, v, dt))
            sys.stdout.flush()
