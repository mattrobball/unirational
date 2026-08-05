#!/usr/bin/env python3
"""FIX-H1: exact factorisation of a generator over K = QQ(om,kp) = QQ(sqrt-3, sqrt33).

K = QQ(om, kp) with om = (-1+sqrt(-3))/2 and kp = (13+3 sqrt 33)/16, so
sqrt(-3) = 2om+1 and sqrt(33) = (16kp-13)/3 -- a biquadratic field.  sympy can
factor multivariate polynomials over it with extension=[sqrt(-3), sqrt(33)].

If a generator g factors as  prod h_i^{e_i}, then V(g) = union V(h_i): this is
an EXACT branching step in characteristic zero (used by holes_solve/holes_track
when no monomial factor is available -- it is what cracks the perfect-cube
generators  c*(B2 + Y3*B9)^3  that the linear cascade cannot see).
"""
from fractions import Fraction as Fr

import sympy as sp

S3 = sp.sqrt(-3)
S33 = sp.sqrt(33)
OMs = sp.Rational(-1, 2) + S3 / 2
KPs = (13 + 3 * S33) / 16
EXT = [S3, S33]


def k_to_sympy(c):
    return sp.expand(sp.Rational(c[0]) + sp.Rational(c[1]) * OMs
                     + sp.Rational(c[2]) * KPs
                     + sp.Rational(c[3]) * OMs * KPs)


def sympy_to_k(e):
    """express e in K = QQ(sqrt-3, sqrt33) in the basis {1, om, kp, om*kp}.

    sympy normalises sqrt(-3) to sqrt(3)*I and sqrt(3)*sqrt(33) to 3*sqrt(11),
    so the safe generator set is (I, sqrt3, sqrt11):

        1            -> 1
        I*sqrt3      -> s3   = sqrt(-3)
        sqrt3*sqrt11 -> s33  = sqrt(33)
        I*sqrt11     -> s3*s33/3

    and then  1 = 1,  s3 = 1+2om,  s33 = (16kp-13)/3,  s3*s33 = (1+2om)(16kp-13)/3.
    The result is verified by an exact round trip.
    """
    e = sp.expand(sp.radsimp(sp.expand(e)))
    I, r3, r11 = sp.I, sp.sqrt(3), sp.sqrt(11)
    pe = sp.Poly(e, I, r3, r11)
    v = {0: sp.Integer(0), 1: sp.Integer(0), 2: sp.Integer(0), 3: sp.Integer(0)}
    for mono, c in zip(pe.monoms(), pe.coeffs()):
        a, b, cc = mono
        q = sp.Rational(c)
        while a >= 2:
            q *= -1
            a -= 2
        while b >= 2:
            q *= 3
            b -= 2
        while cc >= 2:
            q *= 11
            cc -= 2
        key = (a, b, cc)
        if key == (0, 0, 0):
            v[0] += q
        elif key == (1, 1, 0):
            v[1] += q
        elif key == (0, 1, 1):
            v[2] += q
        elif key == (1, 0, 1):
            v[3] += q / 3
        else:
            raise ValueError('not in K: %s' % e)
    # {1, s3, s33, s3 s33} -> {1, om, kp, om kp}
    out = [sp.Rational(0)] * 4
    out[0] += v[0]
    out[0] += v[1]
    out[1] += 2 * v[1]
    out[0] += v[2] * sp.Rational(-13, 3)
    out[2] += v[2] * sp.Rational(16, 3)
    out[0] += v[3] * sp.Rational(-13, 3)
    out[1] += v[3] * sp.Rational(-26, 3)
    out[2] += v[3] * sp.Rational(16, 3)
    out[3] += v[3] * sp.Rational(32, 3)
    res = tuple(Fr(int(sp.Rational(x).p), int(sp.Rational(x).q)) for x in out)
    assert sp.simplify(sp.expand(k_to_sympy(res) - e)) == 0, (res, e)
    return res


_CACHE = {}


def factor_gen(names, q, maxterms=20):
    """[(poly_dict, multiplicity)] or None if it does not factor."""
    if len(q) > maxterms:
        return None
    key = (tuple(names), tuple(sorted(q.items())))
    if key in _CACHE:
        return _CACHE[key]
    vs = [sp.Symbol(n) for n in names]
    e = sp.Integer(0)
    for k, c in q.items():
        m = k_to_sympy(c)
        for i, ex in enumerate(k):
            if ex:
                m *= vs[i] ** ex
        e += m
    e = sp.expand(e)
    try:
        cont, facs = sp.factor_list(e, *vs, extension=EXT)
    except Exception:
        return None
    if len(facs) == 1 and facs[0][1] == 1:
        _CACHE[key] = None
        return None
    out = []
    try:
        pass
    except Exception:
        pass
    for f, mult in facs:
        pf = sp.Poly(sp.expand(f), *vs)
        d = {}
        for mono, coeff in zip(pf.monoms(), pf.coeffs()):
            d[tuple(mono)] = sympy_to_k(coeff)
        out.append((d, mult))
    _CACHE[key] = out
    return out


def factor_gen_safe(names, q, maxterms=6):
    try:
        return factor_gen(names, q, maxterms=maxterms)
    except Exception:
        return None


if __name__ == '__main__':
    import holes_track as TR, holes_reduce as RD
    br, blk, vs = TR.stratum_branch(8, 'one', 'B')
    leaves = TR.solve(br)
    lf = leaves[8]
    q = sorted(lf.polys, key=len)[0]
    print('generator:', RD.polystr(q, lf.names))
    f = factor_gen(lf.names, q)
    print('factors:')
    for d, m in f:
        print('   (%s)^%d' % (RD.polystr(d, lf.names), m))
