#!/usr/bin/env python3
"""FIX-P1 Stage 2 -- shared library: the modular Weil frame and the jet engine.

Everything here is built FROM THE DEFINING FORMULAS (Gauss sum, S and T of the
5-dimensional Weil representation of PSL(2,11)); nothing is read from another
packet.  Self-tests are run by `build_frame` and must all pass.

WHY A MODULAR COMPUTATION STILL GIVES A CHARACTERISTIC-ZERO VERDICT.
Let R(s_1),...,R(s_N) be Reynolds averages of monomial seeds; they lie in the
O-lattice of M_d = (Sym^d W* (x) W)^G, O = Z[zeta_33] localised at a prime P
over p (p does not divide |G| = 660, so 1/|G| is a unit -- we drop it anyway,
which only rescales rows).  Let Phi be the matrix of chosen linear functionals
evaluated on those averages, over O.  Then

        rank_{O/P}(Phi mod P)  <=  rank_K(Phi) ,        K = Frac(O),

so  rank mod p = dim M_d  forces  rank_K = dim M_d , i.e. the functionals
are INJECTIVE on M_d over K -- hence over C.  A ZERO kernel mod p is therefore
a genuine characteristic-zero emptiness statement.  (A NONZERO kernel mod p is
NOT: it only bounds the char-0 kernel from above.  This asymmetry is the same
one FIX-N2b sec 2.4 used and is respected throughout.)

Also: using only a SUBSET of the linear functionals cut out by a vanishing
condition can only ENLARGE the computed kernel, so a zero computed kernel is
again decisive.  Random sampling is therefore safe on the emptiness side.
"""
import numpy as np

# --------------------------------------------------------------- F_p helpers


def inv_mod(a, p):
    return pow(int(a) % p, p - 2, p)


def rref_rank(M, p):
    """Rank of an integer matrix mod p (row echelon, in place)."""
    A = np.array(M, dtype=np.int64) % p
    rows, cols = A.shape
    r = 0
    for c in range(cols):
        piv = None
        for i in range(r, rows):
            if A[i, c]:
                piv = i
                break
        if piv is None:
            continue
        A[[r, piv]] = A[[piv, r]]
        A[r] = (A[r] * inv_mod(A[r, c], p)) % p
        col = A[r + 1:, c].copy()
        nz = np.nonzero(col)[0]
        if nz.size:
            A[r + 1 + nz] = (A[r + 1 + nz] - np.outer(col[nz], A[r])) % p
        r += 1
        if r == rows:
            break
    return r


def nullspace(M, p):
    """Basis (rows) of the right null space of M over F_p."""
    A = np.array(M, dtype=np.int64) % p
    rows, cols = A.shape
    piv_cols = []
    r = 0
    for c in range(cols):
        piv = None
        for i in range(r, rows):
            if A[i, c]:
                piv = i
                break
        if piv is None:
            continue
        A[[r, piv]] = A[[piv, r]]
        A[r] = (A[r] * inv_mod(A[r, c], p)) % p
        col = A[:, c].copy()
        col[r] = 0
        nz = np.nonzero(col)[0]
        if nz.size:
            A[nz] = (A[nz] - np.outer(col[nz], A[r])) % p
        piv_cols.append(c)
        r += 1
        if r == rows:
            break
    free = [c for c in range(cols) if c not in piv_cols]
    basis = []
    for f in free:
        v = np.zeros(cols, dtype=np.int64)
        v[f] = 1
        for i, c in enumerate(piv_cols):
            v[c] = (-A[i, f]) % p
        basis.append(v % p)
    return np.array(basis, dtype=np.int64) if basis else np.zeros(
        (0, cols), dtype=np.int64)


def mat_inv(A, p):
    n = A.shape[0]
    M = np.concatenate([A % p, np.eye(n, dtype=np.int64)], axis=1)
    r = 0
    for c in range(n):
        piv = None
        for i in range(r, n):
            if M[i, c]:
                piv = i
                break
        assert piv is not None, "singular"
        M[[r, piv]] = M[[piv, r]]
        M[r] = (M[r] * inv_mod(M[r, c], p)) % p
        col = M[:, c].copy()
        col[r] = 0
        nz = np.nonzero(col)[0]
        if nz.size:
            M[nz] = (M[nz] - np.outer(col[nz], M[r])) % p
        r += 1
    return M[:, n:] % p


# ------------------------------------------------- the Weil representation


def build_frame(p, verbose=True):
    """Return a dict with the group, the sigma/V4 frame, and all self-tests."""
    assert (p - 1) % 33 == 0, "need p = 1 mod 33 (zeta_11 and omega in F_p)"
    assert 660 % p != 0

    # zeta_11 of exact order 11
    z11 = None
    for a in range(2, p):
        c = pow(a, (p - 1) // 11, p)
        if c != 1:
            z11 = c
            break
    assert z11 is not None and pow(z11, 11, p) == 1
    zp = [pow(z11, i % 11, p) for i in range(11)]
    qr = {1, 3, 4, 5, 9}
    gs = sum((1 if a in qr else -1) * zp[a] for a in range(1, 11)) % p
    assert (gs * gs) % p == (-11) % p, "Gauss sum g^2 = -11 failed"

    js = [1, 3, 2, 5, 4]
    signs = [1, 1, -1, 1, 1]
    inv11 = inv_mod(11, p)
    S = np.zeros((5, 5), dtype=np.int64)
    for i, j in enumerate(js):
        for k, l in enumerate(js):
            sg = signs[k] * inv_mod(signs[i] % p, p) if signs[i] == -1 else \
                signs[k]
            sg = (signs[k] * signs[i]) % p       # signs are +-1 so 1/s = s
            val = (sg * (zp[(9 * j * l) % 11] - zp[(-9 * j * l) % 11]) %
                   p) * ((-gs) % p) % p * inv11 % p
            S[i, k] = val % p
    T = np.zeros((5, 5), dtype=np.int64)
    for i in range(5):
        T[i, i] = zp[(js[i] * js[i]) % 11]

    I5 = np.eye(5, dtype=np.int64)

    def mm(A, B):
        return (A @ B) % p

    def mpow(A, n):
        R = I5.copy()
        while n:
            if n & 1:
                R = mm(R, A)
            A = mm(A, A)
            n //= 2
        return R

    assert np.array_equal(mpow(S, 2), I5), "S^2 != 1"
    assert np.array_equal(mpow(T, 11), I5), "T^11 != 1"
    assert np.array_equal(mpow(mm(S, T), 3), I5), "(ST)^3 != 1"

    # BFS closure
    key = lambda A: A.tobytes()
    seen = {key(I5): 0}
    mats = [I5]
    frontier = [I5]
    while frontier:
        nxt = []
        for A in frontier:
            for gmat in (S, T):
                B = mm(A, gmat)
                k = key(B)
                if k not in seen:
                    seen[k] = len(mats)
                    mats.append(B)
                    nxt.append(B)
        frontier = nxt
    assert len(mats) == 660, ("group order", len(mats))
    RHO = np.array(mats, dtype=np.int64)                 # (660,5,5)
    RHOI = np.array([mat_inv(A, p) for A in mats], dtype=np.int64)

    # Klein cubic F = sum_i x_i^2 x_{i+1}  --  check invariance
    rng = np.random.default_rng(11)
    for _ in range(6):
        v = rng.integers(0, p, size=5)
        f0 = sum(int(v[i]) ** 2 * int(v[(i + 1) % 5]) for i in range(5)) % p
        for gi in range(0, 660, 37):
            w = (RHO[gi] @ v) % p
            f1 = sum(int(w[i]) ** 2 * int(w[(i + 1) % 5])
                     for i in range(5)) % p
            assert f0 == f1, "Klein cubic not invariant"

    # traces: the 2A class has trace 1, 3A trace -1 (character check)
    traces = np.array([int(np.trace(A)) % p for A in RHO])

    # --- sigma: an involution
    orders = []
    for A in RHO:
        o = 1
        B = A.copy()
        while not np.array_equal(B, I5):
            B = mm(B, A)
            o += 1
        orders.append(o)
    orders = np.array(orders)
    invol = [i for i in range(660) if orders[i] == 2]
    assert len(invol) == 55, ("involutions", len(invol))
    assert all(traces[i] % p == 1 % p for i in invol), "chi(2A) != 1"

    si = invol[0]
    sig = RHO[si]
    Wp = nullspace((sig - I5) % p, p)          # +1 eigenspace, rows
    Wm = nullspace((sig + I5) % p, p)          # -1 eigenspace, rows
    assert Wp.shape[0] == 3 and Wm.shape[0] == 2, (Wp.shape, Wm.shape)

    # --- a V4 containing sigma; its triple line
    K1 = None
    for tj in invol:
        if tj == si:
            continue
        tau = RHO[tj]
        if not np.array_equal(mm(sig, tau), mm(tau, sig)):
            continue
        M = np.concatenate([(sig - I5) % p, (tau - I5) % p], axis=0)
        fix = nullspace(M, p)
        if fix.shape[0] == 2:
            K1 = (si, tj, (RHO.tolist().index(mm(sig, tau).tolist())
                           if False else None))
            LINE = fix
            tau_idx = tj
            break
    assert K1 is not None, "no V4 with a 2-dimensional fixed space"
    # the third involution
    third = mm(sig, RHO[tau_idx])
    tk = seen[key(third)]
    assert orders[tk] == 2
    v4 = [si, tau_idx, tk]
    # all three plus-planes contain the line
    for t in v4:
        assert rref_rank(np.concatenate([(RHO[t] - I5) % p], axis=0) @
                         LINE.T % p, p) == 0, "line not fixed by V4"

    out = {
        "p": p, "RHO": RHO, "RHOI": RHOI, "S": S, "T": T,
        "sigma_index": si, "v4": v4,
        "Wplus": Wp, "Wminus": Wm, "LINE": LINE,
        "orders": orders, "traces": traces,
        "self_tests": ["g^2=-11", "S^2=1", "T^11=1", "(ST)^3=1",
                       "|G|=660", "F invariant", "55 involutions",
                       "chi(2A)=1", "dim W+=3, dim W-=2",
                       "V4 fixed space is a line (dim 2)"],
    }
    if verbose:
        print("[frame] p=%d  |G|=%d  involutions=%d  dim W+=%d dim W-=%d "
              "dim W^{V4}=%d" % (p, len(mats), len(invol), Wp.shape[0],
                                 Wm.shape[0], LINE.shape[0]))
    return out


# ------------------------------------------------------- the jet engine


def seed_exponents(nseeds, deg=25, seed=20260806):
    """Deterministic pseudo-random monomial exponents of total degree `deg`,
    together with a component index; returns (A, c0) with A of shape (n,5)."""
    import random
    from math import comb
    avail = 5 * comb(deg + 4, 4)
    if nseeds > avail:
        raise ValueError("only %d (monomial, component) seeds exist in degree "
                         "%d; asked for %d" % (avail, deg, nseeds))
    rnd = random.Random(seed)
    got = set()
    out = []
    while len(out) < nseeds:
        cuts = sorted(rnd.randrange(0, deg + 1) for _ in range(4))
        e = (cuts[0], cuts[1] - cuts[0], cuts[2] - cuts[1],
             cuts[3] - cuts[2], deg - cuts[3])
        c0 = rnd.randrange(5)
        if (e, c0) in got:
            continue
        got.add((e, c0))
        out.append((e, c0))
    A = np.array([e for e, _ in out], dtype=np.int64)
    C = np.array([c for _, c in out], dtype=np.int64)
    return A, C


def jet_rows(frame, A, C, W, Y, J, deg=25):
    """Rows of the jet-functional matrix.

    For each seed s = X^alpha e_{c0} and each pair (w, y) taken from the arrays
    W (npair,5) and Y (npair,5), returns the coefficients of t^0..t^{J-1} of

        R(s)_c( w + t y ) ,   R(s)(v) := sum_g rho(g)^{-1} s( rho(g) v ) ,

    for all five output components c.  Shape: (nseeds, npair, 5, J).

    (The 1/|G| of the Reynolds operator is dropped -- a unit rescaling that
    does not change any rank.)
    """
    p = frame["p"]
    RHO = frame["RHO"]
    RHOI = frame["RHOI"]
    ns = A.shape[0]
    npair = W.shape[0]
    res = np.zeros((ns, npair, 5, J), dtype=np.int64)

    def tmul(a, b):
        """Truncated product of t-series, arrays (..., J)."""
        out = np.zeros_like(a)
        for i in range(J):
            if i:
                out[..., i:] = (out[..., i:] +
                                a[..., i][..., None] * b[..., :J - i]) % p
            else:
                out = (out + a[..., 0][..., None] * b) % p
        return out % p

    for q in range(npair):
        u = (RHO @ W[q]) % p                 # (660,5)
        up = (RHO @ Y[q]) % p                # (660,5)
        # POW[j][m] = (u_j + t up_j)^m truncated, shape (660,J)
        POW = []
        for j in range(5):
            base = np.zeros((660, J), dtype=np.int64)
            base[:, 0] = u[:, j]
            if J > 1:
                base[:, 1] = up[:, j]
            cur = np.zeros((660, J), dtype=np.int64)
            cur[:, 0] = 1
            lst = [cur]
            for m in range(1, deg + 1):
                cur = tmul(cur, base)
                lst.append(cur)
            POW.append(np.stack(lst))        # (deg+1,660,J)
        P = POW[0][A[:, 0]]                  # (ns,660,J)
        for j in range(1, 5):
            P = tmul(P, POW[j][A[:, j]])
        # contract with rho(g)^{-1}[:, c0]
        for c0 in range(5):
            idx = np.nonzero(C == c0)[0]
            if idx.size == 0:
                continue
            Mg = RHOI[:, :, c0] % p          # (660,5)
            # res[idx,q,c,:] = sum_g Mg[g,c] * P[idx,g,:]
            res[idx, q] = np.einsum('sgj,gc->scj', P[idx], Mg) % p
    return res % p
