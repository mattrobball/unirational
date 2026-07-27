/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualTargetNegativeTwistTransitionCompatibility
public import BConicBundleMultisections.ResidualTargetNegativeTwistFactorTransition
public import BConicBundleMultisections.ResidualTargetRelationGeometryNegativeTwist

/-!
# Automatic projective gluing for residual negative twists

This file assembles coefficientwise transition-compatible retained-chart representatives into
the projective gluing package consumed by the residual target-relation argument.  The concrete
transition calculation is kept separate: it identifies the chart representatives obtained by
multiplying a local residual factor by the dehomogenization of a homogeneous target quadratic.
-/

@[expose] public section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry BiprojectiveSpace
open _root_.MvPolynomial

/-- Intrinsic equality of the chartwise products `P_b * s_b` gives the concrete compatible
representatives required by the negative-twist gluing interface. -/
theorem ProjectiveSpace.hasCompatibleRetainedChartRepresentativesAt_of_quadraticProduct_transition
    {k : Type u} [Field k]
    (H : MvPolynomial (Fin 3) k) {d : ℕ}
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (i : NonemptyHypersurfaceChart H)
    (P : MvPolynomial (Fin 3) k) (_hP : P.IsHomogeneous 2)
    (s : (b : NonemptyHypersurfaceChart H) →
      HypersurfaceChartQuotient H b.1)
    (htransition : ∀ b : NonemptyHypersurfaceChart H,
      hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr b
          (Ideal.Quotient.mk
              (Ideal.span {chartDehomogenization 2 k b.1 H})
              (chartDehomogenization 2 k b.1 P) * s b) =
        hypersurfaceChartQuotientToSchemeFunctionField H hH hd hHirr i
          (Ideal.Quotient.mk
              (Ideal.span {chartDehomogenization 2 k i.1 H})
              (chartDehomogenization 2 k i.1 P) * s i)) :
    HasCompatibleRetainedChartRepresentativesAt H hH hd hHirr i
      (hypersurfaceHomogeneousPolynomialToFunctionField H hH hHirr i P *
        hypersurfaceChartQuotientToFunctionField H hH hHirr i (s i)) := by
  letI : IsIntegral (projectiveZeroLocus 2 k H) :=
    isIntegral_projectiveZeroLocus_of_irreducible H hH hd hHirr
  refine ⟨fun b =>
    Ideal.Quotient.mk
        (Ideal.span {chartDehomogenization 2 k b.1 H})
        (chartDehomogenization 2 k b.1 P) * s b, ?_, htransition⟩
  rw [map_mul]
  rw [hypersurfaceHomogeneousPolynomialToFunctionField_eq_algebraMap_chartDehomogenization]

/-- Coefficientwise compatible representatives for every homogeneous target quadratic supply
the exact family-form gluing datum required by the residual target-relation consumer. -/
theorem targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn_of_compatibleFactors
    {k : Type u} [Field k]
    (M N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hcompat :
      ∀ (H : MvPolynomial (Fin 3) k) (d : ℕ)
        (hHirr : Irreducible H) (hHhom : H.IsHomogeneous d) (hd : 0 < d),
        ∀ (a : Fin 3)
          (R : (b : ProjectiveSpace.NonemptyHypersurfaceChart H) →
            MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b.1)),
          (∀ b : ProjectiveSpace.NonemptyHypersurfaceChart H,
            R b * affineChartEquationOverTargetRelationBase k H a b.1 F =
              affineChartEquationOverTargetRelationBase k H a b.1
                (residualEquationOn M N F)) →
            ∀ (b : ProjectiveSpace.NonemptyHypersurfaceChart H)
              (e : Fin 2 →₀ ℕ) (P : MvPolynomial (Fin 3) k),
              P.IsHomogeneous 2 →
                ProjectiveSpace.HasCompatibleRetainedChartRepresentativesAt
                  H hHhom hd hHirr b
                  (ProjectiveSpace.hypersurfaceHomogeneousPolynomialToFunctionField
                      H hHhom hHirr b P *
                    ProjectiveSpace.hypersurfaceChartQuotientToFunctionField
                      H hHhom hHirr b ((R b).coeff e))) :
    TargetRelationsResidualNegativeTwistGluingAwayDiscriminantOn M N F := by
  intro H d hHabs hHhom hd _hdisc
  have hHirr : Irreducible H := hHabs.irreducible
  refine ⟨fun b =>
    ProjectiveSpace.canonicalGlobalSectionsToHypersurfaceFunctionFieldComparison
      H hHhom hHirr b, ?_⟩
  intro a R hfactor b e
  let s := ProjectiveSpace.hypersurfaceChartQuotientToFunctionField
    H hHhom hHirr b ((R b).coeff e)
  refine
    ProjectiveSpace.quadraticMultiplesExtendToGlobal_of_homogeneousQuadraticMultiplesExtendToGlobal
      H hHhom hHirr b
        (ProjectiveSpace.canonicalGlobalSectionsToHypersurfaceFunctionFieldComparison
          H hHhom hHirr b) s ?_
  refine
    ProjectiveSpace.homogeneousQuadraticMultiplesExtendToGlobal_of_compatibleRetainedChartRepresentatives
      H hHhom hd hHirr b s ?_
  intro P hP
  exact hcompat H d hHirr hHhom hd a R hfactor b e P hP

/-- An intrinsic function-field transition formula for the products `P_b * coeff(R_b)` implies
the full residual negative-twist gluing package. -/
theorem targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn_of_intrinsicTransitions
    {k : Type u} [Field k]
    (M N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (htransition :
      ∀ (H : MvPolynomial (Fin 3) k) (d : ℕ)
        (hHirr : Irreducible H) (hHhom : H.IsHomogeneous d) (hd : 0 < d),
        ∀ (a : Fin 3)
          (R : (b : ProjectiveSpace.NonemptyHypersurfaceChart H) →
            MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b.1)),
          (∀ b : ProjectiveSpace.NonemptyHypersurfaceChart H,
            R b * affineChartEquationOverTargetRelationBase k H a b.1 F =
              affineChartEquationOverTargetRelationBase k H a b.1
                (residualEquationOn M N F)) →
            ∀ (i b : ProjectiveSpace.NonemptyHypersurfaceChart H)
              (e : Fin 2 →₀ ℕ) (P : MvPolynomial (Fin 3) k),
              P.IsHomogeneous 2 →
                ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
                    H hHhom hd hHirr b
                    (Ideal.Quotient.mk
                        (Ideal.span {
                          ProjectiveSpace.chartDehomogenization 2 k b.1 H})
                        (ProjectiveSpace.chartDehomogenization 2 k b.1 P) *
                      (R b).coeff e) =
                  ProjectiveSpace.hypersurfaceChartQuotientToSchemeFunctionField
                    H hHhom hd hHirr i
                    (Ideal.Quotient.mk
                        (Ideal.span {
                          ProjectiveSpace.chartDehomogenization 2 k i.1 H})
                        (ProjectiveSpace.chartDehomogenization 2 k i.1 P) *
                      (R i).coeff e)) :
    TargetRelationsResidualNegativeTwistGluingAwayDiscriminantOn M N F := by
  apply targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn_of_compatibleFactors
  intro H d hHirr hHhom hd a R hfactor i e P hP
  apply
    ProjectiveSpace.hasCompatibleRetainedChartRepresentativesAt_of_quadraticProduct_transition
      H hHhom hd hHirr i P hP (fun b => (R b).coeff e)
  intro b
  exact htransition H d hHirr hHhom hd a R hfactor i b e P hP

/-- Smooth nonzero bidegree-`(2,3)` equations satisfy the residual target negative-twist gluing
property for every pair of frame matrices.

The target relation's discriminant-avoidance hypothesis is not used in the transition
calculation itself.  It remains part of the consumer interface because it supplies projective
integrality and generic-fibre Artinianness elsewhere in the argument. -/
theorem targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn
    {k : Type u} [Field k] [IsAlgClosed k]
    (M N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    TargetRelationsResidualNegativeTwistGluingAwayDiscriminantOn M N F := by
  apply
    targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn_of_intrinsicTransitions
  intro H d hHirr hHhom hd a R hfactor i b e P hP
  exact residualTargetNegativeTwistFactor_coeff_intrinsic_transition
    M N F hF hF0 H hHhom hd hHirr i b a R hfactor e P hP

namespace BiprojectiveSpace

/-- Scheme-theoretic exhaustion of the residual target component implies literal membership
in `(F,H(y))` under the intrinsic negative-twist transition calculation.

Unlike the intermediate generic-fibre theorem, this statement asks for neither a comparison
map nor a chartwise extension hypothesis.  It chooses the local residual factor on every
retained target chart, proves the target-quadratic products compatible from their intrinsic
transition law, and uses uniqueness only to identify an arbitrary local factor with that
chosen family on the same chart. -/
theorem residualEquationOn_mem_span_targetRelation_of_isIso_of_negativeTwist
    {k : Type u} [Field k] [IsAlgClosed k]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (i j : Fin 3) {d : ℕ} (H : MvPolynomial (Fin 3) k)
    (hH : H.IsHomogeneous d) (hd : 0 < d) (hHirr : Irreducible H)
    (hvan : aeval (residualYCoordsOn p₀ q₀ r N F v) H = 0)
    [IsIso (residualTargetComponentOnι
      p₀ q₀ r N hMN F hF v hv i j H hH hvan)] :
    residualEquationOn (lineFrame p₀ q₀ r) N F ∈
      Ideal.span {F, MvPolynomial.rename Sum.inr H} := by
  let comparison :
      (b : ProjectiveSpace.NonemptyHypersurfaceChart H) →
        ProjectiveSpace.GlobalSectionsToHypersurfaceFunctionFieldComparison
          H hH hHirr b :=
    fun b ↦ ProjectiveSpace.canonicalGlobalSectionsToHypersurfaceFunctionFieldComparison
      H hH hHirr b
  let localFactor :
      (a : Fin 3) → (b : ProjectiveSpace.NonemptyHypersurfaceChart H) →
        MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b.1) :=
    fun a b ↦ Classical.choose
      (exists_residualEquationOn_factor_over_targetRelationBase_of_isIso
        p₀ q₀ r N hMN F hF v hv i j H hH hvan a b.1)
  have localFactor_spec (a : Fin 3)
      (b : ProjectiveSpace.NonemptyHypersurfaceChart H) :
      localFactor a b *
          affineChartEquationOverTargetRelationBase k H a b.1 F =
        affineChartEquationOverTargetRelationBase k H a b.1
          (residualEquationOn (lineFrame p₀ q₀ r) N F) :=
    Classical.choose_spec
      (exists_residualEquationOn_factor_over_targetRelationBase_of_isIso
        p₀ q₀ r N hMN F hF v hv i j H hH hvan a b.1)
  exact
    residualEquationOn_mem_span_targetRelation_of_isIso_of_quadraticMultiples_extendToGlobal
      p₀ q₀ r N hMN F hF v hv i j H hH hd hHirr hvan comparison (by
        intro a b R hR e
        have hReq : R = localFactor a b :=
          factor_over_targetRelationBase_unique_of_smooth_irreducible
            F hF hF0 H hH hHirr b a hR (localFactor_spec a b)
        subst R
        let s := ProjectiveSpace.hypersurfaceChartQuotientToFunctionField
          H hH hHirr b ((localFactor a b).coeff e)
        refine
          ProjectiveSpace.quadraticMultiplesExtendToGlobal_of_homogeneousQuadraticMultiplesExtendToGlobal
            H hH hHirr b (comparison b) s ?_
        refine
          ProjectiveSpace.homogeneousQuadraticMultiplesExtendToGlobal_of_compatibleRetainedChartRepresentatives
            H hH hd hHirr b s ?_
        intro P hP
        apply
          ProjectiveSpace.hasCompatibleRetainedChartRepresentativesAt_of_quadraticProduct_transition
            H hH hd hHirr b P hP (fun c ↦ (localFactor a c).coeff e)
        intro c
        exact residualTargetNegativeTwistFactor_coeff_intrinsic_transition
          (lineFrame p₀ q₀ r) N F hF hF0 H hH hd hHirr b c a
            (localFactor a) (localFactor_spec a) e P hP)

end BiprojectiveSpace

/-- The tangent-residual construction under projective integrality of the target relations.
The residual negative-twist gluing law is automatic for a smooth nonzero bidegree-`(2,3)`
equation and is therefore absent from the statement. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_projectivelyIntegralTargetRelations
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hgood : ResidualLineNonconstantOn (lineFrame p₀ q₀ r) N F)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0)
    (havoid : ResidualAvoidsConicDiscriminantOn p₀ q₀ r N F v)
    (hintegral : TargetRelationsProjectivelyIntegralAwayDiscriminant F) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  exact
    hasUnirationalParametrization3_biprojectiveZeroLocus_of_negativeTwistTargetGeometry
      p₀ q₀ r N hMN F hF hF0 hgood v hv0 hv hv2 hpolar havoid hintegral
        (targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn
          (lineFrame p₀ q₀ r) N F hF hF0)

end

end BConicBundleMultisections
