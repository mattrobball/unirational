#!/usr/bin/env python3
"""FIX-N2C: an INDEPENDENT rebuild of the (m,r) = (1,7) landing system.

Nothing here imports FIX-N2B's engine.  The tuple is built as explicit
polynomials in x, y, z; the residual-C3 conditions are imposed as literal
substitutions (x,y,z) -> (y,z,x); the landing polynomial is the raw Klein
normal form of the V4 packet (1.1); all arithmetic is sympy over
QQ[om,kp]/(om^2+om+1, 8kp^2-13kp-4).

Exports
    cell_basis(r, m)                the (m,r) monomial supports
    equivariant_tuple(r, m, lam)    (params, T) with T = (a',b',u0',u1',u2')
    landing_equations(r, m, lam)    the coefficient equations of F(T) = 0
"""
import itertools

import sympy as sp

x, y, z = sp.symbols('x y z')
om, kp = sp.symbols('om kp')
REL = [om**2 + om + 1, 8*kp**2 - 13*kp - 4]
KM = sp.Rational(13, 8) - kp                       # km = 13/8 - kp


def kred(e):
    """reduce a K-expression modulo om^2+om+1 and 8kp^2-13kp-4."""
    e = sp.expand(e)
    if e == 0:
        return sp.Integer(0)
    _, r = sp.reduced(e, REL, om, kp, order='lex')
    return sp.expand(r)


def psi(e):
    """the source C3: (x,y,z) -> (y,z,x)."""
    return e.subs({x: y, y: z, z: x}, simultaneous=True)


# --------------------------------------------------------------------------
def monomials_xyz(r, m, parity):
    """degree-r monomials x^A y^B z^C with min plane order >= m and the given
    parity pattern (parity[i] in {0,1} = required parity of the exponent)."""
    out = []
    for A in range(r + 1):
        for B in range(r + 1 - A):
            C = r - A - B
            if (A % 2, B % 2, C % 2) != tuple(parity):
                continue
            if r - max(A, B, C) < m:                    # min_i ord_{P_i}
                continue
            out.append((A, B, C))
    return sorted(out, reverse=True)


def slot_parities(r):
    """V4-characters: a', b', u_0', u_1', u_2' as parity patterns of (A,B,C).

    a', b' carry the trivial V4-character; u_0' the character of x, etc.
    For r odd the trivial character forces all exponents odd (x y z divides);
    for r even all exponents even.
    """
    if r % 2:
        return [(1, 1, 1), (1, 1, 1), (1, 0, 0), (0, 1, 0), (0, 0, 1)]
    return [(0, 0, 0), (0, 0, 0), (0, 1, 1), (1, 0, 1), (1, 1, 0)]


def equivariant_tuple(r, m, lam):
    """the general residual-C3-equivariant tuple with scalar lam.

    Conditions:  psi(a') = lam om a',  psi(b') = lam om^2 b',
                 psi(u_0') = lam u_1',  psi(u_1') = lam u_2',  psi(u_2') = lam u_0'.
    """
    par = slot_parities(r)
    pa, pb, p0 = par[0], par[1], par[2]
    Ma = monomials_xyz(r, m, pa)
    M0 = monomials_xyz(r, m, p0)
    lam = sp.expand(lam)
    lami = kred(sp.expand(lam**2))                       # lam^{-1} = lam^2

    def mono(t):
        return x**t[0] * y**t[1] * z**t[2]

    # --- a' : psi(a') = lam*om*a'.  psi permutes Ma; solve on each orbit.
    def eig_block(monos, nu, prefix):
        nu = kred(nu)
        nui = kred(nu**2)                                # nu^{-1}
        seen, out, names = set(), [], []
        k = 0
        for M in monos:
            if M in seen:
                continue
            # psi(x^A y^B z^C) = y^A z^B x^C = x^C y^A z^B  -> (C, A, B)
            o1 = (M[2], M[0], M[1])
            o2 = (o1[2], o1[0], o1[1])
            orb = [M, o1, o2]
            seen |= set(orb)
            if o1 == M:
                if kred(nu - 1) == 0:
                    out.append(mono(M))
                    names.append('%s%d' % (prefix, k))
                    k += 1
                continue
            # v = M + nu^{-1} psi(M) + nu^{-2} psi^2(M)   satisfies psi(v) = nu v
            out.append(sp.expand(mono(M) + nui*mono(o1) + kred(nui**2)*mono(o2)))
            names.append('%s%d' % (prefix, k))
            k += 1
        return names, out

    nP, bP = eig_block(Ma, lam*om, 'P')
    nR, bR = eig_block(Ma, kred(lam*om**2), 'R')
    nB = ['B%d' % i for i in range(len(M0))]
    params = [sp.Symbol(s) for s in nP + nR + nB]
    it = iter(params)
    ap = sum(next(it)*v for v in bP) if bP else sp.Integer(0)
    bp = sum(next(it)*v for v in bR) if bR else sp.Integer(0)
    u0 = sum(next(it)*mono(M) for M in M0)
    u1 = kred(sp.expand(lami*psi(u0)))
    u2 = kred(sp.expand(lami*psi(u1)))
    return [str(s) for s in params], [sp.expand(ap), sp.expand(bp), u0, u1, u2]


def check_equivariance(T, lam):
    """verify psi(T) = lam * g(T) with g = (a,b,u0,u1,u2)->(om a, om^2 b, u1,u2,u0)."""
    ap, bp, u0, u1, u2 = T
    tgt = [kred(lam*om*ap), kred(lam*om**2*bp), kred(lam*u1),
           kred(lam*u2), kred(lam*u0)]
    for got, want in zip([psi(c) for c in T], tgt):
        if kred(sp.expand(got - want)) != 0:
            return False
    return True


def F_klein(T):
    """the Klein normal form (V4 packet (1.1))."""
    a, b, u0, u1, u2 = T
    return sp.expand(kp*a**3 + KM*b**3
                     + a*(u0**2 + om*u1**2 + om**2*u2**2)
                     + b*(u0**2 + om**2*u1**2 + om*u2**2)
                     + u0*u1*u2)


def landing_equations(r, m, lam):
    """coefficient equations of F(T) = 0, as sympy expressions in the params."""
    names, T = equivariant_tuple(r, m, lam)
    assert check_equivariance(T, lam), 'tuple is not C3-equivariant'
    P = sp.Poly(kred(F_klein(T)), x, y, z)
    eqs = []
    for mono, c in zip(P.monoms(), P.coeffs()):
        c = kred(c)
        if c != 0:
            eqs.append((mono, sp.expand(c)))
    return names, T, eqs
