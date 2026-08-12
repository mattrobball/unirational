#!/usr/bin/env python3
"""Emit and solve the d=35 landing-cone section ladder.

Usage:
  python3 scripts/produce_ladder.py emit --p 331 --ms 18,19,20,22
  python3 scripts/produce_ladder.py solve --p 331 --m 20
  python3 scripts/produce_ladder.py anchors --p 331
  python3 scripts/produce_ladder.py director-control

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
import conelib as C

RES = paths.RES
DEG = paths.DEG
DIM37 = paths.DIM37
P3 = paths.P3_SEALED


def dump(name, obj):
    path = os.path.join(RES, name)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        json.dump(obj, f, indent=1)
    return path


def npts_for(m):
    span = min(P3, C.nmon3(m))
    return int(1.4 * span) + 40


def director_control():
    """Re-read the sealed m=20 leading ideal (240-gen director artefact)."""
    lead_path = os.path.join(paths.DIR_PROBES, "cone_m20_lead.out")
    lead = C.parse_leading_ideal(lead_path)
    out = {
        "source": "director_probes_20260812/cone_m20_lead.out",
        "note": "director control: 240 generators (a subset). Lane uses full span.",
        "lead": lead,
        "clears": bool(lead.get("zero_dimensional")),
        "bound_if_clear": 37 - 20,
    }
    dump("director_m20_control.json", out)
    print("director m=20 control: zero_dim=%s missing=%s exponents=%s"
          % (lead.get("zero_dimensional"), lead.get("missing_pure"),
             lead.get("pure_powers")))
    return out


def emit_at_prime(p, ms, seed_pts=20260812):
    """Evaluate seeds once; emit free-rung ranks and full-span .ms files."""
    print("== emit p=%d  ms=%s" % (p, ms), flush=True)
    t0 = time.time()
    cell = C.cell37(p)
    A, Cc = C.load_AC()
    print("   cell37 %s  rank_U=%d  (%.1fs)" % (
        cell["B37"].shape, cell["rank_U"], time.time() - t0), flush=True)
    fr = SL.build_frame(p, verbose=False)
    max_pts = max(npts_for(m) for m in ms)
    # also enough for global P3
    max_pts = max(max_pts, npts_for(37))
    rng = np.random.default_rng(seed_pts + p)
    W = rng.integers(1, p, size=(max_pts, 5)) % p
    print("   evaluating %d points on 637 seeds..." % max_pts, flush=True)
    t1 = time.time()
    V = C.seed_values(fr, A, Cc, W)
    print("   seed values %s in %.1fs" % (V.shape, time.time() - t1), flush=True)

    # global P3 on the 37-cell
    t2 = time.time()
    n_p3 = npts_for(37)
    rows37, mons37 = C.cubic_rows(V[:, :n_p3, :], cell["B37"], p)
    idx37 = C.row_basis_indices(rows37, p)
    p3 = len(idx37)
    p3_rec = {
        "p": p, "m": 37, "npts": n_p3, "dim_sym3": C.nmon3(37),
        "rank": p3, "P3_sealed": P3, "match_sealed": p3 == P3,
        "seconds": time.time() - t2,
    }
    dump("p3_p%d.json" % p, p3_rec)
    print("   P3=%d (sealed %d) in %.1fs" % (p3, P3, p3_rec["seconds"]), flush=True)

    recs = []
    for m in ms:
        t3 = time.time()
        nmon = C.nmon3(m)
        npts = npts_for(m)
        sec_rng = np.random.default_rng(777 + m)
        S = sec_rng.integers(0, p, size=(m, DIM37)) % p
        if m == 37:
            basis = cell["B37"]
            S = np.eye(DIM37, dtype=np.int64)
        else:
            basis = (S @ cell["B37"]) % p
        rows, mons = C.cubic_rows(V[:, :npts, :], basis, p)
        idx = C.row_basis_indices(rows, p)
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
            "section_seed": 777 + m,
            "point_seed": seed_pts + p,
            "seconds_emit": time.time() - t3,
        }
        if free:
            rec["verdict"] = "FREE"
            rec["V_cap_L"] = "{0}"
            rec["bound"] = DIM37 - m
            print("   m=%d FREE  rank=%d/%d  => dim V <= %d  (%.1fs)"
                  % (m, rank, nmon, DIM37 - m, rec["seconds_emit"]), flush=True)
        else:
            ms_path = os.path.join(RES, "cone_m%d_p%d.ms" % (m, p))
            ng = C.write_msolve(ms_path, indep, mons, m, p)
            rec["verdict"] = "EMITTED"
            rec["ms_path"] = ms_path
            rec["ms_bytes"] = os.path.getsize(ms_path)
            rec["ngens_written"] = ng
            print("   m=%d EMIT  rank=%d/%d  gens=%d  %s  (%.1fs)"
                  % (m, rank, nmon, ng, ms_path, rec["seconds_emit"]), flush=True)
        dump("rung_m%d_p%d.json" % (m, p), rec)
        recs.append(rec)
        # keep section matrix for replay (small)
        np.save(os.path.join(RES, "section_S_m%d_p%d.npy" % (m, p)), S)

    dump("emit_p%d.json" % p, {
        "p": p, "cell_rank_U": cell["rank_U"], "cell_shape": list(cell["B37"].shape),
        "P3": p3_rec, "rungs": recs, "seconds": time.time() - t0,
    })
    return recs


def solve_rung(p, m, threads=4, timeout=7200):
    rec_path = os.path.join(RES, "rung_m%d_p%d.json" % (m, p))
    rec = json.load(open(rec_path)) if os.path.isfile(rec_path) else {"p": p, "m": m}
    if rec.get("free_rung"):
        print("m=%d p=%d already FREE" % (m, p), flush=True)
        return rec
    ms_path = rec.get("ms_path") or os.path.join(RES, "cone_m%d_p%d.ms" % (m, p))
    if not os.path.isfile(ms_path):
        rec["verdict"] = "NO_VERDICT_MISSING_MS"
        dump("rung_m%d_p%d.json" % (m, p), rec)
        return rec
    out_path = os.path.join(RES, "cone_m%d_p%d_lead.out" % (m, p))
    log_path = os.path.join(RES, "cone_m%d_p%d_msolve.log" % (m, p))
    print("== msolve -g 1 -t %d  m=%d p=%d  %s  (timeout %ds)"
          % (threads, m, p, ms_path, timeout), flush=True)
    live = C.msolve_running()
    print("   live msolve: %s" % (
        [{"pid": x["pid"], "rss_mb": x["rss_kb"] // 1024} for x in live],),
          flush=True)
    meta = C.run_msolve(ms_path, out_path, log_path, threads=threads, timeout=timeout)
    rec["msolve"] = {
        "returncode": meta.get("returncode"),
        "seconds": meta.get("seconds"),
        "timed_out": meta.get("timed_out"),
        "verdict": meta.get("verdict"),
        "threads": threads,
        "log_tail": meta.get("log_tail"),
        "lead": meta.get("lead"),
    }
    rec["verdict"] = meta.get("verdict")
    if meta.get("verdict") == "ZERO_DIM":
        rec["V_cap_L"] = "{0}"
        rec["bound"] = DIM37 - m
        rec["clears"] = True
        print("   ZERO_DIM  dim V <= %d  (%.1fs)  pure=%s"
              % (DIM37 - m, meta["seconds"],
                 (meta.get("lead") or {}).get("pure_powers")), flush=True)
    elif meta.get("verdict") == "NOT_ZERO_DIM":
        rec["clears"] = False
        rec["bound"] = None
        print("   NOT zero-dimensional; missing %s"
              % meta.get("missing_pure"), flush=True)
    else:
        rec["clears"] = False
        rec["bound"] = None
        print("   %s  (%.1fs)" % (meta.get("verdict"), meta.get("seconds")), flush=True)
    dump("rung_m%d_p%d.json" % (m, p), rec)
    return rec


def compile_summary():
    rows = []
    tightest = 18  # free m=19 is already known; overwritten by our data
    for p in paths.PRIMES:
        for m in list(paths.RUNGS) + list(paths.HIGHER) + [18, 19]:
            path = os.path.join(RES, "rung_m%d_p%d.json" % (m, p))
            if not os.path.isfile(path):
                continue
            rec = json.load(open(path))
            rows.append({
                "p": p, "m": m,
                "verdict": rec.get("verdict"),
                "rank": rec.get("rank"),
                "dim_sym3": rec.get("dim_sym3"),
                "free": rec.get("free_rung"),
                "clears": rec.get("clears"),
                "bound": rec.get("bound"),
                "seconds": (rec.get("msolve") or {}).get("seconds")
                or rec.get("seconds_emit"),
            })
            if rec.get("bound") is not None:
                tightest = min(tightest, rec["bound"]) if isinstance(tightest, int) \
                    else rec["bound"]
    p3s = {}
    for p in paths.PRIMES:
        path = os.path.join(RES, "p3_p%d.json" % p)
        if os.path.isfile(path):
            p3s[str(p)] = json.load(open(path))
    ctrl_path = os.path.join(RES, "director_m20_control.json")
    ctrl = json.load(open(ctrl_path)) if os.path.isfile(ctrl_path) else None
    summary = {
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "P3": p3s,
        "director_m20_control": ctrl,
        "rungs": rows,
        "tightest_bound": tightest,
        "note": "bound is modular (F_p section + leading-ideal / free-span).",
    }
    dump("summary.json", summary)
    return summary


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", choices=["director-control", "emit", "solve", "anchors", "summary"])
    ap.add_argument("--p", type=int, default=331)
    ap.add_argument("--ms", type=str, default="18,19,20,22,24,28,32")
    ap.add_argument("--m", type=int, default=20)
    ap.add_argument("--t", type=int, default=4)
    ap.add_argument("--timeout", type=int, default=7200)
    args = ap.parse_args()
    if args.cmd == "director-control":
        director_control()
    elif args.cmd == "emit":
        ms = tuple(int(x) for x in args.ms.split(",") if x)
        emit_at_prime(args.p, ms)
        compile_summary()
    elif args.cmd == "solve":
        solve_rung(args.p, args.m, threads=args.t, timeout=args.timeout)
        compile_summary()
    elif args.cmd == "anchors":
        director_control()
        emit_at_prime(args.p, (18, 19))
        compile_summary()
    elif args.cmd == "summary":
        s = compile_summary()
        print(json.dumps(s, indent=2))


if __name__ == "__main__":
    main()
