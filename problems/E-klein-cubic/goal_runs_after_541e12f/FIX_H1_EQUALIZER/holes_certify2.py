#!/usr/bin/env python3
"""FIX-H1 TASK 6 (v2): decision of the plane-order-1 locus of the (1,r) cone
(r even), all three eigenblocks, with THREE independent characteristic-zero
engines per leaf plus a three-prime modular cross-check.

  qq   msolve over QQ with om, kp adjoined as variables and their minimal
       polynomials added to the ideal.  Both minimal polynomials are
       irreducible over QQ, so Gal(Qbar/QQ) acts transitively on their roots:
       the ideal is (1) iff the system has no solution for the packet's
       (om, kp+).  Input emitted fully expanded and parenthesis-free, asserted
       (msolve 0.10.1 mis-parses parentheses -- FIX-N2C/MSOLVE_PARSER.md).
  m2   Macaulay2 over the exact number field
       K = toField(QQ[om,kp]/(om^2+om+1, 8kp^2-13kp-4)):  1 % I == 0.
  sp   sympy Groebner over QQ[vars,om,kp] + minimal polynomials (small leaves).

Modular verdicts are FINDINGS, never verdicts.

usage:  holes_certify2.py r [lam,...] [--nom2] [--nosympy] [--spmax=N]
"""
import os
import pickle
import sys
import time

import holes_leaf as LF
import holes_lib as H
import holes_reduce as RD
import holes_track as TR
import n2c_systems as S

PRIMES = [100057, 100153, 1048609]
import os
if os.environ.get('ONEPRIME'):
    PRIMES = [100057]


def modular_leaf(tag, names, polys):
    out = []
    for p in PRIMES:
        omp, kpp = S.find_roots(p)
        assert omp is not None and kpp is not None, 'prime %d not split' % p
        src = H.emit_ff(names, polys, p, omp, kpp)
        rc, dt, txt = H.run_msolve('%s_p%d' % (tag, p), src,
                                   flags=['-g', '1'], nthreads='2',
                                   timeout=900)
        out.append((p, 'ERROR' if txt.startswith('<')
                    else ('UNIT' if H.is_unit_ideal(txt) else 'NONUNIT')))
    return out


def qq_leaf(tag, names, polys, timeout=2400):
    src = H.emit_vars(names, polys, 0)
    rc, dt, txt = H.run_msolve(tag + '_qq', src, flags=['-g', '2'],
                               nthreads='2', timeout=timeout)
    if txt.startswith('<'):
        return None, txt
    return H.is_unit_ideal(txt), 'msolve-qq %.1fs' % dt


def main():
    r = int(sys.argv[1])
    lams = ('one', 'om', 'om2')
    for a in sys.argv[2:]:
        if a[0] != '-':
            lams = tuple(a.split(','))
    do_m2 = '--nom2' not in sys.argv
    do_sp = '--nosympy' not in sys.argv
    spmax = 5
    for a in sys.argv:
        if a.startswith('--spmax='):
            spmax = int(a.split('=')[1])
    allok = True
    store = {}
    for lam in lams:
        for which in ('A', 'B', 'C', 'D'):
            t0 = time.time()
            br, blk, vs = TR.stratum_branch(r, lam, which)
            leaves = TR.solve(br)
            print('r=%d lam=%-4s stratum %s (%s=1,%s=0): %d leaves  (%.1f s)'
                  % (r, lam, which, vs[0], vs[1], len(leaves),
                     time.time() - t0), flush=True)
            store[(lam, which)] = [(lf.names, lf.polys, lf.path) for lf in leaves]
            for li, lf in enumerate(leaves):
                tag = 'c2_r%d_%s_%s_%d' % (r, lam, which, li)
                if not lf.polys:
                    print('   %s NO EQUATIONS on %d vars -> POPULATED %s'
                          % (tag, len(lf.names), lf.path), flush=True)
                    allok = False
                    continue
                mods = modular_leaf(tag, lf.names, lf.polys)
                qq, qinfo = qq_leaf(tag, lf.names, lf.polys)
                sp = m2 = 'skip'
                if do_sp and len(lf.names) <= spmax:
                    try:
                        sp, _ = LF.sympy_verdict(lf.names, lf.polys)
                    except Exception as e:
                        sp = 'ERR:%s' % e
                if do_m2:
                    m2, _ = LF.m2_verdict(lf.names, lf.polys, tag, timeout=1800)
                votes = [v for v in (qq, m2, sp) if v in (True, False)]
                good = bool(votes) and all(v is True for v in votes)
                print('   %s vars=%d%s gens=%d | mod-p %s | qq=%s | M2=%s | '
                      'sympy=%s | %s'
                      % (tag, len(lf.names), lf.names, len(lf.polys),
                         ','.join('%d:%s' % m for m in mods), qq, m2, sp,
                         'EMPTY' if good else '*** NOT CERTIFIED ***'),
                      flush=True)
                if not good:
                    allok = False
                    print('      path %s' % lf.path, flush=True)
                    for q in lf.polys:
                        print('        %s' % RD.polystr(q, lf.names)[:800],
                              flush=True)
    with open(os.path.join(H.HERE, 'leaves_r%d_%s.pkl'
                           % (r, '_'.join(lams))), 'wb') as f:
        pickle.dump(store, f)
    print()
    print('FIX-H1 r=%d lams=%s PLANE-ORDER-1 LOCUS: %s'
          % (r, ','.join(lams),
             'EMPTY (char-0 certified on every leaf)' if allok
             else 'NOT CERTIFIED EMPTY'), flush=True)


if __name__ == '__main__':
    main()
