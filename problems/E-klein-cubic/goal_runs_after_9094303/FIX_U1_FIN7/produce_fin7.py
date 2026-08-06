#!/usr/bin/env python3
"""FIX-U1-FIN7 -- producer.  The named computation FIN(7) of Prop 5.3,
`theory/FIX_IV_closure.md` §5.3.

Decides whether PO_1(7) -- the plane-order-exactly-1 locus of the projectivized
POINTWISE, NON-EQUIVARIANT r = 7 cone -- is finite, and if not describes it.

Everything below is exact characteristic zero over K = QQ(om, kp) and its
degree-1/2/2/4 extensions by the FIX-N2C block cubics.  Modular runs appear
only as cross-checks or as certified LOWER bounds on ranks.
"""
import json
import os
import sys
import time

import sympy as sp

import fin7_equiv as E
import fin7_jac as JJ
import fin7_lib as L
import fin7_points as PT
import fin7_tangent as TG
import fin7_theta as TH
from exalg import Alg
from fin7_equiv import B2s, P1s
from fin7_lib import kp, kred, om, OM2

HERE = os.path.dirname(os.path.abspath(__file__))
T0 = time.time()
LOG = []
RES = {}
FAIL = []


def log(s=''):
    print(s, flush=True)
    LOG.append(s)


def ck(name, cond, extra=''):
    log('  %-64s %s %s' % (name, 'OK  ' if cond else 'FAIL', extra))
    if not cond:
        FAIL.append(name)
    return cond


# ===========================================================================
def sec0_selftest():
    log('## 0. Harness self-test (unit and non-unit controls)')
    A = Alg(sp.Poly(B2s - 1, B2s).as_expr(), sp.Poly(P1s - 2, P1s).as_expr(),
            'ctl')
    one, zero = A.one(), A.zero()
    ck('control: 1 is invertible in the branch algebra', A.inv(one) is not None)
    ck('control: 0 is NOT invertible', A.inv(zero) is None)
    ck('control: om is invertible, om*om^2 = 1',
       A.inv(A.of(om)) is not None
       and A.mul(A.of(om), A.of(OM2)) == one)
    ck('control: (om^2+om+1) reduces to 0', A.is_zero(A.of(om**2 + om + 1)))
    # rank controls
    R = JJ.Fp(100057)
    I3 = [[1 if i == j else 0 for j in range(3)] for i in range(3)]
    r, _, _ = JJ.rank(R, I3)
    ck('control: rank of the 3x3 identity is 3', r == 3)
    Z = [[0]*3 for _ in range(3)]
    r, _, _ = JJ.rank(R, Z)
    ck('control: rank of the 3x3 zero matrix is 0', r == 0)
    Sing = [[1, 2, 3], [2, 4, 6], [1, 1, 1]]
    r, _, _ = JJ.rank(R, Sing)
    ck('control: rank of a rank-2 3x3 matrix is 2', r == 2)
    # exact rank over the K-algebra
    Ak = PT.part_algebra(0, 'A')
    M = [[Ak.of(om), Ak.of(sp.Integer(1))],
         [Ak.of(sp.Integer(1)), Ak.of(OM2)]]      # det = om*om^2 - 1 = 0
    r, _, _ = JJ.rank(Ak, M)
    ck('control: exact rank over K of a singular 2x2 is 1', r == 1)
    M2_ = [[Ak.of(om), Ak.of(sp.Integer(1))],
           [Ak.of(sp.Integer(1)), Ak.of(sp.Integer(1))]]
    r, _, _ = JJ.rank(Ak, M2_)
    ck('control: exact rank over K of a nonsingular 2x2 is 2', r == 2)
    log()


# ===========================================================================
def sec1_system():
    log('## 1. The non-equivariant r = 7 cone: 39 parameters, 52 equations')
    sup = L.supports()
    nms = L.param_names()
    for i in range(5):
        log('   slot %-4s parity %s : %d monomials  %s..%s'
            % (L.SLOT_NAMES[i], L.slot_parities(7)[i], len(sup[i]),
               nms[i][0], nms[i][-1]))
    names, T, eqs_sym = L.landing_equations()
    names2, eqs_trm = L.landing_terms()
    ck('parameter count is 39', len(names) == 39, str(len(names)))
    ck('equation count is 52', len(eqs_sym) == 52, str(len(eqs_sym)))
    ck('the two independent builders agree on the monomial set',
       set(m for m, _ in eqs_sym) == set(m for m, _ in eqs_trm))
    S = [sp.Symbol(n) for n in names]
    d2 = dict(eqs_sym)
    bad = 0
    for mon, tl in eqs_trm:
        e = sum(c*S[i]*S[j]*S[k] for c, (i, j, k) in tl)
        if sp.expand(e - d2[mon]) != 0:
            bad += 1
    ck('symbolic build == term-list build, coefficient by coefficient',
       bad == 0, '(%d mismatches)' % bad)
    ck('all 52 equation monomials have degree 21 and all exponents odd',
       all(sum(m) == 21 and all(e % 2 for e in m) for m, _ in eqs_sym))
    ck('all 52 equation monomials have max exponent <= 17 (= 21 - 3m)',
       all(max(m) <= 17 for m, _ in eqs_sym))
    # equivariant restriction reproduces FIX-N2C's system
    sys.path.insert(0, '/Users/worker/unirational/problems/E-klein-cubic/'
                       'goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION')
    import indep_r7 as I27                                    # noqa: E402
    for j in range(3):
        lam = kred(om**j)
        _bn, coords = E.block_embedding(lam)
        sub = {sp.Symbol(n): coords[n] for n in names}
        n27, T27, e27 = I27.landing_equations(7, 1, lam)
        d27 = dict(e27)
        ck('lam=om^%d : same 52 monomials as FIX-N2C indep_r7' % j,
           set(d27) == set(d2))
        bad = [m for m in d2
               if kred(sp.expand(d2[m].subs(sub) - d27[m])) != 0]
        ck('lam=om^%d : restriction to the eigenblock == indep_r7 equations'
           % j, not bad, '(%d mismatches)' % len(bad))
    # the plane-order-exactly-1 witnesses
    log('   plane-order-exactly-1 witnesses (ord_{P_i} = 1 iff one is nonzero):')
    for i, w in enumerate(L.po1_witnesses()):
        log('     P%d : %s' % (i + 1, ', '.join(
            '%s = [%s]%s' % (nm, 'x^%dy^%dz^%d' % mon, sl)
            for nm, sl, mon in w)))
    RES['n_params'] = len(names)
    RES['n_eqs'] = len(eqs_sym)
    log()


# ===========================================================================
def sec2_points():
    log('## 2. The 27 classified Chebyshev points inside the 39-parameter cone')
    names, eqs = L.landing_terms()
    Th = L.theta_matrix()
    for j in range(3):
        g1, g2 = E.block_cubics(j)
        REL = [g2, g1, om**2 + om + 1, 8*kp**2 - 13*kp - 4]
        GENS = (P1s, B2s, om, kp)

        def red(e, REL=REL, GENS=GENS):
            e = sp.expand(e)
            if e == 0:
                return sp.Integer(0)
            _, r = sp.reduced(e, REL, *GENS, order='lex')
            return sp.expand(r)
        coords = E.classified_point(j)
        sub = {sp.Symbol(n): coords[n] for n in names}
        _n2, _T2, esym = L.landing_equations()
        bad = [m for m, cf in esym if red(sp.expand(cf.subs(sub))) != 0]
        ck('lam=om^%d : F(T) = 0 on all 52 equations, modulo the block ideal'
           % j, not bad, '(%d nonzero)' % len(bad))
        lam = kred(om**j)
        bad2 = [n for n in names
                if red(sp.expand(Th[n].subs(sub) - lam*coords[n])) != 0]
        ck('lam=om^%d : Theta(p) = om^%d p (residual C3 eigenvector)' % (j, j),
           not bad2)
        l1, q1, l2, q2 = PT.block_factors(j)
        ck('lam=om^%d : B2-cubic = (K-rational linear)(irreducible quadratic)'
           % j, sp.Poly(q1, B2s).degree() == 2)
        ck('lam=om^%d : P1-cubic = (K-rational linear)(irreducible quadratic)'
           % j, sp.Poly(q2, P1s).degree() == 2)
    log('   Galois-stable split of each nine-point block: 1 + 2 + 2 + 4'
        '  (parts A, B, C, D)')
    log()


# ===========================================================================
def sec3_torus():
    log('## 3. The (C*)^3 reparametrisation action: PO_1(7) is INFINITE')
    log('   (s,t,w).T := T(sx,ty,wz) preserves the slot parities, the degree,')
    log('   the monomial support (hence every plane order) and F(T)=0, so it')
    log('   acts on PO_1(7).  Its orbits are the reparametrisation orbits.')
    names, eqs = L.landing_terms()
    tab = []
    for j in range(3):
        for part in PT.PARTS:
            A, nm, vals, ceq, prods = TG.prepare(j, part)
            Tt = TG.torus_tangent(A, vals)
            r, _, _ = JJ.rank(A, [[row[t] for t in range(len(nm))]
                                  for row in Tt])
            J = TG.jacobian(A, vals, ceq, prods)
            ink = all(all(A.is_zero(c) for c in TG.contract(A, J, tv))
                      for tv in Tt)
            tab.append((j, part, r, ink))
            ck('lam=om^%d part %s : torus orbit is 3-dimensional (affine), '
               'tangent in ker J' % (j, part), r == 3 and ink)
    RES['torus'] = tab
    log('   => through EVERY one of the 27 classified points PO_1(7) contains')
    log('      a 2-dimensional (projective) rational (toric) subvariety.')
    log('      dim PO_1(7) >= 2 and PO_1(7) is INFINITE.')
    log()


# ===========================================================================
def sec4_tangent():
    log('## 4. Exact tangent spaces at the 27 classified points')
    log('   rank / corank of the 52 x 39 Jacobian over the exact residue field,')
    log('   refined by the Theta-eigenspace decomposition 39 = 13 + 13 + 13.')
    rows = []
    for j in range(3):
        for part in PT.PARTS:
            r = TG.run_point(j, part)
            pb = r['per_block']
            rows.append(r)
            log('   lam=om^%d part %s (%d pts, [L:K]=%d) : on-cone=%s po1=%s '
                'rank=%d corank=%d  block coranks (V1,Vom,Vom2)=(%d,%d,%d) '
                ' [%.0fs]'
                % (j, part, r['npts'], r['dimK']//4, r['on_cone'], r['po1_ok'],
                   r['rank'], r['corank'], pb[0][1], pb[1][1], pb[2][1],
                   r['secs']))
            ck('lam=om^%d part %s : point on the cone, plane orders (1,1,1)'
               % (j, part), r['on_cone'] and r['po1_ok'])
    RES['tangent'] = [{k: v for k, v in r.items() if k != 'po1'} for r in rows]
    bcd = [r for r in rows if r['part'] != 'A']
    a = [r for r in rows if r['part'] == 'A']
    ck('parts B,C,D (24 points): rank 34, corank 5 uniformly',
       all(r['rank'] == 34 and r['corank'] == 5 for r in bcd))
    ck('part A (3 points, one per block): rank 31, corank 8 uniformly',
       all(r['rank'] == 31 and r['corank'] == 8 for r in a))
    ck('parts B,C,D: own eigenblock corank 1 (the scalar) -- the FIX-N2C '
       'nine-point scheme is reduced there',
       all(r['per_block'][r['j']][1] == 1 for r in bcd))
    ck('part A: own eigenblock corank 2 -- the equivariant scheme is SINGULAR '
       'at the K-rational point',
       all(r['per_block'][r['j']][1] == 2 for r in a))
    log()


# ===========================================================================
def sec5_ob2():
    log('## 5. The level-0 Kuranishi obstruction  Ob_2(v) = 3 Phi(p,v,v)')
    log('   TC_p(cone) is contained in { v in ker J_p : Ob_2(v) = 0 in coker },')
    log('   so Ob_2 bounds the local dimension from above.')
    out = []
    for j in range(3):
        for part in PT.PARTS:
            A, nm, vals, ceq, prods = TG.prepare(j, part)
            n = len(nm)
            J = TG.jacobian(A, vals, ceq, prods)
            rk, pc, A2 = JJ.rank(A, J)
            ker = JJ.nullspace(A, J, (rk, pc, A2))
            # left null space of J = the cokernel functionals
            JT = [[J[i][t] for i in range(len(J))] for t in range(n)]
            rkT, pcT, _ = JJ.rank(A, JT)
            coker = JJ.nullspace(A, JT)
            assert rkT == rk
            Tt = TG.torus_tangent(A, vals)

            def obs(v, w):
                """3 Phi(p, v, w) symmetric polarisation, as a 52-vector."""
                res = []
                for _mon, terms in ceq:
                    s = A.zero()
                    for c, (i, jj, k) in terms:
                        t1 = A.mul(A.mul(v[i], w[jj]), vals[k])
                        t2 = A.mul(A.mul(w[i], v[jj]), vals[k])
                        t3 = A.mul(A.mul(v[i], vals[jj]), w[k])
                        t4 = A.mul(A.mul(w[i], vals[jj]), v[k])
                        t5 = A.mul(A.mul(vals[i], v[jj]), w[k])
                        t6 = A.mul(A.mul(vals[i], w[jj]), v[k])
                        s = A.add(s, A.mul(c, A.add(A.add(t1, t2),
                                                    A.add(A.add(t3, t4),
                                                          A.add(t5, t6)))))
                    res.append(s)
                return res

            def in_image(rhs):
                for y in coker:
                    s = A.zero()
                    for i in range(len(rhs)):
                        if not A.is_zero(y[i]):
                            s = A.add(s, A.mul(y[i], rhs[i]))
                    if not A.is_zero(s):
                        return False
                return True

            tors_ok = all(in_image(obs(tv, tv)) for tv in Tt)
            allz = True
            for a1 in range(len(ker)):
                for b1 in range(a1, len(ker)):
                    if not in_image(obs(ker[a1], ker[b1])):
                        allz = False
                        break
                if not allz:
                    break
            out.append((j, part, len(ker), 52 - rk, allz, tors_ok))
            log('   lam=om^%d part %s : dim ker=%d dim coker=%d ; torus '
                'unobstructed=%s ; Ob_2 == 0 identically on ker: %s'
                % (j, part, len(ker), 52 - rk, tors_ok, allz))
            ck('lam=om^%d part %s : the torus directions are unobstructed'
               % (j, part), tors_ok)
    RES['ob2'] = out
    ck('parts B,C,D: Ob_2 vanishes identically on ker J_p',
       all(o[4] for o in out if o[1] != 'A'))
    ck('part A: Ob_2 does NOT vanish identically (obstructed)',
       all(not o[4] for o in out if o[1] == 'A'))
    log()


# ===========================================================================
def sec6_bigcomponents():
    log('## 6. Explicit components of PO_1(7): the degenerate linear family')
    log('   T = (0, 0, u0\', u1\', 0)  has  F(T) = u0\' u1\' * 0 = 0 '
        'identically,')
    log('   for ARBITRARY u0\', u1\'; and its plane orders are (1,1,1) as soon')
    log('   as [x^6y]u1\' != 0, [xy^6]u0\' != 0 and ([xz^6]u0\' or [yz^6]u1\' '
        '!= 0).')
    names, eqs = L.landing_terms()
    sup = L.supports()
    slot_of = []
    for si in range(5):
        slot_of += [si]*len(sup[si])
    A = PT.part_algebra(0, 'A')       # residue field K itself
    n = len(names)
    tab = []
    for zero_slot, tag in ((4, "u2'"), (3, "u1'"), (2, "u0'")):
        vals = [A.zero()]*n
        # a reproducible K-rational member (small integer coefficients)
        cnt = 0
        for t in range(n):
            if slot_of[t] in (2, 3, 4) and slot_of[t] != zero_slot:
                cnt += 1
                vals[t] = A.of(sp.Integer(1 + (7*cnt) % 23))
        ceq = [(mon, [(A.of(c), idx) for c, idx in terms])
               for mon, terms in eqs]
        onc = all(A.is_zero(e) for e in TG.eq_values(A, vals, ceq))
        po = []
        for i, w in enumerate(L.po1_witnesses()):
            po.append(any(not A.is_zero(vals[names.index(nm)])
                          for nm, _s, _m in w))
        prods = [[A.mul(vals[a], vals[b]) for b in range(n)] for a in range(n)]
        J = TG.jacobian(A, vals, ceq, prods)
        rk, _, _ = JJ.rank(A, J)
        tab.append((tag, onc, all(po), rk, n - rk))
        ck("family a'=b'=%s=0 : F(T)=0 exactly, plane orders (1,1,1)" % tag,
           onc and all(po))
        ck("family a'=b'=%s=0 : exact corank 18 at a K-rational member "
           "(so the component is exactly this 18-dim linear space)" % tag,
           n - rk == 18, 'corank=%d' % (n - rk))
    RES['degenerate'] = tab
    log('   => three 17-dimensional PROJECTIVE linear components of PO_1(7).')
    log('      dim PO_1(7) >= 17.')
    log()


# ===========================================================================
def sec7_uv():
    log('## 7. The  u0 + v0  parameter check of Prop 5.3')
    log('   H1 frame: Lambda = [[ [x^6y]u1\', [x^6z]u1\' ],'
        ' [ [x^6y]u2\', [x^6z]u2\' ]] is diagonal;')
    log('   u0 := Lambda_yy = t0 = lam^-1 B8,   v0 := Lambda_zz = w0 '
        '= lam^-2 B5.')
    out = []
    for j in range(3):
        coords = E.classified_point(j)
        lam = kred(om**j)
        t0, w0, s5, s8 = (coords['t0'], coords['w0'], coords['s5'],
                          coords['s8'])
        g1, g2 = E.block_cubics(j)
        REL = [g2, g1, om**2 + om + 1, 8*kp**2 - 13*kp - 4]
        GENS = (P1s, B2s, om, kp)

        def red(e, REL=REL, GENS=GENS):
            e = sp.expand(e)
            if e == 0:
                return sp.Integer(0)
            _, r = sp.reduced(e, REL, *GENS, order='lex')
            return sp.expand(r)
        ck('lam=om^%d : structural identity  Lambda_yy = lam^-1 B8' % j,
           red(sp.expand(t0 - kred(lam**2)*s8)) == 0)
        ck('lam=om^%d : structural identity  Lambda_zz = lam^-2 B5' % j,
           red(sp.expand(w0 - lam*s5)) == 0)
        log('   lam=om^%d :  u0+v0 = %s' % (j, sp.factor(red(t0 + w0))))
        log('   lam=om^%d :  u0-v0 = %s   (the FIX-H1 order-0 equalizer)'
            % (j, sp.factor(red(t0 - w0))))
        for part in PT.PARTS:
            Ap = PT.part_algebra(j, part)
            vp = Ap.of(t0 + w0)
            vm = Ap.of(t0 - w0)
            ip, im = Ap.inv(vp), Ap.inv(vm)
            out.append((j, part, PT.npoints(part), ip is not None,
                        im is not None))
            ck('lam=om^%d part %s (%d pts) : u0+v0 != 0 '
               '(Nullstellensatz inverse exhibited)' % (j, part,
                                                        PT.npoints(part)),
               ip is not None)
            ck('lam=om^%d part %s (%d pts) : u0-v0 != 0 '
               '(independent recompute of FIX-H1-EQ-M1-EMPTY)'
               % (j, part, PT.npoints(part)), im is not None)
    RES['uv'] = out
    log('   => u0 + v0 != 0 at ALL 27 classified points.  The parameter '
        'exception')
    log('      in Prop 5.3 is EMPTY; only the finiteness hypothesis fails.')
    log()


# ===========================================================================
def main():
    log('# FIX-U1-FIN7 -- producer   (%s)' % time.strftime('%Y-%m-%d %H:%M'))
    log('# packet goal_runs_after_9094303/FIX_U1_FIN7')
    log()
    sec0_selftest()
    sec1_system()
    sec2_points()
    sec3_torus()
    sec4_tangent()
    sec5_ob2()
    sec6_bigcomponents()
    sec7_uv()
    log('## Summary')
    log('   checks failed: %d' % len(FAIL))
    for f in FAIL:
        log('     FAILED: %s' % f)
    log('   elapsed %.0f s' % (time.time() - T0))
    with open(os.path.join(HERE, 'logs', 'produce.log'), 'w') as f:
        f.write('\n'.join(LOG) + '\n')
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_results.json'),
              'w') as f:
        json.dump(RES, f, indent=1, default=str)
    print('FIX_U1_FIN7_PRODUCE_%s' % ('OK' if not FAIL else 'FAIL'))


if __name__ == '__main__':
    main()
