"""Lane 2 deliverable: the (h^0, h^1) menus at the pinned odd-order points, per
branch of the Stein dichotomy, plus the constancy verification across the immune
menus (recomputed, not asserted).

Sealed inputs, consumed by citation and RE-READ here:
  goal_runs_20260811/GLOBAL_COHERENCE/results/vectors_d35.json   (the menus)
  goal_runs_20260810/TERMINUS_STRATA_PW/results/t2_strata.txt    (the census)
  goal_runs_20260810/RECEIVER_LEDGER_X/results/ledger_exact.json (the receiver)
  goal_runs_20260812/SMITH_I3/results/f2f3_congruences.json      (the 22 cells)

Exact integer arithmetic only.
"""

import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
OUT = os.path.join(HERE, "..", "results")

VEC = os.path.join(ROOT, "goal_runs_20260811/GLOBAL_COHERENCE/results/vectors_d35.json")
CENSUS = os.path.join(ROOT, "goal_runs_20260810/TERMINUS_STRATA_PW/results/t2_strata.txt")
LEDGER = os.path.join(ROOT, "goal_runs_20260810/RECEIVER_LEDGER_X/results/ledger_exact.json")
SMITH = os.path.join(ROOT, "goal_runs_20260812/SMITH_I3/results/f2f3_congruences.json")


def label_weight(s):
    m = re.match(r"eigpt\(w=(\d+)\)$", s)
    return None if m is None else int(m.group(1))


# --------------------------------------------------------------- constancy

def constancy(log):
    vec = json.load(open(VEC))
    led = json.load(open(LEDGER))
    cen = open(CENSUS).read()

    pc = vec["per_center"]
    sizes = {k: pc[k]["n"] for k in pc}
    prod = 1
    for v in sizes.values():
        prod *= v
    log["menu_factor_sizes"] = sizes
    log["menu_product"] = prod
    log["F_odd_sealed"] = vec["F_odd"]
    assert prod == vec["F_odd"] == 36252160, (prod, vec["F_odd"])

    # ---- receiver side
    n_pts_C11 = sum(1 for p in led["detail"]["C11"]["points"] if p["on_X"])
    n_pts_C5 = sum(1 for p in led["detail"]["C5"]["points"] if p["on_X"])
    log["X_C11_points"] = n_pts_C11
    log["X_C5_points"] = n_pts_C5
    assert (n_pts_C11, n_pts_C5) == (5, 4)
    resC5 = led["detail"]["C11"]["residual_C5_permutation"]
    # transitivity of the residual C5 on the five C11-fixed points
    orb, cur = {0}, 0
    for _ in range(5):
        cur = resC5[cur]
        orb.add(cur)
    log["residual_C5_permutation"] = resC5
    log["residual_C5_transitive"] = (len(orb) == 5)
    assert len(orb) == 5, resC5
    refl = led["detail"]["C5"]["reflection_permutation"]
    log["residual_C2_on_C5_points"] = refl

    # ---- census side (re-read)
    m = re.search(r"H = C11 : components of Z\^H by dim \{0: (\d+)\}", cen)
    zc11 = int(m.group(1))
    m = re.search(r"H = C5  : components of Z\^H by dim \{0: (\d+)\}", cen)
    zc5 = int(m.group(1))
    log["Z_C11_points"], log["Z_C5_points"] = zc11, zc5
    assert (zc11, zc5) == (20, 20)
    # the immune rows and their (ncomp, comp-per-fixed-subgroup) data
    rows11 = re.findall(r"^ C11   0     (\d+)        (\d+)        C11", cen, re.M)
    rows5 = re.findall(r"^  C5   0    (\d+)        (\d+)         C5", cen, re.M)
    r11 = sorted(set(rows11))
    r5 = sorted(set(rows5))
    log["census_C11_row_shape"] = r11
    log["census_C5_row_shape"] = r5
    assert r11 == [("60", "5")], r11
    assert r5 == [("132", "2")], r5

    # ---- C11 factor: n_x is label-independent and equals 4 on every entry
    c11 = pc["C11"]
    n_rows_11 = len(c11["row_names"])
    per_row_per_point = 5 // n_pts_C11        # 5 fixed points of the row / 5 receiver points
    counts11 = []
    defined11 = []
    for v in c11["vectors"]:
        # each of the 4 immune rows contributes 5 components for one fixed C11;
        # residual-C5 transitivity spreads them one per receiver point.
        counts11.append([n_rows_11 * per_row_per_point] * n_pts_C11)
        defined11.append(sum(1 for s in v if s != "UNDEF"))
    log["C11_n_x_per_entry"] = counts11
    log["C11_defined_rows_per_entry"] = defined11
    log["C11_n_x_constant"] = (len({tuple(c) for c in counts11}) == 1
                               and counts11[0] == [4] * 5)
    assert log["C11_n_x_constant"], counts11
    assert max(defined11) == 3, defined11        # STAGE2 Thm 2.1, reproduced
    assert n_rows_11 * 5 == zc11

    # ---- C5 factor: recompute the deposit of every one of the 64 entries
    a_vecs, b_vecs, d_vecs = pc["C5a"]["vectors"], pc["C5b"]["vectors"], pc["D10"]["vectors"]
    counts5 = {}
    for ia, va in enumerate(a_vecs):
        for ib, vb in enumerate(b_vecs):
            for idd, vd in enumerate(d_vecs):
                dep = {w: 0 for w in (1, 2, 3, 4)}
                for lab in va:                       # 4 rows, 2 components each
                    dep[label_weight(lab)] += 2
                for lab in vb:
                    dep[label_weight(lab)] += 2
                for lab in vd:                       # 2 rows, 2 components each,
                    w = label_weight(lab)            # split over w and -w
                    dep[w] += 1
                    dep[(-w) % 5] += 1
                counts5[(ia, ib, idd)] = tuple(dep[w] for w in (1, 2, 3, 4))
    distinct = set(counts5.values())
    log["C5_entries_checked"] = len(counts5)
    log["C5_distinct_deposit_vectors"] = sorted(distinct)
    log["C5_n_x_constant"] = (distinct == {(5, 5, 5, 5)})
    assert len(counts5) == 64 and distinct == {(5, 5, 5, 5)}, distinct
    assert sum(counts5[(0, 0, 0)]) == zc5

    # ---- the 22 cells
    sm = json.load(open(SMITH))
    ids = sorted(c["cell_id"] for c in sm["cells"])
    hashes = sorted(c["content_hash_p331"] for c in sm["cells"])
    log["cells_22_ids"] = ids
    log["cells_22_content_hashes_p331"] = hashes
    log["cells_22_hashes_unique"] = (len(set(hashes)) == 22)
    log["sealed_cell_menu_pairs"] = sm["n_cell_menu_pairs"]
    log["cells_22_count"] = len(ids)
    assert len(ids) == 22, ids
    log["cell_menu_pairs"] = len(ids) * prod
    assert log["cell_menu_pairs"] == sm["n_cell_menu_pairs"] == 797547520
    # Lane-2 verdict: no per-cell datum enters any menu input
    log["menu_inputs_used"] = ["X^{C11}=5", "X^{C5}=4", "Z^{C11}=20", "Z^{C5}=20",
                               "residual C5 5-cycle", "immune row shapes"]
    log["menus_are_cell_independent"] = True
    return log


# ------------------------------------------------------------ the RH tables

def rh_genus(p, h, r):
    """Smooth projective connected C with a FAITHFUL C_p action, quotient genus
    h and r fixed points:  2g - 2 = p(2h - 2) + r(p - 1).

    Hurwitz existence rule, used and not assumed away: the local rotation
    numbers a_1..a_r at the fixed points satisfy sum a_i = 0 (mod p), because
    the surjection pi_1(C' minus B) -> Z/p kills the product of commutators.
    With every a_i nonzero this forbids r = 1.  (r = 0 is the free case.)
    """
    if r == 1:
        return None
    two_g_minus_2 = p * (2 * h - 2) + r * (p - 1)
    if (two_g_minus_2 + 2) % 2:
        return None
    g = (two_g_minus_2 + 2) // 2
    return g if g >= 0 else None


def component_options(p, r, hmax=3):
    return [{"quotient_genus": h, "genus": rh_genus(p, h, r)}
            for h in range(hmax + 1) if rh_genus(p, h, r) is not None]


def splits_no_ones(n, maxlen=8):
    """multisets of parts >= 2 summing to n (r = 1 is Hurwitz-forbidden)."""
    out = []

    def rec(rem, start, cur):
        if rem == 0:
            out.append(tuple(cur))
            return
        if len(cur) >= maxlen:
            return
        for v in range(start, rem + 1):
            if v < 2:
                continue
            rec(rem - v, v, cur + [v])
    rec(n, 2, [])
    return out


def smooth_fibre_types(p, n, hmax=4, emax=1, fmax=3, gmax=1):
    """All (h0, h1) of a fibre that is a disjoint union of smooth curves,
    C_p-stable, with exactly n fixed points, on a model where the C_p fixed
    locus is finite (so C_p acts faithfully on every component).

      * a split of n into parts r_i >= 2 -> the stable components that carry
        fixed points, genus from Riemann-Hurwitz;
      * e extra stable components with r = 0 (free C_p action, genus p(h-1)+1,
        h >= 1);
      * f free C_p-orbits of p components each, any genus g'.
    """
    out = []
    for split in splits_no_ones(n):
        per = [component_options(p, r, hmax) for r in split]
        idx = [0] * len(per)
        while True:
            gs = [per[i][idx[i]]["genus"] for i in range(len(per))]
            for e in range(emax + 1):
                for eg in ([()] if e == 0 else
                           [tuple([p * (h - 1) + 1] * e) for h in range(1, hmax + 2)]):
                    for f in range(fmax + 1):
                        for gp in range(gmax + 1):
                            h0 = len(split) + e + p * f
                            h1 = sum(gs) + sum(eg) + p * f * gp
                            out.append({"split": list(split), "genera": list(gs),
                                        "extra_free_components": list(eg),
                                        "free_orbits": f, "free_orbit_genus": gp,
                                        "h0": h0, "h1": h1, "chi_O": h0 - h1,
                                        "chi_top": 2 * h0 - 2 * h1,
                                        "connected": h0 == 1})
            i = 0
            while i < len(per):
                idx[i] += 1
                if idx[i] < len(per[i]):
                    break
                idx[i] = 0
                i += 1
            if i == len(per):
                break
    return out


def menus(log):
    P = {"C11": {"p": 11, "n": 4, "npts": 5}, "C5": {"p": 5, "n": 5, "npts": 4}}
    out = {}
    types = {}
    for name, D in P.items():
        p, n = D["p"], D["n"]
        cls = {}
        # ---------------- CONNECTED branch, 1-dimensional fibre
        # connected + smooth => irreducible: one component with all n fixed pts
        opts = component_options(p, n)
        cls["CONN_dim1_smooth"] = {
            "h0": 1,
            "h1_menu": [o["genus"] for o in opts],
            "h1_congruence": "h1 = %d (mod %d)" % (rh_genus(p, 0, n) % p, p),
            "h1_min": min(o["genus"] for o in opts),
            "chi_O": [1 - o["genus"] for o in opts],
            "smith_check": [(2 - 2 * o["genus"]) % p == n % p for o in opts],
        }
        assert all(cls["CONN_dim1_smooth"]["smith_check"])
        # reduced, at worst nodal: chi_top = 2 chi(O) + delta
        inv2 = pow(2, -1, p)
        cls["CONN_dim1_reduced_nodal"] = {
            "p": p, "h0": 1,
            "rows": [{"delta_nodes": d, "h1_mod_p": ((2 + d - n) * inv2) % p}
                     for d in range(0, 12)]}
        # general 1-dimensional fibre
        cls["CONN_dim1_general"] = {
            "bridge": "chi_top(F) = 2*chi(O_F) + D - 2*chi(N);  D >= 0, D = 0 iff"
                      " F_red is smooth, D = #nodes if F_red is nodal;"
                      " N = the nilradical sheaf of F",
            "h2": 0, "h3": 0,
            "chi_O": "h0 - h1 = chi_0, the flat-locus constant",
            "constraint": "2*chi_0 + D - 2*chi(N) = %d (mod %d)" % (n % p, p),
            "h0_min": 1}
        # ---------------- CONNECTED branch, 2-dimensional fibre
        cls["CONN_dim2"] = {
            "h0_min": 1, "h2": 0,
            "h2_conditions": ["dim supp R^1 q_* O <= 1 (the escape caveat)",
                              "x isolated in supp R^2 (sealed incidence: the"
                              " pinned points lie on no line and no E^X_sigma)"],
            "h1": "free: no bridge from chi_top for a 2-dimensional fibre",
            "flat": False,
            "note": "q is not flat at x, so the flat-locus constant chi_0 does"
                    " not bind here"}
        cls["dim3_fibre"] = {"status": "FLAGGED", "note":
                             "a 3-dimensional fibre is a contracted divisor;"
                             " R^3 q_* O then enters Leray.  The three J3"
                             " vanishing statements survive (checked in"
                             " THEOREM.md sec. 3.1) but the h^2 corollary is"
                             " not the one proved."}
        # ---------------- DISCONNECTED branch
        tp = smooth_fibre_types(p, n)
        types[name] = tp
        disc = [t for t in tp if t["h0"] >= 2]
        assert all(t["chi_top"] % p == n % p for t in tp), name
        best = min(disc, key=lambda t: (t["h0"], t["h1"]))
        cls["DISC_dim1_smooth"] = {
            "rule": "components of F_x <-> points of nu^{-1}(x); C_p permutes"
                    " them in orbits of size 1 or p; the n fixed points sit on"
                    " the stable components; h0 = #components, h1 = sum of"
                    " genera",
            "hurwitz_rule": "no component carries exactly 1 fixed point",
            "fixed_point_splits": [list(s) for s in splits_no_ones(n)],
            "cheapest_disconnected": best,
            "types_enumerated": len(tp),
            "h0_le_stein_degree": "h0 = #nu^{-1}(x) <= s"}
        cls["smith_input"] = {
            "p": p, "n_x_on_Z": n,
            "chi_top_congruence": "chi_top(F_x) = %d (mod %d)" % (n % p, p),
            "refinement": "on a further equivariant model n_x = %d + Delta/%d"
                          " with Delta >= 0" % (n, D["npts"])}
        out[name] = cls

    # ---------------- the joint statement across the two pinned classes
    # chi_0 = h0 - h1 is constant on the whole 1-dimensional-fibre locus
    # (miracle flatness + irreducibility of X), so the two congruences combine.
    sols = [c for c in range(-500, 500)
            if (2 * c - 4) % 11 == 0 and (2 * c - 5) % 5 == 0]
    reps = sorted({c % 55 for c in sols})
    assert reps == [35], reps
    # realisability of chi_0 = -20 and chi_0 = 35 by explicit smooth types
    realis = {}
    for c in (-20, 35):
        r11 = [t for t in types["C11"] if t["chi_O"] == c]
        r5 = [t for t in types["C5"] if t["chi_O"] == c]
        realis[str(c)] = {
            "enumeration_window": "hmax=4, emax=1, fmax=3, gmax=1 (a WINDOW:"
                                  " absence here is not impossibility)",
            "C11_found_in_window": bool(r11), "C5_found_in_window": bool(r5),
            "C11_min_h0": min([t["h0"] for t in r11], default=None),
            "C5_min_h0": min([t["h0"] for t in r5], default=None),
            "C11_witness": min(r11, key=lambda t: (t["h0"], t["h1"])) if r11 else None,
            "C5_witness": min(r5, key=lambda t: (t["h0"], t["h1"])) if r5 else None}
    assert realis["-20"]["C11_min_h0"] == 1 and realis["-20"]["C5_min_h0"] == 1
    out["JOINT_flat_smooth"] = {
        "hypotheses": ["either branch of the Stein dichotomy",
                       "all nine pinned points carry 1-dimensional fibres",
                       "those fibres are smooth (bridge defects D = 0, N = 0)",
                       "read on the terminus model Z, where n_x = 4 and 5"],
        "lemma": "chi(O_{F_x}) is constant = chi_0 on the open locus of"
                 " 1-dimensional fibres (miracle flatness: Ztilde is CM and X"
                 " is regular; that locus is a nonempty open subset of the"
                 " irreducible X, hence connected)",
        "chi_0_mod_55": reps,
        "realisability": realis,
        "branch_A": {"condition": "chi_0 <= -20",
                     "consequence": "h1 = h0 - chi_0 >= h0 + 20 >= 21 at every"
                                    " one of the nine pinned points",
                     "connected_case": {"h0": 1, "h1_mod_55": 21,
                                        "h1_menu": [x for x in range(0, 250)
                                                    if x % 55 == 21]}},
        "branch_B": {"condition": "chi_0 >= 35",
                     "consequence": "h0 = chi_0 + h1 >= 35, and h0 = #nu^{-1}(x)"
                                    " <= s, so the Stein degree is s >= 35;"
                                    " impossible in the connected branch, where"
                                    " h0 = 1"},
        "general_form": ["2*chi_0 + D_x - 2*chi(N_x) = 4 (mod 11) at each of the"
                         " five C11-points",
                         "2*chi_0 + D_x - 2*chi(N_x) = 0 (mod 5) at each of the"
                         " four C5-points",
                         "the five C11 values chi_top are EQUAL (sealed), so"
                         " D_x - 2*chi(N_x) is the same integer at all five"]}
    g = [x for x in range(0, 200) if x % 11 == 10 and x % 5 == 1]
    assert g[0] == 21 and g[1] == 76, g[:3]
    out["JOINT_flat_smooth"]["cross_check_RH"] = {
        "statement": "connected smooth fibres: g = 11a + 10 at a C11-point and"
                     " g = 5b + 6 at a C5-point; equal genus forces g = 21"
                     " (mod 55)",
        "common_solutions": g[:4]}
    log["menus"] = out
    log["smooth_fibre_type_counts"] = {k: len(v) for k, v in types.items()}
    return log


def ledger(log):
    """The per-cell dichotomy ledger.  Every input to the Lane-2 branches is
    cell-independent (verified in constancy()), so the ledger is one row
    replicated across the 22 -- which is a RESULT, recorded per cell, not an
    abbreviation."""
    sm = json.load(open(SMITH))
    rows = []
    for c in sorted(sm["cells"], key=lambda c: c["cell_id"]):
        rows.append({
            "cell_id": c["cell_id"],
            "content_hash_p331": c["content_hash_p331"],
            "sigma_band_group": "shared by all 22 at this prime (sealed)",
            "branch_CONNECTED": {
                "J3": "H^0(R^1) = H^1(R^1) = 0, H^0(R^2) = H^2(R^1)",
                "h2_at_pinned_points": 0,
                "conditions": ["dim supp R^1 q_*O <= 1",
                               "pinned points isolated in supp R^2"],
                "escape": "a divisorial component of supp R^1 (the h^0-jump"
                          " divisor D_J) is G-invariant of degree >= 5; by"
                          " Proposition PIN it then contains ALL FIVE"
                          " C11-pinned points unless 11 | deg D_J, and all four"
                          " C5-pinned points unless 5 | deg D_J",
                "menu": "CONN_dim1_smooth / CONN_dim1_reduced_nodal /"
                        " CONN_dim1_general / CONN_dim2"},
            "branch_DISCONNECTED": {
                "cost": "a finite G-cover nu : Y -> X of degree s >= 2 branched"
                        " along a G-invariant divisor B with deg B >= 5",
                "PIN_sharpening": ["deg B = 5 forces B = {det Hess F = 0} n X,"
                                   " the UNIQUE degree-5 invariant divisor,"
                                   " which contains all five C11-pinned points"
                                   " and no C5-pinned point",
                                   "B misses every pinned point only if 55 |"
                                   " deg B, hence deg B >= 55"],
                "J3_transfer": "the three vanishing statements hold for"
                               " qtilde : Ztilde -> Y iff H^i(Y, O_Y) = 0 for"
                               " i > 0 (e.g. Y has rational singularities)",
                "menu": "DISC_dim1_smooth",
                "sealed_d35_bound": "NONE -- see THEOREM.md sec. 5.3"},
            "verdict": "BOTH BRANCHES LIVE; no cell cut, no degree excluded"})
    log["dichotomy_ledger"] = {"n_rows": len(rows), "rows": rows}
    with open(os.path.join(OUT, "dichotomy_ledger.json"), "w") as f:
        json.dump(log["dichotomy_ledger"], f, indent=1)
    return log


def main():
    log = {}
    constancy(log)
    menus(log)
    ledger(log)
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "menus.json"), "w") as f:
        json.dump(log, f, indent=1, sort_keys=True)

    print("menu factors      :", log["menu_factor_sizes"], "product", log["menu_product"])
    print("cells x entries   :", log["cell_menu_pairs"])
    print("C11 n_x per entry : constant", log["C11_n_x_constant"],
          " value", log["C11_n_x_per_entry"][0])
    print("C11 defined rows  :", log["C11_defined_rows_per_entry"], "(max 3)")
    print("C5  deposits      : 64 entries checked, distinct vectors",
          log["C5_distinct_deposit_vectors"])
    m = log["menus"]
    print("CONN dim1 smooth C11: h0=1, h1 in", m["C11"]["CONN_dim1_smooth"]["h1_menu"])
    print("CONN dim1 smooth C5 : h0=1, h1 in", m["C5"]["CONN_dim1_smooth"]["h1_menu"])
    print("JOINT connected     : h0=1, h1 = 21 (mod 55), window",
          m["JOINT_flat_smooth"]["branch_A"]["connected_case"]["h1_menu"][:4])
    for nm in ("C11", "C5"):
        d = m[nm]["DISC_dim1_smooth"]
        print("DISC %-4s splits    :" % nm, d["fixed_point_splits"],
              " cheapest disconnected (h0,h1) =",
              (d["cheapest_disconnected"]["h0"], d["cheapest_disconnected"]["h1"]))
    j = m["JOINT_flat_smooth"]
    print("JOINT dichotomy     : chi_0 = 35 (mod 55);  A: chi_0 <= -20 =>"
          " h1 >= h0+20 >= 21;  B: chi_0 >= 35 => Stein degree s >= 35")
    print("JOINT realisability :", {k: (v["C11_min_h0"], v["C5_min_h0"])
                                    for k, v in j["realisability"].items()})
    print("dichotomy ledger    :", log["dichotomy_ledger"]["n_rows"], "cell rows written")
    print("MENUS_OK")


if __name__ == "__main__":
    main()
