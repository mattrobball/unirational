/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import BConicBundleMultisections.ProjectiveSpace
public import BConicBundleMultisections.Unirationality
public import Mathlib.AlgebraicGeometry.Birational.Composition
public import Mathlib.CategoryTheory.Action.Basic
public import Mathlib.CategoryTheory.Comma.Over.Basic

/-!
# Equivariant rational maps of schemes

The objects are genuine group actions in the category of schemes over a base.
The rational map is Mathlib's `Scheme.RationalMap`; neither totality nor
linearity of the map is assumed.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

universe u v w

open AlgebraicGeometry
open TopologicalSpace

/-! ## Pulling arbitrary rational maps back along dominant morphisms -/

/-- Composition of partial maps over a base remains over that base when the
first partial map is dominant.  This is the partial-map form needed to avoid
the extra dominance assumption on the second rational map in Mathlib's
`RationalMap.isOver_comp` instance; the rational-map type itself imposes no
dominance condition. -/
@[expose] public instance partialMapCompIsOver
    {S X Y Z : Scheme.{u}} [PreirreducibleSpace X] [Nonempty Y]
    [X.Over S] [Y.Over S] [Z.Over S]
    (f : X.PartialMap Y) [IsDominant f.hom] [f.IsOver S]
    (g : Y.PartialMap Z) [g.IsOver S] : (f.comp g).IsOver S := by
  rw [Scheme.PartialMap.IsOver, Scheme.Hom.isOver_iff]
  unfold Scheme.PartialMap.comp
  simp only [Category.assoc]
  rw [comp_over g.hom S]
  rw [← comp_over g.domain.ι S, morphismRestrict_ι_assoc,
    comp_over f.hom S]
  rw [f.domain.isoImage_ι_inv_ι_assoc]
  exact comp_over (X.homOfLE (f.domain.ι_image_le (f.hom ⁻¹ᵁ g.domain))) S

/-- Pull an arbitrary rational map over `S` back along a dominant `S`-morphism.
No dominance assumption is placed on the rational map itself. -/
noncomputable def pullbackAlongDominant
    {S B X Y : Scheme.{u}} [PreirreducibleSpace B] [Nonempty X]
    [B.Over S] [X.Over S] [Y.Over S]
    (b : B ⟶ X) [IsDominant b] [b.IsOver S]
    (f : X ⤏ Y) [f.IsOver S] : { g : B ⤏ Y // g.IsOver S } := by
  let p := (f.exists_partialMap_over S).choose
  letI : p.IsOver S := (f.exists_partialMap_over S).choose_spec.1
  exact ⟨(b.toPartialMap.comp p).toRationalMap, inferInstance⟩

/-- Precompose a rational map by one automorphism from an action on schemes. -/
noncomputable def absoluteActionPrecomp {G : Type v} [Group G]
    (X : Action Scheme G) [IrreducibleSpace X.V]
    {Y : Scheme.{u}} (g : G) (f : X.V ⤏ Y) : X.V ⤏ Y := by
  let e : X.V ≅ X.V := X.ρAut g
  letI : IsIso (X.ρ g) := by
    change IsIso e.hom
    infer_instance
  letI : IsDominant (X.ρ g) := inferInstance
  letI : ((X.ρ g).toRationalMap).IsDominant := inferInstance
  exact (X.ρ g).toRationalMap.comp f

/-- A genuine rational map of schemes commuting with absolute `G`-actions.

No linearity, totality, or dominance is built into this notion. -/
structure AbsoluteEquivariantRationalMap {G : Type v} [Group G]
    (X Y : Action Scheme G) [IrreducibleSpace X.V] where
  map : X.V ⤏ Y.V
  equivariant : ∀ g : G,
    absoluteActionPrecomp X g map = map.compHom (Y.ρ g)

/-- Existence of a `G`-equivariant rational map of the underlying schemes. -/
def HasAbsoluteEquivariantRationalMap {G : Type v} [Group G]
    (X Y : Action Scheme G) [IrreducibleSpace X.V] : Prop :=
  Nonempty (AbsoluteEquivariantRationalMap X Y)

/-- A `G`-equivariant rational map of schemes which is defined over `S`.

Keeping the actions in `Scheme` makes this usable before their structure-map
compatibility has been repackaged categorically in `Over S`; `isOver` still
ensures that the rational map itself is an `S`-map. -/
structure SchemeEquivariantRationalMapOver {S : Scheme.{u}} {G : Type v} [Group G]
    (X Y : Action Scheme G) [X.V.Over S] [Y.V.Over S]
    [IrreducibleSpace X.V] where
  map : X.V ⤏ Y.V
  isOver : map.IsOver S
  equivariant : ∀ g : G,
    absoluteActionPrecomp X g map = map.compHom (Y.ρ g)

/-- Existence of a genuine equivariant rational `S`-map. -/
def HasSchemeEquivariantRationalMapOver {S : Scheme.{u}} {G : Type v} [Group G]
    (X Y : Action Scheme G) [X.V.Over S] [Y.V.Over S]
    [IrreducibleSpace X.V] : Prop :=
  Nonempty (SchemeEquivariantRationalMapOver (S := S) X Y)

/-- Package an absolute scheme action over `S` after proving that every action
morphism preserves the structure map. -/
@[expose] public noncomputable def actionOverOfIsOver
    {S : Scheme.{u}} {G : Type v} [Group G]
    (X : Action Scheme G) [X.V.Over S]
    (h : ∀ g : G, (X.ρ g).IsOver S) :
    Action (Over S) G where
  V := OverClass.asOver X.V S
  ρ :=
    { toFun := fun g ↦ by
        letI : (X.ρ g).IsOver S := h g
        exact (X.ρ g).asOver S
      map_one' := by
        apply Over.OverMorphism.ext
        simp
      map_mul' := fun g h ↦ by
        apply Over.OverMorphism.ext
        simp }

/-- Precompose a rational map by one automorphism from a group action. -/
@[expose] public noncomputable def actionPrecomp {S : Scheme.{u}} {G : Type v} [Group G]
    (X : Action (Over S) G) [IrreducibleSpace X.V.left]
    {Y : Scheme.{u}} (g : G)
    (f : X.V.left ⤏ Y) : X.V.left ⤏ Y := by
  let e : X.V.left ≅ X.V.left := (Over.forget S).mapIso (X.ρAut g)
  letI : IsIso (X.ρ g).left := by
    change IsIso e.hom
    infer_instance
  letI : IsDominant (X.ρ g).left := inferInstance
  letI : ((X.ρ g).left.toRationalMap).IsDominant := inferInstance
  exact (X.ρ g).left.toRationalMap.comp f

/-- Precomposition by an element acting identically on the source leaves
every rational map unchanged. -/
public theorem actionPrecomp_eq_self_of_rho_eq_id
    {S : Scheme.{u}} {G : Type v} [Group G]
    (X : Action (Over S) G) [IrreducibleSpace X.V.left]
    {Y : Scheme.{u}} (g : G) (h : X.ρ g = 𝟙 X.V)
    (f : X.V.left ⤏ Y) : actionPrecomp X g f = f := by
  have hleft : (X.ρ g).left = 𝟙 X.V.left := congrArg Over.Hom.left h
  let e : X.V.left ≅ X.V.left := (Over.forget S).mapIso (X.ρAut g)
  letI : IsIso (X.ρ g).left := by
    change IsIso e.hom
    infer_instance
  letI : IsDominant (X.ρ g).left := inferInstance
  letI : ((X.ρ g).left.toRationalMap).IsDominant := inferInstance
  change ((X.ρ g).left.toRationalMap).comp f = f
  simpa [hleft, Scheme.RationalMap.id] using
    (Scheme.RationalMap.id_comp f)

/-- A rational map over `S` commuting with the actions of `G`. -/
public structure EquivariantRationalMap {S : Scheme.{u}} {G : Type v} [Group G]
    (X Y : Action (Over S) G) [IrreducibleSpace X.V.left] where
  map : X.V.left ⤏ Y.V.left
  isOver : map.IsOver S
  equivariant : ∀ g : G,
    actionPrecomp X g map = map.compHom (Y.ρ g).left

namespace EquivariantRationalMap

variable {S : Scheme.{u}} {G : Type v} [Group G]
  {X Y : Action (Over S) G} [IrreducibleSpace X.V.left]

@[expose] public instance (f : EquivariantRationalMap X Y) : f.map.IsOver S := f.isOver

@[expose] public instance actionRes_irreducibleSpace
    {H : Type w} [Group H] (phi : H →* G) (X : Action (Over S) G)
    [IrreducibleSpace X.V.left] :
    IrreducibleSpace ((Action.res (Over S) phi).obj X).V.left := by
  change IrreducibleSpace X.V.left
  infer_instance

@[expose] public instance actionRes_isIntegral
    {H : Type w} [Group H] (phi : H →* G) (X : Action (Over S) G)
    [IsIntegral X.V.left] :
    IsIntegral ((Action.res (Over S) phi).obj X).V.left := by
  change IsIntegral X.V.left
  infer_instance

/-- Restrict an equivariant rational map along a group homomorphism.  The
underlying rational map is unchanged, so no dominance hypothesis is added. -/
@[expose] public noncomputable def res {H : Type w} [Group H] (phi : H →* G)
    (f : EquivariantRationalMap X Y) :
    EquivariantRationalMap
      ((Action.res (Over S) phi).obj X)
      ((Action.res (Over S) phi).obj Y) where
  map := f.map
  isOver := f.isOver
  equivariant := fun h => f.equivariant (phi h)

end EquivariantRationalMap

/-- Existence of a genuine equivariant rational map of schemes. -/
@[expose] public def HasEquivariantRationalMap {S : Scheme.{u}} {G : Type v} [Group G]
    (X Y : Action (Over S) G) [IrreducibleSpace X.V.left] : Prop :=
  Nonempty (EquivariantRationalMap X Y)

end SchemeGeometry
end V14Formalization
