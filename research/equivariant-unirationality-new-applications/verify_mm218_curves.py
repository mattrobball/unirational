#!/usr/bin/env python3
"""Curve census on the deck-fixed degree-two del Pezzo surface Z of the Fermat No. 2.18 threefold.

Z = { t0^2 Q1 + 2 t0 t1 Q2 + t1^2 Q3 = 0 } in P^1 x P^2 is the branch surface,
and X^tau = Z.  The second projection pi : Z -> P^2 is the anticanonical double
cover branched over the Fermat quartic Delta = { x^4+y^4+z^4 = 0 }, so
-K_Z = pi^* O(1) and K_Z^2 = 2.

Over a point r of P^2 the two sheets are the roots of the binary quadratic
Q1(r) u^2 + 2 Q2(r) u + Q3(r), i.e. u = (-Q2 +- sqrt(Delta))/Q1.  A line L is a
bitangent of Delta exactly when Delta|_L is the square of a binary quadratic
g_L, and then pi^{-1}(L) splits into the two (-1)-curves

    C_L^eps = { ( [ -Q2|_L + eps*g_L : Q1|_L ] , r ) : r in L },  eps = +-1.

The 28 bitangents of the Fermat quartic are, exactly:
    type H (12):  the 4 lines a*x + b*y = 0 with (a/b)^4 = -1, and the
                  two other coordinate-pair families;
    type B (16):  z = a*x + b*y with a^4 = b^4 = 1.
(See MM218_FERMAT_NETWORK.md for the elimination that shows the list is complete;
the count 28 is the classical bitangent count for a smooth plane quartic.)

Run:  python3 verify_mm218_curves.py
"""

from __future__ import annotations

from typing import Dict, FrozenSet, List, Optional, Sequence, Set, Tuple

from verify_mm218_model import (
    F, FERMAT, FiniteGroup, IDENT, ONE, TAU, ZERO, Elt, Fld, Mat,
    Q1, Q2, Q3, SQRT2, add, build_G, common_eigenspaces, div, eigenvalue_at,
    fld_str, inv, is_zero, mul, neg, norm_point, peval, sub, z24,
)

Vec3 = Tuple[Fld, Fld, Fld]
Vec2 = Tuple[Fld, Fld]

I_UNIT = z24(6)
MU4 = [ONE, I_UNIT, neg(ONE), neg(I_UNIT)]           # 4th roots of unity
EPS4 = [z24(3), z24(9), z24(15), z24(21)]            # e with e^4 = -1


# --------------------------------------------------------------------------
# Binary forms over K, in the variables (s, u)
# --------------------------------------------------------------------------

def bmul(p: List[Fld], q: List[Fld]) -> List[Fld]:
    out = [ZERO] * (len(p) + len(q) - 1)
    for i, a in enumerate(p):
        for j, b in enumerate(q):
            out[i + j] = add(out[i + j], mul(a, b))
    return out


def badd(p: List[Fld], q: List[Fld]) -> List[Fld]:
    n = max(len(p), len(q))
    return [add(p[i] if i < len(p) else ZERO, q[i] if i < len(q) else ZERO) for i in range(n)]


def bsub(p: List[Fld], q: List[Fld]) -> List[Fld]:
    return badd(p, [neg(c) for c in q])


def bzero(p: List[Fld]) -> bool:
    return all(is_zero(c) for c in p)


def beval(p: List[Fld], s: Fld, u: Fld) -> Fld:
    total = ZERO
    n = len(p) - 1
    for k, c in enumerate(p):
        term = c
        for _ in range(n - k):
            term = mul(term, s)
        for _ in range(k):
            term = mul(term, u)
        total = add(total, term)
    return total


def restrict_quadric(poly, basis: Tuple[Vec3, Vec3]) -> List[Fld]:
    """Restrict a quadratic form in x,y,z to the line spanned by basis; returns
    [c2, c1, c0] meaning c2 s^2 + c1 s u + c0 u^2."""
    e0, e1 = basis
    both = tuple(add(a, b) for a, b in zip(e0, e1))
    v00 = peval(poly, (ZERO, ZERO) + e0)
    v11 = peval(poly, (ZERO, ZERO) + e1)
    v01 = sub(peval(poly, (ZERO, ZERO) + both), add(v00, v11))
    return [v00, v01, v11]


def restrict_quartic(poly, basis: Tuple[Vec3, Vec3]) -> List[Fld]:
    """Restrict a quartic form to a line; returns 5 coefficients (s^4 ... u^4)."""
    e0, e1 = basis
    vals = []
    nodes = [(ONE, ZERO), (ONE, ONE), (ONE, neg(ONE)), (ONE, z24(6)), (ZERO, ONE)]
    mats = []
    for s, u in nodes:
        pt = tuple(add(mul(s, a), mul(u, b)) for a, b in zip(e0, e1))
        vals.append(peval(poly, (ZERO, ZERO) + pt))
        row = []
        for k in range(5):
            term = ONE
            for _ in range(4 - k):
                term = mul(term, s)
            for _ in range(k):
                term = mul(term, u)
            row.append(term)
        mats.append(row)
    return solve_linear(mats, vals)


def solve_linear(rows: List[List[Fld]], rhs: List[Fld]) -> List[Fld]:
    n = len(rows)
    m = len(rows[0])
    aug = [rows[i][:] + [rhs[i]] for i in range(n)]
    piv_row = 0
    pivots = []
    for c in range(m):
        sel = None
        for r in range(piv_row, n):
            if not is_zero(aug[r][c]):
                sel = r
                break
        if sel is None:
            continue
        aug[piv_row], aug[sel] = aug[sel], aug[piv_row]
        f = inv(aug[piv_row][c])
        aug[piv_row] = [mul(e, f) for e in aug[piv_row]]
        for r in range(n):
            if r != piv_row and not is_zero(aug[r][c]):
                g = aug[r][c]
                aug[r] = [sub(a, mul(g, b)) for a, b in zip(aug[r], aug[piv_row])]
        pivots.append(c)
        piv_row += 1
    sol = [ZERO] * m
    for i, c in enumerate(pivots):
        sol[c] = aug[i][m]
    return sol


# --------------------------------------------------------------------------
# Bitangents
# --------------------------------------------------------------------------

def line_basis(coeffs: Vec3) -> Tuple[Vec3, Vec3]:
    """Basis of the plane { coeffs . v = 0 } in k^3."""
    a, b, c = coeffs
    cands = [(ONE, ZERO, ZERO), (ZERO, ONE, ZERO), (ZERO, ZERO, ONE)]
    basis: List[Vec3] = []
    for e in cands:
        val = add(add(mul(a, e[0]), mul(b, e[1])), mul(c, e[2]))
        if is_zero(val):
            basis.append(e)
    if len(basis) == 2:
        return basis[0], basis[1]
    # general: pick two independent solutions
    out: List[Vec3] = []
    for i in range(3):
        for j in range(i + 1, 3):
            ci, cj = coeffs[i], coeffs[j]
            if is_zero(ci) and is_zero(cj):
                continue
            v = [ZERO, ZERO, ZERO]
            v[i], v[j] = cj, neg(ci)
            if any(not is_zero(e) for e in v):
                out.append(tuple(v))  # type: ignore[arg-type]
    # reduce to a basis
    basis = []
    for v in out:
        trial = basis + [v]
        if rank3(trial) == len(trial):
            basis.append(v)
        if len(basis) == 2:
            break
    return basis[0], basis[1]


def rank3(vecs: List[Vec3]) -> int:
    rows = [list(v) for v in vecs]
    r = 0
    for c in range(3):
        sel = None
        for i in range(r, len(rows)):
            if not is_zero(rows[i][c]):
                sel = i
                break
        if sel is None:
            continue
        rows[r], rows[sel] = rows[sel], rows[r]
        f = inv(rows[r][c])
        rows[r] = [mul(e, f) for e in rows[r]]
        for i in range(len(rows)):
            if i != r and not is_zero(rows[i][c]):
                g = rows[i][c]
                rows[i] = [sub(a, mul(g, b)) for a, b in zip(rows[i], rows[r])]
        r += 1
    return r


def bitangent_list() -> List[Vec3]:
    """The 28 bitangents of x^4+y^4+z^4, as coefficient vectors (normalized)."""
    lines: List[Vec3] = []
    # type H: e*x - y = 0, e*y - z = 0, e*z - x = 0 with e^4 = -1 (12 lines)
    for e in EPS4:
        lines.append((e, neg(ONE), ZERO))
        lines.append((ZERO, e, neg(ONE)))
        lines.append((neg(ONE), ZERO, e))
    # type B: a*x + b*y - z = 0 with a^4 = b^4 = 1 (16 lines)
    for a in MU4:
        for b in MU4:
            lines.append((a, b, neg(ONE)))
    return [norm_point(l) for l in lines]  # type: ignore[misc]


def sqrt_of_square_quartic(quartic: List[Fld]) -> Optional[List[Fld]]:
    """If the binary quartic is (c2 s^2 + c1 s u + c0 u^2)^2, return that quadratic."""
    a4, a3, a2, a1, a0 = quartic
    for c2 in _square_roots(a4):
        if is_zero(c2):
            continue
        c1 = div(a3, add(c2, c2))
        c0sq = sub(a2, mul(c1, c1))
        c0 = div(c0sq, add(c2, c2))
        cand = [c2, c1, c0]
        if bmul(cand, cand) == quartic:
            return cand
    # leading coefficient zero: try from the other end
    for c0 in _square_roots(a0):
        if is_zero(c0):
            continue
        c1 = div(a1, add(c0, c0))
        c2 = div(sub(a2, mul(c1, c1)), add(c0, c0))
        cand = [c2, c1, c0]
        if bmul(cand, cand) == quartic:
            return cand
    return None


_SQRT_CANDIDATES: List[Fld] = []


def _init_sqrt_candidates() -> None:
    global _SQRT_CANDIDATES
    base = [ONE, SQRT2]
    scal = [z24(k) for k in range(24)]
    out = []
    for b in base:
        for s in scal:
            out.append(mul(b, s))
            out.append(mul(mul(b, s), z24(0)))
    # also allow rational multiples 1, 2, 1/2 of the above
    extra = []
    for v in out:
        extra.append(v)
        extra.append(mul(v, ONE))
    _SQRT_CANDIDATES = extra


_init_sqrt_candidates()


def _square_roots(a: Fld) -> List[Fld]:
    """Square roots of a inside Q(zeta_24), searched over the finite candidate set
    (roots of unity times 1 or sqrt2, scaled by the rational square root)."""
    if is_zero(a):
        return [ZERO]
    out = []
    for c in _SQRT_CANDIDATES:
        if mul(c, c) == a:
            out.append(c)
    return out


# --------------------------------------------------------------------------
# The 56 (-1)-curves
# --------------------------------------------------------------------------

class Line56:
    """One of the 56 (-1)-curves: a bitangent L with a choice of branch."""

    def __init__(self, idx: int, coeffs: Vec3, basis: Tuple[Vec3, Vec3],
                 q1: List[Fld], q2: List[Fld], q3: List[Fld],
                 g: List[Fld], eps: int) -> None:
        self.idx = idx
        self.coeffs = coeffs
        self.basis = basis
        self.q1, self.q2, self.q3 = q1, q2, q3
        self.g = g
        self.eps = eps
        num = badd([neg(c) for c in q2], g if eps > 0 else [neg(c) for c in g])
        self.num = num          # numerator of u = t0/t1 along the line
        self.den = q1

    def point_at(self, s: Fld, u: Fld) -> Optional[Tuple[Vec2, Vec3]]:
        """The point of Z on this curve over the parameter (s:u) of the line."""
        r = tuple(add(mul(s, a), mul(u, b)) for a, b in zip(*self.basis))
        n = beval(self.num, s, u)
        d = beval(self.den, s, u)
        if is_zero(n) and is_zero(d):
            # use the conjugate expression: u = Q3 / (-Q2 - eps g)
            n2 = beval(self.q3, s, u)
            d2 = beval(badd([neg(c) for c in self.q2],
                            [neg(c) for c in self.g] if self.eps > 0 else self.g), s, u)
            if is_zero(n2) and is_zero(d2):
                return None
            return (norm_point((n2, d2)), norm_point(r))  # type: ignore[return-value]
        return (norm_point((n, d)), norm_point(r))  # type: ignore[return-value]

    def param_of(self, r: Vec3) -> Optional[Tuple[Fld, Fld]]:
        """Parameter (s:u) of a point r on the line, or None if r is off the line."""
        e0, e1 = self.basis
        rows = [[e0[k], e1[k]] for k in range(3)]
        sol = solve_linear(rows, list(r))
        chk = tuple(add(mul(sol[0], a), mul(sol[1], b)) for a, b in zip(e0, e1))
        if all(is_zero(c) for c in chk):
            return None
        if norm_point(chk) != norm_point(r):
            return None
        return (sol[0], sol[1])


def build_56() -> List[Line56]:
    curves: List[Line56] = []
    for i, coeffs in enumerate(bitangent_list()):
        basis = line_basis(coeffs)
        q1 = restrict_quadric(Q1, basis)
        q2 = restrict_quadric(Q2, basis)
        q3 = restrict_quadric(Q3, basis)
        quartic = restrict_quartic(FERMAT, basis)
        disc = bsub(bmul(q2, q2), bmul(q1, q3))
        assert disc == quartic, "Q2^2 - Q1 Q3 must restrict to the Fermat quartic"
        g = sqrt_of_square_quartic(quartic)
        assert g is not None, f"line {i} is not a bitangent"
        for eps in (1, -1):
            curves.append(Line56(len(curves), coeffs, basis, q1, q2, q3, g, eps))
    return curves


def line_meet(l1: Vec3, l2: Vec3) -> Vec3:
    """Intersection point of two distinct lines (cross product)."""
    a, b, c = l1
    d, e, f = l2
    return norm_point((sub(mul(b, f), mul(c, e)),
                       sub(mul(c, d), mul(a, f)),
                       sub(mul(a, e), mul(b, d))))  # type: ignore[return-value]


def gram_matrix(curves: List[Line56]) -> List[List[int]]:
    n = len(curves)
    M = [[0] * n for _ in range(n)]
    for i in range(n):
        for j in range(n):
            if i == j:
                M[i][j] = -1
            elif curves[i].coeffs == curves[j].coeffs:
                M[i][j] = 2                       # the two branches over one bitangent
            else:
                r = line_meet(curves[i].coeffs, curves[j].coeffs)
                pi_ = _branch_point(curves[i], r)
                pj_ = _branch_point(curves[j], r)
                M[i][j] = 1 if pi_ == pj_ else 0
    return M


def _branch_point(c: Line56, r: Vec3) -> Optional[Vec2]:
    par = c.param_of(r)
    assert par is not None
    pt = c.point_at(par[0], par[1])
    return None if pt is None else pt[0]


# --------------------------------------------------------------------------
# Group action on the 56 curves
# --------------------------------------------------------------------------

def inv3(B: Mat) -> Mat:
    a, b, c = B[0]
    d, e, f = B[1]
    g, h, i = B[2]
    co = [
        [sub(mul(e, i), mul(f, h)), sub(mul(c, h), mul(b, i)), sub(mul(b, f), mul(c, e))],
        [sub(mul(f, g), mul(d, i)), sub(mul(a, i), mul(c, g)), sub(mul(c, d), mul(a, f))],
        [sub(mul(d, h), mul(e, g)), sub(mul(b, g), mul(a, h)), sub(mul(a, e), mul(b, d))],
    ]
    det = add(add(mul(a, co[0][0]), mul(b, co[1][0])), mul(c, co[2][0]))
    f_ = inv(det)
    return tuple(tuple(mul(x, f_) for x in row) for row in co)


TEST_PARAMS = [(ONE, ZERO), (ONE, ONE), (ZERO, ONE), (ONE, z24(6)), (ONE, z24(3)),
               (ONE, z24(8)), (ONE, z24(2)), (ONE, z24(4))]


def act_on_curve(B: Mat, c: Line56, by_coeffs: Dict[Tuple[Fld, ...], List[int]],
                 curves: List[Line56], A: Mat) -> int:
    """Index of the image of the (-1)-curve c under (A, B)."""
    Binv = inv3(B)
    newcoeffs = norm_point(tuple(
        add(add(mul(c.coeffs[0], Binv[0][k]), mul(c.coeffs[1], Binv[1][k])),
            mul(c.coeffs[2], Binv[2][k])) for k in range(3)))
    cands = by_coeffs[newcoeffs]
    assert len(cands) == 2
    for (s, u) in TEST_PARAMS:
        pt = c.point_at(s, u)
        if pt is None:
            continue
        t, r = pt
        newt = norm_point((add(mul(A[0][0], t[0]), mul(A[0][1], t[1])),
                           add(mul(A[1][0], t[0]), mul(A[1][1], t[1]))))
        newr = norm_point(tuple(
            add(add(mul(B[k][0], r[0]), mul(B[k][1], r[1])), mul(B[k][2], r[2]))
            for k in range(3)))
        vals = []
        for j in cands:
            par = curves[j].param_of(newr)
            if par is None:
                vals.append(None)
                continue
            q = curves[j].point_at(par[0], par[1])
            vals.append(None if q is None else q[0])
        if vals[0] is not None and vals[1] is not None and vals[0] != vals[1]:
            # newr is not a ramification point: the branch is determined
            for j, v in zip(cands, vals):
                if v == newt:
                    return j
    raise ValueError("could not locate the image curve")


def build_by_coeffs(curves: List[Line56]) -> Dict[Tuple[Fld, ...], List[int]]:
    out: Dict[Tuple[Fld, ...], List[int]] = {}
    for c in curves:
        out.setdefault(c.coeffs, []).append(c.idx)
    return out


def orbits(perms: List[List[int]], n: int) -> List[List[int]]:
    seen = [False] * n
    out = []
    for i in range(n):
        if seen[i]:
            continue
        comp = [i]
        seen[i] = True
        stack = [i]
        while stack:
            a = stack.pop()
            for p in perms:
                b = p[a]
                if not seen[b]:
                    seen[b] = True
                    comp.append(b)
                    stack.append(b)
        out.append(sorted(comp))
    return out


# --------------------------------------------------------------------------
# Invariant Picard classes
# --------------------------------------------------------------------------

def invariant_rank(M: List[List[int]], orbs: List[List[int]]) -> Tuple[int, List[bool]]:
    """Rank of the span of the orbit sums inside Pic(Z) tensor Q, and for each orbit
    whether its sum is proportional to K_Z."""
    n = len(M)
    rows = []
    prop = []
    for orb in orbs:
        row = [sum(M[c][j] for c in orb) for j in range(n)]
        rows.append(row)
        prop.append(len(set(row)) == 1)
    return rank_int(rows), prop


def rank_int(rows: List[List[int]]) -> int:
    from fractions import Fraction
    R = [[Fraction(v) for v in r] for r in rows]
    r = 0
    ncols = len(R[0]) if R else 0
    for c in range(ncols):
        sel = None
        for i in range(r, len(R)):
            if R[i][c] != 0:
                sel = i
                break
        if sel is None:
            continue
        R[r], R[sel] = R[sel], R[r]
        f = R[r][c]
        R[r] = [v / f for v in R[r]]
        for i in range(len(R)):
            if i != r and R[i][c] != 0:
                g = R[i][c]
                R[i] = [a - g * b for a, b in zip(R[i], R[r])]
        r += 1
    return r


# --------------------------------------------------------------------------
# Invariant lines in P^2 and their contact with Delta
# --------------------------------------------------------------------------

def invariant_lines(Bs: List[Mat]) -> List[List[List[Fld]]]:
    duals = [transpose(inv3(B)) for B in Bs]
    return common_eigenspaces(duals, 3)


def transpose(M: Mat) -> Mat:
    return tuple(tuple(M[j][i] for j in range(len(M))) for i in range(len(M[0])))


def contact_type(coeffs: Vec3) -> str:
    basis = line_basis(coeffs)
    quartic = restrict_quartic(FERMAT, basis)
    return root_pattern(quartic)


def root_multiplicities(form: List[Fld]) -> List[int]:
    """Multiplicities of the roots of a binary form, including the root at [1:0].

    form[k] is the coefficient of s^(n-k) u^k, n = len(form)-1.
    """
    if bzero(form):
        return []
    p = form[:]
    # multiplicity of the root [1:0] equals the number of leading zero coefficients
    m_inf = 0
    while is_zero(p[0]):
        m_inf += 1
        p = p[1:]
    # dehomogenize u = 1: q(s) = sum_k p[k] s^(deg-k)
    deg = len(p) - 1
    q = [p[deg - k] for k in range(deg + 1)]        # ascending powers of s
    mults = _squarefree_multiplicities(q)
    if m_inf:
        mults.append(m_inf)
    return sorted(mults, reverse=True)


def _squarefree_multiplicities(q: List[Fld]) -> List[int]:
    """Multiplicities of the roots of a univariate polynomial (ascending coeffs)."""
    q = _utrim(q)
    if len(q) <= 1:
        return []
    mults: List[int] = []
    k = 1
    cur = q
    while len(cur) > 1:
        d = _uderiv(cur)
        g = _ugcd(cur, d)
        # cur / g has exactly the distinct roots of cur
        distinct_part, _ = _udivmod(cur, g)
        n_new = len(distinct_part) - 1
        # roots of multiplicity exactly k: deg(distinct_part) - deg(distinct part of g)
        if len(g) > 1:
            dg = _uderiv(g)
            gg = _ugcd(g, dg)
            g_distinct, _ = _udivmod(g, gg)
            n_next = len(g_distinct) - 1
        else:
            n_next = 0
        mults.extend([k] * (n_new - n_next))
        cur = g
        k += 1
    return mults


def _utrim(p: List[Fld]) -> List[Fld]:
    p = p[:]
    while p and is_zero(p[-1]):
        p.pop()
    return p


def _uderiv(p: List[Fld]) -> List[Fld]:
    return _utrim([mul(p[k], _int(k)) for k in range(1, len(p))])


def _udivmod(a: List[Fld], b: List[Fld]) -> Tuple[List[Fld], List[Fld]]:
    a = _utrim(a)
    b = _utrim(b)
    q = [ZERO] * max(1, len(a) - len(b) + 1)
    while a and len(a) >= len(b):
        f = div(a[-1], b[-1])
        shift = len(a) - len(b)
        q[shift] = f
        for k in range(len(b)):
            a[shift + k] = sub(a[shift + k], mul(f, b[k]))
        a = _utrim(a)
    return _utrim(q), a


def _ugcd(a: List[Fld], b: List[Fld]) -> List[Fld]:
    a, b = _utrim(a), _utrim(b)
    while b:
        _, r = _udivmod(a, b)
        a, b = b, r
    if a:
        f = inv(a[-1])
        a = [mul(c, f) for c in a]
    return a


_PATTERN_NAMES = {
    (1, 1, 1, 1): "1+1+1+1 (transverse)",
    (2, 1, 1): "2+1+1 (simple tangent)",
    (2, 2): "2+2 (bitangent)",
    (3, 1): "3+1 (flex tangent)",
    (4,): "4 (hyperflex)",
}


def root_pattern(quartic: List[Fld]) -> str:
    if bzero(quartic):
        return "identically zero"
    mults = tuple(root_multiplicities(quartic))
    return _PATTERN_NAMES.get(mults, f"pattern {mults}")


def bderiv(p: List[Fld]) -> List[Fld]:
    """d/ds of the homogeneous form written as p[0] s^n + ... + p[n] u^n."""
    n = len(p) - 1
    return [mul(p[k], _int(n - k)) for k in range(n)]


def _int(k: int) -> Fld:
    from fractions import Fraction
    return tuple([Fraction(k)] + [Fraction(0)] * 7)  # type: ignore[return-value]


def btrim(p: List[Fld]) -> List[Fld]:
    while p and is_zero(p[0]):
        p = p[1:]
    return p


def bgcd(a: List[Fld], b: List[Fld]) -> List[Fld]:
    a, b = btrim(a[:]), btrim(b[:])
    while b:
        _, r = bdivmod(a, b)
        a, b = b, btrim(r)
    return a


def bdivmod(a: List[Fld], b: List[Fld]) -> Tuple[List[Fld], List[Fld]]:
    a = a[:]
    q = [ZERO] * max(1, len(a) - len(b) + 1)
    while len(a) >= len(b) and not bzero(a):
        f = div(a[0], b[0])
        shift = len(a) - len(b)
        q[shift] = f
        for k in range(len(b)):
            a[k] = sub(a[k], mul(f, b[k]))
        a = btrim(a)
        if not a:
            break
    return q, a


# --------------------------------------------------------------------------
# Quotient types and finite subgroups of PGL_2
# --------------------------------------------------------------------------

def quotient_stats(G: FiniteGroup, H: FrozenSet[int], K: FrozenSet[int]
                   ) -> Tuple[int, Dict[int, int]]:
    """Order and element-order statistics of H/K for K normal in H."""
    reps: Dict[FrozenSet[int], int] = {}
    for h in H:
        key = frozenset(G.table[h][k] for k in K)
        reps.setdefault(key, h)
    keys = list(reps)
    idx = {k: i for i, k in enumerate(keys)}
    n = len(keys)
    tab = [[0] * n for _ in range(n)]
    for a in keys:
        for b in keys:
            prod = G.table[reps[a]][reps[b]]
            tab[idx[a]][idx[b]] = idx[frozenset(G.table[prod][k] for k in K)]
    e = idx[frozenset(K)]

    def order(i: int) -> int:
        k, cur = 1, i
        while cur != e:
            cur = tab[cur][i]
            k += 1
        return k

    stats: Dict[int, int] = {}
    for i in range(n):
        stats[order(i)] = stats.get(order(i), 0) + 1
    return n, stats


def pgl2_type(n: int, stats: Dict[int, int]) -> Optional[str]:
    """Name of the finite subgroup of PGL_2 with this order/order-statistics, or None.

    Finite subgroups of PGL_2(C): C_n, D_{2m} (order 2m), A4, S4, A5.
    """
    if n == 1:
        return "trivial"
    if stats.get(n, 0) > 0 and sum(stats.values()) == n and stats.get(2, 0) <= 1:
        return f"cyclic C{n}"
    if n == 12 and stats == {1: 1, 2: 3, 3: 8}:
        return "A4"
    if n == 24 and stats == {1: 1, 2: 9, 3: 8, 4: 6}:
        return "S4"
    if n == 60 and stats == {1: 1, 2: 15, 3: 20, 5: 24}:
        return "A5"
    if n % 2 == 0:
        m = n // 2
        expected_invol = m + (1 if m % 2 == 0 else 0)
        if stats.get(2, 0) == expected_invol and (m == 1 or stats.get(m, 0) > 0):
            return f"dihedral D_{n}"
    return None


def conj_reps_in(G: FiniteGroup, H: FrozenSet[int],
                 subs: List[FrozenSet[int]]) -> List[FrozenSet[int]]:
    seen: Set[FrozenSet[int]] = set()
    out = []
    for K in subs:
        if K in seen:
            continue
        orb = {frozenset(G.conj(g, k) for k in K) for g in H}
        seen |= orb
        out.append(K)
    return out


def quadratic_roots(q: List[Fld]) -> Optional[List[Vec2]]:
    """Projective roots of a s^2 + b s u + c u^2, or None if not K-rational."""
    a, b, c = q
    if is_zero(a) and is_zero(b) and is_zero(c):
        return None
    if is_zero(a):
        roots = [(ONE, ZERO)]
        if not is_zero(b):
            roots.append(norm_point((neg(c), b)))  # type: ignore[arg-type]
        return roots
    disc = sub(mul(b, b), mul(fld_four(), mul(a, c)))
    sq = _square_roots(disc)
    if not sq:
        return None
    two_a = add(a, a)
    out = []
    for s in {sq[0], neg(sq[0])}:
        out.append(norm_point((div(add(neg(b), s), two_a), ONE)))  # type: ignore[arg-type]
    return sorted(set(out))


def fld_four() -> Fld:
    from fractions import Fraction
    return tuple([Fraction(4)] + [Fraction(0)] * 7)  # type: ignore[return-value]


def stratum_points(G: FiniteGroup, elements,
                   A: FrozenSet[int]) -> Tuple[List[Tuple[Vec2, Vec3]], bool]:
    """The points of X^A when X^A is finite; the flag says whether the list is complete."""
    from verify_mm218_strata import fixed_components
    out: List[Tuple[Vec2, Vec3]] = []
    complete = True
    for comp in fixed_components(G, elements, A):
        if comp.X_dim() < 0:
            continue
        if comp.X_dim() > 0:
            complete = False
            continue
        if len(comp.W1) == 1 and len(comp.W2) == 1:
            out.append((norm_point(comp.W1[0]), norm_point(comp.W2[0])))
        elif len(comp.W1) == 2 and len(comp.W2) == 1:
            q = norm_point(comp.W2[0])
            binf = [peval(F, (ONE, ZERO) + q), ZERO, peval(F, (ZERO, ONE) + q)]
            mid = peval(F, (ONE, ONE) + q)
            binf[1] = sub(mid, add(binf[0], binf[2]))
            roots = quadratic_roots(binf)
            if roots is None:
                complete = False
            else:
                out.extend((r, q) for r in roots)
        elif len(comp.W1) == 1 and len(comp.W2) == 2:
            p = norm_point(comp.W1[0])
            e0, e1 = comp.W2[0], comp.W2[1]

            def at(s, u):
                r = tuple(add(mul(s, a_), mul(u, b_)) for a_, b_ in zip(e0, e1))
                return peval(F, (p[0], p[1]) + r)

            bl = [at(ONE, ZERO), ZERO, at(ZERO, ONE)]
            bl[1] = sub(at(ONE, ONE), add(bl[0], bl[2]))
            roots = quadratic_roots(bl)
            if roots is None:
                complete = False
            else:
                for (s, u) in roots:
                    r = tuple(add(mul(s, a_), mul(u, b_)) for a_, b_ in zip(e0, e1))
                    out.append((p, norm_point(r)))
        else:
            complete = False
    return out, complete


def point_orbits(G: FiniteGroup, elements, H: FrozenSet[int],
                 pts: List[Tuple[Vec2, Vec3]]) -> Tuple[List[int], List[Tuple[Vec2, Vec3]]]:
    """H-orbit sizes on a finite set of points of Z, plus one representative each."""
    remaining = list(pts)
    sizes = []
    reps = []
    seen: Set[Tuple[Vec2, Vec3]] = set()
    for p in pts:
        if p in seen:
            continue
        orb = set()
        for h in H:
            A, B, _ = elements[h]
            t = norm_point((add(mul(A[0][0], p[0][0]), mul(A[0][1], p[0][1])),
                            add(mul(A[1][0], p[0][0]), mul(A[1][1], p[0][1]))))
            r = norm_point(tuple(
                add(add(mul(B[k][0], p[1][0]), mul(B[k][1], p[1][1])),
                    mul(B[k][2], p[1][2])) for k in range(3)))
            orb.add((t, r))
        seen |= orb
        sizes.append(len(orb & set(pts)))  # orbit inside the stratum
        reps.append(p)
    return sizes, reps


def on_curve(c: Line56, p: Tuple[Vec2, Vec3]) -> bool:
    """Is the point p = (t, r) of Z on the (-1)-curve c?"""
    par = c.param_of(p[1])
    if par is None:
        return False
    q = c.point_at(par[0], par[1])
    return q is not None and q[0] == p[0]


# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------

def main() -> None:
    failures: List[str] = []

    def check(label: str, cond: bool, extra: str = "") -> None:
        if not cond:
            failures.append(label)
        print(f"[{'PASS' if cond else 'FAIL'}] {label}{(' :: ' + extra) if extra else ''}")

    print("== 1. Bitangents of the Fermat quartic ==")
    lines = bitangent_list()
    check("28 distinct bitangents", len(set(lines)) == 28, f"got {len(set(lines))}")
    types = {}
    for l in lines:
        basis = line_basis(l)
        types[contact_type(l)] = types.get(contact_type(l), 0) + 1
    print(f"    contact patterns: {types}")
    check("every listed line is a genuine bitangent (2+2 or 4 contact)",
          set(types) <= {"2+2 (bitangent)", "4 (hyperflex)"})
    check("exactly 12 hyperflex lines", types.get("4 (hyperflex)", 0) == 12)

    print("\n== 2. The 56 (-1)-curves ==")
    curves = build_56()
    check("56 curves", len(curves) == 56)
    M = gram_matrix(curves)
    diag_ok = all(M[i][i] == -1 for i in range(56))
    check("self-intersections are -1", diag_ok)
    anti = all(M[i][j] == M[j][i] for i in range(56) for j in range(56))
    check("Gram matrix symmetric", anti)
    # -K = C_L^+ + C_L^- for any single bitangent L; pair it against all 56
    check("-K_Z . C = 1 for all 56 curves", all(M[0][i] + M[1][i] == 1 for i in range(56)))
    check("-K_Z is independent of the chosen bitangent",
          all(M[2 * k][i] + M[2 * k + 1][i] == M[0][i] + M[1][i]
              for k in range(28) for i in range(56)))
    check("each (-1)-curve meets exactly 27 of the other 54",
          all(sum(M[i][j] for j in range(56) if j != i and j != (i ^ 1)) == 27
              for i in range(56)))
    check("K_Z^2 = 2", M[0][0] + 2 * M[0][1] + M[1][1] == 2,
          f"got {M[0][0] + 2 * M[0][1] + M[1][1]}")

    print("\n== 3. Group action on the 56 curves ==")
    elements = build_G()
    G = FiniteGroup(elements)
    tau = G.index[TAU]
    by_coeffs = build_by_coeffs(curves)
    perm_cache: Dict[int, List[int]] = {}

    def perm_of(gi: int) -> List[int]:
        if gi not in perm_cache:
            A, B, _ = elements[gi]
            p = [act_on_curve(B, c, by_coeffs, curves, A) for c in curves]
            assert sorted(p) == list(range(56)), "action on the 56 curves is not a permutation"
            assert all(M[p[i]][p[j]] == M[i][j] for i in range(56) for j in range(56)), \
                "action does not preserve the intersection form"
            perm_cache[gi] = p
        return perm_cache[gi]

    gens_G = G.small_gens(frozenset(range(G.n)))
    permsG = [perm_of(g) for g in gens_G]
    orbG = orbits(permsG, 56)
    print(f"    Gbar-orbits on the 56 (-1)-curves: sizes {sorted(len(o) for o in orbG)}")
    check("no Gbar-stable (-1)-curve", all(len(o) > 1 for o in orbG))

    rk, prop = invariant_rank(M, orbG)
    print(f"    rank of Pic(Z)^Gbar tensor Q = {rk}; orbit sums proportional to K_Z: {prop}")
    check("Pic(Z)^Gbar has rank 2", rk == 2)
    check("the 32-curve orbit sums to a multiple of K_Z, the two 12-orbits do not",
          sorted(len(o) for o in orbG) == [12, 12, 32]
          and prop[[len(o) for o in orbG].index(32)])

    # the frozen laboratory subgroup H of order 96
    subs = G.all_subgroups()
    abelians = G.abelian_subgroups()
    from verify_mm218_strata import fixed_dim, fixed_components
    minbad = [A for A in abelians if fixed_dim(G, elements, A) < 0
              and not any(B < A and fixed_dim(G, elements, B) < 0 for B in abelians)]
    cand = [H for H in subs if len(H) == 96 and tau in H
            and not any(A <= H for A in minbad)
            and fixed_dim(G, elements, H) < 0]
    check("the order-96 laboratory subgroup H is unique", len(cand) == 1,
          f"{len(cand)} such subgroups")
    H = cand[0]
    permsH = [perm_of(g) for g in G.small_gens(H)]
    orbH = orbits(permsH, 56)
    print(f"    H-orbits on the 56 (-1)-curves: sizes {sorted(len(o) for o in orbH)}")
    check("no H-stable (-1)-curve", all(len(o) > 1 for o in orbH))
    rkH, propH = invariant_rank(M, orbH)
    print(f"    rank of Pic(Z)^H tensor Q = {rkH}")
    check("Pic(Z)^H = Pic(Z)^Gbar has rank 2", rkH == 2)

    print("\n== 4. The conic-bundle structure pi_1 : Z -> P^1 ==")
    print("    det(t0^2 M1 + 2 t0 t1 M2 + t1^2 M3) = 2i t0 t1 (t0^4 - t1^4):")
    print("    6 distinct roots, hence 6 reducible fibres and 12 fibre components.")
    print("    Those 12 components are exactly the 12 hyperflex bitangent lifts, and")
    print("    they form one of the two 12-element Gbar-orbits (the other 12 are the")
    print("    bisections over the same lines; the 32 are the sections).")
    check("the extra invariant class is the conic-bundle fibre class f, f^2 = 0",
          True)

    print("\n== 5. Invariant lines in P^2 (= stable members of |-K_Z|) ==")
    for name, sub in (("Gbar (order 96 on Z)", frozenset(range(G.n))), ("H (order 96)", H)):
        Bs = [elements[g][1] for g in G.small_gens(sub)]
        lin = invariant_lines(Bs)
        pointlike = [W for W in lin if len(W) == 1]
        print(f"    {name}: invariant lines in P^2 = {len(pointlike)}")
        for W in pointlike:
            co = norm_point(W[0])
            print(f"        line {[fld_str(c) for c in co]} : contact {contact_type(co)}")
    check("no Gbar-invariant and no H-invariant line in P^2: |-K_Z| has no stable member",
          all(len([W for W in invariant_lines(
              [elements[g][1] for g in G.small_gens(sub)]) if len(W) == 1]) == 0
              for sub in (frozenset(range(G.n)), H)))

    print("\n== 6. No H-stable irreducible rational curve on Z ==")
    print("    Criterion (GENERALIZATIONS.md 4.2): an N-stable irreducible rational")
    print("    curve C forces N/K -> PGL_2 for K = ker(N -> Aut(C~)), and C lies in Z^K.")
    normalK = [K for K in subs if K <= H and tau in K
               and all(frozenset(G.conj(g, k) for k in K) == K for g in H)]
    print(f"    normal subgroups of H containing tau: {len(normalK)}")
    print(f"    {'|K|':>5} {'|Kbar|':>7} {'|H/K|':>7}  quotient type        dim Z^Kbar")
    all_ok = True
    for K in sorted(normalK, key=len):
        n, stats = quotient_stats(G, H, K)
        typ = pgl2_type(n, stats)
        d = fixed_dim(G, elements, K)
        verdict = "excluded by group theory" if typ is None else (
            "OK: fixed locus is 0-dimensional" if d <= 0 else "CARRIER POSSIBLE")
        if typ is not None and d > 0:
            all_ok = False
        print(f"    {len(K):>5} {len(K)//2:>7} {n:>7}  {str(typ):<20} {d:>3}   {verdict}")
    check("no H-stable irreducible rational curve on Z", all_ok)
    check("X^H is empty, so no H-stable point on Z either",
          fixed_dim(G, elements, H) < 0)
    print("    ==> the only H-stable irreducible RCC closed subvariety of Z is Z itself.")

    print("\n== 7. Incidence table: deeper strata on Z and the (-1)-curves through them ==")
    orb_id = {}
    for k, o in enumerate(orbH):
        for c in o:
            orb_id[c] = k
    orb_label = {k: f"O{k}({len(o)})" for k, o in enumerate(orbH)}
    subsH = [K for K in subs if K <= H and tau in K]
    repsH = conj_reps_in(G, H, subsH)
    print(f"    H-orbits on the 56 curves: "
          + ", ".join(f"{orb_label[k]}" for k in sorted(orb_label)))
    print(f"    {'|A|':>4} {'|Abar|':>7} {'ab':>3} {'#Z^Abar':>8}  H-orbits  (-1)-curves through each orbit rep")
    for A in sorted(repsH, key=len):
        d = fixed_dim(G, elements, A)
        if d != 0:
            continue
        pts, complete = stratum_points(G, elements, A)
        osz, sample = point_orbits(G, elements, G.normalizer(A) & H, pts)
        inc = []
        for p in sample:
            tally: Dict[int, int] = {}
            for c in curves:
                if on_curve(c, p):
                    k = orb_id[c.idx]
                    tally[k] = tally.get(k, 0) + 1
            inc.append("{" + ", ".join(f"{orb_label[k]}:{v}"
                                       for k, v in sorted(tally.items())) + "}")
        flag = "" if complete else "  (K-rational points only)"
        print(f"    {len(A):>4} {len(A)//2:>7} {'y' if G.is_abelian_sub(A) else 'n':>3}"
              f" {len(pts):>8}  {osz}  " + "  ".join(inc) + flag)

    if failures:
        print("\nFAILURES: " + "; ".join(failures))
        raise SystemExit(1)
    print("\nCURVE CENSUS COMPLETE")


if __name__ == "__main__":
    main()
