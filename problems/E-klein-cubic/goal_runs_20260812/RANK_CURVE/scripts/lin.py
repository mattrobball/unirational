#!/usr/bin/env python3
"""Small linear-algebra helpers. Modular rank stays exact; no floats."""
from __future__ import annotations

import json
import os
import resource

import numpy as np


def rss_gb() -> float:
    """Peak RSS of this process in GB. macOS ru_maxrss is bytes."""
    return resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 1e9


def klein_F(v, p: int) -> int:
    s = 0
    for i in range(5):
        s = (s + int(v[i]) * int(v[i]) % p * int(v[(i + 1) % 5])) % p
    return int(s)


def klein_F_batch(Tv, p: int):
    """Tv (..., 5) -> F values. Same polynomial as restricted_cubics."""
    s = np.zeros(Tv.shape[:-1], dtype=np.int64)
    for i in range(5):
        s = (s + (Tv[..., i] * Tv[..., i] % p) * Tv[..., (i + 1) % 5]) % p
    return s % p


def nmon3(K: int) -> int:
    return (K * (K + 1) * (K + 2)) // 6


def nmon4(K: int) -> int:
    return (K * (K + 1) * (K + 2) * (K + 3)) // 24


def rank_mod(M, p: int) -> int:
    """Exact rank over F_p. Vectorized pivot search; forward elimination only."""
    A = np.array(M, dtype=np.int64, copy=True) % p
    rows, cols = A.shape
    r = 0
    for c in range(cols):
        col = A[r:, c]
        nz = np.nonzero(col)[0]
        if nz.size == 0:
            continue
        piv = r + int(nz[0])
        if piv != r:
            A[[r, piv]] = A[[piv, r]]
        inv = pow(int(A[r, c]) % p, p - 2, p)
        A[r] = (A[r] * inv) % p
        below = A[r + 1 :, c]
        kk = np.nonzero(below)[0]
        if kk.size:
            A[r + 1 + kk] = (A[r + 1 + kk] - np.outer(below[kk], A[r])) % p
        r += 1
        if r == rows:
            break
    return int(r)


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
    if isinstance(obj, (np.bool_,)):
        return bool(obj)
    return obj


def dump(path, obj):
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    with open(path, "w") as f:
        json.dump(jsonable(obj), f, indent=1, sort_keys=True)
        f.write("\n")
