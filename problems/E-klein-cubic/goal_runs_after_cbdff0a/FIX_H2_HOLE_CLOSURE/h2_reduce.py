#!/usr/bin/env python3
"""FIX-H2: the LICENSED elimination cascade.

FIX-H1's cascade (`holes_reduce.eliminate_all`) may only eliminate a variable
whose coefficient is a nonzero CONSTANT of K.  The both-nonzero licence buys a
strictly stronger rule, and it is what unlocks the residual region.

On the residual region both plane-order-1 coefficients are nonzero; after
dehomogenising B6 = 1 the surviving one, B9, is INVERTIBLE (the locus
{B6 = 1, B9 = 0} is stratum A, char-0 certified EMPTY by FIX-H1).  So we may
work in the localisation

        R  =  K[vars][1/B9]  =  K[vars, w] / (B9*w - 1)

and use

  R3+  if a generator has the shape  c * B9^a * w^b * v  +  (terms free of v),
       with c in K^* -- i.e. the coefficient of v is a UNIT of R -- then
       substitute  v := -(1/c) * B9^b * w^a * (rest).

This is still the graph of a regular function on R, hence an isomorphism of
affine varieties over the open set {B9 != 0}; it changes neither emptiness nor
the geometry there.  And it is exactly what the vertex-adic structure wants:
the level-l landing equations are LINEAR in the fresh (level l-2) a'- and
b'-slot parameters with coefficient c1^2 = B9^2 or c2^2 = B6^2 = 1, both units,
so every fresh X/Y parameter can be eliminated mechanically, level by level,
until the a',b' slots run out of freedom.

`V(I) = empty` on {B9 != 0} is what we need, and by the licence that is
equivalent to the emptiness of the whole plane-order-1 locus.
"""
import sys

import holes_lib as H
import holes_reduce as RD
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE, ZERO


class Loc:
    """the localisation K[names, w]/(B9*w - 1); `i9` is the index of B9."""

    def __init__(self, names, i9):
        self.names = list(names) + ['w']
        self.i9 = i9
        self.iw = len(names)
        self.n = len(self.names)

    def lift(self, q):
        return {tuple(list(k) + [0]): v for k, v in q.items()}

    def norm(self, q):
        """reduce modulo B9*w = 1."""
        out = {}
        for k, v in q.items():
            k = list(k)
            t = min(k[self.i9], k[self.iw])
            if t:
                k[self.i9] -= t
                k[self.iw] -= t
            k = tuple(k)
            nv = L.kadd(out.get(k, ZERO), v)
            if L.kiszero(nv):
                out.pop(k, None)
            else:
                out[k] = nv
        return out

    def unit_of(self, k):
        """if the exponent vector k is a monomial in B9, w ONLY, return
        (a, b) with monomial = B9^a w^b; else None."""
        a = b = 0
        for i, e in enumerate(k):
            if e == 0:
                continue
            if i == self.i9:
                a = e
            elif i == self.iw:
                b = e
            else:
                return None
        return (a, b)

    def inv_unit(self, c, a, b):
        """the inverse of c*B9^a*w^b as a polynomial: (1/c)*B9^b*w^a."""
        e = [0] * self.n
        e[self.i9] = b
        e[self.iw] = a
        return {tuple(e): S.kinv(c)}

    def lin_candidates(self, polys, protect=()):
        """(qi, i, unit-inverse) for generators c*U*v + (rest free of v),
        U a unit monomial in B9,w and v a genuine variable."""
        out = []
        for qi, q in enumerate(polys):
            for i in range(self.n):
                if i in (self.i9, self.iw):
                    continue
                if self.names[i] in protect:
                    continue
                lead, ok = None, True
                for k, v in q.items():
                    if k[i] == 0:
                        continue
                    if k[i] > 1 or lead is not None:
                        ok = False
                        break
                    kk = list(k)
                    kk[i] = 0
                    u = self.unit_of(tuple(kk))
                    if u is None:
                        ok = False
                        break
                    lead = (v, u[0], u[1])
                if ok and lead is not None:
                    out.append((qi, i, lead))
        return out

    def deg_of_expr(self, q, i):
        return max([sum(k) for k in q if k[i] == 0] or [0])

    def substitute(self, polys, i, expr):
        out = []
        for q in polys:
            r = self.norm(S.p_substitute(q, i, expr))
            if r:
                out.append(r)
        return RD.dedup(out)


def licensed_reduce(names, polys, i9, maxdeg=6, verbose=True, protect=(),
                    maxsteps=200):
    """the R3+ cascade.  Returns (Loc, names_out, polys_out, trail)."""
    loc = Loc(names, i9)
    polys = [loc.norm(loc.lift(q)) for q in polys]
    polys = RD.dedup(polys)
    trail = []
    live = list(range(loc.n))                # index -> alive?
    dead = set()
    for _ in range(maxsteps):
        for q in polys:
            if len(q) == 1 and sum(next(iter(q))) == 0:
                if verbose:
                    print('   NONZERO CONSTANT among the generators '
                          '=> the localised ideal is (1) => EMPTY on {B9!=0}',
                          flush=True)
                return loc, names, [{tuple([0] * loc.n): ONE}], trail
        cands = [c for c in loc.lin_candidates(polys, protect)
                 if c[1] not in dead]
        cands = [c for c in cands
                 if loc.deg_of_expr(polys[c[0]], c[1]) <= maxdeg]
        if not cands:
            break
        cands.sort(key=lambda c: (loc.deg_of_expr(polys[c[0]], c[1]),
                                  len(polys[c[0]]), c[1]))
        qi, i, (c, a, b) = cands[0]
        q = polys[qi]
        rest = {k: v for k, v in q.items() if k[i] == 0}
        inv = loc.inv_unit(c, a, b)
        expr = loc.norm(S.p_scal(S.p_mul(rest, inv), L.kneg(ONE)))
        polys = loc.substitute(polys, i, expr)
        dead.add(i)
        trail.append((loc.names[i], expr))
        if verbose:
            print('   R3+ eliminate %-4s (unit coeff B9^%d w^%d) -> %d gens, '
                  'deg %s' % (loc.names[i], a, b, len(polys),
                              sorted({sum(k) for t in polys for k in t})),
                  flush=True)
    keep = [i for i in range(loc.n) if i not in dead]
    idx = {i: j for j, i in enumerate(keep)}
    out = []
    for q in polys:
        r = {}
        for k, v in q.items():
            kk = [0] * len(keep)
            for i, e in enumerate(k):
                if e and i in idx:
                    kk[idx[i]] = e
                elif e:
                    raise AssertionError('dead variable survived')
            r[tuple(kk)] = v
        out.append(r)
    return loc, [loc.names[i] for i in keep], RD.dedup(out), trail
