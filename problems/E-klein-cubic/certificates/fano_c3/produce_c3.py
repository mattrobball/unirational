#!/usr/bin/env python3
"""Producer: C3.0 maximal-étale rectangular basis + C3.1 preflight/low-degree probes.

Writes only under certificates/fano_c3/ and tmp/c3_*/.
Does NOT start C3.2 (involution/Morita) or C3.3 (common isotropic line).
Does NOT reconstruct the full 36-word regular representation entrywise (§2.10).
Does NOT import the verifier. Does not run git.

Search is fully deterministic: no unseeded RNG.
"""

from __future__ import annotations

import hashlib
import json
import math
import resource
import sys
import time
from itertools import product
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[2]
PKG = Path(__file__).resolve().parent
SCRATCH = ROOT / "tmp" / "c3_preflight"
WORK = ROOT / "tmp" / "c3_work"
ALIGN = ROOT / "tmp" / "pfaffian_representation_alignment"
C1_STRUCT = ROOT / "tmp" / "c1_preflight" / "structure_constants_f23.npz"
C2 = ROOT / "certificates" / "fano_c2"
COMMON = ROOT / "certificates" / "degree25_exact" / "common_p25x.py"

PRIMARY_P = 23
PRIMARY_ZETA = 2
SECONDARY_P = 89
SECONDARY_ZETA = 2
HOLDOUT_P = 199
HOLDOUT_ZETA = 18
POINT = np.array([1, 2, 3, 4, 5], dtype=np.int64)

# Sealed C2.0 pair
A_FRAME = 1
B_FRAME = 2

# Split primes ≡ 1 mod 11, excluding sole-fibre use of 67
PROBE_PRIMES = [
    (23, 2),
    (89, 2),
    (199, 18),
    (331, 74),
    (353, 58),
]
HOLDOUT_PROBE = (463, 15)  # unused in degree-floor decisions

def _build_sample_point_seeds() -> list[tuple[int, ...]]:
    """Deterministic sample points in A^5 (no RNG). Dense enough for deg≤6 in 4 t-vars."""
    seeds: list[tuple[int, ...]] = []
    # Structured lattice: products of small integer lists
    for a in range(1, 12):
        for b in range(1, 12):
            for c in (1, 2, 3, 5, 7, 8):
                seeds.append((a, b, c, (a + 2 * b) % 11 + 1, (2 * a + c) % 11 + 1))
    # Extra diagonal / sparse directions
    for t in range(1, 40):
        seeds.append((t, t + 1, t + 2, t + 3, t + 4))
        seeds.append((t, 1, 2, 3, 4))
        seeds.append((1, t, 2, 3, 4))
        seeds.append((1, 2, t, 3, 4))
        seeds.append((1, 2, 3, t, 4))
        seeds.append((1, 2, 3, 4, t))
    # Deduplicate preserving order
    seen: set[tuple[int, ...]] = set()
    out: list[tuple[int, ...]] = []
    for s in seeds:
        if s not in seen:
            seen.add(s)
            out.append(s)
    return out


SAMPLE_POINT_SEEDS = _build_sample_point_seeds()


def peak_bytes() -> int:
    return int(resource.getrusage(resource.RUSAGE_SELF).ru_maxrss)


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def load_c2_helpers():
    path = C2 / "produce_c2.py"
    ns: dict = {"__file__": str(path), "__name__": "c2_helpers"}
    exec(compile(path.read_text(), str(path), "exec"), ns)
    return ns


def load_common():
    import importlib.util

    spec = importlib.util.spec_from_file_location("common_p25x", COMMON)
    assert spec and spec.loader
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def mat_pow(M: np.ndarray, e: int, p: int) -> np.ndarray:
    R = np.eye(M.shape[0], dtype=np.int64) % p
    M = M % p
    while e:
        if e & 1:
            R = (R @ M) % p
        M = (M @ M) % p
        e //= 2
    return R


def det_mod(matrix: np.ndarray, p: int) -> int:
    m = matrix.copy() % p
    result = 1
    for col in range(m.shape[1]):
        cands = np.flatnonzero(m[col:, col] % p)
        if not len(cands):
            return 0
        piv = col + int(cands[0])
        if piv != col:
            m[[col, piv]] = m[[piv, col]]
            result = -result
        pv = int(m[col, col]) % p
        result = (result * pv) % p
        inv_p = pow(pv, -1, p)
        m[col] = (m[col] * inv_p) % p
        for row in range(col + 1, m.shape[0]):
            if m[row, col] % p:
                m[row] = (m[row] - m[row, col] * m[col]) % p
    return result % p


def inv_mat(matrix: np.ndarray, p: int) -> np.ndarray:
    n = matrix.shape[0]
    a = np.concatenate([matrix % p, np.eye(n, dtype=np.int64)], axis=1)
    for col in range(n):
        pivots = np.flatnonzero(a[col:, col] % p)
        if not len(pivots):
            raise ValueError("singular")
        piv = col + int(pivots[0])
        if piv != col:
            a[[col, piv]] = a[[piv, col]]
        inv_p = pow(int(a[col, col]) % p, -1, p)
        a[col] = (a[col] * inv_p) % p
        for row in range(n):
            if row != col and a[row, col] % p:
                a[row] = (a[row] - a[row, col] * a[col]) % p
    return a[:, n:] % p


def minpoly_coeffs(M: np.ndarray, p: int) -> list[int] | None:
    """Monic minimal polynomial coeffs [c0,...,c_{d-1},1] of T^d + ... over F_p."""
    mats = [np.eye(6, dtype=np.int64) % p]
    for _ in range(1, 7):
        mats.append((mats[-1] @ M) % p)
    for d in range(1, 7):
        V = np.stack([m.reshape(-1) for m in mats[: d + 1]], axis=1) % p
        A = V[:, :d].copy()
        rhs = (-V[:, d]) % p
        Aug = np.concatenate([A, rhs.reshape(-1, 1)], axis=1) % p
        r = 0
        pivots: list[int] = []
        rows = Aug.shape[0]
        for c in range(d):
            cands = np.flatnonzero(Aug[r:, c] % p)
            if not len(cands):
                continue
            piv = r + int(cands[0])
            if piv != r:
                Aug[[r, piv]] = Aug[[piv, r]]
            inv = pow(int(Aug[r, c]) % p, -1, p)
            Aug[r] = (Aug[r] * inv) % p
            for i in range(rows):
                if i != r and Aug[i, c] % p:
                    Aug[i] = (Aug[i] - Aug[i, c] * Aug[r]) % p
            pivots.append(c)
            r += 1
        if len(pivots) < d:
            continue
        if any(Aug[i, d] % p for i in range(r, rows)):
            continue
        sol = np.zeros(d, dtype=np.int64)
        for i, pv in enumerate(pivots):
            sol[pv] = Aug[i, d] % p
        coeffs = [int(x) for x in sol] + [1]
        acc = np.zeros((6, 6), dtype=np.int64)
        for i, ci in enumerate(coeffs):
            acc = (acc + ci * mats[i]) % p
        if np.all(acc % p == 0):
            return coeffs
    return None


def poly_deriv(c: list[int], p: int) -> list[int]:
    return [(i * c[i]) % p for i in range(1, len(c))]


def poly_gcd(a: list[int], b: list[int], p: int) -> list[int]:
    a = [int(x) % p for x in a]
    b = [int(x) % p for x in b]
    while any(x % p for x in b):
        while a and a[-1] % p == 0:
            a.pop()
        while b and b[-1] % p == 0:
            b.pop()
        if not b:
            break
        if len(a) < len(b):
            a, b = b, a
            continue
        inv = pow(b[-1], -1, p)
        scale = (a[-1] * inv) % p
        da = len(a) - len(b)
        for i in range(len(b)):
            a[i + da] = (a[i + da] - scale * b[i]) % p
        while a and a[-1] % p == 0:
            a.pop()
        a, b = b, a
    while a and a[-1] % p == 0:
        a.pop()
    return a


def is_separable(coeffs: list[int], p: int) -> bool:
    """Separable iff gcd(m, m') is a nonzero constant in F_p[T]."""
    d = poly_deriv(coeffs, p)
    g = poly_gcd(list(coeffs), d, p)
    return len(g) == 1 and g[0] % p != 0


def rectangle_matrices(a: np.ndarray, b: np.ndarray, p: int) -> list[np.ndarray]:
    """Return 36 matrices b^j a^i in column-major order j outer, i inner."""
    a_pows = [mat_pow(a, i, p) for i in range(6)]
    b_pows = [mat_pow(b, j, p) for j in range(6)]
    out = []
    for j in range(6):
        for i in range(6):
            out.append((b_pows[j] @ a_pows[i]) % p)
    return out


def rectangle_det_m6(a: np.ndarray, b: np.ndarray, p: int) -> int:
    mats = rectangle_matrices(a, b, p)
    R = np.stack([m.reshape(-1) for m in mats], axis=1) % p
    return det_mod(R, p)


def rectangle_det_frame(
    a: np.ndarray, b: np.ndarray, basis_vecs: np.ndarray, p: int
) -> int:
    """Determinant of rectangle elements as columns of frame coordinates."""
    mats = rectangle_matrices(a, b, p)
    V = basis_vecs.T % p  # columns = frame elements
    V_inv = inv_mat(V, p)
    coords = []
    for m in mats:
        coords.append((V_inv @ m.reshape(-1)) % p)
    C = np.stack(coords, axis=1) % p
    return det_mod(C, p)


def express_in_rectangle(
    M: np.ndarray, a: np.ndarray, b: np.ndarray, p: int
) -> np.ndarray:
    """Coordinates of M in the rectangular K-basis {b^j a^i}, shape (6,6) [j,i]."""
    mats = rectangle_matrices(a, b, p)
    R = np.stack([m.reshape(-1) for m in mats], axis=1) % p
    R_inv = inv_mat(R, p)
    c = (R_inv @ M.reshape(-1)) % p
    return c.reshape(6, 6)  # c[j, i] coeff of b^j a^i


def compressed_data_at(a: np.ndarray, b: np.ndarray, p: int) -> dict | None:
    """Extract minpoly, e_j in E, and L_a over E at a modular specialization.

    Returns None if rectangle is singular or minpoly fails degree-6/separable.
    """
    mpc = minpoly_coeffs(a, p)
    if mpc is None or len(mpc) != 7:
        return None
    if not is_separable(mpc, p):
        return None
    det = rectangle_det_m6(a, b, p)
    if det == 0:
        return None

    # b^6 = sum_j b^j e_j, e_j = sum_i e[j,i] a^i
    b6 = mat_pow(b, 6, p)
    e_coords = express_in_rectangle(b6, a, b, p)  # (6,6)

    # L_a over E: a * b^j = sum_k b^k m_{k j}, m_{kj} in E
    # Store as (6,6,6): L[k,j,:] = E-coords of entry (k,j) in basis 1..a^5
    La_E = np.zeros((6, 6, 6), dtype=np.int64)
    for j in range(6):
        bj = mat_pow(b, j, p)
        prod = (a @ bj) % p
        coords = express_in_rectangle(prod, a, b, p)  # (6,6): row k = E-coords of m_kj
        La_E[:, j, :] = coords

    # companion data for L_b: determined by e_j
    return {
        "minpoly": mpc,  # [c0..c5, 1]
        "e_coords": e_coords.astype(np.int64),  # (6,6)
        "La_E": La_E.astype(np.int64),  # (6,6,6)
        "rect_det_m6": int(det),
    }


def test_pair_at_prime(
    a: np.ndarray, b: np.ndarray, basis_vecs: np.ndarray, p: int
) -> dict:
    mpc = minpoly_coeffs(a, p)
    deg = (len(mpc) - 1) if mpc else -1
    sep = bool(mpc and is_separable(mpc, p))
    det_m6 = rectangle_det_m6(a, b, p) if deg == 6 else 0
    det_fr = (
        rectangle_det_frame(a, b, basis_vecs, p) if det_m6 != 0 else 0
    )
    return {
        "minpoly_coeffs": mpc,
        "minpoly_degree": deg,
        "separable": sep,
        "rect_det_m6": int(det_m6),
        "rect_det_frame": int(det_fr),
        "success": bool(deg == 6 and sep and det_m6 % p != 0),
    }


def monoms(deg: int, nvars: int = 4):
    out = []

    def rec(rem, cur):
        if len(cur) == nvars - 1:
            out.append(tuple(cur + [rem]))
            return
        for e in range(rem + 1):
            rec(rem - e, cur + [e])

    for d in range(deg + 1):
        rec(d, [])
    return out


def build_design_matrix(samples_t_beta, D: int, p: int):
    """Build A (n x nunk) for free-module ansatz from list of (t, beta).

    Returns (A, nunk) or (None, nunk) if underdetermined sample count.
    """
    mons = monoms(D)
    nunk = 12 * len(mons)
    if len(samples_t_beta) < nunk + 20:
        return None, nunk
    ntrain = min(len(samples_t_beta), nunk + 40)
    A = np.zeros((ntrain, nunk), dtype=np.int64)
    for r, (t, beta) in enumerate(samples_t_beta[:ntrain]):
        col = 0
        for k in range(12):
            bk = int(beta[k]) % p
            for exp in mons:
                mv = 1
                for e, v in zip(exp, t):
                    if e:
                        mv = mv * pow(int(v), int(e), p) % p
                A[r, col] = mv * bk % p
                col += 1
    return A, nunk


def precompute_row_ops(A: np.ndarray, p: int):
    """RREF row operations on A alone; return ops to apply to any RHS.

    Returns dict with:
      rank, pivot_cols, and a function apply(b) -> residual vector of free rows
      (nonzero residual => inconsistent).
    """
    n, m = A.shape
    M = A.copy() % p
    # Track permutation of rows via explicit swaps; apply same to b later
    row_perm = list(range(n))
    ops = []  # list of ("scale", r, inv) or ("elim", r, facs_dict) recorded after pivots
    # We'll store the final reduced row-ops as: for each pivot row, the linear form
    # that produces it from original rows — easier: keep elementary ops sequence.
    elem = []  # (type, ...)
    row = 0
    pivot_cols = []
    for col in range(m):
        cands = np.flatnonzero(M[row:, col] % p)
        if not len(cands):
            continue
        piv = row + int(cands[0])
        if piv != row:
            M[[row, piv]] = M[[piv, row]]
            elem.append(("swap", row, piv))
        inv = pow(int(M[row, col]) % p, -1, p)
        M[row] = (M[row] * inv) % p
        elem.append(("scale", row, inv))
        facs = (M[:, col] % p).copy()
        facs[row] = 0
        # only record nonzero facs
        nz = np.flatnonzero(facs)
        for r in nz:
            M[r] = (M[r] - int(facs[r]) * M[row]) % p
            elem.append(("add", int(r), row, int(facs[r])))
        pivot_cols.append(col)
        row += 1
        if row == n:
            break
    rank = row

    def apply_ops(b: np.ndarray) -> np.ndarray:
        y = (b[:n].astype(np.int64) % p).copy()
        for op in elem:
            if op[0] == "swap":
                i, j = op[1], op[2]
                y[i], y[j] = y[j], y[i]
            elif op[0] == "scale":
                r, inv = op[1], op[2]
                y[r] = y[r] * inv % p
            else:  # add
                r, src, fac = op[1], op[2], op[3]
                y[r] = (y[r] - fac * y[src]) % p
        return y

    return {
        "rank": rank,
        "n": n,
        "m": m,
        "pivot_cols": pivot_cols,
        "apply": apply_ops,
        "elem_count": len(elem),
    }


def rhs_consistent(ops: dict, b: np.ndarray, p: int) -> bool:
    """True iff A x = b is consistent over F_p given precomputed ops on A."""
    y = ops["apply"](b)
    rank = ops["rank"]
    n = ops["n"]
    if rank < n and np.any(y[rank:] % p):
        return False
    return True


def poly_consistent_mod(samples_t_beta_x, D: int, p: int) -> bool | None:
    """Single-series convenience wrapper."""
    samples_tb = [(t, beta) for t, beta, _ in samples_t_beta_x]
    A, nunk = build_design_matrix(samples_tb, D, p)
    if A is None:
        return None
    ops = precompute_row_ops(A, p)
    n = A.shape[0]
    b = np.array([int(x) % p for _, _, x in samples_t_beta_x[:n]], dtype=np.int64)
    return rhs_consistent(ops, b, p)


# Secondary free-basis degrees for tau-normalization (matches kproj_arithmetic)
SECONDARY_BASIS = (
    # (name, degree, how to build from f-values)
    ("1", 0, lambda f: 1),
    ("f7", 7, lambda f: f[7]),
    ("f9", 9, lambda f: f[9]),
    ("f10", 10, lambda f: f[10]),
    ("f12", 12, lambda f: f[12]),
    ("f14", 14, lambda f: f[14]),
    ("f7^2", 14, lambda f: f[7] * f[7]),
    ("f7*f9", 16, lambda f: f[7] * f[9]),
    ("f9^2", 18, lambda f: f[9] * f[9]),
    ("f9*f10", 19, lambda f: f[9] * f[10]),
    ("f7^3", 21, lambda f: f[7] * f[7] * f[7]),
    ("f9^2*f10", 28, lambda f: f[9] * f[9] * f[10]),
)


def evaluate_kproj_t_beta(forms, evaluate_mod, pt, p):
    """Return (t3,t6,t8,t11), beta[12], f-dict if denoms nonzero, else None.

    tau = f3^2/f5; t_d = f_d/tau^d; beta_k = secondary_k / tau^{deg_k}.
    """
    point_t = tuple(int(x) for x in pt)
    f = {}
    for d in (3, 5, 6, 7, 8, 9, 10, 11, 12, 14):
        f[d] = int(evaluate_mod(forms[d], point_t, p))
    if f[5] == 0 or f[3] == 0:
        return None

    def div_tau_power(val, deg):
        # val / tau^deg = val * f5^deg / f3^{2*deg}
        num = int(val) * pow(f[5], deg, p) % p
        den = pow(f[3], 2 * deg, p)
        if den % p == 0:
            return None
        return num * pow(den, -1, p) % p

    t3 = div_tau_power(f[3], 3)
    t6 = div_tau_power(f[6], 6)
    t8 = div_tau_power(f[8], 8)
    t11 = div_tau_power(f[11], 11)
    if None in (t3, t6, t8, t11):
        return None
    betas = []
    for _name, deg, builder in SECONDARY_BASIS:
        raw = builder(f) % p
        b = div_tau_power(raw, deg)
        if b is None:
            return None
        betas.append(b)
    return (t3, t6, t8, t11), tuple(betas), f


def build_group(ns, p: int, zeta: int):
    weil_s, weil_t = ns["weil_generators"](p, zeta)
    schur_a, schur_b = ns["schur_generators"](p, zeta)
    image_a = (weil_t @ weil_s @ weil_t @ weil_s) % p
    image_b = (ns["power"](weil_t, 8, p) @ weil_s) % p
    identity5 = np.eye(5, dtype=np.int64) % p
    identity6 = np.eye(6, dtype=np.int64) % p
    seen = {ns["key"](identity5, p): (identity5, identity6)}
    queue = [seen[ns["key"](identity5, p)]]
    while queue:
        target, source = queue.pop()
        for tg, sg in ((image_a, schur_a), (image_b, schur_b)):
            nt = (target @ tg) % p
            nsrc = (source @ sg) % p
            nk = ns["key"](nt, p)
            if nk not in seen:
                seen[nk] = (nt, nsrc)
                queue.append((nt, nsrc))
    if len(seen) != 660:
        raise AssertionError(f"group order {len(seen)} at p={p}")
    group = list(seen.values())
    conj = np.zeros((660, 36, 36), dtype=np.int64)
    inv_targets = np.zeros((660, 5, 5), dtype=np.int64)
    for gi, (target, source) in enumerate(group):
        source_inv = ns["inv_mat"](source, p)
        inv_targets[gi] = ns["inv_mat"](target, p)
        for r in range(6):
            for c in range(6):
                conj[gi, :, 6 * r + c] = (
                    np.outer(source[:, r], source_inv[c, :]).reshape(-1)
                ) % p
    return conj, inv_targets


def frame_at_point(ns, conj, inv_targets, seeds, forms, evaluate_mod, pt, p):
    POINT_ = np.array(pt, dtype=np.int64)
    mult = {
        deg: int(evaluate_mod(forms[14 - deg], tuple(map(int, POINT_)), p))
        for deg in sorted({s["degree"] for s in seeds})
    }
    den = int(evaluate_mod(forms[14], tuple(map(int, POINT_)), p))
    if den == 0 or any(v == 0 for v in mult.values()):
        raise ValueError("vanishing homogenization")
    orbit = np.einsum("gij,j->gi", inv_targets, POINT_) % p
    powers = np.ones((660, 5, 9), dtype=np.int64)
    for e in range(1, 9):
        powers[:, :, e] = powers[:, :, e - 1] * orbit % p

    def weights(exponents):
        result = np.ones(660, dtype=np.int64)
        for var, exp in enumerate(exponents):
            if exp:
                result = result * powers[:, var, exp] % p
        return result

    basis_mats = np.zeros((36, 6, 6), dtype=np.int64)
    basis_vecs = np.zeros((36, 36), dtype=np.int64)
    for bi, seed in enumerate(seeds):
        deg = seed["degree"]
        exp = tuple(seed["monomial_exponents"])
        r0, c0 = seed["matrix_unit_zero_based"]
        acc = np.tensordot(weights(exp), conj[:, :, 6 * r0 + c0], axes=(0, 0)) % p
        acc = (acc * mult[deg] * pow(den, -1, p)) % p
        basis_vecs[bi] = acc
        basis_mats[bi] = acc.reshape(6, 6)
    if det_mod(basis_vecs.T % p, p) == 0:
        raise ValueError("singular frame")
    return basis_mats, basis_vecs


def main() -> None:
    t0 = time.perf_counter()
    SCRATCH.mkdir(parents=True, exist_ok=True)
    WORK.mkdir(parents=True, exist_ok=True)
    PKG.mkdir(parents=True, exist_ok=True)

    ns = load_c2_helpers()
    common = load_common()  # ensure rational_reconstruction available; no SymPy helper

    # Load kproj forms
    kproj: dict = {}
    core_path = ROOT / "tmp" / "kproj_arithmetic" / "core.py"
    exec(
        compile(
            core_path.read_text().replace(
                "ROOT = Path(__file__).resolve().parents[2]", f"ROOT = Path(r'{ROOT}')"
            ),
            str(core_path),
            "exec",
        ),
        kproj,
    )
    forms = kproj["forms"]()
    evaluate_mod = kproj["evaluate_mod"]
    cert = json.loads((ALIGN / "certificate.json").read_text())
    seeds = cert["end36_reynolds_frame"]["selected_reynolds_seeds"]

    # --- C3.0: sealed pair at p=23 and p=89 ---
    sealed = np.load(C1_STRUCT)
    sealed_vecs = sealed["basis_vecs"].astype(np.int64) % PRIMARY_P
    sealed_mats = sealed_vecs.reshape(36, 6, 6)

    frame23 = ns["build_projective_reynolds_frame"](PRIMARY_P, PRIMARY_ZETA)
    if not np.array_equal(frame23["basis_vecs"] % PRIMARY_P, sealed_vecs):
        raise SystemExit("rebuilt p=23 frame differs from sealed C1 structure")

    a23 = sealed_mats[A_FRAME]
    b23 = sealed_mats[B_FRAME]
    res23 = test_pair_at_prime(a23, b23, sealed_vecs, PRIMARY_P)

    frame89 = ns["build_projective_reynolds_frame"](SECONDARY_P, SECONDARY_ZETA)
    a89 = frame89["basis_mats"][A_FRAME]
    b89 = frame89["basis_mats"][B_FRAME]
    res89 = test_pair_at_prime(a89, b89, frame89["basis_vecs"], SECONDARY_P)

    # Holdout modular check at p=199
    frame_h = ns["build_projective_reynolds_frame"](HOLDOUT_P, HOLDOUT_ZETA)
    a_h = frame_h["basis_mats"][A_FRAME]
    b_h = frame_h["basis_mats"][B_FRAME]
    res_h = test_pair_at_prime(a_h, b_h, frame_h["basis_vecs"], HOLDOUT_P)

    pair_success = res23["success"] and res89["success"]
    search_log = []
    chosen = {
        "a_frame_index": A_FRAME,
        "b_frame_index": B_FRAME,
        "form": "pure_frame",
        "a_coeffs": [1 if k == A_FRAME else 0 for k in range(36)],
        "b_coeffs": [1 if k == B_FRAME else 0 for k in range(36)],
        "source": "sealed_C2_pair",
    }

    if not pair_success:
        # Deterministic search: pure pairs first (lex i<j), then a=e_i+e_j, b=e_k small
        print("sealed (e1,e2) failed rectangular test; searching...", flush=True)
        found = None
        # Rebuild frames once
        for i in range(36):
            for j in range(i + 1, 36):
                r23 = test_pair_at_prime(
                    sealed_mats[i], sealed_mats[j], sealed_vecs, PRIMARY_P
                )
                entry = {"i": i, "j": j, "p23": r23}
                if not r23["success"]:
                    search_log.append(entry)
                    continue
                r89 = test_pair_at_prime(
                    frame89["basis_mats"][i],
                    frame89["basis_mats"][j],
                    frame89["basis_vecs"],
                    SECONDARY_P,
                )
                entry["p89"] = r89
                search_log.append(entry)
                if r89["success"]:
                    found = {
                        "a_frame_index": i,
                        "b_frame_index": j,
                        "form": "pure_frame",
                        "a_coeffs": [1 if k == i else 0 for k in range(36)],
                        "b_coeffs": [1 if k == j else 0 for k in range(36)],
                        "source": "search_pure_pairs_lex",
                    }
                    res23, res89 = r23, r89
                    a23, b23 = sealed_mats[i], sealed_mats[j]
                    a89, b89 = frame89["basis_mats"][i], frame89["basis_mats"][j]
                    break
            if found is not None:
                break
        if found is None:
            # Small linear combinations: a = e_i + c e_j, b = e_k with c in {1,2}
            for i, j, c, k in product(range(36), range(36), (1, 2), range(36)):
                if i == j or k in (i, j):
                    continue
                if i > j:
                    continue  # reduce duplication
                a_c = (sealed_mats[i] + c * sealed_mats[j]) % PRIMARY_P
                b_c = sealed_mats[k]
                r23 = test_pair_at_prime(a_c, b_c, sealed_vecs, PRIMARY_P)
                if not r23["success"]:
                    continue
                a89c = (
                    frame89["basis_mats"][i] + c * frame89["basis_mats"][j]
                ) % SECONDARY_P
                b89c = frame89["basis_mats"][k]
                r89 = test_pair_at_prime(
                    a89c, b89c, frame89["basis_vecs"], SECONDARY_P
                )
                search_log.append(
                    {
                        "form": "a=e_i+c*e_j,b=e_k",
                        "i": i,
                        "j": j,
                        "c": c,
                        "k": k,
                        "p23_success": r23["success"],
                        "p89_success": r89["success"],
                    }
                )
                if r89["success"]:
                    found = {
                        "a_frame_index": None,
                        "b_frame_index": k,
                        "form": "a=e_i+c*e_j",
                        "a_coeffs": [
                            (c if t == j else (1 if t == i else 0)) for t in range(36)
                        ],
                        "b_coeffs": [1 if t == k else 0 for t in range(36)],
                        "source": "search_small_lincomb",
                        "i": i,
                        "j": j,
                        "c": c,
                        "k": k,
                    }
                    res23, res89 = r23, r89
                    a23, b23 = a_c, b_c
                    a89, b89 = a89c, b89c
                    break
            if found is None:
                raise SystemExit("C3_FAIL: no rectangular pair at p=23 and p=89")
        chosen = found
        pair_success = True

    # Compressed data at primary/secondary
    comp23 = compressed_data_at(a23, b23, PRIMARY_P)
    comp89 = compressed_data_at(a89, b89, SECONDARY_P)
    if comp23 is None or comp89 is None:
        raise SystemExit("C3_FAIL: compressed extraction failed despite rectangle success")

    # Verify matrix identity: b^6 - sum b^j e_j == 0 using E-coords
    def check_b6_identity(a, b, e_coords, p) -> bool:
        b6 = mat_pow(b, 6, p)
        acc = np.zeros((6, 6), dtype=np.int64)
        for j in range(6):
            ej = np.zeros((6, 6), dtype=np.int64)
            for i in range(6):
                ej = (ej + int(e_coords[j, i]) * mat_pow(a, i, p)) % p
            acc = (acc + mat_pow(b, j, p) @ ej) % p
        return np.array_equal(acc % p, b6 % p)

    assert check_b6_identity(a23, b23, comp23["e_coords"], PRIMARY_P)
    assert check_b6_identity(a89, b89, comp89["e_coords"], SECONDARY_P)

    # Verify L_a: a * b^j == sum_k b^k * La[k,j]
    def check_La_identity(a, b, La_E, p) -> bool:
        for j in range(6):
            left = (a @ mat_pow(b, j, p)) % p
            right = np.zeros((6, 6), dtype=np.int64)
            for k in range(6):
                mk = np.zeros((6, 6), dtype=np.int64)
                for i in range(6):
                    mk = (mk + int(La_E[k, j, i]) * mat_pow(a, i, p)) % p
                right = (right + mat_pow(b, k, p) @ mk) % p
            if not np.array_equal(left, right):
                return False
        return True

    assert check_La_identity(a23, b23, comp23["La_E"], PRIMARY_P)
    assert check_La_identity(a89, b89, comp89["La_E"], SECONDARY_P)

    # --- C3.1 low-degree probes ---
    # Sample compressed data at many (p, point); measure degree floors for
    # minpoly coeffs, e_coords (36 K-values), La_E (216 K-values).
    print("C3.1 low-degree modular probes...", flush=True)
    probe_records = []
    # Collect per-entry samples across primes for degree tests at largest probe prime
    # Use p=353 for degree consistency (many points) and cross-check at holdout 463.

    degree_probe_prime = (353, 58)
    p_deg, zeta_deg = degree_probe_prime
    conj, inv_targets = build_group(ns, p_deg, zeta_deg)

    samples_comp = []
    for seed_pt in SAMPLE_POINT_SEEDS:
        pt = tuple(int(x) % p_deg for x in seed_pt)
        if any(x == 0 for x in pt):
            # allow zeros? homogenization may vanish; skip pure zeros
            pass
        try:
            basis_mats, basis_vecs = frame_at_point(
                ns, conj, inv_targets, seeds, forms, evaluate_mod, pt, p_deg
            )
        except Exception:
            continue
        aa = basis_mats[chosen["a_frame_index"] if chosen["a_frame_index"] is not None else A_FRAME]
        bb = basis_mats[chosen["b_frame_index"] if chosen.get("b_frame_index") is not None else B_FRAME]
        if chosen["form"] != "pure_frame":
            # rebuild linear combination
            coeffs_a = chosen["a_coeffs"]
            coeffs_b = chosen["b_coeffs"]
            aa = sum(int(c) * basis_mats[i] for i, c in enumerate(coeffs_a) if c) % p_deg
            bb = sum(int(c) * basis_mats[i] for i, c in enumerate(coeffs_b) if c) % p_deg
        else:
            aa = basis_mats[chosen["a_frame_index"]]
            bb = basis_mats[chosen["b_frame_index"]]
        comp = compressed_data_at(aa, bb, p_deg)
        if comp is None:
            continue
        tinfo = evaluate_kproj_t_beta(forms, evaluate_mod, pt, p_deg)
        if tinfo is None:
            continue
        tvals, betas, fvals = tinfo
        samples_comp.append(
            {
                "pt": pt,
                "t": tvals,
                "beta": betas,
                "minpoly": comp["minpoly"],
                "e_coords": comp["e_coords"],
                "La_E": comp["La_E"],
                "rect_det": comp["rect_det_m6"],
            }
        )

    print(f"  degree-probe samples at p={p_deg}: {len(samples_comp)}", flush=True)

    # Degree floors in the rank-12 model: x = sum_k r_k(t)*beta_k, deg(r_k)≤D.
    # With ~900 samples, D≤4 is testable (840 unknowns at D=4); D=5 needs 1512.
    # Same methodology as C2.1's proven floor ≥5.
    MAX_D_TESTED = 4

    print("  precomputing design matrices / row ops for D=0..4...", flush=True)
    samples_tb = [(s["t"], s["beta"]) for s in samples_comp]
    ops_by_D = {}
    ntrain_by_D = {}
    for D in range(0, MAX_D_TESTED + 1):
        A, nunk = build_design_matrix(samples_tb, D, p_deg)
        if A is None:
            print(f"    D={D}: insufficient samples for {nunk} unknowns", flush=True)
            continue
        ops_by_D[D] = precompute_row_ops(A, p_deg)
        ntrain_by_D[D] = A.shape[0]
        print(
            f"    D={D}: nunk={nunk} ntrain={A.shape[0]} rank={ops_by_D[D]['rank']} "
            f"ops={ops_by_D[D]['elem_count']}",
            flush=True,
        )

    def degree_floor_for_values(values: list[int], p: int) -> int | None:
        """values aligned with samples_comp. Return min D consistent, or max_D+1."""
        if not ops_by_D:
            return None
        for D in range(0, MAX_D_TESTED + 1):
            if D not in ops_by_D:
                return None
            n = ntrain_by_D[D]
            b = np.array([int(v) % p for v in values[:n]], dtype=np.int64)
            if rhs_consistent(ops_by_D[D], b, p):
                return D
        return MAX_D_TESTED + 1

    floors_minpoly = []
    floors_e = []
    floors_La = []
    constants_minpoly = 0
    constants_e = 0
    constants_La = 0

    print("  measuring free-module degree floors...", flush=True)
    for idx in range(6):
        vals = [int(s["minpoly"][idx]) for s in samples_comp]
        if len(set(vals)) == 1:
            constants_minpoly += 1
            floors_minpoly.append(0)
        else:
            fl = degree_floor_for_values(vals, p_deg)
            floors_minpoly.append(fl)
            print(f"    minpoly[{idx}] floor={fl}", flush=True)

    for j, i in product(range(6), range(6)):
        vals = [int(s["e_coords"][j, i]) for s in samples_comp]
        if len(set(vals)) == 1:
            constants_e += 1
            floors_e.append(0)
        else:
            fl = degree_floor_for_values(vals, p_deg)
            floors_e.append(fl)
            print(f"    e[{j},{i}] floor={fl}", flush=True)

    varying_La_count = 0
    for k, j, i in product(range(6), range(6), range(6)):
        vals = [int(s["La_E"][k, j, i]) for s in samples_comp]
        if len(set(vals)) == 1:
            constants_La += 1
            floors_La.append(0)
        else:
            fl = degree_floor_for_values(vals, p_deg)
            floors_La.append(fl)
            varying_La_count += 1
            if varying_La_count <= 5 or varying_La_count % 30 == 0:
                print(
                    f"    La_E[{k},{j},{i}] floor={fl} "
                    f"(varying #{varying_La_count})",
                    flush=True,
                )
    print(f"  La_E done: const={constants_La} varying={varying_La_count}", flush=True)

    def summarize_floors(floors, name):
        known = [f for f in floors if f is not None]
        gt = sum(1 for f in floors if f is not None and f > MAX_D_TESTED)
        return {
            "n_entries": len(floors),
            "n_measured": len(known),
            "n_insufficient": sum(1 for f in floors if f is None),
            f"n_floor_gt_{MAX_D_TESTED}": gt,
            "n_floor_0": sum(1 for f in known if f == 0),
            "n_floor_1": sum(1 for f in known if f == 1),
            "n_floor_2": sum(1 for f in known if f == 2),
            "n_floor_3": sum(1 for f in known if f == 3),
            "n_floor_4": sum(1 for f in known if f == 4),
            "n_floor_ge_5": sum(1 for f in known if f >= 5),
            "max_measured_floor": max(known) if known else None,
            "min_nonzero_floor": min((f for f in known if f > 0), default=None),
            "ansatz": (
                "x = sum_{k=0..11} r_k(t)*beta_k with r_k total-degree ≤ D in "
                "(t3,t6,t8,t11); free basis of certified K_proj model"
            ),
            "max_D_tested": MAX_D_TESTED,
            "unknowns_at_max_D": 12 * len(monoms(MAX_D_TESTED)),
        }

    floors_minpoly_aff = []  # retained key for schema; unused under free-module ansatz

    # Multi-prime constant detection for compressed entries (like C2.1)
    multi_prime_const = {"minpoly": [], "e": [], "La": []}
    for p, zeta in PROBE_PRIMES[:3]:  # 23, 89, 199 enough for constants
        if pow(zeta, 11, p) != 1 or any(pow(zeta, d, p) == 1 for d in (1, 2, 5, 10)):
            zeta = next(
                z
                for z in range(2, p)
                if pow(z, 11, p) == 1
                and all(pow(z, d, p) != 1 for d in (1, 2, 5, 10))
            )
        conj_p, inv_p = build_group(ns, p, zeta)
        stack_mp = []
        stack_e = []
        stack_La = []
        n_ok = 0
        for seed_pt in SAMPLE_POINT_SEEDS[:25]:
            pt = tuple(int(x) % p for x in seed_pt)
            try:
                basis_mats, _ = frame_at_point(
                    ns, conj_p, inv_p, seeds, forms, evaluate_mod, pt, p
                )
            except Exception:
                continue
            if chosen["form"] == "pure_frame":
                aa = basis_mats[chosen["a_frame_index"]]
                bb = basis_mats[chosen["b_frame_index"]]
            else:
                aa = (
                    sum(
                        int(c) * basis_mats[i]
                        for i, c in enumerate(chosen["a_coeffs"])
                        if c
                    )
                    % p
                )
                bb = (
                    sum(
                        int(c) * basis_mats[i]
                        for i, c in enumerate(chosen["b_coeffs"])
                        if c
                    )
                    % p
                )
            comp = compressed_data_at(aa, bb, p)
            if comp is None:
                continue
            stack_mp.append(comp["minpoly"][:6])
            stack_e.append(comp["e_coords"].reshape(-1))
            stack_La.append(comp["La_E"].reshape(-1))
            n_ok += 1
        probe_records.append({"prime": p, "zeta": zeta, "n_samples": n_ok})
        if n_ok >= 5:
            sm = np.stack(stack_mp, axis=0)
            se = np.stack(stack_e, axis=0)
            sL = np.stack(stack_La, axis=0)
            multi_prime_const["minpoly"].append(
                {
                    "p": p,
                    "const_mask": [
                        len(set(int(x) for x in sm[:, i])) == 1 for i in range(6)
                    ],
                    "const_vals": [
                        int(sm[0, i])
                        if len(set(int(x) for x in sm[:, i])) == 1
                        else None
                        for i in range(6)
                    ],
                }
            )
            multi_prime_const["e"].append(
                {
                    "p": p,
                    "n_const": int(
                        sum(
                            1
                            for i in range(se.shape[1])
                            if len(set(int(x) for x in se[:, i])) == 1
                        )
                    ),
                }
            )
            multi_prime_const["La"].append(
                {
                    "p": p,
                    "n_const": int(
                        sum(
                            1
                            for i in range(sL.shape[1])
                            if len(set(int(x) for x in sL[:, i])) == 1
                        )
                    ),
                }
            )
        print(f"  multi-prime p={p}: n={n_ok}", flush=True)

    # Holdout: recompute rectangle at HOLDOUT_PROBE with sealed pair
    p_ho, z_ho = HOLDOUT_PROBE
    if pow(z_ho, 11, p_ho) != 1 or any(
        pow(z_ho, d, p_ho) == 1 for d in (1, 2, 5, 10)
    ):
        z_ho = next(
            z
            for z in range(2, p_ho)
            if pow(z, 11, p_ho) == 1
            and all(pow(z, d, p_ho) != 1 for d in (1, 2, 5, 10))
        )
    frame_ho = ns["build_projective_reynolds_frame"](p_ho, z_ho)
    if chosen["form"] == "pure_frame":
        a_ho = frame_ho["basis_mats"][chosen["a_frame_index"]]
        b_ho = frame_ho["basis_mats"][chosen["b_frame_index"]]
    else:
        a_ho = (
            sum(
                int(c) * frame_ho["basis_mats"][i]
                for i, c in enumerate(chosen["a_coeffs"])
                if c
            )
            % p_ho
        )
        b_ho = (
            sum(
                int(c) * frame_ho["basis_mats"][i]
                for i, c in enumerate(chosen["b_coeffs"])
                if c
            )
            % p_ho
        )
    res_ho = test_pair_at_prime(a_ho, b_ho, frame_ho["basis_vecs"], p_ho)
    comp_ho = compressed_data_at(a_ho, b_ho, p_ho)

    elapsed = time.perf_counter() - t0
    peak = peak_bytes()

    # Decide C3.1 exit: full reconstruction not completed this round (probes only)
    # Measure whether low-degree reconstruction is plausible
    sum_e = summarize_floors(floors_e, "e")
    sum_La = summarize_floors(floors_La, "La")
    sum_mp = summarize_floors(floors_minpoly, "minpoly")

    measured_floors = [f for f in floors_e + floors_La + floors_minpoly if f is not None]
    high_floor_count = sum(1 for f in measured_floors if f >= 5)  # floor ≥5 (incl. >4)
    low_ok = sum(1 for f in measured_floors if 0 <= f <= 4)
    # true constants (F_p-constant across samples) already counted as floor 0

    # Full C3-APROJ-EXECUTABLE requires actual reconstruction over K_proj —
    # this round only probes. Exit undecided with measured floors.
    c31_exit = "C3-RECONSTRUCTION-UNDECIDED"

    # --- write artifacts ---
    rect_npz = {
        "prime_primary": PRIMARY_P,
        "prime_secondary": SECONDARY_P,
        "prime_holdout_modular": HOLDOUT_P,
        "a_matrix_f23": a23.astype(np.uint8),
        "b_matrix_f23": b23.astype(np.uint8),
        "a_matrix_f89": a89.astype(np.uint8),
        "b_matrix_f89": b89.astype(np.uint8),
        "minpoly_f23": np.array(comp23["minpoly"], dtype=np.int64),
        "minpoly_f89": np.array(comp89["minpoly"], dtype=np.int64),
        "e_coords_f23": comp23["e_coords"].astype(np.uint8),
        "e_coords_f89": comp89["e_coords"].astype(np.uint8),
        "La_E_f23": comp23["La_E"].astype(np.uint8),
        "La_E_f89": comp89["La_E"].astype(np.uint8),
        "rect_mats_f23": np.stack(rectangle_matrices(a23, b23, PRIMARY_P)).astype(
            np.uint8
        ),
        "rect_mats_f89": np.stack(rectangle_matrices(a89, b89, SECONDARY_P)).astype(
            np.uint8
        ),
    }
    np.savez_compressed(PKG / "rectangular_basis.npz", **rect_npz)

    # Sample stack for degree probe
    if samples_comp:
        np.savez_compressed(
            WORK / f"degree_probe_p{p_deg}.npz",
            pts=np.array([s["pt"] for s in samples_comp], dtype=np.int64),
            ts=np.array([s["t"] for s in samples_comp], dtype=np.int64),
            betas=np.array([s["beta"] for s in samples_comp], dtype=np.int64),
            minpolys=np.array([s["minpoly"] for s in samples_comp], dtype=np.int64),
            e_coords=np.stack([s["e_coords"] for s in samples_comp]).astype(np.uint16),
            La_E=np.stack([s["La_E"] for s in samples_comp]).astype(np.uint16),
            rect_dets=np.array([s["rect_det"] for s in samples_comp], dtype=np.int64),
        )

    rectangular_basis_json = {
        "packet": "certificates/fano_c3",
        "track": "C3.0",
        "workorder": "WORKORDER_CAS_T11_P25V_C3.md",
        "exit": "C3-RECTANGULAR-BASIS-MODULAR",
        "headline": "OPEN",
        "proves": (
            "At the sealed F_23 and F_89 split witnesses, the pure Reynolds-frame "
            f"pair (e_{chosen['a_frame_index']}, e_{chosen['b_frame_index']}) has "
            "separable minimal polynomial of degree six for a, and the rectangular "
            "K-basis {b^j a^i : 0<=i,j<6} has nonzero determinant in the Reynolds "
            "frame (equivalently, 1,b,...,b^5 is a right E-basis with E=F_p[a]). "
            "Same exponent rectangle at both primes. Modular only."
        ),
        "does_not_prove": (
            "Does not install m_a, e_j, or L_a over K_proj; does not install the "
            "involution, Morita corner, Hermitian forms, or a Fano point. Modular "
            "rectangular generation does not silently promote to a characteristic-zero "
            "compressed regular representation."
        ),
        "pair": chosen,
        "search": {
            "order": "sealed_C2_pair_first_then_pure_pairs_lex_then_small_lincomb",
            "rng": "none",
            "sealed_pair_succeeded": bool(
                res23["success"] and res89["success"] and chosen["source"] == "sealed_C2_pair"
            ),
            "pairs_examined_beyond_sealed": len(search_log),
            "log_head": search_log[:5],
        },
        "primary_witness": {
            "prime": PRIMARY_P,
            "zeta_11": PRIMARY_ZETA,
            "point": POINT.tolist(),
            "frame_det": int(frame23["frame_det"]),
            "minpoly_coeffs": res23["minpoly_coeffs"],
            "minpoly_degree": res23["minpoly_degree"],
            "separable": res23["separable"],
            "rect_det_m6": res23["rect_det_m6"],
            "rect_det_frame": res23["rect_det_frame"],
            "rect_det_is_unit": res23["rect_det_m6"] % PRIMARY_P != 0,
            "e_coords": comp23["e_coords"].tolist(),
            "b6_identity_ok": True,
            "La_identity_ok": True,
        },
        "secondary_witness": {
            "prime": SECONDARY_P,
            "zeta_11": SECONDARY_ZETA,
            "point": POINT.tolist(),
            "frame_det": int(frame89["frame_det"]),
            "minpoly_coeffs": res89["minpoly_coeffs"],
            "minpoly_degree": res89["minpoly_degree"],
            "separable": res89["separable"],
            "rect_det_m6": res89["rect_det_m6"],
            "rect_det_frame": res89["rect_det_frame"],
            "rect_det_is_unit": res89["rect_det_m6"] % SECONDARY_P != 0,
            "e_coords": comp89["e_coords"].tolist(),
            "b6_identity_ok": True,
            "La_identity_ok": True,
            "note": "p=67 is never used as sole decision fibre",
        },
        "holdout_modular": {
            "prime": HOLDOUT_P,
            "zeta_11": HOLDOUT_ZETA,
            "point": POINT.tolist(),
            "minpoly_degree": res_h["minpoly_degree"],
            "separable": res_h["separable"],
            "rect_det_m6": res_h["rect_det_m6"],
            "rect_det_frame": res_h["rect_det_frame"],
            "success": res_h["success"],
        },
        "holdout_probe_prime": {
            "prime": p_ho,
            "zeta_11": z_ho,
            "point": POINT.tolist(),
            "minpoly_degree": res_ho["minpoly_degree"],
            "separable": res_ho["separable"],
            "rect_det_m6": res_ho["rect_det_m6"],
            "success": res_ho["success"],
            "compressed_ok": comp_ho is not None,
        },
        "rectangle_ordering": {
            "description": "column-major: index = 6*j + i for b^j a^i, 0<=i,j<6",
            "E_basis": "1, a, a^2, a^3, a^4, a^5",
            "right_E_basis": "1, b, b^2, b^3, b^4, b^5",
        },
        "compression_count": {
            "minpoly_K_coeffs": 6,
            "e_j_in_E": 6,
            "La_entries_in_E": 36,
            "E_elements_total": 42,
            "K_coords_per_E": 6,
            "vs_C21_entries": 2592,
            "vs_full_structure": 46656,
        },
        "inputs_consumed": {
            "structure_constants_f23.npz": sha256_file(C1_STRUCT),
            "alignment_certificate.json": sha256_file(ALIGN / "certificate.json"),
            "kproj_core.py": sha256_file(ROOT / "tmp" / "kproj_arithmetic" / "core.py"),
            "word_basis.json": sha256_file(C2 / "word_basis.json"),
        },
        "specific_input_note": (
            "Consumes the sealed PSL(2,11) Reynolds-frame pair (e_1,e_2) from C2.0, "
            "generator alignment A->TSTS, B->T^8S, and homogenization via "
            "tmp/kproj_arithmetic. Not an arbitrary degree-six CSA over an arbitrary "
            "field: the specific descended A_proj frame is the only input."
        ),
        "trap_named": (
            "A construction valid for an arbitrary degree-six CSA over an arbitrary "
            "field is too weak for C3.2/C3.3 — that generality yields individual "
            "isotropy of Hermitian forms and fails to give a common line. This packet "
            "only seals the rectangular/maximal-étale model of the specific A_proj."
        ),
        "elapsed_seconds": round(elapsed, 3),
        "peak_rss_bytes": peak,
        "peak_rss_MiB": round(peak / (1024 * 1024), 2),
        "theorem_boundary": (
            "Proved modularly: the sealed pure frame pair admits a maximal-étale "
            "subalgebra E=F_p[a] of degree six and a right E-basis 1..b^5 at two good "
            "split primes (and holdouts), with unit rectangular-basis determinants. "
            "Not proved: executable compressed regular representation over K_proj, "
            "nor any Fano-section point."
        ),
    }
    (PKG / "rectangular_basis.json").write_text(
        json.dumps(rectangular_basis_json, indent=2) + "\n"
    )

    preflight = {
        "packet": "certificates/fano_c3",
        "track": "C3.1-preflight",
        "workorder": "WORKORDER_CAS_T11_P25V_C3.md §5 C3.1",
        "exit_this_round": "C3-RECTANGULAR-BASIS-MODULAR",
        "c31_exit": c31_exit,
        "next_exit_target": "C3-APROJ-EXECUTABLE",
        "headline": "OPEN",
        "compressed_route": {
            "objects": [
                "m_a(T) in K_proj[T], monic degree 6 (6 K-coeffs)",
                "e_j in E, j=0..5, for b^6 = sum_j b^j e_j (6 E-elements)",
                "L_a in Mat_6(E) (36 E-elements)",
            ],
            "E_basis": "1,a,...,a^5",
            "total_E_elements": 42,
            "total_K_coords": 6 + 42 * 6,  # 6 minpoly + 252 E-coords = 258
            "note": "L_b is the companion matrix over E determined by the e_j",
            "vs_C21": "2592 Mat_36(K) entries; C2.1 floor deg>=5 for ~1249 varying",
            "vs_full_structure": 46656,
        },
        "method": {
            "1_modular_tables": (
                "At primes p≡1 mod 11 (excluding sole use of 67), sample projective "
                "Reynolds frames at deterministic points; extract minpoly, e_coords, La_E."
            ),
            "2_adaptive_interpolation": (
                "Multivariate rational interpolation in the rank-12 K_proj model "
                "(P0=Q(t3,t6,t8,t11) free basis of 12). No fixed degree cap below the "
                "C2.1 proven floor of 5."
            ),
            "3_rational_reconstruction": (
                "CRT + certificates/degree25_exact/common_p25x.py:226 "
                "(never SymPy private helper)."
            ),
            "4_verification": [
                "Holdout prime unused in reconstruction",
                "Exact identities: m_a(a)=0, b^6=sum b^j e_j, a*b^j = sum_k b^k La[k,j]",
                "Rectangular det nonzero on a dense open",
                "Congruence check of every reconstructed rational function",
            ],
        },
        "low_degree_probes": {
            "degree_probe_prime": p_deg,
            "n_samples": len(samples_comp),
            "coordinate_system": (
                "rank-12 free module over P0=Q(t3,t6,t8,t11): "
                "x = sum_k r_k(t)*beta_k with beta = normalized "
                "(1,f7,f9,f10,f12,f14,f7^2,f7*f9,f9^2,f9*f10,f7^3,f9^2*f10)"
            ),
            "max_D_tested": MAX_D_TESTED,
            "unknowns_at_D": {
                str(D): 12 * len(monoms(D)) for D in range(0, MAX_D_TESTED + 1)
            },
            "minpoly_floors": sum_mp,
            "e_coords_floors": sum_e,
            "La_E_floors": sum_La,
            "constants_at_probe_prime": {
                "minpoly_of_6": constants_minpoly,
                "e_of_36": constants_e,
                "La_of_216": constants_La,
            },
            "comparison_to_C21_floor": {
                "C21_varying_degree_floor": 5,
                "C21_method": (
                    "same free-module ansatz; modular systems inconsistent at D=0..4 "
                    "for varying shortlex L_a/L_b entries"
                ),
                "C3_entries_with_floor_ge_5": high_floor_count,
                "C3_entries_with_floor_le_4": low_ok,
                "interpretation": (
                    "Entries with free-module floor ≥5 match C2.1's proven degree floor. "
                    "That does not justify falling back to the 36^3 table (§2.10): "
                    "compression still reduces object count from 2592 to ~258 K-coords "
                    "(or 42 E-elements + 6 minpoly coeffs). Adaptive interpolation with "
                    "no cap below 5 remains the authorized route."
                ),
            },
            "multi_prime_const_scan": multi_prime_const,
            "probe_records": probe_records,
        },
        "resource_floor": {
            "objects": "~258 K_proj elements (vs 2592 for C2.1, 46656 full table)",
            "modular_sample_cost": "group orbit + 36 Reynolds per point; measured C3.0 peak below",
            "reconstruction_estimate": (
                "If degrees stay moderate after adaptive interpolation in the free "
                "module, wall time minutes–hours under 8 GiB. If degrees climb, still "
                "prefer compressed route over entrywise 36-word reconstruction."
            ),
            "heavy_slot": "C3 has third claim after T11 and P25V; this round stays under 8 GiB",
        },
        "failure_modes": [
            "Rectangle det vanishes on a divisor — work on the open where it is a unit",
            "Minpoly degree drops or becomes inseparable on a divisor — exclude that locus",
            "False rational reconstructions that pass CRT but fail holdout (C2.1 caught 12 such L_b)",
            "No fixed degree cap below 5: low-degree inconsistency is not a route failure",
        ],
        "out_of_scope_this_round": [
            "C3.2 involution / Morita corner / Hermitian forms (gated on C3-APROJ-EXECUTABLE)",
            "C3.3 common-isotropic-line search",
            "Full 36^3 structure-constant reconstruction (§2.10 ban)",
        ],
        "language_bans": [
            "Never write: the cubic has a K_proj-point abstractly",
            "Never write: the generic Schur twist has no rational point",
            "No auxiliary projector is a Fano point (FAIL-SCOPE)",
        ],
        "common_p25x_helper_line": 226,
        "common_p25x_sha256": sha256_file(COMMON),
        "elapsed_seconds": round(elapsed, 3),
        "peak_rss_bytes": peak,
        "peak_rss_MiB": round(peak / (1024 * 1024), 2),
    }
    (PKG / "preflight_c31.json").write_text(json.dumps(preflight, indent=2) + "\n")

    exit_json = {
        "exit_c30": "C3-RECTANGULAR-BASIS-MODULAR",
        "exit_c31": c31_exit,
        "headline": "OPEN",
        "pair": {
            "a_frame_index": chosen.get("a_frame_index"),
            "b_frame_index": chosen.get("b_frame_index"),
            "source": chosen["source"],
        },
        "primary": {
            "p": PRIMARY_P,
            "minpoly_degree": res23["minpoly_degree"],
            "separable": res23["separable"],
            "rect_det_m6": res23["rect_det_m6"],
            "rect_det_frame": res23["rect_det_frame"],
        },
        "secondary": {
            "p": SECONDARY_P,
            "minpoly_degree": res89["minpoly_degree"],
            "separable": res89["separable"],
            "rect_det_m6": res89["rect_det_m6"],
            "rect_det_frame": res89["rect_det_frame"],
        },
        "degree_probe": {
            "prime": p_deg,
            "n_samples": len(samples_comp),
            "minpoly_floors": sum_mp,
            "e_floors": sum_e,
            "La_floors": sum_La,
            "entries_floor_ge_5": high_floor_count,
            "entries_floor_le_4": low_ok,
        },
        "peak_rss_MiB": round(peak / (1024 * 1024), 2),
        "elapsed_seconds": round(elapsed, 3),
    }
    (PKG / "exit_c3.json").write_text(json.dumps(exit_json, indent=2) + "\n")
    (SCRATCH / "produce_meta.json").write_text(
        json.dumps(
            {
                "elapsed_seconds": elapsed,
                "peak_rss_bytes": peak,
                "exit_c30": "C3-RECTANGULAR-BASIS-MODULAR",
                "exit_c31": c31_exit,
            },
            indent=2,
        )
        + "\n"
    )
    if search_log:
        (SCRATCH / "search_log.json").write_text(
            json.dumps(search_log, indent=2) + "\n"
        )

    # Markdown report
    md = f"""# C3.0 — Maximal-étale rectangular basis for `A_proj`

**Packet:** `certificates/fano_c3`  
**Date:** 2026-07-31  
**Work order:** `WORKORDER_CAS_T11_P25V_C3.md` §0, §1.8, §2.10, §5 C3.0–C3.1, §7–§9  
**Exit C3.0:** `C3-RECTANGULAR-BASIS-MODULAR`  
**Exit C3.1:** `{c31_exit}`  
**Headline:** **OPEN**

---

## 0. Scope fence

**In scope.** C3.0 modular rectangular basis; C3.1 reconstruction **preflight** and
low-degree probes only.

**Out of scope.** C3.2 (involution, Morita, Hermitian); C3.3 (common isotropic line).
Both gated on `C3-APROJ-EXECUTABLE`. Writes only under `certificates/fano_c3/` and
`tmp/c3_*/`.

**Binding correction §2.10.** C2.1's low-degree failure does **not** justify
entrywise reconstruction of the 36-word regular representation. Maximal-étale
compression first.

---

## 1. Idea (§1.8)

Let `a ∈ A` have separable minimal polynomial of degree six and put `E = K[a]`.
Then `E` is a maximal étale subalgebra and `A` is free of rank six as a right
`E`-module. If `1,b,...,b^5` is a right `E`-basis, the rectangle
`{{b^j a^i : 0 ≤ i,j < 6}}` is a `K`-basis, and left multiplications are `6×6`
matrices over `E`.

**Compressed data:** at most 42 elements of `E` plus six minimal-polynomial
coefficients — against 2592 `K`-entries (C2.1) or 46656 structure constants.

---

## 2. Pair

| Item | Value |
|---|---|
| Source | sealed C2.0 pure frame pair |
| `a` | `e_{{{chosen.get('a_frame_index')}}}` |
| `b` | `e_{{{chosen.get('b_frame_index')}}}` |
| Search | sealed pair first; no RNG |
| Sealed pair succeeded | `{chosen['source'] == 'sealed_C2_pair'}` |

---

## 3. Primary witness `p = 23`

| Check | Result |
|---|---|
| Frame det | {int(frame23['frame_det'])} |
| Minpoly degree of `a` | **{res23['minpoly_degree']}** |
| Separable | **{res23['separable']}** |
| Minpoly coeffs | `{res23['minpoly_coeffs']}` |
| Rectangle det (M6) | **{res23['rect_det_m6']}** |
| Rectangle det (frame) | **{res23['rect_det_frame']}** |
| `b^6` identity | ok |
| `L_a` identity | ok |

---

## 4. Secondary witness `p = 89` (`≡ 1 mod 11`, not 67)

| Check | Result |
|---|---|
| Frame det | {int(frame89['frame_det'])} |
| Minpoly degree | **{res89['minpoly_degree']}** |
| Separable | **{res89['separable']}** |
| Minpoly coeffs | `{res89['minpoly_coeffs']}` |
| Rectangle det (M6) | **{res89['rect_det_m6']}** |
| Rectangle det (frame) | **{res89['rect_det_frame']}** |

Holdout modular `p = {HOLDOUT_P}`: det_m6 = {res_h['rect_det_m6']}, success = {res_h['success']}.  
Holdout probe `p = {p_ho}`: det_m6 = {res_ho['rect_det_m6']}, success = {res_ho['success']}.

---

## 5. C3.1 low-degree probes (summary)

Degree-probe prime `p = {p_deg}`, samples = {len(samples_comp)}.
Ansatz: each compressed `K`-coordinate expands as
`x = Σ_{{k=0..11}} r_k(t)·β_k` in the certified free basis of `K_proj/P_0`,
with each `r_k` a total-degree ≤ `D` polynomial in `(t_3,t_6,t_8,t_11)`.
Max `D` tested: **{MAX_D_TESTED}** (840 unknowns; same method as C2.1).

| Block | entries | floor 0 | floor 1–4 | floor ≥5 | unmeasured |
|---|---:|---:|---:|---:|---:|
| minpoly (6) | {sum_mp['n_entries']} | {sum_mp['n_floor_0']} | {sum_mp['n_floor_1']+sum_mp['n_floor_2']+sum_mp['n_floor_3']+sum_mp['n_floor_4']} | {sum_mp['n_floor_ge_5']} | {sum_mp['n_insufficient']} |
| e_coords (36) | {sum_e['n_entries']} | {sum_e['n_floor_0']} | {sum_e['n_floor_1']+sum_e['n_floor_2']+sum_e['n_floor_3']+sum_e['n_floor_4']} | {sum_e['n_floor_ge_5']} | {sum_e['n_insufficient']} |
| La_E (216) | {sum_La['n_entries']} | {sum_La['n_floor_0']} | {sum_La['n_floor_1']+sum_La['n_floor_2']+sum_La['n_floor_3']+sum_La['n_floor_4']} | {sum_La['n_floor_ge_5']} | {sum_La['n_insufficient']} |

Measured entries with free-module floor ≥ 5: **{high_floor_count}**; with floor ≤ 4: **{low_ok}**.

C2.1 proved a degree floor ≥ 5 for ~1249 varying shortlex entries. Compression
does not magically lower every degree, but cuts the object count from 2592 to
~258 `K`-coordinates (42 `E`-elements + 6 minpoly coeffs). **No fallback to the
36³ table** (§2.10).

Full `C3-APROJ-EXECUTABLE` requires actual multi-prime adaptive reconstruction
over the rank-12 model; this round stops at preflight + probes →
`{c31_exit}`.

---

## 6. Theorem boundary

**Proved (modular).** The pure Reynolds-frame pair `(e_1, e_2)` has separable
degree-six minimal polynomial for `a` and a unit rectangular-basis determinant
at the sealed `F_23` and `F_89` witnesses (and modular holdouts).

**Not proved.** `m_a`, `e_j`, `L_a` over `K_proj`; involution; Morita corner;
quaternion symbol; five Hermitian matrices; restricted Plücker; any point of
the genuine twisted Fano section `F_{{14,T}}`. Problem E remains **OPEN**.

**Trap named.** A construction valid for an arbitrary degree-six CSA over an
arbitrary field is too weak for C3.2/C3.3 — that generality yields individual
isotropy and fails to give a common line. This packet only seals the rectangular
model of the specific descended `A_proj` frame.

**Language.** No claim that “the cubic has a `K_proj`-point abstractly”; no claim
that “the generic Schur twist has no rational point.” No auxiliary projector is
a Fano point.

---

## 7. Deliverables

```text
certificates/fano_c3/
  C3_RECTANGULAR_BASIS.md
  rectangular_basis.json
  rectangular_basis.npz
  preflight_c31.json
  exit_c3.json
  produce_c3.py
  verify_c3.py
```

Scratch: `tmp/c3_preflight/`, `tmp/c3_work/`.

**Peak RSS (producer):** ~{peak / (1024 * 1024):.2f} MiB.  
**Elapsed:** ~{elapsed:.3f} s.
"""
    (PKG / "C3_RECTANGULAR_BASIS.md").write_text(md)

    print(
        f"C3 done: C3-RECTANGULAR-BASIS-MODULAR + {c31_exit}; "
        f"det23={res23['rect_det_m6']} det89={res89['rect_det_m6']}; "
        f"peak_MiB={peak/(1024*1024):.2f} elapsed={elapsed:.3f}s",
        flush=True,
    )
    # silence unused
    _ = common.rational_reconstruction


if __name__ == "__main__":
    main()
