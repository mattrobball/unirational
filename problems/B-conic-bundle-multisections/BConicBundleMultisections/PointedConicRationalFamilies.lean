/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BinaryQuadraticNormalForm
public import BConicBundleMultisections.PointedConicAffineModel
public import BConicBundleMultisections.PointedConicChartBaseChange
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

The obligation is reduced to **one** leaf, `exists_pointedConicAffineModel` — the *spreading-out*
step — by four groups of results that are proved outright:

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
    (hsm : RingHom.Smooth (algebraMap K (MvPolynomial (Fin 2) K ⧸ Ideal.span {g})))
    (p₁ p₂ : K) (hp : MvPolynomial.eval ![p₁, p₂] g = 0) :
    PointedConic.slopeLin (MvPolynomial.eval ![p₁, p₂] (MvPolynomial.pderiv 0 g))
      (MvPolynomial.eval ![p₁, p₂] (MvPolynomial.pderiv 1 g)) ≠ 0 := by
  have hp' : MvPolynomial.aeval ![p₁, p₂] g = 0 := by simpa using hp
  obtain ⟨i, hi⟩ :=
    Hypersurface.exists_pderiv_ne_zero_at_of_smooth g hg hsm ![p₁, p₂] hp'
  intro hzero
  obtain ⟨h0, h1⟩ := (PointedConic.slopeLin_eq_zero_iff _ _).mp hzero
  revert hi
  fin_cases i
  · simpa using h0
  · simpa using h1

/-! ### The two remaining leaves

The spreading-out step splits cleanly in two, and the passage between them is proved.

* `irreducibleSpace_pullback_biprojectiveZeroLocusSnd` — the base change is irreducible.  This is
  the half that uses the ambient smoothness (through "no whole `ℙ²_x` fibre") and it is exactly
  what the counterexample of the module docstring destroys.
* `exists_conicChart_openImmersion` — the chart computation: over a dense affine open of `T` the
  base change *contains* an affine conic with a marked `A`-point as an open subscheme, compatibly
  with the maps to `T`.  Two things it does **not** have to supply: the marked point need not be at
  the origin (`PointedConic.affineConicSchemeIso` translates it, unconditionally), and neither `A`
  nor the conic ring has to be a domain (both follow from integrality of the base change).

Given both, `exists_pointedConicAffineModel` is one application of Mathlib's
`Scheme.Hom.birationalOver`: an open immersion into an irreducible scheme with nonempty source has
dense range, hence is dominant, hence is a birational equivalence onto its target.
-/

/--
**The base change of the conic bundle to an integral base is integral.**

*Why it is true.*  `Y := X ×_{ℙ²_y} T` is cut out in `ℙ²_x × T` by the pullback of `F`, so every
irreducible component of `Y` has codimension at most one, i.e. dimension at least `dim T + 1`.  A
component lying over a proper closed subset `Z ⊊ T` has dimension at most
`(fibre dimension) + dim Z`.  The fibre dimension is at most `1`, because a fibre of
`π` is a plane conic which is never all of `ℙ²_x`: that is
`BiprojectiveSpace.not_specializeSecondCoordinates_eq_zero_of_smooth_bidegree23`, and it is the
only place the ambient smoothness of `X` is used.  So such a component has dimension at most
`1 + (dim T - 1) = dim T`, a contradiction; every component dominates `T`.  Over the generic point
of `T` the fibre is a *smooth* plane conic (`hU`, `hsmooth`, `[IsDominant t]`, `hF0` — see
`exists_conicChart_openImmersion`), and a smooth plane conic is geometrically integral, so there is
exactly one component through the generic fibre, with multiplicity one.  `ℙ²_x ×_k T` is integral
(`k` is algebraically closed and `ℙ²` is geometrically integral), and `Y` is the zero locus in it of
a single element which is therefore prime; hence `Y` is integral.

*Why integral and not merely irreducible.*  Integrality is what lets the chart leaf drop two of its
four conditions: an open subscheme of an integral scheme is integral, so the affine model's
coordinate ring is automatically a domain, and so is the base ring `A`.  Neither has to be produced
by hand, and in particular the "invert a leading coefficient, use freeness over `A[y]`" spreading
argument is not needed anywhere.

*What is missing.*  Only the dimension bookkeeping.  Mathlib has `Order.krullDim` for schemes but
no "a hypersurface in an irreducible scheme has pure codimension one" and no fibre-dimension
theorem at the pinned revision, so the two dimension estimates above have to be made by hand — or,
more cheaply, replaced by the standard argument that `Y` is the closure of its generic fibre once
no fibre is `2`-dimensional.

*Not decoration.*  Without `[Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]` this is **false**: see
the counterexample `F = Y₀³ (X₀X₁ − X₂²)` in the module docstring, where `Y` acquires the vertical
component `ℙ²_x × {Y₀ = 0}`.
-/
theorem isIntegral_pullback_biprojectiveZeroLocusSnd
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (hsmooth : Smooth (biprojectiveZeroLocusSnd 2 2 k F ∣_ U)) :
    IsIntegral (Limits.pullback (C := Scheme.{u}) (biprojectiveZeroLocusSnd 2 2 k F) t) :=
  sorry

/--
**The chart computation: the pointed affine conic sits inside the base change as an open
subscheme** (source §4–§5; `PLAN.md` WP-3e).

*Statement.*  There are a ring `A`, a dominant open immersion `ψ : Spec A ⟶ T`, coefficients
`α, β, γ, δ, ε, ζ` and a point `(p₁, p₂)` **on** the conic
`α x² + β x y + γ y² + δ x + ε y + ζ = 0` — the marked point may be anywhere, no translation is
asked for — with nonzero slope polynomials at the marked point, together with an **open immersion**
of that conic over `Spec A` into the base change `X ×_{ℙ²_y} T`, commuting with the two maps to
`T`.

Neither `A` nor the conic ring has to be shown to be a domain: both are *derived* in
`exists_pointedConicAffineModel` from integrality of the base change, since an open subscheme of an
integral scheme is integral and the marked point makes the affine model nonempty
(`PointedConic.nontrivial_affineConicRing`).

*Why it is true.*  `T` is integral and `t` is dominant, so the generic point `η` of `T` maps to the
generic point of `ℙ²_y`, which lies in the dense open `U`; hence the generic fibre is smooth.  It
is cut out by a *nonzero* quadratic form, because the coefficients of `F(·, y)` are the cubics in
`y` read off from the bihomogeneous coefficients of `F`, and they vanish at the generic point only
if `F = 0`, which `hF0` excludes; a nonzero ternary quadratic form with smooth projective zero
locus is nondegenerate.

Now choose charts.  Pick `j` with `η ∈ D₊(Y_j)`; pick `i` with the section lying in `D₊(X_i)` over
`η`.  Shrinking `T` to an affine open `Spec A` inside `t ⁻¹ (U ∩ D₊(Y_j))` on which the section
stays in `D₊(X_i)`, the biprojective chart machinery
(`BiprojectiveChart`, `chartZeroLocusIsoPullback`, `BiprojectiveDehomogenization`) identifies the
base change over `Spec A`, intersected with the chart `D₊(X_i)`, with
`Spec (A[x₁,x₂]/(g))`, where `g` is the dehomogenization of `F(·, y)` at the `y`-coordinates of
`t` — that is `affineConicPoly α β γ δ ε ζ` — and the section becomes an `A`-point `(p₁, p₂)` of
it.  That intersection is open in `X ×_{ℙ²_y} T`, which is the open immersion asked for.

Translating the marked point to the origin is *not* part of this statement: it is done once and for
all by `PointedConic.affineConicSchemeIso`, proved from `conicTranslate_affineConicPoly_of_mem`
(the quadratic part is unchanged, the new linear part is the gradient at the marked point, and the
constant term becomes `g(p) = 0`).

The three algebraic conditions:

* `slopeQuad α β γ ≠ 0`, i.e. `(α,β,γ) ≠ 0`: the quadratic part of `g` is the restriction of the
  projective conic to the line at infinity of the chart, and it vanishes identically only if that
  line is contained in the conic — impossible for a nondegenerate conic.
* `slopeLin (2αp₁+βp₂+δ) (βp₁+2γp₂+ε) ≠ 0`: that pair is the gradient of `g` at the marked point,
  i.e. the tangent line there, and it vanishes only if the marked point is a singular point of the
  conic.
No further shrinking is needed: the integrality that would have been obtained by inverting a
leading coefficient and using freeness over `A[y]` comes for free from
`isIntegral_pullback_biprojectiveZeroLocusSnd`.

*What is missing, precisely.*  No new mathematics; Mathlib is not the obstacle, the chain below is.
Each step names the declaration that supplies it, so the remaining work is mechanical.

1. *The chart of `X` is an explicit affine scheme.*
   `BiprojectiveSpace.chartZeroLocusIsoSpecAffineQuotient 2 2 k i j F`
   (`BiprojectiveAffineZeroLocus.lean`) gives
   `(chartIdealSheaf 2 2 k i j F).subscheme ≅ Spec (k[x₁,x₂,u,v] ⧸ (affineChartEquation …))`, with
   no bihomogeneity hypothesis, and `affineChartEquation` is literally `F` with `Xᵢ ↦ 1`,
   `Yⱼ ↦ 1` (`BiprojectiveAffineChart.lean`).
2. *That chart is an open subscheme of `X`.*  `chartZeroLocusToGlobal 2 2 k F hF i j`
   (`BiprojectiveAffineZeroLocus.lean`) carries an `IsOpenImmersion` instance, and
   `opensRange_chartZeroLocusToGlobal` (`BiprojectiveSmoothCriterion.lean`) identifies its image.
3. *Base change.*  An open immersion stays one after base change, so
   `pullback (chartZeroLocusToGlobal ≫ π) t ⟶ pullback π t` is an open immersion — this is the `r`
   asked for, once its source has been identified.
4. *Factor `t` through the `y`-chart.*  On the open `t ⁻¹ᵁ (standardChart 2 k j)` the map `t`
   factors through `ProjectiveSpace.standardChartι 2 k j`.  **No lemma does this for a general
   base**; the pattern to imitate is `standardChartResidueLift`
   (`BiprojectiveFiberEquationBaseChange.lean`), which is `IsOpenImmersion.lift` applied to
   `standardChartι`.
5. *Shrink* — **done**.  `exists_affine_base_of_chart` above produces `A` and `ψ` with
   `Set.range ψ ⊆ t ⁻¹ᵁ (U ⊓ standardChart 2 k j)`, for *every* `j`: the generic point of `ℙ²_k`
   lies in every standard chart (`ProjectiveSpace.genericPoint_mem_standardChart`), so no choice of
   `j` has to be made.  It rests on three general lemmas proved above —
   `Scheme.nonempty_preimage_of_isDominant`, `Scheme.nonempty_inf_opens` and
   `Scheme.exists_isOpenImmersion_isDominant_range_subset` (a nonempty open of an integral scheme
   contains a dense affine open, packaged as a dominant open immersion).  The choice of the
   `x`-chart index `i` is `exists_nonempty_preimage_standardChart` above, from
   `ProjectiveSpace.exists_mem_standardChart`.
6. *The substituted equation, and the pullback square.*  This is the crux, and it is **not blocked
   by Mathlib** — every piece exists; what is left is assembly.  `sndFiberChartMap` and
   `map_span_chartEquation_sndFiberChartMap` (`BiprojectiveFiberEquationBaseChange.lean`) already
   compute, for an arbitrary `k`-algebra point `y` of the `j`-th chart, the ring map and the image
   of the chart-equation ideal, namely the ideal generated by
   `specializeSecondCoordinates (secondNormalizedCoordinates y) (F.map (algebraMap k A))` — which is
   the conic `α x² + β x y + γ y² + δ x + ε y + ζ` over `A`, `ζ` included.  That the resulting
   square of rings is a **pushout** — i.e. that

   `(StandardChartRing 2 2 k i j ⧸ (chartEquation)) ⊗[StandardChartRing 2 k j] A` is
   `(A ⊗[k] StandardChartRing 2 k i) ⧸ (substituted equation)` —

   is now **proved**, in `PointedConicChartBaseChange.lean`:
   `BiprojectiveSpace.isPushout_chartQuotient`, with its `Spec` form
   `BiprojectiveSpace.isPullback_SpecMap_chartQuotient` saying that
   `Spec ((A ⊗ Sₓ) ⧸ I.map (sndFiberChartMap y))` *is* the fibre product of the chart of the zero
   locus with `Spec A` over the `j`-th chart of `ℙ²_y`.  It is two pushouts pasted:
   `isPushout_sndFiberChartMap` (substituting a chart point into the second block is a base change
   — itself two tensor-product pushouts pasted, with no hand computation) on top of
   `isPushout_quotientMk` (**quotienting by an ideal is a base change**, which Mathlib does not have
   categorically and which is proved there from the universal property).  What remains of this step
   is only the tree-specific *interface*: to read
   `BiprojectiveSpace.isPullback_SpecMap_chartQuotient` as an `IsPullback` over `ℙ²_y` for the two
   composites `chartZeroLocusToGlobal ≫ π` and `ψ ≫ t`.  The pasting itself is **done**:
   `Scheme.exists_isOpenImmersion_to_pullback` above turns any such square into the `r` this
   statement asks for, open immersion and compatibility square included, using Mathlib's
   `Scheme.pullback_map_isOpenImmersion` with the identity of `ℙ²_y` as the third comparison map.
   (For the point-constructing direction, which is *not* what is needed here but is the natural
   sanity check, the tree already has
   `chartZeroLocusPointOfNormalizedAlgebra` and `affineChartQuotientEvalAlgebra` in
   `ResidualImageAlgebraPoint.lean`.)
7. *Putting it in normal form* — **done**, and that is why this statement hands back the raw
   equation `g` rather than the six coefficients.  `BinaryQuadraticNormalForm` proves
   `eq_affineConicPoly_of_totalDegree_le_two`, and `exists_conicChart_openImmersion` below applies
   it.  The degree hypothesis is stated in **support form**, `∀ d ∈ g.support, d 0 + d 1 ≤ 2`,
   because that is what `IsBihomogeneousOfBidegree.affineChartEquation_leftDegree_le`
   (`BiprojectiveAffineChartDegree.lean`) delivers — it is a *weighted* degree on `Fin m ⊕ Fin n`,
   so converting it to `MvPolynomial.totalDegree` on `Fin 2` first would be extra work;
   `totalDegree_le_two_iff` then bridges the two.

The two nondegeneracy conditions are likewise stated intrinsically, on the raw `g`: the quadratic
part is the triple of coefficients at the exponents `(2,0), (1,1), (0,2)`, and the linear condition
is that the **gradient of `g` at the marked point** is nonzero, i.e. that the marked point is a
smooth point of the conic.

*Where each comes from — and a trap.*  The linear condition is smoothness of the generic fibre at
the section, for which `Hypersurface.exists_pderiv_ne_zero_at_of_smooth`
(`BiprojectiveAffineJacobian.lean`) is the field-level statement to base change to `Frac A`.

The quadratic condition is a different matter and must **not** be discharged by the same appeal.
It is not a consequence of smoothness of the *affine* model — an affine line is smooth and has zero
quadratic part — so `hsmooth` cannot be used twice.

*The heavy route, and why not to take it.*  One may argue that the quadratic condition says the
line at infinity of the `x`-chart is not contained in the conic, which holds because the
*projective* fibre is smooth, hence irreducible, hence a nondegenerate form.  That route is
blocked: Mathlib's `RingTheory/MvPolynomial/IrreducibleQuadratic.lean` covers linear forms
(`irreducible_of_totalDegree_eq_one`, `irreducible_sumSMulX`) and quadratics of the special shape
`Σ cᵢ XᵢYᵢ` (`irreducible_sumSMulXSMulY`), and lists *"prove, over a field, that a polynomial of
degree at most 2 whose quadratic part has rank at least 3 is irreducible"* among its **TODOs**.  It
is the right file and the theorem is not in it.

*The light route — now taken.*  `not_X_inl_dvd_of_smooth` above is the polynomial-level content,
and `Scheme.injective_of_isDominant_specMap` is the join from generic-point vanishing to identical
vanishing.  In outline, unfold what the condition says.  `F` is bihomogeneous
of bidegree `(2,3)`, so `F = Σ_{|a| = 2} c_a(y) x^a`, and dehomogenizing at `xᵢ = 1` makes the
quadratic part of `g` the sum of the terms with `aᵢ = 0`.  Hence `slopeQuad = 0` says exactly that
`c_a = 0` for every `a` with `aᵢ = 0`, *at the generic point of `T`* — and `t` is dominant, so those
cubic forms in `y` vanish identically.  That is to say every monomial of `F` is divisible by `xᵢ`.
But then for any `x₀` with `(x₀)ᵢ = 0` — take the unit vector at any index `≠ i`, which is already
normalized — the whole cubic fibre over `x₀` lies in `X`, i.e.
`specializeFirstCoordinates x₀ F = 0`, which
`BiprojectiveSpace.not_specializeFirstCoordinates_eq_zero_of_smooth_bidegree23` forbids for smooth
`F`.

So the quadratic condition needs only `hF`, `hF0`, `[IsAlgClosed k]`,
`[Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]` and dominance of `t` — **not** `hsmooth`, and no
irreducibility of quadratic forms.  This is the same argument, and the same tree theorem, that
`not_eq_rename_mul_rename_of_smooth` (`GoodLine.lean`) uses for the sibling degeneration
`F = Q(x) f₀(y)`; only the shape of the factor differs.

The step "vanishes at the generic point, hence identically" is
`Scheme.injective_of_isDominant_specMap`: dominance of `Spec A ⟶ Spec k[u₁,u₂]` says the kernel of
the coordinate map lies in the nilradical (`PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical`),
and `k[u₁,u₂]` is reduced, so the map is injective.  The target being reduced is what makes this
work; it is not an extra hypothesis, since the target is a polynomial ring over a field.

*The linear condition* is `slopeLin_ne_zero_of_smooth` above, and it uses smoothness of the
**fibre**, not of `X`: the tree's global-smoothness Jacobian statement
`exists_affineChartEquation_pderiv_ne_zero_at_of_global_smooth` yields a nonzero partial among all
four chart variables, and the two `y`-partials may carry it — exactly the case of a point smooth on
`X` but singular on its own fibre.  So the two conditions are genuinely established from different
inputs.

What is left for both is only the chart bookkeeping: identifying the coefficients of the
substituted equation `g` with those of `F`, and the fibre of the model over `Frac A` with the
generic fibre of `π`.
`PointedConic.eval_pderiv_zero_affineConicPoly` and its sibling identify that gradient with the
translated linear part, so nothing has to be translated by hand here either.

*On the hypotheses.*  `[IsAlgClosed k]` and `[Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]` appear
not to be needed for *this* statement: the argument above uses only `hF`, `hF0`, integrality of `T`,
dominance of `t`, density of `U`, `hsmooth` and the section, and the counterexample of the module
docstring — which is what ambient smoothness exists to exclude — leaves this conclusion intact,
breaking only the sibling leaf.  They are nevertheless **kept**.  Removing a hypothesis makes a
statement stronger and is exactly the move that made the previous version of this leaf false; the
hypotheses cost nothing, since the call site supplies them, and ambient smoothness is genuinely
needed one level up.
-/
theorem exists_chartEquation_openImmersion
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t)
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (hsmooth : Smooth (biprojectiveZeroLocusSnd 2 2 k F ∣_ U)) :
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
          ((Ideal.Quotient.mk (Ideal.span {g})).comp MvPolynomial.C)) ≫ ψ :=
  sorry

/-- **The chart computation in normal form.**

Reading `exists_chartEquation_openImmersion` through `BinaryQuadraticNormalForm`: a binary
polynomial whose exponents all have degree at most two *is* `affineConicPoly` of its six
coefficients (`eq_affineConicPoly_of_totalDegree_le_two`), so the raw chart equation can be
substituted away and the two nondegeneracy conditions become conditions on `α, β, γ` and on the
translated linear part — the latter by `eval_pderiv_zero_affineConicPoly` and its sibling, which
identify that part with the gradient at the marked point. -/
theorem exists_conicChart_openImmersion
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t)
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (hsmooth : Smooth (biprojectiveZeroLocusSnd 2 2 k F ∣_ U)) :
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
    exists_chartEquation_openImmersion F hF hF0 t s U hU hsmooth
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
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t)
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (hsmooth : Smooth (biprojectiveZeroLocusSnd 2 2 k F ∣_ U)) :
    ∃ (A : Type u) (_ : CommRing A) (_ : IsDomain A) (a b c d e' : A)
      (_ : IsDomain (PointedConic.conicRing a b c d e'))
      (_ : PointedConic.slopeQuad a b c ≠ 0) (_ : PointedConic.slopeLin d e' ≠ 0)
      (ψ : Spec (CommRingCat.of A) ⟶ T) (_ : IsOpenImmersion ψ) (_ : IsDominant ψ),
      Scheme.BirationalOver
        (Limits.pullback.snd (biprojectiveZeroLocusSnd 2 2 k F) t)
        (PointedConic.conicSchemeToSpec a b c d e' ≫ ψ) := by
  obtain ⟨A, instCR, α, β, γ, δ, ε, ζ, p₁, p₂, hp, hQ, hL,
    ψ, instOI, instDom, r₀, instR₀, hr₀⟩ :=
    exists_conicChart_openImmersion F hF hF0 t s U hU hsmooth
  letI := instCR
  haveI := instOI
  haveI := instDom
  haveI := instR₀
  -- The base change is integral, so both `A` and the affine model's ring are domains: an open
  -- subscheme of an integral scheme is integral, and the affine model is nonempty because the
  -- section gives it an `A`-point.
  haveI : IsIntegral (Limits.pullback (C := Scheme.{u}) (biprojectiveZeroLocusSnd 2 2 k F) t) :=
    isIntegral_pullback_biprojectiveZeroLocusSnd F hF hF0 t U hU hsmooth
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
theorem isPointedConicRationalOver_of_dense_open_smooth
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {T : Scheme.{u}} [IsIntegral T] (t : T ⟶ ProjectiveSpace 2 k) [IsDominant t]
    (s : PullbackSection (biprojectiveZeroLocusSnd 2 2 k F) t)
    (U : (ProjectiveSpace 2 k).Opens) (hU : Dense (U : Set (ProjectiveSpace 2 k)))
    (hsmooth : Smooth (biprojectiveZeroLocusSnd 2 2 k F ∣_ U)) :
    IsPointedConicRationalOver (biprojectiveZeroLocusSnd 2 2 k F) t s := by
  obtain ⟨A, instCR, instID, a, b, c, d, e', instCD, hQ, hL, ψ, instOI, instDom, hbir⟩ :=
    exists_pointedConicAffineModel F hF hF0 t s U hU hsmooth
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
