#!/usr/bin/env python3
"""FIX-U1-FIN7 -- the 27 classified Chebyshev points inside the 39-parameter
non-equivariant cone: exact verification, and the Galois-stable 1+2+2+4 split.

For lam = om^j the nine-point scheme is (FIX-N2C Thm N2C-1')

    g1_j(B2) = B2^3 + 9 om^j B2 + 3 dl kap = 0
    g2_j(P1) = P1^3 - (8/9) om^(j+1) kap P1^2 + (32/27) kap = 0

and both cubics are REDUCIBLE over K (FIX-C1-PARAMETER-SPLIT), with the
K-rational roots

    B2_0 = dl om^(2j) c0 ,     P1_0 = (4/3) om^(j+1) c0 ,   c0 = (4kp-1)/3

(c0^3 - 3 c0 = kap: the K-rational Chebyshev root).  Dividing them out leaves
irreducible quadratics; the four parts are

    A : (B2_0, P1_0)          residue field K            1 point
    B : (B2_0, quad P1)       degree 2 over K            2 points
    C : (quad B2, P1_0)       degree 2 over K            2 points
    D : (quad B2, quad P1)    degree 4 over K            4 points
"""
import sympy as sp

import fin7_equiv as E
import fin7_lib as L
from exalg import Alg
from fin7_equiv import B2s, P1s, DL
from fin7_lib import kp, kred, om

C0 = sp.Rational(4, 3)*kp - sp.Rational(1, 3)
PARTS = ['A', 'B', 'C', 'D']


def _monic(poly, v):
    p = sp.Poly(poly, v)
    c = p.LC()
    return sp.expand(sp.Poly([kred(sp.expand(a/c)) for a in p.all_coeffs()],
                             v).as_expr())


def block_factors(j):
    """(linB2, quadB2, linP1, quadP1) -- monic factors over K."""
    g1, g2 = E.block_cubics(j)
    B20 = kred(sp.expand(DL*om**(2*j)*C0))
    P10 = kred(sp.expand(sp.Rational(4, 3)*om**(j + 1)*C0))
    assert kred(sp.expand(g1.subs(B2s, B20))) == 0
    assert kred(sp.expand(g2.subs(P1s, P10))) == 0
    Q1, R1 = sp.div(sp.Poly(g1, B2s), sp.Poly(B2s - B20, B2s))
    Q2, R2 = sp.div(sp.Poly(g2, P1s), sp.Poly(P1s - P10, P1s))
    assert kred(R1.as_expr()) == 0 and kred(R2.as_expr()) == 0
    q1 = _monic(Q1.as_expr(), B2s)
    q2 = _monic(Q2.as_expr(), P1s)
    return (sp.expand(B2s - B20), q1, sp.expand(P1s - P10), q2)


def part_algebra(j, part):
    l1, q1, l2, q2 = block_factors(j)
    gB2 = l1 if part in ('A', 'B') else q1
    gP1 = l2 if part in ('A', 'C') else q2
    return Alg(gB2, gP1, name='j%d%s' % (j, part))


def point_vector(j, part):
    """(A, names, values) -- the classified point as Alg elements."""
    A = part_algebra(j, part)
    coords = E.classified_point(j)
    names = L.all_params()
    vals = [A.of(coords[n]) for n in names]
    return A, names, vals


def npoints(part):
    return {'A': 1, 'B': 2, 'C': 2, 'D': 4}[part]
