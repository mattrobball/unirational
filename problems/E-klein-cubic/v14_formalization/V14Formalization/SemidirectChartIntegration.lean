/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.XAdicSemidirectAction
public import V14Formalization.LinearNormalActionReduction

/-!
# Semidirect normal-chart actions on the geometric function fields

The explicit X-adic semidirect action is conjugated through the checked
function-field charts for P^5 and P^2 x P^2.
-/

noncomputable section

open CategoryTheory CategoryTheory.Limits
open scoped AlgebraicGeometry
open Polynomial IsLocalRing IsDedekindDomain

namespace V14Formalization.SchemeGeometry

open AlgebraicGeometry BConicBundleMultisections Module

universe u v

variable {Omega : Type u} [Field Omega]
  {G : Type u} [Group G]
  {V : Type u} [AddCommGroup V] [Module Omega V]
  {sigma : G}

public abbrev chartSemidirectGroup :=
  (LinearResidualField 5 Omega)ˣ ⋊[
    ringAutUnitsAction (LinearResidualField 5 Omega)]
      (LinearResidualField 5 Omega ≃+* LinearResidualField 5 Omega)

public noncomputable abbrev semidirectChartFractionAction
    (a : centralizer sigma →* chartSemidirectGroup (Omega := Omega)) :
    centralizer sigma →* (LinearNormalFractionField 5 Omega ≃+*
      LinearNormalFractionField 5 Omega) :=
  (xAdicSemidirectRatFuncAction (LinearResidualField 5 Omega)).comp a

noncomputable abbrev semidirectChartValuationAction
    (a : centralizer sigma →* chartSemidirectGroup (Omega := Omega)) :
    centralizer sigma →* (LinearNormalValuationRing 5 Omega ≃+*
      LinearNormalValuationRing 5 Omega) :=
  (xAdicSemidirectValuationAction (LinearResidualField 5 Omega)).comp a

public noncomputable abbrev semidirectChartResidueAction
    (a : centralizer sigma →* chartSemidirectGroup (Omega := Omega)) :
    centralizer sigma →* (LinearExceptionalFunctionField 5 Omega ≃+*
      LinearExceptionalFunctionField 5 Omega) :=
  SemidirectProduct.rightHom.comp a

/-- Transport the semidirect chart actions to the two actual geometric
function fields. -/
public noncomputable abbrev semidirectProjectiveFiveFunctionFieldAction
    (a : centralizer sigma →* chartSemidirectGroup (Omega := Omega)) :
    centralizer sigma →*
      ((ProjectiveSpace 5 Omega).functionField ≃+*
        (ProjectiveSpace 5 Omega).functionField) :=
  conjugateRingAction
    (projectiveFiveLinearNormalFunctionFieldEquiv Omega).symm
    (semidirectChartFractionAction a)

public noncomputable abbrev semidirectBiprojectiveTwoTwoFunctionFieldAction
    (a : centralizer sigma →* chartSemidirectGroup (Omega := Omega)) :
    centralizer sigma →*
      ((BiprojectiveSpace 2 2 Omega).functionField ≃+*
        (BiprojectiveSpace 2 2 Omega).functionField) :=
  conjugateRingAction
    (biprojectiveTwoTwoFunctionFieldEquiv Omega).symm
    (semidirectChartResidueAction a)

public theorem semidirectProjectiveFive_chartModel
    (a : centralizer sigma →* chartSemidirectGroup (Omega := Omega)) :
    projectiveFiveChartModelAction
        (semidirectProjectiveFiveFunctionFieldAction a) =
      semidirectChartFractionAction a := by
  ext n x
  simp [projectiveFiveChartModelAction,
    semidirectProjectiveFiveFunctionFieldAction,
    semidirectChartFractionAction, conjugateRingAction]

public theorem semidirectBiprojectiveTwoTwo_chartModel
    (a : centralizer sigma →* chartSemidirectGroup (Omega := Omega)) :
    biprojectiveTwoTwoChartModelAction
        (semidirectBiprojectiveTwoTwoFunctionFieldAction a) =
      semidirectChartResidueAction a := by
  ext n x
  simp [biprojectiveTwoTwoChartModelAction,
    semidirectBiprojectiveTwoTwoFunctionFieldAction,
    semidirectChartResidueAction, conjugateRingAction]

end V14Formalization.SchemeGeometry

