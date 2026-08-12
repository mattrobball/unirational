#!/usr/bin/env python3
"""D35_LANDING producer: sample cubics on the 37-cell, character, Groebner.

Usage:
  python3 produce_landing.py            # both primes, full pipeline
  python3 produce_landing.py 331        # one prime
  python3 produce_landing.py 331 sample # stop after sampling
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
import time
import traceback

import numpy as np

import paths
import landlib as L
import slicelib as SL

RES = paths.RES
NPTS = 320  # >= 300 required
SAMPLE_SEED = 20260811


def run_msolve(ms_path, out_path, threads=4, gb=False, timeout=600):
    cmd = ["msolve", "-t", str(threads), "-f", ms_path, "-o", out_path]
    if gb:
        cmd = ["msolve", "-t", str(threads), "-g", "2", "-f", ms_path,
               "-o", out_path]
    t0 = time.time()
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        dt = time.time() - t0
        return {
            "ok": r.returncode == 0,
            "returncode": r.returncode,
            "seconds": dt,
            "stdout": (r.stdout or "")[-2000:],
            "stderr": (r.stderr or "")[-2000:],
            "out_size": os.path.getsize(out_path) if os.path.exists(out_path) else 0,
        }
    except subprocess.TimeoutExpired:
        return {
            "ok": False,
            "returncode": -1,
            "seconds": timeout,
            "stdout": "",
            "stderr": "TIMEOUT",
            "out_size": os.path.getsize(out_path) if os.path.exists(out_path) else 0,
        }


def run_m2(m2_path, out_path, timeout=600):
    t0 = time.time()
    try:
        r = subprocess.run(
            ["M2", "--script", m2_path],
            capture_output=True, text=True, timeout=timeout,
            cwd=os.path.dirname(m2_path) or ".",
        )
        dt = time.time() - t0
        text = (r.stdout or "") + "\n" + (r.stderr or "")
        open(out_path, "w").write(text)
        return {
            "ok": r.returncode == 0 and "DONE" in text,
            "returncode": r.returncode,
            "seconds": dt,
            "stdout_tail": text[-3000:],
            "dim_I": _parse_tag(text, "dim_I"),
            "deg_I": _parse_tag(text, "deg_I"),
            "dim_sat": _parse_tag(text, "dim_sat"),
            "deg_sat": _parse_tag(text, "deg_sat"),
        }
    except subprocess.TimeoutExpired:
        open(out_path, "w").write("TIMEOUT\n")
        return {
            "ok": False, "returncode": -1, "seconds": timeout,
            "stdout_tail": "TIMEOUT", "dim_I": None, "deg_I": None,
            "dim_sat": None, "deg_sat": None,
        }


def _parse_tag(text, tag):
    for line in text.splitlines():
        if line.strip().startswith(tag):
            parts = line.split()
            try:
                return int(parts[-1])
            except Exception:
                return parts[-1]
    return None


def parse_msolve_solve(out_path):
    """Parse msolve solve-mode output. Return status dict."""
    if not os.path.exists(out_path) or os.path.getsize(out_path) == 0:
        return {"status": "empty_or_missing", "n_solutions": None,
                "origin_only": False, "raw_head": ""}
    s = open(out_path).read()
    head = s[:500]
    # msolve solve format: [n_vars_info..., solutions]
    # origin-only certificate pattern from FIX-VII: many [-1,\n[0]] blocks
    n_zero_coords = s.count("[-1,\n[0]]") + s.count("[-1: [0]]")
    # also count simple zero patterns
    origin_markers = s.count("[0, 1]") + s.count("[0,1]")
    # detect "no solution" 
    no_sol = ("[-1]" in s and "[]" in s) or s.strip() in ("[-1]", "[-1]\n")
    # detect positive-dimensional or failure
    return {
        "status": "parsed",
        "n_zero_coord_blocks": n_zero_coords,
        "origin_markers": origin_markers,
        "origin_only": n_zero_coords >= 30,  # 37 vars -> expect ~36 blocks
        "raw_head": head,
        "raw_len": len(s),
        "no_solution_hint": no_sol,
    }


def parse_msolve_gb(out_path, nvars=37):
    if not os.path.exists(out_path) or os.path.getsize(out_path) == 0:
        return {"status": "empty_or_missing", "is_irrelevant": False}
    body = "".join(l for l in open(out_path) if not l.startswith("#"))
    import re
    gens = re.findall(r"1\*c(\d+)\^1", body)
    gens_i = sorted(set(map(int, gens)))
    is_irr = gens_i == list(range(nvars))
    return {
        "status": "parsed",
        "linear_gens": gens_i,
        "n_linear_gens": len(gens_i),
        "is_irrelevant": is_irr,
        "body_len": len(body),
        "body_head": body[:400],
    }


def linear_kernel_dim(rows, p):
    if rows is None or len(rows) == 0:
        return 37
    return 37 - SL.rref_rank(np.array(rows, dtype=np.int64) % p, p)


def process_prime(p, stage="full"):
    print("=" * 60)
    print("PRIME", p)
    print("=" * 60)
    t_all = time.time()
    out = {"p": p, "stage": stage}

    print("[1] load cell + frame")
    cell = L.load_cell(p)
    fr = SL.build_frame(p, verbose=True)
    out["rank_U"] = cell["rank_U"]
    out["dim_cell"] = 37
    assert cell["rank_U"] == 2, cell["rank_U"]

    # degeneracy linear loci dims
    print("[2] degeneracy loci ranks")
    M_line = L.minus_line_vanishing_matrix(fr, cell, n_dirs=12, seed=3)
    rk_line = SL.rref_rank(M_line, p)
    dim_line_kernel = 37 - rk_line
    out["degeneracy"] = {
        "minus_line_T_zero_rank": int(rk_line),
        "minus_line_T_zero_kernel_dim": int(dim_line_kernel),
        "note": ("kernel = {c : T_c vanishes at 12 sample points of L_sigma}; "
                 "full vanishing on L is the closed locus killing all 22 "
                 "order-0 line branches"),
    }
    print("  minus-line vanishing rank=%d kernel_dim=%d" % (
        rk_line, dim_line_kernel))

    print("[3] G-character of 37-cell")
    char = L.cell_character(fr, cell, seed=1)
    iso = L.isotypic_multiplicities(char, p)
    out["character"] = char
    out["isotypic"] = iso
    print("  isotypic mults:", iso["multiplicities"], "dim_ok", iso["dim_ok"])
    if not iso["dim_ok"]:
        print("  WARNING dim_check=%d != 37 — character may need Galois pairs"
              % iso["dim_check"])

    print("[4] sample landing cubics (n=%d)" % NPTS)
    samp = L.sample_landing_cubics(fr, cell, npts=NPTS, seed=SAMPLE_SEED + p,
                                   batch=20)
    # persist rows
    rows_path = os.path.join(RES, "cubic_rows_p%d.npy" % p)
    np.save(rows_path, samp["rows"])
    # plateau: check stability over last several rank reports
    ranks = [r["rank"] for r in samp["ranks"]]
    plateau = samp["plateau_rank"]
    # extra saturation: sample more if still climbing at the end
    if len(ranks) >= 3 and ranks[-1] > ranks[-3]:
        print("  rank still climbing; extra 200 points")
        extra = L.sample_landing_cubics(fr, cell, npts=200,
                                        seed=SAMPLE_SEED + p + 99, batch=20)
        all_rows = np.concatenate([samp["rows"], extra["rows"]], axis=0) % p
        plateau = SL.rref_rank(all_rows, p)
        np.save(rows_path, all_rows)
        samp["rows"] = all_rows
        samp["ranks"].extend(extra["ranks"])
        samp["plateau_rank"] = int(plateau)
        samp["npts"] = NPTS + 200
        ranks = [r["rank"] for r in samp["ranks"]]

    out["sampling"] = {
        "npts": samp["npts"],
        "seed": samp["seed"],
        "nmons": samp["nmons"],
        "plateau_rank": int(samp["plateau_rank"]),
        "rank_curve": samp["ranks"],
        "rows_path": rows_path,
    }
    print("  PLATEAU dim (deg-3 piece span) =", samp["plateau_rank"])

    # save a compact mons-free summary of first 0 rows? mons are deterministic
    mons = samp["mons"]

    if stage == "sample":
        out["seconds"] = time.time() - t_all
        _dump(p, out)
        return out

    # Extract a spanning set of independent cubics (RREF row basis)
    print("[5] extract independent cubics for CAS")
    indep = _independent_rows(samp["rows"], p)
    print("  independent cubics:", indep.shape[0])
    out["n_independent_cubics"] = int(indep.shape[0])
    np.save(os.path.join(RES, "cubic_indep_p%d.npy" % p), indep)

    # Write msolve + M2 inputs
    ms_path = os.path.join(RES, "land_p%d.ms" % p)
    n_eq = L.write_msolve_system(ms_path, p, indep, mons)
    out["msolve_input"] = {"path": ms_path, "n_eqs": n_eq}

    # random linear forms spanning a complement to the line-kernel for sat
    # Use the rows of M_line themselves as the degeneracy ideal generators
    # (linear).
    sat_linears = [list(map(int, M_line[i])) for i in range(min(15, M_line.shape[0]))
                   if any(int(x) % p for x in M_line[i])]
    m2_path = os.path.join(RES, "land_p%d.m2" % p)
    L.write_m2_dim(m2_path, p, indep, mons, sat_linears=sat_linears)
    out["m2_input"] = m2_path

    print("[6] msolve solve-mode")
    mo = os.path.join(RES, "land_p%d.out" % p)
    ms_meta = run_msolve(ms_path, mo, threads=4, gb=False, timeout=900)
    ms_parse = parse_msolve_solve(mo)
    out["msolve_solve"] = {**ms_meta, "parse": ms_parse}
    print("  msolve solve:", ms_meta["ok"], "sec=%.1f" % ms_meta["seconds"],
          "parse", ms_parse.get("origin_only"), ms_parse.get("status"))

    print("[7] msolve GB-mode (-g 2) if solve was quick / small")
    mo_gb = os.path.join(RES, "land_p%d_gb.out" % p)
    if ms_meta["seconds"] < 120 or ms_parse.get("origin_only"):
        gb_meta = run_msolve(ms_path, mo_gb, threads=4, gb=True, timeout=900)
        gb_parse = parse_msolve_gb(mo_gb, nvars=37)
        out["msolve_gb"] = {**gb_meta, "parse": gb_parse}
        print("  GB:", gb_meta["ok"], "irrelevant?", gb_parse.get("is_irrelevant"),
              "n_lin", gb_parse.get("n_linear_gens"))
    else:
        # still try with shorter timeout
        gb_meta = run_msolve(ms_path, mo_gb, threads=4, gb=True, timeout=300)
        gb_parse = parse_msolve_gb(mo_gb, nvars=37)
        out["msolve_gb"] = {**gb_meta, "parse": gb_parse}
        print("  GB (short):", gb_meta.get("stderr", "")[:80],
              gb_parse.get("status"))

    print("[8] M2 dim + saturate")
    m2_out = os.path.join(RES, "land_p%d_m2.out" % p)
    m2_meta = run_m2(m2_path, m2_out, timeout=900)
    out["m2"] = m2_meta
    print("  M2 dim_I=%s deg_I=%s dim_sat=%s sec=%.1f" % (
        m2_meta.get("dim_I"), m2_meta.get("deg_I"),
        m2_meta.get("dim_sat"), m2_meta["seconds"]))

    # Optional: try low-dimensional random linear sections for witnesses
    print("[9] random P1/P2 sections for witness search")
    witnesses = search_witnesses(fr, cell, p, n_trials=40, seed=7)
    out["witness_search"] = witnesses
    print("  nondeg hits:", witnesses["n_nondeg"],
          "deg hits:", witnesses["n_deg"], "empty sections:", witnesses["n_empty"])

    # Verdict for this prime
    out["prime_verdict"] = decide_prime_verdict(out)
    print("  PRIME VERDICT:", out["prime_verdict"]["label"])
    out["seconds"] = time.time() - t_all
    _dump(p, out)
    return out


def _independent_rows(rows, p):
    """Return a maximal independent subset of rows over F_p."""
    A = np.array(rows, dtype=np.int64) % p
    m, n = A.shape
    chosen = []
    basis = []
    r = 0
    # build RREF tracking which original rows
    M = A.copy()
    row_idx = list(range(m))
    for c in range(n):
        piv = None
        for i in range(r, m):
            if M[i, c]:
                piv = i
                break
        if piv is None:
            continue
        M[[r, piv]] = M[[piv, r]]
        row_idx[r], row_idx[piv] = row_idx[piv], row_idx[r]
        inv = SL.inv_mod(int(M[r, c]), p)
        M[r] = (M[r] * inv) % p
        col = M[:, c].copy()
        col[r] = 0
        nz = np.nonzero(col)[0]
        if nz.size:
            M[nz] = (M[nz] - np.outer(col[nz], M[r])) % p
        chosen.append(row_idx[r])
        r += 1
        if r == m:
            break
    return A[chosen] if chosen else A[:0]


def search_witnesses(fr, cell, p, n_trials=40, seed=7):
    """Search low-dim linear sections of the 37-cell for landing points.

    For a random 2-plane in c-space, sample many x and build the restricted
    cubic system in 2 homogeneous coords; try to find nonzero c on the plane
    with F(T_c)(x)=0 for many x, then check non-degeneracy (T not zero on L).
    """
    rng = np.random.default_rng(seed)
    n_empty = 0
    n_deg = 0
    n_nondeg = 0
    examples = []
    # Simpler direct approach: random c in P^36, check if F(T_c) vanishes
    # at many points (unlikely) — instead use that for each random x, the
    # cubic hypersurface F(T_c)(x)=0 is a cubic in c; take several and look
    # for common zeros via M2 on random 3-dimensional linear sections.
    for trial in range(n_trials):
        # random 3-dim subspace of cell: 3 random vectors
        basis = rng.integers(0, p, size=(3, 37), dtype=np.int64)
        if SL.rref_rank(basis, p) < 3:
            continue
        # sample 40 points, get cubics in a0,a1,a2 where c = a @ basis
        pts = rng.integers(0, p, size=(40, 5), dtype=np.int64)
        for i in range(40):
            if not pts[i].any():
                pts[i, 0] = 1
        M_all = L.eval_cell_at_points(fr, cell, pts)  # (40,5,37)
        # restricted: M_rest[q] is 5x3 = M_all[q] @ basis.T
        eqs = []
        for q in range(40):
            Mr = (M_all[q] @ basis.T) % p  # 5x3
            # F(Mr a) cubic in a0,a1,a2
            C3 = np.zeros((3, 3, 3), dtype=np.int64)
            for i in range(5):
                a = Mr[i]
                b = Mr[(i + 1) % 5]
                C3 = (C3 + np.einsum("u,v,w->uvw", a, a, b)) % p
            terms = []
            for u, v, w in itertools.combinations_with_replacement(range(3), 3):
                perms = set(itertools.permutations((u, v, w)))
                coef = sum(int(C3[q]) for q in perms) % p
                if coef:
                    terms.append((coef, u, v, w))
            eqs.append(terms)
        # write tiny msolve system
        ms = os.path.join(RES, "_tmp_sec_p%d.ms" % p)
        polys = []
        for terms in eqs:
            if not terms:
                continue
            polys.append("+".join("%d*a%d*a%d*a%d" % (c, u, v, w)
                                  for c, u, v, w in terms))
        if len(polys) < 3:
            continue
        open(ms, "w").write(
            "a0,a1,a2\n%d\n" % p + ",\n".join(polys) + "\n")
        mo = os.path.join(RES, "_tmp_sec_p%d.out" % p)
        meta = run_msolve(ms, mo, threads=2, gb=False, timeout=30)
        if not meta["ok"] or meta["out_size"] == 0:
            continue
        s = open(mo).read()
        # crude: if only origin, count empty; if other solutions, try to parse
        n_zero = s.count("[-1,\n[0]]")
        if n_zero >= 2 and "[0, 1]" in s.replace("\n", " "):
            # check if ONLY origin: msolve lists one solution with all zero
            # If there are nonzero coords somewhere, not origin-only
            if s.count("[[-1,\n[0]]]") >= 3 or (n_zero >= 2 and s.count("[1,") == 0
                                                and s.count("[2,") == 0):
                # still may have only origin
                n_empty += 1
                continue
        # try to find a nonzero a by brute force over F_p for small search
        hit = None
        for _ in range(200):
            a = rng.integers(0, p, size=3, dtype=np.int64)
            if not a.any():
                continue
            c = (a @ basis) % p
            # check F(T_c) at 15 random points
            ok = True
            chk = rng.integers(0, p, size=(15, 5), dtype=np.int64)
            Mc = L.eval_cell_at_points(fr, cell, chk)  # (15,5,37)
            for q in range(15):
                v = (Mc[q] @ c) % p
                if L.klein_F(v, p) != 0:
                    ok = False
                    break
            if not ok:
                continue
            # non-degeneracy: T not identically zero on minus-line samples
            Wm = fr["Wminus"]
            coefs = rng.integers(0, p, size=(8, 2), dtype=np.int64)
            lpts = (coefs @ Wm) % p
            Ml = L.eval_cell_at_points(fr, cell, lpts)
            line_vals = (Ml @ c) % p  # (8,5)
            if np.any(line_vals % p):
                hit = {"c": list(map(int, c)), "a": list(map(int, a)),
                       "nondeg": True}
                n_nondeg += 1
                examples.append(hit)
                break
            else:
                hit = {"c": list(map(int, c)), "nondeg": False}
                n_deg += 1
                break
        if hit is None:
            n_empty += 1
    return {
        "n_trials": n_trials,
        "n_empty": n_empty,
        "n_deg": n_deg,
        "n_nondeg": n_nondeg,
        "examples": examples[:5],
    }


import itertools


def decide_prime_verdict(out):
    """Local O1-O4 decision from artefacts."""
    gb = out.get("msolve_gb", {}).get("parse", {})
    sol = out.get("msolve_solve", {}).get("parse", {})
    m2 = out.get("m2", {})
    wit = out.get("witness_search", {})

    if gb.get("is_irrelevant") or (
            sol.get("origin_only") and m2.get("dim_I") in (-1, 0)
            and (m2.get("deg_I") in (0, 1, None) or m2.get("dim_I") == -1)):
        # dim 0 degree 1 = only origin in affine; dim -1 = empty projective
        if gb.get("is_irrelevant") or m2.get("dim_I") == -1 or (
                m2.get("dim_I") == 0 and m2.get("deg_I") == 1):
            return {
                "label": "O1_EMPTY_CANDIDATE",
                "reason": "sampled ideal is irrelevant / only origin",
                "flag": "window-closure candidate; audit gate required",
            }
    if wit.get("n_nondeg", 0) > 0:
        return {
            "label": "O3_CANDIDATE_WITNESS",
            "reason": "found non-degenerate c with F(T_c)~0 on samples",
            "flag": "positive-side sensation; audit gate required",
            "example": wit["examples"][0] if wit.get("examples") else None,
        }
    if wit.get("n_deg", 0) > 0 and wit.get("n_nondeg", 0) == 0:
        # weak evidence for O2 — need component certification
        if m2.get("dim_sat") in (-1, 0) and m2.get("dim_I") not in (-1, None):
            return {
                "label": "O2_DEGENERATE_ONLY_CANDIDATE",
                "reason": "section hits only deg loci; sat dim low",
                "flag": "needs component-by-component cert",
            }
    # stuck?
    stuck = []
    if not out.get("msolve_solve", {}).get("ok"):
        stuck.append("msolve_solve_failed_or_timeout")
    if not gb.get("is_irrelevant") and not sol.get("origin_only"):
        stuck.append("no_irrelevant_ideal_certificate")
    if m2.get("dim_I") is None:
        stuck.append("m2_dim_unavailable")
    else:
        stuck.append("m2_dim_I=%s" % m2.get("dim_I"))
    if out["sampling"]["plateau_rank"] < 50:
        stuck.append("low_plateau_rank=%d" % out["sampling"]["plateau_rank"])
    return {
        "label": "O4_INCONCLUSIVE",
        "reason": "resource or structural obstruction",
        "stuck_at": stuck,
        "plateau_rank": out["sampling"]["plateau_rank"],
        "m2_dim_I": m2.get("dim_I"),
        "m2_dim_sat": m2.get("dim_sat"),
        "msolve_ok": out.get("msolve_solve", {}).get("ok"),
    }


def _dump(p, out):
    # make JSON-safe
    def conv(o):
        if isinstance(o, (np.integer,)):
            return int(o)
        if isinstance(o, (np.floating,)):
            return float(o)
        if isinstance(o, np.ndarray):
            return o.tolist()
        raise TypeError(type(o))
    path = os.path.join(RES, "landing_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(out, f, indent=2, default=conv)
    print("wrote", path)


def combine_verdicts(results):
    labels = {p: results[p]["prime_verdict"]["label"] for p in results}
    if all(l == "O1_EMPTY_CANDIDATE" for l in labels.values()):
        overall = "O1_EMPTY"
    elif all(l.startswith("O2") for l in labels.values()):
        overall = "O2_DEGENERATE_ONLY"
    elif any(l.startswith("O3") for l in labels.values()):
        overall = "O3_CANDIDATE"
    else:
        overall = "O4_INCONCLUSIVE"
    return {"overall": overall, "per_prime": labels}


def main():
    args = sys.argv[1:]
    primes = list(L.PRIMES)
    stage = "full"
    if args:
        if args[0] in ("331", "661"):
            primes = [int(args[0])]
            args = args[1:]
        if args and args[0] in ("sample", "full"):
            stage = args[0]
    results = {}
    for p in primes:
        try:
            results[p] = process_prime(p, stage=stage)
        except Exception as e:
            traceback.print_exc()
            results[p] = {"p": p, "error": str(e),
                          "prime_verdict": {"label": "O4_INCONCLUSIVE",
                                           "reason": "exception",
                                           "stuck_at": [str(e)]}}
            _dump(p, results[p])
    if stage == "full" and len(results) == 2:
        summary = {
            "combine": combine_verdicts(results),
            "plateaus": {p: results[p].get("sampling", {}).get("plateau_rank")
                         for p in results},
            "characters": {
                p: results[p].get("isotypic", {}).get("multiplicities")
                for p in results
            },
            "verdicts": {p: results[p].get("prime_verdict") for p in results},
        }
        with open(os.path.join(RES, "landing_summary.json"), "w") as f:
            json.dump(summary, f, indent=2)
        print("OVERALL:", summary["combine"]["overall"])
    return 0


if __name__ == "__main__":
    sys.exit(main())
