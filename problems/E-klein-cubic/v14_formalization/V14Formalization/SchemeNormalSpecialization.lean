/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.SchemeEquivariant
public import Mathlib.AlgebraicGeometry.ValuativeCriterion

/-!
# Proper specialization at a normal valuation

This file isolates the resolution-free geometric step used by the centralizer
argument.  A valuation ring whose fraction field is `K(X)` and whose residue
field is `K(E)` specializes any rational map `X ⤏ Y` to a rational map
`E ⤏ Y` whenever `Y` is proper over the base.

For the headline application, `E` is the exceptional divisor of the blowup
of projective space along the chosen involution-fixed projective subspace.
The construction uses only the generic point of `E`; it does not assert that
the blowup resolves the original rational map.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry

universe u

variable {S X E Y : Scheme.{u}}

/-- A valuation centered on `S`, with fraction field `K(X)` and residue field
`K(E)`.  The surjectivity and kernel conditions record that the displayed
map to `K(E)` is genuinely the residue map of the valuation ring. -/
public structure NormalValuationData (S X E : Scheme.{u}) [X.Over S] [E.Over S]
    [IsIntegral X] [IsIntegral E] where
  R : Type u
  [commRing : CommRing R]
  [domain : IsDomain R]
  [valuationRing : ValuationRing R]
  [algebra : Algebra R X.functionField]
  [isFractionRing : IsFractionRing R X.functionField]
  toBase : Spec (.of R) ⟶ S
  generic_toBase :
    Spec.map (CommRingCat.ofHom (algebraMap R X.functionField)) ≫ toBase =
      X.fromSpecStalk _ ≫ X ↘ S
  residue : R →+* E.functionField
  residue_surjective : Function.Surjective residue
  residue_ker : RingHom.ker residue = IsLocalRing.maximalIdeal R
  special_toBase :
    Spec.map (CommRingCat.ofHom residue) ≫ toBase =
      E.fromSpecStalk _ ≫ E ↘ S

namespace NormalValuationData

attribute [instance] commRing domain valuationRing algebra isFractionRing

variable [X.Over S] [E.Over S] [IsIntegral X] [IsIntegral E]

public local instance specFunctionFieldX_over : (Spec (.of X.functionField)).Over S where
  hom := X.fromSpecStalk _ ≫ X ↘ S

public local instance specFunctionFieldE_over : (Spec (.of E.functionField)).Over S where
  hom := E.fromSpecStalk _ ≫ E ↘ S

/-- The valuative square obtained from a rational map over `S`. -/
@[expose] public noncomputable def square (D : NormalValuationData S X E)
    [Y.Over S] (f : X ⤏ Y) [f.IsOver S] [LocallyOfFiniteType (Y ↘ S)] :
    ValuativeCommSq (Y ↘ S) where
  R := D.R
  K := X.functionField
  i₁ := f.fromFunctionField
  i₂ := D.toBase
  commSq := by
    constructor
    let ffOver :=
      (Scheme.RationalMap.equivFunctionFieldOver (S := S)).symm
        (⟨f, inferInstance⟩ : { f : X ⤏ Y // f.IsOver S })
    exact ffOver.2.comp_over.trans D.generic_toBase.symm

/-- The unique proper lift of the function-field map to the valuation ring. -/
@[expose] public noncomputable def properLiftStruct (D : NormalValuationData S X E)
    [Y.Over S] (f : X ⤏ Y) [f.IsOver S] [IsProper (Y ↘ S)] :
    (D.square f).commSq.LiftStruct := by
  have hp : IsProper (Y ↘ S) := inferInstance
  rw [IsProper.eq_valuativeCriterion] at hp
  let u : Unique (D.square f).commSq.LiftStruct :=
    Classical.choice (hp.1.1.1 (D.square f))
  exact u.default

/-- The morphism underlying the unique proper valuative lift. -/
@[expose] public noncomputable def properLift (D : NormalValuationData S X E)
    [Y.Over S] (f : X ⤏ Y) [f.IsOver S] [IsProper (Y ↘ S)] :
    Spec (.of D.R) ⟶ Y :=
  (D.properLiftStruct f).l

@[reassoc]
public theorem properLift_toBase (D : NormalValuationData S X E)
    [Y.Over S] (f : X ⤏ Y) [f.IsOver S] [IsProper (Y ↘ S)] :
    D.properLift f ≫ Y ↘ S = D.toBase := by
  exact (D.properLiftStruct f).fac_right

/-- The proper lift extends the original function-field morphism. -/
@[reassoc]
public theorem generic_to_properLift (D : NormalValuationData S X E)
    [Y.Over S] (f : X ⤏ Y) [f.IsOver S] [IsProper (Y ↘ S)] :
    Spec.map (CommRingCat.ofHom (algebraMap D.R X.functionField)) ≫
      D.properLift f = f.fromFunctionField := by
  exact (D.properLiftStruct f).fac_left

/-- The valuative lift is the unique morphism extending the generic map and
lying over the displayed center on the base. -/
theorem properLift_unique (D : NormalValuationData S X E)
    [Y.Over S] (f : X ⤏ Y) [f.IsOver S] [IsProper (Y ↘ S)]
    (l : Spec (.of D.R) ⟶ Y)
    (hgeneric :
      Spec.map (CommRingCat.ofHom (algebraMap D.R X.functionField)) ≫ l =
        f.fromFunctionField)
    (hbase : l ≫ Y ↘ S = D.toBase) : l = D.properLift f := by
  have hp : IsProper (Y ↘ S) := inferInstance
  rw [IsProper.eq_valuativeCriterion] at hp
  have hu := (hp.1.1.1 (D.square f)).some
  let L : (D.square f).commSq.LiftStruct := ⟨l, hgeneric, hbase⟩
  exact congrArg CommSq.LiftStruct.l
    ((hu.uniq L).trans (hu.uniq (D.properLiftStruct f)).symm)

/-- Two morphisms from the valuation ring to a separated target agree once
they agree generically and have the same map to the base. -/
public theorem hom_ext_of_generic_eq (D : NormalValuationData S X E)
    [Y.Over S] [IsSeparated (Y ↘ S)]
    (l₁ l₂ : Spec (.of D.R) ⟶ Y)
    (hbase₁ : l₁ ≫ Y ↘ S = D.toBase)
    (hbase₂ : l₂ ≫ Y ↘ S = D.toBase)
    (hgeneric :
      Spec.map (CommRingCat.ofHom (algebraMap D.R X.functionField)) ≫ l₁ =
        Spec.map (CommRingCat.ofHom (algebraMap D.R X.functionField)) ≫ l₂) :
    l₁ = l₂ := by
  let j := Spec.map (CommRingCat.ofHom (algebraMap D.R X.functionField))
  let sq : ValuativeCommSq (Y ↘ S) :=
    { R := D.R
      K := X.functionField
      i₁ := j ≫ l₁
      i₂ := D.toBase
      commSq := ⟨by rw [Category.assoc, hbase₁]⟩ }
  have hu : Subsingleton sq.commSq.LiftStruct :=
    IsSeparated.valuativeCriterion (Y ↘ S) sq
  let L₁ : sq.commSq.LiftStruct := ⟨l₁, rfl, hbase₁⟩
  let L₂ : sq.commSq.LiftStruct := ⟨l₂, hgeneric.symm, hbase₂⟩
  exact congrArg CommSq.LiftStruct.l (hu.elim L₁ L₂)

/-- Restrict the proper lift to the residue field `K(E)`. -/
@[expose] public noncomputable def specialFiberMap (D : NormalValuationData S X E)
    [Y.Over S] (f : X ⤏ Y) [f.IsOver S] [IsProper (Y ↘ S)] :
    Spec (.of E.functionField) ⟶ Y :=
  Spec.map (CommRingCat.ofHom D.residue) ≫ D.properLift f

@[expose] public instance specialFiberMap_isOver (D : NormalValuationData S X E)
    [Y.Over S] (f : X ⤏ Y) [f.IsOver S] [IsProper (Y ↘ S)] :
    (D.specialFiberMap f).IsOver S where
  comp_over := by
    rw [specialFiberMap, Category.assoc, D.properLift_toBase f]
    exact D.special_toBase

/-- Proper specialization at the normal valuation produces a genuine
rational map from the exceptional divisor over the same base. -/
@[expose] public noncomputable def specialize (D : NormalValuationData S X E)
    [Y.Over S] (f : X ⤏ Y) [f.IsOver S] [IsProper (Y ↘ S)] :
    { q : E ⤏ Y // q.IsOver S } :=
  (Scheme.RationalMap.equivFunctionFieldOver (S := S)).toFun
    ⟨D.specialFiberMap f, D.specialFiberMap_isOver f⟩

@[simp]
public theorem specialize_fromFunctionField (D : NormalValuationData S X E)
    [Y.Over S] (f : X ⤏ Y) [f.IsOver S] [IsProper (Y ↘ S)] :
    (D.specialize f).1.fromFunctionField = D.specialFiberMap f := by
  exact congrArg Subtype.val
    ((Scheme.RationalMap.equivFunctionFieldOver (S := S)).left_inv
      (⟨D.specialFiberMap f, D.specialFiberMap_isOver f⟩))

end NormalValuationData
end SchemeGeometry
end V14Formalization
