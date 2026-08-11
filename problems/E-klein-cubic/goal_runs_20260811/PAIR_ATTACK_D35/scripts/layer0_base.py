#!/usr/bin/env python3
"""Layer 0 -- r-independent sealed cuts on M_35.

Reproduces the D34_GUIDED_SWEEP ladder cell at d=35:

    structure (STAGE2 base-locus congruences) + profile (1, r0=6)
    => dim_structure_plus_(1,r0) = 39   (sealed; STOP if not reproduced)

Then folds in:
  * A4 mu >= 2  (STAGE2_SECOND_ORDER, sealed): jet order >=2 at A4-points
  * C13 prefilter: automatic for Reynolds G-covariant seeds (orbit support)
  * C4 polar / C6 tangent: recorded; C6 is tangent-space-at-candidate (needs
    a point of the landing scheme) and is deferred to survivors; C4's first
    identity is bilinear in (T, dT) and becomes linear only after F(T)=0, so
    it is deferred with C6 per theory/CONSTRAINT_ADDITIONS imposition order
    (C4/C6 into the jet compiler on a candidate, not as ambient linear cuts
    that enlarge the D34 structure block).

Usage:  python3 layer0_base.py [p] [npair] [npt]
"""
import json
import os
import sys
import time

import numpy as np

import paths  # noqa: F401
import slicelib as SL
import p2lib as P2
import d34lib as D34
import produce_d34 as PD
import produce_ladder as PL

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
DEG = 35
DIM_M = 637  # exact Molien, D34 dimension_ledger / produce_dims34
R0 = 6
M0 = 1
T0 = time.time()


def a4_points(fr, p):
    """The two A4-points on ell_V = W^{V4} (C3-eigenlines of A4 = N(V4))."""
    RHO, RHOI = fr["RHO"], fr["RHOI"]
    LINE = fr["ellV"]
    v4 = list(fr["v4"])

    def mat_eq(A, B):
        return np.array_equal(A % p, B % p)

    found = []
    for g in range(660):
        if fr["orders"][g] != 3:
            continue
        Gi, Ginv = RHO[g], RHOI[g]
        imgs = []
        ok = True
        for a in v4:
            C = (Gi @ RHO[a] @ Ginv) % p
            hit = None
            for b in v4:
                if mat_eq(C, RHO[b]):
                    hit = b
                    break
            if hit is None:
                ok = False
                break
            imgs.append(hit)
        if ok and set(imgs) == set(v4) and len(set(imgs)) == 3:
            found.append(g)
    assert found, "no C3 cycling V4"
    g = found[0]
    # 2x2 action of g on LINE coordinates
    B = LINE.T % p  # 5x2
    cols = []
    for i in range(2):
        gv = (RHO[g] @ LINE[i]) % p
        rows = []
        A = np.array(B, dtype=np.int64) % p
        for r in range(5):
            if SL.rref_rank(A[rows + [r], :], p) == len(rows) + 1:
                rows.append(r)
            if len(rows) == 2:
                break
        sub = A[rows, :] % p
        rv = gv[rows] % p
        det = int((sub[0, 0] * sub[1, 1] - sub[0, 1] * sub[1, 0]) % p)
        idet = pow(det, p - 2, p)
        inv = (np.array([[sub[1, 1], -sub[0, 1]],
                         [-sub[1, 0], sub[0, 0]]], dtype=np.int64) * idet) % p
        coef = (inv @ rv) % p
        cols.append(coef)
    Mmat = np.stack(cols, axis=1) % p
    z3 = None
    for a in range(2, p):
        c = pow(a, (p - 1) // 3, p)
        if c != 1:
            z3 = c
            break
    pts = []
    for k in (1, 2):
        lam = pow(z3, k, p)
        ns = SL.nullspace((Mmat - lam * np.eye(2, dtype=np.int64)) % p, p)
        assert ns.shape[0] == 1, (k, ns.shape)
        v = (ns[0] @ LINE) % p
        pts.append(v)
    return pts, g


def a4_mu2_block(fr, A, C, d, p, njet=2, npair=40, rng=None):
    """ord_q(T) >= 2 at both A4-points: jets of order < 2 vanish.

    Sampled: T(q + t u) coefficients of t^0, t^1 vanish for random u.
    Safe direction: fewer functionals only enlarge the kernel.
    """
    if rng is None:
        rng = np.random.default_rng(0)
    pts, _ = a4_points(fr, p)
    ns = A.shape[0]
    blocks = []
    FULL = np.eye(5, dtype=np.int64)
    for q in pts:
        # random directions from q
        U = rng.integers(0, p, size=(npair, 5)) % p
        # jet at basepoint q along directions U, orders 0..njet-1
        # slicelib.jet_rows(fr, A, C, Wbase, Ydir, njet, deg)
        # expands T(W + s Y); we want T(q + s u) so W=q, Y=u
        W = np.tile(q, (npair, 1)) % p
        J = SL.jet_rows(fr, A, C, W, U, njet, deg=d)  # (ns, 5, npair, njet)
        blocks.append(J.reshape(ns, -1) % p)
    return np.concatenate(blocks, axis=1) % p


def build_layer0(p, npair=100, npt=80, rng_seed=20260811, verbose=True):
    """Return dict with basis, constraint blocks, dimensions, ranks."""
    rng = np.random.default_rng(rng_seed)
    t0 = time.time()
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p)), verbose=False)
    if verbose:
        print("[L0] frame ready p=%d  [%.1fs]" % (p, time.time() - t0),
              flush=True)

    A, C, got = PD.basis_seeds(fr, DEG, DIM_M, p, rng)
    if A is None:
        raise RuntimeError("seed shortfall %d/%d at p=%d" % (got, DIM_M, p))
    if verbose:
        print("[L0] basis %d seeds  [%.1fs]" % (A.shape[0], time.time() - t0),
              flush=True)

    P11, P5on, P5off = PL.eig_points(fr, p)
    c1, c2 = PD.plane_blocks(fr, A, C, DEG, M0, npair, p, rng)
    sb, fired = PL.structure_blocks(fr, A, C, DEG, npt, p, rng, P11, P5on, P5off)
    lb = PD.line_block(fr, A, C, DEG, R0, npair, p, rng)
    a4b = a4_mu2_block(fr, A, C, DEG, p, njet=2, npair=max(30, npair // 2),
                       rng=rng)

    # ---- sealed D34 cut (structure + profile), no A4 yet ----
    blocks_struct = [c1, c2] + [b for _, b in sb]
    d_struct = int(DIM_M - P2.rref_rank_fast(
        np.concatenate(blocks_struct, axis=1), p))
    blocks_d34 = blocks_struct + [lb]
    d_d34 = int(DIM_M - P2.rref_rank_fast(
        np.concatenate(blocks_d34, axis=1), p))
    d_prof = int(DIM_M - P2.rref_rank_fast(
        np.concatenate([c1, c2, lb], axis=1), p))

    # ---- + A4 mu>=2 ----
    blocks_full = blocks_d34 + [a4b]
    Mfull = np.concatenate(blocks_full, axis=1) % p
    rank_full = int(P2.rref_rank_fast(Mfull, p))
    d_full = int(DIM_M - rank_full)

    # nullspace basis of the full Layer-0 matrix (for Layer 1 reuse)
    # Work with rows = constraints, cols = coefficients of M_35 basis.
    # jet blocks are (ns, nfunc) so transpose to (nfunc, ns) for nullspace.
    Phi = Mfull.T % p  # (nfunc, ns)
    # nullspace of Phi: vectors x with Phi x = 0
    K = SL.nullspace(Phi, p)  # rows = basis of ker
    if K.size == 0:
        K = np.zeros((0, DIM_M), dtype=np.int64)

    rec = {
        "prime": p,
        "d": DEG,
        "dim_M": DIM_M,
        "r0": R0,
        "m0": M0,
        "rules_fired": fired,
        "dim_profile_only_(1,r0)": d_prof,
        "dim_structure_only": d_struct,
        "dim_structure_plus_(1,r0)": d_d34,
        "dim_layer0_plus_A4mu2": d_full,
        "rank_layer0": rank_full,
        "nullspace_dim": int(K.shape[0]),
        "sealed_target_d34": 39,
        "d34_match": (d_d34 <= 39),
        "d34_exact_match": (d_d34 == 39),
        "C13": "automatic (Reynolds G-orbit support on seeds)",
        "C4_C6": "deferred to survivor jet stage (bilinear / tangent)",
        "wall_s": round(time.time() - t0, 2),
    }
    if verbose:
        print("[L0] profile-only=%d  structure-only=%d  D34 both=%d  "
              "+A4mu2=%d  ker_rows=%d  [%.1fs]"
              % (d_prof, d_struct, d_d34, d_full, K.shape[0],
                 time.time() - t0), flush=True)
        print("[L0] rules %s" % fired, flush=True)
        if d_d34 != 39:
            print("[L0] *** DISCREPANCY vs sealed 39: got %d ***" % d_d34,
                  flush=True)

    return {
        "rec": rec,
        "fr": fr,
        "A": A,
        "C": C,
        "K": K,            # (dim_ker, ns) nullspace basis rows
        "Phi": Phi,        # (nfunc, ns)
        "blocks_d34": blocks_d34,
        "a4_block": a4b,
        "P11": P11,
        "P5on": P5on,
        "fired": fired,
        "p": p,
    }


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    npair = int(sys.argv[2]) if len(sys.argv) > 2 else 100
    npt = int(sys.argv[3]) if len(sys.argv) > 3 else 80
    os.makedirs(RES, exist_ok=True)
    out = build_layer0(p, npair=npair, npt=npt)
    rec = out["rec"]
    fn = os.path.join(RES, "layer0_p%d.json" % p)
    with open(fn, "w") as fh:
        json.dump(rec, fh, indent=1, sort_keys=True)
    print("WROTE", fn)
    # cache nullspace for layer1 (numpy)
    np.save(os.path.join(RES, "layer0_null_p%d.npy" % p), out["K"])
    np.save(os.path.join(RES, "layer0_A_p%d.npy" % p), out["A"])
    np.save(os.path.join(RES, "layer0_C_p%d.npy" % p), out["C"])
    # STOP rule
    if not rec["d34_match"]:
        print("STOP: cannot reproduce ambient dimension <= 39 "
              "(got %d). See rec." % rec["dim_structure_plus_(1,r0)"])
        sys.exit(2)
    print("LAYER0_OK d34=%d layer0=%d" % (
        rec["dim_structure_plus_(1,r0)"], rec["dim_layer0_plus_A4mu2"]))


if __name__ == "__main__":
    main()
