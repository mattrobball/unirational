#!/usr/bin/env python3
"""Compile the per-degree cut table and re-issue the d=34..42 alive table."""
from __future__ import annotations

import json
import os
import sys

import paths

RES = paths.RES


def load(name):
    path = os.path.join(RES, name)
    with open(path) as f:
        return json.load(f)


def main():
    cuts = {}
    for d in paths.CUT_DEGREES:
        for p in paths.PRIMES:
            rec = load("cut_d%d_p%d.json" % (d, p))
            cuts[(d, p)] = rec

    rows = []
    for d in paths.CUT_DEGREES:
        a, b = cuts[(d, 331)], cuts[(d, 661)]
        agree = (
            a["cell_dim"] == b["cell_dim"]
            and a["rank"] == b["rank"]
            and a["new_dim"] == b["new_dim"]
            and a["sealed_ok"] and b["sealed_ok"]
            and a["cut60"]["sat_ok"] and b["cut60"]["sat_ok"]
        )
        rows.append({
            "d": d,
            "d_mod_11": d % 11,
            "is_qr": paths.is_qr(d),
            "sealed_cell": paths.SEALED_CELL[d],
            "cell_331": a["cell_dim"],
            "cell_661": b["cell_dim"],
            "rank_331": a["rank"],
            "rank_661": b["rank"],
            "new_dim_331": a["new_dim"],
            "new_dim_661": b["new_dim"],
            "sat_ok": a["cut60"]["sat_ok"] and b["cut60"]["sat_ok"],
            "one_frame_matches": (
                a["one_frame_rank_matches_60"] and b["one_frame_rank_matches_60"]
            ),
            "c11_already_in_structure": a["c11_already_in_structure"],
            "flagged_zero": a["flagged_zero"] or b["flagged_zero"],
            "agree": agree,
        })

    # Re-issued alive table: QR degrees take the new dim; NQR rows unchanged.
    alive = []
    for d in range(34, 43):
        qr = paths.is_qr(d)
        old = paths.SEALED_CELL[d]
        if d in paths.CUT_DEGREES:
            new = cuts[(d, 331)]["new_dim"]
            source = "this packet (60-point cut)"
        else:
            new = old
            source = "NQR unchanged" if not qr else "QR already empty (d=34); not recut"
        if d in paths.NQR_UNCHANGED and d != 35:
            note = "NQR row unchanged (C11 already in the ladder)"
        elif d == 35:
            note = "NQR control: rank 0, dim stays 39"
        elif d == 34:
            note = "QR but sealed empty; 60-point cut is vacuous"
        else:
            note = "QR degree: cell %d -> %d after 60 C11-points" % (old, new)
        alive.append({
            "d": d,
            "d_mod_11": d % 11,
            "class": "QR" if qr else "NQR",
            "old_cell": old,
            "new_cell": new,
            "changed": new != old,
            "source": source,
            "note": note,
        })

    census = {
        p: {
            "n_points": load("c11_census_p%d.json" % p)["n_points"],
            "n_frames": load("c11_census_p%d.json" % p)["n_frames"],
            "n_order11_elements": load("c11_census_p%d.json" % p)["n_order11_elements"],
            "all_on_X": load("c11_census_p%d.json" % p)["all_on_X"],
            "ladder_five_is_a_frame": load("c11_census_p%d.json" % p)["ladder_five_is_a_frame"],
        }
        for p in paths.PRIMES
    }

    any_flag = any(r["flagged_zero"] for r in rows)
    d35_rank = rows[0]["rank_331"] if rows[0]["d"] == 35 else None
    # locate d=35
    d35 = next(r for r in rows if r["d"] == 35)

    summary = {
        "primes": list(paths.PRIMES),
        "cut_degrees": list(paths.CUT_DEGREES),
        "census": census,
        "control_d35_rank": d35["rank_331"],
        "control_ok": d35["rank_331"] == 0 == d35["rank_661"],
        "sealed_ok": all(r["cell_331"] == r["sealed_cell"] == r["cell_661"] for r in rows),
        "two_prime_agree": all(r["agree"] for r in rows),
        "any_flagged_zero": any_flag,
        "cut_rows": rows,
        "alive_table": alive,
        "headline": "Problem E remains OPEN; this packet excludes no degree",
        "semantics": (
            "new_dim is a modular upper bound when positive; new_dim=0 on a "
            "previously alive cell is FLAGGED behind an ODDZERO-standard audit "
            "and is never claimed as a degree exclusion."
        ),
    }
    out = os.path.join(RES, "summary.json")
    with open(out, "w") as f:
        json.dump(summary, f, indent=1, sort_keys=True)
        f.write("\n")
    print("wrote", out)
    print("control d=35 rank", d35["rank_331"], d35["rank_661"],
          "ok" if summary["control_ok"] else "FAIL")
    print("cuts:")
    for r in rows:
        print("  d=%d  cell=%d  rank=%d  new=%d  flag=%s"
              % (r["d"], r["cell_331"], r["rank_331"], r["new_dim_331"],
                 r["flagged_zero"]))
    print("alive:")
    for a in alive:
        print("  d=%d  %s  %d -> %d  (%s)"
              % (a["d"], a["class"], a["old_cell"], a["new_cell"], a["note"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
