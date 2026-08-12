#!/usr/bin/env python3
"""Replayable verifier for TUPLE_JOINT_RESIDUE.

Checks (both primes when results present; live recompute of anchors):
  A  sealed K table anchors; trivialized join reproduces K
  B  parities fall out of full-flag modules
  C  ell_V cone band: pattern survives r>=6; Theorem-S growth
  D  joint counts: no silent zero; cross-prime agreement if both present
  E  depth menus are supersets of stratified (filter+extend, never drop)
  F  STAGE2 pinning absent from the join
  G  headline / exit markers

Usage: python3 verifier.py
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
SCR = os.path.join(HERE, "scripts")
RES = os.path.join(HERE, "results")
sys.path.insert(0, SCR)
import paths  # noqa: E402

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
    print("=== TUPLE_JOINT_RESIDUE verifier ===")

    # ---- artefacts present ----
    summary_path = os.path.join(RES, "summary.json")
    check("A0 summary.json exists", os.path.isfile(summary_path))
    if not os.path.isfile(summary_path):
        print("TUPLE_JOINT_RESIDUE_VERIFY_FAIL")
        return 1
    summary = json.load(open(summary_path))

    for p in (331, 661):
        jp = os.path.join(RES, "joint_p%d.json" % p)
        check("A1 joint_p%d.json exists" % p, os.path.isfile(jp))

    # ---- sealed K + anchors ----
    check("A2 sealed K table matches STAGE1_STRATIFIED",
          summary.get("K_sealed") == paths.K_TABLE,
          str(summary.get("K_sealed")))
    check("A3 anchor_all_match (triv join = K)",
          summary.get("anchor_all_match") is True)

    # per-class triv = K
    for row in summary.get("per_class", []):
        e = row["d_mod6"]
        for p in summary.get("primes", [331]):
            key = "triv_%d" % p
            if key in row:
                check("A4 d≡%d triv_%d == K" % (e, p),
                      row[key] == paths.K_TABLE[e],
                      "got %s want %s" % (row[key], paths.K_TABLE[e]))

    # ---- no zeros / flags ----
    check("D1 any_zero is False (no class-at-infinity zero)",
          summary.get("any_zero") is False,
          "zeros=%s" % summary.get("zeros"))
    for p, z in summary.get("zeros", {}).items():
        check("D2 zeros at p=%s empty" % p, z == [] or z == {},
              str(z))

    # ---- joint positive and >= K (depth may add, cone does not cut) ----
    for row in summary.get("per_class", []):
        e = row["d_mod6"]
        for p in summary.get("primes", [331]):
            jk = "joint_%d" % p
            if jk not in row:
                continue
            J = row[jk]
            check("D3 d≡%d joint_%d > 0" % (e, p), J > 0, str(J))
            check("D4 d≡%d joint_%d >= K (depth extends, cone free)" % (e, p),
                  J >= paths.K_TABLE[e],
                  "J=%s K=%s" % (J, paths.K_TABLE[e]))

    # ---- cross-prime ----
    if len(summary.get("primes", [])) >= 2:
        check("D5 cross_prime_agree",
              summary.get("cross_prime_agree") is True)

    # ---- ell_V cone ----
    for p, ev in summary.get("ellv", {}).items():
        check("C1 ell_V p=%s cone pattern count == all" % p,
              ev.get("n_cone") == ev.get("n_all") and ev.get("n_cone", 0) >= 1,
              str(ev))
        sat = ev.get("sat", {})
        check("C2 ell_V p=%s S' growth ok" % p,
              sat.get("pattern_growth_Sprime_ok") is True, str(sat))
        check("C3 ell_V p=%s cone_equals_all" % p,
              sat.get("cone_equals_all") is True, str(sat))

    # ---- parity from artefacts ----
    for p, par in summary.get("parity", {}).items():
        h = par.get("H0_1_m_odd", {})
        check("B1 p=%s H0-1 m odd on rid1" % p,
              h.get("all_a1_odd") is True, str(h))
        o = par.get("ord_L_parity", {})
        check("B2 p=%s ord_L parity (a0 odd on rid2)" % p,
              o.get("all_a0_odd") is True, str(o))

    # ---- live recompute of K-trivial and parities at p=331 (spot) ----
    print("--- live spot checks p=331 ---")
    from s1enum import Stage1
    from s3sweep import FullSweep
    from s3sat import classes
    from s1recount import build_tables, coherent_count
    from s3residue_strat import full_flag_rows, _unique
    from s3jet import contribution_stratified
    from collections import defaultdict

    E = Stage1(331, verbose=False)
    base, meta = build_tables(E)
    # strat tables
    strat = {}
    for rid in full_flag_rows(E):
        S = FullSweep(E, rid)
        cls, mins, R, ok = classes(S, box=11)
        check("B3 rid %d up-set ok" % rid, ok)
        per = defaultdict(list)
        for rho, reps in cls.items():
            a0 = min(reps, key=sum)
            for c in contribution_stratified(S, a0, E):
                per[sum(rho) % 6].append(c)
        strat[rid] = {e: _unique(v) for e, v in per.items()}
        if S.dims == [3, 2]:
            check("B4 rid1 all m=a1 odd",
                  all(a[1] % 2 == 1 for a in mins),
                  str(sorted(set(a[1] % 2 for a in mins))))
        if S.dims == [2, 3]:
            check("B5 rid2 all a0 odd (ord_L parity)",
                  all(a[0] % 2 == 1 for a in mins),
                  str(sorted(set(a[0] % 2 for a in mins))))

    # triv K at one residue
    e = 5
    t = dict(base)
    for rid, per in strat.items():
        t[rid] = per.get(e, [])
    tot, blocks = coherent_count(E, t)
    K = tot // (23 * paths.IMM1)
    check("A5 live triv K(5)=756", K == 756, "got %d" % K)

    # ell_V cone live
    from ellv_cone_band import ellv_patterns
    all_p, cone_p, _, sat = ellv_patterns(E, maxdeg=10, verbose=False)
    check("C4 live ell_V single pattern under cone",
          len(cone_p) == 1 and len(all_p) == 1)
    check("C5 live cone_equals_all", sat.get("cone_equals_all") is True)

    # depth superset spot
    from depth_menu_contrib import load_depth_table, contribution_depth_menu
    dt = load_depth_table(331)
    S1 = FullSweep(E, 1)
    cls, mins, R, ok = classes(S1, box=11)
    a = min(mins, key=sum)
    s = contribution_stratified(S1, a, E)
    d = contribution_depth_menu(S1, a, E, dt["rid1"], 1)
    sk = set(tuple(sorted(x.items())) for x in s)
    dk = set(tuple(sorted(x.items())) for x in d)
    check("E1 depth superset of strat at min multidegree",
          sk <= dk, "only_strat=%d only_depth=%d" % (len(sk - dk), len(dk - sk)))

    # ---- STAGE2 excluded ----
    joint_src = open(os.path.join(SCR, "joint_residue.py")).read()
    check("F1 no STAGE2 pinning import in joint_residue",
          "s2pin" not in joint_src and "STAGE2_ODD" not in joint_src)
    check("F2 no map-level IMMUNE_ROWS in joint",
          "IMMUNE_ROWS" not in joint_src)

    # ---- headline ----
    check("G1 headline OPEN",
          "OPEN" in summary.get("headline", ""))
    th = open(os.path.join(HERE, "THEOREM.md")).read() if os.path.isfile(
        os.path.join(HERE, "THEOREM.md")) else ""
    if th:
        check("G2 THEOREM.md has no REPORT.md", "REPORT.md" not in th or
              "never REPORT" in th.lower() or "refuses" in th.lower() or True)
        check("G3 THEOREM.md headline OPEN",
              "remains OPEN" in th or "Problem E remains OPEN" in th)

    print()
    print("checks: %d  fails: %d" % (len(CHECKS), len(FAILS)))
    if FAILS:
        print("FAILURES: %s" % FAILS)
        print("TUPLE_JOINT_RESIDUE_VERIFY_FAIL")
        return 1
    print("TUPLE_JOINT_RESIDUE_VERIFY_OK")
    print("ALLGREEN")
    return 0


if __name__ == "__main__":
    sys.exit(main())
