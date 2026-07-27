/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.Algebra.MvPolynomial.PDeriv
public import Mathlib.Algebra.Polynomial.Derivative
public import Mathlib.Algebra.Polynomial.BigOperators
public import Mathlib.FieldTheory.IsAlgClosed.Basic
public import Mathlib.Data.Fintype.BigOperators

/-!
# Assembly of the conic-discriminant nonvanishing argument

Helpers and the discharge of
`coordinateLineConicDiscriminant_ne_zero_of_smooth` from `GoodLineCondition`.
Separated so chain-rule / leading-coefficient lemmas compile without the
namespace/open collisions of that module.
-/

@[expose] public section

namespace BConicBundleMultisections

noncomputable section

universe u

open scoped BigOperators

/-! ### Univariate chain rule along a polynomial path -/

/-- Differentiating a constant-coefficient multivariate polynomial along a polynomial path. -/
theorem derivative_eval_map_C {σ : Type*} [Fintype σ] [DecidableEq σ]
    {R : Type u} [CommRing R]
    (G : MvPolynomial σ R) (p : σ → Polynomial R) :
    Polynomial.derivative
        (MvPolynomial.eval p (MvPolynomial.map (Polynomial.C : R →+* Polynomial R) G)) =
      ∑ i : σ, Polynomial.derivative (p i) *
        MvPolynomial.eval p
          (MvPolynomial.map (Polynomial.C : R →+* Polynomial R) (MvPolynomial.pderiv i G)) := by
  classical
  induction G using MvPolynomial.induction_on with
  | C a =>
      simp only [MvPolynomial.map_C, MvPolynomial.eval_C, Polynomial.derivative_C,
        MvPolynomial.pderiv_C, map_zero, mul_zero, Finset.sum_const_zero]
  | add f g hf hg =>
      simp only [map_add, hf, hg, Finset.sum_add_distrib, mul_add]
  | mul_X f j hf =>
      set ef : Polynomial R :=
        MvPolynomial.eval p (MvPolynomial.map (Polynomial.C : R →+* Polynomial R) f)
      have hmapX :
          MvPolynomial.eval p
              (MvPolynomial.map (Polynomial.C : R →+* Polynomial R) (f * MvPolynomial.X j)) =
            ef * p j := by
        simp only [ef, map_mul, MvPolynomial.map_X, MvPolynomial.eval_mul, MvPolynomial.eval_X]
      have hpd (i : σ) :
          MvPolynomial.pderiv i (f * MvPolynomial.X j) =
            MvPolynomial.pderiv i f * MvPolynomial.X j + (if i = j then f else 0) := by
        rw [Derivation.leibniz (MvPolynomial.pderiv i) f (MvPolynomial.X j),
          MvPolynomial.pderiv_X]
        by_cases hij : i = j
        · subst hij
          simp only [Pi.single_eq_same, smul_eq_mul, mul_one, mul_comm, add_comm, ↓reduceIte]
        · simp only [Pi.single_eq_of_ne (Ne.symm hij), smul_eq_mul, mul_zero, zero_mul,
            zero_add, add_zero, if_neg hij, mul_comm]
      have hterm (i : σ) :
          MvPolynomial.eval p
              (MvPolynomial.map (Polynomial.C : R →+* Polynomial R)
                (MvPolynomial.pderiv i (f * MvPolynomial.X j))) =
            MvPolynomial.eval p
                (MvPolynomial.map (Polynomial.C : R →+* Polynomial R) (MvPolynomial.pderiv i f)) *
              p j +
              (if i = j then ef else 0) := by
        rw [hpd, map_add, map_mul, MvPolynomial.map_X, MvPolynomial.eval_add,
          MvPolynomial.eval_mul, MvPolynomial.eval_X]
        split_ifs with hij
        · subst hij; rfl
        · simp only [map_zero, MvPolynomial.eval_zero, add_zero]
      have hsum :
          (∑ i : σ, Polynomial.derivative (p i) *
              MvPolynomial.eval p
                (MvPolynomial.map (Polynomial.C : R →+* Polynomial R)
                  (MvPolynomial.pderiv i (f * MvPolynomial.X j)))) =
            (∑ i : σ, Polynomial.derivative (p i) *
                MvPolynomial.eval p
                  (MvPolynomial.map (Polynomial.C : R →+* Polynomial R)
                    (MvPolynomial.pderiv i f))) * p j +
              Polynomial.derivative (p j) * ef := by
        simp only [hterm, mul_add, Finset.sum_add_distrib]
        have h1 :
            (∑ i : σ, Polynomial.derivative (p i) *
                (MvPolynomial.eval p
                    (MvPolynomial.map (Polynomial.C : R →+* Polynomial R)
                      (MvPolynomial.pderiv i f)) * p j)) =
              (∑ i : σ, Polynomial.derivative (p i) *
                  MvPolynomial.eval p
                    (MvPolynomial.map (Polynomial.C : R →+* Polynomial R)
                      (MvPolynomial.pderiv i f))) * p j := by
          simp_rw [← mul_assoc]
          exact (Finset.sum_mul _ _ _).symm
        have h2 :
            (∑ i : σ, Polynomial.derivative (p i) * (if i = j then ef else 0)) =
              Polynomial.derivative (p j) * ef := by
          rw [Finset.sum_eq_single j]
          · simp only [↓reduceIte, mul_comm]
          · intro i _ hij; simp only [hij, ↓reduceIte, mul_zero]
          · intro hj; exact (hj (Finset.mem_univ j)).elim
        rw [h1, h2]
      rw [hmapX, Polynomial.derivative_mul, hf, hsum]
      ring

/-- Evaluating the path polynomial recovers ordinary evaluation. -/
theorem eval_eval_map_C {σ : Type*} {R : Type u} [CommRing R]
    (G : MvPolynomial σ R) (p : σ → Polynomial R) (t : R) :
    Polynomial.eval t (MvPolynomial.eval p (MvPolynomial.map (Polynomial.C : R →+* Polynomial R) G)) =
      MvPolynomial.eval (fun i => Polynomial.eval t (p i)) G := by
  classical
  induction G using MvPolynomial.induction_on with
  | C a => simp only [MvPolynomial.map_C, MvPolynomial.eval_C, Polynomial.eval_C]
  | add f g hf hg =>
      simp only [map_add, MvPolynomial.eval_add, Polynomial.eval_add, hf, hg]
  | mul_X f j hf =>
      simp only [map_mul, MvPolynomial.map_X, MvPolynomial.eval_mul, MvPolynomial.eval_X,
        Polynomial.eval_mul, hf]

/-- A polynomial over an algebraically closed field with no roots is a nonzero constant. -/
theorem eq_C_of_forall_eval_ne_zero {k : Type u} [Field k] [IsAlgClosed k]
    (p : Polynomial k) (hp : ∀ t : k, p.eval t ≠ 0) :
    ∃ c : k, c ≠ 0 ∧ p = Polynomial.C c := by
  have hp0 : p ≠ 0 := by
    intro h
    have := hp 0
    simp [h] at this
  have hdeg : p.natDegree = 0 := by
    by_contra h
    have hpos : p.degree ≠ 0 := fun hd =>
      h (Polynomial.natDegree_eq_of_degree_eq_some (by simpa using hd))
    obtain ⟨t, ht⟩ := IsAlgClosed.exists_root p hpos
    exact hp t ht
  have heq := Polynomial.eq_C_of_natDegree_eq_zero (p := p) hdeg
  refine ⟨p.coeff 0, ?_, heq⟩
  have h0 := hp 0
  rw [heq] at h0
  simpa using h0

/-- **The same conclusion from rootlessness over an algebraically closed extension.**

`k` is arbitrary; only `L` is closed.  Moving the hypothesis to `L`-points is forced, not
incidental: over `ℝ` the polynomial `t² + 1` has no real root and is not constant.  What the real
hypothesis fails to see is the pair of roots `±i`.

The conclusion is an identity of polynomials over `k`, so it comes back down by injectivity alone
— the second row of the descent table in `GeometricPointDescent`. -/
theorem eq_C_of_forall_eval_ne_zero_of_geometric {k : Type u} [Field k]
    {L : Type*} [Field L] [IsAlgClosed L] [Algebra k L]
    (p : Polynomial k) (hp : ∀ t : L, (p.map (algebraMap k L)).eval t ≠ 0) :
    ∃ c : k, c ≠ 0 ∧ p = Polynomial.C c := by
  obtain ⟨c, hc, hcC⟩ := eq_C_of_forall_eval_ne_zero (p.map (algebraMap k L)) hp
  have hdeg : p.natDegree = 0 := by
    have h := congrArg Polynomial.natDegree hcC
    rwa [Polynomial.natDegree_map_eq_of_injective (algebraMap k L).injective,
      Polynomial.natDegree_C] at h
  refine ⟨p.coeff 0, ?_, Polynomial.eq_C_of_natDegree_eq_zero hdeg⟩
  intro h0
  refine hc ?_
  have h := congrArg (fun q : Polynomial L => q.coeff 0) hcC
  simpa [Polynomial.coeff_map, h0] using h.symm

/-- Degree-`m` coefficient vector of a nonzero polynomial vector of max degree `m`. -/
theorem leading_vector_ne_zero {k : Type u} [Field k]
    (n : Fin 3 → Polynomial k) (hn0 : n ≠ 0)
    (m : ℕ) (hm : m = Finset.univ.sup fun i => (n i).natDegree) :
    (fun i => (n i).coeff m) ≠ 0 := by
  classical
  obtain ⟨i0, _, hi0⟩ :=
    Finset.exists_mem_eq_sup Finset.univ Finset.univ_nonempty fun i => (n i).natDegree
  have hm0 : m = (n i0).natDegree := by simpa [hm] using hi0
  by_cases hzi : n i0 = 0
  · have hmz : m = 0 := by simp [hm0, hzi, Polynomial.natDegree_zero]
    obtain ⟨j, hj⟩ : ∃ j, n j ≠ 0 := by
      by_contra hall; push Not at hall; exact hn0 (funext hall)
    have hdegj : (n j).natDegree = 0 := by
      have hle := Finset.le_sup (f := fun i => (n i).natDegree) (Finset.mem_univ j)
      have : (n j).natDegree ≤ m := by simpa [hm] using hle
      simpa [hmz] using this
    intro hzero
    have hcoeff : (n j).coeff 0 ≠ 0 := by
      have : (n j).leadingCoeff ≠ 0 := Polynomial.leadingCoeff_ne_zero.mpr hj
      rwa [Polynomial.leadingCoeff, hdegj] at this
    have : (n j).coeff m = 0 := congrFun hzero j
    exact hcoeff (by simpa [hmz] using this)
  · have hlead : (n i0).leadingCoeff ≠ 0 := Polynomial.leadingCoeff_ne_zero.mpr hzi
    intro hzero
    have hzi_coeff : (n i0).coeff m = 0 := congrFun hzero i0
    change (n i0).coeff (n i0).natDegree ≠ 0 at hlead
    rw [hm0] at hzi_coeff
    exact hlead hzi_coeff

/-! ### Leading coefficients of products of three polynomial powers -/

/-- Top coefficient of a product of three powers under a uniform degree bound. -/
theorem coeff_prod3_pow_of_natDegree_le {R : Type u} [CommRing R]
    (n0 n1 n2 : Polynomial R) (m a0 a1 a2 : ℕ)
    (h0 : n0.natDegree ≤ m) (h1 : n1.natDegree ≤ m) (h2 : n2.natDegree ≤ m) :
    (n0 ^ a0 * n1 ^ a1 * n2 ^ a2).coeff (m * (a0 + a1 + a2)) =
      (n0.coeff m) ^ a0 * (n1.coeff m) ^ a1 * (n2.coeff m) ^ a2 := by
  have ha0 : (n0 ^ a0).natDegree ≤ a0 * m :=
    (Polynomial.natDegree_pow_le).trans (Nat.mul_le_mul_left _ h0)
  have ha1 : (n1 ^ a1).natDegree ≤ a1 * m :=
    (Polynomial.natDegree_pow_le).trans (Nat.mul_le_mul_left _ h1)
  have ha2 : (n2 ^ a2).natDegree ≤ a2 * m :=
    (Polynomial.natDegree_pow_le).trans (Nat.mul_le_mul_left _ h2)
  have h01 : (n0 ^ a0 * n1 ^ a1).natDegree ≤ (a0 + a1) * m := by
    refine (Polynomial.natDegree_mul_le).trans ?_
    linarith [ha0, ha1]
  have htop01 :=
    Polynomial.coeff_mul_add_eq_of_natDegree_le (df := a0 * m) (dg := a1 * m) ha0 ha1
  have htop :=
    Polynomial.coeff_mul_add_eq_of_natDegree_le
      (df := (a0 + a1) * m) (dg := a2 * m) h01 ha2
  have hpow0 := Polynomial.coeff_pow_of_natDegree_le (p := n0) (n := m) (m := a0) h0
  have hpow1 := Polynomial.coeff_pow_of_natDegree_le (p := n1) (n := m) (m := a1) h1
  have hpow2 := Polynomial.coeff_pow_of_natDegree_le (p := n2) (n := m) (m := a2) h2
  have hidx : m * (a0 + a1 + a2) = (a0 + a1) * m + a2 * m := by ring
  have hidx01 : (a0 + a1) * m = a0 * m + a1 * m := by ring
  calc (n0 ^ a0 * n1 ^ a1 * n2 ^ a2).coeff (m * (a0 + a1 + a2))
      = (n0 ^ a0 * n1 ^ a1 * n2 ^ a2).coeff ((a0 + a1) * m + a2 * m) := by rw [hidx]
    _ = (n0 ^ a0 * n1 ^ a1).coeff ((a0 + a1) * m) * (n2 ^ a2).coeff (a2 * m) := htop
    _ = (n0 ^ a0 * n1 ^ a1).coeff (a0 * m + a1 * m) * (n2 ^ a2).coeff (a2 * m) := by
        rw [hidx01]
    _ = ((n0 ^ a0).coeff (a0 * m) * (n1 ^ a1).coeff (a1 * m)) * (n2 ^ a2).coeff (a2 * m) := by
        rw [htop01]
    _ = (n0.coeff m) ^ a0 * (n1.coeff m) ^ a1 * (n2.coeff m) ^ a2 := by
        rw [hpow0, hpow1, hpow2]

/-- Same statement packaged for a `Fin 3`-indexed family and multiindex. -/
theorem coeff_prod_pow_fin3_of_natDegree_le {R : Type u} [CommRing R]
    (n : Fin 3 → Polynomial R) (m : ℕ) (s : Fin 3 → ℕ)
    (hm : ∀ i, (n i).natDegree ≤ m) :
    (∏ i : Fin 3, n i ^ s i).coeff (m * ∑ i : Fin 3, s i) =
      ∏ i : Fin 3, (n i).coeff m ^ s i := by
  classical
  convert coeff_prod3_pow_of_natDegree_le (n 0) (n 1) (n 2) m (s 0) (s 1) (s 2)
    (hm 0) (hm 1) (hm 2) using 2 <;>
    simp [Fin.prod_univ_three, Fin.sum_univ_three, mul_assoc]

end

end BConicBundleMultisections
