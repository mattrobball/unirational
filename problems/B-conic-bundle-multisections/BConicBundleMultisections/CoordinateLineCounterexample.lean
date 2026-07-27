/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Bidegree23Example
public import BConicBundleMultisections.ResidualLineBasePointFree

/-!
# The coordinate line need not be good

The smooth diagonal example `Bidegree23Example.F` has cubic fibres

`A(x) Y₀³ + D(x) Y₁³ + K(x) Y₂³`.

For the hardcoded line `Y₂ = 0`, the universal residual coefficients satisfy `q_U = q_V = 0`.
Consequently its residual line is constant.  This axiom-free regression theorem prevents the
all-smooth argument from silently replacing the source's chosen good line by the coordinate line.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open BiprojectiveSpace MvPolynomial ResidualDivisor

variable (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)] [Infinite k]

private theorem residualCoeffU_example_eq_zero :
    residualCoeffU_of (Bidegree23Example.F k) = 0 := by
  apply MvPolynomial.funext
  intro x
  let A : k := x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2
  let D : k := x 0 ^ 2 + 2 * x 1 ^ 2 + 3 * x 2 ^ 2
  let K : k := x 0 ^ 2 + 4 * x 1 ^ 2 + 9 * x 2 ^ 2
  have hspec : specializeFirstCoordinates (n := 2) x (Bidegree23Example.F k) =
      MvPolynomial.C A * MvPolynomial.X 0 ^ 3 +
        MvPolynomial.C D * MvPolynomial.X 1 ^ 3 +
          MvPolynomial.C K * MvPolynomial.X 2 ^ 3 := by
    apply MvPolynomial.funext
    intro y
    rw [eval_specializeFirstCoordinates, Bidegree23Example.eval_F]
    simp [A, D, K]
    ring
  rw [eval_residualCoeffU_of, hspec]
  simp [UniversalResidual.residualCoeffU, MvPolynomial.coeff_C_mul,
    MvPolynomial.coeff_X_pow, Finsupp.ext_iff, Finsupp.single_apply,
    Fin.forall_fin_succ, Fin.forall_fin_zero]

private theorem residualCoeffV_example_eq_zero :
    residualCoeffV_of (Bidegree23Example.F k) = 0 := by
  apply MvPolynomial.funext
  intro x
  let A : k := x 0 ^ 2 + x 1 ^ 2 + x 2 ^ 2
  let D : k := x 0 ^ 2 + 2 * x 1 ^ 2 + 3 * x 2 ^ 2
  let K : k := x 0 ^ 2 + 4 * x 1 ^ 2 + 9 * x 2 ^ 2
  have hspec : specializeFirstCoordinates (n := 2) x (Bidegree23Example.F k) =
      MvPolynomial.C A * MvPolynomial.X 0 ^ 3 +
        MvPolynomial.C D * MvPolynomial.X 1 ^ 3 +
          MvPolynomial.C K * MvPolynomial.X 2 ^ 3 := by
    apply MvPolynomial.funext
    intro y
    rw [eval_specializeFirstCoordinates, Bidegree23Example.eval_F]
    simp [A, D, K]
    ring
  rw [eval_residualCoeffV_of, hspec]
  simp [UniversalResidual.residualCoeffV, MvPolynomial.coeff_C_mul,
    MvPolynomial.coeff_X_pow, Finsupp.ext_iff, Finsupp.single_apply,
    Fin.forall_fin_succ, Fin.forall_fin_zero]

/-- The residual line of the smooth diagonal example along `Y₂ = 0` is constant. -/
theorem Bidegree23Example.residualLineConstant :
    ResidualLineConstant (Bidegree23Example.F k) := by
  refine ⟨residualCoeffW_of (Bidegree23Example.F k), ![0, 0, 1], ?_⟩
  intro a
  fin_cases a
  · change residualLineCoeff (Bidegree23Example.F k) 0 =
      MvPolynomial.C 0 * residualCoeffW_of (Bidegree23Example.F k)
    rw [residualLineCoeff_zero, residualCoeffU_example_eq_zero]
    simp
  · change residualLineCoeff (Bidegree23Example.F k) 1 =
      MvPolynomial.C 0 * residualCoeffW_of (Bidegree23Example.F k)
    rw [residualLineCoeff_one, residualCoeffV_example_eq_zero]
    simp
  · change residualLineCoeff (Bidegree23Example.F k) 2 =
      MvPolynomial.C 1 * residualCoeffW_of (Bidegree23Example.F k)
    rw [residualLineCoeff_two]
    simp

end

end BConicBundleMultisections
