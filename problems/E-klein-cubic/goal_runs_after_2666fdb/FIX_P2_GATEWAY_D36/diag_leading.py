#!/usr/bin/env python3
"""FIX-P2 diagnostic: WHAT is the leading graded piece along ell_V on the slice?

For the step-3 slice  S = { T in M_d : ord_{P_sigma} T >= 1 , ord_{ell_V} T >= r }
compute, for each bidegree (a, b) with a + b <= r,

    rank of the functionals  T |-> [ s^a t^b ] ( T(P + s e_x + t u) ) ,
    P ranging over sampled points of ell_V, u a sampled vector of W^-,
    separately on the PLUS and MINUS halves,

restricted to S.  A rank 0 at (a,b) says: every element of S has that bidegree
coefficient identically zero, i.e. the (y,z)-degree-b part of the (x,y,z)-degree
(a+b) piece is absent.  This locates the leading cell datum of the slice --
and in particular decides whether the (m, r) = (1, r) datum (b = 1, a = r-1)
is present at all.

Usage: python3 diag_leading.py [p] [d] [r]
"""
import sys
import time

import numpy as np

import slicelib as SL
import p2lib as P2
import produce_cascade as PC

T0 = time.time()


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
    d = int(sys.argv[2]) if len(sys.argv) > 2 else 36
    r = int(sys.argv[3]) if len(sys.argv) > 3 else 6
    dims = PC.load_dims()
    dimM = dims[d]
    fr = P2.adapted_frame(SL.build_frame(p))
    rng = np.random.default_rng(20260806)
    A, C, got = PC.basis_seeds(fr, d, dimM, p, rng)
    assert A is not None, ("seed shortfall", got, dimM)
    ns = A.shape[0]
    npair = max(60, dimM // 6 + 30)

    c1, c2 = PC.plane_blocks(fr, A, C, d, 1, npair, p, rng)
    lb = PC.line_block(fr, A, C, d, r, npair, p, rng)
    M0 = np.concatenate([c1, lb], axis=1)
    base_rank = SL.rref_rank(M0, p)
    print("dim M_%d = %d ;  step-3 slice dim = %d"
          % (d, dimM, dimM - base_rank), flush=True)

    # bivariate jets at sampled points of ell_V, direction u in W^-
    npt = 6
    LINE, Wm = fr["ellV"], fr["Wminus"]
    Wb = PC.rand_in_span(LINE, npt, p, rng)
    U1 = np.tile(fr["ex"] % p, (npt, 1))
    U2 = PC.rand_in_span(Wm, npt, p, rng)
    J1 = r + 1
    J2 = 4          # (y,z)-degrees 0..3 : covers the m = 1 and m = 3 data
    res = P2.jet_rows2(fr, A, C, Wb, U1, U2, J1, J2, d)    # (ns,npt,5,J1,J2)
    PM, PP = fr["PMINUS"], fr["PPLUS"]
    minus = np.einsum('sqcab,ic->sqiab', res, PM) % p
    plus = np.einsum('sqcab,ic->sqiab', res, PP) % p

    print()
    print("rank of the [s^a t^b] functionals ON the step-3 slice "
          "(0 = that bidegree is identically absent):")
    print("   a = x-degree, b = (y,z)-degree, a+b = the (x,y,z)-degree")
    hdr = "  a\\b " + "".join("%6d" % b for b in range(J2))
    print(hdr + "     half")
    for half, nm in ((minus, "MINUS"), (plus, "PLUS ")):
        for a in range(J1):
            row = []
            for b in range(J2):
                if a + b > r:
                    row.append("     .")
                    continue
                blk = half[:, :, :, a, b].reshape(ns, -1) % p
                MM = np.concatenate([M0, blk], axis=1)
                extra = SL.rref_rank(MM, p) - base_rank
                row.append("%6d" % extra)
            print("  %2d  " % a + "".join(row) + "     " + nm)
        print()
    print("elapsed %.1f s" % (time.time() - T0))


if __name__ == "__main__":
    sys.exit(main())
