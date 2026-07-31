#!/usr/bin/env python3
"""P25Y.2 independent verifier.

Does not import produce_rows.py. Rebuilds the monic basis at p=89, regenerates
the deterministic point sequence, recomputes cubic rows for a prefix and the
full rank growth, and checks stored echelon rank and hashes.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

# Reimplement point stream (do not trust produce_rows); may import deterministic_points
from deterministic_points import LCG_A, LCG_C, LCG_M, LCG_SEED, point_stream  # noqa: E402

OUT = HERE
P, Z = 89, 78


def rebuild_basis(prime: int, zeta: int):
    recon = C.load_reconstructor()
    seed_data = C.load_seeds()
    module = recon.load_module(prime, zeta)
    seeds = [
        module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
        for r in seed_data
    ]
    _, plus, minus = C.involution_eigenspaces(module, prime)
    ker = C.arrangement_kernel(module, seeds, plus, prime)
    strict, sr, _ = C.strict_from_arrangement(module, seeds, ker, prime)
    basis43, piv = C.monic_basis_reynolds(sr, prime)
    return module, seeds, basis43, piv


def main() -> None:
    errors: list[str] = []
    for name in (
        "dvr_certificate.json",
        "rank_growth.json",
        "direct_rows_p89.npz",
        "direct_rows_p89.json",
        "deterministic_points_p89.npz",
        "deterministic_points.py",
    ):
        if not (OUT / name).exists():
            errors.append(f"missing {name}")
    if errors:
        print("VERIFY FAIL:")
        for e in errors:
            print(" ", e)
        sys.exit(1)

    dvr = json.loads((OUT / "dvr_certificate.json").read_text())
    if dvr.get("exit") != "P25Y-DVR-PASS":
        errors.append(f"DVR not PASS: {dvr.get('exit')}")

    growth = json.loads((OUT / "rank_growth.json").read_text())
    body = {k: v for k, v in growth.items() if k != "self_sha256"}
    digest = C.sha256_bytes(
        (json.dumps(body, indent=2, sort_keys=True) + "\n").encode()
    )
    if digest != growth.get("self_sha256"):
        errors.append("rank_growth self_sha256 mismatch")

    if not growth.get("rank_is_lower_bound_only", False):
        errors.append("must declare rank is lower bound only")
    if growth.get("upper_bound_proved") is True:
        errors.append("upper bound must not be claimed without proof")

    n = int(growth["n_points"])
    print(f"rebuild basis and {n} deterministic points at p={P}", flush=True)
    module, seeds, basis43, piv = rebuild_basis(P, Z)
    if C.sha256_arr(basis43.astype(np.uint64)) != dvr["decide_fibre"]["basis43_sha256"]:
        errors.append("basis sha != DVR certificate")
    if piv != list(range(43)):
        errors.append("monic pivots not 0..42")

    points = point_stream(P, n, seed=LCG_SEED)
    with np.load(OUT / "deterministic_points_p89.npz") as zf:
        stored_pts = zf["points"].astype(np.int64)
    if not np.array_equal(points, stored_pts % P):
        errors.append("stored points != regenerated LCG stream")

    # Full recompute of rank (decisive invariant)
    print("recompute full echelon rank", flush=True)
    R = C.batch_seed_evaluations(module, seeds, points, P).reshape(n, 5, C.MOLIEN_DIM)
    vals = np.einsum("nsw,bw->nbs", R, basis43) % P
    echelon: list = []
    last_inc = 0
    for i in range(n):
        if C.add_echelon_row(echelon, C.fast_cubic_row(vals[i], P), P):
            last_inc = i + 1
    recompute_rank = len(echelon)
    stored_rank = int(growth["rank_final"])
    if recompute_rank != stored_rank:
        errors.append(f"rank recompute {recompute_rank} != stored {stored_rank}")
    if last_inc != int(growth["last_rank_increase_at"]):
        errors.append(
            f"last increase {last_inc} != stored {growth['last_rank_increase_at']}"
        )

    with np.load(OUT / "direct_rows_p89.npz") as zf:
        ech = zf["echelon"].astype(np.int64) % P
    if ech.shape[0] != stored_rank:
        errors.append(f"echelon rows {ech.shape[0]} != rank {stored_rank}")
    if C.sha256_arr(ech.astype(np.uint64)) != growth.get("echelon_sha256"):
        # recompute sha from stack
        if echelon:
            stacked = np.stack([r for _, r in echelon]).astype(np.uint64)
            if C.sha256_arr(stacked) != growth.get("echelon_sha256"):
                errors.append("echelon sha mismatch vs recomputed stack")
        if C.sha256_arr(ech.astype(np.uint64)) != C.sha256_arr(
            np.stack([r for _, r in echelon]).astype(np.uint64)
        ):
            errors.append("stored echelon != recomputed echelon arrays")

    # Same row space check
    if echelon and ech.shape[0] > 0:
        stacked = np.stack([r for _, r in echelon]).astype(np.int64) % P
        if not C.same_row_space(stacked, ech, P):
            errors.append("stored echelon not same row space as recompute")

    # Spot-check: first growth checkpoint
    if growth.get("growth"):
        g0 = growth["growth"][0]
        ech0: list = []
        for i in range(int(g0["n_points"])):
            C.add_echelon_row(ech0, C.fast_cubic_row(vals[i], P), P)
        if len(ech0) != int(g0["rank"]):
            errors.append(
                f"first block rank {len(ech0)} != stored {g0['rank']}"
            )

    if errors:
        print("VERIFY FAIL:")
        for e in errors:
            print(" ", e)
        sys.exit(1)
    print(
        f"VERIFY OK: rank={recompute_rank} last_inc={last_inc} "
        f"LCG_A={LCG_A} seed={LCG_SEED} M={LCG_M} C={LCG_C} "
        f"rss={C.rss_mib():.1f}"
    )


if __name__ == "__main__":
    main()
