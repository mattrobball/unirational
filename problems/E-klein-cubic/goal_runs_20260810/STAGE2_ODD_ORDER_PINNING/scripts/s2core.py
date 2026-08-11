"""Stage-2 odd-order pinning: shared exact-mod-p model of PSL(2,11) on W.

Reduces the repository's exact Q(zeta_11) matrices of
`certificates/exact_weil_check.py` modulo a split prime p with 330 | p-1, so
that every element order in {1,2,3,5,6,11} splits and every needed root of
unity exists.  p = 331 and p = 661 are the repo's two split primes
(331 = 330+1, 661 = 2*330+1).

This module is byte-compatible in spirit with
`goal_runs_20260810/STAGE1_COMPLEX_MAPS/scripts/psl211.py` (same S, T
construction); it adds the eigen-basis layer that Stage 2 needs.

Klein cubic:  F = sum_{i in Z/5} x_i^2 x_{i+1}.
"""

SPLIT_PRIMES = (331, 661)
QR11 = (1, 3, 4, 5, 9)          # quadratic residues mod 11
NQR11 = (2, 6, 7, 8, 10)


class Model:
    def __init__(self, p):
        assert (p - 1) % 330 == 0, "p must satisfy 330 | p-1"
        self.p = p
        self._build()

    # ---------- field ----------
    def inv(self, a):
        return pow(a % self.p, self.p - 2, self.p)

    def root(self, n):
        """A primitive n-th root of unity in F_p."""
        p = self.p
        assert (p - 1) % n == 0
        for g in range(2, p):
            r = pow(g, (p - 1) // n, p)
            if r != 1 and all(pow(r, n // q, p) != 1 for q in _primes(n)):
                return r
        raise RuntimeError("no primitive root")

    # ---------- representation ----------
    def _build(self):
        p = self.p
        zeta = self.root(11)
        zp = [pow(zeta, i, p) for i in range(11)]
        qr = set(QR11)
        gauss = sum((1 if a in qr else -1) * zp[a] for a in range(1, 11)) % p
        assert (gauss * gauss - (-11)) % p == 0, "Gauss sum check failed"
        js = [1, 3, 2, 5, 4]
        signs = [1, 1, -1, 1, 1]
        S = [[(signs[k] * self.inv(signs[i])) * (zp[(9 * j * l) % 11] - zp[(-9 * j * l) % 11]) % p
              * (-gauss) % p * self.inv(11) % p for k, l in enumerate(js)] for i, j in enumerate(js)]
        Tm = [[zp[(js[i] * js[i]) % 11] if i == j else 0 for j in range(5)] for i in range(5)]
        self.zeta11 = zeta
        self.Tdiag = [ (js[i] * js[i]) % 11 for i in range(5) ]   # (1,9,4,3,5)
        self.Id = tuple(tuple(int(i == j) for j in range(5)) for i in range(5))
        S = self._t(S)
        Tm = self._t(Tm)
        self.S, self.T = S, Tm
        G = {self.Id}
        frontier = [self.Id]
        while frontier:
            nf = []
            for A in frontier:
                for g in (S, Tm):
                    B = self.mm(A, g)
                    if B not in G:
                        G.add(B)
                        nf.append(B)
            frontier = nf
        self.G = sorted(G)
        assert len(self.G) == 660, len(self.G)
        self.order = {A: self.morder(A) for A in self.G}

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

    def act(self, A, v):
        p = self.p
        return tuple(sum(A[i][j] * v[j] for j in range(5)) % p for i in range(5))

    def F(self, v):
        p = self.p
        return sum(v[i] * v[i] % p * v[(i + 1) % 5] for i in range(5)) % p

    # ---------- linear algebra over F_p ----------
    def rref(self, rows, n=5):
        p = self.p
        M = [list(r) for r in rows]
        m = len(M)
        piv, r = [], 0
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

    def nullspace(self, rows, n=5):
        R, piv = self.rref(rows, n)
        free = [c for c in range(n) if c not in piv]
        basis = []
        for f in free:
            v = [0] * n
            v[f] = 1
            for i, c in enumerate(piv):
                v[c] = (-R[i][f]) % self.p
            basis.append(tuple(v))
        return tuple(basis)

    def eigsp(self, A, lam):
        p = self.p
        rows = [[(A[i][j] - (lam if i == j else 0)) % p for j in range(5)] for i in range(5)]
        return self.nullspace(rows)

    def eigenbasis(self, A, n):
        """Return [(weight a, eigenvector)] for A of order n, weights mod n
        w.r.t. the FIXED primitive n-th root self.root(n).  Multiplicities are
        expanded: an a-eigenspace of dim k contributes k entries."""
        z = self.root(n)
        out = []
        for a in range(n):
            E = self.eigsp(A, pow(z, a, self.p))
            for v in E:
                out.append((a, v))
        assert len(out) == 5, (n, len(out))
        return out

    def onX(self, v):
        return self.F(v) % self.p == 0

    # ---------- element finders ----------
    def elt_of_order(self, n):
        for A in self.G:
            if self.order[A] == n:
                return A
        raise RuntimeError

    def centralizer(self, A):
        return [B for B in self.G if self.mm(A, B) == self.mm(B, A)]

    def normalizer_of_cyc(self, A):
        n = self.order[A]
        pw = {}
        B = self.Id
        for k in range(n):
            pw[B] = k
            B = self.mm(B, A)
        out = []
        for C in self.G:
            Ci = self.matinv(C)
            if self.mm(self.mm(C, A), Ci) in pw:
                out.append(C)
        return out

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

    def stab_point(self, v):
        """Projective stabiliser of [v]."""
        out = []
        for A in self.G:
            w = self.act(A, v)
            if self._proportional(v, w):
                out.append(A)
        return out

    def _proportional(self, v, w):
        p = self.p
        k = next((i for i in range(5) if w[i] % p), None)
        if k is None:
            return False
        if v[k] % p == 0:
            return False
        c = w[k] * self.inv(v[k]) % p
        return all((w[i] - c * v[i]) % p == 0 for i in range(5))


def _primes(n):
    out, d, m = set(), 2, n
    while d * d <= m:
        while m % d == 0:
            out.add(d)
            m //= d
        d += 1
    if m > 1:
        out.add(m)
    return out


def normpt(m, v):
    for x in v:
        if x % m.p:
            iv = m.inv(x)
            return tuple(y * iv % m.p for y in v)
    return None
