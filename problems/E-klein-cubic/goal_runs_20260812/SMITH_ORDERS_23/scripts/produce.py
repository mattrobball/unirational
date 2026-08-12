#!/usr/bin/env python3
"""SMITH_ORDERS_23 producer.

Reconstruct the two SMITH_I3-parametric branches from the sealed record,
then test whether STEIN_LERAY (chi_0 == 35 mod 55 on U) and L12_ORDER11
(all 60 C11-points base, forced depths, genus-0 dead) pin them.

Exact integer arithmetic only.  python3 standard library only.
Writes results/audit.json.  Marker: SMITH_ORDERS_23_PRODUCE_OK.
"""
from __future__ import annotations

import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import paths as P  # noqa: E402


def read(path):
    with open(path) as f:
        return f.read()


def loadj(path):
    with open(path) as f:
        return json.load(f)


# ------------------------------------------------------------------ CRT
def chi0_family(k):
    """The sealed smooth-row residue: chi_0 = 35 + 55 k."""
    return 35 + 55 * k


def two_chi0_mod(k, m):
    return (2 * chi0_family(k)) % m


def crt_gap(window=range(-12, 13)):
    """Does chi_0 == 35 (mod 55) determine 2*chi_0 mod 2 or mod 3?"""
    vals2 = sorted({two_chi0_mod(k, 2) for k in window})
    vals3 = sorted({two_chi0_mod(k, 3) for k in window})
    branch_A = [k for k in window if chi0_family(k) <= -20]   # genus >= 21
    branch_B = [k for k in window if chi0_family(k) >= 35]    # Stein s >= 35
    A3 = sorted({two_chi0_mod(k, 3) for k in branch_A})
    B3 = sorted({two_chi0_mod(k, 3) for k in branch_B})
    rows = []
    for k in window:
        c0 = chi0_family(k)
        rows.append({
            "k": k,
            "chi_0": c0,
            "two_chi_0": 2 * c0,
            "two_chi_0_mod_2": (2 * c0) % 2,
            "two_chi_0_mod_3": (2 * c0) % 3,
            "branch": ("A" if c0 <= -20 else ("B" if c0 >= 35 else "gap")),
        })
    # 2 is invertible mod 3, so pinning 2*chi_0 mod 3 is equivalent to
    # pinning chi_0 mod 3.  35 + 55k == 2 + k (mod 3); k free => all residues.
    chi0_mod3 = sorted({chi0_family(k) % 3 for k in window})
    return {
        "formula": "chi_0 = 35 + 55*k  (STEIN_LERAY sec.6.4, smooth row, n_x=4,5 on Z)",
        "window": [min(window), max(window)],
        "two_chi0_mod_2_values": vals2,
        "two_chi0_mod_3_values": vals3,
        "branch_A_two_chi0_mod_3": A3,
        "branch_B_two_chi0_mod_3": B3,
        "chi0_mod_3_values": chi0_mod3,
        "pins_mod_2": vals2 == [0],
        "pins_mod_3": vals3 == [vals3[0]] if vals3 else False,
        "pins_mod_3_on_branch_A": A3 == [A3[0]] if A3 else False,
        "pins_mod_3_on_branch_B": B3 == [B3[0]] if B3 else False,
        "need_modulus_to_pin_mod_3": 55 * 3,
        "rows": rows,
        "verdict": (
            "2*chi_0 is always even, so Smith at p=2 is tautological on U "
            "in the smooth row.  2*chi_0 (mod 3) takes all three residues "
            "on branch A and on branch B, so chi_0 == 35 (mod 55) does not "
            "determine the order-3 Smith residue."
        ),
    }


# ------------------------------------------------------- sealed reconstruct
def reconstruct_smith():
    smith = loadj(os.path.join(P.SMITH_I3, "results", "f2f3_congruences.json"))
    thm = read(os.path.join(P.SMITH_I3, "THEOREM.md"))
    ref = read(os.path.join(P.SMITH_I3, "REFEREE_REPORT.md"))
    o2 = smith["orders"]["2"]
    o3 = smith["orders"]["3"]
    o11 = smith["orders"]["11"]
    o5 = smith["orders"]["5"]

    widened = (
        "chi(q^{-1}(x)) == chi(F_1) + chi(F_2) + n_3 + sum_j chi(F_j) (mod 2)"
    )
    # director correction is in THEOREM.md, not in the pre-correction JSON
    has_widen = (
        "unforced" in thm.lower()
        and "Σ_j χ(F_j)" in thm or "Sigma_j" in thm or "+ Σ" in thm
        or "unforced dominating" in thm
        or "widened" in thm.lower()
    )
    has_ref_s4 = "unforced" in ref.lower() and "CORRECTED" in ref

    return {
        "sealed_order11": {
            "n_x_on_Z": o11["n_x_on_Z"],
            "residue_mod_11": o11["n_x_on_Z"] % 11,
            "five_equal": True,  # director correction; SMITH_I3 THEOREM.md
            "F3": "5*4 = 20 = chi(Z^{C11})",
        },
        "sealed_order5": {
            "n_x_on_Z": o5["n_x"],
            "n_x_uniform": (
                o5["n_x"] == 5
                or (isinstance(o5["n_x"], dict)
                    and set(o5["n_x"].values()) == {5})
            ),
            "residue_mod_5": 0,
            "F3": "4*5 = 20 = chi(Z^{C5})",
        },
        "branch_E": o2["branch_E"],
        "branch_L_as_computed": o2["branch_L"],
        "branch_L_widened_display": widened,
        "branch_L_widened_in_theorem": has_widen,
        "referee_S4_widened": has_ref_s4,
        "order2_census": o2["source_census_Z_sigma_by_dim"],
        "order2_receiver": o2["receiver_strata"],
        "order2_cell_reading": o2["cell_reading"],
        "order3_status": o3["status"],
        "order3_blocker": o3["blocker"],
        "order3_census": o3["source_census_Z_C3_by_dim"],
        "order3_menu_size": o3["menu_size"],
        "order3_receiver_chi": o3["receiver"]["chi"],
        "chi_Z_C3_shape": "94 + chi(S_1) + chi(S_2),  chi(S_i) >= 3",
        "n_cells": smith["n_cells"],
        "F_odd_35": smith["menu"]["F_odd_35"],
    }


def consume_stein():
    blob = loadj(os.path.join(P.STEIN, "results", "menus.json"))
    menus = blob["menus"]
    joint = menus["JOINT_flat_smooth"]
    thm = read(os.path.join(P.STEIN, "THEOREM.md"))
    pin = loadj(os.path.join(P.STEIN, "results", "pinned_points.json"))
    q_at_c11 = pin["quintic_Q_at_C11_points"]
    c11_zero = all(v in (0, "0", [0, 0]) or v == 0 or str(v) in ("0", "0+0")
                   for v in (q_at_c11.values() if isinstance(q_at_c11, dict)
                             else q_at_c11))
    return {
        "chi_0_mod_55": joint["chi_0_mod_55"],
        "hypotheses": joint["hypotheses"],
        "branch_A": joint["branch_A"]["condition"],
        "branch_B": joint["branch_B"]["condition"],
        "general_form": joint["general_form"],
        "lemma_FL_in_menus": joint["lemma"],
        "C11_n_x_on_Z": menus["C11"]["smith_input"]["n_x_on_Z"],
        "C5_n_x_on_Z": menus["C5"]["smith_input"]["n_x_on_Z"],
        "C11_dim2_note": menus["C11"]["CONN_dim2"]["note"],
        "C5_dim2_note": menus["C5"]["CONN_dim2"]["note"],
        "dim3_flagged": menus["C11"]["dim3_fibre"]["status"] == "FLAGGED",
        "J1_degrees_phrase": "{k >= 5}" in thm or "{k ≥ 5}" in thm,
        "PIN_in_theorem": "Proposition PIN" in thm,
        "PIN_min_degree_missing_all": pin["PIN_min_degree_missing_all_pinned_points"],
        "quintic_misses_C5": pin["quintic_vanishes_at_C5_points"] is False,
        "quintic_C11_values": q_at_c11,
        "quintic_vanishes_at_C11": c11_zero,
    }


def consume_l12():
    thm = read(os.path.join(P.L12, "THEOREM.md"))
    # sealed yields are in the director-adjudication block
    thm_flat = " ".join(thm.split())
    all60 = (
        "all 60 C11-points lie in the base locus" in thm_flat
        or "all 60 C11-points lie in Bs(T)" in thm_flat
    )
    g0 = "0 of 2674" in thm
    depths = (
        "≥ 3" in thm and "{6, 9}" in thm and "μ₁ = 7" in thm
    ) or (
        ">= 3" in thm
    )
    orders_untouched = "Orders 5, 3, 2, 6 are untouched" in thm
    return {
        "all_60_base_points": all60,
        "genus0_dead_extended": g0,
        "forced_depths_mentioned": depths,
        "orders_2_3_untouched_in_L12": orders_untouched,
        "n_x_model_caveat_in_smith_feed": "n_x = 4" in thm and "χ_top" in thm,
    }


def locus_obstructions():
    """L_sigma is swept by two dim-3 rows => not in U.
    C3-surfaces contract to points => those C3-points not in U.
    """
    s1 = read(os.path.join(P.STAGE1, "THEOREM.md"))
    # Theorem 3: two dim-3 divisors and one dim-1 line, all onto L_sigma.
    has_thm3 = "### Theorem 3 (three forced sweeps" in s1
    dP = "D_{P_σ}" in s1 and "dim 3, 55 components" in s1
    dL = "D_{L⁻_σ}" in s1 and "dim 3, 55 components" in s1
    line = "dim 1, 55 components" in s1 and "E_{pt_{D12}}" in s1
    onto = "map **onto** `L_σ`" in s1 or "map **onto** `L_sigma`" in s1

    census = read(os.path.join(P.TERMINUS, "results", "t2_strata.txt"))
    mC2 = re.search(
        r"H = C2\s+: components of Z\^H by dim \{0: (\d+), 1: (\d+), 2: (\d+), 3: (\d+)\}",
        census,
    )
    mC3 = re.search(
        r"H = C3\s+: components of Z\^H by dim \{0: (\d+), 1: (\d+), 2: (\d+)\}",
        census,
    )
    c2 = {0: int(mC2.group(1)), 1: int(mC2.group(2)),
          2: int(mC2.group(3)), 3: int(mC2.group(4))} if mC2 else None
    c3 = {0: int(mC3.group(1)), 1: int(mC3.group(2)),
          2: int(mC3.group(3))} if mC3 else None

    # C3 dim-2 row is the C3line surface, model P^1 x P^1 (birational class;
    # TERMINUS Thm 3: "up to the later blowups it undergoes").
    c3_surface_row = (
        "C3   2    110        2         C6      C2  C3line" in census
        or "C3line                             1 [1/3]* [1/3] 1   |  P^1 x P^1" in census
    )
    terminus_thm = read(os.path.join(P.TERMINUS, "THEOREM.md"))
    blowup_not_iso = (
        "smooth blowup of" in terminus_thm
        and "up to the later blowups" in terminus_thm
    )

    # dimension arithmetic
    # A 3-fold mapping onto a curve has generic fibre dimension 2.
    # A surface contracted to a point has fibre dimension 2.
    L_in_U = False  # forced by the two dim-3 sweeps
    reason_L = (
        "STAGE1 Thm 3: D_{P_sigma} and D_{L'_sigma} are dim-3 and map onto "
        "L_sigma (dim 1), so generic fibre dimension is 2.  U is the locus "
        "of 1-dimensional fibres.  Hence L_sigma cap U = empty."
    )
    C3_surfaces_in_U = False
    reason_C3 = (
        "X^{C3} is finite (6 points).  Every component of Z^{C3} is "
        "contracted to one of those points.  The two dim-2 components "
        "therefore give fibre dimension >= 2 at their receiver point(s).  "
        "Those 1 or 2 of the 6 C3-points lie outside U."
    )
    return {
        "stage1_thm3_present": has_thm3 and dP and dL and line and onto,
        "thm3_two_dim3_one_dim1": True,
        "census_C2": c2,
        "census_C3": c3,
        "c3_surface_row_is_C3line": c3_surface_row,
        "c3_model_is_blowup_of_product_not_iso": blowup_not_iso,
        "L_sigma_in_U": L_in_U,
        "reason_L_not_in_U": reason_L,
        "C3_surface_receivers_in_U": C3_surfaces_in_U,
        "reason_C3_surfaces_not_in_U": reason_C3,
        "generic_fibre_dim_over_L": 2,
        "generic_fibre_dim_over_C3_surface_receivers": 2,
        "chi0_binds_on_L": False,
        "chi0_binds_on_C3_surface_receivers": False,
    }


def remaining_unknowns():
    return [
        {
            "id": "L_chi",
            "what": "chi(F_1), chi(F_2), n_3, and chi(F_j) for unforced "
                    "sigma-fixed rows dominating L^X_sigma",
            "scope": "order-2 L-branch, widened display (SMITH_I3 referee S4)",
        },
        {
            "id": "E_escape",
            "what": "whether a sigma-fixed irrational stratum dominates E^X_sigma",
            "scope": "order-2 E-branch escape; Group G forces some irrational "
                     "centre; neither STEIN_LERAY nor L12 shuts this",
        },
        {
            "id": "S_chi",
            "what": "chi(S_1), chi(S_2) and the assignment of the 80 "
                    "Z^{C3}-components to the 6 receiver points",
            "scope": "order-3; chi(Z^{C3}) = 94 + chi(S_1) + chi(S_2), "
                     "chi(S_i) >= 3; census models are blowups of products, "
                     "not isomorphism types",
        },
        {
            "id": "Zsigma_chi",
            "what": "Euler characteristics of the 11 surfaces and 2 threefolds "
                    "of Z^sigma",
            "scope": "order-2 F3; census pins counts by dimension only",
        },
        {
            "id": "U_membership",
            "what": "whether generic points of E^X_sigma, or any C3-point that "
                    "does not receive a surface, lie in U",
            "scope": "chi_0 inheritance is conditional on membership in U",
        },
        {
            "id": "defects",
            "what": "bridge defects D(F) and chi(N_F) on non-smooth fibres",
            "scope": "STEIN_LERAY Lemma BR; sharp numbers are smooth-row only",
        },
        {
            "id": "stein_s",
            "what": "Stein degree s",
            "scope": "carried as a menu variable; branch B requires s >= 35",
        },
        {
            "id": "Delta_C11",
            "what": "refinement delta Delta at C11 (n_x = 4 + Delta/5)",
            "scope": "L12 forces depth >= 3, so the actual model is a "
                     "refinement of Z; the residue chi_0 == 35 (mod 55) "
                     "is Z-scoped",
        },
    ]


def verdict(crt, loc, smith, stein, l12):
    pin_L = False
    pin_3 = False
    reasons = [
        "CRT: chi_0 == 35 (mod 55) does not determine 2*chi_0 (mod 3); "
        "both dichotomy branches hit all three residues.",
        "Locus: STAGE1 Thm 3 puts L^X_sigma in X\\U, so chi_0 does not "
        "bind on the order-2 L-branch.",
        "Locus: the two C3-surfaces put their receiver points in X\\U.",
        "On U itself, 2*chi_0 is even, so Smith at p=2 is tautological "
        "in the smooth row and does not pin chi(F_i) or n_3.",
        "L12's 60 base points are already the STEIN_LERAY pinned points; "
        "forced depths move n_x and therefore the chi_0 residue; "
        "the genus-0 death is at C11 and does not evaluate chi(S_i) "
        "or chi(F_i).  L12 itself says orders 2 and 3 are untouched.",
        "PIN and J1 constrain invariant divisors on X, not the Euler "
        "characteristics of source strata of Z^sigma or Z^{C3}.",
    ]
    return {
        "order2_L_pinned": pin_L,
        "order3_pinned": pin_3,
        "order2_E_still_closed_as_SMITH_I3_left_it": True,
        "order2_E_escape_still_live": True,
        "what_closes": (
            "Nothing of the two SMITH_I3-parametric branches.  "
            "The E-branch remains closed as SMITH_I3 left it "
            "(== 0 mod 2 on Z and on admissible refinements).  "
            "Genus-0 on U is incompatible with chi_0 == 35 (mod 55); "
            "that is already in STEIN_LERAY, not a new pin of order-2/3 "
            "Smith data."
        ),
        "what_stays_parametric": (
            "Order-2 L-branch (widened display) and the whole of order 3, "
            "including F3 at both orders."
        ),
        "reasons": reasons,
        "exclusion_claimed": False,
        "degree_excluded": None,
        "cells_cut": 0,
        "zero_or_all_dead": False,
        "honesty": "FLAGGED-behind-audit only if a zero/all-dead outcome "
                   "appears; none does.  The negative pin is claimed as a "
                   "non-implication, not as an exclusion.",
    }


def main():
    os.makedirs(P.RES, exist_ok=True)
    smith = reconstruct_smith()
    stein = consume_stein()
    l12 = consume_l12()
    crt = crt_gap()
    loc = locus_obstructions()
    unk = remaining_unknowns()
    ver = verdict(crt, loc, smith, stein, l12)
    out = {
        "packet": "goal_runs_20260812/SMITH_ORDERS_23",
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "d": 35,
        "reconstructed": smith,
        "stein_consumed": stein,
        "l12_consumed": l12,
        "crt_gap": {k: v for k, v in crt.items() if k != "rows"},
        "crt_rows_sample": [r for r in crt["rows"] if r["k"] in
                            (-2, -1, 0, 1, 2)],
        "locus": loc,
        "remaining_unknowns": unk,
        "verdict": ver,
    }
    dest = os.path.join(P.RES, "audit.json")
    with open(dest, "w") as f:
        json.dump(out, f, indent=1, sort_keys=True)
        f.write("\n")
    print("wrote", dest)
    print("CRT pins_mod_2 =", crt["pins_mod_2"],
          "pins_mod_3 =", crt["pins_mod_3"],
          "A3 =", crt["branch_A_two_chi0_mod_3"],
          "B3 =", crt["branch_B_two_chi0_mod_3"])
    print("L in U =", loc["L_sigma_in_U"],
          "C3 surfaces in U =", loc["C3_surface_receivers_in_U"])
    print("order2_L_pinned =", ver["order2_L_pinned"],
          "order3_pinned =", ver["order3_pinned"])
    print("SMITH_ORDERS_23_PRODUCE_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
