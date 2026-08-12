"""Dominance-route helpers: cell, jets, 4x4 minors, I3/I4/I5 sketches, flint rank.

Modular rank uses FLINT nmod_mat (same engine M2 uses) via ctypes, called from
python3. No gap/gp/sage/magma.
"""
from __future__ import annotations

import ctypes
import itertools
import json
import os

import numpy as np

import paths
import slicelib as SL

PAIR_RES = paths.PAIR_RES
D35L_RES = paths.D35L_RES
DEG = paths.DEG
K = paths.K
P3 = paths.P3
N3 = paths.N3
N4 = paths.N4
N5 = paths.N5

_FLINT = None
_FLINT_OK = None


class _NModMat(ctypes.Structure):
    _fields_ = [
        ("entries", ctypes.POINTER(ctypes.c_ulong)),
        ("r", ctypes.c_long),
        ("c", ctypes.c_long),
        ("stride", ctypes.c_long),
    ]


def _flint():
    global _FLINT, _FLINT_OK
    if _FLINT_OK is not None:
        return _FLINT
    libpath = "/opt/homebrew/lib/libflint.dylib"
    if not os.path.exists(libpath):
        _FLINT_OK = False
        return None
    lib = ctypes.CDLL(libpath)
    lib.nmod_mat_init.argtypes = [
        ctypes.c_void_p, ctypes.c_long, ctypes.c_long, ctypes.c_ulong]
    lib.nmod_mat_clear.argtypes = [ctypes.c_void_p]
    lib.nmod_mat_rank.argtypes = [ctypes.c_void_p]
    lib.nmod_mat_rank.restype = ctypes.c_long
    lib.nmod_mat_nullspace.argtypes = [ctypes.c_void_p, ctypes.c_void_p]
    lib.nmod_mat_nullspace.restype = ctypes.c_long
    _FLINT = lib
    _FLINT_OK = True
    return lib


def flint_rank(A, p):
    """Rank of A over F_p via FLINT nmod_mat_rank. A is (m, n) integer array."""
    lib = _flint()
    if lib is None:
        return int(SL.rref_rank(np.array(A, dtype=np.int64) % p, p))
    A = np.ascontiguousarray(np.array(A, dtype=np.uint64) % int(p))
    rows, cols = A.shape
    if rows == 0 or cols == 0:
        return 0
    buf = (ctypes.c_char * 256)()
    lib.nmod_mat_init(ctypes.byref(buf), rows, cols, int(p))
    try:
        mat = _NModMat.from_buffer(buf)
        view = np.ctypeslib.as_array(mat.entries, shape=(rows, mat.stride))
        view[:, :cols] = A
        return int(lib.nmod_mat_rank(ctypes.byref(buf)))
    finally:
        lib.nmod_mat_clear(ctypes.byref(buf))


def mon_list(d, n=K):
    return list(itertools.combinations_with_replacement(range(n), d))


def nmon(d, n=K):
    r = 1
    for i in range(d):
        r = r * (n + i) // (i + 1)
    return r


def build_mul_table(d, n=K):
    """table[i, j] = index of (mon_d[j] * x_i) in mon_{d+1}."""
    mons_d = mon_list(d, n)
    mons_n = mon_list(d + 1, n)
    idx_n = {m: i for i, m in enumerate(mons_n)}
    table = np.empty((n, len(mons_d)), dtype=np.int32)
    for j, mon in enumerate(mons_d):
        for i in range(n):
            table[i, j] = idx_n[tuple(sorted(mon + (i,)))]
    return table, len(mons_n)


def load_cell(p):
    """37 x 637 cell basis in seed coordinates, plus A, C, frame-free arrays."""
    null = np.load(os.path.join(PAIR_RES, "layer0_null_p%d.npy" % p)) % p
    A = np.load(os.path.join(PAIR_RES, "layer0_A_p331.npy"))
    C = np.load(os.path.join(PAIR_RES, "layer0_C_p331.npy"))
    we = json.load(open(os.path.join(PAIR_RES, "worked_example_p%d.json" % p)))
    U = np.array(we["universal_matrix_6x39"], dtype=np.int64) % p
    K39 = SL.nullspace(U, p)
    assert K39.shape[0] == K, K39.shape
    B37 = (K39 @ null) % p
    assert SL.rref_rank(B37, p) == K
    return {
        "p": int(p),
        "null39": null,
        "U": U,
        "rank_U": int(SL.rref_rank(U, p)),
        "K39": K39 % p,
        "B37": B37,
        "A": A,
        "C": C,
        "cell_dim": int(K39.shape[0]),
    }


def load_I3(p):
    path = os.path.join(D35L_RES, "I3_echelon_p%d.npy" % p)
    piv = os.path.join(D35L_RES, "I3_pivots_p%d.npy" % p)
    I3 = np.load(path) % p
    assert I3.shape == (P3, N3), I3.shape
    pivots = np.load(piv) if os.path.exists(piv) else None
    return I3, pivots


def eval_seeds(fr, A, C, W):
    Y = np.zeros_like(W)
    return SL.jet_rows(fr, A, C, W, Y, 1, deg=DEG)[:, :, :, 0] % fr["p"]


def jacobians_cell(fr, A, C, B37, W):
    """J[b, pt, row, col] = d(T_b^{row})/dx_col at W[pt]. Shape (37, npts, 5, 5)."""
    p = fr["p"]
    npts = W.shape[0]
    Ws = np.vstack([W] * 5)
    Ys = np.zeros((5 * npts, 5), dtype=np.int64)
    for j in range(5):
        Ys[j * npts:(j + 1) * npts, j] = 1
    R = SL.jet_rows(fr, A, C, Ws, Ys, 2, deg=DEG)
    d1 = R[:, :, :, 1] % p
    d1 = d1.reshape(d1.shape[0], 5, npts, 5)  # (seed, j, pt, a)
    J = np.tensordot(B37 % p, d1, axes=(1, 0)) % p  # (37, j, pt, a)
    return np.transpose(J, (0, 2, 3, 1)) % p  # (37, pt, a, j)


def values_cell(fr, A, C, B37, W):
    """T_b(W[pt]). Shape (37, npts, 5)."""
    p = fr["p"]
    seeds = eval_seeds(fr, A, C, W)  # (637, npts, 5)
    return np.tensordot(B37 % p, seeds, axes=(1, 0)) % p


def jacobian_of_vec(Jcell, c, p):
    """5x5 Jacobian of T_c at each sample: (npts, 5, 5). Jcell is (37, npts, 5, 5)."""
    return np.tensordot(c % p, Jcell, axes=(0, 0)) % p


def rank5(M, p):
    return flint_rank(np.array(M, dtype=np.int64) % p, p)


def minor_subsets():
    rows = []
    for skip_r in range(5):
        for skip_c in range(5):
            rr = [i for i in range(5) if i != skip_r]
            cc = [j for j in range(5) if j != skip_c]
            rows.append((skip_r, skip_c, rr, cc))
    return rows


def _det4_batch(M, p):
    """M: (nc, 4, 4) -> (nc,) determinants mod p (Leibniz, exact)."""
    a, b, cc, d = M[:, 0], M[:, 1], M[:, 2], M[:, 3]
    return (
        a[:, 0] * (b[:, 1] * (cc[:, 2] * d[:, 3] - cc[:, 3] * d[:, 2])
                   - b[:, 2] * (cc[:, 1] * d[:, 3] - cc[:, 3] * d[:, 1])
                   + b[:, 3] * (cc[:, 1] * d[:, 2] - cc[:, 2] * d[:, 1]))
        - a[:, 1] * (b[:, 0] * (cc[:, 2] * d[:, 3] - cc[:, 3] * d[:, 2])
                     - b[:, 2] * (cc[:, 0] * d[:, 3] - cc[:, 3] * d[:, 0])
                     + b[:, 3] * (cc[:, 0] * d[:, 2] - cc[:, 2] * d[:, 0]))
        + a[:, 2] * (b[:, 0] * (cc[:, 1] * d[:, 3] - cc[:, 3] * d[:, 1])
                     - b[:, 1] * (cc[:, 0] * d[:, 3] - cc[:, 3] * d[:, 0])
                     + b[:, 3] * (cc[:, 0] * d[:, 1] - cc[:, 1] * d[:, 0]))
        - a[:, 3] * (b[:, 0] * (cc[:, 1] * d[:, 2] - cc[:, 2] * d[:, 1])
                     - b[:, 1] * (cc[:, 0] * d[:, 2] - cc[:, 2] * d[:, 0])
                     + b[:, 2] * (cc[:, 0] * d[:, 1] - cc[:, 1] * d[:, 0]))
    ) % p


def det4_linear_combo(As, c, p):
    """det(sum_i c_i As[i]) for As[i] 4x4. c shape (37,)."""
    M = np.tensordot(c % p, As, axes=(0, 0)) % p
    return int(_det4_batch(M.reshape(1, 4, 4), p)[0])


def minor_values_at_cs(Jcell_pt, cs, p):
    """All 25 minors of J(c) at one x, for many c.

    Jcell_pt: (37, 5, 5) Jacobians of the 37 basis at this x.
    cs: (nc, 37).
    Returns (25, nc) values.
    """
    Jcs = np.tensordot(cs % p, Jcell_pt % p, axes=(1, 0)) % p  # (nc,5,5)
    specs = minor_subsets()
    out = np.zeros((25, cs.shape[0]), dtype=np.int64)
    for s, (_sr, _sc, rr, cc) in enumerate(specs):
        out[s] = _det4_batch(Jcs[np.ix_(range(cs.shape[0]), rr, cc)], p)
    return out % p


def _scatter4_table(n=K):
    """idx4 of every (a,b,c,d) in 0..n-1 after sorting."""
    mons = mon_list(4, n)
    idx = {m: i for i, m in enumerate(mons)}
    tab = np.empty((n, n, n, n), dtype=np.int32)
    for a in range(n):
        for b in range(n):
            for c in range(n):
                for d in range(n):
                    tab[a, b, c, d] = idx[tuple(sorted((a, b, c, d)))]
    return tab


_SCATTER4 = None


def expand_det4(As, p, scatter=None):
    """Coefficient vector in Sym^4 of det(sum_i c_i As[i]), As (37,4,4)."""
    global _SCATTER4
    if scatter is None:
        if _SCATTER4 is None:
            _SCATTER4 = _scatter4_table()
        scatter = _SCATTER4
    Q = np.zeros(N4, dtype=np.int64)
    # 24 permutations of columns, sign
    import itertools as it
    cols = range(4)
    for perm in it.permutations(cols):
        sign = 1
        # parity
        seen = list(perm)
        for i in range(4):
            for j in range(i):
                if seen[j] > seen[i]:
                    sign = -sign
        L = [As[:, r, perm[r]] % p for r in range(4)]  # 4 linear forms (37,)
        T = np.multiply.outer(L[0], L[1]) % p
        T = np.multiply.outer(T, L[2]) % p
        T = np.multiply.outer(T, L[3]) % p  # (37,37,37,37)
        if sign < 0:
            T = (-T) % p
        np.add.at(Q, scatter.ravel(), T.ravel())
        Q %= p
    return Q % p


def pivot_quartic_support(pivots, mul3):
    """Set of quartic monomials of the form x_i * (I3 pivot)."""
    S = set()
    for i in range(K):
        for pv in pivots:
            S.add(int(mul3[i, int(pv)]))
    return S


def rewrite_I4(Q, I3, pivots, mul3, p):
    """Clear coordinates x_i * pivot_j using the echelon products. In-place copy.

    Remainder 0 => Q is in I4 (sufficient and, if the used leads are independent
    and cover a basis, also necessary). Nonzero remainder is not by itself a
    non-membership proof when |S| < 37*P3.
    """
    R = np.array(Q, dtype=np.int64) % p
    used = {}
    for i in range(K):
        for j in range(I3.shape[0]):
            lead = int(mul3[i, int(pivots[j])])
            if lead not in used:
                used[lead] = (i, j)
    # iterate to a fixed point: remainder 0 is then a sufficient I4 certificate
    for _ in range(8):
        changed = False
        for lead, (i, j) in used.items():
            coef = int(R[lead]) % p
            if coef == 0:
                continue
            row = I3[j] % p
            nz = np.nonzero(row)[0]
            slots = mul3[i, nz]
            R[slots] = (R[slots] - coef * row[nz]) % p
            changed = True
        if not changed:
            break
    return R % p, used


def eval_monomials(z, d, p):
    """Values of mon_d at point z (n,)."""
    mons = mon_list(d, len(z))
    out = np.empty(len(mons), dtype=np.int64)
    for t, m in enumerate(mons):
        v = 1
        for i in m:
            v = (v * int(z[i])) % p
        out[t] = v
    return out


def eval_I3_at_points(I3, Z, p):
    """C_j(z_α). I3 (P3, N3), Z (N, K) -> (N, P3)."""
    # mon3 at each z
    N = Z.shape[0]
    mons = mon_list(3, K)
    M3 = np.empty((N, N3), dtype=np.int64)
    for t, m in enumerate(mons):
        v = np.ones(N, dtype=np.int64)
        for i in m:
            v = (v * Z[:, i]) % p
        M3[:, t] = v
    return (M3 @ (I3.T % p)) % p  # (N, P3)


def i4_eval_matvec(A, C_at, Z, p):
    """μ(A) evaluated: sum_j C_j(z) * (A[j]·z). A is (P3, K)."""
    # (Z @ A.T) is (N, P3); then row-wise dot with C_at
    return np.sum((C_at * ((Z @ (A.T % p)) % p)) % p, axis=1) % p


def random_I4_evals(I3, Z, k, p, rng):
    """k random I4 elements evaluated at the rows of Z. Returns (N, k)."""
    N = Z.shape[0]
    C_at = eval_I3_at_points(I3, Z, p)  # (N, P3)
    Combo = rng.integers(0, p, size=(k, P3), dtype=np.int64)
    F = (Combo @ (I3 % p)) % p  # (k, N3)  -- not needed if we use C_at
    # evaluations of random cubics: C_at @ Combo.T
    Crand = (C_at @ (Combo.T % p)) % p  # (N, k)
    Lin = rng.integers(0, p, size=(k, K), dtype=np.int64)
    Lval = (Z @ (Lin.T % p)) % p  # (N, k)
    return (Crand * Lval) % p, C_at


def random_I5_evals(I3, Z, k, p, rng):
    """k random I5 = quad * I3 elements at rows of Z. Returns (N, k)."""
    C_at = eval_I3_at_points(I3, Z, p)
    Combo = rng.integers(0, p, size=(k, P3), dtype=np.int64)
    Crand = (C_at @ (Combo.T % p)) % p
    # random quadratic via two linears
    A = rng.integers(0, p, size=(k, K), dtype=np.int64)
    B = rng.integers(0, p, size=(k, K), dtype=np.int64)
    qa = (Z @ (A.T % p)) % p
    qb = (Z @ (B.T % p)) % p
    return (Crand * qa % p * qb) % p, C_at


def jsonable(x):
    if isinstance(x, dict):
        return {str(k): jsonable(v) for k, v in x.items()}
    if isinstance(x, (list, tuple)):
        return [jsonable(v) for v in x]
    if isinstance(x, (np.integer,)):
        return int(x)
    if isinstance(x, (np.floating,)):
        return float(x)
    if isinstance(x, (np.bool_,)):
        return bool(x)
    if isinstance(x, np.ndarray):
        return x.tolist()
    return x
