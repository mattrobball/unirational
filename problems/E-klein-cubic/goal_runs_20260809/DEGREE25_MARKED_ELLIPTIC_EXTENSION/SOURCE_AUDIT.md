# Source audit and precedence

**Audited repository head:** `091d4f5d4314c556da96d1804c49be13f48a78c8`.  
**Branch audit:** the active 2026-08-09 research branch and `main` share this
head; older divergent branches inspected did not supersede the consumed
blobs. The layered precedence rule in `NOTEBOOK.md` was applied: correction
layers first within scope, then explicit supersession, then chronology and
dependency; packet-level artifacts outrank narratives.

## Required and superseding material consumed

| path | blob SHA | use |
|---|---|---|
| `problems/E-klein-cubic/NOTEBOOK.md` | `84f9dcd84d567e6c94656b39e9e3c49c845f6cbd` | binding theorem boundary; headline OPEN |
| `problems/E-klein-cubic/REPAIR.md` | `3198cf02288e672de0df86a561421d0d5386671a` | correction precedence; formal states are not covariants |
| `certificates/STRATA_EXACT.md` | `f2274bddc42c8726b2917fa0cd954f454b7a238f` | original exact strata packet |
| `certificates/NORMAL_CHARACTERS.md` | `4034630541e52a5e3aa36a01591b3341a23b2ba6` | local stabilizer/normal characters |
| `certificates/MARKED_S3_GEOMETRY.md` | `6afb8a196796cbf71eb6da4a740ddb66051d7a6a` | marked torsion and residual action |
| `certificates/global_transition/necessity_theorem.json` | `c9d9c7640cae49538084bb6d6e32d4b2a32f6d03` | forward-only global-state necessity |
| `certificates/transition_repair/CATEGORY_AUDIT.md` | `581a1f204e8ecdcaa141bafa128ecb4748fb9315` | source/normal/target line distinction |
| `certificates/lifting/OBSTRUCTION_TOWER.md` | `c2e52450a75db6b9672c3cdc4dc872e56553f0e6` | relative formal tower boundary |
| `certificates/global_finite_lifting/FINITE_TRUNCATION_THEOREM.md` | `bab70b6250f2ea871dd14e7056da9b0436d0bca5` | finite terminal system at fixed degree |
| `certificates/degree25_tower/TOWER.md` | `acfb1ee495b904bf0c079390ef918adf7e7c44fe` | degree-25 formal survival, not a covariant |
| `goal_runs_after_35fa/G_UNIVERSAL/ALL_DEGREE_THEOREM.md` | `4fa884983efcb65209b3bf325e2122c4c6dc2b07` | primitive/invariant-scalar equivalence |
| `certificates/degree25_global/COEFFICIENT_MODEL.md` | `1cf820a42f6ca205910a5f08fdb7c06847ddea7b` | exact dimensions 189, 59, 43 |
| `certificates/degree25_global/FULL_FINITE_TOWER.md` | `7a1208115671cabec3cfde05767037eea87e9d87` | later global tower remains undecided |
| `goal_runs_after_2880a28/FIX_A1_V4_INCIDENCE_REPAIR/CORRECTION.md` | `391144db0e2d4714b63e10586ff407ce2e6714ce` | superseding type-I/type-II incidence and tangent data |
| `goal_runs_after_fa02f05/FIX_A3_ELLIPTIC_SITES/STATUS.md` | `e4b9425a39bef835da8edfa4022ab4c092446879` | complete elliptic site inventory |
| `goal_runs_after_6519c0b/FIX_H0_GLOBAL_SECTIONS/STATUS.md` | `cac068f6509b1ac41c2efecbca2f42fbd71e3382` | exact plus-plane parity/base-locus theorem |
| `goals_after_bd610a/P25_COV_SUPPORT/P25_SUPPORT.md` | `6d3f241670aeee23e4e90145881e4ca9b7c70cd2` | latest degree-25 support remains undecided |

## Scoped correction introduced here

The older marked-geometry prose simultaneously states
`type-I=<q>`, `type-II=e+<q>`, and reflections `P mapsto e-P` for
`e in E[2]`. These cannot all use the same origin convention: the latter
reflections do not fix the installed marked points. With a type-I origin, the
three actual residual reflections have constants in `<q>`. This packet repairs
that coordinate convention while retaining the underlying exact incidence and
the `S3` action.

No existing general degree-25 status is superseded. This packet decides only
the proposed canonical `[-5]/id` boundary-extension route.
