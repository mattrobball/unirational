/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveZeroLocus
public import Mathlib.AlgebraicGeometry.Morphisms.Smooth

/-!
# Smoothness on affine charts of a biprojective zero locus

This file identifies each chartwise zero locus with the corresponding open subscheme of the
global biprojective zero locus. It then transports an assumed global smoothness hypothesis to
the affine chart and to its top-sections ring map. No dimension or integrality conclusion is
inserted into this local restriction step.
-/

@[expose] public section


open CategoryTheory Limits
open scoped AlgebraicGeometry

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry

namespace BiprojectiveSpace

/-- The canonical open immersion from a chartwise zero locus into the global biprojective zero
locus. -/
def chartZeroLocusToGlobal
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (chartIdealSheaf m n R i j F).subscheme ⟶
      biprojectiveZeroLocus m n R F :=
  (chartZeroLocusIsoPullback m n R F hF i j).hom ≫
    pullback.snd (standardChartι m n R i j)
      (biprojectiveZeroLocusι m n R F)

/-- The chartwise open immersion is compatible with the two closed immersions into the ambient
standard chart and biprojective space. -/
@[reassoc]
theorem chartZeroLocusToGlobal_ι
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    chartZeroLocusToGlobal m n R F hF i j ≫
        biprojectiveZeroLocusι m n R F =
      (chartIdealSheaf m n R i j F).subschemeι ≫
        standardChartι m n R i j := by
  unfold chartZeroLocusToGlobal
  rw [Category.assoc, ← pullback.condition]
  rw [← Category.assoc, chartZeroLocusIsoPullback_hom_fst]

/-- A chartwise zero locus is an open subscheme of the global zero locus. -/
instance
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    IsOpenImmersion (chartZeroLocusToGlobal m n R F hF i j) := by
  unfold chartZeroLocusToGlobal
  infer_instance

/-- The structure morphism of a chartwise zero locus, obtained by restricting the global
structure morphism. -/
def chartZeroLocusToSpec
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    (chartIdealSheaf m n R i j F).subscheme ⟶ Spec (.of R) :=
  chartZeroLocusToGlobal m n R F hF i j ≫
    biprojectiveZeroLocusToSpec m n R F

/-- Smoothness of the global zero locus restricts to each chartwise zero locus. -/
instance
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1))
    [Smooth (biprojectiveZeroLocusToSpec m n R F)] :
    Smooth (chartZeroLocusToSpec m n R F hF i j) := by
  unfold chartZeroLocusToSpec
  infer_instance

/-- Every chartwise zero locus is affine. -/
instance chartZeroLocusIsAffine
    (m n : ℕ) (R : Type u) [CommRing R]
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (i : Fin (m + 1)) (j : Fin (n + 1)) :
    IsAffine (chartIdealSheaf m n R i j F).subscheme :=
  (IsClosedImmersion.isAffine_surjective_of_isAffine
    (chartIdealSheaf m n R i j F).subschemeι).1

/-- Under global smoothness, the top-sections ring map of every affine zero-locus chart is
smooth. -/
theorem chartZeroLocus_appTop_smooth
    (m n : ℕ) (R : Type u) [CommRing R]
    {d e : ℕ} (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : IsBihomogeneousOfBidegree d e F)
    (i : Fin (m + 1)) (j : Fin (n + 1))
    [Smooth (biprojectiveZeroLocusToSpec m n R F)] :
    RingHom.Smooth
      ((chartZeroLocusToSpec m n R F hF i j).appTop).hom := by
  exact HasRingHomProperty.appTop @Smooth _ inferInstance

end BiprojectiveSpace

end

end BConicBundleMultisections
