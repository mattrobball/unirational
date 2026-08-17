module

public import V14Formalization.ProjectiveStandardChartAction
public import V14Formalization.ProjectiveFunctionFieldChartReduction

noncomputable section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u
variable {Omega : Type u} [Field Omega]

set_option backward.isDefEq.respectTransparency false in
/-- The function-field pullback of a standard-chart element, evaluated on
the canonical basic open for its transformed denominator. -/
public theorem mapLinearSubst_functionFieldMap_projectiveGeneral_standardChart
    (r : ℕ)
    (M N : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    (hNM : N * M = 1)
    [IsDominant (mapLinearSubst (r + 1) M N hNM)]
    (z : ProjectiveSpace.StandardChartRing (r + 1) Omega 0) :
    let f := mapLinearSubst (r + 1) M N hNM
    let V := AlgebraicGeometry.Proj.basicOpen
      (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
      ((linearSubstGradedRingHom (r + 1) M)
        (MvPolynomial.X (0 : Fin ((r + 1) + 1))))
    f.functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
            (ProjectiveSpace.standardChartRingEquivMvPolynomial
              (r + 1) Omega 0 z))) =
      (ProjectiveSpace (r + 1) Omega).presheaf.germ V
        (genericPoint (ProjectiveSpace (r + 1) Omega))
        (by
          change f (genericPoint (ProjectiveSpace (r + 1) Omega)) ∈
            ProjectiveSpace.standardChart (r + 1) Omega 0
          rw [f.map_genericPoint_of_isDominant]
          exact ((genericPoint_spec
            (ProjectiveSpace (r + 1) Omega)).mem_open_set_iff
              (ProjectiveSpace.standardChart (r + 1) Omega 0).isOpen).mpr
            ⟨ProjectiveSpace.genericPoint (r + 1) Omega,
              ⟨Set.mem_univ _,
                ProjectiveSpace.genericPoint_mem_standardChart
                  (r + 1) Omega 0⟩⟩)
        ((AlgebraicGeometry.Proj.awayToSection
          (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
          ((linearSubstGradedRingHom (r + 1) M)
            (MvPolynomial.X (0 : Fin ((r + 1) + 1)))))
          (HomogeneousLocalization.Away.map
            (linearSubstGradedRingHom (r + 1) M)
            (MvPolynomial.X (0 : Fin ((r + 1) + 1))) z)) := by
  dsimp only
  rw [mapLinearSubst_functionFieldMap_projectiveGeneral_algebraMap]
  let f := mapLinearSubst (r + 1) M N hNM
  let B := ProjectiveSpace.standardChart (r + 1) Omega 0
  let U := (ProjectiveSpace.standardChartι
    (r + 1) Omega 0).opensRange
  let V := AlgebraicGeometry.Proj.basicOpen
    (MvPolynomial.homogeneousSubmodule (Fin ((r + 1) + 1)) Omega)
    ((linearSubstGradedRingHom (r + 1) M)
      (MvPolynomial.X (0 : Fin ((r + 1) + 1))))
  have hB : U = B := ProjectiveSpace.opensRange_standardChartι
    (r + 1) Omega (0 : Fin ((r + 1) + 1))
  have hV : V ≤ f ⁻¹ᵁ B := by rfl
  have hVU : V ≤ f ⁻¹ᵁ U := hB ▸ hV
  let eta := genericPoint (ProjectiveSpace (r + 1) Omega)
  have hetaU : eta ∈ f ⁻¹ᵁ U := by
    change f eta ∈ U
    rw [f.map_genericPoint_of_isDominant]
    exact ((genericPoint_spec (ProjectiveSpace (r + 1) Omega)).mem_open_set_iff
      U.isOpen).mpr (by
        simpa using (inferInstance : Nonempty U))
  have hetaV : eta ∈ V := by
    change f eta ∈ B
    rw [f.map_genericPoint_of_isDominant]
    exact ((genericPoint_spec
      (ProjectiveSpace (r + 1) Omega)).mem_open_set_iff B.isOpen).mpr
      ⟨ProjectiveSpace.genericPoint (r + 1) Omega,
        ⟨Set.mem_univ _, ProjectiveSpace.genericPoint_mem_standardChart
          (r + 1) Omega 0⟩⟩
  let s := (projectiveGeneralGammaEquivMvPolynomial r Omega).symm
    (ProjectiveSpace.standardChartRingEquivMvPolynomial
      (r + 1) Omega 0 z)
  have hres := ((ProjectiveSpace (r + 1) Omega).presheaf.germ_res_apply
    (homOfLE hVU) eta hetaV ((f.app U).hom s)).symm
  have hres' :
      (ProjectiveSpace (r + 1) Omega).presheaf.germ
          (f ⁻¹ᵁ U) eta hetaU ((f.app U).hom s) =
        (ProjectiveSpace (r + 1) Omega).presheaf.germ V eta hetaV
          ((f.appLE U V hVU).hom s) := by
    simpa only [Scheme.Hom.appLE, CommRingCat.comp_apply] using hres
  rw [hres']
  apply congrArg (fun w =>
    (ProjectiveSpace (r + 1) Omega).presheaf.germ V eta hetaV w)
  exact mapLinearSubst_appLE_projectiveGeneralGamma_symm
    r M N hNM z

end V14Formalization.SchemeGeometry
