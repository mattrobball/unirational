#!/usr/bin/env python3
"""Replayable verifier for DOMINANCE_D35.

  python3 verifier.py           # stored artefacts
  python3 verifier.py --live    # also replay anchors at p=331

Machine markers: DOMINANCE_D35_VERIFY_OK / ALLGREEN
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
    print("DOMINANCE_D35 verifier", flush=True)

    print("[A] anchors")
    for p in (331, 661):
        a = load("anchors_p%d.json" % p)
        check("A1 p=%d cell=37" % p, a["cell_dim"] == 37)
        check("A2 p=%d rank_U=2" % p, a["rank_U"] == 2)
        check("A3 p=%d P3=1380" % p, a["P3"] == 1380 and a["I3_shape"] == [1380, 9139])
        check("A4 p=%d HF3=7759" % p, a["HF3"] == 7759)
        check("A5 p=%d Jac rank 5" % p, a["generic_cell_rank"] == 5
              and min(a["cell_ranks"]) == 5)
        check("A6 p=%d Euler" % p, a["euler_all_ok"] is True
              and all(a["euler_ok"]))
        check("A7 p=%d |S|=17905" % p, a["pivot_quartic_support"] == 17905)
        check("A8 p=%d HF4 domain lb 40330" % p, a["HF4_domain_lb"] == 40330)

    print("[B] I4 rewrite of 4x4 minors")
    r331 = load("i4_rewrite_p331.json")
    check("B1 p=331 25 minors", r331["n_tested"] == 25)
    check("B2 p=331 none rewrite to 0", r331["n_rewrite_zero"] == 0)
    check("B3 p=331 rem rank 25", r331["remainder_rank"] == 25)
    check("B4 p=331 |S|=17905", r331["n_used_leads"] == 17905)
    check("B5 p=331 lead deficit 33155", r331["lead_deficit"] == 33155)
    r661 = load("i4_rewrite_p661.json")
    check("B6 p=661 none rewrite to 0", r661["n_rewrite_zero"] == 0
          and r661["n_tested"] >= 5)
    check("B7 p=661 |S|=17905", r661["n_used_leads"] == 17905)

    print("[C] extras and I5")
    ex = load("i4_extras_p331.json")
    check("C1 extras exist 33155", ex["n_extras"] == 33155)
    check("C2 sampled extras not in lead span", ex["n_rewrite_zero"] == 0
          and ex["n_sampled"] >= 12)
    i5 = load("i5_rewrite_p331.json")
    check("C3 I5 |S5|=178811", i5["n_used_I5_leads"] == 178811)
    check("C4 I5 sampled linears not in lead span", i5["n_rewrite_zero"] == 0
          and i5.get("n_sampled", i5.get("n_linears", 0)) >= 4)

    print("[D] minor span + flag discipline")
    m = load("minors_span_p331.json")
    check("D1 minor rank >= 2200", m["rank_after_extra"] >= 2200)
    check("D2 no degree exclusion in rewrite flags",
          r331["all_in_I4_by_rewrite"] is False
          and i5.get("all_linears_times_Q_in_I5") is False)

    if live:
        print("[L] live anchors p=331")
        sys.path.insert(0, SCR)
        import produce_anchors as PA
        rec = PA.run_one(331, ntrials=2)
        check("L1 live cell 37", rec["cell_dim"] == 37)
        check("L2 live Jac 5 Euler", rec["generic_cell_rank"] == 5
              and rec["euler_all_ok"])

    print()
    n_fail = len(fails)
    ok = n_fail == 0
    status = {
        "checks": len(checks),
        "fails": fails,
        "ok": ok,
        "seconds": time.time() - T0,
        "markers": ["DOMINANCE_D35_VERIFY_OK", "ALLGREEN"] if ok else [],
    }
    with open(os.path.join(RES, "verifier_output.json"), "w") as f:
        json.dump(status, f, indent=2)
    if ok:
        print("DOMINANCE_D35_VERIFY_OK")
        print("ALLGREEN  %d checks, 0 failures  [%.1fs]" % (
            len(checks), time.time() - T0))
        return 0
    print("DOMINANCE_D35_VERIFY_FAIL")
    print("fails:", fails)
    return 1


if __name__ == "__main__":
    sys.exit(main())
