/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveCoordinateNormalization
public import BConicBundleMultisections.ResidualImageAffineParam
public import BConicBundleMultisections.ResidualImageAlgebraPoint
public import BConicBundleMultisections.ResidualMultisectionDominant
public import BConicBundleMultisections.Unirationality
public import Mathlib.AlgebraicGeometry.AffineSpace
public import Mathlib.AlgebraicGeometry.Birational.Composition
public import Mathlib.AlgebraicGeometry.Birational.RationalMap
public import Mathlib.AlgebraicGeometry.Restrict
public import Mathlib.RingTheory.Localization.Away.Basic

/-!
# Residual-image rational parametrization via chart normalization

Residual stereo coordinates over `k[t,s]` need not be chart-normalized.  Localizing away from a
product of nonzero first- and second-block coordinates makes those coordinates units; scaling
produces normalized representatives, and `residualImagePointOfNormalizedAlgebra` supplies a
morphism from the corresponding basic open of affine 2-space into residual image over `Spec k`.

The resulting partial map packages as a rational map `𝔸² ⤏ residualImage F` over `Spec k`.
Dominance is the remaining geometric input for `HasResidualImageUnirationalParametrization2`.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry Scheme MvPolynomial BiprojectiveSpace ResidualDivisor
open _root_.MvPolynomial Localization

attribute [local instance] MvPolynomial.gradedAlgebra

/-! ### Unit scaling of coordinate representatives -/

/-- Scale a coordinate vector by the inverse of a unit coordinate. -/
def scaleByUnitInv {σ : Type*} {S : Type u} [CommRing S]
    (x : σ → S) (i : σ) (hi : IsUnit (x i)) : σ → S :=
  fun j => (↑hi.unit⁻¹ : S) * x j

@[simp]
theorem scaleByUnitInv_apply {σ : Type*} {S : Type u} [CommRing S]
    (x : σ → S) (i : σ) (hi : IsUnit (x i)) :
    scaleByUnitInv x i hi i = 1 := by
  simp [scaleByUnitInv]

theorem scaleByUnitInv_eq_smul {σ : Type*} {S : Type u} [CommRing S]
    (x : σ → S) (i : σ) (hi : IsUnit (x i)) :
    scaleByUnitInv x i hi = (↑hi.unit⁻¹ : S) • x := by
  funext j
  simp [scaleByUnitInv, Pi.smul_apply, smul_eq_mul]

/-! ### Algebra evaluation after block scaling -/

/-- First-block scaling for bihomogeneous equations under algebra evaluation. -/
theorem aeval_smul_first_of_isBihomogeneous
    {k S : Type u} [CommRing k] [CommRing S] [Algebra k S]
    {m n d e : ℕ} {F : MvPolynomial (BiprojectiveCoordinate m n) k}
    (hF : IsBihomogeneousOfBidegree d e F)
    (r : S) (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) :
    aeval (Sum.elim (fun i => r * x i) y) F =
      r ^ d * aeval (Sum.elim x y) F := by
  have hmap : IsBihomogeneousOfBidegree d e (map (algebraMap k S) F) :=
    hF.map_coefficients (algebraMap k S)
  have hhom :
      (specializeSecondCoordinates (m := m) y (map (algebraMap k S) F)).IsHomogeneous d :=
    hmap.specializeSecondCoordinates_isHomogeneous y
  calc
    aeval (Sum.elim (fun i => r * x i) y) F =
        eval (Sum.elim (fun i => r * x i) y) (map (algebraMap k S) F) := by
      rw [aeval_def, eval₂_eq_eval_map]
    _ = eval (fun i => r * x i)
          (specializeSecondCoordinates y (map (algebraMap k S) F)) := by
      rw [eval_specializeSecondCoordinates]
    _ = r ^ d *
          eval x (specializeSecondCoordinates y (map (algebraMap k S) F)) := by
      simpa [Pi.smul_def, smul_eq_mul] using
        eval_smul_point_of_isHomogeneous hhom r x
    _ = r ^ d * eval (Sum.elim x y) (map (algebraMap k S) F) := by
      rw [eval_specializeSecondCoordinates]
    _ = r ^ d * aeval (Sum.elim x y) F := by
      rw [aeval_def, eval₂_eq_eval_map]

/-- Second-block scaling for bihomogeneous equations under algebra evaluation. -/
theorem aeval_smul_second_of_isBihomogeneous
    {k S : Type u} [CommRing k] [CommRing S] [Algebra k S]
    {m n d e : ℕ} {F : MvPolynomial (BiprojectiveCoordinate m n) k}
    (hF : IsBihomogeneousOfBidegree d e F)
    (r : S) (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) :
    aeval (Sum.elim x (fun j => r * y j)) F =
      r ^ e * aeval (Sum.elim x y) F := by
  have hmap : IsBihomogeneousOfBidegree d e (map (algebraMap k S) F) :=
    hF.map_coefficients (algebraMap k S)
  have hhom :
      (specializeFirstCoordinates (n := n) x (map (algebraMap k S) F)).IsHomogeneous e :=
    hmap.specializeFirstCoordinates_isHomogeneous x
  calc
    aeval (Sum.elim x (fun j => r * y j)) F =
        eval (Sum.elim x (fun j => r * y j)) (map (algebraMap k S) F) := by
      rw [aeval_def, eval₂_eq_eval_map]
    _ = eval (fun j => r * y j)
          (specializeFirstCoordinates x (map (algebraMap k S) F)) := by
      rw [eval_specializeFirstCoordinates]
    _ = r ^ e *
          eval y (specializeFirstCoordinates x (map (algebraMap k S) F)) := by
      simpa [Pi.smul_def, smul_eq_mul] using
        eval_smul_point_of_isHomogeneous hhom r y
    _ = r ^ e * eval (Sum.elim x y) (map (algebraMap k S) F) := by
      rw [eval_specializeFirstCoordinates]
    _ = r ^ e * aeval (Sum.elim x y) F := by
      rw [aeval_def, eval₂_eq_eval_map]

theorem aeval_scaleByUnitInv_first_eq_zero
    {k S : Type u} [CommRing k] [CommRing S] [Algebra k S]
    {m n d e : ℕ} {F : MvPolynomial (BiprojectiveCoordinate m n) k}
    (hF : IsBihomogeneousOfBidegree d e F)
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) (i : Fin (m + 1))
    (hi : IsUnit (x i))
    (hx : aeval (Sum.elim x y) F = 0) :
    aeval (Sum.elim (scaleByUnitInv x i hi) y) F = 0 := by
  rw [scaleByUnitInv_eq_smul, Pi.smul_def]
  simp only [smul_eq_mul]
  rw [aeval_smul_first_of_isBihomogeneous hF, hx, mul_zero]

theorem aeval_scaleByUnitInv_second_eq_zero
    {k S : Type u} [CommRing k] [CommRing S] [Algebra k S]
    {m n d e : ℕ} {F : MvPolynomial (BiprojectiveCoordinate m n) k}
    (hF : IsBihomogeneousOfBidegree d e F)
    (x : Fin (m + 1) → S) (y : Fin (n + 1) → S) (j : Fin (n + 1))
    (hj : IsUnit (y j))
    (hx : aeval (Sum.elim x y) F = 0) :
    aeval (Sum.elim x (scaleByUnitInv y j hj)) F = 0 := by
  rw [scaleByUnitInv_eq_smul, Pi.smul_def]
  simp only [smul_eq_mul]
  rw [aeval_smul_second_of_isBihomogeneous hF, hx, mul_zero]

/-- Residual equation scales by `r^10` in the first block after coefficient extension. -/
theorem aeval_residualEquation_smul_first
    {k S : Type u} [CommRing k] [CommRing S] [Algebra k S]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) k}
    (hF : IsBidegree23 F) (r : S) (x y : Fin 3 → S) :
    aeval (Sum.elim (fun i => r * x i) y) (residualEquation F) =
      r ^ 10 * aeval (Sum.elim x y) (residualEquation F) := by
  have hmap : IsBidegree23 (map (algebraMap k S) F) :=
    hF.map_coefficients (algebraMap k S)
  calc
    aeval (Sum.elim (fun i => r * x i) y) (residualEquation F) =
        eval (Sum.elim (fun i => r * x i) y)
          (map (algebraMap k S) (residualEquation F)) := by
      rw [aeval_def, eval₂_eq_eval_map]
    _ = eval (Sum.elim (fun i => r * x i) y)
          (residualEquation (map (algebraMap k S) F)) := by
      rw [map_residualEquation]
    _ = r ^ 10 *
          eval (Sum.elim x y) (residualEquation (map (algebraMap k S) F)) := by
      simpa [Pi.smul_def, smul_eq_mul] using
        eval_residualEquation_smul_first_of_bidegree23 hmap r x y
    _ = r ^ 10 *
          eval (Sum.elim x y) (map (algebraMap k S) (residualEquation F)) := by
      rw [map_residualEquation]
    _ = r ^ 10 * aeval (Sum.elim x y) (residualEquation F) := by
      rw [aeval_def, eval₂_eq_eval_map]

theorem aeval_residualEquation_scaleByUnitInv_first_eq_zero
    {k S : Type u} [CommRing k] [CommRing S] [Algebra k S]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) k}
    (hF : IsBidegree23 F) (x y : Fin 3 → S) (i : Fin 3) (hi : IsUnit (x i))
    (hx : aeval (Sum.elim x y) (residualEquation F) = 0) :
    aeval (Sum.elim (scaleByUnitInv x i hi) y) (residualEquation F) = 0 := by
  rw [scaleByUnitInv_eq_smul, Pi.smul_def]
  simp only [smul_eq_mul]
  rw [aeval_residualEquation_smul_first hF, hx, mul_zero]

/-- Residual equation is linear in the second block, so second-block unit scaling
preserves zeros. -/
theorem aeval_residualEquation_scaleByUnitInv_second_eq_zero
    {k S : Type u} [CommRing k] [CommRing S] [Algebra k S]
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) k}
    (x y : Fin 3 → S) (j : Fin 3) (hj : IsUnit (y j))
    (hx : aeval (Sum.elim x y) (residualEquation F) = 0) :
    aeval (Sum.elim x (scaleByUnitInv y j hj)) (residualEquation F) = 0 := by
  set c : S := (↑hj.unit⁻¹ : S)
  have hscale : scaleByUnitInv y j hj = fun t => c * y t := rfl
  have hx' :
      eval (Sum.elim x y) (map (algebraMap k S) (residualEquation F)) = 0 := by
    have heq :
        aeval (Sum.elim x y) (residualEquation F) =
          eval (Sum.elim x y) (map (algebraMap k S) (residualEquation F)) := by
      rw [aeval_def, eval₂_eq_eval_map]
    rwa [heq] at hx
  rw [aeval_def, eval₂_eq_eval_map, hscale]
  have hlin :
      eval (Sum.elim x (fun t => c * y t)) (map (algebraMap k S) (residualEquation F)) =
        c * eval (Sum.elim x y) (map (algebraMap k S) (residualEquation F)) := by
    rw [← map_residualEquation, eval_residualEquation, eval_residualEquation]
    simp only [mul_left_comm _ c, ← mul_add]
  rw [hlin, hx', mul_zero]

/-! ### Localization away from a chart-normalizing product -/

/-- Product of selected residual coordinates used for Away-localization. -/
def residualChartDenom
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) : affineTwoRing k :=
  residualImageXCoords F v i * residualYCoords F v j

/-- Localization of the affine plane ring away from the chart-normalizing product. -/
abbrev residualChartLoc
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) : Type u :=
  Away (residualChartDenom F v i j)

instance residualChartLoc_algebra
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    Algebra k (residualChartLoc F v i j) :=
  RingHom.toAlgebra ((algebraMap (affineTwoRing k) (residualChartLoc F v i j)).comp C)

/-- Residual first-block coordinates in the Away localization. -/
def residualImageXCoordsLoc
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    Fin 3 → residualChartLoc F v i j :=
  fun t => algebraMap (affineTwoRing k) _ (residualImageXCoords F v t)

/-- Residual second-block coordinates in the Away localization. -/
def residualYCoordsLoc
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    Fin 3 → residualChartLoc F v i j :=
  fun t => algebraMap (affineTwoRing k) _ (residualYCoords F v t)

theorem isUnit_residualImageXCoordsLoc
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    IsUnit (residualImageXCoordsLoc F v i j i) := by
  have hf : IsUnit (algebraMap (affineTwoRing k) (residualChartLoc F v i j)
      (residualChartDenom F v i j)) :=
    IsLocalization.Away.algebraMap_isUnit (residualChartDenom F v i j)
  -- algebraMap (x_i * y_j) = algebraMap x_i * algebraMap y_j
  have hprod :
      algebraMap (affineTwoRing k) (residualChartLoc F v i j)
          (residualChartDenom F v i j) =
        residualImageXCoordsLoc F v i j i * residualYCoordsLoc F v i j j := by
    simp [residualChartDenom, residualImageXCoordsLoc, residualYCoordsLoc, map_mul]
  have hf' : IsUnit (residualImageXCoordsLoc F v i j i * residualYCoordsLoc F v i j j) := by
    rwa [← hprod]
  exact isUnit_of_mul_isUnit_left hf'

theorem isUnit_residualYCoordsLoc
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    IsUnit (residualYCoordsLoc F v i j j) := by
  have hf : IsUnit (algebraMap (affineTwoRing k) (residualChartLoc F v i j)
      (residualChartDenom F v i j)) :=
    IsLocalization.Away.algebraMap_isUnit (residualChartDenom F v i j)
  have hprod :
      algebraMap (affineTwoRing k) (residualChartLoc F v i j)
          (residualChartDenom F v i j) =
        residualImageXCoordsLoc F v i j i * residualYCoordsLoc F v i j j := by
    simp [residualChartDenom, residualImageXCoordsLoc, residualYCoordsLoc, map_mul]
  have hf' : IsUnit (residualImageXCoordsLoc F v i j i * residualYCoordsLoc F v i j j) := by
    rwa [← hprod]
  exact isUnit_of_mul_isUnit_right hf'

/-- Chart-normalized residual first-block coordinates over the Away localization. -/
def residualImageXCoordsNorm
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    Fin 3 → residualChartLoc F v i j :=
  scaleByUnitInv (residualImageXCoordsLoc F v i j) i
    (isUnit_residualImageXCoordsLoc F v i j)

/-- Chart-normalized residual second-block coordinates over the Away localization. -/
def residualYCoordsNorm
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    Fin 3 → residualChartLoc F v i j :=
  scaleByUnitInv (residualYCoordsLoc F v i j) j
    (isUnit_residualYCoordsLoc F v i j)

@[simp]
theorem residualImageXCoordsNorm_apply
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    residualImageXCoordsNorm F v i j i = 1 :=
  scaleByUnitInv_apply _ _ _

@[simp]
theorem residualYCoordsNorm_apply
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    residualYCoordsNorm F v i j j = 1 :=
  scaleByUnitInv_apply _ _ _

/-- The `k`-algebra structure on the Away localization factors through `k[t,s]`. -/
theorem algebraMap_k_residualChartLoc
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) (a : k) :
    algebraMap k (residualChartLoc F v i j) a =
      algebraMap (affineTwoRing k) (residualChartLoc F v i j) (C a) :=
  rfl

/-- Algebra evaluation at localized residual coords equals localization of the plane evaluation. -/
theorem aeval_comp_algebraMap_residualCoords
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    (p : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    aeval (Sum.elim (residualImageXCoordsLoc F v i j) (residualYCoordsLoc F v i j)) p =
      algebraMap (affineTwoRing k) (residualChartLoc F v i j)
        (aeval (Sum.elim (residualImageXCoords F v) (residualYCoords F v)) p) := by
  induction p using MvPolynomial.induction_on with
  | C a =>
      simp only [aeval_C, algebraMap_k_residualChartLoc, algebraMap_eq]
  | add p q hp hq =>
      simp only [map_add, hp, hq]
  | mul_X p z hp =>
      simp only [map_mul, aeval_X, hp]
      cases z with
      | inl t =>
          simp only [Sum.elim_inl, residualImageXCoordsLoc]
      | inr t =>
          simp only [Sum.elim_inr, residualYCoordsLoc]

theorem aeval_residualCoordsLoc_F
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    aeval (Sum.elim (residualImageXCoordsLoc F v i j) (residualYCoordsLoc F v i j)) F = 0 := by
  rw [aeval_comp_algebraMap_residualCoords, aeval_residualImageCoords_F F hF v hv, map_zero]

theorem aeval_residualCoordsLoc_residualEquation
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    aeval (Sum.elim (residualImageXCoordsLoc F v i j) (residualYCoordsLoc F v i j))
      (residualEquation F) = 0 := by
  rw [aeval_comp_algebraMap_residualCoords,
    aeval_residualImageCoords_residualEquation F hF v hv, map_zero]

theorem aeval_residualCoordsNorm_F
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    aeval (Sum.elim (residualImageXCoordsNorm F v i j) (residualYCoordsNorm F v i j)) F =
      0 := by
  have h0 := aeval_residualCoordsLoc_F F hF v hv i j
  have h1 :=
    aeval_scaleByUnitInv_first_eq_zero (hF : IsBihomogeneousOfBidegree 2 3 F)
      (residualImageXCoordsLoc F v i j) (residualYCoordsLoc F v i j) i
      (isUnit_residualImageXCoordsLoc F v i j) h0
  exact aeval_scaleByUnitInv_second_eq_zero (hF : IsBihomogeneousOfBidegree 2 3 F)
    (residualImageXCoordsNorm F v i j) (residualYCoordsLoc F v i j) j
    (isUnit_residualYCoordsLoc F v i j) h1

theorem aeval_residualCoordsNorm_residualEquation
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    aeval (Sum.elim (residualImageXCoordsNorm F v i j) (residualYCoordsNorm F v i j))
      (residualEquation F) = 0 := by
  have h0 := aeval_residualCoordsLoc_residualEquation F hF v hv i j
  have h1 :=
    aeval_residualEquation_scaleByUnitInv_first_eq_zero hF
      (residualImageXCoordsLoc F v i j) (residualYCoordsLoc F v i j) i
      (isUnit_residualImageXCoordsLoc F v i j) h0
  exact aeval_residualEquation_scaleByUnitInv_second_eq_zero
    (residualImageXCoordsNorm F v i j) (residualYCoordsLoc F v i j) j
    (isUnit_residualYCoordsLoc F v i j) h1

/-- Spec-point of residual image from Away-localized normalized residual coordinates. -/
def residualImagePointOfNormalizedLoc
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    Spec (.of (residualChartLoc F v i j)) ⟶ residualImage F :=
  residualImagePointOfNormalizedAlgebra F i j
    (residualImageXCoordsNorm F v i j) (residualYCoordsNorm F v i j)
    (residualImageXCoordsNorm_apply F v i j) (residualYCoordsNorm_apply F v i j)
    (aeval_residualCoordsNorm_F F hF v hv i j)
    (aeval_residualCoordsNorm_residualEquation F hF v hv i j)

/-! ### Partial / rational map packaging -/

/-- Open immersion of the Away-localization into affine plane Spec. -/
def residualChartLocι
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    Spec (.of (residualChartLoc F v i j)) ⟶ Spec (.of (affineTwoRing k)) :=
  Spec.map (CommRingCat.ofHom
    (algebraMap (affineTwoRing k) (residualChartLoc F v i j)))

/-- Basic open of the chart-normalizing product as an open of `Spec(k[t,s])`. -/
def residualChartBasicOpen
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3) :
    (Spec (.of (affineTwoRing k))).Opens :=
  PrimeSpectrum.basicOpen (residualChartDenom F v i j)

/-- Basic open of the chart-normalizing product is dense when the product is nonzero
(affine plane ring over a field is a domain). -/
theorem dense_residualChartBasicOpen
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k) (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0) :
    Dense (SetLike.coe (residualChartBasicOpen F v i j) :
      Set (Spec (.of (affineTwoRing k)))) := by
  haveI : IsDomain (affineTwoRing k) := inferInstance
  haveI : IrreducibleSpace (Spec (.of (affineTwoRing k))) := inferInstance
  haveI : PreirreducibleSpace (Spec (.of (affineTwoRing k))) :=
    (inferInstance : IrreducibleSpace _).toPreirreducibleSpace
  have hnil : ¬ IsNilpotent (residualChartDenom F v i j) := fun h =>
    hdenom (IsNilpotent.eq_zero h)
  have hne : PrimeSpectrum.basicOpen (residualChartDenom F v i j) ≠ ⊥ :=
    mt (PrimeSpectrum.basicOpen_eq_bot_iff _).mp hnil
  set U : Set (Spec (.of (affineTwoRing k))) :=
    SetLike.coe (residualChartBasicOpen F v i j)
  have hnonempty : U.Nonempty := by
    change (SetLike.coe (PrimeSpectrum.basicOpen (residualChartDenom F v i j)) :
      Set (PrimeSpectrum (affineTwoRing k))).Nonempty
    rw [Set.nonempty_iff_ne_empty]
    intro hempty
    apply hne
    exact TopologicalSpace.Opens.ext hempty
  have hopen : IsOpen U := by
    change IsOpen (SetLike.coe (PrimeSpectrum.basicOpen (residualChartDenom F v i j)) :
      Set (PrimeSpectrum (affineTwoRing k)))
    exact (PrimeSpectrum.basicOpen (residualChartDenom F v i j)).isOpen
  exact (preirreducibleSpace_iff_open_dense _).mp ‹_› hopen hnonempty

/-- Partial residual-image map on the chart-normalizing basic open of affine plane Spec. -/
def residualImagePartialMap
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0) :
    (Spec (.of (affineTwoRing k))).PartialMap (residualImage F) where
  domain := residualChartBasicOpen F v i j
  dense_domain := dense_residualChartBasicOpen F v i j hdenom
  hom :=
    (basicOpenIsoSpecAway
        (R := CommRingCat.of (affineTwoRing k))
        (residualChartDenom F v i j)).hom ≫
      residualImagePointOfNormalizedLoc F hF v hv i j

/-- Rational map `Spec(k[t,s]) ⤏ residualImage F` from chart-normalized residual coordinates. -/
def residualImageRationalMap
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0) :
    Spec (.of (affineTwoRing k)) ⤏ residualImage F :=
  (residualImagePartialMap F hF v hv i j hdenom).toRationalMap

/-! ### Nonzero chart denominators -/

/-- In an integral domain, a product of coordinate vectors is nonzero for some pair of indices
iff neither vector is the zero vector. -/
theorem exists_mul_ne_zero_of_ne_zero_vectors
    {R : Type u} [CommRing R] [IsDomain R] {ι : Type*}
    (x y : ι → R) (hx : x ≠ 0) (hy : y ≠ 0) :
    ∃ i j : ι, x i * y j ≠ 0 := by
  obtain ⟨i, hi⟩ : ∃ i, x i ≠ 0 := by
    by_contra h
    push_neg at h
    exact hx (funext h)
  obtain ⟨j, hj⟩ : ∃ j, y j ≠ 0 := by
    by_contra h
    push_neg at h
    exact hy (funext h)
  exact ⟨i, j, mul_ne_zero hi hj⟩

/-- Nonzero residual first- and second-block coordinate vectors yield a nonzero chart product. -/
theorem exists_residualChartDenom_ne_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (v : Fin 3 → Polynomial k)
    (hX : residualImageXCoords F v ≠ 0)
    (hY : residualYCoords F v ≠ 0) :
    ∃ i j : Fin 3, residualChartDenom F v i j ≠ 0 := by
  haveI : IsDomain (affineTwoRing k) := inferInstance
  obtain ⟨i, j, hij⟩ :=
    exists_mul_ne_zero_of_ne_zero_vectors
      (residualImageXCoords F v) (residualYCoords F v) hX hY
  exact ⟨i, j, hij⟩

/-- Coefficient of `t^n` in `liftPolyT p` recovers `p.coeff n`. -/
theorem coeff_liftPolyT
    {k : Type u} [CommRing k] (p : Polynomial k) (n : ℕ) :
    MvPolynomial.coeff (Finsupp.single (ULift.up (0 : Fin 2)) n)
        (liftPolyT (k := k) p) =
      p.coeff n := by
  simp only [liftPolyT]
  rw [Polynomial.eval₂_eq_sum, Polynomial.sum_def, MvPolynomial.coeff_sum]
  classical
  rw [Finset.sum_eq_single n]
  · simp [affineTwoCoord0, MvPolynomial.coeff_C_mul, MvPolynomial.coeff_X_pow]
  · intro b _ hbn
    simp [affineTwoCoord0, MvPolynomial.coeff_C_mul, MvPolynomial.coeff_X_pow]
    intro hsingle
    have : b = n := by
      have h := congr_arg (fun m : ULift (Fin 2) →₀ ℕ => m (ULift.up 0)) hsingle
      simpa [Finsupp.single_apply, if_pos rfl] using h
    exact (hbn this).elim
  · intro hn
    have : p.coeff n = 0 := by
      by_contra hne
      exact hn (Polynomial.mem_support_iff.mpr hne)
    simp [this]

/-- Embedding `k[X] → k[t,s]` by `X ↦ t` is injective. -/
theorem liftPolyT_injective {k : Type u} [CommRing k] :
    Function.Injective (liftPolyT (k := k)) := by
  intro p q h
  ext n
  simpa [coeff_liftPolyT] using
    congr_arg (MvPolynomial.coeff (Finsupp.single (ULift.up (0 : Fin 2)) n)) h

theorem liftTsenSection_ne_zero
    {k : Type u} [Field k] (v : Fin 3 → Polynomial k) (hv : v ≠ 0) :
    liftTsenSection (k := k) v ≠ 0 := by
  intro h
  apply hv
  funext i
  apply liftPolyT_injective (k := k)
  have hi : liftPolyT (v i) = 0 := by
    simpa [liftTsenSection, Pi.zero_apply] using congr_fun h i
  simpa [liftPolyT, map_zero] using hi

/-- Monomials `t^e` have zero coefficient on multiindices with positive `s`-power. -/
private theorem coeff_X0_pow_s_pos {k : Type u} [CommRing k]
    (n m e : ℕ) (hm : 0 < m) :
    MvPolynomial.coeff
        (Finsupp.single (ULift.up (0 : Fin 2)) n +
          Finsupp.single (ULift.up (1 : Fin 2)) m)
        ((X (ULift.up (0 : Fin 2)) : affineTwoRing k) ^ e) = 0 := by
  rw [MvPolynomial.coeff_X_pow]
  split_ifs with h
  · -- single up0 e = single0 n + single1 m forces the `s`-component of the LHS to be 0 = m
    have h1 :
        (Finsupp.single (ULift.up (0 : Fin 2)) e : ULift.{u} (Fin 2) →₀ ℕ)
            (ULift.up (1 : Fin 2)) =
          (Finsupp.single (ULift.up (0 : Fin 2)) n +
              Finsupp.single (ULift.up (1 : Fin 2)) m)
            (ULift.up (1 : Fin 2)) :=
      congr_arg (fun f : ULift.{u} (Fin 2) →₀ ℕ => f (ULift.up (1 : Fin 2))) h
    have hm0 : m = 0 := by
      have hne : (ULift.up (1 : Fin 2) : ULift.{u} (Fin 2)) ≠ ULift.up (0 : Fin 2) := by
        intro heq
        exact absurd (ULift.up.inj heq) (by decide : (1 : Fin 2) ≠ 0)
      simpa [Finsupp.single_apply, Finsupp.add_apply, hne] using h1.symm
    exact absurd hm0 (ne_of_gt hm)
  · rfl

/-- `liftPolyT p` has no terms with positive power of `s`. -/
theorem coeff_liftPolyT_of_s_pos {k : Type u} [CommRing k]
    (p : Polynomial k) (n m : ℕ) (hm : 0 < m) :
    MvPolynomial.coeff
        (Finsupp.single (ULift.up (0 : Fin 2)) n +
          Finsupp.single (ULift.up (1 : Fin 2)) m)
        (liftPolyT (k := k) p) = 0 := by
  simp only [liftPolyT]
  rw [Polynomial.eval₂_eq_sum, Polynomial.sum_def, MvPolynomial.coeff_sum]
  apply Finset.sum_eq_zero
  intro e _
  simp only [affineTwoCoord0, MvPolynomial.coeff_C_mul]
  rw [coeff_X0_pow_s_pos n m e hm, mul_zero]

/-- If `liftPolyT a = liftPolyT b * s`, then `a = b = 0`. -/
theorem liftPolyT_eq_liftPolyT_mul_s {k : Type u} [Field k]
    (a b : Polynomial k)
    (h : liftPolyT (k := k) a = liftPolyT (k := k) b * affineTwoCoord1 k) :
    a = 0 ∧ b = 0 := by
  have hR (n : ℕ) :
      MvPolynomial.coeff
          (Finsupp.single (ULift.up (0 : Fin 2)) n + Finsupp.single (ULift.up 1) 1)
          (liftPolyT (k := k) b * affineTwoCoord1 k) =
        b.coeff n := by
    have hmul :=
      MvPolynomial.coeff_mul_X (Finsupp.single (ULift.up (0 : Fin 2)) n)
        (ULift.up (1 : Fin 2)) (liftPolyT (k := k) b)
    simpa [affineTwoCoord1, coeff_liftPolyT] using hmul.symm
  have hb : b = 0 := by
    ext n
    have hL := coeff_liftPolyT_of_s_pos a n 1 (by decide)
    have hEq := congr_arg
      (MvPolynomial.coeff
        (Finsupp.single (ULift.up (0 : Fin 2)) n + Finsupp.single (ULift.up 1) 1)) h
    exact (hR n).symm.trans (hEq.symm.trans hL)
  have ha : a = 0 := by
    apply liftPolyT_injective (k := k)
    rw [h, hb]
    simp [liftPolyT]
  exact ⟨ha, hb⟩

/-- Free-direction quadratic form of the specialized conic: `Q(1,s,0)`. -/
def specializedConicFreeDirForm {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : affineTwoRing k :=
  eval (affineTwoStereoDir (k := k)) (specializedConicPullback F)

/-- Expansion of the free-direction form via upper-triangular ternary coefficients. -/
theorem specializedConicFreeDirForm_eq {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    specializedConicFreeDirForm F =
      ternaryQuadraticCoeff (specializedConicPullback F) 0 0 +
        ternaryQuadraticCoeff (specializedConicPullback F) 0 1 * affineTwoCoord1 k +
          ternaryQuadraticCoeff (specializedConicPullback F) 1 1 *
            (affineTwoCoord1 k) ^ 2 := by
  have hf := specializedConicPullback_isHomogeneous F hF
  have hsum := eval_eq_ternaryQuadraticCoeff_sum hf (affineTwoStereoDir (k := k))
  -- Upper-triangular convention: coeff j i = 0 for j > i
  have h10 : ternaryQuadraticCoeff (specializedConicPullback F) 1 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (1 : Fin 3) < 0 by decide]
  have h20 : ternaryQuadraticCoeff (specializedConicPullback F) 2 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 0 by decide]
  have h21 : ternaryQuadraticCoeff (specializedConicPullback F) 2 1 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 1 by decide]
  -- Expand the double sum on w = (1,s,0)
  simp only [specializedConicFreeDirForm] at hsum ⊢
  rw [hsum]
  simp only [Fin.sum_univ_three, affineTwoStereoDir, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.cons_val_two, Matrix.tail_cons, h10, h20, h21, mul_zero, zero_mul,
    add_zero, zero_add, mul_one, one_mul]
  ring

/-- The free-direction form is the lift of the polynomial specialized-conic free form. -/
theorem specializedConicFreeDirForm_eq_lift {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    specializedConicFreeDirForm F =
      liftPolyT (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) 0 0) +
        liftPolyT (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) 0 1) *
          affineTwoCoord1 k +
          liftPolyT (ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) 1 1) *
            (affineTwoCoord1 k) ^ 2 := by
  rw [specializedConicFreeDirForm_eq F hF]
  simp only [ternaryQuadraticCoeff_specializedConicPullback]

/-- Coefficient of multiindex `m` in `f * s` via `coeff_mul_X'`. -/
private theorem coeff_mul_affineTwoCoord1 {k : Type u} [CommRing k]
    (f : affineTwoRing k) (m : ULift.{u} (Fin 2) →₀ ℕ) :
    MvPolynomial.coeff m (f * affineTwoCoord1 k) =
      if ULift.up (1 : Fin 2) ∈ m.support then
        MvPolynomial.coeff (m - Finsupp.single (ULift.up (1 : Fin 2)) 1) f
      else 0 := by
  simpa [affineTwoCoord1] using MvPolynomial.coeff_mul_X' m (ULift.up (1 : Fin 2)) f

/-- Pure `t^n` multiindices do not contain the `s`-variable. -/
private theorem not_mem_support_s_of_pure_t (n : ℕ) :
    ULift.up (1 : Fin 2) ∉
      (Finsupp.single (ULift.up (0 : Fin 2)) n : ULift.{u} (Fin 2) →₀ ℕ).support := by
  simp [Finsupp.mem_support_iff, Finsupp.single_apply,
    show (ULift.up (1 : Fin 2) : ULift.{u} (Fin 2)) ≠ ULift.up 0 by
      intro heq; exact absurd (ULift.up.inj heq) (by decide)]

/-- `s` belongs to the support of `t^n s`. -/
private theorem mem_support_s_of_t_s (n : ℕ) :
    ULift.up (1 : Fin 2) ∈
      (Finsupp.single (ULift.up (0 : Fin 2)) n +
        Finsupp.single (ULift.up (1 : Fin 2)) 1 : ULift.{u} (Fin 2) →₀ ℕ).support := by
  simp [Finsupp.mem_support_iff, Finsupp.single_apply, Finsupp.add_apply]

/-- `s` belongs to the support of `t^n s^2`. -/
private theorem mem_support_s_of_t_s2 (n : ℕ) :
    ULift.up (1 : Fin 2) ∈
      (Finsupp.single (ULift.up (0 : Fin 2)) n +
        Finsupp.single (ULift.up (1 : Fin 2)) 2 : ULift.{u} (Fin 2) →₀ ℕ).support := by
  simp [Finsupp.mem_support_iff, Finsupp.single_apply, Finsupp.add_apply]

/-- If the free-direction form vanishes, its three polynomial specialized-conic coefficients vanish. -/
theorem freeDir_coeffs_eq_zero_of_freeDirForm_eq_zero {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0) :
    ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) 0 0 = 0 ∧
      ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) 0 1 = 0 ∧
        ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) 1 1 = 0 := by
  set c00 := ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) 0 0
  set c01 := ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) 0 1
  set c11 := ternaryQuadraticCoeff (coordinateLineSpecializedConicPoly F) 1 1
  have hform :
      liftPolyT c00 + liftPolyT c01 * affineTwoCoord1 k +
          liftPolyT c11 * (affineTwoCoord1 k) ^ 2 = 0 := by
    simpa [c00, c01, c11, specializedConicFreeDirForm_eq_lift F hF] using hα
  have hc00 : c00 = 0 := by
    ext n
    have hL :=
      congr_arg (MvPolynomial.coeff (Finsupp.single (ULift.up (0 : Fin 2)) n)) hform
    have h01 :
        MvPolynomial.coeff (Finsupp.single (ULift.up (0 : Fin 2)) n)
            (liftPolyT c01 * affineTwoCoord1 k) = 0 := by
      rw [coeff_mul_affineTwoCoord1, if_neg (not_mem_support_s_of_pure_t n)]
    have h11 :
        MvPolynomial.coeff (Finsupp.single (ULift.up (0 : Fin 2)) n)
            (liftPolyT c11 * (affineTwoCoord1 k) ^ 2) = 0 := by
      have htmp : liftPolyT c11 * (affineTwoCoord1 k) ^ 2 =
          (liftPolyT c11 * affineTwoCoord1 k) * affineTwoCoord1 k := by ring
      rw [htmp, coeff_mul_affineTwoCoord1, if_neg (not_mem_support_s_of_pure_t n)]
    have h00 := coeff_liftPolyT c00 n
    have : MvPolynomial.coeff (Finsupp.single (ULift.up (0 : Fin 2)) n) (liftPolyT c00) = 0 := by
      simpa [MvPolynomial.coeff_add, h01, h11, add_zero, MvPolynomial.coeff_zero] using hL
    exact h00.symm.trans this
  have hc01 : c01 = 0 := by
    ext n
    set m :=
      Finsupp.single (ULift.up (0 : Fin 2)) n + Finsupp.single (ULift.up (1 : Fin 2)) 1
        with hm_def
    have hL := congr_arg (MvPolynomial.coeff m) hform
    have h00 : MvPolynomial.coeff m (liftPolyT c00) = 0 := by
      simpa [m] using coeff_liftPolyT_of_s_pos c00 n 1 (by decide)
    have h01 :
        MvPolynomial.coeff m (liftPolyT c01 * affineTwoCoord1 k) = c01.coeff n := by
      rw [coeff_mul_affineTwoCoord1, if_pos (mem_support_s_of_t_s n)]
      have hsub : m - Finsupp.single (ULift.up (1 : Fin 2)) 1 =
          Finsupp.single (ULift.up (0 : Fin 2)) n := by
        ext i
        simp only [m, Finsupp.coe_tsub, Pi.sub_apply, Finsupp.single_apply, Finsupp.add_apply]
        split_ifs <;> omega
      rw [hsub, coeff_liftPolyT]
    have h11 :
        MvPolynomial.coeff m (liftPolyT c11 * (affineTwoCoord1 k) ^ 2) = 0 := by
      have htmp : liftPolyT c11 * (affineTwoCoord1 k) ^ 2 =
          (liftPolyT c11 * affineTwoCoord1 k) * affineTwoCoord1 k := by ring
      rw [htmp, coeff_mul_affineTwoCoord1, if_pos (mem_support_s_of_t_s n)]
      have hsub : m - Finsupp.single (ULift.up (1 : Fin 2)) 1 =
          Finsupp.single (ULift.up (0 : Fin 2)) n := by
        ext i
        simp only [m, Finsupp.coe_tsub, Pi.sub_apply, Finsupp.single_apply, Finsupp.add_apply]
        split_ifs <;> omega
      rw [hsub, coeff_mul_affineTwoCoord1, if_neg (not_mem_support_s_of_pure_t n)]
    have hsum :
        MvPolynomial.coeff m (liftPolyT c00) +
            MvPolynomial.coeff m (liftPolyT c01 * affineTwoCoord1 k) +
              MvPolynomial.coeff m (liftPolyT c11 * (affineTwoCoord1 k) ^ 2) = 0 := by
      simpa [MvPolynomial.coeff_add, MvPolynomial.coeff_zero] using hL
    -- reduce using h00, h11
    have hsum' : MvPolynomial.coeff m (liftPolyT c01 * affineTwoCoord1 k) = 0 := by
      linear_combination hsum - h00 - h11
    exact h01.symm.trans hsum'
  have hc11 : c11 = 0 := by
    ext n
    set m :=
      Finsupp.single (ULift.up (0 : Fin 2)) n + Finsupp.single (ULift.up (1 : Fin 2)) 2
    have hL := congr_arg (MvPolynomial.coeff m) hform
    have h00 : MvPolynomial.coeff m (liftPolyT c00) = 0 := by
      simpa [m] using coeff_liftPolyT_of_s_pos c00 n 2 (by decide)
    have h01 :
        MvPolynomial.coeff m (liftPolyT c01 * affineTwoCoord1 k) = 0 := by
      rw [coeff_mul_affineTwoCoord1, if_pos (mem_support_s_of_t_s2 n)]
      have hsub : m - Finsupp.single (ULift.up (1 : Fin 2)) 1 =
          Finsupp.single (ULift.up (0 : Fin 2)) n +
            Finsupp.single (ULift.up (1 : Fin 2)) 1 := by
        ext i
        simp only [m, Finsupp.coe_tsub, Pi.sub_apply, Finsupp.single_apply, Finsupp.add_apply]
        split_ifs <;> omega
      rw [hsub]
      exact coeff_liftPolyT_of_s_pos c01 n 1 (by decide)
    have h11 :
        MvPolynomial.coeff m (liftPolyT c11 * (affineTwoCoord1 k) ^ 2) = c11.coeff n := by
      have htmp : liftPolyT c11 * (affineTwoCoord1 k) ^ 2 =
          (liftPolyT c11 * affineTwoCoord1 k) * affineTwoCoord1 k := by ring
      rw [htmp, coeff_mul_affineTwoCoord1, if_pos (mem_support_s_of_t_s2 n)]
      have hsub : m - Finsupp.single (ULift.up (1 : Fin 2)) 1 =
          Finsupp.single (ULift.up (0 : Fin 2)) n +
            Finsupp.single (ULift.up (1 : Fin 2)) 1 := by
        ext i
        simp only [m, Finsupp.coe_tsub, Pi.sub_apply, Finsupp.single_apply, Finsupp.add_apply]
        split_ifs <;> omega
      rw [hsub, coeff_mul_affineTwoCoord1, if_pos (mem_support_s_of_t_s n)]
      have hsub2 :
          (Finsupp.single (ULift.up (0 : Fin 2)) n +
                Finsupp.single (ULift.up (1 : Fin 2)) 1) -
              Finsupp.single (ULift.up (1 : Fin 2)) 1 =
            Finsupp.single (ULift.up (0 : Fin 2)) n := by
        ext i
        simp only [Finsupp.coe_tsub, Pi.sub_apply, Finsupp.single_apply, Finsupp.add_apply]
        split_ifs <;> omega
      rw [hsub2, coeff_liftPolyT]
    have hsum :
        MvPolynomial.coeff m (liftPolyT c00) +
            MvPolynomial.coeff m (liftPolyT c01 * affineTwoCoord1 k) +
              MvPolynomial.coeff m (liftPolyT c11 * (affineTwoCoord1 k) ^ 2) = 0 := by
      simpa [MvPolynomial.coeff_add, MvPolynomial.coeff_zero] using hL
    have hsum' : MvPolynomial.coeff m (liftPolyT c11 * (affineTwoCoord1 k) ^ 2) = 0 := by
      linear_combination hsum - h00 - h01
    exact h11.symm.trans hsum'
  exact ⟨hc00, hc01, hc11⟩

/-- Free-direction form vanishing forces the specialized-conic free-block coefficients over
`k[t,s]` to vanish. -/
theorem specializedConic_freeBlock_eq_zero_of_freeDirForm_eq_zero {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0) :
    ternaryQuadraticCoeff (specializedConicPullback F) 0 0 = 0 ∧
      ternaryQuadraticCoeff (specializedConicPullback F) 0 1 = 0 ∧
        ternaryQuadraticCoeff (specializedConicPullback F) 1 1 = 0 := by
  obtain ⟨h00, h01, h11⟩ := freeDir_coeffs_eq_zero_of_freeDirForm_eq_zero F hF hα
  refine ⟨?_, ?_, ?_⟩
  · simpa [ternaryQuadraticCoeff_specializedConicPullback, h00, liftPolyT, map_zero]
  · simpa [ternaryQuadraticCoeff_specializedConicPullback, h01, liftPolyT, map_zero]
  · simpa [ternaryQuadraticCoeff_specializedConicPullback, h11, liftPolyT, map_zero]

/-- If the free-direction form vanishes, the specialized conic vanishes on the line `X₂ = 0`. -/
theorem eval_specializedConicPullback_of_freeDirForm_eq_zero {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0)
    (x0 x1 : affineTwoRing k) :
    eval (![x0, x1, (0 : affineTwoRing k)]) (specializedConicPullback F) = 0 := by
  have hf := specializedConicPullback_isHomogeneous F hF
  have hsum := eval_eq_ternaryQuadraticCoeff_sum hf (![x0, x1, (0 : affineTwoRing k)])
  obtain ⟨z00, z01, z11⟩ := specializedConic_freeBlock_eq_zero_of_freeDirForm_eq_zero F hF hα
  have h10 : ternaryQuadraticCoeff (specializedConicPullback F) 1 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (1 : Fin 3) < 0 by decide]
  have h20 : ternaryQuadraticCoeff (specializedConicPullback F) 2 0 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 0 by decide]
  have h21 : ternaryQuadraticCoeff (specializedConicPullback F) 2 1 = 0 := by
    simp [ternaryQuadraticCoeff, show ¬ (2 : Fin 3) < 1 by decide]
  -- On X₂ = 0 only free-block terms survive; those coefficients vanish
  rw [hsum]
  simp only [Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.cons_val_two, Matrix.tail_cons, z00, z01, z11, h10, h20, h21, mul_zero, zero_mul,
    add_zero, zero_add]

/-- Free-direction form vanishing implies the biprojective equation vanishes on
`X₂ = 0` along the coordinate line `Y = (1, t, 0)`. -/
theorem eval_F_of_freeDirForm_eq_zero {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (hα : specializedConicFreeDirForm F = 0)
    (x0 x1 : affineTwoRing k) :
    eval (Sum.elim (![x0, x1, (0 : affineTwoRing k)]) (affineTwoCoordinateLineY k))
      (affineTwoPullback F) = 0 := by
  rw [← eval_specializedConicPullback]
  exact eval_specializedConicPullback_of_freeDirForm_eq_zero F hF hα x0 x1

/-- Stereographic residual first-block coordinates are nonzero when the free-direction form is
nonzero and the Tsen section is nonzero.

If `stereoAlg` vanished with `Q(1,s,0) ≠ 0`, the relation `p₁ = p₀ · s` would force the Tsen
lift to be zero by s-independence of `liftPolyT`. -/
theorem residualImageXCoords_ne_zero_of_freeDir_ne_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (_hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (_hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hα0 : specializedConicFreeDirForm F ≠ 0) :
    residualImageXCoords F v ≠ 0 := by
  intro h
  have hpne : liftTsenSection (k := k) v ≠ 0 := liftTsenSection_ne_zero v hv0
  set p := liftTsenSection (k := k) v
  set w := affineTwoStereoDir (k := k)
  set fQ := specializedConicPullback F
  have hst : stereoAlg fQ p w = 0 := by
    simpa [residualImageXCoords, stereoFirstCoords, p, w, fQ] using h
  set α := eval w fQ
  set β := polarEval fQ p w
  have hαdef : α = specializedConicFreeDirForm F := rfl
  have hα : α ≠ 0 := by simpa [hαdef] using hα0
  have hw0 : w 0 = 1 := by simp [w, affineTwoStereoDir]
  have hw1 : w 1 = affineTwoCoord1 k := by simp [w, affineTwoStereoDir]
  have hw2 : w 2 = 0 := by simp [w, affineTwoStereoDir]
  -- Component equations from stereoAlg = 0
  have h0 : α * p 0 - β * w 0 = 0 := by
    change (α * p 0 - β * w 0) = (0 : affineTwoRing k)
    simpa [stereoAlg, α, β] using congr_fun hst 0
  have h1 : α * p 1 - β * w 1 = 0 := by
    change (α * p 1 - β * w 1) = (0 : affineTwoRing k)
    simpa [stereoAlg, α, β] using congr_fun hst 1
  have h2 : α * p 2 - β * w 2 = 0 := by
    change (α * p 2 - β * w 2) = (0 : affineTwoRing k)
    simpa [stereoAlg, α, β] using congr_fun hst 2
  simp only [hw0, hw2, mul_one, mul_zero, sub_zero] at h0 h2
  have hp2 : p 2 = 0 := (mul_eq_zero.mp h2).resolve_left hα
  have hβeq : β = α * p 0 := by linear_combination -h0
  have hp1eq : p 1 = p 0 * w 1 := by
    have h1' : α * p 1 - (α * p 0) * w 1 = 0 := by
      simpa [hβeq] using h1
    have : α * (p 1 - p 0 * w 1) = 0 := by
      convert h1' using 1; ring
    exact eq_of_sub_eq_zero ((mul_eq_zero.mp this).resolve_left hα)
  have heq :
      liftPolyT (v 1) = liftPolyT (v 0) * affineTwoCoord1 k := by
    simpa [p, liftTsenSection, hw1] using hp1eq
  obtain ⟨hv1, hv0'⟩ := liftPolyT_eq_liftPolyT_mul_s (v 1) (v 0) heq
  have hp0z : p 0 = 0 := by simp [p, liftTsenSection, hv0', liftPolyT]
  have hp1z : p 1 = 0 := by simp [p, liftTsenSection, hv1, liftPolyT]
  have : p = 0 := by
    funext i
    fin_cases i <;> simp [hp0z, hp1z, hp2]
  exact hpne this

/-- Stereographic residual first-block coordinates are nonzero for a nonzero Tsen section once
the free-direction form is known to be nonzero.

Free-direction nonvanishing for smooth `F` is the remaining geometric input
(`specializedConicFreeDirForm_ne_zero_of_smooth`). -/
theorem residualImageXCoords_ne_zero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hα0 : specializedConicFreeDirForm F ≠ 0) :
    residualImageXCoords F v ≠ 0 :=
  residualImageXCoords_ne_zero_of_freeDir_ne_zero F hF v hv0 hv hα0

/--
Chart-localized residual ofHom package.

Given a Tsen section and chart indices with nonzero residual chart product, residual stereo
coordinates normalize on a dense open of affine 2-space and define a rational map into residual
image over `k`.

Remaining for `HasResidualImageUnirationalParametrization2 F`:
1. prove residual coordinate vectors are nonzero (⇒ some chart product nonzero);
2. transport along `AffineSpace.SpecIso` to a map from `𝔸²`;
3. structure over `Spec k` and dominance.
-/
theorem residualImage_chartLoc_package_summary
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    ∃ (v : Fin 3 → Polynomial k)
      (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0),
      v ≠ 0 ∧
        ∀ (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0),
          ∃ f : Spec (.of (affineTwoRing k)) ⤏ residualImage F,
            f = residualImageRationalMap F hF v hv i j hdenom := by
  obtain ⟨v, hv0, hv⟩ := exists_isotropic_coordinateLine_conic k F
  exact ⟨v, hv, hv0, fun i j hdenom =>
    ⟨residualImageRationalMap F hF v hv i j hdenom, rfl⟩⟩

/-- Rational map from residual chart data under nonzero residual coordinate vectors. -/
theorem exists_residualImageRationalMap_of_ne_zero_coords
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hX : residualImageXCoords F v ≠ 0)
    (hY : residualYCoords F v ≠ 0) :
    ∃ (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0),
      Nonempty (Spec (.of (affineTwoRing k)) ⤏ residualImage F) := by
  obtain ⟨i, j, hdenom⟩ := exists_residualChartDenom_ne_zero F v hX hY
  exact ⟨i, j, hdenom, ⟨residualImageRationalMap F hF v hv i j hdenom⟩⟩

/-! ### SpecIso transport to affine 2-space -/

/-- Rational map `𝔸² ⤏ residualImage F` obtained by transporting the Spec-plane rational map
along `AffineSpace.SpecIso`. -/
def residualImageRationalMapAffine
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0) :
    𝔸(ULift.{u} (Fin 2); Spec (.of k)) ⤏ residualImage F :=
  let e := AffineSpace.SpecIso (ULift.{u} (Fin 2)) (CommRingCat.of k)
  haveI : IsDominant e.hom := inferInstance
  haveI : e.hom.toRationalMap.IsDominant := inferInstance
  Scheme.RationalMap.comp e.hom.toRationalMap
    (residualImageRationalMap F hF v hv i j hdenom)


/-! ### Structure of localized residual point over `Spec k` -/

/-- The localized residual-image point is a section of `residualImageToSpec` over `Spec k`. -/
theorem residualImagePointOfNormalizedLoc_comp_residualImageToSpec
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3) :
    residualImagePointOfNormalizedLoc F hF v hv i j ≫ residualImageToSpec F =
      Spec.map (CommRingCat.ofHom (algebraMap k (residualChartLoc F v i j))) :=
  residualImagePointOfNormalizedAlgebra_toSpec F i j
    (residualImageXCoordsNorm F v i j) (residualYCoordsNorm F v i j)
    (residualImageXCoordsNorm_apply F v i j) (residualYCoordsNorm_apply F v i j)
    (aeval_residualCoordsNorm_F F hF v hv i j)
    (aeval_residualCoordsNorm_residualEquation F hF v hv i j)

/-- Partial residual map composed with residual-image structure factors through the basic-open iso
and the algebra structure map `k → Away`. -/
theorem residualImagePartialMap_hom_comp_residualImageToSpec
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0) :
    (residualImagePartialMap F hF v hv i j hdenom).hom ≫ residualImageToSpec F =
      (basicOpenIsoSpecAway
          (R := CommRingCat.of (affineTwoRing k))
          (residualChartDenom F v i j)).hom ≫
        Spec.map (CommRingCat.ofHom (algebraMap k (residualChartLoc F v i j))) := by
  dsimp [residualImagePartialMap]
  rw [Category.assoc, residualImagePointOfNormalizedLoc_comp_residualImageToSpec F hF v hv i j]
  rfl

/-! ### Structure over `Spec k` (IsOver) for residual rational maps -/

/-- Postcomposing the Spec-plane residual rational map by `residualImageToSpec` recovers the
structure map `Spec(k[t,s]) → Spec k` induced by `C : k → k[t,s]`. -/
theorem residualImageRationalMap_compHom_residualImageToSpec
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0) :
    (residualImageRationalMap F hF v hv i j hdenom).compHom (residualImageToSpec F) =
      (Spec.map (CommRingCat.ofHom (C : k →+* affineTwoRing k))).toRationalMap := by
  dsimp only [residualImageRationalMap]
  rw [← RationalMap.compHom_toRationalMap]
  -- Compare partial maps on the chart basic open: both restrict to `U.ι ≫ Spec.map C`.
  let X : Scheme.{u} := Spec (.of (affineTwoRing k))
  let φ : X.PartialMap (residualImage F) := residualImagePartialMap F hF v hv i j hdenom
  let f : X.PartialMap (Spec (.of k)) := φ.compHom (residualImageToSpec F)
  let sC : X ⟶ Spec (.of k) :=
    Spec.map (CommRingCat.ofHom (C : k →+* affineTwoRing k))
  let g : X.PartialMap (Spec (.of k)) := sC.toPartialMap
  change f.toRationalMap = g.toRationalMap
  refine PartialMap.toRationalMap_eq_iff.mpr ?_
  refine ⟨f.domain, f.dense_domain, le_rfl, le_top, ?_⟩
  have hhom : f.hom = f.domain.ι ≫ sC := by
    dsimp [f, φ, PartialMap.compHom]
    rw [residualImagePartialMap_hom_comp_residualImageToSpec]
    -- `algebraMap k Away = algebraMap affine Away ∘ C`, so Spec.map factors; then
    -- `basicOpenIso.hom ≫ Spec.map (affine → Away) = U.ι`.
    change
      (basicOpenIsoSpecAway
          (R := CommRingCat.of (affineTwoRing k))
          (residualChartDenom F v i j)).hom ≫
        Spec.map (CommRingCat.ofHom
          ((algebraMap (affineTwoRing k) (residualChartLoc F v i j)).comp
            (C : k →+* affineTwoRing k))) =
        (residualImagePartialMap F hF v hv i j hdenom).domain.ι ≫ sC
    rw [CommRingCat.ofHom_comp, Spec.map_comp, ← Category.assoc,
      basicOpenIsoSpecAway_hom_SpecMap]
    rfl
  change X.homOfLE (le_rfl : f.domain ≤ f.domain) ≫ f.hom =
    X.homOfLE (le_top : f.domain ≤ ⊤) ≫ g.hom
  have hg : g.hom = X.topIso.hom ≫ sC := rfl
  rw [Scheme.homOfLE_rfl, Category.id_comp, hhom, hg]
  have hι : f.domain.ι = X.homOfLE (le_top : f.domain ≤ ⊤) ≫ X.topIso.hom := by
    rw [Scheme.topIso_hom]
    exact (Scheme.homOfLE_ι X (le_top : f.domain ≤ ⊤)).symm
  rw [hι, Category.assoc]

/-- Partial-map reassociation: `(f.comp g).compHom h = f.comp (g.compHom h)`. -/
theorem partialMap_comp_compHom_eq {X Y Z W : Scheme.{u}} [PreirreducibleSpace X] [Nonempty Y]
    (f : X.PartialMap Y) [IsDominant f.hom] (g : Y.PartialMap Z) (h : Z ⟶ W) :
    (f.comp g).compHom h = f.comp (g.compHom h) := by
  refine PartialMap.ext _ _ rfl ?_
  change ((f.comp g).compHom h).hom =
    (X.isoOfEq (rfl : ((f.comp g).compHom h).domain = (f.comp (g.compHom h)).domain)).hom ≫
      (f.comp (g.compHom h)).hom
  simp only [isoOfEq_rfl, Iso.refl_hom, Category.id_comp]
  rfl

/-- Transport of residual IsOver along `AffineSpace.SpecIso`: the affine residual rational map is
a section of `residualImageToSpec` over `Spec k`. -/
theorem residualImageRationalMapAffine_compHom_residualImageToSpec
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0) :
    (residualImageRationalMapAffine F hF v hv i j hdenom).compHom (residualImageToSpec F) =
      (𝔸(ULift.{u} (Fin 2); Spec (.of k)) ↘ Spec (.of k)).toRationalMap := by
  dsimp only [residualImageRationalMapAffine, residualImageRationalMap]
  let e := AffineSpace.SpecIso (ULift.{u} (Fin 2)) (CommRingCat.of k)
  haveI : IsDominant e.hom := inferInstance
  -- Unfold rational composition as partial composition.
  have hcomp :
      e.hom.toRationalMap.comp
          (residualImagePartialMap F hF v hv i j hdenom).toRationalMap =
        (e.hom.toPartialMap.comp
          (residualImagePartialMap F hF v hv i j hdenom)).toRationalMap :=
    RationalMap.toRationalMap_comp e.hom.toPartialMap
      (residualImagePartialMap F hF v hv i j hdenom)
  rw [hcomp, ← RationalMap.compHom_toRationalMap]
  -- Reassociate: `(e.comp residual).compHom toSpec = e.comp (residual.compHom toSpec)`.
  have hreassoc :
      ((e.hom.toPartialMap.comp
          (residualImagePartialMap F hF v hv i j hdenom)).compHom
        (residualImageToSpec F)) =
      e.hom.toPartialMap.comp
        ((residualImagePartialMap F hF v hv i j hdenom).compHom
          (residualImageToSpec F)) :=
    partialMap_comp_compHom_eq _ _ _
  rw [hreassoc]
  -- residual.compHom toSpec ~ Spec.map C; transport under left composition with e.
  have h1 :
      ((residualImagePartialMap F hF v hv i j hdenom).compHom
          (residualImageToSpec F)).toRationalMap =
        (Spec.map (CommRingCat.ofHom
          (C : k →+* affineTwoRing k))).toRationalMap := by
    simpa [residualImageRationalMap, RationalMap.compHom_toRationalMap] using
      residualImageRationalMap_compHom_residualImageToSpec F hF v hv i j hdenom
  have hequiv :
      ((residualImagePartialMap F hF v hv i j hdenom).compHom
          (residualImageToSpec F)).equiv
        (Spec.map (CommRingCat.ofHom
          (C : k →+* affineTwoRing k))).toPartialMap :=
    PartialMap.toRationalMap_eq_iff.mp h1
  have hequiv' :
      (e.hom.toPartialMap.comp
          ((residualImagePartialMap F hF v hv i j hdenom).compHom
            (residualImageToSpec F))).equiv
        (e.hom.toPartialMap.comp
          (Spec.map (CommRingCat.ofHom
            (C : k →+* affineTwoRing k))).toPartialMap) :=
    PartialMap.comp_equiv_of_equiv_right _ hequiv
  rw [PartialMap.toRationalMap_eq_iff.mpr hequiv', PartialMap.comp_toPartialMap,
    Hom.toPartialMap_compHom, SpecIso_hom_comp_map_C]

/-- Package unirationality of residual image from nonzero residual coords and dominance.
IsOver is supplied by `residualImageRationalMapAffine_compHom_residualImageToSpec`. -/
theorem hasResidualImageUnirationalParametrization2_of_ne_zero_coords_and_dominant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (_hX : residualImageXCoords F v ≠ 0)
    (_hY : residualYCoords F v ≠ 0)
    (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0)
    (hdom : (residualImageRationalMapAffine F hF v hv i j hdenom).IsDominant) :
    HasResidualImageUnirationalParametrization2 F :=
  ⟨{ map := residualImageRationalMapAffine F hF v hv i j hdenom
     isDominant := hdom
     isOver := residualImageRationalMapAffine_compHom_residualImageToSpec
       F hF v hv i j hdenom }⟩

/-- Existence form: nonzero residual coordinate vectors yield a residual-image unirationality
package once dominance is supplied (IsOver is unconditional). -/
theorem exists_hasResidualImageUnirationalParametrization2_of_ne_zero_coords
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hX : residualImageXCoords F v ≠ 0)
    (hY : residualYCoords F v ≠ 0)
    (hdom :
      ∀ (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0),
        (residualImageRationalMapAffine F hF v hv i j hdenom).IsDominant) :
    HasResidualImageUnirationalParametrization2 F := by
  obtain ⟨i, j, hdenom⟩ := exists_residualChartDenom_ne_zero F v hX hY
  exact hasResidualImageUnirationalParametrization2_of_ne_zero_coords_and_dominant
    F hF v hv hX hY i j hdenom (hdom i j hdenom)

/-! ### Dominance of residual rational maps (reductions) -/

/-- The Spec-plane residual rational map is dominant iff its partial morphism is. -/
theorem isDominant_residualImageRationalMap_iff
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0) :
    (residualImageRationalMap F hF v hv i j hdenom).IsDominant ↔
      IsDominant (residualImagePartialMap F hF v hv i j hdenom).hom :=
  (residualImagePartialMap F hF v hv i j hdenom).isDominant_toRationalMap_iff

/-- Partial residual morphism factors as basic-open iso followed by the localized residual point. -/
theorem residualImagePartialMap_hom_eq
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0) :
    (residualImagePartialMap F hF v hv i j hdenom).hom =
      (basicOpenIsoSpecAway
          (R := CommRingCat.of (affineTwoRing k))
          (residualChartDenom F v i j)).hom ≫
        residualImagePointOfNormalizedLoc F hF v hv i j :=
  rfl

/-- Dominance of the partial residual morphism reduces to dominance of the localized residual point
(the basic-open iso is an isomorphism, hence dominant). -/
theorem isDominant_residualImagePartialMap_hom_iff
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0) :
    IsDominant (residualImagePartialMap F hF v hv i j hdenom).hom ↔
      IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j) := by
  set e :=
    basicOpenIsoSpecAway
      (R := CommRingCat.of (affineTwoRing k))
      (residualChartDenom F v i j)
  haveI : IsDominant e.hom := inferInstance
  change IsDominant (e.hom ≫ residualImagePointOfNormalizedLoc F hF v hv i j) ↔ _
  exact IsDominant.comp_iff e.hom (residualImagePointOfNormalizedLoc F hF v hv i j)

/-- Affine residual rational map is dominant once the Spec-plane residual rational map is
(SpecIso is an isomorphism). -/
theorem isDominant_residualImageRationalMapAffine_of_isDominant_residualImageRationalMap
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0)
    [hdom : (residualImageRationalMap F hF v hv i j hdenom).IsDominant] :
    (residualImageRationalMapAffine F hF v hv i j hdenom).IsDominant := by
  dsimp only [residualImageRationalMapAffine]
  infer_instance

/-- Package: localized residual point dominant ⇒ residual affine rational map dominant. -/
theorem isDominant_residualImageRationalMapAffine_of_isDominant_point
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (i j : Fin 3)
    (hdenom : residualChartDenom F v i j ≠ 0)
    [IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j)] :
    (residualImageRationalMapAffine F hF v hv i j hdenom).IsDominant := by
  haveI : IsDominant (residualImagePartialMap F hF v hv i j hdenom).hom :=
    (isDominant_residualImagePartialMap_hom_iff F hF v hv i j hdenom).mpr inferInstance
  haveI : (residualImageRationalMap F hF v hv i j hdenom).IsDominant :=
    (isDominant_residualImageRationalMap_iff F hF v hv i j hdenom).mpr inferInstance
  exact isDominant_residualImageRationalMapAffine_of_isDominant_residualImageRationalMap
    F hF v hv i j hdenom

/-- Assembly skeleton: residual X,Y nonzero + localized residual point dominant
⇒ residual-image unirationality.

IsOver is unconditional.  On a smooth equation, `residualImageXCoords_ne_zero_of_smooth`
supplies X ≠ 0; remaining geometric inputs are `residualYCoords_ne_zero_of_smooth` and
dominance of `residualImagePointOfNormalizedLoc`. -/
theorem hasResidualImageUnirationalParametrization2_of_ne_zero_coords_and_dominant_point
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (hX : residualImageXCoords F v ≠ 0)
    (hY : residualYCoords F v ≠ 0)
    (hdom :
      ∀ (i j : Fin 3) (hdenom : residualChartDenom F v i j ≠ 0),
        IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j)) :
    HasResidualImageUnirationalParametrization2 F := by
  refine exists_hasResidualImageUnirationalParametrization2_of_ne_zero_coords
    F hF v hv hX hY ?_
  intro i j hdenom
  haveI : IsDominant (residualImagePointOfNormalizedLoc F hF v hv i j) := hdom i j hdenom
  exact isDominant_residualImageRationalMapAffine_of_isDominant_point F hF v hv i j hdenom


end

end BConicBundleMultisections
