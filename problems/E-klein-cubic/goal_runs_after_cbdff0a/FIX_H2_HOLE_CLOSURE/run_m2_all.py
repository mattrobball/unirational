#!/usr/bin/env python3
"""FIX-H2 TASK A: the Macaulay2 side -- the INDEPENDENT second engine.

Run on the WHOLE-case low-degree presentations (11-17 variables, degree <= 3),
which are the ones a Groebner engine over QQ handles: the exact cascade's
`reduced' leaves are small in variables but degree 15-18, and Macaulay2 does
badly on those.  Two Macaulay2 formulations are tried, both characteristic
zero and both independent of msolve:
   M2v : QQ[vars, om, kp] + the two minimal polynomials, 1 % I == 0
   M2K : toField(QQ[om,kp]/(...)), 1 % I == 0
"""
import json, os, sys
import h2_engines as E
import h2_final as FF
import holes_lib as H
r = 8
res = {}
for lam in ('one', 'om', 'om2'):
    pres = FF.presentations(r, lam)
    for case in ('Z', 'N'):
        whole = [(k, nm, pl) for c, k, nm, pl in pres
                 if c == case and not k.startswith('reduced')]
        whole.sort(key=lambda t: len(t[1]))
        verdict = 'NOT-DECIDED'
        for kind, nm, pl in whole:
            done = False
            for eng, fn in (('M2v', E.m2v), ('M2K', E.m2)):
                tag = 'h2M_r%d_%s_%s_%s' % (r, lam, case, kind)
                v, dt, info = fn(tag, nm, pl, timeout=1500)
                print('  lam=%-4s CASE %s %-12s vars=%2d gens=%2d deg<=%2d  '
                      '%s = %-5s (%.0f s)'
                      % (lam, case, kind, len(nm), len(pl),
                         max(sum(k) for q in pl for k in q), eng, v, dt),
                      flush=True)
                if v is True:
                    verdict = 'EMPTY-by-%s (%s)' % (eng, kind); done = True; break
                if v is False:
                    verdict = 'NONEMPTY'; done = True; break
            if done:
                break
        res['%s_%s' % (lam, case)] = verdict
        print('  => lam=%s CASE %s : %s' % (lam, case, verdict), flush=True)
p = os.path.join(H.HERE, 'payloads', 'taskA_m2_r%d.json' % r)
json.dump(res, open(p, 'w'), indent=1, sort_keys=True)
print('\nFIX-H2 TASK A Macaulay2 side: %s' % res, flush=True)
