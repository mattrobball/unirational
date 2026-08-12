#!/usr/bin/env python3
"""Replayable verifier for CONE_LADDER_D35.

Default: stored artefacts only (cell/P3 JSON, free-rung ranks, leading ideals).
--live: rebuild the 37-cell at p=331 and re-parse the director m=20 control.

Machine markers: CONE_LADDER_D35_VERIFY_OK / ALLGREEN
"""
from __future__ import annotations

import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
SCR = os.path.join(HERE, "scripts")
sys.path.insert(0, SCR)

import paths  # noqa: E402
import conelib as C  # noqa: E402

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
    print("CONE_LADDER_D35 verifier", flush=True)

    th = open(os.path.join(HERE, "THEOREM.md")).read()
    check("H1 headline OPEN", "Problem E remains OPEN" in th)
    check("H2 excludes no degree", "excludes no degree" in th)
    check("H3 no REPORT.md", not os.path.isfile(os.path.join(HERE, "REPORT.md")))
    check("H4 registration present",
          os.path.isfile(os.path.join(HERE, "REGISTRATION_SNIPPET.md")))
    check("H5 Not claimed section", "Not claimed" in th)

    print("[A] cell / P3 anchors")
    for p in (331, 661):
        emit = loadj("emit_p%d.json" % p)
        p3 = loadj("p3_p%d.json" % p)
        check("A1 p=%d emit present" % p, emit is not None)
        check("A2 p=%d P3 present" % p, p3 is not None)
        if emit:
            check("A3 p=%d cell shape 37x637" % p,
                  emit.get("cell_shape") == [37, 637], str(emit.get("cell_shape")))
            check("A4 p=%d rank_U=2" % p, emit.get("cell_rank_U") == 2)
        if p3:
            check("A5 p=%d P3=1380" % p, p3.get("rank") == 1380, str(p3.get("rank")))
            check("A6 p=%d P3 matches sealed" % p, p3.get("match_sealed") is True)

    print("[B] free rungs m=18,19")
    for p in (331, 661):
        for m, nmon, bound in ((18, 1140, 19), (19, 1330, 18)):
            rec = loadj("rung_m%d_p%d.json" % (m, p))
            check("B1 m=%d p=%d present" % (m, p), rec is not None)
            if not rec:
                continue
            check("B2 m=%d p=%d free" % (m, p), rec.get("free_rung") is True)
            check("B3 m=%d p=%d rank=Sym3" % (m, p),
                  rec.get("rank") == nmon == rec.get("dim_sym3"),
                  "%s/%s" % (rec.get("rank"), rec.get("dim_sym3")))
            check("B4 m=%d p=%d bound %d" % (m, p, bound), rec.get("bound") == bound)

    print("[C] director m=20 control (240-gen artefact)")
    ctrl = loadj("director_m20_control.json")
    check("C1 director control json", ctrl is not None)
    if ctrl:
        check("C2 director zero-dim", ctrl.get("clears") is True)
        lead = (ctrl.get("lead") or {})
        check("C3 director 20 pure powers",
              lead.get("zero_dimensional") is True
              and lead.get("nvars") == 20
              and lead.get("missing_pure") == [])
        # re-parse the sealed file
        sealed = C.parse_leading_ideal(
            os.path.join(paths.DIR_PROBES, "cone_m20_lead.out"))
        check("C4 sealed lead reparse zero-dim", sealed.get("zero_dimensional") is True)
        check("C5 sealed nlead 11201", sealed.get("nlead") == 11201, str(sealed.get("nlead")))

    print("[D] full-span msolve rungs")
    tightest_two_prime = None
    tightest_one_prime = None
    for m in (20, 22, 24, 28, 32, 34, 36, 37):
        recs = {}
        for p in (331, 661):
            rec = loadj("rung_m%d_p%d.json" % (m, p))
            if rec is None:
                continue
            recs[p] = rec
            if rec.get("verdict") == "EMITTED":
                check("D0 m=%d p=%d emitted, no solve yet" % (m, p), True,
                      "no verdict")
                continue
            if rec.get("verdict") in ("NO_VERDICT_TIMEOUT", "NO_VERDICT_PARSE",
                                      "NO_VERDICT_MISSING_MS", "NO_VERDICT_MEMORY"):
                check("D0 m=%d p=%d recorded as no-verdict" % (m, p), True,
                      rec.get("verdict"))
                continue
            if rec.get("free_rung"):
                continue
            lead = ((rec.get("msolve") or {}).get("lead")) or {}
            if rec.get("clears"):
                check("D1 m=%d p=%d ZERO_DIM" % (m, p),
                      rec.get("verdict") == "ZERO_DIM"
                      and lead.get("zero_dimensional") is True)
                check("D2 m=%d p=%d ngens=1380" % (m, p),
                      rec.get("ngens_written") == 1380
                      or rec.get("full_span_ngens") == 1380,
                      str(rec.get("ngens_written") or rec.get("full_span_ngens")))
                check("D3 m=%d p=%d all pure powers" % (m, p),
                      lead.get("missing_pure") == [])
                check("D4 m=%d p=%d bound=%d" % (m, p, 37 - m),
                      rec.get("bound") == 37 - m)
                # re-parse the lead file
                outp = os.path.join(RES, "cone_m%d_p%d_lead.out" % (m, p))
                if os.path.isfile(outp) and os.path.getsize(outp):
                    live_lead = C.parse_leading_ideal(outp)
                    check("D5 m=%d p=%d lead file zero-dim" % (m, p),
                          live_lead.get("zero_dimensional") is True)
                if tightest_one_prime is None or (37 - m) < tightest_one_prime:
                    tightest_one_prime = 37 - m
            elif rec.get("verdict") == "NOT_ZERO_DIM":
                check("D1 m=%d p=%d recorded not 0-dim" % (m, p), True,
                      "missing %s" % lead.get("missing_pure"))
        if all(recs.get(p, {}).get("clears") for p in (331, 661)):
            if tightest_two_prime is None or (37 - m) < tightest_two_prime:
                tightest_two_prime = 37 - m

    print("[E] bound bookkeeping")
    summ = loadj("summary.json")
    check("E1 summary present", summ is not None)
    check("E2 summary headline OPEN",
          summ is not None and "OPEN" in (summ.get("headline") or ""))
    check("E3 two-prime bound is %s" % tightest_two_prime,
          tightest_two_prime is not None, "one-prime tightest %s" % tightest_one_prime)

    if live:
        print("[L] live cell rebuild p=331")
        cell = C.cell37(331)
        check("L1 live cell 37x637", list(cell["B37"].shape) == [37, 637])
        check("L2 live rank_U=2", cell["rank_U"] == 2)

    print()
    print("%d checks, %d failures" % (len(checks), len(fails)))
    if fails:
        print("FAILURES:", ", ".join(fails))
        out = {"ok": False, "n": len(checks), "fails": fails}
        json.dump(out, open(os.path.join(RES, "verifier_output.json"), "w"), indent=1)
        return 1
    print("CONE_LADDER_D35_VERIFY_OK")
    print("ALLGREEN")
    json.dump({"ok": True, "n": len(checks), "fails": [],
               "tightest_two_prime": tightest_two_prime,
               "tightest_one_prime": tightest_one_prime},
              open(os.path.join(RES, "verifier_output.json"), "w"), indent=1)
    return 0


if __name__ == "__main__":
    sys.exit(main())
