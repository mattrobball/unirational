/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.V14SchemeModel
public import V14Formalization.SchemeBaseChangeAction

/-!
# Base change of the genuine V14 scheme action

The coordinate V14 over the cyclotomic field is a closed subscheme of
projective space and hence proper.  This file packages its genuine group
action after an arbitrary field extension and records properness of the
base-changed structure morphism.
-/

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry

namespace V14Formalization
namespace V14SchemeModel

open AlgebraicGeometry SchemeGeometry

/-- The coordinate V14 is proper over its cyclotomic base field. -/
@[expose] public instance actionOver_isProper : IsProper actionOver.V.hom := by
  change IsProper
    (projectiveZeroLocusFamilyι 14 k
      (grassmannianLinearSectionEquations k projectorMatrix) ≫
      BConicBundleMultisections.ProjectiveSpace.toSpec 14 k)
  infer_instance

variable (Omega : Type) [Field Omega] [Algebra k Omega]

/-- The genuine V14 action after extending scalars from `k` to `Omega`. -/
@[expose] public def actionOverBaseChange : Action (Over (Spec (.of Omega))) G :=
  baseChangeAction
    (Spec.map (CommRingCat.ofHom (algebraMap k Omega))) actionOver

@[simp]
public theorem actionOverBaseChange_carrier :
    (actionOverBaseChange Omega).V.left =
      pullback actionOver.V.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k Omega))) := rfl

@[simp]
theorem actionOverBaseChange_toSpec :
    (actionOverBaseChange Omega).V.hom =
      pullback.snd actionOver.V.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k Omega))) := rfl

/-- Properness survives the field extension. -/
@[expose] public instance actionOverBaseChange_isProper :
    IsProper (actionOverBaseChange Omega).V.hom := by
  change IsProper (pullback.snd actionOver.V.hom
    (Spec.map (CommRingCat.ofHom (algebraMap k Omega))))
  infer_instance

end V14SchemeModel
end V14Formalization
