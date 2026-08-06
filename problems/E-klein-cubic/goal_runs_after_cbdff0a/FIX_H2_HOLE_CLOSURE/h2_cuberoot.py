#!/usr/bin/env python3
"""FIX-H2 TASK A, CASE N: the cube-root cover that splits the real obstruction.

WHAT ACTUALLY BLOCKS CASE N.  Two of the seven closed U-exponent-0 face
generators are, in every eigenblock (only the K-scalars differ),

    (0,9,3):   a*Y0^3 + c*X2 = 0
    (0,3,9):   d*X2*B9^2 + e*X1^3 = 0

with a,c,d,e nonzero constants of K.  Eliminating X2 gives, exactly and in all
three eigenblocks,

    X1^3  =  -Y0^3 * B9^2 .                                              (C)

On CASE N both Y0 and B9 are nonzero, so (C) says X1/Y0 is a cube root of
-B9^2.  Over the function field K(Y0,B9) the cubic T^3 + Y0^3 B9^2 is
IRREDUCIBLE (B9^2 is not a cube there), which is exactly why FIX-H1's exact
branch-and-reduce -- whose only splitting rules are monomial factors and
factorisation over K -- cannot break CASE N, and why its leaf stays at 11
variables.  (This is the degree-3 obstruction the director's hint predicted,
but it comes from the FACE, not from the pure-x^r coefficient, which is
vacuous on the m=1 cell.)

THE COVER.  Adjoin a cube root: t with t^3 = B9.  Over an algebraically closed
field the map t -> t^3 is onto {B9 != 0}, so

    CASE N is empty  <=>  its pullback under B9 = t^3 is empty.

And in the pullback (C) becomes X1^3 + (Y0 t^2)^3 = 0, which SPLITS:

    X1^3 + (Y0 t^2)^3  =  (X1 + Y0 t^2)(X1 + om Y0 t^2)(X1 + om^2 Y0 t^2),

so the pullback is covered by three branches, on each of which X1 is a LINEAR
function of Y0 and t and can be eliminated outright.  Each branch is then
handed back to the exact cascade and to the engines.

usage:  h2_cuberoot.py [r] [lam,...] [--timeout=SEC]
"""
import json, os, sys, time
import h2_engines as E
import h2_face as F
import holes_reduce as RD
import holes_lib as H
import holes_track as TR
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE, OM, OM2

def branches(r, lam):
    """the three cube-root branches of CASE N, as tracked Branch objects."""
    names, fpolys, allp, b, vs = F.face(r, lam)
    out = []
    for k, w in enumerate((ONE, OM, OM2)):
        nm = list(names) + ['t']
        n = len(nm)
        lift = lambda q: {tuple(list(kk) + [0]): v for kk, v in q.items()}
        i9, i1, i0, it = nm.index('B9'), nm.index('X1'), nm.index('Y0'), n - 1
        e3 = [0]*n; e3[it] = 3
        pol = [lift(q) for q in allp]
        # B9 := t^3   (the cube-root cover)
        pol = [S.p_substitute(q, i9, {tuple(e3): ONE}) for q in pol]
        pol = [q for q in pol if q]
        # X1 := -om^k * Y0 * t^2   (one of the three factors of (C))
        e = [0]*n; e[i0] = 1; e[it] = 2
        pol = [S.p_substitute(q, i1, {tuple(e): L.kneg(w)}) for q in pol]
        pol = [q for q in pol if q]
        keep = [j for j in range(n) if j not in (i9, i1)]
        idx = {j: p for p, j in enumerate(keep)}
        out2 = []
        for q in pol:
            rr = {}
            for kk, v in q.items():
                ee = [0]*len(keep)
                ok = True
                for j, x in enumerate(kk):
                    if x and j in idx: ee[idx[j]] = x
                    elif x: ok = False; break
                if ok:
                    rr[tuple(ee)] = L.kadd(rr.get(tuple(ee), L.ZERO), v)
            rr = {a2: c2 for a2, c2 in rr.items() if not L.kiszero(c2)}
            if rr: out2.append(rr)
        nm2 = [nm[j] for j in keep]
        # CASE N also has Y0 != 0 and t != 0 (t^3 = B9 != 0): Rabinowitsch
        for var in ('Y0', 't'):
            j = nm2.index(var); m = len(nm2)
            ee = [0]*(m+1); ee[j] = 1; ee[m] = 1
            out2 = [{tuple(list(a2)+[0]): c2 for a2, c2 in q.items()} for q in out2]
            out2.append({tuple(ee): ONE, tuple([0]*(m+1)): L.kneg(ONE)})
            nm2 = nm2 + ['inv%s' % var]
        out.append(('k%d' % k, nm2, RD.dedup(out2)))
    return out

def main():
    r = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    lams = ('one','om','om2'); tmo = 1800
    for a in sys.argv[2:]:
        if a.startswith('--timeout='): tmo = int(a.split('=')[1])
        elif not a.startswith('-'): lams = tuple(a.split(','))
    res = {}
    for lam in lams:
        ok = True
        for tag, nm, pl in branches(r, lam):
            t0 = time.time()
            br = TR.Branch(list(nm), [dict(q) for q in pl], {x: {} for x in nm}, '')
            leaves = TR.solve(br)
            print('r=%d lam=%-4s branch %s : %d vars -> %d leaves %s (%.1f s)'
                  % (r, lam, tag, len(nm), len(leaves),
                     sorted((len(s.names), len(s.polys)) for s in leaves),
                     time.time()-t0), flush=True)
            for li, s in enumerate(leaves):
                t = 'h2c_r%d_%s_%s_%d' % (r, lam, tag, li)
                if not s.polys:
                    print('   %s NO EQUATIONS -> POPULATED' % t, flush=True); ok = False; continue
                v, dt, i = E.qq(t, s.names, s.polys, timeout=tmo)
                v2, dt2, i2 = (None, 0, '')
                if v is True:
                    v2, dt2, i2 = E.m2v(t, s.names, s.polys, timeout=tmo)
                good = (v is True) and (v2 is True)
                ok = ok and good
                print('   %s vars=%d gens=%d deg<=%d | qq=%-5s(%.0fs) M2v=%-5s(%.0fs) | %s'
                      % (t, len(s.names), len(s.polys),
                         max(sum(k) for q in s.polys for k in q), v, dt, v2, dt2,
                         'EMPTY' if good else ('EMPTY-by-msolve-only' if v is True else 'NOT CERTIFIED')),
                      flush=True)
        res[lam] = 'EMPTY' if ok else 'NOT-DECIDED'
        print(' => r=%d lam=%s CASE N (cube-root cover): %s' % (r, lam, res[lam]), flush=True)
    p = os.path.join(H.HERE, 'payloads', 'taskA_cuberoot_r%d.json' % r)
    old = json.load(open(p)) if os.path.exists(p) else {}
    old.update(res); json.dump(old, open(p,'w'), indent=1, sort_keys=True)
    print('\nFIX-H2 CASE N cube-root cover r=%d: %s' % (r, old), flush=True)

if __name__ == '__main__':
    main()
