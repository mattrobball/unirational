import V14Formalization.ProjectiveGammaAwayTransport
import V14Formalization.ProjectiveAwayPullback

noncomputable section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u
variable {Omega : Type u} [Field Omega]

set_option backward.isDefEq.respectTransparency false in
/-- Pulling a canonical standard-chart section back to the basic open where
the transformed denominator is invertible is exactly the graded Away map. -/
theorem mapLinearSubst_appLE_projectiveGeneralGamma_symm
    (r : ℕ)
    (M N : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    (hNM : N * M = 1)
    (z : ProjectiveSpace.StandardChartRing (r + 1) Omega 0) :
    let f := mapLinearSubst (r + 1) M N hNM
    let B := AlgebraicGeometry.Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
      (MvPolynomial.X (0 : Fin ((r + 1) + 1)))
    let V := AlgebraicGeometry.Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
      ((linearSubstGradedRingHom (r + 1) M)
        (MvPolynomial.X (0 : Fin ((r + 1) + 1))))
    let hB := ProjectiveSpace.opensRange_standardChartι
      (r + 1) Omega (0 : Fin ((r + 1) + 1))
    let hV : V ≤ f ⁻¹ᵁ B := by rfl
    (f.appLE
      (ProjectiveSpace.standardChartι (r + 1) Omega 0).opensRange
      V (hB ▸ hV)).hom
        ((projectiveGeneralGammaEquivMvPolynomial r Omega).symm
          (ProjectiveSpace.standardChartRingEquivMvPolynomial
            (r + 1) Omega 0 z)) =
      (AlgebraicGeometry.Proj.awayToSection
        (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
        ((linearSubstGradedRingHom (r + 1) M)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1)))))
        (HomogeneousLocalization.Away.map
          (linearSubstGradedRingHom (r + 1) M)
          (MvPolynomial.X (0 : Fin ((r + 1) + 1))) z) := by
  dsimp only
  rw [projectiveGeneralGammaEquivMvPolynomial_symm_eq_awayToSection]
  let f := mapLinearSubst (r + 1) M N hNM
  let B := AlgebraicGeometry.Proj.basicOpen
    (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
    (MvPolynomial.X (0 : Fin ((r + 1) + 1)))
  let V := AlgebraicGeometry.Proj.basicOpen
    (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
    ((linearSubstGradedRingHom (r + 1) M)
      (MvPolynomial.X (0 : Fin ((r + 1) + 1))))
  let hB := ProjectiveSpace.opensRange_standardChartι
    (r + 1) Omega (0 : Fin ((r + 1) + 1))
  let hV : V ≤ f ⁻¹ᵁ B := by rfl
  have hc := f.map_appLE' hV hB
  have hcz := congrArg (fun q => q.hom
    ((AlgebraicGeometry.Proj.awayToSection
      (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
      (MvPolynomial.X (0 : Fin ((r + 1) + 1)))) z)) hc
  rw [CommRingCat.comp_apply] at hcz
  have hz :
      (ProjectiveSpace.standardChartRingEquivMvPolynomial
        (r + 1) Omega 0).symm
          ((ProjectiveSpace.standardChartRingEquivMvPolynomial
            (r + 1) Omega 0) z) = z :=
    RingEquiv.symm_apply_apply _ z
  have harg := congrArg (fun w =>
    (f.appLE
      (ProjectiveSpace.standardChartι (r + 1) Omega 0).opensRange
      V (hB ▸ hV)).hom
        (((ProjectiveSpace (r + 1) Omega).presheaf.map
          (eqToHom hB).op).hom
          ((AlgebraicGeometry.Proj.awayToSection
            (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
            (MvPolynomial.X (0 : Fin ((r + 1) + 1)))).hom w))) hz
  exact harg.trans (hcz.trans
    (mapLinearSubst_appLE_awayToSection (r + 1) M N hNM z))

end V14Formalization.SchemeGeometry
