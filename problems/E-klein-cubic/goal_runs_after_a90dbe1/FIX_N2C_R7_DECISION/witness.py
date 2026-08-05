#!/usr/bin/env python3
"""FIX-N2C -- THE WITNESS.

An exact characteristic-zero, plane-order-1, triple-line-order-7,
residual-C3-equivariant (lam = 1) pointwise landing tuple.

    Ground field  K  = QQ(om, kp),  om^2+om+1 = 0,  8kp^2-13kp-4 = 0.
    Put  kap = kp + 2  ( = B^3 + B^-3 for the D_B parameter,
                         since (B^3-1)^2/B^3 = kp ),
         dl  = 2*om + 1 = om - om^2,   dl^2 = -3.

    Adjoin  c  and  v  with

        c^3 - 3 c  =  kap                                        (E_c)
        v^3 - 3 v  = -27/(4 kap)                                 (E_v)

    -- two Chebyshev cubics; c = s + s^-1 with s^3 = B^3, so c runs over
    B + B^-1, om B + om^2 B^-1, om^2 B + om B^-1.

    Then, in the normalisation  P0 = 1,

        B2 = dl * c
        P1 = 2 om / v
        B5 = om + ((om+2)/6) * B2 * P1

    and the remaining nine block coordinates are the K-linear expressions

        R0 = om B5 - om^2 P0            B1 = -B5
        R1 = -om P1                     B3 = -2 om B5 - (2om+4) P0
        B0 = -om^2 B5 - (om^2-1) P0     B4 = -B2
        B6 = om B5 - (om^2-1)P0 - (om^2+2)P1
        B7 = om B5 - (om^2-1)P0 - (om-1) P1
        B8 = om^2 B5 + (om^2-1) P0      ( = -B0 )

    Nine points (3 choices of c times 3 of v).  Every one satisfies F(T) = 0
    identically and has m = 1, r = 7.

The verification below is exact: everything is reduced modulo the Groebner
basis {E_c, E_v', om^2+om+1, 8kp^2-13kp-4} (leading monomials c^3, P1^3,
om^2, kp^2 -- pairwise coprime, hence a Groebner basis by Buchberger's first
criterion), and the 52 coefficient equations of F(T) = 0 are rebuilt from the
RAW Klein normal form by `indep_r7.py`.
"""
import sympy as sp

import indep_r7 as I
import point_tools as PT
from indep_r7 import om, kp, x, y, z

c, P1s = sp.symbols('c P1')
KAP = kp + 2
DL = 2*om + 1
OM2 = -1 - om

# E_v rewritten directly as the minimal polynomial of P1 = 2 om / v :
#   v^3 - 3v + 27/(4 kap) = 0   <=>   P1^3 - (8/9) om kap P1^2 + (32/27) kap = 0
REL = [P1s**3 - sp.Rational(8, 9)*om*KAP*P1s**2 + sp.Rational(32, 27)*KAP,
       c**3 - 3*c - KAP,
       om**2 + om + 1,
       8*kp**2 - 13*kp - 4]
GENS = (P1s, c, om, kp)


def red(e):
    e = sp.expand(e)
    if e == 0:
        return sp.Integer(0)
    _, r = sp.reduced(e, REL, *GENS, order='lex')
    return sp.expand(r)


def coordinates():
    P0 = sp.Integer(1)
    B2 = DL*c
    B5 = red(om + sp.Rational(1, 6)*(om + 2)*B2*P1s)
    v = {'P0': P0, 'P1': P1s, 'B2': B2, 'B5': B5}
    v['R0'] = red(om*B5 - OM2*P0)
    v['R1'] = red(-om*P1s)
    v['B0'] = red(-OM2*B5 - (OM2 - 1)*P0)
    v['B1'] = red(-B5)
    v['B3'] = red(-2*om*B5 - (2*om + 4)*P0)
    v['B4'] = red(-B2)
    v['B6'] = red(om*B5 - (OM2 - 1)*P0 - (OM2 + 2)*P1s)
    v['B7'] = red(om*B5 - (OM2 - 1)*P0 - (om - 1)*P1s)
    v['B8'] = red(OM2*B5 + (OM2 - 1)*P0)
    return v


def run(check=None):
    def ck(name, cond, extra=''):
        if check:
            check(name, cond, extra)
        else:
            print('%-58s %s %s' % (name, 'OK ' if cond else 'FAIL', extra))
        return cond

    vals = coordinates()
    lam = sp.Integer(1)
    names, T, eqs = I.landing_equations(7, 1, lam)
    sub = {sp.Symbol(n): vals[n] for n in names}

    # (a) the landing identity, all 52 coefficient equations
    bad = [m for m, cf in eqs if red(sp.expand(cf.subs(sub))) != 0]
    ck('  witness: F(T) = 0, all 52 coefficient equations', not bad,
       '(%d nonzero)' % len(bad))

    # (b) residual C3-equivariance,  psi(T) = lam * g(T)
    Tv = [red(sp.expand(comp.subs(sub))) for comp in T]
    tgt = [red(om*Tv[0]), red(om**2*Tv[1]), Tv[3], Tv[4], Tv[2]]
    eq = all(red(sp.expand(I.psi(cc) - tt)) == 0 for cc, tt in zip(Tv, tgt))
    ck('  witness: psi(T) = g(T)   (residual C3, lam = 1)', eq)

    # (c) F(T) = 0 as a raw polynomial identity in x,y,z (independent path)
    F = sp.expand(I.F_klein(Tv))
    if F != 0:
        P = sp.Poly(F, x, y, z)
        F = sp.expand(sum(red(cf)*x**m[0]*y**m[1]*z**m[2]
                          for m, cf in zip(P.monoms(), P.coeffs())))
    ck('  witness: raw Klein normal form F(T) vanishes identically', F == 0)

    # (d) the invariants: r = 7 exactly, m = 1 exactly, all three planes
    orders, degs = [], set()
    for comp in Tv:
        if comp == 0:
            continue
        P = sp.Poly(comp, x, y, z)
        for mono, cf in zip(P.monoms(), P.coeffs()):
            if red(cf) == 0:
                continue
            A, B, C = mono
            degs.add(A + B + C)
            orders.append((B + C, A + C, A + B))
    ordP = tuple(min(o[i] for o in orders) for i in range(3))
    m = min(ordP)
    ck('  witness: triple-line order r = 7 exactly', degs == {7}, str(sorted(degs)))
    ck('  witness: common plane order m = 1 exactly', m == 1,
       '(ord_P1,ord_P2,ord_P3) = %s' % (ordP,))

    # (e) it is NOT in the G*D_B(X) class: both a' and b' are nonzero
    ck("  witness: a' != 0 and b' != 0 (outside the D_B / mirror class)",
       Tv[0] != 0 and Tv[1] != 0)

    # (f) primitivity: the five components have no common polynomial factor
    g = Tv[0]
    for comp in Tv[1:]:
        g = sp.gcd(g, comp)
    ck('  witness: gcd of the five components is a unit (primitive)',
       sp.total_degree(sp.expand(g), x, y, z) == 0, 'gcd = %s' % g)

    # (g) Corollary N2C-2: q = x^2+y^2+z^2 is A_4-invariant with ord_{P_i} q = 0,
    #     so q^k T is again a landing family with m = 1 and r = 7 + 2k.
    q = x**2 + y**2 + z**2
    ck('  corollary: q = x^2+y^2+z^2 is psi-invariant', sp.expand(I.psi(q) - q) == 0)
    qo = min(min(b + c2, a + c2, a + b)
             for a, b, c2 in sp.Poly(q, x, y, z).monoms())
    ck('  corollary: ord_{P_i}(q) = 0 for every i', qo == 0)
    for k in (1, 2):
        QT = [sp.expand(q**k*comp) for comp in Tv]
        FQ = sp.expand(I.F_klein(QT))
        if FQ != 0:
            P = sp.Poly(FQ, x, y, z)
            FQ = sp.expand(sum(red(cf)*x**m2[0]*y**m2[1]*z**m2[2]
                               for m2, cf in zip(P.monoms(), P.coeffs())))
        oq, dq = [], set()
        for comp in QT:
            if comp == 0:
                continue
            P = sp.Poly(comp, x, y, z)
            for mono, cf in zip(P.monoms(), P.coeffs()):
                if red(cf) == 0:
                    continue
                a, b, c2 = mono
                dq.add(a + b + c2)
                oq.append(min(b + c2, a + c2, a + b))
        ck('  corollary: q^%d * T lands, m = 1, r = %d  ==> (1,%d) POPULATED'
           % (k, 7 + 2*k, 7 + 2*k),
           FQ == 0 and min(oq) == 1 and dq == {7 + 2*k},
           '(m=%d, r=%s)' % (min(oq), sorted(dq)))
    return vals, Tv


if __name__ == '__main__':
    vals, Tv = run()
    print()
    print('The witness, in the normalisation P0 = 1 '
          '(dl = 2om+1, kap = kp+2, c^3-3c = kap, '
          '27 P1^3 - 24 om kap P1^2 + 32 kap = 0):')
    for k in ['P0', 'P1', 'R0', 'R1', 'B0', 'B1', 'B2', 'B3', 'B4',
              'B5', 'B6', 'B7', 'B8']:
        print('   %-3s = %s' % (k, sp.factor(vals[k])))
    print()
    for nm, comp in zip(["a'", "b'", "u0'", "u1'", "u2'"], Tv):
        print('   %-4s = %s' % (nm, sp.factor(comp)))
