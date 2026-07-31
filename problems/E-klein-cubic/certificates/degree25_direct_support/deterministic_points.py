#!/usr/bin/env python3
"""Deterministic, replayable source-point sequence in F_p^5 for P25Y.2.

No unseeded RNG. Verifiers import this module (or reimplement the same LCG)
to rebuild the exact point list in order.
"""

from __future__ import annotations

import numpy as np

# Park–Miller LCG parameters (full period on 1..MOD-1).
LCG_A = 48271
LCG_C = 0
LCG_M = 2**31 - 1  # 2147483647
LCG_SEED = 2026073189  # fixed; encodes dispatch date + track tag

# How many points the producer uses at the decision fibre.
DEFAULT_N_POINTS = 1600


def lcg_state(seed: int = LCG_SEED) -> int:
    s = seed % LCG_M
    if s == 0:
        s = 1
    return s


def next_state(state: int) -> int:
    return (LCG_A * state + LCG_C) % LCG_M


def point_stream(prime: int, n: int, seed: int = LCG_SEED) -> np.ndarray:
    """Return (n, 5) array of points in F_prime^5, deterministic order.

    Each coordinate is taken from successive LCG outputs reduced mod prime.
    Zero vector is rejected and replaced by continuing the stream (so the
    sequence length is exactly n affine points, all nonzero).
    """
    if prime < 2:
        raise ValueError("prime must be >= 2")
    state = lcg_state(seed)
    out = np.zeros((n, 5), dtype=np.int64)
    i = 0
    while i < n:
        coords = []
        for _ in range(5):
            state = next_state(state)
            coords.append(state % prime)
        if all(c == 0 for c in coords):
            continue
        out[i] = coords
        i += 1
    return out


def point_stream_meta(prime: int, n: int = DEFAULT_N_POINTS, seed: int = LCG_SEED) -> dict:
    return {
        "generator": "Park-Miller LCG",
        "LCG_A": LCG_A,
        "LCG_C": LCG_C,
        "LCG_M": LCG_M,
        "seed": seed,
        "prime": prime,
        "n_points": n,
        "reject_zero_vector": True,
        "coordinate_rule": "five successive LCG outputs mod prime per point",
    }


if __name__ == "__main__":
    pts = point_stream(89, 5)
    print(point_stream_meta(89, 5))
    print(pts)
