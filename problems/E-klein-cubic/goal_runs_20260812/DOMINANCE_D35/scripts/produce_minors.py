#!/usr/bin/env python3
"""Sample 4x4 Jacobian minors as quartics in c; saturate their span by evaluation."""
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


def saturate(p, nx=80, nc=2200, extra_x=16, seed=20260812, batch=16):
    t0 = time.time()
    print("== minor span p=%d nx=%d nc=%d" % (p, nx, nc), flush=True)
    cell = L.load_cell(p)
    fr = SL.build_frame(p, verbose=False)
    rng = np.random.default_rng(seed + p)
    A, C, B37 = cell["A"], cell["C"], cell["B37"]
    cs = rng.integers(0, p, size=(nc, 37))
    blocks = []
    curve = []
    done = 0
    rk = 0
    while done < nx:
        b = min(batch, nx - done)
        W = rng.integers(1, p, size=(b, 5))
        Jcell = L.jacobians_cell(fr, A, C, B37, W)
        for pt in range(b):
            blocks.append(L.minor_values_at_cs(Jcell[:, pt], cs, p))
        done += b
        M = np.vstack(blocks) % p
        nz = np.where(np.any(M, axis=1))[0]
        rk = L.flint_rank(M[nz], p)
        curve.append({"nx": done, "nrows": int(M.shape[0]),
                      "nnz_rows": int(nz.size), "rank": int(rk)})
        print("  nx=%d rank=%d / %d nnz (%.1fs)" % (
            done, rk, nz.size, time.time() - t0), flush=True)
        if done >= 32 and curve[-1]["rank"] < curve[-2]["rank"] + 1:
            # no growth this batch vs previous recorded; keep going to extra
            pass

    W2 = rng.integers(1, p, size=(extra_x, 5))
    J2 = L.jacobians_cell(fr, A, C, B37, W2)
    extra_rows = [L.minor_values_at_cs(J2[:, pt], cs, p) for pt in range(extra_x)]
    E = np.vstack(extra_rows) % p
    Mnz = np.vstack(blocks)
    nz = np.where(np.any(Mnz, axis=1))[0]
    Mnz = Mnz[nz]
    rk = L.flint_rank(Mnz, p)
    stacked = np.vstack([Mnz, E])
    rk2 = L.flint_rank(stacked, p)
    added = int(rk2 - rk)
    print("  extra %d x-points: rank %d (added %d)" % (extra_x, rk2, added),
          flush=True)

    # control: a random cell member should have some 4x4 minor nonzero
    # (generic rank 5) — already implied by nonzero rows
    rec = {
        "p": int(p),
        "nx": nx,
        "nc": nc,
        "extra_x": extra_x,
        "n_minor_slots": 25,
        "n_rows": int(sum(b.shape[0] for b in blocks)),
        "n_nonzero_rows": int(Mnz.shape[0]),
        "rank": int(rk),
        "rank_after_extra": int(rk2),
        "added_by_extra": added,
        "saturated": added == 0,
        "curve": curve,
        "seed": seed + p,
        "seconds": time.time() - t0,
        "note": (
            "Rank of the evaluation matrix of the 25 four-by-four minors "
            "of J_T at nx sample points, on nc random cell vectors. "
            "Equals dim of the span of those minor-quartics once nc is "
            "larger than that dimension and the x-sample has saturated."
        ),
    }
    path = os.path.join(RES, "minors_span_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(L.jsonable(rec), f, indent=2)
    print("  wrote", path, flush=True)
    return rec


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("-")]
    primes = [int(a) for a in args if int(a) >= 100] or [331]
    nx = 80
    nc = 2200
    extra = 16
    recs = {}
    for p in primes:
        recs[str(p)] = saturate(p, nx=nx, nc=nc, extra_x=extra)
    with open(os.path.join(RES, "minors_summary.json"), "w") as f:
        json.dump(L.jsonable(recs), f, indent=2)
    print("DONE", recs, flush=True)


if __name__ == "__main__":
    main()
