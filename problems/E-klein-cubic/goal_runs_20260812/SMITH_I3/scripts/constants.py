#!/usr/bin/env python3
"""
Every constant this packet consumes, with its provenance.

RULE (DATA_SPEC_SMITH_I3_20260812.md sec.2): receiver constants and census
values are CONSUMED BY CITATION, never re-derived here.  Each entry carries
`src` = the sealed file and the section/row it is read from.  The verifier's
check group B re-reads the machine-readable ones out of the sealed JSON and
compares; the ones that live only in a THEOREM.md table are cited by
file + section and cross-checked against an independent identity where one
exists (see `CROSSCHECKS`).

NOTATION, disambiguated (the record overloads `E_sigma`):
  RECEIVER  X^sigma  =  E^X_sigma  (elliptic curve, chi = 0)
                     u  L^X_sigma  (line P^1, chi = 2)
  SOURCE    P_sigma  = P(W^+) = P^2   (the "plus-plane"),
            L'_sigma = P(W^-) = P^1   (the "minus-line"),
            D_{P_sigma}, D_{L'_sigma}  their exceptional divisors on Z.
This packet never writes a bare `E_sigma`.
"""

# --------------------------------------------------------------------------
# B1. Receiver side: chi_top(X^g) by element order.
#     Source: goal_runs_20260810/RECEIVER_LEDGER_X/THEOREM.md sec.6.1,
#     the table "L(g) = chi_top(X^g)".  Proved four independent ways there
#     (eigenspace, discriminant, M2 ideal, topological Lefschetz).
CHI_X_FIXED = {1: -6, 2: 2, 3: 6, 5: 4, 6: 2, 11: 5}
CHI_X_FIXED_SRC = ("goal_runs_20260810/RECEIVER_LEDGER_X/THEOREM.md sec.6.1, "
                   "table 'L(g) = chi_top(X^g)'")

# B2. Receiver side: the stratification of X^g into connected pieces, with
#     the chi of each.  Source: same THEOREM.md sec.6.1 prose
#     ("2 = chi(E_sigma) + chi(L_sigma) = 0 + 2 is the C2 row's shape; and
#       6, 4, 2, 5 are exactly the C3, C5, C6, C11 point counts of sec.2")
#     plus results/ledger_exact.json rows (X_points fields).
X_FIXED_STRATA = {
    2:  [("E^X_sigma", "elliptic curve", 0), ("L^X_sigma", "line P^1", 2)],
    3:  [("pt", "isolated point", 1)] * 6,
    5:  [("pt", "isolated point", 1)] * 4,
    6:  [("pt", "isolated point", 1)] * 2,
    11: [("pt", "isolated point", 1)] * 5,
}
X_FIXED_STRATA_SRC = ("goal_runs_20260810/RECEIVER_LEDGER_X/THEOREM.md sec.6.1 "
                      "+ results/ledger_exact.json rows[*].ambient_strata "
                      "(X_points fields)")

# B3. Source side, census on the wonderful terminus Z: the number of
#     connected components of Z^H for ONE fixed subgroup H, and their
#     dimensions.  Source: goal_runs_20260810/TERMINUS_STRATA_PW/THEOREM.md
#     sec.2, the census table (columns "of Z_{=H}, ONE fixed H" and
#     "of Z^H, ONE fixed H") + the per-class row breakdown below it.
Z_FIXED_COMPONENTS = {         # components of Z^H, one fixed H
    "C2": 239, "C3": 80, "V4": 54, "C5": 20, "C6": 38, "C11": 20,
}
Z_FIXED_COMPONENTS_SRC = ("goal_runs_20260810/TERMINUS_STRATA_PW/THEOREM.md "
                          "sec.2 census table, column 'of Z^H, ONE fixed H'")

# B4. The three classes whose fixed locus on Z is FINITE (every component is
#     dim 0), so chi(Z^H) = #components exactly.  Source: same table, column
#     "by dimension": C5 '0: 1320', C6 '0: 2090', C11 '0: 240' -- every
#     G-orbit of components is 0-dimensional, and for these H no larger
#     occurring class contains H, so Z^H = Z_{=H}.
Z_FINITE_FIXED = {"C5": 20, "C6": 38, "C11": 20}
Z_FINITE_FIXED_SRC = ("goal_runs_20260810/TERMINUS_STRATA_PW/THEOREM.md "
                      "sec.2: 'H = C5 (10 orbits of 132, all dim 0)', "
                      "'H = C6 (19 orbits of 110, all dim 0)', "
                      "'H = C11 (4 orbits of 60, all dim 0, in E_{C11})'; "
                      "and 'Z^{C11} = Z_{=C11}'")

# B5. chi of P(W)^g.  Not census data -- a one-line classical fact recorded
#     here so the verifier can check it: for ANY finite-order automorphism g
#     of P^n, g acts trivially on H^{2i}(P^n,Q) = Q (the hyperplane class is
#     canonical), so the topological Lefschetz number is n+1 and
#     chi(P(W)^g) = 5 for every g in G.  Cross-checked against the
#     eigenstructure per class in CROSSCHECKS below.
CHI_PW_FIXED = {1: 5, 2: 5, 3: 5, 5: 5, 6: 5, 11: 5}

# B6. The eigenstructure of W per class (used only to cross-check B5 and to
#     name the source loci).  Source: theory/SCHEME_MAP_CONSEQUENCES_
#     20260812.md sec.3.3 table 'Res_S W'.
W_EIGENSTRUCTURE = {
    1:  [("triv", 5)],
    2:  [("+1", 3), ("-1", 2)],                       # P^2 u P^1
    3:  [("1", 1), ("w", 2), ("w^2", 2)],             # pt u P^1 u P^1
    5:  [("z5^%d" % k, 1) for k in range(5)],         # 5 points
    6:  [("1", 1), ("-w", 1), ("-w^2", 1), ("w", 1), ("w^2", 1)],
    11: [("z11^%d" % r, 1) for r in (1, 3, 4, 5, 9)],
}
W_EIGENSTRUCTURE_SRC = ("theory/SCHEME_MAP_CONSEQUENCES_20260812.md sec.3.3 "
                        "table; C11 row 'zeta^r, r in {1,3,4,5,9}'")

# B7. The C11 character labels actually carried by the five eigenpoints of
#     P(W), read machine-readably out of the sealed receiver ledger
#     (rows[C11].ambient_strata[*].chi).  Used by the I3 eigenbasis
#     corollary.  The verifier re-reads these from the JSON.
C11_WEIGHTS = (1, 3, 4, 5, 9)
C11_WEIGHTS_SRC = ("goal_runs_20260810/RECEIVER_LEDGER_X/results/"
                   "ledger_exact.json, rows[label=C11].ambient_strata[*].chi")

# B8. Rationality of every stratum of Z -- the input that makes the order-2
#     dichotomy decidable on Z.  Source: TERMINUS_STRATA_PW THEOREM.md sec.1,
#     'Every stratum is rational. ... So delta_bir(H,F) = rational for EVERY
#     row -- verified per row, not assumed'.
Z_ALL_STRATA_RATIONAL = True
Z_ALL_STRATA_RATIONAL_SRC = ("goal_runs_20260810/TERMINUS_STRATA_PW/THEOREM.md "
                             "sec.1, corollary 'Every stratum is rational'")

# B9. The two divisorial rows of the sigma band on Z (the only dim-3
#     components of Z^{C2}).  Source: TERMINUS_STRATA_PW sec.2, 'H = C2'
#     table rows dim 3.
SIGMA_BAND_DIVISORS = [
    {"name": "D_{L'_sigma}", "dim": 3, "n_orbit": 55, "stab": "D12",
     "W_HF": "S3", "boundary": "L'_sigma", "model": "P^1 x P^2"},
    {"name": "D_{P_sigma}", "dim": 3, "n_orbit": 55, "stab": "D12",
     "W_HF": "S3", "boundary": "P_sigma", "model": "P^2 x P^1"},
]
SIGMA_BAND_DIVISORS_SRC = ("goal_runs_20260810/TERMINUS_STRATA_PW/THEOREM.md "
                           "sec.2, 'H = C2' table, the two dim-3 rows")

# B10. Components of Z^H (ONE fixed H) BROKEN DOWN BY DIMENSION.  This is the
#      finest source-side datum the census carries.  Source:
#      goal_runs_20260810/TERMINUS_STRATA_PW/results/t2_strata.txt,
#      'DICTIONARY' block (lines 399-404).
Z_FIXED_BY_DIM = {
    "C2":  {0: 146, 1: 80, 2: 11, 3: 2},   # total 239
    "C3":  {0: 62,  1: 16, 2: 2},          # total 80
    "V4":  {0: 36,  1: 18},                # total 54
    "C5":  {0: 20},
    "C6":  {0: 38},
    "C11": {0: 20},
}
Z_FIXED_BY_DIM_SRC = ("goal_runs_20260810/TERMINUS_STRATA_PW/results/"
                      "t2_strata.txt, DICTIONARY block")

# B11. The wonderful-model centre list (the G-arrangement blown up to build Z
#      from P(W) = P^4).  Source: TERMINUS_STRATA_PW results/t3_localmodels.txt
#      sec.1 (both primes agree): 1215 boundary divisors in 14 G-orbits.
WONDERFUL_CENTERS = {
    "T0_points": [("C11", 60, "C11"), ("D10", 66, "D10"), ("A4(a)", 55, "A4"),
                  ("A4(b)", 55, "A4"), ("V4I", 165, "V4"), ("C5(a)", 132, "C5"),
                  ("C6(a)", 110, "C6"), ("C5(b)", 132, "C5"),
                  ("D12", 55, "D12"), ("C6(b)", 110, "C6")],   # sum 940
    "T1_lines": [("C3line", 110, "C6"), ("Lminus_sigma", 55, "D12"),
                 ("ell_V", 55, "A4")],                          # sum 220
    "T2_planes": [("P_sigma", 55, "D12")],                      # sum 55
}
WONDERFUL_CENTERS_SRC = ("goal_runs_20260810/TERMINUS_STRATA_PW/results/"
                         "t3_localmodels.txt sec.1")

# B12. THE ORDER-2 DOMINANCE THEOREM -- the load-bearing order-2 input.
#      Source: goal_runs_20260810/STAGE1_COMPLEX_MAPS/THEOREM.md Theorem 3
#      (lines 221-237): the three D12-stabilised rows D_{P_sigma},
#      D_{L^-_sigma}, and the central-involution line in E_{pt_D12} "map onto
#      L_sigma, surjectively ... uniquely.  No other row is forced to be
#      non-constant."  This theorem is one of the two divisorial rows that
#      SCHEME_MAP_CONSEQUENCES sec.0 says bind on EVERY model.
ROWS_DOMINATING_L_SIGMA = ["D_{P_sigma}", "D_{L'_sigma}",
                           "central-involution line in E_{pt_D12}"]
ROWS_DOMINATING_L_SIGMA_SRC = ("goal_runs_20260810/STAGE1_COMPLEX_MAPS/"
                               "THEOREM.md Theorem 3")

# B13. The residual actions on the receiver fixed loci -- these drive the
#      transitivity argument of Lemma 2 in THEOREM.md sec.4.
#      Source: goal_runs_20260810/RECEIVER_LEDGER_X/results/ledger_exact.json,
#      detail.C11.residual_C5_permutation and detail.C5.reflection_permutation.
C11_RESIDUAL_C5_PERM = [2, 0, 3, 4, 1]     # a 5-cycle: transitive on X^{C11}
C5_REFLECTION_PERM = [0, 4, 3, 2, 1]       # fixes the OFF-X point (index 0),
                                           # swaps 1<->4 and 2<->3 on X^{C5}
RESIDUAL_PERMS_SRC = ("goal_runs_20260810/RECEIVER_LEDGER_X/results/"
                      "ledger_exact.json, detail.C11.residual_C5_permutation "
                      "and detail.C5.reflection_permutation")

# B14. The 22 coherence-immune rows of Z with their weight data.  CONSUMED BY
#      CITATION from goal_runs_20260810/STAGE2_ODD_ORDER_PINNING/scripts/
#      s2pin.py, IMMUNE_ROWS (lines 124-176).  Fields used here:
#      (name, n = order of g, base = g-weight of the level-0 centre,
#       chain = relative weights of the exceptional directions, ncomp).
IMMUNE_ROWS = [
    ("C11/pt_C11 c=3", 11, 9, (3,), 0, 60),
    ("C11/pt_C11 c=5", 11, 9, (5,), 0, 60),
    ("C11/pt_C11 c=6", 11, 9, (6,), 0, 60),
    ("C11/pt_C11 c=7", 11, 9, (7,), 0, 60),
    ("C5/pt_C5(a) c=1", 5, 1, (1,), 0, 132),
    ("C5/pt_C5(a) c=2", 5, 1, (2,), 0, 132),
    ("C5/pt_C5(a) c=3", 5, 1, (3,), 0, 132),
    ("C5/pt_C5(a) c=4", 5, 1, (4,), 0, 132),
    ("C5/pt_C5(b) c=1", 5, 2, (1,), 0, 132),
    ("C5/pt_C5(b) c=2", 5, 2, (2,), 0, 132),
    ("C5/pt_C5(b) c=3", 5, 2, (3,), 0, 132),
    ("C5/pt_C5(b) c=4", 5, 2, (4,), 0, 132),
    ("C5/pt_D10 c=1", 5, 0, (1,), 0, 132),
    ("C5/pt_D10 c=2", 5, 0, (2,), 0, 132),
    ("C3/pt_A4(a) dim1 c=1", 3, 1, (1,), 1, 220),
    ("C3/pt_A4(a) dim0 c=2", 3, 1, (2,), 0, 220),
    ("C3/pt_A4(a)<ell_V c=(1,1)", 3, 1, (1, 1), 0, 220),
    ("C3/pt_A4(a)<ell_V c=(1,2)", 3, 1, (1, 2), 0, 220),
    ("C3/pt_A4(b) dim1 c=2", 3, 2, (2,), 1, 220),
    ("C3/pt_A4(b) dim0 c=1", 3, 2, (1,), 0, 220),
    ("C3/pt_A4(b)<ell_V c=(2,2)", 3, 2, (2, 2), 0, 220),
    ("C3/pt_A4(b)<ell_V c=(2,1)", 3, 2, (2, 1), 0, 220),
]
IMMUNE_ROWS_SRC = ("goal_runs_20260810/STAGE2_ODD_ORDER_PINNING/scripts/"
                   "s2pin.py, IMMUNE_ROWS")

# B15. Which g-weights carry a point of X, per prime order.  Read from
#      RECEIVER_LEDGER_X results/ledger_exact.json rows[*].ambient_strata:
#      an entry with X_points >= 1 is on X.
ON_X_WEIGHTS = {
    11: {1, 3, 4, 5, 9},          # all five C11-eigenpoints lie on X
    5:  {1, 2, 3, 4},             # the weight-0 (D10) point is OFF X
    3:  {1, 2},                   # eigenLINES; weight 0 (D12 point) is OFF X
}
ON_X_WEIGHTS_SRC = ("goal_runs_20260810/RECEIVER_LEDGER_X/results/"
                    "ledger_exact.json rows[*].ambient_strata[*].X_points")

# B16. The 22 live d = 35 cells.  Source: goal_runs_20260811/D35_AUDIT/
#      results/patterns_r5_content_p331.json, survivors22.
#      *** SPEC DIVERGENCE, flagged: the data spec calls the key `sol_hash`;
#      the file's per-cell identity fields are `content_hash` (and a second
#      `sealed_hash`).  There is no field named `sol_hash` in D35_AUDIT. ***
LIVE_CELL_IDS = [5, 7, 13, 15, 21, 23, 29, 31, 37, 39, 45, 47, 53, 55,
                 61, 63, 69, 71, 697, 699, 701, 703]
LIVE_CELL_HASHES_P331 = [
    "1c9110f65f5bbba3", "3150d84bef191573", "3618971b26ff55c3",
    "3f5a2ac32819ba6f", "4719753a11bf778e", "5a83d267319fa23e",
    "60e0986d49bee8f8", "6250d74a687cb983", "6d86d9d5001c7e2e",
    "936cc3c107447118", "9b53e234676b5956", "a604f5628e9236ba",
    "b55e098db7f81575", "bbb7766320c5cd5a", "c1aa082c6d18a709",
    "cc5dcc73af916c94", "cda89047957f1b38", "d0d84b4f9163e092",
    "db1cfded50b57ffb", "f3d6a4eaa956f29f", "f728b33a2e34714b",
    "fcf626911737b157"]
LIVE_CELLS_SRC = ("goal_runs_20260811/D35_AUDIT/results/"
                  "patterns_r5_content_p331.json, survivors22")

# B17. The sigma-band pattern shared by all 22 live cells.  Source: the same
#      file, patterns[*] with group_key '0bbfc90a9b60'.
#      *** SPEC DIVERGENCE, flagged: the data spec says "each cell's
#      sigma-band pattern is UNIQUE".  In the files all 22 live cells carry
#      the IDENTICAL sigma-band pattern (one group_key); what is unique per
#      cell is the content_hash of the embedded finite-field data. ***
SIGMA_BAND_PATTERN_22 = {
    "group_key": "0bbfc90a9b60",
    "min_m": 1, "max_m": 1,
    "m_options_L": [35], "m_options_P": [1],
    "a35_L_options": [[35, 0]], "a35_P_options": [[34, 1]],
}
SIGMA_BAND_PATTERN_22_SRC = LIVE_CELLS_SRC

# B18. The F_odd menu at the residue of 35 (the per-centre value-vector
#      lists).  Source: goal_runs_20260811/GLOBAL_COHERENCE/results/
#      vectors_d35.json.  F_odd(35) = 10*4*4*4*238*238 = 36 252 160.
MENU_FACTORS = {"C11": 10, "C5a": 4, "C5b": 4, "D10": 4,
                "A4a": 238, "A4b": 238}
F_ODD_35 = 36252160
MENU_SRC = ("goal_runs_20260811/GLOBAL_COHERENCE/results/vectors_d35.json "
            "(d=35, per_center); count cross-checked against "
            "results/F_odd_counts.json record d_mod_330 = 35")

# B19. NO cell -> menu-subset linkage exists in the record.  Per DATA_SPEC
#      sec.2 ("If the linkage ... is not determined by the files, treat the
#      FULL menu as admissible and say so"), every one of the 22 cells is
#      paired with the FULL menu.
CELL_MENU_LINKAGE = "NOT DETERMINED BY THE FILES -- full menu admissible"

# --------------------------------------------------------------------------
# Cross-checks the verifier runs (identities among the cited constants;
# they do not re-derive anything, they detect transcription error).
CROSSCHECKS = [
    ("chi_X_order2_splits", "CHI_X_FIXED[2] == 0 + 2 == sum of X_FIXED_STRATA[2] chis"),
    ("chi_X_odd_orders_are_point_counts",
     "CHI_X_FIXED[o] == len(X_FIXED_STRATA[o]) for o in (3,5,6,11)"),
    ("chi_PW_is_5", "chi(P(W)^g) == sum of eigenspace projective-space chis"),
    ("C11_weights_are_QR_mod_11", "{1,3,4,5,9} == quadratic residues mod 11"),
]


def selfcheck():
    """Runs CROSSCHECKS; returns list of (name, ok, detail)."""
    out = []

    ok = (CHI_X_FIXED[2] == sum(c for _, _, c in X_FIXED_STRATA[2]) == 2)
    out.append(("chi_X_order2_splits", ok,
                "0 (E^X_sigma) + 2 (L^X_sigma) = 2"))

    ok = all(CHI_X_FIXED[o] == sum(c for _, _, c in X_FIXED_STRATA[o])
             for o in (3, 5, 6, 11))
    out.append(("chi_X_odd_orders_are_point_counts", ok,
                "6,4,2,5 = #points for orders 3,5,6,11"))

    detail = []
    good = True
    for o, eig in W_EIGENSTRUCTURE.items():
        # P(W)^g = disjoint union of P(eigenspace); chi(P^{m-1}) = m
        c = sum(m for _, m in eig)
        detail.append("order %d: %d" % (o, c))
        good = good and (c == CHI_PW_FIXED[o] == 5)
    out.append(("chi_PW_is_5", good, "; ".join(detail)))

    qr = sorted({(k * k) % 11 for k in range(1, 11)})
    out.append(("C11_weights_are_QR_mod_11", sorted(C11_WEIGHTS) == qr,
                "QR mod 11 = %r" % (qr,)))

    ok = (Z_FINITE_FIXED["C11"] == Z_FIXED_COMPONENTS["C11"] == 20 and
          Z_FINITE_FIXED["C5"] == Z_FIXED_COMPONENTS["C5"] == 20 and
          Z_FINITE_FIXED["C6"] == Z_FIXED_COMPONENTS["C6"] == 38)
    out.append(("Z_finite_fixed_matches_census", ok,
                "C11 20, C5 20, C6 38"))

    return out


if __name__ == "__main__":
    for name, ok, detail in selfcheck():
        print("%-40s %s   %s" % (name, "OK" if ok else "FAIL", detail))
