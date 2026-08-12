#!/usr/bin/env python3
"""P3 for RANDOM K-dim subspaces of M_d vs the sealed window cell.

Question: is the landing-rank collapse (P3(35) = 1380 out of ceiling 8555)
specific to the sealed cell, or generic for any 37-dim subspace of M_35?

Method: identical invariant-side evaluation-matrix rank as
LANDING_INVARIANT_SIDE/scripts/invlib.py, but with Bcell replaced by a
random (K x ns) matrix over F_p (rank K whp).  Seeds A, C are the sealed
ones (they span M_d).  n_func columns cap the measurable rank; we only
need to distinguish "~1380" from "thousands", so a cap is acceptable and
reported honestly as a lower bound when hit.

Usage: python3 p3_random_subspace.py d p K n_func
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import common as CM


def main():
    d = int(sys.argv[1]) if len(sys.argv) > 1 else 35
    p = int(sys.argv[2]) if len(sys.argv) > 2 else 331
    K = int(sys.argv[3]) if len(sys.argv) > 3 else 37
    n_func = int(sys.argv[4]) if len(sys.argv) > 4 else 3600
    t0 = time.time()
    fr = CM.frame(p)
    A, C, Bcell = CM.load_cell(d, p)
    ns = A.shape[0]
    rng = np.random.default_rng(20260812 + 7919 * d + 13 * p + K)
    Brand = rng.integers(0, p, size=(K, ns), dtype=np.int64)

    pts = rng.integers(0, p, size=(n_func, 5), dtype=np.int64)
    for i in range(n_func):
        if not pts[i].any():
            pts[i, 0] = 1
    print("[precomp] evaluating %d seed covariants at %d points (d=%d) ..." % (ns, n_func, d), flush=True)
    t1 = time.time()
    seeds = CM.eval_seeds(fr, A, C, pts, d)  # (ns, n_func, 5)
    print("[precomp] done %.1fs" % (time.time() - t1), flush=True)

    results = {}
    for tag, B in (("random", Brand), ("cell", Bcell)):
        Mall = np.transpose(np.einsum("js,sqc->jqc", B % p, seeds) % p, (1, 2, 0)) % p
        rng2 = np.random.default_rng(1 + d + p + K)
        ech, n_tested, stable = CM.saturate_span(
            Mall, B.shape[0], p, rng2, max_c=12000, stable_window=350,
            verbose_tag="%s K=%d" % (tag, B.shape[0]))
        hit_cap = ech.rank >= n_func - 2
        results[tag] = {
            "rank": int(ech.rank),
            "saturated": bool(stable >= 350 and not hit_cap),
            "hit_func_cap": bool(hit_cap),
            "n_tested": int(n_tested),
        }
        print("[%s] K=%d rank=%d sat=%s cap=%s" % (tag, B.shape[0], ech.rank,
              results[tag]["saturated"], hit_cap), flush=True)

    out = {
        "d": d, "p": p, "K": K, "n_func": n_func, "ns": ns,
        "results": results, "seconds": time.time() - t0,
    }
    path = os.path.join(CM.RES, "p3_random_d%d_p%d_K%d.json" % (d, p, K))
    json.dump(out, open(path, "w"), indent=1)
    print("[write]", path, "total %.1fs" % out["seconds"])


if __name__ == "__main__":
    main()
