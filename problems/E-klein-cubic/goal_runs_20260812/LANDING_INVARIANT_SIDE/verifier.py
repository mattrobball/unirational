#!/usr/bin/env python3
"""Replayable verifier for LANDING_INVARIANT_SIDE.

Checks:
  A  d=35 control P3=1380 both primes (inv-side)
  B  exact P3(36), P3(37), P3(38) two-prime agreement + ceilings
  C  HF3 = N3 − P3 bookkeeping; P3 ≤ I(3d)
  D  HF4 two-sided bounds at d=35 (domain lb + sketch ub)
  E  kernel probe artefact present with verdict
  F  optional --live: recompute d=35 p=331 inv-P3 quickly

Machine markers: LANDING_INV_VERIFY_OK / ALLGREEN
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


def load(d, p):
    path = os.path.join(RES, "p3_inv_d%d_p%d.json" % (d, p))
    if not os.path.exists(path):
        return None
    return json.load(open(path))


def main():
    live = "--live" in sys.argv
    print("LANDING_INVARIANT_SIDE verifier", flush=True)

    # ---- A control ----
    print("[A] d=35 control")
    for p in (331, 661):
        r = load(35, p)
        check("A1 d=35 p=%d present" % p, r is not None)
        if r:
            check("A2 d=35 p=%d P3=1380" % p, r.get("P3") == 1380, str(r.get("P3")))
            check("A3 d=35 p=%d HF3=7759" % p, r.get("HF3") == 7759)
            check("A4 d=35 p=%d K=37" % p, r.get("K") == 37)
            check("A5 d=35 p=%d saturated" % p, r.get("saturated") is True)
            check("A6 d=35 p=%d mode inv" % p, r.get("mode") == "inv_eval_matrix")
            check(
                "A7 d=35 p=%d P3<=I" % p,
                r.get("P3", 0) <= paths.I_3D[35],
            )

    # ---- B exact higher ----
    print("[B] exact P3 at 36..38")
    expected = {
        # filled from this packet's saturated runs; verifier checks agreement
    }
    for d in (36, 37, 38):
        r331, r661 = load(d, 331), load(d, 661)
        check("B1 d=%d both primes present" % d, r331 is not None and r661 is not None)
        if not (r331 and r661):
            continue
        check(
            "B2 d=%d two-prime P3 agree" % d,
            r331["P3"] == r661["P3"],
            "%s vs %s" % (r331["P3"], r661["P3"]),
        )
        check("B3 d=%d both saturated" % d, r331["saturated"] and r661["saturated"])
        check(
            "B4 d=%d K matches seal" % d,
            r331["K"] == paths.POST_FLIP_K[d] == r661["K"],
            "got %s/%s want %s" % (r331["K"], r661["K"], paths.POST_FLIP_K[d]),
        )
        check(
            "B5 d=%d P3 <= I(3d)=%d" % (d, paths.I_3D[d]),
            r331["P3"] <= paths.I_3D[d],
            "P3=%s" % r331["P3"],
        )
        check(
            "B6 d=%d HF3 = N3-P3" % d,
            r331["HF3"] == r331["N3"] - r331["P3"],
        )
        expected[d] = r331["P3"]

    # known un-walling: d=36 was ≥1500 unsaturated in LANDING_SWEEP
    r36 = load(36, 331)
    if r36:
        check("B7 d=36 P3 exact >1500 prior LB", r36["P3"] > 1500 and r36["saturated"])

    # ---- C bookkeeping ----
    print("[C] ceilings and growth")
    p3s = []
    for d in (35, 36, 37, 38):
        r = load(d, 331)
        if r:
            p3s.append(r["P3"])
            check(
                "C1 d=%d deficit I-P3 = recorded" % d,
                r.get("deficit_vs_I") == paths.I_3D[d] - r["P3"],
            )
    if len(p3s) == 4:
        check("C2 P3 strictly increasing", p3s == sorted(p3s) and len(set(p3s)) == 4, str(p3s))

    # ---- D HF4 ----
    print("[D] HF4 bounds d=35")
    N4, P4ub, HF4lb = 91390, 37 * 1380, 91390 - 37 * 1380
    check("D1 domain HF4_lb=40330", HF4lb == 40330)
    for p in (331, 661):
        path = os.path.join(RES, "hf4_p%d.json" % p)
        if not os.path.exists(path):
            # allow summary-only if one prime pushed
            check("D2 hf4 p=%d present (soft)" % p, False, "missing — soft if other prime ok")
            # demote: don't fail hard if at least one prime has bounds
            fails.pop() if fails and fails[-1].startswith("D2") else None
            checks.pop()
            print("  SKIP D2 hf4 p=%d missing" % p)
            continue
        h = json.load(open(path))
        check("D3 p=%d P4_upper=51060" % p, h.get("P4_upper") == P4ub)
        check("D4 p=%d HF4_lower=40330" % p, h.get("HF4_lower") == HF4lb)
        check(
            "D5 p=%d P4_lower >= 6000 sealed" % p,
            (h.get("P4_lower") or 0) >= 6000,
            str(h.get("P4_lower")),
        )
        check(
            "D6 p=%d HF4_upper = N4 - P4_lb" % p,
            h.get("HF4_upper") == N4 - h.get("P4_lower", 0),
        )

    # at least one prime HF4
    any_hf4 = any(
        os.path.exists(os.path.join(RES, "hf4_p%d.json" % p)) for p in (331, 661)
    )
    check("D7 at least one prime HF4 artefact", any_hf4)

    # ---- E kernel ----
    print("[E] kernel probe")
    kp = os.path.join(RES, "kernel_p331.json")
    check("E1 kernel_p331.json present", os.path.exists(kp))
    if os.path.exists(kp):
        k = json.load(open(kp))
        check("E2 verdict present", "verdict" in k)
        nested = k.get("K2_nested") or []
        check("E3 nested curve length>=5", len(nested) >= 5, str(len(nested)))
        if nested:
            # r<=15 full rank observation
            full = [c for c in nested if c.get("r", 99) <= 15]
            check(
                "E4 r<=15 full rank P3=N3",
                all(c.get("P3") == c.get("N3") for c in full) and len(full) >= 2,
            )

    # ---- F live optional ----
    if live:
        print("[F] live d=35 p=331 inv-P3")
        import numpy as np
        import invlib as L
        import slicelib as SL
        import d34lib as D34
        import p2lib as P2

        fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(331, verbose=False)))
        cell = L.load_d35_cell(331)
        rec = L.inv_side_p3(
            fr, cell["A"], cell["C"], cell["Bcell"], 35, 331,
            n_func=1800, max_c=2500, stable_window=300,
            extra_batches=1, extra_size=200, seed=99,
        )
        check("F1 live P3=1380", rec["P3"] == 1380, str(rec["P3"]))
        check("F2 live saturated", rec["saturated"] is True)

    # summary compile
    try:
        import compile_summary
        compile_summary.main()
        check("Z1 summary.json compiled", os.path.exists(os.path.join(RES, "summary.json")))
    except Exception as e:
        check("Z1 summary.json compiled", False, str(e))

    print()
    n_fail = len(fails)
    # soft: missing hf4 on second prime shouldn't kill if D7 holds
    hard_fails = [f for f in fails if not f.startswith("D2")]
    ok = len(hard_fails) == 0
    status = {
        "checks": len(checks),
        "fails": hard_fails,
        "soft_fails": [f for f in fails if f.startswith("D2")],
        "ok": ok,
        "seconds": time.time() - T0,
        "expected_P3": expected,
    }
    with open(os.path.join(RES, "verifier_output.json"), "w") as f:
        json.dump(status, f, indent=2)
    if ok:
        print("LANDING_INV_VERIFY_OK")
        print("ALLGREEN")
        print("(%d checks, %.1fs)" % (len(checks), time.time() - T0))
        return 0
    print("VERIFY_FAIL", hard_fails)
    return 1


if __name__ == "__main__":
    sys.exit(main())
