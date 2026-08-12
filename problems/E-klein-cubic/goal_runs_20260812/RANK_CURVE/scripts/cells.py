#!/usr/bin/env python3
"""Window cells at degree d: LANDING_SWEEP post-flip, QR_POINT_CUTS cut."""
from __future__ import annotations

import importlib.util
import json
import os

import numpy as np

import paths
import slicelib as SL
import d34lib as D34
import p2lib as P2
import produce_dims34 as DIMS
import instruments as I


def dimM_of(d: int) -> int:
    Pbig = DIMS.big_prime()
    dims, _ = DIMS.pathA_dimM(Pbig, dmax=max(42, d))
    return int(dims[d])


def load_d35_cell(p: int) -> dict:
    """Sealed 37-cell from PAIR_ATTACK_D35 (same as invlib.load_d35_cell)."""
    null = np.load(os.path.join(paths.PAIR_RES, "layer0_null_p%d.npy" % p))
    A = np.load(os.path.join(paths.PAIR_RES, "layer0_A_p331.npy"))
    C = np.load(os.path.join(paths.PAIR_RES, "layer0_C_p331.npy"))
    we = json.load(open(os.path.join(paths.PAIR_RES, "worked_example_p%d.json" % p)))
    U = np.array(we["universal_matrix_6x39"], dtype=np.int64) % p
    K39 = SL.nullspace(U, p)
    assert K39.shape[0] == 37, K39.shape
    B37 = (K39 @ null) % p
    assert SL.rref_rank(B37, p) == 37
    return {
        "d": 35,
        "p": p,
        "A": A,
        "C": C,
        "NUL": null,
        "Bcell": B37,
        "K": 37,
        "cell_dim": 39,
        "source": "PAIR_ATTACK_D35",
    }


def build_sweep_cell(fr, d: int, p: int, rng) -> dict:
    """Layer-0 (1,6) cell then six-flip (odd d). LANDING_SWEEP recipe."""
    dimM = dimM_of(d)
    cell = I.build_layer0_cell(fr, d, dimM, p, rng, npair=100, npt=80)
    if "error" in cell:
        return cell
    NUL = cell["NUL"]
    if int(NUL.shape[0]) != paths.SEALED_CELL[d]:
        raise SystemExit(
            "FATAL: Layer-0 cell dim %d != sealed %d at d=%d p=%d"
            % (NUL.shape[0], paths.SEALED_CELL[d], d, p)
        )
    flip = I.six_flip_rank(fr, cell["A"], cell["C"], NUL, d, p)
    B = I.post_flip_null(NUL, flip, p)
    expect = paths.POST_FLIP_K[d]
    if int(B.shape[0]) != expect:
        raise SystemExit(
            "FATAL: post-flip K %d != sealed %d at d=%d p=%d"
            % (B.shape[0], expect, d, p)
        )
    return {
        "d": d,
        "p": p,
        "A": cell["A"],
        "C": cell["C"],
        "NUL": NUL,
        "Bcell": B,
        "K": int(B.shape[0]),
        "cell_dim": int(cell["cell_dim"]),
        "dim_M": dimM,
        "flip": {k: flip[k] for k in flip if k != "universal_matrix"},
        "source": "LANDING_SWEEP layer0+flip",
    }


def _load_c11():
    spec = importlib.util.spec_from_file_location(
        "c11_points",
        os.path.join(paths.QR_SCR, "c11_points.py"),
    )
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def qr_cut_basis(fr, A, C, NUL, d: int, p: int) -> dict:
    """Impose T=0 at the 60 C11-points (QR_POINT_CUTS)."""
    c11 = _load_c11()
    pts60, report = c11.collect_c11_points(fr, p)
    if NUL.shape[0] == 0:
        return {
            "rank": 0,
            "new_dim": 0,
            "Bcut": NUL,
            "n_points": 0,
        }
    pb = D34.point_block(fr, A, C, d, pts60, p)
    S = (NUL @ pb) % p  # (cell_dim, 5*n_pts)
    rank = int(P2.rref_rank_fast(S, p))
    # Left kernel of S: x @ S = 0  <=>  S.T @ x = 0.
    Kloc = SL.nullspace(S.T % p, p) % p
    if Kloc.shape[0] == 0:
        Bcut = np.zeros((0, NUL.shape[1]), dtype=np.int64)
    else:
        Bcut = (Kloc @ NUL) % p
    return {
        "rank": rank,
        "new_dim": int(Bcut.shape[0]),
        "Bcut": Bcut,
        "n_points": len(pts60),
        "census_n_points": report.get("n_points"),
        "n_frames": report.get("n_frames"),
    }
