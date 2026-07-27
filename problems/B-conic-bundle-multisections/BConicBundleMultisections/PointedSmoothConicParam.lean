/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.GoodLineCondition
public import BConicBundleMultisections.HomogeneousQuadraticEval
public import BConicBundleMultisections.SpecializedConicFreeDir
public import BConicBundleMultisections.TsenConic
public import Mathlib.Algebra.MvPolynomial.Eval
public import Mathlib.FieldTheory.RatFunc.Basic
public import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
public import Mathlib.LinearAlgebra.Projectivization.Basic
public import Mathlib.RingTheory.Localization.FractionRing

/-!
# Pointed smooth conic ≃ ℙ¹: residual parametrization, injectivity, excision

A smooth pointed plane conic over a field of characteristic not 2 is parametrized by ℙ¹.  This
module records the residual-point form of that statement at the level of vectors and univariate
polynomials, reusing the tree's `stereoAlg` / `polarEval` API.

## Already in the tree (reused, not reproved)

* Residual-point map: `stereoAlg Q p w = Q(w) • p − B(p,w) • w` with `B = polarEval`
  (`HomogeneousQuadraticEval`).
* Lands on the conic: `stereoAlg_isotropic` / `eval_stereoAlg` (when `Q(p) = 0`).
* Nonvanishing: `stereoAlg_ne_zero_of_isotropic_of_polar_ne_zero` (`GoodLineCondition`).
* Quadratic-form twin: `conicParametrization` (`PointedConicRational`).
* Residual-surface chart: `stereoFirstCoords` / `liftTsenSection`.

## What this file adds

1. **Affine-line parametrization.** Restrict the residual map to directions `w₀ + s · w₁`; each
   coordinate is evaluation of an explicit univariate polynomial of degree ≤ 2.
2. **Injectivity / infinitude.** Under an explicit frame condition on `(w₀, w₁)`, distinct
   parameters give non-proportional residual points; over infinite `F` the conic has infinitely
   many projective `F`-points.  `RatFunc k` is infinite.
3. **Excision.** Finitely many nonzero univariate conditions on the parameter are avoided over an
   infinite field.
4. **Section bridge.** A nonzero isotropic triple of polynomials gives a base point over
   `RatFunc k`, and a parametrized isotropic `RatFunc` point clears denominators back to a nonzero
   isotropic triple.

Frame hypotheses are honest side conditions (residual line through `p`, isotropic free direction,
rank drop).  They are discharged for a smooth conic by `exists_stereoLineFrame_of_det_ne_zero`.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open Matrix
open scoped LinearAlgebra.Projectivization
open _root_.MvPolynomial (eval aeval C X IsHomogeneous)

variable {F : Type u} [Field F]

/-! ### Frame matrix for three vectors in `F³` -/

/-- Columns `v₀, v₁, v₂` as a `3 × 3` matrix. -/
def frameMatrix (v0 v1 v2 : Fin 3 → F) : Matrix (Fin 3) (Fin 3) F :=
  of fun i j => ![v0, v1, v2] j i

theorem mulVec_frameMatrix (v0 v1 v2 : Fin 3 → F) (a b c : F) :
    (frameMatrix v0 v1 v2).mulVec ![a, b, c] =
      fun i => a * v0 i + b * v1 i + c * v2 i := by
  funext i
  simp [frameMatrix, mulVec, dotProduct, of_apply, Fin.sum_univ_three]
  ring

theorem eq_zero_of_lincomb_frameMatrix
    {v0 v1 v2 : Fin 3 → F} (hdet : (frameMatrix v0 v1 v2).det ≠ 0)
    {a b c : F} (h : ∀ i, a * v0 i + b * v1 i + c * v2 i = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 := by
  have hmv : (frameMatrix v0 v1 v2).mulVec ![a, b, c] = 0 := by
    funext i; simpa [mulVec_frameMatrix] using h i
  have hvec : (![a, b, c] : Fin 3 → F) = 0 :=
    eq_zero_of_mulVec_eq_zero hdet hmv
  exact ⟨congr_fun hvec 0, congr_fun hvec 1, congr_fun hvec 2⟩

/-! ### Affine residual line through a pointed conic -/

/-- Residual point along the affine line of free directions `w₀ + s · w₁`.

This is `stereoAlg Q p (w₀ + s · w₁)`: the classical formula
`Q(w) · p − B(p, w) · w` of `HomogeneousQuadraticEval`. -/
def stereoLineParam (Q : MvPolynomial (Fin 3) F) (p w0 w1 : Fin 3 → F) (s : F) :
    Fin 3 → F :=
  stereoAlg Q p (fun i => w0 i + s * w1 i)

/-- **Parametrization lands on the conic.** Reuses `stereoAlg_isotropic`. -/
theorem stereoLineParam_isotropic
    (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (p w0 w1 : Fin 3 → F) (hp : eval p Q = 0) (s : F) :
    eval (stereoLineParam Q p w0 w1 s) Q = 0 :=
  stereoAlg_isotropic Q hQ p _ hp

/-- Free direction `w₀ + X · w₁` as a triple of univariate polynomials. -/
def stereoLineDirPoly (w0 w1 : Fin 3 → F) : Fin 3 → Polynomial F :=
  fun j => Polynomial.C (w0 j) + Polynomial.X * Polynomial.C (w1 j)

/-- Polar form of `Q` along the affine direction: `B(p, w₀) + X · B(p, w₁)`. -/
def stereoLinePolarPoly (Q : MvPolynomial (Fin 3) F) (_hQ : Q.IsHomogeneous 2)
    (p w0 w1 : Fin 3 → F) : Polynomial F :=
  Polynomial.C (polarEval Q p w0) + Polynomial.X * Polynomial.C (polarEval Q p w1)

theorem eval_stereoLinePolarPoly (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (p w0 w1 : Fin 3 → F) (s : F) :
    Polynomial.eval s (stereoLinePolarPoly Q hQ p w0 w1) =
      polarEval Q p (fun i => w0 i + s * w1 i) := by
  have hlin :
      polarEval Q p (fun i => (1 : F) * w0 i + s * w1 i) =
        (1 : F) * polarEval Q p w0 + s * polarEval Q p w1 :=
    polarEval_linear_right (Q := Q) hQ (1 : F) s w0 w1 p
  have hdir : (fun i => w0 i + s * w1 i) = fun i => (1 : F) * w0 i + s * w1 i := by
    funext i; ring
  simp only [stereoLinePolarPoly, Polynomial.eval_add, Polynomial.eval_mul, Polynomial.eval_C,
    Polynomial.eval_X]
  rw [hdir, hlin]
  ring

/-- Value of `Q` along the affine direction, as a univariate polynomial of degree ≤ 2. -/
def stereoLineQuadPoly (Q : MvPolynomial (Fin 3) F) (_hQ : Q.IsHomogeneous 2)
    (w0 w1 : Fin 3 → F) : Polynomial F :=
  Polynomial.C (eval w0 Q) + Polynomial.C (polarEval Q w0 w1) * Polynomial.X +
    Polynomial.C (eval w1 Q) * Polynomial.X ^ 2

theorem eval_stereoLineQuadPoly (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (w0 w1 : Fin 3 → F) (s : F) :
    Polynomial.eval s (stereoLineQuadPoly Q hQ w0 w1) =
      eval (fun i => w0 i + s * w1 i) Q := by
  have hexp := eval_linComb_of_isHomogeneous_two Q hQ (1 : F) s w0 w1
  have hdir : (fun i => w0 i + s * w1 i) = fun i => (1 : F) * w0 i + s * w1 i := by
    funext i; ring
  simp only [stereoLineQuadPoly, Polynomial.eval_add, Polynomial.eval_mul, Polynomial.eval_C,
    Polynomial.eval_X, Polynomial.eval_pow]
  rw [hdir, hexp]
  ring

/-- Residual-point coordinates as univariate polynomials of degree ≤ 2. -/
def stereoLineParamPoly (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (p w0 w1 : Fin 3 → F) : Fin 3 → Polynomial F :=
  fun i =>
    stereoLineQuadPoly Q hQ w0 w1 * Polynomial.C (p i) -
      stereoLinePolarPoly Q hQ p w0 w1 * stereoLineDirPoly w0 w1 i

theorem natDegree_stereoLineParamPoly_le
    (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (p w0 w1 : Fin 3 → F) (i : Fin 3) :
    (stereoLineParamPoly Q hQ p w0 w1 i).natDegree ≤ 2 := by
  classical
  have hC (a : F) : (Polynomial.C a).natDegree ≤ 2 := by simp [Polynomial.natDegree_C]
  have hCX (a : F) : (Polynomial.C a * Polynomial.X).natDegree ≤ 2 :=
    (Polynomial.natDegree_mul_le).trans (by simp [Polynomial.natDegree_C, Polynomial.natDegree_X])
  have hCX2 (a : F) : (Polynomial.C a * Polynomial.X ^ 2).natDegree ≤ 2 :=
    (Polynomial.natDegree_mul_le).trans (by
      simp only [Polynomial.natDegree_C, zero_add]
      exact Polynomial.natDegree_X_pow_le 2)
  have hα : (stereoLineQuadPoly Q hQ w0 w1).natDegree ≤ 2 := by
    simp only [stereoLineQuadPoly]
    refine (Polynomial.natDegree_add_le _ _).trans (sup_le ?_ (hCX2 _))
    exact (Polynomial.natDegree_add_le _ _).trans (sup_le (hC _) (hCX _))
  have hβ : (stereoLinePolarPoly Q hQ p w0 w1).natDegree ≤ 1 := by
    simp only [stereoLinePolarPoly]
    refine (Polynomial.natDegree_add_le _ _).trans (sup_le (by simp [Polynomial.natDegree_C]) ?_)
    exact (Polynomial.natDegree_mul_le).trans
      (by simp [Polynomial.natDegree_C, Polynomial.natDegree_X])
  have hdir : (stereoLineDirPoly w0 w1 i).natDegree ≤ 1 := by
    simp only [stereoLineDirPoly]
    refine (Polynomial.natDegree_add_le _ _).trans (sup_le (by simp [Polynomial.natDegree_C]) ?_)
    exact (Polynomial.natDegree_mul_le).trans
      (by simp [Polynomial.natDegree_C, Polynomial.natDegree_X])
  simp only [stereoLineParamPoly]
  refine (Polynomial.natDegree_sub_le _ _).trans (sup_le ?_ ?_)
  · exact (Polynomial.natDegree_mul_le).trans (by
      have : (Polynomial.C (p i)).natDegree ≤ 0 := by simp [Polynomial.natDegree_C]
      omega)
  · exact (Polynomial.natDegree_mul_le).trans (by omega)

theorem eval_stereoLineParamPoly
    (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (p w0 w1 : Fin 3 → F) (s : F) (i : Fin 3) :
    Polynomial.eval s (stereoLineParamPoly Q hQ p w0 w1 i) =
      stereoLineParam Q p w0 w1 s i := by
  simp only [stereoLineParamPoly, stereoLineParam, stereoAlg, Polynomial.eval_sub,
    Polynomial.eval_mul, Polynomial.eval_C, eval_stereoLineQuadPoly Q hQ w0 w1 s,
    eval_stereoLinePolarPoly Q hQ p w0 w1 s]
  simp only [stereoLineDirPoly, Polynomial.eval_add, Polynomial.eval_mul, Polynomial.eval_C,
    Polynomial.eval_X]

/-- Composition of a ternary polynomial with the residual line, as a univariate polynomial. -/
def stereoLineCompose (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (p w0 w1 : Fin 3 → F) (G : MvPolynomial (Fin 3) F) : Polynomial F :=
  aeval (stereoLineParamPoly Q hQ p w0 w1) G

theorem eval_stereoLineCompose (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (p w0 w1 : Fin 3 → F) (G : MvPolynomial (Fin 3) F) (s : F) :
    Polynomial.eval s (stereoLineCompose Q hQ p w0 w1 G) =
      eval (stereoLineParam Q p w0 w1 s) G := by
  have hcomp :
      Polynomial.eval s (aeval (stereoLineParamPoly Q hQ p w0 w1) G) =
        eval (fun i => Polynomial.eval s (stereoLineParamPoly Q hQ p w0 w1 i)) G := by
    induction G using MvPolynomial.induction_on with
    | C a => simp
    | add f g hf hg => simp [hf, hg]
    | mul_X f j hf => simp [hf]
  simp only [stereoLineCompose, hcomp]
  have hpt : (fun i => Polynomial.eval s (stereoLineParamPoly Q hQ p w0 w1 i)) =
      stereoLineParam Q p w0 w1 s := by
    funext i; exact eval_stereoLineParamPoly Q hQ p w0 w1 s i
  rw [hpt]

/-! ### Nondegeneracy package for injectivity -/

/-- Frame data making the residual affine line a projective embedding of `𝔸¹` into the conic.

* `polar_w0`: `B(p, w₀) = 0` (tangent condition);
* `polar_w1`: `B(p, w₁) ≠ 0` (transversality);
* `free_not_isotropic`: `Q(w₀) ≠ 0` (so `s = 0` is not a double root on the tangent);
* `frame_det`: `p, w₀, w₁` form a basis of `F³`. -/
structure StereoLineFrame (Q : MvPolynomial (Fin 3) F) (p w0 w1 : Fin 3 → F) : Prop where
  isHomogeneous : Q.IsHomogeneous 2
  isotropic : eval p Q = 0
  base_ne_zero : p ≠ 0
  polar_w0 : polarEval Q p w0 = 0
  polar_w1 : polarEval Q p w1 ≠ 0
  free_not_isotropic : eval w0 Q ≠ 0
  frame_det : (frameMatrix p w0 w1).det ≠ 0

namespace StereoLineFrame

variable {Q : MvPolynomial (Fin 3) F} {p w0 w1 : Fin 3 → F}

/-- Expanded residual point under a polar-adapted frame. -/
theorem param_eq (h : StereoLineFrame Q p w0 w1) (s : F) :
    stereoLineParam Q p w0 w1 s =
      fun i =>
        (eval w0 Q + s * polarEval Q w0 w1 + s ^ 2 * eval w1 Q) * p i -
          s * polarEval Q p w1 * w0 i - s ^ 2 * polarEval Q p w1 * w1 i := by
  funext i
  have hα :
      eval (fun j => w0 j + s * w1 j) Q =
        eval w0 Q + s * polarEval Q w0 w1 + s ^ 2 * eval w1 Q := by
    have hexp := eval_linComb_of_isHomogeneous_two Q h.isHomogeneous (1 : F) s w0 w1
    have hdir : (fun j => w0 j + s * w1 j) = fun j => (1 : F) * w0 j + s * w1 j := by
      funext j; ring
    rw [hdir, hexp]; ring
  have hβ :
      polarEval Q p (fun j => w0 j + s * w1 j) = s * polarEval Q p w1 := by
    have hlin :=
      polarEval_linear_right (Q := Q) h.isHomogeneous (1 : F) s w0 w1 p
    have hdir : (fun j => w0 j + s * w1 j) = fun j => (1 : F) * w0 j + s * w1 j := by
      funext j; ring
    rw [hdir, hlin, h.polar_w0]; ring
  simp only [stereoLineParam, stereoAlg, hα, hβ]
  ring

theorem param_ne_zero (h : StereoLineFrame Q p w0 w1) (s : F) :
    stereoLineParam Q p w0 w1 s ≠ 0 := by
  intro hz
  have hexp := h.param_eq s
  rw [hexp] at hz
  have hlin :
      ∀ i,
        (eval w0 Q + s * polarEval Q w0 w1 + s ^ 2 * eval w1 Q) * p i +
            (-s * polarEval Q p w1) * w0 i +
              (-s ^ 2 * polarEval Q p w1) * w1 i =
          0 := by
    intro i
    have hi := congr_fun hz i
    simp only [Pi.zero_apply] at hi
    linear_combination hi
  obtain ⟨ha, hb, _hc⟩ := eq_zero_of_lincomb_frameMatrix h.frame_det hlin
  have hs : s = 0 := by
    have : s * polarEval Q p w1 = 0 := by linear_combination -hb
    exact (mul_eq_zero.mp this).resolve_right h.polar_w1
  simp only [hs, zero_mul, zero_pow two_ne_zero, add_zero] at ha
  exact h.free_not_isotropic ha

/-- Distinct parameters give non-proportional residual points. -/
theorem param_not_proportional (h : StereoLineFrame Q p w0 w1) {s t : F} (hst : s ≠ t) :
    ¬∃ c : F, stereoLineParam Q p w0 w1 s = c • stereoLineParam Q p w0 w1 t := by
  rintro ⟨c, hc⟩
  have hs := h.param_eq s
  have ht := h.param_eq t
  have hcomp :
      (fun i =>
          (eval w0 Q + s * polarEval Q w0 w1 + s ^ 2 * eval w1 Q) * p i -
            s * polarEval Q p w1 * w0 i - s ^ 2 * polarEval Q p w1 * w1 i) =
        fun i =>
          c *
            ((eval w0 Q + t * polarEval Q w0 w1 + t ^ 2 * eval w1 Q) * p i -
              t * polarEval Q p w1 * w0 i - t ^ 2 * polarEval Q p w1 * w1 i) := by
    funext i
    have := congr_fun hc i
    simp only [hs, ht, Pi.smul_apply, smul_eq_mul] at this
    exact this
  have hlin :
      ∀ i,
        (eval w0 Q + s * polarEval Q w0 w1 + s ^ 2 * eval w1 Q -
              c * (eval w0 Q + t * polarEval Q w0 w1 + t ^ 2 * eval w1 Q)) *
              p i +
            ((-s + c * t) * polarEval Q p w1) * w0 i +
              ((-s ^ 2 + c * t ^ 2) * polarEval Q p w1) * w1 i =
          0 := by
    intro i
    have hi := congr_fun hcomp i
    linear_combination hi
  obtain ⟨_ha, hb, hc0⟩ := eq_zero_of_lincomb_frameMatrix h.frame_det hlin
  have hB1 := h.polar_w1
  have hct : c * t = s := by
    have : (-s + c * t) * polarEval Q p w1 = 0 := hb
    have : -s + c * t = 0 := (mul_eq_zero.mp this).resolve_right hB1
    linear_combination this
  have hct2 : c * t ^ 2 = s ^ 2 := by
    have : (-s ^ 2 + c * t ^ 2) * polarEval Q p w1 = 0 := hc0
    have : -s ^ 2 + c * t ^ 2 = 0 := (mul_eq_zero.mp this).resolve_right hB1
    linear_combination this
  have hss : s * s = s * t := by
    calc
      s * s = s ^ 2 := by ring
      _ = c * t ^ 2 := hct2.symm
      _ = (c * t) * t := by ring
      _ = s * t := by rw [hct]
  have hfactor : s * (s - t) = 0 := by linear_combination hss
  rcases mul_eq_zero.mp hfactor with hs0 | hst'
  · have ht0 : t ≠ 0 := fun ht0 => hst (hs0.trans ht0.symm)
    have hc00 : c = 0 := by
      have : c * t = 0 := by rw [hct, hs0]
      exact (mul_eq_zero.mp this).resolve_right ht0
    have hφs : stereoLineParam Q p w0 w1 s = 0 := by
      funext i
      have := congr_fun hc i
      simp only [hc00, Pi.smul_apply, smul_eq_mul, zero_mul] at this
      exact this
    exact h.param_ne_zero s hφs
  · exact hst (sub_eq_zero.mp hst')

theorem param_projectivization_injective (h : StereoLineFrame Q p w0 w1) {s t : F}
    (hst : s ≠ t) :
    Projectivization.mk F (stereoLineParam Q p w0 w1 s) (h.param_ne_zero s) ≠
      Projectivization.mk F (stereoLineParam Q p w0 w1 t) (h.param_ne_zero t) := by
  intro heq
  rw [Projectivization.mk_eq_mk_iff] at heq
  obtain ⟨u, hu⟩ := heq
  exact h.param_not_proportional hst ⟨(u : F), by
    funext i
    have := congr_fun hu i
    simp only [Units.smul_def, Pi.smul_apply, smul_eq_mul] at this
    exact this.symm⟩

end StereoLineFrame

/-! ### Infinitude -/

/-- `RatFunc k` is always infinite (image of the infinite polynomial ring). -/
instance instInfiniteRatFunc (k : Type u) [Field k] : Infinite (RatFunc k) :=
  Infinite.of_injective (algebraMap (Polynomial k) (RatFunc k))
    (IsFractionRing.injective (Polynomial k) (RatFunc k))

/-- Over an infinite field, a residual frame produces infinitely many projective conic points. -/
theorem infinite_projective_points_of_stereoLineFrame [Infinite F]
    {Q : MvPolynomial (Fin 3) F} {p w0 w1 : Fin 3 → F}
    (h : StereoLineFrame Q p w0 w1) :
    Set.Infinite
      (Set.range fun s : F =>
        Projectivization.mk F (stereoLineParam Q p w0 w1 s) (h.param_ne_zero s)) := by
  refine Set.infinite_range_of_injective fun s t heq => ?_
  by_contra hne
  exact h.param_projectivization_injective hne heq

/-- Instantiation over `RatFunc k`. -/
theorem infinite_projective_points_ratFunc (k : Type u) [Field k]
    {Q : MvPolynomial (Fin 3) (RatFunc k)} {p w0 w1 : Fin 3 → RatFunc k}
    (h : StereoLineFrame Q p w0 w1) :
    Set.Infinite
      (Set.range fun s : RatFunc k =>
        Projectivization.mk (RatFunc k) (stereoLineParam Q p w0 w1 s)
          (h.param_ne_zero s)) :=
  infinite_projective_points_of_stereoLineFrame h

/-! ### Excision of finitely many polynomial conditions -/

/-- Finitely many nonzero univariate polynomials over an infinite field have a common nonroot. -/
theorem exists_eval_ne_zero_of_finite_ne_zero [Infinite F] {ι : Type*} [Finite ι]
    (f : ι → Polynomial F) (hf : ∀ i, f i ≠ 0) :
    ∃ s : F, ∀ i, Polynomial.eval s (f i) ≠ 0 := by
  classical
  let bad : Set F := ⋃ i : ι, {s | Polynomial.eval s (f i) = 0}
  have hbad_finite : bad.Finite :=
    Set.finite_iUnion fun i =>
      (f i).roots.toFinset.finite_toSet.subset fun s hs => by
        simp only [Set.mem_setOf_eq] at hs
        exact Multiset.mem_toFinset.mpr ((Polynomial.mem_roots (hf i)).mpr hs)
  have hcompl : (badᶜ).Nonempty :=
    Set.Infinite.nonempty (Set.Finite.infinite_compl hbad_finite)
  obtain ⟨s, hs⟩ := hcompl
  refine ⟨s, fun i hi => ?_⟩
  exact hs (Set.mem_iUnion.mpr ⟨i, hi⟩)

/-- **Excision.** If each polynomial condition pulls back nontrivially along the residual line,
some parameter avoids them all. -/
theorem exists_stereoLineParam_avoid [Infinite F]
    (Q : MvPolynomial (Fin 3) F) (hQ : Q.IsHomogeneous 2)
    (p w0 w1 : Fin 3 → F) {ι : Type*} [Finite ι]
    (G : ι → MvPolynomial (Fin 3) F)
    (hG : ∀ i, stereoLineCompose Q hQ p w0 w1 (G i) ≠ 0) :
    ∃ s : F, ∀ i, eval (stereoLineParam Q p w0 w1 s) (G i) ≠ 0 := by
  obtain ⟨s, hs⟩ :=
    exists_eval_ne_zero_of_finite_ne_zero (fun i => stereoLineCompose Q hQ p w0 w1 (G i)) hG
  refine ⟨s, fun i => ?_⟩
  simpa [eval_stereoLineCompose] using hs i

/-! ### Frame existence note

Given `det (polarMatrix Q) ≠ 0` and an isotropic nonzero `p`, a residual frame exists:
the polar form at `p` is a nonzero linear form (else the radical is nontrivial), its kernel is
the tangent plane (containing `p`), `Q` does not vanish identically on that plane (else a
2-dimensional totally isotropic subspace contradicts nondegeneracy), and any complementary
transverse direction `w₁` completes the frame.  The injectivity and infinitude lemmas above
take the resulting `StereoLineFrame` as an explicit hypothesis; the intended consumer discharges
it from smoothness of `Q_L` over `F = RatFunc k`.

-/

/-! ### Bridge to polynomial Tsen sections over `RatFunc k` -/

variable {k : Type u} [Field k]

/-- Lift a matrix ternary quadratic over `k[t]` to `RatFunc k` by coefficient extension. -/
def ternaryQuadraticPolyRatFunc (Q : @TernaryQuadraticPoly k _) :
    Fin 3 → Fin 3 → RatFunc k :=
  fun i j => algebraMap (Polynomial k) (RatFunc k) (Q i j)

/-- Evaluation of the coefficient-extended form. -/
def TernaryQuadraticPoly.evalRatFunc (Q : @TernaryQuadraticPoly k _)
    (x : Fin 3 → RatFunc k) : RatFunc k :=
  ∑ i : Fin 3, ∑ j : Fin 3, ternaryQuadraticPolyRatFunc Q i j * x i * x j

theorem TernaryQuadraticPoly.evalRatFunc_algebraMap
    (Q : @TernaryQuadraticPoly k _) (v : Fin 3 → Polynomial k) :
    TernaryQuadraticPoly.evalRatFunc Q (fun i => algebraMap _ (RatFunc k) (v i)) =
      algebraMap (Polynomial k) (RatFunc k) (TernaryQuadraticPoly.eval Q v) := by
  simp only [TernaryQuadraticPoly.evalRatFunc, TernaryQuadraticPoly.eval,
    ternaryQuadraticPolyRatFunc, map_sum, map_mul]

/-- **Forward bridge.** A nonzero isotropic polynomial triple gives a nonzero isotropic point
over `RatFunc k`. -/
theorem isotropic_ratFunc_of_poly
    (Q : @TernaryQuadraticPoly k _)
    (v : Fin 3 → Polynomial k) (hv0 : v ≠ 0)
    (hv : TernaryQuadraticPoly.eval Q v = 0) :
    (fun i => algebraMap (Polynomial k) (RatFunc k) (v i)) ≠ 0 ∧
      TernaryQuadraticPoly.evalRatFunc Q
        (fun i => algebraMap (Polynomial k) (RatFunc k) (v i)) = 0 := by
  refine ⟨?_, ?_⟩
  · intro h0
    apply hv0
    funext i
    have hi := congr_fun h0 i
    simp only [Pi.zero_apply] at hi
    exact (IsFractionRing.injective (Polynomial k) (RatFunc k)).eq_iff.mp
      (by simpa [map_zero] using hi)
  · rw [TernaryQuadraticPoly.evalRatFunc_algebraMap, hv, map_zero]

/-- Homogeneity of the matrix pairing: scaling multiplies the value by the square. -/
theorem TernaryQuadraticPoly.evalRatFunc_smul
    (Q : @TernaryQuadraticPoly k _) (c : RatFunc k) (x : Fin 3 → RatFunc k) :
    TernaryQuadraticPoly.evalRatFunc Q (fun i => c * x i) =
      c * c * TernaryQuadraticPoly.evalRatFunc Q x := by
  simp only [TernaryQuadraticPoly.evalRatFunc]
  calc
    (∑ i, ∑ j, ternaryQuadraticPolyRatFunc Q i j * (c * x i) * (c * x j)) =
        ∑ i, ∑ j, c * c * (ternaryQuadraticPolyRatFunc Q i j * x i * x j) := by
      refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
      ring
    _ = c * c * ∑ i, ∑ j, ternaryQuadraticPolyRatFunc Q i j * x i * x j := by
      simp only [Finset.mul_sum]

/-- Clear a common denominator for a triple of rational functions. -/
theorem exists_common_denom_smul (x : Fin 3 → RatFunc k) :
    ∃ (d : Polynomial k) (_hd : d ≠ 0) (v : Fin 3 → Polynomial k),
      ∀ i, algebraMap (Polynomial k) (RatFunc k) (v i) =
        algebraMap (Polynomial k) (RatFunc k) d * x i := by
  classical
  obtain ⟨n0, d0, hd0mem, heq0⟩ :=
    IsFractionRing.div_surjective (K := RatFunc k) (A := Polynomial k) (x 0)
  obtain ⟨n1, d1, hd1mem, heq1⟩ :=
    IsFractionRing.div_surjective (K := RatFunc k) (A := Polynomial k) (x 1)
  obtain ⟨n2, d2, hd2mem, heq2⟩ :=
    IsFractionRing.div_surjective (K := RatFunc k) (A := Polynomial k) (x 2)
  -- heq* : algebraMap n / algebraMap d = x
  have hd0 : d0 ≠ 0 := nonZeroDivisors.ne_zero hd0mem
  have hd1 : d1 ≠ 0 := nonZeroDivisors.ne_zero hd1mem
  have hd2 : d2 ≠ 0 := nonZeroDivisors.ne_zero hd2mem
  have hd : d0 * d1 * d2 ≠ 0 := mul_ne_zero (mul_ne_zero hd0 hd1) hd2
  have hφ0 : algebraMap (Polynomial k) (RatFunc k) d0 ≠ 0 :=
    (map_ne_zero_iff _ (IsFractionRing.injective (Polynomial k) (RatFunc k))).mpr hd0
  have hφ1 : algebraMap (Polynomial k) (RatFunc k) d1 ≠ 0 :=
    (map_ne_zero_iff _ (IsFractionRing.injective (Polynomial k) (RatFunc k))).mpr hd1
  have hφ2 : algebraMap (Polynomial k) (RatFunc k) d2 ≠ 0 :=
    (map_ne_zero_iff _ (IsFractionRing.injective (Polynomial k) (RatFunc k))).mpr hd2
  let v : Fin 3 → Polynomial k := fun i =>
    if i = 0 then n0 * d1 * d2 else if i = 1 then n1 * d0 * d2 else n2 * d0 * d1
  refine ⟨d0 * d1 * d2, hd, v, ?_⟩
  intro i
  have hgoal0 :
      algebraMap (Polynomial k) (RatFunc k) (n0 * d1 * d2) =
        algebraMap _ _ (d0 * d1 * d2) * x 0 := by
    calc
      algebraMap (Polynomial k) (RatFunc k) (n0 * d1 * d2) =
          algebraMap _ _ n0 * algebraMap _ _ d1 * algebraMap _ _ d2 := by simp [map_mul]
      _ = (algebraMap _ _ d0 * algebraMap _ _ d1 * algebraMap _ _ d2) *
            (algebraMap _ _ n0 / algebraMap _ _ d0) := by field_simp [hφ0]
      _ = algebraMap _ _ (d0 * d1 * d2) * x 0 := by simp [map_mul, heq0]
  have hgoal1 :
      algebraMap (Polynomial k) (RatFunc k) (n1 * d0 * d2) =
        algebraMap _ _ (d0 * d1 * d2) * x 1 := by
    calc
      algebraMap (Polynomial k) (RatFunc k) (n1 * d0 * d2) =
          algebraMap _ _ n1 * algebraMap _ _ d0 * algebraMap _ _ d2 := by simp [map_mul]
      _ = (algebraMap _ _ d0 * algebraMap _ _ d1 * algebraMap _ _ d2) *
            (algebraMap _ _ n1 / algebraMap _ _ d1) := by field_simp [hφ1]
      _ = algebraMap _ _ (d0 * d1 * d2) * x 1 := by simp [map_mul, heq1]
  have hgoal2 :
      algebraMap (Polynomial k) (RatFunc k) (n2 * d0 * d1) =
        algebraMap _ _ (d0 * d1 * d2) * x 2 := by
    calc
      algebraMap (Polynomial k) (RatFunc k) (n2 * d0 * d1) =
          algebraMap _ _ n2 * algebraMap _ _ d0 * algebraMap _ _ d1 := by simp [map_mul]
      _ = (algebraMap _ _ d0 * algebraMap _ _ d1 * algebraMap _ _ d2) *
            (algebraMap _ _ n2 / algebraMap _ _ d2) := by field_simp [hφ2]
      _ = algebraMap _ _ (d0 * d1 * d2) * x 2 := by simp [map_mul, heq2]
  match i with
  | ⟨0, _⟩ => simpa [v] using hgoal0
  | ⟨1, _⟩ => simpa [v] using hgoal1
  | ⟨2, _⟩ => simpa [v] using hgoal2

/-- **Reverse bridge.** An isotropic point over `RatFunc k` clears denominators to a nonzero
isotropic polynomial triple. -/
theorem exists_poly_isotropic_of_ratFunc
    (Q : @TernaryQuadraticPoly k _)
    (x : Fin 3 → RatFunc k) (hx0 : x ≠ 0)
    (hx : TernaryQuadraticPoly.evalRatFunc Q x = 0) :
    ∃ v : Fin 3 → Polynomial k, v ≠ 0 ∧ TernaryQuadraticPoly.eval Q v = 0 := by
  classical
  obtain ⟨d, hd, v, hv⟩ := exists_common_denom_smul x
  have hmap :
      TernaryQuadraticPoly.evalRatFunc Q (fun i => algebraMap _ (RatFunc k) (v i)) = 0 := by
    have : (fun i => algebraMap _ (RatFunc k) (v i)) =
        fun i => algebraMap _ (RatFunc k) d * x i := funext hv
    rw [this, TernaryQuadraticPoly.evalRatFunc_smul, hx, mul_zero]
  have hpol :
      algebraMap (Polynomial k) (RatFunc k) (TernaryQuadraticPoly.eval Q v) = 0 := by
    rwa [← TernaryQuadraticPoly.evalRatFunc_algebraMap]
  have heval : TernaryQuadraticPoly.eval Q v = 0 :=
    (IsFractionRing.injective (Polynomial k) (RatFunc k)).eq_iff.mp (by simpa using hpol)
  have hv0 : v ≠ 0 := by
    intro hvz
    apply hx0
    funext i
    have : algebraMap _ (RatFunc k) d * x i = 0 := by
      simpa [hvz, map_zero] using (hv i).symm
    have hd' : algebraMap (Polynomial k) (RatFunc k) d ≠ 0 :=
      (map_ne_zero_iff _ (IsFractionRing.injective (Polynomial k) (RatFunc k))).mpr hd
    exact (mul_eq_zero.mp this).resolve_left hd'
  exact ⟨v, hv0, heval⟩

/-- Two-way bridge summary for Tsen sections over `RatFunc k`. -/
theorem tsen_section_ratFunc_bridge (Q : @TernaryQuadraticPoly k _) :
    (∃ v : Fin 3 → Polynomial k, v ≠ 0 ∧ TernaryQuadraticPoly.eval Q v = 0) ↔
      ∃ x : Fin 3 → RatFunc k, x ≠ 0 ∧ TernaryQuadraticPoly.evalRatFunc Q x = 0 := by
  constructor
  · rintro ⟨v, hv0, hv⟩
    refine ⟨fun i => algebraMap _ _ (v i), ?_⟩
    exact isotropic_ratFunc_of_poly Q v hv0 hv
  · rintro ⟨x, hx0, hx⟩
    exact exists_poly_isotropic_of_ratFunc Q x hx0 hx

end
end BConicBundleMultisections
