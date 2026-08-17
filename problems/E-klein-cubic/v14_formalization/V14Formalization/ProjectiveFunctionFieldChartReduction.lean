module

public import V14Formalization.SchemeFunctionFieldNaturality
public import V14Formalization.ProjectiveGeneralFunctionField
public import V14Formalization.ProjectiveAwayPullback

noncomputable section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u

variable {Omega : Type u} [Field Omega]

/-- The canonical function-field pullback along a projective linear
automorphism, reduced to its map on the chosen standard-chart section.  No
chart-compatibility assumption occurs here. -/
public theorem mapLinearSubst_functionFieldMap_projectiveGeneral_algebraMap
    (r : ℕ)
    (M N : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
    (hNM : N * M = 1)
    [IsDominant (mapLinearSubst (r + 1) M N hNM)]
    (P : MvPolynomial (Fin (r + 1)) Omega) :
    let f := mapLinearSubst (r + 1) M N hNM
    f.functionFieldMap
        (projectiveGeneralFunctionFieldEquiv r Omega
          (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
            (FractionRing (MvPolynomial (Fin (r + 1)) Omega)) P)) =
      (ProjectiveSpace (r + 1) Omega).presheaf.germ
        (f ⁻¹ᵁ (ProjectiveSpace.standardChartι
          (r + 1) Omega 0).opensRange)
        (genericPoint (ProjectiveSpace (r + 1) Omega))
        (by
          rw [Scheme.Hom.mem_preimage]
          rw [f.map_genericPoint_of_isDominant]
          exact ((genericPoint_spec (ProjectiveSpace (r + 1) Omega)).mem_open_set_iff
            (ProjectiveSpace.standardChartι
              (r + 1) Omega 0).opensRange.isOpen).mpr
              (by simpa using (inferInstance : Nonempty
                (ProjectiveSpace.standardChartι
                  (r + 1) Omega 0).opensRange)))
        (f.app ((ProjectiveSpace.standardChartι
          (r + 1) Omega 0).opensRange)
          ((projectiveGeneralGammaEquivMvPolynomial r Omega).symm P)) := by
  dsimp only
  rw [projectiveGeneralFunctionFieldEquiv_algebraMap]
  exact AlgebraicGeometry.Scheme.Hom.functionFieldMap_germToFunctionField
    (mapLinearSubst (r + 1) M N hNM)
    ((ProjectiveSpace.standardChartι (r + 1) Omega 0).opensRange)
    ((projectiveGeneralGammaEquivMvPolynomial r Omega).symm P)

end V14Formalization.SchemeGeometry
