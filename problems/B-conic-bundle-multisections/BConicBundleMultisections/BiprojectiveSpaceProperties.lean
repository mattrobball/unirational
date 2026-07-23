/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveSpace
public import Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Proper

/-!
# Geometric properties of the biprojective ambient space

This file records properness and separatedness properties of projective and biprojective spaces,
as well as the quasi-compactness of the standard affine open immersions. These facts are used when
local ideal sheaves are extended from standard charts and when the two hypersurface projections
are studied.
-/

@[expose] public section

open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry

attribute [local instance] MvPolynomial.gradedAlgebra

namespace ProjectiveSpace

/-- Projective `n`-space is proper over its affine base scheme. -/
instance (n : ℕ) (R : Type u) [CommRing R] :
    IsProper (toSpec n R) := by
  unfold toSpec
  letI : IsScalarTower R
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)
      (MvPolynomial (Fin (n + 1)) R) :=
    IsScalarTower.of_algebraMap_eq fun r : R ↦
      show algebraMap R (MvPolynomial (Fin (n + 1)) R) r =
        algebraMap (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)
          (MvPolynomial (Fin (n + 1)) R)
          (algebraMap R (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0) r) from rfl
  haveI : Algebra.FiniteType
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)
      (MvPolynomial (Fin (n + 1)) R) := by
    exact Algebra.FiniteType.of_restrictScalars_finiteType R
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0)
      (MvPolynomial (Fin (n + 1)) R)
  let f : R →+* MvPolynomial.homogeneousSubmodule (Fin (n + 1)) R 0 :=
    algebraMap R _
  have hf : Function.Bijective f := by
    constructor
    · intro x y hxy
      apply MvPolynomial.C_injective (Fin (n + 1)) R
      exact congrArg Subtype.val hxy
    · intro x
      have hx : x.1 ∈ (1 : Submodule R (MvPolynomial (Fin (n + 1)) R)) := by
        rw [← MvPolynomial.homogeneousSubmodule_zero]
        exact x.2
      obtain ⟨r, hr⟩ := Submodule.mem_one.mp hx
      refine ⟨r, Subtype.ext ?_⟩
      exact hr
  letI : IsIso (CommRingCat.ofHom f) :=
    (ConcreteCategory.isIso_iff_bijective _).2 hf
  infer_instance

end ProjectiveSpace

namespace BiprojectiveSpace

/-- The first projection from a biprojective space is proper. -/
instance (m n : ℕ) (R : Type u) [CommRing R] :
    IsProper (fst m n R) := by
  infer_instance

/-- The second projection from a biprojective space is proper. -/
instance (m n : ℕ) (R : Type u) [CommRing R] :
    IsProper (snd m n R) := by
  infer_instance

/-- A biprojective space is proper over its affine base scheme. -/
instance (m n : ℕ) (R : Type u) [CommRing R] :
    IsProper (toSpec m n R) := by
  unfold toSpec
  infer_instance

instance (m n : ℕ) (R : Type u) [CommRing R] :
    Scheme.IsSeparated (BiprojectiveSpace m n R) := by
  letI : IsSeparated (toSpec m n R) := by
    change IsSeparated (fst m n R ≫ ProjectiveSpace.toSpec m R)
    infer_instance
  constructor
  rw [← terminal.comp_from (toSpec m n R)]
  infer_instance

instance (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    IsAffineHom (standardChartι m n R i j) := by
  let f := standardChartι m n R i j
  constructor
  intro V hV
  rw [← f.isAffineOpen_iff_of_isOpenImmersion, f.image_preimage_eq_opensRange_inf]
  exact (isAffineOpen_opensRange f).inf hV

instance (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    QuasiCompact (standardChartι m n R i j) := by
  infer_instance

/-- The range of a standard product chart, bundled as an affine open of the ambient space. -/
def standardChartAffineOpen (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (BiprojectiveSpace m n R).affineOpens :=
  ⟨(standardChartι m n R i j).opensRange,
    isAffineOpen_opensRange (standardChartι m n R i j)⟩

/-- The standard affine opens cover the biprojective ambient space. -/
theorem iSup_standardChartAffineOpen (m n : ℕ) (R : Type u) [CommRing R] :
    ⨆ ij : Fin (m + 1) × Fin (n + 1),
      (standardChartAffineOpen m n R ij.1 ij.2).1 = ⊤ :=
  (standardOpenCover m n R).iSup_opensRange

end BiprojectiveSpace

end

end BConicBundleMultisections
