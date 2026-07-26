/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GoodLineCondition
public import BConicBundleMultisections.PlaneCubicResidualTransport
public import BConicBundleMultisections.ResidualImageRationalParam

/-!
# The residual component attached to an arbitrary line

This file is the scheme-level counterpart of the arbitrary-line coordinate formulas in
`PlaneCubicResidualTransport`.  For a framed line `L = span(p₀,q₀)`, the formulas
`stereoFirstCoordsOn` and `residualYCoordsOn` give two homogeneous triples over `k[t,s]`.
After localizing where one coordinate in each triple is nonzero, both triples can be normalized
and hence define a morphism to a standard affine chart of the biprojective zero locus of `F`.

The scheme-theoretic image of that morphism is the first intrinsic residual-component object which
does not identify the construction with the coordinate line.  No assertion about horizontality or
dimension is made here: those require the separate good-line input.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial Localization

/-! ### The arbitrary-line residual point lies on the cubic fibre -/

/-- The transported tangent-residual representative along an arbitrary framed line lies on the
cubic fibre.  The proof moves the cubic and the residual representative into the line frame,
applies the coordinate-free double-contact lemma there, and moves the resulting equality back. -/
theorem eval_residualYCoordsOn_cubicFiber
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0) :
    eval (residualYCoordsOn p₀ q₀ r N F v)
      (cubicFiberPullback F (stereoFirstCoordsOn p₀ q₀ F v)) = 0 := by
  let M : Matrix (Fin 3) (Fin 3) (affineTwoRing k) := affineTwoLineFrame p₀ q₀ r
  let N' : Matrix (Fin 3) (Fin 3) (affineTwoRing k) := N.map C
  let x : Fin 3 → affineTwoRing k := stereoFirstCoordsOn p₀ q₀ F v
  let p : Fin 3 → affineTwoRing k := affineTwoLinePoint p₀ q₀
  let G : MvPolynomial (Fin 3) (affineTwoRing k) := cubicFiberPullback F x
  let Gb : MvPolynomial (Fin 3) (affineTwoRing k) :=
    (aeval (linearSubst 2 M) : MvPolynomial (Fin 3) (affineTwoRing k) →ₐ[_] _) G
  let z : Fin 3 → affineTwoRing k := N' *ᵥ p
  let qb : Fin 3 → affineTwoRing k := complementaryTangentDir Gb z
  let q : Fin 3 → affineTwoRing k := frameTangentDir M N' G p
  let f : MvPolynomial (Fin 2) (affineTwoRing k) := binaryLineRestriction z qb Gb
  have hMN' : M * N' = 1 := by
    exact lineFrame_map_mul_map (C : k →+* affineTwoRing k) p₀ q₀ r N hMN
  have hinv : ∀ y : Fin 3 → affineTwoRing k, M *ᵥ (N' *ᵥ y) = y := by
    intro y
    rw [Matrix.mulVec_mulVec, hMN', Matrix.one_mulVec]
  have hinv' : ∀ y : Fin 3 → affineTwoRing k, N' *ᵥ (M *ᵥ y) = y := by
    intro y
    rw [Matrix.mulVec_mulVec, mul_eq_one_comm.mp hMN', Matrix.one_mulVec]
  have hp : eval p G = 0 := by
    simpa [p, G, x] using eval_cubicFiber_line_of_stereo p₀ q₀ F hF v hv
  have hpFrame : eval z Gb = 0 := by
    change eval (N' *ᵥ p)
      ((aeval (linearSubst 2 M) :
        MvPolynomial (Fin 3) (affineTwoRing k) →ₐ[affineTwoRing k] _) G) = 0
    rw [eval_aeval_linearSubst, hinv]
    exact hp
  have hG : G.IsHomogeneous 3 := cubicFiberPullback_isHomogeneous F hF x
  have hGb : Gb.IsHomogeneous 3 := by
    exact isHomogeneous_aeval_linearSubst M hG
  have hqb : qb ∈ tangentHyperplaneCone Gb z := by
    exact complementaryTangentDir_mem_tangentHyperplaneCone Gb z
  have hframe : eval (residualAmbientRep z qb f) Gb = 0 := by
    exact eval_residualAmbientRep_of_double_contact Gb hGb z qb hpFrame hqb
  have hq : q = M *ᵥ qb := by
    rfl
  have hrestr : binaryLineRestriction p q G = f := by
    calc
      binaryLineRestriction p q G =
          binaryLineRestriction (N' *ᵥ p) (N' *ᵥ q) Gb := by
        change binaryLineRestriction p q G =
          binaryLineRestriction (N' *ᵥ p) (N' *ᵥ q)
            ((aeval (linearSubst 2 M) :
              MvPolynomial (Fin 3) (affineTwoRing k) →ₐ[affineTwoRing k] _) G)
        rw [binaryLineRestriction_aeval_linearSubst, hinv, hinv]
      _ = binaryLineRestriction z qb Gb := by rw [hq, hinv']
      _ = f := rfl
  have hpoint : residualAmbientRep p q (binaryLineRestriction p q G) =
      M *ᵥ residualAmbientRep z qb f := by
    rw [mulVec_residualAmbientRep, hinv, ← hq, ← hrestr]
  change eval (residualAmbientRep p q (binaryLineRestriction p q G)) G = 0
  calc
    eval (residualAmbientRep p q (binaryLineRestriction p q G)) G =
        eval (M *ᵥ residualAmbientRep z qb f) G := congrArg (fun y => eval y G) hpoint
    _ = eval (residualAmbientRep z qb f) Gb := by
      change eval (M *ᵥ residualAmbientRep z qb f) G =
        eval (residualAmbientRep z qb f)
          ((aeval (linearSubst 2 M) :
            MvPolynomial (Fin 3) (affineTwoRing k) →ₐ[affineTwoRing k] _) G)
      rw [eval_aeval_linearSubst]
    _ = 0 := hframe

/-- The arbitrary-line residual coordinate pair vanishes on the coefficient pullback of `F`. -/
theorem eval_residualCoordsOn_F
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0) :
    eval (Sum.elim (stereoFirstCoordsOn p₀ q₀ F v)
        (residualYCoordsOn p₀ q₀ r N F v)) (affineTwoPullback F) = 0 := by
  rw [← eval_cubicFiberPullback]
  exact eval_residualYCoordsOn_cubicFiber p₀ q₀ r N hMN F hF v hv

/-- The same vanishing, viewed as algebra evaluation of the original equation over `k`. -/
theorem aeval_residualCoordsOn_F
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0) :
    aeval (Sum.elim (stereoFirstCoordsOn p₀ q₀ F v)
        (residualYCoordsOn p₀ q₀ r N F v)) F = 0 := by
  rw [MvPolynomial.aeval_def, MvPolynomial.eval₂_eq_eval_map, MvPolynomial.algebraMap_eq]
  exact eval_residualCoordsOn_F p₀ q₀ r N hMN F hF v hv

/-! ### Chart localization and normalization -/

/-- A nonzero polar form makes the arbitrary-line stereographic first-block coordinates a
genuine projective point. -/
theorem stereoFirstCoordsOn_ne_zero_of_polar
    {k : Type u} [Field k]
    (p₀ q₀ : Fin 3 → k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hpolar : polarEval (lineSpecializedConicPullback p₀ q₀ F)
      (liftTsenSection v) affineTwoStereoDir ≠ 0) :
    stereoFirstCoordsOn p₀ q₀ F v ≠ 0 :=
  stereoAlg_ne_zero_of_isotropic_of_polar_ne_zero
    (lineSpecializedConicPullback_isHomogeneous p₀ q₀ hF)
    (liftTsenSection v) affineTwoStereoDir
    (eval_liftTsenSection_lineSpecializedConicPullback p₀ q₀ F hF v hv) hpolar

/-- Product inverted to put both projective coordinate triples in the chosen standard chart. -/
def residualComponentOnDenom
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) : affineTwoRing k :=
  stereoFirstCoordsOn p₀ q₀ F v i * residualYCoordsOn p₀ q₀ r N F v j

/-- Nonzero first- and second-block coordinate triples yield a nonempty chart for the
arbitrary-line residual map. -/
theorem exists_residualComponentOnDenom_ne_zero
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    (hX : stereoFirstCoordsOn p₀ q₀ F v ≠ 0)
    (hY : residualYCoordsOn p₀ q₀ r N F v ≠ 0) :
    ∃ i j : Fin 3, residualComponentOnDenom p₀ q₀ r N F v i j ≠ 0 := by
  haveI : IsDomain (affineTwoRing k) := inferInstance
  obtain ⟨i, j, hij⟩ :=
    exists_mul_ne_zero_of_ne_zero_vectors
      (stereoFirstCoordsOn p₀ q₀ F v) (residualYCoordsOn p₀ q₀ r N F v) hX hY
  exact ⟨i, j, hij⟩

/-- The affine parameter ring localized at the chosen chart-normalizing product. -/
abbrev residualComponentOnLoc
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) : Type u :=
  Away (residualComponentOnDenom p₀ q₀ r N F v i j)

instance residualComponentOnLoc_algebra
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    Algebra k (residualComponentOnLoc p₀ q₀ r N F v i j) :=
  RingHom.toAlgebra
    ((algebraMap (affineTwoRing k) (residualComponentOnLoc p₀ q₀ r N F v i j)).comp C)

/-- First-block coordinates in the chart localization. -/
def residualComponentOnXCoordsLoc
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    Fin 3 → residualComponentOnLoc p₀ q₀ r N F v i j :=
  fun a ↦ algebraMap (affineTwoRing k) _ (stereoFirstCoordsOn p₀ q₀ F v a)

/-- Second-block coordinates in the chart localization. -/
def residualComponentOnYCoordsLoc
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    Fin 3 → residualComponentOnLoc p₀ q₀ r N F v i j :=
  fun a ↦ algebraMap (affineTwoRing k) _ (residualYCoordsOn p₀ q₀ r N F v a)

theorem isUnit_residualComponentOnXCoordsLoc
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    IsUnit (residualComponentOnXCoordsLoc p₀ q₀ r N F v i j i) := by
  have hf : IsUnit
      (algebraMap (affineTwoRing k)
        (residualComponentOnLoc p₀ q₀ r N F v i j)
        (residualComponentOnDenom p₀ q₀ r N F v i j)) :=
    IsLocalization.Away.algebraMap_isUnit
      (residualComponentOnDenom p₀ q₀ r N F v i j)
  have heq :
      algebraMap (affineTwoRing k)
          (residualComponentOnLoc p₀ q₀ r N F v i j)
          (residualComponentOnDenom p₀ q₀ r N F v i j) =
        residualComponentOnXCoordsLoc p₀ q₀ r N F v i j i *
          residualComponentOnYCoordsLoc p₀ q₀ r N F v i j j := by
    simp [residualComponentOnDenom, residualComponentOnXCoordsLoc,
      residualComponentOnYCoordsLoc, map_mul]
  have hprod : IsUnit
      (residualComponentOnXCoordsLoc p₀ q₀ r N F v i j i *
        residualComponentOnYCoordsLoc p₀ q₀ r N F v i j j) := by
    rwa [← heq]
  exact isUnit_of_mul_isUnit_left hprod

theorem isUnit_residualComponentOnYCoordsLoc
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    IsUnit (residualComponentOnYCoordsLoc p₀ q₀ r N F v i j j) := by
  have hf : IsUnit
      (algebraMap (affineTwoRing k)
        (residualComponentOnLoc p₀ q₀ r N F v i j)
        (residualComponentOnDenom p₀ q₀ r N F v i j)) :=
    IsLocalization.Away.algebraMap_isUnit
      (residualComponentOnDenom p₀ q₀ r N F v i j)
  have heq :
      algebraMap (affineTwoRing k)
          (residualComponentOnLoc p₀ q₀ r N F v i j)
          (residualComponentOnDenom p₀ q₀ r N F v i j) =
        residualComponentOnXCoordsLoc p₀ q₀ r N F v i j i *
          residualComponentOnYCoordsLoc p₀ q₀ r N F v i j j := by
    simp [residualComponentOnDenom, residualComponentOnXCoordsLoc,
      residualComponentOnYCoordsLoc, map_mul]
  have hprod : IsUnit
      (residualComponentOnXCoordsLoc p₀ q₀ r N F v i j i *
        residualComponentOnYCoordsLoc p₀ q₀ r N F v i j j) := by
    rwa [← heq]
  exact isUnit_of_mul_isUnit_right hprod

/-- Chart-normalized first-block coordinates. -/
def residualComponentOnXCoordsNorm
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    Fin 3 → residualComponentOnLoc p₀ q₀ r N F v i j :=
  scaleByUnitInv (residualComponentOnXCoordsLoc p₀ q₀ r N F v i j) i
    (isUnit_residualComponentOnXCoordsLoc p₀ q₀ r N F v i j)

/-- Chart-normalized second-block coordinates. -/
def residualComponentOnYCoordsNorm
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    Fin 3 → residualComponentOnLoc p₀ q₀ r N F v i j :=
  scaleByUnitInv (residualComponentOnYCoordsLoc p₀ q₀ r N F v i j) j
    (isUnit_residualComponentOnYCoordsLoc p₀ q₀ r N F v i j)

@[simp] theorem residualComponentOnXCoordsNorm_apply
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    residualComponentOnXCoordsNorm p₀ q₀ r N F v i j i = 1 :=
  scaleByUnitInv_apply _ _ _

@[simp] theorem residualComponentOnYCoordsNorm_apply
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    residualComponentOnYCoordsNorm p₀ q₀ r N F v i j j = 1 :=
  scaleByUnitInv_apply _ _ _

theorem algebraMap_k_residualComponentOnLoc
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) (a : k) :
    algebraMap k (residualComponentOnLoc p₀ q₀ r N F v i j) a =
      algebraMap (affineTwoRing k) (residualComponentOnLoc p₀ q₀ r N F v i j) (C a) :=
  rfl

/-- Algebra evaluation after localization is localization of evaluation over `k[t,s]`. -/
theorem aeval_residualComponentOnLoc_coords
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    (P : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    aeval (Sum.elim (residualComponentOnXCoordsLoc p₀ q₀ r N F v i j)
        (residualComponentOnYCoordsLoc p₀ q₀ r N F v i j)) P =
      algebraMap (affineTwoRing k) (residualComponentOnLoc p₀ q₀ r N F v i j)
        (aeval (Sum.elim (stereoFirstCoordsOn p₀ q₀ F v)
          (residualYCoordsOn p₀ q₀ r N F v)) P) := by
  induction P using MvPolynomial.induction_on with
  | C a =>
      simp only [aeval_C, algebraMap_k_residualComponentOnLoc, algebraMap_eq]
  | add P Q hP hQ =>
      simp only [map_add, hP, hQ]
  | mul_X P z hP =>
      simp only [map_mul, aeval_X, hP]
      cases z with
      | inl a => simp only [Sum.elim_inl, residualComponentOnXCoordsLoc]
      | inr a => simp only [Sum.elim_inr, residualComponentOnYCoordsLoc]

theorem aeval_residualComponentOnCoordsLoc_F
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) :
    aeval (Sum.elim (residualComponentOnXCoordsLoc p₀ q₀ r N F v i j)
        (residualComponentOnYCoordsLoc p₀ q₀ r N F v i j)) F = 0 := by
  rw [aeval_residualComponentOnLoc_coords,
    aeval_residualCoordsOn_F p₀ q₀ r N hMN F hF v hv, map_zero]

theorem aeval_residualComponentOnCoordsNorm_F
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) :
    aeval (Sum.elim (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
        (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j)) F = 0 := by
  have h₀ := aeval_residualComponentOnCoordsLoc_F p₀ q₀ r N hMN F hF v hv i j
  have h₁ := aeval_scaleByUnitInv_first_eq_zero
    (hF : IsBihomogeneousOfBidegree 2 3 F)
    (residualComponentOnXCoordsLoc p₀ q₀ r N F v i j)
    (residualComponentOnYCoordsLoc p₀ q₀ r N F v i j) i
    (isUnit_residualComponentOnXCoordsLoc p₀ q₀ r N F v i j) h₀
  exact aeval_scaleByUnitInv_second_eq_zero
    (hF : IsBihomogeneousOfBidegree 2 3 F)
    (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
    (residualComponentOnYCoordsLoc p₀ q₀ r N F v i j) j
    (isUnit_residualComponentOnYCoordsLoc p₀ q₀ r N F v i j) h₁

/-! ### The localized morphism and its scheme-theoretic image -/

/-- The normalized arbitrary-line residual coordinates define a morphism to the global
biprojective zero locus of `F`. -/
def residualZeroLocusPointOn
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) :
    Spec (.of (residualComponentOnLoc p₀ q₀ r N F v i j)) ⟶
      biprojectiveZeroLocus 2 2 k F :=
  chartZeroLocusPointOfNormalizedAlgebra 2 2 i j
      (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
      (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j)
      (residualComponentOnXCoordsNorm_apply p₀ q₀ r N F v i j)
      (residualComponentOnYCoordsNorm_apply p₀ q₀ r N F v i j)
      F (aeval_residualComponentOnCoordsNorm_F p₀ q₀ r N hMN F hF v hv i j) ≫
    chartZeroLocusToGlobal 2 2 k F (hF : IsBihomogeneousOfBidegree 2 3 F) i j

/-- Compatibility with the ambient biprojective chart evaluation. -/
@[reassoc]
theorem residualZeroLocusPointOn_ι
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) :
    residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j ≫
        biprojectiveZeroLocusι 2 2 k F =
      biprojectiveChartPointOfNormalizedAlgebra 2 2 i j
          (residualComponentOnXCoordsNorm p₀ q₀ r N F v i j)
          (residualComponentOnYCoordsNorm p₀ q₀ r N F v i j) ≫
        standardChartι 2 2 k i j := by
  unfold residualZeroLocusPointOn
  rw [Category.assoc, chartZeroLocusToGlobal_ι]
  rw [← Category.assoc,
    chartZeroLocusPointOfNormalizedAlgebra_subschemeι]

/-- The arbitrary-line residual component, defined as the scheme-theoretic image of the localized
residual chart morphism. -/
def residualComponentOn
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) : Scheme.{u} :=
  (residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j).image

/-- Closed immersion of the arbitrary-line residual component into the zero locus. -/
def residualComponentOnι
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) :
    residualComponentOn p₀ q₀ r N hMN F hF v hv i j ⟶
      biprojectiveZeroLocus 2 2 k F :=
  (residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j).imageι

/-- The localized residual morphism corestricted to its scheme-theoretic image. -/
def residualComponentPointOn
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) :
    Spec (.of (residualComponentOnLoc p₀ q₀ r N F v i j)) ⟶
      residualComponentOn p₀ q₀ r N hMN F hF v hv i j :=
  (residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j).toImage

instance residualComponentPointOn_isDominant
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) :
    IsDominant (residualComponentPointOn p₀ q₀ r N hMN F hF v hv i j) :=
  inferInstanceAs
    (IsDominant (residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j).toImage)

@[reassoc (attr := simp)]
theorem residualComponentPointOn_ι
    {k : Type u} [Field k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) :
    residualComponentPointOn p₀ q₀ r N hMN F hF v hv i j ≫
        residualComponentOnι p₀ q₀ r N hMN F hF v hv i j =
      residualZeroLocusPointOn p₀ q₀ r N hMN F hF v hv i j :=
  Scheme.Hom.toImage_imageι _

end

end BConicBundleMultisections
