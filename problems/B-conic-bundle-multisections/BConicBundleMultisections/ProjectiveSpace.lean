/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic
public import Mathlib.AlgebraicGeometry.Pullbacks
public import Mathlib.RingTheory.MvPolynomial.Homogeneous
public import Mathlib.RingTheory.MvPolynomial.Ideal

/-!
# Projective spaces and their fiber products

This file defines scheme-level projective `n`-space over a commutative ring using Mathlib's
projective spectrum.  Its homogeneous coordinates are indexed by `Fin (n + 1)`, so `n` is the
geometric dimension.  It also defines `ℙᵐ ×_S ℙⁿ` as a categorical pullback over the base scheme.

The definitions retain their natural generality over arbitrary dimensions and an arbitrary
commutative base ring.  The `(2, 2)` specialization is introduced separately for the final
bidegree `(2, 3)` threefold theorem.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry

attribute [local instance] MvPolynomial.gradedAlgebra

/-- Scheme-level projective `n`-space over a commutative ring `R`. -/
abbrev ProjectiveSpace (n : ℕ) (R : Type u) [CommRing R] : Scheme.{u} :=
  Proj (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)

namespace ProjectiveSpace

/-- The structure morphism from projective `n`-space over `R` to `Spec R`. -/
def toSpec (n : ℕ) (R : Type u) [CommRing R] : ProjectiveSpace n R ⟶ Spec (.of R) :=
  Proj.toSpecZero (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) ≫
    Spec.map (CommRingCat.ofHom
      (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)))

instance (n : ℕ) (R : Type u) [CommRing R] :
    (ProjectiveSpace n R).CanonicallyOver (Spec (.of R)) where
  hom := toSpec n R

/-- The degree-zero homogeneous localization defining the `i`-th standard affine chart. -/
abbrev StandardChartRing (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) : Type u :=
  HomogeneousLocalization.Away (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.X i)

/-- The canonical ring homomorphism from `R` to the ring of the `i`-th standard chart. -/
def standardChartRingHom (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    R →+* StandardChartRing n R i :=
  (algebraMap (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)
    (StandardChartRing n R i)).comp
      (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0))

/-- The canonical `R`-algebra structure on a standard projective-space chart. -/
instance standardChartRingAlgebra (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) : Algebra R (StandardChartRing n R i) where
  smul := (inferInstance : SMul R (StandardChartRing n R i)).smul
  algebraMap := standardChartRingHom n R i
  commutes' _ _ := mul_comm _ _
  smul_def' r x := by
    apply HomogeneousLocalization.val_injective
    rw [HomogeneousLocalization.val_smul, HomogeneousLocalization.val_mul, Algebra.smul_def]
    rfl

/-- The `i`-th standard open subset `D₊(Xᵢ)` of projective `n`-space. -/
def standardChart (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    (ProjectiveSpace n R).Opens :=
  Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) (MvPolynomial.X i)

/-- The standard open immersion `Spec (R[X₀, …, Xₙ]_(Xᵢ))₀ ⟶ ℙⁿ_R`. -/
def standardChartι (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    Spec (.of (StandardChartRing n R i)) ⟶ ProjectiveSpace n R :=
  Proj.awayι (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) (MvPolynomial.X i)
    (MvPolynomial.isHomogeneous_X R i) zero_lt_one

instance (n : ℕ) (R : Type u) [CommRing R] (i : Fin (n + 1)) :
    IsOpenImmersion (standardChartι n R i) :=
  show IsOpenImmersion
    (Proj.awayι (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R) (MvPolynomial.X i)
      (MvPolynomial.isHomogeneous_X R i) zero_lt_one) from
    inferInstance

@[simp]
theorem opensRange_standardChartι (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) :
    (standardChartι n R i).opensRange = standardChart n R i :=
  Proj.opensRange_awayι (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.X i) (MvPolynomial.isHomogeneous_X R i) zero_lt_one

@[reassoc]
theorem standardChartι_toSpec (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) :
    standardChartι n R i ≫ toSpec n R =
      Spec.map (CommRingCat.ofHom (algebraMap R (StandardChartRing n R i))) := by
  unfold standardChartι toSpec
  rw [Proj.awayι_toSpecZero_assoc, ← Spec.map_comp]
  change Spec.map (CommRingCat.ofHom (standardChartRingHom n R i)) = _
  rfl

/-- Every standard chart of projective space is affine. -/
theorem isAffineOpen_standardChart (n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (n + 1)) : IsAffineOpen (standardChart n R i) :=
  Proj.isAffineOpen_basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.X i) (MvPolynomial.isHomogeneous_X R i) zero_lt_one

/-- The irrelevant ideal of the homogeneous coordinate ring is generated by the variables. -/
theorem irrelevant_le_span_X (n : ℕ) (R : Type u) [CommRing R] :
    (HomogeneousIdeal.irrelevant
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)).toIdeal ≤
      Ideal.span (Set.range
        (MvPolynomial.X : Fin (n + 1) → MvPolynomial (Fin (n + 1)) R)) := by
  rw [HomogeneousIdeal.toIdeal_irrelevant_le]
  intro d hd p hp
  change p ∈ MvPolynomial.idealOfVars (Fin (n + 1)) R
  rw [← pow_one (MvPolynomial.idealOfVars (Fin (n + 1)) R),
    MvPolynomial.mem_pow_idealOfVars_iff]
  intro monomial hmonomial
  rw [Finsupp.degree_apply, ← hp.degree_eq_sum_deg_support hmonomial]
  exact Nat.succ_le_iff.mpr hd

/-- The affine open cover of projective `n`-space by its standard charts. -/
@[simps! f]
def standardAffineOpenCover (n : ℕ) (R : Type u) [CommRing R] :
    (ProjectiveSpace n R).AffineOpenCover :=
  Proj.affineOpenCoverOfIrrelevantLESpan
    (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R)
    (MvPolynomial.X : Fin (n + 1) → MvPolynomial (Fin (n + 1)) R)
    (fun i ↦ MvPolynomial.isHomogeneous_X R i) (fun _ ↦ zero_lt_one)
    (irrelevant_le_span_X n R)

end ProjectiveSpace

/-- The scheme `ℙᵐ_R ×_{Spec R} ℙⁿ_R`. -/
abbrev BiprojectiveSpace (m n : ℕ) (R : Type u) [CommRing R] : Scheme.{u} :=
  pullback (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)

namespace BiprojectiveSpace

/-- The first projection from `ℙᵐ_R ×_{Spec R} ℙⁿ_R`. -/
abbrev fst (m n : ℕ) (R : Type u) [CommRing R] :
    BiprojectiveSpace m n R ⟶ ProjectiveSpace m R :=
  pullback.fst (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)

/-- The second projection from `ℙᵐ_R ×_{Spec R} ℙⁿ_R`. -/
abbrev snd (m n : ℕ) (R : Type u) [CommRing R] :
    BiprojectiveSpace m n R ⟶ ProjectiveSpace n R :=
  pullback.snd (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)

/-- The structure morphism from `ℙᵐ_R ×_{Spec R} ℙⁿ_R` to `Spec R`. -/
def toSpec (m n : ℕ) (R : Type u) [CommRing R] :
    BiprojectiveSpace m n R ⟶ Spec (.of R) :=
  fst m n R ≫ ProjectiveSpace.toSpec m R

instance (m n : ℕ) (R : Type u) [CommRing R] :
    (BiprojectiveSpace m n R).CanonicallyOver (Spec (.of R)) where
  hom := toSpec m n R

@[reassoc]
theorem fst_toSpec (m n : ℕ) (R : Type u) [CommRing R] :
    fst m n R ≫ ProjectiveSpace.toSpec m R = toSpec m n R :=
  rfl

@[reassoc]
theorem snd_toSpec (m n : ℕ) (R : Type u) [CommRing R] :
    snd m n R ≫ ProjectiveSpace.toSpec n R = toSpec m n R :=
  (pullback.condition : fst m n R ≫ ProjectiveSpace.toSpec m R =
    snd m n R ≫ ProjectiveSpace.toSpec n R).symm

/-- The tensor-product coordinate ring of a standard chart of `ℙᵐ_R ×_R ℙⁿ_R`. -/
abbrev StandardChartRing (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) : Type u :=
  TensorProduct R (ProjectiveSpace.StandardChartRing m R i)
    (ProjectiveSpace.StandardChartRing n R j)

/-- The pullback of standard charts of `ℙᵐ_R` and `ℙⁿ_R` over `Spec R`. -/
abbrev standardChart (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) : Scheme.{u} :=
  pullback
    (ProjectiveSpace.standardChartι m R i ≫ ProjectiveSpace.toSpec m R)
    (ProjectiveSpace.standardChartι n R j ≫ ProjectiveSpace.toSpec n R)

/-- The tensor-product spectrum is a pullback of the two standard affine charts over `Spec R`. -/
theorem standardChartSpec_isPullback (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    IsPullback
      (Spec.map (CommRingCat.ofHom Algebra.TensorProduct.includeLeftRingHom))
      (Spec.map (CommRingCat.ofHom
        (Algebra.TensorProduct.includeRight
          (R := R)
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom))
      (ProjectiveSpace.standardChartι m R i ≫ ProjectiveSpace.toSpec m R)
      (ProjectiveSpace.standardChartι n R j ≫ ProjectiveSpace.toSpec n R) := by
  rw [ProjectiveSpace.standardChartι_toSpec, ProjectiveSpace.standardChartι_toSpec]
  apply IsPullback.of_iso_pullback (by
      refine ⟨?_⟩
      rw [← Spec.map_comp, ← Spec.map_comp]
      congr 1
      ext r
      simp [Algebra.TensorProduct.algebraMap_def])
    (pullbackSpecIso R (ProjectiveSpace.StandardChartRing m R i)
      (ProjectiveSpace.StandardChartRing n R j)).symm
  · exact pullbackSpecIso_inv_fst R _ _
  · exact pullbackSpecIso_inv_snd R _ _

/-- A standard product chart is the spectrum of the tensor product of its two chart rings. -/
def standardChartIsoSpec (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    standardChart m n R i j ≅ Spec (.of (StandardChartRing m n R i j)) :=
  (standardChartSpec_isPullback m n R i j).isoPullback.symm

@[reassoc]
theorem standardChartIsoSpec_inv_fst (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (standardChartIsoSpec m n R i j).inv ≫ pullback.fst _ _ =
      Spec.map (CommRingCat.ofHom Algebra.TensorProduct.includeLeftRingHom) :=
  (standardChartSpec_isPullback m n R i j).isoPullback_hom_fst

@[reassoc]
theorem standardChartIsoSpec_inv_snd (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (standardChartIsoSpec m n R i j).inv ≫ pullback.snd _ _ =
      Spec.map (CommRingCat.ofHom
        (Algebra.TensorProduct.includeRight
          (R := R)
          (A := ProjectiveSpace.StandardChartRing m R i)
          (B := ProjectiveSpace.StandardChartRing n R j)).toRingHom) :=
  (standardChartSpec_isPullback m n R i j).isoPullback_hom_snd

/-- The standard affine open cover of `ℙᵐ_R ×_R ℙⁿ_R`. -/
def standardOpenCover (m n : ℕ) (R : Type u) [CommRing R] :
    (BiprojectiveSpace m n R).OpenCover :=
  Scheme.Pullback.openCoverOfLeftRight
    (ProjectiveSpace.standardAffineOpenCover m R).openCover
    (ProjectiveSpace.standardAffineOpenCover n R).openCover
    (ProjectiveSpace.toSpec m R) (ProjectiveSpace.toSpec n R)

/-- The standard open immersion from the product chart indexed by `(i, j)`. -/
abbrev standardChartι (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    standardChart m n R i j ⟶ BiprojectiveSpace m n R :=
  (standardOpenCover m n R).f (i, j)

instance (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    IsOpenImmersion (standardChartι m n R i j) :=
  (standardOpenCover m n R).map_prop (i, j)

@[reassoc]
theorem standardChartι_fst (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    standardChartι m n R i j ≫ fst m n R =
      pullback.fst _ _ ≫ ProjectiveSpace.standardChartι m R i := by
  simp only [standardChartι, standardOpenCover,
    Scheme.Pullback.openCoverOfLeftRight_f]
  dsimp [pullback.map, fst]
  erw [pullback.lift_fst]
  rfl

@[reassoc]
theorem standardChartι_snd (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    standardChartι m n R i j ≫ snd m n R =
      pullback.snd _ _ ≫ ProjectiveSpace.standardChartι n R j := by
  simp only [standardChartι, standardOpenCover,
    Scheme.Pullback.openCoverOfLeftRight_f]
  dsimp [pullback.map, snd]
  erw [pullback.lift_snd]
  rfl

/-- A standard-cover object is the spectrum of its tensor-product coordinate ring. -/
def standardOpenCoverObjIso (m n : ℕ) (R : Type u) [CommRing R]
    (ij : Fin (m + 1) × Fin (n + 1)) :
    (standardOpenCover m n R).X ij ≅ Spec (.of (StandardChartRing m n R ij.1 ij.2)) := by
  change standardChart m n R ij.1 ij.2 ≅ Spec (.of (StandardChartRing m n R ij.1 ij.2))
  exact standardChartIsoSpec m n R ij.1 ij.2

end BiprojectiveSpace

end

end BConicBundleMultisections
