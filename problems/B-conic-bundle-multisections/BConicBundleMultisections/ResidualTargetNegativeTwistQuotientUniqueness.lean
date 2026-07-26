/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.TargetRelationChartDomain

/-!
# Uniqueness of local residual quotients

On a retained affine chart of an irreducible projective target relation, the coefficient ring
is a domain.  Smoothness of the bidegree-`(2,3)` hypersurface makes the restricted conic equation
primitive, hence nonzero.  Cancellation therefore makes a local quotient by that equation
unique.

Discriminant avoidance is not needed for this uniqueness statement.  In particular, the result
applies directly in the stronger standard context where the target relation also avoids the
second-conic discriminant.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry
open _root_.MvPolynomial

namespace BiprojectiveSpace

/-- If two factorizations are written in target charts whose defining and residual equations
scale by `t³` and `t`, respectively, then their quotients scale by `t²`.

This is the cancellation calculation behind the target-degree `-2` transition law. -/
theorem factor_eq_transitionSquare_mul_of_scaled_equations
    {K : Type*} [Field K] {σ : Type*}
    (t : K) (R R' F F' Q Q' : MvPolynomial σ K)
    (hF : F = MvPolynomial.C (t ^ 3) * F')
    (hQ : Q = MvPolynomial.C t * Q')
    (hR : R * F = Q) (hR' : R' * F' = Q')
    (ht : t ≠ 0) (hF' : F' ≠ 0) :
    R' = MvPolynomial.C (t ^ 2) * R := by
  have hprod : R * (MvPolynomial.C (t ^ 3) * F') =
      MvPolynomial.C t * (R' * F') := by
    rw [← hF, hR, hQ, ← hR']
  have hcancel : R * MvPolynomial.C (t ^ 3) = MvPolynomial.C t * R' := by
    apply mul_right_cancel₀ hF'
    calc
      (R * MvPolynomial.C (t ^ 3)) * F' =
          R * (MvPolynomial.C (t ^ 3) * F') := by ring
      _ = MvPolynomial.C t * (R' * F') := hprod
      _ = (MvPolynomial.C t * R') * F' := by ring
  have htC : MvPolynomial.C t ≠ (0 : MvPolynomial σ K) :=
    MvPolynomial.C_ne_zero.mpr ht
  apply mul_left_cancel₀ htC
  calc
    MvPolynomial.C t * R' = R * MvPolynomial.C (t ^ 3) := hcancel.symm
    _ = MvPolynomial.C t * (MvPolynomial.C (t ^ 2) * R) := by
      simp only [map_pow]
      ring

/-- The conic equation restricted to a retained target-relation chart is nonzero.

The coefficient-span theorem makes this polynomial primitive.  The retained-chart domain
instance rules out the only exceptional case in which the zero polynomial could have unit
coefficient ideal, namely a trivial coefficient ring. -/
theorem affineChartEquationOverTargetRelationBase_ne_zero_of_smooth_irreducible
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (b : ProjectiveSpace.NonemptyHypersurfaceChart H)
    (a : Fin 3) :
    affineChartEquationOverTargetRelationBase k H a b.1 F ≠ 0 := by
  letI : IsDomain (targetRelationBaseChartRing k H b.1) :=
    ProjectiveSpace.isDomain_chartDehomogenization_quotient_of_irreducible
      b.1 H hH hHirr b.2
  intro hzero
  have hcoeff :=
    span_range_coeff_affineChartEquationOverTargetRelationBase_eq_top
      F hF hF0 H a b.1
  rw [hzero] at hcoeff
  simp at hcoeff

/-- A local quotient by the restricted conic equation is unique on a retained target chart.

The right-hand side `Q` is arbitrary, so this applies both to residual equations and to any
other chartwise divisibility construction. -/
theorem factor_over_targetRelationBase_unique_of_smooth_irreducible
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hHirr : Irreducible H)
    (b : ProjectiveSpace.NonemptyHypersurfaceChart H)
    (a : Fin 3)
    {Q R S : MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b.1)}
    (hR : R * affineChartEquationOverTargetRelationBase k H a b.1 F = Q)
    (hS : S * affineChartEquationOverTargetRelationBase k H a b.1 F = Q) :
    R = S := by
  letI : IsDomain (targetRelationBaseChartRing k H b.1) :=
    ProjectiveSpace.isDomain_chartDehomogenization_quotient_of_irreducible
      b.1 H hH hHirr b.2
  apply mul_right_cancel₀
    (affineChartEquationOverTargetRelationBase_ne_zero_of_smooth_irreducible
      F hF hF0 H hH hHirr b a)
  exact hR.trans hS.symm

end BiprojectiveSpace

end

end BConicBundleMultisections

end
