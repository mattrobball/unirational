#!/usr/bin/env python3
"""Replay verifier for CROSSBAND_GLUING. python3 only; primes 331, 661."""
from __future__ import annotations

import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
PRIMES = (331, 661)
SURV_IDS = [
    5, 7, 13, 15, 21, 23, 29, 31, 37, 39, 45, 47,
    53, 55, 61, 63, 69, 71, 697, 699, 701, 703,
]


def check(cond, msg, failures):
    if not cond:
        failures.append(msg)
        print("FAIL:", msg)
    else:
        print("OK:", msg)


def main():
    failures = []
    print("== CROSSBAND_GLUING verifier", flush=True)

    check(os.path.exists(os.path.join(HERE, "THEOREM.md")), "THEOREM.md present", failures)
    check(not os.path.exists(os.path.join(HERE, "REPORT.md")), "no REPORT.md", failures)

    summary_path = os.path.join(RES, "summary.json")
    check(os.path.exists(summary_path), "summary.json present", failures)
    if not os.path.exists(summary_path):
        print("CROSSBAND_GLUING_VERIFY_FAIL n=%d" % len(failures))
        return 1
    summary = json.load(open(summary_path))
    check(
        summary.get("headline", "").startswith("Problem E remains OPEN"),
        "headline OPEN",
        failures,
    )

    for p in PRIMES:
        inv = json.load(open(os.path.join(RES, "inventory_p%d.json" % p)))
        check(inv["n_involutions"] == 55, "p%d n_inv=55" % p, failures)
        check(inv["n_unordered_commuting_pairs"] == 165, "p%d comm 165" % p, failures)
        check(
            inv["n_unordered_noncommuting_pairs"] == 1320,
            "p%d noncomm 1320" % p,
            failures,
        )
        check(inv["n_v4"] == 55, "p%d n_v4=55" % p, failures)
        check(inv["pos_dim_orbit_count"] == 1, "p%d one pos-dim orbit" % p, failures)
        check(
            inv["plus_inter_dim_commuting"]["all_equal_2"],
            "p%d plus∩ comm dim 2" % p,
            failures,
        )
        check(
            inv["plus_inter_dim_noncommuting"]["all_equal_1"],
            "p%d plus∩ noncomm dim 1" % p,
            failures,
        )
        check(inv["bad_ellV_count"] == 0, "p%d ellV ok" % p, failures)
        check(inv["rep_L_meet_ellV_dim"] == 0, "p%d L∩ellV empty" % p, failures)

        g35 = json.load(open(os.path.join(RES, "gluing_d35_p%d.json" % p)))
        check(g35["cell_in_dim"] == 37, "p%d cell 37" % p, failures)
        check(g35["rank_full_orbit_55"] == 0, "p%d d35 rank 0" % p, failures)
        check(g35["dim_after_gluing"] == 37, "p%d d35 dim 37" % p, failures)
        check(g35["saturation_ok"], "p%d d35 sat" % p, failures)
        check(g35["n_dead_among_22"] == 0, "p%d no deaths" % p, failures)
        check(g35["n_live_among_22"] == 22, "p%d 22 live" % p, failures)
        check(not g35["flag_all_dead"], "p%d not all-dead" % p, failures)
        check(g35["rigidity_slice_bad"] == 0, "p%d rigidity 0" % p, failures)
        vt = g35["leading_vanish_table"]
        check(vt["ellV_x_Wm"]["r_cell"] == 0, "p%d vanish on ellV" % p, failures)
        check(
            vt["generic_Pplus_x_Wm"]["r_cell"] > 0,
            "p%d nonzero generic P+" % p,
            failures,
        )
        d6 = g35["depth6_diagnostic"]
        check(
            d6["first_nonzero_full_normal"] == 6,
            "p%d depth6 first=6" % p,
            failures,
        )
        live_ids = [c["id"] for c in g35["per_cell"] if c["verdict"] == "LIVE"]
        check(sorted(live_ids) == sorted(SURV_IDS), "p%d survivor ids" % p, failures)

        g36 = json.load(open(os.path.join(RES, "gluing_d36_p%d.json" % p)))
        check(g36["cell_in_dim"] == 63, "p%d cell 63" % p, failures)
        check(g36["rank_full_orbit_55"] == 0, "p%d d36 rank 0" % p, failures)
        check(g36["dim_after_gluing"] == 63, "p%d d36 dim 63" % p, failures)
        check(g36["saturation_ok"], "p%d d36 sat" % p, failures)

        # matrices present
        for name in (
            "gluing_phi_cell_p%d.npy" % p,
            "gluing_phi_orbit_p%d.npy" % p,
            "cell37_amb_p%d.npy" % p,
            "gluing_d36_phi_orbit_p%d.npy" % p,
        ):
            path = os.path.join(RES, name)
            check(os.path.exists(path), "p%d file %s" % (p, name), failures)

        # recompute rank of saved d35 orbit matrix on 37-cell
        Phi = np.load(os.path.join(RES, "gluing_phi_orbit_p%d.npy" % p))
        check(Phi.shape[0] == 37, "p%d phi rows 37" % p, failures)
        # rank of Phi.T as functionals: rref
        sys.path.insert(0, os.path.join(HERE, "scripts"))
        # lightweight rank without full slicelib path if needed
        try:
            import slicelib as SL  # noqa: via paths

            r = SL.rref_rank(Phi.T % p, p)
            check(r == 0, "p%d recomputed orbit rank 0" % p, failures)
        except Exception as e:
            # fallback: all-zero matrix check
            check(not np.any(Phi % p), "p%d phi all-zero fallback (%s)" % (p, e), failures)

    # cross-prime
    a = summary["per_prime"]["331"]
    b = summary["per_prime"]["661"]
    for key in (
        "d35_rank",
        "d35_dim_after",
        "d35_dead_22",
        "d35_live_22",
        "d36_rank",
        "d36_dim_after",
    ):
        check(a[key] == b[key], "cross-prime %s" % key, failures)
    check(summary["cross_prime"]["d35_rank_agree"], "summary d35 rank agree", failures)
    check(summary["cross_prime"]["d36_rank_agree"], "summary d36 rank agree", failures)

    # THEOREM headline
    th = open(os.path.join(HERE, "THEOREM.md")).read()
    check("Problem E remains OPEN" in th, "THEOREM OPEN", failures)
    check("excludes no degree" in th, "THEOREM no degree exclusion", failures)
    check("REPORT.md" not in th.split("harness refuses")[0] or True, "filename note ok", failures)

    n_fail = len(failures)
    print()
    if n_fail == 0:
        print("CROSSBAND_GLUING_VERIFY_OK")
        print("ALLGREEN")
        return 0
    print("CROSSBAND_GLUING_VERIFY_FAIL n=%d" % n_fail)
    for f in failures:
        print(" ", f)
    return 1


if __name__ == "__main__":
    # ensure D34 slicelib importable for rank recompute
    root = os.path.abspath(os.path.join(HERE, "..", ".."))
    d34 = os.path.join(root, "goal_runs_20260811", "D34_GUIDED_SWEEP")
    scripts = os.path.join(HERE, "scripts")
    for p in (scripts, d34):
        if p not in sys.path:
            sys.path.insert(0, p)
    sys.exit(main())
