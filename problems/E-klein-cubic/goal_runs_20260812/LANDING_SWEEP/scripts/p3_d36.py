#!/usr/bin/env python3
"""Push P3 saturation at d=36 (K=63) with denser sampling; both primes."""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import paths
import instruments as I
import produce_dims34 as DIMS
import d34lib as D34
import p2lib as P2
import slicelib as SL

RES = paths.RES


def main():
    primes = [int(a) for a in sys.argv[1:]] or [331, 661]
    d = 36
    Pbig = DIMS.big_prime()
    dims, _ = DIMS.pathA_dimM(Pbig, dmax=42)
    rng = np.random.default_rng(20260812)
    for p in primes:
        t0 = time.time()
        print("== P3 d=36 p=%d" % p, flush=True)
        fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p)))
        cell = I.build_layer0_cell(fr, d, dims[d], p, rng, npair=100, npt=80)
        A, C, NUL = cell["A"], cell["C"], cell["NUL"]
        assert cell["cell_dim"] == 63, cell["cell_dim"]
        p3 = I.p3_plateau(fr, A, C, NUL, d, p, max_pts=6000, stable_window=400)
        print("P3 result:", p3, flush=True)
        # merge into existing json
        path = os.path.join(RES, "d%d_p%d.json" % (d, p))
        rec = json.load(open(path))
        rec["p3"] = p3
        rec["p3_rerun_seconds"] = time.time() - t0
        with open(path, "w") as f:
            json.dump(I.jsonable(rec), f, indent=1, sort_keys=True)
        print("updated", path, "in %.0fs" % (time.time() - t0), flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
