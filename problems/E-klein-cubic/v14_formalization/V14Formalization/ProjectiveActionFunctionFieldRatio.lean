import V14Formalization.ProjectiveFunctionFieldRatio
import V14Formalization.SchemeProjectiveAction

noncomputable section

open CategoryTheory TopologicalSpace
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

universe u v
variable {Omega : Type u} [Field Omega]
  {G : Type v} [Group G]

local instance projectiveActionOver_isIntegral
    (d : ℕ) (R : MatrixRepresentation (k := Omega) (G := G) d) :
    IsIntegral (projectiveActionOver d R).V.left := by
  change IsIntegral (ProjectiveSpace d Omega)
  infer_instance

/-- The canonical function-field action of a projective matrix representation
has the expected row-ratio formula on the standard affine generators. -/
theorem projectiveActionOver_actionFunctionFieldMap_X
    (r : ℕ) (R : MatrixRepresentation (k := Omega) (G := G) (r + 1))
    (g : G) (j : Fin (r + 1)) :
    let e := projectiveGeneralFunctionFieldEquiv r Omega
    let K := FractionRing (MvPolynomial (Fin (r + 1)) Omega)
    let M := (↑(R g) : Matrix (Fin ((r + 1) + 1))
      (Fin ((r + 1) + 1)) Omega)
    (Scheme.actionFunctionFieldMap (projectiveActionOver (r + 1) R) g).hom
        (e (algebraMap (MvPolynomial (Fin (r + 1)) Omega) K
          (MvPolynomial.X j))) =
      e (algebraMap (MvPolynomial (Fin (r + 1)) Omega) K
          (ProjectiveSpace.chartDehomogenization (r + 1) Omega 0
            (linearSubst (r + 1) M
              ((0 : Fin ((r + 1) + 1)).succAbove j)))) /
        e (algebraMap (MvPolynomial (Fin (r + 1)) Omega) K
          (ProjectiveSpace.chartDehomogenization (r + 1) Omega 0
            (linearSubst (r + 1) M 0))) := by
  dsimp only
  let M := (↑(R g) : Matrix (Fin ((r + 1) + 1))
    (Fin ((r + 1) + 1)) Omega)
  let N := (↑((R g)⁻¹) : Matrix (Fin ((r + 1) + 1))
    (Fin ((r + 1) + 1)) Omega)
  have hNM : N * M = 1 := by simp [M, N]
  have hMN : M * N = 1 := by simp [M, N]
  let e := mapLinearSubstIso (r + 1) M N hNM hMN
  letI : IsIso (mapLinearSubst (r + 1) M N hNM) := e.isIso_hom
  letI : IsDominant (mapLinearSubst (r + 1) M N hNM) := inferInstance
  letI : IsIso (projectiveActionHom R g) := by
    change IsIso (mapLinearSubst (r + 1)
      (↑(R g) : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
      (↑((R g)⁻¹) : Matrix (Fin ((r + 1) + 1)) (Fin ((r + 1) + 1)) Omega)
      (by simp))
    change IsIso (mapLinearSubst (r + 1) M N hNM)
    infer_instance
  letI : IsDominant (projectiveActionHom R g) := inferInstance
  change (projectiveActionHom R g).functionFieldMap
      (projectiveGeneralFunctionFieldEquiv r Omega
        (algebraMap (MvPolynomial (Fin (r + 1)) Omega)
          (FractionRing (MvPolynomial (Fin (r + 1)) Omega))
          (MvPolynomial.X j))) = _
  unfold projectiveActionHom
  simpa only [M, N] using
    (mapLinearSubst_functionFieldMap_projectiveGeneral_X r M N hNM j)

end V14Formalization.SchemeGeometry
