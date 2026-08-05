#!/usr/bin/env python3
"""FIX-H1: second independent characteristic-zero engine on EVERY leaf.

Macaulay2 over the exact number field K = toField(QQ[om,kp]/(om^2+om+1,
8kp^2-13kp-4)), `1 % I == 0`, run leaf-parallel.  This is the independent
confirmation of the msolve-over-QQ certificate of `holes_parallel.py`.

usage:  holes_m2pass.py r [--nprocs=N] [--tmo=SECONDS]
"""
import multiprocessing as mp
import sys
import time

import holes_leaf as LF
import holes_track as TR


def decide(arg):
    tag, names, polys, tmo = arg
    t0 = time.time()
    v, _ = LF.m2_verdict(names, polys, tag, timeout=tmo)
    return (tag, len(names), len(polys), v, time.time() - t0)


def main():
    r = int(sys.argv[1])
    npr, tmo = 8, 900
    for a in sys.argv[2:]:
        if a.startswith('--nprocs='):
            npr = int(a.split('=')[1])
        if a.startswith('--tmo='):
            tmo = int(a.split('=')[1])
    jobs = []
    for lam in ('one', 'om', 'om2'):
        for which in ('A', 'B', 'C', 'D'):
            br, blk, vs = TR.stratum_branch(r, lam, which)
            for li, lf in enumerate(TR.solve(br)):
                if lf.polys:
                    jobs.append(('m2_r%d_%s_%s_%d' % (r, lam, which, li),
                                 lf.names, lf.polys, tmo))
    print('M2 pass: %d leaves' % len(jobs), flush=True)
    bad = []
    with mp.Pool(npr) as pool:
        for tag, nv, ng, v, dt in pool.imap_unordered(decide, jobs):
            print('   %-24s vars=%2d gens=%2d M2-unit=%s %.1fs'
                  % (tag, nv, ng, v, dt), flush=True)
            if v is not True:
                bad.append(tag)
    print('M2 PASS r=%d : %d leaves, %d not unit/undecided %s'
          % (r, len(jobs), len(bad), bad), flush=True)


if __name__ == '__main__':
    main()
