/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualPrimitiveEquation
public import BConicBundleMultisections.TernaryQuadraticGradient

/-!
# A target relation forces a constant residual line

This file records the final elementary step in the target-relation argument.  If the arbitrary-
line residual equation belongs to `(F,H(y))` for a nonconstant homogeneous `H`, bidegree forces
`H` to be linear and the residual equation to be a first-block polynomial times that fixed linear
form.  Consequently its three coefficient forms are constant multiples of one polynomial, which
is exactly failure of condition G3.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open _root_.MvPolynomial ResidualDivisor

universe u

/-- Membership of the residual equation in a nonconstant vertical target-relation ideal forces
the residual line to be constant. -/
theorem residualLineConstantOn_of_mem_targetRelation
    {K : Type u} [Field K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F)
    (hq0 : residualEquationOn M N F ≠ 0)
    {d : ℕ} {H : MvPolynomial (Fin 3) K}
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hmem : residualEquationOn M N F ∈ Ideal.span {F, MvPolynomial.rename Sum.inr H}) :
    ResidualLineConstantOn M N F := by
  obtain ⟨hd1, B, hB, hfactor⟩ :=
    residualEquationOn_factor_of_mem_targetRelation M N hF hq0 hH hd hmem
  subst d
  obtain ⟨c, hc⟩ := TernaryQuadratic.eq_sum_C_mul_X_of_isHomogeneous_one H hH
  let g : MvPolynomial (Fin 3) K :=
    secondBlockCoeff B 0
  have hBeq : B = liftFirstBlock g :=
    ResidualPrimitiveEquation.eq_liftFirstBlock_secondBlockCoeff_zero B hB
  refine ⟨g, c, fun a ↦ ?_⟩
  apply ResidualPrimitiveEquation.residualLineCoeffOn_eq_of_eq_sum_local
    M N F (fun l ↦ C (c l) * g)
  rw [hfactor, hBeq, hc, map_sum]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro l _
  simp only [map_mul, rename_C, rename_X, liftSecondLinear, liftFirstBlock]
  ring

end

end BConicBundleMultisections
