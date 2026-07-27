/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualTargetProjectiveVanishingDescent
public import BConicBundleMultisections.ResidualTargetRelationConstantLine

/-!
# The final consumer of projective negative-twist vanishing

Once the local negative-twist quotients vanish on every nonempty chart of an irreducible target
curve, `ResidualTargetProjectiveVanishingDescent` puts the residual equation in the principal
vertical ideal `(H(y))`.  The existing bidegree argument then says that the residual line is
constant.  This contradicts condition G3.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open _root_.MvPolynomial ResidualDivisor

universe u

namespace BiprojectiveSpace

/-- Projective negative-twist vanishing along a nonconstant irreducible target relation forces
the arbitrary-frame residual line to be constant. -/
theorem residualLineConstantOn_of_targetRelation_chart_zero
    {K : Type u} [Field K] [IsAlgClosed K] [Infinite K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F)
    (hq0 : residualEquationOn M N F ≠ 0)
    {d : ℕ} (H : MvPolynomial (Fin 3) K)
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (hzero : ∀ (a b : Fin 3),
      ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 K b H) →
        affineChartEquationOverTargetRelationBase K H a b
          (residualEquationOn M N F) = 0) :
    ResidualLineConstantOn M N F := by
  let Q := residualEquationOn M N F
  have hQ : IsBihomogeneousOfBidegree 10 1 Q :=
    residualEquationOn_isBihomogeneous M N hF
  have hmem0 : Q ∈ Ideal.span
      {(0 : MvPolynomial (BiprojectiveCoordinate 2 2) K), rename Sum.inr H} :=
    mem_span_zero_rename_inr_of_targetRelation_chart_zero_of_isAlgClosed
      Q hQ (by norm_num) (by norm_num) H hH hHirr hzero
  obtain ⟨A, B, hAB⟩ := Ideal.mem_span_pair.mp hmem0
  have hmem : Q ∈ Ideal.span {F, rename Sum.inr H} := by
    apply Ideal.mem_span_pair.mpr
    refine ⟨0, B, ?_⟩
    simpa using hAB
  exact residualLineConstantOn_of_mem_targetRelation
    M N hF hq0 hH hd hmem

/-- Under G3, an irreducible positive-degree target relation cannot have all of its nonempty
charts killed by the negative-twist restriction. -/
theorem exists_targetRelation_chart_ne_zero_of_residualLineNonconstantOn
    {K : Type u} [Field K] [IsAlgClosed K] [Infinite K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F)
    (hgood : ResidualLineNonconstantOn M N F)
    {d : ℕ} (H : MvPolynomial (Fin 3) K)
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H) :
    ∃ a b : Fin 3,
      ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 K b H) ∧
        affineChartEquationOverTargetRelationBase K H a b
          (residualEquationOn M N F) ≠ 0 := by
  by_contra hnone
  apply hgood
  apply residualLineConstantOn_of_targetRelation_chart_zero
    M N hF
      (ResidualPrimitiveEquation.residualEquationOn_ne_zero_of_nonconstant
        M N F hgood)
      H hH hd hHirr
  intro a b hb
  by_contra hne
  exact hnone ⟨a, b, hb, hne⟩

end BiprojectiveSpace

end

end BConicBundleMultisections

end
