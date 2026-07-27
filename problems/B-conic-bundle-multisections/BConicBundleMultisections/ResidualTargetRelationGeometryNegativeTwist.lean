/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualTargetNegativeTwistGenericFiber
public import BConicBundleMultisections.ResidualTargetNegativeTwistQuotientUniqueness
public import BConicBundleMultisections.ResidualTargetRelationGeometryAutomaticArtinian

/-!
# Projective negative twist in the target-relation geometry consumer

This module replaces the raw Cox-radical hypothesis in `ResidualTargetRelationGeometry` by the
projectively meaningful remaining datum: local quotients of target degree `-2` have
coefficientwise target-quadratic multiples which glue to global functions on the irreducible
projective target curve.

Scheme-theoretic exhaustion supplies the local factorizations.  The generic-function-field
negative-twist theorem kills their coefficients, chartwise vanishing descends through the prime
vertical ideal `(H(y))`, and the result is the exact literal membership in `(F,H(y))` required by
the residual discriminant argument.  Generic-fibre Artinianness is supplied automatically from
bidegree `(2,3)` and discriminant avoidance.
-/

@[expose] public section

open CategoryTheory Topology TopologicalSpace
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry BiprojectiveSpace
open _root_.MvPolynomial

/-- The exact projective gluing datum still needed for the residual negative-twist argument.

For every irreducible positive-degree target relation away from the discriminant, a compatible
family of local quotients of the residual `(10,1)` equation by the conic `(2,3)` equation has
coefficients whose target-quadratic multiples extend globally.  Scheme-theoretic exhaustion
supplies the whole family simultaneously.  Its members represent one rational section of
`O(-2)` on the projective target curve; multiplying by a target quadratic gives ordinary regular
functions which glue.

Quantifying over the family is essential.  A quotient which is regular on one affine chart alone
does not, by itself, contain the data needed to assert regularity on every other chart. -/
def TargetRelationsResidualNegativeTwistGluingAwayDiscriminantOn
    {k : Type u} [Field k]
    (M N : Matrix (Fin 3) (Fin 3) k)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : Prop :=
  ∀ (H : MvPolynomial (Fin 3) k) (d : ℕ),
    ∀ (hHirr : Irreducible H) (hHhom : H.IsHomogeneous d) (_hd : 0 < d),
      ∀ (_hdisc : ¬ H ∣ sndConicDiscriminant F),
        ∃ comparison :
            (b : ProjectiveSpace.NonemptyHypersurfaceChart H) →
              ProjectiveSpace.GlobalSectionsToHypersurfaceFunctionFieldComparison
                H hHhom hHirr b,
          ∀ (a : Fin 3)
              (R : (b : ProjectiveSpace.NonemptyHypersurfaceChart H) →
                MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b.1)),
            (∀ b : ProjectiveSpace.NonemptyHypersurfaceChart H,
              R b * affineChartEquationOverTargetRelationBase k H a b.1 F =
                affineChartEquationOverTargetRelationBase k H a b.1
                  (residualEquationOn M N F)) →
              ∀ (b : ProjectiveSpace.NonemptyHypersurfaceChart H)
                  (e : Fin 2 →₀ ℕ),
                ProjectiveSpace.QuadraticMultiplesExtendToGlobal
                  H hHhom hHirr b (comparison b)
                  (ProjectiveSpace.hypersurfaceChartQuotientToFunctionField
                    H hHhom hHirr b ((R b).coeff e))

/-- Projective integrality plus negative-twist gluing imply the exact residual target-relation
membership package.  No reducedness hypothesis on the affine complete-intersection cone is
used, and generic-fibre Artinianness is automatic. -/
theorem residualTargetRelationMembershipAwayDiscriminantOn_of_negativeTwistGeometry
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (p₀ q₀ r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (hMN : lineFrame p₀ q₀ r * N = 1)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval (lineTernaryQuadraticPoly p₀ q₀ F) v = 0)
    (hv2 : v 2 ≠ 0)
    (hpolar : lineStereoPolarForm p₀ q₀ F v ≠ 0)
    (hintegral : TargetRelationsProjectivelyIntegralAwayDiscriminant F)
    (hglue : TargetRelationsResidualNegativeTwistGluingAwayDiscriminantOn
      (lineFrame p₀ q₀ r) N F) :
    ResidualTargetRelationMembershipAwayDiscriminantOn p₀ q₀ r N F v := by
  have hX : stereoFirstCoordsOn p₀ q₀ F v ≠ 0 :=
    stereoFirstCoordsOn_ne_zero_of_polar p₀ q₀ F hF v hv (by
      simpa [lineStereoPolarForm] using hpolar)
  have hY : residualYCoordsOn p₀ q₀ r N F v ≠ 0 :=
    residualYCoordsOn_ne_zero_of_smooth_transport
      p₀ q₀ r N hMN F hF hF0 v hv0 hv hv2 hpolar
  obtain ⟨i, j, hdenom⟩ :=
    exists_residualComponentOnDenom_ne_zero p₀ q₀ r N F v hX hY
  intro H d hHirr hHhom hd hvan hdisc
  letI : IsIntegral (targetRelationZeroLocus F H) :=
    hintegral H d hHirr hHhom hd hdisc
  have hdom : IsDominant
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hHhom hvan) :=
    isDominant_residualTargetComponentOnToFirst_of_smooth
      p₀ q₀ r N hMN F hF hF0 v hv hv2 i j hdenom H hHhom hvan
  letI : Surjective
      (residualTargetComponentOnToFirst
        p₀ q₀ r N hMN F hF v hv i j H hHhom hvan) :=
    surjective_residualTargetComponentOnToFirst
      p₀ q₀ r N hMN F hF v hv i j H hHhom hvan hdom
  letI : IsLocallyArtinian
      ((targetRelationToFirst F H).fiber
        (genericPoint (ProjectiveSpace 2 k))) :=
    targetRelation_genericFiber_isLocallyArtinian_of_irreducible_not_dvd_discriminant
      F hF H hHhom hd hHirr hdisc 0
  letI : IsIso
      (residualTargetComponentOnι
        p₀ q₀ r N hMN F hF v hv i j H hHhom hvan) :=
    TargetRelationGenericFiber.residualTargetComponentOnι_isIso_of_isLocallyArtinian_genericFiber
      p₀ q₀ r N hMN F hF v hv i j H hHhom hvan
  obtain ⟨comparison, hext⟩ :=
    hglue H d hHirr hHhom hd hdisc
  let localFactor :
      (a : Fin 3) → (b : ProjectiveSpace.NonemptyHypersurfaceChart H) →
        MvPolynomial (Fin 2) (targetRelationBaseChartRing k H b.1) :=
    fun a b ↦ Classical.choose
      (exists_residualEquationOn_factor_over_targetRelationBase_of_isIso
        p₀ q₀ r N hMN F hF v hv i j H hHhom hvan a b.1)
  have localFactor_spec (a : Fin 3)
      (b : ProjectiveSpace.NonemptyHypersurfaceChart H) :
      localFactor a b *
          affineChartEquationOverTargetRelationBase k H a b.1 F =
        affineChartEquationOverTargetRelationBase k H a b.1
          (residualEquationOn (lineFrame p₀ q₀ r) N F) :=
    Classical.choose_spec
      (exists_residualEquationOn_factor_over_targetRelationBase_of_isIso
        p₀ q₀ r N hMN F hF v hv i j H hHhom hvan a b.1)
  exact residualEquationOn_mem_span_targetRelation_of_isIso_of_quadraticMultiples_extendToGlobal
    p₀ q₀ r N hMN F hF v hv i j H hHhom hd hHirr hvan comparison (by
      intro a b R hR e
      have hReq : R = localFactor a b :=
        factor_over_targetRelationBase_unique_of_smooth_irreducible
          F hF hF0 H hHhom hHirr b a hR (localFactor_spec a b)
      subst R
      exact hext a (localFactor a) (localFactor_spec a) b e)

/-- Full tangent-residual consumer under projective target integrality and the negative-twist
gluing property.  Both the generic-fibre Artinianness and the Cox-radical hypotheses have
disappeared from the statement. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_negativeTwistTargetGeometry
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
    (hintegral : TargetRelationsProjectivelyIntegralAwayDiscriminant F)
    (hglue : TargetRelationsResidualNegativeTwistGluingAwayDiscriminantOn
      (lineFrame p₀ q₀ r) N F) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  have hmembership :
      ResidualTargetRelationMembershipAwayDiscriminantOn p₀ q₀ r N F v :=
    residualTargetRelationMembershipAwayDiscriminantOn_of_negativeTwistGeometry
      p₀ q₀ r N hMN F hF hF0 v hv0 hv hv2 hpolar hintegral hglue
  exact hasUnirationalParametrization3_biprojectiveZeroLocus_of_membershipAwayDiscriminant
    p₀ q₀ r N hMN F hF hF0 v hv hpolar hgood havoid hmembership

end

end BConicBundleMultisections
