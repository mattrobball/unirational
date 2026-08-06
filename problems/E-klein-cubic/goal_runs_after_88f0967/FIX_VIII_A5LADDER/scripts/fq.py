"""Minimal F_{p^k} layer.

The field is built as a tensor product  F_p[th_1] (x) ... (x) F_p[th_s]  of
extensions of PAIRWISE COPRIME degrees, each given by the companion matrix of
multiplication by th_i.  That is exactly the shape needed here: the candidate
branch points are roots of small polynomials whose irreducible factors have
degrees 1, 2 and 3, and the compositum of F_{p^2} and F_{p^3} is F_{p^6}.
No root finding is needed: th_i is a root by construction and its conjugates
are th_i^(p^j).

Elements are numpy arrays whose LAST axis has length k = prod(k_i).
"""
import numpy as np
from a5lib import mm, inv_p


def companion(monic, p):
    """monic = coefficients high->low of a monic poly of degree m;
    returns the m x m matrix of multiplication by theta on basis 1..th^{m-1}."""
    m = len(monic) - 1
    Th = np.zeros((m, m))
    for j in range(m - 1):
        Th[j + 1, j] = 1
    for j in range(m):
        Th[j, m - 1] = (-monic[m - j]) % p
    return Th % p


class Fq:
    def __init__(self, p, blocks):
        """blocks = list of companion matrices (possibly empty -> F_p)."""
        self.p = p
        self.blocks = blocks
        self.ks = [B.shape[0] for B in blocks]
        self.k = int(np.prod(self.ks)) if blocks else 1
        tabs = []
        for B in blocks:
            m = B.shape[0]
            P = [np.eye(m)]
            for _ in range(1, m):
                P.append(mm(P[-1], B, p))
            e0 = np.zeros((m, 1)); e0[0, 0] = 1
            pw = [mm(P[i], e0, p).ravel() for i in range(m)]
            t = np.zeros((m, m, m))
            for i in range(m):
                for j in range(m):
                    t[i, j] = mm(P[i], pw[j][:, None], p).ravel() % p
            tabs.append(t)
        tab = np.ones((1, 1, 1))
        for t in tabs:
            m = t.shape[0]
            K = tab.shape[0]
            new = np.einsum('abc,ijl->aibjcl', tab, t).reshape(K * m, K * m, K * m)
            tab = new % p
        self.tab = tab % p

    # ---- basics
    def zero(self, shape=()):
        return np.zeros(shape + (self.k,))

    def fp(self, x):
        x = np.asarray(x, dtype=np.float64)
        out = np.zeros(x.shape + (self.k,))
        out[..., 0] = x % self.p
        return out

    def one(self):
        return self.fp(1.0)

    def gen(self, b):
        """theta_b as an element (b = block index)"""
        idx, stride = 0, 1
        for j in range(len(self.ks) - 1, -1, -1):
            if j == b:
                idx = stride
            stride *= self.ks[j]
        out = np.zeros(self.k)
        out[idx] = 1
        return out

    def mul(self, a, b):
        return np.einsum('...i,...j,ijl->...l', a, b, self.tab) % self.p

    def mulmat(self, a):
        return np.einsum('i,ijl->lj', a, self.tab) % self.p

    def inv(self, a):
        Mi = inv_p(self.mulmat(a), self.p)
        assert Mi is not None, 'not invertible in F_q'
        e0 = np.zeros((self.k, 1)); e0[0, 0] = 1
        return mm(Mi, e0, self.p).ravel() % self.p

    def is_zero(self, a):
        return not np.any(np.asarray(a) % self.p)

    def power(self, a, e):
        r, b = self.one(), a.copy()
        while e:
            if e & 1:
                r = self.mul(r, b)
            b = self.mul(b, b)
            e >>= 1
        return r

    def frob(self, a, times=1):
        for _ in range(times):
            a = self.power(a, self.p)
        return a

    # ---- linear algebra: matrices are (rows, cols, k)
    def rref(self, A):
        p = self.p
        A = np.array(A, dtype=np.float64) % p
        rows, cols, k = A.shape
        piv, r = [], 0
        for c in range(cols):
            if r >= rows:
                break
            nz = [i for i in range(r, rows) if np.any(A[i, c] % p)]
            if not nz:
                continue
            i = nz[0]
            if i != r:
                A[[r, i]] = A[[i, r]]
            iv = self.inv(A[r, c])
            A[r] = self.mul(A[r], iv[None, :])
            col = A[:, c, :].copy()
            col[r] = 0
            act = [i for i in range(rows) if np.any(col[i] % p)]
            if act:
                A[act] = (A[act] - self.mul(col[act][:, None, :], A[r][None, :, :])) % p
            piv.append(c)
            r += 1
        return A[:r], piv

    def nullspace(self, A):
        rows, cols, k = A.shape
        R, piv = self.rref(A)
        free = [c for c in range(cols) if c not in piv]
        out = []
        for f in free:
            v = self.zero((cols,))
            v[f] = self.one()
            for i, c in enumerate(piv):
                v[c] = (-R[i, f]) % self.p
            out.append(v)
        return np.array(out) if out else np.zeros((0, cols, k))


def subfield_of(S, fq):
    """smallest block-subfield of fq containing all entries of S -> (k_eff, idx)"""
    used = set(np.nonzero(np.any(np.abs(S) > 0, axis=tuple(range(S.ndim - 1))))[0])
    ks = fq.ks
    cands = []
    if not ks:
        return 1, [0]
    strides, st = [], 1
    for kk in ks[::-1]:
        strides.insert(0, st)
        st *= kk
    # candidate subfields: any subset of blocks
    for mask in range(1 << len(ks)):
        idx = [0]
        for bi in range(len(ks)):
            if mask >> bi & 1:
                idx = [i + j * strides[bi] for i in idx for j in range(ks[bi])]
        idx = sorted(idx)
        if used <= set(idx):
            cands.append(idx)
    idx = min(cands, key=len)
    return len(idx), idx


def sub_fq(idx, fq):
    """Fq object on the sub-basis idx (must be closed under multiplication)"""
    k = len(idx)
    tab = fq.tab[np.ix_(idx, idx, list(range(fq.k)))]
    assert not np.any(np.delete(tab, idx, axis=2) % fq.p), 'not a subfield'
    sub = Fq.__new__(Fq)
    sub.p, sub.blocks, sub.ks, sub.k = fq.p, None, [k], k
    sub.tab = tab[:, :, idx] % fq.p
    return sub
