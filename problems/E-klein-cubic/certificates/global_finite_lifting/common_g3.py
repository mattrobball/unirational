#!/usr/bin/env python3
"""Shared exact helpers for Path G3 finite towers at arbitrary (m,d).

Independent of produce/verify. Exact Fraction arithmetic. Absolute-path safe.
Polar model matches certificates/lifting/families/common_tower.py and degree7/common_d7.py.
"""

from __future__ import annotations

import hashlib
import json
import math
from collections import defaultdict
from fractions import Fraction as Q
from itertools import permutations
from pathlib import Path
from typing import Any


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path | str) -> str:
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def canonical_json(obj: Any) -> str:
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


def parse_q(s: str | int) -> Q:
    if isinstance(s, int):
        return Q(s)
    if isinstance(s, Q):
        return s
    if "/" in str(s):
        a, b = str(s).split("/")
        return Q(int(a), int(b))
    return Q(int(s))


def binom(n: int, k: int) -> int:
    if k < 0 or n < 0 or k > n:
        return 0
    return math.comb(n, k)


def monoms_bin(deg: int) -> list[tuple[int, int]]:
    return [(deg - k, k) for k in range(deg + 1)]


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


def multi_rees_dim(order: int, target_dim: int, d: int) -> int:
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


def stage_ledger(m: int, d: int) -> dict:
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
        delta = N - 3 * m
        formal_newest_ep = m + delta if delta >= 0 and (m + delta) % 2 == 0 else None
        isolable = (
            formal_newest_ep is not None
            and formal_newest_ep <= d
            and any(t["max_Eplus"] == formal_newest_ep for t in triples)
        )
        poly_newest_ep = max_ep if max_ep <= d else None
        eq_type = "empty"
        if triples:
            if isolable and formal_newest_ep is not None and formal_newest_ep <= d:
                eq_type = "isolate_Eplus"
            elif poly_newest_ep is not None and poly_newest_ep <= d:
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
                "codomain_free_dim": N + 1,
                "codomain_multi_rees_dim": dim_sym(3, 3 * d - N) * (N + 1)
                if N <= 3 * d
                else 0,
            }
        )
    return {
        "m": m,
        "d": d,
        "d_minus_6m": d - 6 * m,
        "terminal_F_order": terminal,
        "stages": stages,
        "nonautomatic_orders": [
            s["F_order"]
            for s in stages
            if not s["automatic_by_y_evenness"] and s["live_triples"]
        ],
    }


def jet_dimension_table(m: int, d: int) -> dict:
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


def first_stage_no_poly_correction(ledger: dict) -> dict:
    last_iso = None
    first_noniso = None
    for s in ledger["stages"]:
        if s["automatic_by_y_evenness"] or not s["live_triples"]:
            continue
        if s["equation_type"] == "isolate_Eplus" and s.get("isolable_Eplus_within_d"):
            last_iso = s["F_order"]
        elif first_noniso is None and s["F_order"] > (last_iso or -1):
            if not s.get("isolable_Eplus_within_d"):
                first_noniso = s
                break
    return {
        "last_isolable_Eplus_F_order": last_iso,
        "first_stage_without_Eplus_poly_isolator": (
            first_noniso["F_order"] if first_noniso else None
        ),
        "stage": first_noniso,
        "meaning": (
            "From this F-order onward, free-module isolation would require an "
            "E+ jet of order > d (or no pure isolator). Remaining freedom is "
            "only ker(L_*) of earlier stages and a_odd relative parameters "
            "still within degree, subject to coefficient coupling."
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
    a_items = [
        (lead[t][0], lead[t][1], Q(a_coeffs[t]))
        for t in range(len(lead))
        if a_coeffs[t] != 0
    ]
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
                tot = (
                    beta[0] + alpha[0] + alpha2[0],
                    beta[1] + alpha[1] + alpha2[1],
                )
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
    for i in range(r, n):
        if Mtx[i][m] != 0:
            return None, r
    x = [Q(0)] * m
    for i, c in enumerate(pivots):
        x[c] = Mtx[i][m]
    return x, r


# ---------------------------------------------------------------------------
# Leading jet samples (exact Q, residual-type labels)
# ---------------------------------------------------------------------------

def sample_leading_a_triv(m: int) -> tuple[list[Q], str]:
    """Residual-S3-trivial free fibre when m=1; pure-powers generic for m=3."""
    n = free_rank_jet(m, 2)
    if m == 1:
        # a_triv = y0 f1 + y1 f0  (residual S3-trivial)
        return [Q(0), Q(1), Q(1), Q(0)], "residual_S3_trivial_a_triv"
    if m == 3:
        # pure powers y0^3 f0 + y1^3 f1 — surjective L_r open sample
        a = [Q(0)] * n
        # basis order: monoms (3,0),(2,1),(1,2),(0,3) x j=0,1
        a[0] = Q(1)  # y0^3 f0
        a[7] = Q(1)  # y1^3 f1
        return a, "pure_powers_y0m_f0_plus_y1m_f1"
    # generic deterministic pattern
    out = []
    for i in range(n):
        out.append(Q((17 + i * 13 + 5) % 97 - 48, 1 + (i % 5)))
    if all(x == 0 for x in out):
        out[0] = Q(1)
    return out, f"deterministic_generic_m{m}"


def sample_leading_pure(m: int) -> tuple[list[Q], str]:
    """y0^m f0 + y1^m f1."""
    n = free_rank_jet(m, 2)
    a = [Q(0)] * n
    a[0] = Q(1)
    a[-1] = Q(1)
    return a, "pure_powers_y0m_f0_plus_y1m_f1"


# ---------------------------------------------------------------------------
# F expansion on free fibre
# ---------------------------------------------------------------------------

def pack_jet(order: int, target: str, coeffs: list[Q]) -> dict:
    if target == "E_minus":
        keys = [(mon, j) for mon in monoms_bin(order) for j in (0, 1)]
    else:
        keys = domain_basis_Eplus(order)
    assert len(coeffs) == len(keys), (order, target, len(coeffs), len(keys))
    return {keys[i]: Q(coeffs[i]) for i in range(len(keys)) if coeffs[i] != 0}


def Phi_plus(u, v, w) -> Q:
    s = Q(0)
    for t in range(3):
        s += u[t] * v[t] * w[t]
    s += (
        -Q(1, 2)
        * (
            u[0] * v[1] * w[2]
            + u[0] * v[2] * w[1]
            + u[1] * v[0] * w[2]
            + u[1] * v[2] * w[0]
            + u[2] * v[0] * w[1]
            + u[2] * v[1] * w[0]
        )
    )
    return s


def B_form(z: list[Q], yA: list[Q], yB: list[Q]) -> Q:
    return (
        z[0] * (yA[0] * yB[1] + yA[1] * yB[0])
        + z[1] * yA[1] * yB[1]
        + z[2] * yA[0] * yB[0]
    )


def Phi_mixed(u_type, u, v_type, v, w_type, w) -> Q:
    types = (u_type, v_type, w_type)
    n_plus = types.count("E_plus")
    n_minus = types.count("E_minus")
    if n_minus == 3:
        return Q(0)
    if n_plus == 3:
        return Phi_plus(u, v, w)
    if n_plus == 1 and n_minus == 2:
        if u_type == "E_plus":
            return B_form(u, v, w) / Q(3)
        if v_type == "E_plus":
            return B_form(v, u, w) / Q(3)
        return B_form(w, u, v) / Q(3)
    # (E+,E+,E-) vanishes in F(z+y)=F+(z)+B(z;y,y) model
    return Q(0)


def _basis_vec(target: str, idx: int) -> list[Q]:
    dim = 3 if target == "E_plus" else 2
    v = [Q(0)] * dim
    v[idx] = Q(1)
    return v


def expand_F_order_N(
    jets: dict[int, tuple[str, dict]],
    N: int,
    m: int,
) -> list[Q]:
    """Coefficient vector of (F(p))_N as binary form of degree N (free fibre)."""
    orders = sorted(o for o in jets if o >= m)
    cod = monoms_bin(N)
    acc = [Q(0) for _ in cod]
    cod_index = {mn: i for i, mn in enumerate(cod)}

    # Pre-extract nonzero items per order
    items = {}
    for o in orders:
        t, jdict = jets[o]
        nz = [(mon, idx, c) for (mon, idx), c in jdict.items() if c != 0]
        items[o] = (t, nz)

    for i in orders:
        ti, ni = items[i]
        if not ni:
            continue
        for j in orders:
            tj, nj = items[j]
            if not nj:
                continue
            for k in orders:
                if i + j + k != N:
                    continue
                tk, nk = items[k]
                if not nk:
                    continue
                for ai, ii, ci in ni:
                    for aj, jj_, cj in nj:
                        for ak, kk_, ck in nk:
                            tot = (
                                ai[0] + aj[0] + ak[0],
                                ai[1] + aj[1] + ak[1],
                            )
                            if tot not in cod_index:
                                continue
                            phi = Phi_mixed(
                                ti,
                                _basis_vec(ti, ii),
                                tj,
                                _basis_vec(tj, jj_),
                                tk,
                                _basis_vec(tk, kk_),
                            )
                            if phi == 0:
                                continue
                            acc[cod_index[tot]] += phi * ci * cj * ck
    return acc


# ---------------------------------------------------------------------------
# Free-fibre tower runner
# ---------------------------------------------------------------------------

def isolable_r_list(m: int, d: int) -> list[int]:
    """Odd stage indices r with m+r even (always when r odd, m odd) and m+r <= d."""
    out = []
    r = 1
    while m + r <= d:
        if r % 2 == 1:
            out.append(r)
        r += 2
    return out


def free_fibre_tower(
    m: int,
    d: int,
    a_coeffs: list[Q],
    *,
    mode: str = "ker_L1",
    a_label: str = "",
) -> dict:
    """Run truncated free-fibre polar tower with based-style a_odd=0.

    mode:
      based_zero — all E+ corrections particular=0 when RHS=0; b_{m+1}=0
      ker_L1 — first ker L1 basis vector as b_{m+1}, particular sols later
    """
    terminal = 3 * d
    lead_dim = free_rank_jet(m, 2)
    assert len(a_coeffs) == lead_dim

    jets: dict[int, tuple[str, dict]] = {
        m: ("E_minus", pack_jet(m, "E_minus", a_coeffs)),
    }
    stage_log: list[dict] = []
    L_rank_table: list[dict] = []

    # Zero intermediate pure E- relative jets (based coefficient coupling style)
    for k in range(m + 2, d + 1, 2):
        if k % 2 == 1:
            zeros = [Q(0)] * free_rank_jet(k, 2)
            jets[k] = ("E_minus", pack_jet(k, "E_minus", zeros))
            stage_log.append(
                {
                    "unknown": f"a{k}",
                    "choice": "zero_based_relative",
                    "dim": len(zeros),
                }
            )

    # Isolable stages r = 1,3,..., with order_b = m+r <= d
    r_list = isolable_r_list(m, d)
    first_b_coeffs = None
    for r in r_list:
        order_b = m + r
        F_order = 3 * m + r
        L = L_matrix_sparse(m, r, a_coeffs)
        L_rank_table.append(
            {
                "r": r,
                "order_b": order_b,
                "F_order": F_order,
                "shape": L["shape"],
                "rank_over_Q": L["rank_over_Q"],
                "nullity_over_Q": L["nullity_over_Q"],
                "coker_over_Q": L["cokernel_dim_over_Q"],
                "surjective": L["cokernel_dim_over_Q"] == 0,
            }
        )
        # Residual at F_order without b_{order_b}
        res_pre = expand_F_order_N(jets, F_order, m)
        assert len(res_pre) == L["shape"][0], (len(res_pre), L["shape"])
        A = matrix_from_coo(
            L["shape"][0],
            L["shape"][1],
            L["coo_rows"],
            L["coo_cols"],
            [parse_q(x) for x in L["coo_data"]],
        )
        if r == 1 and mode == "based_zero":
            # L1(b)=0; take zero particular
            b_coeffs = [Q(0)] * L["shape"][1]
            solvable = True
        elif r == 1 and mode == "ker_L1":
            ker = nullspace(A)
            assert len(ker) == L["nullity_over_Q"]
            b_coeffs = ker[0] if ker else [Q(0)] * L["shape"][1]
            first_b_coeffs = b_coeffs
            # verify L b = 0
            solvable = True
        else:
            sol, _rk = solve_least_particular(A, [-x for x in res_pre])
            if sol is None:
                # not solvable on this sample
                jets[order_b] = (
                    "E_plus",
                    pack_jet(order_b, "E_plus", [Q(0)] * L["shape"][1]),
                )
                stage_log.append(
                    {
                        "F_order": F_order,
                        "unknown": f"b{order_b}",
                        "L_shape": L["shape"],
                        "L_rank": L["rank_over_Q"],
                        "L_coker": L["cokernel_dim_over_Q"],
                        "R_norm_sq": q_to_str(sum(x * x for x in res_pre)),
                        "solvable": False,
                    }
                )
                return {
                    "sample_name": f"{mode}_on_{a_label or 'leading'}",
                    "mode": mode,
                    "a_label": a_label,
                    "a_m": [q_to_str(x) for x in a_coeffs],
                    "m": m,
                    "d": d,
                    "failed_at_isolable_F_order": F_order,
                    "stage_log": stage_log,
                    "L_rank_table": L_rank_table,
                    "first_nonzero_terminal_F_order": F_order,
                    "early_orders_vanish": {},
                    "terminal_residuals": {
                        str(F_order): {
                            "F_order": F_order,
                            "residual_norm_sq": q_to_str(sum(x * x for x in res_pre)),
                            "is_zero": False,
                            "note": "RHS not in image of L_r on this sample",
                        }
                    },
                    "solvable_through_all_isolators": False,
                }
            b_coeffs = sol
            solvable = True

        jets[order_b] = ("E_plus", pack_jet(order_b, "E_plus", b_coeffs))
        stage_log.append(
            {
                "F_order": F_order,
                "unknown": f"b{order_b}",
                "L_shape": L["shape"],
                "L_rank": L["rank_over_Q"],
                "L_coker": L["cokernel_dim_over_Q"],
                "R_norm_sq": q_to_str(sum(x * x for x in res_pre)),
                "solvable": solvable,
                "particular_is_zero": all(x == 0 for x in b_coeffs),
                "b_nonzero": any(x != 0 for x in b_coeffs),
            }
        )

    # Ensure all even orders in [m+1, d] have jet entries (zero if not set)
    for k in range(m + 1 if (m + 1) % 2 == 0 else m + 2, d + 1, 2):
        if k not in jets:
            jets[k] = (
                "E_plus",
                pack_jet(k, "E_plus", [Q(0)] * free_rank_jet(k, 3)),
            )

    # Based coupling: a_d = 0 already if d odd (E-)
    if d % 2 == 1 and d not in jets:
        jets[d] = ("E_minus", pack_jet(d, "E_minus", [Q(0)] * free_rank_jet(d, 2)))
        stage_log.append(
            {
                "unknown": f"a{d}",
                "choice": "zero_based_coefficient_coupling",
                "reason": "based family: p|_{E_-}=0 and d odd ⇒ a_d=0",
                "dim": free_rank_jet(d, 2),
            }
        )

    # Early isolable F-orders should vanish
    early = {}
    for r in r_list:
        N = 3 * m + r
        res = expand_F_order_N(jets, N, m)
        nsq = sum(x * x for x in res)
        early[str(N)] = {
            "residual_norm_sq": q_to_str(nsq),
            "is_zero": nsq == 0,
        }

    # Terminal / post-isolator residuals
    last_iso_F = 3 * m + r_list[-1] if r_list else None
    first_post = (last_iso_F + 2) if last_iso_F is not None else (3 * m + 1)
    # first even >= first_post
    if first_post % 2 == 1:
        first_post += 1

    terminal_res = {}
    first_nonzero = None
    residual_at_first = None
    for N in range(first_post, terminal + 1, 2):
        res = expand_F_order_N(jets, N, m)
        nsq = sum(x * x for x in res)
        entry = {
            "F_order": N,
            "codomain_dim": len(res),
            "residual_norm_sq": q_to_str(nsq),
            "is_zero": nsq == 0,
        }
        # store coeffs only for first nonzero (keep sealed payloads small)
        if nsq != 0 and first_nonzero is None:
            first_nonzero = N
            entry["residual_coeffs"] = [q_to_str(x) for x in res]
            residual_at_first = res
        terminal_res[str(N)] = entry

    # Representation note for residual binary form
    residual_decomp = residual_binary_decomp(residual_at_first, first_nonzero)

    return {
        "sample_name": f"{mode}_on_{a_label or 'leading'}",
        "mode": mode,
        "a_label": a_label,
        "a_m": [q_to_str(x) for x in a_coeffs],
        "m": m,
        "d": d,
        "d_minus_6m": d - 6 * m,
        "stage_log": stage_log,
        "L_rank_table": L_rank_table,
        "early_orders_vanish": early,
        "terminal_residuals": terminal_res,
        "first_nonzero_terminal_F_order": first_nonzero,
        "last_isolable_F_order": last_iso_F,
        "first_post_isolator_F_order": first_post,
        "solvable_through_all_isolators": all(
            e.get("is_zero", False) for e in early.values()
        ),
        "b_m_plus_1_nonzero": (
            any(x != 0 for x in first_b_coeffs) if first_b_coeffs is not None else False
        ),
        "residual_decomposition": residual_decomp,
        "ker_L1_dim": next(
            (row["nullity_over_Q"] for row in L_rank_table if row["r"] == 1), None
        ),
    }


def residual_binary_decomp(res: list[Q] | None, N: int | None) -> dict:
    if res is None or N is None:
        return {
            "status": "ZERO_OR_ABSENT",
            "note": "No nonzero free-fibre residual on this sample branch.",
        }
    # C3 weight: monom y0^{N-k} y1^k has weight (N-k) - k = N - 2k mod 3
    weights = {0: [], 1: [], 2: []}
    monoms = monoms_bin(N)
    for idx, ((a, b), c) in enumerate(zip(monoms, res)):
        if c == 0:
            continue
        w = (a - b) % 3
        weights[w].append({"monom": [a, b], "coeff": q_to_str(c), "index": idx})
    support = [i for i, c in enumerate(res) if c != 0]
    return {
        "status": "NONZERO",
        "F_order": N,
        "codomain_dim": N + 1,
        "support_indices": support,
        "support_size": len(support),
        "C3_weight_components": {
            str(w): {"n_terms": len(weights[w]), "terms": weights[w][:12]}
            for w in (0, 1, 2)
        },
        "dominant_C3_weights": [w for w in (0, 1, 2) if weights[w]],
        "stabilizer_note": (
            "Free-fibre residual is a binary form of order N under the residual "
            "D12 / C3 action on E_- coordinates. This is a local normal-cone "
            "obstruction type, not a full G-isotypic of Hom(Sym^d W*,W)^G."
        ),
        "G_representation_note": (
            "G-global residual for equivariant polynomial maps is a separate "
            "layer (Molien spaces / modular scans). Free-fibre residual classifies "
            "the truncated polar tower on one involution plane."
        ),
    }


# ---------------------------------------------------------------------------
# G4 architecture
# ---------------------------------------------------------------------------

def global_correction_architecture(stage: dict, d: int, m: int) -> dict:
    N = stage["F_order"]
    free_cod = stage.get("codomain_free_dim", N + 1)
    rees_cod = stage.get("codomain_multi_rees_dim", 0)
    eq_type = stage["equation_type"]
    newest_ep = stage.get("formal_newest_Eplus_order")

    if eq_type == "isolate_Eplus" and newest_ep is not None and newest_ep <= d:
        dom_free = free_rank_jet(newest_ep, 3)
        dom_rees = multi_rees_dim(newest_ep, 3, d)
        operator = f"L(b_{newest_ep}) = B(b_{newest_ep}; a_{m}, a_{m})"
    else:
        dom_free = 0
        dom_rees = 0
        operator = "no_newest_Eplus_isolator_within_degree"

    plane_norm = {
        "layer": "plane_normalization",
        "object": "normal jets along Z_t = P(E_+)",
        "free_codomain_dim": free_cod,
        "multi_rees_codomain_dim": rees_cod,
        "note": "Scalar F-order N jets on the normal cone of the involution plane.",
    }
    triple_eq = {
        "layer": "triple_line_equalizer",
        "object": (
            "V4 triple-line residual equalizer of plane jets "
            "(three copies of P(E_-) kept distinct)"
        ),
        "source_line_coefficient_coupling": (
            "based: p|_{E_-}=0; residual: p|_{E_-}=p_d(0,y) nonzero ledger"
        ),
        "repaired_category": [
            "L_t^{src} (SOURCE)",
            "P(E_-)^N (NORMAL)",
            "L_t^{tgt} (TARGET)",
        ],
        "note": (
            "Equalizer cuts the free plane module before L_r acts. "
            "Local free-module surjectivity is not global solvability."
        ),
        "accepted_leading_based_residual_dim_m1": 10,
    }
    point_ker = {
        "layer": "residual_point_kernel",
        "object": "A4/D10/D12/type-I/II point modules + marked elliptic charges",
        "irrelevant_torsion": "retained (finite T_m; not discarded)",
        "note": (
            "Point kernels impose O(d) residual conditions (accepted upper bound). "
            "They are coefficient constraints orthogonal to free polar ranks."
        ),
    }

    if eq_type == "isolate_Eplus":
        local_claim = (
            "Free-module L_r is generically surjective (accepted rank theorem). "
            "Global solvability requires the composition through the equalizer "
            "and point kernel to hit the residual class — NOT automatic from local rank."
        )
        global_status = "LOCAL_SURJECTIVE_OPEN_GLOBAL_EQUALIZER_REQUIRED"
    elif eq_type == "mixed_residual":
        local_claim = (
            "No pure free-module E+ isolator; residual is a polynomial constraint "
            "on previously fixed jets, possibly linear in remaining a_odd."
        )
        global_status = "CONSTRAINT_ON_PRIOR_GLOBAL_STATE"
    elif eq_type == "terminal_residual":
        local_claim = "Terminal residual: no polynomial correction remains."
        global_status = "TERMINAL"
    else:
        local_claim = "Empty or automatic."
        global_status = "N/A"

    return {
        "F_order": N,
        "equation_type": eq_type,
        "operator": operator,
        "domain_free_dim": dom_free,
        "domain_multi_rees_dim": dom_rees,
        "layers": [plane_norm, triple_eq, point_ker],
        "local_vs_global": local_claim,
        "global_status": global_status,
        "house_rule_G4": (
            "No local free-module surjectivity may be promoted to global "
            "solvability without plane→equalizer→point-kernel."
        ),
    }


def build_g4_table(ledger: dict, d: int, m: int) -> list[dict]:
    out = []
    for s in ledger["stages"]:
        if s["automatic_by_y_evenness"]:
            continue
        if not s["live_triples"]:
            continue
        out.append(global_correction_architecture(s, d, m))
    return out


def free_Lr_rank_table(m: int, d: int, a_coeffs: list[Q], a_label: str) -> dict:
    rows = []
    for r in isolable_r_list(m, d):
        L = L_matrix_sparse(m, r, a_coeffs)
        rows.append(
            {
                "r": r,
                "order_b": m + r,
                "F_order": 3 * m + r,
                "within_degree": True,
                "sample": a_label,
                "shape": L["shape"],
                "rank_over_Q": L["rank_over_Q"],
                "nullity_over_Q": L["nullity_over_Q"],
                "coker_over_Q": L["cokernel_dim_over_Q"],
                "surjective": L["cokernel_dim_over_Q"] == 0,
            }
        )
    # first formal isolator beyond degree
    r_beyond = None
    r = 1
    while True:
        if m + r > d and r % 2 == 1:
            r_beyond = r
            break
        r += 2
        if r > d + 5:
            break
    if r_beyond is not None:
        rows.append(
            {
                "r": r_beyond,
                "order_b": m + r_beyond,
                "F_order": 3 * m + r_beyond,
                "within_degree": False,
                "sample": None,
                "note": f"First formal isolator beyond polynomial degree {d}",
            }
        )
    return {"m": m, "d": d, "a_label": a_label, "rows": rows}
