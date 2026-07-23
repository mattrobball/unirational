/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.Algebra.Polynomial.Homogenize
public import Mathlib.FieldTheory.IsAlgClosed.Basic
public import Mathlib.RingTheory.Polynomial.Resultant.Basic

/-!
# Fixed-degree resultants of binary forms

Binary forms of degree `d` are represented by Mathlib's homogeneous degree-`d` submodule of
`MvPolynomial (Fin 2) R`.  Dehomogenization in the second standard chart converts them to
univariate polynomials of degree at most `d`.  Passing the *nominal* degrees to
`Polynomial.resultant` is essential: after specialization, a drop in both univariate degrees is
the common projective root at infinity and must still force the resultant to vanish.
-/

@[expose] public section

open scoped Polynomial

namespace BConicBundleMultisections

namespace BinaryForm

open Polynomial

private lemma resultant_eq_mul_default_of_degree_le {K : Type*} [Field K]
    (p q : K[X]) (k l : ℕ) :
    p.resultant q (p.natDegree + k) (q.natDegree + l) =
      (-1) ^ ((q.natDegree + l) * k) * q.coeff (q.natDegree + l) ^ k *
        (p.leadingCoeff ^ l * p.resultant q) := by
  rw [resultant_add_left_deg, resultant_add_right_deg] <;> simp

private theorem resultant_eq_zero_iff_of_degree_le {K : Type*} [Field K]
    {p q : K[X]} {m n : ℕ} (hp : p.natDegree ≤ m) (hq : q.natDegree ≤ n)
    (hmn : m ≠ 0 ∨ n ≠ 0) :
    p.resultant q m n = 0 ↔
      ((p ≠ 0 ∨ q ≠ 0) ∧ ¬ IsCoprime p q) ∨
        (p.coeff m = 0 ∧ q.coeff n = 0) := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le hp
  obtain ⟨l, rfl⟩ := Nat.exists_eq_add_of_le hq
  rcases k with _ | k <;> rcases l with _ | l
  · have hpq : p ≠ 0 ∨ q ≠ 0 := by
      contrapose! hmn
      simp [hmn.1, hmn.2]
    simp only [add_zero]
    rw [resultant_eq_zero_iff]
    simp only [coeff_natDegree, leadingCoeff_eq_zero]
    tauto
  · rw [resultant_eq_mul_default_of_degree_le]
    have hqcoeff : q.coeff (q.natDegree + (l + 1)) = 0 :=
      coeff_eq_zero_of_natDegree_lt (by omega)
    simp [hqcoeff, resultant_eq_zero_iff, leadingCoeff_eq_zero, pow_succ]
    tauto
  · rw [resultant_eq_mul_default_of_degree_le]
    have hpcoeff : p.coeff (p.natDegree + (k + 1)) = 0 :=
      coeff_eq_zero_of_natDegree_lt (by omega)
    simp [hpcoeff, resultant_eq_zero_iff, leadingCoeff_eq_zero, pow_succ]
    tauto
  · rw [resultant_eq_mul_default_of_degree_le]
    have hpcoeff : p.coeff (p.natDegree + (k + 1)) = 0 :=
      coeff_eq_zero_of_natDegree_lt (by omega)
    have hqcoeff : q.coeff (q.natDegree + (l + 1)) = 0 :=
      coeff_eq_zero_of_natDegree_lt (by omega)
    simp [hpcoeff, hqcoeff, pow_succ]

/-- Binary homogeneous forms of degree `d` over `R`. -/
abbrev Form (R : Type*) [CommSemiring R] (d : ℕ) :=
  MvPolynomial.homogeneousSubmodule (Fin 2) R d

/-- Dehomogenize a binary form in the chart where the second coordinate is one. -/
noncomputable def dehomogenize {R : Type*} [CommSemiring R] {d : ℕ}
    (F : Form R d) : R[X] :=
  MvPolynomial.aeval ![X, 1] (F : MvPolynomial (Fin 2) R)

/-- Dehomogenization of a degree-`d` binary form has univariate degree at most `d`. -/
theorem natDegree_dehomogenize_le {R : Type*} [CommSemiring R] {d : ℕ}
    (F : Form R d) : (dehomogenize F).natDegree ≤ d := by
  simpa [dehomogenize] using MvPolynomial.aeval_natDegree_le
    F.1 F.2.totalDegree_le ![X, 1] (m := d) (n := 1) (by
      intro i
      fin_cases i
      · exact Polynomial.natDegree_X_le
      · simp)

/-- Rehomogenizing the dehomogenization of a binary form recovers the original form. -/
theorem homogenize_dehomogenize {R : Type*} [CommSemiring R] {d : ℕ}
    (F : Form R d) :
    (dehomogenize F).homogenize d = (F : MvPolynomial (Fin 2) R) := by
  exact Polynomial.homogenize_eq_of_isHomogeneous F.2 rfl

/-- Dehomogenizing a homogenized polynomial of bounded degree recovers the polynomial. -/
@[simp]
theorem dehomogenize_homogenize {R : Type*} [CommSemiring R] {d : ℕ}
    (p : R[X]) (hp : p.natDegree ≤ d) :
    dehomogenize ⟨p.homogenize d, Polynomial.isHomogeneous_homogenize p⟩ = p := by
  simpa [dehomogenize] using Polynomial.aeval_homogenize_X_one p hp

/-- Dehomogenization identifies degree-`d` binary forms with univariate
polynomials of degree at most `d`. -/
noncomputable def dehomogenizeEquivDegreeLE (R : Type*) [CommSemiring R] (d : ℕ) :
    Form R d ≃ₗ[R] Polynomial.degreeLE R d where
  toFun F := ⟨dehomogenize F, Polynomial.mem_degreeLE.mpr <|
    Polynomial.degree_le_of_natDegree_le (natDegree_dehomogenize_le F)⟩
  invFun p := ⟨p.1.homogenize d, Polynomial.isHomogeneous_homogenize p.1⟩
  map_add' F G := by
    ext
    simp [dehomogenize]
  map_smul' r F := by
    ext
    simp [dehomogenize]
  left_inv F := Subtype.ext (homogenize_dehomogenize F)
  right_inv p := Subtype.ext <| dehomogenize_homogenize p.1 <|
    Polynomial.natDegree_le_of_degree_le (Polynomial.mem_degreeLE.mp p.2)

/-- Map the coefficients of a binary form. -/
noncomputable def map {R S : Type*} [CommSemiring R] [CommSemiring S]
    (f : R →+* S) {d : ℕ} (F : Form R d) : Form S d :=
  ⟨MvPolynomial.map f F.1, F.2.map f⟩

/-- The underlying multivariate polynomial of a coefficientwise mapped binary form. -/
@[simp]
theorem coe_map {R S : Type*} [CommSemiring R] [CommSemiring S]
    (f : R →+* S) {d : ℕ} (F : Form R d) :
    (map f F : MvPolynomial (Fin 2) S) = MvPolynomial.map f F :=
  rfl

/-- Dehomogenization commutes with coefficient maps. -/
@[simp]
theorem dehomogenize_map {R S : Type*} [CommSemiring R] [CommSemiring S]
    (f : R →+* S) {d : ℕ} (F : Form R d) :
    dehomogenize (map f F) = (dehomogenize F).map f := by
  simp only [dehomogenize, coe_map, MvPolynomial.aeval_def,
    MvPolynomial.eval₂_map]
  change _ = Polynomial.mapRingHom f _
  rw [MvPolynomial.hom_eval₂]
  congr 1
  · ext r
    simp
  · funext i
    fin_cases i <;> simp

/-- The fixed-degree resultant of two binary forms. -/
noncomputable def resultant {R : Type*} [CommRing R] {m n : ℕ}
    (F : Form R m) (G : Form R n) : R :=
  Polynomial.resultant (dehomogenize F) (dehomogenize G) m n

/-- The fixed-degree binary resultant commutes with coefficient maps and hence with
specialization. -/
@[simp]
theorem resultant_map {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) {m n : ℕ} (F : Form R m) (G : Form R n) :
    resultant (map f F) (map f G) = f (resultant F G) := by
  change Polynomial.resultant (dehomogenize (map f F))
      (dehomogenize (map f G)) m n = _
  rw [dehomogenize_map f F, dehomogenize_map f G]
  exact Polynomial.resultant_map_map (dehomogenize F) (dehomogenize G) m n f

/-- Over a field, the fixed-degree resultant vanishes precisely when the dehomogenized forms
have a nontrivial common factor or when both nominal leading coefficients vanish.  The latter
alternative is the common projective root at infinity.  The positive-degree hypothesis excludes
the exceptional empty `0 × 0` Sylvester matrix, whose determinant is one. -/
theorem resultant_eq_zero_iff {K : Type*} [Field K] {m n : ℕ}
    (F : Form K m) (G : Form K n) (hmn : m ≠ 0 ∨ n ≠ 0) :
    resultant F G = 0 ↔
      (((dehomogenize F ≠ 0 ∨ dehomogenize G ≠ 0) ∧
          ¬ IsCoprime (dehomogenize F) (dehomogenize G)) ∨
        ((dehomogenize F).coeff m = 0 ∧ (dehomogenize G).coeff n = 0)) := by
  exact resultant_eq_zero_iff_of_degree_le
    (natDegree_dehomogenize_le F) (natDegree_dehomogenize_le G) hmn

/-- Over an algebraically closed extension, the fixed-degree resultant vanishes precisely at a
common affine root or at the common projective root at infinity.  The nonzero disjunction in the
affine alternative records the exceptional default resultant of two zero constant polynomials. -/
theorem resultant_eq_zero_iff_exists_affine_root_or_infinity
    {k L : Type*} [Field k] [Field L] [IsAlgClosed L] [Algebra k L]
    {m n : ℕ} (F : Form k m) (G : Form k n) (hmn : m ≠ 0 ∨ n ≠ 0) :
    resultant F G = 0 ↔
      (((dehomogenize F ≠ 0 ∨ dehomogenize G ≠ 0) ∧
          ∃ a : L, Polynomial.aeval a (dehomogenize F) = 0 ∧
            Polynomial.aeval a (dehomogenize G) = 0) ∨
        ((dehomogenize F).coeff m = 0 ∧ (dehomogenize G).coeff n = 0)) := by
  rw [resultant_eq_zero_iff F G hmn]
  have hroot : ¬ IsCoprime (dehomogenize F) (dehomogenize G) ↔
      ∃ a : L, Polynomial.aeval a (dehomogenize F) = 0 ∧
        Polynomial.aeval a (dehomogenize G) = 0 := by
    calc
      ¬ IsCoprime (dehomogenize F) (dehomogenize G) ↔
          ¬ ∀ a : L, Polynomial.aeval a (dehomogenize F) ≠ 0 ∨
            Polynomial.aeval a (dehomogenize G) ≠ 0 :=
        not_congr (Polynomial.isCoprime_iff_aeval_ne_zero_of_isAlgClosed
          (k := k) L (dehomogenize F) (dehomogenize G))
      _ ↔ _ := by simp only [not_forall, not_or, not_ne_iff]
  rw [hroot]

end BinaryForm

end BConicBundleMultisections
