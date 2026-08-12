#!/usr/bin/env python3
"""R5: recompute semi-regular degree of regularity. Full generator span."""
import json
import math
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import paths
from hilbert import degree_of_regularity, hilbert_coeff, macaulay_columns

CLAIMED = {55: 21, 520: 7, 1380: 5}
N = 37


def main():
    os.makedirs(paths.RES, exist_ok=True)
    rows = []
    all_ok = True
    for m, claimed in CLAIMED.items():
        dreg, coeffs = degree_of_regularity(N, m, dmax=40)
        cols = macaulay_columns(N, dreg) if dreg is not None else None
        # last nonnegative and the first nonpositive
        detail = []
        if dreg is not None:
            lo = max(0, dreg - 2)
            hi = dreg
            for d in range(lo, hi + 1):
                detail.append({"d": d, "coeff": coeffs[d]})
        rec = {
            "n": N,
            "m": m,
            "dreg": dreg,
            "claimed": claimed,
            "match": dreg == claimed,
            "macaulay_columns_at_dreg": cols,
            "nearby_coeffs": detail,
            "HF_3": hilbert_coeff(N, m, 3),
            "HF_4": hilbert_coeff(N, m, 4),
            "HF_5": hilbert_coeff(N, m, 5),
        }
        if m == 1380:
            rec["dim_Sym5"] = math.comb(41, 5)
            rec["macaulay_rows_deg5"] = 1380 * math.comb(38, 2)
            rec["first_possible_surjective_degree"] = 5
            rec["deg4_cannot_surject"] = {
                "rows": 37 * 1380,
                "cols": math.comb(40, 4),
                "rows_lt_cols": 37 * 1380 < math.comb(40, 4),
            }
        if m == 520:
            rec["dim_Sym7"] = math.comb(43, 7)
        if m == 55:
            rec["dim_Sym21"] = math.comb(57, 21)
        rows.append(rec)
        all_ok = all_ok and rec["match"]
        print("  m=%4d  dreg=%s  claimed=%d  cols=%s"
              % (m, dreg, claimed, cols), flush=True)

    out = {
        "model": "semi-regular cubics; dreg = first d with Hilbert coeff <= 0",
        "not_a_measurement_of_landing_ideal": True,
        "n": N,
        "rows": rows,
        "numbers_match_director": all_ok,
        "practical_conclusion": (
            "Use the FULL cubic span as generators. A 55-element subset has "
            "semi-regular dreg 21 (about 10^15 Macaulay columns). A 520-element "
            "subset has dreg 7 (about 32 million columns). The full 1380-span "
            "has dreg 5 (749398 columns). A subset is valid for emptiness "
            "(V(subset) contains V) and ruinously more expensive."
        ),
        "verdict": "CONFIRMED" if all_ok else "REFUTED",
    }
    with open(os.path.join(paths.RES, "r5_hilbert.json"), "w") as f:
        json.dump(out, f, indent=1)
    print("R5", out["verdict"], flush=True)
    return out


if __name__ == "__main__":
    main()
