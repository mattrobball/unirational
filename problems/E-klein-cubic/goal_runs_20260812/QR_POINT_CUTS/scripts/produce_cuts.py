#!/usr/bin/env python3
"""Rebuild Layer-0 cells and impose the 60 C11-point conditions.

Degrees: 35 (NQR control), 36, 37, 38, 42 (QR window cells).
Primes: 331, 661.
Engine: D34_GUIDED_SWEEP (slicelib / d34lib.point_block / produce_d34 /
produce_ladder.structure_blocks). Sealed cell dims 39/63/121/151/397 are
fatal anchors. At d=35 the 60-point rank on the cell must be 0.

Usage:
  python3 scripts/produce_cuts.py [p] [d ...]
  python3 scripts/produce_cuts.py --census-only [p]
  python3 scripts/produce_cuts.py 331 35 36 37 38 42
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import paths
import slicelib as SL
import p2lib as P2
import d34lib as D34
import produce_d34 as PD
import produce_ladder as PL
import produce_dims34 as DIMS
from c11_points import collect_c11_points

RES = paths.RES
T0 = time.time()


def jsonable(obj):
    if isinstance(obj, dict):
        return {k: jsonable(v) for k, v in obj.items()}
    if isinstance(obj, (list, tuple)):
        return [jsonable(v) for v in obj]
    if isinstance(obj, (np.integer,)):
        return int(obj)
    if isinstance(obj, (np.floating,)):
        return float(obj)
    if isinstance(obj, np.ndarray):
        return obj.tolist()
    if isinstance(obj, (bool, int, float, str)) or obj is None:
        return obj
    return str(obj)


def dump(path, obj):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        json.dump(jsonable(obj), f, indent=1, sort_keys=True)
        f.write("\n")


def build_layer0_cell(fr, d, dimM, p, rng, npair=100, npt=80):
    """Structure + (P)+(P+)+ord_ellV>=6. Same recipe as LANDING_SWEEP."""
    t0 = time.time()
    A, C, got = PD.basis_seeds(fr, d, dimM, p, rng)
    if A is None:
        return {"d": d, "p": p, "error": "seed shortfall %d/%d" % (got, dimM)}
    P11, P5on, P5off = PL.eig_points(fr, p)
    c1, c2 = PD.plane_blocks(fr, A, C, d, 1, npair, p, rng)
    sb, fired = PL.structure_blocks(fr, A, C, d, npt, p, rng, P11, P5on, P5off)
    blocks = [c1, c2] + [b for _, b in sb]
    r0 = 6
    lb = PD.line_block(fr, A, C, d, r0, npair, p, rng)
    full = np.concatenate(blocks + [lb], axis=1) % p
    NUL = SL.nullspace(full.T % p, p) % p
    cell_dim = int(NUL.shape[0])
    d_prof = int(dimM - P2.rref_rank_fast(np.concatenate([c1, c2, lb], axis=1), p))
    d_struct = int(dimM - P2.rref_rank_fast(np.concatenate(blocks, axis=1), p))
    d_full = int(dimM - P2.rref_rank_fast(full, p))
    if d_full != cell_dim:
        raise AssertionError("nullspace dim %d != corank %d" % (cell_dim, d_full))
    return {
        "d": d,
        "p": p,
        "dim_M": int(dimM),
        "cell_dim": cell_dim,
        "dim_profile_only": d_prof,
        "dim_structure_only": d_struct,
        "r0": r0,
        "rules_fired": fired,
        "A": A,
        "C": C,
        "NUL": NUL,
        "seconds": time.time() - t0,
    }


def impose_points(fr, A, C, NUL, d, p, pts):
    """Rank of T(p)=0 at the listed points, restricted to the cell."""
    if NUL.shape[0] == 0:
        return {
            "n_points": len(pts),
            "n_functionals": 0,
            "rank": 0,
            "new_dim": 0,
            "sat_rank": 0,
            "sat_ok": True,
            "note": "empty cell",
        }
    ns = A.shape[0]
    K = int(NUL.shape[0])
    pb = D34.point_block(fr, A, C, d, pts, p)  # (ns, 5*n_pts)
    S = (NUL @ pb) % p                         # (K, 5*n_pts)
    rank = int(P2.rref_rank_fast(S, p))
    # saturation: the same 60 evaluation rows stacked twice
    S2 = np.concatenate([S, S], axis=1) % p
    sat_rank = int(P2.rref_rank_fast(S2, p))
    return {
        "n_points": len(pts),
        "n_functionals": int(S.shape[1]),
        "rank": rank,
        "new_dim": K - rank,
        "sat_rank": sat_rank,
        "sat_ok": sat_rank == rank,
    }


def run_degree(fr, d, dimM, p, rng, pts60, frames):
    print("=" * 70, flush=True)
    print("CUT d=%d  p=%d  dimM=%d  qr=%s  [%.0fs]"
          % (d, p, dimM, paths.is_qr(d), time.time() - T0), flush=True)
    cell = build_layer0_cell(fr, d, dimM, p, rng, npair=100, npt=80)
    if "error" in cell:
        rec = {"d": d, "p": p, "error": cell["error"]}
        dump(os.path.join(RES, "cut_d%d_p%d.json" % (d, p)), rec)
        return rec

    sealed = paths.SEALED_CELL[d]
    cell_dim = cell["cell_dim"]
    print("  cell_dim=%d  sealed=%d  match=%s  fired_C11=%s  [%.0fs]"
          % (cell_dim, sealed, cell_dim == sealed,
             cell["rules_fired"].get("C11_points"), time.time() - T0),
          flush=True)
    if cell_dim != sealed:
        raise SystemExit("FATAL: sealed cell dim failed at d=%d p=%d: got %d want %d"
                         % (d, p, cell_dim, sealed))

    A, C, NUL = cell["A"], cell["C"], cell["NUL"]
    cut60 = impose_points(fr, A, C, NUL, d, p, pts60)
    frame0 = [tuple(v) for v in frames[0]["points"]]
    cut5 = impose_points(fr, A, C, NUL, d, p, frame0)
    print("  rank60=%d  new_dim=%d  sat=%s  rank_one_frame=%d"
          % (cut60["rank"], cut60["new_dim"], cut60["sat_ok"], cut5["rank"]),
          flush=True)

    if d == 35 and cut60["rank"] != 0:
        raise SystemExit("FATAL: d=35 control rank is %d, must be 0" % cut60["rank"])

    flagged = bool(cut60["new_dim"] == 0 and cell_dim > 0)
    rec = {
        "d": d,
        "p": p,
        "dim_M": cell["dim_M"],
        "cell_dim": cell_dim,
        "sealed_cell": sealed,
        "sealed_ok": cell_dim == sealed,
        "dim_profile_only": cell["dim_profile_only"],
        "dim_structure_only": cell["dim_structure_only"],
        "is_qr": paths.is_qr(d),
        "d_mod_11": d % 11,
        "rules_fired": cell["rules_fired"],
        "c11_already_in_structure": bool(cell["rules_fired"].get("C11_points")),
        "cut60": cut60,
        "cut_one_frame": cut5,
        "one_frame_rank_matches_60": cut5["rank"] == cut60["rank"],
        "new_dim": cut60["new_dim"],
        "rank": cut60["rank"],
        "flagged_zero": flagged,
        "flag_note": (
            "new_dim=0 on a previously alive cell: FLAGGED behind an "
            "ODDZERO-standard audit; not claimed as a degree exclusion"
            if flagged else None
        ),
        "seconds_cell": round(cell["seconds"], 1),
        "seconds_total": round(time.time() - T0, 1),
    }
    dump(os.path.join(RES, "cut_d%d_p%d.json" % (d, p)), rec)
    print("  wrote cut_d%d_p%d.json" % (d, p), flush=True)
    return rec


def run_census(fr, p):
    pts, report = collect_c11_points(fr, p)
    dump(os.path.join(RES, "c11_census_p%d.json" % p), report)
    print("[census] p=%d  60 points, 12 frames of 5, all on X, ladder-5 is a frame"
          % p, flush=True)
    return pts, report


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    census_only = "--census-only" in sys.argv
    p = int(args[0]) if args else None
    if census_only:
        primes = [p] if p else list(paths.PRIMES)
        degrees = []
    else:
        primes = [p] if p else list(paths.PRIMES)
        if len(args) >= 2:
            degrees = [int(x) for x in args[1:]]
        else:
            degrees = list(paths.CUT_DEGREES)

    Pbig = DIMS.big_prime()
    dims, _ = DIMS.pathA_dimM(Pbig, dmax=42)
    rng = np.random.default_rng(20260812)

    for prime in primes:
        print("[frame] p=%d  [%.0fs]" % (prime, time.time() - T0), flush=True)
        fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(prime)))
        pts, report = run_census(fr, prime)
        if census_only:
            continue
        frames = report["frames"]
        for d in degrees:
            run_degree(fr, d, dims[d], prime, rng, pts, frames)

    print("DONE  [%.0fs]" % (time.time() - T0), flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
