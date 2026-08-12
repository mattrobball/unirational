#!/usr/bin/env python3
"""D35_LANDING verifier — replayable checks for the landing packet.

Groups:
  A  I3 plateau ranks (reload echelon; optional live re-sample cross-check)
  B  HF profile bookkeeping (N_d, bounds)
  C  character triviality of the 37-cell
  D  degeneracy kernel dims + section origin-only counts (from artefacts)
  E  cross-prime agreement (331 vs 661)
  F  live spot: re-sample a few cubics; re-run one P1 msolve section

Usage:  python3 verifier.py
"""
from __future__ import annotations

import itertools
import json
import os
import re
import subprocess
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
SCR = os.path.join(HERE, "scripts")
sys.path.insert(0, SCR)
import paths  # noqa: E402, F401
import landlib as L  # noqa: E402
import slicelib as SL  # noqa: E402

PASS = 0
FAIL = 0
CHECKS = []


def check(name, cond, detail=""):
    global PASS, FAIL
    ok = bool(cond)
    if ok:
        PASS += 1
        status = "OK"
    else:
        FAIL += 1
        status = "FAIL"
    line = "CHECK [%s] %s" % (status, name)
    if detail:
        line += "  " + str(detail)
    print(line, flush=True)
    CHECKS.append({"name": name, "ok": ok, "detail": str(detail)})
    return ok


def nmon(d, n=37):
    r = 1
    for i in range(d):
        r = r * (n + i) // (i + 1)
    return r


def load_json(name):
    fn = os.path.join(RES, name)
    if not os.path.isfile(fn):
        return None
    with open(fn) as fh:
        return json.load(fh)


def main():
    global PASS, FAIL
    t0 = time.time()
    print("D35_LANDING verifier", flush=True)
    print("=" * 60, flush=True)

    # ------------------------------------------------------------ A. plateau
    print("\n-- A. I3 plateau ranks --", flush=True)
    for p in (331, 661):
        plat = load_json("plateau_p%d.json" % p)
        check("plateau_json_p%d" % p, plat is not None)
        if not plat:
            continue
        check("N3_p%d" % p, plat.get("N3") == 9139, plat.get("N3"))
        check("P3_p%d" % p, plat.get("P3") == 1380, plat.get("P3"))
        check("HF3_p%d" % p, plat.get("HF3") == 7759, plat.get("HF3"))
        check("P3_plus_HF3_p%d" % p,
              plat.get("P3", 0) + plat.get("HF3", 0) == 9139)
        check("saturation_ok_p%d" % p, plat.get("saturation_ok") is True)
        extras = plat.get("extra_batches") or []
        check("extra_batches_zero_p%d" % p,
              len(extras) >= 2 and all(e.get("added", 1) == 0 for e in extras),
              extras)
        ech_path = os.path.join(RES, "I3_echelon_p%d.npy" % p)
        check("I3_echelon_exists_p%d" % p, os.path.isfile(ech_path))
        if os.path.isfile(ech_path):
            basis = np.load(ech_path)
            check("I3_echelon_rows_p%d" % p, basis.shape[0] == 1380,
                  basis.shape)
            check("I3_echelon_cols_p%d" % p, basis.shape[1] == 9139,
                  basis.shape)
            # rank of saved echelon should be full row rank
            rk = SL.rref_rank(basis % p, p)
            check("I3_echelon_rank_p%d" % p, rk == 1380, rk)

    # ------------------------------------------------------------ B. HF bookkeeping
    print("\n-- B. HF profile bookkeeping --", flush=True)
    check("nmon3", nmon(3) == 9139)
    check("nmon4", nmon(4) == 91390)
    check("nmon5", nmon(5) == 749398)
    # P4 cannot fill Sym^4
    check("P4_upper_lt_N4", 37 * 1380 < nmon(4),
          "37*1380=%d < %d" % (37 * 1380, nmon(4)))
    check("HF4_lower_bound", nmon(4) - 37 * 1380 == 40330)
    for p in (331, 661):
        hf = load_json("hf_mul_p%d.json" % p)
        check("hf_mul_json_p%d" % p, hf is not None)
        if hf and "d4" in hf:
            d4 = hf["d4"]
            check("P4_lb_ge_6000_p%d" % p, d4.get("P_lower_bound", 0) >= 6000,
                  d4.get("P_lower_bound"))
            check("HF4_lb_p%d" % p, d4.get("HF_lower_bound") == 40330,
                  d4.get("HF_lower_bound"))
            check("P4_cannot_full_p%d" % p, d4.get("cannot_be_full") is True
                  or d4.get("upper_bound_P", 0) < d4.get("N", 1))

    # ------------------------------------------------------------ C. character
    print("\n-- C. cell character (trivial residual action) --", flush=True)
    for p in (331, 661):
        fin = load_json("landing_final_p%d.json" % p)
        if fin and "character_trivial" in fin:
            check("char_trivial_cached_p%d" % p, fin["character_trivial"] is True)
        else:
            # live compute (slower)
            cell = L.load_cell(p)
            fr = SL.build_frame(p, verbose=False)
            char = L.cell_character(fr, cell, seed=1)
            iso = L.isotypic_multiplicities(char, p)
            check("char_trivial_live_p%d" % p,
                  iso.get("residual_action") == "trivial", iso)

    # ------------------------------------------------------------ D. sections
    print("\n-- D. degeneracy + sections from artefacts --", flush=True)
    for p in (331, 661):
        deg = load_json("degeneracy_p%d.json" % p)
        check("degeneracy_json_p%d" % p, deg is not None)
        if not deg:
            continue
        dk = deg.get("degeneracy_kernel", {})
        check("deg_ker_dim_p%d" % p, dk.get("kernel_dim") == 29, dk)
        check("deg_ker_rank_p%d" % p, dk.get("rank") == 8, dk)
        for lab, n_exp in (("P1", 40), ("P2", 25), ("P3", 12)):
            sec = deg.get("sections_%s" % lab, {})
            check("%s_origin_only_p%d" % (lab, p),
                  sec.get("n_origin_only") == n_exp, sec.get("n_origin_only"))
            check("%s_nontriv_zero_p%d" % (lab, p),
                  sec.get("n_nontriv", -1) == 0)
            check("%s_nondeg_zero_p%d" % (lab, p),
                  sec.get("n_nondeg_witnesses", -1) == 0)
        check("verdict_O1_leaning_p%d" % p,
              "O1" in deg.get("prime_verdict", {}).get("label", "")
              or "EMPTY" in deg.get("prime_verdict", {}).get("label", ""),
              deg.get("prime_verdict"))

    # ------------------------------------------------------------ E. cross-prime
    print("\n-- E. cross-prime agreement --", flush=True)
    p331 = load_json("plateau_p331.json") or {}
    p661 = load_json("plateau_p661.json") or {}
    check("P3_agree", p331.get("P3") == p661.get("P3") == 1380)
    check("HF3_agree", p331.get("HF3") == p661.get("HF3") == 7759)
    s331 = load_json("landing_summary.json") or {}
    check("summary_overall_O4", s331.get("overall") == "O4_INCONCLUSIVE",
          s331.get("overall"))
    check("summary_leaning_O1", s331.get("leaning") == "O1_EMPTY",
          s331.get("leaning"))
    check("summary_tier2", s331.get("honesty_tier") == 2)
    check("summary_not_claimed_flag",
          "NOT claimed" in (s331.get("flag") or "")
          or "not claimed" in (s331.get("flag") or "").lower()
          or "audit" in (s331.get("flag") or "").lower(),
          s331.get("flag"))

    # ------------------------------------------------------------ F. live spot
    print("\n-- F. live spot checks --", flush=True)
    p = 331
    cell = L.load_cell(p)
    fr = SL.build_frame(p, verbose=False)
    basis = np.load(os.path.join(RES, "I3_echelon_p%d.npy" % p)) % p
    # 20 fresh points must lie in the I3 span
    rng = np.random.default_rng(424242 + p)
    new_dirs = 0
    for _ in range(20):
        pt = rng.integers(0, p, size=(1, 5), dtype=np.int64)
        if not pt[0].any():
            pt[0, 0] = 1
        Mall = L.eval_cell_at_points(fr, cell, pt)
        row, _ = L.cubic_coeff_row(Mall[0], p)
        # reduce against echelon
        v = row.copy() % p
        pivots = []
        for i in range(basis.shape[0]):
            nz = np.nonzero(basis[i])[0]
            if not nz.size:
                continue
            piv = int(nz[0])
            pivots.append(piv)
            if v[piv]:
                v = (v - int(v[piv]) * basis[i]) % p
        if np.any(v):
            new_dirs += 1
    check("live_I3_span_20pts_p331", new_dirs == 0, "new_dirs=%d" % new_dirs)

    # one P1 section msolve GB origin-only
    B = rng.integers(0, p, size=(2, 37), dtype=np.int64)
    if SL.rref_rank(B, p) < 2:
        B[0, 0] = 1
        B[1, 1] = 1
    pts = rng.integers(0, p, size=(30, 5), dtype=np.int64)
    for i in range(30):
        if not pts[i].any():
            pts[i, 0] = 1
    Mall = L.eval_cell_at_points(fr, cell, pts)
    mons = list(itertools.combinations_with_replacement(range(2), 3))
    polys = []
    for q in range(30):
        Mr = (Mall[q] @ B.T) % p
        C3 = np.zeros((2, 2, 2), dtype=np.int64)
        for i in range(5):
            a, b = Mr[i], Mr[(i + 1) % 5]
            C3 = (C3 + np.einsum("u,v,w->uvw", a, a, b)) % p
        terms = []
        for (u, v, w) in mons:
            perms = set(itertools.permutations((u, v, w)))
            coef = sum(int(C3[t]) for t in perms) % p
            if coef:
                terms.append("%d*a%d*a%d*a%d" % (coef, u, v, w))
        if terms:
            polys.append("+".join(terms))
    ms = os.path.join(RES, "_verifier_P1.ms")
    mo = os.path.join(RES, "_verifier_P1.gb")
    open(ms, "w").write("a0,a1\n%d\n" % p + ",\n".join(polys) + "\n")
    try:
        r = subprocess.run(
            ["msolve", "-t", "2", "-g", "2", "-f", ms, "-o", mo],
            capture_output=True, text=True, timeout=60)
        ok = r.returncode == 0 and os.path.exists(mo) and os.path.getsize(mo) > 0
    except (subprocess.TimeoutExpired, FileNotFoundError) as e:
        ok = False
        print("  msolve spot skip:", e, flush=True)
    if ok:
        body = "".join(l for l in open(mo) if not l.startswith("#"))
        gens = sorted(set(map(int, re.findall(r"1\*a(\d+)\^1", body))))
        check("live_P1_msolve_irrelevant_p331", gens == [0, 1], gens)
    else:
        check("live_P1_msolve_irrelevant_p331", False, "msolve failed/missing")

    # ------------------------------------------------------------ summary
    print("\n" + "=" * 60, flush=True)
    print("PASS %d  FAIL %d  (%.1fs)" % (PASS, FAIL, time.time() - t0), flush=True)
    out = {
        "pass": PASS, "fail": FAIL, "checks": CHECKS,
        "seconds": time.time() - t0,
        "marker": "D35_LANDING_VERIFY_OK" if FAIL == 0 else "D35_LANDING_VERIFY_FAIL",
    }
    with open(os.path.join(RES, "verifier_output.json"), "w") as f:
        json.dump(out, f, indent=2)
    if FAIL == 0:
        print("D35_LANDING_VERIFY_OK", flush=True)
        print("ALLGREEN", flush=True)
        return 0
    print("D35_LANDING_VERIFY_FAIL", flush=True)
    return 1


if __name__ == "__main__":
    sys.exit(main())
