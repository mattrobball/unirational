#!/usr/bin/env python3
"""FIX-N2B: the SECOND-ORDER specialisation step ("ladder rigidity").

Background (Lemma S of FIX-N2, CELL_TABLE.md section 2).  An A4-equivariant
landing family T of triple-line order r and line degree n expands t-adically at
a C3-fixed point of the line as  T = sum_j t^j T_j  with

    T_j  a C3-equivariant POINTWISE tuple of degree r in J_m,
         with projective scalar  lam_j = lam * om^{-(n+j)},
    T_0 != 0,  F(T_0) = 0.

Lemma S alone decides a cell only when the pointwise cone is trivial.  When it
is not (r >= 6), the next t-adic level decides, via:

  LEMMA S2 (ladder rigidity).  Let ord_J denote the plane-order filtration
  J_1 > J_2 > ...  (J_a * J_b subset J_{a+b}).  The level-l coefficient of
  F(T) = 0 reads

      3 Phi(T_0, T_0, T_l)  =  - sum_{a+b+c=l, a,b,c < l} Phi(T_a,T_b,T_c).

  If T_i lies in J_rho for every i < l, the right-hand side lies in J_{3 rho}.
  Hence, writing

      KK_{3rho}(T_0) := { e in E_mu : Phi(T_0,T_0,e) in J_{3 rho} }   (mu in mu_3),

  which always CONTAINS J_rho ∩ E_mu, we get by induction on l:

      if  rho = ord_J(T_0)  and  KK_{3 rho}(T_0) = J_rho ∩ E_mu  for all mu,
      then  T_i in J_rho for every i,  i.e.  ord_J(T) >= rho.

  Consequently, if the cone at order r has no point of plane order 1, and the
  above rigidity holds at every cone point, then NO A4-equivariant family of
  triple-line order r has common plane order 1, in ANY line degree.

This module computes  KK_N(T_0)  as an exact kernel over the field
K = QQ(om,kp) (or over an extension QQ(om,kp,B,...) supplied by the caller).
"""

import n2b_lib as L
from n2b_lib import ONE, OM, OM2, ZERO, KP, KM, kadd, ksub, kmul, kscal, kiszero


def plane_order_F(r, mo):
    """plane order of the degree-3r x,y,z-monomial encoded by the U,V,W-monomial
    `mo` of the landing polynomial  L = F(T)/(xyz)^{r mod 2}."""
    if r % 2 == 0:
        return 3 * r - 2 * max(mo)
    return 3 * r - (2 * max(mo) + 1)


def polar_cpoly(block, tau):
    """The cpoly  e |-> 3*Phi(T_0,T_0,e) / (xyz)^{r mod 2},  as a cpoly in U,V,W
    whose parameter-monomials are the LINEAR monomials e_i.

    T_0 is the point of the block with parameter vector `tau` (a list of field
    elements).  Implementation: the epsilon-linear part of the landing
    polynomial at v = tau + eps*e, obtained by differentiating the landing
    polynomial symbolically and substituting.
    """
    Lp = L.landing_cpoly(block)
    n = block.n
    out = {}
    for mo, pc in Lp.items():
        d = {}
        for pm, c in pc.items():
            for i, ei in enumerate(pm):
                if ei == 0:
                    continue
                # derivative wrt v_i : coefficient ei * prod tau^(pm - e_i)
                val = kscal(ei, c)
                ok = True
                for j, ej in enumerate(pm):
                    e = ej - (1 if j == i else 0)
                    for _ in range(e):
                        val = kmul(val, tau[j])
                        if kiszero(val):
                            ok = False
                            break
                    if not ok:
                        break
                if not ok or kiszero(val):
                    continue
                key = tuple(1 if j == i else 0 for j in range(n))
                v = kadd(d.get(key, ZERO), val)
                if kiszero(v):
                    d.pop(key, None)
                else:
                    d[key] = v
        if d:
            out[mo] = d
    return out


def eval_cpoly(block, tau):
    """value of the landing polynomial at the parameter point tau."""
    Lp = L.landing_cpoly(block)
    out = {}
    for mo, pc in Lp.items():
        acc = ZERO
        for pm, c in pc.items():
            val = c
            for j, ej in enumerate(pm):
                for _ in range(ej):
                    val = kmul(val, tau[j])
                    if kiszero(val):
                        break
                if kiszero(val):
                    break
            acc = kadd(acc, val)
        if not kiszero(acc):
            out[mo] = acc
    return out


# --------------------------------------------------------------- linear algebra
def kdiv(a, b, kinv):
    return kmul(a, kinv(b))


def kernel(rows, ncols, kinv):
    """kernel of the matrix given by `rows` (lists of field elements)."""
    mat = [list(r) for r in rows]
    piv = []            # (col, row index)
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
        inv = kinv(mat[rr][c])
        mat[rr] = [kmul(v, inv) for v in mat[rr]]
        for i in range(len(mat)):
            if i != rr and not kiszero(mat[i][c]):
                f = mat[i][c]
                mat[i] = [ksub(a, kmul(f, b)) for a, b in zip(mat[i], mat[rr])]
        piv.append(c)
        rr += 1
        if rr == len(mat):
            break
    free = [c for c in range(ncols) if c not in piv]
    basis = []
    for fc in free:
        v = [ZERO] * ncols
        v[fc] = ONE
        for ri, pc in enumerate(piv):
            v[pc] = kneg_(mat[ri][fc])
        basis.append(v)
    return basis, piv


def kneg_(a):
    return (-a[0], -a[1], -a[2], -a[3])


def kinv_K(a):
    """inverse in K = QQ(om,kp) by solving a 4x4 rational linear system."""
    from fractions import Fraction as Fr
    basis = [ONE, OM, KP, kmul(OM, KP)]
    cols = []
    for b in basis:
        cols.append(kmul(a, b))
    # solve  M z = e_0   where M[i][j] = coefficient i of a*basis[j]
    M = [[cols[j][i] for j in range(4)] + [Fr(1) if i == 0 else Fr(0)]
         for i in range(4)]
    for c in range(4):
        pr = next((i for i in range(c, 4) if M[i][c] != 0), None)
        if pr is None:
            raise ZeroDivisionError('not invertible')
        M[c], M[pr] = M[pr], M[c]
        pv = M[c][c]
        M[c] = [v / pv for v in M[c]]
        for i in range(4):
            if i != c and M[i][c] != 0:
                f = M[i][c]
                M[i] = [a - f * b for a, b in zip(M[i], M[c])]
    return (M[0][4], M[1][4], M[2][4], M[3][4])


def ladder_kernel(block, tau, N, kinv=kinv_K):
    """basis of KK_N(T_0) = { e : Phi(T_0,T_0,e) in J_N }, inside the block."""
    r = block.r
    Pol = polar_cpoly(block, tau)
    rows = []
    for mo, d in Pol.items():
        if plane_order_F(r, mo) >= N:
            continue
        rows.append([d.get(tuple(1 if j == i else 0 for j in range(block.n)),
                           ZERO) for i in range(block.n)])
    if not rows:
        rows = [[ZERO] * block.n]
    basis, piv = kernel(rows, block.n, kinv)
    return basis, len(piv)
