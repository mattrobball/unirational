#!/usr/bin/env python3
"""FIX-C1 -- explicit points of Spec R over finite fields.

Used ONLY to guess pivot rows and as an independent cross-check of the exact
verdicts (a rank computed at a split point of Spec R mod p is a lower bound
for the rank over R, and the exact routine certifies the matching upper bound).
"""
import sympy as sp


def roots_mod(coeffs, p):
    """all roots in F_p of the polynomial with the given (descending) coeffs."""
    out = []
    for t in range(p):
        v = 0
        for a in coeffs:
            v = (v*t + a) % p
        if v == 0:
            out.append(t)
    return out


def _rat(q, p):
    q = sp.Rational(q)
    return int(q.p) % p * pow(int(q.q) % p, p - 2, p) % p


def points_m1(j, p, limit=None):
    """(om, kp, c, P1) in F_p^4 satisfying the four relations of block j."""
    oms = roots_mod([1, 1, 1], p)
    kps = roots_mod([8, -13, -4], p)
    pts = []
    for o in oms:
        for k in kps:
            kap = (k + 2) % p
            for cc in roots_mod([1, 0, (-3) % p, (-kap) % p], p):
                omj = pow(o, (j + 1) % 3, p)
                a2 = (-_rat(sp.Rational(8, 9), p)*omj % p)*kap % p
                a0 = _rat(sp.Rational(32, 27), p)*kap % p
                for P1 in roots_mod([1, a2, 0, a0], p):
                    pts.append((P1, cc, o, k))
    if limit:
        pts = pts[:limit]
    return pts


def points_control(p, limit=None):
    """(B, om, kp) in F_p^3 with om^2+om+1 = 0, 8kp^2-13kp-4 = 0,
    B^6 - (kp+2) B^3 + 1 = 0."""
    oms = roots_mod([1, 1, 1], p)
    kps = roots_mod([8, -13, -4], p)
    pts = []
    for o in oms:
        for k in kps:
            kap = (k + 2) % p
            for B in roots_mod([1, 0, 0, (-kap) % p, 0, 0, 1], p):
                pts.append((B, o, k))
    if limit:
        pts = pts[:limit]
    return pts


def good_primes(j, lo=100000, hi=200000, want=3, kind='m1'):
    out = []
    for p in sp.primerange(lo, hi):
        if p % 3 != 1:
            continue
        if pow(33, (p - 1)//2, p) != 1:
            continue
        pts = points_m1(j, p) if kind == 'm1' else points_control(p)
        if kind == 'm1' and len(pts) >= 36:      # 2*2*3*3 = fully split
            out.append(p)
        if kind == 'control' and len(pts) >= 24:  # 2*2*6
            out.append(p)
        if len(out) >= want:
            break
    return out


if __name__ == '__main__':
    for j in (0, 1, 2):
        ps = good_primes(j, want=3)
        print('block j=%d: fully split primes %s' % (j, ps))
        if ps:
            print('   #points =', len(points_m1(j, ps[0])))
    ps = good_primes(0, want=3, kind='control')
    print('control: fully split primes %s  #points = %d'
          % (ps, len(points_control(ps[0])) if ps else 0))


def points_m1_split(j, part, p):
    """points of one Galois-stable part of the block-j parameter scheme."""
    import sympy as sp
    pts = points_m1(j, p)
    out = []
    for (P1, cc, o, k) in pts:
        c0 = _rat(sp.Rational(-1, 3), p) + _rat(sp.Rational(4, 3), p)*k % p
        c0 = (_rat(sp.Rational(4, 3), p)*k - _rat(sp.Rational(1, 3), p)) % p
        p10 = _rat(sp.Rational(4, 3), p)*pow(o, (j + 1) % 3, p) % p*c0 % p
        isc, isp = (cc == c0), (P1 == p10)
        want = {'A': (True, True), 'B': (True, False),
                'C': (False, True), 'D': (False, False)}[part]
        if (isc, isp) == want:
            out.append((P1, cc, o, k))
    return out
