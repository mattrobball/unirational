#!/usr/bin/env python3
"""Shared helpers for P25X.0 / P25X.1 (degree-25 exact landing track).

Independent of produce_*.py / verify_*.py. Absolute-path safe.
Implements CRT and rational reconstruction explicitly (no SymPy ratrecon).
"""

from __future__ import annotations

import hashlib
import json
import math
import sys
from fractions import Fraction as Q
from pathlib import Path
from typing import Any

import numpy as np

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
TMP = ROOT / "tmp" / "v2_P25"
TMP.mkdir(parents=True, exist_ok=True)

DEGREE = 25
MOLIEN_DIM = 189
ARRANGEMENT_DIM = 59
STRICT_DIM = 43
Q_DIM = 37
K_DIM = 6
BORDER_RANK = 28
RESIDUAL_RANK = 7
FREE_AD_DIM = (DEGREE + 1) * 2  # 52
CUBIC_MONOM_DIM = math.comb(STRICT_DIM + 2, 3)  # 14190

# Good split primes p ≡ 1 (mod 11) with sealed primitive 11th roots.
GOOD_PRIMES: list[tuple[int, int]] = [
    (67, 64),
    (89, 78),
    (199, 61),
    (331, 270),
    (353, 58),
]
# Holdouts for landing rowspace (p > DEGREE so evaluation of deg-75 forms is faithful).
LANDING_PRIMES: list[tuple[int, int]] = [
    (89, 78),
    (199, 61),
    (331, 270),
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


def free_rank_jet(order: int) -> int:
    tdim = 3 if order % 2 == 0 else 2
    return (order + 1) * tdim


def free_jet_total() -> int:
    return sum(free_rank_jet(r) for r in range(1, DEGREE + 1))


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


def same_row_space(left: np.ndarray, right: np.ndarray, prime: int) -> bool:
    left = np.asarray(left, dtype=np.int64) % prime
    right = np.asarray(right, dtype=np.int64) % prime
    if left.size == 0 and right.size == 0:
        return True
    if left.size == 0 or right.size == 0:
        return False
    rl, rr = rank_mod(left, prime), rank_mod(right, prime)
    return rl == rr == rank_mod(np.vstack([left, right]), prime)


# ---------------------------------------------------------------------------
# Explicit CRT / rational reconstruction (no SymPy private helpers)
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
    """Wang-style extended Euclidean reconstruction. No SymPy."""
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
        "p25x_recon", ROOT / "tmp" / "degree13_opt" / "reconstruct_large_prime.py"
    )


def load_seeds() -> list[dict]:
    path = ROOT / "tmp" / "degree25_structural_probe" / "seeds.json"
    return json.loads(path.read_text())


def batch_seed_evaluations(module, seeds, points: np.ndarray, prime: int) -> np.ndarray:
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


def coefficient_weights(degree: int, coefficient: int, prime: int) -> np.ndarray:
    vandermonde = np.array(
        [
            [pow(value, exponent, prime) for exponent in range(degree + 1)]
            for value in range(degree + 1)
        ],
        dtype=np.int64,
    )
    return invert_mod(vandermonde, prime)[coefficient]


def joint_basis(module, prime: int) -> tuple[np.ndarray, np.ndarray]:
    """D12-adapted joint eigenbasis of a commuting involution pair (exact circuit)."""
    identity = np.eye(5, dtype=np.int64)
    first = module.A % prime
    candidates = []
    for matrix in module.GROUP:
        matrix = np.asarray(matrix, dtype=np.int64) % prime
        if np.array_equal(matrix, identity):
            continue
        if (
            np.array_equal(matrix @ matrix % prime, identity)
            and np.array_equal(matrix @ first % prime, first @ matrix % prime)
            and not np.array_equal(matrix, first)
        ):
            candidates.append(matrix)
    assert len(candidates) == 6, f"expected 6 commuting involutions, got {len(candidates)}"
    second = min(candidates, key=lambda m: bytes((m % prime).astype(np.uint8).flat))

    def eigenspace(s1: int, s2: int):
        eqs = np.vstack(
            (first - s1 * identity, second - s2 * identity)
        ) % prime
        return list(nullspace_rows(eqs, prime))

    spaces = [
        eigenspace(1, 1),
        eigenspace(1, -1),
        eigenspace(-1, 1),
        eigenspace(-1, -1),
    ]
    dims = [len(s) for s in spaces]
    assert dims == [2, 1, 1, 1], dims
    basis = np.column_stack([v for sp in spaces for v in sp]).astype(np.int64) % prime
    return basis, invert_mod(basis, prime)


def arrangement_kernel(module, seeds, plus: np.ndarray, prime: int) -> np.ndarray:
    pts = []
    for a in range(DEGREE + 1):
        for b in range(DEGREE + 1 - a):
            pts.append((plus[0] + a * plus[1] + b * plus[2]) % prime)
    points = np.asarray(pts[:351], dtype=np.int64)
    R = batch_seed_evaluations(module, seeds, points, prime)
    ker = nullspace_rows(R, prime)
    assert ker.shape == (ARRANGEMENT_DIM, MOLIEN_DIM), ker.shape
    return ker


def strict_from_arrangement(
    module, seeds, ker: np.ndarray, prime: int
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Return (strict_43x59, strict_reynolds_43x189, order2_map).

    Strict space = kernel of the common-line order-2 map on the arrangement
    kernel (dimension 43). Matches tmp/degree25_structural_probe.
    """
    basis, basis_inverse = joint_basis(module, prime)
    weights2 = coefficient_weights(DEGREE, 2, prime)
    components = []
    for direction, target_component in (
        ((0, 1, 1), 2),
        ((1, 0, 1), 3),
        ((1, 1, 0), 4),
    ):
        points = []
        for t in range(DEGREE - 1):
            for scalar in range(DEGREE + 1):
                z = np.array(
                    [1, t] + [scalar * e % prime for e in direction],
                    dtype=np.int64,
                )
                points.append(basis @ z % prime)
        evaluated = batch_seed_evaluations(
            module, seeds, np.asarray(points, dtype=np.int64), prime
        )
        values = (evaluated @ ker.T % prime).reshape(
            DEGREE - 1, DEGREE + 1, 5, ARRANGEMENT_DIM
        )
        values = np.einsum("ab,tsbk->tsak", basis_inverse, values) % prime
        second = np.einsum("s,tsak->tak", weights2, values) % prime
        components.append(second[:, target_component, :])
    order2_map = np.vstack(components)
    assert rank_mod(order2_map, prime) == 16, rank_mod(order2_map, prime)
    strict = nullspace_rows(order2_map, prime)
    assert strict.shape == (STRICT_DIM, ARRANGEMENT_DIM), strict.shape
    strict_reynolds = (strict @ ker) % prime
    return strict, strict_reynolds, order2_map


def monic_basis_reynolds(strict_reynolds: np.ndarray, prime: int) -> tuple[np.ndarray, list[int]]:
    """Monic RREF basis of V_25 in original Reynolds coordinates (43 x 189)."""
    reduced, pivots = rref(strict_reynolds, prime)
    basis = reduced[: len(pivots)] % prime
    assert basis.shape == (STRICT_DIM, MOLIEN_DIM)
    assert len(pivots) == STRICT_DIM
    return basis, pivots


def residual_restriction_map(
    module, seeds, ker: np.ndarray, plus: np.ndarray, minus: np.ndarray, prime: int
) -> np.ndarray:
    """Map arrangement ker -> F_p^{52}: minus-components on L_t = P(E_-)."""
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
    based = coords[:, 3:, :].transpose(2, 0, 1).reshape(ker.shape[0], -1)
    assert based.shape[1] == FREE_AD_DIM
    return based


def residual_on_strict(
    based_arr: np.ndarray, strict: np.ndarray, prime: int
) -> np.ndarray:
    """52 x 43 residual restriction on V_25 (strict coordinates)."""
    # c_arr = c_strict @ strict  => residual = based_arr.T @ strict.T
    return (based_arr.T @ strict.T) % prime


def qk_frame(strict_reynolds: np.ndarray, module, seeds, plus, minus, ker, strict, prime: int):
    """Build Q(37)|K(6) frame on strict space via common-order-3 kernel."""
    # Sample third-order common-line values on strict (structural probe style).
    basis, basis_inverse = joint_basis(module, prime)
    weights3 = coefficient_weights(DEGREE, 3, prime)
    strict_reynolds = (strict @ ker) % prime
    rng = np.random.default_rng(202607282525 + prime)
    blocks = []
    for _ in range(4):
        count = 40
        points = []
        for _i in range(count):
            t = int(rng.integers(0, prime))
            y = tuple(int(v) for v in rng.integers(0, prime, size=3))
            while y == (0, 0, 0):
                y = tuple(int(v) for v in rng.integers(0, prime, size=3))
            for scalar in range(DEGREE + 1):
                z = np.array(
                    [1, t] + [scalar * e % prime for e in y], dtype=np.int64
                )
                points.append(basis @ z % prime)
        evaluated = batch_seed_evaluations(
            module, seeds, np.asarray(points, dtype=np.int64), prime
        )
        values = (evaluated @ strict_reynolds.T % prime).reshape(
            count, DEGREE + 1, 5, STRICT_DIM
        )
        values = np.einsum("ab,psbk->psak", basis_inverse, values) % prime
        third = np.einsum("s,psak->pak", weights3, values) % prime
        blocks.append(third.reshape(-1, STRICT_DIM))
    linear_map = np.vstack(blocks)
    rk = rank_mod(linear_map, prime)
    # Expected: rank 37, kernel dim 6 = K
    K_rows = nullspace_rows(linear_map, prime)
    if K_rows.shape[0] != K_DIM:
        # Fall back to sealed filtration at p=67 pattern: use rref kernel of target rank
        # Take a monic complement of a rank-37 row space approximation via rref
        red, piv = rref(linear_map, prime)
        # kernel dim = 43 - len(piv)
        K_rows = nullspace_rows(linear_map, prime)
    assert K_rows.shape[0] == K_DIM, (
        f"K dim {K_rows.shape[0]} (linear rank {rk}) at p={prime}"
    )
    # Q = complement: monic free columns of K
    _, kpiv = rref(K_rows, prime)
    free = [c for c in range(STRICT_DIM) if c not in kpiv]
    assert len(free) == Q_DIM
    Q_rows = np.eye(STRICT_DIM, dtype=np.int64)[free]
    frame = np.vstack([Q_rows, K_rows]) % prime
    assert rank_mod(frame, prime) == STRICT_DIM
    return Q_rows, K_rows, frame, rk


def rho_block_r(
    module, seeds, basis43: np.ndarray, plus: np.ndarray, minus: np.ndarray,
    r: int, prime: int,
) -> np.ndarray:
    """Restriction rho_r: V_25 -> free jet of order r along L_t (free chart).

    Returns matrix of shape (free_rank_jet(r), 43).
    For odd r target is E_minus (2); even r target is E_plus (3).
    Free chart: evaluate Taylor jet of adapted coordinates on the minus line
    by sampling r+1 points and extracting the degree-r binary form coeffs
    for the target components via Vandermonde.
    """
    tdim = 3 if r % 2 == 0 else 2
    free = (r + 1) * tdim
    # Sample r+1 points on L_t and convert values to jet coefficients
    line = np.array(
        [(minus[0] + t * minus[1]) % prime for t in range(r + 1)],
        dtype=np.int64,
    )
    RL = batch_seed_evaluations(module, seeds, line, prime).reshape(
        r + 1, 5, MOLIEN_DIM
    )
    # values of basis: (r+1, 5, 43)
    VB = np.einsum("psw,bw->psb", RL, basis43) % prime
    adapted = np.vstack([plus, minus]) % prime
    ainv = invert_mod(adapted, prime)
    coords = np.einsum("ij,psb->psb", ainv, VB) % prime  # (r+1, 5, 43)
    if r % 2 == 0:
        # even: E_plus components 0,1,2
        target = coords[:, 0:3, :]  # (r+1, 3, 43)
    else:
        target = coords[:, 3:5, :]  # (r+1, 2, 43)
    # Invert Vandermonde on sample parameter t=0..r to get poly coeffs
    V = np.array(
        [[pow(t, e, prime) for e in range(r + 1)] for t in range(r + 1)],
        dtype=np.int64,
    )
    Vinv = invert_mod(V, prime)
    # coeffs[e, comp, b] = sum_t Vinv[e,t] * target[t, comp, b]
    coeffs = np.einsum("et,tcb->ecb", Vinv, target) % prime
    return coeffs.reshape(free, STRICT_DIM)


def rho_le_25(
    module, seeds, basis43: np.ndarray, plus: np.ndarray, minus: np.ndarray, prime: int
) -> np.ndarray:
    """Materialize rho_≤25 : V_25 -> ⊕_{r=1}^{25} J_r  (868 x 43)."""
    blocks = [
        rho_block_r(module, seeds, basis43, plus, minus, r, prime)
        for r in range(1, DEGREE + 1)
    ]
    mat = np.vstack(blocks)
    assert mat.shape == (free_jet_total(), STRICT_DIM), mat.shape
    return mat


def weak_compositions(total: int, slots: int) -> list[tuple[int, ...]]:
    result: list[tuple[int, ...]] = []

    def visit(prefix: tuple[int, ...], remaining: int, left: int) -> None:
        if left == 1:
            result.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, left - 1)

    visit((), total, slots)
    return result


_CUBIC_MONOMS: list[tuple[int, ...]] | None = None


def cubic_monomials() -> list[tuple[int, ...]]:
    global _CUBIC_MONOMS
    if _CUBIC_MONOMS is None:
        _CUBIC_MONOMS = weak_compositions(3, STRICT_DIM)
        assert len(_CUBIC_MONOMS) == CUBIC_MONOM_DIM
    return _CUBIC_MONOMS


def fast_cubic_row(V: np.ndarray, prime: int) -> np.ndarray:
    """Cubic coefficient row of F(sum c_i V[i]) for V shape (43, 5)."""
    dim = V.shape[0]
    assert dim == STRICT_DIM and V.shape[1] == 5
    T = np.zeros((dim, dim, dim), dtype=np.int64)
    for i in range(5):
        vi = V[:, i].astype(np.int64) % prime
        vj = V[:, (i + 1) % 5].astype(np.int64) % prime
        T = (T + np.einsum("r,s,t->rst", vi, vi, vj)) % prime
    monoms = cubic_monomials()
    row = np.zeros(len(monoms), dtype=np.int64)
    from itertools import permutations

    for idx, exp in enumerate(monoms):
        idxs: list[int] = []
        for r, e in enumerate(exp):
            idxs.extend([r] * e)
        if len(idxs) != 3:
            continue
        acc = 0
        for perm in set(permutations(idxs)):
            acc += int(T[perm])
        row[idx] = acc % prime
    return row


def add_echelon_row(echelon: list, row: np.ndarray, prime: int) -> bool:
    """In-place F_p row echelon insert. Returns True if row increased rank."""
    row = (np.asarray(row, dtype=np.int64) % prime).copy()
    for pivot, erow in echelon:
        if row[pivot] % prime:
            row = (row - row[pivot] * erow) % prime
    pivots = np.flatnonzero(row)
    if not len(pivots):
        return False
    pivot = int(pivots[0])
    inv = pow(int(row[pivot]), -1, prime)
    row = (row * inv) % prime
    for i, (p, erow) in enumerate(echelon):
        if erow[pivot] % prime:
            echelon[i] = (p, (erow - erow[pivot] * row) % prime)
    echelon.append((pivot, row))
    echelon.sort(key=lambda item: item[0])
    return True


def rss_mib() -> float:
    import resource

    value = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    if sys.platform == "darwin":
        return value / (1024 * 1024)
    return value / 1024


def preflight_record(**kwargs) -> dict:
    base = {
        "ring": "F_p with p=1 mod 11 (split cyclotomic), exact model over K=Q(zeta_11)",
        "monomial_order": "weak compositions / grevlex-compatible index order",
        "memory_ceiling_GiB_exploratory": 8,
        "checkpoint_plan": "tmp/v2_P25/*.npz + certificates/degree25_exact/",
        "independent_verifier": "verify_p25x0.py / verify_p25x1.py (no producer import)",
    }
    base.update(kwargs)
    return base
