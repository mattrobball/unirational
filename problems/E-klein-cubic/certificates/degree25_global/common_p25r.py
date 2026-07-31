#!/usr/bin/env python3
"""Shared exact helpers for P25R (degree-25 global coefficient model).

Independent of produce_*.py. Absolute-path safe.
Implements CRT / rational reconstruction explicitly (no SymPy ratrecon).
"""

from __future__ import annotations

import hashlib
import json
import math
import sys
from fractions import Fraction as Q
from pathlib import Path
from typing import Any, Iterable

import numpy as np

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
TMP = ROOT / "tmp" / "p25r"
TMP.mkdir(parents=True, exist_ok=True)

DEGREE = 25
M_PLANE = 1
N_STAR = DEGREE + 2 * M_PLANE + 1  # 28
TERMINAL = 3 * DEGREE  # 75
MOLIEN_DIM = 189
STRICT_DIM = 43
Q_DIM = 37
K_DIM = 6
BORDER_RANK = 28
RESIDUAL_RANK = 7
BASED_KERNEL_DIM = 36
ARRANGEMENT_KERNEL_DIM = 59
FREE_AD_DIM = (DEGREE + 1) * 2  # 52

# Good split primes p ≡ 1 (mod 11) with primitive 11th root and γ² ≡ −11.
GOOD_PRIMES: list[tuple[int, int]] = [
    (67, 64),
    (89, 78),
    (199, 61),
    (331, 270),
    (353, 58),
]


def sha256_file(path: Path | str) -> str:
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_arr(array: np.ndarray) -> str:
    return sha256_bytes(np.ascontiguousarray(array).tobytes())


def canonical_json(obj: Any) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def write_json_self_hash(path: Path, payload: dict) -> str:
    body = {k: v for k, v in payload.items() if k != "self_sha256"}
    text = canonical_json(body)
    digest = sha256_bytes(text.encode())
    body["self_sha256"] = digest
    path.write_text(canonical_json(body))
    return digest


def q_to_str(x: Q) -> str:
    x = Q(x)
    if x.denominator == 1:
        return str(x.numerator)
    return f"{x.numerator}/{x.denominator}"


def parse_q(s: str | int | Q) -> Q:
    if isinstance(s, Q):
        return s
    if isinstance(s, int):
        return Q(s)
    if "/" in str(s):
        a, b = str(s).split("/")
        return Q(int(a), int(b))
    return Q(int(s))


def binom(n: int, k: int) -> int:
    if k < 0 or n < 0 or k > n:
        return 0
    return math.comb(n, k)


def monoms_bin(deg: int) -> list[tuple[int, int]]:
    return [(deg - k, k) for k in range(deg + 1)]


def free_rank_jet(order: int, target_dim: int) -> int:
    if order < 0:
        return 0
    return (order + 1) * target_dim


def rank_mod(matrix: np.ndarray, prime: int) -> int:
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


def rref(matrix: np.ndarray, prime: int):
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


def nullspace_rows(matrix: np.ndarray, prime: int) -> np.ndarray:
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


def invert_mod(matrix: np.ndarray, prime: int) -> np.ndarray:
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


def rank_Q(cols: list[list[Q]]) -> int:
    """Column rank of a list of column vectors over Q."""
    if not cols:
        return 0
    n = len(cols[0])
    m = len(cols)
    A = [[cols[j][i] for j in range(m)] for i in range(n)]
    r = 0
    for c in range(m):
        piv = next((i for i in range(r, n) if A[i][c] != 0), None)
        if piv is None:
            continue
        A[r], A[piv] = A[piv], A[r]
        inv = Q(1) / A[r][c]
        A[r] = [inv * x for x in A[r]]
        for i in range(n):
            if i != r and A[i][c] != 0:
                f = A[i][c]
                A[i] = [A[i][j] - f * A[r][j] for j in range(m)]
        r += 1
        if r == n:
            break
    return r


def solve_Q(cols: list[list[Q]], target: list[Q]):
    """Solve sum_j cols[j] * x_j = target over Q. Returns rank, ok, solution."""
    n = len(target)
    m = len(cols)
    if m == 0:
        return 0, all(x == 0 for x in target), []
    A = [[cols[j][i] for j in range(m)] + [target[i]] for i in range(n)]
    pivots: list[int] = []
    r = 0
    for c in range(m):
        piv = next((i for i in range(r, n) if A[i][c] != 0), None)
        if piv is None:
            continue
        A[r], A[piv] = A[piv], A[r]
        inv = Q(1) / A[r][c]
        A[r] = [inv * x for x in A[r]]
        for i in range(n):
            if i != r and A[i][c] != 0:
                f = A[i][c]
                A[i] = [A[i][j] - f * A[r][j] for j in range(m + 1)]
        pivots.append(c)
        r += 1
        if r == n:
            break
    for i in range(r, n):
        if A[i][m] != 0:
            return r, False, None
    x = [Q(0)] * m
    for i, c in enumerate(pivots):
        x[c] = A[i][m]
    return r, True, x


# ---------------------------------------------------------------------------
# Explicit CRT and rational reconstruction (no SymPy private helpers)
# ---------------------------------------------------------------------------

def egcd(a: int, b: int) -> tuple[int, int, int]:
    if b == 0:
        return a, 1, 0
    g, x, y = egcd(b, a % b)
    return g, y, x - (a // b) * y


def inv_mod(a: int, m: int) -> int:
    g, x, _ = egcd(a % m, m)
    if g != 1:
        raise ZeroDivisionError(f"no inverse of {a} mod {m}")
    return x % m


def crt_pair(a1: int, m1: int, a2: int, m2: int) -> tuple[int, int]:
    """Solve x ≡ a1 (mod m1), x ≡ a2 (mod m2). Returns (x, m1*m2/gcd)."""
    g, s, _ = egcd(m1, m2)
    if (a1 - a2) % g != 0:
        raise ValueError(f"CRT incongruence: {a1} mod {m1} vs {a2} mod {m2}")
    lcm = m1 // g * m2
    x = (a1 - s * (m1 // g) * ((a1 - a2) // g)) % lcm
    return x, lcm


def crt_list(residues: list[int], moduli: list[int]) -> tuple[int, int]:
    x, m = residues[0] % moduli[0], moduli[0]
    for a, mi in zip(residues[1:], moduli[1:]):
        x, m = crt_pair(x, m, a % mi, mi)
    return x, m


def rational_reconstruction(h: int, m: int, N: int | None = None) -> Q | None:
    """Reconstruct a/b with |a|,|b| ≤ N and a/b ≡ h (mod m), gcd(a,b)=1.

    Uses the extended Euclidean algorithm (Wang-style). Implemented here;
    does not call SymPy.
    """
    if N is None:
        N = int(math.isqrt(m // 2))
    h = h % m
    r0, r1 = m, h
    s0, s1 = 0, 1
    while r1 != 0 and r1 > N:
        q = r0 // r1
        r0, r1 = r1, r0 - q * r1
        s0, s1 = s1, s0 - q * s1
    if abs(s1) > N or s1 == 0:
        return None
    # r1 / s1 ≡ h (mod m)
    a, b = r1, s1
    if b < 0:
        a, b = -a, -b
    g = math.gcd(a, b)
    a //= g
    b //= g
    if abs(a) > N or abs(b) > N:
        return None
    return Q(a, b)


def reduce_Q_mod(x: Q, p: int) -> int:
    return (int(x.numerator) % p * inv_mod(int(x.denominator) % p, p)) % p


def load_module_from_path(name: str, path: Path):
    import importlib.util

    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def load_reconstructor():
    return load_module_from_path(
        "p25r_recon", ROOT / "tmp" / "degree13_opt" / "reconstruct_large_prime.py"
    )


def load_seeds() -> list[dict]:
    path = ROOT / "tmp" / "degree25_structural_probe" / "seeds.json"
    return json.loads(path.read_text())


def batch_seed_evaluations(module, seeds, points: np.ndarray, prime: int) -> np.ndarray:
    """(5 * n_points) x n_seeds evaluation matrix over F_p."""
    G = module.GROUP % prime
    inv = module.INVERSES % prime
    transformed = np.einsum("gij,pj->pgi", G, points) % prime
    power_cache: dict[tuple[int, int], np.ndarray] = {}

    def powers(coordinate: int, exponent: int) -> np.ndarray:
        key = (coordinate, exponent)
        if key not in power_cache:
            value = np.ones(transformed.shape[:2], dtype=np.int64)
            for _ in range(exponent):
                value = value * transformed[:, :, coordinate] % prime
            power_cache[key] = value
        return power_cache[key]

    columns = []
    for seed in seeds:
        values = np.ones(transformed.shape[:2], dtype=np.int64)
        for coordinate, exponent in enumerate(seed.exponents):
            if exponent:
                values = values * powers(coordinate, exponent) % prime
        evaluated = values @ inv[:, :, seed.output] % prime
        columns.append(evaluated.reshape(-1))
    return np.column_stack(columns).astype(np.int64)


def involution_eigenspaces(module, prime: int):
    I = np.eye(5, dtype=np.int64)
    for g in module.GROUP:
        g = np.asarray(g, dtype=np.int64) % prime
        if np.array_equal((g @ g) % prime, I) and not np.array_equal(g, I):
            plus = nullspace_rows((g - I) % prime, prime)
            minus = nullspace_rows((g + I) % prime, prime)
            assert plus.shape == (3, 5) and minus.shape == (2, 5)
            return g, plus, minus
    raise RuntimeError("no involution found")


def arrangement_kernel(module, seeds, plus: np.ndarray, prime: int) -> np.ndarray:
    """Restriction kernel to one plus-plane; expected dim 59."""
    pts = []
    for a in range(DEGREE + 1):
        for b in range(DEGREE + 1 - a):
            pts.append((plus[0] + a * plus[1] + b * plus[2]) % prime)
    # Unisolvent triangular count for degree 25 on A^2 is binom(27,2)=351.
    points = np.asarray(pts[:351], dtype=np.int64)
    R = batch_seed_evaluations(module, seeds, points, prime)
    return nullspace_rows(R, prime)


def residual_restriction_map(
    module, seeds, ker: np.ndarray, plus: np.ndarray, minus: np.ndarray, prime: int
) -> np.ndarray:
    """Map ker -> F_p^{52}: minus-components of values on L_t = P(E_-).

    Returns matrix of shape (ker_dim, 52).
    """
    line = np.array(
        [(minus[0] + t * minus[1]) % prime for t in range(DEGREE + 1)],
        dtype=np.int64,
    )
    RL = batch_seed_evaluations(module, seeds, line, prime).reshape(
        DEGREE + 1, 5, len(seeds)
    )
    VK = np.einsum("pws,ks->pwk", RL, ker) % prime
    adapted = np.vstack([plus, minus]) % prime
    ainv = invert_mod(adapted, prime)
    coords = np.einsum("ij,pjk->pik", ainv, VK) % prime
    # minus target components: indices 3,4
    based = coords[:, 3:, :].transpose(2, 0, 1).reshape(ker.shape[0], -1)
    assert based.shape[1] == FREE_AD_DIM
    return based


def image_basis_from_map(map_rows: np.ndarray, prime: int) -> np.ndarray:
    """Given map as (domain_dim, codomain_dim) rows, return codomain x rank image basis."""
    _, piv = rref(map_rows.T, prime)
    if not piv:
        return np.zeros((map_rows.shape[1], 0), dtype=np.int64)
    return np.stack([map_rows.T[:, j] % prime for j in piv], axis=1)


def rss_mib() -> float:
    import resource

    value = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    # macOS: bytes; Linux: KiB
    if sys.platform == "darwin":
        return value / (1024 * 1024)
    return value / 1024
