/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualTargetRelationGeometry
public import BConicBundleMultisections.TargetRelationGenericGlobalCoprimalityFromDiscriminant

/-!
# Automatic generic-fibre Artinianness in the target-relation consumer

For a bidegree `(2,3)` equation, an irreducible positive-degree target relation which avoids the
second-conic discriminant automatically has locally Artinian generic fibre over the first
projective plane.  This module installs that theorem in the uniform interface used by
`ResidualTargetRelationGeometry` and records consumer variants which no longer ask for a
separate Artinianness hypothesis.

The projective-integrality and Cox-reducedness inputs are deliberately left unchanged here.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry BiprojectiveSpace

/-- Bidegree `(2,3)` and discriminant avoidance automatically supply the uniform generic-fibre
Artinianness property used by the residual target-geometry consumer. -/
theorem targetRelationsGenericFiberArtinianAwayDiscriminant_of_bidegree23
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) :
    TargetRelationsGenericFiberArtinianAwayDiscriminant F := by
  intro H d hHabs hHhom hd hdisc
  exact
    targetRelation_genericFiber_isLocallyArtinian_of_irreducible_not_dvd_discriminant
      F hF H hHhom hd hHabs.irreducible hdisc 0

/-- Projective integrality and Cox reducedness imply residual target-relation membership; the
generic-fibre Artinianness hypothesis is automatic from bidegree and discriminant avoidance. -/
theorem residualTargetRelationMembershipAwayDiscriminantOn_of_reducedGeometry_autoArtinian
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
    (hradical : TargetRelationsCoxRadicalAwayDiscriminant F) :
    ResidualTargetRelationMembershipAwayDiscriminantOn p₀ q₀ r N F v := by
  exact residualTargetRelationMembershipAwayDiscriminantOn_of_reducedGeometry
    p₀ q₀ r N hMN F hF hF0 v hv0 hv hv2 hpolar hintegral
      (targetRelationsGenericFiberArtinianAwayDiscriminant_of_bidegree23 F hF)
      hradical

/-- Full residual target-geometry consumer with the generic-fibre Artinianness input discharged
automatically. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_targetRelationGeometry_autoArtinian
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
    (hradical : TargetRelationsCoxRadicalAwayDiscriminant F) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  exact hasUnirationalParametrization3_biprojectiveZeroLocus_of_targetRelationGeometry
    p₀ q₀ r N hMN F hF hF0 hgood v hv0 hv hv2 hpolar havoid hintegral
      (targetRelationsGenericFiberArtinianAwayDiscriminant_of_bidegree23 F hF)
      hradical

end

end BConicBundleMultisections
