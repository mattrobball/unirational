/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualTargetNegativeTwistChartEquationTransport
public import BConicBundleMultisections.ResidualTargetNegativeTwistQuotientUniqueness
public import BConicBundleMultisections.ResidualTargetNegativeTwistTransitionCompatibility

/-!
# Transition compatibility of residual target factors

For a fixed first projective chart, the conic and residual equations have target degrees three
and one.  Their local quotient therefore has target transition degree minus two.  This file
proves that calculation in the intrinsic function field and records the resulting invariance of
the coefficients after multiplication by a homogeneous target quadratic.
-/

@[expose] public section

open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry
open _root_.MvPolynomial

namespace BiprojectiveSpace

/-- Two local factors on retained target charts differ by the square of the intrinsic target
transition.  The first projective chart `a` is fixed throughout. -/
theorem map_factor_eq_transitionSquare_mul_of_factorizations
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (b b' : ProjectiveSpace.NonemptyHypersurfaceChart H)
    (a : Fin 3)
    (Q : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hQ : IsBihomogeneousOfBidegree 10 1 Q)
    (R : MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b.1))
    (R' : MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b'.1))
    (hR : R * affineChartEquationOverTargetRelationBase k H a b.1 F =
      affineChartEquationOverTargetRelationBase k H a b.1 Q)
    (hR' : R' * affineChartEquationOverTargetRelationBase k H a b'.1 F =
      affineChartEquationOverTargetRelationBase k H a b'.1 Q) :
    letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
      ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    MvPolynomial.map
        (ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
          H hH hd hHirr b') R' =
      MvPolynomial.C
          (targetRelationIntrinsicTransition H hH hd hHirr b b' ^ 2) *
        MvPolynomial.map
          (ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
            H hH hd hHirr b) R := by
  letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
    ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  let φ := ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
    H hH hd hHirr b
  let φ' := ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
    H hH hd hHirr b'
  let T := targetRelationIntrinsicTransition H hH hd hHirr b b'
  let Fb := affineChartEquationOverTargetRelationBase k H a b.1 F
  let Fb' := affineChartEquationOverTargetRelationBase k H a b'.1 F
  let Qb := affineChartEquationOverTargetRelationBase k H a b.1 Q
  let Qb' := affineChartEquationOverTargetRelationBase k H a b'.1 Q
  have hFscale : MvPolynomial.map φ Fb =
      MvPolynomial.C (T ^ 3) * MvPolynomial.map φ' Fb' := by
    have h := affineChartEquationOverTargetRelationBase_intrinsic_transition
      H hH hd hHirr b b' a F hF
    simpa only [map_pow] using h
  have hQscale : MvPolynomial.map φ Qb =
      MvPolynomial.C T * MvPolynomial.map φ' Qb' := by
    have h := affineChartEquationOverTargetRelationBase_intrinsic_transition
      H hH hd hHirr b b' a Q hQ
    simpa only [pow_one] using h
  have hRmap : MvPolynomial.map φ R * MvPolynomial.map φ Fb =
      MvPolynomial.map φ Qb := by
    simpa only [map_mul] using congrArg (MvPolynomial.map φ) hR
  have hR'map : MvPolynomial.map φ' R' * MvPolynomial.map φ' Fb' =
      MvPolynomial.map φ' Qb' := by
    simpa only [map_mul] using congrArg (MvPolynomial.map φ') hR'
  have hFb'0 : MvPolynomial.map φ' Fb' ≠ 0 := by
    have hbase : Fb' ≠ 0 :=
      affineChartEquationOverTargetRelationBase_ne_zero_of_smooth_irreducible
        F hF hF0 H hH hHirr b' a
    intro hz
    apply hbase
    apply MvPolynomial.map_injective φ'
      (ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField_injective
        H hH hd hHirr b')
    simpa only [map_zero] using hz
  exact factor_eq_transitionSquare_mul_of_scaled_equations
    T (MvPolynomial.map φ R) (MvPolynomial.map φ' R')
      (MvPolynomial.map φ Fb) (MvPolynomial.map φ' Fb')
      (MvPolynomial.map φ Qb) (MvPolynomial.map φ' Qb')
      hFscale hQscale hRmap hR'map
      (isUnit_targetRelationIntrinsicTransition H hH hd hHirr b b').ne_zero hFb'0

/-- Multiplication by a homogeneous target quadratic cancels the residual factor's negative
transition degree, coefficient by coefficient. -/
theorem mapped_quadratic_mul_factor_coeff_eq
    {k : Type u} [Field k] [IsAlgClosed k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (b b' : ProjectiveSpace.NonemptyHypersurfaceChart H)
    (a : Fin 3)
    (Q : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hQ : IsBihomogeneousOfBidegree 10 1 Q)
    (R : MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b.1))
    (R' : MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b'.1))
    (hR : R * affineChartEquationOverTargetRelationBase k H a b.1 F =
      affineChartEquationOverTargetRelationBase k H a b.1 Q)
    (hR' : R' * affineChartEquationOverTargetRelationBase k H a b'.1 F =
      affineChartEquationOverTargetRelationBase k H a b'.1 Q)
    (e : Fin 2 →₀ ℕ) (P : MvPolynomial (Fin 3) k)
    (hP : P.IsHomogeneous 2) :
    letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
      ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
        H hH hd hHirr b
        (Ideal.Quotient.mk
            (Ideal.span {ProjectiveSpace.chartDehomogenization 2 k b.1 H})
            (ProjectiveSpace.chartDehomogenization 2 k b.1 P) * R.coeff e) =
      ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
        H hH hd hHirr b'
        (Ideal.Quotient.mk
            (Ideal.span {ProjectiveSpace.chartDehomogenization 2 k b'.1 H})
            (ProjectiveSpace.chartDehomogenization 2 k b'.1 P) * R'.coeff e) := by
  letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
    ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  let φ := ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
    H hH hd hHirr b
  let φ' := ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
    H hH hd hHirr b'
  let T := targetRelationIntrinsicTransition H hH hd hHirr b b'
  have hfactor := map_factor_eq_transitionSquare_mul_of_factorizations
    F hF hF0 H hH hd hHirr b b' a Q hQ R R' hR hR'
  have hcoeff := congrArg (MvPolynomial.coeff e) hfactor
  simp only [MvPolynomial.coeff_map, MvPolynomial.coeff_C_mul] at hcoeff
  have hPscale :=
    ProjectiveSpace.hypersurfaceChartDehomogenization_intrinsic_transition_mul
      H hH hd hHirr b b' P hP
  change φ (Ideal.Quotient.mk _
      (ProjectiveSpace.chartDehomogenization 2 k b.1 P)) =
    φ (targetRelationChartCoordinates b.1 H b'.1) ^ 2 *
      φ' (Ideal.Quotient.mk _
        (ProjectiveSpace.chartDehomogenization 2 k b'.1 P)) at hPscale
  rw [← targetRelationIntrinsicTransition_eq_chartCoordinate
    H hH hd hHirr b b'] at hPscale
  change φ (Ideal.Quotient.mk _
      (ProjectiveSpace.chartDehomogenization 2 k b.1 P) * R.coeff e) =
    φ' (Ideal.Quotient.mk _
      (ProjectiveSpace.chartDehomogenization 2 k b'.1 P) * R'.coeff e)
  simp only [map_mul]
  change φ (Ideal.Quotient.mk _
      (ProjectiveSpace.chartDehomogenization 2 k b.1 P)) * φ (R.coeff e) =
    φ' (Ideal.Quotient.mk _
      (ProjectiveSpace.chartDehomogenization 2 k b'.1 P)) * φ' (R'.coeff e)
  change φ (Ideal.Quotient.mk _
      (ProjectiveSpace.chartDehomogenization 2 k b.1 P)) =
      T ^ 2 * φ' (Ideal.Quotient.mk _
        (ProjectiveSpace.chartDehomogenization 2 k b'.1 P)) at hPscale
  change φ' (R'.coeff e) = T ^ 2 * φ (R.coeff e) at hcoeff
  rw [hPscale, hcoeff]
  ring

/-- A family of chartwise factors of the residual equation has coefficientwise compatible
quadratic products in the intrinsic target-curve function field.

The anchor `i` is used only to state the common representative.  The proof applies the
two-chart transition theorem to the family members on `b` and `i`; no global gluing is used. -/
theorem residualTargetNegativeTwistFactor_coeff_intrinsic_transition
    {k : Type u} [Field k] [IsAlgClosed k] [Infinite k]
    (M N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i b : ProjectiveSpace.NonemptyHypersurfaceChart H)
    (a : Fin 3)
    (R : (c : ProjectiveSpace.NonemptyHypersurfaceChart H) →
      MvPolynomial (Fin 2) (targetRelationBaseChartRing k H c.1))
    (hR : ∀ c : ProjectiveSpace.NonemptyHypersurfaceChart H,
      R c * affineChartEquationOverTargetRelationBase k H a c.1 F =
        affineChartEquationOverTargetRelationBase k H a c.1
          (residualEquationOn M N F))
    (e : Fin 2 →₀ ℕ) (P : MvPolynomial (Fin 3) k)
    (hP : P.IsHomogeneous 2) :
    letI : IsIntegral (ProjectiveSpace.projectiveZeroLocus 2 k H) :=
      ProjectiveSpace.isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
    ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
        H hH hd hHirr b
        (Ideal.Quotient.mk
            (Ideal.span {ProjectiveSpace.chartDehomogenization 2 k b.1 H})
            (ProjectiveSpace.chartDehomogenization 2 k b.1 P) * (R b).coeff e) =
      ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
        H hH hd hHirr i
        (Ideal.Quotient.mk
            (Ideal.span {ProjectiveSpace.chartDehomogenization 2 k i.1 H})
            (ProjectiveSpace.chartDehomogenization 2 k i.1 P) * (R i).coeff e) := by
  exact mapped_quadratic_mul_factor_coeff_eq
    F hF hF0 H hH hd hHirr b i a (residualEquationOn M N F)
      (ResidualDivisor.residualEquationOn_isBihomogeneous M N hF)
      (R b) (R i) (hR b) (hR i) e P hP

end BiprojectiveSpace

end

end BConicBundleMultisections

end
