#!/usr/bin/env python3
"""
Deterministic exact sigma-fixed-piece normal-form exporter.

Reads:  results/d12_lean_K.json
Writes: results/sigma_normal_form_K.json

S := R^3 on Lambda^2 (the actual sigma action from the D12 data).
Computes exact P-fixed S = +/-1 bases, restricted NORMALIZED Plucker quadrics,
minus-component P1 + squarefree binary quadratic certificate, and attempts a
plus-component 2-Veronese / plane-cubic certificate.

Minus completeness requires BOTH directions over Q(zeta_11):
  forward: each restricted Plucker q_i lies in J=(L1,L2,Q)  =>  V(J) subset V(I)
  reverse: eight constant-coeff identities
      y_j * L_i = sum_q c_{i,j,q} * Qminus_q   (i=1,2; j=0,1,2,3; exponent 1)
    which force L1=L2=0 at every nonzero projective common zero of the q_i
    => V(I) subset V(L1,L2) in P^3.
Combined with P1 parametrization, pullback lambdas (ref lambda=1), and disc(f)!=0,
this certifies equality of the reduced projective zero locus of I with the
reduced binary-quadratic divisor V(L1,L2,f) on that P1.
If the eight reverse identities cannot be exported/verified, status is partial
(not complete). No unsupported M2 booleans as certificates.

Hard-fails (REQUIRE) on validation errors for exported claims. Atomic
deterministic output, regenerated twice byte-identically. Fail-closed verify
recomputes input hashes, P/R/S, wedge factor two, ranks, pullbacks, and
the eight reverse identities; rejects tampering.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import sys
import tempfile
from fractions import Fraction
from itertools import combinations
from typing import Any, Dict, List, Optional, Sequence, Tuple

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
D12_PATH = os.path.join(ROOT, "results", "d12_lean_K.json")
OUT_PATH = os.path.join(ROOT, "results", "sigma_normal_form_K.json")
WORK_DIR = os.path.join(ROOT, "results", "sigma_normal_form_work")
SCHEMA = "v14.fix_ix.sigma_normal_form.v1"

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


def fint(n: int) -> KElem:
    return nf([Fraction(n)] + [Fraction(0)] * 9)


def frac(n: int, d: int = 1) -> KElem:
    return fmul(fint(n), finv(fint(d)))


def fser(a: KElem) -> List[List[int]]:
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


def mat_from_rows(rows: Sequence[Sequence[KElem]]) -> Mat:
    return tuple(tuple(x for x in row) for row in rows)


def mat_shape(A: Mat) -> Tuple[int, int]:
    r = len(A)
    if r == 0:
        return (0, 0)
    return (r, len(A[0]))


def meye(n: int) -> Mat:
    return tuple(tuple(ONE if i == j else ZERO for j in range(n)) for i in range(n))


def mzeros(r: int, c: int) -> Mat:
    return tuple(tuple(ZERO for _ in range(c)) for _ in range(r))


def madd(A: Mat, B: Mat) -> Mat:
    return tuple(tuple(fadd(x, y) for x, y in zip(ra, rb)) for ra, rb in zip(A, B))


def msub(A: Mat, B: Mat) -> Mat:
    return tuple(tuple(fsub(x, y) for x, y in zip(ra, rb)) for ra, rb in zip(A, B))


def mneg(A: Mat) -> Mat:
    return tuple(tuple(fneg(x) for x in row) for row in A)


def mscale(c: KElem, A: Mat) -> Mat:
    return tuple(tuple(fmul(c, x) for x in row) for row in A)


def mmul(A: Mat, B: Mat) -> Mat:
    n = len(A)
    p = len(B)
    if n == 0:
        return tuple()
    a_cols = len(A[0]) if n else 0
    if p == 0:
        if a_cols != 0:
            raise ValueError("mmul shape")
        return tuple(tuple() for _ in range(n))
    m = len(B[0])
    if a_cols != p:
        raise ValueError(f"mmul shape: {n}x{a_cols} * {p}x{m}")
    Bt = list(zip(*B))
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


def mat_eq(A: Mat, B: Mat) -> bool:
    return A == B


def mat_ser(A: Mat) -> List[List[List[List[int]]]]:
    return [[fser(x) for x in row] for row in A]


def mat_deser(data: Sequence[Sequence[Sequence[Sequence[int]]]]) -> Mat:
    return tuple(tuple(fdeser(x) for x in row) for row in data)


def mat_vec(A: Mat, v: Sequence[KElem]) -> Tuple[KElem, ...]:
    out = []
    for row in A:
        s = ZERO
        for x, y in zip(row, v):
            if not fisz(x) and not fisz(y):
                s = fadd(s, fmul(x, y))
        out.append(s)
    return tuple(out)


# ---------------------------------------------------------------------------
# REQUIRE / validation log
# ---------------------------------------------------------------------------

VALIDATIONS: List[Tuple[str, bool, str]] = []


def REQUIRE(name: str, ok: bool, detail: str = "") -> None:
    VALIDATIONS.append((name, bool(ok), detail))
    if not ok:
        msg = f"REQUIRE FAIL: {name}" + (f" — {detail}" if detail else "")
        raise RuntimeError(msg)


# ---------------------------------------------------------------------------
# Linear algebra
# ---------------------------------------------------------------------------


def rref_with_U(A_in: Mat) -> Tuple[Mat, Mat, List[int]]:
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


def column_basis_of_image(Pproj: Mat, ambient: int = 15) -> Mat:
    cols_as_rows = [
        tuple(Pproj[i][j] for i in range(ambient)) for j in range(ambient)
    ]
    R, _, piv = rref_with_U(mat_from_rows(cols_as_rows))
    rank = len(piv)
    MB = [R[i] for i in range(rank)]
    B = mat_from_rows([[MB[j][i] for j in range(rank)] for i in range(ambient)])
    return B


def left_inverse_via_projector(B: Mat, Pproj: Mat) -> Mat:
    """L0 from RREF (L0 B = I); L = L0 Pproj so L B = I and B L = Pproj."""
    R, U, piv = rref_with_U(B)
    d = len(B[0])
    REQUIRE("B_full_col_rank", len(piv) == d, f"rank={len(piv)} d={d}")
    L0 = mat_from_rows([U[i] for i in range(d)])
    REQUIRE("L0B_I", mat_eq(mmul(L0, B), meye(d)), "L0*B = I")
    L = mmul(L0, Pproj)
    return L


# ---------------------------------------------------------------------------
# Plucker indices and NORMALIZED restriction
# ---------------------------------------------------------------------------

PAIRS = list(combinations(range(6), 2))
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
PAIR_INDEX = {p: i for i, p in enumerate(PAIRS)}
QUADS = list(combinations(range(6), 4))
assert len(QUADS) == 15

# Monomials x_i x_j for i <= j
def monoms(d: int) -> List[Tuple[int, int]]:
    return [(i, j) for i in range(d) for j in range(i, d)]


QuadCoeffs = Dict[Tuple[int, int], KElem]  # upper-tri poly coeffs of normalized Plucker


def restrict_normalized_plucker(B: Mat) -> List[QuadCoeffs]:
    """
    Restrict the 15 NORMALIZED Plucker quadrics
      p_ab p_cd - p_ac p_bd + p_ad p_bc
    to the column-span of B (15 x d). Returns one upper-tri coeff dict per quad.
    """
    d = len(B[0]) if B else 0
    out: List[QuadCoeffs] = []
    for Q in QUADS:
        a, b, c, e = Q
        # three pair partitions with signs of the normalized form
        parts = [
            ((a, b), (c, e), +1),
            ((a, c), (b, e), -1),
            ((a, e), (b, c), +1),
        ]
        # bilinear accumulation M[k][l] for coeff of x_k * (from p_p1) * x_l (from p_p2)
        M = [[ZERO] * d for _ in range(d)]
        for p1, p2, sgn in parts:
            i1 = PAIR_INDEX[p1]
            i2 = PAIR_INDEX[p2]
            for k in range(d):
                if fisz(B[i1][k]):
                    continue
                for l in range(d):
                    if fisz(B[i2][l]):
                        continue
                    term = fmul(B[i1][k], B[i2][l])
                    if sgn < 0:
                        term = fneg(term)
                    M[k][l] = fadd(M[k][l], term)
        coeffs: QuadCoeffs = {}
        for i in range(d):
            for j in range(i, d):
                if i == j:
                    v = M[i][i]
                else:
                    # poly monom x_i x_j has coeff M[i][j] + M[j][i]
                    v = fadd(M[i][j], M[j][i])
                if not fisz(v):
                    coeffs[(i, j)] = v
        out.append(coeffs)
    return out


def normalized_plucker_value_at(p: Sequence[KElem], Q: Tuple[int, int, int, int]) -> KElem:
    """Normalized Plucker p_ab p_cd - p_ac p_bd + p_ad p_bc at ambient p."""
    a, b, c, e = Q

    def pcoord(i: int, j: int) -> KElem:
        return p[PAIR_INDEX[(i, j)]]

    val = fsub(
        fmul(pcoord(a, b), pcoord(c, e)),
        fmul(pcoord(a, c), pcoord(b, e)),
    )
    return fadd(val, fmul(pcoord(a, e), pcoord(b, c)))


def verify_normalized_vs_direct(B: Mat, quads: List[QuadCoeffs], tag: str = "") -> None:
    """
    Coefficient-complete check: for every monom x_r x_s (r<=s) and every Plucker,
    the restricted coeff matches direct ambient evaluation recovery.
    No sampling cap — all binom(d+1,2) monoms (21 when d=6, 10 when d=4).
    """
    d = len(B[0])
    mons = monoms(d)
    prefix = f"{tag}_" if tag else ""
    REQUIRE(
        f"{prefix}plucker_quad_count",
        len(quads) == 15,
        str(len(quads)),
    )
    REQUIRE(
        f"{prefix}monom_count",
        len(mons) == d * (d + 1) // 2,
        f"d={d} monoms={len(mons)}",
    )

    # Direct ambient evaluation at each monom support vector e_r (+ e_s).
    # For quadratics this recovers every coefficient:
    #   c_rr = Q(e_r),  c_rs = Q(e_r+e_s) - Q(e_r) - Q(e_s).
    def monom_vector(r: int, s: int) -> Tuple[KElem, ...]:
        x = [ZERO] * d
        x[r] = ONE
        if s != r:
            x[s] = ONE
        return tuple(x)

    # Precompute direct values at e_i and e_i+e_j for all monoms.
    diag_direct: List[List[KElem]] = [[ZERO] * d for _ in range(15)]
    for i in range(d):
        p = mat_vec(B, monom_vector(i, i))
        for qi, Q in enumerate(QUADS):
            diag_direct[qi][i] = normalized_plucker_value_at(p, Q)

    for qi in range(15):
        q = quads[qi]
        for (r, s) in mons:
            x = monom_vector(r, s)
            p = mat_vec(B, x)
            val_direct = normalized_plucker_value_at(p, QUADS[qi])
            val_restr = eval_quad(q, x)
            REQUIRE(
                f"{prefix}plucker_eval_Q{qi}_m{r}_{s}",
                fisz(fsub(val_direct, val_restr)),
                f"direct vs restricted mismatch at monom ({r},{s})",
            )
            # Coefficient recovery (coefficient-complete, not just point values).
            if r == s:
                c_rec = val_direct
            else:
                c_rec = fsub(
                    fsub(val_direct, diag_direct[qi][r]),
                    diag_direct[qi][s],
                )
            c_stored = q.get((r, s), ZERO)
            REQUIRE(
                f"{prefix}plucker_coeff_Q{qi}_m{r}_{s}",
                fisz(fsub(c_rec, c_stored)),
                f"coeff mismatch monom ({r},{s})",
            )


def wedge_restrict(B: Mat) -> List[QuadCoeffs]:
    """
    Old w-wedge-w convention (twice normalized) for cross-check only.
    Returns one upper-tri coeff dict per Plucker quad index.
    """
    d = len(B[0])
    vecs = [[B[r][c] for r in range(15)] for c in range(d)]

    def perm_sign(Pseq: Sequence[int]) -> int:
        s = 1
        Pseq = list(Pseq)
        for i in range(len(Pseq)):
            for j in range(i + 1, len(Pseq)):
                if Pseq[i] > Pseq[j]:
                    s = -s
        return s

    def wedge22(a: Tuple[int, int], b: Tuple[int, int]):
        if set(a) & set(b):
            return None
        s = tuple(sorted(set(a) | set(b)))
        return (QUADS.index(s), perm_sign(list(a) + list(b)))

    Qw: List[QuadCoeffs] = [dict() for _ in range(15)]
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
                    Qw[K][(i, j)] = vv
    return Qw


def verify_wedge_equals_twice_normalized(
    B: Mat, Qnorm: List[QuadCoeffs], tag: str
) -> None:
    """
    Exhaustive: for every Plucker index and every monom coeff on the piece,
    wedge coeff == 2 * normalized coeff. Fail-closed before any global flag.
    """
    d = len(B[0])
    mons = monoms(d)
    W = wedge_restrict(B)
    two = fint(2)
    REQUIRE(f"wedge_{tag}_quad_count", len(W) == 15 and len(Qnorm) == 15, "")
    for K in range(15):
        for key in mons:
            qv = Qnorm[K].get(key, ZERO)
            wv = W[K].get(key, ZERO)
            REQUIRE(
                f"wedge_is_twice_normalized_{tag}_Q{K}_{key[0]}_{key[1]}",
                fisz(fsub(wv, fmul(two, qv))),
                f"wedge={fstr(wv)} 2*norm={fstr(fmul(two, qv))}",
            )


def quad_to_row(q: QuadCoeffs, d: int) -> Tuple[KElem, ...]:
    return tuple(q.get(m, ZERO) for m in monoms(d))


def row_to_quad(row: Sequence[KElem], d: int) -> QuadCoeffs:
    out: QuadCoeffs = {}
    for m, c in zip(monoms(d), row):
        if not fisz(c):
            out[m] = c
    return out


def echelon_span(rows: Sequence[Sequence[KElem]]) -> Tuple[List[Tuple[KElem, ...]], List[int]]:
    if not rows:
        return [], []
    R, _, piv = rref_with_U(mat_from_rows(rows))
    rank = len(piv)
    return [R[i] for i in range(rank)], piv


def ser_quad(q: QuadCoeffs) -> List[Dict[str, Any]]:
    items = []
    for (i, j) in sorted(q.keys()):
        items.append({"i": i, "j": j, "c": fser(q[(i, j)])})
    return items


def deser_quad(items: Sequence[Dict[str, Any]]) -> QuadCoeffs:
    q: QuadCoeffs = {}
    for it in items:
        q[(int(it["i"]), int(it["j"]))] = fdeser(it["c"])
    return q


def linear_form_times_linear(
    ell: Sequence[KElem], L: Sequence[KElem]
) -> QuadCoeffs:
    """Product of two linear forms as upper-tri poly coeffs on P^{n-1}."""
    n = len(ell)
    REQUIRE("lin_prod_len", n == len(L), f"{n} vs {len(L)}")
    M = [[ZERO] * n for _ in range(n)]
    for i in range(n):
        if fisz(ell[i]):
            continue
        for j in range(n):
            if fisz(L[j]):
                continue
            M[i][j] = fadd(M[i][j], fmul(ell[i], L[j]))
    out: QuadCoeffs = {}
    for i in range(n):
        for j in range(i, n):
            v = M[i][i] if i == j else fadd(M[i][j], M[j][i])
            if not fisz(v):
                out[(i, j)] = v
    return out


def quad_add(q1: QuadCoeffs, q2: QuadCoeffs) -> QuadCoeffs:
    keys = set(q1) | set(q2)
    out: QuadCoeffs = {}
    for k in keys:
        v = fadd(q1.get(k, ZERO), q2.get(k, ZERO))
        if not fisz(v):
            out[k] = v
    return out


def quad_scale(s: KElem, q: QuadCoeffs) -> QuadCoeffs:
    if fisz(s):
        return {}
    return {k: fmul(s, v) for k, v in q.items() if not fisz(fmul(s, v))}


def quad_sub(q1: QuadCoeffs, q2: QuadCoeffs) -> QuadCoeffs:
    return quad_add(q1, quad_scale(fneg(ONE), q2))


def quad_eq(q1: QuadCoeffs, q2: QuadCoeffs) -> bool:
    return len(quad_sub(q1, q2)) == 0


def eval_quad(q: QuadCoeffs, x: Sequence[KElem]) -> KElem:
    acc = ZERO
    for (i, j), cf in q.items():
        if i == j:
            acc = fadd(acc, fmul(cf, fmul(x[i], x[i])))
        else:
            acc = fadd(acc, fmul(cf, fmul(x[i], x[j])))
    return acc


# ---------------------------------------------------------------------------
# Minus normal form: P1 + squarefree binary quadratic
# ---------------------------------------------------------------------------


def solve_linear_system(A: Mat, b: Sequence[KElem]) -> Optional[Tuple[KElem, ...]]:
    """Solve A x = b (m equations, n unknowns). Return one solution or None."""
    m = len(A)
    n = len(A[0]) if m else 0
    # augment
    Aug = mat_from_rows([tuple(list(A[i]) + [b[i]]) for i in range(m)])
    R, _, piv = rref_with_U(Aug)
    # check consistency
    for i in range(len(R)):
        row = R[i]
        if all(fisz(row[j]) for j in range(n)) and not fisz(row[n]):
            return None
    x = [ZERO] * n
    for i, pc in enumerate(piv):
        if pc >= n:
            return None
        x[pc] = R[i][n]
    return tuple(x)


def minus_normal_form(
    Bm: Mat, Qm: List[QuadCoeffs]
) -> Dict[str, Any]:
    """
    Exact saturated normal form for the minus piece:
      two independent linears cutting a P1, squarefree binary quadratic f on that P1.
    Linears from the M2/GB structure, re-verified by pullback identities.
    """
    d = 4
    REQUIRE("minus_dim4", len(Bm[0]) == 4, str(len(Bm[0])))

    # Exact linears from saturated GB over K (verified below by pullback):
    # L1: y1 + a y2 + b y3 = 0
    # L2: y0 + c y2 + d y3 = 0
    # with a,b,c,d in K as in results of saturate(Im) over Q(zeta_11).
    def sparse(dmap: Dict[int, int]) -> KElem:
        c = [Fraction(0)] * 10
        for i, v in dmap.items():
            c[i] = Fraction(v)
        return nf(c)

    a = sparse({2: -1, 3: -1, 5: -1, 6: -1, 8: -1, 9: -1})
    b = sparse({0: 2, 2: 1, 3: 2, 4: -1, 5: 2, 6: 2, 7: -1, 8: 2, 9: 1})
    c = sparse({3: -1, 4: -1, 5: -1, 6: -1, 7: -1, 8: -1})
    dd = sparse({0: 2, 3: 1, 8: 1})

    # L2 coeffs on (y0,y1,y2,y3): (1, 0, c, d)
    # L1 coeffs: (0, 1, a, b)
    L2_coeffs = (ONE, ZERO, c, dd)
    L1_coeffs = (ZERO, ONE, a, b)

    # Parametrization of the P1: y = s*v0 + t*v1
    v0 = (fneg(c), fneg(a), ONE, ZERO)
    v1 = (fneg(dd), fneg(b), ZERO, ONE)

    # Verify linears vanish on the image
    for s_val, t_val in ((ONE, ZERO), (ZERO, ONE), (ONE, ONE), (fint(2), ONE)):
        y = tuple(
            fadd(fmul(s_val, v0[i]), fmul(t_val, v1[i])) for i in range(4)
        )
        for L, name in ((L1_coeffs, "L1"), (L2_coeffs, "L2")):
            val = ZERO
            for i in range(4):
                val = fadd(val, fmul(L[i], y[i]))
            REQUIRE(f"linear_{name}_vanishes_on_P1", fisz(val), fstr(val))

    def pullback_binary(q: QuadCoeffs) -> Tuple[KElem, KElem, KElem]:
        """Pull q back to (s:t) along y = s v0 + t v1 -> (A,B,C) for A s^2 + B s t + C t^2."""
        A = ZERO
        B = ZERO
        C = ZERO
        for (i, j), cf in q.items():
            if i == j:
                A = fadd(A, fmul(cf, fmul(v0[i], v0[i])))
                B = fadd(B, fmul(cf, fmul(fint(2), fmul(v0[i], v1[i]))))
                C = fadd(C, fmul(cf, fmul(v1[i], v1[i])))
            else:
                A = fadd(A, fmul(cf, fmul(v0[i], v0[j])))
                B = fadd(
                    B,
                    fmul(
                        cf,
                        fadd(fmul(v0[i], v1[j]), fmul(v1[i], v0[j])),
                    ),
                )
                C = fadd(C, fmul(cf, fmul(v1[i], v1[j])))
        return A, B, C

    pbs = [pullback_binary(q) for q in Qm]
    # Reference nonzero binary form
    ref = None
    for pb in pbs:
        if not all(fisz(x) for x in pb):
            ref = pb
            break
    REQUIRE("minus_nonzero_pullback", ref is not None, "all pullbacks zero")
    assert ref is not None
    fA, fB, fC = ref

    # Every pullback is a constant multiple of ref
    lambdas: List[KElem] = []
    for i, pb in enumerate(pbs):
        if all(fisz(x) for x in pb):
            lambdas.append(ZERO)
            continue
        # find scale
        scale = None
        for j in range(3):
            if not fisz(ref[j]):
                scale = fmul(pb[j], finv(ref[j]))
                break
        REQUIRE(f"minus_pb_scale_{i}", scale is not None, "")
        assert scale is not None
        for j in range(3):
            REQUIRE(
                f"minus_pb_mult_{i}_{j}",
                fisz(fsub(pb[j], fmul(scale, ref[j]))),
                "pullback not multiple of f",
            )
        lambdas.append(scale)

    # disc(f) = B^2 - 4AC
    disc = fsub(fmul(fB, fB), fmul(fint(4), fmul(fA, fC)))
    REQUIRE("minus_disc_nonzero", not fisz(disc), fstr(disc))

    # Extend f to a quadric Q on P3 vanishing on the linears' common zero only via f:
    # In ambient coords: Q(y) is the unique quadric of the form
    #   alpha * L1^2 + beta * L1*L2 + gamma * L2^2  is pure linears;
    # instead take the pullback extension constant on free coords:
    # Q = fA * y2^2 + fB * y2*y3 + fC * y3^2   works because on P1, y2=s, y3=t
    # and L1,L2 kill the residual y0,y1 directions? On P1 y2=s,y3=t so yes.
    # But is Q in the ideal of the two points? Yes: on V(L1,L2) we have y= s v0+t v1
    # and Q(y)=f(s,t). Combined with L1,L2, V(L1,L2,Q) = two points.

    Q_ext: QuadCoeffs = {}
    if not fisz(fA):
        Q_ext[(2, 2)] = fA
    if not fisz(fB):
        Q_ext[(2, 3)] = fB
    if not fisz(fC):
        Q_ext[(3, 3)] = fC

    # ------------------------------------------------------------------
    # Forward direction: each Plucker q lies in J = (L1, L2, Q_ext)
    # in degree 2: q = ell1*L1 + ell2*L2 + const*Q_ext.
    # This alone only proves V(J) subset V(I); reverse is required for equality.
    # ------------------------------------------------------------------
    mons4 = monoms(4)
    membership_witnesses = []
    for qi, q in enumerate(Qm):
        # unknowns: ell1_0..3, ell2_0..3, const  -> 9
        cols: List[List[KElem]] = []
        for e in range(4):
            ell = [ZERO] * 4
            ell[e] = ONE
            prod = linear_form_times_linear(ell, L1_coeffs)
            cols.append([prod.get(m, ZERO) for m in mons4])
        for e in range(4):
            ell = [ZERO] * 4
            ell[e] = ONE
            prod = linear_form_times_linear(ell, L2_coeffs)
            cols.append([prod.get(m, ZERO) for m in mons4])
        cols.append([Q_ext.get(m, ZERO) for m in mons4])
        A = mat_from_rows([[cols[j][i] for j in range(9)] for i in range(10)])
        b = [q.get(m, ZERO) for m in mons4]
        sol = solve_linear_system(A, b)
        if sol is None:
            membership_witnesses.append(
                {
                    "quadric_index": qi,
                    "in_linear_quad_ideal": False,
                    "note": "constant-span membership failed; pullback multiple of f verified",
                    "pullback_lambda": fser(lambdas[qi]),
                }
            )
        else:
            ell1 = sol[0:4]
            ell2 = sol[4:8]
            const = sol[8]
            prod = quad_add(
                linear_form_times_linear(ell1, L1_coeffs),
                linear_form_times_linear(ell2, L2_coeffs),
            )
            prod = quad_add(prod, quad_scale(const, Q_ext))
            diff = quad_sub(q, prod)
            REQUIRE(
                f"minus_membership_Q{qi}",
                len(diff) == 0,
                f"residual keys {list(diff.keys())}",
            )
            membership_witnesses.append(
                {
                    "quadric_index": qi,
                    "in_linear_quad_ideal": True,
                    "ell1": [fser(x) for x in ell1],
                    "ell2": [fser(x) for x in ell2],
                    "const_Q": fser(const),
                    "pullback_lambda": fser(lambdas[qi]),
                }
            )

    n_mem = sum(1 for w in membership_witnesses if w["in_linear_quad_ideal"])
    forward_ok = n_mem == 15
    if forward_ok:
        REQUIRE(
            "minus_membership_count",
            True,
            f"{n_mem}/15 Pluckers in (L1,L2,Q)",
        )
    else:
        # Do not claim completeness; keep export usable as partial.
        VALIDATIONS.append(
            (
                "minus_membership_count",
                False,
                f"only {n_mem}/15 Pluckers in (L1,L2,Q); forward incomplete",
            )
        )

    # ------------------------------------------------------------------
    # Reverse direction (critical for V(I) subset V(J)):
    # For i in {1,2}, j in {0,1,2,3}:
    #   y_j * L_i  =  sum_{q=0..14} c_{i,j,q} * Qminus_q
    # as quadratic forms, with constant coefficients c in K.
    # Independent M2 replay: exponent 1 suffices (no higher power of y_j).
    # At any common zero of all Qminus with some y_j != 0, both L_i vanish.
    # ------------------------------------------------------------------
    linears_by_i = {1: L1_coeffs, 2: L2_coeffs}
    # Columns of the 10x15 matrix of Plucker coeff vectors.
    plucker_cols: List[List[KElem]] = [
        [q.get(m, ZERO) for m in mons4] for q in Qm
    ]
    A_pl = mat_from_rows(
        [[plucker_cols[j][i] for j in range(15)] for i in range(10)]
    )

    reverse_identities: List[Dict[str, Any]] = []
    reverse_all_ok = True
    for i_lin in (1, 2):
        L = linears_by_i[i_lin]
        for j_coord in range(4):
            e_j = [ZERO] * 4
            e_j[j_coord] = ONE
            lhs = linear_form_times_linear(e_j, L)
            bvec = [lhs.get(m, ZERO) for m in mons4]
            sol = solve_linear_system(A_pl, bvec)
            entry: Dict[str, Any] = {
                "linear_index": i_lin,
                "coord_index": j_coord,
                "identity": f"y_{j_coord} * L_{i_lin} = sum_q c_q * Qminus_q",
                "exponent": 1,
            }
            if sol is None:
                reverse_all_ok = False
                entry["solved"] = False
                entry["verified"] = False
                entry["note"] = "no constant-coefficient solution over K"
                reverse_identities.append(entry)
                continue
            # Exact recheck: reconstruct sum c_q Q_q and match lhs.
            recon: QuadCoeffs = {}
            for q_idx, cq in enumerate(sol):
                if fisz(cq):
                    continue
                recon = quad_add(recon, quad_scale(cq, Qm[q_idx]))
            ok = quad_eq(lhs, recon)
            if not ok:
                reverse_all_ok = False
            nnz = sum(1 for cq in sol if not fisz(cq))
            entry["solved"] = True
            entry["verified"] = bool(ok)
            entry["nnz_coefficients"] = nnz
            entry["coefficients_c_q"] = [fser(cq) for cq in sol]
            reverse_identities.append(entry)
            REQUIRE(
                f"minus_reverse_y{j_coord}_L{i_lin}",
                ok,
                "reconstructed sum c_q Q_q does not match y_j L_i",
            )

    n_rev = sum(1 for e in reverse_identities if e.get("verified"))
    if reverse_all_ok:
        REQUIRE("minus_reverse_count", n_rev == 8, f"only {n_rev}/8")
    else:
        VALIDATIONS.append(
            (
                "minus_reverse_count",
                False,
                f"only {n_rev}/8 reverse identities verified; mark partial",
            )
        )

    # Reference lambda = 1 by construction (first nonzero pullback is the form).
    ref_index = next(
        (i for i, pb in enumerate(pbs) if not all(fisz(x) for x in pb)),
        None,
    )
    REQUIRE("minus_ref_index", ref_index is not None, "")
    assert ref_index is not None
    REQUIRE(
        "minus_ref_lambda_one",
        fisz(fsub(lambdas[ref_index], ONE)),
        fstr(lambdas[ref_index]),
    )

    complete = bool(forward_ok and reverse_all_ok and not fisz(disc))
    status = "complete" if complete else "partial"

    scope = {
        "I": "ideal generated by the 15 restricted normalized Plucker quadrics on P^3_minus",
        "J": "ideal (L1, L2, Q) with Q|P1 = f = A s^2 + B s t + C t^2",
        "forward_direction": (
            "each q_i lies in J in degree 2 (ell1*L1 + ell2*L2 + const*Q); "
            "proves V(J) subset V(I) only"
        ),
        "reverse_direction": (
            "eight identities y_j * L_i = sum_q c_{i,j,q} * Qminus_q with constant "
            "c in Q(zeta_11) and exponent 1; at every nonzero projective common zero "
            "of the q_i some y_j != 0, hence both L_i vanish, so V(I) subset V(L1,L2) "
            "in P^3"
        ),
        "on_P1": (
            "parametrization y = s v0 + t v1 of V(L1,L2); every pullback is "
            "lambda_i * f with reference lambda = 1; disc(f) != 0 => f squarefree"
        ),
        "certified_when_complete": (
            "reduced projective zero locus of I equals the reduced binary-quadratic "
            "divisor V(L1, L2, f) on that P1 (two distinct K-bar points)"
        ),
        "not_claimed": (
            "plus-component Veronese/plane-cubic normal form; any M2 dim/deg boolean "
            "without an exported exact witness"
        ),
        "status": status,
        "forward_ok": forward_ok,
        "reverse_ok": reverse_all_ok,
    }

    return {
        "status": status,
        "ambient_dim": 4,
        "linears": {
            "L1_coeffs_y0y1y2y3": [fser(x) for x in L1_coeffs],
            "L2_coeffs_y0y1y2y3": [fser(x) for x in L2_coeffs],
            "description": "L1=y1+a*y2+b*y3, L2=y0+c*y2+d*y3 cut a P1",
        },
        "P1_parametrization": {
            "y": "s*v0 + t*v1",
            "v0": [fser(x) for x in v0],
            "v1": [fser(x) for x in v1],
        },
        "binary_quadratic_f": {
            "form": "A*s^2 + B*s*t + C*t^2",
            "A": fser(fA),
            "B": fser(fB),
            "C": fser(fC),
            "disc_B2_minus_4AC": fser(disc),
            "disc_nonzero": True,
            "reference_quadric_index": ref_index,
            "reference_pullback_lambda": fser(ONE),
        },
        "extended_quadric_Q_on_P3": ser_quad(Q_ext),
        "ideal_description": "(L1, L2, Q) with Q|P1 = f, disc(f)!=0",
        "plucker_membership_witnesses": membership_witnesses,
        "pullback_all_multiples_of_f": True,
        "pullback_lambdas": [fser(x) for x in lambdas],
        "reverse_direction_identities": {
            "description": (
                "y_j * L_i = sum_q c_i_j_q * Qminus_q as quadratic forms over "
                "Q(zeta_11); constant coefficients; exponent 1"
            ),
            "exponent": 1,
            "count_expected": 8,
            "count_verified": n_rev,
            "identities": reverse_identities,
            "checks": {
                "all_eight_exact": reverse_all_ok,
                "forces_linears_at_nonzero_projective_common_zeros": reverse_all_ok,
            },
        },
        "scheme_equality_scope": scope,
        "checks": {
            "disc_nonzero": True,
            "linears_vanish_on_P1": True,
            "all_pluckers_in_ideal_L1_L2_Q": forward_ok,
            "all_pluckers_pullback_multiples_of_f": True,
            "reference_lambda_one": True,
            "reverse_eight_identities": reverse_all_ok,
            "minus_normal_form_complete": complete,
        },
    }


# ---------------------------------------------------------------------------
# Plus: record span; attempt Veronese (may remain open)
# ---------------------------------------------------------------------------


def plus_attempt(Bp: Mat, Qp: List[QuadCoeffs]) -> Dict[str, Any]:
    """
    Record exact 9-dimensional span of restricted Pluckers on the plus piece.
    Attempt a 2-Veronese / plane-cubic normal form; if not found, report the
    remaining search problem without fabricating.
    """
    d = 6
    REQUIRE("plus_dim6", len(Bp[0]) == 6, str(len(Bp[0])))
    rows = [quad_to_row(q, d) for q in Qp]
    basis_rows, piv = echelon_span(rows)
    REQUIRE("plus_quad_span_dim9", len(basis_rows) == 9, f"dim={len(basis_rows)}")

    # Standard Veronese relations on w = (w0..w5) ~ (X^2,XY,XZ,Y^2,YZ,Z^2):
    # w0 w3 - w1^2, w0 w4 - w1 w2, w0 w5 - w2^2,
    # w1 w4 - w2 w3, w1 w5 - w2 w4, w3 w5 - w4^2
    veronese_pairs = [
        ((0, 3), (1, 1), +1),  # w0 w3 - w1^2 encoded separately
    ]
    # We search for A in GL6 such that the 6 Veronese quads in coords w=A x
    # lie in the 9-span. This is a system of quadratic equations on A.
    # A full exact solution over K or an explicit finite extension was not
    # obtained in this export run; we do not fabricate A or F.

    remaining = {
        "problem": (
            "Find A in GL_6(L) for L/K finite (preferably L=K) such that, with "
            "w = A x, the six standard Veronese quadrics "
            "w0*w3-w1^2, w0*w4-w1*w2, w0*w5-w2^2, w1*w4-w2*w3, w1*w5-w2*w4, "
            "w3*w5-w4^2 lie in the 9-dimensional span of the restricted "
            "normalized Plucker quadrics, the residual 3-dimensional quotient "
            "matches X*F,Y*F,Z*F for a cubic F in X,Y,Z, and disc(F)!=0 "
            "(or a Jacobian smoothness certificate for F). Then produce constant "
            "matrices U,V proving span equality between the 9 normal-form "
            "quadrics and the 15 transformed restricted Pluckers."
        ),
        "known": {
            "plus_ambient_dim": 6,
            "restricted_plucker_span_dim": 9,
            "expected_geometry": (
                "smooth irreducible genus-1 sextic = 2-Veronese of a plane cubic "
                "(supported by independent Macaulay2 evidence over finite fields: "
                "dim=1, deg=6, hp=6i, Jacobian smooth — not used as a Lean witness)"
            ),
            "obstruction_note": (
                "Catalecticant presentation may require a finite extension of K "
                "if O(1) is not twice a K-rational degree-3 line bundle on the curve. "
                "Do not infer connectedness from Hilbert polynomials alone."
            ),
        },
        "search_space": (
            "36 coefficients of A (or of a 3x3 symmetric matrix of linear forms), "
            "quadratic membership conditions into a 9-plane in the 21-dimensional "
            "space of quadrics; residual cubic F with 10 coefficients up to scale."
        ),
    }

    return {
        "status": "partial",
        "ambient_dim": 6,
        "restricted_plucker_span_dim": 9,
        "echelon_basis_of_span": [ser_quad(row_to_quad(r, d)) for r in basis_rows],
        "pivot_monomials": [list(monoms(d)[p]) for p in piv],
        "veronese_plane_cubic_certificate": None,
        "remaining_search_problem": remaining,
        "checks": {
            "quad_span_dim9": True,
            "veronese_form_found": False,
            "fabricated": False,
        },
    }


# ---------------------------------------------------------------------------
# Hashing / serialization helpers
# ---------------------------------------------------------------------------


def sha256_file(path: str) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def canonical_json_bytes(obj: Any) -> bytes:
    return json.dumps(obj, sort_keys=True, separators=(",", ":"), ensure_ascii=True).encode(
        "utf-8"
    )


def payload_hash(obj: Any) -> str:
    return hashlib.sha256(canonical_json_bytes(obj)).hexdigest()


def atomic_write_bytes(path: str, data: bytes) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    fd, tmp = tempfile.mkstemp(
        dir=os.path.dirname(path), prefix=".sigma_nf_", suffix=".tmp"
    )
    try:
        with os.fdopen(fd, "wb") as f:
            f.write(data)
            f.flush()
            os.fsync(f.fileno())
        os.replace(tmp, path)
    except Exception:
        try:
            os.unlink(tmp)
        except OSError:
            pass
        raise


# ---------------------------------------------------------------------------
# Main computation
# ---------------------------------------------------------------------------


def compute_payload(d12: Dict[str, Any], d12_path: str) -> Dict[str, Any]:
    global VALIDATIONS
    VALIDATIONS = []
    REQUIRE("d12_schema", d12.get("schema") == "v14.fix_ix.d12_lean.v1", str(d12.get("schema")))
    REQUIRE("d12_has_P", "P15x15" in d12["operators"], "")
    REQUIRE("d12_has_R", "R15x15" in d12["operators"], "")

    P = mat_deser(d12["operators"]["P15x15"])
    R = mat_deser(d12["operators"]["R15x15"])
    REQUIRE("P_shape", mat_shape(P) == (15, 15), str(mat_shape(P)))
    REQUIRE("R_shape", mat_shape(R) == (15, 15), str(mat_shape(R)))
    REQUIRE("P_idempotent", mat_eq(mmul(P, P), P), "P^2=P")

    # S := R^3  (actual sigma on Lambda^2)
    S = mmul(mmul(R, R), R)
    REQUIRE("S2_I", mat_eq(mmul(S, S), meye(15)), "S^2 = I on Lambda^2")
    # R^6 = I
    R6 = meye(15)
    for _ in range(6):
        R6 = mmul(R6, R)
    REQUIRE("R6_I", mat_eq(R6, meye(15)), "R^6=I")
    REQUIRE("SP_eq_PS", mat_eq(mmul(S, P), mmul(P, S)), "S commutes with P")

    half = finv(fint(2))
    SP = mmul(S, P)
    Pplus = mscale(half, madd(P, SP))  # (P + S P)/2
    Pminus = mscale(half, msub(P, SP))  # (P - S P)/2
    REQUIRE("Pplus_idem", mat_eq(mmul(Pplus, Pplus), Pplus), "")
    REQUIRE("Pminus_idem", mat_eq(mmul(Pminus, Pminus), Pminus), "")
    REQUIRE("Pplus_Pminus_sum_P", mat_eq(madd(Pplus, Pminus), P), "")
    REQUIRE("Pplus_Pminus_prod0", mat_eq(mmul(Pplus, Pminus), mzeros(15, 15)), "")

    Bplus = column_basis_of_image(Pplus)
    Bminus = column_basis_of_image(Pminus)
    REQUIRE("Bplus_cols6", len(Bplus[0]) == 6, str(len(Bplus[0])))
    REQUIRE("Bminus_cols4", len(Bminus[0]) == 4, str(len(Bminus[0])))

    Lplus = left_inverse_via_projector(Bplus, Pplus)
    Lminus = left_inverse_via_projector(Bminus, Pminus)

    # Core identities
    REQUIRE("P_Bplus_Bplus", mat_eq(mmul(P, Bplus), Bplus), "")
    REQUIRE("S_Bplus_Bplus", mat_eq(mmul(S, Bplus), Bplus), "")
    REQUIRE("Lplus_Bplus_I", mat_eq(mmul(Lplus, Bplus), meye(6)), "")
    REQUIRE("Bplus_Lplus_Pplus", mat_eq(mmul(Bplus, Lplus), Pplus), "")

    REQUIRE("P_Bminus_Bminus", mat_eq(mmul(P, Bminus), Bminus), "")
    REQUIRE(
        "S_Bminus_minusBminus",
        mat_eq(mmul(S, Bminus), mneg(Bminus)),
        "",
    )
    REQUIRE("Lminus_Bminus_I", mat_eq(mmul(Lminus, Bminus), meye(4)), "")
    REQUIRE("Bminus_Lminus_Pminus", mat_eq(mmul(Bminus, Lminus), Pminus), "")

    # Restricted NORMALIZED Plucker
    Qplus = restrict_normalized_plucker(Bplus)
    Qminus = restrict_normalized_plucker(Bminus)
    # Coefficient-complete: all monoms (21 for d=6, 10 for d=4), no sampling cap.
    verify_normalized_vs_direct(Bplus, Qplus, tag="plus")
    verify_normalized_vs_direct(Bminus, Qminus, tag="minus")

    # Span ranks
    plus_rows = [quad_to_row(q, 6) for q in Qplus]
    minus_rows = [quad_to_row(q, 4) for q in Qminus]
    plus_basis, _ = echelon_span(plus_rows)
    minus_basis, _ = echelon_span(minus_rows)
    REQUIRE("plus_span9", len(plus_basis) == 9, str(len(plus_basis)))
    REQUIRE("minus_span_pos", len(minus_basis) >= 1, str(len(minus_basis)))

    # wedge = 2 * normalized: exhaustive on BOTH pieces before any global flag.
    verify_wedge_equals_twice_normalized(Bplus, Qplus, tag="plus")
    verify_wedge_equals_twice_normalized(Bminus, Qminus, tag="minus")
    wedge_plus_ok = True
    wedge_minus_ok = True
    # Global flag only after both per-piece exhaustive checks passed (REQUIRE above).
    wedge_both_ok = wedge_plus_ok and wedge_minus_ok
    REQUIRE("wedge_equals_twice_normalized_both", wedge_both_ok, "")

    minus_cert = minus_normal_form(Bminus, Qminus)
    plus_cert = plus_attempt(Bplus, Qplus)

    # File hash of the actual input bytes used for this export.
    input_sha = sha256_file(d12_path)

    body = {
        "schema": SCHEMA,
        "version": 1,
        "field": {
            "name": "Q(zeta_11)",
            "modulus": "Phi11=1+z+...+z^10",
            "basis": ["1", "z", "z^2", "z^3", "z^4", "z^5", "z^6", "z^7", "z^8", "z^9"],
            "serialization": "ten [numerator,denominator] pairs, positive denominators",
        },
        "conventions": {
            "ambient_plucker_order": [list(p) for p in PAIRS],
            "matrices_act_on": "column_vectors",
            "S_definition": "S := R^3 with R = operators.R15x15 from d12_lean_K.json",
            "normalized_plucker": "p_ab*p_cd - p_ac*p_bd + p_ad*p_bc",
            "not_used": "old seal.py next(...) involution; w-wedge-w (twice normalized)",
        },
        "inputs": {
            "d12_path": "results/d12_lean_K.json",
            "d12_schema": d12.get("schema"),
            "d12_sha256_file": input_sha,
            "d12_embedded_sha256": d12.get("sha256"),
        },
        "operators": {
            "P15x15": mat_ser(P),
            "R15x15": mat_ser(R),
            "S15x15": mat_ser(S),
            "Pplus15x15": mat_ser(Pplus),
            "Pminus15x15": mat_ser(Pminus),
        },
        "eigenspaces": {
            "Bplus_15x6": mat_ser(Bplus),
            "Lplus_6x15": mat_ser(Lplus),
            "Bminus_15x4": mat_ser(Bminus),
            "Lminus_4x15": mat_ser(Lminus),
            "checks": {
                "P_Bplus_eq_Bplus": True,
                "S_Bplus_eq_Bplus": True,
                "Lplus_Bplus_eq_I6": True,
                "Bplus_Lplus_eq_Pplus": True,
                "P_Bminus_eq_Bminus": True,
                "S_Bminus_eq_minus_Bminus": True,
                "Lminus_Bminus_eq_I4": True,
                "Bminus_Lminus_eq_Pminus": True,
            },
        },
        "restricted_plucker": {
            "convention": "normalized",
            "plus_15_quadrics": [ser_quad(q) for q in Qplus],
            "minus_15_quadrics": [ser_quad(q) for q in Qminus],
            "plus_span_dim": 9,
            "minus_span_dim": len(minus_basis),
            "checks": {
                "direct_eval_matches_restricted_plus": True,
                "direct_eval_matches_restricted_minus": True,
                "direct_eval_coefficient_complete": True,
                "direct_eval_monoms_checked": {
                    "plus_d6": 21,
                    "minus_d4": 10,
                },
                "wedge_equals_twice_normalized_plus": wedge_plus_ok,
                "wedge_equals_twice_normalized_minus": wedge_minus_ok,
                "wedge_equals_twice_normalized": wedge_both_ok,
                "plus_span_dim9": True,
            },
        },
        "plus_component": plus_cert,
        "minus_component": minus_cert,
        "validations": [
            {"name": n, "ok": ok, "detail": d} for (n, ok, d) in VALIDATIONS
        ],
        "summary": {
            "S_is_R3": True,
            "eigenspace_dims": {"plus": 6, "minus": 4},
            "plus_veronese_complete": False,
            "minus_normal_form_complete": minus_cert.get("status") == "complete",
            "minus_forward_membership_ok": bool(
                minus_cert.get("checks", {}).get("all_pluckers_in_ideal_L1_L2_Q")
            ),
            "minus_reverse_identities_ok": bool(
                minus_cert.get("checks", {}).get("reverse_eight_identities")
            ),
            "minus_reverse_identity_count": int(
                minus_cert.get("reverse_direction_identities", {}).get(
                    "count_verified", 0
                )
            ),
            "all_require_passed": all(ok for (_, ok, _) in VALIDATIONS),
            "scope_note": (
                "minus complete only if forward (q_i in J) AND reverse "
                "(eight y_j L_i in I) AND disc(f)!=0; plus remains partial"
            ),
        },
    }

    # Payload hash excludes the hash field itself
    body["payload_sha256"] = payload_hash(body)
    return body


def verify_payload(payload: Dict[str, Any], d12_path: str) -> None:
    """
    Independent fail-closed replay from written JSON + d12 input.
    Recomputes input hashes, P/R/S, projectors, ranks, wedge factor two,
    pullback lambdas, forward membership, and the eight reverse identities.
    Rejects tampering (hash mismatch, completeness claim without reverse certs).
    """
    global VALIDATIONS
    VALIDATIONS = []

    REQUIRE("verify_schema", payload.get("schema") == SCHEMA, str(payload.get("schema")))
    REQUIRE("verify_d12_exists", os.path.isfile(d12_path), d12_path)

    with open(d12_path, "r", encoding="utf-8") as f:
        d12 = json.load(f)

    # --- input hashes (reject wrong/tampered d12 or stale pointer) ---
    file_sha = sha256_file(d12_path)
    REQUIRE(
        "verify_d12_file_hash",
        file_sha == payload["inputs"]["d12_sha256_file"],
        f"{file_sha} vs {payload['inputs']['d12_sha256_file']}",
    )
    if d12.get("sha256") is not None and payload["inputs"].get("d12_embedded_sha256"):
        REQUIRE(
            "verify_d12_embedded_hash",
            d12.get("sha256") == payload["inputs"]["d12_embedded_sha256"],
            "",
        )

    # --- recompute P, R from d12; match stored operators ---
    P = mat_deser(d12["operators"]["P15x15"])
    R = mat_deser(d12["operators"]["R15x15"])
    REQUIRE(
        "verify_P_match",
        mat_eq(P, mat_deser(payload["operators"]["P15x15"])),
        "stored P differs from d12 recomputation",
    )
    REQUIRE(
        "verify_R_match",
        mat_eq(R, mat_deser(payload["operators"]["R15x15"])),
        "stored R differs from d12 recomputation",
    )
    REQUIRE("verify_P_idempotent", mat_eq(mmul(P, P), P), "")

    S = mmul(mmul(R, R), R)
    REQUIRE("verify_S_matches", mat_eq(S, mat_deser(payload["operators"]["S15x15"])), "")
    REQUIRE("verify_S2_I", mat_eq(mmul(S, S), meye(15)), "")

    half = finv(fint(2))
    Pplus = mscale(half, madd(P, mmul(S, P)))
    Pminus = mscale(half, msub(P, mmul(S, P)))
    REQUIRE(
        "verify_Pplus",
        mat_eq(Pplus, mat_deser(payload["operators"]["Pplus15x15"])),
        "",
    )
    REQUIRE(
        "verify_Pminus",
        mat_eq(Pminus, mat_deser(payload["operators"]["Pminus15x15"])),
        "",
    )

    Bplus = mat_deser(payload["eigenspaces"]["Bplus_15x6"])
    Lplus = mat_deser(payload["eigenspaces"]["Lplus_6x15"])
    Bminus = mat_deser(payload["eigenspaces"]["Bminus_15x4"])
    Lminus = mat_deser(payload["eigenspaces"]["Lminus_4x15"])

    REQUIRE("verify_Bplus_cols", len(Bplus[0]) == 6, str(len(Bplus[0])))
    REQUIRE("verify_Bminus_cols", len(Bminus[0]) == 4, str(len(Bminus[0])))
    REQUIRE("verify_PB+", mat_eq(mmul(P, Bplus), Bplus), "")
    REQUIRE("verify_SB+", mat_eq(mmul(S, Bplus), Bplus), "")
    REQUIRE("verify_LB+", mat_eq(mmul(Lplus, Bplus), meye(6)), "")
    REQUIRE("verify_BL+", mat_eq(mmul(Bplus, Lplus), Pplus), "")
    REQUIRE("verify_PB-", mat_eq(mmul(P, Bminus), Bminus), "")
    REQUIRE("verify_SB-", mat_eq(mmul(S, Bminus), mneg(Bminus)), "")
    REQUIRE("verify_LB-", mat_eq(mmul(Lminus, Bminus), meye(4)), "")
    REQUIRE("verify_BL-", mat_eq(mmul(Bminus, Lminus), Pminus), "")

    Qplus = [deser_quad(q) for q in payload["restricted_plucker"]["plus_15_quadrics"]]
    Qminus = [deser_quad(q) for q in payload["restricted_plucker"]["minus_15_quadrics"]]
    REQUIRE("verify_Qplus_count", len(Qplus) == 15, str(len(Qplus)))
    REQUIRE("verify_Qminus_count", len(Qminus) == 15, str(len(Qminus)))
    # Coefficient-complete monom coverage (21 for d=6, 10 for d=4); no sampling cap.
    verify_normalized_vs_direct(Bplus, Qplus, tag="verify_plus")
    verify_normalized_vs_direct(Bminus, Qminus, tag="verify_minus")

    # ranks
    plus_basis, _ = echelon_span([quad_to_row(q, 6) for q in Qplus])
    minus_basis, _ = echelon_span([quad_to_row(q, 4) for q in Qminus])
    REQUIRE("verify_plus_span9", len(plus_basis) == 9, str(len(plus_basis)))
    REQUIRE(
        "verify_plus_span_field",
        payload["restricted_plucker"]["plus_span_dim"] == 9,
        "",
    )
    REQUIRE(
        "verify_minus_span_field",
        payload["restricted_plucker"]["minus_span_dim"] == len(minus_basis),
        f"stored {payload['restricted_plucker']['minus_span_dim']} vs {len(minus_basis)}",
    )
    REQUIRE("verify_minus_span_pos", len(minus_basis) >= 1, str(len(minus_basis)))

    # wedge = 2 * normalized: exhaustive on BOTH pieces before reading global flag.
    verify_wedge_equals_twice_normalized(Bplus, Qplus, tag="verify_plus")
    verify_wedge_equals_twice_normalized(Bminus, Qminus, tag="verify_minus")
    rp_checks = payload["restricted_plucker"].get("checks", {})
    REQUIRE(
        "verify_wedge_plus_flag",
        rp_checks.get("wedge_equals_twice_normalized_plus") is True,
        str(rp_checks.get("wedge_equals_twice_normalized_plus")),
    )
    REQUIRE(
        "verify_wedge_minus_flag",
        rp_checks.get("wedge_equals_twice_normalized_minus") is True,
        str(rp_checks.get("wedge_equals_twice_normalized_minus")),
    )
    REQUIRE(
        "verify_wedge_global_flag",
        rp_checks.get("wedge_equals_twice_normalized") is True,
        "global flag requires both pieces",
    )
    monoms_checked = rp_checks.get("direct_eval_monoms_checked", {})
    REQUIRE(
        "verify_monoms_plus_21",
        monoms_checked.get("plus_d6") == 21,
        str(monoms_checked),
    )
    REQUIRE(
        "verify_monoms_minus_10",
        monoms_checked.get("minus_d4") == 10,
        str(monoms_checked),
    )
    REQUIRE(
        "verify_coeff_complete_flag",
        rp_checks.get("direct_eval_coefficient_complete") is True,
        "",
    )

    # --- minus component ---
    mc = payload["minus_component"]
    claimed_complete = mc.get("status") == "complete"
    summary_complete = bool(payload.get("summary", {}).get("minus_normal_form_complete"))
    REQUIRE(
        "verify_summary_matches_minus_status",
        summary_complete == claimed_complete,
        f"summary={summary_complete} status={mc.get('status')}",
    )

    fA = fdeser(mc["binary_quadratic_f"]["A"])
    fB = fdeser(mc["binary_quadratic_f"]["B"])
    fC = fdeser(mc["binary_quadratic_f"]["C"])
    disc = fsub(fmul(fB, fB), fmul(fint(4), fmul(fA, fC)))
    REQUIRE("verify_disc", not fisz(disc), fstr(disc))
    REQUIRE(
        "verify_disc_match",
        fisz(fsub(disc, fdeser(mc["binary_quadratic_f"]["disc_B2_minus_4AC"]))),
        "",
    )

    v0 = tuple(fdeser(x) for x in mc["P1_parametrization"]["v0"])
    v1 = tuple(fdeser(x) for x in mc["P1_parametrization"]["v1"])
    L1 = tuple(fdeser(x) for x in mc["linears"]["L1_coeffs_y0y1y2y3"])
    L2 = tuple(fdeser(x) for x in mc["linears"]["L2_coeffs_y0y1y2y3"])
    for s_val, t_val in ((ONE, ZERO), (ZERO, ONE), (ONE, ONE), (fint(2), ONE)):
        y = tuple(fadd(fmul(s_val, v0[i]), fmul(t_val, v1[i])) for i in range(4))
        for L, name in ((L1, "L1"), (L2, "L2")):
            val = ZERO
            for i in range(4):
                val = fadd(val, fmul(L[i], y[i]))
            REQUIRE(f"verify_L_on_P1_{name}", fisz(val), "")

    # Pullback lambdas recomputed and matched
    def pullback_binary(q: QuadCoeffs) -> Tuple[KElem, KElem, KElem]:
        A = ZERO
        B = ZERO
        C = ZERO
        for (i, j), cf in q.items():
            if i == j:
                A = fadd(A, fmul(cf, fmul(v0[i], v0[i])))
                B = fadd(B, fmul(cf, fmul(fint(2), fmul(v0[i], v1[i]))))
                C = fadd(C, fmul(cf, fmul(v1[i], v1[i])))
            else:
                A = fadd(A, fmul(cf, fmul(v0[i], v0[j])))
                B = fadd(
                    B,
                    fmul(cf, fadd(fmul(v0[i], v1[j]), fmul(v1[i], v0[j]))),
                )
                C = fadd(C, fmul(cf, fmul(v1[i], v1[j])))
        return A, B, C

    pbs = [pullback_binary(q) for q in Qminus]
    ref_idx = int(mc["binary_quadratic_f"]["reference_quadric_index"])
    REQUIRE("verify_ref_idx_range", 0 <= ref_idx < 15, str(ref_idx))
    ref_pb = pbs[ref_idx]
    REQUIRE(
        "verify_ref_nonzero",
        not all(fisz(x) for x in ref_pb),
        "reference pullback zero",
    )
    REQUIRE(
        "verify_ref_matches_f",
        fisz(fsub(ref_pb[0], fA))
        and fisz(fsub(ref_pb[1], fB))
        and fisz(fsub(ref_pb[2], fC)),
        "reference pullback != stored f",
    )
    REQUIRE(
        "verify_ref_lambda_one_field",
        fisz(fsub(fdeser(mc["binary_quadratic_f"]["reference_pullback_lambda"]), ONE)),
        "",
    )

    stored_lambdas = [fdeser(x) for x in mc["pullback_lambdas"]]
    REQUIRE("verify_lambda_count", len(stored_lambdas) == 15, str(len(stored_lambdas)))
    for i, pb in enumerate(pbs):
        if all(fisz(x) for x in pb):
            REQUIRE(f"verify_lambda_zero_{i}", fisz(stored_lambdas[i]), "")
            continue
        # pb should equal lambda * (fA,fB,fC)
        scale = stored_lambdas[i]
        for j, (p, fcomp) in enumerate(zip(pb, (fA, fB, fC))):
            REQUIRE(
                f"verify_pullback_lambda_{i}_{j}",
                fisz(fsub(p, fmul(scale, fcomp))),
                "",
            )
    REQUIRE(
        "verify_ref_lambda_is_one",
        fisz(fsub(stored_lambdas[ref_idx], ONE)),
        fstr(stored_lambdas[ref_idx]),
    )

    # Forward membership witnesses re-check
    Q_ext = deser_quad(mc["extended_quadric_Q_on_P3"])
    n_mem_ok = 0
    for w in mc["plucker_membership_witnesses"]:
        qi = w["quadric_index"]
        if not w.get("in_linear_quad_ideal"):
            continue
        ell1 = tuple(fdeser(x) for x in w["ell1"])
        ell2 = tuple(fdeser(x) for x in w["ell2"])
        const = fdeser(w["const_Q"])
        prod = quad_add(
            linear_form_times_linear(ell1, L1),
            linear_form_times_linear(ell2, L2),
        )
        prod = quad_add(prod, quad_scale(const, Q_ext))
        REQUIRE(
            f"verify_mem_Q{qi}",
            quad_eq(Qminus[qi], prod),
            "forward membership residual",
        )
        n_mem_ok += 1
    REQUIRE("verify_mem_count", n_mem_ok == 15, f"only {n_mem_ok}/15")

    # Reverse identities: always present as a block; every *claimed* verified
    # identity is rechecked exactly. Completeness requires all eight.
    rev = mc.get("reverse_direction_identities")
    REQUIRE("verify_reverse_block_present", rev is not None, "missing reverse block")
    assert rev is not None
    REQUIRE("verify_reverse_exponent", rev.get("exponent") == 1, str(rev.get("exponent")))
    identities = rev.get("identities", [])
    REQUIRE(
        "verify_reverse_identity_slots",
        len(identities) == 8,
        str(len(identities)),
    )

    n_rev_ok = 0
    seen_pairs = set()
    for entry in identities:
        i_lin = int(entry["linear_index"])
        j_coord = int(entry["coord_index"])
        seen_pairs.add((i_lin, j_coord))
        REQUIRE(f"verify_rev_lin_idx_{i_lin}", i_lin in (1, 2), str(i_lin))
        REQUIRE(
            f"verify_rev_coord_{j_coord}",
            0 <= j_coord <= 3,
            str(j_coord),
        )
        if not (entry.get("solved") and entry.get("verified")):
            # Allowed only when status is partial (no completeness claim).
            REQUIRE(
                f"verify_rev_unsolved_only_if_partial_{i_lin}_{j_coord}",
                not claimed_complete,
                "complete claim but reverse identity missing/unverified",
            )
            continue
        L = L1 if i_lin == 1 else L2
        e_j = [ZERO] * 4
        e_j[j_coord] = ONE
        lhs = linear_form_times_linear(e_j, L)
        coeffs = [fdeser(c) for c in entry["coefficients_c_q"]]
        REQUIRE(f"verify_rev_coeff_len_{i_lin}_{j_coord}", len(coeffs) == 15, "")
        recon = {}
        for q_idx, cq in enumerate(coeffs):
            if fisz(cq):
                continue
            recon = quad_add(recon, quad_scale(cq, Qminus[q_idx]))
        REQUIRE(
            f"verify_rev_id_{i_lin}_{j_coord}",
            quad_eq(lhs, recon),
            "y_j L_i != sum c_q Q_q",
        )
        n_rev_ok += 1

    REQUIRE(
        "verify_reverse_all_pairs",
        seen_pairs == {(i, j) for i in (1, 2) for j in range(4)},
        str(sorted(seen_pairs)),
    )
    REQUIRE(
        "verify_reverse_count_field",
        int(rev.get("count_verified", -1)) == n_rev_ok,
        f"field {rev.get('count_verified')} vs recomputed {n_rev_ok}",
    )

    # Completeness claim is allowed only with both directions + disc
    if claimed_complete:
        REQUIRE("verify_complete_needs_forward", n_mem_ok == 15, "")
        REQUIRE("verify_complete_needs_reverse", n_rev_ok == 8, "")
        REQUIRE("verify_complete_needs_disc", not fisz(disc), "")
        REQUIRE(
            "verify_complete_check_flag",
            mc.get("checks", {}).get("minus_normal_form_complete") is True,
            "",
        )
        REQUIRE(
            "verify_complete_rev_flag",
            rev.get("checks", {}).get("all_eight_exact") is True,
            "",
        )
    else:
        # partial is honest; must not set the complete flag true
        REQUIRE(
            "verify_partial_not_flagged_complete",
            mc.get("checks", {}).get("minus_normal_form_complete") is not True,
            "",
        )
        REQUIRE(
            "verify_partial_summary",
            payload.get("summary", {}).get("minus_normal_form_complete") is not True,
            "",
        )

    # plus: ensure not fabricated
    REQUIRE(
        "verify_plus_not_fabricated",
        payload["plus_component"]["veronese_plane_cubic_certificate"] is None,
        "",
    )
    REQUIRE(
        "verify_plus_span9",
        payload["plus_component"]["restricted_plucker_span_dim"] == 9,
        "",
    )
    REQUIRE(
        "verify_plus_incomplete",
        payload["summary"]["plus_veronese_complete"] is False,
        "",
    )

    stored = payload.get("payload_sha256")
    recomputed = payload_hash(
        {k: v for k, v in payload.items() if k != "payload_sha256"}
    )
    REQUIRE("verify_payload_hash", stored == recomputed, f"{stored} vs {recomputed}")


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--verify",
        action="store_true",
        help="Replay algebraic checks on existing results/sigma_normal_form_K.json",
    )
    parser.add_argument(
        "--d12",
        default=D12_PATH,
        help="Path to d12_lean_K.json",
    )
    parser.add_argument(
        "--out",
        default=OUT_PATH,
        help="Output JSON path",
    )
    args = parser.parse_args(list(argv) if argv is not None else None)

    if args.verify:
        if not os.path.isfile(args.out):
            print(f"VERIFY FAIL: missing {args.out}", file=sys.stderr)
            return 1
        with open(args.out, "r", encoding="utf-8") as f:
            payload = json.load(f)
        try:
            verify_payload(payload, args.d12)
        except Exception as e:
            print(f"VERIFY FAIL: {e}", file=sys.stderr)
            return 1
        mc = payload["minus_component"]
        rev = mc.get("reverse_direction_identities", {})
        print("VERIFY OK: all replayed identities hold (fail-closed)")
        print(f"  schema={payload.get('schema')}")
        print(f"  payload_sha256={payload.get('payload_sha256')}")
        print(f"  d12_sha256_file={payload['inputs']['d12_sha256_file']}")
        print(f"  plus_complete={payload['summary']['plus_veronese_complete']}")
        print(f"  minus_complete={payload['summary']['minus_normal_form_complete']}")
        print(f"  minus_status={mc.get('status')}")
        print(
            f"  reverse_identities={rev.get('count_verified')}/{rev.get('count_expected')} "
            f"exponent={rev.get('exponent')}"
        )
        return 0

    if not os.path.isfile(args.d12):
        print(f"FAIL: missing input {args.d12}", file=sys.stderr)
        return 1

    os.makedirs(WORK_DIR, exist_ok=True)

    with open(args.d12, "r", encoding="utf-8") as f:
        d12 = json.load(f)

    # Two independent regenerations; must be byte-identical.
    try:
        payload1 = compute_payload(d12, args.d12)
        data1 = canonical_json_bytes(payload1) + b"\n"
        payload2 = compute_payload(d12, args.d12)
        data2 = canonical_json_bytes(payload2) + b"\n"
    except Exception as e:
        print(f"EXPORT FAIL (no output written): {e}", file=sys.stderr)
        return 1

    if data1 != data2:
        print(
            "EXPORT FAIL (no output written): two regenerations differ bytewise",
            file=sys.stderr,
        )
        return 1

    h1 = hashlib.sha256(data1).hexdigest()
    h2 = hashlib.sha256(data2).hexdigest()
    if h1 != h2:
        print("EXPORT FAIL: hash mismatch between regenerations", file=sys.stderr)
        return 1

    # Atomic write of the canonical bytes; also store both runs under work/.
    atomic_write_bytes(args.out, data1)
    atomic_write_bytes(os.path.join(WORK_DIR, "run1.json"), data1)
    atomic_write_bytes(os.path.join(WORK_DIR, "run2.json"), data2)
    atomic_write_bytes(
        os.path.join(WORK_DIR, "hash1.txt"), (h1 + "\n").encode("ascii")
    )
    atomic_write_bytes(
        os.path.join(WORK_DIR, "hash2.txt"), (h2 + "\n").encode("ascii")
    )

    # Post-write self-verify (fail-closed; rejects incomplete reverse claims)
    with open(args.out, "r", encoding="utf-8") as f:
        loaded = json.load(f)
    try:
        verify_payload(loaded, args.d12)
    except Exception as e:
        print(f"POST-WRITE VERIFY FAIL: {e}", file=sys.stderr)
        return 1

    # Round-trip: re-read file bytes must match regeneration
    with open(args.out, "rb") as f:
        on_disk = f.read()
    if on_disk != data1:
        print("POST-WRITE BYTE FAIL: on-disk differs from regeneration", file=sys.stderr)
        return 1

    mc = payload1["minus_component"]
    rev = mc.get("reverse_direction_identities", {})
    identities = rev.get("identities", [])
    nnz_list = [e.get("nnz_coefficients", 0) for e in identities if e.get("verified")]

    print("EXPORT OK")
    print(f"  wrote {args.out} ({len(data1)} bytes)")
    print(f"  payload_sha256={payload1['payload_sha256']}")
    print(f"  file_sha256={h1}")
    print(f"  byte_identical_regenerations=2")
    print(f"  d12_sha256_file={payload1['inputs']['d12_sha256_file']}")
    print(f"  Bplus 15x6, Bminus 15x4; S=R^3 verified")
    print(
        f"  plus span dim 9; veronese complete="
        f"{payload1['summary']['plus_veronese_complete']}"
    )
    print(
        f"  minus status={mc.get('status')} "
        f"complete={payload1['summary']['minus_normal_form_complete']}"
    )
    print(
        f"  reverse identities verified="
        f"{rev.get('count_verified')}/{rev.get('count_expected')} "
        f"exponent={rev.get('exponent')} nnz={nnz_list}"
    )
    print(
        f"  forward membership witnesses="
        f"{sum(1 for w in mc['plucker_membership_witnesses'] if w.get('in_linear_quad_ideal'))}/15"
    )
    print(f"  export_validations={len(payload1['validations'])} all passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
