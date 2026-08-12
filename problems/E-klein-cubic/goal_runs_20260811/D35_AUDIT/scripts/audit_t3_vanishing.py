#!/usr/bin/env python3
"""T3 hostile audit: 14 of 18 value-defined rid-1 rows have level-0 reading
identically zero on the 39-slice.

Interpretation check (not a value contradiction except at period-2 children)
is recorded; the machine claim is the vanishing count itself.
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


def run(p):
    print("== T3 vanishing table  p=%d" % p)
    fr = our_frame(p)
    A, C, NUL = load_null(p)
    ns, nsl = A.shape[0], NUL.shape[0]

    # STAGE1 frame for child attaching pairs (same realization check)
    from s1enum import Stage1
    import s3sweep
    E = Stage1(p)
    S1 = s3sweep.FullSweep(E, 1)
    Z1 = np.array(S1.sig, dtype=np.int64) % p
    hits = [i for i in range(660)
            if np.array_equal(fr["RHO"][i] % p, Z1)]
    assert hits, "TIGHTEN and audit frames disagree on realization"
    inv2 = pow(2, p - 2, p)
    Pminus = ((np.eye(5, dtype=np.int64) - Z1) * inv2) % p
    Wp1 = nullspace((Z1 - np.eye(5, dtype=np.int64)) % p, p)
    assert Wp1.shape[0] == 3
    comp0 = np.array(S1.slots[0][2], dtype=np.int64) % p
    comp1 = np.array(S1.slots[1][2], dtype=np.int64) % p

    a35 = (34, 1)
    allrecs = []
    for kid in S1.kids:
        U0 = S1.value(a35, kid, None)
        if U0 is None or kid.get("mu") is None:
            continue
        lab0 = S1.own_frame(kid, U0)
        if lab0 is None:
            continue
        q0 = np.array(kid["qs"][0][0], dtype=np.int64) % p
        q1 = np.array(kid["qs"][1][0], dtype=np.int64) % p
        w = (q0 @ comp0) % p
        y = ((q1 @ comp1) @ Pminus.T) % p
        if not np.any(y % p):
            continue

        def vec5(U):
            return np.array(U, dtype=np.int64).reshape(-1) % p
        U0v = vec5(U0)
        others = [vec5(U) for (_chi, U) in kid["lines"]
                  if not np.array_equal(vec5(U), U0v)]
        if not others:
            continue
        allrecs.append(dict(kid_idx=kid["idx"], row=kid["row"], w=w, y=y,
                            U0=U0v, Ut=others[0], lab0=lab0))

    if not allrecs:
        out = {"p": p, "verdict": "REFUTED", "witness": "no value-defined kids"}
        with open(os.path.join(AUDIT_RES, "t3_vanishing_p%d.json" % p), "w") as f:
            json.dump(out, f, indent=1)
        return out

    Wm_ = np.array([r["w"] for r in allrecs], dtype=np.int64) % p
    Ym_ = np.array([r["y"] for r in allrecs], dtype=np.int64) % p
    J2 = eval_jet(fr, A, C, Wm_, Ym_, 2, deg=DEG)[:, :, :, 1] % p
    lam = np.zeros((ns, len(allrecs)), dtype=np.int64)
    rig_bad = 0
    for j, r in enumerate(allrecs):
        Bmat = np.concatenate([r["U0"][None, :], r["Ut"][None, :],
                               Wp1], axis=0) % p
        CINV = mat_inv(Bmat.T % p, p).T % p
        comp = (J2[:, j, :] @ CINV) % p
        lam[:, j] = comp[:, 0]
        rig_bad += int(np.count_nonzero(comp[:, 1] % p))
    assert rig_bad == 0, "T3 rigidity failed: %d" % rig_bad

    KALL = ((NUL % p) @ lam) % p
    zero_on_slice = {}
    for j, r in enumerate(allrecs):
        zero_on_slice.setdefault(r["row"], []).append(
            not bool(np.any(KALL[:, j] % p)))
    dead_rows = sorted(r0 for r0, zs in zero_on_slice.items() if all(zs))
    live_rows = sorted(r0 for r0, zs in zero_on_slice.items() if not all(zs))
    n_defined = len(zero_on_slice)

    # Sealed row ids from director worked_example at p=331 only.
    # Row ids are prime-dependent (STAGE1 coords over F_p); the claim is the
    # count 14-of-18, not a fixed id list across primes.
    sealed_dead_p331 = [23, 24, 35, 36, 37, 38, 41, 42, 43, 44, 45, 46, 68, 69]
    match_sealed_p331 = (dead_rows == sealed_dead_p331)

    out = {
        "p": p,
        "n_value_defined_rows": n_defined,
        "n_forced_deeper": len(dead_rows),
        "forced_deeper_rows": dead_rows,
        "live_rows": live_rows,
        "rigidity_violations": int(rig_bad),
        "matches_director_count_14_of_18": bool(
            len(dead_rows) == 14 and n_defined == 18),
        "matches_sealed_row_ids_p331": bool(match_sealed_p331),
        "sealed_dead_rows_p331": sealed_dead_p331,
        "note_row_ids": (
            "Row ids are prime-dependent; only p=331 is expected to match "
            "the sealed id list. The load-bearing claim is the count 14/18."
        ),
        "interpretation": (
            "level-0 reading vanishes on the whole 39-slice at these rows; "
            "readings live deeper. This is NOT a value contradiction except "
            "where arc-character period > 1 (see T4)."
        ),
    }
    if len(dead_rows) == 14 and n_defined == 18:
        # at p=331 also require id match as an anchor
        if p == 331 and not match_sealed_p331:
            out["verdict"] = "REFUTED"
            out["witness"] = {
                "kind": "p331_row_id_mismatch",
                "ours": dead_rows, "sealed": sealed_dead_p331,
            }
        else:
            out["verdict"] = "CONFIRMED"
    else:
        out["verdict"] = "REFUTED"
        out["witness"] = {
            "n_forced_deeper": len(dead_rows),
            "n_defined": n_defined,
            "rows": dead_rows,
            "expected": "14 of 18",
        }
    print("  defined", n_defined, "forced-deeper", len(dead_rows), dead_rows)
    print("  count 14/18", len(dead_rows) == 14 and n_defined == 18,
          "p331-ids", match_sealed_p331, " verdict", out["verdict"])
    os.makedirs(AUDIT_RES, exist_ok=True)
    with open(os.path.join(AUDIT_RES, "t3_vanishing_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=1)
    return out


if __name__ == "__main__":
    primes = [int(x) for x in sys.argv[1:]] or [331, 661]
    for p in primes:
        run(p)
