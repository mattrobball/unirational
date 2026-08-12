#!/usr/bin/env python3
"""Replayable verifier for LANDING_SWEEP.

Checks:
  A  degree table presence, two-prime agreement, anchor cell dims, d=34 control
  B  finisher impossibility pattern + six-flip ranks on stored JSON
  C  d=35 calibration against sealed D35_LANDING / PAIR_ATTACK numbers
  D  section origin-only bookkeeping
  E  live mini-replay: cell dim at d=34 and d=35 at one prime (optional heavy)

Usage: python3 verifier.py [--live]
"""
from __future__ import annotations

import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
SCR = os.path.join(HERE, "scripts")
sys.path.insert(0, SCR)
import paths  # noqa: E402

T0 = time.time()
fails = []
checks = []


def check(name, cond, detail=""):
    checks.append(name)
    if cond:
        print("  OK  %s %s" % (name, detail))
    else:
        print("  FAIL %s %s" % (name, detail))
        fails.append(name)


def main():
    live = "--live" in sys.argv
    print("LANDING_SWEEP verifier", flush=True)

    # ---- A table ----
    print("[A] degree table + anchors")
    tab_path = os.path.join(RES, "degree_table.json")
    if not os.path.exists(tab_path):
        # try compile
        import compile_table

        compile_table.main()
    tab = json.load(open(tab_path))
    check("A1 table has 9 degrees", len(tab["rows"]) == 9)
    by_d = {r["d"]: r for r in tab["rows"]}
    for d, anc in paths.ANCHOR_CELL.items():
        r = by_d[d]
        check(
            "A2 d=%d cell matches anchor %d" % (d, anc),
            r["p331"]["cell"] == anc == r["p661"]["cell"],
            "got %s/%s" % (r["p331"]["cell"], r["p661"]["cell"]),
        )
        check(
            "A3 d=%d two-prime agree core" % d,
            r["agree_all"],
            str(r["agree"]),
        )
    check("A4 d=34 control cell=0", by_d[34]["p331"]["cell"] == 0)

    # ---- B instruments ----
    print("[B] finisher + six-flip pattern")
    # impossibility at 34 (vacuous), 35, 36 only
    for d in range(34, 43):
        r = by_d[d]["p331"]
        if d in (34, 35, 36):
            check("B1 d=%d finisher impossible" % d, r["fin_imp"] is True)
        else:
            check("B2 d=%d finisher NOT full-rank kill" % d, r["fin_imp"] is False)
        if d % 2 == 1 and d >= 35:
            check("B3 d=%d six-flip rank=2" % d, r["flip_rank"] == 2)
            check(
                "B4 d=%d post = cell-2" % d,
                r["post"] == r["cell"] - 2,
                "post=%s cell=%s" % (r["post"], r["cell"]),
            )
        if d % 2 == 0 and d >= 34:
            check("B5 d=%d six-flip skipped" % d, r["flip_skip"] is True)
        if d % 2 == 0 and d >= 36:
            check("B6 d=%d fin demand=3" % d, r["fin_demand"] == 3)
        if d % 2 == 1 and d >= 35:
            check("B7 d=%d fin demand=2" % d, r["fin_demand"] == 2)

    # sealed finisher ranks (both primes already agreed)
    expected_fin = {
        35: 39,
        36: 63,
        37: 54,
        38: 114,
        39: 57,
        40: 122,
        41: 61,
        42: 130,
    }
    for d, rk in expected_fin.items():
        check(
            "B8 d=%d finisher rank=%d" % (d, rk),
            by_d[d]["p331"]["fin_rank"] == rk,
            "got %s" % by_d[d]["p331"]["fin_rank"],
        )

    # ---- C d=35 calibration ----
    print("[C] d=35 sealed calibration")
    r35 = by_d[35]["p331"]
    check("C1 cell=39", r35["cell"] == 39)
    check("C2 flip=2 post=37", r35["flip_rank"] == 2 and r35["post"] == 37)
    check("C3 P3=1380", r35["P3"] == 1380)
    check("C4 HF3=7759", r35["HF3"] == 7759)
    check("C5 P3 saturated", r35["p3sat"] is True)
    check(
        "C6 sections origin-only",
        r35["P1_oo"] == r35["P1_n"] == 10 and r35["P2_oo"] == r35["P2_n"] == 10,
    )
    # cross-prime P3
    check("C7 P3 agree 661", by_d[35]["p661"]["P3"] == 1380)

    # ---- D sections ----
    print("[D] sections origin-only across alive degrees")
    for d in range(35, 43):
        r = by_d[d]["p331"]
        check(
            "D1 d=%d P1 origin-only" % d,
            r["P1_n"] == 10 and r["P1_oo"] == 10,
            "oo=%s n=%s" % (r["P1_oo"], r["P1_n"]),
        )
        check(
            "D2 d=%d P2 origin-only" % d,
            r["P2_n"] == 10 and r["P2_oo"] == 10,
            "oo=%s n=%s" % (r["P2_oo"], r["P2_n"]),
        )

    # ---- E optional live ----
    if live:
        print("[E] live mini-replay d=34,35 p=331")
        import instruments as I
        import produce_dims34 as DIMS
        import d34lib as D34
        import p2lib as P2
        import slicelib as SL
        import numpy as np

        p = 331
        Pbig = DIMS.big_prime()
        dims, _ = DIMS.pathA_dimM(Pbig, dmax=42)
        fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p)))
        rng = np.random.default_rng(20260812)
        for d, want in ((34, 0), (35, 39)):
            cell = I.build_layer0_cell(fr, d, dims[d], p, rng, npair=80, npt=60)
            check(
                "E1 live d=%d cell=%d" % (d, want),
                cell.get("cell_dim") == want,
                "got %s" % cell.get("cell_dim"),
            )
            if d == 35:
                fin = I.finisher_line_order(
                    fr, cell["A"], cell["C"], cell["NUL"], d, p, npts=30
                )
                check("E2 live finisher full", fin["impossible"] is True)
                flip = I.six_flip_rank(fr, cell["A"], cell["C"], cell["NUL"], d, p)
                check("E3 live flip rank 2", flip.get("rank") == 2)
    else:
        print("[E] skipped (pass --live for live replay)")

    # per-degree files exist
    print("[F] artefacts")
    for d in range(34, 43):
        for p in (331, 661):
            check(
                "F d=%d p=%d json" % (d, p),
                os.path.exists(os.path.join(RES, "d%d_p%d.json" % (d, p))),
            )

    print()
    n = len(checks)
    nf = len(fails)
    print("checks=%d failures=%d  [%.1fs]" % (n, nf, time.time() - T0))
    out = {
        "checks": n,
        "failures": nf,
        "failed": fails,
        "seconds": time.time() - T0,
    }
    with open(os.path.join(RES, "verifier_output.json"), "w") as f:
        json.dump(out, f, indent=1)
    if nf == 0:
        print("LANDING_SWEEP_VERIFY_OK")
        print("ALLGREEN")
        return 0
    print("LANDING_SWEEP_VERIFY_FAIL")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
