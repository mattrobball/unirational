/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveTangentHyperplane

/-!
# Point-level projective hypersurfaces

This file descends vanishing of a homogeneous polynomial and nonvanishing of its coordinate
gradient to predicates on point-level projectivization.  Their intersection is the coordinate
nonsingular locus of the projective hypersurface.

These are point-level predicates.  No identification with a scheme-theoretic zero locus or with
scheme smoothness is asserted here; those require the later chartwise Jacobian comparison.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial
open scoped LinearAlgebra.Projectivization

universe u v

variable {σ : Type v} {K : Type u} [Field K]

/-- The projective points at which a homogeneous polynomial vanishes. -/
def projectiveHypersurfacePoints {f : MvPolynomial σ K} {d : ℕ}
    (h : f.IsHomogeneous d) : Set (ℙ K (σ → K)) :=
  {P | Projectivization.lift
    (fun p ↦ eval (p : σ → K) f = 0)
    (by
      intro a b t hab
      apply propext
      have ht : t ≠ 0 := by
        intro ht
        apply a.2
        rw [hab, ht, zero_smul]
      rw [hab]
      change eval (fun i ↦ t * (b : σ → K) i) f = 0 ↔ _
      rw [eval_smul_point_of_isHomogeneous h]
      exact Units.mul_right_eq_zero ((Units.mk0 t ht) ^ d)) P}

/-- Membership in the projective vanishing locus can be checked on any nonzero coordinate
representative. -/
@[simp]
theorem mk_mem_projectiveHypersurfacePoints_iff
    {f : MvPolynomial σ K} {d : ℕ} (h : f.IsHomogeneous d)
    (p : σ → K) (hp : p ≠ 0) :
    Projectivization.mk K p hp ∈ projectiveHypersurfacePoints h ↔ eval p f = 0 :=
  Iff.rfl

/-- The projective points where the coordinate gradient of a homogeneous polynomial is nonzero. -/
def projectiveNonsingularPoints {f : MvPolynomial σ K} {d : ℕ}
    (h : f.IsHomogeneous d) : Set (ℙ K (σ → K)) :=
  {P | Projectivization.lift
    (fun p ↦ tangentGradient f (p : σ → K) ≠ 0)
    (by
      intro a b t hab
      apply propext
      have ht : t ≠ 0 := by
        intro ht
        apply a.2
        rw [hab, ht, zero_smul]
      rw [hab, tangentGradient_smul_point h]
      exact not_congr (smul_eq_zero.trans (or_iff_right
        (pow_ne_zero (d - 1) ht))))
    P}

/-- Coordinate-gradient nonvanishing can be checked on any nonzero representative. -/
@[simp]
theorem mk_mem_projectiveNonsingularPoints_iff
    {f : MvPolynomial σ K} {d : ℕ} (h : f.IsHomogeneous d)
    (p : σ → K) (hp : p ≠ 0) :
    Projectivization.mk K p hp ∈ projectiveNonsingularPoints h ↔
      tangentGradient f p ≠ 0 :=
  Iff.rfl

/-- The coordinate nonsingular locus of a point-level projective hypersurface. -/
def projectiveNonsingularHypersurfacePoints {f : MvPolynomial σ K} {d : ℕ}
    (h : f.IsHomogeneous d) : Set (ℙ K (σ → K)) :=
  projectiveHypersurfacePoints h ∩ projectiveNonsingularPoints h

/-- A representative belongs to the coordinate nonsingular hypersurface locus exactly when the
polynomial vanishes there and its coordinate gradient does not. -/
@[simp]
theorem mk_mem_projectiveNonsingularHypersurfacePoints_iff
    {f : MvPolynomial σ K} {d : ℕ} (h : f.IsHomogeneous d)
    (p : σ → K) (hp : p ≠ 0) :
    Projectivization.mk K p hp ∈ projectiveNonsingularHypersurfacePoints h ↔
      eval p f = 0 ∧ tangentGradient f p ≠ 0 := by
  rfl

end

end BConicBundleMultisections
