#!/usr/bin/env python3
"""FIX-N2 cell library: K-equivariant pointwise landing systems at a V4 triple line.

Conventions (reconciled against the V4 packet
`goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/`):

  * normal coordinates x,y,z carry the three nontrivial V4-characters
    chi_1,chi_2,chi_3 with chi_1 chi_2 chi_3 = triv.  We encode a character as
    a pair in (Z/2)^2 and give x,y,z the characters (1,0),(0,1),(1,1); the
    character of x^A y^B z^C is ((A+C)%2,(B+C)%2).  This is exactly the encoding
    used by the packet's `verify.py::check_j3_character_classification`.
  * plus-planes P_1=(y,z), P_2=(x,z), P_3=(x,y); for a monomial
    ord_{P_1} = B+C, ord_{P_2} = A+C, ord_{P_3} = A+B, and ord_R = A+B+C = the
    total degree in x,y,z (R = the triple line).
  * CELL (m,r):  m = common involution-plane order = min_i ord_{P_i},
                 r = triple-line order = ord_R = degree in (x,y,z).
    Membership in J_m at degree r is equivalent to: every exponent <= r-m.
    Hence m = r - (max exponent occurring), and Lemma 2.1 reads
    sum_i ord_{P_i} = 2 ord_R  =>  r >= ceil(3m/2).
  * NOTE ON THE LETTER r.  The packet's Section 4 uses `r` for the auxiliary
    index in `m = 2r+1`, `(J_m)_{3r+3} = (xyz)^{r-1}(J_3)_6`.  The FIX-N2 brief
    and Note II Section 4 use `r` for the triple-line order.  We use the brief's
    convention throughout and write the packet's Section-4 index as k:
    m = 2k+1, first permissible layer at r = 3k+3.  (m=3 <-> k=1 <-> r=6.)
  * Klein normal form (packet (1.1)):
      F = kp a^3 + km b^3 + a(u0^2 + om u1^2 + om^2 u2^2)
                          + b(u0^2 + om^2 u1^2 + om u2^2) + u0 u1 u2,
    om^2+om+1 = 0, kp+km = 13/8, kp*km = -1/2 (so 8 kp^2 - 13 kp - 4 = 0).
    Smoothness of the two character surfaces: kp, km != 0, -4 (packet (1.2)).
"""

import itertools
import sympy as sp

om = sp.Symbol('om')          # primitive cube root of unity, om^2+om+1 = 0
kp, km = sp.symbols('kp km')  # kappa_+, kappa_-
x, y, z = sp.symbols('x y z')
U, V, W = sp.symbols('U V W')

CYC = sp.Poly(om**2 + om + 1, om)

# characters, in the (Z/2)^2 encoding
TRIV = (0, 0)
CHI = {0: (1, 0), 1: (0, 1), 2: (1, 1)}   # chi_1, chi_2, chi_3 <-> u0,u1,u2


def char_of(mono):
    A, B, C = mono
    return ((A + C) % 2, (B + C) % 2)


def plane_orders(mono):
    A, B, C = mono
    return (B + C, A + C, A + B)


def basis(chi, r, m):
    """Monomials x^A y^B z^C of degree r, character chi, all plane orders >= m."""
    out = []
    for A in range(r + 1):
        for B in range(r + 1 - A):
            C = r - A - B
            if max(A, B, C) > r - m:
                continue
            if char_of((A, B, C)) != chi:
                continue
            out.append((A, B, C))
    return sorted(out, reverse=True)


def reduce_om(expr):
    """Reduce an expression modulo om^2+om+1."""
    e = sp.expand(expr)
    if not e.has(om):
        return e
    return sp.expand(sp.div(sp.Poly(e, om), CYC)[1].as_expr())


def mono_expr(mono):
    A, B, C = mono
    return x**A * y**B * z**C


def make_tuple(r, m, prefix=''):
    """General K-equivariant tuple at cell-level (m,r).  Returns (forms, coeffs, bases)."""
    names = ['a', 'b', 'u0', 'u1', 'u2']
    chars = [TRIV, TRIV, CHI[0], CHI[1], CHI[2]]
    forms, coeffs, bases = [], [], []
    for nm, ch in zip(names, chars):
        bs = basis(ch, r, m)
        cs = [sp.Symbol('%s%s_%d_%d_%d' % (prefix, nm, *mo)) for mo in bs]
        forms.append(sum(c * mono_expr(mo) for c, mo in zip(cs, bs)))
        coeffs.extend(cs)
        bases.append(bs)
    return forms, coeffs, bases


def klein(a, b, u0, u1, u2):
    return (kp * a**3 + km * b**3
            + a * (u0**2 + om * u1**2 + om**2 * u2**2)
            + b * (u0**2 + om**2 * u1**2 + om * u2**2)
            + u0 * u1 * u2)


def landing_system(r, m, prefix=''):
    """Coefficient equations of F(tuple) = 0 for the general (m,r) tuple."""
    forms, coeffs, bases = make_tuple(r, m, prefix)
    Fv = reduce_om(sp.expand(klein(*forms)))
    if Fv == 0:
        return [], coeffs, bases, forms
    P = sp.Poly(Fv, x, y, z)
    eqs = [reduce_om(c) for c in P.coeffs()]
    eqs = [e for e in eqs if e != 0]
    return eqs, coeffs, bases, forms


def exact_m_conditions(r, m, bases, coeffs_by_slot):
    """Coefficients whose monomial realises plane order exactly m (max exponent r-m)."""
    out = []
    for bs, cs in zip(bases, coeffs_by_slot):
        for mo, c in zip(bs, cs):
            if max(mo) == r - m:
                out.append(c)
    return out


def slot_coeffs(r, m, prefix=''):
    names = ['a', 'b', 'u0', 'u1', 'u2']
    chars = [TRIV, TRIV, CHI[0], CHI[1], CHI[2]]
    out = []
    for nm, ch in zip(names, chars):
        bs = basis(ch, r, m)
        out.append([sp.Symbol('%s%s_%d_%d_%d' % (prefix, nm, *mo)) for mo in bs])
    return out


def cell_dims(r, m):
    return {'a': len(basis(TRIV, r, m)),
            'b': len(basis(TRIV, r, m)),
            'u0': len(basis(CHI[0], r, m)),
            'u1': len(basis(CHI[1], r, m)),
            'u2': len(basis(CHI[2], r, m))}


# ---------------------------------------------------------------- UVW picture
def uvw_shape(r, m):
    """Parity-table shape of the general K-equivariant tuple at (m,r).

    r odd :  a' = xyz Q(U,V,W), b' = xyz S,  u_i' = x_i A_i(U,V,W),
             deg A_i = (r-1)/2 =: d,  deg Q = deg S = d-1.
    r even:  a' = P(U,V,W), b' = R,  u_0' = yz B_0, u_1' = zx B_1, u_2' = xy B_2,
             deg P = deg R = r/2 =: d,  deg B_i = d-1.
    Returns a dict describing the allowed U,V,W-monomials in each slot.
    """
    info = {'parity': 'odd' if r % 2 else 'even'}
    if r % 2:
        d = (r - 1) // 2
        info['d'] = d
        # a' = xyz U^i V^j W^k  <-> exponents (1+2i, 1+2j, 1+2k) <= r-m
        info['Q'] = [t for t in _tri(d - 1) if max(1 + 2 * e for e in t) <= r - m]
        info['A0'] = [t for t in _tri(d)
                      if max(1 + 2 * t[0], 2 * t[1], 2 * t[2]) <= r - m]
        info['A1'] = [t for t in _tri(d)
                      if max(2 * t[0], 1 + 2 * t[1], 2 * t[2]) <= r - m]
        info['A2'] = [t for t in _tri(d)
                      if max(2 * t[0], 2 * t[1], 1 + 2 * t[2]) <= r - m]
    else:
        d = r // 2
        info['d'] = d
        info['P'] = [t for t in _tri(d) if max(2 * e for e in t) <= r - m]
        info['B0'] = [t for t in _tri(d - 1)
                      if max(2 * t[0], 1 + 2 * t[1], 1 + 2 * t[2]) <= r - m]
        info['B1'] = [t for t in _tri(d - 1)
                      if max(1 + 2 * t[0], 2 * t[1], 1 + 2 * t[2]) <= r - m]
        info['B2'] = [t for t in _tri(d - 1)
                      if max(1 + 2 * t[0], 1 + 2 * t[1], 2 * t[2]) <= r - m]
    return info


def _tri(n):
    if n < 0:
        return []
    return sorted([(i, j, n - i - j) for i in range(n + 1)
                   for j in range(n + 1 - i)], reverse=True)
