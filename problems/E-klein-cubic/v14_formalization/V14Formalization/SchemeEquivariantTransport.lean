/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.SchemeEquivariant

/-!
# Transporting equivariant rational maps along an isomorphism of actions

If `X ≅ X'` in `Action (Over S) G`, then an equivariant rational map out of
`X'` gives one out of `X`, by precomposing with the isomorphism.  The
isomorphism is dominant, so no dominance hypothesis on the rational map itself
is needed — which matters, because `EquivariantRationalMap` deliberately does
not assume its map is dominant.

This is what lets the coordinate-free statement and the coordinatized statement
imply each other.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization
namespace SchemeGeometry

open AlgebraicGeometry

universe u v

/-! ## Glue for composing rational maps with morphisms -/

section Glue

variable {X Y Z W : Scheme.{u}}

/-- A composite of morphisms, as a rational map, is the composite of the
rational maps.  Needs the first to be dominant, as `RationalMap.comp` does. -/
public theorem hom_toRationalMap_comp [PreirreducibleSpace X] [Nonempty Y]
    (u : X ⟶ Y) [IsDominant u] (v : Y ⟶ Z) :
    (u ≫ v).toRationalMap = u.toRationalMap.comp v.toRationalMap := by
  rw [Scheme.RationalMap.comp_toRationalMap]
  rfl

/-- Composing on the right by a morphism commutes with composing on the left by
a dominant rational map.  Mathlib's `comp_assoc` wants the middle map dominant;
here the middle map is arbitrary, and the statement still holds because
`compHom` does not move the domain. -/
public theorem partialMap_comp_compHom [PreirreducibleSpace X] [Nonempty Y]
    (q : X.PartialMap Y) [IsDominant q.hom] (p : Y.PartialMap Z) (h : Z ⟶ W) :
    q.comp (p.compHom h) = (q.comp p).compHom h := by
  ext1
  · rfl
  · simp [Scheme.PartialMap.compHom, Scheme.PartialMap.comp, Category.assoc]

public theorem rationalMap_comp_compHom [PreirreducibleSpace X] [Nonempty Y]
    (q : X ⤏ Y) [q.IsDominant] (p : Y ⤏ Z) (h : Z ⟶ W) :
    q.comp (p.compHom h) = (q.comp p).compHom h := by
  obtain ⟨p', rfl⟩ := p.exists_rep
  rw [← Scheme.RationalMap.compHom_toRationalMap, Scheme.RationalMap.comp_def,
    Scheme.RationalMap.comp_def, ← Scheme.RationalMap.compHom_toRationalMap]
  exact congrArg _ (partialMap_comp_compHom _ _ _)

/-- `RationalMap.comp` depends on its dominance instance only up to proof
irrelevance, so equal first arguments give equal composites.  This is what
`rw` cannot do directly, because the instance argument mentions the term being
rewritten. -/
public theorem comp_congr_left [PreirreducibleSpace X] [Nonempty Y]
    {q q' : X ⤏ Y} [q.IsDominant] [q'.IsDominant] (h : q = q') (p : Y ⤏ Z) :
    q.comp p = q'.comp p := by
  subst h; rfl

end Glue

/-! ## The transport -/

variable {S : Scheme.{u}} {G : Type v} [Group G]

/-- `actionPrecomp` is composition with the action morphism, as a rational map. -/
public theorem actionPrecomp_eq (X : Action (Over S) G) [IrreducibleSpace X.V.left]
    {Y : Scheme.{u}} (g : G) (f : X.V.left ⤏ Y)
    [((X.ρ g).left.toRationalMap).IsDominant] :
    actionPrecomp X g f = (X.ρ g).left.toRationalMap.comp f := rfl

variable {X X' Y : Action (Over S) G}

/-- Transport an equivariant rational map along an isomorphism of actions. -/
@[expose] public noncomputable def EquivariantRationalMap.ofIso
    [IrreducibleSpace X.V.left] [IrreducibleSpace X'.V.left]
    (e : X ≅ X') (f : EquivariantRationalMap X' Y) :
    EquivariantRationalMap X Y := by
  classical
  let ee : X.V.left ≅ X'.V.left :=
    (Over.forget S).mapIso ((Action.forget (Over S) G).mapIso e)
  letI : IsIso e.hom.hom.left := by
    change IsIso ee.hom
    infer_instance
  letI : IsDominant e.hom.hom.left := inferInstance
  letI : (e.hom.hom.left.toRationalMap).IsDominant := inferInstance
  letI : e.hom.hom.left.IsOver S := ⟨Over.w e.hom.hom⟩
  refine
    { map := e.hom.hom.left.toRationalMap.comp f.map
      isOver := ?_
      equivariant := ?_ }
  · obtain ⟨p, hp, hpe⟩ := (f.map.exists_partialMap_over S)
    letI : p.IsOver S := hp
    have hrw : e.hom.hom.left.toRationalMap.comp f.map
        = (e.hom.hom.left.toPartialMap.comp p).toRationalMap := by
      rw [← hpe, Scheme.RationalMap.toRationalMap_comp]
    rw [hrw]
    infer_instance
  · intro g
    letI : IsIso (X.ρ g).left := by
      change IsIso ((Over.forget S).mapIso (X.ρAut g)).hom
      infer_instance
    letI : IsDominant (X.ρ g).left := inferInstance
    letI : (((X.ρ g).left).toRationalMap).IsDominant := inferInstance
    letI : IsIso (X'.ρ g).left := by
      change IsIso ((Over.forget S).mapIso (X'.ρAut g)).hom
      infer_instance
    letI : IsDominant (X'.ρ g).left := inferInstance
    letI : (((X'.ρ g).left).toRationalMap).IsDominant := inferInstance
    have hcomm : (X.ρ g).left ≫ e.hom.hom.left = e.hom.hom.left ≫ (X'.ρ g).left :=
      congrArg (fun m => m.left) (e.hom.comm g)
    calc actionPrecomp X g (e.hom.hom.left.toRationalMap.comp f.map)
        = (X.ρ g).left.toRationalMap.comp
            (e.hom.hom.left.toRationalMap.comp f.map) := rfl
      _ = ((X.ρ g).left.toRationalMap.comp e.hom.hom.left.toRationalMap).comp f.map :=
          (Scheme.RationalMap.comp_assoc _ _ _).symm
      _ = ((X.ρ g).left ≫ e.hom.hom.left).toRationalMap.comp f.map :=
          comp_congr_left (hom_toRationalMap_comp _ _).symm f.map
      _ = (e.hom.hom.left ≫ (X'.ρ g).left).toRationalMap.comp f.map :=
          comp_congr_left (congrArg Scheme.Hom.toRationalMap hcomm) f.map
      _ = (e.hom.hom.left.toRationalMap.comp (X'.ρ g).left.toRationalMap).comp f.map :=
          comp_congr_left (hom_toRationalMap_comp _ _) f.map
      _ = e.hom.hom.left.toRationalMap.comp
            ((X'.ρ g).left.toRationalMap.comp f.map) :=
          Scheme.RationalMap.comp_assoc _ _ _
      _ = e.hom.hom.left.toRationalMap.comp (actionPrecomp X' g f.map) := rfl
      _ = e.hom.hom.left.toRationalMap.comp (f.map.compHom (Y.ρ g).left) := by
          rw [f.equivariant g]
      _ = (e.hom.hom.left.toRationalMap.comp f.map).compHom (Y.ρ g).left :=
          rationalMap_comp_compHom _ _ _

/-- Existence of an equivariant rational map only depends on the isomorphism
class of the source. -/
public theorem hasEquivariantRationalMap_of_iso
    [IrreducibleSpace X.V.left] [IrreducibleSpace X'.V.left]
    (e : X ≅ X') (h : HasEquivariantRationalMap X' Y) :
    HasEquivariantRationalMap X Y :=
  h.elim fun f => ⟨EquivariantRationalMap.ofIso e f⟩

/-! ## Pushing forward along an equivariant morphism

`EquivariantRationalMap.ofIso` transports along an isomorphism of the *source*.
This transports along an arbitrary equivariant morphism of the *target*, which
is what turns a hypothetical equivariant rational map to one `G`-scheme into
one to another.  No dominance is needed, because `compHom` does not move the
domain.
-/

section Push

variable {X' Y' Z' W' : Scheme.{u}}

public theorem partialMap_compHom_compHom (f : X'.PartialMap Y') (u : Y' ⟶ Z') (v : Z' ⟶ W') :
    (f.compHom u).compHom v = f.compHom (u ≫ v) := by
  ext1
  · rfl
  · simp [Scheme.PartialMap.compHom, Category.assoc]

public theorem rationalMap_compHom_compHom (f : X' ⤏ Y') (u : Y' ⟶ Z') (v : Z' ⟶ W') :
    (f.compHom u).compHom v = f.compHom (u ≫ v) := by
  obtain ⟨p, rfl⟩ := f.exists_rep
  rw [← Scheme.RationalMap.compHom_toRationalMap, ← Scheme.RationalMap.compHom_toRationalMap,
    ← Scheme.RationalMap.compHom_toRationalMap, partialMap_compHom_compHom]

end Push

variable {Z : Action (Over S) G}

/-- Push an equivariant rational map forward along an equivariant morphism of
targets. -/
@[expose] public noncomputable def EquivariantRationalMap.pushHom
    [IrreducibleSpace X.V.left] (f : EquivariantRationalMap X Y)
    (c : Y.V.left ⟶ Z.V.left) (hcOver : c.IsOver S)
    (hc : ∀ g : G, (Y.ρ g).left ≫ c = c ≫ (Z.ρ g).left) :
    EquivariantRationalMap X Z where
  map := f.map.compHom c
  isOver := by
    letI := f.isOver
    letI := hcOver
    infer_instance
  equivariant := fun g => by
    letI : IsIso (X.ρ g).left := by
      change IsIso ((Over.forget S).mapIso (X.ρAut g)).hom
      infer_instance
    letI : IsDominant (X.ρ g).left := inferInstance
    letI : (((X.ρ g).left).toRationalMap).IsDominant := inferInstance
    calc actionPrecomp X g (f.map.compHom c)
        = (X.ρ g).left.toRationalMap.comp (f.map.compHom c) := rfl
      _ = ((X.ρ g).left.toRationalMap.comp f.map).compHom c := rationalMap_comp_compHom _ _ _
      _ = (actionPrecomp X g f.map).compHom c := rfl
      _ = (f.map.compHom (Y.ρ g).left).compHom c := by rw [f.equivariant g]
      _ = f.map.compHom ((Y.ρ g).left ≫ c) := rationalMap_compHom_compHom _ _ _
      _ = f.map.compHom (c ≫ (Z.ρ g).left) := by rw [hc g]
      _ = (f.map.compHom c).compHom (Z.ρ g).left := (rationalMap_compHom_compHom _ _ _).symm

/-- Existence of an equivariant rational map is inherited along an equivariant
morphism of targets. -/
public theorem hasEquivariantRationalMap_of_hom
    [IrreducibleSpace X.V.left]
    (c : Y.V.left ⟶ Z.V.left) (hcOver : c.IsOver S)
    (hc : ∀ g : G, (Y.ρ g).left ≫ c = c ≫ (Z.ρ g).left)
    (h : HasEquivariantRationalMap X Y) : HasEquivariantRationalMap X Z :=
  h.elim fun f => ⟨EquivariantRationalMap.pushHom f c hcOver hc⟩

end SchemeGeometry
end V14Formalization
