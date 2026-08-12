#!/usr/bin/env python3
"""Replayable verifier for ALIVE_EXTEND.

Default: JSON checks (anchors 34-42, two-prime agreement, instrument
pattern, flag discipline, packet files).

  python3 verifier.py           # stored artefacts
  python3 verifier.py --live    # also rebuild d=34 and d=35 at p=331

Machine markers: ALIVE_EXTEND_VERIFY_OK / ALLGREEN
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
    with open(os.path.join(RES, name)) as f:
        return json.load(f)


def main():
    live = "--live" in sys.argv
    print("ALIVE_EXTEND verifier", flush=True)

    print("[A] packet files")
    for rel in (
        "THEOREM.md",
        "REGISTRATION_SNIPPET.md",
        "verifier.py",
        "scripts/produce_extend.py",
        "scripts/compile_table.py",
        "scripts/paths.py",
        "results/degree_table.json",
        "results/summary.json",
        "results/dimM.json",
    ):
        check("A1 exists %s" % rel, os.path.exists(os.path.join(HERE, rel)))
    check("A2 no REPORT.md", not os.path.exists(os.path.join(HERE, "REPORT.md")))

    print("[B] sealed dimM + census")
    dimM = load("dimM.json")
    check("B1 sealed dimM 34-42", dimM["sealed_ok"] is True)
    for d, want in paths.SEALED_DIMM.items():
        check("B2 dimM[%d]=%d" % (d, want), dimM["dim_M"][d] == want)
    check("B3 dimM has d=50", len(dimM["dim_M"]) >= 51)
    for p in paths.PRIMES:
        c = load("c11_census_p%d.json" % p)
        check("B4 p=%d 60 points" % p, c["n_points"] == 60 and len(c["points"]) == 60)
        check("B5 p=%d 12 frames" % p, c["n_frames"] == 12 and c["n_subgroups"] == 12)
        check("B6 p=%d all on X" % p, c["all_on_X"] is True)

    print("[C] degree table, anchors, two-prime agreement")
    tab = load("degree_table.json")
    summary = load("summary.json")
    check("C1 table has 17 degrees 34..50", len(tab["rows"]) == 17)
    check("C2 two-prime agree", tab["two_prime_agree"] is True)
    check("C3 summary anchors_ok", summary["anchors_ok"] is True)
    check(
        "C4 headline OPEN",
        "OPEN" in tab["headline"] and "excludes no degree" in tab["headline"],
    )
    by_d = {r["d"]: r for r in tab["rows"]}
    for d, want in paths.SEALED_RAW.items():
        r = by_d[d]
        check(
            "C5 d=%d raw=%d both primes" % (d, want),
            r["p331"]["raw"] == want == r["p661"]["raw"],
            "got %s/%s" % (r["p331"]["raw"], r["p661"]["raw"]),
        )
    for d, want in paths.SEALED_WINDOW.items():
        r = by_d[d]
        check(
            "C6 d=%d window=%d both primes" % (d, want),
            r["p331"]["window"] == want == r["p661"]["window"],
            "got %s/%s" % (r["p331"]["window"], r["p661"]["window"]),
        )
        rec331 = load("d%d_p331.json" % d)
        rec661 = load("d%d_p661.json" % d)
        check(
            "C7 d=%d json window matches table" % d,
            rec331["window"] == want == rec661["window"],
        )
    for d in range(34, 51):
        check("C8 d=%d agree_all" % d, by_d[d]["agree_all"] is True, str(by_d[d]["agree"]))
        check("C9 d=%d r0=6" % d, by_d[d]["p331"]["r0"] == 6 == by_d[d]["p661"]["r0"])

    print("[D] C11 + finisher + six-flip pattern")
    rec35 = load("d35_p331.json")
    check("D1 d=35 NQR and C11 already in structure",
          rec35["is_qr"] is False and rec35["c11_already_in_structure"] is True)
    check("D2 d=35 C11 rank 0 window 39",
          rec35["c11_rank"] == 0 and rec35["window"] == 39)
    check("D3 d=34 control window 0", by_d[34]["p331"]["window"] == 0)
    for d in range(34, 51):
        r = by_d[d]["p331"]
        rec = load("d%d_p331.json" % d)
        check("D4 d=%d sat_ok" % d, r["sat_ok"] is True)
        check("D5 d=%d one-frame rank matches 60" % d, r["one_frame_matches"] is True)
        if paths.is_qr(d):
            check("D6 d=%d QR: C11 not in old structure" % d,
                  rec["c11_already_in_structure"] is False)
        else:
            check("D6 d=%d NQR: C11 already in structure" % d,
                  rec["c11_already_in_structure"] is True)
        if d % 2 == 0:
            check("D7 d=%d six-flip skipped" % d, r["flip_skip"] is True)
            if d >= 36:
                check("D8 d=%d fin demand=3" % d, r["fin_demand"] == 3)
        else:
            check("D7 d=%d six-flip not skipped" % d, r["flip_skip"] is False)
            check("D8 d=%d fin demand=2" % d, r["fin_demand"] == 2)
            if r["window"] > 0:
                check("D9 d=%d six-flip rank=2" % d, r["flip_rank"] == 2,
                      "got %s" % r["flip_rank"])
                check(
                    "D10 d=%d post = window-2" % d,
                    r["post"] == r["window"] - r["flip_rank"],
                    "post=%s window=%s rank=%s" % (r["post"], r["window"], r["flip_rank"]),
                )
        # sealed finisher kills at 35 (window=raw) and 36 (window=raw-1)
        if d in (34, 35, 36):
            check("D11 d=%d finisher impossible" % d, r["fin_imp"] is True)
        if 37 <= d <= 42:
            check("D11 d=%d finisher not a full-rank kill (sealed fade)" % d,
                  r["fin_imp"] is False)
        # d=43..50: finisher verdict is a measurement, not an expected pattern

    print("[E] flag discipline")
    check("E1 any_flagged_zero matches table",
          tab["any_flagged_zero"] is summary["any_flagged_zero"])
    for d in range(34, 51):
        r = by_d[d]["p331"]
        rec = load("d%d_p331.json" % d)
        if r["window"] == 0 and r["raw"] > 0:
            check("E2 d=%d zero window is FLAGGED" % d,
                  r["flagged_zero"] is True and rec.get("flag_note"))
        else:
            check("E2 d=%d no silent zero-claim" % d, r["flagged_zero"] is False)
    check("E3 no degree-exclusion claim in summary headline",
          "OPEN" in summary["headline"] and "excludes no degree" in summary["headline"])

    if live:
        print("[F] live mini-replay d=34,35 p=331")
        import numpy as np
        import d34lib as D34
        import p2lib as P2
        import slicelib as SL
        import produce_dims34 as DIMS
        from c11_points import collect_c11_points
        import produce_extend as PE

        p = 331
        Pbig = DIMS.big_prime()
        dims, _ = DIMS.pathA_dimM(Pbig, dmax=50)
        fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p)))
        pts, report = collect_c11_points(fr, p)
        rng = np.random.default_rng(20260812)
        rec34 = PE.run_degree(fr, 34, dims[34], p, rng, pts, report["frames"])
        check("F1 live d=34 window=0", rec34["window"] == 0)
        rec35 = PE.run_degree(fr, 35, dims[35], p, rng, pts, report["frames"])
        check("F2 live d=35 raw=39 window=39",
              rec35["raw_cell"] == 39 and rec35["window"] == 39)
        check("F3 live d=35 C11 rank 0", rec35["c11_rank"] == 0)
        check("F4 live d=35 finisher full", rec35["finisher"]["impossible"] is True)
        check("F5 live d=35 flip rank 2", rec35["six_flip"].get("rank") == 2)
    else:
        print("[F] skipped (pass --live for live replay)")

    print()
    out = {
        "ok": len(fails) == 0,
        "n_checks": len(checks),
        "n_fail": len(fails),
        "fails": fails,
        "seconds": round(time.time() - T0, 2),
    }
    with open(os.path.join(RES, "verifier_output.json"), "w") as f:
        json.dump(out, f, indent=1)
        f.write("\n")
    if fails:
        print("ALIVE_EXTEND_VERIFY_FAIL  %d/%d failed" % (len(fails), len(checks)))
        for n in fails:
            print("  -", n)
        return 1
    print("ALIVE_EXTEND_VERIFY_OK")
    print("ALLGREEN  %d checks, 0 failures  [%.1fs]" % (len(checks), time.time() - T0))
    out["markers"] = ["ALIVE_EXTEND_VERIFY_OK", "ALLGREEN"]
    with open(os.path.join(RES, "verifier_output.json"), "w") as f:
        json.dump(out, f, indent=1)
        f.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
