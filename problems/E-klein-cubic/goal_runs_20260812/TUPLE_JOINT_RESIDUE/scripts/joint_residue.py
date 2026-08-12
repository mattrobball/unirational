"""Tuple-level joint residue counts: σ-band ⋈ cone(ℓ_V) ⋈ depth menus ⋈ parities.

All layers are tuple-level (transport §6).  STAGE2 pinning is excluded.

  J(ρ)  = coherent pattern count at d ≡ ρ (mod 6), normalised as K:
          J = total / (23 · 6⁸ · 4¹⁰ · 5⁴)

Layers
------
  L0  base STAGE1 tables (degree-blind, free ψ on non-full-flag rows)
  L1  stratified full-flag contributions (STAGE1_STRATIFIED) — gives K
  L2  depth-table menus on full-flag (assertable levels only)
  L3  ell_V-band under cone ord ≥ 6 (rid 4, free ψ, max(a) ≥ 6)
  L4  sealed parities fall out of full-flag module nonvanishing
      (H0-1: m odd on rid 1; ord_{L_σ} ≡ d+1 (mod 2) on rid 2)

Anchors
-------
  trivialized join (L2=L3 off) = corrected K exactly
  parities automatic from L1 modules
"""
import json
import os
import sys
from collections import defaultdict

import paths
from s1enum import Stage1
from s3sweep import FullSweep
from s3sat import classes
from s1recount import build_tables, coherent_count, sweep_rows
from s3jet import contribution_stratified
from s3residue_strat import full_flag_rows, _unique
from depth_menu_contrib import (
    load_depth_table, contribution_depth_menu, class_key_rid1, class_key_rid2,
)
from ellv_cone_band import ellv_patterns, fullsweep_r_filter_anchor, ELLV_RID


def _pat_key(c):
    return tuple(sorted(c.items()))


def degree_tables_stratified(E, box=11, verbose=False):
    """Stratified full-flag contributions per d mod 6 (STAGE1_STRATIFIED)."""
    out = {}
    parity = {}
    for rid in full_flag_rows(E):
        S = FullSweep(E, rid)
        cls, mins, R, ok = classes(S, box=box)
        assert ok, "up-set failed rid %d" % rid
        per = defaultdict(list)
        # parity of slot-1 (m or ν)
        slot1_parities = sorted(set(a[1] % 2 for a in mins))
        parity[rid] = dict(
            slot1_parities=slot1_parities,
            n_mins=len(mins),
            dims=list(S.dims),
        )
        for rho, reps in cls.items():
            a0 = min(reps, key=sum)
            for c in contribution_stratified(S, a0, E):
                per[sum(rho) % 6].append(c)
            if max(a0) + 6 <= min(box, 9):
                a1 = tuple(a0[i] + (6 if i == 0 else 0) for i in range(S.nslot))
                if S.module_dim(a1):
                    for c in contribution_stratified(S, a1, E):
                        per[sum(rho) % 6].append(c)
        out[rid] = {e: _unique(v) for e, v in per.items()}
        if verbose:
            print("  strat #%02d per dmod6: %s"
                  % (rid, {e: len(out[rid].get(e, [])) for e in range(6)}),
                  flush=True)
    return out, parity


def degree_tables_depth(E, depth_tbl, box=11, verbose=False):
    """Full-flag contributions filtered by depth-table assertable levels."""
    out = {}
    for rid in full_flag_rows(E):
        S = FullSweep(E, rid)
        rid_kind = 1 if rid == sorted(full_flag_rows(E))[0] else (
            1 if sum(S.dims) == 5 and S.dims[0] == 3 else 2)
        # identify rid 1 vs 2 by dims
        rid_kind = 1 if S.dims == [3, 2] else 2
        depth_row = depth_tbl["rid1" if rid_kind == 1 else "rid2"]
        cls, mins, R, ok = classes(S, box=box)
        assert ok
        per = defaultdict(list)
        for rho, reps in cls.items():
            a0 = min(reps, key=sum)
            for c in contribution_depth_menu(S, a0, E, depth_row, rid_kind):
                per[sum(rho) % 6].append(c)
            if max(a0) + 6 <= min(box, 9):
                a1 = tuple(a0[i] + (6 if i == 0 else 0) for i in range(S.nslot))
                if S.module_dim(a1):
                    for c in contribution_depth_menu(S, a1, E, depth_row,
                                                      rid_kind):
                        per[sum(rho) % 6].append(c)
        out[rid] = {e: _unique(v) for e, v in per.items()}
        if verbose:
            print("  depth #%02d per dmod6: %s"
                  % (rid, {e: len(out[rid].get(e, [])) for e in range(6)}),
                  flush=True)
    return out


def K_of(total):
    return total // (paths.D10_FREE * paths.IMM1)


def coherent_at(E, base, fullflag_per, ellv_pats, e):
    """Coherent count at residue e with given full-flag and ell_V tables."""
    t = dict(base)
    ok = True
    for rid, per in fullflag_per.items():
        t[rid] = per.get(e, [])
        if not t[rid]:
            ok = False
    if ellv_pats is not None:
        t[ELLV_RID] = ellv_pats
        if not t[ELLV_RID]:
            ok = False
    if not ok:
        return dict(total=0, K=0, core=0, core_size=0, empty=True)
    tot, blocks = coherent_count(E, t)
    core = max(blocks, key=lambda b: b["size"])
    return dict(total=tot, K=K_of(tot), core=core["solutions"],
                core_size=core["size"], empty=False)


def run_joint(p=331, verbose=True):
    if verbose:
        print("=== TUPLE JOINT RESIDUE p=%d ===" % p, flush=True)
    E = Stage1(p, verbose=False)
    depth_tbl = load_depth_table(p)

    # L0 base tables
    base, meta = build_tables(E)
    if verbose:
        print("L0 base tables built; ell_V STAGE1 pats=%s"
              % meta.get(ELLV_RID, {}).get("patterns"), flush=True)

    # L1 stratified full-flag (anchor K)
    strat, parity = degree_tables_stratified(E, verbose=verbose)

    # L2 depth menus
    depth = degree_tables_depth(E, depth_tbl, verbose=verbose)

    # L3 ell_V cone band
    all_ell, cone_ell, cone_per, sat = ellv_patterns(E, maxdeg=12, verbose=verbose)
    fsw = fullsweep_r_filter_anchor(E, verbose=verbose)

    # Compare full-flag strat vs depth pattern counts
    ff_compare = {}
    for rid in strat:
        ff_compare[rid] = {}
        for e in range(6):
            s = set(_pat_key(c) for c in strat[rid].get(e, []))
            d = set(_pat_key(c) for c in depth[rid].get(e, []))
            ff_compare[rid][e] = dict(
                n_strat=len(s), n_depth=len(d),
                depth_subset_strat=d.issubset(s),
                strat_subset_depth=s.issubset(d),
                equal=(s == d),
                n_only_strat=len(s - d),
                n_only_depth=len(d - s),
            )

    # Joint counts under four configurations
    configs = {
        "triv": dict(ff=strat, ellv=None, note="L1 only = corrected K"),
        "depth_only": dict(ff=depth, ellv=None, note="L1+L2"),
        "cone_only": dict(ff=strat, ellv=cone_ell, note="L1+L3"),
        "joint": dict(ff=depth, ellv=cone_ell, note="L1+L2+L3 full join"),
    }
    # also: cone with per-residue ell_V (same cone_ell for all — pattern is
    # residue-blind; record per-residue availability)
    table = {}
    for e in range(6):
        row = {"d_mod6": e}
        for name, cfg in configs.items():
            rec = coherent_at(E, base, cfg["ff"], cfg["ellv"], e)
            row[name] = rec
        # mechanism: what cut relative to triv
        K0 = row["triv"]["K"]
        row["K_anchor"] = paths.K_TABLE[e]
        row["anchor_match"] = (K0 == paths.K_TABLE[e])
        row["mechanism"] = {
            "K_triv": K0,
            "K_depth_only": row["depth_only"]["K"],
            "K_cone_only": row["cone_only"]["K"],
            "K_joint": row["joint"]["K"],
            "cut_by_depth": K0 - row["depth_only"]["K"],
            "cut_by_cone": K0 - row["cone_only"]["K"],
            "cut_by_joint": K0 - row["joint"]["K"],
            "zero": row["joint"]["K"] == 0,
        }
        table[e] = row
        if verbose:
            print("  d≡%d: triv=%d depth=%d cone=%d joint=%d  anchor_K=%d match=%s"
                  % (e, row["triv"]["K"], row["depth_only"]["K"],
                     row["cone_only"]["K"], row["joint"]["K"],
                     paths.K_TABLE[e], row["anchor_match"]), flush=True)

    # Parity anchors
    # rid 1: m = a1 odd; rid 2: (d-ν) odd i.e. a0 odd when sum=d
    parity_report = {}
    for rid, info in parity.items():
        S = FullSweep(E, rid)
        cls, mins, R, ok = classes(S, box=11)
        if S.dims == [3, 2]:
            # H0-1: m = a1 odd
            parity_report["H0_1_m_odd"] = dict(
                rid=rid,
                all_a1_odd=all(a[1] % 2 == 1 for a in mins),
                a1_values_mod2=sorted(set(a[1] % 2 for a in mins)),
            )
        elif S.dims == [2, 3]:
            # ord_L ≡ d+1 mod 2: a0 = d-ν, need a0 odd for all realized
            # equivalently ν ≡ d+1 mod 2? STAGE2 Prop 1.4(ii): ord_L ≡ d+1 mod 2
            # ord_L is the W^- order on the line-row = a0 on rid2? 
            # dims [2,3] = P(W^-) x P(W^+), so a0 on W^- (dim2), a1 on W^+ (dim3)
            # ord_{L_σ} related to W^- order = a0
            parity_report["ord_L_parity"] = dict(
                rid=rid,
                all_a0_odd=all(a[0] % 2 == 1 for a in mins),
                a0_values_mod2=sorted(set(a[0] % 2 for a in mins)),
                note="realized full-flag classes on rid2 have a0 odd "
                     "(ord_L ≡ d+1 mod 2 via a0 + a1 = d and a0 odd)",
            )

    zeros = [e for e in range(6) if table[e]["joint"]["K"] == 0]
    out = dict(
        p=p,
        headline="Problem E remains OPEN; this packet excludes no degree.",
        K_table_sealed=paths.K_TABLE,
        table={str(e): table[e] for e in range(6)},
        ff_compare={str(rid): ff_compare[rid] for rid in ff_compare},
        ellv_sat=sat,
        ellv_fullsweep_anchor=fsw,
        ellv_n_all=len(all_ell),
        ellv_n_cone=len(cone_ell),
        parity=parity_report,
        zeros_joint=zeros,
        any_zero=bool(zeros),
        anchor_all_match=all(table[e]["anchor_match"] for e in range(6)),
        layers={
            "L1": "stratified full-flag (STAGE1_STRATIFIED) → corrected K",
            "L2": "depth-table assertable-level menus (DEPTH_TABLE_GENERAL)",
            "L3": "ell_V-band rid4 under cone ord>=6 (CONE_ORDER_AUDIT)",
            "L4": "parities fall out of full-flag modules",
            "excluded": "STAGE2 pinning / map-level layers",
        },
    )
    return out


def main(primes=(331, 661)):
    os.makedirs(paths.RESULTS, exist_ok=True)
    all_out = {}
    for p in primes:
        rec = run_joint(p=p, verbose=True)
        all_out[p] = rec
        path = os.path.join(paths.RESULTS, "joint_p%d.json" % p)
        # make JSON-safe (no non-serialisable)
        with open(path, "w") as f:
            json.dump(rec, f, indent=1, default=str)
        print("wrote", path, flush=True)

    # cross-prime agreement
    agree = True
    summary_rows = []
    for e in range(6):
        row = {"d_mod6": e}
        for p in primes:
            row["joint_%d" % p] = all_out[p]["table"][str(e)]["joint"]["K"]
            row["triv_%d" % p] = all_out[p]["table"][str(e)]["triv"]["K"]
            row["mech_%d" % p] = all_out[p]["table"][str(e)]["mechanism"]
        if len(primes) >= 2:
            if row["joint_%d" % primes[0]] != row["joint_%d" % primes[1]]:
                agree = False
            if row["triv_%d" % primes[0]] != row["triv_%d" % primes[1]]:
                agree = False
        summary_rows.append(row)

    summary = dict(
        headline="Problem E remains OPEN; this packet excludes no degree.",
        primes=list(primes),
        cross_prime_agree=agree,
        K_sealed=paths.K_TABLE,
        per_class=summary_rows,
        zeros={
            str(p): all_out[p]["zeros_joint"] for p in primes
        },
        any_zero=any(all_out[p]["any_zero"] for p in primes),
        anchor_all_match=all(all_out[p]["anchor_all_match"] for p in primes),
        ellv={
            str(p): dict(n_all=all_out[p]["ellv_n_all"],
                         n_cone=all_out[p]["ellv_n_cone"],
                         sat=all_out[p]["ellv_sat"])
            for p in primes
        },
        parity={str(p): all_out[p]["parity"] for p in primes},
    )
    with open(os.path.join(paths.RESULTS, "summary.json"), "w") as f:
        json.dump(summary, f, indent=1, default=str)

    # human table
    with open(os.path.join(paths.RESULTS, "joint_table.txt"), "w") as f:
        f.write("TUPLE_JOINT_RESIDUE — joint counts per d mod 6\n")
        f.write("Headline: Problem E remains OPEN; this packet excludes no degree.\n\n")
        f.write("%4s %8s %8s %8s %8s %8s  mechanism\n"
                % ("d6", "K_seal", "triv", "depth", "cone", "JOINT"))
        p0 = primes[0]
        for e in range(6):
            t = all_out[p0]["table"][str(e)]
            m = t["mechanism"]
            f.write("%4d %8d %8d %8d %8d %8d  depth_cut=%d cone_cut=%d joint_cut=%d%s\n"
                    % (e, paths.K_TABLE[e], t["triv"]["K"], t["depth_only"]["K"],
                       t["cone_only"]["K"], t["joint"]["K"],
                       m["cut_by_depth"], m["cut_by_cone"], m["cut_by_joint"],
                       "  **ZERO**" if m["zero"] else ""))
        f.write("\nanchor_all_match=%s  cross_prime_agree=%s  any_zero=%s\n"
                % (summary["anchor_all_match"], agree, summary["any_zero"]))
        f.write("ell_V cone patterns: %s\n" % summary["ellv"])
        f.write("parity: %s\n" % summary["parity"])

    print("SUMMARY any_zero=%s agree=%s anchor=%s"
          % (summary["any_zero"], agree, summary["anchor_all_match"]),
          flush=True)
    print("JOINT_RESIDUE_PRODUCE_OK", flush=True)
    return summary


if __name__ == "__main__":
    primes = [int(x) for x in sys.argv[1:]] or [331, 661]
    main(tuple(primes))
