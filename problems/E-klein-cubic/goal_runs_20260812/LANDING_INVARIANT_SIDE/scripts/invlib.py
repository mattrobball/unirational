#!/usr/bin/env python3
"""Invariant-side landing instruments.

Structural fact: c ↦ F(T_c) lands in Inv^{3d} ⊂ Sym^{3d} W*.
The map μ: Sym^3(cell) → Inv^{3d} has rank P3(d).

P3 is computed without the raw Sym^3(cell) ambient binom(K+2,3):
sample random Inv dual functionals (point evaluations — for an already-
invariant form P, orbit-averaged eval reduces to scaled eval), build the
matrix M_{s,t} = F(T_{c_s}(y_t)), and take its rank.  For char > 3 the
pure cubes span Sym^3, so the linear span of {F(T_c)} recovers im(μ).

Ceiling: P3(d) ≤ I(3d).  HF3(d) = binom(K+2,3) − P3(d).
"""
from __future__ import annotations

import json
import os
import time
from typing import Any

import numpy as np

import paths
import slicelib as SL

# Reuse Layer-0 / flip builders from LANDING_SWEEP
import instruments as I  # noqa: E402
import produce_dims34 as DIMS  # noqa: E402
import d34lib as D34  # noqa: E402
import p2lib as P2  # noqa: E402


def nmon3(K: int) -> int:
    return (K * (K + 1) * (K + 2)) // 6


def klein_F(v, p: int) -> int:
    s = 0
    for i in range(5):
        s = (s + int(v[i]) * int(v[i]) % p * int(v[(i + 1) % 5])) % p
    return int(s)


class Echelon:
    """Row-echelon span over F_p."""

    def __init__(self, ncols: int, p: int):
        self.p = int(p)
        self.ncols = ncols
        self.basis = np.zeros((0, ncols), dtype=np.int64)
        self.pivots: list[int] = []

    @property
    def rank(self) -> int:
        return len(self.pivots)

    def reduce(self, v):
        p = self.p
        v = np.array(v, dtype=np.int64, copy=True) % p
        for i, piv in enumerate(self.pivots):
            if v[piv]:
                v = (v - int(v[piv]) * self.basis[i]) % p
        return v

    def try_add(self, v) -> bool:
        p = self.p
        v = self.reduce(v)
        nz = np.nonzero(v)[0]
        if not nz.size:
            return False
        piv = int(nz[0])
        v = (v * pow(int(v[piv]), p - 2, p)) % p
        if self.basis.shape[0]:
            col = self.basis[:, piv].copy()
            nz2 = np.nonzero(col)[0]
            if nz2.size:
                self.basis[nz2] = (self.basis[nz2] - np.outer(col[nz2], v)) % p
        self.basis = (
            np.vstack([self.basis, v]) if self.basis.shape[0] else v.reshape(1, -1)
        )
        self.pivots.append(piv)
        return True


def load_d35_cell(p: int) -> dict:
    """Sealed 37-cell from PAIR_ATTACK_D35 (flip cut of Layer-0)."""
    null = np.load(os.path.join(paths.PAIR_RES, "layer0_null_p%d.npy" % p))
    A = np.load(os.path.join(paths.PAIR_RES, "layer0_A_p331.npy"))
    C = np.load(os.path.join(paths.PAIR_RES, "layer0_C_p331.npy"))
    we = json.load(
        open(os.path.join(paths.PAIR_RES, "worked_example_p%d.json" % p))
    )
    U = np.array(we["universal_matrix_6x39"], dtype=np.int64) % p
    K39 = SL.nullspace(U, p)
    assert K39.shape[0] == 37, K39.shape
    B37 = (K39 @ null) % p
    assert SL.rref_rank(B37, p) == 37
    return {
        "d": 35,
        "p": p,
        "A": A,
        "C": C,
        "Bcell": B37,
        "K": 37,
        "source": "PAIR_ATTACK_D35",
    }


def build_post_flip_cell(fr, d: int, dimM: int, p: int, rng) -> dict:
    """Layer-0 (1,6) cell then six-flip cut (odd d) via LANDING_SWEEP instruments."""
    cell = I.build_layer0_cell(fr, d, dimM, p, rng, npair=100, npt=80)
    if "error" in cell:
        return cell
    NUL = cell["NUL"]
    flip = I.six_flip_rank(fr, cell["A"], cell["C"], NUL, d, p)
    B = I.post_flip_null(NUL, flip, p)
    return {
        "d": d,
        "p": p,
        "A": cell["A"],
        "C": cell["C"],
        "NUL": NUL,
        "Bcell": B,
        "K": int(B.shape[0]),
        "cell_dim": int(cell["cell_dim"]),
        "flip": {k: flip[k] for k in flip if k != "universal_matrix"},
        "source": "build_layer0+flip",
    }


def eval_T_at_points(fr, A, C, Bcell, pts, d: int):
    """(npts, 5, K) = T_j(x_q) components."""
    return I.eval_cell_at_points(fr, A, C, Bcell, pts, d)


def inv_side_p3(
    fr,
    A,
    C,
    Bcell,
    d: int,
    p: int,
    n_func: int | None = None,
    max_c: int = 8000,
    stable_window: int = 400,
    extra_batches: int = 2,
    extra_size: int = 500,
    seed: int = 20260812,
    grow_func: bool = True,
) -> dict[str, Any]:
    """Saturate P3 via evaluation matrix M[s,t] = F(T_{c_s}(y_t)).

    Columns index sketched Inv duals (point evals); rows index random cell
    samples.  Rank equals P3 once both pools separate im(μ).
    """
    K = int(Bcell.shape[0])
    Iceil = paths.I_3D.get(d)
    N3 = nmon3(K)
    t0 = time.time()
    if K == 0:
        return {
            "d": d, "p": p, "K": 0, "P3": 0, "HF3": 0, "N3": 0,
            "I_3d": Iceil, "saturated": True, "mode": "empty",
        }

    # Functional pool: start large enough vs sealed/expected ranks; can grow.
    if n_func is None:
        # d=35 control targets 1380; d=36 was ≥1500 unsaturated in dense mode
        base = {35: 2200, 36: 3500, 37: 4500, 38: 5500}.get(d, 4000)
        n_func = min(base, Iceil if Iceil else base)
    rng = np.random.default_rng(seed + 17 * d + p)

    def fresh_funcs(n):
        ys = rng.integers(0, p, size=(n, 5), dtype=np.int64)
        for i in range(n):
            if not ys[i].any():
                ys[i, 0] = 1
        return ys

    ys = fresh_funcs(n_func)
    print(
        "[inv-P3] d=%d p=%d K=%d N3=%d I(3d)=%s n_func=%d"
        % (d, p, K, N3, Iceil, n_func),
        flush=True,
    )
    print("[inv-P3] precomputing T at functional points ...", flush=True)
    t1 = time.time()
    Mall = eval_T_at_points(fr, A, C, Bcell, ys, d)  # (n_func, 5, K)
    print(
        "[inv-P3] T-precomp done in %.1fs  shape=%s"
        % (time.time() - t1, Mall.shape),
        flush=True,
    )

    # Row = (F(M_t @ c))_t  ∈ F_p^{n_func}
    ech = Echelon(n_func, p)
    n_tested = 0
    stable = 0
    curve = []
    # Batch size: evaluate many c against fixed Mall
    while n_tested < max_c and stable < stable_window:
        b = 32
        cs = rng.integers(0, p, size=(b, K), dtype=np.int64)
        # For each c: v[t] = F(Mall[t] @ c)
        # Mall: (R, 5, K); c: (b, K) -> Tv[t,q,comp] = sum_j Mall[t,comp,j]*c[q,j]
        Tv = np.einsum("tck,bk->btc", Mall, cs) % p  # (b, n_func, 5)
        for q in range(b):
            if n_tested >= max_c or stable >= stable_window:
                break
            row = np.zeros(n_func, dtype=np.int64)
            for t in range(n_func):
                row[t] = klein_F(Tv[q, t], p)
            n_tested += 1
            if ech.try_add(row):
                stable = 0
            else:
                stable += 1
            if n_tested % 100 == 0 or ech.rank == n_func:
                curve.append(
                    {
                        "n": n_tested,
                        "rank": ech.rank,
                        "stable": stable,
                        "n_func": n_func,
                        "t": time.time() - t0,
                    }
                )
                print(
                    "  n=%d rank=%d stable=%d n_func=%d (%.1fs)"
                    % (n_tested, ech.rank, stable, n_func, time.time() - t0),
                    flush=True,
                )
            # If rank hits functional budget, grow the dual pool
            if grow_func and ech.rank >= n_func - 2 and n_func < (Iceil or 10**9):
                add = min(1500, (Iceil or n_func + 1500) - n_func)
                if add <= 0:
                    break
                print(
                    "[inv-P3] rank hit n_func=%d; growing by %d" % (n_func, add),
                    flush=True,
                )
                ys2 = fresh_funcs(add)
                Mall2 = eval_T_at_points(fr, A, C, Bcell, ys2, d)
                Mall = np.concatenate([Mall, Mall2], axis=0)
                # Rebuild echelon in enlarged ambient from stored basis
                # (basis rows were length old n_func — pad zeros and re-seed
                # from a fresh saturation pass would be safer; here: restart
                # rank accumulation with larger pool, keep rank lower bound)
                old_rank = ech.rank
                n_func = n_func + add
                ech = Echelon(n_func, p)
                stable = 0
                # Re-sample enough to recover previous rank quickly
                recover = 0
                while ech.rank < old_rank and recover < old_rank + 500:
                    cs = rng.integers(0, p, size=(48, K), dtype=np.int64)
                    Tv = np.einsum("tck,bk->btc", Mall, cs) % p
                    for q in range(48):
                        row = np.array(
                            [klein_F(Tv[q, t], p) for t in range(n_func)],
                            dtype=np.int64,
                        )
                        recover += 1
                        n_tested += 1
                        ech.try_add(row)
                print(
                    "[inv-P3] after grow: rank=%d n_func=%d" % (ech.rank, n_func),
                    flush=True,
                )

    # Extra independent batches for saturation certificate
    extras = []
    for bi in range(extra_batches):
        brng = np.random.default_rng(seed + 10007 * (bi + 1) + 13 * p + d)
        before = ech.rank
        added = 0
        for _ in range(extra_size):
            c = brng.integers(0, p, size=K, dtype=np.int64)
            Tv = np.einsum("tck,k->tc", Mall, c) % p  # (n_func, 5)
            row = np.array([klein_F(Tv[t], p) for t in range(n_func)], dtype=np.int64)
            if ech.try_add(row):
                added += 1
            n_tested += 1
        extras.append(
            {
                "batch": bi,
                "size": extra_size,
                "rank_before": before,
                "rank_after": ech.rank,
                "added": added,
            }
        )
        print(
            "  extra batch %d: +%d -> rank=%d" % (bi, added, ech.rank), flush=True
        )

    P3 = int(ech.rank)
    hit_ceiling_funcs = P3 >= n_func - 1
    sat = (
        stable >= stable_window
        and all(e["added"] == 0 for e in extras)
        and not hit_ceiling_funcs
    )
    out = {
        "d": d,
        "p": int(p),
        "K": K,
        "N3": N3,
        "I_3d": Iceil,
        "P3": P3,
        "P3_is_lower_bound": not sat,
        "HF3": N3 - P3,
        "HF3_note": "HF3 = binom(K+2,3) - P3 (c-ring Hilbert piece)",
        "deficit_vs_I": (Iceil - P3) if Iceil is not None else None,
        "ratio_P3_over_I": (P3 / Iceil) if Iceil else None,
        "ratio_P3_over_N3": P3 / N3 if N3 else None,
        "n_func": n_func,
        "npts_c_tested": n_tested,
        "stable_final": stable,
        "stable_window": stable_window,
        "extra_batches": extras,
        "extra_added_total": sum(e["added"] for e in extras),
        "saturated": sat,
        "mode": "inv_eval_matrix",
        "hit_func_ceiling": hit_ceiling_funcs,
        "rank_curve": curve[-40:],
        "seconds": time.time() - t0,
    }
    return out


def jsonable(obj):
    if isinstance(obj, dict):
        return {k: jsonable(v) for k, v in obj.items()}
    if isinstance(obj, (list, tuple)):
        return [jsonable(v) for v in obj]
    if isinstance(obj, (np.integer,)):
        return int(obj)
    if isinstance(obj, (np.floating,)):
        return float(obj)
    if isinstance(obj, np.ndarray):
        return obj.tolist()
    if isinstance(obj, (np.bool_,)):
        return bool(obj)
    return obj
