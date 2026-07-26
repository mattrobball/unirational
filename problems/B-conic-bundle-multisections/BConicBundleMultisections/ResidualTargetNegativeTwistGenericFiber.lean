/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveHypersurfaceNegativeTwist
public import BConicBundleMultisections.ResidualTargetProjectiveVanishingDescent

/-!
# Generic-fibre endpoint for the residual negative-twist argument

Let `H` be an irreducible positive-degree homogeneous equation for a projective target curve.
On a retained target chart, a local quotient of a bidegree `(10,1)` equation by a bidegree
`(2,3)` equation has target degree `-2`.  Coefficientwise, multiplication by a target quadratic
therefore gives a global regular function.  The negative-twist theorem on the integral
projective curve forces every coefficient to vanish in its function field, and injectivity of
the chart ring into that function field forces the whole quotient to vanish.

This file proves the complete algebraic endpoint from that coefficientwise extension property.
It then combines local factorization on every product chart with projective chart-vanishing
descent.  The conclusion is literal membership in `(F,H(y))`, but no radicality or primeness of
that two-generated affine Cox ideal is assumed.  The remaining input is precisely construction
of the global-section comparison and gluing of the quadratic multiples of each local quotient
coefficient.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry
open _root_.MvPolynomial

namespace ProjectiveSpace

/-- A polynomial over a retained hypersurface chart vanishes if every coefficient, viewed in
the hypersurface function field, has all required quadratic multiples extending globally.

This is the coefficientwise generic-fibre/projective-degree endpoint.  It uses only the
integrality of the retained chart and the negative-twist theorem on the projective curve. -/
theorem mvPolynomial_eq_zero_of_coeff_quadraticMultiples_extendToGlobal
    {k : Type u} [Field k] [IsAlgClosed k]
    {σ : Type*}
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (comparison :
      GlobalSectionsToHypersurfaceFunctionFieldComparison H hH hHirr i)
    (R : MvPolynomial σ (HypersurfaceChartQuotient H i.1))
    (hext : ∀ e : σ →₀ ℕ,
      QuadraticMultiplesExtendToGlobal H hH hHirr i comparison
        (hypersurfaceChartQuotientToFunctionField H hH hHirr i (R.coeff e))) :
    R = 0 := by
  let A := HypersurfaceChartQuotient H i.1
  let K := HypersurfaceFunctionField H i
  letI : IsDomain A :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  ext e
  apply IsFractionRing.injective A K
  change hypersurfaceChartQuotientToFunctionField H hH hHirr i (R.coeff e) =
    hypersurfaceChartQuotientToFunctionField H hH hHirr i ((0 : MvPolynomial σ A).coeff e)
  rw [hypersurfaceFunctionField_eq_zero_of_quadraticMultiples_extendToGlobal
    H hH hd hHirr i comparison _ (hext e)]
  simp

/-- Invariant version of the coefficientwise endpoint: it is enough that multiplication by
every homogeneous target quadratic extends globally. -/
theorem mvPolynomial_eq_zero_of_coeff_homogeneousQuadraticMultiples_extendToGlobal
    {k : Type u} [Field k] [IsAlgClosed k]
    {σ : Type*}
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (comparison :
      GlobalSectionsToHypersurfaceFunctionFieldComparison H hH hHirr i)
    (R : MvPolynomial σ (HypersurfaceChartQuotient H i.1))
    (hext : ∀ e : σ →₀ ℕ,
      HomogeneousQuadraticMultiplesExtendToGlobal H hH hHirr i comparison
        (hypersurfaceChartQuotientToFunctionField H hH hHirr i (R.coeff e))) :
    R = 0 := by
  let A := HypersurfaceChartQuotient H i.1
  let K := HypersurfaceFunctionField H i
  letI : IsDomain A :=
    isDomain_chartDehomogenization_quotient_of_irreducible
      i.1 H hH hHirr i.2
  ext e
  apply IsFractionRing.injective A K
  change hypersurfaceChartQuotientToFunctionField H hH hHirr i (R.coeff e) =
    hypersurfaceChartQuotientToFunctionField H hH hHirr i ((0 : MvPolynomial σ A).coeff e)
  rw [hypersurfaceFunctionField_eq_zero_of_homogeneousQuadraticMultiples_extendToGlobal
    H hH hd hHirr i comparison _ (hext e)]
  simp

end ProjectiveSpace

namespace BiprojectiveSpace

/-- A local factorization by the conic has zero right-hand side once the local quotient's
coefficients satisfy the projective degree `-2` extension condition. -/
theorem eq_zero_of_exists_factor_and_coeff_quadraticMultiples_extendToGlobal
    {k : Type u} [Field k] [IsAlgClosed k]
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : ProjectiveSpace.NonemptyHypersurfaceChart H)
    (comparison :
      ProjectiveSpace.GlobalSectionsToHypersurfaceFunctionFieldComparison
        H hH hHirr i)
    (F Q : MvPolynomial (Fin 2) (targetRelationBaseChartRing k H i.1))
    (R : MvPolynomial (Fin 2) (targetRelationBaseChartRing k H i.1))
    (hfactor : R * F = Q)
    (hext : ∀ e : Fin 2 →₀ ℕ,
      ProjectiveSpace.QuadraticMultiplesExtendToGlobal H hH hHirr i comparison
        (ProjectiveSpace.hypersurfaceChartQuotientToFunctionField
          H hH hHirr i (R.coeff e))) :
    Q = 0 := by
  have hR : R = 0 :=
    ProjectiveSpace.mvPolynomial_eq_zero_of_coeff_quadraticMultiples_extendToGlobal
      H hH hd hHirr i comparison R hext
  rw [← hfactor, hR, zero_mul]

/-- Local factorization on every product chart, together with the coefficientwise projective
degree `-2` extension property, implies literal Cox membership of `Q` in `(F,H(y))`.

The proof first kills every local quotient by the generic-function-field negative-twist theorem.
It then descends chartwise vanishing using only the prime vertical ideal `(H(y))`; the possibly
nonradical affine complete-intersection cone `(F,H(y))` never enters. -/
theorem mem_span_targetRelation_of_local_factors_quadraticMultiples_extendToGlobal
    {k : Type u} [Field k] [IsAlgClosed k]
    (F Q : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    {aF eF aQ eQ d : ℕ}
    (_hF : IsBihomogeneousOfBidegree aF eF F)
    (hQ : IsBihomogeneousOfBidegree aQ eQ Q)
    (haQ : 0 < aQ) (heQ : 0 < eQ)
    (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (comparison : (i : ProjectiveSpace.NonemptyHypersurfaceChart H) →
      ProjectiveSpace.GlobalSectionsToHypersurfaceFunctionFieldComparison
        H hH hHirr i)
    (hfactor : ∀ (a : Fin 3)
        (i : ProjectiveSpace.NonemptyHypersurfaceChart H),
      ∃ R : MvPolynomial (Fin 2) (targetRelationBaseChartRing k H i.1),
        R * affineChartEquationOverTargetRelationBase k H a i.1 F =
          affineChartEquationOverTargetRelationBase k H a i.1 Q)
    (hext : ∀ (a : Fin 3)
        (i : ProjectiveSpace.NonemptyHypersurfaceChart H)
        (R : MvPolynomial (Fin 2) (targetRelationBaseChartRing k H i.1)),
      R * affineChartEquationOverTargetRelationBase k H a i.1 F =
          affineChartEquationOverTargetRelationBase k H a i.1 Q →
        ∀ e : Fin 2 →₀ ℕ,
          ProjectiveSpace.QuadraticMultiplesExtendToGlobal H hH hHirr i
            (comparison i)
            (ProjectiveSpace.hypersurfaceChartQuotientToFunctionField
              H hH hHirr i (R.coeff e))) :
    Q ∈ Ideal.span {F, MvPolynomial.rename Sum.inr H} := by
  have hzero : ∀ (a b : Fin 3),
      ¬ IsUnit (ProjectiveSpace.chartDehomogenization 2 k b H) →
        affineChartEquationOverTargetRelationBase k H a b Q = 0 := by
    intro a b hb
    let i : ProjectiveSpace.NonemptyHypersurfaceChart H := ⟨b, hb⟩
    obtain ⟨R, hR⟩ := hfactor a i
    exact eq_zero_of_exists_factor_and_coeff_quadraticMultiples_extendToGlobal
      H hH hd hHirr i (comparison i)
      (affineChartEquationOverTargetRelationBase k H a i.1 F)
      (affineChartEquationOverTargetRelationBase k H a i.1 Q)
      R hR (hext a i R hR)
  have hvertical : Q ∈ Ideal.span
      {(0 : MvPolynomial (BiprojectiveCoordinate 2 2) k),
        MvPolynomial.rename Sum.inr H} :=
    mem_span_zero_rename_inr_of_targetRelation_chart_zero
      Q hQ haQ heQ H hH hHirr hzero
  rw [Ideal.span_pair_comm, Ideal.span_pair_zero] at hvertical
  exact (Ideal.span_mono (by simp)) hvertical

/-- Scheme-theoretic exhaustion of the residual target component supplies the local factors in
the preceding theorem.  Thus the sole remaining negative-twist input is coefficientwise gluing
of their target-quadratic multiples. -/
theorem residualEquationOn_mem_span_targetRelation_of_isIso_of_quadraticMultiples_extendToGlobal
    {k : Type u} [Field k] [IsAlgClosed k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0)
    [IsIso (residualTargetComponentOnι
      p₀ q₀ r N hMN F hF v hv i j H hH hvan)]
    (comparison : (b : ProjectiveSpace.NonemptyHypersurfaceChart H) →
      ProjectiveSpace.GlobalSectionsToHypersurfaceFunctionFieldComparison
        H hH hHirr b)
    (hext : ∀ (a : Fin 3)
        (b : ProjectiveSpace.NonemptyHypersurfaceChart H)
        (R : MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b.1)),
      R * affineChartEquationOverTargetRelationBase k H a b.1 F =
          affineChartEquationOverTargetRelationBase k H a b.1
            (residualEquationOn (lineFrame p₀ q₀ r) N F) →
        ∀ e : Fin 2 →₀ ℕ,
          ProjectiveSpace.QuadraticMultiplesExtendToGlobal H hH hHirr b
            (comparison b)
            (ProjectiveSpace.hypersurfaceChartQuotientToFunctionField
              H hH hHirr b (R.coeff e))) :
    residualEquationOn (lineFrame p₀ q₀ r) N F ∈
      Ideal.span {F, MvPolynomial.rename Sum.inr H} := by
  apply mem_span_targetRelation_of_local_factors_quadraticMultiples_extendToGlobal
    F (residualEquationOn (lineFrame p₀ q₀ r) N F)
      hF (ResidualDivisor.residualEquationOn_isBihomogeneous
        (lineFrame p₀ q₀ r) N hF)
      (by norm_num) (by norm_num) H hH hd hHirr comparison
  · intro a b
    exact exists_residualEquationOn_factor_over_targetRelationBase_of_isIso
      p₀ q₀ r N hMN F hF v hv i j H hH hvan a b.1
  · exact hext

end BiprojectiveSpace

end

end BConicBundleMultisections
