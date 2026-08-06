#!/usr/bin/env python3
"""FIX-H2 TASK A: the BOTH-NONZERO licence and the licensed system.

THE LICENCE (a reduction conditional on facts FIX-H1 certified in char 0).

FIX-H1 certified in characteristic zero, for every eigenblock lam:

    (A-cert)  stratum A = V(cone) n {B6 = 1, B9 = 0}  is EMPTY;
    (C-cert)  stratum C = V(cone) n {B9 = 1, B6 = 0}  is EMPTY.

(`B6`, `B9` are the two plane-order-1 parameters at r = 8; at general even r
they are `po1[0]`, `po1[1]`.)  The cone is homogeneous (the landing equations
are homogeneous cubics in the block parameters), so `{B6 != 0}` meets the cone
iff `{B6 = 1}` does, and likewise for B9.  The two sparse top-U generators are

    X0 * B6^2 = 0 ,      Y1 * B9^2 = 0 .

Consequences, in order.

 1. On the chart {B6 = 1}:  X0 * 1 = 0 forces  X0 = 0  outright.
 2. On the chart {B6 = 1}:  Y1 * B9^2 = 0 forces  Y1 = 0  or  B9 = 0.  The
    second alternative is exactly stratum A, EMPTY by (A-cert).  Hence
        V(cone) n {B6 = 1}  =  V(cone) n {B6 = 1, X0 = 0, Y1 = 0} ,
    i.e. the two linear equations X0 = 0 AND Y1 = 0 may be adjoined to the
    B6-chart without losing any point.  `Y1 = 0` is the new one: it is NOT a
    consequence of the chart alone, only of the chart together with (A-cert).
 3. Symmetrically on {B9 = 1}: Y1 = 0 outright, and X0 = 0 by (C-cert).
 4. On {B9 = 1} the locus splits as {B6 = 0} u {B6 != 0}; the first is stratum
    C, EMPTY by (C-cert); the second rescales (single overall scaling, all
    block parameters of weight 1) into the chart {B6 = 1}.  Hence

        the plane-order-1 locus of the (1,r) cone in block lam is NONEMPTY
        <=>  V( cone , B6 - 1 , X0 , Y1 )  is NONEMPTY.                  (L)

    In particular the three D-chart hard leaves need NO computation of their
    own: they are empty as soon as the three B-chart ones are.

This module builds the left-hand side of (L) -- the LICENSED SYSTEM -- and
also the Rabinowitsch variant with B9*w = 1 adjoined (which cuts the same set,
since V(cone) n {B6=1, B9=0} is empty by (A-cert), but presents it saturated).

usage:  h2_licence.py [r]        -- report sizes and check the licence inputs
"""
import sys

import holes_lib as H
import holes_reduce as RD
import holes_xy as XY
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE, ZERO


def licensed_system(r, lam, rabin=False, orbit_reduce=True):
    """(names, polys) for  V(cone, B6-1, X0, Y1)  in the (X,Y) coordinates.

    Returns the system with B6 substituted by 1 and X0, Y1 substituted by 0,
    so the ambient is the affine space on the remaining block coordinates.
    If `rabin`, a slack variable `w` and the generator `B9*w - 1` are added.
    """
    names, polys, b = XY.xy_system(r, lam, orbit_reduce=orbit_reduce)
    po1 = H.po1_params(b)                    # r=8: ['B6','B9']
    b6, b9 = po1
    # 1. the two forced-zero coordinates
    for z in ('X0', 'Y1'):
        i = names.index(z)
        polys = [S.p_setvar(q, i, ZERO) for q in polys]
        polys = [q for q in polys if q]
        polys = [S.p_drop(q, {i}) for q in polys]
        names = [n for j, n in enumerate(names) if j != i]
    # 2. dehomogenise at B6
    i = names.index(b6)
    polys = [S.p_setvar(q, i, ONE) for q in polys]
    polys = [q for q in polys if q]
    polys = [S.p_drop(q, {i}) for q in polys]
    names = [n for j, n in enumerate(names) if j != i]
    polys = RD.dedup(polys)
    if rabin:
        i9 = names.index(b9)
        n = len(names)
        e9 = [0] * (n + 1)
        e9[i9] = 1
        e9[n] = 1
        z = [0] * (n + 1)
        polys = [{tuple(list(k) + [0]): v for k, v in q.items()} for q in polys]
        polys.append({tuple(e9): ONE, tuple(z): L.kneg(ONE)})
        names = names + ['w']
    return names, polys, b, (b6, b9)


def report(r):
    print('=== FIX-H2 licensed system, r = %d ===' % r)
    for lam in ('one', 'om', 'om2'):
        names0, polys0, b = XY.xy_system(r, lam)
        po1 = H.po1_params(b)
        print('block lam=%-4s: %d params %s' % (lam, len(names0), names0))
        print('   %d generators, degrees %s, plane-order-1 params %s'
              % (len(polys0), sorted({sum(k) for q in polys0 for k in q}), po1))
        names, polys, b, vs = licensed_system(r, lam)
        degs = sorted({sum(k) for q in polys for k in q})
        print('   LICENSED (%s=1, X0=0, Y1=0): %d vars %s, %d gens, degrees %s'
              % (vs[0], len(names), names, len(polys), degs))
        # how far the plain linear cascade takes it, at several degree caps
        for md in (1, 2, 3):
            nm, pl, _ = RD.eliminate_all(names, [dict(q) for q in polys],
                                         verbose=False, maxdeg=md)
            print('      maxdeg=%d -> %d vars, %d gens, degrees %s'
                  % (md, len(nm), len(pl), sorted({sum(k) for q in pl
                                                   for k in q})))
        print(flush=True)


if __name__ == '__main__':
    report(int(sys.argv[1]) if len(sys.argv) > 1 else 8)
