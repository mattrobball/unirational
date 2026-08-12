#!/usr/bin/env python3
"""Cubic expansion F(T_c(x)) in cell parameters.

Reference: director_probes_20260812/cone_dimension_probe.py :: restricted_cubics.
The director function hardcodes deg=35; this copy is the same expansion with
a deg argument. The d=35 control imports the director function itself.
"""
from __future__ import annotations

import importlib.util
import itertools
import os

import numpy as np

import paths
import slicelib as SL


def load_director_probe():
    """Import the director module (paths/slicelib already cached)."""
    spec = importlib.util.spec_from_file_location(
        "cone_dimension_probe",
        os.path.join(paths.PROBE, "cone_dimension_probe.py"),
    )
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def restricted_cubics(fr, A, C, basis, npts, p, seed=20260812, deg=35):
    """npts cubic forms in the section parameters, one per sample point.

    Identical to cone_dimension_probe.restricted_cubics except `deg` is an
    argument (the director copy freezes DEG=35).
    """
    rng = np.random.default_rng(seed)
    W = rng.integers(1, p, size=(npts, 5)) % p
    V = SL.jet_rows(fr, A, C, W, np.zeros_like(W), 1, deg=deg)[:, :, :, 0] % p
    v = np.tensordot(basis % p, V % p, axes=(1, 0)) % p  # (m, npts, 5)
    m = basis.shape[0]
    mons = list(itertools.combinations_with_replacement(range(m), 3))
    idx = {t: n for n, t in enumerate(mons)}
    out = np.zeros((npts, len(mons)), dtype=np.int64)
    for k in range(5):
        Ak = v[:, :, k] % p
        Bk = v[:, :, (k + 1) % 5] % p
        for i in range(m):
            for j in range(i, m):
                base = (Ak[i] * Ak[j]) % p
                mult = 1 if i == j else 2
                for l in range(m):
                    t = tuple(sorted((i, j, l)))
                    out[:, idx[t]] = (out[:, idx[t]] + mult * base * Bk[l]) % p
    return out % p, mons, W


def restricted_cubics_director(fr, A, C, basis, npts, p, seed=20260812):
    """Call the director function unchanged (deg frozen at 35)."""
    mod = load_director_probe()
    rows, mons = mod.restricted_cubics(fr, A, C, basis, npts, p, seed=seed)
    return rows, mons
