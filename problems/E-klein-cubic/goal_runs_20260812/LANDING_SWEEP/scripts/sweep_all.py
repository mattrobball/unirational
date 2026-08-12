#!/usr/bin/env python3
"""Run endgame instruments at every degree d in 34..42, primes 331 and 661.

Usage:
  python3 scripts/sweep_all.py [p] [dmin] [dmax]
  python3 scripts/sweep_all.py 331 34 42
  python3 scripts/sweep_all.py 331 35 35   # single degree
"""
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
T0 = time.time()


def run_degree(fr, d, dimM, p, rng):
    print("=" * 70, flush=True)
    print("DEGREE d=%d  p=%d  dimM=%d  [%.0fs]" % (d, p, dimM, time.time() - T0), flush=True)
    out_path = os.path.join(RES, "d%d_p%d.json" % (d, p))

    # 1. Layer-0 cell
    cell = I.build_layer0_cell(fr, d, dimM, p, rng, npair=100, npt=80)
    if "error" in cell:
        print("  ERROR:", cell["error"], flush=True)
        with open(out_path, "w") as f:
            json.dump(I.jsonable(cell), f, indent=1)
        return cell
    print(
        "  cell_dim=%d (profile_only=%d struct_only=%d) anchor=%s  [%.0fs]"
        % (
            cell["cell_dim"],
            cell["dim_profile_only"],
            cell["dim_structure_only"],
            paths.ANCHOR_CELL.get(d),
            time.time() - T0,
        ),
        flush=True,
    )
    A, C, NUL = cell["A"], cell["C"], cell["NUL"]

    # 2. Finisher
    fin = I.finisher_line_order(fr, A, C, NUL, d, p, npts=40)
    print(
        "  finisher ord>=%s rank=%s/%s dim_after=%s impossible=%s sat=%s"
        % (
            fin.get("demanded_ord"),
            fin.get("rank"),
            fin.get("cell_dim"),
            fin.get("dim_after"),
            fin.get("impossible"),
            fin.get("saturation_ok"),
        ),
        flush=True,
    )

    # 3. Six-flip (odd d)
    flip = I.six_flip_rank(fr, A, C, NUL, d, p)
    if flip.get("skipped"):
        print("  six-flip: skipped (even d)", flush=True)
        Bpost = NUL
        post_dim = cell["cell_dim"]
    else:
        print(
            "  six-flip rank=%s dim_after=%s r1_bad=%s amb=%s"
            % (
                flip.get("rank"),
                flip.get("dim_after"),
                flip.get("r1_bad"),
                flip.get("ambient_rank"),
            ),
            flush=True,
        )
        Bpost = I.post_flip_null(NUL, flip, p)
        post_dim = int(Bpost.shape[0])
        # drop heavy matrix from JSON
        flip = {k: v for k, v in flip.items() if k != "universal_matrix"}
        flip["post_flip_dim"] = post_dim

    # 4. P3 / HF3 on post-flip cell
    print("  P3 plateau on K=%d ..." % post_dim, flush=True)
    p3 = I.p3_plateau(fr, A, C, Bpost, d, p)
    print(
        "  P3 mode=%s P3=%s HF3=%s sat=%s  [%.0fs]"
        % (
            p3.get("mode"),
            p3.get("P3", p3.get("P3_lower")),
            p3.get("HF3", p3.get("HF3_upper")),
            p3.get("saturated"),
            time.time() - T0,
        ),
        flush=True,
    )

    # 5. Section battery (smaller)
    print("  sections (10 P1 + 10 P2) ...", flush=True)
    sec = I.section_battery(fr, A, C, Bpost, d, p, n_line=10, n_plane=10)
    print(
        "  P1: %s  P2: %s"
        % (sec.get("P1"), sec.get("P2")),
        flush=True,
    )

    rec = {
        "d": d,
        "p": p,
        "dim_M": dimM,
        "cell_dim": cell["cell_dim"],
        "dim_profile_only": cell["dim_profile_only"],
        "dim_structure_only": cell["dim_structure_only"],
        "anchor_cell": paths.ANCHOR_CELL.get(d),
        "rules_fired": cell["rules_fired"],
        "finisher": fin,
        "six_flip": flip,
        "post_flip_dim": post_dim,
        "p3": p3,
        "sections": sec,
        "seconds_total": time.time() - T0,
    }
    with open(out_path, "w") as f:
        json.dump(I.jsonable(rec), f, indent=1, sort_keys=True)
    print("  wrote", out_path, flush=True)
    return rec


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    dmin = int(sys.argv[2]) if len(sys.argv) > 2 else 34
    dmax = int(sys.argv[3]) if len(sys.argv) > 3 else 42
    os.makedirs(RES, exist_ok=True)

    Pbig = DIMS.big_prime()
    dims, _ = DIMS.pathA_dimM(Pbig, dmax=max(dmax, 42))
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p)))
    rng = np.random.default_rng(20260812)

    summary = []
    for d in range(dmin, dmax + 1):
        rec = run_degree(fr, d, dims[d], p, rng)
        summary.append(
            {
                "d": d,
                "cell_dim": rec.get("cell_dim"),
                "finisher_impossible": (rec.get("finisher") or {}).get("impossible"),
                "finisher_rank": (rec.get("finisher") or {}).get("rank"),
                "finisher_demand": (rec.get("finisher") or {}).get("demanded_ord"),
                "flip_rank": (rec.get("six_flip") or {}).get("rank"),
                "post_flip_dim": rec.get("post_flip_dim"),
                "P3": (rec.get("p3") or {}).get("P3"),
                "P3_lower": (rec.get("p3") or {}).get("P3_lower"),
                "HF3": (rec.get("p3") or {}).get("HF3"),
                "p3_mode": (rec.get("p3") or {}).get("mode"),
                "P1": (rec.get("sections") or {}).get("P1"),
                "P2": (rec.get("sections") or {}).get("P2"),
            }
        )
        with open(os.path.join(RES, "summary_p%d.json" % p), "w") as f:
            json.dump({"prime": p, "rows": summary}, f, indent=1)

    print("DONE p=%d  [%.0fs]" % (p, time.time() - T0), flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
