#!/usr/bin/env python3
"""Merge both primes into results/summary.json."""
from __future__ import annotations

import json
import os
import sys

import paths
import cone_lib as L

RES = paths.RES


def load(name):
    path = os.path.join(RES, name)
    if not os.path.exists(path):
        return None
    with open(path) as f:
        return json.load(f)


def msolve_rows(p):
    rows = []
    for fn in sorted(os.listdir(RES)):
        if fn.startswith("msolve_m") and fn.endswith("_p%d.json" % p):
            rows.append(load(fn))
    return rows


def pack(p):
    cell = load("cell_d36_p%d.json" % p)
    p3_63 = load("p3_K63_p%d.json" % p)
    p3_62 = load("p3_K62_p%d.json" % p)
    free = load("free_rungs_p%d.json" % p)
    ms = msolve_rows(p)
    bounds = []
    if free and free.get("best_free_bound") is not None:
        bounds.append({"source": "free_m%d" % free["best_free_m"],
                       "dim_V_le": free["best_free_bound"], "kind": "free"})
    for r in ms:
        if r and r.get("verdict") == "cleared":
            bounds.append({"source": "msolve_m%d" % r["m"],
                           "dim_V_le": r["dim_V_le"], "kind": "msolve",
                           "seconds": r.get("seconds")})
    tight = min((b["dim_V_le"] for b in bounds), default=None)
    return {
        "p": p,
        "cell": None if not cell else {
            "cell_dim": cell["cell_dim"], "new_dim": cell["new_dim"],
            "cut_rank": cell["cut_rank"], "sat_ok": cell["sat_ok"],
            "cut_ok": cell["cut_ok"],
        },
        "P3_K63": None if not p3_63 else {
            "K": p3_63["K"], "P3": p3_63["P3"],
            "saturated": p3_63["saturated"],
        },
        "P3_K62": None if not p3_62 else {
            "K": p3_62["K"], "P3": p3_62["P3"],
            "saturated": p3_62["saturated"],
        },
        "free": free,
        "msolve": [
            {k: r.get(k) for k in
             ("m", "verdict", "dim_V_le", "n_gens_written", "timeout",
              "seconds", "full_span_rule")}
            for r in ms if r
        ],
        "bounds": bounds,
        "tightest_dim_V_le": tight,
    }


def main():
    a331 = pack(331)
    a661 = pack(661)
    both_m28 = False
    v331 = {r["m"]: r for r in a331["msolve"]}
    v661 = {r["m"]: r for r in a661["msolve"]}
    two_prime_cleared = [
        m for m in sorted(set(v331) & set(v661))
        if v331[m].get("verdict") == "cleared"
        and v661[m].get("verdict") == "cleared"
    ]
    if two_prime_cleared:
        both_m28 = 28 in two_prime_cleared
    tight_two = None
    if two_prime_cleared:
        tight_two = min(62 - m for m in two_prime_cleared)
    out = {
        "d": 36,
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "N": 62,
        "anchors": {
            "post_cut_62": {
                "331": a331["cell"], "661": a661["cell"],
                "ok": (a331["cell"] or {}).get("new_dim") == 62
                and (a661["cell"] or {}).get("new_dim") == 62,
            },
            "P3_1850_on_63cell": {
                "331": a331["P3_K63"], "661": a661["P3_K63"],
                "ok": (a331["P3_K63"] or {}).get("P3") == 1850
                and (a661["P3_K63"] or {}).get("P3") == 1850,
            },
            "P3_on_62cell": {
                "331": a331["P3_K62"], "661": a661["P3_K62"],
            },
        },
        "p331": a331,
        "p661": a661,
        "two_prime_cleared_msolve_m": two_prime_cleared,
        "tightest_one_prime_dim_V_le": a331["tightest_dim_V_le"],
        "tightest_two_prime_dim_V_le": tight_two,
        "tightest_dim_V_le": a331["tightest_dim_V_le"],
        "m28_two_prime": both_m28,
        "flagged_exclusion": False,
        "m32_p331": v331.get(32),
    }
    L.dump(os.path.join(RES, "summary.json"), out)
    print(json.dumps({
        "tightest": out["tightest_dim_V_le"],
        "two_prime_cleared": two_prime_cleared,
        "anchors_ok": out["anchors"]["post_cut_62"]["ok"]
        and out["anchors"]["P3_1850_on_63cell"]["ok"],
    }, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
