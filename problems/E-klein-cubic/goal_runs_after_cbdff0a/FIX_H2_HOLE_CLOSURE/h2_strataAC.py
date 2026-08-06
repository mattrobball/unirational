#!/usr/bin/env python3
"""FIX-H2: INDEPENDENT re-certification of the two strata the licence rests on.

The whole TASK-A reduction is conditional on FIX-H1's char-0 verdicts

    (A-cert)  V(cone) n {B6 = 1, B9 = 0} = empty      (stratum A)
    (C-cert)  V(cone) n {B9 = 1, B6 = 0} = empty      (stratum C)

in all three eigenblocks.  FIX-H1 reports stratum A with msolve-qq AND
Macaulay2, but stratum C only with msolve-qq plus a modular cross-check.  This
packet's discipline is two independent characteristic-zero engines per EMPTY
verdict, so both strata are re-run here from scratch, in this packet, with
msolve over QQ, Macaulay2 over K, and sympy where the leaf is small.

usage:  h2_strataAC.py [r] [lam,...]
"""
import json
import os
import sys
import time

import h2_engines as E
import holes_lib as H
import holes_track as TR

LAMS = ('one', 'om', 'om2')


def main():
    r = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    lams = tuple(sys.argv[2].split(',')) if len(sys.argv) > 2 else LAMS
    print('=== FIX-H2: re-certification of strata A and C, r = %d ===' % r,
          flush=True)
    res = {}
    for lam in lams:
        for which in ('A', 'C'):
            t0 = time.time()
            br, blk, vs = TR.stratum_branch(r, lam, which)
            leaves = TR.solve(br)
            print('r=%d lam=%-4s stratum %s (%s=1, %s=0): %d leaves (%.1f s)'
                  % (r, lam, which, vs[0], vs[1], len(leaves),
                     time.time() - t0), flush=True)
            ok = True
            for li, lf in enumerate(leaves):
                tag = 'h2AC_r%d_%s_%s_%d' % (r, lam, which, li)
                if not lf.polys:
                    print('   %s NO EQUATIONS on %d vars -> POPULATED'
                          % (tag, len(lf.names)), flush=True)
                    ok = False
                    continue
                vq, dtq, iq = E.qq(tag, lf.names, lf.polys, timeout=1800)
                vm, dtm, im = E.m2(tag, lf.names, lf.polys, timeout=1800)
                vsp = None
                if len(lf.names) <= 6:
                    vsp, _, _ = E.sp(lf.names, lf.polys)
                votes = [v for v in (vq, vm, vsp) if v in (True, False)]
                good = len(votes) >= 2 and all(v is True for v in votes)
                ok = ok and good
                print('   %s vars=%d gens=%d | qq=%-5s(%.1fs) M2=%-5s(%.1fs) '
                      'sp=%-5s | %s'
                      % (tag, len(lf.names), len(lf.polys), vq, dtq, vm, dtm,
                         vsp, 'EMPTY' if good else '*** NOT CERTIFIED ***'),
                      flush=True)
            res['%s_%s' % (lam, which)] = 'EMPTY' if ok else 'NOT CERTIFIED'
            print('   => stratum %s, lam=%s : %s'
                  % (which, lam, res['%s_%s' % (lam, which)]), flush=True)
    p = os.path.join(H.HERE, 'payloads', 'strataAC_r%d.json' % r)
    old = json.load(open(p)) if os.path.exists(p) else {}
    old.update(res)
    json.dump(old, open(p, 'w'), indent=1, sort_keys=True)
    print('\nFIX-H2 strata A/C re-certification r=%d: %s' % (r, old),
          flush=True)


if __name__ == '__main__':
    main()
