#!/usr/bin/env python3
"""Run full CROSSBAND_GLUING pipeline at both primes."""
from __future__ import annotations

import json
import os
import sys
import time

import paths
import inventory as INV
import gluing_d35 as G35
import gluing_d36 as G36


def main():
    t0 = time.time()
    summary = {
        "primes": list(paths.PRIMES),
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "per_prime": {},
    }
    for p in paths.PRIMES:
        print("\n" + "=" * 60)
        print("PRIME", p)
        print("=" * 60)
        inv, _, _ = INV.inventory(p, verbose=True)
        with open(os.path.join(paths.RES, "inventory_p%d.json" % p), "w") as f:
            json.dump(inv, f, indent=1, sort_keys=True)
        g35 = G35.run(p)
        g36 = G36.run(p)
        summary["per_prime"][str(p)] = {
            "inventory_pos_dim_orbits": inv["pos_dim_orbit_count"],
            "d35_rank": g35["rank_full_orbit_55"],
            "d35_dim_after": g35["dim_after_gluing"],
            "d35_dead_22": g35["n_dead_among_22"],
            "d35_live_22": g35["n_live_among_22"],
            "d35_flag_all_dead": g35["flag_all_dead"],
            "d35_sat_ok": g35["saturation_ok"],
            "d36_rank": g36["rank_full_orbit_55"],
            "d36_dim_after": g36["dim_after_gluing"],
            "d36_sat_ok": g36["saturation_ok"],
        }

    # cross-prime agreement
    a = summary["per_prime"]["331"]
    b = summary["per_prime"]["661"]
    summary["cross_prime"] = {
        "d35_rank_agree": a["d35_rank"] == b["d35_rank"],
        "d35_dim_agree": a["d35_dim_after"] == b["d35_dim_after"],
        "d35_dead_agree": a["d35_dead_22"] == b["d35_dead_22"],
        "d36_rank_agree": a["d36_rank"] == b["d36_rank"],
        "d36_dim_agree": a["d36_dim_after"] == b["d36_dim_after"],
    }
    summary["seconds_total"] = time.time() - t0
    path = os.path.join(paths.RES, "summary.json")
    with open(path, "w") as f:
        json.dump(summary, f, indent=1, sort_keys=True)
    print("\n=== SUMMARY ===")
    print(json.dumps(summary, indent=2))
    print("wrote", path)


if __name__ == "__main__":
    main()
