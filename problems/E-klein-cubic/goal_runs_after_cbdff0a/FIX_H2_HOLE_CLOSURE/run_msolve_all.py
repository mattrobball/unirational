#!/usr/bin/env python3
"""FIX-H2 TASK A: the msolve-over-QQ side of the decision, all blocks.

CAREFUL WITH THE SEMANTICS OF THE PRESENTATIONS (a bug caught mid-run):

  * `lowdeg*` and `faceleaf` each cut out the WHOLE case, so a unit ideal on
    any ONE of them proves the whole case empty;
  * `reduced*` are the LEAVES of the exact branch-and-reduce -- a COVER of the
    case, not alternative presentations.  The case is empty only when EVERY
    surviving leaf is empty.  (Leaves on which B9 vanishes identically are
    dropped by the licence and never appear here.)

CASE Z happens to have exactly one surviving leaf, so the distinction is
invisible there; CASE N has four, and treating them as alternatives would be
a false EMPTY.
"""
import json, os, sys
import h2_engines as E
import h2_final as FF
import holes_lib as H
E.NTH = os.environ.get('NTH', '6')
r = 8
res = {}
for lam in ('one', 'om', 'om2'):
    pres = FF.presentations(r, lam)
    for case in ('Z', 'N'):
        whole = [(k, nm, pl) for c, k, nm, pl in pres
                 if c == case and not k.startswith('reduced')]
        cover = [(k, nm, pl) for c, k, nm, pl in pres
                 if c == case and k.startswith('reduced')]
        whole.sort(key=lambda t: len(t[1]))
        verdict = None
        # (a) a WHOLE-case presentation settles everything in one run, so try
        #     those first (they are low degree, which msolve handles well)
        for kind, nm, pl in whole:
            tag = 'h2m_r%d_%s_%s_%s' % (r, lam, case, kind)
            v, dt, info = E.qq(tag, nm, pl, timeout=1200)
            print('  lam=%-4s CASE %s  whole %-11s vars=%2d gens=%2d '
                  'deg<=%2d  msolve-qq = %-5s (%.0f s)'
                  % (lam, case, kind, len(nm), len(pl),
                     max(sum(k) for q in pl for k in q), v, dt), flush=True)
            if v is True:
                verdict = 'EMPTY-by-msolve (whole case, %s)' % kind; break
            if v is False:
                verdict = 'NONEMPTY'; break
        if verdict is not None:
            res['%s_%s' % (lam, case)] = verdict
            print('  => lam=%s CASE %s : %s' % (lam, case, verdict), flush=True)
            continue
        # (b) otherwise decide the COVER leaf by leaf
        allpieces = True
        for kind, nm, pl in cover:
            if not pl:
                print('  lam=%-4s CASE %s %-12s NO EQUATIONS on %d vars '
                      '-> POPULATED' % (lam, case, kind, len(nm)), flush=True)
                verdict = 'NONEMPTY'; allpieces = False; break
            tag = 'h2m_r%d_%s_%s_%s' % (r, lam, case, kind)
            v, dt, info = E.qq(tag, nm, pl, timeout=1800)
            print('  lam=%-4s CASE %s  piece %-11s vars=%2d gens=%2d deg<=%2d '
                  ' msolve-qq = %-5s (%.0f s)'
                  % (lam, case, kind, len(nm), len(pl),
                     max(sum(k) for q in pl for k in q), v, dt), flush=True)
            if v is False:
                verdict = 'NONEMPTY'; allpieces = False; break
            if v is not True:
                allpieces = False
        if verdict is None and allpieces and cover:
            verdict = 'EMPTY-by-msolve (all %d leaves of the cover)' % len(cover)
        res['%s_%s' % (lam, case)] = verdict or 'NOT-DECIDED'
        print('  => lam=%s CASE %s : %s' % (lam, case, res['%s_%s' % (lam, case)]),
              flush=True)
p = os.path.join(H.HERE, 'payloads', 'taskA_msolve_r%d.json' % r)
json.dump(res, open(p, 'w'), indent=1, sort_keys=True)
print('\nFIX-H2 TASK A msolve side: %s' % res, flush=True)
