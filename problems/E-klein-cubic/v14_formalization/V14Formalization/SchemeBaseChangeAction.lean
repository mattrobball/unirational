/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import Mathlib.CategoryTheory.Action.Basic
public import Mathlib.CategoryTheory.Comma.Over.Pullback
public import Mathlib.AlgebraicGeometry.Limits

/-!
# Base change of actions on relative schemes
-/

noncomputable section

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry

universe u v

variable {G : Type v} [Group G]
variable {S T : Scheme.{u}}

/-- Pull back every object and action morphism along a base morphism.  This is
the ordinary categorical base change functor on the slice, applied to a
bundled action. -/
@[expose] public def baseChangeAction (f : T ⟶ S) (A : Action (Over S) G) :
    Action (Over T) G :=
  ((Over.pullback f).mapAction G).obj A

@[simp]
theorem baseChangeAction_V_left (f : T ⟶ S) (A : Action (Over S) G) :
    (baseChangeAction f A).V.left = pullback A.V.hom f :=
  rfl

@[simp]
theorem baseChangeAction_V_hom (f : T ⟶ S) (A : Action (Over S) G) :
    (baseChangeAction f A).V.hom = pullback.snd A.V.hom f :=
  rfl

end SchemeGeometry
end V14Formalization
