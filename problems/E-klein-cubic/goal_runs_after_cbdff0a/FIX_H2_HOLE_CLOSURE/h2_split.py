#!/usr/bin/env python3
"""FIX-H2: exact zero/non-zero splitting, to make a stubborn leaf small enough
for a SECOND independent characteristic-zero engine.

For any variable v,   V(I) = ( V(I) n {v = 0} )  u  ( V(I) n {v != 0} ) ,
and the second piece is V(I + (v*u - 1)) in one more variable.  Both are exact
operations over K, valid in characteristic zero, and after each split FIX-H1's
own reduction rules R1-R5 (`holes_track.solve`) are re-applied, which is what
actually shrinks the pieces: with v inverted, generators that were previously
irreducible monomial products become linear.

The result is a COVER of the original variety by small pieces; the original is
empty iff every piece is.  Used only when the direct engines do not finish --
msolve already decides these leaves, and this is here to supply the required
INDEPENDENT confirmation.

usage:  h2_split.py [r] [lam,...] [case] [--maxvars=N] [--engine=m2v|sympy|both]
"""
import json
import os
import sys
import time

import h2_engines as E
import h2_face as F
import holes_reduce as RD
import holes_lib as H
import holes_track as TR
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE, ZERO


def add_inverse(names, polys, i):
    """adjoin u with names[i]*u = 1."""
    n = len(names)
    e = [0] * (n + 1)
    e[i] = 1
    e[n] = 1
    out = [{tuple(list(k) + [0]): v for k, v in q.items()} for q in polys]
    out.append({tuple(e): ONE, tuple([0] * (n + 1)): L.kneg(ONE)})
    return names + ['inv%s' % names[i]], out


def pieces(names, polys, maxvars=5, maxdepth=6, _depth=0):
    """exact cover of V(polys) by systems of at most `maxvars` variables."""
    br = TR.Branch(list(names), [dict(q) for q in polys],
                   {n: {} for n in names}, '')
    out = []
    for s in TR.solve(br):
        if not s.polys:
            out.append((s.names, [], 'NOEQ'))
            continue
        if len(s.names) <= maxvars or _depth >= maxdepth:
            out.append((list(s.names), [dict(q) for q in s.polys],
                        'depth%d' % _depth))
            continue
        # split on the variable occurring in the most generators
        cnt = {i: 0 for i in range(len(s.names))}
        for q in s.polys:
            for k in q:
                for i, e in enumerate(k):
                    if e:
                        cnt[i] += 1
        i = max(cnt, key=lambda j: cnt[j])
        # (a) v = 0  -- one variable fewer
        z = TR.Branch(list(s.names), [dict(q) for q in s.polys],
                      {n: {} for n in s.names}, s.path)
        z = TR.do_setzero(z, i)
        out += pieces(z.names, z.polys, maxvars, maxdepth, _depth + 1)
        # (b) v != 0 -- invert v and run the LICENSED cascade R3+, which is
        #     what makes this branch shrink: with v a unit, generators of the
        #     shape c*v^a*w -> ... become linear in w and w is eliminated.
        import h2_reduce as HR
        loc, nm2, pl2, _tr = HR.licensed_reduce(
            list(s.names), [dict(q) for q in s.polys], i, maxdeg=4,
            verbose=False)
        if pl2 and len(pl2) == 1 and sum(next(iter(pl2[0]))) == 0:
            pass                       # unit ideal: this branch is EMPTY
        elif _depth + 1 >= maxdepth:
            out.append((nm2, pl2, 'stuck-depth%d' % _depth))
        else:
            out += pieces(nm2, pl2, maxvars, maxdepth, _depth + 1)
    return out


def main():
    r = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    lams = ('one', 'om', 'om2')
    case = 'Z'
    maxvars = 5
    engine = 'both'
    for a in sys.argv[2:]:
        if a.startswith('--maxvars='):
            maxvars = int(a.split('=')[1])
        elif a.startswith('--engine='):
            engine = a.split('=')[1]
        elif a in ('Z', 'N'):
            case = a
        elif not a.startswith('-'):
            lams = tuple(a.split(','))
    res = {}
    for lam in lams:
        names, fpolys, allp, b, vs = F.face(r, lam)
        if case == 'Z':
            br = TR.start(names, [dict(q) for q in allp])
            br = TR.do_setzero(br, br.names.index('Y0'))
            leaves = [s for s in TR.solve(br) if s.env.get('B9')]
        else:
            nm, lv, _ = F.face_leaves(r, lam, verbose=False)
            lf, full = lv[-1]
            br2 = TR.Branch(list(lf.names), [dict(q) for q in full],
                            {k: dict(v) for k, v in lf.env.items()}, lf.path)
            leaves = [s for s in TR.solve(br2) if s.env.get('B9')]
        t0 = time.time()
        pcs = []
        for s in leaves:
            pcs += pieces(list(s.names), [dict(q) for q in s.polys],
                          maxvars=maxvars)
        print('r=%d lam=%-4s CASE %s : %d surviving leaf/leaves -> %d exact '
              'pieces (max %d vars)  (%.1f s)'
              % (r, lam, case, len(leaves), len(pcs), maxvars,
                 time.time() - t0), flush=True)
        ok = True
        for i, (nm, pl, tagx) in enumerate(pcs):
            tag = 'h2s_r%d_%s_%s_%d' % (r, lam, case, i)
            if not pl:
                print('   piece %2d NO EQUATIONS on %d vars -> POPULATED'
                      % (i, len(nm)), flush=True)
                ok = False
                continue
            vv = vsp = None
            if engine in ('m2v', 'both'):
                vv, dtv, iv = E.m2v(tag, nm, pl, timeout=900)
            if engine in ('sympy', 'both') and vv is not True and len(nm) <= 6:
                vsp, dts, isp = E.sp(nm, pl)
            good = (vv is True) or (vsp is True)
            ok = ok and good
            print('   piece %2d vars=%d%s gens=%2d deg<=%2d | M2v=%-5s '
                  'sympy=%-5s | %s'
                  % (i, len(nm), nm, len(pl),
                     max(sum(k) for q in pl for k in q), vv, vsp,
                     'EMPTY' if good else '*** NOT CERTIFIED ***'), flush=True)
        res['%s_%s' % (lam, case)] = 'EMPTY' if ok else 'NOT-DECIDED'
        print('  => r=%d lam=%s CASE %s : %s'
              % (r, lam, case, res['%s_%s' % (lam, case)]), flush=True)
    p = os.path.join(H.HERE, 'payloads', 'taskA_split_r%d.json' % r)
    old = json.load(open(p)) if os.path.exists(p) else {}
    old.update(res)
    json.dump(old, open(p, 'w'), indent=1, sort_keys=True)
    print('\nFIX-H2 split-cover r=%d: %s' % (r, old), flush=True)


if __name__ == '__main__':
    main()
