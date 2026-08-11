"""Shared core for the STANDARD_FORM_PW packet.

Builds on `psl211.py` (the packet-local copy of the DUNCAN_CORNER_F2 model of
`G = PSL(2,11)` acting on `W = C^5`, reduced at a split prime).  Adds:

  * a fast index/multiplication-table layer over the 660 matrices;
  * enumeration of every subgroup up to conjugacy (cyclic-extension method);
  * linear characters of a subgroup and the corresponding joint eigenspaces
    (= the fixed points / fixed linear subspaces of that subgroup on P(W));
  * pointwise and setwise stabilizers of a linear subspace;
  * tangent modules `T_[v]P(W) = Hom(<v>, W/<v>)` as H-modules, returned as an
    exact multiset of characters when H is abelian.

Everything is exact arithmetic in F_p for a prime p with 5 | p-1 and 11 | p-1,
so that every element order in {1,2,3,5,6,11} splits and every representation
of every subgroup of G is realised with the same character theory as over C
(Brauer: p = 331, 661 are coprime to |G| = 660?  -- 331 and 661 are both
coprime to 660, so reduction mod p is a bijection on irreducible characters
and on the lattice of subrepresentations).
"""
from collections import defaultdict
import itertools
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from psl211 import Model, SPLIT_PRIMES          # noqa: E402


class Core:
    def __init__(self, p):
        assert 660 % p != 0
        self.m = Model(p)
        self.p = p
        m = self.m
        self.G = m.G
        self.idx = {A: i for i, A in enumerate(m.G)}
        n = len(m.G)
        self.n = n
        # multiplication / inverse tables on indices
        self.mul = [[0] * n for _ in range(n)]
        for i, A in enumerate(m.G):
            row = self.mul[i]
            for j, B in enumerate(m.G):
                row[j] = self.idx[m.mm(A, B)]
        self.inv = [0] * n
        for i in range(n):
            for j in range(n):
                if self.mul[i][j] == 0 if False else self.mul[i][j] == self.idx[m.Id]:
                    self.inv[i] = j
                    break
        self.e = self.idx[m.Id]
        self.ordr = [m.morder(A) for A in m.G]

    # ---------------- group layer (index based) ----------------
    def gen(self, elts):
        S = {self.e}
        fr = [self.e]
        while fr:
            nf = []
            for a in fr:
                for g in elts:
                    b = self.mul[a][g]
                    if b not in S:
                        S.add(b)
                        nf.append(b)
            fr = nf
        return frozenset(S)

    def conj(self, H, g):
        gi = self.inv[g]
        return frozenset(self.mul[self.mul[g][x]][gi] for x in H)

    def is_abelian(self, H):
        return all(self.mul[x][y] == self.mul[y][x] for x in H for y in H)

    def subgroup_classes(self):
        """Every subgroup of G up to conjugacy (cyclic extension)."""
        reps = []
        seen = set()
        frontier = [frozenset([self.e])]
        seen.add(frozenset([self.e]))
        reps.append(frozenset([self.e]))
        while frontier:
            nxt = []
            for H in frontier:
                for g in range(self.n):
                    if g in H:
                        continue
                    K = self.gen(list(H) + [g])
                    if K in seen:
                        continue
                    orb = set(self.conj(K, x) for x in range(self.n))
                    if orb & seen:
                        seen |= orb
                        continue
                    seen |= orb
                    reps.append(K)
                    nxt.append(K)
            frontier = nxt
        return sorted(reps, key=lambda H: (len(H), sorted(H)))

    def name(self, H):
        k = len(H)
        if k == 1:
            return "1"
        ords = sorted(self.ordr[x] for x in H)
        ab = self.is_abelian(H)
        if ab:
            return f"C{k}" if max(ords) == k else ("V4" if k == 4 else f"Ab{k}")
        return {6: "S3", 8: "D8", 10: "D10", 55: "11:5", 60: "A5", 660: "PSL(2,11)"}.get(
            k, ("A4" if (k == 12 and 6 not in ords) else "D12" if k == 12 else f"NA{k}"))

    def generators(self, H):
        """A short generating list for H (greedy, at most 2 for our subgroups)."""
        elts = sorted(H, key=lambda x: -self.ordr[x])
        gens = []
        cur = frozenset([self.e])
        for g in elts:
            if g in cur:
                continue
            gens.append(g)
            cur = self.gen(gens)
            if cur == H:
                break
        return gens

    # ---------------- linear algebra on W ----------------
    def roots(self, n):
        """All n-th roots of unity in F_p."""
        p = self.p
        assert (p - 1) % n == 0
        g = self.m._root(n)
        return [pow(g, i, p) for i in range(n)]

    def joint_eigenspace(self, gens, lams):
        """{v : g_i v = lam_i v for all i}."""
        p = self.p
        rows = []
        for g, lam in zip(gens, lams):
            A = self.G[g]
            rows += [[(A[i][j] - (lam if i == j else 0)) % p for j in range(5)]
                     for i in range(5)]
        ns = self.m.nullspace(rows)
        return self.m.canon(ns) if ns else ()

    def linear_characters(self, H):
        """All linear characters of H, as dicts elt-index -> scalar in F_p,
        found by scanning admissible values on a generating set."""
        gens = self.generators(H)
        out = []
        choices = [self.roots(self.ordr[g]) for g in gens]
        for lams in itertools.product(*choices):
            # extend to a function on H by words; check well defined
            val = {self.e: 1}
            fr = [self.e]
            ok = True
            while fr and ok:
                nf = []
                for a in fr:
                    for g, lam in zip(gens, lams):
                        b = self.mul[a][g]
                        v = val[a] * lam % self.p
                        if b in val:
                            if val[b] != v:
                                ok = False
                                break
                        else:
                            val[b] = v
                            nf.append(b)
                    if not ok:
                        break
                fr = nf
            if ok and len(val) == len(H):
                out.append((tuple(lams), val))
        return gens, out

    def char_subspaces(self, H):
        """[(character-as-dict, basis)] for each linear character of H whose
        joint eigenspace on W is nonzero.  These are exactly the H-fixed linear
        subspaces of P(W)."""
        gens, chars = self.linear_characters(H)
        out = []
        for lams, val in chars:
            U = self.joint_eigenspace(gens, lams)
            if U:
                out.append((val, U))
        return out

    def pstab(self, U):
        """{g : g acts on U by a scalar} -- the pointwise stabilizer of P(U)."""
        m = self.m
        out = []
        for i, A in enumerate(self.G):
            im = [m.act(A, v) for v in U]
            # scalar iff im[k] = c * U[k] for a common c
            c = None
            good = True
            for v, w in zip(U, im):
                j = next((t for t in range(5) if v[t] % self.p), None)
                if w[j] % self.p == 0:
                    good = False
                    break
                cc = w[j] * m.inv(v[j]) % self.p
                if c is None:
                    c = cc
                elif cc != c:
                    good = False
                    break
                if any((w[t] - c * v[t]) % self.p for t in range(5)):
                    good = False
                    break
            if good:
                out.append(i)
        return frozenset(out)

    def sstab(self, U):
        m = self.m
        cu = m.canon(U)
        return frozenset(i for i, A in enumerate(self.G)
                         if m.canon([list(m.act(A, v)) for v in U]) == cu)

    # ---------------- character bookkeeping for abelian H ----------------
    def abelian_chartable(self, H):
        """For abelian H return (gens, [char dicts]) with characters listed in a
        fixed order; character multiplication is pointwise."""
        gens, chars = self.linear_characters(H)
        assert len(chars) == len(H), (len(chars), len(H))
        return gens, [val for _, val in chars]

    def weight_of(self, H, vec_action):
        """Given a dict elt->scalar realised on a 1-dim H-module, return it."""
        return vec_action

    def tangent_weights(self, H, U):
        """H abelian, U a 1-dim H-stable subspace (a point y=[v] of P(W)).
        Return the multiset of H-characters (as dicts) of T_y P(W)."""
        m = self.m
        assert len(U) == 1
        v = U[0]
        # lambda = character of the line
        lam = {}
        for i in range(self.n):
            if i in H:
                w = m.act(self.G[i], v)
                j = next(t for t in range(5) if v[t] % self.p)
                lam[i] = w[j] * m.inv(v[j]) % self.p
        # decompose W into H-characters, subtract one copy of lam
        gens, chars = self.abelian_chartable(H)
        wts = []
        for val in chars:
            U2 = self.joint_eigenspace(gens, [val[g] for g in gens])
            d = len(U2)
            for _ in range(d):
                wts.append(val)
        # remove one copy of lam, twist the rest by lam^{-1}
        rem = None
        for k, val in enumerate(wts):
            if all(val[i] == lam[i] for i in H):
                rem = k
                break
        assert rem is not None
        wts.pop(rem)
        out = []
        for val in wts:
            out.append({i: val[i] * m.inv(lam[i]) % self.p for i in H})
        return out

    def normal_weights(self, H, U):
        """H abelian, U an H-stable subspace of dim d >= 1 with H acting on U by
        a single character lam (so P(U) is pointwise H-fixed).  Return the
        multiset of H-characters of the normal bundle fibre
        N = Hom(O(-1), W/U) = lam^{-1} (x) (W/U) at a point of P(U)."""
        m = self.m
        v = U[0]
        lam = {}
        for i in H:
            w = m.act(self.G[i], v)
            j = next(t for t in range(5) if v[t] % self.p)
            lam[i] = w[j] * m.inv(v[j]) % self.p
        gens, chars = self.abelian_chartable(H)
        wts = []
        for val in chars:
            U2 = self.joint_eigenspace(gens, [val[g] for g in gens])
            d = len(U2)
            if all(val[i] == lam[i] for i in H):
                d -= len(U)          # the whole of U sits in this character
            for _ in range(d):
                wts.append(val)
        return [{i: val[i] * m.inv(lam[i]) % self.p for i in H} for val in wts]


def chkey(H, val):
    """Hashable key of a character of H."""
    return tuple(val[i] for i in sorted(H))


def chmul(H, a, b, p):
    return {i: a[i] * b[i] % p for i in H}


def chdiv(H, a, b, p, inv):
    return {i: a[i] * inv(b[i]) % p for i in H}


def is_trivial(H, val):
    return all(val[i] == 1 for i in H)


# --------------------------------------------------------------------------
# generic linear algebra over F_p in arbitrary width (psl211.Model hardcodes 5)
# --------------------------------------------------------------------------
def rref(rows, n, p):
    M = [[x % p for x in r] for r in rows]
    piv, r = [], 0
    for c in range(n):
        pr = next((i for i in range(r, len(M)) if M[i][c] % p), None)
        if pr is None:
            continue
        M[r], M[pr] = M[pr], M[r]
        iv = pow(M[r][c], p - 2, p)
        M[r] = [x * iv % p for x in M[r]]
        for i in range(len(M)):
            if i != r and M[i][c] % p:
                f = M[i][c]
                M[i] = [(x - f * y) % p for x, y in zip(M[i], M[r])]
        piv.append(c)
        r += 1
    return tuple(tuple(row) for row in M[:r]), tuple(piv)


def nullspace(rows, n, p):
    R, piv = rref(rows, n, p)
    free = [c for c in range(n) if c not in piv]
    out = []
    for f in free:
        v = [0] * n
        v[f] = 1
        for i, c in enumerate(piv):
            v[c] = (-R[i][f]) % p
        out.append(v)
    return rref(out, n, p)[0] if out else ()


class Rep:
    """A representation of a finite group on F_p^n, given as {elt-key: matrix}."""

    def __init__(self, mats, n, p, mul=None, keys=None):
        self.mats = mats            # dict key -> n x n tuple-of-tuples
        self.n = n
        self.p = p
        self.keys = list(keys if keys is not None else mats.keys())

    def act(self, k, v):
        M = self.mats[k]
        return tuple(sum(M[i][j] * v[j] for j in range(self.n)) % self.p
                     for i in range(self.n))

    def fixed_space(self, keys, lams):
        """{v : g v = lam v for the listed (g, lam)}."""
        rows = []
        for k, lam in zip(keys, lams):
            M = self.mats[k]
            rows += [[(M[i][j] - (lam if i == j else 0)) % self.p for j in range(self.n)]
                     for i in range(self.n)]
        return nullspace(rows, self.n, self.p)

    def sub_rep(self, basis):
        """The representation induced on the span of `basis` (assumed invariant)."""
        B, _ = rref([list(b) for b in basis], self.n, self.p)
        d = len(B)
        piv = rref([list(b) for b in B], self.n, self.p)[1]
        mats = {}
        for k in self.keys:
            cols = []
            for b in B:
                w = self.act(k, b)
                cols.append([w[c] for c in piv])
            mats[k] = tuple(tuple(cols[c][r] for c in range(d)) for r in range(d))
        return Rep(mats, d, self.p, keys=self.keys)

    def quot_rep(self, basis):
        """The representation on F_p^n / span(basis)."""
        B, piv = rref([list(b) for b in basis], self.n, self.p)
        free = [c for c in range(self.n) if c not in piv]
        d = len(free)

        def reduce(w):
            w = list(w)
            for i, c in enumerate(piv):
                f = w[c]
                if f:
                    w = [(x - f * y) % self.p for x, y in zip(w, B[i])]
            return [w[c] for c in free]

        mats = {}
        for k in self.keys:
            cols = []
            for c in free:
                e = [int(t == c) for t in range(self.n)]
                cols.append(reduce(self.act(k, e)))
            mats[k] = tuple(tuple(cols[c][r] for c in range(d)) for r in range(d))
        return Rep(mats, d, self.p, keys=self.keys)

    def twist(self, chi):
        """Twist by the character chi (dict key -> scalar)."""
        mats = {k: tuple(tuple(x * pow(chi[k], self.p - 2, self.p) % self.p for x in row)
                         for row in M) for k, M in self.mats.items()}
        return Rep(mats, self.n, self.p, keys=self.keys)
