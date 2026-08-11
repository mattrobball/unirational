"""Tiny CRT / factorisation helpers (no external dependencies)."""

from math import gcd


def prime_factors(n):
    n = abs(n)
    out = set()
    d = 2
    while d * d <= n:
        while n % d == 0:
            out.add(d)
            n //= d
        d += 1
    if n > 1:
        out.add(n)
    return sorted(out)


def crt_solve(mods):
    """mods = [(m_1, r_1), ...] with pairwise coprime m_i; least POSITIVE solution."""
    M, R = 1, 0
    for m, r in mods:
        assert gcd(M, m) == 1, f"moduli not coprime: {M}, {m}"
        # solve R + M*k = r (mod m)
        inv = pow(M % m, -1, m) if m > 1 else 0
        k = ((r - R) * inv) % m if m > 1 else 0
        R = R + M * k
        M = M * m
    R %= M
    if R == 0:
        R = M
    return R
