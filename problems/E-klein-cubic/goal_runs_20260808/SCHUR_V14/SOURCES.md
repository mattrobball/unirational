# Source and bridge audit

The following authoritative files were read.  They remain read-only; this
run writes only in `goal_runs_20260808/SCHUR_V14`.

## Genuine Schur source and Klein bridge

- `RESOLUTION.md`, especially the Schur-source and projective-source
  distinctions and the generic-twist bridge.
- `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/GENUINE_TWIST.md`.
- `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/exact_schur_frame/THEOREM.md`.

Bridge audit: `K_Schur=C(P(U))^G` is not the nonsplit `K_proj` field.  A
`K_Schur`-point is descent data for a rational map from the projective Schur
source.  The present work never imports a `K_proj` Morita point into this
field.

## Five alternating forms, elliptic quintic, and `V14`

- `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/schur_enq_v14/THEOREM.md`.
- `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/FIBRATION_AUDIT.md`.
- `goal_runs_after_c53d89a/FIX_IX_SEAL/REPORT.md`.
- `goal_runs_after_d0ab8d0/FIX_IX_V14MODEL/brief.md` and its exact model
  scripts.

Bridge audit: Schur splitting really makes `P(U)`, `P(U*)`, and `Gr(2,6)`
split and descends the five alternating forms.  Their common isotropic
two-plane scheme is the displayed `V14`.  The elliptic normal quintic and
the Fano--Iskovskikh link are defined over `K_Schur`; a `V14(K_Schur)` point
would yield an `X_Schur(K_Schur)` point by Lang--Nishimura.  Index one from
degree-four and degree-five cycles is not a point.

## Palatini and Morita attempts

- `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/REPORT.md`.
- `goals_2026-08-01/Q_SCHUR_DESCENT/parallel/`
  `full_schur_palatinian_point_next/REPORT.md` and
  `THREE_FRAME_SLICE_REPORT.md`.
- `goals_after_bd610a/C5_PROJECTOR_INCIDENCE/STATUS.md` and
  `CORRECTED_INCIDENCE.md`.
- `goal_runs_after_141f60/C6_PALATINI_BIG_CELL/STATUS.md`.

Bridge audit: the full-Schur Palatini identity
`I4(sum b_i r_i)=0` is an exact equivalent point gate, but its bounded
self-covariant and pencil exclusions do not decide arbitrary invariant
rational coefficients.  The projector/Morita packets concern the
quaternionic nonsplit `K_proj` corner; their corrected square-zero equations
do not produce a point over `K_Schur` and cannot be transported across the
field boundary.

## `A5`, `D10`, `D12`, and the odd normalizer

- `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/`
  `a5_valuation_elimination/THEOREM.md`.
- `goals_2026-08-01/H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/`
  `D10/STATUS.md` and `D12/STATUS.md`.
- `goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/DESCENT_OBSTRUCTION.md`.
- `goal_runs_after_35fa/H_11_5_TWIST/NORM_MODEL.md`, `BRIDGE.md`, and
  `COMPLETION_AUDIT.md`.
- `theory/FIX_IX_v14.md`, including the corrections through sections
  8.28--8.30; `HANDOFF_F55_ENDGAME.md` was read with its superseding banner.

Bridge audit: both maximal `A5` classes and all `D10`/`D12` twists are
soluble on the Klein side, so those strata cannot prove global
pointlessness.  For odd `H=C11:C5`, the Schur extension splits and the twin
bridge is valid.  Its genuine twist is exactly the sealed cyclic trace
cubic.  The latest correction proves that the conserved-eleven polytope
shadow is feasible and that the proposed extra Brauer constraint was
circular; the earlier Lemma-S plan must not be cited as a theorem.

