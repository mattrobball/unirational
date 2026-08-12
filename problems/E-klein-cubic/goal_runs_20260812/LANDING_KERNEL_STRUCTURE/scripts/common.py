#!/usr/bin/env python3
"""Shared machinery for LANDING_KERNEL_STRUCTURE probes."""
from __future__ import annotations

import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
ROOT = os.path.abspath(os.path.join(PACKET, "..", ".."))
D34 = os.path.join(ROOT, "goal_runs_20260811", "D34_GUIDED_SWEEP")
LIS_RES = os.path.join(ROOT, "goal_runs_20260812", "LANDING_INVARIANT_SIDE", "results")
PAIR_RES = os.path.join(ROOT, "goal_runs_20260811", "PAIR_ATTACK_D35", "results")
SWEEP_SCR = os.path.join(ROOT, "goal_runs_20260812", "LANDING_SWEEP", "scripts")
for q in (D34, SWEEP_SCR, HERE):
    if q not in sys.path:
        sys.path.insert(0, q)

import slicelib as SL  # noqa: E402

os.makedirs(RES, exist_ok=True)

_FRAMES = {}


def frame(p):
    if p not in _FRAMES:
        _FRAMES[p] = SL.build_frame(p, verbose=False)
    return _FRAMES[p]


def load_cell(d, p):
    A = np.load(os.path.join(LIS_RES, "A_d%d_p%d.npy" % (d, p)))
    C = np.load(os.path.join(LIS_RES, "C_d%d_p%d.npy" % (d, p)))
    B = np.load(os.path.join(LIS_RES, "Bcell_d%d_p%d.npy" % (d, p)))
    return A, C, B


def eval_cell(fr, A, C, Bcell, pts, d):
    """(npts, 5, K): T_j(x_q) contracted with cell basis."""
    p = fr["p"]
    seeds = SL.jet_rows(fr, A, C, pts % p, np.zeros_like(pts), 1, deg=d)[:, :, :, 0] % p
    T = np.einsum("js,sqc->jqc", Bcell, seeds) % p
    return np.transpose(T, (1, 2, 0)) % p


def eval_seeds(fr, A, C, pts, d):
    """(ns, npts, 5): raw seed covariant values."""
    p = fr["p"]
    return SL.jet_rows(fr, A, C, pts % p, np.zeros_like(pts), 1, deg=d)[:, :, :, 0] % p


def klein_F_vec(V, p):
    s = np.zeros(V.shape[:-1], dtype=np.int64)
    for i in range(5):
        s = (s + V[..., i] * V[..., i] % p * V[..., (i + 1) % 5]) % p
    return s


class FastEchelon:
    """RREF row-span accumulator over F_p; reduce is a single matmul.

    Invariant: pivot columns of `basis` are unit columns, so reduction
    against the whole basis is v - v[pivots] @ basis (entries < p, sums
    fit int64 for rank*p^2 < 2^63)."""

    def __init__(self, ncols, p):
        self.p = int(p)
        self.ncols = ncols
        self.basis = np.zeros((0, ncols), dtype=np.int64)
        self.pivots = []

    @property
    def rank(self):
        return len(self.pivots)

    def reduce(self, v):
        p = self.p
        v = np.asarray(v, dtype=np.int64) % p
        if self.pivots:
            v = (v - v[self.pivots] @ self.basis) % p
        return v

    def try_add(self, v):
        p = self.p
        v = self.reduce(v)
        nz = np.nonzero(v)[0]
        if not nz.size:
            return False
        piv = int(nz[0])
        v = (v * pow(int(v[piv]), p - 2, p)) % p
        if self.basis.shape[0]:
            col = self.basis[:, piv].copy()
            nz2 = np.nonzero(col)[0]
            if nz2.size:
                self.basis[nz2] = (self.basis[nz2] - np.outer(col[nz2], v)) % p
        self.basis = (
            np.vstack([self.basis, v]) if self.basis.shape[0] else v.reshape(1, -1)
        )
        self.pivots.append(piv)
        return True


def landing_rows(Mall, cs, p):
    """Mall: (n_func, 5, K); cs: (b, K). Rows F(T_c(y_t)) as (b, n_func)."""
    Tv = np.einsum("tck,bk->btc", Mall, cs) % p
    return klein_F_vec(Tv, p)


def saturate_span(Mall, K, p, rng, ech=None, max_c=20000, stable_window=400,
                  batch=64, verbose_tag="", row_transform=None):
    """Grow span of landing rows until stable_window consecutive misses."""
    n_func = Mall.shape[0]
    if ech is None:
        ech = FastEchelon(n_func, p)
    stable = 0
    n_tested = 0
    while n_tested < max_c and stable < stable_window:
        cs = rng.integers(0, p, size=(batch, K), dtype=np.int64)
        rows = landing_rows(Mall, cs, p)
        if row_transform is not None:
            rows = row_transform(rows)
        for q in range(rows.shape[0]):
            n_tested += 1
            if ech.try_add(rows[q]):
                stable = 0
            else:
                stable += 1
            if stable >= stable_window or n_tested >= max_c:
                break
        if verbose_tag and n_tested % 512 < batch:
            print("  [%s] n=%d rank=%d stable=%d" % (verbose_tag, n_tested, ech.rank, stable), flush=True)
    return ech, n_tested, stable
