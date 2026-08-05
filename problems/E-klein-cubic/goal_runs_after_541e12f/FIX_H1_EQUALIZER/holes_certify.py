#!/usr/bin/env python3
"""FIX-H1 TASK 6: full decision of the plane-order-1 locus of the (1,r) cone
(r even), all three eigenblocks, with a characteristic-zero certificate per leaf
and TWO independent char-0 engines plus a three-prime modular cross-check.

usage:  holes_certify.py r [lam,...] [--nom2] [--nosympy]
"""
import os, pickle, sys, time
import holes_lib as H, holes_leaf as LF, holes_reduce as RD
import holes_track as TR
import n2c_systems as S, n2b_lib as L

PRIMES = [100057, 100153, 1048609]


def modular_leaf(tag, names, polys):
    out = []
    for p in PRIMES:
        omp, kpp = S.find_roots(p)
        assert omp is not None and kpp is not None, 'prime %d not split' % p
        src = H.emit_ff(names, polys, p, omp, kpp)
        rc, dt, txt = H.run_msolve('%s_p%d' % (tag, p), src,
                                   flags=['-g', '1'], nthreads='2')
        if txt.startswith('<'):
            out.append((p, 'ERROR'))
        else:
            out.append((p, 'UNIT' if H.is_unit_ideal(txt) else 'NONUNIT'))
    return out


def main():
    r = int(sys.argv[1])
    lams = ('one', 'om', 'om2')
    for a in sys.argv[2:]:
        if a[0] != '-':
            lams = tuple(a.split(','))
    do_m2 = '--nom2' not in sys.argv
    do_sp = '--nosympy' not in sys.argv
    allok = True
    store = {}
    for lam in lams:
        for which in ('A', 'B', 'C', 'D'):
            t0 = time.time()
            br, blk, vs = TR.stratum_branch(r, lam, which)
            leaves = TR.solve(br)
            print('r=%d lam=%-4s stratum %s (%s=1,%s=0): %d leaves  (%.1f s)'
                  % (r, lam, which, vs[0], vs[1], len(leaves), time.time()-t0),
                  flush=True)
            store[(lam, which)] = [(lf.names, lf.polys, lf.path, lf.env)
                                   for lf in leaves]
            for li, lf in enumerate(leaves):
                tag = 'cf_r%d_%s_%s_%d' % (r, lam, which, li)
                if not lf.polys:
                    print('   %s NO EQUATIONS on %d vars -> POPULATED %s'
                          % (tag, len(lf.names), lf.path), flush=True)
                    allok = False
                    continue
                mods = modular_leaf(tag, lf.names, lf.polys)
                sp = m2 = None
                if do_sp:
                    try:
                        sp, _ = LF.sympy_verdict(lf.names, lf.polys)
                    except Exception as e:
                        sp = 'ERR:%s' % e
                if do_m2:
                    m2, _ = LF.m2_verdict(lf.names, lf.polys, tag)
                print('   %s vars=%s gens=%d | mod-p %s | sympy-unit=%s | '
                      'M2-unit=%s' % (tag, lf.names, len(lf.polys),
                                      ','.join('%d:%s' % m for m in mods),
                                      sp, m2), flush=True)
                if sp is not True or m2 is not True:
                    allok = False
                    print('      !! NOT CERTIFIED EMPTY -- %s' % lf.path,
                          flush=True)
                    for q in lf.polys:
                        print('        %s' % RD.polystr(q, lf.names)[:600],
                              flush=True)
    with open(os.path.join(H.HERE, 'leaves_tracked_r%d.pkl' % r), 'wb') as f:
        pickle.dump(store, f)
    print()
    print('FIX-H1 r=%d PLANE-ORDER-1 LOCUS: %s'
          % (r, 'EMPTY (char-0 certified, all leaves)' if allok
             else 'NOT CERTIFIED EMPTY'), flush=True)


if __name__ == '__main__':
    main()
