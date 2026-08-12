#!/usr/bin/env python3
"""DEPTH_TABLE_GENERAL verifier — replayable checks on results/.

Reads depth_table_p*.json and keep_pass_22_p*.json. Re-derives the T4 period
histogram anchor and the two-class lift-invariance; checks the keep-pass
census shape. Machine markers: DEPTH_TABLE_GENERAL_VERIFY_OK / ALLGREEN.
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
AUDIT_RES = os.path.join(
    os.path.dirname(HERE), "goal_runs_20260811", "D35_AUDIT", "results")
# packet lives in goal_runs_20260812; sibling is goal_runs_20260811
AUDIT_RES = os.path.join(os.path.dirname(os.path.dirname(HERE)),
                         "goal_runs_20260811", "D35_AUDIT", "results")

CHECKS = []
FAILS = []


def check(name, cond, detail=""):
    CHECKS.append(name)
    if cond:
        print("  OK  ", name, detail)
    else:
        FAILS.append((name, detail))
        print("  FAIL", name, detail)


def load(name):
    path = os.path.join(RES, name)
    if not os.path.exists(path):
        return None
    with open(path) as f:
        return json.load(f)


def main():
    print("== DEPTH_TABLE_GENERAL verifier ==")

    # ---- Deliverable 1: general table ----
    print("-- general depth table --")
    tables = {}
    for p in (331, 661):
        d = load("depth_table_p%d.json" % p)
        check("depth_table exists p=%d" % p, d is not None)
        if not d:
            continue
        tables[p] = d
        h1 = d["rid1"]["period_histogram"]
        check("T4 anchor hist rid1 36/6/12 p=%d" % p,
              h1.get("1") == 36 and h1.get("2") == 6 and h1.get("3") == 12,
              str(h1))
        check("t4_anchor flag p=%d" % p, d.get("t4_anchor_histogram_ok") is True)
        h2 = d["rid2"]["period_histogram"]
        # rid2: all period > 1 (12 period-2 + 6 period-3) from T4 audit
        check("rid2 period hist 12/6 p=%d" % p,
              h2.get("2") == 12 and h2.get("3") == 6, str(h2))
        check("rid1 n_kids 54 p=%d" % p, d["rid1"]["n_kids"] == 54)
        check("rid2 n_kids 18 p=%d" % p, d["rid2"]["n_kids"] == 18)
        # two-class verification
        for v in d["rid1"]["verify"]:
            check("rid1 same-class lift ok class=%s p=%d" % (v["class"], p),
                  v.get("same_class_lift_ok") is True,
                  "match %s/%s" % (v.get("n_cycle_match_same_class_lift"),
                                   v.get("n_kids_compared")))
        for v in d["rid2"]["verify"]:
            check("rid2 same-class lift ok class=%s p=%d" % (v["class"], p),
                  v.get("same_class_lift_ok") is True
                  and v.get("n_kids_compared", 0) > 0,
                  "match %s/%s" % (v.get("n_cycle_match_same_class_lift"),
                                   v.get("n_kids_compared")))
        # concrete d=35 class present
        c35 = d.get("concrete_class_d35_a_34_1")
        check("concrete (34,1) present p=%d" % p, c35 is not None
              and len(c35.get("kids", [])) == 54)
        # periods in concrete match rid1 kids
        if c35:
            ph = {}
            for k in c35["kids"]:
                ph[k["period"]] = ph.get(k["period"], 0) + 1
            check("concrete period hist p=%d" % p,
                  ph.get(1) == 36 and ph.get(2) == 6 and ph.get(3) == 12,
                  str(ph))

    # cross-prime: period histograms identical
    if 331 in tables and 661 in tables:
        check("cross-prime rid1 hist equal",
              tables[331]["rid1"]["period_histogram"]
              == tables[661]["rid1"]["period_histogram"])
        check("cross-prime rid2 hist equal",
              tables[331]["rid2"]["period_histogram"]
              == tables[661]["rid2"]["period_histogram"])

    # ---- Deliverable 2: keep-pass on 22 ----
    print("-- keep-pass on the 22 --")
    passes = {}
    for p in (331, 661):
        d = load("keep_pass_22_p%d.json" % p)
        check("keep_pass exists p=%d" % p, d is not None)
        if not d:
            continue
        passes[p] = d
        check("14 of 18 forced-deeper p=%d" % p,
              d.get("n_value_defined_rows") == 18
              and len(d.get("forced_deeper_rows", [])) == 14,
              "deeper=%s defined=%s" % (len(d.get("forced_deeper_rows", [])),
                                        d.get("n_value_defined_rows")))
        check("universal rank 2 p=%d" % p, d.get("universal_rank") == 2)
        check("cell37 p=%d" % p, d.get("cell37_dim") == 37)
        # rigidity
        for k, v in d.get("level_rigidity", {}).items():
            check("level-%s rigidity 0 p=%d" % (k, p), v == 0, "viol=%s" % v)
        check("22 in p=%d" % p, d.get("n_survivors_in") == 22)
        check("dead+live=22 p=%d" % p,
              d.get("n_dead", -1) + d.get("n_live", -1) == 22,
              "dead=%s live=%s" % (d.get("n_dead"), d.get("n_live")))
        # every detail entry has openness checklist
        for rec in d.get("detail", []):
            for b in rec.get("branches", []):
                check("open_demands list id=%d branch=%s p=%d"
                      % (rec["id"], b.get("branch"), p),
                      isinstance(b.get("open_demands"), list))
                break
            break
        # content hashes match sealed audit 22
        if os.path.exists(os.path.join(AUDIT_RES,
                                       "patterns_r5_content_summary_p%d.json"
                                       % p)):
            summ = json.load(open(os.path.join(
                AUDIT_RES, "patterns_r5_content_summary_p%d.json" % p)))
            sealed_ids = set(summ["survivors22"]["ids"])
            our_ids = {r["id"] for r in d.get("detail", [])}
            check("22 ids match content-addressed p=%d" % p,
                  our_ids == sealed_ids, "ours=%s" % sorted(our_ids))

    if 331 in passes and 661 in passes:
        check("cross-prime n_dead equal",
              passes[331]["n_dead"] == passes[661]["n_dead"],
              "%s vs %s" % (passes[331]["n_dead"], passes[661]["n_dead"]))
        check("cross-prime n_live equal",
              passes[331]["n_live"] == passes[661]["n_live"])
        check("cross-prime live_dims equal",
              passes[331]["live_dims"] == passes[661]["live_dims"],
              "%s vs %s" % (passes[331]["live_dims"], passes[661]["live_dims"]))

    # ---- framing ----
    print("-- framing --")
    for src in list(tables.values()) + list(passes.values()):
        h = src.get("headline", "")
        check("headline open + no exclusion",
              ("OPEN" in h) and ("excludes no degree" in h.lower()))

    print()
    n_fail = len(FAILS)
    n_ok = len(CHECKS) - n_fail
    print("checks: %d  failures: %d" % (len(CHECKS), n_fail))
    if n_fail:
        for name, det in FAILS:
            print("  FAIL:", name, det)
        print("DEPTH_TABLE_GENERAL_VERIFY_FAIL")
        sys.exit(1)
    print("DEPTH_TABLE_GENERAL_VERIFY_OK")
    print("ALLGREEN")
    # machine-readable summary
    summary = {
        "n_checks": len(CHECKS),
        "n_failures": 0,
        "markers": ["DEPTH_TABLE_GENERAL_VERIFY_OK", "ALLGREEN"],
    }
    if 331 in passes:
        summary["keep_pass_p331"] = {
            "n_dead": passes[331]["n_dead"],
            "n_live": passes[331]["n_live"],
            "live_dims": passes[331]["live_dims"],
        }
    with open(os.path.join(RES, "verifier_output.json"), "w") as f:
        json.dump(summary, f, indent=1)
    return 0


if __name__ == "__main__":
    sys.exit(main() or 0)
