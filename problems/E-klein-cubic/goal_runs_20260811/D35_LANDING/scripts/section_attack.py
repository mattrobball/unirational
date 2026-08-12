#!/usr/bin/env python3
"""Landing certificate via linear sections + plateau saturation.

Full 37-variable msolve on 500+ dense cubics is a resource wall (70MB
input). Strategy:

1. Saturate the cubic span (incremental rank) -> plateau dimension.
2. Character of the 37-cell (trivial residual action; recorded).
3. Random linear sections of dimension s in {2,3,4}: restrict the landing
   cubics to a P^s, run msolve; record whether only the origin appears.
4. M2 dim on the full independent cubic ideal with a DegreeLimit / timeout.
5. Direct random-c search is useless; section solve is the witness channel.

Both primes. Outputs JSON under results/.
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

import paths
import landlib as L
import slicelib as SL

RES = paths.RES


def inv(a, p):
    return pow(int(a) % p, p - 2, p)


def rref_rank(M, p):
    return SL.rref_rank(M, p)


# --------------------------------------------------------------------------- plateau
def saturate_plateau(p, max_pts=2500, stable_window=250, seed=20260811):
    cell = L.load_cell(p)
    fr = SL.build_frame(p, verbose=True)
    rng = np.random.default_rng(seed + p)
    K = 37
    nmons = (K * (K + 1) * (K + 2)) // 6
    basis = np.zeros((0, nmons), dtype=np.int64)
    pivots = []
    indep = []
    curve = []
    t0 = time.time()
    n = 0
    stable = 0

    def reduce(v):
        v = v.copy() % p
        for i, piv in enumerate(pivots):
            if v[piv]:
                v = (v - int(v[piv]) * basis[i]) % p
        return v

    def extend(v, orig):
        nonlocal basis
        nz = np.nonzero(v)[0]
        if not nz.size:
            return False
        piv = int(nz[0])
        v = (v * inv(v[piv], p)) % p
        if basis.shape[0]:
            col = basis[:, piv].copy()
            nz2 = np.nonzero(col)[0]
            if nz2.size:
                basis[nz2] = (basis[nz2] - np.outer(col[nz2], v)) % p
        basis = np.vstack([basis, v]) if basis.shape[0] else v.reshape(1, -1)
        pivots.append(piv)
        indep.append(orig % p)
        return True

    print("[plateau] p=%d" % p, flush=True)
    while n < max_pts and stable < stable_window:
        pts = rng.integers(0, p, size=(16, 5), dtype=np.int64)
        for i in range(16):
            if not pts[i].any():
                pts[i, 0] = 1
        Mall = L.eval_cell_at_points(fr, cell, pts)
        for q in range(16):
            if n >= max_pts or stable >= stable_window:
                break
            row, _ = L.cubic_coeff_row(Mall[q], p)
            n += 1
            vr = reduce(row)
            if np.any(vr):
                extend(vr, row)
                stable = 0
            else:
                stable += 1
            if n % 100 == 0:
                curve.append({"n": n, "rank": len(pivots), "stable": stable,
                              "t": time.time() - t0})
                print("  n=%d rank=%d stable=%d (%.1fs)" % (
                    n, len(pivots), stable, time.time() - t0), flush=True)
    out = {
        "p": p, "npts": n, "plateau_rank": len(pivots), "nmons": nmons,
        "saturated": stable >= stable_window, "stable_window": stable_window,
        "seconds": time.time() - t0, "rank_curve": curve,
    }
    np.save(os.path.join(RES, "cubic_indep_p%d.npy" % p),
            np.array(indep, dtype=np.int64) if indep else np.zeros((0, nmons)))
    with open(os.path.join(RES, "plateau_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=2)
    print("[plateau] DONE rank=%d sat=%s" % (out["plateau_rank"], out["saturated"]),
          flush=True)
    return out, np.array(indep, dtype=np.int64), cell, fr


# --------------------------------------------------------------------------- sections
def section_msolve(p, fr, cell, sec_dim, n_sections, seed, timeout=60):
    """Restrict landing to random P^{sec_dim} in the 37-cell; msolve each."""
    rng = np.random.default_rng(seed)
    K = 37
    results = []
    n_origin_only = 0
    n_nontriv = 0
    n_fail = 0
    n_nondeg_wit = 0
    witnesses = []
    mons3 = list(itertools.combinations_with_replacement(range(sec_dim + 1), 3))
    # sec_dim is projective dim => sec_dim+1 affine coords
    nvars = sec_dim + 1

    for sidx in range(n_sections):
        # random (nvars) x 37 basis of a linear subspace
        B = rng.integers(0, p, size=(nvars, K), dtype=np.int64)
        if rref_rank(B, p) < nvars:
            continue
        # sample many points to get restricted cubics
        npts = max(40, 3 * nvars * nvars)
        pts = rng.integers(0, p, size=(npts, 5), dtype=np.int64)
        for i in range(npts):
            if not pts[i].any():
                pts[i, 0] = 1
        Mall = L.eval_cell_at_points(fr, cell, pts)  # (npts,5,37)
        polys = []
        for q in range(npts):
            Mr = (Mall[q] @ B.T) % p  # 5 x nvars
            C3 = np.zeros((nvars,) * 3, dtype=np.int64)
            for i in range(5):
                a, b = Mr[i], Mr[(i + 1) % 5]
                C3 = (C3 + np.einsum("u,v,w->uvw", a, a, b)) % p
            terms = []
            for (u, v, w) in mons3:
                perms = set(itertools.permutations((u, v, w)))
                coef = sum(int(C3[t]) for t in perms) % p
                if coef:
                    terms.append("%d*a%d*a%d*a%d" % (coef, u, v, w))
            if terms:
                polys.append("+".join(terms))
        if len(polys) < nvars:
            n_fail += 1
            continue
        # write msolve
        ms = os.path.join(RES, "_sec_p%d_d%d_%d.ms" % (p, sec_dim, sidx))
        mo = os.path.join(RES, "_sec_p%d_d%d_%d.out" % (p, sec_dim, sidx))
        header = ",".join("a%d" % i for i in range(nvars))
        open(ms, "w").write(header + "\n%d\n" % p + ",\n".join(polys) + "\n")
        try:
            r = subprocess.run(
                ["msolve", "-t", "2", "-f", ms, "-o", mo],
                capture_output=True, text=True, timeout=timeout)
            ok = r.returncode == 0 and os.path.getsize(mo) > 0
        except subprocess.TimeoutExpired:
            ok = False
            open(mo, "w").write("TIMEOUT\n")
        if not ok:
            n_fail += 1
            results.append({"sidx": sidx, "status": "fail"})
            continue
        s = open(mo).read()
        # GB mode check for small nvars: also try -g 2 when nvars <= 4
        origin_only = False
        if nvars <= 5:
            mo_gb = mo + ".gb"
            try:
                subprocess.run(
                    ["msolve", "-t", "2", "-g", "2", "-f", ms, "-o", mo_gb],
                    capture_output=True, text=True, timeout=timeout)
                body = "".join(l for l in open(mo_gb) if not l.startswith("#"))
                gens = sorted(set(map(int, re.findall(r"1\*a(\d+)\^1", body))))
                origin_only = gens == list(range(nvars))
            except Exception:
                origin_only = False
        if not origin_only:
            # solve-mode heuristic: all coord blocks zero
            n_zero = s.count("[-1,\n[0]]")
            origin_only = n_zero >= nvars - 1 and "[1," not in s and "[2," not in s
        if origin_only:
            n_origin_only += 1
            results.append({"sidx": sidx, "status": "origin_only"})
        else:
            n_nontriv += 1
            # try to extract a nonzero solution by brute force on F_p^{nvars}
            # for nvars=3,p=331 too big; use random probe
            hit = None
            for _ in range(500):
                a = rng.integers(0, p, size=nvars, dtype=np.int64)
                if not a.any():
                    continue
                c = (a @ B) % p
                # check F(T_c)=0 at 20 points
                chk = rng.integers(0, p, size=(20, 5), dtype=np.int64)
                Mc = L.eval_cell_at_points(fr, cell, chk)
                good = True
                for q in range(20):
                    if L.klein_F((Mc[q] @ c) % p, p) != 0:
                        good = False
                        break
                if not good:
                    continue
                # nondeg: T not zero on minus line
                Wm = fr["Wminus"]
                lpts = (rng.integers(0, p, size=(10, 2)) @ Wm) % p
                Ml = L.eval_cell_at_points(fr, cell, lpts)
                if np.any((Ml @ c) % p):
                    hit = {"c": list(map(int, c)), "a": list(map(int, a)),
                           "nondeg": True}
                    n_nondeg_wit += 1
                    witnesses.append(hit)
                else:
                    hit = {"c": list(map(int, c)), "nondeg": False}
                break
            results.append({"sidx": sidx, "status": "nontriv",
                            "hit": hit is not None})
        # cleanup heavy temps
        for f in (ms, mo, mo + ".gb"):
            if os.path.exists(f) and sidx > 2:
                try:
                    os.remove(f)
                except OSError:
                    pass
        if (sidx + 1) % 5 == 0:
            print("  sections d=%d done %d/%d origin_only=%d nontriv=%d fail=%d wit=%d" % (
                sec_dim, sidx + 1, n_sections, n_origin_only, n_nontriv, n_fail,
                n_nondeg_wit), flush=True)

    return {
        "sec_dim": sec_dim,
        "n_sections": n_sections,
        "n_origin_only": n_origin_only,
        "n_nontriv": n_nontriv,
        "n_fail": n_fail,
        "n_nondeg_witnesses": n_nondeg_wit,
        "witnesses": witnesses[:3],
        "detail_head": results[:10],
    }


def m2_dim_attempt(p, indep_rows, max_eqs=80, timeout=300):
    """M2 dim of ideal generated by a random subset of independent cubics."""
    K = 37
    mons = list(itertools.combinations_with_replacement(range(K), 3))
    rows = indep_rows
    if rows.shape[0] > max_eqs:
        rng = np.random.default_rng(0)
        idx = rng.choice(rows.shape[0], size=max_eqs, replace=False)
        rows = rows[idx]
    m2 = os.path.join(RES, "land_subset_p%d.m2" % p)
    out = os.path.join(RES, "land_subset_p%d_m2.out" % p)
    lines = ["kk = ZZ/%d;" % p, "R = kk[c_0..c_%d, MonomialOrder=>GRevLex];" % (K - 1)]
    eqs = []
    for row in rows:
        terms = []
        for coef, (u, v, w) in zip(row, mons):
            coef = int(coef) % p
            if coef:
                terms.append("%d*c_%d*c_%d*c_%d" % (coef, u, v, w))
        if terms:
            eqs.append("(" + "+".join(terms) + ")")
    lines.append("I = ideal(%s);" % ",".join(eqs))
    lines.append('<< "n_gens " << #I_* << endl;')
    lines.append('<< "dim_I " << dim I << endl;')
    lines.append('<< "deg_I " << degree I << endl;')
    lines.append('<< "DONE" << endl;')
    open(m2, "w").write("\n".join(lines) + "\n")
    t0 = time.time()
    try:
        r = subprocess.run(["M2", "--script", m2], capture_output=True,
                           text=True, timeout=timeout)
        text = (r.stdout or "") + (r.stderr or "")
        open(out, "w").write(text)
        dim = deg = None
        for line in text.splitlines():
            if line.strip().startswith("dim_I"):
                try:
                    dim = int(line.split()[-1])
                except Exception:
                    dim = line.split()[-1]
            if line.strip().startswith("deg_I"):
                try:
                    deg = int(line.split()[-1])
                except Exception:
                    deg = line.split()[-1]
        return {"ok": "DONE" in text, "dim_I": dim, "deg_I": deg,
                "n_eqs": len(eqs), "seconds": time.time() - t0,
                "tail": text[-1500:]}
    except subprocess.TimeoutExpired:
        open(out, "w").write("TIMEOUT\n")
        return {"ok": False, "dim_I": None, "deg_I": None, "n_eqs": len(eqs),
                "seconds": timeout, "tail": "TIMEOUT"}


def msolve_full_gb_small(p, indep_rows, n_eqs=40, timeout=180):
    """msolve -g 2 on a small subset; rarely decisive but cheap."""
    K = 37
    mons = list(itertools.combinations_with_replacement(range(K), 3))
    rows = indep_rows[:n_eqs]
    ms = os.path.join(RES, "land_small_p%d.ms" % p)
    mo = os.path.join(RES, "land_small_p%d_gb.out" % p)
    L.write_msolve_system(ms, p, rows, mons)
    t0 = time.time()
    try:
        subprocess.run(["msolve", "-t", "4", "-g", "2", "-f", ms, "-o", mo],
                       capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return {"ok": False, "seconds": timeout, "is_irrelevant": False,
                "status": "timeout"}
    if not os.path.exists(mo) or os.path.getsize(mo) == 0:
        return {"ok": False, "seconds": time.time() - t0, "is_irrelevant": False,
                "status": "empty_out"}
    body = "".join(l for l in open(mo) if not l.startswith("#"))
    gens = sorted(set(map(int, re.findall(r"1\*c(\d+)\^1", body))))
    return {
        "ok": True,
        "seconds": time.time() - t0,
        "is_irrelevant": gens == list(range(K)),
        "n_linear_gens": len(gens),
        "linear_gens_head": gens[:10],
        "body_len": len(body),
        "status": "parsed",
    }


def character_block(p, cell, fr):
    char = L.cell_character(fr, cell, seed=1)
    iso = L.isotypic_multiplicities(char, p)
    return {"character": char, "isotypic": iso}


def degeneracy(p, cell, fr):
    M = L.minus_line_vanishing_matrix(fr, cell, n_dirs=16, seed=3)
    rk = rref_rank(M, p)
    return {
        "minus_line_rank": int(rk),
        "minus_line_kernel_dim": int(37 - rk),
    }


def process(p):
    print("=" * 60, "\nPRIME", p, flush=True)
    t0 = time.time()
    plat, indep, cell, fr = saturate_plateau(p)
    print("[character]", flush=True)
    ch = character_block(p, cell, fr)
    print("  residual:", ch["isotypic"]["residual_action"],
          ch["isotypic"]["multiplicities"], flush=True)
    print("[degeneracy]", flush=True)
    deg = degeneracy(p, cell, fr)
    print(" ", deg, flush=True)

    print("[sections P2]", flush=True)
    sec2 = section_msolve(p, fr, cell, sec_dim=2, n_sections=30, seed=11 + p,
                          timeout=45)
    print("  P2 origin_only=%d nontriv=%d fail=%d wit=%d" % (
        sec2["n_origin_only"], sec2["n_nontriv"], sec2["n_fail"],
        sec2["n_nondeg_witnesses"]), flush=True)

    print("[sections P3]", flush=True)
    sec3 = section_msolve(p, fr, cell, sec_dim=3, n_sections=20, seed=22 + p,
                          timeout=90)
    print("  P3 origin_only=%d nontriv=%d fail=%d wit=%d" % (
        sec3["n_origin_only"], sec3["n_nontriv"], sec3["n_fail"],
        sec3["n_nondeg_witnesses"]), flush=True)

    print("[M2 subset dim]", flush=True)
    m2 = m2_dim_attempt(p, indep, max_eqs=60, timeout=400)
    print("  M2 dim=%s deg=%s ok=%s sec=%.1f" % (
        m2.get("dim_I"), m2.get("deg_I"), m2.get("ok"), m2["seconds"]),
          flush=True)

    print("[msolve small GB]", flush=True)
    gb = msolve_full_gb_small(p, indep, n_eqs=30, timeout=120)
    print("  GB", gb.get("status"), "irr?", gb.get("is_irrelevant"), flush=True)

    # verdict
    if (sec2["n_nondeg_witnesses"] > 0 or sec3["n_nondeg_witnesses"] > 0):
        label = "O3_CANDIDATE_WITNESS"
        reason = "non-degenerate section witness"
    elif (gb.get("is_irrelevant") or
          (m2.get("dim_I") in (-1, 0) and m2.get("deg_I") == 1 and
           sec2["n_origin_only"] == sec2["n_sections"] - sec2["n_fail"] and
           sec2["n_fail"] == 0)):
        label = "O1_EMPTY_CANDIDATE"
        reason = "irrelevant ideal or all sections origin-only + dim0 deg1"
    elif (sec2["n_origin_only"] > 0 and sec2["n_nontriv"] == 0 and
          sec3["n_nontriv"] == 0 and sec2["n_fail"] < sec2["n_sections"] // 2):
        # strong section evidence but not full GB
        label = "O4_INCONCLUSIVE"
        reason = "all successful low-dim sections origin-only; full GB wall"
        stuck = ["full_37var_msolve_resource_wall",
                 "plateau_rank=%d" % plat["plateau_rank"],
                 "P2_origin_only=%d/%d" % (sec2["n_origin_only"], sec2["n_sections"]),
                 "P3_origin_only=%d/%d" % (sec3["n_origin_only"], sec3["n_sections"]),
                 "m2_dim=%s" % m2.get("dim_I")]
    else:
        label = "O4_INCONCLUSIVE"
        reason = "mixed or incomplete"
        stuck = ["see section counts"]

    verdict = {
        "label": label,
        "reason": reason,
        "stuck_at": stuck if label.startswith("O4") else [],
    }
    # refine stuck if O1-like sections
    if label.startswith("O4") and sec2["n_nontriv"] == 0 and sec3["n_nontriv"] == 0:
        verdict["section_evidence"] = "EMPTY-leaning: no nontrivial section hit"
        verdict["flag"] = (
            "NOT a window-closure claim; full Groebner certificate absent"
        )

    out = {
        "p": p,
        "plateau": plat,
        "character": ch,
        "degeneracy": deg,
        "sections_P2": sec2,
        "sections_P3": sec3,
        "m2_subset": m2,
        "msolve_small_gb": gb,
        "prime_verdict": verdict,
        "n_independent_cubics": int(indep.shape[0]),
        "seconds": time.time() - t0,
    }
    with open(os.path.join(RES, "landing_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=2, default=lambda o: int(o) if isinstance(o, np.integer) else str(o))
    print("PRIME VERDICT", label, "in %.1fs" % out["seconds"], flush=True)
    return out


def main():
    primes = [int(a) for a in sys.argv[1:]] or [331, 661]
    results = {}
    for p in primes:
        results[p] = process(p)
    if len(results) == 2:
        labs = {p: results[p]["prime_verdict"]["label"] for p in results}
        if all(l.startswith("O1") for l in labs.values()):
            overall = "O1_EMPTY"
        elif any(l.startswith("O3") for l in labs.values()):
            overall = "O3_CANDIDATE"
        elif all(l.startswith("O2") for l in labs.values()):
            overall = "O2_DEGENERATE_ONLY"
        else:
            overall = "O4_INCONCLUSIVE"
        summary = {
            "overall": overall,
            "per_prime": labs,
            "plateaus": {p: results[p]["plateau"]["plateau_rank"] for p in results},
            "isotypic": {p: results[p]["character"]["isotypic"]["multiplicities"]
                         for p in results},
        }
        with open(os.path.join(RES, "landing_summary.json"), "w") as f:
            json.dump(summary, f, indent=2)
        print("OVERALL", overall, flush=True)


if __name__ == "__main__":
    main()
