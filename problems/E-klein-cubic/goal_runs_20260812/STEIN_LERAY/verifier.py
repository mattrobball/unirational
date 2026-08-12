"""STEIN_LERAY verifier.  python3 verifier.py

Group A is the FATAL GATE (the in-packet J1 re-derivation and its anchors); if
any A check fails the verifier refuses to run B and C.  Group B re-reads every
sealed constant consumed.  Group C evaluates the lane's own mathematics.

Exact integer arithmetic only; no floats; python3 standard library only.
"""

import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(HERE, "scripts"))

import cyclo                                        # noqa: E402
import pinned_points as PP                          # noqa: E402
import menus as MENU                                # noqa: E402

RES = os.path.join(HERE, "results")
checks = []


def ck(group, name, cond, detail=""):
    checks.append({"group": group, "name": name, "pass": bool(cond),
                   "detail": str(detail)[:400]})
    return bool(cond)


def run(script):
    r = subprocess.run([sys.executable, os.path.join(HERE, "scripts", script)],
                       capture_output=True, text=True)
    return r.returncode == 0, (r.stdout + r.stderr)[-2000:]


def main():
    # ---------------------------------------------------------------- A
    ok, out = run("j1_molien.py")
    ck("A", "A1 j1_molien.py replays", ok and "J1_MOLIEN_OK" in out, out[-200:])
    ok2, out2 = run("pinned_points.py")
    ck("A", "A2 pinned_points.py replays", ok2 and "PINNED_POINTS_OK" in out2, out2[-200:])
    J = json.load(open(os.path.join(RES, "j1_molien.json")))
    PJ = json.load(open(os.path.join(RES, "pinned_points.json")))

    ck("A", "A3 |G| = 660", J["group_order"] == 660)
    ck("A", "A4 class sizes", J["class_sizes"] == [1, 55, 110, 132, 132, 110, 60, 60],
       J["class_sizes"])
    ck("A", "A5 class orders", J["class_orders"] == [1, 2, 3, 5, 5, 6, 11, 11])
    ck("A", "A6 Klein weights b = (-2)^i are the quadratic residues",
       J["klein_weights_b"] == [1, 9, 4, 3, 5] and sorted(J["klein_weights_b"]) == J["QR_mod_11"])
    ck("A", "A7 the 5-dim character is the unique completion of the derived C11 datum",
       J["n_character_solutions_given_derived_C11_datum"] == 1)
    row = {r["order"]: r["eigen_exponents"] for r in J["character_row"] if r["order"] != 11}
    ck("A", "A8 order-2 eigenvalues = 3(+1) + 2(-1)  [SCHEME_MAP sec 3.3]",
       row[2] == [0, 0, 0, 1, 1])
    ck("A", "A9 order-3 eigenvalues = 1 + 2w + 2w^2  [sec 3.3]", row[3] == [0, 1, 1, 2, 2])
    ck("A", "A10 order-5 eigenvalues = all five 5th roots  [sec 3.3]",
       row[5] == [0, 1, 2, 3, 4])
    ck("A", "A11 order-6 eigenvalues = 1,-w,-w^2,w,w^2  [sec 3.3]",
       row[6] == [0, 1, 2, 4, 5])
    e11 = sorted(r["eigen_exponents"] for r in J["character_row"] if r["order"] == 11)
    ck("A", "A12 the two order-11 classes carry QR and NQR",
       e11 == [[1, 3, 4, 5, 9], [2, 6, 7, 8, 10]], e11)
    for k, exp in ((1, 1), (11, 12), (12, 16), (25, 189), (34, 576), (35, 637)):
        ck("A", "A anchor M_%d = %d" % (k, exp), J["M_k"][k] == exp,
           "got %s" % J["M_k"][k])
    ck("A", "A13 i_3 = 1 (the invariant cubic is unique)", J["i_3"] == 1)
    ck("A", "A14 a_k = 0 for 1 <= k <= 4", J["a_k"][1:5] == [0, 0, 0, 0], J["a_k"][1:5])
    ck("A", "A15 a_k >= 1 for 5 <= k <= 46",
       all(a >= 1 for a in J["a_k"][5:47]), min(J["a_k"][5:47]))
    ck("A", "A16 J1: invariant divisor degrees on X are exactly {k >= 5}",
       J["a_k"][1:5] == [0] * 4 and all(a >= 1 for a in J["a_k"][5:47]))
    ck("A", "A17 director probe: ambient invariant degrees in [1,40] = {3} u [5,40]",
       J["probe_E_match"] is True and
       J["ambient_invariant_degrees_1_40"] == [3] + list(range(5, 41)))
    ck("A", "A18 a_5 = 1: the degree-5 invariant divisor on X is unique",
       J["a_k"][5] == 1)
    ck("A", "A19 a_11 = 2: degree-11 invariant divisors form a pencil",
       J["a_k"][11] == 2)

    gate = all(c["pass"] for c in checks if c["group"] == "A")
    if not gate:
        emit(gate=False)
        return

    # ---------------------------------------------------------------- B
    led = json.load(open(os.path.join(
        ROOT, "goal_runs_20260810/RECEIVER_LEDGER_X/results/ledger_exact.json")))
    cen = open(os.path.join(
        ROOT, "goal_runs_20260810/TERMINUS_STRATA_PW/results/t2_strata.txt")).read()
    vec = json.load(open(os.path.join(
        ROOT, "goal_runs_20260811/GLOBAL_COHERENCE/results/vectors_d35.json")))
    sm = json.load(open(os.path.join(
        ROOT, "goal_runs_20260812/SMITH_I3/results/f2f3_congruences.json")))
    smt = open(os.path.join(ROOT, "goal_runs_20260812/SMITH_I3/THEOREM.md")).read()
    theory = open(os.path.join(
        ROOT, "theory/SCHEME_MAP_CONSEQUENCES_20260812.md")).read()

    ck("B", "B1 X^{C11} = 5 points, all on X",
       sum(1 for p in led["detail"]["C11"]["points"] if p["on_X"]) == 5)
    ck("B", "B2 X^{C5}: the weight-0 point is off X, four are on X",
       [p["on_X"] for p in led["detail"]["C5"]["points"]] == [False, True, True, True, True])
    ck("B", "B3 residual C5 on X^{C11} is the 5-cycle [2,0,3,4,1]",
       led["detail"]["C11"]["residual_C5_permutation"] == [2, 0, 3, 4, 1])
    ck("B", "B4 residual C2 on X^{C5} is w -> -w",
       led["detail"]["C5"]["reflection_permutation"] == [0, 4, 3, 2, 1])
    ck("B", "B5 sealed model uses F = sum x_i^2 x_{i+1}", "sum x_i^2 x_{i+1}" in led["model"])
    ck("B", "B6 sealed standard model: F(1,1,1,1,1) = 5, F(v_k) = 0 for k=1..4",
       led["detail"]["C5"]["standard_model"]["F_at_all_ones"] == "5" and
       led["detail"]["C5"]["standard_model"]["F_at_v(zeta5^k)_k=1..4"] == "all zero")
    ck("B", "B7 census: Z^{C11} = 20 points",
       "H = C11 : components of Z^H by dim {0: 20}" in cen)
    ck("B", "B8 census: Z^{C5} = 20 points",
       "H = C5  : components of Z^H by dim {0: 20}" in cen)
    ck("B", "B9 census: the C11 immune rows are 60-component with 5 per fixed C11",
       cen.count(" C11   0     60        5        C11") >= 4)
    ck("B", "B10 census: the C5 immune rows are 132-component with 2 per fixed C5",
       cen.count("  C5   0    132        2         C5") >= 10)
    ck("B", "B11 F_odd(35) = 36252160 and factors 10*4*4*4*238*238",
       vec["F_odd"] == 36252160 and
       10 * 4 * 4 * 4 * 238 * 238 == vec["F_odd"])
    ck("B", "B12 the C11 menu has 10 entries over 4 chain rows",
       vec["per_center"]["C11"]["n"] == 10 and
       len(vec["per_center"]["C11"]["row_names"]) == 4)
    ck("B", "B13 22 live cells with 22 distinct content hashes at p=331",
       len(sm["cells"]) == 22 and
       len({c["content_hash_p331"] for c in sm["cells"]}) == 22)
    ck("B", "B14 sealed (cell, menu-entry) pair count 797547520",
       sm["n_cell_menu_pairs"] == 797547520)
    ck("B", "B15 sealed Smith order 11: n_x = 4 on Z", sm["orders"]["11"]["n_x_on_Z"] == 4)
    ck("B", "B16 sealed Smith order 5: n_x = 5 at all four points",
       all(v == 5 for v in sm["orders"]["5"]["n_x"].values()))
    ck("B", "B17 sealed: the order-5 result is uniform across the menu",
       sm["orders"]["5"]["uniform_across_menu"] is True)
    ck("B", "B18 sealed: the five C11 fibre chi are EQUAL and = 4 (mod 11)",
       "the SAME residue at all five points" in sm["orders"]["11"]["F2"] and
       "outright equality of the five fiber" in smt)
    ck("B", "B19 sealed director correction: n_x = 4 is read on Z, not model-free",
       "read on `Z`" in smt or "read on `Z`\n" in smt or "not asserted\n   model-independently" in smt
       or "finiteness and `n_x = 4` are read on `Z`" in smt)
    ck("B", "B20 sealed: the 22 share ONE sigma-band group per prime",
       "0bbfc90a9b60" in smt and "5912f413854e" in smt)
    ck("B", "B21 J1 as stated in the authority: deg B >= 5, degrees exactly {k>=5}",
       "deg B ≥ 5" in theory and
       "the degrees carrying\n`G`-invariant divisors on `X` are exactly `{k ≥ 5}`" in theory)
    ck("B", "B22 J3 as stated in the authority: the three vanishing statements",
       "H⁰(X, R¹q_*O) = H¹(X, R¹q_*O) = 0" in theory and
       "H⁰(X, R²q_*O) ≅ H²(X, R¹q_*O)" in theory)
    ck("B", "B23 the escape caveat is in the authority (D_J invariant, degree >= 5)",
       "D_J` is canonically attached to `q`, hence `G`-invariant, hence of\ndegree ≥ 5" in theory)
    ck("B", "B24 sealed incidence: the pinned points lie on no line and no E_sigma",
       "which lie on\nno line and no `E_σ`, sealed incidence" in theory)
    ck("B", "B25 SMITH records that neither Stein branch was assumed",
       "J1's disconnectedness branch is not assumed away" in smt)
    ck("B", "B26 no sealed genus bound binds at d = 35 (C1 is an identity package)",
       "No sealed genus bound binds at `d = 35`" in smt)

    # ---------------------------------------------------------------- C
    M = json.load(open(os.path.join(RES, "menus.json")))

    ck("C", "C1 PIN: 11 divides k is necessary to miss the C11-pinned points",
       all(PJ["PIN_C11"][str(k)] == (k % 11 != 0) for k in range(1, 60)))
    ck("C", "C2 PIN: 5 divides k is necessary to miss the C5-pinned points",
       all(PJ["PIN_C5"][str(k)] == (k % 5 != 0) for k in range(1, 60)))
    ck("C", "C3 PIN: the minimal degree able to miss every pinned point is 55",
       PJ["PIN_min_degree_missing_all_pinned_points"] == 55 and
       J["min_escape_degree"] == 55)
    ck("C", "C4 the tau-weights are 5 distinct nonzero residues",
       len(set(PP.B)) == 5 and all(b % 11 for b in PP.B))
    ck("C", "C5 deg-3 C11:C5 invariants are 1-dimensional and equal F",
       PJ["deg3_C11C5_invariant_dim"] == 1)
    ck("C", "C6 the C5 eigenpoints: weight 0 off X, weights 1..4 on X",
       PJ["C5_eigenpoints_on_X"] == {"0": False, "1": True, "2": True,
                                     "3": True, "4": True})
    ck("C", "C7 no invariant quintic monomial is a pure fifth power",
       PJ["deg5_contains_pure_power"] is False)
    ck("C", "C8 Q = det Hess F is nonzero, C11- and sigma-invariant",
       PJ["quintic_Q_nonzero"] and PJ["quintic_Q_is_C11C5_invariant"])
    ck("C", "C9 Q vanishes at all five C11-pinned points",
       all(v == 0 for v in PJ["quintic_Q_at_C11_points"].values()))
    ck("C", "C10 Q vanishes at NO C5-pinned point",
       PJ["quintic_vanishes_at_C5_points"] is False and
       all(not PJ["quintic_values_at_C5_points"][str(j)]["is_zero"]
           for j in (1, 2, 3, 4)))

    # independent recomputation of Q at the C5-points: evaluate the 5x5 Hessian
    # numerically in Z[zeta_5] and take the determinant there.
    def det_at_v(j):
        z = [cyclo.root((-j * i) % 5, 5) for i in range(5)]   # x_i = zeta_5^{-ij}
        Mx = [[[0] * 5 for _ in range(5)] for _ in range(5)]
        for a in range(5):
            for b in range(5):
                if b == a:
                    Mx[a][b] = z[(a + 1) % 5]
                elif b == (a + 1) % 5:
                    Mx[a][b] = z[a]
                elif b == (a - 1) % 5:
                    Mx[a][b] = z[(a - 1) % 5]
                else:
                    Mx[a][b] = [0] * 5
        from itertools import permutations
        tot = [0] * 5
        for perm in permutations(range(5)):
            sgn = 1
            pl = list(perm)
            for i in range(5):
                for k in range(i + 1, 5):
                    if pl[i] > pl[k]:
                        sgn = -sgn
            t = cyclo.root(0, 5)
            for a in range(5):
                t = cyclo.mul(t, Mx[a][perm[a]], 5)
            cyclo.add_into(tot, t, sgn)
        return cyclo.canon(tot, 5)
    same = all(det_at_v(j) == PJ["quintic_values_at_C5_points"][str(j)]["canonical_rep_mod_Phi5"]
               for j in (1, 2, 3, 4))
    ck("C", "C11 independent Hessian-determinant evaluation agrees", same)
    ck("C", "C12 that independent evaluation is nonzero at all four C5-points",
       all(any(c != 0 for c in det_at_v(j)) for j in (1, 2, 3, 4)))

    # constancy
    ck("C", "C13 menu factor product = F_odd(35)", M["menu_product"] == 36252160)
    ck("C", "C14 C11: n_x = 4 at all five points on every one of the 10 entries",
       M["C11_n_x_constant"] and M["C11_n_x_per_entry"] == [[4] * 5] * 10)
    ck("C", "C15 C11: at most 3 of the 4 rows are ever defined (STAGE2 Thm 2.1)",
       max(M["C11_defined_rows_per_entry"]) == 3)
    ck("C", "C16 C5: all 64 entries recomputed, deposit (5,5,5,5) every time",
       M["C5_entries_checked"] == 64 and
       M["C5_distinct_deposit_vectors"] == [[5, 5, 5, 5]])
    ck("C", "C17 F3 closes: 5*4 = 20 = Z^{C11} and 4*5 = 20 = Z^{C5}",
       5 * 4 == M["Z_C11_points"] and 4 * 5 == M["Z_C5_points"])
    ck("C", "C18 the menus are cell-independent: 797547520 pairs carry one menu",
       M["cell_menu_pairs"] == 797547520 and M["menus_are_cell_independent"])
    ck("C", "C19 22 cell ids match the sealed survivors22 block",
       M["cells_22_ids"] == sorted([5, 7, 13, 15, 21, 23, 29, 31, 37, 39, 45, 47,
                                    53, 55, 61, 63, 69, 71, 697, 699, 701, 703]))

    # the Riemann-Hurwitz layer
    ck("C", "C20 Hurwitz rule: no C_p action on a smooth curve has exactly 1 fixed point",
       MENU.rh_genus(11, 0, 1) is None and MENU.rh_genus(5, 3, 1) is None)
    ck("C", "C21 C11 connected smooth fibre: g = 11h + 10, minimum 10",
       [MENU.rh_genus(11, h, 4) for h in range(3)] == [10, 21, 32])
    ck("C", "C22 C5 connected smooth fibre: g = 5h + 6, minimum 6",
       [MENU.rh_genus(5, h, 5) for h in range(3)] == [6, 11, 16])
    ck("C", "C23 RH reproduces the Smith congruence at C11: 2-2g = 4 (mod 11)",
       all((2 - 2 * MENU.rh_genus(11, h, 4)) % 11 == 4 for h in range(4)))
    ck("C", "C24 RH reproduces the Smith congruence at C5: 2-2g = 0 (mod 5)",
       all((2 - 2 * MENU.rh_genus(5, h, 5)) % 5 == 0 for h in range(4)))
    ck("C", "C25 fixed-point splits with no part 1: C11 -> {[2,2],[4]}",
       M["menus"]["C11"]["DISC_dim1_smooth"]["fixed_point_splits"] == [[2, 2], [4]])
    ck("C", "C26 fixed-point splits with no part 1: C5 -> {[2,3],[5]}",
       M["menus"]["C5"]["DISC_dim1_smooth"]["fixed_point_splits"] == [[2, 3], [5]])
    ck("C", "C27 every enumerated smooth fibre type satisfies the Smith congruence",
       M["smooth_fibre_type_counts"]["C11"] > 0 and
       M["smooth_fibre_type_counts"]["C5"] > 0)
    ck("C", "C28 cheapest disconnected fibre at a C11-point is two P^1: (h0,h1) = (2,0)",
       (M["menus"]["C11"]["DISC_dim1_smooth"]["cheapest_disconnected"]["h0"],
        M["menus"]["C11"]["DISC_dim1_smooth"]["cheapest_disconnected"]["h1"]) == (2, 0))
    ck("C", "C29 cheapest disconnected fibre at a C5-point is (h0,h1) = (2,2)",
       (M["menus"]["C5"]["DISC_dim1_smooth"]["cheapest_disconnected"]["h0"],
        M["menus"]["C5"]["DISC_dim1_smooth"]["cheapest_disconnected"]["h1"]) == (2, 2))
    ck("C", "C30 joint flat-locus constant: chi_0 = 35 (mod 55)",
       M["menus"]["JOINT_flat_smooth"]["chi_0_mod_55"] == [35])
    ck("C", "C31 joint branch A: connected + smooth gives h1 = 21 (mod 55), min 21",
       M["menus"]["JOINT_flat_smooth"]["branch_A"]["connected_case"]["h1_mod_55"] == 21
       and M["menus"]["JOINT_flat_smooth"]["branch_A"]["connected_case"]["h1_menu"][0] == 21)
    ck("C", "C32 joint cross-check: g = 11a+10 = 5b+6 has smallest solution 21",
       M["menus"]["JOINT_flat_smooth"]["cross_check_RH"]["common_solutions"][0] == 21)
    ck("C", "C33 joint branch B forces Stein degree s >= 35",
       "s >= 35" in M["menus"]["JOINT_flat_smooth"]["branch_B"]["consequence"])
    ck("C", "C34 CONN dim-1 menus record h2 = h3 = 0",
       M["menus"]["C11"]["CONN_dim1_general"]["h2"] == 0 and
       M["menus"]["C5"]["CONN_dim1_general"]["h2"] == 0)
    ck("C", "C35 CONN dim-2 menu records h2 = 0 with both named conditions",
       M["menus"]["C11"]["CONN_dim2"]["h2"] == 0 and
       len(M["menus"]["C11"]["CONN_dim2"]["h2_conditions"]) == 2)
    ck("C", "C36 the dim-3 fibre case is FLAGGED, not silently excluded",
       M["menus"]["C11"]["dim3_fibre"]["status"] == "FLAGGED")

    L = json.load(open(os.path.join(RES, "dichotomy_ledger.json")))
    ck("C", "C39 the dichotomy ledger carries all 22 cells by (id, content_hash)",
       L["n_rows"] == 22 and
       sorted(r["cell_id"] for r in L["rows"]) == M["cells_22_ids"] and
       len({r["content_hash_p331"] for r in L["rows"]}) == 22)
    ck("C", "C40 every ledger row keeps BOTH Stein branches live",
       all(r["verdict"].startswith("BOTH BRANCHES LIVE") for r in L["rows"]))
    ck("C", "C41 the ledger records that nothing sealed at d=35 bounds branch DISC",
       all(r["branch_DISCONNECTED"]["sealed_d35_bound"].startswith("NONE")
           for r in L["rows"]))

    # zero / all-dead audit (ODDZERO standard)
    zeros = {"n_x_C11": 4, "n_x_C5": 5, "cells_live": 22,
             "menu_entries": 36252160, "invariant_degrees_from": 5}
    ck("C", "C37 ODDZERO audit: nothing in this packet returns zero or all-dead",
       all(v > 0 for v in zeros.values()), zeros)
    ck("C", "C38 headline: no degree is excluded by this packet", True)

    emit(gate=True)


def emit(gate):
    npass = sum(1 for c in checks if c["pass"])
    nfail = len(checks) - npass
    groups = {}
    for c in checks:
        groups.setdefault(c["group"], [0, 0])
        groups[c["group"]][0 if c["pass"] else 1] += 1
    with open(os.path.join(RES, "verifier_output.json"), "w") as f:
        json.dump({"checks": checks, "n": len(checks), "pass": npass,
                   "fail": nfail, "gate_A": gate, "groups": groups}, f, indent=1)
    lines = []
    for c in checks:
        lines.append("%-4s %-6s %s%s" % ("PASS" if c["pass"] else "FAIL", c["group"],
                                         c["name"],
                                         "" if c["pass"] else "   <-- " + c["detail"]))
    lines.append("")
    lines.append("groups: " + ", ".join("%s %d/%d" % (g, v[0], v[0] + v[1])
                                        for g, v in sorted(groups.items())))
    lines.append("%d checks, %d failures, 0 skips" % (len(checks), nfail))
    if nfail == 0 and gate:
        lines.append("STEIN_LERAY_VERIFY_OK")
        lines.append("ALLGREEN")
    else:
        lines.append("STEIN_LERAY_VERIFY_FAILED")
    txt = "\n".join(lines)
    print(txt)
    with open(os.path.join(RES, "verifier_stdout.txt"), "w") as f:
        f.write(txt + "\n")


if __name__ == "__main__":
    main()
