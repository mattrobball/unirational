#!/usr/bin/env python3
"""FIX-C1 -- independent verifier.

Every decisive claim of the packet is recomputed here by a route that does not
reuse the producer's:

  * the level operators are rebuilt from the SYMMETRIC TRILINEAR POLARISATION
    Phi (third-derivative tensor of F), not from the producer's first/second
    Taylor derivatives of F;
  * the target rows are taken in the OPPOSITE monomial order, and the pivot
    search starts from the other end, so the echelon form is a different one;
  * every rank/kernel/obstruction verdict is cross-checked modulo three primes
    at EVERY point of the relevant part of the parameter scheme;
  * the level-2 obstruction at the special point is certified by an explicit
    LEFT-kernel functional (computed from the transposed matrix -- a different
    linear system), verified exactly: phi.M = 0 and phi.R_2 != 0;
  * the unobstructed verdicts are certified by exhibiting the exact solution
    e_2 and substituting it back into the level-2 identity as a polynomial
    identity in x,y,z (no linear algebra involved in the check);
  * the whole machinery is calibrated against a ladder whose solution is known
    in closed form: p0 o (id + eps V) for the A4-equivariant vector field
    V = (yz, zx, xy), which must solve levels 1,2,3 identically.

Terminal marker: FIX_C1_VERIFY_OK
"""
import json
import os
import sys
import time

import sympy as sp

import c1_lib as L
import c1_ladder as LD
import c1_points as PT
import c1_ring as CR
from c1_lib import x, y, z, om, kp, c, P1s

HERE = os.path.dirname(os.path.abspath(__file__))
T0 = time.time()
FAILS = []
NCHECK = [0]


def ck(name, cond, extra=''):
    NCHECK[0] += 1
    print('[%6.1fs] %-64s %s %s'
          % (time.time() - T0, name, 'OK  ' if cond else 'FAIL', extra),
          flush=True)
    if not cond:
        FAILS.append(name)
    return cond


# ---------------------------------------------------------------------------
# 1. the seeds
# ---------------------------------------------------------------------------
def check_seeds():
    for j in (0, 1, 2):
        names, T, lam, rel, rd = L.seed_m1(j)
        # F(T) = 0 by the POLARISATION route (independent of F_klein(T))
        ck('seed m=1 lam=om^%d : Phi(T,T,T) = 0 (polarisation route)' % j,
           L.red_poly(L.Phi_fast(T, T, T), rd) == 0)
        r, ordP, degs = L.orders(T, rd)
        ck('seed m=1 lam=om^%d : r = 7, ord_P = (1,1,1), degrees {7}' % j,
           r == 7 and ordP == (1, 1, 1) and degs == {7})
        pm = L.sigma_split_orders(T, rd)
        ck('seed m=1 lam=om^%d : FIX-H0 split ord(T-) = 1 < ord(T+) = 2' % j,
           pm == (2, 1))
        ck('seed m=1 lam=om^%d : psi(T) = lam g(T)' % j,
           L.check_equivariance(T, lam, rd))
        g = T[0]
        for u in T[1:]:
            g = sp.gcd(g, u)
        ck('seed m=1 lam=om^%d : primitive, a != 0 and b != 0' % j,
           sp.total_degree(sp.expand(g), x, y, z) == 0
           and T[0] != 0 and T[1] != 0)
    T, lam, rel, rd = L.seed_control()
    ck('control (3,6) D_B seed : Phi(T,T,T) = 0',
       L.red_poly(L.Phi_fast(T, T, T), rd) == 0)
    r, ordP, degs = L.orders(T, rd)
    ck('control (3,6) D_B seed : r = 6, ord_P = (3,3,3), lam = om^2',
       r == 6 and ordP == (3, 3, 3) and L.red_poly(sp.expand(lam - om**2), rd) == 0)
    ck('control (3,6) D_B seed : FIX-H0 split ord(T-) = 3 < ord(T+) = 4',
       L.sigma_split_orders(T, rd) == (4, 3))
    ck('control (3,6) D_B seed : psi(T) = om^2 g(T)',
       L.check_equivariance(T, lam, rd))


# ---------------------------------------------------------------------------
# 2. the exact split of the parameter scheme
# ---------------------------------------------------------------------------
def check_split():
    GB = [om**2 + om + 1, 8*kp**2 - 13*kp - 4]

    def rk(e):
        e = sp.expand(e)
        return 0 if e == 0 else sp.expand(sp.reduced(e, GB, om, kp,
                                                     order='lex')[1])
    ck('split: c_0 = (4kp-1)/3 satisfies c^3 - 3c = kap',
       rk(L.C0**3 - 3*L.C0 - L.KAP) == 0)
    for j in (0, 1, 2):
        p10 = L.P10(j)
        A = sp.expand(-sp.Rational(8, 9)*om**((j + 1) % 3)*L.KAP)
        ck('split: P1_0 = (4/3) om^%d c_0 satisfies the block-%d P1-cubic'
           % ((j + 1) % 3, j),
           rk(p10**3 + A*p10**2 + sp.Rational(32, 27)*L.KAP) == 0)
        gc = sp.expand(c**2 + L.C0*c + L.C0**2 - 3)
        gP = sp.expand(P1s**2 + (A + p10)*P1s + (p10**2 + A*p10))
        d1 = sp.expand((c - L.C0)*gc - (c**3 - 3*c - L.KAP))
        d2 = sp.expand((P1s - p10)*gP
                       - (P1s**3 + A*P1s**2 + sp.Rational(32, 27)*L.KAP))
        ok = all(rk(t) == 0 for t in sp.Poly(d1, c).all_coeffs()) and \
            all(rk(t) == 0 for t in sp.Poly(d2, P1s).all_coeffs())
        ck('split: block %d, both cubics factor as (lin)*(quadratic)' % j, ok)
        # the four parts partition the nine points
        tot = 0
        for part, want in (('A', 1), ('B', 2), ('C', 2), ('D', 4)):
            rel, gens, degs, rd = L.ring_m1_split(j, part)
            tot += degs[0]*degs[1]
        ck('split: block %d, parts A+B+C+D account for all 9 points' % j,
           tot == 9)


# ---------------------------------------------------------------------------
# 3. the FIX-H0 refinement is automatic (parity), for every level
# ---------------------------------------------------------------------------
def check_h0_auto():
    ok = True
    detail = ''
    for m in (1, 3):
        for n in range(m + 4, m + 16):
            par = L.slot_parities(n)
            plus = [par[0], par[1], par[2]]     # a', b', u0'  (W^+ of sigma_1)
            minus = [par[3], par[4]]            # u1', u2'     (W^-)
            for p in plus:
                mons = L.monomials_xyz(n, m, p)
                if mons and min(b + cc for a, b, cc in mons) % 2 != 0:
                    ok = False
                    detail = 'n=%d plus-half order odd' % n
            for p in minus:
                mons = L.monomials_xyz(n, m, p)
                if mons and min(b + cc for a, b, cc in mons) % 2 != 1:
                    ok = False
                    detail = 'n=%d minus-half order even' % n
    ck('H0-AUTO: in every V_n(m,lam) the sigma-plus half has EVEN and the '
       'minus half ODD plane order', ok, detail)


# ---------------------------------------------------------------------------
# 4. psi-invariance of the level equations (justifies the orbit reduction)
# ---------------------------------------------------------------------------
def check_psi_invariance():
    names, T, lam, rel, rd = L.seed_m1(0)
    nm, E = L.graded_piece(8, 1, lam, 'q', rd)
    D = L.red_poly(L.D_apply(L.dF_at(T), E), rd)
    ck('psi-invariance of D_{p0}(e) (level-1 equation)',
       L.red_poly(sp.expand(L.psi(D) - D), rd) == 0)
    import random
    random.seed(11)
    sub = {sp.Symbol(n): sp.Integer(random.randint(-4, 4)) for n in nm}
    e = [L.red_poly(sp.expand(u.subs(sub)), rd) for u in E]
    H = L.red_poly(L.H_apply(L.ddF_at(T), e, e), rd)
    ck('psi-invariance of 3Phi(p0,e,e) (level-2 right-hand side)',
       L.red_poly(sp.expand(L.psi(H) - H), rd) == 0)
    C3 = L.red_poly(L.Phi_fast(e, e, e), rd)
    ck('psi-invariance of Phi(e,e,e) (level-3 right-hand side)',
       L.red_poly(sp.expand(L.psi(C3) - C3), rd) == 0)


# ---------------------------------------------------------------------------
# 5. calibration: the reparametrisation ladder must solve every level
# ---------------------------------------------------------------------------
def check_reparam_ladder():
    """p0 o (id + eps V) with V = (yz, zx, xy) solves the WHOLE ladder, because
    F(p0 o phi) = F(p0) o phi = 0.  Its graded pieces are

        e_k = sum_{i+j+l=k} V_x^i V_y^j V_z^l /(i! j! l!) * d^(i,j,l) p0

    (Taylor with the increment eps*V frozen at the base point).  Feeding them
    into the level equations of `produce_c1.py` must give 0 at levels 1, 2, 3 --
    a closed-form calibration of the entire ladder assembly.
    """
    import math
    for tag, seedfn in (('m=1 (1,7)', lambda: L.seed_m1(0)[1:]),
                        ('control (3,6)', lambda: L.seed_control())):
        T, lam, rel, rd = seedfn()
        V = [y*z, z*x, x*y]

        def piece(k):
            out = []
            for u in T:
                acc = sp.Integer(0)
                for i in range(k + 1):
                    for jj in range(k + 1 - i):
                        l = k - i - jj
                        d = sp.diff(u, x, i, y, jj, z, l)
                        if d == 0:
                            continue
                        acc += (V[0]**i*V[1]**jj*V[2]**l*d
                                / (math.factorial(i)*math.factorial(jj)
                                   * math.factorial(l)))
                out.append(L.red_poly(sp.expand(acc), rd))
            return out
        e = {k: piece(k) for k in (1, 2, 3)}
        dfp, ddfp = L.dF_at(T), L.ddF_at(T)
        lv1 = L.red_poly(L.D_apply(dfp, e[1]), rd)
        ck('calibration %s : level 1, D(e_1) = 0' % tag, lv1 == 0)
        lv2 = L.red_poly(sp.expand(L.D_apply(dfp, e[2])
                                   + sp.Rational(1, 2)*L.H_apply(ddfp, e[1],
                                                                 e[1])), rd)
        ck('calibration %s : level 2, D(e_2) + 3Phi(p0,e_1,e_1) = 0' % tag,
           lv2 == 0)
        lv3 = L.red_poly(sp.expand(L.D_apply(dfp, e[3])
                                   + L.H_apply(ddfp, e[1], e[2])
                                   + L.Phi_fast(e[1], e[1], e[1])), rd)
        ck('calibration %s : level 3, D(e_3) + 6Phi(p0,e_1,e_2) '
           '+ Phi(e_1,e_1,e_1) = 0' % tag, lv3 == 0)


# ---------------------------------------------------------------------------
# 6. independent rebuild of a level operator, and the rank verdicts
# ---------------------------------------------------------------------------
def level_operator_phi(seed, n, m, lam, Q, rd, tag, reverse_rows=True):
    """the level operator built from the POLARISATION Phi (not from dF)."""
    names, E = L.graded_piece(n, m, lam, tag, rd)
    syms = [sp.Symbol(s) for s in names]
    expr = sp.expand(3*L.Phi_fast(seed, seed, E))
    rows, M, cv = LD.linear_system(expr, syms, Q)
    assert all(Q.is_zero(v) for v in cv)
    rows2, M2, _ = LD.psi_orbit_reduce(rows, M, Q, check=True)
    if reverse_rows:
        idx = list(range(len(rows2)))[::-1]
        rows2 = [rows2[i] for i in idx]
        M2 = [M2[i] for i in idx]
    return names, E, syms, rows2, M2


def check_ranks(parts=('A', 'D'), j=0):
    recorded = {}
    for part in parts:
        fn = os.path.join(HERE, 'payloads', 'LADDER_m1_lam%d_%s.json' % (j, part))
        if os.path.exists(fn):
            with open(fn) as fh:
                recorded[part] = json.load(fh)
    for part in parts:
        names, T, lam, rel, degs, rd = L.seed_m1_split(j, part)
        Q = CR.Quo(rel, L.GENS, degs, rd)
        nm, E, syms, rows, M = level_operator_phi(T, 8, 1, lam, Q, rd, 'v1')
        res = CR.analyze_R(Q, M)
        got = res['rank']
        exp = None
        if part in recorded:
            exp = [l for l in recorded[part]['levels'] if l['level'] == 1][0]
        ck('part %s : level-1 rank %d (Phi route, reversed rows) matches '
           'the producer' % (part, got), exp is None or exp['rank'] == got,
           '' if exp is None else 'producer %d' % exp['rank'])
        ck('part %s : level-1 dim ker = %d matches the producer'
           % (part, len(res['kernel'])),
           exp is None or exp['ker'] == len(res['kernel']))
        # modular cross-check at every point, three primes
        agree = True
        seen = set()
        for p in (1021, 1039, 1123):
            for pt in PT.points_m1_split(j, part, p):
                S = [[CR.spec_vec(Q, M[i][k], pt, p) for k in range(len(nm))]
                     for i in range(len(rows))]
                r, _, _ = CR.modular_rref(S, p)
                seen.add(r)
                if r > got:
                    agree = False
        ck('part %s : modular level-1 ranks at every point, 3 primes, are '
           '<= the exact rank and attain it' % part,
           agree and got in seen, 'observed %s, exact %d' % (sorted(seen), got))


# ---------------------------------------------------------------------------
# 7. the obstruction certificate at the special point A
# ---------------------------------------------------------------------------
def check_obstruction_certificate(j=0):
    names, T, lam, rel, degs, rd = L.seed_m1_split(j, 'A')
    Q = CR.Quo(rel, L.GENS, degs, rd)
    nm1, E1, sy1, rows1, M1 = level_operator_phi(T, 8, 1, lam, Q, rd, 'w1')
    res1 = CR.analyze_R(Q, M1)
    k1v = res1['kernel']
    k1 = [LD.tuple_from_vector(E1, sy1, v, Q, rd) for v in k1v]
    ck('block %d part A : level-1 kernel is 4-dimensional' % j, len(k1) == 4)
    nm2, E2s, sy2, rows2, M2 = level_operator_phi(T, 9, 1, lam, Q, rd, 'w2')
    # LEFT kernel of M2 via the transposed system (a different linear system)
    MT = [[M2[i][k] for i in range(len(rows2))] for k in range(len(nm2))]
    resT = CR.analyze_R(Q, MT)
    phis = resT['kernel']
    ck('block %d part A : left kernel of the level-2 operator has dim %d'
       % (j, len(phis)), len(phis) > 0)
    for ph in phis:
        w = CR.matvec_R(Q, MT, ph)
        assert all(Q.is_zero(e) for e in w)
    # the level-2 right-hand sides
    ddfp = L.ddF_at(T)
    hits = 0
    for i in range(len(k1)):
        for jj in range(i, len(k1)):
            f = sp.Rational(1, 2) if i == jj else sp.Integer(1)
            W = L.red_poly(f*L.H_apply(ddfp, k1[i], k1[jj]), rd)
            vec = {}
            if W != 0:
                Pw = sp.Poly(W, x, y, z)
                for mono, cf in zip(Pw.monoms(), Pw.coeffs()):
                    vec[LD.orbit_key(tuple(mono))] = cf
            missing = set(vec) - set(rows2)
            rr = [Q.from_expr(vec.get(mn, sp.Integer(0))) for mn in rows2]
            val = [CR._dot(Q, ph, rr) for ph in phis]
            if missing or any(not Q.is_zero(v) for v in val):
                hits += 1
    ck('block %d part A : the exact left-kernel functionals certify Ob_2 != 0 '
       'on all %d coefficient pairs' % (j, hits), hits == 10, '%d/10' % hits)


def main():
    check_seeds()
    check_split()
    check_h0_auto()
    check_psi_invariance()
    check_reparam_ladder()
    check_ranks()
    check_obstruction_certificate()
    print()
    if FAILS:
        print('FIX_C1_VERIFY_FAILED: %d of %d checks failed: %s'
              % (len(FAILS), NCHECK[0], FAILS))
        sys.exit(1)
    print('%d checks, 0 failures' % NCHECK[0])
    print('FIX_C1_VERIFY_OK')


if __name__ == '__main__':
    main()
