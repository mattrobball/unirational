#!/usr/bin/env python3
"""D34_GUIDED_SWEEP, engine 1 -- the EXACT dimension ledger at d = 34.

Everything here is exact.  All characters are evaluated in F_P for a prime

        P = 1 (mod 330),    P > 5 * dim Sym^34 W* = 369075,

so every root of unity of every element order in {1,2,3,5,6,11} lives in F_P,
1/|G| = 1/660 is a unit, and every dimension computed is an integer in
[0, 369075] hence determined UNIQUELY by its residue mod P.  No floating point,
no cyclotomic-field arithmetic, no rounding.

Two independent code paths compute every number:

  PATH A -- abstract character theory.  The 8 conjugacy classes of PSL(2,11)
            with their sizes and the eigenvalue weight-multisets of W recorded
            in STAGE2_ODD_ORDER_PINNING sec.0; and for the point/line/plane
            stabilisers the abstract character tables of D12 = C2 x S3,
            A4 = N_G(V4), C6 = Stab(eigenline), D10 = Stab(D10-point),
            using the sealed restriction data
                W^+ = 1 |X| (triv + std),   W^- = eps |X| std   (D12),
                W|_{A4} = omega + omega^2 + Theta,  W^{V4} = omega + omega^2.
  PATH B -- brute force on the explicit modular Weil frame: the 660 matrices
            built by slicelib.build_frame(P) from the Gauss-sum formulas, the
            actual subgroups found inside them by centraliser/normaliser
            search, and symmetric-power characters read off char polys via
            chi_{Sym^k V}(g) = [t^k] 1/det(1 - t . g|_V).

PATH A never looks at a matrix; PATH B never looks at a character table.  They
must agree on every entry.

Quantities produced (d = 34 unless noted):

    dim M_d = dim (Sym^d W* (x) W)^G                       d = 0..40
    N_plane   = dim (Sym^d (W^+)* (x) W)^{D12}         [55 plus-planes, ord 1]
    N_minus   = dim (Sym^d (W^-)* (x) W)^{D12}         [55 minus-lines, ord 1]
    N_line(r) = dim (+)_{k<r} (Sym^k Q* (x) Sym^{d-k} U* (x) W)^{A4}
                                                       [55 V4-lines, ord r]
    N_c3      = dim (Sym^d (W_w)* (x) (W/<p_w>))^{C6}  [110 C3-eigenlines]
    N_D10     = dim W^{D10}                            [66 D10-points]
    N_C6pt    = dim W^{C6}                             [110 X^{C6} points]
    N_D12pt   = dim W^{D12}                            [55 D12-points]

Usage:  python3 produce_dims34.py [P]
"""
import json
import os
import sys

import numpy as np

import slicelib as SL

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
DMAX = 40
DEG = 34

# --------------------------------------------------------------------- prime


def big_prime(lo=400000):
    """smallest prime  = 1 (mod 330)  above `lo`."""
    def isp(n):
        if n < 2:
            return False
        for q in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37):
            if n % q == 0:
                return n == q
        d, s = n - 1, 0
        while d % 2 == 0:
            d //= 2
            s += 1
        for a in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37):
            x = pow(a, d, n)
            if x in (1, n - 1):
                continue
            for _ in range(s - 1):
                x = x * x % n
                if x == n - 1:
                    break
            else:
                return False
        return True
    n = lo + (1 - lo) % 330
    while not isp(n):
        n += 330
    return n


def root_of_unity(P, n):
    """an element of F_P of exact multiplicative order n."""
    assert (P - 1) % n == 0
    for a in range(2, P):
        c = pow(a, (P - 1) // n, P)
        if all(pow(c, n // q, P) != 1 for q in set(prime_factors(n))):
            return c
    raise RuntimeError


def prime_factors(n):
    out = []
    d = 2
    while d * d <= n:
        while n % d == 0:
            out.append(d)
            n //= d
        d += 1
    if n > 1:
        out.append(n)
    return out


# ------------------------------------------------- complete homogeneous h_k


def h_series(eigs, kmax, P):
    """[h_0..h_kmax] with h_k = sum of all degree-k monomials in `eigs`
    = [t^k] prod 1/(1 - e t).  Exact in F_P."""
    h = [0] * (kmax + 1)
    h[0] = 1
    for e in eigs:
        e = int(e) % P
        for k in range(1, kmax + 1):
            h[k] = (h[k] + e * h[k - 1]) % P
    return h


def h_from_matrix(M, kmax, P):
    """chi_{Sym^k V}(g) for g|_V = M, via 1/det(1 - tM) as a power series.
    Uses only the char poly, so no eigenvalues are extracted."""
    n = M.shape[0]
    # det(I - tM) = sum_j (-1)^j e_j(M) t^j  -- Faddeev-LeVerrier free version:
    # compute coefficients by expanding det(I - tM) with fraction-free
    # Gaussian elimination over F_P[t]/(t^{n+1}).
    # simplest exact route: c(t) = det(I - tM) has degree n; interpolate it at
    # n+1 points of F_P.
    xs = list(range(n + 1))
    ys = []
    for x in xs:
        A = (np.eye(n, dtype=np.int64) - x * M) % P
        ys.append(det_modp(A, P))
    coef = lagrange_coeffs(xs, ys, P)
    # invert the series
    inv = [0] * (kmax + 1)
    inv[0] = SL.inv_mod(coef[0], P)
    for k in range(1, kmax + 1):
        s = 0
        for j in range(1, min(k, n) + 1):
            s = (s + coef[j] * inv[k - j]) % P
        inv[k] = (-s * inv[0]) % P
    return inv


def det_modp(A, P):
    A = np.array(A, dtype=np.int64) % P
    n = A.shape[0]
    det = 1
    r = 0
    for c in range(n):
        piv = None
        for i in range(r, n):
            if A[i, c]:
                piv = i
                break
        if piv is None:
            return 0
        if piv != r:
            A[[r, piv]] = A[[piv, r]]
            det = (-det) % P
        det = det * int(A[r, c]) % P
        A[r] = (A[r] * SL.inv_mod(A[r, c], P)) % P
        col = A[r + 1:, c].copy()
        nz = np.nonzero(col)[0]
        if nz.size:
            A[r + 1 + nz] = (A[r + 1 + nz] - np.outer(col[nz], A[r])) % P
        r += 1
    return det % P


def lagrange_coeffs(xs, ys, P):
    """coefficients of the interpolating polynomial, exact in F_P."""
    n = len(xs)
    coef = [0] * n
    for i in range(n):
        # basis poly prod_{j!=i} (t - x_j) / (x_i - x_j)
        num = [1] + [0] * (n - 1)
        deg = 0
        den = 1
        for j in range(n):
            if j == i:
                continue
            new = [0] * n
            for k in range(deg + 1):
                new[k + 1] = (new[k + 1] + num[k]) % P
                new[k] = (new[k] - xs[j] * num[k]) % P
            num = new
            deg += 1
            den = den * ((xs[i] - xs[j]) % P) % P
        f = ys[i] * SL.inv_mod(den, P) % P
        for k in range(n):
            coef[k] = (coef[k] + f * num[k]) % P
    return coef


# ------------------------------------------------------- PATH A: class table
# (order n, class size, weight multiset of W mod n)  -- STAGE2 THEOREM.md sec.0
CLASSES = [
    ("1A", 1, 1, [0, 0, 0, 0, 0]),
    ("2A", 2, 55, [0, 0, 0, 1, 1]),
    ("3A", 3, 110, [0, 1, 1, 2, 2]),
    ("5A", 5, 132, [0, 1, 2, 3, 4]),
    ("5B", 5, 132, [0, 2, 4, 1, 3]),
    ("6A", 6, 110, [0, 1, 2, 4, 5]),
    ("11A", 11, 60, [1, 3, 4, 5, 9]),
    ("11B", 11, 60, [2, 6, 7, 8, 10]),
]


def pathA_dimM(P, dmax=DMAX):
    """dim (Sym^d W* (x) W)^G for d = 0..dmax, from the class table alone."""
    tot = [0] * (dmax + 1)
    chi = {}
    for name, n, size, wts in CLASSES:
        z = root_of_unity(P, n) if n > 1 else 1
        ev = [pow(z, w, P) for w in wts]                 # eigenvalues on W
        evstar = [SL.inv_mod(e, P) for e in ev]          # eigenvalues on W*
        h = h_series(evstar, dmax, P)
        chiW = sum(ev) % P
        chi[name] = chiW
        for d in range(dmax + 1):
            tot[d] = (tot[d] + size * h[d] * chiW) % P
    inv660 = SL.inv_mod(660, P)
    return [tot[d] * inv660 % P for d in range(dmax + 1)], chi


def pathA_selftest(P, chi):
    """<chi_W, chi_W> = 1 and <chi_W, 1> = 0, exactly in F_P."""
    s1 = s0 = 0
    for name, n, size, wts in CLASSES:
        z = root_of_unity(P, n) if n > 1 else 1
        ev = [pow(z, w, P) for w in wts]
        c = sum(ev) % P
        cbar = sum(SL.inv_mod(e, P) for e in ev) % P
        s1 = (s1 + size * c * cbar) % P
        s0 = (s0 + size * c) % P
    inv660 = SL.inv_mod(660, P)
    return s1 * inv660 % P, s0 * inv660 % P


def D12_classes(P):
    """(label, size, eigenvalues on W^+, eigenvalues on W^-) for D12 = C2 x S3,
    from the sealed restrictions W^+ = 1 |X| (triv+std), W^- = eps |X| std."""
    w3 = root_of_unity(P, 3)
    m1 = P - 1
    return [
        ("1", 1, [1, 1, 1], [1, 1]),
        ("r3=sigma", 1, [1, 1, 1], [m1, m1]),
        ("r2,r4", 2, [1, w3, w3 * w3 % P], [w3, w3 * w3 % P]),
        ("r,r5", 2, [1, w3, w3 * w3 % P], [m1 * w3 % P, m1 * w3 * w3 % P]),
        ("s,r2s,r4s", 3, [1, 1, m1], [1, m1]),
        ("r3s,rs,r5s", 3, [1, 1, m1], [m1, 1]),
    ]


def N_leading(P, d, m):
    """STAGE1_COMPLEX_MAPS' order-0 leading-datum count

        N(d,m) = dim ( Sym^{d-m}(W^+)* (x) Sym^m (W^-)* (x) W^- )^{D12} .

    Recomputed here from the abstract D12 table alone, as an independent
    check on the consumed STAGE1 figure N(34,1) = 397."""
    tot = 0
    for lab, size, ep, em in D12_classes(P):
        hp = h_series([SL.inv_mod(e, P) for e in ep], d, P)
        hm = h_series([SL.inv_mod(e, P) for e in em], d, P)
        tot = (tot + size * hp[d - m] * hm[m] * (sum(em) % P)) % P
    return tot * SL.inv_mod(12, P) % P


# ------------- PATH A: the stabiliser targets from abstract character tables
# D12 = <sigma> x S3.  Elements listed as (label, size, order,
#   eigenvalues on W^+, on W^-, on W)  -- see THEOREM.md sec.2 for the source.
def pathA_targets(P, d=DEG, r=6):
    w3 = root_of_unity(P, 3)
    w6 = root_of_unity(P, 6)
    m1 = P - 1
    # ---- D12 : classes (label, size, W+ eigs, W- eigs)
    D12 = [
        ("1", 1, [1, 1, 1], [1, 1]),
        ("r3=sigma", 1, [1, 1, 1], [m1, m1]),
        ("r2,r4", 2, [1, w3, w3 * w3 % P], [w3, w3 * w3 % P]),
        ("r,r5", 2, [1, w3, w3 * w3 % P],
         [m1 * w3 % P, m1 * w3 * w3 % P]),
        ("s,r2s,r4s", 3, [1, 1, m1], [1, m1]),
        ("r3s,rs,r5s", 3, [1, 1, m1], [m1, 1]),
    ]
    NA = NB = 0
    for lab, size, ep, em in D12:
        chiW = (sum(ep) + sum(em)) % P
        hp = h_series([SL.inv_mod(e, P) for e in ep], d, P)
        hm = h_series([SL.inv_mod(e, P) for e in em], d, P)
        NA = (NA + size * hp[d] * chiW) % P
        NB = (NB + size * hm[d] * chiW) % P
    inv12 = SL.inv_mod(12, P)
    NA = NA * inv12 % P
    NB = NB * inv12 % P

    # ---- A4 = N_G(V4) = Stab(ell_V).  W|_{A4} = omega + omega^2 + Theta,
    #      U = W^{V4} = omega + omega^2 (the line),  Q = W/U = Theta.
    # A4 classes: 1 (size 1), the three involutions (size 3),
    #             two classes of 3-cycles (size 4 each).
    # characters: omega(1)=1, omega(inv)=1, omega(c)=w3, omega(c^2)=w3^2
    #             Theta(1)=3, Theta(inv)=-1, Theta(c)=Theta(c^2)=0
    # eigenvalues: on U = omega+omega^2 ; on Theta.
    A4 = [
        ("1", 1, [1, 1], [1, 1, 1]),
        ("inv", 3, [1, 1], [1, m1, m1]),
        ("c", 4, [w3, w3 * w3 % P], [1, w3, w3 * w3 % P]),
        ("c2", 4, [w3 * w3 % P, w3], [1, w3 * w3 % P, w3]),
    ]
    NC = 0
    for lab, size, eu, eq in A4:
        chiW = (sum(eu) + sum(eq)) % P
        hu = h_series([SL.inv_mod(e, P) for e in eu], d, P)
        hq = h_series([SL.inv_mod(e, P) for e in eq], r, P)
        s = 0
        for k in range(r):
            s = (s + hq[k] * hu[d - k]) % P
        NC = (NC + size * s * chiW) % P
    NC = NC * SL.inv_mod(12, P) % P

    # ---- C6 = Stab(C3-eigenline ell_w).  Generator t of order 6 has weights
    #      {0,1,2,4,5} on W;  ell_w = W_w(rho), rho = t^2 (rho-weight = a mod 3)
    #      w = 1  =>  ell_1 = <v_1, v_4>,  the X^{C6} point on it is v_1.
    #      target = Sym^d(ell_1)* (x) (W / <v_1>) .
    N3 = 0
    for j in range(6):
        t = pow(w6, j, P)
        eW = [pow(t, a, P) for a in (0, 1, 2, 4, 5)]
        eL = [pow(t, a, P) for a in (1, 4)]              # ell_1
        eQ = [pow(t, a, P) for a in (0, 2, 4, 5)]        # W / <v_1>
        h = h_series([SL.inv_mod(e, P) for e in eL], d, P)
        N3 = (N3 + h[d] * sum(eQ)) % P
    N3 = N3 * SL.inv_mod(6, P) % P

    # ---- D10 = Stab(D10-point).  C5 has weights {0,1,2,3,4} on W; the
    #      residual involution acts by a -> -a, so it fixes W_0 and swaps
    #      W_1<->W_4, W_2<->W_3.  dim W^{D10} = dim of the +1-eigenspace of
    #      that involution on W_0, which is 1-dimensional.
    #      chi_{W}(C5-elt) = 0 for a nontrivial one, = 5 for 1;
    #      chi_W(reflection) = trace of a -> -a on W = 1 (fixes W_0 only,
    #      up to the sign it acts with; the sealed data has chi(2A) = 1).
    ND10 = ((5 + 0 + 0 + 0 + 0) + 5 * 1) % P
    ND10 = ND10 * SL.inv_mod(10, P) % P
    # ---- C6-point / D12-point targets : dim W^{C6}, dim W^{D12}
    NC6 = 0
    for j in range(6):
        t = pow(w6, j, P)
        NC6 = (NC6 + sum(pow(t, a, P) for a in (0, 1, 2, 4, 5))) % P
    NC6 = NC6 * SL.inv_mod(6, P) % P
    ND12 = 0
    for lab, size, ep, em in D12:
        ND12 = (ND12 + size * ((sum(ep) + sum(em)) % P)) % P
    ND12 = ND12 * SL.inv_mod(12, P) % P
    return dict(N_plane=NA, N_minus=NB, N_line=NC, N_c3=N3,
                N_D10=ND10, N_C6pt=NC6, N_D12pt=ND12)


# ------------------------------------- PATH B: brute force on the Weil frame
def pathB(P, d=DEG, r=6, dmax=DMAX):
    fr = SL.build_frame(P, verbose=True)
    RHO, RHOI = fr["RHO"], fr["RHOI"]
    I5 = np.eye(5, dtype=np.int64)
    out = {}

    # dim M_d for all d, by a sum over the 660 explicit matrices
    tot = np.zeros(dmax + 1, dtype=object)
    for g in range(660):
        h = h_from_matrix(RHOI[g] % P, dmax, P)       # chi_{Sym^d W*}(g)
        tr = int(np.trace(RHO[g])) % P
        for k in range(dmax + 1):
            tot[k] = (tot[k] + h[k] * tr) % P
    inv660 = SL.inv_mod(660, P)
    out["dimM"] = [int(tot[k]) * inv660 % P for k in range(dmax + 1)]

    # --- sigma, D12 = C_G(sigma), W^+, W^-
    si = fr["sigma_index"]
    sig = RHO[si]
    D12 = [g for g in range(660)
           if np.array_equal((RHO[g] @ sig) % P, (sig @ RHO[g]) % P)]
    assert len(D12) == 12
    Wp, Wm = fr["Wplus"], fr["Wminus"]

    def restrict(g, rows):
        """matrix of rho(g) on the span of `rows`, in that row basis."""
        img = (rows @ RHO[g].T) % P                    # rows: g.v_i
        A = rows.T % P                                 # (5,k)
        idx, cur = [], np.zeros((0, rows.shape[0]), dtype=np.int64)
        for i in range(5):
            t = np.concatenate([cur, A[i][None, :]], axis=0)
            if SL.rref_rank(t, P) > cur.shape[0]:
                cur = t
                idx.append(i)
            if len(idx) == rows.shape[0]:
                break
        return (img[:, idx] @ SL.mat_inv(A[idx] % P, P).T) % P

    NA = NB = 0
    for g in D12:
        Mp = restrict(g, Wp)
        Mm = restrict(g, Wm)
        gi = [k for k in range(660)
              if np.array_equal((RHO[k] @ RHO[g]) % P, I5)][0]
        hp = h_from_matrix(restrict(gi, Wp), d, P)
        hm = h_from_matrix(restrict(gi, Wm), d, P)
        tr = int(np.trace(RHO[g])) % P
        NA = (NA + hp[d] * tr) % P
        NB = (NB + hm[d] * tr) % P
    inv12 = SL.inv_mod(12, P)
    out["N_plane"] = NA * inv12 % P
    out["N_minus"] = NB * inv12 % P
    out["N_D12pt"] = sum(int(np.trace(RHO[g])) % P
                         for g in D12) % P * inv12 % P

    # --- A4 = Stab(ell_V) = N_G(V4)
    LINE = fr["LINE"]
    A4 = []
    for g in range(660):
        img = (LINE @ RHO[g].T) % P
        if SL.rref_rank(np.concatenate([LINE, img], axis=0), P) == 2:
            A4.append(g)
    assert len(A4) == 12, len(A4)
    # Q = W/U : use a complement basis and the induced action
    comp = []
    cur = LINE.copy()
    for i in range(5):
        e = np.zeros(5, dtype=np.int64)
        e[i] = 1
        t = np.concatenate([cur, e[None, :]], axis=0)
        if SL.rref_rank(t, P) > cur.shape[0]:
            cur = t
            comp.append(e)
    COMP = np.array(comp, dtype=np.int64)               # 3 rows
    BAS = np.concatenate([LINE, COMP], axis=0)          # 5 rows, basis of W
    BINV = SL.mat_inv(BAS.T % P, P)                     # coords in that basis
    NC = 0
    for g in A4:
        gi = [k for k in range(660)
              if np.array_equal((RHO[k] @ RHO[g]) % P, I5)][0]
        # action on W in the adapted basis: coords of g.b_i
        Mfull = (BINV @ RHO[gi] @ BAS.T) % P            # (5,5), block lower-tri
        MU = Mfull[0:2, 0:2] % P
        MQ = Mfull[2:5, 2:5] % P
        hu = h_from_matrix(MU, d, P)
        hq = h_from_matrix(MQ, r, P)
        s = 0
        for k in range(r):
            s = (s + hq[k] * hu[d - k]) % P
        NC = (NC + s * (int(np.trace(RHO[g])) % P)) % P
    out["N_line"] = NC * inv12 % P

    # --- C6 = Stab(C3-eigenline), the X^{C6} point on it
    t6 = [g for g in range(660) if fr["orders"][g] == 6][0]
    T6 = RHO[t6] % P
    z6 = root_of_unity(P, 6)
    eig = {}
    for a in range(6):
        ns = SL.nullspace((T6 - pow(z6, a, P) * I5) % P, P)
        if ns.shape[0]:
            eig[a] = ns
    assert sorted(eig) == [0, 1, 2, 4, 5], sorted(eig)
    assert all(eig[a].shape[0] == 1 for a in eig)

    def Fklein(v):
        return sum(int(v[i]) ** 2 * int(v[(i + 1) % 5]) for i in range(5)) % P
    onX = sorted(a for a in eig if Fklein(eig[a][0]) == 0)
    out["C6_weights_on_X"] = onX
    # rho = t6^2 has order 3; ell_w for w = 1 is <v_1, v_4>
    ELL = np.concatenate([eig[1], eig[4]], axis=0) % P
    pw = eig[1][0] % P                                   # the X^{C6} point
    C6 = [g for g in range(660)
          if np.array_equal((RHO[g] @ T6) % P, (T6 @ RHO[g]) % P)]
    assert len(C6) == 6, len(C6)
    # quotient W/<p_w>
    comp2 = []
    cur = pw[None, :].copy()
    for i in range(5):
        e = np.zeros(5, dtype=np.int64)
        e[i] = 1
        t = np.concatenate([cur, e[None, :]], axis=0)
        if SL.rref_rank(t, P) > cur.shape[0]:
            cur = t
            comp2.append(e)
    BAS2 = np.concatenate([pw[None, :], np.array(comp2, dtype=np.int64)],
                          axis=0)
    B2I = SL.mat_inv(BAS2.T % P, P)
    N3 = 0
    for g in C6:
        gi = [k for k in range(660)
              if np.array_equal((RHO[k] @ RHO[g]) % P, I5)][0]
        ML = restrict(gi, ELL)
        h = h_from_matrix(ML, d, P)
        Mf = (B2I @ RHO[g] @ BAS2.T) % P
        trQ = int(np.trace(Mf[1:5, 1:5])) % P
        N3 = (N3 + h[d] * trQ) % P
    out["N_c3"] = N3 * SL.inv_mod(6, P) % P
    out["N_C6pt"] = sum(int(np.trace(RHO[g])) % P
                        for g in C6) % P * SL.inv_mod(6, P) % P

    # --- D10 = Stab(D10-point) = N_G(C5)
    g5 = [g for g in range(660) if fr["orders"][g] == 5][0]
    q = SL.nullspace((RHO[g5] - I5) % P, P)
    assert q.shape[0] == 1
    out["D10_point_off_X"] = bool(Fklein(q[0]) % P != 0)
    D10 = [g for g in range(660)
           if SL.rref_rank(np.concatenate([q, (q @ RHO[g].T) % P],
                                          axis=0), P) == 1]
    assert len(D10) == 10, len(D10)
    out["N_D10"] = sum(int(np.trace(RHO[g])) % P
                       for g in D10) % P * SL.inv_mod(10, P) % P
    out["frame_prime"] = P
    return out, fr


def main():
    P = int(sys.argv[1]) if len(sys.argv) > 1 else big_prime()
    os.makedirs(RES, exist_ok=True)
    print("[prime] P = %d   (P = 1 mod 330: %s;  P > 369075: %s)"
          % (P, (P - 1) % 330 == 0, P > 369075))
    dimA, chi = pathA_dimM(P)
    n1, n0 = pathA_selftest(P, chi)
    print("[pathA] <chi_W,chi_W> = %d   <chi_W,1> = %d" % (n1, n0))
    assert n1 == 1 and n0 == 0
    tA = pathA_targets(P)
    print("[pathA] dim M_d, d=0..10:", dimA[:11])
    print("[pathA] dim M_25 = %d   dim M_34 = %d   dim M_36 = %d"
          % (dimA[25], dimA[34], dimA[36]))
    print("[pathA] targets:", tA)

    outB, fr = pathB(P)
    print("[pathB] dim M_d, d=0..10:", outB["dimM"][:11])
    print("[pathB] dim M_25 = %d   dim M_34 = %d   dim M_36 = %d"
          % (outB["dimM"][25], outB["dimM"][34], outB["dimM"][36]))
    print("[pathB] targets:", {k: v for k, v in outB.items()
                               if k.startswith("N_")})

    agree = all(dimA[k] == outB["dimM"][k] for k in range(DMAX + 1))
    tgt_agree = {k: (tA[k] == outB[k]) for k in tA}
    print("[agree] dim M_d all degrees:", agree)
    print("[agree] targets:", tgt_agree)

    sealed = [1, 0, 0, 2, 1, 2, 4]
    print("[sealed] Molien row d=1..7 reproduced:",
          dimA[1:8] == sealed, dimA[1:8])

    out = {
        "prime": P,
        "prime_conditions": {"P mod 330 == 1": (P - 1) % 330 == 0,
                             "P > 5*C(38,4) = 369075": P > 369075},
        "dim_M_d_pathA": dimA,
        "dim_M_d_pathB": outB["dimM"],
        "dim_M_d_agree": bool(agree),
        "sealed_molien_row_1_7": sealed,
        "sealed_row_reproduced": bool(dimA[1:8] == sealed),
        "targets_pathA": {k: int(v) for k, v in tA.items()},
        "targets_pathB": {k: int(v) for k, v in outB.items()
                          if k.startswith("N_")},
        "targets_agree": {k: bool(v) for k, v in tgt_agree.items()},
        "C6_weights_on_X": outB["C6_weights_on_X"],
        "D10_point_off_X": bool(outB["D10_point_off_X"]),
        "d": DEG, "r_for_N_line": 6,
        "self_tests": {"chi_W_norm_1": int(n1), "chi_W_trivial_mult_0": int(n0),
                       "frame": fr["self_tests"]},
    }
    fn = os.path.join(RES, "dimension_ledger.json")
    with open(fn, "w") as fh:
        json.dump(out, fh, indent=1, sort_keys=True)
    print("wrote", fn)
    return 0


if __name__ == "__main__":
    sys.exit(main())
