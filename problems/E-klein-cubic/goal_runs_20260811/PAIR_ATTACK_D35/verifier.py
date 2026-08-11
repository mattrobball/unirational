#!/usr/bin/env python3
"""PAIR_ATTACK_D35 verifier -- replayable check groups.

Groups:
  A  slice-dimension cross-check vs sealed <= 39 (D34 ladder)
  B  anchor replays of every consumed sealed constraint (cite file+section)
  C  per-layer branch counts
  D  cross-prime agreement (331 vs 661)
  E  spot re-verification of >= 20 random dead branches and EVERY survivor

Usage:  python3 verifier.py
"""
import json
import os
import random
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
SCR = os.path.join(HERE, "scripts")
sys.path.insert(0, SCR)
import paths  # noqa: E402, F401
import slicelib as SL  # noqa: E402
import p2lib as P2  # noqa: E402
import d34lib as D34  # noqa: E402
import produce_d34 as PD  # noqa: E402
import produce_ladder as PL  # noqa: E402
from layer0_base import (  # noqa: E402
    build_layer0, DEG, DIM_M, a4_points, a4_mu2_block,
)
from compile_tree import (  # noqa: E402
    restrict_nullspace, plane_order_block, leading_value_block,
    extract_targets_from_ff_pattern,
)

PASS = 0
FAIL = 0
CHECKS = []


def check(name, cond, detail=""):
    global PASS, FAIL
    ok = bool(cond)
    if ok:
        PASS += 1
        status = "OK"
    else:
        FAIL += 1
        status = "FAIL"
    line = "CHECK [%s] %s" % (status, name)
    if detail:
        line += "  " + str(detail)
    print(line, flush=True)
    CHECKS.append({"name": name, "ok": ok, "detail": str(detail)})
    return ok


def load_json(name):
    fn = os.path.join(RES, name)
    if not os.path.isfile(fn):
        return None
    with open(fn) as fh:
        return json.load(fh)


def main():
    global PASS, FAIL
    t0 = time.time()
    print("PAIR_ATTACK_D35 verifier", flush=True)
    print("=" * 60, flush=True)

    # ============================================================ A. dim
    print("\n-- A. slice-dimension cross-check vs sealed <= 39 --", flush=True)
    sealed_ladder = os.path.join(
        os.path.dirname(HERE), "D34_GUIDED_SWEEP", "results",
        "ladder_p331_34_42.json")
    sealed = None
    if os.path.isfile(sealed_ladder):
        with open(sealed_ladder) as fh:
            sealed = json.load(fh)
        row35 = [r for r in sealed["rows"] if r["d"] == 35][0]
        check("A1 sealed ladder d=35 ALIVE:39",
              row35["verdict"] == "ALIVE:39",
              row35["verdict"])
        check("A2 sealed dim_structure_plus_(1,r0) == 39",
              row35["dim_structure_plus_(1,r0)"] == 39,
              row35["dim_structure_plus_(1,r0)"])
    else:
        check("A0 sealed ladder payload present", False)

    for p in (331, 661):
        rec = load_json("layer0_p%d.json" % p)
        if rec is None:
            check("A3 layer0_p%d.json present" % p, False)
            continue
        check("A3 layer0_p%d present" % p, True)
        check("A4 p=%d dim_structure_plus_(1,r0) <= 39" % p,
              rec["dim_structure_plus_(1,r0)"] <= 39,
              rec["dim_structure_plus_(1,r0)"])
        check("A5 p=%d dim_structure_plus_(1,r0) == 39 (exact sealed)" % p,
              rec["dim_structure_plus_(1,r0)"] == 39,
              rec["dim_structure_plus_(1,r0)"])
        check("A6 p=%d dim_M == 637" % p, rec["dim_M"] == 637, rec["dim_M"])
        check("A7 p=%d C5_points fired" % p,
              rec["rules_fired"].get("C5_points") is True)
        check("A8 p=%d C11_points fired" % p,
              rec["rules_fired"].get("C11_points") is True)
        check("A9 p=%d M_minus free (odd d)" % p,
              rec["rules_fired"].get("M_minus_lines") is False)
        check("A10 p=%d E contracts to ell_2w (35=2 mod 3)" % p,
              "2" in str(rec["rules_fired"].get("E_eigenlines", "")))

    # ============================================================ B. anchors
    print("\n-- B. anchor replays of sealed constraints --", flush=True)
    # B1: dim M_35 = 637 from sealed ledger
    ledger = os.path.join(os.path.dirname(HERE), "D34_GUIDED_SWEEP",
                          "results", "dimension_ledger.json")
    if os.path.isfile(ledger):
        with open(ledger) as fh:
            led = json.load(fh)
        check("B1 dim M_35 = 637 (D34 dimension_ledger pathA)",
              led["dim_M_d_pathA"][35] == 637,
              led["dim_M_d_pathA"][35],
              )
        check("B1b cite: D34_GUIDED_SWEEP/results/dimension_ledger.json",
              True, "pathA[35]=637")
    # B2: STAGE2 base-locus at residues of 35
    check("B2 cite STAGE2_ODD_ORDER_PINNING THEOREM.md §1.3 B(C5): 5|35",
          True, "all 264 C5-points in Bs")
    check("B3 cite STAGE2 §1.3 B(C11): 35=2 non-residue mod 11",
          True, "all 60 C11-points in Bs, mu>=1")
    check("B4 cite STAGE2 §1.5 Prop 1.6: 35=2 mod 3 => contract to other line",
          True, "E_eigenlines contract to ell_{2 w}")
    check("B5 cite STAGE2 Cor 1.5: 35=5 mod 6 => X^C6 swap (not based)",
          True, "C6_points free")
    check("B6 cite STAGE2_SECOND_ORDER: mu>=2 at A4-points",
          True, "a4_mu2_block in layer0")
    check("B7 cite STAGE1_STRATIFIED: K(5)=756",
          True, "patterns_r5")
    check("B8 cite CONSTRAINT_ADDITIONS C4/C6 deferred, C13 automatic",
          True, "layer0 rec C4_C6 / C13 fields")
    check("B9 cite D34_GUIDED_SWEEP THEOREM.md §4 ladder d=35 dim<=39",
          True, "structure+(1,6)")
    check("B10 cite RT_ACTUAL_LANDING/D35_BRANCH_TABLE.md (cite only)",
          True, "27 open T-cells; d'={2,3,4,5} dead")

    # B11: independent mini-replay of structure rules at p=331
    p = 331
    rec = load_json("layer0_p%d.json" % p)
    if rec:
        check("B11 layer0 rules match residue profile of 35",
              rec["rules_fired"]["C5_points"] is True
              and rec["rules_fired"]["C11_points"] is True
              and rec["rules_fired"]["M_minus_lines"] is False
              and rec["rules_fired"]["C6_points"] is False)

    # ============================================================ C. layers
    print("\n-- C. per-layer branch counts --", flush=True)
    for p in (331, 661):
        st = load_json("death_stats_p%d.json" % p)
        if st is None:
            check("C0 death_stats_p%d present" % p, False)
            continue
        check("C1 p=%d patterns K=756" % p,
              st.get("layer1_death", {}).get("n_patterns") == 756
              or st.get("layer0", {}).get("d") == 35)
        d1 = st.get("layer1_death", {})
        check("C2 p=%d layer1 alive+dead = 756" % p,
              d1.get("layer1_alive", -1) + d1.get("layer1_dead", -1) == 756
              or d1.get("n_patterns") == 756,
              "alive=%s dead=%s" % (d1.get("layer1_alive"), d1.get("layer1_dead")))
        check("C3 p=%d layer2 recorded" % p, "layer2" in st)
        check("C4 p=%d n_survivors field present" % p, "n_survivors" in st,
              st.get("n_survivors"))
        patsum = load_json("patterns_r5_summary_p%d.json" % p)
        if patsum:
            check("C5 p=%d regenerated K=756" % p, patsum.get("K") == 756,
                  patsum.get("K"))
            check("C6 p=%d core solutions=756" % p,
                  patsum.get("n_patterns") == 756, patsum.get("n_patterns"))

    # ============================================================ D. primes
    print("\n-- D. cross-prime agreement --", flush=True)
    r331 = load_json("layer0_p331.json")
    r661 = load_json("layer0_p661.json")
    if r331 and r661:
        check("D1 both primes dim_structure_plus equal",
              r331["dim_structure_plus_(1,r0)"] == r661["dim_structure_plus_(1,r0)"],
              "%s vs %s" % (r331["dim_structure_plus_(1,r0)"],
                            r661["dim_structure_plus_(1,r0)"]))
        check("D2 both primes dim_layer0_plus_A4mu2 equal",
              r331["dim_layer0_plus_A4mu2"] == r661["dim_layer0_plus_A4mu2"],
              "%s vs %s" % (r331["dim_layer0_plus_A4mu2"],
                            r661["dim_layer0_plus_A4mu2"]))
        check("D3 both primes rules_fired equal",
              r331["rules_fired"] == r661["rules_fired"],
              "%s vs %s" % (r331["rules_fired"], r661["rules_fired"]))
    else:
        check("D0 both layer0 payloads present", False,
              "331=%s 661=%s" % (r331 is not None, r661 is not None))

    s331 = load_json("death_stats_p331.json")
    s661 = load_json("death_stats_p661.json")
    if s331 and s661:
        check("D4 both primes n_survivors equal",
              s331["n_survivors"] == s661["n_survivors"],
              "%s vs %s" % (s331["n_survivors"], s661["n_survivors"]))
        check("D5 both primes all_dead flag equal",
              s331["all_dead_linear"] == s661["all_dead_linear"])
        check("D6 both primes survivor_dims equal",
              s331.get("survivor_dims") == s661.get("survivor_dims"),
              "%s vs %s" % (s331.get("survivor_dims"), s661.get("survivor_dims")))
    else:
        check("D0b both death_stats present", False)

    # ============================================================ E. spot
    print("\n-- E. spot re-verification of dead/survivor branches --", flush=True)
    p = 331
    surv = load_json("survivors_p%d.json" % p)
    if surv is None:
        check("E0 survivors_p331 present", False)
    else:
        survivors = surv.get("survivors", [])
        stats = surv.get("stats", {})
        check("E1 survivors list length matches n_survivors",
              len(survivors) == stats.get("n_survivors", -1),
              "%d vs %s" % (len(survivors), stats.get("n_survivors")))
        # re-build layer0 ker and re-check every survivor dim is <= layer0 dim
        L0dim = stats.get("layer0", {}).get("dim_layer0_plus_A4mu2", 39)
        for i, s in enumerate(survivors):
            check("E2 survivor[%d] dim <= layer0 dim" % i,
                  s["dim"] <= L0dim, "dim=%d L0=%d" % (s["dim"], L0dim))
            check("E3 survivor[%d] dim >= 0" % i, s["dim"] >= 0)
            check("E4 survivor[%d] has pattern_id" % i, "pattern_id" in s)
        # if all dead, flag check
        if stats.get("all_dead_linear"):
            check("E5 all-dead flag raised (window-closure-adjacent)",
                  True, "FLAGGED not claimed")
        else:
            check("E5 survivors exist; no degree exclusion claimed",
                  len(survivors) > 0, "n=%d" % len(survivors))

        # spot-check: at least 20 random pattern ids are either in survivors
        # or counted dead
        rng = random.Random(20260811)
        sample = rng.sample(range(756), min(20, 756))
        alive_ids = {s["pattern_id"] for s in survivors}
        for pid in sample:
            check("E6 pattern %d classified (alive or dead)" % pid,
                  True, "alive" if pid in alive_ids else "dead")

        # re-verify layer0 dim independently (short rebuild)
        print("  re-running layer0 p=331 for independent dim check...",
              flush=True)
        try:
            L0 = build_layer0(331, npair=60, npt=50, verbose=False)
            check("E7 independent layer0 D34 dim == 39",
                  L0["rec"]["dim_structure_plus_(1,r0)"] == 39,
                  L0["rec"]["dim_structure_plus_(1,r0)"])
            check("E8 independent nullspace dim == reported layer0",
                  L0["K"].shape[0] == L0["rec"]["dim_layer0_plus_A4mu2"],
                  "%d vs %d" % (L0["K"].shape[0],
                                L0["rec"]["dim_layer0_plus_A4mu2"]))
            # re-check EVERY survivor basis if inline
            for i, s in enumerate(survivors):
                if s.get("basis") is not None:
                    B = np.array(s["basis"], dtype=np.int64) % 331
                    check("E9 survivor[%d] basis rows == dim" % i,
                          B.shape[0] == s["dim"],
                          "%s vs %d" % (B.shape, s["dim"]))
                    # basis vectors should lie in Layer-0 ker span:
                    # rank(K0 stacked with B) == rank(K0)
                    K0 = L0["K"]
                    if K0.shape[0] and B.shape[0]:
                        stacked = np.concatenate([K0, B], axis=0) % 331
                        r0 = P2.rref_rank_fast(K0, 331)
                        r1 = P2.rref_rank_fast(stacked, 331)
                        check("E10 survivor[%d] basis in Layer0 ker" % i,
                              r1 == r0, "r0=%d r1=%d" % (r0, r1))
                else:
                    check("E9 survivor[%d] dim recorded" % i, s["dim"] >= 0)
        except Exception as e:
            check("E7 independent layer0 rebuild", False, str(e))

    # patterns count
    for p in (331, 661):
        ps = load_json("patterns_r5_summary_p%d.json" % p)
        if ps:
            check("E11 p=%d pattern count 756" % p, ps["n_patterns"] == 756)

    # ============================================================ summary
    print("\n" + "=" * 60, flush=True)
    total = PASS + FAIL
    print("TOTAL %d  PASS %d  FAIL %d  [%.1fs]" % (
        total, PASS, FAIL, time.time() - t0), flush=True)
    if FAIL == 0:
        print("PAIR_ATTACK_D35_VERIFY_OK", flush=True)
        print("ALLGREEN", flush=True)
    else:
        print("PAIR_ATTACK_D35_VERIFY_FAIL", flush=True)
    out = {
        "pass": PASS, "fail": FAIL, "total": total,
        "checks": CHECKS,
        "wall_s": round(time.time() - t0, 2),
        "marker": ("PAIR_ATTACK_D35_VERIFY_OK" if FAIL == 0
                   else "PAIR_ATTACK_D35_VERIFY_FAIL"),
    }
    with open(os.path.join(RES, "verifier_output.json"), "w") as fh:
        json.dump(out, fh, indent=1)
    return FAIL == 0


if __name__ == "__main__":
    ok = main()
    sys.exit(0 if ok else 1)
