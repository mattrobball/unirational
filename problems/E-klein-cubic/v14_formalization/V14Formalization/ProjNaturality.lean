/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import BConicBundleMultisections.LinearCoordinateChange

/-!
# Naturality of the structure morphism of `Proj`

This supplies the base-compatibility lemma needed to regard the projective
linear actions imported from Problem B as actions over `Spec k`.
-/

noncomputable section

universe u

open CategoryTheory
open HomogeneousIdeal HomogeneousLocalization TopologicalSpace Graded
open AlgebraicGeometry ProjectiveSpectrum

namespace AlgebraicGeometry.Proj

variable {A B σ τ : Type u}
  [CommRing A] [SetLike σ A] [AddSubgroupClass σ A]
  [CommRing B] [SetLike τ B] [AddSubgroupClass τ B]
  {𝒶 : ℕ → σ} {ℬ : ℕ → τ} [GradedRing 𝒶] [GradedRing ℬ]

private theorem awayMap_comp_fromZero (f : 𝒶 →+*ᵍ ℬ) (s : A) :
    (Away.map f s).comp
        (fromZeroRingHom 𝒶 (.powers s) : 𝒶 0 →+* Away 𝒶 s) =
      (fromZeroRingHom ℬ (.powers (f s)) : ℬ 0 →+* Away ℬ (f s)).comp
        (f.gradedZeroRingHom : 𝒶 0 →+* ℬ 0) := by
  apply RingHom.ext
  intro x
  apply HomogeneousLocalization.val_injective
  simp [fromZeroRingHom, Away.map, HomogeneousLocalization.map_mk]

/-- Naturality of the structure morphism of `Proj` under a graded ring map. -/
theorem map_toSpecZero (f : 𝒶 →+*ᵍ ℬ) (hf : ℬ₊ ≤ 𝒶₊.map f) :
    map f hf ≫ toSpecZero 𝒶 =
      toSpecZero ℬ ≫ Spec.map (CommRingCat.ofHom f.gradedZeroRingHom) := by
  refine (mapAffineOpenCover f hf).openCover.hom_ext _ _ fun s ↦ ?_
  rcases s with ⟨i, s⟩
  simp only [Scheme.AffineOpenCover.openCover_f, mapAffineOpenCover_f]
  change
    (awayι ℬ (f (s : A)) (map_mem f s.2) i.pos ≫
      map f hf ≫ toSpecZero 𝒶) =
      (awayι ℬ (f (s : A)) (map_mem f s.2) i.pos ≫
        toSpecZero ℬ ≫
        Spec.map (CommRingCat.ofHom f.gradedZeroRingHom))
  rw [← Category.assoc]
  rw [awayι_comp_map f hf i.pos (s : A) s.2]
  rw [Category.assoc, awayι_toSpecZero]
  rw [awayι_toSpecZero_assoc]
  rw [← Spec.map_comp, ← Spec.map_comp]
  congr 1
  simpa using congrArg CommRingCat.ofHom (awayMap_comp_fromZero f s)

end AlgebraicGeometry.Proj

namespace BConicBundleMultisections

open AlgebraicGeometry HomogeneousIdeal MvPolynomial ProjectiveSpace

attribute [local instance] MvPolynomial.gradedAlgebra

variable {k : Type u} [CommRing k]

private theorem linearSubst_zero_comp_algebraMap (n : ℕ)
    (M : Matrix (Fin (n + 1)) (Fin (n + 1)) k) :
    (linearSubstGradedRingHom n M).gradedZeroRingHom.comp
        (algebraMap k
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k 0)) =
      algebraMap k
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k 0) := by
  apply RingHom.ext
  intro r
  apply Subtype.ext
  simp [linearSubstGradedRingHom]

/-- Every projective linear coordinate change is a morphism over `Spec k`. -/
theorem mapLinearSubst_toSpec (n : ℕ)
    (M N : Matrix (Fin (n + 1)) (Fin (n + 1)) k) (h : N * M = 1) :
    mapLinearSubst n M N h ≫ ProjectiveSpace.toSpec n k =
      ProjectiveSpace.toSpec n k := by
  unfold mapLinearSubst ProjectiveSpace.toSpec
  rw [← Category.assoc, AlgebraicGeometry.Proj.map_toSpecZero]
  rw [Category.assoc, ← Spec.map_comp]
  have hz :
      CommRingCat.ofHom
          (algebraMap k
            (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k 0)) ≫
        CommRingCat.ofHom
          (linearSubstGradedRingHom n M).gradedZeroRingHom =
      CommRingCat.ofHom
        (algebraMap k
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k 0)) := by
    simpa using congrArg CommRingCat.ofHom
      (linearSubst_zero_comp_algebraMap n M)
  rw [hz]

end BConicBundleMultisections
