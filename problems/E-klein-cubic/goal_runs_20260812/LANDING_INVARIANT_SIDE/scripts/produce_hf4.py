#!/usr/bin/env python3
"""Push HF(4) at d=35 via k×k sketched multiply of the sealed I3 basis.

Reuses D35_LANDING I3_echelon_p{p}.npy.  Two independent seeds; both primes.
Goal: exact P4 (rank < k plateau) or certified two-sided bounds.

HF4_lb = N4 - min(K*P3, N4) = 91390 - 51060 = 40330 is exact domain bound.
P4_lb from sketches; P4_ub = K*P3 = 51060.
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

K = 37
P3 = 1380
N3 = 9139
N4 = 91390  # binom(40,4)
P4_UB = K * P3  # 51060
HF4_LB_DOMAIN = N4 - P4_UB  # 40330


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
        below = A[r + 1 :, c]
        kk = np.nonzero(below)[0]
        if kk.size:
            A[r + 1 + kk] = (A[r + 1 + kk] - np.outer(below[kk], A[r])) % p
        r += 1
        if r == rows:
            break
    return r


def kxk_mul_rank(basis_d, d, p, k, seed, mul_table=None):
    """Rank of k random elements of I_{d+1}, each on k random coords."""
    p = int(p)
    P, N_d = basis_d.shape
    if mul_table is None:
        mul_table, N_next = build_mul_table(d)
    else:
        N_next = nmon(d + 1)
    rng = np.random.default_rng(seed)
    k = min(k, N_next, P4_UB)
    coords = rng.choice(N_next, size=k, replace=False)
    inv = np.full(N_next, -1, dtype=np.int32)
    inv[coords] = np.arange(k, dtype=np.int32)
    land = inv[mul_table]  # (K, N_d)

    t0 = time.time()
    Combo = rng.integers(0, p, size=(k, P), dtype=np.int64)
    F = (Combo @ (basis_d % p)) % p
    Lin = rng.integers(0, p, size=(k, K), dtype=np.int64)
    Mat = np.zeros((k, k), dtype=np.int64)
    for i in range(K):
        slots = land[i]
        active = np.where(slots >= 0)[0]
        if not active.size:
            continue
        sl = slots[active]
        li = Lin[:, i] % p
        for j, slot in zip(active, sl):
            col = (li * F[:, j]) % p
            Mat[:, slot] = (Mat[:, slot] + col) % p
    rk = rref_rank_fast(Mat, p)
    dt = time.time() - t0
    print("  k=%d seed=%d rank=%d (%.1fs)" % (k, seed, rk, dt), flush=True)
    return int(rk), {"k": k, "seed": seed, "seconds": dt}


def main():
    primes = [int(a) for a in sys.argv[1:] if a.isdigit()] or [331, 661]
    # Sealed k=6000 two-seed schedule (D35_LANDING Tier-2). Larger k is O(k^3)
    # and does not yield a rank<k plateau within packet budget; exact P4 deferred.
    k_schedule = [6000]
    seeds = (13, 41)
    summary = {}

    for p in primes:
        print("=" * 60, "\np=%d" % p, flush=True)
        path = os.path.join(paths.D35L_RES, "I3_echelon_p%d.npy" % p)
        if not os.path.exists(path):
            print("MISSING", path, "— regenerate D35_LANDING I3 first", flush=True)
            summary[str(p)] = {"error": "missing I3 basis"}
            continue
        basis = np.load(path) % p
        assert basis.shape[0] == P3, basis.shape
        print("I3 basis shape", basis.shape, flush=True)

        t0 = time.time()
        print("[mul table d=3]", flush=True)
        mul_table, N_next = build_mul_table(3)
        assert N_next == N4
        print("  done (%.1fs)" % (time.time() - t0), flush=True)

        best_lb = 0
        certified = None
        probes = []
        for k in k_schedule:
            if k > P4_UB:
                break
            ranks = []
            for s in seeds:
                rk, meta = kxk_mul_rank(
                    basis, 3, p, k,
                    seed=s + 10007 * 3 + 17 * p,
                    mul_table=mul_table,
                )
                ranks.append(rk)
            probes.append({"k": k, "ranks": ranks})
            best_lb = max(best_lb, max(ranks))
            print("  >> k=%d ranks=%s lb=%d" % (k, ranks, best_lb), flush=True)
            if all(r < k for r in ranks) and ranks[0] == ranks[1]:
                certified = ranks[0]
                print("  PLATEAU P4 = %d" % certified, flush=True)
                break

        P4 = certified if certified is not None else best_lb
        out = {
            "p": p,
            "K": K,
            "P3": P3,
            "N4": N4,
            "P4_upper": P4_UB,
            "P4_lower": best_lb,
            "P4_certified": certified,
            "P4": P4,
            "P4_is_lower_bound": certified is None,
            "HF4_lower": HF4_LB_DOMAIN,  # domain: cannot fill Sym^4
            "HF4_upper": N4 - best_lb,
            "HF4_exact": (N4 - certified) if certified is not None else None,
            "probes": probes,
            "k_schedule": k_schedule,
            "seeds": list(seeds),
            "seconds": time.time() - t0,
            "method": "kxk_sketch_two_seeds",
            "note": (
                "HF4_lower=40330 is characteristic-free (37*1380 < binom(40,4)). "
                "Sketch ranks are Tier-2 modular lower bounds on P4."
            ),
        }
        with open(os.path.join(paths.RES, "hf4_p%d.json" % p), "w") as f:
            json.dump(out, f, indent=2)
        summary[str(p)] = {
            "P4_lower": best_lb,
            "P4_certified": certified,
            "HF4_lower": HF4_LB_DOMAIN,
            "HF4_upper": N4 - best_lb,
            "HF4_exact": out["HF4_exact"],
            "seconds": out["seconds"],
        }
        print("SUMMARY p=%d" % p, summary[str(p)], flush=True)

    with open(os.path.join(paths.RES, "hf4_summary.json"), "w") as f:
        json.dump(summary, f, indent=2)
    print("DONE", summary, flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
