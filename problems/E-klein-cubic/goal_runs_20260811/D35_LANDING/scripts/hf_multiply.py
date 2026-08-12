#!/usr/bin/env python3
"""Hilbert pieces I_d for d>=4 of the landing ideal, via k×k sketched rank.

Each probe builds a k×k matrix whose rank equals min(k, dim I_d) with high
probability (two seeds). Adaptive k until rank < k (certified plateau) or
time/schedule cap. Tier-2 modular evidence.
"""
from __future__ import annotations

import itertools
import json
import os
import sys
import time

import numpy as np

import paths
import slicelib as SL

RES = paths.RES
K = 37


def nmon(d, n=K):
    r = 1
    for i in range(d):
        r = r * (n + i) // (i + 1)
    return r


def mon_list(d, n=K):
    return list(itertools.combinations_with_replacement(range(n), d))


def build_mul_table(d, n=K):
    mons_d = mon_list(d, n)
    mons_n = mon_list(d + 1, n)
    idx_n = {m: i for i, m in enumerate(mons_n)}
    N_d = len(mons_d)
    table = np.empty((n, N_d), dtype=np.int32)
    for j, mon in enumerate(mons_d):
        for i in range(n):
            table[i, j] = idx_n[tuple(sorted(mon + (i,)))]
    return table, len(mons_n)


def rref_rank_fast(M, p):
    A = np.array(M, dtype=np.int64) % p
    rows, cols = A.shape
    r = 0
    for c in range(cols):
        col = A[r:, c]
        nz = np.nonzero(col)[0]
        if nz.size == 0:
            continue
        piv = r + int(nz[0])
        if piv != r:
            A[[r, piv]] = A[[piv, r]]
        inv = pow(int(A[r, c]) % p, p - 2, p)
        A[r] = (A[r] * inv) % p
        below = A[r + 1:, c]
        kk = np.nonzero(below)[0]
        if kk.size:
            A[r + 1 + kk] = (A[r + 1 + kk] - np.outer(below[kk], A[r])) % p
        r += 1
        if r == rows:
            break
    return r


def kxk_mul_rank(basis_d, d, p, k, seed, mul_table=None):
    """Rank of k random elements of I_{d+1}, each restricted to k random coords.

    Equals min(k, P_{d+1}) with overwhelming probability.
    Element construction: L * f with random linear L and random f in span(basis_d).
    """
    p = int(p)
    P, N_d = basis_d.shape
    N_next = nmon(d + 1)
    if mul_table is None:
        mul_table, N_next = build_mul_table(d)
    rng = np.random.default_rng(seed)
    k = min(k, N_next)
    coords = rng.choice(N_next, size=k, replace=False)
    inv = np.full(N_next, -1, dtype=np.int32)
    inv[coords] = np.arange(k, dtype=np.int32)
    land = inv[mul_table]  # (K, N_d)

    t0 = time.time()
    # Batch: compute k random combos -> F (k, N_d)
    Combo = rng.integers(0, p, size=(k, P), dtype=np.int64)
    F = (Combo @ (basis_d % p)) % p  # (k, N_d)
    Lin = rng.integers(0, p, size=(k, K), dtype=np.int64)

    Mat = np.zeros((k, k), dtype=np.int64)
    # For each sample s: Mat[s, slot] += Lin[s,i] * F[s,j] for land[i,j]=slot
    # Vectorize over j where possible
    for i in range(K):
        slots = land[i]  # (N_d,)
        # columns j that land in sketch
        active = np.where(slots >= 0)[0]
        if not active.size:
            continue
        sl = slots[active]  # sketch slots
        # contrib[s, t] from this i: sum_{j: slots[j]=sl[t]?} 
        # For each active j: Mat[s, slots[j]] += Lin[s,i] * F[s,j]
        li = Lin[:, i] % p  # (k,)
        for j, slot in zip(active, sl):
            col = (li * F[:, j]) % p
            Mat[:, slot] = (Mat[:, slot] + col) % p
        if (i + 1) % 10 == 0:
            print("    var %d/%d build (%.1fs)" % (i + 1, K, time.time() - t0),
                  flush=True)

    rk = rref_rank_fast(Mat, p)
    dt = time.time() - t0
    print("  k=%d seed=%d rank=%d (%.1fs)" % (k, seed, rk, dt), flush=True)
    return int(rk), {"k": k, "seed": seed, "seconds": dt, "method": "kxk_random"}


def adaptive_P(basis_d, d, p, seeds=(13, 41), k_schedule=None):
    P = basis_d.shape[0]
    N_next = nmon(d + 1)
    upper = min(K * P, N_next)
    if k_schedule is None:
        # Cap k at 6000: rref on 6000² is ~4 min; larger is diminishing returns
        # for Tier-2 lower bounds. Exact plateau needs rank < k.
        k_schedule = [1000, 2000, 3500, 5000, 6000]
        k_schedule = [k for k in k_schedule if k <= upper]
        if not k_schedule:
            k_schedule = [min(500, upper)]
    print("[P%d] upper=%d N=%d schedule=%s" % (
        d + 1, upper, N_next, k_schedule), flush=True)
    t0 = time.time()
    mul_table, _ = build_mul_table(d)
    print("  mul table (%.1fs)" % (time.time() - t0), flush=True)

    best_lb = 0
    certified = None
    all_probes = []
    for k in k_schedule:
        ranks = []
        metas = []
        for s in seeds:
            rk, meta = kxk_mul_rank(basis_d, d, p, k,
                                    seed=s + 10007 * d + 17 * p,
                                    mul_table=mul_table)
            ranks.append(rk)
            metas.append(meta)
        all_probes.append({"k": k, "ranks": ranks, "metas": metas})
        best_lb = max(best_lb, max(ranks))
        print("  >> k=%d ranks=%s lb=%d" % (k, ranks, best_lb), flush=True)
        if all(r < k for r in ranks):
            if ranks[0] == ranks[1]:
                certified = ranks[0]
            else:
                certified = max(ranks)
            print("  PLATEAU P_%d = %d" % (d + 1, certified), flush=True)
            break

    out = {
        "d": d + 1,
        "N": N_next,
        "upper_bound_P": upper,
        "P_lower_bound": best_lb,
        "P_certified": certified,
        "P": certified if certified is not None else best_lb,
        "P_is_lower_bound": certified is None,
        "HF": (N_next - certified) if certified is not None else None,
        "HF_upper_bound": N_next - best_lb,
        "HF_lower_bound": max(0, N_next - upper),
        "probes": [{"k": pr["k"], "ranks": pr["ranks"]} for pr in all_probes],
        "seconds": time.time() - t0,
        "method": "kxk_sketch_tier2",
        "cannot_be_full": upper < N_next,
    }
    return out


def main():
    primes = [int(a) for a in sys.argv[1:] if a.isdigit()] or [331, 661]
    summary = {}
    for p in primes:
        print("=" * 60, "\np=%d" % p, flush=True)
        basis = np.load(os.path.join(RES, "I3_echelon_p%d.npy" % p)) % p
        meta3 = json.load(open(os.path.join(RES, "plateau_p%d.json" % p)))
        print("I3 P3=%d HF3=%d" % (meta3["P3"], meta3["HF3"]), flush=True)

        r4 = adaptive_P(basis, 3, p)
        # Bounds chain for d=5,6 without I4 basis
        N5, N6 = nmon(5), nmon(6)
        P4u = r4["upper_bound_P"]
        P4 = r4["P"]
        upper5 = min(K * (r4["P_certified"] or P4u), N5)
        # If only lower bound on P4, upper5 uses upper on P4
        upper5_from_ub = min(K * P4u, N5)
        upper5_from_lb = min(K * P4, N5) if r4["P_certified"] else None

        out = {
            "p": p,
            "I3": {"P3": meta3["P3"], "HF3": meta3["HF3"],
                   "sat_ok": meta3.get("saturation_ok")},
            "d4": r4,
            "d5_bounds": {
                "N": N5,
                "upper_bound_P_from_P4upper": upper5_from_ub,
                "upper_bound_P_from_P4cert": upper5_from_lb,
                "HF_lower_bound_from_P4upper": max(0, N5 - upper5_from_ub),
            },
            "d6_bounds": {
                "N": N6,
                "upper_bound_P_from_chain": min(K * upper5_from_ub, N6),
                "HF_lower_bound": max(0, N6 - min(K * upper5_from_ub, N6)),
            },
            "HF_profile": {
                "3": meta3["HF3"],
                "4": r4.get("HF"),
                "4_HF_lower": r4["HF_lower_bound"],
                "4_HF_upper": r4["HF_upper_bound"],
            },
            "O1_empty_by_HF0": (meta3["HF3"] == 0) or (r4.get("HF") == 0),
        }
        with open(os.path.join(RES, "hf_mul_p%d.json" % p), "w") as f:
            json.dump(out, f, indent=2, default=str)
        summary[str(p)] = {
            "P3": meta3["P3"], "HF3": meta3["HF3"],
            "P4": r4["P"], "P4_cert": r4["P_certified"],
            "HF4": r4.get("HF"), "HF4_lb": r4["HF_lower_bound"],
            "HF4_ub": r4["HF_upper_bound"],
        }
        print("SUMMARY p=%d" % p, summary[str(p)], flush=True)

    with open(os.path.join(RES, "hf_mul_summary.json"), "w") as f:
        json.dump(summary, f, indent=2)
    print("DONE", summary, flush=True)


if __name__ == "__main__":
    main()
