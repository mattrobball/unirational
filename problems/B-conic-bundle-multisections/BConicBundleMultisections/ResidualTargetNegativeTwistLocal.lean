/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualTargetProjectiveChartMembership

/-!
# Local divisibility over a projective target-relation chart

Scheme-theoretic exhaustion gives membership in the two-equation ideal on every product chart.
After quotienting the second-factor chart by the target relation, its generator vanishes.  The
remaining ideal membership is therefore a literal local factorization of the residual equation
by the conic equation.

These local quotients are the affine representatives of the negative-twist section used in the
global horizontality argument.  No assertion about the unsaturated Cox ideal is made here.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry
open _root_.MvPolynomial

namespace BiprojectiveSpace

/-- The coordinate ring of the standard chart `b` on the projective relation curve `V(H)`. -/
abbrev targetRelationBaseChartRing
    (k : Type u) [Field k] (H : MvPolynomial (Fin 3) k) (b : Fin 3) :=
  MvPolynomial (Fin 2) k ⧸
    Ideal.span {ProjectiveSpace.chartDehomogenization 2 k b H}

/-- Restrict a polynomial on a standard product chart to the affine relation curve in the
second factor, while retaining the first-factor affine variables as polynomial variables. -/
def affineChartToTargetRelationBase
    (k : Type u) [Field k] (H : MvPolynomial (Fin 3) k) (b : Fin 3) :
    MvPolynomial (Fin 2 ⊕ Fin 2) k →ₐ[k]
      MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b) :=
  MvPolynomial.aeval fun
    | .inl r => MvPolynomial.X r
    | .inr s => MvPolynomial.C
        (Ideal.Quotient.mk (Ideal.span
          {ProjectiveSpace.chartDehomogenization 2 k b H}) (MvPolynomial.X s))

/-- A Cox equation dehomogenized on `(a,b)` and then restricted to the affine target-relation
chart `V(H) ∩ D(Y_b)`. -/
def affineChartEquationOverTargetRelationBase
    (k : Type u) [Field k] (H : MvPolynomial (Fin 3) k)
    (a b : Fin 3) (P : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b) :=
  affineChartToTargetRelationBase k H b (affineChartEquation 2 2 k a b P)

/-- A polynomial supported in the second Cox block restricts to the constant polynomial whose
coefficient is its ordinary dehomogenization modulo `H`. -/
theorem affineChartToTargetRelationBase_affineChartEquation_rename_inr
    (k : Type u) [Field k] (H P : MvPolynomial (Fin 3) k)
    (a b : Fin 3) :
    affineChartEquationOverTargetRelationBase k H a b
        (MvPolynomial.rename
          (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) P) =
      MvPolynomial.C
        (Ideal.Quotient.mk (Ideal.span
          {ProjectiveSpace.chartDehomogenization 2 k b H})
          (ProjectiveSpace.chartDehomogenization 2 k b P)) := by
  induction P using MvPolynomial.induction_on with
  | C c =>
      simp [affineChartEquationOverTargetRelationBase,
        affineChartToTargetRelationBase, affineChartEquation,
        affineChartEvaluation]
      simpa using (Ideal.Quotient.mk_algebraMap
        (R₁ := k)
        (Ideal.span {ProjectiveSpace.chartDehomogenization 2 k b H}) c).symm
  | add P Q hP hQ =>
      simpa [affineChartEquationOverTargetRelationBase, affineChartEquation,
        affineChartEvaluation, map_add] using
        congrArg₂ (fun x y ↦ x + y) hP hQ
  | mul_X P j hP =>
      have hX :
          affineChartEquationOverTargetRelationBase k H a b
              (MvPolynomial.X (.inr j)) =
            MvPolynomial.C
              (Ideal.Quotient.mk (Ideal.span
                {ProjectiveSpace.chartDehomogenization 2 k b H})
                (ProjectiveSpace.chartDehomogenization 2 k b
                  (MvPolynomial.X j))) := by
        rcases Fin.eq_self_or_eq_succAbove b j with rfl | ⟨s, rfl⟩
        · simp [affineChartEquationOverTargetRelationBase,
            affineChartToTargetRelationBase, affineChartEquation,
            affineChartEvaluation, affineChartVariable]
        · simp [affineChartEquationOverTargetRelationBase,
            affineChartToTargetRelationBase, affineChartEquation,
            affineChartEvaluation, affineChartVariable]
      simpa [affineChartEquationOverTargetRelationBase, affineChartEquation,
        affineChartEvaluation, map_mul] using
        congrArg₂ (fun x y ↦ x * y) hP hX

/-- The lifted target relation itself vanishes after restriction to its affine chart. -/
@[simp]
theorem affineChartEquationOverTargetRelationBase_rename_inr_eq_zero
    (k : Type u) [Field k] (H : MvPolynomial (Fin 3) k)
    (a b : Fin 3) :
    affineChartEquationOverTargetRelationBase k H a b
        (MvPolynomial.rename
          (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H) = 0 := by
  rw [affineChartToTargetRelationBase_affineChartEquation_rename_inr k H H]
  simp

/-- Two-equation chart membership becomes divisibility by `F` after passing to the affine
target-relation curve. -/
theorem exists_factor_over_targetRelationBase_of_mem_twoEquationAffineChartIdeal
    (k : Type u) [Field k] (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (H : MvPolynomial (Fin 3) k) (a b : Fin 3)
    (Q : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hmem : affineChartEquation 2 2 k a b Q ∈
      twoEquationAffineChartIdeal 2 2 k a b F
        (MvPolynomial.rename
          (Sum.inr : Fin 3 → BiprojectiveCoordinate 2 2) H)) :
    ∃ R : MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b),
      R * affineChartEquationOverTargetRelationBase k H a b F =
        affineChartEquationOverTargetRelationBase k H a b Q := by
  obtain ⟨A, B, hAB⟩ := Ideal.mem_span_pair.mp hmem
  refine ⟨affineChartToTargetRelationBase k H b A, ?_⟩
  have hmapped := congrArg (affineChartToTargetRelationBase k H b) hAB
  simp only [map_add, map_mul] at hmapped
  have hG := affineChartEquationOverTargetRelationBase_rename_inr_eq_zero k H a b
  change affineChartToTargetRelationBase k H b
      (affineChartEquation 2 2 k a b (MvPolynomial.rename Sum.inr H)) = 0 at hG
  rw [hG, mul_zero, add_zero] at hmapped
  simpa [affineChartEquationOverTargetRelationBase] using hmapped

/-- Scheme-theoretic exhaustion supplies a local quotient of the residual equation by `F` on
every standard chart of the projective target relation. -/
theorem exists_residualEquationOn_factor_over_targetRelationBase_of_isIso
    {k : Type u} [Field k] [Infinite k]
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
    (a b : Fin 3) :
    ∃ R : MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b),
      R * affineChartEquationOverTargetRelationBase k H a b F =
        affineChartEquationOverTargetRelationBase k H a b
          (residualEquationOn (lineFrame p₀ q₀ r) N F) := by
  apply exists_factor_over_targetRelationBase_of_mem_twoEquationAffineChartIdeal
  exact affineChartEquation_residualEquationOn_mem_targetRelationChart_of_isIso
    p₀ q₀ r N hMN F hF v hv i j H hH hvan a b

end BiprojectiveSpace

end

end BConicBundleMultisections
