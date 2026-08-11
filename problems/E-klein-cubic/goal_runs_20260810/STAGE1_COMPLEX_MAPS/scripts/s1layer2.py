"""STAGE1_COMPLEX_MAPS -- Layer 2: the per-cell moduli of the sweeping rows.

By Layer 1 the only positive-dimensional images are X (from the free stratum)
and the 55 lines L_sigma.  So the whole of Layer 2 reduces to: for each row that
sweeps, classify the Stab_G(F)-equivariant dominant maps

        F = P(A_0) x ... x P(A_k)  -->  L_sigma = P(W^-_sigma) = P^1 ,

stratum by stratum.  A map of multidegree a = (a_0,...,a_k) is a nonzero element
of the Gamma-eigenspace, for some linear character psi of Gamma = Stab_G(F), of

        S(a) = Sym^{a_0}(A_0^*) (x) ... (x) Sym^{a_k}(A_k^*) (x) W^-_sigma ,

modulo scalars; the map is dominant iff the two coordinate forms have no common
factor.  This module computes  dim S(a)^{Gamma, psi}  exactly over F_p (p does
not divide |Gamma|, so these dimensions are the characteristic-zero ones).
"""
import itertools
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


def monomials(n, d):
    if n == 1:
        yield (d,)
        return
    for i in range(d + 1):
        for rest in monomials(n - 1, d - i):
            yield (i,) + rest


class SymAction:
    """the Gamma-action on Sym^d(U^*) for U a Gamma-stable subquotient."""

    def __init__(self, m, mats, d):
        self.m = m
        self.p = m.p
        self.n = len(mats[next(iter(mats))]) if mats else 0
        self.d = d
        self.mons = list(monomials(self.n, d))
        self.idx = {e: i for i, e in enumerate(self.mons)}

    def matrix(self, M):
        """M = matrix of gamma on U (columns = images of the basis).
        Returns the matrix of gamma on Sym^d(U^*) in the monomial basis."""
        p, n, d = self.p, self.n, self.d
        out = [[0] * len(self.mons) for _ in self.mons]
        # x_j  |->  sum_i M[i][j] x_i  acting on the DUAL basis:
        # (gamma . f)(u) = f(gamma^{-1} u); use the transpose-inverse convention
        # by simply feeding in the matrix of gamma on U^*.
        for c, e in enumerate(self.mons):
            poly = {tuple([0] * n): 1}
            for j in range(n):
                for _ in range(e[j]):
                    new = {}
                    for mon, co in poly.items():
                        for i in range(n):
                            if M[i][j] % p == 0:
                                continue
                            k = list(mon)
                            k[i] += 1
                            k = tuple(k)
                            new[k] = (new.get(k, 0) + co * M[i][j]) % p
                    poly = new
            for mon, co in poly.items():
                out[self.idx[mon]][c] = co % p
        return out


def slot_matrices(S, g, lo, A):
    """matrix of g on the quotient A/lo, in a fixed basis."""
    m = S.m
    basis = [list(v) for v in lo]
    comp = []
    for v in A:
        if m.rank(basis + [list(v)]) > len(basis):
            basis.append(list(v))
            comp.append(list(v))
    dl = len(lo)
    cols = []
    for v in comp:
        w = list(m.act(g, tuple(v)))
        coef = solve(S, basis, w)[dl:]
        cols.append(coef)
    n = len(comp)
    return [[cols[j][i] for j in range(n)] for i in range(n)]   # M[i][j]


def solve(S, basis, w):
    p = S.p
    n = len(basis)
    Aug = [[basis[i][c] for i in range(n)] + [w[c]] for c in range(5)]
    r, piv = 0, []
    for c in range(n):
        pr = None
        for i in range(r, 5):
            if Aug[i][c] % p:
                pr = i
                break
        if pr is None:
            continue
        Aug[r], Aug[pr] = Aug[pr], Aug[r]
        iv = S.m.inv(Aug[r][c])
        Aug[r] = [x * iv % p for x in Aug[r]]
        for i in range(5):
            if i != r and Aug[i][c] % p:
                f = Aug[i][c]
                Aug[i] = [(x - f * y) % p for x, y in zip(Aug[i], Aug[r])]
        piv.append(c)
        r += 1
    x = [0] * n
    for i, c in enumerate(piv):
        x[c] = Aug[i][n] % p
    return x


def kron(A, B, p):
    ra, ca, rb, cb = len(A), len(A[0]), len(B), len(B[0])
    return [[A[i // rb][j // cb] * B[i % rb][j % cb] % p
             for j in range(ca * cb)] for i in range(ra * rb)]


def invariant_dim(p, mats, chars):
    """dim of the subspace where every gamma acts by the scalar chars[gamma]."""
    n = len(next(iter(mats.values())))
    rows = []
    for g, M in mats.items():
        lam = chars[g]
        for i in range(n):
            rows.append([(M[i][j] - (lam if i == j else 0)) % p for j in range(n)])
    # rank of the stacked matrix
    r = 0
    piv = []
    R = [list(x) for x in rows]
    for c in range(n):
        pr = None
        for i in range(r, len(R)):
            if R[i][c] % p:
                pr = i
                break
        if pr is None:
            continue
        R[r], R[pr] = R[pr], R[r]
        iv = pow(R[r][c], p - 2, p)
        R[r] = [x * iv % p for x in R[r]]
        for i in range(len(R)):
            if i != r and R[i][c] % p:
                f = R[i][c]
                R[i] = [(x - f * y) % p for x, y in zip(R[i], R[r])]
        piv.append(c)
        r += 1
        if r == n:
            break
    return n - r


def sweep_moduli(E, rid, maxdeg=6):
    """dim of the space of equivariant maps F --> L_sigma, per multidegree."""
    S, T, m = E.S, E.T, E.m
    p = E.p
    r = [q for q in E.rows if q["id"] == rid][0]
    C, L, H = S.comps[r["rep"]]
    Gam = sorted(r["S"])
    sig = [x for x in H if x != m.Id][0]
    Wm = T.minus[sig]
    Us = [()] + list(C)
    slots = [(Us[i], L[i]) for i in range(len(L)) if len(L[i]) - len(Us[i]) >= 2]
    dims = [len(A) - len(lo) for lo, A in slots]
    # matrices on each slot and on W^-
    slotmats = [{g: slot_matrices(S, g, lo, A) for g in Gam} for lo, A in slots]
    wmats = {g: slot_matrices(S, g, (), Wm) for g in Gam}
    # linear characters of Gamma (order <= 12, abelian or D12)
    lin = linear_characters(m, Gam, p)
    out = {}
    for degs in itertools.product(range(maxdeg + 1), repeat=len(slots)):
        if sum(degs) == 0:
            continue
        mats = {}
        for g in Gam:
            M = [[1]]
            for si, d in enumerate(degs):
                sa = SymAction(m, slotmats[si], d)
                M = kron(M, sa.matrix(slotmats[si][g]), p)
            M = kron(M, wmats[g], p)
            mats[g] = M
        best = {}
        for name, ch in lin:
            d = invariant_dim(p, mats, ch)
            if d:
                best[name] = d
        if best:
            out[degs] = best
    return out, [len(A) - len(lo) for lo, A in slots], len(Gam)


def linear_characters(m, Gam, p):
    """all homomorphisms Gamma -> F_p^* (the group is C2, V4, C6 or D12 here)."""
    Gs = list(Gam)
    # commutator subgroup
    com = set([m.Id])
    changed = True
    while changed:
        changed = False
        for a in Gs:
            for b in Gs:
                c = m.mm(m.mm(a, b), m.mm(m.matinv(a), m.matinv(b)))
                if c not in com:
                    com.add(c)
                    changed = True
        # close under multiplication
        cur = list(com)
        for a in cur:
            for b in cur:
                if m.mm(a, b) not in com:
                    com.add(m.mm(a, b))
                    changed = True
    # abelianization as a set of cosets
    cosets = []
    seen = set()
    for g in Gs:
        c = frozenset(m.mm(g, x) for x in com)
        if c not in seen:
            seen.add(c)
            cosets.append(c)
    n = len(cosets)
    # the abelianization is cyclic (C1, C2, C6) or C2xC2 for V4
    # brute force: all maps cosets -> mu_n(F_p) that are homomorphisms
    roots = [x for x in range(1, p) if pow(x, n, p) == 1]
    out = []
    for assign in itertools.product(roots, repeat=len(cosets)):
        ch = {}
        ok = True
        for i, c in enumerate(cosets):
            for g in c:
                ch[g] = assign[i]
        for a in Gs:
            for b in Gs:
                if ch[m.mm(a, b)] != ch[a] * ch[b] % p:
                    ok = False
                    break
            if not ok:
                break
        if ok:
            out.append((tuple(assign), ch))
    return out
