/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.AlgebraicGeometry.IdealSheaf.Subscheme
public import Mathlib.AlgebraicGeometry.Morphisms.QuasiCompact
public import Mathlib.AlgebraicGeometry.Properties

/-!
# Integrality of scheme-theoretic images

Mathlib supplies the dominant corestriction `f.toImage`, but at the pinned revision does not
package the elementary fact that the scheme-theoretic image of an integral scheme is integral.
-/

@[expose] public section

open CategoryTheory
open scoped AlgebraicGeometry

namespace AlgebraicGeometry.Scheme

noncomputable section

universe u

variable {X Y : Scheme.{u}}

/-- The scheme-theoretic image of an irreducible scheme is irreducible. -/
theorem irreducibleSpace_image (f : X ⟶ Y) [QuasiCompact f] [IrreducibleSpace X] :
    IrreducibleSpace f.image := by
  have hdense : DenseRange (f.toImage.base) := IsDominant.denseRange (f := f.toImage)
  have huniv : IsIrreducible (Set.univ : Set X) := IrreducibleSpace.isIrreducible_univ X
  have hrange : IsIrreducible (Set.range ⇑f.toImage.base) := by
    simpa [Set.image_univ] using
      huniv.image (⇑f.toImage.base) (Scheme.Hom.continuous f.toImage).continuousOn
  have hclosure : IsIrreducible (closure (Set.range ⇑f.toImage.base)) := hrange.closure
  rw [hdense.closure_range] at hclosure
  exact { toPreirreducibleSpace := ⟨hclosure.2⟩, toNonempty := ⟨hclosure.1.choose⟩ }

/-- The scheme-theoretic image of a reduced scheme is reduced. -/
theorem isReduced_image (f : X ⟶ Y) [QuasiCompact f] [IsReduced X] : IsReduced f.image := by
  haveI hquot : ∀ U : Y.affineOpens,
      _root_.IsReduced ((Γ(Y, (U : Y.Opens)) : Type u) ⧸ f.ker.ideal U) := by
    intro U
    have hker : f.ker.ideal U = RingHom.ker (f.app U).hom := Scheme.Hom.ker_apply f U
    haveI : _root_.IsReduced (Γ(X, f ⁻¹ᵁ (U : Y.Opens))) := IsReduced.component_reduced _
    haveI : _root_.IsReduced ((Γ(Y, (U : Y.Opens)) : Type u) ⧸ RingHom.ker (f.app U).hom) :=
      isReduced_of_injective (RingHom.kerLift (f.app U).hom) (RingHom.kerLift_injective _)
    exact isReduced_of_injective (Ideal.quotEquivOfEq hker).toRingHom
      (Ideal.quotEquivOfEq hker).injective
  apply +allowSynthFailures @IsReduced.of_openCover
    (𝒰 := f.ker.subschemeCover.openCover)
  intro U
  haveI : _root_.IsReduced ((f.ker.subschemeCover.X U : CommRingCat.{u}) : Type u) := hquot U
  exact inferInstanceAs (IsReduced (Spec (f.ker.subschemeCover.X U)))

/-- The scheme-theoretic image of an integral scheme is integral. -/
theorem isIntegral_image (f : X ⟶ Y) [QuasiCompact f] [IsIntegral X] : IsIntegral f.image := by
  haveI := irreducibleSpace_image f
  haveI := isReduced_image f
  exact isIntegral_of_irreducibleSpace_of_isReduced _

end


end AlgebraicGeometry.Scheme
