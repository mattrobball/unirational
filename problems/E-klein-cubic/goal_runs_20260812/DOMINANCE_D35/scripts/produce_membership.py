#!/usr/bin/env python3
"""I4 membership of the 4x4-minor quartics: rewrite + P4 sketches.

Remainder 0 under the I3-echelon rewrite is a sufficient certificate that
the quartic is in I4. A k-sketch plateau (rank < k, two seeds) certifies
P4 and then a stacked sketch decides membership.
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import paths
import domlib as L
import slicelib as SL

RES = paths.RES


def expand_and_rewrite(p, nx=2, seed=20260812):
    t0 = time.time()
    print("== expand+rewrite p=%d" % p, flush=True)
    cell = L.load_cell(p)
    I3, pivots = L.load_I3(p)
    assert pivots is not None
    fr = SL.build_frame(p, verbose=False)
    rng = np.random.default_rng(seed + 17 * p)
    W = rng.integers(1, p, size=(nx, 5))
    print("  jacobians...", flush=True)
    Jcell = L.jacobians_cell(fr, cell["A"], cell["C"], cell["B37"], W)
    print("  mul table...", flush=True)
    mul3, n4 = L.build_mul_table(3)
    specs = L.minor_subsets()
    print("  scatter4 table...", flush=True)
    scatter = L._scatter4_table()
    L._SCATTER4 = scatter

    rems = []
    n_zero = 0
    weights = []
    for pt in range(nx):
        for s, (_sr, _sc, rr, cc) in enumerate(specs):
            As = Jcell[np.ix_(range(37), [pt], rr, cc)][:, 0]
            Q = L.expand_det4(As, p, scatter=scatter)
            wt0 = int(np.count_nonzero(Q))
            R, used = L.rewrite_I4(Q, I3, pivots, mul3, p)
            wt = int(np.count_nonzero(R))
            zero = wt == 0
            if zero:
                n_zero += 1
            weights.append({"pt": pt, "minor": s, "wt_Q": wt0, "wt_rem": wt,
                            "zero": zero})
            rems.append(R)
            print("  pt %d minor %02d wtQ=%d wtR=%d zero=%s" % (
                pt, s, wt0, wt, zero), flush=True)
    rem_mat = np.vstack(rems) % p
    # drop zeros
    nz = [i for i, w in enumerate(weights) if w["wt_rem"] > 0]
    if nz:
        rk_rem = L.flint_rank(rem_mat[nz], p)
    else:
        rk_rem = 0
    rec = {
        "p": int(p),
        "nx": nx,
        "n_minors": 25,
        "n_tested": len(weights),
        "n_rewrite_zero": n_zero,
        "all_in_I4_by_rewrite": n_zero == len(weights),
        "remainder_rank": int(rk_rem),
        "n_used_leads": len(used),
        "P4_ub": 51060,
        "lead_deficit": 51060 - len(used),
        "weights": weights,
        "seconds": time.time() - t0,
        "method": "I3-echelon product rewrite (sufficient for membership)",
    }
    path = os.path.join(RES, "i4_rewrite_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(L.jsonable(rec), f, indent=2)
    print("  rewrite zero %d/%d rem_rank=%d |S|=%d" % (
        n_zero, len(weights), rk_rem, len(used)), flush=True)
    return rec


def p4_sketches(p, ks=(8000, 18000), seeds=(13, 41)):
    t0 = time.time()
    print("== P4 sketches p=%d" % p, flush=True)
    I3, _ = L.load_I3(p)
    mul3, n4 = L.build_mul_table(3)
    assert n4 == 91390
    probes = []
    best = 0
    certified = None
    for k in ks:
        ranks = []
        for s in seeds:
            # reuse D35_LANDING kxk construction
            rng = np.random.default_rng(s + 10007 * 3 + 17 * p)
            coords = rng.choice(n4, size=k, replace=False)
            inv = np.full(n4, -1, dtype=np.int32)
            inv[coords] = np.arange(k, dtype=np.int32)
            land = inv[mul3]  # (37, N3)
            Combo = rng.integers(0, p, size=(k, paths.P3), dtype=np.int64)
            F = (Combo @ (I3 % p)) % p
            Lin = rng.integers(0, p, size=(k, paths.K), dtype=np.int64)
            Mat = np.zeros((k, k), dtype=np.int64)
            t1 = time.time()
            for i in range(paths.K):
                slots = land[i]
                active = np.where(slots >= 0)[0]
                if not active.size:
                    continue
                li = Lin[:, i] % p
                sl = slots[active]
                for j, slot in zip(active, sl):
                    Mat[:, slot] = (Mat[:, slot] + li * F[:, j]) % p
            rk = L.flint_rank(Mat, p)
            ranks.append(int(rk))
            print("  k=%d seed=%d rank=%d (%.1fs)" % (
                k, s, rk, time.time() - t1), flush=True)
            del Mat
        probes.append({"k": k, "ranks": ranks})
        best = max(best, max(ranks))
        if all(r < k for r in ranks) and ranks[0] == ranks[1]:
            certified = ranks[0]
            print("  PLATEAU P4=%d" % certified, flush=True)
            break
    rec = {
        "p": int(p),
        "P4_lower": int(best),
        "P4_certified": certified,
        "P4_upper": 51060,
        "P4_is_lower_bound": certified is None,
        "HF4_lower": 40330,
        "HF4_upper": 91390 - best,
        "probes": probes,
        "seconds": time.time() - t0,
        "method": "kxk random I4 elements on k random monomials; flint rank",
    }
    path = os.path.join(RES, "i4_sketch_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(L.jsonable(rec), f, indent=2)
    print("  P4 >= %s <= 51060" % best, flush=True)
    return rec


def main():
    primes = [int(a) for a in sys.argv[1:] if a.isdigit()] or [331]
    do_rewrite = "--no-rewrite" not in sys.argv
    do_sketch = "--no-sketch" not in sys.argv
    for p in primes:
        if do_rewrite:
            expand_and_rewrite(p, nx=1)
        if do_sketch:
            p4_sketches(p)


if __name__ == "__main__":
    main()
