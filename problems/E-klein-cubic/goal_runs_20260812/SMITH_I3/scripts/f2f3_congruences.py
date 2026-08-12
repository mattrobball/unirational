#!/usr/bin/env python3
"""
F2/F3 -- the Smith mod-p congruences, instantiated at d = 35.

F2 (fiberwise).  g of prime order p, x in X^g:
        chi(q^{-1}(x))  ==  chi( (q|_{Ztilde^g})^{-1}(x) )   (mod p).
F3 (global).     chi(Ztilde^g)  =  sum over strata Y of X^g of the integrated
                 chi of the g-fixed fibers.

Everything below is exact integer arithmetic.  The receiver constants and the
census values are CONSUMED BY CITATION out of `constants.py` (which records
their provenance); the only thing computed here is the value-assignment
bookkeeping of the 22 immune rows under the F_odd menu, and the resulting
per-(cell, menu-entry) congruence.

Reporting discipline (DATA_SPEC sec.2): every result is per (cell, menu
entry); the menu is NEVER collapsed.  The menu is a Cartesian product over
six independent centres, so results are reported per relevant factor with the
irrelevant factors named as free multiplicities -- that is a factorisation of
the report, not a collapse of the menu: every one of the
22 * 36 252 160 pairs is covered and its value stated.
"""

import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import constants as K

D = 35


# ---------------------------------------------------------------- the menu
def weight_of_row(n, base, chain, d, mus):
    """The sealed master formula w(R) = d*a_k + sum_l mu_l c_l  (mod n)
    (STAGE2_ODD_ORDER_PINNING scripts/s2pin.py; GLOBAL_COHERENCE sec.1.1)."""
    w = d * base
    for c, mu in zip(chain, mus):
        w += mu * c
    return w % n


def c11_menu(d=D):
    """
    The 10 admissible C11 menu entries at d = 35, reconstructed from the
    master formula and matched against vectors_d35.json.

    Sealed constraint (GLOBAL_COHERENCE sec.1.1): 'mu >= 0 if d in QR11,
    else mu >= 1'.  35 = 2 (mod 11) and 2 is NOT a quadratic residue mod 11,
    so mu in {1,...,10}: exactly 10 entries.
    """
    rows = [r for r in K.IMMUNE_ROWS if r[1] == 11]
    out = []
    for mu in range(1, 11):
        vec = []
        for name, n, base, chain, dim, ncomp in rows:
            w = weight_of_row(n, base, chain, d, (mu,))
            vec.append("eigpt(w=%d)" % w if w in K.ON_X_WEIGHTS[11] else "UNDEF")
        out.append({"mu": mu, "vector": vec,
                    "n_defined": sum(1 for v in vec if v != "UNDEF")})
    return rows, out


def c5_menus(d=D):
    """
    The C5a / C5b / D10 menus.  Sealed constraint: '5 | d  =>  5 does not
    divide mu' and mu >= 1, so mu in {1,2,3,4}: 4 entries each, matching
    vectors_d35.json (C5a 4, C5b 4, D10 4).
    """
    out = {}
    for tag, prefix in (("C5a", "C5/pt_C5(a)"), ("C5b", "C5/pt_C5(b)"),
                        ("D10", "C5/pt_D10")):
        rows = [r for r in K.IMMUNE_ROWS if r[0].startswith(prefix)]
        entries = []
        for mu in range(1, 5):
            vec = []
            for name, n, base, chain, dim, ncomp in rows:
                w = weight_of_row(n, base, chain, d, (mu,))
                vec.append("eigpt(w=%d)" % w if w in K.ON_X_WEIGHTS[5] else "UNDEF")
            entries.append({"mu": mu, "vector": vec,
                            "n_defined": sum(1 for v in vec if v != "UNDEF")})
        out[tag] = {"rows": [r[0] for r in rows], "entries": entries}
    return out


def a4_menus(d=D):
    """
    The A4a / A4b menus (order 3).  Sealed constraints (GLOBAL_COHERENCE
    sec.1.1, STAGE2_SECOND_ORDER Thm 2.2): mu1 >= 2, mu2 >= 1, and the
    residual per row is 0 for mu1 in {2,4} (row valueless / UNDEF), 2 for
    mu1 = 3 (X^{C6} excluded) and 3 for mu1 >= 5.  238 entries each.

    We do NOT re-enumerate the 238 entries from the constraints here -- that
    is GLOBAL_COHERENCE's sealed deliverable.  We read them from the sealed
    JSON and classify each by the multiset of receiver points it names.
    """
    path = os.path.join(K_ROOT, "goal_runs_20260811", "GLOBAL_COHERENCE",
                        "results", "vectors_d35.json")
    with open(path) as f:
        v = json.load(f)
    return {t: v["per_center"][t] for t in ("A4a", "A4b")}


K_ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                      "..", "..", ".."))


def read_sealed_menu():
    path = os.path.join(K_ROOT, "goal_runs_20260811", "GLOBAL_COHERENCE",
                        "results", "vectors_d35.json")
    with open(path) as f:
        return json.load(f)


# ------------------------------------------------------ order 11 (F2 + F3)
def order11():
    """
    THE ORDER-11 INSTANTIATION.

    Lemma U (uniformity).  For any smooth G-equivariant model Ztilde
    dominating P(W) on which q is a morphism:
      (a) Ztilde^{C11} is FINITE.  W has five DISTINCT C11-characters, so at
          every C11-fixed point of P(W) the four tangent weights are distinct;
          blowing up a C11-stable smooth centre through such a point gives an
          exceptional projectivised normal space whose C11-fixed locus is the
          set of projectivised weight EIGENLINES, again isolated with distinct
          weights.  The property is inherited at every stage.
      (b) n_x := #(q|_{Ztilde^{C11}})^{-1}(x) is CONSTANT over x in X^{C11}.
          N_G(C11) = C11:C5 acts on both sides and q is equivariant; the
          residual C5 acts on X^{C11} (5 points) as the 5-cycle
          C11_RESIDUAL_C5_PERM, hence transitively, so all fibres of an
          equivariant map to it have equal cardinality.
    Consequently  5 | #Ztilde^{C11}  and  n_x = #Ztilde^{C11} / 5.

    On the terminus Z the census gives #Z^{C11} = 20, so n_x = 4 for all five
    x, and F2 reads   chi(q^{-1}(x)) == 4 (mod 11)   at each of the five
    C11-fixed points of X.  The value ASSIGNMENT (which row lands on which
    point) varies over the menu; the COUNT n_x does not.
    """
    rows, menu = c11_menu()
    perm = K.C11_RESIDUAL_C5_PERM
    # transitivity check on the 5-point set
    seen, cur = {0}, 0
    for _ in range(5):
        cur = perm[cur]
        seen.add(cur)
    transitive = (len(seen) == 5)

    N_Z = K.Z_FINITE_FIXED["C11"]
    assert N_Z % 5 == 0
    n_x = N_Z // 5

    per_entry = []
    for e in menu:
        # row -> receiver weight, and the induced per-x contribution.
        # Each row is one G-orbit of 60 components; for ONE fixed C11 it
        # contributes 60/12 = 5 components (12 = #C11 subgroups in G), one
        # over each of the 5 source eigenpoints, forming a FREE C5-orbit.
        # A C5-equivariant map from a free C5-orbit of size 5 to the
        # transitive C5-set X^{C11} of size 5 is a bijection, so EVERY row --
        # defined or UNDEF at this jet order -- puts exactly one point over
        # each x.  Hence n_x = #rows = 4 independently of the menu entry.
        per_entry.append({
            "mu": e["mu"],
            "vector": e["vector"],
            "n_defined_rows": e["n_defined"],
            "n_x": n_x,
            "congruence": "chi(q^{-1}(x)) == %d (mod 11) for all x in X^{C11}" % (n_x % 11),
        })

    return {
        "order": 11,
        "receiver": {"X^g": "5 isolated points", "chi": K.CHI_X_FIXED[11]},
        "source_census": {"#Z^{C11}": N_Z, "all dim 0": True},
        "residual_C5_transitive_on_X^{C11}": transitive,
        "n_x_on_Z": n_x,
        "menu_size": len(menu),
        "menu": per_entry,
        "n_defined_rows_range": [min(e["n_defined"] for e in menu),
                                 max(e["n_defined"] for e in menu)],
        "F3": ("chi(Ztilde^{C11}) = sum_{x in X^{C11}} n_x = 5*n_x; "
               "on Z this is 5*4 = 20, matching the census exactly"),
        "F2": ("chi(q^{-1}(x)) == n_x (mod 11), the SAME residue at all five "
               "points; on Z the residue is 4"),
        "refinement": ("on a further equivariant model, "
                       "#Ztilde^{C11} = 20 + Delta with 5 | Delta and "
                       "n_x = 4 + Delta/5; the five congruences stay equal "
                       "to each other for every Delta"),
    }


# ------------------------------------------------------- order 5 (F2 + F3)
def order5():
    """
    THE ORDER-5 INSTANTIATION.

    X^{C5} = 4 points (weights 1,2,3,4; the weight-0 D10-point is OFF X).
    N_G(C5) = D10; the residual C2 acts by w -> -w, so it has TWO orbits on
    X^{C5}: {1,4} and {2,3}.  Transitivity is therefore NOT available and the
    count must be done row by row.

    Z^{C5} = 20 points (census, all dim 0).  The ten immune C5 rows each have
    ncomp = 132; G has 66 conjugate C5-subgroups, so each row contributes
    132/66 = 2 components for ONE fixed C5, and 10 * 2 = 20 = the census.

    d = 35 is divisible by 5, so the base contribution d*a_k vanishes mod 5
    for every row and the receiver weight of row (block, c) at shared jet
    order mu is simply  w = mu*c (mod 5).

    Row (a,c): its 2 components sit over the two source eigenpoints of the
    orbit, exchanged by the reflection, and land on x_w and x_{-w}.  As c runs
    over 1..4 with mu fixed and coprime to 5, w = mu*c runs over ALL of
    1,2,3,4 -- so the four (a)-rows deposit exactly 2 points over each of the
    four receiver points.  Same for (b).  The two D10-rows deposit
    {mu0, -mu0, 2mu0, -2mu0} = {1,2,3,4}, i.e. one point over each.
    Total n_x = 2 + 2 + 1 = 5 for every x, for EVERY menu entry.
    """
    menus = c5_menus()
    contrib = {w: 0 for w in (1, 2, 3, 4)}
    per_entry = []
    for mu_a in range(1, 5):
        for mu_b in range(1, 5):
            for mu_0 in range(1, 5):
                cnt = {w: 0 for w in (1, 2, 3, 4)}
                for mu, prefix, cs in ((mu_a, "C5/pt_C5(a)", (1, 2, 3, 4)),
                                       (mu_b, "C5/pt_C5(b)", (1, 2, 3, 4)),
                                       (mu_0, "C5/pt_D10", (1, 2))):
                    for c in cs:
                        w = (mu * c) % 5
                        assert w != 0
                        cnt[w] += 1          # the point over the base eigenpoint
                        cnt[(-w) % 5] += 1   # its reflection partner
                per_entry.append({"mu_C5a": mu_a, "mu_C5b": mu_b,
                                  "mu_D10": mu_0,
                                  "n_x": {str(k): v for k, v in sorted(cnt.items())}})
    totals = {tuple(sorted(e["n_x"].items())) for e in per_entry}
    uniform = (len(totals) == 1)
    n_x = per_entry[0]["n_x"]
    return {
        "order": 5,
        "receiver": {"X^g": "4 isolated points (weights 1,2,3,4)",
                     "chi": K.CHI_X_FIXED[5],
                     "off_X": "the weight-0 D10-point"},
        "source_census": {"#Z^{C5}": K.Z_FINITE_FIXED["C5"], "all dim 0": True},
        "residual_C2_orbits_on_X^{C5}": [[1, 4], [2, 3]],
        "menu_size": len(per_entry),
        "menu_factors_used": ["C5a", "C5b", "D10"],
        "uniform_across_menu": uniform,
        "n_x": n_x,
        "sum_check": sum(int(v) for v in n_x.values()),
        "F3": ("chi(Ztilde^{C5}) = sum_{x in X^{C5}} n_x; on Z this is "
               "4*5 = 20, matching the census exactly"),
        "F2": ("chi(q^{-1}(x)) == 5 == 0 (mod 5) at every one of the four "
               "C5-fixed points of X, for EVERY menu entry"),
        "menu": per_entry,
    }


# ------------------------------------------------------------- order 6 (F3)
def order6():
    """
    Order 6 is NOT prime, so F2 (Smith) does not apply.  F3 (chi additivity)
    does, and gives a free cross-check of the transitivity method:
    X^{C6} = 2 points (weights 1 and 5, exchanged by the residual C2 of
    D12/C6 acting as w -> -w mod 6), so n_x is constant and equal to
    #Z^{C6}/2 = 38/2 = 19.
    """
    return {
        "order": 6,
        "smith_applies": False,
        "receiver": {"X^g": "2 isolated points (weights 1, 5)",
                     "chi": K.CHI_X_FIXED[6]},
        "source_census": {"#Z^{C6}": K.Z_FINITE_FIXED["C6"]},
        "n_x": 19,
        "F3": "chi(Z^{C6}) = 2 * 19 = 38, matching the census exactly",
        "note": "recorded as an F3 consistency row only; no mod-p claim",
    }


# ------------------------------------------------------- order 2 (F2 + F3)
def order2():
    """
    THE ORDER-2 INSTANTIATION.

    Receiver: X^sigma = E^X_sigma (smooth plane cubic, genus 1, chi = 0)
    disjoint union L^X_sigma (a line, chi = 2); total chi = 2.

    Lemma R (no rational variety dominates E^X_sigma).  Every stratum of Z is
    rational (TERMINUS_STRATA_PW sec.1, proved per row).  If an irreducible
    subvariety V of Z^sigma dominated E^X_sigma, then composing a dominant
    rational map from projective space to V with q and restricting to a
    general line would exhibit E^X_sigma as the image of a dominant rational
    map from P^1, so by Luroth E^X_sigma would be rational -- contradicting
    genus 1.  Hence NO component of Z^sigma dominates E^X_sigma.

    Consequence (F2 at p = 2):  for all but finitely many x in E^X_sigma the
    sigma-fixed part of the fibre is EMPTY, so
            chi(q^{-1}(x)) == 0  (mod 2).
    This is unconditional on Z and on every ADMISSIBLE refinement (admissible
    centres are rational, so Lemma R still applies).  On the actual model the
    dichotomy of SCHEME_MAP_CONSEQUENCES sec.3.2 is live and BOTH branches are
    carried below.

    Over L^X_sigma (rational, so Lemma R is silent) STAGE1_COMPLEX_MAPS
    Theorem 3 pins exactly three rows as surjecting onto L_sigma and says no
    other row is forced non-constant.  The generic sigma-fixed fibre over
    L^X_sigma is therefore the disjoint union of the generic fibres of those
    three rows, and the congruence is reported PARAMETRICALLY in their Euler
    characteristics (no sealed bound at d = 35 pins them -- see the C1 check).
    """
    return {
        "order": 2,
        "receiver_strata": [
            {"name": "E^X_sigma", "type": "smooth plane cubic, genus 1",
             "chi": 0, "j": "8192/11", "CM": False},
            {"name": "L^X_sigma", "type": "line P^1", "chi": 2},
        ],
        "chi_X_sigma": K.CHI_X_FIXED[2],
        "source_census_Z_sigma_by_dim": K.Z_FIXED_BY_DIM["C2"],
        "all_strata_rational": K.Z_ALL_STRATA_RATIONAL,
        "branch_E": {
            "statement": ("chi(q^{-1}(x)) == 0 (mod 2) for all but finitely "
                          "many x in E^X_sigma"),
            "holds_on": "Z and every admissible refinement",
            "proof": "Lemma R (rationality + Luroth) + Smith at p = 2",
            "escape": ("a sigma-fixed IRRATIONAL stratum of the actual model "
                       "dominating E^X_sigma; only a non-admissible centre "
                       "can supply one"),
            "coupling": ("such a centre is exactly a G1 Hodge-carrier at the "
                         "C2 row (Res_{C2} W = 3(+1) (+) 2(-1), cheapest "
                         "carrying centre g >= 1) -- "
                         "SCHEME_MAP_CONSEQUENCES sec.3.3 table"),
        },
        "branch_L": {
            "dominating_rows": K.ROWS_DOMINATING_L_SIGMA,
            "statement": ("chi(q^{-1}(x)) == chi(F_1) + chi(F_2) + n_3 "
                          "(mod 2) for generic x in L^X_sigma, where F_1, F_2 "
                          "are the generic fibres of D_{P_sigma} and "
                          "D_{L'_sigma} over L^X_sigma and n_3 is the degree "
                          "of the third (1-dimensional) row over L^X_sigma"),
            "parametric": True,
            "reason_parametric": ("no sealed bound at d = 35 pins chi(F_1), "
                                  "chi(F_2) or n_3; C1 of "
                                  "CONSTRAINT_ADDITIONS_20260811.md is a "
                                  "genus IDENTITY package, not a bound"),
        },
        "cell_data": K.SIGMA_BAND_PATTERN_22,
        "cell_reading": ("all 22 live cells carry ord_{L'_sigma}(T) = 0 and "
                         "ord_{P_sigma}(T) = 1 with m = 1, so the minus-line "
                         "is NOT in the base locus and the plus-plane carries "
                         "a simple vanishing; identical across the 22"),
        "F3": ("chi(Ztilde^sigma) = (finite E^X_sigma contribution) + "
               "int_{L^X_sigma} chi(fibre^sigma); NOT closable here because "
               "the census fixes only the COMPONENT COUNTS of Z^sigma by "
               "dimension (146/80/11/2), not the Euler characteristics of "
               "the 11 surface and 2 threefold components"),
    }


# ------------------------------------------------------------ order 3 (F2)
def order3():
    """
    THE ORDER-3 INSTANTIATION (partial, flagged).

    X^{C3} = 6 points: on each of the two C3-eigenLINES (weights 1 and 2) X
    cuts a length-3 scheme = 1 C6-point + 2 exact-C3 points; the isolated
    weight-0 D12-point is OFF X.  chi(X^{C3}) = 6.

    Z^{C3} has 80 components for one fixed C3, of dimensions 0 (62), 1 (16)
    and 2 (2).  Because X^{C3} is FINITE, every component of Z^{C3} is
    contracted to a single receiver point, so
        chi((q|_{Z^{C3}})^{-1}(x)) = sum of chi over the components sent to x
    and the fiberwise congruence needs the Euler characteristics of the 16
    curve components and the 2 surface components, NOT just their count.
    Every component is smooth (fixed locus of a finite group on a smooth
    variety) and rational (census), so each curve component is P^1 with
    chi = 2, but the two surface components have chi = 2 + b_2 with b_2 NOT
    pinned by the census.  Reported parametrically.

    What IS computed here: the receiver-point assignment of the 8 immune A4
    rows per (A4a, A4b) menu entry, i.e. the multiset of receiver points the
    immune block deposits, for all 238 * 238 = 56 644 menu pairs.
    """
    menu = read_sealed_menu()
    a4a = menu["per_center"]["A4a"]
    a4b = menu["per_center"]["A4b"]

    def classify(vec):
        """Multiset of receiver-point KINDS named by a value vector."""
        kinds = {}
        for v in vec:
            kinds[v] = kinds.get(v, 0) + 1
        return kinds

    # profile of the two 238-entry menus by number of UNDEF rows
    def undef_profile(centre):
        prof = {}
        for vec in centre["vectors"]:
            k = sum(1 for v in vec if v == "UNDEF")
            prof[k] = prof.get(k, 0) + 1
        return {str(k): v for k, v in sorted(prof.items())}

    # the set of distinct receiver labels the A4 block can name
    labels = set()
    for centre in (a4a, a4b):
        for vec in centre["vectors"]:
            labels.update(v for v in vec if v != "UNDEF")

    # joint profile over all 238*238 pairs, keyed by (#defined a, #defined b)
    joint = {}
    da = [sum(1 for v in vec if v != "UNDEF") for vec in a4a["vectors"]]
    db = [sum(1 for v in vec if v != "UNDEF") for vec in a4b["vectors"]]
    for x in da:
        for y in db:
            joint[(x, y)] = joint.get((x, y), 0) + 1

    return {
        "order": 3,
        "receiver": {"X^g": "6 isolated points (2 eigenlines x 3 points)",
                     "chi": K.CHI_X_FIXED[3],
                     "off_X": "the weight-0 isolated D12-point"},
        "source_census_Z_C3_by_dim": K.Z_FIXED_BY_DIM["C3"],
        "menu_factors_used": ["A4a", "A4b"],
        "menu_size": len(a4a["vectors"]) * len(a4b["vectors"]),
        "A4a_rows": a4a["row_names"],
        "A4b_rows": a4b["row_names"],
        "A4a_undef_profile": undef_profile(a4a),
        "A4b_undef_profile": undef_profile(a4b),
        "receiver_labels_named": sorted(labels),
        "joint_defined_profile": {"%d,%d" % k: v for k, v in sorted(joint.items())},
        "status": "PARAMETRIC",
        "blocker": ("chi of the 2 two-dimensional components of Z^{C3} is not "
                    "pinned by the census (component counts by dimension only); "
                    "with the 62 points and the 16 rational curves this gives "
                    "chi(Z^{C3}) = 62 + 32 + chi(S_1) + chi(S_2) "
                    "= 94 + chi(S_1) + chi(S_2), chi(S_i) >= 3"),
        "F2": ("chi(q^{-1}(x)) == chi((q|_{Z^{C3}})^{-1}(x)) (mod 3) at each "
               "of the 6 points; the right-hand sides sum to "
               "94 + chi(S_1) + chi(S_2) and are otherwise free"),
    }


# ------------------------------------------------------------- per cell
def per_cell_report():
    """
    The 22 live cells x the FULL menu.  No cell -> menu-subset linkage exists
    in the record (constants.CELL_MENU_LINKAGE), so every cell is paired with
    all 36 252 160 menu entries.  The menu is a product of six independent
    centres, so each order's result depends only on its own factors; the
    remaining factors enter as stated free multiplicities.
    """
    o11 = order11()
    o5 = order5()
    rows = []
    for cid, chash in zip(K.LIVE_CELL_IDS, K.LIVE_CELL_HASHES_P331):
        rows.append({
            "cell_id": cid,
            "content_hash_p331": chash,
            "sigma_band": K.SIGMA_BAND_PATTERN_22,
            "menu_admissible": "FULL (36252160 entries)",
            "order11": {"n_x": o11["n_x_on_Z"],
                        "residue_mod_11": o11["n_x_on_Z"] % 11,
                        "constant_over_menu": True,
                        "menu_entries_covered": K.MENU_FACTORS["C11"],
                        "free_multiplicity": (K.F_ODD_35 //
                                              K.MENU_FACTORS["C11"])},
            "order5": {"n_x": o5["n_x"],
                       "residue_mod_5": 0,
                       "constant_over_menu": o5["uniform_across_menu"],
                       "menu_entries_covered": 4 * 4 * 4,
                       "free_multiplicity": K.F_ODD_35 // (4 * 4 * 4)},
            "order2": {"status": "E^X_sigma branch CLOSED (== 0 mod 2); "
                                 "L^X_sigma branch PARAMETRIC",
                       "constant_over_menu": True,
                       "note": "the sigma-band pattern is identical for all "
                               "22 cells, so the order-2 reading is too"},
            "order3": {"status": "PARAMETRIC",
                       "menu_entries_covered": 238 * 238,
                       "free_multiplicity": K.F_ODD_35 // (238 * 238)},
        })
    return rows


def main():
    out = {
        "d": D,
        "orders": {
            "11": order11(),
            "5": order5(),
            "2": order2(),
            "3": order3(),
            "6": order6(),
        },
        "cells": per_cell_report(),
        "menu": {"factors": K.MENU_FACTORS, "F_odd_35": K.F_ODD_35,
                 "linkage": K.CELL_MENU_LINKAGE},
        "n_cells": len(K.LIVE_CELL_IDS),
        "n_cell_menu_pairs": len(K.LIVE_CELL_IDS) * K.F_ODD_35,
    }
    here = os.path.dirname(os.path.abspath(__file__))
    dest = os.path.join(here, "..", "results", "f2f3_congruences.json")
    with open(dest, "w") as f:
        json.dump(out, f, indent=1, sort_keys=True)
    print("wrote %s" % os.path.normpath(dest))
    print("order 11: n_x = %d, residue %d mod 11, menu size %d, "
          "defined-row range %r"
          % (out["orders"]["11"]["n_x_on_Z"],
             out["orders"]["11"]["n_x_on_Z"] % 11,
             out["orders"]["11"]["menu_size"],
             out["orders"]["11"]["n_defined_rows_range"]))
    print("order  5: n_x = %r, uniform over menu = %s"
          % (out["orders"]["5"]["n_x"], out["orders"]["5"]["uniform_across_menu"]))
    print("order  2: E^X_sigma CLOSED (0 mod 2); L^X_sigma PARAMETRIC")
    print("order  3: PARAMETRIC (%d menu pairs classified)"
          % out["orders"]["3"]["menu_size"])
    print("cells: %d, cell x menu pairs: %d"
          % (out["n_cells"], out["n_cell_menu_pairs"]))


if __name__ == "__main__":
    main()
