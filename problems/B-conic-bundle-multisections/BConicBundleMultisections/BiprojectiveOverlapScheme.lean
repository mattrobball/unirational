/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveOverlap

/-!
# Scheme-theoretic intersections of standard biprojective charts

This file identifies the explicit overlap rings from `BiprojectiveOverlap` with the categorical
pullbacks of standard chart immersions.  For one projective-space factor the identification is
Mathlib's `Proj.pullbackAwayιIso`.  The product overlap is then assembled from the two one-factor
overlaps and shown to be the pullback of the two standard product charts.

These pullback squares connect the explicit transition-unit calculation with restriction of
ideal sheaves to actual scheme-theoretic chart intersections.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry TensorProduct

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry

attribute [local instance] MvPolynomial.gradedAlgebra

namespace ProjectiveSpace

/-- The standard open immersion of the intersection `D₊(Xᵢ) ∩ D₊(Xᵢ′)`. -/
def overlapι (n : ℕ) (R : Type u) [CommRing R] (i i' : Fin (n + 1)) :
    Spec (.of (OverlapRing n R i i')) ⟶ ProjectiveSpace n R :=
  Proj.awayι (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.X i * MvPolynomial.X i')
    (SetLike.mul_mem_graded (MvPolynomial.isHomogeneous_X R i)
      (MvPolynomial.isHomogeneous_X R i'))
    (by omega)

instance (n : ℕ) (R : Type u) [CommRing R] (i i' : Fin (n + 1)) :
    IsOpenImmersion (overlapι n R i i') := by
  dsimp [overlapι]
  infer_instance

@[reassoc]
theorem SpecMap_toOverlap_standardChartι
    (n : ℕ) (R : Type u) [CommRing R] (i i' : Fin (n + 1)) :
    Spec.map (CommRingCat.ofHom (toOverlap n R i i')) ≫ standardChartι n R i =
      overlapι n R i i' := by
  rw [toOverlap_eq_awayMap]
  exact Proj.SpecMap_awayMap_awayι
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.isHomogeneous_X R i)
    (show (0 : ℕ) < 1 by omega)
    (MvPolynomial.isHomogeneous_X R i') rfl

@[reassoc]
theorem SpecMap_fromOtherToOverlap_standardChartι
    (n : ℕ) (R : Type u) [CommRing R] (i i' : Fin (n + 1)) :
    Spec.map (CommRingCat.ofHom (fromOtherToOverlap n R i i')) ≫ standardChartι n R i' =
      overlapι n R i i' := by
  rw [fromOtherToOverlap_eq_awayMap]
  exact Proj.SpecMap_awayMap_awayι
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.isHomogeneous_X R i')
    (show (0 : ℕ) < 1 by omega)
    (MvPolynomial.isHomogeneous_X R i) (mul_comm _ _)

@[reassoc]
theorem overlapι_toSpec (n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (n + 1)) :
    overlapι n R i i' ≫ toSpec n R =
      Spec.map (CommRingCat.ofHom (algebraMap R (OverlapRing n R i i'))) := by
  rw [← SpecMap_toOverlap_standardChartι]
  rw [Category.assoc, standardChartι_toSpec, ← Spec.map_comp]
  congr 2
  ext r
  exact congrArg HomogeneousLocalization.val (toOverlap_algebraMap n R i i' r)

/-- The explicit one-factor overlap realizes the pullback of the two standard chart immersions. -/
theorem overlap_isPullback (n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (n + 1)) :
    IsPullback
      (Spec.map (CommRingCat.ofHom (toOverlap n R i i')))
      (Spec.map (CommRingCat.ofHom (fromOtherToOverlap n R i i')))
      (standardChartι n R i) (standardChartι n R i') := by
  let e := Proj.pullbackAwayιIso
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.isHomogeneous_X R i) (show (0 : ℕ) < 1 by omega)
    (MvPolynomial.isHomogeneous_X R i') (show (0 : ℕ) < 1 by omega) rfl
  apply IsPullback.of_iso_pullback
    (CommSq.mk
      (SpecMap_toOverlap_standardChartι n R i i' |>.trans
        (SpecMap_fromOtherToOverlap_standardChartι n R i i').symm))
    e.symm
  · rw [toOverlap_eq_awayMap]
    exact Proj.pullbackAwayιIso_inv_fst
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
      (MvPolynomial.isHomogeneous_X R i) (show (0 : ℕ) < 1 by omega)
      (MvPolynomial.isHomogeneous_X R i') (show (0 : ℕ) < 1 by omega) rfl
  · rw [fromOtherToOverlap_eq_awayMap]
    exact Proj.pullbackAwayιIso_inv_snd
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
      (MvPolynomial.isHomogeneous_X R i) (show (0 : ℕ) < 1 by omega)
      (MvPolynomial.isHomogeneous_X R i') (show (0 : ℕ) < 1 by omega) rfl

end ProjectiveSpace

namespace BiprojectiveSpace

/-- The affine scheme of the explicit tensor-product overlap ring. -/
abbrev overlapScheme (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) : Scheme.{u} :=
  Spec (.of (OverlapRing m n R i i' j j'))

/-- The first projection from the product overlap scheme. -/
abbrev overlapFst (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapScheme m n R i i' j j' ⟶ Spec (.of (ProjectiveSpace.OverlapRing m R i i')) :=
  Spec.map (CommRingCat.ofHom Algebra.TensorProduct.includeLeftRingHom)

/-- The second projection from the product overlap scheme. -/
abbrev overlapSnd (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapScheme m n R i i' j j' ⟶ Spec (.of (ProjectiveSpace.OverlapRing n R j j')) :=
  Spec.map (CommRingCat.ofHom Algebra.TensorProduct.includeRight.toRingHom)

/-- The tensor-product overlap scheme is the fiber product of the one-factor overlaps. -/
theorem overlapSpec_isPullback (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    IsPullback (overlapFst m n R i i' j j') (overlapSnd m n R i i' j j')
      (Spec.map (CommRingCat.ofHom
        (algebraMap R (ProjectiveSpace.OverlapRing m R i i'))))
      (Spec.map (CommRingCat.ofHom
        (algebraMap R (ProjectiveSpace.OverlapRing n R j j')))) := by
  apply IsPullback.of_iso_pullback (by
    refine ⟨?_⟩
    rw [← Spec.map_comp, ← Spec.map_comp]
    congr 1
    ext r
    simp [Algebra.TensorProduct.algebraMap_def])
    (pullbackSpecIso R (ProjectiveSpace.OverlapRing m R i i')
      (ProjectiveSpace.OverlapRing n R j j')).symm
  · exact pullbackSpecIso_inv_fst R (ProjectiveSpace.OverlapRing m R i i')
      (ProjectiveSpace.OverlapRing n R j j')
  · exact pullbackSpecIso_inv_snd R (ProjectiveSpace.OverlapRing m R i i')
      (ProjectiveSpace.OverlapRing n R j j')

/-- Restriction from the explicit overlap scheme to the first product chart. -/
def overlapToChart (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapScheme m n R i i' j j' ⟶ standardChart m n R i j :=
  Spec.map (CommRingCat.ofHom (chartToOverlap m n R i i' j j').toRingHom) ≫
    (standardChartIsoSpec m n R i j).inv

/-- Restriction from the explicit overlap scheme to the second product chart. -/
def overlapToOtherChart (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapScheme m n R i i' j j' ⟶ standardChart m n R i' j' :=
  Spec.map (CommRingCat.ofHom (otherChartToOverlap m n R i i' j j').toRingHom) ≫
    (standardChartIsoSpec m n R i' j').inv

@[reassoc]
theorem overlapToChart_fst (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapToChart m n R i i' j j' ≫ pullback.fst _ _ =
      overlapFst m n R i i' j j' ≫
        Spec.map (CommRingCat.ofHom (ProjectiveSpace.toOverlap m R i i')) := by
  rw [overlapToChart, Category.assoc, standardChartIsoSpec_inv_fst]
  rw [← Spec.map_comp, ← Spec.map_comp]
  congr 1
  ext x
  exact DFunLike.congr_fun (chartToOverlap_comp_includeLeft m n R i i' j j') x

@[reassoc]
theorem overlapToChart_snd (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapToChart m n R i i' j j' ≫ pullback.snd _ _ =
      overlapSnd m n R i i' j j' ≫
        Spec.map (CommRingCat.ofHom (ProjectiveSpace.toOverlap n R j j')) := by
  rw [overlapToChart, Category.assoc, standardChartIsoSpec_inv_snd]
  rw [← Spec.map_comp, ← Spec.map_comp]
  congr 1
  ext x
  exact DFunLike.congr_fun (chartToOverlap_comp_includeRight m n R i i' j j') x

@[reassoc]
theorem overlapToOtherChart_fst (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapToOtherChart m n R i i' j j' ≫ pullback.fst _ _ =
      overlapFst m n R i i' j j' ≫
        Spec.map (CommRingCat.ofHom (ProjectiveSpace.fromOtherToOverlap m R i i')) := by
  rw [overlapToOtherChart, Category.assoc, standardChartIsoSpec_inv_fst]
  rw [← Spec.map_comp, ← Spec.map_comp]
  congr 1
  ext x
  exact DFunLike.congr_fun (otherChartToOverlap_comp_includeLeft m n R i i' j j') x

@[reassoc]
theorem overlapToOtherChart_snd (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapToOtherChart m n R i i' j j' ≫ pullback.snd _ _ =
      overlapSnd m n R i i' j j' ≫
        Spec.map (CommRingCat.ofHom (ProjectiveSpace.fromOtherToOverlap n R j j')) := by
  rw [overlapToOtherChart, Category.assoc, standardChartIsoSpec_inv_snd]
  rw [← Spec.map_comp, ← Spec.map_comp]
  congr 1
  ext x
  exact DFunLike.congr_fun (otherChartToOverlap_comp_includeRight m n R i i' j j') x

/-- The open immersion of the explicit product overlap into the biprojective ambient space. -/
def overlapι (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapScheme m n R i i' j j' ⟶ BiprojectiveSpace m n R :=
  (pullbackSpecIso R (ProjectiveSpace.OverlapRing m R i i')
      (ProjectiveSpace.OverlapRing n R j j')).inv ≫
    pullback.map
      (Spec.map (CommRingCat.ofHom
        (algebraMap R (ProjectiveSpace.OverlapRing m R i i'))))
      (Spec.map (CommRingCat.ofHom
        (algebraMap R (ProjectiveSpace.OverlapRing n R j j'))))
      (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)
      (ProjectiveSpace.overlapι m R i i') (ProjectiveSpace.overlapι n R j j') (𝟙 _)
      (by simpa using (ProjectiveSpace.overlapι_toSpec m R i i').symm)
      (by simpa using (ProjectiveSpace.overlapι_toSpec n R j j').symm)

instance (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    IsOpenImmersion (overlapι m n R i i' j j') := by
  dsimp [overlapι]
  infer_instance

@[reassoc]
theorem overlapι_fst (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapι m n R i i' j j' ≫ fst m n R =
      overlapFst m n R i i' j j' ≫ ProjectiveSpace.overlapι m R i i' := by
  unfold overlapι
  rw [Category.assoc]
  dsimp only [pullback.map, fst]
  erw [pullback.lift_fst]
  rw [← Category.assoc, pullbackSpecIso_inv_fst]

@[reassoc]
theorem overlapι_snd (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapι m n R i i' j j' ≫ snd m n R =
      overlapSnd m n R i i' j j' ≫ ProjectiveSpace.overlapι n R j j' := by
  unfold overlapι
  rw [Category.assoc]
  dsimp only [pullback.map, snd]
  erw [pullback.lift_snd]
  rw [← Category.assoc, pullbackSpecIso_inv_snd]
  rfl

@[reassoc]
theorem overlapToChart_standardChartι
    (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapToChart m n R i i' j j' ≫ standardChartι m n R i j =
      overlapι m n R i i' j j' := by
  apply pullback.hom_ext
  · rw [Category.assoc, standardChartι_fst, ← Category.assoc, overlapToChart_fst,
      Category.assoc, ProjectiveSpace.SpecMap_toOverlap_standardChartι, overlapι_fst]
  · rw [Category.assoc, standardChartι_snd, ← Category.assoc, overlapToChart_snd,
      Category.assoc, ProjectiveSpace.SpecMap_toOverlap_standardChartι, overlapι_snd]

@[reassoc]
theorem overlapToOtherChart_standardChartι
    (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    overlapToOtherChart m n R i i' j j' ≫ standardChartι m n R i' j' =
      overlapι m n R i i' j j' := by
  apply pullback.hom_ext
  · rw [Category.assoc, standardChartι_fst, ← Category.assoc, overlapToOtherChart_fst,
      Category.assoc, ProjectiveSpace.SpecMap_fromOtherToOverlap_standardChartι, overlapι_fst]
  · rw [Category.assoc, standardChartι_snd, ← Category.assoc, overlapToOtherChart_snd,
      Category.assoc, ProjectiveSpace.SpecMap_fromOtherToOverlap_standardChartι, overlapι_snd]

/-- The commutative square from the explicit overlap to two standard product charts. -/
theorem overlap_commSq (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    CommSq (overlapToChart m n R i i' j j') (overlapToOtherChart m n R i i' j j')
      (standardChartι m n R i j) (standardChartι m n R i' j') :=
  ⟨(overlapToChart_standardChartι m n R i i' j j').trans
    (overlapToOtherChart_standardChartι m n R i i' j j').symm⟩

/-- The explicit product overlap realizes the pullback of two standard chart immersions. -/
theorem overlap_isPullback (m n : ℕ) (R : Type u) [CommRing R]
    (i i' : Fin (m + 1)) (j j' : Fin (n + 1)) :
    IsPullback (overlapToChart m n R i i' j j')
      (overlapToOtherChart m n R i i' j j')
      (standardChartι m n R i j) (standardChartι m n R i' j') := by
  let h₁ := ProjectiveSpace.overlap_isPullback m R i i'
  let h₂ := ProjectiveSpace.overlap_isPullback n R j j'
  let hT := overlapSpec_isPullback m n R i i' j j'
  refine IsPullback.mk' (overlap_commSq m n R i i' j j').w ?_ ?_
  · intro T φ φ' hφ hφ'
    apply hT.hom_ext
    · apply h₁.hom_ext
      · simpa only [Category.assoc, overlapToChart_fst] using
          congrArg (fun k => k ≫ pullback.fst _ _) hφ
      · simpa only [Category.assoc, overlapToOtherChart_fst] using
          congrArg (fun k => k ≫ pullback.fst _ _) hφ'
    · apply h₂.hom_ext
      · simpa only [Category.assoc, overlapToChart_snd] using
          congrArg (fun k => k ≫ pullback.snd _ _) hφ
      · simpa only [Category.assoc, overlapToOtherChart_snd] using
          congrArg (fun k => k ≫ pullback.snd _ _) hφ'
  · intro T a b hab
    have hab₁ :
        (a ≫ pullback.fst _ _) ≫ ProjectiveSpace.standardChartι m R i =
          (b ≫ pullback.fst _ _) ≫ ProjectiveSpace.standardChartι m R i' := by
      simpa only [Category.assoc, standardChartι_fst] using
        congrArg (fun k => k ≫ fst m n R) hab
    have hab₂ :
        (a ≫ pullback.snd _ _) ≫ ProjectiveSpace.standardChartι n R j =
          (b ≫ pullback.snd _ _) ≫ ProjectiveSpace.standardChartι n R j' := by
      simpa only [Category.assoc, standardChartι_snd] using
        congrArg (fun k => k ≫ snd m n R) hab
    let l₁ := h₁.lift (a ≫ pullback.fst _ _) (b ≫ pullback.fst _ _) hab₁
    let l₂ := h₂.lift (a ≫ pullback.snd _ _) (b ≫ pullback.snd _ _) hab₂
    have hl :
        l₁ ≫ Spec.map (CommRingCat.ofHom
            (algebraMap R (ProjectiveSpace.OverlapRing m R i i'))) =
          l₂ ≫ Spec.map (CommRingCat.ofHom
            (algebraMap R (ProjectiveSpace.OverlapRing n R j j'))) := by
      rw [← ProjectiveSpace.overlapι_toSpec, ← ProjectiveSpace.overlapι_toSpec]
      rw [← ProjectiveSpace.SpecMap_toOverlap_standardChartι,
        ← ProjectiveSpace.SpecMap_toOverlap_standardChartι]
      simp only [Category.assoc, l₁, l₂, IsPullback.lift_fst_assoc]
      exact congrArg (fun k => a ≫ k) pullback.condition
    let l := hT.lift l₁ l₂ hl
    refine ⟨l, ?_, ?_⟩
    · apply pullback.hom_ext
      · simp [l, l₁, overlapToChart_fst]
      · simp [l, l₂, overlapToChart_snd]
    · apply pullback.hom_ext
      · simp [l, l₁, overlapToOtherChart_fst]
      · simp [l, l₂, overlapToOtherChart_snd]

end BiprojectiveSpace

end


end BConicBundleMultisections
