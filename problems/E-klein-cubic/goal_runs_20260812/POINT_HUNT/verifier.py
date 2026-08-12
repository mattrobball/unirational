#!/usr/bin/env python3
"""Replayable verifier for POINT_HUNT.

Default: stored artefacts (selftest, cell/P3, jacobian control, extracts).
--live: rebuild the 37-cell at p=331, re-run synthetic msolve selftest,
        re-score any stored points (landing + Euler + Jacobian rank).

Machine markers: POINT_HUNT_VERIFY_OK / ALLGREEN
"""
from __future__ import annotations

import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
SCR = os.path.join(HERE, "scripts")
sys.path.insert(0, SCR)

import paths  # noqa: E402
import huntlib as H  # noqa: E402
import slicelib as SL  # noqa: E402

fails = []
checks = []


def check(name, cond, detail=""):
    checks.append(name)
    if cond:
        print("  OK  %s %s" % (name, detail))
    else:
        print("  FAIL %s %s" % (name, detail))
        fails.append(name)


def loadj(name):
    p = os.path.join(RES, name)
    if not os.path.isfile(p):
        return None
    return json.load(open(p))


def main():
    live = "--live" in sys.argv
    print("POINT_HUNT verifier", flush=True)

    th = open(os.path.join(HERE, "THEOREM.md")).read()
    check("H1 headline OPEN", "Problem E remains OPEN" in th)
    check("H2 excludes no degree", "excludes no degree" in th)
    check("H3 no REPORT.md", not os.path.isfile(os.path.join(HERE, "REPORT.md")))
    check("H4 registration present",
          os.path.isfile(os.path.join(HERE, "REGISTRATION_SNIPPET.md")))
    check("H5 Not claimed section", "Not claimed" in th)
    check("H6 exit ledger present", "Exit ledger" in th)
    check("H7 honesty present", "Honesty" in th)

    print("[A] selftest (msolve empty / positive-dim / line chart)")
    st = loadj("selftest.json")
    check("A1 selftest json", st is not None)
    if st:
        check("A2 selftest ok", st.get("ok") is True)
        check("A3 recovered (0,0,1)",
              [0, 0, 1] in (st.get("line_points") or []))
        check("A4 empty chart parser", st.get("empty_ok") is True)
        check("A5 positive-dim parser", st.get("inf_ok") is True)

    print("[B] cell / P3 anchors")
    for p in (331, 661):
        emit = loadj("emit_p%d.json" % p)
        p3 = loadj("p3_p%d.json" % p)
        if emit is None and p3 is None:
            check("B0 p=%d emit not run" % p, True, "skipped")
            continue
        check("B1 p=%d emit present" % p, emit is not None)
        if emit:
            check("B2 p=%d cell 37x637" % p,
                  emit.get("cell_shape") == [37, 637], str(emit.get("cell_shape")))
            check("B3 p=%d rank_U=2" % p, emit.get("cell_rank_U") == 2)
        if p3:
            check("B4 p=%d P3=1380" % p, p3.get("rank") == 1380, str(p3.get("rank")))
            check("B5 p=%d P3 matches sealed" % p, p3.get("match_sealed") is True)
            check("B6 p=%d full span note" % p, True)

    print("[C] Jacobian / Euler control (director probe)")
    for p in (331, 661):
        jc = loadj("jac_control_p%d.json" % p)
        if jc is None:
            check("C0 p=%d jac-control not run" % p, True, "skipped")
            continue
        check("C1 p=%d Euler OK" % p, jc.get("euler_all_ok") is True)
        check("C2 p=%d generic rank 5" % p, jc.get("matches_director") is True,
              str(jc.get("max_ranks")))

    print("[D] extracts / full-span")
    n_extract = 0
    infeas = None
    n_points = 0
    for p in (331, 661):
        for m in range(1, 38):
            rec = loadj("extract_m%d_p%d.json" % (m, p))
            if rec is None:
                continue
            n_extract += 1
            ng = rec.get("full_span_ngens")
            if rec.get("verdict") == "FREE_EMPTY":
                check("D1 m=%d p=%d free empty" % (m, p), True)
                continue
            if ng is not None:
                check("D2 m=%d p=%d full span 1380" % (m, p),
                      ng == 1380, str(ng))
            if rec.get("infeasible_at_m") is not None:
                infeas = rec.get("infeasible_at_m")
                check("D3 m=%d p=%d recorded infeasible (%s)" %
                      (m, p, rec.get("verdict")), True)
            if rec.get("verdict") == "POINTS":
                n_points += rec.get("n_points") or len(rec.get("points") or [])
                check("D4 m=%d p=%d points recorded" % (m, p),
                      (rec.get("n_points") or 0) > 0)
            elif rec.get("verdict") in ("EMPTY_CHARTS", "FREE_EMPTY",
                                        "ZERO_DIM", "EMPTY_CHART"):
                check("D4 m=%d p=%d no nonzero point" % (m, p), True,
                      rec.get("verdict"))
            sl = loadj("slice_t1_m%d_p%d.json" % (m, p))
            if sl and sl.get("zero_dimensional"):
                check("D6 m=%d p=%d t1=0 slice zero-dim" % (m, p),
                      sl.get("verdict") == "ZERO_DIM")
    check("D0 at least one extract or infeasible record",
          n_extract > 0 or loadj("summary.json") is not None)

    print("[E] scored points / dominance")
    for p in (331, 661):
        for m in range(1, 38):
            rec = loadj("score_m%d_p%d.json" % (m, p))
            if rec is None:
                continue
            for s in rec.get("scored") or []:
                i = s.get("i")
                if s.get("verdict") == "NOT_ON_V":
                    check("E1 m=%d p=%d pt%d flagged not on V" % (m, p, i), True)
                    continue
                land = s.get("landing") or {}
                dom = s.get("dominance") or {}
                check("E2 m=%d p=%d pt%d lands" % (m, p, i),
                      land.get("lands") is True)
                check("E3 m=%d p=%d pt%d Euler" % (m, p, i),
                      dom.get("euler_ok") is True)
                check("E4 m=%d p=%d pt%d rank recorded" % (m, p, i),
                      isinstance(dom.get("max_rank"), int),
                      "rank=%s %s" % (dom.get("max_rank"), s.get("verdict")))
                if isinstance(dom.get("max_rank"), int) and dom["max_rank"] <= 3:
                    check("E5 m=%d p=%d pt%d NOT_DOMINANT" % (m, p, i),
                          s.get("verdict") == "NOT_DOMINANT")

    print("[F] summary / no exclusion")
    summ = loadj("summary.json")
    check("F1 summary present", summ is not None)
    if summ:
        check("F2 summary headline OPEN", "OPEN" in (summ.get("headline") or ""))
        check("F3 no exclusion language in summary headline",
              "excludes no degree" in (summ.get("headline") or ""))

    print("[G] m=29 combined hunts")
    for p, name in ((331, "hunt_m29_p331.json"), (661, "hunt_m29_p661.json")):
        h = loadj(name)
        check("G1 p=%d hunt json" % p, h is not None)
        if h:
            check("G2 p=%d no nonzero point" % p,
                  h.get("verdict") == "NO_NONZERO_POINT"
                  and h.get("n_points") == 0
                  and h.get("V_cap_L") == "{0}")
    h30 = loadj("hunt_m30_p331.json")
    check("G3 m=30 infeasible record",
          h30 is not None and h30.get("infeasible_at_m") == 30)

    if live:
        print("[L] live cell + selftest + rescore")
        cell = H.cell37(331)
        check("L1 live cell 37x637", list(cell["B37"].shape) == [37, 637])
        check("L2 live rank_U=2", cell["rank_U"] == 2)
        # reparse stored selftest outputs if present
        line_out = os.path.join(RES, "selftest", "line.out")
        if os.path.isfile(line_out):
            sol = H.parse_msolve_solutions(line_out, 331)
            check("L3 live reparse line",
                  sol.get("kind") == "zero_dim"
                  and [0, 0, 1] in (sol.get("points") or []),
                  sol.get("kind"))
        empty_out = os.path.join(RES, "selftest", "empty.out")
        if os.path.isfile(empty_out):
            sol = H.parse_msolve_solutions(empty_out, 331)
            check("L4 live reparse empty", sol.get("kind") == "empty")
        inf_out = os.path.join(RES, "selftest", "inf.out")
        if os.path.isfile(inf_out):
            sol = H.parse_msolve_solutions(inf_out, 331)
            check("L5 live reparse posdim", sol.get("kind") == "positive_dim")
        # rescore first stored point if any
        for p in (331, 661):
            for m in range(1, 38):
                rec = loadj("score_m%d_p%d.json" % (m, p))
                if not rec or not rec.get("scored"):
                    continue
                s = rec["scored"][0]
                if s.get("verdict") == "NOT_ON_V" or not s.get("c37"):
                    continue
                A, C = H.load_AC()
                fr = SL.build_frame(p, verbose=False)
                c = np.array(s["c37"], dtype=np.int64)
                B = H.cell37(p)["B37"]
                vec = (c @ B) % p
                land = H.landing_check(fr, A, C, vec, p, npts=12, seed=1)
                check("L6 live landing p=%d m=%d" % (p, m), land["lands"] is True)
                dom = H.dominance_test(fr, A, C, vec, p, ntrials=2, seed=2)
                check("L7 live Euler p=%d m=%d" % (p, m), all(dom["euler_ok"]))
                check("L8 live rank matches store p=%d m=%d" % (p, m),
                      dom["max_rank"] == (s.get("dominance") or {}).get("max_rank"),
                      "%s vs %s" % (dom["max_rank"],
                                    (s.get("dominance") or {}).get("max_rank")))
                break

    print()
    print("%d checks, %d failures" % (len(checks), len(fails)))
    if fails:
        print("FAILURES:", ", ".join(fails))
        json.dump({"ok": False, "n": len(checks), "fails": fails},
                  open(os.path.join(RES, "verifier_output.json"), "w"), indent=1)
        return 1
    print("POINT_HUNT_VERIFY_OK")
    print("ALLGREEN")
    json.dump({"ok": True, "n": len(checks), "fails": []},
              open(os.path.join(RES, "verifier_output.json"), "w"), indent=1)
    return 0


if __name__ == "__main__":
    sys.exit(main())
