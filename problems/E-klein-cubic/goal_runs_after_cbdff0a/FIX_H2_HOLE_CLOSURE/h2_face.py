#!/usr/bin/env python3
"""FIX-H2 TASK A: the CLOSED U-EXPONENT-0 FACE, and the face-driven solver.

This is the structure FIX-H1 did not use.  FIX-H1 exploited only the *leading*
(top-U) part of the plane-adic filtration -- the three coefficients of the top
U-degree, which give the two sparse generators X0*B6^2, Y1*B9^2 and hence the
four strata.  But the OTHER end of the filtration is just as special, and much
bigger:

    the coefficient of U^0 V^b W^c in the landing polynomial involves ONLY the
    U-degree-0 parts of the components,

because every term of

    F = kp P^3 + km R^3 + (P+R) VW B0^2 + (om P+om^2 R) WU B1^2
                        + (om^2 P+om R) UV B2^2 + UVW B0 B1 B2

that mixes the slots carries an EXPLICIT factor U (the B1-, B2- and
B0B1B2-terms), so it cannot contribute at U-exponent 0.  What survives is

    kp P_0^3 + km R_0^3 + (P_0+R_0) VW (B0)_0^2  =  0                    (F0)

with P_0 = P|_{U=0}, R_0 = R|_{U=0}, (B0)_0 = B0|_{U=0}.  At r = 8 that is a
binary-form identity of degree 12 in (V,W) whose coefficients involve ONLY

    X1, X2, Y0, Y2, B7, B8, B9          (7 of the 15 licensed variables)

-- 7 generators, 30 terms in all.  V(licensed) is contained in V(face), the
face system is TINY, and its exact branch-and-reduce splits the problem into a
handful of leaves on each of which most of the X,Y block collapses.

(Geometrically (F0) is the landing condition for the restriction of the tuple
to the line {x = 0}; the C_3-eigenblock structure makes the U-exponent-0
coefficients the sigma-images of the top-U ones, so this is genuinely the same
filtration seen from the other end.)

usage:
  h2_face.py show   [r]              -- the face system and its leaves
  h2_face.py solve  [r] [lam,...]    -- face leaves x full system, char-0
"""
import json
import os
import sys
import time

import h2_engines as E
import h2_levels as LV
import h2_licence as LI
import holes_lib as H
import holes_reduce as RD
import holes_solve as SV
import holes_track as TR
import n2c_systems as S
from n2b_lib import ONE, ZERO

LAMS = ('one', 'om', 'om2')


def face(r, lam):
    """(names, face_polys, full_polys) all in the licensed 15-variable ring."""
    names, gr, b, vs = LV.graded_licensed(r, lam)
    fpolys = RD.dedup([q for a, mo, q in gr if a == 0])
    allp = RD.dedup([q for a, mo, q in gr])
    return names, fpolys, allp, b, vs


def face_vars(names, polys):
    used = sorted({i for q in polys for k in q for i, e in enumerate(k) if e})
    return [names[i] for i in used]


def face_leaves(r, lam, verbose=True):
    """exact branch-and-reduce driven by the FACE generators only.

    Returns [(leaf, full_polys_on_leaf)].  Leaves on which B9 = 0 are DROPPED:
    the licence (stratum A char-0 empty) gives V(licensed) SUBSET {B9 != 0}.
    """
    names, fpolys, allp, b, vs = face(r, lam)
    br = TR.start(names, [dict(q) for q in fpolys])
    leaves = TR.solve(br)
    out = []
    for lf in leaves:
        # is B9 identically 0 on this leaf?  (env['B9'] == 0)
        if not lf.env.get('B9'):
            if verbose:
                print('   leaf %-46s DROPPED by the licence (B9 = 0 there)'
                      % lf.path[:46], flush=True)
            continue
        # push the full generator set through the leaf's reconstruction
        sub = {}
        for j, nm in enumerate(names):
            sub[j] = lf.env[nm]
        full = []
        for q in allp:
            acc = {}
            for k, v in q.items():
                term = {tuple([0]*len(lf.names)): v}
                for j, e in enumerate(k):
                    if not e:
                        continue
                    for _ in range(e):
                        term = S.p_mul(term, sub[j])
                    if not term:
                        break
                acc = S.p_add(acc, term)
            if acc:
                full.append(acc)
        full = RD.dedup(full + [dict(q) for q in lf.polys])
        out.append((lf, full))
    return names, out, vs


def show(r):
    for lam in LAMS:
        names, fpolys, allp, b, vs = face(r, lam)
        fv = face_vars(names, fpolys)
        print('=== r=%d lam=%s ===' % (r, lam))
        print('  licensed system : %d vars, %d gens' % (len(names), len(allp)))
        print('  FACE (U-exp 0)  : %d gens, %d terms, vars %s'
              % (len(fpolys), sum(len(q) for q in fpolys), fv))
        for q in sorted(fpolys, key=len):
            print('     %s' % RD.polystr(q, names))
        t0 = time.time()
        nm, lv, _ = face_leaves(r, lam)
        print('  face leaves kept: %d   (%.1f s)' % (len(lv), time.time()-t0))
        for lf, full in lv:
            zero = [n for n in names if not lf.env[n]]
            print('     %-52s vars=%2d facegens=%d fullgens=%3d  zero: %s'
                  % (lf.path[:52], len(lf.names), len(lf.polys), len(full),
                     ','.join(zero) or '-'))
        print(flush=True)


def solve(r, lams):
    print('=== TASK A: face-driven char-0 decision ===', flush=True)
    res = {}
    for lam in lams:
        t0 = time.time()
        names, lv, vs = face_leaves(r, lam)
        print('r=%d lam=%-4s : %d face leaves kept (%.1f s)'
              % (r, lam, len(lv), time.time()-t0), flush=True)
        verdicts = []
        for li, (lf, full) in enumerate(lv):
            # further exact reduction with the FULL generator set on this leaf
            br = TR.Branch(list(lf.names), [dict(q) for q in full],
                           {k: dict(v) for k, v in lf.env.items()}, lf.path)
            sub = TR.solve(br)
            print('  leaf %d %-40s -> %d subleaves'
                  % (li, lf.path[:40], len(sub)), flush=True)
            for si, sl in enumerate(sub):
                tag = 'face_r%d_%s_%d_%d' % (r, lam, li, si)
                if not sl.polys:
                    print('     %s NO EQUATIONS on %d vars -> POPULATED %s'
                          % (tag, len(sl.names), sl.path), flush=True)
                    verdicts.append((tag, 'NONEMPTY'))
                    continue
                if not sl.env.get('B9'):
                    print('     %s dropped by the licence (B9 = 0)' % tag,
                          flush=True)
                    continue
                vq, dtq, iq = E.qq(tag, sl.names, sl.polys, timeout=3600)
                vm, dtm, im = E.m2(tag, sl.names, sl.polys, timeout=3600)
                vsp = None
                if len(sl.names) <= 6:
                    vsp, dts, isp = E.sp(sl.names, sl.polys)
                votes = [v for v in (vq, vm, vsp) if v in (True, False)]
                ok = len(votes) >= 2 and all(v is True for v in votes)
                print('     %s vars=%d%s gens=%d | qq=%s(%.0fs) M2=%s(%.0fs) '
                      'sp=%s | %s'
                      % (tag, len(sl.names), sl.names, len(sl.polys), vq, dtq,
                         vm, dtm, vsp,
                         'EMPTY' if ok else '*** NOT CERTIFIED ***'),
                      flush=True)
                verdicts.append((tag, 'EMPTY' if ok else
                                 ('NONEMPTY' if any(v is False for v in votes)
                                  else 'NOT-DECIDED')))
        bad = [t for t, v in verdicts if v != 'EMPTY']
        res[lam] = {'leaves': len(verdicts), 'not_empty': bad,
                    'verdict': 'EMPTY' if not bad else 'NOT-DECIDED'}
        print('  => r=%d lam=%s : %s (%d subleaves, %d not certified)'
              % (r, lam, res[lam]['verdict'], len(verdicts), len(bad)),
              flush=True)
    p = os.path.join(H.HERE, 'payloads', 'taskA_face_r%d.json' % r)
    old = json.load(open(p)) if os.path.exists(p) else {}
    old.update(res)
    json.dump(old, open(p, 'w'), indent=1, sort_keys=True)
    print('\nTASK A (face) r=%d: %s'
          % (r, {k: v['verdict'] for k, v in old.items()}), flush=True)


if __name__ == '__main__':
    what = sys.argv[1]
    r = int(sys.argv[2]) if len(sys.argv) > 2 else 8
    lams = tuple(sys.argv[3].split(',')) if len(sys.argv) > 3 else LAMS
    if what == 'show':
        show(r)
    elif what == 'solve':
        solve(r, lams)
