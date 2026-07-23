/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.PlaneCubicTangentForm
public import Mathlib.LinearAlgebra.Projectivization.Constructions

/-!
# Projective tangent hyperplanes in coordinates

This file proves that the coordinate tangent form of a homogeneous polynomial is well defined
projectively.  Over a commutative semiring, its affine-cone zero locus is unchanged by unit
rescaling of the base point, the target point, or the tangent form itself.  Over a field, tangent
incidence descends to a predicate on pairs of points in projective coordinate space.

When the tangent form is nonzero, its coefficient vector defines a point in the dual projective
coordinate space.  Using the chosen coordinate dot product to identify covectors with coordinate
vectors, tangent incidence agrees with Mathlib's `Projectivization.orthogonal` predicate.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial

universe u v

variable {σ : Type v} {R : Type u} [CommSemiring R]

/-- The coefficient vector of the coordinate tangent form. -/
def tangentGradient (f : MvPolynomial σ R) (p : σ → R) : σ → R :=
  fun i ↦ eval p (pderiv i f)

@[simp]
theorem tangentGradient_apply (f : MvPolynomial σ R) (p : σ → R) (i : σ) :
    tangentGradient f p i = eval p (pderiv i f) :=
  rfl

/-- The gradient of a degree-`d` homogeneous polynomial has weight `d - 1` in its base point. -/
theorem tangentGradient_smul_point {f : MvPolynomial σ R} {d : ℕ}
    (h : f.IsHomogeneous d) (r : R) (p : σ → R) :
    tangentGradient f (r • p) = r ^ (d - 1) • tangentGradient f p := by
  funext i
  rw [show r • p = fun j ↦ r * p j by ext j; simp]
  simp [tangentGradient, eval_smul_point_of_isHomogeneous h.pderiv]

variable [Fintype σ]

/-- Evaluating the tangent form is the coordinate dot product of its coefficient vector with
the target point. -/
theorem eval_tangentForm_eq_dotProduct (f : MvPolynomial σ R) (p q : σ → R) :
    eval q (tangentForm f p) = tangentGradient f p ⬝ᵥ q := by
  simp [dotProduct, tangentGradient]

/-- The gradient vector is zero exactly when the corresponding tangent polynomial is zero. -/
theorem tangentGradient_eq_zero_iff (f : MvPolynomial σ R) (p : σ → R) :
    tangentGradient f p = 0 ↔ tangentForm f p = 0 := by
  constructor
  · intro hg
    apply (tangentForm_eq_zero_iff f p).2
    intro i
    have hi := congrFun hg i
    simpa [tangentGradient] using hi
  · intro ht
    ext i
    simpa [tangentGradient] using (tangentForm_eq_zero_iff f p).1 ht i

/-- Nonvanishing of the gradient vector is equivalent to nonvanishing of the tangent
polynomial. -/
theorem tangentGradient_ne_zero_iff (f : MvPolynomial σ R) (p : σ → R) :
    tangentGradient f p ≠ 0 ↔ tangentForm f p ≠ 0 :=
  not_congr (tangentGradient_eq_zero_iff f p)

/-- Exact two-sided scaling formula for tangent incidence. -/
theorem eval_tangentForm_smul_point_smul_target {f : MvPolynomial σ R} {d : ℕ}
    (h : f.IsHomogeneous d) (r s : R) (p q : σ → R) :
    eval (s • q) (tangentForm f (r • p)) =
      (r ^ (d - 1) * s) * eval q (tangentForm f p) := by
  rw [tangentForm_smul_point h, map_mul, eval_C, eval_tangentForm_smul_target]
  ac_rfl

/-- The affine cone over the tangent hyperplane at `p`. -/
def tangentHyperplaneCone (f : MvPolynomial σ R) (p : σ → R) : Set (σ → R) :=
  {q | eval q (tangentForm f p) = 0}

@[simp]
theorem mem_tangentHyperplaneCone (f : MvPolynomial σ R) (p q : σ → R) :
    q ∈ tangentHyperplaneCone f p ↔ eval q (tangentForm f p) = 0 :=
  Iff.rfl

/-- Unit rescaling of the base-point representative does not change the tangent hyperplane
cone. -/
theorem tangentHyperplaneCone_smul_point {f : MvPolynomial σ R} {d : ℕ}
    (h : f.IsHomogeneous d) (u : Rˣ) (p : σ → R) :
    tangentHyperplaneCone f ((u : R) • p) = tangentHyperplaneCone f p := by
  ext q
  exact eval_tangentForm_smul_point_eq_zero_iff h u p q

/-- Membership in the tangent hyperplane cone is insensitive to unit rescaling of the target
representative. -/
theorem smul_mem_tangentHyperplaneCone_iff
    (f : MvPolynomial σ R) (p q : σ → R) (u : Rˣ) :
    (u : R) • q ∈ tangentHyperplaneCone f p ↔ q ∈ tangentHyperplaneCone f p := by
  rw [mem_tangentHyperplaneCone, mem_tangentHyperplaneCone,
    eval_tangentForm_smul_target]
  exact Units.mul_right_eq_zero u

/-- Simultaneous unit rescaling of both projective representatives preserves tangent
incidence. -/
theorem eval_tangentForm_smul_point_smul_target_eq_zero_iff
    {f : MvPolynomial σ R} {d : ℕ} (h : f.IsHomogeneous d)
    (u v : Rˣ) (p q : σ → R) :
    eval ((v : R) • q) (tangentForm f ((u : R) • p)) = 0 ↔
      eval q (tangentForm f p) = 0 := by
  rw [eval_tangentForm_smul_point_smul_target h]
  exact Units.mul_right_eq_zero (u ^ (d - 1) * v)

/-- Multiplying the tangent polynomial itself by a unit does not change its zero set. -/
theorem eval_C_mul_tangentForm_eq_zero_iff
    (f : MvPolynomial σ R) (p q : σ → R) (u : Rˣ) :
    eval q (C (u : R) * tangentForm f p) = 0 ↔
      eval q (tangentForm f p) = 0 := by
  rw [map_mul, eval_C]
  exact Units.mul_right_eq_zero u

section Field

variable {K : Type u} [Field K]

open scoped LinearAlgebra.Projectivization

/-- Tangent incidence as a predicate on two projective coordinate points.  This remains defined
when the tangent form is zero; nonvanishing is needed only to regard that form as a projective
hyperplane below. -/
def projectiveTangentIncidence {f : MvPolynomial σ K} {d : ℕ}
    (h : f.IsHomogeneous d) : ℙ K (σ → K) → ℙ K (σ → K) → Prop :=
  Projectivization.lift
    (fun p ↦ Projectivization.lift
      (fun q ↦ eval (q : σ → K) (tangentForm f (p : σ → K)) = 0)
      (by
        intro a b t hab
        apply propext
        have ht : t ≠ 0 := by
          intro ht
          apply a.2
          rw [hab, ht, zero_smul]
        rw [hab, eval_tangentForm_smul_target]
        exact Units.mul_right_eq_zero (Units.mk0 t ht)))
    (by
      intro a b t hab
      funext Q
      induction Q using Projectivization.ind with
      | h q hq =>
          apply propext
          have ht : t ≠ 0 := by
            intro ht
            apply a.2
            rw [hab, ht, zero_smul]
          change eval q (tangentForm f (a : σ → K)) = 0 ↔
            eval q (tangentForm f (b : σ → K)) = 0
          rw [hab, tangentForm_smul_point h, map_mul, eval_C]
          exact Units.mul_right_eq_zero ((Units.mk0 t ht) ^ (d - 1)))

/-- The projective incidence predicate reduces to coordinate tangent-form vanishing on any
chosen pair of nonzero representatives. -/
@[simp]
theorem projectiveTangentIncidence_mk_mk_iff {f : MvPolynomial σ K} {d : ℕ}
    (h : f.IsHomogeneous d) (p q : σ → K) (hp : p ≠ 0) (hq : q ≠ 0) :
    projectiveTangentIncidence h (Projectivization.mk K p hp)
        (Projectivization.mk K q hq) ↔
      eval q (tangentForm f p) = 0 :=
  Iff.rfl

/-- A nonzero coordinate tangent form, viewed as a point of the dual projective coordinate
space via the chosen coordinate dot product. -/
def projectiveTangentHyperplane (f : MvPolynomial σ K) (p : σ → K)
    (hp : tangentGradient f p ≠ 0) : ℙ K (σ → K) :=
  Projectivization.mk K (tangentGradient f p) hp

omit [Fintype σ] in
/-- Unit rescaling preserves nonvanishing of the gradient. -/
theorem tangentGradient_smul_point_ne_zero {f : MvPolynomial σ K} {d : ℕ}
    (h : f.IsHomogeneous d) (u : Kˣ) (p : σ → K)
    (hp : tangentGradient f p ≠ 0) :
    tangentGradient f ((u : K) • p) ≠ 0 := by
  rw [tangentGradient_smul_point h]
  exact smul_ne_zero (Units.ne_zero (u ^ (d - 1))) hp

omit [Fintype σ] in
/-- The projective tangent hyperplane is independent of unit rescaling of the chosen
base-point representative. -/
theorem projectiveTangentHyperplane_smul_point {f : MvPolynomial σ K} {d : ℕ}
    (h : f.IsHomogeneous d) (u : Kˣ) (p : σ → K)
    (hp : tangentGradient f p ≠ 0) :
    projectiveTangentHyperplane f ((u : K) • p)
        (tangentGradient_smul_point_ne_zero h u p hp) =
      projectiveTangentHyperplane f p hp := by
  apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).2
  exact ⟨(u : K) ^ (d - 1), (tangentGradient_smul_point h (u : K) p).symm⟩

/-- Projective orthogonality to the tangent covector is precisely vanishing of the coordinate
tangent form.  In particular, the right-hand condition is independent of the representative
of the target projective point. -/
theorem projectiveTangentHyperplane_orthogonal_mk_iff
    (f : MvPolynomial σ K) (p q : σ → K)
    (hp : tangentGradient f p ≠ 0) (hq : q ≠ 0) :
    Projectivization.orthogonal (projectiveTangentHyperplane f p hp)
        (Projectivization.mk K q hq) ↔
      eval q (tangentForm f p) = 0 := by
  rw [projectiveTangentHyperplane, Projectivization.orthogonal_mk]
  rw [← eval_tangentForm_eq_dotProduct]

/-- At a point with nonzero tangent form, projective tangent incidence is exactly
orthogonality to the associated dual-projective tangent hyperplane. -/
theorem projectiveTangentIncidence_mk_left_iff_orthogonal
    {f : MvPolynomial σ K} {d : ℕ} (h : f.IsHomogeneous d)
    (p : σ → K) (hp : p ≠ 0) (hgrad : tangentGradient f p ≠ 0)
    (Q : ℙ K (σ → K)) :
    projectiveTangentIncidence h (Projectivization.mk K p hp) Q ↔
      Projectivization.orthogonal (projectiveTangentHyperplane f p hgrad) Q := by
  induction Q using Projectivization.ind with
  | h q hq =>
      rw [projectiveTangentIncidence_mk_mk_iff,
        projectiveTangentHyperplane_orthogonal_mk_iff]

end Field

end

end BConicBundleMultisections
