/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualComponentOn
public import BConicBundleMultisections.ResidualEquationBidegree
public import BConicBundleMultisections.ResidualHorizontalityLineAudit
public import BConicBundleMultisections.ProjectiveSpaceChartDominance
public import BConicBundleMultisections.JacobianCriterionCharFree
public import Mathlib.AlgebraicGeometry.Morphisms.ClosedImmersion
public import Mathlib.Data.Fintype.EquivFin

/-!
# Exhausting a reduced complete intersection by its generic points

The degree-three residual argument has a short scheme-theoretic endpoint.  If a chosen closed
component contains the generic point of every irreducible component of the ambient complete
intersection, then its closed image is dense and hence is the whole underlying space.  When the
ambient scheme is reduced, the resulting surjective closed immersion is an isomorphism.

This lemma deliberately does not assert that a reduced three-point generic fibre supplies the
generic-point hypothesis.  That preceding step needs an actual finite generic-fibre object, its
length/degree-three computation, and injectivity of the tangent-residual map on the three line
section points.
-/

@[expose] public section

open CategoryTheory Topology TopologicalSpace
open scoped AlgebraicGeometry Matrix
open AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial BiprojectiveSpace ResidualDivisor
open _root_.MvPolynomial Localization

attribute [local instance] MvPolynomial.gradedAlgebra

/-! ### Coefficient extension for the arbitrary-frame residual equation -/

/-- Second-block linear substitution commutes with extension of coefficients. -/
theorem map_secondBlockSubst
    {R S : Type u} [CommRing R] [CommRing S] (φ : R →+* S)
    (M : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    secondBlockSubst (M.map φ) (map φ F) = map φ (secondBlockSubst M F) := by
  induction F using MvPolynomial.induction_on with
  | C a => simp
  | add F G hF hG => simp [hF, hG]
  | mul_X F z hF =>
      cases z with
      | inl i => simp [hF]
      | inr j => simp [hF, map_sum]

/-- The arbitrary-frame residual equation commutes with extension of coefficients. -/
theorem map_residualEquationOn
    {R S : Type u} [CommRing R] [CommRing S] (φ : R →+* S)
    (M N : Matrix (Fin 3) (Fin 3) R)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R) :
    residualEquationOn (M.map φ) (N.map φ) (map φ F) =
      map φ (residualEquationOn M N F) := by
  simp only [residualEquationOn, map_secondBlockSubst, map_residualEquation]

/-! ### The vertical complete intersection `X_H` -/

/-- The ideal sheaf cutting out `X_H = V(F,H(y))` in biprojective space. -/
def targetRelationIdeal
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) :
    (BiprojectiveSpace 2 2 k).IdealSheafData :=
  biprojectiveZeroLocusIdeal 2 2 k F ⊔
    biprojectiveZeroLocusIdeal 2 2 k
      (rename (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H)

/-- The vertical complete intersection `X_H = V(F,H(y))`. -/
abbrev targetRelationZeroLocus
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) : Scheme.{u} :=
  (targetRelationIdeal F H).subscheme

/-- Canonical closed immersion of `X_H` into biprojective space. -/
abbrev targetRelationι
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) :
    targetRelationZeroLocus F H ⟶ BiprojectiveSpace 2 2 k :=
  (targetRelationIdeal F H).subschemeι

theorem ker_targetRelationι
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) :
    (targetRelationι F H).ker = targetRelationIdeal F H :=
  Scheme.IdealSheafData.ker_subschemeι _

/-- Projection `X_H → P²_x`. -/
def targetRelationToFirst
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) :
    targetRelationZeroLocus F H ⟶ ProjectiveSpace 2 k :=
  targetRelationι F H ≫ BiprojectiveSpace.fst 2 2 k

/-- Algebra-valued normalized common zero of `F` and `H(y)` as a point of `X_H`. -/
def targetRelationPointOfNormalizedAlgebra
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (i j : Fin 3) (x y : Fin 3 → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (H : MvPolynomial (Fin 3) R)
    (hF : aeval (Sum.elim x y) F = 0) (hH : aeval y H = 0) :
    Spec (.of S) ⟶ targetRelationZeroLocus F H :=
  IsClosedImmersion.lift
    (targetRelationι F H)
    (biprojectiveChartPointOfNormalizedAlgebra 2 2 i j x y ≫
      standardChartι 2 2 R i j)
    (by
      rw [ker_targetRelationι]
      refine sup_le ?_ ?_
      · exact biprojectiveZeroLocusIdeal_le_biprojectiveChartPointAlgebra_ker
          2 2 i j x y hxi hyj F hF
      · apply biprojectiveZeroLocusIdeal_le_biprojectiveChartPointAlgebra_ker
          2 2 i j x y hxi hyj
        have hcomp : Sum.elim x y ∘
            (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) = y := by
          funext a
          rfl
        simpa only [aeval_rename, hcomp] using hH)

@[reassoc (attr := simp)]
theorem targetRelationPointOfNormalizedAlgebra_ι
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (i j : Fin 3) (x y : Fin 3 → S)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) R)
    (H : MvPolynomial (Fin 3) R)
    (hF : aeval (Sum.elim x y) F = 0) (hH : aeval y H = 0) :
    targetRelationPointOfNormalizedAlgebra i j x y hxi hyj F H hF hH ≫
        targetRelationι F H =
      biprojectiveChartPointOfNormalizedAlgebra 2 2 i j x y ≫
        standardChartι 2 2 R i j :=
  IsClosedImmersion.lift_fac _ _ _

/-! ### Transporting a target relation through localization and normalization -/

/-- Homogeneous vanishing survives normalization by a unit coordinate. -/
theorem aeval_scaleByUnitInv_eq_zero_of_isHomogeneous
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    {σ : Type*} {H : MvPolynomial σ R} {d : ℕ}
    (hH : H.IsHomogeneous d) (y : σ → S) (j : σ) (hj : IsUnit (y j))
    (hy : aeval y H = 0) :
    aeval (scaleByUnitInv y j hj) H = 0 := by
  rw [scaleByUnitInv_eq_smul, Pi.smul_def]
  simp only [smul_eq_mul]
  let c : S := ↑hj.unit⁻¹
  calc
    aeval (fun a => c * y a) H =
        eval (fun a => c * y a) (map (algebraMap R S) H) := by
      rw [aeval_def, eval₂_eq_eval_map]
    _ = c ^ d * eval y (map (algebraMap R S) H) := by
      simpa [Pi.smul_def, smul_eq_mul] using
        eval_smul_point_of_isHomogeneous (hH.map (algebraMap R S)) c y
    _ = c ^ d * aeval y H := by rw [aeval_def, eval₂_eq_eval_map]
    _ = 0 := by rw [hy, mul_zero]

/-- A target relation vanishing on the raw residual coordinates still vanishes after passing to
the chart localization. -/
theorem aeval_residualComponentOnYCoordsLoc_targetRelation
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    (H : MvPolynomial (Fin 3) k)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    aeval (residualComponentOnYCoordsLoc p₀ q₀ r N F v i j) H = 0 := by
  let xLoc := residualComponentOnXCoordsLoc p₀ q₀ r N F v i j
  let yLoc := residualComponentOnYCoordsLoc p₀ q₀ r N F v i j
  let xRaw := stereoFirstCoordsOn p₀ q₀ F v
  let yRaw := residualYCoordsOn p₀ q₀ r N F v
  have hloc : Sum.elim xLoc yLoc ∘
      (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) = yLoc := by
    funext a
    rfl
  have hraw : Sum.elim xRaw yRaw ∘
      (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) = yRaw := by
    funext a
    rfl
  calc
    aeval yLoc H = aeval (Sum.elim xLoc yLoc)
        (rename (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H) := by
      simpa only [aeval_rename, hloc]
    _ = algebraMap (affineTwoRing k)
          (residualComponentOnLoc p₀ q₀ r N F v i j)
          (aeval (Sum.elim xRaw yRaw)
            (rename (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H)) :=
      aeval_residualComponentOnLoc_coords p₀ q₀ r N F v i j _
    _ = algebraMap (affineTwoRing k)
          (residualComponentOnLoc p₀ q₀ r N F v i j) (aeval yRaw H) := by
      rw [aeval_rename, hraw]
    _ = 0 := by rw [hvan, map_zero]

/-- A homogeneous target relation vanishing on the raw residual coordinates also vanishes on the
normalized coordinates used by the scheme morphism. -/
theorem aeval_residualComponentOnYCoordsNorm_targetRelation
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    {d : ℕ} (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    aeval (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j) H = 0 := by
  exact aeval_scaleByUnitInv_eq_zero_of_isHomogeneous hH
    (residualComponentOnYCoordsLoc p₀ q₀ r N F v i j) j
    (isUnit_residualComponentOnYCoordsLoc p₀ q₀ r N F v i j)
    (aeval_residualComponentOnYCoordsLoc_targetRelation
      p₀ q₀ r N F v i j H hvan)

/-! ### First-coordinate normalization and algebraic independence -/

/-- Evaluation at the localized first-block coordinates is the localization of evaluation at the
raw stereographic coordinates. -/
theorem aeval_residualComponentOnXCoordsLoc
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    (Ψ : MvPolynomial (Fin 3) k) :
    aeval (residualComponentOnXCoordsLoc p₀ q₀ r N F v i j) Ψ =
      algebraMap (affineTwoRing k) (residualComponentOnLoc p₀ q₀ r N F v i j)
        (aeval (stereoFirstCoordsOn p₀ q₀ F v) Ψ) := by
  induction Ψ using MvPolynomial.induction_on with
  | C a =>
      simp only [aeval_C, algebraMap_k_residualComponentOnLoc, algebraMap_eq]
  | add P Q hP hQ =>
      simp only [map_add, hP, hQ]
  | mul_X P z hP =>
      simp only [map_mul, aeval_X, hP, residualComponentOnXCoordsLoc]

/-- Localization and normalization introduce no new homogeneous relation among the first-block
coordinates when the chosen chart denominator is nonzero. -/
theorem eq_zero_of_aeval_residualComponentOnXCoordsNorm_of_isHomogeneous
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0)
    (hcore : ∀ (d : ℕ) (Ψ : MvPolynomial (Fin 3) k), Ψ.IsHomogeneous d →
      aeval (stereoFirstCoordsOn p₀ q₀ F v) Ψ = 0 → Ψ = 0)
    (d : ℕ) (Ψ : MvPolynomial (Fin 3) k) (hΨ : Ψ.IsHomogeneous d)
    (hvan : aeval (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j) Ψ = 0) :
    Ψ = 0 := by
  have hunit := isUnit_residualComponentOnXCoordsLoc p₀ q₀ r N F v i j
  have hnorm : residualComponentOnXCoordsNorm p₀ q₀ r N F v i j =
      fun a ↦
        (↑hunit.unit⁻¹ : residualComponentOnLoc p₀ q₀ r N F v i j) *
          residualComponentOnXCoordsLoc p₀ q₀ r N F v i j a := rfl
  rw [hnorm, aeval_smul_point_of_isHomogeneous hΨ,
    aeval_residualComponentOnXCoordsLoc] at hvan
  have hscale : IsUnit
      ((↑hunit.unit⁻¹ : residualComponentOnLoc p₀ q₀ r N F v i j) ^ d) :=
    (Units.isUnit hunit.unit⁻¹).pow d
  have hloc : algebraMap (affineTwoRing k)
      (residualComponentOnLoc p₀ q₀ r N F v i j)
      (aeval (stereoFirstCoordsOn p₀ q₀ F v) Ψ) = 0 :=
    (hscale.mul_right_eq_zero).mp hvan
  have hinj : Function.Injective
      (algebraMap (affineTwoRing k)
        (residualComponentOnLoc p₀ q₀ r N F v i j)) :=
    IsLocalization.injective
      (M := Submonoid.powers (residualComponentOnDenom p₀ q₀ r N F v i j))
      (residualComponentOnLoc p₀ q₀ r N F v i j)
      (powers_le_nonZeroDivisors_of_noZeroDivisors hdenom)
  exact hcore d Ψ hΨ (hinj (by rw [hloc, map_zero]))

/-- Absence of homogeneous relations among the raw stereographic coordinates makes the
normalized first-chart evaluation injective. -/
theorem injective_standardChartEvalAlgebra_residualComponentOnXCoordsNorm
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0)
    (hcore : ∀ (d : ℕ) (Ψ : MvPolynomial (Fin 3) k), Ψ.IsHomogeneous d →
      aeval (stereoFirstCoordsOn p₀ q₀ F v) Ψ = 0 → Ψ = 0) :
    Function.Injective
      (ProjectiveSpace.standardChartEvalAlgebra (R := k) 2 i
        (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)) := by
  have haff : Function.Injective
      (aeval (ProjectiveSpace.affineCoordinates i
        (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)) :
          MvPolynomial (Fin 2) k →ₐ[k] residualComponentOnLoc p₀ q₀ r N F v i j) :=
    ProjectiveSpace.injective_aeval_affineCoordinates (R := k) i
      (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
      (residualComponentOnXCoordsNorm_apply p₀ q₀ r N F v i j)
      (fun d Ψ hΨ hvan ↦
        eq_zero_of_aeval_residualComponentOnXCoordsNorm_of_isHomogeneous
          p₀ q₀ r N F v i j hdenom hcore d Ψ hΨ hvan)
  intro a b hab
  exact (ProjectiveSpace.standardChartRingEquivMvPolynomial 2 k i).injective (haff hab)

/-- A spectrum map induced by an injective ring map is dominant. -/
theorem isDominant_specMap_of_injective_for_exhaustion
    {R S : CommRingCat.{u}} (φ : R ⟶ S) (h : Function.Injective φ.hom) :
    IsDominant (Spec.map φ) := by
  rw [isDominant_iff]
  refine (PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical (f := φ.hom)).mpr ?_
  intro a ha
  simp only [RingHom.mem_ker] at ha
  have hazero : a = 0 := h (by simpa using ha)
  simp [hazero]

/-- An algebra-valued projective point is dominant when its standard-chart evaluation and the
standard chart itself are dominant. -/
theorem isDominant_projectivePointOfNormalizedAlgebra_of_injective
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (n : ℕ) (i : Fin (n + 1)) (x : Fin (n + 1) → S)
    (hchart : IsDominant (ProjectiveSpace.standardChartι n R i))
    (hinj : Function.Injective
      (ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x)) :
    IsDominant (ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := R) n i x) := by
  unfold ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra
  haveI := hchart
  haveI : IsDominant
      (Spec.map (CommRingCat.ofHom
        (ProjectiveSpace.standardChartEvalAlgebra (R := R) n i x))) :=
    isDominant_specMap_of_injective_for_exhaustion _ hinj
  infer_instance

/-! ### The residual chart and its component inside `X_H` -/

/-- The normalized arbitrary-line residual chart, corestricted to `X_H` under the explicit target
relation. -/
def residualTargetPointOn
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    Spec (.of (residualComponentOnLoc p₀ q₀ r N F v i j)) ⟶
      targetRelationZeroLocus F H :=
  targetRelationPointOfNormalizedAlgebra i j
    (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
    (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j)
    (residualComponentOnXCoordsNorm_apply p₀ q₀ r N F v i j)
    (residualComponentOnYCoordsNorm_apply p₀ q₀ r N F v i j)
    F H (aeval_residualComponentOnCoordsNorm_F p₀ q₀ r N hMN F hF v hv i j)
    (aeval_residualComponentOnYCoordsNorm_targetRelation
      p₀ q₀ r N F v i j H hH hvan)

/-- The residual chart inside `X_H`, followed by the first projection, is the projective point of
its normalized stereographic first-block coordinates. -/
theorem residualTargetPointOn_toFirst
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    residualTargetPointOn p₀ q₀ r N hMN F hF v hv i j H hH hvan ≫
        targetRelationToFirst F H =
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) 2 i
        (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j) := by
  unfold targetRelationToFirst
  rw [← Category.assoc]
  unfold residualTargetPointOn
  rw [targetRelationPointOfNormalizedAlgebra_ι]
  exact biprojectiveChartPointOfNormalizedAlgebra_comp_standardChartι_fst
    (R := k) (S := residualComponentOnLoc p₀ q₀ r N F v i j)
    2 2 i j
    (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
    (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j)

/-- Scheme-theoretic residual component formed inside `X_H`. -/
def residualTargetComponentOn
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) : Scheme.{u} :=
  (residualTargetPointOn p₀ q₀ r N hMN F hF v hv i j H hH hvan).image

/-- Closed immersion of the residual target component into `X_H`. -/
def residualTargetComponentOnι
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    residualTargetComponentOn p₀ q₀ r N hMN F hF v hv i j H hH hvan ⟶
      targetRelationZeroLocus F H :=
  (residualTargetPointOn p₀ q₀ r N hMN F hF v hv i j H hH hvan).imageι

instance residualTargetComponentOnι_isClosedImmersion
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    IsClosedImmersion
      (residualTargetComponentOnι p₀ q₀ r N hMN F hF v hv i j H hH hvan) :=
  inferInstanceAs
    (IsClosedImmersion
      (residualTargetPointOn p₀ q₀ r N hMN F hF v hv i j H hH hvan).imageι)

/-- The localized residual chart corestricted to its scheme-theoretic image inside `X_H`. -/
def residualTargetComponentPointOn
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    Spec (.of (residualComponentOnLoc p₀ q₀ r N F v i j)) ⟶
      residualTargetComponentOn p₀ q₀ r N hMN F hF v hv i j H hH hvan :=
  (residualTargetPointOn p₀ q₀ r N hMN F hF v hv i j H hH hvan).toImage

instance residualTargetComponentPointOn_isDominant
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    IsDominant
      (residualTargetComponentPointOn
        p₀ q₀ r N hMN F hF v hv i j H hH hvan) :=
  inferInstanceAs
    (IsDominant
      (residualTargetPointOn p₀ q₀ r N hMN F hF v hv i j H hH hvan).toImage)

@[reassoc (attr := simp)]
theorem residualTargetComponentPointOn_ι
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    residualTargetComponentPointOn
        p₀ q₀ r N hMN F hF v hv i j H hH hvan ≫
      residualTargetComponentOnι
        p₀ q₀ r N hMN F hF v hv i j H hH hvan =
      residualTargetPointOn p₀ q₀ r N hMN F hF v hv i j H hH hvan :=
  Scheme.Hom.toImage_imageι _

/-- First projection of the residual component formed inside `X_H`. -/
def residualTargetComponentOnToFirst
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    residualTargetComponentOn p₀ q₀ r N hMN F hF v hv i j H hH hvan ⟶
      ProjectiveSpace 2 k :=
  residualTargetComponentOnι p₀ q₀ r N hMN F hF v hv i j H hH hvan ≫
    targetRelationToFirst F H

/-- Going to the first projective factor through the residual component agrees with going there
directly from the localized residual chart. -/
@[reassoc]
theorem residualTargetComponentPointOn_toFirst
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    residualTargetComponentPointOn
        p₀ q₀ r N hMN F hF v hv i j H hH hvan ≫
      residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hH hvan =
      residualTargetPointOn p₀ q₀ r N hMN F hF v hv i j H hH hvan ≫
        targetRelationToFirst F H := by
  rw [residualTargetComponentOnToFirst, ← Category.assoc,
    residualTargetComponentPointOn_ι]

/-- Dominance of the residual component over `P²_x` is equivalent to dominance of its explicit
localized chart map. -/
theorem isDominant_residualTargetComponentOnToFirst_iff
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    IsDominant
        (residualTargetComponentOnToFirst
          p₀ q₀ r N hMN F hF v hv i j H hH hvan) ↔
      IsDominant
        (residualTargetPointOn p₀ q₀ r N hMN F hF v hv i j H hH hvan ≫
          targetRelationToFirst F H) := by
  rw [← residualTargetComponentPointOn_toFirst]
  exact
    (IsDominant.comp_iff
      (residualTargetComponentPointOn
        p₀ q₀ r N hMN F hF v hv i j H hH hvan)
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hH hvan)).symm

/-- Smoothness and `v 2 ≠ 0` make the explicit residual chart dominate the first projective
factor.  This is the scheme-level consumer of the positive first-coordinate Jacobian audit. -/
theorem isDominant_residualTargetPointOn_toFirst_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0) (i j : Fin 3)
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0)
    {d : ℕ} (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    IsDominant
      (residualTargetPointOn p₀ q₀ r N hMN F hF v hv i j H hH hvan ≫
        targetRelationToFirst F H) := by
  rw [residualTargetPointOn_toFirst]
  exact isDominant_projectivePointOfNormalizedAlgebra_of_injective 2 i _
    (ProjectiveSpace.isDominant_standardChartι 2 k i)
    (injective_standardChartEvalAlgebra_residualComponentOnXCoordsNorm
      p₀ q₀ r N F v i j hdenom
      (fun d Ψ hΨ hΨvan ↦
        eq_zero_of_isHomogeneous_of_aeval_eq_zero_of_perfectField
          (stereoFirstCoordsOn p₀ q₀ F v) (ULift.up 0) (ULift.up 1)
          (det_stereoFirstCoordsOn_ne_zero_of_smooth_of_two_ne_zero
            p₀ q₀ r N hMN F hF hF0 v hv hv2)
          d Ψ hΨ hΨvan))

/-- Under the same hypotheses, the scheme-theoretic residual component inside `X_H` dominates
`P²_x`. -/
theorem isDominant_residualTargetComponentOnToFirst_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0) (i j : Fin 3)
    (hdenom : residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0)
    {d : ℕ} (H : MvPolynomial (Fin 3) k) (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    IsDominant
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hH hvan) :=
  (isDominant_residualTargetComponentOnToFirst_iff
    p₀ q₀ r N hMN F hF v hv i j H hH hvan).mpr
      (isDominant_residualTargetPointOn_toFirst_of_smooth
        p₀ q₀ r N hMN F hF hF0 v hv hv2 i j hdenom H hH hvan)

/-- The first projection of the residual component inside `X_H` is proper. -/
instance residualTargetComponentOnToFirst_isProper
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0) :
    IsProper
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hH hvan) := by
  unfold residualTargetComponentOnToFirst targetRelationToFirst
  infer_instance

/-- Proper dominance upgrades the first projection of the residual component to surjectivity. -/
theorem surjective_residualTargetComponentOnToFirst
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0)
    (hdom : IsDominant
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hH hvan)) :
    Surjective
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hH hvan) := by
  haveI := hdom
  exact Surjective.of_universallyClosed_of_isDominant _

/-- The underlying set-theoretic fibre of a scheme morphism over a point.  This intentionally
forgets residue fields and scheme structure; reduced degree-three generic fibres are meant to
supply a three-element instance of this type. -/
def schemePointFiber {Y S : Scheme.{u}} (p : Y ⟶ S) (s : S) : Type u :=
  {y : Y // p y = s}

/-- A morphism over `S` induces the evident map on underlying point fibres. -/
def schemePointFiberMap {X Y S : Scheme.{u}} (f : X ⟶ Y) (p : Y ⟶ S) (s : S) :
    schemePointFiber (f ≫ p) s → schemePointFiber p s :=
  fun x ↦ ⟨f x.1, x.2⟩

/-- A closed immersion is injective on every underlying point fibre. -/
theorem schemePointFiberMap_injective_of_isClosedImmersion
    {X Y S : Scheme.{u}} (f : X ⟶ Y) (p : Y ⟶ S) (s : S)
    [IsClosedImmersion f] : Function.Injective (schemePointFiberMap f p s) := by
  intro x y hxy
  apply Subtype.ext
  apply f.isClosedEmbedding.injective
  exact congrArg Subtype.val hxy

/-- A closed subscheme of a reduced scheme which contains every irreducible-component generic
point is the whole scheme. -/
theorem isIso_of_isClosedImmersion_of_genericPoints_subset_range
    {X Y : Scheme.{u}} (f : X ⟶ Y) [IsClosedImmersion f] [IsReduced Y]
    (hgeneric : genericPoints Y ⊆ Set.range f) : IsIso f := by
  have hdenseGeneric : Dense (genericPoints Y) := by
    rw [dense_iff_closure_eq, genericPoints.closure]
  have hdenseRange : Dense (Set.range f) := hdenseGeneric.mono hgeneric
  have hclosedRange : IsClosed (Set.range f) := f.isClosedEmbedding.isClosed_range
  have hrange : Set.range f = Set.univ := by
    rw [← hclosedRange.closure_eq]
    exact hdenseRange.closure_eq
  letI : Surjective f := ⟨Set.range_eq_univ.mp hrange⟩
  exact isIso_of_isClosedImmersion_of_surjective f

/-- If the ambient reduced integral scheme has only its generic point over the generic point of
the base, then a closed subscheme which still surjects onto the base exhausts the ambient
scheme.  This is the generic-fibre endpoint suited to `X_H`: integrality makes the ambient
generic point unique, while zero-dimensionality of the integral generic fibre supplies
`hunique` below. -/
theorem isIso_of_isClosedImmersion_of_surjective_toBase_of_unique_genericFiber
    {X Y S : Scheme.{u}} (f : X ⟶ Y) (p : Y ⟶ S)
    [IsClosedImmersion f] [IsReduced Y] [IrreducibleSpace Y]
    [IrreducibleSpace S] [Surjective (f ≫ p)]
    (hunique : ∀ y : Y, p y = genericPoint S → y = genericPoint Y) :
    IsIso f := by
  apply isIso_of_isClosedImmersion_of_genericPoints_subset_range f
  rw [genericPoints_eq_singleton]
  rintro y (rfl : y = genericPoint Y)
  obtain ⟨x, hx⟩ := (f ≫ p).surjective (genericPoint S)
  exact ⟨x, hunique (f x) hx⟩

/-- A dominant morphism between integral schemes sends the generic point to the generic point.
This local copy keeps the exhaustion criterion independent of the rational-family API. -/
theorem schemeMap_genericPoint_eq_of_isDominant
    {Y S : Scheme.{u}} [IsIntegral Y] [IsIntegral S]
    (p : Y ⟶ S) [IsDominant p] :
    p (genericPoint Y) = genericPoint S := by
  apply ((genericPoint_spec S).eq _).symm
  have himage : IsGenericPoint
      (p (genericPoint Y)) (closure (Set.range p)) := by
    have h := (genericPoint_spec Y).image p.continuous
    convert h using 1
    simp only [Set.image_univ]
  have hrange : DenseRange p := IsDominant.denseRange
  rwa [DenseRange.closure_range hrange] at himage

/-- Subsingleton generic-fibre form of the exhaustion criterion.  Surjectivity of `f ≫ p`
makes `p` dominant, so the generic point of the integral ambient scheme lies over the base generic
point.  If that underlying point fibre is a subsingleton, any residual point lying above the base
generic point must be the ambient generic point. -/
theorem isIso_of_isClosedImmersion_of_surjective_toBase_of_subsingleton_genericFiber
    {X Y S : Scheme.{u}} (f : X ⟶ Y) (p : Y ⟶ S)
    [IsClosedImmersion f] [IsIntegral Y] [IsIntegral S]
    [Surjective (f ≫ p)]
    [hsubsingleton : Subsingleton (schemePointFiber p (genericPoint S))] :
    IsIso f := by
  letI : IsDominant (f ≫ p) := inferInstance
  letI : IsDominant p := IsDominant.of_comp f p
  have hgeneric : p (genericPoint Y) = genericPoint S :=
    schemeMap_genericPoint_eq_of_isDominant p
  apply isIso_of_isClosedImmersion_of_surjective_toBase_of_unique_genericFiber f p
  intro y hy
  have hsubtype :
      (⟨y, hy⟩ : schemePointFiber p (genericPoint S)) =
        ⟨genericPoint Y, hgeneric⟩ :=
    @Subsingleton.elim _ hsubsingleton _ _
  exact congrArg Subtype.val hsubtype

/-- Specialization of the preceding exhaustion criterion to the residual component constructed
inside `X_H = V(F,H(y))`.  Thus, after the explicit factorization above, the remaining geometric
inputs are exactly: `X_H` is reduced and irreducible, the residual component dominates
`P²_x`, and the generic fibre of `X_H → P²_x` has a unique underlying point. -/
theorem residualTargetComponentOnι_isIso_of_surjective_toFirst_of_unique_genericFiber
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0)
    [IsReduced (targetRelationZeroLocus F H)]
    [IrreducibleSpace (targetRelationZeroLocus F H)]
    [hsurj : Surjective
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hH hvan)]
    (hunique : ∀ y : targetRelationZeroLocus F H,
      targetRelationToFirst F H y = genericPoint (ProjectiveSpace 2 k) →
        y = genericPoint (targetRelationZeroLocus F H)) :
    IsIso
      (residualTargetComponentOnι
        p₀ q₀ r N hMN F hF v hv i j H hH hvan) := by
  letI : Surjective
      (residualTargetComponentOnι
          p₀ q₀ r N hMN F hF v hv i j H hH hvan ≫
        targetRelationToFirst F H) := by
    change Surjective
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hH hvan)
    exact hsurj
  exact
    isIso_of_isClosedImmersion_of_surjective_toBase_of_unique_genericFiber
      (residualTargetComponentOnι
        p₀ q₀ r N hMN F hF v hv i j H hH hvan)
      (targetRelationToFirst F H) hunique

/-- The same `X_H` exhaustion endpoint with the generic-fibre condition packaged as a
`Subsingleton` instance.  For a nonempty zero-dimensional integral generic fibre, this is exactly
the one-point statement supplied by its spectrum being the spectrum of a field. -/
theorem residualTargetComponentOnι_isIso_of_subsingleton_genericFiber
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0)
    [IsIntegral (targetRelationZeroLocus F H)]
    [hsurj : Surjective
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hH hvan)]
    [Subsingleton
      (schemePointFiber (targetRelationToFirst F H)
        (genericPoint (ProjectiveSpace 2 k)))] :
    IsIso
      (residualTargetComponentOnι
        p₀ q₀ r N hMN F hF v hv i j H hH hvan) := by
  letI : Surjective
      (residualTargetComponentOnι
          p₀ q₀ r N hMN F hF v hv i j H hH hvan ≫
        targetRelationToFirst F H) := by
    change Surjective
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hH hvan)
    exact hsurj
  exact
    isIso_of_isClosedImmersion_of_surjective_toBase_of_subsingleton_genericFiber
      (residualTargetComponentOnι
        p₀ q₀ r N hMN F hF v hv i j H hH hvan)
      (targetRelationToFirst F H)

/-- Generic-fibre form of the exhaustion criterion.

`hnoVertical` says that every irreducible component of `Y` dominates the irreducible base `S`;
`hgenericFiber` says that `f` exhausts the underlying fibre over the generic point of `S`.  These
two hypotheses put every generic point of `Y` in the range of `f`, so the preceding theorem
applies.

The first hypothesis is genuinely stronger than saying that the image of `f` is the unique
component dominating `S`: that weaker statement still permits components supported over proper
closed subsets of `S`.  In the residual-divisor application, removing the common first-block
factor from the second-block-linear equation does not by itself supply `hnoVertical`; a separate
flatness, saturation, or divisor-class argument is required. -/
theorem isIso_of_isClosedImmersion_of_genericFiber_surjective_of_noVerticalComponents
    {X Y S : Scheme.{u}} (f : X ⟶ Y) (p : Y ⟶ S)
    [IsClosedImmersion f] [IsReduced Y] [IrreducibleSpace S]
    (hnoVertical : ∀ y : Y, y ∈ genericPoints Y → p y = genericPoint S)
    (hgenericFiber : ∀ y : Y, p y = genericPoint S → ∃ x : X, f x = y) :
    IsIso f := by
  apply isIso_of_isClosedImmersion_of_genericPoints_subset_range f
  intro y hy
  exact hgenericFiber y (hnoVertical y hy)

/-- Finite-cardinality form of generic-fibre exhaustion.

For the residual construction, the displayed cardinality equality is obtained by proving that
both generic fibres are reduced of degree three.  The closed immersion is automatically
injective on points, so equality of the two finite cardinalities makes it surjective on the
generic fibre. -/
theorem isIso_of_isClosedImmersion_of_genericFiber_card_eq_of_noVerticalComponents
    {X Y S : Scheme.{u}} (f : X ⟶ Y) (p : Y ⟶ S)
    [IsClosedImmersion f] [IsReduced Y] [IrreducibleSpace S]
    [Fintype (schemePointFiber (f ≫ p) (genericPoint S))]
    [Fintype (schemePointFiber p (genericPoint S))]
    (hnoVertical : ∀ y : Y, y ∈ genericPoints Y → p y = genericPoint S)
    (hcard : Fintype.card (schemePointFiber (f ≫ p) (genericPoint S)) =
      Fintype.card (schemePointFiber p (genericPoint S))) :
    IsIso f := by
  apply isIso_of_isClosedImmersion_of_genericFiber_surjective_of_noVerticalComponents
    f p hnoVertical
  have hsurj : Function.Surjective
      (schemePointFiberMap f p (genericPoint S)) :=
    ((Fintype.bijective_iff_injective_and_card _).2
      ⟨schemePointFiberMap_injective_of_isClosedImmersion f p (genericPoint S), hcard⟩).2
  intro y hy
  obtain ⟨x, hx⟩ := hsurj ⟨y, hy⟩
  exact ⟨x.1, congrArg Subtype.val hx⟩

/-- Degree-three specialization of the finite-cardinality exhaustion theorem. -/
theorem isIso_of_isClosedImmersion_of_genericFibers_card_three_of_noVerticalComponents
    {X Y S : Scheme.{u}} (f : X ⟶ Y) (p : Y ⟶ S)
    [IsClosedImmersion f] [IsReduced Y] [IrreducibleSpace S]
    [Fintype (schemePointFiber (f ≫ p) (genericPoint S))]
    [Fintype (schemePointFiber p (genericPoint S))]
    (hnoVertical : ∀ y : Y, y ∈ genericPoints Y → p y = genericPoint S)
    (hsource : Fintype.card (schemePointFiber (f ≫ p) (genericPoint S)) = 3)
    (htarget : Fintype.card (schemePointFiber p (genericPoint S)) = 3) :
    IsIso f :=
  isIso_of_isClosedImmersion_of_genericFiber_card_eq_of_noVerticalComponents
    f p hnoVertical (hsource.trans htarget.symm)

end

end BConicBundleMultisections
