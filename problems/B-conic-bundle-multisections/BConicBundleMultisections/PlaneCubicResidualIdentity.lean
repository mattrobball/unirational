/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.UniversalResidualIdentity
public import Mathlib.Algebra.BigOperators.Fin
public import Mathlib.Data.Finsupp.Basic
public import Mathlib.Data.Finsupp.Weight
public import Mathlib.RingTheory.MvPolynomial.Homogeneous
public import Mathlib.Tactic.FinCases
public import Mathlib.Tactic.Ring

/-!
# Residual linear form of a plane cubic on the coordinate line `W = 0`

Specializes the universal residual identity to an arbitrary homogeneous plane cubic of degree
three, expressed in the monomial basis of `MvPolynomial (Fin 3) R`.
-/

@[expose] public section

open MvPolynomial
open Finsupp

namespace BConicBundleMultisections
namespace PlaneCubicResidual

noncomputable section

variable {R : Type*} [CommRing R]

/-! ### Standard multi-indices of total degree 3 on `Fin 3` -/

/-- Multi-index `X₀³`. -/
def eU3 : Fin 3 →₀ ℕ := single 0 3
/-- Multi-index `X₀² X₁`. -/
def eU2V : Fin 3 →₀ ℕ := single 0 2 + single 1 1
/-- Multi-index `X₀ X₁²`. -/
def eUV2 : Fin 3 →₀ ℕ := single 0 1 + single 1 2
/-- Multi-index `X₁³`. -/
def eV3 : Fin 3 →₀ ℕ := single 1 3
/-- Multi-index `X₀² X₂`. -/
def eU2W : Fin 3 →₀ ℕ := single 0 2 + single 2 1
/-- Multi-index `X₀ X₁ X₂`. -/
def eUVW : Fin 3 →₀ ℕ := single 0 1 + single 1 1 + single 2 1
/-- Multi-index `X₁² X₂`. -/
def eV2W : Fin 3 →₀ ℕ := single 1 2 + single 2 1
/-- Multi-index `X₀ X₂²`. -/
def eUW2 : Fin 3 →₀ ℕ := single 0 1 + single 2 2
/-- Multi-index `X₁ X₂²`. -/
def eVW2 : Fin 3 →₀ ℕ := single 1 1 + single 2 2
/-- Multi-index `X₂³`. -/
def eW3 : Fin 3 →₀ ℕ := single 2 3

@[simp] theorem eU3_degree : eU3.degree = 3 := by
  simp [eU3, degree_eq_sum, Fin.sum_univ_three, single_apply]
@[simp] theorem eU2V_degree : eU2V.degree = 3 := by
  simp [eU2V, degree_eq_sum, Fin.sum_univ_three, single_apply, Finsupp.add_apply]
@[simp] theorem eUV2_degree : eUV2.degree = 3 := by
  simp [eUV2, degree_eq_sum, Fin.sum_univ_three, single_apply, Finsupp.add_apply]
@[simp] theorem eV3_degree : eV3.degree = 3 := by
  simp [eV3, degree_eq_sum, Fin.sum_univ_three, single_apply]
@[simp] theorem eU2W_degree : eU2W.degree = 3 := by
  simp [eU2W, degree_eq_sum, Fin.sum_univ_three, single_apply, Finsupp.add_apply]
@[simp] theorem eUVW_degree : eUVW.degree = 3 := by
  simp [eUVW, degree_eq_sum, Fin.sum_univ_three, single_apply, Finsupp.add_apply]
@[simp] theorem eV2W_degree : eV2W.degree = 3 := by
  simp [eV2W, degree_eq_sum, Fin.sum_univ_three, single_apply, Finsupp.add_apply]
@[simp] theorem eUW2_degree : eUW2.degree = 3 := by
  simp [eUW2, degree_eq_sum, Fin.sum_univ_three, single_apply, Finsupp.add_apply]
@[simp] theorem eVW2_degree : eVW2.degree = 3 := by
  simp [eVW2, degree_eq_sum, Fin.sum_univ_three, single_apply, Finsupp.add_apply]
@[simp] theorem eW3_degree : eW3.degree = 3 := by
  simp [eW3, degree_eq_sum, Fin.sum_univ_three, single_apply]

private theorem ne_of_apply_ne (s t : Fin 3 →₀ ℕ) (i : Fin 3) (h : s i ≠ t i) : s ≠ t :=
  fun heq => h (congrArg (fun u : Fin 3 →₀ ℕ => u i) heq)

/-! Pairwise distinctness of the ten multi-indices (needed for `coeff_monomial` ifs). -/

private theorem eU3_ne_eU2V : eU3 ≠ eU2V :=
  ne_of_apply_ne _ _ 0 (by simp [eU3, eU2V, single_apply, Finsupp.add_apply])
private theorem eU3_ne_eUV2 : eU3 ≠ eUV2 :=
  ne_of_apply_ne _ _ 0 (by simp [eU3, eUV2, single_apply, Finsupp.add_apply])
private theorem eU3_ne_eV3 : eU3 ≠ eV3 :=
  ne_of_apply_ne _ _ 0 (by simp [eU3, eV3, single_apply])
private theorem eU3_ne_eU2W : eU3 ≠ eU2W :=
  ne_of_apply_ne _ _ 0 (by simp [eU3, eU2W, single_apply, Finsupp.add_apply])
private theorem eU3_ne_eUVW : eU3 ≠ eUVW :=
  ne_of_apply_ne _ _ 0 (by simp [eU3, eUVW, single_apply, Finsupp.add_apply])
private theorem eU3_ne_eV2W : eU3 ≠ eV2W :=
  ne_of_apply_ne _ _ 0 (by simp [eU3, eV2W, single_apply, Finsupp.add_apply])
private theorem eU3_ne_eUW2 : eU3 ≠ eUW2 :=
  ne_of_apply_ne _ _ 0 (by simp [eU3, eUW2, single_apply, Finsupp.add_apply])
private theorem eU3_ne_eVW2 : eU3 ≠ eVW2 :=
  ne_of_apply_ne _ _ 0 (by simp [eU3, eVW2, single_apply, Finsupp.add_apply])
private theorem eU3_ne_eW3 : eU3 ≠ eW3 :=
  ne_of_apply_ne _ _ 0 (by simp [eU3, eW3, single_apply])

private theorem eU2V_ne_eUV2 : eU2V ≠ eUV2 :=
  ne_of_apply_ne _ _ 0 (by simp [eU2V, eUV2, single_apply, Finsupp.add_apply])
private theorem eU2V_ne_eV3 : eU2V ≠ eV3 :=
  ne_of_apply_ne _ _ 0 (by simp [eU2V, eV3, single_apply, Finsupp.add_apply])
private theorem eU2V_ne_eU2W : eU2V ≠ eU2W :=
  ne_of_apply_ne _ _ 1 (by simp [eU2V, eU2W, single_apply, Finsupp.add_apply])
private theorem eU2V_ne_eUVW : eU2V ≠ eUVW :=
  ne_of_apply_ne _ _ 0 (by simp [eU2V, eUVW, single_apply, Finsupp.add_apply])
private theorem eU2V_ne_eV2W : eU2V ≠ eV2W :=
  ne_of_apply_ne _ _ 0 (by simp [eU2V, eV2W, single_apply, Finsupp.add_apply])
private theorem eU2V_ne_eUW2 : eU2V ≠ eUW2 :=
  ne_of_apply_ne _ _ 0 (by simp [eU2V, eUW2, single_apply, Finsupp.add_apply])
private theorem eU2V_ne_eVW2 : eU2V ≠ eVW2 :=
  ne_of_apply_ne _ _ 0 (by simp [eU2V, eVW2, single_apply, Finsupp.add_apply])
private theorem eU2V_ne_eW3 : eU2V ≠ eW3 :=
  ne_of_apply_ne _ _ 0 (by simp [eU2V, eW3, single_apply, Finsupp.add_apply])

private theorem eUV2_ne_eV3 : eUV2 ≠ eV3 :=
  ne_of_apply_ne _ _ 0 (by simp [eUV2, eV3, single_apply, Finsupp.add_apply])
private theorem eUV2_ne_eU2W : eUV2 ≠ eU2W :=
  ne_of_apply_ne _ _ 1 (by simp [eUV2, eU2W, single_apply, Finsupp.add_apply])
private theorem eUV2_ne_eUVW : eUV2 ≠ eUVW :=
  ne_of_apply_ne _ _ 1 (by simp [eUV2, eUVW, single_apply, Finsupp.add_apply])
private theorem eUV2_ne_eV2W : eUV2 ≠ eV2W :=
  ne_of_apply_ne _ _ 0 (by simp [eUV2, eV2W, single_apply, Finsupp.add_apply])
private theorem eUV2_ne_eUW2 : eUV2 ≠ eUW2 :=
  ne_of_apply_ne _ _ 1 (by simp [eUV2, eUW2, single_apply, Finsupp.add_apply])
private theorem eUV2_ne_eVW2 : eUV2 ≠ eVW2 :=
  ne_of_apply_ne _ _ 0 (by simp [eUV2, eVW2, single_apply, Finsupp.add_apply])
private theorem eUV2_ne_eW3 : eUV2 ≠ eW3 :=
  ne_of_apply_ne _ _ 0 (by simp [eUV2, eW3, single_apply, Finsupp.add_apply])

private theorem eV3_ne_eU2W : eV3 ≠ eU2W :=
  ne_of_apply_ne _ _ 1 (by simp [eV3, eU2W, single_apply, Finsupp.add_apply])
private theorem eV3_ne_eUVW : eV3 ≠ eUVW :=
  ne_of_apply_ne _ _ 1 (by simp [eV3, eUVW, single_apply, Finsupp.add_apply])
private theorem eV3_ne_eV2W : eV3 ≠ eV2W :=
  ne_of_apply_ne _ _ 1 (by simp [eV3, eV2W, single_apply, Finsupp.add_apply])
private theorem eV3_ne_eUW2 : eV3 ≠ eUW2 :=
  ne_of_apply_ne _ _ 1 (by simp [eV3, eUW2, single_apply, Finsupp.add_apply])
private theorem eV3_ne_eVW2 : eV3 ≠ eVW2 :=
  ne_of_apply_ne _ _ 1 (by simp [eV3, eVW2, single_apply, Finsupp.add_apply])
private theorem eV3_ne_eW3 : eV3 ≠ eW3 :=
  ne_of_apply_ne _ _ 1 (by simp [eV3, eW3, single_apply])

private theorem eU2W_ne_eUVW : eU2W ≠ eUVW :=
  ne_of_apply_ne _ _ 0 (by simp [eU2W, eUVW, single_apply, Finsupp.add_apply])
private theorem eU2W_ne_eV2W : eU2W ≠ eV2W :=
  ne_of_apply_ne _ _ 0 (by simp [eU2W, eV2W, single_apply, Finsupp.add_apply])
private theorem eU2W_ne_eUW2 : eU2W ≠ eUW2 :=
  ne_of_apply_ne _ _ 0 (by simp [eU2W, eUW2, single_apply, Finsupp.add_apply])
private theorem eU2W_ne_eVW2 : eU2W ≠ eVW2 :=
  ne_of_apply_ne _ _ 0 (by simp [eU2W, eVW2, single_apply, Finsupp.add_apply])
private theorem eU2W_ne_eW3 : eU2W ≠ eW3 :=
  ne_of_apply_ne _ _ 0 (by simp [eU2W, eW3, single_apply, Finsupp.add_apply])

private theorem eUVW_ne_eV2W : eUVW ≠ eV2W :=
  ne_of_apply_ne _ _ 0 (by simp [eUVW, eV2W, single_apply, Finsupp.add_apply])
private theorem eUVW_ne_eUW2 : eUVW ≠ eUW2 :=
  ne_of_apply_ne _ _ 1 (by simp [eUVW, eUW2, single_apply, Finsupp.add_apply])
private theorem eUVW_ne_eVW2 : eUVW ≠ eVW2 :=
  ne_of_apply_ne _ _ 0 (by simp [eUVW, eVW2, single_apply, Finsupp.add_apply])
private theorem eUVW_ne_eW3 : eUVW ≠ eW3 :=
  ne_of_apply_ne _ _ 0 (by simp [eUVW, eW3, single_apply, Finsupp.add_apply])

private theorem eV2W_ne_eUW2 : eV2W ≠ eUW2 :=
  ne_of_apply_ne _ _ 0 (by simp [eV2W, eUW2, single_apply, Finsupp.add_apply])
private theorem eV2W_ne_eVW2 : eV2W ≠ eVW2 :=
  ne_of_apply_ne _ _ 1 (by simp [eV2W, eVW2, single_apply, Finsupp.add_apply])
private theorem eV2W_ne_eW3 : eV2W ≠ eW3 :=
  ne_of_apply_ne _ _ 1 (by simp [eV2W, eW3, single_apply, Finsupp.add_apply])

private theorem eUW2_ne_eVW2 : eUW2 ≠ eVW2 :=
  ne_of_apply_ne _ _ 0 (by simp [eUW2, eVW2, single_apply, Finsupp.add_apply])
private theorem eUW2_ne_eW3 : eUW2 ≠ eW3 :=
  ne_of_apply_ne _ _ 0 (by simp [eUW2, eW3, single_apply, Finsupp.add_apply])

private theorem eVW2_ne_eW3 : eVW2 ≠ eW3 :=
  ne_of_apply_ne _ _ 1 (by simp [eVW2, eW3, single_apply, Finsupp.add_apply])

/-- Bundle of pairwise inequalities used when extracting coefficients of the ten-monomial sum. -/
private theorem planeCubic_index_ne_simp :
    eU3 ≠ eU2V ∧ eU3 ≠ eUV2 ∧ eU3 ≠ eV3 ∧ eU3 ≠ eU2W ∧ eU3 ≠ eUVW ∧
    eU3 ≠ eV2W ∧ eU3 ≠ eUW2 ∧ eU3 ≠ eVW2 ∧ eU3 ≠ eW3 ∧
    eU2V ≠ eUV2 ∧ eU2V ≠ eV3 ∧ eU2V ≠ eU2W ∧ eU2V ≠ eUVW ∧
    eU2V ≠ eV2W ∧ eU2V ≠ eUW2 ∧ eU2V ≠ eVW2 ∧ eU2V ≠ eW3 ∧
    eUV2 ≠ eV3 ∧ eUV2 ≠ eU2W ∧ eUV2 ≠ eUVW ∧ eUV2 ≠ eV2W ∧
    eUV2 ≠ eUW2 ∧ eUV2 ≠ eVW2 ∧ eUV2 ≠ eW3 ∧
    eV3 ≠ eU2W ∧ eV3 ≠ eUVW ∧ eV3 ≠ eV2W ∧ eV3 ≠ eUW2 ∧ eV3 ≠ eVW2 ∧ eV3 ≠ eW3 ∧
    eU2W ≠ eUVW ∧ eU2W ≠ eV2W ∧ eU2W ≠ eUW2 ∧ eU2W ≠ eVW2 ∧ eU2W ≠ eW3 ∧
    eUVW ≠ eV2W ∧ eUVW ≠ eUW2 ∧ eUVW ≠ eVW2 ∧ eUVW ≠ eW3 ∧
    eV2W ≠ eUW2 ∧ eV2W ≠ eVW2 ∧ eV2W ≠ eW3 ∧
    eUW2 ≠ eVW2 ∧ eUW2 ≠ eW3 ∧
    eVW2 ≠ eW3 :=
  ⟨eU3_ne_eU2V, eU3_ne_eUV2, eU3_ne_eV3, eU3_ne_eU2W, eU3_ne_eUVW,
    eU3_ne_eV2W, eU3_ne_eUW2, eU3_ne_eVW2, eU3_ne_eW3,
    eU2V_ne_eUV2, eU2V_ne_eV3, eU2V_ne_eU2W, eU2V_ne_eUVW,
    eU2V_ne_eV2W, eU2V_ne_eUW2, eU2V_ne_eVW2, eU2V_ne_eW3,
    eUV2_ne_eV3, eUV2_ne_eU2W, eUV2_ne_eUVW, eUV2_ne_eV2W,
    eUV2_ne_eUW2, eUV2_ne_eVW2, eUV2_ne_eW3,
    eV3_ne_eU2W, eV3_ne_eUVW, eV3_ne_eV2W, eV3_ne_eUW2, eV3_ne_eVW2, eV3_ne_eW3,
    eU2W_ne_eUVW, eU2W_ne_eV2W, eU2W_ne_eUW2, eU2W_ne_eVW2, eU2W_ne_eW3,
    eUVW_ne_eV2W, eUVW_ne_eUW2, eUVW_ne_eVW2, eUVW_ne_eW3,
    eV2W_ne_eUW2, eV2W_ne_eVW2, eV2W_ne_eW3,
    eUW2_ne_eVW2, eUW2_ne_eW3,
    eVW2_ne_eW3⟩

/-- Coefficient of `X₀³` in a plane cubic. -/
def coeffU3 (f : MvPolynomial (Fin 3) R) : R := coeff eU3 f
/-- Coefficient of `X₀² X₁`. -/
def coeffU2V (f : MvPolynomial (Fin 3) R) : R := coeff eU2V f
/-- Coefficient of `X₀ X₁²`. -/
def coeffUV2 (f : MvPolynomial (Fin 3) R) : R := coeff eUV2 f
/-- Coefficient of `X₁³`. -/
def coeffV3 (f : MvPolynomial (Fin 3) R) : R := coeff eV3 f
/-- Coefficient of `X₀² X₂`. -/
def coeffU2W (f : MvPolynomial (Fin 3) R) : R := coeff eU2W f
/-- Coefficient of `X₀ X₁ X₂`. -/
def coeffUVW (f : MvPolynomial (Fin 3) R) : R := coeff eUVW f
/-- Coefficient of `X₁² X₂`. -/
def coeffV2W (f : MvPolynomial (Fin 3) R) : R := coeff eV2W f
/-- Coefficient of `X₀ X₂²`. -/
def coeffUW2 (f : MvPolynomial (Fin 3) R) : R := coeff eUW2 f
/-- Coefficient of `X₁ X₂²`. -/
def coeffVW2 (f : MvPolynomial (Fin 3) R) : R := coeff eVW2 f
/-- Coefficient of `X₂³`. -/
def coeffW3 (f : MvPolynomial (Fin 3) R) : R := coeff eW3 f

/-- Residual linear form of a plane cubic on the coordinate line `X₂ = 0`. -/
def residualLinearForm (f : MvPolynomial (Fin 3) R) : MvPolynomial (Fin 3) R :=
  C (UniversalResidual.residualCoeffU
      (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
      (coeffU2W f) (coeffUVW f) (coeffV2W f) (coeffUW2 f)) * X 0 +
  C (UniversalResidual.residualCoeffV
      (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
      (coeffU2W f) (coeffUVW f) (coeffV2W f) (coeffVW2 f)) * X 1 +
  C (UniversalResidual.residualCoeffW
      (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
      (coeffU2W f) (coeffUVW f) (coeffV2W f) (coeffW3 f)) * X 2

/-- Evaluation of the residual linear form. -/
theorem eval_residualLinearForm (f : MvPolynomial (Fin 3) R) (p : Fin 3 → R) :
    eval p (residualLinearForm f) =
      UniversalResidual.residualLinear
        (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
        (coeffU2W f) (coeffUVW f) (coeffV2W f)
        (coeffUW2 f) (coeffVW2 f) (coeffW3 f)
        (p 0) (p 1) (p 2) := by
  simp [residualLinearForm, UniversalResidual.residualLinear]

/-- The residual linear form is homogeneous of degree one. -/
theorem residualLinearForm_isHomogeneous (f : MvPolynomial (Fin 3) R) :
    (residualLinearForm f).IsHomogeneous 1 := by
  simp only [residualLinearForm]
  exact
    ((isHomogeneous_C_mul_X
        (UniversalResidual.residualCoeffU
          (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
          (coeffU2W f) (coeffUVW f) (coeffV2W f) (coeffUW2 f))
        (0 : Fin 3)).add
      (isHomogeneous_C_mul_X
        (UniversalResidual.residualCoeffV
          (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
          (coeffU2W f) (coeffUVW f) (coeffV2W f) (coeffVW2 f))
        (1 : Fin 3))).add
      (isHomogeneous_C_mul_X
        (UniversalResidual.residualCoeffW
          (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
          (coeffU2W f) (coeffUVW f) (coeffV2W f) (coeffW3 f))
        (2 : Fin 3))

/-- The ten-monomial sum is homogeneous of degree 3. -/
private theorem planeCubicSum_isHomogeneous (f : MvPolynomial (Fin 3) R) :
    (monomial eU3 (coeffU3 f) + monomial eU2V (coeffU2V f) + monomial eUV2 (coeffUV2 f) +
      monomial eV3 (coeffV3 f) + monomial eU2W (coeffU2W f) + monomial eUVW (coeffUVW f) +
      monomial eV2W (coeffV2W f) + monomial eUW2 (coeffUW2 f) + monomial eVW2 (coeffVW2 f) +
      monomial eW3 (coeffW3 f)).IsHomogeneous 3 := by
  refine (((((((((isHomogeneous_monomial _ eU3_degree).add
    (isHomogeneous_monomial _ eU2V_degree)).add
    (isHomogeneous_monomial _ eUV2_degree)).add
    (isHomogeneous_monomial _ eV3_degree)).add
    (isHomogeneous_monomial _ eU2W_degree)).add
    (isHomogeneous_monomial _ eUVW_degree)).add
    (isHomogeneous_monomial _ eV2W_degree)).add
    (isHomogeneous_monomial _ eUW2_degree)).add
    (isHomogeneous_monomial _ eVW2_degree)).add
    (isHomogeneous_monomial _ eW3_degree)

/-- After expanding `coeff` of the ten-monomial sum at a concrete multi-index equal to one of
the ten standard indices, the matching coefficient is recovered. -/
private theorem coeff_planeCubicSum_at
    (f : MvPolynomial (Fin 3) R) (d : Fin 3 →₀ ℕ)
    (h : d = eU3 ∨ d = eU2V ∨ d = eUV2 ∨ d = eV3 ∨ d = eU2W ∨
      d = eUVW ∨ d = eV2W ∨ d = eUW2 ∨ d = eVW2 ∨ d = eW3) :
    coeff d
      (monomial eU3 (coeffU3 f) + monomial eU2V (coeffU2V f) + monomial eUV2 (coeffUV2 f) +
        monomial eV3 (coeffV3 f) + monomial eU2W (coeffU2W f) + monomial eUVW (coeffUVW f) +
        monomial eV2W (coeffV2W f) + monomial eUW2 (coeffUW2 f) + monomial eVW2 (coeffVW2 f) +
        monomial eW3 (coeffW3 f)) =
      coeff d f := by
  obtain ⟨n01, n02, n03, n04, n05, n06, n07, n08, n09,
    n12, n13, n14, n15, n16, n17, n18, n19,
    n23, n24, n25, n26, n27, n28, n29,
    n34, n35, n36, n37, n38, n39,
    n45, n46, n47, n48, n49,
    n56, n57, n58, n59,
    n67, n68, n69,
    n78, n79,
    n89⟩ := planeCubic_index_ne_simp
  rcases h with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  all_goals
    simp only [coeff_add, coeff_monomial, coeffU3, coeffU2V, coeffUV2, coeffV3, coeffU2W,
      coeffUVW, coeffV2W, coeffUW2, coeffVW2, coeffW3]
    simp only [n01, n02, n03, n04, n05, n06, n07, n08, n09,
      n12, n13, n14, n15, n16, n17, n18, n19,
      n23, n24, n25, n26, n27, n28, n29,
      n34, n35, n36, n37, n38, n39,
      n45, n46, n47, n48, n49,
      n56, n57, n58, n59,
      n67, n68, n69,
      n78, n79,
      n89, Ne.symm n01, Ne.symm n02, Ne.symm n03, Ne.symm n04, Ne.symm n05,
      Ne.symm n06, Ne.symm n07, Ne.symm n08, Ne.symm n09,
      Ne.symm n12, Ne.symm n13, Ne.symm n14, Ne.symm n15, Ne.symm n16, Ne.symm n17,
      Ne.symm n18, Ne.symm n19,
      Ne.symm n23, Ne.symm n24, Ne.symm n25, Ne.symm n26, Ne.symm n27, Ne.symm n28,
      Ne.symm n29,
      Ne.symm n34, Ne.symm n35, Ne.symm n36, Ne.symm n37, Ne.symm n38, Ne.symm n39,
      Ne.symm n45, Ne.symm n46, Ne.symm n47, Ne.symm n48, Ne.symm n49,
      Ne.symm n56, Ne.symm n57, Ne.symm n58, Ne.symm n59,
      Ne.symm n67, Ne.symm n68, Ne.symm n69,
      Ne.symm n78, Ne.symm n79,
      Ne.symm n89]
    simp only [↓reduceIte, add_zero, zero_add]

/-- A homogeneous plane cubic equals the sum of its ten standard monomials. -/
theorem planeCubic_eq_sum_monomials
    (f : MvPolynomial (Fin 3) R) (hf : f.IsHomogeneous 3) :
    f =
      monomial eU3 (coeffU3 f) + monomial eU2V (coeffU2V f) + monomial eUV2 (coeffUV2 f) +
        monomial eV3 (coeffV3 f) + monomial eU2W (coeffU2W f) + monomial eUVW (coeffUVW f) +
        monomial eV2W (coeffV2W f) + monomial eUW2 (coeffUW2 f) + monomial eVW2 (coeffVW2 f) +
        monomial eW3 (coeffW3 f) := by
  classical
  ext d
  by_cases hd : d.degree = 3
  · have hsum : d 0 + d 1 + d 2 = 3 := by
      simpa [degree_eq_sum, Fin.sum_univ_three] using hd
    have h0c : d 0 = 0 ∨ d 0 = 1 ∨ d 0 = 2 ∨ d 0 = 3 := by omega
    have hmem :
        d = eU3 ∨ d = eU2V ∨ d = eUV2 ∨ d = eV3 ∨ d = eU2W ∨
          d = eUVW ∨ d = eV2W ∨ d = eUW2 ∨ d = eVW2 ∨ d = eW3 := by
      rcases h0c with h0 | h0 | h0 | h0
      · have h1c : d 1 = 0 ∨ d 1 = 1 ∨ d 1 = 2 ∨ d 1 = 3 := by omega
        rcases h1c with h1 | h1 | h1 | h1
        · refine Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ?_))))))))
          ext i; fin_cases i <;> simp [eW3, h0, h1, single_apply]
          omega
        · refine Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl ?_))))))))
          ext i; fin_cases i <;> simp [eVW2, h0, h1, single_apply, Finsupp.add_apply]
          omega
        · refine Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl ?_))))))
          ext i; fin_cases i <;> simp [eV2W, h0, h1, single_apply, Finsupp.add_apply]
          omega
        · refine Or.inr (Or.inr (Or.inr (Or.inl ?_)))
          ext i; fin_cases i <;> simp [eV3, h0, h1, single_apply]
          omega
      · have h1c : d 1 = 0 ∨ d 1 = 1 ∨ d 1 = 2 := by omega
        rcases h1c with h1 | h1 | h1
        · refine Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl ?_)))))))
          ext i; fin_cases i <;> simp [eUW2, h0, h1, single_apply, Finsupp.add_apply]
          omega
        · refine Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl ?_)))))
          ext i; fin_cases i <;> simp [eUVW, h0, h1, single_apply, Finsupp.add_apply]
          omega
        · refine Or.inr (Or.inr (Or.inl ?_))
          ext i; fin_cases i <;> simp [eUV2, h0, h1, single_apply, Finsupp.add_apply]
          omega
      · have h1c : d 1 = 0 ∨ d 1 = 1 := by omega
        rcases h1c with h1 | h1
        · refine Or.inr (Or.inr (Or.inr (Or.inr (Or.inl ?_))))
          ext i; fin_cases i <;> simp [eU2W, h0, h1, single_apply, Finsupp.add_apply]
          omega
        · refine Or.inr (Or.inl ?_)
          ext i; fin_cases i <;> simp [eU2V, h0, h1, single_apply, Finsupp.add_apply]
          omega
      · have h1 : d 1 = 0 := by omega
        have h2 : d 2 = 0 := by omega
        refine Or.inl ?_
        ext i; fin_cases i <;> simp [eU3, h0, h1, h2, single_apply]
    rw [coeff_planeCubicSum_at f d hmem]
  · rw [hf.coeff_eq_zero hd]
    symm
    exact (planeCubicSum_isHomogeneous f).coeff_eq_zero hd

private theorem prod_single_pow (x : Fin 3 → R) (i : Fin 3) (n : ℕ) :
    ((single i n).prod fun j e => x j ^ e) = x i ^ n :=
  prod_single_index (pow_zero _)

private theorem prod_add_pows (x : Fin 3 → R) (i j : Fin 3) (n m : ℕ) :
    ((single i n + single j m).prod fun k e => x k ^ e) = x i ^ n * x j ^ m := by
  classical
  rw [prod_add_index' (fun a => pow_zero (x a)) (fun a b₁ b₂ => pow_add (x a) b₁ b₂),
    prod_single_pow, prod_single_pow]

private theorem prod_three_pows (x : Fin 3 → R) :
    ((single (0 : Fin 3) 1 + single 1 1 + single 2 1).prod fun k e => x k ^ e) =
      x 0 * x 1 * x 2 := by
  classical
  rw [prod_add_index' (fun a => pow_zero (x a)) (fun a b₁ b₂ => pow_add (x a) b₁ b₂),
    prod_single_pow, prod_add_pows]
  ring

/-- Evaluation of a homogeneous plane cubic equals the universal `planeCubicValue`. -/
theorem eval_eq_planeCubicValue
    {f : MvPolynomial (Fin 3) R} (hf : f.IsHomogeneous 3) (x : Fin 3 → R) :
    eval x f =
      UniversalResidual.planeCubicValue
        (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
        (coeffU2W f) (coeffUVW f) (coeffV2W f)
        (coeffUW2 f) (coeffVW2 f) (coeffW3 f)
        (x 0) (x 1) (x 2) := by
  -- Rewrite only the left-hand evaluation, keeping `coeffU* f` as original coeffs
  conv_lhs => rw [planeCubic_eq_sum_monomials f hf]
  simp only [map_add, eval_monomial, UniversalResidual.planeCubicValue,
    eU3, eU2V, eUV2, eV3, eU2W, eUVW, eV2W, eUW2, eVW2, eW3]
  have h03 := prod_single_pow x 0 3
  have h13 := prod_single_pow x 1 3
  have h23 := prod_single_pow x 2 3
  have h021 := prod_add_pows x 0 1 2 1
  have h012 := prod_add_pows x 0 1 1 2
  have h022 := prod_add_pows x 0 2 2 1
  have h122 := prod_add_pows x 1 2 2 1
  have h0022 := prod_add_pows x 0 2 1 2
  have h1122 := prod_add_pows x 1 2 1 2
  have h111 := prod_three_pows x
  simp only [h03, h13, h23, h021, h012, h022, h122, h0022, h1122, h111, pow_one]
  ring

/-- Certificate identity (2.1) for a homogeneous plane cubic at a point. -/
theorem residual_identity_eval
    {f : MvPolynomial (Fin 3) R} (hf : f.IsHomogeneous 3) (p : Fin 3 → R) :
    UniversalResidual.polarResultant
        (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
        (coeffU2W f) (coeffUVW f) (coeffV2W f) (p 0) (p 1) (p 2) +
      UniversalResidual.binaryCubicDiscr
          (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f) *
        eval p f =
      (p 2) ^ 2 * eval p (residualLinearForm f) := by
  have hid :=
    UniversalResidual.residual_identity
      (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
      (coeffU2W f) (coeffUVW f) (coeffV2W f)
      (coeffUW2 f) (coeffVW2 f) (coeffW3 f)
      (p 0) (p 1) (p 2)
  rw [eval_residualLinearForm, eval_eq_planeCubicValue hf p]
  simpa [pow_two] using hid

end
end PlaneCubicResidual
end BConicBundleMultisections
