#!/usr/bin/env python3
"""Timeboxed kernel question: why is rank(μ: Sym^3(cell)→Inv^{105}) only 1380?

The 7759-dim kernel is HF3 = N3 − P3.  Candidate: polarization degeneracy
from T_c ranging over a LINEAR subspace L ⊂ M_35 (dim 37 ≪ dim M_35 = 637).

Tests (modular, both primes where cheap):
  K1  rank of μ on the FULL M_35 (not just the cell) via same inv-eval method
      — if still ≪ I(105), degeneracy is not just "small linear slice".
  K2  rank growth along nested random subspaces L_r ⊂ cell of dim r=5..37
      — is rank ~ binom(r+2,3) (full) or saturates early (structural)?
  K3  compare P3 to dim Sym^3 of a "multiplicative" model: if T_i were
      rank-1 or shared image, F(T_c) would factor; measure image span of
      {T_j(x)} over random x (tuple-multiplication rank bound).

One clean statement or documented dead end.  No deep sink.
"""
from __future__ import annotations

import json
import os
import sys
time_mod = __import__("time")
import numpy as np

import paths
import invlib as L
import slicelib as SL
import d34lib as D34
import p2lib as P2
import produce_d34 as PD


def klein_F_batch(Tv, p):
    """Tv (..., 5) -> F values."""
    s = np.zeros(Tv.shape[:-1], dtype=np.int64)
    for i in range(5):
        s = (s + Tv[..., i] * Tv[..., i] % p * Tv[..., (i + 1) % 5]) % p
    return s % p


def p3_on_B(fr, A, C, B, d, p, n_func=2000, max_c=5000, stable_window=300, seed=0):
    """Quick inv-side P3 on a (K x ns) basis matrix B."""
    return L.inv_side_p3(
        fr, A, C, B, d, p,
        n_func=n_func,
        max_c=max_c,
        stable_window=stable_window,
        extra_batches=1,
        extra_size=200,
        seed=seed,
        grow_func=True,
    )


def tuple_image_ranks(fr, A, C, B, d, p, npts=40, seed=1):
    """For random x, rank of the K vectors T_j(x) in F_p^5.

    If all T_j(x) lie in a low-dim subspace of W, F(T_c(x)) is constrained.
    """
    rng = np.random.default_rng(seed + p)
    pts = rng.integers(0, p, size=(npts, 5), dtype=np.int64)
    for i in range(npts):
        if not pts[i].any():
            pts[i, 0] = 1
    Mall = L.eval_T_at_points(fr, A, C, B, pts, d)  # (npts, 5, K)
    ranks = []
    for q in range(npts):
        # matrix 5 x K
        ranks.append(int(SL.rref_rank(Mall[q], p)))
    return {
        "npts": npts,
        "ranks": ranks,
        "rank_min": min(ranks),
        "rank_max": max(ranks),
        "rank_mean": float(np.mean(ranks)),
        "note": "rank of {T_j(x)} as vectors in W at sample points x",
    }


def nested_rank_curve(fr, A, C, Bfull, d, p, dims=None, seed=2):
    """P3 on coordinate subspaces of the cell (first r basis vectors after random mix)."""
    rng = np.random.default_rng(seed + p)
    K = Bfull.shape[0]
    # random GL mix so "first r" is a random r-plane
    G = rng.integers(1, p, size=(K, K), dtype=np.int64)
    Bmix = (G @ Bfull) % p
    if dims is None:
        dims = [5, 10, 15, 20, 25, 30, 37]
        dims = [r for r in dims if r <= K]
    curve = []
    for r in dims:
        Br = Bmix[:r]
        # smaller budget for nested probes
        nf = min(1800, 80 * r + 200)
        rec = p3_on_B(
            fr, A, C, Br, d, p,
            n_func=nf, max_c=min(4000, 30 * r + 500),
            stable_window=200, seed=1000 + r,
        )
        curve.append({
            "r": r,
            "P3": rec["P3"],
            "saturated": rec["saturated"],
            "N3": rec["N3"],
            "ratio_P3_N3": rec["P3"] / rec["N3"] if rec["N3"] else None,
            "seconds": rec["seconds"],
        })
        print("  nested r=%d P3=%d N3=%d sat=%s" % (
            r, rec["P3"], rec["N3"], rec["saturated"]), flush=True)
    return curve


def full_M35_rank(fr, d, p, dimM, seed=3):
    """P3 for the full M_d (all of M, not the cell): B = I_{ns} after basis seeds."""
    rng = np.random.default_rng(seed + p)
    print("[K1] building full M_%d basis seeds dim=%d" % (d, dimM), flush=True)
    A, C, got = PD.basis_seeds(fr, d, dimM, p, rng)
    if A is None:
        return {"error": "seed shortfall %d/%d" % (got, dimM)}
    ns = A.shape[0]
    B = np.eye(ns, dtype=np.int64)  # full ambient in seed coordinates
    # This is huge K=637 — inv method still works but n_func needs care.
    # Use moderate n_func; report lower bound if unsaturated.
    rec = L.inv_side_p3(
        fr, A, C, B, d, p,
        n_func=4000,
        max_c=10000,
        stable_window=400,
        extra_batches=1,
        extra_size=300,
        seed=20260812 + p,
        grow_func=True,
    )
    rec["dim_M"] = dimM
    rec["note"] = "μ on full M_d in Reynolds-seed coordinates"
    return rec


def main():
    primes = [int(a) for a in sys.argv[1:] if a.isdigit()] or [331]
    # Default: one prime deep + optional second; timeboxed
    d = 35
    t_budget = 900  # seconds soft budget for full-M probe
    out_all = {}

    for p in primes:
        t0 = time_mod.time()
        print("=" * 60, "\n[kernel] p=%d" % p, flush=True)
        fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=True)))
        cell = L.load_d35_cell(p)
        A, C, B = cell["A"], cell["C"], cell["Bcell"]

        # K3: tuple image ranks
        print("[K3] tuple image ranks at random x", flush=True)
        k3 = tuple_image_ranks(fr, A, C, B, d, p)

        # K2: nested subspaces of the cell
        print("[K2] nested cell subspaces", flush=True)
        k2 = nested_rank_curve(fr, A, C, B, d, p)

        # K1: full M_35 if budget remains
        k1 = None
        elapsed = time_mod.time() - t0
        if elapsed < t_budget * 0.4:
            print("[K1] full M_35 probe (timeboxed)", flush=True)
            try:
                k1 = full_M35_rank(fr, d, p, paths.DIM_M[d])
            except Exception as e:
                k1 = {"error": str(e)}
        else:
            k1 = {"skipped": True, "reason": "time budget", "elapsed": elapsed}

        # Verdict assembly
        verdict = {
            "candidate": (
                "polarization degeneracy from linear T_c ⊂ M_35"
            ),
            "observations": [],
            "status": "dead_end_or_partial",
        }
        if k3:
            verdict["observations"].append(
                "K3: at random x, rank{T_j(x)} ⊂ W has min=%d max=%d mean=%.2f "
                "(K=37, ambient W=5 so max≤5). Low pointwise rank is forced by "
                "dim W=5, not by the cell."
                % (k3["rank_min"], k3["rank_max"], k3["rank_mean"])
            )
        if k2:
            ratios = [
                (c["r"], c["P3"], c["N3"], round(c["P3"] / c["N3"], 4) if c["N3"] else None)
                for c in k2
            ]
            verdict["observations"].append(
                "K2 nested (r, P3, N3, ratio): %s" % ratios
            )
            # If ratio stays ~ constant or P3 << N3 even for small r, structural
            last = k2[-1]
            if last["P3"] and last["N3"] and last["P3"] / last["N3"] < 0.25:
                verdict["observations"].append(
                    "P3/N3 stays well below 1 on the full cell (%.3f) — "
                    "kernel is a large fraction of Sym^3(cell)."
                    % (last["P3"] / last["N3"])
                )
        if k1 and not k1.get("skipped") and not k1.get("error"):
            verdict["observations"].append(
                "K1 full M_35: P3_full=%s sat=%s I(105)=8555 (if P3_full still "
                "≪ 8555, the kernel is not explained merely by restricting to "
                "the 37-cell)."
                % (k1.get("P3"), k1.get("saturated"))
            )
            if k1.get("P3") and k1["P3"] < 8555 * 0.5:
                verdict["status"] = (
                    "partial: full M_35 also far below I(105) — degeneracy is "
                    "in the cubic map Sym^3(M)→Inv, not only the cell cut"
                )
            elif k1.get("P3") and k1["P3"] >= 8000:
                verdict["status"] = (
                    "partial: full M_35 nearly fills Inv — cell restriction "
                    "is the dominant source of the 7759 kernel"
                )

        rec = {
            "p": p,
            "d": d,
            "K3_tuple_image": k3,
            "K2_nested": k2,
            "K1_full_M": {
                k: k1[k]
                for k in k1
                if k not in ("rank_curve", "extra_batches")
            } if k1 else None,
            "verdict": verdict,
            "seconds": time_mod.time() - t0,
            "HF3_kernel_dim": 7759,
            "I105": 8555,
            "P3_cell": 1380,
        }
        with open(os.path.join(paths.RES, "kernel_p%d.json" % p), "w") as f:
            json.dump(L.jsonable(rec), f, indent=2)
        out_all[str(p)] = rec["verdict"]
        print("VERDICT p=%d:" % p, json.dumps(verdict, indent=2), flush=True)

    with open(os.path.join(paths.RES, "kernel_summary.json"), "w") as f:
        json.dump(L.jsonable(out_all), f, indent=2)
    return 0


if __name__ == "__main__":
    sys.exit(main())
