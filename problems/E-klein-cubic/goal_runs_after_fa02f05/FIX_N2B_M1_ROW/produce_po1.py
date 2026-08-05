#!/usr/bin/env python3
"""FIX-N2B: the decisive saturation -- can a PLANE-ORDER-1 parameter be nonzero
on the C3-equivariant pointwise cone?  (2 parameters per eigenblock, at every r.)

Runs msolve in Groebner mode on  I + (1 - w v)  for v the two plane-order-1
parameters; the reduced basis is {1} exactly when v vanishes on the whole cone.
"""
import os, sys, time
import n2b_lib as L
from n2b_lib import ONE, OM, OM2
from produce_gb import build, run_msolve, is_unit_ideal
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
            vs = variables + ['wsat']
            ps = polys + ['1-wsat*%s' % nm]
            t, dt = run_msolve(vs, char, ps, 'po1_r%d_%s_%s_%s' % (r, TAG[lam], mode, nm),
                               gmode=1, timeout=TO)
            v = 'TIMEOUT' if t is None else ('forced-zero' if is_unit_ideal(t)
                                             else 'CAN-BE-NONZERO')
            print('PO1[%s] r=%d lam=%-4s %-5s : %-15s (%.1fs)' % (mode, r, TAG[lam], nm, v, dt))
            sys.stdout.flush()
