/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveNoWholeFiber
public import BConicBundleMultisections.HomogeneousQuadraticEval
public import BConicBundleMultisections.PointedConicRational
public import BConicBundleMultisections.ResidualBaseChangeUnirational
public import BConicBundleMultisections.ResidualMultisectionDominant
public import Mathlib.Algebra.BigOperators.Fin
public import Mathlib.LinearAlgebra.QuadraticForm.Basic
public import Mathlib.RingTheory.MvPolynomial.Homogeneous
public import Mathlib.Tactic.Ring

/-!
# Vertical surface stereography over the coordinate line

Over the coordinate line `Y₂ = 0` (parameter `t`), the specialized conic
`coordinateLineSpecializedConic F t` is a plane conic in the first Cox block.  Given a Tsen
isotropic section `v(t)` and a free stereographic direction `w(s) = ![1,s,0]`, the classical
second-intersection formula produces an isotropic vector of the specialized conic at each
`(t,s)`.

This is the algebraic content of the dominant rational map `𝔸² ⤏ S_L`.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial
open _root_.MvPolynomial
open QuadraticMap
open AlgebraicGeometry
open BiprojectiveSpace

universe u

variable {K : Type u} [Field K]

/-! ### Quadratic form of a homogeneous ternary polynomial -/

theorem eval_smul_of_isHomogeneous_two
    {f : MvPolynomial (Fin 3) K} (hf : f.IsHomogeneous 2)
    (c : K) (x : Fin 3 → K) :
    eval (c • x) f = (c * c) * eval x f := by
  rw [eval_eq_ternaryQuadraticCoeff_sum hf, eval_eq_ternaryQuadraticCoeff_sum hf]
  simp only [Pi.smul_apply, smul_eq_mul]
  calc
    (∑ i : Fin 3, ∑ j : Fin 3, ternaryQuadraticCoeff f i j * (c * x i) * (c * x j)) =
        ∑ i : Fin 3, ∑ j : Fin 3, (c * c) * (ternaryQuadraticCoeff f i j * x i * x j) := by
      refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
      ring
    _ = (c * c) * ∑ i : Fin 3, ∑ j : Fin 3, ternaryQuadraticCoeff f i j * x i * x j := by
      rw [Finset.mul_sum]
      refine Finset.sum_congr rfl fun i _ => ?_
      rw [Finset.mul_sum]

theorem polar_add_left_eval
    {f : MvPolynomial (Fin 3) K} (hf : f.IsHomogeneous 2)
    (x x' y : Fin 3 → K) :
    polar (fun z : Fin 3 → K => eval z f) (x + x') y =
      polar (fun z => eval z f) x y + polar (fun z => eval z f) x' y := by
  simp only [polar]
  have hx := eval_eq_ternaryQuadraticCoeff_sum hf x
  have hx' := eval_eq_ternaryQuadraticCoeff_sum hf x'
  have hy := eval_eq_ternaryQuadraticCoeff_sum hf y
  have hxy := eval_eq_ternaryQuadraticCoeff_sum hf (x + y)
  have hx'y := eval_eq_ternaryQuadraticCoeff_sum hf (x' + y)
  have hxx' := eval_eq_ternaryQuadraticCoeff_sum hf (x + x')
  have hxx'y := eval_eq_ternaryQuadraticCoeff_sum hf (x + x' + y)
  simp only [hx, hx', hy, hxy, hx'y, hxx', hxx'y, Pi.add_apply, Fin.sum_univ_three]
  ring

theorem polar_smul_left_eval
    {f : MvPolynomial (Fin 3) K} (hf : f.IsHomogeneous 2)
    (a : K) (x y : Fin 3 → K) :
    polar (fun z : Fin 3 → K => eval z f) (a • x) y =
      a * polar (fun z => eval z f) x y := by
  simp only [polar]
  have hx := eval_eq_ternaryQuadraticCoeff_sum hf x
  have hy := eval_eq_ternaryQuadraticCoeff_sum hf y
  have hax := eval_eq_ternaryQuadraticCoeff_sum hf (a • x)
  have haxy := eval_eq_ternaryQuadraticCoeff_sum hf (a • x + y)
  have hxy := eval_eq_ternaryQuadraticCoeff_sum hf (x + y)
  simp only [hx, hy, hax, haxy, hxy, Pi.add_apply, Pi.smul_apply, smul_eq_mul, Fin.sum_univ_three]
  ring

/-- Quadratic form attached to a homogeneous degree-2 ternary polynomial. -/
def ternaryQuadraticForm
    (f : MvPolynomial (Fin 3) K) (hf : f.IsHomogeneous 2) :
    QuadraticForm K (Fin 3 → K) :=
  QuadraticMap.ofPolar
    (fun x => eval x f)
    (fun c x => by
      simpa [smul_eq_mul] using eval_smul_of_isHomogeneous_two hf c x)
    (fun x x' y => polar_add_left_eval hf x x' y)
    (fun a x y => by
      simpa [smul_eq_mul] using polar_smul_left_eval hf a x y)

@[simp]
theorem ternaryQuadraticForm_apply
    (f : MvPolynomial (Fin 3) K) (hf : f.IsHomogeneous 2) (x : Fin 3 → K) :
    ternaryQuadraticForm f hf x = eval x f :=
  rfl

/-- Stereographic second-intersection via the ternary quadratic form. -/
def stereoSecondIntersection
    (f : MvPolynomial (Fin 3) K) (hf : f.IsHomogeneous 2)
    (p w : Fin 3 → K) : Fin 3 → K :=
  conicParametrization (ternaryQuadraticForm f hf) p w

theorem stereoSecondIntersection_isotropic
    (f : MvPolynomial (Fin 3) K) (hf : f.IsHomogeneous 2)
    {p w : Fin 3 → K} (hp : eval p f = 0) :
    eval (stereoSecondIntersection f hf p w) f = 0 := by
  have hpQ : ternaryQuadraticForm f hf p = 0 := by simpa using hp
  simpa [stereoSecondIntersection] using
    conicParametrization_is_isotropic (ternaryQuadraticForm f hf) hpQ (w := w)

/-! ### Coordinate-line stereo family -/

/-- Stereographic parametrization of the specialized conic at `t` along a Tsen section. -/
def coordinateLineStereoParam
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K) (t s : K) : Fin 3 → K :=
  stereoSecondIntersection (coordinateLineSpecializedConic F t)
    (coordinateLineSpecializedConic_isHomogeneous hF t)
    (evalPolySection v t) (stereographicDirection s)

theorem coordinateLineStereoParam_isotropic
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial K)
    (hv : TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0)
    (t s : K) :
    eval (coordinateLineStereoParam F hF v t s) (coordinateLineSpecializedConic F t) = 0 := by
  refine stereoSecondIntersection_isotropic _ _ ?_
  exact evalPolySection_isotropic_coordinateLineSpecializedConic F hF v hv t

/-- Tsen + stereo: isotropic points of the specialized conic parametrized by `𝔸²`. -/
theorem exists_stereo_parametrization_isotropic
    [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) :
    ∃ v : Fin 3 → Polynomial K, v ≠ 0 ∧
      TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0 ∧
        ∀ t s : K,
          eval (coordinateLineStereoParam F hF v t s)
            (coordinateLineSpecializedConic F t) = 0 := by
  obtain ⟨v, hv0, hv⟩ := exists_isotropic_coordinateLine_conic K F
  exact ⟨v, hv0, hv, fun t s => coordinateLineStereoParam_isotropic F hF v hv t s⟩

/-- Package: stereo family + nonvanishing specialized conics + residual base-change dominance. -/
theorem vertical_surface_stereo_package
    [IsAlgClosed K]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 K F)] :
    (∃ v : Fin 3 → Polynomial K, v ≠ 0 ∧
      TernaryQuadraticPoly.eval (coordinateLineTernaryQuadraticPoly F) v = 0 ∧
        ∀ t s : K,
          eval (coordinateLineStereoParam F hF v t s)
            (coordinateLineSpecializedConic F t) = 0) ∧
      (∀ t : K, coordinateLineSpecializedConic F t ≠ 0) ∧
        IsDominant (residualMultisection F).baseChangeFst := by
  refine ⟨?_, ?_, ?_⟩
  · exact exists_stereo_parametrization_isotropic F hF
  · intro t
    exact coordinateLineSpecializedConic_ne_zero_of_smooth K F hF hF0 t
  · exact isDominant_residualMultisection_baseChangeFst_of_smooth_bidegree23 K F hF hF0

/-- Residual base-change dim-3 unirationality from residual-image unirationality and pointed-conic
rationality, via an explicit product bridge supplied by the caller. -/
theorem hasResidualBaseChangeUnirationalParametrization3_of_image_and_pointed
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) K)
    (hT : HasResidualImageUnirationalParametrization2 F)
    (hP : IsResidualPointedConicRational F)
    (hprod :
      HasResidualImageUnirationalParametrization2 F →
        IsResidualPointedConicRational F →
          HasResidualBaseChangeUnirationalParametrization3 F) :
    HasResidualBaseChangeUnirationalParametrization3 F :=
  hprod hT hP

end

end BConicBundleMultisections
