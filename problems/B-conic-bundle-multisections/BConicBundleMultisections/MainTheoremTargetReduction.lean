/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.Standard.G3FrameIncidenceSelection
public import BConicBundleMultisections.ResidualTargetNegativeTwistAutomaticGluing
public import BConicBundleMultisections.ResidualTargetRelationGeometryNegativeTwist
public import BConicBundleMultisections.TargetRelationTotalSpaceIntegral

/-!
# Main theorem reduced to automatic projective target geometry

The frame-incidence argument supplies one actual line carrying G3, a nondegenerate Tsen section,
and G4 simultaneously.  Consequently the headline theorem follows once target relations away
from the conic discriminant are projectively integral and the local residual quotients satisfy
their canonical degree `-2` gluing law.

This theorem is the fixed assembly point for those two projective target calculations.  It has
the exact headline conclusion and introduces no choice of line, section, or auxiliary geometric
hypothesis beyond the two target properties which the following modules prove automatically.
-/

@[expose] public section

open scoped AlgebraicGeometry Matrix

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry BiprojectiveSpace

/-- The main tangent-residual construction, reduced only to the two uniform projective target
properties.  The selected framed line already satisfies G3, section nondegeneracy, and G4. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_uniformTargetGeometry
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hintegral : TargetRelationsProjectivelyIntegralAwayDiscriminant F)
    (hglue : ∀ (M N : Matrix (Fin 3) (Fin 3) k),
      TargetRelationsResidualNegativeTwistGluingAwayDiscriminantOn M N F) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  obtain ⟨p, q, r, N, _x, v, _u, hactual, _⟩ :=
    Standard.exists_actualG3G4LineSection_via_frameIncidence F hF hF0
  rcases hactual with ⟨hMN, hgood, hsection, havoid⟩
  rcases hsection with ⟨hv0, hv, hv2, hpolar⟩
  exact
    hasUnirationalParametrization3_biprojectiveZeroLocus_of_negativeTwistTargetGeometry
      p q r N hMN F hF hF0 hgood v hv0 hv hv2
        (by simpa [lineStereoPolarForm] using hpolar) havoid hintegral
        (hglue (lineFrame p q r) N)

/-- After the retained-chart integrality theorem, uniform negative-twist gluing is the only
remaining projective target input to the main tangent-residual construction. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_uniformNegativeTwistGluing
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hglue : ∀ (M N : Matrix (Fin 3) (Fin 3) k),
      TargetRelationsResidualNegativeTwistGluingAwayDiscriminantOn M N F) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) :=
  hasUnirationalParametrization3_biprojectiveZeroLocus_of_uniformTargetGeometry
    k F hF hF0
      (targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth F hF hF0) hglue

/-- Every smooth nonzero bidegree-`(2,3)` hypersurface in `ℙ² × ℙ²` over an algebraically closed
field of characteristic zero admits a unirational parametrization by affine `3`-space.

The retained-chart integrality and negative-twist gluing inputs of the target-reduction theorem
are both automatic under these headline assumptions. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus
    (k : Type u) [Field k] [IsAlgClosed k] [CharZero k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    HasUnirationalParametrization 3
      (biprojectiveZeroLocusToSpec 2 2 k F) := by
  apply
    hasUnirationalParametrization3_biprojectiveZeroLocus_of_uniformNegativeTwistGluing
      k F hF hF0
  intro M N
  exact targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn
    M N F hF hF0

end

end BConicBundleMultisections

end
