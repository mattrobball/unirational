/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.SchemeEquivariant
import Mathlib.AlgebraicGeometry.IdealSheaf.Functorial

/-!
# Restricting scheme actions to invariant closed subschemes
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry

universe u v

variable {G : Type v} [Group G]

/-- An ideal sheaf is invariant when every action morphism restricts to
its associated closed subscheme.  The reverse inclusion follows by applying
the condition to the inverse group element, but is not needed to construct
the restricted action. -/
structure IsInvariantIdeal (A : Action Scheme G)
    (I : A.V.IdealSheafData) : Prop where
  le_map : ∀ g : G, I ≤ I.map (A.ρ g)

namespace IsInvariantIdeal

variable {A : Action Scheme G} {I : A.V.IdealSheafData}

/-- The pullback-of-equations formulation of invariance. -/
theorem of_comap_le (h : ∀ g : G, I.comap (A.ρ g) ≤ I) :
    IsInvariantIdeal A I where
  le_map g := Scheme.IdealSheafData.le_map_iff_comap_le.mpr (h g)

/-- The restriction of one action morphism to the invariant subscheme. -/
def hom (hI : IsInvariantIdeal A I) (g : G) : I.subscheme ⟶ I.subscheme :=
  I.subschemeMap I (A.ρ g) (hI.le_map g)

@[reassoc]
theorem hom_subschemeι (hI : IsInvariantIdeal A I) (g : G) :
    hI.hom g ≫ I.subschemeι = I.subschemeι ≫ A.ρ g :=
  I.subschemeMap_subschemeι I (A.ρ g) (hI.le_map g)

@[simp]
theorem hom_one (hI : IsInvariantIdeal A I) : hI.hom 1 = 𝟙 _ := by
  apply (cancel_mono I.subschemeι).1
  rw [hI.hom_subschemeι]
  simp

theorem hom_mul (hI : IsInvariantIdeal A I) (g h : G) :
    hI.hom (g * h) = hI.hom h ≫ hI.hom g := by
  apply (cancel_mono I.subschemeι).1
  rw [hI.hom_subschemeι, Category.assoc, hI.hom_subschemeι,
    ← Category.assoc, hI.hom_subschemeι, Category.assoc]
  have hmul := A.ρ.map_mul g h
  change A.ρ (g * h) = A.ρ h ≫ A.ρ g at hmul
  rw [hmul]

/-- The induced action on the invariant closed subscheme. -/
def action (hI : IsInvariantIdeal A I) : Action Scheme G where
  V := I.subscheme
  ρ :=
    { toFun := hI.hom
      map_one' := hI.hom_one
      map_mul' := hI.hom_mul }

/-- If the ambient action is over `S`, so is the induced action on the
invariant closed subscheme. -/
def actionOver {S : Scheme.{u}} (hI : IsInvariantIdeal A I)
    [A.V.Over S] (hA : ∀ g : G, (A.ρ g).IsOver S) :
    Action (Over S) G := by
  letI hsub : I.subscheme.Over S :=
    ⟨I.subschemeι ≫ A.V ↘ S⟩
  letI : hI.action.V.Over S := by
    change I.subscheme.Over S
    exact hsub
  apply actionOverOfIsOver hI.action
  intro g
  change (hI.hom g).IsOver S
  refine ⟨?_⟩
  change hI.hom g ≫ I.subschemeι ≫ A.V ↘ S =
    I.subschemeι ≫ A.V ↘ S
  rw [← Category.assoc, hI.hom_subschemeι, Category.assoc]
  exact congrArg (fun f ↦ I.subschemeι ≫ f) (hA g).comp_over

end IsInvariantIdeal

end SchemeGeometry
end V14Formalization
