/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.AlgebraicGeometry.AffineSpace
public import Mathlib.AlgebraicGeometry.Birational.Birational
public import Mathlib.AlgebraicGeometry.Birational.Dominant
public import Mathlib.Tactic.MkIffOfInductiveProp

/-!
# Unirational parametrizations of schemes

This file defines chosen fixed-dimensional unirational parametrizations, their existence, and
finite-dimensional unirationality over a base scheme.  It also records transfer of fixed-dimensional
parametrizations along dominant morphisms and finite-dimensional birational models over the base.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

noncomputable section

universe u

open AlgebraicGeometry

namespace AlgebraicGeometry.Scheme.RationalMap

/-- Postcomposing a rational map by two morphisms agrees with postcomposing by their
composite. -/
lemma compHom_compHom {W X Y Z : Scheme.{u}} (f : W ⤏ X)
    (g : X ⟶ Y) (h : Y ⟶ Z) :
    (f.compHom g).compHom h = f.compHom (g ≫ h) := by
  obtain ⟨f, rfl⟩ := AlgebraicGeometry.Scheme.PartialMap.toRationalMap_surjective f
  rw [← compHom_toRationalMap, ← compHom_toRationalMap, ← compHom_toRationalMap]
  apply congrArg PartialMap.toRationalMap
  apply PartialMap.ext _ _ rfl
  simp

/-- Postcomposing a dominant rational map by a dominant morphism remains dominant. -/
lemma isDominant_compHom {W X Y : Scheme.{u}} (f : W ⤏ X)
    [f.IsDominant] (g : X ⟶ Y) [IsDominant g] :
    (f.compHom g).IsDominant := by
  obtain ⟨f, rfl⟩ := AlgebraicGeometry.Scheme.PartialMap.toRationalMap_surjective f
  rw [← compHom_toRationalMap]
  haveI : IsDominant f.hom := f.isDominant_toRationalMap_iff.mp inferInstance
  rw [PartialMap.isDominant_toRationalMap_iff]
  change IsDominant (f.hom ≫ g)
  infer_instance

end AlgebraicGeometry.Scheme.RationalMap

namespace BConicBundleMultisections

/--
The data of a fixed-dimensional unirational parametrization of `X → S`.

The source is relative affine `n`-space.  The map is allowed to be rational, as geometric
parametrizations naturally have indeterminacy loci, but it must be dominant and over `S`.
`ULift (Fin n)` is the universe-correct finite coordinate type for Mathlib's affine-space API.
-/
structure UnirationalParametrization {S X : Scheme.{u}} (n : ℕ) (sX : X ⟶ S) where
  /-- The chosen dominant rational map from relative affine `n`-space. -/
  map : 𝔸(ULift.{u} (Fin n); S) ⤏ X
  /-- The chosen rational map is dominant. -/
  isDominant : map.IsDominant
  /-- The chosen rational map commutes with the structure morphisms to `S`. -/
  isOver : map.compHom sX = (𝔸(ULift.{u} (Fin n); S) ↘ S).toRationalMap

/-- `X → S` admits a unirational parametrization by relative affine `n`-space. -/
def HasUnirationalParametrization {S X : Scheme.{u}} (n : ℕ) (sX : X ⟶ S) : Prop :=
  Nonempty (UnirationalParametrization n sX)

namespace UnirationalParametrization

variable {S X : Scheme.{u}} {n : ℕ} {sX : X ⟶ S}

instance (p : UnirationalParametrization n sX) : p.map.IsDominant := p.isDominant

/--
A total dominant `S`-morphism from affine `n`-space gives a unirational parametrization.

This is the convenient constructor when the parametrization has no indeterminacy.  The main
structure still accepts rational maps, which is essential for tangent-residual constructions.
-/
def ofHom (f : 𝔸(ULift.{u} (Fin n); S) ⟶ X) [IsDominant f]
    (hf : f ≫ sX = 𝔸(ULift.{u} (Fin n); S) ↘ S) :
    UnirationalParametrization n sX where
  map := f.toRationalMap
  isDominant := inferInstance
  isOver := by
    rw [← Scheme.RationalMap.compHom_toRationalMap,
      Scheme.Hom.toPartialMap_compHom, hf]

/-- Transport a chosen unirational parametrization across an isomorphism of targets over the
same base. -/
def targetIso {Y : Scheme.{u}} {sY : Y ⟶ S}
    (p : UnirationalParametrization n sX) (e : X ≅ Y)
    (he : e.hom ≫ sY = sX) : UnirationalParametrization n sY where
  map := p.map.compHom e.hom
  isDominant := Scheme.RationalMap.isDominant_compHom p.map e.hom
  isOver := by
    rw [Scheme.RationalMap.compHom_compHom, he]
    exact p.isOver

/-- Forget the chosen parametrization but retain its fixed source dimension. -/
theorem toHasUnirationalParametrization (p : UnirationalParametrization n sX) :
    HasUnirationalParametrization n sX :=
  ⟨p⟩

/--
Postcompose a unirational parametrization of `Y → S` by a dominant `S`-morphism `Y → X`.

This is the composition step in the multisection principle: a dominant map from a rational
source to a base change of `X`, followed by the projection of that base change to `X`, yields a
unirational parametrization of `X`.
-/
def postcomp {Y : Scheme.{u}} {sY : Y ⟶ S} (p : UnirationalParametrization n sY)
    (f : Y ⟶ X) [IsDominant f] (hf : f ≫ sX = sY) :
    UnirationalParametrization n sX where
  map := p.map.compHom f
  isDominant := Scheme.RationalMap.isDominant_compHom p.map f
  isOver := by
    rw [Scheme.RationalMap.compHom_compHom, hf]
    exact p.isOver

open Scheme

/-- The rational map associated to a partial isomorphism is dominant. -/
instance (priority := 100) {X Y : Scheme.{u}} (φ : PartialIso X Y) :
    φ.toRationalMap.IsDominant := by
  have : IsDominant φ.target.ι := Opens.isDominant_ι φ.dense_target
  have : IsDominant φ.toPartialMap.hom := by
    dsimp [PartialIso.toPartialMap]
    infer_instance
  exact φ.toPartialMap.isDominant_toRationalMap_iff.mpr ‹_›

/--
A partial isomorphism over `S` from finite-dimensional relative affine space supplies a
unirational parametrization.

This converts a finite-dimensional `BirationalOver` witness into the project's fixed-dimension
parametrization API (U08 bridge).  The `IsOver` identity is compared as an equivalence of partial
maps on the dense source of `φ`.
-/
def ofPartialIso (φ : PartialIso (𝔸(ULift.{u} (Fin n); S)) X)
    (hφ : φ.IsOver (𝔸(ULift.{u} (Fin n); S) ↘ S) sX) :
    UnirationalParametrization n sX where
  map := φ.toRationalMap
  isDominant := inferInstance
  isOver := by
    let A : Scheme.{u} := 𝔸(ULift.{u} (Fin n); S)
    -- Compare `φ.toPartialMap.compHom sX` with `(A ↘ S).toPartialMap` on `φ.source`.
    change φ.toPartialMap.toRationalMap.compHom sX = (A ↘ S).toPartialMap.toRationalMap
    rw [← Scheme.RationalMap.compHom_toRationalMap]
    refine PartialMap.toRationalMap_eq_iff.mpr ?_
    refine ⟨φ.source, φ.dense_source, le_rfl, le_top, ?_⟩
    -- Left restriction: `iso.hom ≫ target.ι ≫ sX`.
    -- Right restriction: `homOfLE le_top ≫ topIso.hom ≫ (A ↘ S)`.
    -- `PartialIso.IsOver` and `U.ι = homOfLE (U ≤ ⊤) ≫ topIso.hom` finish the proof.
    have hφ' : φ.iso.hom ≫ φ.target.ι ≫ sX = φ.source.ι ≫ A ↘ S := hφ
    -- Unfold both restricted homs.
    -- Left domain equals `φ.source`, so `homOfLE le_rfl` is the identity.
    -- Right is the restriction of the total structure map of affine space.
    dsimp [PartialMap.restrict, PartialMap.compHom, Hom.toPartialMap, PartialIso.toPartialMap]
    rw [Scheme.homOfLE_rfl, Category.id_comp, Category.assoc, hφ']
    -- `topIso.hom = ⊤.ι`, and `homOfLE_ι` says `homOfLE (U ≤ ⊤) ≫ ⊤.ι = U.ι`.
    have hι : φ.source.ι =
        A.homOfLE (le_top : φ.source ≤ ⊤) ≫ A.topIso.hom := by
      rw [Scheme.topIso_hom]
      exact (Scheme.homOfLE_ι A (le_top : φ.source ≤ ⊤)).symm
    rw [hι, Category.assoc]

/-- From a finite-dimensional birationality witness over `S` to affine space, extract a
unirational parametrization.

`BirationalOver sX (A ↘ S)` chooses a partial iso `X → A`; its inverse is a partial iso
`A → X` and is the oriented witness used by `ofPartialIso`.
-/
def ofBirationalOverAffine
    (h : BirationalOver sX (𝔸(ULift.{u} (Fin n); S) ↘ S)) :
    UnirationalParametrization n sX :=
  ofPartialIso h.partialIso.symm h.partialIso_isOver.symm

end UnirationalParametrization

/-- Admitting a fixed-dimensional unirational parametrization is invariant under an isomorphism
of targets over the base. -/
theorem hasUnirationalParametrization_iff_of_iso
    {S X Y : Scheme.{u}} {n : ℕ} {sX : X ⟶ S} {sY : Y ⟶ S}
    (e : X ≅ Y) (he : e.hom ≫ sY = sX) :
    HasUnirationalParametrization n sX ↔ HasUnirationalParametrization n sY := by
  constructor
  · exact Nonempty.map (fun p ↦ p.targetIso e he)
  · have he' : e.inv ≫ sX = sY := by
      rw [← he]
      simp
    exact Nonempty.map (fun p ↦ p.targetIso e.symm he')

/-- Postcompose an existence statement for a unirational parametrization by a dominant
`S`-morphism. -/
theorem HasUnirationalParametrization.postcomp {S X Y : Scheme.{u}} {n : ℕ}
    {sX : X ⟶ S} {sY : Y ⟶ S} (h : HasUnirationalParametrization n sY)
    (f : Y ⟶ X) [IsDominant f] (hf : f ≫ sX = sY) :
    HasUnirationalParametrization n sX :=
  h.map fun p ↦ p.postcomp f hf

/--
A scheme `X → S` is unirational over `S` if it admits a parametrization by some
finite-dimensional affine space over `S`.

Use `HasUnirationalParametrization n sX` when the source dimension matters.  In particular, the
main `(2, 3)` threefold theorem should prove the stronger case `n = 3` before forgetting `n` here.
-/
@[mk_iff]
class IsUnirationalOver {S X : Scheme.{u}} (sX : X ⟶ S) : Prop where
  /-- A finite dimension in which `X` has a unirational parametrization. -/
  exists_parametrization : ∃ n : ℕ, HasUnirationalParametrization n sX

/-- Unirationality over a base is invariant under an isomorphism of targets over that base. -/
theorem isUnirationalOver_iff_of_iso
    {S X Y : Scheme.{u}} {sX : X ⟶ S} {sY : Y ⟶ S}
    (e : X ≅ Y) (he : e.hom ≫ sY = sX) :
    IsUnirationalOver sX ↔ IsUnirationalOver sY := by
  rw [isUnirationalOver_iff, isUnirationalOver_iff]
  exact exists_congr fun n ↦ hasUnirationalParametrization_iff_of_iso e he

/-- A fixed-dimensional unirational parametrization implies unirationality. -/
theorem HasUnirationalParametrization.isUnirationalOver {S X : Scheme.{u}} {n : ℕ}
    {sX : X ⟶ S} (h : HasUnirationalParametrization n sX) : IsUnirationalOver sX :=
  ⟨⟨n, h⟩⟩

/-- A chosen fixed-dimensional parametrization implies unirationality. -/
theorem UnirationalParametrization.isUnirationalOver {S X : Scheme.{u}} {n : ℕ}
    {sX : X ⟶ S} (p : UnirationalParametrization n sX) : IsUnirationalOver sX :=
  p.toHasUnirationalParametrization.isUnirationalOver

/-- Postcomposing an unirational scheme by a dominant morphism over the base preserves
unirationality. -/
theorem IsUnirationalOver.postcomp {S X Y : Scheme.{u}} {sX : X ⟶ S} {sY : Y ⟶ S}
    [IsUnirationalOver sY] (f : Y ⟶ X) [IsDominant f] (hf : f ≫ sX = sY) :
    IsUnirationalOver sX := by
  obtain ⟨n, hn⟩ := IsUnirationalOver.exists_parametrization (sX := sY)
  exact (hn.postcomp f hf).isUnirationalOver

/-- Finite-dimensional birationality of `X` over `S` to relative affine `n`-space implies a
unirational parametrization of dimension `n`.

The partial isomorphism is oriented as a map **from** affine space **to** `X`, matching the
direction of a parametrization.
-/
theorem HasUnirationalParametrization.of_partialIso {S X : Scheme.{u}} {n : ℕ}
    {sX : X ⟶ S} (φ : Scheme.PartialIso (𝔸(ULift.{u} (Fin n); S)) X)
    (hφ : φ.IsOver (𝔸(ULift.{u} (Fin n); S) ↘ S) sX) :
    HasUnirationalParametrization n sX :=
  ⟨UnirationalParametrization.ofPartialIso φ hφ⟩

end BConicBundleMultisections

end
