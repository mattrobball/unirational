/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.DeterminantHomogeneous
public import BConicBundleMultisections.GenericConicNondegeneracy
public import BConicBundleMultisections.StereoJacobian

/-!
# The homogeneous discriminant of the second conic projection

For a bidegree-`(2,3)` equation, regard the first block as the variables of a ternary quadratic
and the second block as coefficients in the homogeneous coordinate ring of `P^2_y`.  The
determinant of its polar matrix is the homogeneous conic-discriminant form.  This module gives the
global form and compares it with the affine standard-chart form already used by
`GenericConicNondegeneracy`.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open AlgebraicGeometry MvPolynomial BiprojectiveSpace
open _root_.MvPolynomial
open scoped Matrix

attribute [local instance] MvPolynomial.gradedAlgebra

/-- The universal second-projection conic: the `x` block remains polynomial variables and the
`y` block becomes the coefficient variables of another ternary polynomial ring. -/
def universalSndConic
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    MvPolynomial (Fin 3) (MvPolynomial (Fin 3) k) :=
  specializeSecondCoordinates (fun j => X j)
    (map (C : k →+* MvPolynomial (Fin 3) k) F)

/-- Evaluating the first variables of the universal conic recovers ordinary first-block
specialization, now viewed as a polynomial in the homogeneous `y` variables. -/
theorem eval_universalSndConic
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (x : Fin 3 → k) :
    eval (fun i => C (x i)) (universalSndConic F) =
      specializeFirstCoordinates x F := by
  rw [universalSndConic, eval_specializeSecondCoordinates]
  induction F using MvPolynomial.induction_on with
  | C a => simp
  | add P Q hP hQ => simp [hP, hQ]
  | mul_X P z hP =>
      rcases z with i | j
      · simp [hP]
      · simp [hP]

/-- The homogeneous discriminant of the conic bundle over `P^2_y`. -/
def sndConicDiscriminant
    {k : Type u} [CommRing k]
  (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) : MvPolynomial (Fin 3) k :=
  (polarMatrix (universalSndConic F)).det

/-- Every entry of the universal polar matrix is a cubic form in the base coordinates. -/
theorem polarMatrix_universalSndConic_entry_isHomogeneous
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (i j : Fin 3) :
    ((polarMatrix (universalSndConic F)) i j).IsHomogeneous 3 := by
  let ei : Fin 3 → k := Pi.single i 1
  let ej : Fin 3 → k := Pi.single j 1
  have hei : (Pi.single i (1 : MvPolynomial (Fin 3) k)) = fun a => C (ei a) := by
    funext a
    by_cases h : a = i
    · subst h
      simp [ei, Pi.single_eq_same]
    · simp [ei, Pi.single_eq_of_ne h]
  have hej : (Pi.single j (1 : MvPolynomial (Fin 3) k)) = fun a => C (ej a) := by
    funext a
    by_cases h : a = j
    · subst h
      simp [ej, Pi.single_eq_same]
    · simp [ej, Pi.single_eq_of_ne h]
  have heij : (fun a : Fin 3 =>
      (C (ei a) : MvPolynomial (Fin 3) k) + C (ej a)) =
      fun a => (C (ei a + ej a) : MvPolynomial (Fin 3) k) := by
    funext a
    rw [map_add]
  rw [polarMatrix_apply, polarEval, hei, hej, heij,
    eval_universalSndConic, eval_universalSndConic, eval_universalSndConic]
  exact ((hF.specializeFirstCoordinates_isHomogeneous fun a => ei a + ej a).sub
    (hF.specializeFirstCoordinates_isHomogeneous ei)).sub
      (hF.specializeFirstCoordinates_isHomogeneous ej)

/-- The conic-discriminant form has degree nine in the homogeneous base coordinates. -/
theorem sndConicDiscriminant_isHomogeneous
    {k : Type u} [CommRing k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F) :
    (sndConicDiscriminant F).IsHomogeneous 9 := by
  have hdet := Matrix.det_isHomogeneous (polarMatrix (universalSndConic F)) 3
    (polarMatrix_universalSndConic_entry_isHomogeneous F hF)
  simpa [sndConicDiscriminant] using hdet

/-- Evaluation of homogeneous `y`-coordinates on the `j`th standard chart. -/
def sndConicStandardChartEval
    {k : Type u} [Field k] (j : Fin 3) :
    MvPolynomial (Fin 3) k →ₐ[k] ProjectiveSpace.StandardChartRing 2 k j :=
  aeval fun l => ProjectiveSpace.normalizedCoordinate 2 k j l

@[simp]
theorem sndConicStandardChartEval_X
    {k : Type u} [Field k] (j l : Fin 3) :
    sndConicStandardChartEval j (X l) =
      ProjectiveSpace.normalizedCoordinate 2 k j l := by
  simp [sndConicStandardChartEval]

/-- The universal homogeneous conic dehomogenizes to the conic used on a standard base chart. -/
theorem map_universalSndConic_standardChart
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (j : Fin 3) :
    map (sndConicStandardChartEval j).toRingHom (universalSndConic F) =
      specializeSecondCoordinates
        (fun l => ProjectiveSpace.normalizedCoordinate 2 k j l)
        (map (algebraMap k (ProjectiveSpace.StandardChartRing 2 k j)) F) := by
  rw [universalSndConic, map_specializeSecondCoordinates, MvPolynomial.map_map]
  have hcoeff : (sndConicStandardChartEval j).toRingHom.comp
      (C : k →+* MvPolynomial (Fin 3) k) =
      algebraMap k (ProjectiveSpace.StandardChartRing 2 k j) := by
    ext a
    simp [sndConicStandardChartEval]
  rw [hcoeff]
  congr 1
  refine MvPolynomial.algHom_ext fun z => ?_
  rcases z with i | l
  · simp
  · simp [sndConicStandardChartEval]

/-- On chart zero, the preceding comparison is exactly `genericSndConicChartZero`. -/
theorem map_universalSndConic_standardChartZero
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    map (sndConicStandardChartEval (0 : Fin 3)).toRingHom (universalSndConic F) =
      genericSndConicChartZero F := by
  rw [map_universalSndConic_standardChart, genericSndConicChartZero]

/-- The global discriminant dehomogenizes to the determinant of the chart conic's polar matrix. -/
theorem sndConicStandardChartEval_discriminant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (j : Fin 3) :
    sndConicStandardChartEval j (sndConicDiscriminant F) =
      (polarMatrix
        (specializeSecondCoordinates
          (fun l => ProjectiveSpace.normalizedCoordinate 2 k j l)
          (map (algebraMap k (ProjectiveSpace.StandardChartRing 2 k j)) F))).det := by
  change (sndConicStandardChartEval j).toRingHom
      ((polarMatrix (universalSndConic F)).det) = _
  rw [RingHom.map_det]
  congr 1
  change (polarMatrix (universalSndConic F)).map
      (sndConicStandardChartEval j).toRingHom = _
  rw [← polarMatrix_map]
  exact congrArg polarMatrix (map_universalSndConic_standardChart F j)

/-- Chart-zero comparison in the exact form consumed by generic-conic nondegeneracy. -/
theorem sndConicStandardChartEval_zero_discriminant
    {k : Type u} [Field k]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) :
    sndConicStandardChartEval (0 : Fin 3) (sndConicDiscriminant F) =
      (polarMatrix (genericSndConicChartZero F)).det := by
  rw [sndConicStandardChartEval_discriminant, ← genericSndConicChartZero]

/-- Smoothness of the total bidegree-`(2,3)` hypersurface makes the global conic discriminant a
nonzero homogeneous-coordinate form. -/
theorem sndConicDiscriminant_ne_zero_of_smooth
    {k : Type u} [Field k] [IsAlgClosed k] [NeZero (2 : k)] [NeZero (3 : k)]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k)
    (hF : IsBidegree23 F) (hF0 : F ≠ 0)
    [Smooth (biprojectiveZeroLocusToSpec 2 2 k F)] :
    sndConicDiscriminant F ≠ 0 := by
  intro hzero
  apply det_polarMatrix_genericSndConicChartZero_ne_zero_of_smooth F hF hF0
  rw [← sndConicStandardChartEval_zero_discriminant F, hzero, map_zero]

end

end BConicBundleMultisections
