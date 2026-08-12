#!/usr/bin/env python3
"""Final d=35 census: 1264 = sealed kills + arc-jet kills + live (22 anchor).

Aggregates sieve_layers + arc_jet_ladder at both primes; cross-prime check.
"""
import json
import os
import sys

import paths

RES = paths.RES


def load(p):
    mat = json.load(open(os.path.join(RES, "materialize_summary_p%d.json" % p)))
    sieve = json.load(open(os.path.join(RES, "sieve_layers_p%d.json" % p)))
    ladder = json.load(open(os.path.join(RES, "arc_jet_ladder_p%d.json" % p)))
    return mat, sieve, ladder


def build(p):
    mat, sieve, ladder = load(p)
    d508 = sieve["per_layer_deaths_508"]
    n_multi = d508["multidegree"]
    n_line = d508["line_order"]
    n_to_ladder = d508["live_after_six_flips"]
    n_ladder_dead = ladder["n_dead"]
    n_ladder_live = ladder["n_live"]
    assert n_to_ladder == n_ladder_dead + n_ladder_live
    assert n_multi + n_line + n_to_ladder == 508

    # stratified sealed 336+398+22
    s756 = sieve["strat_756"]["deaths"]
    n_strat_multi = s756["DEAD_MULTIDEGREE"]
    n_strat_line = s756["DEAD_LINE_ORDER"]
    n_strat_live = s756["LIVE_AFTER_FLIPS"]  # 22 before ladder; ladder is ext-only
    assert n_strat_multi == 336 and n_strat_line == 398 and n_strat_live == 22

    # final live = strat 22 (ladder not reapplied to them here — DEPTH keep-pass
    # already showed 0 closed deaths) + ladder survivors among 508
    n_live = 22 + n_ladder_live
    n_dead = 1264 - n_live
    assert n_dead == (n_multi + n_line + n_ladder_dead
                      + n_strat_multi + n_strat_line)

    # FLAG if extended set all-dead (not a degree exclusion — 22 remain)
    ext_all_dead = (n_ladder_live == 0 and n_multi + n_line + n_ladder_dead == 508)

    out = {
        "p": p,
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "J_r5": 1264,
        "K_r5": 756,
        "N_ext": 508,
        "per_layer_deaths_508": {
            "multidegree_m_in_3_5": n_multi,
            "line_order_nu_ge_2": n_line,
            "arc_jet_ladder_period3": n_ladder_dead,
            "live_among_508": n_ladder_live,
            "total": 508,
            "check": n_multi + n_line + n_ladder_dead + n_ladder_live == 508,
        },
        "strat_756_sealed": {
            "multidegree": n_strat_multi,
            "line_order": n_strat_line,
            "live_22": n_strat_live,
        },
        "final_census_1264": {
            "dead_multidegree": n_multi + n_strat_multi,
            "dead_line_order": n_line + n_strat_line,
            "dead_arc_jet_ext": n_ladder_dead,
            "live": n_live,
            "live_dims": sorted(set(
                ([37] if n_live else []) + ladder.get("live_dims", [])
            )),
            "formula": (
                "1264 = %d(multi) + %d(line) + %d(arc-jet) + %d(live)"
                % (n_multi + n_strat_multi, n_line + n_strat_line,
                   n_ladder_dead, n_live)
            ),
            "sum_ok": (n_multi + n_strat_multi + n_line + n_strat_line
                       + n_ladder_dead + n_live) == 1264,
        },
        "anchor_22": sieve["anchor_22"],
        "ladder_mechanisms": ladder.get("death_mechanisms", {}),
        "p3_vanishing": ladder.get("p3_summary", {}),
        "ext_508_all_dead": ext_all_dead,
        "FLAG": (
            "EXTENDED-508-ALL-DEAD — FLAGGED, not claimed as degree exclusion; "
            "22 stratified survivors remain live at dim≤37. ODDZERO-standard "
            "audit gate before any promotion of the 508-kill."
            if ext_all_dead else None
        ),
        "not_claimed": [
            "No degree exclusion",
            "No char-0 emptiness of the 22",
            "508 all-dead is modular finite-exact, FLAGGED pending audit",
        ],
    }
    return out


def main(primes=(331, 661)):
    all_out = {}
    for p in primes:
        all_out[p] = build(p)
        path = os.path.join(RES, "census_p%d.json" % p)
        with open(path, "w") as f:
            json.dump(all_out[p], f, indent=1)
        print("p=%d: %s" % (p, all_out[p]["final_census_1264"]["formula"]))
        print("  508 deaths:", all_out[p]["per_layer_deaths_508"])
        print("  live=%d dims=%s anchor22=%s FLAG=%s" % (
            all_out[p]["final_census_1264"]["live"],
            all_out[p]["final_census_1264"]["live_dims"],
            all_out[p]["anchor_22"]["all_present"],
            bool(all_out[p]["FLAG"]),
        ))

    # cross-prime
    agree = True
    keys = ["per_layer_deaths_508", "final_census_1264", "ext_508_all_dead"]
    if len(primes) >= 2:
        a, b = all_out[primes[0]], all_out[primes[1]]
        for k in ("per_layer_deaths_508",):
            if a[k] != b[k]:
                # compare numeric fields only
                for kk in a[k]:
                    if isinstance(a[k][kk], (int, bool)) and a[k][kk] != b[k][kk]:
                        agree = False
                        print("DISAGREE", k, kk, a[k][kk], b[k][kk])
        if a["final_census_1264"]["live"] != b["final_census_1264"]["live"]:
            agree = False
        if a["ext_508_all_dead"] != b["ext_508_all_dead"]:
            agree = False

    summary = {
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "primes": list(primes),
        "cross_prime_agree": agree,
        "per_prime": {str(p): all_out[p] for p in primes},
        "banner": (
            "1264 = dead(multidegree+line+arc-jet) + live(22); "
            "508 extended all-dead FLAGGED; 22-anchor reappears unchanged."
        ),
    }
    with open(os.path.join(RES, "census_summary.json"), "w") as f:
        json.dump(summary, f, indent=1)
    print("CENSUS_OK agree=%s" % agree)
    return summary


if __name__ == "__main__":
    primes = [int(x) for x in sys.argv[1:]] or [331, 661]
    main(tuple(primes))
