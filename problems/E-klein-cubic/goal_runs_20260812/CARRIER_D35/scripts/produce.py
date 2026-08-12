#!/usr/bin/env python3
"""Carrier gateway at d=35.

1. Reconstruct the sealed d=34 GATE/LAND verdict (read-only).
2. Replay the Hessian window (on-curve W-bar multiplicity).
3. Certify I_C at the live primes (M2).
4. Build the F_p2 Hessian sextet (M2) and extra F_p2-points of C
   (hyperplane sections).  Rank the sealed 37-cell by evaluation
   (values only — valid restriction functionals).
5. Intersect with the sealed closed constraints of the 22.

Usage: python3 scripts/produce.py [p ...]
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
import time

import numpy as np

import paths
import collect_fp2 as CF
import fp2
import hesslib as H
import slicelib as SL
import window as W

RES = paths.RES
TMP = paths.TMP
T0 = time.time()


def dump(path, obj):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        json.dump(obj, f, indent=1, sort_keys=True)
        f.write("\n")


def reconstruct_d34():
    gate_sum = json.load(open(os.path.join(paths.GATE, "payload",
                                           "carrier_summary.json")))
    land_rep = open(os.path.join(paths.LAND, "REPORT.md")).read()
    rows = {}
    for p, rec in gate_sum.items():
        rows[str(p)] = {
            "n1": rec["n1"], "rank": rec["rank"], "n2": rec["n2"],
            "HF34": rec["IC"]["HF34"], "degree": rec["IC"]["degree"],
            "hilbPoly": rec["IC"]["hilbPoly"],
        }
    out = {
        "source_gate": "goal_runs_after_ac61998/FIX_VII_GATE",
        "source_land": "goal_runs_after_10804b2/FIX_VII_LAND",
        "chain": "M_34=576; (1,6) n1=16; restr-to-C rank 3; n2=13; LAND empty",
        "by_prime": rows,
        "n1_both": {r["n1"] for r in rows.values()} == {16},
        "rank_both": {r["rank"] for r in rows.values()} == {3},
        "n2_both": {r["n2"] for r in rows.values()} == {13},
        "land_empty_claimed": "EMPTY" in land_rep,
        "land_primes": [67, 199],
        "verdict": "CANONICAL_CARRIER_D34_CLOSED_NEGATIVE",
    }
    out["n1_both"] = bool(out["n1_both"])
    out["rank_both"] = bool(out["rank_both"])
    out["n2_both"] = bool(out["n2_both"])
    dump(os.path.join(RES, "d34_reconstruct.json"), out)
    return out


def run_ic(p):
    src = open(os.path.join(os.path.dirname(__file__), "ic_probe.m2")).read()
    outf = os.path.join(RES, "IC_p%d.txt" % p)
    sc = os.path.join(TMP, "ic%d.m2" % p)
    open(sc, "w").write(src.replace("PPP", str(p)).replace("OUTFILE", '"%s"' % outf))
    r = subprocess.run(["M2", "--script", sc], capture_output=True, text=True)
    if r.returncode:
        raise SystemExit("M2 I_C failed p=%d\n%s" % (p, r.stderr[-1500:]))
    info = {"p": p, "HF": {}}
    for line in open(outf):
        t = line.split()
        if not t:
            continue
        if t[0] == "HF":
            info["HF"][int(t[1])] = int(t[2])
        elif t[0] in ("p", "degH", "dimProj", "degree", "ngens"):
            info[t[0]] = int(t[1]) if t[1].lstrip("-").isdigit() else t[1]
        elif t[0] == "hilbPoly":
            info["hilbPoly"] = line.split(" ", 1)[1].strip()
    hp_ok = info.get("hilbPoly", "").replace(" ", "") in ("20*i-25", "-25+20*i")
    info["ok"] = (info.get("dimProj") == 1 and info.get("degree") == 20
                  and hp_ok and info["HF"].get(35) == 675
                  and info["HF"].get(34) == 655)
    dump(os.path.join(RES, "IC_p%d.json" % p), info)
    return info


def run_sextet(p, fr):
    g = H.first_involution(fr, p)
    Wp, Wm = H.plus_minus(fr, g, p)
    N = SL.nullspace(Wp, p)
    def lin(v):
        return "+".join("%d*x%d" % (int(c) % p, i)
                        for i, c in enumerate(v) if int(c) % p)
    src = open(os.path.join(os.path.dirname(__file__), "sextet.m2")).read()
    outf = os.path.join(RES, "sextet_p%d.txt" % p)
    src = (src.replace("PPP", str(p)).replace("LFORM1", lin(N[0]))
           .replace("LFORM2", lin(N[1])).replace("OUTFILE", '"%s"' % outf))
    open(os.path.join(TMP, "sextet%d.m2" % p), "w").write(src)
    r = subprocess.run(["M2", "--script", os.path.join(TMP, "sextet%d.m2" % p)],
                       capture_output=True, text=True)
    if r.returncode:
        raise SystemExit("M2 sextet failed p=%d\n%s" % (p, r.stderr[-1500:]))
    n2 = 0
    degs = []
    for line in open(outf):
        if line.startswith("ncomps2 "):
            n2 = int(line.split()[1])
        if line.startswith("comp2 dim="):
            degs.append(int(line.split("deg=")[1]))
    return {
        "involution": int(g),
        "ncomps2": n2,
        "comp2_degrees": degs,
        "six_linear_over_fp2": n2 == 6 and degs == [1] * 6,
    }


def c11_value_rank(fr, A, C, B, p):
    rec, pts = H.c11_points(fr, p)
    W = np.array(pts, dtype=np.int64)
    V = SL.jet_rows(fr, A, C, W, np.zeros_like(W), 1, deg=35)[:, :, :, 0] % p
    M = np.tensordot(B, V, axes=(1, 0)).reshape(37, -1) % p
    return {
        "n": len(pts),
        "all_on_X": rec["all_on_X"],
        "all_on_C": rec["all_on_C"],
        "value_rank": int(SL.rref_rank(M, p)),
    }


def meet_22(ker_lo):
    rows = []
    ok = True
    for p in (331, 661):
        rec = json.load(open(os.path.join(paths.DEPTH_RES,
                                          "keep_pass_22_p%d.json" % p)))
        ranks = [b["rank"] for d in rec["detail"] for b in d["branches"]]
        row = {
            "p": p, "n_live": rec["n_live"], "n_dead": rec["n_dead"],
            "all_closed_rank_0": all(r == 0 for r in ranks),
            "all_best_dim_37": all(d["best_dim"] == 37 for d in rec["detail"]),
        }
        rows.append(row)
        if not (row["n_live"] == 22 and row["all_closed_rank_0"]
                and row["all_best_dim_37"]):
            ok = False
    return {
        "sealed_keep_pass_ok": ok,
        "by_prime": rows,
        "kernel_dim_lower": ker_lo,
        "meets_closed_constraints": bool(ker_lo > 0 and ok),
        "note": (
            "The 22 occupy the full 37-cell linearly (closed rank 0). "
            "Any positive-dimensional subspace meets those closed constraints. "
            "KEEP non-vanishing on the kernel is not a closed cut."
        ),
    }


def run_prime(p):
    t0 = time.time()
    print("== carrier d=35 p=%d" % p, flush=True)
    fr = SL.build_frame(p, verbose=False)
    A = np.load(os.path.join(paths.PAIR_RES, "layer0_A_p331.npy"))
    C = np.load(os.path.join(paths.PAIR_RES, "layer0_C_p331.npy"))
    NUL = np.load(os.path.join(paths.PAIR_RES, "layer0_null_p%d.npy" % p)) % p
    CELL = np.load(os.path.join(paths.SIEVE_RES, "cell37_p%d.npy" % p)) % p
    assert CELL.shape == (37, 39)
    B = (CELL @ NUL) % p
    fd_ok, fd_n = H.fd_check_dH(p)
    print("  dH fd %d/%d" % (fd_ok, fd_n), flush=True)
    c11 = c11_value_rank(fr, A, C, B, p)
    print("  C11 n=%d onC=%s value_rank=%d" % (
        c11["n"], c11["all_on_C"], c11["value_rank"]), flush=True)
    sx = run_sextet(p, fr)
    print("  sextet over Fp2: %s comps %s" % (sx["ncomps2"], sx["comp2_degrees"]),
          flush=True)
    fp2rec = CF.collect_and_rank(p, n_hyper=8)
    rec = {
        "p": p,
        "dH_fd_check": [fd_ok, fd_n],
        "c11": c11,
        "sextet": sx,
        "fp2": fp2rec,
        "rank_values": fp2rec["rank_values"],
        "kernel_dim_upper": fp2rec["kernel_dim"],
        "kernel_dim_lower": 37 - paths.ONCURVE_WB[35],
        "oncurve_Wb_bound": paths.ONCURVE_WB[35],
        "saturated_at_character_bound": fp2rec["saturated_at_character_bound"],
        "seconds": round(time.time() - t0, 2),
    }
    dump(os.path.join(RES, "carrier_d35_p%d.json" % p), rec)
    return rec


def main(primes):
    print("CARRIER_D35 produce", primes, flush=True)
    d34 = reconstruct_d34()
    print("  d34 n1/rank/n2", d34["n1_both"], d34["rank_both"], d34["n2_both"],
          flush=True)
    win = W.window_rows([33, 34, 35, 36, 37])
    dump(os.path.join(RES, "hess_window.json"), {"rows": win})
    print("  window d=35 oncurve_Wb=%d molien=%d" % (
        win[2]["oncurve_Wb"], win[2]["molien_Wb"]), flush=True)
    ic = {}
    for p in primes:
        ic[p] = run_ic(p)
        print("  I_C p=%d ok=%s HF35=%s" % (p, ic[p]["ok"], ic[p]["HF"].get(35)),
              flush=True)
    recs = {p: run_prime(p) for p in primes}
    ranks = {p: recs[p]["rank_values"] for p in primes}
    agree = len(set(ranks.values())) == 1
    rk = recs[primes[0]]["rank_values"]
    ker_hi = 37 - rk
    ker_lo = 37 - paths.ONCURVE_WB[35]
    sat = all(recs[p]["saturated_at_character_bound"] for p in primes)
    meet = meet_22(ker_lo)
    dump(os.path.join(RES, "meet22.json"), meet)
    if sat and rk == 37:
        ansatz = "CANONICAL_CARRIER_D35_LINEARLY_DEAD"
        alive = False
    elif ker_lo > 0:
        ansatz = "CANONICAL_CARRIER_D35_LINEARLY_ALIVE"
        alive = True
    else:
        ansatz = "CANONICAL_CARRIER_D35_UNDECIDED"
        alive = None
    remaining = {
        "canonical_hessian": "linearly ALIVE at d=35" if alive else "see ansatz",
        "also_open": [
            "genus-5 A5-curves (11-orbit; FIX_VII §3)",
            "genus-12 F55-curves (12-orbit; FIX_VII §3)",
            "C11 Lefschetz / D12 genus>=3 induced carriers",
            "tower carriers over point orbits (Hodge-local)",
        ],
        "landing_cone": "NOT COMPUTED",
        "d34_contrast": (
            "d=34 died at LANDING on a 13-space, not at the linear cut. "
            "A d=35 landing cone on the Hessian kernel is FIX_VII_LAND's analogue "
            "and is out of scope (director msolve jobs own the box)."
        ),
    }
    dump(os.path.join(RES, "remaining_families.json"), remaining)
    summary = {
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "d34": d34,
        "window_d35": win[2],
        "ic_ok": {str(p): ic[p]["ok"] for p in primes},
        "rank_values_by_prime": {str(p): ranks[p] for p in primes},
        "two_prime_agree": agree,
        "rank_values": rk,
        "kernel_dim_interval": [ker_lo, ker_hi],
        "saturated_at_character_bound": sat,
        "ansatz": ansatz,
        "alive_linearly": alive,
        "meets_22_closed": meet["meets_closed_constraints"],
        "degree_excluded": False,
        "oddzero_idle": True,
        "flag": "no degree excluded; Problem E remains OPEN; ODDZERO gate idle",
        "seconds_total": round(time.time() - T0, 2),
    }
    dump(os.path.join(RES, "summary.json"), summary)
    print("SUMMARY", json.dumps({k: summary[k] for k in (
        "ansatz", "rank_values", "kernel_dim_interval", "meets_22_closed",
        "two_prime_agree", "degree_excluded")}, indent=2), flush=True)
    return summary


if __name__ == "__main__":
    ps = [int(a) for a in sys.argv[1:]] or list(paths.PRIMES)
    main(ps)
