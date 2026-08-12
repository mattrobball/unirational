#!/usr/bin/env python3
"""R4: director m=20 leading-ideal criterion + independent full-span msolve."""
import json
import os
import subprocess
import sys
import time

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import paths
from cell37 import cell37, load_AC
from cubics import cubic_rows, nmon3, write_msolve
from frame import build_frame
from leadparse import parse_leading_ideal
from linalg import row_basis_indices, rref_rank
from reynolds import eval_at_points

assert "slicelib" not in sys.modules


def director_artefact():
    lead_path = os.path.join(paths.DIR_PROBES, "cone_m20_lead.out")
    rec = parse_leading_ideal(lead_path)
    rec["source"] = "director_probes_20260812/cone_m20_lead.out"
    rec["claimed_exponents"] = (
        [3] * 10 + [4] * 5 + [5] * 5
    )
    if rec.get("ok"):
        got = [rec["pure_powers"][str(i)] for i in range(1, 21)]
        rec["exponents_in_order"] = got
        rec["exponent_multiset_matches_readme"] = sorted(got) == sorted(rec["claimed_exponents"])
        rec["criterion_applies"] = (
            rec.get("zero_dimensional") is True
            and rec.get("nvars") == 20
            and "reverse lex" in (rec.get("header") or {}).get("order", "").lower()
        )
        # Homogeneous + 0-dim => only the origin. Then dim V <= 37-20 = 17.
        rec["implies_V_cap_L_eq_0"] = rec["zero_dimensional"]
        rec["implies_dimV_le_17"] = rec["zero_dimensional"]
    return rec


def emit_and_solve(p, threads=2, npts=1800, seed=0xE56A0D17):
    print("== R4 independent m=20 full span, p=%d" % p, flush=True)
    vpath = os.path.join(paths.RES, "Vseed_p%d.npy" % p)
    wpath = os.path.join(paths.RES, "Wpts_p%d.npy" % p)
    bpath = os.path.join(paths.RES, "B37_p%d.npy" % p)
    if os.path.isfile(vpath) and os.path.isfile(bpath):
        V = np.load(vpath)
        B = np.load(bpath)
        print("  reused V", V.shape, flush=True)
        if V.shape[1] > npts:
            V = V[:, :npts, :]
    else:
        fr = build_frame(p, verbose=True)
        A, C = load_AC()
        B = cell37(p)["B37"]
        rngW = np.random.default_rng(seed + 17 * p)
        W = rngW.integers(1, p, size=(npts, 5))
        print("  evaluating seeds...", flush=True)
        V = eval_at_points(fr, A, C, W, deg=paths.DEG, batch=48)
        if os.path.isfile(wpath):
            pass
    rng = np.random.default_rng(seed + 101 * p)
    m = 20
    S = rng.integers(0, p, size=(m, 37))
    assert rref_rank(S, p) == m
    basis = (S @ B) % p
    rows, mons = cubic_rows(V, basis, p)
    r = rref_rank(rows, p)
    print("  restricted rank=%d (expect 1380), dim Sym3=%d" % (r, nmon3(m)), flush=True)
    idx = row_basis_indices(rows, p)
    indep = rows[idx]
    print("  independent generators=%d" % len(idx), flush=True)
    ms_path = os.path.join(paths.RES, "own_cone_m20_p%d.ms" % p)
    out_path = os.path.join(paths.RES, "own_cone_m20_p%d_lead.out" % p)
    log_path = os.path.join(paths.RES, "own_cone_m20_p%d_msolve.log" % p)
    ng = write_msolve(ms_path, indep, mons, m, p)
    print("  wrote %s (%d gens)" % (ms_path, ng), flush=True)

    # resource check
    try:
        ps = subprocess.check_output(["ps", "-eo", "rss,comm"], text=True)
        msolve_rss = 0
        for line in ps.splitlines():
            parts = line.split()
            if len(parts) >= 2 and parts[1] == "msolve":
                msolve_rss += int(parts[0])
        print("  live msolve rss_kb=%d" % msolve_rss, flush=True)
    except Exception as e:
        print("  ps failed", e, flush=True)

    cmd = ["msolve", "-g", "1", "-t", str(threads), "-v", "1",
           "-f", ms_path, "-o", out_path]
    t0 = time.time()
    proc = subprocess.run(cmd, capture_output=True, text=True, timeout=1800)
    dt = time.time() - t0
    log = (proc.stdout or "") + (proc.stderr or "")
    with open(log_path, "w") as f:
        f.write(log)
    lead = parse_leading_ideal(out_path)
    rec = {
        "p": p,
        "m": 20,
        "restricted_rank": int(r),
        "dim_sym3": nmon3(m),
        "n_independent": int(len(idx)),
        "n_written": int(ng),
        "full_span": int(r) == 1380,
        "threads": threads,
        "seconds": dt,
        "returncode": proc.returncode,
        "cmd": cmd,
        "lead": lead,
        "zero_dimensional": bool(lead.get("zero_dimensional")),
        "bound": 17 if lead.get("zero_dimensional") else None,
        "log_tail": "\n".join(log.splitlines()[-30:]),
    }
    print("  msolve %.2fs zero_dim=%s nlead=%s"
          % (dt, rec["zero_dimensional"], lead.get("nlead")), flush=True)
    return rec


def main():
    os.makedirs(paths.RES, exist_ok=True)
    director = director_artefact()
    with open(os.path.join(paths.RES, "r4_director_lead.json"), "w") as f:
        json.dump(director, f, indent=1)
    print("director lead zero_dim=%s missing=%s"
          % (director.get("zero_dimensional"), director.get("missing_pure")),
          flush=True)

    own = {}
    for p in paths.PRIMES:
        try:
            own[str(p)] = emit_and_solve(p, threads=2)
            with open(os.path.join(paths.RES, "r4_own_m20_p%d.json" % p), "w") as f:
                json.dump(own[str(p)], f, indent=1)
        except subprocess.TimeoutExpired:
            own[str(p)] = {"p": p, "timed_out": True, "zero_dimensional": False}
            print("  TIMEOUT p=%d" % p, flush=True)

    dir_ok = bool(director.get("zero_dimensional") and director.get("criterion_applies"))
    own_ok = all(own.get(str(p), {}).get("zero_dimensional") for p in paths.PRIMES)
    if dir_ok and own_ok:
        verdict = "CONFIRMED"
    elif dir_ok and not own_ok:
        verdict = "CORRECTED"
    else:
        verdict = "REFUTED"
    out = {
        "director": {
            "zero_dimensional": director.get("zero_dimensional"),
            "nlead": director.get("nlead"),
            "pure_powers": director.get("pure_powers"),
            "criterion_applies": director.get("criterion_applies"),
            "exponent_multiset_matches_readme": director.get("exponent_multiset_matches_readme"),
        },
        "own": {k: {
            "zero_dimensional": v.get("zero_dimensional"),
            "restricted_rank": v.get("restricted_rank"),
            "n_independent": v.get("n_independent"),
            "seconds": v.get("seconds"),
            "nlead": (v.get("lead") or {}).get("nlead"),
            "pure_powers": (v.get("lead") or {}).get("pure_powers"),
            "missing_pure": (v.get("lead") or {}).get("missing_pure"),
        } for k, v in own.items()},
        "verdict": verdict,
        "dimV_le_17_modular": bool(dir_ok or own_ok),
    }
    with open(os.path.join(paths.RES, "r4_summary.json"), "w") as f:
        json.dump(out, f, indent=1)
    print("R4", verdict, "dimV<=17 modular", out["dimV_le_17_modular"], flush=True)
    return out


if __name__ == "__main__":
    main()
