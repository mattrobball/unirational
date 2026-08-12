#!/usr/bin/env python3
"""Low-memory batched P3: build the evaluation matrix, one rank, extra batches.

Peak storage is the (n_c x n_func) matrix (int32) plus a working int64 copy
during rank. No incremental Echelon vstack.
"""
from __future__ import annotations

import time

import numpy as np

import lin


def eval_F_rows(Mall, cs, p):
    """Mall (n_func, 5, K), cs (b, K) -> (b, n_func) of F(T_c(y_t))."""
    Tv = np.einsum("tck,bk->btc", Mall, cs, dtype=np.int64) % p
    return lin.klein_F_batch(Tv, p)


def p3_batch(fr, eval_T, A, C, B, d, p, n_func, n_c, extra_size=600, extra_batches=2, seed=20260812):
    t0 = time.time()
    K = int(B.shape[0])
    rng = np.random.default_rng(seed + 17 * d + p)
    ys = rng.integers(0, p, size=(n_func, 5), dtype=np.int64)
    for i in range(n_func):
        if not ys[i].any():
            ys[i, 0] = 1
    print(
        "[batch-P3] d=%d p=%d K=%d n_func=%d n_c=%d rss=%.2fGB"
        % (d, p, K, n_func, n_c, lin.rss_gb()),
        flush=True,
    )
    t1 = time.time()
    Mall = eval_T(fr, A, C, B, ys, d)  # (n_func, 5, K)
    print(
        "[batch-P3] T-precomp %.1fs shape=%s rss=%.2fGB"
        % (time.time() - t1, Mall.shape, lin.rss_gb()),
        flush=True,
    )
    rows = np.zeros((n_c, n_func), dtype=np.int32)
    bs = 48
    for s in range(0, n_c, bs):
        e = min(n_c, s + bs)
        cs = rng.integers(0, p, size=(e - s, K), dtype=np.int64)
        rows[s:e] = eval_F_rows(Mall, cs, p)
        if e % 800 == 0 or e == n_c:
            print("  filled %d/%d rss=%.2fGB" % (e, n_c, lin.rss_gb()), flush=True)
    print("[batch-P3] ranking %s ..." % (rows.shape,), flush=True)
    t2 = time.time()
    rk = lin.rank_mod(rows, p)
    print(
        "[batch-P3] rank=%d (%.1fs) rss=%.2fGB" % (rk, time.time() - t2, lin.rss_gb()),
        flush=True,
    )
    extras = []
    for bi in range(extra_batches):
        brng = np.random.default_rng(seed + 10007 * (bi + 1) + 13 * p + d)
        extra = np.zeros((extra_size, n_func), dtype=np.int32)
        for s in range(0, extra_size, bs):
            e = min(extra_size, s + bs)
            cs = brng.integers(0, p, size=(e - s, K), dtype=np.int64)
            extra[s:e] = eval_F_rows(Mall, cs, p)
        stacked = np.vstack([rows, extra])
        rk2 = lin.rank_mod(stacked, p)
        extras.append({
            "batch": bi,
            "size": extra_size,
            "rank_before": int(rk),
            "rank_after": int(rk2),
            "added": int(rk2 - rk),
        })
        print("  extra %d: +%d -> %d" % (bi, rk2 - rk, rk2), flush=True)
        rk = rk2
        rows = stacked
    hit_ceil = rk >= n_func - 1
    sat = all(e["added"] == 0 for e in extras) and not hit_ceil
    N3 = lin.nmon3(K)
    Iceil = None
    try:
        import paths
        Iceil = paths.I_3D.get(d)
    except Exception:
        pass
    return {
        "d": d,
        "p": int(p),
        "K": K,
        "N3": N3,
        "I_3d": Iceil,
        "P3": int(rk),
        "P3_is_lower_bound": not sat,
        "HF3": N3 - int(rk),
        "deficit_vs_I": (Iceil - rk) if Iceil is not None else None,
        "ratio_P3_over_I": (rk / Iceil) if Iceil else None,
        "n_func": n_func,
        "npts_c_tested": n_c + extra_size * extra_batches,
        "extra_batches": extras,
        "extra_added_total": sum(e["added"] for e in extras),
        "saturated": sat,
        "mode": "inv_eval_matrix_batch",
        "hit_func_ceiling": hit_ceil,
        "seconds": time.time() - t0,
        "rss_gb": lin.rss_gb(),
    }
