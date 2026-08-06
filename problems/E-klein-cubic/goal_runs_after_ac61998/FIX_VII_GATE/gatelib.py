"""FIX-VII-GATE core library: mod-p linear algebra, monomials, group, checks.

Linear-algebra and Sym^d primitives follow FIX-VII-XRING's `lib_xring.py`
(same conventions, so the covariant spaces computed here are the same objects);
everything about degree-34 spanning / evaluation is new.
"""
import itertools
import os

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
CHECKLOG = os.path.join(HERE, "results", "checks.log")


# ---------------------------------------------------------------- modular LA

def rref(A, p):
    A = (A % p).astype(np.int64).copy()
    m, n = A.shape
    pivots = []
    r = 0
    for c in range(n):
        if r >= m:
            break
        nz = np.nonzero(A[r:, c])[0]
        if nz.size == 0:
            continue
        i = r + int(nz[0])
        if i != r:
            A[[r, i]] = A[[i, r]]
        inv = pow(int(A[r, c]), p - 2, p)
        A[r] = (A[r] * inv) % p
        col = A[:, c].copy()
        col[r] = 0
        nzr = np.nonzero(col)[0]
        if nzr.size:
            A[nzr] = (A[nzr] - np.outer(col[nzr], A[r])) % p
        pivots.append(c)
        r += 1
    return A, pivots


def rank_mod(A, p):
    if A.size == 0:
        return 0
    return len(rref(A, p)[1])


def rank_fast(M, p):
    """Row-echelon rank (forward elimination only)."""
    A = np.array(M, dtype=np.int64) % p
    rows, cols = A.shape
    r = 0
    for c in range(cols):
        if r >= rows:
            break
        nz = np.nonzero(A[r:, c])[0]
        if nz.size == 0:
            continue
        piv = r + int(nz[0])
        if piv != r:
            A[[r, piv]] = A[[piv, r]]
        A[r] = (A[r] * pow(int(A[r, c]), p - 2, p)) % p
        below = A[r + 1:, c]
        k = np.nonzero(below)[0]
        if k.size:
            A[r + 1 + k] = (A[r + 1 + k] - np.outer(below[k], A[r])) % p
        r += 1
    return r


def nullspace(A, p):
    m, n = A.shape
    if m == 0:
        return np.eye(n, dtype=np.int64)
    R, piv = rref(A, p)
    free = [c for c in range(n) if c not in set(piv)]
    B = np.zeros((n, len(free)), dtype=np.int64)
    for j, f in enumerate(free):
        B[f, j] = 1
        for i, c in enumerate(piv):
            B[c, j] = (-R[i, f]) % p
    return B


def matinv(M, p):
    n = M.shape[0]
    A = np.concatenate([M % p, np.eye(n, dtype=np.int64)], axis=1)
    R, piv = rref(A, p)
    assert piv == list(range(n)), "singular matrix"
    return R[:, n:] % p


def mmul(A, B, p):
    return (A.astype(np.int64) @ B.astype(np.int64)) % p


def matmul_mod(A, B, p):
    """int64-safe modular matmul via float64 BLAS when it is exact."""
    A = np.asarray(A, dtype=np.int64) % p
    B = np.asarray(B, dtype=np.int64) % p
    K = A.shape[-1]
    if (p - 1) ** 2 * K < (1 << 52):
        return (A.astype(np.float64) @ B.astype(np.float64)).astype(np.int64) % p
    return (A @ B) % p


def det_mod(M, p):
    A = (M % p).astype(np.int64).copy()
    n = A.shape[0]
    det = 1
    r = 0
    for c in range(n):
        nz = np.nonzero(A[r:, c])[0]
        if nz.size == 0:
            return 0
        i = r + int(nz[0])
        if i != r:
            A[[r, i]] = A[[i, r]]
            det = (-det) % p
        det = (det * int(A[r, c])) % p
        inv = pow(int(A[r, c]), p - 2, p)
        A[r] = (A[r] * inv) % p
        for j in range(r + 1, n):
            if A[j, c]:
                A[j] = (A[j] - A[j, c] * A[r]) % p
        r += 1
        if r == n:
            break
    return det % p


def sqrt_mod(a, p):
    a %= p
    if a == 0:
        return 0
    if pow(a, (p - 1) // 2, p) != 1:
        return None
    if p % 4 == 3:
        return pow(a, (p + 1) // 4, p)
    q, s = p - 1, 0
    while q % 2 == 0:
        q //= 2
        s += 1
    z = 2
    while pow(z, (p - 1) // 2, p) != p - 1:
        z += 1
    m, c, t, r = s, pow(z, q, p), pow(a, q, p), pow(a, (q + 1) // 2, p)
    while t != 1:
        i, t2 = 0, t
        while t2 != 1:
            t2 = t2 * t2 % p
            i += 1
        b = pow(c, 1 << (m - i - 1), p)
        m, c = i, b * b % p
        t = t * c % p
        r = r * b % p
    return r


def prime_factors(n):
    fs, d = set(), 2
    while d * d <= n:
        while n % d == 0:
            fs.add(d)
            n //= d
        d += 1
    if n > 1:
        fs.add(n)
    return fs


def nth_root_unity(n, p):
    assert (p - 1) % n == 0
    g = 2
    while True:
        if pow(g, (p - 1) // 2, p) == p - 1 and all(
                pow(g, (p - 1) // q, p) != 1 for q in prime_factors(p - 1)):
            break
        g += 1
    return pow(g, (p - 1) // n, p)


class RowBasis:
    """Incremental row basis over F_p; remembers which rows were kept."""

    def __init__(self, ncols, p):
        self.p = p
        self.ncols = ncols
        self.rows = np.zeros((0, ncols), dtype=np.int64)
        self.piv = []
        self.keep = []

    def add_block(self, M, tags):
        p = self.p
        B = np.array(M, dtype=np.int64) % p
        if self.rows.shape[0]:
            B = (B - matmul_mod(B[:, self.piv], self.rows, p)) % p
        for i in range(B.shape[0]):
            v = B[i]
            nz = np.nonzero(v)[0]
            if nz.size == 0:
                continue
            c = int(nz[0])
            v = (v * pow(int(v[c]), p - 2, p)) % p
            if self.rows.shape[0]:
                col = self.rows[:, c].copy()
                k = np.nonzero(col)[0]
                if k.size:
                    self.rows[k] = (self.rows[k] - np.outer(col[k], v)) % p
            self.rows = np.concatenate([self.rows, v[None, :]], axis=0)
            self.piv.append(c)
            self.keep.append(tags[i])
            if i + 1 < B.shape[0]:
                col = B[i + 1:, c].copy()
                k = np.nonzero(col)[0]
                if k.size:
                    B[i + 1 + k] = (B[i + 1 + k] - np.outer(col[k], v)) % p
        return len(self.keep)

    @property
    def rank(self):
        return len(self.keep)


# ---------------------------------------------------------- monomials / Sym^d

_MONCACHE = {}


def monomials(d, nv=5):
    key = (d, nv)
    if key in _MONCACHE:
        return _MONCACHE[key]
    out = []

    def rec(pos, rem, cur):
        if pos == nv - 1:
            out.append(tuple(cur + [rem]))
            return
        for e in range(rem, -1, -1):
            rec(pos + 1, rem - e, cur + [e])

    rec(0, d, [])
    idx = {m: i for i, m in enumerate(out)}
    _MONCACHE[key] = (out, idx)
    return out, idx


def nmon(d, nv=5):
    from math import comb
    return comb(d + nv - 1, nv - 1)


_SHIFTCACHE = {}


def shift_table(a, b, nv=5):
    """shift[k][j] = index in degree a+b of (mon_b[j] + e_k)?  No -- see below.

    Returns for each degree-a monomial index i an array `T[i]` of length N_b
    with T[i][j] = index of mon_a[i]+mon_b[j] in degree a+b.  Built lazily per
    single degree-a monomial to keep memory bounded (see `shift_row`).
    """
    raise NotImplementedError


_ROWCACHE = {}


def shift_row(alpha, b, nv=5):
    """Array T of length N_b with T[j] = index of alpha + mon_b[j] in degree
    |alpha| + b."""
    key = (alpha, b, nv)
    r = _ROWCACHE.get(key)
    if r is not None:
        return r
    a = sum(alpha)
    monb, _ = monomials(b, nv)
    _, idxc = monomials(a + b, nv)
    T = np.empty(len(monb), dtype=np.int64)
    for j, mb in enumerate(monb):
        T[j] = idxc[tuple(x + y for x, y in zip(alpha, mb))]
    if len(_ROWCACHE) > 4000:
        _ROWCACHE.clear()
    _ROWCACHE[key] = T
    return T


def sym_power_matrix(g, d, p, nv=5):
    """S_d(g)[a,b]:  m_a(g v) = sum_b S_d(g)[a,b] m_b(v)."""
    g = np.asarray(g, dtype=np.int64) % p
    mons, idx = monomials(d, nv)
    if d == 0:
        return np.ones((1, 1), dtype=np.int64)
    prev, previdx = monomials(d - 1, nv)
    Sprev = sym_power_matrix(g, d - 1, p, nv)
    shift = np.zeros((nv, len(prev)), dtype=np.int64)
    for k in range(nv):
        for j, b in enumerate(prev):
            bb = list(b)
            bb[k] += 1
            shift[k, j] = idx[tuple(bb)]
    out = np.zeros((len(mons), len(mons)), dtype=np.int64)
    for i in range(nv):
        rows, srcs = [], []
        for a_i, a in enumerate(mons):
            if a[i] > 0 and all(a[t] == 0 for t in range(i)):
                aa = list(a)
                aa[i] -= 1
                rows.append(a_i)
                srcs.append(previdx[tuple(aa)])
        if not rows:
            continue
        rows = np.array(rows)
        srcs = np.array(srcs)
        blk = Sprev[srcs]
        acc = np.zeros((len(rows), len(mons)), dtype=np.int64)
        for k in range(nv):
            c = int(g[i, k])
            if c == 0:
                continue
            acc[:, shift[k]] = (acc[:, shift[k]] + c * blk) % p
        out[rows] = acc % p
    return out


# ------------------------------------------------------- polynomials as dicts

def poly_mul(a, b, p):
    out = {}
    for ma, ca in a.items():
        for mb, cb in b.items():
            m = tuple(x + y for x, y in zip(ma, mb))
            out[m] = (out.get(m, 0) + ca * cb) % p
    return {m: c for m, c in out.items() if c}


def poly_add(a, b, p):
    out = dict(a)
    for m, c in b.items():
        out[m] = (out.get(m, 0) + c) % p
    return {m: c for m, c in out.items() if c}


def poly_scale(a, s, p):
    s %= p
    if s == 0:
        return {}
    return {m: (c * s) % p for m, c in a.items()}


def poly_diff(a, i, p):
    out = {}
    for m, c in a.items():
        if m[i] > 0:
            mm = list(m)
            e = mm[i]
            mm[i] -= 1
            cc = (c * e) % p
            if cc:
                out[tuple(mm)] = (out.get(tuple(mm), 0) + cc) % p
    return {m: c for m, c in out.items() if c}


def poly_to_vec(a, d, p, nv=5):
    mons, idx = monomials(d, nv)
    v = np.zeros(len(mons), dtype=np.int64)
    for m, c in a.items():
        assert sum(m) == d, (m, d)
        v[idx[m]] = c % p
    return v


def vec_to_poly(v, d, p, nv=5):
    mons, _ = monomials(d, nv)
    return {mons[i]: int(v[i]) % p for i in range(len(mons)) if int(v[i]) % p}


def poly_m2(vec, d, p, nv=5):
    """coefficient vector over the degree-d monomial list -> M2 source string."""
    mons, _ = monomials(d, nv)
    terms = []
    nz = np.nonzero(np.asarray(vec) % p)[0]
    for i in nz:
        c = int(vec[i]) % p
        s = str(c)
        for k, e in enumerate(mons[i]):
            if e:
                s += "*x%d" % k + ("^%d" % e if e > 1 else "")
        terms.append(s)
    return "+".join(terms) if terms else "0_R"


def det_poly(M, p, nv=5):
    n = len(M)
    total = {}
    for perm in itertools.permutations(range(n)):
        sgn = perm_sign(perm)
        term = {tuple([0] * nv): 1}
        for i in range(n):
            term = poly_mul(term, M[i][perm[i]], p)
            if not term:
                break
        if term:
            total = poly_add(total, poly_scale(term, sgn, p), p)
    return total


def perm_sign(perm):
    perm = list(perm)
    n = len(perm)
    seen = [False] * n
    sgn = 1
    for i in range(n):
        if seen[i]:
            continue
        j, ln = i, 0
        while not seen[j]:
            seen[j] = True
            j = perm[j]
            ln += 1
        if ln % 2 == 0:
            sgn = -sgn
    return sgn


# ------------------------------------------------------------------ the cubic

KLEIN = {}
for _i in range(5):
    _m = [0] * 5
    _m[_i] += 2
    _m[(_i + 1) % 5] += 1
    KLEIN[tuple(_m)] = 1


def F_eval(V, p):
    V = V % p
    return sum((V[:, i] ** 2 % p) * V[:, (i + 1) % 5] for i in range(5)) % p


def hessian_H(p):
    """H = det(Hess F), the degree-5 invariant, as a coefficient dict."""
    Hs = [[poly_diff(poly_diff(KLEIN, i, p), j, p) for j in range(5)]
          for i in range(5)]
    return det_poly(Hs, p)


# ------------------------------------------------------------------- checks

def check(name, ok, note=""):
    line = "CHECK %s %s%s" % (name, "PASS" if ok else "FAIL",
                              ("  # " + note) if note else "")
    os.makedirs(os.path.dirname(CHECKLOG), exist_ok=True)
    with open(CHECKLOG, "a") as f:
        f.write(line + "\n")
    print(line, flush=True)
    return ok
