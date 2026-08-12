#!/usr/bin/env python3
"""Sealed kill layers on the 508 extended blueprints (and joint 1264 census).

Layers, in order (PAIR_ATTACK §§10–12 + D35_AUDIT T1/T2):
  L1 multidegree: min_m ∈ {3,5} → dead (m∈{3,5} slices empty — sealed)
  L2 line-order finisher: all L-options have ν≥2 → dead (ord≥2 rank 39 — sealed)
  L3 universal six flips: rank 2 on 39-slice → every live cell dim ≤ 37

Reports per-layer death counts over the 508; verifies the 22 reappear among
the 756 stratified overlap; re-confirms finisher + six-flip ranks in-run.

Usage: python3 sieve_layers.py [p]
"""
import json
import os
import sys

import numpy as np

import paths
import slicelib as SL

RES = paths.RES
PAIR_RES = paths.PAIR_RES
DEG = 35
SURV_IDS = paths.SURV_IDS


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


def confirm_finisher(fr, A6, C6, NUL, p, npts=40):
    """Reconfirm ord≥2 on minus-line has rank 39 (D35_AUDIT T1 / finisher)."""
    RHO, orders = fr["RHO"], fr["orders"]
    I5 = np.eye(5, dtype=np.int64)
    z = next(g for g in range(660) if orders[g] == 2)
    Z = RHO[z] % p
    Wm = nullspace_rows((Z + I5) % p, p)
    Wp = nullspace_rows((Z - I5) % p, p)
    assert Wm.shape[0] == 2 and Wp.shape[0] == 3
    ns, nsl = A6.shape[0], NUL.shape[0]
    rng = np.random.default_rng(20260811)
    ab = rng.integers(1, p, size=(npts, 2))
    pts = (ab @ Wm) % p
    J1 = SL.jet_rows(fr, A6, C6, pts, np.zeros_like(pts), 1, deg=DEG)
    S1 = (NUL @ (J1.reshape(ns, -1) % p)) % p
    blocks = [S1]
    for k in range(3):
        Y = np.tile(Wp[k][None, :], (npts, 1)) % p
        J2 = SL.jet_rows(fr, A6, C6, pts, Y, 2, deg=DEG)[:, :, :, 1]
        blocks.append((NUL @ (J2.reshape(ns, -1) % p)) % p)
    SALL = np.concatenate(blocks, axis=1) % p
    r12 = SL.rref_rank(SALL.T % p, p)
    return dict(rank_ord2=int(r12), dim_after=int(nsl - r12),
                sealed_empty=bool(r12 == nsl))


def confirm_six_flips(fr, A6, C6, NUL, p):
    z, Z, Wplus, Wminus, kids6 = build_v4_children(fr, p)
    ns, nsl = A6.shape[0], NUL.shape[0]
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
    assert r1_bad == 0, "six-flip rigidity failed: %d" % r1_bad
    LAM_SLICE = (NUL % p) @ (lam_amb % p) % p
    r6 = SL.rref_rank(LAM_SLICE.T % p, p)
    CELL37 = SL.nullspace(LAM_SLICE.T % p, p) % p
    return dict(
        rank=int(r6), dim_after=int(nsl - r6),
        rigidity_violations=int(r1_bad),
        cell37_shape=list(CELL37.shape),
        LAM_SLICE=LAM_SLICE, CELL37=CELL37, kids6=kids6,
        Wplus=Wplus, Wminus=Wminus,
    )


def classify_pattern(pt):
    """Return fate under sealed L1/L2 (multidegree / line-order)."""
    if pt["min_m"] != 1:
        return "DEAD_MULTIDEGREE", 0
    aL = pt["a35_L_options"]
    has_ord0 = any(tuple(o)[1] == 0 for o in aL)
    only_ge2 = all(tuple(o)[1] >= 2 for o in aL)
    if only_ge2 and not has_ord0:
        return "DEAD_LINE_ORDER", 0
    if has_ord0:
        return "LIVE_TO_FLIPS", 37  # after universal cut (applied next)
    return "DEAD_LINE_ORDER", 0


def main(p):
    print("== sieve sealed layers p=%d" % p, flush=True)
    fr = SL.build_frame(p, verbose=False)
    A6 = np.load(os.path.join(PAIR_RES, "layer0_A_p331.npy"))
    C6 = np.load(os.path.join(PAIR_RES, "layer0_C_p331.npy"))
    NUL = np.load(os.path.join(PAIR_RES, "layer0_null_p%d.npy" % p)) % p
    assert A6.shape == (637, 6) or A6.shape[0] == 637
    assert NUL.shape[0] == 39

    fin = confirm_finisher(fr, A6, C6, NUL, p)
    print("  finisher ord≥2: rank=%d dim=%d sealed_empty=%s"
          % (fin["rank_ord2"], fin["dim_after"], fin["sealed_empty"]),
          flush=True)
    assert fin["sealed_empty"], "finisher failed to empty the slice"

    six = confirm_six_flips(fr, A6, C6, NUL, p)
    print("  six flips: rank=%d → dim %d (expect 2 → 37)"
          % (six["rank"], six["dim_after"]), flush=True)
    assert six["rank"] == 2 and six["dim_after"] == 37

    # persist cell for arc-jet ladder
    np.save(os.path.join(RES, "cell37_p%d.npy" % p), six["CELL37"])
    np.save(os.path.join(RES, "lam6_p%d.npy" % p), six["LAM_SLICE"])

    joint = json.load(open(os.path.join(RES, "patterns_joint1264_p%d.json" % p)))
    pats = joint["patterns"]
    assert len(pats) == 1264

    # per-layer over the 508 and over all 1264
    def run_census(subset, label):
        deaths = {
            "DEAD_MULTIDEGREE": 0,
            "DEAD_LINE_ORDER": 0,
            "LIVE_AFTER_FLIPS": 0,
        }
        live = []
        detail = []
        for pt in subset:
            fate, dim = classify_pattern(pt)
            if fate == "DEAD_MULTIDEGREE":
                deaths["DEAD_MULTIDEGREE"] += 1
                dim_out = 0
                v = "DEAD"
                layer = "multidegree"
            elif fate == "DEAD_LINE_ORDER":
                deaths["DEAD_LINE_ORDER"] += 1
                dim_out = 0
                v = "DEAD"
                layer = "line_order"
            else:
                deaths["LIVE_AFTER_FLIPS"] += 1
                dim_out = 37
                v = "LIVE"
                layer = "six_flips_cut_to_37"
                live.append(pt)
            detail.append({
                "id": pt["id"],
                "content_hash": pt["content_hash"],
                "sol_hash": pt["sol_hash"],
                "is_extended": pt["is_extended"],
                "min_m": pt["min_m"],
                "a35_P": pt["a35_P_options"],
                "a35_L": pt["a35_L_options"],
                "layer": layer,
                "verdict": v,
                "dim_ub": dim_out,
            })
        return dict(
            label=label, n=len(subset), deaths=deaths,
            n_live=len(live), live_dims=[37] if live else [],
            live_ids=[pt["id"] for pt in live],
            live_sol_hashes=sorted(pt["sol_hash"] for pt in live),
            detail=detail,
        )

    ext = [pt for pt in pats if pt["is_extended"]]
    strat = [pt for pt in pats if not pt["is_extended"]]
    assert len(ext) == 508 and len(strat) == 756

    c_ext = run_census(ext, "ext_508")
    c_all = run_census(pats, "joint_1264")
    c_strat = run_census(strat, "strat_756")

    # 22-anchor among stratified live
    sealed_surv = json.load(open(os.path.join(
        PAIR_RES, "survivors22_p%d.json" % p)))
    sealed_22_hashes = sorted(d["hash"] for d in sealed_surv["detail"])
    strat_live_h = set(c_strat["live_sol_hashes"])
    anchor = {
        "sealed_22_hashes": sealed_22_hashes,
        "n_sealed": 22,
        "n_present_in_strat_live": sum(1 for h in sealed_22_hashes
                                       if h in strat_live_h),
        "all_present": all(h in strat_live_h for h in sealed_22_hashes),
        "strat_live_count": c_strat["n_live"],
        "note": ("22 must reappear unchanged among stratified live after "
                 "multidegree+line-order+six-flips; sealed count was 22 "
                 "at dim≤37."),
    }
    # sealed strat census: 336+398+22
    assert c_strat["deaths"]["DEAD_MULTIDEGREE"] == 336, c_strat["deaths"]
    assert c_strat["deaths"]["DEAD_LINE_ORDER"] == 398, c_strat["deaths"]
    assert c_strat["n_live"] == 22, c_strat["n_live"]
    assert anchor["all_present"]

    out = {
        "p": p,
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "finisher": {k: v for k, v in fin.items()},
        "six_flips": {k: v for k, v in six.items()
                      if k not in ("LAM_SLICE", "CELL37", "kids6",
                                   "Wplus", "Wminus")},
        "ext_508": {k: v for k, v in c_ext.items() if k != "detail"},
        "strat_756": {k: v for k, v in c_strat.items() if k != "detail"},
        "joint_1264": {k: v for k, v in c_all.items() if k != "detail"},
        "anchor_22": anchor,
        "per_layer_deaths_508": {
            "multidegree": c_ext["deaths"]["DEAD_MULTIDEGREE"],
            "line_order": c_ext["deaths"]["DEAD_LINE_ORDER"],
            "live_after_six_flips": c_ext["deaths"]["LIVE_AFTER_FLIPS"],
            "total": c_ext["n"],
        },
        "detail_ext": c_ext["detail"],
        "detail_joint_live_ids": c_all["live_ids"],
    }
    path = os.path.join(RES, "sieve_layers_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(out, f, indent=1)
    # live-to-ladder list for arc-jet
    live_ext = [pt for pt in ext if classify_pattern(pt)[0] == "LIVE_TO_FLIPS"]
    with open(os.path.join(RES, "live_ext_to_ladder_p%d.json" % p), "w") as f:
        json.dump({"p": p, "n": len(live_ext), "patterns": live_ext}, f)
    print("  508 deaths: multidegree=%d line_order=%d live_to_ladder=%d"
          % (c_ext["deaths"]["DEAD_MULTIDEGREE"],
             c_ext["deaths"]["DEAD_LINE_ORDER"],
             c_ext["deaths"]["LIVE_AFTER_FLIPS"]), flush=True)
    print("  strat 756: 336+398+22 ok; anchor22=%s"
          % anchor["all_present"], flush=True)
    print("  joint live after sealed layers: %d" % c_all["n_live"], flush=True)
    print("SIEVE_LAYERS_OK p=%d" % p, flush=True)
    return out


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 331)
