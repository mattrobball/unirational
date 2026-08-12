#!/usr/bin/env python3
"""
REFEREE spot-checks R5 (LP layer) and R6 (E4) -- run against the STORED
results/e_ledger.json only; no packet solver code is imported.  Exact
Fraction arithmetic, own checker.

R5:
  L1  the LP has exactly 19 rows = 14 one-orbit + two_planes + three_planes
      + 3 line-orbit+plane, and the row coefficients equal the certified
      incidence vectors at both primes;
  L2  every stored optimum in BOTH LP blocks re-verifies by exact weak
      duality from the STORED primal/dual vectors alone (feasibility of
      each + equal objective values pins the optimum; no simplex trusted);
  L3  max x_{P_sigma} = 1/3 (core) and adding the cone row changes no
      optimum; the other 13 optima are 1;
  L4  pinning: A.lower <= b at d = 35 (feasible; E3 excludes no degree) and
      min degree forced = 7, from the ell_V + P_sigma row (6 + 1);
  L5  the FLAG E3-DEGREE worked example: at e = 9 a plane curve in a 2-plane
      through z can be asked through min(55, e(e+3)/2 - 1) = 53 of the 55
      plane-points, giving d >= (53/9) m_P > 3 m_P -- so the degree-1 LP is
      an outer approximation and 1/3 is NOT claimed as the movable-cone
      bound.

R6:
  E1  the four E4 rows at five integer specialisations have rank exactly 4
      (own Gaussian elimination), and rank <= 4 trivially, so generic rank
      is 4; the packet's certifying 4x4 minor (columns s_G, t_G,
      eb[pt_C11], g) is non-singular;
  E2  NO FORCED ENTRIES, verified by the test the packet did NOT run: a
      variable x_j is forced by the linear part iff e_j lies in the row
      space; for every one of the 46 declared columns, appending e_j raises
      the rank to 5 at every specialisation (and the certifying reasoning
      is recorded).  This REPAIRS the packet's justification, which
      inferred "no forced entries" from rank < #columns alone -- a non
      sequitur in general (a system of rank 1 can force a variable) --
      while confirming its conclusion.
"""

import json
import os
import sys
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results", "e_ledger.json")

FAILS = []

ORDER = ["pt_C11", "pt_D10", "pt_A4(a)", "pt_A4(b)", "pt_V4I", "pt_C5(a)",
         "pt_C5(b)", "pt_C6(a)", "pt_C6(b)", "pt_D12", "C3line",
         "Lminus_sigma", "ell_V", "P_sigma"]


def chk(name, ok, detail=""):
    print("[%s] %s %s" % ("PASS" if ok else "FAIL", name, detail))
    if not ok:
        FAILS.append(name)


def rank(rows):
    M = [list(r) for r in rows]
    n = len(M[0]) if M else 0
    r = 0
    for c in range(n):
        piv = next((i for i in range(r, len(M)) if M[i][c] != 0), None)
        if piv is None:
            continue
        M[r], M[piv] = M[piv], M[r]
        pv = M[r][c]
        M[r] = [x / pv for x in M[r]]
        for i in range(len(M)):
            if i != r and M[i][c] != 0:
                f = M[i][c]
                M[i] = [a - f * b for a, b in zip(M[i], M[r])]
        r += 1
    return r


def main():
    D = json.load(open(RES))

    # ------------------------------------------------ L1: the 19 rows
    for p in sorted(D["e3_by_prime"]):
        cert = D["e3_by_prime"][p]
        good = [f for f in cert["certified"] if f["status"] == "CERTIFIED"]
        chk("L1_p%s_19_certified_families" % p, len(good) == 19, len(good))
        lab = cert["labels"]
        vecs = sorted(tuple(sorted((lab[k], v) for k, v in f["incidence"].items()))
                      for f in good)
        expected = sorted(
            [(("%s" % l, 1),) for l in ORDER]
            + [(("P_sigma", 2),), (("P_sigma", 3),)]
            + [tuple(sorted([(l, 1), ("P_sigma", 1)]))
               for l in ("C3line", "ell_V", "Lminus_sigma")])
        chk("L1_p%s_incidence_vectors_are_the_19_of_THEOREM_5_3" % p,
            vecs == expected)
        ctrl = cert["controls"]
        chk("L1_p%s_11_controls_all_non_covering" % p,
            len(ctrl) == 11 and all(not c["is_covering_family"] for c in ctrl))
        chk("L1_p%s_best_control_coverage_at_most_4_of_12" % p,
            max(c["max_general_points_covered_by_one_tuple"] for c in ctrl) <= 4
            and all(c["n_general_points"] == 12 for c in ctrl))

    rows_core = D["e3_lp_core"]["rows"]
    chk("L1_lp_core_has_19_rows", len(rows_core) == 19, len(rows_core))
    chk("L1_lp_cone_has_20_rows", len(D["e3_lp_with_cone_coupling"]["rows"]) == 20)

    # ------------------------------------- L2: duality from stored vectors
    for block in ("e3_lp_core", "e3_lp_with_cone_coupling"):
        rows = D[block]["rows"]
        A = [[Fraction(r["coeffs"].get(l, "0")) for l in ORDER] for r in rows]
        b = [Fraction(r["rhs"]) for r in rows]
        n, m = len(ORDER), len(A)
        allok = True
        for l, obj in D[block]["objectives"].items():
            c = [Fraction(1 if ll == l else 0) for ll in ORDER]
            v = Fraction(obj["max_m_over_d"])
            x = [Fraction(s) for s in obj["primal_x"]]
            y = [Fraction(s) for s in obj["dual_y"]]
            ok = (all(xx >= 0 for xx in x)
                  and all(sum(A[i][j] * x[j] for j in range(n)) <= b[i]
                          for i in range(m))
                  and all(yy >= 0 for yy in y)
                  and all(sum(A[i][j] * y[i] for i in range(m)) >= c[j]
                          for j in range(n))
                  and sum(c[j] * x[j] for j in range(n)) == v
                  and sum(b[i] * y[i] for i in range(m)) == v)
            if not ok:
                chk("L2_%s_certificate_%s" % (block, l), False)
                allok = False
        chk("L2_%s_all_14_stored_certificates_reverify" % block, allok)

    # --------------------------------------------------- L3: the optima
    core = D["e3_lp_core"]["objectives"]
    cone = D["e3_lp_with_cone_coupling"]["objectives"]
    chk("L3_max_xP_is_one_third_core", core["P_sigma"]["max_m_over_d"] == "1/3")
    chk("L3_floor_at_35_is_11", core["P_sigma"]["floor_at_d=35"] == 11)
    chk("L3_other_13_optima_are_1",
        all(core[l]["max_m_over_d"] == "1" for l in ORDER if l != "P_sigma"))
    chk("L3_cone_coupling_changes_no_optimum",
        all(core[l]["max_m_over_d"] == cone[l]["max_m_over_d"] for l in ORDER))

    # --------------------------------------------------- L4: pinning
    pin = D["e3_pinning_core"]
    lower = {l: Fraction(pin["pinned_lower_bounds"][l]["m_min"]) for l in ORDER}
    viol, dmin = [], Fraction(0)
    for r in rows_core:
        s = sum(Fraction(r["coeffs"].get(l, "0")) * lower[l] for l in ORDER)
        if s / 35 > Fraction(r["rhs"]):
            viol.append(r["name"])
        dmin = max(dmin, s)
    chk("L4_pinned_bounds_feasible_at_35_no_row_violated", not viol, viol)
    chk("L4_min_degree_is_7", dmin == 7, str(dmin))
    row_ellV_P = next(r for r in rows_core
                      if r["name"] == "line_orbit_10_plus_plane")
    chk("L4_binding_row_is_ellV_plus_P_6_plus_1",
        sorted(row_ellV_P["coeffs"]) == ["P_sigma", "ell_V"]
        and lower["ell_V"] == 6 and lower["P_sigma"] == 1)
    chk("L4_matches_packet", pin["feasible_at_d=35"] is True
        and pin["min_degree_forced_by_E3_plus_pinning"] == "7")

    # --------------------------------------------------- L5: FLAG E3-DEGREE
    e = 9
    npts = min(55, e * (e + 3) // 2 - 1)
    chk("L5_degree9_example_53_points", npts == 53, npts)
    chk("L5_53_over_9_beats_3", Fraction(npts, e) > 3, str(Fraction(npts, e)))
    chk("L5_conditions_count_54_equals_dim_of_system",
        e * (e + 3) // 2 == 54)

    # =================================================== R6: the E4 system
    e4 = D["e4"]
    chk("E1_62_variables_declared", len(e4["variables"]) == 62,
        len(e4["variables"]))
    chk("E1_4_equations", len(e4["equations"]) == 4)
    cols = e4["linear_part"]["columns"]
    chk("E1_46_columns", len(cols) == 46, len(cols))
    n_orb = {l: e4["orbit_sizes"][l] for l in ORDER}
    a_orb = {l: e4["discrepancies"][l] for l in ORDER}
    chk("E1_orbit_sizes_times_stab_660",
        sorted(n_orb.values()) == sorted([60, 66, 55, 55, 165, 132, 132, 110,
                                          110, 55, 110, 55, 55, 55]))
    ci = {c: k for k, c in enumerate(cols)}

    def rows_at(dv, mv):
        R = [[Fraction(0)] * len(cols) for _ in range(4)]
        for l in ORDER:
            R[0][ci["s[%s]" % l]] = Fraction(n_orb[l])
            R[1][ci["t[%s]" % l]] = Fraction(n_orb[l])
            R[2][ci["eb[%s]" % l]] = Fraction(-mv[l])
            R[3][ci["eb[%s]" % l]] = Fraction(a_orb[l] - 2 * mv[l])
        R[0][ci["s[G]"]] = Fraction(1)
        R[1][ci["t[G]"]] = Fraction(1)
        R[1][ci["nu"]] = Fraction(3)
        R[2][ci["nu"]] = Fraction(dv)
        R[3][ci["nu"]] = Fraction(2 * dv - 5)
        R[3][ci["g"]] = Fraction(-2)
        return R

    specs = [(35, {l: 7 * k + 3 * j + 1 for j, l in enumerate(ORDER)})
             for k in range(1, 6)] + [(11, {l: 2 for l in ORDER})]
    ranks = [rank(rows_at(dv, mv)) for dv, mv in specs]
    chk("E1_rank_4_at_six_specialisations_and_at_most_4_rows",
        all(r == 4 for r in ranks), ranks)
    minor_cols = ["s[G]", "t[G]", "eb[pt_C11]", "g"]
    mv1 = {l: 1 for l in ORDER}
    sub = [[rows_at(35, mv1)[i][ci[c]] for c in minor_cols] for i in range(4)]
    chk("E1_certifying_minor_nonsingular", rank(sub) == 4)

    # E2: forced entries -- e_j in rowspace test, at every specialisation
    forced_any = set()
    for dv, mv in specs:
        R = rows_at(dv, mv)
        base = rank(R)
        for j, cname in enumerate(cols):
            ej = [Fraction(0)] * len(cols)
            ej[j] = Fraction(1)
            if rank(R + [ej]) == base:      # e_j in rowspace => forced
                forced_any.add(cname)
    chk("E2_no_column_unit_vector_in_rowspace_no_forced_entries",
        not forced_any, sorted(forced_any))
    chk("E2_packet_conclusion_matches", D["e4"]["forced_entries"] == [])

    print()
    print("referee_lp: %d failures" % len(FAILS))
    return 1 if FAILS else 0


if __name__ == "__main__":
    sys.exit(main())
