# Problem E — next goals after `35fa8f59b6a1423cc89300aeaceefe91552be5ba`

**Repository:** `mattrobball/unirational`  
**Audit boundary:** `35fa8f59b6a1423cc89300aeaceefe91552be5ba`  
**Headline:** **OPEN**

This round consumes the first all-out reports, corrects their implementation boundaries, and redirects effort toward the exact new bottlenecks. The initial audit is in [`IMPLEMENTATION_AUDIT.md`](IMPLEMENTATION_AUDIT.md).

## Tier 0 — canonicalization gate

| Rank | Goal | Purpose |
|---:|---|---|
| 0 | [`GOAL_A0_CANONICAL_IMPLEMENTATION_AUDIT.md`](GOAL_A0_CANONICAL_IMPLEMENTATION_AUDIT.md) | replay and canonicalize the duplicated C/COV packets, close the P25 verifier gap, and publish one authoritative route ledger |

Later workers may begin theorem-first analysis concurrently, but no large computation should consume a disputed packet before A0 resolves its authority.

## Tier A — strongest immediate headline opportunities

| Rank | Goal | Direction | New leverage |
|---:|---|---|---|
| 1 | [`GOAL_B_FIXED_FRAME_TO_GENERIC_BRIDGE.md`](GOAL_B_FIXED_FRAME_TO_GENERIC_BRIDGE.md) | negative | exact `C(K_proj)=empty` is already proved; only the bridge to a genuine versal object is missing |
| 2 | [`GOAL_P25_ENLARGED_CLOSURE_AND_SUPPORT.md`](GOAL_P25_ENLARGED_CLOSURE_AND_SUPPORT.md) | positive or degree-scoped negative | exact `746=690+56` structure and known failure of the old presentation |
| 3 | [`GOAL_C_EXPLICIT_MORITA_AND_COMMON_LINE.md`](GOAL_C_EXPLICIT_MORITA_AND_COMMON_LINE.md) | positive | exact lazy algebra, involution, and distinguished five-plane are now available |
| 4 | [`GOAL_COV_M1_EQUALIZERS_DEG31_35.md`](GOAL_COV_M1_EQUALIZERS_DEG31_35.md) | positive or scoped negative | all selected higher plane orders are dead; only the full `m=1` modules remain |
| 5 | [`GOAL_H2_A4_GENERIC_TWIST.md`](GOAL_H2_A4_GENERIC_TWIST.md) | negative or subgroup-positive | smallest exact unresolved proper-subgroup twist; index one; polynomial maps through degree four excluded |
| 6 | [`GOAL_T2_TARGET_BRANCH_NORMALIZATION.md`](GOAL_T2_TARGET_BRANCH_NORMALIZATION.md) | negative | genuine target branch still has a valid `Cl/Pic mod 3` headline bridge |

## Tier B — structural headline routes not implemented in the first round

| Rank | Goal | Direction |
|---:|---|---|
| 7 | [`GOAL_G2_UNIVERSAL_NOETHERIANITY.md`](GOAL_G2_UNIVERSAL_NOETHERIANITY.md) | negative or positive all-degree covariant theorem |
| 8 | [`GOAL_S19_MARKED_CURVE_CONTINUATION.md`](GOAL_S19_MARKED_CURVE_CONTINUATION.md) | positive marked degree-19 curve |
| 9 | [`GOAL_Q_SCHUR_INDEX_ONE_DECISION.md`](GOAL_Q_SCHUR_INDEX_ONE_DECISION.md) | positive or negative full Schur twist |
| 10 | [`GOAL_KLS2_MINIMALITY_TO_DISCREPANCY.md`](GOAL_KLS2_MINIMALITY_TO_DISCREPANCY.md) | negative, theorem-first |
| 11 | [`GOAL_J2_BASELOCUS_CONSTRAINED_PRYM.md`](GOAL_J2_BASELOCUS_CONSTRAINED_PRYM.md) | negative fixed-centre/Prym, now constrained by Goal D's countermodel |
| 12 | [`GOAL_V2_GENUINE_TWIST_VALUATION.md`](GOAL_V2_GENUINE_TWIST_VALUATION.md) | negative valuation route using the new infinity-place template |

## Tier C — independent proper-subgroup and birational geometry attacks

| Rank | Goal | Direction |
|---:|---|---|
| 13 | [`GOAL_H3_TWO_A5_GENERIC_TWISTS.md`](GOAL_H3_TWO_A5_GENERIC_TWISTS.md) | negative or subgroup-positive; preserve the two classes separately |
| 14 | [`GOAL_R2_RATIONAL_CURVES_ON_GENUINE_TWIST.md`](GOAL_R2_RATIONAL_CURVES_ON_GENUINE_TWIST.md) | positive rational-curve/Hilbert route |
| 15 | [`GOAL_M2_EQUIVARIANT_SARKISOV.md`](GOAL_M2_EQUIVARIANT_SARKISOV.md) | positive link or exhaustive negative rigidity theorem |
| 16 | [`GOAL_D2_MIXED_PRIME_STACK_INVARIANT.md`](GOAL_D2_MIXED_PRIME_STACK_INVARIANT.md) | negative only after selecting an invariant not refuted by Goal D |
| 17 | [`GOAL_H4_11_5_GENERIC_TWIST.md`](GOAL_H4_11_5_GENERIC_TWIST.md) | negative or subgroup-positive solvable-group twist |

## Routes retired or redirected

- **No further conic search on the installed fixed frame.** Goal F proved that criterion empty. Work now belongs to Goal B or V2.
- **No reuse of the old P25 690-row presentation as exact.** It is not `T`-stable.
- **No more selected higher-plane-order searches at `(25,3)`, `(31,5)`, or `(35,5)`.** Those global modules are zero.
- **No reuse of the unrestricted rational-Hodge/motive invariant from Goal D.** It is reproducible by free-orbit blowup centres.
- **No negative work on `D10` or `D12` subgroup twists.** Every such twist contains a base-field line and is soluble.
- **No use of the auxiliary degree-12 Morita-projector scheme as a Fano point.** It may supply coordinates for Morita reduction only.

## Dependency graph

```text
A0 canonical audit
 ├─> P25 enlarged support
 ├─> C explicit Morita/common line
 └─> COV m=1 equalizers

F fixed-frame pointlessness
 ├─> B bridge audit ──> possible immediate negative headline
 └─> V2 valuation transfer

B bridge failure
 └─> T2 genuine target-branch class group remains independent

H exact twists
 ├─> A4 first
 ├─> two A5 classes
 └─> 11:5

D route refutation
 ├─> J2 must constrain actual base-locus centres
 └─> D2 requires a genuinely new mixed-prime invariant
```

## Resource coordination

Likely heavy jobs:

- P25 closure/support;
- exact Morita/common-line elimination;
- COV degree-31/35 equalizers;
- target-branch normalization;
- S19 Hilbert components.

Only one unrelated job above 8 GiB should run at a time unless an external scheduler confirms sufficient headroom. Each heavy worker must publish a preflight with dimensions, sparsity, certificate format, checkpoint plan, and independent-verifier design before execution.

## Shared rules

1. Record the exact commit consumed and produced.
2. Use the exit strings in the assigned goal file.
3. Do not promote modular ranks, special fibres, finite ansätze, or solver termination without the stated transfer theorem.
4. Every positive object is substituted into the original genuine equations.
5. Every negative headline includes the complete versal/subgroup/exhaustiveness bridge.
6. Independent verifiers recompute the load-bearing claim, not JSON counters.
7. Put artifacts only in the route-specific `goal_runs_after_35fa/` directory.
8. Do not modify sealed historical packets.
9. No Magma dependency.
