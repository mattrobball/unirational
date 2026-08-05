#!/usr/bin/env python3
"""FIX-H1 producer, Part D -- the order-0 equalizer for branch (i), the D_B
family, at EVERY classified odd-m member of FIX-H0's branch table.

For a form X in (x,y,z) of V4-character chi_x (with binary-form coefficients
on the triple line), Theorem D / N2B-2 gives the A_4-equivariant landing family

    D_B(X) = ( -XYZ , 0 , X(X^2+BY^2+B^-1Z^2) ,
               om Y(Y^2+BZ^2+B^-1X^2) , om^2 Z(Z^2+BX^2+B^-1Y^2) ),
    Y = Theta X ,  Z = Theta^2 X ,  Theta : (x,y,z) -> (y,z,x) ,
    (B^3-1)^2/B^3 = kp   (the trace curve  B^3 + B^-3 = kp+2).

This script builds each member exactly over QQ(om)[B, B^-1], extracts
(r, m, e = r-m) and the LEADING LINE DATUM

    Lambda  =  ( (y,z)-degree-m part of (u1', u2') ) / x^e   in
               V = Hom(Sym^m W^-, W^-),

and decides the ORDER-0 EQUALIZER  Lambda in V[sgn^e]  exactly, as a condition
on B, eliminated against the trace curve.
"""
import json
import os
import sys
import time

import sympy as sp

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from k0 import K, ZERO, ONE, OM, OM2, NU, KP, KM, nullspace   # noqa: E402
import produce_h1_equalizer as EQ                             # noqa: E402

T0 = time.time()
LOG = []


def log(s):
    print(s, flush=True)
    LOG.append(s)


x, y, z, Bs = sp.symbols('x y z B')
w = sp.Symbol('w')                    # om, with w^2+w+1 = 0
REL = [w**2 + w + 1]


def kred(e):
    e = sp.expand(e)
    if e == 0:
        return sp.Integer(0)
    _, r = sp.reduced(e, REL, w, order='lex')
    return sp.expand(r)


def theta(e):
    return e.subs({x: y, y: z, z: x}, simultaneous=True)


def DB(X):
    Y, Z = theta(X), theta(theta(X))
    Bi = 1 / Bs
    return [sp.expand(-X * Y * Z),
            sp.Integer(0),
            sp.expand(X * (X**2 + Bs * Y**2 + Bi * Z**2)),
            sp.expand(w * Y * (Y**2 + Bs * Z**2 + Bi * X**2)),
            sp.expand(w**2 * Z * (Z**2 + Bs * X**2 + Bi * Y**2))]


def orders(T):
    """(r, (ord_P1, ord_P2, ord_P3))."""
    degs, ords = set(), []
    for c in T:
        c = sp.expand(sp.together(c) * Bs**3)      # clear B^-1 safely
        if c == 0:
            continue
        P = sp.Poly(sp.expand(c), x, y, z)
        for mo, cf in zip(P.monoms(), P.coeffs()):
            if kred(cf) == 0:
                continue
            a, b, cc = mo
            degs.add(a + b + cc)
            ords.append((b + cc, a + cc, a + b))
    r = min(degs)
    op = tuple(min(o[i] for o in ords) for i in range(3))
    return r, op, sorted(degs)


def to_k0(e):
    """convert a QQ(w) constant to a K0 element."""
    e = kred(sp.expand(e))
    p = sp.Poly(e, w)
    out = ZERO
    for mo, cf in zip(p.monoms(), p.coeffs()):
        c = sp.Rational(cf)
        base = ONE if mo[0] == 0 else (OM if mo[0] == 1 else OM2)
        out = out + K.rat(c.p, c.q) * base
    return out


def leading_datum(T, m, e):
    """coefficients of Lambda in EQ.vbasis(m), as K0-polynomials in B."""
    n = 2 * (m + 1)
    lam = {i: {} for i in range(n)}
    for comp, poly in ((0, T[3]), (1, T[4])):
        pe = sp.expand(sp.together(poly) * Bs**3)   # multiply by B^3, undo later
        P = sp.Poly(pe, x, y, z, Bs)
        for mo, cf in zip(P.monoms(), P.coeffs()):
            a, b, c, eb = mo
            if b + c != m or a != e:
                continue
            k0c = to_k0(cf)
            if k0c.is_zero():
                continue
            i = EQ.vbasis(m).index((comp, b))
            lam[i] = EQ.padd(lam[i], {eb: k0c})
    return lam


def test_member(name, X, note='', mult=None, swap_om=False,
                rho2=False):
    log('')
    log('--- %s :  X = %s  %s' % (name, X, note))
    T = DB(X)
    if mult is not None:
        T = [sp.expand(mult * c) for c in T]
    if swap_om:
        T = [sp.expand(c.subs(w, -1 - w)) for c in T]
    r, op, degs = orders(T)
    assert len(degs) == 1, 'not (x,y,z)-homogeneous: %s' % degs
    m = min(op)
    e = r - m
    log('    (m, r) = (%d, %d) ,  ord_{P_i} = %s ,  e = r-m = %d' % (m, r, op, e))
    # H0-1 check: the minus half must lead
    def ordP1(c):
        c = sp.expand(sp.together(c) * Bs**3)
        if c == 0:
            return 10**6
        P = sp.Poly(c, x, y, z)
        return min(mo[1] + mo[2] for mo, cf in zip(P.monoms(), P.coeffs())
                   if kred(cf) != 0)
    op_plus = min(ordP1(T[0]), ordP1(T[1]), ordP1(T[2]))
    op_minus = min(ordP1(T[3]), ordP1(T[4]))
    log('    ord_{P_1} T^+ = %d , ord_{P_1} T^- = %d  ->  minus half leads: %s'
        % (op_plus, op_minus, op_minus < op_plus))
    if op_minus >= op_plus:
        log('    (excluded already by Theorem H0-1: m would be even)')
        return dict(name=name, m=m, r=r, e=e, excluded_by='H0-1')

    lam = leading_datum(T, m, e)
    n = 2 * (m + 1)
    nz = [i for i in range(n) if lam[i]]
    log('    Lambda has %d nonzero coordinates: %s'
        % (len(nz), ', '.join('%s : %s' % (EQ.mono_str(m, *EQ.vbasis(m)[i]),
                                           EQ.pstr(lam[i])) for i in nz)))
    # the equalizer conditions
    RR = EQ.R
    if rho2:
        RR = [[sum((EQ.R[i][k] * EQ.R[k][j] for k in range(2)), ZERO)
               for j in range(2)] for i in range(2)]
    A = EQ.act_matrix(RR, m)
    Bt = EQ.act_matrix(EQ.TAU, m)
    sgn = ONE if e % 2 == 0 else -ONE
    eqs = []
    for (M, s) in ((A, ONE), (Bt, sgn)):
        for i in range(n):
            acc = {}
            for j in range(n):
                if not M[i][j].is_zero():
                    acc = EQ.padd(acc, EQ.pscal(lam[j], M[i][j]))
            acc = EQ.padd(acc, EQ.pscal(lam[i], -s))
            if acc:
                eqs.append(acc)
    # the tau-part alone (should be automatically satisfied)
    tau_eqs = []
    for i in range(n):
        acc = {}
        for j in range(n):
            if not Bt[i][j].is_zero():
                acc = EQ.padd(acc, EQ.pscal(lam[j], Bt[i][j]))
        acc = EQ.padd(acc, EQ.pscal(lam[i], -sgn))
        if acc:
            tau_eqs.append(acc)
    log('    tau-part of the equalizer (must be AUTOMATIC): %s'
        % ('satisfied identically' if not tau_eqs
           else '%d nonzero equations !!' % len(tau_eqs)))
    log('    total equalizer equations in B : %d' % len(eqs))
    if not eqs:
        log('    ==> the order-0 equalizer holds IDENTICALLY in B  '
            '(NONEMPTY, whole trace curve)')
        return dict(name=name, m=m, r=r, e=e, verdict='NONEMPTY-IDENTICAL')
    trace = {6: ONE, 3: -(KP + K.rat(2)), 0: ONE}
    g = EQ.poly_gcd_list(eqs + [trace])
    solvable = bool(g) and max(g) > 0
    log('    gcd(equalizer eqs, B^6-(kp+2)B^3+1) = %s' % EQ.pstr(g))
    log('    ==> a B on the trace curve satisfying the order-0 equalizer: %s'
        % ('YES' if solvable else 'NO'))
    # also with kp replaced by km (the Galois conjugate branch)
    trace2 = {6: ONE, 3: -(KM + K.rat(2)), 0: ONE}
    g2 = EQ.poly_gcd_list(eqs + [trace2])
    solvable2 = bool(g2) and max(g2) > 0
    log('    ==> same with km instead of kp: %s' % ('YES' if solvable2 else 'NO'))
    return dict(name=name, m=m, r=r, e=e, neqs=len(eqs),
                gcd=EQ.pstr(g), solvable=bool(solvable or solvable2),
                verdict='NONEMPTY' if (solvable or solvable2) else 'EMPTY')


def main():
    log('# FIX-H1 producer D -- branch (i), the D_B family, order-0 equalizer')
    log('# every classified odd-m member of the FIX-H0 branch table')
    out = []
    out.append(test_member('D_B(yz)   (3,6)  the T5 witness', y * z,
                           '[lam = om^2]'))
    q = x**2 + y**2 + z**2
    out.append(test_member('q.D_B(yz) (3,8)', y * z,
                           '-- multiplied by q = x^2+y^2+z^2', mult=q))
    out.append(test_member('D_B(xy^2) (3,9)  primitive', x * y**2))
    out.append(test_member('D_B(x^3)  (m,r) control', x**3))
    out.append(test_member('D_B(xz^2)', x * z**2))
    log('')
    log('NOTE on invariant multiples.  If G is an A_4-invariant with'
        ' ord_{P_i}G = 2k and')
    log('  (y,z)-degree-0 part x^{2k}, then G.T has m -> m+2k, r -> r+deg G,'
        ' e -> e + deg G - 2k,')
    log('  and its leading datum is x^{...} times (y^2z^2)^k-shifted'
        ' Lambda(T).  For G = q = x^2+y^2+z^2')
    log('  (deg 2, ord_{P_i} = 0) the datum is UNCHANGED, so (3,8) = q.D_B(yz)'
        ' and every q^k-translate')
    log('  inherit the (3,6) verdict verbatim.  For G = (xyz)^2 the datum is'
        ' multiplied by y^2z^2 in')
    log('  Sym^{m+4}; that case is run separately below.')
    out.append(test_xyz2())
    log('')
    log('CONVENTION ROBUSTNESS.  The om appearing in the D_B tuple and the om')
    log('  appearing in the frame are the same by construction, but the choice')
    log('  of the order-3 generator psi of A_4 can swap om <-> om^2.  Rerun the')
    log('  (3,6) test with om -> om^2 inside D_B while keeping rho|_{W^-}:')
    out.append(test_member('D_B(yz) with om -> om^2 (convention twist)',
                           y * z, '', swap_om=True))
    log('  (also with rho replaced by rho^2 = rho^-1, which must give the same')
    log('   verdict since rho.L = L iff rho^2.L = L):')
    out.append(test_member('D_B(yz) with rho -> rho^2', y * z, '',
                           rho2=True))
    return out


def test_xyz2():
    """(7,12) = (xyz)^2 . D_B(yz): leading datum y^2z^2 * Lambda_0 in Sym^7."""
    log('')
    log('--- (xyz)^2 . D_B(yz)   (7,12) ---')
    T0_ = DB(y * z)
    G = (x * y * z)**2
    T = [sp.expand(G * c) for c in T0_]
    r, op, degs = orders(T)
    m = min(op)
    e = r - m
    log('    (m, r) = (%d, %d) , ord_{P_i} = %s , e = %d' % (m, r, op, e))
    lam = leading_datum(T, m, e)
    n = 2 * (m + 1)
    nz = [i for i in range(n) if lam[i]]
    log('    Lambda coordinates: %s'
        % ', '.join('%s : %s' % (EQ.mono_str(m, *EQ.vbasis(m)[i]),
                                 EQ.pstr(lam[i])) for i in nz))
    A = EQ.act_matrix(EQ.R, m)
    Bt = EQ.act_matrix(EQ.TAU, m)
    sgn = ONE if e % 2 == 0 else -ONE
    eqs = []
    for (M, s) in ((A, ONE), (Bt, sgn)):
        for i in range(n):
            acc = {}
            for j in range(n):
                if not M[i][j].is_zero():
                    acc = EQ.padd(acc, EQ.pscal(lam[j], M[i][j]))
            acc = EQ.padd(acc, EQ.pscal(lam[i], -s))
            if acc:
                eqs.append(acc)
    log('    equalizer equations in B : %d' % len(eqs))
    trace = {6: ONE, 3: -(KP + K.rat(2)), 0: ONE}
    g = EQ.poly_gcd_list(eqs + [trace]) if eqs else {0: ONE}
    solvable = bool(eqs) and bool(g) and max(g) > 0
    if not eqs:
        log('    ==> holds identically (NONEMPTY)')
    else:
        log('    gcd with the trace curve = %s ; solvable: %s'
            % (EQ.pstr(g), 'YES' if solvable else 'NO'))
    return dict(name='(xyz)^2 D_B(yz) (7,12)', m=m, r=r, e=e,
                verdict='NONEMPTY' if solvable else 'EMPTY')


if __name__ == '__main__':
    res = main()
    log('')
    log('SUMMARY')
    for d in res:
        log('   %-40s (m,r)=(%s,%s) e=%s  %s'
            % (d.get('name'), d.get('m'), d.get('r'), d.get('e'),
               d.get('verdict', d.get('excluded_by'))))
    log('elapsed %.1f s' % (time.time() - T0))
    os.makedirs(os.path.join(HERE, 'payloads'), exist_ok=True)
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_branch1.txt'),
              'w') as fh:
        fh.write('\n'.join(LOG) + '\n')
    with open(os.path.join(HERE, 'payloads', 'h1_branch1.json'), 'w') as fh:
        json.dump(res, fh, indent=1, default=str)
    print('FIX_H1_BRANCH1_OK')
