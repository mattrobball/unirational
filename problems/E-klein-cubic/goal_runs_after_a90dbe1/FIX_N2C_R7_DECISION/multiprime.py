#!/usr/bin/env python3
"""FIX-N2C: the multi-prime consistency test for the (1,7) plane-order-1 locus.

For each prime, computes the LEADING IDEAL (msolve `-g 1`) of the dehomogenised
system and reports

    UNIT           the ideal is (1): no plane-order-1 point over Fbar_p
    dim d, deg D   the staircase's dimension and (if d = 0) its degree

A characteristic-zero point would reduce, at all but finitely many primes, to a
point mod p; so a locus that is nonempty in char 0 must be nonempty mod almost
every prime, with a stable dimension.  Conversely a locus that is EMPTY in char
0 has 1 = sum f_i g_i over K, hence is empty mod all but the finitely many
primes dividing the denominators of that identity.  Disagreement between primes
therefore localises the artifact.

usage:  multiprime.py LAM VAR nprimes [start]
"""
import itertools
import os
import subprocess
import sys
import time

import n2c_systems as S

HERE = os.path.dirname(os.path.abspath(__file__))


def staircase(txt):
    body = txt[txt.find('[')+1:txt.rfind(']')].strip()
    if body == '1':
        return 'UNIT', None, None
    if not body:
        return 'EMPTY-OUTPUT', None, None
    mons = [m.strip() for m in body.split(',')]
    return 'NONUNIT', mons, len(mons)


def dim_and_degree(mons, names):
    idx = {v: i for i, v in enumerate(names)}
    sup = []
    exps = []
    for m in mons:
        e = [0]*len(names)
        for f in m.split('*'):
            f = f.strip()
            if not f:
                continue
            nm, _, ex = f.partition('^')
            e[idx[nm]] += int(ex or 1)
        exps.append(tuple(e))
        sup.append({i for i, v in enumerate(e) if v})
    d = 0
    for k in range(len(names), -1, -1):
        if any(all(not (sp <= set(Ssub)) for sp in sup)
               for Ssub in itertools.combinations(range(len(names)), k)):
            d = k
            break
    if d != 0:
        return d, None
    # count standard monomials
    bnd = []
    for i in range(len(names)):
        b = None
        for e in exps:
            if sum(e) == e[i] and e[i] > 0:
                b = e[i] if b is None else min(b, e[i])
        bnd.append(b if b is not None else 0)
    cnt = 0
    for pt in itertools.product(*[range(b) for b in bnd]):
        if not any(all(pt[i] >= e[i] for i in range(len(names))) for e in exps):
            cnt += 1
    return 0, cnt


def run(lam, var, primes, threads=6, timeout=5400):
    b, polys = S.system(7, S.LAMS[lam])
    names, dh = S.dehomogenise(b, polys, var)
    for p in primes:
        omp, kpp = S.find_roots(p)
        if omp is None or kpp is None:
            print('p=%-12d  NOT SPLIT (skipped)' % p, flush=True)
            continue
        src = S.emit_ff(names, dh, p, omp, kpp)
        assert '(' not in src
        tag = 'MP_r7_%s_%s_p%d' % (lam, var, p)
        f = os.path.join(HERE, 'msolve', tag + '.ms')
        o = os.path.join(HERE, 'msolve', tag + '.out')
        open(f, 'w').write(src)
        t0 = time.time()
        try:
            subprocess.run([S.MSOLVE, '-t', str(threads), '-g', '1',
                            '-f', f, '-o', o], capture_output=True,
                           text=True, timeout=timeout)
        except subprocess.TimeoutExpired:
            print('p=%-12d  TIMEOUT' % p, flush=True)
            continue
        txt = open(o).read() if os.path.exists(o) else ''
        st, mons, n = staircase(txt)
        if st == 'NONUNIT':
            d, deg = dim_and_degree(mons, names)
            print('p=%-12d  %7.1fs  NON-UNIT  #lead=%d  dim=%d  degree=%s'
                  % (p, time.time()-t0, n, d, deg), flush=True)
            print('              staircase: %s' % ','.join(mons), flush=True)
        else:
            print('p=%-12d  %7.1fs  %s' % (p, time.time()-t0, st), flush=True)


if __name__ == '__main__':
    lam, var, n = sys.argv[1], sys.argv[2], int(sys.argv[3])
    start = int(sys.argv[4]) if len(sys.argv) > 4 else 100000
    ps = S.split_primes(start, n)
    print('# lam=%s %s=1 ; split primes: %s' % (lam, var, ps), flush=True)
    run(lam, var, ps, threads=int(os.environ.get('NTH', '6')))
