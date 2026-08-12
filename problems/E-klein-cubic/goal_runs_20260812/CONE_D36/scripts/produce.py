#!/usr/bin/env python3
"""Lane 2: d=36 landing cone. Build 62-cell, reproduce P3=1850, climb rungs.

Usage:
  python3 scripts/produce.py            # p=331 full pipeline
  python3 scripts/produce.py 331        # same
  python3 scripts/produce.py 661 anchors
  python3 scripts/produce.py 331 msolve 22,24,28
  python3 scripts/produce.py 331 free
"""
from __future__ import annotations

import os
import sys
import time

import numpy as np

import paths
import cone_lib as L
import slicelib as SL
import p2lib as P2
import d34lib as D34
import produce_dims34 as DIMS
import instruments as I
from c11_points import collect_c11_points

DEG = paths.DEG
RES = paths.RES
LOGS = paths.LOGS
T0 = time.time()


def log(msg):
    print("[%6.1fs] %s" % (time.time() - T0, msg), flush=True)


def build_frame(p):
    return D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=False)))


def build_cell(fr, p, rng):
    """Layer-0 63-cell then the 60 C11-point cut → 62-cell."""
    Pbig = DIMS.big_prime()
    dims, _ = DIMS.pathA_dimM(Pbig, dmax=42)
    dimM = int(dims[DEG])
    assert dimM == paths.DIM_M_36, dimM
    cell = I.build_layer0_cell(fr, DEG, dimM, p, rng, npair=100, npt=80)
    if "error" in cell:
        raise RuntimeError(cell["error"])
    A, C, NUL = cell["A"], cell["C"], cell["NUL"]
    cell_dim = int(cell["cell_dim"])
    log("layer0 cell_dim=%d (sealed 63) fired=%s" % (cell_dim, cell["rules_fired"]))
    if cell_dim != paths.SEALED_CELL_63:
        raise SystemExit("FATAL: sealed 63-cell failed p=%d got %d" % (p, cell_dim))

    pts, census = collect_c11_points(fr, p)
    pb = D34.point_block(fr, A, C, DEG, pts, p)
    S = (NUL @ pb) % p                         # (63, 300)
    rank = int(P2.rref_rank_fast(S, p))
    S2 = np.concatenate([S, S], axis=1) % p
    sat_rank = int(P2.rref_rank_fast(S2, p))
    # {x : x @ S = 0} = right kernel of S.T
    Kloc = SL.nullspace(S.T % p, p) % p        # (62, 63)
    new_dim = int(Kloc.shape[0])
    if new_dim != cell_dim - rank:
        raise SystemExit("null dim %d != 63-rank %d" % (new_dim, cell_dim - rank))
    B62 = (Kloc @ NUL) % p                     # (62, ns)
    log("C11 cut rank=%d sat=%d new_dim=%d (fatal 62)" % (rank, sat_rank, new_dim))
    if new_dim != paths.SEALED_CUT_62:
        raise SystemExit("FATAL: post-cut dim p=%d got %d want 62" % (p, new_dim))
    rec = {
        "d": DEG, "p": int(p), "dim_M": dimM,
        "cell_dim": cell_dim, "sealed_cell": 63, "sealed_ok": True,
        "cut_rank": rank, "sat_rank": sat_rank, "sat_ok": sat_rank == rank,
        "new_dim": new_dim, "sealed_cut": 62, "cut_ok": new_dim == 62,
        "rules_fired": cell["rules_fired"],
        "census_n_points": census["n_points"],
        "census_n_frames": census["n_frames"],
        "census_all_on_X": census["all_on_X"],
        "seconds": time.time() - T0,
    }
    L.dump(os.path.join(RES, "cell_d36_p%d.json" % p), rec)
    np.save(os.path.join(RES, "A_d36_p%d.npy" % p), A)
    np.save(os.path.join(RES, "C_d36_p%d.npy" % p), C)
    np.save(os.path.join(RES, "NUL63_d36_p%d.npy" % p), NUL)
    np.save(os.path.join(RES, "B62_d36_p%d.npy" % p), B62)
    return rec, A, C, NUL, B62, census


def load_or_build_cell(fr, p, force=False):
    ap = os.path.join(RES, "A_d36_p%d.npy" % p)
    bp = os.path.join(RES, "B62_d36_p%d.npy" % p)
    np63 = os.path.join(RES, "NUL63_d36_p%d.npy" % p)
    jp = os.path.join(RES, "cell_d36_p%d.json" % p)
    if (not force) and all(os.path.exists(x) for x in (ap, bp, np63, jp)):
        import json
        rec = json.load(open(jp))
        A = np.load(ap)
        C = np.load(os.path.join(RES, "C_d36_p%d.npy" % p))
        NUL = np.load(np63)
        B62 = np.load(bp)
        log("loaded cell p=%d dim63=%d dim62=%d" % (p, NUL.shape[0], B62.shape[0]))
        return rec, A, C, NUL, B62, None
    rng = np.random.default_rng(20260812 + DEG)
    rec, A, C, NUL, B62, census = build_cell(fr, p, rng)
    return rec, A, C, NUL, B62, census


def measure_p3(fr, A, C, Bcell, p, tag):
    rec = L.inv_side_p3(
        fr, A, C, Bcell, DEG, p, I.eval_cell_at_points,
        n_func=3500, max_c=8000, stable_window=400,
        extra_batches=2, extra_size=500, Iceil=paths.I_108,
    )
    rec["tag"] = tag
    rec["anchor_P3_1850"] = (tag == "K63" and rec["P3"] == paths.SEALED_P3
                             and rec.get("saturated"))
    L.dump(os.path.join(RES, "p3_%s_p%d.json" % (tag, p)), rec)
    log("P3 %s p=%d K=%d P3=%s sat=%s (sealed 1850 on K63)"
        % (tag, p, rec["K"], rec["P3"], rec["saturated"]))
    if tag == "K63" and rec["P3"] != paths.SEALED_P3:
        raise SystemExit("FATAL: P3(36) on 63-cell p=%d got %s want 1850"
                         % (p, rec["P3"]))
    return rec


def sample_seed_values(fr, A, C, npts, p, seed):
    rng = np.random.default_rng(seed)
    W = rng.integers(1, p, size=(npts, 5)) % p
    log("jet_rows npts=%d deg=%d ns=%d ..." % (npts, DEG, A.shape[0]))
    t1 = time.time()
    V = SL.jet_rows(fr, A, C, W, np.zeros_like(W), 1, deg=DEG)[:, :, :, 0] % p
    log("jet_rows done in %.1fs shape=%s" % (time.time() - t1, V.shape))
    return V


def free_rungs(fr, A, C, Bcell, p, P3_cell, ms=None):
    """Restriction ranks. Full Sym^3 => V∩L={0} => dim V <= N-m."""
    N = int(Bcell.shape[0])
    if ms is None:
        ms = (16, 18, 19, 20, 21, 22)
    # enough points for the largest free candidate (m=21: 1771) at 1.4x
    nmon_need = max(L.nmon3(m) for m in ms)
    npts = int(max(nmon_need, P3_cell) * 1.45) + 80
    V = sample_seed_values(fr, A, C, npts, p, seed=20260812 + 100 * p)
    rng = np.random.default_rng(20260812 + 7 * p)
    rows_out = []
    best_free = None
    for m in ms:
        nmon = L.nmon3(m)
        S = rng.integers(0, p, size=(m, N)) % p
        if int(P2.rref_rank_fast(S, p)) < m:
            S = (S + np.eye(m, N, dtype=np.int64)) % p
        basis = (S @ Bcell) % p
        M, mons = L.cubic_rows(V, basis, p)
        rnk = int(P2.rref_rank_fast(M % p, p))
        full = rnk == nmon
        bound = (N - m) if full else None
        rec = {
            "m": m, "N": N, "dim_sym3": nmon, "rank": rnk,
            "HF_L3": nmon - rnk, "npts": npts,
            "full_sym3": full, "P3_cell": P3_cell,
            "generic_cap": min(P3_cell, nmon),
            "free": full,
            "dim_V_le": bound,
        }
        log("  free m=%d Sym3=%d rank=%d full=%s bound=%s"
            % (m, nmon, rnk, full, bound))
        rows_out.append(rec)
        if full:
            best_free = rec
        # persist section basis + independent cubics for the first non-free
        # msolve candidate (and for the last free as a control)
        if full or m == min(x for x in ms if x > (best_free["m"] if best_free else 0)
                            or [m]):
            pass
    out = {
        "p": int(p), "N": N, "P3_cell": P3_cell, "npts": npts,
        "sections": rows_out,
        "best_free_m": None if best_free is None else best_free["m"],
        "best_free_bound": None if best_free is None else best_free["dim_V_le"],
    }
    L.dump(os.path.join(RES, "free_rungs_p%d.json" % p), out)
    return out, V


def emit_and_run_msolve(fr, A, C, Bcell, V, p, m, P3_cell, timeout=900):
    """FULL restricted span as generators (counterintuitive rule)."""
    N = int(Bcell.shape[0])
    nmon = L.nmon3(m)
    expect_span = min(P3_cell, nmon)
    npts_have = V.shape[1]
    need = int(expect_span * 1.45) + 40
    if npts_have < need:
        extra = sample_seed_values(fr, A, C, need - npts_have, p,
                                   seed=20260812 + 333 * m + p)
        V = np.concatenate([V, extra], axis=1)
    rng = np.random.default_rng(777 + m + 17 * p)
    S = rng.integers(0, p, size=(m, N)) % p
    if int(P2.rref_rank_fast(S, p)) < m:
        S = (S + np.eye(m, N, dtype=np.int64)) % p
    basis = (S @ Bcell) % p
    M, mons = L.cubic_rows(V, basis, p)
    indep, kept = L.independent_rows(M, p)
    log("  m=%d sampled=%d indep=%d (cap %d) gens will be FULL span"
        % (m, M.shape[0], indep.shape[0], expect_span))
    ms = os.path.join(RES, "cone_m%d_p%d.ms" % (m, p))
    ngen = L.write_msolve(ms, indep, mons, m, p)
    meta = {
        "m": m, "p": int(p), "N": N, "dim_sym3": nmon,
        "n_sampled": int(M.shape[0]), "n_indep": int(indep.shape[0]),
        "n_gens_written": ngen, "ms_path": ms,
        "full_span_rule": True,
        "rss_before_kb": L.rss_kb(),
        "director_rss_kb": L.director_msolve_rss_kb(),
    }
    dir_rss = meta["director_rss_kb"]
    log("  wrote %s (%d gens); self_rss=%d kB director_msolve=%d kB"
        % (os.path.basename(ms), ngen, meta["rss_before_kb"], dir_rss))
    # Our cap is ~15 GB RSS for this rung. Director's 16-thread job is
    # separate; skip only if this process is already oversized.
    if meta["rss_before_kb"] > 12_000_000:
        log("  SKIP msolve: our RSS already %d kB" % meta["rss_before_kb"])
        meta["verdict"] = "skipped_own_memory"
        L.dump(os.path.join(RES, "msolve_m%d_p%d.json" % (m, p)), meta)
        return meta, V

    outp = os.path.join(RES, "cone_m%d_p%d_lead.out" % (m, p))
    logp = os.path.join(LOGS, "cone_m%d_p%d.log" % (m, p))
    run = L.run_msolve_g1(ms, outp, logp, threads=4, timeout=timeout)
    meta["seconds"] = run["seconds"]
    meta["timeout"] = run["timeout"]
    meta["returncode"] = run["returncode"]
    meta["rss_after_kb"] = L.rss_kb()
    if run["timeout"]:
        meta["verdict"] = "timeout"
        log("  m=%d TIMEOUT (%.0fs) — no verdict" % (m, run["seconds"]))
    elif not run["ok"]:
        meta["verdict"] = "msolve_fail"
        meta["log_tail"] = run["log"][-2000:]
        log("  m=%d msolve fail rc=%s" % (m, run["returncode"]))
    else:
        parsed = L.parse_leading_pure_powers(run["lead"], m)
        meta["leading"] = parsed
        if parsed["zero_dimensional"]:
            meta["verdict"] = "cleared"
            meta["dim_V_le"] = N - m
            log("  m=%d CLEARED pure-powers=%s => dim V <= %d"
                % (m, parsed["exponents_sorted"], N - m))
        else:
            meta["verdict"] = "not_zero_dim"
            meta["dim_V_le"] = None
            log("  m=%d leading ideal missing pure powers %s — no bound"
                % (m, parsed["missing"]))
    L.dump(os.path.join(RES, "msolve_m%d_p%d.json" % (m, p)), meta)
    return meta, V


def compile_summary(p=331):
    import json
    def load(name):
        path = os.path.join(RES, name)
        return json.load(open(path)) if os.path.exists(path) else None

    cell = load("cell_d36_p%d.json" % p)
    p3_63 = load("p3_K63_p%d.json" % p)
    p3_62 = load("p3_K62_p%d.json" % p)
    free = load("free_rungs_p%d.json" % p)
    msolve_rows = []
    for fn in sorted(os.listdir(RES)):
        if fn.startswith("msolve_m") and fn.endswith("_p%d.json" % p):
            msolve_rows.append(load(fn))
    bounds = []
    if free and free.get("best_free_bound") is not None:
        bounds.append(("free_m%d" % free["best_free_m"], free["best_free_bound"]))
    for r in msolve_rows:
        if r and r.get("verdict") == "cleared":
            bounds.append(("msolve_m%d" % r["m"], r["dim_V_le"]))
    tightest = min((b for _, b in bounds), default=None)
    out = {
        "p": p, "d": 36,
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "anchor_cell62": None if not cell else {
            "cell_dim": cell["cell_dim"], "new_dim": cell["new_dim"],
            "cut_ok": cell["cut_ok"], "cut_rank": cell["cut_rank"],
        },
        "anchor_P3_1850": None if not p3_63 else {
            "K": p3_63["K"], "P3": p3_63["P3"], "saturated": p3_63["saturated"],
            "ok": p3_63["P3"] == 1850,
        },
        "P3_on_62cell": None if not p3_62 else {
            "K": p3_62["K"], "P3": p3_62["P3"], "saturated": p3_62["saturated"],
        },
        "free": free,
        "msolve": msolve_rows,
        "bounds": bounds,
        "tightest_dim_V_le": tightest,
        "flagged_exclusion": False,
    }
    L.dump(os.path.join(RES, "summary_p%d.json" % p), out)
    L.dump(os.path.join(RES, "summary.json"), out)
    return out


def main():
    args = sys.argv[1:]
    p = 331
    phases = ["cell", "p3", "free", "msolve"]
    msolve_ms = [22, 24, 28, 32]
    if args and args[0].isdigit():
        p = int(args[0])
        args = args[1:]
    if args:
        if args[0] == "anchors":
            phases = ["cell", "p3"]
        elif args[0] == "free":
            phases = ["cell", "free"]
        elif args[0] == "msolve":
            phases = ["cell", "msolve"]
            if len(args) > 1:
                msolve_ms = [int(x) for x in args[1].split(",")]
        elif args[0] == "cell":
            phases = ["cell"]
        elif args[0] == "summary":
            phases = ["summary"]
    log("CONE_D36 produce p=%d phases=%s" % (p, phases))
    fr = None
    rec = A = C = NUL = B62 = None
    V = None
    P3_62 = None

    if any(ph in phases for ph in ("cell", "p3", "free", "msolve")):
        fr = build_frame(p)
        rec, A, C, NUL, B62, _ = load_or_build_cell(fr, p)

    if "p3" in phases:
        p3_63 = measure_p3(fr, A, C, NUL, p, "K63")
        p3_62 = measure_p3(fr, A, C, B62, p, "K62")
        P3_62 = p3_62["P3"]

    if "free" in phases:
        if P3_62 is None:
            import json
            pj = os.path.join(RES, "p3_K62_p%d.json" % p)
            if os.path.exists(pj):
                P3_62 = json.load(open(pj))["P3"]
            else:
                # free rungs do not need global P3; use sealed 1850 as cap only
                P3_62 = paths.SEALED_P3
        free, V = free_rungs(fr, A, C, B62, p, P3_62)
        np.save(os.path.join(RES, "Vseed_p%d.npy" % p), V)

    if "msolve" in phases:
        import json
        if V is None:
            vp = os.path.join(RES, "Vseed_p%d.npy" % p)
            if os.path.exists(vp):
                V = np.load(vp)
                log("loaded Vseed shape=%s" % (V.shape,))
            else:
                V = sample_seed_values(fr, A, C, 2800, p, seed=20260812 + 100 * p)
        if P3_62 is None:
            pj = os.path.join(RES, "p3_K62_p%d.json" % p)
            P3_62 = json.load(open(pj))["P3"] if os.path.exists(pj) else paths.SEALED_P3
        # skip free m
        fj = os.path.join(RES, "free_rungs_p%d.json" % p)
        free_m = set()
        if os.path.exists(fj):
            frj = json.load(open(fj))
            free_m = {s["m"] for s in frj["sections"] if s.get("free")}
        for m in msolve_ms:
            if m in free_m:
                log("skip m=%d (already free)" % m)
                continue
            # time budget grows with m; report timeout honestly
            to = 600 if m <= 22 else (900 if m <= 24 else (2400 if m <= 32 else 3600))
            meta, V = emit_and_run_msolve(fr, A, C, B62, V, p, m, P3_62,
                                          timeout=to)
            if meta.get("verdict") == "timeout":
                log("stop climb: first timeout at m=%d" % m)
                break

    compile_summary(p)
    try:
        import compile_summary as CS
        CS.main()
    except Exception as e:
        log("merge-summary skip: %s" % e)
    log("DONE p=%d" % p)
    return 0


if __name__ == "__main__":
    sys.exit(main())
