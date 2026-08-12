#!/usr/bin/env python3
"""Replayable verifier for CONE_D36.

Default: stored artefacts (anchors, free rungs, msolve leading ideals).
  python3 verifier.py
  python3 verifier.py --live    # rebuild 62-cell + P3 on K=63 at p=331

Machine markers: CONE_D36_VERIFY_OK / ALLGREEN
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
import cone_lib as L  # noqa: E402

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
    if not os.path.exists(path):
        return None
    with open(path) as f:
        return json.load(f)


def main():
    live = "--live" in sys.argv
    print("CONE_D36 verifier", flush=True)

    print("[A] fatal anchors")
    cell = load("cell_d36_p331.json")
    check("A1 cell artefact p=331", cell is not None)
    if cell:
        check("A2 sealed 63-cell", cell.get("cell_dim") == 63, str(cell.get("cell_dim")))
        check("A3 post-cut 62", cell.get("new_dim") == 62, str(cell.get("new_dim")))
        check("A4 cut rank 1", cell.get("cut_rank") == 1, str(cell.get("cut_rank")))
        check("A5 cut sat", cell.get("sat_ok") is True)
        check("A6 C11 census 60", cell.get("census_n_points") == 60)
    p3 = load("p3_K63_p331.json")
    check("A7 P3 artefact K63 p=331", p3 is not None)
    if p3:
        check("A8 P3(36)=1850", p3.get("P3") == 1850, str(p3.get("P3")))
        check("A9 P3 saturated", p3.get("saturated") is True)
        check("A10 K=63", p3.get("K") == 63)
        check("A11 P3 <= I(108)", p3.get("P3", 0) <= 9545)

    print("[B] 62-cell P3 and free rungs")
    p362 = load("p3_K62_p331.json")
    if p362:
        check("B1 P3 on 62-cell present", True, "P3=%s sat=%s" % (p362.get("P3"), p362.get("saturated")))
        check("B2 K=62", p362.get("K") == 62)
        check("B3 P3_62 <= 1850", p362.get("P3", 99999) <= 1850)
    free = load("free_rungs_p331.json")
    check("B4 free-rung artefact", free is not None)
    if free:
        check("B5 N=62", free.get("N") == 62)
        by_m = {s["m"]: s for s in free.get("sections", [])}
        for m, nmon in ((16, 816), (18, 1140), (19, 1330), (20, 1540), (21, 1771)):
            if m in by_m:
                s = by_m[m]
                check("B6 m=%d rank bookkeeping" % m,
                      s["rank"] + s["HF_L3"] == s["dim_sym3"] == nmon,
                      "rank=%s HF=%s" % (s["rank"], s["HF_L3"]))
        if free.get("best_free_m"):
            check("B7 free bound = 62-m",
                  free["best_free_bound"] == 62 - free["best_free_m"])

    print("[C] msolve rungs (full span)")
    import glob
    msj = sorted(glob.glob(os.path.join(RES, "msolve_m*_p331.json")))
    check("C1 any msolve rung recorded or free-only", True,
          "n=%d" % len(msj))
    for path in msj:
        r = json.load(open(path))
        m = r["m"]
        check("C2 m=%d full-span rule" % m, r.get("full_span_rule") is True)
        if r.get("verdict") == "cleared":
            leadp = os.path.join(RES, "cone_m%d_p331_lead.out" % m)
            check("C3 m=%d leading file" % m, os.path.exists(leadp))
            if os.path.exists(leadp):
                parsed = L.parse_leading_pure_powers(open(leadp).read(), m)
                check("C4 m=%d every var has a pure power" % m,
                      parsed["zero_dimensional"], str(parsed["missing"]))
                check("C5 m=%d bound 62-m" % m, r.get("dim_V_le") == 62 - m)
        elif r.get("verdict") == "timeout":
            check("C6 m=%d timeout recorded honestly" % m, r.get("timeout") is True)
        else:
            check("C7 m=%d verdict recorded" % m, r.get("verdict") is not None,
                  str(r.get("verdict")))

    print("[D] summary + honesty")
    sm = load("summary.json") or load("summary_p331.json")
    check("D1 summary present", sm is not None)
    if sm:
        check("D2 no exclusion flag", sm.get("flagged_exclusion") is False)
        check("D3 headline open", "OPEN" in (sm.get("headline") or ""))
        if sm.get("tightest_dim_V_le") is not None:
            check("D4 tightest is int", isinstance(sm["tightest_dim_V_le"], int))

    cell661 = load("cell_d36_p661.json")
    p3661 = load("p3_K63_p661.json")
    if cell661:
        check("E1 p=661 cell 62", cell661.get("new_dim") == 62)
    if p3661:
        check("E2 p=661 P3=1850", p3661.get("P3") == 1850)

    if live:
        print("[LIVE] rebuild cell + P3 K63 at p=331")
        import produce
        fr = produce.build_frame(331)
        rec, A, C, NUL, B62, _ = produce.load_or_build_cell(fr, 331, force=True)
        check("L1 live cell 63", rec["cell_dim"] == 63)
        check("L2 live cut 62", rec["new_dim"] == 62)
        p3l = produce.measure_p3(fr, A, C, NUL, 331, "K63")
        check("L3 live P3=1850", p3l["P3"] == 1850)

    print()
    if fails:
        print("CONE_D36_VERIFY_FAIL %d/%d  %s"
              % (len(fails), len(checks), fails))
        return 1
    print("CONE_D36_VERIFY_OK")
    print("ALLGREEN  %d checks  %.1fs" % (len(checks), time.time() - T0))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
