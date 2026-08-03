# Verifier-depth classification (2026-08-03 review round)

Classes: ALGEBRAIC-RECOMPUTE (independently reconstructs objects and re-verifies
identities/ranks/emptiness computationally) | PARTIAL-RECOMPUTE (recomputes some
substantive algebra, reads other decisive values from producer artifacts) |
CONSISTENCY-ONLY (hashes, marker strings, JSON cross-field checks, log greps) |
NO-VERIFIER.

## goal_runs layer (75 run/sub-run dirs; every one has a verify script)

ALGEBRAIC-RECOMPUTE: 69 of 75. All G3A/G3B/G3C/G3P, G7 (all three subpackets),
C6 (+2 phases), G4, G4A, G5, H6 (+phase), H6A, Q3, A0 (C/FLINT random-projection
RREF over F_89, `reads_4140_from_json: false`), COV, D2, G_UNIVERSAL, H_11_5,
H_A4, H_A5 (all subpackets), J_BASELOCUS_PRYM, KLS_MINIMALITY, M_SARKISOV,
Q_SCHUR_INDEX_ONE (+13 subpackets), R_RATIONAL_CURVES, S19 (both runs),
V_GENUINE_VALUATION, L1, A5Q (both), C5 (all three), H5 (all three), M3B, V3,
V4, G3D (+line27_exact), G3H phase5 subpackets.

PARTIAL-RECOMPUTE: 3 — `B_FIXED_FRAME_BRIDGE` (mostly hash/field checks; one
sub-verifier recomputes valuation/derivative identities), `T_TARGET_BRANCH`
(mostly hash/field checks; embedded sympy partial-derivative identity),
`G3H_A5_SEMILINEAR_SPRINGER` top level (phase2 rebuilds covariant Y; phases
1/4/5 hash/flag checks — phase 4 is the `INTERFACE_INSTALLED` frame).

CONSISTENCY-ONLY: 3 — `R0_CANONICAL_REFRESH` (the only `-PASS` primary exit on a
consistency-only verifier; already marked stale), `B_FIXED_FRAME_EXHAUSTIVENESS_20260802`
(backs `B-BRIDGE-REFUTED` — JSON dimension fields and text markers only),
`Q_SCHUR_INDEX_ONE_DESCENT_OBSTRUCTION_20260802` (git-blob hashes and markers only).

NO-VERIFIER: 0.

## certificates layer (26 key packets sampled)

ALGEBRAIC-RECOMPUTE: 13 — target_branch_mod3, fold_decision_t8, fold_decision_t8n1,
fold_binodal_t9, fold_t11, fold_t11b, degree25_tower, degree25_rank_k,
schur_degree19, global_finite_lifting, global_lifting_decision,
global_terminal_module, hodge_centers.

PARTIAL-RECOMPUTE: 10 — target_branch_global, target_branch_t10,
fold_normalization, fold_normalization_t2r, fold_decision_t6, degree25_exact,
degree25_global, degree25_finite_module, schur_krylov, fano_c2_1.

CONSISTENCY-ONLY: 2 — fano_interface_c0 (`C0-UNDECIDED` boundary asserted, not
re-derived), elliptic_lifting (internal `PROVED_AS_REGRESSION` accepted via
hash-check/field-read only).

NO-VERIFIER: 1 — pfaffian_point (hosts the FAIL-SCOPE bridge audit; analytic
audit document, no machine verifier).

## Reading

The blanket claim "packet verify.py scripts check hashes/markers, not algebra"
is wrong as a generalization: it holds for 6 of ~100 verifiers. The load-bearing
weak spots are exactly: `B-BRIDGE-REFUTED` (consistency-only verifier over an
analytic finiteness citation), `Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS`
(consistency-only, matching the session's own disclosure), G3H phase 4
(interface bookkeeping), R0 (stale anyway), elliptic_lifting's regression
marker, and pfaffian_point (no verifier by nature).
