#!/usr/bin/env python3
"""Degeneracy analysis for the landing ideal on the 37-cell.

When HF(3)>0 the cubic span does not fill Sym^3.  Decide whether surviving
components of V(I) lie only in degeneracy loci:

  (D1) T|_{L_σ} ≡ 0  (kills all 22 order-0 line-branch blueprints)
  (D2) (34,1)-datum ≡ 0  (same linear conditions for order-0 reading)

Method:
  1. Linear degeneracy kernel K_deg ⊂ F_p^{37} (minus-line vanishing).
  2. Random linear sections of the 37-cell of dim s∈{1,2,3}:
       - sample cubics restricted to the section
       - msolve GB for origin-only / nontrivial
       - classify hits as deg / nondeg
  3. On the degeneracy subspace itself: restrict I to K_deg and test whether
     the restricted ideal is the unit ideal in those coordinates (only 0, or not).

Never runs the 37-var monolith.
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
K = 37


def run_msolve(ms, mo, timeout=60, gb=False):
    cmd = ["msolve", "-t", "2", "-f", ms, "-o", mo]
    if gb:
        cmd = ["msolve", "-t", "2", "-g", "2", "-f", ms, "-o", mo]
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        ok = r.returncode == 0 and os.path.exists(mo) and os.path.getsize(mo) > 0
        return ok, (r.stderr or "")[-500:]
    except subprocess.TimeoutExpired:
        open(mo, "w").write("TIMEOUT\n")
        return False, "TIMEOUT"


def is_origin_only_gb(mo, nvars):
    if not os.path.exists(mo) or os.path.getsize(mo) == 0:
        return False
    body = "".join(l for l in open(mo) if not l.startswith("#"))
    gens = sorted(set(map(int, re.findall(r"1\*a(\d+)\^1", body))))
    return gens == list(range(nvars))


def section_campaign(p, fr, cell, sec_dim, n_sections, seed, timeout=45):
    rng = np.random.default_rng(seed)
    nvars = sec_dim + 1
    mons3 = list(itertools.combinations_with_replacement(range(nvars), 3))
    n_origin = 0
    n_nontriv = 0
    n_fail = 0
    n_nondeg = 0
    n_deg = 0
    witnesses = []
    details = []

    Mline = L.minus_line_vanishing_matrix(fr, cell, n_dirs=16, seed=3)
    # projector: c is nondeg if Mline @ c != 0

    for sidx in range(n_sections):
        B = rng.integers(0, p, size=(nvars, K), dtype=np.int64)
        if SL.rref_rank(B, p) < nvars:
            continue
        npts = max(50, 4 * nvars * nvars)
        pts = rng.integers(0, p, size=(npts, 5), dtype=np.int64)
        for i in range(npts):
            if not pts[i].any():
                pts[i, 0] = 1
        Mall = L.eval_cell_at_points(fr, cell, pts)
        polys = []
        for q in range(npts):
            Mr = (Mall[q] @ B.T) % p
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
        ms = os.path.join(RES, "_degsec_p%d_d%d_%d.ms" % (p, sec_dim, sidx))
        mo = os.path.join(RES, "_degsec_p%d_d%d_%d.out" % (p, sec_dim, sidx))
        header = ",".join("a%d" % i for i in range(nvars))
        # take at most 80 polys
        open(ms, "w").write(header + "\n%d\n" % p + ",\n".join(polys[:80]) + "\n")
        ok, _ = run_msolve(ms, mo, timeout=timeout, gb=True)
        if not ok:
            n_fail += 1
            details.append({"sidx": sidx, "status": "fail"})
            continue
        if is_origin_only_gb(mo, nvars):
            n_origin += 1
            details.append({"sidx": sidx, "status": "origin_only"})
        else:
            n_nontriv += 1
            # probe for a nonzero a on the section with F(T_c)~0
            hit = None
            for _ in range(400):
                a = rng.integers(0, p, size=nvars, dtype=np.int64)
                if not a.any():
                    continue
                c = (a @ B) % p
                chk = rng.integers(0, p, size=(25, 5), dtype=np.int64)
                Mc = L.eval_cell_at_points(fr, cell, chk)
                good = all(L.klein_F((Mc[q] @ c) % p, p) == 0 for q in range(25))
                if not good:
                    continue
                # nondeg?
                if np.any((Mline @ c) % p):
                    hit = {"c": list(map(int, c)), "nondeg": True}
                    n_nondeg += 1
                    witnesses.append(hit)
                else:
                    hit = {"c": list(map(int, c)), "nondeg": False}
                    n_deg += 1
                break
            details.append({"sidx": sidx, "status": "nontriv",
                            "hit": hit is not None,
                            "nondeg": hit["nondeg"] if hit else None})
        # cleanup
        for f in (ms, mo):
            try:
                if sidx > 3 and os.path.exists(f):
                    os.remove(f)
            except OSError:
                pass
        if (sidx + 1) % 5 == 0:
            print("  sec d=%d %d/%d origin=%d nontriv=%d fail=%d nondeg=%d deg=%d" % (
                sec_dim, sidx + 1, n_sections, n_origin, n_nontriv, n_fail,
                n_nondeg, n_deg), flush=True)

    return {
        "sec_dim": sec_dim, "n_sections": n_sections,
        "n_origin_only": n_origin, "n_nontriv": n_nontriv, "n_fail": n_fail,
        "n_nondeg_witnesses": n_nondeg, "n_deg_witnesses": n_deg,
        "witnesses": witnesses[:5], "details_head": details[:15],
    }


def degeneracy_kernel(fr, cell, p):
    M = L.minus_line_vanishing_matrix(fr, cell, n_dirs=20, seed=3)
    rk = SL.rref_rank(M, p)
    # nullspace
    null = SL.nullspace(M, p)
    return {
        "rank": int(rk),
        "kernel_dim": int(null.shape[0]),
        "null_basis_shape": list(null.shape),
        "null": null,
    }


def restricted_to_degeneracy(p, fr, cell, null, npts=200, seed=99):
    """Sample landing cubics restricted to the degeneracy kernel.

    c = a @ null, a in F^{kdim}.  Cubics in a.  Report rank of cubic span
    vs dim Sym^3(kdim), and try msolve on random low-dim sections of ker.
    """
    rng = np.random.default_rng(seed)
    kdim = null.shape[0]
    if kdim == 0:
        return {"kdim": 0, "note": "degeneracy kernel trivial"}
    N3 = kdim * (kdim + 1) * (kdim + 2) // 6
    # build cubic rows in a-coordinates
    pts = rng.integers(0, p, size=(npts, 5), dtype=np.int64)
    for i in range(npts):
        if not pts[i].any():
            pts[i, 0] = 1
    Mall = L.eval_cell_at_points(fr, cell, pts)  # (npts,5,37)
    # M_a = Mall @ null.T : (npts,5,kdim)
    rows = []
    mons = list(itertools.combinations_with_replacement(range(kdim), 3))
    for q in range(npts):
        Mr = (Mall[q] @ null.T) % p
        C3 = np.zeros((kdim,) * 3, dtype=np.int64)
        for i in range(5):
            a, b = Mr[i], Mr[(i + 1) % 5]
            C3 = (C3 + np.einsum("u,v,w->uvw", a, a, b)) % p
        row = []
        for (u, v, w) in mons:
            perms = set(itertools.permutations((u, v, w)))
            row.append(sum(int(C3[t]) for t in perms) % p)
        rows.append(row)
    R = np.array(rows, dtype=np.int64) % p
    rk = SL.rref_rank(R, p)
    out = {
        "kdim": kdim, "npts": npts, "N3": N3, "rank_I3_on_deg": int(rk),
        "HF3_on_deg": N3 - rk, "fills_sym3": rk == N3 and N3 > 0,
    }
    # msolve small: if kdim <= 6, try full; else random P2 in ker
    if kdim <= 4:
        # write system in a0..a_{kdim-1}
        indep = R[: min(rk, R.shape[0])]
        # get independent rows
        # use first min(80, npts) eqs
        ms = os.path.join(RES, "deg_restrict_p%d.ms" % p)
        polys = []
        for row in R[:80]:
            terms = []
            for coef, (u, v, w) in zip(row, mons):
                coef = int(coef) % p
                if coef:
                    terms.append("%d*a%d*a%d*a%d" % (coef, u, v, w))
            if terms:
                polys.append("+".join(terms))
        header = ",".join("a%d" % i for i in range(kdim))
        open(ms, "w").write(header + "\n%d\n" % p + ",\n".join(polys) + "\n")
        mo = os.path.join(RES, "deg_restrict_p%d_gb.out" % p)
        ok, err = run_msolve(ms, mo, timeout=120, gb=True)
        out["msolve_ok"] = ok
        out["origin_only"] = is_origin_only_gb(mo, kdim) if ok else None
    else:
        # random P2 sections inside degeneracy kernel
        n_oo = 0
        n_nt = 0
        n_f = 0
        for sidx in range(15):
            B = rng.integers(0, p, size=(3, kdim), dtype=np.int64)
            if SL.rref_rank(B, p) < 3:
                continue
            # compose null section: c = a @ B @ null = a @ (B@null)
            B37 = (B @ null) % p  # (3,37)
            pts2 = rng.integers(0, p, size=(40, 5), dtype=np.int64)
            for i in range(40):
                if not pts2[i].any():
                    pts2[i, 0] = 1
            Mall2 = L.eval_cell_at_points(fr, cell, pts2)
            polys = []
            mons3 = list(itertools.combinations_with_replacement(range(3), 3))
            for q in range(40):
                Mr = (Mall2[q] @ B37.T) % p
                C3 = np.zeros((3, 3, 3), dtype=np.int64)
                for i in range(5):
                    aa, bb = Mr[i], Mr[(i + 1) % 5]
                    C3 = (C3 + np.einsum("u,v,w->uvw", aa, aa, bb)) % p
                terms = []
                for (u, v, w) in mons3:
                    perms = set(itertools.permutations((u, v, w)))
                    coef = sum(int(C3[t]) for t in perms) % p
                    if coef:
                        terms.append("%d*a%d*a%d*a%d" % (coef, u, v, w))
                if terms:
                    polys.append("+".join(terms))
            ms = os.path.join(RES, "_degP2_p%d_%d.ms" % (p, sidx))
            mo = os.path.join(RES, "_degP2_p%d_%d.out" % (p, sidx))
            open(ms, "w").write("a0,a1,a2\n%d\n" % p + ",\n".join(polys) + "\n")
            ok, _ = run_msolve(ms, mo, timeout=40, gb=True)
            if not ok:
                n_f += 1
            elif is_origin_only_gb(mo, 3):
                n_oo += 1
            else:
                n_nt += 1
            for f in (ms, mo):
                try:
                    os.remove(f)
                except OSError:
                    pass
        out["deg_P2_sections"] = {
            "n_origin_only": n_oo, "n_nontriv": n_nt, "n_fail": n_f,
        }
        print("  deg-kernel P2: origin=%d nontriv=%d fail=%d" % (n_oo, n_nt, n_f),
              flush=True)
    return out


def process(p):
    print("=" * 60, "\nDEGENERACY p=%d" % p, flush=True)
    t0 = time.time()
    cell = L.load_cell(p)
    fr = SL.build_frame(p, verbose=True)

    print("[degeneracy kernel]", flush=True)
    deg = degeneracy_kernel(fr, cell, p)
    print("  rank=%d ker_dim=%d" % (deg["rank"], deg["kernel_dim"]), flush=True)

    print("[restrict I to degeneracy]", flush=True)
    rest = restricted_to_degeneracy(p, fr, cell, deg["null"], npts=250, seed=7 + p)
    print("  ", {k: rest[k] for k in rest if k != "null"}, flush=True)

    print("[sections P1]", flush=True)
    s1 = section_campaign(p, fr, cell, sec_dim=1, n_sections=40, seed=11 + p,
                          timeout=30)
    print("  P1 origin=%d nontriv=%d fail=%d nondeg=%d" % (
        s1["n_origin_only"], s1["n_nontriv"], s1["n_fail"],
        s1["n_nondeg_witnesses"]), flush=True)

    print("[sections P2]", flush=True)
    s2 = section_campaign(p, fr, cell, sec_dim=2, n_sections=25, seed=22 + p,
                          timeout=45)
    print("  P2 origin=%d nontriv=%d fail=%d nondeg=%d" % (
        s2["n_origin_only"], s2["n_nontriv"], s2["n_fail"],
        s2["n_nondeg_witnesses"]), flush=True)

    print("[sections P3]", flush=True)
    s3 = section_campaign(p, fr, cell, sec_dim=3, n_sections=12, seed=33 + p,
                          timeout=90)
    print("  P3 origin=%d nontriv=%d fail=%d nondeg=%d" % (
        s3["n_origin_only"], s3["n_nontriv"], s3["n_fail"],
        s3["n_nondeg_witnesses"]), flush=True)

    # verdict
    nondeg = (s1["n_nondeg_witnesses"] + s2["n_nondeg_witnesses"]
              + s3["n_nondeg_witnesses"])
    deg_w = s1["n_deg_witnesses"] + s2["n_deg_witnesses"] + s3["n_deg_witnesses"]
    all_origin = (
        s1["n_nontriv"] == 0 and s2["n_nontriv"] == 0 and s3["n_nontriv"] == 0
        and s1["n_origin_only"] + s2["n_origin_only"] + s3["n_origin_only"] > 0
    )
    if nondeg > 0:
        label = "O3_CANDIDATE_WITNESS"
        reason = "non-degenerate section witness for F(T_c)~0"
    elif all_origin and rest.get("fills_sym3"):
        label = "O1_EMPTY_SECTION_EVIDENCE"
        reason = "all low-dim sections origin-only; deg-locus also full cubics"
    elif all_origin:
        label = "O1_EMPTY_LEANING"
        reason = "all successful low-dim sections origin-only; no full GB"
    elif deg_w > 0 and nondeg == 0:
        label = "O2_DEGENERATE_ONLY_LEANING"
        reason = "section hits only on degeneracy locus"
    else:
        label = "O4_INCONCLUSIVE"
        reason = "mixed section behaviour"

    out = {
        "p": p,
        "degeneracy_kernel": {k: deg[k] for k in deg if k != "null"},
        "restricted_to_deg": {k: rest[k] for k in rest},
        "sections_P1": s1,
        "sections_P2": s2,
        "sections_P3": s3,
        "prime_verdict": {"label": label, "reason": reason,
                          "n_nondeg": nondeg, "n_deg": deg_w},
        "seconds": time.time() - t0,
    }
    # JSON-safe
    def conv(o):
        if isinstance(o, np.ndarray):
            return o.tolist()
        if isinstance(o, (np.integer,)):
            return int(o)
        return str(o)
    with open(os.path.join(RES, "degeneracy_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=2, default=conv)
    print("VERDICT", label, "in %.1fs" % out["seconds"], flush=True)
    return out


def main():
    primes = [int(a) for a in sys.argv[1:] if a.isdigit()] or [331, 661]
    results = {}
    for p in primes:
        results[p] = process(p)
    labs = {p: results[p]["prime_verdict"]["label"] for p in results}
    with open(os.path.join(RES, "degeneracy_summary.json"), "w") as f:
        json.dump({"per_prime": labs,
                   "detail": {p: results[p]["prime_verdict"] for p in results}},
                  f, indent=2)
    print("OVERALL labels", labs, flush=True)


if __name__ == "__main__":
    main()
