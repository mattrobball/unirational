/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BiprojectiveAffineChart

/-!
# Jacobian formulas on standard biprojective charts

This file compares the partial derivatives of a bihomogeneous equation with those of its
ordinary affine equation on a standard product chart.  It also records the evaluation formulas
at normalized homogeneous representatives.  All statements retain arbitrary dimensions.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial

namespace BiprojectiveSpace

universe u

private lemma pderiv_affineChartVariable_inl_inr
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) (r : Fin m) (l : Fin (n + 1)) :
    pderiv (.inl r) (affineChartVariable m n R i j (.inr l)) = 0 := by
  simp only [affineChartVariable]
  induction l using j.succAboveCases with
  | _ => simp

private lemma pderiv_affineChartVariable_inr_inl
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) (s : Fin n) (l : Fin (m + 1)) :
    pderiv (.inr s) (affineChartVariable m n R i j (.inl l)) = 0 := by
  simp only [affineChartVariable]
  induction l using i.succAboveCases with
  | _ => simp

private lemma pderiv_aeval_affineChartVariable_inl
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) (r : Fin m)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    pderiv (.inl r) (aeval (affineChartVariable m n R i j) F) =
      aeval (affineChartVariable m n R i j) (pderiv (.inl (i.succAbove r)) F) := by
  induction F using MvPolynomial.induction_on with
  | C a =>
      simp
  | add p q hp hq =>
      simp [hp, hq]
  | mul_X p z hp =>
      simp only [map_mul, aeval_X, Derivation.leibniz, map_add, pderiv_X, Pi.single_apply, hp]
      cases z with
      | inl l =>
          rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨s, rfl⟩
          · simp [affineChartVariable]
          · by_cases hsr : s = r
            · subst hsr
              simp [affineChartVariable]
            · have hne : i.succAbove s ≠ i.succAbove r :=
                (Fin.succAbove_right_injective).ne hsr
              simp [affineChartVariable, hsr, hne]
      | inr l =>
          simp [pderiv_affineChartVariable_inl_inr]

private lemma pderiv_aeval_affineChartVariable_inr
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) (s : Fin n)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    pderiv (.inr s) (aeval (affineChartVariable m n R i j) F) =
      aeval (affineChartVariable m n R i j) (pderiv (.inr (j.succAbove s)) F) := by
  induction F using MvPolynomial.induction_on with
  | C a =>
      simp
  | add p q hp hq =>
      simp [hp, hq]
  | mul_X p z hp =>
      simp only [map_mul, aeval_X, Derivation.leibniz, map_add, pderiv_X, Pi.single_apply, hp]
      cases z with
      | inl l =>
          simp [pderiv_affineChartVariable_inr_inl]
      | inr l =>
          rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨t, rfl⟩
          · simp [affineChartVariable]
          · by_cases hts : t = s
            · subst hts
              simp [affineChartVariable]
            · have hne : j.succAbove t ≠ j.succAbove s :=
                (Fin.succAbove_right_injective).ne hts
              simp [affineChartVariable, hts, hne]

/-- Differentiating a product-chart equation in a left affine coordinate is the same as first
differentiating in the corresponding left homogeneous coordinate and then dehomogenizing. -/
theorem pderiv_affineChartEquation_inl
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) (r : Fin m)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    pderiv (.inl r) (affineChartEquation m n R i j F) =
      affineChartEquation m n R i j (pderiv (.inl (i.succAbove r)) F) := by
  simpa [affineChartEquation, affineChartEvaluation] using
    pderiv_aeval_affineChartVariable_inl m n R i j r F

/-- Differentiating a product-chart equation in a right affine coordinate is the same as first
differentiating in the corresponding right homogeneous coordinate and then dehomogenizing. -/
theorem pderiv_affineChartEquation_inr
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) (s : Fin n)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    pderiv (.inr s) (affineChartEquation m n R i j F) =
      affineChartEquation m n R i j (pderiv (.inr (j.succAbove s)) F) := by
  simpa [affineChartEquation, affineChartEvaluation] using
    pderiv_aeval_affineChartVariable_inr m n R i j s F

/-- The affine coordinates associated to normalized homogeneous representatives on a standard
product chart. -/
def affineChartPoint
    {m n : ℕ} {R : Type u}
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R) :
    Fin m ⊕ Fin n → R
  | .inl r => x (i.succAbove r)
  | .inr s => y (j.succAbove s)

/-- Evaluating a normalized chart variable at the associated affine point recovers the
corresponding homogeneous coordinate. -/
theorem eval_affineChartVariable_affineChartPoint
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (z : BiprojectiveCoordinate m n) :
    eval (affineChartPoint i j x y) (affineChartVariable m n R i j z) =
      Sum.elim x y z := by
  rcases z with l | l
  · rcases Fin.eq_self_or_eq_succAbove i l with rfl | ⟨r, rfl⟩
    · simp [affineChartVariable, hxi]
    · simp [affineChartVariable, affineChartPoint]
  · rcases Fin.eq_self_or_eq_succAbove j l with rfl | ⟨s, rfl⟩
    · simp [affineChartVariable, hyj]
    · simp [affineChartVariable, affineChartPoint]

/-- Evaluating the affine chart equation at normalized affine coordinates agrees with
evaluating the original homogeneous equation at the two representatives. -/
theorem eval_affineChartEquation_affineChartPoint
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    eval (affineChartPoint i j x y) (affineChartEquation m n R i j F) =
      eval (Sum.elim x y) F := by
  rw [affineChartEquation, affineChartEvaluation, aeval_def, eval_eval₂]
  have hc :
      (eval (affineChartPoint i j x y)).comp
          (algebraMap R (MvPolynomial (Fin m ⊕ Fin n) R)) =
        RingHom.id R := by
    ext a
    simp
  rw [hc]
  apply eval₂_congr
  intro z c hz hc'
  exact eval_affineChartVariable_affineChartPoint m n R i j x y hxi hyj z

/-- At normalized representatives, a left affine partial evaluates as the corresponding
homogeneous partial derivative. -/
theorem eval_pderiv_affineChartEquation_inl_affineChartPoint
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) (r : Fin m)
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    eval (affineChartPoint i j x y)
        (pderiv (.inl r) (affineChartEquation m n R i j F)) =
      eval (Sum.elim x y) (pderiv (.inl (i.succAbove r)) F) := by
  rw [pderiv_affineChartEquation_inl]
  exact eval_affineChartEquation_affineChartPoint m n R i j x y hxi hyj _

/-- At normalized representatives, a right affine partial evaluates as the corresponding
homogeneous partial derivative. -/
theorem eval_pderiv_affineChartEquation_inr_affineChartPoint
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1)) (s : Fin n)
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    eval (affineChartPoint i j x y)
        (pderiv (.inr s) (affineChartEquation m n R i j F)) =
      eval (Sum.elim x y) (pderiv (.inr (j.succAbove s)) F) := by
  rw [pderiv_affineChartEquation_inr]
  exact eval_affineChartEquation_affineChartPoint m n R i j x y hxi hyj _

/-- Homogeneous vanishing of a biprojective equation and all of its partials at normalized
representatives is equivalent to vanishing of the affine chart equation and all of its
affine partials at the associated affine point. -/
theorem affineChartEquation_vanishing_and_gradient_eq_zero
    (m n : ℕ) (R : Type u) [CommRing R]
    (i : Fin (m + 1)) (j : Fin (n + 1))
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (hxi : x i = 1) (hyj : y j = 1)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hF : eval (Sum.elim x y) F = 0)
    (hgrad : ∀ z : BiprojectiveCoordinate m n,
      eval (Sum.elim x y) (pderiv z F) = 0) :
    eval (affineChartPoint i j x y) (affineChartEquation m n R i j F) = 0 ∧
      ∀ q : Fin m ⊕ Fin n,
        eval (affineChartPoint i j x y)
          (pderiv q (affineChartEquation m n R i j F)) = 0 := by
  constructor
  · rw [eval_affineChartEquation_affineChartPoint m n R i j x y hxi hyj]
    exact hF
  · rintro (r | s)
    · rw [eval_pderiv_affineChartEquation_inl_affineChartPoint
        m n R i j r x y hxi hyj]
      exact hgrad (.inl (i.succAbove r))
    · rw [eval_pderiv_affineChartEquation_inr_affineChartPoint
        m n R i j s x y hxi hyj]
      exact hgrad (.inr (j.succAbove s))

end BiprojectiveSpace

end

end BConicBundleMultisections
