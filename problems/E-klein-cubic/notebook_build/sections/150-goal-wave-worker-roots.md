## Goal-wave worker roots

Added Round 5 (`## 2026-08-03 review round`), after the expanded
`scripts/check_manifest_parity.py` coverage-by-mention check surfaced 43
level-1 children of `goals_2026-08-01/`, `goals_after_35fa8f/`, and
`goals_after_bd610a/` that were never mentioned by name anywhere in this
document. A disposition sweep then classified all 43: **21 PROMOTED** (the
worker root's content is already carried by a named `goal_runs_after_*`
packet or the entry cited in the table below — the worker root itself is
superseded infrastructure), **15 SCRATCH** (unexecuted, superseded, or a
staging/duplicate snapshot with no independent claim), and **7
UNPROMOTED-RESULT** (the worker root contains an executed computation with
a specific claim absent from every packet and every entry above). The key
cross-reference for the PROMOTED dispositions is
`goal_runs_after_35fa/A0_CANONICAL_AUDIT/CANONICAL_STATE.md`, which names
most `goals_2026-08-01/*` directories as canonical packets (or, in one
case, repairs the label under which a directory's content is canonical).
Per the Coverage contract, this appendix satisfies coverage-by-mention; it
does not create new per-record manifest entries. The 7 UNPROMOTED-RESULT
dirs are independent verification debt — see Verification debt item 20.

| dir | class | owning packet/entry or claim |
|---|---|---|
| `goals_after_35fa8f/H3_A5_CANONICAL_MODEL_INVARIANT_20260801` | PROMOTED | H_A5_TWISTS ([E11](#e11)) |
| `goals_after_35fa8f/point_attack_degree11_20260801` | PROMOTED | H_A5_TWISTS ([E11](#e11)) |
| `goals_after_35fa8f/source_audit_canonical` | SCRATCH | audit supporting [E11](#e11) |
| `goals_after_bd610a/A5Q_QUARTIC_RESCUE_WORK` | UNPROMOTED | [E04](#e04) — `COMMON_CYCLE_VARIANT.md` rank witness |
| `goals_after_bd610a/P25_COV_SUPPORT` | UNPROMOTED | [E09](#e09)/[E25](#e25) — exact ranks nowhere else |
| `goals_after_bd610a/scratch_t3` | UNPROMOTED | [E32](#e32) — executed T3 discriminant computation |
| `goals_2026-08-01/COV_M1_DEG31_35_WORK` | PROMOTED | COV_M1_DEG31_35 ([E09](#e09)) |
| `goals_2026-08-01/COV_STRUCTURED_SEARCH` | PROMOTED | A0-canonical for COV ([E02](#e02)/[E09](#e09)) |
| `goals_2026-08-01/COV_STRUCTURED_SEARCH_ROOT` | PROMOTED (label repaired by A0) | [E09](#e09) — see COV caveat below |
| `goals_2026-08-01/C_PFAFFIAN_FANO` | SCRATCH | historical, superseded |
| `goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT` | PROMOTED | A0-canonical for C ([E07](#e07)/[E08](#e08)) |
| `goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3` | UNPROMOTED | [E07](#e07)/[E08](#e08) — "research only" idempotent |
| `goals_2026-08-01/D_EQUIVARIANT_MOTIVE` | PROMOTED | [E10](#e10) |
| `goals_2026-08-01/F_CONIC_ALGEBRA` | PROMOTED | [E13](#e13) |
| `goals_2026-08-01/G_ALL_DEGREE_ROOT_20260801` | UNPROMOTED | [E16](#e16) — unmerged 8-point delta |
| `goals_2026-08-01/H_SUBGROUP_TWISTS_CODEX_ROOT_20260801` | UNPROMOTED | [E11](#e11) — CTZ-5.1 completeness claim |
| `goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10` | PROMOTED | [E11](#e11) |
| `goals_2026-08-01/M2_EQUIVARIANT_SARKISOV_CODEX_ROOT_20260801` | PROMOTED | M_SARKISOV ([E24](#e24)) |
| `goals_2026-08-01/M_SARKISOV_CODEX_ROOT_20260801` | PROMOTED | M_SARKISOV ([E24](#e24)) |
| `goals_2026-08-01/Q_11_5_FIVE_KUMMER_CODEX_ROOT_20260801_5FIVE` | SCRATCH | unexecuted script |
| `goals_2026-08-01/Q_11_5_FOUR_KUMMER_CODEX_ROOT_20260801_B91C` | PROMOTED | Q_SCHUR_INDEX_ONE/h_trace_four_kummer_laurent ([E27](#e27)) |
| `goals_2026-08-01/Q_11_5_TRACE_BINOMIAL_CODEX_ROOT_20260801_C71A` | SCRATCH | unexecuted script |
| `goals_2026-08-01/Q_11_5_TRACE_FACTOR_CODEX_ROOT_20260801_6D4E` | PROMOTED | h_trace_fourier_pair_k + h_trace_three_kummer_laurent ([E27](#e27)) |
| `goals_2026-08-01/Q_A5_VALUATION_REPLAY_20260801_D2B9` | SCRATCH | replay of [E11](#e11) result |
| `goals_2026-08-01/Q_SCHUR_A5_PARENT_INTEGRATION_20260801_EA52` | SCRATCH | staging snapshot |
| `goals_2026-08-01/Q_SCHUR_A5_VALUATION_ELIMINATION_CODEX_ROOT_20260801_EA52` | PROMOTED | a5_valuation_elimination ([E27](#e27)) |
| `goals_2026-08-01/Q_SCHUR_DEGREE6_11_5_20260801_2A6C` | PROMOTED | Q_SCHUR_INDEX_ONE_DEGREE6_11_5 ([E27](#e27)) |
| `goals_2026-08-01/Q_SCHUR_DESCENT` | PROMOTED | A0-canonical for Q ([E27](#e27)) |
| `goals_2026-08-01/Q_SCHUR_DESCENT_CODEX_ROOT_20260801_5F31` | PROMOTED | Q_SCHUR_DESCENT ([E27](#e27)) |
| `goals_2026-08-01/Q_SCHUR_EXACT_FRAME_PARENT_INTEGRATION_20260801_8F3D` | SCRATCH | staging snapshot |
| `goals_2026-08-01/Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D` | PROMOTED | Q_SCHUR_INDEX_ONE_EXACT_FRAME ([E27](#e27)) |
| `goals_2026-08-01/Q_SCHUR_FOUR_KUMMER_PARENT_INTEGRATION_20260801_B91C` | SCRATCH | staging snapshot |
| `goals_2026-08-01/Q_SCHUR_H4_DEG6_CODEX_ROOT_20260801_2A6C` | PROMOTED | Q_SCHUR_INDEX_ONE_DEGREE6_11_5 ([E27](#e27)) |
| `goals_2026-08-01/Q_SCHUR_INDEX_ONE_STAGE_20260801_INTEGRATE2` | SCRATCH | staging snapshot |
| `goals_2026-08-01/Q_SCHUR_INDEX_ONE_STAGE_20260801_ROOT` | SCRATCH | staging snapshot |
| `goals_2026-08-01/R_RATIONAL_CURVES_CODEX` | PROMOTED | A0-canonical for R ([E28](#e28)) |
| `goals_2026-08-01/R_RATIONAL_CURVES_ROOT_20260801A` | SCRATCH | subsumed (low confidence) |
| `goals_2026-08-01/R_RATIONAL_CURVES_ROOT_JACOBIAN_ZERO` | UNPROMOTED | [E28](#e28) — all-degree secant bridge |
| `goals_2026-08-01/S19_SCHUR_CURVE_CODEX_ROOT_20260801_7B4E` | PROMOTED | S19_MARKED_CURVE/CODEX_ROOT ([E30](#e30)) |
| `goals_2026-08-01/T_TARGET_BRANCH_INDEX3` | SCRATCH | unexecuted checklist |
| `goals_2026-08-01/T_TARGET_BRANCH_INDEX3_ROOT_019FBE13` | PROMOTED | A0-canonical for T ([E32](#e32)) |
| `goals_2026-08-01/T_TARGET_BRANCH_INDEX3_codex_root` | SCRATCH | duplicate parallel run |
| `goals_2026-08-01/V_VALUATION_TROPICAL_CODEX_ROOT_20260801` | PROMOTED | [E33](#e33) |

### Unpromoted results (verify-and-promote-or-retire pending)

The 7 UNPROMOTED-RESULT worker roots each carry a specific, executed claim
that is not recorded in any packet or entry. None has been independently
re-derived or sealed; each is worker-root evidence only (Binding rule 4).
Compact pointers to these same claims are also placed inline at their
owning entries, tagged "worker-root, unpromoted/unverified".

- **`goals_after_bd610a/A5Q_QUARTIC_RESCUE_WORK`** ([E04](#e04)) —
  `COMMON_CYCLE_VARIANT.md`: per class the 11×15 quadratic-evaluation
  matrix has rank 11; stacking both classes gives a 22×15 matrix of rank
  15 with a nonzero combined-submatrix determinant. Absent from the sealed
  A5Q packet.
- **`goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3`**
  ([E07](#e07)/[E08](#e08)) — "research only" per A0: a degree-12
  full-wedge covariant with nonzero symplectic contraction, an idempotent
  of reduced rank two, and Morita corner ranks 4/12/5.
- **`goals_after_bd610a/P25_COV_SUPPORT`** ([E09](#e09)/[E25](#e25)) —
  exact `F_89` ranks 690/56/746; multiplication rank 27583; kernel dim
  19; a coupled degree-4 relation space of rank 29880; a 25200-state
  transition-stable border hull; all 7770 three-coordinate q-planes have
  contraction rank 75/75. None of these figures appear in any packet.
- **`goals_2026-08-01/H_SUBGROUP_TWISTS_CODEX_ROOT_20260801`**
  ([E11](#e11)) — claims a COMPLETE proper-subgroup decision boundary
  ("every proper subgroup of an A5 or 11:5 not already displayed is
  outside the possible exceptions of CTZ Theorem 5.1") — stronger than
  the canonical packet; if verified this upgrades [E11](#e11)'s scope
  from finite sample to complete boundary.
- **`goals_2026-08-01/G_ALL_DEGREE_ROOT_20260801`** ([E16](#e16)) —
  self-acknowledged isolated delta (concurrent-worker collision) with 8
  unmerged structural results, e.g. an eight-chart scheme audit proving
  the split-67 line-degree-four scheme equals the inherited `D_L`
  multiple scheme scheme-theoretically.
- **`goals_2026-08-01/R_RATIONAL_CURVES_ROOT_JACOBIAN_ZERO`**
  ([E28](#e28)) — extends the canonical degree-2/3 closure: every
  geometrically integral K-curve on the twist with genus-zero
  normalization forces a K-point (degree-two anticanonical divisor spans
  a K-secant line), plus claimed irreducibility/dimensions 8 and 10 for
  rational quartic/quintic loci with dominant Abel–Jacobi maps. Absent
  from [E28](#e28)'s canonical packet.
- **`goals_after_bd610a/scratch_t3`** ([E32](#e32)) — contains an
  actually-executed T3 fixed-frame computation: an exact discriminant
  constructed and factored, with the plane boundary `A=15, Y=12`
  certified to have contact order two and one generic ordinary node
  (`Δ_cub` irreducible of degree 15 over `Q(ζ₁₁)`, 719 terms), markers
  `T3_FIXED_FRAME_DISCRIMINANT_DISCOVERY_DONE` and
  `T3_DISC_PLANE_GENERIC_ONE_ORDINARY_NODE`. This corrects the prior
  notebook record that T3 was never executed (Verification debt item
  14): no *promoted* T3 packet exists, but an executed worker-root
  computation exists unpromoted in `scratch_t3`.

**COV caveat ([E09](#e09)).** A0's `CANONICAL_STATE.md` downgraded the
worker-root label `COV-STRUCTURED-DEGREES-EMPTY-SCOPED` to
`COV-HIGHER-ORDER-BRANCHES-EMPTY-SCOPED` (line 42, "Root label
`COV-STRUCTURED-DEGREES-EMPTY-SCOPED` repaired to higher-order-branch
emptiness only"). This is the A0 repair referenced by
`goals_2026-08-01/COV_STRUCTURED_SEARCH_ROOT`'s PROMOTED-with-repaired-
label disposition above. Verification debt item 13's "retire or correct
the invalid exit label" action is therefore **done** — retired by A0's
repair, not left open.

---
