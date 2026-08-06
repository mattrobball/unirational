#!/usr/bin/env python3
"""FIX-H1 TASK 5: the (1,6) cell at POSITIVE line degree.

Conventions (reproduced and re-derived here, cf. FIX-N2B STATUS.md section 2.4).
A family of line degree n is  T = sum_{j=0}^n s^{n-j} t^j T_j  with the A_4
action  Theta : s -> om s, t -> om^2 t, (x,y,z) -> (y,z,x),  and equivariance
Theta(T) = lam g(T).  Expanding,

    Theta(T) = sum_j om^{n-j} om^{2j} s^{n-j} t^j psi(T_j)
             = sum_j om^{n+j} s^{n-j} t^j psi(T_j)  =  lam sum_j s^{n-j}t^j g(T_j)

so  psi(T_j) = lam om^{-(n+j)} g(T_j),  i.e.   T_j in E_{mu_j},
    mu_j = lam * om^{-(n+j)} .                        [= FIX-N2B section 2.4]

Levels: F(T) = 0 splits by (s,t)-bidegree into
    level l:  sum_{a+b+c=l, 0<=a,b,c<=n}  Phi(T_a,T_b,T_c) = 0 ,  l = 0..3n
(the sum is over ORDERED triples).  Level 0 is F(T_0) = 0 and level 3n is
F(T_n) = 0, so T_0 and T_n are cone points.

Degenerate ends.  If T_0 = 0 then t | T and T/t is an A_4-equivariant family of
line degree n-1 with scalar lam*om (Theta(tT') = om^2 t Theta(T') = lam t g(T')
=> Theta(T') = lam om^{-2} g(T') = lam om g(T')).  If T_n = 0 then s | T and
T/s has line degree n-1 with scalar lam*om^2.  Since dividing by s or t changes
neither the plane orders nor r, a plane-order-1 family with T_0 = 0 or T_n = 0
gives one of smaller line degree.  So an INDUCTION on n only has to treat
T_0 != 0 != T_n, i.e. mu_0 != 1 != mu_n (the E_1 cone at r = 6 is {0}).

Scalings.  (s,t) -> (alpha s, beta t) preserves Theta-equivariance and sends
T_j -> alpha^{n-j} beta^j T_j, so over an algebraically closed field T_0 and
T_n may be normalised to be exactly the chosen cone-line representatives.
"""
import itertools
import sys

import holes_lib as H
import fullspace as FS
import n2b_lib as L
from n2b_lib import ONE, OM, OM2

P = 100057
OMP, KPP = 1140, 74361
assert (OMP ** 2 + OMP + 1) % P == 0
assert (8 * KPP ** 2 - 13 * KPP - 4) % P == 0
KMP = (13 * pow(8, P - 2, P) - KPP) % P


# --------------------------------------------------------------------------
class Cone6:
    """the r = 6 full cell space mod p, its cubic, and its 24 cone lines."""

    def __init__(self, p=P, omp=OMP, kpp=KPP, r=6):
        self.p, self.omp, self.kpp, self.r = p, omp, kpp, r
        self.fs = FS.FullSpace(r, 1)
        self.n = self.fs.n
        Lp = self.fs.landing_cpoly()
        self.terms = []
        for mo, pc in Lp.items():
            for pm, c in pc.items():
                cc = L.kmod_p(c, p, omp, kpp)
                if cc:
                    idx = tuple(i for i, e in enumerate(pm) for _ in range(e))
                    self.terms.append((mo, idx, cc))
        self.mons = sorted({mo for mo, _, _ in self.terms})
        self.po = self.fs.param_plane_orders()
        self.po1 = [i for i, q in enumerate(self.po) if q == 1]

    def F(self, v):
        p = self.p
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
        """symmetric trilinear polarisation with Phi(v,v,v) = F(v)."""
        p = self.p
        inv6 = pow(6, p - 2, p)

        def add(*vs):
            return [sum(c) % p for c in zip(*vs)]

        acc = {}
        for sgn, vv in ((1, add(A, B, C)), (-1, add(A, B)), (-1, add(A, C)),
                        (-1, add(B, C)), (1, A), (1, B), (1, C)):
            for k, w in self.F(vv).items():
                acc[k] = (acc.get(k, 0) + sgn * w) % p
        return {k: w * inv6 % p for k, w in acc.items() if w % p}

    # ---------------------------------------------------------------- blocks
    def block(self, lam):
        return [[L.kmod_p(c, self.p, self.omp, self.kpp) for c in v]
                for v in self.fs.block_basis(lam)]

    # ------------------------------------------------------------ cone lines
    def cone_lines(self):
        """the 24 lines of the r=6 cone (Theorem N2B-1).

        Built by FIX-N2B's own `probe_family.cone_lines_r6` (read-only import)
        and INDEPENDENTLY re-checked here: each must satisfy F = 0 in this
        module's own compiled cubic, must lie in the announced eigenblock, and
        must have plane order >= 2.
        """
        import probe_family as PF
        out = []
        for tag, lam in (('om', OM), ('om2', OM2)):
            for (B, branch, v) in PF.cone_lines_r6(lam):
                assert not self.F(v), 'cone line does not land'
                blk = self._which_block(v)
                assert blk == tag, (blk, tag)
                po = min(self.po[i] for i, x in enumerate(v) if x)
                assert po >= 2, po
                out.append((B, branch, tag, po, v))
        return out

    def _which_block(self, v):
        for tag, lam in (('one', ONE), ('om', OM), ('om2', OM2)):
            B = self.block(lam)
            if _in_span(B, v, self.p):
                return tag
        return None


# --------------------------------------------------------------------------
def _sqrt_roots(a, p):
    if pow(a * a - 4, (p - 1) // 2, p) != 1:
        raise RuntimeError('kap^2-4 not a square mod p')
    s = _tonelli((a * a - 4) % p, p)
    inv2 = pow(2, p - 2, p)
    return [(a + s) * inv2 % p, (a - s) * inv2 % p]


def _cube_roots(u, p):
    """the three cube roots of u mod p, for p = 1 mod 3 with 3 || p-1."""
    assert (p - 1) % 3 == 0 and (p - 1) % 9 != 0, 'need 3 || p-1'
    m = (p - 1) // 3
    assert pow(u, m, p) == 1, 'u is not a cube'
    d = pow(3, -1, m)
    b0 = pow(u, d, p)
    assert pow(b0, 3, p) == u
    g = 2
    while pow(g, m, p) == 1:
        g += 1
    om = pow(g, m, p)
    return [b0, b0 * om % p, b0 * om * om % p]


def _tonelli(n, p):
    if p % 4 == 3:
        return pow(n, (p + 1) // 4, p)
    q, s = p - 1, 0
    while q % 2 == 0:
        q //= 2
        s += 1
    z = 2
    while pow(z, (p - 1) // 2, p) != p - 1:
        z += 1
    m, c, t, R = s, pow(z, q, p), pow(n, q, p), pow(n, (q + 1) // 2, p)
    while t != 1:
        i, t2 = 0, t
        while t2 != 1:
            t2 = t2 * t2 % p
            i += 1
        b = pow(c, 1 << (m - i - 1), p)
        m, c = i, b * b % p
        t = t * c % p
        R = R * b % p
    return R


def _rref(mat, ncols, p):
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


def _in_span(basis, v, p):
    mat = [[basis[j][i] for j in range(len(basis))] + [v[i]]
           for i in range(len(v))]
    m, piv = _rref(mat, len(basis) + 1, p)
    return len(basis) not in piv


def kernel(mat, ncols, p):
    m, piv = _rref(mat, ncols, p)
    out = []
    for fc in [c for c in range(ncols) if c not in piv]:
        v = [0] * ncols
        v[fc] = 1
        for ri, pc in enumerate(piv):
            v[pc] = (-m[ri][fc]) % p
        out.append(v)
    return out


def mu(lam_tag, n, j):
    """mu_j = lam om^{-(n+j)} as a tag."""
    base = {'one': 0, 'om': 1, 'om2': 2}[lam_tag]
    e = (base - (n + j)) % 3
    return ('one', 'om', 'om2')[e]


if __name__ == '__main__':
    C = Cone6()
    lines = C.cone_lines()
    print('r=6 cone lines built and checked: %d' % len(lines))
    from collections import Counter
    print('by (branch, block, plane order):',
          Counter((b, lam, po) for _, b, lam, po, _ in lines))
    print('PO1 coordinates of the full space:',
          [C.fs.names[i] for i in C.po1])
    for n in (3, 4, 5, 6):
        for lam in ('one', 'om', 'om2'):
            mus = [mu(lam, n, j) for j in range(n + 1)]
            note = ''
            if mus[0] == 'one':
                note += ' T_0=0 -> reduces to line degree %d, lam=%s' % (
                    n - 1, ('om', 'om2', 'one')[{'one': 0, 'om': 1,
                                                 'om2': 2}[lam]])
            if mus[-1] == 'one':
                note += ' T_n=0 -> reduces to line degree %d' % (n - 1)
            print('n=%d lam=%-4s mu = %s%s' % (n, lam, mus, note))


# --------------------------------------------------------------------------
# the ladder differential  D_T : e |-> 3 Phi(T,T,e)  on a block
# --------------------------------------------------------------------------
def Dmatrix(C, T, basis):
    """rows = U,V,W-monomials, cols = basis vectors; entries of e -> Phi(T,T,e)."""
    cols = []
    for b in basis:
        cols.append(C.Phi(T, T, b))
    mons = sorted({mo for c in cols for mo in c})
    return [[c.get(mo, 0) for c in cols] for mo in mons], mons


def kernel_dim(C, T, basis):
    M, mons = Dmatrix(C, T, basis)
    if not M:
        return len(basis), []
    ker = kernel(M, len(basis), C.p)
    return len(ker), ker


def po1_coords(C, basis):
    """for each basis vector, its plane-order-1 coordinates (indices)."""
    return C.po1


def report_kernels(n, lam):
    C = Cone6()
    lines = C.cone_lines()
    mus = [mu(lam, n, j) for j in range(n + 1)]
    if mus[0] == 'one' or mus[-1] == 'one':
        print('n=%d lam=%s : degenerate end, reduces to line degree %d'
              % (n, lam, n - 1))
        return
    L0 = [x for x in lines if x[2] == mus[0]]
    Ln = [x for x in lines if x[2] == mus[-1]]
    blocks = {t: C.block(H.LAMS[t]) for t in ('one', 'om', 'om2')}
    from collections import Counter
    cnt1, cntn = Counter(), Counter()
    ker1_has_po1 = 0
    for (B, br, tag, po, T0) in L0:
        d, ker = kernel_dim(C, T0, blocks[mus[1]])
        cnt1[d] += 1
        for k in ker:
            v = [0] * C.n
            for c, b in zip(k, blocks[mus[1]]):
                if c:
                    for i in range(C.n):
                        v[i] = (v[i] + c * b[i]) % C.p
            if any(v[i] for i in C.po1):
                ker1_has_po1 += 1
                break
    for (B, br, tag, po, Tn) in Ln:
        d, ker = kernel_dim(C, Tn, blocks[mus[-2]])
        cntn[d] += 1
    print('n=%d lam=%-4s mu=%s : dim ker D_{T_0}|E_%s = %s ; '
          'dim ker D_{T_n}|E_%s = %s ; T_0-kernels containing a plane-order-1 '
          'vector: %d/%d'
          % (n, lam, mus, mus[1], dict(cnt1), mus[-2], dict(cntn),
             ker1_has_po1, len(L0)))
