"""Minimal exact cyclotomic-integer arithmetic.  Integers only; no floats.

An element of Z[zeta_N] is carried as a length-N integer vector v, meaning
sum_j v[j] * zeta_N^j  (i.e. a class in Z[x]/(x^N - 1) mapping onto Z[zeta_N]).
Canonicalisation = reduction of the polynomial modulo the N-th cyclotomic
polynomial Phi_N, which is monic with integer coefficients, so the division is
exact over Z.  An element is rational iff its canonical form has degree <= 0.
"""


def poly_divmod(a, b):
    """Exact integer polynomial division; b must be monic.  Lists are
    little-endian coefficient lists."""
    a = list(a)
    db = len(b) - 1
    assert b[db] == 1, "divisor must be monic"
    q = [0] * max(1, len(a) - db)
    for i in range(len(a) - 1, db - 1, -1):
        c = a[i]
        if c:
            q[i - db] = c
            for j in range(db + 1):
                a[i - db + j] -= c * b[j]
    while len(a) > 1 and a[-1] == 0:
        a.pop()
    return q, a


_PHI = {}


def cyclotomic_poly(n):
    """Phi_n by exact recursive division of x^n - 1."""
    if n in _PHI:
        return _PHI[n]
    num = [0] * (n + 1)
    num[0] = -1
    num[n] = 1
    for d in range(1, n):
        if n % d == 0:
            num, r = poly_divmod(num, cyclotomic_poly(d))
            assert all(c == 0 for c in r), "non-exact division in Phi_%d" % n
    _PHI[n] = num
    return num


def canon(v, N):
    """Canonical representative of v (length N) modulo Phi_N."""
    _, r = poly_divmod(list(v), cyclotomic_poly(N))
    while len(r) > 1 and r[-1] == 0:
        r.pop()
    return r


def to_int(v, N):
    """Return the rational integer represented by v, or None if irrational."""
    r = canon(v, N)
    if len(r) == 1:
        return r[0]
    return None


def zero(N):
    return [0] * N


def add_into(dst, src, scale=1):
    for j, c in enumerate(src):
        if c:
            dst[j] += scale * c
    return dst


def mul(a, b, N):
    """Product in Z[x]/(x^N - 1)."""
    out = [0] * N
    for i, ai in enumerate(a):
        if ai:
            for j, bj in enumerate(b):
                if bj:
                    out[(i + j) % N] += ai * bj
    return out


def embed(v, n, N):
    """Embed an element of Z[x]/(x^n - 1) into Z[x]/(x^N - 1); n | N."""
    assert N % n == 0
    s = N // n
    out = [0] * N
    for j, c in enumerate(v):
        if c:
            out[(j * s) % N] += c
    return out


def root(e, N):
    """The element zeta_N^e."""
    out = [0] * N
    out[e % N] = 1
    return out
