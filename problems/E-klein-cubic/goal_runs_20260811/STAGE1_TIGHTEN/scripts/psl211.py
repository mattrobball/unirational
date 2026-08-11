"""Shared exact-mod-p model of PSL(2,11) in its 5-dimensional Klein representation.

Reduces the repository's exact Q(zeta_11) matrices of
`certificates/exact_weil_check.py` modulo a split prime p with 11 | p-1 and
5 | p-1 (so that every element order in {1,2,3,5,6,11} splits).  The repo's
own full-split prime is p = 331 (certificates/STRATA_EXACT.md:98); the second
prime used by this packet's verifier is p = 661.

Nothing here is a char-0 proof on its own.  Every conclusion drawn from this
module in REPORT.md is either (i) a rank/dimension statement stable under
reduction and cross-checked at two primes, or (ii) a purely group-theoretic
statement about the 660 matrices, which determine PSL(2,11) up to isomorphism.

Klein cubic:  F = sum_{i in Z/5} x_i^2 x_{i+1}.
"""
from collections import defaultdict

SPLIT_PRIMES = (331, 661)


class Model:
    def __init__(self, p):
        assert (p - 1) % 11 == 0 and (p - 1) % 5 == 0, "p must split orders 5 and 11"
        self.p = p
        self._build()

    # ---------- field helpers ----------
    def inv(self, a):
        return pow(a % self.p, self.p - 2, self.p)

    def _root(self, n):
        p = self.p
        for g in range(2, p):
            r = pow(g, (p - 1) // n, p)
            if r != 1:
                return r
        raise RuntimeError("no root")

    # ---------- representation ----------
    def _build(self):
        p = self.p
        zeta = self._root(11)
        zp = [pow(zeta, i, p) for i in range(11)]
        qr = {1, 3, 4, 5, 9}
        gauss = sum((1 if a in qr else -1) * zp[a] for a in range(1, 11)) % p
        assert (gauss * gauss - (-11)) % p == 0, "Gauss sum check failed"
        js = [1, 3, 2, 5, 4]
        signs = [1, 1, -1, 1, 1]
        S = [[(signs[k] * self.inv(signs[i])) * (zp[(9 * j * l) % 11] - zp[(-9 * j * l) % 11]) % p
              * (-gauss) % p * self.inv(11) % p for k, l in enumerate(js)] for i, j in enumerate(js)]
        T = [[zp[(js[i] * js[i]) % 11] if i == j else 0 for j in range(5)] for i in range(5)]
        self.Id = tuple(tuple(int(i == j) for j in range(5)) for i in range(5))
        S = self._t(S)
        T = self._t(T)
        G = {self.Id}
        frontier = [self.Id]
        while frontier:
            nf = []
            for A in frontier:
                for g in (S, T):
                    B = self.mm(A, g)
                    if B not in G:
                        G.add(B)
                        nf.append(B)
            frontier = nf
        self.G = sorted(G)
        assert len(self.G) == 660, len(self.G)
        self.order = {A: self.morder(A) for A in self.G}
        self.invols = [A for A in self.G if self.order[A] == 2]

    def _t(self, A):
        return tuple(tuple(x % self.p for x in r) for r in A)

    def mm(self, A, B):
        p = self.p
        return tuple(tuple(sum(A[i][k] * B[k][j] for k in range(5)) % p for j in range(5))
                     for i in range(5))

    def morder(self, A):
        B, n = A, 1
        while B != self.Id:
            B = self.mm(B, A)
            n += 1
        return n

    def matinv(self, A):
        p = self.p
        M = [list(A[i]) + [int(i == j) for j in range(5)] for i in range(5)]
        r = 0
        for c in range(5):
            pr = next(i for i in range(r, 5) if M[i][c] % p)
            M[r], M[pr] = M[pr], M[r]
            iv = self.inv(M[r][c])
            M[r] = [x * iv % p for x in M[r]]
            for i in range(5):
                if i != r and M[i][c] % p:
                    f = M[i][c]
                    M[i] = [(x - f * y) % p for x, y in zip(M[i], M[r])]
            r += 1
        return tuple(tuple(M[i][5:]) for i in range(5))

    def act(self, A, v):
        p = self.p
        return tuple(sum(A[i][j] * v[j] for j in range(5)) % p for i in range(5))

    # ---------- linear algebra ----------
    def rref(self, rows):
        p = self.p
        M = [list(r) for r in rows]
        m = len(M)
        n = 5
        piv = []
        r = 0
        for c in range(n):
            pr = None
            for i in range(r, m):
                if M[i][c] % p:
                    pr = i
                    break
            if pr is None:
                continue
            M[r], M[pr] = M[pr], M[r]
            iv = self.inv(M[r][c])
            M[r] = [x * iv % p for x in M[r]]
            for i in range(m):
                if i != r and M[i][c] % p:
                    f = M[i][c]
                    M[i] = [(x - f * y) % p for x, y in zip(M[i], M[r])]
            piv.append(c)
            r += 1
            if r == m:
                break
        return tuple(tuple(row) for row in M[:r]), tuple(piv)

    def rank(self, rows):
        return len(self.rref(rows)[0])

    def canon(self, rows):
        return self.rref(rows)[0]

    def nullspace(self, rows):
        R, piv = self.rref(rows)
        free = [c for c in range(5) if c not in piv]
        basis = []
        for f in free:
            v = [0] * 5
            v[f] = 1
            for i, c in enumerate(piv):
                v[c] = (-R[i][f]) % self.p
            basis.append(tuple(v))
        return self.canon(basis) if basis else ()

    def eigsp(self, A, lam):
        p = self.p
        rows = [[(A[i][j] - (lam if i == j else 0)) % p for j in range(5)] for i in range(5)]
        return self.canon(self.nullspace(rows)) if self.nullspace(rows) else ()

    def perp(self, U):
        return self.nullspace(list(U)) if U else tuple(tuple(int(i == j) for j in range(5))
                                                       for i in range(5))

    def inter(self, U, V):
        if not U or not V:
            return ()
        pu, pv = self.perp(U), self.perp(V)
        ns = self.nullspace(list(pu) + list(pv))
        return self.canon(ns) if ns else ()

    def contains_pt(self, U, v):
        return self.rank(list(U) + [list(v)]) == len(U)

    def setstab(self, U):
        cu = self.canon(U)
        return [A for A in self.G
                if self.canon([list(self.act(A, v)) for v in U]) == cu]

    # ---------- Klein cubic ----------
    def F(self, v):
        p = self.p
        return sum(v[i] * v[i] % p * v[(i + 1) % 5] for i in range(5)) % p

    # ---------- strata ----------
    def plus_plane(self, sigma):
        return self.eigsp(sigma, 1)

    def minus_line(self, sigma):
        return self.eigsp(sigma, self.p - 1)

    def klein_fours(self):
        """All 55 Klein four-subgroups, as frozensets of matrices."""
        out = set()
        for i, a in enumerate(self.invols):
            for b in self.invols[i + 1:]:
                if self.mm(a, b) == self.mm(b, a):
                    out.add(frozenset([self.Id, a, b, self.mm(a, b)]))
        return sorted(out, key=lambda H: sorted(self.G.index(x) for x in H))

    def v4_decomp(self, H):
        """W = A + B + C + D with characters (triv, chi_z, chi_s, chi_r),
        dims (2,1,1,1), where ker chi_z = <z> etc."""
        z, s, r = [x for x in H if x != self.Id]
        A = self.inter(self.eigsp(z, 1), self.eigsp(s, 1))
        B = self.inter(self.eigsp(z, 1), self.eigsp(s, self.p - 1))
        C = self.inter(self.eigsp(z, self.p - 1), self.eigsp(s, 1))
        D = self.inter(self.eigsp(z, self.p - 1), self.eigsp(s, self.p - 1))
        return (z, s, r), (A, B, C, D)

    def ell_V(self, H):
        return self.v4_decomp(H)[1][0]


def normpt(m, v):
    for x in v:
        if x % m.p:
            iv = m.inv(x)
            return tuple(y * iv % m.p for y in v)
    return None
