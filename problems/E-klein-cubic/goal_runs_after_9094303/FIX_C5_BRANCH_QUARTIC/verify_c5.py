#!/usr/bin/env python3
"""FIX-C5 INDEPENDENT VERIFIER.

Fully self-contained.  It implements

  * its own exact number field  K = Q(om, nu),  om^2+om+1 = 0, nu^2 = -11
    (degree 4 over Q, basis 1, om, nu, om*nu) -- no sympy, no klein_exact,
    no group theory, no floating point in any decision;
  * its own quadratic extensions K(rho), rho^2 = d, for the four "new" lines;
  * its own sparse multivariate polynomial arithmetic.

and then re-derives, by ROUTES DIFFERENT FROM THE PRODUCER'S, every structural
claim of the packet:

  producer                                   verifier
  --------                                   --------
  sympy expressions reduced mod a Groebner   hand-built exact K-arithmetic
  basis {om^2+om+1, nu^2+11, ...}
  Delta_v from the sec.5.19 (s,t) binary     Delta_v from the "F is a quadratic
  cubic, cross-checked against the           in the eliminated slot x" route,
  quadratic-in-x route                       cross-checked against a THIRD route
                                             (the resultant Res_x(F, dF/dx))
  Sing by an 8-case split written in sympy   the same case split re-derived from
                                             scratch in K-arithmetic, PLUS an
                                             independent NONSQUARE proof that the
                                             two degree-2 components are K-prime
  irreducibility by sympy factor_list        Lemma C5-I applied to dim Sing = 0
  55-membership by PSL(2,11)                 (not re-done: needs the group; the
                                             producer's enumeration is complete)

Exit line:  FIX_C5_VERIFY_OK   (or an AssertionError).
"""
import json
import os
import sys
import time
from fractions import Fraction as F

HERE = os.path.dirname(os.path.abspath(__file__))
T0 = time.time()
LOG = []
NCHK = [0]


def log(s=''):
    print(s, flush=True)
    LOG.append(s)


def check(cond, msg):
    NCHK[0] += 1
    if not cond:
        raise AssertionError('CHECK FAILED: ' + msg)
    return cond


# ============================================================ the field Q(om,nu)
#   basis e0 = 1, e1 = om, e2 = nu, e3 = om*nu
_MT = {
    (0, 0): {0: 1}, (0, 1): {1: 1}, (0, 2): {2: 1}, (0, 3): {3: 1},
    (1, 1): {0: -1, 1: -1},           # om^2 = -1-om
    (1, 2): {3: 1},                   # om*nu
    (1, 3): {2: -1, 3: -1},           # om^2 nu = -nu - om nu
    (2, 2): {0: -11},                 # nu^2
    (2, 3): {1: -11},                 # nu^2 om
    (3, 3): {0: 11, 1: 11},           # om^2 nu^2 = 11 + 11 om
}
for (i, j), vv in list(_MT.items()):
    _MT[(j, i)] = vv


class K:
    """exact element of Q(om,nu) = c0 + c1 om + c2 nu + c3 om nu."""
    __slots__ = ('c',)

    def __init__(self, c=(0, 0, 0, 0)):
        self.c = tuple(F(u) for u in c)

    @staticmethod
    def rat(p, q=1):
        return K((F(p, q), 0, 0, 0))

    def is_zero(self):
        return all(u == 0 for u in self.c)

    def __bool__(self):
        return not self.is_zero()

    def __eq__(self, o):
        if isinstance(o, int):
            o = K.rat(o)
        return self.c == o.c

    def __hash__(self):
        return hash(self.c)

    def __neg__(self):
        return K(tuple(-u for u in self.c))

    def __add__(self, o):
        if isinstance(o, int):
            o = K.rat(o)
        return K(tuple(p + q for p, q in zip(self.c, o.c)))

    __radd__ = __add__

    def __sub__(self, o):
        if isinstance(o, int):
            o = K.rat(o)
        return K(tuple(p - q for p, q in zip(self.c, o.c)))

    def __rsub__(self, o):
        return (-self) + o

    def __mul__(self, o):
        if isinstance(o, int):
            o = K.rat(o)
        if isinstance(o, F):
            return K(tuple(u * o for u in self.c))
        out = [F(0)] * 4
        for i, ci in enumerate(self.c):
            if ci == 0:
                continue
            for j, cj in enumerate(o.c):
                if cj == 0:
                    continue
                for kk, co in _MT[(i, j)].items():
                    out[kk] += ci * cj * co
        return K(out)

    __rmul__ = __mul__

    def conj(self, i, j):
        """om -> om^2 if i ; nu -> -nu if j."""
        c0, c1, c2, c3 = self.c
        if i:                      # om -> -1-om ;  om nu -> (-1-om) nu
            c0, c1 = c0 - c1, -c1
            c2, c3 = c2 - c3, -c3
        if j:
            c2, c3 = -c2, -c3
        return K((c0, c1, c2, c3))

    def inv(self):
        co = self.conj(0, 1) * self.conj(1, 0) * self.conj(1, 1)
        n = self * co
        assert n.c[1] == 0 and n.c[2] == 0 and n.c[3] == 0 and n.c[0] != 0, \
            'norm is not a nonzero rational'
        return K(tuple(u / n.c[0] for u in co.c))

    def __truediv__(self, o):
        if isinstance(o, int):
            o = K.rat(o)
        return self * o.inv()

    def __pow__(self, e):
        r, s = K.rat(1), self
        while e:
            if e & 1:
                r = r * s
            s = s * s
            e >>= 1
        return r

    def __repr__(self):
        nm = ['', 'om', 'nu', 'om*nu']
        parts = []
        for i, u in enumerate(self.c):
            if u == 0:
                continue
            if i == 0:
                parts.append(str(u))
            else:
                parts.append(('%s*%s' % (u, nm[i])) if u != 1 else nm[i])
        return ' + '.join(parts) if parts else '0'


K0, K1 = K.rat(0), K.rat(1)
OM = K((0, 1, 0, 0))
NU = K((0, 0, 1, 0))
OM2 = K.rat(-1) - OM
DELTA = K.rat(2) * OM + K1                 # om - om^2
S33 = -(NU * DELTA)                        # FIX-L1 sign convention
KP = (K.rat(13) + K.rat(3) * S33) / K.rat(16)
KM = (K.rat(13) - K.rat(3) * S33) / K.rat(16)


# ============================================== quadratic extension K(rho), rho^2 = d
class QE:
    """u + v*rho with rho^2 = d (d a K-element fixed per class instance)."""
    __slots__ = ('u', 'v', 'd')

    def __init__(self, u, v, d):
        self.u, self.v, self.d = u, v, d

    @staticmethod
    def lift(u, d):
        return QE(u if isinstance(u, K) else K.rat(u), K0, d)

    def is_zero(self):
        return self.u.is_zero() and self.v.is_zero()

    def __bool__(self):
        return not self.is_zero()

    def __eq__(self, o):
        if isinstance(o, int):
            o = QE.lift(o, self.d)
        return self.u == o.u and self.v == o.v

    def __neg__(self):
        return QE(-self.u, -self.v, self.d)

    def _co(self, o):
        if isinstance(o, (int, K)):
            return QE.lift(o, self.d)
        return o

    def __add__(self, o):
        o = self._co(o)
        return QE(self.u + o.u, self.v + o.v, self.d)

    __radd__ = __add__

    def __sub__(self, o):
        o = self._co(o)
        return QE(self.u - o.u, self.v - o.v, self.d)

    def __rsub__(self, o):
        return (-self) + o

    def __mul__(self, o):
        o = self._co(o)
        return QE(self.u * o.u + self.v * o.v * self.d,
                  self.u * o.v + self.v * o.u, self.d)

    __rmul__ = __mul__

    def __pow__(self, e):
        r = QE.lift(1, self.d)
        s = self
        while e:
            if e & 1:
                r = r * s
            s = s * s
            e >>= 1
        return r

    def __repr__(self):
        return '(%s) + (%s)rho' % (self.u, self.v)


# ================================================ sparse multivariate polynomials
class P:
    """sparse polynomial: dict exponent-tuple -> coefficient (K or QE)."""
    __slots__ = ('n', 't')

    def __init__(self, n, t=None):
        self.n = n
        self.t = {}
        if t:
            for e, c in t.items():
                if not (c.is_zero() if hasattr(c, 'is_zero') else c == 0):
                    self.t[e] = c

    @staticmethod
    def const(n, c):
        return P(n, {(0,) * n: c})

    @staticmethod
    def var(n, i, one):
        e = [0] * n
        e[i] = 1
        return P(n, {tuple(e): one})

    def is_zero(self):
        return not self.t

    def __eq__(self, o):
        return (self - o).is_zero()

    def __neg__(self):
        return P(self.n, {e: -c for e, c in self.t.items()})

    def __add__(self, o):
        out = dict(self.t)
        for e, c in o.t.items():
            out[e] = out.get(e, c * 0) + c if e in out else c
        return P(self.n, out)

    def __sub__(self, o):
        return self + (-o)

    def __mul__(self, o):
        out = {}
        for e1, c1 in self.t.items():
            for e2, c2 in o.t.items():
                e = tuple(u + v for u, v in zip(e1, e2))
                out[e] = out[e] + c1 * c2 if e in out else c1 * c2
        return P(self.n, out)

    def scal(self, c):
        return P(self.n, {e: cc * c for e, cc in self.t.items()})

    def __pow__(self, k):
        assert k >= 1, 'P.__pow__ requires k >= 1'
        r, s = self, self
        k -= 1
        while k:
            r = r * s
            k -= 1
        return r

    def coeff_in(self, i, deg):
        """coefficient of var_i^deg, as a polynomial in the other variables."""
        out = {}
        for e, c in self.t.items():
            if e[i] == deg:
                e2 = list(e)
                e2[i] = 0
                out[tuple(e2)] = c
        return P(self.n, out)

    def deg_in(self, i):
        return max((e[i] for e in self.t), default=-1)

    def total_degree(self):
        return max((sum(e) for e in self.t), default=-1)

    def subs_const(self, vals):
        """substitute constants (or None to keep) for variables; returns P."""
        out = P(self.n, {})
        for e, c in self.t.items():
            cc = c
            e2 = list(e)
            for i, val in enumerate(vals):
                if val is None:
                    continue
                for _ in range(e[i]):
                    cc = cc * val
                e2[i] = 0
            out = out + P(self.n, {tuple(e2): cc})
        return out

    def diff(self, i):
        out = {}
        for e, c in self.t.items():
            if e[i] == 0:
                continue
            e2 = list(e)
            e2[i] -= 1
            out[tuple(e2)] = c * e[i]
        return P(self.n, out)

    def eval_all(self, vals, zero=None):
        acc = zero
        for e, c in self.t.items():
            term = c
            for i, val in enumerate(vals):
                for _ in range(e[i]):
                    term = term * val
            acc = term if acc is None else acc + term
        if acc is None:
            acc = vals[0] * 0
        return acc


# ===================================================================== the setup
NV = 5                      # a, b, x, y, z
IA, IB, IX, IY, IZ = range(5)


def mkvars(n, one):
    return [P.var(n, i, one) for i in range(n)]


def build_F(one, kp, km, cxyz):
    a, b, x, y, z = mkvars(5, one)
    C = (a**3).scal(kp) + (b**3).scal(km)
    Q1 = a + b
    Q2 = a.scal(lift(OM, one)) + b.scal(lift(OM2, one))
    Q3 = a.scal(lift(OM2, one)) + b.scal(lift(OM, one))
    Fq = C + Q1 * x * x + Q2 * y * y + Q3 * z * z + (x * y * z).scal(cxyz)
    return Fq, C, Q1, Q2, Q3


def lift(c, one):
    """lift a K-element into the coefficient ring of `one`."""
    if isinstance(one, QE):
        return QE.lift(c, one.d)
    return c


# ============================================================== rational sqrt test
def is_rational_square(q):
    if q < 0:
        return False
    n, d = q.numerator, q.denominator
    rn, rd = _isqrt(n), _isqrt(d)
    return rn is not None and rd is not None


def _isqrt(n):
    if n < 0:
        return None
    r = int(n ** 0.5)
    for cand in range(max(0, r - 2), r + 3):
        if cand * cand == n:
            return cand
    # exact fallback for large n
    lo, hi = 0, n + 1
    while lo < hi:
        mid = (lo + hi) // 2
        if mid * mid < n:
            lo = mid + 1
        else:
            hi = mid
    return lo if lo * lo == n else None


def square_in_Qnu(p, q):
    """is p + q*nu a square in Q(nu), nu^2 = -11?  p,q rational.  Exact."""
    if q == 0:
        # need P0^2 - 11 P1^2 = p with 2 P0 P1 = 0
        return is_rational_square(p) or is_rational_square(F(-p, 11))
    # 2 P0 P1 = q, P0^2 - 11 P1^2 = p  =>  44 u^2 + 4 p u - q^2 = 0, u = P1^2
    disc = 16 * p * p + 176 * q * q
    if not is_rational_square(F(disc)):
        return False
    sq = F(_isqrt(F(disc).numerator), _isqrt(F(disc).denominator))
    for sgn in (1, -1):
        u = (-4 * p + sgn * sq) / 88
        if u > 0 and is_rational_square(u):
            return True
    return False


def square_in_K(c):
    """is the K-element c a square in K?   K = Q(nu)(delta), delta^2 = -3.
       c = A + B delta ; k = Pp + Qq delta ; k^2 = Pp^2-3Qq^2 + 2 Pp Qq delta.
       We only need (and only support) the case B = 0."""
    c0, c1, c2, c3 = c.c
    A = (c0 - F(c1, 2), c2 - F(c3, 2))          # A = A0 + A1 nu
    B = (F(c1, 2), F(c3, 2))                    # B = B0 + B1 nu
    assert B == (0, 0), 'square_in_K: only implemented for B = 0'
    #   2 Pp Qq = 0  ->  Qq = 0 (then Pp^2 = A) or Pp = 0 (then -3 Qq^2 = A)
    return square_in_Qnu(A[0], A[1]) or square_in_Qnu(F(-A[0], 3), F(-A[1], 3))


# =============================================================================
def main():
    log('# FIX-C5 INDEPENDENT VERIFIER -- branch quartic Delta_v')
    log('# packet goal_runs_after_9094303/FIX_C5_BRANCH_QUARTIC')
    log('# own exact K = Q(om,nu); no sympy, no group theory, no floating point')
    log('')

    # ------------------------------------------------------------- 0. SELF-TEST
    log('== 0.  self-test of the verifier\'s own machinery ==')
    #   (a) the harness really fails on a false statement
    try:
        check(K1 == K0, 'SELF-TEST: this must fail')
        raise RuntimeError('SELF-TEST DID NOT FIRE')
    except AssertionError:
        NCHK[0] -= 1                      # do not count the deliberate failure
        log('   check() fires on a false statement                          PASS')
    #   (b) field arithmetic: (om+nu)^2, inversion, conjugation
    u = OM + NU
    check(u * u == OM * OM + K.rat(2) * OM * NU + NU * NU, 'K: (om+nu)^2 expands')
    check(u * u.inv() == K1, 'K: inversion')
    check(u.conj(1, 1).conj(1, 1) == u, 'K: conjugation is an involution')
    check((u * u).conj(1, 0) == u.conj(1, 0) * u.conj(1, 0), 'K: conj is multiplicative')
    #   (c) quadratic-extension arithmetic
    rr = QE(K0, K1, NU)
    check(rr * rr == QE.lift(NU, NU), 'QE: rho^2 = d')
    check((rr + QE.lift(K1, NU))**2
          == rr * rr + rr * QE.lift(K.rat(2), NU) + QE.lift(K1, NU), 'QE: binomial')
    #   (d) polynomial arithmetic: (p+q)^3 and differentiation
    pv, qv = P.var(2, 0, K1), P.var(2, 1, K1)
    cube = (pv + qv)**3
    check(cube == pv**3 + (pv**2 * qv).scal(K.rat(3))
          + (pv * qv**2).scal(K.rat(3)) + qv**3, 'P: (p+q)^3')
    check(cube.diff(0) == ((pv + qv)**2).scal(K.rat(3)), 'P: d/dp (p+q)^3')
    check(cube.eval_all([K1, K1]) == K.rat(8), 'P: evaluation')
    check((pv * qv - qv * pv).is_zero(), 'P: multiplication commutes')
    #   (e) the rational/number-field square tests behave
    check(is_rational_square(F(49, 25)) and not is_rational_square(F(2)),
          'is_rational_square controls')
    log('   field, quadratic-extension and polynomial arithmetic self-tests PASS')

    # ---------------------------------------------------------- 1. the field
    log('')
    log('== 1.  the field K = Q(om,nu), and the frame constants ==')
    check(OM * OM + OM + K1 == K0, 'om^2+om+1 = 0')
    check(NU * NU + K.rat(11) == K0, 'nu^2 = -11')
    check(DELTA * DELTA + K.rat(3) == K0, 'delta^2 = -3')
    check(S33 * S33 - K.rat(33) == K0, 'sqrt33^2 = 33')
    check(OM2 == OM * OM, 'om^2 bookkeeping')
    check(KP + KM == K.rat(13, 8), 'kp + km = 13/8')
    check(KP * KM == K.rat(-1, 2), 'kp*km = -1/2')
    check(KP * KP * K.rat(8) - KP * K.rat(13) - K.rat(4) == K0,
          '8 kp^2 - 13 kp - 4 = 0')
    check(KP - KM == S33 * K.rat(3, 8), 'kp - km = 3 sqrt33/8')
    check((KP * K.rat(4)).inv() * (KP * K.rat(4)) == K1, 'inversion works')
    #  FIX-L1 regressions (frame-independent identities of its sec.3)
    C_CHEB = (K.rat(3) + S33) / K.rat(4)
    ALPHA = K.rat(9) + K.rat(3) * S33
    check(ALPHA == C_CHEB * K.rat(12), 'FIX-L1: alpha = 12 c_cheb')
    check(ALPHA == KP * K.rat(16) - K.rat(4), 'FIX-L1: alpha = 16 kp - 4')
    check(C_CHEB**3 == KP + KM * (-(K.rat(7) + S33) / K.rat(4))**3,
          'FIX-L1: F(c_sigma) = c_cheb^3')
    log('   om^2+om+1 = 0, nu^2 = -11, delta = 2om+1, sqrt33 = -nu*delta : PASS')
    log('   kp = (13+3 sqrt33)/16, km = (13-3 sqrt33)/16 ; kp+km = 13/8, kp km = -1/2')
    log('   FIX-L1 regressions alpha = 12 c_cheb = 16 kp - 4 and F(c_sigma) = c_cheb^3 : PASS')

    # -------------------------------------------- 2. F, the vertex, and Delta_v
    log('')
    log('== 2.  F, the chi_1-vertex, and Delta_v by three routes ==')
    Fq, C, Q1, Q2, Q3 = build_F(K1, KP, KM, K1)
    a, b, x, y, z = mkvars(5, K1)
    check(Fq.eval_all([K0, K0, K1, K0, K0]) == K0, 'F(v) = 0 : v = E_x lies on X')
    log('   F(v) = 0 for v = [0:0:1:0:0]   (no x^3 monomial)              PASS')

    #   V4-invariance of F
    V4 = [(1, 1, 1), (1, -1, -1), (-1, 1, -1), (-1, -1, 1)]
    for e1, e2, e3 in V4:
        g = P(5, {})
        for e, c in Fq.t.items():
            sgn = (e1 ** e[IX]) * (e2 ** e[IY]) * (e3 ** e[IZ])
            g = g + P(5, {e: c * sgn})
        check(g == Fq, 'F invariant under V4 element %s' % (e1, ))
    log('   F is invariant under all four V4 sign patterns                PASS')

    #   route (a): F as a quadratic in x
    e2c = Fq.coeff_in(IX, 2)
    e1c = Fq.coeff_in(IX, 1)
    e0c = Fq.coeff_in(IX, 0)
    check(Fq.deg_in(IX) == 2, 'F is quadratic in the eliminated coordinate')
    check(e2c == Q1, 'leading coefficient is Q1')
    check(e1c == y * z, 'middle coefficient is c yz')
    check(e0c == C + Q2 * y * y + Q3 * z * z, 'constant coefficient')
    Da = e1c * e1c - (e2c * e0c).scal(K.rat(4))
    log('   route (a): F = Q1 x^2 + (c yz) x + [C + Q2 y^2 + Q3 z^2]      PASS')

    #   route (b): the sec.5.19 binary cubic in (s,t) with x' free.
    #   variables here: a,b,xp,y,z,s,t  (7)
    aa, bb, xpv, yy, zz, ss, tt = mkvars(7, K1)
    C7 = aa**3 * P.const(7, KP) + bb**3 * P.const(7, KM)
    Q17, Q27, Q37 = aa + bb, aa.scal(OM) + bb.scal(OM2), aa.scal(OM2) + bb.scal(OM)
    #   substitute (a,b,x,y,z) -> (t a, t b, s + t x', t y, t z)
    #   substitute (a,b,x,y,z) -> (t a, t b, s + t x', t y, t z) into F, using that
    #   C is cubic and Q1,Q2,Q3 are linear in (a,b):
    Fsub = (C7 * tt**3
            + Q17 * tt * (ss + tt * xpv)**2
            + Q27 * tt * (tt * yy)**2 + Q37 * tt * (tt * zz)**2
            + (ss + tt * xpv) * (tt * yy) * (tt * zz))
    c3 = Fsub.coeff_in(5, 3)
    c2 = Fsub.coeff_in(5, 2)
    c1 = Fsub.coeff_in(5, 1)
    c0 = Fsub.coeff_in(5, 0)
    check(c3.is_zero(), 'binary cubic has no s^3 term')
    check(c2 == Q17 * tt, 'sec.5.19: ell = Q1')
    check(c1 == (Q17 * xpv).scal(K.rat(2)) * tt**2 + (yy * zz) * tt**2,
          "sec.5.19: q = 2 Q1 x' + c yz")
    check(c0 == (C7 + Q17 * xpv**2 + Q27 * yy**2 + Q37 * zz**2 + xpv * yy * zz) * tt**3,
          "sec.5.19: k = C + Q1 x'^2 + Q2 y^2 + Q3 z^2 + c x' yz")
    ellp = Q17
    qp = (Q17 * xpv).scal(K.rat(2)) + yy * zz
    kp7 = C7 + Q17 * xpv**2 + Q27 * yy**2 + Q37 * zz**2 + xpv * yy * zz
    Db = qp * qp - (ellp * kp7).scal(K.rat(4))
    check(Db.deg_in(2) <= 0, "x' cancels from q^2 - 4 ell k")
    log("   route (b): sec.5.19's (ell, q, k) reproduced; x'-cancellation   PASS")

    #   compare (a) and (b) after dropping x' :  map (a,b,xp,y,z,s,t)->(a,b,y,z)
    def drop(p7):
        out = {}
        for e, c in p7.t.items():
            check(e[2] == 0 and e[5] == 0 and e[6] == 0, 'stray variable')
            out[(e[0], e[1], 0, e[3], e[4])] = c
        return P(5, out)

    check(drop(Db) == Da, 'route (a) == route (b)')
    log('   routes (a) and (b) give the SAME Delta_v                       PASS')

    #   route (c): the SYLVESTER RESULTANT Res_x(F, dF/dx) -- a third bookkeeping.
    #   f = A x^2 + B x + C0 , g = 2A x + B ; Sylvester matrix (3x3)
    #        [ A   B   C0 ]
    #        [ 2A  B   0  ]
    #        [ 0   2A  B  ]     with determinant  -A (B^2 - 4 A C0) .
    dFdx = Fq.diff(IX)
    check(dFdx == e2c.scal(K.rat(2)) * x + e1c, 'dF/dx = 2 Q1 x + c yz')
    A_, B_, C_ = e2c, e1c, e0c
    Z_ = P(5, {})
    M = [[A_, B_, C_], [A_.scal(K.rat(2)), B_, Z_], [Z_, A_.scal(K.rat(2)), B_]]
    det = (M[0][0] * (M[1][1] * M[2][2] - M[1][2] * M[2][1])
           - M[0][1] * (M[1][0] * M[2][2] - M[1][2] * M[2][0])
           + M[0][2] * (M[1][0] * M[2][1] - M[1][1] * M[2][0]))
    check(det == (A_ * Da).scal(K.rat(-1)),
          'route (c): Res_x(F, dF/dx) = -Q1 * Delta_v')
    log('   route (c): Sylvester Res_x(F, dF/dx) = -Q1 * Delta_v            PASS')
    #   closed form
    Dclosed = y * y * z * z - (Q1 * (Q2 * y * y + Q3 * z * z + C)).scal(K.rat(4))
    check(Da == Dclosed, 'sec.5.19 CLOSED FORM for Delta_v')
    log('   Delta_v = c^2 y^2 z^2 - 4 Q1 (Q2 y^2 + Q3 z^2 + C)             PASS')
    check(Da.total_degree() == 4, 'Delta_v is a quartic')

    #   Delta_v mod Q1 : substitute a = -b
    Dm = P(5, {})
    for e, c in Da.t.items():
        e2 = (0, e[1] + e[0], 0, e[3], e[4])
        cc = c * K.rat((-1) ** e[0])
        Dm = Dm + P(5, {e2: cc})
    check(Dm == y * y * z * z, 'Delta_v == (c y z)^2  mod Q1')
    log('   Delta_v == (c y z)^2 modulo Q1                                 PASS')

    #   V4-invariance / character of Delta_v
    for e1, e2, e3 in V4:
        g = P(5, {})
        for e, c in Da.t.items():
            g = g + P(5, {e: c * ((e2 ** e[IY]) * (e3 ** e[IZ]))})
        check(g == Da, 'Delta_v is V4-invariant')
    check(all(e[IY] % 2 == 0 and e[IZ] % 2 == 0 for e in Da.t),
          'every monomial of Delta_v is even in y and in z (character chi_0)')
    log('   Delta_v is V4-invariant, character chi_0                       PASS')

    #   Galois action
    for (i, j), sw in [((1, 0), 'ab'), ((0, 1), 'abyz'), ((1, 1), 'yz')]:
        Dg = P(5, {e: c.conj(i, j) for e, c in Da.t.items()})
        out = {}
        for e, c in Da.t.items():
            ea, eb, ex, ey, ez = e
            if 'ab' in sw:
                ea, eb = eb, ea
            if 'yz' in sw:
                ey, ez = ez, ey
            out[(ea, eb, ex, ey, ez)] = c
        check(Dg == P(5, out), 'Galois (%d,%d) acts as the swap %s' % (i, j, sw))
    log('   Gal(K/Q) acts on Delta_v by the coordinate swaps (a b), (y z)  PASS')

    # ------------------------------------------------------ 3. the line census
    log('')
    log('== 3.  the census of lines of X through v ==')
    #   incidence: Q1 = 0, yz = 0, C + Q2 y^2 + Q3 z^2 = 0
    #   on b = -a :  Q2 = delta a , Q3 = -delta a , C = (kp-km) a^3
    check(Q2.eval_all([K1, -K1, K0, K0, K0]) == DELTA, 'Q2 on Q1 = 0')
    check(Q3.eval_all([K1, -K1, K0, K0, K0]) == -DELTA, 'Q3 on Q1 = 0')
    check(C.eval_all([K1, -K1, K0, K0, K0]) == KP - KM, 'C on Q1 = 0')
    dy2 = (KM - KP) / DELTA            # y^2 when z = 0, a = 1, b = -1
    dz2 = (KP - KM) / DELTA            # z^2 when y = 0, a = 1, b = -1
    check(dy2 == NU * K.rat(3, 8), 'y0^2 = 3 nu/8')
    check(dz2 == -(NU * K.rat(3, 8)), 'z0^2 = -3 nu/8')
    log('   incidence system solved: a = 0 gives L2, L3 ; a = 1, b = -1 gives')
    log('   y^2 = 3nu/8 (two roots) and z^2 = -3nu/8 (two roots)          => 6 LINES')

    #   the two K-rational lines
    for nm, w in [('L2 = <v,E_y>', (K0, K0, K0, K1, K0)),
                  ('L3 = <v,E_z>', (K0, K0, K0, K0, K1))]:
        s2, t2 = mkvars(2, K1)
        pt = [t2.scal(w[i]) + (s2 if i == IX else P(2, {})) for i in range(5)]
        Fl = ((pt[0]**3).scal(KP) + (pt[1]**3).scal(KM)
              + (pt[0] + pt[1]) * pt[2]**2
              + (pt[0].scal(OM) + pt[1].scal(OM2)) * pt[3]**2
              + (pt[0].scal(OM2) + pt[1].scal(OM)) * pt[4]**2
              + pt[2] * pt[3] * pt[4])
        check(Fl.is_zero(), 'F vanishes identically on %s' % nm)
    log('   F|_{L2} = F|_{L3} = 0 identically                              PASS')

    #   the four new lines, in the quadratic extensions
    for tag, dsq, slot in [('M_y', dy2, IY), ('M_z', dz2, IZ)]:
        one = QE.lift(1, dsq)
        rho = QE(K0, K1, dsq)
        check(rho * rho == QE.lift(dsq, dsq), 'rho^2 = d for %s' % tag)
        for sg in (1, -1):
            w = [QE.lift(K1, dsq), QE.lift(-K1, dsq), QE.lift(K0, dsq),
                 QE.lift(K0, dsq), QE.lift(K0, dsq)]
            w[slot] = rho if sg == 1 else -rho
            vv = [QE.lift(K0, dsq)] * 5
            vv[IX] = one
            va = mkvars(2, one)          # s, t
            pt = [va[1].scal(w[i]) + va[0].scal(vv[i]) for i in range(5)]
            Fl = ((pt[0]**3).scal(lift(KP, one))
                  + (pt[1]**3).scal(lift(KM, one))
                  + (pt[0] + pt[1]) * pt[2]**2
                  + (pt[0].scal(lift(OM, one)) + pt[1].scal(lift(OM2, one))) * pt[3]**2
                  + (pt[0].scal(lift(OM2, one)) + pt[1].scal(lift(OM, one))) * pt[4]**2
                  + pt[2] * pt[3] * pt[4])
            check(Fl.is_zero(), 'F vanishes identically on %s%s' % (tag, '+-'[sg < 0]))
    log('   F|_{M_y+-} = F|_{M_z+-} = 0 identically (in K(rho))            PASS')

    #   the new lines are NOT K-rational: 3nu/8 and -3nu/8 are nonsquares in K
    check(not square_in_K(dy2), '3nu/8 is NOT a square in K')
    check(not square_in_K(dz2), '-3nu/8 is NOT a square in K')
    check(square_in_K(K.rat(4)), 'control: 4 IS a square in K')
    check(square_in_K(K.rat(-3)), 'control: -3 IS a square in K (= delta^2)')
    check(square_in_K(K.rat(-11)), 'control: -11 IS a square in K (= nu^2)')
    check(not square_in_K(K.rat(2)), 'control: 2 is NOT a square in K')
    log('   3nu/8, -3nu/8 are NONSQUARES in K (controls: 4, -3, -11 are squares,')
    log('   2 is not)  ==> M_y+-, M_z+- are defined over quadratic extensions of K,')
    log('   the two degree-2 components of Sing are K-PRIME, and the total')
    log('   K-decomposition of Sing is 1 + 1 + 2 + 2 = 6.                  PASS')

    # ------------------------------------------------------ 4. singular locus
    log('')
    log('== 4.  Sing(Delta_v): the exact case analysis ==')
    Dpa, Dpb, Dpy, Dpz = (Da.diff(i) for i in (IA, IB, IY, IZ))
    check(Da.scal(K.rat(4)) == a * Dpa + b * Dpb + y * Dpy + z * Dpz, 'Euler')
    check(Dpy == (y * (z * z - (Q1 * Q2).scal(K.rat(4)))).scal(K.rat(2)),
          'd_y = 2y(c^2z^2 - 4 Q1 Q2)')
    check(Dpz == (z * (y * y - (Q1 * Q3).scal(K.rat(4)))).scal(K.rat(2)),
          'd_z = 2z(c^2y^2 - 4 Q1 Q3)')
    kpoly = Q2 * y * y + Q3 * z * z + C
    check(Dpa == (kpoly + Q1 * (y * y).scal(OM) + Q1 * (z * z).scal(OM2)
                  + Q1 * (a * a).scal(KP * K.rat(3))).scal(K.rat(-4)), 'd_a')
    check(Dpb == (kpoly + Q1 * (y * y).scal(OM2) + Q1 * (z * z).scal(OM)
                  + Q1 * (b * b).scal(KM * K.rat(3))).scal(K.rat(-4)), 'd_b')
    log('   d_y, d_z, d_a, d_b in the factored shapes                      PASS')

    #   CASE I : Q1 = 0.  substitute b = -a.
    def sub_b_eq_ma(p):
        out = P(5, {})
        for e, c in p.t.items():
            out = out + P(5, {(e[0] + e[1], 0, e[2], e[3], e[4]):
                              c * K.rat((-1) ** e[1])})
        return out

    kI = sub_b_eq_ma(kpoly)
    check(sub_b_eq_ma(Dpa) == kI.scal(K.rat(-4)), 'Case I: d_a = -4k')
    check(sub_b_eq_ma(Dpb) == kI.scal(K.rat(-4)), 'Case I: d_b = -4k')
    check(sub_b_eq_ma(Dpy) == (y * z * z).scal(K.rat(2)), 'Case I: d_y = 2 y z^2')
    check(sub_b_eq_ma(Dpz) == (z * y * y).scal(K.rat(2)), 'Case I: d_z = 2 z y^2')
    log('   CASE I (Q1 = 0): the system becomes {yz = 0, k = 0} = the INCIDENCE')
    log('   SYSTEM of part 3, hence exactly the six contracted points.      PASS')

    #   CASE II : Q1 != 0.
    #   (a) y = z = 0
    D_yz0 = Da.subs_const([None, None, None, K0, K0])
    check(D_yz0 == (Q1 * C).scal(K.rat(-4)), 'II.a Delta = -4 Q1 C')
    Da_yz0 = Dpa.subs_const([None, None, None, K0, K0])
    check(Da_yz0 == (C + Q1 * (a * a).scal(KP * K.rat(3))).scal(K.rat(-4)), 'II.a d_a')
    Db_yz0 = Dpb.subs_const([None, None, None, K0, K0])
    check(Db_yz0 == (C + Q1 * (b * b).scal(KM * K.rat(3))).scal(K.rat(-4)), 'II.a d_b')
    check(KP != K0 and KM != K0, 'kp, km nonzero')
    log('   CASE II.a (y = z = 0): Euler forces C = 0, then d_a, d_b force a = b = 0.')

    #   (b) y = 0, z != 0 : d_z forces Q1 Q3 = 0, so Q3 = 0, i.e. b = -om a
    bB = -OM
    check(Q3.eval_all([K1, bB, K0, K0, K0]) == K0, 'II.b Q3(1,-om) = 0')
    check(C.eval_all([K1, bB, K0, K0, K0]) == KP - KM, 'II.b C(1,-om) = kp-km')
    check(Q1.eval_all([K1, bB, K0, K0, K0]) != K0, 'II.b Q1(1,-om) != 0')
    check(KP - KM != K0, 'kp != km')
    log('   CASE II.b (y = 0, z != 0): Q3 = 0 => b = -om a, C = (kp-km) a^3,')
    log('   Delta = -4 Q1 C and Euler force a = 0 -- contradiction.')

    #   (c) z = 0, y != 0 : Q2 = 0, b = -om^2 a
    bC = -OM2
    check(Q2.eval_all([K1, bC, K0, K0, K0]) == K0, 'II.c Q2(1,-om^2) = 0')
    check(C.eval_all([K1, bC, K0, K0, K0]) == KP - KM, 'II.c C(1,-om^2) = kp-km')
    check(Q1.eval_all([K1, bC, K0, K0, K0]) != K0, 'II.c Q1(1,-om^2) != 0')
    log('   CASE II.c (z = 0, y != 0): symmetric -- contradiction.')

    #   (d) y != 0, z != 0 : substitute y^2 = 4 Q1 Q3, z^2 = 4 Q1 Q2 (c = 1)
    Y2 = (Q1 * Q3).scal(K.rat(4))
    Z2 = (Q1 * Q2).scal(K.rat(4))
    kd = Q2 * Y2 + Q3 * Z2 + C
    Dd = Y2 * Z2 - (Q1 * kd).scal(K.rat(4))
    check(Dd == (Q1 * ((Q1 * Q2 * Q3).scal(K.rat(4)) + C)).scal(K.rat(-4)),
          'II.d Delta = -4 Q1 (4 Q1 Q2 Q3 + C)')
    #   impose Delta = 0, i.e. C -> -4 Q1 Q2 Q3
    Cs = (Q1 * Q2 * Q3).scal(K.rat(-4))
    kd2 = Q2 * Y2 + Q3 * Z2 + Cs
    Da_d = (kd2 + Q1 * Y2.scal(OM) + Q1 * Z2.scal(OM2)
            + Q1 * (a * a).scal(KP * K.rat(3))).scal(K.rat(-4))
    Db_d = (kd2 + Q1 * Y2.scal(OM2) + Q1 * Z2.scal(OM)
            + Q1 * (b * b).scal(KM * K.rat(3))).scal(K.rat(-4))
    check(Da_d == (Q1 * (a * a)).scal((KP * K.rat(3) + K.rat(12)) * K.rat(-4)),
          'II.d COLLAPSE: d_a = -4 Q1 (12 + 3kp) a^2')
    check(Db_d == (Q1 * (b * b)).scal((KM * K.rat(3) + K.rat(12)) * K.rat(-4)),
          'II.d COLLAPSE: d_b = -4 Q1 (12 + 3km) b^2')
    check((KP + K.rat(4)) * (KM + K.rat(4)) == K.rat(22), '(4+kp)(4+km) = 22')
    check(KP + K.rat(4) != K0 and KM + K.rat(4) != K0, '4+kp, 4+km nonzero')
    log('   CASE II.d (y,z != 0): the COLLAPSE  d_a = -4Q1(12+3kp)a^2 ,')
    log('   d_b = -4Q1(12+3km)b^2 forces a = b = 0 -- contradiction. (N = 22 != 0)')
    log('')
    log('   ==> dim Sing(Delta_v) = 0, Sing = the six contracted points.   PASS')

    #   the six nodes, exactly
    log('')
    log('== 5.  the six nodes: vanishing and the Hessian (node) test ==')
    nodes = []
    nodes.append(('P_y', K1, [K0, K0, K1, K0], None))
    nodes.append(('P_z', K1, [K0, K0, K0, K1], None))
    for tag, dsq, slot in [('N_y', dy2, 2), ('N_z', dz2, 3)]:
        for sg in (1, -1):
            one = QE.lift(1, dsq)
            rho = QE(K0, K1, dsq)
            co = [QE.lift(K1, dsq), QE.lift(-K1, dsq), QE.lift(K0, dsq),
                  QE.lift(K0, dsq)]
            co[slot] = rho if sg == 1 else -rho
            nodes.append((tag + '+-'[sg < 0], one, co, dsq))
    for nm, one, co, dsq in nodes:
        #   build Delta_v over the right coefficient ring
        DD = P(4, {(e[IA], e[IB], e[IY], e[IZ]): lift(c, one) for e, c in Da.t.items()})
        check(DD.eval_all(co).is_zero(), '%s: Delta_v = 0' % nm)
        for i, gn in enumerate(['d_a', 'd_b', 'd_y', 'd_z']):
            check(DD.diff(i).eval_all(co).is_zero(), '%s: %s = 0' % (nm, gn))
        check(sum(1 for u in co if not u.is_zero()) > 0, '%s: nonzero point' % nm)
        check(co[0] + co[1] == co[0] * 0, '%s lies on Q1 = 0' % nm)
        #   Hessian in the affine chart var[idx] = 1 (idx = first nonzero slot)
        idx = next(i for i in range(4) if not co[i].is_zero())
        check(co[idx] == one, '%s already normalised in slot %d' % (nm, idx))
        loc = [i for i in range(4) if i != idx]
        #   translate: substitute var[i] = co[i] + eps_i  (i in loc), var[idx] = 1
        E = [P.var(3, j, one) for j in range(3)]
        sub = [None] * 4
        sub[idx] = P.const(3, one)
        for j, i in enumerate(loc):
            sub[i] = P.const(3, co[i]) + E[j]
        g = P(3, {})
        for e, c in DD.t.items():
            term = P.const(3, c)
            for i in range(4):
                for _ in range(e[i]):
                    term = term * sub[i]
            g = g + term
        H = [[None] * 3 for _ in range(3)]
        for i in range(3):
            for j in range(3):
                H[i][j] = g.diff(i).diff(j).eval_all([one * 0] * 3)
        det = (H[0][0] * (H[1][1] * H[2][2] - H[1][2] * H[2][1])
               - H[0][1] * (H[1][0] * H[2][2] - H[1][2] * H[2][0])
               + H[0][2] * (H[1][0] * H[2][1] - H[1][1] * H[2][0]))
        check(not det.is_zero(), '%s: Hessian nondegenerate -> ORDINARY NODE' % nm)
        log('   %-6s  Delta = grad = 0 ;  det Hess = %s  != 0  -> A_1 node'
            % (nm, det))

    log('')
    log('   Sing(Delta_v) = { P_y, P_z, N_y+, N_y-, N_z+, N_z- } = the six images')
    log('   of the six contracted lines : BIJECTION.                       PASS')

    # ---------------------------------------------------- 6. irreducibility
    log('')
    log('== 6.  irreducibility (Lemma C5-I) ==')
    log('   LEMMA C5-I.  A nonzero form G of degree >= 2 on P^n, n >= 3, with')
    log('   dim Sing V(G) = 0 is reduced and absolutely irreducible: a repeated')
    log('   factor would make Sing contain a hypersurface, and two distinct factors')
    log('   would make Sing contain their intersection, of dimension >= n-2 >= 1.')
    log('   Section 4 above proves dim Sing(Delta_v) = 0 in exact K-arithmetic.')
    log('   ==> Delta_v is ABSOLUTELY IRREDUCIBLE.                          PASS')
    check(Da.total_degree() == 4 and not Da.is_zero(), 'Delta_v is a nonzero quartic')

    # ---------------------------------------------------- 7. the V4-quotient
    log('')
    log('== 7.  the V4-quotient and the plane sections ==')
    A4, B4, YY, ZZ = mkvars(4, K1)
    Q1b, Q2b, Q3b = A4 + B4, A4.scal(OM) + B4.scal(OM2), A4.scal(OM2) + B4.scal(OM)
    Cb = A4**3 * P.const(4, KP) + B4**3 * P.const(4, KM)
    Dbar = YY * ZZ - (Q1b * (Q2b * YY + Q3b * ZZ + Cb)).scal(K.rat(4))
    hyp = (YY - (Q1b * Q3b).scal(K.rat(4))) * (ZZ - (Q1b * Q2b).scal(K.rat(4))) \
        - (Q1b * ((Q1b * Q2b * Q3b).scal(K.rat(4)) + Cb)).scal(K.rat(4))
    check(Dbar == hyp, 'Delta_bar = (Y-4Q1Q3)(Z-4Q1Q2) - 4Q1(4Q1Q2Q3+C)')
    check((Q1b * Q2b * Q3b).scal(K.rat(4)) + Cb
          == A4**3 * P.const(4, KP + K.rat(4)) + B4**3 * P.const(4, KM + K.rat(4)),
          '4 Q1Q2Q3 + C = (4+kp)a^3 + (4+km)b^3')
    #   Delta_bar pulls back to Delta_v under Y = y^2, Z = z^2
    pull = P(5, {})
    for e, c in Dbar.t.items():
        pull = pull + P(5, {(e[0], e[1], 0, 2 * e[2], 2 * e[3]): c})
    check(pull == Da, 'Delta_bar(Y=y^2,Z=z^2) = Delta_v')
    log('   Delta_bar : YZ = 4 Q1(Q2 Y + Q3 Z + C) on P(1,1,2,2), pulls back to')
    log('   Delta_v ; hyperbola form and (4+kp)a^3+(4+km)b^3 verified.      PASS')
    #   plane sections
    Dy0 = Da.subs_const([None, None, None, K0, None])
    Dz0 = Da.subs_const([None, None, None, None, K0])
    check(Dy0 == (Q1 * (Q3 * z * z + C)).scal(K.rat(-4)), 'Delta|_{y=0} = -4Q1(Q3z^2+C)')
    check(Dz0 == (Q1 * (Q2 * y * y + C)).scal(K.rat(-4)), 'Delta|_{z=0} = -4Q1(Q2y^2+C)')
    Dl0 = Da.subs_const([None, None, None, K0, K0])
    check(Dl0 == (Q1 * C).scal(K.rat(-4)), 'Delta|_{y=z=0} = -4 Q1 C')
    check(KP != K0 and KM != K0, 'kp, km != 0 : C has three distinct roots')
    check(C.eval_all([K1, -K1, K0, K0, K0]) != K0,
          'C(1,-1) = kp-km != 0 : Q1 and C are coprime, so the four points are DISTINCT')
    log('   Delta|_{y=0} = -4Q1(Q3z^2+C), Delta|_{z=0} = -4Q1(Q2y^2+C),')
    log('   Delta|_{V4-fixed line} = -4 Q1 C : FOUR DISTINCT points (kp,km != 0 and')
    log('   kp != km), so E_{sigma_1} -> P^1 has 4 branch points, g = 1.     PASS')

    # -------------------------------------------------- 8. payload cross-check
    log('')
    log('== 8.  cross-check against payloads/c5_data.json ==')
    with open(os.path.join(HERE, 'payloads', 'c5_data.json')) as fh:
        data = json.load(fh)
    check(data['singular_locus']['dim'] == 0, 'payload: dim Sing = 0')
    check(data['singular_locus']['degree'] == 6, 'payload: degree Sing = 6')
    check(data['singular_locus']['reduced'] is True, 'payload: Sing reduced')
    check(data['line_census']['count'] == 6, 'payload: 6 lines')
    check(data['line_census']['arrangement']['n_through_v'] == 2,
          'payload: 2 arrangement lines through v')
    check(data['line_census']['arrangement']['n_involutions'] == 55,
          'payload: 55 involutions')
    check(data['irreducibility']['over_K'] == 'IRREDUCIBLE', 'payload: irreducible')
    check(data['irreducibility']['over_Kbar'] == 'IRREDUCIBLE',
          'payload: absolutely irreducible')
    check(data['c_xyz'] == 1, 'payload: xyz-coefficient = 1')
    hd = data['singular_locus']['hessian_determinants']
    check(set(hd.values()) == {'96', '-594'}, 'payload: hessian determinants')
    log('   every structural field of c5_data.json agrees with this verifier. PASS')

    # ------------------------------------------------------ 9. numeric sanity
    log('')
    log('== 9.  40-digit numeric sanity layer (printed only; no decision) ==')
    try:
        from mpmath import mp, mpf, sqrt as msqrt
        mp.dps = 40
        s33n = msqrt(mpf(33))
        kpn = (13 + 3 * s33n) / 16
        kmn = (13 - 3 * s33n) / 16
        log('   sqrt33 = %s' % mp.nstr(s33n, 40))
        log('   kp     = %s' % mp.nstr(kpn, 40))
        log('   km     = %s' % mp.nstr(kmn, 40))
        log('   (4+kp)(4+km) = %s   [exact 22]' % mp.nstr((4 + kpn) * (4 + kmn), 40))
        log('   kp*km  = %s   [exact -1/2]' % mp.nstr(kpn * kmn, 40))
    except ImportError:
        log('   mpmath unavailable -- skipped (no decision depends on it)')

    log('')
    log('exact checks performed: %d' % NCHK[0])
    log('elapsed %.1f s' % (time.time() - T0))
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_VERIFY.txt'), 'w') as fh:
        fh.write('\n'.join(LOG) + '\n')
    print('FIX_C5_VERIFY_OK')


if __name__ == '__main__':
    main()
