#!/usr/bin/env python3
"""Cross-prime the director's single-prime cone-ladder claims at p=661.

Usage:
  python3 scripts/produce.py                # ranks + full-span m=20 msolve
  python3 scripts/produce.py ranks
  python3 scripts/produce.py msolve
  python3 scripts/produce.py director-control
  python3 scripts/produce.py summary

Writes ONLY under this packet's results/.
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import paths
import slicelib as SL
import conelib as C

RES = paths.RES
P = paths.PRIME
DIM37 = paths.DIM37
P3 = paths.P3_SEALED

# Director p=331 claims (director_probes_20260812/README.md).
DIRECTOR_CLAIMS = {
    "prime": 331,
    "source": "director_probes_20260812/README.md",
    "sections": {
        "6": {"dim_sym3": 56, "rank": 56, "HF_L3": 0, "generic_rank": 56},
        "8": {"dim_sym3": 120, "rank": 120, "HF_L3": 0, "generic_rank": 120},
        "10": {"dim_sym3": 220, "rank": 220, "HF_L3": 0, "generic_rank": 220},
        "18": {"dim_sym3": 1140, "rank": 1140, "HF_L3": 0, "generic_rank": 1140},
        "19": {"dim_sym3": 1330, "rank": 1330, "HF_L3": 0, "generic_rank": 1330},
        "20": {"dim_sym3": 1540, "rank": 1380, "HF_L3": 160, "generic_rank": 1380},
        "22": {"dim_sym3": 2024, "rank": 1380, "HF_L3": 644, "generic_rank": 1380},
    },
    "m20_msolve": {
        "generators": 240,
        "note": "subset, not full span",
        "zero_dimensional": True,
        "bound": 17,
        "lead_path": "director_probes_20260812/cone_m20_lead.out",
    },
}


def dump(name, obj):
    path = os.path.join(RES, name)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        json.dump(obj, f, indent=1)
    return path


def pin_threads():
    os.environ["OMP_NUM_THREADS"] = str(paths.THREADS)
    os.environ["OPENBLAS_NUM_THREADS"] = "1"
    os.environ["MKL_NUM_THREADS"] = "1"
    os.environ["NUMEXPR_NUM_THREADS"] = "1"


def director_control():
    lead_path = os.path.join(paths.DIR_PROBES, "cone_m20_lead.out")
    lead = C.parse_leading_ideal(lead_path)
    out = {
        "source": "director_probes_20260812/cone_m20_lead.out",
        "note": "director p=331 m=20 control: 240 generators (a subset).",
        "lead": lead,
        "clears": bool(lead.get("zero_dimensional")),
        "bound_if_clear": 37 - 20,
        "char": (lead.get("header") or {}).get("char"),
        "nlead": lead.get("nlead"),
        "pure_exponent_histogram": lead.get("pure_exponent_histogram"),
    }
    dump("director_m20_control.json", out)
    print("director m=20 p=331 control: zero_dim=%s nlead=%s missing=%s hist=%s"
          % (lead.get("zero_dimensional"), lead.get("nlead"),
             lead.get("missing_pure"), lead.get("pure_exponent_histogram")),
          flush=True)
    return out


def emit_ranks(p=P):
    pin_threads()
    print("== CONE_CROSSPRIME emit p=%d  ms=%s" % (p, list(paths.MS_ALL)), flush=True)
    print("   live msolve: %s" % (
        [{"pid": x["pid"], "rss_mb": x["rss_kb"] // 1024} for x in C.msolve_running()],),
          flush=True)
    print("   self rss_mb=%d" % (C.rss_kb() // 1024), flush=True)
    t0 = time.time()
    cell = C.cell37(p)
    A, Cc = C.load_AC()
    print("   cell37 %s  rank_U=%d  (%.1fs)" % (
        cell["B37"].shape, cell["rank_U"], time.time() - t0), flush=True)
    fr = SL.build_frame(p, verbose=False)
    max_pts = max(C.npts_for(m) for m in paths.MS_ALL)
    max_pts = max(max_pts, C.npts_for(37))
    rng = np.random.default_rng(paths.POINT_SEED)
    W = rng.integers(1, p, size=(max_pts, 5)) % p
    print("   evaluating %d points on 637 seeds (point_seed=%d)..."
          % (max_pts, paths.POINT_SEED), flush=True)
    t1 = time.time()
    V = C.seed_values(fr, A, Cc, W)
    print("   seed values %s in %.1fs  rss_mb=%d"
          % (V.shape, time.time() - t1, C.rss_kb() // 1024), flush=True)

    t2 = time.time()
    n_p3 = C.npts_for(37)
    rows37, _mons37 = C.cubic_rows(V[:, :n_p3, :], cell["B37"], p)
    idx37 = C.row_basis_indices(rows37, p)
    p3 = len(idx37)
    p3_rec = {
        "p": p,
        "m": 37,
        "npts": n_p3,
        "dim_sym3": C.nmon3(37),
        "rank": p3,
        "P3_sealed": P3,
        "match_sealed": p3 == P3,
        "point_seed": paths.POINT_SEED,
        "seconds": time.time() - t2,
    }
    dump("p3_p%d.json" % p, p3_rec)
    print("   P3=%d (sealed %d) in %.1fs" % (p3, P3, p3_rec["seconds"]), flush=True)

    recs = []
    for m in paths.MS_ALL:
        t3 = time.time()
        nmon = C.nmon3(m)
        npts = C.npts_for(m)
        sseed = C.section_seed(m)
        sec_rng = np.random.default_rng(sseed)
        S = sec_rng.integers(0, p, size=(m, DIM37)) % p
        # Fatal if the random section is rank-deficient (vanishingly rare).
        srank = int(SL.rref_rank(S, p))
        if srank != m:
            raise RuntimeError("section m=%d rank %d < m (reseed)" % (m, srank))
        basis = (S @ cell["B37"]) % p
        rows, mons = C.cubic_rows(V[:, :npts, :], basis, p)
        idx = C.row_basis_indices(rows, p)
        rank = len(idx)
        free = rank == nmon
        expected = min(P3, nmon)
        rec = {
            "p": p,
            "m": m,
            "dim_sym3": nmon,
            "npts": npts,
            "rank": rank,
            "HF_L3": nmon - rank,
            "generic_rank": expected,
            "matches_generic": rank == expected,
            "full_span_ngens": rank,
            "free_rung": free,
            "section_seed": sseed,
            "point_seed": paths.POINT_SEED,
            "section_rank": srank,
            "seconds_emit": time.time() - t3,
        }
        if free:
            rec["verdict"] = "FREE"
            rec["V_cap_L"] = "{0}"
            rec["bound"] = DIM37 - m
            print("   m=%d FREE  rank=%d/%d  => dim V <= %d  (%.1fs)"
                  % (m, rank, nmon, DIM37 - m, rec["seconds_emit"]), flush=True)
        else:
            rec["verdict"] = "RANKED"
            rec["bound"] = None
            print("   m=%d RANK  rank=%d/%d  HF=%d  generic=%d  (%.1fs)"
                  % (m, rank, nmon, nmon - rank, expected, rec["seconds_emit"]),
                  flush=True)
        if m == 20:
            rec["indep_row_indices"] = [int(i) for i in idx]
            rec["mons"] = None  # reconstructed on msolve emit
        dump("rung_m%d_p%d.json" % (m, p), rec)
        np.save(os.path.join(RES, "section_S_m%d_p%d.npy" % (m, p)), S)
        recs.append(rec)

        if m == 20:
            ms_path = os.path.join(RES, "cone_m20_p%d.ms" % p)
            indep = rows[idx]
            ng = C.write_msolve(ms_path, indep, mons, m, p)
            rec["ms_path"] = ms_path
            rec["ms_bytes"] = os.path.getsize(ms_path)
            rec["ngens_written"] = ng
            rec["note"] = "FULL restricted span (never a subset)"
            dump("rung_m%d_p%d.json" % (m, p), rec)
            print("   m=20 wrote FULL span %d gens -> %s (%d bytes)"
                  % (ng, ms_path, rec["ms_bytes"]), flush=True)

    emit = {
        "p": p,
        "cell_rank_U": cell["rank_U"],
        "cell_shape": list(cell["B37"].shape),
        "null_shape": cell["null_shape"],
        "dim_universal_json": cell["dim_universal_json"],
        "worked_example": cell["worked_example"],
        "null_path": cell["null_path"],
        "point_seed": paths.POINT_SEED,
        "section_seed_base": paths.SECTION_SEED_BASE,
        "section_seed_stride": paths.SECTION_SEED_STRIDE,
        "independence_note": (
            "sections drawn from packet seeds, not director 20260812 / 777+m "
            "and not CONE_LADDER_D35 777+m / 20260812+p"
        ),
        "P3": p3_rec,
        "rungs": recs,
        "seconds": time.time() - t0,
        "rss_mb": C.rss_kb() // 1024,
    }
    dump("emit_p%d.json" % p, emit)
    return emit


def solve_m20(p=P, threads=paths.THREADS, timeout=1800):
    pin_threads()
    rec_path = os.path.join(RES, "rung_m20_p%d.json" % p)
    rec = json.load(open(rec_path)) if os.path.isfile(rec_path) else {"p": p, "m": 20}
    ms_path = rec.get("ms_path") or os.path.join(RES, "cone_m20_p%d.ms" % p)
    if not os.path.isfile(ms_path):
        rec["verdict"] = "NO_VERDICT_MISSING_MS"
        dump("rung_m20_p%d.json" % p, rec)
        return rec
    ng = rec.get("ngens_written")
    if ng is not None and ng != P3:
        print("WARNING: ngens_written=%s is not full span %d" % (ng, P3), flush=True)
    out_path = os.path.join(RES, "cone_m20_p%d_lead.out" % p)
    log_path = os.path.join(RES, "cone_m20_p%d_msolve.log" % p)
    print("== msolve -g 1 -t %d  m=20 p=%d  ngens=%s  (timeout %ds)"
          % (threads, p, ng, timeout), flush=True)
    live = C.msolve_running()
    print("   live msolve: %s" % (
        [{"pid": x["pid"], "rss_mb": x["rss_kb"] // 1024} for x in live],),
          flush=True)
    print("   self rss_mb=%d" % (C.rss_kb() // 1024), flush=True)
    meta = C.run_msolve(ms_path, out_path, log_path, threads=threads, timeout=timeout)
    rec["msolve"] = {
        "returncode": meta.get("returncode"),
        "seconds": meta.get("seconds"),
        "timed_out": meta.get("timed_out"),
        "verdict": meta.get("verdict"),
        "threads": threads,
        "log_tail": meta.get("log_tail"),
        "lead": meta.get("lead"),
        "rss_kb_before": meta.get("rss_kb_before"),
        "rss_kb_after": meta.get("rss_kb_after"),
    }
    rec["verdict"] = meta.get("verdict")
    if meta.get("verdict") == "ZERO_DIM":
        rec["V_cap_L"] = "{0}"
        rec["bound"] = DIM37 - 20
        rec["clears"] = True
        print("   ZERO_DIM  dim V <= %d  (%.1fs)  hist=%s"
              % (DIM37 - 20, meta["seconds"],
                 (meta.get("lead") or {}).get("pure_exponent_histogram")),
              flush=True)
    elif meta.get("verdict") == "NOT_ZERO_DIM":
        rec["clears"] = False
        rec["bound"] = None
        print("   NOT zero-dimensional; missing %s" % meta.get("missing_pure"),
              flush=True)
    else:
        rec["clears"] = False
        rec["bound"] = None
        print("   %s  (%.1fs)" % (meta.get("verdict"), meta.get("seconds")), flush=True)
    dump("rung_m20_p%d.json" % p, rec)
    return rec


def compare_to_director():
    disagreements = []
    agreements = []
    rows = []
    for m in paths.MS_ALL:
        rec = json.load(open(os.path.join(RES, "rung_m%d_p%d.json" % (m, P))))
        claim = DIRECTOR_CLAIMS["sections"][str(m)]
        rank_ok = rec.get("rank") == claim["rank"]
        hf_ok = rec.get("HF_L3") == claim["HF_L3"]
        row = {
            "m": m,
            "director_p331_rank": claim["rank"],
            "this_p661_rank": rec.get("rank"),
            "director_HF_L3": claim["HF_L3"],
            "this_HF_L3": rec.get("HF_L3"),
            "dim_sym3": rec.get("dim_sym3"),
            "free_rung": rec.get("free_rung"),
            "rank_agrees": rank_ok,
            "hf_agrees": hf_ok,
        }
        rows.append(row)
        tag = "m=%d rank %s vs director %s" % (m, rec.get("rank"), claim["rank"])
        if rank_ok and hf_ok:
            agreements.append(tag)
        else:
            disagreements.append(tag)

    m20 = json.load(open(os.path.join(RES, "rung_m20_p%d.json" % P)))
    ctrl_path = os.path.join(RES, "director_m20_control.json")
    ctrl = json.load(open(ctrl_path)) if os.path.isfile(ctrl_path) else None
    dir_zd = bool((ctrl or {}).get("clears"))
    our_zd = bool(m20.get("clears"))
    m20_row = {
        "director_p331_zero_dim": dir_zd,
        "director_ngens": DIRECTOR_CLAIMS["m20_msolve"]["generators"],
        "this_p661_zero_dim": our_zd,
        "this_ngens": m20.get("ngens_written"),
        "this_full_span": m20.get("ngens_written") == P3,
        "this_threads": (m20.get("msolve") or {}).get("threads"),
        "this_seconds": (m20.get("msolve") or {}).get("seconds"),
        "this_pure_hist": ((m20.get("msolve") or {}).get("lead") or {}).get(
            "pure_exponent_histogram"),
        "director_pure_hist": (ctrl or {}).get("pure_exponent_histogram"),
        "zero_dim_agrees": dir_zd and our_zd,
    }
    if not m20_row["zero_dim_agrees"]:
        disagreements.append(
            "m=20 zero-dim director=%s this=%s" % (dir_zd, our_zd))
    else:
        agreements.append("m=20 zero-dimensional both primes")

    prime_dependence = len(disagreements) > 0
    out = {
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "prime_dependence": prime_dependence,
        "serious_finding": prime_dependence,
        "agreements": agreements,
        "disagreements": disagreements,
        "section_rows": rows,
        "m20": m20_row,
        "note": (
            "Agreement of ranks and of m=20 zero-dimensionality is the "
            "campaign's standard cross-prime evidence class. Exact leading "
            "exponents may differ (independent sections; director used a "
            "240-gen subset, this packet uses the full 1380-gen span)."
        ),
    }
    dump("crossprime_compare.json", out)
    return out


def compile_summary():
    emit = None
    ep = os.path.join(RES, "emit_p%d.json" % P)
    if os.path.isfile(ep):
        emit = json.load(open(ep))
    rungs = []
    tightest = None
    for m in paths.MS_ALL:
        path = os.path.join(RES, "rung_m%d_p%d.json" % (m, P))
        if not os.path.isfile(path):
            continue
        rec = json.load(open(path))
        rungs.append({
            "p": P, "m": m,
            "verdict": rec.get("verdict"),
            "rank": rec.get("rank"),
            "dim_sym3": rec.get("dim_sym3"),
            "HF_L3": rec.get("HF_L3"),
            "free": rec.get("free_rung"),
            "clears": rec.get("clears"),
            "bound": rec.get("bound"),
            "ngens_written": rec.get("ngens_written"),
            "seconds": (rec.get("msolve") or {}).get("seconds")
            or rec.get("seconds_emit"),
        })
        if rec.get("bound") is not None:
            tightest = rec["bound"] if tightest is None else min(tightest, rec["bound"])
    p3 = None
    pp = os.path.join(RES, "p3_p%d.json" % P)
    if os.path.isfile(pp):
        p3 = json.load(open(pp))
    ctrl = None
    cp = os.path.join(RES, "director_m20_control.json")
    if os.path.isfile(cp):
        ctrl = json.load(open(cp))
    cmp_ = None
    cpath = os.path.join(RES, "crossprime_compare.json")
    if os.path.isfile(cpath):
        cmp_ = json.load(open(cpath))
    summary = {
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "packet": "goal_runs_20260812/CONE_CROSSPRIME",
        "p": P,
        "director_prime": paths.DIRECTOR_PRIME,
        "P3": p3,
        "cell_shape": (emit or {}).get("cell_shape"),
        "cell_rank_U": (emit or {}).get("cell_rank_U"),
        "director_m20_control": ctrl,
        "rungs": rungs,
        "tightest_modular_bound": tightest,
        "crossprime": cmp_,
        "note": (
            "Bound is modular (F_661 section + free-span / leading-ideal). "
            "No degree excluded."
        ),
    }
    dump("summary.json", summary)
    return summary


def main():
    pin_threads()
    cmd = sys.argv[1] if len(sys.argv) > 1 else "all"
    if cmd in ("director-control", "all"):
        director_control()
        if cmd == "director-control":
            return
    if cmd in ("ranks", "all"):
        emit_ranks(P)
    if cmd in ("msolve", "all"):
        solve_m20(P, threads=paths.THREADS)
    if cmd in ("summary", "ranks", "msolve", "all"):
        compare_to_director()
        s = compile_summary()
        print(json.dumps({
            "headline": s["headline"],
            "tightest_modular_bound": s.get("tightest_modular_bound"),
            "prime_dependence": (s.get("crossprime") or {}).get("prime_dependence"),
            "disagreements": (s.get("crossprime") or {}).get("disagreements"),
            "rungs": s.get("rungs"),
        }, indent=2), flush=True)


if __name__ == "__main__":
    main()
