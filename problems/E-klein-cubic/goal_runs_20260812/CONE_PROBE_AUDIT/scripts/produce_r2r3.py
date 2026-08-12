#!/usr/bin/env python3
"""R2 section ranks and R3 free-argument chain. Own cubics, own Reynolds."""
import json
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import paths
from cell37 import cell37, load_AC
from cubics import F_linear_combo, cubic_rows, eval_form, nmon3
from frame import build_frame
from linalg import rref_rank
from reynolds import eval_at_points

assert "slicelib" not in sys.modules

MS = (6, 8, 10, 18, 19, 20, 22)
DIRECTOR = {
    6: {"dim_sym3": 56, "rank": 56},
    8: {"dim_sym3": 120, "rank": 120},
    10: {"dim_sym3": 220, "rank": 220},
    18: {"dim_sym3": 1140, "rank": 1140},
    19: {"dim_sym3": 1330, "rank": 1330},
    20: {"dim_sym3": 1540, "rank": 1380},
    22: {"dim_sym3": 2024, "rank": 1380},
}


def form_check(V, basis, rows, mons, p, rng, n=8):
    """F(sum t_i v_i) vs reconstructed cubic, at random t and a random point."""
    m = basis.shape[0]
    npts = V.shape[1]
    vsec = np.tensordot(basis % p, V % p, axes=(1, 0)) % p
    oks = 0
    for _ in range(n):
        q = int(rng.integers(0, npts))
        t = rng.integers(0, p, size=m)
        lhs = eval_form(rows[q], mons, t, p)
        rhs = F_linear_combo(vsec[:, q, :], t, p)
        oks += int(lhs == rhs)
    return oks, n


def one_prime(p, npts=2200, seed=0xE56A0D17):
    print("== R2/R3 sections, p=%d npts=%d" % (p, npts), flush=True)
    fr = build_frame(p, verbose=True)
    A, C = load_AC()
    cell = cell37(p)
    B = cell["B37"]
    rng = np.random.default_rng(seed + 17 * p)
    W = rng.integers(1, p, size=(npts, 5))
    print("  evaluating %d seeds at %d points..." % (A.shape[0], npts), flush=True)
    V = eval_at_points(fr, A, C, W, deg=paths.DEG, batch=48)
    print("  values done", V.shape, flush=True)
    np.save(os.path.join(paths.RES, "Vseed_p%d.npy" % p), V)
    np.save(os.path.join(paths.RES, "Wpts_p%d.npy" % p), W)
    np.save(os.path.join(paths.RES, "B37_p%d.npy" % p), B)

    # Global P3 on the 37-cell (sample of points; lower bound, decisive at 1380).
    print("  global P3...", flush=True)
    M37, mons37 = cubic_rows(V, B, p)
    p3 = rref_rank(M37, p)
    print("  P3 rank=%d (sealed 1380, npts=%d)" % (p3, npts), flush=True)

    sections = []
    free = {}
    for m in MS:
        nmon = nmon3(m)
        # two independent sections at free rungs; one elsewhere
        nsec = 2 if m in (18, 19) else 1
        sec_recs = []
        for sidx in range(nsec):
            S = rng.integers(0, p, size=(m, 37))
            srank = rref_rank(S, p)
            basis = (S @ B) % p
            brank = rref_rank(basis, p)
            rows, mons = cubic_rows(V, basis, p)
            r = rref_rank(rows, p)
            chk_ok, chk_n = form_check(V, basis, rows, mons, p, rng)
            exp = DIRECTOR[m]
            rec = {
                "m": m,
                "section": sidx,
                "S_rank": int(srank),
                "basis_rank": int(brank),
                "dim_sym3": nmon,
                "rank": int(r),
                "HF_L3": int(nmon - r),
                "generic_1380_rank": int(min(1380, nmon)),
                "director_rank": exp["rank"],
                "director_dim_sym3": exp["dim_sym3"],
                "matches_director": int(r) == exp["rank"] and nmon == exp["dim_sym3"],
                "full_sym3": int(r) == nmon,
                "form_check_ok": chk_ok,
                "form_check_n": chk_n,
                "npts": npts,
                "ti3_in_span": bool(int(r) == nmon),
                "bound_if_VcapL_zero": 37 - m,
            }
            print("  m=%2d sec=%d  rank=%5d / %5d  form=%d/%d  Srank=%d"
                  % (m, sidx, r, nmon, chk_ok, chk_n, srank), flush=True)
            sec_recs.append(rec)
        sections.extend(sec_recs)
        if m in (18, 19):
            free[str(m)] = {
                "all_full": all(s["full_sym3"] for s in sec_recs),
                "all_form": all(s["form_check_ok"] == s["form_check_n"] for s in sec_recs),
                "all_dim_m": all(s["S_rank"] == m and s["basis_rank"] == m for s in sec_recs),
                "n_sections": nsec,
                "bound": 37 - m,
            }

    r2_ok = all(s["matches_director"] for s in sections)
    r3_ok = free.get("18", {}).get("all_full") and free.get("19", {}).get("all_full")
    out = {
        "p": p,
        "npts": npts,
        "cell_shape": list(B.shape),
        "rank_U": cell["rank_U"],
        "P3_sampled": int(p3),
        "P3_sealed": 1380,
        "P3_match_or_lowerbound": int(p3) == 1380 or int(p3) >= 1380,
        "P3_note": "rank of sampled cubics; npts=%d so rank<=npts; 1380 is decisive if reached" % npts,
        "sections": sections,
        "free": free,
        "R2_matches_director_table": r2_ok,
        "R3_free_span": bool(r3_ok),
    }
    return out


def main():
    os.makedirs(paths.RES, exist_ok=True)
    summary = {"primes": {}, "R2": None, "R3": None}
    for p in paths.PRIMES:
        rec = one_prime(p)
        summary["primes"][str(p)] = rec
        with open(os.path.join(paths.RES, "r2r3_p%d.json" % p), "w") as f:
            json.dump(rec, f, indent=1)
    r2 = all(summary["primes"][str(p)]["R2_matches_director_table"] for p in paths.PRIMES)
    r3 = all(summary["primes"][str(p)]["R3_free_span"] for p in paths.PRIMES)
    # R2 verdict from the numbers; R3 math justification is written in THEOREM.
    summary["R2"] = "CONFIRMED" if r2 else "REFUTED"
    summary["R3_machine"] = "CONFIRMED" if r3 else "REFUTED"
    with open(os.path.join(paths.RES, "r2r3_summary.json"), "w") as f:
        json.dump(summary, f, indent=1)
    print("R2", summary["R2"], "R3_machine", summary["R3_machine"], flush=True)
    return summary


if __name__ == "__main__":
    main()
