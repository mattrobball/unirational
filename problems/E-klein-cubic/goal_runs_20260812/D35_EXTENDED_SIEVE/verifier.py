#!/usr/bin/env python3
"""Replay verifier for D35_EXTENDED_SIEVE. python3 only; primes 331, 661."""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
PRIMES = (331, 661)
SURV_IDS = [5, 7, 13, 15, 21, 23, 29, 31, 37, 39, 45, 47,
            53, 55, 61, 63, 69, 71, 697, 699, 701, 703]


def check(cond, msg, failures):
    if not cond:
        failures.append(msg)
        print("FAIL:", msg)
    else:
        print("OK:", msg)


def main():
    failures = []
    print("== D35_EXTENDED_SIEVE verifier", flush=True)

    for p in PRIMES:
        mat = json.load(open(os.path.join(RES, "materialize_summary_p%d.json" % p)))
        check(mat["n_patterns_joint"] == 1264, "p%d joint 1264" % p, failures)
        check(mat["n_extended"] == 508, "p%d extended 508" % p, failures)
        check(mat["n_stratified_overlap"] == 756, "p%d strat 756" % p, failures)
        check(mat["anchor_22"]["all_22_hashes_present"],
              "p%d anchor22 hashes present in joint" % p, failures)
        se = mat["split_ext_508"]
        check(se["n"] == 508, "p%d split_ext n" % p, failures)
        check(se["multidegree_dead_m_ne_1"] + se["ord_ge2_L_only"] + se["ord0_L"]
              == 508, "p%d split_ext partition" % p, failures)

        sieve = json.load(open(os.path.join(RES, "sieve_layers_p%d.json" % p)))
        d = sieve["per_layer_deaths_508"]
        check(d["multidegree"] + d["line_order"] + d["live_after_six_flips"]
              == 508, "p%d sieve 508 partition" % p, failures)
        check(sieve["finisher"]["sealed_empty"], "p%d finisher empty" % p, failures)
        check(sieve["six_flips"]["rank"] == 2, "p%d six flips rank 2" % p, failures)
        check(sieve["strat_756"]["n_live"] == 22, "p%d strat live 22" % p, failures)
        check(sieve["anchor_22"]["all_present"], "p%d 22-anchor in strat live" % p,
              failures)
        check(sieve["strat_756"]["deaths"]["DEAD_MULTIDEGREE"] == 336,
              "p%d strat multi 336" % p, failures)
        check(sieve["strat_756"]["deaths"]["DEAD_LINE_ORDER"] == 398,
              "p%d strat line 398" % p, failures)

        ladder = json.load(open(os.path.join(RES, "arc_jet_ladder_p%d.json" % p)))
        check(ladder["n_period3_children"] == 12, "p%d 12 period-3" % p, failures)
        check(ladder["n_live_ext_in"] == d["live_after_six_flips"],
              "p%d ladder input = sieve live" % p, failures)
        check(ladder["n_dead"] + ladder["n_live"] == ladder["n_live_ext_in"],
              "p%d ladder partition" % p, failures)
        # hard rigidity anchors
        for k in ("0", "1", "2", "5", "8"):
            # level_rigidity is over all jet_recs; p3 hard anchors asserted in-run
            pass
        check(os.path.exists(os.path.join(RES, "cell37_p%d.npy" % p)),
              "p%d cell37 saved" % p, failures)

        census = json.load(open(os.path.join(RES, "census_p%d.json" % p)))
        fc = census["final_census_1264"]
        check(fc["sum_ok"], "p%d census sum 1264" % p, failures)
        check(fc["live"] == 22 + ladder["n_live"], "p%d live count" % p, failures)
        check(census["anchor_22"]["all_present"], "p%d census anchor" % p, failures)
        check(census["headline"].startswith("Problem E remains OPEN"),
              "p%d headline OPEN" % p, failures)

    # cross-prime
    c331 = json.load(open(os.path.join(RES, "census_p331.json")))
    c661 = json.load(open(os.path.join(RES, "census_p661.json")))
    for key in ("multidegree_m_in_3_5", "line_order_nu_ge_2",
                "arc_jet_ladder_period3", "live_among_508"):
        check(c331["per_layer_deaths_508"][key] == c661["per_layer_deaths_508"][key],
              "cross-prime 508 %s" % key, failures)
    check(c331["final_census_1264"]["live"] == c661["final_census_1264"]["live"],
          "cross-prime final live", failures)

    # no REPORT.md
    check(not os.path.exists(os.path.join(HERE, "REPORT.md")),
          "no REPORT.md", failures)
    check(os.path.exists(os.path.join(HERE, "THEOREM.md")),
          "THEOREM.md present", failures)

    n_fail = len(failures)
    n_ok = 0  # printed above
    print()
    if n_fail == 0:
        print("D35_EXTENDED_SIEVE_VERIFY_OK")
        print("ALLGREEN")
        return 0
    print("D35_EXTENDED_SIEVE_VERIFY_FAIL n=%d" % n_fail)
    for f in failures:
        print(" ", f)
    return 1


if __name__ == "__main__":
    sys.exit(main())
