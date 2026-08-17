/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import BConicBundleMultisections.GenericConicProjectivePoint
public import V14Formalization.SchemeProjectiveAction

/-!
# Reconstructing projective field-valued points from coordinates

This module imports Problem B's normalized-coordinate construction and proves
the extensionality statements needed to pass between a scheme morphism
`Spec L ⟶ P^n_k` and its homogeneous coordinates on a containing standard
chart. It does not assert compatibility with a projective group action; that
is a separate naturality theorem.
-/

noncomputable section

open CategoryTheory
open scoped AlgebraicGeometry

namespace V14Formalization.SchemeGeometry

universe u

open AlgebraicGeometry BConicBundleMultisections

attribute [local instance] MvPolynomial.gradedAlgebra

variable {k L : Type u} [Field k] [Field L] [Algebra k L]

/-- Two algebra-valued projective points reconstructed in the same normalized
chart are equal only if all of their normalized coordinates are equal. -/
public theorem normalizedCoordinates_eq_of_pointOfNormalizedCoordinatesAlgebra_eq
    (n : ℕ) (i : Fin (n + 1))
    (x y : Fin (n + 1) → L) (hxi : x i = 1) (hyi : y i = 1)
    (hpoint :
      ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n i x =
        ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n i y) :
    x = y := by
  apply funext
  intro l
  unfold ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra at hpoint
  have hspec := (cancel_mono (ProjectiveSpace.standardChartι n k i)).mp hpoint
  have hring := AlgebraicGeometry.Spec.map_inj.mp hspec
  have hfun := congrArg
    (fun q : CommRingCat.of (ProjectiveSpace.StandardChartRing n k i) ⟶
        CommRingCat.of L ↦
      q.hom (ProjectiveSpace.normalizedCoordinate n k i l)) hring
  simpa only [CommRingCat.hom_ofHom,
    standardChartEvalAlgebra_normalizedCoordinate n i x hxi l,
    standardChartEvalAlgebra_normalizedCoordinate n i y hyi l] using hfun

/-- A `k`-linear field-valued point of projective space is exactly the point
reconstructed from its mapped normalized residue coordinates on any standard
chart containing its image point. -/
public theorem fieldPoint_eq_pointOfMappedNormalizedResidueCoordinates
    (n : ℕ) (p : Spec (.of L) ⟶ ProjectiveSpace n k)
    (hpbase : p ≫ ProjectiveSpace.toSpec n k =
      Spec.map (CommRingCat.ofHom (algebraMap k L))) :
    let yf := Scheme.SpecToEquivOfField L (ProjectiveSpace n k) p
    ∀ (j : Fin (n + 1))
      (hy : yf.1 ∈ ProjectiveSpace.standardChart n k j),
      p = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j
        (fun l ↦ yf.2
          (ProjectiveSpace.normalizedResidueCoordinates n k yf.1 j hy l)) := by
  dsimp only
  intro j hy
  let yf := Scheme.SpecToEquivOfField L (ProjectiveSpace n k) p
  let y := yf.1
  let f : (ProjectiveSpace n k).residueField y →+* L := yf.2.hom
  have hp_reconstruct :
      Spec.map (CommRingCat.ofHom f) ≫
          (ProjectiveSpace n k).fromSpecResidueField y = p := by
    exact (Scheme.SpecToEquivOfField L (ProjectiveSpace n k)).symm_apply_apply p
  have hf : f.comp (ProjectiveSpace.residueCoefficientMap n k y) =
      algebraMap k L := by
    have hmorph :
        (Spec.map (CommRingCat.ofHom f) ≫
            (ProjectiveSpace n k).fromSpecResidueField y) ≫
              ProjectiveSpace.toSpec n k =
          Spec.map (CommRingCat.ofHom (algebraMap k L)) := by
      rw [hp_reconstruct]
      exact hpbase
    have hpre := congrArg Spec.preimage hmorph
    simpa [Spec.preimage_comp, ProjectiveSpace.residueCoefficientMap] using
      congrArg CommRingCat.Hom.hom hpre
  have hcoords :=
    pointOfNormalizedCoordinatesAlgebra_mapped_normalizedResidueCoordinates
      n y j hy f hf
  exact hp_reconstruct.symm.trans hcoords.symm

/-- Existential chart form of
`fieldPoint_eq_pointOfMappedNormalizedResidueCoordinates`. -/
public theorem exists_normalizedResidueCoordinates_for_fieldPoint
    (n : ℕ) (p : Spec (.of L) ⟶ ProjectiveSpace n k)
    (hpbase : p ≫ ProjectiveSpace.toSpec n k =
      Spec.map (CommRingCat.ofHom (algebraMap k L))) :
    ∃ (j : Fin (n + 1)) (x : Fin (n + 1) → L),
      x j = 1 ∧
      p = ProjectiveSpace.pointOfNormalizedCoordinatesAlgebra (R := k) n j x := by
  let yf := Scheme.SpecToEquivOfField L (ProjectiveSpace n k) p
  obtain ⟨j, hj⟩ := ProjectiveSpace.exists_mem_standardChart n k yf.1
  let x : Fin (n + 1) → L := fun l ↦ yf.2
    (ProjectiveSpace.normalizedResidueCoordinates n k yf.1 j hj l)
  refine ⟨j, x, ?_, ?_⟩
  · simp [x]
  · exact fieldPoint_eq_pointOfMappedNormalizedResidueCoordinates
      n p hpbase j hj

end V14Formalization.SchemeGeometry
