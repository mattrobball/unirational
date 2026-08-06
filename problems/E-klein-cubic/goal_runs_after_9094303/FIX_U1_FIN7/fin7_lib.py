#!/usr/bin/env python3
"""FIX-U1-FIN7 -- the POINTWISE, NON-EQUIVARIANT r = 7 cone.

Named by Proposition 5.3 of `theory/FIX_IV_closure.md` (computation FIN(7)).

Frame (V4 normal form (1.1), `goal_runs_after_f1f0be/.../THEOREM.md`):
ground field K = QQ(om, kp), om^2+om+1 = 0, 8kp^2-13kp-4 = 0, kp = kappa_+,
km = 13/8 - kp = kappa_-.  Klein normal form

    F(a,b,u0,u1,u2) = kp a^3 + km b^3
                      + a (u0^2 + om u1^2 + om^2 u2^2)
                      + b (u0^2 + om^2 u1^2 + om u2^2)
                      + u0 u1 u2 .

x, y, z are the normal coordinates of the V4-characters B, C, D at the triple
line; the three involution plus-planes have ideals (y,z), (x,z), (x,y), so for
a monomial x^A y^B z^C of degree r

    ord_{P_1} = r - A ,   ord_{P_2} = r - B ,   ord_{P_3} = r - C .

A pointwise cone element of order r with all plane orders >= m is a tuple
T = (a', b', u0', u1', u2') of degree-r forms, one V4-parity pattern per slot,
supported on monomials with max(A,B,C) <= r - m, with F(T) = 0 identically.

This module builds that system WITHOUT the residual-C3 relation
psi(T) = lam g(T).  For (r,m) = (7,1):

    a', b'  : 6 monomials each  (all exponents odd)     -> p0..p5, q0..q5
    u0'     : 9 monomials (odd, even, even)             -> s0..s8
    u1'     : 9 monomials (even, odd, even)             -> t0..t8
    u2'     : 9 monomials (even, even, odd)             -> w0..w8
                                                    39 parameters in all,
and F(T) has 52 coefficient equations (all-odd degree-21 monomials with
max(A,B,C) <= 18).

Variable names are lowercase, digit-suffixed, underscore-free (M2 rule) and
every emitted msolve input is fully expanded with bare integer coefficients
(MSOLVE_PARSER.md rule).
"""
import sympy as sp

x, y, z = sp.symbols('x y z')
om, kp = sp.symbols('om kp')
REL = [om**2 + om + 1, 8*kp**2 - 13*kp - 4]
KM = sp.Rational(13, 8) - kp
OM2 = -1 - om                                          # om^2

SLOT_NAMES = ["a'", "b'", "u0'", "u1'", "u2'"]
SLOT_PREFIX = ['p', 'q', 's', 't', 'w']


def kred(e):
    """normal form modulo om^2+om+1 and 8kp^2-13kp-4 (a Groebner basis:
    leading monomials om^2, kp^2 are coprime -- Buchberger's 1st criterion)."""
    e = sp.expand(e)
    if e == 0:
        return sp.Integer(0)
    _, r = sp.reduced(e, REL, om, kp, order='lex')
    return sp.expand(r)


def slot_parities(r):
    """V4-characters of the five slots as parity patterns of (A,B,C)."""
    if r % 2:
        return [(1, 1, 1), (1, 1, 1), (1, 0, 0), (0, 1, 0), (0, 0, 1)]
    return [(0, 0, 0), (0, 0, 0), (0, 1, 1), (1, 0, 1), (1, 1, 0)]


def monomials_xyz(r, m, parity):
    """degree-r monomials with the given parity pattern and min_i ord_{P_i} >= m,
    i.e. max(A,B,C) <= r - m.  Sorted descending (indep_r7 convention)."""
    out = []
    for A in range(r + 1):
        for B in range(r + 1 - A):
            C = r - A - B
            if (A % 2, B % 2, C % 2) != tuple(parity):
                continue
            if r - max(A, B, C) < m:
                continue
            out.append((A, B, C))
    return sorted(out, reverse=True)


def supports(r=7, m=1):
    return [monomials_xyz(r, m, p) for p in slot_parities(r)]


def param_names(r=7, m=1):
    sup = supports(r, m)
    return [['%s%d' % (SLOT_PREFIX[i], k) for k in range(len(sup[i]))]
            for i in range(5)]


def all_params(r=7, m=1):
    return [n for blk in param_names(r, m) for n in blk]


# ---------------------------------------------------------------------------
# sparse polynomials in x,y,z with sympy coefficients
# ---------------------------------------------------------------------------
def pmul(a, b):
    out = {}
    for ka, va in a.items():
        for kb, vb in b.items():
            k = (ka[0] + kb[0], ka[1] + kb[1], ka[2] + kb[2])
            out[k] = out.get(k, 0) + va*vb
    return out


def padd(*ps):
    out = {}
    for p in ps:
        for k, v in p.items():
            out[k] = out.get(k, 0) + v
    return out


def pscal(a, c):
    return {k: c*v for k, v in a.items()}


def tuple_generic(r=7, m=1):
    """(names, T) with T a list of 5 sparse dicts, coefficients = parameters."""
    sup = supports(r, m)
    nms = param_names(r, m)
    T = []
    for i in range(5):
        T.append({mon: sp.Symbol(nms[i][k]) for k, mon in enumerate(sup[i])})
    return [n for blk in nms for n in blk], T


def F_klein(T):
    """Klein normal form (1.1) applied to a tuple of sparse dicts."""
    a, b, u0, u1, u2 = T
    a3 = pmul(pmul(a, a), a)
    b3 = pmul(pmul(b, b), b)
    q0, q1, q2 = pmul(u0, u0), pmul(u1, u1), pmul(u2, u2)
    Qa = padd(q0, pscal(q1, om), pscal(q2, OM2))
    Qb = padd(q0, pscal(q1, OM2), pscal(q2, om))
    return padd(pscal(a3, kp), pscal(b3, KM),
                pmul(a, Qa), pmul(b, Qb), pmul(pmul(u0, u1), u2))


def landing_equations(r=7, m=1):
    """(names, T, eqs) -- eqs = [(monomial, coefficient)] of F(T)."""
    names, T = tuple_generic(r, m)
    F = F_klein(T)
    eqs = []
    for mon in sorted(F, reverse=True):
        c = kred(F[mon])
        if c != 0:
            eqs.append((mon, c))
    return names, T, eqs


# ---------------------------------------------------------------------------
# the plane-order-exactly-1 open conditions
# ---------------------------------------------------------------------------
def po1_witnesses(r=7, m=1):
    """for each plane i, the parameters whose non-vanishing gives ord_{P_i}=1.

    ord_{P_i}(T) >= 1 holds by construction; ord_{P_i}(T) = 1 iff some monomial
    with (r - exponent_i) = 1 has a nonzero coefficient.
    """
    sup, nms = supports(r, m), param_names(r, m)
    out = []
    for i in range(3):
        w = []
        for sl in range(5):
            for k, mon in enumerate(sup[sl]):
                if r - mon[i] == m:
                    w.append((nms[sl][k], SLOT_NAMES[sl], mon))
        out.append(w)
    return out


# ---------------------------------------------------------------------------
# the residual-C3 operator Theta on the parameter space
# ---------------------------------------------------------------------------
def psi_mon(mon):
    """psi: (x,y,z) -> (y,z,x) sends x^A y^B z^C to x^C y^A z^B."""
    A, B, C = mon
    return (C, A, B)


def theta_matrix(r=7, m=1):
    """Theta(T) := g^{-1}(psi(T)),  g = (a,b,u0,u1,u2) -> (om a, om^2 b, u1,u2,u0).

    T is residual-C3-equivariant with scalar lam  <=>  Theta(T) = lam * T.
    Returned as a dict {param_out: sympy linear form in params}.
    Theta^3 = id, so the 39-space splits as 13 + 13 + 13.
    """
    sup, nms = supports(r, m), param_names(r, m)
    idx = [{mon: k for k, mon in enumerate(sup[i])} for i in range(5)]
    # component j of Theta(T):  j=0: om^2 psi(a'), 1: om psi(b'),
    #                           2: psi(u2'), 3: psi(u0'), 4: psi(u1')
    src = [(0, OM2), (1, om), (4, sp.Integer(1)), (2, sp.Integer(1)),
           (3, sp.Integer(1))]
    out = {}
    for j in range(5):
        sl, fac = src[j]
        for k, mon in enumerate(sup[sl]):
            tgt = psi_mon(mon)
            assert tgt in idx[j], (j, sl, mon)
            nm = nms[j][idx[j][tgt]]
            out[nm] = out.get(nm, 0) + fac*sp.Symbol(nms[sl][k])
    assert len(out) == sum(len(b) for b in nms)
    return {k: kred(v) for k, v in out.items()}


# ---------------------------------------------------------------------------
# the torus (reparametrisation) tangent directions
# ---------------------------------------------------------------------------
def torus_vectors(r=7, m=1):
    """E_x, E_y, E_z as diagonal weight vectors on the 39 parameters.

    (s,t,w) . T := T(sx, ty, wz) is a (C*)^3-action preserving the slot
    parities, the degree, the monomial support (hence every plane order) and
    the landing identity F(T)(sx,ty,wz) = F(T o diag) = 0.  Its infinitesimal
    generators act on the coefficient of x^A y^B z^C by A, B, C respectively,
    and E_x + E_y + E_z = r * id (the global scalar).
    """
    sup, nms = supports(r, m), param_names(r, m)
    E = [[], [], []]
    for sl in range(5):
        for k, mon in enumerate(sup[sl]):
            for i in range(3):
                E[i].append(mon[i])
    names = [n for blk in nms for n in blk]
    return names, E


# ---------------------------------------------------------------------------
# term-list form of the 52 equations (fast evaluation / Jacobian over any ring)
# ---------------------------------------------------------------------------
def _slot_terms(r, m):
    sup = supports(r, m)
    off, out = 0, []
    for i in range(5):
        out.append({mon: off + k for k, mon in enumerate(sup[i])})
        off += len(sup[i])
    return out, off


def landing_terms(r=7, m=1):
    """(names, eqs) with eqs = [(xyzmon, [(Kcoeff, (i,j,k))])].

    Kcoeff is a sympy element of K (reduced); (i,j,k) is the sorted triple of
    parameter indices of the cubic monomial.  Independent of `landing_equations`
    -- the two are cross-checked in verify_fin7.py.
    """
    slot, npar = _slot_terms(r, m)
    sup = supports(r, m)
    terms = {}

    def add(coef, idx, mon):
        key = (mon, tuple(sorted(idx)))
        terms[key] = terms.get(key, 0) + coef

    def cube(sl, coef):
        for m1 in sup[sl]:
            for m2 in sup[sl]:
                for m3 in sup[sl]:
                    add(coef, (slot[sl][m1], slot[sl][m2], slot[sl][m3]),
                        tuple(a + b + c for a, b, c in zip(m1, m2, m3)))

    def lin_sq(sl_lin, sl_sq, coef):
        for m1 in sup[sl_lin]:
            for m2 in sup[sl_sq]:
                for m3 in sup[sl_sq]:
                    add(coef, (slot[sl_lin][m1], slot[sl_sq][m2],
                               slot[sl_sq][m3]),
                        tuple(a + b + c for a, b, c in zip(m1, m2, m3)))

    cube(0, kp)
    cube(1, KM)
    for sl_sq, ca, cb in ((2, sp.Integer(1), sp.Integer(1)),
                          (3, om, OM2), (4, OM2, om)):
        lin_sq(0, sl_sq, ca)
        lin_sq(1, sl_sq, cb)
    for m0 in sup[2]:
        for m1 in sup[3]:
            for m2 in sup[4]:
                add(sp.Integer(1), (slot[2][m0], slot[3][m1], slot[4][m2]),
                    tuple(a + b + c for a, b, c in zip(m0, m1, m2)))

    eqs = {}
    for (mon, idx), coef in terms.items():
        coef = kred(coef)
        if coef == 0:
            continue
        eqs.setdefault(mon, []).append((coef, idx))
    out = [(mon, sorted(eqs[mon], key=lambda t: t[1]))
           for mon in sorted(eqs, reverse=True)]
    return all_params(r, m), out
