#!/usr/bin/env python3
"""Replayable verifier for CONE_CROSSPRIME.

Default: stored artefacts (cell/P3 JSON, section ranks, leading ideal).
--live: rebuild the 37-cell at p=661 from sealed PAIR_ATTACK files.

Machine markers: CONE_CROSSPRIME_VERIFY_OK / ALLGREEN
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
P = 661

DIRECTOR = {
    6: (56, 56, 0),
    8: (120, 120, 0),
    10: (220, 220, 0),
    18: (1140, 1140, 0),
    19: (1330, 1330, 0),
    20: (1540, 1380, 160),
    22: (2024, 1380, 644),
}


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
    print("CONE_CROSSPRIME verifier", flush=True)

    th = open(os.path.join(HERE, "THEOREM.md")).read()
    check("H1 headline OPEN", "Problem E remains OPEN" in th)
    check("H2 excludes no degree", "excludes no degree" in th)
    check("H3 no REPORT.md", not os.path.isfile(os.path.join(HERE, "REPORT.md")))
    check("H4 registration present",
          os.path.isfile(os.path.join(HERE, "REGISTRATION_SNIPPET.md")))
    check("H5 Not claimed section", "Not claimed" in th)
    check("H6 exit ledger present", "Exit ledger" in th)
    check("H7 honesty tiering", "Honesty" in th or "honesty" in th)

    print("[A] sealed p=661 cell / P3")
    emit = loadj("emit_p%d.json" % P)
    p3 = loadj("p3_p%d.json" % P)
    check("A1 emit present", emit is not None)
    check("A2 P3 present", p3 is not None)
    if emit:
        check("A3 cell shape 37x637",
              emit.get("cell_shape") == [37, 637], str(emit.get("cell_shape")))
        check("A4 rank_U=2", emit.get("cell_rank_U") == 2)
        check("A5 independent seeds recorded",
              emit.get("point_seed") == paths.POINT_SEED
              and emit.get("section_seed_base") == paths.SECTION_SEED_BASE)
        check("A6 not director seed 20260812",
              emit.get("point_seed") != 20260812
              and emit.get("section_seed_base") != 20260812)
        check("A7 not CONE_LADDER section seed 777",
              emit.get("section_seed_base") != 777)
    if p3:
        check("A8 P3=1380", p3.get("rank") == 1380, str(p3.get("rank")))
        check("A9 P3 matches sealed", p3.get("match_sealed") is True)

    print("[B] restricted ranks vs director p=331 table")
    for m, (nmon, rank, hf) in DIRECTOR.items():
        rec = loadj("rung_m%d_p%d.json" % (m, P))
        check("B1 m=%d present" % m, rec is not None)
        if not rec:
            continue
        check("B2 m=%d dim_sym3=%d" % (m, nmon), rec.get("dim_sym3") == nmon)
        check("B3 m=%d rank=%d" % (m, rank), rec.get("rank") == rank,
              str(rec.get("rank")))
        check("B4 m=%d HF_L3=%d" % (m, hf), rec.get("HF_L3") == hf,
              str(rec.get("HF_L3")))
        check("B5 m=%d own section seed" % m,
              rec.get("section_seed") == C.section_seed(m),
              str(rec.get("section_seed")))
        if m in (6, 8, 10, 18, 19):
            check("B6 m=%d FREE" % m, rec.get("free_rung") is True)
            check("B7 m=%d bound=%d" % (m, 37 - m), rec.get("bound") == 37 - m)
        else:
            check("B6 m=%d not free" % m, rec.get("free_rung") is False)
            check("B7 m=%d matches generic 1380" % m,
                  rec.get("matches_generic") is True)

    print("[C] director p=331 m=20 control (240-gen subset)")
    ctrl = loadj("director_m20_control.json")
    check("C1 director control json", ctrl is not None)
    if ctrl:
        check("C2 director zero-dim", ctrl.get("clears") is True)
        lead = ctrl.get("lead") or {}
        check("C3 director 20 pure powers",
              lead.get("zero_dimensional") is True
              and lead.get("nvars") == 20
              and lead.get("missing_pure") == [])
        sealed = C.parse_leading_ideal(
            os.path.join(paths.DIR_PROBES, "cone_m20_lead.out"))
        check("C4 sealed lead reparse zero-dim", sealed.get("zero_dimensional") is True)
        check("C5 sealed nlead 11201", sealed.get("nlead") == 11201, str(sealed.get("nlead")))
        check("C6 sealed char 331",
              (sealed.get("header") or {}).get("char") == 331)
        hist = sealed.get("pure_exponent_histogram") or {}
        check("C7 sealed hist 3x10,4x5,5x5",
              hist.get("3") == 10 and hist.get("4") == 5 and hist.get("5") == 5,
              str(hist))

    print("[D] full-span m=20 msolve at p=661")
    rec = loadj("rung_m20_p%d.json" % P)
    check("D1 m=20 rung present", rec is not None)
    if rec:
        check("D2 full span 1380 gens", rec.get("ngens_written") == 1380,
              str(rec.get("ngens_written")))
        check("D3 not a subset", rec.get("ngens_written") != 240)
        ms = rec.get("msolve") or {}
        lead = ms.get("lead") or {}
        check("D4 threads<=2", (ms.get("threads") or 99) <= 2, str(ms.get("threads")))
        check("D5 ZERO_DIM",
              rec.get("verdict") == "ZERO_DIM" and rec.get("clears") is True)
        check("D6 all 20 pure powers",
              lead.get("zero_dimensional") is True
              and lead.get("missing_pure") == []
              and lead.get("nvars") == 20)
        check("D7 bound 17", rec.get("bound") == 17)
        check("D8 lead char 661", (lead.get("header") or {}).get("char") == 661)
        outp = os.path.join(RES, "cone_m20_p%d_lead.out" % P)
        if os.path.isfile(outp) and os.path.getsize(outp):
            live_lead = C.parse_leading_ideal(outp)
            check("D9 lead file zero-dim", live_lead.get("zero_dimensional") is True)
            check("D10 lead file 20 vars", live_lead.get("nvars") == 20)
        else:
            check("D9 lead file present", False)

    print("[E] cross-prime compare")
    cmp_ = loadj("crossprime_compare.json")
    check("E1 compare present", cmp_ is not None)
    if cmp_:
        check("E2 no prime-dependence", cmp_.get("prime_dependence") is False,
              "disagreements=%s" % cmp_.get("disagreements"))
        check("E3 no serious finding", cmp_.get("serious_finding") is False)
        check("E4 m=20 zero-dim agrees",
              (cmp_.get("m20") or {}).get("zero_dim_agrees") is True)
    summ = loadj("summary.json")
    check("E5 summary present", summ is not None)
    check("E6 summary headline OPEN",
          summ is not None and "OPEN" in (summ.get("headline") or ""))
    check("E7 tightest bound 17",
          summ is not None and summ.get("tightest_modular_bound") == 17)

    if live:
        print("[L] live cell rebuild p=661")
        cell = C.cell37(661)
        check("L1 live cell 37x637", list(cell["B37"].shape) == [37, 637])
        check("L2 live rank_U=2", cell["rank_U"] == 2)
        check("L3 live dim_universal json 37", cell["dim_universal_json"] == 37)

    print()
    print("%d checks, %d failures" % (len(checks), len(fails)))
    if fails:
        print("FAILURES:", ", ".join(fails))
        json.dump({"ok": False, "n": len(checks), "fails": fails},
                  open(os.path.join(RES, "verifier_output.json"), "w"), indent=1)
        return 1
    print("CONE_CROSSPRIME_VERIFY_OK")
    print("ALLGREEN")
    json.dump({"ok": True, "n": len(checks), "fails": []},
              open(os.path.join(RES, "verifier_output.json"), "w"), indent=1)
    return 0


if __name__ == "__main__":
    sys.exit(main())
