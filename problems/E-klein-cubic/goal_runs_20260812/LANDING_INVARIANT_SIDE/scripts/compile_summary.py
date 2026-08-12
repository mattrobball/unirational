#!/usr/bin/env python3
"""Compile P3/HF3 table + HF4 + kernel into results/summary.json."""
from __future__ import annotations

import json
import os

import paths

RES = paths.RES


def main():
    rows = []
    for d in (35, 36, 37, 38):
        row = {"d": d, "I_3d": paths.I_3D[d], "K_expect": paths.POST_FLIP_K[d]}
        for p in paths.PRIMES:
            path = os.path.join(RES, "p3_inv_d%d_p%d.json" % (d, p))
            if not os.path.exists(path):
                row["p%d" % p] = None
                continue
            r = json.load(open(path))
            row["p%d" % p] = {
                "P3": r["P3"],
                "HF3": r["HF3"],
                "K": r["K"],
                "N3": r["N3"],
                "saturated": r["saturated"],
                "deficit_vs_I": r.get("deficit_vs_I"),
                "ratio_P3_I": r.get("ratio_P3_over_I"),
                "seconds": r.get("seconds_total") or r.get("seconds"),
            }
        a, b = row.get("p331"), row.get("p661")
        row["agree"] = (
            a is not None
            and b is not None
            and a["P3"] == b["P3"]
            and a["K"] == b["K"]
            and a["saturated"]
            and b["saturated"]
        )
        if a and b and row["agree"]:
            row["P3"] = a["P3"]
            row["HF3"] = a["HF3"]
            row["K"] = a["K"]
            row["N3"] = a["N3"]
            row["ratio_P3_I"] = a["P3"] / paths.I_3D[d]
            row["deficit_vs_I"] = paths.I_3D[d] - a["P3"]
        rows.append(row)

    hf4 = {}
    for p in paths.PRIMES:
        path = os.path.join(RES, "hf4_p%d.json" % p)
        if os.path.exists(path):
            hf4[str(p)] = json.load(open(path))
    if os.path.exists(os.path.join(RES, "hf4_summary.json")):
        hf4["summary"] = json.load(open(os.path.join(RES, "hf4_summary.json")))

    kernel = None
    kp = os.path.join(RES, "kernel_p331.json")
    if os.path.exists(kp):
        kernel = json.load(open(kp))

    # crude growth observation
    growth = []
    for i in range(1, len(rows)):
        if rows[i].get("P3") and rows[i - 1].get("P3"):
            growth.append({
                "from": rows[i - 1]["d"],
                "to": rows[i]["d"],
                "dP3": rows[i]["P3"] - rows[i - 1]["P3"],
                "dI": rows[i]["I_3d"] - rows[i - 1]["I_3d"],
                "d_deficit": rows[i]["deficit_vs_I"] - rows[i - 1]["deficit_vs_I"],
            })

    out = {
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "method": "inv_eval_matrix (sketched Inv dual via point evals of F(T_c))",
        "rows": rows,
        "growth": growth,
        "observation": {
            "P3_seq": [r.get("P3") for r in rows],
            "ratio_P3_I_seq": [r.get("ratio_P3_I") for r in rows],
            "deficit_vs_I_seq": [r.get("deficit_vs_I") for r in rows],
            "note": (
                "P3/I(3d) rises ~0.16→0.28 over d=35..38; deficit I−P3 grows "
                "slowly (~7175→8491). No low-degree polynomial closed form forced."
            ),
        },
        "hf4_d35": hf4,
        "kernel": kernel["verdict"] if kernel else None,
        "ceilings_I_3d": paths.I_3D,
    }
    with open(os.path.join(RES, "summary.json"), "w") as f:
        json.dump(out, f, indent=2)
    print(json.dumps(out, indent=2)[:3000])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
