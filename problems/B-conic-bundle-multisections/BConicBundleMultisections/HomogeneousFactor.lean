/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the LICENSE file.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.ChartHomogenization
public import Mathlib.Algebra.MvPolynomial.Nilpotent
public import Mathlib.Algebra.Polynomial.Degree.TrailingDegree
public import Mathlib.RingTheory.Polynomial.UniqueFactorization
public import Mathlib.RingTheory.UniqueFactorizationDomain.NormalizedFactors

/-!
# Factors of homogeneous multivariate polynomials

Over a domain, every nonzero factor of a nonzero homogeneous multivariate polynomial is
homogeneous.  The proof records the grading in one auxiliary polynomial variable: scale every
original variable by `T`.  A homogeneous polynomial becomes one monomial in `T`; the leading and
trailing degrees of a product then force both factors to be monomials in `T` as well.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u v w

open MvPolynomial

variable {K : Type u} [CommRing K] [IsDomain K]
variable {σ : Type v}

/-- Record the ordinary total-degree grading in an auxiliary polynomial variable. -/
def MvPolynomial.degreeEmbedding :
    MvPolynomial σ K →ₐ[K] Polynomial (MvPolynomial σ K) :=
  aeval fun i => Polynomial.X * Polynomial.C (MvPolynomial.X i)

/-- Substituting the constant polynomial `C (X i)` is just coefficientwise inclusion. -/
private theorem aeval_polynomial_C_X (p : MvPolynomial σ K) :
    aeval (fun i : σ => Polynomial.C (MvPolynomial.X i)) p = Polynomial.C p := by
  induction p using MvPolynomial.induction_on with
  | C r => simp
  | add p q hp hq => simp [hp, hq]
  | mul_X p i hp => simp [hp, mul_assoc]

/-- A homogeneous polynomial maps to a single monomial in the grading variable. -/
theorem MvPolynomial.degreeEmbedding_eq_C_mul_X_pow_of_isHomogeneous
    {p : MvPolynomial σ K} {n : ℕ} (hp : p.IsHomogeneous n) :
    MvPolynomial.degreeEmbedding p = Polynomial.X ^ n * Polynomial.C p := by
  change aeval (fun i : σ => Polynomial.X * Polynomial.C (MvPolynomial.X i)) p = _
  calc
    aeval (fun i : σ => Polynomial.X * Polynomial.C (MvPolynomial.X i)) p =
      Polynomial.X ^ n *
        aeval (fun i : σ => Polynomial.C (MvPolynomial.X i)) p := by
      simpa using
        (aeval_smul_point_of_isHomogeneous
          (R := K) (S := Polynomial (MvPolynomial σ K)) hp
          (Polynomial.X : Polynomial (MvPolynomial σ K))
          (fun i : σ => Polynomial.C (MvPolynomial.X i)))
    _ = Polynomial.X ^ n * Polynomial.C p := by rw [aeval_polynomial_C_X]

/-- Evaluating the grading variable at one recovers the original multivariate polynomial. -/
@[simp]
theorem MvPolynomial.eval_one_degreeEmbedding (p : MvPolynomial σ K) :
    Polynomial.eval 1 (MvPolynomial.degreeEmbedding p) = p := by
  induction p using MvPolynomial.induction_on with
  | C r => simp [MvPolynomial.degreeEmbedding]
  | add p q hp hq => simp [hp, hq]
  | mul_X p i hp =>
      change Polynomial.eval 1
          (MvPolynomial.degreeEmbedding (p * MvPolynomial.X i)) = p * MvPolynomial.X i
      rw [map_mul, Polynomial.eval_mul, hp]
      simp [MvPolynomial.degreeEmbedding]

/-- The grading embedding is injective. -/
theorem MvPolynomial.degreeEmbedding_injective :
    Function.Injective (MvPolynomial.degreeEmbedding :
      MvPolynomial σ K → Polynomial (MvPolynomial σ K)) := by
  intro p q hpq
  simpa using congrArg (Polynomial.eval 1) hpq

/-- A monomial maps to the monomial of its total degree in the grading variable. -/
theorem MvPolynomial.degreeEmbedding_monomial (d : σ →₀ ℕ) (r : K) :
    MvPolynomial.degreeEmbedding (MvPolynomial.monomial d r) =
      Polynomial.monomial d.degree (MvPolynomial.monomial d r) := by
  rw [MvPolynomial.degreeEmbedding_eq_C_mul_X_pow_of_isHomogeneous
    (MvPolynomial.isHomogeneous_monomial r rfl)]
  rw [mul_comm, Polynomial.C_mul_X_pow_eq_monomial]

/-- The coefficient of the grading variable is the corresponding homogeneous component. -/
theorem MvPolynomial.coeff_degreeEmbedding (p : MvPolynomial σ K) (n : ℕ) :
    (MvPolynomial.degreeEmbedding p).coeff n = MvPolynomial.homogeneousComponent n p := by
  classical
  conv_lhs => rw [← p.support_sum_monomial_coeff]
  rw [map_sum]
  rw [Polynomial.finsetSum_coeff]
  rw [MvPolynomial.homogeneousComponent_apply]
  simp_rw [MvPolynomial.degreeEmbedding_monomial, Polynomial.coeff_monomial]
  rw [Finset.sum_filter]

/-- If the first and last nonzero coefficients have the same index, there is only one term. -/
private theorem Polynomial.eq_monomial_natDegree_of_natTrailingDegree_eq
    {R : Type*} [Semiring R] (p : Polynomial R)
    (hdegree : p.natTrailingDegree = p.natDegree) :
    p = Polynomial.monomial p.natDegree (p.coeff p.natDegree) := by
  classical
  ext i
  by_cases hi : i = p.natDegree
  · subst i
    simp
  by_cases hlt : i < p.natDegree
  · have htrail : i < p.natTrailingDegree := by simpa [hdegree] using hlt
    rw [Polynomial.coeff_eq_zero_of_lt_natTrailingDegree htrail]
    simp [Polynomial.coeff_monomial, Ne.symm hi]
  · have hdegree_lt : p.natDegree < i :=
      lt_of_le_of_ne (Nat.le_of_not_gt hlt) (Ne.symm hi)
    rw [Polynomial.coeff_eq_zero_of_natDegree_lt hdegree_lt]
    simp [Polynomial.coeff_monomial, Ne.symm hi]

/-- Nonzero factors of a nonzero homogeneous polynomial are themselves homogeneous. -/
theorem MvPolynomial.exists_isHomogeneous_of_mul_isHomogeneous
    {p q : MvPolynomial σ K} {n : ℕ} (hp0 : p ≠ 0) (hq0 : q ≠ 0)
    (hpq : (p * q).IsHomogeneous n) :
    ∃ a b : ℕ, p.IsHomogeneous a ∧ q.IsHomogeneous b ∧ a + b = n := by
  let P : Polynomial (MvPolynomial σ K) := MvPolynomial.degreeEmbedding p
  let Q : Polynomial (MvPolynomial σ K) := MvPolynomial.degreeEmbedding q
  have hP0 : P ≠ 0 := by
    simpa [P] using MvPolynomial.degreeEmbedding_injective.ne hp0
  have hQ0 : Q ≠ 0 := by
    simpa [Q] using MvPolynomial.degreeEmbedding_injective.ne hq0
  have hpq0 : p * q ≠ 0 := mul_ne_zero hp0 hq0
  have hproduct : P * Q =
      Polynomial.X ^ n * Polynomial.C (p * q) := by
    change MvPolynomial.degreeEmbedding p * MvPolynomial.degreeEmbedding q = _
    rw [← map_mul]
    exact MvPolynomial.degreeEmbedding_eq_C_mul_X_pow_of_isHomogeneous hpq
  have hnatDegree_mul : (P * Q).natDegree = P.natDegree + Q.natDegree :=
    Polynomial.natDegree_mul'
      (mul_ne_zero (Polynomial.leadingCoeff_ne_zero.mpr hP0)
        (Polynomial.leadingCoeff_ne_zero.mpr hQ0))
  have hnatDegree_product : (P * Q).natDegree = n := by
    rw [hproduct, mul_comm]
    exact Polynomial.natDegree_C_mul_X_pow n (p * q) hpq0
  have hdegree : P.natDegree + Q.natDegree = n := by
    rw [← hnatDegree_mul, hnatDegree_product]
  have hnatTrailingDegree_mul :
      (P * Q).natTrailingDegree = P.natTrailingDegree + Q.natTrailingDegree :=
    Polynomial.natTrailingDegree_mul hP0 hQ0
  have hnatTrailingDegree_product : (P * Q).natTrailingDegree = n := by
    rw [hproduct, mul_comm,
      Polynomial.natTrailingDegree_mul_X_pow (Polynomial.C_ne_zero.mpr hpq0)]
    simp only [Polynomial.natTrailingDegree_C, zero_add]
  have htrailing : P.natTrailingDegree + Q.natTrailingDegree = n := by
    rw [← hnatTrailingDegree_mul, hnatTrailingDegree_product]
  have hPtrailing : P.natTrailingDegree = P.natDegree := by
    have hP_le := P.natTrailingDegree_le_natDegree
    have hQ_le := Q.natTrailingDegree_le_natDegree
    omega
  have hQtrailing : Q.natTrailingDegree = Q.natDegree := by
    have hP_le := P.natTrailingDegree_le_natDegree
    have hQ_le := Q.natTrailingDegree_le_natDegree
    omega
  have hPmonomial : P = Polynomial.monomial P.natDegree (P.coeff P.natDegree) :=
    Polynomial.eq_monomial_natDegree_of_natTrailingDegree_eq P hPtrailing
  have hQmonomial : Q = Polynomial.monomial Q.natDegree (Q.coeff Q.natDegree) :=
    Polynomial.eq_monomial_natDegree_of_natTrailingDegree_eq Q hQtrailing
  have hPcoeff : P.coeff P.natDegree = p := by
    calc
      P.coeff P.natDegree = Polynomial.eval 1 P := by rw [hPmonomial]; simp
      _ = p := by simpa [P] using MvPolynomial.eval_one_degreeEmbedding p
  have hQcoeff : Q.coeff Q.natDegree = q := by
    calc
      Q.coeff Q.natDegree = Polynomial.eval 1 Q := by rw [hQmonomial]; simp
      _ = q := by simpa [Q] using MvPolynomial.eval_one_degreeEmbedding q
  have hPcomponent : MvPolynomial.homogeneousComponent P.natDegree p = p := by
    rw [← MvPolynomial.coeff_degreeEmbedding]
    change P.coeff P.natDegree = p
    exact hPcoeff
  have hQcomponent : MvPolynomial.homogeneousComponent Q.natDegree q = q := by
    rw [← MvPolynomial.coeff_degreeEmbedding]
    change Q.coeff Q.natDegree = q
    exact hQcoeff
  refine ⟨P.natDegree, Q.natDegree, ?_, ?_, hdegree⟩
  · have h := MvPolynomial.homogeneousComponent_isHomogeneous P.natDegree p
    rwa [hPcomponent] at h
  · have h := MvPolynomial.homogeneousComponent_isHomogeneous Q.natDegree q
    rwa [hQcomponent] at h

/-- A nonzero homogeneous polynomial of positive degree has an irreducible homogeneous factor of
positive degree. -/
theorem MvPolynomial.exists_irreducible_isHomogeneous_dvd
    {L : Type u} [Field L] {τ : Type v}
    {p : MvPolynomial τ L} {n : ℕ}
    (hp : p.IsHomogeneous n) (hp0 : p ≠ 0) (hn : 0 < n) :
    ∃ q : MvPolynomial τ L, ∃ m : ℕ,
      Irreducible q ∧ q.IsHomogeneous m ∧ 0 < m ∧ q ∣ p := by
  have hpNonunit : ¬ IsUnit p := by
    intro hunit
    have hzero := (MvPolynomial.isUnit_iff_totalDegree_of_isReduced.mp hunit).2
    have hdegree := hp.totalDegree hp0
    omega
  obtain ⟨q, hqIrreducible, hqDvd⟩ :=
    WfDvdMonoid.exists_irreducible_factor hpNonunit hp0
  obtain ⟨r, hr⟩ := hqDvd
  have hq0 : q ≠ 0 := hqIrreducible.ne_zero
  have hr0 : r ≠ 0 := by
    intro hrzero
    apply hp0
    rw [hr, hrzero, mul_zero]
  have hproduct : (q * r).IsHomogeneous n := by
    rw [← hr]
    exact hp
  obtain ⟨a, b, hqHomogeneous, _hrHomogeneous, hab⟩ :=
    MvPolynomial.exists_isHomogeneous_of_mul_isHomogeneous hq0 hr0 hproduct
  have ha : 0 < a := by
    by_contra hapos
    have ha0 : a = 0 := Nat.eq_zero_of_not_pos hapos
    subst a
    have hqC : q = MvPolynomial.C (MvPolynomial.coeff 0 q) := by
      calc
        q = MvPolynomial.homogeneousComponent 0 q :=
          (MvPolynomial.homogeneousComponent_eq_self hqHomogeneous).symm
        _ = MvPolynomial.C (MvPolynomial.coeff 0 q) :=
          MvPolynomial.homogeneousComponent_zero q
    have hcoeff0 : MvPolynomial.coeff 0 q ≠ 0 := by
      intro hzero
      apply hq0
      rw [hqC, hzero, map_zero]
    apply hqIrreducible.not_isUnit
    rw [MvPolynomial.isUnit_iff_eq_C_of_isReduced]
    exact ⟨MvPolynomial.coeff 0 q, isUnit_iff_ne_zero.mpr hcoeff0, hqC⟩
  exact ⟨q, a, hqIrreducible, hqHomogeneous, ha, ⟨r, hr⟩⟩

/-- If a positive-degree homogeneous relation vanishes after evaluation in a domain, one of its
irreducible homogeneous factors already vanishes. -/
theorem MvPolynomial.exists_irreducible_isHomogeneous_dvd_aeval_eq_zero
    {L : Type u} [Field L] {τ : Type v}
    {S : Type w} [CommRing S] [IsDomain S] [Algebra L S]
    {p : MvPolynomial τ L} {n : ℕ}
    (hp : p.IsHomogeneous n) (hp0 : p ≠ 0) (hn : 0 < n)
    (y : τ → S) (hvan : aeval y p = 0) :
    ∃ q : MvPolynomial τ L, ∃ m : ℕ,
      Irreducible q ∧ q.IsHomogeneous m ∧ 0 < m ∧ q ∣ p ∧ aeval y q = 0 := by
  letI : NormalizationMonoid (MvPolynomial τ L) := Classical.arbitrary _
  let f : MvPolynomial τ L →* S := (aeval y).toRingHom.toMonoidHom
  have hassociated : Associated (f (UniqueFactorizationMonoid.normalizedFactors p).prod) (f p) :=
    (UniqueFactorizationMonoid.prod_normalizedFactors hp0).map f
  have hprodzero : f (UniqueFactorizationMonoid.normalizedFactors p).prod = 0 :=
    hassociated.eq_zero_iff.mpr hvan
  have hmappedzero :
      ((UniqueFactorizationMonoid.normalizedFactors p).map f).prod = 0 := by
    rw [← f.map_multiset_prod]
    exact hprodzero
  have hzeroMem : 0 ∈ (UniqueFactorizationMonoid.normalizedFactors p).map f :=
    Multiset.prod_eq_zero_iff.mp hmappedzero
  obtain ⟨q, hqMem, hqEval⟩ := Multiset.mem_map.mp hzeroMem
  have hqIrreducible : Irreducible q :=
    UniqueFactorizationMonoid.irreducible_of_normalized_factor q hqMem
  have hqDvd : q ∣ p :=
    (Multiset.dvd_prod hqMem).trans
      (UniqueFactorizationMonoid.prod_normalizedFactors hp0).dvd
  obtain ⟨r, hr⟩ := hqDvd
  have hq0 : q ≠ 0 := hqIrreducible.ne_zero
  have hr0 : r ≠ 0 := by
    intro hrzero
    apply hp0
    rw [hr, hrzero, mul_zero]
  have hproduct : (q * r).IsHomogeneous n := by
    rw [← hr]
    exact hp
  obtain ⟨a, b, hqHomogeneous, _hrHomogeneous, hab⟩ :=
    MvPolynomial.exists_isHomogeneous_of_mul_isHomogeneous hq0 hr0 hproduct
  have ha : 0 < a := by
    by_contra hapos
    have ha0 : a = 0 := Nat.eq_zero_of_not_pos hapos
    subst a
    have hqC : q = MvPolynomial.C (MvPolynomial.coeff 0 q) := by
      calc
        q = MvPolynomial.homogeneousComponent 0 q :=
          (MvPolynomial.homogeneousComponent_eq_self hqHomogeneous).symm
        _ = MvPolynomial.C (MvPolynomial.coeff 0 q) :=
          MvPolynomial.homogeneousComponent_zero q
    have hcoeff0 : MvPolynomial.coeff 0 q ≠ 0 := by
      intro hzero
      apply hq0
      rw [hqC, hzero, map_zero]
    apply hqIrreducible.not_isUnit
    rw [MvPolynomial.isUnit_iff_eq_C_of_isReduced]
    exact ⟨MvPolynomial.coeff 0 q, isUnit_iff_ne_zero.mpr hcoeff0, hqC⟩
  exact ⟨q, a, hqIrreducible, hqHomogeneous, ha, ⟨r, hr⟩, hqEval⟩

end

end BConicBundleMultisections
