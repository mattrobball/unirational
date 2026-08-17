/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.SchemeFixedLocus
public import V14Formalization.SchemeNormalSpecialization

/-!
# Rational maps into a scheme-theoretic fixed locus

A rational map fixed by an automorphism of its target factors as a genuine
`Scheme.RationalMap` through the equalizer defining the fixed locus.  The
construction takes place at the function field and then uses Mathlib's
function-field/rational-map equivalence.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry

universe u v

variable {S E : Scheme.{u}} {G : Type v} [Group G]
  (Y : Action (Over S) G) (sigma : G)
  [E.Over S] [IsIntegral E]

public local instance specFunctionFieldE_over : (Spec (.of E.functionField)).Over S where
  hom := E.fromSpecStalk _ ≫ E ↘ S

/-- Passing from a rational map to its function-field morphism commutes with
postcomposition by a scheme morphism. -/
public theorem fromFunctionField_compHom
    {A B C : Scheme.{u}} [IrreducibleSpace A]
    (q : A ⤏ B) (a : B ⟶ C) :
    (q.compHom a).fromFunctionField = q.fromFunctionField ≫ a := by
  obtain ⟨q, rfl⟩ := q.exists_rep
  rfl

/-- A rational map fixed by `sigma` factors through the scheme-theoretic
`sigma`-fixed locus. -/
@[expose] public noncomputable def rationalMapToFixedBy
    (q : E ⤏ Y.V.left) [q.IsOver S]
    (hfixed : q.compHom (Y.ρ sigma).left = q)
    [LocallyOfFiniteType Y.V.hom]
    [LocallyOfFiniteType (FixedBy Y sigma).hom] :
    { r : E ⤏ (FixedBy Y sigma).left // r.IsOver S } := by
  letI hYlft : LocallyOfFiniteType (Y.V.left ↘ S) := by
    change LocallyOfFiniteType Y.V.hom
    infer_instance
  letI hFlft : LocallyOfFiniteType ((FixedBy Y sigma).left ↘ S) := by
    change LocallyOfFiniteType (FixedBy Y sigma).hom
    infer_instance
  let qffOver :=
    (Scheme.RationalMap.equivFunctionFieldOver (S := S)).symm
      (⟨q, inferInstance⟩ : { q : E ⤏ Y.V.left // q.IsOver S })
  letI : q.fromFunctionField.IsOver S := qffOver.2
  let p : Over.mk (E.fromSpecStalk _ ≫ E ↘ S) ⟶ Y.V :=
    q.fromFunctionField.asOver S
  have hp : p ≫ Y.ρ sigma = p := by
    apply Over.OverMorphism.ext
    change q.fromFunctionField ≫ (Y.ρ sigma).left = q.fromFunctionField
    have h := congrArg Scheme.RationalMap.fromFunctionField hfixed
    simpa only [fromFunctionField_compHom] using h
  let l := fixedByLift Y sigma p hp
  letI hlOver : l.left.IsOver S := by
    constructor
    exact l.w
  exact (Scheme.RationalMap.equivFunctionFieldOver (S := S)).toFun
    ⟨l.left, hlOver⟩

/-- The factorization really recovers the original rational map after
composing with the fixed-locus inclusion. -/
@[simp]
public theorem rationalMapToFixedBy_comp_ι
    (q : E ⤏ Y.V.left) [q.IsOver S]
    (hfixed : q.compHom (Y.ρ sigma).left = q)
    [LocallyOfFiniteType Y.V.hom]
    [LocallyOfFiniteType (FixedBy Y sigma).hom] :
    (rationalMapToFixedBy Y sigma q hfixed).1.compHom (fixedByι Y sigma).left = q := by
  apply Scheme.RationalMap.eq_of_fromFunctionField_eq
  letI hYlft : LocallyOfFiniteType (Y.V.left ↘ S) := by
    change LocallyOfFiniteType Y.V.hom
    infer_instance
  letI hFlft : LocallyOfFiniteType ((FixedBy Y sigma).left ↘ S) := by
    change LocallyOfFiniteType (FixedBy Y sigma).hom
    infer_instance
  let qffOver :=
    (Scheme.RationalMap.equivFunctionFieldOver (S := S)).symm
      (⟨q, inferInstance⟩ : { q : E ⤏ Y.V.left // q.IsOver S })
  letI : q.fromFunctionField.IsOver S := qffOver.2
  let p : Over.mk (E.fromSpecStalk _ ≫ E ↘ S) ⟶ Y.V :=
    q.fromFunctionField.asOver S
  have hp : p ≫ Y.ρ sigma = p := by
    apply Over.OverMorphism.ext
    change q.fromFunctionField ≫ (Y.ρ sigma).left = q.fromFunctionField
    have h := congrArg Scheme.RationalMap.fromFunctionField hfixed
    simpa only [fromFunctionField_compHom] using h
  have hff :
      (rationalMapToFixedBy Y sigma q hfixed).1.fromFunctionField =
        (fixedByLift Y sigma p hp).left := by
    unfold rationalMapToFixedBy
    let l := fixedByLift Y sigma p hp
    letI hlOver : l.left.IsOver S := by
      constructor
      exact l.w
    exact congrArg Subtype.val
      ((Scheme.RationalMap.equivFunctionFieldOver (S := S)).left_inv
        (⟨l.left, hlOver⟩))
  rw [fromFunctionField_compHom, hff]
  have h := congrArg Over.Hom.left (fixedByLift_ι Y sigma p hp)
  change (fixedByLift Y sigma p hp).left ≫ (fixedByι Y sigma).left = p.left at h
  exact h

end SchemeGeometry
end V14Formalization
