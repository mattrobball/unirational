#!/usr/bin/env python3
"""FIX-H1 TASK 6: the (P,R) -> (X,Y) coordinate change on the even-r blocks.

The plane-adic leading equations of the cone (the U-degree-top part of
F(T) = 0, i.e. the ord_{P_1} = 4 level) are

    coeff V^2 :  (om^2 L_P + om L_R)|_V  * c2^2            = 0
    coeff W^2 :  (om   L_P + om^2 L_R)|_W * c1^2           = 0
    coeff V W :  (om L_P + om^2 L_R)|_V c1^2
               + (om^2 L_P + om L_R)|_W c2^2  +  b300 c1 c2 = 0

so the natural coordinates on the (a',b') block are, orbit index by orbit index,

    X_i = om^2 P_i + om R_i ,   Y_i = om P_i + om^2 R_i          (invertible:
    P_i = (om^2 X_i - om Y_i)/(om-om^2),  R_i = (om^2 Y_i - om X_i)/(om-om^2)).

In these coordinates the leading relations become COORDINATE vanishing, and the
exact elimination cascade of `holes_reduce` no longer blows the degrees up.
This is a linear change of variables -- an isomorphism of affine space, exact
over K, characteristic zero.
"""
import sys

import holes_lib as H
import holes_reduce as RD
import n2b_lib as L
import n2c_systems as S
from n2b_lib import ONE, OM, OM2


def xy_system(r, lam, m=1, orbit_reduce=True):
    """(names, polys) with the (P,R) block replaced by (X,Y).

    P_i and R_j are paired when they carry the SAME sigma-orbit of monomials
    (the eigenbasis orders orbits identically for the two eigenvalues, but a
    sigma-FIXED monomial -- possible when 3 | deg -- occurs in only one of the
    two blocks, so the two lists can have different lengths; those entries stay
    untouched).
    """
    b, polys = H.block_system(r, H.LAMS[lam], m=m, orbit_reduce=orbit_reduce)
    names = list(b.names)
    n = len(names)
    nP = len(b.bP)
    nR = len(b.bR)
    supP = [frozenset(v) for v in b.bP]
    supR = [frozenset(v) for v in b.bR]
    pair = {}
    for i, s in enumerate(supP):
        for j, t in enumerate(supR):
            if s == t:
                pair[i] = nP + j
                break
    det = L.ksub(OM, OM2)
    di = S.kinv(det)

    def lin(pairs):
        out = {}
        for c, j in pairs:
            e = [0] * n
            e[j] = 1
            out[tuple(e)] = L.kmul(c, di)
        return out

    # substitute all paired P_i, R_j simultaneously: the slots that will hold
    # X_i (old P_i slot) and Y_i (old R_j slot).
    subs = {}
    for ip, ir in pair.items():
        subs[ip] = lin([(OM2, ip), (L.kneg(OM), ir)])           # P_i
        subs[ir] = lin([(OM2, ir), (L.kneg(OM), ip)])           # R_j
    out = []
    for q in polys:
        acc = {}
        for k, v in q.items():
            term = {tuple([0] * n): v}
            for j, e in enumerate(k):
                sub = subs.get(j)
                if sub is None:
                    ee = [0] * n
                    ee[j] = e
                    term = S.p_mul(term, {tuple(ee): ONE})
                else:
                    for _ in range(e):
                        term = S.p_mul(term, sub)
            acc = S.p_add(acc, term)
        if acc:
            out.append(acc)
    newnames = (['X%d' % i for i in range(nP)] + ['Y%d' % j for j in range(nR)]
                + [x for x in names if x.startswith('B')])
    return newnames, RD.dedup(out), b


def check_change(r, lam):
    """sanity: the change is invertible and the two systems have the same
    number of generators; a random point maps correctly."""
    import random
    b, polys = H.block_system(r, H.LAMS[lam], orbit_reduce=True)
    names2, polys2, _ = xy_system(r, lam)
    assert len(polys) == len(polys2), (len(polys), len(polys2))
    p, omp, kpp = 100057, 1140, 74361
    n = len(b.names)
    nP = len(b.bP)
    supP = [frozenset(v) for v in b.bP]
    supR = [frozenset(v) for v in b.bR]
    pair = {}
    for i, s in enumerate(supP):
        for j, t in enumerate(supR):
            if s == t:
                pair[i] = nP + j
                break
    om = omp
    om2 = om * om % p
    det = (om - om2) % p
    di = pow(det, p - 2, p)
    for _ in range(5):
        XY = [random.randrange(p) for _ in range(n)]
        PR = list(XY)
        for ip, ir in pair.items():
            X, Y = XY[ip], XY[ir]
            PR[ip] = (om2 * X - om * Y) % p * di % p
            PR[ir] = (om2 * Y - om * X) % p * di % p
        def ev(qs, v):
            out = []
            for q in qs:
                s = 0
                for k, c in q.items():
                    t = L.kmod_p(c, p, omp, kpp)
                    for j, e in enumerate(k):
                        if e:
                            t = t * pow(v[j], e, p) % p
                    s = (s + t) % p
                out.append(s)
            return sorted(out)
        assert ev(polys, PR) == ev(polys2, XY), 'coordinate change is wrong'
    return True


if __name__ == '__main__':
    r = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    for lam in ('one', 'om', 'om2'):
        assert check_change(r, lam)
        names, polys, b = xy_system(r, lam)
        print('r=%d lam=%-4s  vars %s  %d generators  CHANGE-OK'
              % (r, lam, names, len(polys)))
        rows = sorted(polys, key=len)
        for q in rows[:6]:
            print('    %s' % RD.polystr(q, names))
        print()
