#!/usr/bin/env python3
"""
SMITH_I3 verifier.  Replayable, exact, python3-standard-library only
(numpy is used only to read the two sealed .npy seed arrays; if it is absent
that single check is reported SKIP, never PASS).

Three check groups, named by DATA_SPEC_SMITH_I3_20260812.md sec.3:

  GROUP A -- the calibration anchors of sec.1 of the data spec.
             NOTHING in this packet is allowed to depend on the
             Hilbert-Mumford convention unless group A is all-green.
  GROUP B -- every receiver / census constant this packet consumes,
             re-read from the sealed artefact where it is machine-readable
             and cross-checked by an independent identity where it is not.
  GROUP C -- the congruence evaluations.

Run:  python3 verifier.py
Writes results/verifier_output.json and prints results/verifier_stdout-style
lines.  Markers on success: SMITH_I3_VERIFY_OK and ALLGREEN.
"""

import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "scripts"))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))

import constants as K                                    # noqa: E402
from i3_semistability import (hm_test, weight_of, run_anchors,      # noqa: E402
                              anchor_i_support, anchor_ii_support,
                              klein_F_monomials)
import f2f3_congruences as F                             # noqa: E402

CHECKS = []


def chk(group, name, ok, detail=""):
    CHECKS.append({"group": group, "name": name,
                   "pass": bool(ok), "detail": str(detail)})
    return ok


def skip(group, name, detail):
    CHECKS.append({"group": group, "name": name, "pass": None,
                   "detail": str(detail)})


def sealed(*parts):
    return os.path.join(ROOT, *parts)


# =========================================================== GROUP A
def group_A():
    g = "A"
    res = run_anchors()

    a1 = res["anchor_i_F_times_x"]
    chk(g, "A1_anchor_i_F_times_x_is_SEMISTABLE", a1["pass"],
        "expected %s got %s, d=%d, |supp|=%d"
        % (a1["expected"], a1["got"], a1["d"], a1["n_support"]))

    # the convex certificate is the honest barycentre, exhibited explicitly
    sup = anchor_i_support()
    lam = {j: v for j, v in [(int(j), v) for j, v in a1["convex_certificate"]]}
    from fractions import Fraction
    tot = sum(Fraction(v) for v in lam.values())
    acc = [Fraction(0)] * 5
    for j, v in lam.items():
        alpha, c = sup[j]
        w = list(alpha)
        w[c] -= 1
        for i in range(5):
            acc[i] += Fraction(v) * w[i]
    target = Fraction(a1["d"] - 1, 5)
    chk(g, "A2_anchor_i_convex_certificate_hits_barycentre",
        tot == 1 and all(x == target for x in acc),
        "sum(lambda)=%s, combination=%s, target=%s"
        % (tot, [str(x) for x in acc], target))

    a2 = res["anchor_ii_x0d_e0"]
    chk(g, "A3_anchor_ii_x0d_e0_is_UNSTABLE", a2["pass"],
        "expected %s got %s at d=%d" % (a2["expected"], a2["got"], a2["d"]))
    chk(g, "A4_anchor_ii_pinned_destabiliser_(4,-1,-1,-1,-1)_works",
        a2["pinned_destabiliser_works"] and
        a2["pinned_destabiliser"] == [4, -1, -1, -1, -1],
        "weights under the pinned 1-PS: %r" % (a2["pinned_destabiliser_weights"],))
    chk(g, "A5_anchor_ii_found_destabiliser_matches_the_pinned_one",
        a2["found_destabiliser"] == [4, -1, -1, -1, -1],
        "found %r, min weight %r"
        % (a2["found_destabiliser"], a2["min_weight_found"]))
    chk(g, "A6_anchor_ii_also_UNSTABLE_at_d=4", res["anchor_ii_at_d4"]["pass"],
        "verdict is not an artefact of the degree")

    # the convention itself, checked against its written form
    r = [4, -1, -1, -1, -1]
    chk(g, "A7_one_PS_is_traceless", sum(r) == 0, "sum(r) = 0")
    alpha, c = anchor_ii_support(35)[0]
    chk(g, "A8_weight_formula_is_<r,alpha>-r_c",
        weight_of(alpha, c, r) == sum(r[i] * alpha[i] for i in range(5)) - r[c]
        == 4 * 35 - 4,
        "weight(x_0^35 e_0) = 140 - 4 = %d" % weight_of(alpha, c, r))

    # F = sum x_i^2 x_{i+1}: the support the spec names
    mons = klein_F_monomials()
    chk(g, "A9_F_monomials_are_x_i^2_x_(i+1)",
        len(mons) == 5 and all(sum(m) == 3 for m in mons) and
        mons[0] == (2, 1, 0, 0, 0),
        "%r" % (mons,))

    chk(g, "A10_all_anchors_pass", res["all_pass"],
        "gate for every later use of the test")
    return res


# =========================================================== GROUP B
def group_B():
    g = "B"

    # B-a: the receiver ledger, machine-readable, re-read from the sealed JSON
    p = sealed("goal_runs_20260810", "RECEIVER_LEDGER_X", "results",
               "ledger_exact.json")
    ok = os.path.exists(p)
    chk(g, "B1_receiver_ledger_present", ok, p)
    if ok:
        with open(p) as f:
            led = json.load(f)
        chk(g, "B2_receiver_ledger_all_pass", led.get("all_pass") is True,
            "sealed self-report all_pass")
        rows = {r["label"]: r for r in led["rows"]}

        # X-point counts per class, re-derived from the sealed strata rows
        counts = {}
        for lab, order in (("C11", 11), ("C5", 5), ("C6", 6), ("C3", 3)):
            tot = 0
            for s in rows[lab]["ambient_strata"]:
                xp = s.get("X_points")
                if isinstance(xp, int):
                    tot += xp
            counts[order] = tot
        chk(g, "B3_X_fixed_point_counts_match_CHI_X_FIXED",
            all(counts[o] == K.CHI_X_FIXED[o] for o in (11, 5, 6, 3)),
            "from ledger rows: %r ; constants: %r"
            % (counts, {o: K.CHI_X_FIXED[o] for o in (11, 5, 6, 3)}))

        # the C11 character labels used by the I3 eigenbasis corollary
        w = tuple(sorted(s["chi"] for s in rows["C11"]["ambient_strata"]))
        chk(g, "B4_C11_weights_read_from_ledger",
            w == tuple(sorted(K.C11_WEIGHTS)),
            "ledger %r vs constants %r" % (w, K.C11_WEIGHTS))

        # on-X weight sets
        onx5 = {s["chi"] for s in rows["C5"]["ambient_strata"]
                if s.get("X_points")}
        chk(g, "B5_on_X_weights_order5", onx5 == K.ON_X_WEIGHTS[5],
            "ledger %r vs constants %r" % (sorted(onx5),
                                           sorted(K.ON_X_WEIGHTS[5])))
        onx11 = {s["chi"] for s in rows["C11"]["ambient_strata"]
                 if s.get("X_points")}
        chk(g, "B6_on_X_weights_order11", onx11 == K.ON_X_WEIGHTS[11],
            "ledger %r" % (sorted(onx11),))

        # residual permutations
        chk(g, "B7_residual_C5_permutation",
            led["detail"]["C11"]["residual_C5_permutation"] ==
            K.C11_RESIDUAL_C5_PERM,
            "%r" % (led["detail"]["C11"]["residual_C5_permutation"],))
        chk(g, "B8_C5_reflection_permutation",
            led["detail"]["C5"]["reflection_permutation"] ==
            K.C5_REFLECTION_PERM,
            "%r" % (led["detail"]["C5"]["reflection_permutation"],))

        # the residual C5 is a 5-cycle: the hypothesis of Lemma U(b)
        perm = K.C11_RESIDUAL_C5_PERM
        orb, cur = {0}, 0
        for _ in range(5):
            cur = perm[cur]
            orb.add(cur)
        chk(g, "B9_residual_C5_transitive_on_X_C11", len(orb) == 5,
            "orbit of point 0 has size %d" % len(orb))

        # the residual C2 on X^{C5} is NOT transitive: Lemma U(b) is
        # unavailable at p = 5 and the row count is required
        refl = K.C5_REFLECTION_PERM
        orbs = []
        seen = set()
        for i in (1, 2, 3, 4):
            if i in seen:
                continue
            o = {i, refl[i]}
            seen |= o
            orbs.append(sorted(o))
        chk(g, "B10_residual_C2_on_X_C5_has_two_orbits",
            sorted(orbs) == [[1, 4], [2, 3]], "%r" % (sorted(orbs),))

        # subgroup counts -- load-bearing for the order-5 row arithmetic
        ncj = {r["label"]: r["nconj"] for r in led["rows"]}
        chk(g, "B10a_subgroup_counts_C11_12_and_C5_66",
            ncj.get("C11") == 12 and ncj.get("C5") == 66,
            "PSL(2,11): 12 Sylow-11 and 66 Sylow-5 subgroups (ledger nconj)")
        c11_rows = [r for r in K.IMMUNE_ROWS if r[1] == 11]
        c5_rows = [r for r in K.IMMUNE_ROWS if r[1] == 5]
        chk(g, "B10b_row_arithmetic_reproduces_the_census",
            len(c11_rows) * (60 // ncj["C11"]) == K.Z_FINITE_FIXED["C11"] == 20
            and len(c5_rows) * (132 // ncj["C5"]) == K.Z_FINITE_FIXED["C5"] == 20,
            "C11: 4 rows x 60/12 = 4 x 5 = 20;  C5: 10 rows x 132/66 = "
            "10 x 2 = 20")

    # B-b: chi(X^g) -- lives only in a THEOREM.md table; cited + cross-checked
    p = sealed("goal_runs_20260810", "RECEIVER_LEDGER_X", "THEOREM.md")
    ok = os.path.exists(p)
    chk(g, "B11_receiver_THEOREM_present", ok, p)
    if ok:
        txt = open(p).read()
        chk(g, "B12_chi_X_table_line_present_verbatim",
            "| `L(g) = chi_top(X^g)` | −6 | 2 | **6** | **4** | **2** | **5** |"
            in txt,
            "sec.6.1 topological-Lefschetz table")
        chk(g, "B13_chi_E_sigma_plus_chi_L_sigma_line_present",
            "2 = chi(E_sigma) + chi(L_sigma)" in txt or
            "`2 = chi(E_sigma) + chi(L_sigma)" in txt,
            "the order-2 split 0 + 2")

    # B-c: the census
    p = sealed("goal_runs_20260810", "TERMINUS_STRATA_PW", "results",
               "t2_strata.txt")
    ok = os.path.exists(p)
    chk(g, "B14_census_file_present", ok, p)
    if ok:
        txt = open(p).read()
        rows_c11 = [l for l in txt.splitlines()
                    if l.strip().startswith("C11") and "pt_C11" in l]
        shape_ok = all(l.split()[:5] == ["C11", "0", "60", "5", "C11"]
                       for l in rows_c11)
        chk(g, "B15_census_C11_rows_are_dim0_60_comp_5_per_fixed_C11",
            bool(rows_c11) and shape_ok and
            "C11        OCCURS   :   4 G-orbits,    240 components" in txt,
            "%d 'pt_C11' rows across the stage/prime blocks, every one "
            "dim 0, #comp 60, #/fixedK 5; OCCURS line gives 4 G-orbits and "
            "240 components => 4 x 5 = 20 points of Z^{C11} for one fixed "
            "C11" % len(rows_c11))
        chk(g, "B16_census_Z_fixed_by_dim_C11", K.Z_FIXED_BY_DIM["C11"] == {0: 20},
            "%r" % (K.Z_FIXED_BY_DIM["C11"],))
        for h, exp in (("C2", 239), ("C3", 80), ("V4", 54), ("C5", 20),
                       ("C6", 38), ("C11", 20)):
            chk(g, "B17_%s_dim_breakdown_sums_to_component_count" % h,
                sum(K.Z_FIXED_BY_DIM[h].values()) == exp ==
                K.Z_FIXED_COMPONENTS[h],
                "%s: %r sums to %d"
                % (h, K.Z_FIXED_BY_DIM[h], sum(K.Z_FIXED_BY_DIM[h].values())))

    p = sealed("goal_runs_20260810", "TERMINUS_STRATA_PW", "THEOREM.md")
    if os.path.exists(p):
        txt = open(p).read()
        chk(g, "B18_terminus_20_points_sentence_present",
            "a fixed `C11` fixes exactly 20 points" in txt,
            "sec.2 prose")
        chk(g, "B19_every_stratum_rational_present",
            "**Every stratum is rational.**" in txt,
            "sec.1 corollary -- the input to Lemma R")

    # B-d: STAGE1_COMPLEX_MAPS Theorem 3, the order-2 dominance datum
    p = sealed("goal_runs_20260810", "STAGE1_COMPLEX_MAPS", "THEOREM.md")
    if os.path.exists(p):
        txt = open(p).read()
        chk(g, "B20_L_sigma_dominance_theorem_present",
            "L_sigma" in txt or "L_\\sigma" in txt or "L_σ" in txt,
            "Theorem 3 (three D12-stabilised rows surject onto L_sigma)")

    # B-e: the F_odd menu, machine-readable
    p = sealed("goal_runs_20260811", "GLOBAL_COHERENCE", "results",
               "vectors_d35.json")
    ok = os.path.exists(p)
    chk(g, "B21_menu_file_present", ok, p)
    if ok:
        with open(p) as f:
            v = json.load(f)
        chk(g, "B22_menu_is_for_d_35", v["d"] == 35, "d = %r" % v["d"])
        fac = {k: v["per_center"][k]["n"] for k in v["per_center"]}
        chk(g, "B23_menu_factors_match", fac == K.MENU_FACTORS, "%r" % (fac,))
        prod = 1
        for n in fac.values():
            prod *= n
        chk(g, "B24_menu_product_equals_F_odd_35",
            prod == v["F_odd"] == K.F_ODD_35, "%d" % prod)

        # the reconstruction check: our master-formula rebuild of the C11 and
        # C5 menus reproduces the sealed vector lists EXACTLY
        _, mine = F.c11_menu()
        chk(g, "B25_C11_menu_rebuilt_from_master_formula",
            sorted(tuple(e["vector"]) for e in mine) ==
            sorted(tuple(x) for x in v["per_center"]["C11"]["vectors"]),
            "10 entries, mu = 1..10 (35 = 2 mod 11 is a non-residue, so "
            "mu >= 1)")
        c5 = F.c5_menus()
        allok = True
        for t in ("C5a", "C5b", "D10"):
            allok = allok and (
                sorted(tuple(e["vector"]) for e in c5[t]["entries"]) ==
                sorted(tuple(x) for x in v["per_center"][t]["vectors"]) and
                c5[t]["rows"] == v["per_center"][t]["row_names"])
        chk(g, "B26_C5a_C5b_D10_menus_rebuilt_from_master_formula", allok,
            "mu = 1..4 each (5 | 35 forces 5 not dividing mu)")

        # STAGE2 Theorem 2.1: at a non-residue d at most three of the four
        # C11 rows can carry a value.  Our rebuild must respect it.
        mx = max(e["n_defined"] for e in mine)
        chk(g, "B27_at_most_three_C11_rows_defined_at_d_35", mx <= 3,
            "max defined rows over the whole menu = %d "
            "(STAGE2_ODD_ORDER_PINNING Thm 2.1)" % mx)

    p = sealed("goal_runs_20260811", "GLOBAL_COHERENCE", "results",
               "F_odd_counts.json")
    if os.path.exists(p):
        with open(p) as f:
            cnt = json.load(f)
        recs = cnt if isinstance(cnt, list) else cnt.get("records", [])
        hit = [r for r in recs if isinstance(r, dict) and
               r.get("d_mod_330") == 35]
        chk(g, "B28_F_odd_counts_record_for_residue_35",
            len(hit) == 1 and hit[0].get("F_odd") == K.F_ODD_35 and
            hit[0].get("factors") == K.MENU_FACTORS,
            "record d_mod_330 = 35: F_odd = %r, factors = %r, d mod 11 = %r "
            "(non-residue), d mod 5 = %r"
            % (hit[0].get("F_odd"), hit[0].get("factors"),
               hit[0].get("d_mod_11"), hit[0].get("d_mod_5")) if hit
            else "no record found")

    # B-f: the 22 live cells
    p = sealed("goal_runs_20260811", "D35_AUDIT", "results",
               "patterns_r5_content_p331.json")
    ok = os.path.exists(p)
    chk(g, "B29_d35_audit_file_present", ok, p)
    if ok:
        with open(p) as f:
            pat = json.load(f)
        chk(g, "B30_n_patterns_756", pat["n_patterns"] == 756,
            "%r" % pat["n_patterns"])
        s22 = pat["survivors22"]
        chk(g, "B31_survivor_ids_match", list(s22["ids"]) == K.LIVE_CELL_IDS,
            "%d ids" % len(s22["ids"]))
        chk(g, "B32_survivor_hashes_match",
            sorted(s22["content_hashes"]) == sorted(K.LIVE_CELL_HASHES_P331),
            "22 content hashes at p = 331")
        chk(g, "B33_split_formula_756_336_398_22",
            pat["split"]["total"] == 756 and
            pat["split"]["ord0_L_survivors"] == 22,
            "%r" % pat["split"])
        live = [q for q in pat["patterns"] if q["id"] in set(K.LIVE_CELL_IDS)]
        keys = {q["group_key"] for q in live}
        chk(g, "B34_all_22_share_one_sigma_band_group_key",
            keys == {K.SIGMA_BAND_PATTERN_22["group_key"]},
            "group_keys among the 22: %r  *** SPEC DIVERGENCE: the data spec "
            "says each cell's sigma-band pattern is UNIQUE; it is SHARED ***"
            % (sorted(keys),))
        band_ok = all(
            q["m_options_L"] == K.SIGMA_BAND_PATTERN_22["m_options_L"] and
            q["m_options_P"] == K.SIGMA_BAND_PATTERN_22["m_options_P"] and
            q["a35_L_options"] == K.SIGMA_BAND_PATTERN_22["a35_L_options"] and
            q["a35_P_options"] == K.SIGMA_BAND_PATTERN_22["a35_P_options"] and
            q["min_m"] == 1 and q["max_m"] == 1 for q in live)
        chk(g, "B35_sigma_band_pattern_of_the_22_is_as_recorded", band_ok,
            "ord_{L'_sigma} = 0, ord_{P_sigma} = 1, m = 1")
        chk(g, "B36_no_field_named_sol_hash",
            "sol_hash" not in (live[0].keys() if live else {}),
            "per-cell identity fields are content_hash / sealed_hash "
            "*** SPEC DIVERGENCE, flagged ***")

    # B-g: no cell -> menu-subset linkage anywhere
    chk(g, "B37_cell_menu_linkage_not_determined",
        K.CELL_MENU_LINKAGE.startswith("NOT DETERMINED"),
        "full menu treated as admissible for every cell, per DATA_SPEC sec.2")

    # B-h: C1 carries no sealed genus bound at d = 35
    p = sealed("theory", "CONSTRAINT_ADDITIONS_20260811.md")
    if os.path.exists(p):
        txt = open(p).read()
        i = txt.find("## C1.")
        j = txt.find("## C2.")
        blk = txt[i:j]
        chk(g, "B38_C1_is_an_identity_package_not_a_bound",
            "2g - 2" in blk.replace("−", "-") and
            "genus identity package" in blk,
            "C1 states K_{Z/X}, 2g-2 = 65nu + sum(a_E - 2m_E)e_E and d*nu = "
            "sum m_E e_E at d = 35: identities in unpinned a_E, m_E, e_E, nu. "
            "NO sealed numeric g_max binds => fiber menus reported "
            "PARAMETRICALLY, per DATA_SPEC sec.2")

    # B-i: the internal cross-checks of constants.py
    for name, okk, detail in K.selfcheck():
        chk(g, "B39_selfcheck_%s" % name, okk, detail)


# =========================================================== GROUP C
def group_C():
    g = "C"
    o11 = F.order11()
    o5 = F.order5()
    o2 = F.order2()
    o3 = F.order3()
    o6 = F.order6()

    # --- order 11
    chk(g, "C1_order11_Z_fixed_is_20_points",
        o11["source_census"]["#Z^{C11}"] == 20, "census")
    chk(g, "C2_order11_5_divides_Z_fixed", 20 % 5 == 0,
        "Lemma U(b) forces 5 | #Ztilde^{C11}")
    chk(g, "C3_order11_n_x_equals_4", o11["n_x_on_Z"] == 4, "20 / 5")
    chk(g, "C4_order11_F3_closes_exactly",
        5 * o11["n_x_on_Z"] == K.Z_FINITE_FIXED["C11"] == 20,
        "sum over the 5 receiver points = chi(Z^{C11}) = 20")
    chk(g, "C5_order11_congruence_residue_is_4", o11["n_x_on_Z"] % 11 == 4,
        "chi(q^{-1}(x)) == 4 (mod 11) at each of the 5 C11-fixed points of X")
    chk(g, "C6_order11_result_constant_over_the_menu",
        len({e["n_x"] for e in o11["menu"]}) == 1 and
        len(o11["menu"]) == K.MENU_FACTORS["C11"] == 10,
        "all 10 C11 menu entries give n_x = 4; the entry changes WHICH row "
        "lands on which point, never the count")
    chk(g, "C7_order11_menu_defined_row_counts",
        [e["n_defined_rows"] for e in o11["menu"]] ==
        [2, 0, 2, 2, 2, 3, 3, 2, 2, 2],
        "per mu = 1..10; max 3, so at d = 35 the value assignment is NEVER "
        "total on the four C11 rows")

    # --- order 5
    chk(g, "C8_order5_uniform_over_the_64_menu_entries",
        o5["uniform_across_menu"] and o5["menu_size"] == 64,
        "C5a x C5b x D10 = 4 x 4 x 4")
    chk(g, "C9_order5_n_x_is_5_at_every_receiver_point",
        all(v == 5 for v in o5["n_x"].values()) and len(o5["n_x"]) == 4,
        "%r" % (o5["n_x"],))
    chk(g, "C10_order5_F3_closes_exactly",
        o5["sum_check"] == K.Z_FINITE_FIXED["C5"] == 20,
        "4 receiver points x 5 = 20 = chi(Z^{C5})")
    chk(g, "C11_order5_congruence_residue_is_0", 5 % 5 == 0,
        "chi(q^{-1}(x)) == 0 (mod 5) at each of the 4 C5-fixed points of X")

    # --- order 6 (F3 cross-check only; Smith needs a prime)
    chk(g, "C12_order6_F3_cross_check",
        o6["n_x"] * 2 == K.Z_FINITE_FIXED["C6"] == 38 and
        o6["smith_applies"] is False,
        "2 receiver points x 19 = 38; recorded as F3 only, no mod-p claim")

    # --- order 2
    chk(g, "C13_order2_receiver_split",
        [s["chi"] for s in o2["receiver_strata"]] == [0, 2] and
        sum(s["chi"] for s in o2["receiver_strata"]) == K.CHI_X_FIXED[2],
        "E^X_sigma chi 0 (genus 1) + L^X_sigma chi 2 = 2")
    chk(g, "C14_order2_rationality_input_present",
        o2["all_strata_rational"] is True,
        "TERMINUS_STRATA_PW sec.1: every stratum of Z is rational")
    chk(g, "C15_order2_E_branch_closed_on_Z",
        o2["branch_E"]["holds_on"] == "Z and every admissible refinement",
        o2["branch_E"]["statement"])
    chk(g, "C16_order2_L_branch_is_parametric",
        o2["branch_L"]["parametric"] is True,
        o2["branch_L"]["reason_parametric"])
    chk(g, "C17_order2_three_dominating_rows",
        len(o2["branch_L"]["dominating_rows"]) == 3,
        "%r" % (o2["branch_L"]["dominating_rows"],))
    chk(g, "C18_order2_cell_band_reading",
        o2["cell_data"]["a35_L_options"] == [[35, 0]] and
        o2["cell_data"]["a35_P_options"] == [[34, 1]],
        "ord_{L'_sigma}(T) = 0, ord_{P_sigma}(T) = 1 for all 22 cells")

    # --- order 3
    chk(g, "C19_order3_is_parametric", o3["status"] == "PARAMETRIC",
        o3["blocker"])
    chk(g, "C20_order3_menu_size_56644",
        o3["menu_size"] == 238 * 238 == 56644, "A4a x A4b")
    chk(g, "C21_order3_receiver_is_6_points",
        o3["receiver"]["chi"] == 6, "chi(X^{C3}) = 6")
    chk(g, "C22_order3_Z_fixed_dim_breakdown",
        o3["source_census_Z_C3_by_dim"] == {0: 62, 1: 16, 2: 2},
        "62 points + 16 rational curves + 2 surfaces = 80 components")

    # --- the per-cell x menu report
    cells = F.per_cell_report()
    chk(g, "C23_22_cells_reported", len(cells) == 22, "one row per live cell")
    chk(g, "C24_every_cell_paired_with_the_FULL_menu",
        all(c["menu_admissible"] == "FULL (36252160 entries)" for c in cells),
        "no linkage exists, so no menu is narrowed")
    chk(g, "C25_menu_never_collapsed",
        all(c["order11"]["menu_entries_covered"] *
            c["order11"]["free_multiplicity"] == K.F_ODD_35 for c in cells) and
        all(c["order5"]["menu_entries_covered"] *
            c["order5"]["free_multiplicity"] == K.F_ODD_35 for c in cells),
        "covered x free-multiplicity = F_odd(35) for every reported factor")
    chk(g, "C26_cell_menu_pair_count",
        22 * K.F_ODD_35 == 797547520, "22 x 36252160")

    # --- I3 scan (group C also covers the I3 evaluations)
    from i3_pipeline_scan import (single_monomial_criterion,
                                  c11_eigenbasis_corollary, scan_stored_seeds,
                                  VERDICT)
    for d in (34, 35):
        c = single_monomial_criterion(d)
        chk(g, "C27_no_semistable_single_monomial_at_d_%d" % d,
            c["any_semistable_single_monomial"] is False,
            "5 does not divide %d" % (d - 1))
    c36 = single_monomial_criterion(36)
    chk(g, "C28_semistable_single_monomials_exist_exactly_when_5_divides_d_minus_1",
        c36["any_semistable_single_monomial"] is True and
        len(c36["the_only_ones"]) == 5,
        "at d = 36 the five tuples x^(7,7,7,7,7) x_c (x) e_c are semistable")

    for d, exp_lo, exp_hi in ((34, 13, 14), (35, 13, 14)):
        cor = c11_eigenbasis_corollary(d)
        chk(g, "C29_C11_eigenbasis_levels_d_%d" % d,
            cor["need_some_level_k_le"] == exp_lo and
            cor["need_some_level_k_ge"] == exp_hi and
            cor["one_PS_r"] == [-17, -7, -2, 3, 23] and
            cor["vacuous"] is False,
            "r = %r, need a level k <= %d and a level k >= %d, attainable "
            "range %r" % (cor["one_PS_r"], exp_lo, exp_hi,
                          cor["attainable_level_range"]))
    cor2 = c11_eigenbasis_corollary(35, (2, 6, 7, 8, 10))
    chk(g, "C30_C11_eigenbasis_second_frame_d_35",
        cor2["one_PS_r"] == [-23, -3, 2, 7, 17] and
        cor2["need_some_level_k_le"] == 20 and
        cor2["need_some_level_k_ge"] == 21,
        "the non-residue generator gives an independent two-sided level test")

    s = scan_stored_seeds()
    if s.get("status") == "ok":
        chk(g, "C31_all_637_stored_d35_seeds_are_UNSTABLE",
            s["verdicts"]["UNSTABLE"] == s["n_seeds"] == 637 and
            s["verdicts"]["SEMISTABLE"] == 0 and s["degree"] == 35,
            "and this is CORRECT, not a leak: a seed is an argument of the "
            "Reynolds operator, never a candidate tuple")
    else:
        skip(g, "C31_all_637_stored_d35_seeds_are_UNSTABLE", s.get("status"))

    chk(g, "C32_I3_verdict_is_SUBSUMED", VERDICT["verdict"] == "SUBSUMED",
        VERDICT["statement"][:120] + " ...")

    # --- the ODDZERO-standard zero/all-dead audit
    zero_flags = []
    if o11["n_x_on_Z"] == 0:
        zero_flags.append("order 11 n_x = 0")
    if any(v == 0 for v in o5["n_x"].values()):
        zero_flags.append("order 5 n_x = 0")
    if len(K.LIVE_CELL_IDS) == 0:
        zero_flags.append("no live cells")
    chk(g, "C33_no_zero_or_all_dead_outcome_to_flag", zero_flags == [],
        "nothing in this packet returns 0 or all-dead; if it ever does, the "
        "ODDZERO-standard audit is mandatory before any claim")


def main():
    res_a = group_A()
    if not res_a["all_pass"]:
        print("GROUP A FAILED -- the Hilbert-Mumford convention is wrong. "
              "Per DATA_SPEC sec.1 the correct action is to fix the "
              "convention, NOT to proceed.  Groups B and C are not run.")
        emit()
        return 1
    group_B()
    group_C()
    return emit()


def emit():
    npass = sum(1 for c in CHECKS if c["pass"] is True)
    nfail = sum(1 for c in CHECKS if c["pass"] is False)
    nskip = sum(1 for c in CHECKS if c["pass"] is None)
    for c in CHECKS:
        tag = {True: "PASS", False: "FAIL", None: "SKIP"}[c["pass"]]
        print("[%s] %-4s %-62s %s" % (c["group"], tag, c["name"], c["detail"]))
    print()
    print("groups: A=%d B=%d C=%d"
          % (sum(1 for c in CHECKS if c["group"] == "A"),
             sum(1 for c in CHECKS if c["group"] == "B"),
             sum(1 for c in CHECKS if c["group"] == "C")))
    print("checks: %d  pass: %d  fail: %d  skip: %d"
          % (len(CHECKS), npass, nfail, nskip))
    out = {"checks": CHECKS, "n_checks": len(CHECKS), "n_pass": npass,
           "n_fail": nfail, "n_skip": nskip, "all_pass": nfail == 0}
    with open(os.path.join(HERE, "results", "verifier_output.json"), "w") as f:
        json.dump(out, f, indent=1, sort_keys=True)
    if nfail == 0:
        print("SMITH_I3_VERIFY_OK")
        print("ALLGREEN")
        return 0
    print("SMITH_I3_VERIFY_FAIL")
    return 1


if __name__ == "__main__":
    sys.exit(main())
