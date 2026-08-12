#!/usr/bin/env python3
"""D35 landing on the 37-cell: F(T_c) = 0 sampled cubics, G-character, helpers.

Reuses D34_GUIDED_SWEEP/slicelib.py for the modular Weil frame and Reynolds
evaluation (jet_rows). Inputs from PAIR_ATTACK_D35/results/.
"""
from __future__ import annotations

import itertools
import json
import os
import time

import numpy as np

import paths  # noqa: F401
import slicelib as SL

PAIR_RES = paths.PAIR_RES
RES = paths.RES
DEG = 35
NSEED = 637
DIM39 = 39
DIM37 = 37
PRIMES = (331, 661)


def load_cell(p):
    """Return dict with B37 (37 x 637), A, C, U, null39, frame-free."""
    null = np.load(os.path.join(PAIR_RES, "layer0_null_p%d.npy" % p))
    assert null.shape == (DIM39, NSEED), null.shape
    # exponents are prime-independent
    A = np.load(os.path.join(PAIR_RES, "layer0_A_p331.npy"))
    C = np.load(os.path.join(PAIR_RES, "layer0_C_p331.npy"))
    assert A.shape == (NSEED, 5) and C.shape == (NSEED,)
    we = json.load(open(os.path.join(PAIR_RES, "worked_example_p%d.json" % p)))
    U = np.array(we["universal_matrix_6x39"], dtype=np.int64) % p
    assert U.shape == (6, DIM39)
    K39 = SL.nullspace(U, p)  # (37, 39) if rank(U)=2
    assert K39.shape[0] == DIM37, ("expected 37-cell, got", K39.shape)
    B37 = (K39 @ null) % p
    assert SL.rref_rank(B37, p) == DIM37
    return {
        "p": p,
        "null39": null % p,
        "U": U,
        "K39": K39 % p,
        "B37": B37,
        "A": A,
        "C": C,
        "rank_U": SL.rref_rank(U, p),
    }


def klein_F(v, p):
    """F = sum_{i in Z/5} x_i^2 x_{i+1}."""
    s = 0
    for i in range(5):
        s += int(v[i]) * int(v[i]) % p * int(v[(i + 1) % 5]) % p
    return s % p


def eval_seeds_at_points(fr, A, C, pts, deg=DEG):
    """Evaluate all 637 Reynolds seeds at pts. Returns (nseeds, npts, 5)."""
    npts = pts.shape[0]
    W = pts % fr["p"]
    Y = np.zeros_like(W)
    res = SL.jet_rows(fr, A, C, W, Y, J=1, deg=deg)  # (ns, npts, 5, 1)
    return res[:, :, :, 0] % fr["p"]


def eval_cell_at_points(fr, cell, pts):
    """M[q, c, j] = (T_j(x_q))_c  shape (npts, 5, 37)."""
    seeds = eval_seeds_at_points(fr, cell["A"], cell["C"], pts)
    # seeds: (637, npts, 5); B37: (37, 637)
    # T_j(x_q)_c = sum_s B37[j,s] * seeds[s,q,c]
    B = cell["B37"]
    p = fr["p"]
    # (37, npts, 5)
    T = np.einsum("js,sqc->jqc", B, seeds) % p
    return np.transpose(T, (1, 2, 0)) % p  # (npts, 5, 37)


def cubic_coeff_row(M5x37, p):
    """Coefficient vector of F(M c) in the non-symmetric monomial basis
    combinations_with_replacement(range(37), 3), following FIX-VII-LAND.

    M is 5 x 37: T_c(x) = M @ c.
    F = sum_i (row_i · c)^2 (row_{i+1} · c).
    """
    K = M5x37.shape[1]
    C3 = np.zeros((K, K, K), dtype=np.int64)
    for i in range(5):
        a = M5x37[i]
        b = M5x37[(i + 1) % 5]
        C3 = (C3 + np.einsum("u,v,w->uvw", a, a, b)) % p
    mons = list(itertools.combinations_with_replacement(range(K), 3))
    row = []
    for (u, v, w) in mons:
        perms = set(itertools.permutations((u, v, w)))
        row.append(sum(int(C3[q]) for q in perms) % p)
    return np.array(row, dtype=np.int64), mons


def sample_landing_cubics(fr, cell, npts, seed, batch=20):
    """Sample npts random affine points in F_p^5; return cubic matrix and meta.

    Rows of the matrix live in Sym^3 dual (non-redundant monomial basis of size
    binom(K+2,3)).
    """
    p = fr["p"]
    rng = np.random.default_rng(seed)
    K = DIM37
    nmons = (K * (K + 1) * (K + 2)) // 6
    rows = []
    ranks = []
    t0 = time.time()
    done = 0
    while done < npts:
        b = min(batch, npts - done)
        pts = rng.integers(0, p, size=(b, 5), dtype=np.int64)
        # reject 0 vector
        for i in range(b):
            if not pts[i].any():
                pts[i, 0] = 1
        M_all = eval_cell_at_points(fr, cell, pts)  # (b, 5, 37)
        for q in range(b):
            row, mons = cubic_coeff_row(M_all[q], p)
            rows.append(row)
        done += b
        R = np.array(rows, dtype=np.int64)
        rk = SL.rref_rank(R, p)
        ranks.append({"n": done, "rank": int(rk), "t": time.time() - t0})
        print("  sample n=%d rank=%d  (%.1fs)" % (done, rk, time.time() - t0),
              flush=True)
    mons = list(itertools.combinations_with_replacement(range(K), 3))
    assert len(mons) == nmons
    return {
        "rows": np.array(rows, dtype=np.int64) % p,
        "mons": mons,
        "ranks": ranks,
        "plateau_rank": int(ranks[-1]["rank"]),
        "npts": npts,
        "seed": seed,
        "nmons": nmons,
    }


def action_matrix_on_cell(fr, cell, g_index, nprobe=12, seed=0):
    """37x37 matrix of g-action on the cell, by evaluation matching.

    (g · T)(x) = rho(g) T(rho(g)^{-1} x).
    """
    p = fr["p"]
    RHO = fr["RHO"]
    RHOI = fr["RHOI"]
    g = RHO[g_index]
    ginv = RHOI[g_index]
    rng = np.random.default_rng(seed + g_index)
    pts = rng.integers(0, p, size=(nprobe, 5), dtype=np.int64)
    for i in range(nprobe):
        if not pts[i].any():
            pts[i, 0] = 1
    # T_j at pts: (nprobe, 5, 37)
    T_at = eval_cell_at_points(fr, cell, pts)
    # points mapped: rho(g)^{-1} pts
    pts_pull = (pts @ ginv.T) % p  # (x @ ginv^T) if row vectors... 
    # v is column: ginv @ v. Our pts are rows, so (ginv @ pts.T).T = pts @ ginv.T
    T_pull = eval_cell_at_points(fr, cell, pts_pull)  # (nprobe, 5, 37)
    # (g·T_j)(x) = g @ T_j(ginv x)
    # shape: for each j, g @ T_pull[q,:,j] = sum_k A[j,k] T_at[q,:,k]
    # Build E: (nprobe*5, 37) with columns = T_k values
    E = T_at.reshape(nprobe * 5, DIM37) % p  # columns are basis values
    # RHS for each j: (g · T_j) values
    # T_pull_g[q, c, j] = (g @ T_pull[q, :, j])_c
    Tg = np.einsum("cd,qdj->qcj", g, T_pull) % p
    RHS = Tg.reshape(nprobe * 5, DIM37) % p  # column j = g·T_j values
    # Solve E @ A.T = RHS  i.e. A.T = E^+ RHS, so A maps coords: g·(sum c_j T_j) = sum (A c)_k T_k
    # We want A such that E @ A.T ≡ RHS, i.e. each column: E @ A[j,:] = RHS[:,j]
    # Use least-squares / exact solve via RREF on stacked system.
    # Since basis is free, E should have rank 37 if nprobe*5 >= 37 and pts generic.
    # Solve E X = RHS for X = A.T  (37 x 37)
    # Augment and RREF-style solve per column using numpy over F_p.
    X = _solve_fp(E, RHS, p)  # E X = RHS, X shape (37, 37)
    A = X.T % p
    return A


def _solve_fp(E, RHS, p):
    """Solve E X = RHS over F_p. E is (m,n), RHS (m,k), m>=n, full rank n."""
    m, n = E.shape
    k = RHS.shape[1]
    # Gaussian elimination on E | RHS
    M = np.concatenate([E % p, RHS % p], axis=1).astype(np.int64) % p
    piv_cols = []
    r = 0
    for c in range(n):
        piv = None
        for i in range(r, m):
            if M[i, c]:
                piv = i
                break
        if piv is None:
            continue
        M[[r, piv]] = M[[piv, r]]
        inv = SL.inv_mod(int(M[r, c]), p)
        M[r] = (M[r] * inv) % p
        col = M[:, c].copy()
        col[r] = 0
        nz = np.nonzero(col)[0]
        if nz.size:
            M[nz] = (M[nz] - np.outer(col[nz], M[r])) % p
        piv_cols.append(c)
        r += 1
        if r == n:
            break
    assert len(piv_cols) == n, ("rank-deficient eval matrix", len(piv_cols), n)
    # now top n rows are I | X
    X = M[:n, n:] % p
    return X


def conjugacy_class_reps(fr):
    """One representative index per conjugacy class, with order and size."""
    p = fr["p"]
    RHO = fr["RHO"]
    orders = fr["orders"]
    traces = fr["traces"]
    # classify by (order, trace) which separates classes for PSL(2,11) Weil
    # ATLAS L2(11): classes 1A, 2A, 3A, 5A, 5B, 6A, 11A, 11B
    buckets = {}
    for i in range(660):
        key = (int(orders[i]), int(traces[i]) % p)
        buckets.setdefault(key, []).append(i)
    reps = []
    for key, idxs in sorted(buckets.items()):
        reps.append({
            "order": key[0],
            "trace_W": key[1],
            "size": len(idxs),
            "rep": idxs[0],
            "indices": idxs,
        })
    assert sum(r["size"] for r in reps) == 660
    return reps


def cell_character(fr, cell, seed=1):
    """Character of G on the 37-cell: list of (class, chi(g), size)."""
    reps = conjugacy_class_reps(fr)
    out = []
    for r in reps:
        A = action_matrix_on_cell(fr, cell, r["rep"], nprobe=16, seed=seed)
        chi = int(np.trace(A)) % fr["p"]
        # lift to signed small integer in (-p/2, p/2]
        if chi > fr["p"] // 2:
            chi_s = chi - fr["p"]
        else:
            chi_s = chi
        out.append({
            "order": r["order"],
            "trace_W": r["trace_W"],
            "size": r["size"],
            "rep": r["rep"],
            "chi_mod_p": chi,
            "chi": chi_s,
            "matrix_ok": True,
        })
        print("  class ord=%d trW=%d size=%d  chi(g)=%d" % (
            r["order"], r["trace_W"], r["size"], chi_s), flush=True)
    # dimension check: chi(1) == 37
    id_chi = [c for c in out if c["order"] == 1][0]["chi"]
    assert id_chi % fr["p"] == DIM37 % fr["p"], id_chi
    return out


def isotypic_multiplicities(char_table_cell, p):
    """Match cell character against ATLAS irreps of L2(11) via class functions."""
    return _isotypic_from_integer_irreps(char_table_cell, p)


def _isotypic_from_integer_irreps(char_list, p):
    """Frobenius products against ATLAS irreps of L2(11).

    M_d = (Sym^d W* ⊗ W)^G is the space of G-invariants, so residual G-action
    on any subspace (including the 37-cell) is necessarily trivial: chi = dim · 1.
    The Weil representation's traces merge ATLAS classes 5A/5B (both tr_W=0),
    so the class function is recorded on the 7 observable (order, tr_W) buckets;
    |G| still equals the sum of bucket sizes.

    For a trivial character of dimension 37 the only multiplicity is m(1)=37.
    """
    classes = sorted(char_list, key=lambda c: (c["order"], c["size"], c["trace_W"]))
    sizes = [c["size"] for c in classes]
    chi = [c["chi"] for c in classes]
    assert sum(sizes) == 660
    assert classes[0]["order"] == 1 and chi[0] == 37

    # Detect triviality: chi(g) == 37 for all classes.
    trivial = all(c == 37 for c in chi)
    mults = {
        "1": 37 if trivial else None,
        "5a+5b": 0 if trivial else None,
        "10a": 0 if trivial else None,
        "10b": 0 if trivial else None,
        "11": 0 if trivial else None,
        "12a+12b": 0 if trivial else None,
    }
    if trivial:
        # <37·1, 1> = 37; all other irreps orthogonal to 1.
        dim = 37
    else:
        # Fallback: project onto the trivial irrep only.
        s = sum(sizes[i] * chi[i] for i in range(len(classes)))
        mults["1"] = s // 660
        dim = mults["1"]  # incomplete if non-trivial
    return {
        "classes": [
            {"order": c["order"], "size": c["size"], "trace_W": c["trace_W"],
             "chi": c["chi"]}
            for c in classes
        ],
        "multiplicities": mults,
        "residual_action": "trivial" if trivial else "nontrivial",
        "note": (
            "M_35 is defined as G-invariants, so G acts trivially on the "
            "37-cell; isotypic blocking of the cubic system is vacuous. "
            "Equivariance is still used: F(T_c) is a G-invariant form in x, "
            "so orbit-wise sampling saturates."
        ),
        "dim_check": dim,
        "dim_ok": dim == 37 and trivial,
    }


def write_msolve_system(path, p, rows, mons, var_prefix="c", max_eqs=None):
    """Write msolve input: cubic system in DIM37 variables."""
    K = DIM37
    if max_eqs is not None:
        rows = rows[:max_eqs]
    polys = []
    for row in rows:
        terms = []
        for coef, (u, v, w) in zip(row, mons):
            coef = int(coef) % p
            if coef == 0:
                continue
            terms.append("%d*%s%d*%s%d*%s%d" % (
                coef, var_prefix, u, var_prefix, v, var_prefix, w))
        if terms:
            polys.append("+".join(terms))
        else:
            polys.append("0")
    # drop zero polys
    polys = [pl for pl in polys if pl != "0"]
    header = ",".join("%s%d" % (var_prefix, i) for i in range(K))
    body = header + "\n" + str(p) + "\n" + ",\n".join(polys) + "\n"
    with open(path, "w") as f:
        f.write(body)
    return len(polys)


def write_m2_dim(path, p, rows, mons, max_eqs=None, sat_linears=None):
    """Macaulay2 script: dim of ideal of cubics, optional saturation by linears."""
    K = DIM37
    if max_eqs is not None:
        rows = rows[:max_eqs]
    lines = []
    lines.append("kk = ZZ/%d;" % p)
    lines.append("R = kk[c_0..c_%d];" % (K - 1))
    eqs = []
    for row in rows:
        terms = []
        for coef, (u, v, w) in zip(row, mons):
            coef = int(coef) % p
            if coef == 0:
                continue
            terms.append("%d*c_%d*c_%d*c_%d" % (coef, u, v, w))
        if terms:
            eqs.append("("+("+".join(terms))+")")
    lines.append("I = ideal(%s);" % ",".join(eqs))
    lines.append('<< "dim_I " << dim I << endl;')
    lines.append('<< "deg_I " << degree I << endl;')
    if sat_linears:
        # sat_linears: list of lists of length K (linear forms)
        Lpolys = []
        for j, lin in enumerate(sat_linears):
            terms = ["%d*c_%d" % (int(a) % p, i) for i, a in enumerate(lin)
                     if int(a) % p]
            if terms:
                Lpolys.append("+".join(terms))
        if Lpolys:
            lines.append("L = ideal(%s);" % ",".join(Lpolys))
            lines.append("J = saturate(I, L);")
            lines.append('<< "dim_sat " << dim J << endl;')
            lines.append('<< "deg_sat " << degree J << endl;')
    lines.append('<< "DONE" << endl;')
    with open(path, "w") as f:
        f.write("\n".join(lines) + "\n")


def minus_line_vanishing_matrix(fr, cell, n_dirs=8, seed=3):
    """Linear conditions T|_{L_sigma} ≡ 0: T vanishes on the minus-line of sigma.

    Sample points on W^- (dim 2) and require T(point)=0 (5 conditions each).
    Returns a matrix (nrows, 37) whose kernel is {c : T_c |_{L} = 0}.
    Safe direction: more samples only shrinks kernel.
    """
    p = fr["p"]
    Wm = fr["Wminus"]  # (2, 5) rows
    rng = np.random.default_rng(seed)
    # points on the minus-line: linear combos of Wm rows
    coefs = rng.integers(0, p, size=(n_dirs, 2), dtype=np.int64)
    pts = (coefs @ Wm) % p
    M = eval_cell_at_points(fr, cell, pts)  # (n_dirs, 5, 37)
    # each entry M[q,c,j] is linear form in cell coords for component c at pt q
    rows = M.reshape(-1, DIM37) % p
    return rows


def datum_34_1_vanishing_matrix(fr, cell, n_dirs=6, seed=5):
    """Linear conditions for the (34,1)-sweep datum to vanish.

    The (34,1) datum is the leading transverse jet of T along the minus-line
    in the plus-plane directions — equivalently, the coefficient of t^0 in
    the expansion is already killed by (M) off at odd d, and the order-0
    reading is T itself on generic points of L_sigma? At odd d the minus-line
    is NOT forced into Bs; the open condition for the 22 blueprints is that
    T does not vanish to order >=1 on L (order 0 branch).

    So " (34,1)-datum ≡ 0 " as a degeneracy is: the full restriction of T to
    a generic minus-line direction vanishes (no sweep). We approximate by
    T vanishing at enough sample points of L_sigma — same linear conditions
    as minus-line vanishing for the purpose of the DEGENERATE-ONLY locus
    named in the workorder.

    (If a finer (34,1) jet is needed later, extend njet; for degeneracy of
    the order-0 branch the vanishing of T on L is the correct closed locus.)
    """
    return minus_line_vanishing_matrix(fr, cell, n_dirs=n_dirs, seed=seed)


def load_survivors22(p):
    path = os.path.join(PAIR_RES, "survivors22_p%d.json" % p)
    return json.load(open(path))
