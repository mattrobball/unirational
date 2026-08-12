import V14Formalization.StandardChartAwayTransport

noncomputable section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u
variable {Omega : Type u} [Field Omega]

set_option backward.isDefEq.respectTransparency false in
theorem projectiveGeneralGammaEquivMvPolynomial_symm_eq_awayToSection
    (r : ℕ) (P : MvPolynomial (Fin (r + 1)) Omega) :
    (projectiveGeneralGammaEquivMvPolynomial r Omega).symm P =
      (ProjectiveSpace (r + 1) Omega).presheaf.map
        (eqToHom (ProjectiveSpace.opensRange_standardChartι
          (r + 1) Omega (0 : Fin ((r + 1) + 1)))).op
        ((AlgebraicGeometry.Proj.awayToSection
          (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1))))
          ((ProjectiveSpace.standardChartRingEquivMvPolynomial
            (r + 1) Omega 0).symm P)) := by
  change
    (IsOpenImmersion.ΓIsoTop
      (ProjectiveSpace.standardChartι (r + 1) Omega 0)).hom
        ((Scheme.ΓSpecIso (.of
          (ProjectiveSpace.StandardChartRing (r + 1) Omega 0))).inv
          ((ProjectiveSpace.standardChartRingEquivMvPolynomial
            (r + 1) Omega 0).symm P)) = _
  exact standardChartGammaIsoTop_hom_GammaSpecIso_inv r _

end V14Formalization.SchemeGeometry
