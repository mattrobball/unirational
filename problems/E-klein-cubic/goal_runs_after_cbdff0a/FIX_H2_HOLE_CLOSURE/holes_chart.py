#!/usr/bin/env python3
"""FIX-H1 TASK 6: the reduced plane-order-1 chart of the (1,r) cone, in the
(X,Y) coordinates of `holes_xy`, with the exact elimination cascade capped so
the degrees stay small.

usage:  holes_chart.py r LAM VAR [maxdeg]

Everything here is an EXACT operation over K = QQ(om,kp):
  * the dehomogenisation `VAR := 1` (legitimate: the cone is homogeneous),
  * the linear change (P,R) -> (X,Y),
  * each elimination `w := -rest/c` with `c` a nonzero constant of K
    (the graph of a regular function -- a variety isomorphism).
So the reduced system's emptiness is EQUIVALENT to the emptiness of the
plane-order-1 locus of the cone in that eigenblock.
"""
import sys

import holes_lib as H
import holes_reduce as RD
import holes_xy as XY
import n2b_lib as L
import n2c_systems as S


def chart(r, lam, var, maxdeg=3, verbose=True, orbit_reduce=True):
    names, polys, b = XY.xy_system(r, lam, orbit_reduce=orbit_reduce)
    i = names.index(var)
    dh = [S.p_setvar(q, i, H.ONE) for q in polys]
    dh = [q for q in dh if q]
    dh = [S.p_drop(q, {i}) for q in dh]
    names = [n for j, n in enumerate(names) if j != i]
    dh = RD.dedup(dh)
    if verbose:
        print(' chart %s=1 : %d vars %s, %d generators'
              % (var, len(names), names, len(dh)), flush=True)
    return RD.eliminate_all(names, dh, verbose=verbose, maxdeg=maxdeg)


def main():
    r = int(sys.argv[1])
    lam = sys.argv[2]
    var = sys.argv[3]
    maxdeg = int(sys.argv[4]) if len(sys.argv) > 4 else 3
    print('=== r=%d lam=%s %s=1  (maxdeg %d) ===' % (r, lam, var, maxdeg))
    names, polys, trail = chart(r, lam, var, maxdeg)
    degs = sorted({sum(k) for q in polys for k in q})
    print('   -> %d variables %s' % (len(names), names))
    print('   -> %d generators, degrees %s' % (len(polys), degs))
    for q in sorted(polys, key=len):
        print('      %s' % RD.polystr(q, names))


if __name__ == '__main__':
    main()
