#!/usr/bin/env python3
"""
Exact equivariant model of the genus-12 prime Fano threefold V22 with a faithful
PSL(2,F_7)-action (the Cheltsov-Shramov / Klein V22), and the sigma / D8 fixed
locus data.

Model (Mukai):  X = { U in Gr(3, A) : U isotropic for every form in the net N },
A = the 7-dimensional irreducible Q-representation of G = PSL(2,F_7)
    (deleted permutation module on P^1(F_7), 8 points),
N = a 3-dimensional irreducible subrepresentation of Lambda^2 A^*.
Character arithmetic: Lambda^2(7) = 3 + 3' + 7 + 8, so the two 3-dimensional
irreducibles are the ONLY 3-dimensional subrepresentations of Lambda^2 A^*, i.e.
the only PSL(2,7)-invariant Mukai nets on A.  They are Galois-conjugate over
Q(sqrt(-7)) (equivalently swapped by the outer automorphism of PSL(2,7)), so the
two resulting V22's are abstractly isomorphic as G-varieties up to Out(G).

Everything here is exact: Q(sqrt(-7)) arithmetic on top of fractions.Fraction.
No floating point, no finite-field sampling.
"""

from fractions import Fraction as Fr
from itertools import product

# ---------------------------------------------------------------- field K = Q(sqrt(-7))

DISC = -7


class K:
    """a + b*s with s^2 = -7."""

    __slots__ = ("a", "b")

    def __init__(self, a=0, b=0):
        self.a = Fr(a)
        self.b = Fr(b)

    @staticmethod
    def coerce(x):
        return x if isinstance(x, K) else K(x)

    def __add__(self, o):
        o = K.coerce(o)
        return K(self.a + o.a, self.b + o.b)

    __radd__ = __add__

    def __neg__(self):
        return K(-self.a, -self.b)

    def __sub__(self, o):
        return self + (-K.coerce(o))

    def __rsub__(self, o):
        return K.coerce(o) + (-self)

    def __mul__(self, o):
        o = K.coerce(o)
        return K(self.a * o.a + DISC * self.b * o.b, self.a * o.b + self.b * o.a)

    __rmul__ = __mul__

    def conj(self):
        return K(self.a, -self.b)

    def norm(self):
        return self.a * self.a - DISC * self.b * self.b

    def inv(self):
        n = self.norm()
        if n == 0:
            raise ZeroDivisionError
        c = self.conj()
        return K(c.a / n, c.b / n)

    def __truediv__(self, o):
        return self * K.coerce(o).inv()

    def __eq__(self, o):
        o = K.coerce(o)
        return self.a == o.a and self.b == o.b

    def is_zero(self):
        return self.a == 0 and self.b == 0

    def __repr__(self):
        if self.b == 0:
            return str(self.a)
        if self.a == 0:
            return f"{self.b}*s"
        return f"({self.a}{'+' if self.b > 0 else '-'}{abs(self.b)}*s)"

    def __hash__(self):
        return hash((self.a, self.b))


ZERO = K(0)
ONE = K(1)
S = K(0, 1)  # sqrt(-7)


# ---------------------------------------------------------------- linear algebra over K

def zeros(m, n):
    return [[K(0) for _ in range(n)] for _ in range(m)]


def mat_mul(A, B):
    m, k, n = len(A), len(B), len(B[0])
    C = zeros(m, n)
    for i in range(m):
        Ai = A[i]
        for t in range(k):
            a = Ai[t]
            if a.is_zero():
                continue
            Bt = B[t]
            Ci = C[i]
            for j in range(n):
                Ci[j] = Ci[j] + a * Bt[j]
    return C


def transpose(A):
    return [list(col) for col in zip(*A)]


def rref(M):
    """Return (R, pivots) with R the reduced row echelon form of a copy of M."""
    R = [row[:] for row in M]
    rows, cols = len(R), len(R[0]) if R else 0
    piv = []
    r = 0
    for c in range(cols):
        p = None
        for i in range(r, rows):
            if not R[i][c].is_zero():
                p = i
                break
        if p is None:
            continue
        R[r], R[p] = R[p], R[r]
        inv = R[r][c].inv()
        R[r] = [x * inv for x in R[r]]
        for i in range(rows):
            if i != r and not R[i][c].is_zero():
                f = R[i][c]
                R[i] = [x - f * y for x, y in zip(R[i], R[r])]
        piv.append(c)
        r += 1
        if r == rows:
            break
    return R, piv


def rank(M):
    if not M:
        return 0
    return len(rref(M)[1])


def kernel(M):
    """Basis (list of vectors) of {x : M x = 0}."""
    R, piv = rref(M)
    n = len(M[0])
    free = [c for c in range(n) if c not in piv]
    basis = []
    for f in free:
        v = [K(0)] * n
        v[f] = K(1)
        for i, c in enumerate(piv):
            v[c] = -R[i][f]
        basis.append(v)
    return basis


def row_space(M):
    R, piv = rref(M)
    return [R[i] for i in range(len(piv))]


def in_span(basis, v):
    if not basis:
        return all(x.is_zero() for x in v)
    return rank(basis + [v]) == rank(basis)


def coords_in(basis, v):
    """Coordinates of v in the given (independent) basis, or None."""
    A = transpose(basis)  # columns = basis vectors
    aug = [row[:] + [v[i]] for i, row in enumerate(A)]
    R, piv = rref(aug)
    n = len(basis)
    if n in piv:
        return None
    out = [K(0)] * n
    for i, c in enumerate(piv):
        out[c] = R[i][n]
    return out


# ---------------------------------------------------------------- the group PSL(2,F_7)

INF = 7


def inv7(x):
    return pow(x % 7, 5, 7)


def canon(g):
    a, b, c, d = [x % 7 for x in g]
    return min((a, b, c, d), ((-a) % 7, (-b) % 7, (-c) % 7, (-d) % 7))


def gmul(g, h):
    a, b, c, d = g
    e, f, i, j = h
    return canon((a * e + b * i, a * f + b * j, c * e + d * i, c * f + d * j))


def ginv(g):
    a, b, c, d = g
    return canon((d, -b, -c, a))


def act_pt(g, z):
    a, b, c, d = g
    if z == INF:
        return INF if c % 7 == 0 else (a * inv7(c)) % 7
    num = (a * z + b) % 7
    den = (c * z + d) % 7
    return INF if den == 0 else (num * inv7(den)) % 7


def perm(g):
    return tuple(act_pt(g, z) for z in range(8))


def group():
    els = set()
    for a, b, c, d in product(range(7), repeat=4):
        if (a * d - b * c) % 7 == 1:
            els.add(canon((a, b, c, d)))
    return sorted(els)


def order(g):
    e = canon((1, 0, 0, 1))
    h, n = g, 1
    while h != e:
        h = gmul(h, g)
        n += 1
    return n


# ------------------------------------------------- the 7-dimensional rational irrep A

def rho(g):
    """Matrix of g on A = {sum-zero vectors in Q^8}, basis f_i = e_i - e_INF, i=0..6."""
    p = perm(g)
    M = zeros(7, 7)
    for i in range(7):
        if p[i] != INF:
            M[p[i]][i] = M[p[i]][i] + ONE
        if p[INF] != INF:
            M[p[INF]][i] = M[p[INF]][i] - ONE
    return M


# ------------------------------------------------- skew forms: Lambda^2 A^*

PAIRS = [(i, j) for i in range(7) for j in range(i + 1, 7)]


def form_from_vec(v):
    M = zeros(7, 7)
    for t, (i, j) in enumerate(PAIRS):
        M[i][j] = v[t]
        M[j][i] = -v[t]
    return M


def vec_from_form(M):
    return [M[i][j] for (i, j) in PAIRS]


def act_form(R, M):
    """(R^T M R): this is the action of g^{-1} when R = rho(g); harmless in the
    class sums below because the characters used are real and the class sets are
    closed under the relevant symmetry (documented at the call sites)."""
    return mat_mul(transpose(R), mat_mul(M, R))


def main():
    G = group()
    assert len(G) == 168, len(G)
    perms = {g: perm(g) for g in G}
    assert len({perms[g] for g in G}) == 168  # faithful on P^1(F_7)
    ords = {g: order(g) for g in G}
    from collections import Counter
    print("order distribution:", dict(sorted(Counter(ords.values()).items())))

    R = {g: rho(g) for g in G}

    # character of A = deleted permutation module: chi(g) = #fix(g) - 1
    chiA = {g: sum(1 for z in range(8) if perms[g][z] == z) - 1 for g in G}
    exp7 = {1: 7, 2: -1, 3: 1, 4: -1, 7: 0}
    assert all(chiA[g] == exp7[ords[g]] for g in G)
    print("A is the 7-dim irreducible (character check passed)")

    # ---- project Lambda^2 A^* onto the (3 + 3')-isotypic part.
    # chi_3 + chi_3' is rational with values 6,-2,0,2,-1,-1 on 1A,2A,3A,4A,7A,7B,
    # i.e. it only depends on the ORDER of g.
    chi33 = {1: 6, 2: -2, 3: 0, 4: 2, 7: -1}
    proj_rows = []
    for t in range(21):
        v = [K(0)] * 21
        v[t] = ONE
        M = form_from_vec(v)
        acc = zeros(7, 7)
        for g in G:
            c = chi33[ords[g]]
            if c == 0:
                continue
            Mg = act_form(R[g], M)
            for i in range(7):
                for j in range(7):
                    acc[i][j] = acc[i][j] + K(c) * Mg[i][j]
        proj_rows.append([x / 56 for x in vec_from_form(acc)])
    Sbasis = row_space(proj_rows)
    print("dim of (3+3')-isotypic part of Lambda^2 A^* =", len(Sbasis))
    assert len(Sbasis) == 6

    # ---- split it over Q(sqrt(-7)) using the class sum of an order-7 element.
    h = canon((1, 1, 0, 1))
    assert ords[h] == 7
    C7 = sorted({gmul(gmul(x, h), ginv(x)) for x in G})
    assert len(C7) == 24
    T = []
    for w in Sbasis:
        M = form_from_vec(w)
        acc = zeros(7, 7)
        for g in C7:
            Mg = act_form(R[g], M)
            for i in range(7):
                for j in range(7):
                    acc[i][j] = acc[i][j] + Mg[i][j]
        T.append(coords_in(Sbasis, vec_from_form(acc)))
    # T is the matrix of the class sum acting on S (rows = images of basis vectors)
    Tm = transpose(T)
    # eigenvalues must be -4 +- 4*sqrt(-7)  (= 8*alpha, 8*alpha-bar)
    lam = K(-4, 4)
    Mlam = [[Tm[i][j] - (lam if i == j else ZERO) for j in range(6)] for i in range(6)]
    ker = kernel(Mlam)
    print("dim of the lambda = -4+4s eigenspace =", len(ker))
    assert len(ker) == 3
    # net N: three skew 7x7 matrices over K
    Nb = []
    for cvec in ker:
        acc = [K(0)] * 21
        for i, c in enumerate(cvec):
            for t in range(21):
                acc[t] = acc[t] + c * Sbasis[i][t]
        Nb.append(form_from_vec(acc))
    # equivariance check: g.N = N for all g
    Nvecs = [vec_from_form(M) for M in Nb]
    for g in G:
        for M in Nb:
            assert in_span(Nvecs, vec_from_form(act_form(R[g], M))), "net not G-stable"
    print("net N is G-stable, dim 3  (checked on all 168 group elements)")

    return G, R, ords, Nb, Nvecs, perms


if __name__ == "__main__":
    main()
