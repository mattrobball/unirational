#!/usr/bin/env python3
"""FIX-N2B: the FULL K-equivariant cell space (no C3 imposed), its landing
polynomial, and the embeddings of the three C3-eigenblocks.

Needed because the t-adic pieces T_j of an A4-equivariant family lie in
DIFFERENT C3-eigenblocks: T_j in E_{lam * om^{-(n+j)}}.  A ladder condition of
the shape  Phi(T_0,T_0,e) = 0  therefore has to be solved for e in the whole
32- (resp. 39-, 54-, 62-) dimensional cell space, and the answer intersected
with each eigenblock separately.

Parameter layout (even r):  P (na) | R (na) | B0 (nu) | B1 (nu) | B2 (nu)
                (odd  r):  Q (na) | S (na) | A0 (nu) | A1 (nu) | A2 (nu)
"""
import n2b_lib as L
from n2b_lib import (ONE, OM, OM2, ZERO, KP, KM, kadd, ksub, kmul, kiszero,
                     kinv_of_root_of_unity, cp_zero, cp_addto, cp_mul, cp_scal,
                     cp_shift, support, plane_order, sigma, eigen_basis)


class FullSpace:
    def __init__(self, r, m=1):
        self.r, self.m = r, m
        self.sa = support(r, m, 'a')
        self.su = support(r, m, 'u0')
        na, nu = len(self.sa), len(self.su)
        self.na, self.nu = na, nu
        self.n = 2 * na + 3 * nu
        self.names = (['P%d' % i for i in range(na)]
                      + ['R%d' % i for i in range(na)]
                      + ['C%d_%d' % (j, i) for j in range(3) for i in range(nu)])
        self.offsets = (0, na, 2 * na, 2 * na + nu, 2 * na + 2 * nu)

    def _lin(self, monos, off):
        out = {}
        for i, mo in enumerate(monos):
            e = [0] * self.n
            e[off + i] = 1
            out.setdefault(mo, {})[tuple(e)] = ONE
        return out

    def components(self):
        o = self.offsets
        P = self._lin(self.sa, o[0])
        R = self._lin(self.sa, o[1])
        B0 = self._lin(self.su, o[2])
        B1 = self._lin(self.su, o[3])
        B2 = self._lin(self.su, o[4])
        return P, R, B0, B1, B2

    def landing_cpoly(self):
        P, R, B0, B1, B2 = self.components()
        r = self.r
        out = cp_zero()
        s0 = cp_zero(); cp_addto(s0, P); cp_addto(s0, R)
        s1 = cp_zero(); cp_addto(s1, P, OM); cp_addto(s1, R, OM2)
        s2 = cp_zero(); cp_addto(s2, P, OM2); cp_addto(s2, R, OM)
        cube = cp_zero()
        cp_addto(cube, cp_mul(cp_mul(P, P), P), KP)
        cp_addto(cube, cp_mul(cp_mul(R, R), R), KM)
        if r % 2 == 0:
            cp_addto(out, cube)
            cp_addto(out, cp_shift(cp_mul(s0, cp_mul(B0, B0)), (0, 1, 1)))
            cp_addto(out, cp_shift(cp_mul(s1, cp_mul(B1, B1)), (1, 0, 1)))
            cp_addto(out, cp_shift(cp_mul(s2, cp_mul(B2, B2)), (1, 1, 0)))
            cp_addto(out, cp_shift(cp_mul(cp_mul(B0, B1), B2), (1, 1, 1)))
        else:
            cp_addto(out, cp_shift(cube, (1, 1, 1)))
            cp_addto(out, cp_shift(cp_mul(s0, cp_mul(B0, B0)), (1, 0, 0)))
            cp_addto(out, cp_shift(cp_mul(s1, cp_mul(B1, B1)), (0, 1, 0)))
            cp_addto(out, cp_shift(cp_mul(s2, cp_mul(B2, B2)), (0, 0, 1)))
            cp_addto(out, cp_mul(cp_mul(B0, B1), B2))
        return out

    # ------------------------------------------------------------------ blocks
    def block_basis(self, lam):
        """basis of E_lam inside the n-dimensional space, as n-vectors over K."""
        r, m = self.r, self.m
        idxa = {mo: i for i, mo in enumerate(self.sa)}
        idxu = {mo: i for i, mo in enumerate(self.su)}
        o = self.offsets
        out = []
        for eig, off in ((kmul(lam, OM), o[0]), (kmul(lam, OM2), o[1])):
            for bvec in eigen_basis(self.sa, eig):
                v = [ZERO] * self.n
                for mo, c in bvec.items():
                    v[off + idxa[mo]] = c
                out.append(v)
        lami = kinv_of_root_of_unity(lam)
        for mo in self.su:
            v = [ZERO] * self.n
            v[o[2] + idxu[mo]] = ONE
            v[o[3] + idxu[sigma(mo)]] = lami
            v[o[4] + idxu[sigma(sigma(mo))]] = kmul(lami, lami)
            out.append(v)
        return out

    def param_plane_orders(self):
        """plane order of every coordinate of the full cell space.

        u_0' = yz B0, u_1' = zx B1, u_2' = xy B2 (even r) carry DIFFERENT
        exponent patterns, so the plane order of the coefficient of the same
        U,V,W-monomial differs from slot to slot; the u_1'-pattern is the
        u_0'-pattern at sigma^{-1}(mo) and the u_2'-pattern at sigma^{-2}(mo).
        """
        po = []
        for _ in range(2):
            po += [plane_order(self.r, 'a', mo) for mo in self.sa]
        po += [plane_order(self.r, 'u0', mo) for mo in self.su]
        po += [plane_order(self.r, 'u0', (mo[1], mo[2], mo[0]))
               for mo in self.su]
        po += [plane_order(self.r, 'u0', (mo[2], mo[0], mo[1]))
               for mo in self.su]
        return po


# ---------------------------------------------------------------- linear algebra
def polar_rows(FS, tau, Lp=None):
    """rows of the linear map  e |-> 3 Phi(T_0,T_0,e)  at the point tau."""
    Lp = Lp if Lp is not None else FS.landing_cpoly()
    n = FS.n
    rows = []
    for mo, pc in Lp.items():
        row = [ZERO] * n
        for pm, c in pc.items():
            for i, ei in enumerate(pm):
                if ei == 0:
                    continue
                val = c if ei == 1 else L.kscal(ei, c)
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
                row[i] = kadd(row[i], val)
        if any(not kiszero(v) for v in row):
            rows.append((mo, row))
    return rows
