#!/usr/bin/env python3
"""FIX-P2 diagnostic: THE THREE LEADING DATA ARE THREE DIFFERENT OBJECTS.

The V4 K_1 has three involutions sigma_1, sigma_2, sigma_3; each plane
P_{sigma_i} contains ell_V, and each carries its own leading line datum

    Lambda^{(i)}  :=  ( the (W^-_{sigma_i})-degree-m part of T^{-,sigma_i} )
                      / (the sigma_i-plus normal coordinate)^e   |_{ell_V}

In the V4 coordinates (x, y, z) = (E_1, E_2, E_3):

    Lambda^{(1)} = [ x^{r-1} * (y or z) ] of the (y,z)-components   (sigma_1)
    Lambda^{(2)} = [ y^{r-1} * (z or x) ] of the (z,x)-components   (sigma_2)
    Lambda^{(3)} = [ z^{r-1} * (x or y) ] of the (x,y)-components   (sigma_3)

The residual C3 = A4/K_1 permutes  c_1, c_2, c_3  AND  Lambda^{(1)},
Lambda^{(2)}, Lambda^{(3)}  simultaneously.  So the mirror-line theorem
"ord_{c_i} Lambda^{(i)} >= 2e", applied at all three i, is ONE statement
about ONE binary form up to C3-translation -- it does NOT say that a single
Lambda vanishes to order 2e at three points.

This script measures both data at the SAME point c_2 on the same slice:

    ord_{c_2} Lambda^{(2)}   should be  >= 2e   (the theorem, at sigma_2)
    ord_{c_2} Lambda^{(1)}   is measured -- and is NOT 2e.

Usage: python3 diag_sigma2.py [p] [d] [r] [kmax]
"""
import sys
import time

import numpy as np

import slicelib as SL
import p2lib as P2
import produce_cascade as PC
import diag_d12 as D12

T0 = time.time()


def datum(fr, A, C, deg, r, p, base, direction, which):
    """Taylor coefficients at `base` of Lambda^{(which)}, which in {1,2,3}."""
    m = 1
    e, n = r - m, deg - r
    ns = A.shape[0]
    ex, ey, ez = fr["ex"], fr["ey"], fr["ez"]
    Binv = fr["Binv"]
    # (normal coordinate raised to e, the two transverse directions,
    #  the two output components)
    cfg = {1: (ex, (ey, ez), Binv[3:5, :]),
           2: (ey, (ez, ex), np.concatenate([Binv[4:5, :], Binv[2:3, :]],
                                            axis=0)),
           3: (ez, (ex, ey), np.concatenate([Binv[2:3, :], Binv[3:4, :]],
                                            axis=0))}[which]
    u1, u2s, PJ = cfg
    taus = list(range(n + 1))
    pts, dirs = [], []
    for t in taus:
        for u2 in u2s:
            pts.append((base + t * direction) % p)
            dirs.append(u2)
    Wb = np.array(pts, dtype=np.int64) % p
    U1 = np.tile(u1 % p, (len(pts), 1))
    U2 = np.array(dirs, dtype=np.int64) % p
    res = P2.jet_rows2(fr, A, C, Wb, U1, U2, e + 1, 2, deg)
    top = res[:, :, :, e, 1]
    lp = np.einsum('sqc,ic->sqi', top, PJ) % p
    Lp = np.zeros((ns, n + 1, 4), dtype=np.int64)
    for k in range(n + 1):
        for jd in range(2):
            Lp[:, k, jd] = lp[:, 2 * k + jd, 0]
            Lp[:, k, 2 + jd] = lp[:, 2 * k + jd, 1]
    Vi = P2.vandermonde_inv(taus, p)
    return np.einsum('kq,sqv->skv', Vi, Lp) % p


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
    d = int(sys.argv[2]) if len(sys.argv) > 2 else 36
    r = int(sys.argv[3]) if len(sys.argv) > 3 else 6
    kmax = int(sys.argv[4]) if len(sys.argv) > 4 else 11
    e = r - 1
    dims = PC.load_dims()
    dimM = dims[d]
    fr = P2.adapted_frame(SL.build_frame(p))
    rng = np.random.default_rng(20260806)
    C123 = D12.d12_points(fr, p)
    A, C, got = PC.basis_seeds(fr, d, dimM, p, rng)
    assert A is not None, ("seed shortfall", got, dimM)
    ns = A.shape[0]
    npair = max(60, dimM // 6 + 30)
    b1, _ = PC.plane_blocks(fr, A, C, d, 1, npair, p, rng)
    lb = PC.line_block(fr, A, C, d, r, npair, p, rng)
    M0 = np.concatenate([b1, lb], axis=1)
    base_rank = P2.rref_rank_fast(M0, p)
    print("dim M_%d = %d ; step-3 slice dim = %d ; 2e = %d"
          % (d, dimM, dimM - base_rank, 2 * e), flush=True)
    LINE = fr["ellV"]
    print("\nrank of the order-k Taylor functionals ON the slice"
          "  (0 = forced to vanish)")
    print("   k :   " + "".join("%5d" % k for k in range(kmax + 1)))
    for ip, cpt in ((0, C123[0]), (1, C123[1])):
        u = LINE[0] if SL.rref_rank(np.stack([cpt, LINE[0]]), p) == 2 \
            else LINE[1]
        for which in (1, 2):
            lam = datum(fr, A, C, d, r, p, cpt, u, which)
            row = []
            for k in range(kmax + 1):
                blk = lam[:, k, :].reshape(ns, -1) % p
                MM = np.concatenate([M0, blk], axis=1)
                row.append(P2.rref_rank_fast(MM, p) - base_rank)
            print("  Lambda^{(%d)} at c_%d : " % (which, ip + 1) +
                  "".join("%5d" % x for x in row), flush=True)
    print("\nelapsed %.1f s" % (time.time() - T0))


if __name__ == "__main__":
    sys.exit(main())
