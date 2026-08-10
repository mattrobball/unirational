#!/usr/bin/env python3
"""Exact model and automorphism group of the Fermat-discriminant Mori-Mukai No. 2.18 threefold.

Model (Abe, arXiv:2506.15042, the example with |Aut(X)| = 2 x |Aut(Delta)| = 192):

    P^1 x P^2 with coordinates ([t0:t1], [x:y:z]),
    Q1 = i*x^2 + y^2,   Q2 = z^2,   Q3 = i*x^2 - y^2,
    Z  = { F = 0 },  F = t0^2*Q1 + 2*t0*t1*Q2 + t1^2*Q3   (a (2,2)-divisor),
    X  = double cover of P^1 x P^2 branched along Z,
    Delta = { Q2^2 - Q1*Q3 = 0 } = { x^4 + y^4 + z^4 = 0 }  (Fermat quartic).

X sits inside the total space of O(1,1) as  w^2 = F, with the scaling
equivalence  (t, x, w) ~ (a*t, b*x, a*b*w).  An automorphism of X lying over
(A, B) in GL_2 x GL_3 is a triple (A, B, mu) acting by

    (t, x, w)  |-->  (A t, B x, mu w),          F(A t, B x) = mu^2 * F(t, x).

We normalize A in SL_2 and B in SL_3, so every group element is represented by
a matrix of finite order and all eigenvalues are 24th roots of unity.  The
residual equivalence is then the central subgroup

    Delta_6 = { (a*I2, b*I3, a*b) : a^2 = 1, b^3 = 1 },   |Delta_6| = 6,

which acts trivially on X.  Hence  G = Aut(X) = Gtilde / Delta_6  with
|Gtilde| = 1152 and |G| = 192.  The deck involution is tau = class of
(I2, I3, -1); it is central and generates ker(G -> Aut(P^1 x P^2 ; Z)).

All arithmetic is exact in K = Q(zeta_24) = Q[T]/(T^8 - T^4 + 1).

Run:  python3 verify_mm218_model.py
"""

from __future__ import annotations

from fractions import Fraction
from typing import Dict, FrozenSet, Iterable, List, Sequence, Set, Tuple

# --------------------------------------------------------------------------
# 1. Exact arithmetic in K = Q(zeta_24) = Q[T]/(Phi_24),  Phi_24 = T^8 - T^4 + 1
# --------------------------------------------------------------------------

DEG = 8  # T^8 = T^4 - 1

Fld = Tuple[Fraction, ...]


def _reduce(raw: List[Fraction]) -> Fld:
    for k in range(len(raw) - 1, DEG - 1, -1):
        c = raw[k]
        if c:
            raw[k] = Fraction(0)
            raw[k - 4] += c
            raw[k - 8] -= c
    return tuple(raw[:DEG])


def fld(*coeffs: object) -> Fld:
    out = [Fraction(0)] * DEG
    for k, c in enumerate(coeffs):
        out[k] = Fraction(c)  # type: ignore[arg-type]
    return tuple(out)


ZERO: Fld = fld()
ONE: Fld = fld(1)


def z24(k: int) -> Fld:
    """zeta_24^k, exactly."""
    k %= 24
    raw = [Fraction(0)] * 24
    raw[k] = Fraction(1)
    return _reduce(raw)


I_UNIT: Fld = z24(6)                                   # sqrt(-1)
ZETA8: Fld = z24(3)
ZETA3: Fld = z24(8)
ZETA12: Fld = z24(2)


def add(a: Fld, b: Fld) -> Fld:
    return tuple(x + y for x, y in zip(a, b))


def sub(a: Fld, b: Fld) -> Fld:
    return tuple(x - y for x, y in zip(a, b))


def neg(a: Fld) -> Fld:
    return tuple(-x for x in a)


def mul(a: Fld, b: Fld) -> Fld:
    raw = [Fraction(0)] * (2 * DEG - 1)
    for i, ai in enumerate(a):
        if ai:
            for j, bj in enumerate(b):
                if bj:
                    raw[i + j] += ai * bj
    return _reduce(raw)


def is_zero(a: Fld) -> bool:
    return not any(a)


def _trim(p: List[Fraction]) -> List[Fraction]:
    while p and p[-1] == 0:
        p.pop()
    return p


def _polydivmod(a: List[Fraction], b: List[Fraction]) -> Tuple[List[Fraction], List[Fraction]]:
    a = _trim(a[:])
    b = _trim(b[:])
    q = [Fraction(0)] * max(1, len(a) - len(b) + 1)
    while a and len(a) >= len(b):
        shift = len(a) - len(b)
        f = a[-1] / b[-1]
        q[shift] = f
        for k, bk in enumerate(b):
            a[shift + k] -= f * bk
        _trim(a)
    return q, a


def inv(a: Fld) -> Fld:
    """Inverse in K; Phi_24 is irreducible over Q so K is a field."""
    if is_zero(a):
        raise ZeroDivisionError("inverse of 0 in Q(zeta_24)")
    modulus = [Fraction(0)] * 9
    modulus[8] = Fraction(1)
    modulus[4] = Fraction(-1)
    modulus[0] = Fraction(1)                    # T^8 - T^4 + 1
    r0, r1 = modulus, _trim(list(a))
    s0: List[Fraction] = [Fraction(0)]
    s1: List[Fraction] = [Fraction(1)]
    while r1:
        q, r = _polydivmod(r0[:], r1[:])
        prod = [Fraction(0)] * (len(q) + len(s1) - 1)
        for i, qi in enumerate(q):
            for j, sj in enumerate(s1):
                prod[i + j] += qi * sj
        length = max(len(s0), len(prod))
        s = [(s0[k] if k < len(s0) else Fraction(0)) - (prod[k] if k < len(prod) else Fraction(0))
             for k in range(length)]
        r0, r1 = r1, r
        s0, s1 = s1, _trim(s)
    lead = r0[-1]
    res = [c / lead for c in s0] + [Fraction(0)] * DEG
    return _reduce(res[: 2 * DEG - 1])


def div(a: Fld, b: Fld) -> Fld:
    return mul(a, inv(b))


SQRT2: Fld = add(z24(3), z24(21))               # zeta_8 + zeta_8^{-1}
HALF: Fld = fld(Fraction(1, 2))
A4SCALE: Fld = mul(HALF, add(ONE, I_UNIT))      # (1+i)/2 = zeta_8/sqrt(2)


def fld_str(a: Fld) -> str:
    parts = []
    for k, c in enumerate(a):
        if c:
            parts.append(str(c) if k == 0 else f"{c}*z^{k}")
    return " + ".join(parts) if parts else "0"


ROOTS_OF_UNITY: List[Fld] = [z24(k) for k in range(24)]


# --------------------------------------------------------------------------
# 2. Multivariate polynomials over K in t0,t1,x,y,z
# --------------------------------------------------------------------------

VARS = ("t0", "t1", "x", "y", "z")
Mono = Tuple[int, int, int, int, int]
Poly = Dict[Mono, Fld]


def pconst(c: Fld) -> Poly:
    return {} if is_zero(c) else {(0, 0, 0, 0, 0): c}


def pvar(name: str) -> Poly:
    m = [0] * 5
    m[VARS.index(name)] = 1
    return {tuple(m): ONE}  # type: ignore[dict-item]


def padd(p: Poly, q: Poly) -> Poly:
    out = dict(p)
    for m, c in q.items():
        nc = add(out.get(m, ZERO), c)
        if is_zero(nc):
            out.pop(m, None)
        else:
            out[m] = nc
    return out


def pscale(p: Poly, c: Fld) -> Poly:
    return {} if is_zero(c) else {m: mul(v, c) for m, v in p.items()}


def pmul(p: Poly, q: Poly) -> Poly:
    out: Poly = {}
    for m1, c1 in p.items():
        for m2, c2 in q.items():
            m = tuple(a + b for a, b in zip(m1, m2))
            nc = add(out.get(m, ZERO), mul(c1, c2))  # type: ignore[arg-type]
            if is_zero(nc):
                out.pop(m, None)  # type: ignore[arg-type]
            else:
                out[m] = nc  # type: ignore[index]
    return out


def psub(p: Poly, q: Poly) -> Poly:
    return padd(p, pscale(q, neg(ONE)))


def peq(p: Poly, q: Poly) -> bool:
    return not psub(p, q)


def psubst(p: Poly, images: Dict[str, Poly]) -> Poly:
    out: Poly = {}
    for m, c in p.items():
        term = pconst(c)
        for idx, e in enumerate(m):
            for _ in range(e):
                term = pmul(term, images[VARS[idx]])
        out = padd(out, term)
    return out


def peval(p: Poly, values: Sequence[Fld]) -> Fld:
    total = ZERO
    for m, c in p.items():
        term = c
        for idx, e in enumerate(m):
            for _ in range(e):
                term = mul(term, values[idx])
        total = add(total, term)
    return total


t0, t1, x, y, z = (pvar(v) for v in VARS)


def make_F(q1: Poly, q2: Poly, q3: Poly) -> Poly:
    return padd(padd(pmul(pmul(t0, t0), q1),
                     pscale(pmul(pmul(t0, t1), q2), fld(2))),
                pmul(pmul(t1, t1), q3))


Q1 = padd(pscale(pmul(x, x), I_UNIT), pmul(y, y))
Q2 = pmul(z, z)
Q3 = psub(pscale(pmul(x, x), I_UNIT), pmul(y, y))
F = make_F(Q1, Q2, Q3)

DISCRIMINANT = psub(pmul(Q2, Q2), pmul(Q1, Q3))
FERMAT = padd(padd(pmul(pmul(x, x), pmul(x, x)), pmul(pmul(y, y), pmul(y, y))),
              pmul(pmul(z, z), pmul(z, z)))


# --------------------------------------------------------------------------
# 3. Matrices over K
# --------------------------------------------------------------------------

Mat = Tuple[Tuple[Fld, ...], ...]


def mat(rows: Sequence[Sequence[Fld]]) -> Mat:
    return tuple(tuple(r) for r in rows)


def mmul(a: Mat, b: Mat) -> Mat:
    m = len(b)
    p = len(b[0])
    out = []
    for i in range(len(a)):
        row = []
        for j in range(p):
            s = ZERO
            for k in range(m):
                if not is_zero(a[i][k]) and not is_zero(b[k][j]):
                    s = add(s, mul(a[i][k], b[k][j]))
            row.append(s)
        out.append(tuple(row))
    return tuple(out)


def eye(n: int) -> Mat:
    return tuple(tuple(ONE if i == j else ZERO for j in range(n)) for i in range(n))


def mscale(a: Mat, c: Fld) -> Mat:
    return tuple(tuple(mul(e, c) for e in row) for row in a)


def det2(a: Mat) -> Fld:
    return sub(mul(a[0][0], a[1][1]), mul(a[0][1], a[1][0]))


def det3(a: Mat) -> Fld:
    s = ZERO
    for perm, sign in (((0, 1, 2), 1), ((1, 2, 0), 1), ((2, 0, 1), 1),
                       ((0, 2, 1), -1), ((2, 1, 0), -1), ((1, 0, 2), -1)):
        term = mul(mul(a[0][perm[0]], a[1][perm[1]]), a[2][perm[2]])
        s = add(s, term if sign > 0 else neg(term))
    return s


def apply_mat(a: Mat, v: Sequence[Fld]) -> Tuple[Fld, ...]:
    out = []
    for row in a:
        s = ZERO
        for c, vi in zip(row, v):
            s = add(s, mul(c, vi))
        out.append(s)
    return tuple(out)


# --------------------------------------------------------------------------
# 4. Group elements: (A, B, mu) in SL_2 x SL_3 x K^*, modulo Delta_6
# --------------------------------------------------------------------------

Elt = Tuple[Mat, Mat, Fld]

_A_SCALARS = (ONE, neg(ONE))                 # a with a^2 = 1
_B_SCALARS = (ONE, ZETA3, mul(ZETA3, ZETA3))  # b with b^3 = 1


def canonical(g: Elt) -> Elt:
    A, B, mu = g
    best = None
    for a in _A_SCALARS:
        for b in _B_SCALARS:
            cand = (mscale(A, a), mscale(B, b), mul(mul(a, b), mu))
            key = (cand[0], cand[1], cand[2])
            if best is None or key < best:
                best = key
    return best  # type: ignore[return-value]


def gmul(g: Elt, h: Elt) -> Elt:
    return canonical((mmul(g[0], h[0]), mmul(g[1], h[1]), mul(g[2], h[2])))


IDENT: Elt = canonical((eye(2), eye(3), ONE))
TAU: Elt = canonical((eye(2), eye(3), neg(ONE)))


def substitution_check(g: Elt, poly: Poly = F) -> bool:
    A, B, mu = g
    images = {
        "t0": padd(pscale(t0, A[0][0]), pscale(t1, A[0][1])),
        "t1": padd(pscale(t0, A[1][0]), pscale(t1, A[1][1])),
        "x": padd(padd(pscale(x, B[0][0]), pscale(y, B[0][1])), pscale(z, B[0][2])),
        "y": padd(padd(pscale(x, B[1][0]), pscale(y, B[1][1])), pscale(z, B[1][2])),
        "z": padd(padd(pscale(x, B[2][0]), pscale(y, B[2][1])), pscale(z, B[2][2])),
    }
    return peq(psubst(poly, images), pscale(poly, mul(mu, mu)))


def _diag(*d: Fld) -> Mat:
    n = len(d)
    return tuple(tuple(d[i] if i == j else ZERO for j in range(n)) for i in range(n))


# Abe's generators of Aut(P^1 x P^2 ; Z), lifted to X and SL-normalized.
GEN_LIFTS: List[Elt] = [
    # tau1 : ([t0:t1],[x:y:z]) -> ([-t1:t0], [i x : y : z])
    canonical((mat([[ZERO, neg(ONE)], [ONE, ZERO]]),
               _diag(neg(ONE), I_UNIT, I_UNIT),
               neg(ONE))),
    # tau2 : ([t0:t1],[x:y:z]) -> ([t1:t0], [x : i y : z])
    canonical((mat([[ZERO, I_UNIT], [I_UNIT, ZERO]]),
               _diag(I_UNIT, neg(ONE), I_UNIT),
               neg(ONE))),
    # tau3 : ([t0:t1],[x:y:z]) -> ([i t1:t0], [y : x : z])
    canonical((mat([[ZERO, z24(9)], [ZETA8, ZERO]]),
               mat([[ZERO, neg(ONE), ZERO], [neg(ONE), ZERO, ZERO], [ZERO, ZERO, neg(ONE)]]),
               neg(I_UNIT))),
    # tau4 : ([t0:t1],[x:y:z]) -> ([t1-t0 : i(t0+t1)], [z : x : y])
    canonical((mscale(mat([[neg(ONE), ONE], [I_UNIT, I_UNIT]]), A4SCALE),
               mat([[ZERO, ZERO, ONE], [ONE, ZERO, ZERO], [ZERO, ONE, ZERO]]),
               ONE)),
]


def closure(seeds: Iterable[Elt], start: Elt = IDENT) -> List[Elt]:
    seeds = list(seeds)
    seen: Set[Elt] = {start}
    frontier = [start]
    while frontier:
        new = []
        for a in frontier:
            for s in seeds:
                b = gmul(a, s)
                if b not in seen:
                    seen.add(b)
                    new.append(b)
        frontier = new
    return sorted(seen)


def build_G() -> List[Elt]:
    return closure(GEN_LIFTS + [TAU])


# --------------------------------------------------------------------------
# 5. Abstract finite-group machinery
# --------------------------------------------------------------------------

class FiniteGroup:
    def __init__(self, elements: List[Elt], mulfn=gmul, ident: Elt = IDENT) -> None:
        self.elements = elements
        self.index = {g: i for i, g in enumerate(elements)}
        n = len(elements)
        self.n = n
        self.table = [[0] * n for _ in range(n)]
        for i, a in enumerate(elements):
            row = self.table[i]
            for j, b in enumerate(elements):
                row[j] = self.index[mulfn(a, b)]
        self.e = self.index[ident]
        self.inv = [0] * n
        for i in range(n):
            for j in range(n):
                if self.table[i][j] == self.e:
                    self.inv[i] = j
                    break

    def order(self, i: int) -> int:
        k, cur = 1, i
        while cur != self.e:
            cur = self.table[cur][i]
            k += 1
        return k

    def sub_closure(self, gens: Iterable[int]) -> FrozenSet[int]:
        gens = list(gens)
        seen = {self.e}
        frontier = [self.e]
        while frontier:
            new = []
            for a in frontier:
                ta = self.table[a]
                for s in gens:
                    b = ta[s]
                    if b not in seen:
                        seen.add(b)
                        new.append(b)
            frontier = new
        return frozenset(seen)

    def centralizer_elt(self, i: int) -> FrozenSet[int]:
        return frozenset(j for j in range(self.n) if self.table[i][j] == self.table[j][i])

    def centralizer_set(self, H: Iterable[int]) -> FrozenSet[int]:
        H = list(H)
        return frozenset(j for j in range(self.n)
                         if all(self.table[h][j] == self.table[j][h] for h in H))

    def center(self) -> FrozenSet[int]:
        return self.centralizer_set(range(self.n))

    def conj(self, g: int, h: int) -> int:
        return self.table[self.table[g][h]][self.inv[g]]

    def conjugacy_classes(self) -> List[FrozenSet[int]]:
        seen: Set[int] = set()
        out = []
        for i in range(self.n):
            if i in seen:
                continue
            cls = frozenset(self.conj(g, i) for g in range(self.n))
            seen |= cls
            out.append(cls)
        return out

    def normalizer(self, H: FrozenSet[int]) -> FrozenSet[int]:
        return frozenset(g for g in range(self.n)
                         if frozenset(self.conj(g, h) for h in H) == H)

    def is_abelian_sub(self, H: Iterable[int]) -> bool:
        H = list(H)
        return all(self.table[a][b] == self.table[b][a] for a in H for b in H)

    def small_gens(self, H: FrozenSet[int]) -> List[int]:
        gens: List[int] = []
        cur = frozenset({self.e})
        for h in sorted(H, key=lambda i: -self.order(i)):
            if h in cur:
                continue
            gens.append(h)
            cur = self.sub_closure(gens)
            if cur == H:
                break
        return gens

    def all_subgroups(self) -> List[FrozenSet[int]]:
        """Cyclic-extension enumeration; correct for solvable groups."""
        cyclics = {self.sub_closure([i]) for i in range(self.n)}
        found: Dict[FrozenSet[int], List[int]] = {}
        for H in cyclics:
            found[H] = self.small_gens(H)
        frontier = list(cyclics)
        while frontier:
            new: List[FrozenSet[int]] = []
            for H in frontier:
                if len(H) == self.n:
                    continue
                gens = found[H]
                norm = self.normalizer(H)
                for g in norm:
                    if g in H:
                        continue
                    K = self.sub_closure(gens + [g])
                    if K not in found:
                        found[K] = self.small_gens(K)
                        new.append(K)
            frontier = new
        return sorted(found, key=lambda s: (len(s), sorted(s)))

    def abelian_subgroups(self) -> List[FrozenSet[int]]:
        cyclics = {self.sub_closure([i]) for i in range(self.n)}
        found: Set[FrozenSet[int]] = set(cyclics)
        frontier = list(cyclics)
        while frontier:
            new: List[FrozenSet[int]] = []
            for H in frontier:
                cent = self.centralizer_set(H)
                for g in cent:
                    if g in H:
                        continue
                    K = self.sub_closure(list(H) + [g])
                    if K not in found and self.is_abelian_sub(K):
                        found.add(K)
                        new.append(K)
            frontier = new
        return sorted(found, key=lambda s: (len(s), sorted(s)))

    def conjugacy_reps(self, subs: Iterable[FrozenSet[int]]) -> List[FrozenSet[int]]:
        seen: Set[FrozenSet[int]] = set()
        reps = []
        for H in subs:
            if H in seen:
                continue
            orbit = {frozenset(self.conj(g, h) for h in H) for g in range(self.n)}
            seen |= orbit
            reps.append(H)
        return reps

    def structure_name(self, H: FrozenSet[int]) -> str:
        n = len(H)
        if n == 1:
            return "1"
        orders = sorted(self.order(h) for h in H)
        ab = self.is_abelian_sub(H)
        exponent = max(orders)
        tag = "abelian" if ab else "nonabelian"
        if ab and exponent == n:
            return f"C{n}"
        return f"[order {n}, exponent {exponent}, {tag}]"


# --------------------------------------------------------------------------
# 6. Linear algebra: simultaneous eigenspaces / projective fixed loci
# --------------------------------------------------------------------------

def rref(rows: List[List[Fld]]) -> List[List[Fld]]:
    rows = [r[:] for r in rows]
    if not rows:
        return []
    ncols = len(rows[0])
    piv = 0
    for c in range(ncols):
        sel = None
        for r in range(piv, len(rows)):
            if not is_zero(rows[r][c]):
                sel = r
                break
        if sel is None:
            continue
        rows[piv], rows[sel] = rows[sel], rows[piv]
        f = inv(rows[piv][c])
        rows[piv] = [mul(e, f) for e in rows[piv]]
        for r in range(len(rows)):
            if r != piv and not is_zero(rows[r][c]):
                f2 = rows[r][c]
                rows[r] = [sub(a_, mul(f2, b_)) for a_, b_ in zip(rows[r], rows[piv])]
        piv += 1
        if piv == len(rows):
            break
    return [r for r in rows if any(not is_zero(e) for e in r)]


def nullspace(rows: List[List[Fld]], n: int) -> List[List[Fld]]:
    if not rows:
        return [[ONE if j == i else ZERO for j in range(n)] for i in range(n)]
    R = rref(rows)
    pivots = []
    for r in R:
        for c in range(n):
            if not is_zero(r[c]):
                pivots.append(c)
                break
    free = [c for c in range(n) if c not in pivots]
    basis = []
    for fcol in free:
        v = [ZERO] * n
        v[fcol] = ONE
        for r, pc in zip(R, pivots):
            v[pc] = neg(r[fcol])
        basis.append(v)
    return basis


def eigenspaces(M: Mat) -> List[Tuple[Fld, List[List[Fld]]]]:
    """Eigenvalues among 24th roots of unity, with eigenspace bases."""
    n = len(M)
    out = []
    total = 0
    for lam in ROOTS_OF_UNITY:
        rows = [[sub(M[i][j], lam if i == j else ZERO) for j in range(n)] for i in range(n)]
        ker = nullspace(rows, n)
        if ker:
            out.append((lam, ker))
            total += len(ker)
    if total != n:
        raise ValueError(f"matrix not diagonalizable over Q(zeta_24): got {total} of {n}")
    return out


def intersect(W: List[List[Fld]], U: List[List[Fld]], n: int) -> List[List[Fld]]:
    if not W or not U:
        return []
    rows = []
    for c in range(n):
        rows.append([W[i][c] for i in range(len(W))] + [neg(U[j][c]) for j in range(len(U))])
    ker = nullspace(rows, len(W) + len(U))
    out = []
    for v in ker:
        vec = [ZERO] * n
        for i in range(len(W)):
            if not is_zero(v[i]):
                for c in range(n):
                    vec[c] = add(vec[c], mul(v[i], W[i][c]))
        if any(not is_zero(e) for e in vec):
            out.append(vec)
    return rref(out) if out else []


def common_eigenspaces(mats: List[Mat], n: int) -> List[List[List[Fld]]]:
    """Maximal subspaces on which every matrix acts by a scalar.

    A projective point is fixed by all matrices iff it lies in one of them.
    """
    current: List[List[List[Fld]]] = [[[ONE if j == i else ZERO for j in range(n)]
                                       for i in range(n)]]
    for M in mats:
        eig = eigenspaces(M)
        if len(eig) == 1:
            continue
        nxt: List[List[List[Fld]]] = []
        for W in current:
            for _, U in eig:
                it = intersect(W, U, n)
                if it:
                    nxt.append(it)
        current = nxt
        if not current:
            break
    return current


def eigenvalue_at(M: Mat, v: Sequence[Fld]) -> Fld:
    w = apply_mat(M, v)
    for a_, b_ in zip(w, v):
        if not is_zero(b_):
            return div(a_, b_)
    raise ValueError("zero vector")


def norm_point(v: Sequence[Fld]) -> Tuple[Fld, ...]:
    for e in v:
        if not is_zero(e):
            f = inv(e)
            return tuple(mul(c, f) for c in v)
    raise ValueError("zero vector")


# --------------------------------------------------------------------------
# 7. Self-test
# --------------------------------------------------------------------------

def main() -> None:
    failures = []

    def check(label: str, cond: bool, extra: str = "") -> None:
        if not cond:
            failures.append(label)
        print(f"[{'PASS' if cond else 'FAIL'}] {label}{(' :: ' + extra) if extra else ''}")

    print("== 1. Field ==")
    check("zeta_24 has order 24", z24(24) == ONE and z24(12) != ONE and z24(8) != ONE)
    check("i^2 = -1", mul(I_UNIT, I_UNIT) == neg(ONE))
    check("sqrt2^2 = 2", mul(SQRT2, SQRT2) == fld(2))
    check("((1+i)/2)^2 = i/2", mul(A4SCALE, A4SCALE) == mul(I_UNIT, HALF))

    print("\n== 2. Model ==")
    check("Q2^2 - Q1*Q3 = x^4 + y^4 + z^4 (Fermat quartic)", peq(DISCRIMINANT, FERMAT))
    check("F is a (2,2)-form",
          all(m[0] + m[1] == 2 and m[2] + m[3] + m[4] == 2 for m in F))

    print("\n== 3. Generators ==")
    for k, g in enumerate(GEN_LIFTS, start=1):
        A, B, mu = g
        check(f"tau_{k}: det A = 1, det B = 1, F(At,Bx) = mu^2 F",
              det2(A) == ONE and det3(B) == ONE and substitution_check(g),
              f"mu = {fld_str(mu)}")

    print("\n== 4. The group G = Aut(X) ==")
    elems = build_G()
    check("|G| = 192", len(elems) == 192, f"got {len(elems)}")
    check("every element satisfies F(At,Bx) = mu^2 F and lies in SL2 x SL3",
          all(substitution_check(g) and det2(g[0]) == ONE and det3(g[1]) == ONE
              for g in elems))
    G = FiniteGroup(elems)
    tau_i = G.index[TAU]
    check("tau has order 2", G.order(tau_i) == 2)
    check("Z(G) = <tau>", G.center() == frozenset({G.e, tau_i}),
          f"|Z(G)| = {len(G.center())}")

    print("\n== 5. Residual group Gbar = G/<tau> ==")
    images = {(g[0], g[1]) for g in elems}
    check("|Gbar| = 96", len(images) == 96, f"got {len(images)}")

    counts: Dict[int, int] = {}
    for i in range(G.n):
        counts[G.order(i)] = counts.get(G.order(i), 0) + 1
    print(f"       order statistics of G: {dict(sorted(counts.items()))}")
    print(f"       number of conjugacy classes of G: {len(G.conjugacy_classes())}")

    # Every element must be diagonalizable over K (needed downstream).
    try:
        for g in elems:
            eigenspaces(g[0])
            eigenspaces(g[1])
        check("all A and B are diagonalizable with 24th-root eigenvalues", True)
    except ValueError as exc:  # pragma: no cover
        check("all A and B are diagonalizable with 24th-root eigenvalues", False, str(exc))

    if failures:
        print("\nFAILURES: " + "; ".join(failures))
        raise SystemExit(1)
    print("\nALL MODEL CHECKS PASSED")


if __name__ == "__main__":
    main()
