# Implementation audit at `35fa8f59b6a1423cc89300aeaceefe91552be5ba`

**Repository:** `mattrobball/unirational`  
**Original all-out dispatch:** `problems/E-klein-cubic/goals_2026-08-01/`  
**Audit boundary:** no result after `35fa8f59b6a1423cc89300aeaceefe91552be5ba` is consumed  
**Headline:** **OPEN**

## 1. Executive verdict

Six of the fifteen dispatched routes produced substantive reports by the audit boundary:

- degree-25 support (`P25`);
- Pfaffian–Morita/Fano (`C`);
- conic/intersection algebra (`F`);
- structured covariant search (`COV`);
- equivariant motive/degree formula (`D`);
- proper-subgroup twists (`H`).

Nine dispatched routes have no new route packet after the all-out dispatch:

- target branch (`T`);
- universal all-degree lifting (`G`);
- Schur degree-19 curve (`S19`);
- KLS minimality/conductor (`KLS`);
- unrestricted Schur index-one descent (`Q`);
- valuation/tropical pointlessness (`V`);
- equivariant Sarkisov models (`M`);
- resolved fixed-centre Prym/1-motive (`J`);
- rational curves on the genuine twist (`R`).

No worker reached a positive or negative headline. The implemented workers were generally disciplined about theorem boundaries. The main deficiencies are duplicated/noncanonical output directories, one materially incomplete independent verifier, and one exit label whose literal wording is broader than the theorem actually proved.

## 2. Route-by-route faithfulness

### P25 — partial implementation, honest exit, verification debt

Authoritative packet:

```text
certificates/degree25_p25v/
```

Proved over `F_89`:

- the 690-seed lower presentation is not `T`-stable;
- all 4,140 degree-four `T_i(s_a)` tests and all 315 recorded commutator tests fail membership in the old degree-four seed span in the bulk FLINT calculation;
- Stage A of the kernel incidence remains empty;
- the full and compressed support problems remain undecided.

This faithfully refuses to infer emptiness from an interrupted `msolve` run. It also correctly preserves the safe lower-presentation implication.

**Audit defect:** `verify_p25v0.py` independently rebuilds `rank(V_0)=690` and proves each of the 126 missing cubic rows is outside `V_0`, but it reads the decisive `4140` and `315` counts from JSON. It does not independently recompute the quartic-level map

```text
S_1 tensor (V_0 + W) -> S_4
```

or the bulk membership conclusions. The producer had already encountered and repaired an input-destruction bug in FLINT rank computation. Therefore `P25V-PRESENTATION-ENLARGED` is strongly supported but must be independently replicated before it becomes a canonical dependency.

**Goal completion:** not achieved; `P25V-SUPPORT-UNDECIDED` is faithful.

### C — substantial C0/C1 progress, no C2/C3, noncanonical duplication

Three collision-avoidance directories were published:

```text
C_PFAFFIAN_FANO/
C_PFAFFIAN_FANO_CODEX_ROOT/
C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/
```

The union of accepted progress is:

- exact characteristic-zero minimal polynomials of the two installed generators and the scalar `b^6` block;
- an exact lazy maximal-etale multiplication interface for `L_a` via invariant Cramer circuits;
- fresh-prime verification of the rectangular basis and multiplication;
- exact transport of the symplectic involution to the rectangular model, with `+/-` dimensions `15/21`;
- exact identification of the distinguished five-plane inside the algebra with involution.

The workers correctly state that none of this is yet:

- a self-adjoint reduced-rank-two idempotent in explicit exact coordinates;
- a Morita quaternion corner;
- five `3 x 3` Hermitian matrices;
- a simultaneous common isotropic line;
- a point of the genuine `F_{14,T}`.

The ambient degree-12 projector scheme is explicitly labelled auxiliary. One sibling cyclotomic-conjugate RUR was detected as invalid because its harness mutated a copy of a `runpy` namespace; it is not consumed by the authoritative audit.

**Audit defect:** there is no single canonical seal joining the exact lazy algebra, involution, and distinguished five-plane. The three directories overlap, and consumers can easily select a stale or invalid sibling artifact.

**Goal completion:** not achieved; all `C-UNDECIDED` exits are faithful.

### F — complete scoped theorem, correctly no headline

Authoritative packet:

```text
F_CONIC_ALGEBRA/
```

The worker proves an exact residue-degree-one infinity place of the installed degree-six field and computes that the residual fixed-frame plane cubic has index three. Proper specialization yields

```text
C(K_proj) = empty
```

for the installed fixed-frame plane cubic. The bidirectional conic/intersection-algebra criterion is therefore empty. The verifier recomputes the exact field layer, reciprocal leading factor, residual net, good-reduction base scheme, and class-group/index argument.

The worker correctly withholds the Klein-cubic headline because the repaired repository does not identify pointlessness of this auxiliary fixed-frame plane cubic with pointlessness of the genuine generic Klein twist.

**Design issue in the original goal:** its mission prose suggested an accepted positive bridge from the fixed-frame cubic, while its scoped exit correctly required a fresh bridge audit. The worker followed the repaired theorem boundary rather than the optimistic mission wording.

**Goal completion:** `F-CONIC-CRITERION-EMPTY` is a faithful and substantial scoped exit.

### COV — two compatible partial results, one misleading exit label

Published directories:

```text
COV_STRUCTURED_SEARCH/
COV_STRUCTURED_SEARCH_ROOT/
```

Exact combined conclusions:

1. At `(d,m,e)=(25,3,7),(31,5,1),(35,5,5)`, the global coefficient module is zero already after the first normal Taylor coefficients. Thus the selected higher-plane-order branches do not globalize.
2. Consequently, any landing covariant in degrees 25, 31, or 35 must have plane order `m=1`.
3. The named composition, invariant-gradient cross-product, and mixed ansatz families are exactly empty in characteristic zero.
4. The full `m=1` equalizers and landing schemes in degrees 31 and 35 were not constructed. Degree 25 remains the known strict 43-space problem.

The main directory uses the accurate exit

```text
COV-NEW-ANSATZ-STRUCTURAL
```

and explicitly records that COV0 was not completed.

**Audit defect:** the root directory uses

```text
COV-STRUCTURED-DEGREES-EMPTY-SCOPED
```

although its own theorem says the degrees are not excluded and `m=1` remains live. The theorem is useful and apparently independently verified, but that exit string must not be consumed as degree-wide emptiness. The canonical replacement is `COV-HIGHER-ORDER-BRANCHES-EMPTY-SCOPED` or the existing structural exit.

**Goal completion:** positive mission not achieved; structural progress is faithful after correcting the exit semantics.

### D — faithful completed route refutation

Authoritative packet:

```text
D_EQUIVARIANT_MOTIVE/
```

Exit:

```text
D-INVARIANT-REPRODUCIBLE
```

The worker audits the relative-dimension-one bridge, proves the classical index-valued degree formulas are vacuous because every twist has index one, corrects the splitting identity to `r i = n id`, and constructs an unrestricted equivariant blowup-centre system reproducing the target rational Hodge/motivic summand. This is exactly the route-refutation exit authorized by Goal D.

The packet does not claim that the reproducing centres occur in the base locus of a landing covariant. That limitation is explicit and is the correct boundary.

**Goal completion:** faithfully completed at a negative-for-the-route scoped exit. Do not rerun the same unrestricted invariant.

### H — faithful subgroup sweep, exact new models, no pointlessness

Authoritative packet:

```text
H_SUBGROUP_TWISTS_ROOT_019FBE10/
```

Exit:

```text
H-SWEEP-UNDECIDED
```

The worker:

- proves the subgroup-twist bridge;
- treats the two maximal `A_5` classes separately;
- installs exact generic Hilbert-90 frames and genuine twisted Klein equations for both `A_5` classes, `A_4`, and `11:5`;
- proves all selected twists have index one;
- proves every `D_10` and `D_12` twist is soluble by a stable contained line;
- excludes all polynomial `A_4` landing maps through degree four, for all three projective character multipliers.

The seal/commit binding was corrected in two follow-up commits. The final packet does not identify index one with a point and does not promote the bounded `A_4` search.

**Goal completion:** faithful undecided exit. The smallest unresolved exact twist is `A_4`; degree five is only a finite polynomial gate, not an exhaustive point test.

## 3. Canonical consumption rules pending a new audit packet

Until the next implementation-audit goal completes:

1. consume `F_CONIC_ALGEBRA` as a scoped pointlessness theorem only;
2. consume `D_EQUIVARIANT_MOTIVE` and `H_SUBGROUP_TWISTS_ROOT_019FBE10` at their stated exits;
3. consume the COV theorem only as elimination of the named ansätze and the three higher-plane-order branches;
4. do not consume `COV-STRUCTURED-DEGREES-EMPTY-SCOPED` as degree-wide emptiness;
5. do not consume the P25 quartic nonmembership theorem without independent reproduction of the decisive bulk map;
6. for Goal C, use the lazy algebra/involution/five-plane data only after a canonical merge identifies exact file hashes and quarantines invalid sibling RURs;
7. treat the nine unimplemented goals as still open at their pre-dispatch state.

## 4. Immediate mathematical consequences for the next round

- The most leveraged new fact is exact pointlessness of the fixed-frame cubic. The next question is the missing bridge to the genuine generic twist, not another conic search.
- Degree 25 must be reformulated using the enlarged `T`-stable relation module; the old 690-row presentation is known to be insufficient.
- The Pfaffian route should stop interpolating expanded `L_a` entries: an exact lazy algebra, involution, and five-plane already exist. The next task is the explicit projector/Morita/common-line problem.
- The selected `e=1` and `e=5` high-plane-order positive branches at degrees 31 and 35 are dead; only `m=1` remains in all three structured degrees.
- The standard equivariant motive/Hodge route is too flexible without proving restrictions on actual base-locus centres.
- Among proper subgroups, `D_10` and `D_12` are retired negatively; `A_4` is the smallest installed unresolved generic twist.
