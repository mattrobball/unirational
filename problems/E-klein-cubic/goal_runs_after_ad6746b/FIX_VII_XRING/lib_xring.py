"""Core mod-p linear algebra + symmetric-power machinery for FIX-VII-XRING."""
import itertools, json, os
import numpy as np

# ---------------------------------------------------------------- modular LA

def rref(A, p):
    """Row-reduce A (numpy int64, mod p) in place-ish. Returns (R, pivots)."""
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


def nullspace(A, p):
    """Right nullspace basis of A (mod p) as columns of an n x k array."""
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
    """Tonelli-Shanks; returns a root or None."""
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


def nth_root_unity(n, p):
    """A primitive n-th root of unity mod p (requires n | p-1)."""
    assert (p - 1) % n == 0
    g = 2
    while True:
        if pow(g, (p - 1) // 2, p) == p - 1 and all(
                pow(g, (p - 1) // q, p) != 1 for q in prime_factors(p - 1)):
            break
        g += 1
    return pow(g, (p - 1) // n, p)


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


def sym_power_matrix(g, d, p, nv=5):
    """S_d(g)[a,b]:  m_a(g v) = sum_b S_d(g)[a,b] m_b(v)."""
    g = np.asarray(g, dtype=np.int64) % p
    mons, idx = monomials(d, nv)
    if d == 0:
        return np.ones((1, 1), dtype=np.int64)
    prev, previdx = monomials(d - 1, nv)
    Sprev = sym_power_matrix(g, d - 1, p, nv)
    # shift tables: for each k, index of beta + e_k in degree-d list
    shift = np.zeros((nv, len(prev)), dtype=np.int64)
    for k in range(nv):
        for j, b in enumerate(prev):
            bb = list(b)
            bb[k] += 1
            shift[k, j] = idx[tuple(bb)]
    # group alpha by pivot i = first index with alpha_i > 0
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
        blk = Sprev[srcs]                      # (len(rows), N_{d-1})
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


def poly_str(a, names=('x0', 'x1', 'x2', 'x3', 'x4')):
    if not a:
        return "0"
    terms = []
    for m in sorted(a.keys(), reverse=True):
        c = a[m]
        s = str(c)
        for i, e in enumerate(m):
            if e == 1:
                s += "*" + names[i]
            elif e > 1:
                s += "*" + names[i] + "^" + str(e)
        terms.append(s)
    return "+".join(terms)


def det_poly(M, p, nv=5):
    """Determinant of an n x n matrix of polynomials (dicts), by expansion."""
    n = len(M)
    idxs = list(range(n))
    total = {}
    for perm in itertools.permutations(idxs):
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
    """F on rows of V (n x 5)."""
    V = V % p
    return sum((V[:, i] ** 2 % p) * V[:, (i + 1) % 5] for i in range(5)) % p


# ------------------------------------------------------------------- checks

CHECKLOG = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        "results", "checks.log")


def check(name, ok, note=""):
    line = "CHECK %s %s%s" % (name, "PASS" if ok else "FAIL",
                              ("  # " + note) if note else "")
    os.makedirs(os.path.dirname(CHECKLOG), exist_ok=True)
    with open(CHECKLOG, "a") as f:
        f.write(line + "\n")
    print(line, flush=True)
    return ok
