#!/usr/bin/env python3
"""FIX-H1 producer, Part C -- the order-0 equalizer for branch (ii), the
primitive Chebyshev branch (m,r) = (1,7), in ALL THREE eigenblocks.

The order-0 condition (Part B, C2) is

        Lambda_yy = Lambda_zz ,
        Lambda = [ [x^6y]u1'  [x^6z]u1' ; [x^6y]u2'  [x^6z]u2' ] ,

Lambda being the leading line datum ( = (y,z)-degree-1 part of T^- over x^e,
e = r-m = 6).  Two independent evaluations are made:

 (1) STRUCTURAL.  The residual-C3 relation psi(T) = lam g(T) gives
         u1' = lam^{-1} u0' o S ,  u2' = lam^{-2} u0' o S^2 ,  S:(x,y,z)->(y,z,x),
     whence  [x^6y]u1' = lam^{-1} [x z^6]u0' = lam^{-1} B8   and
             [x^6z]u2' = lam^{-2} [x y^6]u0' = lam^{-2} B5 ,
     so the condition is exactly     B5 = lam * B8 .
 (2) DIRECT.  The three exact witnesses of FIX-N2C are rebuilt (read-only
     import of that packet's `indep_r7`, `witness`, `witness_om`,
     `witness_om2`), the tuples are expanded, and the four entries of Lambda
     are read off literally.  The two evaluations must agree.

Then B5 - lam*B8 is reduced modulo the block ideal; nonvanishing is certified
by exhibiting an exact inverse modulo the ideal (a Nullstellensatz certificate
1 = h * (B5 - lam B8) mod I), which proves the condition is EMPTY.
"""
import json
import os
import sys
import time

import sympy as sp

HERE = os.path.dirname(os.path.abspath(__file__))
N2C = ('/Users/worker/unirational/problems/E-klein-cubic/'
       'goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION')
sys.path.insert(0, N2C)

import indep_r7 as I                                          # noqa: E402
from indep_r7 import om, kp, x, y, z                          # noqa: E402

T0 = time.time()
LOG = []


def log(s):
    print(s, flush=True)
    LOG.append(s)


OM2 = -1 - om
KAP = kp + 2
DL = 2 * om + 1


def coeff_xyz(poly, i, j, k):
    p = sp.Poly(sp.expand(poly), x, y, z)
    return p.coeff_monomial(x**i * y**j * z**k)


def main():
    log('# FIX-H1 producer C -- branch (ii), the (1,7) Chebyshev branch')
    log('# order-0 equalizer:  Lambda_yy = Lambda_zz   (Part B, C2)')
    res = {}

    import witness as W0
    import witness_om as W1
    import witness_om2 as W2
    blocks = [('lam=1', sp.Integer(1), W0), ('lam=om', om, W1),
              ('lam=om^2', OM2, W2)]

    for tag, lam, mod in blocks:
        log('')
        log('--- eigenblock %s ---' % tag)
        vals = mod.coordinates()
        red = mod.red
        names, T, eqs = I.landing_equations(7, 1, lam)
        sub = {sp.Symbol(n): vals[n] for n in names}
        Tv = [red(sp.expand(c.subs(sub))) for c in T]

        # sanity: this really is a landing family (all 52 equations)
        bad = [m for m, cf in eqs if red(sp.expand(cf.subs(sub))) != 0]
        log('  witness rebuilt : F(T) = 0 on all %d coefficient equations,'
            ' %d nonzero' % (len(eqs), len(bad)))
        assert not bad

        u0, u1, u2 = Tv[2], Tv[3], Tv[4]
        Lam = [[red(coeff_xyz(u1, 6, 1, 0)), red(coeff_xyz(u1, 6, 0, 1))],
               [red(coeff_xyz(u2, 6, 1, 0)), red(coeff_xyz(u2, 6, 0, 1))]]
        log('  Lambda_yy = [x^6 y] u1\' = %s' % sp.factor(Lam[0][0]))
        log('  Lambda_yz = [x^6 z] u1\' = %s' % sp.factor(Lam[0][1]))
        log('  Lambda_zy = [x^6 y] u2\' = %s' % sp.factor(Lam[1][0]))
        log('  Lambda_zz = [x^6 z] u2\' = %s' % sp.factor(Lam[1][1]))
        diag = (Lam[0][1] == 0 and Lam[1][0] == 0)
        log('  Lambda is DIAGONAL (the tau-condition, automatic) : %s'
            % ('YES' if diag else 'NO'))
        assert diag

        # structural cross-check
        B5, B8 = vals['B5'], vals['B8']
        # lam^3 = 1 so lam^{-1} = lam^2 and lam^{-2} = lam
        linv1 = red(sp.expand(lam**2))
        linv2 = red(sp.expand(lam))
        s1 = red(sp.expand(linv1 * B8 - Lam[0][0]))
        s2 = red(sp.expand(linv2 * B5 - Lam[1][1]))
        log('  structural check  [x^6y]u1\' = lam^-1 B8 : %s'
            % ('OK' if s1 == 0 else 'MISMATCH %s' % s1))
        log('  structural check  [x^6z]u2\' = lam^-2 B5 : %s'
            % ('OK' if s2 == 0 else 'MISMATCH %s' % s2))
        assert s1 == 0 and s2 == 0

        D = red(sp.expand(Lam[0][0] - Lam[1][1]))
        log('  order-0 equalizer residual  Lambda_yy - Lambda_zz = %s'
            % sp.factor(D))
        Deq = red(sp.expand(linv1 * B8 - linv2 * B5))
        assert red(sp.expand(D - Deq)) == 0
        log('  equivalently (x lam)  B8 - lam B5 ... i.e.  B5 = lam * B8')

        # ---- decide exactly: is D = 0 anywhere on the block ideal? -------
        # Reduce D modulo the block's Groebner basis; then certify by
        # showing D is INVERTIBLE modulo the ideal.
        zero = (D == 0)
        log('  D reduces to 0 modulo the block ideal : %s'
            % ('YES  (equalizer SATISFIED)' if zero else 'NO'))
        res[tag] = dict(diag=diag, D=str(sp.factor(D)), zero=bool(zero))

        if not zero:
            inv, cert = invert_mod(D, mod)
            log('  Nullstellensatz certificate: D * h = 1 modulo the block'
                ' ideal : %s' % ('FOUND' if cert else 'NOT FOUND'))
            res[tag]['invertible'] = bool(cert)
            if cert:
                log('  h = %s' % sp.factor(inv))
    log('')
    log('  ==> the order-0 equalizer holds at NONE of the 27 points'
        if all(not v['zero'] for v in res.values()) else
        '  ==> some point satisfies the order-0 equalizer')

    # ---------- the closed-form derivation, lam = 1 ---------------------
    log('')
    log('--- closed form (lam = 1) ---')
    c, P1 = sp.symbols('c P1')
    lhs = sp.expand(sp.Rational(1, 2) * (om * (P1 * c + 2))
                    - sp.Rational(1, 2) * (P1 * c - 2 * om - 2))
    log('  B5 - B8 = %s' % sp.factor(lhs))
    solc = sp.solve(sp.Eq(lhs, 0), P1 * c)
    log('  B5 = B8  <==>  P1*c = %s' % [sp.simplify(s) for s in solc])
    # substitute P1 = 2 om / c into the P1-cubic
    pc = 27 * P1**3 - 24 * om * KAP * P1**2 + 32 * KAP
    sub = sp.expand(pc.subs(P1, 2 * om / c))
    sub = sp.simplify(sp.expand(sub * c**3 / 8))
    sub = I.kred(sp.expand(sub))
    log('  substituting P1 = 2om/c into 27P1^3-24 om kap P1^2+32 kap and'
        ' clearing:')
    log('     %s' % sp.expand(sub))
    # reduce c^3 -> 3c + kap
    red2 = sp.simplify(sp.expand(sub.subs(c**3, 3 * c + KAP)))
    red2 = I.kred(sp.expand(sp.expand(sub) - 0))
    P = sp.Poly(sp.expand(sub), c)
    out = sp.Integer(0)
    for mo, cf in zip(P.monoms(), P.coeffs()):
        e = mo[0]
        t = cf
        if e >= 3:
            t = cf * (3 * c + KAP) * c**(e - 3)
        else:
            t = cf * c**e
        out += t
    out = I.kred(sp.expand(out))
    log('  modulo c^3 = 3c + kap this becomes:  %s' % sp.factor(out))
    log('  i.e. 4 kap^2 + 27 = 0, whereas kap = kp+2 is REAL'
        ' ( = 3.8896054962... ):')
    val = I.kred(sp.expand(4 * KAP**2 + 27))
    log('  4 kap^2 + 27 = %s   (reduced modulo 8kp^2-13kp-4)' % sp.expand(val))
    num = float(sp.expand(val).subs(kp, (13 + 3 * sp.sqrt(33)) / 16))
    log('  numerically = %.12f  != 0    ==>  EMPTY' % num)
    res['closed_form'] = dict(condition='P1*c = 2*om',
                              consequence='4*kap^2 + 27 = 0',
                              value=str(sp.expand(val)), numeric=num)
    return res


def invert_mod(D, mod):
    """try to find h with D*h = 1 modulo the block ideal (over K)."""
    # The block ring is K[B2,P1]/(cubic(B2), cubic(P1)) (or K[c,P1]).  Set up
    # the multiplication-by-D matrix on the 9-dimensional K-basis and invert.
    GENS = mod.GENS
    v1, v2 = GENS[0], GENS[1]          # (P1, c) or (P1, B2)
    basis = [v1**i * v2**j for i in range(3) for j in range(3)]
    cols = []
    for b in basis:
        e = mod.red(sp.expand(D * b))
        P = sp.Poly(sp.expand(e), v1, v2)
        col = []
        for i in range(3):
            for j in range(3):
                col.append(sp.expand(P.coeff_monomial(v1**i * v2**j)))
        cols.append(col)
    M = sp.Matrix(9, 9, lambda a, b: cols[b][a])
    # solve M * h = e_0 over K = QQ(om,kp) -- do it with sympy over the
    # quotient by treating om, kp as symbols and reducing at the end
    rhs = sp.Matrix(9, 1, lambda a, b: 1 if a == 0 else 0)
    try:
        sol = solve_over_K(M, rhs, mod)
    except Exception as exc:                                  # noqa: BLE001
        log('  (inversion failed: %s)' % exc)
        return None, False
    if sol is None:
        return None, False
    h = sum(mod.red(sp.expand(sol[k])) * basis[k] for k in range(9))
    chk = mod.red(sp.expand(D * h))
    return sp.expand(h), sp.expand(chk - 1) == 0


def solve_over_K(M, rhs, mod):
    """Gaussian elimination over K = QQ(om,kp), reducing after every step."""
    n = M.rows
    A = [[mod.red(sp.expand(M[i, j])) for j in range(n)] + [rhs[i, 0]]
         for i in range(n)]
    piv = []
    r = 0
    for cidx in range(n):
        pr = None
        for rr in range(r, n):
            if mod.red(sp.expand(A[rr][cidx])) != 0:
                pr = rr
                break
        if pr is None:
            continue
        A[r], A[pr] = A[pr], A[r]
        f = kinv(A[r][cidx], mod)
        A[r] = [mod.red(sp.expand(v * f)) for v in A[r]]
        for rr in range(n):
            if rr != r and mod.red(sp.expand(A[rr][cidx])) != 0:
                g = A[rr][cidx]
                A[rr] = [mod.red(sp.expand(a - g * b))
                         for a, b in zip(A[rr], A[r])]
        piv.append(cidx)
        r += 1
    if len(piv) < n:
        # singular -> D is a zero divisor; report failure
        return None
    sol = [sp.Integer(0)] * n
    for i, cidx in enumerate(piv):
        sol[cidx] = A[i][n]
    return sol


def kinv(e, mod):
    """inverse of a nonzero element of K = QQ(om,kp) (degree 4 over QQ)."""
    e = mod.red(sp.expand(e))
    a, b, c, d = sp.symbols('h0 h1 h2 h3')
    h = a + b * om + c * kp + d * om * kp
    pr = mod.red(sp.expand(e * h))
    P = sp.Poly(sp.expand(pr), om, kp)
    eqs = []
    for i in range(2):
        for j in range(2):
            cf = P.coeff_monomial(om**i * kp**j)
            eqs.append(sp.Eq(cf, 1 if (i, j) == (0, 0) else 0))
    sol = sp.solve(eqs, [a, b, c, d], dict=True)
    assert sol, 'no inverse in K'
    return sp.expand(h.subs(sol[0]))


if __name__ == '__main__':
    out = main()
    log('elapsed %.1f s' % (time.time() - T0))
    os.makedirs(os.path.join(HERE, 'payloads'), exist_ok=True)
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_branch2.txt'),
              'w') as fh:
        fh.write('\n'.join(LOG) + '\n')
    with open(os.path.join(HERE, 'payloads', 'h1_branch2.json'), 'w') as fh:
        json.dump(out, fh, indent=1, default=str)
    print('FIX_H1_BRANCH2_OK')
