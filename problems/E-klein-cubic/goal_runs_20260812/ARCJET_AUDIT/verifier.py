#!/usr/bin/env python3
"""Replay verifier for ARCJET_AUDIT. python3 only; primes 331, 661, 991."""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
PRIMES_A1 = (331, 661, 991)
PRIMES_A3 = (331, 661)


def check(cond, msg, failures):
    if not cond:
        failures.append(msg)
        print("FAIL:", msg)
    else:
        print("OK:", msg)


def main():
    failures = []
    print("== ARCJET_AUDIT verifier", flush=True)

    # no REPORT.md
    check(not os.path.exists(os.path.join(HERE, "REPORT.md")),
          "no REPORT.md", failures)
    check(os.path.exists(os.path.join(HERE, "THEOREM.md")),
          "THEOREM.md present", failures)

    # A1/A2
    for p in PRIMES_A1:
        path = os.path.join(RES, "a1_a2_p%d.json" % p)
        check(os.path.exists(path), "a1_a2_p%d.json exists" % p, failures)
        d = json.load(open(path))
        check(d["A1_verdict"] == "CONFIRMED",
              "A1 CONFIRMED p=%d" % p, failures)
        check(d["A2_verdict"] == "CONFIRMED",
              "A2 CONFIRMED p=%d" % p, failures)
        check(d["n_period3"] == 12, "12 period-3 p=%d" % p, failures)
        check(d["hard_rigidity_ok"], "hard rigidity p=%d" % p, failures)
        zc = d["zero_counts"]
        check(int(zc.get("2", zc.get(2, -1))) == 4,
              "kappa2 zero 4/12 p=%d" % p, failures)
        check(int(zc.get("5", zc.get(5, -1))) == 12,
              "kappa5 zero 12/12 p=%d" % p, failures)
        check(int(zc.get("8", zc.get(8, -1))) == 4,
              "kappa8 zero 4/12 p=%d" % p, failures)
        check(d["n_all_mod2_vanish"] == 4,
              "all-mod2-vanish 4 kids p=%d" % p, failures)
        check(d["level_rigidity"]["0"] == 0, "rig0 p=%d" % p, failures)
        check(d["level_rigidity"]["1"] == 0, "rig1 p=%d" % p, failures)
        check(d["level_rigidity"]["2"] == 0, "rig2 p=%d" % p, failures)
        check(d["level_rigidity"]["5"] == 0, "rig5 p=%d" % p, failures)
        check(d["level_rigidity"]["8"] == 0, "rig8 p=%d" % p, failures)
        check(d["n_no_level0"] == 4, "4 no-level0 p=%d" % p, failures)
        check(len(d["A1_refute_witnesses"]) == 0,
              "A1 no refute witnesses p=%d" % p, failures)
        check(len(d["A2_refute_witnesses"]) == 0,
              "A2 no refute witnesses p=%d" % p, failures)
        check(os.path.exists(os.path.join(RES, "cell37_own_p%d.npy" % p)),
              "own cell37 p=%d" % p, failures)
        if p in (331, 661):
            rep = d.get("replay_62") or {}
            check(rep.get("n_dead") == 62 and rep.get("n_live") == 0,
                  "replay 62 dead p=%d" % p, failures)
            check(d.get("sealed_cell_rowspace_match") is True,
                  "sealed cell rowspace p=%d" % p, failures)
            sc = d.get("sealed_compare") or {}
            check(sc.get("n_mismatches", 1) == 0,
                  "sealed vanishing match p=%d" % p, failures)

    # A3
    for p in PRIMES_A3:
        path = os.path.join(RES, "a3_materialize_p%d.json" % p)
        check(os.path.exists(path), "a3_materialize_p%d.json exists" % p, failures)
        d = json.load(open(path))
        check(d["A3_verdict"] == "CONFIRMED", "A3 CONFIRMED p=%d" % p, failures)
        check(d["n_joint"] == 1264, "joint 1264 p=%d" % p, failures)
        check(d["n_ext"] == 508, "ext 508 p=%d" % p, failures)
        check(d["n_strat"] == 756, "strat 756 p=%d" % p, failures)
        part = d["partition_508"]
        check(part["multidegree"] == 298 and part["line_order"] == 148
              and part["to_ladder"] == 62,
              "partition 298/148/62 p=%d" % p, failures)
        check(d["sol_hash_joint_match"] and d["sol_hash_ext_match"],
              "sol_hash sets match p=%d" % p, failures)
        check(d["partition_match_298_148_62"],
              "partition_match flag p=%d" % p, failures)

    # A4
    a4 = json.load(open(os.path.join(RES, "a4_anchor.json")))
    check(a4["A4_verdict"] == "CONFIRMED", "A4 CONFIRMED", failures)
    for p in (331, 661, 991):
        check(a4["per_prime"][str(p)]["ok"], "A4 ok p=%d" % p, failures)
    r991 = a4["per_prime"]["991"]
    check(r991["null_dim"] == 39, "991 null dim 39", failures)
    check(r991["six_flip"]["slice_rank"] == 2, "991 six-flip rank 2", failures)
    check(r991["six_flip"]["dim_after"] == 37, "991 dim 37", failures)

    # summary
    summary_path = os.path.join(RES, "audit_summary.json")
    check(os.path.exists(summary_path), "audit_summary.json exists", failures)
    if os.path.exists(summary_path):
        s = json.load(open(summary_path))
        check(s["headline"].startswith("Problem E remains OPEN"),
              "headline OPEN", failures)
        for k in ("A1", "A2", "A3", "A4"):
            check(s["verdicts"][k] == "CONFIRMED",
                  "summary %s CONFIRMED" % k, failures)

    # independent engine present
    for name in ("reynolds.py", "frame.py", "linalg.py", "audit_a1_a2.py",
                 "audit_a3_materialize.py", "audit_a4_anchor.py"):
        check(os.path.exists(os.path.join(HERE, "scripts", name)),
              "script %s" % name, failures)

    print()
    if not failures:
        print("ARCJET_AUDIT_VERIFY_OK")
        print("ALLGREEN")
        return 0
    print("ARCJET_AUDIT_VERIFY_FAIL n=%d" % len(failures))
    for f in failures:
        print(" ", f)
    return 1


if __name__ == "__main__":
    sys.exit(main())
