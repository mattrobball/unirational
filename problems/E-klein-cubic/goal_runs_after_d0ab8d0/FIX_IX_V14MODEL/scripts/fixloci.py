"""Correct joint-eigenspace (= projective fixed locus) machinery, valid for
non-abelian subgroups too, plus an F_p-point solver for small linear sections."""
import numpy as np

import fp
import geom
import v14lib as V


def eigenvalues(D, p):
    """Eigenvalues of D in F_p (roots of the characteristic polynomial)."""
    n = len(D)
    out = []
    for lam in range(p):
        Y = fp.madd(D, fp.scal(fp.ident(n), (-lam) % p, p), p)
        if len(fp.nullspace(Y, p)) > 0:
            out.append(lam)
    return out


def fixed_pieces(mats10, p):
    """Projective fixed locus of <mats> on P(M): list of (char, basis).

    A point is fixed iff its line is a 1-dim subrepresentation, i.e. the vector
    is a common eigenvector.  The joint eigenspace for a character (l_1..l_k)
    is  ker[ D_1 - l_1 ; ... ; D_k - l_k ]  -- a stacked kernel, correct for
    non-commuting generators as well.
    """
    n = len(mats10[0])
    evs = [eigenvalues(D, p) for D in mats10]
    pieces = []

    def rec(i, chosen):
        if i == len(mats10):
            rows = []
            for D, lam in zip(mats10, chosen):
                Y = fp.madd(D, fp.scal(fp.ident(n), (-lam) % p, p), p)
                rows.extend(Y)
            ns = fp.nullspace(rows, p)
            if ns:
                pieces.append((tuple(chosen), fp.rowspace_basis(ns, p)))
            return
        for lam in evs[i]:
            rec(i + 1, chosen + [lam])

    rec(0, [])
    return pieces


# ------------------------------------------------------------------ points

def _sqrt_table(p):
    t = -np.ones(p, dtype=np.int64)
    x = np.arange(p, dtype=np.int64)
    t[(x * x) % p] = x
    return t


def points_in_P(quads, d, p):
    """All F_p-points of the common zero locus of `quads` (dicts on d vars)
    inside P^{d-1}.  Exhaustive; intended for d <= 4."""
    if d == 1:
        y = [1]
        return [y] if not any(V.eval_quads(quads, y, p)) else []
    st = _sqrt_table(p)
    pts = []
    # charts: leading 1 in position k, zeros before it
    for k in range(d):
        free = d - 1 - k
        if free == 0:
            y = [0] * d
            y[k] = 1
            if not any(V.eval_quads(quads, y, p)):
                pts.append(y)
            continue
        # enumerate the first free-1 coordinates, solve the last quadratically
        head = np.zeros((1, 0), dtype=np.int64)
        for _ in range(free - 1):
            reps = np.repeat(head, p, axis=0)
            tail = np.tile(np.arange(p, dtype=np.int64), head.shape[0]).reshape(-1, 1)
            head = np.concatenate([reps, tail], axis=1)
        # build full coordinate array with the last coordinate symbolic
        Nn = head.shape[0]
        base = np.zeros((Nn, d), dtype=np.int64)
        base[:, k] = 1
        for j in range(free - 1):
            base[:, k + 1 + j] = head[:, j]
        last = d - 1
        # pick the quadric with the fewest degenerate rows in the last variable
        best = None
        for q in quads:
            A, B, C = _quad_coeffs(q, base, last, p)
            ndeg = int((((A % p) == 0) & ((B % p) == 0) & ((C % p) == 0)).sum())
            if best is None or ndeg < best[0]:
                best = (ndeg, A, B, C)
            if ndeg == 0:
                break
        _, A, B, C = best
        cand = _solve_quadratic(A, B, C, st, p)
        for arr, mask in cand:
            if not mask.any():
                continue
            sel = base[mask].copy()
            sel[:, last] = arr[mask]
            keep = np.ones(sel.shape[0], dtype=bool)
            for q in quads:
                vals = _eval_np(q, sel, p)
                keep &= (vals == 0)
                if not keep.any():
                    break
            for row in sel[keep]:
                pts.append([int(x) for x in row])
    # dedup
    seen, out = set(), []
    for y in pts:
        t = tuple(y)
        if t not in seen:
            seen.add(t)
            out.append(y)
    return out


def _quad_coeffs(q, base, last, p):
    """Write q(base with x_last = t) = A t^2 + B t + C."""
    n = base.shape[0]
    A = np.zeros(n, dtype=np.int64)
    B = np.zeros(n, dtype=np.int64)
    C = np.zeros(n, dtype=np.int64)
    for (a, b), c in q.items():
        if a == last and b == last:
            A = (A + c) % p
        elif a == last:
            B = (B + c * base[:, b]) % p
        elif b == last:
            B = (B + c * base[:, a]) % p
        else:
            C = (C + c * base[:, a] * base[:, b]) % p
    return A % p, B % p, C % p


def _solve_quadratic(A, B, C, st, p):
    """Return list of (roots_array, mask) covering all solutions of A t^2+B t+C=0."""
    out = []
    Az = (A % p) == 0
    Bz = (B % p) == 0
    # degenerate: A = B = 0 -> every t works iff C = 0 (handle by scanning t)
    deg = Az & Bz & ((C % p) == 0)
    if deg.any():
        for t in range(p):
            out.append((np.full(A.shape, t, dtype=np.int64), deg))
    lin = Az & ~Bz
    if lin.any():
        r = (-C % p) * pow_arr(B, p - 2, p) % p
        out.append((r, lin))
    quad = ~Az
    if quad.any():
        inv2a = pow_arr((2 * A) % p, p - 2, p)
        disc = (B * B - 4 * A * C) % p
        s = st[disc]
        ok = quad & (s >= 0)
        if ok.any():
            r1 = ((-B + s) % p) * inv2a % p
            r2 = ((-B - s) % p) * inv2a % p
            out.append((r1, ok))
            out.append((r2, ok))
    return out


def pow_arr(a, e, p):
    r = np.ones_like(a)
    b = a % p
    while e:
        if e & 1:
            r = r * b % p
        b = b * b % p
        e >>= 1
    return r


def _eval_np(q, X, p):
    v = np.zeros(X.shape[0], dtype=np.int64)
    for (a, b), c in q.items():
        v = (v + c * X[:, a] % p * X[:, b]) % p
    return v % p


# ------------------------------------------------------------------ orbits

def normalize(y, p):
    for x in y:
        if x % p:
            iv = fp.inv(x, p)
            return tuple((v * iv) % p for v in y)
    return tuple(0 for _ in y)


def orbit(y10, mats10_all, p):
    seen = set()
    for D in mats10_all:
        seen.add(normalize(fp.matvec(D, y10, p), p))
    return seen


def stabilizer_order(y10, mats10_all, p):
    key0 = normalize(y10, p)
    return sum(1 for D in mats10_all if normalize(fp.matvec(D, y10, p), p) == key0)
