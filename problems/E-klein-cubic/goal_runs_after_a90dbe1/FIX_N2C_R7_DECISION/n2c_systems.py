#!/usr/bin/env python3
"""FIX-N2C: the (m,r) = (1,7) plane-order-1 systems.

Builds the C3-equivariant landing system on the cell (m,r) = (1,7) for each
residual-C3 scalar lam, dehomogenises at a plane-order-1 parameter (B5 or B8),
and emits msolve input either

  * over a prime field F_p with chosen roots (om_p, kp_p)          [mode 'ff']
  * over QQ with om, kp adjoined as VARIABLES subject to their
    minimal polynomials om^2+om+1, 8kp^2-13kp-4                    [mode 'qq']
  * over F_p with om, kp adjoined as variables (works at inert
    primes too, and is an independent encoding)                    [mode 'fv']

The 'qq' mode is characteristic-zero rigorous: 8kp^2-13kp-4 and om^2+om+1 are
irreducible over QQ, so Gal(Qbar/QQ) acts transitively on their roots and the
whole system is defined over QQ; hence V(I_QQ) is nonempty over Qbar iff it is
nonempty for the packet's specific pair (om, kp+).

The engine itself is FIX-N2B's `n2b_lib` (reproduction path); `verify_n2c.py`
rebuilds the same system from scratch in sympy from the raw Klein normal form
and checks the two agree termwise.
"""
import os
import sys

N2B = ('/Users/worker/unirational/problems/E-klein-cubic/'
       'goal_runs_after_fa02f05/FIX_N2B_M1_ROW')
sys.path.insert(0, N2B)

import n2b_lib as L                                             # noqa: E402
from n2b_lib import ONE, OM, OM2, ZERO                          # noqa: E402
from fractions import Fraction as Fr                            # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
MSOLVE = '/opt/homebrew/bin/msolve'
LAMS = {'one': ONE, 'om': OM, 'om2': OM2}
TAGOF = {ONE: 'one', OM: 'om', OM2: 'om2'}


# --------------------------------------------------------------------------
# generic sparse polynomial in the block parameters, coefficients in K
# --------------------------------------------------------------------------
def poly_from_pc(pc):
    """{param_exponent_tuple: Kelt} -- already the right shape."""
    return dict(pc)


def p_add(a, b):
    out = dict(a)
    for k, v in b.items():
        w = L.kadd(out.get(k, ZERO), v)
        if L.kiszero(w):
            out.pop(k, None)
        else:
            out[k] = w
    return out


def p_scal(a, c):
    out = {}
    for k, v in a.items():
        w = L.kmul(v, c)
        if not L.kiszero(w):
            out[k] = w
    return out


def p_mul(a, b):
    out = {}
    for ka, va in a.items():
        for kb, vb in b.items():
            k = tuple(i + j for i, j in zip(ka, kb))
            w = L.kadd(out.get(k, ZERO), L.kmul(va, vb))
            if L.kiszero(w):
                out.pop(k, None)
            else:
                out[k] = w
    return out


def p_setvar(a, i, val):
    """substitute variable i by the constant `val` (a K element)."""
    out = {}
    for k, v in a.items():
        e = k[i]
        c = v
        for _ in range(e):
            c = L.kmul(c, val)
        if L.kiszero(c):
            continue
        kk = list(k)
        kk[i] = 0
        kk = tuple(kk)
        w = L.kadd(out.get(kk, ZERO), c)
        if L.kiszero(w):
            out.pop(kk, None)
        else:
            out[kk] = w
    return out


def p_substitute(a, i, expr):
    """substitute variable i by the polynomial `expr` (same variable count)."""
    out = {}
    for k, v in a.items():
        e = k[i]
        kk = list(k)
        kk[i] = 0
        term = {tuple(kk): v}
        for _ in range(e):
            term = p_mul(term, expr)
        out = p_add(out, term)
    return out


def p_drop(a, drop_idx):
    """drop the (now unused) variables in drop_idx from every exponent tuple."""
    keep = [i for i in range(len(next(iter(a))) if a else 0)
            if i not in drop_idx]
    out = {}
    for k, v in a.items():
        assert all(k[i] == 0 for i in drop_idx), 'variable still present'
        out[tuple(k[i] for i in keep)] = v
    return out


# --------------------------------------------------------------------------
def system(r, lam, orbit_reduce=True):
    """(block, [polys]) with polys = {param_exponent: Kelt}."""
    b = L.Block(r, 1, lam)
    return b, [poly_from_pc(pc)
               for pc in L.equations(b, orbit_reduce=orbit_reduce)]


def dehomogenise(b, polys, var):
    """set parameter `var` := 1.  Returns (names, polys) with var removed."""
    i = b.names.index(var)
    out = [p_setvar(q, i, ONE) for q in polys]
    out = [q for q in out if q]
    names = [n for j, n in enumerate(b.names) if j != i]
    out = [p_drop(q, {i}) for q in out]
    return names, out


def eliminate_linear(names, polys, var):
    """If some polynomial is  c*var + rest  with c a NONZERO CONSTANT in K and
    `rest` free of var, substitute var := -rest/c everywhere.

    This is an exact isomorphism of affine varieties (the graph of a function),
    so it changes neither emptiness nor the geometry -- no saturation.
    """
    i = names.index(var)
    n = len(names)
    zero = tuple([0] * n)
    for q in polys:
        lin, rest, ok = None, {}, True
        for k, v in q.items():
            if k[i] == 0:
                rest[k] = v
            elif k[i] == 1:
                kk = list(k)
                kk[i] = 0
                if tuple(kk) != zero:
                    ok = False
                    break
                lin = v
            else:
                ok = False
                break
        if ok and lin is not None:
            # var = -rest/lin ;  need lin invertible in K: it is a nonzero elt
            expr = p_scal(rest, kinv(lin))
            expr = p_scal(expr, (Fr(-1), Fr(0), Fr(0), Fr(0)))
            out = [p_substitute(q2, i, expr) for q2 in polys]
            out = [q2 for q2 in out if q2]
            out = [p_drop(q2, {i}) for q2 in out]
            nm = [x for j, x in enumerate(names) if j != i]
            return nm, out, (var, expr, names)
    return names, polys, None


def kinv(a):
    """inverse in K = QQ(om)[kp]/(8kp^2-13kp-4); K = QQ(om) + QQ(om) kp."""
    # write a = a0 + a1 kp with a_i in QQ(om); multiply by conjugate
    # (a0 + a1 km) where km = 13/8 - kp, using kp*km = -1/2, kp+km = 13/8.
    a0 = (a[0], a[1])
    a1 = (a[2], a[3])
    # N = (a0+a1 kp)(a0+a1 km) = a0^2 + a0 a1 (kp+km) + a1^2 kp km
    #   = a0^2 + 13/8 a0 a1 - 1/2 a1^2      in QQ(om)
    N = _oadd(_omul(a0, a0),
              _oadd(_oscal(_omul(a0, a1), Fr(13, 8)),
                    _oscal(_omul(a1, a1), Fr(-1, 2))))
    Ni = _oinv(N)
    # conjugate = a0 + a1*km = a0 + a1*(13/8 - kp) = (a0 + 13/8 a1) - a1 kp
    c0 = _oadd(a0, _oscal(a1, Fr(13, 8)))
    c1 = _oscal(a1, Fr(-1))
    c0 = _omul(c0, Ni)
    c1 = _omul(c1, Ni)
    return (c0[0], c0[1], c1[0], c1[1])


def _oadd(a, b):
    return (a[0] + b[0], a[1] + b[1])


def _oscal(a, c):
    return (a[0] * c, a[1] * c)


def _omul(p, q):
    a = p[0] * q[0]
    b = p[0] * q[1] + p[1] * q[0]
    c = p[1] * q[1]
    return (a - c, b - c)


def _oinv(a):
    """inverse in QQ(om), om^2 = -1-om.  N(a0+a1 om) = a0^2 - a0 a1 + a1^2."""
    a0, a1 = a
    N = a0 * a0 - a0 * a1 + a1 * a1
    assert N != 0
    # (a0+a1 om)(a0+a1 om^2) = N ; om^2 = -1-om
    # conj = a0 + a1*om^2 = (a0-a1) - a1 om
    return ((a0 - a1) / N, -a1 / N)


# --------------------------------------------------------------------------
# emitters
# --------------------------------------------------------------------------
def emit_ff(names, polys, p, omp, kpp):
    lines = []
    for q in polys:
        terms = []
        for k, v in sorted(q.items()):
            c = L.kmod_p(v, p, omp, kpp)
            if c == 0:
                continue
            mon = '*'.join('%s^%d' % (names[i], e) if e > 1 else names[i]
                           for i, e in enumerate(k) if e)
            terms.append('%d%s' % (c, '*' + mon if mon else ''))
        if terms:
            lines.append('+'.join(terms))
    return '%s\n%d\n%s\n' % (','.join(names), p, ',\n'.join(lines))


def emit_vars(names, polys, char):
    """om, kp adjoined as extra variables; works for char = 0 or a prime.

    IMPORTANT: msolve's input parser does NOT support parentheses -- it silently
    drops parenthesised groups and returns a wrong Groebner basis (verified: see
    `MSOLVE_PARSER.md`).  Everything is therefore emitted FULLY EXPANDED with
    integer coefficients (denominators cleared per polynomial).
    """
    vs = list(names) + ['om', 'kp']
    lines = []
    for q in polys:
        # expand: coefficient (c0,c1,c2,c3) = c0 + c1 om + c2 kp + c3 om kp
        flat = {}
        for k, v in q.items():
            for ci, extra in ((0, ()), (1, ('om',)), (2, ('kp',)),
                              (3, ('om', 'kp'))):
                if v[ci] == 0:
                    continue
                key = (k, extra)
                flat[key] = flat.get(key, Fr(0)) + v[ci]
        flat = {k: v for k, v in flat.items() if v != 0}
        if not flat:
            continue
        den = 1
        for v in flat.values():
            den = den * v.denominator // _gcd(den, v.denominator)
        terms = []
        for (k, extra), v in sorted(flat.items()):
            c = v * den
            assert c.denominator == 1
            mon = [('%s^%d' % (names[i], e) if e > 1 else names[i])
                   for i, e in enumerate(k) if e] + list(extra)
            terms.append('%s%d%s' % ('+' if c > 0 else '-', abs(c.numerator),
                                     ('*' + '*'.join(mon)) if mon else ''))
        lines.append(''.join(terms).lstrip('+'))
    lines.append('om^2+om+1')
    lines.append('8*kp^2-13*kp-4')
    return '%s\n%d\n%s\n' % (','.join(vs), char, ',\n'.join(lines))


def _gcd(a, b):
    while b:
        a, b = b, a % b
    return a


# --------------------------------------------------------------------------
def find_roots(p):
    """(om, kp) roots mod p, or (None, None) if the prime is not split."""
    om = kp = None
    if p % 3 == 1:
        g = 2
        while pow(g, (p - 1) // 3, p) == 1:
            g += 1
        om = pow(g, (p - 1) // 3, p)
        assert (om * om + om + 1) % p == 0
    d = 297 % p                     # disc of 8x^2-13x-4
    if pow(d, (p - 1) // 2, p) == 1:
        s = tonelli(d, p)
        kp = (13 + s) * pow(16, p - 2, p) % p
        assert (8 * kp * kp - 13 * kp - 4) % p == 0
    return om, kp


def tonelli(n, p):
    if p % 4 == 3:
        return pow(n, (p + 1) // 4, p)
    q, s = p - 1, 0
    while q % 2 == 0:
        q //= 2
        s += 1
    z = 2
    while pow(z, (p - 1) // 2, p) != p - 1:
        z += 1
    m, c, t, R = s, pow(z, q, p), pow(n, q, p), pow(n, (q + 1) // 2, p)
    while t != 1:
        i, t2 = 0, t
        while t2 != 1:
            t2 = t2 * t2 % p
            i += 1
        b = pow(c, 1 << (m - i - 1), p)
        m, c = i, b * b % p
        t = t * c % p
        R = R * b % p
    return R


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
        x = pow(q, d, n)
        if x in (1, n - 1):
            continue
        for _ in range(s - 1):
            x = x * x % n
            if x == n - 1:
                break
        else:
            return False
    return True


def split_primes(lo, count):
    """primes p > lo with both om and kp in F_p (i.e. p splits completely)."""
    out, n = [], lo | 1
    while len(out) < count:
        n += 2
        if not is_prime(n):
            continue
        om, kp = find_roots(n)
        if om is not None and kp is not None:
            out.append(n)
    return out
