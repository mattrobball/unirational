/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BigradedPolynomial

/-!
# Polynomial equations of biprojective fibers

This file defines partial evaluation in either block of Cox coordinates.  Fixing a representative
of a point in the first factor turns a polynomial of bidegree `(d, e)` into a homogeneous
polynomial of degree `e` in the second block; fixing the second factor gives a homogeneous
polynomial of degree `d` in the first block.

These are polynomial-level equations.  Their identification with scheme-theoretic fibers of the
two projections is a separate base-change theorem.
-/

@[expose] public section

namespace MvPolynomial

open Finsupp

variable {σ τ R S : Type*} [CommSemiring R] [CommSemiring S]

/-- Evaluating a weighted-homogeneous polynomial at homogeneous polynomials whose ordinary
degrees are the corresponding weights produces an ordinary homogeneous polynomial. -/
theorem IsWeightedHomogeneous.eval₂_isHomogeneous
    {w : σ → ℕ} {F : MvPolynomial σ R} {d : ℕ}
    (hF : F.IsWeightedHomogeneous w d)
    (f : R →+* MvPolynomial τ S) (g : σ → MvPolynomial τ S)
    (hf : ∀ r, (f r).IsHomogeneous 0)
    (hg : ∀ i, (g i).IsHomogeneous (w i)) :
    (eval₂ f g F).IsHomogeneous d := by
  induction hF using IsWeightedHomogeneous.induction_on with
  | zero => simpa using isHomogeneous_zero τ S d
  | add p q hp hq ihp ihq =>
      rw [eval₂_add]
      exact ihp.add ihq
  | monomial p r hr =>
      rw [eval₂_monomial]
      rw [← zero_add d]
      apply (hf r).mul
      convert IsHomogeneous.prod p.support (fun i ↦ g i ^ p i)
          (fun i ↦ w i * p i) (fun i _ ↦ (hg i).pow (p i)) using 1
      · rfl
      · rw [← hr, weight_apply]
        simp only [smul_eq_mul]
        exact Finset.sum_congr rfl (fun i _ ↦ mul_comm (p i) (w i))

/-- Algebraic evaluation is the coefficient-preserving specialization of
`IsWeightedHomogeneous.eval₂_isHomogeneous`. -/
theorem IsWeightedHomogeneous.aeval_isHomogeneous
    {w : σ → ℕ} {F : MvPolynomial σ R} {d : ℕ}
    (hF : F.IsWeightedHomogeneous w d)
    [Algebra R S] (g : σ → MvPolynomial τ S)
    (hg : ∀ i, (g i).IsHomogeneous (w i)) :
    (aeval g F).IsHomogeneous d := by
  exact hF.eval₂_isHomogeneous (C.comp (algebraMap R S)) g
    (fun r ↦ isHomogeneous_C _ _) hg

/-- Scaling the value assigned to each variable by the corresponding power of its weight scales
the value of a weighted-homogeneous polynomial by its total weighted degree. -/
theorem IsWeightedHomogeneous.eval₂_weight_smul
    {w : σ → ℕ} {F : MvPolynomial σ R} {d : ℕ}
    (hF : F.IsWeightedHomogeneous w d)
    (f : R →+* S) (g : σ → S) (r : S) :
    eval₂ f (fun i ↦ r ^ w i * g i) F = r ^ d * eval₂ f g F := by
  induction hF using IsWeightedHomogeneous.induction_on with
  | zero => simp
  | add p q hp hq ihp ihq => simp [ihp, ihq, mul_add]
  | monomial s a hs =>
      rw [eval₂_monomial, eval₂_monomial]
      simp_rw [mul_pow, ← pow_mul]
      rw [Finsupp.prod, Finset.prod_mul_distrib,
        Finset.prod_pow_eq_pow_sum]
      have hs' : ∑ i ∈ s.support, w i * s i = d := by
        rw [← hs, weight_apply]
        apply Finset.sum_congr rfl
        intro i hi
        simp [mul_comm]
      rw [hs']
      simp only [Finsupp.prod]
      ac_rfl

end MvPolynomial

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial

/-- Evaluate the first block of Cox coordinates at `x`, leaving a polynomial in the second
block. -/
def specializeFirstCoordinates {m n : ℕ} {R : Type*} [CommSemiring R]
    (x : Fin (m + 1) → R) :
    MvPolynomial (BiprojectiveCoordinate m n) R →ₐ[R]
      MvPolynomial (Fin (n + 1)) R :=
  MvPolynomial.aeval fun z ↦ match z with
    | .inl i => C (x i)
    | .inr j => X j

/-- Evaluate the second block of Cox coordinates at `y`, leaving a polynomial in the first
block. -/
def specializeSecondCoordinates {m n : ℕ} {R : Type*} [CommSemiring R]
    (y : Fin (n + 1) → R) :
    MvPolynomial (BiprojectiveCoordinate m n) R →ₐ[R]
      MvPolynomial (Fin (m + 1)) R :=
  MvPolynomial.aeval fun z ↦ match z with
    | .inl i => X i
    | .inr j => C (y j)

/-- Partial evaluation in the first block preserves constants. -/
theorem specializeFirstCoordinates_C {m n : ℕ} {R : Type*} [CommSemiring R]
    (x : Fin (m + 1) → R) (r : R) :
    specializeFirstCoordinates (n := n) x (C r) = C r := by
  simp [specializeFirstCoordinates]

/-- Partial evaluation in the first block evaluates a first-block variable. -/
@[simp]
theorem specializeFirstCoordinates_X_inl {m n : ℕ} {R : Type*} [CommSemiring R]
    (x : Fin (m + 1) → R) (i : Fin (m + 1)) :
    specializeFirstCoordinates (n := n) x (X (.inl i)) = C (x i) := by
  simp [specializeFirstCoordinates]

/-- Partial evaluation in the first block preserves a second-block variable. -/
@[simp]
theorem specializeFirstCoordinates_X_inr {m n : ℕ} {R : Type*} [CommSemiring R]
    (x : Fin (m + 1) → R) (j : Fin (n + 1)) :
    specializeFirstCoordinates (n := n) x (X (.inr j)) = X j := by
  simp [specializeFirstCoordinates]

/-- Partial evaluation in the second block preserves constants. -/
theorem specializeSecondCoordinates_C {m n : ℕ} {R : Type*} [CommSemiring R]
    (y : Fin (n + 1) → R) (r : R) :
    specializeSecondCoordinates (m := m) y (C r) = C r := by
  simp [specializeSecondCoordinates]

/-- Partial evaluation in the second block preserves a first-block variable. -/
@[simp]
theorem specializeSecondCoordinates_X_inl {m n : ℕ} {R : Type*} [CommSemiring R]
    (y : Fin (n + 1) → R) (i : Fin (m + 1)) :
    specializeSecondCoordinates (m := m) y (X (.inl i)) = X i := by
  simp [specializeSecondCoordinates]

/-- Partial evaluation in the second block evaluates a second-block variable. -/
@[simp]
theorem specializeSecondCoordinates_X_inr {m n : ℕ} {R : Type*} [CommSemiring R]
    (y : Fin (n + 1) → R) (j : Fin (n + 1)) :
    specializeSecondCoordinates (m := m) y (X (.inr j)) = C (y j) := by
  simp [specializeSecondCoordinates]

/-- Partial evaluation in the first coordinate block commutes with differentiation in the
second block. -/
theorem specializeFirstCoordinates_pderiv_inr
    {m n : ℕ} {R : Type*} [CommSemiring R]
    (x : Fin (m + 1) → R) (j : Fin (n + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    specializeFirstCoordinates x (pderiv (.inr j) F) =
      pderiv j (specializeFirstCoordinates x F) := by
  classical
  induction F using MvPolynomial.induction_on with
  | C a => simp
  | add p q hp hq => simp [hp, hq]
  | mul_X p z h =>
      simp only [Derivation.leibniz, map_add, map_mul, pderiv_X,
        Pi.single_apply]
      cases z with
      | inl i => simp [h, mul_comm]
      | inr j' =>
          by_cases hj : j' = j <;> simp [h, hj, mul_comm]

/-- Partial evaluation in the second coordinate block commutes with differentiation in the
first block. -/
theorem specializeSecondCoordinates_pderiv_inl
    {m n : ℕ} {R : Type*} [CommSemiring R]
    (y : Fin (n + 1) → R) (i : Fin (m + 1))
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    specializeSecondCoordinates y (pderiv (.inl i) F) =
      pderiv i (specializeSecondCoordinates y F) := by
  classical
  induction F using MvPolynomial.induction_on with
  | C a => simp
  | add p q hp hq => simp [hp, hq]
  | mul_X p z h =>
      simp only [Derivation.leibniz, map_add, map_mul, pderiv_X,
        Pi.single_apply]
      cases z with
      | inl i' =>
          by_cases hi : i' = i <;> simp [h, hi, mul_comm]
      | inr j => simp [h, mul_comm]

/-- Evaluating after fixing the first coordinate block is the same as evaluating the original
polynomial at both coordinate blocks simultaneously. -/
@[simp]
theorem eval_specializeFirstCoordinates
    {m n : ℕ} {R : Type*} [CommSemiring R]
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    eval y (specializeFirstCoordinates x F) = eval (Sum.elim x y) F := by
  rw [specializeFirstCoordinates, aeval_def, eval_eval₂]
  have hc : (eval y).comp (algebraMap R (MvPolynomial (Fin (n + 1)) R)) =
      RingHom.id R := by
    ext r
    simp
  rw [hc]
  change eval₂ (RingHom.id R) _ F = eval₂ (RingHom.id R) _ F
  apply eval₂_congr
  intro z c hz hc
  cases z <;> simp

/-- Evaluating after fixing the second coordinate block is the same as evaluating the original
polynomial at both coordinate blocks simultaneously. -/
@[simp]
theorem eval_specializeSecondCoordinates
    {m n : ℕ} {R : Type*} [CommSemiring R]
    (x : Fin (m + 1) → R) (y : Fin (n + 1) → R)
    (F : MvPolynomial (BiprojectiveCoordinate m n) R) :
    eval x (specializeSecondCoordinates y F) = eval (Sum.elim x y) F := by
  rw [specializeSecondCoordinates, aeval_def, eval_eval₂]
  have hc : (eval x).comp (algebraMap R (MvPolynomial (Fin (m + 1)) R)) =
      RingHom.id R := by
    ext r
    simp
  rw [hc]
  change eval₂ (RingHom.id R) _ F = eval₂ (RingHom.id R) _ F
  apply eval₂_congr
  intro z c hz hc
  cases z <;> simp

/-- Rescaling the first projective-coordinate representative rescales a bidegree-`(d, e)` fiber
equation by the `d`-th power of the scalar. -/
theorem IsBihomogeneousOfBidegree.specializeFirstCoordinates_smul
    {m n d e : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (r : R) (x : Fin (m + 1) → R) :
    specializeFirstCoordinates (r • x) F =
      C (r ^ d) * specializeFirstCoordinates x F := by
  rw [specializeFirstCoordinates, specializeFirstCoordinates]
  rw [aeval_def, aeval_def]
  have h := hF.isWeightedHomogeneous_left.eval₂_weight_smul
    (algebraMap R (MvPolynomial (Fin (n + 1)) R))
    (fun z ↦ match z with
      | .inl i => C (x i)
      | .inr j => X j)
    (C r)
  rw [map_pow]
  convert h using 1
  apply eval₂_congr
  intro z s hz hs
  cases z <;> simp [leftDegreeWeight]

/-- Rescaling the second projective-coordinate representative rescales a bidegree-`(d, e)` fiber
equation by the `e`-th power of the scalar. -/
theorem IsBihomogeneousOfBidegree.specializeSecondCoordinates_smul
    {m n d e : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (r : R) (y : Fin (n + 1) → R) :
    specializeSecondCoordinates (r • y) F =
      C (r ^ e) * specializeSecondCoordinates y F := by
  rw [specializeSecondCoordinates, specializeSecondCoordinates]
  rw [aeval_def, aeval_def]
  have h := hF.isWeightedHomogeneous_right.eval₂_weight_smul
    (algebraMap R (MvPolynomial (Fin (m + 1)) R))
    (fun z ↦ match z with
      | .inl i => X i
      | .inr j => C (y j))
    (C r)
  rw [map_pow]
  convert h using 1
  apply eval₂_congr
  intro z s hz hs
  cases z <;> simp [rightDegreeWeight]

/-- Fixing the first coordinates of a bidegree-`(d, e)` polynomial leaves a homogeneous
degree-`e` equation in the second coordinates. -/
theorem IsBihomogeneousOfBidegree.specializeFirstCoordinates_isHomogeneous
    {m n d e : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (x : Fin (m + 1) → R) :
    (specializeFirstCoordinates x F).IsHomogeneous e := by
  apply hF.isWeightedHomogeneous_right.aeval_isHomogeneous
  intro z
  cases z with
  | inl i => exact isHomogeneous_C _ _
  | inr j => exact isHomogeneous_X _ _

/-- Fixing the second coordinates of a bidegree-`(d, e)` polynomial leaves a homogeneous
degree-`d` equation in the first coordinates. -/
theorem IsBihomogeneousOfBidegree.specializeSecondCoordinates_isHomogeneous
    {m n d e : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (y : Fin (n + 1) → R) :
    (specializeSecondCoordinates y F).IsHomogeneous d := by
  apply hF.isWeightedHomogeneous_left.aeval_isHomogeneous
  intro z
  cases z with
  | inl i => exact isHomogeneous_X _ _
  | inr j => exact isHomogeneous_C _ _

/-- A bidegree-`(2, 3)` equation restricts over the first projection to a homogeneous cubic. -/
theorem IsBidegree23.specializeFirstCoordinates_isHomogeneous
    {m n : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBidegree23 F) (x : Fin (m + 1) → R) :
    (specializeFirstCoordinates x F).IsHomogeneous 3 :=
  IsBihomogeneousOfBidegree.specializeFirstCoordinates_isHomogeneous hF x

/-- A bidegree-`(2, 3)` equation restricts over the second projection to a homogeneous quadric. -/
theorem IsBidegree23.specializeSecondCoordinates_isHomogeneous
    {m n : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBidegree23 F) (y : Fin (n + 1) → R) :
    (specializeSecondCoordinates y F).IsHomogeneous 2 :=
  IsBihomogeneousOfBidegree.specializeSecondCoordinates_isHomogeneous hF y

/-- Differentiating a positive-degree first-block variable lowers the first bidegree by one. -/
theorem IsBihomogeneousOfBidegree.pderiv_inl
    {m n d e : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F) (hd : 0 < d)
    (i : Fin (m + 1)) :
    IsBihomogeneousOfBidegree (d - 1) e (pderiv (.inl i) F) := by
  unfold IsBihomogeneousOfBidegree at hF ⊢
  apply hF.pderiv
  simp [bidegreeWeight, Nat.sub_add_cancel hd]

/-- Differentiating a positive-degree second-block variable lowers the second bidegree by one. -/
theorem IsBihomogeneousOfBidegree.pderiv_inr
    {m n d e : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F) (he : 0 < e)
    (j : Fin (n + 1)) :
    IsBihomogeneousOfBidegree d (e - 1) (pderiv (.inr j) F) := by
  unfold IsBihomogeneousOfBidegree at hF ⊢
  apply hF.pderiv
  simp [bidegreeWeight, Nat.sub_add_cancel he]

/-- After fixing the first coordinates, a first-block partial derivative remains homogeneous of
the original second bidegree. -/
theorem IsBihomogeneousOfBidegree.specializeFirstCoordinates_pderiv_inl_isHomogeneous
    {m n d e : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F) (hd : 0 < d)
    (x : Fin (m + 1) → R) (i : Fin (m + 1)) :
    (specializeFirstCoordinates (n := n) x (pderiv (.inl i) F)).IsHomogeneous e :=
  (hF.pderiv_inl hd i).specializeFirstCoordinates_isHomogeneous x

/-- After fixing the second coordinates, a second-block partial derivative remains homogeneous
of the original first bidegree. -/
theorem IsBihomogeneousOfBidegree.specializeSecondCoordinates_pderiv_inr_isHomogeneous
    {m n d e : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F) (he : 0 < e)
    (y : Fin (n + 1) → R) (j : Fin (n + 1)) :
    (specializeSecondCoordinates (m := m) y (pderiv (.inr j) F)).IsHomogeneous d :=
  (hF.pderiv_inr he j).specializeSecondCoordinates_isHomogeneous y

/-- If the equation vanishes identically after fixing the first coordinates, then every partial
in a remaining second-block variable also vanishes identically. -/
theorem specializeFirstCoordinates_pderiv_inr_eq_zero
    {m n : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (x : Fin (m + 1) → R)
    (hzero : specializeFirstCoordinates (n := n) x F = 0)
    (j : Fin (n + 1)) :
    specializeFirstCoordinates (n := n) x (pderiv (.inr j) F) = 0 := by
  rw [specializeFirstCoordinates_pderiv_inr, hzero, map_zero]

/-- If the equation vanishes identically after fixing the second coordinates, then every partial
in a remaining first-block variable also vanishes identically. -/
theorem specializeSecondCoordinates_pderiv_inl_eq_zero
    {m n : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (y : Fin (n + 1) → R)
    (hzero : specializeSecondCoordinates (m := m) y F = 0)
    (i : Fin (m + 1)) :
    specializeSecondCoordinates (m := m) y (pderiv (.inl i) F) = 0 := by
  rw [specializeSecondCoordinates_pderiv_inl, hzero, map_zero]

/-- Euler's identity in the first block after fixing the first coordinates. -/
theorem IsBihomogeneousOfBidegree.specializeFirstCoordinates_sum_pderiv_inl
    {m n d e : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (x : Fin (m + 1) → R) :
    ∑ i : Fin (m + 1),
        C (x i) * specializeFirstCoordinates (n := n) x (pderiv (.inl i) F) =
      d • specializeFirstCoordinates (n := n) x F := by
  have h := congrArg (specializeFirstCoordinates (n := n) x)
    hF.sum_inl_X_mul_pderiv
  simpa using h

/-- Euler's identity in the second block after fixing the second coordinates. -/
theorem IsBihomogeneousOfBidegree.specializeSecondCoordinates_sum_pderiv_inr
    {m n d e : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (y : Fin (n + 1) → R) :
    ∑ j : Fin (n + 1),
        C (y j) * specializeSecondCoordinates (m := m) y (pderiv (.inr j) F) =
      e • specializeSecondCoordinates (m := m) y F := by
  have h := congrArg (specializeSecondCoordinates (m := m) y)
    hF.sum_inr_X_mul_pderiv
  simpa using h

/-- At a normalized first-factor point, Euler's identity makes the remaining first partial
vanish once all the other first partials vanish. -/
theorem IsBihomogeneousOfBidegree.eval_specializeFirstCoordinates_pderiv_inl_eq_zero
    {m n d e : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (x : Fin (m + 1) → R) (i : Fin (m + 1)) (hx : x i = 1)
    (hzero : specializeFirstCoordinates (n := n) x F = 0)
    (y : Fin (n + 1) → R)
    (hothers : ∀ l : Fin (m + 1), l ≠ i →
      eval y (specializeFirstCoordinates (n := n) x (pderiv (.inl l) F)) = 0) :
    eval y (specializeFirstCoordinates (n := n) x (pderiv (.inl i) F)) = 0 := by
  have h := congrArg (eval y)
    (hF.specializeFirstCoordinates_sum_pderiv_inl x)
  rw [map_sum] at h
  rw [Finset.sum_eq_single i] at h
  · simpa [hx, hzero] using h
  · intro l hl hli
    simp [hothers l hli]
  · simp

/-- At a normalized second-factor point, Euler's identity makes the remaining second partial
vanish once all the other second partials vanish. -/
theorem IsBihomogeneousOfBidegree.eval_specializeSecondCoordinates_pderiv_inr_eq_zero
    {m n d e : ℕ} {R : Type*} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R}
    (hF : IsBihomogeneousOfBidegree d e F)
    (y : Fin (n + 1) → R) (j : Fin (n + 1)) (hy : y j = 1)
    (hzero : specializeSecondCoordinates (m := m) y F = 0)
    (x : Fin (m + 1) → R)
    (hothers : ∀ l : Fin (n + 1), l ≠ j →
      eval x (specializeSecondCoordinates (m := m) y (pderiv (.inr l) F)) = 0) :
    eval x (specializeSecondCoordinates (m := m) y (pderiv (.inr j) F)) = 0 := by
  have h := congrArg (eval x)
    (hF.specializeSecondCoordinates_sum_pderiv_inr y)
  rw [map_sum] at h
  rw [Finset.sum_eq_single j] at h
  · simpa [hy, hzero] using h
  · intro l hl hlj
    simp [hothers l hlj]
  · simp

end

end BConicBundleMultisections
