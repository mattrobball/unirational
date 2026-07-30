#!/usr/bin/env python3
"""Shared exact helpers for WP-6 border-support certificates.

Does not import produce.py. Absolute-path safe.
"""

from __future__ import annotations

import hashlib
import importlib.util
import json
import math
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
P = 67
DEGREE = 25
QDIM = 37
KDIM = 6
BORDER_RANK = 28


def sha256_file(path: Path | str) -> str:
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_arr(array: np.ndarray) -> str:
    return sha256_bytes(np.ascontiguousarray(array).tobytes())


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def rank_mod(matrix: np.ndarray, prime: int = P) -> int:
    a = (np.asarray(matrix) % prime).astype(np.int64).copy()
    if a.size == 0:
        return 0
    rows, cols = a.shape
    r = 0
    for c in range(cols):
        piv = next((i for i in range(r, rows) if a[i, c] % prime), None)
        if piv is None:
            continue
        a[[r, piv]] = a[[piv, r]]
        inv = pow(int(a[r, c]) % prime, -1, prime)
        a[r] = (a[r] * inv) % prime
        for i in range(rows):
            if i != r and a[i, c] % prime:
                a[i] = (a[i] - a[i, c] * a[r]) % prime
        r += 1
        if r == rows:
            break
    return r


def rref(matrix: np.ndarray, prime: int = P):
    a = (np.asarray(matrix) % prime).astype(np.int64).copy()
    rows, cols = a.shape
    pivots: list[int] = []
    r = 0
    for c in range(cols):
        piv = next((i for i in range(r, rows) if a[i, c] % prime), None)
        if piv is None:
            continue
        a[[r, piv]] = a[[piv, r]]
        inv = pow(int(a[r, c]) % prime, -1, prime)
        a[r] = (a[r] * inv) % prime
        for i in range(rows):
            if i != r and a[i, c] % prime:
                a[i] = (a[i] - a[i, c] * a[r]) % prime
        pivots.append(c)
        r += 1
        if r == rows:
            break
    return a, pivots


def nullspace_rows(matrix: np.ndarray, prime: int = P) -> np.ndarray:
    mat, pivots = rref(matrix, prime)
    cols = matrix.shape[1]
    free = [c for c in range(cols) if c not in pivots]
    basis = []
    for f in free:
        v = np.zeros(cols, dtype=np.int64)
        v[f] = 1
        for i, pcol in enumerate(pivots):
            v[pcol] = (-mat[i, f]) % prime
        basis.append(v)
    if not basis:
        return np.zeros((0, cols), dtype=np.int64)
    return np.asarray(basis, dtype=np.int64)


def invert_mod(matrix: np.ndarray, prime: int = P) -> np.ndarray:
    n = matrix.shape[0]
    a = np.concatenate(
        [matrix.astype(np.int64) % prime, np.eye(n, dtype=np.int64)], axis=1
    )
    for col in range(n):
        piv = next(i for i in range(col, n) if a[i, col] % prime)
        a[[col, piv]] = a[[piv, col]]
        inv = pow(int(a[col, col]) % prime, -1, prime)
        a[col] = (a[col] * inv) % prime
        for i in range(n):
            if i != col and a[i, col] % prime:
                a[i] = (a[i] - a[i, col] * a[col]) % prime
    return a[:, n:]


def binom(n: int, k: int) -> int:
    if n < k or n < 0 or k < 0:
        return 0
    return math.comb(n, k)


def dim_border_piece(degree: int, n_q: int = QDIM) -> int:
    """Dimension of the degree-`degree` piece of S^{28} with shifts 0,1^6,2^21."""
    return (
        binom(degree + n_q - 1, n_q - 1)
        + 6 * binom(degree - 1 + n_q - 1, n_q - 1)
        + 21 * binom(degree - 2 + n_q - 1, n_q - 1)
    )


def write_json_with_self_hash(path: Path, payload: dict) -> str:
    """Write JSON with sort_keys, then set self_sha256 of the pre-hash body."""
    body = {k: v for k, v in payload.items() if k != "self_sha256"}
    text = json.dumps(body, indent=2, sort_keys=True) + "\n"
    digest = sha256_bytes(text.encode())
    body["self_sha256"] = digest
    path.write_text(json.dumps(body, indent=2, sort_keys=True) + "\n")
    return digest


def coefficients_sha256_from_npz(path: Path, key: str = "coefficients") -> str:
    with np.load(path) as frozen:
        return sha256_arr(np.ascontiguousarray(frozen[key]))
