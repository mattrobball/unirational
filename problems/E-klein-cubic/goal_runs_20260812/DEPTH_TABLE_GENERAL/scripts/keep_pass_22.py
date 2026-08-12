#!/usr/bin/env python3
"""Deliverable 2 — corrected keep-pass on the 22 survivors at d = 35.

Closed conditions only, using the general depth-value table's period data:

  * period 1 at a forced-deeper row: keep unaffected (value depth-constant);
  * period > 1 with kept value attainable only at levels κ ≡ 0 (mod period):
    level 0 is dead on the slice ⇒ force CLOSED vanishing of levels
    1 … period−1 at that child (higher arc-jets of the (34,1) datum).

Base cell: the sealed 39-slice cut by the universal six flips → dim ≤ 37.
Rigidity anchors at every new functional (transverse W^- components vanish
for all 637 basis covariants).

Content-addressed blueprints from D35_AUDIT repair (not index-linked).
Recomputes the 14 forced-deeper rows in-run (PAIR_ATTACK worked-example
context).

Usage: python3 keep_pass_22.py [p]
"""
import json
import os
import sys
from collections import Counter

import numpy as np

import paths
import slicelib as SL
from s1enum import Stage1
from s3sweep import FullSweep
from s3jet import chi_arc_of, value_at_level

RES = paths.RES
PAIR_RES = paths.PAIR_RES
AUDIT_RES = paths.AUDIT_RES
DEG = 35
os.makedirs(RES, exist_ok=True)

SURV_IDS = [5, 7, 13, 15, 21, 23, 29, 31, 37, 39, 45, 47,
            53, 55, 61, 63, 69, 71, 697, 699, 701, 703]


def inv_mod(M, p):
    n = M.shape[0]
    A = np.concatenate([M % p, np.eye(n, dtype=np.int64)], axis=1) % p
    r = 0
    for c in range(n):
        piv = None
        for i in range(r, n):
            if A[i, c] % p:
                piv = i
                break
        assert piv is not None, "singular"
        A[[r, piv]] = A[[piv, r]]
        A[r] = (A[r] * pow(int(A[r, c]), p - 2, p)) % p
        for i in range(n):
            if i != r and A[i, c] % p:
                A[i] = (A[i] - A[i, c] * A[r]) % p
        r += 1
    return A[:, n:] % p


def nullspace_rows(M, p):
    return SL.nullspace(np.array(M, dtype=np.int64) % p, p)


def eig_split(Ms, p, signs):
    I5 = np.eye(5, dtype=np.int64)
    B = I5.copy()
    for M, s in zip(Ms, signs):
        rows = nullspace_rows((M - (s % p) * I5) % p, p)
        big = np.concatenate([B, (-rows) % p], axis=0)
        ker = nullspace_rows(big.T % p, p)
        if ker.shape[0] == 0:
            return np.zeros((0, 5), dtype=np.int64)
        B = (ker[:, :B.shape[0]] @ B) % p
        keep = []
        for v in B:
            test = np.array(keep + [v], dtype=np.int64)
            if SL.rref_rank(test % p, p) == len(keep) + 1:
                keep.append(v % p)
        B = (np.array(keep, dtype=np.int64) if keep
             else np.zeros((0, 5), dtype=np.int64))
    return B % p


def build_v4_children(fr, p):
    """Six universal flip attaching pairs (director_worked_example)."""
    RHO, orders = fr["RHO"], fr["orders"]
    I5 = np.eye(5, dtype=np.int64)
    invs = [g for g in range(660) if orders[g] == 2]
    z = None
    for cand in invs:
        Z = RHO[cand] % p
        partners = [h for h in invs if h != cand and
                    np.array_equal((RHO[h] @ Z) % p, (Z @ RHO[h]) % p)]
        if len(partners) >= 4:
            z, plist = cand, partners
            break
    assert z is not None
    Z = RHO[z] % p
    Ks, used = [], set()
    for s in plist:
        if s in used:
            continue
        ZS = (Z @ RHO[s]) % p
        mate = [h for h in plist if np.array_equal(RHO[h] % p, ZS)]
        assert len(mate) == 1
        used.update({s, mate[0]})
        Ks.append((s, mate[0]))
    assert len(Ks) == 3
    Wplus = nullspace_rows((Z - I5) % p, p)
    Wminus = nullspace_rows((Z + I5) % p, p)
    children = []
    for (s, zs) in Ks:
        Sm = RHO[s] % p
        Bln = eig_split([Z, Sm], p, [1, -1])
        Cln = eig_split([Z, Sm], p, [-1, 1])
        Dln = eig_split([Z, Sm], p, [-1, -1])
        for (y, yperp, tag) in ((Cln[0], Dln[0], "C"), (Dln[0], Cln[0], "D")):
            children.append({
                "K": (z, s, zs), "w": Bln[0] % p, "y": y % p,
                "yperp": yperp % p, "tag": tag,
            })
    assert len(children) == 6
    return z, Z, Wplus, Wminus, children


def vec5p(U, p):
    return np.array(U, dtype=np.int64).reshape(-1) % p


def label_at(S, a, kid, kappa, chi):
    U = value_at_level(S, a, kid, kappa, None, chi)
    if U is None:
        return None
    return S.own_frame(kid, U)


def lab_eq(a, b):
    if a is None or b is None:
        return False
    return json.dumps(a, sort_keys=True) == json.dumps(b, sort_keys=True)


def assign_from_embed(entry):
    """embedded_ff entry -> {row: label}."""
    out = {}
    for r, lab in entry["assign"]:
        out[int(r)] = lab
    return out


def main(p):
    print("== keep-pass on the 22  p=%d" % p, flush=True)
    fr = SL.build_frame(p, verbose=False)
    # sealed Layer-0 seeds (prime-independent exponents) + null at p
    A6 = np.load(os.path.join(PAIR_RES, "layer0_A_p331.npy"))
    C6 = np.load(os.path.join(PAIR_RES, "layer0_C_p331.npy"))
    NUL = np.load(os.path.join(PAIR_RES, "layer0_null_p%d.npy" % p)) % p
    ns, nsl = A6.shape[0], NUL.shape[0]
    assert (ns, nsl) == (637, 39)

    # ---- universal six flips → 37-cell ----
    z, Z, Wplus, Wminus, kids6 = build_v4_children(fr, p)
    Wmat = np.array([k["w"] for k in kids6], dtype=np.int64) % p
    Ymat = np.array([k["y"] for k in kids6], dtype=np.int64) % p
    JR = SL.jet_rows(fr, A6, C6, Wmat, Ymat, 2, deg=DEG)
    VAL = JR[:, :, :, 1] % p
    lam_amb = np.zeros((ns, 6), dtype=np.int64)
    r1_bad = 0
    for j, kid in enumerate(kids6):
        Bmat = np.concatenate([kid["y"][None, :], kid["yperp"][None, :],
                               Wplus], axis=0) % p
        CINV = inv_mod(Bmat.T % p, p).T % p
        comp = (VAL[:, j, :] @ CINV) % p
        lam_amb[:, j] = comp[:, 0]
        r1_bad += int(np.count_nonzero(comp[:, 1] % p))
    assert r1_bad == 0, "universal rigidity failed: %d" % r1_bad
    LAM_SLICE = (NUL % p) @ (lam_amb % p) % p   # (39, 6)
    r6 = SL.rref_rank(LAM_SLICE.T % p, p)
    assert r6 == 2, "universal rank expected 2, got %d" % r6
    # 37-cell basis: right-null of LAM_SLICE^T
    CELL37 = SL.nullspace(LAM_SLICE.T % p, p) % p   # (37, 39)
    assert CELL37.shape == (37, nsl)
    print("  universal six: rank %d → 37-cell" % r6)

    # ---- STAGE1 rid-1 children, forced-deeper rows ----
    E = Stage1(p)
    S1 = FullSweep(E, 1)
    Z1 = np.array(S1.sig, dtype=np.int64) % p
    hits = [i for i in range(660)
            if np.array_equal(fr["RHO"][i] % p, Z1)]
    assert hits, "TIGHTEN/D34 realization mismatch"
    inv2 = pow(2, p - 2, p)
    Pminus = ((np.eye(5, dtype=np.int64) - Z1) * inv2) % p
    Wp1 = nullspace_rows((Z1 - np.eye(5, dtype=np.int64)) % p, p)
    assert Wp1.shape[0] == 3
    comp0 = np.array(S1.slots[0][2], dtype=np.int64) % p
    comp1 = np.array(S1.slots[1][2], dtype=np.int64) % p

    a35 = (34, 1)
    # build per-kid records with attaching pairs + period + cycle
    allrecs = []
    for kid in S1.kids:
        chi, per = chi_arc_of(S1, kid)
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
        U0v = vec5p(U0, p)
        others = [vec5p(U, p) for (_chi, U) in kid["lines"]
                  if not np.array_equal(vec5p(U, p), U0v)]
        if not others:
            continue
        cycle = [label_at(S1, a35, kid, k, chi) for k in range(per)]
        # levels where each cycle label appears
        levels_for = {}
        for k, lab in enumerate(cycle):
            if lab is None:
                continue
            key = json.dumps(lab, sort_keys=True)
            levels_for.setdefault(key, []).append(k)
        allrecs.append(dict(
            kid_idx=int(kid["idx"]), row=int(kid["row"]),
            w=w, y=y, U0=U0v, Ut=others[0], lab0=lab0,
            period=int(per), cycle=cycle, levels_for=levels_for,
            chi=chi, kid=kid,
        ))

    # level-0 functionals on the 39-slice → forced-deeper rows
    Wm_ = np.array([r["w"] for r in allrecs], dtype=np.int64) % p
    Ym_ = np.array([r["y"] for r in allrecs], dtype=np.int64) % p
    # need jets up to order 4 (period ≤ 3 ⇒ levels 1,2 use t^2, t^3)
    Jmax = 4
    JALL = SL.jet_rows(fr, A6, C6, Wm_, Ym_, Jmax, deg=DEG) % p
    # level-0 = t^1
    lam0 = np.zeros((ns, len(allrecs)), dtype=np.int64)
    rig0 = 0
    CINVS = []
    for j, r in enumerate(allrecs):
        Bmat = np.concatenate([r["U0"][None, :], r["Ut"][None, :],
                               Wp1], axis=0) % p
        CINV = inv_mod(Bmat.T % p, p).T % p
        CINVS.append(CINV)
        comp = (JALL[:, j, :, 1] @ CINV) % p
        lam0[:, j] = comp[:, 0]
        rig0 += int(np.count_nonzero(comp[:, 1] % p))
    assert rig0 == 0, "level-0 rigidity failed: %d" % rig0
    K0 = ((NUL % p) @ lam0) % p
    zero_on_slice = {}
    for j, r in enumerate(allrecs):
        zero_on_slice.setdefault(r["row"], []).append(
            not bool(np.any(K0[:, j] % p)))
    dead_rows = sorted(r0 for r0, zs in zero_on_slice.items() if all(zs))
    live_rows = sorted(r0 for r0, zs in zero_on_slice.items() if not all(zs))
    print("  forced-deeper rows: %d of %d: %s"
          % (len(dead_rows), len(zero_on_slice), dead_rows))
    assert len(dead_rows) == 14 and len(zero_on_slice) == 18

    # precompute higher-level functionals (t^{κ+1} component along U0)
    # level κ uses jet order κ+1
    level_lams = {}  # kappa -> (ns, nrecs)
    level_rig = {}
    for kappa in range(0, Jmax - 1):
        lam = np.zeros((ns, len(allrecs)), dtype=np.int64)
        rb = 0
        for j, r in enumerate(allrecs):
            comp = (JALL[:, j, :, kappa + 1] @ CINVS[j]) % p
            lam[:, j] = comp[:, 0]
            rb += int(np.count_nonzero(comp[:, 1] % p))
        level_lams[kappa] = lam
        level_rig[kappa] = rb
        print("  level-%d rigidity violations: %d / %d"
              % (kappa, rb, ns * len(allrecs)))
        assert rb == 0, "level-%d rigidity failed" % kappa

    # ---- load content-addressed 22 ----
    content = json.load(open(os.path.join(
        AUDIT_RES, "patterns_r5_content_p%d.json" % p)))
    pats = {pt["id"]: pt for pt in content["patterns"]}
    for sid in SURV_IDS:
        assert sid in pats, "missing survivor %d" % sid

    results = []
    n_dead = 0
    n_live = 0
    live_dims = []
    total_closed_conds = Counter()

    for sid in SURV_IDS:
        pt = pats[sid]
        # all embedded rid-1 branches with a = (34, 1)
        branches = [e for e in pt["embedded_ff"]["1"] if e["a35"] == [34, 1]]
        assert branches, "survivor %d has no (34,1) embed" % sid
        bres = []
        for bi, entry in enumerate(branches):
            asg = assign_from_embed(entry)
            # classify keeps at forced-deeper rows
            closed_kids = []   # (j, kappa_list) to impose
            open_demands = []  # recorded, not imposed
            period1_keeps = []
            for j, r in enumerate(allrecs):
                row = r["row"]
                if row not in dead_rows:
                    continue
                if row not in asg:
                    continue
                V = asg[row]
                per = r["period"]
                key = json.dumps(V, sort_keys=True)
                levs = r["levels_for"].get(key, [])
                if per == 1:
                    period1_keeps.append({
                        "kid_idx": r["kid_idx"], "row": row,
                        "note": "period-1: value depth-constant; no closed cond",
                    })
                    continue
                # period > 1
                if not levs:
                    open_demands.append({
                        "kid_idx": r["kid_idx"], "row": row, "period": per,
                        "assigned": V,
                        "note": "assigned label not in cycle; open/unmatched",
                    })
                    continue
                # attainable only at levels ≡ 0 (mod period)?
                only_mod0 = all(k % per == 0 for k in levs)
                if only_mod0:
                    # force levels 1 .. period-1 vanish
                    kappas = list(range(1, per))
                    closed_kids.append({
                        "kid_idx": r["kid_idx"], "row": row, "period": per,
                        "rec_index": j, "kappas": kappas,
                        "assigned_matches_lab0": lab_eq(V, r["lab0"]),
                    })
                else:
                    open_demands.append({
                        "kid_idx": r["kid_idx"], "row": row, "period": per,
                        "levels": levs,
                        "note": ("kept value at levels %s; openness demand "
                                 "(not used to kill)" % levs),
                    })

            # build closed condition matrix on the 37-cell
            # CELL37 is (37, 39); functionals on 39-slice: col of (NUL @ lam)
            # on 37-cell: CELL37 @ (NUL @ lam_col)
            cols = []
            for ck in closed_kids:
                j = ck["rec_index"]
                for kappa in ck["kappas"]:
                    lam = level_lams[kappa][:, j]   # (637,)
                    on39 = ((NUL % p) @ lam) % p   # (39,)
                    on37 = (CELL37 @ on39) % p     # (37,)
                    cols.append(on37)
            if cols:
                M = np.stack(cols, axis=1) % p     # (37, ncond)
                rank = int(SL.rref_rank(M.T % p, p))
                dim = 37 - rank
            else:
                M = np.zeros((37, 0), dtype=np.int64)
                rank = 0
                dim = 37
            total_closed_conds[len(closed_kids)] += 1
            verdict = "LIVE" if dim > 0 else "DEAD"
            bres.append({
                "branch": bi,
                "content_key": entry.get("content_key"),
                "n_closed_kid_sites": len(closed_kids),
                "n_closed_functionals": int(M.shape[1]),
                "closed_kids": [{k: v for k, v in ck.items()
                                 if k != "rec_index"} for ck in closed_kids],
                "n_period1_keeps": len(period1_keeps),
                "n_open_demands": len(open_demands),
                "open_demands": open_demands,
                "rank": rank,
                "dim": int(dim),
                "verdict": verdict,
            })
        alive = [b for b in bres if b["dim"] > 0]
        best = max((b["dim"] for b in bres), default=0)
        v = "LIVE" if alive else "DEAD"
        if v == "DEAD":
            n_dead += 1
        else:
            n_live += 1
            live_dims.append(best)
        results.append({
            "id": sid,
            "content_hash": pt["content_hash"],
            "sealed_hash": pt["sealed_hash"],
            "branches": bres,
            "verdict": v,
            "best_dim": best,
        })
        print("  id %d: %s best_dim=%d  closed_sites=%s"
              % (sid, v, best,
                 [b["n_closed_kid_sites"] for b in bres]))

    live_dims_u = sorted(set(live_dims))
    out = {
        "p": p,
        "n_survivors_in": 22,
        "forced_deeper_rows": dead_rows,
        "live_rows_level0": live_rows,
        "n_value_defined_rows": len(zero_on_slice),
        "universal_rank": int(r6),
        "cell37_dim": 37,
        "level_rigidity": {str(k): int(v) for k, v in level_rig.items()},
        "n_dead": n_dead,
        "n_live": n_live,
        "live_dims": live_dims_u,
        "detail": results,
        "headline": ("Problem E remains OPEN; this packet excludes no degree."),
        "note": (
            "Closed conditions only: period>1 keeps of a κ≡0-only value at a "
            "forced-deeper child force levels 1..period-1 to vanish. Period-1 "
            "keeps and non-mod0 keeps are recorded as open demands, not kills."
        ),
    }
    path = os.path.join(RES, "keep_pass_22_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(out, f, indent=1)
    print("  wrote", path)
    print("  SUMMARY: dead=%d live=%d dims=%s" % (n_dead, n_live, live_dims_u))
    return out


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 331)
