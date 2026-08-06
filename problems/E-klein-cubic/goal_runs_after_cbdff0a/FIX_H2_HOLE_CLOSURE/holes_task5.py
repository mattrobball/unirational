#!/usr/bin/env python3
"""FIX-H1 TASK 5: the (1,6) cell at line degree n >= 3.

For each admissible (n, lam) (see holes_ld: the cases with T_0 != 0 != T_n; the
others reduce to line degree n-1 by dividing out s or t) and each ORDERED PAIR
of cone lines (T_0, T_n) -- 12 x 12 = 144 pairs, with both scalars normalised
away by (s,t) -> (alpha s, beta t) -- solve the level system

    level l:  sum_{a+b+c=l} Phi(T_a,T_b,T_c) = 0,   l = 1 .. 3n-1

for the intermediate T_1..T_{n-1}, and ask whether any plane-order-1 coordinate
of any T_j can be nonzero (Rabinowitsch: add v*z - 1).

Level 1 says T_1 in ker D_{T_0} and level 3n-1 says T_{n-1} in ker D_{T_n}, so
those two are parametrised by the kernels; the other T_j run over their whole
eigenblock.

MODULAR (F_100057).  Verdicts from this file are FINDINGS.
"""
import itertools
import os
import sys
import time

import holes_ld as LD
import holes_lib as H
import n2c_systems as S

P, OMP, KPP = LD.P, LD.OMP, LD.KPP


def combos(l):
    """ordered triples (a,b,c) with a+b+c=l, 0<=a,b,c<=nmax, as multiset counts"""
    return None


def build_system(C, n, lam, T0, Tn, blocks):
    mus = [LD.mu(lam, n, j) for j in range(n + 1)]
    # bases for the unknown pieces
    bases = {}
    d1, k1 = LD.kernel_dim(C, T0, blocks[mus[1]])
    bases[1] = [_mk(C, k, blocks[mus[1]]) for k in k1]
    if n - 1 != 1:
        dn, kn = LD.kernel_dim(C, Tn, blocks[mus[n - 1]])
        bases[n - 1] = [_mk(C, k, blocks[mus[n - 1]]) for k in kn]
    for j in range(2, n - 1):
        bases[j] = [list(b) for b in blocks[mus[j]]]
    # unknown index layout
    off, names = {}, []
    for j in range(1, n):
        off[j] = len(names)
        names += ['a%d_%d' % (j, i) for i in range(len(bases[j]))]
    N = len(names)
    # vectors participating in Phi
    vecs = {('T', 0): T0, ('T', n): Tn}
    for j in range(1, n):
        for i, b in enumerate(bases[j]):
            vecs[(j, i)] = b
    # Phi cache
    cache = {}

    def phi(u, v, w):
        key = tuple(sorted([u, v, w], key=str))
        if key not in cache:
            cache[key] = C.Phi(vecs[key[0]], vecs[key[1]], vecs[key[2]])
        return cache[key]

    def sym(j):
        """list of (index-key, unknown-index) for T_j; T_0/T_n are constants."""
        if j == 0:
            return [(('T', 0), None)]
        if j == n:
            return [(('T', n), None)]
        return [((j, i), off[j] + i) for i in range(len(bases[j]))]

    polys = []
    for l in range(1, 3 * n):
        acc = {}
        for a in range(0, min(l, n) + 1):
            for b in range(0, min(l - a, n) + 1):
                c = l - a - b
                if c < 0 or c > n:
                    continue
                for (ka, ia) in sym(a):
                    for (kb, ib) in sym(b):
                        for (kc, ic) in sym(c):
                            pv = phi(ka, kb, kc)
                            if not pv:
                                continue
                            e = [0] * N
                            for ix in (ia, ib, ic):
                                if ix is not None:
                                    e[ix] += 1
                            e = tuple(e)
                            for mo, val in pv.items():
                                d = acc.setdefault(mo, {})
                                d[e] = (d.get(e, 0) + val) % P
        for mo, d in acc.items():
            d = {k: v for k, v in d.items() if v}
            if d:
                polys.append(d)
    return names, polys, bases, off, N


def _mk(C, coeffs, basis):
    v = [0] * C.n
    for c, b in zip(coeffs, basis):
        if c:
            for i in range(C.n):
                v[i] = (v[i] + c * b[i]) % P
    return v


def po1_forms(C, bases, off, N, n):
    """linear forms in the unknowns giving each plane-order-1 coordinate of
    each T_j (j = 1..n-1)."""
    out = []
    for j in range(1, n):
        for ci in C.po1:
            f = {}
            for i, b in enumerate(bases[j]):
                if b[ci]:
                    e = [0] * N
                    e[off[j] + i] = 1
                    f[tuple(e)] = b[ci] % P
            if f:
                out.append(('T%d' % j, C.fs.names[ci], f))
    return out


def emit(names, polys, extra=()):
    lines = []
    for q in list(polys) + list(extra):
        terms = []
        for k, v in sorted(q.items()):
            if not v:
                continue
            mon = '*'.join('%s^%d' % (names[i], e) if e > 1 else names[i]
                           for i, e in enumerate(k) if e)
            terms.append('%d%s' % (v % P, '*' + mon if mon else ''))
        if terms:
            lines.append('+'.join(terms))
    src = '%s\n%d\n%s\n' % (','.join(names), P, ',\n'.join(lines))
    return H.assert_paren_free(src)


def run(n, lam, limit=None):
    C = LD.Cone6()
    lines = C.cone_lines()
    mus = [LD.mu(lam, n, j) for j in range(n + 1)]
    if mus[0] == 'one' or mus[-1] == 'one':
        print('n=%d lam=%s : degenerate (reduces to line degree %d)' % (n, lam, n - 1))
        return True
    blocks = {t: C.block(H.LAMS[t]) for t in ('one', 'om', 'om2')}
    L0 = [x for x in lines if x[2] == mus[0]]
    Ln = [x for x in lines if x[2] == mus[-1]]
    allzero = True
    t00 = time.time()
    npairs = 0
    for (B0, br0, _, po0, T0) in L0:
        for (Bn, brn, _, pon, Tn) in Ln:
            npairs += 1
            if limit and npairs > limit:
                break
            names, polys, bases, off, N = build_system(C, n, lam, T0, Tn, blocks)
            forms = po1_forms(C, bases, off, N, n)
            for (tj, cname, f) in forms:
                vn = names + ['zz']
                fz = {}
                for k, v in f.items():
                    fz[tuple(list(k) + [1])] = v
                fz[tuple([0] * (N + 1))] = P - 1
                pz = [{tuple(list(k) + [0]): v for k, v in q.items()}
                      for q in polys]
                tag = 'ld_n%d_%s_%d_%s_%s' % (n, lam, npairs, tj, cname)
                src = emit(vn, pz, [fz])
                rc, dt, txt = H.run_msolve(tag, src, flags=['-g', '1'],
                                           nthreads='2', timeout=600,
                                           subdir='msolve')
                if txt.startswith('<'):
                    print('   %s : msolve ERROR/timeout' % tag, flush=True)
                    allzero = False
                    continue
                if not H.is_unit_ideal(txt):
                    print('   %s : CAN-BE-NONZERO  (T0: B=%d %s, Tn: B=%d %s)'
                          % (tag, B0, br0, Bn, brn), flush=True)
                    allzero = False
    print('n=%d lam=%-4s : %d pairs, %s  (%.1f s)'
          % (n, lam, npairs, 'ALL plane-order-1 coordinates FORCED ZERO'
             if allzero else 'SOME plane-order-1 coordinate CAN BE NONZERO',
             time.time() - t00), flush=True)
    return allzero


if __name__ == '__main__':
    n = int(sys.argv[1])
    lams = sys.argv[2].split(',') if len(sys.argv) > 2 else ['one', 'om', 'om2']
    lim = int(sys.argv[3]) if len(sys.argv) > 3 else None
    ok = True
    for lam in lams:
        ok &= run(n, lam, lim)
    print('TASK5 n=%d : %s' % (n, 'EMPTY (modular finding)' if ok else 'NOT EMPTY'))
