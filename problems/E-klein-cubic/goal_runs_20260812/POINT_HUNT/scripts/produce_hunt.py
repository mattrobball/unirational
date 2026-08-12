#!/usr/bin/env python3
"""Emit sections, extract V ∩ L points, test dominance.

Usage:
  python3 scripts/produce_hunt.py selftest
  python3 scripts/produce_hunt.py emit --p 331 --ms 19,20,29
  python3 scripts/produce_hunt.py jac-control --p 331
  python3 scripts/produce_hunt.py extract --p 331 --m 20
  python3 scripts/produce_hunt.py extract --p 331 --m 29
  python3 scripts/produce_hunt.py run --p 331
  python3 scripts/produce_hunt.py summary

Writes ONLY under this packet's results/.
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import time

import numpy as np

import paths
import slicelib as SL
import huntlib as H

RES = paths.RES
DIM37 = paths.DIM37
P3 = paths.P3_SEALED
THREADS = paths.THREADS


def dump(name, obj):
    path = os.path.join(RES, name)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        json.dump(obj, f, indent=1)
    return path


def section_seed(m):
    return 20260812 + 1000 + m


def point_seed(p):
    return 20260812 + p


def selftest():
    """Synthetic line: V = {t1=t2=0} in A^3. Chart t3=1 recovers (0,0,1)."""
    tmp = os.path.join(RES, "selftest")
    os.makedirs(tmp, exist_ok=True)
    p = 331
    ms = os.path.join(tmp, "line.ms")
    out = os.path.join(tmp, "line.out")
    log = os.path.join(tmp, "line.log")
    with open(ms, "w") as f:
        f.write("t1,t2,t3\n%d\nt1,\nt2,\nt3-1\n" % p)
    meta = H.run_msolve(ms, out, log, threads=1, timeout=30, mode="solve")
    pts = meta.get("points") or []
    ok = (meta.get("verdict") == "POINTS"
          and any(pt == [0, 0, 1] for pt in pts))
    # empty / positive-dim parsers
    empty_ms = os.path.join(tmp, "empty.ms")
    with open(empty_ms, "w") as f:
        f.write("t1\n%d\nt1-1,\nt1-2\n" % p)
    empty = H.run_msolve(empty_ms, os.path.join(tmp, "empty.out"),
                         os.path.join(tmp, "empty.log"),
                         threads=1, timeout=30, mode="solve")
    inf_ms = os.path.join(tmp, "inf.ms")
    with open(inf_ms, "w") as f:
        f.write("t1,t2\n%d\nt1\n" % p)
    inf = H.run_msolve(inf_ms, os.path.join(tmp, "inf.out"),
                       os.path.join(tmp, "inf.log"),
                       threads=1, timeout=30, mode="solve")
    rec = {
        "line_verdict": meta.get("verdict"),
        "line_points": pts,
        "line_ok": ok,
        "empty_verdict": empty.get("verdict"),
        "empty_ok": empty.get("verdict") == "EMPTY_CHART",
        "inf_verdict": inf.get("verdict"),
        "inf_ok": inf.get("verdict") == "POSITIVE_DIM",
        "seconds": {
            "line": meta.get("seconds"),
            "empty": empty.get("seconds"),
            "inf": inf.get("seconds"),
        },
    }
    rec["ok"] = bool(rec["line_ok"] and rec["empty_ok"] and rec["inf_ok"])
    dump("selftest.json", rec)
    print("selftest ok=%s line=%s empty=%s inf=%s"
          % (rec["ok"], rec["line_verdict"], rec["empty_verdict"],
             rec["inf_verdict"]), flush=True)
    if not rec["ok"]:
        raise SystemExit("selftest failed: %s" % rec)
    return rec


def emit_at_prime(p, ms, seed_pts=None):
    seed_pts = point_seed(p) if seed_pts is None else seed_pts
    print("== emit p=%d  ms=%s" % (p, ms), flush=True)
    t0 = time.time()
    cell = H.cell37(p)
    A, Cc = H.load_AC()
    print("   cell37 %s  rank_U=%d  (%.1fs)" % (
        cell["B37"].shape, cell["rank_U"], time.time() - t0), flush=True)
    fr = SL.build_frame(p, verbose=False)
    max_pts = max(H.npts_for(m) for m in tuple(ms) + (37,))
    rng = np.random.default_rng(seed_pts)
    W = rng.integers(1, p, size=(max_pts, 5)) % p
    print("   evaluating %d points on 637 seeds..." % max_pts, flush=True)
    t1 = time.time()
    V = H.seed_values(fr, A, Cc, W)
    print("   seed values %s in %.1fs" % (V.shape, time.time() - t1), flush=True)

    t2 = time.time()
    n_p3 = H.npts_for(37)
    rows37, mons37 = H.cubic_rows(V[:, :n_p3, :], cell["B37"], p)
    idx37 = H.row_basis_indices(rows37, p)
    p3 = len(idx37)
    p3_rec = {
        "p": p, "m": 37, "npts": n_p3, "dim_sym3": H.nmon3(37),
        "rank": p3, "P3_sealed": P3, "match_sealed": p3 == P3,
        "seconds": time.time() - t2,
        "point_seed": seed_pts,
    }
    dump("p3_p%d.json" % p, p3_rec)
    print("   P3=%d (sealed %d) in %.1fs" % (p3, P3, p3_rec["seconds"]), flush=True)

    recs = []
    for m in ms:
        t3 = time.time()
        nmon = H.nmon3(m)
        npts = H.npts_for(m)
        sec_rng = np.random.default_rng(section_seed(m))
        S = sec_rng.integers(0, p, size=(m, DIM37)) % p
        if m == 37:
            basis = cell["B37"]
            S = np.eye(DIM37, dtype=np.int64)
        else:
            basis = (S @ cell["B37"]) % p
        rows, mons = H.cubic_rows(V[:, :npts, :], basis, p)
        idx = H.row_basis_indices(rows, p)
        rank = len(idx)
        indep = rows[idx]
        free = rank == nmon
        rec = {
            "p": p,
            "m": m,
            "dim_sym3": nmon,
            "npts": npts,
            "rank": rank,
            "HF_L3": nmon - rank,
            "generic_rank": min(P3, nmon),
            "full_span_ngens": rank,
            "free_rung": free,
            "section_seed": section_seed(m),
            "point_seed": seed_pts,
            "seconds_emit": time.time() - t3,
        }
        np.save(os.path.join(RES, "section_S_m%d_p%d.npy" % (m, p)), S)
        if free:
            rec["verdict"] = "FREE"
            rec["V_cap_L"] = "{0}"
            print("   m=%d FREE  rank=%d/%d  (%.1fs)"
                  % (m, rank, nmon, rec["seconds_emit"]), flush=True)
        else:
            ms_path = os.path.join(RES, "cone_m%d_p%d.ms" % (m, p))
            ng = H.write_msolve(ms_path, indep, mons, m, p)
            rec["verdict"] = "EMITTED"
            rec["ms_path"] = ms_path
            rec["ms_bytes"] = os.path.getsize(ms_path)
            rec["ngens_written"] = ng
            # keep monomials + independent rows for residual checks (compact)
            np.save(os.path.join(RES, "cubics_m%d_p%d.npy" % (m, p)),
                    indep.astype(np.int32))
            with open(os.path.join(RES, "mons_m%d_p%d.json" % (m, p)), "w") as f:
                json.dump(mons, f)
            print("   m=%d EMIT  rank=%d/%d  gens=%d  %.1fMB  (%.1fs)"
                  % (m, rank, nmon, ng, rec["ms_bytes"] / 1e6,
                     rec["seconds_emit"]), flush=True)
        dump("emit_m%d_p%d.json" % (m, p), rec)
        recs.append(rec)

    dump("emit_p%d.json" % p, {
        "p": p, "cell_rank_U": cell["rank_U"],
        "cell_shape": list(cell["B37"].shape),
        "P3": p3_rec, "rungs": recs, "seconds": time.time() - t0,
        "note": "full restricted span; never a subset",
    })
    return recs


def jac_control(p=331, ntrials=3):
    """Director control: generic cell member has Jacobian rank 5, Euler exact."""
    print("== jacobian control p=%d" % p, flush=True)
    cell = H.cell37(p)
    A, C = H.load_AC()
    fr = SL.build_frame(p, verbose=False)
    rng = np.random.default_rng(20260812)
    recs = []
    for t in range(ntrials):
        c = rng.integers(1, p, size=37) % p
        vec = (c @ cell["B37"]) % p
        dom = H.dominance_test(fr, A, C, vec, p, ntrials=3, seed=20260812 + t)
        recs.append(dom)
        print("   trial %d max_rank=%d euler=%s verdict=%s"
              % (t, dom["max_rank"], all(dom["euler_ok"]), dom["verdict"]),
              flush=True)
    out = {
        "p": p,
        "ntrials": ntrials,
        "trials": recs,
        "max_ranks": [r["max_rank"] for r in recs],
        "euler_all_ok": all(all(r["euler_ok"]) for r in recs),
        "matches_director": all(r["max_rank"] == 5 for r in recs),
    }
    dump("jac_control_p%d.json" % p, out)
    if not out["euler_all_ok"]:
        raise SystemExit("Euler control failed")
    return out


def _load_emit(p, m):
    path = os.path.join(RES, "emit_m%d_p%d.json" % (m, p))
    if not os.path.isfile(path):
        return None
    return json.load(open(path))


def extract_points(p, m, threads=THREADS, timeout=1200, charts=3, extra_cuts=0):
    """Dehomogenize V ∩ L and solve. Full span only.

    extras: additional random affine hyperplanes (not through 0) when the
    chart is still positive-dimensional.
    """
    print("== extract p=%d m=%d charts=%d extra_cuts=%d timeout=%ds t=%d"
          % (p, m, charts, extra_cuts, timeout, threads), flush=True)
    live = H.msolve_running()
    print("   live msolve: %s" % (
        [{"pid": x["pid"], "rss_mb": x["rss_kb"] // 1024} for x in live],),
          flush=True)
    emit = _load_emit(p, m)
    if emit is None:
        rec = {"p": p, "m": m, "verdict": "NO_VERDICT_MISSING_EMIT"}
        dump("extract_m%d_p%d.json" % (m, p), rec)
        return rec
    if emit.get("free_rung"):
        rec = {
            "p": p, "m": m, "verdict": "FREE_EMPTY",
            "V_cap_L": "{0}", "points": [],
            "note": "restricted cubics fill Sym^3(L); only the origin",
        }
        dump("extract_m%d_p%d.json" % (m, p), rec)
        print("   FREE => no nonzero points", flush=True)
        return rec
    ms_hom = emit.get("ms_path") or os.path.join(RES, "cone_m%d_p%d.ms" % (m, p))
    cub_path = os.path.join(RES, "cubics_m%d_p%d.npy" % (m, p))
    mon_path = os.path.join(RES, "mons_m%d_p%d.json" % (m, p))
    if not os.path.isfile(ms_hom):
        rec = {"p": p, "m": m, "verdict": "NO_VERDICT_MISSING_MS"}
        dump("extract_m%d_p%d.json" % (m, p), rec)
        return rec
    rows = np.load(cub_path) if os.path.isfile(cub_path) else None
    mons = json.load(open(mon_path)) if os.path.isfile(mon_path) else None
    S = np.load(os.path.join(RES, "section_S_m%d_p%d.npy" % (m, p)))

    rec = {
        "p": p, "m": m, "threads": threads, "timeout": timeout,
        "full_span_ngens": emit.get("ngens_written") or emit.get("full_span_ngens"),
        "charts": [],
        "points": [],
    }
    rng = np.random.default_rng(section_seed(m) + 17)
    found = []
    last_posdim = False
    for ci in range(charts):
        extras = ["t%d-1" % (ci + 1)]
        for _ in range(extra_cuts):
            a = rng.integers(0, p, size=m)
            terms = "+".join("%d*t%d" % (int(a[i]) % p, i + 1)
                             for i in range(m) if int(a[i]) % p)
            extras.append("%s-1" % terms if terms else "t1-1")
        chart_ms = os.path.join(RES, "chart_m%d_p%d_c%d_k%d.ms" % (m, p, ci, extra_cuts))
        if rows is not None and mons is not None:
            H.write_msolve(chart_ms, rows, mons, m, p, extras=extras)
        else:
            # fall back: concatenate extras onto the homogeneous file
            txt = open(ms_hom).read().rstrip()
            if txt.endswith("\n"):
                txt = txt[:-1]
            with open(chart_ms, "w") as f:
                f.write(txt)
                for ex in extras:
                    f.write(",\n%s" % ex)
                f.write("\n")
        outp = os.path.join(RES, "chart_m%d_p%d_c%d_k%d.out" % (m, p, ci, extra_cuts))
        logp = os.path.join(RES, "chart_m%d_p%d_c%d_k%d.log" % (m, p, ci, extra_cuts))
        print("   chart t%d=1 + %d affine cuts  %s" % (ci + 1, extra_cuts, chart_ms),
              flush=True)
        meta = H.run_msolve(chart_ms, outp, logp, threads=threads,
                            timeout=timeout, mode="solve")
        crec = {
            "chart": ci + 1,
            "extra_cuts": extra_cuts,
            "verdict": meta.get("verdict"),
            "seconds": meta.get("seconds"),
            "max_rss_kb": meta.get("max_rss_kb"),
            "timed_out": meta.get("timed_out"),
            "killed_memory": meta.get("killed_memory"),
            "n_points": meta.get("n_points"),
            "cmd": meta.get("cmd"),
        }
        rec["charts"].append(crec)
        print("      %s  %.1fs  rss_mb=%.1f  n=%s"
              % (meta.get("verdict"), meta.get("seconds") or 0,
                 (meta.get("max_rss_kb") or 0) / 1024.0, meta.get("n_points")),
              flush=True)
        if meta.get("verdict") == "POINTS":
            for pt in meta.get("points") or []:
                if any(int(x) % p for x in pt):
                    found.append([int(x) % p for x in pt])
            if found:
                break
        if meta.get("verdict") == "POSITIVE_DIM":
            last_posdim = True
        if meta.get("verdict") in ("NO_VERDICT_TIMEOUT", "NO_VERDICT_MEMORY"):
            rec["verdict"] = meta.get("verdict")
            rec["infeasible_at_m"] = m
            rec["infeasible_reason"] = meta.get("verdict")
            dump("extract_m%d_p%d.json" % (m, p), rec)
            return rec
        if meta.get("verdict") == "POSITIVE_DIM":
            # one more affine cut on this same chart
            if extra_cuts < 4:
                return extract_points(p, m, threads=threads, timeout=timeout,
                                      charts=1, extra_cuts=extra_cuts + 1)

    # residual filter against the full span
    kept = []
    if rows is not None and mons is not None:
        for pt in found:
            res = H.eval_cubic_rows(rows, mons, pt, p)
            if int(np.count_nonzero(res)) == 0:
                kept.append(pt)
            else:
                print("   drop point residual nz=%d" % int(np.count_nonzero(res)),
                      flush=True)
    else:
        kept = found

    rec["points"] = kept
    rec["n_points"] = len(kept)
    if kept:
        rec["verdict"] = "POINTS"
    elif last_posdim:
        rec["verdict"] = "POSITIVE_DIM_NO_FP_POINT"
    elif rec["charts"] and all(c.get("verdict") == "EMPTY_CHART" for c in rec["charts"]):
        rec["verdict"] = "EMPTY_CHARTS"
    elif rec["charts"]:
        rec["verdict"] = rec["charts"][-1].get("verdict")
    else:
        rec["verdict"] = "NO_CHART"
    dump("extract_m%d_p%d.json" % (m, p), rec)
    print("   extract verdict %s  n=%d" % (rec["verdict"], len(kept)), flush=True)
    return rec


def diagnose_coord_zero(p, m, coord=0, threads=THREADS, timeout=1200):
    """Full-span system on the hyperplane t_{coord+1}=0 inside L (m-1 vars).

    Together with an empty chart t_{coord+1}=1 this proves V ∩ L = {0}.
    """
    print("== diagnose t%d=0 p=%d m=%d -> %d vars" % (coord + 1, p, m, m - 1),
          flush=True)
    cub_path = os.path.join(RES, "cubics_m%d_p%d.npy" % (m, p))
    mon_path = os.path.join(RES, "mons_m%d_p%d.json" % (m, p))
    if not (os.path.isfile(cub_path) and os.path.isfile(mon_path)):
        rec = {"p": p, "m": m, "coord": coord, "verdict": "NO_VERDICT_MISSING_CUBICS"}
        dump("slice_t%d_m%d_p%d.json" % (coord + 1, m, p), rec)
        return rec
    rows = np.load(cub_path)
    mons = json.load(open(mon_path))
    kept = []
    new_mons = []
    remap = {}
    for k, triple in enumerate(mons):
        if coord in triple:
            continue
        nt = tuple(i - 1 if i > coord else i for i in triple)
        remap.setdefault(nt, len(new_mons))
        if nt not in new_mons and remap[nt] == len(new_mons):
            new_mons.append(nt)
    # rebuild rows on surviving monomials
    col_old = [k for k, triple in enumerate(mons) if coord not in triple]
    col_new = [remap[tuple(i - 1 if i > coord else i for i in mons[k])]
               for k in col_old]
    m2 = m - 1
    nmon = H.nmon3(m2)
    # new_mons may not be a full list of combinations; write using those present
    sliced = np.zeros((rows.shape[0], len(new_mons)), dtype=np.int64)
    for old_k, new_k in zip(col_old, col_new):
        sliced[:, new_k] = rows[:, old_k]
    ms_path = os.path.join(RES, "slice_t%d_m%d_p%d.ms" % (coord + 1, m, p))
    ng = H.write_msolve(ms_path, sliced, new_mons, m2, p)
    outp = os.path.join(RES, "slice_t%d_m%d_p%d_lead.out" % (coord + 1, m, p))
    logp = os.path.join(RES, "slice_t%d_m%d_p%d_lead.log" % (coord + 1, m, p))
    print("   wrote %s gens=%d nmon_kept=%d" % (ms_path, ng, len(new_mons)),
          flush=True)
    meta = H.run_msolve(ms_path, outp, logp, threads=threads,
                        timeout=timeout, mode="lead")
    rec = {
        "p": p, "m": m, "coord": coord, "m_slice": m2,
        "ngens": ng, "nmon_kept": len(new_mons),
        "verdict": meta.get("verdict"),
        "seconds": meta.get("seconds"),
        "max_rss_kb": meta.get("max_rss_kb"),
        "timed_out": meta.get("timed_out"),
        "killed_memory": meta.get("killed_memory"),
        "lead": meta.get("lead"),
        "zero_dimensional": meta.get("verdict") == "ZERO_DIM",
        "cmd": meta.get("cmd"),
    }
    dump("slice_t%d_m%d_p%d.json" % (coord + 1, m, p), rec)
    print("   slice t%d=0 %s  %.1fs"
          % (coord + 1, rec["verdict"], rec.get("seconds") or 0), flush=True)
    return rec


def diagnose_lead(p, m, threads=THREADS, timeout=1200):
    """Homogeneous leading-ideal test on the full span (zero-dim ⇒ only origin)."""
    print("== diagnose -g 1 p=%d m=%d" % (p, m), flush=True)
    emit = _load_emit(p, m)
    if emit is None:
        return {"p": p, "m": m, "verdict": "NO_VERDICT_MISSING_EMIT"}
    if emit.get("free_rung"):
        rec = {"p": p, "m": m, "verdict": "FREE", "zero_dimensional": True}
        dump("lead_m%d_p%d.json" % (m, p), rec)
        return rec
    ms_path = emit.get("ms_path") or os.path.join(RES, "cone_m%d_p%d.ms" % (m, p))
    outp = os.path.join(RES, "lead_m%d_p%d.out" % (m, p))
    logp = os.path.join(RES, "lead_m%d_p%d.log" % (m, p))
    meta = H.run_msolve(ms_path, outp, logp, threads=threads,
                        timeout=timeout, mode="lead")
    rec = {
        "p": p, "m": m,
        "verdict": meta.get("verdict"),
        "seconds": meta.get("seconds"),
        "max_rss_kb": meta.get("max_rss_kb"),
        "timed_out": meta.get("timed_out"),
        "killed_memory": meta.get("killed_memory"),
        "lead": meta.get("lead"),
        "zero_dimensional": meta.get("verdict") == "ZERO_DIM",
        "cmd": meta.get("cmd"),
    }
    dump("lead_m%d_p%d.json" % (m, p), rec)
    print("   lead %s  %.1fs" % (rec["verdict"], rec.get("seconds") or 0), flush=True)
    return rec


def score_points(p, m):
    """Lift extracted points, check landing, run Jacobian/Euler."""
    ext = json.load(open(os.path.join(RES, "extract_m%d_p%d.json" % (m, p))))
    pts = ext.get("points") or []
    out = {"p": p, "m": m, "n": len(pts), "scored": []}
    if not pts:
        dump("score_m%d_p%d.json" % (m, p), out)
        return out
    cell = H.cell37(p)
    A, C = H.load_AC()
    fr = SL.build_frame(p, verbose=False)
    S = np.load(os.path.join(RES, "section_S_m%d_p%d.npy" % (m, p)))
    for i, pt in enumerate(pts):
        lift = H.lift_section_point(pt, S, cell["B37"], p)
        vec = np.array(lift["vec637"], dtype=np.int64)
        land = H.landing_check(fr, A, C, vec, p, npts=40, seed=20260812 + i)
        if not land["lands"]:
            print("   point %d FAILED landing check nz=%d" % (i, land["n_nonzero"]),
                  flush=True)
            scored = {"i": i, "lift": lift, "landing": land, "verdict": "NOT_ON_V"}
        else:
            dom = H.dominance_test(fr, A, C, vec, p, ntrials=8,
                                   seed=20260812 + 100 + i)
            scored = {
                "i": i,
                "t": lift["t"],
                "c37": lift["c37"],
                "c_nonzero": lift["c_nonzero"],
                "vec_nonzero": lift["vec_nonzero"],
                "landing": land,
                "dominance": {
                    "max_rank": dom["max_rank"],
                    "ranks": dom["ranks"],
                    "euler_ok": all(dom["euler_ok"]),
                    "verdict": dom["verdict"],
                },
                "verdict": dom["verdict"],
            }
            print("   point %d lands=%s jac=%d %s"
                  % (i, land["lands"], dom["max_rank"], dom["verdict"]),
                  flush=True)
        out["scored"].append(scored)
    dump("score_m%d_p%d.json" % (m, p), out)
    return out


def compile_summary():
    files = sorted(fn for fn in os.listdir(RES) if fn.endswith(".json"))
    extracts = []
    scores = []
    leads = []
    infeasible = None
    largest_attempted = None
    any_points = []
    for p in paths.PRIMES:
        for m in range(1, 38):
            ep = os.path.join(RES, "extract_m%d_p%d.json" % (m, p))
            if os.path.isfile(ep):
                rec = json.load(open(ep))
                extracts.append({
                    "p": p, "m": m, "verdict": rec.get("verdict"),
                    "n_points": rec.get("n_points") or len(rec.get("points") or []),
                    "infeasible_at_m": rec.get("infeasible_at_m"),
                    "charts": [{
                        "verdict": c.get("verdict"),
                        "seconds": c.get("seconds"),
                        "max_rss_kb": c.get("max_rss_kb"),
                    } for c in rec.get("charts") or []],
                })
                if rec.get("infeasible_at_m") is not None:
                    if infeasible is None or rec["infeasible_at_m"] < infeasible:
                        infeasible = rec["infeasible_at_m"]
                if largest_attempted is None or m > largest_attempted:
                    largest_attempted = m
            lp = os.path.join(RES, "lead_m%d_p%d.json" % (m, p))
            if os.path.isfile(lp):
                rec = json.load(open(lp))
                leads.append({"p": p, "m": m, "verdict": rec.get("verdict"),
                              "seconds": rec.get("seconds"),
                              "killed_memory": rec.get("killed_memory")})
            sl = os.path.join(RES, "slice_t1_m%d_p%d.json" % (m, p))
            if os.path.isfile(sl):
                rec = json.load(open(sl))
                leads.append({
                    "p": p, "m": m, "kind": "slice_t1=0",
                    "verdict": rec.get("verdict"),
                    "seconds": rec.get("seconds"),
                    "zero_dimensional": rec.get("zero_dimensional"),
                })
            sp = os.path.join(RES, "score_m%d_p%d.json" % (m, p))
            if os.path.isfile(sp):
                rec = json.load(open(sp))
                scores.append(rec)
                for s in rec.get("scored") or []:
                    any_points.append({
                        "p": p, "m": m, "verdict": s.get("verdict"),
                        "jac": (s.get("dominance") or {}).get("max_rank"),
                        "lands": (s.get("landing") or {}).get("lands"),
                    })
    p3s = {}
    for p in paths.PRIMES:
        path = os.path.join(RES, "p3_p%d.json" % p)
        if os.path.isfile(path):
            p3s[str(p)] = json.load(open(path))
    selft = None
    sp = os.path.join(RES, "selftest.json")
    if os.path.isfile(sp):
        selft = json.load(open(sp))
    jac = {}
    for p in paths.PRIMES:
        path = os.path.join(RES, "jac_control_p%d.json" % p)
        if os.path.isfile(path):
            jac[str(p)] = json.load(open(path))
    summary = {
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "selftest": None if selft is None else {"ok": selft.get("ok")},
        "P3": p3s,
        "jac_control": {k: {
            "max_ranks": v.get("max_ranks"),
            "euler_all_ok": v.get("euler_all_ok"),
            "matches_director": v.get("matches_director"),
        } for k, v in jac.items()},
        "extracts": extracts,
        "leads": leads,
        "points": any_points,
        "largest_completed_m": 29 if any(
            os.path.isfile(os.path.join(RES, "hunt_m29_p%d.json" % p))
            for p in paths.PRIMES) else largest_attempted,
        "largest_attempted_m": largest_attempted,
        "infeasible_at_m": infeasible,
        "hunts": {
            k: json.load(open(os.path.join(RES, k)))
            for k in ("hunt_m29_p331.json", "hunt_m29_p661.json",
                      "hunt_m30_p331.json")
            if os.path.isfile(os.path.join(RES, k))
        },
        "json_files": files,
        "note": ("Points are F_p-points of V ∩ L on an affine chart. "
                 "A rank<=3 Jacobian is not dominant. No degree is excluded."),
    }
    dump("summary.json", summary)
    return summary


def run_campaign(p, ms, threads=THREADS, timeout_ctrl=180, timeout_hunt=1200):
    print("== POINT_HUNT run p=%d ms=%s t=%d" % (p, ms, threads), flush=True)
    print("   live msolve: %s" % (
        [{"pid": x["pid"], "rss_mb": x["rss_kb"] // 1024}
         for x in H.msolve_running()],), flush=True)
    selftest()
    emit_at_prime(p, ms)
    jac_control(p)
    for m in ms:
        if m <= 19:
            continue
        to = timeout_ctrl if m <= 20 else timeout_hunt
        ext = extract_points(p, m, threads=threads, timeout=to)
        if ext.get("verdict") == "POINTS":
            score_points(p, m)
        elif ext.get("verdict") == "EMPTY_CHARTS":
            diagnose_lead(p, m, threads=threads, timeout=to)
        elif ext.get("infeasible_at_m") is not None:
            print("   stop climb: infeasible at m=%d" % m, flush=True)
            break
    compile_summary()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", choices=[
        "selftest", "emit", "jac-control", "extract", "diagnose",
        "slice", "score", "run", "summary",
    ])
    ap.add_argument("--p", type=int, default=331)
    ap.add_argument("--ms", type=str, default="19,20,29")
    ap.add_argument("--m", type=int, default=29)
    ap.add_argument("--t", type=int, default=THREADS)
    ap.add_argument("--timeout", type=int, default=1200)
    ap.add_argument("--charts", type=int, default=3)
    args = ap.parse_args()
    if args.cmd == "selftest":
        selftest()
    elif args.cmd == "emit":
        ms = tuple(int(x) for x in args.ms.split(",") if x)
        emit_at_prime(args.p, ms)
        compile_summary()
    elif args.cmd == "jac-control":
        jac_control(args.p)
    elif args.cmd == "extract":
        extract_points(args.p, args.m, threads=args.t, timeout=args.timeout,
                       charts=args.charts)
        compile_summary()
    elif args.cmd == "diagnose":
        diagnose_lead(args.p, args.m, threads=args.t, timeout=args.timeout)
        compile_summary()
    elif args.cmd == "slice":
        diagnose_coord_zero(args.p, args.m, coord=0, threads=args.t,
                            timeout=args.timeout)
        compile_summary()
    elif args.cmd == "score":
        score_points(args.p, args.m)
        compile_summary()
    elif args.cmd == "run":
        ms = tuple(int(x) for x in args.ms.split(",") if x)
        run_campaign(args.p, ms, threads=args.t, timeout_hunt=args.timeout)
    elif args.cmd == "summary":
        print(json.dumps(compile_summary(), indent=2))


if __name__ == "__main__":
    main()
