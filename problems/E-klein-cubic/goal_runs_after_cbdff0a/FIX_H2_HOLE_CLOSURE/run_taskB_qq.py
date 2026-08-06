#!/usr/bin/env python3
"""driver: TASK B in CHARACTERISTIC ZERO -- four runs per (n,lam), endpoint
parameters B_0, B_n carried as variables with their minimal polynomials, so
one run covers all six roots at once (Galois transitivity).  These are
VERDICTS, not findings."""
import os, sys
import h2_engines as E
E.NTH = os.environ.get('NTH', '4')
import h2_taskB as TB
todo = [(3, 'om'), (3, 'om2'), (4, 'one'), (5, 'one')]
ok = {}
for (n, lam) in todo:
    ok['n%d_%s' % (n, lam)] = TB.run(n, lam, tmo=1800, mode='qq')
    print('TASKB-QQ RUNNING SUMMARY: %s' % ok, flush=True)
print('TASKB-QQ SUMMARY: %s' % ok)
