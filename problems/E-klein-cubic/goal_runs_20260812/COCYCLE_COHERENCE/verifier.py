#!/usr/bin/env python3
"""Replayable verifier for COCYCLE_COHERENCE.

Re-runs the audit live at both primes and checks the sealed summary.
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
SCR = os.path.join(HERE, "scripts")
RES = os.path.join(HERE, "results")
sys.path.insert(0, SCR)
import paths  # noqa: E402
from audit_implied import run as audit_run  # noqa: E402

CHECKS = []
FAILS = []


def check(name, cond, detail=""):
    CHECKS.append(name)
    if cond:
        print("  PASS  %s" % name)
    else:
        FAILS.append(name)
        print("  FAIL  %s  %s" % (name, detail))


def main():
    print("=== COCYCLE_COHERENCE verifier ===")
    summary_path = os.path.join(RES, "summary.json")
    audit_path = os.path.join(RES, "audit_implied.json")
    check("A0 summary.json exists", os.path.isfile(summary_path))
    check("A1 audit_implied.json exists", os.path.isfile(audit_path))
    if not os.path.isfile(summary_path):
        print("COCYCLE_COHERENCE_VERIFY_FAIL")
        return 1
    summary = json.load(open(summary_path))
    audit = json.load(open(audit_path)) if os.path.isfile(audit_path) else {}

    check("H1 headline OPEN / no degree exclusion",
          "OPEN" in summary.get("headline", "") and
          "excludes no degree" in summary.get("headline", ""))
    check("V1 primary verdict COCYCLE-ALREADY-IMPLIED",
          summary.get("verdict") == "COCYCLE-ALREADY-IMPLIED",
          str(summary.get("verdict")))

    # live re-audit both primes
    live = {}
    for p in (331, 661):
        print("--- live audit p=%d ---" % p)
        live[p] = audit_run(p, verbose=False)
        check("L1 p=%d verdict ALREADY-IMPLIED" % p,
              live[p]["verdict"] == "COCYCLE-ALREADY-IMPLIED",
              live[p]["verdict"])
        check("L2 p=%d orbit edges = 145" % p,
              live[p]["n_orbit_edges"] == 145,
              str(live[p]["n_orbit_edges"]))
        check("L3 p=%d missing_direct = 0" % p,
              live[p]["n_missing_direct"] == 0,
              str(live[p]["n_missing_direct"]))
        check("L4 p=%d BFS fail = 0" % p,
              live[p]["bfs_tree"]["n_fail"] == 0)
        check("L5 p=%d geometric 2-chain fail = 0" % p,
              live[p]["geometric_2chain"]["n_fail"] == 0)
        check("L6 p=%d eval arc failures = 0" % p,
              live[p]["eval_arc"]["n_arc_failures"] == 0)
        check("L7 p=%d core solutions = 43008" % p,
              live[p]["core_solutions"] == 43008,
              str(live[p]["core_solutions"]))
        # sealed audit match
        if str(p) in audit:
            check("L8 p=%d sealed audit verdict matches live" % p,
                  audit[str(p)].get("verdict") == live[p]["verdict"])
            check("L9 p=%d sealed n_triangles matches live" % p,
                  audit[str(p)].get("n_triangles") == live[p]["n_triangles"])

    check("C1 cross-prime triangle counts agree",
          live[331]["n_triangles"] == live[661]["n_triangles"])
    check("C2 cross-prime verdicts agree",
          live[331]["verdict"] == live[661]["verdict"])

    # J identity
    check("J1 J_before == sealed TUPLE_JOINT_RESIDUE",
          summary.get("J_before") == paths.J_TABLE,
          str(summary.get("J_before")))
    check("J2 J_after == J_before (identity under ALREADY-IMPLIED)",
          summary.get("J_after") == summary.get("J_before"))
    check("J3 no zero class",
          summary.get("any_zero") is False and summary.get("zeros") == [])
    check("J4 triangle_layer_size == 0 (no extra filter)",
          summary.get("triangle_layer_size") == 0)

    # d35 unchanged
    d35 = summary.get("d35", {})
    check("D1 d35 residue 5", d35.get("residue") == 5)
    check("D2 d35 J unchanged 1264",
          d35.get("J_before") == 1264 and d35.get("J_after") == 1264)
    check("D3 d35 cut 0", d35.get("cut") == 0)
    check("D4 d35 22-anchor unchanged",
          d35.get("anchor_22") == "unchanged")

    # per-class
    for row in summary.get("per_class", []):
        e = row["d_mod6"]
        check("P1 d≡%d cut 0" % e, row.get("cut") == 0)
        check("P2 d≡%d J_after > 0" % e, row.get("J_after", 0) > 0)

    n_fail = len(FAILS)
    n_pass = len(CHECKS) - n_fail
    print("--- %d checks, %d pass, %d fail ---" % (len(CHECKS), n_pass, n_fail))
    if n_fail:
        print("COCYCLE_COHERENCE_VERIFY_FAIL")
        return 1
    print("COCYCLE_COHERENCE_VERIFY_OK")
    print("ALLGREEN")
    return 0


if __name__ == "__main__":
    sys.exit(main())
