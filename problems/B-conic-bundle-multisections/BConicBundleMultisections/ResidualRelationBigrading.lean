/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ResidualEquationBidegree
public import BConicBundleMultisections.WeightedHomogeneousLowDegree
public import Mathlib.Algebra.MvPolynomial.Nilpotent

/-!
# A bigrading obstruction to a vertical residual relation

Let `F` and `q` be bihomogeneous equations in the Cox ring of
`P^m × P^n`.  If both have positive degree in the first block, then the radical of
`(F, q)` contains no nonzero polynomial pulled back from the second block.

The proof simply sets all first-block variables equal to zero.  This is the exact elementary
algebraic last step in a horizontality argument.  Applying it to a scheme-theoretic component
requires a separate geometric contraction statement: a relation in the component kernel must
belong to `radical (F, q)` *before* inverting first-block polynomials.  Generic-fibre membership
alone only supplies an equation with a first-block denominator and is not enough.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

open MvPolynomial

universe u

/-! ### Specialization at the origin of the first block -/

/-- A bihomogeneous polynomial of positive first degree vanishes when every first-block variable
is set equal to zero. -/
theorem specializeFirstCoordinates_zero_of_bidegree_pos
    {m n : ℕ} {R : Type u} [CommSemiring R]
    {F : MvPolynomial (BiprojectiveCoordinate m n) R} {a b : ℕ}
    (hF : IsBihomogeneousOfBidegree a b F) (ha : 0 < a) :
    specializeFirstCoordinates (0 : Fin (m + 1) → R) F = 0 := by
  have h := hF.specializeFirstCoordinates_smul
    (0 : R) (0 : Fin (m + 1) → R)
  simpa [zero_pow ha.ne'] using h

/-- Specializing the first block leaves a polynomial pulled back from the second block unchanged.
This general version avoids fixing either projective dimension. -/
@[simp]
theorem specializeFirstCoordinates_rename_inr_general
    {m n : ℕ} {R : Type u} [CommSemiring R]
    (x : Fin (m + 1) → R) (P : MvPolynomial (Fin (n + 1)) R) :
    specializeFirstCoordinates x (rename Sum.inr P) = P := by
  induction P using MvPolynomial.induction_on with
  | C r => simp [specializeFirstCoordinates]
  | add P Q hP hQ => simp [hP, hQ]
  | mul_X P j hP =>
      rw [map_mul, rename_X, map_mul, hP]
      simp

/-! ### Extracting a low weighted-degree part of an ideal relation -/

/-- A coefficient of weighted degree below the degree of a homogeneous factor vanishes in every
multiple of that factor. -/
theorem coeff_mul_eq_zero_of_weight_lt
    {σ : Type*} {R : Type u} [CommSemiring R]
    {w : σ → ℕ} {G c : MvPolynomial σ R} {e N : ℕ}
    (hG : G.IsWeightedHomogeneous w e) (hNe : N < e)
    {τ : σ →₀ ℕ} (hτ : Finsupp.weight w τ = N) :
    coeff τ (c * G) = 0 := by
  classical
  rw [coeff_mul]
  apply Finset.sum_eq_zero
  rintro ⟨s, t⟩ hst
  rw [Finset.mem_antidiagonal] at hst
  by_cases ht : coeff t G = 0
  · simp [ht]
  · have hwt : Finsupp.weight w t = e := hG ht
    have hsum : Finsupp.weight w s + Finsupp.weight w t = N := by
      rw [← map_add, hst, hτ]
    exfalso
    omega

/-- At weighted degree `N`, multiplication by a homogeneous form of degree `e ≤ N` only sees the
weighted-degree-`N-e` part of the other factor. -/
theorem coeff_mul_eq_coeff_weightedHomogeneousComponent_mul
    {σ : Type*} {R : Type u} [CommSemiring R]
    {w : σ → ℕ} {G c : MvPolynomial σ R} {e N : ℕ}
    (hG : G.IsWeightedHomogeneous w e) (he : e ≤ N)
    {τ : σ →₀ ℕ} (hτ : Finsupp.weight w τ = N) :
    coeff τ (c * G) =
      coeff τ (weightedHomogeneousComponent w (N - e) c * G) := by
  classical
  rw [coeff_mul, coeff_mul]
  refine Finset.sum_congr rfl fun st hst => ?_
  rw [Finset.mem_antidiagonal] at hst
  by_cases ht : Finsupp.weight w st.2 = e
  · have hsum : Finsupp.weight w st.1 + Finsupp.weight w st.2 = N := by
      rw [← map_add, hst, hτ]
    have hs : Finsupp.weight w st.1 = N - e := by omega
    rw [coeff_weightedHomogeneousComponent, if_pos hs]
  · have hc : coeff st.2 G = 0 := by
      by_contra hc
      exact ht (hG hc)
    rw [hc, mul_zero, mul_zero]

/-- A coefficient outside the declared weighted degree of a weighted-homogeneous polynomial is
zero. -/
theorem IsWeightedHomogeneous.coeff_eq_zero_of_weight_ne
    {σ : Type*} {R : Type u} [CommSemiring R]
    {w : σ → ℕ} {G : MvPolynomial σ R} {e : ℕ}
    (hG : G.IsWeightedHomogeneous w e) {τ : σ →₀ ℕ}
    (hτ : Finsupp.weight w τ ≠ e) : coeff τ G = 0 := by
  by_contra hcoeff
  exact hτ (hG hcoeff)

/-- If a weighted-homogeneous polynomial of degree `N` is written as a sum of multiples of two
forms whose degrees are both strictly larger than `N`, it is zero. -/
theorem eq_zero_of_eq_mul_add_mul_of_weight_lt
    {σ : Type*} {R : Type u} [CommSemiring R]
    {w : σ → ℕ} {q F H A B : MvPolynomial σ R} {N eF eH : ℕ}
    (hq : q.IsWeightedHomogeneous w N)
    (hF : F.IsWeightedHomogeneous w eF) (hNF : N < eF)
    (hH : H.IsWeightedHomogeneous w eH) (hNH : N < eH)
    (hrel : q = A * F + B * H) : q = 0 := by
  ext τ
  by_cases hτ : Finsupp.weight w τ = N
  · rw [congrArg (coeff τ) hrel, coeff_add,
      coeff_mul_eq_zero_of_weight_lt hF hNF hτ,
      coeff_mul_eq_zero_of_weight_lt hH hNH hτ,
      coeff_zero, add_zero]
  · rw [IsWeightedHomogeneous.coeff_eq_zero_of_weight_ne hq hτ, coeff_zero]

/-- In a relation of weighted degree `N`, a generator of degree larger than `N` contributes
nothing, while a generator of degree `e ≤ N` is multiplied only by the degree-`N-e` component of
its coefficient. -/
theorem eq_weightedHomogeneousComponent_mul_of_eq_mul_add_mul
    {σ : Type*} {R : Type u} [CommSemiring R]
    {w : σ → ℕ} {q F H A B : MvPolynomial σ R} {N eF eH : ℕ}
    (hq : q.IsWeightedHomogeneous w N)
    (hF : F.IsWeightedHomogeneous w eF) (hNF : N < eF)
    (hH : H.IsWeightedHomogeneous w eH) (heH : eH ≤ N)
    (hrel : q = A * F + B * H) :
    q = weightedHomogeneousComponent w (N - eH) B * H := by
  have hcomponent :
      (weightedHomogeneousComponent w (N - eH) B * H).IsWeightedHomogeneous w N := by
    convert (weightedHomogeneousComponent_isWeightedHomogeneous
      (w := w) (N - eH) B).mul hH using 1
    all_goals omega
  ext τ
  by_cases hτ : Finsupp.weight w τ = N
  · have hcoeff := congrArg (coeff τ) hrel
    rw [coeff_add, coeff_mul_eq_zero_of_weight_lt hF hNF hτ,
      coeff_mul_eq_coeff_weightedHomogeneousComponent_mul hH heH hτ,
      zero_add] at hcoeff
    exact hcoeff
  · rw [IsWeightedHomogeneous.coeff_eq_zero_of_weight_ne hq hτ,
      IsWeightedHomogeneous.coeff_eq_zero_of_weight_ne hcomponent hτ]

/-- Algebraic evaluation preserves a weighted grading when each substituted variable has the
weight of the variable it replaces. -/
theorem IsWeightedHomogeneous.aeval_preserves_weights_general
    {R : Type u} [CommSemiring R] {σ τ M : Type*} [AddCommMonoid M]
    {w : σ → M} {v : τ → M} {P : MvPolynomial σ R} {d : M}
    (hP : P.IsWeightedHomogeneous w d) (g : σ → MvPolynomial τ R)
    (hg : ∀ i, (g i).IsWeightedHomogeneous v (w i)) :
    (aeval g P).IsWeightedHomogeneous v d := by
  rw [aeval_def]
  apply IsWeightedHomogeneous.sum
  intro s hs
  rw [← zero_add d]
  apply (isWeightedHomogeneous_C v _).mul
  convert IsWeightedHomogeneous.prod s.support (fun i => g i ^ s i)
      (fun i => s i • w i) (fun i _ => (hg i).pow (s i)) using 1
  · simp only [Finsupp.prod]
  · rw [← hP (mem_support_iff.mp hs), Finsupp.weight_apply]
    simp only [Finsupp.sum]

/-- Renaming a homogeneous polynomial into the second Cox block makes it weighted-homogeneous for
the right-block grading, with the same degree. -/
theorem rename_inr_isWeightedHomogeneous_right
    {m n : ℕ} {R : Type u} [CommSemiring R]
    {H : MvPolynomial (Fin (n + 1)) R} {d : ℕ} (hH : H.IsHomogeneous d) :
    (rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H).IsWeightedHomogeneous
      rightDegreeWeight d := by
  rw [rename_eq_aeval]
  apply IsWeightedHomogeneous.aeval_preserves_weights_general hH
  intro i
  simpa [rightDegreeWeight] using
    (isWeightedHomogeneous_X R rightDegreeWeight
      (Sum.inr i : BiprojectiveCoordinate m n))

/-- **Low second-degree factorization.**

Let `q` have second-block degree one, let `F` have second-block degree strictly larger than one,
and let `H(y)` be a nonconstant homogeneous second-block relation.  If `q ∈ (F,H)`, then `H` is
linear and `q` is `H` times a polynomial of second-block degree zero.

No primeness, radical, saturation, or component hypothesis is hidden here; all geometric content
is concentrated in the displayed ideal-membership assumption. -/
theorem secondDegree_one_factor_of_eq_mul_add_mul
    {m n : ℕ} {R : Type u} [CommRing R]
    {q F : MvPolynomial (BiprojectiveCoordinate m n) R}
    {aq aF eF d : ℕ} {H : MvPolynomial (Fin (n + 1)) R}
    (hq : IsBihomogeneousOfBidegree aq 1 q) (hq0 : q ≠ 0)
    (hF : IsBihomogeneousOfBidegree aF eF F) (heF : 1 < eF)
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (A B : MvPolynomial (BiprojectiveCoordinate m n) R)
    (hrel : q = A * F +
      B * rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H) :
    d = 1 ∧ ∃ B : MvPolynomial (BiprojectiveCoordinate m n) R,
      B.IsWeightedHomogeneous (rightDegreeWeight (m := m) (n := n)) 0 ∧
        q = B * rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H := by
  let w := rightDegreeWeight (m := m) (n := n)
  have hHright :
      (rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H).IsWeightedHomogeneous
        w d := rename_inr_isWeightedHomogeneous_right (m := m) hH
  have hqright : q.IsWeightedHomogeneous w 1 := hq.isWeightedHomogeneous_right
  have hFright : F.IsWeightedHomogeneous w eF := hF.isWeightedHomogeneous_right
  have hAFzero : weightedHomogeneousComponent w 1 (A * F) = 0 :=
    weightedHomogeneousComponent_mul_right_eq_zero_of_lt
      w A F eF 1 hFright heF
  have hqcomponent : weightedHomogeneousComponent w 1 q = q :=
    hqright.weightedHomogeneousComponent_same
  have hd1 : d = 1 := by
    by_contra hdne
    have h1d : 1 < d := by omega
    apply hq0
    have hBHzero : weightedHomogeneousComponent w 1
        (B * rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H) = 0 :=
      weightedHomogeneousComponent_mul_right_eq_zero_of_lt
        w B _ d 1 hHright h1d
    calc
      q = weightedHomogeneousComponent w 1 q := hqcomponent.symm
      _ = weightedHomogeneousComponent w 1
          (A * F + B * rename
            (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H) := by rw [hrel]
      _ = 0 := by rw [map_add, hAFzero, hBHzero, add_zero]
  subst d
  refine ⟨rfl, weightedHomogeneousComponent w 0 B,
    weightedHomogeneousComponent_isWeightedHomogeneous 0 B, ?_⟩
  have hBHcomponent := weightedHomogeneousComponent_mul_right_eq_zeroComponent_mul
    w B
      (rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H) 1 hHright
  calc
    q = weightedHomogeneousComponent w 1 q := hqcomponent.symm
    _ = weightedHomogeneousComponent w 1
        (A * F + B * rename
          (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H) := by rw [hrel]
    _ = weightedHomogeneousComponent w 0 B *
        rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H := by
      rw [map_add, hAFzero, hBHcomponent, zero_add]

/-- Ideal-membership wrapper for `secondDegree_one_factor_of_eq_mul_add_mul`. -/
theorem secondDegree_one_factor_of_mem_span_pair
    {m n : ℕ} {R : Type u} [CommRing R]
    {q F : MvPolynomial (BiprojectiveCoordinate m n) R}
    {aq aF eF d : ℕ} {H : MvPolynomial (Fin (n + 1)) R}
    (hq : IsBihomogeneousOfBidegree aq 1 q) (hq0 : q ≠ 0)
    (hF : IsBihomogeneousOfBidegree aF eF F) (heF : 1 < eF)
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hmem : q ∈ Ideal.span {F,
      rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H}) :
    d = 1 ∧ ∃ B : MvPolynomial (BiprojectiveCoordinate m n) R,
      B.IsWeightedHomogeneous (rightDegreeWeight (m := m) (n := n)) 0 ∧
        q = B * rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H := by
  obtain ⟨A, B, hrel⟩ := Ideal.mem_span_pair.mp hmem
  exact secondDegree_one_factor_of_eq_mul_add_mul
    hq hq0 hF heF hH hd A B hrel.symm

/-- A Cox polynomial is primitive over the first block if every factor of right degree zero is a
unit.  For a polynomial linear in the second block this is the intrinsic version of saying that
its coefficient forms have had their common first-block factor divided out. -/
def IsPrimitiveOverFirstBlock
    {m n : ℕ} {R : Type u} [CommRing R]
    (q : MvPolynomial (BiprojectiveCoordinate m n) R) : Prop :=
  ∀ (B Q : MvPolynomial (BiprojectiveCoordinate m n) R),
    B.IsWeightedHomogeneous (rightDegreeWeight (m := m) (n := n)) 0 →
      q = B * Q → IsUnit B

/-- A primitive second-block-linear equation in `(F,H(y))` is a nonzero scalar multiple of the
linear relation `H`.  This is the precise algebraic endpoint of the vertical-image argument; the
geometric task is to supply the ideal membership. -/
theorem eq_C_mul_rename_inr_of_primitive_mem_span_pair
    {m n : ℕ} {R : Type u} [CommRing R] [IsReduced R]
    {q F : MvPolynomial (BiprojectiveCoordinate m n) R}
    {aq aF eF d : ℕ} {H : MvPolynomial (Fin (n + 1)) R}
    (hq : IsBihomogeneousOfBidegree aq 1 q) (hq0 : q ≠ 0)
    (hF : IsBihomogeneousOfBidegree aF eF F) (heF : 1 < eF)
    (hprimitive : IsPrimitiveOverFirstBlock q)
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hmem : q ∈ Ideal.span {F,
      rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H}) :
    d = 1 ∧ ∃ c : R, IsUnit c ∧
      q = C c * rename (Sum.inr : Fin (n + 1) → BiprojectiveCoordinate m n) H := by
  obtain ⟨hd1, B, hBdegree, hfactor⟩ :=
    secondDegree_one_factor_of_mem_span_pair hq hq0 hF heF hH hd hmem
  have hBunit : IsUnit B := hprimitive B _ hBdegree hfactor
  obtain ⟨c, hc, hB⟩ := MvPolynomial.isUnit_iff_eq_C_of_isReduced.mp hBunit
  exact ⟨hd1, c, hc, by simpa [hB] using hfactor⟩

/-! ### The two-generator obstruction -/

/-- An explicit relation between a second-block polynomial and two equations of positive first
degree forces the second-block polynomial to vanish.  The exponent accommodates radical
membership. -/
theorem secondBlockPolynomial_eq_zero_of_power_eq_mul_add_mul
    {m n : ℕ} {R : Type u} [CommRing R] [IsDomain R]
    {F q A B : MvPolynomial (BiprojectiveCoordinate m n) R}
    {aF bF aq bq N : ℕ} {P : MvPolynomial (Fin (n + 1)) R}
    (hF : IsBihomogeneousOfBidegree aF bF F) (haF : 0 < aF)
    (hq : IsBihomogeneousOfBidegree aq bq q) (haq : 0 < aq)
    (hrel : rename Sum.inr (P ^ N) = A * F + B * q) :
    P = 0 := by
  have h := congrArg
    (specializeFirstCoordinates (0 : Fin (m + 1) → R)) hrel
  rw [specializeFirstCoordinates_rename_inr_general, map_add, map_mul, map_mul,
    specializeFirstCoordinates_zero_of_bidegree_pos hF haF,
    specializeFirstCoordinates_zero_of_bidegree_pos hq haq,
    mul_zero, mul_zero, add_zero] at h
  exact eq_zero_of_pow_eq_zero h

/-- The radical of two bihomogeneous equations of positive first degree has zero intersection
with the polynomial subring on the second block. -/
theorem secondBlockPolynomial_eq_zero_of_mem_radical_span_pair
    {m n : ℕ} {R : Type u} [CommRing R] [IsDomain R]
    {F q : MvPolynomial (BiprojectiveCoordinate m n) R}
    {aF bF aq bq : ℕ} {P : MvPolynomial (Fin (n + 1)) R}
    (hF : IsBihomogeneousOfBidegree aF bF F) (haF : 0 < aF)
    (hq : IsBihomogeneousOfBidegree aq bq q) (haq : 0 < aq)
    (hmem : rename Sum.inr P ∈ (Ideal.span {F, q}).radical) :
    P = 0 := by
  obtain ⟨N, hN⟩ := Ideal.mem_radical_iff.mp hmem
  have hN' : rename Sum.inr (P ^ N) ∈ Ideal.span {F, q} := by
    simpa only [map_pow] using hN
  obtain ⟨A, B, hrel⟩ := Ideal.mem_span_pair.mp hN'
  exact secondBlockPolynomial_eq_zero_of_power_eq_mul_add_mul hF haF hq haq hrel.symm

/-- Contrapositive form: a nonzero equation in the second block cannot lie in the radical of the
positive-first-degree complete-intersection ideal. -/
theorem rename_inr_not_mem_radical_span_pair
    {m n : ℕ} {R : Type u} [CommRing R] [IsDomain R]
    {F q : MvPolynomial (BiprojectiveCoordinate m n) R}
    {aF bF aq bq : ℕ} {P : MvPolynomial (Fin (n + 1)) R}
    (hF : IsBihomogeneousOfBidegree aF bF F) (haF : 0 < aF)
    (hq : IsBihomogeneousOfBidegree aq bq q) (haq : 0 < aq)
    (hP : P ≠ 0) :
    rename Sum.inr P ∉ (Ideal.span {F, q}).radical := by
  intro hmem
  exact hP (secondBlockPolynomial_eq_zero_of_mem_radical_span_pair
    hF haF hq haq hmem)

/-- Ideal-theoretic form of the obstruction: contraction of the radical complete-intersection
ideal to the second-block polynomial ring is the zero ideal. -/
theorem comap_rename_inr_radical_span_pair_eq_bot
    {m n : ℕ} {R : Type u} [CommRing R] [IsDomain R]
    {F q : MvPolynomial (BiprojectiveCoordinate m n) R}
    {aF bF aq bq : ℕ}
    (hF : IsBihomogeneousOfBidegree aF bF F) (haF : 0 < aF)
    (hq : IsBihomogeneousOfBidegree aq bq q) (haq : 0 < aq) :
    Ideal.comap (rename (R := R) Sum.inr)
      (Ideal.span {F, q}).radical = ⊥ := by
  apply le_antisymm
  · intro P hP
    have hP0 : P = 0 := secondBlockPolynomial_eq_zero_of_mem_radical_span_pair
      hF haF hq haq hP
    exact hP0
  · exact bot_le

/-- Exact contraction hypothesis needed for a chosen component.  If the component ideal's
second-block contraction is contained in the contraction of the full complete-intersection
radical, then that component has no nonzero second-block relation.

For an arbitrary irreducible component the displayed containment is not automatic: its prime
ideal contains the complete-intersection radical, so the evident inclusion goes in the opposite
direction. -/
theorem component_secondBlock_comap_eq_bot_of_le_completeIntersection
    {m n : ℕ} {R : Type u} [CommRing R] [IsDomain R]
    {F q : MvPolynomial (BiprojectiveCoordinate m n) R}
    {aF bF aq bq : ℕ}
    (hF : IsBihomogeneousOfBidegree aF bF F) (haF : 0 < aF)
    (hq : IsBihomogeneousOfBidegree aq bq q) (haq : 0 < aq)
    (J : Ideal (MvPolynomial (BiprojectiveCoordinate m n) R))
    (hcontract : Ideal.comap (rename (R := R) Sum.inr) J ≤
      Ideal.comap (rename (R := R) Sum.inr) (Ideal.span {F, q}).radical) :
    Ideal.comap (rename (R := R) Sum.inr) J = ⊥ := by
  rw [comap_rename_inr_radical_span_pair_eq_bot hF haF hq haq] at hcontract
  exact le_antisymm hcontract bot_le

/-! ### The residual equation -/

/-- If the residual equation belongs to `(F,H(y))` for a nonconstant homogeneous target
relation, then that relation is linear and the residual equation has a common factor of right
degree zero.  Thus its three line coefficients are proportional after identifying a right-degree
zero Cox polynomial with a first-block polynomial. -/
theorem residualEquationOn_factor_of_mem_targetRelation
    {K : Type u} [Field K] [Infinite K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F)
    (hq0 : residualEquationOn M N F ≠ 0)
    {d : ℕ} {H : MvPolynomial (Fin 3) K}
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hmem : residualEquationOn M N F ∈ Ideal.span {F, rename Sum.inr H}) :
    d = 1 ∧ ∃ B : MvPolynomial (BiprojectiveCoordinate 2 2) K,
      B.IsWeightedHomogeneous (rightDegreeWeight (m := 2) (n := 2)) 0 ∧
        residualEquationOn M N F = B * rename Sum.inr H := by
  exact secondDegree_one_factor_of_mem_span_pair
    (ResidualDivisor.residualEquationOn_isBihomogeneous M N hF) hq0
    hF (by norm_num) hH hd hmem

/-- Primitive form of the preceding theorem: the residual equation itself is a scalar multiple
of the constant target line. -/
theorem residualEquationOn_eq_C_mul_targetRelation_of_primitive
    {K : Type u} [Field K] [Infinite K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F)
    (hq0 : residualEquationOn M N F ≠ 0)
    (hprimitive : IsPrimitiveOverFirstBlock (residualEquationOn M N F))
    {d : ℕ} {H : MvPolynomial (Fin 3) K}
    (hH : H.IsHomogeneous d) (hd : 0 < d)
    (hmem : residualEquationOn M N F ∈ Ideal.span {F, rename Sum.inr H}) :
    d = 1 ∧ ∃ c : K, IsUnit c ∧
      residualEquationOn M N F = C c * rename Sum.inr H := by
  exact eq_C_mul_rename_inr_of_primitive_mem_span_pair
    (ResidualDivisor.residualEquationOn_isBihomogeneous M N hF) hq0
    hF (by norm_num) hprimitive hH hd hmem

/-- For a bidegree-`(2,3)` equation, no nonzero polynomial from the second block belongs to the
radical of the complete-intersection ideal generated by `F` and its arbitrary-frame residual
equation.  This uses the residual equation's first degree `10`.

This statement concerns the whole complete intersection.  Passing from a relation on one chosen
irreducible component to membership in this radical is the separate geometric input discussed in
the module docstring. -/
theorem residualEquationOn_rename_inr_not_mem_radical
    {K : Type u} [Field K] [Infinite K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F)
    {P : MvPolynomial (Fin 3) K} (hP : P ≠ 0) :
    rename Sum.inr P ∉
      (Ideal.span {F, residualEquationOn M N F}).radical := by
  exact rename_inr_not_mem_radical_span_pair hF (by norm_num)
    (ResidualDivisor.residualEquationOn_isBihomogeneous M N hF) (by norm_num) hP

/-- The complete-intersection ideal `(F, residualEquationOn M N F)` contracts trivially to the
second Cox block. -/
theorem residualEquationOn_secondBlock_comap_radical_eq_bot
    {K : Type u} [Field K] [Infinite K]
    (M N : Matrix (Fin 3) (Fin 3) K)
    {F : MvPolynomial (BiprojectiveCoordinate 2 2) K} (hF : IsBidegree23 F) :
    Ideal.comap (rename (R := K) Sum.inr)
      (Ideal.span {F, residualEquationOn M N F}).radical = ⊥ := by
  exact comap_rename_inr_radical_span_pair_eq_bot hF (by norm_num)
    (ResidualDivisor.residualEquationOn_isBihomogeneous M N hF) (by norm_num)

end

end BConicBundleMultisections
