#!/usr/bin/env python3
"""d=37 and d=38 landing-cone ladders.

Usage:
  python3 scripts/produce.py                  # p=331 both degrees, all phases
  python3 scripts/produce.py 331
  python3 scripts/produce.py 661 anchors
  python3 scripts/produce.py 331 37 free
  python3 scripts/produce.py 331 37 msolve 25,26,28
  python3 scripts/produce.py 331 summary
"""
from __future__ import annotations

import json
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

RES = paths.RES
LOGS = paths.LOGS
T0 = time.time()

FREE_MS = {
    37: (20, 22, 23, 24, 25, 26),
    38: (22, 24, 25, 26, 27, 28),
}
MSOLVE_MS = {
    37: (25, 26, 28, 30, 32),
    38: (27, 28, 30, 32),
}
N_FUNC = {37: 4500, 38: 5500}


def log(msg):
    print("[%6.1fs] %s" % (time.time() - T0, msg), flush=True)


def build_frame(p):
    return D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=False)))


def dimM_of(d):
    Pbig = DIMS.big_prime()
    dims, _ = DIMS.pathA_dimM(Pbig, dmax=42)
    return int(dims[d])


def build_cells(fr, d, p, rng):
    """Layer-0 cell, six-flip (odd d), C11-point cut."""
    dimM = dimM_of(d)
    cell = I.build_layer0_cell(fr, d, dimM, p, rng, npair=100, npt=80)
    if "error" in cell:
        raise RuntimeError(cell["error"])
    A, C, NUL = cell["A"], cell["C"], cell["NUL"]
    cell_dim = int(cell["cell_dim"])
    want_pre = paths.SEALED_PRECUT[d]
    log("d=%d layer0 cell_dim=%d (sealed %d) fired=%s"
        % (d, cell_dim, want_pre, cell["rules_fired"]))
    if cell_dim != want_pre:
        raise SystemExit("FATAL: pre-cut cell d=%d p=%d got %d want %d"
                         % (d, p, cell_dim, want_pre))

    flip = I.six_flip_rank(fr, A, C, NUL, d, p)
    Bflip = I.post_flip_null(NUL, flip, p)
    Kflip = int(Bflip.shape[0])
    want_p3k = paths.SEALED_P3_K[d]
    log("d=%d post-flip K=%d (sealed P3-cell %d) skipped=%s rank=%s"
        % (d, Kflip, want_p3k, flip.get("skipped"), flip.get("rank")))
    if Kflip != want_p3k:
        raise SystemExit("FATAL: post-flip K d=%d p=%d got %d want %d"
                         % (d, p, Kflip, want_p3k))

    pts, census = collect_c11_points(fr, p)
    pb = D34.point_block(fr, A, C, d, pts, p)
    S = (NUL @ pb) % p
    rank = int(P2.rref_rank_fast(S, p))
    S2 = np.concatenate([S, S], axis=1) % p
    sat_rank = int(P2.rref_rank_fast(S2, p))
    Kloc = SL.nullspace(S.T % p, p) % p
    new_dim = int(Kloc.shape[0])
    if new_dim != cell_dim - rank:
        raise SystemExit("null dim %d != %d-rank %d" % (new_dim, cell_dim, rank))
    Bcut = (Kloc @ NUL) % p
    want_cut = paths.SEALED_POSTCUT[d]
    log("d=%d C11 cut rank=%d sat=%d new_dim=%d (fatal %d)"
        % (d, rank, sat_rank, new_dim, want_cut))
    if new_dim != want_cut:
        raise SystemExit("FATAL: post-cut dim d=%d p=%d got %d want %d"
                         % (d, p, new_dim, want_cut))

    rec = {
        "d": d, "p": int(p), "dim_M": dimM,
        "cell_dim": cell_dim, "sealed_precut": want_pre,
        "precut_ok": cell_dim == want_pre,
        "flip_skipped": bool(flip.get("skipped")),
        "flip_rank": flip.get("rank"),
        "K_flip": Kflip, "sealed_P3_K": want_p3k,
        "flip_ok": Kflip == want_p3k,
        "cut_rank": rank, "sat_rank": sat_rank, "sat_ok": sat_rank == rank,
        "new_dim": new_dim, "sealed_postcut": want_cut,
        "cut_ok": new_dim == want_cut,
        "rules_fired": cell["rules_fired"],
        "census_n_points": census["n_points"],
        "census_n_frames": census["n_frames"],
        "census_all_on_X": census["all_on_X"],
        "seconds": time.time() - T0,
    }
    L.dump(os.path.join(RES, "cell_d%d_p%d.json" % (d, p)), rec)
    np.save(os.path.join(RES, "A_d%d_p%d.npy" % (d, p)), A)
    np.save(os.path.join(RES, "C_d%d_p%d.npy" % (d, p)), C)
    np.save(os.path.join(RES, "NUL_precut_d%d_p%d.npy" % (d, p)), NUL)
    np.save(os.path.join(RES, "Bflip_d%d_p%d.npy" % (d, p)), Bflip)
    np.save(os.path.join(RES, "Bcut_d%d_p%d.npy" % (d, p)), Bcut)
    return rec, A, C, NUL, Bflip, Bcut, census


def load_or_build_cells(fr, d, p, force=False):
    ap = os.path.join(RES, "A_d%d_p%d.npy" % (d, p))
    cp = os.path.join(RES, "C_d%d_p%d.npy" % (d, p))
    np_pre = os.path.join(RES, "NUL_precut_d%d_p%d.npy" % (d, p))
    bp_flip = os.path.join(RES, "Bflip_d%d_p%d.npy" % (d, p))
    bp_cut = os.path.join(RES, "Bcut_d%d_p%d.npy" % (d, p))
    jp = os.path.join(RES, "cell_d%d_p%d.json" % (d, p))
    if (not force) and all(os.path.exists(x) for x in
                           (ap, cp, np_pre, bp_flip, bp_cut, jp)):
        rec = json.load(open(jp))
        A = np.load(ap)
        C = np.load(cp)
        NUL = np.load(np_pre)
        Bflip = np.load(bp_flip)
        Bcut = np.load(bp_cut)
        log("loaded d=%d p=%d precut=%d flip=%d cut=%d"
            % (d, p, NUL.shape[0], Bflip.shape[0], Bcut.shape[0]))
        return rec, A, C, NUL, Bflip, Bcut, None
    rng = np.random.default_rng(20260812 + d)
    return build_cells(fr, d, p, rng)


def measure_p3_pair(fr, A, C, Bflip, Bcut, d, p):
    """One seed-jet at the functional points; saturate P3 on flip-cell and cut-cell."""
    n_func = N_FUNC[d]
    Iceil = paths.I_3D[d]
    rng = np.random.default_rng(20260812 + 17 * d + p)
    ys = rng.integers(0, p, size=(n_func, 5), dtype=np.int64)
    for i in range(n_func):
        if not ys[i].any():
            ys[i, 0] = 1
    log("d=%d p=%d jet_rows n_func=%d for P3 ..." % (d, p, n_func))
    t1 = time.time()
    V = SL.jet_rows(fr, A, C, ys, np.zeros_like(ys), 1, deg=d)[:, :, :, 0] % p
    log("d=%d P3 jet_rows done in %.1fs shape=%s" % (d, time.time() - t1, V.shape))

    out = {}
    for tag, B in (("Kflip", Bflip), ("Kcut", Bcut)):
        Mall = np.einsum("ks,sqc->qck", B % p, V) % p
        log("[inv-P3] d=%d p=%d %s K=%d n_func=%d" % (d, p, tag, B.shape[0], n_func))
        rec = L.saturate_p3_from_mall(
            Mall, d, p, Iceil, n_func, seed=20260812
        )
        rec["tag"] = tag
        rec["anchor_P3"] = (tag == "Kflip" and rec["P3"] == paths.SEALED_P3[d]
                            and rec.get("saturated"))
        L.dump(os.path.join(RES, "p3_%s_d%d_p%d.json" % (tag, d, p)), rec)
        log("P3 %s d=%d p=%d K=%d P3=%s sat=%s (sealed %d on Kflip=%d)"
            % (tag, d, p, rec["K"], rec["P3"], rec["saturated"],
               paths.SEALED_P3[d], paths.SEALED_P3_K[d]))
        if tag == "Kflip" and rec["P3"] != paths.SEALED_P3[d]:
            raise SystemExit("FATAL: P3(%d) on Kflip p=%d got %s want %d"
                             % (d, p, rec["P3"], paths.SEALED_P3[d]))
        out[tag] = rec
    return out


def sample_seed_values(fr, A, C, npts, p, d, seed):
    rng = np.random.default_rng(seed)
    W = rng.integers(1, p, size=(npts, 5)) % p
    log("jet_rows npts=%d deg=%d ns=%d ..." % (npts, d, A.shape[0]))
    t1 = time.time()
    V = SL.jet_rows(fr, A, C, W, np.zeros_like(W), 1, deg=d)[:, :, :, 0] % p
    log("jet_rows done in %.1fs shape=%s" % (time.time() - t1, V.shape))
    return V


def free_rungs(fr, A, C, Bcell, p, d, P3_cell, ms=None):
    N = int(Bcell.shape[0])
    if ms is None:
        ms = FREE_MS[d]
    nmon_need = max(L.nmon3(m) for m in ms)
    npts = int(max(nmon_need, P3_cell) * 1.45) + 80
    V = sample_seed_values(fr, A, C, npts, p, d, seed=20260812 + 100 * p + d)
    rng = np.random.default_rng(20260812 + 7 * p + 13 * d)
    rows_out = []
    best_free = None
    for m in ms:
        t1 = time.time()
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
            "m": m, "N": N, "d": d, "dim_sym3": nmon, "rank": rnk,
            "HF_L3": nmon - rnk, "npts": npts,
            "full_sym3": full, "P3_cell": P3_cell,
            "generic_cap": min(P3_cell, nmon),
            "free": full,
            "dim_V_le": bound,
            "seconds": time.time() - t1,
        }
        log("  d=%d free m=%d Sym3=%d rank=%d full=%s bound=%s (%.1fs)"
            % (d, m, nmon, rnk, full, bound, rec["seconds"]))
        rows_out.append(rec)
        if full:
            best_free = rec
        np.save(os.path.join(RES, "section_S_d%d_m%d_p%d.npy" % (d, m, p)), S)
    out = {
        "p": int(p), "d": d, "N": N, "P3_cell": P3_cell, "npts": npts,
        "sections": rows_out,
        "best_free_m": None if best_free is None else best_free["m"],
        "best_free_bound": None if best_free is None else best_free["dim_V_le"],
    }
    L.dump(os.path.join(RES, "free_rungs_d%d_p%d.json" % (d, p)), out)
    return out, V


def emit_and_run_msolve(fr, A, C, Bcell, V, p, d, m, P3_cell, timeout=900):
    """FULL restricted span as generators (counterintuitive rule)."""
    N = int(Bcell.shape[0])
    nmon = L.nmon3(m)
    expect_span = min(P3_cell, nmon)
    npts_have = V.shape[1]
    need = int(expect_span * 1.45) + 40
    if npts_have < need:
        extra = sample_seed_values(fr, A, C, need - npts_have, p, d,
                                   seed=20260812 + 333 * m + p + d)
        V = np.concatenate([V, extra], axis=1)
    rng = np.random.default_rng(777 + m + 17 * p + 31 * d)
    S = rng.integers(0, p, size=(m, N)) % p
    if int(P2.rref_rank_fast(S, p)) < m:
        S = (S + np.eye(m, N, dtype=np.int64)) % p
    basis = (S @ Bcell) % p
    M, mons = L.cubic_rows(V, basis, p)
    indep, kept = L.independent_rows(M, p)
    log("  d=%d m=%d sampled=%d indep=%d (cap %d) FULL span"
        % (d, m, M.shape[0], indep.shape[0], expect_span))
    if indep.shape[0] < int(0.9 * expect_span):
        raise SystemExit(
            "FATAL: generator subset d=%d m=%d p=%d indep=%d < 0.9*%d"
            % (d, m, p, indep.shape[0], expect_span)
        )
    ms = os.path.join(RES, "cone_d%d_m%d_p%d.ms" % (d, m, p))
    ngen = L.write_msolve(ms, indep, mons, m, p)
    tot_ms, n_ms = L.all_msolve_rss_kb()
    meta = {
        "m": m, "p": int(p), "d": d, "N": N, "dim_sym3": nmon,
        "n_sampled": int(M.shape[0]), "n_indep": int(indep.shape[0]),
        "n_gens_written": ngen, "ms_path": ms,
        "full_span_rule": True,
        "expect_span": expect_span,
        "rss_before_kb": L.rss_kb(),
        "other_msolve_rss_kb": tot_ms,
        "other_msolve_n": n_ms,
        "threads": paths.THREADS,
    }
    log("  wrote %s (%d gens); self_rss=%d kB other_msolve=%d kB n=%d"
        % (os.path.basename(ms), ngen, meta["rss_before_kb"], tot_ms, n_ms))
    if meta["rss_before_kb"] > paths.RSS_CAP_KB:
        log("  SKIP msolve: our RSS already %d kB" % meta["rss_before_kb"])
        meta["verdict"] = "skipped_own_memory"
        L.dump(os.path.join(RES, "msolve_d%d_m%d_p%d.json" % (d, m, p)), meta)
        return meta, V

    outp = os.path.join(RES, "cone_d%d_m%d_p%d_lead.out" % (d, m, p))
    logp = os.path.join(LOGS, "cone_d%d_m%d_p%d.log" % (d, m, p))
    run = L.run_msolve_g1(
        ms, outp, logp, threads=paths.THREADS, timeout=timeout,
        rss_cap_kb=paths.RSS_CAP_KB,
    )
    meta["seconds"] = run["seconds"]
    meta["timeout"] = run["timeout"]
    meta["returncode"] = run["returncode"]
    meta["rss_after_kb"] = L.rss_kb()
    meta["killed_rss"] = run.get("killed_rss")
    if run.get("killed_rss"):
        meta["verdict"] = "killed_rss"
        log("  d=%d m=%d KILLED: RSS cap (%.0fs) — no verdict"
            % (d, m, run["seconds"]))
    elif run["timeout"]:
        meta["verdict"] = "timeout"
        log("  d=%d m=%d TIMEOUT (%.0fs) — no verdict" % (d, m, run["seconds"]))
    elif not run["ok"]:
        meta["verdict"] = "msolve_fail"
        meta["log_tail"] = (run["log"] or "")[-2000:]
        log("  d=%d m=%d msolve fail rc=%s" % (d, m, run["returncode"]))
    else:
        parsed = L.parse_leading_pure_powers(run["lead"], m)
        meta["leading"] = parsed
        if parsed["zero_dimensional"]:
            meta["verdict"] = "cleared"
            meta["dim_V_le"] = N - m
            log("  d=%d m=%d CLEARED pure-powers=%s => dim V <= %d (%.1fs)"
                % (d, m, parsed["exponents_sorted"], N - m, run["seconds"]))
        else:
            meta["verdict"] = "not_zero_dim"
            meta["dim_V_le"] = None
            log("  d=%d m=%d leading missing %s — no bound"
                % (d, m, parsed["missing"]))
    L.dump(os.path.join(RES, "msolve_d%d_m%d_p%d.json" % (d, m, p)), meta)
    np.save(os.path.join(RES, "section_S_d%d_m%d_p%d.npy" % (d, m, p)), S)
    return meta, V


def compile_summary(p=None):
    primes = [p] if p else list(paths.PRIMES)
    by_d = {}
    for d in paths.DEGREES:
        by_d[str(d)] = {}
        for pr in primes:
            cell = _load("cell_d%d_p%d.json" % (d, pr))
            p3f = _load("p3_Kflip_d%d_p%d.json" % (d, pr))
            p3c = _load("p3_Kcut_d%d_p%d.json" % (d, pr))
            free = _load("free_rungs_d%d_p%d.json" % (d, pr))
            msolve_rows = []
            for fn in sorted(os.listdir(RES)):
                if fn.startswith("msolve_d%d_m" % d) and fn.endswith("_p%d.json" % pr):
                    msolve_rows.append(_load(fn))
            bounds = []
            if free and free.get("best_free_bound") is not None:
                bounds.append(("free_m%d" % free["best_free_m"],
                               free["best_free_bound"]))
            for r in msolve_rows:
                if r and r.get("verdict") == "cleared":
                    bounds.append(("msolve_m%d" % r["m"], r["dim_V_le"]))
            tightest = min((b for _, b in bounds), default=None)
            by_d[str(d)][str(pr)] = {
                "anchor_cell": None if not cell else {
                    "cell_dim": cell["cell_dim"],
                    "K_flip": cell["K_flip"],
                    "new_dim": cell["new_dim"],
                    "cut_ok": cell["cut_ok"],
                    "flip_ok": cell["flip_ok"],
                    "cut_rank": cell["cut_rank"],
                },
                "anchor_P3": None if not p3f else {
                    "K": p3f["K"], "P3": p3f["P3"],
                    "saturated": p3f["saturated"],
                    "ok": p3f["P3"] == paths.SEALED_P3[d],
                },
                "P3_on_cut": None if not p3c else {
                    "K": p3c["K"], "P3": p3c["P3"],
                    "saturated": p3c["saturated"],
                },
                "free": free,
                "msolve": msolve_rows,
                "bounds": bounds,
                "tightest_dim_V_le": tightest,
            }
    out = {
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "flagged_exclusion": False,
        "threads": paths.THREADS,
        "rss_cap_kb": paths.RSS_CAP_KB,
        "degrees": by_d,
        "tightest": {
            str(d): {
                str(pr): (by_d[str(d)].get(str(pr)) or {}).get("tightest_dim_V_le")
                for pr in primes
            }
            for d in paths.DEGREES
        },
    }
    L.dump(os.path.join(RES, "summary.json"), out)
    if p:
        L.dump(os.path.join(RES, "summary_p%d.json" % p), out)
    return out


def _load(name):
    path = os.path.join(RES, name)
    return json.load(open(path)) if os.path.exists(path) else None


def run_degree(fr, d, p, phases, msolve_ms):
    rec = A = C = NUL = Bflip = Bcut = None
    V = None
    P3_cut = None

    if any(ph in phases for ph in ("cell", "p3", "free", "msolve")):
        rec, A, C, NUL, Bflip, Bcut, _ = load_or_build_cells(fr, d, p)

    if "p3" in phases:
        pair = measure_p3_pair(fr, A, C, Bflip, Bcut, d, p)
        P3_cut = pair["Kcut"]["P3"]

    if "free" in phases:
        if P3_cut is None:
            pj = os.path.join(RES, "p3_Kcut_d%d_p%d.json" % (d, p))
            if os.path.exists(pj):
                P3_cut = json.load(open(pj))["P3"]
            else:
                P3_cut = paths.SEALED_P3[d]
        free, V = free_rungs(fr, A, C, Bcut, p, d, P3_cut)
        np.save(os.path.join(RES, "Vseed_d%d_p%d.npy" % (d, p)), V)

    if "msolve" in phases:
        if V is None:
            vp = os.path.join(RES, "Vseed_d%d_p%d.npy" % (d, p))
            if os.path.exists(vp):
                V = np.load(vp)
                log("loaded Vseed d=%d shape=%s" % (d, V.shape))
            else:
                V = sample_seed_values(fr, A, C, 4000, p, d,
                                       seed=20260812 + 100 * p + d)
        if P3_cut is None:
            pj = os.path.join(RES, "p3_Kcut_d%d_p%d.json" % (d, p))
            P3_cut = json.load(open(pj))["P3"] if os.path.exists(pj) \
                else paths.SEALED_P3[d]
        fj = os.path.join(RES, "free_rungs_d%d_p%d.json" % (d, p))
        free_m = set()
        if os.path.exists(fj):
            frj = json.load(open(fj))
            free_m = {s["m"] for s in frj["sections"] if s.get("free")}
        for m in msolve_ms:
            if m in free_m:
                log("skip d=%d m=%d (already free)" % (d, m))
                continue
            to = 480 if m <= 26 else (900 if m <= 28 else (1500 if m <= 30 else 2400))
            meta, V = emit_and_run_msolve(fr, A, C, Bcut, V, p, d, m, P3_cut,
                                          timeout=to)
            if meta.get("verdict") in ("timeout", "killed_rss"):
                log("stop climb d=%d: %s at m=%d" % (d, meta["verdict"], m))
                break


def main():
    args = sys.argv[1:]
    p = 331
    degrees = list(paths.DEGREES)
    phases = ["cell", "p3", "free", "msolve"]
    msolve_ms = None
    if args and args[0].isdigit():
        p = int(args[0])
        args = args[1:]
    if args and args[0].isdigit() and int(args[0]) in paths.DEGREES:
        degrees = [int(args[0])]
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
        elif args[0] == "p3":
            phases = ["cell", "p3"]
        elif args[0] == "summary":
            phases = ["summary"]
    log("CONE_D3738 produce p=%d degrees=%s phases=%s" % (p, degrees, phases))
    tot_ms, n_ms = L.all_msolve_rss_kb()
    log("preflight: other msolve n=%d rss=%d kB; self rss=%d kB; threads=%d"
        % (n_ms, tot_ms, L.rss_kb(), paths.THREADS))

    if phases == ["summary"]:
        compile_summary(p)
        log("DONE summary")
        return 0

    fr = None
    if any(ph in phases for ph in ("cell", "p3", "free", "msolve")):
        fr = build_frame(p)

    for d in degrees:
        ms = msolve_ms if msolve_ms is not None else list(MSOLVE_MS[d])
        run_degree(fr, d, p, phases, ms)

    compile_summary(p)
    log("DONE p=%d" % p)
    return 0


if __name__ == "__main__":
    sys.exit(main())
