"""Exact arithmetic in the number field K = Q(sqrt(33), sqrt(-3)).

Faithful Q-basis (1, r, i, r*i) with r = sqrt(33), i = sqrt(-3), so r*i = sqrt(-99).
[K:Q] = 4 because 33 > 0 and -3 < 0 (so sqrt(-3) is not in the real field Q(sqrt(33))).

Coefficients are sympy Rational, so every operation below is exact; zero-testing is
component-wise equality of four rationals, with no simplify() heuristics involved.
"""
from sympy import Rational, sqrt, nsimplify, Integer

R33, IM3 = 33, -3  # r^2 = 33, i^2 = -3, (r*i)^2 = -99


class KE:
    __slots__ = ("c",)

    def __init__(self, c0=0, c1=0, c2=0, c3=0):
        self.c = (Rational(c0), Rational(c1), Rational(c2), Rational(c3))

    # --- constructors -------------------------------------------------
    @staticmethod
    def rat(q):
        return KE(q, 0, 0, 0)

    @staticmethod
    def r():          # sqrt(33)
        return KE(0, 1, 0, 0)

    @staticmethod
    def i():          # sqrt(-3)
        return KE(0, 0, 1, 0)

    # --- ring ops -----------------------------------------------------
    def __add__(self, o):
        o = _co(o)
        return KE(*[a + b for a, b in zip(self.c, o.c)])

    __radd__ = __add__

    def __neg__(self):
        return KE(*[-a for a in self.c])

    def __sub__(self, o):
        return self + (-_co(o))

    def __rsub__(self, o):
        return _co(o) + (-self)

    def __mul__(self, o):
        o = _co(o)
        a0, a1, a2, a3 = self.c
        b0, b1, b2, b3 = o.c
        return KE(
            a0*b0 + 33*a1*b1 - 3*a2*b2 - 99*a3*b3,
            a0*b1 + a1*b0 - 3*(a2*b3 + a3*b2),
            a0*b2 + a2*b0 + 33*(a1*b3 + a3*b1),
            a0*b3 + a3*b0 + a1*b2 + a2*b1,
        )

    __rmul__ = __mul__

    def inv(self):
        """z = A + B*r with A, B in Q(i); invert via the r-conjugate then the i-conjugate."""
        if self.is_zero():
            raise ZeroDivisionError("inverse of 0 in K")
        a0, a1, a2, a3 = self.c
        # A = a0 + a2 i, B = a1 + a3 i ; N = A^2 - 33 B^2 in Q(i)
        p = a0*a0 - 3*a2*a2 - 33*(a1*a1 - 3*a3*a3)
        q = 2*a0*a2 - 33*(2*a1*a3)
        # (A - B r) / N, then multiply by conj_i(N)/|N|^2 with N = p + q i, i^2 = -3
        d = p*p + 3*q*q
        # numerator A - B r  =  (a0 + a2 i) - (a1 + a3 i) r
        num = KE(a0, -a1, a2, -a3)
        # times (p - q i)
        num = num * KE(p, 0, -q, 0)
        return KE(*[x / d for x in num.c])

    def __truediv__(self, o):
        return self * _co(o).inv()

    def __rtruediv__(self, o):
        return _co(o) * self.inv()

    def __pow__(self, n):
        assert isinstance(n, int) and n >= 0
        out, base = KE(1), self
        while n:
            if n & 1:
                out = out * base
            base = base * base
            n >>= 1
        return out

    # --- predicates / output -----------------------------------------
    def is_zero(self):
        return all(x == 0 for x in self.c)

    def is_rat(self):
        return self.c[1] == 0 and self.c[2] == 0 and self.c[3] == 0

    def __eq__(self, o):
        return self.c == _co(o).c

    def __hash__(self):
        return hash(self.c)

    def to_sympy(self):
        a0, a1, a2, a3 = self.c
        return a0 + a1*sqrt(33) + a2*sqrt(-3) + a3*sqrt(33)*sqrt(-3)

    def __repr__(self):
        a0, a1, a2, a3 = self.c
        return f"({a0}) + ({a1})*sqrt(33) + ({a2})*sqrt(-3) + ({a3})*sqrt(33)*sqrt(-3)"

    def n(self, prec=50):
        from sympy import N
        return complex(N(self.to_sympy(), prec))


def _co(o):
    return o if isinstance(o, KE) else KE(o)


# ---------------------------------------------------------------------
# dense univariate polynomials over K, coeffs[k] = coefficient of x^k
# ---------------------------------------------------------------------
def p_trim(p):
    p = list(p)
    while len(p) > 1 and p[-1].is_zero():
        p.pop()
    return p


def p_add(p, q):
    n = max(len(p), len(q))
    return p_trim([(p[k] if k < len(p) else KE(0)) + (q[k] if k < len(q) else KE(0))
                   for k in range(n)])


def p_scal(c, p):
    c = _co(c)
    return p_trim([c * a for a in p])


def p_sub(p, q):
    return p_add(p, p_scal(-1, q))


def p_mul(p, q):
    out = [KE(0)] * (len(p) + len(q) - 1)
    for i, a in enumerate(p):
        if a.is_zero():
            continue
        for j, b in enumerate(q):
            out[i + j] = out[i + j] + a * b
    return p_trim(out)


def p_pow(p, n):
    out = [KE(1)]
    for _ in range(n):
        out = p_mul(out, p)
    return out


def p_eval(p, x):
    x = _co(x)
    acc = KE(0)
    for a in reversed(p):
        acc = acc * x + a
    return acc


def p_deg(p):
    p = p_trim(p)
    return -1 if (len(p) == 1 and p[0].is_zero()) else len(p) - 1


def p_divmod(p, q):
    """Exact division with remainder over the field K."""
    p = p_trim(list(p)); q = p_trim(list(q))
    if p_deg(q) < 0:
        raise ZeroDivisionError
    quot = [KE(0)] * max(1, p_deg(p) - p_deg(q) + 1)
    lead = q[-1]
    while p_deg(p) >= p_deg(q) and p_deg(p) >= 0:
        d = p_deg(p) - p_deg(q)
        c = p[-1] / lead
        quot[d] = quot[d] + c
        p = p_sub(p, p_mul([KE(0)] * d + [c], q))
    return p_trim(quot), p_trim(p)


def p_gcd(p, q):
    p, q = p_trim(list(p)), p_trim(list(q))
    while p_deg(q) >= 0:
        p, q = q, p_divmod(p, q)[1]
    if p_deg(p) >= 0:
        p = p_scal(p[-1].inv(), p)   # monic
    return p


def p_deriv(p):
    return p_trim([KE(k) * p[k] for k in range(1, len(p))] or [KE(0)])


def p_resultant(p, q):
    """Resultant via the Euclidean/subresultant-free recursion (field arithmetic)."""
    p, q = p_trim(list(p)), p_trim(list(q))
    dp, dq = p_deg(p), p_deg(q)
    if dp < 0 or dq < 0:
        return KE(0)
    if dq == 0:
        return q[0] ** dp
    _, r = p_divmod(p, q)
    dr = p_deg(r)
    if dr < 0:
        return KE(0)
    sign = KE((-1) ** (dp * dq))
    return sign * (q[-1] ** (dp - dr)) * p_resultant(q, r)


def p_disc(p):
    d = p_deg(p)
    res = p_resultant(p, p_deriv(p))
    return KE((-1) ** (d * (d - 1) // 2)) * res / p[-1]
