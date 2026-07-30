#!/usr/bin/env python3
"""Shared exact helpers for WP-4 local transition modules.

Uses the certified Q(zeta_11) representation from exact_weil_check.py.
Does not import any WP-4 producer.  Absolute-path-safe for tests.
"""

from __future__ import annotations

import hashlib
import math
import sys
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
sys.path.insert(0, str(CERT))
import exact_weil_check as ew  # noqa: E402


def sha256_file(path: Path | str) -> str:
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def mul_key(a, b):
    return ew.fcanon(ew.fmul(a, b))


def inv_key(a):
    aa, b, c, d = a
    return ew.fcanon((d, -b, -c, aa))


def power_key(a, n):
    out = ew.fone
    for _ in range(n):
        out = mul_key(out, a)
    return out


def order_key(a, bound=100):
    out = ew.fone
    for n in range(1, bound + 1):
        out = mul_key(out, a)
        if out == ew.fone:
            return n
    raise AssertionError(f"order exceeded bound for {a}")


def matmul5(A, B):
    return [
        [sum(A[i][k] * B[k][j] for k in range(5)) for j in range(5)]
        for i in range(5)
    ]


def mv(M, v):
    return [sum(M[i][j] * v[j] for j in range(len(v))) for i in range(len(M))]


def mpow5(A, n):
    R = [[ew.C(i == j) for j in range(5)] for i in range(5)]
    while n:
        if n & 1:
            R = matmul5(R, A)
        A = matmul5(A, A)
        n //= 2
    return R


def klein(v):
    """F(v) = sum_i v_i^2 v_{i+1} over Q(zeta_11) entries."""
    return sum(v[i] * v[i] * v[(i + 1) % 5] for i in range(5))


def nullspace_exact(matrix_rows, field_zero=None):
    """Right nullspace over Q via Gaussian elimination with Fraction.

    matrix_rows: list of list of Fraction (or int).
    Returns list of basis vectors (lists of Fraction).
    """
    if not matrix_rows:
        return []
    a = [[Q(x) for x in row] for row in matrix_rows]
    rows, cols = len(a), len(a[0])
    pivots = []
    r = 0
    for c in range(cols):
        pivot = next((i for i in range(r, rows) if a[i][c] != 0), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        inv = Q(1) / a[r][c]
        a[r] = [inv * x for x in a[r]]
        for i in range(rows):
            if i != r and a[i][c] != 0:
                factor = a[i][c]
                a[i] = [a[i][j] - factor * a[r][j] for j in range(cols)]
        pivots.append(c)
        r += 1
        if r == rows:
            break
    free = [c for c in range(cols) if c not in pivots]
    basis = []
    for f in free:
        v = [Q(0)] * cols
        v[f] = Q(1)
        for i, c in enumerate(pivots):
            v[c] = -a[i][f]
        basis.append(v)
    return basis


def binom(n, k):
    if k < 0 or n < 0 or k > n:
        return 0
    return math.comb(n, k)


def dim_sym(dim_v: int, degree: int) -> int:
    """dim Sym^degree of a dim_v-dimensional vector space."""
    if degree < 0:
        return 0
    return binom(degree + dim_v - 1, dim_v - 1)


# ---------------------------------------------------------------------------
# Modular reduction at a split prime for zeta_11 (regression only)
# ---------------------------------------------------------------------------

MODULAR_PRIMES = {
    67: 64,   # zeta_11 ≡ 64
    89: 78,
    331: 270,
}


def cmod(a: ew.C, p: int, zeta: int) -> int:
    total = 0
    power = 1
    for coefficient in a.a:
        num = coefficient.numerator % p
        den = pow(coefficient.denominator % p, -1, p)
        total = (total + num * den * power) % p
        power = power * zeta % p
    return total


def mmod(matrix, p: int, zeta: int):
    return [[cmod(entry, p, zeta) for entry in row] for row in matrix]


def nullspace_mod(matrix, p: int):
    a = [[entry % p for entry in row] for row in matrix]
    rows, cols = len(a), len(a[0])
    pivots = []
    r = 0
    for c in range(cols):
        pivot = next((i for i in range(r, rows) if a[i][c]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        inv = pow(a[r][c], -1, p)
        a[r] = [(inv * x) % p for x in a[r]]
        for i in range(rows):
            if i != r and a[i][c]:
                factor = a[i][c]
                a[i] = [(a[i][j] - factor * a[r][j]) % p for j in range(cols)]
        pivots.append(c)
        r += 1
        if r == rows:
            break
    free = [c for c in range(cols) if c not in pivots]
    basis = []
    for f in free:
        v = [0] * cols
        v[f] = 1
        for i, c in enumerate(pivots):
            v[c] = -a[i][f] % p
        basis.append(v)
    return basis


def centralizer_of_S():
    """Exact C_G(S) as list of PSL keys; S = fs is the standard involution."""
    t = ew.fs
    return [g for g in ew.rho if mul_key(g, t) == mul_key(t, g)]


def find_order_elements(keys, n):
    return [g for g in keys if order_key(g) == n]


# Molien / Hilbert helpers for finite abelian groups of characters

def molien_C2_on_signs(sign_list, max_m=20, max_d=20):
    """Placeholder; concrete Molien formulas live in each package."""
    raise NotImplementedError
