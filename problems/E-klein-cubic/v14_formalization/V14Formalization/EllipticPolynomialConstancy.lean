/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import Mathlib.NumberTheory.FLT.Polynomial
public import Mathlib.AlgebraicGeometry.EllipticCurve.Affine.Point
public import Mathlib.AlgebraicGeometry.EllipticCurve.NormalForms
public import Mathlib.RingTheory.PrincipalIdealDomain
public import Mathlib.FieldTheory.IsAlgClosed.Basic
public import Mathlib.FieldTheory.IsAlgClosed.AlgebraicClosure
public import Mathlib.FieldTheory.RatFunc.AsPolynomial
public import Mathlib.Algebra.MvPolynomial.Equiv
public import Mathlib.RingTheory.Localization.FractionRing

/-!
# Constancy of maps to short Weierstrass elliptic curves

Polynomial and rational-function solutions of a smooth short-Weierstrass
equation are constant.  The multivariable endpoint treats the pure
transcendental function fields of the normal divisor, including the exact
four-variable field of the standard chart of P2 x P2.
-/

open Polynomial

namespace V14Formalization
namespace EllipticPolynomialConstancy

variable {k : Type*} [Field k] [IsAlgClosed k]

lemma isSquare_of_associated_square {a d : k[X]} (h : Associated (d ^ 2) a) :
    IsSquare a := by
  obtain ⟨u, hu⟩ := h
  obtain ⟨r, -, hr⟩ := Polynomial.isUnit_iff.mp u.isUnit
  obtain ⟨z, hz⟩ := IsAlgClosed.exists_pow_nat_eq r (by decide : 0 < 2)
  refine ⟨C z * d, ?_⟩
  rw [← hu, ← hr, ← hz, map_pow]
  ring

lemma isSquare_left_of_coprime_mul_eq_square {a b y : k[X]}
    (hab : IsCoprime a b) (h : a * b = y ^ 2) : IsSquare a := by
  obtain ⟨d, hd⟩ := exists_associated_pow_of_mul_eq_pow' hab h
  exact isSquare_of_associated_square hd

omit [IsAlgClosed k] in
lemma isCoprime_sub_C_sub_C {x : k[X]} {e₁ e₂ : k} (h : e₁ ≠ e₂) :
    IsCoprime (x - C e₁) (x - C e₂) := by
  refine ⟨C (e₂ - e₁)⁻¹, -C (e₂ - e₁)⁻¹, ?_⟩
  rw [neg_mul, ← sub_eq_add_neg]
  rw [← mul_sub]
  rw [sub_sub_sub_cancel_left, ← C_sub, ← map_mul]
  field_simp [h]
  exact C_1

omit [IsAlgClosed k] in
lemma isCoprime_homogeneous_split_factors
    {a d : k[X]} (had : IsCoprime a d) {e₁ e₂ : k} (h12 : e₁ ≠ e₂) :
    IsCoprime (a - C e₁ * d ^ 2) (a - C e₂ * d ^ 2) := by
  have hfd : IsCoprime (a - C e₁ * d ^ 2) d := by
    obtain ⟨u, v, huv⟩ := had
    refine ⟨u, v + u * C e₁ * d, ?_⟩
    calc
      u * (a - C e₁ * d ^ 2) + (v + u * C e₁ * d) * d =
          u * a + v * d := by ring
      _ = 1 := huv
  have hfdsq : IsCoprime (a - C e₁ * d ^ 2) (d ^ 2) := hfd.pow_right
  have hscaled : IsCoprime (a - C e₁ * d ^ 2) (C (e₁ - e₂) * d ^ 2) := by
    obtain ⟨u, v, huv⟩ := hfdsq
    refine ⟨u, v * C (e₁ - e₂)⁻¹, ?_⟩
    have hs : C (e₁ - e₂)⁻¹ * C (e₁ - e₂) = (1 : k[X]) := by
      rw [← map_mul, inv_mul_cancel₀ (sub_ne_zero.mpr h12), C_1]
    calc
      u * (a - C e₁ * d ^ 2) +
          (v * C (e₁ - e₂)⁻¹) * (C (e₁ - e₂) * d ^ 2) =
          u * (a - C e₁ * d ^ 2) +
            v * (C (e₁ - e₂)⁻¹ * C (e₁ - e₂)) * d ^ 2 := by ring
      _ = u * (a - C e₁ * d ^ 2) + v * d ^ 2 := by rw [hs]; ring
      _ = 1 := huv
  obtain ⟨u, v, huv⟩ := hscaled
  refine ⟨u - v, v, ?_⟩
  calc
    (u - v) * (a - C e₁ * d ^ 2) + v * (a - C e₂ * d ^ 2) =
        u * (a - C e₁ * d ^ 2) + v * (C (e₁ - e₂) * d ^ 2) := by
          rw [C_sub]
          ring
    _ = 1 := huv

lemma homogeneous_split_factors_are_squares
    {a b d : k[X]} (had : IsCoprime a d) {e₁ e₂ e₃ : k}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
      (a - C e₃ * d ^ 2) = b ^ 2) :
    IsSquare (a - C e₁ * d ^ 2) ∧
      IsSquare (a - C e₂ * d ^ 2) ∧
      IsSquare (a - C e₃ * d ^ 2) := by
  have hc12 := isCoprime_homogeneous_split_factors had h12
  have hc13 := isCoprime_homogeneous_split_factors had h13
  have hc23 := isCoprime_homogeneous_split_factors had h23
  constructor
  · apply isSquare_left_of_coprime_mul_eq_square (hc12.mul_right hc13)
    simpa only [mul_assoc] using heq
  constructor
  · apply isSquare_left_of_coprime_mul_eq_square (hc12.symm.mul_right hc23)
    calc
      (a - C e₂ * d ^ 2) *
          ((a - C e₁ * d ^ 2) * (a - C e₃ * d ^ 2)) =
          ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
            (a - C e₃ * d ^ 2) := by ring
      _ = b ^ 2 := heq
  · apply isSquare_left_of_coprime_mul_eq_square
      (hc13.symm.mul_right hc23.symm)
    calc
      (a - C e₃ * d ^ 2) *
          ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) =
          ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
            (a - C e₃ * d ^ 2) := by ring
      _ = b ^ 2 := heq

/-- The coefficient of the pulled-back invariant differential has no finite
poles.  This is the algebraic core: after the three split cubic factors are
squares, their square roots all divide `a' d - 2 a d'`, and their product is
`b` up to sign. -/
lemma split_square_root_dvd_invariant_numerator
    {a d p : k[X]} {e : k} (hp : p ^ 2 = a - C e * d ^ 2) :
    p ∣ derivative a * d - (2 : k[X]) * a * derivative d := by
  refine ⟨(2 : k[X]) * (derivative p * d - p * derivative d), ?_⟩
  calc
    derivative a * d - (2 : k[X]) * a * derivative d =
        derivative (a - C e * d ^ 2) * d -
          (2 : k[X]) * (a - C e * d ^ 2) * derivative d := by
            simp only [derivative_sub, derivative_mul, derivative_C,
              zero_mul, zero_add, derivative_pow, C_eq_natCast]
            ring
    _ = derivative (p ^ 2) * d - (2 : k[X]) * p ^ 2 * derivative d := by rw [hp]
    _ = p * ((2 : k[X]) * (derivative p * d - p * derivative d)) := by
      simp only [derivative_pow, C_eq_natCast]
      ring

omit [IsAlgClosed k] in
lemma invariant_numerator_rewrite_by_factor
    {a d : k[X]} {e : k} :
    derivative a * d - (2 : k[X]) * a * derivative d =
      derivative (a - C e * d ^ 2) * d -
        (2 : k[X]) * (a - C e * d ^ 2) * derivative d := by
  simp only [derivative_sub, derivative_mul, derivative_C,
    zero_mul, zero_add, derivative_pow, C_eq_natCast]
  ring

lemma square_roots_coprime_of_coprime_squares
    {f g p q : k[X]} (hfg : IsCoprime f g)
    (hp : f = p ^ 2) (hq : g = q ^ 2) : IsCoprime p q := by
  rw [← IsCoprime.pow_iff (m := 2) (n := 2) (by decide) (by decide)]
  simpa [hp, hq] using hfg

omit [IsAlgClosed k] in
lemma square_product_associated_dvd
    {p₁ p₂ p₃ b N : k[X]}
    (hp12 : IsCoprime p₁ p₂) (hp13 : IsCoprime p₁ p₃)
    (hp23 : IsCoprime p₂ p₃)
    (hd₁ : p₁ ∣ N) (hd₂ : p₂ ∣ N) (hd₃ : p₃ ∣ N)
    (hsq : (p₁ * p₂ * p₃) ^ 2 = b ^ 2) : b ∣ N := by
  have hp12_3 : IsCoprime (p₁ * p₂) p₃ := hp13.mul_left hp23
  have hd12 : p₁ * p₂ ∣ N := hp12.mul_dvd hd₁ hd₂
  have hprod : p₁ * p₂ * p₃ ∣ N := hp12_3.mul_dvd hd12 hd₃
  rcases eq_or_eq_neg_of_sq_eq_sq (p₁ * p₂ * p₃) b hsq with hb | hb
  · rwa [← hb]
  · rw [← neg_dvd]
    rwa [← hb]

lemma homogeneous_split_invariant_numerator_dvd
    {a b d : k[X]} (had : IsCoprime a d) {e₁ e₂ e₃ : k}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
      (a - C e₃ * d ^ 2) = b ^ 2) :
    b ∣ derivative a * d - (2 : k[X]) * a * derivative d := by
  obtain ⟨hs₁, hs₂, hs₃⟩ :=
    homogeneous_split_factors_are_squares had h12 h13 h23 heq
  obtain ⟨p₁, hp₁⟩ := hs₁.exists_sq
  obtain ⟨p₂, hp₂⟩ := hs₂.exists_sq
  obtain ⟨p₃, hp₃⟩ := hs₃.exists_sq
  have hc12 := isCoprime_homogeneous_split_factors had h12
  have hc13 := isCoprime_homogeneous_split_factors had h13
  have hc23 := isCoprime_homogeneous_split_factors had h23
  have hp12 : IsCoprime p₁ p₂ := by
    exact square_roots_coprime_of_coprime_squares hc12 hp₁ hp₂
  have hp13 : IsCoprime p₁ p₃ := by
    exact square_roots_coprime_of_coprime_squares hc13 hp₁ hp₃
  have hp23 : IsCoprime p₂ p₃ := by
    exact square_roots_coprime_of_coprime_squares hc23 hp₂ hp₃
  have hd₁ : p₁ ∣ derivative a * d - (2 : k[X]) * a * derivative d :=
    split_square_root_dvd_invariant_numerator hp₁.symm
  have hd₂ : p₂ ∣ derivative a * d - (2 : k[X]) * a * derivative d :=
    split_square_root_dvd_invariant_numerator hp₂.symm
  have hd₃ : p₃ ∣ derivative a * d - (2 : k[X]) * a * derivative d :=
    split_square_root_dvd_invariant_numerator hp₃.symm
  have hsq : (p₁ * p₂ * p₃) ^ 2 = b ^ 2 := by
    calc
      (p₁ * p₂ * p₃) ^ 2 =
          ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
            (a - C e₃ * d ^ 2) := by rw [mul_pow, mul_pow, hp₁, hp₂, hp₃]
      _ = b ^ 2 := heq
  exact square_product_associated_dvd hp12 hp13 hp23 hd₁ hd₂ hd₃ hsq

omit [IsAlgClosed k] in
lemma invariant_numerator_natDegree_lt_add
    {f d N : k[X]} (hf0 : f ≠ 0) (hd0 : d ≠ 0) (hN0 : N ≠ 0)
    (hN : N = derivative f * d - (2 : k[X]) * f * derivative d) :
    N.natDegree < f.natDegree + d.natDegree := by
  have htwo : (2 : k[X]).natDegree = 0 := by norm_num
  by_cases hfdeg : f.natDegree = 0
  · have hfder : derivative f = 0 := derivative_of_natDegree_zero hfdeg
    have hddeg : d.natDegree ≠ 0 := by
      intro hddeg
      have hdder : derivative d = 0 := derivative_of_natDegree_zero hddeg
      apply hN0
      rw [hN, hfder, hdder, zero_mul, mul_zero, sub_zero]
    rw [hN, hfder, zero_mul, zero_sub, natDegree_neg, hfdeg, zero_add]
    calc
      ((2 : k[X]) * f * derivative d).natDegree ≤
          (2 : k[X]).natDegree + f.natDegree + (derivative d).natDegree := by
            have houter := natDegree_mul_le (p := (2 : k[X]) * f) (q := derivative d)
            have hinner := natDegree_mul_le (p := (2 : k[X])) (q := f)
            omega
      _ ≤ 0 + 0 + (d.natDegree - 1) := by
        rw [htwo, hfdeg]
        have hdle := natDegree_derivative_le d
        omega
      _ < d.natDegree := by omega
  · by_cases hddeg : d.natDegree = 0
    · have hdder : derivative d = 0 := derivative_of_natDegree_zero hddeg
      rw [hN, hdder, mul_zero, sub_zero, hddeg, add_zero]
      calc
        (derivative f * d).natDegree ≤
            (derivative f).natDegree + d.natDegree := natDegree_mul_le
        _ ≤ (f.natDegree - 1) + 0 := by
          rw [hddeg]
          have hfle := natDegree_derivative_le f
          omega
        _ < f.natDegree := by omega
    · rw [hN]
      apply lt_of_le_of_lt (natDegree_sub_le _ _)
      rw [max_lt_iff]
      constructor
      · calc
          (derivative f * d).natDegree ≤
              (derivative f).natDegree + d.natDegree := natDegree_mul_le
          _ ≤ (f.natDegree - 1) + d.natDegree := by
            have hfle := natDegree_derivative_le f
            omega
          _ < f.natDegree + d.natDegree := by omega
      · calc
          ((2 : k[X]) * f * derivative d).natDegree ≤
              (2 : k[X]).natDegree + f.natDegree + (derivative d).natDegree := by
                have houter := natDegree_mul_le (p := (2 : k[X]) * f) (q := derivative d)
                have hinner := natDegree_mul_le (p := (2 : k[X])) (q := f)
                omega
          _ ≤ 0 + f.natDegree + (d.natDegree - 1) := by
            rw [htwo]
            have hdle := natDegree_derivative_le d
            omega
          _ < f.natDegree + d.natDegree := by omega

omit [IsAlgClosed k] in
lemma split_factor_degree_relation
    {f g d : k[X]} {c : k} (hd0 : d ≠ 0) (hc : c ≠ 0)
    (hfg : f - g = C c * d ^ 2) (hle : f.natDegree ≤ g.natDegree) :
    (f.natDegree < 2 * d.natDegree → g.natDegree = 2 * d.natDegree) ∧
    (2 * d.natDegree < f.natDegree → g.natDegree = f.natDegree) := by
  have hC0 : C c ≠ (0 : k[X]) := C_ne_zero.mpr hc
  have hd20 : d ^ 2 ≠ 0 := pow_ne_zero _ hd0
  have hdiff : (f - g).natDegree = 2 * d.natDegree := by
    rw [hfg, natDegree_mul hC0 hd20, natDegree_C, natDegree_pow]
    omega
  constructor
  · intro hflt
    have hlt : f.natDegree < g.natDegree := by
      by_contra hnlt
      have hgle : g.natDegree ≤ f.natDegree := Nat.le_of_not_gt hnlt
      have hleDiff := natDegree_sub_le f g
      rw [hdiff] at hleDiff
      omega
    rw [natDegree_sub_eq_right_of_natDegree_lt hlt] at hdiff
    exact hdiff
  · intro hgt
    have hnlt : ¬ f.natDegree < g.natDegree := by
      intro hlt
      have heq := natDegree_sub_eq_right_of_natDegree_lt hlt
      rw [hdiff] at heq
      omega
    have hge : g.natDegree ≤ f.natDegree := Nat.le_of_not_gt hnlt
    exact Nat.le_antisymm hge hle

omit [IsAlgClosed k] in
lemma three_split_factor_degree_bound
    {l m r n B Q : ℕ}
    (hlm : l ≤ m) (hlr : l ≤ r)
    (hmSmall : l < 2 * n → m = 2 * n)
    (hrSmall : l < 2 * n → r = 2 * n)
    (hmLarge : 2 * n < l → m = l)
    (hrLarge : 2 * n < l → r = l)
    (hsum : l + m + r = 2 * B) (hQ : Q < l + n) : Q < B := by
  rcases lt_trichotomy l (2 * n) with hsmall | heq | hlarge
  · rw [hmSmall hsmall, hrSmall hsmall] at hsum
    omega
  · omega
  · rw [hmLarge hlarge, hrLarge hlarge] at hsum
    omega

omit [IsAlgClosed k] in
lemma three_split_factors_invariant_degree_lt
    {f₁ f₂ f₃ d b N : k[X]} {c12 c13 c23 : k}
    (hd0 : d ≠ 0) (hN0 : N ≠ 0)
    (hN₁ : N = derivative f₁ * d - (2 : k[X]) * f₁ * derivative d)
    (hN₂ : N = derivative f₂ * d - (2 : k[X]) * f₂ * derivative d)
    (hN₃ : N = derivative f₃ * d - (2 : k[X]) * f₃ * derivative d)
    (hc12 : c12 ≠ 0) (hc13 : c13 ≠ 0) (hc23 : c23 ≠ 0)
    (h12 : f₁ - f₂ = C c12 * d ^ 2)
    (h13 : f₁ - f₃ = C c13 * d ^ 2)
    (h23 : f₂ - f₃ = C c23 * d ^ 2)
    (heq : f₁ * f₂ * f₃ = b ^ 2) : N.natDegree < b.natDegree := by
  have hf₁ : f₁ ≠ 0 := by
    intro hf
    apply hN0
    rw [hN₁]
    simp [hf]
  have hf₂ : f₂ ≠ 0 := by
    intro hf
    apply hN0
    rw [hN₂]
    simp [hf]
  have hf₃ : f₃ ≠ 0 := by
    intro hf
    apply hN0
    rw [hN₃]
    simp [hf]
  have hb0 : b ≠ 0 := by
    intro hb
    have hlhs : f₁ * f₂ * f₃ ≠ 0 := mul_ne_zero (mul_ne_zero hf₁ hf₂) hf₃
    apply hlhs
    rw [heq, hb, zero_pow (by decide)]
  have hsum : f₁.natDegree + f₂.natDegree + f₃.natDegree =
      2 * b.natDegree := by
    have h := congrArg natDegree heq
    rw [natDegree_mul (mul_ne_zero hf₁ hf₂) hf₃,
      natDegree_mul hf₁ hf₂, natDegree_pow] at h
    omega
  have h21 : f₂ - f₁ = C (-c12) * d ^ 2 := by
    calc
      f₂ - f₁ = -(f₁ - f₂) := by ring
      _ = -(C c12 * d ^ 2) := by rw [h12]
      _ = C (-c12) * d ^ 2 := by rw [map_neg]; ring
  have h31 : f₃ - f₁ = C (-c13) * d ^ 2 := by
    calc
      f₃ - f₁ = -(f₁ - f₃) := by ring
      _ = -(C c13 * d ^ 2) := by rw [h13]
      _ = C (-c13) * d ^ 2 := by rw [map_neg]; ring
  have h32 : f₃ - f₂ = C (-c23) * d ^ 2 := by
    calc
      f₃ - f₂ = -(f₂ - f₃) := by ring
      _ = -(C c23 * d ^ 2) := by rw [h23]
      _ = C (-c23) * d ^ 2 := by rw [map_neg]; ring
  by_cases h12le : f₁.natDegree ≤ f₂.natDegree
  · by_cases h13le : f₁.natDegree ≤ f₃.natDegree
    · obtain ⟨h2s, h2l⟩ := split_factor_degree_relation hd0 hc12 h12 h12le
      obtain ⟨h3s, h3l⟩ := split_factor_degree_relation hd0 hc13 h13 h13le
      apply three_split_factor_degree_bound h12le h13le h2s h3s h2l h3l hsum
      exact invariant_numerator_natDegree_lt_add hf₁ hd0 hN0 hN₁
    · have h31le : f₃.natDegree ≤ f₁.natDegree := by omega
      have h32le : f₃.natDegree ≤ f₂.natDegree := h31le.trans h12le
      obtain ⟨h1s, h1l⟩ :=
        split_factor_degree_relation hd0 (neg_ne_zero.mpr hc13) h31 h31le
      obtain ⟨h2s, h2l⟩ :=
        split_factor_degree_relation hd0 (neg_ne_zero.mpr hc23) h32 h32le
      apply three_split_factor_degree_bound h31le h32le h1s h2s h1l h2l (by omega)
      exact invariant_numerator_natDegree_lt_add hf₃ hd0 hN0 hN₃
  · have h21le : f₂.natDegree ≤ f₁.natDegree := by omega
    by_cases h23le : f₂.natDegree ≤ f₃.natDegree
    · obtain ⟨h1s, h1l⟩ :=
        split_factor_degree_relation hd0 (neg_ne_zero.mpr hc12) h21 h21le
      obtain ⟨h3s, h3l⟩ := split_factor_degree_relation hd0 hc23 h23 h23le
      apply three_split_factor_degree_bound h21le h23le h1s h3s h1l h3l (by omega)
      exact invariant_numerator_natDegree_lt_add hf₂ hd0 hN0 hN₂
    · have h32le : f₃.natDegree ≤ f₂.natDegree := by omega
      have h31le : f₃.natDegree ≤ f₁.natDegree := h32le.trans h21le
      obtain ⟨h1s, h1l⟩ :=
        split_factor_degree_relation hd0 (neg_ne_zero.mpr hc13) h31 h31le
      obtain ⟨h2s, h2l⟩ :=
        split_factor_degree_relation hd0 (neg_ne_zero.mpr hc23) h32 h32le
      apply three_split_factor_degree_bound h31le h32le h1s h2s h1l h2l (by omega)
      exact invariant_numerator_natDegree_lt_add hf₃ hd0 hN0 hN₃

omit [IsAlgClosed k] in
lemma homogeneous_split_invariant_zero_or_degree_lt
    {a b d : k[X]} (hd0 : d ≠ 0) {e₁ e₂ e₃ : k}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
      (a - C e₃ * d ^ 2) = b ^ 2) :
    derivative a * d - (2 : k[X]) * a * derivative d = 0 ∨
      (derivative a * d - (2 : k[X]) * a * derivative d).natDegree < b.natDegree := by
  let N := derivative a * d - (2 : k[X]) * a * derivative d
  by_cases hN0 : N = 0
  · exact Or.inl hN0
  · right
    apply three_split_factors_invariant_degree_lt hd0 hN0
      (invariant_numerator_rewrite_by_factor (e := e₁))
      (invariant_numerator_rewrite_by_factor (e := e₂))
      (invariant_numerator_rewrite_by_factor (e := e₃))
      (sub_ne_zero.mpr h12.symm) (sub_ne_zero.mpr h13.symm)
      (sub_ne_zero.mpr h23.symm)
    · rw [C_sub]
      ring
    · rw [C_sub]
      ring
    · rw [C_sub]
      ring
    · exact heq

omit [IsAlgClosed k] in
lemma invariant_numerator_zero_implies_constants [CharZero k]
    {a d : k[X]} (had : IsCoprime a d) (hd0 : d ≠ 0)
    (hzero : derivative a * d - (2 : k[X]) * a * derivative d = 0) :
    ∃ A D : k, a = C A ∧ d = C D := by
  have htwo : IsUnit (2 : k[X]) := by
    change IsUnit (C (2 : k))
    exact isUnit_C.mpr (isUnit_iff_ne_zero.mpr (by norm_num : (2 : k) ≠ 0))
  have hcop : IsCoprime d ((2 : k[X]) * a) :=
    (isCoprime_mul_unit_left_right htwo d a).mpr had.symm
  have hdiv : d ∣ ((2 : k[X]) * a) * derivative d := by
    refine ⟨derivative a, ?_⟩
    rw [sub_eq_zero] at hzero
    calc
      ((2 : k[X]) * a) * derivative d = derivative a * d := hzero.symm
      _ = d * derivative a := mul_comm _ d
  have hdd : d ∣ derivative d := hcop.dvd_of_dvd_mul_left hdiv
  have hdunit : IsUnit d := by
    by_cases hdeg : d.natDegree = 0
    · rw [Polynomial.isUnit_iff]
      refine ⟨d.coeff 0, ?_, (eq_C_of_natDegree_eq_zero hdeg).symm⟩
      rw [isUnit_iff_ne_zero]
      intro hc
      apply hd0
      rw [eq_C_of_natDegree_eq_zero hdeg, hc, C_0]
    · have hdder0 : derivative d = 0 :=
        eq_zero_of_dvd_of_natDegree_lt hdd (natDegree_derivative_lt hdeg)
      have hdC := eq_C_of_derivative_eq_zero hdder0
      exact False.elim (hdeg (by rw [hdC, natDegree_C]))
  obtain ⟨D, hDunit, hDd⟩ := Polynomial.isUnit_iff.mp hdunit
  have hdder0 : derivative d = 0 := by rw [← hDd, derivative_C]
  have hader0 : derivative a = 0 := by
    rw [hdder0, mul_zero, sub_zero, mul_eq_zero] at hzero
    exact hzero.resolve_right hd0
  exact ⟨a.coeff 0, D, eq_C_of_derivative_eq_zero hader0,
    hDd.symm⟩

/-- Once the no-pole-at-infinity degree inequality is supplied, the finite
regularity theorem forces the invariant differential to vanish, hence all
homogeneous coordinates are constant. -/
lemma homogeneous_split_coordinates_constant_of_degree_bound [CharZero k]
    {a b d : k[X]} (had : IsCoprime a d) (hd0 : d ≠ 0)
    {e₁ e₂ e₃ : k}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
      (a - C e₃ * d ^ 2) = b ^ 2)
    (hdeg : (derivative a * d - (2 : k[X]) * a * derivative d).natDegree <
      b.natDegree) :
    ∃ A B D : k, a = C A ∧ b = C B ∧ d = C D := by
  have hdvd := homogeneous_split_invariant_numerator_dvd had h12 h13 h23 heq
  have hzero : derivative a * d - (2 : k[X]) * a * derivative d = 0 :=
    eq_zero_of_dvd_of_natDegree_lt hdvd hdeg
  obtain ⟨A, D, ha, hd⟩ :=
    invariant_numerator_zero_implies_constants had hd0 hzero
  have hbsqdeg : (b ^ 2).natDegree = 0 := by
    rw [← heq, ha, hd]
    simp only [← C_pow, ← C_mul, ← C_sub, natDegree_C]
  rw [natDegree_pow] at hbsqdeg
  have hbdeg : b.natDegree = 0 := by omega
  exact ⟨A, b.coeff 0, D, ha, eq_C_of_natDegree_eq_zero hbdeg, hd⟩

/-- The full homogeneous polynomial form of elliptic constancy.  The degree
alternative above supplies the point at infinity, so no separate genus or
Mason--Stothers input is needed. -/
lemma homogeneous_split_coordinates_constant [CharZero k]
    {a b d : k[X]} (had : IsCoprime a d) (hd0 : d ≠ 0)
    {e₁ e₂ e₃ : k}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
      (a - C e₃ * d ^ 2) = b ^ 2) :
    ∃ A B D : k, a = C A ∧ b = C B ∧ d = C D := by
  let N := derivative a * d - (2 : k[X]) * a * derivative d
  have finish (hzero : N = 0) :
      ∃ A B D : k, a = C A ∧ b = C B ∧ d = C D := by
    obtain ⟨A, D, ha, hd⟩ :=
      invariant_numerator_zero_implies_constants had hd0 hzero
    have hbsqdeg : (b ^ 2).natDegree = 0 := by
      rw [← heq, ha, hd]
      simp only [← C_pow, ← C_mul, ← C_sub, natDegree_C]
    rw [natDegree_pow] at hbsqdeg
    have hbdeg : b.natDegree = 0 := by omega
    exact ⟨A, b.coeff 0, D, ha, eq_C_of_natDegree_eq_zero hbdeg, hd⟩
  rcases homogeneous_split_invariant_zero_or_degree_lt hd0 h12 h13 h23 heq with
    hzero | hdeg
  · exact finish hzero
  · apply finish
    exact eq_zero_of_dvd_of_natDegree_lt
      (homogeneous_split_invariant_numerator_dvd had h12 h13 h23 heq) hdeg

/-- A rational-function point is constant as soon as it is put in primitive
weighted homogeneous coordinates.  Thus the only remaining bridge from raw
`RatFunc` coordinates is the standard UFD normalization
`x = a/d²`, `y = b/d³`, `IsCoprime a d`. -/
lemma ratfunc_xy_constant_of_split_homogeneous_coordinates [CharZero k]
    {x y : RatFunc k} {e₁ e₂ e₃ : k}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (hcoords : ∃ a b d : k[X], IsCoprime a d ∧ d ≠ 0 ∧
      x = algebraMap k[X] (RatFunc k) a /
        algebraMap k[X] (RatFunc k) (d ^ 2) ∧
      y = algebraMap k[X] (RatFunc k) b /
        algebraMap k[X] (RatFunc k) (d ^ 3) ∧
      ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
        (a - C e₃ * d ^ 2) = b ^ 2) :
    ∃ X Y : k, x = RatFunc.C X ∧ y = RatFunc.C Y := by
  obtain ⟨a, b, d, had, hd0, hx, hy, heq⟩ := hcoords
  obtain ⟨A, B, D, ha, hb, hd⟩ :=
    homogeneous_split_coordinates_constant had hd0 h12 h13 h23 heq
  have hD0 : D ≠ 0 := by
    intro hD
    apply hd0
    rw [hd, hD, C_0]
  refine ⟨A / D ^ 2, B / D ^ 3, ?_, ?_⟩
  · rw [hx, ha, hd, map_pow, RatFunc.algebraMap_C, RatFunc.algebraMap_C,
      ← map_pow, ← map_div₀]
  · rw [hy, hb, hd, map_pow, RatFunc.algebraMap_C, RatFunc.algebraMap_C,
      ← map_pow, ← map_div₀]

/-- Reduction of raw rational coordinates to the single denominator-root
statement.  This packages all remaining fraction-field bookkeeping. -/
lemma ratfunc_xy_constant_of_common_denominator_powers [CharZero k]
    {x y : RatFunc k} {e₁ e₂ e₃ : k}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((x - RatFunc.C e₁) * (x - RatFunc.C e₂)) *
      (x - RatFunc.C e₃) = y ^ 2)
    (hden : ∃ d : k[X], d ≠ 0 ∧ x.denom = d ^ 2 ∧ y.denom = d ^ 3) :
    ∃ X Y : k, x = RatFunc.C X ∧ y = RatFunc.C Y := by
  obtain ⟨d, hd0, hxd, hyd⟩ := hden
  let a := x.num
  let b := y.num
  have had : IsCoprime a d := by
    have h := x.isCoprime_num_denom
    rw [hxd, IsCoprime.pow_right_iff (by decide)] at h
    exact h
  have hx : x = algebraMap k[X] (RatFunc k) a /
      algebraMap k[X] (RatFunc k) (d ^ 2) := by
    rw [← x.num_div_denom, hxd]
  have hy : y = algebraMap k[X] (RatFunc k) b /
      algebraMap k[X] (RatFunc k) (d ^ 3) := by
    rw [← y.num_div_denom, hyd]
  have hdmap : algebraMap k[X] (RatFunc k) d ≠ 0 :=
    (map_ne_zero_iff _ (IsFractionRing.injective k[X] (RatFunc k))).mpr hd0
  have hpoly : ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
      (a - C e₃ * d ^ 2) = b ^ 2 := by
    apply IsFractionRing.injective k[X] (RatFunc k)
    have h := heq
    rw [hx, hy] at h
    field_simp [hdmap] at h
    apply mul_right_cancel₀
      (b := (algebraMap k[X] (RatFunc k) d) ^ 6) (pow_ne_zero _ hdmap)
    simp only [map_mul, map_sub, map_pow, RatFunc.algebraMap_C] at h ⊢
    convert h using 1 <;> ring
  apply ratfunc_xy_constant_of_split_homogeneous_coordinates h12 h13 h23
  exact ⟨a, b, d, had, hd0, hx, hy, hpoly⟩

omit [IsAlgClosed k] in
lemma ratfunc_denom_pow (z : RatFunc k) (n : ℕ) :
    (z ^ n).denom = z.denom ^ n := by
  classical
  have hq0 : z.denom ^ n ≠ 0 := pow_ne_zero _ z.denom_ne_zero
  have hcop : IsCoprime (z.num ^ n) (z.denom ^ n) := z.isCoprime_num_denom.pow
  have hgunit : IsUnit (gcd (z.num ^ n) (z.denom ^ n)) :=
    (gcd_isUnit_iff _ _).mpr hcop
  have hgmonic : (gcd (z.num ^ n) (z.denom ^ n)).Monic := by
    rw [← normalize_gcd]
    exact monic_normalize (gcd_ne_zero_of_right hq0)
  have hg : gcd (z.num ^ n) (z.denom ^ n) = 1 :=
    hgmonic.eq_one_of_isUnit hgunit
  have hzpow : z ^ n = algebraMap k[X] (RatFunc k) (z.num ^ n) /
      algebraMap k[X] (RatFunc k) (z.denom ^ n) := by
    calc
      z ^ n = (algebraMap k[X] (RatFunc k) z.num /
          algebraMap k[X] (RatFunc k) z.denom) ^ n := by rw [z.num_div_denom]
      _ = algebraMap k[X] (RatFunc k) (z.num ^ n) /
          algebraMap k[X] (RatFunc k) (z.denom ^ n) := by
            rw [div_pow, map_pow, map_pow]
  rw [hzpow, RatFunc.denom_div _ hq0, hg]
  simp [z.monic_denom.pow]

omit [IsAlgClosed k] in
lemma ratfunc_denom_div_of_coprime_monic
    {p q : k[X]} (hpq : IsCoprime p q) (hq : q.Monic) :
    (algebraMap k[X] (RatFunc k) p / algebraMap k[X] (RatFunc k) q).denom = q := by
  classical
  have hq0 : q ≠ 0 := hq.ne_zero
  have hgunit : IsUnit (gcd p q) := (gcd_isUnit_iff _ _).mpr hpq
  have hgmonic : (gcd p q).Monic := by
    rw [← normalize_gcd]
    exact monic_normalize (gcd_ne_zero_of_right hq0)
  have hg : gcd p q = 1 := hgmonic.eq_one_of_isUnit hgunit
  rw [RatFunc.denom_div _ hq0, hg]
  simp [hq.leadingCoeff]

omit [IsAlgClosed k] in
lemma isCoprime_sub_C_mul
    {a d : k[X]} (had : IsCoprime a d) (e : k) :
    IsCoprime (a - C e * d) d := by
  obtain ⟨u, v, huv⟩ := had
  refine ⟨u, v + u * C e, ?_⟩
  calc
    u * (a - C e * d) + (v + u * C e) * d = u * a + v * d := by ring
    _ = 1 := huv

omit [IsAlgClosed k] in
lemma exists_common_root_of_cube_eq_square
    {D E : k[X]} (hD0 : D ≠ 0) (h : D ^ 3 = E ^ 2) :
    ∃ d : k[X], D = d ^ 2 ∧ E = d ^ 3 := by
  have hD2dvdE2 : D ^ 2 ∣ E ^ 2 := by
    refine ⟨D, ?_⟩
    rw [← h]
    ring
  have hDdvdE : D ∣ E :=
    (IsIntegrallyClosed.pow_dvd_pow_iff (n := 2) (by decide)).mp hD2dvdE2
  obtain ⟨d, hEd⟩ := hDdvdE
  have hD : D = d ^ 2 := by
    apply mul_left_cancel₀ (pow_ne_zero 2 hD0)
    calc
      D ^ 2 * D = D ^ 3 := by ring
      _ = E ^ 2 := h
      _ = D ^ 2 * d ^ 2 := by rw [hEd]; ring
  refine ⟨d, hD, ?_⟩
  rw [hEd, hD]
  ring

omit [IsAlgClosed k] in
lemma common_denominator_powers_of_split_ratfunc_equation
    {x y : RatFunc k} {e₁ e₂ e₃ : k}
    (heq : ((x - RatFunc.C e₁) * (x - RatFunc.C e₂)) *
      (x - RatFunc.C e₃) = y ^ 2) :
    ∃ d : k[X], d ≠ 0 ∧ x.denom = d ^ 2 ∧ y.denom = d ^ 3 := by
  let A := x.num
  let D := x.denom
  let E := y.denom
  let p₁ := A - C e₁ * D
  let p₂ := A - C e₂ * D
  let p₃ := A - C e₃ * D
  have hD0 : D ≠ 0 := x.denom_ne_zero
  have hDmap : algebraMap k[X] (RatFunc k) D ≠ 0 :=
    (map_ne_zero_iff _ (IsFractionRing.injective k[X] (RatFunc k))).mpr hD0
  have hxmul : x * algebraMap k[X] (RatFunc k) D =
      algebraMap k[X] (RatFunc k) A := by
    rw [← x.num_div_denom]
    exact div_mul_cancel₀ _ hDmap
  have factor_rep (e : k) : x - RatFunc.C e =
      algebraMap k[X] (RatFunc k) (A - C e * D) /
        algebraMap k[X] (RatFunc k) D := by
    rw [eq_div_iff hDmap, sub_mul, hxmul, map_sub, map_mul,
      RatFunc.algebraMap_C]
  have hp₁D : IsCoprime p₁ D := by
    exact isCoprime_sub_C_mul x.isCoprime_num_denom e₁
  have hp₂D : IsCoprime p₂ D := by
    exact isCoprime_sub_C_mul x.isCoprime_num_denom e₂
  have hp₃D : IsCoprime p₃ D := by
    exact isCoprime_sub_C_mul x.isCoprime_num_denom e₃
  have hpD : IsCoprime (p₁ * p₂ * p₃) (D ^ 3) :=
    (hp₁D.mul_left hp₂D |>.mul_left hp₃D).pow_right
  have hprod : ((x - RatFunc.C e₁) * (x - RatFunc.C e₂)) *
      (x - RatFunc.C e₃) =
      algebraMap k[X] (RatFunc k) (p₁ * p₂ * p₃) /
        algebraMap k[X] (RatFunc k) (D ^ 3) := by
    rw [factor_rep e₁, factor_rep e₂, factor_rep e₃]
    simp only [map_mul, map_pow]
    field_simp [hDmap]
    ring
  have hprodDen : (((x - RatFunc.C e₁) * (x - RatFunc.C e₂)) *
      (x - RatFunc.C e₃)).denom = D ^ 3 := by
    rw [hprod]
    exact ratfunc_denom_div_of_coprime_monic hpD (x.monic_denom.pow 3)
  have hDE : D ^ 3 = E ^ 2 := by
    have h := congrArg RatFunc.denom heq
    rw [hprodDen, ratfunc_denom_pow y 2] at h
    exact h
  obtain ⟨d, hDd, hEd⟩ := exists_common_root_of_cube_eq_square hD0 hDE
  exact ⟨d, fun hd ↦ hD0 (by rw [hDd, hd, zero_pow (by decide)]), hDd, hEd⟩

/-- Every rational-function point on a split smooth cubic in characteristic
zero is constant. -/
lemma ratfunc_xy_constant_of_split_cubic_square [CharZero k]
    {x y : RatFunc k} {e₁ e₂ e₃ : k}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((x - RatFunc.C e₁) * (x - RatFunc.C e₂)) *
      (x - RatFunc.C e₃) = y ^ 2) :
    ∃ X Y : k, x = RatFunc.C X ∧ y = RatFunc.C Y := by
  apply ratfunc_xy_constant_of_common_denominator_powers h12 h13 h23 heq
  exact common_denominator_powers_of_split_ratfunc_equation heq

/-- Every affine `RatFunc` point on a short Weierstrass elliptic curve over an
algebraically closed characteristic-zero field is constant. -/
public lemma ratfunc_xy_constant_of_short_weierstrass [CharZero k]
    (W : WeierstrassCurve k) [W.IsShortNF] [W.IsElliptic]
    {x y : RatFunc k}
    (heq : y ^ 2 = x ^ 3 + RatFunc.C W.a₄ * x + RatFunc.C W.a₆) :
    ∃ X Y : k, x = RatFunc.C X ∧ y = RatFunc.C Y := by
  let P : Cubic k := ⟨1, 0, W.a₄, W.a₆⟩
  have hsplit : (P.toPoly.map (RingHom.id k)).Splits := by
    simpa using IsAlgClosed.splits P.toPoly
  obtain ⟨e₁, e₂, e₃, hroots⟩ :=
    (Cubic.splits_iff_roots_eq_three (P := P) (φ := RingHom.id k) (by simp [P])).mp hsplit
  have hdisc : P.discr ≠ 0 := by
    intro hzero
    have hsum : 4 * W.a₄ ^ 3 + 27 * W.a₆ ^ 2 = 0 := by
      dsimp [P, Cubic.discr] at hzero
      linear_combination -hzero
    have hDelta : W.Δ = 0 := by rw [W.Δ_of_isShortNF, hsum, mul_zero]
    exact (W.coe_Δ' ▸ W.Δ'.ne_zero) hDelta
  obtain ⟨h12, h13, h23⟩ :=
    (Cubic.discr_ne_zero_iff_roots_ne (P := P) (φ := RingHom.id k)
      (by simp [P]) hroots).mp hdisc
  have hfacPoly := Cubic.eq_prod_three_roots (P := P) (φ := RingHom.id k)
    (by simp [P]) hroots
  have hfac : ((x - RatFunc.C e₁) * (x - RatFunc.C e₂)) *
      (x - RatFunc.C e₃) = x ^ 3 + RatFunc.C W.a₄ * x + RatFunc.C W.a₆ := by
    have h := congrArg (Polynomial.eval₂ RatFunc.C x) hfacPoly
    simpa [P, Cubic.map, Cubic.toPoly] using h.symm
  apply ratfunc_xy_constant_of_split_cubic_square h12 h13 h23
  rw [hfac, ← heq]

public lemma ratfunc_coordinates_constant_of_short_weierstrass_equation [CharZero k]
    (W : WeierstrassCurve k) [W.IsShortNF] [W.IsElliptic]
    {x y : RatFunc k}
    (heq : (W.baseChange (RatFunc k)).toAffine.Equation x y) :
    ∃ X Y : k, x = RatFunc.C X ∧ y = RatFunc.C Y := by
  apply ratfunc_xy_constant_of_short_weierstrass W
  rw [WeierstrassCurve.Affine.equation_iff] at heq
  simpa using heq

/-- The point-level form needed for constancy of rational maps: base change
from the constant field to the one-variable rational function field is
surjective on affine Weierstrass points (including the point at infinity). -/
public lemma short_weierstrass_point_baseChange_ratfunc_surjective [CharZero k]
    [DecidableEq k] [DecidableEq (RatFunc k)]
    (W : WeierstrassCurve k) [W.IsShortNF] [W.IsElliptic] :
    Function.Surjective
      (WeierstrassCurve.Affine.Point.baseChange (W' := W.toAffine) k (RatFunc k)) := by
  classical
  intro P
  rcases P with _ | ⟨x, y, hxy⟩
  · exact ⟨0, rfl⟩
  · obtain ⟨X, Y, hx, hy⟩ :=
      ratfunc_coordinates_constant_of_short_weierstrass_equation W hxy.1
    subst x
    subst y
    have hXY0 : W.toAffine.Nonsingular X Y := by
      apply (W.toAffine.baseChange_nonsingular
        (f := Algebra.ofId k (RatFunc k)) (Algebra.ofId k (RatFunc k)).injective X Y).mp
      simpa using hxy
    have hXY : (W.toAffine.baseChange k).Nonsingular X Y :=
      (W.toAffine.baseChange_nonsingular
        (f := Algebra.ofId k k) (Algebra.ofId k k).injective X Y).mpr hXY0
    refine ⟨WeierstrassCurve.Affine.Point.some X Y hXY, ?_⟩
    rfl

lemma polynomial_x_constant_of_split_cubic_square [CharZero k]
    {x y : k[X]} {e₁ e₂ e₃ : k}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((x - C e₁) * (x - C e₂)) * (x - C e₃) = y ^ 2) :
    ∃ a : k, x = C a := by
  have hc12 := isCoprime_sub_C_sub_C (x := x) h12
  have hc13 := isCoprime_sub_C_sub_C (x := x) h13
  have hc23 := isCoprime_sub_C_sub_C (x := x) h23
  have hs1 : IsSquare (x - C e₁) := by
    apply isSquare_left_of_coprime_mul_eq_square (hc12.mul_right hc13)
    simpa only [mul_assoc] using heq
  have hs2 : IsSquare (x - C e₂) := by
    apply isSquare_left_of_coprime_mul_eq_square (hc12.symm.mul_right hc23)
    calc
      (x - C e₂) * ((x - C e₁) * (x - C e₃)) =
          ((x - C e₁) * (x - C e₂)) * (x - C e₃) := by ring
      _ = y ^ 2 := heq
  obtain ⟨p, hp⟩ := hs1.exists_sq
  obtain ⟨q, hq⟩ := hs2.exists_sq
  have hprod : (p - q) * (p + q) = C (e₂ - e₁) := by
    calc
      (p - q) * (p + q) = p ^ 2 - q ^ 2 := by ring
      _ = (x - C e₁) - (x - C e₂) := by rw [← hp, ← hq]
      _ = C (e₂ - e₁) := by rw [sub_sub_sub_cancel_left, ← C_sub]
  have hprod_unit : IsUnit ((p - q) * (p + q)) := by
    rw [hprod, Polynomial.isUnit_C]
    exact (sub_ne_zero.mpr h12.symm).isUnit
  have hminus : p - q = C ((p - q).coeff 0) :=
    eq_C_of_natDegree_eq_zero
      (Polynomial.natDegree_eq_zero_of_isUnit (IsUnit.mul_iff.mp hprod_unit).1)
  have hplus : p + q = C ((p + q).coeff 0) :=
    eq_C_of_natDegree_eq_zero
      (Polynomial.natDegree_eq_zero_of_isUnit (IsUnit.mul_iff.mp hprod_unit).2)
  let c : k := ((p - q).coeff 0 + (p + q).coeff 0) * (2 : k)⁻¹
  have hpC : p = C c := by
    dsimp only [c]
    rw [map_mul, C_add, ← hminus, ← hplus]
    have hsum : (p - q) + (p + q) = C (2 : k) * p := by
      simp only [map_ofNat]
      ring
    rw [hsum, mul_comm (C (2 : k)) p, mul_assoc, ← map_mul]
    simp
  refine ⟨e₁ + c ^ 2, ?_⟩
  calc
    x = (x - C e₁) + C e₁ := by ring
    _ = p ^ 2 + C e₁ := by rw [hp]
    _ = C (e₁ + c ^ 2) := by
      rw [hpC]
      rw [← map_pow, ← C_add]
      congr 1
      ring

lemma polynomial_xy_constant_of_split_cubic_square [CharZero k]
    {x y : k[X]} {e₁ e₂ e₃ : k}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((x - C e₁) * (x - C e₂)) * (x - C e₃) = y ^ 2) :
    ∃ a b : k, x = C a ∧ y = C b := by
  obtain ⟨a, hx⟩ := polynomial_x_constant_of_split_cubic_square h12 h13 h23 heq
  have hydeg : (y ^ 2).natDegree = 0 := by
    rw [← heq, hx]
    simp only [← C_sub, ← C_mul, natDegree_C]
  rw [natDegree_pow] at hydeg
  have hydeg0 : y.natDegree = 0 := by omega
  obtain ⟨b, hb⟩ := natDegree_eq_zero.mp hydeg0
  exact ⟨a, b, hx, hb.symm⟩

lemma polynomial_xy_constant_of_short_weierstrass [CharZero k]
    (W : WeierstrassCurve k) [W.IsShortNF] [W.IsElliptic]
    {x y : k[X]}
    (heq : y ^ 2 = x ^ 3 + C W.a₄ * x + C W.a₆) :
    ∃ a b : k, x = C a ∧ y = C b := by
  let P : Cubic k := ⟨1, 0, W.a₄, W.a₆⟩
  have hsplit : (P.toPoly.map (RingHom.id k)).Splits := by
    simpa using IsAlgClosed.splits P.toPoly
  obtain ⟨e₁, e₂, e₃, hroots⟩ :=
    (Cubic.splits_iff_roots_eq_three (P := P) (φ := RingHom.id k) (by simp [P])).mp hsplit
  have hdisc : P.discr ≠ 0 := by
    intro hzero
    have hsum : 4 * W.a₄ ^ 3 + 27 * W.a₆ ^ 2 = 0 := by
      dsimp [P, Cubic.discr] at hzero
      linear_combination -hzero
    have hDelta : W.Δ = 0 := by rw [W.Δ_of_isShortNF, hsum, mul_zero]
    exact (W.coe_Δ' ▸ W.Δ'.ne_zero) hDelta
  obtain ⟨h12, h13, h23⟩ :=
    (Cubic.discr_ne_zero_iff_roots_ne (P := P) (φ := RingHom.id k)
      (by simp [P]) hroots).mp hdisc
  have hfacPoly := Cubic.eq_prod_three_roots (P := P) (φ := RingHom.id k)
    (by simp [P]) hroots
  have hfac : ((x - C e₁) * (x - C e₂)) * (x - C e₃) =
      x ^ 3 + C W.a₄ * x + C W.a₆ := by
    have h := congrArg (Polynomial.eval₂ C x) hfacPoly
    simpa [P, Cubic.map, Cubic.toPoly] using h.symm
  apply polynomial_xy_constant_of_split_cubic_square h12 h13 h23
  rw [hfac, ← heq]

lemma polynomial_coordinates_constant_of_short_weierstrass_equation [CharZero k]
    (W : WeierstrassCurve k) [W.IsShortNF] [W.IsElliptic]
    {x y : k[X]} (heq : (W.baseChange k[X]).toAffine.Equation x y) :
    ∃ a b : k, x = C a ∧ y = C b := by
  apply polynomial_xy_constant_of_short_weierstrass W
  rw [WeierstrassCurve.Affine.equation_iff] at heq
  simpa using heq

section ArbitraryField

variable {F : Type*} [Field F] [CharZero F]

/-- Over an arbitrary field the three coprime split factors need only be
associated to squares: their unit factors need not themselves be squares. -/
lemma homogeneous_split_factors_are_associated_squares
    {a b d : F[X]} (had : IsCoprime a d) {e₁ e₂ e₃ : F}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
      (a - C e₃ * d ^ 2) = b ^ 2) :
    (∃ p₁ : F[X], Associated (p₁ ^ 2) (a - C e₁ * d ^ 2)) ∧
      (∃ p₂ : F[X], Associated (p₂ ^ 2) (a - C e₂ * d ^ 2)) ∧
      (∃ p₃ : F[X], Associated (p₃ ^ 2) (a - C e₃ * d ^ 2)) := by
  have hc12 := isCoprime_homogeneous_split_factors had h12
  have hc13 := isCoprime_homogeneous_split_factors had h13
  have hc23 := isCoprime_homogeneous_split_factors had h23
  constructor
  · exact exists_associated_pow_of_mul_eq_pow' (hc12.mul_right hc13)
      (by simpa only [mul_assoc] using heq)
  constructor
  · apply exists_associated_pow_of_mul_eq_pow' (hc12.symm.mul_right hc23)
    calc
      (a - C e₂ * d ^ 2) *
          ((a - C e₁ * d ^ 2) * (a - C e₃ * d ^ 2)) =
          ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
            (a - C e₃ * d ^ 2) := by ring
      _ = b ^ 2 := heq
  · apply exists_associated_pow_of_mul_eq_pow'
      (hc13.symm.mul_right hc23.symm)
    calc
      (a - C e₃ * d ^ 2) *
          ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) =
          ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
            (a - C e₃ * d ^ 2) := by ring
      _ = b ^ 2 := heq

lemma associated_square_root_dvd_invariant_numerator
    {a d p : F[X]} {e : F}
    (hp : Associated (p ^ 2) (a - C e * d ^ 2)) :
    p ∣ derivative a * d - (2 : F[X]) * a * derivative d := by
  obtain ⟨u, hu⟩ := hp
  obtain ⟨r, -, hr⟩ := Polynomial.isUnit_iff.mp u.isUnit
  refine ⟨C r * ((2 : F[X]) * (derivative p * d - p * derivative d)), ?_⟩
  calc
    derivative a * d - (2 : F[X]) * a * derivative d =
        derivative (a - C e * d ^ 2) * d -
          (2 : F[X]) * (a - C e * d ^ 2) * derivative d :=
      invariant_numerator_rewrite_by_factor
    _ = derivative (p ^ 2 * C r) * d -
          (2 : F[X]) * (p ^ 2 * C r) * derivative d := by
      rw [hu.symm, ← hr]
    _ = p * (C r * ((2 : F[X]) *
          (derivative p * d - p * derivative d))) := by
      simp only [derivative_mul, derivative_pow, derivative_C, mul_zero,
        add_zero, C_eq_natCast]
      ring

lemma associated_square_roots_coprime
    {f g p q : F[X]} (hfg : IsCoprime f g)
    (hp : Associated (p ^ 2) f) (hq : Associated (q ^ 2) g) :
    IsCoprime p q := by
  obtain ⟨a, b, hab⟩ := hfg
  obtain ⟨u, hu⟩ := hp
  obtain ⟨v, hv⟩ := hq
  apply (IsCoprime.pow_iff (m := 2) (n := 2) (by decide) (by decide)).mp
  refine ⟨a * u, b * v, ?_⟩
  calc
    (a * (u : F[X])) * p ^ 2 + (b * (v : F[X])) * q ^ 2 =
        a * (p ^ 2 * u) + b * (q ^ 2 * v) := by ring
    _ = a * f + b * g := by rw [hu, hv]
    _ = 1 := hab

lemma homogeneous_split_invariant_numerator_dvd_over_field
    {a b d : F[X]} (had : IsCoprime a d) {e₁ e₂ e₃ : F}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
      (a - C e₃ * d ^ 2) = b ^ 2) :
    b ∣ derivative a * d - (2 : F[X]) * a * derivative d := by
  obtain ⟨⟨p₁, hp₁⟩, ⟨p₂, hp₂⟩, ⟨p₃, hp₃⟩⟩ :=
    homogeneous_split_factors_are_associated_squares had h12 h13 h23 heq
  have hc12 := isCoprime_homogeneous_split_factors had h12
  have hc13 := isCoprime_homogeneous_split_factors had h13
  have hc23 := isCoprime_homogeneous_split_factors had h23
  have hp12 : IsCoprime p₁ p₂ := associated_square_roots_coprime hc12 hp₁ hp₂
  have hp13 : IsCoprime p₁ p₃ := associated_square_roots_coprime hc13 hp₁ hp₃
  have hp23 : IsCoprime p₂ p₃ := associated_square_roots_coprime hc23 hp₂ hp₃
  have hd₁ := associated_square_root_dvd_invariant_numerator hp₁
  have hd₂ := associated_square_root_dvd_invariant_numerator hp₂
  have hd₃ := associated_square_root_dvd_invariant_numerator hp₃
  have hprod : p₁ * p₂ * p₃ ∣
      derivative a * d - (2 : F[X]) * a * derivative d :=
    (hp13.mul_left hp23).mul_dvd (hp12.mul_dvd hd₁ hd₂) hd₃
  have hassoc : Associated ((p₁ * p₂ * p₃) ^ 2) (b ^ 2) := by
    have hpall := (hp₁.mul_mul hp₂).mul_mul hp₃
    have hpall' : Associated ((p₁ * p₂ * p₃) ^ 2)
        (((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
          (a - C e₃ * d ^ 2)) := by
      rw [show (p₁ * p₂ * p₃) ^ 2 = p₁ ^ 2 * p₂ ^ 2 * p₃ ^ 2 by ring]
      exact hpall
    exact hpall'.trans (Associated.of_eq heq)
  have hbprod : b ∣ p₁ * p₂ * p₃ :=
    (IsIntegrallyClosed.pow_dvd_pow_iff (n := 2) (by decide)).mp hassoc.dvd'
  exact hbprod.trans hprod

lemma homogeneous_split_coordinates_constant_over_field
    {a b d : F[X]} (had : IsCoprime a d) (hd0 : d ≠ 0)
    {e₁ e₂ e₃ : F}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
      (a - C e₃ * d ^ 2) = b ^ 2) :
    ∃ A B D : F, a = C A ∧ b = C B ∧ d = C D := by
  let N := derivative a * d - (2 : F[X]) * a * derivative d
  have finish (hzero : N = 0) :
      ∃ A B D : F, a = C A ∧ b = C B ∧ d = C D := by
    obtain ⟨A, D, ha, hd⟩ :=
      invariant_numerator_zero_implies_constants had hd0 hzero
    have hbsqdeg : (b ^ 2).natDegree = 0 := by
      rw [← heq, ha, hd]
      simp only [← C_pow, ← C_mul, ← C_sub, natDegree_C]
    rw [natDegree_pow] at hbsqdeg
    have hbdeg : b.natDegree = 0 := by omega
    exact ⟨A, b.coeff 0, D, ha, eq_C_of_natDegree_eq_zero hbdeg, hd⟩
  rcases homogeneous_split_invariant_zero_or_degree_lt hd0 h12 h13 h23 heq with
    hzero | hdeg
  · exact finish hzero
  · apply finish
    exact eq_zero_of_dvd_of_natDegree_lt
      (homogeneous_split_invariant_numerator_dvd_over_field had h12 h13 h23 heq) hdeg

public lemma ratfunc_xy_constant_of_split_cubic_square_over_field
    {x y : RatFunc F} {e₁ e₂ e₃ : F}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    (heq : ((x - RatFunc.C e₁) * (x - RatFunc.C e₂)) *
      (x - RatFunc.C e₃) = y ^ 2) :
    ∃ X Y : F, x = RatFunc.C X ∧ y = RatFunc.C Y := by
  obtain ⟨d, hd0, hxd, hyd⟩ :=
    common_denominator_powers_of_split_ratfunc_equation heq
  let a := x.num
  let b := y.num
  have had : IsCoprime a d := by
    have h := x.isCoprime_num_denom
    rw [hxd, IsCoprime.pow_right_iff (by decide)] at h
    exact h
  have hx : x = algebraMap F[X] (RatFunc F) a /
      algebraMap F[X] (RatFunc F) (d ^ 2) := by
    rw [← x.num_div_denom, hxd]
  have hy : y = algebraMap F[X] (RatFunc F) b /
      algebraMap F[X] (RatFunc F) (d ^ 3) := by
    rw [← y.num_div_denom, hyd]
  have hdmap : algebraMap F[X] (RatFunc F) d ≠ 0 :=
    (map_ne_zero_iff _ (IsFractionRing.injective F[X] (RatFunc F))).mpr hd0
  have hpoly : ((a - C e₁ * d ^ 2) * (a - C e₂ * d ^ 2)) *
      (a - C e₃ * d ^ 2) = b ^ 2 := by
    apply IsFractionRing.injective F[X] (RatFunc F)
    have h := heq
    rw [hx, hy] at h
    field_simp [hdmap] at h
    apply mul_right_cancel₀
      (b := (algebraMap F[X] (RatFunc F) d) ^ 6) (pow_ne_zero _ hdmap)
    simp only [map_mul, map_sub, map_pow, RatFunc.algebraMap_C] at h ⊢
    convert h using 1 <;> ring
  obtain ⟨A, B, D, ha, hb, hd⟩ :=
    homogeneous_split_coordinates_constant_over_field had hd0 h12 h13 h23 hpoly
  have hD0 : D ≠ 0 := by
    intro hD
    apply hd0
    rw [hd, hD, C_0]
  refine ⟨A / D ^ 2, B / D ^ 3, ?_, ?_⟩
  · rw [hx, ha, hd, map_pow, RatFunc.algebraMap_C, RatFunc.algebraMap_C,
      ← map_pow, ← map_div₀]
  · rw [hy, hb, hd, map_pow, RatFunc.algebraMap_C, RatFunc.algebraMap_C,
      ← map_pow, ← map_div₀]

/-- The boundary exponent pattern needed after parametrizing one of the two
quadrics in the homogeneous elliptic equation. -/
lemma quartic_quartic_square_mason
    {a b c : F[X]} (ha : a ≠ 0) (hb : b ≠ 0) (hc : c ≠ 0)
    (hab : IsCoprime a b) {u v w : F}
    (hu : u ≠ 0) (hv : v ≠ 0) (hw : w ≠ 0)
    (heq : C u * a ^ 4 + C v * b ^ 4 + C w * c ^ 2 = 0) :
    a.natDegree = 0 ∧ b.natDegree = 0 ∧ c.natDegree = 0 := by
  apply Polynomial.flt_catalan (p := 4) (q := 4) (r := 2)
    (by decide) (by decide) (by decide) (by norm_num)
    (by norm_num) (by norm_num) (by norm_num)
    ha hb hc hab hu hv hw heq

public lemma polynomial_xy_constant_of_short_weierstrass_over_field
    (W : WeierstrassCurve F) [W.IsShortNF] [W.IsElliptic]
    {x y : F[X]}
    (heq : y ^ 2 = x ^ 3 + C W.a₄ * x + C W.a₆) :
    ∃ a b : F, x = C a ∧ y = C b := by
  let K := AlgebraicClosure F
  let f : F →+* K := algebraMap F K
  let W' : WeierstrassCurve K := W.map f
  letI : W'.IsShortNF := by
    constructor <;> simp [W', f]
  have heqK : (y.map f) ^ 2 =
      (x.map f) ^ 3 + C W'.a₄ * x.map f + C W'.a₆ := by
    have h := congrArg (Polynomial.map f) heq
    simpa [W', f] using h
  obtain ⟨a, b, hx, hy⟩ :=
    polynomial_xy_constant_of_short_weierstrass W' heqK
  have hxdegK : (x.map f).natDegree = 0 := by rw [hx, natDegree_C]
  have hydegK : (y.map f).natDegree = 0 := by rw [hy, natDegree_C]
  have hxdeg : x.natDegree = 0 := by
    rw [natDegree_map_eq_of_injective f.injective] at hxdegK
    exact hxdegK
  have hydeg : y.natDegree = 0 := by
    rw [natDegree_map_eq_of_injective f.injective] at hydegK
    exact hydegK
  exact ⟨x.coeff 0, y.coeff 0,
    eq_C_of_natDegree_eq_zero hxdeg, eq_C_of_natDegree_eq_zero hydeg⟩

/-- Once both rational coordinates have no finite poles, polynomial constancy
finishes the one-variable argument.  Ruling out poles is the genuinely hard
projective/genus step; properness alone only extends the map across them. -/
public lemma ratfunc_xy_constant_of_unit_denominators
    (W : WeierstrassCurve F) [W.IsShortNF] [W.IsElliptic]
    {x y : RatFunc F}
    (heq : y ^ 2 = x ^ 3 + RatFunc.C W.a₄ * x + RatFunc.C W.a₆)
    (hxden : IsUnit x.denom) (hyden : IsUnit y.denom) :
    ∃ a b : F, x = RatFunc.C a ∧ y = RatFunc.C b := by
  obtain ⟨p, hp⟩ := (RatFunc.denom_dvd (x := x) (q := (1 : F[X])) one_ne_zero).mp hxden.dvd
  obtain ⟨q, hq⟩ := (RatFunc.denom_dvd (x := y) (q := (1 : F[X])) one_ne_zero).mp hyden.dvd
  simp only [map_one, div_one] at hp hq
  have hpq : q ^ 2 = p ^ 3 + C W.a₄ * p + C W.a₆ := by
    apply IsFractionRing.injective F[X] (RatFunc F)
    simpa only [map_pow, map_add, map_mul, RatFunc.algebraMap_C] using
      (hp ▸ hq ▸ heq)
  obtain ⟨a, b, hpa, hqb⟩ :=
    polynomial_xy_constant_of_short_weierstrass_over_field W hpq
  exact ⟨a, b, by rw [hp, hpa, RatFunc.algebraMap_C],
    by rw [hq, hqb, RatFunc.algebraMap_C]⟩

end ArbitraryField

noncomputable section Multivariable

open MvPolynomial

variable {K : Type*} [Field K]

public abbrev MvFrac (K : Type*) [Field K] (n : ℕ) :=
  FractionRing (MvPolynomial (Fin n) K)

@[expose] public def mvSuccToRatFuncBase (n : ℕ) :
    MvPolynomial (Fin (n + 1)) K →+* RatFunc (MvFrac K n) :=
  (algebraMap (Polynomial (MvFrac K n)) (RatFunc (MvFrac K n))).comp
    ((Polynomial.mapRingHom
      (algebraMap (MvPolynomial (Fin n) K) (MvFrac K n))).comp
        (MvPolynomial.finSuccEquiv K n).toRingHom)

lemma mvSuccToRatFuncBase_injective (n : ℕ) :
    Function.Injective (mvSuccToRatFuncBase (K := K) n) :=
  (IsFractionRing.injective (Polynomial (MvFrac K n)) (RatFunc (MvFrac K n))).comp
    ((Polynomial.map_injective _
      (IsFractionRing.injective (MvPolynomial (Fin n) K) (MvFrac K n))).comp
        (MvPolynomial.finSuccEquiv K n).injective)

@[expose] public def mvSuccToRatFunc (n : ℕ) : MvFrac K (n + 1) →+* RatFunc (MvFrac K n) :=
  IsFractionRing.lift (mvSuccToRatFuncBase_injective (K := K) n)

@[simp] public lemma mvSuccToRatFunc_algebraMap (n : ℕ)
    (f : MvPolynomial (Fin (n + 1)) K) :
    mvSuccToRatFunc (K := K) n
        (algebraMap (MvPolynomial (Fin (n + 1)) K) (MvFrac K (n + 1)) f) =
      mvSuccToRatFuncBase (K := K) n f :=
  IsFractionRing.lift_algebraMap (mvSuccToRatFuncBase_injective (K := K) n) f

def mvTailRingHom (n : ℕ) :
    MvPolynomial (Fin n) K →+* MvPolynomial (Fin (n + 1)) K :=
  (MvPolynomial.finSuccEquiv K n).symm.toRingHom.comp Polynomial.C

lemma mvTailRingHom_injective (n : ℕ) :
    Function.Injective (mvTailRingHom (K := K) n) :=
  (MvPolynomial.finSuccEquiv K n).symm.injective.comp Polynomial.C_injective

@[expose] public def mvTailBase (n : ℕ) : MvPolynomial (Fin n) K →+* MvFrac K (n + 1) :=
  (algebraMap (MvPolynomial (Fin (n + 1)) K) (MvFrac K (n + 1))).comp
    (mvTailRingHom (K := K) n)

lemma mvTailBase_injective (n : ℕ) :
    Function.Injective (mvTailBase (K := K) n) :=
  (IsFractionRing.injective (MvPolynomial (Fin (n + 1)) K) (MvFrac K (n + 1))).comp
    (mvTailRingHom_injective (K := K) n)

@[expose] public def mvTailFrac (n : ℕ) : MvFrac K n →+* MvFrac K (n + 1) :=
  IsFractionRing.lift (mvTailBase_injective (K := K) n)

@[simp] public lemma mvTailFrac_algebraMap (n : ℕ)
    (f : MvPolynomial (Fin n) K) :
    mvTailFrac (K := K) n
        (algebraMap (MvPolynomial (Fin n) K) (MvFrac K n) f) =
      mvTailBase (K := K) n f :=
  IsFractionRing.lift_algebraMap (mvTailBase_injective (K := K) n) f

def mvLastVariable (n : ℕ) : MvFrac K (n + 1) :=
  algebraMap (MvPolynomial (Fin (n + 1)) K) (MvFrac K (n + 1)) (X 0)

@[expose] public def mvRatFuncBackBase (n : ℕ) :
    Polynomial (MvFrac K n) →+* MvFrac K (n + 1) :=
  Polynomial.eval₂RingHom (mvTailFrac (K := K) n) (mvLastVariable (K := K) n)

lemma mvSuccToRatFunc_comp_mvTailFrac (n : ℕ) :
    (mvSuccToRatFunc (K := K) n).comp (mvTailFrac (K := K) n) = RatFunc.C := by
  apply IsFractionRing.ringHom_ext (A := MvPolynomial (Fin n) K)
  intro f
  simp [mvTailBase, mvTailRingHom, mvSuccToRatFuncBase]

lemma mvSuccToRatFunc_mvLastVariable (n : ℕ) :
    mvSuccToRatFunc (K := K) n (mvLastVariable (K := K) n) =
      (RatFunc.X : RatFunc (MvFrac K n)) := by
  simp [mvLastVariable, mvSuccToRatFuncBase,
    MvPolynomial.finSuccEquiv_X_zero, RatFunc.algebraMap_X]

public lemma mvSuccToRatFunc_algebraMap_base (n : ℕ) (c : K) :
    mvSuccToRatFunc (K := K) n (algebraMap K (MvFrac K (n + 1)) c) =
      RatFunc.C (algebraMap K (MvFrac K n) c) := by
  rw [IsScalarTower.algebraMap_apply K (MvPolynomial (Fin (n + 1)) K)]
  rw [mvSuccToRatFunc_algebraMap]
  change (algebraMap (Polynomial (MvFrac K n)) (RatFunc (MvFrac K n)))
      (Polynomial.map (algebraMap (MvPolynomial (Fin n) K) (MvFrac K n))
        ((MvPolynomial.finSuccEquiv K n) (MvPolynomial.C c))) = _
  rw [show (MvPolynomial.finSuccEquiv K n) (MvPolynomial.C c) =
      Polynomial.C (MvPolynomial.C c) by
        exact (MvPolynomial.finSuccEquiv K n).commutes c]
  rw [Polynomial.map_C, RatFunc.algebraMap_C]
  congr 1

lemma mvSuccToRatFunc_comp_mvRatFuncBackBase (n : ℕ) :
    (mvSuccToRatFunc (K := K) n).comp (mvRatFuncBackBase (K := K) n) =
      algebraMap (Polynomial (MvFrac K n)) (RatFunc (MvFrac K n)) := by
  apply Polynomial.ringHom_ext
  · intro z
    simpa [mvRatFuncBackBase] using
      DFunLike.congr_fun (mvSuccToRatFunc_comp_mvTailFrac (K := K) n) z
  · simpa [mvRatFuncBackBase] using mvSuccToRatFunc_mvLastVariable (K := K) n

lemma mvRatFuncBackBase_injective (n : ℕ) :
    Function.Injective (mvRatFuncBackBase (K := K) n) := by
  intro p q hpq
  apply IsFractionRing.injective (Polynomial (MvFrac K n)) (RatFunc (MvFrac K n))
  have h := congrArg (mvSuccToRatFunc (K := K) n) hpq
  change ((mvSuccToRatFunc (K := K) n).comp
    (mvRatFuncBackBase (K := K) n)) p =
      ((mvSuccToRatFunc (K := K) n).comp
        (mvRatFuncBackBase (K := K) n)) q at h
  rw [mvSuccToRatFunc_comp_mvRatFuncBackBase] at h
  exact h

@[expose] public def mvRatFuncBack (n : ℕ) : RatFunc (MvFrac K n) →+* MvFrac K (n + 1) :=
  IsFractionRing.lift (mvRatFuncBackBase_injective (K := K) n)

@[simp] public lemma mvRatFuncBack_algebraMap (n : ℕ)
    (p : Polynomial (MvFrac K n)) :
    mvRatFuncBack (K := K) n
        (algebraMap (Polynomial (MvFrac K n)) (RatFunc (MvFrac K n)) p) =
      mvRatFuncBackBase (K := K) n p :=
  IsFractionRing.lift_algebraMap (mvRatFuncBackBase_injective (K := K) n) p

public lemma mvSuccToRatFunc_comp_mvRatFuncBack (n : ℕ) :
    (mvSuccToRatFunc (K := K) n).comp (mvRatFuncBack (K := K) n) =
      RingHom.id (RatFunc (MvFrac K n)) := by
  apply IsFractionRing.ringHom_ext (A := Polynomial (MvFrac K n))
  intro p
  rw [RingHom.comp_apply, mvRatFuncBack_algebraMap]
  change ((mvSuccToRatFunc (K := K) n).comp
    (mvRatFuncBackBase (K := K) n)) p = _
  rw [mvSuccToRatFunc_comp_mvRatFuncBackBase]
  rfl

@[expose] public def mvFractionSuccRingEquiv (n : ℕ) :
    MvFrac K (n + 1) ≃+* RatFunc (MvFrac K n) :=
  RingEquiv.ofBijective (mvSuccToRatFunc (K := K) n)
    ⟨RingHom.injective _, fun z ↦
      ⟨mvRatFuncBack (K := K) n z,
        DFunLike.congr_fun (mvSuccToRatFunc_comp_mvRatFuncBack (K := K) n) z⟩⟩

@[simp] public lemma mvFractionSuccRingEquiv_apply (n : ℕ) (z : MvFrac K (n + 1)) :
    mvFractionSuccRingEquiv (K := K) n z = mvSuccToRatFunc (K := K) n z := rfl

@[expose] public def mvFractionZeroAlgEquiv : MvFrac K 0 ≃ₐ[K] K :=
  IsFractionRing.algEquivOfAlgEquiv (MvPolynomial.isEmptyAlgEquiv K (Fin 0))

variable [CharZero K]

/-- Every solution of a fixed split smooth cubic over a finite-variable pure
transcendental extension descends to the ground field. -/
public theorem mvfrac_xy_constant_of_split_cubic_square
    (n : ℕ) {e₁ e₂ e₃ : K}
    (h12 : e₁ ≠ e₂) (h13 : e₁ ≠ e₃) (h23 : e₂ ≠ e₃)
    {x y : MvFrac K n}
    (heq : ((x - algebraMap K (MvFrac K n) e₁) *
        (x - algebraMap K (MvFrac K n) e₂)) *
        (x - algebraMap K (MvFrac K n) e₃) = y ^ 2) :
    ∃ X Y : K, x = algebraMap K (MvFrac K n) X ∧
      y = algebraMap K (MvFrac K n) Y := by
  induction n with
  | zero =>
      let φ := mvFractionZeroAlgEquiv (K := K)
      refine ⟨φ x, φ y, ?_, ?_⟩
      · apply φ.injective
        simp [φ]
      · apply φ.injective
        simp [φ]
  | succ n ih =>
      let φ := mvFractionSuccRingEquiv (K := K) n
      have heq' : ((φ x - RatFunc.C (algebraMap K (MvFrac K n) e₁)) *
          (φ x - RatFunc.C (algebraMap K (MvFrac K n) e₂))) *
          (φ x - RatFunc.C (algebraMap K (MvFrac K n) e₃)) =
          (φ y) ^ 2 := by
        have h := congrArg φ heq
        simpa only [map_mul, map_sub, map_pow, φ,
          mvFractionSuccRingEquiv_apply,
          mvSuccToRatFunc_algebraMap_base] using h
      obtain ⟨X, Y, hx, hy⟩ :=
        ratfunc_xy_constant_of_split_cubic_square_over_field
          ((algebraMap K (MvFrac K n)).injective.ne h12)
          ((algebraMap K (MvFrac K n)).injective.ne h13)
          ((algebraMap K (MvFrac K n)).injective.ne h23) heq'
      have heqLower :
          ((X - algebraMap K (MvFrac K n) e₁) *
            (X - algebraMap K (MvFrac K n) e₂)) *
            (X - algebraMap K (MvFrac K n) e₃) = Y ^ 2 := by
        apply RatFunc.C_injective
        simpa only [map_mul, map_sub, map_pow, hx, hy] using heq'
      obtain ⟨A, B, hXA, hYB⟩ := ih heqLower
      refine ⟨A, B, ?_, ?_⟩
      · apply φ.injective
        change mvSuccToRatFunc (K := K) n x =
          mvSuccToRatFunc (K := K) n (algebraMap K (MvFrac K (n + 1)) A)
        have hx' : mvSuccToRatFunc (K := K) n x = RatFunc.C X := by
          simpa only [φ, mvFractionSuccRingEquiv_apply] using hx
        rw [hx', hXA, mvSuccToRatFunc_algebraMap_base]
      · apply φ.injective
        change mvSuccToRatFunc (K := K) n y =
          mvSuccToRatFunc (K := K) n (algebraMap K (MvFrac K (n + 1)) B)
        have hy' : mvSuccToRatFunc (K := K) n y = RatFunc.C Y := by
          simpa only [φ, mvFractionSuccRingEquiv_apply] using hy
        rw [hy', hYB, mvSuccToRatFunc_algebraMap_base]

variable [IsAlgClosed K]

theorem mvfrac_xy_constant_of_short_weierstrass
    (n : ℕ) (W : WeierstrassCurve K) [W.IsShortNF] [W.IsElliptic]
    {x y : MvFrac K n}
    (heq : y ^ 2 = x ^ 3 + algebraMap K (MvFrac K n) W.a₄ * x +
      algebraMap K (MvFrac K n) W.a₆) :
    ∃ X Y : K, x = algebraMap K (MvFrac K n) X ∧
      y = algebraMap K (MvFrac K n) Y := by
  let P : Cubic K := ⟨1, 0, W.a₄, W.a₆⟩
  have hsplit : (P.toPoly.map (RingHom.id K)).Splits := by
    simpa using IsAlgClosed.splits P.toPoly
  obtain ⟨e₁, e₂, e₃, hroots⟩ :=
    (Cubic.splits_iff_roots_eq_three (P := P) (φ := RingHom.id K)
      (by simp [P])).mp hsplit
  have hdisc : P.discr ≠ 0 := by
    intro hzero
    have hsum : 4 * W.a₄ ^ 3 + 27 * W.a₆ ^ 2 = 0 := by
      dsimp [P, Cubic.discr] at hzero
      linear_combination -hzero
    have hDelta : W.Δ = 0 := by rw [W.Δ_of_isShortNF, hsum, mul_zero]
    exact (W.coe_Δ' ▸ W.Δ'.ne_zero) hDelta
  obtain ⟨h12, h13, h23⟩ :=
    (Cubic.discr_ne_zero_iff_roots_ne (P := P) (φ := RingHom.id K)
      (by simp [P]) hroots).mp hdisc
  have hfacPoly := Cubic.eq_prod_three_roots (P := P) (φ := RingHom.id K)
    (by simp [P]) hroots
  have hfac :
      ((x - algebraMap K (MvFrac K n) e₁) *
        (x - algebraMap K (MvFrac K n) e₂)) *
        (x - algebraMap K (MvFrac K n) e₃) =
      x ^ 3 + algebraMap K (MvFrac K n) W.a₄ * x +
        algebraMap K (MvFrac K n) W.a₆ := by
    have h := congrArg
      (Polynomial.eval₂ (algebraMap K (MvFrac K n)) x) hfacPoly
    simpa [P, Cubic.map, Cubic.toPoly] using h.symm
  apply mvfrac_xy_constant_of_split_cubic_square n h12 h13 h23
  rw [hfac, ← heq]

public theorem mvfrac_coordinates_constant_of_short_weierstrass_equation
    (n : ℕ) (W : WeierstrassCurve K) [W.IsShortNF] [W.IsElliptic]
    {x y : MvFrac K n}
    (heq : (W.baseChange (MvFrac K n)).toAffine.Equation x y) :
    ∃ X Y : K, x = algebraMap K (MvFrac K n) X ∧
      y = algebraMap K (MvFrac K n) Y := by
  apply mvfrac_xy_constant_of_short_weierstrass n W
  rw [WeierstrassCurve.Affine.equation_iff] at heq
  simpa using heq

public theorem short_weierstrass_point_baseChange_mvfrac_surjective
    [DecidableEq K] (n : ℕ) [DecidableEq (MvFrac K n)]
    (W : WeierstrassCurve K) [W.IsShortNF] [W.IsElliptic] :
    Function.Surjective
      (WeierstrassCurve.Affine.Point.baseChange
        (W' := W.toAffine) K (MvFrac K n)) := by
  classical
  intro Q
  rcases Q with _ | ⟨x, y, hxy⟩
  · exact ⟨0, rfl⟩
  · obtain ⟨X, Y, hx, hy⟩ :=
      mvfrac_coordinates_constant_of_short_weierstrass_equation n W hxy.1
    subst x
    subst y
    have hXY0 : W.toAffine.Nonsingular X Y := by
      apply (W.toAffine.baseChange_nonsingular
        (f := Algebra.ofId K (MvFrac K n))
        (Algebra.ofId K (MvFrac K n)).injective X Y).mp
      simpa using hxy
    have hXY : (W.toAffine.baseChange K).Nonsingular X Y :=
      (W.toAffine.baseChange_nonsingular
        (f := Algebra.ofId K K) (Algebra.ofId K K).injective X Y).mpr hXY0
    refine ⟨WeierstrassCurve.Affine.Point.some X Y hXY, ?_⟩
    rfl

/-- The exact pure-transcendental function field occurring on the standard
affine chart of `P² × P²`. -/
public theorem short_weierstrass_point_baseChange_mvfrac_fin4_surjective
    [DecidableEq K]
    [DecidableEq (FractionRing (MvPolynomial (Fin 4) K))]
    (W : WeierstrassCurve K) [W.IsShortNF] [W.IsElliptic] :
    Function.Surjective
      (WeierstrassCurve.Affine.Point.baseChange
        (W' := W.toAffine) K
        (FractionRing (MvPolynomial (Fin 4) K))) :=
  short_weierstrass_point_baseChange_mvfrac_surjective 4 W

/-- Transport of the `Fin 4` endpoint to any explicitly identified
`K`-function field. -/
public theorem short_weierstrass_point_baseChange_of_fin4_algEquiv_surjective
    {L : Type*} [Field L] [Algebra K L]
    [DecidableEq K] [DecidableEq L]
    (e : FractionRing (MvPolynomial (Fin 4) K) ≃ₐ[K] L)
    (W : WeierstrassCurve K) [W.IsShortNF] [W.IsElliptic] :
    Function.Surjective
      (WeierstrassCurve.Affine.Point.baseChange (W' := W.toAffine) K L) := by
  classical
  intro Q
  let Q₄ := WeierstrassCurve.Affine.Point.map (W' := W.toAffine)
    e.symm.toAlgHom Q
  obtain ⟨P, hP⟩ :=
    short_weierstrass_point_baseChange_mvfrac_fin4_surjective W Q₄
  refine ⟨P, ?_⟩
  have hinv : WeierstrassCurve.Affine.Point.map (W' := W.toAffine)
      e.toAlgHom Q₄ = Q := by
    change WeierstrassCurve.Affine.Point.map (W' := W.toAffine)
      e.toAlgHom (WeierstrassCurve.Affine.Point.map (W' := W.toAffine)
        e.symm.toAlgHom Q) = Q
    rw [WeierstrassCurve.Affine.Point.map_map]
    have he : e.toAlgHom.comp e.symm.toAlgHom = AlgHom.id K L := by
      ext z
      exact e.apply_symm_apply z
    rw [he]
    cases Q <;> rfl
  have h := congrArg
    (WeierstrassCurve.Affine.Point.map (W' := W.toAffine) e.toAlgHom) hP
  rw [WeierstrassCurve.Affine.Point.map_baseChange, hinv] at h
  exact h

end Multivariable

end EllipticPolynomialConstancy
end V14Formalization
