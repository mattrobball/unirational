/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveFiberTangent
public import BConicBundleMultisections.ProjectiveTangentHyperplane

/-!
# Projective tangent incidence in biprojective fibers

For a bihomogeneous equation, tangent incidence in a fiber of the first projection is
independent of all three choices of homogeneous-coordinate representatives: the point in the
first factor, the point of its second-factor fiber, and the target point in the tangent
hyperplane.  This file descends that coordinate condition to point-level projectivizations.

This is a point-level construction.  Relating it to a closed incidence subscheme and to the
scheme-theoretic fibers of a biprojective zero locus is a later geometric step.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial
open scoped LinearAlgebra.Projectivization

universe u

variable {m n d e : ℕ} {K : Type u} [Field K]

/-- First-fiber tangent incidence on three projective coordinate points: a first-factor point,
a point in its second-factor fiber, and a target point of the tangent hyperplane. -/
def projectiveFirstFiberTangentIncidence
    {F : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hF : IsBihomogeneousOfBidegree d e F) :
    ℙ K (Fin (m + 1) → K) →
      ℙ K (Fin (n + 1) → K) → ℙ K (Fin (n + 1) → K) → Prop :=
  Projectivization.lift
    (fun x ↦ projectiveTangentIncidence
      (hF.specializeFirstCoordinates_isHomogeneous (x : Fin (m + 1) → K)))
    (by
      intro a b t hab
      funext Y Z
      induction Y using Projectivization.ind with
      | h y hy =>
          induction Z using Projectivization.ind with
          | h z hz =>
              apply propext
              rw [projectiveTangentIncidence_mk_mk_iff,
                projectiveTangentIncidence_mk_mk_iff]
              change eval z (firstFiberTangentForm F (a : Fin (m + 1) → K) y) = 0 ↔
                eval z (firstFiberTangentForm F (b : Fin (m + 1) → K) y) = 0
              have ht : t ≠ 0 := by
                intro ht
                apply a.2
                rw [hab, ht, zero_smul]
              rw [hab, hF.firstFiberTangentForm_smul_first, map_mul, eval_C]
              exact Units.mul_right_eq_zero ((Units.mk0 t ht) ^ d))

/-- First-fiber tangent incidence as a predicate on the literal product of its three
projective-coordinate spaces. -/
def projectiveFirstFiberTangentIncidenceOnProduct
    {F : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hF : IsBihomogeneousOfBidegree d e F) :
    ℙ K (Fin (m + 1) → K) ×
        ℙ K (Fin (n + 1) → K) × ℙ K (Fin (n + 1) → K) → Prop :=
  fun p ↦ projectiveFirstFiberTangentIncidence hF p.1 p.2.1 p.2.2

/-- The descended predicate is computed by tangent-form vanishing on any chosen nonzero
representatives. -/
@[simp]
theorem projectiveFirstFiberTangentIncidence_mk_mk_mk_iff
    {F : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hF : IsBihomogeneousOfBidegree d e F)
    (x : Fin (m + 1) → K) (hx : x ≠ 0)
    (y : Fin (n + 1) → K) (hy : y ≠ 0)
    (z : Fin (n + 1) → K) (hz : z ≠ 0) :
    projectiveFirstFiberTangentIncidence hF
        (Projectivization.mk K x hx) (Projectivization.mk K y hy)
        (Projectivization.mk K z hz) ↔
      eval z (firstFiberTangentForm F x y) = 0 :=
  projectiveTangentIncidence_mk_mk_iff
    (hF.specializeFirstCoordinates_isHomogeneous x) y z hy hz

/-- Product-form computation rule for chosen nonzero representatives. -/
@[simp]
theorem projectiveFirstFiberTangentIncidenceOnProduct_mk_iff
    {F : MvPolynomial (BiprojectiveCoordinate m n) K}
    (hF : IsBihomogeneousOfBidegree d e F)
    (x : Fin (m + 1) → K) (hx : x ≠ 0)
    (y : Fin (n + 1) → K) (hy : y ≠ 0)
    (z : Fin (n + 1) → K) (hz : z ≠ 0) :
    projectiveFirstFiberTangentIncidenceOnProduct hF
        (Projectivization.mk K x hx,
          Projectivization.mk K y hy, Projectivization.mk K z hz) ↔
      eval z (firstFiberTangentForm F x y) = 0 :=
  projectiveFirstFiberTangentIncidence_mk_mk_mk_iff hF x hx y hy z hz

end

end BConicBundleMultisections
