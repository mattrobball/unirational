# Authoritative inputs

The audit is pinned to goal commit
`35fa8f59b6a1423cc89300aeaceefe91552be5ba`.  Its live start commit was
`37d61c19a108781cf74af837e24810a9f7f7c3be`.

The producer and independent verifier hash-check these inputs:

| Input | Role |
|---|---|
| `goals_after_35fa8f/GOAL_B_FIXED_FRAME_TO_GENERIC_BRIDGE.md` | binding contract |
| `goals_after_35fa8f/IMPLEMENTATION_AUDIT.md` | canonical Goal F boundary |
| `goals_2026-08-01/F_CONIC_ALGEBRA/SEAL.json` | exact `C(K_proj)=empty` theorem and scope |
| `goals_2026-08-01/F_CONIC_ALGEBRA/field_presentation.json` | exact ordered degree-six presentation |
| `goals_2026-08-01/F_CONIC_ALGEBRA/payload/global_primitive_u_sextic_exact.tsv` | all 1,593 primitive sextic terms |
| `goals_2026-08-01/F_CONIC_ALGEBRA/infinity_obstruction.json` | infinity factor, ordered place, residual index-three theorem |
| `certificates/fixed_frame_arithmetic/five_forms.json` | all coefficients of `F0,FA,FB,FY,FZ` |
| `certificates/fixed_frame_arithmetic/SEAL.json` | fixed-frame coefficient seal |
| `certificates/pfaffian_point/SEAL.json` | accepted Pfaffian bridge audit |
| `certificates/pfaffian_point/IDEMPOTENT_TO_KLEIN_POINT.md` | projector/Fano dictionary |
| `certificates/pfaffian_point/quaternion_corner.json` | smallest five-Hermitian-equation gate |
| `tmp/pfaffian_rank2_idempotent_attack/PROOF_AUDIT.md` | primary functional-calculus rank-two identity (used to correct a later convention inconsistency) |
| `certificates/fold_normalization/payload.json` | finite birational simple-fold component |
| `certificates/fold_normalization/SEAL.json` | repaired normalization boundary |
| `certificates/target_branch_global/H_factor/H_primitive_integer.tsv` | exact target divisor equation |
| `certificates/target_branch_global/SEAL.json` | target-branch global seal |
| `certificates/TARGET_BRANCH_MOD3_CLASS_GROUP.md` | exact `BR-T-NEG` gate and theorem boundary |
| `certificates/target_branch_mod3/payload.json` | residue-degree-one, smooth-cubic, and open mod-three gate |
| `certificates/target_branch_mod3/SEAL.json` | target mod-three packet seal |
| `certificates/fano_interface_c0/C0_MODEL.md` | current executable Fano-model boundary |
| `certificates/fano_interface_c0/SEAL.json` | C0 scope seal |

The three large exact equation inputs are byte-copied into `exact/` by the
producer so this output packet is self-contained; their source and local
hashes must agree.

No output from another concurrent route directory is consumed.  In
particular, the exact conic theorem is replayed but its search is not rerun.
