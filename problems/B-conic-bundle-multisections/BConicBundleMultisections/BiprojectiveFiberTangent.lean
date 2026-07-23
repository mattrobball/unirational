/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveFiberPolynomial
public import BConicBundleMultisections.PlaneCubicTangentForm

/-!
# Tangent forms in biprojective fibers

This file specializes a biprojective equation in its first coordinate block and takes the
coordinate tangent form of the resulting equation in the second block.  For a bidegree `(2, 3)`
equation, this is the tangent-line equation of a plane cubic fiber of the first projection.

The results here remain at the polynomial level.  Their identification with tangent spaces of
scheme-theoretic fibers will be supplied by the later fiber comparison and smoothness layers.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial

variable {m n : ℕ} {R : Type*} [CommSemiring R]

/-- The coordinate tangent form at `y` of the equation obtained by fixing the first coordinates
at `x`. -/
def firstFiberTangentForm
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    MvPolynomial (Fin (n + 1)) R :=
  tangentForm (specializeFirstCoordinates x F) y

/-- The coefficients of the first-fiber tangent form are the second-block partial derivatives
of the original biprojective equation evaluated at `(x, y)`. -/
@[simp]
theorem coeff_firstFiberTangentForm
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (j : Fin (n + 1)) :
    coeff (Finsupp.single j 1) (firstFiberTangentForm F x y) =
      eval (Sum.elim x y) (pderiv (.inr j) F) := by
  rw [firstFiberTangentForm, coeff_tangentForm,
    ← specializeFirstCoordinates_pderiv_inr,
    eval_specializeFirstCoordinates]

/-- A first-fiber tangent form is homogeneous of degree one in the second coordinate block. -/
theorem firstFiberTangentForm_isHomogeneous
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    (firstFiberTangentForm F x y).IsHomogeneous 1 :=
  tangentForm_isHomogeneous _ _

/-- Rescaling the representative in the first projective factor rescales the first-fiber
tangent form by the first homogeneous degree. -/
theorem IsBihomogeneousOfBidegree.firstFiberTangentForm_smul_first
    {d e : ℕ} {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (r : R) (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    firstFiberTangentForm F (r • x) y =
      C (r ^ d) * firstFiberTangentForm F x y := by
  change tangentForm (specializeFirstCoordinates (r • x) F) y =
    C (r ^ d) * tangentForm (specializeFirstCoordinates x F) y
  rw [hF.specializeFirstCoordinates_smul, tangentForm_C_mul]

/-- Rescaling the point of the fiber at which the tangent is taken rescales the first-fiber
tangent form by one less than the second homogeneous degree. -/
theorem IsBihomogeneousOfBidegree.firstFiberTangentForm_smul_second
    {d e : ℕ} {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (s : R) (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    firstFiberTangentForm F x (s • y) =
      C (s ^ (e - 1)) * firstFiberTangentForm F x y := by
  exact tangentForm_smul_point
    (hF.specializeFirstCoordinates_isHomogeneous x) s y

/-- Simultaneous rescaling of the first-factor representative and the tangent base point. -/
theorem IsBihomogeneousOfBidegree.firstFiberTangentForm_smul_first_smul_second
    {d e : ℕ} {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (r s : R) (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    firstFiberTangentForm F (r • x) (s • y) =
      C (r ^ d * s ^ (e - 1)) * firstFiberTangentForm F x y := by
  rw [hF.firstFiberTangentForm_smul_first,
    hF.firstFiberTangentForm_smul_second, ← mul_assoc, ← C_mul]

/-- Evaluating the first-fiber tangent form is the dot product of the second-block gradient of
the original equation at `(x, y)` with the new second-coordinate vector. -/
@[simp]
theorem eval_firstFiberTangentForm
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (x : Fin (m + 1) → R) (y z : Fin (n + 1) → R) :
    eval z (firstFiberTangentForm F x y) =
      ∑ j : Fin (n + 1),
        eval (Sum.elim x y) (pderiv (.inr j) F) * z j := by
  rw [firstFiberTangentForm, eval_tangentForm]
  apply Finset.sum_congr rfl
  intro j hj
  rw [← specializeFirstCoordinates_pderiv_inr,
    eval_specializeFirstCoordinates]

/-- Rescaling the target at which a first-fiber tangent form is evaluated scales the value
linearly. -/
theorem eval_firstFiberTangentForm_smul_target
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (t : R) (x : Fin (m + 1) → R)
    (y z : Fin (n + 1) → R) :
    eval (t • z) (firstFiberTangentForm F x y) =
      t * eval z (firstFiberTangentForm F x y) := by
  exact eval_tangentForm_smul_target (specializeFirstCoordinates x F) y z t

/-- Exact scaling formula for first-fiber tangent incidence under all three projective
representative rescalings. -/
theorem IsBihomogeneousOfBidegree.eval_firstFiberTangentForm_smul
    {d e : ℕ} {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (r s t : R) (x : Fin (m + 1) → R)
    (y z : Fin (n + 1) → R) :
    eval (t • z) (firstFiberTangentForm F (r • x) (s • y)) =
      (r ^ d * s ^ (e - 1) * t) *
        eval z (firstFiberTangentForm F x y) := by
  rw [hF.firstFiberTangentForm_smul_first_smul_second, map_mul, eval_C,
    eval_firstFiberTangentForm_smul_target]
  ac_rfl

/-- Unit rescaling in all three projective-coordinate slots preserves first-fiber tangent
incidence. -/
theorem IsBihomogeneousOfBidegree.eval_firstFiberTangentForm_smul_eq_zero_iff
    {d e : ℕ} {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (r s t : Rˣ) (x : Fin (m + 1) → R)
    (y z : Fin (n + 1) → R) :
    eval ((t : R) • z)
        (firstFiberTangentForm F ((r : R) • x) ((s : R) • y)) = 0 ↔
      eval z (firstFiberTangentForm F x y) = 0 := by
  rw [hF.eval_firstFiberTangentForm_smul]
  exact Units.mul_right_eq_zero (r ^ d * s ^ (e - 1) * t)

/-- A point of a bihomogeneous hypersurface lies on the coordinate tangent hyperplane of its
fiber under the first projection. -/
theorem eval_firstFiberTangentForm_self_eq_zero
    {d e : ℕ} {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (x : Fin (m + 1) → R) {y : Fin (n + 1) → R}
    (hy : eval (Sum.elim x y) F = 0) :
    eval y (firstFiberTangentForm F x y) = 0 := by
  apply eval_tangentForm_self_eq_zero
    (hF.specializeFirstCoordinates_isHomogeneous x)
  simpa only [eval_specializeFirstCoordinates] using hy

end

end BConicBundleMultisections
