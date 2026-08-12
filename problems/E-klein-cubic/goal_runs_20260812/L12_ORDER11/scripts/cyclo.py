"""Exact arithmetic in Q(zeta_11) on the power basis of Phi_11.

No floats anywhere.  An element is a tuple of 10 Fractions:
    c[0] + c[1] z + ... + c[9] z^9,   z = zeta_11,  Phi_11(z) = 0,
i.e. z^10 = -(1 + z + ... + z^9).

Also exposes:
  * the prime pi = 1 - z above 11 (residue field F_11 via z -> 1),
  * val_pi / res_pi for algebraic integers,
  * the Galois action sigma_m : z -> z^m.
"""
from fractions import Fraction as Fr

N = 11
DEG = 10  # deg Phi_11


def zero():
    return (Fr(0),) * DEG


def one():
    return (Fr(1),) + (Fr(0),) * (DEG - 1)


def from_int(n):
    return (Fr(n),) + (Fr(0),) * (DEG - 1)


def zpow(e):
    """zeta^e as an element (e any integer)."""
    e %= N
    if e < DEG:
        c = [Fr(0)] * DEG
        c[e] = Fr(1)
        return tuple(c)
    # e == 10
    return tuple(Fr(-1) for _ in range(DEG))


def add(x, y):
    return tuple(a + b for a, b in zip(x, y))


def sub(x, y):
    return tuple(a - b for a, b in zip(x, y))


def neg(x):
    return tuple(-a for a in x)


def smul(r, x):
    r = Fr(r)
    return tuple(r * a for a in x)


def _reduce_poly(p):
    """p is a list of Fractions of any length; reduce mod Phi_11."""
    p = list(p)
    while len(p) < DEG:
        p.append(Fr(0))
    for i in range(len(p) - 1, DEG - 1, -1):
        c = p[i]
        if c == 0:
            continue
        p[i] = Fr(0)
        # z^i = z^(i-10) * z^10 = z^(i-10) * -(1+z+...+z^9)
        base = i - DEG
        for j in range(DEG):
            p[base + j] -= c
    return tuple(p[:DEG])


def mul(x, y):
    p = [Fr(0)] * (2 * DEG - 1)
    for i, a in enumerate(x):
        if a == 0:
            continue
        for j, b in enumerate(y):
            if b == 0:
                continue
            p[i + j] += a * b
    return _reduce_poly(p)


def is_zero(x):
    return all(a == 0 for a in x)


def eq(x, y):
    return all(a == b for a, b in zip(x, y))


_INV_CACHE = {}


def inv(x):
    """Multiplicative inverse via 10x10 exact linear solve."""
    key = x
    if key in _INV_CACHE:
        return _INV_CACHE[key]
    if is_zero(x):
        raise ZeroDivisionError("inverse of 0 in Q(zeta_11)")
    # matrix of multiplication-by-x in the power basis
    cols = []
    for j in range(DEG):
        e = [Fr(0)] * DEG
        e[j] = Fr(1)
        cols.append(mul(x, tuple(e)))
    M = [[cols[j][i] for j in range(DEG)] for i in range(DEG)]
    rhs = [Fr(1)] + [Fr(0)] * (DEG - 1)
    y = _solve(M, rhs)
    res = tuple(y)
    _INV_CACHE[key] = res
    return res


def _solve(M, rhs):
    n = len(M)
    A = [row[:] + [rhs[i]] for i, row in enumerate(M)]
    for c in range(n):
        piv = None
        for r in range(c, n):
            if A[r][c] != 0:
                piv = r
                break
        if piv is None:
            raise ZeroDivisionError("singular multiplication matrix")
        A[c], A[piv] = A[piv], A[c]
        pv = A[c][c]
        A[c] = [v / pv for v in A[c]]
        for r in range(n):
            if r == c:
                continue
            f = A[r][c]
            if f != 0:
                A[r] = [vr - f * vc for vr, vc in zip(A[r], A[c])]
    return [A[i][n] for i in range(n)]


def div(x, y):
    return mul(x, inv(y))


def prod(items):
    r = one()
    for it in items:
        r = mul(r, it)
    return r


def total(items):
    r = zero()
    for it in items:
        r = add(r, it)
    return r


def sigma(x, m):
    """Galois automorphism zeta -> zeta^m, m coprime to 11."""
    assert m % N != 0
    out = zero()
    for i, c in enumerate(x):
        if c != 0:
            out = add(out, smul(c, zpow(i * m)))
    return out


def one_minus_zpow(e):
    """1 - zeta^e (nonzero for e != 0 mod 11)."""
    assert e % N != 0
    return sub(one(), zpow(e))


# ---------------------------------------------------------------- pi-adic
def is_alg_int(x):
    return all(c.denominator == 1 for c in x)


def res_pi(x):
    """Image in Z[zeta]/(1-zeta) = F_11 (algebraic integers only)."""
    assert is_alg_int(x), "res_pi needs an algebraic integer"
    return sum(int(c) for c in x) % N


def val_pi(x, cap=40):
    """(1-zeta)-adic valuation of an algebraic integer (cap for safety)."""
    if is_zero(x):
        return cap
    assert is_alg_int(x)
    v = 0
    cur = x
    piinv = inv(one_minus_zpow(1))
    while v < cap:
        if res_pi(cur) != 0:
            return v
        cur = mul(cur, piinv)
        if not is_alg_int(cur):
            return v
        v += 1
    return cap


def to_str(x):
    parts = []
    for i, c in enumerate(x):
        if c == 0:
            continue
        parts.append(f"{c}" if i == 0 else f"{c}*z^{i}")
    return " + ".join(parts) if parts else "0"
