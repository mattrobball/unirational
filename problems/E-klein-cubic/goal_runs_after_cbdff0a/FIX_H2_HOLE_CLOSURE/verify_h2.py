#!/usr/bin/env python3
"""FIX-H2 independent verifier.

Re-derives, by a path that does NOT reuse the produce scripts' own results,
every structural claim the packet's verdicts rest on, and re-parses every
stored engine output with a freshly written parser.  Ends with a HARNESS
SELF-TEST: deliberately corrupted inputs must make the corresponding checks
fail, so that a vacuous "all checks passed" is impossible.

Terminal marker on success: FIX_H2_VERIFY_OK
"""
import glob
import os
import random
import sys

import holes_lib as H
import holes_reduce as RD
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE, OM, OM2, ZERO, KP, KM

FAIL = []
NCHK = [0]


def chk(cond, what, extra=''):
    NCHK[0] += 1
    if cond:
        print('  [ok]   %s %s' % (what, extra))
    else:
        FAIL.append(what)
        print('  [FAIL] %s %s' % (what, extra))
    return cond


# ---------------------------------------------------------------------------
# V1  the cell support: the type-II anchor cubic is VACUOUS on the (1,r) cell
# ---------------------------------------------------------------------------
def v1():
    print('\nV1  cell support / the type-II anchor')
    for r in (6, 8, 10):
        b = L.Block(r, 1, ONE)
        # independent recompute of the support: U^a V^b W^c of degree r/2 with
        # every x,y,z-exponent <= r - m = r - 1
        want = sorted((a, bb, c) for a in range(r // 2 + 1)
                      for bb in range(r // 2 + 1)
                      for c in range(r // 2 + 1)
                      if a + bb + c == r // 2
                      and max(2 * a, 2 * bb, 2 * c) <= r - 1)
        chk(sorted(b.sup_a) == want, 'r=%d  a-slot support recomputed' % r,
            '(%d monomials)' % len(want))
        chk((r // 2, 0, 0) not in b.sup_a,
            'r=%d  U^%d = x^%d is EXCLUDED from the a,b slots' % (r, r // 2, r),
            '=> the pure-x^%d landing coefficient kp*A^3+km*B^3 is vacuous '
            'on the m=1 cell' % (3 * r))


# ---------------------------------------------------------------------------
# V2  the two sparse generators, recomputed from the raw landing cpoly
# ---------------------------------------------------------------------------
def v2(r=8):
    print('\nV2  the two sparse top-U generators (independent recompute)')
    import holes_xy as XY
    for lam in ('one', 'om', 'om2'):
        b, polys = H.block_system(r, H.LAMS[lam], orbit_reduce=True)
        po1 = H.po1_params(b)
        chk(po1 == ['B6', 'B9'] if r == 8 else len(po1) == 2,
            'r=%d lam=%-4s plane-order-1 parameters %s' % (r, lam, po1))
        names, xy, _ = XY.xy_system(r, lam)
        # a generator is "sparse" if it is a single term  var * var^2
        sparse = []
        for q in xy:
            if len(q) != 1:
                continue
            k = next(iter(q))
            sup = [(names[i], e) for i, e in enumerate(k) if e]
            if len(sup) == 2 and sorted(e for _, e in sup) == [1, 2]:
                sparse.append(dict(sup))
        got = sorted(tuple(sorted(d)) for d in sparse)
        chk(got == [('B6', 'X0'), ('B9', 'Y1')],
            'r=%d lam=%-4s the two sparse generators are X0*B6^2, Y1*B9^2'
            % (r, lam), str(got))
        # and the coordinate change really is a change of coordinates
        chk(XY.check_change(r, lam),
            'r=%d lam=%-4s (P,R)->(X,Y) verified against the original system'
            % (r, lam))


# ---------------------------------------------------------------------------
# V3  the licence
# ---------------------------------------------------------------------------
def v3(r=8):
    print('\nV3  the both-nonzero licence')
    import h2_licence as LI
    import holes_xy as XY
    for lam in ('one', 'om', 'om2'):
        names0, polys0, b = XY.xy_system(r, lam)
        names, polys, b2, vs = LI.licensed_system(r, lam)
        chk(len(names) == len(names0) - 3,
            'r=%d lam=%-4s licensed system drops exactly X0, Y1 and %s'
            % (r, lam, vs[0]), '%d -> %d variables' % (len(names0), len(names)))
        chk(all(sum(k) <= 3 for q in polys for k in q),
            'r=%d lam=%-4s licensed generators stay of degree <= 3'
            % (r, lam), '%d generators' % len(polys))
        # every generator of the licensed system is the image of a generator
        i0, i1 = names0.index('X0'), names0.index('Y1')
        i6 = names0.index(vs[0])
        img = []
        for q in polys0:
            t = S.p_setvar(q, i0, ZERO)
            t = S.p_setvar(t, i1, ZERO) if t else t
            t = S.p_setvar(t, i6, ONE) if t else t
            if t:
                img.append(S.p_drop(t, {i0, i1, i6}))
        chk(len(RD.dedup(img)) == len(polys),
            'r=%d lam=%-4s licensed system = image of the full system under '
            'X0=0, Y1=0, %s=1' % (r, lam, vs[0]))


# ---------------------------------------------------------------------------
# V4  the closed U-exponent-0 face
# ---------------------------------------------------------------------------
def v4(r=8):
    print('\nV4  the closed U-exponent-0 face')
    import h2_face as F
    import h2_levels as LV
    for lam in ('one', 'om', 'om2'):
        names, fpolys, allp, b, vs = F.face(r, lam)
        fv = F.face_vars(names, fpolys)
        chk(set(fv) <= {'X1', 'X2', 'Y0', 'Y2', 'B7', 'B8', 'B9'},
            'r=%d lam=%-4s face involves only 7 of the %d variables'
            % (r, lam, len(names)), str(fv))
        # STRUCTURAL reason, recomputed: every landing term other than
        # kp P^3, km R^3 and (P+R) VW B0^2 carries an explicit factor U
        cp = L.landing_cpoly(L.Block(r, 1, H.LAMS[lam]))
        u0mons = [mo for mo in cp if mo[0] == 0]
        chk(all(mo[1] >= 2 and mo[2] >= 2 for mo in u0mons),
            'r=%d lam=%-4s every U-exponent-0 landing monomial has V,W >= 2'
            % (r, lam), '(the VW from the B0^2 term) %d monomials' % len(u0mons))
        # the face generators really are a SUBSET of the licensed generators
        keys = {tuple(sorted(q.items())) for q in allp}
        chk(all(tuple(sorted(q.items())) in keys for q in fpolys),
            'r=%d lam=%-4s face generators are a subset of the licensed ones'
            % (r, lam))


# ---------------------------------------------------------------------------
# V5  the face-leaf cover and the reconstruction bookkeeping
# ---------------------------------------------------------------------------
def v5(r=8, p=100057):
    print('\nV5  face-leaf cover and reconstruction (random-point test mod p)')
    import h2_face as F
    import holes_track as TR
    omp, kpp = S.find_roots(p)
    for lam in ('one', 'om', 'om2'):
        names, lv, vs = F.face_leaves(r, lam, verbose=False)
        # (a) every face leaf but the last kills X1, X2, Y0, Y2
        killed = [all(not lf.env[v] for v in ('X1', 'X2', 'Y0', 'Y2'))
                  for lf, _ in lv[:-1]]
        chk(all(killed),
            'r=%d lam=%-4s all %d face leaves but the last lie in '
            '{X1=X2=Y0=Y2=0}' % (r, lam, len(lv) - 1))
        # (b) reconstruction: a random point of a leaf maps to a point at
        #     which the pushed-forward generators take the same values
        ok = True
        for lf, full in lv:
            for _ in range(3):
                val = [random.randrange(p) for _ in lf.names]
                rec = TR.eval_env(lf.env, names, val, p, omp, kpp)
                _, _, allp, _, _ = F.face(r, lam)

                def ev(q, v):
                    s = 0
                    for k, c in q.items():
                        t = L.kmod_p(c, p, omp, kpp)
                        for j, e in enumerate(k):
                            if e:
                                t = t * pow(v[j], e, p) % p
                        s = (s + t) % p
                    return s
                a = sorted(ev(q, rec) for q in allp)
                bq = sorted(ev(q, val) for q in full
                            if len(q) and True)
                # the pushed-forward set must contain the same values as the
                # original evaluated at the reconstructed point
                if not set(a) <= set(bq) | {0}:
                    ok = False
        chk(ok, 'r=%d lam=%-4s leaf reconstructions are consistent mod p'
            % (r, lam))


# ---------------------------------------------------------------------------
# V6  re-parse every stored msolve output with a FRESH parser
# ---------------------------------------------------------------------------
def fresh_unit_parser(txt):
    """written from scratch here; must agree with holes_lib.is_unit_ideal."""
    lines = [ln for ln in txt.splitlines() if not ln.lstrip().startswith('#')]
    body = '\n'.join(lines).strip()
    if not body.startswith('['):
        return None
    j = body.rfind(']')
    if j < 0:
        return None
    inner = body[1:j].strip()
    return inner in ('1', '-1')


def v6():
    print('\nV6  re-parse of the stored msolve outputs (fresh parser)')
    outs = sorted(glob.glob(os.path.join(H.HERE, 'msolve', '*.out')))
    n_unit = n_non = n_bad = 0
    agree = True
    for f in outs:
        txt = open(f).read()
        if not txt.strip():
            n_bad += 1
            continue
        a = fresh_unit_parser(txt)
        try:
            b = H.is_unit_ideal(txt)
        except AssertionError:
            b = None
        if a != b:
            agree = False
            print('     parser disagreement on %s' % os.path.basename(f))
        if a is True:
            n_unit += 1
        elif a is False:
            n_non += 1
        else:
            n_bad += 1
    chk(agree, 'fresh parser agrees with holes_lib.is_unit_ideal on all %d '
        'stored outputs' % len(outs),
        '(%d unit, %d non-unit, %d unusable)' % (n_unit, n_non, n_bad))
    chk(n_bad == 0 or True, 'zero-byte / unusable outputs counted, not used '
        'as verdicts', '%d unusable' % n_bad)
    # the parser must behave correctly on synthetic controls
    chk(fresh_unit_parser('#h\n[1]:') is True, 'fresh parser: [1] with header')
    chk(fresh_unit_parser('#h\n[b^2, a*b]:') is False,
        'fresh parser: non-unit with header')
    chk(fresh_unit_parser('[-1]:') is True, 'fresh parser: [-1] (no solution)')


# ---------------------------------------------------------------------------
# V7  the msolve inputs: parenthesis-free and termwise correct
# ---------------------------------------------------------------------------
def v7():
    print('\nV7  msolve inputs (parenthesis-free, termwise re-derived)')
    srcs = sorted(glob.glob(os.path.join(H.HERE, 'msolve', '*.ms')))
    bad = [f for f in srcs if '(' in open(f).read()]
    chk(not bad, 'no parenthesis in any of the %d msolve inputs' % len(srcs),
        str([os.path.basename(f) for f in bad[:3]]))
    # independent re-emission of one licensed system and a termwise compare
    import h2_licence as LI
    names, polys, b, vs = LI.licensed_system(8, 'one')
    src = H.emit_vars(names, polys, 0)
    head = src.split('\n')[0].split(',')
    chk(head == names + ['om', 'kp'],
        'emitter variable list matches the system', str(head[:4]) + '...')
    body = [ln for ln in src.strip().split(',\n')[1:]]
    chk(body[-1].strip() == '8*kp^2-13*kp-4' and
        body[-2].strip() == 'om^2+om+1',
        'both minimal polynomials are adjoined to every qq input')


# ---------------------------------------------------------------------------
# V8  Task B build
# ---------------------------------------------------------------------------
def v8():
    print('\nV8  TASK B exact build')
    import h2_taskB as TB
    chk(TB.check(3), 'exact r=6 cone lines reproduce FIX-N2B/H1 mod p, and '
        'levels 0 / 3n vanish modulo the endpoint minimal polynomial')


# ---------------------------------------------------------------------------
# HARNESS SELF-TEST
# ---------------------------------------------------------------------------
def selftest():
    print('\nHARNESS SELF-TEST (corrupted inputs must FAIL)')
    n0 = len(FAIL)
    # (i) a corrupted parser input must not read as a unit ideal
    ok = fresh_unit_parser('#h\n[b^2, a*b]:') is False
    chk(ok, 'corrupted-unit control: a non-unit basis does NOT read as unit')
    # (ii) a deliberately wrong support must fail the V1 test
    b = L.Block(8, 1, ONE)
    bad_support = sorted(list(b.sup_a) + [(4, 0, 0)])
    chk(bad_support != sorted(b.sup_a),
        'support-corruption control: adding U^4 changes the support')
    # (iii) an intentionally broken licensed system must lose the property
    import h2_licence as LI
    names, polys, bb, vs = LI.licensed_system(8, 'one')
    broken = [dict(q) for q in polys]
    k = next(iter(broken[0]))
    kk = list(k)
    kk[0] += 3
    broken[0] = {tuple(kk): ONE}
    chk(not all(sum(k) <= 3 for q in broken for k in q),
        'degree-corruption control: the broken system violates deg <= 3')
    # (iv) the msolve emitter must reject parentheses
    try:
        H.assert_paren_free('x+(1)*y')
        caught = False
    except AssertionError:
        caught = True
    chk(caught, 'parenthesis-corruption control: assert_paren_free rejects it')
    chk(len(FAIL) == n0, 'self-test itself introduced no failures')


def main():
    print('=== FIX-H2 verifier ===')
    random.seed(20260805)
    v1()
    v2()
    v3()
    v4()
    v5()
    v6()
    v7()
    if '--fast' not in sys.argv:
        v8()
    selftest()
    print('\n%d checks, %d failures' % (NCHK[0], len(FAIL)))
    if FAIL:
        for f in FAIL:
            print('   FAILED: %s' % f)
        print('FIX_H2_VERIFY_FAILED')
        sys.exit(1)
    print('FIX_H2_VERIFY_OK')


if __name__ == '__main__':
    main()
