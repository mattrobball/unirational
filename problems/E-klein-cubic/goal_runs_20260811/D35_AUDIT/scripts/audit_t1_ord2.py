#!/usr/bin/env python3
"""T1 hostile audit: ord ≥ 2 on one minus-line has rank 39 on the slice?

Independent Reynolds evaluation (reynolds.eval_jet), own points/directions,
seeds 331/661/991, different RNG seeds from the director finisher.
"""
import json
import os
import sys

import numpy as np

import paths
from linalg import nullspace, rref_rank
from reynolds import eval_jet
from slice_at_prime import load_null, our_frame

AUDIT_RES = paths.AUDIT_RES
DEG = 35


def minus_line_and_transverse(fr, p, invol_pick=0):
    """Pick an involution; return Wm (2x5), Wp (3x5)."""
    RHO, orders = fr["RHO"], fr["orders"]
    I5 = np.eye(5, dtype=np.int64)
    invs = [g for g in range(660) if orders[g] == 2]
    # different pick from director (which took the first with rich centralizer)
    z = invs[invol_pick % len(invs)]
    Z = RHO[z] % p
    Wm = nullspace((Z + I5) % p, p)
    Wp = nullspace((Z - I5) % p, p)
    assert Wm.shape[0] == 2 and Wp.shape[0] == 3, (Wm.shape, Wp.shape)
    return z, Wm, Wp


def run(p, npts=48, seed=20260811 + 991, invol_pick=3):
    print("== T1 ord>=2  p=%d npts=%d seed=%d invol_pick=%d" %
          (p, npts, seed, invol_pick))
    fr = our_frame(p)
    A, C, NUL = load_null(p)
    ns, nsl = A.shape[0], NUL.shape[0]
    z, Wm, Wp = minus_line_and_transverse(fr, p, invol_pick=invol_pick)

    rng = np.random.default_rng(seed)
    ab = rng.integers(1, p, size=(npts, 2))
    pts = (ab @ Wm) % p

    # V1: T(x)=0  (J=1, zero direction)
    J1 = eval_jet(fr, A, C, pts, np.zeros_like(pts), 1, deg=DEG)
    S1 = (NUL @ (J1.reshape(ns, -1) % p)) % p          # (nsl, npts*5)
    r1 = rref_rank(S1.T % p, p)

    # V2: directional derivatives along three plus-directions
    blocks = [S1]
    for k in range(3):
        Y = np.tile(Wp[k][None, :], (npts, 1)) % p
        J2 = eval_jet(fr, A, C, pts, Y, 2, deg=DEG)[:, :, :, 1]
        blocks.append((NUL @ (J2.reshape(ns, -1) % p)) % p)
    SALL = np.concatenate(blocks, axis=1) % p
    r12 = rref_rank(SALL.T % p, p)

    # saturation: extra points
    ab2 = rng.integers(1, p, size=(16, 2))
    pts2 = (ab2 @ Wm) % p
    J1b = eval_jet(fr, A, C, pts2, np.zeros_like(pts2), 1, deg=DEG)
    S1b = (NUL @ (J1b.reshape(ns, -1) % p)) % p
    r1b = rref_rank(np.concatenate([S1, S1b], axis=1).T % p, p)
    sat_ok = (r1b == r1)

    # second involution (different line) — must also full-rank if claim is G-equivariant
    z2, Wm2, Wp2 = minus_line_and_transverse(fr, p, invol_pick=invol_pick + 7)
    ab3 = rng.integers(1, p, size=(npts, 2))
    pts3 = (ab3 @ Wm2) % p
    blocks2 = []
    J1c = eval_jet(fr, A, C, pts3, np.zeros_like(pts3), 1, deg=DEG)
    blocks2.append((NUL @ (J1c.reshape(ns, -1) % p)) % p)
    for k in range(3):
        Y = np.tile(Wp2[k][None, :], (npts, 1)) % p
        J2 = eval_jet(fr, A, C, pts3, Y, 2, deg=DEG)[:, :, :, 1]
        blocks2.append((NUL @ (J2.reshape(ns, -1) % p)) % p)
    r12_alt = rref_rank(np.concatenate(blocks2, axis=1).T % p, p)

    out = {
        "p": p, "npts": npts, "seed": seed, "invol_pick": invol_pick,
        "z": int(z), "z_alt": int(z2),
        "null_dim": int(nsl),
        "rank_ord1": int(r1), "dim_after_ord1": int(nsl - r1),
        "rank_ord2": int(r12), "dim_after_ord2": int(nsl - r12),
        "rank_ord2_alt_line": int(r12_alt),
        "dim_after_ord2_alt": int(nsl - r12_alt),
        "saturation_ok": bool(sat_ok),
        "claim_rank_ord2_eq_null_dim": bool(r12 == nsl),
        "claim_alt_also_full": bool(r12_alt == nsl),
    }
    # verdict: CONFIRMED only if full rank on slice at this prime
    if r12 == nsl and r12_alt == nsl and sat_ok:
        out["verdict"] = "CONFIRMED"
    elif r12 < nsl:
        out["verdict"] = "REFUTED"
        out["witness"] = {
            "kind": "nonzero_kernel_after_ord2",
            "rank_ord2": int(r12), "null_dim": int(nsl),
            "surviving_dim": int(nsl - r12),
        }
    else:
        out["verdict"] = "INCONCLUSIVE"
    print("  V1 rank", r1, "-> dim", nsl - r1)
    print("  V1+V2 rank", r12, "-> dim", nsl - r12, "  alt-line", r12_alt)
    print("  saturation", sat_ok, " verdict", out["verdict"])
    os.makedirs(AUDIT_RES, exist_ok=True)
    with open(os.path.join(AUDIT_RES, "t1_ord2_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=1)
    return out


if __name__ == "__main__":
    primes = [int(x) for x in sys.argv[1:]] or [331, 661, 991]
    for p in primes:
        run(p)
