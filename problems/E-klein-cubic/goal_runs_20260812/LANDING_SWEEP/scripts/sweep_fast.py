#!/usr/bin/env python3
"""Faster sweep: cell + finisher + six-flip + light P3 + sections.

P3 policy:
  K == 0        -> empty
  K <= 50       -> dense saturated plateau
  50 < K <= 80  -> dense with more samples; report saturated flag
  K > 80        -> mode=too_large (N3 too big); skip cubic span

Usage: python3 scripts/sweep_fast.py [p] [dmin] [dmax]
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

    # resume if already complete with finisher present
    if os.path.exists(out_path):
        prev = json.load(open(out_path))
        if prev.get("finisher") and prev.get("cell_dim") is not None:
            # re-do only missing P3/sections if needed? keep unless --force
            if prev.get("six_flip") is not None and prev.get("p3") is not None:
                if prev["p3"].get("mode") != "dense" or prev["p3"].get("saturated"):
                    # for large cells too_large is acceptable final
                    if prev.get("sections") is not None:
                        print("  SKIP existing complete", out_path, flush=True)
                        return prev

    cell = I.build_layer0_cell(fr, d, dimM, p, rng, npair=100, npt=80)
    if "error" in cell:
        with open(out_path, "w") as f:
            json.dump(I.jsonable(cell), f, indent=1)
        return cell
    print(
        "  cell_dim=%d (prof=%d struct=%d) anchor=%s  [%.0fs]"
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

    fin = I.finisher_line_order(fr, A, C, NUL, d, p, npts=40)
    print(
        "  finisher ord>=%s rank=%s/%s impossible=%s"
        % (fin.get("demanded_ord"), fin.get("rank"), fin.get("cell_dim"), fin.get("impossible")),
        flush=True,
    )

    flip = I.six_flip_rank(fr, A, C, NUL, d, p)
    if flip.get("skipped"):
        print("  six-flip: skipped (even)", flush=True)
        Bpost = NUL
        post_dim = cell["cell_dim"]
    else:
        print(
            "  six-flip rank=%s dim_after=%s r1=%s amb=%s"
            % (flip.get("rank"), flip.get("dim_after"), flip.get("r1_bad"), flip.get("ambient_rank")),
            flush=True,
        )
        Bpost = I.post_flip_null(NUL, flip, p)
        post_dim = int(Bpost.shape[0])
        flip = {k: v for k, v in flip.items() if k != "universal_matrix"}
        flip["post_flip_dim"] = post_dim

    # P3: hard-cap K
    if post_dim > 80:
        p3 = {
            "d": d,
            "p": p,
            "K": post_dim,
            "N3": I.nmon3(post_dim),
            "P3": None,
            "P3_lower": None,
            "HF3": None,
            "saturated": False,
            "mode": "too_large",
            "note": "post-flip dim %d exceeds dense P3 budget" % post_dim,
        }
        print("  P3 skipped (K=%d too large)" % post_dim, flush=True)
    else:
        print("  P3 plateau K=%d ..." % post_dim, flush=True)
        p3 = I.p3_plateau(fr, A, C, Bpost, d, p, max_pts=4000, stable_window=300)
        print(
            "  P3 mode=%s P3=%s HF3=%s sat=%s"
            % (p3.get("mode"), p3.get("P3", p3.get("P3_lower")), p3.get("HF3", p3.get("HF3_upper")), p3.get("saturated")),
            flush=True,
        )

    print("  sections ...", flush=True)
    sec = I.section_battery(fr, A, C, Bpost, d, p, n_line=10, n_plane=10)
    print("  P1=%s P2=%s" % (sec.get("P1"), sec.get("P2")), flush=True)

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
    force = "--force" in sys.argv
    os.makedirs(RES, exist_ok=True)

    Pbig = DIMS.big_prime()
    dims, _ = DIMS.pathA_dimM(Pbig, dmax=max(dmax, 42))
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p)))
    rng = np.random.default_rng(20260812)

    summary = []
    for d in range(dmin, dmax + 1):
        out_path = os.path.join(RES, "d%d_p%d.json" % (d, p))
        if (not force) and os.path.exists(out_path):
            prev = json.load(open(out_path))
            # accept existing if instruments present and P3 not a hung partial dense
            ok = (
                prev.get("finisher") is not None
                and prev.get("six_flip") is not None
                and prev.get("sections") is not None
                and prev.get("p3") is not None
            )
            if ok and prev["p3"].get("mode") in ("empty", "dense", "too_large", "sketch"):
                # re-run if dense unsaturated on K<=80 and we want better — keep for now
                print("  RESUME skip d=%d (complete)" % d, flush=True)
                summary.append(_sumrow(prev))
                continue
        rec = run_degree(fr, d, dims[d], p, rng)
        summary.append(_sumrow(rec))
        with open(os.path.join(RES, "summary_p%d.json" % p), "w") as f:
            json.dump({"prime": p, "rows": summary}, f, indent=1)

    print("DONE p=%d  [%.0fs]" % (p, time.time() - T0), flush=True)
    return 0


def _sumrow(rec):
    return {
        "d": rec.get("d"),
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


if __name__ == "__main__":
    sys.exit(main())
