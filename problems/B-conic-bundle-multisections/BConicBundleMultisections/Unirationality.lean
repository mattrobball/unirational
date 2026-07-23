/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.AlgebraicGeometry.AffineSpace
public import Mathlib.AlgebraicGeometry.Birational.Dominant
public import Mathlib.Tactic.MkIffOfInductiveProp

/-!
# Unirational parametrizations of schemes

This file defines chosen fixed-dimensional unirational parametrizations, their existence, and
finite-dimensional unirationality over a base scheme.
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

end BConicBundleMultisections

end
