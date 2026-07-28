# Formalization status

Current as of 27 July 2026. This file is the authoritative Lean status; it supersedes older
progress notes and historical blocker lists.

Build state on branch `agent/weaken-hypotheses`, 27 July 2026: `lake build` green at **3317 jobs**,
`lake build Statement Solution` green at **8866 jobs**, every audited endpoint at
`[propext, Classical.choice, Quot.sound]`, project-module `sorry` census **2**
(`ResidualHorizontalityLine:300`, `Standard/GenericSmoothness:171`, neither on the headline path).

## Headline: fully proved

### Independently verified, 26 July 2026

Checked from the committed tree rather than taken from any agent's report:

| check | result |
|---|---|
| `#guard_no_sorry` on the headline theorem (`MainTheoremGuard:91`) | builds — that elaborator errors on `sorryAx`, so building **is** the check |
| `Statement.lean` diff vs. last commit | one blank line added, zero deletions — `HasUnirationalParametrization`, `Bidegree23ZeroLocus.toSpec` and `IsBidegree23` are byte-identical, so the statement was **not weakened** |
| `#check` on the theorem | matches the statement pinned at the top of `PLAN.md` |
| `#print axioms` on the theorem | `[propext, Classical.choice, Quot.sound]` — no `sorryAx` |
| non-vacuity: `Bidegree23Example.smooth_F` | axiom-clean, so `[Smooth …]` is satisfiable |
| non-vacuity in every char ∤ 6: `Bidegree23Example.exists_smooth_bidegree23` | axiom-clean; explicit witness, no genericity argument |
| `axiom` / `admit` / `native_decide` | none anywhere in the tree |
| `lake build` | green, 3305 jobs |

The non-vacuity check is not redundant: a vacuous theorem passes every axiom check and every `sorry`
census. `smooth_F` is what separates "proved" from "proved about nothing" — and the obvious Fermat
candidate is *singular*, machine-checked, so the witness had to couple every `x` to every `y`
through a Vandermonde matrix.

**One `sorry` remains in the tree** — `det_residualYCoordsOn_ne_zero` in `ResidualHorizontalityLine`
— and it is **not on the theorem's dependency path**, which is precisely what the clean axiom check
establishes. Horizontality was reached by another route; the declaration is vestigial and is kept
only because its docstring records why `hgood`, `hv2` and `hpolar` are each necessary.

The faithful theorem has no auxiliary geometric hypotheses:

```lean
theorem smooth_bidegree23_hasUnirationalParametrization
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F)
```

The characteristic hypothesis is `ringChar k ∤ 6`, not characteristic zero; `Statement.lean` and
`Solution.lean` still ask for `[CharZero k]`, which this proves a fortiori through the bridging
instances of `NeZeroTwoThree.lean`.

It is proved in `BConicBundleMultisections/MainTheorem.lean`. The existential wrapper
`smooth_bidegree23_isUnirationalOver` is proved as well.

**`[IsAlgClosed k]` is no longer part of the mathematics.** As of 27 July 2026 the headline above is
a *corollary* of a theorem in the same file that assumes no algebraic closure at all:

```lean
theorem smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection
    (k : Type u) [Field k] [PerfectField k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (hline : ∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
      (v : Fin 3 → Polynomial k), Standard.HasActualG3G4LineSection F p q r N v) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F)
```

`Standard.HasActualG3G4LineSection F p q r N v` unfolds to exactly the good-line/Tsen-section
package: `lineFrame p q r * N = 1`, G3 (`ResidualLineNonconstantOn`), `HasNondegenerateLineStereoSection`
(`v ≠ 0`, isotropic, `v 2 ≠ 0`, nonvanishing stereographic polar form), and G4
(`ResidualAvoidsConicDiscriminantOn`). Nothing else is assumed of `k` beyond perfectness and
char ∤ 6. The headline is recovered by supplying `hline` from
`Standard.exists_actualG3G4LineSection_via_frameIncidence`, which is where — and now only where —
`[IsAlgClosed k]` is used. See "The closure-free theorem" below.

The direct audit reports:

```text
'BConicBundleMultisections.smooth_bidegree23_hasUnirationalParametrization' depends on axioms:
[propext, Classical.choice, Quot.sound]

'BConicBundleMultisections.smooth_bidegree23_isUnirationalOver' depends on axioms:
[propext, Classical.choice, Quot.sound]
```

`MainTheoremGuard.lean` pins the exact theorem type and applies `#guard_no_sorry` both to the
headline theorem and to its statement guard. Adding an auxiliary hypothesis, weakening the
dimension, changing the target, or reintroducing `sorryAx` now breaks the build.

## Verified build state

Environment:

- Lean `4.32.1`
- Mathlib `v4.32.1`
- publication target `main`, fast-forwarded from
  `agent/formalize-conic-bundle-and-audit-klein-cubic`

Checks run from this problem directory:

```text
focused final dependency-and-audit build
  Build completed successfully (3291 jobs).

lake env lean MainTheoremAxiomAudit.lean
  all eight selected endpoints: standard three axioms only

lake build BConicBundleMultisections
  Build completed successfully (3305 jobs).

lake build
  Build completed successfully (3305 jobs).
```

The build emits existing style/linter warnings, but no errors. Focused source-and-axiom-audit
builds also passed for the chart transition, factor transition, automatic gluing, projective
integrality, and final target-reduction layers.

The Mathlib-only `Statement.lean`/`Solution.lean` package was also accepted by upstream Comparator
v4.32.0 retargeted to Lean v4.32.1 on macOS and Linux. Both runs reached theorem-closure,
permitted-axiom, export, and Lean default-kernel acceptance. The macOS run used Comparator's
insecure fake-landrun shim; the Apple-container Linux kernel had Landlock disabled, so its
`--best-effort` sandbox degraded to no Landlock restrictions. This is a proof-validation result,
not an adversarial sandbox-security claim.

The commit containing this file publishes the result together with its axiom-audit corpus and the
separate, explicitly open Klein-cubic research dossier. Exploratory B-side files outside the live
theorem and audit closure remain uncommitted.

## Mathematical route formalized

The proof no longer tries to prove that one hardcoded coordinate line is good. Its live route is:

1. `Standard.exists_actualG3G4LineSection_via_frameIncidence` chooses one actual framed line that
   simultaneously carries G3, a nondegenerate Tsen section, and G4.
2. `targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth` proves the retained target
   relations projectively integral away from the conic discriminant.
3. Local residual factors are constructed on every retained target chart. For two charts, target
   bihomogeneity gives

   ```text
   F_b = T^3 F_b',    Q_b = T Q_b'.
   ```

   From `R_b F_b = Q_b` and `R_b' F_b' = Q_b'`, nonvanishing of the conic equation permits
   cancellation and yields the intrinsic degree-minus-two law

   ```text
   R_b' = T^2 R_b.
   ```

   A homogeneous target quadratic satisfies `P_b = T^2 P_b'`, so the two square laws give
   `P_b R_b = P_b' R_b'`; the product is independent of the retained chart.
4. `targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn` turns that coefficientwise
   compatibility into global regular functions on the integral projective target curve. Proper
   integral global functions are constant, and the negative-twist argument forces the residual
   relation coefficients to vanish.
5. `hasUnirationalParametrization3_biprojectiveZeroLocus_of_actualG3G4LineSection` assembles a
   given G3/G4 line, projective integrality, and automatic gluing into the
   residual-component/unirational-tower construction, over an arbitrary perfect field of
   char ∤ 6. `hasUnirationalParametrization3_biprojectiveZeroLocus` is its specialization: step 1
   supplies the line, and that is the sole use of `[IsAlgClosed k]`.
   `MainTheorem.smooth_bidegree23_hasUnirationalParametrization` is definitionally the same raw
   biprojective statement and delegates to this endpoint.

The main assembly lives in:

| Layer | Principal module / endpoint |
|---|---|
| Simultaneous line and section | `Standard/G3FrameIncidenceSelection.lean` / `exists_actualG3G4LineSection_via_frameIncidence` |
| Target integrality | `TargetRelationTotalSpaceIntegral.lean` / `targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth` |
| Intrinsic chart transition | `ProjectiveHypersurfaceChartTransition.lean` and `ResidualTargetNegativeTwistChartEquationTransport.lean` |
| Residual factor transition | `ResidualTargetNegativeTwistFactorTransition.lean` / `residualTargetNegativeTwistFactor_coeff_intrinsic_transition` |
| Automatic gluing | `ResidualTargetNegativeTwistAutomaticGluing.lean` / `targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn` |
| Closure-free assembly | `MainTheoremTargetReduction.lean` / `hasUnirationalParametrization3_biprojectiveZeroLocus_of_actualG3G4LineSection` |
| Closure-free public theorem | `MainTheorem.lean` / `smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection` |
| Final clean reduction | `MainTheoremTargetReduction.lean` / `hasUnirationalParametrization3_biprojectiveZeroLocus` |
| Exact public theorem | `MainTheorem.lean` / `smooth_bidegree23_hasUnirationalParametrization` |

Each new load-bearing endpoint has a neighboring `AxiomAudit.lean` file and was checked to depend
only on `propext`, `Classical.choice`, and `Quot.sound`.

## The exact remaining project-module `sorry` boundary

Excluding trusted comparator input `Statement.lean`, whose theorem body is intentionally the
challenge placeholder, an anchored source census finds exactly two direct legacy declarations in
the project modules:

| Module | Declaration | Current role |
|---|---|---|
| `Standard/GenericSmoothness.lean` | `exists_nonempty_open_smooth_restrict` | Strengthened legacy generic-smoothness interface; orphaned and unused by the headline route |
| `ResidualHorizontalityLine.lean` | `det_residualYCoordsOn_ne_zero` | Old isolated-determinant route; retained for reference and unused by the headline route |

Neither declaration is in the dependency closure of the headline theorem. This separation is
machine-checked by `#guard_no_sorry` and confirmed by the explicit axiom printout above. These are
cleanup tasks, not open boundaries of the formalized main theorem.

The old determinant-dependent chain remains available as a legacy conditional development, but
the following declarations no longer feed the headline:

- `det_residualYCoordsOn_ne_zero`
- `eq_zero_of_aeval_residualYCoordsOn_of_isHomogeneous`
- `residualYCoordsOn_ne_zero_of_good_line`
- `isDominant_residualZeroLocusPointOn_toBase`
- `isDominant_residualComponentOnToBase`
- `exists_isDominant_residualComponentOnToBase`
- `smooth_bidegree23_hasUnirationalParametrization_of_good_line_section`

## Statement fidelity and non-vacuity

`Bidegree23Example.smooth_F` gives a concrete, axiom-clean smooth bidegree-`(2,3)` example, and
`MainTheoremGuard.lean` pins it. Thus the `Smooth` hypothesis in the universal theorem is
satisfiable; the proof is not vacuous. `Bidegree23Example.exists_smooth_bidegree23` extends this
to every algebraically closed field with `2 ≠ 0` and `3 ≠ 0`, so non-vacuity now covers exactly the
characteristic range the rest of the development assumes — see the char-∤-6 section below.

`CoordinateLineCounterexample.lean` records the complementary warning:
`Bidegree23Example.residualLineConstant` proves that the hardcoded coordinate line can have
constant residual line even for a smooth example. This is why the final proof uses an actual line
selected by frame incidence rather than silently normalizing an arbitrary fixed line.

The obsolete full-`residualImage` route is also not the headline route. The complete intersection
`V(F) ∩ V(q_F)` can acquire vertical components when the coefficients of `q_F` have a common
factor, so a claim of domination by irreducible affine space would be false for that full reducible
scheme. The formal proof works with the residual component actually reached by the residual map.

## Hypothesis audit: how far the headline hypotheses can be weakened

Recorded on branch `agent/weaken-hypotheses`. The headline statement **has** changed on this
branch: `[CharZero k]` is now `[NeZero (2 : k)] [NeZero (3 : k)]`, and
`MainTheoremGuard.headline_statement_guard` was updated to pin the new type byte-for-byte. That is
the one guard edit this weakening legitimises; no other guard was touched.

### `CharZero` → char ∤ 6: done, headline included

Every `[CharZero k]` on the headline path is gone. The theorem runs on `[NeZero (2 : k)]
[NeZero (3 : k)]`, and exactly five `[CharZero]` binders survive in the library, none of them
reachable from the headline: three in `GenericCubicNondegeneracy` (item 3 below), one in
`AlgebraicIndependenceJacobian.eq_zero_of_isHomogeneous_of_aeval_eq_zero` (Euler division by an
unbounded degree `d`; the headline uses the `[PerfectField k]` version in
`JacobianCriterionCharFree` instead), and one in `Bidegree23Example.hasUnirationalParametrization_F`,
where it is only a convenient way to supply `NeZero` of `2`, `3` and `5` at once.

The single *essential* use — the Euler step in the Jacobian criterion, which needs `(d : k) ≠ 0` for
unbounded `d` — was removed first: `JacobianCriterionCharFree.lean` proves the same criterion from
`[PerfectField k]`, which `IsAlgClosed` supplies by instance.

Three statements on the headline path were genuinely false in positive characteristic. **All three
are now settled**: two were repaired, and the third is confined to declarations nothing consumes.

1. ~~`FirstProjectionSmoothFiber.exists_algebraicClosure_coordinateDerivation`~~ — **repaired, in
   two steps.** The derivation extension went through `Algebra.FormallyEtale.of_isSeparable`, and
   `CharZero` was supplying exactly one thing: `Algebra.IsSeparable K (AlgebraicClosure K)`, free in
   char 0 and false in char `p`. It is *not* the perfect closure that repairs this — a perfect field
   of char `p` has **no nonzero derivations at all** (`D z = D((z^{1/p})^p) = 0`), so passing there
   destroys the tool. It is the **separable** closure:
   `Algebra.FormallyEtale K (SeparableClosure K)` holds with no characteristic hypothesis.
   `exists_separable_coordinateDerivation` is stated for an arbitrary separable extension and
   carries none.

   That concentrated the whole char-0 dependence of the project in one self-contained statement
   about plane cubics: *a singular point of a plane cubic can be taken separable over the base
   field*, `exists_separableClosure_singularPoint_of_cubic`. It is now **proved** under
   `[NeZero (2 : K)] [NeZero (3 : K)]`, in the new module
   `BConicBundleMultisections/CubicSingularSeparable.lean`, and that is what removed `CharZero`
   from the headline. In char ∤ 3, Euler gives `Z = V(∂₀G, ∂₁G, ∂₂G)`, cut by three conics, and the
   proof runs:

   * **the descent** — `separableClosure K Ω` is separably closed and `2 ≠ 0`, so *one* coordinate
     ratio in it already forces the whole point in: the free coordinate is a root of a quadratic
     over that field, or all three quadratics vanish identically and the point with that coordinate
     `0` is already a common zero. Only one degree bound is ever needed.
   * **the main branch** — two coprime partials feed
     `ConicResultant.exists_polynomial_ne_zero_natDegree_le_four`, and
     `SeparableLowDegree.mem_separableClosure_algebraicClosure_of_natDegree_le_four` makes the ratio
     separable. The chart `y₂ = 0` needs no elimination: the last two coordinates are `(1,0)`, or
     the point is `(1 : 0 : 0)` and already rational.
   * **the degenerate branch** — no pair coprime. It never uses the given point; it builds one.
     Either an irreducible factor `h` common to all three, so `V(h) ⊆ Z`: for `deg h = 2` restrict
     to `X₂ = 0` and take a root of the resulting quadratic, or, if that quadratic degenerates,
     take `(1 : 0 : 0)`, which is then on `V(h)`. Or `h₀₁ ∤ q₂`, in which case `h₀₁` and `h₀₂` are
     relatively prime, their product divides the conic `q₀`, both are linear, every `qⱼ` is
     divisible by one of them, and two linear forms in three variables have a nonzero common zero
     already over `K` — a rank count, no cross-product minors.

   The `p^m ≤ 4` with `m ≥ 1` numerology is why quasi-elliptic fibrations live exactly in
   characteristics `2` and `3`: the degree bound replaces the classification in the only case
   needed.

   Two corrections to earlier drafts of this argument, both recorded because they were load-bearing:

   * **Separability, not rationality, is what is true.** An integral plane cubic over `K` need not
     be *geometrically* integral — `G = N_{L/K}(ℓ)` with `[L:K] = 3` is three Galois-conjugate
     lines with three conjugate singular points, none `K`-rational. The genus-1 uniqueness argument
     applies only to geometrically integral curves. Degree ≤ 4 still gives separability at `p ≥ 5`,
     which is all the derivation needs.
   * **Two partials need not be coprime.** The triangle `G = y₀y₁y₂` has partials `y₁y₂, y₀y₂,
     y₀y₁`, pairwise non-coprime, so naive Bézout does not apply. That is the second bullet of the
     degenerate branch above. The nontrivial-gcd branch (`G = y₀³`, `Z = V(y₀²)`) is the first.

   The Mathlib gaps that blocked earlier attempts were closed inside the project rather than
   waited on: `HomogeneousFactor.lean` gives that a divisor of a nonzero homogeneous polynomial is
   homogeneous, and `ConicResultant.lean` gives the conic resultant with both directions —
   including the packaged form that survives the centre-of-projection degeneracy, where the naive
   resultant vanishes identically.
2. ~~`StereoJacobian.exists_C_mul_of_wronskian_eq_zero`~~ — **repaired.** The lemma
   (`f'g = g'f → f = c·g`) really is false in char `p` (`f = Xᵖ`, `g = 1`), but the generality is
   what forced char 0: its only consumer applies it to the pure-`t` coefficients of the generic
   conic along `L = {Y₂ = 0}`, and those are cubics in `t`
   (`natDegree_ternaryQuadraticCoeff_coordinateLineSpecializedConicPoly_le`, proved from
   bidegree `(2,3)` via `natDegree_coeff_specializeSecondCoordinates_map_C_le`). At degree `≤ 3` the
   obstruction disappears for char `≥ 5`, which char ∤ 6 supplies. `[CharZero k]` is replaced by
   `∀ N, 0 < N → N ≤ max f.natDegree g.natDegree → (N : k) ≠ 0` — exactly what the proof consumes,
   through `natCast_natDegree_eq_zero_of_derivative_eq_zero`. `polarEval_stereo_pderiv_t_ne_zero`,
   `stereoJacobianDet_ne_zero_of_smooth` and the two arbitrary-line audit theorems in
   `ResidualHorizontalityLineAudit.lean` moved to `[NeZero (2 : k)] [NeZero (3 : k)]` with it.
   With item 1 proved, that chain now carries no `CharZero` at all.
3. `GenericCubicNondegeneracy.finiteExtensionCoordinateDifferential` extends a differential along a
   finite field extension — the same separability obstruction, and it does **not** yield to the
   move that fixed item 2. It quantifies over an arbitrary finite extension `L` of `k(X_σ)`, and
   every field of characteristic `p` has purely inseparable ones: for `L = K(X_i^{1/p})`, writing
   `X_i = uᵖ` gives `D(X_i) = p·u^(p−1)·D u = 0` for *any* derivation of `L`, while
   `finiteExtension_deriv_algebraMap` asserts `D(X_i) = pderiv i X_i = 1`. So the accompanying
   theorems are false, not merely unproved. There is no degree bound to exploit: the offending
   extension has degree exactly `p`, so it exists precisely in the range char ∤ 6 permits.
   Mathlib is gated the same way — the whole section containing
   `Differential.differentialFiniteDimensional` carries `[CharZero F]` — so even adding
   `[Algebra.IsSeparable K L]` would not make the construction available without new Mathlib-side
   work. These three declarations are currently consumed by nothing.

Two modules looked worse than char ∤ 6 and were not:

* `HesseProjectiveResidualRigidity.octic_coefficients_eq_zero` interpolated on 45 points and divided
  by `8! = 40320`, needing char ∉ {2,3,5,7}. Replaced by `CoefficientVanishing.coeffs8_eq_zero`
  (`Polynomial.funext` over an infinite domain), which divides by nothing: **1082 lines → 56**, and
  the hypothesis drops to `Infinite R`, free from `IsAlgClosed`. A `maxHeartbeats 16000000` was
  deleted, not added.
* The Hesse/Weierstrass and short-Weierstrass normal forms divide only by 2s and 3s.

`linear_combination₆` (`NeZeroTwoThree.lean`) is what found the 5s and 7s: `linear_combination` with
a normalizer that clears numeral denominators using the char-∤-6 facts instead of `CharZero`. It
fails loudly on any certificate dividing by 5 or 7, which is how both problems above surfaced rather
than being silently absorbed.

A trap worth recording: `[CharZero k]` does **not** give `[NeZero (3 : k)]` by instance search —
`NeZero.charZero_ofNat` does not fire for `(3 : k)` over a field, and `(2 : k)` works only via a
dedicated instance. Without `NeZeroTwoThree.NeZero.charZeroThree` the "weakening" would not have
been one, and `Solution.lean` could not have called the main theorem.

### The non-vacuity witness was char ∉ {2,3,5}; it is now char ∤ 6 — *fixed*

`Bidegree23Example.smooth_F` carries an explicit `[NeZero (5 : k)]`, and that is not slack:
`Bidegree23Example.not_smooth_F_of_ringChar_five` proves that in characteristic five the zero locus
of `F` is genuinely singular, at `([0:1:2], [1:0:1])`. So the witness really was a property of the
polynomial chosen, not of the theorem, and it left the characteristic-five case of a
characteristic-∤-6 theorem unwitnessed.

That gap is closed. `Bidegree23Example` is now parameterised by the coefficient matrix:
`exampleForm M` is `∑_{i,l} M_{i l} xᵢ² y_l³`, and `IsSmoothCoefficientMatrix M` — every entry,
every `2 × 2` minor, and `det M` nonzero, nineteen scalars — is exactly what
`gradient_eq_zero_imp_exampleForm` consumes, together with `2 ≠ 0` and `3 ≠ 0`. The nineteen
conditions are also necessary; only sufficiency is formalised.

`F` is the instance at the Vandermonde matrix of the nodes `1, 2, 3` and is unchanged, so
`MainTheoremGuard` and `CoordinateLineCounterexample` are untouched. The new
`Bidegree23Example.universalMatrix = !![1,1,1; 1,2,3; 1,3,4]` has all nineteen scalars in
`{±1, ±2, ±3, ±4}`, so `Bidegree23Example.exists_smooth_bidegree23` gives a smooth
bidegree-`(2,3)` form over **every** algebraically closed field with `2 ≠ 0` and `3 ≠ 0` — no
genericity argument, no appeal to the base field being infinite. Characteristic five is recorded
separately as `Bidegree23Example.exists_smooth_bidegree23_of_ringChar_five`. All three are pinned
in `MainTheoremGuard.lean`.

### `IsAlgClosed` splits three ways

Measured by actual API consumption, not by binders: `vanishingIdeal_zeroLocus_eq_radical` ×11,
`exists_root` ×9, `exists_pow_nat_eq` ×5, `splits` ×1, `ringHom_bijective_of_isIntegral` ×1,
`perfectField` ×1. `GeometricPointDescent.lean` classifies these and carries out the removable part.
Conclusions about coefficients descend; hypotheses of the form "no common zero" ascend and must be
assumed over the big field; existence of a rational point is irreducible — and the construction
needs a good line and a Tsen section, both points. So the honest generalization is not "drop
`IsAlgClosed`" but "hypothesise the points", with algebraic closure demoted to a sufficient
condition.

The three descents need three different strengths of hypothesis on the coefficient map: `a ≠ 0`
from `φ a ≠ 0` needs nothing; `p = q` from `φ p = φ q` needs exactly injectivity; `x ∈ I` from
`φ x ∈ I.map φ` needs faithful flatness. Only the middle is a real hypothesis, and it is minimal.
`Ideal.comap_map_eq_self_of_faithfullyFlat` is the third; what Mathlib lacks is the instance for
`MvPolynomial σ k → MvPolynomial σ K`.

### `Infinite` is never a hypothesis of the mathematics

It enters only through `MvPolynomial.funext` (~12 sites) and descends;
`GeometricPointDescent.funext_of_forall_eval_eq_algebraicClosure` is the drop-in, with no hypothesis
on `k` at all. Mathlib's `funext_set` does not help — infinite test sets force an infinite ring. The
genuine alternative is `MvPolynomial.eq_zero_of_eval_zero_at_prod_finset` (Alon–Füredi), which trades
infiniteness for degree bounds and would apply here, but buys a theorem over small finite fields that
the source argument cannot support anyway.

### The `IsAlgClosed` surface, re-measured on the proof term — 27 July 2026

**This subsection supersedes the two that follow it.** The earlier "257 binders, 243 genuinely
needed" figure was taken on the endpoint's **import closure**. The import closure is not the proof:
of the 161 modules it contains, most contribute nothing to the live argument, and inside a module a
single `variable [IsAlgClosed k]` line attaches the binder to every declaration that mentions `k`
whether or not the proof uses it. Measured on the **proof term** instead — walk the value of
`hasUnirationalParametrization3_biprojectiveZeroLocus_of_negativeTwistTargetGeometry` transitively —
the surface is an order of magnitude smaller.

Two corrections that change the plan, both machine-checked.

**1. `smooth_bidegree23_hasUnirationalParametrization_of_good_line_section` is `sorry`-tainted.**

```text
'BConicBundleMultisections.smooth_bidegree23_hasUnirationalParametrization_of_good_line_section'
  depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound]
```

It is the obvious place to start a weakening pass — it already takes the good line and the Tsen
section explicitly — but it routes through `exists_isDominant_residualComponentOnToBase` →
`residualYCoordsOn_ne_zero_of_good_line` → `det_residualYCoordsOn_ne_zero`, the legacy
determinant `sorry` at `ResidualHorizontalityLine:300`. It is on the list of superseded
declarations above; that list is right, and anything built on it inherits `sorryAx`. The
`sorry`-free endpoint with the same shape is
`hasUnirationalParametrization3_biprojectiveZeroLocus_of_negativeTwistTargetGeometry`
(`ResidualTargetRelationGeometryNegativeTwist.lean:155`), which additionally takes G4, projective
integrality and negative-twist gluing — the last two being *proved* from smoothness one layer up,
so they are not extra assumptions of the headline.

**2. The live surface is 118 declarations with 15 roots, not 243.**

| measurement (proof-term closure of the `sorry`-free core) | value |
| --- | --- |
| project declarations in the closure | 1975 |
| of those, carrying `IsAlgClosed`, `Infinite` or `PerfectField` | **118** |
| of those, **minimal** — nothing else in the set is below them | **15** |
| minimal and carrying `IsAlgClosed` | **7** |
| minimal and carrying `Infinite` | **7** |
| minimal and carrying `PerfectField` | **1** |

`Infinite` and `PerfectField` have to be counted with `IsAlgClosed`: an arbitrary field supplies
neither, and both are currently obtained from closure by instance search, so a census that greps
for `IsAlgClosed` alone understates the job. The 118 was 128 before the free deletions committed
below; the 15 was 24.

**3. Block 1 — dominance by closed points — is not in the live core at all.** Machine-checked
against the same proof term:

```text
AlgebraicGeometry.residueFieldIsoBase                        in closure: false
ProjectiveSpace.closedPointNormalizedCoordinates             in closure: false
closedPoint_mem_range_biprojectiveZeroLocusSnd               in closure: false
isDominant_biprojectiveZeroLocusSnd_of_smooth_bidegree23     in closure: false
sorryAx                                                      in closure: false
```

The `residueFieldIsoBase` apparatus — the hardest of the four blocks, ≈46 import-closure binders,
and the one whose fix was thought to require base-change comparison isomorphisms the project does
not have — is reached only from the **line-selection** layer (`Standard/*`,
`PointedConicOpenDominance`, `TargetRelationTotalSpaceIntegral`), which is exactly what the core
endpoint replaces by hypotheses. Dominance inside the core is established by injectivity of an
explicit coordinate-ring map (`injective_standardChartEvalAlgebra_residualComponentOnYCoordsNorm`),
not by exhibiting `k`-rational closed points. The same census on the *headline* theorem gives 201
`IsAlgClosed`-typed declarations against the core's 97, and `PointedConicOpenDominance` contributes
23 of the difference: those binders are the price of *choosing* the line, not of using it.

The seven `IsAlgClosed` roots, and what each consumes:

| root | Mathlib API | replacement |
| --- | --- | --- |
| `Hypersurface.sup_span_pderiv_eq_top_of_exists_pderiv_ne_zero` | `vanishingIdeal_zeroLocus_eq_radical` | `…_of_geometric`, built |
| `eq_C_of_forall_eval_ne_zero` | `IsAlgClosed.exists_root` | `…_of_geometric`, built |
| `exists_det_ne_zero_of_forall_ne_zero` | `vanishingIdeal_zeroLocus_eq_radical` | `…_of_geometric`, built and **wired** |
| `mul_eval_eq_of_disc_ne_zero` | `IsAlgClosed.splits` | `eq_smul_…_of_geometric`, built |
| `exists_common_nonzero_zero_of_card_lt` | `vanishingIdeal_zeroLocus_eq_radical` | `…_of_geometric`, built |
| `globalSectionsMapFromBase_bijective_of_isIntegral_of_universallyClosed` | `IsAlgClosed.ringHom_bijective_of_isIntegral` | `RelativelyAlgClosedRationalFunctionField`, built |
| `mem_radical_span_pair_of_vanishes_on_common_zero` | `vanishingIdeal_zeroLocus_eq_radical` | `…_of_isRadical` geometric form, built |

The seven `Infinite` roots — `isHomogeneous_of_eval_smul`,
`polarEval_lineStereoDir_ne_zero_of_polarEval_ne_zero`, `pencilDiscPoly_ne_zero`,
`binaryLineRestriction_eq_zero_of_dir_eq_zero`, `eq_X2_mul_of_eval_on_X2_zero`,
`exists_eval_ne_zero_affineTwoRing`, `eval_stereoAlg_inf_eq_zero` — are all
`MvPolynomial.funext` / `Polynomial.funext` sites, and
`GeometricPointDescent.funext_of_forall_eval_eq_algebraicClosure` discharges them with **no
hypothesis on `k` at all**. `isHomogeneous_of_eval_smul` is discharged in the tree already: see
`coeff_cubicFiberJacobianFamily_isHomogeneous_of_geometric` below.

The single `PerfectField` root is
`JacobianCriterionCharFree.eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField`. Perfectness
is genuinely used there and is genuinely false for an imperfect field of characteristic `p`, so
this is the one place where a fallback statement would carry a **(T)**, namely `[PerfectField k]`.
It is free in characteristic zero and for finite fields.

**Consequence for the ask.** Every remaining root is a *descent* problem — conclusions over `k`
reached after working over `k̄`, with hypotheses that ascend and are supplied by `Smooth` through
`SmoothExtensionJacobian` — and **not** a rational-point problem. The two genuine
rational-point inputs, the good line and the Tsen section, are already explicit hypotheses of the
core endpoint. So the projected hypothesis inventory of a closure-free core is:

* **(P)** the framed line `p₀ q₀ r N`, `hMN`, and `hgood : ResidualLineNonconstantOn …` — already there;
* **(P)** the Tsen section `v`, `hv0`, `hv`, `hv2`, `hpolar` — already there;
* **(P)** `havoid : ResidualAvoidsConicDiscriminantOn …` (G4) — already there;
* **(T)** `[PerfectField k]`, unless the Jacobian criterion is rerouted through the separable closure;
* nothing else.

`hintegral` and `hglue` must **not** appear: they are proved from smoothness by
`targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth` and
`targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn`, so hypothesising them would be the
dishonest move recorded at the end of this section.

**What is done, 27 July 2026.** Two commits, both purely additive or binder-only, tree green at
3315 / 8865 jobs, headline axioms unchanged, sorry census still 2.

* `CubicFiberSingularLocus` has a complete base-field-free interface:
  `elimCertificates_spec_of_geometric`, `exists_defining_set_forms_no_common_zero_of_geometric`,
  `exists_defining_set_nonsingular_cubicFiber_of_bidegree23_of_geometric`, and — removing the
  `Infinite` axis from that chain — `isHomogeneous_of_map_isHomogeneous`,
  `map_map_universalCubicFiber`, `map_map_cubicFiberJacobianFamily`,
  `coeff_cubicFiberJacobianFamily_isHomogeneous_of_geometric`,
  `famMatrix_cubicFiber_isHomogeneous_of_geometric`,
  `elimCertificates_isHomogeneous_of_geometric`. Homogeneity is a support statement, so it descends
  along the injective coefficient extension; the universal cubic fibre commutes with base change.
* Nine free `IsAlgClosed` deletions: seven in `GoodLineCondition` (one `variable` line that only two
  declarations in the section actually need), plus
  `StereoJacobian.eval_eq_zero_of_free_polar_root` and
  `PointedConicRationalFamilies.exists_chartQuotient_openImmersion`.

**What is not done.** ~~The 103 non-minimal declarations have not been rethreaded, so the core
endpoint still carries `[IsAlgClosed k]` and no closure-free theorem exists yet.~~ **Superseded by
the next subsection: the core endpoint is closure-free and the closure-free theorem exists.**

### The closure-free theorem — 27 July 2026

The projected inventory at the end of the previous subsection is now realised exactly, with no
extra item. The remaining two binders were on the two *producers*, and both were shed:

| producer | before | after |
| --- | --- | --- |
| `targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth` (`TargetRelationTotalSpaceIntegral:673`) | `[Field k] [IsAlgClosed k] [NeZero 2] [NeZero 3]` | `[Field k] [NeZero 2] [NeZero 3]` |
| `targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn` (`ResidualTargetNegativeTwistAutomaticGluing:159`) | `[Field k] [IsAlgClosed k]` | `[Field k]` |

Neither needed a proof change. By the time the preceding passes had finished — retained-chart
domain theorems in `TargetRelationChartDomain` (never carried closure), the smooth-nonvanishing
lemma `affineChartEquationOverTargetRelationBase_ne_zero_of_smooth_irreducible` and the
cancellation lemma `factor_over_targetRelationBase_unique_of_smooth_irreducible`
(`ResidualTargetNegativeTwistQuotientUniqueness`, both already `[Field k]`), and the intrinsic
transition transport — the `[IsAlgClosed k]` binders on the whole intermediate layer were
**vestigial**: they had been attached by `variable` lines and by copy-forward, and no proof in
`ResidualTargetNegativeTwistFactorTransition`, `ResidualTargetNegativeTwistAutomaticGluing` or
`TargetRelationTotalSpaceIntegral` consumed them. A vestigial `[Infinite k]` on
`residualTargetNegativeTwistFactor_coeff_intrinsic_transition` went the same way. Both producers
were then instantiated over `ℚ` as a check that this is not an instance-resolution artefact.

In particular, the descent worry recorded in the hazards — *geometrically* integral ⟹ integral,
so integrality would have to be proved over `k̄` and descended — never had to be paid. The
retained-chart cover is built from explicit affine quotients whose primality
(`isPrime_twoEquationAffineChartIdeal_targetRelation`) is proved over the given field directly;
the closure binder above it was decoration.

The assembly:

| endpoint | module | binders |
| --- | --- | --- |
| `hasUnirationalParametrization3_biprojectiveZeroLocus_of_negativeTwistTargetGeometry` | `ResidualTargetRelationGeometryNegativeTwist` | `[Field] [PerfectField] [NeZero 2] [NeZero 3]` |
| `hasUnirationalParametrization3_biprojectiveZeroLocus_of_actualG3G4LineSection` | `MainTheoremTargetReduction` | same |
| `hasUnirationalParametrization3_biprojectiveZeroLocus_of_exists_actualG3G4LineSection` | `MainTheoremTargetReduction` | same |
| `smooth_bidegree23_hasUnirationalParametrization_of_goodLineSection` | `MainTheorem` | same |
| `hasUnirationalParametrization3_biprojectiveZeroLocus` | `MainTheoremTargetReduction` | `[IsAlgClosed]`, now re-derived from the row above |
| `smooth_bidegree23_hasUnirationalParametrization` | `MainTheorem` | unchanged, byte-identical |

`[PerfectField k]` did **not** spread. It was already on the core endpoint and it stays exactly
where the previous subsection put it: one root,
`JacobianCriterionCharFree.eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField`, reached
through `ResidualComponentExhaustion.isDominant_residualTargetPointOn_toFirst_of_smooth`, where
`p`-th roots of coefficients are taken. It is free in characteristic zero and for finite fields,
and `IsAlgClosed` supplies it by instance, which is why the headline is unaffected.

`MainTheoremGuard.lean` gained three `#guard_no_sorry` lines and nothing else; the headline
statement guard and every existing guard are untouched. The two axiom-audit files gained entries
for the new endpoints. All of them print `[propext, Classical.choice, Quot.sound]`.

### The core/corollary split over `IsAlgClosed` — the earlier, import-closure measurement

**Superseded by the subsection above; the numbers here are import-closure numbers and overstate the
job.** Retained because the four-block decomposition and the negative results about
`residueFieldIsoBase` and `finiteExtensionCoordinateDifferential` are still correct.

**Attempted and measured, 27 July 2026.** The goal was to split the
headline into a core theorem over an arbitrary field, hypothesising the good line, the Tsen section
and G4, plus a corollary supplying them from algebraic closure. The natural core is
`hasUnirationalParametrization3_biprojectiveZeroLocus_of_negativeTwistTargetGeometry`
(`ResidualTargetRelationGeometryNegativeTwist.lean:155`), which already takes exactly those inputs
and carries `[IsAlgClosed k]`. **That binder cannot be removed without rebuilding most of the
development**, and the measurements below are what establish it. They were taken by machine, not by
reading.

Method: strip every `[IsAlgClosed …]` binder in the endpoint's import closure, then let the compiler
restore the binder on every declaration whose proof breaks, to a fixed point. A restored declaration
is one that consumes algebraic closure *as currently written*; a surviving strip is one that never
did.

| measurement | value |
| --- | --- |
| project modules in the endpoint's import closure | 161 |
| of those, modules carrying `[IsAlgClosed …]` binders | 53 |
| `[IsAlgClosed …]` binders in them | 257 |
| binders deletable outright, no proof change | **9** |
| binders weakenable to `[Infinite …]`, no proof change | **14** |
| binders that still need `IsAlgClosed` verbatim | **243** |
| direct `IsAlgClosed`-API call sites in the closure | 35, in 14 modules |

So `Infinite` is *not* the bottleneck: it accounts for 14 of 257 binders, and `StereoJacobian` for a
further 10. Together the two items previously believed to be the whole remaining job cover under 10%
of the surface.

The 35 direct API sites break down as `residueFieldIsoBase` ×20,
`vanishingIdeal_zeroLocus_eq_radical` ×8, `IsAlgClosed.exists_root` ×3, and one each of
`isCoprime_iff_aeval_ne_zero_of_isAlgClosed`, `IsAlgClosed.exists_aeval_eq_zero`,
`IsAlgClosed.splits`, `IsAlgClosed.ringHom_bijective_of_isIntegral`. The remaining ~208 restored
declarations are transitive consumers, each of which would have to be restated with the ascended
(geometric) hypothesis before its own binder could go.

**The geometric twins are built but unwired.** Every `_of_geometric` / `_of_embedding` variant was
checked for consumers outside its own defining module:
`smooth_biprojectiveZeroLocusToSpec_of_gradient_of_geometric`,
`flat_biprojectiveZeroLocusSnd_of_geometric`, `eq_C_of_forall_eval_ne_zero_of_geometric`,
`eq_smul_of_eval_eq_zero_on_isotropic_cone_of_geometric`,
`exists_det_ne_zero_of_forall_ne_zero_of_geometric`,
`mem_span_pair_of_vanishes_on_common_geometric_zero_of_isRadical`,
`exists_common_nonzero_zero_pair_of_geometric`, `exists_nonzero_zero_of_isHomogeneous_of_geometric`
have **zero**. Nothing on the headline path has been rethreaded through any of them. The prior
passes added the descent leaves; they did not move the chain onto them, which is why the binder
count did not fall.

Four methodological rebuilds stand between here and the core theorem, in rough order of cost.

1. **The dominance layer is closed-point based, and that method is only valid over an algebraically
   closed field.** `residueFieldIsoBase` (Mathlib, `AlgebraicGeometry/AlgClosed/Basic.lean`) says the
   residue field at a closed point of a finite-type `k`-scheme *is* `k`; over a general field it is a
   finite extension and the statement is false. The whole
   `ProjectiveSpaceClosedPoints.closedPointNormalizedCoordinates` apparatus is built on it, and
   `closedPoint_mem_range_biprojectiveZeroLocusSnd` → `surjective_…` →
   `isDominant_biprojectiveZeroLocusSnd_of_smooth_bidegree23` proves dominance by exhibiting
   `k`-rational closed points, as does `closedPoint_mem_range_residualImageToBase` in
   `ResidualMultisectionDominant`. Note these are `def`s as well as theorems, so the fix is not a
   hypothesis edit. Replacing them means either a generic-fibre nonemptiness argument or descending
   dominance from `k̄`, and the latter needs base-change comparison isomorphisms
   `X ×_{Spec k} Spec k̄ ≅ X_{k̄}` for the project's `Proj`-based schemes, which neither the project
   nor Mathlib currently provides in this presentation. ≈46 binders.
2. **The pointed-conic rationality layer.** `PointedConicOpenDominance` (27 binders, incl.
   `irreducible_genericConicAffineChart`, `isDomain_genericConicAffineChart`,
   `isIntegral_biprojectiveZeroLocus_of_smooth_bidegree23`) and `PointedConicRationalFamilies` (16,
   3751 lines). The mathematics survives — a nondegenerate conic is geometrically integral over any
   field — but the proofs route irreducibility through closure. ≈53 binders.
3. **The stereographic / free-direction layer.** `SpecializedConicFreeDir` (24 binders, 4194 lines),
   `StereoJacobian` (10), `ResidualYNonvanishing` (6), `ResidualYCoordsPureT` (5) and neighbours use
   `IsAlgClosed.exists_root` to produce a root of an auxiliary univariate polynomial, and
   `IsAlgClosed.splits` in `IsotropicCone`. These are the "hypotheses ascend" cases and are the most
   mechanical of the four, but they are also where the line count is. ≈69 binders.
4. **The Nullstellensatz and proper-global-sections layers.** ≈65 binders across
   `BiprojectiveSmoothCriterion`, `ConicProjectionFlat`, `ResidualTargetRelationNullstellensatz`,
   `ProjectiveHypersurfaceNegativeTwist`, `ProperIntegralGlobalSections` and the target-relation
   assembly. This is the layer where the replacements already exist
   (`…_of_geometric`, `…_of_embedding`, `RelativelyAlgClosedRationalFunctionField`) and only the
   wiring is missing — but the wiring changes the *statement* of
   `TargetRelationsResidualNegativeTwistGluingAwayDiscriminantOn`, which is a hypothesis of the
   endpoint, so it cannot be done in isolation.

One enabling piece *is* already in place and should not be rebuilt: `SmoothExtensionJacobian.lean`
gives `Smooth` over `K` ⟹ no singular point over an arbitrary extension `L`
(`Hypersurface.exists_pderiv_ne_zero_at_of_smooth_extension`,
`no_common_zero_affineChartEquation_and_pderiv_of_global_smooth_extension`), with no closure
hypothesis anywhere. That is exactly the ascent every geometric restatement needs, and it means the
`Smooth` hypothesis on the headline is strong enough to feed the whole geometric route once the
route exists.

What was explicitly *not* done, because it would be dishonest: a "core" theorem that keeps the
present proof and simply hypothesises the facts the closure is used for — dominance of the residual
component, integrality of the generic conic, nonvanishing of the residual coordinates. Those are
established from `Smooth` today, and assuming them would make the core weaker than it looks while
appearing to generalise it.

## The minimal-hypothesis theorem — 28 July 2026, grok-executed goal chain

Directed as five targeted goals (A–E) plus three follow-ups, executed by Grok Build headless,
each verified and committed by the director. The standing endpoint family in
`MinimalLineSection.lean`:

```lean
-- the bare-section theorem
smooth_bidegree23_hasUnirationalParametrization_of_lineSection'
    (k) [Field k] [NeZero (2:k)] [NeZero (3:k)] [Infinite k]
    (F) (hF : IsBidegree23 F) (hF0 : F ≠ 0) [Smooth (Bidegree23ZeroLocus.toSpec k F)]
    (h : ∃ p q r N v, Standard.HasGoodLineWithSection F p q r N v) :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F)
```

`HasGoodLineWithSection` = frame ∧ G3 ∧ `lineConicDiscriminant ≠ 0` ∧ bare isotropic section ∧ G4
— certificate §4's conditions on `L`, a bare `k(t)`-point, and nothing else. `v 2 ≠ 0` and the
polar condition are theorems now, not hypotheses (`hpolar` from `v₂ ≠ 0` + disc; `v₂` by pencil
excision through the given section, G4 riding on the degree-8 homogeneity of `residualYCoordsOn`).
`[PerfectField k]` was removed by perfect-closure base change. `[Infinite k]` is confined to the
hard branch (constant excision parameter); the `v 2 ≠ 0` path (`…_of_lineSection_noInfinite`)
needs none, and the closed-field corollary (`…'_of_isAlgClosed`) carries no `Infinite` binder.
Dropping `Infinite` on the hard branch is the one named residual: the disc identity for the
Veronese re-clearing `(d², dn, n²)` at a nonconstant rational parameter.

The original headline and `MainTheoremGuard` are byte-unchanged throughout; every goal was
additive. All endpoints `[propext, Classical.choice, Quot.sound]`; sorry census 2 throughout.

## Reproduction commands

```bash
cd /Users/worker/unirational/problems/B-conic-bundle-multisections
lake build BConicBundleMultisections.MainTheoremGuard
lake env lean MainTheoremAxiomAudit.lean
lake build BConicBundleMultisections
lake build
rg -n '^[[:space:]]*sorry\b' --glob '*.lean' --glob '!Statement.lean' .
rg -n '^[[:space:]]*(public[[:space:]]+)?(admit|axiom|axioms|opaque)[[:space:]]+[A-Za-z_]' \
  --glob '*.lean' .
git diff --check
```

The filtered `sorry` census should show only the two legacy declarations listed above. An
unfiltered census also shows the intentional comparator challenge hole in `Statement.lean`. The
declaration census should find no `admit` or source `axiom` declaration.
