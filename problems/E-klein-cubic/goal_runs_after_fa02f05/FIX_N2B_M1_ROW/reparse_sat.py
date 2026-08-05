#!/usr/bin/env python3
"""Re-read the msolve saturation outputs already on disk and print verdicts."""
import os, sys, glob
import n2b_lib as L
from n2b_lib import ONE, OM, OM2
from produce_gb import is_unit_ideal
HERE = os.path.dirname(os.path.abspath(__file__))
TAG = {ONE: 'one', OM: 'om', OM2: 'om2'}
for r in (int(v) for v in sys.argv[1:]):
    for lam in (ONE, OM, OM2):
        b = L.Block(r, 1, lam); po = b.param_plane_orders()
        for i, nm in enumerate(b.names):
            for mode in ('ff', 'qq'):
                p = os.path.join(HERE, 'msolve',
                                 'gb_r%d_%s_%s_sat_%s.out' % (r, TAG[lam], mode, nm))
                if not os.path.exists(p):
                    continue
                t = open(p).read()
                print('r=%d lam=%-4s %-4s (plane order %d) [%s]: %s'
                      % (r, TAG[lam], nm, po[i], mode,
                         'forced-zero' if is_unit_ideal(t) else 'CAN-BE-NONZERO'))
