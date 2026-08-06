#!/usr/bin/env python3
"""FIX-P2 diagnostic: the THREE D12-points and the vanishing of Lambda at each.

Theorem H1-1(a) (FIX-H1, PAYLOAD_theorem.txt) reads

   Lambda vanishes to order >= 2e at c_sigma -- hence, by the residual
   C3 = A4/K_1 which permutes the three D12-points of ell_V, at ALL THREE
   D12-points.  In particular  d - r >= 6e .

The first half is derived from the three concurrent mirror lines of P_sigma
and uses only H0-1 + the multi-order -- i.e. exactly the conditions that cut
the step-3 slice.  So it must be AUTOMATIC on that slice.  The second half
("hence ... at all three") is what supplies the factor 3 in the degree bound.
This script measures both, on the slice, order by order, at each of the three
D12-points of ell_V:

    rank of  { T |-> lambda_k(Lambda_T at c_i) }  restricted to the slice,

where lambda_k is the order-k Taylor coefficient along ell_V.  Rank 0 means
that order of vanishing is FORCED by the slice conditions.

Usage: python3 diag_d12.py [p] [d] [r] [kmax]
"""
import sys
import time

import numpy as np

import slicelib as SL
import p2lib as P2
import produce_cascade as PC

T0 = time.time()


def d12_points(fr, p):
    """The three D12-fixed points of ell_V, one per involution of K_1."""
    RHO = fr["RHO"]
    I5 = np.eye(5, dtype=np.int64)
    pts = []
    for si in fr["v4"]:
        sig = RHO[si]
        D = [g for g in range(660)
             if np.array_equal((RHO[g] @ sig) % p, (sig @ RHO[g]) % p)]
        assert len(D) == 12
        S = np.zeros((5, 5), dtype=np.int64)
        for g in D:
            S = (S + RHO[g]) % p
        F = SL.nullspace((S - 12 * I5) % p, p)
        assert F.shape[0] == 1, F.shape
        v = F[0] % p
        # must lie on ell_V
        assert SL.rref_rank(np.concatenate([fr["ellV"], v[None, :]], axis=0),
                            p) == 2
        pts.append(v)
    return pts


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
    d = int(sys.argv[2]) if len(sys.argv) > 2 else 36
    r = int(sys.argv[3]) if len(sys.argv) > 3 else 6
    kmax = int(sys.argv[4]) if len(sys.argv) > 4 else 13
    m, e, n = 1, r - 1, d - r
    dims = PC.load_dims()
    dimM = dims[d]
    fr = P2.adapted_frame(SL.build_frame(p))
    rng = np.random.default_rng(20260806)

    C123 = d12_points(fr, p)
    print("the three D12-points of ell_V (in the standard coordinates):")
    for i, v in enumerate(C123):
        print("   c_%d = %s" % (i + 1, v.tolist()))
    # distinctness
    for i in range(3):
        for j in range(i + 1, 3):
            rk = SL.rref_rank(np.stack([C123[i], C123[j]]), p)
            print("   rank[c_%d;c_%d] = %d  (2 = distinct points)"
                  % (i + 1, j + 1, rk))
    # the residual C3 permutes them
    A4 = [g for g in range(660)
          if all(any(np.array_equal((fr["RHO"][g] @ fr["RHO"][t] @
                                     SL.mat_inv(fr["RHO"][g], p)) % p,
                                    fr["RHO"][u] % p) for u in fr["v4"])
                 for t in fr["v4"])]
    print("   |N_G(K_1)| = %d  (expect 12 = A4)" % len(A4))
    th = [g for g in A4 if fr["orders"][g] == 3]
    print("   A4 elements of order 3: %d" % len(th))
    if th:
        g = fr["RHO"][th[0]]
        img = [(g @ v) % p for v in C123]
        perm = []
        for w in img:
            hit = [j for j in range(3)
                   if SL.rref_rank(np.stack([w, C123[j]]), p) == 1]
            perm.append(hit[0] + 1 if hit else 0)
        print("   theta permutes (c1,c2,c3) -> %s   (a 3-cycle means the"
              " C3 acts freely on the three points)" % perm)

    A, C, got = PC.basis_seeds(fr, d, dimM, p, rng)
    assert A is not None, ("seed shortfall", got, dimM)
    ns = A.shape[0]
    npair = max(60, dimM // 6 + 30)
    c1, c2 = PC.plane_blocks(fr, A, C, d, m, npair, p, rng)
    lb = PC.line_block(fr, A, C, d, r, npair, p, rng)
    M0 = np.concatenate([c1, lb], axis=1)
    base_rank = SL.rref_rank(M0, p)
    print("\ndim M_%d = %d ;  step-3 slice dim = %d"
          % (d, dimM, dimM - base_rank), flush=True)

    # a direction along ell_V, independent of each base point
    LINE = fr["ellV"]
    print("\nrank of the order-k Taylor functionals of Lambda^{(1)} at each"
          " D12-point, ON the slice")
    print("(0 = that order of vanishing is FORCED by the slice conditions;"
          " 2e = %d)" % (2 * e))
    print("   k :   " + "".join("%5d" % k for k in range(kmax + 1)))
    for i, cpt in enumerate(C123):
        u = LINE[0] if SL.rref_rank(np.stack([cpt, LINE[0]]), p) == 2 \
            else LINE[1]
        lam = lam_at(fr, A, C, d, m, r, p, cpt, u)
        row = []
        for k in range(kmax + 1):
            blk = lam[:, k, :].reshape(ns, -1) % p
            MM = np.concatenate([M0, blk], axis=1)
            row.append(SL.rref_rank(MM, p) - base_rank)
        print("  c_%d:   " % (i + 1) + "".join("%5d" % x for x in row),
              flush=True)
        # cumulative: orders 0..k together
        cum = []
        for k in range(kmax + 1):
            blk = lam[:, :k + 1, :].reshape(ns, -1) % p
            MM = np.concatenate([M0, blk], axis=1)
            cum.append(SL.rref_rank(MM, p) - base_rank)
        print("  cum:   " + "".join("%5d" % x for x in cum), flush=True)
    print("\nelapsed %.1f s" % (time.time() - T0))


def lam_at(fr, A, C, deg, m, r, p, base, direction):
    """Taylor coefficients of Lambda^{(1)} at `base` along `direction`."""
    e, n = r - m, deg - r
    ns = A.shape[0]
    ey, ez, ex = fr["ey"], fr["ez"], fr["ex"]
    PM = fr["PMINUS"]
    taus = list(range(n + 1))
    pts, dirs = [], []
    for t in taus:
        for u2 in (ey, ez):
            pts.append((base + t * direction) % p)
            dirs.append(u2)
    Wb = np.array(pts, dtype=np.int64) % p
    U1 = np.tile(ex % p, (len(pts), 1))
    U2 = np.array(dirs, dtype=np.int64) % p
    res = P2.jet_rows2(fr, A, C, Wb, U1, U2, e + 1, 2, deg)
    top = res[:, :, :, e, 1]
    lp = np.einsum('sqc,ic->sqi', top, PM) % p
    Lp = np.zeros((ns, n + 1, 4), dtype=np.int64)
    for k in range(n + 1):
        for jd in range(2):
            Lp[:, k, jd] = lp[:, 2 * k + jd, 0]
            Lp[:, k, 2 + jd] = lp[:, 2 * k + jd, 1]
    Vi = P2.vandermonde_inv(taus, p)
    return np.einsum('kq,sqv->skv', Vi, Lp) % p


if __name__ == "__main__":
    sys.exit(main())
