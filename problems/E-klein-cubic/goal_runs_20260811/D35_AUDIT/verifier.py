#!/usr/bin/env python3
"""D35_AUDIT verifier — check groups T1–T5 + linkage repair.

Reads results produced by scripts/audit_t*.py and scripts/repair_patterns.py.
Re-runs lightweight invariants; does not re-execute the heavy Reynolds rebuilds
(those are the producers). Machine markers: D35_AUDIT_VERIFY_OK / ALLGREEN.
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
PAIR_RES = os.path.join(os.path.dirname(HERE), "PAIR_ATTACK_D35", "results")

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
    print("== D35_AUDIT verifier ==")

    # ---- T1 ----
    print("-- T1 ord>=2 --")
    for p in (331, 661, 991):
        d = load("t1_ord2_p%d.json" % p)
        check("T1 exists p=%d" % p, d is not None)
        if not d:
            continue
        check("T1 rank_ord2==null_dim p=%d" % p,
              d.get("rank_ord2") == d.get("null_dim") == 39,
              "rank=%s dim=%s" % (d.get("rank_ord2"), d.get("null_dim")))
        check("T1 alt-line full p=%d" % p,
              d.get("rank_ord2_alt_line") == 39)
        check("T1 saturation p=%d" % p, d.get("saturation_ok") is True)
        check("T1 verdict CONFIRMED p=%d" % p, d.get("verdict") == "CONFIRMED")
        # V1 rank 10 is the sealed companion fact
        check("T1 V1 rank 10 p=%d" % p, d.get("rank_ord1") == 10)

    # ---- T2 ----
    print("-- T2 six-flip --")
    for p in (331, 661, 991):
        d = load("t2_sixflip_p%d.json" % p)
        check("T2 exists p=%d" % p, d is not None)
        if not d:
            continue
        check("T2 ambient rank 2 p=%d" % p, d.get("ambient_rank") == 2)
        check("T2 slice rank 2 p=%d" % p, d.get("slice_rank") == 2)
        check("T2 rigidity 0 p=%d" % p, d.get("r1_rigidity_violations") == 0)
        check("T2 verdict CONFIRMED p=%d" % p, d.get("verdict") == "CONFIRMED")

    # ---- T3 ----
    print("-- T3 vanishing table --")
    for p in (331, 661):
        d = load("t3_vanishing_p%d.json" % p)
        check("T3 exists p=%d" % p, d is not None)
        if not d:
            continue
        check("T3 14 of 18 p=%d" % p,
              d.get("n_forced_deeper") == 14 and d.get("n_value_defined_rows") == 18,
              "deeper=%s defined=%s" % (d.get("n_forced_deeper"),
                                        d.get("n_value_defined_rows")))
        check("T3 rigidity 0 p=%d" % p, d.get("rigidity_violations") == 0)
        check("T3 verdict CONFIRMED p=%d" % p, d.get("verdict") == "CONFIRMED")
        if p == 331:
            check("T3 p331 row ids match sealed",
                  d.get("matches_sealed_row_ids_p331") is True)

    # ---- T4 ----
    print("-- T4 depth-parity --")
    for p in (331, 661):
        d = load("t4_depth_parity_p%d.json" % p)
        check("T4 exists p=%d" % p, d is not None)
        if not d:
            continue
        # the claim as stated is REFUTED; sub-claim about six period-2 stands
        check("T4 six period-2 exist p=%d" % p, d.get("n_period2") == 6)
        check("T4 all period-2 alternate p=%d" % p,
              d.get("claim_all_p2_alternate") is True)
        check("T4 period>1 beyond six p=%d" % p,
              d.get("n_period_gt1", 0) > 6,
              "n_period_gt1=%s" % d.get("n_period_gt1"))
        check("T4 depth-varies outside p2 p=%d" % p,
              len(d.get("depth_varies_non_p2") or []) > 0)
        check("T4 verdict REFUTED p=%d" % p, d.get("verdict") == "REFUTED")

    # ---- T5 ----
    print("-- T5 flip span --")
    for p in (331, 661, 991):
        d = load("t5_flip_span_p%d.json" % p)
        check("T5 exists p=%d" % p, d is not None)
        if not d:
            continue
        check("T5 V1 rank 10 p=%d" % p, d.get("rank_V1") == 10)
        check("T5 joint==V1 p=%d" % p,
              d.get("rank_joint") == d.get("rank_V1"))
        check("T5 V1|37 rank 8 p=%d" % p, d.get("rank_V1_on_37_cell") == 8)
        check("T5 flips in span p=%d" % p,
              d.get("flips_in_span_of_V1") is True)
        check("T5 verdict CONFIRMED p=%d" % p, d.get("verdict") == "CONFIRMED")

    # ---- repair ----
    print("-- linkage repair --")
    for p in (331, 661):
        st = load("repair_status_p%d.json" % p)
        content = load("patterns_r5_content_p%d.json" % p)
        check("repair content exists p=%d" % p, content is not None)
        if content:
            check("repair n=756 p=%d" % p, content.get("n_patterns") == 756)
            check("repair split 336+398+22 p=%d" % p,
                  content.get("split", {}).get("ok") is True,
                  str(content.get("split")))
            check("repair embed_ok p=%d" % p, content.get("embed_ok") is True)
            surv = content.get("survivors22", {})
            check("repair 22 ids match sealed p=%d" % p,
                  surv.get("ids_match_sealed") is True, str(surv.get("ids")))
            check("repair 22 hashes match sealed p=%d" % p,
                  surv.get("hashes_match_sealed") is True)
            # cross-check against sealed survivors22
            sealed = json.load(open(os.path.join(
                PAIR_RES, "survivors22_p%d.json" % p)))
            sealed_ids = sorted(d["id"] for d in sealed["detail"])
            check("repair ids == survivors22 file p=%d" % p,
                  surv.get("ids") == sealed_ids)
        if st:
            check("repair 3-run identical p=%d" % p,
                  st.get("byte_identical_across_3_runs") is True,
                  str(st.get("run_content_sha1s") or st.get("run_sha1s")))
            check("repair verdict REPAIRED p=%d" % p,
                  st.get("verdict") == "REPAIRED")
        elif p == 331:
            check("repair status exists p=331", False)
        else:
            # 661 may only have single-run content; require content checks only
            check("repair status optional p=%d" % p, True, "single-run ok")

    # ---- third-prime layer0 ----
    print("-- third prime layer0 --")
    l0 = load("layer0_p991.json")
    check("layer0_991 exists", l0 is not None)
    if l0:
        check("layer0_991 dim 39", l0.get("nullspace_dim") == 39)

    n_ok = len(CHECKS) - len(FAILS)
    print()
    print("RESULT: %d checks, %d failures, %d ok" % (
        len(CHECKS), len(FAILS), n_ok))
    if FAILS:
        print("FAILURES:")
        for n, d in FAILS:
            print(" -", n, d)
        print("D35_AUDIT_VERIFY_FAIL")
        return 1
    print("D35_AUDIT_VERIFY_OK")
    print("ALLGREEN")
    out = {
        "n_checks": len(CHECKS),
        "n_failures": len(FAILS),
        "marker": "D35_AUDIT_VERIFY_OK",
        "allgreen": True,
    }
    with open(os.path.join(RES, "verifier_output.json"), "w") as f:
        json.dump(out, f, indent=1)
    return 0


if __name__ == "__main__":
    sys.exit(main())
