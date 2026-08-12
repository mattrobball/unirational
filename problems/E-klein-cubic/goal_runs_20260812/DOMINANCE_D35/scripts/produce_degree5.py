#!/usr/bin/env python3
"""Degree-5 membership of linear * (4x4-minor): I5 rewrite + I5 sketches.

If every c_i * Q lies in I5 = Sym^2 * I3, then Q vanishes on Proj V, so every
nonzero landing solution has Jacobian rank <= 3.
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


def i5_rewrite_one_minor(p, seed=20260812):
    t0 = time.time()
    print("== I5 rewrite of linears*minor p=%d" % p, flush=True)
    cell = L.load_cell(p)
    I3, pivots = L.load_I3(p)
    fr = SL.build_frame(p, verbose=False)
    rng = np.random.default_rng(seed + 29 * p)
    W = rng.integers(1, p, size=(1, 5))
    Jcell = L.jacobians_cell(fr, cell["A"], cell["C"], cell["B37"], W)
    scatter = L._scatter4_table()
    L._SCATTER4 = scatter
    # one 4x4 minor (delete last row and last col)
    As = Jcell[np.ix_(range(37), [0], [0, 1, 2, 3], [0, 1, 2, 3])][:, 0]
    Q = L.expand_det4(As, p, scatter=scatter)
    print("  expanded Q nnz=%d (%.1fs)" % (
        int(np.count_nonzero(Q)), time.time() - t0), flush=True)

    print("  mul3/mul4 tables...", flush=True)
    mul3, n4 = L.build_mul_table(3)
    mul4, n5 = L.build_mul_table(4)
    assert n4 == 91390 and n5 == 749398
    print("  tables done (%.1fs)" % (time.time() - t0), flush=True)

    # unique leads of (linear * linear * I3-pivot) = quad * pivot
    used = {}
    for a in range(paths.K):
        for b in range(a, paths.K):  # quadratic monomials x_a x_b (a<=b)
            for j in range(paths.P3):
                # x_a * x_b * pivot_j
                qidx = int(mul3[b, int(pivots[j])])  # x_b * pivot -> quartic
                lead = int(mul4[a, qidx])            # x_a * that
                if lead not in used:
                    used[lead] = (a, b, j)
    print("  |I5 used leads|=%d / N5=%d (%.1fs)" % (
        len(used), n5, time.time() - t0), flush=True)

    results = []
    n_zero = 0
    for i in range(paths.K):
        # quintic x_i * Q
        Quint = np.zeros(n5, dtype=np.int64)
        nz = np.nonzero(Q)[0]
        Quint[mul4[i, nz]] = (Quint[mul4[i, nz]] + Q[nz]) % p
        wt0 = int(np.count_nonzero(Quint))
        # iterate to a fixed point on the used-lead set
        for _pass in range(6):
            hits = [ℓ for ℓ in used if int(Quint[ℓ]) % p]
            if not hits:
                break
            for lead in hits:
                a, b, j = used[lead]
                coef = int(Quint[lead]) % p
                if coef == 0:
                    continue
                row = I3[j] % p
                rnz = np.nonzero(row)[0]
                mid = mul3[b, rnz]
                slots = mul4[a, mid]
                Quint[slots] = (Quint[slots] - coef * row[rnz]) % p
        wt = int(np.count_nonzero(Quint))
        zero = wt == 0
        if zero:
            n_zero += 1
        results.append({"var": i, "wt_before": wt0, "wt_rem": wt, "zero": zero})
        print("  c_%d * Q  wt0=%d wtR=%d zero=%s" % (i, wt0, wt, zero),
              flush=True)
        del Quint

    rec = {
        "p": int(p),
        "minor": "delete row 4 col 4 at 1 random x",
        "n_linears": paths.K,
        "n_rewrite_zero": n_zero,
        "all_linears_times_Q_in_I5": n_zero == paths.K,
        "n_used_I5_leads": len(used),
        "N5": n5,
        "P5_ub": min(n5, 703 * 1380),
        "results": results,
        "seconds": time.time() - t0,
        "method": "I5 echelon-style rewrite (quad * I3-pivot leads); sufficient",
    }
    path = os.path.join(RES, "i5_rewrite_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(L.jsonable(rec), f, indent=2)
    print("  I5 rewrite zero %d/37" % n_zero, flush=True)
    return rec


def i5_sketches(p, ks=(2000, 4000), seeds=(13, 41)):
    """k x k sketch of I5 = quad * I3, flint rank. Lower bound on P5."""
    t0 = time.time()
    print("== I5 sketches p=%d" % p, flush=True)
    I3, _ = L.load_I3(p)
    mul3, n4 = L.build_mul_table(3)
    mul4, n5 = L.build_mul_table(4)
    probes = []
    best = 0
    for k in ks:
        ranks = []
        for s in seeds:
            rng = np.random.default_rng(s + 4242 * 5 + 19 * p)
            coords = rng.choice(n5, size=k, replace=False)
            inv = np.full(n5, -1, dtype=np.int32)
            inv[coords] = np.arange(k, dtype=np.int32)
            Combo = rng.integers(0, p, size=(k, paths.P3), dtype=np.int64)
            F = (Combo @ (I3 % p)) % p  # (k, N3)
            # random quadratic = product of two linears
            A = rng.integers(0, p, size=(k, paths.K), dtype=np.int64)
            B = rng.integers(0, p, size=(k, paths.K), dtype=np.int64)
            Mat = np.zeros((k, k), dtype=np.int64)
            t1 = time.time()
            # quad * cubic: for each vars u,v: A_u B_v * (x_u x_v F)
            # (x_u x_v mon3) lands at mul4[u, mul3[v, j]]
            for u in range(paths.K):
                Au = A[:, u] % p
                for v in range(paths.K):
                    Bv = B[:, v] % p
                    scale = (Au * Bv) % p  # (k,)
                    if not np.any(scale):
                        continue
                    mid = mul3[v]  # (N3,) quartic idx of x_v * mon3
                    dest = mul4[u, mid]  # (N3,) quintic idx
                    slots = inv[dest]
                    active = np.where(slots >= 0)[0]
                    if not active.size:
                        continue
                    sl = slots[active]
                    for j, slot in zip(active, sl):
                        Mat[:, slot] = (Mat[:, slot] + scale * F[:, j]) % p
            rk = L.flint_rank(Mat, p)
            ranks.append(int(rk))
            print("  I5 k=%d seed=%d rank=%d (%.1fs)" % (
                k, s, rk, time.time() - t1), flush=True)
            del Mat
        probes.append({"k": k, "ranks": ranks})
        best = max(best, max(ranks))
        if all(r < k for r in ranks):
            break
    rec = {
        "p": int(p),
        "P5_lower": int(best),
        "P5_upper": min(749398, 703 * 1380),
        "N5": 749398,
        "probes": probes,
        "seconds": time.time() - t0,
        "method": "kxk random (lin*lin*I3) on k random quintic monomials",
    }
    path = os.path.join(RES, "i5_sketch_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(L.jsonable(rec), f, indent=2)
    return rec


def main():
    primes = [int(a) for a in sys.argv[1:] if a.isdigit()] or [331]
    for p in primes:
        if "--no-rewrite" not in sys.argv:
            i5_rewrite_one_minor(p)
        if "--sketch" in sys.argv:
            i5_sketches(p)


if __name__ == "__main__":
    main()
