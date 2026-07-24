/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PlaneCubicResidualIdentity
public import BConicBundleMultisections.UniversalResidualIdentity

/-!
# Residual coefficient vector of a plane cubic on `{W = 0}`

Packages the residual linear form of certificate identity (2.1) as a coordinate dual covector,
with degree-five homogeneity in the cubic coefficients.
-/

@[expose] public section

open MvPolynomial

namespace BConicBundleMultisections
namespace PlaneCubicResidual

noncomputable section

variable {R : Type*} [CommRing R]

/-- Coefficient vector of the residual linear form of a plane cubic on `{W = 0}`. -/
def residualCoefficientVector (f : MvPolynomial (Fin 3) R) : Fin 3 → R :=
  ![UniversalResidual.residualCoeffU
      (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
      (coeffU2W f) (coeffUVW f) (coeffV2W f) (coeffUW2 f),
    UniversalResidual.residualCoeffV
      (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
      (coeffU2W f) (coeffUVW f) (coeffV2W f) (coeffVW2 f),
    UniversalResidual.residualCoeffW
      (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
      (coeffU2W f) (coeffUVW f) (coeffV2W f) (coeffW3 f)]

@[simp]
theorem residualCoefficientVector_zero (f : MvPolynomial (Fin 3) R) :
    residualCoefficientVector f 0 =
      UniversalResidual.residualCoeffU
        (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
        (coeffU2W f) (coeffUVW f) (coeffV2W f) (coeffUW2 f) := by
  simp [residualCoefficientVector]

@[simp]
theorem residualCoefficientVector_one (f : MvPolynomial (Fin 3) R) :
    residualCoefficientVector f 1 =
      UniversalResidual.residualCoeffV
        (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
        (coeffU2W f) (coeffUVW f) (coeffV2W f) (coeffVW2 f) := by
  simp [residualCoefficientVector]

@[simp]
theorem residualCoefficientVector_two (f : MvPolynomial (Fin 3) R) :
    residualCoefficientVector f 2 =
      UniversalResidual.residualCoeffW
        (coeffU3 f) (coeffU2V f) (coeffUV2 f) (coeffV3 f)
        (coeffU2W f) (coeffUVW f) (coeffV2W f) (coeffW3 f) := by
  simp [residualCoefficientVector]

/-- Evaluating the residual linear form is the coordinate dual pairing with its coefficient
vector. -/
theorem eval_residualLinearForm_eq_dotProduct
    (f : MvPolynomial (Fin 3) R) (p : Fin 3 → R) :
    eval p (residualLinearForm f) = residualCoefficientVector f ⬝ᵥ p := by
  simp [residualLinearForm, residualCoefficientVector, dotProduct, Fin.sum_univ_three]

/-- The residual linear form vanishes exactly on the dual hyperplane of its coefficient vector. -/
theorem eval_residualLinearForm_eq_zero_iff_dotProduct
    (f : MvPolynomial (Fin 3) R) (p : Fin 3 → R) :
    eval p (residualLinearForm f) = 0 ↔ residualCoefficientVector f ⬝ᵥ p = 0 := by
  rw [eval_residualLinearForm_eq_dotProduct]

/-- Residual coefficients scale by `λ⁵` when all ten cubic coefficients are scaled by `λ`. -/
theorem residualCoeffU_smul (r a b c d e f hh i : R) :
    UniversalResidual.residualCoeffU (r * a) (r * b) (r * c) (r * d)
        (r * e) (r * f) (r * hh) (r * i) =
      r ^ 5 * UniversalResidual.residualCoeffU a b c d e f hh i := by
  simp only [UniversalResidual.residualCoeffU]
  ring

theorem residualCoeffV_smul (r a b c d e f hh j : R) :
    UniversalResidual.residualCoeffV (r * a) (r * b) (r * c) (r * d)
        (r * e) (r * f) (r * hh) (r * j) =
      r ^ 5 * UniversalResidual.residualCoeffV a b c d e f hh j := by
  simp only [UniversalResidual.residualCoeffV]
  ring

theorem residualCoeffW_smul (r a b c d e f hh k : R) :
    UniversalResidual.residualCoeffW (r * a) (r * b) (r * c) (r * d)
        (r * e) (r * f) (r * hh) (r * k) =
      r ^ 5 * UniversalResidual.residualCoeffW a b c d e f hh k := by
  simp only [UniversalResidual.residualCoeffW]
  ring

end
end PlaneCubicResidual
end BConicBundleMultisections
