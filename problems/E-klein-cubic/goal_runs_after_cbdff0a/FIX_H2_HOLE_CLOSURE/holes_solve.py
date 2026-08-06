#!/usr/bin/env python3
"""FIX-H1: an EXACT branch-and-reduce solver over K = QQ(om,kp).

Every step is a rigorous characteristic-zero operation on the affine variety:

  (R1) drop duplicate / zero generators;
  (R2) if a generator is a NONZERO CONSTANT of K, the branch is EMPTY;
  (R3) if a generator is  c*w + (rest free of w)  with c a nonzero constant of
       K, substitute  w := -rest/c  (graph of a regular function: an
       isomorphism of affine varieties);
  (R4) if a generator factors as  m * h  with m a nonconstant monomial, then
       V = (V | v = 0 for some variable v of m)  u  (V | h = 0):
       branch.  A monomial generator (h a constant) branches on its variables
       only.  This is an exact decomposition -- the union of the branches is
       the original variety.

A branch is EMPTY iff its leaf system has no solution; the whole variety is
EMPTY iff every leaf is.  Leaves are handed to msolve / Macaulay2.

No prime, no saturation, no numerics anywhere in this file.
"""
import sys

import holes_lib as H
import holes_reduce as RD
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE, ZERO


def is_const(q, n):
    return len(q) == 1 and sum(next(iter(q))) == 0


def common_monomial(q):
    """the gcd monomial of all terms of q (exponent tuple)."""
    ks = list(q)
    g = list(ks[0])
    for k in ks[1:]:
        for i in range(len(g)):
            g[i] = min(g[i], k[i])
        if not any(g):
            break
    return tuple(g)


def divide_monomial(q, g):
    return {tuple(a - b for a, b in zip(k, g)): v for k, v in q.items()}


def reduce_branch(names, polys, maxdeg=6, verbose=False, depth=0, path=''):
    """apply (R1)-(R3) until stuck; return ('EMPTY',) or (names, polys)."""
    names = list(names)
    polys = RD.dedup(polys)
    n = len(names)
    while True:
        polys = RD.dedup(polys)
        n = len(names)
        for q in polys:
            if is_const(q, n):
                return None, None            # EMPTY
        cands = RD.linear_candidates(names, polys)
        cands = [c for c in cands if RD._expr_deg(polys[c[0]], c[1]) <= maxdeg]
        if not cands:
            return names, polys
        cands.sort(key=lambda c: (RD._expr_deg(polys[c[0]], c[1]),
                                  len(polys[c[0]]), c[1]))
        qi, i, nm = cands[0]
        q = polys[qi]
        rest, lin = {}, None
        for k, v in q.items():
            if k[i] == 1:
                lin = v
            else:
                rest[k] = v
        expr = S.p_scal(S.p_scal(rest, S.kinv(lin)), L.kneg(ONE))
        polys = [S.p_substitute(t, i, expr) for t in polys]
        polys = [t for t in polys if t]
        polys = [S.p_drop(t, {i}) for t in polys]
        names = [x for j, x in enumerate(names) if j != i]
        if verbose:
            print('%s  [%s] eliminate %s' % ('  ' * depth, path, nm), flush=True)


def setzero(names, polys, i):
    polys = [S.p_setvar(q, i, ZERO) for q in polys]
    polys = [q for q in polys if q]
    polys = [S.p_drop(q, {i}) for q in polys]
    return [x for j, x in enumerate(names) if j != i], polys


def solve(names, polys, maxdeg=6, maxleaves=400, verbose=True, path='',
          leaves=None, seen=None):
    """returns the list of irreducible-ish leaves (names, polys, path)."""
    if leaves is None:
        leaves = []
    names, polys = reduce_branch(names, polys, maxdeg=maxdeg)
    if names is None:
        if verbose:
            print('   branch %-24s EMPTY (1 in the ideal)' % path, flush=True)
        return leaves
    if not polys:
        leaves.append((names, polys, path))
        if verbose:
            print('   branch %-24s NO EQUATIONS -> affine space, POPULATED'
                  % path, flush=True)
        return leaves
    # (R4): a factorable generator
    best = None
    for qi, q in enumerate(polys):
        g = common_monomial(q)
        if not any(g):
            continue
        vs = [i for i, e in enumerate(g) if e]
        h = divide_monomial(q, g)
        cost = len(vs) + (0 if is_const(h, len(names)) else 1)
        if best is None or cost < best[0]:
            best = (cost, qi, vs, h)
    if best is None:
        leaves.append((names, polys, path))
        if verbose:
            print('   branch %-24s LEAF: %d vars %s, %d gens'
                  % (path, len(names), names, len(polys)), flush=True)
        return leaves
    _, qi, vs, h = best
    rest = polys[:qi] + polys[qi + 1:]
    for i in vs:
        nm = names[i]
        nn, pp = setzero(names, rest, i)
        solve(nn, pp, maxdeg, maxleaves, verbose, path + '/%s=0' % nm, leaves)
        if len(leaves) > maxleaves:
            raise RuntimeError('too many leaves')
    if not is_const(h, len(names)):
        solve(names, rest + [h], maxdeg, maxleaves, verbose,
              path + '/[cofactor]', leaves)
    return leaves


if __name__ == '__main__':
    import holes_strata as ST
    r = int(sys.argv[1])
    lam = sys.argv[2]
    which = sys.argv[3]
    names, polys, _ = ST.stratum(r, lam, which, maxdeg=4, verbose=False)
    print('r=%d lam=%s stratum %s : %d vars, %d gens'
          % (r, lam, which, len(names), len(polys)))
    leaves = solve(names, polys)
    print('LEAVES: %d' % len(leaves))
    for nm, pl, path in leaves:
        print('  %-30s vars=%d gens=%d' % (path, len(nm), len(pl)))
