#!/usr/bin/env python3
"""FIX-N2B: the CONSTRUCTION side -- G * D_B(X).

D_B(X)  (Theorem D of FIX-N2):  for a character-chi_1 form X of degree delta,
Y = psi X, Z = psi^2 X, and B with (B^3-1)^2/B^3 = kappa,

    a' = -XYZ,  b' = 0,
    u_0' =      X(X^2 + B Y^2 + B^-1 Z^2),
    u_1' = om   Y(Y^2 + B Z^2 + B^-1 X^2),
    u_2' = om^2 Z(Z^2 + B X^2 + B^-1 Y^2)

lands (kappa = kp) and is C3-equivariant with lam = om^2.  Multiplying by any
A4-INVARIANT form G (K-invariant and psi-invariant) preserves both properties
and shifts (m,r) by (ord_{P_i} G, deg G).  The mirror (a'=0, kappa = km) lands
in the lam = om block.

This module builds those tuples inside the FULL cell space of `fullspace.py`,
so that they can be tested against the machine-computed cones.
"""
import n2b_lib as L, fullspace as FS


def psi_xyz(mono):
    """(A,B,C) -> exponents of the psi-image monomial: psi(x,y,z)=(y,z,x)."""
    A, B, C = mono
    return (C, A, B)


def poly_mul(f, g):
    out = {}
    for m1, c1 in f.items():
        for m2, c2 in g.items():
            k = (m1[0] + m2[0], m1[1] + m2[1], m1[2] + m2[2])
            out[k] = out.get(k, 0) + c1 * c2
    return {k: v for k, v in out.items() if v}


def poly_add(*fs):
    out = {}
    for f in fs:
        for k, v in f.items():
            out[k] = out.get(k, 0) + v
    return {k: v for k, v in out.items() if v}


def poly_scal(f, c):
    return {k: v * c for k, v in f.items() if v * c}


def psi_poly(f):
    return {psi_xyz(k): v for k, v in f.items()}


def D_tuple(X, B, Binv, om, om2, mul=1):
    """the five x,y,z-polynomials of D_B(X) (coefficients in whatever ring)."""
    Y, Z = psi_poly(X), psi_poly(psi_poly(X))
    a = poly_scal(poly_mul(poly_mul(X, Y), Z), -1)
    u0 = poly_mul(X, poly_add(poly_mul(X, X), poly_scal(poly_mul(Y, Y), B),
                              poly_scal(poly_mul(Z, Z), Binv)))
    u1 = poly_scal(poly_mul(Y, poly_add(poly_mul(Y, Y), poly_scal(poly_mul(Z, Z), B),
                                        poly_scal(poly_mul(X, X), Binv))), om)
    u2 = poly_scal(poly_mul(Z, poly_add(poly_mul(Z, Z), poly_scal(poly_mul(X, X), B),
                                        poly_scal(poly_mul(Y, Y), Binv))), om2)
    return [a, {}, u0, u1, u2]


def to_fullspace(fs, tup, p=None):
    """coordinates of a K-equivariant tuple in the FullSpace parametrisation.

    even r:  a' = P(U,V,W), u_0' = yz B0(U,V,W), u_1' = zx B1, u_2' = xy B2
    odd  r:  a' = xyz Q,    u_0' = x A0,         u_1' = y A1,  u_2' = z A2
    """
    r = fs.r
    v = [0] * fs.n
    idx = {n: i for i, n in enumerate(fs.names)}
    sa = {mo: i for i, mo in enumerate(fs.sa)}
    su = {mo: i for i, mo in enumerate(fs.su)}
    shifts_even = [(0, 0, 0), (0, 0, 0), (0, 1, 1), (1, 0, 1), (1, 1, 0)]
    shifts_odd = [(1, 1, 1), (1, 1, 1), (1, 0, 0), (0, 1, 0), (0, 0, 1)]
    sh = shifts_even if r % 2 == 0 else shifts_odd
    tags = ['P', 'R', 'C0_', 'C1_', 'C2_']
    for slot, (f, s) in enumerate(zip(tup, sh)):
        for mo, c in f.items():
            e = tuple(mo[i] - s[i] for i in range(3))
            assert all(x >= 0 and x % 2 == 0 for x in e), (slot, mo, s)
            key = tuple(x // 2 for x in e)
            tab = sa if slot < 2 else su
            assert key in tab, ('monomial outside the cell', slot, mo, key)
            nm = ('%s%d' % (tags[slot], tab[key]) if slot < 2
                  else '%s%d' % (tags[slot], tab[key]))
            v[idx[nm]] = c % p if p else c
    return v
