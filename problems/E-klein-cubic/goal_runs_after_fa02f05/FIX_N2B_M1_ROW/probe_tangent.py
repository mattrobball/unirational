#!/usr/bin/env python3
"""FIX-N2B: the level-1 ladder condition  Phi(T_0,T_0,T_1) = 0  at a cone point,
solved in the FULL cell space and intersected with each C3-eigenblock.

Modular exploration engine (p = 100057).  Exact-K confirmations are in
verify_n2b.py.
"""
import sys
import n2b_lib as L, modular as MD, fullspace as FS
from n2b_lib import ONE, OM, OM2

p, OMP, KPP = MD.P, MD.OMP, MD.KPP
TAG = {ONE: 'one', OM: 'om', OM2: 'om2'}


def modp(c):
    return L.kmod_p(c, p, OMP, KPP)


def polar_rows_modp(fs, tau, Lp):
    rows = []
    for mo, pc in Lp.items():
        row = [0] * fs.n
        for pm, c in pc.items():
            cc = modp(c)
            if cc == 0:
                continue
            for i, ei in enumerate(pm):
                if ei == 0:
                    continue
                val = cc * ei % p
                for j, ej in enumerate(pm):
                    e = ej - (1 if j == i else 0)
                    if e:
                        val = val * pow(tau[j], e, p) % p
                row[i] = (row[i] + val) % p
        if any(row):
            rows.append((mo, row))
    return rows


def rref(mat, ncols):
    m = [r[:] for r in mat]
    piv, rr = [], 0
    for c in range(ncols):
        pr = next((i for i in range(rr, len(m)) if m[i][c] % p), None)
        if pr is None:
            continue
        m[rr], m[pr] = m[pr], m[rr]
        inv = pow(m[rr][c], p - 2, p)
        m[rr] = [x * inv % p for x in m[rr]]
        for i in range(len(m)):
            if i != rr and m[i][c] % p:
                f = m[i][c]
                m[i] = [(a - f * b) % p for a, b in zip(m[i], m[rr])]
        piv.append(c)
        rr += 1
    return m, piv


def kernel(mat, ncols):
    m, piv = rref(mat, ncols)
    free = [c for c in range(ncols) if c not in piv]
    out = []
    for fc in free:
        v = [0] * ncols
        v[fc] = 1
        for ri, pc in enumerate(piv):
            v[pc] = (-m[ri][fc]) % p
        out.append(v)
    return out, piv


def intersect(kerbasis, blockbasis, n):
    """basis of span(kerbasis) ∩ span(blockbasis) inside F_p^n."""
    if not kerbasis or not blockbasis:
        return []
    k, b = len(kerbasis), len(blockbasis)
    rows = []
    for i in range(n):
        rows.append([kerbasis[j][i] for j in range(k)]
                    + [(-blockbasis[j][i]) % p for j in range(b)])
    sol, _ = kernel(rows, k + b)
    out = []
    for s in sol:
        v = [0] * n
        for j in range(k):
            if s[j]:
                for i in range(n):
                    v[i] = (v[i] + s[j] * kerbasis[j][i]) % p
        if any(v):
            out.append(v)
    if not out:
        return []
    red, piv = rref(out, n)
    return [r for r in red if any(r)]


def analyse(r, tau_named, lam0, label):
    fs = FS.FullSpace(r, 1)
    Lp = fs.landing_cpoly()
    po = fs.param_plane_orders()
    tau = [0] * fs.n
    for nm, v in tau_named.items():
        tau[fs.names.index(nm)] = v % p
    val = [(mo, sum(modp(c) * _pw(tau, pm) % p for pm, c in pc.items()) % p)
           for mo, pc in Lp.items()]
    assert all(v == 0 for _, v in val), 'the given tau is NOT on the cone'
    rows = [row for _, row in polar_rows_modp(fs, tau, Lp)]
    ker, piv = kernel(rows, fs.n)
    print('%s : T_0 in E_%s, dim ker Phi(T0,T0,.) = %d (rank %d of %d)'
          % (label, TAG[lam0], len(ker), len(piv), fs.n))
    lowidx = [i for i, q in enumerate(po) if q == 1]
    for lam in (ONE, OM, OM2):
        bb = [[modp(c) for c in v] for v in fs.block_basis(lam)]
        inter = intersect(ker, bb, fs.n)
        hits = [v for v in inter if any(v[i] for i in lowidx)]
        print('    ∩ E_%-4s : dim %2d   with a plane-order-1 coordinate: %d'
              % (TAG[lam], len(inter), len(hits)))
        for v in hits:
            print('        ', {fs.names[i]: v[i] for i in range(fs.n) if v[i]})
    return


def _pw(tau, pm):
    v = 1
    for j, e in enumerate(pm):
        if e:
            v = v * pow(tau[j], e, p) % p
    return v


if __name__ == '__main__':
    B = 16960
    Bi = pow(B, p - 2, p)
    om = OMP
    om2 = om * om % p
    # (3,6): X = yz.  a' = -UVW ; b'=0 ; B0 = VW + B*WU + B^-1*UV,
    #        B1 = om*sigma B0, B2 = om^2*sigma^2 B0   (lam = om^2)
    fs = FS.FullSpace(6, 1)
    print('supports: a', fs.sa, ' u', fs.su)
