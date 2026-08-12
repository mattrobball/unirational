#!/usr/bin/env python3
"""Replayable verifier for RAMIFICATION_COMPLEX.

Checks:
  A  artefacts present; headline OPEN; no REPORT.md
  B  PATH A/B weight-rule cross-check (1200 cases, 0 mismatch)
  C  receiver tangent-cone: C11 hyperplane x_{j+1}=0; formula ≡ −3a;
     machine at p=331,661
  D  conormal tables: 15 sweep + 22 immune = 37 rows; both primes
  E  join: J_ram = J sealed; no zero; ODDZERO discipline
  F  d=35: 22-anchor intact; 0 closed kills on the 22
  G  lemma engine: weight rule specialises to STAGE2 pathA on point strata
  H  cross-prime agreement

Usage: python3 verifier.py
"""
from __future__ import annotations

import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
SCR = os.path.join(HERE, "scripts")
RES = os.path.join(HERE, "results")
sys.path.insert(0, SCR)
import paths  # noqa: E402
from weight_rule import pathA_weight, SPECTRUM, QR11  # noqa: E402
from tangent_cone import (  # noqa: E402
    all_c11_tangent_cones, machine_c11, c11_coord_cycle_weights,
)
from s2pin import pathA_weight as s2_pathA  # noqa: E402

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
    print("=== RAMIFICATION_COMPLEX verifier ===")

    # A artefacts
    check("A0 no REPORT.md",
          not os.path.isfile(os.path.join(HERE, "REPORT.md")))
    check("A1 THEOREM.md present",
          os.path.isfile(os.path.join(HERE, "THEOREM.md")))
    check("A2 REGISTRATION_SNIPPET.md present",
          os.path.isfile(os.path.join(HERE, "REGISTRATION_SNIPPET.md")))
    summary_path = os.path.join(RES, "summary.json")
    check("A3 summary.json present", os.path.isfile(summary_path))
    if not os.path.isfile(summary_path):
        print("RAMIFICATION_COMPLEX_VERIFY_FAIL")
        return 1
    summary = json.load(open(summary_path))
    check("A4 headline OPEN / excludes no degree",
          "OPEN" in summary.get("headline", "")
          and "excludes no degree" in summary.get("headline", ""))

    for name in (
        "pathAB_crosscheck.json", "receiver_tangent_cone.json",
        "join_summary.json", "d35_effects.json",
        "conormal_tables_p331.json", "conormal_tables_p661.json",
        "conormal_summary_p331.json", "joint_table.txt",
        "conormal_table_sizes.txt", "immune_residue_status.json",
    ):
        check("A5 %s" % name, os.path.isfile(os.path.join(RES, name)))

    # B PATH A/B
    ab = json.load(open(os.path.join(RES, "pathAB_crosscheck.json")))
    check("B1 pathAB ok", ab.get("ok") is True, str(ab))
    check("B2 pathAB checked ≥ 1000", ab.get("checked", 0) >= 1000)
    check("B3 pathAB mismatches == 0", ab.get("mismatches") == 0)

    # live recompute a few PATH A vs STAGE2
    for n, d, ak, chain in (
        (11, 35, 9, [(1, 3)]),
        (5, 35, 1, [(2, 2)]),
        (3, 34, 1, [(1, 1), (1, 2)]),
        (6, 35, 1, [(1, 4)]),
    ):
        w1 = pathA_weight(n, d * ak, chain)
        w2 = s2_pathA(n, d, ak, chain)
        check("B4 pathA≡s2pin n=%d d=%d" % (n, d), w1 == w2,
              "%s vs %s" % (w1, w2))

    # C tangent cone
    tc = json.load(open(os.path.join(RES, "receiver_tangent_cone.json")))
    check("C1 C11 formula all match (−3a = a_{j+1}−a_j)",
          tc.get("C11_formula_all_match") is True)
    for p in (331, 661):
        check("C2 C11 machine hyperplane p=%d" % p,
              tc.get("C11_machine_ok", {}).get(str(p)) is True)
    # live recompute
    cyc = c11_coord_cycle_weights()
    check("C3 coord cycle starts at 1 and closes",
          cyc[0] == 1 and (-2 * cyc[-1]) % 11 == 1 and len(set(cyc)) == 5,
          str(cyc))
    for row in all_c11_tangent_cones():
        check("C4 live formula_match w=%d" % row["weight"],
              row["formula_match"] is True, str(row))
    for p in (331, 661):
        rows = machine_c11(p)
        check("C5 live machine p=%d all x_{j+1}=0" % p,
              all(r["hyperplane_is_x_j1"] for r in rows))

    # D conormal tables
    for p in (331, 661):
        sm = json.load(open(os.path.join(RES, "conormal_summary_p%d.json" % p)))
        check("D1 p=%d tabulated 37" % p, sm.get("n_tabulated") == 37)
        check("D2 p=%d n_sweep 15" % p, sm.get("n_sweep") == 15)
        check("D3 p=%d n_immune 22" % p, sm.get("n_immune") == 22)
        check("D4 p=%d no dead values (degree-free)" % p,
              sm.get("total_dead_values") == 0,
              str(sm.get("total_dead_values")))
        tabs = json.load(open(os.path.join(RES, "conormal_tables_p%d.json" % p)))
        ids = sorted(t["id"] for t in tabs)
        check("D5 p=%d ids = TABULATED" % p, ids == paths.TABULATED, str(ids))
        # every immune row has conormal_weights from STAGE2 chain
        for t in tabs:
            if t["role"] == "immune":
                check("D6 immune #%d has conormal" % t["id"],
                      len(t["conormal_weights"]) >= 1)

    # E join
    js = json.load(open(os.path.join(RES, "join_summary.json")))
    check("E1 join J_sealed matches TUPLE_JOINT",
          js.get("J_sealed") == paths.J_TABLE, str(js.get("J_sealed")))
    check("E2 any_zero is False", js.get("any_zero") is False,
          str(js.get("zeros")))
    check("E3 ramification_free (cut=0 all ρ)",
          js.get("ramification_free") is True)
    for row in js.get("per_class", []):
        e = row["d_mod6"]
        check("E4 ρ=%d J_ram == J_sealed" % e,
              row["J_ram"] == row["J_sealed"] == paths.J_TABLE[e],
              str(row))
        check("E5 ρ=%d not zero" % e, row["zero"] is False)
        check("E6 ρ=%d J_ram > 0" % e, row["J_ram"] > 0)

    # F d=35
    d35 = json.load(open(os.path.join(RES, "d35_effects.json")))
    check("F1 d=35", d35.get("d") == 35)
    for p in (331, 661):
        check("F2 p=%d anchor intact" % p,
              d35["anchor_22_intact"].get(p) is True
              or d35["anchor_22_intact"].get(str(p)) is True)
        nk = d35["n_closed_kills_on_22"].get(p,
             d35["n_closed_kills_on_22"].get(str(p)))
        check("F3 p=%d zero closed kills on 22" % p, nk == 0, str(nk))
        pp = d35["per_prime"][str(p)]
        check("F4 p=%d n_anchor_hashes == 22" % p,
              pp.get("n_anchor_hashes") == 22)
    check("F5 cross_prime_count_agree",
          d35.get("cross_prime_count_agree") is True)

    # G lemma specialisation: w = d a_k + Σ μ c  recovers STAGE2 on C11
    # d=1, a_k=9, μ=0 → w=9; d=3, μ=0 → w=27≡5; both in Q
    check("G1 level0 d=1 base9 → 9",
          pathA_weight(11, 1 * 9, []) == 9)
    check("G2 level0 d=3 base9 → 5",
          pathA_weight(11, 3 * 9, []) == 5)
    check("G3 nonresidue d=2 base9 → 7 ∉ Q (Bs)",
          pathA_weight(11, 2 * 9, []) == 7 and 7 not in QR11)
    check("G4 d=35≡2 mod11 level0 Bs flag",
          (35 % 11) not in QR11)

    # H summary consistency
    check("H1 summary.join.ramification_free",
          summary["join"]["ramification_free"] is True)
    check("H2 summary.join.any_zero False",
          summary["join"]["any_zero"] is False)
    check("H3 summary.tc_C11_ok", summary.get("tc_C11_ok") is True)
    check("H4 summary.pathAB.ok", summary.get("pathAB", {}).get("ok") is True)

    print()
    print("checks: %d  fails: %d" % (len(CHECKS), len(FAILS)))
    if FAILS:
        print("RAMIFICATION_COMPLEX_VERIFY_FAIL")
        for f in FAILS:
            print("  ", f)
        return 1
    print("RAMIFICATION_COMPLEX_VERIFY_OK")
    print("ALLGREEN")
    return 0


if __name__ == "__main__":
    sys.exit(main())
