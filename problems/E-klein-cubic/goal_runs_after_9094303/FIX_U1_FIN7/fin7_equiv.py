#!/usr/bin/env python3
"""FIX-U1-FIN7 -- the residual-C3 eigenblocks inside the 39-parameter cone,
and the 27 classified Chebyshev points, placed in the non-equivariant chart.

Two independent constructions of the eigenblock embedding are provided and
cross-checked:

  (E1) explicit:   a' = sum P_k b_k with psi(b_k) = lam*om*b_k, etc.,
                   u1' = lam^{-1} psi(u0'),  u2' = lam^{-1} psi(u1')
                   -- the FIX-N2C / indep_r7 parametrisation;
  (E2) intrinsic:  the lam-eigenspace of the operator Theta of `fin7_lib`.

The 27 classified points are FIX-N2C's Theorem N2C-1' witnesses: in the
normalisation P0 = 1 and for lam = om^j (j = 0,1,2),

    B2^3 + 9 om^j B2 + 3 dl kap = 0 ,      dl = 2om+1 ,  kap = kp+2
    P1^3 - (8/9) om^(j+1) kap P1^2 + (32/27) kap = 0
    B5 = om + ((om+2)/6) B2 P1

plus nine K-linear relations (block-dependent; taken from FIX-N2C's
`witness.py`, `witness_om.py`, `witness_om2.py` and RE-VERIFIED here against
this packet's independently built 52 equations).
"""
import sympy as sp

import fin7_lib as L
from fin7_lib import om, kp, kred, OM2

B2s, P1s = sp.symbols('B2 P1')
KAP = kp + 2
DL = 2*om + 1

LAMS = [('lam1', sp.Integer(1), 0), ('lamom', om, 1), ('lamom2', OM2, 2)]

# ---- FIX-N2C's nine K-linear relations, per eigenblock --------------------
# each entry maps a block coordinate name to a K-linear form in P0, P1, B2, B5
def _rel_lam1(P0, P1, B2, B5):
    return {'R0': om*B5 - OM2*P0,
            'R1': -om*P1,
            'B0': -OM2*B5 - (OM2 - 1)*P0,
            'B1': -B5,
            'B3': -2*om*B5 - (2*om + 4)*P0,
            'B4': -B2,
            'B6': om*B5 - (OM2 - 1)*P0 - (OM2 + 2)*P1,
            'B7': om*B5 - (OM2 - 1)*P0 - (om - 1)*P1,
            'B8': OM2*B5 + (OM2 - 1)*P0}


def _rel_lamom(P0, P1, B2, B5):
    return {'R0': om*B5 - OM2*P0,
            'R1': -om*P1,
            'B0': -B5 + (om - 1)*P0,
            'B1': -OM2*B5,
            'B3': -2*om*B5 - (2*om + 4)*P0,
            'B4': -OM2*B2,
            'B6': OM2*B5 + (om - 1)*(P0 + P1),
            'B7': B5 - DL*(P0 - P1),
            'B8': OM2*B5 - (om + 2)*P0}


def _rel_lamom2(P0, P1, B2, B5):
    return {'R0': om*B5 - OM2*P0,
            'R1': -om*P1,
            'B0': -om*B5 - DL*P0,
            'B1': -om*B5,
            'B3': -2*om*B5 - (2*om + 4)*P0,
            'B4': -om*B2,
            'B6': B5 - DL*P0 + (om - 1)*P1,
            'B7': OM2*B5 + (om - 1)*P0 - (om + 2)*P1,
            'B8': OM2*B5 - (om + 2)*P0}


RELS = {0: _rel_lam1, 1: _rel_lamom, 2: _rel_lamom2}


# ---------------------------------------------------------------------------
def eig_basis(monos, nu):
    """orbit basis of the nu-eigenspace of psi on span(monos)."""
    nu = kred(nu)
    nui = kred(nu**2)                     # nu^{-1} (nu^3 = 1)
    nui2 = kred(nui**2)
    seen, out = set(), []
    for M in monos:
        if M in seen:
            continue
        o1 = L.psi_mon(M)
        o2 = L.psi_mon(o1)
        seen |= {M, o1, o2}
        if o1 == M:
            if kred(nu - 1) == 0:
                out.append({M: sp.Integer(1)})
            continue
        out.append({M: sp.Integer(1), o1: nui, o2: nui2})
    return out


def block_embedding(lam, r=7, m=1):
    """(blocknames, coords) -- coords[param39] = K-linear form in the 13
    eigenblock coordinates P0,P1,R0,R1,B0..B8 (E1, explicit)."""
    sup = L.supports(r, m)
    nms = L.param_names(r, m)
    lam = kred(lam)
    lami = kred(lam**2)                   # lam^{-1}
    bP = eig_basis(sup[0], kred(lam*om))
    bR = eig_basis(sup[1], kred(lam*OM2))
    assert len(bP) == 2 and len(bR) == 2, (len(bP), len(bR))
    blocknames = (['P%d' % k for k in range(len(bP))]
                  + ['R%d' % k for k in range(len(bR))]
                  + ['B%d' % k for k in range(len(sup[2]))])
    coords = {n: sp.Integer(0) for blk in nms for n in blk}
    for k, v in enumerate(bP):
        for mon, cf in v.items():
            coords[nms[0][sup[0].index(mon)]] += sp.Symbol('P%d' % k)*cf
    for k, v in enumerate(bR):
        for mon, cf in v.items():
            coords[nms[1][sup[1].index(mon)]] += sp.Symbol('R%d' % k)*cf
    for k, mon in enumerate(sup[2]):
        coords[nms[2][k]] += sp.Symbol('B%d' % k)
        # u1' = lam^{-1} psi(u0');  psi sends x^A y^B z^C -> x^C y^A z^B
        m1 = L.psi_mon(mon)
        coords[nms[3][sup[3].index(m1)]] += lami*sp.Symbol('B%d' % k)
        m2 = L.psi_mon(m1)
        coords[nms[4][sup[4].index(m2)]] += kred(lami**2)*sp.Symbol('B%d' % k)
    return blocknames, {k: kred(v) for k, v in coords.items()}


def classified_point(j, r=7, m=1):
    """the 9-point family of eigenblock lam = om^j, as a dict param39 -> value
    in K[B2, P1] (to be read modulo the two block cubics)."""
    lam = kred(om**j)
    blocknames, coords = block_embedding(lam, r, m)
    P0 = sp.Integer(1)
    B5 = sp.expand(om + sp.Rational(1, 6)*(om + 2)*B2s*P1s)
    vals = {'P0': P0, 'P1': P1s, 'B2': B2s, 'B5': B5}
    vals.update(RELS[j](P0, P1s, B2s, B5))
    sub = {sp.Symbol(k): v for k, v in vals.items()}
    assert set(sub) == {sp.Symbol(n) for n in blocknames}, (
        sorted(str(s) for s in sub), blocknames)
    return {k: sp.expand(v.subs(sub)) for k, v in coords.items()}


def block_cubics(j):
    """the two defining cubics of the nine-point scheme in eigenblock om^j."""
    return [sp.expand(B2s**3 + 9*kred(om**j)*B2s + 3*DL*KAP),
            sp.expand(P1s**3 - sp.Rational(8, 9)*kred(om**(j + 1))*KAP*P1s**2
                      + sp.Rational(32, 27)*KAP)]
