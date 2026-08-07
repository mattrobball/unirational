"""Minimal exact F_p linear algebra (deterministic, no external deps)."""


def inv(a, p):
    a %= p
    if a == 0:
        raise ZeroDivisionError("inverse of 0")
    return pow(a, p - 2, p)


def matmul(A, B, p):
    n = len(A)
    m = len(B[0])
    k = len(B)
    C = [[0] * m for _ in range(n)]
    for i in range(n):
        Ai = A[i]
        Ci = C[i]
        for t in range(k):
            a = Ai[t]
            if a:
                Bt = B[t]
                for j in range(m):
                    Ci[j] = (Ci[j] + a * Bt[j]) % p
    return C


def matvec(A, v, p):
    return [sum(A[i][j] * v[j] for j in range(len(v))) % p for i in range(len(A))]


def ident(n):
    return [[1 if i == j else 0 for j in range(n)] for i in range(n)]


def scal(A, c, p):
    return [[(c * x) % p for x in row] for row in A]


def madd(A, B, p):
    return [[(A[i][j] + B[i][j]) % p for j in range(len(A[0]))] for i in range(len(A))]


def transpose(A):
    return [list(r) for r in zip(*A)]


def key(A, p):
    return tuple(tuple(x % p for x in row) for row in A)


def rref(A, p):
    """Return (R, pivots) with R the reduced row echelon form of A (copy)."""
    R = [[x % p for x in row] for row in A]
    rows = len(R)
    cols = len(R[0]) if rows else 0
    piv = []
    r = 0
    for c in range(cols):
        if r >= rows:
            break
        s = None
        for i in range(r, rows):
            if R[i][c] % p:
                s = i
                break
        if s is None:
            continue
        R[r], R[s] = R[s], R[r]
        iv = inv(R[r][c], p)
        R[r] = [(x * iv) % p for x in R[r]]
        for i in range(rows):
            if i != r and R[i][c] % p:
                f = R[i][c]
                R[i] = [(R[i][j] - f * R[r][j]) % p for j in range(cols)]
        piv.append(c)
        r += 1
    return R, piv


def rank(A, p):
    if not A or not A[0]:
        return 0
    _, piv = rref(A, p)
    return len(piv)


def nullspace(A, p):
    """Basis (list of vectors) of {x : A x = 0}."""
    if not A:
        return []
    cols = len(A[0])
    R, piv = rref(A, p)
    free = [c for c in range(cols) if c not in piv]
    basis = []
    for f in free:
        v = [0] * cols
        v[f] = 1
        for i, c in enumerate(piv):
            v[c] = (-R[i][f]) % p
        basis.append(v)
    return basis


def rowspace_basis(A, p):
    R, piv = rref(A, p)
    return [R[i] for i in range(len(piv))]


def sqrt_mod(a, p):
    """Deterministic square root mod p (Tonelli-Shanks, smallest non-residue)."""
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


def prim_root_of_unity(n, p):
    """Deterministic primitive n-th root of unity in F_p (smallest generator power)."""
    assert (p - 1) % n == 0
    g = 2
    while True:
        ok = True
        for q in _factor(p - 1):
            if pow(g, (p - 1) // q, p) == 1:
                ok = False
                break
        if ok:
            break
        g += 1
    return pow(g, (p - 1) // n, p)


def _factor(n):
    fs = set()
    d = 2
    while d * d <= n:
        while n % d == 0:
            fs.add(d)
            n //= d
        d += 1
    if n > 1:
        fs.add(n)
    return sorted(fs)
