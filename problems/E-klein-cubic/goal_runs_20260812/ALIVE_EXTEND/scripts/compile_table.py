#!/usr/bin/env python3
"""Compile per-degree JSON into results/degree_table.json + results/summary.json."""
from __future__ import annotations

import json
import os

import paths

RES = paths.RES


def load(name):
    with open(os.path.join(RES, name)) as f:
        return json.load(f)


def pack(r):
    f = r.get("finisher") or {}
    s = r.get("six_flip") or {}
    return {
        "raw": r.get("raw_cell"),
        "c11_rank": r.get("c11_rank"),
        "window": r.get("window"),
        "is_qr": r.get("is_qr"),
        "d_mod_11": r.get("d_mod_11"),
        "c11_in_structure": r.get("c11_already_in_structure"),
        "one_frame_matches": r.get("one_frame_rank_matches_60"),
        "sat_ok": (r.get("cut60") or {}).get("sat_ok"),
        "fin_demand": f.get("demanded_ord"),
        "fin_rank": f.get("rank"),
        "fin_imp": f.get("impossible"),
        "fin_after": f.get("dim_after"),
        "fin_sat": f.get("saturation_ok"),
        "flip_rank": s.get("rank"),
        "flip_skip": bool(s.get("skipped")),
        "flip_r1_bad": s.get("r1_bad"),
        "flip_amb": s.get("ambient_rank"),
        "post": r.get("post_flip_dim"),
        "flagged_zero": r.get("flagged_zero"),
        "dim_M": r.get("dim_M"),
        "r0": r.get("r0"),
        "prof": r.get("dim_profile_only"),
        "struct": r.get("dim_structure_only"),
    }


def main():
    rows = []
    for d in paths.DEGREES:
        a = pack(load("d%d_p331.json" % d))
        b = pack(load("d%d_p661.json" % d))
        keys = [
            "raw",
            "c11_rank",
            "window",
            "fin_rank",
            "fin_imp",
            "flip_rank",
            "post",
        ]
        agree = {k: a.get(k) == b.get(k) for k in keys}
        rows.append(
            {
                "d": d,
                "sealed_raw": paths.SEALED_RAW.get(d),
                "sealed_window": paths.SEALED_WINDOW.get(d),
                "p331": a,
                "p661": b,
                "agree": agree,
                "agree_all": all(agree.values()),
            }
        )

    any_flag = any(r["p331"]["flagged_zero"] or r["p661"]["flagged_zero"] for r in rows)
    table = {
        "primes": [331, 661],
        "range": [34, 50],
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "any_flagged_zero": any_flag,
        "two_prime_agree": all(r["agree_all"] for r in rows),
        "rows": rows,
        "notes": {
            "raw": "Layer-0 (1,6) structure+profile cell (upper bound if >0)",
            "window": "raw cell after the 60 all-degree C11-point conditions",
            "finisher": (
                "parity-forced minimal POSITIVE line order on the window: "
                "odd d ord>=2, even d ord>=3"
            ),
            "six_flip": "odd d only; six V4-child flip functionals on the window",
            "semantics": (
                "window>0 is a modular upper bound; window=0 on a previously "
                "alive raw cell is FLAGGED, never claimed as a degree exclusion"
            ),
        },
    }
    out = os.path.join(RES, "degree_table.json")
    with open(out, "w") as f:
        json.dump(table, f, indent=1, sort_keys=True)
        f.write("\n")

    alive = []
    for r in rows:
        d = r["d"]
        win = r["p331"]["window"]
        alive.append(
            {
                "d": d,
                "class": "QR" if paths.is_qr(d) else "NQR",
                "d_mod_11": d % 11,
                "raw": r["p331"]["raw"],
                "c11_rank": r["p331"]["c11_rank"],
                "window": win,
                "fin_imp": r["p331"]["fin_imp"],
                "fin_rank": r["p331"]["fin_rank"],
                "flip_rank": r["p331"]["flip_rank"],
            }
        )
    summary = {
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "primes": [331, 661],
        "range": [34, 50],
        "alive_table_34_50": [r["p331"]["window"] for r in rows],
        "sealed_window_34_42": [paths.SEALED_WINDOW[d] for d in range(34, 43)],
        "anchors_ok": all(
            r["p331"]["window"] == paths.SEALED_WINDOW[r["d"]]
            and r["p661"]["window"] == paths.SEALED_WINDOW[r["d"]]
            for r in rows
            if r["d"] in paths.SEALED_WINDOW
        ),
        "two_prime_agree": table["two_prime_agree"],
        "any_flagged_zero": any_flag,
        "alive": alive,
    }
    with open(os.path.join(RES, "summary.json"), "w") as f:
        json.dump(summary, f, indent=1, sort_keys=True)
        f.write("\n")
    print("wrote degree_table.json + summary.json")
    print("agree_all", table["two_prime_agree"], "flagged_zero", any_flag)
    for r in rows:
        a = r["p331"]
        print(
            "  d=%d  raw=%s  c11=%s  window=%s  fin=%s/%s imp=%s  flip=%s"
            % (
                r["d"],
                a["raw"],
                a["c11_rank"],
                a["window"],
                a["fin_rank"],
                a["window"],
                a["fin_imp"],
                a["flip_rank"],
            )
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
