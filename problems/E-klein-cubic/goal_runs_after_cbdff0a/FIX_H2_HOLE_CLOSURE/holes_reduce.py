#!/usr/bin/env python3
"""FIX-H1 TASK 6: exact elimination cascade on a dehomogenised cone system.

Given the cell (m,r) = (1,r) block for a residual-C3 scalar `lam`, dehomogenise
at a plane-order-1 parameter `v` (set v := 1; legitimate because the cone is
homogeneous -- the landing equations are homogeneous cubics in the block
parameters -- so `v` vanishes identically on the cone iff the dehomogenised
ideal is the unit ideal), then repeatedly apply the EXACT elimination

    if some generator has the shape  c*w + (terms free of w),  c a NONZERO
    CONSTANT of K,  substitute  w := -(rest)/c  everywhere.

This is the graph of a regular function, hence an isomorphism of affine
varieties: it changes neither emptiness nor the geometry.  Everything is exact
over K = QQ(om,kp); no prime, no saturation, no guessing.
"""
import sys

import holes_lib as H
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE, ZERO


def dedup(polys):
    seen, out = set(), []
    for q in polys:
        if not q:
            continue
        key = tuple(sorted(q.items()))
        if key in seen:
            continue
        seen.add(key)
        out.append(q)
    return out


def linear_candidates(names, polys):
    """(index, var, poly) for every generator that is c*w + (rest free of w)."""
    n = len(names)
    zero = tuple([0] * n)
    out = []
    for qi, q in enumerate(polys):
        for i in range(n):
            lin, ok = None, True
            for k, v in q.items():
                if k[i] == 0:
                    continue
                if k[i] > 1:
                    ok = False
                    break
                kk = list(k)
                kk[i] = 0
                if tuple(kk) != zero:
                    ok = False
                    break
                lin = v
            if ok and lin is not None:
                out.append((qi, i, names[i]))
    return out


def _expr_deg(q, i):
    """degree of the expression that would replace variable i using poly q."""
    d = 0
    for k in q:
        if k[i] == 0:
            d = max(d, sum(k))
    return d


def eliminate_all(names, polys, verbose=True, protect=(), maxdeg=None):
    """repeat the exact linear elimination until no candidate remains.

    `maxdeg` (optional) refuses substitutions whose replacement expression has
    total degree > maxdeg -- this is what keeps the reduced system small.
    """
    names = list(names)
    polys = dedup(polys)
    trail = []
    while True:
        cands = [c for c in linear_candidates(names, polys)
                 if c[2] not in protect]
        if maxdeg is not None:
            cands = [c for c in cands if _expr_deg(polys[c[0]], c[1]) <= maxdeg]
        if not cands:
            break
        # prefer the substitution of lowest expression degree, then sparsest
        cands.sort(key=lambda c: (_expr_deg(polys[c[0]], c[1]),
                                  len(polys[c[0]]), c[1]))
        qi, i, nm = cands[0]
        q = polys[qi]
        n = len(names)
        zero = tuple([0] * n)
        rest, lin = {}, None
        for k, v in q.items():
            if k[i] == 1:
                lin = v
            else:
                rest[k] = v
        expr = S.p_scal(S.p_scal(rest, S.kinv(lin)), L.kneg(ONE))
        polys = [S.p_substitute(t, i, expr) for t in polys]
        polys = dedup(polys)
        polys = [S.p_drop(t, {i}) for t in polys]
        exprs = S.p_drop(expr, {i}) if expr else {}
        newnames = [x for j, x in enumerate(names) if j != i]
        trail.append((nm, newnames, exprs))
        if verbose:
            print('   eliminate %-4s := %s   (%d generators left, %d vars)'
                  % (nm, polystr(exprs, newnames), len(polys), len(newnames)),
                  flush=True)
        names = newnames
    return names, polys, trail


def polystr(q, names):
    if not q:
        return '0'
    parts = []
    for k, v in sorted(q.items()):
        mon = '*'.join('%s^%d' % (names[i], e) if e > 1 else names[i]
                       for i, e in enumerate(k) if e)
        parts.append('(%s)%s' % (L.kstr(v), '*' + mon if mon else ''))
    return ' + '.join(parts)


def chart(r, lam, var, verbose=True, extra=(), protect=()):
    """the dehomogenised + fully linearly reduced system on {var != 0}."""
    b, polys = H.block_system(r, H.LAMS[lam], orbit_reduce=False)
    names, dh = S.dehomogenise(b, polys, var)
    for e in extra:                      # extra polynomials given as dicts
        dh = dh + [e]
    if verbose:
        print(' chart %s=1 : %d vars %s, %d generators'
              % (var, len(names), names, len(dedup(dh))), flush=True)
    return eliminate_all(names, dedup(dh), verbose=verbose, protect=protect)


def main():
    r = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    lams = sys.argv[2].split(',') if len(sys.argv) > 2 else ['one', 'om', 'om2']
    b0 = L.Block(r, 1, H.LAMS[lams[0]])
    vs = H.po1_params(b0)
    for lam in lams:
        for var in vs:
            print('=== r=%d lam=%s %s=1 ===' % (r, lam, var), flush=True)
            names, polys, trail = chart(r, lam, var)
            print('   -> %d variables %s, %d generators'
                  % (len(names), names, len(polys)), flush=True)
            degs = sorted({sum(k) for q in polys for k in q})
            print('   -> generator degrees present: %s' % degs, flush=True)
            for q in sorted(polys, key=len)[:6]:
                print('      %s' % polystr(q, names), flush=True)
            print(flush=True)


if __name__ == '__main__':
    main()
