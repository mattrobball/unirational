#!/usr/bin/env python3
"""FIX-H2 TASK A -- the decision, in its final two-case form.

    L1  LICENCE (h2_licence.py).  From FIX-H1's char-0 verdicts on strata A
        and C, and the two sparse top-U generators X0*B6^2 = 0, Y1*B9^2 = 0:

            plane-order-1 locus of the (1,r) cone in block lam is NONEMPTY
            <=>  W := V(cone, B6-1, X0, Y1)  is NONEMPTY,   and W ⊆ {B9 != 0}.

    L2  FACE (h2_face.py).  The U-exponent-0 coefficients of the landing
        polynomial form a CLOSED subsystem in 7 of the 15 variables
        (X1, X2, Y0, Y2, B7, B8, B9).  Its exact reduction proves

            on the face,  Y0 = 0  forces  X1 = X2 = Y2 = 0.

    L3  DICHOTOMY.  W = (W n {Y0 = 0}) u (W n {Y0 != 0}) =: CASE Z u CASE N,
        and on CASE Z the face collapses X1 = X2 = Y2 = 0 as well.  Both are
        cut out by DEGREE-3 systems once B9 (and, on N, Y0) are inverted --
        which the licence permits.  Two presentations of each are tried:

          lowdeg : the licensed cubics + the case condition + Rabinowitsch
                   inverses  (more variables, degree <= 3 -- what Macaulay2
                   likes)
          reduced: the same after FIX-H1's exact branch-and-reduce R1-R5
                   (fewer variables, high degree -- what msolve likes)

    L4  Two independent characteristic-zero engines must agree for EMPTY.
        A timeout is NOT-DECIDED, never a verdict.

usage:  h2_final.py [r] [lam,...] [--timeout=SEC]
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
from n2b_lib import ONE, ZERO

LAMS = ('one', 'om', 'om2')


def rabin_expr(names, polys, exprs):
    """adjoin one slack variable per expression:  expr * w = 1."""
    names = list(names)
    polys = [dict(q) for q in polys]
    for expr in exprs:
        n = len(names)
        lift = lambda q: {tuple(list(k) + [0]): v for k, v in q.items()}
        ew = [0] * (n + 1)
        ew[n] = 1
        rel = S.p_add(S.p_mul(lift(expr), {tuple(ew): ONE}),
                      {tuple([0] * (n + 1)): L.kneg(ONE)})
        polys = [lift(q) for q in polys] + [rel]
        names = names + ['w%d' % (len(names) - n + 1)]
    return names, polys


def presentations(r, lam):
    """[(case, presentation, names, polys)] -- everything that has to be
    proved empty for the hole to close in this eigenblock."""
    names, fpolys, allp, b, vs = F.face(r, lam)
    out = []

    # ---- CASE Z : Y0 = 0 -------------------------------------------------
    # NO Rabinowitsch is needed here.  V(licensed, Y0) already EQUALS CASE Z:
    # any of its points with B9 = 0 would lie in V(cone) n {B6=1, B9=0} =
    # stratum A, which is char-0 EMPTY (A-cert).  So the plain ideal
    # (licensed, Y0) is the unit ideal iff CASE Z is empty -- a strictly
    # simpler system than the saturated one (11 variables, degree <= 3).
    brz = TR.start(names, [dict(q) for q in allp])
    brz = TR.do_setzero(brz, brz.names.index('Y0'))
    # (D): on the face Y0 = 0 forces X1 = X2 = Y2 = 0, so all four may be set
    # to zero -- proved by the exact face reduction, logs/H2_DICHOTOMY.log.
    brz4 = brz.copy()
    for z in ('X1', 'X2', 'Y2'):
        brz4 = TR.do_setzero(brz4, brz4.names.index(z))
    out.append(('Z', 'lowdeg4', list(brz4.names),
                [dict(q) for q in brz4.polys]))
    out.append(('Z', 'lowdeg', list(brz.names),
                [dict(q) for q in brz.polys]))
    nzr, pzr = rabin_expr(brz.names, brz.polys, [brz.env['B9']])
    out.append(('Z', 'lowdeg-sat', nzr, pzr))
    for i, s in enumerate(TR.solve(brz.copy())):
        if not s.polys:
            out.append(('Z', 'reduced%d-NOEQ' % i, s.names, []))
        elif s.env.get('B9'):
            out.append(('Z', 'reduced%d' % i, list(s.names),
                        [dict(q) for q in s.polys]))
        # leaves with B9 == 0 identically are dropped by the licence

    # ---- CASE N : Y0 != 0 ------------------------------------------------
    # only Y0 has to be inverted; B9 != 0 is automatic on the licensed system
    # by (A-cert), exactly as in CASE Z.
    brn = TR.start(names, [dict(q) for q in allp])
    nn, pn = rabin_expr(brn.names, brn.polys, [brn.env['Y0']])
    out.append(('N', 'lowdeg', nn, pn))
    nn3, pn3 = rabin_expr(brn.names, brn.polys,
                          [brn.env['Y0'], brn.env['B9']])
    out.append(('N', 'lowdeg-sat', nn3, pn3))
    nm, lv, _ = F.face_leaves(r, lam, verbose=False)
    lf, full = lv[-1]                       # the all-cofactor face leaf
    nn2, pn2 = rabin_expr(lf.names, full, [lf.env['B9']])
    out.append(('N', 'faceleaf', nn2, pn2))
    br2 = TR.Branch(list(lf.names), [dict(q) for q in full],
                    {k: dict(v) for k, v in lf.env.items()}, lf.path)
    for i, s in enumerate(TR.solve(br2)):
        if not s.polys:
            out.append(('N', 'reduced%d-NOEQ' % i, s.names, []))
        elif s.env.get('B9'):
            out.append(('N', 'reduced%d' % i, list(s.names),
                        [dict(q) for q in s.polys]))
    return out


def decide_case(r, lam, case, pres, tmo, log):
    """Decide ONE case.

    The presentations of a case all cut out the SAME set (they differ by the
    exact reductions R1-R5 and by which units are inverted), so a `unit ideal'
    answer on ANY of them is a complete characteristic-zero proof that the
    case is empty.  We therefore let each engine work on the presentation it
    can actually finish -- msolve on the reduced, few-variable, high-degree
    ones, Macaulay2 on the low-degree ones -- and require agreement of TWO
    INDEPENDENT ENGINES on the same mathematical statement rather than on the
    same ideal.  A leaf with no equations at all would be POPULATED and is
    reported as NONEMPTY.
    """
    ev = {'msolve': None, 'M2': None, 'sympy': None}
    where = {}
    for kind, nm, pl in pres:
        if not pl:
            log('  %-2s %-16s NO EQUATIONS on %d vars -> POPULATED'
                % (case, kind, len(nm)))
            return 'NONEMPTY', 'no equations on presentation %s' % kind, where
    order = sorted(pres, key=lambda t: (0 if t[0].startswith('reduced') else 1))
    for kind, nm, pl in order:
        if ev['msolve'] is True:
            break
        tag = 'h2f_r%d_%s_%s_%s' % (r, lam, case, kind)
        v, dt, info = E.qq(tag, nm, pl, timeout=tmo)
        log('  %-2s %-16s vars=%2d gens=%2d deg<=%2d  msolve-qq = %-5s (%.0fs)'
            % (case, kind, len(nm), len(pl),
               max(sum(k) for q in pl for k in q), v, dt))
        if v is False:
            return 'NONEMPTY', 'msolve non-unit on %s' % kind, where
        if v is True:
            ev['msolve'] = True
            where['msolve'] = kind
    order2 = sorted(pres, key=lambda t: (0 if t[0].startswith('lowdeg') else 1, len(t[1])))
    for kind, nm, pl in order2:
        if ev['M2'] is True:
            break
        tag = 'h2f_r%d_%s_%s_%s' % (r, lam, case, kind)
        for eng, fn in (('M2v', E.m2v), ('M2K', E.m2)):
            v, dt, info = fn(tag, nm, pl, timeout=tmo)
            log('  %-2s %-16s vars=%2d gens=%2d deg<=%2d  %-3s       = %-5s '
                '(%.0fs)' % (case, kind, len(nm), len(pl),
                             max(sum(k) for q in pl for k in q), eng, v, dt))
            if v is False:
                return 'NONEMPTY', '%s non-unit on %s' % (eng, kind), where
            if v is True:
                ev['M2'] = True
                where['M2'] = '%s/%s' % (eng, kind)
                break
    if ev['msolve'] is not True or ev['M2'] is not True:
        for kind, nm, pl in order:
            if len(nm) <= 7:
                v, dt, info = E.sp(nm, pl)
                log('  %-2s %-16s sympy = %-5s (%.0fs)' % (case, kind, v, dt))
                if v is True:
                    ev['sympy'] = True
                    where['sympy'] = kind
                    break
                if v is False:
                    return 'NONEMPTY', 'sympy non-unit on %s' % kind, where
    good = [k for k, v in ev.items() if v is True]
    return ('EMPTY' if len(good) >= 2 else 'NOT-DECIDED',
            'engines agreeing: %s' % (', '.join('%s@%s' % (k, where[k])
                                                for k in good) or 'none'),
            where)


def main():
    r = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    lams = LAMS
    tmo = 2400
    for a in sys.argv[2:]:
        if a.startswith('--timeout='):
            tmo = int(a.split('=')[1])
        elif not a.startswith('-'):
            lams = tuple(a.split(','))
    print('=== FIX-H2 TASK A final decision, r=%d, lams=%s ===' % (r, lams))
    print('    msolve -t %s / Macaulay2 / sympy, sequential, per-run timeout '
          '%d s' % (E.NTH, tmo), flush=True)
    res = {}
    for lam in lams:
        t0 = time.time()
        pres = presentations(r, lam)
        print('\nr=%d lam=%-4s : %d presentations (%.1f s)'
              % (r, lam, len(pres), time.time() - t0), flush=True)
        def log(s):
            print(s, flush=True)

        best, detail = {}, {}
        for case in ('Z', 'N'):
            sub = [(kind, nm, pl) for c, kind, nm, pl in pres if c == case]
            v, det, where = decide_case(r, lam, case, sub, tmo, log)
            best[case], detail[case] = v, det
            print('  -- CASE %s : %s   (%s)' % (case, v, det), flush=True)
        zc, nc = best.get('Z', 'NOT-DECIDED'), best.get('N', 'NOT-DECIDED')
        verdict = ('EMPTY' if zc == 'EMPTY' and nc == 'EMPTY'
                   else ('NONEMPTY' if 'NONEMPTY' in (zc, nc)
                         else 'NOT-DECIDED'))
        res[lam] = {'caseZ': zc, 'caseN': nc, 'verdict': verdict, 'detail': detail}
        print('  => r=%d lam=%-4s  CASE Z = %s , CASE N = %s  ==>  %s'
              % (r, lam, zc, nc, verdict), flush=True)
    p = os.path.join(H.HERE, 'payloads', 'taskA_final_r%d.json' % r)
    old = json.load(open(p)) if os.path.exists(p) else {}
    old.update(res)
    json.dump(old, open(p, 'w'), indent=1, sort_keys=True)
    print('\nFIX-H2 TASK A r=%d FINAL: %s'
          % (r, {k: v['verdict'] for k, v in old.items()}), flush=True)


if __name__ == '__main__':
    main()
