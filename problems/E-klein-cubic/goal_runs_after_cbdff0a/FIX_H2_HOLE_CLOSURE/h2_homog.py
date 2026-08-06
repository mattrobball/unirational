#!/usr/bin/env python3
"""FIX-H2: the HOMOGENEOUS form of the two cases, and its Macaulay2 decision.

Do not dehomogenise.  In the (X,Y) coordinates the cone's 28 landing equations
are homogeneous cubics in the 18 block parameters, and every extra condition
the licence and the face supply is a LINEAR form:

   X0 = 0, Y1 = 0     (licence: the two sparse generators + stratum A)
   Y0 = 0             (case Z)      and then X1 = X2 = Y2 = 0  (the face, (D))

so the whole ideal stays homogeneous.  Then, for f a product of parameters the
licence lets us invert,

        V(I) n {f != 0} = empty     <=>     saturate(I, f) = (1),

and Macaulay2's homogeneous Groebner engine is far faster than the
inhomogeneous one obtained by setting B6 = 1.

   CASE Z :  I = (cubics, X0, Y1, Y0, X1, X2, Y2),  saturate by  B6
   CASE N :  I = (cubics, X0, Y1),                  saturate by  B6*Y0

usage:  h2_homog.py [r] [lam,...] [--timeout=SEC]
"""
import json, os, sys, time
import h2_engines as E
import holes_lib as H
import holes_xy as XY

LAMS = ('one', 'om', 'om2')
ZERO_Z = ('X0', 'Y1', 'Y0', 'X1', 'X2', 'Y2')
ZERO_N = ('X0', 'Y1')

def system(r, lam, zeros):
    import n2c_systems as S
    from n2b_lib import ZERO
    names, polys, b = XY.xy_system(r, lam)
    lin = []
    for z in zeros:
        i = names.index(z)
        e = [0]*len(names); e[i] = 1
        lin.append({tuple(e): H.ONE})
    return names, list(polys) + lin, H.po1_params(b)

def main():
    r = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    lams, tmo = LAMS, 2400
    for a in sys.argv[2:]:
        if a.startswith('--timeout='): tmo = int(a.split('=')[1])
        elif not a.startswith('-'): lams = tuple(a.split(','))
    res = {}
    print('=== FIX-H2 homogeneous decision, r=%d ===' % r, flush=True)
    for lam in lams:
        for case, zeros, sat in (('Z', ZERO_Z, '{B6}'), ('N', ZERO_N, '{B6,Y0}')):
            names, polys, po1 = system(r, lam, zeros)
            s = sat.replace('B6', po1[0])
            tag = 'h2h_r%d_%s_%s' % (r, lam, case)
            v, dt, info = E.m2h(tag, names, polys, s, timeout=tmo)
            print('  r=%d lam=%-4s CASE %s : %d vars, %d gens, saturate by %s '
                  '-> M2-homog = %-5s (%.0f s) %s'
                  % (r, lam, case, len(names), len(polys), s, v, dt,
                     '' if v is not None else info[:150]), flush=True)
            res['%s_%s' % (lam, case)] = ('EMPTY' if v is True else
                                          ('NONEMPTY' if v is False else 'NOT-DECIDED'))
    p = os.path.join(H.HERE, 'payloads', 'taskA_homog_r%d.json' % r)
    old = json.load(open(p)) if os.path.exists(p) else {}
    old.update(res); json.dump(old, open(p, 'w'), indent=1, sort_keys=True)
    print('\nFIX-H2 homogeneous r=%d: %s' % (r, old), flush=True)

if __name__ == '__main__':
    main()
