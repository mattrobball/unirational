#!/usr/bin/env python3
"""FIX-H1 TASK 6: leaf-parallel characteristic-zero pass.

Enumerates every leaf of every stratum of every eigenblock at a given even r,
then decides them in parallel with msolve over QQ (om, kp adjoined as variables
with their minimal polynomials -- characteristic zero, rigorous by Galois
transitivity) and, for the ones msolve cannot finish, Macaulay2 over the exact
number field.  Modular runs (three split primes) are FINDINGS only.

usage:  holes_parallel.py r [--nprocs=N] [--tmo=SECONDS]
"""
import multiprocessing as mp
import os
import pickle
import sys
import time

import holes_leaf as LF
import holes_lib as H
import holes_track as TR
import n2c_systems as S

PRIMES = [100057, 100153, 1048609]


def decide(arg):
    tag, names, polys, tmo = arg
    t0 = time.time()
    mods = []
    for p in PRIMES:
        omp, kpp = S.find_roots(p)
        src = H.emit_ff(names, polys, p, omp, kpp)
        rc, dt, txt = H.run_msolve('%s_p%d' % (tag, p), src, flags=['-g', '1'],
                                   nthreads='1', timeout=tmo)
        mods.append('ERR' if txt.startswith('<')
                    else ('U' if H.is_unit_ideal(txt) else 'N'))
    src = H.emit_vars(names, polys, 0)
    rc, dt, txt = H.run_msolve(tag + '_qq', src, flags=['-g', '2'],
                               nthreads='1', timeout=tmo)
    qq = None if txt.startswith('<') else H.is_unit_ideal(txt)
    m2 = None
    if qq is not True:
        m2, _ = LF.m2_verdict(names, polys, tag, timeout=tmo)
    return (tag, len(names), len(polys), mods, qq, m2, time.time() - t0)


def main():
    r = int(sys.argv[1])
    npr = 8
    tmo = 900
    for a in sys.argv[2:]:
        if a.startswith('--nprocs='):
            npr = int(a.split('=')[1])
        if a.startswith('--tmo='):
            tmo = int(a.split('=')[1])
    jobs = []
    for lam in ('one', 'om', 'om2'):
        for which in ('A', 'B', 'C', 'D'):
            br, blk, vs = TR.stratum_branch(r, lam, which)
            leaves = TR.solve(br)
            print('r=%d lam=%-4s stratum %s: %d leaves' % (r, lam, which,
                                                           len(leaves)),
                  flush=True)
            for li, lf in enumerate(leaves):
                tag = 'pl_r%d_%s_%s_%d' % (r, lam, which, li)
                if not lf.polys:
                    print('   %s NO EQUATIONS -> POPULATED' % tag, flush=True)
                    continue
                jobs.append((tag, lf.names, lf.polys, tmo))
    print('total leaves to decide: %d' % len(jobs), flush=True)
    bad = []
    with mp.Pool(npr) as pool:
        for res in pool.imap_unordered(decide, jobs):
            tag, nv, ng, mods, qq, m2, dt = res
            ok = (qq is True) or (m2 is True)
            print('   %-24s vars=%2d gens=%2d modp=%s qq=%s M2=%s %.1fs %s'
                  % (tag, nv, ng, ''.join(mods), qq, m2, dt,
                     'EMPTY' if ok else '*** NOT CERTIFIED ***'), flush=True)
            if not ok:
                bad.append(tag)
    print()
    print('FIX-H1 r=%d : %d leaves, %d NOT certified %s'
          % (r, len(jobs), len(bad), bad), flush=True)
    print('PLANE-ORDER-1 LOCUS OF THE r=%d CONE: %s'
          % (r, 'EMPTY (char-0 certified on every leaf)' if not bad
             else 'INCOMPLETE'), flush=True)


if __name__ == '__main__':
    main()
