#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
FIX-T34, CASE T3 -- PRODUCER.

Target: the degree-2 del Pezzo surface

    S : w^2 = F(x) = x1^4 + x2^4 + x3^4     inside  P(1,1,1,2),

the double cover of P^2 branched over the Fermat quartic B = {F = 0}.

Model of Aut(S).  A point of P(1,1,1,2) is [x1:x2:x3:w] with
(x,w) ~ (lam x, lam^2 w).  An automorphism of S is induced by a pair
(A, nu) in GL_3 x C^* with F(Ax) = nu^2 F(x) and (x,w) -> (Ax, nu w),
taken modulo (A,nu) ~ (lam A, lam^2 nu).  Because F is the Fermat quartic,
its projective stabiliser is the monomial group of order 96 (classical:
Aut(Fermat quartic curve) has order 96), so A can be taken monomial with
4th-root-of-unity entries and then F(Ax) = F(x), forcing nu^2 = 1.
Hence

    Aut(S) = { (A, nu) : A monomial with mu_4 entries, nu in mu_2 } / <(iI, -1)>

of order 4^3 * 6 * 2 / 4 = 192, and Aut(S) = <deck> x {nu = 1} with
<deck> = <(I,-1)> central of order 2 and the nu=1 part of order 96
isomorphic to mu_4^2 : S_3.  (Verified numerically below.)

Element encoding:  (sigma, a, n) with sigma in S_3 given as a tuple
(sigma[j] = row of the nonzero entry in column j), a in (Z/4)^3 the
exponents A[sigma[j]][j] = i^{a[j]}, and nu = (-1)^n.  Canonical form:
a[0] = 0 (scale by i^{-a[0]}, which multiplies nu by (-1)^{a[0]}).

Fixed loci.  For g = (A,nu) and a point [x:w] of S (note x != 0 on S,
since x = 0 forces w = 0), g fixes [x:w] iff Ax = lam x for some lam and
nu w = lam^2 w.  Hence, writing E_lam for the lam-eigenspace of A,

    S^g  =  UNION over eigenvalues lam of A of
              * if nu = lam^2 :  pi^{-1}( P(E_lam) )         (full preimage)
              * if nu = -lam^2:  { [x:0] : x in P(E_lam), F(x) = 0 }

where pi : S -> P^2 is the double cover.  dim E_lam = 2 gives a curve
pi^{-1}(L), L a line: it is the double cover of L ~ P^1 branched over the
quartic binary form q = F|_L, so it is a smooth genus-1 curve iff q has 4
distinct roots, and otherwise it is (a union of) rational curve(s).
dim E_lam = 3 happens only for A scalar, i.e. g = deck, with
S^deck = B = {w = 0}, the branch quartic, of genus 3.

Exact arithmetic: all matrix entries lie in mu_4 and all eigenvalues in
mu_24 (a 2-cycle with entry-product i has eigenvalues in mu_8; a 3-cycle
gives mu_12), so we work in Q(zeta_24) = Q[x]/(x^8 - x^4 + 1).

Outputs T3_payload.json.
"""

import json
import os
from fractions import Fraction as Fr
from itertools import permutations

HERE = os.path.dirname(os.path.abspath(__file__))

# ----------------------------------------------------------------------
# 1. Exact arithmetic in Q(zeta_24) = Q[x]/(x^8 - x^4 + 1)
# ----------------------------------------------------------------------
D = 8
FZERO = (Fr(0),) * D
FONE = (Fr(1),) + (Fr(0),) * (D - 1)


def fadd(a, b):
    return tuple(x + y for x, y in zip(a, b))


def fsub(a, b):
    return tuple(x - y for x, y in zip(a, b))


def fneg(a):
    return tuple(-x for x in a)


def fmul(a, b):
    c = [Fr(0)] * (2 * D - 1)
    for i in range(D):
        if a[i]:
            ai = a[i]
            for j in range(D):
                if b[j]:
                    c[i + j] += ai * b[j]
    # reduce x^8 = x^4 - 1  (Phi_24 = x^8 - x^4 + 1)
    for k in range(2 * D - 2, D - 1, -1):
        ck = c[k]
        if ck:
            c[k - 4] += ck
            c[k - 8] -= ck
            c[k] = Fr(0)
    return tuple(c[:D])


def fiszero(a):
    return all(x == 0 for x in a)


def finv(a):
    """Inverse in Q(zeta_24) via solving the 8x8 rational linear system."""
    assert not fiszero(a)
    basis = []
    for j in range(D):
        e = [Fr(0)] * D
        e[j] = Fr(1)
        basis.append(fmul(a, tuple(e)))
    # matrix M with columns basis[j]; solve M y = e_0
    M = [[basis[j][i] for j in range(D)] for i in range(D)]
    rhs = [Fr(1)] + [Fr(0)] * (D - 1)
    n = D
    for col in range(n):
        piv = None
        for r in range(col, n):
            if M[r][col] != 0:
                piv = r
                break
        assert piv is not None, "singular"
        M[col], M[piv] = M[piv], M[col]
        rhs[col], rhs[piv] = rhs[piv], rhs[col]
        pv = M[col][col]
        M[col] = [v / pv for v in M[col]]
        rhs[col] = rhs[col] / pv
        for r in range(n):
            if r != col and M[r][col] != 0:
                f = M[r][col]
                M[r] = [u - f * v for u, v in zip(M[r], M[col])]
                rhs[r] = rhs[r] - f * rhs[col]
    return tuple(rhs)


_ZPOW = [FONE]
_X = tuple([Fr(0), Fr(1)] + [Fr(0)] * (D - 2))
for _k in range(1, 24):
    _ZPOW.append(fmul(_ZPOW[-1], _X))


def zeta(k):
    """zeta_24^k."""
    return _ZPOW[k % 24]


assert zeta(12) == fneg(FONE), "zeta_24^12 must be -1"
assert zeta(0) == FONE


# ----------------------------------------------------------------------
# 2. Linear algebra over Q(zeta_24)  (vectors of length 3)
# ----------------------------------------------------------------------
def rref(rows, ncols):
    """Row-reduce a list of row vectors, return (rref rows, pivot columns)."""
    rows = [list(r) for r in rows]
    piv = []
    r = 0
    for c in range(ncols):
        pr = None
        for k in range(r, len(rows)):
            if not fiszero(rows[k][c]):
                pr = k
                break
        if pr is None:
            continue
        rows[r], rows[pr] = rows[pr], rows[r]
        iv = finv(rows[r][c])
        rows[r] = [fmul(iv, v) for v in rows[r]]
        for k in range(len(rows)):
            if k != r and not fiszero(rows[k][c]):
                f = rows[k][c]
                rows[k] = [fsub(u, fmul(f, v)) for u, v in zip(rows[k], rows[r])]
        piv.append(c)
        r += 1
        if r == len(rows):
            break
    rows = [row for row in rows if any(not fiszero(v) for v in row)]
    return rows, piv


def nullspace(rows, ncols):
    """Basis of the nullspace of the matrix with the given rows."""
    R, piv = rref(rows, ncols)
    free = [c for c in range(ncols) if c not in piv]
    basis = []
    for fc in free:
        v = [FZERO] * ncols
        v[fc] = FONE
        for i, pc in enumerate(piv):
            v[pc] = fneg(R[i][fc])
        basis.append(tuple(v))
    return basis


def intersect(U, V):
    """Intersection of the spans of the column lists U and V (in K^3)."""
    if not U or not V:
        return []
    p, q = len(U), len(V)
    rows = []
    for i in range(3):
        row = [U[j][i] for j in range(p)] + [fneg(V[j][i]) for j in range(q)]
        rows.append(row)
    ker = nullspace(rows, p + q)
    out = []
    for k in ker:
        vec = [FZERO] * 3
        for j in range(p):
            for i in range(3):
                vec[i] = fadd(vec[i], fmul(k[j], U[j][i]))
        if any(not fiszero(c) for c in vec):
            out.append(tuple(vec))
    R, piv = rref(out, 3) if out else ([], [])
    return [tuple(r) for r in R]


# ----------------------------------------------------------------------
# 3. Univariate polynomials over Q(zeta_24) (for root multiplicities)
# ----------------------------------------------------------------------
def ptrim(p):
    while p and fiszero(p[-1]):
        p.pop()
    return p


def pmul(p, q):
    if not p or not q:
        return []
    r = [FZERO] * (len(p) + len(q) - 1)
    for i, a in enumerate(p):
        if fiszero(a):
            continue
        for j, b in enumerate(q):
            if fiszero(b):
                continue
            r[i + j] = fadd(r[i + j], fmul(a, b))
    return ptrim(r)


def psub(p, q):
    n = max(len(p), len(q))
    r = []
    for i in range(n):
        a = p[i] if i < len(p) else FZERO
        b = q[i] if i < len(q) else FZERO
        r.append(fsub(a, b))
    return ptrim(r)


def pmod(p, q):
    p = list(p)
    dq = len(q) - 1
    ivq = finv(q[-1])
    while len(p) - 1 >= dq and p:
        d = len(p) - 1 - dq
        c = fmul(p[-1], ivq)
        shifted = [FZERO] * d + [fmul(c, t) for t in q]
        p = psub(p, shifted)
    return ptrim(p)


def pgcd(p, q):
    p, q = ptrim(list(p)), ptrim(list(q))
    while q:
        p, q = q, pmod(p, q)
    if p:
        iv = finv(p[-1])
        p = [fmul(iv, c) for c in p]
    return p


def scal(c, a):
    """Multiply a field element by a rational scalar."""
    c = Fr(c)
    return tuple(c * x for x in a)


def pderiv(p):
    return ptrim([scal(i, p[i]) for i in range(1, len(p))])


def root_pattern(coeffs):
    """coeffs = [q0,...,q4] of the binary quartic q(s,t) = sum q_m s^{4-m} t^m.
    Returns the multiplicity pattern of its 4 roots on P^1."""
    def qval(s, t):
        # s,t rational integers
        tot = FZERO
        for m in range(5):
            co = Fr(s) ** (4 - m) * Fr(t) ** m
            tot = fadd(tot, scal(co, coeffs[m]))
        return tot

    cc = None
    for c in range(0, 12):
        if not fiszero(qval(1, c)):
            cc = c
            break
    assert cc is not None
    # substitute t -> t + c s : new coefficients
    new = [FZERO] * 5
    from math import comb
    for m in range(5):
        # q_m s^{4-m}(t + c s)^m = q_m sum_k C(m,k) c^{m-k} s^{4-k} t^k
        for k in range(m + 1):
            co = Fr(comb(m, k)) * Fr(cc) ** (m - k)
            new[k] = fadd(new[k], scal(co, coeffs[m]))
    # dehomogenise t = 1: p(s) = sum new[k] s^{4-k}  -> poly in s of degree 4
    p = [new[4 - d] for d in range(5)]  # p[d] = coeff of s^d
    p = ptrim(list(p))
    assert len(p) == 5, "leading coefficient should be nonzero"
    g1 = pgcd(p, pderiv(p))
    d1 = len(g1) - 1
    if d1 == 0:
        return (1, 1, 1, 1)
    if d1 == 1:
        return (2, 1, 1)
    if d1 == 2:
        g2 = pgcd(g1, pderiv(g1))
        return (3, 1) if len(g2) - 1 == 1 else (2, 2)
    if d1 == 3:
        return (4,)
    raise AssertionError("bad gcd degree")


# ----------------------------------------------------------------------
# 4. The group Aut(S) of order 192
# ----------------------------------------------------------------------
PERMS = [tuple(p) for p in permutations(range(3))]


def canon(sig, a, n):
    k = (-a[0]) % 4
    aa = tuple((x + k) % 4 for x in a)
    nn = (n + k) % 2
    return (tuple(sig), aa, nn)


def gmul(g, h):
    s, a, n = g
    t, b, m = h
    p = tuple(s[t[j]] for j in range(3))
    c = tuple((b[j] + a[t[j]]) % 4 for j in range(3))
    return canon(p, c, (n + m) % 2)


def ginv(g):
    s, a, n = g
    si = [0, 0, 0]
    for j in range(3):
        si[s[j]] = j
    si = tuple(si)
    b = tuple((-a[si[j]]) % 4 for j in range(3))
    return canon(si, b, n % 2)


ID = canon((0, 1, 2), (0, 0, 0), 0)
DECK = canon((0, 1, 2), (0, 0, 0), 1)

ELEMENTS = []
for sig in PERMS:
    for a2 in range(4):
        for a3 in range(4):
            for n in range(2):
                ELEMENTS.append(canon(sig, (0, a2, a3), n))
ELEMENTS = sorted(set(ELEMENTS))
IDX = {g: i for i, g in enumerate(ELEMENTS)}
N = len(ELEMENTS)
assert N == 192, N

MT = [[IDX[gmul(g, h)] for h in ELEMENTS] for g in ELEMENTS]
INV = [IDX[ginv(g)] for g in ELEMENTS]
IDI = IDX[ID]
DECKI = IDX[DECK]
for i in range(N):
    assert MT[i][INV[i]] == IDI


def gorder(i):
    k, x = 1, i
    while x != IDI:
        x = MT[x][i]
        k += 1
    return k


def matrix_of(g):
    """3x3 matrix over Q(zeta_24) of the linear part."""
    s, a, n = g
    M = [[FZERO] * 3 for _ in range(3)]
    for j in range(3):
        M[s[j]][j] = zeta(6 * a[j])
    return M


def apply_mat(M, v):
    out = []
    for i in range(3):
        acc = FZERO
        for j in range(3):
            if not fiszero(M[i][j]) and not fiszero(v[j]):
                acc = fadd(acc, fmul(M[i][j], v[j]))
        out.append(acc)
    return tuple(out)


# ---- structural sanity checks on Aut(S) -----------------------------------
# NB. nu is *not* a class invariant: (A,nu) ~ (iA,-nu).  In particular the deck
# involution is also the class of the scalar matrix iI with nu = +1.
CENTER_FULL = [i for i in range(N) if all(MT[i][j] == MT[j][i] for j in range(N))]


def _closure_idx(gens):
    S = {IDI}
    fr = [IDI]
    while fr:
        x = fr.pop()
        for g in gens:
            y = MT[x][g]
            if y not in S:
                S.add(y)
                fr.append(y)
    return frozenset(S)


# derived subgroup and squares, to list the index-2 subgroups (order 96)
_comms = set()
for i in range(N):
    for j in range(N):
        _comms.add(MT[MT[INV[i]][INV[j]]][MT[i][j]])
DERIVED = _closure_idx(sorted(_comms))
FRAT2 = _closure_idx(sorted(set(DERIVED) | {MT[i][i] for i in range(N)}))
# G/FRAT2 is elementary abelian; index-2 subgroups = preimages of hyperplanes
_cosets = {}
for i in range(N):
    key = frozenset(MT[i][f] for f in FRAT2)
    _cosets.setdefault(key, []).append(i)
_keys = list(_cosets)
_kidx = {k: i for i, k in enumerate(_keys)}
_M = len(_keys)


def _coset_of(x):
    return _kidx[frozenset(MT[x][f] for f in FRAT2)]


_QT = [[_coset_of(MT[_cosets[_keys[i]][0]][_cosets[_keys[j]][0]]) for j in range(_M)]
       for i in range(_M)]
_qid = _coset_of(IDI)
import itertools as _it
INDEX2 = []
for _sub in _it.combinations([i for i in range(_M) if i != _qid], _M // 2 - 1):
    _S = set(_sub) | {_qid}
    if all(_QT[a][b] in _S for a in _S for b in _S):
        _full = frozenset(x for k in _S for x in _cosets[_keys[k]])
        assert len(_full) == N // 2
        INDEX2.append(_full)
COMPLEMENTS96 = [H for H in INDEX2 if DECKI not in H]


# ----------------------------------------------------------------------
# 5. Fixed loci
# ----------------------------------------------------------------------
def cycles_of(sig):
    seen = set()
    out = []
    for j in range(3):
        if j in seen:
            continue
        cyc = [j]
        seen.add(j)
        k = sig[j]
        while k != j:
            cyc.append(k)
            seen.add(k)
            k = sig[k]
        out.append(cyc)
    return out


def eigendata(g):
    """Return {u (exponent of zeta_24 : lam = zeta^u) : [eigenvectors]}."""
    sig, a, n = g
    out = {}
    for cyc in cycles_of(sig):
        k = len(cyc)
        c = (6 * sum(a[j] for j in cyc)) % 24
        # solve u*k = c (mod 24)
        for u in range(24):
            if (u * k - c) % 24 != 0:
                continue
            # eigenvector supported on the cycle
            v = [FZERO] * 3
            e = 0  # exponent of the current coefficient
            for m in range(k):
                j = cyc[m]
                v[j] = zeta(e)
                e = (e + 6 * a[j] - u) % 24
            assert e % 24 == 0, "cycle consistency"
            out.setdefault(u, []).append(tuple(v))
    # sanity: total dimension 3
    assert sum(len(v) for v in out.values()) == 3
    M = matrix_of(g)
    for u, vs in out.items():
        for v in vs:
            got = apply_mat(M, v)
            want = tuple(fmul(zeta(u), c) for c in v)
            assert got == want, "eigenvector check failed"
    return out


def Fval(v):
    """F(v) = sum v_i^4 for v a vector over Q(zeta_24)."""
    tot = FZERO
    for c in v:
        c2 = fmul(c, c)
        tot = fadd(tot, fmul(c2, c2))
    return tot


def _powk(a, k):
    r = FONE
    for _ in range(k):
        r = fmul(r, a)
    return r


def quartic_on_line(v, u):
    """Coefficients [q0..q4] of F(s v + t u) = sum_m q_m s^{4-m} t^m."""
    from math import comb
    q = [FZERO] * 5
    for i in range(3):
        for m in range(5):
            term = scal(comb(4, m), fmul(_powk(v[i], 4 - m), _powk(u[i], m)))
            q[m] = fadd(q[m], term)
    return q


def fixed_locus(gi):
    """Structure of S^g for the element with index gi."""
    g = ELEMENTS[gi]
    sig, a, n = g
    comps = []          # list of dicts
    if gi == IDI:
        return [{"type": "whole surface", "dim": 2}]
    ed = eigendata(g)
    for u, vs in sorted(ed.items()):
        dim = len(vs)
        # nu = (-1)^n = zeta^{12n}; lam^2 = zeta^{2u}.
        # w != 0 is allowed exactly when nu = lam^2; otherwise w = 0 is forced.
        plus = (2 * u - 12 * n) % 24 == 0     # nu = lam^2
        if plus:
            if dim == 3:
                comps.append({"type": "whole surface", "dim": 2, "lam": u})
            elif dim == 2:
                q = quartic_on_line(vs[0], vs[1])
                pat = root_pattern(q)
                if pat == (1, 1, 1, 1):
                    comps.append({"type": "curve", "dim": 1, "lam": u,
                                  "description": "pi^{-1}(L), L = P(E_lam) a line",
                                  "branch_pattern": list(pat),
                                  "irreducible": True, "genus": 1})
                elif pat in [(2, 2), (4,)]:
                    comps.append({"type": "curve", "dim": 1, "lam": u,
                                  "description": "pi^{-1}(L) splits into two rational curves",
                                  "branch_pattern": list(pat),
                                  "irreducible": False, "genus": 0})
                else:
                    comps.append({"type": "curve", "dim": 1, "lam": u,
                                  "description": "pi^{-1}(L) irreducible singular, rational",
                                  "branch_pattern": list(pat),
                                  "irreducible": True, "genus": 0})
            else:
                v = vs[0]
                if fiszero(Fval(v)):
                    comps.append({"type": "point", "dim": 0, "lam": u,
                                  "count": 1, "on_branch": True})
                else:
                    comps.append({"type": "point", "dim": 0, "lam": u,
                                  "count": 2, "on_branch": False})
        else:
            if dim == 3:
                comps.append({"type": "curve", "dim": 1, "lam": u,
                              "description": "the branch quartic B = {w=0}",
                              "irreducible": True, "genus": 3})
            elif dim == 2:
                q = quartic_on_line(vs[0], vs[1])
                pat = root_pattern(q)
                comps.append({"type": "point", "dim": 0, "lam": u,
                              "count": len(pat), "on_branch": True,
                              "description": "the points of L cap B (w=0)",
                              "branch_pattern": list(pat)})
            else:
                v = vs[0]
                if fiszero(Fval(v)):
                    comps.append({"type": "point", "dim": 0, "lam": u,
                                  "count": 1, "on_branch": True})
    return comps


def hyp_a(comps):
    """Hypothesis (a): every positive-dimensional component has genus >= 1."""
    for c in comps:
        if c["dim"] == 2:
            return False
        if c["dim"] == 1 and c.get("genus", 0) < 1:
            return False
    return True


def fixed_summary(comps):
    curves = [(c.get("genus"), c.get("description", "")) for c in comps if c["dim"] == 1]
    pts = sum(c.get("count", 0) for c in comps if c["dim"] == 0)
    return {"curves": curves, "isolated_points": pts}


# ----------------------------------------------------------------------
# 6. Subgroups
# ----------------------------------------------------------------------
def closure(gens):
    S = {IDI}
    frontier = [IDI]
    while frontier:
        x = frontier.pop()
        for g in gens:
            y = MT[x][g]
            if y not in S:
                S.add(y)
                frontier.append(y)
    return frozenset(S)


def subgroups_of_order(target):
    """All 2-subgroups up to order `target`, bottom-up cyclic extension."""
    level = {frozenset([IDI])}
    all_levels = {1: level}
    order = 1
    while order < target:
        nxt = set()
        for H in level:
            for g in range(N):
                if g in H:
                    continue
                K = closure(list(H) + [g])
                if len(K) == 2 * order:
                    nxt.add(K)
        order *= 2
        all_levels[order] = nxt
        level = nxt
    return all_levels


CONJ = [[MT[MT[INV[c]][x]][c] for x in range(N)] for c in range(N)]  # x -> c^{-1} x c


def conj_class_of_subgroup(H):
    seen = {H}
    frontier = [H]
    while frontier:
        K = frontier.pop()
        for c in range(N):
            L = frozenset(CONJ[c][x] for x in K)
            if L not in seen:
                seen.add(L)
                frontier.append(L)
    return seen


def center_of(H):
    return [x for x in H if all(MT[x][y] == MT[y][x] for y in H)]


def min_gens(H):
    gens = []
    cur = {IDI}
    for x in sorted(H):
        if x in cur:
            continue
        gens.append(x)
        cur = closure(gens)
        if len(cur) == len(H):
            break
    return gens


# ----------------------------------------------------------------------
# 7. Identification of the 14 groups of order 16
# ----------------------------------------------------------------------
def table_from(elems, mul):
    idx = {e: i for i, e in enumerate(elems)}
    T = [[idx[mul(a, b)] for b in elems] for a in elems]
    # identity to index 0
    ident = None
    for i in range(len(elems)):
        if all(T[i][j] == j for j in range(len(elems))):
            ident = i
    assert ident is not None
    perm = [ident] + [i for i in range(len(elems)) if i != ident]
    ren = {old: new for new, old in enumerate(perm)}
    T2 = [[ren[T[perm[i]][perm[j]]] for j in range(len(elems))] for i in range(len(elems))]
    # associativity check
    n = len(elems)
    for i in range(n):
        for j in range(n):
            for k in range(n):
                assert T2[T2[i][j]][k] == T2[i][T2[j][k]], "non-associative"
    return T2


def build_order16_groups():
    G = {}

    def abelian(mods):
        elems = [()]
        for m in mods:
            elems = [e + (v,) for e in elems for v in range(m)]
        return table_from(elems, lambda a, b: tuple((x + y) % m for x, y, m in zip(a, b, mods)))

    G["C16"] = abelian([16])
    G["C8xC2"] = abelian([8, 2])
    G["C4xC4"] = abelian([4, 4])
    G["C4xC2xC2"] = abelian([4, 2, 2])
    G["C2^4"] = abelian([2, 2, 2, 2])

    def meta(m):  # <r,s | r^8, s^2, s r s^-1 = r^m>
        elems = [(i, j) for i in range(8) for j in range(2)]
        def mul(A, B):
            i, j = A
            k, l = B
            return ((i + (m ** j) * k) % 8, (j + l) % 2)
        return table_from(elems, mul)

    G["D16"] = meta(7)
    G["SD16"] = meta(3)
    G["M16"] = meta(5)

    elems = [(i, j) for i in range(8) for j in range(2)]
    def mulq16(A, B):
        i, j = A
        k, l = B
        return ((i + ((-1) ** j) * k + 4 * j * l) % 8, (j + l) % 2)
    G["Q16"] = table_from(elems, mulq16)

    # D8 and Q8 as tables of pairs, then x C2
    d8 = [(i, j) for i in range(4) for j in range(2)]
    def muld8(A, B):
        i, j = A
        k, l = B
        return ((i + ((-1) ** j) * k) % 4, (j + l) % 2)
    def mulq8(A, B):
        i, j = A
        k, l = B
        return ((i + ((-1) ** j) * k + 2 * j * l) % 4, (j + l) % 2)

    G["D8xC2"] = table_from([(a, c) for a in d8 for c in range(2)],
                            lambda A, B: (muld8(A[0], B[0]), (A[1] + B[1]) % 2))
    G["Q8xC2"] = table_from([(a, c) for a in d8 for c in range(2)],
                            lambda A, B: (mulq8(A[0], B[0]), (A[1] + B[1]) % 2))

    # central product D8 o C4 = (D8 x C4)/<(z, c^2)>, z = x^2
    big = [(a, c) for a in d8 for c in range(4)]
    def mulbig(A, B):
        return (muld8(A[0], B[0]), (A[1] + B[1]) % 4)
    zc = ((2, 0), 2)
    cosets = {}
    reps = []
    for e in big:
        pair = frozenset([e, mulbig(e, zc)])
        if pair not in cosets:
            cosets[pair] = len(reps)
            reps.append(pair)
    def mulcp(A, B):
        a = next(iter(A))
        b = next(iter(B))
        p = mulbig(a, b)
        return frozenset([p, mulbig(p, zc)])
    G["D8oC4"] = table_from(reps, mulcp)

    # C4 : C4
    elems = [(i, j) for i in range(4) for j in range(4)]
    def mulc4c4(A, B):
        i, j = A
        k, l = B
        return ((i + ((-1) ** j) * k) % 4, (j + l) % 4)
    G["C4:C4"] = table_from(elems, mulc4c4)

    # (C2 x C2) : C4  (C4 acts by swapping the factors)
    elems = [((a, b), j) for a in range(2) for b in range(2) for j in range(4)]
    def mulv4c4(A, B):
        (a, b), j = A
        (c, d), l = B
        if j % 2 == 1:
            c, d = d, c
        return (((a + c) % 2, (b + d) % 2), (j + l) % 4)
    G["(C2xC2):C4"] = table_from(elems, mulv4c4)
    return G


def table_orders(T):
    n = len(T)
    out = []
    for i in range(n):
        k, x = 1, i
        while x != 0:
            x = T[x][i]
            k += 1
        out.append(k)
    return out


def iso_tables(T1, T2):
    n = len(T1)
    if sorted(table_orders(T1)) != sorted(table_orders(T2)):
        return False
    o1 = table_orders(T1)
    o2 = table_orders(T2)

    def cl(T, gens):
        S = {0}
        fr = [0]
        while fr:
            x = fr.pop()
            for g in gens:
                y = T[x][g]
                if y not in S:
                    S.add(y)
                    fr.append(y)
        return S

    gens = []
    cur = {0}
    for x in range(n):
        if x in cur:
            continue
        gens.append(x)
        cur = cl(T1, gens)
        if len(cur) == n:
            break
    r = len(gens)

    def try_map(images):
        phi = {0: 0}
        frontier = [0]
        while frontier:
            x = frontier.pop()
            for gi, g in enumerate(gens):
                y = T1[x][g]
                fy = T2[phi[x]][images[gi]]
                if y in phi:
                    if phi[y] != fy:
                        return None
                else:
                    phi[y] = fy
                    frontier.append(y)
        if len(set(phi.values())) != n or len(phi) != n:
            return None
        for a in range(n):
            for b in range(n):
                if phi[T1[a][b]] != T2[phi[a]][phi[b]]:
                    return None
        return phi

    cands = [[y for y in range(n) if o2[y] == o1[g]] for g in gens]

    def rec(k, chosen):
        if k == r:
            return try_map(chosen) is not None
        for y in cands[k]:
            if rec(k + 1, chosen + [y]):
                return True
        return False

    return rec(0, [])


ORDER16 = build_order16_groups()
_names = list(ORDER16)
for _i in range(len(_names)):
    for _j in range(_i + 1, len(_names)):
        assert not iso_tables(ORDER16[_names[_i]], ORDER16[_names[_j]]), \
            "the 14 model groups must be pairwise non-isomorphic: %s %s" % (_names[_i], _names[_j])
assert len(_names) == 14


def fingerprint16(H):
    """A method-independent invariant of the abstract group H:
    (element-order profile, |Z(H)|, |H'|, orders in the abelianisation)."""
    prof = {}
    for x in H:
        o = gorder(x)
        prof[o] = prof.get(o, 0) + 1
    Z = center_of(H)
    gens = set()
    for a in H:
        for b in H:
            gens.add(MT[MT[INV[a]][INV[b]]][MT[a][b]])
    Dv = closure(sorted(gens)) & frozenset(H)
    Dv = frozenset(x for x in closure(sorted(gens)))
    cos = {}
    for x in sorted(H):
        cos.setdefault(frozenset(MT[x][d] for d in Dv), []).append(x)
    keys = list(cos)
    kidx = {k: j for j, k in enumerate(keys)}

    def cos_of(x):
        return kidx[frozenset(MT[x][d] for d in Dv)]

    m = len(keys)
    QT = [[cos_of(MT[cos[keys[a]][0]][cos[keys[b]][0]]) for b in range(m)]
          for a in range(m)]
    qe = cos_of(IDI)
    ab = []
    for a in range(m):
        k, y = 1, a
        while y != qe:
            y = QT[y][a]
            k += 1
        ab.append(k)
    return (tuple(sorted(prof.items())), len(Z), len(Dv), tuple(sorted(ab)))


def identify16(H):
    elems = sorted(H)
    T = table_from(elems, lambda a, b: MT[a][b])
    for nm, T2 in ORDER16.items():
        if iso_tables(T, T2):
            return nm
    raise AssertionError("unidentified group of order 16")


# ----------------------------------------------------------------------
# 8. S^G = empty?
# ----------------------------------------------------------------------
def joint_eigenspaces(H):
    """List of (basis, {}) for the maximal joint eigenspaces of H in C^3."""
    gens = min_gens(H)
    if not gens:
        return [([ (FONE, FZERO, FZERO), (FZERO, FONE, FZERO), (FZERO, FZERO, FONE) ], {})]
    cur = None
    for g in gens:
        ed = eigendata(ELEMENTS[g])
        pieces = [(vs, {g: u}) for u, vs in ed.items()]
        if cur is None:
            cur = [( [tuple(v) for v in vs], dict(lab)) for vs, lab in pieces]
        else:
            nxt = []
            for B, lab in cur:
                for vs, lab2 in pieces:
                    W = intersect(B, [tuple(v) for v in vs])
                    if W:
                        d = dict(lab)
                        d.update(lab2)
                        nxt.append((W, d))
            cur = nxt
    return cur


def fixed_points_of_subgroup(H):
    """Return a description of S^H (empty list == S^H is empty)."""
    out = []
    for B, lab in joint_eigenspaces(H):
        dimW = len(B)
        # eigenvalue of every element of H on this joint eigenspace
        lams = {}
        ok = True
        for h in sorted(H):
            M = matrix_of(ELEMENTS[h])
            v = B[0]
            w = apply_mat(M, v)
            piv = next(i for i in range(3) if not fiszero(v[i]))
            lam = fmul(w[piv], finv(v[piv]))
            for b in B:
                wb = apply_mat(M, b)
                if tuple(fmul(lam, c) for c in b) != wb:
                    ok = False
            lams[h] = lam
        assert ok, "joint eigenspace is not an eigenspace for the whole group"
        # (i) points with w != 0 : need nu_h = lam_h^2 for all h, and F|_W not identically 0
        cond = all(fmul(lams[h], lams[h]) == zeta(12 * ELEMENTS[h][2]) for h in H)
        if cond:
            if dimW >= 2:
                q = quartic_on_line(B[0], B[1])
                assert any(not fiszero(c) for c in q), "F vanishes on a line: impossible"
                out.append({"kind": "w != 0", "dimW": dimW,
                            "note": "F|_W is a nonzero quartic, so points with w != 0 exist"})
            else:
                if not fiszero(Fval(B[0])):
                    out.append({"kind": "w != 0", "dimW": 1,
                                "note": "two points over one fixed point of P^2"})
        # (ii) points with w = 0 : P(W) cap B
        if dimW >= 2:
            out.append({"kind": "w = 0", "dimW": dimW,
                        "note": "a line always meets the quartic B"})
        else:
            if fiszero(Fval(B[0])):
                out.append({"kind": "w = 0", "dimW": 1,
                            "note": "the fixed point of P^2 lies on B"})
    return out


# ----------------------------------------------------------------------
# 9. Main
# ----------------------------------------------------------------------
def vec_str(v):
    """Readable form of a vector whose entries are 0 or powers of zeta_24."""
    out = []
    for c in v:
        if fiszero(c):
            out.append("0")
        else:
            k = next((k for k in range(24) if zeta(k) == c), None)
            out.append("z24^%d" % k if k is not None else "?")
    return "(" + ",".join(out) + ")"


def elt_str(g):
    sig, a, n = g
    return "A=[e%d->%d(i^%d), e%d->%d(i^%d), e%d->%d(i^%d)], nu=%d" % (
        1, sig[0] + 1, a[0], 2, sig[1] + 1, a[1], 3, sig[2] + 1, a[2], (-1) ** n)


def main():
    payload = {}
    payload["surface"] = "S : w^2 = x1^4+x2^4+x3^4 in P(1,1,1,2) (degree-2 del Pezzo)"
    payload["aut_order"] = N
    payload["center_of_Aut"] = [elt_str(ELEMENTS[i]) for i in CENTER_FULL]
    payload["center_of_Aut_order"] = len(CENTER_FULL)
    payload["deck_is_central"] = DECKI in CENTER_FULL
    payload["num_index2_subgroups"] = len(INDEX2)
    payload["num_order96_complements_to_deck"] = len(COMPLEMENTS96)
    payload["Aut_is_C2_times_96"] = len(COMPLEMENTS96) > 0
    payload["derived_subgroup_order"] = len(DERIVED)
    order_profile = {}
    for i in range(N):
        order_profile[gorder(i)] = order_profile.get(gorder(i), 0) + 1
    payload["element_order_profile"] = {str(k): v for k, v in sorted(order_profile.items())}

    # ---- fixed loci of all elements (inventory) ----
    inv_el = []
    for i in range(N):
        if i == IDI:
            continue
        comps = fixed_locus(i)
        inv_el.append({"element": elt_str(ELEMENTS[i]), "order": gorder(i),
                       "summary": fixed_summary(comps), "hyp_a": hyp_a(comps)})
    payload["element_fixed_loci"] = inv_el
    # elements whose fixed locus contains a rational curve
    payload["elements_failing_hyp_a"] = [e for e in inv_el if not e["hyp_a"]]

    # ---- order-16 subgroups ----
    levels = subgroups_of_order(16)
    subs16 = sorted(levels[16], key=lambda H: sorted(H))
    payload["num_subgroups_order16"] = len(subs16)
    payload["num_subgroups_order8"] = len(levels[8])
    payload["num_subgroups_order4"] = len(levels[4])
    payload["num_subgroups_order2"] = len(levels[2])

    classes = []
    seen = set()
    for H in subs16:
        if H in seen:
            continue
        orb = conj_class_of_subgroup(H)
        seen |= orb
        classes.append((H, len(orb)))

    payload["num_conjugacy_classes_order16"] = len(classes)
    out_classes = []
    for ci, (H, orbsize) in enumerate(classes):
        name = identify16(H)
        Z = center_of(H)
        rec = {
            "class_id": "T3-C%02d" % (ci + 1),
            "iso_type": name,
            "class_size": orbsize,
            "generators": [elt_str(ELEMENTS[g]) for g in min_gens(H)],
            "generators_raw": [list(ELEMENTS[g][0]) + list(ELEMENTS[g][1]) + [ELEMENTS[g][2]]
                               for g in min_gens(H)],
            "contains_deck": DECKI in H,
            "fingerprint": json.loads(json.dumps(fingerprint16(H))),
            "center_order": len(Z),
            "center_elements": [elt_str(ELEMENTS[z]) for z in Z],
        }
        cents = []
        for z in Z:
            if z == IDI:
                continue
            comps = fixed_locus(z)
            cents.append({
                "z": elt_str(ELEMENTS[z]),
                "z_order": gorder(z),
                "is_deck": z == DECKI,
                "fixed_locus": comps,
                "summary": fixed_summary(comps),
                "hyp_a": hyp_a(comps),
            })
        rec["central_elements"] = cents
        fx = fixed_points_of_subgroup(H)
        rec["S_G_fixed_points"] = fx
        rec["hyp_b"] = (len(fx) == 0)
        rec["hyp_a_witnesses"] = [c["z"] for c in cents if c["hyp_a"]]
        rec["corollary_applies"] = rec["hyp_b"] and any(c["hyp_a"] for c in cents)
        rec["matches_sessions_typeII"] = rec["hyp_b"] and any(
            c["hyp_a"] and c["summary"]["curves"] and
            all(g == 1 for g, _ in c["summary"]["curves"]) for c in cents)
        out_classes.append(rec)
    # the fingerprint must be an isomorphism invariant: same name <=> same value
    _seen = {}
    for c in out_classes:
        key = json.dumps(c["fingerprint"])
        _seen.setdefault(c["iso_type"], set()).add(key)
        for nm, vals in _seen.items():
            assert len(vals) == 1, "fingerprint is not constant on %s" % nm
    _byfp = {}
    for c in out_classes:
        _byfp.setdefault(json.dumps(c["fingerprint"]), set()).add(c["iso_type"])
    assert all(len(v) == 1 for v in _byfp.values()), \
        "fingerprint fails to separate the iso types occurring"
    payload["order16_classes"] = out_classes

    good = [c for c in out_classes if c["corollary_applies"]]
    payload["classes_satisfying_a_and_b"] = [c["class_id"] for c in good]
    payload["classes_matching_sessions_typeII"] = [
        c["class_id"] for c in out_classes if c["matches_sessions_typeII"]]

    with open(os.path.join(HERE, "T3_payload.json"), "w") as fh:
        json.dump(payload, fh, indent=1, sort_keys=False)

    # ---- console report ----
    print("Aut(S) order            :", N)
    print("Z(Aut(S))               :", len(CENTER_FULL), "elements",
          [elt_str(ELEMENTS[i]) for i in CENTER_FULL])
    print("subgroups of order 16   :", len(subs16),
          "in", len(classes), "conjugacy classes")
    print()
    for c in out_classes:
        print("%s  %-12s |class|=%-3d deck in G: %s  Z(G) order %d  (a)-witnesses %d  (b) S^G empty: %s  => Cor T3.1: %s"
              % (c["class_id"], c["iso_type"], c["class_size"], c["contains_deck"],
                 c["center_order"], len(c["hyp_a_witnesses"]), c["hyp_b"],
                 c["corollary_applies"]))
        for z in c["central_elements"]:
            print("      z (ord %d)%s : curves %s, isolated pts %d  -> (a) %s"
                  % (z["z_order"], " [deck]" if z["is_deck"] else "",
                     z["summary"]["curves"], z["summary"]["isolated_points"], z["hyp_a"]))
    print()
    print("classes with (a)+(b):", payload["classes_satisfying_a_and_b"])
    print("classes matching sessions' Type-II description (genus-1 curve + points):",
          payload["classes_matching_sessions_typeII"])


if __name__ == "__main__":
    main()
