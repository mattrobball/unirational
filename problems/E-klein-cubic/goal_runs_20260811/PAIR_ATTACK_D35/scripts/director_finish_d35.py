#!/usr/bin/env python3
"""Director finisher (2026-08-11): the second divisor row's UNIVERSAL demand.

Every coherent residue-5 blueprint carries an L-row multidegree with
transverse order nu in {2, 4} (machine fact: every stored pattern's
a35_L_options are [[31,4],[33,2]]-type; nu = 0 never occurs).  So EVERY
pair (T, r) at d = 35 demands, with no level or parity subtleties:

    T vanishes on every minus-line, to order >= 2 transversally.

By G-equivariance it is enough to impose this on ONE minus-line.  These
are certain, closed, linear conditions -- and they are NOT part of the
sealed 39-dimensional Layer-0 slice (at d = 35 the mod-6 table does not
put the minus-lines in the base locus, so the ladder never imposed them).

This script imposes, on the 39-dim slice, in order:
  (V1) T = 0 at 40 sampled points of one minus-line     [order >= 1]
  (V2) all three transverse first derivatives = 0 at those points
                                                        [order >= 2]
and reports the surviving dimension, also in combination with the six
universal flip conditions of director_worked_example.py.  Both primes.

Sanity anchors: (a) the verdict must be identical at 331 and 661;
(b) sampling MORE points must not change the rank (saturation check with
60 points); (c) V1's rank alone must not exceed 5*36 - obvious bounds.
"""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import paths  # noqa: E402
import slicelib as SL  # noqa: E402

PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
DEG = 35


def nullspace_rows(M, p):
    return SL.nullspace(np.array(M, dtype=np.int64) % p, p)


def main(p, npts=40):
    print("== finisher, p = %d, npts = %d" % (p, npts))
    fr = SL.build_frame(p, verbose=False)
    A6 = np.load(os.path.join(RES, "layer0_A_p331.npy"))
    C6 = np.load(os.path.join(RES, "layer0_C_p331.npy"))
    NUL = np.load(os.path.join(RES, "layer0_null_p%d.npy" % p)) % p
    ns, nsl = A6.shape[0], NUL.shape[0]
    assert (ns, nsl) == (637, 39)

    RHO, orders = fr["RHO"], fr["orders"]
    I5 = np.eye(5, dtype=np.int64)
    z = next(g for g in range(660) if orders[g] == 2)
    Z = RHO[z] % p
    Wm = nullspace_rows((Z + I5) % p, p)   # 2 x 5, the minus-line of z
    Wp = nullspace_rows((Z - I5) % p, p)   # 3 x 5, transverse directions
    assert Wm.shape[0] == 2 and Wp.shape[0] == 3

    rng = np.random.default_rng(20260811)
    ab = rng.integers(1, p, size=(npts, 2))
    pts = (ab @ Wm) % p                    # points on the line

    # V1: T(x) = 0 on the line
    J1 = SL.jet_rows(fr, A6, C6, pts, np.zeros_like(pts), 1, deg=DEG)
    ROWS1 = J1.reshape(ns, -1) % p                      # (637, npts*5)
    S1 = (NUL @ ROWS1) % p                              # (39, npts*5)
    r1 = SL.rref_rank(S1.T % p, p)

    # V2: directional derivatives along the three plus-directions
    blocks = [S1]
    for k in range(3):
        Y = np.tile(Wp[k][None, :], (npts, 1)) % p
        J2 = SL.jet_rows(fr, A6, C6, pts, Y, 2, deg=DEG)[:, :, :, 1]
        blocks.append((NUL @ (J2.reshape(ns, -1) % p)) % p)
    SALL = np.concatenate(blocks, axis=1) % p
    r12 = SL.rref_rank(SALL.T % p, p)

    print("V1 rank (order >= 1 on the line):", r1, "-> dim", nsl - r1)
    print("V1+V2 rank (order >= 2):", r12, "-> dim", nsl - r12)

    out = {"p": p, "npts": npts, "rank_ord1": int(r1),
           "dim_after_ord1": int(nsl - r1), "rank_ord2": int(r12),
           "dim_after_ord2": int(nsl - r12)}

    # combine with the universal six flips if available
    we = os.path.join(RES, "worked_example_p%d.json" % p)
    if os.path.exists(we):
        U = np.array(json.load(open(we))["universal_matrix_6x39"],
                     dtype=np.int64) % p                 # (6, 39)
        COMB = np.concatenate([SALL, U.T % p], axis=1) % p
        rC = SL.rref_rank(COMB.T % p, p)
        print("with the six universal flips:", rC, "-> dim", nsl - rC)
        out["rank_with_universal"] = int(rC)
        out["dim_final"] = int(nsl - rC)

    # saturation: more points must not change anything
    ab2 = rng.integers(1, p, size=(20, 2))
    pts2 = (ab2 @ Wm) % p
    J1b = SL.jet_rows(fr, A6, C6, pts2, np.zeros_like(pts2), 1, deg=DEG)
    S1b = (NUL @ (J1b.reshape(ns, -1) % p)) % p
    r1b = SL.rref_rank(np.concatenate([S1, S1b], axis=1).T % p, p)
    assert r1b == r1, "V1 not saturated at %d points" % npts
    print("saturation check: extra 20 points change nothing  [OK]")

    with open(os.path.join(RES, "finisher_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=1)
    return out


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 331)
