/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.UnirationalTower

/-!
# Fixed-dimensional unirationality across a birational target

The project already turns a birational model *equal to affine space* into a parametrization.
For the open-base pointed-conic route one also needs the elementary invariance of an existing
fixed-dimensional parametrization under a birational replacement of its target.  The proof is at
the partial-map level, so it reuses the strict representatives and composition identity of
`UnirationalTower` and introduces no function-field hypotheses.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry

/-- Transfer a fixed-dimensional unirational parametrization from `Y` to a scheme birational to
`Y` over the same base. -/
theorem HasUnirationalParametrization.of_birationalOver
    {S X Y : Scheme.{u}} {n : ℕ} {sX : X ⟶ S} {sY : Y ⟶ S}
    [PreirreducibleSpace (𝔸(ULift.{u} (Fin n); S))]
    [Nonempty (𝔸(ULift.{u} (Fin n); S))]
    (hY : HasUnirationalParametrization n sY)
    (hbir : Scheme.BirationalOver sX sY) :
    HasUnirationalParametrization n sX := by
  letI : Nonempty Y := nonempty_of_hasUnirationalParametrization hY
  obtain ⟨q⟩ := hY
  obtain ⟨f, hfdom, -, hfover⟩ := exists_isOver_representative q
  let g : Y.PartialMap X := hbir.partialIso.symm.toPartialMap
  haveI : IsDominant f.hom := hfdom
  haveI : IsDominant g.hom := by
    haveI : IsDominant hbir.partialIso.symm.target.ι :=
      Opens.isDominant_ι hbir.partialIso.symm.dense_target
    dsimp [g, Scheme.PartialIso.toPartialMap]
    infer_instance
  have hgover : g.hom ≫ sX = g.domain.ι ≫ sY := by
    exact hbir.partialIso_isOver.symm
  have hover := comp_hom_over f g
    (𝔸(ULift.{u} (Fin n); S) ↘ S) sY sX hfover hgover
  exact ⟨UnirationalParametrization.ofPartialMapOver sX (f.comp g) hover⟩

/-- Fixed-dimensional unirationality is invariant under birational replacement of the target,
provided the affine source is nonempty. -/
theorem hasUnirationalParametrization_iff_of_birationalOver
    {S X Y : Scheme.{u}} {n : ℕ} {sX : X ⟶ S} {sY : Y ⟶ S}
    [PreirreducibleSpace (𝔸(ULift.{u} (Fin n); S))]
    [Nonempty (𝔸(ULift.{u} (Fin n); S))]
    (hbir : Scheme.BirationalOver sX sY) :
    HasUnirationalParametrization n sX ↔
      HasUnirationalParametrization n sY := by
  constructor
  · intro hX
    exact hX.of_birationalOver hbir.symm
  · intro hY
    exact hY.of_birationalOver hbir

end

end BConicBundleMultisections
