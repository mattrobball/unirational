# Faithful V14 completion runbook

Date: 2026-08-12

Status: **execution plan; headline still open**

This is the operational companion to `HANDOFF_2026-08-12.md`.  The handoff
explains the mathematics and the boundary of what has actually been proved.
This file tells a less-capable agent exactly what to do next, in what order,
what it may edit, and what evidence is required before a task may be marked
complete.

The final objective is the unconditional theorem
`SchemeGeometry.noEquivariantRationalMap_from_ambient`, with no constancy,
dominance, matrix, normal-form, or certificate hypothesis in its type.

## Rules that override convenience

1. Work on **one work order at a time**.  Do not start a blocked order.
2. Never weaken or condition a target theorem to make it compile.
3. Never add `set_option maxHeartbeats` or `set_option maxRecDepth`.
4. Never use `sorry`, `admit`, `native_decide`, a project `axiom`, `opaque`,
   `unsafe`, `run_tac`, `implemented_by`, or an evaluator escape.
5. Split expensive finite proofs by row, column, coefficient, or monomial.
   Each declaration must fit Lean's stock budget.
6. A green umbrella build is irrelevant if the new module is not imported.
7. Do not add dominance to the rational-map statement.  Do not replace
   `Scheme.RationalMap` by `PartialMap`.
8. Do not use the old `finSuccEquiv` normal chart.  The valid chart is the
   corrected `(u,T,v)` chart with `T = minus_0 / plus_0`.
9. Do not replace `P(V+) x P(V-)` by a projective space.
10. The plus branch is the Segre branch, not a Veronese branch.
11. The shared worktree is dirty.  Never reset, clean, or run `git add -A`.
12. Preserve all unrelated changes.  Stage only files named in the completed
    work order.

## Completion vocabulary

Use only these status labels in `COMPLETION_STATUS_2026-08-12.md`:

- `READY`: all prerequisites are complete and the task may be started.
- `IN_PROGRESS`: exactly one agent owns the task.
- `BLOCKED`: a named prerequisite or genuinely missing mathematical/API fact
  prevents progress.  Record the exact smallest blocker.
- `RED`: the target exists but fails its stated acceptance command.
- `GREEN_LOCAL`: the target builds in isolation and passes its local audit.
- `ACCEPTED`: deterministic replay, axiom audit, hygiene scan, and required
  integration gates all pass.

`GREEN_LOCAL` is not `ACCEPTED`.  `/tmp` evidence is never `ACCEPTED` until it
has been moved into a durable project path and replayed there.

## The loop for every work order

Before editing:

```bash
git status --short
git rev-parse HEAD
rg -n 'set_option (maxHeartbeats|maxRecDepth)' V14Formalization scripts
```

Then:

1. Read this work order, every prerequisite theorem named in it, and no
   unrelated generated payload.
2. Record `IN_PROGRESS`, owner, timestamp, and the pre-edit hashes in
   `COMPLETION_STATUS_2026-08-12.md`.
3. Make the smallest source change satisfying the declared output contract.
4. Run the local build command.
5. Run the forbidden-token scan on only the touched files.
6. Run the stated axiom audit.
7. For generated files, regenerate twice into fresh directories and compare
   A to B and both to the proposed landed files.
8. Record exact commands, wall times, hashes, and theorem axiom sets.
9. Mark `ACCEPTED` only after every gate in the work order passes.
10. Update the next task from `BLOCKED` to `READY` when all its prerequisites
    have become `ACCEPTED`.

If a proposed theorem is false, do not silently change it.  Stop, mark the
task `BLOCKED`, give the counterexample or exact failed implication, and update
the architectural handoff.

## Dependency graph

```text
WO-00 preserve inputs
  |
  +--> WO-01 repair minus endpoint --> WO-02 seal minus generator
  |                                      |
  +--> WO-03 constant field ------------+--> WO-04 minus descent
  |
  +--> WO-05 plus generator/data --> WO-06 plus algebraic certificate
                                         |
WO-03 constant field --------------------+--> WO-07 cubic descent
                                                   |
WO-06 plus certificate + WO-07 cubic descent ------+--> WO-08 plus descent

WO-09 coordinate-to-scheme (independent) ---------------------+
WO-04 minus descent + WO-08 plus descent + WO-09 -------------+--> WO-10 fixed field point
                                            --> WO-11 rational-map constancy
                                            --> WO-12 unconditional headline
                                            --> WO-13 final trust audit
```

WO-01, WO-03, and WO-05 may be worked independently, but a less-capable agent
should do them sequentially in numeric order.

## WO-00: Preserve and verify the plus exploratory inputs

Status at this handoff: `READY`.

Difficulty: mechanical.

Purpose: turn the archived exploratory generator into a location-independent,
reproducible project generator before doing any plus work.  The generator,
M2 replay, and report are durably preserved under
`handoff_artifacts/2026-08-12/`; only the regenerated JSON remains ephemeral.

Authoritative current inputs and hashes:

| Source | SHA-256 |
|---|---|
| `handoff_artifacts/2026-08-12/export_sigma_plus_segre.py` | `9b4cd263916bd321ea53fb09d5028a4d4e62f835f6bbff029f40359bf37d7424` |
| `/tmp/sigma_plus_segre_Ki.json` | `52c1280a0a5e84128432db79e4d95753efe52a73d49a0fa450e69798a64965dc` |
| `handoff_artifacts/2026-08-12/sigma_plus_smooth_mod89.m2` | `e254e8a6bb2852fa843b1ab732c97723268047e7e319cc98b89f91cfe9c35f2d` |
| `handoff_artifacts/2026-08-12/sigma_plus_segre_REPORT.md` | `9ab7111c33b72ee188569c7a41e459ac3293a738e05f5d04b2d57ea2392a46a2` |

Required durable destinations:

- `scripts/export_sigma_plus_segre.py`;
- `results/sigma_plus_segre_Ki.json`;
- `scripts/sigma_plus_smooth_mod89.m2`;
- `SIGMA_PLUS_SEGRE_SOURCE_REPORT_2026-08-12.md`.

Run the archived generator once first and verify that it recreates the expected
JSON hash.  Then make these edits in the project copy:

1. Replace the hard-coded absolute repository path by
   `Path(__file__).resolve().parents[1]`.
2. Add `--out-dir`; every generated file must be written beneath that path.
3. Do not write to `/tmp` or `V14Formalization/` unless the caller explicitly
   supplies that output directory.
4. Continue reading only `results/d12_lean_K.json` and
   `results/sigma_normal_form_K.json` from the repository root.
5. Print the payload hash and output file hashes.
6. Fail closed on every matrix, span, inverse, determinant, and smoothness
   precondition currently asserted by the exploratory script.

Acceptance:

```bash
shasum -a 256 results/d12_lean_K.json results/sigma_normal_form_K.json
```

The expected hashes are respectively:

- `76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0`;
- `69c98b2df53b0689df935306fbe647014c7a8d46ea05c486f756ba20a61b426a`.

Run the revised generator twice into two fresh directories.  The JSON and M2
outputs must be byte-identical.  Run the M2 file; it must assert all three
smooth charts.  Record the new generator hash because changing path handling
will intentionally change the old generator hash.

Do not claim a Lean theorem in this work order.

## WO-01: Repair `D12SigmaMinusConcrete`

Status at this handoff: `RED`.

Difficulty: bounded Lean integration; no new mathematics.

Allowed edits:

- `V14Formalization/D12PolynomialEvaluation.lean`;
- `V14Formalization/D12SigmaMinusConcrete.lean`;
- `scripts/export_sigma_minus_normal_form_lean.py` only to keep regenerated
  source synchronized with the hand-written repair.

Do not edit any quadric, reverse, or reference payload in this work order.

Required public endpoint: the existing theorem, with its type unchanged:

```lean
D12SigmaMinusConcrete.common_plucker_zero_parametric
```

Current reproducible command:

```bash
lake build V14Formalization.D12SigmaMinusConcrete
```

At the handoff snapshot it fails for four local reasons:

1. `D12SigmaMinusConcrete.lean` must directly import
   `V14Formalization.D12SigmaCarrierConcrete`.
2. The eight `rw` calls after `fin_cases j` fail because the branch-local
   `Fin 4` values carry proof-dependent constructors.  Use `convert ... using
   1` plus `Fin.ext`, or define four literal-coordinate helper lemmas and
   dispatch through a `Fin.cases` recursor.  Do not raise limits and do not
   regenerate a giant match.
3. Add this generic scalar-extension lemma to
   `D12PolynomialEvaluation.lean`:

   ```lean
   theorem evalPolyAt_extension_eq_map_evalPolyAt
       (Omega : Type*) [CommRing Omega] [Algebra Q Omega]
       [Algebra WeilRep.K Omega] [IsScalarTower Q WeilRep.K Omega]
       (p : Polynomial Q) :
       evalPolyAt ((algebraMap WeilRep.K Omega) WeilRep.zeta) p =
         (algebraMap WeilRep.K Omega) (evalPolyAt WeilRep.zeta p)
   ```

   In project source use the actual Unicode names `ℚ` and `WeilRep.ζ`.  The
   proof is `Polynomial.aeval_algHom_apply` with
   `IsScalarTower.toAlgHom ℚ WeilRep.K Omega`.
4. Use that lemma twice:
   - transport `D12U6PolynomialSeal.evalPhi11_ζ` to prove `hPhi`;
   - transport `D12SigmaMinusReference.eval_disc_K_ne_zero` to close the
     discriminant nonvanishing goal.

After fixing the import, the spurious `Field Nat` and `sorry`-shaped cascading
errors should disappear.  If they remain, stop and record the first error
after the import; do not patch downstream cascades first.

Local acceptance:

```bash
lake build V14Formalization.D12SigmaMinusConcrete
```

Then create a temporary audit importing the module and run:

```lean
#print axioms V14Formalization.D12SigmaMinusConcrete.evalMatrixK_Bminus_poly
#print axioms V14Formalization.D12SigmaMinusConcrete.plucker_eq_evalQuadratic
#print axioms V14Formalization.D12SigmaMinusConcrete.linears_zero_of_quadrics
#print axioms V14Formalization.D12SigmaMinusConcrete.common_plucker_zero_parametric
```

Every set must be exactly `[propext, Classical.choice, Quot.sound]` or a subset.

Do not import this module into the umbrella yet.  That belongs to WO-02.

## WO-02: Make the complete minus packet reproducible and integrate it

Prerequisite: WO-01 `GREEN_LOCAL`.

Status at this handoff: `BLOCKED` by WO-01.

Difficulty: mechanical generation and audit.

Allowed edits:

- `scripts/export_sigma_minus_normal_form_lean.py`;
- all `V14Formalization/D12SigmaMinus*.lean` generated by that script;
- `V14Formalization.lean`;
- `V14Formalization/TrustGuard.lean`.

Generator requirements:

1. Add `--out-dir` and never write outside it.
2. Generate all data, ambient, eight quadrics, eight reverse shards,
   reference, and concrete modules.
3. Generate the direct import of `D12SigmaCarrierConcrete` and the repaired
   stock-safe proof from WO-01.
4. Run twice in fresh directories A and B.
5. Compare every output A=B and A=the proposed project file.
6. Independently replay all polynomial identities using a script that does
   not import the exporter.

Build every shard separately.  Each forced-cold generated target must finish
below 60 seconds wall time.  Then build `D12SigmaMinusConcrete`.

Only after those checks pass:

- import `D12SigmaMinusConcrete` from `V14Formalization.lean`;
- add TrustGuard entries for the four WO-01 endpoints, the eight quadric
  endpoints, eight reverse identities, `pullback`, `eval_disc`, and
  `common_plucker_zero_parametric`.

Acceptance:

```bash
lake build V14Formalization.D12SigmaMinusConcrete
lake build V14Formalization.TrustGuard
lake env lean V14Formalization.lean
```

## WO-03: Prove the relative constant-field theorem for `MvFrac`

Status at this handoff: `READY`.

Difficulty: reusable algebraic proof; no V14 matrices.

Create:

- `V14Formalization/MvFracConstantField.lean`.

Imports should initially be limited to
`V14Formalization.EllipticPolynomialConstancy` and the smallest required
RatFunc algebraicity module.

Required endpoints:

```lean
theorem ratFunc_isAlgebraic_iff_constant
    {K : Type*} [Field K] (x : RatFunc K) :
    IsAlgebraic K x ↔ ∃ a : K, x = RatFunc.C a

theorem mvFrac_isAlgebraic_iff_constant
    {K : Type*} [Field K] (n : Nat) (x : MvFrac K n) :
    IsAlgebraic K x ↔
      ∃ a : K, x = algebraMap K (MvFrac K n) a
```

Proof route for the RatFunc lemma:

1. Constants are algebraic by `IsAlgebraic.isAlgebraic`/`isAlgebraic_iff`.
2. For the converse, assume `x` is not `RatFunc.C a`.
3. Use `RatFunc.isAlgebraic_adjoin_simple_X'` from
   `Mathlib/FieldTheory/RatFunc/IntermediateField.lean`.
4. Combine algebraicity of `K(x)/K` with algebraicity of `K(X)/K(x)` by the
   tower theorem to make `RatFunc K` algebraic over `K`.
5. Contradict `RatFunc.transcendental_X` or the existing
   `Algebra.Transcendental K (RatFunc K)` instance.

Proof route for `MvFrac`:

1. Base case: transport through `mvFractionZeroAlgEquiv`.
2. Successor: transport through `mvFractionSuccRingEquiv n`.
3. Apply the RatFunc lemma over coefficient field `MvFrac K n`.
4. Apply the induction hypothesis to the resulting coefficient.
5. Use the already proved formulas
   `mvSuccToRatFunc_algebraMap_base` and the inverse formulas in
   `EllipticPolynomialConstancy.lean`.

Also provide this operational corollary, even if the proof uses a differently
named helper:

```lean
theorem mvFrac_eq_constant_of_map_eq_constant
    {K L : Type*} [Field K] [Field L] [Algebra K L]
    [Algebra.IsAlgebraic K L]
    (n : Nat)
    (f : MvFrac K n →ₐ[K] MvFrac L n)
    (hf : Function.Injective f)
    (x : MvFrac K n) (a : L)
    (h : f x = algebraMap L (MvFrac L n) a) :
    ∃ b : K, x = algebraMap K (MvFrac K n) b
```

It is acceptable to replace the explicit `f` by the canonical coefficient
base-change hom defined in this module.  It is not acceptable to assume `K`
algebraically closed.

Acceptance:

```bash
lake build V14Formalization.MvFracConstantField
```

Audit all three endpoints.  Then import the module into the umbrella and add
their TrustGuard entries.

## WO-04: Complete the minus projective descent

Prerequisites: WO-02 and WO-03 `ACCEPTED`.

Status at this handoff: `BLOCKED`.

Difficulty: small field/projective argument plus concrete assembly.

Create:

- `V14Formalization/BinaryQuadraticDescent.lean`;
- `V14Formalization/D12SigmaMinusDescent.lean`.

First endpoint:

```lean
theorem binaryQuadratic_projective_descends_mvfrac
    {K : Type*} [Field K] [CharZero K] (n : Nat)
    (A B C : K) (hdisc : B ^ 2 - 4 * A * C ≠ 0)
    (s t : MvFrac K n) (hst : s ≠ 0 ∨ t ≠ 0)
    (hq : A * s ^ 2 + B * s * t + C * t ^ 2 = 0) :
    ∃ (s0 t0 : K) (c : MvFrac K n),
      (s0 ≠ 0 ∨ t0 ≠ 0) ∧ c ≠ 0 ∧
      s = c * algebraMap K _ s0 ∧
      t = c * algebraMap K _ t0
```

Proof split:

- If `t ≠ 0`, set `r=s/t`.  It satisfies `A*r^2+B*r+C=0`, so it is
  algebraic over `K`; WO-03 makes it constant.  Take `c=t`.
- If `t=0`, then `s≠0`; take `(s0,t0,c)=(1,0,s)`.
- The discriminant excludes a doubled projective root and is required by the
  concrete geometric theorem, although the basic constant-ratio argument may
  use only that the displayed polynomial is nonzero.  Do not delete `hdisc`
  from the public theorem.

Concrete endpoint over `V14SchemeModel.k`:

```lean
theorem minusCarrier_commonPluckerZero_descends_mvfrac
    (n : Nat) (v : Fin 4 → MvFrac V14SchemeModel.k n)
    (hv : v ≠ 0)
    (hQ : ∀ q : Fin 15,
      D12Certificate.pluckerValue
        (((D12SigmaCarrierConcrete.core.Bminus).map
          (algebraMap V14SchemeModel.k _)).mulVec v) q = 0) :
    ∃ (v0 : Fin 4 → V14SchemeModel.k) (hv0 : v0 ≠ 0)
      (c : MvFrac V14SchemeModel.k n), c ≠ 0 ∧
      v = c • fun i => algebraMap V14SchemeModel.k _ (v0 i)
```

Then prove an ambient version for
`x = Bminus * v : Fin 15 → MvFrac K n`.  Use
`D12SigmaMinusConcrete.common_plucker_zero_parametric`, take `(s,t)=(v 2,v 3)`,
apply the binary theorem, and reconstruct the first two coordinates with
`lineParam`.  Use `D12SigmaCarrierConcrete.core.left_inverse_minus` to ensure
the base vector is nonzero when needed.

Acceptance:

```bash
lake build V14Formalization.BinaryQuadraticDescent
lake build V14Formalization.D12SigmaMinusDescent
lake build V14Formalization.TrustGuard
```

All public endpoints must have only the standard three axioms.  Import both
modules from `V14Formalization.lean` and guard
`binaryQuadratic_projective_descends_mvfrac`,
`minusCarrier_commonPluckerZero_descends_mvfrac`, and the ambient descent
wrapper.

## WO-05: Generate the plus Segre Lean data

Prerequisite: WO-00 `ACCEPTED`.

Status at this handoff: `BLOCKED` by WO-00.

Difficulty: generated finite certificates.  This work order creates data and
bounded identities; it does not prove cubic constancy.

Reuse existing definitions instead of defining a new quadratic extension:

- `GeometricV14Carrier.Ladj` is `K[i]`;
- `GeometricV14Carrier.iRoot` is the chosen root;
- `GeometricV14Carrier.aeval_iRoot` proves `iRoot^2+1=0`;
- `GeometricV14Carrier.minpoly_iRoot` and `fact_irr_X2p1` supply the field
  extension facts.

Create:

- `scripts/export_sigma_plus_segre_lean.py`;
- `V14Formalization/D12SigmaPlusSegreCore.lean`;
- bounded row/column/coefficient shards named
  `D12SigmaPlusSegre*.lean`;
- `V14Formalization/D12SigmaPlusSegreData.lean` as a thin aggregator.

Required definitions over `GeometricV14Carrier.Ladj`:

- `H : Matrix (Fin 9) (Fin 6) Ladj`;
- `L : Matrix (Fin 6) (Fin 9) Ladj`;
- `N : Matrix (Fin 3) (Fin 9) Ladj`;
- the optional `9 x 9` completion and inverse;
- `minorCoeff : Fin 9 → Fin 21 → Ladj` or an equivalent nine-quadratic
  representation;
- both quadratic-span coefficient matrices;
- `bilinearCoeff : Fin 3 → Fin 3 → Fin 3 → Ladj`;
- `Fplus : MvPolynomial (Fin 3) Ladj`.

Required finite identities:

```lean
L * H = 1
N * H = 0
N.mulVec z = 0 → z = H.mulVec (L.mulVec z)
```

and both directions of the nine-minor/fifteen-restricted-Plücker span,
coefficientwise equality `Fplus = det(bilinearCoefficientMatrix ...)`, and
the matrix identities connecting the packet's six carrier coordinates to
`D12SigmaCarrierConcrete.core.Bplus` after scalar extension.

Generation rules:

- never emit a single `fin_cases i <;> fin_cases j` proof over a large matrix;
- one coordinate theorem, then one bounded row/column dispatcher;
- polynomial identities modulo `Phi11` must carry explicit quotient witnesses;
- generated `Ladj` elements must use the existing `K` basis plus `iRoot`, not
  an unverified decoder;
- every target below 60 seconds forced-cold;
- two isolated regenerations and independent Fraction replay.

Do not add smoothness or point descent in this work order.

Acceptance:

```bash
lake build V14Formalization.D12SigmaPlusSegreData
```

Audit every aggregate matrix/span identity, not only sampled coordinate
lemmas.  Do not umbrella-import the packet until WO-06 supplies its public
certificate boundary.

## WO-06: Prove the plus Segre and smooth-cubic certificate

Prerequisite: WO-05 `ACCEPTED`.

Status at this handoff: `BLOCKED`.

Difficulty: bounded algebra plus one smoothness certificate.

Create:

- `V14Formalization/D12SigmaPlusSegreCertificate.lean`;
- if needed, separately generated smoothness shards.

Use the existing generic lemmas in `V14FixedPointSegreBridge.lean`.

Required endpoints:

```lean
theorem plusCarrier_commonPluckerZero_to_determinantalCubic
theorem Fplus_isHomogeneous : Fplus.IsHomogeneous 3
theorem Fplus_isSmoothPlaneCubic :
  BConicBundleMultisections.Standard.IsSmoothPlaneCubic Fplus
```

The first theorem must return nonzero `a,b : Fin 3 → L` after scalar
extension, the pure tensor equality, `A(a).mulVec b = 0`, and `Fplus(a)=0`.

Preferred smoothness certificate:

1. Compute exact characteristic-zero chart Nullstellensatz identities for the
   three charts `U=1`, `V=1`, and `W=1` over `Ladj`.
2. Serialize them coefficientwise into bounded Lean shards.
3. Use them to prove the pointwise definition of
   `Standard.IsSmoothPlaneCubic` directly.

Fallback only if exact identities are unmanageably large: formalize a general
good-reduction implication and use the mod-89 certificate.  The bare fact that
the M2 reduction was smooth is not a Lean proof and cannot be imported as a
boolean.

Also prove:

```lean
theorem smooth_detCubic_rank_eq_two
```

At a nonzero `a` with `Fplus(a)=0`, the `3 x 3` matrix `A(a)` has rank two.
The proof is by contradiction: rank at most one makes all cofactors zero; the
derivative of `det A(a)` in each coordinate is the corresponding linear
combination of cofactors, contradicting `Fplus_isSmoothPlaneCubic`.

Do not claim descent yet.

Acceptance:

```bash
lake build V14Formalization.D12SigmaPlusSegreCertificate
lake build V14Formalization.TrustGuard
```

Import the plus data and certificate modules into the umbrella.  Guard
`plusCarrier_commonPluckerZero_to_determinantalCubic`,
`Fplus_isHomogeneous`, `Fplus_isSmoothPlaneCubic`, and
`smooth_detCubic_rank_eq_two`, together with the aggregate inverse/span
identities on which they depend.

## WO-07: Prove smooth plane-cubic descent over an arbitrary ground field

Prerequisites: WO-03 and the generic smoothness APIs used by WO-06.

Status at this handoff: `BLOCKED` by WO-03.

Difficulty: the main non-computational proof-design task.

Create:

- `V14Formalization/SmoothPlaneCubicMvFracDescent.lean`.

Required endpoint:

```lean
theorem smoothPlaneCubic_projective_descends_mvfrac
    {K : Type*} [Field K] [CharZero K]
    (n : Nat) (F : MvPolynomial (Fin 3) K)
    (hF : Standard.IsSmoothPlaneCubic F)
    (a : Fin 3 → MvFrac K n) (ha : a ≠ 0)
    (hzero : MvPolynomial.eval a
      (MvPolynomial.map (algebraMap K (MvFrac K n)) F) = 0) :
    ∃ (a0 : Fin 3 → K) (ha0 : a0 ≠ 0)
      (c : MvFrac K n), c ≠ 0 ∧
      a = c • fun i => algebraMap K _ (a0 i)
```

Required proof route:

1. Base-change `F` and `a` to an algebraic closure `Kbar` using the canonical
   coefficient-extension map on `MvFrac` from WO-03.
2. Transport smoothness to `Kbar`.
3. Apply
   `ShortWeierstrassNormalForm.exists_shortWeierstrass_coordinates` to the
   base-changed cubic.
4. Transport the point through the returned matrix.  Use
   `WeierstrassSchemeDescent.projectivization_weierstrass_descends_mvfrac`
   over `Kbar`.
5. Transport back through the inverse matrix.  The image coordinates are
   constants in `Kbar`.
6. Each original coordinate is therefore algebraic over `K`.  Apply
   `mvFrac_isAlgebraic_iff_constant` coordinatewise.
7. Normalize one nonzero coordinate to obtain one common projective scalar;
   do not conclude only that each coordinate is individually constant with
   unrelated scalars.

If step 2 lacks a reusable lemma, add only the general theorem that
`Standard.IsSmoothPlaneCubic` is preserved by injective field base change.
Do not specialize that lemma to the D12 cubic.

The ground field in this theorem must not carry `[IsAlgClosed K]`.

Acceptance:

```bash
lake build V14Formalization.SmoothPlaneCubicMvFracDescent
lake build V14Formalization.TrustGuard
```

Import and guard `smoothPlaneCubic_projective_descends_mvfrac`.  Its printed
type must show only `Field K` and `CharZero K`, not `IsAlgClosed K`.

## WO-08: Complete plus-carrier and ambient descent

Prerequisites: WO-06 and WO-07 `ACCEPTED`.

Status at this handoff: `BLOCKED`.

Difficulty: finite-dimensional linear algebra assembly.

Create:

- `V14Formalization/D12SigmaPlusDescent.lean`.

Required generic helper:

```lean
theorem kernelLine_descends_of_rank_eq_two
```

For a rank-two `3 x 3` matrix over `K`, every nonzero kernel vector after
field extension is a scalar multiple of a nonzero base-field kernel vector.
Use a nonzero `2 x 2` minor and solve two coordinates in terms of the third,
or use the adjugate.  Do not choose a kernel basis nonconstructively without
proving base-change compatibility.

Required concrete endpoint:

```lean
theorem plusCarrier_commonPluckerZero_descends_mvfrac
```

It must conclude projective descent of the original six carrier coordinates
and of the resulting ambient `Fin 15` vector.  The proof must:

1. extend from `K` to `GeometricV14Carrier.Ladj`;
2. apply the plus Segre certificate;
3. descend the first factor with WO-07;
4. use rank two and `kernelLine_descends_of_rank_eq_two` to descend the second
   factor;
5. reconstruct the nine cross coordinates and then the original six
   coordinates with `L`;
6. use WO-03's algebraic-extension intersection result to return from `Ladj`
   constants to `K` constants.

Descent of only the first cubic projection is a failed endpoint.

Acceptance:

```bash
lake build V14Formalization.D12SigmaPlusDescent
lake build V14Formalization.TrustGuard
```

Import and guard `kernelLine_descends_of_rank_eq_two`,
`plusCarrier_commonPluckerZero_descends_mvfrac`, and the ambient descent
wrapper.

## WO-09: Convert descended coordinates back to V14 and fixed-locus points

Prerequisites: the already integrated `ProjectiveFamilyFieldPoint` and
`ProjectiveEigenvectorReduction` modules.

Status at this handoff: `READY`.

Difficulty: scheme API glue; no new geometry.

Create:

- `V14Formalization/ProjectiveFamilyFieldPointLift.lean`;
- `V14Formalization/V14FixedPointDescent.lean`.

Required generic endpoint:

```lean
theorem pointOfNormalizedCoordinates_lifts_projectiveZeroLocusFamily
```

Input: a normalized nonzero coordinate vector satisfying every homogeneous
family equation.  Output: a morphism to `projectiveZeroLocusFamily` whose
composite with `projectiveZeroLocusFamilyι` is the normalized projective point,
plus its base square.

Implementation reference:

- `BiprojectiveTwoEquationAffine.lean:216-232` for
  `IsClosedImmersion.lift` and `IsClosedImmersion.lift_fac`;
- `MultiProjectiveZeroLocus.lean:55` for
  `ker_projectiveZeroLocusFamilyι`;
- `ProjectiveFamilyFieldPoint.lean` for the forward kernel/evaluation bridge.

Also prove the converse action helper:

```lean
theorem pointOfNormalizedCoordinates_fixed_of_mulVec_eq_smul
```

Use `pointOfNormalizedCoordinatesAlgebra_comp_mapLinearSubst`.  Require the
eigenvalue scalar to be nonzero.  Do not reprove Away naturality.

The V14 wrapper must construct a base morphism
`Spec V14SchemeModel.k ⟶ V14SchemeModel.v14Scheme` from descended coordinates,
prove its base equation, and prove it is fixed by sigma.

Acceptance:

```bash
lake build V14Formalization.ProjectiveFamilyFieldPointLift
lake build V14Formalization.V14FixedPointDescent
lake build V14Formalization.TrustGuard
```

Import both modules.  Guard the generic lift, its factorization/base-square
lemmas, `pointOfNormalizedCoordinates_fixed_of_mulVec_eq_smul`, and the V14
wrapper.

## WO-10: Descend every pure-transcendental fixed field point

Prerequisite: WO-09 `ACCEPTED`.

Status at this handoff: `BLOCKED`.

Difficulty: branch assembly.

Create:

- `V14Formalization/V14FixedFieldPointDescent.lean`.

Use `k := V14SchemeModel.k` locally and this exact source type:

```lean
p : v14FieldPointOver L ⟶
  FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma
```

Required endpoint, allowing binder-order adjustments but no weaker content:

```lean
theorem v14FixedFieldPoint_descends_of_mvfrac
    (n : Nat) (L : Type*) [Field L] [Algebra V14SchemeModel.k L]
    (e : MvFrac V14SchemeModel.k n ≃ₐ[V14SchemeModel.k] L)
    (p : v14FieldPointOver L ⟶
      FixedBy V14SchemeModel.actionOver GeometricV14Carrier.sigma) :
    ∃ y : Spec (.of V14SchemeModel.k) ⟶ V14SchemeModel.v14Scheme,
      y ≫ V14SchemeModel.actionOver.V.hom = 𝟙 _ ∧
      y ≫ (V14SchemeModel.actionOver.ρ
        GeometricV14Carrier.sigma).left = y ∧
      p.left ≫
          (fixedByι V14SchemeModel.actionOver
            GeometricV14Carrier.sigma).left =
        Spec.map (CommRingCat.ofHom
          (algebraMap V14SchemeModel.k L)) ≫ y
```

Proof sequence:

1. Apply
   `exists_normalizedCoordinates_v14FixedBy_concrete_plus_or_minus_carrier`.
2. Transfer `L` coordinates through `e.symm` to `MvFrac k n`.
3. In the minus branch apply WO-04; in the plus branch apply WO-08.
4. Reconstruct a nonzero base ambient coordinate vector.
5. Prove projector and Plücker equations by injectivity of scalar extension.
6. Apply WO-09 to obtain `y : Spec k ⟶ v14Scheme`.
7. Apply the eigenvector-to-fixed-point helper to prove sigma fixedness.
8. Use normalized-coordinate reconstruction uniqueness to prove the final
   equality after `Spec.map (algebraMap k L)`.

Do not construct or claim a global decomposition of the fixed-locus scheme.

Acceptance:

```bash
lake build V14Formalization.V14FixedFieldPointDescent
lake build V14Formalization.TrustGuard
```

Import and guard `v14FixedFieldPoint_descends_of_mvfrac`.

## WO-11: Prove rational-map constancy on the exceptional divisor

Prerequisite: WO-10 `ACCEPTED`.

Status at this handoff: `BLOCKED`.

Difficulty: formal generic-point packaging.

Create:

- `V14Formalization/V14FixedRationalConstancy.lean`.

Required endpoint:

```lean
theorem rationalMapIsConstantOver_v14FixedBy
    (p q : Nat)
    (z : Scheme.RationalMap
      (BiprojectiveSpace p q V14SchemeModel.k)
      (FixedBy V14SchemeModel.actionOver
        GeometricV14Carrier.sigma).left)
    (hz : z.IsOver (Spec (.of V14SchemeModel.k))) :
    RationalMapIsConstantOver z
```

Implementation recipe:

1. Set `E := BiprojectiveSpace p q k` and
   `L := E.functionField`.
2. Use `Scheme.RationalMap.equivFunctionFieldOver` exactly as in
   `SchemeRationalConstancy.lean:178-188` to install that
   `z.fromFunctionField` is over `Spec k`.
3. Package `z.fromFunctionField` as an Over morphism
   `v14FieldPointOver L ⟶ FixedBy ...`.
4. Use
   `biprojectiveGeneralFunctionFieldAlgEquiv p q k` to identify `L` with
   `MvFrac k (p+q)`.
5. Apply WO-10.
6. Pass its ambient equality to
   `rationalMapIsConstantOver_fixedBy_of_comp_descends`.

No dominance hypothesis belongs in this theorem.

Acceptance:

```bash
lake build V14Formalization.V14FixedRationalConstancy
lake build V14Formalization.TrustGuard
```

Import and guard `rationalMapIsConstantOver_v14FixedBy`.  Inspect its printed
type and reject it if `Dominant`, `IsDominant`, or any constancy hypothesis is
present.

## WO-12: Add the unconditional faithful headline

Prerequisite: WO-11 `ACCEPTED`.

Status at this handoff: `BLOCKED`.

Difficulty: short final assembly.

Allowed edits:

- `V14Formalization/FaithfulHeadlineReduction.lean`;
- `V14Formalization.lean`;
- `V14Formalization/TrustGuard.lean`.

Add after `noEquivariantRationalMap_from_ambient_of_constancy`, in the same
namespace so the private abbreviations remain usable:

```lean
theorem noEquivariantRationalMap_from_ambient
    {V : Type} [AddCommGroup V] [Module k V]
    (R : FaithfulLinearRep k G V)
    (p q : Nat)
    (bp : Basis (Fin (p + 1)) k (R.plusEigenspace sigma))
    (bm : Basis (Fin (q + 1)) k (R.minusEigenspace sigma)) :
    ¬ HasEquivariantRationalMap
      (ambientFor R p q bp bm) V14SchemeModel.actionOver := by
  apply noEquivariantRationalMap_from_ambient_of_constancy R p q bp bm
  intro z hz
  exact rationalMapIsConstantOver_v14FixedBy p q z hz
```

Adjust only implicit arguments required by elaboration.  Do not add any
hypothesis to the theorem.

Add a TrustGuard entry for the new theorem and ensure every newly completed
module is imported before the guard.

Acceptance:

```bash
lake build V14Formalization.FaithfulHeadlineReduction
lake build V14Formalization.TrustGuard
```

Inspect the printed theorem type before continuing to WO-13.

## WO-13: Final acceptance and status reconciliation

Prerequisite: WO-12 `GREEN_LOCAL`.

Status at this handoff: `BLOCKED`.

Difficulty: mechanical audit.

Required commands:

```bash
lake build V14Formalization.FaithfulHeadlineReduction
lake build V14Formalization.TrustGuard
lake build V14Formalization
lake env lean V14Formalization.lean
```

Required hygiene scan over all newly added or modified files:

```bash
rg -n 'set_option (maxHeartbeats|maxRecDepth)|native_decide|sorry|admit|run_tac|implemented_by' <files>
```

Manually distinguish prose from declarations for `axiom`, `opaque`, and
`unsafe`; no such declarations are permitted.

The final axiom audit must include:

- both branch descent theorems;
- `v14FixedFieldPoint_descends_of_mvfrac`;
- `rationalMapIsConstantOver_v14FixedBy`;
- `noEquivariantRationalMap_from_ambient`.

Each must report exactly `[propext, Classical.choice, Quot.sound]` or a subset.

Reconcile `README.md`, `FAITHFULNESS_CHECK.md`, the architectural handoff, and
`COMPLETION_STATUS_2026-08-12.md`.  Only now may the project status change from
`OPEN / CONDITIONAL` to complete.

## If an agent gets stuck

The correct response is not to raise limits or weaken a theorem.  Record:

1. work-order identifier;
2. exact command;
3. first non-cascading Lean error;
4. smallest proposition or API equality not yet proved;
5. source hashes of touched files;
6. whether the obstacle is mathematical, API normalization, generated-data
   size, or dependency integration.

Then mark the order `BLOCKED`.  Work may proceed only on another `READY`
independent order.
