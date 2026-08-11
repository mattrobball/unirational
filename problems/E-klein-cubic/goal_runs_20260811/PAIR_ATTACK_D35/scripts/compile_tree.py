#!/usr/bin/env python3
"""Hierarchical pair-attack compiler at d=35 (prune-as-you-go).

Layer 0  : sealed cuts + A4 mu>=2  (layer0_base.py)  -- shared matrix
Layer 1  : per sigma-band pattern, full-flag leading-datum conditions
           branched by multidegree class then value fingerprint; dead
           branches killed immediately; constraint rows shared up the tree
Layer 2  : D10 branch + odd-order values from GLOBAL_COHERENCE when present

Usage:  python3 compile_tree.py [p] [npair] [npt]
"""
import json
import os
import sys
import time
from collections import defaultdict

import numpy as np

import paths  # noqa: F401
import slicelib as SL
import p2lib as P2
import d34lib as D34
import produce_d34 as PD
from layer0_base import build_layer0, DEG, DIM_M
from patterns_r5 import build_patterns, full_flag_rows

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
BASE11 = os.path.dirname(PACKET)
GC_RES = os.path.join(BASE11, "GLOBAL_COHERENCE", "results")


def plane_order_block(fr, A, C, d, m, npair, p, rng):
    return PD.plane_blocks(fr, A, C, d, m, npair, p, rng)


def leading_value_block(fr, A, C, d, m, target_pts, npair, p, rng):
    """Order-m leading form on plus-plane lands in span of target directions."""
    if m < 0 or not target_pts:
        return np.zeros((A.shape[0], 0), dtype=np.int64)
    Wp, Wm = fr["Wplus"], fr["Wminus"]
    ns = A.shape[0]
    Wa = D34.rand_in_span(Wp, npair, p, rng)
    Ya = D34.rand_in_span(Wm, npair, p, rng)
    J = SL.jet_rows(fr, A, C, Wa, Ya, m + 1, deg=d)
    # jet_rows shape: (ns, npair, 5, njet)  -- matches produce_d34 einsum 'sqc'
    top = J[:, :, :, m]  # (ns, npair, 5)
    blocks = []
    for tgt in target_pts:
        if tgt is None:
            continue
        tgt = np.array(tgt, dtype=np.int64) % p
        if not np.any(tgt % p):
            continue
        ANN = SL.nullspace(tgt[None, :] % p, p)  # (4, 5)
        bl = np.einsum("sqc,ac->sqa", top, ANN).reshape(ns, -1) % p
        blocks.append(bl)
    if not blocks:
        return np.zeros((ns, 0), dtype=np.int64)
    return np.concatenate(blocks, axis=1) % p


def extract_targets_from_ff_pattern(pat, p):
    targets = []
    if pat is None:
        return targets
    for r0, v in pat.items():
        try:
            if not isinstance(v, (list, tuple)) or len(v) < 3:
                continue
            if v[0] not in ("pt", "gen"):
                continue
            coords = v[2]
            while isinstance(coords, (list, tuple)) and len(coords) == 1:
                coords = coords[0]
            if isinstance(coords, (list, tuple)) and len(coords) == 5:
                targets.append([int(x) % p for x in coords])
        except Exception:
            continue
    return targets


def restrict_nullspace(K, blocks, p):
    if K.shape[0] == 0:
        return K
    parts = [b for b in blocks if b.size and b.shape[1] > 0]
    if not parts:
        return K
    B = np.concatenate(parts, axis=1) % p
    M = (B.T @ (K.T % p)) % p  # (nf, k)
    N = SL.nullspace(M, p)
    if N.size == 0:
        return np.zeros((0, K.shape[1]), dtype=np.int64)
    return (N @ K) % p


def layer1_tree(L0, patterns_pack, p, npair=60, rng_seed=20260811, verbose=True):
    rng = np.random.default_rng(rng_seed)
    fr, A, C, K0 = L0["fr"], L0["A"], L0["C"], L0["K"]
    patterns, summary, groups, tables, E, ff_pats, ff_lead, ff_tagged = \
        patterns_pack
    ff = full_flag_rows(E)
    t0 = time.time()

    # Multidegree classes on D_P: m in {1,3,5}
    m_classes = sorted({t["m_or_nu"] for t in ff_tagged[ff[0]]})
    if verbose:
        print("[L1] D_P m-classes: %s" % m_classes, flush=True)
        print("[L1] min_m histogram: %s" % summary.get("m_hist_by_min_m"),
              flush=True)

    # Shared order-blocks and restricted kers
    ker_after_m = {}
    for m in m_classes:
        c1, c2 = plane_order_block(fr, A, C, DEG, m, npair, p, rng)
        Km = restrict_nullspace(K0, [c1, c2], p)
        ker_after_m[m] = Km
        if verbose:
            print("[L1] m=%d  dim %d -> %d  [%.1fs]"
                  % (m, K0.shape[0], Km.shape[0], time.time() - t0), flush=True)

    death = {
        "layer1_mclass_dead": 0,
        "layer1_value_dead": 0,
        "layer1_alive": 0,
        "n_mclass": len(m_classes),
        "n_patterns": 756,
        "n_groups": len(groups),
        "m_class_dims": {str(m): int(ker_after_m[m].shape[0]) for m in m_classes},
        "per_m_alive": {},
        "per_m_dead": {},
    }

    survivors = []
    # Group patterns by (min_m, group_key)
    by_key = defaultdict(list)
    for rec in patterns:
        by_key[(rec["min_m"], rec["group_key"])].append(rec)

    # Value-linearization note: pointwise conditions require evaluating the
    # bihomogeneous leading form at STAGE1 child coordinates (kid['qs']) in a
    # frame aligned with the D34 Weil frame.  A global annihilator against
    # every assigned *image* value is incorrect (forces the leading form into
    # the intersection of many lines ⇒ 0).  This packet therefore treats the
    # multidegree class cut as the decisive Layer-1 linear prune; value
    # fingerprints are recorded per group for frame-aligned follow-up, and do
    # not further cut the T-slice here.
    death["value_linearization"] = (
        "DEFERRED_FRAME_ALIGNMENT: pointwise child evaluation needs "
        "STAGE1 qs coords in the D34 Weil frame; global multi-target "
        "annihilators are unsound and are not used."
    )

    for (min_m, gkey), recs in sorted(by_key.items(),
                                      key=lambda kv: (kv[0][0] is None,
                                                      kv[0][0] or 0,
                                                      kv[0][1])):
        n = len(recs)
        if min_m is None:
            death["layer1_mclass_dead"] += n
            death["per_m_dead"]["None"] = death["per_m_dead"].get("None", 0) + n
            continue

        m_opts = recs[0]["m_options_P"]
        live_m = None
        K_live = None
        for m in sorted(m_opts):
            Km = ker_after_m.get(m)
            if Km is not None and Km.shape[0] > 0:
                live_m = m
                K_live = Km
                break
        if live_m is None:
            death["layer1_mclass_dead"] += n
            death["per_m_dead"][str(min_m)] = (
                death["per_m_dead"].get(str(min_m), 0) + n)
            if verbose:
                print("[L1]   DEAD mclass min_m=%s opts=%s n=%d"
                      % (min_m, m_opts, n), flush=True)
            continue

        # Live: multidegree class compatible with the sealed slice.
        # Dim = dim of ker_after_m[live_m] (value cuts deferred).
        K2 = K_live
        death["layer1_alive"] += n
        death["per_m_alive"][str(live_m)] = (
            death["per_m_alive"].get(str(live_m), 0) + n)
        tag = "m%d_%s" % (live_m, gkey)
        np.save(os.path.join(RES, "surv_basis_%s_p%d.npy" % (tag, p)), K2)
        basis = K2.tolist() if K2.shape[0] <= 40 else None
        # record value fingerprint size for follow-up
        n_val = 0
        for rec in recs[:1]:
            for rid in ff:
                for idx in rec["compat_ff"].get(str(rid), []):
                    n_val += ff_tagged[rid][idx]["n_assigned"]
        for rec in recs:
            survivors.append({
                "pattern_id": rec["id"],
                "hash": rec["hash"],
                "group_key": gkey,
                "group_size": rec["group_size"],
                "min_m": min_m,
                "live_m": live_m,
                "m_options_P": rec["m_options_P"],
                "a35_P_options": rec["a35_P_options"],
                "a35_L_options": rec["a35_L_options"],
                "dim": int(K2.shape[0]),
                "n_value_assignments": n_val,
                "value_cut": "deferred_frame_alignment",
                "slice_basis_rows": int(K2.shape[0]),
                "basis_ref": "surv_basis_%s_p%d.npy" % (tag, p),
                "basis": basis,
                "basis_shape": list(K2.shape),
            })

    death["layer1_alive"] = len(survivors)
    death["layer1_dead"] = 756 - len(survivors)
    death["wall_s"] = round(time.time() - t0, 2)
    if verbose:
        print("[L1] alive=%d dead=%d (mclass_dead=%d value_dead=%d)  [%.1fs]"
              % (death["layer1_alive"], death["layer1_dead"],
                 death["layer1_mclass_dead"], death["layer1_value_dead"],
                 time.time() - t0), flush=True)
        print("[L1] per_m_alive=%s per_m_dead=%s"
              % (death["per_m_alive"], death["per_m_dead"]), flush=True)
        print("[L1] value cut: %s" % death["value_linearization"][:80],
              flush=True)
    return survivors, death, ker_after_m


def layer2_odd(survivors, p, verbose=True):
    """Consume GLOBAL_COHERENCE value-vectors at d=35 when present.

    The per-center menus are symbolic (eigpt/C6pt/UNDEF).  They pin the
    odd-order row values of each surviving r; translating them into
    additional linear cuts on T requires matching symbolic labels to
    frame eigenpoints (done for the sealed base-locus already).  Here we
    record the menus, the D10 branch data, and leave the T-slice unchanged
    (no further linear cut beyond Layer 0/1).  The tree only shrinks under
    a future geometric realisation test.
    """
    gc_present = os.path.isdir(GC_RES)
    vectors_path = os.path.join(GC_RES, "vectors_d35.json")
    has_vectors = os.path.isfile(vectors_path)
    info = {
        "GLOBAL_COHERENCE_present": gc_present,
        "vectors_d35_present": has_vectors,
        "odd_order_mode": "consume_value_vectors" if has_vectors else "free",
        "n_in": len(survivors),
        "n_out": len(survivors),
    }
    if has_vectors:
        with open(vectors_path) as fh:
            vec = json.load(fh)
        info["G"] = vec.get("G")
        info["G_corrected_cite"] = (
            "GLOBAL_COHERENCE/results/G_table_corrected.txt: "
            "G_corrected(35)=630352558080"
        )
        info["K"] = vec.get("K")
        info["F_odd"] = vec.get("F_odd")
        info["per_center_sizes"] = {
            k: v.get("n") if isinstance(v, dict) else len(v)
            for k, v in vec.get("per_center", {}).items()
        }
        info["D10_branch"] = (
            "D10 per_center n=%s; B(D10) already in Layer 0; "
            "mu0-parity selects E/L branch of C2-line (both open on T-side "
            "linear layer)" % info["per_center_sizes"].get("D10")
        )
        info["note"] = (
            "Consumed vectors_d35.json menus (symbolic).  No additional "
            "linear cut on the Layer-1 T-slice: value labels are eigenpoint "
            "weights already compatible with the sealed base-locus.  "
            "Realization tests on survivors must match the menus."
        )
        # Attach menu sizes to each survivor
        for s in survivors:
            s["F_odd"] = vec.get("F_odd")
            s["G_factor_cite"] = info["G"]
            s["odd_order_menus"] = info["per_center_sizes"]
    else:
        info["D10_branch"] = "both open (mu1 free; B(D10) in L0)"
        info["note"] = (
            "GLOBAL_COHERENCE/results/vectors_d35.json absent; "
            "running with free odd-order values (tree only shrinks under join)."
        )
    if verbose:
        print("[L2] mode=%s in=%d out=%d F_odd=%s G=%s"
              % (info["odd_order_mode"], info["n_in"], info["n_out"],
                 info.get("F_odd"), info.get("G")), flush=True)
    return survivors, info


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    npair = int(sys.argv[2]) if len(sys.argv) > 2 else 80
    npt = int(sys.argv[3]) if len(sys.argv) > 3 else 60
    os.makedirs(RES, exist_ok=True)
    t0 = time.time()

    print("=" * 60, flush=True)
    print("PAIR ATTACK d=35  p=%d" % p, flush=True)
    print("=" * 60, flush=True)

    L0 = build_layer0(p, npair=npair, npt=npt)
    rec0 = L0["rec"]
    with open(os.path.join(RES, "layer0_p%d.json" % p), "w") as fh:
        json.dump(rec0, fh, indent=1, sort_keys=True)
    np.save(os.path.join(RES, "layer0_null_p%d.npy" % p), L0["K"])
    if not rec0["d34_match"]:
        print("STOP: ambient dim %d > 39" % rec0["dim_structure_plus_(1,r0)"])
        with open(os.path.join(RES, "STOP_DISCREPANCY_p%d.json" % p), "w") as fh:
            json.dump(rec0, fh, indent=1)
        sys.exit(2)

    patterns_pack = build_patterns(p, verbose=True)
    patterns, summary, groups, tables, E, ff_pats, ff_lead, ff_tagged = \
        patterns_pack
    with open(os.path.join(RES, "patterns_r5_summary_p%d.json" % p), "w") as fh:
        json.dump(summary, fh, indent=1, sort_keys=True)
    with open(os.path.join(RES, "patterns_r5_p%d.json" % p), "w") as fh:
        json.dump({"summary": summary, "patterns": patterns}, fh)

    survivors, death1, ker_m = layer1_tree(
        L0, patterns_pack, p, npair=npair, verbose=True)
    survivors2, info2 = layer2_odd(survivors, p, verbose=True)
    survivors2 = sorted(survivors2, key=lambda s: (s["dim"], s["pattern_id"]))

    stats = {
        "prime": p,
        "layer0": rec0,
        "layer1_death": death1,
        "layer2": info2,
        "n_survivors": len(survivors2),
        "survivor_dims": sorted(set(s["dim"] for s in survivors2)),
        "dim_histogram": {
            str(d): sum(1 for s in survivors2 if s["dim"] == d)
            for d in sorted(set(s["dim"] for s in survivors2))
        },
        "all_dead_linear": len(survivors2) == 0,
        "wall_s": round(time.time() - t0, 2),
        "RT_ACTUAL_LANDING_cite": (
            "goal_runs_20260811/RT_ACTUAL_LANDING/D35_BRANCH_TABLE.md: "
            "27 open T-side cells; d' in {2,3,4,5} excluded; k=32,33 excluded. "
            "r-side packet does not recompute."
        ),
        "GLOBAL_COHERENCE_cite": (
            "goal_runs_20260811/GLOBAL_COHERENCE/results/vectors_d35.json; "
            "G_corrected(35)=630352558080"
        ),
    }
    slim = []
    for s in survivors2:
        s2 = dict(s)
        if s2.get("basis") is not None and s2["dim"] > 10:
            s2["basis"] = None
            s2["basis_ref"] = s2.get("basis_ref", "surv_basis_*.npy")
        slim.append(s2)
    with open(os.path.join(RES, "survivors_p%d.json" % p), "w") as fh:
        json.dump({"stats": stats, "survivors": slim}, fh, indent=1)
    with open(os.path.join(RES, "death_stats_p%d.json" % p), "w") as fh:
        json.dump(stats, fh, indent=1, sort_keys=True)

    print("=" * 60, flush=True)
    print("DONE p=%d  L0_d34=%d L0_full=%d  L1_alive=%d  survivors=%d  "
          "dims=%s  all_dead=%s  [%.0fs]"
          % (p, rec0["dim_structure_plus_(1,r0)"],
             rec0["dim_layer0_plus_A4mu2"], death1["layer1_alive"],
             len(survivors2), stats["survivor_dims"],
             stats["all_dead_linear"], time.time() - t0), flush=True)
    if stats["all_dead_linear"]:
        print("FLAG: ALL_DEAD_LINEAR -- window-closure-adjacent; "
              "DO NOT CLAIM; promotion gate = ODDZERO-standard adversarial "
              "audit. Window stays 'first open window d=35'.", flush=True)


if __name__ == "__main__":
    main()
