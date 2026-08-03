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

## Addendum (completion sweep)

Manifest completion pass (2026-08-03): the 21 packets left `UNCLASSIFIED` in
the sample above, plus the 2 branch-only packets not on `main`, read against
the same rubric.

ALGEBRAIC-RECOMPUTE: 15 — `border_support` (rebuilds the based-residual Q|K
reduction from primary degree-25 artifacts and recomputes rank/kernel, not
just hash-checks), `degree25_direct_support` (`verify_rows.py`/`verify_dvr.py`/
`verify_p25yb.py` each independently rebuild the Reynolds monic basis and
recompute echelon rank / unit minors), `degree25_molien` (recomputes `m_75`
by an independent complex-analytic Molien route plus a separately-coded
modular group sum, distinct from the producer's CRT pipeline),
`degree25_p25v`, `degree25_p25w` (RREF/kernel/quadric-span ranks rebuilt from
sealed seeds in every sub-verifier), `degree25_rowrank` (rebuilds the
Reynolds invariant basis, unisolvence rank, and landing rank from scratch),
`degree25_support_f4` (rebuilds the QK transform, monic-K³ pivot profile, and
a specialized 84-jet rank), `fano_c1`/`fano_c2`/`fano_c3` (full independent
rebuild of the 660-element group representation at two-plus primes,
structure constants / word-basis determinants / minimal polynomials
recomputed and compared, not read), `fixed_frame_arithmetic`
(`existence_verify.py` recomputes the degree-6 line eliminant and its S6
Galois group via sympy; `conic_algebra_verify.py` recomputes the five-form
rank and fixed-direction residual identities), `lifting` (`verify_polar_expansion.py`
re-derives the polarization identity and universal order equations by
independent triple enumeration; `families/verify.py` rebuilds free-module
ranks and generic-rank samples via `common_tower`), `restricted_e3` (an
independent Julia/Hecke replay refactors and factors the quartic/octic
resolvents at a fresh specialization, alongside structural field checks),
`strata` (`verify.py`/`verify_normal_characters.py`/`verify_marked_s3.py`
rebuild the 660-element group from `exact_weil_check.py`, recompute all
subgroup-class counts and joint-character dimensions, and independently
recompute `j(E_t)=8192/11` via PARI/GP at two primes), `transitions`
(sampled `v4_fixed_line`/`c3_lines`: exact Hilbert-coefficient tables and
V4/C3 character-projector dimensions recomputed via modular linear algebra,
not read from JSON).

PARTIAL-RECOMPUTE: 1 — `global_transition` (recomputes `dim_plane`,
`dim_v4_line`, `dim_d12_ordinary`, `n_triv` and the endpoint-ledger
classification independently across the full sampled range and cross-checks
cell-by-cell against the sealed tables; but the necessity-theorem `PROVED`
status and the Level-2 growth witnesses are read/marker-checked, not
re-derived).

CONSISTENCY-ONLY: 2 — `global_lifting` (self-hash checks, JSON field/marker
checks, and a cross-check of two closed-form shape formulas against sealed
free-module stages; no rank/determinant/identity is independently computed),
`transition_repair` (an independent re-classification function re-derives
legacy arrow-type labels and runs adversarial forbidden-identification
predicate checks, but there is no numerical/algebraic recomputation — no
rank, determinant, or polynomial identity anywhere in the script).

NO-VERIFIER: 3 — `audit_a1` (`no_computation_performed: true`; a
claims-about-claims audit of other packets' markers, no verify script),
`fold_normalization_t3` (empty stub directory — two empty subdirectories,
no files, no git history for the path at all; never populated),
`headline_cas_order` (a CAS toolchain-version baseline freeze: `SEAL.json`/
`BASELINE.json`/`SHA256SUMS` only, no verify script and no mathematical
claim to check).

Branch-only (not on `main`, read via `git show`/`git ls-tree` without
checkout):

- `goal_runs_after_eb21458/G3P_A5_SEMILINEAR_QUADRATIC`
  (`agent/g3p-a5-semilinear-20260802`) — NO-VERIFIER. The tracked snapshot
  has no `verify*.py` at any level (`CAS_NEXT_ORDER.md`, `G7B_SCOPE_CORRECTION.md`,
  `INPUT_MANIFEST.json`, `REPLAY.md`, `STATUS.md`, `THEOREM.md`,
  `certificate.json` only) — narrative and data, no independent verifier.
- `goal_runs_after_bd610a/M3_SARKISOV_SECTION`
  (`agent/m3-sarkisov-section-residual`) — PARTIAL-RECOMPUTE.
  `verify_residual_galois.py` is a genuine independent recompute: it
  enumerates all 660 determinant-one matrices mod 11 directly (not by
  generating the group from two matrices, unlike the producer) and
  recomputes the element-order histogram, involution centralizer,
  subdegrees, pair/triple orbit digests, and the no-index-4-subgroup
  simplicity check. But `verify_all.py` (the packet-level orchestrator)
  also calls `verify_section_search.py` against `section_search_payload.json`
  — neither file exists in this branch snapshot — so the packet's actual
  `primary_exit` claim (`M3-SECTION-COMPONENT-PASS`, a `section_search`
  result) is asserted via JSON field reads only, with no present code that
  independently re-derives it.

## Reading

The blanket claim "packet verify.py scripts check hashes/markers, not algebra"
is wrong as a generalization: it holds for 6 of ~100 verifiers. The load-bearing
weak spots are exactly: `B-BRIDGE-REFUTED` (consistency-only verifier over an
analytic finiteness citation), `Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS`
(consistency-only, matching the session's own disclosure), G3H phase 4
(interface bookkeeping), R0 (stale anyway), elliptic_lifting's regression
marker, and pfaffian_point (no verifier by nature).
