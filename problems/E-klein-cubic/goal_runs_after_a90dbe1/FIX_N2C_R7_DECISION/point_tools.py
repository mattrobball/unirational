#!/usr/bin/env python3
"""FIX-N2C: exact verification of a candidate cone point.

Given exact values for the 13 block parameters of the (m,r) = (1,7) cell, this
re-derives the tuple T = (a', b', u_0', u_1', u_2') from the INDEPENDENT sympy
build, and checks, exactly and in characteristic zero:

  * the residual C3 equivariance   psi(T) = lam g(T);
  * the landing identity           F(T) = 0  (raw Klein normal form);
  * the triple-line order          ord_R(T) = 7;
  * the common plane order         m = min_i ord_{P_i}(T)  (must be 1).

`extra_rel` is a list of algebraic relations (sympy expressions that vanish)
satisfied by any auxiliary algebraic numbers occurring in the values; the
checks are performed modulo those relations together with om^2+om+1 and
8kp^2-13kp-4.
"""
import sympy as sp

import indep_r7 as I
from indep_r7 import om, kp, x, y, z


def reduce_mod(e, extra_rel, gens):
    e = sp.expand(e)
    if e == 0:
        return sp.Integer(0)
    rels = [om**2 + om + 1, 8*kp**2 - 13*kp - 4] + list(extra_rel)
    _, r = sp.reduced(e, rels, *gens, order='lex')
    return sp.expand(sp.simplify(r))


def check_point(lam, values, extra_rel=(), extra_gens=()):
    """values: dict {'P0': expr, ..., 'B8': expr}.  Returns a report dict."""
    names, T = I.equivariant_tuple(7, 1, lam)
    gens = list(extra_gens) + [om, kp]
    sub = {sp.Symbol(n): values[n] for n in names}
    Tv = [sp.expand(c.subs(sub)) for c in T]
    Tv = [reduce_mod(c, extra_rel, gens) for c in Tv]

    rep = {'names': names, 'T': Tv}

    # equivariance
    tgt = [lam*om*Tv[0], lam*om**2*Tv[1], lam*Tv[3], lam*Tv[4], lam*Tv[2]]
    rep['equivariant'] = all(
        reduce_mod(sp.expand(I.psi(c) - t), extra_rel, gens) == 0
        for c, t in zip(Tv, tgt))

    # landing
    Fv = reduce_mod(I.F_klein(Tv), extra_rel, gens)
    if Fv != 0:
        P = sp.Poly(Fv, x, y, z)
        Fv = sum(reduce_mod(c, extra_rel, gens)*x**m[0]*y**m[1]*z**m[2]
                 for m, c in zip(P.monoms(), P.coeffs()))
        Fv = sp.expand(Fv)
    rep['lands'] = (Fv == 0)
    rep['F'] = Fv

    # orders
    rep['nonzero'] = any(c != 0 for c in Tv)
    orders = []
    for c in Tv:
        if c == 0:
            continue
        P = sp.Poly(c, x, y, z)
        for mono, co in zip(P.monoms(), P.coeffs()):
            if reduce_mod(co, extra_rel, gens) == 0:
                continue
            A, B, C = mono
            orders.append((B + C, A + C, A + B, A + B + C))
    rep['r'] = {o[3] for o in orders}
    rep['m'] = min(min(o[0], o[1], o[2]) for o in orders) if orders else None
    rep['ordP'] = tuple(min(o[i] for o in orders) for i in range(3)) if orders else None
    return rep


def pretty(rep):
    out = []
    out.append('  nonzero      : %s' % rep['nonzero'])
    out.append('  equivariant  : %s' % rep['equivariant'])
    out.append('  F(T) = 0     : %s' % rep['lands'])
    out.append('  ord_R        : %s' % sorted(rep['r']))
    out.append('  (ordP1,2,3)  : %s' % (rep['ordP'],))
    out.append('  m            : %s' % rep['m'])
    return '\n'.join(out)
