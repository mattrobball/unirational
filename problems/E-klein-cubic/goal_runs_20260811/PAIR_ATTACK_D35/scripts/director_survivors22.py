#!/usr/bin/env python3
"""Director (2026-08-11): the 22 surviving blueprints, pinned down.

After the finisher, the live set at d = 35 is the 22 m = 1 blueprints
possessing an L-row branch with transverse order nu = 0 (multidegree
(35, 0): the minus-lines are NOT in the base locus and the line-row datum
is T restricted to the line).  For each survivor and each of its (35,0)
branches, this script imposes the CERTAIN closed conditions only:

  * the six universal flip conditions (rank 2 on the 39-slice);
  * the branch's L-row FLIP demands: children of the line row whose
    assigned value differs from the character-rule value at (35,0) --
    each such child point (a point ON the minus-line) must be a base
    point: T = 0 there (5 evaluation rows via jet_rows, J = 1).

Keeps are NOT used to kill anything (the retraction of the earlier
census applies; keep-kills need the level-parity analysis and are left
to the audit).  Output: per-survivor, per-branch upper-bound dimensions;
a branch at dimension 0 is soundly dead; a survivor is dead iff all its
branches are.  Both primes.
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


def main(p):
    print("== survivors-22, p =", p)
    fr = SL.build_frame(p, verbose=False)
    A6 = np.load(os.path.join(RES, "layer0_A_p331.npy"))
    C6 = np.load(os.path.join(RES, "layer0_C_p331.npy"))
    NUL = np.load(os.path.join(RES, "layer0_null_p%d.npy" % p)) % p
    ns, nsl = A6.shape[0], NUL.shape[0]
    U6 = np.array(json.load(open(os.path.join(
        RES, "worked_example_p%d.json" % p)))["universal_matrix_6x39"],
        dtype=np.int64).T % p                       # (39, 6)

    from s1enum import Stage1
    from patterns_r5 import build_tagged_ff_tables
    import s3sweep
    E = Stage1(p)
    S2 = s3sweep.FullSweep(E, 2)
    _plain, tagged = build_tagged_ff_tables(E)

    comp0 = np.array(S2.slots[0][2], dtype=np.int64) % p   # W^- basis (2x5)

    pats = json.load(open(os.path.join(
        RES, "patterns_r5_p%d.json" % p)))["patterns"]
    surv = [pt for pt in pats if pt["min_m"] == 1 and
            any(o[1] == 0 for o in pt["a35_L_options"])]
    print("survivors entering:", len(surv))
    a350 = (35, 0)

    # precompute per-kid data for rid 2 at (35, 0)
    kidinfo = []
    for kid in S2.kids:
        U0 = S2.value(a350, kid, None)
        lab0 = S2.own_frame(kid, U0) if U0 is not None else None
        q0 = np.array(kid["qs"][0][0], dtype=np.int64) % p
        w = (q0 @ comp0) % p                        # a point on the line
        kidinfo.append(dict(kid=kid, row=kid["row"], lab0=lab0, w=w))

    # evaluation rows for every kid point once
    W = np.array([ki["w"] for ki in kidinfo], dtype=np.int64) % p
    J1 = SL.jet_rows(fr, A6, C6, W, np.zeros_like(W), 1, deg=DEG)
    EVAL = J1.reshape(ns, len(kidinfo), 5) % p      # (637, nk, 5)

    results = []
    for pt in surv:
        branches = [i for i in pt["compat_ff"]["2"]
                    if list(tagged[2][i].get("a35", [None])) == [35, 0]]
        bres = []
        for bi in branches:
            asg = tagged[2][bi]["assign"]
            asg = {int(k): tuple(v) if isinstance(v, list) else v
                   for k, v in asg.items()}
            cond_cols = [U6]
            nflip = 0
            for j, ki in enumerate(kidinfo):
                if ki["row"] in asg and ki["lab0"] is not None \
                        and asg[ki["row"]] != ki["lab0"]:
                    nflip += 1
                    cond_cols.append((NUL @ (EVAL[:, j, :] % p)) % p)
            M = np.concatenate(cond_cols, axis=1) % p
            r = SL.rref_rank(M.T % p, p)
            bres.append(dict(branch=bi, n_line_flips=nflip,
                             rank=int(r), dim=int(nsl - r)))
        alive = [b for b in bres if b["dim"] > 0]
        results.append(dict(id=pt["id"], hash=pt["hash"],
                            branches=bres,
                            verdict="LIVE" if alive else "DEAD",
                            best_dim=max((b["dim"] for b in bres),
                                         default=0)))
    n_dead = sum(1 for r in results if r["verdict"] == "DEAD")
    n_live = len(results) - n_dead
    dims = sorted(set(r["best_dim"] for r in results if r["verdict"] == "LIVE"))
    print("of %d survivors: %d DEAD by line-flip conditions, %d LIVE; "
          "live dims (upper bounds): %s" % (len(results), n_dead, n_live, dims))
    with open(os.path.join(RES, "survivors22_p%d.json" % p), "w") as f:
        json.dump({"n_in": len(results), "n_dead": n_dead, "n_live": n_live,
                   "live_dims": dims, "detail": results}, f, indent=1)
    return n_dead, n_live, dims


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 331)
