module

public import V14Formalization.ProjectiveFamilyNaturality

noncomputable section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u

variable {Omega : Type u} [Field Omega]

/-- Pullback by a projective linear substitution on an arbitrary degree-zero
homogeneous-localization element.  This is the canonical `Proj` chart square;
the matrix occurs with the same (row) orientation as `mapLinearSubst`. -/
public theorem mapLinearSubst_appLE_awayToSection
    (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) Omega)
    (hNM : N * M = 1)
    (z : ProjectiveSpace.StandardChartRing n Omega 0) :
    ((mapLinearSubst n M N hNM).appLE
      (AlgebraicGeometry.Proj.basicOpen
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega)
        (MvPolynomial.X (0 : Fin (n + 1))))
      (AlgebraicGeometry.Proj.basicOpen
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega)
        ((linearSubstGradedRingHom n M)
          (MvPolynomial.X (0 : Fin (n + 1))))) (by rfl)).hom
        ((AlgebraicGeometry.Proj.awayToSection
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega)
          (MvPolynomial.X (0 : Fin (n + 1)))) z) =
      (AlgebraicGeometry.Proj.awayToSection
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega)
        ((linearSubstGradedRingHom n M)
          (MvPolynomial.X (0 : Fin (n + 1)))))
        (HomogeneousLocalization.Away.map
          (linearSubstGradedRingHom n M)
          (MvPolynomial.X (0 : Fin (n + 1))) z) := by
  have h := AlgebraicGeometry.Proj.awayToSection_comp_appLE
    (linearSubstGradedRingHom n M)
    (irrelevant_le_map_linearSubst n M N hNM)
    (MvPolynomial.isHomogeneous_X Omega (0 : Fin (n + 1)))
  exact congrArg (fun q => q.hom z) h

/-- On a standard normalized homogeneous coordinate, the preceding Away map
is literally the quotient of the corresponding matrix row by row zero. -/
public theorem awayMap_linearSubst_normalizedCoordinate
    (n : ℕ)
    (M : Matrix (Fin (n + 1)) (Fin (n + 1)) Omega)
    (i : Fin (n + 1)) :
    HomogeneousLocalization.Away.map
        (linearSubstGradedRingHom n M)
        (MvPolynomial.X (0 : Fin (n + 1)))
        (ProjectiveSpace.normalizedCoordinate n Omega 0 i) =
      HomogeneousLocalization.Away.mk
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) Omega)
        (GradedRingHom.map_mem (linearSubstGradedRingHom n M)
          (MvPolynomial.isHomogeneous_X Omega (0 : Fin (n + 1))))
        1 (linearSubst n M i) (by
          simpa using isHomogeneous_linearSubst n M i) := by
  unfold ProjectiveSpace.normalizedCoordinate
  rw [HomogeneousLocalization.Away.map_mk]
  simp only [linearSubstGradedRingHom_X]

end V14Formalization.SchemeGeometry
