/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualRelationBigrading
public import Mathlib.RingTheory.Nullstellensatz

/-!
# From exhaustion of a target relation to Cox-ideal membership

Suppose a homogeneous target relation `H(y)` cuts out a vertical surface `X_H` and the residual
equation `q` vanishes at every projective point of `X_H`.  If the affine-cone ideal `(F,H)` is
prime, affine Nullstellensatz upgrades this pointwise statement to `q ∈ (F,H)`.

The only apparent gap between projective and affine zeros consists of points where one Cox block
is zero.  Bihomogeneity handles those points automatically when `q` has positive degree in each
block.  Thus the theorem below has no saturation shortcut hidden in it.

What remains geometric is precisely the pointwise-exhaustion hypothesis.  The source obtains it
from a degree-three reduced line section and injectivity of the tangent-residual map (or, in the
discriminant-avoidance route, from integrality of `X_H` and equality of the residual component with
`X_H`).  Those degree/component statements are not currently represented by the project API.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial

universe u

/-! ### Vanishing on the irrelevant coordinate blocks -/

/-- A bihomogeneous polynomial of positive second degree vanishes when every second-block
variable is set equal to zero. -/
theorem specializeSecondCoordinates_zero_of_bidegree_pos
    {m n : ℕ} {R : Type u} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R} {a b : ℕ}
    (hF : IsBihomogeneousOfBidegree a b F) (hb : 0 < b) :
    specializeSecondCoordinates (0 : Fin (n + 1) → R) F = 0 := by
  have h := hF.specializeSecondCoordinates_smul
    (0 : R) (0 : Fin (n + 1) → R)
  simpa [zero_pow hb.ne'] using h

/-- Positive first degree kills evaluation on the zero first block. -/
theorem aeval_sum_elim_zero_left_of_bidegree_pos
    {m n : ℕ} {R : Type u} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R} {a b : ℕ}
    (hF : IsBihomogeneousOfBidegree a b F) (ha : 0 < a)
    (y : Fin (n + 1) → R) :
    aeval (Sum.elim (0 : Fin (m + 1) → R) y) F = 0 := by
  change eval (Sum.elim (0 : Fin (m + 1) → R) y) F = 0
  rw [← eval_specializeFirstCoordinates,
    specializeFirstCoordinates_zero_of_bidegree_pos hF ha, map_zero]

/-- Positive second degree kills evaluation on the zero second block. -/
theorem aeval_sum_elim_zero_right_of_bidegree_pos
    {m n : ℕ} {R : Type u} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R} {a b : ℕ}
    (hF : IsBihomogeneousOfBidegree a b F) (hb : 0 < b)
    (x : Fin (m + 1) → R) :
    aeval (Sum.elim x (0 : Fin (n + 1) → R)) F = 0 := by
  change eval (Sum.elim x (0 : Fin (n + 1) → R)) F = 0
  rw [← eval_specializeSecondCoordinates,
    specializeSecondCoordinates_zero_of_bidegree_pos hF hb, map_zero]

/-! ### Affine Nullstellensatz -/

/-- If a polynomial vanishes at every common affine zero of `F` and `G`, it belongs to the
radical of `(F,G)`. -/
theorem mem_radical_span_pair_of_vanishes_on_common_zero
    {σ : Type*} [Finite σ] {K : Type u} [Field K] [IsAlgClosed K]
    {F G q : MvPolynomial σ K}
    (hvan : ∀ z : σ → K, aeval z F = 0 → aeval z G = 0 → aeval z q = 0) :
    q ∈ (Ideal.span {F, G}).radical := by
  rw [← MvPolynomial.vanishingIdeal_zeroLocus_eq_radical (K := K)]
  rw [MvPolynomial.mem_vanishingIdeal_iff]
  intro z hz
  rw [MvPolynomial.mem_zeroLocus_iff] at hz
  exact hvan z (hz F (Ideal.subset_span (by simp)))
    (hz G (Ideal.subset_span (by simp)))

/-- Radical-ideal form of the preceding Nullstellensatz bridge. -/
theorem mem_span_pair_of_vanishes_on_common_zero_of_isRadical
    {σ : Type*} [Finite σ] {K : Type u} [Field K] [IsAlgClosed K]
    {F G q : MvPolynomial σ K}
    (hradical : (Ideal.span {F, G}).IsRadical)
    (hvan : ∀ z : σ → K, aeval z F = 0 → aeval z G = 0 → aeval z q = 0) :
    q ∈ Ideal.span {F, G} := by
  have hmem := mem_radical_span_pair_of_vanishes_on_common_zero hvan
  rwa [hradical.radical] at hmem

/-- Prime-ideal specialization of the preceding radical-ideal bridge. -/
theorem mem_span_pair_of_vanishes_on_common_zero_of_isPrime
    {σ : Type*} [Finite σ] {K : Type u} [Field K] [IsAlgClosed K]
    {F G q : MvPolynomial σ K}
    (hprime : (Ideal.span {F, G}).IsPrime)
    (hvan : ∀ z : σ → K, aeval z F = 0 → aeval z G = 0 → aeval z q = 0) :
    q ∈ Ideal.span {F, G} := by
  exact mem_span_pair_of_vanishes_on_common_zero_of_isRadical hprime.isRadical hvan

/-! ### Projective exhaustion implies unsaturated Cox membership -/

/-- **Projective pointwise exhaustion gives unsaturated ideal membership.**

Here `hvan` says that every genuine biprojective point of `V(F,H(y))` also lies on `V(q)`.
Primeness of `(F,H)` is the affine-cone form of the no-extra-component/integrality input.  Since
`q` has positive degree in both Cox blocks, the irrelevant affine zeros with one block equal to
zero cause no problem, and Nullstellensatz gives membership in `(F,H)` itself. -/
theorem mem_span_F_rename_inr_of_projective_vanishing
    {m n : ℕ} {K : Type u} [Field K] [IsAlgClosed K]
    {F q : MvPolynomial (BiprojectiveCoordinate m n) K}
    {aq bq : ℕ} (hq : IsBihomogeneousOfBidegree aq bq q)
    (haq : 0 < aq) (hbq : 0 < bq)
    {H : MvPolynomial (Fin (n + 1)) K}
    (hprime : (Ideal.span {F,
      rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H}).IsPrime)
    (hvan : ∀ (x : Fin (m + 1) → K) (y : Fin (n + 1) → K),
      x ≠ 0 → y ≠ 0 →
      aeval (Sum.elim x y) F = 0 → aeval y H = 0 →
        aeval (Sum.elim x y) q = 0) :
    q ∈ Ideal.span {F,
      rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H} := by
  apply mem_span_pair_of_vanishes_on_common_zero_of_isRadical hprime.isRadical
  intro z hFz hHz
  let x : Fin (m + 1) → K := fun i => z (.inl i)
  let y : Fin (n + 1) → K := fun j => z (.inr j)
  have hz : Sum.elim x y = z := by
    funext a
    cases a <;> rfl
  rw [← hz] at hFz hHz ⊢
  by_cases hx : x = 0
  · simpa only [hx] using aeval_sum_elim_zero_left_of_bidegree_pos hq haq y
  by_cases hy : y = 0
  · simpa only [hy] using aeval_sum_elim_zero_right_of_bidegree_pos hq hbq x
  apply hvan x y hx hy hFz
  have hcomp : Sum.elim x y ∘
      (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) = y := by
    funext j
    rfl
  simpa only [aeval_rename, hcomp] using hHz

/-- Radical-ideal version of `mem_span_F_rename_inr_of_projective_vanishing`.

This is the exact algebraic form supplied by reducedness of the affine complete-intersection cone;
irreducibility is unnecessary. -/
theorem mem_span_F_rename_inr_of_projective_vanishing_of_isRadical
    {m n : ℕ} {K : Type u} [Field K] [IsAlgClosed K]
    {F q : MvPolynomial (BiprojectiveCoordinate m n) K}
    {aq bq : ℕ} (hq : IsBihomogeneousOfBidegree aq bq q)
    (haq : 0 < aq) (hbq : 0 < bq)
    {H : MvPolynomial (Fin (n + 1)) K}
    (hradical : (Ideal.span {F,
      rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H}).IsRadical)
    (hvan : ∀ (x : Fin (m + 1) → K) (y : Fin (n + 1) → K),
      x ≠ 0 → y ≠ 0 →
      aeval (Sum.elim x y) F = 0 → aeval y H = 0 →
        aeval (Sum.elim x y) q = 0) :
    q ∈ Ideal.span {F,
      rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H} := by
  apply mem_span_pair_of_vanishes_on_common_zero_of_isRadical hradical
  intro z hFz hHz
  let x : Fin (m + 1) → K := fun i => z (.inl i)
  let y : Fin (n + 1) → K := fun j => z (.inr j)
  have hz : Sum.elim x y = z := by
    funext a
    cases a <;> rfl
  rw [← hz] at hFz hHz ⊢
  by_cases hx : x = 0
  · simpa only [hx] using aeval_sum_elim_zero_left_of_bidegree_pos hq haq y
  by_cases hy : y = 0
  · simpa only [hy] using aeval_sum_elim_zero_right_of_bidegree_pos hq hbq x
  apply hvan x y hx hy hFz
  have hcomp : Sum.elim x y ∘
      (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) = y := by
    funext j
    rfl
  simpa only [aeval_rename, hcomp] using hHz

/-- Reduced affine-cone specialization of the residual `(10,1)` projective-exhaustion bridge. -/
theorem residualEquationOn_mem_span_targetRelation_of_projective_vanishing_of_isRadical
    {K : Type u} [Field K] [IsAlgClosed K] [Infinite K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F)
    {H : MvPolynomial (Fin 3) K}
    (hradical : (Ideal.span {F, rename Sum.inr H}).IsRadical)
    (hvan : ∀ (x y : Fin 3 → K), x ≠ 0 → y ≠ 0 →
      aeval (Sum.elim x y) F = 0 → aeval y H = 0 →
        aeval (Sum.elim x y) (residualEquationOn M N F) = 0) :
    residualEquationOn M N F ∈ Ideal.span {F, rename Sum.inr H} := by
  exact mem_span_F_rename_inr_of_projective_vanishing_of_isRadical
    (ResidualDivisor.residualEquationOn_isBihomogeneous M N hF)
    (by norm_num) (by norm_num) hradical hvan

/-- The residual `(10,1)` equation specialization of the projective-exhaustion bridge. -/
theorem residualEquationOn_mem_span_targetRelation_of_projective_vanishing
    {K : Type u} [Field K] [IsAlgClosed K] [Infinite K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F)
    {H : MvPolynomial (Fin 3) K}
    (hprime : (Ideal.span {F, rename Sum.inr H}).IsPrime)
    (hvan : ∀ (x y : Fin 3 → K), x ≠ 0 → y ≠ 0 →
      aeval (Sum.elim x y) F = 0 → aeval y H = 0 →
        aeval (Sum.elim x y) (residualEquationOn M N F) = 0) :
    residualEquationOn M N F ∈ Ideal.span {F, rename Sum.inr H} := by
  exact mem_span_F_rename_inr_of_projective_vanishing
    (ResidualDivisor.residualEquationOn_isBihomogeneous M N hF)
    (by norm_num) (by norm_num) hprime hvan

/-- Primitive endpoint when the affine complete-intersection cone is merely reduced. -/
theorem residualEquationOn_eq_C_mul_targetRelation_of_projective_vanishing_of_isRadical
    {K : Type u} [Field K] [IsAlgClosed K] [Infinite K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F)
    (hq0 : residualEquationOn M N F ≠ 0)
    (hprimitive : IsPrimitiveOverFirstBlock (residualEquationOn M N F))
    {d : ℕ} {H : MvPolynomial (Fin 3) K}
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hradical : (Ideal.span {F, rename Sum.inr H}).IsRadical)
    (hvan : ∀ (x y : Fin 3 → K), x ≠ 0 → y ≠ 0 →
      aeval (Sum.elim x y) F = 0 → aeval y H = 0 →
        aeval (Sum.elim x y) (residualEquationOn M N F) = 0) :
    d = 1 ∧ ∃ c : K, IsUnit c ∧
      residualEquationOn M N F = C c * rename Sum.inr H := by
  apply residualEquationOn_eq_C_mul_targetRelation_of_primitive
    M N hF hq0 hprimitive hH hd
  exact residualEquationOn_mem_span_targetRelation_of_projective_vanishing_of_isRadical
    M N hF hradical hvan

/-- **Primitive residual endpoint of projective exhaustion.**

If the affine cone `(F,H(y))` is prime and every genuine biprojective point of that complete
intersection lies on the residual equation, then a nonzero primitive residual equation can only
be a nonzero scalar multiple of `H`.  In particular `H` has degree one.

All geometric content remains visible in `hprime` and `hvan`; this theorem does not infer either
assumption from reducedness of a generic line section alone. -/
theorem residualEquationOn_eq_C_mul_targetRelation_of_projective_vanishing
    {K : Type u} [Field K] [IsAlgClosed K] [Infinite K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F)
    (hq0 : residualEquationOn M N F ≠ 0)
    (hprimitive : IsPrimitiveOverFirstBlock (residualEquationOn M N F))
    {d : ℕ} {H : MvPolynomial (Fin 3) K}
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hprime : (Ideal.span {F, rename Sum.inr H}).IsPrime)
    (hvan : ∀ (x y : Fin 3 → K), x ≠ 0 → y ≠ 0 →
      aeval (Sum.elim x y) F = 0 → aeval y H = 0 →
        aeval (Sum.elim x y) (residualEquationOn M N F) = 0) :
    d = 1 ∧ ∃ c : K, IsUnit c ∧
      residualEquationOn M N F = C c * rename Sum.inr H := by
  apply residualEquationOn_eq_C_mul_targetRelation_of_primitive
    M N hF hq0 hprimitive hH hd
  exact residualEquationOn_mem_span_targetRelation_of_projective_vanishing
    M N hF hprime hvan

end

end BConicBundleMultisections
