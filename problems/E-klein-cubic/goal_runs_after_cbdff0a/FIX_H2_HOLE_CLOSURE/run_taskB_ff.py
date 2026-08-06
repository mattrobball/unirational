#!/usr/bin/env python3
"""driver: TASK B mod-p 4-run form (a FINDING, stronger than FIX-H1's 144 pairs)."""
import os, sys
import h2_engines as E
E.NTH = os.environ.get('NTH', '3')
import h2_taskB as TB
ok = {}
for (n, lam) in [(3, 'om'), (3, 'om2'), (4, 'one'), (5, 'one')]:
    ok[(n, lam)] = TB.run(n, lam, tmo=1800, mode='ff')
print('TASKB-FF SUMMARY: %s' % {('n%d_%s' % k): v for k, v in ok.items()})
