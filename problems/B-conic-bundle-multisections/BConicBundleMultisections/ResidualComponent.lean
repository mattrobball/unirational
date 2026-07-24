/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualImageRationalParam

/-!
# The residual component `T_L` as a scheme-theoretic image

`residualImage F` is cut out by `F` together with the residual-line covariant
`residualEquation F`, i.e. it is the complete intersection `V(F) ∩ V(q_F)`.  Over a
general `x` its fibre is the three points `C_x ∩ {q_F = 0}`, which are exactly the three
residual points, so generically it *is* the residual surface.  But the coefficients of
`q_F` are the degree-ten forms in `x`, and when they acquire a common factor `V(q_F)`
picks up a vertical divisor over that factor's zero locus.  `residualImage F` then has
components lying over curves in `P²_x` that the residual map never meets.

That is fatal for `HasUnirationalParametrization 2 (residualImageToSpec F)`: affine space
is irreducible, so the closure of its image under any rational map is irreducible, and a
dominant rational map onto a reducible target cannot exist.  The statement is not merely
hard in that case, it is false — and the main theorem quantifies over *all* smooth `F`, so
the general case is not available.  (The paper-level argument anticipates this: the class
`aH_x + H_y` is taken only "after removing their common factor and any components over
special x-curves".)

The fix is to name the component that the residual map actually dominates, namely the
scheme-theoretic image of the localized residual chart map.  Dominance onto it is then
supplied by Mathlib's `IsDominant f.toImage` instance rather than proved, and the
reducedness question disappears with it.  Only *some* rational horizontal multisection is
needed downstream, and this is one.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace ResidualDivisor
open _root_.MvPolynomial

variable {k : Type u} [Field k]
  (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
  (v : Fin 3 → Polynomial k)
  (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
  (i j : Fin 3)

/-! ### The component -/

/-- The residual component `T_L`: the scheme-theoretic image of the localized residual
chart map inside `residualImage F`.  This, rather than `residualImage F` itself, is the
surface the residual map dominates. -/
def residualComponent : Scheme.{u} :=
  (residualImagePointOfNormalizedLoc F hF v hv i j).image

/-- The closed immersion of the residual component into `residualImage F`. -/
def residualComponentι :
    residualComponent F hF v hv i j ⟶ residualImage F :=
  (residualImagePointOfNormalizedLoc F hF v hv i j).imageι

/-- Structure morphism of the residual component over `Spec k`. -/
def residualComponentToSpec :
    residualComponent F hF v hv i j ⟶ Spec (.of k) :=
  residualComponentι F hF v hv i j ≫ residualImageToSpec F

/-- The localized residual chart map, corestricted to the component it dominates. -/
def residualComponentPoint :
    Spec (.of (residualChartLoc F v i j)) ⟶ residualComponent F hF v hv i j :=
  (residualImagePointOfNormalizedLoc F hF v hv i j).toImage

/-! ### Dominance, for free -/

/-- Dominance of the corestricted residual map.  This is Mathlib's
`IsDominant f.toImage` for quasi-compact `f`; the source here is affine.  It replaces the
`WP10-dense` / `loc-dom` obligations, which targeted `residualImage F` and were therefore
attempts to prove a statement that is false whenever that scheme is reducible. -/
instance residualComponentPoint_isDominant :
    IsDominant (residualComponentPoint F hF v hv i j) :=
  inferInstanceAs (IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j).toImage)

instance residualComponentPoint_quasiCompact :
    QuasiCompact (residualComponentPoint F hF v hv i j) :=
  inferInstanceAs (QuasiCompact (residualImagePointOfNormalizedLoc F hF v hv i j).toImage)

/-! ### Compatibilities -/

/-- The corestriction composed with the closed immersion is the original residual map. -/
@[reassoc (attr := simp)]
theorem residualComponentPoint_ι :
    residualComponentPoint F hF v hv i j ≫ residualComponentι F hF v hv i j =
      residualImagePointOfNormalizedLoc F hF v hv i j :=
  Scheme.Hom.toImage_imageι _

/-- The component's structure morphism is compatible with the residual map: going down to
`Spec k` through the component agrees with going through `residualImage F`. -/
@[reassoc]
theorem residualComponentPoint_toSpec :
    residualComponentPoint F hF v hv i j ≫ residualComponentToSpec F hF v hv i j =
      residualImagePointOfNormalizedLoc F hF v hv i j ≫ residualImageToSpec F := by
  rw [residualComponentToSpec, ← Category.assoc, residualComponentPoint_ι]

/-- The component maps to the conic-bundle base through `residualImage F`. -/
def residualComponentToBase :
    residualComponent F hF v hv i j ⟶ ProjectiveSpace 2 k :=
  residualComponentι F hF v hv i j ≫ residualImageToBase F

/-! ### Transport to affine `2`-space

Mirrors the chain in `ResidualImageRationalParam` with the component as target.  Every step is
the same construction; only the codomain changes, and the dominance input is now the free
instance `residualComponentPoint_isDominant` rather than an assumed one.
-/

/-- Partial map from the affine plane onto the residual component. -/
def residualComponentPartialMap (hdenom : residualChartDenom F v i j ≠ 0) :
    (Spec (.of (affineTwoRing k))).PartialMap (residualComponent F hF v hv i j) where
  domain := residualChartBasicOpen F v i j
  dense_domain := dense_residualChartBasicOpen F v i j hdenom
  hom :=
    (basicOpenIsoSpecAway
        (R := CommRingCat.of (affineTwoRing k))
        (residualChartDenom F v i j)).hom ≫
      residualComponentPoint F hF v hv i j

/-- Composing the component partial map with the closed immersion recovers the
`residualImage`-targeted partial map. -/
theorem residualComponentPartialMap_hom_ι (hdenom : residualChartDenom F v i j ≠ 0) :
    (residualComponentPartialMap F hF v hv i j hdenom).hom ≫
        residualComponentι F hF v hv i j =
      (residualImagePartialMap F hF v hv i j hdenom).hom := by
  show ((basicOpenIsoSpecAway
      (R := CommRingCat.of (affineTwoRing k))
      (residualChartDenom F v i j)).hom ≫ residualComponentPoint F hF v hv i j) ≫
        residualComponentι F hF v hv i j = _
  rw [Category.assoc, residualComponentPoint_ι]
  rfl

instance isDominant_residualComponentPartialMap_hom
    (hdenom : residualChartDenom F v i j ≠ 0) :
    IsDominant (residualComponentPartialMap F hF v hv i j hdenom).hom := by
  show IsDominant ((basicOpenIsoSpecAway
      (R := CommRingCat.of (affineTwoRing k))
      (residualChartDenom F v i j)).hom ≫ residualComponentPoint F hF v hv i j)
  infer_instance

/-- Rational map `Spec(k[t,s]) ⤏ T_L`. -/
def residualComponentRationalMap (hdenom : residualChartDenom F v i j ≠ 0) :
    Spec (.of (affineTwoRing k)) ⤏ residualComponent F hF v hv i j :=
  (residualComponentPartialMap F hF v hv i j hdenom).toRationalMap

instance isDominant_residualComponentRationalMap
    (hdenom : residualChartDenom F v i j ≠ 0) :
    (residualComponentRationalMap F hF v hv i j hdenom).IsDominant :=
  (residualComponentPartialMap F hF v hv i j hdenom).isDominant_toRationalMap_iff.mpr
    inferInstance

/-- Rational map `𝔸² ⤏ T_L`, transported along `AffineSpace.SpecIso`. -/
def residualComponentRationalMapAffine (hdenom : residualChartDenom F v i j ≠ 0) :
    𝔸(ULift.{u} (Fin 2); Spec (.of k)) ⤏ residualComponent F hF v hv i j :=
  let e := AffineSpace.SpecIso (ULift.{u} (Fin 2)) (CommRingCat.of k)
  haveI : IsDominant e.hom := inferInstance
  haveI : e.hom.toRationalMap.IsDominant := inferInstance
  Scheme.RationalMap.comp e.hom.toRationalMap
    (residualComponentRationalMap F hF v hv i j hdenom)

instance isDominant_residualComponentRationalMapAffine
    (hdenom : residualChartDenom F v i j ≠ 0) :
    (residualComponentRationalMapAffine F hF v hv i j hdenom).IsDominant := by
  dsimp only [residualComponentRationalMapAffine]
  infer_instance

/-! ### `IsOver`: the component parametrization lies over `Spec k` -/

/-- The component partial map, postcomposed with the closed immersion, is the
`residualImage`-targeted partial map. -/
theorem residualComponentPartialMap_compHom_ι (hdenom : residualChartDenom F v i j ≠ 0) :
    (residualComponentPartialMap F hF v hv i j hdenom).compHom
        (residualComponentι F hF v hv i j) =
      residualImagePartialMap F hF v hv i j hdenom := by
  refine Scheme.PartialMap.ext _ _ rfl ?_
  change (residualComponentPartialMap F hF v hv i j hdenom).hom ≫
      residualComponentι F hF v hv i j =
    ((Spec (CommRingCat.of (affineTwoRing k))).isoOfEq
        (rfl : ((residualComponentPartialMap F hF v hv i j hdenom).compHom
            (residualComponentι F hF v hv i j)).domain =
          (residualImagePartialMap F hF v hv i j hdenom).domain)).hom ≫
      (residualImagePartialMap F hF v hv i j hdenom).hom
  simp only [Scheme.isoOfEq_rfl, Iso.refl_hom, Category.id_comp]
  exact residualComponentPartialMap_hom_ι F hF v hv i j hdenom

/-- Spec-plane level: the component rational map is a section over `Spec k`. -/
theorem residualComponentRationalMap_compHom_toSpec
    (hdenom : residualChartDenom F v i j ≠ 0) :
    (residualComponentRationalMap F hF v hv i j hdenom).compHom
        (residualComponentToSpec F hF v hv i j) =
      (Spec.map (CommRingCat.ofHom (C : k →+* affineTwoRing k))).toRationalMap := by
  have hι :
      (residualComponentRationalMap F hF v hv i j hdenom).compHom
          (residualComponentι F hF v hv i j) =
        residualImageRationalMap F hF v hv i j hdenom := by
    rw [residualComponentRationalMap, ← Scheme.RationalMap.compHom_toRationalMap,
      residualComponentPartialMap_compHom_ι]
    rfl
  rw [residualComponentToSpec, ← Scheme.RationalMap.compHom_compHom, hι]
  exact residualImageRationalMap_compHom_residualImageToSpec F hF v hv i j hdenom

/-- Affine level: transport of `IsOver` along `AffineSpace.SpecIso`. -/
theorem residualComponentRationalMapAffine_compHom_toSpec
    (hdenom : residualChartDenom F v i j ≠ 0) :
    (residualComponentRationalMapAffine F hF v hv i j hdenom).compHom
        (residualComponentToSpec F hF v hv i j) =
      (𝔸(ULift.{u} (Fin 2); Spec (.of k)) ↘ Spec (.of k)).toRationalMap := by
  dsimp only [residualComponentRationalMapAffine, residualComponentRationalMap]
  let e := AffineSpace.SpecIso (ULift.{u} (Fin 2)) (CommRingCat.of k)
  haveI : IsDominant e.hom := inferInstance
  have hcomp :
      e.hom.toRationalMap.comp
          (residualComponentPartialMap F hF v hv i j hdenom).toRationalMap =
        (e.hom.toPartialMap.comp
          (residualComponentPartialMap F hF v hv i j hdenom)).toRationalMap :=
    Scheme.RationalMap.toRationalMap_comp e.hom.toPartialMap
      (residualComponentPartialMap F hF v hv i j hdenom)
  rw [hcomp, ← Scheme.RationalMap.compHom_toRationalMap]
  have hreassoc :
      ((e.hom.toPartialMap.comp
          (residualComponentPartialMap F hF v hv i j hdenom)).compHom
        (residualComponentToSpec F hF v hv i j)) =
      e.hom.toPartialMap.comp
        ((residualComponentPartialMap F hF v hv i j hdenom).compHom
          (residualComponentToSpec F hF v hv i j)) :=
    partialMap_comp_compHom_eq _ _ _
  rw [hreassoc]
  have h1 :
      ((residualComponentPartialMap F hF v hv i j hdenom).compHom
          (residualComponentToSpec F hF v hv i j)).toRationalMap =
        (Spec.map (CommRingCat.ofHom
          (C : k →+* affineTwoRing k))).toRationalMap := by
    simpa [residualComponentRationalMap, Scheme.RationalMap.compHom_toRationalMap] using
      residualComponentRationalMap_compHom_toSpec F hF v hv i j hdenom
  have hequiv :
      ((residualComponentPartialMap F hF v hv i j hdenom).compHom
          (residualComponentToSpec F hF v hv i j)).equiv
        (Spec.map (CommRingCat.ofHom
          (C : k →+* affineTwoRing k))).toPartialMap :=
    Scheme.PartialMap.toRationalMap_eq_iff.mp h1
  have hequiv' :
      (e.hom.toPartialMap.comp
          ((residualComponentPartialMap F hF v hv i j hdenom).compHom
            (residualComponentToSpec F hF v hv i j))).equiv
        (e.hom.toPartialMap.comp
          (Spec.map (CommRingCat.ofHom
            (C : k →+* affineTwoRing k))).toPartialMap) :=
    Scheme.PartialMap.comp_equiv_of_equiv_right _ hequiv
  rw [Scheme.PartialMap.toRationalMap_eq_iff.mpr hequiv',
    Scheme.PartialMap.comp_toPartialMap, Scheme.Hom.toPartialMap_compHom,
    SpecIso_hom_comp_map_C]

/-! ### Unirationality of the residual component -/

/-- **The residual component is unirational over `Spec k`, unconditionally.**  Dominance is
Mathlib's `toImage` instance and `IsOver` is transported; the only input is a nonvanishing
chart denominator. -/
theorem hasUnirationalParametrization2_residualComponent
    (hdenom : residualChartDenom F v i j ≠ 0) :
    HasUnirationalParametrization 2 (residualComponentToSpec F hF v hv i j) :=
  ⟨{ map := residualComponentRationalMapAffine F hF v hv i j hdenom
     isDominant := isDominant_residualComponentRationalMapAffine F hF v hv i j hdenom
     isOver := residualComponentRationalMapAffine_compHom_toSpec F hF v hv i j hdenom }⟩

/-! ### The component as a multisection -/

/-- The residual component, viewed as a multisection of the conic bundle
`biprojectiveZeroLocusSnd`.  Same shape as `residualMultisection`, but carried by the
component that the residual map actually dominates. -/
def residualComponentMultisection :
    Multisection (biprojectiveZeroLocusSnd 2 2 k F) where
  carrier := residualComponent F hF v hv i j
  toBase := residualComponentToBase F hF v hv i j
  toTotal := residualComponentι F hF v hv i j ≫ residualImageToZeroLocus F
  toTotal_comp := by
    have h : residualImageToZeroLocus F ≫ biprojectiveZeroLocusSnd 2 2 k F =
        residualImageToBase F := (residualMultisection F).toTotal_comp
    rw [Category.assoc, h]
    rfl

@[simp]
theorem residualComponentMultisection_carrier :
    (residualComponentMultisection F hF v hv i j).carrier =
      residualComponent F hF v hv i j := rfl

@[simp]
theorem residualComponentMultisection_toBase :
    (residualComponentMultisection F hF v hv i j).toBase =
      residualComponentToBase F hF v hv i j := rfl

end

end BConicBundleMultisections
