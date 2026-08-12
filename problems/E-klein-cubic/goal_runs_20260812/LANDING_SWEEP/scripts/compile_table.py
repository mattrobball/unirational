#!/usr/bin/env python3
"""Compile results/d*_p*.json into results/degree_table.json + summary_both.json."""
from __future__ import annotations

import json
import os

import paths

RES = paths.RES


def pack(r):
    f = r.get("finisher") or {}
    s = r.get("six_flip") or {}
    p3 = r.get("p3") or {}
    sec = r.get("sections") or {}
    P3 = p3.get("P3")
    if P3 is not None and not p3.get("saturated"):
        # unsaturated dense counts as lower bound only
        p3_lb = P3
        P3 = None
    else:
        p3_lb = p3.get("P3_lower")
    return {
        "cell": r.get("cell_dim"),
        "prof": r.get("dim_profile_only"),
        "struct": r.get("dim_structure_only"),
        "fin_demand": f.get("demanded_ord"),
        "fin_rank": f.get("rank"),
        "fin_imp": f.get("impossible"),
        "fin_after": f.get("dim_after"),
        "flip_rank": s.get("rank"),
        "flip_skip": bool(s.get("skipped")),
        "post": r.get("post_flip_dim"),
        "P3": P3,
        "P3_lb": p3_lb,
        "HF3": p3.get("HF3") if P3 is not None else None,
        "p3mode": p3.get("mode"),
        "p3sat": p3.get("saturated"),
        "N3": p3.get("N3"),
        "P1_oo": (sec.get("P1") or {}).get("origin_only"),
        "P1_n": (sec.get("P1") or {}).get("n"),
        "P2_oo": (sec.get("P2") or {}).get("origin_only"),
        "P2_n": (sec.get("P2") or {}).get("n"),
    }


def main():
    rows = []
    for d in range(34, 43):
        r331 = json.load(open(os.path.join(RES, "d%d_p331.json" % d)))
        r661 = json.load(open(os.path.join(RES, "d%d_p661.json" % d)))
        a, b = pack(r331), pack(r661)
        keys = ["cell", "fin_rank", "fin_imp", "flip_rank", "post", "P3"]
        agree = {k: a.get(k) == b.get(k) for k in keys}
        rows.append(
            {
                "d": d,
                "anchor": paths.ANCHOR_CELL[d],
                "p331": a,
                "p661": b,
                "agree": agree,
                "agree_all": all(agree.values()),
            }
        )
    out = {
        "primes": [331, 661],
        "range": [34, 42],
        "rows": rows,
        "notes": {
            "cell": "Layer-0 (1,6) structure+profile dim (upper bound if >0)",
            "finisher": "parity-forced minimal POSITIVE line order: odd d ord>=2, even d ord>=3",
            "six_flip": "odd d only; rank of six V4-child flip functionals on cell",
            "P3": "dim span of sampled landing cubics on post-flip cell; exact only if dense+saturated",
            "sections": "10 P1 + 10 P2 random linear sections; origin_only count",
        },
    }
    with open(os.path.join(RES, "degree_table.json"), "w") as f:
        json.dump(out, f, indent=1)
    print("wrote degree_table.json; all_agree =", all(r["agree_all"] for r in rows))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
