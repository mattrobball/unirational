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

/-! ## The closure-free core

Both projective target inputs of the tangent-residual construction — retained-chart integrality
and the degree `-2` gluing law — are automatic from smoothness over an arbitrary field.  What the
construction still genuinely needs of the base field is only that it carry *one* line with the
good-line property together with a nondegenerate Tsen section of that line's generic conic.  Over
an algebraically closed field the frame-incidence argument produces such a line; over a general
field its existence is a hypothesis, and nothing else is.
-/

/-- **Closure-free assembly.**  A smooth nonzero bidegree-`(2,3)` hypersurface over a perfect
field of characteristic prime to `6` is unirational as soon as *one* framed line carries G3, a
nondegenerate Tsen section, and G4.

No algebraic closure is used: retained-chart projective integrality
(`targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth`) and the residual negative-twist
gluing law (`targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn`) are both supplied
from smoothness over the given field. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_actualG3G4LineSection
    (k : Type u) [Field k] [PerfectField k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
    (v : Fin 3 → Polynomial k)
    (hactual : Standard.HasActualG3G4LineSection F p q r N v) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  rcases hactual with ⟨hMN, hgood, hsection, havoid⟩
  rcases hsection with ⟨hv0, hv, hv2, hpolar⟩
  exact
    hasUnirationalParametrization3_biprojectiveZeroLocus_of_negativeTwistTargetGeometry
      p q r N hMN F hF hF0 hgood v hv0 hv hv2
        (by simpa [lineStereoPolarForm] using hpolar) havoid
        (targetRelationsProjectivelyIntegralAwayDiscriminant_of_smooth F hF hF0)
        (targetRelationsResidualNegativeTwistGluingAwayDiscriminantOn
          (lineFrame p q r) N F hF hF0)

/-- Existential form of the closure-free assembly: the sole hypothesis on the base field beyond
perfectness and characteristic prime to `6` is that *some* good framed line with a nondegenerate
Tsen section exists over `k`. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_exists_actualG3G4LineSection
    (k : Type u) [Field k] [PerfectField k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)]
    (hline : ∃ (p q r : Fin 3 → k) (N : Matrix (Fin 3) (Fin 3) k)
      (v : Fin 3 → Polynomial k), Standard.HasActualG3G4LineSection F p q r N v) :
    HasUnirationalParametrization 3 (biprojectiveZeroLocusToSpec 2 2 k F) := by
  obtain ⟨p, q, r, N, v, hactual⟩ := hline
  exact hasUnirationalParametrization3_biprojectiveZeroLocus_of_actualG3G4LineSection
    k F hF hF0 p q r N v hactual

/-- The main tangent-residual construction, reduced only to the two uniform projective target
properties.  The selected framed line already satisfies G3, section nondegeneracy, and G4.

Retained as a reduction statement: it consumes the two target properties as hypotheses rather
than producing them, and so remains meaningful independently of the automatic producers. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus_of_uniformTargetGeometry
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
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
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
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

This is now a *specialization* of the closure-free assembly
`hasUnirationalParametrization3_biprojectiveZeroLocus_of_exists_actualG3G4LineSection`: an
algebraically closed field is perfect, and the frame-incidence argument supplies the one
remaining input, a good framed line carrying a nondegenerate Tsen section. -/
theorem hasUnirationalParametrization3_biprojectiveZeroLocus
    (k : Type u) [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    HasUnirationalParametrization 3
      (biprojectiveZeroLocusToSpec 2 2 k F) := by
  apply
    hasUnirationalParametrization3_biprojectiveZeroLocus_of_exists_actualG3G4LineSection
      k F hF hF0
  obtain ⟨p, q, r, N, _x, v, _u, hactual, _⟩ :=
    Standard.exists_actualG3G4LineSection_via_frameIncidence F hF hF0
  exact ⟨p, q, r, N, v, hactual⟩

end

end BConicBundleMultisections

end
