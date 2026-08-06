#!/usr/bin/env python3
"""FIX-H2 TASK A: the vertex-adic (U-degree) stratification of the licensed
system, and the incremental sub-ideal probe.

The landing cpoly of a (1,r) tuple, r even, is a polynomial in U = x^2,
V = y^2, W = z^2 of total degree 3r/2; its coefficients ARE the generators.
Grouping them by U-degree is the vertex-adic filtration of FIX-H1 §1.1: the
top-U generators are the two sparse ones X0*B6^2, Y1*B9^2 that produced the
four strata, and the U-degree decreases as more parameters enter.

Since adding generators can only make an ideal larger, the sub-ideal spanned
by the generators of U-degree >= t is contained in the whole ideal, so

    (sub-ideal is the unit ideal)  =>  (the whole ideal is the unit ideal),

and the smallest such t gives the cheapest possible certificate.  This module
finds it.

usage:
  h2_levels.py show   [r]                -- the stratification
  h2_levels.py probe  [r] [lam,...]      -- incremental mod-p probe (FINDING)
  h2_levels.py char0  [r] [lam,...] [t]  -- char-0 battery on the U>=t sub-ideal
"""
import json
import os
import sys

import h2_engines as E
import h2_licence as LI
import holes_lib as H
import holes_reduce as RD
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE, ZERO

LAMS = ('one', 'om', 'om2')


def graded_licensed(r, lam):
    """[(Udeg, monomial, poly)] for the licensed system, orbit_reduce=False.

    Same substitutions as `h2_licence.licensed_system` (X0 = 0, Y1 = 0,
    B6 = 1) but keeping the generator <-> monomial correspondence.
    """
    import holes_xy as XY
    b, polys = H.block_system(r, H.LAMS[lam], orbit_reduce=False)
    # rebuild with the monomial tags: recompute the landing cpoly directly
    cp = L.landing_cpoly(b)
    names = list(b.names)
    # (P,R) -> (X,Y) exactly as holes_xy does
    names2, _, _ = XY.xy_system(r, lam, orbit_reduce=False)
    nP = len(b.bP)
    supP = [frozenset(v) for v in b.bP]
    supR = [frozenset(v) for v in b.bR]
    pair = {}
    for i, s in enumerate(supP):
        for j, t in enumerate(supR):
            if s == t:
                pair[i] = nP + j
                break
    n = len(names)
    det = L.ksub(L.OM, L.OM2)
    di = S.kinv(det)

    def lin(pairs):
        out = {}
        for c, j in pairs:
            e = [0] * n
            e[j] = 1
            out[tuple(e)] = L.kmul(c, di)
        return out

    subs = {}
    for ip, ir in pair.items():
        subs[ip] = lin([(L.OM2, ip), (L.kneg(L.OM), ir)])
        subs[ir] = lin([(L.OM2, ir), (L.kneg(L.OM), ip)])

    def to_xy(q):
        acc = {}
        for k, v in q.items():
            term = {tuple([0] * n): v}
            for j, e in enumerate(k):
                sub = subs.get(j)
                if sub is None:
                    ee = [0] * n
                    ee[j] = e
                    term = S.p_mul(term, {tuple(ee): ONE})
                else:
                    for _ in range(e):
                        term = S.p_mul(term, sub)
            acc = S.p_add(acc, term)
        return acc

    out = []
    for mo, pc in sorted(cp.items()):
        q = to_xy(dict(pc))
        if q:
            out.append((mo[0], mo, q))
    names = names2
    # the licence substitutions
    po1 = H.po1_params(b)
    b6, b9 = po1
    for z in ('X0', 'Y1'):
        i = names.index(z)
        out = [(a, mo, S.p_drop(S.p_setvar(q, i, ZERO), {i})) for a, mo, q in out]
        names = [x for j, x in enumerate(names) if j != i]
    i = names.index(b6)
    out = [(a, mo, S.p_drop(S.p_setvar(q, i, ONE), {i})) for a, mo, q in out]
    names = [x for j, x in enumerate(names) if j != i]
    out = [(a, mo, q) for a, mo, q in out if q]
    return names, out, b, (b6, b9)


def show(r):
    for lam in LAMS:
        names, gr, b, vs = graded_licensed(r, lam)
        print('=== r=%d lam=%s : %d vars %s, %d graded generators ==='
              % (r, lam, len(names), names, len(gr)))
        bylev = {}
        for a, mo, q in gr:
            bylev.setdefault(a, []).append((mo, q))
        for a in sorted(bylev, reverse=True):
            terms = sum(len(q) for _, q in bylev[a])
            vsu = sorted({names[i] for _, q in bylev[a] for k in q
                          for i, e in enumerate(k) if e})
            print('  U-degree %2d : %2d gens, %4d terms, vars %s'
                  % (a, len(bylev[a]), terms, vsu))
            if a >= 8:
                for mo, q in bylev[a]:
                    s = RD.polystr(q, names)
                    print('      %s : %s' % (str(mo), s if len(s) < 220
                                             else s[:220] + ' ...'))
        print(flush=True)


def subideal(r, lam, t):
    names, gr, b, vs = graded_licensed(r, lam)
    polys = RD.dedup([q for a, mo, q in gr if a >= t])
    return names, polys


def probe(r, lams, tmax=1800):
    print('=== incremental sub-ideal probe (mod p -- a FINDING) ===',
          flush=True)
    for lam in lams:
        names, gr, b, vs = graded_licensed(r, lam)
        levels = sorted({a for a, _, _ in gr}, reverse=True)
        for t in levels:
            names_, polys = subideal(r, lam, t)
            v, dt, info = E.ff('lev_r%d_%s_t%d' % (r, lam, t), names_, polys,
                               timeout=tmax, nthreads='4')
            print('  r=%d lam=%-4s U>=%2d : %2d gens -> %s  (%.1f s)'
                  % (r, lam, t, len(polys),
                     'UNIT' if v is True else
                     ('NONUNIT' if v is False else 'ERR/NOT-DECIDED'), dt),
                  flush=True)
            if v is True:
                print('     => the U>=%d sub-ideal ALREADY certifies emptiness '
                      '(mod p).  char-0 next.' % t, flush=True)
                break


def char0(r, lams, t):
    res = {}
    for lam in lams:
        names, polys = subideal(r, lam, t)
        tag = 'lev_r%d_%s_t%d' % (r, lam, t)
        print('  --- r=%d lam=%s U>=%d : %d vars, %d gens, degrees %s'
              % (r, lam, t, len(names), len(polys),
                 sorted({sum(k) for q in polys for k in q})), flush=True)
        vq, dtq, iq = E.qq(tag, names, polys, timeout=3600)
        print('      msolve-qq = %-5s (%.1f s) %s'
              % (vq, dtq, '' if vq is not None else iq[:160]), flush=True)
        vm, dtm, im = E.m2(tag, names, polys, timeout=3600)
        print('      Macaulay2 = %-5s (%.1f s) %s'
              % (vm, dtm, '' if vm is not None else im[:160]), flush=True)
        votes = [v for v in (vq, vm) if v in (True, False)]
        res[lam] = {'t': t, 'qq': vq, 'm2': vm,
                    'verdict': 'EMPTY' if len(votes) == 2 and all(votes)
                    else ('NONEMPTY' if any(v is False for v in votes)
                          else 'NOT-DECIDED')}
        print('      => %s' % res[lam]['verdict'], flush=True)
    p = os.path.join(H.HERE, 'payloads', 'taskA_levels_r%d.json' % r)
    old = json.load(open(p)) if os.path.exists(p) else {}
    old.update({k: v for k, v in res.items()})
    json.dump(old, open(p, 'w'), indent=1, sort_keys=True)
    print('LEVELS r=%d: %s' % (r, {k: v['verdict'] for k, v in old.items()}),
          flush=True)


if __name__ == '__main__':
    what = sys.argv[1]
    r = int(sys.argv[2]) if len(sys.argv) > 2 else 8
    lams = tuple(sys.argv[3].split(',')) if len(sys.argv) > 3 else LAMS
    if what == 'show':
        show(r)
    elif what == 'probe':
        probe(r, lams)
    elif what == 'char0':
        char0(r, lams, int(sys.argv[4]))
