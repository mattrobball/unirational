/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualComponentExhaustion
public import BConicBundleMultisections.TargetRelationGenericFiber
public import BConicBundleMultisections.ResidualTargetRelationNullstellensatz

/-!
# From residual-target exhaustion to Cox-ideal membership

This file turns scheme-theoretic exhaustion of the target relation by the explicit residual
component into pointwise vanishing of the residual equation, and hence into unsaturated
Cox-ideal membership by the affine-cone Nullstellensatz.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry Matrix
open AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial BiprojectiveSpace ResidualDivisor
open _root_.MvPolynomial Localization

attribute [local instance] MvPolynomial.gradedAlgebra

/-! ### Reading an ideal-sheaf kernel on a normalized chart point -/

@[reassoc]
theorem biprojectiveChartPointOfNormalizedAlgebra_appTop_standardChartΓIso
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) :
    (biprojectiveChartPointOfNormalizedAlgebra m n i j x y).appTop ≫
        (Scheme.ΓSpecIso (.of S)).hom =
      (standardChartΓIso m n R i j).hom ≫
        CommRingCat.ofHom (biprojectiveChartEvalAlgebra m n i j x y) := by
  unfold biprojectiveChartPointOfNormalizedAlgebra standardChartΓIso
  rw [Scheme.Hom.comp_appTop]
  simp only [Scheme.Γ_map_op, Category.assoc, Scheme.ΓSpecIso_naturality]
  have hinv : (standardChartIsoSpec m n R i j).inv =
      inv (standardChartIsoSpec m n R i j).hom := by
    rw [← asIso_inv]
    exact (Iso.inv_eq_inv _ _).2 rfl
  rw [hinv, Scheme.Hom.inv_appTop]
  rfl

/-- Conversely to
`biprojectiveZeroLocusIdeal_le_biprojectiveChartPointAlgebra_ker`, containment of the global
ideal sheaf of a bihomogeneous equation in the kernel of a normalized chart point forces the
corresponding algebra-valued polynomial evaluation to vanish. -/
theorem aeval_eq_zero_of_biprojectiveZeroLocusIdeal_le_biprojectiveChartPointAlgebra_ker
    {R S : Type u} [CommRing R] [CommRing S] [Algebra R S]
    (m n : ℕ) (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S)
    (hxi : x i = 1) (hyj : y j = 1)
    {d e : ℕ} (Q : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hQ : IsBihomogeneousOfBidegree d e Q)
    (hle : biprojectiveZeroLocusIdeal m n R Q ≤
      (biprojectiveChartPointOfNormalizedAlgebra m n i j x y ≫
        standardChartι m n R i j).ker) :
    aeval (Sum.elim x y) Q = 0 := by
  let p : Spec (.of S) ⟶ standardChart m n R i j :=
    biprojectiveChartPointOfNormalizedAlgebra m n i j x y
  have hle' : biprojectiveZeroLocusIdeal m n R Q ≤
      p.ker.map (standardChartι m n R i j) := by
    simpa only [Scheme.Hom.ker_comp] using hle
  have hlocal : chartIdealSheaf m n R i j Q ≤ p.ker := by
    have := (Scheme.IdealSheafData.le_map_iff_comap_le.mp hle')
    rwa [biprojectiveZeroLocusIdeal_comap_standardChartι m n R Q hQ] at this
  have hsection : chartEquationSection m n R i j Q ∈
      p.ker.ideal (chartTopAffineOpen m n R i j) := by
    apply hlocal
    rw [chartIdealSheaf_ideal_chartTopAffineOpen]
    exact chartEquationSection_mem_chartIdealTop m n R i j Q
  have hsection0 : p.appTop.hom (chartEquationSection m n R i j Q) = 0 := by
    apply RingHom.mem_ker.mp
    exact p.ideal_ker_le (chartTopAffineOpen m n R i j) hsection
  have hsectionS :
      ((p.appTop ≫ (Scheme.ΓSpecIso (.of S)).hom).hom)
          (chartEquationSection m n R i j Q) = 0 := by
    simp only [CommRingCat.hom_comp, RingHom.coe_comp, Function.comp_apply, hsection0, map_zero]
  rw [biprojectiveChartPointOfNormalizedAlgebra_appTop_standardChartΓIso] at hsectionS
  change biprojectiveChartEvalAlgebra m n i j x y
      ((standardChartΓIso m n R i j).hom (chartEquationSection m n R i j Q)) = 0 at hsectionS
  rw [standardChartΓIso_hom_chartEquationSection] at hsectionS
  simp only [biprojectiveChartEvalAlgebra, RingHom.comp_apply] at hsectionS
  change aeval (affineChartPoint i j x y)
      (standardChartRingEquivMvPolynomial m n R i j
        (chartEquation m n R i j Q)) = 0 at hsectionS
  rw [standardChartRingEquivMvPolynomial_chartEquation] at hsectionS
  rwa [aeval_affineChartEquation_affineChartPoint m n i j x y hxi hyj Q] at hsectionS

/-! ### The explicit residual chart kills the residual equation -/

/-- The unnormalized arbitrary-line residual coordinate pair lies on the corresponding residual
equation. -/
theorem aeval_residualCoordsOn_residualEquationOn
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0) :
    aeval (Sum.elim (stereoFirstCoordsOn p₀ q₀ F v)
        (residualYCoordsOn p₀ q₀ r N F v))
      (residualEquationOn (lineFrame p₀ q₀ r) N F) = 0 := by
  rw [MvPolynomial.aeval_def, MvPolynomial.eval₂_eq_eval_map,
    ← map_residualEquationOn]
  rw [eval_residualEquationOn, lineFrame_map]
  exact eval_residualYCoordsOn_residualLinearFormOn p₀ q₀ r N hMN F hF v hv

/-- The localized and separately normalized coordinates used by the residual scheme morphism
still annihilate the arbitrary-line residual equation. -/
theorem aeval_residualComponentOnCoordsNorm_residualEquationOn
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) :
    aeval (Sum.elim (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
        (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j))
      (residualEquationOn (lineFrame p₀ q₀ r) N F) = 0 := by
  let Q := residualEquationOn (lineFrame p₀ q₀ r) N F
  have hloc :
      aeval (Sum.elim (residualComponentOnXCoordsLoc p₀ q₀ r N F v i j)
          (residualComponentOnYCoordsLoc p₀ q₀ r N F v i j)) Q = 0 := by
    rw [aeval_residualComponentOnLoc_coords,
      aeval_residualCoordsOn_residualEquationOn p₀ q₀ r N hMN F hF v hv, map_zero]
  have hfirst := aeval_scaleByUnitInv_first_eq_zero
    (ResidualDivisor.residualEquationOn_isBihomogeneous
      (lineFrame p₀ q₀ r) N hF)
    (residualComponentOnXCoordsLoc p₀ q₀ r N F v i j)
    (residualComponentOnYCoordsLoc p₀ q₀ r N F v i j) i
    (isUnit_residualComponentOnXCoordsLoc p₀ q₀ r N F v i j) hloc
  exact aeval_scaleByUnitInv_second_eq_zero
    (ResidualDivisor.residualEquationOn_isBihomogeneous
      (lineFrame p₀ q₀ r) N hF)
    (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
    (residualComponentOnYCoordsLoc p₀ q₀ r N F v i j) j
    (isUnit_residualComponentOnYCoordsLoc p₀ q₀ r N F v i j) hfirst

/-! ### Exhaustion identifies the target-relation kernel -/

/-- If the scheme-theoretic residual component exhausts `X_H`, then the global ideal sheaf of
the residual equation is contained in the ideal sheaf of `X_H` in biprojective space. -/
theorem biprojectiveZeroLocusIdeal_residualEquationOn_le_targetRelationIdeal_of_isIso
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0)
    [IsIso (residualTargetComponentOnι
      p₀ q₀ r N hMN F hF v hv i j H hH hvan)] :
    biprojectiveZeroLocusIdeal 2 2 k
        (residualEquationOn (lineFrame p₀ q₀ r) N F) ≤
      targetRelationIdeal F H := by
  let f := residualTargetPointOn p₀ q₀ r N hMN F hF v hv i j H hH hvan
  let x := residualComponentOnXCoordsNorm p₀ q₀ r N F v i j
  let y := residualComponentOnYCoordsNorm p₀ q₀ r N F v i j
  have hQ : aeval (Sum.elim x y)
      (residualEquationOn (lineFrame p₀ q₀ r) N F) = 0 :=
    aeval_residualComponentOnCoordsNorm_residualEquationOn
      p₀ q₀ r N hMN F hF v hv i j
  have hQker : biprojectiveZeroLocusIdeal 2 2 k
        (residualEquationOn (lineFrame p₀ q₀ r) N F) ≤
      (biprojectiveChartPointOfNormalizedAlgebra 2 2 i j x y ≫
        standardChartι 2 2 k i j).ker :=
    biprojectiveZeroLocusIdeal_le_biprojectiveChartPointAlgebra_ker
      2 2 i j x y
      (residualComponentOnXCoordsNorm_apply p₀ q₀ r N F v i j)
      (residualComponentOnYCoordsNorm_apply p₀ q₀ r N F v i j)
      (residualEquationOn (lineFrame p₀ q₀ r) N F) hQ
  have hfambient : f ≫ targetRelationι F H =
      biprojectiveChartPointOfNormalizedAlgebra 2 2 i j x y ≫
        standardChartι 2 2 k i j := by
    exact targetRelationPointOfNormalizedAlgebra_ι i j x y
      (residualComponentOnXCoordsNorm_apply p₀ q₀ r N F v i j)
      (residualComponentOnYCoordsNorm_apply p₀ q₀ r N F v i j)
      F H
      (aeval_residualComponentOnCoordsNorm_F p₀ q₀ r N hMN F hF v hv i j)
      (aeval_residualComponentOnYCoordsNorm_targetRelation
        p₀ q₀ r N F v i j H hH hvan)
  rw [← hfambient] at hQker
  letI : IsIso f.imageι := by
    change IsIso (residualTargetComponentOnι
      p₀ q₀ r N hMN F hF v hv i j H hH hvan)
    infer_instance
  have hfker : f.ker = ⊥ := by
    calc
      f.ker = f.imageι.ker :=
        (Scheme.IdealSheafData.ker_subschemeι f.ker).symm
      _ = ⊥ := Scheme.Hom.ker_eq_bot_of_isIso f.imageι
  have hcompker : (f ≫ targetRelationι F H).ker = (targetRelationι F H).ker := by
    rw [Scheme.Hom.ker_comp, hfker, Scheme.IdealSheafData.map_bot]
  rw [hcompker, ker_targetRelationι] at hQker
  exact hQker

/-! ### Projective pointwise vanishing -/

/-- Scheme-theoretic exhaustion of `X_H` forces the residual equation to vanish at every
nonzero common projective zero of `F` and `H(y)`. -/
theorem aeval_residualEquationOn_eq_zero_of_targetRelation_isIso
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0)
    [IsIso (residualTargetComponentOnι
      p₀ q₀ r N hMN F hF v hv i j H hH hvan)]
    (x y : Fin 3 → k) (hx : x ≠ 0) (hy : y ≠ 0)
    (hxF : aeval (Sum.elim x y) F = 0) (hyH : aeval y H = 0) :
    aeval (Sum.elim x y)
      (residualEquationOn (lineFrame p₀ q₀ r) N F) = 0 := by
  obtain ⟨ix, hxix⟩ := exists_normalizing_coordinate x hx
  obtain ⟨jy, hyjy⟩ := exists_normalizing_coordinate y hy
  have hxunit : IsUnit (x ix) := isUnit_iff_ne_zero.mpr hxix
  have hyunit : IsUnit (y jy) := isUnit_iff_ne_zero.mpr hyjy
  let xn := scaleByUnitInv x ix hxunit
  let yn := scaleByUnitInv y jy hyunit
  have hxni : xn ix = 1 := scaleByUnitInv_apply x ix hxunit
  have hynj : yn jy = 1 := scaleByUnitInv_apply y jy hyunit
  have hFnFirst : aeval (Sum.elim xn y) F = 0 :=
    aeval_scaleByUnitInv_first_eq_zero hF x y ix hxunit hxF
  have hFn : aeval (Sum.elim xn yn) F = 0 :=
    aeval_scaleByUnitInv_second_eq_zero hF xn y jy hyunit hFnFirst
  have hHn : aeval yn H = 0 :=
    aeval_scaleByUnitInv_eq_zero_of_isHomogeneous hH y jy hyunit hyH
  let pt := targetRelationPointOfNormalizedAlgebra ix jy xn yn hxni hynj F H hFn hHn
  have htargetKer : targetRelationIdeal F H ≤
      (biprojectiveChartPointOfNormalizedAlgebra 2 2 ix jy xn yn ≫
        standardChartι 2 2 k ix jy).ker := by
    rw [← targetRelationPointOfNormalizedAlgebra_ι
      ix jy xn yn hxni hynj F H hFn hHn]
    rw [← ker_targetRelationι F H]
    exact Scheme.Hom.le_ker_comp pt (targetRelationι F H)
  have hQKer : biprojectiveZeroLocusIdeal 2 2 k
        (residualEquationOn (lineFrame p₀ q₀ r) N F) ≤
      (biprojectiveChartPointOfNormalizedAlgebra 2 2 ix jy xn yn ≫
        standardChartι 2 2 k ix jy).ker :=
    (biprojectiveZeroLocusIdeal_residualEquationOn_le_targetRelationIdeal_of_isIso
      p₀ q₀ r N hMN F hF v hv i j H hH hvan).trans htargetKer
  have hQn : aeval (Sum.elim xn yn)
      (residualEquationOn (lineFrame p₀ q₀ r) N F) = 0 :=
    aeval_eq_zero_of_biprojectiveZeroLocusIdeal_le_biprojectiveChartPointAlgebra_ker
      2 2 ix jy xn yn hxni hynj
      (residualEquationOn (lineFrame p₀ q₀ r) N F)
      (ResidualDivisor.residualEquationOn_isBihomogeneous
        (lineFrame p₀ q₀ r) N hF) hQKer
  have hxscale : IsUnit ((↑hxunit.unit⁻¹ : k) ^ 10) :=
    (Units.isUnit hxunit.unit⁻¹).pow 10
  have hyscale : IsUnit ((↑hyunit.unit⁻¹ : k) ^ 1) :=
    (Units.isUnit hyunit.unit⁻¹).pow 1
  change aeval (Sum.elim (scaleByUnitInv x ix hxunit)
      (scaleByUnitInv y jy hyunit))
      (residualEquationOn (lineFrame p₀ q₀ r) N F) = 0 at hQn
  rw [scaleByUnitInv_eq_smul, scaleByUnitInv_eq_smul] at hQn
  simp only [Pi.smul_def, smul_eq_mul] at hQn
  rw [aeval_smul_second_of_isBihomogeneous
      (ResidualDivisor.residualEquationOn_isBihomogeneous
        (lineFrame p₀ q₀ r) N hF),
    aeval_smul_first_of_isBihomogeneous
      (ResidualDivisor.residualEquationOn_isBihomogeneous
        (lineFrame p₀ q₀ r) N hF)] at hQn
  exact hxscale.mul_right_eq_zero.mp (hyscale.mul_right_eq_zero.mp hQn)

/-! ### Unsaturated affine Cox-ideal membership -/

/-- Reduced affine-cone endpoint: residual-target exhaustion plus radicality of `(F,H(y))`
gives raw, unsaturated ideal membership of the residual equation. -/
theorem residualEquationOn_mem_span_targetRelation_of_isIso_of_isRadical
    {k : Type u} [Field k] [IsAlgClosed k] [Infinite k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0)
    [IsIso (residualTargetComponentOnι
      p₀ q₀ r N hMN F hF v hv i j H hH hvan)]
    (hradical : (Ideal.span {F, rename Sum.inr H}).IsRadical) :
    residualEquationOn (lineFrame p₀ q₀ r) N F ∈
      Ideal.span {F, rename Sum.inr H} := by
  apply residualEquationOn_mem_span_targetRelation_of_projective_vanishing_of_isRadical
    (lineFrame p₀ q₀ r) N hF hradical
  intro x y hx hy hxF hyH
  exact aeval_residualEquationOn_eq_zero_of_targetRelation_isIso
    p₀ q₀ r N hMN F hF v hv i j H hH hvan x y hx hy hxF hyH

/-- Prime affine-cone endpoint. -/
theorem residualEquationOn_mem_span_targetRelation_of_isIso_of_isPrime
    {k : Type u} [Field k] [IsAlgClosed k] [Infinite k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0)
    [IsIso (residualTargetComponentOnι
      p₀ q₀ r N hMN F hF v hv i j H hH hvan)]
    (hprime : (Ideal.span {F, rename Sum.inr H}).IsPrime) :
    residualEquationOn (lineFrame p₀ q₀ r) N F ∈
      Ideal.span {F, rename Sum.inr H} := by
  apply residualEquationOn_mem_span_targetRelation_of_projective_vanishing
    (lineFrame p₀ q₀ r) N hF hprime
  intro x y hx hy hxF hyH
  exact aeval_residualEquationOn_eq_zero_of_targetRelation_isIso
    p₀ q₀ r N hMN F hF v hv i j H hH hvan x y hx hy hxF hyH

end

end BConicBundleMultisections
