#!/usr/bin/env python3
"""FIX-N2B engine: the C3-equivariant pointwise landing systems in the U,V,W picture.

This is an INDEPENDENT re-implementation of the FIX-N2 cell engine
(`goal_runs_after_fc5e2d3/FIX_N2_CELL_CLASSIFICATION/`).  Differences that make
it independent:

  * exact arithmetic in the degree-4 number field  K = QQ(om, kp),
    om^2+om+1 = 0, 8 kp^2 - 13 kp - 4 = 0  (so kp+km = 13/8, kp*km = -1/2),
    implemented from scratch as QQ-vectors in the basis {1, om, kp, om*kp}
    -- no sympy anywhere in the hot path;
  * the tuple is built in the PARITY-REDUCED U = x^2, V = y^2, W = z^2 picture
    of CELL_TABLE.md section 1 rather than as a raw monomial expansion, and the
    C3-eigenblocks are produced by an explicit eigenvector formula
    (M + nu^-1 sigma M + nu^-2 sigma^2 M) rather than by a nullspace;
  * plane orders are read off the U,V,W exponents.

CONVENTIONS (identical to FIX-N2; see its CELL_TABLE.md section 0):
  x,y,z normal coordinates of the three nontrivial V4-characters;
  P_1 = (y,z), P_2 = (x,z), P_3 = (x,y);  for a monomial x^A y^B z^C,
  ord_{P_1} = B+C, ord_{P_2} = A+C, ord_{P_3} = A+B, ord_R = A+B+C.
  CELL (m,r): m = min_i ord_{P_i}, r = ord_R;  membership in J_m at degree r
  <=> every exponent <= r-m.
  Klein normal form (V4 packet (1.1)):
    F = kp a^3 + km b^3 + a(u0^2+om u1^2+om^2 u2^2) + b(u0^2+om^2 u1^2+om u2^2)
        + u0 u1 u2.
  Residual C3:  psi = ((x,y,z)->(y,z,x)) on the source,
    g = ((a,b,u0,u1,u2) -> (om a, om^2 b, u1, u2, u0)) on the target;
    a pointwise C3-equivariant tuple satisfies psi(T) = lam * g(T), lam^3 = 1.

SHAPES (CELL_TABLE.md section 1):
  r even, d = r/2 :  a' = P(U,V,W), b' = R(U,V,W)   (deg d)
                     u0' = yz B0(U,V,W), u1' = zx B1, u2' = xy B2  (deg d-1)
  r odd,  d = (r-1)/2 :
                     a' = xyz Q(U,V,W), b' = xyz S  (deg d-1)
                     u0' = x A0(U,V,W), u1' = y A1, u2' = z A2   (deg d)
"""

from fractions import Fraction as Fr
Fr = Fr
import itertools

# --------------------------------------------------------------------------
# 1.  the field K = QQ(om)[kp]/(8kp^2-13kp-4);  basis {1, om, kp, om*kp}
# --------------------------------------------------------------------------
# element = 4-tuple (c0,c1,c2,c3)  meaning  c0 + c1*om + c2*kp + c3*om*kp
ZERO = (Fr(0),) * 4
ONE = (Fr(1), Fr(0), Fr(0), Fr(0))
OM = (Fr(0), Fr(1), Fr(0), Fr(0))
OM2 = (Fr(-1), Fr(-1), Fr(0), Fr(0))          # om^2 = -1-om
KP = (Fr(0), Fr(0), Fr(1), Fr(0))
KM = (Fr(13, 8), Fr(0), Fr(-1), Fr(0))        # km = 13/8 - kp


def kadd(a, b):
    return (a[0] + b[0], a[1] + b[1], a[2] + b[2], a[3] + b[3])


def kneg(a):
    return (-a[0], -a[1], -a[2], -a[3])


def ksub(a, b):
    return (a[0] - b[0], a[1] - b[1], a[2] - b[2], a[3] - b[3])


def kscal(c, a):
    c = Fr(c)
    return (c * a[0], c * a[1], c * a[2], c * a[3])


def _om_mul(p, q):
    """(p0+p1 om)(q0+q1 om) with om^2 = -1-om."""
    a = p[0] * q[0]
    b = p[0] * q[1] + p[1] * q[0]
    c = p[1] * q[1]
    return (a - c, b - c)


def kmul(a, b):
    """product in K, with kp^2 = (13 kp + 4)/8."""
    a0, a1 = (a[0], a[1]), (a[2], a[3])     # a = a0 + a1*kp   (a_i in QQ(om))
    b0, b1 = (b[0], b[1]), (b[2], b[3])
    p00 = _om_mul(a0, b0)
    p01 = _om_mul(a0, b1)
    p10 = _om_mul(a1, b0)
    p11 = _om_mul(a1, b1)                   # coefficient of kp^2
    # kp^2 = 13/8 kp + 1/2
    c0 = (p00[0] + Fr(1, 2) * p11[0], p00[1] + Fr(1, 2) * p11[1])
    c1 = (p01[0] + p10[0] + Fr(13, 8) * p11[0],
          p01[1] + p10[1] + Fr(13, 8) * p11[1])
    return (c0[0], c0[1], c1[0], c1[1])


def kiszero(a):
    return a[0] == 0 and a[1] == 0 and a[2] == 0 and a[3] == 0


def kinv_of_root_of_unity(lam):
    """inverse of 1, om, om^2."""
    if lam == ONE:
        return ONE
    if lam == OM:
        return OM2
    if lam == OM2:
        return OM
    raise ValueError(lam)


def kstr(a):
    """Macaulay2 / msolve friendly string over QQ[om,kp]."""
    parts = []
    for c, s in ((a[0], ''), (a[1], '*om'), (a[2], '*kp'), (a[3], '*om*kp')):
        if c == 0:
            continue
        num, den = c.numerator, c.denominator
        t = '(%d/%d)' % (num, den) if den != 1 else '(%d)' % num
        parts.append(t + s)
    return '+'.join(parts) if parts else '0'


def kmod_p(a, p, omp, kpp):
    """reduce an element of K modulo a prime p with chosen roots om,kp mod p."""
    v = 0
    for c, r in ((a[0], 1), (a[1], omp), (a[2], kpp), (a[3], omp * kpp % p)):
        if c == 0:
            continue
        v = (v + c.numerator * pow(c.denominator, p - 2, p) % p * r) % p
    return v % p


# --------------------------------------------------------------------------
# 2.  polynomials in U,V,W with coefficients polynomial in the parameters
# --------------------------------------------------------------------------
# A "cpoly" is dict{ uvw_exponent_triple : dict{ param_exponent_tuple : Kelt } }

def cp_zero():
    return {}


def cp_addto(dst, src, fac=ONE):
    for mo, pc in src.items():
        d = dst.setdefault(mo, {})
        for pm, c in pc.items():
            v = kadd(d.get(pm, ZERO), kmul(c, fac))
            if kiszero(v):
                d.pop(pm, None)
            else:
                d[pm] = v
        if not d:
            dst.pop(mo)
    return dst


def cp_mul(A, B):
    out = {}
    for ma, pa in A.items():
        for mb, pb in B.items():
            mo = (ma[0] + mb[0], ma[1] + mb[1], ma[2] + mb[2])
            d = out.setdefault(mo, {})
            for pma, ca in pa.items():
                for pmb, cb in pb.items():
                    pm = tuple(i + j for i, j in zip(pma, pmb))
                    v = kadd(d.get(pm, ZERO), kmul(ca, cb))
                    if kiszero(v):
                        d.pop(pm, None)
                    else:
                        d[pm] = v
    return {mo: d for mo, d in out.items() if d}


def cp_scal(A, c):
    out = {}
    for mo, pa in A.items():
        d = {pm: kmul(v, c) for pm, v in pa.items()}
        d = {pm: v for pm, v in d.items() if not kiszero(v)}
        if d:
            out[mo] = d
    return out


def cp_shift(A, mo0):
    """multiply by the U,V,W-monomial mo0."""
    return {(mo[0] + mo0[0], mo[1] + mo0[1], mo[2] + mo0[2]): dict(pc)
            for mo, pc in A.items()}


# --------------------------------------------------------------------------
# 3.  cells:  monomial supports with the plane-order constraint
# --------------------------------------------------------------------------
def tri(n):
    """exponent triples of total degree n, sorted."""
    if n < 0:
        return []
    return sorted([(i, j, n - i - j) for i in range(n + 1)
                   for j in range(n + 1 - i)], reverse=True)


def support(r, m, slot):
    """U,V,W-exponent triples allowed in the given slot at cell level (m,r).

    slot in {'a','b'} (the trivial-character components) or 'u0'.
    Returns the list of (i,j,k).
    """
    lim = r - m
    if r % 2 == 0:
        d = r // 2
        if slot in ('a', 'b'):
            return [t for t in tri(d) if 2 * max(t) <= lim]
        return [t for t in tri(d - 1)
                if max(2 * t[0], 2 * t[1] + 1, 2 * t[2] + 1) <= lim]
    d = (r - 1) // 2
    if slot in ('a', 'b'):
        return [t for t in tri(d - 1) if 2 * max(t) + 1 <= lim]
    return [t for t in tri(d)
            if max(2 * t[0] + 1, 2 * t[1], 2 * t[2]) <= lim]


def plane_order(r, slot, t):
    """plane order of the x,y,z-monomial encoded by (slot, U,V,W-exponent t)."""
    if r % 2 == 0:
        if slot in ('a', 'b'):
            e = (2 * t[0], 2 * t[1], 2 * t[2])
        else:                                     # u0 slot: yz * U^i V^j W^k
            e = (2 * t[0], 2 * t[1] + 1, 2 * t[2] + 1)
    else:
        if slot in ('a', 'b'):
            e = (2 * t[0] + 1, 2 * t[1] + 1, 2 * t[2] + 1)
        else:                                     # u0 slot: x * U^i V^j W^k
            e = (2 * t[0] + 1, 2 * t[1], 2 * t[2])
    return r - max(e)


def cell_dims(r, m):
    na = len(support(r, m, 'a'))
    nu = len(support(r, m, 'u0'))
    return (na, na, nu, nu, nu)


# --------------------------------------------------------------------------
# 4.  the C3-eigenblocks, built by the explicit eigenvector formula
# --------------------------------------------------------------------------
def sigma(t):
    """sigma(U^i V^j W^k) = V^i W^j U^k = U^k V^i W^j."""
    return (t[2], t[0], t[1])


def eigen_basis(monos, nu):
    """basis of {P : sigma P = nu P} inside span(monos) (a sigma-stable set).

    For each sigma-orbit of size 3 with representative M:
        M + nu^-1 sigma M + nu^-2 sigma^2 M .
    A fixed monomial (i=j=k) contributes iff nu == 1.
    """
    nui = kinv_of_root_of_unity(nu)
    nui2 = kmul(nui, nui)
    seen, out = set(), []
    for M in monos:
        if M in seen:
            continue
        orb = [M, sigma(M), sigma(sigma(M))]
        seen |= set(orb)
        if orb[0] == orb[1]:                       # fixed monomial
            if nu == ONE:
                out.append({M: ONE})
            continue
        out.append({orb[0]: ONE, orb[1]: nui, orb[2]: nui2})
    return out


class Block:
    """the C3-eigenblock of pointwise tuples at cell (m,r) with scalar lam."""

    def __init__(self, r, m, lam):
        self.r, self.m, self.lam = r, m, lam
        self.sup_a = support(r, m, 'a')
        self.sup_u = support(r, m, 'u0')
        nuP = kmul(lam, OM)                        # sigma P = lam*om * P
        nuR = kmul(lam, OM2)                       # sigma R = lam*om^2 * R
        self.bP = eigen_basis(self.sup_a, nuP)
        self.bR = eigen_basis(self.sup_a, nuR)
        self.bB = [{M: ONE} for M in self.sup_u]   # B0 is free
        self.names = (['P%d' % i for i in range(len(self.bP))]
                      + ['R%d' % i for i in range(len(self.bR))]
                      + ['B%d' % i for i in range(len(self.bB))])
        self.n = len(self.names)
        self.blocks = [('P', self.bP), ('R', self.bR), ('B', self.bB)]

    # -- the five components, as cpolys in U,V,W with linear param coefficients
    def components(self):
        n = self.n
        idx = 0

        def lin(basis_list):
            nonlocal idx
            out = {}
            for b in basis_list:
                e = [0] * n
                e[idx] = 1
                e = tuple(e)
                for mo, c in b.items():
                    out.setdefault(mo, {})[e] = c
                idx += 1
            return out

        P = lin(self.bP)
        R = lin(self.bR)
        B0 = lin(self.bB)
        lami = kinv_of_root_of_unity(self.lam)
        # B1 = lam^-1 * sigma B0 ;  B2 = lam^-1 * sigma B1
        B1 = cp_scal({sigma(mo): dict(pc) for mo, pc in B0.items()}, lami)
        B2 = cp_scal({sigma(mo): dict(pc) for mo, pc in B1.items()}, lami)
        return P, R, B0, B1, B2

    def param_plane_orders(self):
        """for every parameter, the plane orders of the monomials it carries."""
        out = []
        for tag, basis_list in self.blocks:
            slot = 'a' if tag in 'PR' else 'u0'
            for b in basis_list:
                if tag == 'B':
                    # B0 carries u0'; its sigma-images carry u1',u2' with the
                    # same plane order profile (cyclic), so one slot suffices
                    out.append(min(plane_order(self.r, slot, mo) for mo in b))
                else:
                    out.append(min(plane_order(self.r, slot, mo) for mo in b))
        return out


# --------------------------------------------------------------------------
# 5.  the landing equation
# --------------------------------------------------------------------------
def landing_cpoly(block):
    """F(T)/(xyz)^{r mod 2} as a cpoly in U,V,W.  Zero <=> the tuple lands."""
    P, R, B0, B1, B2 = block.components()
    r = block.r
    if r % 2 == 0:
        # kp P^3 + km R^3 + (P+R) VW B0^2 + (omP+om^2R) WU B1^2
        #                 + (om^2P+omR) UV B2^2 + UVW B0B1B2
        out = cp_zero()
        cp_addto(out, cp_mul(cp_mul(P, P), P), KP)
        cp_addto(out, cp_mul(cp_mul(R, R), R), KM)
        s0 = cp_zero(); cp_addto(s0, P); cp_addto(s0, R)
        s1 = cp_zero(); cp_addto(s1, P, OM); cp_addto(s1, R, OM2)
        s2 = cp_zero(); cp_addto(s2, P, OM2); cp_addto(s2, R, OM)
        cp_addto(out, cp_shift(cp_mul(s0, cp_mul(B0, B0)), (0, 1, 1)))
        cp_addto(out, cp_shift(cp_mul(s1, cp_mul(B1, B1)), (1, 0, 1)))
        cp_addto(out, cp_shift(cp_mul(s2, cp_mul(B2, B2)), (1, 1, 0)))
        cp_addto(out, cp_shift(cp_mul(cp_mul(B0, B1), B2), (1, 1, 1)))
        return out
    # odd: UVW(kp Q^3 + km S^3) + (Q+S) U A0^2 + (omQ+om^2S) V A1^2
    #      + (om^2Q+omS) W A2^2 + A0A1A2          (Q=P, S=R, A_i=B_i)
    Q, S, A0, A1, A2 = P, R, B0, B1, B2
    out = cp_zero()
    cube = cp_zero()
    cp_addto(cube, cp_mul(cp_mul(Q, Q), Q), KP)
    cp_addto(cube, cp_mul(cp_mul(S, S), S), KM)
    cp_addto(out, cp_shift(cube, (1, 1, 1)))
    s0 = cp_zero(); cp_addto(s0, Q); cp_addto(s0, S)
    s1 = cp_zero(); cp_addto(s1, Q, OM); cp_addto(s1, S, OM2)
    s2 = cp_zero(); cp_addto(s2, Q, OM2); cp_addto(s2, S, OM)
    cp_addto(out, cp_shift(cp_mul(s0, cp_mul(A0, A0)), (1, 0, 0)))
    cp_addto(out, cp_shift(cp_mul(s1, cp_mul(A1, A1)), (0, 1, 0)))
    cp_addto(out, cp_shift(cp_mul(s2, cp_mul(A2, A2)), (0, 0, 1)))
    cp_addto(out, cp_mul(cp_mul(A0, A1), A2))
    return out


def equations(block, orbit_reduce=False):
    """the coefficient equations of F(T) = 0, as dicts {param_mono: Kelt}."""
    L = landing_cpoly(block)
    if not orbit_reduce:
        return [pc for pc in L.values() if pc]
    seen, out = set(), []
    for mo in sorted(L, reverse=True):
        if mo in seen:
            continue
        orb = {mo, sigma(mo), sigma(sigma(mo))}
        seen |= orb
        for m2 in orb:
            if L.get(m2):
                out.append(L[m2])
                break
    return out


# --------------------------------------------------------------------------
# 6.  export
# --------------------------------------------------------------------------
def eq_str(pc, names, mod=None, p=None, omp=None, kpp=None):
    terms = []
    for pm, c in sorted(pc.items()):
        mon = '*'.join('%s^%d' % (names[i], e) if e > 1 else names[i]
                       for i, e in enumerate(pm) if e)
        if mod:
            v = kmod_p(c, p, omp, kpp)
            if v == 0:
                continue
            terms.append('%d%s' % (v, '*' + mon if mon else ''))
        else:
            terms.append('(%s)%s' % (kstr(c), '*' + mon if mon else ''))
    return '+'.join(terms) if terms else '0'
