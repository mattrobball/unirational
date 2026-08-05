#!/usr/bin/env python3
"""FIX-N2B: MACHINE PROBE for an A4-equivariant landing family of common plane
order 1 at a given triple-line order r and line degree n.

By Lemma S the t-adic pieces are  T_j in E_{lam om^{-(n+j)}}, with T_0 and T_n
on the C3-equivariant pointwise CONE (levels 0 and 3n of F(T) = 0) and the
intermediate pieces free.  The level equations are

    level l :  sum_{a+b+c = l}  Phi(T_a,T_b,T_c) = 0 ,   l = 0..3n.

For n = 2 with T_0, T_2 nonzero cone points the scalings of T_0 and T_2 can be
normalised away ((s,t) -> (s,ct) rescales T_j by c^j), so the search is: for
each pair (T_0, T_2) of cone lines, solve levels 1..5 for T_1, and ask whether
any solution has a nonzero plane-order-1 coordinate.

Modular engine (p = 100057) -- a SEARCH device.  Anything found is lifted and
re-verified exactly in characteristic zero by verify_n2b.py.
"""
import itertools
import sys

import fullspace as FS
import modular as MD
import n2b_lib as L
from n2b_lib import ONE, OM, OM2

p, OMP, KPP = MD.P, MD.OMP, MD.KPP
KMP = MD.KMP
TAG = {ONE: 'one', OM: 'om', OM2: 'om2'}


def modp(c):
    return L.kmod_p(c, p, OMP, KPP)


class Cubic:
    def __init__(self, r, m=1):
        self.fs = FS.FullSpace(r, m)
        Lp = self.fs.landing_cpoly()
        self.terms = []
        for mo, pc in Lp.items():
            for pm, c in pc.items():
                cc = modp(c)
                if cc:
                    self.terms.append((mo, tuple(i for i, e in enumerate(pm)
                                                 for _ in range(e)), cc))
        self.mons = sorted({mo for mo, _, _ in self.terms})

    def F(self, v):
        out = {}
        for mo, idx, c in self.terms:
            val = c
            for i in idx:
                val = val * v[i] % p
                if val == 0:
                    break
            if val:
                out[mo] = (out.get(mo, 0) + val) % p
        return {k: w for k, w in out.items() if w}

    def Phi(self, A, B, C):
        """symmetric trilinear polarisation, via the standard identity."""
        inv6 = pow(6, p - 2, p)
        def add(*vs):
            return [sum(x) % p for x in zip(*vs)]
        acc = {}
        for sgn, vv in ((1, add(A, B, C)), (-1, add(A, B)), (-1, add(A, C)),
                        (-1, add(B, C)), (1, A), (1, B), (1, C)):
            for k, w in self.F(vv).items():
                acc[k] = (acc.get(k, 0) + sgn * w) % p
        return {k: w * inv6 % p for k, w in acc.items() if w % p}


# ------------------------------------------------------------------ linear algebra
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
    return out


# ------------------------------------------------------------------ cone points
def cube_roots(u):
    return [B for B in range(1, p) if pow(B, 3, p) == u]


def cone_lines_r6(lam):
    """the 12 lines of the r=6 cone in E_lam (lam = om, om2), as full-space
    vectors mod p.  Derived in STATUS.md section "the r=6 cone"."""
    kap = KPP if lam == OM2 else KMP
    # u + 1/u = kap + 2
    s = MD.KMP  # placeholder
    disc = ((kap + 2) ** 2 - 4) % p
    sq = tonelli(disc)
    inv2 = pow(2, p - 2, p)
    Bs = []
    for sg in (1, p - 1):
        u = (kap + 2 + sg * sq) % p * inv2 % p
        Bs += cube_roots(u)
    assert len(Bs) == 6, Bs
    fs = FS.FullSpace(6, 1)
    om = OMP
    om2 = om * om % p
    idx = {n: i for i, n in enumerate(fs.names)}
    lamv = om if lam == OM else om2
    lami = pow(lamv, p - 2, p)
    out = []
    for B in Bs:
        Bi = pow(B, p - 2, p)
        for branch in ('A', 'B'):
            v = [0] * fs.n
            head = 'R3' if lam == OM else 'P3'
            v[idx[head]] = p - 1                      # a' resp. b' = -(xyz)^2
            if branch == 'A':                          # C = VW + B WU + B^-1 UV
                c = {'C0_4': 1, 'C0_2': B, 'C0_1': Bi}
            else:                                      # C = U^2 + B UV + B^-1 UW
                c = {'C0_0': 1, 'C0_1': B, 'C0_2': Bi}
            for nm, val in c.items():
                v[idx[nm]] = val
            # C1 = lam^-1 sigma C0 ,  C2 = lam^-1 sigma C1
            for j in (1, 2):
                for i, mo in enumerate(fs.su):
                    src = fs.su.index((mo[1], mo[2], mo[0]))   # sigma^{-1} mo
                    v[idx['C%d_%d' % (j, i)]] = \
                        v[idx['C%d_%d' % (j - 1, src)]] * lami % p
            out.append((B, branch, v))
    return out


def tonelli(a):
    if a == 0:
        return 0
    assert pow(a, (p - 1) // 2, p) == 1, 'not a square'
    q, s2 = p - 1, 0
    while q % 2 == 0:
        q //= 2
        s2 += 1
    z = 2
    while pow(z, (p - 1) // 2, p) != p - 1:
        z += 1
    m, c, t, rr = s2, pow(z, q, p), pow(a, q, p), pow(a, (q + 1) // 2, p)
    while t != 1:
        i, tt = 0, t
        while tt != 1:
            tt = tt * tt % p
            i += 1
        b = pow(c, 1 << (m - i - 1), p)
        m, c = i, b * b % p
        t = t * c % p
        rr = rr * b % p
    return rr


def flatten(d, mons):
    return [d.get(mo, 0) for mo in mons]


def search_n2(r=6, verbose=True):
    """line degree 2: T_0 in E_om cone, T_1 in E_1 free, T_2 in E_om2 cone."""
    C = Cubic(r)
    fs = C.fs
    po = fs.param_plane_orders()
    low = [i for i, q in enumerate(po) if q == 1]
    E1 = [[modp(c) for c in v] for v in fs.block_basis(ONE)]
    lines0 = cone_lines_r6(OM)
    lines2 = cone_lines_r6(OM2)
    for _, _, v in lines0 + lines2:
        assert not C.F(v), 'cone line does not land'
    if verbose:
        print('r=%d : %d cone lines in E_om, %d in E_om2, dim E_1 = %d'
              % (r, len(lines0), len(lines2), len(E1)))
    hits = []
    for (B0, br0, T0) in lines0:
        for (B2, br2, T2) in lines2:
            # levels 1 and 5 are linear in T_1
            rows = []
            for basis in (E1,):
                pass
            cols = len(E1)
            M = []
            for e in E1:
                c1 = C.Phi(T0, T0, e)
                c5 = C.Phi(e, T2, T2)
                M.append(flatten(c1, C.mons) + flatten(c5, C.mons))
            rows = [[M[j][i] for j in range(cols)] for i in range(len(M[0]))]
            ker = kernel(rows, cols)
            if not ker:
                continue
            # impose levels 2,3,4 on the (small) kernel
            sols = solve_small(C, T0, T2, [combine(E1, k) for k in ker])
            for sv in sols:
                if any(sv[i] for i in low):
                    hits.append((B0, br0, B2, br2, sv))
            if verbose and ker:
                print('   T0=(B=%d,%s) T2=(B=%d,%s): dim ker(levels 1,5) = %d,'
                      ' level-2,3,4 solutions = %d'
                      % (B0, br0, B2, br2, len(ker), len(sols)))
    return hits


def combine(basis, coeffs):
    n = len(basis[0])
    v = [0] * n
    for c, b in zip(coeffs, basis):
        if c:
            for i in range(n):
                v[i] = (v[i] + c * b[i]) % p
    return v


def solve_small(C, T0, T2, kerbasis, tries=4000):
    """brute/parametric solve of levels 2,3,4 on span(kerbasis) (dim <= 2)."""
    d = len(kerbasis)
    out = []
    if d == 0:
        return out

    def ok(v):
        l2 = C.Phi(T0, T0, T2)
        l2b = C.Phi(T0, v, v)
        if any((l2.get(mo, 0) + l2b.get(mo, 0)) % p for mo in C.mons):
            return False
        l4 = C.Phi(T0, T2, T2)
        l4b = C.Phi(v, v, T2)
        if any((l4.get(mo, 0) + l4b.get(mo, 0)) % p for mo in C.mons):
            return False
        l3 = C.Phi(T0, v, T2)
        f1 = C.F(v)
        if any((6 * l3.get(mo, 0) + f1.get(mo, 0)) % p for mo in C.mons):
            return False
        return True

    if d == 1:
        # v = c * k ; the levels are polynomial in c of degree <= 3 -> test by
        # interpolation over enough values
        for c in range(p):
            if c > tries:
                break
            v = combine(kerbasis, [c])
            if ok(v):
                out.append(v)
        return out
    for c1 in range(min(p, 200)):
        for c2 in range(min(p, 200)):
            v = combine(kerbasis, [c1, c2])
            if any(v) and ok(v):
                out.append(v)
    return out


if __name__ == '__main__':
    hits = search_n2(6)
    print('plane-order-1 hits:', len(hits))
    for h in hits[:5]:
        print(h)
