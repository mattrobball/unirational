#!/usr/bin/env python3
"""FIX-H2 TASK A, structural analysis (the director's type-II anchor hint).

Checks, against the ACTUAL generators rather than against the narrative:

 1. the vertex P_1 = (y,z) order-0 part of the landing equation.  For r even
    the components are a' = P(U,V,W), b' = R(U,V,W), u_0' = yz B0, u_1' = zx B1,
    u_2' = xy B2, and every term of
        F = kp a'^3 + km b'^3 + a'(u0'^2+om u1'^2+om^2 u2'^2)
                              + b'(u0'^2+om^2 u1'^2+om u2'^2) + u0'u1'u2'
    other than the first two carries a factor y or z (u0'^2 has y^2z^2,
    u1'^2 has z^2, u2'^2 has y^2, u0'u1'u2' has x^2y^2z^2).  Hence the pure
    x^{3r} coefficient of F is
        C(A,B) = kp*A^3 + km*B^3 ,   A = [U^{r/2}]P ,  B = [U^{r/2}]R ,
    a BINARY CUBIC in the two x^r-coefficients of the a'- and b'-slots.
 2. whether C is irreducible over K = QQ(om,kp) = QQ(sqrt-3,sqrt33) -- i.e.
    whether the anchor really forces a degree-3 extension (type-II point).
 3. the grading lattice of the licensed system: all integer weight vectors w
    for which every generator is w-homogeneous.
 4. what C looks like in the (X,Y) coordinates and after the licence's
    substitutions X0 = 0, Y1 = 0, B6 = 1.

usage:  h2_struct.py [r]
"""
import sys
from fractions import Fraction as Fr

import sympy as sp

import h2_licence as LI
import holes_lib as H
import holes_reduce as RD
import holes_xy as XY
import n2b_lib as L
from n2b_lib import ONE, OM, OM2, KP, KM

OMs, KPs = sp.symbols('om kp')
MIN = [OMs**2 + OMs + 1, 8*KPs**2 - 13*KPs - 4]


def ksym(v):
    return (sp.Rational(v[0]) + sp.Rational(v[1])*OMs + sp.Rational(v[2])*KPs
            + sp.Rational(v[3])*OMs*KPs)


def psym(q, names):
    e = sp.Integer(0)
    for k, c in q.items():
        m = sp.Integer(1)
        for i, ex in enumerate(k):
            if ex:
                m *= sp.Symbol(names[i])**ex
        e += ksym(c)*m
    return sp.expand(e)


# ------------------------------------------------------------------ 1. anchor
def anchor(r, lam):
    """(index of the U^{r/2} eigenbasis vector in bP / bR, its coefficient)."""
    b = L.Block(r, 1, H.LAMS[lam])
    d = r // 2
    target = (d, 0, 0)                          # U^d = x^r
    outs = []
    for tag, basis in (('P', b.bP), ('R', b.bR)):
        for i, vec in enumerate(basis):
            if target in vec:
                outs.append((tag, i, vec[target], sorted(vec)))
    return b, outs


def grading(names, polys):
    """integer weight vectors w with every generator w-homogeneous."""
    n = len(names)
    rows = []
    for q in polys:
        ks = list(q)
        if len(ks) < 2:
            continue
        k0 = ks[0]
        for k in ks[1:]:
            rows.append([k[i] - k0[i] for i in range(n)])
    if not rows:
        return sp.eye(n)
    M = sp.Matrix(rows)
    return M.nullspace()


def main():
    r = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    print('=== FIX-H2 structural analysis, r = %d ===\n' % r)

    # ---- 1/2. the type-II anchor cubic
    for lam in ('one', 'om', 'om2'):
        b, outs = anchor(r, lam)
        print('lam=%-4s  x^%d anchor basis vectors (support of U^%d):' %
              (lam, r, r // 2))
        for tag, i, c, sup in outs:
            print('   %s%d  coeff of U^%d = %s   support %s'
                  % (tag, i, r // 2, L.kstr(c), sup))
        print()
    # C(A,B) = kp A^3 + km B^3 ; is it irreducible over K?
    A, B = sp.symbols('A B')
    C = sp.expand(ksym(KP)*A**3 + ksym(KM)*B**3)
    print('anchor cubic C(A,B) = %s' % C)
    # (A/B)^3 = -km/kp, reduced mod the minimal polynomial of kp
    t = sp.symbols('t')
    kpv = (13 + 3*sp.sqrt(33))/16
    kmv = sp.Rational(13, 8) - kpv
    c3 = sp.simplify(-kmv/kpv)
    print('   (A/B)^3 = -km/kp = %s = %s' % (sp.simplify(c3),
                                             sp.nsimplify(sp.N(c3, 30))))
    print('   norm_{QQ(sqrt33)/QQ} = %s' %
          sp.simplify(sp.expand(c3*c3.subs(sp.sqrt(33), -sp.sqrt(33)))))
    for extname, ext in (('K = QQ(sqrt-3,sqrt33)', [sp.sqrt(-3), sp.sqrt(33)]),):
        fl = sp.factor_list(sp.expand(t**3 - c3), t, extension=ext)
        print('   t^3 - (-km/kp) over %s factors as %s'
              % (extname, [(sp.simplify(f), m) for f, m in fl[1]]))
        print('   => C is %s over K'
              % ('IRREDUCIBLE (a genuine cubic / type-II anchor)'
                 if len(fl[1]) == 1 and sp.degree(fl[1][0][0], t) == 3
                 else 'REDUCIBLE'))
    print()

    # ---- 3/4. the anchor inside the actual systems
    for lam in ('one', 'om', 'om2'):
        names0, polys0, b = XY.xy_system(r, lam)
        cubics = [q for q in polys0
                  if len({i for k in q for i, e in enumerate(k) if e}) == 2
                  and all(sum(k) == 3 for k in q)]
        print('lam=%-4s  full block: %d gens; binary cubics among them: %d'
              % (lam, len(polys0), len(cubics)))
        for q in cubics:
            vsx = sorted({names0[i] for k in q for i, e in enumerate(k) if e})
            e = psym(q, names0)
            fl = sp.factor_list(e, *[sp.Symbol(v) for v in vsx],
                                extension=[sp.sqrt(-3), sp.sqrt(33)])
            print('   binary cubic in %s : %s' % (vsx, RD.polystr(q, names0)))
            print('      factors over K: %s  => %s'
                  % ([(sp.simplify(f), m) for f, m in fl[1]],
                     'IRREDUCIBLE' if len(fl[1]) == 1 and fl[1][0][1] == 1
                     and sp.total_degree(fl[1][0][0]) == 3 else 'REDUCIBLE'))
        names, polys, b2, vs = LI.licensed_system(r, lam)
        surv = [q for q in polys
                if len({i for k in q for i, e in enumerate(k) if e}) <= 2
                and all(sum(k) == 3 for k in q)]
        print('   licensed system: %d binary/unary cubics survive' % len(surv))
        for q in surv:
            print('      %s' % RD.polystr(q, names))
        ns = grading(names, polys)
        print('   grading lattice of the licensed system: rank %d' % len(ns))
        for v in ns:
            print('      w = %s' % dict((names[i], v[i]) for i in range(len(names))
                                        if v[i] != 0))
        print(flush=True)


if __name__ == '__main__':
    main()
