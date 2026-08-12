#!/usr/bin/env python3
"""
E_LEDGER verifier.  Replayable, exact, python3 standard library only.

    python3 verifier.py                 # both split primes (~3 min)
    E_LEDGER_PRIMES=331 python3 verifier.py

Check groups, named by the Lane-1 pins of DATA_SPEC_PIPELINE_FLUSH_20260812.md:

  A  CALIBRATION ANCHORS (fatal).  The blowup Chow numbers are re-derived by
     a SECOND, independent route inside the verifier (Fulton's Segre closed
     form) and compared with the producer's projectivised-bundle computation.
     Nothing in the packet is allowed to stand if group A is not all-green.
  B  THE C1 CROSS-CHECK (fatal): the sealed C1 relation family reproduced by
     this packet's own expansion at level 3.
  C  THE CENSUS: the cited constants are internally consistent
     (orbit size = 660/|Stab|, totals 940/220/55/14) and the independent
     rebuild at each split prime reproduces them.
  D  LEMMA F (the mod-p filter) re-proved numerically, with the p = 2 control,
     and the congruence coefficient table compared against the values printed
     in SCHEME_MAP_CONSEQUENCES section 3.1.
  E  THE d = 35 ORDER-11 INSTANCE, in its conditional form.
  F  E3: every certified covering family re-checked from its stored witness
     line; every negative control re-checked; every LP optimum re-checked by
     exact duality.
  G  E4: the rank of the linear part and its certifying minor.

Markers on success: E_LEDGER_VERIFY_OK and ALLGREEN.
"""

import json
import os
import sys
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "scripts"))

import chow                                          # noqa: E402
import census                                        # noqa: E402
import e2_congruences as e2                          # noqa: E402
import e3_movable as e3                              # noqa: E402
import e4_system as e4                               # noqa: E402
import lp                                            # noqa: E402
from psl211 import Model, SPLIT_PRIMES               # noqa: E402

CHECKS = []
RES = os.path.join(HERE, "results", "e_ledger.json")


def chk(g, name, ok, detail=""):
    CHECKS.append({"group": g, "name": name, "pass": bool(ok),
                   "detail": str(detail)})
    return bool(ok)


def primes():
    v = os.environ.get("E_LEDGER_PRIMES")
    return tuple(int(x) for x in v.split(",")) if v else SPLIT_PRIMES


def binom(n, k):
    if k < 0 or k > n:
        return 0
    num = den = 1
    for i in range(k):
        num *= n - i
        den *= i + 1
    return num // den


# =========================================================== GROUP A
def group_A(D):
    g = "A"
    pt = chow.blowup_numbers(0)
    chk(g, "A1_E4_is_minus_one_on_Bl_pt_P4", pt[4] == -1, "E^4 = %s" % pt[4])
    chk(g, "A1_H3E_H2E2_HE3_vanish_on_Bl_pt_P4",
        pt[1] == 0 and pt[2] == 0 and pt[3] == 0,
        "(%s, %s, %s)" % (pt[1], pt[2], pt[3]))
    chk(g, "A1_H4_is_one", pt[0] == 1)

    # independent route: Fulton pi_*(E^b) = (-1)^(b-1) s_{b-r}(N) cap [Z],
    # N = O(1)^r on P^delta, s_k(N) = (-1)^k C(r+k-1,k) h^k.
    ok = True
    for delta in (0, 1, 2):
        r = 4 - delta
        nums = chow.blowup_numbers(delta)
        for b in range(1, 5):
            pred = 0 if b < r else ((-1) ** (delta + 1)) * binom(b - 1, b - 4 + delta)
            ok = ok and nums[b] == pred
    chk(g, "A2_segre_closed_form_agrees_with_the_bundle_computation", ok)

    # independent route: (H - E)^4 = 0 for a linear centre of dim <= 2
    ok = True
    for delta in (0, 1, 2):
        nums = chow.blowup_numbers(delta)
        ok = ok and sum((-1) ** b * binom(4, b) * nums[b] for b in range(5)) == 0
    chk(g, "A3_projection_identity_(H-E)^4_is_zero", ok)

    # the curve-centre normal-bundle degrees the census gives
    ln = chow.blowup_numbers(1)
    chk(g, "A4_line_centre_HE3_is_1_and_E4_is_3", ln[3] == 1 and ln[4] == 3,
        "HE^3 = %s, E^4 = %s" % (ln[3], ln[4]))
    pl = chow.blowup_numbers(2)
    chk(g, "A5_plane_centre_H2E2_HE3_E4_are_-1_-2_-3",
        pl[2] == -1 and pl[3] == -2 and pl[4] == -3)
    chk(g, "A6_discrepancies_are_3_2_1",
        [chow.discrepancy(x) for x in (0, 1, 2)] == [3, 2, 1])

    # the producer stored the same table
    a = D["anchors"]
    chk(g, "A7_producer_anchor_block_all_pass",
        all(v["pass"] for v in a.values()), sorted(a))


# =========================================================== GROUP B
def group_B(D):
    g = "B"
    c1 = chow.run_c1_reproduction()
    for k, v in c1.items():
        chk(g, "B_%s" % k, v["pass"], v.get("identity", ""))
    chk(g, "B_producer_c1_block_matches",
        all(D["c1_reproduction"][k]["pass"] for k in D["c1_reproduction"]))
    # the level-4 local form at an isolated point centre is exactly mu^4
    s0 = chow.local_contribution_level4(0)
    chk(g, "B_isolated_point_local_level4_is_mu^4", repr(s0) == "1*m^4", repr(s0))
    s1 = chow.local_contribution_level4(1)
    s2 = chow.local_contribution_level4(2)
    chk(g, "B_line_and_plane_local_level4_forms",
        repr(s1) == "4*d*m^3 - 3*m^4"
        and repr(s2) == "6*d^2*m^2 - 8*d*m^3 + 3*m^4",
        "%s | %s" % (s1, s2))


# =========================================================== GROUP C
def group_C(D):
    g = "C"
    C = census.CENSUS
    chk(g, "C1_orbit_size_equals_660_over_setwise_stabiliser",
        all(v[1] * v[4] == 660 for v in C.values()))
    pts, lns, pls = census.census_totals()
    chk(g, "C2_totals_940_220_55", (pts, lns, pls) == (940, 220, 55),
        (pts, lns, pls))
    chk(g, "C3_fourteen_orbits", len(C) == 14)
    for p in primes():
        rb = D["rebuild"][str(p)]
        chk(g, "C4_rebuild_p%d_matches_cited_census" % p,
            rb["matches_cited_census"],
            "%d/%d/%d in %d orbits" % (rb["points"], rb["lines"],
                                       rb["planes"], rb["n_orbits"]))
        chk(g, "C5_rebuild_p%d_labels_are_the_14_census_labels" % p,
            sorted(rb["labels"].values()) == sorted(C))
        chk(g, "C6_rebuild_p%d_every_plus_plane_pair_meets" % p,
            rb["plus_plane_pairs"]["disjoint"] == 0
            and rb["plus_plane_union_is_connected"],
            rb["plus_plane_pairs"])


# =========================================================== GROUP D
def group_D(D):
    g = "D"
    orders = D["e2"]["subgroup_orders_derived_from_the_660_matrices"]
    chk(g, "D1_lagrange", all(660 % s == 0 for s in orders), orders)
    chk(g, "D2_v_p_660_is_one_for_11_5_3",
        all(e2.vp(660, p) == 1 for p in (11, 5, 3)))
    chk(g, "D3_v_2_660_is_two", e2.vp(660, 2) == 2)
    L = e2.lemma_F_check(orders)
    chk(g, "D4_lemma_F_holds_for_p_in_11_5_3", L["lemma_F_holds_for_11_5_3"])
    chk(g, "D5_p2_control_fails_as_it_must",
        L["p2_control_shows_lemma_needs_v_p=1"], L["p2_control_failures"])

    # the coefficient table, against the values SCHEME_MAP section 3.1 prints
    expected = {
        11: {11: 5, 55: 1},
        5:  {5: 2, 10: 1, 55: 2, 60: 1},
        3:  {3: 1, 6: 2, 12: 1, 60: 2},
    }
    coeffs = D["e2"]["congruence_coefficients"]
    for p, exp in expected.items():
        got = {r["|S|"]: r["coefficient n mod p"] for r in coeffs[str(p)]}
        ok = all(got.get(s) == c for s, c in exp.items())
        chk(g, "D6_section3_1_coefficients_reproduced_p%d" % p, ok,
            "expected %r inside got %r" % (exp, got))
        chk(g, "D7_row_660_present_and_dropped_by_section3_1_p%d" % p,
            got.get(660) == 1,
            "n = 1 for a G-stabilised component; this is FLAG E2-G-ORBIT")

    chk(g, "D8_fourth_powers_mod_11_are_the_QRs",
        e2.fourth_powers(11) == [1, 3, 4, 5, 9], e2.fourth_powers(11))
    chk(g, "D9_fourth_powers_mod_5_and_3_are_trivial",
        e2.fourth_powers(5) == [1] and e2.fourth_powers(3) == [1])

    # which census orbits survive the filter, per prime
    exp_heavy = {11: {"pt_C11"},
                 5: {"pt_D10", "pt_C5(a)", "pt_C5(b)"},
                 3: {"pt_A4(a)", "pt_A4(b)", "pt_D12", "pt_C6(a)", "pt_C6(b)",
                     "C3line", "Lminus_sigma", "ell_V", "P_sigma"}}
    for p, exp in exp_heavy.items():
        got = {lab for lab, v in census.CENSUS.items() if v[4] % p == 0}
        chk(g, "D10_census_orbits_surviving_the_filter_p%d" % p, got == exp,
            sorted(got))


# =========================================================== GROUP E
def group_E(D):
    g = "E"
    inst = D["e2"]["d35_order11"]
    chk(g, "E1_35_mod_11_is_2", inst["d mod 11"] == 2)
    chk(g, "E2_35^4_mod_11_is_5", inst["d^4 mod 11"] == 5
        and pow(35, 4, 11) == 5)
    chk(g, "E3_2_is_not_a_fourth_power_mod_11",
        2 not in e2.fourth_powers(11))
    chk(g, "E4_section3_1_form_reproduced", inst["reproduced"],
        inst["solved_for_s_C11"])
    chk(g, "E5_mu4_eq_1_mod_11_iff_mu_eq_pm1",
        inst["mu_solutions_of_mu^4=1_mod_11"] == [1, 10])
    chk(g, "E6_statement_is_conditional_and_names_its_hypotheses",
        "IF" in inst["conditional_statement"]
        and "nondegenerate" in inst["conditional_statement"]
        and "hypotheses, not results" in inst["conditional_statement"])


# =========================================================== GROUP F
def group_F(D):
    g = "F"
    for p in primes():
        G = e3.Geometry(p)
        cert = D["e3_by_prime"][str(p)]
        labmap = census.label_orbits(G.A)
        chk(g, "F1_p%d_labels_stable" % p,
            {str(i): labmap[i] for i in labmap} == cert["labels"])
        for f in cert["certified"]:
            if f["status"] != "CERTIFIED":
                chk(g, "F2_p%d_%s_certified" % (p, f["name"]), False, f["status"])
                continue
            L = tuple(tuple(r) for r in f["line"])
            cnt, contained = G.line_incidence(L)
            got = {str(k): int(v) for k, v in sorted(cnt.items())}
            chk(g, "F2_p%d_%s_witness_reverified" % (p, f["name"]),
                not contained and got == f["incidence"],
                "stored %r recomputed %r" % (f["incidence"], got))
            # the witness line really passes through the stored general point
            z = tuple(f["z"])
            chk(g, "F3_p%d_%s_line_through_z" % (p, f["name"]),
                G.m.rank([list(x) for x in L] + [list(z)]) == 2)
        for c in cert["controls"]:
            chk(g, "F4_p%d_control_%s_is_not_a_covering_family" % (p, c["name"]),
                not c["is_covering_family"],
                "%d/%d" % (c["max_general_points_covered_by_one_tuple"],
                           c["n_general_points"]))

    chk(g, "F5_two_prime_agreement", D["e3_two_prime_agreement"]["agree"],
        D["e3_two_prime_agreement"])

    # the LP: rebuild rows from the stored certificates and re-solve
    labels = e4.ORDER
    idx = {l: k for k, l in enumerate(labels)}
    for block, cone in (("e3_lp_core", False),
                        ("e3_lp_with_cone_coupling", True)):
        rows = D[block]["rows"]
        A = [[Fraction(r["coeffs"].get(l, "0")) for l in labels] for r in rows]
        b = [Fraction(r["rhs"]) for r in rows]
        for l, obj in D[block]["objectives"].items():
            c = [Fraction(1) if j == idx[l] else Fraction(0)
                 for j in range(len(labels))]
            res = lp.solve_max(c, A, b)
            ok = (str(res["value"]) == obj["max_m_over_d"])
            chk(g, "F6_%s_optimum_%s" % (block, l), ok,
                "%s vs %s" % (res["value"], obj["max_m_over_d"]))
            chkc = lp.check_certificate(c, A, b, res)
            chk(g, "F7_%s_duality_certificate_%s" % (block, l), chkc["ok"],
                chkc["detail"])
    chk(g, "F8_max_plus_plane_multiplicity_is_d_over_3",
        D["e3_lp_core"]["objectives"]["P_sigma"]["max_m_over_d"] == "1/3")
    chk(g, "F9_pinned_bounds_feasible_at_d35",
        D["e3_pinning_core"]["feasible_at_d=35"] is True,
        D["e3_pinning_core"]["violated_rows"])
    chk(g, "F10_degree_bound_from_E3_plus_pinning_is_7",
        D["e3_pinning_core"]["min_degree_forced_by_E3_plus_pinning"] == "7")


# =========================================================== GROUP G
def group_G(D):
    g = "G"
    s = e4.build(35)
    chk(g, "G1_linear_part_rank_is_4", s["linear_part"]["rank"] == 4,
        s["linear_part"]["rank_note"])
    chk(g, "G2_certifying_minor_has_rank_4",
        s["linear_part"]["certifying_minor_rank"] == 4)
    chk(g, "G3_no_forced_entries_from_the_linear_part",
        s["forced_entries"] == [], s["forced_note"])
    chk(g, "G4_producer_matches", D["e4"]["linear_part"]["rank"] == 4)
    nd = D["e4_nd_corollary"]
    chk(g, "G5_ND_corollary_is_conditional",
        nd["status"].startswith("CONDITIONAL"))
    chk(g, "G6_ND_mu_candidates_at_d35",
        nd["mu_candidates_at_d=35_under_ND_and_the_mod11_clause"] == [12, 21],
        nd["mu_candidates_at_d=35_under_ND_and_the_mod11_clause"])


# =========================================================== main
def main():
    if not os.path.exists(RES):
        print("results/e_ledger.json missing; run scripts/pipeline.py first")
        return 2
    D = json.load(open(RES))
    group_A(D)
    if any(c["group"] == "A" and not c["pass"] for c in CHECKS):
        print("FATAL: calibration anchors failed; stopping.")
    else:
        group_B(D)
        group_C(D)
        group_D(D)
        group_E(D)
        group_F(D)
        group_G(D)
    fails = [c for c in CHECKS if not c["pass"]]
    out = {"checks": CHECKS, "n_checks": len(CHECKS), "n_failures": len(fails)}
    with open(os.path.join(HERE, "results", "verifier_output.json"), "w") as fh:
        json.dump(out, fh, indent=1)
    lines = []
    for c in CHECKS:
        lines.append("[%s] %-6s %-62s %s"
                     % ("PASS" if c["pass"] else "FAIL", c["group"],
                        c["name"], c["detail"][:70]))
    lines.append("")
    lines.append("%d checks, %d failures" % (len(CHECKS), len(fails)))
    if not fails:
        lines.append("E_LEDGER_VERIFY_OK")
        lines.append("ALLGREEN")
    txt = "\n".join(lines)
    with open(os.path.join(HERE, "results", "verifier_stdout.txt"), "w") as fh:
        fh.write(txt + "\n")
    print(txt)
    return 0 if not fails else 1


if __name__ == "__main__":
    sys.exit(main())
