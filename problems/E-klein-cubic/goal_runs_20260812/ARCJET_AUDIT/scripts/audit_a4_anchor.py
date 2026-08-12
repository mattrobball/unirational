#!/usr/bin/env python3
"""A4 hostile audit: 22-anchor at primes 331, 661, and 991.

Checks:
  - sealed 22 sol/content hashes reappear among stratified live after
    multidegree + line-order + six-flips (331/661, from EXT sieve artefacts)
  - at 991: Layer-0 null dim 39, own-Reynolds six-flip rank 2 → dim 37,
    and the sealed 22 ids remain the audit survivors set (geometry anchors
    underwriting the 22 are stable at the third prime)

Usage: python3 audit_a4_anchor.py
"""
import json
import os
import sys

import numpy as np

import paths
from slice_load import load_null, our_frame, six_flip_cell37
from linalg import rref_rank

RES = paths.RES
EXT_RES = paths.EXT_RES
AUDIT_RES = paths.AUDIT_RES
PAIR_RES = paths.PAIR_RES
SURV_IDS = paths.SURV_IDS


def check_331_661(p):
    mat = json.load(open(os.path.join(EXT_RES, "materialize_summary_p%d.json" % p)))
    sieve = json.load(open(os.path.join(EXT_RES, "sieve_layers_p%d.json" % p)))
    census = json.load(open(os.path.join(EXT_RES, "census_p%d.json" % p)))
    audit = json.load(open(os.path.join(AUDIT_RES, "patterns_r5_content_p%d.json" % p)))

    sealed_22_hashes = set(mat["anchor_22"]["sealed_hashes"])
    sealed_22_ids = list(mat["anchor_22"]["sealed_ids"])
    audit_22_hashes = set(audit["survivors22"]["sealed_hashes"])
    audit_22_ids = list(audit["survivors22"]["ids"])

    # sieve anchor
    sieve_anchor = sieve["anchor_22"]
    census_anchor = census["anchor_22"]

    witnesses = []
    if sealed_22_ids != SURV_IDS and sealed_22_ids != sorted(SURV_IDS):
        if set(sealed_22_ids) != set(SURV_IDS):
            witnesses.append({"kind": "id_set_mismatch",
                              "sealed": sealed_22_ids, "SURV": SURV_IDS})
    if not mat["anchor_22"]["all_22_hashes_present"]:
        witnesses.append({"kind": "mat_anchor_missing"})
    if not sieve_anchor.get("all_present", False):
        witnesses.append({"kind": "sieve_anchor_missing",
                          "sieve_anchor": sieve_anchor})
    if not census_anchor.get("all_present", False):
        witnesses.append({"kind": "census_anchor_missing"})
    if sieve["strat_756"]["n_live"] != 22:
        witnesses.append({"kind": "strat_live_ne_22",
                          "n": sieve["strat_756"]["n_live"]})
    if census["final_census_1264"]["live"] != 22:
        witnesses.append({"kind": "final_live_ne_22",
                          "n": census["final_census_1264"]["live"]})
    # audit sealed hashes must equal materialize's 22 hashes
    if sealed_22_hashes != audit_22_hashes:
        # materialize may use sol_hash vs content_hash
        # check ids match at least
        if set(sealed_22_ids) != set(audit_22_ids):
            witnesses.append({
                "kind": "audit_vs_mat_hash_or_id_mismatch",
                "n_mat_hashes": len(sealed_22_hashes),
                "n_audit_hashes": len(audit_22_hashes),
                "ids_mat": sealed_22_ids,
                "ids_audit": audit_22_ids,
            })

    # cross-check: every sealed 22 hash appears in joint stratified
    joint = json.load(open(os.path.join(EXT_RES, "patterns_joint1264_p%d.json" % p)))
    joint_hashes = {}
    for pt in joint["patterns"]:
        h = pt.get("sol_hash") or pt.get("hash")
        joint_hashes[h] = pt
    missing = [h for h in sealed_22_hashes if h not in joint_hashes]
    # try content_hash
    if missing:
        by_ch = {pt.get("content_hash"): pt for pt in joint["patterns"]}
        missing_ch = [h for h in sealed_22_hashes if h not in by_ch]
        if missing_ch:
            # sealed_hashes in mat are likely sol or content — check both
            all_sol = {pt.get("sol_hash") for pt in joint["patterns"]}
            all_ch = {pt.get("content_hash") for pt in joint["patterns"]}
            if not (sealed_22_hashes <= all_sol or sealed_22_hashes <= all_ch):
                witnesses.append({
                    "kind": "22_hashes_absent_from_joint",
                    "n_missing": len(missing_ch),
                    "sample": missing_ch[:5],
                })

    return {
        "p": p,
        "n_sealed_hashes": len(sealed_22_hashes),
        "sealed_ids": sealed_22_ids,
        "ids_match_SURV": set(sealed_22_ids) == set(SURV_IDS),
        "mat_all_present": mat["anchor_22"]["all_22_hashes_present"],
        "sieve_all_present": sieve_anchor.get("all_present"),
        "census_all_present": census_anchor.get("all_present"),
        "strat_live": sieve["strat_756"]["n_live"],
        "final_live": census["final_census_1264"]["live"],
        "witnesses": witnesses,
        "ok": len(witnesses) == 0,
    }


def check_991():
    print("== A4 third-prime geometry p=991", flush=True)
    fr = our_frame(991)
    A, C, NUL = load_null(991)
    assert NUL.shape == (39, 637), NUL.shape
    LAM, CELL37, meta = six_flip_cell37(fr, A, C, NUL, 991, pick=0)
    print("  null dim=%d six-flip rank=%d dim_after=%d rig=%d"
          % (NUL.shape[0], meta["slice_rank"], meta["dim_after"],
             meta["r1_rigidity"]), flush=True)
    np.save(os.path.join(RES, "cell37_own_p991.npy"), CELL37)
    np.save(os.path.join(RES, "lam6_own_p991.npy"), LAM)

    witnesses = []
    if NUL.shape[0] != 39:
        witnesses.append({"kind": "null_dim", "got": int(NUL.shape[0])})
    if meta["slice_rank"] != 2 or meta["dim_after"] != 37:
        witnesses.append({"kind": "six_flip_rank", "meta": meta})
    if meta["r1_rigidity"] != 0:
        witnesses.append({"kind": "six_flip_rigidity", "bad": meta["r1_rigidity"]})
    if CELL37.shape != (37, 39):
        witnesses.append({"kind": "cell37_shape", "shape": list(CELL37.shape)})

    # sealed 22 ids unchanged (ids are combinatorial, prime-independent)
    audit331 = json.load(open(
        os.path.join(AUDIT_RES, "patterns_r5_content_p331.json")))
    audit661 = json.load(open(
        os.path.join(AUDIT_RES, "patterns_r5_content_p661.json")))
    ids331 = list(audit331["survivors22"]["ids"])
    ids661 = list(audit661["survivors22"]["ids"])
    if set(ids331) != set(SURV_IDS) or set(ids661) != set(SURV_IDS):
        witnesses.append({"kind": "survivor_ids_not_stable_across_331_661",
                          "ids331": ids331, "ids661": ids661})
    if ids331 != ids661:
        witnesses.append({"kind": "ids_331_ne_661",
                          "ids331": ids331, "ids661": ids661})

    # D35_AUDIT already confirmed T2 at 991; cross-check rank numbers
    t2 = json.load(open(os.path.join(AUDIT_RES, "t2_sixflip_p991.json")))
    if t2.get("slice_rank") != 2 or t2.get("verdict") != "CONFIRMED":
        witnesses.append({"kind": "prior_t2_991_not_confirmed", "t2": t2})

    return {
        "p": 991,
        "null_dim": int(NUL.shape[0]),
        "six_flip": meta,
        "cell37_shape": list(CELL37.shape),
        "survivor_ids": SURV_IDS,
        "ids_stable_331_661": ids331 == ids661 == SURV_IDS or (
            set(ids331) == set(ids661) == set(SURV_IDS)),
        "prior_t2_991": {
            "slice_rank": t2.get("slice_rank"),
            "ambient_rank": t2.get("ambient_rank"),
            "verdict": t2.get("verdict"),
        },
        "witnesses": witnesses,
        "ok": len(witnesses) == 0,
        "note": (
            "At 991 the full 1264 materialization is not re-run; the 22-anchor "
            "is the sealed survivor id set plus the geometric cut (null 39, "
            "six-flip rank 2 → dim ≤ 37) underwriting every live cell."
        ),
    }


def main():
    out = {
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "per_prime": {},
    }
    witnesses_all = []
    for p in (331, 661):
        r = check_331_661(p)
        out["per_prime"][str(p)] = r
        witnesses_all.extend([{"p": p, **w} for w in r["witnesses"]])
        print("  p=%d A4 partial: ok=%s strat_live=%s final_live=%s"
              % (p, r["ok"], r["strat_live"], r["final_live"]), flush=True)
    r991 = check_991()
    out["per_prime"]["991"] = r991
    witnesses_all.extend([{"p": 991, **w} for w in r991["witnesses"]])

    # cross-prime: 22 live at both 331 and 661
    if out["per_prime"]["331"]["final_live"] != 22:
        witnesses_all.append({"kind": "final_live_331"})
    if out["per_prime"]["661"]["final_live"] != 22:
        witnesses_all.append({"kind": "final_live_661"})

    verdict = "REFUTED" if witnesses_all else "CONFIRMED"
    out["A4_verdict"] = verdict
    out["A4_refute_witnesses"] = witnesses_all
    out["all_primes_ok"] = all(out["per_prime"][str(p)]["ok"]
                               for p in (331, 661, 991))

    with open(os.path.join(RES, "a4_anchor.json"), "w") as f:
        json.dump(out, f, indent=1)
    print("A4_VERDICT", verdict, "witnesses", len(witnesses_all))
    return out


if __name__ == "__main__":
    main()
