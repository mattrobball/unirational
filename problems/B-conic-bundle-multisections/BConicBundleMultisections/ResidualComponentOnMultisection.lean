/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualComponentOn
public import BConicBundleMultisections.SchemeImageIntegral

/-!
# The arbitrary-line residual component as a unirational multisection

This file packages the scheme-theoretic image constructed in `ResidualComponentOn` as a
unirational surface and as a multisection of the second projection of the bidegree-`(2,3)` zero
locus.  Everything here is formal once a framed line, a polynomial parametrization of its
vertical conic, and a nonzero chart denominator have been supplied.

No horizontality or pointed-conic rationality is asserted.  Instead, the final results record the
generic proper/surjective reduction: dominance of the component over `P^2_y` implies dominance of
the projection from the corresponding base change to the original zero locus.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial

variable {k : Type u} [Field k]
  (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
  (hMN : lineFrame p₀ q₀ r * N = 1)
  (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
  (v : Fin 3 → Polynomial k)
  (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
  (i j : Fin 3)

/-! ### Structure morphisms and the localized point -/

/-- Structure morphism of the arbitrary-line residual component over `Spec k`. -/
def residualComponentOnToSpec :
    residualComponentOn p₀ q₀ r N hMN F hF v hv i j ⟶ Spec (.of k) :=
  residualComponentOnι p₀ q₀ r N hMN F hF v hv i j ≫
    biprojectiveZeroLocusToSpec 2 2 k F

/-- Projection of the arbitrary-line residual component to the conic-bundle base. -/
def residualComponentOnToBase :
    residualComponentOn p₀ q₀ r N hMN F hF v hv i j ⟶ ProjectiveSpace 2 k :=
  residualComponentOnι p₀ q₀ r N hMN F hF v hv i j ≫
    biprojectiveZeroLocusSnd 2 2 k F

/-- The dominant corestriction to the scheme-theoretic image is quasi-compact as well. -/
instance residualComponentPointOn_quasiCompact :
    QuasiCompact (residualComponentPointOn p₀ q₀ r N hMN F hF v hv i j) :=
  inferInstanceAs
    (QuasiCompact (residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j).toImage)

/-- The arbitrary-line chart localization is a domain when its inverted denominator is nonzero. -/
theorem isDomain_residualComponentOnLoc
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    IsDomain (residualComponentOnLoc p₀ q₀ r N F v i j) :=
  IsLocalization.isDomain_localization
    (powers_le_nonZeroDivisors_of_noZeroDivisors hdenom)

/-- The arbitrary-line residual component is integral: it is the scheme-theoretic image of the
spectrum of the domain obtained by localizing `k[t,s]` at a nonzero chart denominator. -/
theorem isIntegral_residualComponentOn
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    IsIntegral (residualComponentOn p₀ q₀ r N hMN F hF v hv i j) := by
  haveI := isDomain_residualComponentOnLoc p₀ q₀ r N F v i j hdenom
  exact AlgebraicGeometry.Scheme.isIntegral_image
    (residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j)

/-- The normalized zero-locus point respects the structure maps to `Spec k`. -/
theorem residualZeroLocusPointOn_toSpec :
    residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j ≫
        biprojectiveZeroLocusToSpec 2 2 k F =
      Spec.map (CommRingCat.ofHom
        (algebraMap k (residualComponentOnLoc p₀ q₀ r N F v i j))) := by
  have hι := residualZeroLocusPointOn_ι p₀ q₀ r N hMN F hF v hv i j
  have hring :
      (biprojectiveChartEvalAlgebra 2 2 i j
          (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
          (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j)).comp
        (algebraMap k (StandardChartRing 2 2 k i j)) =
      algebraMap k (residualComponentOnLoc p₀ q₀ r N F v i j) :=
    biprojectiveChartEvalAlgebra_comp_algebraMap 2 2 i j
      (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
      (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j)
  change residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j ≫
      biprojectiveZeroLocusι 2 2 k F ≫ BiprojectiveSpace.toSpec 2 2 k = _
  rw [← Category.assoc, hι]
  unfold biprojectiveChartPointOfNormalizedAlgebra
  have hstd := standardChartIsoSpec_hom_toSpec 2 2 k i j
  have hinv :
      (standardChartIsoSpec 2 2 k i j).inv ≫
          standardChartι 2 2 k i j ≫ BiprojectiveSpace.toSpec 2 2 k =
        Spec.map (CommRingCat.ofHom
          (algebraMap k (StandardChartRing 2 2 k i j))) := by
    rw [← hstd, ← Category.assoc, Iso.inv_hom_id, Category.id_comp]
  calc
    (Spec.map (CommRingCat.ofHom
          (biprojectiveChartEvalAlgebra 2 2 i j
            (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
            (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j))) ≫
        (standardChartIsoSpec 2 2 k i j).inv) ≫
        standardChartι 2 2 k i j ≫ BiprojectiveSpace.toSpec 2 2 k =
      Spec.map (CommRingCat.ofHom
          (biprojectiveChartEvalAlgebra 2 2 i j
            (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
            (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j))) ≫
        ((standardChartIsoSpec 2 2 k i j).inv ≫
          standardChartι 2 2 k i j ≫ BiprojectiveSpace.toSpec 2 2 k) := by
        simp only [Category.assoc]
    _ = Spec.map (CommRingCat.ofHom
          (biprojectiveChartEvalAlgebra 2 2 i j
            (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
            (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j))) ≫
        Spec.map (CommRingCat.ofHom
          (algebraMap k (StandardChartRing 2 2 k i j))) := by rw [hinv]
    _ = Spec.map (CommRingCat.ofHom
          ((biprojectiveChartEvalAlgebra 2 2 i j
            (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
            (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j)).comp
              (algebraMap k (StandardChartRing 2 2 k i j)))) := by
        rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
    _ = Spec.map (CommRingCat.ofHom
          (algebraMap k (residualComponentOnLoc p₀ q₀ r N F v i j))) := by rw [hring]

/-- Going through the component and then to `Spec k` recovers the localized structure map. -/
@[reassoc]
theorem residualComponentPointOn_toSpec :
    residualComponentPointOn p₀ q₀ r N hMN F hF v hv i j ≫
        residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j =
      Spec.map (CommRingCat.ofHom
        (algebraMap k (residualComponentOnLoc p₀ q₀ r N F v i j))) := by
  rw [residualComponentOnToSpec, ← Category.assoc, residualComponentPointOn_ι,
    residualZeroLocusPointOn_toSpec]

/-! ### Partial and rational parametrizations -/

/-- The chart-normalizing basic open in affine two-space. -/
def residualComponentOnBasicOpen : (Spec (.of (affineTwoRing k))).Opens :=
  PrimeSpectrum.basicOpen (residualComponentOnDenom p₀ q₀ r N F v i j)

/-- A nonzero chart denominator cuts out a dense open in affine two-space. -/
theorem dense_residualComponentOnBasicOpen
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    Dense (SetLike.coe (residualComponentOnBasicOpen p₀ q₀ r N F v i j) :
      Set (Spec (.of (affineTwoRing k)))) := by
  haveI : IsDomain (affineTwoRing k) := inferInstance
  haveI : IrreducibleSpace (Spec (.of (affineTwoRing k))) := inferInstance
  haveI : PreirreducibleSpace (Spec (.of (affineTwoRing k))) :=
    (inferInstance : IrreducibleSpace _).toPreirreducibleSpace
  have hnil : ¬ IsNilpotent (residualComponentOnDenom p₀ q₀ r N F v i j) := fun h =>
    hdenom (IsNilpotent.eq_zero h)
  have hne : PrimeSpectrum.basicOpen
      (residualComponentOnDenom p₀ q₀ r N F v i j) ≠ ⊥ :=
    mt (PrimeSpectrum.basicOpen_eq_bot_iff _).mp hnil
  have hnonempty :
      (SetLike.coe (residualComponentOnBasicOpen p₀ q₀ r N F v i j) :
        Set (Spec (.of (affineTwoRing k)))).Nonempty := by
    rw [Set.nonempty_iff_ne_empty]
    intro hempty
    apply hne
    exact TopologicalSpace.Opens.ext hempty
  exact (preirreducibleSpace_iff_open_dense _).mp inferInstance
    (residualComponentOnBasicOpen p₀ q₀ r N F v i j).isOpen hnonempty

/-- Partial map from affine two-space to the arbitrary-line residual component. -/
def residualComponentOnPartialMap
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    (Spec (.of (affineTwoRing k))).PartialMap
      (residualComponentOn p₀ q₀ r N hMN F hF v hv i j) where
  domain := residualComponentOnBasicOpen p₀ q₀ r N F v i j
  dense_domain := dense_residualComponentOnBasicOpen p₀ q₀ r N F v i j hdenom
  hom :=
    (basicOpenIsoSpecAway
      (R := CommRingCat.of (affineTwoRing k))
      (residualComponentOnDenom p₀ q₀ r N F v i j)).hom ≫
      residualComponentPointOn p₀ q₀ r N hMN F hF v hv i j

instance isDominant_residualComponentOnPartialMap_hom
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    IsDominant
      (residualComponentOnPartialMap p₀ q₀ r N hMN F hF v hv i j hdenom).hom := by
  change IsDominant
    ((basicOpenIsoSpecAway
      (R := CommRingCat.of (affineTwoRing k))
      (residualComponentOnDenom p₀ q₀ r N F v i j)).hom ≫
      residualComponentPointOn p₀ q₀ r N hMN F hF v hv i j)
  infer_instance

/-- Rational map `Spec(k[t,s]) ⤏ T_L` for the arbitrary-line component. -/
def residualComponentOnRationalMap
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    Spec (.of (affineTwoRing k)) ⤏
      residualComponentOn p₀ q₀ r N hMN F hF v hv i j :=
  (residualComponentOnPartialMap p₀ q₀ r N hMN F hF v hv i j hdenom).toRationalMap

instance isDominant_residualComponentOnRationalMap
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    (residualComponentOnRationalMap p₀ q₀ r N hMN F hF v hv i j hdenom).IsDominant :=
  (residualComponentOnPartialMap
      p₀ q₀ r N hMN F hF v hv i j hdenom).isDominant_toRationalMap_iff.mpr inferInstance

/-- Rational map from affine two-space, transported along `AffineSpace.SpecIso`. -/
def residualComponentOnRationalMapAffine
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    𝔸(ULift.{u} (Fin 2); Spec (.of k)) ⤏
      residualComponentOn p₀ q₀ r N hMN F hF v hv i j :=
  let e := AffineSpace.SpecIso (ULift.{u} (Fin 2)) (CommRingCat.of k)
  haveI : IsDominant e.hom := inferInstance
  haveI : e.hom.toRationalMap.IsDominant := inferInstance
  Scheme.RationalMap.comp e.hom.toRationalMap
    (residualComponentOnRationalMap p₀ q₀ r N hMN F hF v hv i j hdenom)

instance isDominant_residualComponentOnRationalMapAffine
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    (residualComponentOnRationalMapAffine
      p₀ q₀ r N hMN F hF v hv i j hdenom).IsDominant := by
  dsimp only [residualComponentOnRationalMapAffine]
  infer_instance

/-- The partial parametrization followed by the component structure map is the localized
structure morphism. -/
theorem residualComponentOnPartialMap_hom_toSpec
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    (residualComponentOnPartialMap p₀ q₀ r N hMN F hF v hv i j hdenom).hom ≫
        residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j =
      (basicOpenIsoSpecAway
        (R := CommRingCat.of (affineTwoRing k))
        (residualComponentOnDenom p₀ q₀ r N F v i j)).hom ≫
        Spec.map (CommRingCat.ofHom
          (algebraMap k (residualComponentOnLoc p₀ q₀ r N F v i j))) := by
  dsimp [residualComponentOnPartialMap]
  rw [Category.assoc, residualComponentPointOn_toSpec]
  rfl

/-- The Spec-plane rational parametrization lies over `Spec k`. -/
theorem residualComponentOnRationalMap_compHom_toSpec
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    (residualComponentOnRationalMap p₀ q₀ r N hMN F hF v hv i j hdenom).compHom
        (residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j) =
      (Spec.map (CommRingCat.ofHom (C : k →+* affineTwoRing k))).toRationalMap := by
  dsimp only [residualComponentOnRationalMap]
  rw [← Scheme.RationalMap.compHom_toRationalMap]
  let X : Scheme.{u} := Spec (.of (affineTwoRing k))
  let φ : X.PartialMap
      (residualComponentOn p₀ q₀ r N hMN F hF v hv i j) :=
    residualComponentOnPartialMap p₀ q₀ r N hMN F hF v hv i j hdenom
  let f : X.PartialMap (Spec (.of k)) :=
    φ.compHom (residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j)
  let sC : X ⟶ Spec (.of k) :=
    Spec.map (CommRingCat.ofHom (C : k →+* affineTwoRing k))
  let g : X.PartialMap (Spec (.of k)) := sC.toPartialMap
  change f.toRationalMap = g.toRationalMap
  refine Scheme.PartialMap.toRationalMap_eq_iff.mpr ?_
  refine ⟨f.domain, f.dense_domain, le_rfl, le_top, ?_⟩
  have hhom : f.hom = f.domain.ι ≫ sC := by
    dsimp [f, φ, Scheme.PartialMap.compHom]
    rw [residualComponentOnPartialMap_hom_toSpec]
    change
      (basicOpenIsoSpecAway
        (R := CommRingCat.of (affineTwoRing k))
        (residualComponentOnDenom p₀ q₀ r N F v i j)).hom ≫
        Spec.map (CommRingCat.ofHom
          ((algebraMap (affineTwoRing k)
              (residualComponentOnLoc p₀ q₀ r N F v i j)).comp
            (C : k →+* affineTwoRing k))) =
      (residualComponentOnPartialMap p₀ q₀ r N hMN F hF v hv i j hdenom).domain.ι ≫ sC
    rw [CommRingCat.ofHom_comp, Spec.map_comp, ← Category.assoc,
      basicOpenIsoSpecAway_hom_SpecMap]
    rfl
  change X.homOfLE (le_rfl : f.domain ≤ f.domain) ≫ f.hom =
    X.homOfLE (le_top : f.domain ≤ ⊤) ≫ g.hom
  have hg : g.hom = X.topIso.hom ≫ sC := rfl
  rw [Scheme.homOfLE_rfl, Category.id_comp, hhom, hg]
  have hι : f.domain.ι =
      X.homOfLE (le_top : f.domain ≤ ⊤) ≫ X.topIso.hom := by
    rw [Scheme.topIso_hom]
    exact (Scheme.homOfLE_ι X (le_top : f.domain ≤ ⊤)).symm
  rw [hι, Category.assoc]

/-- The affine-space rational parametrization lies over `Spec k`. -/
theorem residualComponentOnRationalMapAffine_compHom_toSpec
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    (residualComponentOnRationalMapAffine
      p₀ q₀ r N hMN F hF v hv i j hdenom).compHom
        (residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j) =
      (𝔸(ULift.{u} (Fin 2); Spec (.of k)) ↘ Spec (.of k)).toRationalMap := by
  dsimp only [residualComponentOnRationalMapAffine, residualComponentOnRationalMap]
  let e := AffineSpace.SpecIso (ULift.{u} (Fin 2)) (CommRingCat.of k)
  haveI : IsDominant e.hom := inferInstance
  have hcomp :
      e.hom.toRationalMap.comp
          (residualComponentOnPartialMap
            p₀ q₀ r N hMN F hF v hv i j hdenom).toRationalMap =
        (e.hom.toPartialMap.comp
          (residualComponentOnPartialMap
            p₀ q₀ r N hMN F hF v hv i j hdenom)).toRationalMap :=
    Scheme.RationalMap.toRationalMap_comp e.hom.toPartialMap
      (residualComponentOnPartialMap p₀ q₀ r N hMN F hF v hv i j hdenom)
  rw [hcomp, ← Scheme.RationalMap.compHom_toRationalMap]
  have hreassoc :
      ((e.hom.toPartialMap.comp
          (residualComponentOnPartialMap
            p₀ q₀ r N hMN F hF v hv i j hdenom)).compHom
        (residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j)) =
      e.hom.toPartialMap.comp
        ((residualComponentOnPartialMap
          p₀ q₀ r N hMN F hF v hv i j hdenom).compHom
          (residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j)) :=
    partialMap_comp_compHom_eq _ _ _
  rw [hreassoc]
  have h1 :
      ((residualComponentOnPartialMap
        p₀ q₀ r N hMN F hF v hv i j hdenom).compHom
          (residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j)).toRationalMap =
        (Spec.map (CommRingCat.ofHom
          (C : k →+* affineTwoRing k))).toRationalMap := by
    simpa [residualComponentOnRationalMap,
      Scheme.RationalMap.compHom_toRationalMap] using
        residualComponentOnRationalMap_compHom_toSpec
          p₀ q₀ r N hMN F hF v hv i j hdenom
  have hequiv :
      ((residualComponentOnPartialMap
        p₀ q₀ r N hMN F hF v hv i j hdenom).compHom
          (residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j)).equiv
        (Spec.map (CommRingCat.ofHom
          (C : k →+* affineTwoRing k))).toPartialMap :=
    Scheme.PartialMap.toRationalMap_eq_iff.mp h1
  have hequiv' :
      (e.hom.toPartialMap.comp
          ((residualComponentOnPartialMap
            p₀ q₀ r N hMN F hF v hv i j hdenom).compHom
            (residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j))).equiv
        (e.hom.toPartialMap.comp
          (Spec.map (CommRingCat.ofHom
            (C : k →+* affineTwoRing k))).toPartialMap) :=
    Scheme.PartialMap.comp_equiv_of_equiv_right _ hequiv
  rw [Scheme.PartialMap.toRationalMap_eq_iff.mpr hequiv',
    Scheme.PartialMap.comp_toPartialMap, Scheme.Hom.toPartialMap_compHom,
    SpecIso_hom_comp_map_C]

/-- A nonzero arbitrary-line chart gives a dominant two-dimensional parametrization of its
scheme-theoretic residual component. -/
theorem hasUnirationalParametrization2_residualComponentOn
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0) :
    HasUnirationalParametrization 2
      (residualComponentOnToSpec p₀ q₀ r N hMN F hF v hv i j) :=
  ⟨{ map := residualComponentOnRationalMapAffine
        p₀ q₀ r N hMN F hF v hv i j hdenom
     isDominant := isDominant_residualComponentOnRationalMapAffine
        p₀ q₀ r N hMN F hF v hv i j hdenom
     isOver := residualComponentOnRationalMapAffine_compHom_toSpec
        p₀ q₀ r N hMN F hF v hv i j hdenom }⟩

/-! ### The arbitrary-line component as a multisection -/

/-- The arbitrary-line residual component as a multisection of the conic projection. -/
def residualComponentOnMultisection :
    Multisection (biprojectiveZeroLocusSnd 2 2 k F) where
  carrier := residualComponentOn p₀ q₀ r N hMN F hF v hv i j
  toBase := residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j
  toTotal := residualComponentOnι p₀ q₀ r N hMN F hF v hv i j
  toTotal_comp := rfl

@[simp]
theorem residualComponentOnMultisection_carrier :
    (residualComponentOnMultisection p₀ q₀ r N hMN F hF v hv i j).carrier =
      residualComponentOn p₀ q₀ r N hMN F hF v hv i j := rfl

@[simp]
theorem residualComponentOnMultisection_toBase :
    (residualComponentOnMultisection p₀ q₀ r N hMN F hF v hv i j).toBase =
      residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j := rfl

/-- Going to the base through the component agrees with the explicit localized residual point. -/
@[reassoc]
theorem residualComponentPointOn_toBase :
    residualComponentPointOn p₀ q₀ r N hMN F hF v hv i j ≫
        residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j =
      residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j ≫
        biprojectiveZeroLocusSnd 2 2 k F := by
  rw [residualComponentOnToBase, ← Category.assoc, residualComponentPointOn_ι]

/-- Component horizontality is equivalent to dominance of the explicit localized residual map
to the base. -/
theorem isDominant_residualComponentOnToBase_iff :
    IsDominant (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j) ↔
      IsDominant (residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j ≫
        biprojectiveZeroLocusSnd 2 2 k F) := by
  rw [← residualComponentPointOn_toBase]
  exact (IsDominant.comp_iff
    (residualComponentPointOn p₀ q₀ r N hMN F hF v hv i j)
    (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j)).symm

/-- The arbitrary-line component inclusion is a closed immersion. -/
instance residualComponentOnι_isClosedImmersion :
    IsClosedImmersion (residualComponentOnι p₀ q₀ r N hMN F hF v hv i j) :=
  inferInstanceAs
    (IsClosedImmersion
      (Scheme.Hom.ker (residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j)).subschemeι)

/-- The map from the arbitrary-line residual component to the base is proper. -/
instance residualComponentOnToBase_isProper :
    IsProper (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j) := by
  unfold residualComponentOnToBase
  infer_instance

/-- Proper dominance of the component over the projective base upgrades to surjectivity. -/
theorem surjective_residualComponentOnToBase
    (hdom : IsDominant
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j)) :
    Surjective (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j) := by
  haveI := hdom
  exact Surjective.of_universallyClosed_of_isDominant _

/-- Dominance of the component over the base implies dominance of the base-change projection to
the original zero locus, via properness and stability of surjectivity under pullback. -/
theorem isDominant_residualComponentOnMultisection_baseChangeFst
    (hdom : IsDominant
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j)) :
    IsDominant
      (residualComponentOnMultisection p₀ q₀ r N hMN F hF v hv i j).baseChangeFst := by
  haveI : Surjective
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j) :=
    surjective_residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j hdom
  haveI : Surjective
      (residualComponentOnMultisection
        p₀ q₀ r N hMN F hF v hv i j).baseChangeFst := by
    change Surjective (Limits.pullback.fst (biprojectiveZeroLocusSnd 2 2 k F)
      (residualComponentOnToBase p₀ q₀ r N hMN F hF v hv i j))
    infer_instance
  infer_instance

end

end BConicBundleMultisections
