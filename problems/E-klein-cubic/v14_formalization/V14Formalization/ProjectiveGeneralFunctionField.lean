import V14Formalization.GenericCharts
import V14Formalization.SchemeFunctionFieldPrecomp
import V14Formalization.ProjectiveFamilyNaturality

noncomputable section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u

variable {Omega : Type u} [Field Omega]

theorem projectiveGeneralFunctionFieldEquiv_algebraMap
    (r : ℕ) (P : MvPolynomial (Fin (r + 1)) Omega) :
    projectiveGeneralFunctionFieldEquiv r Omega
        (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
          (FractionRing (MvPolynomial (Fin (r + 1)) Omega)) P) =
      (ProjectiveSpace (r + 1) Omega).germToFunctionField
        ((ProjectiveSpace.standardChartι (r + 1) Omega 0).opensRange)
        ((projectiveGeneralGammaEquivMvPolynomial r Omega).symm P) := by
  simp [projectiveGeneralFunctionFieldEquiv,
    projectiveGeneralFunctionFieldAlgEquiv]
  rfl

end V14Formalization.SchemeGeometry
