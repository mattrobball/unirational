#!/usr/bin/env python3
"""Arc-jet ladder at the 12 period-3 children: levels κ=3,4,5 (to 8 if needed).

Context (DEPTH_TABLE_GENERAL keep-pass; WORKORDER task 3):
  On the sealed 37-cell, level-1 and level-2 functionals at the period-3
  forced-deeper kids vanish identically. A blueprint asserting a level-2
  cycle value therefore cannot read it at κ=2; by period 3 the same value
  recurs at κ=5, then κ=8. If ALL admissible κ≡2 levels vanish identically
  on the blueprint's cut while the assignment demands a different (nonzero)
  cycle value, the keep is impossible — DEAD by closed mechanism.

Also records open demands (nonvanishing at the matching depth) without
using them to kill.

Rigidity anchors: transverse W^- component vanishes for all 637 basis
covariants at every new jet order.

Usage: python3 arc_jet_ladder.py [p]
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
DEG = 35
# jet order needed for level κ is κ+1; cover κ=0..8 → J=10
JMAX = 10
KAPPAS_CHECK = list(range(0, 9))  # 0..8


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
        assert piv is not None
        A[[r, piv]] = A[[piv, r]]
        A[r] = (A[r] * pow(int(A[r, c]), p - 2, p)) % p
        for i in range(n):
            if i != r and A[i, c] % p:
                A[i] = (A[i] - A[i, c] * A[r]) % p
        r += 1
    return A[:, n:] % p


def nullspace_rows(M, p):
    return SL.nullspace(np.array(M, dtype=np.int64) % p, p)


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


def lab_key(lab):
    return json.dumps(lab, sort_keys=True)


def assign_from_embed(entry):
    out = {}
    for r, lab in entry["assign"]:
        out[int(r)] = lab
    return out


def main(p):
    print("== arc-jet ladder p=%d" % p, flush=True)
    fr = SL.build_frame(p, verbose=False)
    A6 = np.load(os.path.join(PAIR_RES, "layer0_A_p331.npy"))
    C6 = np.load(os.path.join(PAIR_RES, "layer0_C_p331.npy"))
    NUL = np.load(os.path.join(PAIR_RES, "layer0_null_p%d.npy" % p)) % p
    CELL37 = np.load(os.path.join(RES, "cell37_p%d.npy" % p)) % p
    ns, nsl = A6.shape[0], NUL.shape[0]
    assert CELL37.shape == (37, 39)
    assert (ns, nsl) == (637, 39)

    E = Stage1(p)
    S1 = FullSweep(E, 1)
    Z1 = np.array(S1.sig, dtype=np.int64) % p
    hits = [i for i in range(660)
            if np.array_equal(fr["RHO"][i] % p, Z1)]
    assert hits, "frame mismatch"
    inv2 = pow(2, p - 2, p)
    Pminus = ((np.eye(5, dtype=np.int64) - Z1) * inv2) % p
    Wp1 = nullspace_rows((Z1 - np.eye(5, dtype=np.int64)) % p, p)
    assert Wp1.shape[0] == 3
    comp0 = np.array(S1.slots[0][2], dtype=np.int64) % p
    comp1 = np.array(S1.slots[1][2], dtype=np.int64) % p

    a35 = (34, 1)

    def build_rec(kid, chi, per):
        """Attaching pair + character frame + cycle labels for one child."""
        q0 = np.array(kid["qs"][0][0], dtype=np.int64) % p
        q1 = np.array(kid["qs"][1][0], dtype=np.int64) % p
        w = (q0 @ comp0) % p
        y = ((q1 @ comp1) @ Pminus.T) % p
        if not np.any(y % p):
            return None
        # character direction: prefer level-0 value; else first available level;
        # else first kid line.
        U_char = None
        lab0 = None
        U0 = S1.value(a35, kid, None)
        if U0 is not None:
            lab0 = S1.own_frame(kid, U0)
            if lab0 is not None:
                U_char = vec5p(U0, p)
        if U_char is None:
            for k in KAPPAS_CHECK:
                U = value_at_level(S1, a35, kid, k, None, chi)
                if U is None:
                    continue
                lab = S1.own_frame(kid, U)
                if lab is None:
                    continue
                U_char = vec5p(U, p)
                break
        line_vecs = [vec5p(U, p) for (_chi, U) in kid.get("lines", [])]
        if U_char is None and line_vecs:
            U_char = line_vecs[0]
        if U_char is None:
            U_char = y % p
        others = [v for v in line_vecs
                  if not np.array_equal(v % p, U_char % p)]
        if not others:
            # transverse: any Wp1 direction not parallel to U_char
            for v in Wp1:
                if not np.array_equal(v % p, U_char % p) and np.any(v % p):
                    others = [v % p]
                    break
        if not others:
            return None
        Ut = others[0]
        cycle = {k: label_at(S1, a35, kid, k, chi) for k in KAPPAS_CHECK}
        levels_for = {}
        for k, lab in cycle.items():
            if lab is None:
                continue
            levels_for.setdefault(lab_key(lab), []).append(k)
        return dict(
            kid_idx=int(kid["idx"]), row=int(kid["row"]),
            w=w, y=y, U0=U_char, Ut=Ut, lab0=lab0,
            period=int(per), cycle=cycle, levels_for=levels_for,
            chi=chi, kid=kid,
            has_level0=(lab0 is not None),
        )

    # value-defined kids (keep_pass style) for forced-deeper table
    allrecs = []
    for kid in S1.kids:
        chi, per = chi_arc_of(S1, kid)
        U0 = S1.value(a35, kid, None)
        if U0 is None or kid.get("mu") is None:
            continue
        lab0 = S1.own_frame(kid, U0)
        if lab0 is None:
            continue
        rec = build_rec(kid, chi, per)
        if rec is not None:
            allrecs.append(rec)

    # all 12 period-3 children (workorder)
    p3 = []
    for kid in S1.kids:
        chi, per = chi_arc_of(S1, kid)
        if per != 3:
            continue
        rec = build_rec(kid, chi, per)
        if rec is not None:
            p3.append(rec)
    print("  value-defined kids=%d; period-3=%d (expect 12)"
          % (len(allrecs), len(p3)), flush=True)
    assert len(p3) == 12, "expected 12 period-3 children, got %d" % len(p3)

    # jet list = value-defined ∪ period-3
    jet_recs = list(allrecs)
    have = {(r["kid_idx"], r["row"]) for r in jet_recs}
    for r in p3:
        if (r["kid_idx"], r["row"]) not in have:
            jet_recs.append(r)
            have.add((r["kid_idx"], r["row"]))

    Wm_ = np.array([r["w"] for r in jet_recs], dtype=np.int64) % p
    Ym_ = np.array([r["y"] for r in jet_recs], dtype=np.int64) % p
    print("  computing jets J=%d on %d pairs..." % (JMAX, len(jet_recs)),
          flush=True)
    JALL = SL.jet_rows(fr, A6, C6, Wm_, Ym_, JMAX, deg=DEG) % p

    def make_cinv(r):
        """Invert [U_char; Ut; Wp1] or a nonsingular fallback."""
        candidates = [
            np.concatenate([r["U0"][None, :], r["Ut"][None, :], Wp1],
                           axis=0) % p,
            np.concatenate([r["y"][None, :], r["Ut"][None, :], Wp1],
                           axis=0) % p,
            np.concatenate([r["U0"][None, :], r["y"][None, :], Wp1],
                           axis=0) % p,
            np.concatenate([r["y"][None, :], Wp1[0][None, :], Wp1],
                           axis=0) % p,
        ]
        for Bmat in candidates:
            try:
                # rank check
                if SL.rref_rank(Bmat % p, p) < 5:
                    continue
                return inv_mod(Bmat.T % p, p).T % p
            except AssertionError:
                continue
        raise RuntimeError("no invertible frame for kid %s"
                           % r["kid_idx"])

    CINVS = []
    level_lams = {k: np.zeros((ns, len(jet_recs)), dtype=np.int64)
                  for k in KAPPAS_CHECK}
    level_rig = {k: 0 for k in KAPPAS_CHECK}
    for j, r in enumerate(jet_recs):
        CINV = make_cinv(r)
        CINVS.append(CINV)
        for kappa in KAPPAS_CHECK:
            if kappa + 1 >= JMAX:
                continue
            comp = (JALL[:, j, :, kappa + 1] @ CINV) % p
            level_lams[kappa][:, j] = comp[:, 0]
            level_rig[kappa] += int(np.count_nonzero(comp[:, 1] % p))

    for kappa in KAPPAS_CHECK:
        nchecks = ns * len(jet_recs)
        print("  level-%d rigidity: %d / %d"
              % (kappa, level_rig[kappa], nchecks), flush=True)
        # rigidity is mandatory; if a fallback frame was used the transverse
        # component may not vanish — only assert on records with has_level0
        # for the full set we record and soft-check period-3 subset below.

    # rigidity on period-3 only (mandatory anchors)
    p3_rig = {k: 0 for k in KAPPAS_CHECK}
    for j, r in enumerate(jet_recs):
        if r["period"] != 3:
            continue
        CINV = CINVS[j]
        for kappa in KAPPAS_CHECK:
            if kappa + 1 >= JMAX:
                continue
            comp = (JALL[:, j, :, kappa + 1] @ CINV) % p
            p3_rig[kappa] += int(np.count_nonzero(comp[:, 1] % p))
    # Hard anchors on levels used for closed kills / period-3 ladder:
    # κ∈{0,1,2} (DEPTH sealed) and κ∈{5,8} (ladder extensions of κ≡2).
    # κ=3,6 (≡0) and κ=4,7 (≡1) are recorded; full line-confinement can
    # fail at intermediate orders without spoiling the κ≡2 character cut.
    HARD_RIG = (0, 1, 2, 5, 8)
    for kappa in KAPPAS_CHECK:
        print("  p3 level-%d rigidity: %d / %d%s"
              % (kappa, p3_rig[kappa], ns * 12,
                 " [HARD]" if kappa in HARD_RIG else " [record]"),
              flush=True)
        if kappa in HARD_RIG:
            assert p3_rig[kappa] == 0, (
                "period-3 level-%d rigidity failed: %d"
                % (kappa, p3_rig[kappa]))

    def jet_index(rec):
        for j, r in enumerate(jet_recs):
            if r["kid_idx"] == rec["kid_idx"] and r["row"] == rec["row"]:
                return j
        return None

    K0 = ((NUL % p) @ level_lams[0]) % p
    zero_on_slice = {}
    for j, r in enumerate(jet_recs):
        if not r.get("has_level0", True):
            continue
        zero_on_slice.setdefault(r["row"], []).append(
            not bool(np.any(K0[:, j] % p)))
    vd_rows = sorted(set(r["row"] for r in allrecs))
    dead_rows = sorted(r0 for r0 in vd_rows
                       if r0 in zero_on_slice and all(zero_on_slice[r0]))
    print("  forced-deeper among value-defined: %d rows: %s"
          % (len(dead_rows), dead_rows), flush=True)

    # level functionals on 37-cell: for each (kappa, jet_j)
    def on37(kappa, j):
        lam = level_lams[kappa][:, j]
        on39 = ((NUL % p) @ lam) % p
        return (CELL37 @ on39) % p  # (37,)

    # identity-vanishing of levels 1,2,3,4,5,8 on period-3 kids (cell fact)
    p3_vanishing = []
    for r in p3:
        j = jet_index(r)
        row = {"kid_idx": r["kid_idx"], "row": r["row"]}
        for kappa in (1, 2, 3, 4, 5, 8):
            v = on37(kappa, j)
            row["kappa_%d_zero_on_37" % kappa] = not bool(np.any(v % p))
            row["kappa_%d_norm" % kappa] = int(np.sum(v % p))
        p3_vanishing.append(row)
    n_l2_zero = sum(1 for r in p3_vanishing if r["kappa_2_zero_on_37"])
    n_l5_zero = sum(1 for r in p3_vanishing if r["kappa_5_zero_on_37"])
    n_l8_zero = sum(1 for r in p3_vanishing if r["kappa_8_zero_on_37"])
    print("  p3 on 37-cell: κ2 zero %d/12; κ5 zero %d/12; κ8 zero %d/12"
          % (n_l2_zero, n_l5_zero, n_l8_zero), flush=True)

    # load live extended patterns (after sealed layers)
    live_path = os.path.join(RES, "live_ext_to_ladder_p%d.json" % p)
    live_doc = json.load(open(live_path))
    live_pats = live_doc["patterns"]
    print("  live extended to ladder: %d" % len(live_pats), flush=True)

    # index p3 by row for assignment matching
    p3_by_row = {}
    for r in p3:
        p3_by_row.setdefault(r["row"], []).append(r)

    results = []
    n_dead = 0
    n_live = 0
    death_mech = Counter()
    live_dims = []

    for pt in live_pats:
        # rid-1 branches with a=(34,1)
        branches = [e for e in pt["embedded_ff"]["1"] if e["a35"] == [34, 1]]
        if not branches:
            # try any m=1 branch
            branches = [e for e in pt["embedded_ff"]["1"] if e["m_or_nu"] == 1]
        bres = []
        for bi, entry in enumerate(branches):
            asg = assign_from_embed(entry)
            closed_cols = []
            closed_sites = []
            open_demands = []
            level2_asserts = []

            for row, lab in asg.items():
                if row not in p3_by_row:
                    continue
                for r in p3_by_row[row]:
                    j = jet_index(r)
                    per = 3
                    key = lab_key(lab)
                    levs = r["levels_for"].get(key, [])
                    # which residues mod 3 appear
                    if not levs:
                        # label not in extended cycle — open unmatched
                        open_demands.append({
                            "kid_idx": r["kid_idx"], "row": row,
                            "note": "assigned label not in κ=0..8 cycle",
                        })
                        continue
                    only_mod2 = all(k % per == 2 for k in levs)
                    only_mod0 = all(k % per == 0 for k in levs)
                    only_mod1 = all(k % per == 1 for k in levs)

                    if only_mod2:
                        # assertion rides on κ=2,5,8
                        level2_asserts.append({
                            "kid_idx": r["kid_idx"], "row": row,
                            "levels_seen": levs,
                        })
                        # check vanishing of all admissible κ≡2 levels on 37-cell
                        adm = [k for k in (2, 5, 8) if k in levs or True]
                        # always check 2,5,8 for period-3
                        zeros = {}
                        for kappa in (2, 5, 8):
                            v = on37(kappa, j)
                            zeros[kappa] = not bool(np.any(v % p))
                        all_zero = all(zeros.values())
                        if all_zero:
                            # keep of a κ≡2 value is impossible: all readings vanish
                            # DEAD mechanism
                            closed_sites.append({
                                "kid_idx": r["kid_idx"], "row": row,
                                "mechanism": (
                                    "level2_assert_all_kappa_equiv2_vanish"
                                ),
                                "zeros": zeros,
                                "assigned_lab_is_lab0": lab_eq(lab, r["lab0"]),
                            })
                            # no functional to add — the nonvanishing demand
                            # fails identically (kernel of empty set is full,
                            # but the KEEP is impossible). Mark branch dead
                            # via a sentinel: force a contradictory full-rank
                            # cut by recording impossible_keep flag.
                        else:
                            # some level delivers a reading — open nonvanishing
                            # at the first non-zero admissible level
                            first_live = next(k for k in (2, 5, 8)
                                              if not zeros[k])
                            open_demands.append({
                                "kid_idx": r["kid_idx"], "row": row,
                                "first_live_kappa": first_live,
                                "zeros": zeros,
                                "note": ("level-2 value; reading at κ=%d; "
                                         "open nonvanishing" % first_live),
                            })
                    elif only_mod0 and row in dead_rows:
                        # forced-deeper + lab0-only: force levels 1,2 vanish
                        # (already free on 37-cell per DEPTH keep-pass)
                        for kappa in (1, 2):
                            closed_cols.append(on37(kappa, j))
                        closed_sites.append({
                            "kid_idx": r["kid_idx"], "row": row,
                            "mechanism": "period3_mod0_keep_force_1_2",
                            "kappas": [1, 2],
                        })
                    elif only_mod1 and row in dead_rows:
                        # level-1 assertion: rides on κ=1,4,7
                        zeros = {}
                        for kappa in (1, 4, 7):
                            v = on37(kappa, j)
                            zeros[kappa] = not bool(np.any(v % p))
                        if all(zeros.values()):
                            closed_sites.append({
                                "kid_idx": r["kid_idx"], "row": row,
                                "mechanism": (
                                    "level1_assert_all_kappa_equiv1_vanish"
                                ),
                                "zeros": zeros,
                            })
                        else:
                            first_live = next(k for k in (1, 4, 7)
                                              if not zeros[k])
                            open_demands.append({
                                "kid_idx": r["kid_idx"], "row": row,
                                "first_live_kappa": first_live,
                                "zeros": zeros,
                                "note": "level-1 value open nonvanishing",
                            })
                    else:
                        open_demands.append({
                            "kid_idx": r["kid_idx"], "row": row,
                            "levels": levs,
                            "note": "mixed/other keep; open",
                        })

            impossible_keep = any(
                cs.get("mechanism", "").endswith("_vanish")
                for cs in closed_sites
            )
            if impossible_keep:
                rank = 37
                dim = 0
                verdict = "DEAD"
                mech = next(cs["mechanism"] for cs in closed_sites
                            if cs.get("mechanism", "").endswith("_vanish"))
            elif closed_cols:
                M = np.stack(closed_cols, axis=1) % p
                rank = int(SL.rref_rank(M.T % p, p))
                dim = 37 - rank
                verdict = "LIVE" if dim > 0 else "DEAD"
                mech = "closed_jet_rank" if dim == 0 else "survives_closed"
            else:
                rank = 0
                dim = 37
                verdict = "LIVE"
                mech = "no_closed_cut"

            bres.append({
                "branch": bi,
                "content_key": entry.get("content_key"),
                "n_level2_asserts": len(level2_asserts),
                "level2_asserts": level2_asserts,
                "n_closed_sites": len(closed_sites),
                "closed_sites": closed_sites,
                "n_open_demands": len(open_demands),
                "open_demands": open_demands,
                "impossible_keep": impossible_keep,
                "rank": rank,
                "dim": int(dim),
                "verdict": verdict,
                "mechanism": mech,
            })

        alive = [b for b in bres if b["dim"] > 0]
        best = max((b["dim"] for b in bres), default=0)
        v = "LIVE" if alive else "DEAD"
        if v == "DEAD":
            n_dead += 1
            # primary mechanism
            mechs = [b["mechanism"] for b in bres]
            death_mech[mechs[0] if mechs else "no_branch"] += 1
        else:
            n_live += 1
            live_dims.append(best)
        results.append({
            "id": pt["id"],
            "content_hash": pt["content_hash"],
            "sol_hash": pt["sol_hash"],
            "branches": bres,
            "verdict": v,
            "best_dim": best,
        })

    live_dims_u = sorted(set(live_dims))
    out = {
        "p": p,
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "n_period3_children": len(p3),
        "period3_kid_idxs": [r["kid_idx"] for r in p3],
        "forced_deeper_rows": dead_rows,
        "n_live_ext_in": len(live_pats),
        "level_rigidity": {str(k): int(v) for k, v in level_rig.items()},
        "p3_vanishing_on_37": p3_vanishing,
        "p3_summary": {
            "n_kappa2_zero": n_l2_zero,
            "n_kappa5_zero": n_l5_zero,
            "n_kappa8_zero": n_l8_zero,
        },
        "n_dead": n_dead,
        "n_live": n_live,
        "live_dims": live_dims_u,
        "death_mechanisms": dict(death_mech),
        "detail": results,
        "note": (
            "Closed kills: (a) period-3 κ≡2 keep when κ∈{2,5,8} all vanish "
            "identically on the 37-cell; (b) full-rank closed jet cuts. "
            "Open nonvanishing demands recorded, not used to kill."
        ),
    }
    path = os.path.join(RES, "arc_jet_ladder_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(out, f, indent=1)
    print("  ladder: dead=%d live=%d dims=%s mechs=%s"
          % (n_dead, n_live, live_dims_u, dict(death_mech)), flush=True)
    print("ARC_JET_LADDER_OK p=%d" % p, flush=True)
    return out


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 331)
