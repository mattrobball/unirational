#!/usr/bin/env python3
"""Saturate the sampled cubic span on the 37-cell; report plateau dimension.

Incremental rank: keep a row-echelon basis of the cubic coefficient space,
add a new sample only when it increases rank. Stops after `stable_window`
consecutive non-increasing samples or at max_pts.
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import paths
import landlib as L
import slicelib as SL

RES = paths.RES


def incremental_plateau(p, max_pts=4000, stable_window=200, seed=20260811,
                        batch_eval=16):
    cell = L.load_cell(p)
    fr = SL.build_frame(p, verbose=True)
    rng = np.random.default_rng(seed + p)
    K = L.DIM37
    nmons = (K * (K + 1) * (K + 2)) // 6
    # echelon basis stored as list of reduced rows (or matrix)
    basis = np.zeros((0, nmons), dtype=np.int64)
    pivots = []  # pivot column per basis row
    rank_curve = []
    t0 = time.time()
    n_tested = 0
    n_since_increase = 0
    indep_rows = []  # keep the original cubic rows that increased rank

    def reduce_against_basis(v):
        """Return v reduced by current basis; optionally would-extend info."""
        nonlocal basis
        v = v.copy() % p
        for i, piv in enumerate(pivots):
            if v[piv]:
                v = (v - v[piv] * basis[i]) % p
        return v

    def extend_basis(v_red, original_row):
        nonlocal basis, pivots
        # find pivot
        nz = np.nonzero(v_red)[0]
        if nz.size == 0:
            return False
        piv = int(nz[0])
        inv = SL.inv_mod(int(v_red[piv]), p)
        v_red = (v_red * inv) % p
        # eliminate this pivot from existing basis rows
        if basis.shape[0]:
            col = basis[:, piv].copy()
            nz = np.nonzero(col)[0]
            if nz.size:
                basis[nz] = (basis[nz] - np.outer(col[nz], v_red)) % p
        basis = np.vstack([basis, v_red]) if basis.shape[0] else v_red.reshape(1, -1)
        pivots.append(piv)
        indep_rows.append(original_row % p)
        return True

    print("saturating cubic span at p=%d (max_pts=%d, stable=%d)" % (
        p, max_pts, stable_window), flush=True)

    while n_tested < max_pts and n_since_increase < stable_window:
        b = min(batch_eval, max_pts - n_tested)
        pts = rng.integers(0, p, size=(b, 5), dtype=np.int64)
        for i in range(b):
            if not pts[i].any():
                pts[i, 0] = 1
        M_all = L.eval_cell_at_points(fr, cell, pts)
        for q in range(b):
            row, _mons = L.cubic_coeff_row(M_all[q], p)
            n_tested += 1
            v_red = reduce_against_basis(row)
            if np.any(v_red):
                extend_basis(v_red, row)
                n_since_increase = 0
            else:
                n_since_increase += 1
            if n_tested % 50 == 0 or n_since_increase == 0:
                rank_curve.append({
                    "n": n_tested,
                    "rank": int(basis.shape[0]),
                    "stable": n_since_increase,
                    "t": time.time() - t0,
                })
            if n_tested % 100 == 0:
                print("  n=%d rank=%d stable=%d (%.1fs)" % (
                    n_tested, basis.shape[0], n_since_increase,
                    time.time() - t0), flush=True)
            if n_since_increase >= stable_window:
                break

    plateau = int(basis.shape[0])
    mons = list(__import__("itertools").combinations_with_replacement(range(K), 3))
    out = {
        "p": p,
        "npts_tested": n_tested,
        "plateau_rank": plateau,
        "nmons": nmons,
        "stable_window": stable_window,
        "max_pts": max_pts,
        "seed": seed + p,
        "rank_curve": rank_curve,
        "saturated": n_since_increase >= stable_window,
        "seconds": time.time() - t0,
    }
    np.save(os.path.join(RES, "cubic_indep_p%d.npy" % p),
            np.array(indep_rows, dtype=np.int64))
    np.save(os.path.join(RES, "cubic_basis_echelon_p%d.npy" % p), basis)
    with open(os.path.join(RES, "plateau_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=2)
    print("PLATEAU p=%d rank=%d after %d tests saturated=%s (%.1fs)" % (
        p, plateau, n_tested, out["saturated"], out["seconds"]), flush=True)
    return out, np.array(indep_rows, dtype=np.int64), mons, cell, fr


if __name__ == "__main__":
    primes = [int(a) for a in sys.argv[1:]] or [331, 661]
    for p in primes:
        sample_plateau(p)
