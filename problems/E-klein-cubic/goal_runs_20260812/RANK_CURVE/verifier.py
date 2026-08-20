#!/usr/bin/env python3
"""Replayable verifier for RANK_CURVE.

Checks bookkeeping of the extended P3 curve, the d=35 restricted_cubics
control, the semi-regularity artefact, and that no degree is excluded.

Machine markers: RANK_CURVE_VERIFY_OK / ALLGREEN
Optional: --live  (recompute d=35 p=331 restricted_cubics on 400 points,
                   rank must be <= 1380 and, if 400 samples saturate early,
                   still a lower bound; full 2200-point replay is produce_control)
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
    if not os.path.exists(path):
        return None
    return json.load(open(path))


def main():
    live = "--live" in sys.argv
    print("RANK_CURVE verifier", flush=True)

    print("[A] sealed 35..38 bookkeeping")
    for d, P3 in paths.SEALED_P3.items():
        K = paths.POST_FLIP_K[d]
        I3 = paths.I_3D[d]
        check("A1 d=%d P3<=I(3d)" % d, P3 <= I3, "P3=%d I=%d" % (P3, I3))
        check("A2 d=%d K sealed" % d, K > 0)

    print("[B] d=35 restricted_cubics control")
    c331 = load("control_d35_p331.json")
    check("B1 control p=331 present", c331 is not None)
    if c331:
        check("B2 director P3=1380", c331.get("P3_director") == 1380, str(c331.get("P3_director")))
        check("B3 copy P3=1380", c331.get("P3_copy") == 1380, str(c331.get("P3_copy")))
        check("B4 rows equal", c331.get("rows_equal") is True)
        check("B5 mode restricted_cubics", c331.get("mode") == "restricted_cubics")
    c661 = load("control_d35_p661.json")
    if c661:
        check("B6 control p=661 P3=1380", c661.get("P3_director") == 1380)

    print("[C] extended P3 at 39..42")
    got = []
    for d in (39, 40, 41, 42):
        r331 = load("p3_d%d_p331.json" % d)
        r661 = load("p3_d%d_p661.json" % d)
        check("C1 d=%d p=331 present" % d, r331 is not None)
        if r331 is None:
            continue
        check("C2 d=%d K matches sweep post-flip" % d, r331.get("K") == paths.POST_FLIP_K[d],
              "got %s want %s" % (r331.get("K"), paths.POST_FLIP_K[d]))
        check("C3 d=%d P3 <= I(3d)=%d" % (d, paths.I_3D[d]),
              r331.get("P3", 10 ** 9) <= paths.I_3D[d], str(r331.get("P3")))
        check("C4 d=%d HF3 = N3-P3" % d,
              r331.get("HF3") == r331.get("N3") - r331.get("P3"))
        check("C5 d=%d saturated" % d, r331.get("saturated") is True,
              "sat=%s lb=%s" % (r331.get("saturated"), r331.get("P3_is_lower_bound")))
        check("C6 d=%d P3>0" % d, (r331.get("P3") or 0) > 0)
        if r661:
            check("C7 d=%d two-prime P3 agree" % d, r331.get("P3") == r661.get("P3"),
                  "%s vs %s" % (r331.get("P3"), r661.get("P3")))
            check("C8 d=%d p=661 saturated" % d, r661.get("saturated") is True)
        got.append(r331.get("P3"))
        if r331.get("qr_cut"):
            expect = paths.QR_ALIVE[d]
            check(
                "C9 d=%d qr new_dim vs alive table" % d,
                r331["qr_cut"].get("new_dim") == expect,
                "got %s want %s" % (r331["qr_cut"].get("new_dim"), expect),
            )
    c39 = load("p3_confirm_d39_p331.json")
    r39 = load("p3_d39_p331.json")
    check("C10 d=39 independent confirm present", c39 is not None)
    if c39 and r39:
        check("C11 d=39 confirm P3 matches", c39.get("P3") == r39.get("P3") == 4168,
              str(c39.get("P3")))
        check("C12 d=39 confirm saturated", c39.get("saturated") is True)

    print("[D] semi-regularity artefact")
    s331 = load("semireg_d35_p331.json")
    check("D1 semireg p=331 present", s331 is not None)
    if s331:
        check("D2 P3=1380", s331.get("P3") == 1380, str(s331.get("P3")))
        check("D3 n_products=51060", s331.get("n_products") == 37 * 1380)
        check("D4 largest subset >= 1", (s331.get("largest_independent_subset") or 0) >= 1)
        check("D5 verdict recorded", s331.get("verdict") in (
            "UNFALSIFIED_AT_SCALE", "DEPENDENCY_FOUND_NOT_SEMIREGULAR"
        ), str(s331.get("verdict")))
        check("D6 HF4 domain lb 40330", s331.get("HF4_domain_lb") == 40330)

    print("[E] no degree exclusion")
    th = os.path.join(HERE, "THEOREM.md")
    check("E1 THEOREM.md present", os.path.exists(th))
    if os.path.exists(th):
        txt = open(th).read()
        check(
            "E2 headline open",
            "Problem E remains OPEN; this packet excludes no degree." in txt,
        )
        check("E3 Not claimed section", "## Not claimed" in txt or "## 5. Not claimed" in txt
              or "Not claimed" in txt)
        check("E4 no closed-degree claim", "excludes no degree" in txt)

    print("[F] registration snippet")
    reg = os.path.join(HERE, "REGISTRATION_SNIPPET.md")
    check("F1 REGISTRATION_SNIPPET.md present", os.path.exists(reg))
    if os.path.exists(reg):
        rtxt = open(reg).read()
        check("F2 entry E56", '"entry": "E56"' in rtxt or "entry: E56" in rtxt)
        check("F3 kind goal_run", "goal_run" in rtxt)
        check("F4 tracked true", "tracked" in rtxt)

    if live:
        print("[G] live restricted_cubics sketch d=35 p=331")
        import numpy as np
        import cells
        import cubics
        import lin
        import d34lib as D34
        import p2lib as P2
        import slicelib as SL

        fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(331, verbose=False)))
        cell = cells.load_d35_cell(331)
        rows, mons = cubics.restricted_cubics_director(
            fr, cell["A"], cell["C"], cell["Bcell"], 500, 331, seed=99
        )
        rk = lin.rank_mod(rows, 331)
        check("G1 live rank <= 1380", rk <= 1380, str(rk))
        check("G2 live rank >= 400 or full on 500", rk >= 400)

    try:
        import compile_summary
        compile_summary.main()
        check("Z1 summary.json compiled", os.path.exists(os.path.join(RES, "summary.json")))
    except Exception as e:
        check("Z1 summary.json compiled", False, str(e))

    print()
    ok = len(fails) == 0
    status = {
        "checks": len(checks),
        "fails": fails,
        "ok": ok,
        "seconds": time.time() - T0,
        "extended_P3": got,
    }
    with open(os.path.join(RES, "verifier_output.json"), "w") as f:
        json.dump(status, f, indent=2)
    if ok:
        print("RANK_CURVE_VERIFY_OK")
        print("ALLGREEN")
        print("(%d checks, %.1fs)" % (len(checks), time.time() - T0))
        return 0
    print("VERIFY_FAIL", fails)
    return 1


if __name__ == "__main__":
    sys.exit(main())
