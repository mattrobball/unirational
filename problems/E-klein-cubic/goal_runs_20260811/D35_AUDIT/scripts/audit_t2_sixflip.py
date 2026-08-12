#!/usr/bin/env python3
"""T2 hostile audit: universal six-flip cut has rank 2 on the slice;
ambient rank exactly 2 (ODDZERO F1 by independent route).
"""
import json
import os
import sys

import numpy as np

import paths
from linalg import nullspace, rref_rank, mat_inv
from reynolds import eval_jet
from slice_at_prime import load_null, our_frame

AUDIT_RES = paths.AUDIT_RES
DEG = 35


def eig_split(Ms, p, signs):
    I5 = np.eye(5, dtype=np.int64)
    B = I5.copy()
    for M, s in zip(Ms, signs):
        rows = nullspace((M - (s % p) * I5) % p, p)
        big = np.concatenate([B, (-rows) % p], axis=0)
        ker = nullspace(big.T % p, p)
        if ker.shape[0] == 0:
            return np.zeros((0, 5), dtype=np.int64)
        B = (ker[:, :B.shape[0]] @ B) % p
        keep = []
        for v in B:
            test = np.array(keep + [v], dtype=np.int64)
            if rref_rank(test % p, p) == len(keep) + 1:
                keep.append(v % p)
        B = np.array(keep, dtype=np.int64) if keep else np.zeros((0, 5),
                                                                 dtype=np.int64)
    return B % p


def build_v4_children(fr, p, pick=0):
    """Three V4s through an involution; six attaching pairs. Independent pick."""
    RHO, orders = fr["RHO"], fr["orders"]
    I5 = np.eye(5, dtype=np.int64)
    invs = [g for g in range(660) if orders[g] == 2]
    candidates = []
    for cand in invs:
        Z = RHO[cand] % p
        partners = [h for h in invs if h != cand and
                    np.array_equal((RHO[h] @ Z) % p, (Z @ RHO[h]) % p)]
        if len(partners) >= 4:
            candidates.append((cand, partners))
    assert candidates, "no V4-rich involution"
    z, plist = candidates[pick % len(candidates)]
    Z = RHO[z] % p
    Ks, used = [], set()
    for s in plist:
        if s in used:
            continue
        ZS = (Z @ RHO[s]) % p
        mate = [h for h in plist if np.array_equal(RHO[h] % p, ZS)]
        if len(mate) != 1:
            continue
        used.update({s, mate[0]})
        Ks.append((s, mate[0]))
    assert len(Ks) >= 3, len(Ks)
    Ks = Ks[:3]
    Wplus = nullspace((Z - I5) % p, p)
    Wminus = nullspace((Z + I5) % p, p)
    children = []
    for (s, zs) in Ks:
        Sm = RHO[s] % p
        Bln = eig_split([Z, Sm], p, [1, -1])
        Cln = eig_split([Z, Sm], p, [-1, 1])
        Dln = eig_split([Z, Sm], p, [-1, -1])
        assert Bln.shape[0] == 1 and Cln.shape[0] == 1 and Dln.shape[0] == 1
        for (y, yperp, tag) in ((Cln[0], Dln[0], "C"), (Dln[0], Cln[0], "D")):
            children.append({
                "K": (z, s, zs), "w": Bln[0] % p, "y": y % p,
                "yperp": yperp % p, "tag": tag,
            })
    assert len(children) == 6
    return z, Z, Wplus, Wminus, children


def run(p, pick=0, seed_offset=17):
    print("== T2 six-flip  p=%d pick=%d" % (p, pick))
    fr = our_frame(p)
    A, C, NUL = load_null(p)
    ns, nsl = A.shape[0], NUL.shape[0]
    z, Z, Wplus, Wminus, kids6 = build_v4_children(fr, p, pick=pick)

    Wmat = np.array([k["w"] for k in kids6], dtype=np.int64) % p
    Ymat = np.array([k["y"] for k in kids6], dtype=np.int64) % p
    # independent jet extraction: t^1 block = bidegree (34,1) leading datum
    JR = eval_jet(fr, A, C, Wmat, Ymat, 2, deg=DEG)
    VAL = JR[:, :, :, 1] % p

    lam_amb = np.zeros((ns, 6), dtype=np.int64)
    r1_bad = 0
    for j, kid in enumerate(kids6):
        Bmat = np.concatenate([kid["y"][None, :], kid["yperp"][None, :],
                               Wplus], axis=0) % p
        CINV = mat_inv(Bmat.T % p, p).T % p
        comp = (VAL[:, j, :] @ CINV) % p
        lam_amb[:, j] = comp[:, 0]
        r1_bad += int(np.count_nonzero(comp[:, 1] % p))
    r_amb = rref_rank(lam_amb.T % p, p)
    LAM_SLICE = (NUL % p) @ (lam_amb % p) % p
    r6 = rref_rank(LAM_SLICE.T % p, p)

    # profile: W+ components of (34,1) vanish on the slice (ladder P+ cut)
    r2_bad = 0
    SLICE_VAL = np.einsum('ks,sjc->kjc', NUL % p, VAL) % p
    for j, kid in enumerate(kids6):
        Bmat = np.concatenate([kid["y"][None, :], kid["yperp"][None, :],
                               Wplus], axis=0) % p
        CINV = mat_inv(Bmat.T % p, p).T % p
        comp = (SLICE_VAL[:, j, :] @ CINV) % p
        r2_bad += int(np.count_nonzero(comp[:, 2:] % p))

    out = {
        "p": p, "pick": pick, "z": int(z),
        "r1_rigidity_violations": int(r1_bad),
        "r1_checks": int(ns * 6),
        "r2_profile_violations": int(r2_bad),
        "r2_checks": int(nsl * 6 * 3),
        "ambient_rank": int(r_amb),
        "slice_rank": int(r6),
        "dim_universal": int(nsl - r6),
        "universal_matrix_6x_slice": LAM_SLICE.T.tolist(),  # (6, nsl)
        "claim_ambient_rank_2": bool(r_amb == 2),
        "claim_slice_rank_2": bool(r6 == 2),
    }
    if r1_bad == 0 and r_amb == 2 and r6 == 2:
        out["verdict"] = "CONFIRMED"
    elif r_amb != 2 or r6 != 2:
        out["verdict"] = "REFUTED"
        out["witness"] = {
            "ambient_rank": int(r_amb), "slice_rank": int(r6),
            "expected": 2,
        }
    else:
        out["verdict"] = "INCONCLUSIVE"
        out["note"] = "rigidity failed"
    print("  R1 bad", r1_bad, " ambient", r_amb, " slice", r6,
          " verdict", out["verdict"])
    os.makedirs(AUDIT_RES, exist_ok=True)
    with open(os.path.join(AUDIT_RES, "t2_sixflip_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=1)
    return out


if __name__ == "__main__":
    primes = [int(x) for x in sys.argv[1:]] or [331, 661, 991]
    for p in primes:
        run(p)
