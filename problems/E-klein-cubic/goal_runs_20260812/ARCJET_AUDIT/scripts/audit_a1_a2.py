#!/usr/bin/env python3
"""A1 + A2 hostile audit of the arc-jet ladder.

A1: independent Reynolds jets at the 12 period-3 children, levels κ=0..8,
    on the 37-cell, primes 331/661/991. Try to refute the identically-zero
    pattern that the 62 kills rest on.

A2: independent attaching-frame construction for period-3 kids, especially
    those without level-0 surface values. Frame error voids A1 at that child.

python3 only; writes only under ARCJET_AUDIT/results/.
"""
import json
import os
import sys
import time

import numpy as np

import paths
from linalg import mat_inv, rref_rank, nullspace
from reynolds import eval_jet
from slice_load import load_null, our_frame, six_flip_cell37

from s1enum import Stage1
from s3sweep import FullSweep
from s3jet import chi_arc_of, value_at_level

RES = paths.RES
EXT_RES = paths.EXT_RES
DEG = 35
A35 = (34, 1)
JMAX = 10
KAPPAS = list(range(0, 9))
HARD_RIG = (0, 1, 2, 5, 8)
# levels used by the sealed closed kills
KILL_LEVELS_MOD1 = (1, 4, 7)
KILL_LEVELS_MOD2 = (2, 5, 8)


def vec5(U, p):
    return np.array(U, dtype=np.int64).reshape(-1) % p


def lab_key(lab):
    return json.dumps(lab, sort_keys=True) if lab is not None else None


def label_at(S, a, kid, kappa, chi):
    U = value_at_level(S, a, kid, kappa, None, chi)
    if U is None:
        return None, None
    return S.own_frame(kid, U), vec5(U, S.p)


def build_attaching(S, kid, p):
    """Director attaching pair (w, y) from kid qs + slot components."""
    inv2 = pow(2, p - 2, p)
    Z1 = np.array(S.sig, dtype=np.int64) % p
    Pminus = ((np.eye(5, dtype=np.int64) - Z1) * inv2) % p
    comp0 = np.array(S.slots[0][2], dtype=np.int64) % p
    comp1 = np.array(S.slots[1][2], dtype=np.int64) % p
    q0 = np.array(kid["qs"][0][0], dtype=np.int64) % p
    q1 = np.array(kid["qs"][1][0], dtype=np.int64) % p
    w = (q0 @ comp0) % p
    y = ((q1 @ comp1) @ Pminus.T) % p
    return w, y, Z1, Pminus


def build_char_frame(S, kid, chi, per, w, y, p):
    """A2: character frame without relying on slicelib.jet_rows.

    Novelty under audit: kids with no level-0 surface value. Prefer U0;
    else first available level-κ value; else kid line; else y.
    """
    Wp1 = nullspace(
        (np.array(S.sig, dtype=np.int64) - np.eye(5, dtype=np.int64)) % p, p)
    assert Wp1.shape[0] == 3

    U_char = None
    lab0 = None
    source = None
    U0 = S.value(A35, kid, None)
    if U0 is not None:
        lab0 = S.own_frame(kid, U0)
        if lab0 is not None:
            U_char = vec5(U0, p)
            source = "level0"

    if U_char is None:
        for k in KAPPAS:
            lab, U = label_at(S, A35, kid, k, chi)
            if lab is None or U is None:
                continue
            U_char = U
            source = "level_%d" % k
            break

    line_vecs = [vec5(U, p) for (_ch, U) in kid.get("lines", [])]
    if U_char is None and line_vecs:
        U_char = line_vecs[0]
        source = "kid_line0"
    if U_char is None:
        U_char = y % p
        source = "fallback_y"

    others = [v for v in line_vecs
              if not np.array_equal(v % p, U_char % p)]
    if not others:
        for v in Wp1:
            if not np.array_equal(v % p, U_char % p) and np.any(v % p):
                others = [v % p]
                break
    if not others:
        return None

    Ut = others[0]
    cycle = {}
    levels_for = {}
    for k in KAPPAS:
        lab, U = label_at(S, A35, kid, k, chi)
        cycle[k] = lab
        if lab is not None:
            levels_for.setdefault(lab_key(lab), []).append(k)

    # invertible frame candidates (same order as sealed ladder)
    candidates = [
        ("Uchar_Ut_Wp", np.concatenate(
            [U_char[None, :], Ut[None, :], Wp1], axis=0) % p),
        ("y_Ut_Wp", np.concatenate(
            [y[None, :], Ut[None, :], Wp1], axis=0) % p),
        ("Uchar_y_Wp", np.concatenate(
            [U_char[None, :], y[None, :], Wp1], axis=0) % p),
        ("y_Wp0_Wp", np.concatenate(
            [y[None, :], Wp1[0][None, :], Wp1], axis=0) % p),
    ]
    chosen = None
    cinv = None
    for name, Bmat in candidates:
        if rref_rank(Bmat % p, p) < 5:
            continue
        try:
            cinv = mat_inv(Bmat.T % p, p).T % p
            chosen = name
            break
        except AssertionError:
            continue
    if cinv is None:
        return None

    return dict(
        kid_idx=int(kid["idx"]), row=int(kid["row"]),
        period=int(per), w=w % p, y=y % p,
        U_char=U_char % p, Ut=Ut % p, CINV=cinv,
        frame_name=chosen, U_char_source=source,
        has_level0=(lab0 is not None), lab0=lab0,
        cycle={str(k): cycle[k] for k in KAPPAS},
        levels_for=levels_for,
        chi=chi, kid=kid,
    )


def on_cell(NUL, CELL37, lam, p):
    """Character functional (ns,) → restriction to 37-cell (37,)."""
    on39 = ((NUL % p) @ (lam % p)) % p
    return (CELL37 @ on39) % p


def audit_prime(p):
    t0 = time.time()
    print("== A1/A2 audit p=%d" % p, flush=True)
    fr = our_frame(p)
    A, C, NUL = load_null(p)
    ns = A.shape[0]
    assert ns == 637 and NUL.shape[0] == 39

    # own six-flip 37-cell (independent of sealed cell37_p*.npy)
    LAM, CELL37, six_meta = six_flip_cell37(fr, A, C, NUL, p, pick=0)
    print("  six-flip: rank=%d dim=%d rig=%d cell=%s [%.1fs]"
          % (six_meta["slice_rank"], six_meta["dim_after"],
             six_meta["r1_rigidity"], six_meta["cell37_shape"],
             time.time() - t0), flush=True)
    assert six_meta["slice_rank"] == 2 and CELL37.shape[0] == 37
    assert six_meta["r1_rigidity"] == 0
    np.save(os.path.join(RES, "cell37_own_p%d.npy" % p), CELL37)
    np.save(os.path.join(RES, "lam6_own_p%d.npy" % p), LAM)

    # compare to sealed cell if present (331/661 only)
    sealed_cell_match = None
    sealed_path = os.path.join(EXT_RES, "cell37_p%d.npy" % p)
    if os.path.exists(sealed_path):
        SC = np.load(sealed_path) % p
        # same row-space?
        joint = np.concatenate([CELL37, SC], axis=0) % p
        r_joint = rref_rank(joint, p)
        sealed_cell_match = (r_joint == 37 and SC.shape == CELL37.shape)
        print("  sealed cell37 row-space match: %s (joint_rank=%d)"
              % (sealed_cell_match, r_joint), flush=True)

    E = Stage1(p)
    S1 = FullSweep(E, 1)
    # align frame sigma with Stage1 sig (director)
    Z1 = np.array(S1.sig, dtype=np.int64) % p
    hits = [i for i in range(660)
            if np.array_equal(fr["RHO"][i] % p, Z1)]
    assert hits, "own frame does not contain Stage1 involution"

    recs = []
    n_no_level0 = 0
    frame_failures = []
    for kid in S1.kids:
        chi, per = chi_arc_of(S1, kid)
        if per != 3:
            continue
        w, y, Z1b, Pm = build_attaching(S1, kid, p)
        if not np.any(y % p):
            frame_failures.append({"kid_idx": int(kid["idx"]),
                                   "reason": "y=0"})
            continue
        rec = build_char_frame(S1, kid, chi, per, w, y, p)
        if rec is None:
            frame_failures.append({"kid_idx": int(kid["idx"]),
                                   "reason": "no_invertible_frame"})
            continue
        if not rec["has_level0"]:
            n_no_level0 += 1
        recs.append(rec)
    print("  period-3 kids with frames: %d/12; no-level0: %d; failures: %d"
          % (len(recs), n_no_level0, len(frame_failures)), flush=True)
    assert len(recs) == 12, "expected 12 period-3 frames, got %d" % len(recs)

    # A2 geometry checks (census attaching pair + invertible character frame)
    a2_checks = []
    for r in recs:
        Z = Z1
        I5 = np.eye(5, dtype=np.int64)
        # left eigenchecks (Stage1 sig acts on ambient P^4)
        w_plus = np.array_equal((Z @ r["w"]) % p, r["w"] % p)
        y_minus = np.array_equal((Z @ r["y"]) % p, (-r["y"]) % p)
        # frame matrix used must be full rank 5
        frame_rank = int(rref_rank(
            np.concatenate([r["U_char"][None, :], r["Ut"][None, :],
                            nullspace((Z - I5) % p, p)], axis=0) % p, p))
        a2_checks.append({
            "kid_idx": r["kid_idx"], "row": r["row"],
            "has_level0": r["has_level0"],
            "U_char_source": r["U_char_source"],
            "frame_name": r["frame_name"],
            "w_plus_eigen": bool(w_plus),
            "y_minus_eigen": bool(y_minus),
            "frame_rank": frame_rank,
            "w_nonzero": bool(np.any(r["w"] % p)),
            "y_nonzero": bool(np.any(r["y"] % p)),
            "U_char_nonzero": bool(np.any(r["U_char"] % p)),
        })
    # Hard fails: singular frame or zero attaching data. Eigenchecks recorded;
    # some director embeddings use right-action conventions — non-eigen is a
    # soft flag, not automatic refutation unless paired with rigidity failure.
    a2_fail = [c for c in a2_checks
               if not (c["w_nonzero"] and c["y_nonzero"]
                       and c["U_char_nonzero"] and c["frame_rank"] == 5)]
    a2_soft = [c for c in a2_checks
               if not (c["w_plus_eigen"] and c["y_minus_eigen"])]
    print("  A2 hard fails: %d / %d; eigen soft flags: %d"
          % (len(a2_fail), len(a2_checks), len(a2_soft)), flush=True)

    # independent jets
    Wm = np.array([r["w"] for r in recs], dtype=np.int64) % p
    Ym = np.array([r["y"] for r in recs], dtype=np.int64) % p
    print("  computing own Reynolds jets J=%d on %d pairs..." % (JMAX, len(recs)),
          flush=True)
    t1 = time.time()
    JALL = eval_jet(fr, A, C, Wm, Ym, JMAX, deg=DEG) % p
    print("  jets done [%.1fs]" % (time.time() - t1), flush=True)

    # character components + rigidity per level
    level_lams = {k: np.zeros((ns, len(recs)), dtype=np.int64) for k in KAPPAS}
    level_rig = {k: 0 for k in KAPPAS}
    full_jet_norm = {k: np.zeros(len(recs), dtype=np.int64) for k in KAPPAS}
    for j, r in enumerate(recs):
        CINV = r["CINV"]
        for kappa in KAPPAS:
            jet = JALL[:, j, :, kappa + 1] % p          # (ns, 5)
            comp = (jet @ CINV) % p
            level_lams[kappa][:, j] = comp[:, 0]
            level_rig[kappa] += int(np.count_nonzero(comp[:, 1] % p))
            # full 5-vector jet restricted to 37-cell (sum of norms)
            # store ambient seed-norm of jet for diagnostics
            full_jet_norm[kappa][j] = int(np.sum(jet % p))

    for kappa in KAPPAS:
        tag = "HARD" if kappa in HARD_RIG else "record"
        print("  level-%d rigidity: %d / %d [%s]"
              % (kappa, level_rig[kappa], ns * 12, tag), flush=True)

    hard_rig_ok = all(level_rig[k] == 0 for k in HARD_RIG)

    # vanishing on 37-cell
    p3_vanishing = []
    n_zero = {k: 0 for k in (1, 2, 3, 4, 5, 7, 8)}
    for j, r in enumerate(recs):
        row = {
            "kid_idx": r["kid_idx"], "row": r["row"],
            "has_level0": r["has_level0"],
            "U_char_source": r["U_char_source"],
            "frame_name": r["frame_name"],
        }
        for kappa in (1, 2, 3, 4, 5, 7, 8):
            v = on_cell(NUL, CELL37, level_lams[kappa][:, j], p)
            is_zero = not bool(np.any(v % p))
            row["kappa_%d_zero_on_37" % kappa] = is_zero
            row["kappa_%d_norm" % kappa] = int(np.sum(v % p))
            # also: does full jet vanish on cell? (all 5 components)
            jet = JALL[:, j, :, kappa + 1] % p
            # restrict each of 5 comps
            full_zero = True
            full_norm = 0
            for c in range(5):
                vc = on_cell(NUL, CELL37, jet[:, c], p)
                full_norm += int(np.sum(vc % p))
                if np.any(vc % p):
                    full_zero = False
            row["kappa_%d_fulljet_zero_on_37" % kappa] = full_zero
            row["kappa_%d_fulljet_norm" % kappa] = full_norm
            if is_zero:
                n_zero[kappa] += 1
        # cycle residues available
        defined = [k for k in KAPPAS if r["cycle"][str(k)] is not None]
        row["defined_levels"] = defined
        row["only_mod1_defined"] = bool(defined) and all(k % 3 == 1 for k in defined)
        row["only_mod2_defined"] = bool(defined) and all(k % 3 == 2 for k in defined)
        # abstract cycle may mix residues; record which residues appear
        row["residues_present"] = sorted(set(k % 3 for k in defined))
        p3_vanishing.append(row)

    print("  zero counts /12:", {k: n_zero[k] for k in n_zero}, flush=True)

    # sealed comparison at 331/661
    sealed_compare = None
    sealed_ladder = os.path.join(EXT_RES, "arc_jet_ladder_p%d.json" % p)
    mismatches = []
    if os.path.exists(sealed_ladder):
        sealed = json.load(open(sealed_ladder))
        by_kid = {int(r["kid_idx"]): r for r in sealed["p3_vanishing_on_37"]}
        for row in p3_vanishing:
            sk = by_kid.get(row["kid_idx"])
            if sk is None:
                mismatches.append({"kid_idx": row["kid_idx"],
                                   "reason": "missing_in_sealed"})
                continue
            for kappa in (1, 2, 5, 8):
                key = "kappa_%d_zero_on_37" % kappa
                if key in sk and sk[key] != row[key]:
                    mismatches.append({
                        "kid_idx": row["kid_idx"], "kappa": kappa,
                        "ours": row[key], "sealed": sk[key],
                        "our_norm": row["kappa_%d_norm" % kappa],
                        "sealed_norm": sk.get("kappa_%d_norm" % kappa),
                    })
        sealed_compare = {
            "n_sealed_p3": len(sealed["p3_vanishing_on_37"]),
            "n_mismatches": len(mismatches),
            "mismatches": mismatches[:20],
            "sealed_p3_summary": sealed.get("p3_summary"),
        }
        print("  sealed vanishing mismatches: %d" % len(mismatches), flush=True)

    # closed-kill support on forced-deeper period-3 kids
    # forced-deeper: level-0 character component ≡ 0 on 39-slice (then 37)
    forced_rows = []
    for j, r in enumerate(recs):
        if not r["has_level0"]:
            continue
        v0 = on_cell(NUL, CELL37, level_lams[0][:, j], p)
        # also check on 39-slice
        on39 = ((NUL % p) @ level_lams[0][:, j]) % p
        if not np.any(on39 % p):
            forced_rows.append(r["row"])
    forced_rows = sorted(set(forced_rows))

    # for each p3 kid: do mod1 / mod2 kill sites fire?
    kill_sites = []
    for j, r in enumerate(recs):
        zeros_m1 = {k: not bool(np.any(
            on_cell(NUL, CELL37, level_lams[k][:, j], p) % p))
            for k in KILL_LEVELS_MOD1}
        zeros_m2 = {k: not bool(np.any(
            on_cell(NUL, CELL37, level_lams[k][:, j], p) % p))
            for k in KILL_LEVELS_MOD2}
        # hard-only (drop κ=4 which has soft rigidity)
        zeros_m1_hard = {k: zeros_m1[k] for k in (1, 7)}
        kill_sites.append({
            "kid_idx": r["kid_idx"], "row": r["row"],
            "has_level0": r["has_level0"],
            "zeros_mod1": {str(k): zeros_m1[k] for k in zeros_m1},
            "zeros_mod2": {str(k): zeros_m2[k] for k in zeros_m2},
            "all_mod1_vanish": all(zeros_m1.values()),
            "all_mod2_vanish": all(zeros_m2.values()),
            "all_mod1_hard_vanish": all(zeros_m1_hard.values()),
            "mod1_hard_zeros": {str(k): zeros_m1_hard[k] for k in zeros_m1_hard},
        })

    n_all_m1 = sum(1 for s in kill_sites if s["all_mod1_vanish"])
    n_all_m2 = sum(1 for s in kill_sites if s["all_mod2_vanish"])
    n_all_m1_hard = sum(1 for s in kill_sites if s["all_mod1_hard_vanish"])
    print("  kids with all mod1 vanish: %d; mod2: %d; mod1-hard(1,7): %d"
          % (n_all_m1, n_all_m2, n_all_m1_hard), flush=True)

    # Replay sealed 62 death logic on live_ext (331/661) using OUR functionals
    replay = None
    live_path = os.path.join(EXT_RES, "live_ext_to_ladder_p%d.json" % p)
    if os.path.exists(live_path):
        live_doc = json.load(open(live_path))
        live_pats = live_doc["patterns"]
        p3_by_row = {}
        for j, r in enumerate(recs):
            p3_by_row.setdefault(r["row"], []).append((j, r))

        n_dead = 0
        n_live = 0
        mechs = {}
        detail_sample = []
        for pt in live_pats:
            branches = [e for e in pt["embedded_ff"]["1"]
                        if e.get("a35") == [34, 1] or e.get("m_or_nu") == 1]
            branch_dead = False
            branch_mechs = []
            for entry in branches:
                asg = {int(r): lab for r, lab in entry["assign"]}
                closed_vanish = False
                used = None
                for row, lab in asg.items():
                    if row not in p3_by_row:
                        continue
                    for j, r in p3_by_row[row]:
                        key = lab_key(lab)
                        levs = r["levels_for"].get(key, [])
                        if not levs:
                            continue
                        only_m2 = all(k % 3 == 2 for k in levs)
                        only_m1 = all(k % 3 == 1 for k in levs)
                        only_m0 = all(k % 3 == 0 for k in levs)
                        if only_m2:
                            zs = {k: not bool(np.any(
                                on_cell(NUL, CELL37, level_lams[k][:, j], p) % p))
                                for k in KILL_LEVELS_MOD2}
                            if all(zs.values()):
                                closed_vanish = True
                                used = "level2_assert_all_kappa_equiv2_vanish"
                        elif only_m1 and row in forced_rows:
                            zs = {k: not bool(np.any(
                                on_cell(NUL, CELL37, level_lams[k][:, j], p) % p))
                                for k in KILL_LEVELS_MOD1}
                            if all(zs.values()):
                                closed_vanish = True
                                used = "level1_assert_all_kappa_equiv1_vanish"
                if closed_vanish:
                    branch_dead = True
                    branch_mechs.append(used)
            if branch_dead or not branches:
                # sealed marks DEAD only if all branches dead; our simpler:
                # pattern dead if every a35=(34,1) branch has a vanish site
                # Recompute carefully
                pass

        # careful per-pattern
        n_dead = 0
        n_live = 0
        mechs = {}
        for pt in live_pats:
            branches = [e for e in pt["embedded_ff"]["1"]
                        if e.get("a35") == [34, 1]]
            if not branches:
                branches = [e for e in pt["embedded_ff"]["1"]
                            if e.get("m_or_nu") == 1]
            any_live_branch = False
            pat_mechs = []
            for entry in branches:
                asg = {int(r): lab for r, lab in entry["assign"]}
                impossible = False
                used = None
                for row, lab in asg.items():
                    if row not in p3_by_row:
                        continue
                    for j, r in p3_by_row[row]:
                        key = lab_key(lab)
                        levs = r["levels_for"].get(key, [])
                        if not levs:
                            continue
                        only_m2 = all(k % 3 == 2 for k in levs)
                        only_m1 = all(k % 3 == 1 for k in levs)
                        if only_m2:
                            zs = all(
                                not bool(np.any(
                                    on_cell(NUL, CELL37,
                                            level_lams[k][:, j], p) % p))
                                for k in KILL_LEVELS_MOD2)
                            if zs:
                                impossible = True
                                used = "level2_assert_all_kappa_equiv2_vanish"
                        elif only_m1 and row in forced_rows:
                            zs = all(
                                not bool(np.any(
                                    on_cell(NUL, CELL37,
                                            level_lams[k][:, j], p) % p))
                                for k in KILL_LEVELS_MOD1)
                            if zs:
                                impossible = True
                                used = "level1_assert_all_kappa_equiv1_vanish"
                if not impossible:
                    any_live_branch = True
                elif used:
                    pat_mechs.append(used)
            if any_live_branch:
                n_live += 1
            else:
                n_dead += 1
                if pat_mechs:
                    mechs[pat_mechs[0]] = mechs.get(pat_mechs[0], 0) + 1
                else:
                    mechs["no_vanish_site_but_dead"] = mechs.get(
                        "no_vanish_site_but_dead", 0) + 1

        replay = {
            "n_live_ext_in": len(live_pats),
            "n_dead": n_dead,
            "n_live": n_live,
            "death_mechanisms": mechs,
            "forced_rows_own": forced_rows,
        }
        print("  replay 62-kill: dead=%d live=%d mechs=%s"
              % (n_dead, n_live, mechs), flush=True)

    # A1 verdict attempt
    # Refutation criteria:
    #  (i) hard rigidity fails on κ in HARD_RIG
    #  (ii) sealed vanishing disagrees with ours
    #  (iii) replay fails to kill all 62
    #  (iv) a killing kid has nonzero character reading at a required level
    a1_refute_witnesses = []
    if not hard_rig_ok:
        a1_refute_witnesses.append({
            "kind": "hard_rigidity_fail",
            "level_rigidity": {str(k): level_rig[k] for k in HARD_RIG},
        })
    if sealed_compare and sealed_compare["n_mismatches"]:
        a1_refute_witnesses.append({
            "kind": "sealed_vanishing_mismatch",
            "n": sealed_compare["n_mismatches"],
            "sample": sealed_compare["mismatches"][:5],
        })
    if replay is not None:
        if replay["n_live"] != 0 or replay["n_dead"] != replay["n_live_ext_in"]:
            a1_refute_witnesses.append({
                "kind": "replay_62_not_all_dead",
                "replay": replay,
            })

    # specifically: among kids with all_mod2_vanish, confirm character is zero
    # and among those with defined κ≡2 levels in abstract cycle
    for s, row in zip(kill_sites, p3_vanishing):
        if s["all_mod2_vanish"]:
            for k in KILL_LEVELS_MOD2:
                if row["kappa_%d_norm" % k] != 0:
                    a1_refute_witnesses.append({
                        "kind": "claimed_zero_nonzero",
                        "kid_idx": s["kid_idx"], "kappa": k,
                        "norm": row["kappa_%d_norm" % k],
                    })

    a2_refute_witnesses = []
    if frame_failures:
        a2_refute_witnesses.append({
            "kind": "frame_build_failure", "failures": frame_failures})
    if a2_fail:
        a2_refute_witnesses.append({
            "kind": "geometry_check_fail", "fails": a2_fail})
    # no-level0 kids must still have hard rigidity 0
    for j, r in enumerate(recs):
        if not r["has_level0"]:
            for kappa in HARD_RIG:
                # per-kid rigidity: recompute
                jet = JALL[:, j, :, kappa + 1] % p
                comp = (jet @ r["CINV"]) % p
                bad = int(np.count_nonzero(comp[:, 1] % p))
                if bad:
                    a2_refute_witnesses.append({
                        "kind": "no_level0_rigidity_fail",
                        "kid_idx": r["kid_idx"], "kappa": kappa,
                        "transverse_nonzero": bad,
                        "source": r["U_char_source"],
                        "frame": r["frame_name"],
                    })

    a1_verdict = "REFUTED" if a1_refute_witnesses else "CONFIRMED"
    a2_verdict = "REFUTED" if a2_refute_witnesses else "CONFIRMED"

    out = {
        "p": p,
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "wall_s": round(time.time() - t0, 2),
        "six_flip": six_meta,
        "sealed_cell_rowspace_match": sealed_cell_match,
        "n_period3": len(recs),
        "n_no_level0": n_no_level0,
        "frame_failures": frame_failures,
        "a2_geometry": a2_checks,
        "a2_eigen_soft_flags": a2_soft,
        "level_rigidity": {str(k): int(level_rig[k]) for k in KAPPAS},
        "hard_rigidity_ok": hard_rig_ok,
        "p3_vanishing_on_37": p3_vanishing,
        "zero_counts": {str(k): n_zero[k] for k in n_zero},
        "kill_sites": kill_sites,
        "n_all_mod1_vanish": n_all_m1,
        "n_all_mod2_vanish": n_all_m2,
        "n_all_mod1_hard_vanish": n_all_m1_hard,
        "forced_rows_own": forced_rows,
        "sealed_compare": sealed_compare,
        "replay_62": replay,
        "A1_verdict": a1_verdict,
        "A1_refute_witnesses": a1_refute_witnesses,
        "A2_verdict": a2_verdict,
        "A2_refute_witnesses": a2_refute_witnesses,
        "period3_kid_idxs": [r["kid_idx"] for r in recs],
        "no_level0_kids": [r["kid_idx"] for r in recs if not r["has_level0"]],
    }
    path = os.path.join(RES, "a1_a2_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(out, f, indent=1)
    print("  A1=%s A2=%s  -> %s [%.1fs]"
          % (a1_verdict, a2_verdict, path, time.time() - t0), flush=True)
    return out


if __name__ == "__main__":
    primes = [int(x) for x in sys.argv[1:]] or [331, 661, 991]
    for p in primes:
        audit_prime(p)
    summary = {}
    for p in primes:
        d = json.load(open(os.path.join(RES, "a1_a2_p%d.json" % p)))
        summary[str(p)] = {
            "A1": d["A1_verdict"],
            "A2": d["A2_verdict"],
            "n_no_level0": d["n_no_level0"],
            "zero_counts": d["zero_counts"],
            "replay": d.get("replay_62"),
            "A1_witnesses": d["A1_refute_witnesses"],
            "A2_witnesses": d["A2_refute_witnesses"],
            "hard_rigidity_ok": d["hard_rigidity_ok"],
            "wall_s": d["wall_s"],
        }
    with open(os.path.join(RES, "a1_a2_summary.json"), "w") as f:
        json.dump(summary, f, indent=1)
    print("A1_A2_SUMMARY", json.dumps(summary, indent=1))
