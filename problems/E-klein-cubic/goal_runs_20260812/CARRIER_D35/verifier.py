#!/usr/bin/env python3
"""Replayable verifier for CARRIER_D35.

  python3 verifier.py           # stored artefacts + window replay
  python3 verifier.py --live    # also I_C at 331 and C11-on-C

Machine markers: CARRIER_D35_VERIFY_OK / ALLGREEN
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
import window as W  # noqa: E402

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
    print("CARRIER_D35 verifier", flush=True)

    check("THEOREM.md present", os.path.exists(os.path.join(HERE, "THEOREM.md")))
    check("no REPORT.md", not os.path.exists(os.path.join(HERE, "REPORT.md")))

    print("[A] d=34 reconstruction")
    d34 = load("d34_reconstruct.json")
    check("A1 n1=16 both", d34["n1_both"] is True)
    check("A2 rank=3 both", d34["rank_both"] is True)
    check("A3 n2=13 both", d34["n2_both"] is True)
    check("A4 LAND empty claimed", d34["land_empty_claimed"] is True)
    check("A5 GATE source numbers",
          d34["by_prime"]["67"]["n2"] == 13
          and d34["by_prime"]["199"]["n2"] == 13)

    print("[B] Hessian window replay")
    rows = {r["d"]: r for r in W.window_rows([34, 35, 36])}
    stored = load("hess_window.json")["rows"]
    st = {r["d"]: r for r in stored}
    check("B1 d=34 oncurve 6 / molien 576",
          rows[34]["oncurve_Wb"] == 6 and rows[34]["molien_Wb"] == 576)
    check("B2 d=35 oncurve 5 / molien 637",
          rows[35]["oncurve_Wb"] == 5 and rows[35]["molien_Wb"] == 637)
    check("B3 d=35 HF 675", rows[35]["HF"] == 675)
    check("B4 stored matches replay",
          st[35]["oncurve_Wb"] == 5 and st[35]["molien_Wb"] == 637)

    print("[C] I_C and geometry")
    for p in (331, 661):
        ic = load("IC_p%d.json" % p)
        check("C1 p=%d I_C ok" % p, ic["ok"] is True,
              "dim=%s deg=%s HF35=%s" % (ic.get("dimProj"), ic.get("degree"),
                                          ic["HF"].get("35", ic["HF"].get(35))))
        rec = load("carrier_d35_p%d.json" % p)
        check("C2 p=%d dH fd 8/8" % p, rec["dH_fd_check"] == [8, 8])
        check("C3 p=%d C11 60 on C, value rank 0" % p,
              rec["c11"]["n"] == 60 and rec["c11"]["all_on_C"]
              and rec["c11"]["value_rank"] == 0)
        check("C4 p=%d value rank 1" % p, rec["rank_values"] == 1)
        check("C5 p=%d kernel interval 32..36" % p,
              rec["kernel_dim_lower"] == 32
              and rec["kernel_dim_upper"] == 36)

    rec331 = load("carrier_d35_p331.json")
    check("C6 p=331 sextet 6 linear over Fp2",
          rec331["sextet"]["six_linear_over_fp2"] is True)

    print("[D] 22 and headline")
    meet = load("meet22.json")
    check("D1 keep-pass ok", meet["sealed_keep_pass_ok"] is True)
    check("D2 meets closed", meet["meets_closed_constraints"] is True)
    for row in meet["by_prime"]:
        check("D3 p=%d 22 live closed-rank 0" % row["p"],
              row["n_live"] == 22 and row["all_closed_rank_0"]
              and row["all_best_dim_37"])

    summary = load("summary.json")
    check("D4 headline OPEN",
          summary["headline"].startswith("Problem E remains OPEN"))
    check("D5 no degree excluded", summary["degree_excluded"] is False)
    check("D6 ODDZERO idle", summary["oddzero_idle"] is True)
    check("D7 ansatz linearly alive",
          summary["ansatz"] == "CANONICAL_CARRIER_D35_LINEARLY_ALIVE"
          and summary["alive_linearly"] is True)
    check("D8 two-prime agree rank 1",
          summary["two_prime_agree"] is True
          and summary["rank_values_by_prime"] == {"331": 1, "661": 1})
    check("D9 kernel interval", summary["kernel_dim_interval"] == [32, 36])

    if live:
        print("[E] --live")
        import hesslib as H
        import slicelib as SL
        from produce import run_ic
        ic = run_ic(331)
        check("E1 live I_C 331", ic["ok"] is True)
        fr = SL.build_frame(331, verbose=False)
        rec, pts = H.c11_points(fr, 331)
        check("E2 live C11 on C", rec["all_on_C"] is True and len(pts) == 60)
        fd = H.fd_check_dH(331)
        check("E3 live dH fd", fd == (8, 8))

    if fails:
        print("CARRIER_D35_VERIFY_FAIL n=%d" % len(fails))
        for f in fails:
            print("  ", f)
        return 1
    print("CARRIER_D35_VERIFY_OK")
    print("ALLGREEN")
    print("checks %d" % len(checks))
    return 0


if __name__ == "__main__":
    sys.exit(main())
