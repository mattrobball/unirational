#!/usr/bin/env python3
"""Shared exact helpers for the (m,d)=(1,7) finite global lifting tower.

Independent of produce/verify. Exact Fraction arithmetic. Absolute-path safe.
Polar model matches certificates/lifting/families/common_tower.py.
"""

from __future__ import annotations

import hashlib
import json
import math
from collections import defaultdict
from fractions import Fraction as Q
from itertools import permutations
from pathlib import Path

HERE = Path(__file__).resolve().parent
GFL = HERE.parent
CERT = GFL.parent
ROOT = CERT.parent
M = 1
D = 7
TERMINAL_F_ORDER = 3 * D  # 21


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path | str) -> str:
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def canonical_json(obj) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def write_json(path: Path, obj: dict) -> str:
    obj = dict(obj)
    obj["self_sha256"] = None
    text = canonical_json(obj)
    h = sha256_bytes(text.encode())
    obj["self_sha256"] = h
    path.write_text(canonical_json(obj))
    return h


def q_to_str(x: Q) -> str:
    if x.denominator == 1:
        return str(x.numerator)
    return f"{x.numerator}/{x.denominator}"


def binom(n: int, k: int) -> int:
    if k < 0 or n < 0 or k > n:
        return 0
    return math.comb(n, k)


def monoms_bin(deg: int) -> list[tuple[int, int]]:
    return [(deg - k, k) for k in range(deg + 1)]


def monoms_tern(deg: int) -> list[tuple[int, int, int]]:
    out = []
    for a in range(deg, -1, -1):
        for b in range(deg - a, -1, -1):
            out.append((a, b, deg - a - b))
    return out


def dim_sym(n_vars: int, deg: int) -> int:
    if deg < 0:
        return 0
    return binom(deg + n_vars - 1, n_vars - 1)


# ---------------------------------------------------------------------------
# Polar model B (D12-weight abstract model; ranks transport)
# B(z;y,y)= z0*2 y0 y1 + z1*y1^2 + z2*y0^2
# ---------------------------------------------------------------------------

def B_coeff(z_index: int, j: int, k: int) -> Q:
    if z_index == 0:
        return Q(1) if (j, k) in ((0, 1), (1, 0)) else Q(0)
    if z_index == 1:
        return Q(1) if j == 1 and k == 1 else Q(0)
    if z_index == 2:
        return Q(1) if j == 0 and k == 0 else Q(0)
    raise IndexError(z_index)


def parity_target(r: int) -> str:
    return "E_plus" if r % 2 == 0 else "E_minus"


def free_rank_jet(order: int, target_dim: int) -> int:
    if order < 0:
        return 0
    return (order + 1) * target_dim


def multi_rees_dim(order: int, target_dim: int, d: int = D) -> int:
    """dim Sym^{d-order} E_+* ⊗ Sym^{order} E_-* ⊗ target."""
    if order < 0 or order > d:
        return 0
    return dim_sym(3, d - order) * free_rank_jet(order, target_dim)


def F_order_live_triples(m: int, N: int, r_max: int) -> list[dict]:
    """Unique sorted live triples i+j+k=N, m<=i,j,k<=r_max, not triple-E-."""
    seen: dict[tuple[int, int, int], dict] = {}
    for i in range(m, r_max + 1):
        for j in range(m, r_max + 1):
            for k in range(m, r_max + 1):
                if i + j + k != N:
                    continue
                types = tuple(parity_target(r) for r in (i, j, k))
                if types.count("E_minus") == 3:
                    continue
                key = tuple(sorted((i, j, k)))
                if key in seen:
                    continue
                mult = len(set(permutations(key)))
                seen[key] = {
                    "ijk_sorted": list(key),
                    "multiplicity": mult,
                    "types": [parity_target(r) for r in key],
                    "max_order": max(key),
                    "max_Eplus": max((r for r in key if r % 2 == 0), default=-1),
                    "max_Eminus": max((r for r in key if r % 2 == 1), default=-1),
                }
    return [seen[k] for k in sorted(seen)]


def stage_ledger(m: int = M, d: int = D) -> dict:
    """Complete nonautomatic F-order ledger through terminal order 3d."""
    terminal = 3 * d
    stages = []
    for N in range(0, terminal + 1):
        auto = N % 2 == 1  # y-evenness of F(p) under t-covariance
        if auto:
            stages.append(
                {
                    "F_order": N,
                    "automatic_by_y_evenness": True,
                    "live_triples": [],
                    "newest_Eplus_order": None,
                    "newest_Eminus_order": None,
                    "isolable_Eplus_within_d": None,
                    "equation_type": "automatic",
                }
            )
            continue
        triples = F_order_live_triples(m, N, r_max=d)
        max_ep = max((t["max_Eplus"] for t in triples), default=-1)
        max_em = max((t["max_Eminus"] for t in triples), default=-1)
        # Free-module isolation pattern: pure (m,m,m+r) with r=N-2m gives newest b
        delta = N - 3 * m
        formal_newest_ep = m + delta if delta >= 0 and (m + delta) % 2 == 0 else None
        isolable = (
            formal_newest_ep is not None
            and formal_newest_ep <= d
            and any(t["max_Eplus"] == formal_newest_ep for t in triples)
        )
        # Polynomial isolation: can we solve for a newest E+ jet of order <=d?
        poly_newest_ep = max_ep if max_ep <= d else None
        # Stage is "correction" if formal isolation wants E+ order in range and
        # that jet is still a free unknown introduced at this stage.
        eq_type = "empty"
        if triples:
            if isolable and formal_newest_ep is not None and formal_newest_ep <= d:
                eq_type = "isolate_Eplus"
            elif poly_newest_ep is not None and poly_newest_ep <= d:
                # may still involve free a_odd as linear corrections
                eq_type = "mixed_residual"
            else:
                eq_type = "terminal_residual"
        stages.append(
            {
                "F_order": N,
                "automatic_by_y_evenness": False,
                "live_triples": triples,
                "n_live_classes": len(triples),
                "formal_delta": delta,
                "formal_newest_Eplus_order": formal_newest_ep,
                "newest_Eplus_order": max_ep if max_ep >= 0 else None,
                "newest_Eminus_order": max_em if max_em >= 0 else None,
                "isolable_Eplus_within_d": isolable,
                "equation_type": eq_type,
                "codomain_free_dim": N + 1,  # scalar binary of order N
                "codomain_multi_rees_dim": dim_sym(3, 3 * d - N) * (N + 1)
                if N <= 3 * d
                else 0,
            }
        )
    return {
        "m": m,
        "d": d,
        "terminal_F_order": terminal,
        "stages": stages,
        "nonautomatic_orders": [s["F_order"] for s in stages if not s["automatic_by_y_evenness"] and s["live_triples"]],
    }


def jet_dimension_table(m: int = M, d: int = D) -> dict:
    rows = []
    total_free = 0
    total_rees = 0
    for k in range(m, d + 1):
        tdim = 3 if k % 2 == 0 else 2
        fr = free_rank_jet(k, tdim)
        rees = multi_rees_dim(k, tdim, d)
        total_free += fr
        total_rees += rees
        rows.append(
            {
                "normal_order": k,
                "target": "E_plus" if k % 2 == 0 else "E_minus",
                "target_dim": tdim,
                "free_fibre_rank": fr,
                "multi_rees_dim": rees,
                "base_degree_d_minus_k": d - k,
                "sym_Eplus_dim": dim_sym(3, d - k),
            }
        )
    return {
        "m": m,
        "d": d,
        "rows": rows,
        "total_free_fibre_rank": total_free,
        "total_multi_rees_dim": total_rees,
        "note": (
            "C2-parity normal jets of a single degree-d map along one involution "
            "plus-plane (not yet residual equalizer / G-invariants)."
        ),
    }


# ---------------------------------------------------------------------------
# Free polar operator L_r(b) = B(b; a, a) for odd r (E+ newest)
# ---------------------------------------------------------------------------

def leading_basis(m: int) -> list[tuple[tuple[int, int], int]]:
    return [(mon, j) for mon in monoms_bin(m) for j in (0, 1)]


def domain_basis_Eplus(order: int) -> list[tuple[tuple[int, int], int]]:
    return [(mon, i) for mon in monoms_bin(order) for i in (0, 1, 2)]


def L_matrix_sparse(m: int, r: int, a_coeffs: list[Q]) -> dict:
    """L_r(b)=B(b;a,a) on free fibre; r odd, newest order m+r."""
    assert r % 2 == 1
    order_b = m + r
    order_out = 2 * m + order_b  # = 3m+r
    lead = leading_basis(m)
    assert len(a_coeffs) == len(lead)
    a_items = [(lead[t][0], lead[t][1], Q(a_coeffs[t])) for t in range(len(lead)) if a_coeffs[t] != 0]
    dom = domain_basis_Eplus(order_b)
    cod = monoms_bin(order_out)
    cod_index = {mn: i for i, mn in enumerate(cod)}
    acc: dict[tuple[int, int], Q] = defaultdict(lambda: Q(0))
    for col, (beta, i) in enumerate(dom):
        for alpha, j, Aj in a_items:
            for alpha2, k, Ak in a_items:
                c = B_coeff(i, j, k)
                if c == 0:
                    continue
                tot = (beta[0] + alpha[0] + alpha2[0], beta[1] + alpha[1] + alpha2[1])
                if tot not in cod_index:
                    continue
                acc[(cod_index[tot], col)] += c * Aj * Ak
    entries = sorted(((r0, c0, v) for (r0, c0), v in acc.items() if v != 0))
    rows = [e[0] for e in entries]
    cols = [e[1] for e in entries]
    data = [e[2] for e in entries]
    n_rows, n_cols = len(cod), len(dom)
    rank = exact_rank_from_coo(n_rows, n_cols, rows, cols, data)
    return {
        "m": m,
        "r": r,
        "order_b": order_b,
        "order_out": order_out,
        "shape": [n_rows, n_cols],
        "nnz": len(data),
        "rank_over_Q": rank,
        "nullity_over_Q": n_cols - rank,
        "cokernel_dim_over_Q": n_rows - rank,
        "coo_rows": rows,
        "coo_cols": cols,
        "coo_data": [q_to_str(v) for v in data],
    }


def exact_rank_from_coo(n_rows, n_cols, rows, cols, data) -> int:
    if n_rows == 0 or n_cols == 0:
        return 0
    if n_rows * n_cols > 2_000_000:
        raise MemoryError(f"refusing dense rank on {(n_rows, n_cols)}")
    A = [[Q(0) for _ in range(n_cols)] for _ in range(n_rows)]
    for r0, c0, v in zip(rows, cols, data):
        A[r0][c0] += Q(v)
    rank = 0
    row = 0
    for col in range(n_cols):
        piv = None
        for i in range(row, n_rows):
            if A[i][col] != 0:
                piv = i
                break
        if piv is None:
            continue
        A[row], A[piv] = A[piv], A[row]
        inv = Q(1) / A[row][col]
        A[row] = [inv * x for x in A[row]]
        for i in range(n_rows):
            if i != row and A[i][col] != 0:
                f = A[i][col]
                A[i] = [A[i][j] - f * A[row][j] for j in range(n_cols)]
        rank += 1
        row += 1
        if row == n_rows:
            break
    return rank


def nullspace(A: list[list[Q]]) -> list[list[Q]]:
    if not A or not A[0]:
        return []
    n, m = len(A), len(A[0])
    Mtx = [row[:] for row in A]
    pivots: list[int] = []
    r = 0
    for c in range(m):
        piv = next((i for i in range(r, n) if Mtx[i][c] != 0), None)
        if piv is None:
            continue
        Mtx[r], Mtx[piv] = Mtx[piv], Mtx[r]
        inv = Q(1) / Mtx[r][c]
        Mtx[r] = [inv * x for x in Mtx[r]]
        for i in range(n):
            if i != r and Mtx[i][c] != 0:
                f = Mtx[i][c]
                Mtx[i] = [Mtx[i][j] - f * Mtx[r][j] for j in range(m)]
        pivots.append(c)
        r += 1
        if r == n:
            break
    free = [c for c in range(m) if c not in pivots]
    basis = []
    for f in free:
        v = [Q(0)] * m
        v[f] = Q(1)
        for i, c in enumerate(pivots):
            v[c] = -Mtx[i][f]
        basis.append(v)
    return basis


def matrix_from_coo(n_rows, n_cols, rows, cols, data) -> list[list[Q]]:
    A = [[Q(0) for _ in range(n_cols)] for _ in range(n_rows)]
    for r0, c0, v in zip(rows, cols, data):
        A[r0][c0] += Q(v)
    return A


def solve_least_particular(A: list[list[Q]], b: list[Q]) -> tuple[list[Q] | None, int]:
    """Solve A x = b over Q. Returns (particular solution or None, rank)."""
    if not A:
        return ([], 0) if not b else (None, 0)
    n, m = len(A), len(A[0])
    # Augmented RREF
    Mtx = [A[i][:] + [b[i]] for i in range(n)]
    pivots: list[int] = []
    r = 0
    for c in range(m):
        piv = next((i for i in range(r, n) if Mtx[i][c] != 0), None)
        if piv is None:
            continue
        Mtx[r], Mtx[piv] = Mtx[piv], Mtx[r]
        inv = Q(1) / Mtx[r][c]
        Mtx[r] = [inv * x for x in Mtx[r]]
        for i in range(n):
            if i != r and Mtx[i][c] != 0:
                f = Mtx[i][c]
                Mtx[i] = [Mtx[i][j] - f * Mtx[r][j] for j in range(m + 1)]
        pivots.append(c)
        r += 1
        if r == n:
            break
    # consistency
    for i in range(r, n):
        if Mtx[i][m] != 0:
            return None, r
    x = [Q(0)] * m
    for i, c in enumerate(pivots):
        x[c] = Mtx[i][m]
    return x, r
