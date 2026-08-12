#!/usr/bin/env python3
"""Extend the sealed window-cell table from d=34..42 to d=43..50.

Rebuilds the Layer-0 (1,6) cell at every d in 34..50, both primes, then
imposes the 60 all-degree C11-point conditions (the window), then the
parity-forced line-order finisher and the six-flip cut (odd d).

Sealed raw cells and sealed post-C11 windows at d=34..42 are fatal anchors.

Usage:
  python3 scripts/produce_extend.py [p] [dmin] [dmax]
  python3 scripts/produce_extend.py 331 34 50
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
import instruments as I
from c11_points import collect_c11_points

RES = paths.RES
T0 = time.time()


def dump(path, obj):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        json.dump(I.jsonable(obj), f, indent=1, sort_keys=True)
        f.write("\n")


def restrict_cell(NUL, block, p):
    """Intersect the cell with the left-kernel of `block` (ns x nfunc)."""
    if NUL.shape[0] == 0:
        return NUL
    S = (NUL @ (block % p)) % p
    Kloc = SL.nullspace(S.T % p, p) % p
    if Kloc.shape[0] == 0:
        return np.zeros((0, NUL.shape[1]), dtype=np.int64)
    return (Kloc @ NUL) % p


def impose_points(fr, A, C, NUL, d, p, pts):
    if NUL.shape[0] == 0:
        return {
            "n_points": len(pts),
            "n_functionals": 0,
            "rank": 0,
            "new_dim": 0,
            "sat_rank": 0,
            "sat_ok": True,
            "note": "empty cell",
        }, NUL
    ns = A.shape[0]
    K = int(NUL.shape[0])
    pb = D34.point_block(fr, A, C, d, pts, p)
    S = (NUL @ pb) % p
    rank = int(P2.rref_rank_fast(S, p))
    S2 = np.concatenate([S, S], axis=1) % p
    sat_rank = int(P2.rref_rank_fast(S2, p))
    NUL_win = restrict_cell(NUL, pb, p)
    if int(NUL_win.shape[0]) != K - rank:
        raise AssertionError(
            "window nullspace dim %d != K-rank %d" % (NUL_win.shape[0], K - rank)
        )
    rec = {
        "n_points": len(pts),
        "n_functionals": int(S.shape[1]),
        "rank": rank,
        "new_dim": K - rank,
        "sat_rank": sat_rank,
        "sat_ok": sat_rank == rank,
    }
    return rec, NUL_win


def instrument_bundle(fr, A, C, NUL, d, p):
    fin = I.finisher_line_order(fr, A, C, NUL, d, p, npts=40)
    flip = I.six_flip_rank(fr, A, C, NUL, d, p)
    if flip.get("skipped") or NUL.shape[0] == 0:
        post_dim = int(NUL.shape[0])
        flip_out = {k: v for k, v in flip.items() if k != "universal_matrix"}
        flip_out["post_flip_dim"] = post_dim
        return fin, flip_out, post_dim
    Bpost = I.post_flip_null(NUL, flip, p)
    post_dim = int(Bpost.shape[0])
    flip_out = {k: v for k, v in flip.items() if k != "universal_matrix"}
    flip_out["post_flip_dim"] = post_dim
    return fin, flip_out, post_dim


def run_degree(fr, d, dimM, p, rng, pts60, frames):
    print("=" * 70, flush=True)
    print(
        "EXTEND d=%d  p=%d  dimM=%d  qr=%s  [%.0fs]"
        % (d, p, dimM, paths.is_qr(d), time.time() - T0),
        flush=True,
    )
    out_path = os.path.join(RES, "d%d_p%d.json" % (d, p))

    profs = PL.profiles(d)
    if not profs:
        rec = {
            "d": d,
            "p": p,
            "dim_M": int(dimM),
            "error": "no admissible profile",
            "r0": None,
        }
        dump(out_path, rec)
        return rec
    r0 = min(x["r"] for x in profs)
    if r0 != 6:
        raise SystemExit("FATAL: r0=%d at d=%d (expected 6)" % (r0, d))

    cell = I.build_layer0_cell(fr, d, dimM, p, rng, npair=100, npt=80)
    if "error" in cell:
        dump(out_path, cell)
        return cell

    raw = int(cell["cell_dim"])
    print(
        "  raw_cell=%d  prof=%d  struct=%d  r0=%d  fired_C11=%s  [%.0fs]"
        % (
            raw,
            cell["dim_profile_only"],
            cell["dim_structure_only"],
            r0,
            cell["rules_fired"].get("C11_points"),
            time.time() - T0,
        ),
        flush=True,
    )

    if d in paths.SEALED_RAW and raw != paths.SEALED_RAW[d]:
        raise SystemExit(
            "FATAL: sealed raw cell failed at d=%d p=%d: got %d want %d"
            % (d, p, raw, paths.SEALED_RAW[d])
        )

    A, C, NUL = cell["A"], cell["C"], cell["NUL"]
    cut60, NUL_win = impose_points(fr, A, C, NUL, d, p, pts60)
    frame0 = [tuple(v) for v in frames[0]["points"]]
    cut5, _ = impose_points(fr, A, C, NUL, d, p, frame0)
    window = int(cut60["new_dim"])
    print(
        "  C11 rank60=%d  one_frame=%d  window=%d  sat=%s"
        % (cut60["rank"], cut5["rank"], window, cut60["sat_ok"]),
        flush=True,
    )

    if d in paths.SEALED_WINDOW and window != paths.SEALED_WINDOW[d]:
        raise SystemExit(
            "FATAL: sealed window failed at d=%d p=%d: got %d want %d"
            % (d, p, window, paths.SEALED_WINDOW[d])
        )
    if d == 35 and cut60["rank"] != 0:
        raise SystemExit("FATAL: d=35 control C11 rank is %d, must be 0" % cut60["rank"])

    fin, flip, post_dim = instrument_bundle(fr, A, C, NUL_win, d, p)
    if flip.get("skipped"):
        print("  six-flip: skipped (even)  window=%d" % window, flush=True)
    else:
        print(
            "  six-flip rank=%s dim_after=%s r1=%s amb=%s"
            % (
                flip.get("rank"),
                flip.get("dim_after"),
                flip.get("r1_bad"),
                flip.get("ambient_rank"),
            ),
            flush=True,
        )
    print(
        "  finisher ord>=%s rank=%s/%s impossible=%s sat=%s"
        % (
            fin.get("demanded_ord"),
            fin.get("rank"),
            fin.get("cell_dim"),
            fin.get("impossible"),
            fin.get("saturation_ok"),
        ),
        flush=True,
    )

    flagged = bool(window == 0 and raw > 0)
    rec = {
        "d": d,
        "p": p,
        "dim_M": int(dimM),
        "r0": r0,
        "n_profiles": len(profs),
        "raw_cell": raw,
        "sealed_raw": paths.SEALED_RAW.get(d),
        "sealed_raw_ok": (d not in paths.SEALED_RAW) or (raw == paths.SEALED_RAW[d]),
        "dim_profile_only": cell["dim_profile_only"],
        "dim_structure_only": cell["dim_structure_only"],
        "is_qr": paths.is_qr(d),
        "d_mod_11": d % 11,
        "rules_fired": cell["rules_fired"],
        "c11_already_in_structure": bool(cell["rules_fired"].get("C11_points")),
        "cut60": cut60,
        "cut_one_frame": {
            k: cut5[k] for k in ("n_points", "rank", "new_dim", "sat_ok")
        },
        "one_frame_rank_matches_60": cut5["rank"] == cut60["rank"],
        "window": window,
        "sealed_window": paths.SEALED_WINDOW.get(d),
        "sealed_window_ok": (d not in paths.SEALED_WINDOW)
        or (window == paths.SEALED_WINDOW[d]),
        "c11_rank": cut60["rank"],
        "finisher": fin,
        "six_flip": flip,
        "post_flip_dim": post_dim,
        "flagged_zero": flagged,
        "flag_note": (
            "window=0 on a previously alive raw cell: FLAGGED behind an "
            "ODDZERO-standard audit; not claimed as a degree exclusion"
            if flagged
            else None
        ),
        "seconds_cell": round(cell["seconds"], 1),
        "seconds_total": round(time.time() - T0, 1),
    }
    dump(out_path, rec)
    print("  wrote", out_path, flush=True)
    return rec


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    p = int(args[0]) if args else None
    dmin = int(args[1]) if len(args) >= 2 else 34
    dmax = int(args[2]) if len(args) >= 3 else 50
    primes = [p] if p else list(paths.PRIMES)

    Pbig = DIMS.big_prime()
    dims, _ = DIMS.pathA_dimM(Pbig, dmax=max(dmax, 50))
    for d, want in paths.SEALED_DIMM.items():
        if d <= dmax and dims[d] != want:
            raise SystemExit(
                "FATAL: dimM[%d]=%d != sealed %d (P=%d)" % (d, dims[d], want, Pbig)
            )
    dimM_path = os.path.join(RES, "dimM.json")
    dump(
        dimM_path,
        {
            "prime_for_molien": int(Pbig),
            "dmax": max(dmax, 50),
            "dim_M": [int(x) for x in dims],
            "sealed_ok": True,
        },
    )
    print(
        "[dimM] P=%d  M_34=%d M_42=%d M_50=%d  [%.0fs]"
        % (Pbig, dims[34], dims[42], dims[50], time.time() - T0),
        flush=True,
    )

    rng = np.random.default_rng(20260812)
    for prime in primes:
        print("[frame] p=%d  [%.0fs]" % (prime, time.time() - T0), flush=True)
        fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(prime)))
        pts, report = collect_c11_points(fr, prime)
        dump(os.path.join(RES, "c11_census_p%d.json" % prime), report)
        print(
            "[census] p=%d  %d points, %d frames  [%.0fs]"
            % (prime, report["n_points"], report["n_frames"], time.time() - T0),
            flush=True,
        )
        summary = []
        force = "--force" in sys.argv
        for d in range(dmin, dmax + 1):
            out_path = os.path.join(RES, "d%d_p%d.json" % (d, prime))
            if (not force) and os.path.exists(out_path):
                prev = json.load(open(out_path))
                if (
                    prev.get("window") is not None
                    and prev.get("finisher") is not None
                    and prev.get("six_flip") is not None
                    and not prev.get("error")
                ):
                    print("  RESUME skip d=%d p=%d window=%s" %
                          (d, prime, prev.get("window")), flush=True)
                    rec = prev
                    summary.append(
                        {
                            "d": rec.get("d"),
                            "raw_cell": rec.get("raw_cell"),
                            "c11_rank": rec.get("c11_rank"),
                            "window": rec.get("window"),
                            "is_qr": rec.get("is_qr"),
                            "finisher_impossible": (rec.get("finisher") or {}).get(
                                "impossible"
                            ),
                            "finisher_rank": (rec.get("finisher") or {}).get("rank"),
                            "finisher_demand": (rec.get("finisher") or {}).get(
                                "demanded_ord"
                            ),
                            "flip_rank": (rec.get("six_flip") or {}).get("rank"),
                            "flip_skip": bool((rec.get("six_flip") or {}).get("skipped")),
                            "post_flip_dim": rec.get("post_flip_dim"),
                            "flagged_zero": rec.get("flagged_zero"),
                        }
                    )
                    continue
            rec = run_degree(fr, d, dims[d], prime, rng, pts, report["frames"])
            summary.append(
                {
                    "d": rec.get("d"),
                    "raw_cell": rec.get("raw_cell"),
                    "c11_rank": rec.get("c11_rank"),
                    "window": rec.get("window"),
                    "is_qr": rec.get("is_qr"),
                    "finisher_impossible": (rec.get("finisher") or {}).get("impossible"),
                    "finisher_rank": (rec.get("finisher") or {}).get("rank"),
                    "finisher_demand": (rec.get("finisher") or {}).get("demanded_ord"),
                    "flip_rank": (rec.get("six_flip") or {}).get("rank"),
                    "flip_skip": bool((rec.get("six_flip") or {}).get("skipped")),
                    "post_flip_dim": rec.get("post_flip_dim"),
                    "flagged_zero": rec.get("flagged_zero"),
                }
            )
            dump(os.path.join(RES, "summary_p%d.json" % prime),
                 {"prime": prime, "rows": summary})

    print("DONE  [%.0fs]" % (time.time() - T0), flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
