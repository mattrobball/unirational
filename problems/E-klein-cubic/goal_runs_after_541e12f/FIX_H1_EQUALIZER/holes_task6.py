#!/usr/bin/env python3
"""FIX-H1 TASK 6 driver: decide the plane-order-1 locus of the (1,r) cone
(r even) in all three eigenblocks, exactly, in characteristic zero.

usage:  holes_task6.py [r] [lam,...] [--nom2]
"""
import sys
import time

import holes_lib as H
import holes_leaf as LF
import holes_reduce as RD
import holes_solve as SV
import holes_strata as ST


def run(r=8, lams=('one', 'om', 'om2'), do_m2=True, maxdeg=6):
    summary = []
    for lam in lams:
        for which in ('A', 'B', 'C', 'D'):
            t0 = time.time()
            names, polys, _ = ST.stratum(r, lam, which, maxdeg=4, verbose=False)
            if len(polys) == 1 and sum(next(iter(polys[0]))) == 0:
                print('r=%d lam=%-4s stratum %s : IMMEDIATELY EMPTY'
                      % (r, lam, which), flush=True)
                summary.append((lam, which, 'EMPTY', 0, 0))
                continue
            leaves = SV.solve(names, polys, maxdeg=maxdeg, verbose=False)
            print('r=%d lam=%-4s stratum %s : %d leaves (%.1f s)'
                  % (r, lam, which, len(leaves), time.time() - t0), flush=True)
            allempty = True
            for li, (nm, pl, path) in enumerate(leaves):
                tag = 'leaf_r%d_%s_%s_%d' % (r, lam, which, li)
                if not pl:
                    print('   %s : NO EQUATIONS on %d vars -> POPULATED  %s'
                          % (tag, len(nm), path), flush=True)
                    allempty = False
                    continue
                u1, exprs = LF.sympy_verdict(nm, pl)
                v2 = None
                if do_m2:
                    v2, _ = LF.m2_verdict(nm, pl, tag)
                ok = (u1 is True) and (v2 in (True, None))
                print('   %s vars=%d gens=%d  sympy-unit=%s  M2-unit=%s  %s'
                      % (tag, len(nm), len(pl), u1, v2, path), flush=True)
                if not u1 or v2 is False:
                    allempty = False
                    print('      GB (sympy): %s' % [str(e) for e in exprs][:8],
                          flush=True)
                    print('      leaf vars %s' % nm, flush=True)
                    for q in pl:
                        print('        %s' % RD.polystr(q, nm), flush=True)
            summary.append((lam, which, 'EMPTY' if allempty else 'NONEMPTY',
                            len(leaves), time.time() - t0))
    print()
    print('==== SUMMARY r=%d ====' % r, flush=True)
    for lam, which, verdict, nl, dt in summary:
        print('  lam=%-4s stratum %s : %-9s (%d leaves, %.1f s)'
              % (lam, which, verdict, nl, dt), flush=True)
    empties = all(s[2] == 'EMPTY' for s in summary)
    print('  PLANE-ORDER-1 LOCUS OF THE r=%d CONE: %s'
          % (r, 'EMPTY' if empties else 'NOT EMPTY (see above)'), flush=True)
    return summary


if __name__ == '__main__':
    r = int(sys.argv[1]) if len(sys.argv) > 1 and sys.argv[1].isdigit() else 8
    lams = ('one', 'om', 'om2')
    for a in sys.argv[1:]:
        if ',' in a or a in ('one', 'om', 'om2'):
            lams = tuple(a.split(','))
    run(r, lams, do_m2=('--nom2' not in sys.argv))
