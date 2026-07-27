# Formalization status

Current as of 26 July 2026. This file is the authoritative Lean status; it supersedes older
progress notes and historical blocker lists.

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
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (Bidegree23ZeroLocus.toSpec k F)] :
    HasUnirationalParametrization 3 (Bidegree23ZeroLocus.toSpec k F)
```

It is proved in `BConicBundleMultisections/MainTheorem.lean`. The existential wrapper
`smooth_bidegree23_isUnirationalOver` is proved as well.

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
5. `hasUnirationalParametrization3_biprojectiveZeroLocus` assembles the actual G3/G4 line,
   projective integrality, and automatic gluing into the residual-component/unirational-tower
   construction. `MainTheorem.smooth_bidegree23_hasUnirationalParametrization` is definitionally
   the same raw biprojective statement and delegates to this endpoint.

The main assembly lives in:

| Layer | Principal module / endpoint |
|---|---|
| Simultaneous line and section | `Standard/G3FrameIncidenceSelection.lean` / `exists_actualG3G4LineSection_via_frameIncidence` |
| Target integrality | `TargetRelationTotalSpaceIntegral.lean` / `targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth` |
| Intrinsic chart transition | `ProjectiveHypersurfaceChartTransition.lean` and `ResidualTargetNegativeTwistChartEquationTransport.lean` |
| Residual factor transition | `ResidualTargetNegativeTwistFactorTransition.lean` / `residualTargetNegativeTwistFactor_coeff_intrinsic_transition` |
| Automatic gluing | `ResidualTargetNegativeTwistAutomaticGluing.lean` / `targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn` |
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

Recorded on branch `agent/weaken-hypotheses`. The headline statement on `main` is unchanged, and
the guard in `MainTheoremGuard.lean` still pins it byte-for-byte; this section records what was
measured, not a change to the theorem.

### `CharZero` → char ∤ 6: the infrastructure moves, the theorem does not

191 of the 254 declarations that carried `[CharZero k]` now run on `[NeZero (2 : k)] [NeZero (3 : k)]`.
The single *essential* use — the Euler step in the Jacobian criterion, which needs `(d : k) ≠ 0` for
unbounded `d` — was removed first: `JacobianCriterionCharFree.lean` proves the same criterion from
`[PerfectField k]`, which `IsAlgClosed` supplies by instance.

Three statements on the headline path were genuinely false in positive characteristic. **One of the
three has since been repaired by specialisation**; the other two are separability obstructions and
stand, so the headline hypotheses stay at `CharZero`:

1. ~~`FirstProjectionSmoothFiber.exists_algebraicClosure_coordinateDerivation`~~ — **reduced to one
   isolated lemma.** The derivation extension went through `Algebra.FormallyEtale.of_isSeparable`,
   and `CharZero` was supplying exactly one thing: `Algebra.IsSeparable K (AlgebraicClosure K)`,
   free in char 0 and false in char `p`. It is *not* the perfect closure that repairs this — a
   perfect field of char `p` has **no nonzero derivations at all** (`D z = D((z^{1/p})^p) = 0`), so
   passing there destroys the tool. It is the **separable** closure:
   `Algebra.FormallyEtale K (SeparableClosure K)` holds with no characteristic hypothesis.
   `exists_separable_coordinateDerivation` is now stated for an arbitrary separable extension and
   carries none.

   The entire remaining char-0 dependence of the project is therefore concentrated in
   `FirstProjectionSmoothFiber.exists_separableClosure_singularPoint_of_cubic` — a self-contained
   statement about plane cubics, referencing nothing else in the development: *a singular point of a
   plane cubic can be taken separable over the base field.* Proved so far only in char 0, where it
   is trivial.

   For `p ≥ 5` the argument is known and written out in the module docstring. In char ∤ 3, Euler
   gives `Z = V(∂₀G, ∂₁G, ∂₂G)`, cut by three conics; a point of `Z` has degree ≤ 4 over `K`, so its
   inseparability degree `p^m` divides 4, and `p ≥ 5` forces `m = 0`. That `p^m ≤ 4` with `m ≥ 1`
   needs `p ∈ {2,3}` is why quasi-elliptic fibrations live exactly there — the degree bound replaces
   the classification in the only case needed.

   Two corrections to earlier drafts of this argument, both recorded because they were load-bearing:

   * **Separability, not rationality, is what is true.** An integral plane cubic over `K` need not
     be *geometrically* integral — `G = N_{L/K}(ℓ)` with `[L:K] = 3` is three Galois-conjugate
     lines with three conjugate singular points, none `K`-rational. The genus-1 uniqueness argument
     applies only to geometrically integral curves. Degree ≤ 4 still gives separability at `p ≥ 5`,
     which is all the derivation needs.
   * **Two partials need not be coprime.** The triangle `G = y₀y₁y₂` has partials `y₁y₂, y₀y₂,
     y₀y₁`, pairwise non-coprime, so naive Bézout does not apply. There the shared factors are two
     non-associate `K`-lines and the point is their intersection, a single `K`-rational point. The
     nontrivial-gcd branch (`G = y₀³`, `Z = V(y₀²)`) restricts a degree-≤2 form to a coordinate
     line, whose root is separable for `p > 2`.

   What blocks formalisation is a Mathlib gap, not the mathematics: there is no projective Bézout,
   no determinant degree bound, and no lemma that a divisor of a homogeneous polynomial is
   homogeneous. `PlaneCurveIntersectionArtinian.lean` documents the identical gap and supplies only
   nonvanishing. Estimated 1000–1500 lines with `gcd`/factorisation bookkeeping in
   `MvPolynomial (Fin 3) K`. One shortcut is known: the resultant of two conics
   `q = a t² + b t + c`, `q' = a't² + b't + c'` over `K[y₁,y₂]` is explicitly the binary quartic
   `(ac'−a'c)² − (ab'−a'b)(bc'−b'c)`, and "common root ⟹ it vanishes" is a `ring` identity after
   splitting on `t = 0` — sidestepping Sylvester matrices and `Polynomial.resultant` entirely. Only
   the nonvanishing direction still needs gcd theory.
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
   Generic smoothness (item 1) is now the *only* `CharZero` in that chain.
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
