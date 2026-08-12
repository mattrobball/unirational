#!/usr/bin/env python3
"""Invariant-side P3 for degrees 35 (control), 36, 37, 38 at primes 331 and 661.

Usage:
  python3 produce_p3.py              # all degrees, both primes
  python3 produce_p3.py 35           # d=35 control only
  python3 produce_p3.py 36 331       # single (d,p)
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import paths
import invlib as L
import slicelib as SL
import d34lib as D34
import p2lib as P2
import produce_dims34 as DIMS


def run_one(d: int, p: int) -> dict:
    t0 = time.time()
    print("=" * 60, "\n[produce_p3] d=%d p=%d" % (d, p), flush=True)
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=True)))
    rng = np.random.default_rng(20260812 + d)

    if d == 35:
        cell = L.load_d35_cell(p)
        A, C, B = cell["A"], cell["C"], cell["Bcell"]
        assert cell["K"] == 37
    else:
        Pbig = DIMS.big_prime()
        dims, _ = DIMS.pathA_dimM(Pbig, dmax=max(42, d))
        dimM = int(dims[d])
        built = L.build_post_flip_cell(fr, d, dimM, p, rng)
        if "error" in built:
            return {"d": d, "p": p, "error": built["error"]}
        A, C, B = built["A"], built["C"], built["Bcell"]
        expect_K = paths.POST_FLIP_K.get(d)
        print(
            "[cell] K=%d cell_dim=%d expect_post=%s"
            % (built["K"], built["cell_dim"], expect_K),
            flush=True,
        )
        if expect_K is not None and built["K"] != expect_K:
            print(
                "WARNING: post-flip K mismatch got %d want %d"
                % (built["K"], expect_K),
                flush=True,
            )

    # Persist Bcell lightly for HF/kernel reuse (gitignore *.npy)
    np.save(os.path.join(paths.RES, "Bcell_d%d_p%d.npy" % (d, p)), B)
    np.save(os.path.join(paths.RES, "A_d%d_p%d.npy" % (d, p)), A)
    np.save(os.path.join(paths.RES, "C_d%d_p%d.npy" % (d, p)), C)

    rec = L.inv_side_p3(fr, A, C, B, d, p)
    rec["cell_source"] = "PAIR_ATTACK" if d == 35 else "layer0+flip"
    rec["seconds_total"] = time.time() - t0
    path = os.path.join(paths.RES, "p3_inv_d%d_p%d.json" % (d, p))
    with open(path, "w") as f:
        json.dump(L.jsonable(rec), f, indent=1, sort_keys=True)
    print("[write]", path, "P3=%s sat=%s" % (rec.get("P3"), rec.get("saturated")),
          flush=True)
    return rec


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("-")]
    degrees = [35, 36, 37, 38]
    primes = list(paths.PRIMES)
    if args:
        nums = [int(a) for a in args]
        degs = [n for n in nums if n < 100]
        prs = [n for n in nums if n >= 100]
        if degs:
            degrees = degs
        if prs:
            primes = prs

    summary = {}
    for d in degrees:
        summary[str(d)] = {}
        for p in primes:
            rec = run_one(d, p)
            summary[str(d)][str(p)] = {
                "P3": rec.get("P3"),
                "HF3": rec.get("HF3"),
                "K": rec.get("K"),
                "N3": rec.get("N3"),
                "I_3d": rec.get("I_3d"),
                "saturated": rec.get("saturated"),
                "P3_is_lower_bound": rec.get("P3_is_lower_bound"),
                "deficit_vs_I": rec.get("deficit_vs_I"),
                "seconds": rec.get("seconds_total") or rec.get("seconds"),
                "error": rec.get("error"),
            }
    out = os.path.join(paths.RES, "p3_inv_summary.json")
    with open(out, "w") as f:
        json.dump(summary, f, indent=2)
    print("SUMMARY", json.dumps(summary, indent=2), flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
