"""Hessian curve C_20 = Sing(V(H)), H = det Hess F, and point geometry.

F = sum_i x_i^2 x_{i+1}.  Second derivatives are linear:
  Hess[i,i]     = 2 x_{i+1}
  Hess[i,i+1]   = 2 x_i
  Hess[i,i-1]   = 2 x_{i-1}
H = det Hess is the classical quintic.  C = V(∂H) (Euler: 5H = <x,∇H>,
p != 5, so ∇H = 0 implies H = 0).
"""
from __future__ import annotations

import numpy as np

import slicelib as SL


def klein_F(x, p):
    x = np.asarray(x, dtype=np.int64) % p
    s = 0
    for i in range(5):
        s += int(x[i]) * int(x[i]) % p * int(x[(i + 1) % 5])
    return s % p


def hess_F(x, p):
    """5x5 Hessian matrix of F at x."""
    x = np.asarray(x, dtype=np.int64).reshape(-1) % p
    M = np.zeros((5, 5), dtype=np.int64)
    for i in range(5):
        M[i, i] = (2 * int(x[(i + 1) % 5])) % p
        M[i, (i + 1) % 5] = (2 * int(x[i])) % p
        M[i, (i - 1) % 5] = (2 * int(x[(i - 1) % 5])) % p
    return M % p


def det5(M, p):
    A = np.array(M, dtype=np.int64) % p
    det = 1
    for c in range(5):
        piv = None
        for i in range(c, 5):
            if A[i, c] % p:
                piv = i
                break
        if piv is None:
            return 0
        if piv != c:
            A[[c, piv]] = A[[piv, c]]
            det = (-det) % p
        inv = pow(int(A[c, c]), p - 2, p)
        det = det * int(A[c, c]) % p
        A[c] = (A[c] * inv) % p
        for i in range(c + 1, 5):
            if A[i, c] % p:
                A[i] = (A[i] - A[i, c] * A[c]) % p
    return det % p


def cofactor_matrix(M, p):
    """Cofactor matrix of a 5x5 (transpose of adjugate is not needed separately)."""
    M = np.asarray(M, dtype=np.int64) % p
    C = np.zeros((5, 5), dtype=np.int64)
    for i in range(5):
        for j in range(5):
            minor = np.delete(np.delete(M, i, axis=0), j, axis=1)
            C[i, j] = ((-1) ** (i + j) * det4(minor, p)) % p
    return C


def det4(M, p):
    A = np.array(M, dtype=np.int64) % p
    det = 1
    n = 4
    for c in range(n):
        piv = None
        for i in range(c, n):
            if A[i, c] % p:
                piv = i
                break
        if piv is None:
            return 0
        if piv != c:
            A[[c, piv]] = A[[piv, c]]
            det = (-det) % p
        inv = pow(int(A[c, c]), p - 2, p)
        det = det * int(A[c, c]) % p
        A[c] = (A[c] * inv) % p
        for i in range(c + 1, n):
            if A[i, c] % p:
                A[i] = (A[i] - A[i, c] * A[c]) % p
    return det % p


def H_eval(x, p):
    return det5(hess_F(x, p), p)


def dH_eval(x, p):
    """∇H at x via Jacobi: ∂det/∂x_k = sum_{ij} cofactor_{ij} ∂Hess_{ij}/∂x_k.

    Only three families of entries depend on x_k:
      Hess[k-1, k-1] = 2 x_k
      Hess[k,   k+1] = 2 x_k
      Hess[k+1, k  ] = 2 x_k
    """
    x = np.asarray(x, dtype=np.int64).reshape(-1) % p
    cof = cofactor_matrix(hess_F(x, p), p)
    out = np.zeros(5, dtype=np.int64)
    for k in range(5):
        s = 2 * int(cof[(k - 1) % 5, (k - 1) % 5])
        s += 2 * int(cof[k, (k + 1) % 5])
        s += 2 * int(cof[(k + 1) % 5, k])
        out[k] = s % p
    return out


def on_C(x, p):
    return not np.any(dH_eval(x, p) % p)


def fd_check_dH(p, n=8, seed=7):
    """Finite-difference check of ∇H (p > deg H + 2 = 7)."""
    rng = np.random.default_rng(seed)
    ok = 0
    for _ in range(n):
        x = rng.integers(0, p, size=5)
        dh = dH_eval(x, p)
        good = True
        for k in range(5):
            xp = x.copy()
            xp[k] = (int(xp[k]) + 1) % p
            xm = x.copy()
            xm[k] = (int(xm[k]) - 1) % p
            # H is degree 5; forward difference is not exact. Use symbolic
            # increment via 6-point? Simpler: H(x+t e_k) polynomial in t.
            ts = list(range(6))
            vals = []
            for t in ts:
                xt = x.copy()
                xt[k] = (int(x[k]) + t) % p
                vals.append(H_eval(xt, p))
            # interpolate degree-5 univariate; derivative at 0 is c1
            # Vandermonde on 0..5
            V = np.array([[pow(t, e, p) for e in range(6)] for t in ts],
                         dtype=np.int64) % p
            # solve V c = vals
            A = np.concatenate([V, np.array(vals, dtype=np.int64).reshape(6, 1)],
                               axis=1) % p
            r = 0
            for c in range(6):
                piv = None
                for i in range(r, 6):
                    if A[i, c] % p:
                        piv = i
                        break
                if piv is None:
                    continue
                A[[r, piv]] = A[[piv, r]]
                A[r] = (A[r] * pow(int(A[r, c]), p - 2, p)) % p
                for i in range(6):
                    if i != r and A[i, c] % p:
                        A[i] = (A[i] - A[i, c] * A[r]) % p
                r += 1
            c1 = int(A[1, 6]) % p
            if c1 != int(dh[k]) % p:
                good = False
                break
        ok += int(good)
    return ok, n


def normalize_pt(v, p):
    v = np.array(v, dtype=np.int64) % p
    for i in range(5):
        if int(v[i]) % p:
            inv = pow(int(v[i]), p - 2, p)
            return tuple(int(x) * inv % p for x in v)
    raise ValueError("zero vector")


def first_involution(fr, p):
    orders = fr["orders"]
    for g in range(660):
        if orders[g] == 2:
            return g
    raise RuntimeError("no involution")


def plus_minus(fr, g, p):
    Z = fr["RHO"][g] % p
    I5 = np.eye(5, dtype=np.int64)
    Wp = SL.nullspace((Z - I5) % p, p)
    Wm = SL.nullspace((Z + I5) % p, p)
    return Wp % p, Wm % p


def batch_hess(X, p):
    """X: (n,5) -> Hess F: (n,5,5)."""
    X = np.asarray(X, dtype=np.int64) % p
    n = X.shape[0]
    M = np.zeros((n, 5, 5), dtype=np.int64)
    for i in range(5):
        M[:, i, i] = (2 * X[:, (i + 1) % 5]) % p
        M[:, i, (i + 1) % 5] = (2 * X[:, i]) % p
        M[:, i, (i - 1) % 5] = (2 * X[:, (i - 1) % 5]) % p
    return M


def _perm_sign(perm):
    perm = list(perm)
    seen = [False] * 5
    sgn = 1
    for i in range(5):
        if seen[i]:
            continue
        j, ln = i, 0
        while not seen[j]:
            seen[j] = True
            j = perm[j]
            ln += 1
        if ln % 2 == 0:
            sgn = -sgn
    return sgn


_PERMS5 = None
_SIGNS5 = None


def _perms5():
    global _PERMS5, _SIGNS5
    if _PERMS5 is None:
        import itertools
        _PERMS5 = list(itertools.permutations(range(5)))
        _SIGNS5 = [_perm_sign(p) for p in _PERMS5]
    return _PERMS5, _SIGNS5


def batch_det5(M, p):
    perms, signs = _perms5()
    acc = np.zeros(M.shape[0], dtype=np.int64)
    for perm, sgn in zip(perms, signs):
        term = np.ones(M.shape[0], dtype=np.int64)
        for i in range(5):
            term = (term * M[:, i, perm[i]]) % p
        acc = (acc + sgn * term) % p
    return acc % p


def batch_dH(X, p):
    """∇H at a batch of points. Uses the 3-term Jacobi formula with 4x4 cofactors."""
    import itertools
    X = np.asarray(X, dtype=np.int64) % p
    M = batch_hess(X, p)
    n = X.shape[0]
    # cofactors C_ij via 4x4 Leibniz
    C = np.zeros((n, 5, 5), dtype=np.int64)
    perms4 = list(itertools.permutations(range(4)))

    def sgn4(perm):
        perm = list(perm)
        seen = [False] * 4
        s = 1
        for i in range(4):
            if seen[i]:
                continue
            j, ln = i, 0
            while not seen[j]:
                seen[j] = True
                j = perm[j]
                ln += 1
            if ln % 2 == 0:
                s = -s
        return s

    signs4 = [sgn4(pr) for pr in perms4]
    idx = [0, 1, 2, 3, 4]
    for i in range(5):
        for j in range(5):
            rows = [a for a in idx if a != i]
            cols = [b for b in idx if b != j]
            acc = np.zeros(n, dtype=np.int64)
            for pr, sg in zip(perms4, signs4):
                term = np.ones(n, dtype=np.int64)
                for a in range(4):
                    term = (term * M[:, rows[a], cols[pr[a]]]) % p
                acc = (acc + sg * term) % p
            C[:, i, j] = ((-1) ** (i + j) * acc) % p
    out = np.zeros((n, 5), dtype=np.int64)
    for k in range(5):
        s = 2 * C[:, (k - 1) % 5, (k - 1) % 5]
        s = s + 2 * C[:, k, (k + 1) % 5]
        s = s + 2 * C[:, (k + 1) % 5, k]
        out[:, k] = s % p
    return out


def scan_plane(basis, p):
    """Projective points of P(span(basis)) at which ∇H = 0. Vectorized charts."""
    basis = np.asarray(basis, dtype=np.int64) % p
    r = basis.shape[0]
    found = []
    for nfix in range(r):
        nfree = r - 1 - nfix
        total = p ** nfree if nfree else 1
        n = np.arange(total, dtype=np.int64)
        coeff = np.zeros((total, r), dtype=np.int64)
        coeff[:, nfix] = 1
        m = n
        for k in range(r - 1, nfix, -1):
            coeff[:, k] = m % p
            m = m // p
        X = (coeff @ basis) % p
        dH = batch_dH(X, p)
        keep = np.nonzero(np.all(dH % p == 0, axis=1))[0]
        for t in keep:
            found.append(normalize_pt(X[t], p))
    return sorted(set(found))


def g_orbit_points(fr, seeds, p):
    RHO = fr["RHO"]
    out = set()
    for s in seeds:
        v = np.array(s, dtype=np.int64) % p
        for g in range(660):
            out.add(normalize_pt((RHO[g] @ v) % p, p))
    return sorted(out)


def hessian_sextet_orbit(fr, p, involution=None):
    """F_p-points of C in one plus-plane, then G-orbit.

    At many primes the Hessian sextet is not F_p-rational (GATE at p=67
    found |C(F_67)|=60 = the C11-orbit only).  n_sextet = 0 is allowed.
    """
    g = first_involution(fr, p) if involution is None else involution
    Wp, Wm = plus_minus(fr, g, p)
    sextet = scan_plane(Wp, p)
    minus_pts = scan_plane(Wm, p)
    orbit = g_orbit_points(fr, sextet, p) if sextet else []
    return {
        "involution": int(g),
        "plus_dim": int(Wp.shape[0]),
        "minus_dim": int(Wm.shape[0]),
        "sextet": [list(q) for q in sextet],
        "n_sextet": len(sextet),
        "n_minus": len(minus_pts),
        "minus_empty": len(minus_pts) == 0,
        "orbit": [list(q) for q in orbit],
        "n_orbit": len(orbit),
    }


def random_plane_C_points(p, nplanes=8, seed=20260812):
    """F_p-points of C found by scanning random P^2s in P^4."""
    rng = np.random.default_rng(seed + p)
    found = []
    per = []
    for _ in range(nplanes):
        B = rng.integers(0, p, size=(3, 5))
        if SL.rref_rank(B, p) < 3:
            continue
        pts = scan_plane(B, p)
        per.append(len(pts))
        found.extend(pts)
    uniq = sorted(set(found))
    return uniq, per


def tangent_to_C(pt, p):
    """A tangent vector to C at a smooth F_p-point, or None.

    T_P C = ker Hess(H)(P); Euler puts P itself in the kernel.
    """
    # Hess(H) via directional derivatives of ∇H
    P = np.array(pt, dtype=np.int64) % p
    H2 = np.zeros((5, 5), dtype=np.int64)
    d0 = dH_eval(P, p)
    for j in range(5):
        Q = P.copy()
        Q[j] = (int(Q[j]) + 1) % p
        # ∇H is degree 4; interpolate along e_j
        ts = list(range(5))
        cols = []
        for t in ts:
            Xt = P.copy()
            Xt[j] = (int(P[j]) + t) % p
            cols.append(dH_eval(Xt, p))
        V = np.array([[pow(t, e, p) for e in range(5)] for t in ts],
                     dtype=np.int64) % p
        for coord in range(5):
            vals = np.array([int(c[coord]) for c in cols], dtype=np.int64)
            A = np.concatenate([V, vals.reshape(5, 1)], axis=1) % p
            r = 0
            for c in range(5):
                piv = None
                for i in range(r, 5):
                    if A[i, c] % p:
                        piv = i
                        break
                if piv is None:
                    continue
                A[[r, piv]] = A[[piv, r]]
                A[r] = (A[r] * pow(int(A[r, c]), p - 2, p)) % p
                for i in range(5):
                    if i != r and A[i, c] % p:
                        A[i] = (A[i] - A[i, c] * A[r]) % p
                r += 1
            H2[coord, j] = int(A[1, 5]) % p
    K = SL.nullspace(H2 % p, p)
    for row in K:
        if SL.rref_rank(np.stack([P, row]) % p, p) == 2:
            return (row % p), int(K.shape[0])
    return None, int(K.shape[0])


def primitive_11th_root(p):
    for a in range(2, p):
        c = pow(a, (p - 1) // 11, p)
        if c != 1:
            return c
    raise RuntimeError("no primitive 11th root in F_%d" % p)


def c11_points(fr, p):
    """60 eigenpoints of the 12 C11-subgroups (all on X and on C)."""
    RHO, orders = fr["RHO"], fr["orders"]
    gens = [g for g in range(660) if orders[g] == 11]
    if len(gens) != 120:
        raise AssertionError("expected 120 order-11 elements, got %d" % len(gens))
    z11 = primitive_11th_root(p)
    I5 = np.eye(5, dtype=np.int64)
    mat_to_idx = {tuple(int(x) for x in (RHO[h] % p).ravel()): h
                  for h in range(660)}
    frames = []
    seen_g = set()
    all_pts = []
    for g in gens:
        if g in seen_g:
            continue
        G = RHO[g] % p
        M = I5.copy()
        for _ in range(11):
            key = tuple(int(x) for x in M.ravel())
            hit = mat_to_idx.get(key)
            if hit is None:
                raise AssertionError("C11 power not in frame")
            if orders[hit] == 11:
                seen_g.add(hit)
            M = (M @ G) % p
        pts = []
        for k in range(11):
            ns = SL.nullspace((G - pow(z11, k, p) * I5) % p, p)
            if ns.shape[0] == 0:
                continue
            if ns.shape[0] != 1:
                raise AssertionError("C11 weight dim %d" % ns.shape[0])
            pts.append(normalize_pt(ns[0], p))
        uniq = []
        seenp = set()
        for pt in pts:
            if pt not in seenp:
                seenp.add(pt)
                uniq.append(pt)
        if len(uniq) != 5:
            raise AssertionError("eigenframe size %d" % len(uniq))
        frames.append(uniq)
        all_pts.extend(uniq)
    unique = []
    seen = set()
    for pt in all_pts:
        if pt not in seen:
            seen.add(pt)
            unique.append(pt)
    if len(unique) != 60:
        raise AssertionError("C11 unique count %d" % len(unique))
    rec = {
        "p": p,
        "n_order11_elements": 120,
        "n_frames": len(frames),
        "n_points": 60,
        "all_on_X": all(klein_F(pt, p) == 0 for pt in unique),
        "all_on_C": all(on_C(pt, p) for pt in unique),
        "points": [list(pt) for pt in unique],
    }
    return rec, unique
