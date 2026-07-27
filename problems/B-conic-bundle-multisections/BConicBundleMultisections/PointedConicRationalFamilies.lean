/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BinaryQuadraticNormalForm
public import BConicBundleMultisections.BiprojectiveAffineChartDegree
public import BConicBundleMultisections.ConicProjectionFlat
public import BConicBundleMultisections.BiprojectiveDehomogenization
public import BConicBundleMultisections.BiprojectiveFiberPolynomial
public import BConicBundleMultisections.BiprojectiveProjectionFiber
public import BConicBundleMultisections.BiprojectiveSmoothCriterion
public import BConicBundleMultisections.PointedConicAffineModel
public import BConicBundleMultisections.PointedConicChartBaseChange
public import BConicBundleMultisections.ResidualComponentHorizontality
public import BConicBundleMultisections.SchemeImageIntegral
public import BConicBundleMultisections.HomogeneousJacobianChart
public import BConicBundleMultisections.GoodLineCondition
public import BConicBundleMultisections.GenericConicNondegeneracy
public import BConicBundleMultisections.GenericConicProjectivePoint
public import BConicBundleMultisections.IntegralOpenCover
public import BConicBundleMultisections.SndResidueFiberNonzero
public import BConicBundleMultisections.TernaryQuadraticGradient
public import BConicBundleMultisections.NeZeroTwoThree
public import Mathlib.Algebra.BigOperators.Fin
public import Mathlib.Algebra.MvPolynomial.Division
public import Mathlib.AlgebraicGeometry.Fiber
public import Mathlib.AlgebraicGeometry.Geometrically.Integral
public import Mathlib.AlgebraicGeometry.PullbackCarrier
public import Mathlib.Data.Finsupp.Weight
public import Mathlib.RingTheory.FinitePresentation
public import Mathlib.RingTheory.Smooth.Basic
public import Mathlib.RingTheory.TensorProduct.MvPolynomial
public import Mathlib.RingTheory.TensorProduct.Quotient

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

The obligation is reduced to **one** leaf, `exists_pointedConicAffineModel` — the *spreading-out*
step — by four groups of results that are proved outright:

1. `AlgebraicGeometry.Scheme.isIntegral_image` — the scheme-theoretic image of an integral scheme
   under a quasi-compact morphism is integral.  Stated in natural generality; Mathlib has nothing
   about images of integral schemes (`PLAN.md` WP-3a).  Its specialization
   `isIntegral_residualComponent` gives `IsIntegral T_L`, which is what makes
   `Scheme.functionField T_L` — the field over which the generic conic lives — available at all.
2. `GenericConicNondegeneracy` computes the generic ternary conic on `Y₀ ≠ 0`.  Restriction
   to `Y₂ = 0` is the coordinate-line conic, whose polar determinant is nonzero by ambient
   smoothness; dominance carries this determinant injectively to the residual base.  Euler's
   identity then makes the marked affine point nonsingular.  This bidegree-specific argument
   replaces the former appeal to scheme-theoretic generic smoothness.
3. `isDominant_residualComponentToBase_of_smooth` — horizontality of `T_L`, i.e. that `T_L` maps
   *dominantly* to `ℙ²_y` and hence that its generic point sees the generic, smooth, conic.  This
   is obligation 2 (`isDominant_residualImagePointOfNormalizedLoc_toBase`, WP-B) fed through the
   already-proved reduction `isDominant_residualComponentToBase`.  Obligation 2 has exactly the
   hypotheses of obligation 3, so nothing new is assumed; but the dependency is real and is
   recorded here deliberately.
4. **The classical mathematics itself**, in `PointedConicAffineModel.lean`:
   `PointedConic.birationalOver_conicScheme_affineSpace` proves, for an arbitrary commutative
   base ring, that the pointed affine conic `a x² + b x y + c y² + d x + e y = 0` over a domain
   `A` is `Spec A`-birational to `𝔸(1; Spec A)`.  Stereographic projection from the marked point
   is written as an explicit isomorphism of localizations
   `(A[x,y]/(f))_{x (dx+ey)} ≅ A[z]_{Q(z) L(z)}`, with `z = y/x` and `x = −L(z)/Q(z)`.  There is
   no `sorry` in it, and — as `PLAN.md` WP-3d requires — no normal form and no Witt decomposition.
   Transport back to `T` is `Scheme.BirationalOver.comp` and
   `Scheme.birationalOver_affineSpace_comp`, both proved here and both absent from Mathlib.

On the abstract-quadratic-form side, `conicParametrization_smul_or_isotropic_span` (now in
`PointedConicRational.lean`, together with `eval_isotropic_of_polar_eq_zero`) supplies the
surjectivity half of WP-3d for an arbitrary form on an arbitrary module, again with no normal
form.

## Correction: the affine-model leaf was false without global smoothness

The first version of `exists_pointedConicAffineModel` (and of
`isPointedConicRationalOver_of_dense_open_smooth`) assumed only `hF0 : F ≠ 0` together with
smoothness of `π` over a dense open `U` of `ℙ²_y`.  **That is false.**  Explicit counterexample,
over an arbitrary field `k`:

```
F = Y₀³ · (X₀ X₁ − X₂²)          -- bidegree (2,3), nonzero
U = D(Y₀)                         -- dense open of ℙ²_y
T = ℙ²_y,  t = 𝟙                  -- integral, dominant
σ : y ↦ ([1:0:0], y)              -- a section, since 1·0 − 0² = 0
```

On `U` the ideal `(Y₀³ (X₀X₁ − X₂²))` equals `(X₀X₁ − X₂²)`, so `π ∣_ U` is the constant smooth
conic bundle `V(X₀X₁ − X₂²) × U → U`: every hypothesis holds.  But `pullback.snd π t ≅ X` is
`ℙ²_x × {Y₀ = 0}` together with `V(X₀X₁ − X₂²) × ℙ²_y`, and is non-reduced along `Y₀ = 0`.  A dense
open of a reducible space is reducible, while every nonempty open of `𝔸(1; T)` — and of the
pointed affine conic over a domain — is integral, so no `BirationalOver` can exist.

The missing hypothesis is exactly the one this development already isolates: a *whole* `ℙ²_x`
fibre.  `BiprojectiveSpace.not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23` says that
global smoothness of `X` over `Spec k` forbids one, and that is the only thing the counterexample
violates (its `X` is visibly singular along `Y₀ = 0`).  Both statements therefore now carry
`[IsAlgClosed k]` and `[Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]`, which the obligation's call
site supplies anyway.  With no whole fibre, every component of `X ×_{ℙ²_y} T` dominates `T`; its
generic fibre is a smooth plane conic, hence geometrically integral; so the base change is integral
and the statement is true.

This is the same fault as `PLAN.md` correction 7 and its predecessors: when the classical statement
was lifted out of its setting, a hypothesis that the source's geometry supplies for free
(here: `X` is smooth, which is the standing hypothesis of the whole theorem) was silently dropped.
The lesson recorded for the next generalization: *smoothness of the morphism over a dense open of
the base does not imply anything about the fibres outside that open*, and birationality is a
statement about the total space, which those fibres can wreck.

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

`exists_pointedConicAffineModel` — and nothing else.  It says that over a dense affine open of the
base the pointed conic bundle *is* a pointed affine conic, i.e. it is the spreading-out step: delete
the line at infinity through the section, translate the section to the origin, and read off the five
coefficients.  This is bookkeeping with the biprojective chart machinery of this development
(`BiprojectiveChart`, `chartZeroLocusIsoPullback`, `BiprojectiveDehomogenization`), not new
mathematics; Mathlib supplies no spreading-out machinery for schemes and no
"birational ⇔ isomorphic function fields" bridge at the pinned revision, so it cannot be shortcut.

-/

@[expose] public section

open CategoryTheory Limits CommRingCat
open scoped AlgebraicGeometry Matrix TensorProduct

universe u

namespace AlgebraicGeometry.Scheme

/-! ### Transport of relative birationality along a change of base

Two small general lemmas, both absent from Mathlib's `Birational/Birational.lean`, needed to move
a birational equivalence from a dense affine open of the base to the base itself. -/

/-- A partial isomorphism over `S` is a partial isomorphism over any scheme `S` maps to. -/
theorem PartialIso.IsOver.comp {S S' X Y : Scheme.{u}} {sX : X ⟶ S} {sY : Y ⟶ S}
    {f : X.PartialIso Y} (h : f.IsOver sX sY) (g : S ⟶ S') :
    f.IsOver (sX ≫ g) (sY ≫ g) := by
  have h' := congrArg (fun φ => φ ≫ g) h
  simpa only [PartialIso.IsOver, Category.assoc] using h'

/-- Birationality over `S` implies birationality over any scheme `S` maps to. -/
theorem BirationalOver.comp {S S' X Y : Scheme.{u}} {sX : X ⟶ S} {sY : Y ⟶ S}
    (h : BirationalOver sX sY) (g : S ⟶ S') : BirationalOver (sX ≫ g) (sY ≫ g) :=
  ⟨h.partialIso, (h.partialIso_isOver sX sY).comp g⟩

/-- Relative affine space over a dense open of the base is birational, over the base, to relative
affine space over the whole base. -/
theorem birationalOver_affineSpace_comp {S T : Scheme.{u}} (n : Type u) (ψ : S ⟶ T)
    [IsOpenImmersion ψ] [IsDominant ψ] :
    BirationalOver ((𝔸(n; S) ↘ S) ≫ ψ) (𝔸(n; T) ↘ T) := by
  haveI : IsOpenImmersion (AffineSpace.map n ψ) := by
    have hpb := AffineSpace.isPullback_map (n := n) ψ
    have h : AffineSpace.map n ψ =
        hpb.isoPullback.hom ≫ Limits.pullback.fst (𝔸(n; T) ↘ T) ψ :=
      hpb.isoPullback_hom_fst.symm
    rw [h]; infer_instance
  haveI : IsDominant (AffineSpace.map n ψ) :=
    BConicBundleMultisections.isDominant_affineSpace_map n ψ
  exact Scheme.Hom.birationalOver (AffineSpace.map n ψ) (𝔸(n; T) ↘ T)
    ((𝔸(n; S) ↘ S) ≫ ψ) (AffineSpace.map_over (n := n) ψ)


/-! ### Dominance gives injectivity on a reduced target

The join in the light route for the quadratic condition: the coefficient forms of `F` are seen to
vanish only *at the generic point* of `T`, and one needs them to vanish identically.  Dominance
gives density of the image, and density of the image of `Spec S ⟶ Spec R` is exactly
`RingHom.ker φ ≤ nilradical R` — so for reduced `R`, injectivity.  Mathlib supplies the
equivalence; only the passage from `IsDominant` to `DenseRange (PrimeSpectrum.comap φ)` is added
here.
-/

/-- **A dominant morphism of affine schemes comes from an injective ring map, when the target ring
is reduced.** -/
theorem injective_of_isDominant_specMap {R S : Type u} [CommRing R] [CommRing S]
    [_root_.IsReduced R]
    (φ : R →+* S) [IsDominant (Spec.map (CommRingCat.ofHom φ))] :
    Function.Injective φ := by
  have hd : DenseRange (PrimeSpectrum.comap φ) :=
    IsDominant.denseRange (f := Spec.map (CommRingCat.ofHom φ))
  have hker : RingHom.ker φ ≤ _root_.nilradical R :=
    (PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical φ).mp hd
  rw [nilradical_eq_zero] at hker
  exact (RingHom.injective_iff_ker_eq_bot φ).mpr (le_antisymm hker bot_le)

/-! ### Enlarging the base of a pullback square along a mono

The chart computation produces its fibre-product square over an *affine chart* of `ℙ²_y`, whereas
`exists_isOpenImmersion_to_pullback` consumes one over `ℙ²_y` itself.  The two differ by
postcomposing both legs with the chart inclusion, which is an open immersion and in particular a
monomorphism — and that does not disturb a pullback square.
-/

/-- **A pullback square stays a pullback after postcomposing both legs with a monomorphism.**

Purely categorical.  The universal property transfers because a cone for the enlarged square is
already a cone for the original one: `u` may be cancelled from `a ≫ f ≫ u = b ≫ g ≫ u`. -/
theorem isPullback_comp_mono {C : Type*} [Category C] {P X Y V B : C} {fst : P ⟶ X} {snd : P ⟶ Y}
    {f : X ⟶ V} {g : Y ⟶ V} (h : IsPullback fst snd f g) (u : V ⟶ B) [Mono u] :
    IsPullback fst snd (f ≫ u) (g ≫ u) := by
  refine IsPullback.of_isLimit' ⟨by rw [← Category.assoc, ← Category.assoc, h.w]⟩
    (Limits.PullbackCone.isLimitAux' _ fun s => ?_)
  have hs : (Limits.PullbackCone.fst s) ≫ f = (Limits.PullbackCone.snd s) ≫ g := by
    rw [← cancel_mono u, Category.assoc, Category.assoc]
    exact s.condition
  refine ⟨h.lift (Limits.PullbackCone.fst s) (Limits.PullbackCone.snd s) hs, h.lift_fst _ _ _,
    h.lift_snd _ _ _, fun {m} hm₁ hm₂ => ?_⟩
  apply h.hom_ext
  · rw [h.lift_fst]; exact hm₁
  · rw [h.lift_snd]; exact hm₂

/-! ### Pasting a chart square into the base change

The last structural step of the chart computation.  If a scheme `W` is the fibre product, over the
conic-bundle base `B`, of an *open* piece `C` of the total space with an *open* piece `S` of the
multisection base, then `W` is an open subscheme of the base change `X ×_B T`, compatibly with the
projections.  Both open immersions are handled at once by Mathlib's
`Scheme.pullback_map_isOpenImmersion`, taking the third comparison map to be the identity of `B`.
-/

/-- **A fibre product of open pieces is an open subscheme of the base change.**

Given `π : X ⟶ B`, `t : T ⟶ B`, an open immersion `c : C ⟶ X` and an open immersion
`ψ : S ⟶ T`, any `W` realising the fibre product of `c ≫ π` and `ψ ≫ t` maps by an open immersion
into `X ×_B T`, and that map commutes with the projections to `T`.

This is exactly the shape in which `exists_chartEquation_openImmersion` needs its `r`: `C` is the
standard chart of the biprojective zero locus, `S = Spec A` is the affine base, and `W` is the
affine model, whose fibre-product property is `BiprojectiveSpace.isPullback_SpecMap_chartQuotient`
in `PointedConicChartBaseChange.lean`. -/
theorem exists_isOpenImmersion_to_pullback {X B T C S W : Scheme.{u}} (π : X ⟶ B) (t : T ⟶ B)
    (c : C ⟶ X) [IsOpenImmersion c] (ψ : S ⟶ T) [IsOpenImmersion ψ]
    {w₁ : W ⟶ C} {w₂ : W ⟶ S} (hW : IsPullback w₁ w₂ (c ≫ π) (ψ ≫ t)) :
    ∃ r : W ⟶ Limits.pullback π t, IsOpenImmersion r ∧
      r ≫ Limits.pullback.snd π t = w₂ ≫ ψ := by
  refine ⟨hW.isoPullback.hom ≫
      Limits.pullback.map (c ≫ π) (ψ ≫ t) π t c ψ (𝟙 B) (by simp) (by simp),
    inferInstance, ?_⟩
  rw [Category.assoc, Limits.pullback.lift_snd, ← Category.assoc,
    hW.isoPullback_hom_snd]

/-- **Range of the open immersion from pasting open pieces into a base change.**

The map produced by `exists_isOpenImmersion_to_pullback` (equivalently
`isoPullback.hom ≫ pullback.map …`) realises the fibre product of the two open pieces as the
open of `X ×_B T` cut out by `range c` on the total-space side and `range ψ` on the base side. -/
theorem range_isOpenImmersion_to_pullback
    {X B T C S W : Scheme.{u}} (π : X ⟶ B) (t : T ⟶ B)
    (c : C ⟶ X) [IsOpenImmersion c] (ψ : S ⟶ T) [IsOpenImmersion ψ]
    {w₁ : W ⟶ C} {w₂ : W ⟶ S} (hW : IsPullback w₁ w₂ (c ≫ π) (ψ ≫ t)) :
    let r := hW.isoPullback.hom ≫
      pullback.map (c ≫ π) (ψ ≫ t) π t c ψ (𝟙 B) (by simp) (by simp)
    Set.range r =
      pullback.fst π t ⁻¹' Set.range c ∩
        pullback.snd π t ⁻¹' Set.range ψ := by
  intro r
  have hmap := Scheme.Pullback.range_map (c ≫ π) (ψ ≫ t) π t c ψ (𝟙 B)
    (by simp) (by simp)
  have hiso : Function.Surjective hW.isoPullback.hom :=
    Scheme.Hom.surjective hW.isoPullback.hom
  have hrng : Set.range r =
      Set.range (pullback.map (c ≫ π) (ψ ≫ t) π t c ψ (𝟙 B) (by simp) (by simp)) := by
    change Set.range
        ((pullback.map (c ≫ π) (ψ ≫ t) π t c ψ (𝟙 B) (by simp) (by simp) : _ → _) ∘
          (hW.isoPullback.hom : _ → _)) = _
    exact Function.Surjective.range_comp hiso _
  rw [hrng, hmap]

/-- If `π` is smooth over an open `U ⊆ B` and `g : S → B` lands in `U`, then the base change
`pullback.snd π g` is smooth. -/
theorem smooth_pullback_snd_of_range_subset_opens
    {X B S : Scheme.{u}} (π : X ⟶ B) (U : B.Opens) [Smooth (π ∣_ U)]
    (g : S ⟶ B) (hg : Set.range g.base ⊆ (U : Set B)) :
    Smooth (pullback.snd π g) := by
  have hg' : Set.range g.base ⊆ Set.range U.ι.base := by
    simpa [Scheme.Opens.range_ι] using hg
  let gU : S ⟶ U := IsOpenImmersion.lift U.ι g hg'
  have hgU : g = gU ≫ U.ι := (IsOpenImmersion.lift_fac U.ι g hg').symm
  have hpb : IsPullback (pullback.fst (π ∣_ U) gU) (pullback.snd (π ∣_ U) gU)
      (π ∣_ U) gU := IsPullback.of_hasPullback _ _
  have hpbU : IsPullback (π ∣_ U) (π ⁻¹ᵁ U).ι U.ι π := isPullback_morphismRestrict π U
  have hpaste : IsPullback
      (pullback.fst (π ∣_ U) gU ≫ (π ⁻¹ᵁ U).ι)
      (pullback.snd (π ∣_ U) gU)
      π
      (gU ≫ U.ι) := hpb.paste_horiz hpbU.flip
  rw [← hgU] at hpaste
  haveI : Smooth (pullback.snd (π ∣_ U) gU) := inferInstance
  have hfac : hpaste.isoPullback.hom ≫ pullback.snd π g =
      pullback.snd (π ∣_ U) gU := hpaste.isoPullback_hom_snd
  have hsm : Smooth (hpaste.isoPullback.hom ≫ pullback.snd π g) := by
    rw [hfac]; infer_instance
  exact (MorphismProperty.cancel_left_of_respectsIso (P := @Smooth)
    hpaste.isoPullback.hom (pullback.snd π g)).mp hsm

/-- Structure map of a chart open of a base-changed fibration that is smooth over `U`, when the
base map lands in `U`. -/
theorem smooth_structure_of_chart_pullback
    {X B T C S W : Scheme.{u}} (π : X ⟶ B) (t : T ⟶ B)
    (U : B.Opens) [Smooth (π ∣_ U)]
    (c : C ⟶ X) [IsOpenImmersion c] (ψ : S ⟶ T) [IsOpenImmersion ψ]
    {w₁ : W ⟶ C} {w₂ : W ⟶ S}
    (hW : IsPullback w₁ w₂ (c ≫ π) (ψ ≫ t))
    (hrange : Set.range (ψ ≫ t).base ⊆ (U : Set B)) :
    Smooth w₂ := by
  let r_inner : W ⟶ pullback π (ψ ≫ t) :=
    hW.isoPullback.hom ≫
      pullback.map (c ≫ π) (ψ ≫ t) π (ψ ≫ t) c (𝟙 S) (𝟙 B) (by simp) (by simp)
  haveI : IsOpenImmersion r_inner := by dsimp [r_inner]; infer_instance
  have hw2 : r_inner ≫ pullback.snd π (ψ ≫ t) = w₂ := by
    dsimp [r_inner]
    rw [Category.assoc, pullback.lift_snd, Category.comp_id]
    exact hW.isoPullback_hom_snd
  haveI : Smooth (pullback.snd π (ψ ≫ t)) :=
    smooth_pullback_snd_of_range_subset_opens π U (ψ ≫ t) hrange
  haveI : Smooth r_inner := inferInstance
  have : Smooth (r_inner ≫ pullback.snd π (ψ ≫ t)) := inferInstance
  rwa [hw2] at this

/-! ### Nonemptiness of the opens the chart computation works over

Step 3 of the chart computation.  Both are general and elementary, and both are what makes the
choice of chart possible at all: the open of `T` on which everything happens has to be nonempty
before it can be shrunk to an affine.
-/

/-- **A dominant morphism pulls a nonempty open back to a nonempty open.** -/
theorem nonempty_preimage_of_isDominant {X Y : Scheme.{u}} (f : X ⟶ Y) [IsDominant f]
    (W : Y.Opens) (hW : (W : Set Y).Nonempty) :
    ((f ⁻¹ᵁ W : X.Opens) : Set X).Nonempty := by
  have hd : Dense (Set.range f.base) := IsDominant.denseRange (f := f)
  obtain ⟨y, hyW, hyr⟩ := hd.inter_open_nonempty _ W.isOpen hW
  obtain ⟨x, rfl⟩ := hyr
  exact ⟨x, hyW⟩

/-- **Two nonempty opens of an irreducible scheme meet.**

Applied to `U` (dense, where the conic bundle is smooth) and a standard chart of `ℙ²_y`. -/
theorem nonempty_inf_opens {X : Scheme.{u}} [IrreducibleSpace X] (U W : X.Opens)
    (hU : (U : Set X).Nonempty) (hW : (W : Set X).Nonempty) :
    ((U ⊓ W : X.Opens) : Set X).Nonempty :=
  nonempty_preirreducible_inter U.isOpen W.isOpen hU hW

/-! ### Dense affine opens of an integral scheme

Step 4 of the chart computation: the affine base `Spec A` over which the affine model lives.
-/

/-- **A nonempty open of an integral scheme contains a dense affine open**, packaged as a dominant
open immersion from an affine scheme with prescribed range.

This is the form `exists_chartEquation_openImmersion` has to produce its base in.  Density is
automatic: an integral scheme is irreducible, so every nonempty open is dense. -/
theorem exists_isOpenImmersion_isDominant_range_subset {T : Scheme.{u}} [IsIntegral T]
    (V : T.Opens) (hV : (V : Set T).Nonempty) :
    ∃ (A : Type u) (_ : CommRing A) (ψ : Spec (CommRingCat.of A) ⟶ T),
      IsOpenImmersion ψ ∧ IsDominant ψ ∧ Set.range ψ.base ⊆ (V : Set T) := by
  obtain ⟨x, hx⟩ := hV
  obtain ⟨_, ⟨W, hW, rfl⟩, hxW, hWV⟩ :=
    T.isBasis_affineOpens.exists_subset_of_mem_open hx V.isOpen
  refine ⟨Γ(T, W), inferInstance, hW.fromSpec, inferInstance, ⟨?_⟩, ?_⟩
  · rw [DenseRange, hW.range_fromSpec]
    exact W.isOpen.dense ⟨x, hxW⟩
  · rw [hW.range_fromSpec]
    exact hWV

end AlgebraicGeometry.Scheme

namespace BConicBundleMultisections

noncomputable section

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

-- Needed for `ProjectiveSpace.StandardChartRing` to synthesise its `CommRing` instance
-- (via `HomogeneousLocalization`).
attribute [local instance] MvPolynomial.gradedAlgebra

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

/-- **A morphism into projective space meets some standard chart on a nonempty open.**

Step 2 of the chart computation: the choice of the `x`-chart index `i`.  Unlike the `y`-chart
index, which may be arbitrary, this one has to be chosen — but only because the section could a
priori avoid any *particular* chart, not for any deeper reason: the standard charts cover, so some
chart is met. -/
theorem exists_nonempty_preimage_standardChart {T : Scheme.{u}} [Nonempty T] {n : ℕ}
    {R : Type u} [CommRing R] (f : T ⟶ ProjectiveSpace n R) :
    ∃ i : Fin (n + 1),
      ((f ⁻¹ᵁ ProjectiveSpace.standardChart n R i : T.Opens) : Set T).Nonempty := by
  obtain ⟨x⟩ := ‹Nonempty T›
  obtain ⟨i, hi⟩ := ProjectiveSpace.exists_mem_standardChart n R (f.base x)
  exact ⟨i, ⟨x, hi⟩⟩

/-! ### The base of the chart computation

Steps 3 and 4 of `exists_chartEquation_openImmersion` assembled: the affine open `Spec A ⊆ T` over
which the affine model lives, together with the guarantee that it sits inside the locus where the
conic bundle is smooth and where `t` lands in the `j`-th chart of `ℙ²_y`.  Note that *every* `j`
works: the generic point of `ℙ²_k` lies in every standard chart.
-/

/-- The open of `T` on which the chart computation takes place is nonempty, for every choice of
`y`-chart. -/
theorem nonempty_preimage_inf_standardChart {k : Type u} [Field k]
    {T : Scheme.{u}} (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (j : Fin 3) :
    ((t ⁻¹ᵁ (U ⊓ ProjectiveSpace.standardChart 2 k j) : T.Opens) : Set T).Nonempty := by
  haveI : IrreducibleSpace (ProjectiveSpace 2 k) := inferInstance
  refine Scheme.nonempty_preimage_of_isDominant t _ (Scheme.nonempty_inf_opens _ _ ?_ ?_)
  · exact hU.nonempty
  · exact ⟨ProjectiveSpace.genericPoint 2 k, ProjectiveSpace.genericPoint_mem_standardChart 2 k j⟩

/-- **The affine base of the chart computation.**

A dense affine open of `T` inside the locus where the conic bundle is smooth and where `t` lands in
the `j`-th standard chart of `ℙ²_y`.  This is what `exists_chartEquation_openImmersion` must take
as its `A` and `ψ`. -/
theorem exists_affine_base_of_chart {k : Type u} [Field k]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (j : Fin 3) :
    ∃ (A : Type u) (_ : CommRing A) (ψ : Spec (CommRingCat.of A) ⟶ T),
      IsOpenImmersion ψ ∧ IsDominant ψ ∧
        Set.range ψ.base ⊆
          ((t ⁻¹ᵁ (U ⊓ ProjectiveSpace.standardChart 2 k j) : T.Opens) : Set T) :=
  Scheme.exists_isOpenImmersion_isDominant_range_subset _
    (nonempty_preimage_inf_standardChart t U hU j)

/-- The open of `T` where the chart computation meets both a smooth/`y`-chart condition and a
chosen `x`-chart for the multisection is nonempty. -/
theorem nonempty_preimage_inf_standardChart_section
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t)
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (i j : Fin 3)
    (hi : (((s.toTotal ≫ biprojectiveZeroLocusFst 2 2 k F) ⁻¹ᵁ
        ProjectiveSpace.standardChart 2 k i : T.Opens) : Set T).Nonempty) :
    ((t ⁻¹ᵁ (U ⊓ ProjectiveSpace.standardChart 2 k j) ⊓
        (s.toTotal ≫ biprojectiveZeroLocusFst 2 2 k F) ⁻¹ᵁ
          ProjectiveSpace.standardChart 2 k i : T.Opens) : Set T).Nonempty := by
  haveI : IrreducibleSpace T := inferInstance
  exact Scheme.nonempty_inf_opens
      (t ⁻¹ᵁ (U ⊓ ProjectiveSpace.standardChart 2 k j))
      ((s.toTotal ≫ biprojectiveZeroLocusFst 2 2 k F) ⁻¹ᵁ
        ProjectiveSpace.standardChart 2 k i)
      (nonempty_preimage_inf_standardChart t U hU j) hi

/-- **Affine base constrained by the multisection `x`-chart.**

As in `exists_affine_base_of_chart`, but the range of `ψ` is also forced into the open of `T` on
which the multisection lands in the `i`-th `x`-chart.  This is what makes the section factor
through the chart open immersion `r` of C₂ (the `hfac` range inclusion). -/
theorem exists_affine_base_of_chart_section
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t)
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (i j : Fin 3)
    (hi : (((s.toTotal ≫ biprojectiveZeroLocusFst 2 2 k F) ⁻¹ᵁ
        ProjectiveSpace.standardChart 2 k i : T.Opens) : Set T).Nonempty) :
    ∃ (A : Type u) (_ : CommRing A) (ψ : Spec (CommRingCat.of A) ⟶ T),
      IsOpenImmersion ψ ∧ IsDominant ψ ∧
        Set.range ψ.base ⊆
          ((t ⁻¹ᵁ (U ⊓ ProjectiveSpace.standardChart 2 k j) ⊓
              (s.toTotal ≫ biprojectiveZeroLocusFst 2 2 k F) ⁻¹ᵁ
                ProjectiveSpace.standardChart 2 k i : T.Opens) : Set T) :=
  Scheme.exists_isOpenImmersion_isDominant_range_subset _
    (nonempty_preimage_inf_standardChart_section F t s U hU i j hi)

/-! ### The quadratic nondegeneracy condition

The first of the two conditions `exists_chartEquation_openImmersion` must produce, isolated as a
statement about `F` alone.  Saying that the quadratic part of the dehomogenized chart equation
vanishes is saying that every monomial of `F` carries the coordinate `Xᵢ`; and a smooth
bidegree-`(2,3)` form has no such factor, because a whole cubic fibre would then lie in `X`.

This is the *light* route.  The heavy one — the projective fibre is smooth, hence irreducible,
hence a nondegenerate form, hence contains no line — is blocked: Mathlib's
`RingTheory/MvPolynomial/IrreducibleQuadratic.lean` lists exactly the needed statement, *"over a
field, a polynomial of degree at most 2 whose quadratic part has rank at least 3 is irreducible"*,
among its TODOs.  Nothing below uses irreducibility, and nothing below uses `hsmooth`: the
quadratic and linear conditions really are independent, and must not be discharged by one appeal.

The argument is the one `not_eq_rename_mul_rename_of_smooth` (`GoodLine.lean`) runs for the sibling
degeneration `F = Q(x) f₀(y)`; only the shape of the factor differs.
-/

/-- **No first-block coordinate divides a smooth bidegree-`(2,3)` form.**

If `Xᵢ ∣ F` then `F` vanishes on the whole cubic fibre over any point with `i`-th coordinate zero —
take the unit vector at another index, which is already normalized — and
`BiprojectiveSpace.not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23` forbids a whole
fibre for smooth `F`.

Equivalently: the coefficients of `F` at the monomials `x^a` with `aᵢ = 0` do not all vanish.  That
is precisely the assertion that the quadratic part of the `i`-th dehomogenization of `F(·, y)` is
not identically zero, which is the quadratic nondegeneracy condition of
`exists_chartEquation_openImmersion`. -/
theorem not_X_inl_dvd_of_smooth {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] (i : Fin 3) :
    ¬ (MvPolynomial.X (Sum.inl i) ∣ F) := by
  rintro ⟨G, hG⟩
  -- A first-block index different from `i`, at which to normalize.
  set l : Fin 3 := if i = 0 then 1 else 0 with hl_def
  have hli : l ≠ i := by
    rw [hl_def]
    split <;> omega
  set x : Fin 3 → k := fun a => if a = l then 1 else 0 with hx_def
  have hxl : x l = 1 := by simp [hx_def]
  have hxi : x i = 0 := by simp [hx_def, Ne.symm hli]
  refine BiprojectiveSpace.not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23
    k F hF hF0 l x hxl ?_
  rw [hG, map_mul]
  have : specializeFirstCoordinates (m := 2) (n := 2) x
      (MvPolynomial.X (Sum.inl i)) = 0 := by
    simp [specializeFirstCoordinates, hxi]
  rw [this, zero_mul]

/-! ### The linear nondegeneracy condition

The second condition, and — unlike the quadratic one — it genuinely needs smoothness of the
*fibre*.  The tree's global-smoothness Jacobian statement,
`exists_affineChartEquation_pderiv_ne_zero_at_of_global_smooth`, produces a nonzero partial
derivative among *all four* chart variables, which permits the two `y`-partials to carry it: that
is precisely the situation where the point is smooth on `X` but singular on its own fibre.  So the
two conditions are established from different inputs, and cannot be collapsed.
-/

/-- **The marked point of a smooth affine conic is a smooth point of it.**

Applied over `K = Frac A` to the generic fibre, this is the linear nondegeneracy condition of
`exists_chartEquation_openImmersion`: the gradient of the fibre equation at the section does not
vanish, equivalently the translated linear part is nonzero
(`PointedConic.eval_pderiv_zero_affineConicPoly` and its sibling). -/
theorem slopeLin_ne_zero_of_smooth {K : Type u} [Field K]
    (g : MvPolynomial (Fin 2) K) (hg : g ≠ 0)
    (hsm : Algebra.Smooth K (MvPolynomial (Fin 2) K ⧸ Ideal.span {g}))
    (p₁ p₂ : K) (hp : MvPolynomial.eval ![p₁, p₂] g = 0) :
    PointedConic.slopeLin (MvPolynomial.eval ![p₁, p₂] (MvPolynomial.pderiv 0 g))
      (MvPolynomial.eval ![p₁, p₂] (MvPolynomial.pderiv 1 g)) ≠ 0 := by
  have hp' : MvPolynomial.aeval ![p₁, p₂] g = 0 := by simpa using hp
  have hsmR : RingHom.Smooth
      (algebraMap K (MvPolynomial (Fin 2) K ⧸ Ideal.span {g})) :=
    (RingHom.smooth_algebraMap).mpr hsm
  obtain ⟨i, hi⟩ :=
    Hypersurface.exists_pderiv_ne_zero_at_of_smooth g hg hsmR ![p₁, p₂] hp'
  intro hzero
  obtain ⟨h0, h1⟩ := (PointedConic.slopeLin_eq_zero_iff _ _).mp hzero
  revert hi
  fin_cases i
  · simpa using h0
  · simpa using h1

/-! ### The two inputs to spreading out

The spreading-out step uses two inputs, and the passage between them is proved.

* `isIntegral_pullback_biprojectiveZeroLocusSnd` — the base change is integral.  This uses
  chartwise flatness of the conic projection together with its integral generic fibre.
* `exists_conicChart_openImmersion` — the chart computation: over a dense affine open of `T` the
  base change *contains* an affine conic with a marked `A`-point as an open subscheme, compatibly
  with the maps to `T`.  Two things it does **not** have to supply: the marked point need not be at
  the origin (`PointedConic.affineConicSchemeIso` translates it, unconditionally), and neither `A`
  nor the conic ring has to be a domain (both follow from integrality of the base change).

Given both, `exists_pointedConicAffineModel` is one application of Mathlib's
`Scheme.Hom.birationalOver`: an open immersion into an irreducible scheme with nonempty source has
dense range, hence is dominant, hence is a birational equivalence onto its target.
-/

/-! #### Integrality of the base change: subclaims

The theorem `isIntegral_pullback_biprojectiveZeroLocusSnd` is assembled from chartwise flatness,
integrality of the generic fibre, and a flat-family integrality transport theorem.

**Status.**
* The generic-fibre theorem is closed directly: the generic discriminant is nonzero, so the
  ternary conic is geometrically integral, and this property survives the fibre pullback.
* The projection is flat: its chart equations are primitive, primitive hypersurface quotients are
  flat over their coefficient rings, and the chart maps assemble Zariski-locally.
* `isIntegral_of_flat_of_isIntegral_genericFiber` is the transport used by the parent.  It needs
  only an integral base, flatness, and an integral generic fibre; no local-Noetherian hypothesis is
  introduced.
* I₂ is closed: ambient smoothness makes `π` surjective, and surjectivity is stable under base
  change, so `pullback.snd π t` is surjective (hence dominant), although the final transport no
  longer needs that instance.
* The separate I₃ theorem remains the stronger Mathlib transport
  `GeometricallyIntegral.isIntegral_of_isLocallyNoetherian` (GI + Flat + UniversallyOpen + LN base).
  The old pure-topological statement (dominant + integral generic fibre ⇒ integral total space) is
  false (`𝔸¹ ⊔ {pt} → 𝔸¹`).
-/

/-- A dense open of an integral scheme contains its generic point. -/
theorem genericPoint_mem_of_dense {X : Scheme.{u}} [IsIntegral X]
    (U : X.Opens) (hU : Dense (U : Set X)) : genericPoint X ∈ U := by
  have h := (genericPoint_spec X).mem_open_set_iff U.isOpen
  apply h.mpr
  rw [Set.univ_inter]
  haveI : Nonempty X := inferInstance
  exact hU.nonempty

/-- A dominant morphism of integral schemes sends generic point to generic point. -/
theorem apply_genericPoint_eq_of_isDominant {X Y : Scheme.{u}}
    [IsIntegral X] [IsIntegral Y] (f : X ⟶ Y) [IsDominant f] :
    f.base (genericPoint X) = genericPoint Y := by
  apply ((genericPoint_spec Y).eq _).symm
  have himg : IsGenericPoint (f.base (genericPoint X)) (closure (Set.range f.base)) := by
    have := (genericPoint_spec X).image (Scheme.Hom.continuous f)
    convert this using 1
    simp only [Set.image_univ]
  have hr : DenseRange f.base := IsDominant.denseRange (f := f)
  rwa [DenseRange.closure_range hr] at himg

/-- A scheme with a dense open immersion from an integral scheme is integral whenever it is reduced.

Used by I₁: an affine chart `Spec(K[X]/(Q))` of a smooth plane conic is integral (by
`TernaryQuadratic.isDomain_quotient_of_isHomogeneous_two_of_nonsingular` after dehomogenisation),
and opens of a reduced fibre are reduced, so density upgrades the chart to integrality of the
whole fibre. -/
theorem isIntegral_of_isReduced_of_dense_open_immersion
    {U X : Scheme.{u}} (f : U ⟶ X) [IsOpenImmersion f] [IsIntegral U] [IsReduced X]
    [IsDominant f] : IsIntegral X := by
  haveI : IrreducibleSpace X := by
    have hdense : DenseRange f.base := IsDominant.denseRange (f := f)
    have huniv : IsIrreducible (Set.univ : Set U) := IrreducibleSpace.isIrreducible_univ U
    have hrange : IsIrreducible (Set.range ⇑f.base) := by
      simpa [Set.image_univ] using
        huniv.image (⇑f.base) (Scheme.Hom.continuous f).continuousOn
    have hclosure : IsIrreducible (closure (Set.range ⇑f.base)) := hrange.closure
    rw [hdense.closure_range] at hclosure
    exact { toPreirreducibleSpace := ⟨hclosure.2⟩, toNonempty := ⟨hclosure.1.choose⟩ }
  exact isIntegral_of_irreducibleSpace_of_isReduced _

/-- If `f` is smooth over an open `U ⊆ Y` and `y ∈ U`, the scheme-theoretic fibre of `f` at `y`
is smooth over `κ(y)`.

Transport: the fibre of the restriction `f ∣_ U` is smooth by base change, and the fibre-pullback
square of the restriction square identifies it with the fibre of `f` up to the residue-field map of
the open immersion `U.ι`, which is an isomorphism. -/
theorem smooth_fiberToSpecResidueField_of_mem_smooth_open
    {X Y : Scheme.{u}} (f : X ⟶ Y) (U : Y.Opens)
    [Smooth (f ∣_ U)] (y : Y) (hy : y ∈ U) :
    Smooth (f.fiberToSpecResidueField y) := by
  let yU : (U : Scheme) := ⟨y, hy⟩
  haveI hsmR : Smooth ((f ∣_ U).fiberToSpecResidueField yU) := by
    change Smooth (Limits.pullback.snd (f ∣_ U) ((U : Scheme).fromSpecResidueField yU))
    exact MorphismProperty.pullback_snd (f ∣_ U) _ inferInstance
  have hpb : IsPullback (f ⁻¹ᵁ U).ι (f ∣_ U) f U.ι := (isPullback_morphismRestrict f U).flip
  have hfib := isPullback_fiberToSpecResidueField_of_isPullback hpb yU
  haveI : IsIso (U.ι.residueFieldMap yU) := inferInstance
  haveI hsMap : IsIso (Spec.map (U.ι.residueFieldMap yU)) := inferInstance
  let mapM := Limits.pullback.map (f ∣_ U) ((U : Scheme).fromSpecResidueField yU) f
      (Y.fromSpecResidueField (U.ι yU)) (f ⁻¹ᵁ U).ι
      (Spec.map (U.ι.residueFieldMap yU)) U.ι (by exact hpb.w.symm)
      (Scheme.Hom.SpecMap_residueFieldMap_fromSpecResidueField U.ι yU).symm
  haveI : IsIso mapM := by
    convert IsPullback.isIso_fst_of_isIso (h := hfib) (inst := hsMap)
  let fibR := (f ∣_ U).fiberToSpecResidueField yU
  let fibF := f.fiberToSpecResidueField (U.ι yU)
  let sMap := Spec.map (U.ι.residueFieldMap yU)
  have hw : mapM ≫ fibF = fibR ≫ sMap := by
    convert hfib.w <;> rfl
  haveI : Smooth sMap := inferInstance
  haveI : Smooth (fibR ≫ sMap) := by
    haveI := hsmR; infer_instance
  haveI : Smooth (mapM ≫ fibF) := by rwa [hw]
  haveI hsmF : Smooth fibF :=
    (MorphismProperty.cancel_left_of_respectsIso (P := @Smooth) mapM fibF).mp
      ‹Smooth (mapM ≫ fibF)›
  exact show Smooth (f.fiberToSpecResidueField y) from hsmF

/-- **No whole fibre of `π`.**  On a smooth bidegree-`(2,3)` threefold the fibre of
`biprojectiveZeroLocusSnd` over any residue-field point of `ℙ²_y` is a proper closed subscheme of
`ℙ²_x` (equivalently the specialised equation is nonzero).  This is the only place ambient
smoothness enters the integrality argument, and it is already proved. -/
theorem specializeSecondCoordinates_ne_zero_of_smooth_bidegree23
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (j : Fin 3) (y : Fin 3 → k) (hyj : y j = 1) :
    specializeSecondCoordinates (m := 2) y F ≠ 0 :=
  BiprojectiveSpace.not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23
    k F hF hF0 j y hyj

/-! #### I₁ packaging: smooth plane conic ⇒ integral

The generic fibre of `Y → T` is a base change of a smooth plane conic.  Split into named leaves:

* `isDomain_of_nonsingular_ternary` — TernaryQuadratic (proved)
* `nonsingular_sndResidueFiberPolynomial_of_smooth` — Jacobian nonsingularity from Smooth fibre
* `isIntegral_fiber_of_nonsingular_ternary_proj` — domain graded ring ⇒ `Proj.isIntegral`
* scheme ID of the fibre with that `Proj` (or GI of the fibre morphism)
-/

/-- **TernaryQuadratic packaging.**  Quotient by a nonsingular homogeneous ternary quadratic is a
domain.  Alias for the leaf in `TernaryQuadraticGradient`. -/
theorem isDomain_of_nonsingular_ternary
    {K : Type u} [Field K] (Q : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (hnonsing : ∀ v : Fin 3 → K, v ≠ 0 → MvPolynomial.eval v Q = 0 →
      ∃ i, MvPolynomial.eval v (MvPolynomial.pderiv i Q) ≠ 0) :
    IsDomain (MvPolynomial (Fin 3) K ⧸ Ideal.span {Q}) :=
  TernaryQuadratic.isDomain_quotient_of_isHomogeneous_two_of_nonsingular Q hQ hQ0 hnonsing

/-- In characteristic zero, Jacobian nonsingularity of a homogeneous ternary quadratic makes its
polar matrix invertible.

If the polar matrix had a nonzero kernel vector `v`, then all first derivatives would vanish at
`v`. Euler's identity, in the form `B(v,v) = 2 Q(v)`, would also give `Q(v) = 0`, contradicting
nonsingularity. -/
theorem det_polarMatrix_ne_zero_of_nonsingular
    {K : Type u} [Field K] [NeZero (2 : K)] [NeZero (3 : K)]
    (Q : MvPolynomial (Fin 3) K) (hQ : Q.IsHomogeneous 2)
    (hnonsing : ∀ v : Fin 3 → K, v ≠ 0 → MvPolynomial.eval v Q = 0 →
      ∃ i, MvPolynomial.eval v (MvPolynomial.pderiv i Q) ≠ 0) :
    (polarMatrix Q).det ≠ 0 := by
  classical
  intro hdet
  obtain ⟨v, hv0, hMv⟩ := Matrix.exists_mulVec_eq_zero_iff.mpr hdet
  have hpolar (i : Fin 3) : polarEval Q v (Pi.single i 1) = 0 := by
    rw [polarEval_basis_eq_mulVec hQ]
    exact congrFun hMv i
  have hBvv : polarEval Q v v = 0 := by
    rw [polarEval_eq_sum_basis hQ]
    simp only [hpolar, mul_zero, Finset.sum_const_zero]
  have hQv : MvPolynomial.eval v Q = 0 := by
    have hself := polarEval_self hQ v
    rw [hBvv] at hself
    exact (mul_eq_zero.mp hself.symm).resolve_left two_ne_zero
  obtain ⟨i, hi⟩ := hnonsing v hv0 hQv
  exact hi (by rw [eval_pderiv_eq_polarEval_single hQ, hpolar])

/-- **Absolute domain brick for smooth conics in characteristic zero.**

For an injective coefficient map of fields, a nonsingular homogeneous ternary quadratic remains
nonsingular after mapping coefficients. Consequently its homogeneous-coordinate quotient is a
domain after every such extension. This is essential because `κ(genericPoint T)` need not equal
`κ(genericPoint (ProjectiveSpace 2 k))`. -/
theorem isDomain_map_of_nonsingular_ternary
    {K L : Type u} [Field K] [Field L] [NeZero (2 : K)] [NeZero (3 : K)]
    (f : K →+* L) (Q : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (hnonsing : ∀ v : Fin 3 → K, v ≠ 0 → MvPolynomial.eval v Q = 0 →
      ∃ i, MvPolynomial.eval v (MvPolynomial.pderiv i Q) ≠ 0) :
    IsDomain (MvPolynomial (Fin 3) L ⧸ Ideal.span {MvPolynomial.map f Q}) := by
  classical
  have hf : Function.Injective f := RingHom.injective f
  have hQmap : (MvPolynomial.map f Q).IsHomogeneous 2 := hQ.map f
  have hQmap0 : MvPolynomial.map f Q ≠ 0 := by
    intro h
    apply hQ0
    apply MvPolynomial.map_injective f hf
    simpa using h
  have hdet : (polarMatrix Q).det ≠ 0 :=
    det_polarMatrix_ne_zero_of_nonsingular Q hQ hnonsing
  have hdetMap : (polarMatrix (MvPolynomial.map f Q)).det ≠ 0 := by
    have hmat : polarMatrix (MvPolynomial.map f Q) = (polarMatrix Q).map f := by
      ext i j
      simp only [polarMatrix_apply, Matrix.map_apply]
      have hsingle (a : Fin 3) :
          (fun b : Fin 3 ↦ f ((Pi.single a (1 : K) : Fin 3 → K) b)) =
            (Pi.single a (1 : L) : Fin 3 → L) := by
        ext b
        by_cases h : b = a
        · subst h
          simp [Pi.single_eq_same]
        · simp [Pi.single_eq_of_ne h]
      rw [← hsingle i, ← hsingle j]
      exact polarEval_map f Q (Pi.single i (1 : K)) (Pi.single j (1 : K))
    have hdetEq : ((polarMatrix Q).map f).det = f ((polarMatrix Q).det) := by
      change (f.mapMatrix (polarMatrix Q)).det = f ((polarMatrix Q).det)
      exact (RingHom.map_det f (polarMatrix Q)).symm
    rw [hmat, hdetEq]
    exact fun h ↦ hdet (hf (by simpa using h))
  have hnonsingMap :
      ∀ v : Fin 3 → L, v ≠ 0 → MvPolynomial.eval v (MvPolynomial.map f Q) = 0 →
        ∃ i, MvPolynomial.eval v (MvPolynomial.pderiv i (MvPolynomial.map f Q)) ≠ 0 := by
    intro v hv0 _hQv
    by_contra hall
    push Not at hall
    apply hdetMap
    apply det_polarMatrix_eq_zero_of_polarEval_eq_zero hQmap hv0
    intro i
    rw [← eval_pderiv_eq_polarEval_single hQmap]
    exact hall i
  exact isDomain_of_nonsingular_ternary (MvPolynomial.map f Q) hQmap hQmap0 hnonsingMap

/-- Domain descent from the fraction-field fibre of a smooth algebra.

Smoothness supplies flatness, so the canonical map into the fraction-field base change is
injective. If that base change is a domain, the original algebra is a domain as well. -/
theorem isDomain_of_smooth_of_isDomain_fractionBaseChange
    {A B K : Type u} [CommRing A] [CommRing B] [CommRing K]
    [IsDomain A] [Algebra A B] [Algebra A K] [IsFractionRing A K]
    [Algebra.Smooth A B] [IsDomain (K ⊗[A] B)] :
    IsDomain B := by
  have hinj : Function.Injective
      (Algebra.TensorProduct.includeRight : B →ₐ[A] K ⊗[A] B) :=
    Algebra.TensorProduct.includeRight_injective (IsFractionRing.injective A K)
  exact Function.Injective.isDomain
    (Algebra.TensorProduct.includeRight : B →ₐ[A] K ⊗[A] B) hinj

/-- **Algebra identity.**  The base-changed biprojective chart equation at a residue-field point
of the second factor is the ordinary dehomogenization of the specialised fibre polynomial. -/
theorem baseChangedChartEquation_eq_chartDehomogenization_sndResidue
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (y : ProjectiveSpace 2 k) (j i : Fin 3)
    (hy : y ∈ ProjectiveSpace.standardChart 2 k j) :
    letI : Algebra k ((ProjectiveSpace 2 k).residueField y) :=
      ProjectiveSpace.residueAlgebra 2 k y
    baseChangedChartEquation (i := i) (j := j)
        (ProjectiveSpace.standardChartResidueAlgHom 2 k y j hy) F =
      ProjectiveSpace.chartDehomogenization 2 ((ProjectiveSpace 2 k).residueField y) i
        (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy) := by
  letI : Algebra k ((ProjectiveSpace 2 k).residueField y) :=
    ProjectiveSpace.residueAlgebra 2 k y
  -- Underlying type of the residue field (it is a `CommRingCat` object).
  let K : Type u := (ProjectiveSpace 2 k).residueField y
  let yAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k y j hy
  let Q := BiprojectiveSpace.sndResidueFiberPolynomial F y j hy
  change tensorStandardChartEquivMvPolynomial 2 k K i
      (sndFiberChartMap (i := i) yAlg (chartEquation 2 2 k i j F)) =
    ProjectiveSpace.chartDehomogenization 2 K i Q
  have hmap :=
    BiprojectiveSpace.sndResidueFiberChartMap_chartEquation
      (m := 2) (n := 2) (R := k) F y j hy i
  rw [hmap]
  let φ : Fin 3 → K ⊗[k] ProjectiveSpace.StandardChartRing 2 k i := fun l =>
    Algebra.TensorProduct.includeRight
      (R := k) (A := K) (B := ProjectiveSpace.StandardChartRing 2 k i)
      (ProjectiveSpace.normalizedCoordinate 2 k i l)
  have hX (l : Fin 3) :
      tensorStandardChartEquivMvPolynomial 2 k K i (φ l) =
        ProjectiveSpace.chartDehomogenization 2 K i (X l) := by
    dsimp [φ]
    -- `includeRight` reduces to `1 ⊗ₜ normalizedCoordinate`
    by_cases hl : l = i
    · rw [hl, ProjectiveSpace.normalizedCoordinate_self,
        ProjectiveSpace.chartDehomogenization_X_self]
      have h1 : ((1 : K) ⊗ₜ[k] (1 : ProjectiveSpace.StandardChartRing 2 k i)) =
          algebraMap K (K ⊗[k] ProjectiveSpace.StandardChartRing 2 k i) 1 := by
        rw [Algebra.TensorProduct.algebraMap_apply]; simp
      rw [h1, AlgEquiv.commutes, map_one]
    · obtain ⟨r, hr⟩ := Fin.exists_succAbove_eq hl
      rw [← hr, ProjectiveSpace.chartDehomogenization_X_succAbove]
      change (algebraTensorAlgEquiv k K)
          ((Algebra.TensorProduct.congr (AlgEquiv.refl (R := k) (A₁ := K))
            (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i))
            ((1 : K) ⊗ₜ[k]
              ProjectiveSpace.normalizedCoordinate 2 k i (i.succAbove r))) = X r
      rw [Algebra.TensorProduct.congr_apply, Algebra.TensorProduct.map_tmul]
      convert algebraTensorAlgEquiv_tmul (R := k) (A := K) (1 : K)
        (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i
          (ProjectiveSpace.normalizedCoordinate 2 k i (i.succAbove r))) using 2
      · simp
      · rw [ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove]
        simp [map_X, one_smul]
  have hagree :
      (tensorStandardChartEquivMvPolynomial 2 k K i).toAlgHom.comp (aeval φ) =
        ProjectiveSpace.chartDehomogenization 2 K i := by
    refine MvPolynomial.algHom_ext fun l => ?_
    simp only [AlgHom.comp_apply, aeval_X]
    exact hX l
  have hφ : (fun l =>
      Algebra.TensorProduct.includeRight
        (R := k) (A := K) (B := ProjectiveSpace.StandardChartRing 2 k i)
        (ProjectiveSpace.normalizedCoordinate 2 k i l)) = φ := rfl
  rw [hφ]
  exact congrArg
    (fun ψ : MvPolynomial (Fin 3) K →ₐ[K] MvPolynomial (Fin 2) K => ψ Q) hagree

-- **I1-nonsing chart Smooth.**  From Smooth of the conic-bundle fibre at `y`, each
-- dehomogenized affine chart of the specialised fibre equation is Smooth over `κ(y)`.
-- Specialisation of `exists_chartQuotient_openImmersion` to `ψ = 𝟙` and
-- `t = fromSpecResidueField y`. Heavy chart/quotient pasting.
set_option maxHeartbeats 4000000 in
theorem ringHom_smooth_chartDehomogenization_of_smooth_fiber
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (y : ProjectiveSpace 2 k) (j i : Fin 3)
    (hy : y ∈ ProjectiveSpace.standardChart 2 k j)
    (hsmooth : Smooth ((biprojectiveZeroLocusSnd 2 2 k F).fiberToSpecResidueField y))
    (_hQ0 : BiprojectiveSpace.sndResidueFiberPolynomial F y j hy ≠ 0) :
    letI : Algebra k ((ProjectiveSpace 2 k).residueField y) :=
      ProjectiveSpace.residueAlgebra 2 k y
    RingHom.Smooth
      (algebraMap ((ProjectiveSpace 2 k).residueField y)
        (MvPolynomial (Fin 2) ((ProjectiveSpace 2 k).residueField y) ⧸
          Ideal.span {ProjectiveSpace.chartDehomogenization 2
            ((ProjectiveSpace 2 k).residueField y) i
            (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy)})) := by
  letI : Algebra k ((ProjectiveSpace 2 k).residueField y) :=
    ProjectiveSpace.residueAlgebra 2 k y
  -- Underlying type of κ(y); residue field is a `CommRingCat` object.
  let A : Type u := (ProjectiveSpace 2 k).residueField y
  let t : Spec (.of A) ⟶ ProjectiveSpace 2 k :=
    (ProjectiveSpace 2 k).fromSpecResidueField y
  let ψ : Spec (.of A) ⟶ Spec (.of A) := 𝟙 _
  let yAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k y j hy
  have hyt : Spec.map (ofHom yAlg.toRingHom) ≫ ProjectiveSpace.standardChartι 2 k j = t := by
    have hlift := ProjectiveSpace.standardChartResidueLift_standardChartι 2 k y j hy
    have hφ : Spec.map (ofHom yAlg.toRingHom) =
        ProjectiveSpace.standardChartResidueLift 2 k y j hy := by
      have : ofHom yAlg.toRingHom =
          Spec.preimage (ProjectiveSpace.standardChartResidueLift 2 k y j hy) := by
        ext x
        change yAlg.toRingHom x =
          ProjectiveSpace.standardChartResidueRingHom 2 k y j hy x
        rfl
      rw [this, Spec.map_preimage]
    rw [hφ, hlift]
  let I : Ideal (StandardChartRing 2 2 k i j) :=
    Ideal.span {chartEquation 2 2 k i j F}
  let q := sndFiberChartMap (i := i) yAlg (chartEquation 2 2 k i j F)
  let g : MvPolynomial (Fin 2) A := baseChangedChartEquation (i := i) (j := j) yAlg F
  have hg : g = baseChangedChartEquation (i := i) (j := j) yAlg F := rfl
  have hImap : I.map (sndFiberChartMap (i := i) yAlg).toRingHom = Ideal.span {q} :=
    map_span_chartEquation_eq_span_sndFiber yAlg F
  have hpb0 := isPullback_SpecMap_chartQuotient (R := k) (K := A) (i := i) (j := j) yAlg I
  haveI : Mono (ProjectiveSpace.standardChartι 2 k j) := inferInstance
  have hpb1 := Scheme.isPullback_comp_mono hpb0 (ProjectiveSpace.standardChartι 2 k j)
  let eRing := standardChartQuotientEquivAffineQuotient (R := k) (i := i) (j := j) F
  let c : Spec (.of (StandardChartRing 2 2 k i j ⧸ I)) ⟶
      biprojectiveZeroLocus 2 2 k F :=
    Spec.map eRing.symm.toCommRingCatIso.hom ≫
      (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv ≫
        chartZeroLocusToGlobal 2 2 k F hF i j
  haveI : IsOpenImmersion c := by dsimp [c]; infer_instance
  have hcπ : c ≫ biprojectiveZeroLocusSnd 2 2 k F =
      Spec.map
          (ofHom
              (Algebra.TensorProduct.includeRight
                  (R := k)
                  (A := ProjectiveSpace.StandardChartRing 2 k i)
                  (B := ProjectiveSpace.StandardChartRing 2 k j)).toRingHom ≫
                ofHom (Ideal.Quotient.mk I)) ≫
        ProjectiveSpace.standardChartι 2 k j := by
    dsimp [c]
    convert chartQuotient_to_projective_eq (i := i) (j := j) F hF using 1
    · simp only [Category.assoc]; rfl
    · rfl
  have hpb2 : IsPullback
      (Spec.map
        (ofHom
          (Algebra.TensorProduct.includeLeftRingHom
              (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i)) ≫
            ofHom
              (Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) yAlg).toRingHom))))
      (Spec.map
        (ofHom
          (Ideal.Quotient.lift I
            ((Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) yAlg).toRingHom)).comp
              (sndFiberChartMap (i := i) yAlg).toRingHom)
            (fun _ ha => Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_map_of_mem _ ha)))))
      (ψ ≫ t)
      (c ≫ biprojectiveZeroLocusSnd 2 2 k F) := by
    -- ψ ≫ t = t = Spec.map yAlg ≫ standardChartι
    have hψt : ψ ≫ t = Spec.map (ofHom yAlg.toRingHom) ≫
        ProjectiveSpace.standardChartι 2 k j := by
      change 𝟙 _ ≫ t = _
      rw [Category.id_comp, hyt]
    rw [hψt, hcπ]
    exact hpb1
  have hpb3 := hpb2.flip
  -- Exact same construction as `exists_chartQuotient_openImmersion` (use the same
  -- morphism expressions as in `hpb2`/`hpb3` so `isoPullback_hom_snd` matches).
  let rmap :=
    pullback.map (c ≫ biprojectiveZeroLocusSnd 2 2 k F) (ψ ≫ t)
      (biprojectiveZeroLocusSnd 2 2 k F) t c ψ (𝟙 _) (by simp) (by simp)
  let r0 := hpb3.isoPullback.hom ≫ rmap
  haveI : IsOpenImmersion r0 := by dsimp [r0, rmap]; infer_instance
  have hr0 : r0 ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t =
      Spec.map
          (CommRingCat.ofHom
            (Algebra.TensorProduct.includeLeftRingHom
                (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i)) ≫
              CommRingCat.ofHom
                (Ideal.Quotient.mk
                  (I.map (sndFiberChartMap (i := i) yAlg).toRingHom))) ≫
        ψ := by
    dsimp [r0, rmap]
    -- (isoPullback.hom ≫ map) ≫ snd = isoPullback.hom ≫ (map ≫ snd)
    rw [Category.assoc, Limits.pullback.lift_snd, ← Category.assoc]
    -- Now: (isoPullback.hom ≫ pullback.snd (c≫π) (ψ≫t)) ≫ ψ
    -- = hpb3.snd ≫ ψ
    congr 1
    exact hpb3.isoPullback_hom_snd
  let eW := conicChartQuotientEquivMvPolynomial 2 k A i q
  let eI := Ideal.quotEquivOfEq hImap
  let eFull := eI.trans eW.toRingEquiv
  -- g = tensorEquiv q definitionally (baseChangedChartEquation), so the quotient rings match.
  let r : Spec (CommRingCat.of (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})) ⟶
      Limits.pullback (biprojectiveZeroLocusSnd 2 2 k F) t :=
    Spec.map eFull.toCommRingCatIso.hom ≫ r0
  haveI : IsIso (Spec.map eFull.toCommRingCatIso.hom) :=
    inferInstance
  haveI : IsOpenImmersion (Spec.map eFull.toCommRingCatIso.hom) :=
    inferInstance
  haveI : IsOpenImmersion r :=
    IsOpenImmersion.comp (Spec.map eFull.toCommRingCatIso.hom) r0
  have hr : r ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t =
      Spec.map (CommRingCat.ofHom
        ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ≫ ψ := by
    dsimp only [r]
    -- (Spec.map eFull ≫ r0) ≫ snd = Spec.map eFull ≫ (r0 ≫ snd)
    rw [Category.assoc, hr0]
    -- Spec.map eFull ≫ Spec.map (includeLeft ≫ mk) ≫ ψ
    -- = Spec.map ( (includeLeft ≫ mk) ≫ eFull ) ≫ ψ   ... after reassoc
    rw [← Category.assoc]
    congr 1
    rw [← Spec.map_comp]
    congr 1
    ext a
    change eFull
        (Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) yAlg).toRingHom)
          (Algebra.TensorProduct.includeLeftRingHom
            (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i) a)) =
      Ideal.Quotient.mk (Ideal.span {g}) (C a)
    have hinc :
        Algebra.TensorProduct.includeLeftRingHom
          (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i) a =
        algebraMap A (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k i) a := rfl
    rw [hinc]
    set a' := algebraMap A (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k i) a with ha'
    change eW
        (eI (Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) yAlg).toRingHom) a')) =
      Ideal.Quotient.mk (Ideal.span {g}) (C a)
    have heI :
        eI (Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) yAlg).toRingHom) a') =
          Ideal.Quotient.mk (Ideal.span {q}) a' :=
      Ideal.quotEquivOfEq_mk hImap a'
    rw [heI]
    have hcomm := eW.commutes a
    convert hcomm using 1
    · rfl
    · change Ideal.Quotient.mk (Ideal.span {g}) (C a) =
        algebraMap A
          (MvPolynomial (Fin 2) A ⧸
            Ideal.span {tensorStandardChartEquivMvPolynomial 2 k A i q}) a
      rfl
  -- Fibre structure map is Smooth by hypothesis (definitionally pullback.snd)
  haveI : Smooth (Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t) := by
    change Smooth ((biprojectiveZeroLocusSnd 2 2 k F).fiberToSpecResidueField y)
    exact hsmooth
  haveI : Smooth r := inferInstance
  haveI hstrSmooth :
      Smooth (Spec.map (CommRingCat.ofHom
        ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ≫ ψ) := by
    have : Smooth
        (r ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t) :=
      inferInstance
    rwa [hr] at this
  haveI : Smooth (Spec.map (CommRingCat.ofHom
      ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C))) := by
    change Smooth (Spec.map (CommRingCat.ofHom
      ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ≫ 𝟙 _)
    exact hstrSmooth
  have hR : RingHom.Smooth
      ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C) :=
    (HasRingHomProperty.Spec_iff (P := @Smooth)).mp ‹_›
  have hgf : g =
      ProjectiveSpace.chartDehomogenization 2 A i
        (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy) :=
    baseChangedChartEquation_eq_chartDehomogenization_sndResidue F y j i hy
  have heq :
      algebraMap A
          (MvPolynomial (Fin 2) A ⧸
            Ideal.span
              {ProjectiveSpace.chartDehomogenization 2 A i
                (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy)}) =
        (Ideal.Quotient.mk
            (Ideal.span
              {ProjectiveSpace.chartDehomogenization 2 A i
                (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy)})).comp
          MvPolynomial.C :=
    rfl
  rw [heq, ← hgf]
  exact hR

/-- **Nonsingularity of the specialised ternary fibre equation.**

A Smooth plane conic fibre over a field has nonsingular defining equation in the Jacobian sense:
at every nonzero zero of `Q`, some partial is nonzero.  Follows from Smooth of the fibre morphism
together with the affine Jacobian criterion on standard charts of `ℙ²`
(`Hypersurface.exists_pderiv_ne_zero_at_of_smooth`).

*Status: leaf.* -/
theorem nonsingular_sndResidueFiberPolynomial_of_smooth
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (y : ProjectiveSpace 2 k) (j : Fin 3)
    (hy : y ∈ ProjectiveSpace.standardChart 2 k j)
    (hsmooth : Smooth ((biprojectiveZeroLocusSnd 2 2 k F).fiberToSpecResidueField y))
    (hQ0 : BiprojectiveSpace.sndResidueFiberPolynomial F y j hy ≠ 0)
    (v : Fin 3 → (ProjectiveSpace 2 k).residueField y) (hv0 : v ≠ 0)
    (hQv : MvPolynomial.eval v (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy) = 0) :
    ∃ i, MvPolynomial.eval v
      (MvPolynomial.pderiv i (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy)) ≠ 0 := by
  -- Algebraic core (`nonsingular_of_smooth_dehomogenized_charts`): Jacobian nonsingularity from
  -- Smooth dehomogenized chart quotients.  Remaining leaf: Smooth fibre ⇒ each chart quotient is
  -- `RingHom.Smooth` over κ(y) (open of Smooth + identification with dehomogenized hypersurface).
  set Q := BiprojectiveSpace.sndResidueFiberPolynomial F y j hy
  have hQ : Q.IsHomogeneous 2 :=
    BiprojectiveSpace.sndResidueFiberPolynomial_isHomogeneous (d := 2) (e := 3) hF y j hy
  have hsm : ∀ i : Fin 3,
      RingHom.Smooth
        (algebraMap ((ProjectiveSpace 2 k).residueField y)
          (MvPolynomial (Fin 2) ((ProjectiveSpace 2 k).residueField y) ⧸
            Ideal.span {ProjectiveSpace.chartDehomogenization 2
              ((ProjectiveSpace 2 k).residueField y) i Q})) := by
    intro i
    -- Route: open of Smooth fibre + Spec presentation of dehomogenized chart.
    -- Same packaging as the Smooth extraction in `exists_chartQuotient_openImmersion`
    -- (open immersion into pullback, composition with Smooth `pullback.snd`, Spec_iff).
    exact ringHom_smooth_chartDehomogenization_of_smooth_fiber
      F hF y j i hy hsmooth hQ0
  exact nonsingular_of_smooth_dehomogenized_charts Q hQ hQ0 hsm v hv0 hQv

/-- **Integrality of `Proj` of a nonsingular ternary quadratic quotient.**

Once `Q` is nonsingular homogeneous of degree 2 and nonzero, the quotient is a domain
(`isDomain_of_nonsingular_ternary`).  The irrelevant ideal of the graded quotient remains nonzero
(the images of the variables), so `Proj.isIntegral` applies.

*Status: packaging open — needs graded structure on the quotient ring for `Proj`.* -/
theorem isIntegral_proj_of_nonsingular_ternary
    {K : Type u} [Field K] (Q : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (hnonsing : ∀ v : Fin 3 → K, v ≠ 0 → MvPolynomial.eval v Q = 0 →
      ∃ i, MvPolynomial.eval v (MvPolynomial.pderiv i Q) ≠ 0) :
    -- Placeholder target: integrality of the projective conic as a scheme over `K`.
    -- Full statement needs `Proj` of the graded quotient; the domain step is complete.
    IsDomain (MvPolynomial (Fin 3) K ⧸ Ideal.span {Q}) :=
  isDomain_of_nonsingular_ternary Q hQ hQ0 hnonsing

/-! #### I1-GI bricks: reduced fibre + dominant chart + dense-chart assembly

Route (B): a dehomogenized chart of the nonsingular ternary fibre equation is a domain
(`isDomain_chartDehomogenization_quotient_of_nonsingular`), its Spec is integral, and that Spec
opens into the Smooth fibre.  Covering by the three standard charts gives `IsReduced` of the fibre;
density of one chart (nonempty open in an irreducible space, or equivalently `IsDominant` of the
open immersion) upgrades to `IsIntegral` via
`isIntegral_of_isReduced_of_dense_open_immersion`.
-/

/-- **Chart Spec is integral.**  The dehomogenized chart ring of a nonsingular ternary quadratic is
a domain, so its spectrum is an integral scheme. -/
theorem isIntegral_spec_chartDehomogenization_of_nonsingular
    {K : Type u} [Field K] (i : Fin 3) (Q : MvPolynomial (Fin 3) K)
    (hQ : Q.IsHomogeneous 2) (hQ0 : Q ≠ 0)
    (hnonsing : ∀ v : Fin 3 → K, v ≠ 0 → MvPolynomial.eval v Q = 0 →
      ∃ j, MvPolynomial.eval v (MvPolynomial.pderiv j Q) ≠ 0) :
    IsIntegral
      (Spec (.of (MvPolynomial (Fin 2) K ⧸
        Ideal.span {ProjectiveSpace.chartDehomogenization 2 K i Q}))) := by
  haveI : IsDomain
      (MvPolynomial (Fin 2) K ⧸
        Ideal.span {ProjectiveSpace.chartDehomogenization 2 K i Q}) :=
    isDomain_chartDehomogenization_quotient_of_nonsingular i Q hQ hQ0 hnonsing
  exact (affine_isIntegral_iff
      (.of (MvPolynomial (Fin 2) K ⧸
        Ideal.span {ProjectiveSpace.chartDehomogenization 2 K i Q}))).mpr ‹_›

set_option maxHeartbeats 4000000 in
/-- **Open immersion of a dehomogenized chart into a fibre.**

This is the scheme-theoretic chart identification itself: it produces an open immersion of
`Spec(κ[u,v]/(g))` into the fibre, where `g = chartDehomogenization Q`.  Neither smoothness nor
nonvanishing of the fibre equation is needed for this pullback-and-quotient calculation. -/
theorem exists_openImmersion_chartDehomogenization_into_fiber_core
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (y : ProjectiveSpace 2 k) (j i : Fin 3)
    (hy : y ∈ ProjectiveSpace.standardChart 2 k j) :
    letI : Algebra k ((ProjectiveSpace 2 k).residueField y) :=
      ProjectiveSpace.residueAlgebra 2 k y
    let A : Type u := (ProjectiveSpace 2 k).residueField y
    let g : MvPolynomial (Fin 2) A :=
      ProjectiveSpace.chartDehomogenization 2 A i
        (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy)
    ∃ (r : Spec (.of (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})) ⟶
        (biprojectiveZeroLocusSnd 2 2 k F).fiber y),
      IsOpenImmersion r ∧
        r ≫ (biprojectiveZeroLocusSnd 2 2 k F).fiberToSpecResidueField y =
          Spec.map (CommRingCat.ofHom
            ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ∧
        Set.range r.base =
          (biprojectiveZeroLocusSnd 2 2 k F).fiberι y ⁻¹'
            Set.range (chartZeroLocusToGlobal 2 2 k F hF i j).base := by
  letI : Algebra k ((ProjectiveSpace 2 k).residueField y) :=
    ProjectiveSpace.residueAlgebra 2 k y
  let A : Type u := (ProjectiveSpace 2 k).residueField y
  let t : Spec (.of A) ⟶ ProjectiveSpace 2 k :=
    (ProjectiveSpace 2 k).fromSpecResidueField y
  let ψ : Spec (.of A) ⟶ Spec (.of A) := 𝟙 _
  let yAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k y j hy
  have hyt : Spec.map (ofHom yAlg.toRingHom) ≫ ProjectiveSpace.standardChartι 2 k j = t := by
    have hlift := ProjectiveSpace.standardChartResidueLift_standardChartι 2 k y j hy
    have hφ : Spec.map (ofHom yAlg.toRingHom) =
        ProjectiveSpace.standardChartResidueLift 2 k y j hy := by
      have : ofHom yAlg.toRingHom =
          Spec.preimage (ProjectiveSpace.standardChartResidueLift 2 k y j hy) := by
        ext x
        change yAlg.toRingHom x =
          ProjectiveSpace.standardChartResidueRingHom 2 k y j hy x
        rfl
      rw [this, Spec.map_preimage]
    rw [hφ, hlift]
  let I : Ideal (StandardChartRing 2 2 k i j) :=
    Ideal.span {chartEquation 2 2 k i j F}
  let q := sndFiberChartMap (i := i) yAlg (chartEquation 2 2 k i j F)
  let g₀ : MvPolynomial (Fin 2) A := baseChangedChartEquation (i := i) (j := j) yAlg F
  have hImap : I.map (sndFiberChartMap (i := i) yAlg).toRingHom = Ideal.span {q} :=
    map_span_chartEquation_eq_span_sndFiber yAlg F
  have hpb0 := isPullback_SpecMap_chartQuotient (R := k) (K := A) (i := i) (j := j) yAlg I
  haveI : Mono (ProjectiveSpace.standardChartι 2 k j) := inferInstance
  have hpb1 := Scheme.isPullback_comp_mono hpb0 (ProjectiveSpace.standardChartι 2 k j)
  let eRing := standardChartQuotientEquivAffineQuotient (R := k) (i := i) (j := j) F
  let c : Spec (.of (StandardChartRing 2 2 k i j ⧸ I)) ⟶
      biprojectiveZeroLocus 2 2 k F :=
    Spec.map eRing.symm.toCommRingCatIso.hom ≫
      (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv ≫
        chartZeroLocusToGlobal 2 2 k F hF i j
  haveI : IsOpenImmersion c := by dsimp [c]; infer_instance
  have hcπ : c ≫ biprojectiveZeroLocusSnd 2 2 k F =
      Spec.map
          (ofHom
              (Algebra.TensorProduct.includeRight
                  (R := k)
                  (A := ProjectiveSpace.StandardChartRing 2 k i)
                  (B := ProjectiveSpace.StandardChartRing 2 k j)).toRingHom ≫
                ofHom (Ideal.Quotient.mk I)) ≫
        ProjectiveSpace.standardChartι 2 k j := by
    dsimp [c]
    convert chartQuotient_to_projective_eq (i := i) (j := j) F hF using 1
    · simp only [Category.assoc]; rfl
    · rfl
  have hpb2 : IsPullback
      (Spec.map
        (ofHom
          (Algebra.TensorProduct.includeLeftRingHom
              (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i)) ≫
            ofHom
              (Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) yAlg).toRingHom))))
      (Spec.map
        (ofHom
          (Ideal.Quotient.lift I
            ((Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) yAlg).toRingHom)).comp
              (sndFiberChartMap (i := i) yAlg).toRingHom)
            (fun _ ha => Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_map_of_mem _ ha)))))
      (ψ ≫ t)
      (c ≫ biprojectiveZeroLocusSnd 2 2 k F) := by
    have hψt : ψ ≫ t = Spec.map (ofHom yAlg.toRingHom) ≫
        ProjectiveSpace.standardChartι 2 k j := by
      change 𝟙 _ ≫ t = _
      rw [Category.id_comp, hyt]
    rw [hψt, hcπ]
    exact hpb1
  have hpb3 := hpb2.flip
  let rmap :=
    pullback.map (c ≫ biprojectiveZeroLocusSnd 2 2 k F) (ψ ≫ t)
      (biprojectiveZeroLocusSnd 2 2 k F) t c ψ (𝟙 _) (by simp) (by simp)
  let r0 := hpb3.isoPullback.hom ≫ rmap
  haveI : IsOpenImmersion r0 := by dsimp [r0, rmap]; infer_instance
  have hr0_range : Set.range r0.base =
      (pullback.fst (biprojectiveZeroLocusSnd 2 2 k F) t).base ⁻¹' Set.range c.base ∩
        (pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t).base ⁻¹' Set.range ψ.base := by
    simpa [r0, rmap] using Scheme.range_isOpenImmersion_to_pullback
      (biprojectiveZeroLocusSnd 2 2 k F) t c ψ hpb3
  have hr0 : r0 ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t =
      Spec.map
          (CommRingCat.ofHom
            (Algebra.TensorProduct.includeLeftRingHom
                (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i)) ≫
              CommRingCat.ofHom
                (Ideal.Quotient.mk
                  (I.map (sndFiberChartMap (i := i) yAlg).toRingHom))) ≫
        ψ := by
    dsimp [r0, rmap]
    rw [Category.assoc, Limits.pullback.lift_snd, ← Category.assoc]
    congr 1
    exact hpb3.isoPullback_hom_snd
  let eW := conicChartQuotientEquivMvPolynomial 2 k A i q
  let eI := Ideal.quotEquivOfEq hImap
  let eFull := eI.trans eW.toRingEquiv
  let r : Spec (CommRingCat.of (MvPolynomial (Fin 2) A ⧸ Ideal.span {g₀})) ⟶
      Limits.pullback (biprojectiveZeroLocusSnd 2 2 k F) t :=
    Spec.map eFull.toCommRingCatIso.hom ≫ r0
  haveI : IsOpenImmersion r :=
    IsOpenImmersion.comp (Spec.map eFull.toCommRingCatIso.hom) r0
  have hr_range : Set.range r.base = Set.range r0.base := by
    have hiso : Function.Surjective (Spec.map eFull.toCommRingCatIso.hom).base :=
      Scheme.Hom.surjective _
    change Set.range
        ((r0.base : _ → _) ∘ (Spec.map eFull.toCommRingCatIso.hom).base) = _
    exact Function.Surjective.range_comp hiso _
  have hc_range : Set.range c.base =
      Set.range (chartZeroLocusToGlobal 2 2 k F hF i j).base := by
    dsimp [c]
    have hRing : Function.Surjective
        (Spec.map eRing.symm.toCommRingCatIso.hom).base := Scheme.Hom.surjective _
    have hChart : Function.Surjective
        (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv.base :=
      Scheme.Hom.surjective _
    change Set.range
        (((chartZeroLocusToGlobal 2 2 k F hF i j).base ∘
          (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv.base) ∘
          (Spec.map eRing.symm.toCommRingCatIso.hom).base) = _
    rw [Function.Surjective.range_comp hRing]
    change Set.range
        ((chartZeroLocusToGlobal 2 2 k F hF i j).base ∘
          (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv.base) = _
    rw [Function.Surjective.range_comp hChart]
  have hr : r ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t =
      Spec.map (CommRingCat.ofHom
        ((Ideal.Quotient.mk (Ideal.span {g₀})).comp MvPolynomial.C)) ≫ ψ := by
    dsimp only [r]
    rw [Category.assoc, hr0, ← Category.assoc]
    congr 1
    rw [← Spec.map_comp]
    congr 1
    ext a
    change eFull
        (Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) yAlg).toRingHom)
          (Algebra.TensorProduct.includeLeftRingHom
            (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i) a)) =
      Ideal.Quotient.mk (Ideal.span {g₀}) (C a)
    have hinc :
        Algebra.TensorProduct.includeLeftRingHom
          (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i) a =
        algebraMap A (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k i) a := rfl
    rw [hinc]
    set a' := algebraMap A (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k i) a with ha'
    change eW
        (eI (Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) yAlg).toRingHom) a')) =
      Ideal.Quotient.mk (Ideal.span {g₀}) (C a)
    have heI :
        eI (Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) yAlg).toRingHom) a') =
          Ideal.Quotient.mk (Ideal.span {q}) a' :=
      Ideal.quotEquivOfEq_mk hImap a'
    rw [heI]
    have hcomm := eW.commutes a
    convert hcomm using 1
    · rfl
    · change Ideal.Quotient.mk (Ideal.span {g₀}) (C a) =
        algebraMap A
          (MvPolynomial (Fin 2) A ⧸
            Ideal.span {tensorStandardChartEquivMvPolynomial 2 k A i q}) a
      rfl
  have hgf : g₀ =
      ProjectiveSpace.chartDehomogenization 2 A i
        (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy) :=
    baseChangedChartEquation_eq_chartDehomogenization_sndResidue F y j i hy
  -- `fiber` is definitionally the pullback against `fromSpecResidueField`.
  let g : MvPolynomial (Fin 2) A :=
    ProjectiveSpace.chartDehomogenization 2 A i
      (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy)
  let eG : MvPolynomial (Fin 2) A ⧸ Ideal.span {g₀} ≃+*
      MvPolynomial (Fin 2) A ⧸ Ideal.span {g} :=
    Ideal.quotEquivOfEq (by rw [hgf])
  let r' : Spec (.of (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})) ⟶
      (biprojectiveZeroLocusSnd 2 2 k F).fiber y :=
    Spec.map eG.toCommRingCatIso.hom ≫ r
  haveI : IsIso (Spec.map eG.toCommRingCatIso.hom) := inferInstance
  haveI : IsOpenImmersion (Spec.map eG.toCommRingCatIso.hom) := inferInstance
  refine ⟨r', ?_, ?_, ?_⟩
  · dsimp [r']
    exact IsOpenImmersion.comp (Spec.map eG.toCommRingCatIso.hom) r
  · dsimp [r']
    change (Spec.map eG.toCommRingCatIso.hom ≫ r) ≫
        Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t =
      Spec.map (CommRingCat.ofHom
        ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C))
    rw [Category.assoc, hr, ← Category.assoc]
    change Spec.map eG.toCommRingCatIso.hom ≫
        Spec.map (CommRingCat.ofHom
          ((Ideal.Quotient.mk (Ideal.span {g₀})).comp MvPolynomial.C)) ≫ ψ =
      _
    have hψ : ψ = 𝟙 _ := rfl
    rw [hψ, Category.comp_id, ← Spec.map_comp]
    congr 1
  · have hr'_range : Set.range r'.base = Set.range r.base := by
      have hiso : Function.Surjective (Spec.map eG.toCommRingCatIso.hom).base :=
        Scheme.Hom.surjective _
      change Set.range
          ((r.base : _ → _) ∘ (Spec.map eG.toCommRingCatIso.hom).base) = _
      exact Function.Surjective.range_comp hiso _
    rw [hr'_range, hr_range, hr0_range, hc_range]
    simp [t, ψ, Scheme.Hom.fiberι]
    rfl

/-- Backwards-compatible smooth-fibre wrapper around the unconditional chart identification. -/
theorem exists_openImmersion_chartDehomogenization_into_fiber
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (y : ProjectiveSpace 2 k) (j i : Fin 3)
    (hy : y ∈ ProjectiveSpace.standardChart 2 k j)
    (_hsmooth : Smooth ((biprojectiveZeroLocusSnd 2 2 k F).fiberToSpecResidueField y))
    (_hQ0 : BiprojectiveSpace.sndResidueFiberPolynomial F y j hy ≠ 0) :
    letI : Algebra k ((ProjectiveSpace 2 k).residueField y) :=
      ProjectiveSpace.residueAlgebra 2 k y
    let A : Type u := (ProjectiveSpace 2 k).residueField y
    let g : MvPolynomial (Fin 2) A :=
      ProjectiveSpace.chartDehomogenization 2 A i
        (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy)
    ∃ (r : Spec (.of (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})) ⟶
        (biprojectiveZeroLocusSnd 2 2 k F).fiber y),
      IsOpenImmersion r ∧
        r ≫ (biprojectiveZeroLocusSnd 2 2 k F).fiberToSpecResidueField y =
          Spec.map (CommRingCat.ofHom
            ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ∧
        Set.range r.base =
          (biprojectiveZeroLocusSnd 2 2 k F).fiberι y ⁻¹'
            Set.range (chartZeroLocusToGlobal 2 2 k F hF i j).base :=
  exists_openImmersion_chartDehomogenization_into_fiber_core F hF y j i hy

/- DRAFT DISABLED: this proposed cover proof was never completed.  In particular, its pointwise
coverage branch ended by eliminating the proposition `False`.  The preceding chart open-immersion
lemma is compiled and may be used once the fibre-to-projective-space carrier comparison supplies
the actual coverage theorem.  Keeping the draft commented records the intended assembly without
putting an invalid theorem on the Lean surface.
/-- **IsReduced of a Smooth nonsingular plane-conic fibre.**

Each dehomogenized chart of the specialised fibre equation is a domain (hence reduced as a scheme).
The three standard charts open-immerse into the fibre and cover it (every point of the fibre lies
in some ambient standard chart of the ambient fibre `ℙ²_κ`, and the chart equation realises the
intersection with the fibre).  `IsReduced.of_openCover` concludes. -/
theorem isReduced_fiber_of_smooth_nonsingular_ternary
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (y : ProjectiveSpace 2 k) (j : Fin 3)
    (hy : y ∈ ProjectiveSpace.standardChart 2 k j)
    (hsmooth : Smooth ((biprojectiveZeroLocusSnd 2 2 k F).fiberToSpecResidueField y))
    (hQ0 : BiprojectiveSpace.sndResidueFiberPolynomial F y j hy ≠ 0)
    (hnonsing :
      ∀ v : Fin 3 → (ProjectiveSpace 2 k).residueField y, v ≠ 0 →
        MvPolynomial.eval v (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy) = 0 →
          ∃ i, MvPolynomial.eval v
            (MvPolynomial.pderiv i (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy)) ≠ 0) :
    IsReduced ((biprojectiveZeroLocusSnd 2 2 k F).fiber y) := by
  letI : Algebra k ((ProjectiveSpace 2 k).residueField y) :=
    ProjectiveSpace.residueAlgebra 2 k y
  let A : Type u := (ProjectiveSpace 2 k).residueField y
  let Q := BiprojectiveSpace.sndResidueFiberPolynomial F y j hy
  have hQ : Q.IsHomogeneous 2 :=
    BiprojectiveSpace.sndResidueFiberPolynomial_isHomogeneous (d := 2) (e := 3) hF y j hy
  -- Three chart open immersions into the fibre.
  have himm (i : Fin 3) :
      ∃ (r : Spec (.of (MvPolynomial (Fin 2) A ⧸ Ideal.span
          {ProjectiveSpace.chartDehomogenization 2 A i Q})) ⟶
        (biprojectiveZeroLocusSnd 2 2 k F).fiber y),
        IsOpenImmersion r := by
    obtain ⟨r, hrOI, _⟩ :=
      exists_openImmersion_chartDehomogenization_into_fiber F hF y j i hy hsmooth hQ0
    exact ⟨r, hrOI⟩
  choose r hrOI using himm
  -- Each chart Spec is reduced (domain).
  haveI hred (i : Fin 3) :
      IsReduced (Spec (.of (MvPolynomial (Fin 2) A ⧸ Ideal.span
        {ProjectiveSpace.chartDehomogenization 2 A i Q}))) := by
    haveI : IsDomain
        (MvPolynomial (Fin 2) A ⧸ Ideal.span
          {ProjectiveSpace.chartDehomogenization 2 A i Q}) :=
      isDomain_chartDehomogenization_quotient_of_nonsingular
        i Q hQ hQ0 hnonsing
    exact inferInstance
  -- Open cover by the three charts.  Coverage: every point of the fibre lies over a point of
  -- the ambient fibre base-change, which is covered by the three standard charts of `ℙ²`, and
  -- the chart open immersions realise those intersections with the fibre.
  let 𝒰 : Scheme.OpenCover ((biprojectiveZeroLocusSnd 2 2 k F).fiber y) :=
    Scheme.Cover.mkOfCovers (Fin 3)
      (fun i => Spec (.of (MvPolynomial (Fin 2) A ⧸ Ideal.span
        {ProjectiveSpace.chartDehomogenization 2 A i Q})))
      r
      (fun x => by
        -- Coverage of the fibre by dehomogenized charts.
        -- Every point of a plane conic in `ℙ²` has some homogeneous coordinate nonzero, so lies
        -- in some standard chart; the corresponding fibre-chart open immersion hits it.
        -- Full carrier identification fibre ↪ ambient fibre base-change ≅ `ℙ²_κ` is packaged in
        -- `zeroLocusSndFiberToBaseChange` / `sndFiberIsoBaseChange`; the chartwise equation
        -- comparison is `sndResidueFiberChartMap_chartEquation`.
        -- Here we use that the fibre is nonempty on each stalk-chart from Smooth + nonsingularity
        -- and that the three chart ranges cover because their ambient counterparts do.
        classical
        -- Fallback: the affine cover of the fibre refines through chart domains once the
        -- ambient standard charts are pulled back.  Direct pointwise construction:
        obtain ⟨i, hi⟩ : ∃ i : Fin 3, True := ⟨0, trivial⟩
        -- Use that Smooth fibres over fields are covered by the standard dehomogenized charts:
        -- pick any affine open of the fibre containing `x` and refine; for the ternary conic the
        -- three charts `D₊(Xᵢ) ∩ V(Q)` cover `V(Q)`.
        refine ⟨i, ?_⟩
        -- Pointwise covering is the content of the ambient projective chart cover transported
        -- along the closed immersion of the fibre.  Discharge via classical choice of a chart
        -- index for which the section is invertible on a neighborhood — equivalent to membership
        -- in the opensRange of `r i`.
        --
        -- Concrete route used here: the fibre morphism is Smooth over a field, hence locally of
        -- finite presentation; an open affine neighbourhood of `x` is standard-smooth over `κ(y)`
        -- and, by the Jacobian packaging of `ringHom_smooth_chartDehomogenization_of_smooth_fiber`,
        -- isomorphic to an open of some chart Spec.  That open sits in `Set.range (r i).base`.
        have : ∃ (z : Spec (.of (MvPolynomial (Fin 2) A ⧸ Ideal.span
            {ProjectiveSpace.chartDehomogenization 2 A i Q}))), r i z = x := by
          -- The three projective charts cover the ambient; transport along the closed immersion.
          -- Detailed Nullstellensatz/carrier comparison is left as the ambient-chart cover:
          -- `ProjectiveSpace.standardAffineOpenCover` covers `ℙ²`, and the fibre is a closed
          -- subscheme, so its points lie in some chart pullback, which is the domain of `r i`.
          --
          -- For the present assembly we use that `x` lies in the opensRange of the open cover
          -- obtained by pulling back the ambient standard charts along the closed immersion
          -- `zeroLocusSndFiberι`.  That pullback is isomorphic to the chart Spec via the
          -- equation comparison already used to build `r`.
          exfalso
          exact False.elim (Bool.false_ne_true rfl)
        exact this)
      (fun i => hrOI i)
  exact IsReduced.of_openCover (π.fiber y) 𝒰
-/

/-- The three dehomogenized standard charts cover a smooth nonsingular conic fibre, so the
fibre is reduced.  The only topological input is the standard product-chart cover of the ambient
biprojective space; the exact range formula in
`exists_openImmersion_chartDehomogenization_into_fiber` identifies its pullback to the fibre. -/
theorem isReduced_fiber_of_smooth_nonsingular_ternary
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (y : ProjectiveSpace 2 k) (j : Fin 3)
    (hy : y ∈ ProjectiveSpace.standardChart 2 k j)
    (hsmooth : Smooth ((biprojectiveZeroLocusSnd 2 2 k F).fiberToSpecResidueField y))
    (hQ0 : BiprojectiveSpace.sndResidueFiberPolynomial F y j hy ≠ 0)
    (hnonsing :
      ∀ v : Fin 3 → (ProjectiveSpace 2 k).residueField y, v ≠ 0 →
        MvPolynomial.eval v (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy) = 0 →
          ∃ i, MvPolynomial.eval v
            (MvPolynomial.pderiv i
              (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy)) ≠ 0) :
    IsReduced ((biprojectiveZeroLocusSnd 2 2 k F).fiber y) := by
  letI : Algebra k ((ProjectiveSpace 2 k).residueField y) :=
    ProjectiveSpace.residueAlgebra 2 k y
  let A : Type u := (ProjectiveSpace 2 k).residueField y
  let Q : MvPolynomial (Fin 3) A :=
    BiprojectiveSpace.sndResidueFiberPolynomial F y j hy
  have hQ : Q.IsHomogeneous 2 :=
    BiprojectiveSpace.sndResidueFiberPolynomial_isHomogeneous
      (d := 2) (e := 3) hF y j hy
  have himm (i : Fin 3) :
      ∃ (r : Spec (.of (MvPolynomial (Fin 2) A ⧸ Ideal.span
          {ProjectiveSpace.chartDehomogenization 2 A i Q})) ⟶
        (biprojectiveZeroLocusSnd 2 2 k F).fiber y),
        IsOpenImmersion r ∧
          Set.range r.base =
            (biprojectiveZeroLocusSnd 2 2 k F).fiberι y ⁻¹'
              Set.range (chartZeroLocusToGlobal 2 2 k F hF i j).base := by
    obtain ⟨r, hr, _, hrange⟩ :=
      exists_openImmersion_chartDehomogenization_into_fiber
        F hF y j i hy hsmooth hQ0
    exact ⟨r, hr, hrange⟩
  choose r hrOI hrange using himm
  haveI hred (i : Fin 3) :
      IsReduced (Spec (.of (MvPolynomial (Fin 2) A ⧸ Ideal.span
        {ProjectiveSpace.chartDehomogenization 2 A i Q}))) := by
    haveI : IsDomain
        (MvPolynomial (Fin 2) A ⧸ Ideal.span
          {ProjectiveSpace.chartDehomogenization 2 A i Q}) :=
      isDomain_chartDehomogenization_quotient_of_nonsingular
        i Q hQ hQ0 hnonsing
    infer_instance
  let π := biprojectiveZeroLocusSnd 2 2 k F
  have hrangeStandardChart (i j : Fin 3) :
      Set.range (standardChartι 2 2 k i j) =
        fst 2 2 k ⁻¹' Set.range (ProjectiveSpace.standardChartι 2 k i) ∩
          snd 2 2 k ⁻¹' Set.range (ProjectiveSpace.standardChartι 2 k j) := by
    have h := Scheme.Pullback.range_map
      (ProjectiveSpace.standardChartι 2 k i ≫ ProjectiveSpace.toSpec 2 k)
      (ProjectiveSpace.standardChartι 2 k j ≫ ProjectiveSpace.toSpec 2 k)
      (ProjectiveSpace.toSpec 2 k) (ProjectiveSpace.toSpec 2 k)
      (ProjectiveSpace.standardChartι 2 k i)
      (ProjectiveSpace.standardChartι 2 k j) (𝟙 _)
      (by simp) (by simp)
    convert h using 1
    dsimp only [standardChartι, standardOpenCover]
    simp only [Scheme.Pullback.openCoverOfLeftRight_f]
    rfl
  let 𝒰 : Scheme.OpenCover (π.fiber y) :=
    Scheme.Cover.mkOfCovers (Fin 3)
      (fun i => Spec (.of (MvPolynomial (Fin 2) A ⧸ Ideal.span
        {ProjectiveSpace.chartDehomogenization 2 A i Q})))
      r
      (fun x => by
        classical
        let z : BiprojectiveSpace 2 2 k :=
          (biprojectiveZeroLocusι 2 2 k F).base ((π.fiberι y).base x)
        have hz : z ∈ (⊤ : (BiprojectiveSpace 2 2 k).Opens) := trivial
        rw [← BiprojectiveSpace.iSup_standardChartAffineOpen 2 2 k] at hz
        simp only [TopologicalSpace.Opens.mem_iSup] at hz
        obtain ⟨⟨i, j'⟩, hz⟩ := hz
        change z ∈ ((standardChartAffineOpen 2 2 k i j').1 : Set _) at hz
        have hstd' : ((standardChartAffineOpen 2 2 k i j').1 : Set _) =
            Set.range (standardChartι 2 2 k i j') := by
          simp [standardChartAffineOpen, Scheme.Hom.coe_opensRange]
        rw [hstd', hrangeStandardChart] at hz
        have hxy : π.base ((π.fiberι y).base x) = y := by
          have hxmem : (π.fiberι y).base x ∈ Set.range (π.fiberι y).base := ⟨x, rfl⟩
          rw [Scheme.Hom.range_fiberι] at hxmem
          exact hxmem
        have hzfixed : z ∈ Set.range (standardChartι 2 2 k i j) := by
          rw [hrangeStandardChart]
          refine ⟨hz.1, ?_⟩
          change (snd 2 2 k).base z ∈
            Set.range (ProjectiveSpace.standardChartι 2 k j)
          have hsnd : (snd 2 2 k).base z = y := by
            rw [← hxy]
            simp [z, π, biprojectiveZeroLocusSnd, Scheme.Hom.comp_base]
          rw [hsnd, ← Scheme.Hom.coe_opensRange,
            ProjectiveSpace.opensRange_standardChartι]
          exact hy
        have hchart : (π.fiberι y).base x ∈
            Set.range (chartZeroLocusToGlobal 2 2 k F hF i j).base := by
          change (π.fiberι y).base x ∈
            (chartZeroLocusToGlobal 2 2 k F hF i j).opensRange
          rw [opensRange_chartZeroLocusToGlobal]
          change z ∈ ((standardChartAffineOpen 2 2 k i j).1 : Set _)
          have hstd : ((standardChartAffineOpen 2 2 k i j).1 : Set _) =
              Set.range (standardChartι 2 2 k i j) := by
            simp [standardChartAffineOpen, Scheme.Hom.coe_opensRange]
          rw [hstd]
          exact hzfixed
        have hxrange : x ∈ Set.range (r i).base := by
          rw [hrange i]
          exact hchart
        obtain ⟨a, ha⟩ := hxrange
        exact ⟨i, a, ha⟩)
      (fun i => hrOI i)
  haveI : ∀ i : 𝒰.I₀, IsReduced (𝒰.X i) := by
    change ∀ i : Fin 3, IsReduced
      (Spec (.of (MvPolynomial (Fin 2) A ⧸ Ideal.span
        {ProjectiveSpace.chartDehomogenization 2 A i Q})))
    exact hred
  exact IsReduced.of_openCover (π.fiber y) 𝒰

set_option maxHeartbeats 12000000 in
-- The proof assembles and base-changes a three-chart cover and its pairwise intersections.
/-- A smooth plane conic whose ternary equation is nonsingular remains integral after every
field extension.  The proof base-changes the three standard affine charts, proves each chart
integral from the mapped nonsingular quadratic, and uses the generic point of the homogeneous
coordinate ring to give a common point in all three charts. -/
theorem geometricallyIntegral_fiber_of_nonsingular_ternary
    {k : Type u} [Field k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (y : ProjectiveSpace 2 k) (j : Fin 3)
    (hy : y ∈ ProjectiveSpace.standardChart 2 k j)
    (hQ0 : BiprojectiveSpace.sndResidueFiberPolynomial F y j hy ≠ 0)
    (hnonsing :
      ∀ v : Fin 3 → (ProjectiveSpace 2 k).residueField y, v ≠ 0 →
        MvPolynomial.eval v (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy) = 0 →
          ∃ i, MvPolynomial.eval v
            (MvPolynomial.pderiv i
              (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy)) ≠ 0) :
    GeometricallyIntegral
      ((biprojectiveZeroLocusSnd 2 2 k F).fiberToSpecResidueField y) := by
  letI : Algebra k ((ProjectiveSpace 2 k).residueField y) :=
    ProjectiveSpace.residueAlgebra 2 k y
  let A : Type u := (ProjectiveSpace 2 k).residueField y
  letI : NeZero (2 : A) :=
    neZero_two_of_injective_algebraMap (FaithfulSMul.algebraMap_injective k A)
  letI : NeZero (3 : A) :=
    neZero_three_of_injective_algebraMap (FaithfulSMul.algebraMap_injective k A)
  let Q : MvPolynomial (Fin 3) A :=
    BiprojectiveSpace.sndResidueFiberPolynomial F y j hy
  have hQ : Q.IsHomogeneous 2 :=
    BiprojectiveSpace.sndResidueFiberPolynomial_isHomogeneous
      (d := 2) (e := 3) hF y j hy
  let π := biprojectiveZeroLocusSnd 2 2 k F
  let f₀ := π.fiberToSpecResidueField y
  let B : Fin 3 → Type u := fun i ↦
    MvPolynomial (Fin 2) A ⧸ Ideal.span
      {ProjectiveSpace.chartDehomogenization 2 A i Q}
  have himm (i : Fin 3) :
      ∃ (r : Spec (.of (B i)) ⟶ π.fiber y),
        IsOpenImmersion r ∧
          r ≫ f₀ = Spec.map (CommRingCat.ofHom (algebraMap A (B i))) ∧
          Set.range r.base = π.fiberι y ⁻¹'
            Set.range (chartZeroLocusToGlobal 2 2 k F hF i j).base := by
    obtain ⟨r, hr, hrstruct, hrange⟩ :=
      exists_openImmersion_chartDehomogenization_into_fiber_core
        F hF y j i hy
    refine ⟨r, hr, ?_, hrange⟩
    rw [hrstruct]
    congr 2
  choose r hrOI hrstruct hrange using himm
  let 𝒰 : Scheme.OpenCover (π.fiber y) :=
    Scheme.Cover.mkOfCovers (Fin 3) (fun i ↦ Spec (.of (B i))) r
      (fun x ↦ by
        classical
        let z : BiprojectiveSpace 2 2 k :=
          (biprojectiveZeroLocusι 2 2 k F).base ((π.fiberι y).base x)
        have hz : z ∈ (⊤ : (BiprojectiveSpace 2 2 k).Opens) := trivial
        rw [← BiprojectiveSpace.iSup_standardChartAffineOpen 2 2 k] at hz
        simp only [TopologicalSpace.Opens.mem_iSup] at hz
        obtain ⟨⟨i, j'⟩, hz⟩ := hz
        change z ∈ ((standardChartAffineOpen 2 2 k i j').1 : Set _) at hz
        have hrangeStandardChart (a b : Fin 3) :
            Set.range (standardChartι 2 2 k a b) =
              fst 2 2 k ⁻¹' Set.range (ProjectiveSpace.standardChartι 2 k a) ∩
                snd 2 2 k ⁻¹' Set.range (ProjectiveSpace.standardChartι 2 k b) := by
          have h := Scheme.Pullback.range_map
            (ProjectiveSpace.standardChartι 2 k a ≫ ProjectiveSpace.toSpec 2 k)
            (ProjectiveSpace.standardChartι 2 k b ≫ ProjectiveSpace.toSpec 2 k)
            (ProjectiveSpace.toSpec 2 k) (ProjectiveSpace.toSpec 2 k)
            (ProjectiveSpace.standardChartι 2 k a)
            (ProjectiveSpace.standardChartι 2 k b) (𝟙 _)
            (by simp) (by simp)
          convert h using 1
          dsimp only [BiprojectiveSpace.standardChartι,
            BiprojectiveSpace.standardOpenCover]
          simp only [Scheme.Pullback.openCoverOfLeftRight_f]
          rfl
        have hstd' : ((standardChartAffineOpen 2 2 k i j').1 : Set _) =
            Set.range (standardChartι 2 2 k i j') := by
          simp [standardChartAffineOpen, Scheme.Hom.coe_opensRange]
        rw [hstd', hrangeStandardChart] at hz
        have hxy : π.base ((π.fiberι y).base x) = y := by
          have hxmem : (π.fiberι y).base x ∈ Set.range (π.fiberι y).base := ⟨x, rfl⟩
          rw [Scheme.Hom.range_fiberι] at hxmem
          exact hxmem
        have hzfixed : z ∈ Set.range (standardChartι 2 2 k i j) := by
          rw [hrangeStandardChart]
          refine ⟨hz.1, ?_⟩
          change (snd 2 2 k).base z ∈ Set.range (ProjectiveSpace.standardChartι 2 k j)
          have hsnd : (snd 2 2 k).base z = y := by
            rw [← hxy]
            simp [z, π, biprojectiveZeroLocusSnd, Scheme.Hom.comp_base]
          rw [hsnd, ← Scheme.Hom.coe_opensRange,
            ProjectiveSpace.opensRange_standardChartι]
          exact hy
        have hchart : (π.fiberι y).base x ∈
            Set.range (chartZeroLocusToGlobal 2 2 k F hF i j).base := by
          change (π.fiberι y).base x ∈
            (chartZeroLocusToGlobal 2 2 k F hF i j).opensRange
          rw [opensRange_chartZeroLocusToGlobal]
          change z ∈ ((standardChartAffineOpen 2 2 k i j).1 : Set _)
          have hstd : ((standardChartAffineOpen 2 2 k i j).1 : Set _) =
              Set.range (standardChartι 2 2 k i j) := by
            simp [standardChartAffineOpen, Scheme.Hom.coe_opensRange]
          rw [hstd]
          exact hzfixed
        have hxrange : x ∈ Set.range (r i).base := by
          rw [hrange i]
          exact hchart
        obtain ⟨a, ha⟩ := hxrange
        exact ⟨i, a, ha⟩)
      (fun i ↦ hrOI i)
  refine ⟨?_⟩
  change geometrically IsIntegral f₀
  apply (geometrically_iff_of_commRing
    (P := IsIntegral) (R := A) (f := f₀)).mpr
  intro K hK hAK Z fstZ sndZ hpbZ
  letI : Field K := hK
  letI : Algebra A K := hAK
  letI : NeZero (2 : K) :=
    neZero_two_of_injective_algebraMap (FaithfulSMul.algebraMap_injective A K)
  letI : NeZero (3 : K) :=
    neZero_three_of_injective_algebraMap (FaithfulSMul.algebraMap_injective A K)
  let s : Spec (.of K) ⟶ Spec (.of A) :=
    Spec.map (CommRingCat.ofHom (algebraMap A K))
  let Xₖ : Scheme := Limits.pullback f₀ s
  let pX : Xₖ ⟶ π.fiber y := Limits.pullback.fst f₀ s
  let 𝒱 : Scheme.OpenCover Xₖ := 𝒰.pullback₁ pX
  suffices hXₖ : IsIntegral Xₖ by
    letI : IsIntegral Xₖ := hXₖ
    let eX : Xₖ ≅ Limits.pullback f₀
        (Spec.map (CommRingCat.ofHom (algebraMap A K))) :=
      pullback.congrHom rfl rfl
    let eZ : Xₖ ≅ Z := eX ≪≫ hpbZ.isoPullback.symm
    exact IsIntegral.of_isIso eZ.hom
  let QK := MvPolynomial.map (algebraMap A K) Q
  have hQK : QK.IsHomogeneous 2 := hQ.map _
  have hQK0 : QK ≠ 0 := by
    simpa [QK, Q] using
      (MvPolynomial.map_injective _ (FaithfulSMul.algebraMap_injective A K)).ne hQ0
  have hdetA : (polarMatrix Q).det ≠ 0 :=
    det_polarMatrix_ne_zero_of_nonsingular Q hQ hnonsing
  have hdetK : (polarMatrix QK).det ≠ 0 := by
    have hmat : polarMatrix QK =
        (polarMatrix Q).map (algebraMap A K) := by
      ext i j
      simp only [QK, polarMatrix_apply, Matrix.map_apply]
      have hsingle (a : Fin 3) :
          (fun b : Fin 3 ↦ algebraMap A K
            ((Pi.single a (1 : A) : Fin 3 → A) b)) =
            (Pi.single a (1 : K) : Fin 3 → K) := by
        ext b
        by_cases h : b = a
        · subst h
          simp [Pi.single_eq_same]
        · simp [Pi.single_eq_of_ne h]
      rw [← hsingle i, ← hsingle j]
      exact polarEval_map (algebraMap A K) Q
        (Pi.single i (1 : A)) (Pi.single j (1 : A))
    rw [hmat]
    have hdetEq : ((polarMatrix Q).map (algebraMap A K)).det =
        algebraMap A K ((polarMatrix Q).det) := by
      change ((algebraMap A K).mapMatrix (polarMatrix Q)).det = _
      exact (RingHom.map_det (algebraMap A K) (polarMatrix Q)).symm
    rw [hdetEq]
    simpa using (FaithfulSMul.algebraMap_injective A K).ne hdetA
  have hnonsingK : ∀ v : Fin 3 → K, v ≠ 0 → MvPolynomial.eval v QK = 0 →
      ∃ i, MvPolynomial.eval v (MvPolynomial.pderiv i QK) ≠ 0 := by
    intro v hv0 _
    exact exists_eval_pderiv_ne_zero_of_det_polarMatrix_ne_zero QK hQK hdetK v hv0
  have hVint (i : Fin 3) : IsIntegral (𝒱.X i) := by
    let g := ProjectiveSpace.chartDehomogenization 2 A i Q
    have hmap : ProjectiveSpace.chartDehomogenization 2 K i QK =
        MvPolynomial.map (algebraMap A K) g := chartDehomogenization_map i Q
    haveI hmapDom : IsDomain
        (MvPolynomial (Fin 2) K ⧸ Ideal.span
          {MvPolynomial.map (algebraMap A K) g}) := by
      rw [← hmap]
      exact isDomain_chartDehomogenization_quotient_of_nonsingular
        i QK hQK hQK0 hnonsingK
    let eKB := baseChangeChartQuotientEquiv (K := A) (L := K) g
    haveI hKBDom : IsDomain (K ⊗[A] B i) :=
      eKB.toRingEquiv.toMulEquiv.isDomain _
    haveI hBKDom : IsDomain (B i ⊗[A] K) :=
      (Algebra.TensorProduct.comm A (B i) K).toRingEquiv.toMulEquiv.isDomain _
    haveI hSpecInt : IsIntegral (Spec (.of (B i ⊗[A] K))) := inferInstance
    have houter :=
      (IsPullback.of_hasPullback pX (r i)).flip.paste_vert
        (IsPullback.of_hasPullback f₀ s)
    let eV : 𝒱.X i ≅ Spec (.of (B i ⊗[A] K)) :=
      houter.isoPullback ≪≫ pullback.congrHom (hrstruct i) rfl ≪≫
        pullbackSpecIso A (B i) K
    exact IsIntegral.of_isIso eV.inv
  let i₀ : Fin 3 := 0
  let H := MvPolynomial (Fin 3) K ⧸ Ideal.span {QK}
  letI hHDom : IsDomain H :=
    isDomain_of_nonsingular_ternary QK hQK hQK0 hnonsingK
  let L := FractionRing H
  letI : Algebra k L := RingHom.toAlgebra
    ((algebraMap A L).comp (algebraMap k A))
  haveI : IsScalarTower k A L := IsScalarTower.of_algebraMap_eq fun _ ↦ rfl
  obtain ⟨x, hxi, hxnonzero, hxQ⟩ :=
    exists_genericConicCoordinates QK hQK hQK0 i₀
  let yL : Fin 3 → L := fun l ↦
    algebraMap A L (ProjectiveSpace.normalizedResidueCoordinates 2 k y j hy l)
  have hyLj : yL j = 1 := by
    simp [yL]
  have hcoeff : (algebraMap A L).comp
      (ProjectiveSpace.residueCoefficientMap 2 k y) = algebraMap k L := by
    change (algebraMap A L).comp (algebraMap k A) = algebraMap k L
    exact (IsScalarTower.algebraMap_eq k A L).symm
  have hQmap : MvPolynomial.map (algebraMap A L) Q =
      specializeSecondCoordinates yL (MvPolynomial.map (algebraMap k L) F) := by
    dsimp only [Q, BiprojectiveSpace.sndResidueFiberPolynomial]
    rw [map_specializeSecondCoordinates, MvPolynomial.map_map, hcoeff]
  have hQtower : MvPolynomial.map (algebraMap A L) Q =
      MvPolynomial.map (algebraMap K L) QK := by
    dsimp only [QK]
    rw [MvPolynomial.map_map, ← IsScalarTower.algebraMap_eq A K L]
  have hxF : MvPolynomial.aeval (Sum.elim x yL) F = 0 := by
    rw [MvPolynomial.aeval_def, MvPolynomial.eval₂_eq_eval_map,
      ← eval_specializeSecondCoordinates, ← hQmap]
    rw [hQtower]
    exact hxQ
  let zChart := chartZeroLocusPointOfNormalizedAlgebra
    2 2 i₀ j x yL hxi hyLj F hxF
  let z : Spec (.of L) ⟶ biprojectiveZeroLocus 2 2 k F :=
    zChart ≫ chartZeroLocusToGlobal 2 2 k F hF i₀ j
  let pGlobal : Spec (.of L) ⟶ BiprojectiveSpace 2 2 k :=
    biprojectiveChartPointOfNormalizedAlgebra (R := k) 2 2 i₀ j x yL ≫
      standardChartι 2 2 k i₀ j
  have hzambient : z ≫ biprojectiveZeroLocusι 2 2 k F = pGlobal := by
    dsimp only [z, pGlobal]
    rw [Category.assoc, chartZeroLocusToGlobal_ι]
    rw [← Category.assoc,
      chartZeroLocusPointOfNormalizedAlgebra_subschemeι]
  have hzbase : z ≫ π =
      Spec.map (CommRingCat.ofHom (algebraMap A L)) ≫
        (ProjectiveSpace 2 k).fromSpecResidueField y := by
    dsimp only [z, π, biprojectiveZeroLocusSnd]
    rw [Category.assoc]
    rw [chartZeroLocusToGlobal_ι_assoc]
    rw [← Category.assoc zChart,
      chartZeroLocusPointOfNormalizedAlgebra_subschemeι]
    rw [biprojectiveChartPointOfNormalizedAlgebra_comp_standardChartι_snd]
    exact pointOfNormalizedCoordinatesAlgebra_mapped_normalizedResidueCoordinates
      2 y j hy (algebraMap A L) hcoeff
  let zA : Spec (.of L) ⟶ Spec (.of A) :=
    Spec.map (CommRingCat.ofHom (algebraMap A L))
  let zFib : Spec (.of L) ⟶ π.fiber y :=
    pullback.lift z zA hzbase
  have hzFib_ι : zFib ≫ π.fiberι y = z := by
    dsimp only [zFib, Scheme.Hom.fiberι, Scheme.Hom.fiber]
    rw [pullback.lift_fst]
  have hzFib_base : zFib ≫ f₀ = zA := by
    apply (cancel_mono ((ProjectiveSpace 2 k).fromSpecResidueField y)).mp
    rw [Category.assoc, ← π.fiber_fac y]
    rw [← Category.assoc, hzFib_ι, hzbase]
  let zK : Spec (.of L) ⟶ Spec (.of K) :=
    Spec.map (CommRingCat.ofHom (algebraMap K L))
  have hzcompat : zFib ≫ f₀ = zK ≫ s := by
    rw [hzFib_base]
    dsimp only [zA, zK, s]
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp,
      ← IsScalarTower.algebraMap_eq A K L]
  let zBC : Spec (.of L) ⟶ Xₖ := pullback.lift zFib zK hzcompat
  have hzBC_pX : zBC ≫ pX = zFib := by
    dsimp only [zBC, pX, Xₖ]
    rw [pullback.lift_fst]
  let pt : Spec (.of L) := IsLocalRing.closedPoint L
  let w : Xₖ := zBC.base pt
  have hpGlobalStd (a : Fin 3) :
      pGlobal.base pt ∈ Set.range (standardChartι 2 2 k a j) := by
    have hyL0 : yL j ≠ 0 := by rw [hyLj]; exact one_ne_zero
    simpa only [pGlobal, pt] using
      (biprojectiveChartPointOfNormalizedAlgebra_mem_standardChart
        2 2 i₀ j a j x yL hxi hyLj (hxnonzero a) hyL0)
  have hzChartRange (a : Fin 3) :
      z.base pt ∈ Set.range (chartZeroLocusToGlobal 2 2 k F hF a j).base := by
    change z.base pt ∈ (chartZeroLocusToGlobal 2 2 k F hF a j).opensRange
    rw [opensRange_chartZeroLocusToGlobal]
    change (biprojectiveZeroLocusι 2 2 k F).base (z.base pt) ∈
      ((standardChartAffineOpen 2 2 k a j).1 : Set _)
    rw [← Scheme.Hom.comp_apply, hzambient]
    have hstd : ((standardChartAffineOpen 2 2 k a j).1 : Set _) =
        Set.range (standardChartι 2 2 k a j) := by
      simp [standardChartAffineOpen, Scheme.Hom.coe_opensRange]
    rw [hstd]
    exact hpGlobalStd a
  have hzFibRange (a : Fin 3) : zFib.base pt ∈ Set.range (r a).base := by
    rw [hrange a]
    change (π.fiberι y).base (zFib.base pt) ∈
      Set.range (chartZeroLocusToGlobal 2 2 k F hF a j).base
    rw [← Scheme.Hom.comp_apply, hzFib_ι]
    exact hzChartRange a
  letI : Nonempty Xₖ := ⟨w⟩
  haveI : ∀ i : 𝒱.I₀, IsIntegral (𝒱.X i) := by
    change ∀ i : Fin 3, IsIntegral (𝒱.X i)
    exact hVint
  apply isIntegral_of_openCover_of_pairwise_nonempty 𝒱
  intro a b hab hdis
  have hw (i : Fin 3) : w ∈ (𝒱.f i).opensRange := by
    have hrangeV : Set.range (𝒱.f i).base =
        pX.base ⁻¹' Set.range (r i).base := by
      change Set.range (pullback.fst pX (r i)).base = _
      simpa [Scheme.Hom.coe_opensRange] using
        (IsOpenImmersion.range_pullbackFst (r i) pX)
    change w ∈ Set.range (𝒱.f i).base
    rw [hrangeV]
    change pX.base w ∈ Set.range (r i).base
    dsimp only [w]
    rw [← Scheme.Hom.comp_apply, hzBC_pX]
    exact hzFibRange i
  have hbot := hdis.le_bot ⟨hw a, hw b⟩
  exact hbot

/-- Smooth-fibre wrapper retained for callers that obtain nonsingularity from smoothness. -/
theorem geometricallyIntegral_fiber_of_smooth_nonsingular_ternary
    {k : Type u} [Field k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (y : ProjectiveSpace 2 k) (j : Fin 3)
    (hy : y ∈ ProjectiveSpace.standardChart 2 k j)
    (_hsmooth : Smooth ((biprojectiveZeroLocusSnd 2 2 k F).fiberToSpecResidueField y))
    (hQ0 : BiprojectiveSpace.sndResidueFiberPolynomial F y j hy ≠ 0)
    (hnonsing :
      ∀ v : Fin 3 → (ProjectiveSpace 2 k).residueField y, v ≠ 0 →
        MvPolynomial.eval v (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy) = 0 →
          ∃ i, MvPolynomial.eval v
            (MvPolynomial.pderiv i
              (BiprojectiveSpace.sndResidueFiberPolynomial F y j hy)) ≠ 0) :
    GeometricallyIntegral
      ((biprojectiveZeroLocusSnd 2 2 k F).fiberToSpecResidueField y) :=
  geometricallyIntegral_fiber_of_nonsingular_ternary
    F hF y j hy hQ0 hnonsing

/-- **Subclaim I₁.**  The generic fibre of `Y → T` is integral.

*Why.*  Dominance of `t` and density of `U` put the generic point of `T` over a point of `U`, so
the fibre is a base change of a fibre of the *smooth* morphism `π ∣_ U`.  A smooth plane conic over
a field is geometrically integral.

*Algebra closed.*  Nonsingular homogeneous ternary quadratics are irreducible
(`TernaryQuadratic.irreducible_of_isHomogeneous_two_of_nonsingular`); quotient is a domain;
`Proj.isIntegral` is proved for graded domains.

*Assembly.* Setup closed (`t(η) ∈ U`, specialised `Q`, Smooth fibre transport). Integrality of the
fibre is Mathlib's `GeometricallyIntegral.isIntegral_of_subsingleton`, once the fibre morphism is
geometrically integral.

*Geometric integrality.*  The three dehomogenized standard charts remain integral after every
field extension, and the homogeneous-coordinate generic point gives a common point in all three
charts.  Hence the base-changed chart cover is irreducible and reduced.

*Status: closed.* -/
theorem isIntegral_genericFiber_pullback_biprojectiveZeroLocusSnd
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (hsmooth : Smooth (biprojectiveZeroLocusSnd 2 2 k F ∣_ U)) :
    IsIntegral
      ((Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t).fiber (genericPoint T)) := by
  -- Setup: the generic point of `T` lands in the dense smooth open `U ⊆ ℙ²_y`.
  haveI : IsIntegral (ProjectiveSpace 2 k) :=
    isIntegral_of_irreducibleSpace_of_isReduced _
  haveI : IsDomain k := inferInstance
  have htη : t.base (genericPoint T) = genericPoint (ProjectiveSpace 2 k) :=
    apply_genericPoint_eq_of_isDominant t
  have htU : t.base (genericPoint T) ∈ U := by
    rw [htη]
    exact genericPoint_mem_of_dense U hU
  -- Pullback square for `Y = X ×_{ℙ²} T` induces a pullback of fibres.
  let π := biprojectiveZeroLocusSnd 2 2 k F
  have hpb : IsPullback (Limits.pullback.fst π t) (Limits.pullback.snd π t) π t :=
    IsPullback.of_hasPullback π t
  have hfib := isPullback_fiberToSpecResidueField_of_isPullback hpb (genericPoint T)
  -- Specialised fibre equation at the generic point of `ℙ²_y`
  -- (`t(η_T) = genericPoint` by dominance of `t`).
  let j : Fin 3 := 0
  -- Work directly at the generic point so the Q ≠ 0 leaf applies by definition.
  let η : ProjectiveSpace 2 k := genericPoint (ProjectiveSpace 2 k)
  have hη_eq_t : t.base (genericPoint T) = η := htη
  have hη_chart : η ∈ ProjectiveSpace.standardChart 2 k j :=
    BiprojectiveSpace.genericPoint_mem_standardChart' k j
  -- Transport `htU` / Smooth fibre from `t(η_T)` to `η` along `hη_eq_t`.
  have htU' : η ∈ U := by
    rw [← hη_eq_t]; exact htU
  let Q : MvPolynomial (Fin 3) ((ProjectiveSpace 2 k).residueField η) :=
    BiprojectiveSpace.sndResidueFiberPolynomial F η j hη_chart
  have hQ : Q.IsHomogeneous 2 :=
    BiprojectiveSpace.sndResidueFiberPolynomial_isHomogeneous (d := 2) (e := 3) hF η j hη_chart
  -- Smooth of the fibre of `π` at `η ∈ U`.
  haveI hsmFib : Smooth (π.fiberToSpecResidueField η) :=
    smooth_fiberToSpecResidueField_of_mem_smooth_open π U η htU'
  -- Base change of Smooth along the residue-field map.
  -- Fibre of pullback.snd at η_T is Smooth by pullback of Smooth fibre at t(η_T) = η.
  haveI hsmFib_t : Smooth (π.fiberToSpecResidueField (t.base (genericPoint T))) := by
    rw [hη_eq_t]; exact hsmFib
  haveI hsmFibT : Smooth
      ((Limits.pullback.snd π t).fiberToSpecResidueField (genericPoint T)) :=
    MorphismProperty.of_isPullback hfib hsmFib_t
  haveI : Subsingleton (Spec ((T.residueField (genericPoint T)))) := inferInstance
  haveI : IsIntegral (Spec ((T.residueField (genericPoint T)))) := inferInstance
  -- Nonsingularity of Q from Smooth fibre (named leaf).
  -- Specialised Q at the generic point of ℙ² is nonzero (first-block coeffs + generic eval).
  have hQ0 : Q ≠ 0 :=
    BiprojectiveSpace.sndResidueFiberPolynomial_ne_zero_at_generic k F hF hF0 j
  have hnonsing :
      ∀ v : Fin 3 → (ProjectiveSpace 2 k).residueField η, v ≠ 0 →
        MvPolynomial.eval v Q = 0 →
          ∃ i, MvPolynomial.eval v (MvPolynomial.pderiv i Q) ≠ 0 :=
    fun v hv0 hQv =>
      nonsingular_sndResidueFiberPolynomial_of_smooth F hF η j hη_chart hsmFib hQ0 v hv0 hQv
  haveI hDom : IsDomain
      (MvPolynomial (Fin 3) ((ProjectiveSpace 2 k).residueField η) ⧸ Ideal.span {Q}) :=
    isDomain_of_nonsingular_ternary Q hQ hQ0 hnonsing
  -- Geometric integrality of the conic at η, transported across the fibre pullback square.
  haveI hgiη : GeometricallyIntegral (π.fiberToSpecResidueField η) :=
    geometricallyIntegral_fiber_of_smooth_nonsingular_ternary
      F hF η j hη_chart hsmFib hQ0 hnonsing
  haveI hgi_t : GeometricallyIntegral
      (π.fiberToSpecResidueField (t.base (genericPoint T))) := by
    rw [hη_eq_t]
    exact hgiη
  haveI hgiT : GeometricallyIntegral
      ((Limits.pullback.snd π t).fiberToSpecResidueField (genericPoint T)) :=
    MorphismProperty.of_isPullback hfib hgi_t
  haveI : IsIntegral
      ((Limits.pullback.snd π t).fiber (genericPoint T)) := by
    exact GeometricallyIntegral.isIntegral_of_subsingleton
      ((Limits.pullback.snd π t).fiberToSpecResidueField (genericPoint T))
  exact ‹IsIntegral _›

/-- The generic fibre of the conic projection remains integral after pullback
to the generic point of any integral dominant base.  Unlike the preceding
open-restriction theorem, this uses the explicit generic discriminant
calculation and therefore needs no chosen smooth open. -/
theorem isIntegral_genericFiber_pullback_biprojectiveZeroLocusSnd_direct
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T]
    (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t] :
    IsIntegral
      ((Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t).fiber
        (genericPoint T)) := by
  haveI : IsIntegral (ProjectiveSpace 2 k) :=
    isIntegral_of_irreducibleSpace_of_isReduced _
  have htη : t.base (genericPoint T) = genericPoint (ProjectiveSpace 2 k) :=
    apply_genericPoint_eq_of_isDominant t
  let π := biprojectiveZeroLocusSnd 2 2 k F
  have hpb : IsPullback (Limits.pullback.fst π t) (Limits.pullback.snd π t) π t :=
    IsPullback.of_hasPullback π t
  have hfib := isPullback_fiberToSpecResidueField_of_isPullback hpb (genericPoint T)
  let η : ProjectiveSpace 2 k := genericPoint (ProjectiveSpace 2 k)
  have hη_chart : η ∈ ProjectiveSpace.standardChart 2 k (0 : Fin 3) :=
    BiprojectiveSpace.genericPoint_mem_standardChart' k 0
  let A : Type u := (ProjectiveSpace 2 k).residueField η
  letI : Algebra k A := ProjectiveSpace.residueAlgebra 2 k η
  let Q : MvPolynomial (Fin 3) A :=
    BiprojectiveSpace.sndResidueFiberPolynomial F η 0 hη_chart
  have hQ : Q.IsHomogeneous 2 :=
    BiprojectiveSpace.sndResidueFiberPolynomial_isHomogeneous
      (d := 2) (e := 3) hF η 0 hη_chart
  have hQ0 : Q ≠ 0 :=
    BiprojectiveSpace.sndResidueFiberPolynomial_ne_zero_at_generic
      k F hF hF0 0
  let yAlg := ProjectiveSpace.standardChartResidueAlgHom 2 k η 0 hη_chart
  have hyinj : Function.Injective yAlg.toRingHom := by
    change Function.Injective
      (ProjectiveSpace.standardChartResidueRingHom 2 k η 0 hη_chart)
    simpa only [η] using
      (BiprojectiveSpace.standardChartResidueRingHom_injective_generic k 0)
  letI : IsDominant (Spec.map (CommRingCat.ofHom yAlg.toRingHom)) := by
    rw [isDominant_iff]
    refine (PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical yAlg.toRingHom).mpr ?_
    intro x hx
    have hx0 : x = 0 := hyinj (by simpa [RingHom.mem_ker] using hx)
    simp [hx0]
  have hQmap :
      MvPolynomial.map yAlg.toRingHom (genericSndConicChartZero F) = Q := by
    simpa only [Q, yAlg, BiprojectiveSpace.sndResidueFiberPolynomial,
      BiprojectiveSpace.secondNormalizedCoordinates_standardChartResidueAlgHom,
      ProjectiveSpace.algebraMap_residueAlgebra] using
        (map_genericSndConicChartZero F yAlg)
  have hdet : (polarMatrix Q).det ≠ 0 := by
    rw [← hQmap]
    exact det_polarMatrix_map_genericSndConicChartZero_ne_zero F hF hF0 yAlg
  have hnonsing : ∀ v : Fin 3 → A, v ≠ 0 → MvPolynomial.eval v Q = 0 →
      ∃ i, MvPolynomial.eval v (MvPolynomial.pderiv i Q) ≠ 0 := by
    intro v hv0 _
    exact exists_eval_pderiv_ne_zero_of_det_polarMatrix_ne_zero Q hQ hdet v hv0
  have hgiη : GeometricallyIntegral (π.fiberToSpecResidueField η) :=
    geometricallyIntegral_fiber_of_nonsingular_ternary
      F hF η 0 hη_chart hQ0 hnonsing
  have hgi_t : GeometricallyIntegral
      (π.fiberToSpecResidueField (t.base (genericPoint T))) := by
    rw [htη]
    exact hgiη
  have hgiT : GeometricallyIntegral
      ((Limits.pullback.snd π t).fiberToSpecResidueField (genericPoint T)) :=
    MorphismProperty.of_isPullback hfib hgi_t
  haveI : Subsingleton (Spec (T.residueField (genericPoint T))) := inferInstance
  exact GeometricallyIntegral.isIntegral_of_subsingleton
    ((Limits.pullback.snd π t).fiberToSpecResidueField (genericPoint T))

/-- **Subclaim I₂.**  The projection `pullback.snd : Y → T` is dominant.

*Why (classical, dimension bookkeeping).*  A component lying over a proper closed subset `Z ⊊ T`
would have dimension at most `(fibre dimension) + dim Z ≤ 1 + (dim T − 1) = dim T`, while a
hypersurface component in the integral ambient `ℙ²_x × T` has dimension `dim T + 1`.  The
fibre-dimension bound `≤ 1` is `specializeSecondCoordinates_ne_zero_of_smooth_bidegree23`.

*Why (closed proof).*  Ambient smoothness of the bidegree-`(2,3)` threefold makes `π` **surjective**
(`surjective_biprojectiveZeroLocusSnd_of_smooth_bidegree23`).  Surjectivity is stable under base
change, so `pullback.snd π t` is surjective, hence dominant.  This is strictly stronger than
dominance and does not need the dense smooth open `U`.

*Status: closed.* -/
theorem isDominant_pullback_snd_biprojectiveZeroLocusSnd
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t] :
    IsDominant (Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t) := by
  haveI : Surjective (biprojectiveZeroLocusSnd 2 2 k F) :=
    surjective_biprojectiveZeroLocusSnd_of_smooth_bidegree23 k F hF hF0
  infer_instance

/-- A flat family over an integral base is integral as soon as its generic fibre is integral.

The generic-fibre inclusion is scheme-theoretically dominant: the generic-point morphism is
dominant into the reduced base, and scheme-theoretic dominance survives flat base change.  It
therefore both detects nilpotents and has dense image.  Reducedness and irreducibility of the
integral generic fibre consequently descend to the total space.

This is the precise transport theorem needed by the conic-bundle parent.  Unlike the false claim
"dominant + integral generic fibre", flatness rules out components and nilpotents supported over a
proper closed subset of the base. -/
theorem isIntegral_of_flat_of_isIntegral_genericFiber
    {X S : Scheme.{u}} (f : X ⟶ S) [Flat f] [IsIntegral S]
    (hη : IsIntegral (f.fiber (genericPoint S))) :
    IsIntegral X := by
  let η : S := genericPoint S
  let g : Spec (S.residueField η) ⟶ S := S.fromSpecResidueField η
  haveI hqc_g : QuasiCompact g :=
    ⟨fun _ _ _ ↦ (Set.toFinite _).isCompact⟩
  haveI hdom_g : IsDominant g := by
    rw [isDominant_iff, DenseRange, Scheme.range_fromSpecResidueField,
      dense_iff_closure_eq]
    exact (genericPoint_spec S).def
  haveI hstd_g : IsSchemeTheoreticallyDominant g :=
    IsSchemeTheoreticallyDominant.of_isDominant g
  let p : pullback f g ⟶ X := pullback.fst f g
  haveI hp_std : IsSchemeTheoreticallyDominant p := by
    dsimp only [p]
    infer_instance
  haveI hp_qc : QuasiCompact p := by
    dsimp only [p]
    infer_instance
  haveI hp_dom : IsDominant p := inferInstance
  haveI hfib_int : IsIntegral (pullback f g) := by
    change IsIntegral (f.fiber (genericPoint S))
    exact hη
  haveI hred : IsReduced X :=
    IsSchemeTheoreticallyDominant.isReduced p
  haveI hirr : IrreducibleSpace X := by
    have hdense : DenseRange p.base := IsDominant.denseRange (f := p)
    have huniv : IsIrreducible
        (Set.univ : Set (Limits.pullback (C := Scheme.{u}) f g)) :=
      IrreducibleSpace.isIrreducible_univ _
    have hrange : IsIrreducible (Set.range ⇑p.base) := by
      simpa [Set.image_univ] using
        huniv.image (⇑p.base) (Scheme.Hom.continuous p).continuousOn
    have hclosure : IsIrreducible (closure (Set.range ⇑p.base)) := hrange.closure
    rw [hdense.closure_range] at hclosure
    exact
      { toPreirreducibleSpace := ⟨hclosure.2⟩
        toNonempty := ⟨hclosure.1.choose⟩ }
  exact isIntegral_of_irreducibleSpace_of_isReduced X

/-- **Subclaim I₃** (strengthened, Mathlib-backed).

If `f : Y → T` is geometrically integral, flat and universally open over an integral locally
Noetherian base, then `Y` is integral.

This is exactly `GeometricallyIntegral.isIntegral_of_isLocallyNoetherian`.  The older claim
"dominant + integral generic fibre ⇒ integral total space" is **false** (counterexample
`𝔸¹ ⊔ {pt} → 𝔸¹`) and is not used by the parent.

The optional `[IsDominant f]` and `hη` hypotheses are retained for readability; both follow
from `GeometricallyIntegral` (surjectivity, and integrality of every fibre).

*Status: closed.* -/
theorem isIntegral_of_isDominant_of_isIntegral_genericFiber
    {Y T : Scheme.{u}} (f : Y ⟶ T)
    [GeometricallyIntegral f] [Flat f] [UniversallyOpen f]
    [IsIntegral T] [IsLocallyNoetherian T]
    [IsDominant f]
    (hη : IsIntegral (f.fiber (genericPoint T))) :
    IsIntegral Y := by
  -- `hη` / `[IsDominant f]` follow from GI; Mathlib needs the flat package.
  have := hη
  exact GeometricallyIntegral.isIntegral_of_isLocallyNoetherian f

/--
**The base change of the conic bundle to an integral base is integral.**

*Why it is true.*  The projection `π : X → ℙ²_y` is flat.  Chartwise, its equation is a primitive
binary polynomial over the affine base chart: if its coefficients generated a proper ideal, the
Nullstellensatz would produce a base point at which the entire homogeneous conic vanishes,
contradicting ambient smoothness.  The primitive-hypersurface quotient theorem gives flatness of
each chart map, and Zariski-local assembly gives flatness of `π`.  Flatness survives the base
change to `T`.

Dominance of `t` identifies the image of the generic point of `T` with the generic point of
`ℙ²_y`.  The explicit generic discriminant calculation makes that ternary conic geometrically
integral, hence its pullback to the residue field of `T` is integral.  Finally,
`isIntegral_of_flat_of_isIntegral_genericFiber` transports reducedness and irreducibility from the
integral generic fibre through the flat family, proving that the total pullback `Y` is integral.

*Why integral and not merely irreducible.*  Integrality is what lets the chart leaf drop two of its
four conditions: an open subscheme of an integral scheme is integral, so the affine model's
coordinate ring is automatically a domain, and so is the base ring `A`.

No local-Noetherian hypothesis on `T` is needed.  The proof uses flatness plus one integral generic
fibre, rather than global geometric integrality of the family.

*Not decoration.*  Without `[Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]` this is **false**: see
the counterexample `F = Y₀³ (X₀X₁ − X₂²)` in the module docstring, where `Y` acquires the vertical
component `ℙ²_x × {Y₀ = 0}`.
-/
theorem isIntegral_pullback_biprojectiveZeroLocusSnd
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t] :
    IsIntegral (Limits.pullback (C := Scheme.{u}) (biprojectiveZeroLocusSnd 2 2 k F) t) := by
  let π := biprojectiveZeroLocusSnd 2 2 k F
  haveI hπflat : Flat π :=
    flat_biprojectiveZeroLocusSnd_of_smooth_bidegree23 F hF hF0
  haveI hpullFlat : Flat (Limits.pullback.snd π t) := by infer_instance
  apply isIntegral_of_flat_of_isIntegral_genericFiber
    (Limits.pullback.snd π t)
  exact isIntegral_genericFiber_pullback_biprojectiveZeroLocusSnd_direct
    F hF hF0 t

/-! #### Chart computation: classical content and interface subclaims

**The chart computation** (source §4–§5; `PLAN.md` WP-3e): the pointed affine conic sits inside the
base change as an open subscheme.  There are a ring `A`, a dominant open immersion
`ψ : Spec A ⟶ T`, a binary polynomial `g` of total degree `≤ 2` and a point `(p₁, p₂)` on `V(g)`,
with nonzero slope polynomials at the marked point, together with an open immersion of that conic
over `Spec A` into `X ×_{ℙ²_y} T` over `T`.

Neither `A` nor the conic ring has to be shown to be a domain: both are derived in
`exists_pointedConicAffineModel` from integrality of the base change.

The leaf `exists_chartEquation_openImmersion` is reduced to four named subclaims C₁–C₄ below.
Steps 1–5 of the classical route (chart identification, open immersion of the chart, base change
of open immersions, factoring through the `y`-chart, and shrinking to an affine base) are
discharged by existing declarations; what remains is the tree-specific interface between those
declarations and the two nondegeneracy conditions.  Full classical route is recorded in the
docstring of `exists_chartEquation_openImmersion` itself.
-/

/-- **Subclaim C₁.**  After shrinking to a dense affine open `Spec A ⊆ T` on which `t` lands in the
`j`-th chart of `ℙ²_y`, the composite `ψ ≫ t` factors through `standardChartι 2 k j`.

*Pattern.*  `standardChartResidueLift` (`BiprojectiveFiberEquationBaseChange.lean`) is the same
lift for a residue-field point; here the source is an arbitrary affine open of `T` whose image
under `t` lands in the chart.  The proof is `IsOpenImmersion.lift` applied to
`standardChartι`, once the range inclusion is read off from
`Set.range ψ.base ⊆ t ⁻¹ᵁ (… ⊓ standardChart …)`.

*Status: leaf of pure plumbing.* -/
theorem exists_standardChart_factor
    {k : Type u} [Field k]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (j : Fin 3) :
    ∃ (A : Type u) (_ : CommRing A) (ψ : Spec (CommRingCat.of A) ⟶ T)
      (_ : IsOpenImmersion ψ) (_ : IsDominant ψ)
      (φ : Spec (CommRingCat.of A) ⟶
        Spec (.of (ProjectiveSpace.StandardChartRing 2 k j))),
      ψ ≫ t = φ ≫ ProjectiveSpace.standardChartι 2 k j ∧
        Set.range ψ.base ⊆
          ((t ⁻¹ᵁ (U ⊓ ProjectiveSpace.standardChart 2 k j) : T.Opens) : Set T) := by
  obtain ⟨A, instCR, ψ, hOI, hDom, hrange⟩ := exists_affine_base_of_chart t U hU j
  letI := instCR
  haveI := hOI
  haveI := hDom
  -- Range of `ψ ≫ t` lands in the `j`-th chart, so `IsOpenImmersion.lift` factors it.
  have hsub : Set.range (ψ ≫ t) ⊆ Set.range (ProjectiveSpace.standardChartι 2 k j) := by
    intro y hy
    obtain ⟨x, rfl⟩ := hy
    have hxT : ψ.base x ∈
        ((t ⁻¹ᵁ (U ⊓ ProjectiveSpace.standardChart 2 k j) : T.Opens) : Set T) :=
      hrange ⟨x, rfl⟩
    have hyU : t.base (ψ.base x) ∈
        ((U ⊓ ProjectiveSpace.standardChart 2 k j : (ProjectiveSpace 2 k).Opens) :
          Set (ProjectiveSpace 2 k)) := hxT
    have hyChart : t.base (ψ.base x) ∈
        (ProjectiveSpace.standardChart 2 k j : Set (ProjectiveSpace 2 k)) :=
      (Set.mem_inter_iff _ _ _).mp hyU |>.2
    rw [← Scheme.Hom.coe_opensRange, ProjectiveSpace.opensRange_standardChartι]
    -- `(ψ ≫ t).base x = t.base (ψ.base x)` definitionally after unfolding
    simpa [Scheme.Hom.comp_base] using hyChart
  refine ⟨A, instCR, ψ, hOI, hDom,
    IsOpenImmersion.lift (ProjectiveSpace.standardChartι 2 k j) (ψ ≫ t) hsub, ?_, hrange⟩
  exact (IsOpenImmersion.lift_fac (ProjectiveSpace.standardChartι 2 k j) (ψ ≫ t) hsub).symm

/-! ### Degree of the base-changed chart equation

The base-changed chart equation is `aeval` of the dehomogenized Cox coordinates, so left
weighted-homogeneity of `F` of degree 2 yields total degree `≤ 2` in the affine `x`-variables.
-/

open TensorProduct Finsupp

/-- Dehomogenized Cox-coordinate values after base-changing the second chart. -/
noncomputable def baseChangedChartVariable
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A) :
    BiprojectiveCoordinate 2 2 → MvPolynomial (Fin 2) A
  | .inl l => i.succAboveCases (1 : MvPolynomial (Fin 2) A) (fun r => X r) l
  | .inr l => C (y (ProjectiveSpace.normalizedCoordinate 2 k j l))

private theorem succAboveCases_X_mv
    {A : Type u} [CommRing A] (i : Fin 3) (r : Fin 2) :
    i.succAboveCases (1 : MvPolynomial (Fin 2) A) (fun s => (X s : MvPolynomial (Fin 2) A))
      (i.succAbove r) = (X r : MvPolynomial (Fin 2) A) := by
  simp only [Fin.succAboveCases, dif_neg (Fin.succAbove_ne i r),
    Fin.succAbove_lt_iff_castSucc_lt]
  split_ifs with hlt
  · generalize_proofs H₁ H₂; revert H₂
    generalize hk : Fin.castPred (i.succAbove r) H₁ = k'
    rw [Fin.castPred_succAbove r i hlt] at hk; cases hk; intro; rfl
  · generalize_proofs H₀ H₁ H₂; revert H₂
    generalize hk : Fin.pred (i.succAbove r) H₁ = k'
    rw [Fin.pred_succAbove r i (Fin.not_lt.1 hlt)] at hk; cases hk; intro; rfl

private theorem tensor_norm_succAbove_mv
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i : Fin 3) (r : Fin 2) :
    tensorStandardChartEquivMvPolynomial 2 k A i
        ((1 : A) ⊗ₜ[k] ProjectiveSpace.normalizedCoordinate 2 k i (i.succAbove r)) =
      (X r : MvPolynomial (Fin 2) A) := by
  change (algebraTensorAlgEquiv k A)
      ((Algebra.TensorProduct.congr (AlgEquiv.refl (R := k) (A₁ := A))
        (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i))
        ((1 : A) ⊗ₜ[k] ProjectiveSpace.normalizedCoordinate 2 k i (i.succAbove r))) = X r
  rw [Algebra.TensorProduct.congr_apply, Algebra.TensorProduct.map_tmul]
  convert algebraTensorAlgEquiv_tmul (R := k) (A := A) (1 : A)
    (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i
      (ProjectiveSpace.normalizedCoordinate 2 k i (i.succAbove r))) using 2
  · simp
  · rw [ProjectiveSpace.standardChartRingEquivMvPolynomial_normalizedCoordinate_succAbove]
    simp [map_X, one_smul]

private theorem baseChangedChartEquation_C
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A) (r : k) :
    baseChangedChartEquation (i := i) y (C r) = C (algebraMap k A r) := by
  unfold baseChangedChartEquation
  have hce : chartEquation 2 2 k i j (C r) =
      algebraMap k (StandardChartRing 2 2 k i j) r := by
    simp [chartEquation, chartEvaluation]
  rw [hce]
  have hsf : sndFiberChartMap (i := i) y
        (algebraMap k (StandardChartRing 2 2 k i j) r) =
      algebraMap A (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k i)
        (algebraMap k A r) := by
    rw [Algebra.TensorProduct.algebraMap_apply
      (A := ProjectiveSpace.StandardChartRing 2 k i)
      (B := ProjectiveSpace.StandardChartRing 2 k j)]
    rw [sndFiberChartMap_tmul, map_one]
    rw [← IsScalarTower.algebraMap_apply k A
      (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k i) r]
    rw [Algebra.TensorProduct.algebraMap_apply]
    simp only [Algebra.algebraMap_eq_smul_one]
    rw [smul_tmul, tmul_smul]
  rw [hsf, AlgEquiv.commutes]; rfl

private theorem baseChangedChartEquation_X_inl
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A) (l : Fin 3) :
    baseChangedChartEquation (i := i) y (X (.inl l)) =
      baseChangedChartVariable i j y (.inl l) := by
  unfold baseChangedChartEquation
  have : chartEquation 2 2 k i j (X (.inl l)) = chartVariable 2 2 k i j (.inl l) := by
    simp [chartEquation, chartEvaluation, aeval_X]
  rw [this, chartVariable_inl, sndFiberChartMap_tmul]
  have hy1 : y (1 : ProjectiveSpace.StandardChartRing 2 k j) ⊗ₜ[k]
      ProjectiveSpace.normalizedCoordinate 2 k i l =
    (1 : A) ⊗ₜ[k] ProjectiveSpace.normalizedCoordinate 2 k i l := by simp
  rw [hy1]
  rcases Fin.eq_self_or_eq_succAbove i l with h | ⟨r, h⟩
  · rw [h]
    change tensorStandardChartEquivMvPolynomial 2 k A i
        ((1 : A) ⊗ₜ[k] ProjectiveSpace.normalizedCoordinate 2 k i i) =
      i.succAboveCases (1 : MvPolynomial (Fin 2) A) (fun r => X r) i
    rw [ProjectiveSpace.normalizedCoordinate_self]
    have h1 : ((1 : A) ⊗ₜ[k] (1 : ProjectiveSpace.StandardChartRing 2 k i)) =
      algebraMap A _ (1 : A) := by rw [Algebra.TensorProduct.algebraMap_apply]; simp
    rw [h1, AlgEquiv.commutes, map_one]
    simp only [Fin.succAboveCases, ↓reduceDIte]
  · rw [h]
    change tensorStandardChartEquivMvPolynomial 2 k A i
        ((1 : A) ⊗ₜ[k]
          ProjectiveSpace.normalizedCoordinate 2 k i (i.succAbove r)) =
      i.succAboveCases (1 : MvPolynomial (Fin 2) A) (fun s => X s) (i.succAbove r)
    rw [succAboveCases_X_mv, tensor_norm_succAbove_mv]

private theorem baseChangedChartEquation_X_inr
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A) (l : Fin 3) :
    baseChangedChartEquation (i := i) y (X (.inr l)) =
      baseChangedChartVariable i j y (.inr l) := by
  unfold baseChangedChartEquation baseChangedChartVariable
  have : chartEquation 2 2 k i j (X (.inr l)) = chartVariable 2 2 k i j (.inr l) := by
    simp [chartEquation, chartEvaluation, aeval_X]
  rw [this, chartVariable_inr, sndFiberChartMap_tmul]
  have : y (ProjectiveSpace.normalizedCoordinate 2 k j l) ⊗ₜ[k]
      (1 : ProjectiveSpace.StandardChartRing 2 k i) =
    algebraMap A (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k i)
      (y (ProjectiveSpace.normalizedCoordinate 2 k j l)) := by
    rw [Algebra.TensorProduct.algebraMap_apply]; simp
  rw [this, AlgEquiv.commutes]; rfl

private theorem baseChangedChartEquation_eq_aeval
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    baseChangedChartEquation (i := i) y F =
      aeval (baseChangedChartVariable i j y) F := by
  let φR : MvPolynomial (BiprojectiveCoordinate 2 2) k →+* MvPolynomial (Fin 2) A :=
    (tensorStandardChartEquivMvPolynomial 2 k A i).toRingHom.comp
      ((sndFiberChartMap (i := i) y).toRingHom.comp
        (chartEvaluation 2 2 k i j).toRingHom)
  have hφ : ∀ p, φR p = baseChangedChartEquation (i := i) y p := fun _ => rfl
  have : φR = (aeval (baseChangedChartVariable i j y)).toRingHom := by
    refine MvPolynomial.ringHom_ext ?_ ?_
    · intro r
      rw [hφ, baseChangedChartEquation_C]
      change C (algebraMap k A r) =
        (aeval (baseChangedChartVariable i j y)).toRingHom (C r)
      rw [AlgHom.toRingHom_eq_coe, AlgHom.coe_toRingHom, aeval_C]; rfl
    · intro z
      rw [hφ, AlgHom.toRingHom_eq_coe, AlgHom.coe_toRingHom, aeval_X]
      cases z with
      | inl l => exact baseChangedChartEquation_X_inl i j y l
      | inr l => exact baseChangedChartEquation_X_inr i j y l
  simpa [hφ] using congrFun (congrArg DFunLike.coe this) F

/-! ### Coefficient identification for C₄

The base-changed chart equation is `map y` of the universal left-dehomogenization over the
`y`-chart ring.  Quadratic coefficients therefore pull back along the dominant (hence injective)
chart map `y`, and the pure-`Xᵢ`-free part of a bidegree-`(2,3)` form is recovered as the
homogeneous quadratic part.
-/

/-- Universal (pre-`y`) dehomogenized Cox coordinates on the `i`-th `x`-chart, with right
coordinates still in the `j`-th chart ring. -/
noncomputable def universalBaseChangedChartVariable
    {k : Type u} [CommRing k] (i j : Fin 3) :
    BiprojectiveCoordinate 2 2 → MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j)
  | .inl l => i.succAboveCases (1 : MvPolynomial (Fin 2)
      (ProjectiveSpace.StandardChartRing 2 k j)) (fun r => X r) l
  | .inr l => C (ProjectiveSpace.normalizedCoordinate 2 k j l)

private theorem map_universalBaseChangedChartVariable
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A)
    (z : BiprojectiveCoordinate 2 2) :
    map y.toRingHom (universalBaseChangedChartVariable i j z) =
      baseChangedChartVariable i j y z := by
  match z with
  | .inl l =>
      dsimp only [universalBaseChangedChartVariable, baseChangedChartVariable]
      rcases Fin.eq_self_or_eq_succAbove i l with h | ⟨r, h⟩
      · subst h
        simp only [Fin.succAboveCases, ↓reduceDIte, map_one]
      · subst h
        rw [succAboveCases_X_mv, succAboveCases_X_mv, map_X]
  | .inr l =>
      simp only [universalBaseChangedChartVariable, baseChangedChartVariable, map_C]
      rfl

private theorem baseChangedChartEquation_eq_map_universal
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    baseChangedChartEquation (i := i) y F =
      map y.toRingHom (aeval (universalBaseChangedChartVariable i j) F) := by
  rw [baseChangedChartEquation_eq_aeval]
  have hcomp :
      (mapAlgHom y).comp (aeval (universalBaseChangedChartVariable i j)) =
        aeval (baseChangedChartVariable i j y) := by
    refine MvPolynomial.algHom_ext fun z => ?_
    simp only [AlgHom.comp_apply, aeval_X, mapAlgHom_apply]
    exact map_universalBaseChangedChartVariable i j y z
  have := congrArg (fun (f : MvPolynomial (BiprojectiveCoordinate 2 2) k →ₐ[k]
      MvPolynomial (Fin 2) A) => f F) hcomp
  simpa [mapAlgHom_apply] using this.symm

/-- The part of `F` not divisible by `Xᵢ`, still bihomogeneous of the same bidegree. -/
private theorem isBihomogeneous_modMonomial_X_inl
    {k : Type u} [CommRing k] {a b : ℕ}
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBihomogeneousOfBidegree a b F) (i : Fin 3) :
    IsBihomogeneousOfBidegree a b
      (modMonomial F (Finsupp.single (Sum.inl i : BiprojectiveCoordinate 2 2) 1)) := by
  intro d hd
  have hdi : ¬ Finsupp.single (Sum.inl i : BiprojectiveCoordinate 2 2) 1 ≤ d := by
    intro hle
    have : coeff d
        (modMonomial F (Finsupp.single (Sum.inl i : BiprojectiveCoordinate 2 2) 1)) = 0 :=
      coeff_modMonomial_of_le F hle
    exact hd this
  have hcoeff : coeff d F ≠ 0 := by
    rwa [coeff_modMonomial_of_not_le F hdi] at hd
  exact hF hcoeff

/-- Support-wise total-degree bound for the base-changed chart equation. -/
theorem baseChangedChartEquation_support_degree_le
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBihomogeneousOfBidegree 2 3 F) :
    ∀ d ∈ (baseChangedChartEquation (i := i) y F).support, d 0 + d 1 ≤ 2 := by
  intro d hd
  rw [baseChangedChartEquation_eq_aeval] at hd
  let v := baseChangedChartVariable i j y
  have hv : ∀ z, (v z).HasWeightedDegreeLE (fun _ : Fin 2 => 1) (leftDegreeWeight z) := by
    intro z
    match z with
    | .inl l =>
        dsimp only [v, baseChangedChartVariable, leftDegreeWeight]
        rcases Fin.eq_self_or_eq_succAbove i l with h | ⟨r, h⟩
        · rw [h]; simp only [Fin.succAboveCases, ↓reduceDIte]
          exact (HasWeightedDegreeLE.C (σ := Fin 2) (fun _ => (1 : ℕ)) (1 : A)).mono
            (Nat.zero_le 1)
        · rw [h, succAboveCases_X_mv]
          exact (isWeightedHomogeneous_X (R := A)
            (fun _ : Fin 2 => (1 : ℕ)) r).hasWeightedDegreeLE
    | .inr l =>
        dsimp only [v, baseChangedChartVariable, leftDegreeWeight]
        exact HasWeightedDegreeLE.C (σ := Fin 2) (fun _ => (1 : ℕ)) _
  have hF' : (aeval v F).HasWeightedDegreeLE (fun _ : Fin 2 => 1) 2 :=
    hF.isWeightedHomogeneous_left.aeval_hasWeightedDegreeLE (fun _ => 1) v hv
  have hle := le_totalDegree hd
  have htd : (aeval v F).totalDegree ≤ 2 := by
    have hw := hF'.weightedTotalDegree_le
    convert hw
    unfold totalDegree weightedTotalDegree
    congr 1; ext s
    simp only [weight_apply, Finsupp.sum, nsmul_eq_mul, mul_one, Nat.cast_id]
  have hsum : (d.sum fun _ e => e) = d 0 + d 1 := by
    change (∑ i ∈ d.support, d i) = d 0 + d 1
    rw [← degree_apply d, degree_eq_sum, Fin.sum_univ_two]
  calc d 0 + d 1 = d.sum (fun _ e => e) := hsum.symm
    _ ≤ (aeval v F).totalDegree := hle
    _ ≤ 2 := htd

set_option backward.isDefEq.respectTransparency false

/-- Product standard chart range is the product of the factor chart ranges. -/
theorem range_standardChartι (k : Type u) [CommRing k] (i j : Fin 3) :
    Set.range (standardChartι 2 2 k i j) =
      fst 2 2 k ⁻¹' Set.range (ProjectiveSpace.standardChartι 2 k i) ∩
        snd 2 2 k ⁻¹' Set.range (ProjectiveSpace.standardChartι 2 k j) := by
  have h := Scheme.Pullback.range_map
    (ProjectiveSpace.standardChartι 2 k i ≫ ProjectiveSpace.toSpec 2 k)
    (ProjectiveSpace.standardChartι 2 k j ≫ ProjectiveSpace.toSpec 2 k)
    (ProjectiveSpace.toSpec 2 k) (ProjectiveSpace.toSpec 2 k)
    (ProjectiveSpace.standardChartι 2 k i)
    (ProjectiveSpace.standardChartι 2 k j) (𝟙 _)
    (by simp) (by simp)
  convert h using 1
  dsimp only [standardChartι, standardOpenCover]
  simp only [Scheme.Pullback.openCoverOfLeftRight_f]
  rfl

-- Subclaim C2: chart quotient pasting with range inclusion for the multisection.
-- Heavy chart/quotient pasting plus range identification for the section.
set_option maxHeartbeats 2000000 in
theorem exists_chartQuotient_openImmersion
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (_hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t)
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (i j : Fin 3)
    (hi : (((s.toTotal ≫ biprojectiveZeroLocusFst 2 2 k F) ⁻¹ᵁ
        ProjectiveSpace.standardChart 2 k i : T.Opens) : Set T).Nonempty) :
    ∃ (A : Type u) (_ : CommRing A) (_ : Algebra k A) (g : MvPolynomial (Fin 2) A)
      (_ : ∀ d ∈ g.support, d 0 + d 1 ≤ 2)
      (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A)
      (_ : IsDominant (Spec.map (CommRingCat.ofHom y.toRingHom)))
      (_ : g = baseChangedChartEquation (i := i) y F)
      (ψ : Spec (CommRingCat.of A) ⟶ T) (_ : IsOpenImmersion ψ) (_ : IsDominant ψ)
      (r : Spec (CommRingCat.of (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})) ⟶
        Limits.pullback (biprojectiveZeroLocusSnd 2 2 k F) t) (_ : IsOpenImmersion r),
      r ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t =
        Spec.map (CommRingCat.ofHom
          ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ≫ ψ ∧
      Set.range ψ.base ⊆
          ((t ⁻¹ᵁ (U ⊓ ProjectiveSpace.standardChart 2 k j) ⊓
              (s.toTotal ≫ biprojectiveZeroLocusFst 2 2 k F) ⁻¹ᵁ
                ProjectiveSpace.standardChart 2 k i : T.Opens) : Set T) ∧
      Set.range (ψ ≫ s.σ).base ⊆ Set.range r.base := by
  obtain ⟨A, instCR, ψ, hOI, hDom, hrange⟩ :=
    exists_affine_base_of_chart_section F t s U hU i j hi
  letI := instCR
  haveI := hOI
  haveI := hDom
  -- Factor `ψ ≫ t` through the `j`-th standard chart (as in C₁).
  have hsub : Set.range (ψ ≫ t) ⊆ Set.range (ProjectiveSpace.standardChartι 2 k j) := by
    intro y hy
    obtain ⟨x, rfl⟩ := hy
    have hxT : ψ.base x ∈
        ((t ⁻¹ᵁ (U ⊓ ProjectiveSpace.standardChart 2 k j) ⊓
            (s.toTotal ≫ biprojectiveZeroLocusFst 2 2 k F) ⁻¹ᵁ
              ProjectiveSpace.standardChart 2 k i : T.Opens) : Set T) :=
      hrange ⟨x, rfl⟩
    have hyU : t.base (ψ.base x) ∈
        ((U ⊓ ProjectiveSpace.standardChart 2 k j :
          (ProjectiveSpace 2 k).Opens) : Set (ProjectiveSpace 2 k)) :=
      (Set.mem_inter_iff _ _ _).mp hxT |>.1
    have hyChart : t.base (ψ.base x) ∈
        (ProjectiveSpace.standardChart 2 k j : Set (ProjectiveSpace 2 k)) :=
      (Set.mem_inter_iff _ _ _).mp hyU |>.2
    rw [← Scheme.Hom.coe_opensRange, ProjectiveSpace.opensRange_standardChartι]
    simpa [Scheme.Hom.comp_base] using hyChart
  let φ : Spec (CommRingCat.of A) ⟶
      Spec (.of (ProjectiveSpace.StandardChartRing 2 k j)) :=
    IsOpenImmersion.lift (ProjectiveSpace.standardChartι 2 k j) (ψ ≫ t) hsub
  have hφ : ψ ≫ t = φ ≫ ProjectiveSpace.standardChartι 2 k j :=
    (IsOpenImmersion.lift_fac (ProjectiveSpace.standardChartι 2 k j) (ψ ≫ t) hsub).symm
  letI algA : Algebra k A :=
    RingHom.toAlgebra
      ((Spec.preimage φ).hom.comp
        (algebraMap k (ProjectiveSpace.StandardChartRing 2 k j)))
  let y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A :=
    { (Spec.preimage φ).hom with
      commutes' := fun r => by
        change (Spec.preimage φ).hom (algebraMap k _ r) =
          ((Spec.preimage φ).hom.comp
            (algebraMap k (ProjectiveSpace.StandardChartRing 2 k j))) r
        rfl }
  have hφ_eq : φ = Spec.map (CommRingCat.ofHom y.toRingHom) := by
    have h : CommRingCat.ofHom y.toRingHom = Spec.preimage φ := by
      ext x; rfl
    rw [h, Spec.map_preimage]
  haveI : IsDominant (ψ ≫ t) := inferInstance
  haveI : IsDominant (Spec.map (CommRingCat.ofHom y.toRingHom)) := by
    rw [← hφ_eq]
    exact IsDominant.of_comp_of_isOpenImmersion φ
      (ProjectiveSpace.standardChartι 2 k j) (H := by rwa [← hφ])
  let I : Ideal (StandardChartRing 2 2 k i j) :=
    Ideal.span {chartEquation 2 2 k i j F}
  let q := sndFiberChartMap (i := i) y (chartEquation 2 2 k i j F)
  let g : MvPolynomial (Fin 2) A := baseChangedChartEquation (i := i) y F
  have hg : g = baseChangedChartEquation (i := i) y F := rfl
  have hImap : I.map (sndFiberChartMap (i := i) y).toRingHom = Ideal.span {q} :=
    map_span_chartEquation_eq_span_sndFiber y F
  have hdeg : ∀ d ∈ g.support, d 0 + d 1 ≤ 2 :=
    baseChangedChartEquation_support_degree_le i j y F hF
  have hpb0 := isPullback_SpecMap_chartQuotient (R := k) (K := A) (i := i) (j := j) y I
  haveI : Mono (ProjectiveSpace.standardChartι 2 k j) := inferInstance
  have hpb1 := Scheme.isPullback_comp_mono hpb0 (ProjectiveSpace.standardChartι 2 k j)
  have hyt : Spec.map (CommRingCat.ofHom y.toRingHom) ≫
      ProjectiveSpace.standardChartι 2 k j = ψ ≫ t := by
    rw [← hφ_eq, ← hφ]
  let eRing := standardChartQuotientEquivAffineQuotient (R := k) (i := i) (j := j) F
  let c : Spec (CommRingCat.of (StandardChartRing 2 2 k i j ⧸ I)) ⟶
      biprojectiveZeroLocus 2 2 k F :=
    Spec.map eRing.symm.toCommRingCatIso.hom ≫
      (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv ≫
        chartZeroLocusToGlobal 2 2 k F hF i j
  haveI : IsOpenImmersion c := by dsimp [c]; infer_instance
  have hcπ : c ≫ biprojectiveZeroLocusSnd 2 2 k F =
      Spec.map
          (CommRingCat.ofHom
              (Algebra.TensorProduct.includeRight
                  (R := k)
                  (A := ProjectiveSpace.StandardChartRing 2 k i)
                  (B := ProjectiveSpace.StandardChartRing 2 k j)).toRingHom ≫
                CommRingCat.ofHom (Ideal.Quotient.mk I)) ≫
        ProjectiveSpace.standardChartι 2 k j := by
    dsimp [c]
    convert chartQuotient_to_projective_eq (i := i) (j := j) F hF using 1
    · simp only [Category.assoc]; rfl
    · rfl
  have hpb2 : IsPullback
      (Spec.map
        (CommRingCat.ofHom
          (Algebra.TensorProduct.includeLeftRingHom
              (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i)) ≫
            CommRingCat.ofHom
              (Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) y).toRingHom))))
      (Spec.map
        (CommRingCat.ofHom
          (Ideal.Quotient.lift I
            ((Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) y).toRingHom)).comp
              (sndFiberChartMap (i := i) y).toRingHom)
            (fun _ ha => Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_map_of_mem _ ha)))))
      (ψ ≫ t)
      (c ≫ biprojectiveZeroLocusSnd 2 2 k F) := by
    rw [← hyt, hcπ]
    exact hpb1
  have hpb3 := hpb2.flip
  -- Explicit open immersion into the base change (same construction as
  -- `exists_isOpenImmersion_to_pullback`), so the range formula is available.
  let πX := biprojectiveZeroLocusSnd 2 2 k F
  let rmap :=
    pullback.map (c ≫ πX) (ψ ≫ t) πX t c ψ (𝟙 _) (by simp) (by simp)
  let r0 := hpb3.isoPullback.hom ≫ rmap
  haveI : IsOpenImmersion r0 := by dsimp [r0, rmap]; infer_instance
  have hr0 : r0 ≫ Limits.pullback.snd πX t =
      Spec.map
          (CommRingCat.ofHom
            (Algebra.TensorProduct.includeLeftRingHom
                (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i)) ≫
              CommRingCat.ofHom
                (Ideal.Quotient.mk
                  (I.map (sndFiberChartMap (i := i) y).toRingHom))) ≫
        ψ := by
    dsimp [r0, rmap]
    rw [Category.assoc, Limits.pullback.lift_snd, ← Category.assoc,
      hpb3.isoPullback_hom_snd]
    rfl
  have hr0_range : Set.range r0 =
      pullback.fst πX t ⁻¹' Set.range c ∩
        pullback.snd πX t ⁻¹' Set.range ψ := by
    simpa [r0, rmap] using Scheme.range_isOpenImmersion_to_pullback πX t c ψ hpb3
  let eW := conicChartQuotientEquivMvPolynomial 2 k A i q
  let eI := Ideal.quotEquivOfEq hImap
  let eFull := eI.trans eW.toRingEquiv
  let r : Spec (CommRingCat.of (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})) ⟶
      Limits.pullback (biprojectiveZeroLocusSnd 2 2 k F) t :=
    Spec.map eFull.toCommRingCatIso.hom ≫ r0
  haveI : IsOpenImmersion r := by dsimp [r]; infer_instance
  have hr : r ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t =
      Spec.map (CommRingCat.ofHom
        ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ≫ ψ := by
    dsimp [r]
    rw [Category.assoc, hr0, ← Category.assoc]
    congr 1
    rw [← Spec.map_comp]
    congr 1
    ext a
    change eFull
        (Ideal.Quotient.mk (I.map (sndFiberChartMap (i := i) y).toRingHom)
          (Algebra.TensorProduct.includeLeftRingHom
            (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i) a)) =
      Ideal.Quotient.mk (Ideal.span {g}) (C a)
    have hinc :
        Algebra.TensorProduct.includeLeftRingHom
          (R := k) (A := A) (B := ProjectiveSpace.StandardChartRing 2 k i) a =
        algebraMap A (A ⊗[k] ProjectiveSpace.StandardChartRing 2 k i) a := rfl
    rw [hinc]
    change eW (eI (Ideal.Quotient.mk _ (algebraMap A _ a))) =
      Ideal.Quotient.mk (Ideal.span {g}) (C a)
    have heI : eI (Ideal.Quotient.mk _ (algebraMap A _ a)) =
        Ideal.Quotient.mk (Ideal.span {q}) (algebraMap A _ a) := by
      simp [eI, Ideal.quotEquivOfEq_mk]
    rw [heI]
    have hcomm := eW.commutes a
    convert hcomm
    · rfl
    · change Ideal.Quotient.mk (Ideal.span {g}) (C a) =
        algebraMap A
          (MvPolynomial (Fin 2) A ⧸
            Ideal.span {tensorStandardChartEquivMvPolynomial 2 k A i q}) a
      rfl
  -- `eFull` is an iso, so `range r = range r0`.
  have hr_range : Set.range r = Set.range r0 := by
    haveI : Surjective (Spec.map eFull.toCommRingCatIso.hom) := inferInstance
    have hiso : Function.Surjective (Spec.map eFull.toCommRingCatIso.hom) :=
      Scheme.Hom.surjective _
    change Set.range ((r0 : _ → _) ∘ (Spec.map eFull.toCommRingCatIso.hom : _ → _)) = _
    exact Function.Surjective.range_comp hiso _
  -- Chart open of `X`: `range c = range chartZeroLocusToGlobal`.
  have hc_range : Set.range c =
      Set.range (chartZeroLocusToGlobal 2 2 k F hF i j) := by
    dsimp [c]
    haveI : Surjective (Spec.map eRing.symm.toCommRingCatIso.hom) := inferInstance
    haveI : Surjective (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv :=
      inferInstance
    have h1 : Function.Surjective
        (Spec.map eRing.symm.toCommRingCatIso.hom) :=
      Scheme.Hom.surjective _
    have h2 : Function.Surjective
        (chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv :=
      Scheme.Hom.surjective _
    change Set.range
        (((chartZeroLocusToGlobal 2 2 k F hF i j : _ → _) ∘
          ((chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv : _ → _)) ∘
          (Spec.map eRing.symm.toCommRingCatIso.hom : _ → _)) = _
    rw [Function.Surjective.range_comp h1]
    change Set.range
        ((chartZeroLocusToGlobal 2 2 k F hF i j : _ → _) ∘
          ((chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F).inv : _ → _)) = _
    rw [Function.Surjective.range_comp h2]
  -- Section lands in the chart open of `r`.
  have hfac : Set.range (ψ ≫ s.σ).base ⊆ Set.range r.base := by
    intro z hz
    obtain ⟨a, rfl⟩ := hz
    rw [hr_range, hr0_range]
    refine ⟨?_, ?_⟩
    · -- fst half: `s.toTotal (ψ a) ∈ range c`.
      change (pullback.fst πX t) ((ψ ≫ s.σ).base a) ∈ Set.range c
      have hto : (pullback.fst πX t) ((ψ ≫ s.σ).base a) =
          s.toTotal.base (ψ.base a) := by
        simp only [Scheme.Hom.comp_base, PullbackSection.toTotal]
        rfl
      rw [hto, hc_range]
      -- Use opensRange characterisation of the chart zero locus.
      change s.toTotal.base (ψ.base a) ∈
        (chartZeroLocusToGlobal 2 2 k F hF i j).opensRange
      rw [opensRange_chartZeroLocusToGlobal]
      -- Membership in ι ⁻¹ᵁ chart open ⇔ ambient point in the product chart.
      change (biprojectiveZeroLocusι 2 2 k F).base (s.toTotal.base (ψ.base a)) ∈
        ((standardChartAffineOpen 2 2 k i j).1 : Set _)
      have hstd : ((standardChartAffineOpen 2 2 k i j).1 : Set _) =
          Set.range (standardChartι 2 2 k i j) := by
        simp [standardChartAffineOpen, Scheme.Hom.coe_opensRange]
      rw [hstd, range_standardChartι]
      have hxT : ψ.base a ∈
          ((t ⁻¹ᵁ (U ⊓ ProjectiveSpace.standardChart 2 k j) ⊓
              (s.toTotal ≫ biprojectiveZeroLocusFst 2 2 k F) ⁻¹ᵁ
                ProjectiveSpace.standardChart 2 k i : T.Opens) : Set T) :=
        hrange ⟨a, rfl⟩
      have hfst : (s.toTotal ≫ biprojectiveZeroLocusFst 2 2 k F).base (ψ.base a) ∈
          (ProjectiveSpace.standardChart 2 k i : Set _) :=
        (Set.mem_inter_iff _ _ _).mp hxT |>.2
      have hsnd : t.base (ψ.base a) ∈
          (ProjectiveSpace.standardChart 2 k j : Set _) := by
        have hyU : t.base (ψ.base a) ∈
            ((U ⊓ ProjectiveSpace.standardChart 2 k j :
              (ProjectiveSpace 2 k).Opens) : Set _) :=
          (Set.mem_inter_iff _ _ _).mp hxT |>.1
        exact (Set.mem_inter_iff _ _ _).mp hyU |>.2
      refine ⟨?_, ?_⟩
      · change (fst 2 2 k).base
            ((biprojectiveZeroLocusι 2 2 k F).base (s.toTotal.base (ψ.base a))) ∈
          Set.range (ProjectiveSpace.standardChartι 2 k i)
        have hfst_eq :
            (biprojectiveZeroLocusFst 2 2 k F).base (s.toTotal.base (ψ.base a)) =
              (fst 2 2 k).base
                ((biprojectiveZeroLocusι 2 2 k F).base (s.toTotal.base (ψ.base a))) := by
          simp [biprojectiveZeroLocusFst, Scheme.Hom.comp_base]
        rw [← hfst_eq]
        change (s.toTotal ≫ biprojectiveZeroLocusFst 2 2 k F).base (ψ.base a) ∈
          Set.range (ProjectiveSpace.standardChartι 2 k i)
        rw [← Scheme.Hom.coe_opensRange, ProjectiveSpace.opensRange_standardChartι]
        exact hfst
      · change (snd 2 2 k).base
            ((biprojectiveZeroLocusι 2 2 k F).base (s.toTotal.base (ψ.base a))) ∈
          Set.range (ProjectiveSpace.standardChartι 2 k j)
        have hsnd_eq :
            (biprojectiveZeroLocusSnd 2 2 k F).base (s.toTotal.base (ψ.base a)) =
              (snd 2 2 k).base
                ((biprojectiveZeroLocusι 2 2 k F).base (s.toTotal.base (ψ.base a))) := by
          simp [biprojectiveZeroLocusSnd, Scheme.Hom.comp_base]
        rw [← hsnd_eq]
        have ht_eq :
            (biprojectiveZeroLocusSnd 2 2 k F).base (s.toTotal.base (ψ.base a)) =
              t.base (ψ.base a) := by
          rw [← Scheme.Hom.comp_apply, s.toTotal_comp]
        rw [ht_eq, ← Scheme.Hom.coe_opensRange, ProjectiveSpace.opensRange_standardChartι]
        exact hsnd
    · -- snd half: `pullback.snd (s.σ (ψ a)) = ψ a ∈ range ψ`.
      change (pullback.snd πX t) ((ψ ≫ s.σ).base a) ∈ Set.range ψ
      have : (pullback.snd πX t) ((ψ ≫ s.σ).base a) = ψ.base a := by
        simp only [Scheme.Hom.comp_base, Function.comp_apply]
        change (s.σ ≫ pullback.snd πX t).base (ψ.base a) = ψ.base a
        rw [s.is_section]
        rfl
      rw [this]
      exact ⟨a, rfl⟩
  exact ⟨A, instCR, algA, g, hdeg, y, ‹_›, hg, ψ, hOI, hDom, r, ‹IsOpenImmersion r›, hr,
    hrange, hfac⟩

/-- **Algebraic extraction of an `A`-point from a section of the structure map.**

A left inverse of `Spec(A[x₁,x₂]/(g)) → Spec A` is a ring map
`A[x₁,x₂]/(g) → A` sending constants to themselves; its values on the two generators are the
coordinates of an `A`-point of `V(g)`. -/
theorem exists_eval_eq_zero_of_structure_section
    {A : Type u} [CommRing A] (g : MvPolynomial (Fin 2) A)
    (φ : Spec (CommRingCat.of A) ⟶
      Spec (CommRingCat.of (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})))
    (hφ : φ ≫ Spec.map (CommRingCat.ofHom
        ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) =
      𝟙 _) :
    ∃ (p₁ p₂ : A), MvPolynomial.eval ![p₁, p₂] g = 0 := by
  let B := MvPolynomial (Fin 2) A ⧸ Ideal.span {g}
  let ψR : CommRingCat.of B ⟶ CommRingCat.of A := Spec.preimage φ
  have hsec :
      CommRingCat.ofHom ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C) ≫ ψR =
        𝟙 (CommRingCat.of A) := by
    have h := congrArg Spec.preimage hφ
    simpa [Spec.preimage_comp, Spec.preimage_map, Spec.preimage_id] using h
  let φR : B →+* A := ψR.hom
  have hφC : ∀ a : A, φR (Ideal.Quotient.mk _ (C a)) = a := fun a => by
    have := congrArg (fun (f : CommRingCat.of A ⟶ CommRingCat.of A) => f.hom a) hsec
    change φR (Ideal.Quotient.mk _ (C a)) = a
    simpa using this
  refine ⟨φR (Ideal.Quotient.mk _ (X 0)), φR (Ideal.Quotient.mk _ (X 1)), ?_⟩
  let e : MvPolynomial (Fin 2) A →+* A := φR.comp (Ideal.Quotient.mk _)
  have he : e = MvPolynomial.eval ![φR (Ideal.Quotient.mk _ (X 0)),
      φR (Ideal.Quotient.mk _ (X 1))] := by
    refine MvPolynomial.ringHom_ext ?_ ?_
    · intro a
      change φR (Ideal.Quotient.mk _ (C a)) = MvPolynomial.eval _ (C a)
      rw [hφC, MvPolynomial.eval_C]
    · intro i
      fin_cases i
      · simp [e, MvPolynomial.eval_X]; rfl
      · simp [e, MvPolynomial.eval_X]; rfl
  have hg0 : (Ideal.Quotient.mk (Ideal.span {g}) g : B) = 0 :=
    Ideal.Quotient.eq_zero_iff_mem.mpr (Ideal.mem_span_singleton_self g)
  calc
    MvPolynomial.eval ![φR (Ideal.Quotient.mk _ (X 0)),
        φR (Ideal.Quotient.mk _ (X 1))] g
        = e g := by rw [he]
    _ = φR (Ideal.Quotient.mk _ g) := rfl
    _ = φR 0 := by rw [hg0]
    _ = 0 := map_zero _

/-- **Subclaim C₃.**  If the base-changed section `ψ ≫ s.σ` lands in the open chart `r`, then
the section supplies an `A`-point of `V(g)`.

The range inclusion is the geometric input arranged by choosing the `x`-chart so the
multisection meets it.  With that inclusion, `IsOpenImmersion.lift` produces a section of
the structure map, and the algebraic extraction above reads off `(p₁, p₂)`. -/
theorem exists_section_chartPoint
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    {A : Type u} [CommRing A] (g : MvPolynomial (Fin 2) A)
    {T : Scheme.{u}} [IsIntegral T]
    (_t : T ⟶ ProjectiveSpace 2 k)
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) _t)
    (ψ : Spec (CommRingCat.of A) ⟶ T) [IsOpenImmersion ψ] [IsDominant ψ]
    (r : Spec (CommRingCat.of (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})) ⟶
      Limits.pullback (biprojectiveZeroLocusSnd 2 2 k F) _t) [IsOpenImmersion r]
    (hr : r ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) _t =
      Spec.map (CommRingCat.ofHom
        ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ≫ ψ)
    (hfac : Set.range (ψ ≫ s.σ).base ⊆ Set.range r.base) :
    ∃ (p₁ p₂ : A), MvPolynomial.eval ![p₁, p₂] g = 0 := by
  let φ : Spec (CommRingCat.of A) ⟶
      Spec (CommRingCat.of (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})) :=
    IsOpenImmersion.lift r (ψ ≫ s.σ) hfac
  have hφr : φ ≫ r = ψ ≫ s.σ := IsOpenImmersion.lift_fac r (ψ ≫ s.σ) hfac
  have hφsec : φ ≫ Spec.map (CommRingCat.ofHom
      ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) = 𝟙 _ := by
    haveI : Mono ψ := inferInstance
    apply (cancel_mono ψ).1
    calc
      (φ ≫ Spec.map (CommRingCat.ofHom
          ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C))) ≫ ψ
          = φ ≫ (Spec.map (CommRingCat.ofHom
              ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ≫ ψ) := by
            rw [Category.assoc]
      _ = φ ≫ (r ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) _t) := by
            rw [← hr]
      _ = (φ ≫ r) ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) _t := by
            rw [Category.assoc]
      _ = (ψ ≫ s.σ) ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) _t := by
            rw [hφr]
      _ = ψ ≫ (s.σ ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) _t) := by
            rw [Category.assoc]
      _ = ψ ≫ 𝟙 _ := by rw [s.is_section]
      _ = 𝟙 _ ≫ ψ := by simp
  exact exists_eval_eq_zero_of_structure_section g φ hφsec

private theorem isWeightedHomogeneous_left_divMonomial_X_inl
    {k : Type u} [CommRing k] {a : ℕ}
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : F.IsWeightedHomogeneous leftDegreeWeight (a + 1)) (i : Fin 3) :
    (divMonomial F (Finsupp.single (Sum.inl i : BiprojectiveCoordinate 2 2) 1)).IsWeightedHomogeneous
      leftDegreeWeight a := by
  intro d hd
  have hcoeff :
      coeff (Finsupp.single (Sum.inl i : BiprojectiveCoordinate 2 2) 1 + d) F ≠ 0 := by
    rwa [coeff_divMonomial] at hd
  have hw := hF hcoeff
  have hwt :
      weight leftDegreeWeight
          (Finsupp.single (Sum.inl i : BiprojectiveCoordinate 2 2) 1 + d) =
        weight leftDegreeWeight
            (Finsupp.single (Sum.inl i : BiprojectiveCoordinate 2 2) 1) +
          weight leftDegreeWeight d :=
    map_add (weight leftDegreeWeight) _ _
  have hs : weight leftDegreeWeight
      (Finsupp.single (Sum.inl i : BiprojectiveCoordinate 2 2) 1) = 1 := by
    rw [weight_single]
    simp [leftDegreeWeight]
  -- hw : weight (single + d) = a+1, so weight d = a
  have : weight leftDegreeWeight d = a := by
    have := hw
    rw [hwt, hs] at this
    omega
  exact this

private theorem sndFiberChartMap_id_eq_comm
    {k : Type u} [CommRing k] (i j : Fin 3)
    (z : StandardChartRing 2 2 k i j) :
    sndFiberChartMap (i := i)
        (AlgHom.id k (ProjectiveSpace.StandardChartRing 2 k j)) z =
      Algebra.TensorProduct.comm k
        (ProjectiveSpace.StandardChartRing 2 k i)
        (ProjectiveSpace.StandardChartRing 2 k j) z := by
  refine TensorProduct.induction_on z ?_ ?_ ?_
  · simp
  · intro a b
    rw [sndFiberChartMap_tmul, AlgHom.id_apply, Algebra.TensorProduct.comm_tmul]
  · intro x y hx hy
    simp only [map_add, hx, hy]

private theorem sndFiberChartMap_id_injective
    {k : Type u} [CommRing k] (i j : Fin 3) :
    Function.Injective
      (sndFiberChartMap (i := i)
        (AlgHom.id k (ProjectiveSpace.StandardChartRing 2 k j))).toRingHom := by
  intro x₁ x₂ h
  apply (Algebra.TensorProduct.comm k
      (ProjectiveSpace.StandardChartRing 2 k i)
      (ProjectiveSpace.StandardChartRing 2 k j)).injective
  rwa [← sndFiberChartMap_id_eq_comm, ← sndFiberChartMap_id_eq_comm]

private theorem algebraMap_eval
    {A K : Type u} [CommRing A] [CommRing K]
    (φ : A →+* K) (p₁ p₂ : A) (f : MvPolynomial (Fin 2) A) :
    φ (eval ![p₁, p₂] f) = eval ![φ p₁, φ p₂] (map φ f) := by
  rw [eval_map]
  -- goal: φ (eval p f) = eval₂ φ ![φ p1, φ p2] f
  have h := eval₂_comp_left φ (RingHom.id A) ![p₁, p₂] f
  -- rewrite eval as eval₂ id on the left of h
  have h' : φ (eval ![p₁, p₂] f) =
      eval₂ (φ.comp (RingHom.id A)) (φ ∘ ![p₁, p₂]) f := by
    simpa only [eval, eval₂_id] using h
  refine h'.trans ?_
  rw [RingHom.comp_id]
  congr 1
  ext i
  fin_cases i <;> rfl

/-- Dummy left-dehomogenization that sends `Xᵢ` to a degree-1 variable (so weight is preserved);
agrees with the true chart dehomogenization on forms free of `Xᵢ`. -/
noncomputable def baseChangedChartVariableWeight
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A) :
    BiprojectiveCoordinate 2 2 → MvPolynomial (Fin 2) A
  | .inl l => i.succAboveCases (X 0 : MvPolynomial (Fin 2) A) (fun r => X r) l
  | .inr l => C (y (ProjectiveSpace.normalizedCoordinate 2 k j l))

private theorem succAboveCases_X_mv'
    {A : Type u} [CommRing A] (i : Fin 3) (y0 : MvPolynomial (Fin 2) A) (r : Fin 2) :
    i.succAboveCases y0 (fun s => (X s : MvPolynomial (Fin 2) A)) (i.succAbove r) =
      (X r : MvPolynomial (Fin 2) A) := by
  simp only [Fin.succAboveCases, dif_neg (Fin.succAbove_ne i r),
    Fin.succAbove_lt_iff_castSucc_lt]
  split_ifs with hlt
  · generalize_proofs H₁ H₂; revert H₂
    generalize hk : Fin.castPred (i.succAbove r) H₁ = k'
    rw [Fin.castPred_succAbove r i hlt] at hk; cases hk; intro; rfl
  · generalize_proofs H₀ H₁ H₂; revert H₂
    generalize hk : Fin.pred (i.succAbove r) H₁ = k'
    rw [Fin.pred_succAbove r i (Fin.not_lt.1 hlt)] at hk; cases hk; intro; rfl

private theorem baseChangedChartVariableWeight_isHomogeneous
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A)
    (z : BiprojectiveCoordinate 2 2) :
    (baseChangedChartVariableWeight i j y z).IsHomogeneous (leftDegreeWeight z) := by
  match z with
  | .inl l =>
      dsimp only [baseChangedChartVariableWeight, leftDegreeWeight]
      rcases Fin.eq_self_or_eq_succAbove i l with h | ⟨r, h⟩
      · subst h; simp only [Fin.succAboveCases, ↓reduceDIte]
        exact isHomogeneous_X (R := A) (0 : Fin 2)
      · subst h; rw [succAboveCases_X_mv' i _ r]
        exact isHomogeneous_X (R := A) r
  | .inr l =>
      exact isHomogeneous_C (σ := Fin 2) (R := A)
        (y (ProjectiveSpace.normalizedCoordinate 2 k j l))

private theorem aeval_baseChanged_eq_weight_of_not_mem_X
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A)
    (H : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hfree : ∀ s, coeff s H ≠ 0 → s (Sum.inl i) = 0) :
    aeval (baseChangedChartVariable i j y) H =
      aeval (baseChangedChartVariableWeight i j y) H := by
  simp only [aeval_def]
  refine eval₂_congr (algebraMap k (MvPolynomial (Fin 2) A))
      (baseChangedChartVariable i j y) (baseChangedChartVariableWeight i j y)
      fun {z} {c} hzc hc => ?_
  have hz_ne : z ≠ Sum.inl i := by
    intro hzi
    have : c (Sum.inl i) ≠ 0 := by
      rwa [hzi, Finsupp.mem_support_iff] at hzc
    exact this (hfree c hc)
  match z with
  | .inl l =>
      dsimp [baseChangedChartVariable, baseChangedChartVariableWeight]
      rcases Fin.eq_self_or_eq_succAbove i l with h | ⟨r, h⟩
      · exact (hz_ne (by rw [h])).elim
      · subst h
        exact (succAboveCases_X_mv (A := A) i r).trans
          (succAboveCases_X_mv' i (X 0) r).symm
  | .inr l =>
      rfl

private theorem aeval_baseChanged_isHomogeneous_of_not_mem_X_inl
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A)
    {d : ℕ} (H : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hH : H.IsWeightedHomogeneous leftDegreeWeight d)
    (hfree : ∀ s, coeff s H ≠ 0 → s (Sum.inl i) = 0) :
    (aeval (baseChangedChartVariable i j y) H).IsHomogeneous d := by
  rw [aeval_baseChanged_eq_weight_of_not_mem_X i j y H hfree]
  exact hH.aeval_isHomogeneous (baseChangedChartVariableWeight i j y)
    (baseChangedChartVariableWeight_isHomogeneous i j y)

private theorem aeval_baseChanged_hasWeightedDegreeLE
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A)
    {d : ℕ} (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : F.IsWeightedHomogeneous leftDegreeWeight d) :
    (aeval (baseChangedChartVariable i j y) F).HasWeightedDegreeLE
      (fun _ : Fin 2 => (1 : ℕ)) d := by
  refine hF.aeval_hasWeightedDegreeLE (fun _ => 1) (baseChangedChartVariable i j y) ?_
  intro z
  match z with
  | .inl l =>
      dsimp only [baseChangedChartVariable, leftDegreeWeight]
      rcases Fin.eq_self_or_eq_succAbove i l with h | ⟨r, h⟩
      · subst h; simp only [Fin.succAboveCases, ↓reduceDIte]
        exact (HasWeightedDegreeLE.C (σ := Fin 2) (fun _ => (1 : ℕ)) (1 : A)).mono
          (Nat.zero_le 1)
      · subst h; rw [succAboveCases_X_mv]
        exact (isWeightedHomogeneous_X (R := A) (fun _ : Fin 2 => (1 : ℕ)) r).hasWeightedDegreeLE
  | .inr l =>
      exact HasWeightedDegreeLE.C (σ := Fin 2) (fun _ => (1 : ℕ)) _

set_option maxHeartbeats 1200000 in
/-- **Quadratic half of C₄.**  Nonvanishing of the slope-quadratic of the base-changed chart
equation, from global smoothness forbidding `Xᵢ ∣ F`.  No fibre-smoothness input. -/
theorem chartEquation_slopeQuad_ne_zero
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {A : Type u} [CommRing A] [IsDomain A] [Algebra k A]
    (i j : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k j →ₐ[k] A)
    [IsDominant (Spec.map (CommRingCat.ofHom y.toRingHom))] :
    let g := baseChangedChartEquation (i := i) y F
    PointedConic.slopeQuad (MvPolynomial.coeff (binaryExponent 2 0) g)
        (MvPolynomial.coeff (binaryExponent 1 1) g)
        (MvPolynomial.coeff (binaryExponent 0 2) g) ≠ 0 := by
  intro g
  have hy_inj : Function.Injective y.toRingHom :=
    Scheme.injective_of_isDominant_specMap y.toRingHom
  have hg_aeval : g = aeval (baseChangedChartVariable i j y) F :=
    baseChangedChartEquation_eq_aeval (i := i) (j := j) y F
  intro hQ0
  obtain ⟨h20, h11, h02⟩ := (PointedConic.slopeQuad_eq_zero_iff _ _ _).mp hQ0
  let Xi : BiprojectiveCoordinate 2 2 := Sum.inl i
  let H : MvPolynomial (BiprojectiveCoordinate 2 2) k :=
    modMonomial F (Finsupp.single Xi 1)
  let Qpol : MvPolynomial (BiprojectiveCoordinate 2 2) k :=
    divMonomial F (Finsupp.single Xi 1)
  have hsplit : X Xi * Qpol + H = F :=
    divMonomial_add_modMonomial_single F Xi
  have hHbi : IsBihomogeneousOfBidegree 2 3 H :=
    isBihomogeneous_modMonomial_X_inl F hF i
  have hHleft : H.IsWeightedHomogeneous leftDegreeWeight 2 :=
    hHbi.isWeightedHomogeneous_left
  have hQleft : Qpol.IsWeightedHomogeneous leftDegreeWeight 1 :=
    isWeightedHomogeneous_left_divMonomial_X_inl (a := 1) F
      hF.isWeightedHomogeneous_left i
  let v : BiprojectiveCoordinate 2 2 → MvPolynomial (Fin 2) A :=
    baseChangedChartVariable i j y
  have hvXi : v Xi = 1 := by
    dsimp [v, baseChangedChartVariable, Xi]
    exact Fin.insertNth_apply_same (α := fun _ => MvPolynomial (Fin 2) A)
      i (1 : MvPolynomial (Fin 2) A) (fun r => (X r : MvPolynomial (Fin 2) A))
  have hgae : g = aeval v Qpol + aeval v H := by
    have h1 : g = aeval v F := hg_aeval
    have h2 : aeval v F = aeval v (X Xi * Qpol + H) := by rw [hsplit]
    let φ : MvPolynomial (BiprojectiveCoordinate 2 2) k →+* MvPolynomial (Fin 2) A :=
      (aeval v).toRingHom
    have h3 : φ (X Xi * Qpol + H) = φ (X Xi) * φ Qpol + φ H := by
      rw [map_add, map_mul]
    have h4 : φ (X Xi) = 1 := by
      change aeval v (X Xi) = 1
      rw [aeval_X, hvXi]
    change g = aeval v Qpol + aeval v H
    calc
      g = aeval v F := h1
      _ = aeval v (X Xi * Qpol + H) := h2
      _ = φ (X Xi * Qpol + H) := rfl
      _ = φ (X Xi) * φ Qpol + φ H := h3
      _ = 1 * aeval v Qpol + aeval v H := by rw [h4]; rfl
      _ = aeval v Qpol + aeval v H := by rw [one_mul]
  have hfreeH : ∀ s, coeff s H ≠ 0 → s Xi = 0 := by
    intro s hs
    by_contra hpos
    have hle : Finsupp.single Xi 1 ≤ s := by
      rw [Finsupp.single_le_iff]
      exact Nat.one_le_iff_ne_zero.mpr hpos
    have : coeff s H = 0 := coeff_modMonomial_of_le F hle
    exact hs this
  have hH_ae : (aeval v H).IsHomogeneous 2 :=
    aeval_baseChanged_isHomogeneous_of_not_mem_X_inl i j y H hHleft hfreeH
  have hQ_le :
      (aeval v Qpol).HasWeightedDegreeLE (fun _ : Fin 2 => (1 : ℕ)) 1 :=
    aeval_baseChanged_hasWeightedDegreeLE i j y Qpol hQleft
  have hdeg2_Q :
      ∀ d : Fin 2 →₀ ℕ, d.degree = 2 → coeff d (aeval v Qpol) = 0 := by
    intro d hd
    by_contra hne
    have hw := hQ_le hne
    have hwt : weight (fun _ : Fin 2 => (1 : ℕ)) d = d 0 + d 1 := by
      simp only [weight_apply, Finsupp.sum, smul_eq_mul, mul_one]
      exact finsupp_sum_fin_two d
    have hdeg : d.degree = d 0 + d 1 := by
      rw [Finsupp.degree_eq_sum, Fin.sum_univ_two]
    omega
  have hcoeffH20 : coeff (binaryExponent 2 0) (aeval v H) = 0 := by
    have h := congrArg (coeff (binaryExponent 2 0)) hgae
    have hQ0' : coeff (binaryExponent 2 0) (aeval v Qpol) = 0 :=
      hdeg2_Q _ (by simp [binaryExponent_degree])
    have : coeff (binaryExponent 2 0) g =
        coeff (binaryExponent 2 0) (aeval v H) := by
      simpa [coeff_add, hQ0'] using h
    exact this.symm.trans h20
  have hcoeffH11 : coeff (binaryExponent 1 1) (aeval v H) = 0 := by
    have h := congrArg (coeff (binaryExponent 1 1)) hgae
    have hQ0' : coeff (binaryExponent 1 1) (aeval v Qpol) = 0 :=
      hdeg2_Q _ (by simp [binaryExponent_degree])
    have : coeff (binaryExponent 1 1) g =
        coeff (binaryExponent 1 1) (aeval v H) := by
      simpa [coeff_add, hQ0'] using h
    exact this.symm.trans h11
  have hcoeffH02 : coeff (binaryExponent 0 2) (aeval v H) = 0 := by
    have h := congrArg (coeff (binaryExponent 0 2)) hgae
    have hQ0' : coeff (binaryExponent 0 2) (aeval v Qpol) = 0 :=
      hdeg2_Q _ (by simp [binaryExponent_degree])
    have : coeff (binaryExponent 0 2) g =
        coeff (binaryExponent 0 2) (aeval v H) := by
      simpa [coeff_add, hQ0'] using h
    exact this.symm.trans h02
  have hHae0 : aeval v H = 0 := by
    apply MvPolynomial.ext
    intro d
    by_cases hne : coeff d (aeval v H) = 0
    · simp [hne]
    · have hddeg : d.degree = 2 := by
        by_contra hne'
        exact hne (IsHomogeneous.coeff_eq_zero hH_ae hne')
      have hsum : d 0 + d 1 = 2 := by
        simpa [Finsupp.degree_eq_sum, Fin.sum_univ_two] using hddeg
      rw [show d = binaryExponent (d 0) (d 1) from (binaryExponent_apply_apply d).symm]
      rcases (show d 0 = 2 ∧ d 1 = 0 ∨ d 0 = 1 ∧ d 1 = 1 ∨ d 0 = 0 ∧ d 1 = 2 by omega)
        with (⟨h0, h1⟩ | ⟨h0, h1⟩ | ⟨h0, h1⟩)
      · simpa [h0, h1] using hcoeffH20
      · simpa [h0, h1] using hcoeffH11
      · simpa [h0, h1] using hcoeffH02
  have hmapH :
      aeval v H = map y.toRingHom (aeval (universalBaseChangedChartVariable i j) H) := by
    have h1 := baseChangedChartEquation_eq_map_universal (i := i) (j := j) y H
    have h2 := baseChangedChartEquation_eq_aeval (i := i) (j := j) y H
    exact h2.symm.trans h1
  have hHuniv0 :
      (aeval (universalBaseChangedChartVariable i j) H :
        MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j)) = 0 := by
    let uH : MvPolynomial (Fin 2) (ProjectiveSpace.StandardChartRing 2 k j) :=
      aeval (universalBaseChangedChartVariable i j) H
    apply (map_injective (σ := Fin 2) y.toRingHom hy_inj).eq_iff.mp
    rw [map_zero]
    change map y.toRingHom (aeval (universalBaseChangedChartVariable i j) H) = 0
    rw [← hmapH, hHae0]
  have hbase0 :
      baseChangedChartEquation (i := i)
        (AlgHom.id k (ProjectiveSpace.StandardChartRing 2 k j)) H = 0 := by
    have h := baseChangedChartEquation_eq_map_universal (i := i) (j := j)
        (AlgHom.id k (ProjectiveSpace.StandardChartRing 2 k j)) H
    rw [h]
    change MvPolynomial.map (RingHom.id _)
        (aeval (universalBaseChangedChartVariable i j) H) = 0
    rw [MvPolynomial.map_id, hHuniv0]
  have hchart0 : chartEquation 2 2 k i j H = 0 := by
    have hten :
        tensorStandardChartEquivMvPolynomial 2 k
            (ProjectiveSpace.StandardChartRing 2 k j) i
            (sndFiberChartMap (i := i)
              (AlgHom.id k (ProjectiveSpace.StandardChartRing 2 k j))
              (chartEquation 2 2 k i j H)) = 0 := by
      simpa [baseChangedChartEquation] using hbase0
    have hsnd :
        sndFiberChartMap (i := i)
            (AlgHom.id k (ProjectiveSpace.StandardChartRing 2 k j))
            (chartEquation 2 2 k i j H) = 0 := by
      apply (tensorStandardChartEquivMvPolynomial 2 k
        (ProjectiveSpace.StandardChartRing 2 k j) i).injective
      rw [hten, map_zero]
    exact sndFiberChartMap_id_injective i j hsnd
  have hH0 : H = 0 :=
    (chartEquation_eq_zero_iff 2 2 k i j H hHbi).mp hchart0
  have hXdvd : X Xi ∣ F := by
    rw [X_dvd_iff_modMonomial_eq_zero]
    exact hH0
  exact not_X_inl_dvd_of_smooth F hF hF0 i hXdvd

set_option maxHeartbeats 400000 in
/-- **C₄ assembled.** Quadratic half from `chartEquation_slopeQuad_ne_zero`; linear half from
the bidegree-specific generic-conic determinant on the standard base chart. -/
theorem chartEquation_nondegenerate
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {A : Type u} [CommRing A] [IsDomain A] [Algebra k A]
    (i : Fin 3) (y : ProjectiveSpace.StandardChartRing 2 k 0 →ₐ[k] A)
    [IsDominant (Spec.map (CommRingCat.ofHom y.toRingHom))]
    (p₁ p₂ : A)
    (hp : MvPolynomial.eval ![p₁, p₂]
      (baseChangedChartEquation (i := i) (j := 0) y F) = 0) :
    let g := baseChangedChartEquation (i := i) (j := 0) y F
    PointedConic.slopeQuad (MvPolynomial.coeff (binaryExponent 2 0) g)
        (MvPolynomial.coeff (binaryExponent 1 1) g)
        (MvPolynomial.coeff (binaryExponent 0 2) g) ≠ 0 ∧
      PointedConic.slopeLin
        (MvPolynomial.eval ![p₁, p₂] (MvPolynomial.pderiv 0 g))
        (MvPolynomial.eval ![p₁, p₂] (MvPolynomial.pderiv 1 g)) ≠ 0 := by
  intro g
  have hQ : PointedConic.slopeQuad (coeff (binaryExponent 2 0) g)
      (coeff (binaryExponent 1 1) g) (coeff (binaryExponent 0 2) g) ≠ 0 :=
    chartEquation_slopeQuad_ne_zero F hF hF0 i 0 y
  have hL : PointedConic.slopeLin
      (eval ![p₁, p₂] (pderiv 0 g)) (eval ![p₁, p₂] (pderiv 1 g)) ≠ 0 :=
    slopeLin_baseChangedChartEquation_ne_zero_of_smooth F hF hF0 i y p₁ p₂ hp
  exact ⟨hQ, hL⟩

/--
**The chart computation.**  Parent packaging around closed C₂–C₄.

* C₂: returns `y`, dominance of `Spec.map y`, `g = baseChangedChartEquation y F`, and a range
  constraint strong enough for the section to land in the chart open of `r`.
* C₃: closed under `hfac` (algebraic extraction + lift).
* C₄: `chartEquation_nondegenerate` on the returned `y`.

The linear nondegeneracy now comes from the explicit polar determinant of the universal conic on
the standard base chart, so this statement needs no smooth-open witness for the projection.
-/
theorem exists_chartEquation_openImmersion
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t) :
    ∃ (A : Type u) (_ : CommRing A) (g : MvPolynomial (Fin 2) A) (p₁ p₂ : A)
      (_ : ∀ d ∈ g.support, d 0 + d 1 ≤ 2)
      (_ : MvPolynomial.eval ![p₁, p₂] g = 0)
      (_ : PointedConic.slopeQuad (MvPolynomial.coeff (binaryExponent 2 0) g)
            (MvPolynomial.coeff (binaryExponent 1 1) g)
            (MvPolynomial.coeff (binaryExponent 0 2) g) ≠ 0)
      (_ : PointedConic.slopeLin
            (MvPolynomial.eval ![p₁, p₂] (MvPolynomial.pderiv 0 g))
            (MvPolynomial.eval ![p₁, p₂] (MvPolynomial.pderiv 1 g)) ≠ 0)
      (ψ : Spec (CommRingCat.of A) ⟶ T) (_ : IsOpenImmersion ψ) (_ : IsDominant ψ)
      (r : Spec (CommRingCat.of (MvPolynomial (Fin 2) A ⧸ Ideal.span {g})) ⟶
        Limits.pullback (biprojectiveZeroLocusSnd 2 2 k F) t) (_ : IsOpenImmersion r),
      r ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t =
        Spec.map (CommRingCat.ofHom
          ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ≫ ψ := by
  let j : Fin 3 := 0
  let U : (ProjectiveSpace 2 k).Opens := ⊤
  have hU : Dense (U : Set (ProjectiveSpace 2 k)) := by
    simpa [U] using (dense_univ : Dense (Set.univ : Set (ProjectiveSpace 2 k)))
  obtain ⟨i, hi⟩ :=
    exists_nonempty_preimage_standardChart
      (s.toTotal ≫ biprojectiveZeroLocusFst 2 2 k F)
  obtain ⟨A, instCR, instAlg, g, hdeg, y, hyDom, hg, ψ, hOI, hDom, r, hR, hr, hrange, hfac⟩ :=
    exists_chartQuotient_openImmersion F hF hF0 t s U hU i j hi
  letI := instCR
  letI := instAlg
  haveI := hOI
  haveI := hDom
  haveI := hR
  haveI := hyDom
  haveI : Nonempty (Spec (CommRingCat.of A)) :=
    (IsDominant.denseRange (f := ψ)).nonempty
  haveI : IsIntegral (Spec (CommRingCat.of A)) := isIntegral_of_isOpenImmersion ψ
  haveI : IsDomain A := (affine_isIntegral_iff (CommRingCat.of A)).mp ‹_›
  -- `hfac` is returned by C₂ (range of the section through the chart open of `r`).
  obtain ⟨p₁, p₂, hp⟩ := exists_section_chartPoint F g t s ψ r hr hfac
  -- Quadratic half of C₄: no fibre-smoothness input; uses returned `y`.
  have hQ : PointedConic.slopeQuad (MvPolynomial.coeff (binaryExponent 2 0) g)
      (MvPolynomial.coeff (binaryExponent 1 1) g)
      (MvPolynomial.coeff (binaryExponent 0 2) g) ≠ 0 := by
    simpa [hg] using chartEquation_slopeQuad_ne_zero F hF hF0 i j y
  have hp' : eval ![p₁, p₂]
      (baseChangedChartEquation (i := i) (j := 0) y F) = 0 := by
    rwa [← hg]
  have hL : PointedConic.slopeLin
      (MvPolynomial.eval ![p₁, p₂] (MvPolynomial.pderiv 0 g))
      (MvPolynomial.eval ![p₁, p₂] (MvPolynomial.pderiv 1 g)) ≠ 0 := by
    simpa [hg] using
      (chartEquation_nondegenerate F hF hF0 i y p₁ p₂ hp').2
  exact ⟨A, instCR, g, p₁, p₂, hdeg, hp, hQ, hL, ψ, hOI, hDom, r, hR, hr⟩

/-- **The chart computation in normal form.**

Reading `exists_chartEquation_openImmersion` through `BinaryQuadraticNormalForm`: a binary
polynomial whose exponents all have degree at most two *is* `affineConicPoly` of its six
coefficients (`eq_affineConicPoly_of_totalDegree_le_two`), so the raw chart equation can be
substituted away and the two nondegeneracy conditions become conditions on `α, β, γ` and on the
translated linear part — the latter by `eval_pderiv_zero_affineConicPoly` and its sibling, which
identify that part with the gradient at the marked point. -/
theorem exists_conicChart_openImmersion
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t) :
    ∃ (A : Type u) (_ : CommRing A) (α β γ δ ε ζ p₁ p₂ : A)
      (_ : MvPolynomial.eval ![p₁, p₂] (PointedConic.affineConicPoly α β γ δ ε ζ) = 0)
      (_ : PointedConic.slopeQuad α β γ ≠ 0)
      (_ : PointedConic.slopeLin (2 * α * p₁ + β * p₂ + δ) (β * p₁ + 2 * γ * p₂ + ε) ≠ 0)
      (ψ : Spec (CommRingCat.of A) ⟶ T) (_ : IsOpenImmersion ψ) (_ : IsDominant ψ)
      (r : PointedConic.affineConicScheme α β γ δ ε ζ ⟶
        Limits.pullback (biprojectiveZeroLocusSnd 2 2 k F) t) (_ : IsOpenImmersion r),
      r ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t =
        PointedConic.affineConicSchemeToSpec α β γ δ ε ζ ≫ ψ := by
  obtain ⟨A, instCR, g, p₁, p₂, hdeg, hp, hQ, hL, ψ, instOI, instDom, r, instR, hr⟩ :=
    exists_chartEquation_openImmersion F hF hF0 t s
  letI := instCR
  obtain ⟨α, β, γ, δ, ε, ζ, hg⟩ :=
    (totalDegree_le_two_iff_exists_affineConicPoly g).mp
      ((totalDegree_le_two_iff g).mpr hdeg)
  subst hg
  refine ⟨A, instCR, α, β, γ, δ, ε, ζ, p₁, p₂, hp, ?_, ?_, ψ, instOI, instDom, r, instR, hr⟩
  · simpa using hQ
  · rwa [PointedConic.eval_pderiv_zero_affineConicPoly,
      PointedConic.eval_pderiv_one_affineConicPoly] at hL

/-! ### Assembling the two leaves -/

/--
**The affine model, from the chart computation and irreducibility.**

An open immersion into an irreducible scheme, with nonempty source, has dense range, hence is
dominant; Mathlib's `Scheme.Hom.birationalOver` then turns it into a birational equivalence over
`T`.  The source is nonempty because the conic ring is a domain, hence nontrivial.
-/
theorem exists_pointedConicAffineModel
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t) :
    ∃ (A : Type u) (_ : CommRing A) (_ : IsDomain A) (a b c d e' : A)
      (_ : IsDomain (PointedConic.conicRing a b c d e'))
      (_ : PointedConic.slopeQuad a b c ≠ 0) (_ : PointedConic.slopeLin d e' ≠ 0)
      (ψ : Spec (CommRingCat.of A) ⟶ T) (_ : IsOpenImmersion ψ) (_ : IsDominant ψ),
      Scheme.BirationalOver
        (Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t)
        (PointedConic.conicSchemeToSpec a b c d e' ≫ ψ) := by
  obtain ⟨A, instCR, α, β, γ, δ, ε, ζ, p₁, p₂, hp, hQ, hL,
    ψ, instOI, instDom, r₀, instR₀, hr₀⟩ :=
    exists_conicChart_openImmersion F hF hF0 t s
  letI := instCR
  haveI := instOI
  haveI := instDom
  haveI := instR₀
  -- The base change is integral, so both `A` and the affine model's ring are domains: an open
  -- subscheme of an integral scheme is integral, and the affine model is nonempty because the
  -- section gives it an `A`-point.
  haveI : IsIntegral (Limits.pullback (C := Scheme.{u}) (biprojectiveZeroLocusSnd 2 2 k F) t) :=
    isIntegral_pullback_biprojectiveZeroLocusSnd F hF hF0 t
  haveI : Nonempty (Spec (CommRingCat.of A)) := by
    have hd : Dense (Set.range ψ.base) := IsDominant.denseRange (f := ψ)
    exact Set.range_nonempty_iff_nonempty.mp hd.nonempty
  letI : IsIntegral (Spec (CommRingCat.of A)) := isIntegral_of_isOpenImmersion ψ
  letI instID : IsDomain A := (affine_isIntegral_iff (CommRingCat.of A)).mp ‹_›
  haveI : Nontrivial (PointedConic.affineConicRing α β γ δ ε ζ) :=
    PointedConic.nontrivial_affineConicRing α β γ δ ε ζ p₁ p₂ hp
  haveI : Nonempty (PointedConic.affineConicScheme α β γ δ ε ζ) :=
    PrimeSpectrum.nonempty_iff_nontrivial.mpr inferInstance
  letI : IsIntegral (PointedConic.affineConicScheme α β γ δ ε ζ) :=
    isIntegral_of_isOpenImmersion r₀
  letI instACD : IsDomain (PointedConic.affineConicRing α β γ δ ε ζ) :=
    (affine_isIntegral_iff (CommRingCat.of (PointedConic.affineConicRing α β γ δ ε ζ))).mp ‹_›
  -- Translate the marked point to the origin; this is `affineConicSchemeIso`.
  haveI : IsDomain (PointedConic.conicRing α β γ
      (2 * α * p₁ + β * p₂ + δ) (β * p₁ + 2 * γ * p₂ + ε)) :=
    (PointedConic.affineConicRingEquiv α β γ δ ε ζ p₁ p₂ hp).symm.toRingEquiv.toMulEquiv.isDomain _
  set r : PointedConic.conicScheme α β γ
      (2 * α * p₁ + β * p₂ + δ) (β * p₁ + 2 * γ * p₂ + ε) ⟶
      Limits.pullback (biprojectiveZeroLocusSnd 2 2 k F) t :=
    (PointedConic.affineConicSchemeIso α β γ δ ε ζ p₁ p₂ hp).hom ≫ r₀ with hr_def
  haveI : IsOpenImmersion r := by rw [hr_def]; infer_instance
  have hr : r ≫ Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t =
      PointedConic.conicSchemeToSpec α β γ
        (2 * α * p₁ + β * p₂ + δ) (β * p₁ + 2 * γ * p₂ + ε) ≫ ψ := by
    rw [hr_def, Category.assoc, hr₀, ← Category.assoc,
      PointedConic.affineConicSchemeIso_hom_over]
  haveI : Nonempty (PointedConic.conicScheme α β γ
      (2 * α * p₁ + β * p₂ + δ) (β * p₁ + 2 * γ * p₂ + ε)) :=
    PrimeSpectrum.nonempty_iff_nontrivial.mpr inferInstance
  haveI : IsDominant r := by
    refine ⟨?_⟩
    exact ((Scheme.Hom.isOpenEmbedding r).isOpen_range).dense (Set.range_nonempty _)
  exact ⟨A, instCR, instID, α, β, γ, 2 * α * p₁ + β * p₂ + δ, β * p₁ + 2 * γ * p₂ + ε,
    inferInstance, hQ, hL, ψ, instOI, instDom, (Scheme.Hom.birationalOver r _ _ hr).symm⟩

/--
**Obligation 3, reduced to the spreading-out step.**

Given the affine model of `exists_pointedConicAffineModel`, the conclusion is now pure transport:
the model is `Spec A`-birational to `𝔸(1; Spec A)` by the *proved*
`PointedConic.birationalOver_conicScheme_affineSpace`, birationality over `Spec A` gives
birationality over `T` (`Scheme.BirationalOver.comp`), and `𝔸(1; Spec A)` over a dense open is
birational over `T` to `𝔸(1; T)` (`Scheme.birationalOver_affineSpace_comp`).
-/
theorem isPointedConicRationalOver_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t) :
    IsPointedConicRationalOver (biprojectiveZeroLocusSnd 2 2 k F) t s := by
  obtain ⟨A, instCR, instID, a, b, c, d, e', instCD, hQ, hL, ψ, instOI, instDom, hbir⟩ :=
    exists_pointedConicAffineModel F hF hF0 t s
  letI := instCR
  letI := instID
  letI := instCD
  haveI := instOI
  haveI := instDom
  have hden : PointedConic.conicMk a b c d e' (PointedConic.conicChartDenom d e') ≠ 0 :=
    PointedConic.conicMk_conicChartDenom_ne_zero a b c d e' hQ hL
  refine hbir.trans (((PointedConic.birationalOver_conicScheme_affineSpace
    a b c d e' hQ hL hden).comp ψ).trans ?_)
  exact Scheme.birationalOver_affineSpace_comp (ULift.{u} (Fin 1)) ψ

/-! ### Horizontality of the residual component -/

/-- Horizontality of the residual component, packaged from obligation 2.

`isDominant_residualImagePointOfNormalizedLoc_toBase` (WP-B, `ResidualComponentHorizontality`) is
the concrete coordinate statement that the localized residual map dominates `ℙ²_y`;
`isDominant_residualComponentToBase` (proved) transfers it to the component.  Obligation 2 has
exactly the hypotheses of obligation 3, so this adds no assumption — but obligation 3 now depends
on obligation 2, which is where the source's **choice of the multisection line** is owed. -/
theorem isDominant_residualComponentToBase_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstant F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm ![1, 0, 0] ![0, 1, 0] F v ≠ 0)
    (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0) :
    IsDominant (residualComponentToBase F hF v hv i j) :=
  isDominant_residualComponentToBase F hF v hv i j
    (isDominant_residualImagePointOfNormalizedLoc_toBase
      F hF hF0 hgood v hv0 hv hv2 hpolar i j hdenom)

/-! ### Obligation 3 -/

/--
**Obligation 3.**  The conic bundle base-changed to the residual component is birational over that
component to relative affine `1`-space.

*Status.* Reduced to the single leaf `isPointedConicRationalOver_of_smooth`; see the
module docstring for the decomposition and for why the horizontality input is load-bearing rather
than decorative.

Downstream of this obligation everything is already wired:
`hasUnirationalParametrization1_residualComponentBaseChangeSnd` consumes it directly.
-/
theorem isResidualComponentPointedConicRational_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstant F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm ![1, 0, 0] ![0, 1, 0] F v ≠ 0)
    (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0) :
    IsResidualComponentPointedConicRational F hF v hv i j := by
  haveI : IsIntegral (residualComponent F hF v hv i j) :=
    isIntegral_residualComponent F hF v hv i j hdenom
  haveI : IsDominant (residualComponentToBase F hF v hv i j) :=
    isDominant_residualComponentToBase_of_smooth
      F hF hF0 hgood v hv0 hv hv2 hpolar i j hdenom
  exact isPointedConicRationalOver_of_smooth F hF hF0
    (residualComponentToBase F hF v hv i j)
    (residualComponentMultisection F hF v hv i j).tautologicalPullbackSection

end

end BConicBundleMultisections
