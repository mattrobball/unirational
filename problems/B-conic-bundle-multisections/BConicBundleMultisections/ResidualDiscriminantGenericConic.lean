/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualDiscriminantAvoidance
public import Mathlib.RingTheory.FractionalIdeal.Basic

/-!
# The conic over a base not contained in the discriminant

Evaluating the homogeneous second-block coordinates of a bidegree-`(2,3)` equation in an arbitrary
`k`-algebra `A` produces a ternary quadratic over `A`.  Its polar determinant is exactly the
evaluation of `sndConicDiscriminant`.  Consequently, if that evaluation is nonzero and `A` is a
domain, the conic over `FractionRing A` is nonsingular.

This is the algebraic generic-fibre statement needed by the discriminant-avoidance proof of
residual horizontality.  It deliberately says nothing about the dimension or closure of the
residual image; those are separate geometric inputs.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open _root_.MvPolynomial

/-- The second-projection conic after evaluating its homogeneous base coordinates in a
`k`-algebra. -/
def sndConicAt
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (y : Fin 3 → A) :
    MvPolynomial (Fin 3) A :=
  specializeSecondCoordinates y (map (algebraMap k A) F)

/-- Evaluating the coefficient variables of the universal second conic gives `sndConicAt`. -/
theorem map_universalSndConic_aeval
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (y : Fin 3 → A) :
    map (aeval y).toRingHom (universalSndConic F) = sndConicAt F y := by
  rw [universalSndConic, map_specializeSecondCoordinates, MvPolynomial.map_map]
  have hcoeff : (aeval y).toRingHom.comp (C : k →+* MvPolynomial (Fin 3) k) =
      algebraMap k A := by
    ext a
    simp
  rw [hcoeff]
  congr 1
  refine MvPolynomial.algHom_ext fun z ↦ ?_
  rcases z with i | j
  · simp
  · simp

/-- The polar determinant of a specialized second conic is the specialized global
discriminant. -/
theorem det_polarMatrix_sndConicAt
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (y : Fin 3 → A) :
    (polarMatrix (sndConicAt F y)).det = aeval y (sndConicDiscriminant F) := by
  change (polarMatrix (sndConicAt F y)).det =
    (aeval y).toRingHom ((polarMatrix (universalSndConic F)).det)
  rw [← map_universalSndConic_aeval F y, polarMatrix_map]
  simpa only [RingHom.map_det, RingHom.mapMatrix_apply] using
    (RingHom.map_det (aeval y).toRingHom (polarMatrix (universalSndConic F))).symm

/-- Bidegree `(2,3)` makes every specialized second conic homogeneous of degree two in the first
coordinates. -/
theorem sndConicAt_isHomogeneous
    {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (y : Fin 3 → A) :
    (sndConicAt F y).IsHomogeneous 2 := by
  exact (hF.map_coefficients (algebraMap k A)).specializeSecondCoordinates_isHomogeneous y

/-- Specialization commutes with a further coefficient map. -/
theorem map_sndConicAt
    {k A B : Type u} [CommRing k] [CommRing A] [CommRing B]
    [Algebra k A] [Algebra k B]
    (f : A →+* B) (hfac : f.comp (algebraMap k A) = algebraMap k B)
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (y : Fin 3 → A) :
    map f (sndConicAt F y) = sndConicAt F (fun i ↦ f (y i)) := by
  rw [sndConicAt, sndConicAt, map_specializeSecondCoordinates, MvPolynomial.map_map, hfac]

/-- Avoiding the discriminant over a domain makes the conic over its fraction field
nonsingular. -/
theorem sndConicAt_fraction_nonsingular_of_discriminant_ne_zero
    {k A : Type u} [Field k] [CommRing A] [IsDomain A] [Algebra k A]
    (F : MvPolynomial (BiprojectiveCoordinate 2 2) k) (hF : IsBidegree23 F)
    (y : Fin 3 → A) (hdisc : aeval y (sndConicDiscriminant F) ≠ 0) :
    let Q : MvPolynomial (Fin 3) (FractionRing A) :=
      map (algebraMap A (FractionRing A)) (sndConicAt F y)
    Q.IsHomogeneous 2 ∧ Q ≠ 0 ∧
      ∀ v : Fin 3 → FractionRing A, v ≠ 0 → eval v Q = 0 →
        ∃ j, eval v (pderiv j Q) ≠ 0 := by
  let Q : MvPolynomial (Fin 3) (FractionRing A) :=
    map (algebraMap A (FractionRing A)) (sndConicAt F y)
  have hQhom : Q.IsHomogeneous 2 :=
    (sndConicAt_isHomogeneous F hF y).map (algebraMap A (FractionRing A))
  have hdetA : (polarMatrix (sndConicAt F y)).det ≠ 0 := by
    rwa [det_polarMatrix_sndConicAt]
  have hdet : (polarMatrix Q).det ≠ 0 := by
    change (polarMatrix (map (algebraMap A (FractionRing A)) (sndConicAt F y))).det ≠ 0
    rw [polarMatrix_map]
    simpa only [RingHom.map_det, RingHom.mapMatrix_apply, map_zero] using
      (IsFractionRing.injective A (FractionRing A)).ne hdetA
  have hQ0 : Q ≠ 0 := by
    intro hzero
    apply hdet
    rw [hzero]
    have hp : polarMatrix (0 : MvPolynomial (Fin 3) (FractionRing A)) = 0 := by
      ext i j
      simp [polarMatrix, polarEval]
    rw [hp]
    exact Matrix.det_zero
  exact ⟨hQhom, hQ0, fun v hv _ ↦
    exists_eval_pderiv_ne_zero_of_det_polarMatrix_ne_zero Q hQhom hdet v hv⟩

end

end BConicBundleMultisections
