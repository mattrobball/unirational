#!/usr/bin/env python3
"""d=35 control: director restricted_cubics rank equals sealed P3=1380.

Usage: python3 scripts/produce_control.py [p ...]
"""
from __future__ import annotations

import os
import sys
import time

import numpy as np

import paths
import cells
import cubics
import lin
import d34lib as D34
import p2lib as P2
import slicelib as SL


def run_one(p: int) -> dict:
    t0 = time.time()
    print("=" * 60, "\n[control] d=35 p=%d" % p, flush=True)
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=False)))
    cell = cells.load_d35_cell(p)
    A, C, B = cell["A"], cell["C"], cell["Bcell"]
    assert B.shape[0] == 37

    npts = 2200
    rows, mons = cubics.restricted_cubics_director(
        fr, A, C, B, npts, p, seed=20260812
    )
    print(
        "[director] rows=%s ncols=%s rss=%.2fGB (%.1fs)"
        % (rows.shape, len(mons), lin.rss_gb(), time.time() - t0),
        flush=True,
    )
    rk = lin.rank_mod(rows, p)
    print("[director] rank=%d want 1380" % rk, flush=True)

    rows2, mons2, W = cubics.restricted_cubics(
        fr, A, C, B, npts, p, seed=20260812, deg=35
    )
    rk2 = lin.rank_mod(rows2, p)
    same = int(np.array_equal(rows % p, rows2 % p))
    print("[copy] rank=%d equal_to_director=%s" % (rk2, bool(same)), flush=True)

    rec = {
        "d": 35,
        "p": int(p),
        "K": 37,
        "npts": npts,
        "N3": len(mons),
        "P3_director": int(rk),
        "P3_copy": int(rk2),
        "rows_equal": bool(same),
        "sealed_P3": 1380,
        "matches_seal": rk == 1380 and rk2 == 1380,
        "mode": "restricted_cubics",
        "seed": 20260812,
        "seconds": time.time() - t0,
        "rss_gb": lin.rss_gb(),
    }
    path = os.path.join(paths.RES, "control_d35_p%d.json" % p)
    lin.dump(path, rec)
    print("[write]", path, rec, flush=True)
    return rec


def main():
    primes = [int(a) for a in sys.argv[1:] if a.isdigit()] or [331, 661]
    out = {}
    for p in primes:
        out[str(p)] = run_one(p)
    lin.dump(os.path.join(paths.RES, "control_summary.json"), out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
