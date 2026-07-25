/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualComponentHorizontality
public import BConicBundleMultisections.Standard.GenericSmoothness

/-!
# Obligation 3: the base-changed conic bundle is pointed and rational

One of the four outstanding obligations of the unirationality proof; see
`ResidualComponentAssembly.lean` for the inventory and `PLAN.md` WP-3 (= WP-D) for the work
package.  This is the largest of the four by volume, but classical throughout.

## What has to be produced

`IsResidualComponentPointedConicRational F hF v hv i j` unfolds, through
`IsPointedConicRationalOver`, to

```
BirationalOver (pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) (residualComponentToBase …))
               (𝔸(ULift (Fin 1); T_L) ↘ T_L)
```

that is: a partial isomorphism, over `T_L := residualComponent F hF v hv i j`, between the
base-changed conic bundle `X ×_{ℙ²_y} T_L` and relative affine `1`-space.  Note that the
`PullbackSection` argument of `IsPointedConicRationalOver` does not appear in the unfolded
statement — it records *why* the assertion is expected to hold (source §5: "after base change to
this normalization, the conic bundle has its tautological point and is birational to
`T̃_L × ℙ¹`"), and it is a hypothesis of the general theorem below rather than part of its
conclusion.

## The decomposition implemented here

The obligation is reduced to **one** new leaf,
`isPointedConicRationalOver_of_dense_open_smooth`, by three steps that are proved outright
(plus, on the algebra side, `conicParametrization_smul_or_isotropic_span`, which supplies the
surjectivity half of `PLAN.md` WP-3d for an arbitrary form, with no normal form):

1. `AlgebraicGeometry.Scheme.isIntegral_image` — the scheme-theoretic image of an integral scheme
   under a quasi-compact morphism is integral.  Stated in natural generality; Mathlib has nothing
   about images of integral schemes (`PLAN.md` WP-3a).  Its specialization
   `isIntegral_residualComponent` gives `IsIntegral T_L`, which is what makes
   `Scheme.functionField T_L` — the field over which the generic conic lives — available at all.
2. `exists_dense_open_smooth_biprojectiveZeroLocusSnd` — the conic bundle `X → ℙ²_y` is smooth
   over a *dense* open of `ℙ²_y`.  This is generic smoothness (`Standard.GenericSmoothness`,
   source §1, and the reason `CharZero` is carried) plus irreducibility of `ℙ²_y`.  It is what
   rules out the generic fibre being a degenerate conic — a line pair or a double line — for which
   the conclusion would be **false**, not merely unproved (see the warning below).
3. `isDominant_residualComponentToBase_of_smooth` — horizontality of `T_L`, i.e. that `T_L` maps
   *dominantly* to `ℙ²_y` and hence that its generic point sees the generic, smooth, conic.  This
   is obligation 2 (`isDominant_residualImagePointOfNormalizedLoc_toBase`, WP-B) fed through the
   already-proved reduction `isDominant_residualComponentToBase`.  Obligation 2 has exactly the
   hypotheses of obligation 3, so nothing new is assumed; but the dependency is real and is
   recorded here deliberately.

## Warning: horizontality is not decoration, it is load-bearing

The statement of obligation 3 carries no hypothesis relating `T_L` to the discriminant of the
conic bundle, and **it is not provable without one**.  If the image of `T_L` in `ℙ²_y` were a
curve contained in the discriminant, the fibre of `X ×_{ℙ²_y} T_L → T_L` over the generic point of
`T_L` would be a singular conic over `K = k(T_L)`, and in each of the three cases the conclusion
fails:

* two `K`-rational lines: `X ×_{ℙ²_y} T_L` is reducible, while every nonempty open of
  `𝔸(1; T_L)` is irreducible;
* two conjugate lines: the only `K`-point is the node, and the normalization is `ℙ¹` over a
  quadratic extension of `K`, not over `K`;
* a double line: `X ×_{ℙ²_y} T_L` is non-reduced, while `𝔸(1; T_L)` is reduced.

The bad configuration is exactly the one source §4 excludes.  In the source's geometry: if
`T_L → ℙ²_y` is not dominant its image cannot be a point (the fibres of `X → ℙ²_y` are curves
while `T_L` is a surface), so it is a curve `Z`; the fibres of `T_L → Z` are then whole conics, so
`T_L` is the preimage of `Z`, and §4's class computation `[T_L] = a H_x + H_y` forces `deg Z = 1`.
So `Z` is a line `M` and `δ_C(L) ≡ M` is constant — precisely what §4 rules out with "contrary to
the choice of `L`".  A line *can* be a component of the degree-nine discriminant of a conic
bundle, so non-horizontality does not by itself make the obligation false; but nothing in its
hypotheses excludes the bad configuration, and there is no proof without doing so.

This is the same phenomenon that made obligations 1c and 1d false as stated: the source
**chooses** the multisection line `L` (§3–§4) and normalises it to `{W = 0}` only in §5, whereas
this development hardcodes the normalisation.  Here the dependency is made explicit rather than
hidden: obligation 3 is discharged *modulo obligation 2*, which is where the choice of `L` is
owed.  Note that this couples work packages WP-B and WP-D, which were previously independent; it
costs nothing, because `MainTheorem` consumes both anyway and obligation 2 has exactly the
hypotheses of obligation 3.

## What is left

`isPointedConicRationalOver_of_dense_open_smooth` is the classical statement "a conic with a
rational point is rational", in relative form over an integral base.  Over the function field
`K = k(T)` the algebra is finished: `PointedConicRational.lean` provides `conicParametrization`,
the stereographic second-intersection map, for an arbitrary quadratic form with an isotropic
vector and with no normal form required (`PLAN.md` WP-3d; the Witt/hyperbolic route is *not*
available, Mathlib has no Witt decomposition at the pinned revision).  What is missing is the
spreading-out: turning the `K`-level birational equivalence into a `Scheme.PartialIso` over `T`
(`PLAN.md` WP-3e).  Mathlib has no "birational ⇔ isomorphic function fields" statement and no
limit/spreading-out machinery for schemes, so this has to be done by hand over a dense affine open
of the base, where the conic bundle is `Proj (A[x₀,x₁,x₂]/(q))` for a domain `A` and the section
is an explicit unimodular isotropic vector.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

universe u

namespace AlgebraicGeometry.Scheme

/-! ### Integrality of scheme-theoretic images

`PLAN.md` WP-3a.  Mathlib knows that `f.toImage` is dominant and quasi-compact, but records
nothing about the image of an integral scheme.  Both halves are short once the right Mathlib
lemma is located, and both are stated for an arbitrary quasi-compact morphism of schemes.
-/

variable {X Y : Scheme.{u}}

/-- **The scheme-theoretic image of an irreducible scheme is irreducible.**

`f.toImage : X ⟶ f.image` is dominant for quasi-compact `f`, so the image space is the closure of
the continuous image of an irreducible space. -/
theorem irreducibleSpace_image (f : X ⟶ Y) [QuasiCompact f] [IrreducibleSpace X] :
    IrreducibleSpace f.image := by
  have hdense : DenseRange (f.toImage.base) := IsDominant.denseRange (f := f.toImage)
  have huniv : IsIrreducible (Set.univ : Set X) := IrreducibleSpace.isIrreducible_univ X
  have hrange : IsIrreducible (Set.range ⇑f.toImage.base) := by
    simpa [Set.image_univ] using
      huniv.image (⇑f.toImage.base) (Scheme.Hom.continuous f.toImage).continuousOn
  have hclosure : IsIrreducible (closure (Set.range ⇑f.toImage.base)) := hrange.closure
  rw [hdense.closure_range] at hclosure
  exact { toPreirreducibleSpace := ⟨hclosure.2⟩, toNonempty := ⟨hclosure.1.choose⟩ }

/-- **The scheme-theoretic image of a reduced scheme is reduced.**

On an affine open `U` of the target, the sections of the image are `Γ(Y, U) ⧸ ker (f.app U)`
(`Scheme.Hom.ker_apply`, which needs quasi-compactness), and that quotient embeds in the reduced
ring `Γ(X, f ⁻¹ᵁ U)`.  These affine opens cover the image. -/
theorem isReduced_image (f : X ⟶ Y) [QuasiCompact f] [IsReduced X] :
    IsReduced f.image := by
  haveI hquot : ∀ U : Y.affineOpens,
      _root_.IsReduced ((Γ(Y, (U : Y.Opens)) : Type u) ⧸ f.ker.ideal U) := by
    intro U
    have hker : f.ker.ideal U = RingHom.ker (f.app U).hom := Scheme.Hom.ker_apply f U
    haveI : _root_.IsReduced (Γ(X, f ⁻¹ᵁ (U : Y.Opens))) := IsReduced.component_reduced _
    haveI : _root_.IsReduced ((Γ(Y, (U : Y.Opens)) : Type u) ⧸ RingHom.ker (f.app U).hom) :=
      isReduced_of_injective (RingHom.kerLift (f.app U).hom) (RingHom.kerLift_injective _)
    exact isReduced_of_injective (Ideal.quotEquivOfEq hker).toRingHom
      (Ideal.quotEquivOfEq hker).injective
  apply +allowSynthFailures @IsReduced.of_openCover
    (𝒰 := f.ker.subschemeCover.openCover)
  intro U
  haveI : _root_.IsReduced ((f.ker.subschemeCover.X U : CommRingCat.{u}) : Type u) := hquot U
  exact inferInstanceAs (IsReduced (Spec (f.ker.subschemeCover.X U)))

/-- **The scheme-theoretic image of an integral scheme is integral** (`PLAN.md` WP-3a).

Integrality is irreducibility plus reducedness (`isIntegral_iff_irreducibleSpace_and_isReduced`),
and both are inherited by the image of a quasi-compact morphism. -/
theorem isIntegral_image (f : X ⟶ Y) [QuasiCompact f] [IsIntegral X] :
    IsIntegral f.image := by
  haveI := irreducibleSpace_image f
  haveI := isReduced_image f
  exact isIntegral_of_irreducibleSpace_of_isReduced _

end AlgebraicGeometry.Scheme

namespace BConicBundleMultisections

noncomputable section

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

/-! ### Stereographic projection is surjective (`PLAN.md` WP-3d)

These two lemmas belong in `PointedConicRational.lean` and should move there; they are stated here
only because that module is owned by another work package.  They complete, for an *arbitrary*
quadratic form and with no normal form, the half of pointed-conic rationality that module proves
only for the model conic `X₀X₂ = X₁²` — and the plan explicitly prefers this route, because
Mathlib has no Witt decomposition with which to reduce a general form to the model.
-/

section PointedConic

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- **A conic through two polar-orthogonal isotropic vectors contains the line joining them.**

If `Q p = Q q = 0` and `polar Q p q = 0`, then `Q (a • p + b • q) = 0` for all `a b`, because
`Q (a • p + b • q) = a² Q p + b² Q q + a b · polar Q p q`. -/
theorem eval_isotropic_of_polar_eq_zero (Q : QuadraticForm K V) {p q : V}
    (hp : Q p = 0) (hq : Q q = 0) (hpq : QuadraticMap.polar Q p q = 0) (a b : K) :
    Q (a • p + b • q) = 0 := by
  have h := QuadraticMap.map_add Q (a • p) (b • q)
  rw [Q.map_smul, Q.map_smul, hp, hq, QuadraticMap.polar_smul_left,
    QuadraticMap.polar_smul_right, hpq] at h
  simpa using h

/-- **Stereographic projection from a point of a conic hits every other point of the conic,
unless the conic degenerates along a line through that point.**

Let `p` and `q` be isotropic vectors of `Q`.  Either `polar Q p q ≠ 0`, in which case
`conicParametrization Q p q = -(polar Q p q) • q` is a *nonzero* multiple of `q`, so `q` is in the
projective image of the stereographic map; or `polar Q p q = 0`, in which case the whole plane
spanned by `p` and `q` is isotropic, i.e. the conic contains a line through `p`.

For a nondegenerate plane conic the second alternative is impossible, so the stereographic map is
onto: together with `conicParametrization_is_isotropic` (its image lands on the conic) this is the
point-level statement that a pointed nondegenerate conic is parametrized by `ℙ¹`.  Unlike
`exists_veronese_of_model_isotropic`, it needs no normal form. -/
theorem conicParametrization_smul_or_isotropic_span (Q : QuadraticForm K V) {p q : V}
    (hp : Q p = 0) (hq : Q q = 0) :
    (∃ c : K, c ≠ 0 ∧ conicParametrization Q p q = c • q) ∨
      ∀ a b : K, Q (a • p + b • q) = 0 := by
  by_cases h : QuadraticMap.polar Q p q = 0
  · exact Or.inr fun a b => eval_isotropic_of_polar_eq_zero Q hp hq h a b
  · exact Or.inl ⟨-(QuadraticMap.polar Q p q), neg_ne_zero.mpr h,
      conicParametrization_apply_self Q hq⟩

end PointedConic

/-! ### The residual component is integral -/

variable {k : Type u} [Field k]
  (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
  (v : Fin 3 → Polynomial k)
  (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
  (i j : Fin 3)

/-- The localized residual chart ring is a domain when the chart denominator is nonzero: it is a
localization of the polynomial ring `k[t,s]` at the powers of a nonzero element. -/
theorem isDomain_residualChartLoc (hdenom : residualChartDenom F v i j ≠ 0) :
    IsDomain (residualChartLoc F v i j) :=
  IsLocalization.isDomain_localization
    (powers_le_nonZeroDivisors_of_noZeroDivisors hdenom)

/-- **The residual component `T_L` is integral** (`PLAN.md` WP-3a).

`T_L` is the scheme-theoretic image of `Spec` of the localized residual chart ring, which is a
domain as soon as the chart denominator is nonzero; images of integral schemes under quasi-compact
morphisms are integral (`AlgebraicGeometry.Scheme.isIntegral_image`).

This is what makes `Scheme.functionField T_L` — the field over which the generic fibre of the
base-changed conic bundle is a conic — available. -/
theorem isIntegral_residualComponent (hdenom : residualChartDenom F v i j ≠ 0) :
    IsIntegral (residualComponent F hF v hv i j) := by
  haveI := isDomain_residualChartLoc F v i j hdenom
  exact AlgebraicGeometry.Scheme.isIntegral_image
    (residualImagePointOfNormalizedLoc F hF v hv i j)

/-! ### The conic bundle is smooth over a dense open of its base -/

/-- **Generic smoothness for the conic bundle** (source §1).

For `k` algebraically closed of characteristic zero and `X = V(F)` smooth over `k`, the second
projection `X → ℙ²_y` is smooth over some nonempty open of `ℙ²_y`; since `ℙ²_y` is irreducible
that open is dense.

Characteristic zero is essential and this is where it is used: in positive characteristic the
generic fibre of a dominant morphism from a smooth variety can be everywhere singular.

Geometrically this says the *generic conic* of the bundle is smooth, i.e. the discriminant of the
conic bundle is not identically zero.  It is the input that excludes the degenerate cases in which
obligation 3 would be false; see the module docstring. -/
theorem exists_dense_open_smooth_biprojectiveZeroLocusSnd
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    ∃ U : (ProjectiveSpace 2 k).Opens,
      Dense (U : Set (ProjectiveSpace 2 k)) ∧
        Smooth (biprojectiveZeroLocusSnd 2 2 k F ∣_ U) := by
  obtain ⟨U, hU, hsmooth⟩ :=
    Standard.exists_nonempty_open_smooth_restrict
      (biprojectiveZeroLocusToSpec 2 2 k F) (ProjectiveSpace.toSpec 2 k)
      (biprojectiveZeroLocusSnd 2 2 k F) (biprojectiveZeroLocusSnd_toSpec 2 2 k F)
  refine ⟨U, ?_, hsmooth⟩
  exact U.isOpen.dense (Set.nonempty_coe_sort.mp hU)

/-! ### The general theorem: pointed conic bundles are relatively rational -/

/--
**Pointed conic bundles are relatively rational** (source §4–§5; `PLAN.md` WP-3b–WP-3e).

*Statement.*  Let `F` be a nonzero bidegree-`(2,3)` form, so that the fibres of
`π := biprojectiveZeroLocusSnd 2 2 k F : X → ℙ²_y` are plane conics in `ℙ²_x`.  Let `T` be an
integral scheme mapping dominantly to `ℙ²_y`, and suppose the bundle is smooth over a dense open
`U` of `ℙ²_y`.  Then any section of the base change `X ×_{ℙ²_y} T → T` makes that base change
`T`-birational to relative affine `1`-space.

*Why it is true.*  `T` is integral, so it has a generic point `η` and a function field
`K := k(T)`.  Dominance of `t` and density of `U` put `t η` at the generic point of `ℙ²_y`, which
lies in `U`; smoothness of `π ∣_ U` therefore makes the fibre `X_{t η}` a *smooth* plane curve.
It is a *conic*, i.e. cut out by a nonzero quadratic form: the coefficients of `F(·, y)` are the
cubics in `y` obtained from the bihomogeneous coefficients of `F`, so they vanish at the generic
point of `ℙ²_y` only if `F = 0`, which `hF0` excludes.  A nonzero quadratic form whose projective
zero locus is smooth is nondegenerate — a double line gives a non-reduced scheme, a line pair a
singular point — and smoothness is preserved by the base change to `K`.  So the generic fibre of
`pullback.snd π t → T` is a smooth plane conic over `K`, and the section provides a `K`-rational
point on it.  Stereographic projection from that point — `conicParametrization` in
`PointedConicRational.lean`, which needs no normal form, only an isotropic vector; surjectivity is
`conicParametrization_smul_or_isotropic_span` above — is an isomorphism between a dense open of the
conic and a dense open of `ℙ¹_K`, hence of `𝔸¹_K`.  Spreading that isomorphism out over a dense
affine open of `T` gives the required `Scheme.PartialIso` over `T`.

*What is missing.*  Only the spreading-out.  The field-level algebra is proved
(`conicParametrization_is_isotropic`, `conicParametrization_apply_self`,
`quadratic_line_expansion`), and Mathlib supplies the `PartialIso` API (`symm`, `trans`,
`restrictSource`, `restrictTarget`, `IsOver`) needed to package it.  What Mathlib does *not*
supply, at the pinned revision, is any bridge between the generic fibre and the family: no
"birational ⇔ isomorphic function fields", no spreading out of morphisms defined over the generic
point.  The concrete route is to work over a dense affine open `Spec A ⊆ T` on which the conic
bundle is `Proj (A[x₀,x₁,x₂]/(q))` — `q` the pullback of the ternary quadratic form `F(·, y)` —
and on which the section is an explicit unimodular isotropic vector `p ∈ A³`, and to write the two
mutually inverse maps by the formulas of `PointedConicRational.lean`.

*Hypotheses that are not decoration.*  Each of `hF0`, `[IsDominant t]` and the smoothness of
`π ∣_ U` is needed for the statement to be *true*, not merely for this proof to work.

* Without `hF0` the statement is false: for `F = 0` the "zero locus" is all of `ℙ²_x × ℙ²_y`, `π`
  is the smooth projection to `ℙ²_y`, sections exist, and the base change is `ℙ²_T`, which is not
  `T`-birational to `𝔸(1; T)`.
* `[IsDominant t]` together with density of `U` is what puts the generic point of `T` over a point
  where the conic is nondegenerate.  Over a base whose image lies in the discriminant the generic
  conic is a line pair or a double line, and the base change is respectively reducible,
  non-`K`-rational, or non-reduced — see the module docstring.
-/
theorem isPointedConicRationalOver_of_dense_open_smooth
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t)
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (hsmooth : Smooth (biprojectiveZeroLocusSnd 2 2 k F ∣_ U)) :
    IsPointedConicRationalOver (biprojectiveZeroLocusSnd 2 2 k F) t s :=
  sorry

/-! ### Horizontality of the residual component -/

/-- Horizontality of the residual component, packaged from obligation 2.

`isDominant_residualImagePointOfNormalizedLoc_toBase` (WP-B, `ResidualComponentHorizontality`) is
the concrete coordinate statement that the localized residual map dominates `ℙ²_y`;
`isDominant_residualComponentToBase` (proved) transfers it to the component.  Obligation 2 has
exactly the hypotheses of obligation 3, so this adds no assumption — but obligation 3 now depends
on obligation 2, which is where the source's **choice of the multisection line** is owed. -/
theorem isDominant_residualComponentToBase_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0) :
    IsDominant (residualComponentToBase F hF v hv i j) :=
  isDominant_residualComponentToBase F hF v hv i j
    (isDominant_residualImagePointOfNormalizedLoc_toBase F hF hF0 v hv0 hv i j hdenom)

/-! ### Obligation 3 -/

/--
**Obligation 3.**  The conic bundle base-changed to the residual component is birational over that
component to relative affine `1`-space.

*Status.* Reduced to the single leaf `isPointedConicRationalOver_of_dense_open_smooth`; see the
module docstring for the decomposition and for why the horizontality input is load-bearing rather
than decorative.

Downstream of this obligation everything is already wired:
`hasUnirationalParametrization1_residualComponentBaseChangeSnd` consumes it directly.
-/
theorem isResidualComponentPointedConicRational_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0) :
    IsResidualComponentPointedConicRational F hF v hv i j := by
  haveI : IsIntegral (residualComponent F hF v hv i j) :=
    isIntegral_residualComponent F hF v hv i j hdenom
  haveI : IsDominant (residualComponentToBase F hF v hv i j) :=
    isDominant_residualComponentToBase_of_smooth F hF hF0 v hv0 hv i j hdenom
  obtain ⟨U, hU, hsmooth⟩ := exists_dense_open_smooth_biprojectiveZeroLocusSnd F
  exact isPointedConicRationalOver_of_dense_open_smooth F hF hF0
    (residualComponentToBase F hF v hv i j)
    (residualComponentMultisection F hF v hv i j).tautologicalPullbackSection U hU hsmooth

end

end BConicBundleMultisections
