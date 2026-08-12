"""Blowup towers over P(W) and their exact order-11 localization terms.

Model (PINNED, see THEOREM.md sec.3 and FLAG-T):
  * blowups at g-fixed POINTS only;
  * a node carries its tangent-weight multiset `tw` (mod 11) and the
    accumulated value weight `vw = d a_k + sum_l mu_l c_l` (Stage-2 Thm 1.2);
  * a node is TERMINAL iff vw is one of the five weights of W (= QR): then
    T is defined there, the value is that eigenpoint of X, and every further
    exceptional fibre over it is contracted to the same value, so its total
    localization mass is already correct;
  * a non-terminal node must be blown up with some mu >= 1.

Repeated tangent weights DO occur from depth 2 on.  Blowing up a node whose
tangent multiset has an eigenvalue c of multiplicity m >= 2 produces a
POSITIVE-DIMENSIONAL fixed component P^{m-1}; its Atiyah-Bott term is the
characteristic-class integral implemented in `ab_component`.  All points of
such a component carry the SAME value weight vw + mu*c.
"""
from fractions import Fraction as Fr

import cyclo as C
import l12core as L

N = 11


# ------------------------------------------------------- truncated h-series
def s_mul(a, b, t):
    out = [C.zero()] * t
    for i, x in enumerate(a):
        if C.is_zero(x):
            continue
        for j, y in enumerate(b):
            if i + j >= t:
                break
            out[i + j] = C.add(out[i + j], C.mul(x, y))
    return out


def s_inv(a, t):
    """Inverse of a series with invertible constant term."""
    inv0 = C.inv(a[0])
    out = [C.zero()] * t
    out[0] = inv0
    for n in range(1, t):
        acc = C.zero()
        for i in range(1, n + 1):
            if i < len(a):
                acc = C.add(acc, C.mul(a[i], out[n - i]))
        out[n] = C.neg(C.mul(inv0, acc))
    return out


def s_exp_scaled(eps, t):
    """series of e^{eps h}, eps = +-1."""
    out = []
    fact = 1
    for n in range(t):
        if n > 0:
            fact *= n
        out.append(C.smul(Fr(eps ** n, fact), C.one()))
    return out


def s_todd(t):
    """h/(1-e^{-h}) as a series, exact rational coefficients."""
    # (1-e^{-h})/h = sum_{n>=0} (-1)^n h^n/(n+1)!
    den = []
    fact = 1
    for n in range(t):
        fact_np1 = 1
        for i in range(1, n + 2):
            fact_np1 *= i
        den.append(C.smul(Fr((-1) ** n, fact_np1), C.one()))
    return s_inv(den, t)


def s_one_minus_u_exp(u, eps, t):
    """series of 1 - u*e^{eps h}."""
    e = s_exp_scaled(eps, t)
    out = [C.neg(C.mul(u, c)) for c in e]
    out[0] = C.add(C.one(), out[0])
    return out


# ------------------------------------------------------------- AB terms
def ab_point(tw):
    """Isolated fixed point: 1/det(1-dg^{-1}|T) = 1/prod(1-zeta^{-w})."""
    return C.inv(C.prod([C.one_minus_zpow(-w) for w in tw]))


def ab_component(parent_tw, c):
    """P^{m-1} component of the exceptional divisor of the blowup at a point
    with tangent multiset `parent_tw`, for the eigenvalue c of multiplicity m.

    Y = P(V_c) = P^{m-1};  N_{E/Bl}|_Y = O(-1) with g-weight c;
    N_{Y/E} = O(1) tensor (T/V_c), summands of weight w-c, Chern root h.
    contribution = int_Y td(T_Y) / [(1-z^{-c}e^{h}) prod_{w != c}(1-z^{-(w-c)}e^{-h})].
    """
    m = sum(1 for w in parent_tw if w % N == c % N)
    t = m  # need coefficient of h^{m-1}
    num = [C.one()] + [C.zero()] * (t - 1)
    td = s_todd(t)
    for _ in range(m):
        num = s_mul(num, td, t)
    den = s_one_minus_u_exp(C.zpow(-c), +1, t)
    for w in parent_tw:
        if w % N == c % N:
            continue
        den = s_mul(den, s_one_minus_u_exp(C.zpow(-(w - c)), -1, t), t)
    ser = s_mul(num, s_inv(den, t), t)
    return ser[m - 1]


# ------------------------------------------------------------------- sites
class Site:
    """A connected component of the g-fixed locus, with its value weight.

    kind 'pt'   : isolated point,   data = tangent multiset
    kind 'comp' : P^{m-1},          data = (parent tangent multiset, c)
    """

    __slots__ = ("kind", "data", "vw", "chain")

    def __init__(self, kind, data, vw, chain):
        self.kind = kind
        self.data = data
        self.vw = vw % N
        self.chain = chain

    def defined(self):
        return self.vw in L.QR

    def term(self):
        if self.kind == "pt":
            return ab_point(self.data)
        return ab_component(self.data[0], self.data[1])

    def scaled(self, s):
        """The N_G(C11)-translate: every weight multiplied by s in QR."""
        if self.kind == "pt":
            return Site("pt", tuple((s * w) % N for w in self.data),
                        (s * self.vw) % N, self.chain)
        pw, c = self.data
        return Site("comp", (tuple((s * w) % N for w in pw), (s * c) % N),
                    (s * self.vw) % N, self.chain)


def blowup(site, mu):
    """Blow up an isolated fixed point; returns the fixed components above it."""
    assert site.kind == "pt", "cannot point-blow-up a positive-dimensional site"
    tw = site.data
    out = []
    seen = set()
    for c in tw:
        if c in seen:
            continue
        seen.add(c)
        m = sum(1 for w in tw if w == c)
        vw = (site.vw + mu * c) % N
        ch = site.chain + (c,)
        if m == 1:
            rest = tuple((w - c) % N for w in tw if w != c)
            out.append(Site("pt", (c,) + rest, vw, ch))
        else:
            out.append(Site("comp", (tw, c), vw, ch))
    return out


def mass(sites):
    return C.total([s.term() for s in sites])
