/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ProjectiveCommonZero
public import Mathlib.Algebra.MvPolynomial.Eval
public import Mathlib.Algebra.Polynomial.Degree.Defs
public import Mathlib.Algebra.Polynomial.Eval.Defs
public import Mathlib.FieldTheory.IsAlgClosed.Basic
public import Mathlib.RingTheory.MvPolynomial.Homogeneous

/-!
# Isotropy of ternary quadratics (Tsen input)

Constant-field half: over an algebraically closed field, positive-degree homogeneous forms in
enough variables are isotropic.

Function-field half: undetermined-coefficient counting and the convolution identity
`eval undeterminedCoeffEq = coeff (Q(v))` yield Tsen isotropy for ternary quadratics over `K[t]`.
Clearing denominators reduces the `K(t)` case to this polynomial form.
-/

@[expose] public section

open MvPolynomial Polynomial

namespace BConicBundleMultisections

noncomputable section

universe u

variable {K : Type u} [Field K]

/-! ### Undetermined-coefficient counting -/

/-- Cardinality comparison used by the classical undetermined-coefficient count. -/
theorem tsen_card_lt (D : ℕ) : 2 * D + D + 1 < 3 * (D + 1) := by omega

/-- Undetermined-coefficient count for a ternary quadratic of coefficient degree `≤ δ`
with solution degree bound `D` (polynomials of degree `≤ D`, i.e. length `D + 1`). -/
theorem tsen_quadratic_card_lt (D δ : ℕ) (h : δ < D + 2) :
    2 * D + δ + 1 < 3 * (D + 1) := by omega

/-- Assemble a univariate polynomial of degree `< N` from its coefficient vector. -/
def polyOfCoeffs (N : ℕ) (c : Fin N → K) : K[X] :=
  ∑ i : Fin N, monomial (i : ℕ) (c i)

@[simp]
theorem coeff_polyOfCoeffs (N : ℕ) (c : Fin N → K) (j : ℕ) :
    (polyOfCoeffs N c).coeff j = if hj : j < N then c ⟨j, hj⟩ else 0 := by
  classical
  simp only [polyOfCoeffs, finsetSum_coeff, Polynomial.coeff_monomial]
  by_cases hj : j < N
  · simp only [hj, ↓reduceDIte]
    rw [Finset.sum_eq_single (⟨j, hj⟩ : Fin N)]
    · simp
    · intro i _ hi
      simp [Fin.ext_iff.not.mp hi]
    · simp
  · simp only [hj, ↓reduceDIte]
    refine Finset.sum_eq_zero fun i _ => ?_
    have : (i : ℕ) ≠ j := by omega
    simp [this]

theorem polyOfCoeffs_eq_zero_iff (N : ℕ) (c : Fin N → K) :
    polyOfCoeffs N c = 0 ↔ c = 0 := by
  constructor
  · intro h
    ext i
    have := congrArg (fun p : K[X] => p.coeff (i : ℕ)) h
    simpa [coeff_polyOfCoeffs, i.is_lt] using this
  · rintro rfl
    ext j
    simp [coeff_polyOfCoeffs]

/-- Pack three coefficient vectors of length `N` as a single map on `Fin 3 × Fin N`. -/
def packTripleCoeffs (N : ℕ) (c : Fin 3 → Fin N → K) : Fin 3 × Fin N → K :=
  fun p => c p.1 p.2

theorem packTripleCoeffs_eq_zero_iff (N : ℕ) (c : Fin 3 → Fin N → K) :
    packTripleCoeffs N c = 0 ↔ c = 0 := by
  constructor
  · intro h
    ext i k
    exact congrFun h (i, k)
  · rintro rfl
    ext ⟨i, k⟩
    rfl

theorem card_triple_coeffs (N : ℕ) :
    Fintype.card (Fin 3 × Fin N) = 3 * N := by
  simp [mul_comm]

/-- For every coefficient-degree bound `δ` there exists a solution degree large enough that the
undetermined-coefficient count is strictly favourable. -/
theorem exists_tsen_degree (δ : ℕ) :
    ∃ D : ℕ, δ < D + 2 ∧ 2 * D + δ + 1 < 3 * (D + 1) := by
  refine ⟨δ, by omega, tsen_quadratic_card_lt δ δ (by omega)⟩

/-! ### Ternary quadratic matrix form -/

/-- A ternary quadratic form given by a `3 × 3` matrix of univariate polynomials. -/
abbrev TernaryQuadraticPoly := Fin 3 → Fin 3 → K[X]

namespace TernaryQuadraticPoly

variable (Q : @TernaryQuadraticPoly K _)

/-- Evaluate a matrix-valued ternary quadratic form on three univariate polynomials. -/
def eval (v : Fin 3 → K[X]) : K[X] :=
  ∑ i : Fin 3, ∑ j : Fin 3, Q i j * v i * v j

/-- Maximum coefficient degree of a matrix-valued ternary quadratic. -/
def maxCoeffDegree : ℕ :=
  Finset.univ.sup fun i : Fin 3 × Fin 3 => (Q i.1 i.2).natDegree

theorem le_maxCoeffDegree (i j : Fin 3) :
    (Q i j).natDegree ≤ Q.maxCoeffDegree := by
  simpa [maxCoeffDegree] using
    Finset.le_sup (f := fun p : Fin 3 × Fin 3 => (Q p.1 p.2).natDegree)
      (Finset.mem_univ (i, j))

end TernaryQuadraticPoly

/-- A single undetermined monomial term `C(a) * X_β * X_γ`. -/
def undeterminedTerm (N : ℕ) (i j : Fin 3) (β γ : Fin N) (a : K) :
    MvPolynomial (Fin 3 × Fin N) K :=
  MvPolynomial.C a * X (i, β) * X (j, γ)

theorem undeterminedTerm_isHomogeneous (N : ℕ) (i j : Fin 3) (β γ : Fin N) (a : K) :
    (undeterminedTerm N i j β γ a).IsHomogeneous 2 := by
  have hC := isHomogeneous_C (σ := Fin 3 × Fin N) (R := K) a
  have hXβ := isHomogeneous_X (σ := Fin 3 × Fin N) (R := K) (i, β)
  have hXγ := isHomogeneous_X (σ := Fin 3 × Fin N) (R := K) (j, γ)
  simpa [undeterminedTerm, add_assoc] using (hC.mul hXβ).mul hXγ

@[simp]
theorem eval_undeterminedTerm (N : ℕ) (i j : Fin 3) (β γ : Fin N) (a : K)
    (c : Fin 3 × Fin N → K) :
    eval c (undeterminedTerm N i j β γ a) = a * c (i, β) * c (j, γ) := by
  simp [undeterminedTerm]

/-! ### Convolution identity -/

/-- Collapse a double Fin-sum over `β + γ = r` to a single Fin-sum. -/
theorem sum_eq_of_add_eq (N r : ℕ) (f : Fin N → Fin N → K) :
    (∑ β : Fin N, ∑ γ : Fin N, if (β : ℕ) + (γ : ℕ) = r then f β γ else 0) =
      ∑ β : Fin N,
        if h : (β : ℕ) ≤ r ∧ r - (β : ℕ) < N then
          f β ⟨r - (β : ℕ), h.2⟩
        else
          0 := by
  classical
  refine Finset.sum_congr rfl fun β _ => ?_
  by_cases hβle : (β : ℕ) ≤ r
  · by_cases hγ : r - (β : ℕ) < N
    · have h : (β : ℕ) ≤ r ∧ r - (β : ℕ) < N := ⟨hβle, hγ⟩
      simp only [h]
      rw [Finset.sum_eq_single (⟨r - (β : ℕ), hγ⟩ : Fin N)]
      · have : (β : ℕ) + (r - (β : ℕ)) = r := Nat.add_sub_of_le hβle
        simp [this]
      · intro γ _ hne
        have : ¬(β : ℕ) + (γ : ℕ) = r := by
          intro heq
          exact hne (Fin.ext (by omega : (γ : ℕ) = r - (β : ℕ)))
        simp [this]
      · simp
    · have : ¬((β : ℕ) ≤ r ∧ r - (β : ℕ) < N) := by simp [hβle, hγ]
      simp only [this]
      refine Finset.sum_eq_zero fun γ _ => ?_
      have : ¬(β : ℕ) + (γ : ℕ) = r := by
        intro heq
        exact hγ (by omega)
      simp [this]
  · have : ¬((β : ℕ) ≤ r ∧ r - (β : ℕ) < N) := by simp [hβle]
    simp only [this]
    refine Finset.sum_eq_zero fun γ _ => ?_
    have : ¬(β : ℕ) + (γ : ℕ) = r := by omega
    simp [this]

/-- The antidiagonal form of `coeff_mul` for coefficient polynomials of length `N`. -/
theorem coeff_mul_polyOfCoeffs_range (N : ℕ) (c d : Fin N → K) (r : ℕ) :
    ((polyOfCoeffs N c) * polyOfCoeffs N d).coeff r =
      ∑ k ∈ Finset.range (r + 1),
        (if hk : k < N then c ⟨k, hk⟩ else 0) *
          (if hrk : r - k < N then d ⟨r - k, hrk⟩ else 0) := by
  classical
  have hanti :=
    Finset.Nat.sum_antidiagonal_eq_sum_range_succ
      (fun a b : ℕ => (polyOfCoeffs N c).coeff a * (polyOfCoeffs N d).coeff b) r
  -- `Polynomial.coeff_mul` expands as an antidiagonal sum.
  have hmul :
      ((polyOfCoeffs N c) * polyOfCoeffs N d).coeff r =
        ∑ ij ∈ Finset.antidiagonal r,
          (polyOfCoeffs N c).coeff ij.1 * (polyOfCoeffs N d).coeff ij.2 :=
    Polynomial.coeff_mul _ _ _
  -- Identify the two presentations of the antidiagonal sum.
  have hmul' :
      ((polyOfCoeffs N c) * polyOfCoeffs N d).coeff r =
        ∑ ij ∈ Finset.antidiagonal r,
          (fun a b : ℕ => (polyOfCoeffs N c).coeff a * (polyOfCoeffs N d).coeff b) ij.1 ij.2 := by
    simpa using hmul
  rw [hmul', hanti]
  simp only [coeff_polyOfCoeffs]

/-- Coefficient of a product of two degree-`< N` coefficient polynomials. -/
theorem coeff_mul_polyOfCoeffs (N : ℕ) (c d : Fin N → K) (r : ℕ) :
    ((polyOfCoeffs N c) * polyOfCoeffs N d).coeff r =
      ∑ β : Fin N, ∑ γ : Fin N,
        if (β : ℕ) + (γ : ℕ) = r then c β * d γ else 0 := by
  classical
  rw [coeff_mul_polyOfCoeffs_range, sum_eq_of_add_eq]
  let g : ℕ → K := fun k =>
    (if hk : k < N then c ⟨k, hk⟩ else 0) *
      (if hrk : r - k < N then d ⟨r - k, hrk⟩ else 0)
  change ∑ k ∈ Finset.range (r + 1), g k =
    ∑ β : Fin N, if h : (β : ℕ) ≤ r ∧ r - (β : ℕ) < N then
      c β * d ⟨r - (β : ℕ), h.2⟩ else 0
  have hR :
      (∑ β : Fin N,
          if h : (β : ℕ) ≤ r ∧ r - (β : ℕ) < N then
            c β * d ⟨r - (β : ℕ), h.2⟩ else 0) =
        ∑ β : Fin N, if hβle : (β : ℕ) ≤ r then g (β : ℕ) else 0 := by
    refine Finset.sum_congr rfl fun β _ => ?_
    by_cases hβle : (β : ℕ) ≤ r
    · by_cases hrβ : r - (β : ℕ) < N
      · simp [g, hβle, hrβ]
      · simp [g, hβle, hrβ]
    · simp [hβle]
  rw [hR]
  -- Filtered Fin-sum equals range-sum of `g`.
  have hfilter :
      (∑ β : Fin N, if hβle : (β : ℕ) ≤ r then g (β : ℕ) else 0) =
        ∑ β ∈ Finset.univ.filter (fun β : Fin N => (β : ℕ) ≤ r), g (β : ℕ) := by
    refine Eq.trans ?_ (Finset.sum_filter (p := fun β : Fin N => (β : ℕ) ≤ r)
      (f := fun β => g (β : ℕ))).symm
    refine Finset.sum_congr rfl fun β _ => by split_ifs <;> rfl
  rw [hfilter]
  have himg :
      Finset.image (fun β : Fin N => (β : ℕ))
          (Finset.univ.filter fun β : Fin N => (β : ℕ) ≤ r) =
        (Finset.range (r + 1)).filter (· < N) := by
    ext k
    simp only [Finset.mem_image, Finset.mem_filter, Finset.mem_univ, Finset.mem_range, true_and]
    constructor
    · rintro ⟨β, hβle, rfl⟩
      exact ⟨Nat.lt_succ_of_le hβle, β.isLt⟩
    · rintro ⟨hkr, hkN⟩
      refine ⟨⟨k, hkN⟩, Nat.lt_succ_iff.mp hkr, rfl⟩
  have hcoe :
      (∑ β ∈ Finset.univ.filter fun β : Fin N => (β : ℕ) ≤ r, g (β : ℕ)) =
        ∑ k ∈ (Finset.range (r + 1)).filter (· < N), g k := by
    rw [← himg, Finset.sum_image]
    intro β₁ _ β₂ _ h
    exact Fin.ext h
  rw [hcoe]
  refine (Finset.sum_subset (Finset.filter_subset _ _) ?_).symm
  intro k hk hk'
  have hkN : ¬ k < N := by
    intro h
    exact hk' (Finset.mem_filter.mpr ⟨hk, h⟩)
  simp [g, hkN]

/-- Coefficient of `Qij * v_i * v_j` when `v` are coefficient polynomials of length `N`. -/
theorem coeff_Q_mul_polyOfCoeffs (Qij : K[X]) (N : ℕ) (c d : Fin N → K) (r : ℕ) :
    (Qij * polyOfCoeffs N c * polyOfCoeffs N d).coeff r =
      ∑ β : Fin N, ∑ γ : Fin N,
        if _h : (β : ℕ) + (γ : ℕ) ≤ r then
          Qij.coeff (r - (β : ℕ) - (γ : ℕ)) * c β * d γ
        else
          0 := by
  classical
  rw [mul_assoc]
  have hanti :=
    Finset.Nat.sum_antidiagonal_eq_sum_range_succ
      (fun a b : ℕ => Qij.coeff a * (polyOfCoeffs N c * polyOfCoeffs N d).coeff b) r
  have hmul :
      (Qij * (polyOfCoeffs N c * polyOfCoeffs N d)).coeff r =
        ∑ ij ∈ Finset.antidiagonal r,
          (fun a b : ℕ =>
            Qij.coeff a * (polyOfCoeffs N c * polyOfCoeffs N d).coeff b) ij.1 ij.2 := by
    simpa using (Polynomial.coeff_mul Qij (polyOfCoeffs N c * polyOfCoeffs N d) r)
  rw [hmul, hanti]
  simp_rw [coeff_mul_polyOfCoeffs]
  simp only [Finset.mul_sum]
  have hswap :
      (∑ t ∈ Finset.range (r + 1),
          ∑ β : Fin N, ∑ γ : Fin N,
            Qij.coeff t * (if (β : ℕ) + (γ : ℕ) = r - t then c β * d γ else 0)) =
        ∑ β : Fin N, ∑ γ : Fin N, ∑ t ∈ Finset.range (r + 1),
          Qij.coeff t * (if (β : ℕ) + (γ : ℕ) = r - t then c β * d γ else 0) := by
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun β _ => ?_
    rw [Finset.sum_comm]
  rw [hswap]
  refine Finset.sum_congr rfl fun β _ => ?_
  refine Finset.sum_congr rfl fun γ _ => ?_
  by_cases hβγ : (β : ℕ) + (γ : ℕ) ≤ r
  · have ht0 : r - (β : ℕ) - (γ : ℕ) ∈ Finset.range (r + 1) := by
      exact Finset.mem_range.mpr (by omega)
    simp only [hβγ, ↓reduceDIte]
    rw [Finset.sum_eq_single (r - (β : ℕ) - (γ : ℕ))]
    · have : (β : ℕ) + (γ : ℕ) = r - (r - (β : ℕ) - (γ : ℕ)) := by omega
      simp [this]
      ring
    · intro t ht htne
      have ht' : t ≤ r := Nat.lt_succ_iff.mp (Finset.mem_range.mp ht)
      have : ¬(β : ℕ) + (γ : ℕ) = r - t := by
        intro heq
        exact htne (by omega)
      simp [this]
    · intro hnotin
      exact absurd ht0 hnotin
  · simp only [hβγ, ↓reduceDIte]
    refine Finset.sum_eq_zero fun t ht => ?_
    have ht' : t ≤ r := Nat.lt_succ_iff.mp (Finset.mem_range.mp ht)
    have : ¬(β : ℕ) + (γ : ℕ) = r - t := by omega
    simp [this]

/-- The undetermined-coefficient equation of index `r` for a ternary quadratic matrix form. -/
def undeterminedCoeffEq (Q : @TernaryQuadraticPoly K _) (N r : ℕ) :
    MvPolynomial (Fin 3 × Fin N) K :=
  ∑ i : Fin 3, ∑ j : Fin 3, ∑ β : Fin N, ∑ γ : Fin N,
    if (β : ℕ) + (γ : ℕ) ≤ r then
      undeterminedTerm N i j β γ ((Q i j).coeff (r - (β : ℕ) - (γ : ℕ)))
    else
      0

/-- Each undetermined-coefficient equation is homogeneous of degree two. -/
theorem undeterminedCoeffEq_isHomogeneous (Q : @TernaryQuadraticPoly K _) (N r : ℕ) :
    (undeterminedCoeffEq Q N r).IsHomogeneous 2 := by
  classical
  refine IsHomogeneous.sum _ _ _ fun i _ => ?_
  refine IsHomogeneous.sum _ _ _ fun j _ => ?_
  refine IsHomogeneous.sum _ _ _ fun β _ => ?_
  refine IsHomogeneous.sum _ _ _ fun γ _ => ?_
  split_ifs
  · exact undeterminedTerm_isHomogeneous N i j β γ _
  · exact isHomogeneous_zero (Fin 3 × Fin N) K 2

/-- **Convolution identity.** Evaluating the undetermined-coefficient equation of index `r`
recovers the degree-`r` coefficient of the ternary quadratic on the packed polynomials. -/
theorem eval_undeterminedCoeffEq (Q : @TernaryQuadraticPoly K _) (N r : ℕ)
    (c : Fin 3 × Fin N → K) :
    eval c (undeterminedCoeffEq Q N r) =
      (TernaryQuadraticPoly.eval Q fun i =>
        polyOfCoeffs N fun k => c (i, k)).coeff r := by
  classical
  dsimp [undeterminedCoeffEq, TernaryQuadraticPoly.eval]
  -- Expand evaluation of the four-fold sum, and the polynomial coefficient of the three-fold sum.
  have heval :
      eval c
          (∑ i : Fin 3, ∑ j : Fin 3, ∑ β : Fin N, ∑ γ : Fin N,
            if (β : ℕ) + (γ : ℕ) ≤ r then
              undeterminedTerm N i j β γ ((Q i j).coeff (r - (β : ℕ) - (γ : ℕ)))
            else 0) =
        ∑ i : Fin 3, ∑ j : Fin 3, ∑ β : Fin N, ∑ γ : Fin N,
          if (β : ℕ) + (γ : ℕ) ≤ r then
            ((Q i j).coeff (r - (β : ℕ) - (γ : ℕ))) * c (i, β) * c (j, γ)
          else 0 := by
    simp only [MvPolynomial.eval_sum]
    refine Finset.sum_congr rfl fun i _ => ?_
    refine Finset.sum_congr rfl fun j _ => ?_
    refine Finset.sum_congr rfl fun β _ => ?_
    refine Finset.sum_congr rfl fun γ _ => ?_
    split_ifs <;> simp [eval_undeterminedTerm]
  have hcoeff :
      (∑ i : Fin 3, ∑ j : Fin 3,
          Q i j * polyOfCoeffs N (fun k => c (i, k)) *
            polyOfCoeffs N (fun k => c (j, k))).coeff r =
        ∑ i : Fin 3, ∑ j : Fin 3,
          (Q i j * polyOfCoeffs N (fun k => c (i, k)) *
            polyOfCoeffs N (fun k => c (j, k))).coeff r := by
    simp only [finsetSum_coeff]
  rw [heval, hcoeff]
  refine Finset.sum_congr rfl fun i _ => ?_
  refine Finset.sum_congr rfl fun j _ => ?_
  simpa [mul_assoc] using
    (coeff_Q_mul_polyOfCoeffs (Q i j) N (fun k => c (i, k)) (fun k => c (j, k)) r).symm

/-- Finite list of undetermined-coefficient equations up to the a priori degree bound. -/
def undeterminedCoeffEqList (Q : @TernaryQuadraticPoly K _) (N : ℕ) :
    List (MvPolynomial (Fin 3 × Fin N) K) :=
  (List.range (2 * (N - 1) + Q.maxCoeffDegree + 1)).map fun r =>
    undeterminedCoeffEq Q N r

theorem length_undeterminedCoeffEqList (Q : @TernaryQuadraticPoly K _) (N : ℕ) :
    (undeterminedCoeffEqList Q N).length = 2 * (N - 1) + Q.maxCoeffDegree + 1 := by
  simp [undeterminedCoeffEqList]

theorem undeterminedCoeffEqList_isHomogeneous (Q : @TernaryQuadraticPoly K _) (N : ℕ)
    {f : MvPolynomial (Fin 3 × Fin N) K} (hf : f ∈ undeterminedCoeffEqList Q N) :
    ∃ d : ℕ, 0 < d ∧ f.IsHomogeneous d := by
  obtain ⟨r, _, rfl⟩ := List.mem_map.mp hf
  exact ⟨2, by norm_num, undeterminedCoeffEq_isHomogeneous Q N r⟩

/-- Degree of a coefficient polynomial of length `N` is at most `N - 1`. -/
theorem natDegree_polyOfCoeffs_le (N : ℕ) (c : Fin N → K) :
    (polyOfCoeffs N c).natDegree ≤ N - 1 := by
  classical
  refine natDegree_le_iff_coeff_eq_zero.mpr fun m hm => ?_
  have : ¬ m < N := by omega
  simp [coeff_polyOfCoeffs, this]

/-- Degree bound for the ternary quadratic evaluated on length-`N` coefficient polynomials. -/
theorem natDegree_eval_polyOfCoeffs_le (Q : @TernaryQuadraticPoly K _) (N : ℕ)
    (c : Fin 3 × Fin N → K) :
    (TernaryQuadraticPoly.eval Q (fun i => polyOfCoeffs N fun k => c (i, k))).natDegree ≤
      2 * (N - 1) + Q.maxCoeffDegree := by
  classical
  let v : Fin 3 → K[X] := fun i => polyOfCoeffs N fun k => c (i, k)
  change (TernaryQuadraticPoly.eval Q v).natDegree ≤ 2 * (N - 1) + Q.maxCoeffDegree
  have hsum :=
    natDegree_sum_le (Finset.univ : Finset (Fin 3))
      (fun i => ∑ j : Fin 3, Q i j * v i * v j)
  refine le_trans hsum ?_
  refine Finset.sup_le fun i _ => ?_
  have hsumj :=
    natDegree_sum_le (Finset.univ : Finset (Fin 3))
      (fun j => Q i j * v i * v j)
  refine le_trans hsumj ?_
  refine Finset.sup_le fun j _ => ?_
  have hmul1 := natDegree_mul_le (p := Q i j * v i) (q := v j)
  refine le_trans hmul1 ?_
  have hmul0 := natDegree_mul_le (p := Q i j) (q := v i)
  have hQi := Q.le_maxCoeffDegree i j
  have hvi := natDegree_polyOfCoeffs_le N (fun k => c (i, k))
  have hvj := natDegree_polyOfCoeffs_le N (fun k => c (j, k))
  have hbound :
      (Q i j * v i).natDegree + (v j).natDegree ≤
        Q.maxCoeffDegree + (N - 1) + (N - 1) := by
    refine le_trans (add_le_add hmul0 le_rfl) ?_
    gcongr
  calc
    (Q i j * v i).natDegree + (v j).natDegree
        ≤ Q.maxCoeffDegree + (N - 1) + (N - 1) := hbound
    _ = 2 * (N - 1) + Q.maxCoeffDegree := by ring

/-- Vanishing of every undetermined-coefficient equation implies `Q(v) = 0`. -/
theorem eval_eq_zero_of_undetermined
    (Q : @TernaryQuadraticPoly K _) (N : ℕ) (c : Fin 3 × Fin N → K)
    (hc : ∀ f ∈ undeterminedCoeffEqList Q N, MvPolynomial.eval c f = 0) :
    TernaryQuadraticPoly.eval Q (fun i => polyOfCoeffs N fun k => c (i, k)) = 0 := by
  classical
  ext r
  by_cases hr : r < 2 * (N - 1) + Q.maxCoeffDegree + 1
  · have hmem : undeterminedCoeffEq Q N r ∈ undeterminedCoeffEqList Q N := by
      refine List.mem_map.mpr ⟨r, ?_, rfl⟩
      exact List.mem_range.mpr hr
    have := hc _ hmem
    -- `this : eval c (undeterminedCoeffEq Q N r) = 0`
    -- rewrite via the convolution identity
    have hconv := eval_undeterminedCoeffEq Q N r c
    rw [← hconv]
    exact this
  · have hdeg := natDegree_eval_polyOfCoeffs_le Q N c
    exact coeff_eq_zero_of_natDegree_lt (lt_of_le_of_lt hdeg (by omega))

variable [IsAlgClosed K]

/-- **Undetermined-coefficient existence for ternary quadratics over `K[t]`.**

If `2 * (N - 1) + maxCoeffDegree + 1 < 3 * N`, the homogeneous system of undetermined-coefficient
equations has a nontrivial zero over the algebraically closed field `K`.
-/
theorem exists_nonzero_undetermined_solution
    (Q : @TernaryQuadraticPoly K _) (N : ℕ)
    (hN : 2 * (N - 1) + Q.maxCoeffDegree + 1 < 3 * N) :
    ∃ c : Fin 3 × Fin N → K, c ≠ 0 ∧
      ∀ f ∈ undeterminedCoeffEqList Q N, MvPolynomial.eval c f = 0 := by
  classical
  let s : Finset (MvPolynomial (Fin 3 × Fin N) K) :=
    (undeterminedCoeffEqList Q N).toFinset
  have hcard : s.card < Nat.card (Fin 3 × Fin N) := by
    have h3 : Nat.card (Fin 3 × Fin N) = 3 * N := by
      simp [Nat.card_eq_fintype_card]
    have hlen := length_undeterminedCoeffEqList Q N
    have hle : s.card ≤ (undeterminedCoeffEqList Q N).length := by
      simpa [s] using List.toFinset_card_le (undeterminedCoeffEqList Q N)
    omega
  obtain ⟨x, hx0, hx⟩ := exists_common_nonzero_zero_of_card_lt s
    (by
      intro f hf
      have hf' : f ∈ undeterminedCoeffEqList Q N := by
        simpa [s] using hf
      exact undeterminedCoeffEqList_isHomogeneous Q N hf')
    hcard
  refine ⟨x, hx0, ?_⟩
  intro f hf
  exact hx f (by simpa [s] using hf)

/-- Specialize: for `N = maxCoeffDegree + 1`, the count is always favourable. -/
theorem exists_nonzero_undetermined_solution_of_maxDegree
    (Q : @TernaryQuadraticPoly K _) :
    ∃ N : ℕ, ∃ c : Fin 3 × Fin N → K, c ≠ 0 ∧
      ∀ f ∈ undeterminedCoeffEqList Q N, MvPolynomial.eval c f = 0 := by
  classical
  let δ := Q.maxCoeffDegree
  let N := δ + 1
  have hcount : 2 * (N - 1) + δ + 1 < 3 * N := by
    change 2 * ((δ + 1) - 1) + δ + 1 < 3 * (δ + 1)
    omega
  obtain ⟨c, hc0, hc⟩ := exists_nonzero_undetermined_solution Q N hcount
  exact ⟨N, c, hc0, hc⟩

/-- **Tsen isotropy for ternary quadratics over `K[t]`.**

A ternary quadratic form with polynomial coefficients over an algebraically closed field admits a
nontrivial polynomial solution.
-/
theorem exists_isotropic_ternary_quadratic_poly
    (Q : @TernaryQuadraticPoly K _) :
    ∃ v : Fin 3 → K[X], v ≠ 0 ∧ TernaryQuadraticPoly.eval Q v = 0 := by
  classical
  obtain ⟨N, c, hc0, hc⟩ := exists_nonzero_undetermined_solution_of_maxDegree Q
  refine ⟨fun i => polyOfCoeffs N fun k => c (i, k), ?_, ?_⟩
  · intro hv
    apply hc0
    ext ⟨i, k⟩
    have := congrFun hv i
    have hcoeff := congrArg (fun p : K[X] => p.coeff (k : ℕ)) this
    simpa [coeff_polyOfCoeffs, k.isLt] using hcoeff
  · exact eval_eq_zero_of_undetermined Q N c hc


/-! ### Constant-field isotropy -/

/-- A single positive-degree homogeneous polynomial in at least two variables has a nontrivial
zero over an algebraically closed field. -/
theorem exists_nonzero_zero_of_homogeneous
    {σ : Type*} [Fintype σ]
    (f : MvPolynomial σ K) {d : ℕ} (hd : 0 < d) (hf : f.IsHomogeneous d)
    (hσ : 1 < Fintype.card σ) :
    ∃ x : σ → K, x ≠ 0 ∧ eval x f = 0 := by
  classical
  obtain ⟨x, hx, hzero⟩ := exists_common_nonzero_zero_of_card_lt
    ({f} : Finset (MvPolynomial σ K))
    (by
      intro g hg
      simp only [Finset.mem_singleton] at hg
      exact hg ▸ ⟨d, hd, hf⟩)
    (by
      simpa [Nat.card_eq_fintype_card] using hσ)
  exact ⟨x, hx, hzero f (by simp)⟩

/-- A ternary homogeneous form of positive degree over an algebraically closed field is
isotropic. -/
theorem exists_nonzero_zero_ternary_homogeneous
    (f : MvPolynomial (Fin 3) K) {d : ℕ} (hd : 0 < d) (hf : f.IsHomogeneous d) :
    ∃ x : Fin 3 → K, x ≠ 0 ∧ eval x f = 0 :=
  exists_nonzero_zero_of_homogeneous f hd hf (by decide)

/-- Ternary quadratic forms over algebraically closed fields are isotropic. -/
theorem exists_isotropic_ternary_quadratic_homogeneous
    (f : MvPolynomial (Fin 3) K) (hf : f.IsHomogeneous 2) :
    ∃ x : Fin 3 → K, x ≠ 0 ∧ eval x f = 0 :=
  exists_nonzero_zero_ternary_homogeneous f (by decide) hf

/-- Binary forms of positive degree over an algebraically closed field are isotropic. -/
theorem exists_nonzero_zero_binary_homogeneous
    (f : MvPolynomial (Fin 2) K) {d : ℕ} (hd : 0 < d) (hf : f.IsHomogeneous d) :
    ∃ x : Fin 2 → K, x ≠ 0 ∧ eval x f = 0 :=
  exists_nonzero_zero_of_homogeneous f hd hf (by decide)

end

end BConicBundleMultisections
