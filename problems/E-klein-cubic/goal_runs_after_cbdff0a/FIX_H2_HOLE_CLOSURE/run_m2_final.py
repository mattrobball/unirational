#!/usr/bin/env python3
"""FIX-H2 TASK A: the Macaulay2 (independent second engine) side.

Run on the WHOLE-case low-degree presentations only -- `lowdeg4` for CASE Z
(11 vars, 19 cubics) and `lowdeg` for CASE N (16 vars, 27 cubics).  Each cuts
out its entire case, so one unit-ideal answer settles the case.  These are the
presentations msolve also decides in 1-10 s; the exact cascade's `reduced`
leaves are small in variables but degree 15-18 and Macaulay2 does badly on
those.
"""
import json, os, sys
import h2_engines as E
import h2_final as FF
import holes_lib as H
WANT = {'Z': ('lowdeg4', 'lowdeg', 'lowdeg-sat'), 'N': ('lowdeg', 'lowdeg-sat')}
res = {}
for lam in ('one', 'om', 'om2'):
    pres = FF.presentations(8, lam)
    for case in ('Z', 'N'):
        verdict = 'NOT-DECIDED'
        for want in WANT[case]:
            hit = [(k, nm, pl) for c, k, nm, pl in pres if c == case and k == want]
            if not hit:
                continue
            k, nm, pl = hit[0]
            v, dt, info = E.m2v('h2F_r8_%s_%s_%s' % (lam, case, k), nm, pl,
                                timeout=1500)
            print('  lam=%-4s CASE %s %-12s vars=%2d gens=%2d deg<=%2d  '
                  'M2v = %-5s (%.0f s) %s'
                  % (lam, case, k, len(nm), len(pl),
                     max(sum(x) for q in pl for x in q), v, dt,
                     '' if v is not None else str(info)[:70]), flush=True)
            if v is True:
                verdict = 'EMPTY-by-M2v (%s)' % k; break
            if v is False:
                verdict = 'NONEMPTY'; break
        res['%s_%s' % (lam, case)] = verdict
        print('  => lam=%s CASE %s : %s' % (lam, case, verdict), flush=True)
p = os.path.join(H.HERE, 'payloads', 'taskA_m2_r8.json')
json.dump(res, open(p, 'w'), indent=1, sort_keys=True)
print('\nFIX-H2 TASK A Macaulay2 side: %s' % res, flush=True)
