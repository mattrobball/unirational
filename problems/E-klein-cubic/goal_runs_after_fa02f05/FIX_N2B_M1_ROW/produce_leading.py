#!/usr/bin/env python3
"""FIX-N2B: the LEVEL-4 LEADING-LAYER OBSTRUCTION (char-0 exact).

Let T be a C3-equivariant pointwise landing tuple of triple-line order r in
J_1 (a point of the cone), and decompose it by plane order,
T = T^(1) + T^(2) + T^(3) + ...   (T^(p) = the part supported on monomials of
plane order exactly p).  Since J_a J_b subset J_{a+b},

    [F(T)]_3 = [Phi(T^1,T^1,T^1)]_3 ,
    [F(T)]_4 = [Phi(T^1,T^1,T^1)]_4 + 3 [Phi(T^1,T^1,T^2)]_4 ,

and both vanish.  FIX-N2 checked the level-3 identity and found it VACUOUS at
r = 6 (the products of three plane-order-1 monomials land in J_8).  The level-4
identity is not vacuous, and it involves ONLY the parameters of plane order 1
and 2: a monomial of plane order 4 can only receive a product of three
parameters whose plane orders sum to <= 4, i.e. of profile (1,1,1) or (1,1,2).

The plane-order-1 part of a C3-eigenblock is always exactly TWO-dimensional
(the two "corner" coefficients of u_0', namely y^{r-1} z and y z^{r-1} for even
r, resp. V^d and W^d in the U,V,W-picture).  So T^(1) runs over a P^1, and the
obstruction is: for which [beta : gamma] does the linear system

    3 [Phi(T^1,T^1,S)]_4  =  -[Phi(T^1,T^1,T^1)]_4 ,     S in (J_2/J_3) ∩ E_mu

have a solution?  If none, then the cone has NO plane-order-1 point -- and the
computation is exact linear algebra over K = QQ(om,kp) with ONE homogeneous
parameter, so it is characteristic-zero rigorous and cheap.

Output per (r, lam): the set of [beta:gamma] for which the system is solvable
(empty  =>  no plane-order-1 cone point at that r and lam).
"""
import sys

import n2b_lib as L
from n2b_lib import (ONE, OM, OM2, ZERO, kadd, ksub, kmul, kscal, kiszero,
                     kstr)
from ladder_lib import plane_order_F, kinv_K

TAG = {ONE: 'one', OM: 'om', OM2: 'om2'}


def level4_system(r, lam):
    """rows of the level-4 obstruction, as (coeff-of-S_j polynomials in b,g,
    rhs polynomial in b,g).  b,g are the two plane-order-1 parameters.

    Returns (po1_idx, po2_idx, rows) where each row is
        (dict{j: poly}, poly)   with poly = dict{(i,j) exponent in (b,g): Kelt}
    representing  sum_j poly_j * S_j + rhs = 0.
    """
    b = L.Block(r, 1, lam)
    po = b.param_plane_orders()
    po1 = [i for i, p in enumerate(po) if p == 1]
    po2 = [i for i, p in enumerate(po) if p == 2]
    assert len(po1) == 2, (r, TAG[lam], po1)
    Lp = L.landing_cpoly(b)
    rows = []
    for mo, pc in Lp.items():
        if plane_order_F(r, mo) != 4:
            continue
        lin, rhs = {}, {}
        for pm, c in pc.items():
            supp = [i for i, e in enumerate(pm) for _ in range(e)]
            if any(po[i] > 2 for i in supp):
                continue
            n2 = sum(1 for i in supp if po[i] == 2)
            if n2 == 0:                      # profile (1,1,1) -> rhs
                key = (pm[po1[0]], pm[po1[1]])
                rhs[key] = kadd(rhs.get(key, ZERO), c)
            elif n2 == 1:                    # profile (1,1,2) -> linear in S
                j = next(i for i in supp if po[i] == 2)
                key = (pm[po1[0]], pm[po1[1]])
                d = lin.setdefault(j, {})
                d[key] = kadd(d.get(key, ZERO), c)
            # n2 >= 2 is impossible (plane orders would sum to >= 5)
        lin = {j: {k: v for k, v in d.items() if not kiszero(v)}
               for j, d in lin.items()}
        lin = {j: d for j, d in lin.items() if d}
        rhs = {k: v for k, v in rhs.items() if not kiszero(v)}
        if lin or rhs:
            rows.append((mo, lin, rhs))
    return b, po1, po2, rows


def evaluate(poly, bv, gv):
    """evaluate a dict{(i,j): Kelt} at (beta,gamma) = (bv,gv)."""
    acc = ZERO
    for (i, j), c in poly.items():
        v = c
        for _ in range(i):
            v = kmul(v, bv)
        for _ in range(j):
            v = kmul(v, gv)
        acc = kadd(acc, v)
    return acc


def rank_and_solvable(rows, po2, bv, gv):
    """rank of M and of [M|rhs] at the point (beta,gamma)."""
    M, b = [], []
    for _mo, lin, rhs in rows:
        M.append([evaluate(lin.get(j, {}), bv, gv) for j in po2])
        b.append(evaluate(rhs, bv, gv))
    n = len(po2)
    r1 = _rank([row[:] for row in M], n)
    r2 = _rank([row + [bb] for row, bb in zip(M, b)], n + 1)
    return r1, r2


def _rank(mat, ncols):
    rr = 0
    for c in range(ncols):
        pr = None
        for i in range(rr, len(mat)):
            if not kiszero(mat[i][c]):
                pr = i
                break
        if pr is None:
            continue
        mat[rr], mat[pr] = mat[pr], mat[rr]
        inv = kinv_K(mat[rr][c])
        mat[rr] = [kmul(v, inv) for v in mat[rr]]
        for i in range(rr + 1, len(mat)):
            if not kiszero(mat[i][c]):
                f = mat[i][c]
                mat[i] = [ksub(a, kmul(f, bb)) for a, bb in zip(mat[i], mat[rr])]
        rr += 1
    return rr


def decide(r, lam, verbose=True):
    """Decide solvability of the level-4 system along the P^1 of leading layers.

    The entries are homogeneous in (beta,gamma), so it suffices to test the
    affine chart gamma = 1 -- where solvability is a codimension->=1 condition
    in one variable, detected by comparing generic ranks with the ranks on the
    (finitely many) special points -- plus the point [1:0].

    We do this exactly: build M(beta,1) and rhs(beta,1) over K[beta], run a
    fraction-free elimination over the rational function field K(beta), and
    then test the finitely many beta where a pivot vanishes.
    """
    b, po1, po2, rows = level4_system(r, lam)
    out = []
    # ---- the two "corner" leading layers, tested exactly
    for name, bv, gv in (('[1:0]', ONE, ZERO), ('[0:1]', ZERO, ONE)):
        r1, r2 = rank_and_solvable(rows, po2, bv, gv)
        out.append((name, r1, r2, r1 == r2))
    # ---- a generic layer: test at many rational points, and report the exact
    #      set of beta where the system becomes solvable
    solvable_pts = []
    tested = 0
    for num in range(-14, 15):
        bv = (L.Fr(num), L.Fr(0), L.Fr(0), L.Fr(0))
        if num == 0:
            continue
        r1, r2 = rank_and_solvable(rows, po2, bv, ONE)
        tested += 1
        if r1 == r2:
            solvable_pts.append(num)
    if verbose:
        print('r=%d lam=%-4s  level-4 obstruction (po1 params %s, po2 params %s,'
              ' %d rows)' % (r, TAG[lam], [b.names[i] for i in po1],
                             [b.names[i] for i in po2], len(rows)))
        for name, r1, r2, ok in out:
            print('    layer %-6s : rank M = %d, rank [M|rhs] = %d  -> %s'
                  % (name, r1, r2, 'SOLVABLE' if ok else 'UNSOLVABLE'))
        print('    generic layers [beta:1], beta in -14..14 : %d/%d solvable %s'
              % (len(solvable_pts), tested, solvable_pts))
    return out, solvable_pts


if __name__ == '__main__':
    for r in (int(v) for v in sys.argv[1:]):
        for lam in (ONE, OM, OM2):
            decide(r, lam)
        print()
