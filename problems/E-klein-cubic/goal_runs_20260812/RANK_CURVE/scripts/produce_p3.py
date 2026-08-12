#!/usr/bin/env python3
"""Exact saturated P3(d) at d=39,40,41,42 on LANDING_SWEEP / QR_POINT_CUTS cells.

Usage:
  python3 scripts/produce_p3.py              # 39..42 both primes
  python3 scripts/produce_p3.py 39 331       # single (d,p)
  python3 scripts/produce_p3.py 42           # d=42 both primes
"""
from __future__ import annotations

import os
import sys
import time

import numpy as np

import paths

if paths.INV_SCR not in sys.path:
    sys.path.insert(1, paths.INV_SCR)
import invlib as L  # noqa: E402
import d34lib as D34  # noqa: E402
import p2lib as P2  # noqa: E402
import slicelib as SL  # noqa: E402

import cells  # noqa: E402
import lin  # noqa: E402
import p3_batch  # noqa: E402

# n_func just above expected P3. Too large inflates the Echelon basis.
N_FUNC = {39: 7000, 40: 6500, 41: 7500, 42: 9000}
# d=42 uses the batched ranker (bounded memory).
BATCH_DEGREES = {42}


def run_inv_p3(fr, A, C, B, d, p, tag):
    n_func = N_FUNC.get(d, 8000)
    print(
        "[inv-P3] tag=%s d=%d p=%d K=%d n_func=%d rss=%.2fGB"
        % (tag, d, p, B.shape[0], n_func, lin.rss_gb()),
        flush=True,
    )
    if d in BATCH_DEGREES:
        rec = p3_batch.p3_batch(
            fr, L.eval_T_at_points, A, C, B, d, p,
            n_func=n_func,
            n_c=n_func,
            extra_size=600,
            extra_batches=2,
            seed=20260812,
        )
    else:
        rec = L.inv_side_p3(
            fr, A, C, B, d, p,
            n_func=n_func,
            max_c=16000,
            stable_window=500,
            extra_batches=2,
            extra_size=500,
            seed=20260812,
            grow_func=True,
        )
    rec["tag"] = tag
    rec["rss_gb"] = lin.rss_gb()
    return rec


def run_one(d: int, p: int) -> dict:
    t0 = time.time()
    print("=" * 60, "\n[produce_p3] d=%d p=%d" % (d, p), flush=True)
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=True)))
    rng = np.random.default_rng(20260812 + d)

    if d == 35:
        built = cells.load_d35_cell(p)
    else:
        built = cells.build_sweep_cell(fr, d, p, rng)
        if "error" in built:
            return {"d": d, "p": p, "error": built["error"]}

    A, C, B = built["A"], built["C"], built["Bcell"]
    print(
        "[cell] source=%s K=%d cell_dim=%s dim_M=%s rss=%.2fGB (%.1fs)"
        % (
            built.get("source"),
            built["K"],
            built.get("cell_dim"),
            built.get("dim_M"),
            lin.rss_gb(),
            time.time() - t0,
        ),
        flush=True,
    )
    np.save(os.path.join(paths.RES, "Bcell_d%d_p%d.npy" % (d, p)), B)
    np.save(os.path.join(paths.RES, "A_d%d_p%d.npy" % (d, p)), A)
    np.save(os.path.join(paths.RES, "C_d%d_p%d.npy" % (d, p)), C)

    rec = run_inv_p3(fr, A, C, B, d, p, "sweep_postflip")
    rec["cell_source"] = built.get("source")
    rec["cell_dim"] = built.get("cell_dim")
    rec["dim_M"] = built.get("dim_M")
    rec["seconds_total"] = time.time() - t0
    path = os.path.join(paths.RES, "p3_d%d_p%d.json" % (d, p))
    lin.dump(path, rec)
    print(
        "[write-early]", path,
        "P3=%s sat=%s (%.1fs)"
        % (rec.get("P3"), rec.get("saturated"), rec["seconds_total"]),
        flush=True,
    )

    # QR cut: identity on NQR; rank-1 on QR. Recompute P3 only when the
    # post-flip cell itself is cut (even QR degrees: no flip, cut drops K by 1).
    if "NUL" in built:
        try:
            cut = cells.qr_cut_basis(fr, A, C, built["NUL"], d, p)
            rec["qr_cut"] = {
                "rank": cut["rank"],
                "new_dim": cut["new_dim"],
                "n_points": cut["n_points"],
                "expect_alive": paths.QR_ALIVE.get(d),
                "is_qr": paths.is_qr(d),
            }
            print(
                "[qr-cut] rank=%s new_dim=%s expect=%s"
                % (cut["rank"], cut["new_dim"], paths.QR_ALIVE.get(d)),
                flush=True,
            )
            if (
                paths.is_qr(d)
                and cut["new_dim"] != built["K"]
                and cut["Bcut"].shape[0] > 0
            ):
                rec_cut = run_inv_p3(fr, A, C, cut["Bcut"], d, p, "qr_cut")
                rec["qr_cut_p3"] = {
                    "P3": rec_cut.get("P3"),
                    "K": rec_cut.get("K"),
                    "saturated": rec_cut.get("saturated"),
                    "n_func": rec_cut.get("n_func"),
                    "seconds": rec_cut.get("seconds"),
                }
                path_cut = os.path.join(paths.RES, "p3_qr_d%d_p%d.json" % (d, p))
                lin.dump(path_cut, rec_cut)
                print("[write]", path_cut, "P3=%s" % rec_cut.get("P3"), flush=True)
        except Exception as e:
            rec["qr_cut_error"] = str(e)
            print("[qr-cut] ERROR (P3 already saved):", e, flush=True)
        rec["seconds_total"] = time.time() - t0
        lin.dump(path, rec)
    print(
        "[write]", path,
        "P3=%s sat=%s total=%.1fs rss=%.2fGB"
        % (rec.get("P3"), rec.get("saturated"), rec["seconds_total"], lin.rss_gb()),
        flush=True,
    )
    return rec


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("-")]
    degrees = [39, 40, 41, 42]
    primes = list(paths.PRIMES)
    if args:
        nums = [int(a) for a in args]
        degs = [n for n in nums if n < 100]
        prs = [n for n in nums if n >= 100]
        if degs:
            degrees = degs
        if prs:
            primes = prs

    summary = {}
    for d in degrees:
        summary[str(d)] = {}
        for p in primes:
            rec = run_one(d, p)
            summary[str(d)][str(p)] = {
                "P3": rec.get("P3"),
                "HF3": rec.get("HF3"),
                "K": rec.get("K"),
                "N3": rec.get("N3"),
                "I_3d": rec.get("I_3d"),
                "saturated": rec.get("saturated"),
                "P3_is_lower_bound": rec.get("P3_is_lower_bound"),
                "deficit_vs_I": rec.get("deficit_vs_I"),
                "qr_cut": rec.get("qr_cut"),
                "qr_cut_p3": rec.get("qr_cut_p3"),
                "seconds": rec.get("seconds_total") or rec.get("seconds"),
                "error": rec.get("error"),
            }
            lin.dump(os.path.join(paths.RES, "p3_partial_summary.json"), summary)
    lin.dump(os.path.join(paths.RES, "p3_summary.json"), summary)
    print("SUMMARY", summary, flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
