#!/usr/bin/env python3
"""FIX-U1-FIN7 -- modular Jacobian ranks at the 27 classified points.

Modular ranks are used ONLY as (i) a rigorous LOWER bound on the
characteristic-zero rank (reduction of an exact point mod a prime of good
reduction can only drop the rank -- a nonzero r x r minor mod p is a nonzero
r x r minor over the number field), and (ii) a cheap scan.  The matching upper
bound comes from exactly exhibited kernel vectors.
"""
import sys

import sympy as sp

import fin7_equiv as E
import fin7_jac as JJ
import fin7_lib as L
from fin7_equiv import B2s, P1s
from fin7_lib import kp, om

sys.setrecursionlimit(10000)


def is_prime(n):
    if n < 2:
        return False
    for q in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37):
        if n % q == 0:
            return n == q
    d, s = n - 1, 0
    while d % 2 == 0:
        d //= 2
        s += 1
    for a in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37):
        xx = pow(a, d, n)
        if xx in (1, n - 1):
            continue
        for _ in range(s - 1):
            xx = xx*xx % n
            if xx == n - 1:
                break
        else:
            return False
    return True


def sqrt_mod(a, p):
    a %= p
    if a == 0:
        return 0
    if pow(a, (p - 1)//2, p) != 1:
        return None
    if p % 4 == 3:
        return pow(a, (p + 1)//4, p)
    q, s = p - 1, 0
    while q % 2 == 0:
        q //= 2
        s += 1
    zz = 2
    while pow(zz, (p - 1)//2, p) != p - 1:
        zz += 1
    m, c, t, R = s, pow(zz, q, p), pow(a, q, p), pow(a, (q + 1)//2, p)
    while t != 1:
        i, t2 = 0, t
        while t2 != 1:
            t2 = t2*t2 % p
            i += 1
        b = pow(c, 1 << (m - i - 1), p)
        m, c = i, b*b % p
        t = t*c % p
        R = R*b % p
    return R


def roots_om_kp(p):
    if p % 3 != 1:
        return None
    g = 2
    while pow(g, (p - 1)//3, p) == 1:
        g += 1
    omp = pow(g, (p - 1)//3, p)
    s = sqrt_mod(297 % p, p)
    if s is None:
        return None
    kpp = (13 + s)*pow(16, p - 2, p) % p
    assert (omp*omp + omp + 1) % p == 0
    assert (8*kpp*kpp - 13*kpp - 4) % p == 0
    return omp, kpp


def cubic_roots_mod(coeffs, p):
    """all roots in F_p of a monic cubic given by [1,c2,c1,c0]."""
    return [t for t in range(p)
            if (((t + coeffs[1])*t + coeffs[2])*t + coeffs[3]) % p == 0]


def to_fp(expr, sub, p):
    """rational number -> F_p, with modular inversion of the denominator."""
    v = sp.Rational(sp.expand(expr).subs(sub))
    q = int(v.q) % p
    assert q != 0, 'prime divides a denominator'
    return int(v.p) % p * pow(q, p - 2, p) % p


def block_points_mod(j, p, omp, kpp):
    g1, g2 = E.block_cubics(j)
    sub = {om: omp, kp: kpp}

    def cf(poly, v):
        pp = sp.Poly(poly, v)
        a = [to_fp(c, sub, p) for c in pp.all_coeffs()]
        assert a[0] == 1, a
        return a
    r1 = cubic_roots_mod(cf(g1, B2s), p)
    r2 = cubic_roots_mod(cf(g2, P1s), p)
    return r1, r2


def good_primes(lo, count):
    out, n = [], lo | 1
    while len(out) < count:
        n += 2
        if not is_prime(n):
            continue
        rr = roots_om_kp(n)
        if rr is None:
            continue
        omp, kpp = rr
        ok = True
        for j in range(3):
            r1, r2 = block_points_mod(j, n, omp, kpp)
            if len(r1) != 3 or len(r2) != 3:
                ok = False
                break
        if ok:
            out.append((n, omp, kpp))
    return out


def point_mod(j, B2v, P1v, p, omp, kpp, names, coords=None):
    if coords is None:
        coords = E.classified_point(j)
    sub = {om: omp, kp: kpp, B2s: B2v, P1s: P1v}
    return [to_fp(coords[n], sub, p) for n in names]


def eqs_mod(eqs, p, omp, kpp):
    sub = {om: omp, kp: kpp}
    return [(mon, [(to_fp(c, sub, p), idx) for c, idx in terms])
            for mon, terms in eqs]
