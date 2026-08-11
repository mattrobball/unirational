#!/usr/bin/env python3
"""D34_GUIDED_SWEEP, engine 2 -- the guided cascade at d = 34, (m,r) = (1,6).

The FIX-P2 sweep imposed only the PROFILE conditions

    (P)  ord_{P_sigma}(T)   >= m = 1     at the 55 plus-planes
    (P+) ord_{P_sigma}(T^+) >= m + 1 = 2
    (L)  ord_{ell_V}(T)     >= r = 6     at the 55 V4-triple-lines

and found  dim = 16  at d = 34, n = d - r = 28: the first open window.

STAGE2_ODD_ORDER_PINNING proves further conditions that hold for EVERY landing
covariant of degree 34 whatever its profile, and which FIX-P2 never imposed:

    (M)   T|_{L_sigma} = 0 on all 55 minus-lines            [34 even, Prop 1.4]
    (E)   T contracts each C3-eigenline to the X^{C6} point on it
                                                            [34 = 1 mod 3, 1.6]
    (C6)  both X^{C6} points in Bs(T)                       [34 = 4 mod 6, 1.5]
    (D10) the 66 D10-points in Bs(T)                        [B(D10)]
    (D12) the 55 D12-points in Bs(T)                        [B(D12)]

This script runs the whole nested cascade in two orders -- structure-first and
profile-first -- so that the contribution of each condition is visible, and
reports saturation controls for every sampled block.

Semantics (slicelib.__doc__): dimension 0 at any step is a characteristic-zero
emptiness verdict; a nonzero dimension is an UPPER BOUND on the char-0
dimension.  Sampling a subset of functionals only enlarges the computed space.

Usage:  python3 produce_d34.py [p] [npair] [npt]
"""
import json
import os
import sys
import time

import numpy as np

import slicelib as SL
import p2lib as P2
import d34lib as D34

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
DEG = 34
DIM_M34 = 576                # exact, produce_dims34.py, two independent paths
M, R = 1, 6
E, N = R - M, DEG - R        # e = 5, n = 28
T0 = time.time()


class Basis:
    """Incremental row basis over F_p (copied from FIX-P2 produce_cascade)."""

    def __init__(self, ncols, p):
        self.p = p
        self.ncols = ncols
        self.rows = np.zeros((0, ncols), dtype=np.int64)
        self.piv = []
        self.keep = []

    def add_block(self, M_, tags):
        p = self.p
        B = np.array(M_, dtype=np.int64) % p
        if self.rows.shape[0]:
            B = (B - B[:, self.piv] @ self.rows) % p
        for i in range(B.shape[0]):
            v = B[i]
            nz = np.nonzero(v)[0]
            if nz.size == 0:
                continue
            c = int(nz[0])
            v = (v * SL.inv_mod(v[c], p)) % p
            if self.rows.shape[0]:
                col = self.rows[:, c].copy()
                k = np.nonzero(col)[0]
                if k.size:
                    self.rows[k] = (self.rows[k] - np.outer(col[k], v)) % p
            self.rows = np.concatenate([self.rows, v[None, :]], axis=0)
            self.piv.append(c)
            self.keep.append(tags[i])
            if i + 1 < B.shape[0]:
                col = B[i + 1:, c].copy()
                k = np.nonzero(col)[0]
                if k.size:
                    B[i + 1 + k] = (B[i + 1 + k] - np.outer(col[k], v)) % p
        return len(self.keep)


def basis_seeds(fr, deg, dim, p, rng, block=2500, maxseeds=120000):
    npt = dim // 5 + 40
    Wev = rng.integers(0, p, size=(npt, 5)) % p
    Yev = np.zeros_like(Wev)
    bas = Basis(npt * 5, p)
    used = 0
    while len(bas.keep) < dim and used < maxseeds:
        A, C = SL.seed_exponents(used + block, deg=deg)
        A, C = A[used:], C[used:]
        used += block
        ev = SL.jet_rows(fr, A, C, Wev, Yev, 1, deg=deg)
        bas.add_block(ev.reshape(A.shape[0], -1),
                      list(zip(A.tolist(), C.tolist())))
        print("    [seeds] tried %d, independent %d / %d  [%.0f s]"
              % (used, len(bas.keep), dim, time.time() - T0), flush=True)
    if len(bas.keep) < dim:
        return None, None, len(bas.keep)
    kA = np.array([k[0] for k in bas.keep[:dim]], dtype=np.int64)
    kC = np.array([k[1] for k in bas.keep[:dim]], dtype=np.int64)
    return kA, kC, dim


def rand_in_span(rows, k, p, rng):
    co = rng.integers(0, p, size=(k, rows.shape[0]))
    return (co @ rows) % p


def plane_blocks(fr, A, C, deg, m, npair, p, rng):
    Wp, Wm = fr["Wplus"], fr["Wminus"]
    ns = A.shape[0]
    Wa = rand_in_span(Wp, npair, p, rng)
    Ya = rand_in_span(Wm, npair, p, rng)
    J = SL.jet_rows(fr, A, C, Wa, Ya, m + 1, deg=deg)
    c1 = J[:, :, :, :m].reshape(ns, -1)
    PPL = fr["PPLUS"]
    top = J[:, :, :, m]
    c2 = np.einsum('sqc,kc->sqk', top, PPL).reshape(ns, -1) % p
    return c1 % p, c2 % p


def line_block(fr, A, C, deg, r, npair, p, rng):
    LINE = fr["ellV"]
    FULL = np.eye(5, dtype=np.int64)
    ns = A.shape[0]
    Wb = rand_in_span(LINE, npair, p, rng)
    Yb = rand_in_span(FULL, npair, p, rng)
    J = SL.jet_rows(fr, A, C, Wb, Yb, r, deg=deg)
    return J.reshape(ns, -1) % p


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
    npair = int(sys.argv[2]) if len(sys.argv) > 2 else 120
    npt = int(sys.argv[3]) if len(sys.argv) > 3 else 90
    os.makedirs(RES, exist_ok=True)
    rng = np.random.default_rng(20260811)

    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p)))
    A, C, got = basis_seeds(fr, DEG, DIM_M34, p, rng)
    assert A is not None, ("SEED SHORTFALL %d/%d" % (got, DIM_M34))
    ns = A.shape[0]
    print("[basis] %d Reynolds seeds = a basis of M_34 (dim %d), p = %d  "
          "[%.0f s]" % (ns, DIM_M34, p, time.time() - T0), flush=True)

    # ------------------------------------------------------------ the blocks
    print("[blocks] building ...", flush=True)
    c1, c2 = plane_blocks(fr, A, C, DEG, M, npair, p, rng)
    print("    plane blocks done  [%.0f s]" % (time.time() - T0), flush=True)
    lb = line_block(fr, A, C, DEG, R, npair, p, rng)
    print("    ell_V block done   [%.0f s]" % (time.time() - T0), flush=True)
    mb = D34.minus_line_block(fr, A, C, DEG, npt, p, rng)
    eb, ectl = D34.eigenline_block(fr, A, C, DEG, npt, p, rng, which=1)
    eb2, ectl2 = D34.eigenline_block(fr, A, C, DEG, npt, p, rng, which=2)
    pb = D34.point_block(fr, A, C, DEG,
                         [fr["D10pt"], fr["C6_eig"][1][0], fr["C6_eig"][5][0],
                          fr["w0"]], p)
    print("    stage-2 blocks done [%.0f s]" % (time.time() - T0), flush=True)

    # saturation duplicates (independent random samples)
    c1b, c2b = plane_blocks(fr, A, C, DEG, M, npair, p, rng)
    lbb = line_block(fr, A, C, DEG, R, npair, p, rng)
    mbb = D34.minus_line_block(fr, A, C, DEG, npt, p, rng)
    ebb, _ = D34.eigenline_block(fr, A, C, DEG, npt, p, rng, which=1)
    print("    saturation duplicates done [%.0f s]" % (time.time() - T0),
          flush=True)

    res = {}

    def dim_of(blocks, tag=None):
        Mx = np.concatenate(blocks, axis=1)
        rk = P2.rref_rank_fast(Mx, p)
        d = int(DIM_M34 - rk)
        if tag:
            res[tag] = {"dim": d, "rank": int(rk),
                        "n_functionals": int(Mx.shape[1])}
            print("  %-58s dim = %4d   (rank %d)" % (tag, d, rk), flush=True)
        return d

    # ---- control: Lemma 1.1 forces T(ell_w) into W_w, so ann(W_w) is free
    ctl_rank = P2.rref_rank_fast(ectl, p)
    ctl_rank2 = P2.rref_rank_fast(ectl2, p)
    print("[control] ann(W_w).T|_{ell_w} rank on all of M_34 = %d, %d "
          "(Lemma 1.1 predicts 0)" % (ctl_rank, ctl_rank2), flush=True)

    print("[cascade A] STRUCTURE FIRST (no profile assumed):", flush=True)
    a0 = DIM_M34
    print("  %-58s dim = %4d" % ("0: dim M_34 (exact, Molien)", a0))
    a1 = dim_of([c1], "A1: + (P)  ord_{P_sigma} >= 1   [55 plus-planes]")
    a2 = dim_of([c1, c2], "A2: + (P+) ord_{P_sigma}(T^+) >= 2")
    a3 = dim_of([c1, c2, mb], "A3: + (M)  T|_{L_sigma} = 0 [55 minus-lines]")
    a4 = dim_of([c1, c2, mb, eb, eb2],
                "A4: + (E)  C3-eigenline contraction [110 lines]")
    a5 = dim_of([c1, c2, mb, eb, eb2, pb],
                "A5: + (D10)+(C6pt)+(D12pt) base points")
    a6 = dim_of([c1, c2, mb, eb, eb2, pb, lb],
                "A6: + (L)  ord_{ell_V} >= 6  [profile (1,6)]")

    print("[cascade B] PROFILE FIRST (reproduces FIX-P2, then adds STAGE2):",
          flush=True)
    b1 = dim_of([c1], "B1: + (P)  ord_{P_sigma} >= 1")
    b2 = dim_of([c1, c2], "B2: + (P+) ord_{P_sigma}(T^+) >= 2")
    b3 = dim_of([c1, c2, lb], "B3: + (L)  ord_{ell_V} >= 6   [FIX-P2 = 16]")
    b4 = dim_of([c1, c2, lb, mb], "B4: + (M)  minus-lines")
    b5 = dim_of([c1, c2, lb, mb, eb, eb2], "B5: + (E)  C3-eigenlines")
    b6 = dim_of([c1, c2, lb, mb, eb, eb2, pb], "B6: + base points")

    # individual strengths
    dim_of([mb], "X: (M) alone")
    dim_of([eb, eb2], "X: (E) alone")
    dim_of([lb], "X: (L) alone")
    dim_of([c1, c2, mb], "X: (P)+(P+)+(M)")

    # ---- saturation
    sat_full = dim_of([c1, c2, lb, mb, eb, eb2, pb,
                       c1b, c2b, lbb, mbb, ebb],
                      "SATURATION control (2x sampled functionals)")

    verdict = ("D34-ONESIX-WINDOW-EMPTY" if b6 == 0
               else "D34-ONESIX-SURVIVOR-DIM-%d" % b6)
    out = {
        "prime": p, "deg": DEG, "profile": {"m": M, "r": R, "e": E, "n": N},
        "dim_M_34": DIM_M34, "n_seeds": int(ns),
        "npair_plane_line": npair, "npt_stage2": npt,
        "cascade": res,
        "cascade_A_structure_first": [a0, a1, a2, a3, a4, a5, a6],
        "cascade_B_profile_first": [DIM_M34, b1, b2, b3, b4, b5, b6],
        "fixp2_baseline_reproduced": bool(b3 == 16),
        "lemma11_control_rank_zero": bool(ctl_rank == 0 and ctl_rank2 == 0),
        "saturation_dim": sat_full,
        "saturation_stable": bool(sat_full == b6),
        "verdict": verdict,
        "semantics": ("dimension 0 is a characteristic-zero emptiness verdict "
                      "(rank mod p <= rank over Q, and sampling a subset of "
                      "functionals only enlarges the kernel); a nonzero "
                      "dimension is an upper bound on the char-0 dimension."),
        "frame_self_tests": fr["self_tests"],
        "adapted_self_tests": {k: bool(v) for k, v in
                               fr["adapted_self_tests"].items()},
        "stage2_self_tests": {k: bool(v) for k, v in
                              fr["stage2_self_tests"].items()},
        "elapsed_s": round(time.time() - T0, 1),
    }
    fn = os.path.join(RES, "cascade34_p%d.json" % p)
    with open(fn, "w") as fh:
        json.dump(out, fh, indent=1, sort_keys=True)
    print("[verdict] %s   -> wrote %s   [%.0f s]"
          % (verdict, fn, time.time() - T0))
    return 0


if __name__ == "__main__":
    sys.exit(main())
