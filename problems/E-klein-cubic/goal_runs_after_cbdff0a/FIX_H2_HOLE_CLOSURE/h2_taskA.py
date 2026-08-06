#!/usr/bin/env python3
"""FIX-H2 TASK A: decide the residual {B6 != 0, B9 != 0} region of the (1,r)
cone (r even) in characteristic zero, using the BOTH-NONZERO licence.

See `h2_licence.py` for the derivation of the licence.  Its conclusion:

    the plane-order-1 locus of the (1,r) cone in eigenblock lam is NONEMPTY
    <=>  V( cone , B6 - 1 , X0 , Y1 )  is NONEMPTY .                     (L)

so a single system per eigenblock decides the whole hole, and the three
D-chart hard leaves of FIX-H1 are settled by (L) with no computation of their
own.

usage:
  h2_taskA.py triage [r]            -- mod-p shape of the licensed system
  h2_taskA.py char0  [r] [lam,...]  -- the char-0 battery, SEQUENTIALLY
  h2_taskA.py leaf   [r] [lam,...]  -- the same battery on FIX-H1's own
                                       B_43 leaf, saturated at B9 (control)
"""
import json
import os
import sys
import time

import h2_engines as E
import h2_licence as LI
import holes_lib as H
import holes_reduce as RD
import holes_track as TR

LAMS = ('one', 'om', 'om2')


def triage(r):
    print('=== TASK A triage: licensed system mod p (FINDING only) ===',
          flush=True)
    for lam in LAMS:
        names, polys, b, vs = LI.licensed_system(r, lam)
        for p in E.PRIMES:
            v, dt, info = E.ff('tA_lic_r%d_%s' % (r, lam), names, polys, p=p,
                               timeout=1800)
            print('  r=%d lam=%-4s p=%-8d %d vars %d gens -> %s  (%.1f s)'
                  % (r, lam, p, len(names), len(polys),
                     'UNIT' if v is True else
                     ('NONUNIT' if v is False else 'ERR/NOT-DECIDED'), dt),
                  flush=True)
            if v is not True:
                print('     %s' % info[:400], flush=True)


def char0(r, lams):
    print('=== TASK A: characteristic-zero battery on the licensed system ===',
          flush=True)
    print('    (sequential; msolve -t %s; hard timeout 3600 s; a timeout is '
          'NOT-DECIDED)' % E.NTH, flush=True)
    res = {}
    for lam in lams:
        names, polys, b, vs = LI.licensed_system(r, lam)
        tag = 'tA_lic_r%d_%s' % (r, lam)
        print('  --- r=%d lam=%s : %d vars %s, %d gens, degrees %s'
              % (r, lam, len(names), names, len(polys),
                 sorted({sum(k) for q in polys for k in q})), flush=True)
        vq, dtq, iq = E.qq(tag, names, polys, timeout=3600)
        print('      msolve-qq  = %-5s  (%.1f s)  %s'
              % (vq, dtq, '' if vq is not None else iq[:200]), flush=True)
        vm, dtm, im = E.m2(tag, names, polys, timeout=3600)
        print('      Macaulay2  = %-5s  (%.1f s)  %s'
              % (vm, dtm, '' if vm is not None else im[:200]), flush=True)
        vs_ = vm2 = None
        if vq is not True or vm is not True:
            vs_, dts, is_ = E.sp(names, polys)
            print('      sympy      = %-5s  (%.1f s)  %s'
                  % (vs_, dts, is_[:200]), flush=True)
        votes = [v for v in (vq, vm, vs_) if v in (True, False)]
        agree = len(votes) >= 2 and all(v is True for v in votes)
        res[lam] = {'qq': vq, 'm2': vm, 'sympy': vs_,
                    'verdict': ('EMPTY' if agree else
                                ('NONEMPTY' if any(v is False for v in votes)
                                 else 'NOT-DECIDED')),
                    'secs': {'qq': dtq, 'm2': dtm}}
        print('      => %s' % res[lam]['verdict'], flush=True)
    out = os.path.join(H.HERE, 'payloads', 'taskA_r%d.json' % r)
    old = {}
    if os.path.exists(out):
        old = json.load(open(out))
    old.update(res)
    json.dump(old, open(out, 'w'), indent=1, sort_keys=True)
    print('\nTASK A r=%d: %s' % (r, {k: v['verdict'] for k, v in old.items()}),
          flush=True)


def leaf(r, lams):
    """control: FIX-H1's own hard leaf B_43, with the Rabinowitsch saturation
    at B9 that the licence permits (V(cone) n {B6=1, B9=0} is empty, so
    I : B9^inf has the same variety)."""
    from n2b_lib import ONE
    import n2b_lib as L
    print('=== TASK A control: FIX-H1 leaf B_43, saturated at B9 ===',
          flush=True)
    for lam in lams:
        br, blk, vs = TR.stratum_branch(r, lam, 'B')
        leaves = TR.solve(br)
        li = max(range(len(leaves)), key=lambda i: len(leaves[i].names))
        lf = leaves[li]
        names, polys = list(lf.names), [dict(q) for q in lf.polys]
        i9 = names.index('B9')
        n = len(names)
        e9 = [0] * (n + 1)
        e9[i9] = 1
        e9[n] = 1
        polys = [{tuple(list(k) + [0]): v for k, v in q.items()} for q in polys]
        polys.append({tuple(e9): ONE, tuple([0] * (n + 1)): L.kneg(ONE)})
        names = names + ['w']
        tag = 'tA_leafB43sat_r%d_%s' % (r, lam)
        print('  --- %s leaf B_%d + B9*w=1 : %d vars, %d gens'
              % (lam, li, len(names), len(polys)), flush=True)
        vq, dtq, iq = E.qq(tag, names, polys, timeout=3600)
        print('      msolve-qq  = %-5s (%.1f s) %s'
              % (vq, dtq, '' if vq is not None else iq[:160]), flush=True)


if __name__ == '__main__':
    what = sys.argv[1]
    r = int(sys.argv[2]) if len(sys.argv) > 2 else 8
    lams = tuple(sys.argv[3].split(',')) if len(sys.argv) > 3 else LAMS
    if what == 'triage':
        triage(r)
    elif what == 'char0':
        char0(r, lams)
    elif what == 'leaf':
        leaf(r, lams)
    else:
        print(__doc__)
