#!/usr/bin/env python3
"""FIX-H1 TASK 6: the four strata of the plane-order-1 locus of the (1,r) cone
(r even), in the (X,Y) coordinates, each reduced by the exact cascade and then
handed to msolve / Macaulay2.

The two sparsest generators of the system are, in every eigenblock (only the
overall K-scalar depends on lam):

        X0 * B6^2 = 0 ,        Y1 * B9^2 = 0 .

`m = 1` means `B6 != 0` or `B9 != 0` (B6, B9 are the two plane-order-1
coordinates: the V^3- and W^3-coefficients of the u_0'-polynomial).  Hence

    {m = 1} = {B6 != 0} u {B9 != 0}
            SUBSET  (A) {B6=1, B9=0} u (B) {B6=1, Y1=0}
                  u (C) {B9=1, B6=0} u (D) {B9=1, X0=0} ,

because on {B6 != 0} the generator Y1 B9^2 = 0 forces B9 = 0 or Y1 = 0, and
symmetrically on {B9 != 0}.  So: the plane-order-1 locus is EMPTY iff all four
strata A,B,C,D are empty.  No saturation is needed anywhere -- each stratum is
an honest ideal.

usage:  holes_strata.py r LAM STRATUM [maxdeg]     (STRATUM in A B C D)
"""
import sys

import holes_lib as H
import holes_reduce as RD
import holes_xy as XY
import n2b_lib as L
import n2c_systems as S

STRATA = {'A': ('B6', 'B9'), 'B': ('B6', 'Y1'),
          'C': ('B9', 'B6'), 'D': ('B9', 'X0')}


def stratum(r, lam, which, maxdeg=4, verbose=True, orbit_reduce=True):
    """(names, polys, trail) for the reduced stratum system."""
    one_var, zero_var = STRATA[which]
    names, polys, b = XY.xy_system(r, lam, orbit_reduce=orbit_reduce)
    # the plane-order-1 coordinates, generic (r = 8: B6,B9 ; r = 10: B10,B14)
    po1 = H.po1_params(b)
    if one_var.startswith('B'):
        one_var = po1[0] if one_var == 'B6' else po1[1]
    if zero_var.startswith('B'):
        zero_var = po1[0] if zero_var == 'B6' else po1[1]
    iz = names.index(zero_var)
    polys = [S.p_setvar(q, iz, H.ZERO) for q in polys]
    polys = [q for q in polys if q]
    polys = [S.p_drop(q, {iz}) for q in polys]
    names = [n for j, n in enumerate(names) if j != iz]
    io = names.index(one_var)
    polys = [S.p_setvar(q, io, H.ONE) for q in polys]
    polys = [q for q in polys if q]
    polys = [S.p_drop(q, {io}) for q in polys]
    names = [n for j, n in enumerate(names) if j != io]
    polys = RD.dedup(polys)
    if verbose:
        print(' stratum %s : %s=1, %s=0 -> %d vars %s, %d gens'
              % (which, one_var, zero_var, len(names), names, len(polys)),
              flush=True)
    if not polys:
        return names, polys, []
    if any(len(q) == 1 and sum(next(iter(q))) == 0 for q in polys):
        # a nonzero constant among the generators: the ideal is (1)
        return names, [{tuple([0]*len(names)): H.ONE}], []
    return RD.eliminate_all(names, polys, verbose=verbose, maxdeg=maxdeg)


def main():
    r = int(sys.argv[1])
    lam = sys.argv[2]
    which = sys.argv[3]
    maxdeg = int(sys.argv[4]) if len(sys.argv) > 4 else 4
    print('=== r=%d lam=%s stratum %s (maxdeg %d) ===' % (r, lam, which, maxdeg))
    names, polys, trail = stratum(r, lam, which, maxdeg)
    if not polys:
        print('   -> NO GENERATORS LEFT: the stratum is a whole affine space '
              '(%d-dim) => POPULATED' % len(names))
        return
    degs = sorted({sum(k) for q in polys for k in q})
    print('   -> %d variables %s' % (len(names), names))
    print('   -> %d generators, degrees %s' % (len(polys), degs))
    for q in sorted(polys, key=len):
        s = RD.polystr(q, names)
        print('      %s' % (s if len(s) < 3000 else s[:3000] + ' ...'))


if __name__ == '__main__':
    main()
