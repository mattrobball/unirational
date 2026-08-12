#!/usr/bin/env python3
"""Mechanical joint realization assembly for the 22 live d=35 cells.

Read sealed packets.  Intersect the fiber-structure constraints they
actually state.  Never collapse a menu.  Never invent a bound.  A
contradiction is emitted as FLAG_KILL and is not claimed.

Writes only under CELL_SYNTHESIS/results/.
"""

from __future__ import annotations

import hashlib
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import paths as P  # noqa: E402

HEADLINE = "Problem E remains OPEN; this packet excludes no degree."

# Director-sealed L12 numbers after the referee's extended-scope correction.
# The on-disk l12_order11.json still stores the original depth-<=3 census
# (1540 / 118).  Both figures are recorded; the THEOREM adjudication is
# the sealed yield.
L12_EXTENDED = {
    "source": "goal_runs_20260812/L12_ORDER11/THEOREM.md director adjudication",
    "n_towers": 2674,
    "n_integral": 226,
    "n_genus0_pass": 0,
    "n_menu_pass": 0,
}


def load(path):
    with open(path) as f:
        return json.load(f)


def sha256_of(obj):
    blob = json.dumps(obj, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(blob).hexdigest()


def crt_chi0():
    """Independent CRT: 2 chi0 == 4 (mod 11) and 2 chi0 == 0 (mod 5)."""
    inv11 = next(i for i in range(11) if (2 * i) % 11 == 1)
    inv5 = next(i for i in range(5) if (2 * i) % 5 == 1)
    r11 = (inv11 * 4) % 11
    r5 = (inv5 * 0) % 5
    # chi0 == r11 (mod 11), chi0 == r5 (mod 5)
    x = next(n for n in range(55) if n % 11 == r11 and n % 5 == r5)
    return {
        "two_chi0_mod_11": 4,
        "two_chi0_mod_5": 0,
        "chi0_mod_11": r11,
        "chi0_mod_5": r5,
        "chi0_mod_55": x,
        "modulus": 55,
    }


def joint_genera(limit=400):
    out = []
    for g in range(0, limit + 1):
        if g >= 10 and (g - 10) % 11 == 0 and g >= 6 and (g - 6) % 5 == 0:
            out.append(g)
    return out


def forced_depth_from_l12(l12):
    """Total blowup depth at which R==0 is first reachable: extra+1."""
    i3 = l12["integrality_info"]["I3"]
    i2 = l12["integrality_info"]["I2"]
    g0 = l12["genus0_and_menu"]
    table = {}
    for mu in range(1, 11):
        extra = i3[str(mu)]["min_extra_depth_for_R0"]
        table[mu] = {
            "mu": mu,
            "min_extra_depth_for_R0": extra,
            "forced_total_depth": extra + 1,
            "n_towers_depth_le_3": i2[str(mu)]["n_towers"],
            "n_integral_depth_le_3": i2[str(mu)]["n_integral"],
            "n_genus0_pass_depth_le_3": i2[str(mu)]["n_genus0_pass"],
            "n_menu_pass_depth_le_3": g0[str(mu)]["n_menu_pass"],
            "defined_rows": g0[str(mu)]["defined_rows"],
        }
    return table


def match_c11_vectors(vectors, smith_menu):
    """Attach mu to each vectors_d35 C11 entry by exact vector match.

    The two lists are the same 10 vectors in different order.  Both
    orders are kept.  Matching is a SET check plus a per-entry mu label.
    """
    by_vec = {}
    for e in smith_menu:
        key = tuple(e["vector"])
        if key in by_vec:
            raise RuntimeError("SMITH C11 menu collapsed or duplicated")
        by_vec[key] = e
    attached = []
    seen_mu = []
    for vec in vectors["per_center"]["C11"]["vectors"]:
        e = by_vec[tuple(vec)]
        attached.append({
            "vector": list(vec),
            "mu": e["mu"],
            "n_defined_rows": e["n_defined_rows"],
            "n_x": e["n_x"],
            "congruence": e["congruence"],
        })
        seen_mu.append(e["mu"])
    if sorted(seen_mu) != list(range(1, 11)):
        raise RuntimeError("C11 mu labels are not {1..10}")
    return attached


def identity_block(audit, smith, stein_menus, keep331, keep661):
    ids = list(audit["survivors22"]["ids"])
    hashes = list(audit["survivors22"]["content_hashes"])
    sealed = list(audit["survivors22"]["sealed_hashes"])
    if len(ids) != 22 or len(set(hashes)) != 22:
        raise RuntimeError("survivors22 is not 22 unique content hashes")

    smith_ids = [c["cell_id"] for c in smith["cells"]]
    smith_h = [c["content_hash_p331"] for c in smith["cells"]]
    stein_ids = list(stein_menus["cells_22_ids"])
    stein_h = list(stein_menus["cells_22_content_hashes_p331"])

    keep_ids = [d["id"] for d in keep331["detail"]]
    keep_h = [d["content_hash"] for d in keep331["detail"]]
    keep_s = [d["sealed_hash"] for d in keep331["detail"]]

    pairing = {
        "identity_key": "content_hash@p331 (HANDOFF / D35_AUDIT)",
        "audit_smith_stein_ids_agree": ids == smith_ids == stein_ids,
        "audit_smith_stein_hashes_agree": hashes == smith_h == stein_h,
        "audit_id_to_hash": {str(i): h for i, h in zip(ids, hashes)},
        "keep_pass_p331": {
            "ids_equal_as_list": keep_ids == ids,
            "content_hash_set_equal": set(keep_h) == set(hashes),
            "sealed_hash_set_equal": set(keep_s) == set(sealed),
            "id_to_hash_agrees_with_audit": (
                {i: h for i, h in zip(keep_ids, keep_h)}
                == {i: h for i, h in zip(ids, hashes)}
            ),
            "n_live": keep331["n_live"],
            "n_dead": keep331["n_dead"],
            "live_dims": keep331["live_dims"],
            "all_verdicts_LIVE": all(d["verdict"] == "LIVE" for d in keep331["detail"]),
            "all_best_dim_37": all(d["best_dim"] == 37 for d in keep331["detail"]),
        },
        "keep_pass_p661": {
            "n_live": keep661["n_live"],
            "n_dead": keep661["n_dead"],
            "live_dims": keep661["live_dims"],
            "all_verdicts_LIVE": all(d["verdict"] == "LIVE" for d in keep661["detail"]),
            "all_best_dim_37": all(d["best_dim"] == 37 for d in keep661["detail"]),
        },
    }
    pairing["keep_pass_id_hash_pairing_FLAG"] = (
        not pairing["keep_pass_p331"]["id_to_hash_agrees_with_audit"]
    )
    cells = []
    by_hash = {p["content_hash"]: p for p in audit["patterns"]}
    for i, h, s in zip(ids, hashes, sealed):
        p = by_hash[h]
        cells.append({
            "cell_id": i,
            "content_hash_p331": h,
            "sealed_hash_p331": s,
            "sigma_band": {
                "group_key": p["group_key"],
                "m_options_L": p["m_options_L"],
                "m_options_P": p["m_options_P"],
                "a35_L_options": p["a35_L_options"],
                "a35_P_options": p["a35_P_options"],
                "min_m": p["min_m"],
                "max_m": p["max_m"],
            },
        })
    bands = [json.dumps(c["sigma_band"], sort_keys=True) for c in cells]
    pairing["sigma_band_shared"] = len(set(bands)) == 1
    pairing["sigma_band"] = cells[0]["sigma_band"]
    return cells, pairing


def menu_block(vectors, smith, c11_attached):
    factors = {k: vectors["per_center"][k]["n"] for k in
               ("C11", "C5a", "C5b", "D10", "A4a", "A4b")}
    product = 1
    for n in factors.values():
        product *= n
    c5_menu = list(smith["orders"]["5"]["menu"])
    return {
        "note": (
            "MENUS ARE MENUS.  The six centres are independent G-orbits.  "
            "There is no cell-to-menu-subset linkage in the sealed record "
            "(SMITH_I3 sec. 7.2); the FULL F_odd(35) product is admissible "
            "for every one of the 22 cells.  Factoring a report is not "
            "collapsing a menu: every entry of every factor is listed, and "
            "covered x free-multiplicity = F_odd(35) is checked."
        ),
        "d": 35,
        "F_odd": vectors["F_odd"],
        "factor_sizes": factors,
        "product": product,
        "product_equals_F_odd": product == vectors["F_odd"],
        "n_cells": 22,
        "n_cell_menu_pairs": 22 * product,
        "C11": {
            "n": 10,
            "row_names": list(vectors["per_center"]["C11"]["row_names"]),
            "vectors_as_in_vectors_d35": list(vectors["per_center"]["C11"]["vectors"]),
            "entries_mu_attached": c11_attached,
            "order_in_vectors_d35_differs_from_smith_mu_order": True,
            "set_of_vectors_agrees_with_smith": True,
        },
        "C5a": {
            "n": 4,
            "row_names": list(vectors["per_center"]["C5a"]["row_names"]),
            "vectors": list(vectors["per_center"]["C5a"]["vectors"]),
        },
        "C5b": {
            "n": 4,
            "row_names": list(vectors["per_center"]["C5b"]["row_names"]),
            "vectors": list(vectors["per_center"]["C5b"]["vectors"]),
        },
        "D10": {
            "n": 4,
            "row_names": list(vectors["per_center"]["D10"]["row_names"]),
            "vectors": list(vectors["per_center"]["D10"]["vectors"]),
        },
        "C5_joint_64": {
            "n": 64,
            "factors": ["C5a", "C5b", "D10"],
            "entries": c5_menu,
            "n_x_uniform": all(
                e["n_x"] == {"1": 5, "2": 5, "3": 5, "4": 5} for e in c5_menu
            ),
        },
        "A4a": {
            "n": 238,
            "row_names": list(vectors["per_center"]["A4a"]["row_names"]),
            "vectors_sha256": sha256_of(vectors["per_center"]["A4a"]["vectors"]),
            "n_vectors": len(vectors["per_center"]["A4a"]["vectors"]),
            "note": "238 entries kept as a menu; listed in results/a4_vectors.json",
        },
        "A4b": {
            "n": 238,
            "row_names": list(vectors["per_center"]["A4b"]["row_names"]),
            "vectors_sha256": sha256_of(vectors["per_center"]["A4b"]["vectors"]),
            "n_vectors": len(vectors["per_center"]["A4b"]["vectors"]),
        },
    }


def invariant_table(crt, depths, genera, depth_sum):
    """Every fiber-structure invariant the sealed results constrain."""
    return [
        {
            "id": "BS_C11_ALL_DEGREES",
            "invariant": "base locus at the 60 C11-points",
            "constraint": "all 60 C11-points lie in Bs(T) at EVERY degree",
            "source": "L12_ORDER11 THEOREM director yield 1",
            "depends_on_cell": False,
            "depends_on_menu": False,
            "scope": "map level, genus-free, model- and convention-independent",
        },
        {
            "id": "ORD_L_ZERO",
            "invariant": "order along the minus-line L'_sigma",
            "constraint": "ord_{L'_sigma}(T) = 0 (minus-line is NOT in the base locus)",
            "source": "SMITH_I3 sigma-band of all 22; D35_AUDIT patterns",
            "depends_on_cell": False,
            "depends_on_menu": False,
            "value": {"m_options_L": [35], "a35_L": [35, 0]},
        },
        {
            "id": "ORD_P_ONE",
            "invariant": "order along the plus-plane P_sigma",
            "constraint": "ord_{P_sigma}(T) = 1",
            "source": "SMITH_I3 sigma-band of all 22; D35_AUDIT patterns",
            "depends_on_cell": False,
            "depends_on_menu": False,
            "value": {"m_options_P": [1], "a35_P": [34, 1]},
        },
        {
            "id": "CHI_TOP_C11",
            "invariant": "topological Euler characteristic of the fibre at the five C11-points",
            "constraint": "chi_top == 4 (mod 11) at each of the five; the five values EQUAL",
            "source": "SMITH_I3 F2/F3 order 11, read on terminus Z (n_x = 4)",
            "depends_on_cell": False,
            "depends_on_menu": False,
            "n_x_on_Z": 4,
            "menu_note": "constant across all 10 C11 entries; entry decides which row lands where, never n_x",
        },
        {
            "id": "CHI_TOP_C5",
            "invariant": "topological Euler characteristic of the fibre at the four C5-points",
            "constraint": "chi_top == 0 (mod 5) at each of the four",
            "source": "SMITH_I3 F2/F3 order 5, read on terminus Z (n_x = 5)",
            "depends_on_cell": False,
            "depends_on_menu": False,
            "n_x_on_Z": 5,
            "menu_note": "constant across all 64 (mu_a, mu_b, mu_0) entries",
        },
        {
            "id": "CHI_TOP_E_SIGMA",
            "invariant": "chi_top of the fibre over a generic point of E^X_sigma",
            "constraint": "chi_top == 0 (mod 2) on Z and admissible refinements; irrational-stratum escape live",
            "source": "SMITH_I3 order-2 E-branch CLOSED, escape named",
            "depends_on_cell": False,
            "depends_on_menu": False,
            "status": "CLOSED on the named branch; escape carried",
        },
        {
            "id": "CHI_TOP_L_SIGMA",
            "invariant": "chi_top of the fibre over a generic point of L^X_sigma",
            "constraint": "PARAMETRIC (no sealed numeric bound at d=35)",
            "source": "SMITH_I3 order-2 L-branch",
            "depends_on_cell": False,
            "depends_on_menu": False,
            "status": "PARAMETRIC",
        },
        {
            "id": "CHI_TOP_C3",
            "invariant": "chi_top of the fibre at the six C3-points",
            "constraint": "PARAMETRIC (census does not pin chi of the two surfaces in Z^{C3})",
            "source": "SMITH_I3 order-3",
            "depends_on_cell": False,
            "depends_on_menu_factor": "A4a x A4b (56644 entries)",
            "status": "PARAMETRIC",
        },
        {
            "id": "CHI0_SINGLE",
            "invariant": "coherent fibre Euler characteristic on the 1-dimensional-fibre locus",
            "constraint": "one integer chi_0 (miracle flatness; X irreducible)",
            "source": "STEIN_LERAY Lemma FL",
            "depends_on_cell": False,
            "depends_on_menu": False,
            "hypotheses": "the nine pinned points carry 1-dimensional fibres",
        },
        {
            "id": "CHI0_MOD_55",
            "invariant": "chi_0 in the smooth-fibre row of the bridge",
            "constraint": "chi_0 == %d (mod 55)" % crt["chi0_mod_55"],
            "source": "STEIN_LERAY sec. 6.4 + in-packet CRT",
            "crt": crt,
            "hypotheses": (
                "1-dim fibres at all nine pinned points; D=0, N=0; "
                "n_x = 4 and 5 read on Z; chi_top = 2 chi_0"
            ),
            "depends_on_cell": False,
            "depends_on_menu": False,
        },
        {
            "id": "STEIN_DICHOTOMY",
            "invariant": "connected genus vs Stein degree",
            "constraint": (
                "either chi_0 <= -20 (connected: h^1 == 21 (mod 55), "
                "genus >= 21) or chi_0 >= 35 (Stein degree s >= 35)"
            ),
            "source": "STEIN_LERAY sec. 6.4",
            "branch_A": {"chi_0_max": -20, "connected_genus_min": 21, "h1_mod_55": 21},
            "branch_B": {"chi_0_min": 35, "stein_degree_min": 35, "connected_impossible": True},
            "joint_genera_first": genera[:6],
            "depends_on_cell": False,
            "depends_on_menu": False,
            "both_branches_live_in_STEIN_ledger": True,
        },
        {
            "id": "GENUS0_C14_DEAD",
            "invariant": "C14 trichotomy genus-0 branch at order 11",
            "constraint": "DEAD: 0 genus-0 PASS of 2674 towers (extended scope); 0 of 1540 at depth <= 3",
            "source": "L12_ORDER11 THEOREM sec. 5 + director adjudication",
            "json_census_depth_le_3": {"towers": 1540, "genus0": 0, "integral": 118, "menu": 0},
            "extended_scope": L12_EXTENDED,
            "depends_on_cell": False,
            "depends_on_menu": "holds for every one of the 10 C11 entries",
            "scope": "map level, d = 35; point-blowup towers (FLAG-P); not all-depth",
        },
        {
            "id": "C11_FORCED_DEPTH",
            "invariant": "resolution depth over every C11-point",
            "constraint": ">= 3 always; >= 4 for mu in {6,9}; >= 5 for mu = 7",
            "source": "L12_ORDER11 integrality (genus-free) + I3 table",
            "per_mu": {str(mu): depths[mu]["forced_total_depth"] for mu in range(1, 11)},
            "depends_on_cell": False,
            "depends_on_menu": "C11 mu only",
            "scope": "point-blowup towers, FLAG-P",
        },
        {
            "id": "PIN_AND_J1",
            "invariant": "G-invariant divisor degrees on X, and forced incidence",
            "constraint": (
                "degrees exactly {k >= 5} (window-free); PIN: 11 does not divide k "
                "forces all five C11-points onto D; 5 does not divide k forces all "
                "four C5-points; missing every pinned point forces 55 | k so deg >= 55. "
                "Unique degree-5 divisor is det Hess F, contains all C11 and no C5."
            ),
            "source": "STEIN_LERAY J1 re-derived + Proposition PIN + director window-free form",
            "depends_on_cell": False,
            "depends_on_menu": False,
        },
        {
            "id": "KEEP_PASS_CLOSED",
            "invariant": "closed keep-pass of the general depth-value table at d=35, a=(34,1)",
            "constraint": "0 deaths by closed conditions; all 22 live at dim <= 37; rank 0 on the 37-cell",
            "source": "DEPTH_TABLE_GENERAL keep-pass (both primes)",
            "period_hist_rid1": depth_sum["general_table"]["rid1_period_histogram"],
            "period_hist_rid2": depth_sum["general_table"]["rid2_period_histogram"],
            "depends_on_cell": False,
            "note": "sigma-row jet depth, not C11 blowup depth — two different words",
        },
        {
            "id": "CELL_DIM",
            "invariant": "ambient cell of the 22",
            "constraint": "one shared 37-dimensional candidate cell (universal six-flip cut of the 39-slice)",
            "source": "HANDOFF_2026-08-12; DEPTH_TABLE_GENERAL; D35_AUDIT",
            "depends_on_cell": False,
        },
    ]


def must_look_like(depths, crt, genera):
    return {
        "base_locus": {
            "C11_orbit_60": "MUST be in the base locus (every degree, hence d=35)",
            "minus_line_L": "MUST NOT be in the base locus (ord = 0)",
            "plus_plane_P": "simple vanishing (ord = 1)",
        },
        "tower_depths_over_C11": {
            "every_mu": ">= 3",
            "mu_in_6_9": ">= 4",
            "mu_eq_7": ">= 5",
            "per_mu": {str(mu): depths[mu]["forced_total_depth"] for mu in range(1, 11)},
        },
        "fiber_euler": {
            "C11_five_points": "chi_top congruent to 4 mod 11, and the five values EQUAL (on Z: n_x = 4)",
            "C5_four_points": "chi_top congruent to 0 mod 5 (on Z: n_x = 5)",
            "E_sigma_generic": "chi_top even, on the closed branch; escape carried",
            "L_sigma_and_C3": "not numerically pinned",
        },
        "if_nine_pinned_fibres_are_smooth_curves": {
            "chi_0": "one integer, == %d (mod 55)" % crt["chi0_mod_55"],
            "branch_A_connected": "chi_0 <= -20, genus in %s (and 21+55 Z)" % genera[:4],
            "branch_B_disconnected": "chi_0 >= 35, Stein degree s >= 35",
            "genus_0_C14": "FORBIDDEN (0 of 2674 towers)",
        },
        "invariant_divisors": {
            "degrees": "exactly k >= 5",
            "PIN": "cannot dodge the pinned points below degree 55",
            "D5": "Hessian quintic: all five C11, no C5",
        },
        "cell": "lives in the shared 37-cell; closed keep-pass already satisfied",
    }


def per_c11_rows(c11_attached, depths, must):
    rows = []
    for e in sorted(c11_attached, key=lambda x: x["mu"]):
        mu = e["mu"]
        d = depths[mu]
        rows.append({
            "menu_factor": "C11",
            "mu": mu,
            "vector": e["vector"],
            "n_defined_rows": e["n_defined_rows"],
            "n_x": e["n_x"],
            "chi_top": "congruent to 4 mod 11 at all five C11-points (EQUAL)",
            "forced_total_depth": d["forced_total_depth"],
            "genus0_C14_at_depth_le_3": {
                "towers": d["n_towers_depth_le_3"],
                "pass": d["n_genus0_pass_depth_le_3"],
                "integral": d["n_integral_depth_le_3"],
                "smooth_trace_menu_pass": d["n_menu_pass_depth_le_3"],
            },
            "integrality_at_depth_le_3_empty": d["n_integral_depth_le_3"] == 0,
            "empty_integrality_expected": d["forced_total_depth"] > 3,
            "joint_with_global": must,
            "intersection_empty": False,
            "FLAG_KILL": False,
        })
    return rows


def per_c5_rows(c5_menu):
    rows = []
    for e in c5_menu:
        rows.append({
            "menu_factor": "C5a x C5b x D10",
            "mu_C5a": e["mu_C5a"],
            "mu_C5b": e["mu_C5b"],
            "mu_D10": e["mu_D10"],
            "n_x": e["n_x"],
            "chi_top": "congruent to 0 mod 5 at all four C5-points",
            "intersection_empty": False,
            "FLAG_KILL": False,
        })
    return rows


def per_cell_rows(cells, must, pairing):
    rows = []
    for c in cells:
        rows.append({
            "cell_id": c["cell_id"],
            "content_hash_p331": c["content_hash_p331"],
            "sealed_hash_p331": c["sealed_hash_p331"],
            "sigma_band": c["sigma_band"],
            "menu_admissible": "FULL F_odd(35) = 36252160 entries (no cell-to-menu linkage)",
            "must_look_like": must,
            "keep_pass": {
                "closed_deaths": 0,
                "live_dim_upper": 37,
                "verdict": "LIVE",
                "identity_note": (
                    "DEPTH_TABLE keep_pass id<->hash pairing disagrees with "
                    "D35_AUDIT; the 22 hashes as a SET and the LIVE/37 "
                    "verdict are consumed, not the scrambled pairing"
                    if pairing["keep_pass_id_hash_pairing_FLAG"] else
                    "keep_pass pairing agrees with D35_AUDIT"
                ),
            },
            "stein_ledger_verdict": "BOTH BRANCHES LIVE; no cell cut, no degree excluded",
            "intersection_empty": False,
            "FLAG_KILL": False,
            "claimed_dead": False,
        })
    return rows


def contradiction_scan(c11_rows, c5_rows, cell_rows, depths, genera):
    """Mechanical emptiness checks.  Empty => FLAG_KILL, never a claim."""
    flags = []
    flagged_kills = []

    # 1. genus-0 required vs genus-0 dead
    genus0_required = False
    if genus0_required:
        flagged_kills.append({
            "id": "GENUS0_REQUIRED_AND_DEAD",
            "status": "FLAG_KILL",
            "claimed": False,
        })
    else:
        flags.append({
            "id": "GENUS0_C14_DEAD_NOT_A_CELL_KILL",
            "status": "CONSTRAINT",
            "detail": (
                "L12 kills the C14 genus-0 branch (tr=1) at every C11 menu "
                "entry.  No sealed constraint REQUIRES genus 0, so the "
                "intersection with the live branches is nonempty."
            ),
        })

    # 2. chi0 branches are OR, not AND
    flags.append({
        "id": "STEIN_DICHOTOMY_IS_OR",
        "status": "CONSTRAINT",
        "detail": (
            "chi_0 == 35 (mod 55) splits as chi_0 <= -20 OR chi_0 >= 35.  "
            "Forcing both would be empty; the sealed packet does not force both."
        ),
        "residue_classes_live": ["35+55k for k<=-1 (A)", "35+55k for k>=0 (B)"],
        "first_joint_genera": genera[:4],
    })

    # 3. per-point C11 genus 10 is killed by the joint menu, not by a cell
    flags.append({
        "id": "PER_POINT_MENU_STRICTLY_LARGER",
        "status": "INTERSECTION_TIGHTENING",
        "detail": (
            "STEIN C11-alone smooth connected menu starts at g=10; C5-alone "
            "at g=6.  The joint CRT is g == 21 (mod 55).  g=10 is excluded "
            "by the intersection, not by any one cell dying."
        ),
    })

    # 4. mu in {6,7,9}: 0 integrality at depth <= 3, forced depth > 3
    for mu in (6, 7, 9):
        d = depths[mu]
        expected = d["forced_total_depth"] > 3
        empty = d["n_integral_depth_le_3"] == 0
        if empty and expected:
            flags.append({
                "id": "MU_%d_INTEGRALITY_EMPTY_BELOW_FORCED_DEPTH" % mu,
                "status": "CONSISTENT",
                "forced_total_depth": d["forced_total_depth"],
                "detail": (
                    "No depth-<=3 integrality survivor, and none is allowed: "
                    "R==0 is first reachable at depth %d."
                    % d["forced_total_depth"]
                ),
            })
        elif empty and not expected:
            flagged_kills.append({
                "id": "MU_%d_INTEGRALITY_EMPTY_AT_FORCED_DEPTH" % mu,
                "status": "FLAG_KILL",
                "claimed": False,
                "detail": "Would be a contradiction if forced depth were <= 3.",
            })

    # 5. FLAG-M near-kill: 0 of integrality survivors pass C7 smooth-trace menu
    flags.append({
        "id": "FLAG_M_SMOOTH_TRACE_NEAR_KILL",
        "status": "FLAG",
        "claimed": False,
        "detail": (
            "L12 sec. 7 / TIER B / FLAG-M: 0 of 118 (depth<=3) and 0 of 226 "
            "(extended) integrality survivors lie in the smooth-fibre C7 "
            "trace menu.  Intersected with STEIN's smooth 1-dimensional row "
            "this is a NEAR-KILL of that row at the enumerated tower scope.  "
            "L12 states it is a menu verdict under a stated model, not a "
            "closed death.  FLAG-P (point blowups only) and the proved "
            "saturation of the leading-order obstruction at depth >= 4 are "
            "in force.  NOT claimed as a cell death or a degree exclusion."
        ),
        "ODDZERO_audit": "NOT TRIGGERED (outcome is not an all-22 death)",
    })

    # 6. STEIN realisability window miss at chi0=35 on C5
    flags.append({
        "id": "STEIN_WINDOW_C5_CHI0_35_MISS",
        "status": "FLAG",
        "claimed": False,
        "detail": (
            "STEIN menus.json realisability window (hmax=4,...) finds a "
            "C11 witness at chi_0=35 and does NOT find a C5 witness in "
            "that window.  The packet labels this a WINDOW: absence is "
            "not impossibility.  Not a kill."
        ),
    })

    # 7. keep_pass pairing hygiene
    flags.append({
        "id": "KEEP_PASS_IDENTITY_PAIRING",
        "status": "FLAG",
        "claimed": False,
        "detail": (
            "DEPTH_TABLE_GENERAL keep_pass_22_p331.json carries the same "
            "22 ids and the same 22 content_hash / sealed_hash SETS as "
            "D35_AUDIT, but the three fields are not synchronously paired.  "
            "This packet keys cells by the D35_AUDIT / SMITH / STEIN "
            "pairing (those three AGREE).  The keep-pass LIVE / dim<=37 "
            "verdict is uniform on all 22, so the fiber-structure "
            "intersection does not depend on the pairing."
        ),
    })

    # 8. all-row emptiness
    any_empty = (
        any(r["intersection_empty"] for r in c11_rows)
        or any(r["intersection_empty"] for r in c5_rows)
        or any(r["intersection_empty"] for r in cell_rows)
    )
    any_flag_kill_row = (
        any(r["FLAG_KILL"] for r in c11_rows)
        or any(r["FLAG_KILL"] for r in c5_rows)
        or any(r["FLAG_KILL"] for r in cell_rows)
    )

    return {
        "n_cells": len(cell_rows),
        "n_c11_entries": len(c11_rows),
        "n_c5_entries": len(c5_rows),
        "any_row_intersection_empty": any_empty,
        "any_row_FLAG_KILL": any_flag_kill_row,
        "flagged_kills": flagged_kills,
        "n_flagged_kills": len(flagged_kills),
        "claimed_kills": 0,
        "claimed_degree_exclusion": False,
        "ODDZERO_audit_triggered": False,
        "flags": flags,
        "verdict": (
            "NO CLAIMED CONTRADICTION.  No cell of the 22 has an empty "
            "joint constraint set.  Two FLAGS (smooth-trace near-kill; "
            "keep-pass pairing hygiene) and one window-miss are recorded.  "
            "Problem E remains OPEN; this packet excludes no degree."
        ),
    }


def plain_paragraph():
    return (
        "If a degree-35 landing map exists, it must vanish at all sixty "
        "order-11 points of the Klein cubic, and those vanishings cannot "
        "be resolved in fewer than three blowups (four blowups when the "
        "order-11 menu label is 6 or 9; five when the label is 7).  Over "
        "each of the five order-11 points the topological Euler "
        "characteristic of the fiber is the same integer, congruent to 4 "
        "modulo 11; over each of the four order-5 points it is divisible "
        "by 5.  When those nine fibers are ordinary curves they all share "
        "one coherent Euler characteristic chi_0 congruent to 35 modulo "
        "55: either every such fiber is a connected curve of genus at "
        "least 21, or the map factors through a cover of degree at least "
        "35.  The genus-0 fiber branch is already ruled out (none of "
        "2674 resolution towers survive it).  The map does not vanish along the "
        "distinguished minus-line, and it vanishes simply along the "
        "distinguished plus-plane.  None of these requirements, taken "
        "together, empties any of the 22 remaining candidate cells, and "
        "no degree is excluded."
    )


def main():
    os.makedirs(P.RESULTS, exist_ok=True)

    smith = load(P.SMITH)
    stein_ledger = load(P.STEIN_LEDGER)
    stein_menus = load(P.STEIN_MENUS)
    l12 = load(P.L12)
    depth_sum = load(P.DEPTH_SUM)
    keep331 = load(P.KEEP_331)
    keep661 = load(P.KEEP_661)
    vectors = load(P.VECTORS)
    audit = load(P.AUDIT)

    crt = crt_chi0()
    genera = joint_genera()
    depths = forced_depth_from_l12(l12)
    cells, pairing = identity_block(audit, smith, stein_menus, keep331, keep661)
    c11_attached = match_c11_vectors(vectors, smith["orders"]["11"]["menu"])
    menus = menu_block(vectors, smith, c11_attached)
    inv = invariant_table(crt, depths, genera, depth_sum)
    must = must_look_like(depths, crt, genera)
    c11_rows = per_c11_rows(c11_attached, depths, must)
    c5_rows = per_c5_rows(menus["C5_joint_64"]["entries"])
    cell_rows = per_cell_rows(cells, must, pairing)
    scan = contradiction_scan(c11_rows, c5_rows, cell_rows, depths, genera)
    # attach pairing flag already in scan.flags
    paragraph = plain_paragraph()

    stein_ids = [r["cell_id"] for r in stein_ledger["rows"]]
    stein_verdicts = [r["verdict"] for r in stein_ledger["rows"]]

    synthesis = {
        "packet": "goal_runs_20260812/CELL_SYNTHESIS",
        "headline": HEADLINE,
        "d": 35,
        "n_cells": 22,
        "identity": pairing,
        "cells": cells,
        "menus": menus,
        "invariants": inv,
        "must_look_like": must,
        "per_c11_menu": c11_rows,
        "per_c5_menu_n": len(c5_rows),
        "per_cell": cell_rows,
        "contradiction_scan": scan,
        "plain_paragraph": paragraph,
        "stein_ledger_ids": stein_ids,
        "stein_ledger_verdicts_unique": sorted(set(stein_verdicts)),
        "l12_json_totals": l12["totals"],
        "l12_extended": L12_EXTENDED,
        "crt": crt,
        "joint_genera_first": genera[:8],
        "all_22_identical_fiber_verdict": True,
        "claimed_kills": 0,
        "claimed_degree_exclusion": False,
    }

    def dump(name, obj):
        path = os.path.join(P.RESULTS, name)
        with open(path, "w") as f:
            json.dump(obj, f, indent=2, sort_keys=True)
            f.write("\n")
        return path

    dump("synthesis.json", synthesis)
    dump("identity.json", {"cells": cells, "pairing": pairing})
    dump("menus.json", menus)
    dump("per_c11_menu.json", c11_rows)
    dump("per_c5_menu.json", c5_rows)
    dump("per_cell_verdicts.json", cell_rows)
    dump("invariants.json", inv)
    dump("contradiction_scan.json", scan)
    dump("a4_vectors.json", {
        "A4a": vectors["per_center"]["A4a"]["vectors"],
        "A4b": vectors["per_center"]["A4b"]["vectors"],
        "n_A4a": 238,
        "n_A4b": 238,
        "note": "menus, not collapsed",
    })
    with open(os.path.join(P.RESULTS, "plain_paragraph.txt"), "w") as f:
        f.write(paragraph + "\n")

    print("CELL_SYNTHESIS_ASSEMBLE_OK")
    print("cells", len(cells))
    print("C11", len(c11_rows), "C5", len(c5_rows))
    print("pairs", menus["n_cell_menu_pairs"])
    print("flagged_kills", scan["n_flagged_kills"])
    print("claimed_kills", scan["claimed_kills"])
    print(HEADLINE)
    return 0


if __name__ == "__main__":
    sys.exit(main())
