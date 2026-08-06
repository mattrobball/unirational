#!/usr/bin/env python3
"""FIX-H2 TASK A: the decision run.

Structure of the reduction (all steps exact over K = QQ(om,kp), char 0):

  L1  LICENCE.  FIX-H1 certified strata A = {B6=1,B9=0} and C = {B9=1,B6=0}
      EMPTY in char 0.  With the two sparse top-U generators X0*B6^2 = 0,
      Y1*B9^2 = 0 and the homogeneity of the cone this gives

          plane-order-1 locus NONEMPTY  <=>  V(cone, B6-1, X0, Y1) NONEMPTY,

      and V(cone, B6-1, X0, Y1) SUBSET {B9 != 0}.          (h2_licence.py)

  L2  FACE.  The U-exponent-0 coefficients of the landing polynomial form a
      CLOSED subsystem in 7 of the 15 variables (X1,X2,Y0,Y2,B7,B8,B9) -- the
      other end of the plane-adic filtration, which FIX-H1 never used.  Its
      exact branch-and-reduce splits V(face) into

          {X1 = X2 = Y0 = Y2 = 0}   u   (one all-cofactor leaf).   (h2_face.py)

  L3  On each of the two cases, the FULL licensed generator set is pushed
      through and the exact branch-and-reduce (FIX-H1's R1-R5) is re-run;
      leaves on which B9 = 0 identically are dropped by L1.

  L4  Every surviving leaf goes to the char-0 battery (msolve over QQ with
      om,kp adjoined; Macaulay2 over K; sympy when small).  Two independent
      char-0 engines must agree for an EMPTY verdict.  A timeout is
      NOT-DECIDED.

usage:  h2_decide.py [r] [lam,...] [--only=Z|N] [--rabin] [--timeout=SEC]
"""
import json
import os
import sys
import time

import h2_engines as E
import h2_face as F
import holes_lib as H
import holes_reduce as RD
import holes_track as TR
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE

LAMS = ('one', 'om', 'om2')


def cases(r, lam):
    """[(tag, leaf-Branch)] -- the L2/L3 leaves that survive the licence."""
    names, fpolys, allp, b, vs = F.face(r, lam)
    out = []
    # CASE Z : X1 = X2 = Y0 = Y2 = 0  (covers 10 of the 11 face leaves)
    br = TR.start(names, [dict(q) for q in allp])
    for z in ('X1', 'X2', 'Y0', 'Y2'):
        br = TR.do_setzero(br, br.names.index(z))
    for i, s in enumerate(TR.solve(br)):
        out.append(('Z%d' % i, s))
    # CASE N : the all-cofactor face leaf
    nm, lv, _ = F.face_leaves(r, lam, verbose=False)
    lf, full = lv[-1]
    br2 = TR.Branch(list(lf.names), [dict(q) for q in full],
                    {k: dict(v) for k, v in lf.env.items()}, lf.path)
    for i, s in enumerate(TR.solve(br2)):
        out.append(('N%d' % i, s))
    return out


def rabin(names, polys, var='B9'):
    """adjoin w with var*w = 1 (legitimate: V SUBSET {B9 != 0} by the licence)."""
    if var not in names:
        return names, polys
    i = names.index(var)
    n = len(names)
    e = [0] * (n + 1)
    e[i] = 1
    e[n] = 1
    out = [{tuple(list(k) + [0]): v for k, v in q.items()} for q in polys]
    out.append({tuple(e): ONE, tuple([0] * (n + 1)): L.kneg(ONE)})
    return names + ['w'], out


def main():
    r = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    lams = LAMS
    only = None
    use_rabin = '--rabin' in sys.argv
    tmo = 3600
    for a in sys.argv[2:]:
        if a.startswith('--only='):
            only = a.split('=')[1]
        elif a.startswith('--timeout='):
            tmo = int(a.split('=')[1])
        elif not a.startswith('-'):
            lams = tuple(a.split(','))
    print('=== FIX-H2 TASK A decision, r = %d, lams = %s ===' % (r, lams))
    print('    msolve -t %s, Macaulay2, sympy; per-run timeout %d s; '
          'sequential.%s' % (E.NTH, tmo, '  [+Rabinowitsch B9*w=1]'
                             if use_rabin else ''), flush=True)
    allres = {}
    for lam in lams:
        t0 = time.time()
        cs = cases(r, lam)
        print('\nr=%d lam=%-4s : %d leaves after L2/L3 (%.1f s)'
              % (r, lam, len(cs), time.time() - t0), flush=True)
        rows = []
        for tag, s in cs:
            full = 'h2_%s_r%d_%s_%s' % ('rab' if use_rabin else 'dec', r, lam,
                                        tag)
            if not s.polys:
                print('  %-6s NO EQUATIONS on %d vars -> POPULATED'
                      % (tag, len(s.names)), flush=True)
                rows.append((tag, len(s.names), len(s.polys), None, None, None,
                             'NONEMPTY'))
                continue
            if not s.env.get('B9'):
                print('  %-6s vars=%2d gens=%2d  DROPPED by the licence '
                      '(B9 = 0 identically on this leaf; stratum A is char-0 '
                      'EMPTY)' % (tag, len(s.names), len(s.polys)), flush=True)
                rows.append((tag, len(s.names), len(s.polys), None, None, None,
                             'DROPPED-BY-LICENCE'))
                continue
            nm, pl = (rabin(list(s.names), [dict(q) for q in s.polys])
                      if use_rabin else (list(s.names),
                                         [dict(q) for q in s.polys]))
            vq, dtq, iq = E.qq(full, nm, pl, timeout=tmo)
            # fast, rigorous, one-sided second engine first
            vv, dtv, iv = (None, 0.0, '')
            for dl in (6, 9, 12):
                vv, dtv, iv = E.m2d(full, nm, pl, dlim=dl, timeout=900)
                if vv is True:
                    break
            vm, dtm, im = (None, 0.0, 'skipped')
            if not (vq is True and vv is True):
                vm, dtm, im = E.m2v(full, nm, pl, timeout=tmo)
            vsp = None
            if len(nm) <= 6 and not (vq is True and vv is True):
                vsp, dts, isp = E.sp(nm, pl)
            votes = [v for v in (vq, vv, vm, vsp) if v in (True, False)]
            if any(v is False for v in votes):
                verdict = 'NONEMPTY'
            elif len(votes) >= 2:
                verdict = 'EMPTY'
            else:
                verdict = 'NOT-DECIDED'
            print('  %-6s vars=%2d %-46s gens=%2d | qq=%-5s(%6.1fs) '
                  'M2v=%-5s(%6.1fs) M2K=%-5s(%6.1fs) sp=%-5s | %s'
                  % (tag, len(nm), str(nm)[:46], len(pl), vq, dtq, vv, dtv,
                     vm, dtm, vsp, verdict), flush=True)
            if verdict != 'EMPTY':
                print('        qq-info : %s' % str(iq)[:200], flush=True)
                print('        M2v-info: %s' % str(iv)[:200], flush=True)
                print('        M2K-info: %s' % str(im)[:200], flush=True)
            rows.append((tag, len(nm), len(pl), vq, vv, vm, vsp, verdict))
        bad = [t for t, *_, v in rows if v not in ('EMPTY',
                                                   'DROPPED-BY-LICENCE')]
        allres[lam] = {'rows': rows, 'undecided': bad,
                       'verdict': 'EMPTY' if not bad else
                       ('NONEMPTY' if any(v == 'NONEMPTY'
                                          for *_, v in rows) else
                        'NOT-DECIDED')}
        print('  => r=%d lam=%s : %s   (%d leaves, outstanding: %s)'
              % (r, lam, allres[lam]['verdict'], len(rows), bad or '-'),
              flush=True)
    p = os.path.join(H.HERE, 'payloads', 'taskA_decide_r%d.json' % r)
    old = json.load(open(p)) if os.path.exists(p) else {}
    for k, v in allres.items():
        old[k] = v
    json.dump(old, open(p, 'w'), indent=1, sort_keys=True, default=str)
    print('\nFIX-H2 TASK A r=%d: %s'
          % (r, {k: v['verdict'] for k, v in old.items()}), flush=True)


if __name__ == '__main__':
    main()
