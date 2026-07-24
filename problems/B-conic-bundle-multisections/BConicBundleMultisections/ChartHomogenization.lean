/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.MvPolynomialHomogeneousEvaluation
public import BConicBundleMultisections.ProjectiveSpaceClosedPoints
public import Mathlib.RingTheory.MvPolynomial.Homogeneous

/-!
# Homogenizing along a projective chart

`ProjectiveSpace.affineCoordinates j x` reads the `n` affine coordinates of a homogeneous
representative `x : Fin (n+1) → S` normalized by `x j = 1`.  Evaluating an `n`-variable polynomial
at those affine coordinates is the same as evaluating its **homogenization** — the degree-`d` form
in `n + 1` variables obtained by padding each homogeneous component with a power of `X j` — at the
representative itself.

`chartHomogenization` is that homogenization, built from `homogeneousComponent` and `rename`, so
that `aeval_chartHomogenization` is the only computation needed.  Mathlib has homogenization only
for univariate polynomials (`Polynomial.homogenize`, into `MvPolynomial (Fin 2) R`); this is the
multivariate chart version.

The payoff is `injective_aeval_affineCoordinates`: to know that no nonzero polynomial vanishes on
the affine coordinate ratios of a projective point it suffices to know that no nonzero
**homogeneous form** vanishes on its homogeneous coordinates.  That converts a question about a
localization into a question about forms, which is where the geometry lives.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open MvPolynomial

/-! ### Rescaling an algebra-valued point -/

/-- A homogeneous polynomial of degree `d` evaluated at a uniformly rescaled algebra-valued point
picks up `r ^ d`.  Algebra-valued analogue of `eval_smul_point_of_isHomogeneous`; it is what makes
"pass to a chart-normalized representative" harmless for homogeneous forms. -/
theorem aeval_smul_point_of_isHomogeneous
    {σ : Type*} {R S : Type u} [CommSemiring R] [CommSemiring S] [Algebra R S]
    {f : MvPolynomial σ R} {d : ℕ} (h : f.IsHomogeneous d) (r : S) (p : σ → S) :
    aeval (fun i => r * p i) f = r ^ d * aeval p f := by
  have hmap : (map (algebraMap R S) f).IsHomogeneous d := by
    intro c hc
    exact h (fun h0 => hc (by rw [coeff_map, h0, map_zero]))
  rw [aeval_def, eval₂_eq_eval_map, aeval_def, eval₂_eq_eval_map]
  exact eval_smul_point_of_isHomogeneous hmap r p

namespace ProjectiveSpace

variable {n : ℕ} {R : Type u} [CommRing R]

/-- The degree-`d` homogenization of `p` along the chart variable `X j`.

Its `e`-th homogeneous component is the `e`-th homogeneous component of `p`, with its variables
renamed by `j.succAbove` and padded to degree `d` by `X j ^ (d - e)`. -/
def chartHomogenization (j : Fin (n + 1)) (d : ℕ) (p : MvPolynomial (Fin n) R) :
    MvPolynomial (Fin (n + 1)) R :=
  ∑ e ∈ Finset.range (d + 1),
    X j ^ (d - e) * rename j.succAbove (homogeneousComponent e p)

theorem chartHomogenization_isHomogeneous (j : Fin (n + 1)) (d : ℕ)
    (p : MvPolynomial (Fin n) R) :
    (chartHomogenization j d p).IsHomogeneous d := by
  refine IsHomogeneous.sum _ _ _ fun e he => ?_
  have hed : e ≤ d := Nat.lt_succ_iff.mp (Finset.mem_range.mp he)
  have hX : ((X j : MvPolynomial (Fin (n + 1)) R) ^ (d - e)).IsHomogeneous (d - e) := by
    simpa using (isHomogeneous_X R j).pow (d - e)
  have hcomp : (rename j.succAbove (homogeneousComponent e p)).IsHomogeneous e :=
    (homogeneousComponent_isHomogeneous e p).rename_isHomogeneous
  simpa [Nat.sub_add_cancel hed] using hX.mul hcomp

/-- The homogeneous components below the total degree bound already sum to the polynomial. -/
theorem sum_homogeneousComponent_of_totalDegree_le
    (d : ℕ) (p : MvPolynomial (Fin n) R) (hd : p.totalDegree ≤ d) :
    ∑ e ∈ Finset.range (d + 1), homogeneousComponent e p = p := by
  have hsub : Finset.range (p.totalDegree + 1) ⊆ Finset.range (d + 1) := by
    intro x hx
    simp only [Finset.mem_range] at hx ⊢
    omega
  have hz : ∀ e ∈ Finset.range (d + 1), e ∉ Finset.range (p.totalDegree + 1) →
      homogeneousComponent e p = 0 := by
    intro e _ he
    refine homogeneousComponent_eq_zero e p ?_
    by_contra hcon
    exact he (Finset.mem_range.mpr (Nat.lt_succ_of_le (not_lt.mp hcon)))
  rw [← Finset.sum_subset hsub hz]
  exact sum_homogeneousComponent p

/-- Evaluating the homogenization at a representative normalized by `y j = 1` is evaluating the
original polynomial at the affine coordinates. -/
theorem aeval_chartHomogenization {S : Type u} [CommRing S] [Algebra R S]
    (j : Fin (n + 1)) (d : ℕ) (p : MvPolynomial (Fin n) R) (hd : p.totalDegree ≤ d)
    (y : Fin (n + 1) → S) (hyj : y j = 1) :
    aeval y (chartHomogenization (R := R) j d p) = aeval (affineCoordinates j y) p := by
  have haff : affineCoordinates j y = y ∘ j.succAbove := rfl
  calc
    aeval y (chartHomogenization (R := R) j d p)
        = ∑ e ∈ Finset.range (d + 1),
            aeval y ((X j : MvPolynomial (Fin (n + 1)) R) ^ (d - e)) *
              aeval y (rename j.succAbove (homogeneousComponent e p)) := by
          simp only [chartHomogenization, map_sum, map_mul]
    _ = ∑ e ∈ Finset.range (d + 1),
          aeval (affineCoordinates j y) (homogeneousComponent e p) := by
          refine Finset.sum_congr rfl fun e _ => ?_
          rw [map_pow, aeval_X, hyj, one_pow, one_mul, aeval_rename, haff]
    _ = aeval (affineCoordinates j y) p := by
          rw [← map_sum, sum_homogeneousComponent_of_totalDegree_le d p hd]

/-- Homogenization is injective on polynomials of total degree at most `d`: it is undone by
evaluating at the tautological chart point `X j ↦ 1`, `X (j.succAbove r) ↦ X r`. -/
theorem eq_zero_of_chartHomogenization_eq_zero (j : Fin (n + 1)) (d : ℕ)
    (p : MvPolynomial (Fin n) R) (hd : p.totalDegree ≤ d)
    (h : chartHomogenization (R := R) j d p = 0) : p = 0 := by
  set y₀ : Fin (n + 1) → MvPolynomial (Fin n) R :=
    Fin.insertNth (α := fun _ => MvPolynomial (Fin n) R) j 1 X with hy₀
  have hy : y₀ j = 1 :=
    Fin.insertNth_apply_same (α := fun _ => MvPolynomial (Fin n) R) j 1 X
  have key := aeval_chartHomogenization (R := R) (S := MvPolynomial (Fin n) R) j d p hd y₀ hy
  have haff : affineCoordinates j y₀ = (X : Fin n → MvPolynomial (Fin n) R) := by
    funext r
    exact Fin.insertNth_apply_succAbove (α := fun _ => MvPolynomial (Fin n) R) j 1 X r
  rw [h, map_zero, haff] at key
  have hid : aeval (X : Fin n → MvPolynomial (Fin n) R) p = p := by
    simp [aeval_X_left]
  rw [hid] at key
  exact key.symm

/--
**No relation among the affine coordinates from no relation among the forms.**

If no nonzero homogeneous form in `n + 1` variables vanishes at a chart-normalized representative
`y` (`y j = 1`), then no nonzero polynomial in `n` variables vanishes at its affine coordinates.

This is the step that turns "the image of a rational map to `ℙⁿ` is not contained in a
hypersurface" into an injectivity statement about the chart evaluation.
-/
theorem injective_aeval_affineCoordinates {S : Type u} [CommRing S] [Algebra R S]
    (j : Fin (n + 1)) (y : Fin (n + 1) → S) (hyj : y j = 1)
    (h : ∀ (d : ℕ) (Ψ : MvPolynomial (Fin (n + 1)) R), Ψ.IsHomogeneous d →
      aeval y Ψ = 0 → Ψ = 0) :
    Function.Injective (aeval (affineCoordinates j y) : MvPolynomial (Fin n) R →ₐ[R] S) := by
  rw [injective_iff_map_eq_zero
    (aeval (affineCoordinates j y) : MvPolynomial (Fin n) R →ₐ[R] S)]
  intro p hp
  refine eq_zero_of_chartHomogenization_eq_zero j p.totalDegree p (le_refl _) ?_
  refine h p.totalDegree _ (chartHomogenization_isHomogeneous j p.totalDegree p) ?_
  rw [aeval_chartHomogenization j p.totalDegree p (le_refl _) y hyj]
  exact hp

end ProjectiveSpace

end

end BConicBundleMultisections
