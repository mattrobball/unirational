/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineZeroLocus
public import BConicBundleMultisections.BiprojectiveZeroLocusClosedPoints
public import BConicBundleMultisections.ResidualImage
public import BConicBundleMultisections.ResidualMultisectionDominant

/-!
# Residual-image points over algebras

Given an `R`-algebra `S` and normalized coordinates in `S` at which `F` and its residual
equation vanish under `aeval`, this file constructs an `S`-point
`Spec S → residualImage F` of the residual image over `R`.

This is the coefficient-extension form of `residualImagePointOfNormalized`, needed to land residual
stereo coordinates over `k[t,s]` (or a localization / fraction field) into the residual image of an
equation over `k`.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace ProjectiveSpace ResidualDivisor
open _root_.MvPolynomial

attribute [local instance] MvPolynomial.gradedAlgebra

variable {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]

/-! ### Affine chart evaluation over algebras -/

/-- Evaluating a chart variable at algebra-valued normalized coordinates recovers the coordinate. -/
theorem aeval_affineChartVariable_affineChartPoint
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (z : BiprojectiveCoordinate m n) :
    aeval (affineChartPoint i j x y) (affineChartVariable m n R i j z) =
      Sum.elim x y z := by
  rcases z with l | l
  · rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
    · simp [affineChartVariable, hxi]
    · simp [affineChartVariable, affineChartPoint]
  · rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨s, rfl⟩
    · simp [affineChartVariable, hyj]
    · simp [affineChartVariable, affineChartPoint]

/-- Algebra-valued dehomogenization agrees with the biprojective evaluation. -/
theorem aeval_affineChartEquation_affineChartPoint
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    aeval (affineChartPoint i j x y) (affineChartEquation m n R i j F) =
      aeval (Sum.elim x y) F := by
  rw [affineChartEquation, affineChartEvaluation]
  change (aeval (affineChartPoint i j x y)).comp
      (aeval (affineChartVariable m n R i j)) F =
    aeval (Sum.elim x y) F
  rw [comp_aeval]
  have hvals :
      (fun z => aeval (affineChartPoint i j x y)
        (affineChartVariable m n R i j z)) = Sum.elim x y := by
    funext z
    exact aeval_affineChartVariable_affineChartPoint m n i j x y hxi hyj z
  rw [hvals]

/-- Evaluation of the product chart ring over `R` at algebra-valued normalized coordinates. -/
def biprojectiveChartEvalAlgebra
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) :
    StandardChartRing m n R i j →+* S :=
  (aeval (affineChartPoint i j x y) :
      MvPolynomial (Fin m ⊕ Fin n) R →ₐ[R] S).toRingHom.comp
    (standardChartRingEquivMvPolynomial m n R i j).toRingHom

/-- The algebra-valued chart evaluation of the dehomogenized equation vanishes when the
biprojective evaluation vanishes. -/
theorem biprojectiveChartEvalAlgebra_chartEquation
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : aeval (Sum.elim x y) F = 0) :
    biprojectiveChartEvalAlgebra m n i j x y (chartEquation m n R i j F) = 0 := by
  simp only [biprojectiveChartEvalAlgebra, RingHom.comp_apply]
  change aeval (affineChartPoint i j x y)
      (standardChartRingEquivMvPolynomial m n R i j (chartEquation m n R i j F)) = 0
  rw [standardChartRingEquivMvPolynomial_chartEquation]
  exact (aeval_affineChartEquation_affineChartPoint m n i j x y hxi hyj F).trans hF

/-- Quotient evaluation of the chart ideal at algebra-valued normalized coordinates. -/
def affineChartQuotientEvalAlgebra
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : aeval (Sum.elim x y) F = 0) :
    (MvPolynomial (Fin m ⊕ Fin n) R ⧸
      Ideal.span {affineChartEquation m n R i j F}) →+* S :=
  Ideal.Quotient.lift _
    (aeval (affineChartPoint i j x y)).toRingHom
    (by
      intro a ha
      obtain ⟨b, hb⟩ := Ideal.mem_span_singleton.mp ha
      have hvan :
          (aeval (affineChartPoint i j x y)).toRingHom
            (affineChartEquation m n R i j F) = 0 := by
        change aeval (affineChartPoint i j x y) (affineChartEquation m n R i j F) = 0
        exact (aeval_affineChartEquation_affineChartPoint m n i j x y hxi hyj F).trans hF
      rw [hb, map_mul, hvan, zero_mul])

/-- Spec-point of a standard product chart over `R` from algebra-valued coordinates. -/
def biprojectiveChartPointOfNormalizedAlgebra
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) :
    Spec (.of S) ⟶ standardChart m n R i j :=
  Spec.map (CommRingCat.ofHom (biprojectiveChartEvalAlgebra m n i j x y)) ≫
    (standardChartIsoSpec m n R i j).inv

/-- Spec-point of the chartwise zero locus over `R` from algebra-valued coordinates. -/
def chartZeroLocusPointOfNormalizedAlgebra
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : aeval (Sum.elim x y) F = 0) :
    Spec (.of S) ⟶ (chartIdealSheaf m n R i j F).subscheme :=
  Spec.map (CommRingCat.ofHom
      (affineChartQuotientEvalAlgebra m n i j x y hxi hyj F hF)) ≫
    (chartZeroLocusIsoSpecAffineQuotient m n R i j F).inv

/-- Algebra-valued chart evaluation of a quotient class recovers chart evaluation. -/
theorem affineChartQuotientEvalAlgebra_equiv_mk_ΓIso_inv
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : aeval (Sum.elim x y) F = 0)
    (z : StandardChartRing m n R i j) :
    affineChartQuotientEvalAlgebra m n i j x y hxi hyj F hF
        (chartIdealQuotientEquivMvPolynomial m n R i j F
          (Ideal.Quotient.mk _
            ((standardChartΓIso m n R i j).inv z))) =
      biprojectiveChartEvalAlgebra m n i j x y z := by
  have hmk :
      chartIdealQuotientEquivMvPolynomial m n R i j F
          (Ideal.Quotient.mk _
            ((standardChartΓIso m n R i j).inv z)) =
        Ideal.Quotient.mk _
          (standardChartRingEquivMvPolynomial m n R i j z) := by
    unfold chartIdealQuotientEquivMvPolynomial
    rw [Ideal.quotientEquiv_mk, chartSectionsEquivMvPolynomial_ΓIso_inv]
  rw [hmk]
  rfl

set_option backward.isDefEq.respectTransparency false in
-- Chart immersion comparison rewrites through several Spec/iso composites (same as same-ring case).
set_option maxHeartbeats 800000 in
/-- The algebra-valued chart zero-locus point immerses as the ambient chart evaluation point. -/
theorem chartZeroLocusPointOfNormalizedAlgebra_subschemeι
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : aeval (Sum.elim x y) F = 0) :
    chartZeroLocusPointOfNormalizedAlgebra m n i j x y hxi hyj F hF ≫
        (chartIdealSheaf m n R i j F).subschemeι =
      biprojectiveChartPointOfNormalizedAlgebra m n i j x y := by
  apply (cancel_mono (standardChartIsoSpec m n R i j).hom).mp
  unfold chartZeroLocusPointOfNormalizedAlgebra biprojectiveChartPointOfNormalizedAlgebra
  simp only [Category.assoc]
  rw [Iso.inv_hom_id (standardChartIsoSpec m n R i j), Category.comp_id]
  rw [chartZeroLocusIsoSpecAffineQuotient_inv_eq]
  simp only [Category.assoc]
  have hpath :=
    chartSubschemeCover_subschemeι_standardChartIsoSpec_hom m n R i j F
  rw [hpath]
  rw [← Spec.map_comp, ← Spec.map_comp]
  refine congrArg Spec.map ?_
  apply ConcreteCategory.ext_apply
  intro (z : StandardChartRing m n R i j)
  exact affineChartQuotientEvalAlgebra_equiv_mk_ΓIso_inv m n i j x y hxi hyj F hF z

/-- Vanishing of a biprojective equation at algebra-valued normalized coordinates puts the ambient
chart evaluation point in the zero locus. -/
theorem biprojectiveZeroLocusIdeal_le_biprojectiveChartPointAlgebra_ker
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : aeval (Sum.elim x y) F = 0) :
    biprojectiveZeroLocusIdeal m n R F ≤
      (biprojectiveChartPointOfNormalizedAlgebra m n i j x y ≫
        standardChartι m n R i j).ker := by
  have hfac :=
    chartZeroLocusPointOfNormalizedAlgebra_subschemeι m n i j x y hxi hyj F hF
  have hchart_le :
      biprojectiveZeroLocusIdeal m n R F ≤
        (chartIdealSheaf m n R i j F).map (standardChartι m n R i j) :=
    iInf_le _ (i, j)
  have hker_chart :
      (chartIdealSheaf m n R i j F).map (standardChartι m n R i j) =
        ((chartIdealSheaf m n R i j F).subschemeι ≫
          standardChartι m n R i j).ker := by
    rw [Scheme.Hom.ker_comp, Scheme.IdealSheafData.ker_subschemeι]
  have hle_amb :
      ((chartIdealSheaf m n R i j F).subschemeι ≫ standardChartι m n R i j).ker ≤
        (biprojectiveChartPointOfNormalizedAlgebra m n i j x y ≫
          standardChartι m n R i j).ker := by
    rw [← hfac]
    exact Scheme.Hom.le_ker_comp _ _
  exact hchart_le.trans (hker_chart.le.trans hle_amb)

/-- Common vanishing of `F` and its residual equation at algebra-valued coordinates puts the
ambient chart evaluation on the residual image. -/
theorem residualImageIdeal_le_biprojectiveChartPointAlgebra_ker
    (i j : Fin 3) (x y : Fin 3 → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (hF : aeval (Sum.elim x y) F = 0)
    (hRes : aeval (Sum.elim x y) (residualEquation F) = 0) :
    residualImageIdeal F ≤
      (biprojectiveChartPointOfNormalizedAlgebra 2 2 i j x y ≫
        standardChartι 2 2 R i j).ker := by
  refine sup_le ?_ ?_
  · exact biprojectiveZeroLocusIdeal_le_biprojectiveChartPointAlgebra_ker
      2 2 i j x y hxi hyj F hF
  · exact biprojectiveZeroLocusIdeal_le_biprojectiveChartPointAlgebra_ker
      2 2 i j x y hxi hyj (residualEquation F) hRes

/-- Spec-point of the residual image over `R` from algebra-valued residual-image coordinates. -/
def residualImagePointOfNormalizedAlgebra
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (i j : Fin 3) (x y : Fin 3 → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : aeval (Sum.elim x y) F = 0)
    (hRes : aeval (Sum.elim x y) (residualEquation F) = 0) :
    Spec (.of S) ⟶ residualImage F :=
  IsClosedImmersion.lift
    (residualImageι F)
    (biprojectiveChartPointOfNormalizedAlgebra 2 2 i j x y ≫
      standardChartι 2 2 R i j)
    (by
      rw [ker_residualImageι]
      exact residualImageIdeal_le_biprojectiveChartPointAlgebra_ker
        i j x y hxi hyj F hF hRes)

@[reassoc (attr := simp)]
theorem residualImagePointOfNormalizedAlgebra_ι
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (i j : Fin 3) (x y : Fin 3 → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : aeval (Sum.elim x y) F = 0)
    (hRes : aeval (Sum.elim x y) (residualEquation F) = 0) :
    residualImagePointOfNormalizedAlgebra F i j x y hxi hyj hF hRes ≫ residualImageι F =
      biprojectiveChartPointOfNormalizedAlgebra 2 2 i j x y ≫
        standardChartι 2 2 R i j :=
  IsClosedImmersion.lift_fac _ _ _

/-- Algebra-valued chart evaluation is a section of `R → StandardChartRing` after base change. -/
theorem biprojectiveChartEvalAlgebra_comp_algebraMap
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) :
    (biprojectiveChartEvalAlgebra m n i j x y).comp
        (algebraMap R (StandardChartRing m n R i j)) =
      algebraMap R S := by
  ext r
  simp only [biprojectiveChartEvalAlgebra, RingHom.comp_apply]
  -- aeval (affineChartPoint) is an `R`-algebra map, so it fixes `C r`
  change aeval (affineChartPoint i j x y)
      (standardChartRingEquivMvPolynomial m n R i j
        (algebraMap R (StandardChartRing m n R i j) r)) =
    algebraMap R S r
  rw [(standardChartRingEquivMvPolynomial m n R i j).commutes r]
  simp [MvPolynomial.algebraMap_eq, aeval_C]

/-- Algebra residual-image point is a section of the structure map to `Spec R` after base change
along `algebraMap R S`. -/
theorem residualImagePointOfNormalizedAlgebra_toSpec
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (i j : Fin 3) (x y : Fin 3 → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (hF : aeval (Sum.elim x y) F = 0)
    (hRes : aeval (Sum.elim x y) (residualEquation F) = 0) :
    residualImagePointOfNormalizedAlgebra F i j x y hxi hyj hF hRes ≫
        residualImageToSpec F =
      Spec.map (CommRingCat.ofHom (algebraMap R S)) := by
  have hι := residualImagePointOfNormalizedAlgebra_ι F i j x y hxi hyj hF hRes
  have hring :
      (biprojectiveChartEvalAlgebra 2 2 i j x y).comp
          (algebraMap R (StandardChartRing 2 2 R i j)) =
        algebraMap R S :=
    biprojectiveChartEvalAlgebra_comp_algebraMap 2 2 i j x y
  -- residualImageToSpec = residualImageι ≫ biprojectiveSpace.toSpec
  change residualImagePointOfNormalizedAlgebra F i j x y hxi hyj hF hRes ≫
      residualImageι F ≫ BiprojectiveSpace.toSpec 2 2 R =
    Spec.map (CommRingCat.ofHom (algebraMap R S))
  rw [← Category.assoc, hι]
  -- biprojectiveChartPoint ≫ standardChartι ≫ toSpec
  -- = Spec.map (chartEval) ≫ standardChartIsoSpec.inv ≫ standardChartι ≫ toSpec
  unfold biprojectiveChartPointOfNormalizedAlgebra
  -- standardChartIsoSpec.inv ≫ standardChartι ≫ toSpec
  --   = standardChartIsoSpec.inv ≫ (standardChartIsoSpec.hom ≫ Spec.map algebraMap)
  --   = Spec.map algebraMap
  -- from standardChartIsoSpec_hom_toSpec: hom ≫ Spec.map algebraMap = ι ≫ toSpec
  have hstd := standardChartIsoSpec_hom_toSpec 2 2 R i j
  -- so ι ≫ toSpec = hom ≫ Spec.map algebraMap
  -- thus inv ≫ ι ≫ toSpec = Spec.map algebraMap
  have hinv :
      (standardChartIsoSpec 2 2 R i j).inv ≫
          standardChartι 2 2 R i j ≫ BiprojectiveSpace.toSpec 2 2 R =
        Spec.map (CommRingCat.ofHom
          (algebraMap R (StandardChartRing 2 2 R i j))) := by
    rw [← hstd, ← Category.assoc, Iso.inv_hom_id, Category.id_comp]
  calc
    (Spec.map (CommRingCat.ofHom (biprojectiveChartEvalAlgebra 2 2 i j x y)) ≫
          (standardChartIsoSpec 2 2 R i j).inv) ≫
        standardChartι 2 2 R i j ≫ BiprojectiveSpace.toSpec 2 2 R =
      Spec.map (CommRingCat.ofHom (biprojectiveChartEvalAlgebra 2 2 i j x y)) ≫
        ((standardChartIsoSpec 2 2 R i j).inv ≫
          standardChartι 2 2 R i j ≫ BiprojectiveSpace.toSpec 2 2 R) := by
      simp only [Category.assoc]
    _ = Spec.map (CommRingCat.ofHom (biprojectiveChartEvalAlgebra 2 2 i j x y)) ≫
        Spec.map (CommRingCat.ofHom
          (algebraMap R (StandardChartRing 2 2 R i j))) := by
      rw [hinv]
    _ = Spec.map (CommRingCat.ofHom
          ((biprojectiveChartEvalAlgebra 2 2 i j x y).comp
            (algebraMap R (StandardChartRing 2 2 R i j)))) := by
      rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
    _ = Spec.map (CommRingCat.ofHom (algebraMap R S)) := by
      rw [hring]

end

end BConicBundleMultisections
