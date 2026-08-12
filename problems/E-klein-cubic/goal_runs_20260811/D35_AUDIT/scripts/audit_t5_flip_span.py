#!/usr/bin/env python3
"""T5 hostile audit: the six flip functionals lie in the span of the plain
line-evaluation functionals (joint rank 10 = rank V1; on the 37-cell the
line-vanishing system has rank 8).
"""
import json
import os
import sys

import numpy as np

import paths
from linalg import nullspace, rref_rank, mat_inv
from reynolds import eval_jet
from slice_at_prime import load_null, our_frame
from audit_t2_sixflip import build_v4_children

AUDIT_RES = paths.AUDIT_RES
DEG = 35


def run(p, npts=40, seed=20260811 + 35):
    print("== T5 flip-in-span-of-line-evals  p=%d" % p)
    fr = our_frame(p)
    A, C, NUL = load_null(p)
    ns, nsl = A.shape[0], NUL.shape[0]
    assert nsl == 39

    # --- six flip functionals on the slice (same construction as T2) ---
    z, Z, Wplus, Wminus, kids6 = build_v4_children(fr, p, pick=0)
    Wmat = np.array([k["w"] for k in kids6], dtype=np.int64) % p
    Ymat = np.array([k["y"] for k in kids6], dtype=np.int64) % p
    JR = eval_jet(fr, A, C, Wmat, Ymat, 2, deg=DEG)
    VAL = JR[:, :, :, 1] % p
    lam_amb = np.zeros((ns, 6), dtype=np.int64)
    for j, kid in enumerate(kids6):
        Bmat = np.concatenate([kid["y"][None, :], kid["yperp"][None, :],
                               Wplus], axis=0) % p
        CINV = mat_inv(Bmat.T % p, p).T % p
        comp = (VAL[:, j, :] @ CINV) % p
        lam_amb[:, j] = comp[:, 0]
    FLIP = (NUL % p) @ (lam_amb % p) % p            # (39, 6)
    r_flip = rref_rank(FLIP.T % p, p)

    # --- plain line-evaluation functionals V1 on one minus-line ---
    # Use the SAME involution z so the geometry is comparable
    I5 = np.eye(5, dtype=np.int64)
    Wm = nullspace((Z + I5) % p, p)
    assert Wm.shape[0] == 2
    rng = np.random.default_rng(seed)
    ab = rng.integers(1, p, size=(npts, 2))
    pts = (ab @ Wm) % p
    J1 = eval_jet(fr, A, C, pts, np.zeros_like(pts), 1, deg=DEG)
    V1 = (NUL @ (J1.reshape(ns, -1) % p)) % p       # (39, npts*5)
    r_v1 = rref_rank(V1.T % p, p)

    # joint rank of [V1 | FLIP]
    JOINT = np.concatenate([V1, FLIP], axis=1) % p
    r_joint = rref_rank(JOINT.T % p, p)

    # flips in span of V1  <=>  joint rank == rank V1
    flips_in_span = (r_joint == r_v1)

    # on the 37-cell = ker of the six flips (rank 2 cut): line-vanishing rank
    # ker of FLIP^T : vectors x in F_p^{39} with FLIP^T x = 0, i.e. x @ FLIP = 0
    # nullspace of FLIP.T is right-null of FLIP.T = left-null of FLIP? 
    # We want right-null of FLIP.T, i.e. {x : FLIP.T @ x = 0} = ker(FLIP.T)
    # Our nullspace(M) returns right-null of M, so nullspace(FLIP.T) works.
    K37 = nullspace(FLIP.T % p, p)                   # (37, 39) if r_flip=2
    dim37 = int(K37.shape[0])
    # restrict V1 to 37-cell: rows of K37 are coords; functional cols become
    # V1_37[i,j] = (K37 @ V1)[i,j] = K37_row_i · V1_col_j
    V1_on_37 = (K37 @ V1) % p                        # (dim37, nfunc)
    r_v1_on_37 = rref_rank(V1_on_37.T % p, p) if dim37 else 0

    out = {
        "p": p, "npts": npts, "seed": seed, "z": int(z),
        "rank_flip": int(r_flip),
        "rank_V1": int(r_v1),
        "rank_joint": int(r_joint),
        "flips_in_span_of_V1": bool(flips_in_span),
        "dim_37_cell": dim37,
        "rank_V1_on_37_cell": int(r_v1_on_37),
        "claim_joint_eq_V1": bool(r_joint == r_v1),
        "claim_V1_rank_10": bool(r_v1 == 10),
        "claim_V1_on_37_rank_8": bool(r_v1_on_37 == 8),
        "note_geometry": (
            "If confirmed: the six flip functionals (transverse (34,1) "
            "readings at the six attaching pairs over type-I points of one "
            "plus-plane) are linear combinations of plain T-evaluations on "
            "the corresponding minus-line. Heuristic: by G-equivariance and "
            "the identity theorem along the line, the (34,1) datum at a point "
            "of the line is determined by the restriction of T to a "
            "neighbourhood of that line — hence by sufficiently many plain "
            "line evaluations after the sealed profile cuts."
        ),
    }
    if flips_in_span and r_v1 == 10 and r_v1_on_37 == 8:
        out["verdict"] = "CONFIRMED"
    elif not flips_in_span or r_v1 != 10 or r_v1_on_37 != 8:
        out["verdict"] = "REFUTED"
        out["witness"] = {
            "rank_V1": int(r_v1), "rank_joint": int(r_joint),
            "rank_V1_on_37": int(r_v1_on_37),
            "expected": "V1=10, joint=V1, V1|37=8",
        }
    else:
        out["verdict"] = "INCONCLUSIVE"
    print("  r_flip", r_flip, "r_V1", r_v1, "r_joint", r_joint,
          "V1|37", r_v1_on_37, "in_span", flips_in_span)
    print("  verdict", out["verdict"])
    os.makedirs(AUDIT_RES, exist_ok=True)
    with open(os.path.join(AUDIT_RES, "t5_flip_span_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=1)
    return out


if __name__ == "__main__":
    primes = [int(x) for x in sys.argv[1:]] or [331, 661, 991]
    for p in primes:
        run(p)
