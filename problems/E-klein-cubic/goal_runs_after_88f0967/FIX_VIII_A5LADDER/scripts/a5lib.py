"""FIX-VIII-A5LADDER core library.

Group G660 = PSL(2,11) acting on W = F_p^5 preserving the Klein cubic
F(x) = sum_i x_i^2 x_{i+1}.  A5 < G660 extraction, A5-Molien table for
map-type covariants Hom(S^d W, W)^{A5}, and construction of a basis by
Reynolds averaging in the monomial-coefficient basis.

All linear algebra mod p is done with float64 numpy matmuls: p <= 199 and
N <= 2000 so every intermediate product/sum is < 199*199*2000 = 7.9e7,
exactly representable in float64.
"""
import json, itertools, numpy as np

GATE = ('/Users/worker/unirational/problems/E-klein-cubic/'
        'goal_runs_after_ac61998/FIX_VII_GATE/payload/G660_p%d.json')


# ---------------------------------------------------------------- basic mod-p
def mm(A, B, p):
    """exact matrix product mod p via float64 BLAS"""
    return (np.asarray(A, dtype=np.float64) @ np.asarray(B, dtype=np.float64)) % p


def rref(M, p):
    """reduced row echelon form mod p; returns (R, pivot columns)."""
    M = np.array(M, dtype=np.float64) % p
    rows, cols = M.shape
    piv, r = [], 0
    for c in range(cols):
        if r >= rows:
            break
        nz = np.nonzero(M[r:, c])[0]
        if nz.size == 0:
            continue
        i = r + int(nz[0])
        if i != r:
            M[[r, i]] = M[[i, r]]
        M[r] = M[r] * pow(int(M[r, c]), p - 2, p) % p
        col = M[:, c].copy()
        col[r] = 0
        nzr = np.nonzero(col)[0]
        if nzr.size:
            M[nzr] = (M[nzr] - np.outer(col[nzr], M[r])) % p
        piv.append(c)
        r += 1
    return M[:r], piv


def rank_p(M, p):
    return rref(M, p)[0].shape[0]


def inv_p(A, p):
    """inverse of a square matrix mod p (None if singular)."""
    n = A.shape[0]
    M = np.concatenate([np.array(A, dtype=np.float64) % p, np.eye(n)], axis=1)
    R, piv = rref(M, p)
    if R.shape[0] != n or piv != list(range(n)):
        return None
    return R[:, n:] % p


def solve_p(A, B, p):
    """solve A X = B for square invertible A."""
    return mm(inv_p(A, p), B, p)


# ------------------------------------------------------------------ the group
def klein_F(x, p):
    return int(sum(int(x[i]) * int(x[i]) * int(x[(i + 1) % 5]) for i in range(5))) % p


def load_gens(p):
    d = json.load(open(GATE % p))
    assert d['p'] == p and d['linear_order'] == 660
    return [np.array(d['generators'][k], dtype=np.float64) % p for k in ('g11', 's5', 'S')]


def group_closure(gens, p, cap=2000):
    """BFS closure of a set of 5x5 matrices mod p."""
    key = lambda M: M.astype(np.int64).tobytes()
    seen = {key(np.eye(5))}
    elts = [np.eye(5, dtype=np.float64)]
    frontier = [np.eye(5, dtype=np.float64)]
    while frontier:
        new = []
        for A in frontier:
            for g in gens:
                B = mm(g, A, p)
                k = key(B)
                if k not in seen:
                    seen.add(k)
                    elts.append(B)
                    new.append(B)
                    if len(elts) > cap:
                        raise RuntimeError('closure exceeded cap')
        frontier = new
    return elts


def order_of(M, p):
    I = np.eye(5)
    A, k = M % p, 1
    while not np.array_equal(A, I):
        A = mm(A, M, p)
        k += 1
        if k > 700:
            raise RuntimeError('no finite order')
    return k


def a5_classes(G, p):
    """all A5 subgroups of G, grouped into G-conjugacy classes.

    Returns [(a, b, H)] with one representative per class, in scan order.
    PSL(2,11) has 22 subgroups isomorphic to A5 in two classes of 11."""
    key = lambda M: M.astype(np.int64).tobytes()
    ords = [order_of(M, p) for M in G]
    invs = [M for M, o in zip(G, ords) if o == 2]
    thr = [M for M, o in zip(G, ords) if o == 3]
    subs, seen = [], set()
    for a in invs:
        for b in thr:
            if order_of(mm(a, b, p), p) != 5:
                continue
            H = group_closure([a, b], p, cap=200)
            if len(H) != 60:
                continue
            S = frozenset(key(M) for M in H)
            if S in seen:
                continue
            seen.add(S)
            subs.append((S, a, b, H))
    reps = []
    for S, a, b, H in subs:
        new = True
        for S2, _, _, _ in reps:
            for g in G:
                gi = inv_p(g, p)
                if frozenset(key(mm(mm(g, M, p), gi, p)) for M in H) == S2:
                    new = False
                    break
            if not new:
                break
        if new:
            reps.append((S, a, b, H))
    return [(a, b, H) for _, a, b, H in reps], len(subs)


def find_A5(G, p, want=0):
    """Find (a, b) with a^2 = b^3 = (ab)^5 = 1 generating a group of order 60.

    `want` selects which A5 (0 = first found in the deterministic scan order).
    Returns (a, b, elements)."""
    ords = [order_of(M, p) for M in G]
    invs = [M for M, o in zip(G, ords) if o == 2]
    thr = [M for M, o in zip(G, ords) if o == 3]
    found = 0
    for a in invs:
        for b in thr:
            if order_of(mm(a, b, p), p) != 5:
                continue
            H = group_closure([a, b], p, cap=200)
            if len(H) != 60:
                continue
            if found == want:
                return a, b, H
            found += 1
    raise RuntimeError('no A5 found')


# ------------------------------------------------------------ A5 Molien table
def a5_molien(dmax):
    """dim Hom(S^d W, W)^{A5} for W|_{A5} = V5, chi = (5,1,-1,0,0).

    Classes 1, 2, 3, 5A, 5B with sizes 1,15,20,12,12.  Eigenvalues of W:
    1:[1]*5, 2:[1,1,1,-1,-1], 3:[1,w,w,w2,w2], 5A/5B: all fifth roots.
    Each multiset is closed under conjugation and chi_W is real, so
    chi_{S^d W*}(c) = h_d(eigs(c)) and mult = (1/60) sum |c| h_d chi_W.
    """
    import mpmath as mp
    mp.mp.dps = 60
    w = mp.e ** (2 * mp.pi * mp.mpc(0, 1) / 3)
    z5 = [mp.e ** (2 * mp.pi * mp.mpc(0, 1) * k / 5) for k in range(5)]
    EIG = {'1': [mp.mpf(1)] * 5, '2': [1, 1, 1, -1, -1],
           '3': [mp.mpf(1), w, w, w ** 2, w ** 2], '5A': z5, '5B': z5}
    SZ = {'1': 1, '2': 15, '3': 20, '5A': 12, '5B': 12}
    CHI = {'1': 5, '2': 1, '3': -1, '5A': 0, '5B': 0}
    for c in EIG:                                   # self-test: sum eig = chi
        assert abs(sum(EIG[c]) - CHI[c]) < 1e-40, c
    H = {}
    for c in EIG:
        ev = [mp.mpc(e) for e in EIG[c]]
        pw = [None] + [sum(e ** k for e in ev) for k in range(1, dmax + 1)]
        h = [mp.mpf(1)]
        for d in range(1, dmax + 1):
            h.append(sum(pw[k] * h[d - k] for k in range(1, d + 1)) / d)
        H[c] = h
    out = []
    for d in range(0, dmax + 1):
        s = sum(SZ[c] * H[c][d] * CHI[c] for c in EIG) / 60
        r = int(mp.nint(mp.re(s)))
        assert abs(s - r) < 1e-30, (d, s)
        out.append(r)
    return out


# ------------------------------------------------- monomials and substitution
def monlist(d):
    """exponent tuples of degree d in 5 variables, deterministic order"""
    return [tuple(e) for e in _compositions(d, 5)]


def _compositions(d, n):
    if n == 1:
        yield (d,)
        return
    for i in range(d, -1, -1):
        for rest in _compositions(d - i, n - 1):
            yield (i,) + rest


def monmat(pts, mons, p):
    """|pts| x |mons| evaluation matrix"""
    pts = np.asarray(pts, dtype=np.int64) % p
    P = np.ones((pts.shape[0], 5, max(m[i] for m in mons for i in range(5)) + 1),
                dtype=np.int64)
    for k in range(1, P.shape[2]):
        P[:, :, k] = P[:, :, k - 1] * pts % p
    A = np.ones((pts.shape[0], len(mons)), dtype=np.int64)
    for j, m in enumerate(mons):
        col = np.ones(pts.shape[0], dtype=np.int64)
        for i in range(5):
            if m[i]:
                col = col * P[:, i, m[i]] % p
        A[:, j] = col
    return A.astype(np.float64)


def rho_d(g, mons, pts, Xinv, p):
    """matrix of f(x) -> f(g^{-1} x) on degree-d forms in the monomial basis.

    pts = the interpolation points, Xinv = monmat(pts)^{-1}."""
    gi = inv_p(g, p)
    pts_g = mm(np.asarray(pts, dtype=np.float64), gi.T, p)
    return mm(Xinv, monmat(pts_g, mons, p), p)


def basis_points(d, p, rng, mons):
    """N points with invertible monomial matrix (N = #mons)."""
    N = len(mons)
    for _ in range(40):
        pts = rng.integers(0, p, size=(N, 5))
        X = monmat(pts, mons, p)
        Xi = inv_p(X, p)
        if Xi is not None:
            return pts, X, Xi
    raise RuntimeError('no invertible point set')


# ------------------------------------------------- covariant basis by Reynolds
def covariant_basis(d, p, a, b, rng, target=None, extra=10, verbose=False):
    """Basis of {T in Hom(S^d W, W) : T(g x) = g T(x) for g in A5}.

    Returned as an array (K, 5, N) of monomial-coefficient matrices, in
    row-reduced-echelon form w.r.t. the flattened (5N) coordinates.

    Method: Reynolds projector  Pi(C) = (1/60) sum_g g . C . rho_d(g)^T
    applied to random C, with the 60 group elements enumerated by BFS so
    only rho_d of the two generators is ever formed.
    """
    mons = monlist(d)
    N = len(mons)
    pts, X, Xi = basis_points(d, p, rng, mons)
    Rgen = {}
    for name, g in (('a', a), ('b', b)):
        Rgen[name] = rho_d(g, mons, pts, Xi, p).T % p     # C -> C @ R  is  x->g^{-1}x
    gens = {'a': a, 'b': b}

    B = 0
    basis = None
    nb0 = (target + extra) if target is not None else 24
    while True:
        nb = nb0 if basis is None else max(8, extra)
        C = rng.integers(0, p, size=(nb, 5, N)).astype(np.float64)
        acc = np.zeros_like(C)
        # BFS over A5: state = (5x5 matrix g, C @ R_g)
        key = lambda M: M.astype(np.int64).tobytes()
        seen = {key(np.eye(5))}
        cur = [(np.eye(5, dtype=np.float64), C)]
        acc += np.einsum('ij,bjn->bin', np.eye(5), C)
        cnt = 1
        while cur:
            nxt = []
            for gM, CR in cur:
                for name in ('a', 'b'):
                    g2 = mm(gens[name], gM, p)
                    k = key(g2)
                    if k in seen:
                        continue
                    seen.add(k)
                    CR2 = (CR.reshape(-1, N) @ Rgen[name]) % p
                    CR2 = CR2.reshape(-1, 5, N)
                    acc += np.einsum('ij,bjn->bin', g2, CR2)
                    acc %= p
                    nxt.append((g2, CR2))
                    cnt += 1
            cur = nxt
        assert cnt == 60, cnt
        acc = acc * pow(60, p - 2, p) % p
        flat = acc.reshape(-1, 5 * N)
        basis = flat if basis is None else np.concatenate([basis, flat], axis=0)
        R, _ = rref(basis, p)
        basis = R
        K = R.shape[0]
        if verbose:
            print('   d=%d  rank so far %d (samples %d)' % (d, K, basis.shape[0]))
        B += nb
        if B >= K + extra:
            break
    return basis.reshape(-1, 5, N), mons, Rgen


def check_equivariance(basis, mons, a, b, p, rng, ntest=6):
    """direct test T(g x) = g T(x) at random points"""
    ok = 0
    tot = 0
    for g in (a, b):
        for _ in range(ntest):
            x = rng.integers(0, p, size=5)
            gx = mm(g, x.astype(np.float64), p).ravel()
            mx = monmat([x], mons, p)[0]
            mgx = monmat([gx], mons, p)[0]
            for C in basis:
                lhs = (C @ mgx) % p
                rhs = mm(g, (C @ mx) % p, p).ravel() % p
                tot += 1
                ok += int(np.array_equal(lhs, rhs))
    return ok, tot
