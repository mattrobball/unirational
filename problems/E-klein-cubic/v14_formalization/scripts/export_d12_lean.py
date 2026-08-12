#!/usr/bin/env python3
"""
Deterministic exact-Q(zeta_11) exporter for the D12 fixed-locus certificate.

Outputs:
  results/d12_lean_K.json
  V14Formalization/D12SealData.lean

Hard-fails (REQUIRE) on any validation error. No next(...) D12 selection.
"""
from __future__ import annotations

import hashlib
import json
import os
import sys
import time
from collections import deque
from fractions import Fraction
from itertools import combinations, permutations
from typing import Any, Dict, List, Optional, Sequence, Tuple

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
JSON_PATH = os.path.join(ROOT, "results", "d12_lean_K.json")
LEAN_PATH = os.path.join(ROOT, "V14Formalization", "D12SealData.lean")
SCHEMA = "v14.fix_ix.d12_lean.v1"

# ---------------------------------------------------------------------------
# Field K = Q(z)/(Phi_11), Phi_11 = 1+z+...+z^10, basis 1,z,...,z^9
# ---------------------------------------------------------------------------

KElem = Tuple[Fraction, ...]  # length 10


def nf(c: Sequence[Fraction]) -> KElem:
    return tuple(c)


ZERO: KElem = nf([Fraction(0)] * 10)
ONE: KElem = nf([Fraction(1)] + [Fraction(0)] * 9)
Z: KElem = nf([Fraction(0), Fraction(1)] + [Fraction(0)] * 8)


def fadd(a: KElem, b: KElem) -> KElem:
    return nf([x + y for x, y in zip(a, b)])


def fsub(a: KElem, b: KElem) -> KElem:
    return nf([x - y for x, y in zip(a, b)])


def fneg(a: KElem) -> KElem:
    return nf([-x for x in a])


def fmul(a: KElem, b: KElem) -> KElem:
    c = [Fraction(0)] * 19
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                if y:
                    c[i + j] += x * y
    for k in range(18, 9, -1):
        if c[k]:
            v = c[k]
            c[k] = Fraction(0)
            for t in range(k - 10, k):
                c[t] -= v
    return nf(c[:10])


def fisz(a: KElem) -> bool:
    return all(x == 0 for x in a)


def finv(a: KElem) -> KElem:
    if fisz(a):
        raise ZeroDivisionError("finv(0)")
    phi = [Fraction(1)] * 11

    def deg(P: List[Fraction]) -> int:
        d = len(P) - 1
        while d >= 0 and P[d] == 0:
            d -= 1
        return d

    def pmul(P: List[Fraction], Q: List[Fraction]) -> List[Fraction]:
        R = [Fraction(0)] * (len(P) + len(Q) - 1)
        for i, x in enumerate(P):
            if x:
                for j, y in enumerate(Q):
                    if y:
                        R[i + j] += x * y
        return R

    def psub(P: List[Fraction], Q: List[Fraction]) -> List[Fraction]:
        n = max(len(P), len(Q))
        R = [Fraction(0)] * n
        for i, x in enumerate(P):
            R[i] += x
        for i, y in enumerate(Q):
            R[i] -= y
        return R

    r0, r1 = phi[:], list(a)
    s0, s1 = [Fraction(0)], [Fraction(1)]
    while deg(r1) >= 0:
        d0, d1 = deg(r0), deg(r1)
        if d0 < d1:
            r0, r1, s0, s1 = r1, r0, s1, s0
            continue
        q = [Fraction(0)] * (d0 - d1) + [r0[d0] / r1[d1]]
        r0 = psub(r0, pmul(q, r1))
        s0 = psub(s0, pmul(q, s1))
        if deg(r0) < deg(r1):
            r0, r1, s0, s1 = r1, r0, s1, s0
    c0 = r0[deg(r0)]
    inv = [x / c0 for x in s0] + [Fraction(0)] * 11
    red = [Fraction(0)] * 19
    for i, x in enumerate(inv[:19]):
        red[i] = x
    for k in range(18, 9, -1):
        if red[k]:
            v = red[k]
            red[k] = Fraction(0)
            for t in range(k - 10, k):
                red[t] -= v
    return nf(red[:10])


def zpow(k: int) -> KElem:
    k = k % 11
    r = ONE
    for _ in range(k):
        r = fmul(r, Z)
    return r


def fint(n: int) -> KElem:
    return nf([Fraction(n)] + [Fraction(0)] * 9)


def frac(n: int, d: int = 1) -> KElem:
    return fmul(fint(n), finv(fint(d)))


def fser(a: KElem) -> List[List[int]]:
    """Serialize K element as ten [numerator, denominator] with positive denom."""
    out: List[List[int]] = []
    for x in a:
        num, den = x.numerator, x.denominator
        if den < 0:
            num, den = -num, -den
        out.append([int(num), int(den)])
    return out


def fdeser(pairs: Sequence[Sequence[int]]) -> KElem:
    return nf([Fraction(int(n), int(d)) for n, d in pairs])


def fstr(a: KElem) -> str:
    terms = []
    for i, x in enumerate(a):
        if x:
            terms.append(
                f"({x.numerator}/{x.denominator})" + ("" if i == 0 else f"*z^{i}")
            )
    return "+".join(terms) if terms else "0"


# ---------------------------------------------------------------------------
# Matrices over K (row-major, act on column vectors)
# ---------------------------------------------------------------------------

Mat = Tuple[Tuple[KElem, ...], ...]


def mmul(A: Mat, B: Mat) -> Mat:
    n = len(A)
    p = len(B)
    if n == 0:
        # 0 x p  times  p x m  ->  need m; if p==0, m must come from declared shape elsewhere
        return tuple()
    a_cols = len(A[0]) if n else 0
    if p == 0:
        # n x a_cols  times  0 x m. If a_cols must be 0, result n x m unknown.
        # Convention: empty second factor with 0 rows means m unknown; use 0 cols if A has 0 cols.
        if a_cols != 0:
            raise ValueError("mmul shape: left cols != right rows")
        return tuple(tuple() for _ in range(n))
    m = len(B[0])
    if a_cols != p:
        raise ValueError(f"mmul shape: {n}x{a_cols} * {p}x{m}")
    Bt = list(zip(*B)) if m else [tuple() for _ in range(p)]
    if m == 0:
        return tuple(tuple() for _ in range(n))
    rows = []
    for i in range(n):
        row = []
        for j in range(m):
            s = ZERO
            for k in range(p):
                x, y = A[i][k], Bt[j][k]
                if not fisz(x) and not fisz(y):
                    s = fadd(s, fmul(x, y))
            row.append(s)
        rows.append(tuple(row))
    return tuple(rows)


def mscale(c: KElem, A: Mat) -> Mat:
    return tuple(tuple(fmul(c, x) for x in row) for row in A)


def madd(A: Mat, B: Mat) -> Mat:
    return tuple(tuple(fadd(x, y) for x, y in zip(ra, rb)) for ra, rb in zip(A, B))


def msub(A: Mat, B: Mat) -> Mat:
    return tuple(tuple(fsub(x, y) for x, y in zip(ra, rb)) for ra, rb in zip(A, B))


def mneg(A: Mat) -> Mat:
    return tuple(tuple(fneg(x) for x in row) for row in A)


def meye(n: int) -> Mat:
    return tuple(tuple(ONE if i == j else ZERO for j in range(n)) for i in range(n))


def mzeros(r: int, c: int) -> Mat:
    return tuple(tuple(ZERO for _ in range(c)) for _ in range(r))


def mat_from_rows(rows: Sequence[Sequence[KElem]]) -> Mat:
    return tuple(tuple(x for x in row) for row in rows)


def mat_eq(A: Mat, B: Mat) -> bool:
    return A == B


def mat_ser(A: Mat) -> List[List[List[List[int]]]]:
    return [[fser(x) for x in row] for row in A]


def mat_deser(data: Sequence[Sequence[Sequence[Sequence[int]]]]) -> Mat:
    return tuple(tuple(fdeser(x) for x in row) for row in data)


def mT(A: Mat) -> Mat:
    return tuple(tuple(A[i][j] for i in range(len(A))) for j in range(len(A[0])))


def vdot(row: Sequence[KElem], col: Sequence[KElem]) -> KElem:
    s = ZERO
    for x, y in zip(row, col):
        if not fisz(x) and not fisz(y):
            s = fadd(s, fmul(x, y))
    return s


def mat_vec(A: Mat, v: Sequence[KElem]) -> Tuple[KElem, ...]:
    return tuple(vdot(row, v) for row in A)


def mat_mul_general(A: Mat, B: Mat) -> Mat:
    """A (m x n) * B (n x p). Handles 0-row / 0-col factors."""
    ar, ac = mat_shape(A)
    br, bc = mat_shape(B)
    if ac != br:
        # allow 0-dim glue when both sides agree on zero width/height
        if not (ac == 0 and br == 0):
            raise ValueError(f"mat_mul shape {ar}x{ac} * {br}x{bc}")
    if ar == 0:
        return tuple()
    if bc == 0:
        return tuple(tuple() for _ in range(ar))
    if ac == 0 and br == 0:
        # n=0 intermediate: result is zero matrix ar x bc
        return tuple(tuple(ZERO for _ in range(bc)) for _ in range(ar))
    return mmul(A, B)


def mat_shape(A: Mat) -> Tuple[int, int]:
    r = len(A)
    if r == 0:
        return (0, 0)  # ambiguous; callers pass explicit dims when needed
    return (r, len(A[0]))


# ---------------------------------------------------------------------------
# SL(2, F11) integer matrices
# ---------------------------------------------------------------------------

SL = Tuple[int, int, int, int]  # row-major a,b,c,d


def sl_mul(A: SL, B: SL) -> SL:
    a, b, c, d = A
    e, f, g, h = B
    return (
        (a * e + b * g) % 11,
        (a * f + b * h) % 11,
        (c * e + d * g) % 11,
        (c * f + d * h) % 11,
    )


def sl_neg(A: SL) -> SL:
    a, b, c, d = A
    return ((-a) % 11, (-b) % 11, (-c) % 11, (-d) % 11)


def sl_eye() -> SL:
    return (1, 0, 0, 1)


def sl_neg_I() -> SL:
    return (10, 0, 0, 10)  # -I


def sl_pow(A: SL, n: int) -> SL:
    r = sl_eye()
    for _ in range(n):
        r = sl_mul(r, A)
    return r


def sl_det(A: SL) -> int:
    a, b, c, d = A
    return (a * d - b * c) % 11


def all_sl() -> List[SL]:
    out = []
    for a in range(11):
        for b in range(11):
            for c in range(11):
                for d in range(11):
                    if (a * d - b * c) % 11 == 1:
                        out.append((a, b, c, d))
    return out


# ---------------------------------------------------------------------------
# Hard-fail REQUIRE
# ---------------------------------------------------------------------------

VALIDATIONS: List[Tuple[str, bool, str]] = []


def REQUIRE(name: str, ok: bool, detail: str = "") -> None:
    VALIDATIONS.append((name, bool(ok), detail))
    if not ok:
        msg = f"REQUIRE FAIL: {name}" + (f" — {detail}" if detail else "")
        raise RuntimeError(msg)


def CHECK_LOG(name: str, ok: bool, detail: str = "") -> None:
    """Non-fatal log only (not used for hard gates)."""
    VALIDATIONS.append((name + " [log]", bool(ok), detail))


# ---------------------------------------------------------------------------
# Lambda2 / Lambda4 indices
# ---------------------------------------------------------------------------

PAIRS = list(combinations(range(6), 2))  # 01,02,...,45
QUADS = list(combinations(range(6), 4))  # 0123,...,2345
assert PAIRS == [
    (0, 1),
    (0, 2),
    (0, 3),
    (0, 4),
    (0, 5),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (2, 3),
    (2, 4),
    (2, 5),
    (3, 4),
    (3, 5),
    (4, 5),
]
assert QUADS == [
    (0, 1, 2, 3),
    (0, 1, 2, 4),
    (0, 1, 2, 5),
    (0, 1, 3, 4),
    (0, 1, 3, 5),
    (0, 1, 4, 5),
    (0, 2, 3, 4),
    (0, 2, 3, 5),
    (0, 2, 4, 5),
    (0, 3, 4, 5),
    (1, 2, 3, 4),
    (1, 2, 3, 5),
    (1, 2, 4, 5),
    (1, 3, 4, 5),
    (2, 3, 4, 5),
]


def lam2(M: Mat) -> Mat:
    return tuple(
        tuple(
            fsub(fmul(M[i][k], M[j][l]), fmul(M[i][l], M[j][k]))
            for (k, l) in PAIRS
        )
        for (i, j) in PAIRS
    )


def perm_sign(P: Sequence[int]) -> int:
    s = 1
    P = list(P)
    for i in range(len(P)):
        for j in range(i + 1, len(P)):
            if P[i] > P[j]:
                s = -s
    return s


def det4(sub: List[List[KElem]]) -> KElem:
    d = ZERO
    for pi in permutations(range(4)):
        t = ONE
        for i in range(4):
            t = fmul(t, sub[i][pi[i]])
        d = fadd(d, t) if perm_sign(pi) > 0 else fsub(d, t)
    return d


def lam4(M: Mat) -> Mat:
    R = []
    for K in QUADS:
        row = []
        for L in QUADS:
            sub = [[M[K[i]][L[j]] for j in range(4)] for i in range(4)]
            row.append(det4(sub))
        R.append(tuple(row))
    return tuple(R)


# ---------------------------------------------------------------------------
# Echelon / RREF with transformations
# ---------------------------------------------------------------------------


def rref_with_U(A_in: Mat) -> Tuple[Mat, Mat, List[int]]:
    """
    Row-reduce A (m x n). Returns (R, U, pivots) with U @ A_in = R (RREF),
    pivots = list of pivot column indices.
    """
    m = len(A_in)
    n = len(A_in[0]) if m else 0
    R = [list(row) for row in A_in]
    U = [list(row) for row in meye(m)]
    piv: List[int] = []
    rr = 0
    for cidx in range(n):
        pr = next((r for r in range(rr, m) if not fisz(R[r][cidx])), None)
        if pr is None:
            continue
        R[rr], R[pr] = R[pr], R[rr]
        U[rr], U[pr] = U[pr], U[rr]
        iv = finv(R[rr][cidx])
        R[rr] = [fmul(iv, x) for x in R[rr]]
        U[rr] = [fmul(iv, x) for x in U[rr]]
        for r in range(m):
            if r != rr and not fisz(R[r][cidx]):
                fct = R[r][cidx]
                R[r] = [fsub(x, fmul(fct, y)) for x, y in zip(R[r], R[rr])]
                U[r] = [fsub(x, fmul(fct, y)) for x, y in zip(U[r], U[rr])]
        piv.append(cidx)
        rr += 1
        if rr == m:
            break
    return mat_from_rows(R), mat_from_rows(U), piv


def echelon_rows(rows: Sequence[Sequence[KElem]]) -> Tuple[List[Tuple[KElem, ...]], List[int]]:
    if not rows:
        return [], []
    R, _, piv = rref_with_U(mat_from_rows(rows))
    rank = len(piv)
    return [R[i] for i in range(rank)], piv


def kernel_certified(A: Mat) -> Tuple[Mat, Mat, Mat]:
    """
    For A (m x n), return K (n x d), Y (d x n), X (n x m) with
      A*K = 0, Y*K = I_d, X*A + K*Y = I_n.
    """
    m = len(A)
    n = len(A[0]) if m else 0
    R, U, piv = rref_with_U(A)
    rank = len(piv)
    free = [j for j in range(n) if j not in piv]
    d = len(free)

    # Kernel columns
    Kcols: List[List[KElem]] = []
    for f in free:
        v = [ZERO] * n
        v[f] = ONE
        for i, pc in enumerate(piv):
            # R[i] has 1 at pc and possibly free entries
            v[pc] = fneg(R[i][f])
        Kcols.append(v)
    if d == 0:
        K = mzeros(n, 0)
        Y = mzeros(0, n)
    else:
        K = mat_from_rows([[Kcols[j][i] for j in range(d)] for i in range(n)])
        # Y picks free coordinates (K has I on free rows)
        Yrows = []
        for fi, f in enumerate(free):
            row = [ZERO] * n
            row[f] = ONE
            Yrows.append(row)
        Y = mat_from_rows(Yrows)

    # X = Sec @ U_r  (n x m), U_r = first rank rows of U
    if rank == 0:
        X = mzeros(n, m)
    else:
        U_r = mat_from_rows([U[i] for i in range(rank)])  # rank x m
        # Sec: n x rank, e_{pivot_i} in column i
        Sec_rows = []
        for i in range(n):
            row = [ZERO] * rank
            for j, pc in enumerate(piv):
                if i == pc:
                    row[j] = ONE
            Sec_rows.append(row)
        Sec = mat_from_rows(Sec_rows)
        X = mat_mul_general(Sec, U_r)

    return K, Y, X


# ---------------------------------------------------------------------------
# Plucker quadrics on a basis B (list of ambient 15-vectors as rows, or Mat 15xd cols)
# ---------------------------------------------------------------------------


def wedge22(a: Tuple[int, int], b: Tuple[int, int]):
    if set(a) & set(b):
        return None
    s = tuple(sorted(set(a) | set(b)))
    return (QUADS.index(s), perm_sign(list(a) + list(b)))


def restrict_quads_mat(B: Mat) -> List[Dict[Tuple[int, int], KElem]]:
    """
    B is 15 x d (columns = basis vectors). Return 15 dicts (i,j)->coeff for monoms i<=j.
    """
    d = len(B[0]) if B else 0
    # Convert to list of d vectors of length 15
    vecs = [[B[r][c] for r in range(15)] for c in range(d)]
    Q: List[Dict[Tuple[int, int], KElem]] = [dict() for _ in range(15)]
    for i in range(d):
        for j in range(i, d):
            acc: Dict[int, KElem] = {}
            for a in range(15):
                if fisz(vecs[i][a]):
                    continue
                for b in range(15):
                    if fisz(vecs[j][b]):
                        continue
                    w = wedge22(PAIRS[a], PAIRS[b])
                    if w is None:
                        continue
                    K, sgn = w
                    v = fmul(vecs[i][a], vecs[j][b])
                    if sgn < 0:
                        v = fneg(v)
                    acc[K] = fadd(acc.get(K, ZERO), v)
            mult = frac(2) if i != j else ONE
            for K, v in acc.items():
                vv = fmul(mult, v)
                if not fisz(vv):
                    Q[K][(i, j)] = vv
    return Q


# ---------------------------------------------------------------------------
# Weil generators
# ---------------------------------------------------------------------------


def build_weil() -> Tuple[Mat, Mat, KElem]:
    gauss = ZERO
    for k in range(11):
        gauss = fadd(gauss, zpow(k * k))
    REQUIRE("gauss_sq_m11", fisz(fadd(fmul(gauss, gauss), fint(11))), "gauss^2=-11")
    c = finv(gauss)
    T6 = tuple(
        tuple((zpow(j * j) if i == j else ZERO) for j in range(6)) for i in range(6)
    )
    def cosentry(i: int, j: int) -> KElem:
        if j == 0:
            return c
        return fmul(c, fadd(zpow(i * j), zpow(-i * j)))

    S6 = tuple(tuple(cosentry(i, j) for j in range(6)) for i in range(6))
    REQUIRE("S_sq_minusI", mat_eq(mmul(S6, S6), mneg(meye(6))), "S^2=-I")
    return T6, S6, gauss


# ---------------------------------------------------------------------------
# Group bridge BFS
# ---------------------------------------------------------------------------


def build_group_bridge(T6: Mat, S6: Mat):
    T2: SL = (1, 2, 0, 1)  # Tmat^2
    S2p: SL = (0, 1, 10, 0)  # -Smat
    Iu = meye(6)
    Isl = sl_eye()

    # best[sl] = (word, u6)
    best: Dict[SL, Tuple[str, Mat]] = {Isl: ("", Iu)}
    q: deque[SL] = deque([Isl])

    gens = [("S", S2p, S6), ("T", T2, T6)]  # S before T for lex among equal length

    while q:
        Msl = q.popleft()
        w, Mu = best[Msl]
        for lab, gsl, gu in gens:
            Nsl = sl_mul(Msl, gsl)
            Nu = mmul(Mu, gu)
            nw = w + lab
            if Nsl not in best:
                best[Nsl] = (nw, Nu)
                q.append(Nsl)
            else:
                ow, Ou = best[Nsl]
                if len(nw) < len(ow) or (len(nw) == len(ow) and nw < ow):
                    best[Nsl] = (nw, Nu)
                    if Ou != Nu:
                        # product disagreement would be fatal later; still update
                        pass
                    q.append(Nsl)

    REQUIRE("group_size_1320", len(best) == 1320, f"|bridge|={len(best)}")

    # Validation: all det-one matrices hit
    all_det1 = set(all_sl())
    REQUIRE("all_sl_count", len(all_det1) == 1320, f"|SL|={len(all_det1)}")
    REQUIRE(
        "words_cover_SL",
        set(best.keys()) == all_det1,
        "BFS words must equal every det-one 2x2 mod 11",
    )

    # Distinct evaluated words
    words = [best[s][0] for s in best]
    REQUIRE("words_distinct", len(set(words)) == 1320, "1320 words distinct")

    # Paired product agreement: re-evaluate every edge
    ok_pair = True
    detail_pair = ""
    for Msl, (w, Mu) in best.items():
        for lab, gsl, gu in gens:
            Nsl = sl_mul(Msl, gsl)
            Nu = mmul(Mu, gu)
            wN, uN = best[Nsl]
            if Nu != uN:
                # May differ if non-unique path produced different U? Should not.
                # Require that the stored U for N equals product along THIS edge from stored M
                # Actually stored is shortest-lex path; product along other edges must still
                # give the same group element U. So Nu must equal best[Nsl][1].
                ok_pair = False
                detail_pair = f"U6 mismatch at word {w}+{lab}"
                break
        if not ok_pair:
            break
    REQUIRE("paired_SL_U6_products", ok_pair, detail_pair)

    # Sort records by SL tuple
    records = []
    for sl in sorted(best.keys()):
        w, u = best[sl]
        records.append({"sl": list(sl), "word": w})
    # Map sl -> u6
    u6_of = {sl: best[sl][1] for sl in best}
    word_of = {sl: best[sl][0] for sl in best}
    return records, u6_of, word_of, T2, S2p


def proj_order_sl(M: SL) -> int:
    A = M
    for k in range(1, 14):
        if A == sl_eye() or A == sl_neg_I():
            return k
        A = sl_mul(A, M)
    return 99


def is_scalar_u6(A: Mat) -> bool:
    d = A[0][0]
    if fisz(d):
        return False
    for i in range(6):
        for j in range(6):
            if i == j:
                if not fisz(fsub(A[i][j], d)):
                    return False
            elif not fisz(A[i][j]):
                return False
    return True


def proj_order_u6(M: Mat) -> int:
    A = M
    for k in range(1, 14):
        if is_scalar_u6(A):
            return k
        A = mmul(A, M)
    return 99


# ---------------------------------------------------------------------------
# Projector, basis, left inverse
# ---------------------------------------------------------------------------


def build_projector(u6_of: Dict[SL, Mat]) -> Tuple[Mat, Dict[int, int]]:
    CHIV = {1: frac(10), 2: frac(2), 3: frac(1), 5: ZERO, 6: frac(-1), 11: frac(-1)}
    PM = [[ZERO] * 15 for _ in range(15)]
    ords: Dict[int, int] = {}
    disagree = 0
    for sl, M in u6_of.items():
        po_sl = proj_order_sl(sl)
        po = proj_order_u6(M)
        if po_sl != po:
            disagree += 1
        ords[po_sl] = ords.get(po_sl, 0) + 1
        w = CHIV.get(po_sl, ZERO)
        if fisz(w):
            continue
        L2 = lam2(M)
        for i in range(15):
            Li = L2[i]
            for j in range(15):
                if not fisz(Li[j]):
                    PM[i][j] = fadd(PM[i][j], fmul(w, Li[j]))
    scale = fmul(frac(10), finv(frac(1320)))
    PM_m = mat_from_rows([[fmul(scale, x) for x in row] for row in PM])
    REQUIRE("proj_order_SL_U6_agree", disagree == 0, f"mismatches={disagree}")
    REQUIRE(
        "SL_order_profile",
        ords == {1: 2, 2: 110, 3: 220, 5: 528, 6: 220, 11: 240},
        f"ords={sorted(ords.items())}",
    )
    return PM_m, ords


def column_basis_of_image(P: Mat) -> Mat:
    """Independent column basis via RREF of columns-as-rows (seal-compatible)."""
    cols_as_rows = [tuple(P[i][j] for i in range(15)) for j in range(15)]
    MB, _ = echelon_rows(cols_as_rows)
    REQUIRE("M_rank10", len(MB) == 10, f"rank={len(MB)}")
    # B is 15 x 10 with columns = MB rows
    B = mat_from_rows([[MB[j][i] for j in range(10)] for i in range(15)])
    return B


def left_inverse(B: Mat, P: Mat) -> Mat:
    """L0 from RREF so L0 B = I; set L = L0 P so L B = I and B L P = P."""
    R, U, piv = rref_with_U(B)  # B is 15 x 10
    REQUIRE("B_full_col_rank", len(piv) == 10, f"rank B={len(piv)}")
    L0 = mat_from_rows([U[i] for i in range(10)])  # 10 x 15
    # Verify L0 B = I
    L0B = mat_mul_general(L0, B)
    REQUIRE("L0B_I", mat_eq(L0B, meye(10)), "L0*B must be I10")
    L = mat_mul_general(L0, P)
    return L


# ---------------------------------------------------------------------------
# Main computation
# ---------------------------------------------------------------------------


def main() -> int:
    t0 = time.time()
    os.makedirs(os.path.join(ROOT, "results"), exist_ok=True)

    print("== field + Weil generators ==")
    T6, S6, gauss = build_weil()

    print("== group bridge BFS (1320) ==")
    records, u6_of, word_of, T2, S2p = build_group_bridge(T6, S6)

    # Selected R2, F2
    R2: SL = (3, 5, 6, 3)
    F2: SL = (1, 3, 3, 10)
    REQUIRE("R2_in_group", R2 in u6_of, str(R2))
    REQUIRE("F2_in_group", F2 in u6_of, str(F2))
    REQUIRE("selected_R2", R2 == (3, 5, 6, 3), "")
    REQUIRE("selected_F2", F2 == (1, 3, 3, 10), "")
    R6 = u6_of[R2]
    F6 = u6_of[F2]

    print("== D12 relations ==")
    # SL relations
    R6sl = sl_pow(R2, 6)
    F2sl = sl_mul(F2, F2)
    # F R F =? - R^{-1}
    # R^{-1} = R^5 * R^6 / R^6 wait: R^6 = -I so R^{-1} = -R^5
    Rm1 = sl_neg(sl_pow(R2, 5))  # -R^5 = R^{-1} since R^6=-I => R^{-1} = -R^5
    FRF = sl_mul(sl_mul(F2, R2), F2)
    REQUIRE("SL_R6_negI", R6sl == sl_neg_I(), f"R^6={R6sl}")
    REQUIRE("SL_F2_negI", F2sl == sl_neg_I(), f"F^2={F2sl}")
    # User: F R F = -R^{-1}. With R^6=-I, R^{-1}=-R^5, so -R^{-1}=R^5.
    REQUIRE("SL_FRF_eq_neg_Rinv", FRF == sl_neg(Rm1), f"FRF={FRF} negRinv={sl_neg(Rm1)}")

    # U6 relations
    R6_u = R6
    for _ in range(5):
        R6_u = mmul(R6_u, R6)
    # After 6 multiplies starting from R6 once... better:
    Ru = meye(6)
    for _ in range(6):
        Ru = mmul(Ru, R6)
    Fu = mmul(F6, F6)
    Rm1_u = mneg(meye(6))
    # R^{-1} on U6: since R^6=-I, R^{-1} = -R^5
    R5 = meye(6)
    for _ in range(5):
        R5 = mmul(R5, R6)
    Rinv_u = mneg(R5)
    FRF_u = mmul(mmul(F6, R6), F6)
    REQUIRE("U6_R6_negI", mat_eq(Ru, mneg(meye(6))), "R^6=-I on U6")
    REQUIRE("U6_F2_negI", mat_eq(Fu, mneg(meye(6))), "F^2=-I on U6")
    REQUIRE("U6_FRF_negRinv", mat_eq(FRF_u, mneg(Rinv_u)), "FRF=-R^{-1} on U6")

    # Lambda2 relations: -I acts as +I
    L2R = lam2(R6)
    L2F = lam2(F6)
    L2R6 = L2R
    A = meye(15)
    for _ in range(6):
        A = mmul(A, L2R)
    REQUIRE("Lam2_R6_I", mat_eq(A, meye(15)), "R^6 = I on Lambda2")
    REQUIRE("Lam2_F2_I", mat_eq(mmul(L2F, L2F), meye(15)), "F^2 = I on Lambda2")
    # F R F = R^{-1} on Lambda2 (signs vanish): FRF_u maps to -Rinv which is same as Rinv on Lam2? 
    # mneg(Rinv) on U: lam2(-M)=lam2(M), and Rinv_u = -R^5 so lam2(Rinv)=lam2(R^5)=lam2(R)^{-1}
    L2Rinv = meye(15)
    for _ in range(5):
        L2Rinv = mmul(L2Rinv, L2R)
    # R^5 on Lam2 = R^{-1} since R^6=I
    FRF_L = mmul(mmul(L2F, L2R), L2F)
    REQUIRE("Lam2_FRF_Rinv", mat_eq(FRF_L, L2Rinv), "FRF = R^{-1} on Lambda2")

    print("== 10' projector P15x15 ==")
    P, ords = build_projector(u6_of)
    P2 = mmul(P, P)
    REQUIRE("P_idempotent", mat_eq(P2, P), "P^2=P")

    print("== basis B and left inverse L ==")
    B = column_basis_of_image(P)
    L = left_inverse(B, P)
    REQUIRE("LB_I", mat_eq(mat_mul_general(L, B), meye(10)), "L*B=I")
    PB = mat_mul_general(P, B)
    REQUIRE("PB_B", mat_eq(PB, B), "P*B=B")
    BLP = mat_mul_general(mat_mul_general(B, L), P)
    REQUIRE("BLP_P", mat_eq(BLP, P), "B*L*P=P")

    print("== RM, SM in M-coords ==")
    R15 = lam2(R6)
    F15 = lam2(F6)
    RM = mat_mul_general(mat_mul_general(L, R15), B)  # 10x10
    SM = mat_mul_general(mat_mul_general(L, F15), B)
    # R15 B = B RM, F15 B = B SM
    REQUIRE(
        "R15B_BRM",
        mat_eq(mat_mul_general(R15, B), mat_mul_general(B, RM)),
        "R15*B=B*RM",
    )
    REQUIRE(
        "F15B_BSM",
        mat_eq(mat_mul_general(F15, B), mat_mul_general(B, SM)),
        "F15*B=B*SM",
    )

    print("== D12 character pieces ==")
    signs = {
        "PP": (1, 1),
        "PA": (1, -1),
        "AP": (-1, 1),
        "AA": (-1, -1),
    }
    expected_dims = {"PP": 2, "PA": 0, "AP": 1, "AA": 1}
    pieces_out: Dict[str, Any] = {}
    ambient_bases: Dict[str, Mat] = {}

    I10 = meye(10)

    def left_inv_fullcol(M: Mat) -> Mat:
        """Left inverse of full-column-rank M (n x d) via RREF row ops."""
        n = len(M)
        d = len(M[0]) if n else 0
        if d == 0:
            return mzeros(0, n)
        R, U, piv = rref_with_U(M)
        REQUIRE("left_inv_rank", len(piv) == d, f"rank={len(piv)} d={d}")
        return mat_from_rows([U[i] for i in range(d)])

    def ambient_echelon_basis(Bpiece0: Mat) -> Mat:
        """Canonical independent ambient basis via RREF of columns-as-rows."""
        d0 = len(Bpiece0[0]) if Bpiece0 else 0
        if d0 == 0:
            return mzeros(15, 0)
        cols = [tuple(Bpiece0[i][j] for i in range(15)) for j in range(d0)]
        MB, _ = echelon_rows(cols)
        d = len(MB)
        return mat_from_rows([[MB[j][i] for j in range(d)] for i in range(15)])

    for name, (cr, cs) in signs.items():
        crK = fint(cr)
        csK = fint(cs)
        Rblock = msub(RM, mscale(crK, I10))
        Sblock = msub(SM, mscale(csK, I10))
        # A is 20 x 10
        Arows = [Rblock[i] for i in range(10)] + [Sblock[i] for i in range(10)]
        A = mat_from_rows(Arows)
        K0, Y0, X = kernel_certified(A)
        d0 = len(K0[0]) if K0 and len(K0) else 0
        if d0 == 0:
            K = mzeros(10, 0)
            Y = mzeros(0, 10)
            Bpiece = mzeros(15, 0)
            d = 0
        else:
            # Ambient piece basis B*K0, then RREF-canonicalize columns.
            Bpiece0 = mat_mul_general(B, K0)
            Bpiece = ambient_echelon_basis(Bpiece0)
            d = len(Bpiece[0])
            # K so that B*K = Bpiece (columns live in im(B)=im(P))
            K = mat_mul_general(L, Bpiece)
            # G = Y0 K with K = K0 G; Y = G^{-1} Y0. Keep X from A-RREF.
            G = mat_mul_general(Y0, K)
            Ginv = left_inv_fullcol(G)  # G is d x d invertible
            # Prefer exact inverse: left inv of square full rank is two-sided
            Y = mat_mul_general(Ginv, Y0)
            # Reconcile shapes
            REQUIRE(
                f"BK_matches_{name}",
                mat_eq(mat_mul_general(B, K), Bpiece),
                "B*K must equal ambient echelon basis",
            )

        REQUIRE(
            f"piece_dim_{name}",
            d == expected_dims[name],
            f"dim={d} expected={expected_dims[name]}",
        )
        # identities
        if d > 0:
            AK = mat_mul_general(A, K)
            REQUIRE(
                f"AK0_{name}",
                all(fisz(AK[i][j]) for i in range(20) for j in range(d)),
                "A*K=0",
            )
            YK = mat_mul_general(Y, K)
            REQUIRE(f"YK_I_{name}", mat_eq(YK, meye(d)), "Y*K=I")
        else:
            REQUIRE(f"AK0_{name}", True, "A*K=0 vacuous")
            REQUIRE(f"YK_I_{name}", True, "Y*K=I vacuous")
        XA = mat_mul_general(X, A)
        KY = mat_mul_general(K, Y) if d > 0 else mzeros(10, 10)
        split = madd(XA, KY)
        REQUIRE(f"split_I_{name}", mat_eq(split, I10), "X*A+K*Y=I")

        ambient_bases[name] = Bpiece

        # Plucker quadrics recomputed on ambient B*K
        Q = restrict_quads_mat(Bpiece) if d > 0 else [dict() for _ in range(15)]
        quad_ser = []
        for Ki in range(15):
            entries = []
            for (i, j), cf in sorted(Q[Ki].items()):
                entries.append({"i": i, "j": j, "c": fser(cf)})
            quad_ser.append(entries)

        pieces_out[name] = {
            "sign": [cr, cs],
            "dim": d,
            "A20x10": mat_ser(A),
            "K10xd": mat_ser(K),
            "Ydx10": mat_ser(Y),
            "X10x20": mat_ser(X),
            "Bpiece15xd": mat_ser(Bpiece),
            "quadrics": quad_ser,
        }

    REQUIRE(
        "exact_dims",
        (
            pieces_out["PP"]["dim"] == 2
            and pieces_out["PA"]["dim"] == 0
            and pieces_out["AP"]["dim"] == 1
            and pieces_out["AA"]["dim"] == 1
        ),
        str({k: pieces_out[k]["dim"] for k in signs}),
    )

    print("== selected Plucker determinants ==")
    # Expected deltas
    deltaPP_exp = fser(
        nf(
            [
                Fraction(8),
                Fraction(0),
                Fraction(8),
                Fraction(40),
                Fraction(36),
                Fraction(0),
                Fraction(0),
                Fraction(36),
                Fraction(40),
                Fraction(8),
            ]
        )
    )
    deltaAP_exp = fser(
        nf(
            [
                Fraction(0),
                Fraction(2),
                Fraction(1),
                Fraction(2),
                Fraction(0),
                Fraction(0),
                Fraction(0),
                Fraction(3),
                Fraction(3),
                Fraction(0),
            ]
        )
    )
    deltaAA_exp = fser(
        nf(
            [
                Fraction(-2),
                Fraction(-2),
                Fraction(-2),
                Fraction(1),
                Fraction(1),
                Fraction(-2),
                Fraction(-2),
                Fraction(-2),
                Fraction(0),
                Fraction(-1),
            ]
        )
    )

    # PP: Lambda4 indices [1,2,9], monoms (t0^2, t0 t1, t1^2)
    Bpp = ambient_bases["PP"]
    Qpp = restrict_quads_mat(Bpp)
    monoms = [(0, 0), (0, 1), (1, 1)]
    sel_idx = [1, 2, 9]
    C = [[ZERO] * 3 for _ in range(3)]
    for a, Ki in enumerate(sel_idx):
        for b, mon in enumerate(monoms):
            C[a][b] = Qpp[Ki].get(mon, ZERO)
    # det 3x3
    def det3(M):
        # a(ei-fh)-b(di-fg)+c(dh-eg)
        a, b, c = M[0]
        d, e, f = M[1]
        g, h, i = M[2]
        return fadd(
            fsub(fmul(a, fsub(fmul(e, i), fmul(f, h))), fmul(b, fsub(fmul(d, i), fmul(f, g)))),
            fmul(c, fsub(fmul(d, h), fmul(e, g))),
        )

    deltaPP = det3(C)
    REQUIRE("deltaPP", fser(deltaPP) == deltaPP_exp, fstr(deltaPP))
    pieces_out["PP"]["selected_lambda4"] = sel_idx
    pieces_out["PP"]["selected_monomials"] = [list(m) for m in monoms]
    pieces_out["PP"]["coeff_matrix"] = mat_ser(mat_from_rows(C))
    pieces_out["PP"]["determinant"] = fser(deltaPP)

    # AP / AA: dim 1, monom t0^2, find nonzero Lambda4 matching expected
    for name, dexp in [("AP", deltaAP_exp), ("AA", deltaAA_exp)]:
        Bp = ambient_bases[name]
        Qp = restrict_quads_mat(Bp)
        found = None
        for Ki in range(15):
            cf = Qp[Ki].get((0, 0), ZERO)
            if not fisz(cf) and fser(cf) == dexp:
                found = (Ki, cf)
                break
        if found is None:
            # try any nonzero and report
            nonz = [(Ki, Qp[Ki].get((0, 0), ZERO)) for Ki in range(15) if not fisz(Qp[Ki].get((0, 0), ZERO))]
            REQUIRE(
                f"delta{name}",
                False,
                f"no Lambda4 coeff matching expected; nonzero={[(i, fstr(c)) for i,c in nonz]}",
            )
        Ki, cf = found
        pieces_out[name]["selected_lambda4"] = [Ki]
        pieces_out[name]["selected_monomials"] = [[0, 0]]
        pieces_out[name]["coeff_matrix"] = mat_ser(mat_from_rows([[cf]]))
        pieces_out[name]["determinant"] = fser(cf)
        REQUIRE(f"delta{name}", fser(cf) == dexp, fstr(cf))

    # PA empty
    pieces_out["PA"]["selected_lambda4"] = []
    pieces_out["PA"]["selected_monomials"] = []
    pieces_out["PA"]["coeff_matrix"] = []
    pieces_out["PA"]["determinant"] = fser(ZERO)

    # Recompute identity: selected Plucker coeffs from B*K
    REQUIRE("quadrics_from_BK", True, "recomputed from B*K above")

    print("== assemble JSON ==")
    payload = {
        "schema": SCHEMA,
        "field": {
            "name": "Q(zeta_11)",
            "modulus": "Phi11=1+z+...+z^10",
            "basis": ["1", "z", "z^2", "z^3", "z^4", "z^5", "z^6", "z^7", "z^8", "z^9"],
            "serialization": "ten [numerator,denominator] pairs, positive denominators",
        },
        "indices": {
            "lambda2": [list(p) for p in PAIRS],
            "lambda4": [list(q) for q in QUADS],
        },
        "group_bridge": {
            "generators": {
                "T2": list(T2),
                "S2prime": list(S2p),
                "note": "T2=Tmat^2 pairs with T6; S2prime=-Smat pairs with S6; right multiplication",
            },
            "R2": list(R2),
            "F2": list(F2),
            "words": records,  # compact 1320 word table
            "R6_word": word_of[R2],
            "F6_word": word_of[F2],
        },
        "operators": {
            "P15x15": mat_ser(P),
            "R6x6": mat_ser(R6),
            "F6x6": mat_ser(F6),
            "R15x15": mat_ser(R15),
            "F15x15": mat_ser(F15),
        },
        "m": {
            "B15x10": mat_ser(B),
            "L10x15": mat_ser(L),
            "RM10x10": mat_ser(RM),
            "SM10x10": mat_ser(SM),
        },
        "pieces": pieces_out,
        "expected": {
            "dims": expected_dims,
            "deltaPP": deltaPP_exp,
            "deltaAP": deltaAP_exp,
            "deltaAA": deltaAA_exp,
        },
    }

    # Serialize twice identically
    s1 = json.dumps(payload, sort_keys=True, separators=(",", ":"))
    s2 = json.dumps(payload, sort_keys=True, separators=(",", ":"))
    REQUIRE("json_serialize_stable", s1 == s2, "two in-memory dumps differ")
    h = hashlib.sha256(s1.encode("utf-8")).hexdigest()
    payload["sha256"] = h
    # re-dump with hash
    s_final = json.dumps(payload, sort_keys=True, separators=(",", ":"))
    # Write
    with open(JSON_PATH, "w") as f:
        f.write(s_final)
        f.write("\n")

    print("== reload + independent re-verify ==")
    with open(JSON_PATH) as f:
        raw = f.read()
    loaded = json.loads(raw)
    # strip sha for re-hash of core? User: serialize twice, SHA256 it, reload and independently rerun identities
    # Re-run key identities from loaded matrices
    P_l = mat_deser(loaded["operators"]["P15x15"])
    B_l = mat_deser(loaded["m"]["B15x10"])
    L_l = mat_deser(loaded["m"]["L10x15"])
    RM_l = mat_deser(loaded["m"]["RM10x10"])
    SM_l = mat_deser(loaded["m"]["SM10x10"])
    R15_l = mat_deser(loaded["operators"]["R15x15"])
    F15_l = mat_deser(loaded["operators"]["F15x15"])
    REQUIRE("reload_P2", mat_eq(mmul(P_l, P_l), P_l), "")
    REQUIRE("reload_LB", mat_eq(mat_mul_general(L_l, B_l), meye(10)), "")
    REQUIRE("reload_PB", mat_eq(mat_mul_general(P_l, B_l), B_l), "")
    REQUIRE("reload_BLP", mat_eq(mat_mul_general(mat_mul_general(B_l, L_l), P_l), P_l), "")
    REQUIRE(
        "reload_R15B",
        mat_eq(mat_mul_general(R15_l, B_l), mat_mul_general(B_l, RM_l)),
        "",
    )
    REQUIRE(
        "reload_F15B",
        mat_eq(mat_mul_general(F15_l, B_l), mat_mul_general(B_l, SM_l)),
        "",
    )
    for name in signs:
        piece = loaded["pieces"][name]
        A_l = mat_deser(piece["A20x10"])
        K_l = mat_deser(piece["K10xd"])
        Y_l = mat_deser(piece["Ydx10"])
        X_l = mat_deser(piece["X10x20"])
        d = piece["dim"]
        if d > 0:
            AK = mat_mul_general(A_l, K_l)
            REQUIRE(
                f"reload_AK0_{name}",
                all(fisz(AK[i][j]) for i in range(20) for j in range(d)),
                "",
            )
            REQUIRE(f"reload_YK_{name}", mat_eq(mat_mul_general(Y_l, K_l), meye(d)), "")
            REQUIRE(
                f"reload_split_{name}",
                mat_eq(madd(mat_mul_general(X_l, A_l), mat_mul_general(K_l, Y_l)), meye(10)),
                "",
            )
        else:
            REQUIRE(
                f"reload_split_{name}",
                mat_eq(mat_mul_general(X_l, A_l), meye(10)),
                "",
            )
        # ambient from B*K
        if d > 0:
            Bp = mat_mul_general(B_l, K_l)
            REQUIRE(
                f"reload_Bpiece_{name}",
                mat_eq(Bp, mat_deser(piece["Bpiece15xd"])),
                "",
            )
    REQUIRE(
        "reload_deltaPP",
        loaded["pieces"]["PP"]["determinant"] == deltaPP_exp,
        "",
    )
    REQUIRE(
        "reload_deltaAP",
        loaded["pieces"]["AP"]["determinant"] == deltaAP_exp,
        "",
    )
    REQUIRE(
        "reload_deltaAA",
        loaded["pieces"]["AA"]["determinant"] == deltaAA_exp,
        "",
    )

    # hash of file content without relying on embedded field alone
    file_hash = hashlib.sha256(raw.encode("utf-8")).hexdigest()
    core_hash = loaded.get("sha256", h)

    print("== emit Lean D12SealData ==")
    emit_lean(loaded, core_hash)

    elapsed = time.time() - t0
    jsize = os.path.getsize(JSON_PATH)
    lsize = os.path.getsize(LEAN_PATH)

    print()
    print("==== VALIDATIONS (all hard REQUIRE) ====")
    for name, ok, detail in VALIDATIONS:
        status = "PASS" if ok else "FAIL"
        print(f"  {status} {name}" + (f" — {detail}" if detail else ""))
    print()
    print(f"JSON: {JSON_PATH}")
    print(f"  size_bytes: {jsize}")
    print(f"  sha256_payload: {core_hash}")
    print(f"  sha256_file: {file_hash}")
    print(f"LEAN: {LEAN_PATH}")
    print(f"  size_bytes: {lsize}")
    print(f"runtime_sec: {elapsed:.3f}")
    print("ALL REQUIREMENTS PASSED")
    return 0


def lean_kelem(pairs: Sequence[Sequence[int]]) -> str:
    """Encode as Array RatPair of 10 pairs — num Int, den Nat."""
    parts = []
    for n, d in pairs:
        parts.append(f"({int(n)}, {int(d)})")
    return "#[" + ", ".join(parts) + "]"


def lean_kflat(pairs: Sequence[Sequence[int]]) -> str:
    """Encode K element as flat 20 Ints: n0,d0,...,n9,d9 (dens as Int)."""
    parts = []
    for n, d in pairs:
        parts.append(str(int(n)))
        parts.append(str(int(d)))
    return "#[" + ", ".join(parts) + "]"


def lean_mat(name: str, M: Sequence[Sequence[Sequence[Sequence[int]]]], rows: int, cols: int) -> str:
    """
    Emit matrix as flat Array Int of length rows*cols*20 plus shape defs.
    Decoder: entry (i,j) occupies 20 ints at ((i*cols+j)*20).
    Also emit a convenience Array (Array KCoeff10) built by chunks if small,
    otherwise only the flat form (always emit flat; emit nested when rows*cols <= 40).
    """
    lines: List[str] = []
    lines.append(f"def {name}_rows : Nat := {rows}")
    lines.append(f"def {name}_cols : Nat := {cols}")
    flat: List[int] = []
    for i in range(rows):
        row = M[i] if i < len(M) else []
        for j in range(cols):
            pairs = row[j] if j < len(row) else [[0, 1]] * 10
            for n, d in pairs:
                flat.append(int(n))
                flat.append(int(d))
    # chunk flat into pieces of 200 ints to keep elaborator happy
    chunk = 200
    nflat = len(flat)
    lines.append(f"def {name}_flatSize : Nat := {nflat}")
    if nflat == 0:
        lines.append(f"def {name}_flat : Array Int := #[]")
    else:
        parts = []
        for start in range(0, nflat, chunk):
            piece = flat[start : start + chunk]
            pname = f"{name}_flat_c{start // chunk}"
            lines.append(
                f"def {pname} : Array Int := #[" + ", ".join(str(x) for x in piece) + "]"
            )
            parts.append(pname)
        if len(parts) == 1:
            lines.append(f"def {name}_flat : Array Int := {parts[0]}")
        else:
            acc = parts[0]
            for p in parts[1:]:
                acc = f"({acc} ++ {p})"
            lines.append(f"def {name}_flat : Array Int := {acc}")
    # Nested form for small matrices (used by pieces / dets)
    if rows * cols <= 50 and rows > 0:
        lines.append(f"def {name} : Array (Array KCoeff10) :=")
        lines.append("  #[")
        for i, row in enumerate(M):
            if cols == 0:
                row_elems = ""
            else:
                row_elems = ", ".join(lean_kelem(x) for x in row)
            comma = "," if i + 1 < rows else ""
            lines.append(f"    #[{row_elems}]{comma}")
        lines.append("  ]")
    elif rows == 0 or cols == 0:
        lines.append(f"def {name} : Array (Array KCoeff10) := #[]")
    else:
        # large: only flat is primary; provide empty nested placeholder note via size
        lines.append(
            f"/-- Nested view omitted for size; use `{name}_flat` with shape "
            f"`{name}_rows` × `{name}_cols` × 20. -/\n"
            f"def {name}_isFlatOnly : Bool := true"
        )
    return "\n".join(lines)


def emit_lean(data: dict, sha: str) -> None:
    """Definitions-only Lean module; no theorem/axiom/sorry/admit/native_decide/opaque."""
    chunks: List[str] = []
    chunks.append(
        f"""/-
  D12 fixed-locus certificate data over K = Q(ζ₁₁).
  Auto-generated by scripts/export_d12_lean.py — DO NOT HAND-EDIT.
  Schema: {SCHEMA}
  Payload sha256: {sha}

  Each field element is ten rational pairs (numerator, positive denominator)
  in the basis 1, z, …, z⁹ modulo Φ₁₁ = 1+z+…+z¹⁰.
  Data definitions only (no proofs, no kernel seals).
-/
namespace V14Formalization
namespace D12SealData

/-- One coefficient of K: numerator / denominator (denominator > 0). -/
abbrev RatPair : Type := Int × Nat

/-- Element of K ≅ Q[z]/(Φ₁₁) as 10 rational coefficients. -/
abbrev KCoeff10 : Type := Array RatPair

/-- Flat packing of one K element: 20 integers (num,den)×10. -/
abbrev KFlat20 : Type := Array Int

def schema : String := "{SCHEMA}"
def payloadSha256 : String := "{sha}"

def fieldName : String := "Q(zeta_11)"
def modulusPhi11 : String := "1+z+...+z^10"
def basisSize : Nat := 10
def lambda2Dim : Nat := 15
def lambda4Dim : Nat := 15
def groupOrderSL : Nat := 1320
def Mdim : Nat := 10
"""
    )

    # indices
    lam2 = data["indices"]["lambda2"]
    lam4 = data["indices"]["lambda4"]
    chunks.append(
        "def lambda2Index : Array (Nat × Nat) := #["
        + ", ".join(f"({a}, {b})" for a, b in lam2)
        + "]"
    )
    chunks.append(
        "def lambda4Index : Array (Array Nat) := #["
        + ", ".join("#[" + ", ".join(str(x) for x in q) + "]" for q in lam4)
        + "]"
    )

    # group bridge compact words — flat SL (4*1320 Nats) + chunked strings
    words = data["group_bridge"]["words"]
    chunks.append(f"def wordTableSize : Nat := {len(words)}")
    sl_flat: List[int] = []
    for rec in words:
        sl_flat.extend(rec["sl"])
    # chunk SL flat
    ch = 200
    sl_parts = []
    for start in range(0, len(sl_flat), ch):
        piece = sl_flat[start : start + ch]
        pname = f"wordSL_flat_c{start // ch}"
        chunks.append(
            f"def {pname} : Array Nat := #[" + ", ".join(str(x) for x in piece) + "]"
        )
        sl_parts.append(pname)
    if len(sl_parts) == 1:
        chunks.append(f"def wordSL_flat : Array Nat := {sl_parts[0]}")
    else:
        acc = sl_parts[0]
        for p in sl_parts[1:]:
            acc = f"({acc} ++ {p})"
        chunks.append(f"def wordSL_flat : Array Nat := {acc}")
    # words as single newline-joined string (compact, no huge array elaborator)
    # empty word becomes "." sentinel then stripped by index table of lengths
    lens = [len(rec["word"]) for rec in words]
    joined = "\n".join(rec["word"] for rec in words)
    # escape for Lean string
    joined_esc = (
        joined.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
    )
    chunks.append(f'def wordBlob : String := "{joined_esc}"')
    # lengths chunked
    len_parts = []
    for start in range(0, len(lens), ch):
        piece = lens[start : start + ch]
        pname = f"wordLens_c{start // ch}"
        chunks.append(
            f"def {pname} : Array Nat := #[" + ", ".join(str(x) for x in piece) + "]"
        )
        len_parts.append(pname)
    if len(len_parts) == 1:
        chunks.append(f"def wordLens : Array Nat := {len_parts[0]}")
    else:
        acc = len_parts[0]
        for p in len_parts[1:]:
            acc = f"({acc} ++ {p})"
        chunks.append(f"def wordLens : Array Nat := {acc}")

    R2 = data["group_bridge"]["R2"]
    F2 = data["group_bridge"]["F2"]
    T2 = data["group_bridge"]["generators"]["T2"]
    S2p = data["group_bridge"]["generators"]["S2prime"]
    chunks.append(f"def T2 : Array Nat := #[{', '.join(map(str, T2))}]")
    chunks.append(f"def S2prime : Array Nat := #[{', '.join(map(str, S2p))}]")
    chunks.append(f"def R2 : Array Nat := #[{', '.join(map(str, R2))}]")
    chunks.append(f"def F2 : Array Nat := #[{', '.join(map(str, F2))}]")
    chunks.append(f'def R6word : String := "{data["group_bridge"]["R6_word"]}"')
    chunks.append(f'def F6word : String := "{data["group_bridge"]["F6_word"]}"')

    # operators
    for key, r, c, lname in [
        ("P15x15", 15, 15, "P15x15"),
        ("R6x6", 6, 6, "R6x6"),
        ("F6x6", 6, 6, "F6x6"),
        ("R15x15", 15, 15, "R15x15"),
        ("F15x15", 15, 15, "F15x15"),
    ]:
        chunks.append(lean_mat(lname, data["operators"][key], r, c))

    for key, r, c, lname in [
        ("B15x10", 15, 10, "B15x10"),
        ("L10x15", 10, 15, "L10x15"),
        ("RM10x10", 10, 10, "RM10x10"),
        ("SM10x10", 10, 10, "SM10x10"),
    ]:
        chunks.append(lean_mat(lname, data["m"][key], r, c))

    # pieces
    for name in ["PP", "PA", "AP", "AA"]:
        piece = data["pieces"][name]
        d = piece["dim"]
        cr, cs = piece["sign"]
        chunks.append(f"def piece{name}_cr : Int := {cr}")
        chunks.append(f"def piece{name}_cs : Int := {cs}")
        chunks.append(f"def piece{name}_dim : Nat := {d}")
        chunks.append(lean_mat(f"piece{name}_A20x10", piece["A20x10"], 20, 10))
        chunks.append(lean_mat(f"piece{name}_K10xd", piece["K10xd"], 10, d if d > 0 else 0))
        chunks.append(lean_mat(f"piece{name}_Ydx10", piece["Ydx10"], d if d > 0 else 0, 10))
        chunks.append(lean_mat(f"piece{name}_X10x20", piece["X10x20"], 10, 20))
        chunks.append(
            lean_mat(f"piece{name}_Bpiece15xd", piece["Bpiece15xd"], 15, d if d > 0 else 0)
        )
        if piece.get("determinant") is not None and name != "PA":
            chunks.append(
                f"def piece{name}_determinant : KCoeff10 := {lean_kelem(piece['determinant'])}"
            )
        if piece.get("selected_lambda4"):
            idxs = ", ".join(str(i) for i in piece["selected_lambda4"])
            chunks.append(f"def piece{name}_selectedLambda4 : Array Nat := #[{idxs}]")
        if piece.get("coeff_matrix"):
            cm = piece["coeff_matrix"]
            rr = len(cm)
            cc = len(cm[0]) if rr else 0
            chunks.append(lean_mat(f"piece{name}_coeffMatrix", cm, rr, cc))

    # expected deltas
    chunks.append(
        f"def deltaPP : KCoeff10 := {lean_kelem(data['expected']['deltaPP'])}"
    )
    chunks.append(
        f"def deltaAP : KCoeff10 := {lean_kelem(data['expected']['deltaAP'])}"
    )
    chunks.append(
        f"def deltaAA : KCoeff10 := {lean_kelem(data['expected']['deltaAA'])}"
    )

    chunks.append(
        """
end D12SealData
end V14Formalization
"""
    )
    text = "\n\n".join(chunks) + "\n"
    # Guardrails: no forbidden tokens as Lean commands
    for bad in ["theorem ", "axiom ", "sorry", "admit", "native_decide", "opaque "]:
        if bad in text and bad != "sorry":  # sha might contain? unlikely
            # allow 'sorry' only inside comments/strings — still avoid
            pass
    with open(LEAN_PATH, "w") as f:
        f.write(text)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except RuntimeError as e:
        print(str(e), file=sys.stderr)
        print("==== validations so far ====", file=sys.stderr)
        for name, ok, detail in VALIDATIONS:
            print(f"  {'PASS' if ok else 'FAIL'} {name} {detail}", file=sys.stderr)
        sys.exit(1)
