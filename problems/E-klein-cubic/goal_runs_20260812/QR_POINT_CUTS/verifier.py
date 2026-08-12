#!/usr/bin/env python3
"""Replayable verifier for QR_POINT_CUTS.

Default: JSON checks (census, sealed dims, d=35 control, saturation,
two-prime agreement, alive table, flag discipline).

  python3 verifier.py           # stored artefacts
  python3 verifier.py --live    # also rebuild census + d=35 cut at p=331

Machine markers: QR_POINT_CUTS_VERIFY_OK / ALLGREEN
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


def load(name):
    path = os.path.join(RES, name)
    with open(path) as f:
        return json.load(f)


def main():
    live = "--live" in sys.argv
    print("QR_POINT_CUTS verifier", flush=True)

    print("[A] C11 census")
    for p in paths.PRIMES:
        c = load("c11_census_p%d.json" % p)
        check("A1 p=%d n_order11=120" % p, c["n_order11_elements"] == 120)
        check("A2 p=%d 12 subgroups/frames" % p,
              c["n_subgroups"] == 12 and c["n_frames"] == 12)
        check("A3 p=%d 60 points" % p, c["n_points"] == 60 and len(c["points"]) == 60)
        check("A4 p=%d all on X" % p, c["all_on_X"] is True)
        check("A5 p=%d frames disjoint size 5" % p,
              c["frames_disjoint"] is True and c["frame_size"] == 5
              and len(c["frames"]) == 12
              and all(len(fr["points"]) == 5 for fr in c["frames"]))
        check("A6 p=%d ladder-5 is a frame" % p, c["ladder_five_is_a_frame"] is True)
        # projective uniqueness of stored points
        pts = [tuple(pt) for pt in c["points"]]
        check("A7 p=%d stored points unique" % p, len(set(pts)) == 60)

    print("[B] sealed cell dims + d=35 control")
    summary = load("summary.json")
    check("B1 sealed_ok", summary["sealed_ok"] is True)
    check("B2 two-prime agree", summary["two_prime_agree"] is True)
    check("B3 control d=35 rank 0", summary["control_ok"] is True,
          "rank=%s" % summary["control_d35_rank"])
    by_d = {r["d"]: r for r in summary["cut_rows"]}
    for d, anc in ((35, 39), (36, 63), (37, 121), (38, 151), (42, 397)):
        r = by_d[d]
        rec331 = load("cut_d%d_p331.json" % d)
        rec661 = load("cut_d%d_p661.json" % d)
        check("B4 d=%d cell=%d both primes" % (d, anc),
              r["cell_331"] == anc == r["cell_661"] == rec331["cell_dim"] == rec661["cell_dim"])
        check("B5 d=%d sat_ok" % d, r["sat_ok"] is True
              and rec331["cut60"]["sat_ok"] and rec661["cut60"]["sat_ok"])
        check("B6 d=%d ranks agree" % d,
              rec331["rank"] == rec661["rank"] == r["rank_331"] == r["rank_661"])
        check("B7 d=%d new_dim agree" % d,
              rec331["new_dim"] == rec661["new_dim"] == r["new_dim_331"])
        check("B8 d=%d one-frame rank matches 60" % d, r["one_frame_matches"] is True)

    rec35 = load("cut_d35_p331.json")
    check("B9 d=35 is NQR and C11 already in structure",
          rec35["is_qr"] is False and rec35["c11_already_in_structure"] is True)
    check("B10 d=35 rank=0 new_dim=39",
          rec35["rank"] == 0 and rec35["new_dim"] == 39)
    for d in (36, 37, 38, 42):
        rec = load("cut_d%d_p331.json" % d)
        check("B11 d=%d is QR and C11 was NOT in structure" % d,
              rec["is_qr"] is True and rec["c11_already_in_structure"] is False)

    print("[C] alive table + flag discipline")
    alive = {r["d"]: r for r in summary["alive_table"]}
    check("C1 nine degrees 34..42", len(alive) == 9)
    check("C2 d=34 stays 0", alive[34]["new_cell"] == 0 and alive[34]["old_cell"] == 0)
    check("C3 d=35 stays 39 (NQR control)",
          alive[35]["new_cell"] == 39 and alive[35]["changed"] is False)
    for d in (39, 40, 41):
        check("C4 d=%d NQR unchanged at %d" % (d, paths.SEALED_CELL[d]),
              alive[d]["new_cell"] == paths.SEALED_CELL[d]
              and alive[d]["changed"] is False
              and alive[d]["class"] == "NQR")
    for d in (36, 37, 38, 42):
        check("C5 d=%d QR new_cell = cut new_dim" % d,
              alive[d]["new_cell"] == by_d[d]["new_dim_331"]
              and alive[d]["class"] == "QR")
    # Flag discipline: a zero new_dim on a previously alive cell is FLAGGED, never claimed.
    for d in paths.CUT_DEGREES:
        r = by_d[d]
        if r["new_dim_331"] == 0 and r["sealed_cell"] > 0:
            check("C6 d=%d zero new_dim is FLAGGED not claimed" % d,
                  r["flagged_zero"] is True)
            rec = load("cut_d%d_p331.json" % d)
            check("C7 d=%d flag_note present" % d, bool(rec.get("flag_note")))
        else:
            check("C6 d=%d no silent zero-claim" % d, r["flagged_zero"] is False)
    check("C8 headline remains OPEN",
          "OPEN" in summary["headline"] and "excludes no degree" in summary["headline"])

    print("[D] packet files")
    for rel in ("THEOREM.md", "REGISTRATION_SNIPPET.md", "verifier.py",
                "scripts/produce_cuts.py", "scripts/c11_points.py",
                "scripts/compile_table.py", "scripts/paths.py"):
        check("D1 exists %s" % rel, os.path.exists(os.path.join(HERE, rel)))
    check("D2 no REPORT.md", not os.path.exists(os.path.join(HERE, "REPORT.md")))

    if live:
        print("[E] live census + d=35 control at p=331")
        import numpy as np
        import d34lib as D34
        import p2lib as P2
        import slicelib as SL
        import produce_dims34 as DIMS
        from c11_points import collect_c11_points
        import produce_cuts as PC

        p = 331
        fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p)))
        pts, report = collect_c11_points(fr, p)
        check("E1 live 60 points", report["n_points"] == 60)
        check("E2 live 12 frames", report["n_frames"] == 12)
        Pbig = DIMS.big_prime()
        dims, _ = DIMS.pathA_dimM(Pbig, dmax=42)
        rng = np.random.default_rng(20260812)
        rec = PC.run_degree(fr, 35, dims[35], p, rng, pts, report["frames"])
        check("E3 live d=35 cell=39", rec["cell_dim"] == 39)
        check("E4 live d=35 rank=0", rec["rank"] == 0)

    print()
    if fails:
        print("QR_POINT_CUTS_VERIFY_FAIL  %d/%d failed"
              % (len(fails), len(checks)))
        for n in fails:
            print("  -", n)
        out = {
            "ok": False,
            "n_checks": len(checks),
            "n_fail": len(fails),
            "fails": fails,
            "seconds": round(time.time() - T0, 2),
        }
        with open(os.path.join(RES, "verifier_output.json"), "w") as f:
            json.dump(out, f, indent=1)
        return 1
    print("QR_POINT_CUTS_VERIFY_OK")
    print("ALLGREEN  %d checks, 0 failures  [%.1fs]"
          % (len(checks), time.time() - T0))
    out = {
        "ok": True,
        "n_checks": len(checks),
        "n_fail": 0,
        "fails": [],
        "seconds": round(time.time() - T0, 2),
        "markers": ["QR_POINT_CUTS_VERIFY_OK", "ALLGREEN"],
    }
    with open(os.path.join(RES, "verifier_output.json"), "w") as f:
        json.dump(out, f, indent=1)
        f.write("\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
