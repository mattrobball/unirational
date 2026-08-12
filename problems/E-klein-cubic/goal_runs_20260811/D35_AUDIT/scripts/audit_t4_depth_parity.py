#!/usr/bin/env python3
"""T4 hostile audit: depth-parity semantics on D_{P_σ}.

Claim under audit:
  Exactly the six type-I-plus-plane V4-children have arc-character period 2
  on the D_{P_σ} row (value alternates with depth) and every other child's
  value is depth-constant.

This is the assumption whose earlier misuse forced the §6 retraction.
Pinned to a machine check via s3jet.chi_arc_of + value_at_level.
"""
import json
import os
import sys
from collections import Counter

import paths

AUDIT_RES = paths.AUDIT_RES


def label_at(S, a, kid, kappa, chi_arc):
    from s3jet import value_at_level
    U = value_at_level(S, a, kid, kappa, None, chi_arc)
    if U is None:
        return None
    return S.own_frame(kid, U)


def run(p):
    print("== T4 depth-parity  p=%d" % p)
    from s1enum import Stage1
    from s3sweep import FullSweep
    from s3jet import chi_arc_of, value_at_level

    E = Stage1(p)
    S = FullSweep(E, 1)          # rid 1 = D_{P_σ}
    a35 = (34, 1)

    period_hist = Counter()
    records = []
    n_period2 = 0
    n_period_gt1 = 0
    n_depth_varies = 0
    n_depth_constant = 0
    period2_kids = []
    period_gt1_non2 = []
    depth_varies_non_p2 = []

    for kid in S.kids:
        chi, per = chi_arc_of(S, kid)
        period_hist[per] += 1
        lab0 = label_at(S, a35, kid, 0, chi)
        lab1 = label_at(S, a35, kid, 1, chi)
        lab2 = label_at(S, a35, kid, 2, chi)
        # depth-constant means lab0 == lab1 whenever both defined
        both = lab0 is not None and lab1 is not None
        varies = both and (lab0 != lab1)
        constant = both and (lab0 == lab1)
        if per == 2:
            n_period2 += 1
            period2_kids.append({
                "kid_idx": kid["idx"], "row": kid["row"],
                "lab0": list(lab0) if lab0 else None,
                "lab1": list(lab1) if lab1 else None,
                "alternates": bool(varies),
            })
        if per > 1:
            n_period_gt1 += 1
            if per != 2:
                period_gt1_non2.append({
                    "kid_idx": kid["idx"], "row": kid["row"], "period": per,
                    "lab0": list(lab0) if lab0 else None,
                    "lab1": list(lab1) if lab1 else None,
                    "lab2": list(lab2) if lab2 else None,
                    "varies_0_1": bool(varies),
                })
        if varies:
            n_depth_varies += 1
            if per != 2:
                depth_varies_non_p2.append({
                    "kid_idx": kid["idx"], "row": kid["row"], "period": per,
                    "lab0": list(lab0) if lab0 else None,
                    "lab1": list(lab1) if lab1 else None,
                })
        if constant:
            n_depth_constant += 1
        records.append({
            "kid_idx": kid["idx"], "row": kid["row"], "period": per,
            "lab0_defined": lab0 is not None,
            "lab1_defined": lab1 is not None,
            "varies": bool(varies),
            "constant": bool(constant),
        })

    # Also check rid 2 (minus-line row) for completeness
    S2 = FullSweep(E, 2)
    p2_hist = Counter()
    for kid in S2.kids:
        _, per = chi_arc_of(S2, kid)
        p2_hist[per] += 1

    claim_exactly_six_period2 = (n_period2 == 6)
    claim_no_other_period_gt1 = (n_period_gt1 == n_period2)
    claim_only_p2_varies = (len(depth_varies_non_p2) == 0)
    claim_all_p2_alternate = all(k["alternates"] for k in period2_kids)

    # The director claim as stated:
    # (a) exactly six period-2 children (type-I-plus-plane V4)
    # (b) every OTHER child's value is depth-constant
    # (b) fails if any non-period-2 child has lab0 != lab1
    out = {
        "p": p,
        "n_kids_rid1": len(S.kids),
        "period_histogram_rid1": {str(k): v for k, v in sorted(period_hist.items())},
        "period_histogram_rid2": {str(k): v for k, v in sorted(p2_hist.items())},
        "n_period2": n_period2,
        "n_period_gt1": n_period_gt1,
        "n_depth_varies": n_depth_varies,
        "n_depth_constant": n_depth_constant,
        "period2_kids": period2_kids,
        "period_gt1_non2": period_gt1_non2,
        "depth_varies_non_p2": depth_varies_non_p2,
        "claim_exactly_six_period2": bool(claim_exactly_six_period2),
        "claim_no_other_period_gt1": bool(claim_no_other_period_gt1),
        "claim_only_p2_varies": bool(claim_only_p2_varies),
        "claim_all_p2_alternate": bool(claim_all_p2_alternate),
    }

    if (claim_exactly_six_period2 and claim_only_p2_varies
            and claim_all_p2_alternate and claim_no_other_period_gt1):
        out["verdict"] = "CONFIRMED"
    else:
        out["verdict"] = "REFUTED"
        out["witness"] = {
            "period_histogram": out["period_histogram_rid1"],
            "n_period2": n_period2,
            "period_gt1_non2_count": len(period_gt1_non2),
            "depth_varies_non_p2_count": len(depth_varies_non_p2),
            "period_gt1_non2_sample": period_gt1_non2[:6],
            "depth_varies_non_p2_sample": depth_varies_non_p2[:6],
            "note": (
                "Director claim: only six period-2 kids alternate; all others "
                "depth-constant. Machine found period>1 kids beyond those six "
                "and/or depth-varying labels outside period 2."
                if not claim_no_other_period_gt1 or not claim_only_p2_varies
                else "period-2 count or alternation failed"
            ),
        }
        # refined sub-claims for the record
        out["subclaims"] = {
            "six_period2_exist_and_alternate": bool(
                claim_exactly_six_period2 and claim_all_p2_alternate),
            "no_other_period_gt1": bool(claim_no_other_period_gt1),
            "no_depth_variation_outside_p2": bool(claim_only_p2_varies),
        }
    print("  period hist", dict(period_hist))
    print("  period2", n_period2, "period>1 non2", len(period_gt1_non2),
          "varies non-p2", len(depth_varies_non_p2))
    print("  verdict", out["verdict"])
    os.makedirs(AUDIT_RES, exist_ok=True)
    with open(os.path.join(AUDIT_RES, "t4_depth_parity_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=1)
    return out


if __name__ == "__main__":
    primes = [int(x) for x in sys.argv[1:]] or [331, 661]
    for p in primes:
        run(p)
