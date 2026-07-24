/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import BConicBundleMultisections.BinaryCubicResidual
public import Mathlib.Algebra.Polynomial.Coeff

/-!
# Binary line-restriction coefficients as polars

The `X₀ X₁²` coefficient of a cubic restricted to a line is the polar pairing `∇G(q)·p`,
and the `X₁³` coefficient is `G(q)`.
-/

@[expose] public section

open MvPolynomial

namespace BConicBundleMultisections

noncomputable section

universe u v

variable {R : Type u} [CommRing R]

/-- Constant term of `G(q + X•p)` is `G(q)`. -/
theorem coeff_zero_line_eval
    {σ : Type v} [Fintype σ]
    (G : MvPolynomial σ R) (p q : σ → R) :
    Polynomial.coeff
        (aeval (fun i : σ => Polynomial.C (q i) + Polynomial.C (p i) * Polynomial.X) G) 0 =
      eval q G := by
  classical
  induction G using MvPolynomial.induction_on with
  | C a => simp [aeval_C, Polynomial.coeff_C, eval_C]
  | add f g hf hg => simp [map_add, Polynomial.coeff_add, eval_add, hf, hg]
  | mul_X f i hf =>
      simp only [map_mul, aeval_X, eval_mul, eval_X]
      set ef := aeval (fun j : σ => Polynomial.C (q j) + Polynomial.C (p j) * Polynomial.X) f
      have hmul :
          Polynomial.coeff (ef * (Polynomial.C (q i) + Polynomial.C (p i) * Polynomial.X)) 0 =
            Polynomial.coeff ef 0 * q i := by
        rw [mul_add, Polynomial.coeff_add, Polynomial.coeff_mul_C]
        have : Polynomial.coeff (ef * (Polynomial.C (p i) * Polynomial.X)) 0 = 0 := by
          rw [show ef * (Polynomial.C (p i) * Polynomial.X) =
              (ef * Polynomial.C (p i)) * Polynomial.X by ring]
          exact Polynomial.coeff_mul_X_zero _
        simp [this]
      simpa [ef] using hmul.trans (by rw [hf])

/-- Coefficient of `X` in `G(q + X•p)` equals `∇G(q)·p`. -/
theorem coeff_one_line_eval
    {σ : Type v} [Fintype σ]
    (G : MvPolynomial σ R) (p q : σ → R) :
    Polynomial.coeff
        (aeval (fun i : σ => Polynomial.C (q i) + Polynomial.C (p i) * Polynomial.X) G) 1 =
      ∑ i : σ, p i * eval q (pderiv i G) := by
  classical
  induction G using MvPolynomial.induction_on with
  | C a => simp [aeval_C, Polynomial.coeff_C]
  | add f g hf hg =>
      simp only [map_add, Polynomial.coeff_add, (pderiv _).map_add, eval_add, mul_add,
        Finset.sum_add_distrib, hf, hg]
  | mul_X f i hf =>
      set ef := aeval (fun j : σ => Polynomial.C (q j) + Polynomial.C (p j) * Polynomial.X) f
      have hmul :
          Polynomial.coeff (ef * (Polynomial.C (q i) + Polynomial.C (p i) * Polynomial.X)) 1 =
            Polynomial.coeff ef 1 * q i + Polynomial.coeff ef 0 * p i := by
        rw [mul_add, Polynomial.coeff_add, Polynomial.coeff_mul_C]
        have hx :
            Polynomial.coeff (ef * (Polynomial.C (p i) * Polynomial.X)) 1 =
              Polynomial.coeff ef 0 * p i := by
          rw [show ef * (Polynomial.C (p i) * Polynomial.X) =
              (ef * Polynomial.C (p i)) * Polynomial.X by ring,
            Polynomial.coeff_mul_X, Polynomial.coeff_mul_C]
        simp [hx]
      have hpd (j : σ) :
          pderiv j (f * X i) =
            pderiv j f * X i + f * (if i = j then (1 : MvPolynomial σ R) else 0) := by
        rw [Derivation.leibniz (pderiv j) f (X i), pderiv_X, smul_eq_mul]
        simp only [Pi.single_apply]
        split_ifs <;> ring
      have hRHS :
          (∑ j : σ, p j * eval q (pderiv j (f * X i))) =
            (∑ j : σ, p j * eval q (pderiv j f)) * q i + p i * eval q f := by
        have heval_if (j : σ) :
            eval q (if i = j then (1 : MvPolynomial σ R) else 0) =
              if i = j then (1 : R) else 0 := by
          split_ifs <;> simp
        simp only [hpd, eval_add, eval_mul, eval_X, mul_add, Finset.sum_add_distrib, heval_if]
        -- First sum: ∑ p_j * eval(pderiv j f) * q_i
        have h1 :
            (∑ j : σ, p j * (eval q (pderiv j f) * q i)) =
              (∑ j : σ, p j * eval q (pderiv j f)) * q i := by
          simp only [← mul_assoc]
          rw [← Finset.sum_mul]
        -- Second sum: ∑ p_j * eval f * (if i=j then 1 else 0) = p_i * eval f
        have h2 :
            (∑ j : σ, p j * (eval q f * (if i = j then (1 : R) else 0))) =
              p i * eval q f := by
          classical
          rw [Finset.sum_eq_single i]
          · simp
          · intro j _ hne
            have : i ≠ j := Ne.symm hne
            simp [this]
          · intro hnot
            exact (hnot (Finset.mem_univ i)).elim
        rw [h1, h2]
      have h0 : Polynomial.coeff ef 0 = eval q f := coeff_zero_line_eval f p q
      calc
        Polynomial.coeff
            (aeval (fun j : σ => Polynomial.C (q j) + Polynomial.C (p j) * Polynomial.X)
              (f * X i)) 1 =
            Polynomial.coeff (ef * (Polynomial.C (q i) + Polynomial.C (p i) * Polynomial.X)) 1 := by
          simp only [map_mul, aeval_X, ef]
        _ = Polynomial.coeff ef 1 * q i + Polynomial.coeff ef 0 * p i := hmul
        _ = (∑ j : σ, p j * eval q (pderiv j f)) * q i + p i * eval q f := by
          rw [hf, h0]; ring
        _ = ∑ j : σ, p j * eval q (pderiv j (f * X i)) := hRHS.symm

/-- Dehomogenization at `X₁ = 1` extracts the `X₀ X₁²` coefficient of a homogeneous binary cubic. -/
theorem coeff_one_dehom_binaryCubic
    (f : MvPolynomial (Fin 2) R) (hf : f.IsHomogeneous 3) :
    Polynomial.coeff
        (aeval (fun i : Fin 2 => if i = 0 then Polynomial.X else Polynomial.C 1) f) 1 =
      coeff (binaryExponent 1 2) f := by
  conv_lhs => rw [binaryCubic_eq_sum_monomials f hf]
  simp only [map_add]
  have hmon (a b : ℕ) (c : R) :
      aeval (fun i : Fin 2 => if i = 0 then Polynomial.X else Polynomial.C 1)
          (monomial (binaryExponent a b) c) =
        Polynomial.C c * Polynomial.X ^ a := by
    simp only [aeval_monomial, binaryExponent]
    have e0 : (fun i : Fin 2 => if i = 0 then Polynomial.X else Polynomial.C (1 : R)) 0 =
        Polynomial.X := by simp
    have e1 : (fun i : Fin 2 => if i = 0 then Polynomial.X else Polynomial.C (1 : R)) 1 =
        Polynomial.C 1 := by simp
    rw [Finsupp.prod_add_index' (fun _ => pow_zero _) (fun _ => pow_add _)]
    simp [Finsupp.prod_single_index, e0, e1, one_pow, mul_one]
  simp only [hmon, Polynomial.coeff_add, Polynomial.coeff_C_mul, Polynomial.coeff_X_pow]
  simp

/-- The `X₀ X₁²` coefficient of a line restriction is the polar `∇G(q)·p`. -/
theorem coeff12_of_binaryLineRestriction
    {σ : Type v} [Fintype σ]
    (G : MvPolynomial σ R) (hG : G.IsHomogeneous 3) (p q : σ → R) :
    coeff (binaryExponent 1 2) (binaryLineRestriction p q G) =
      ∑ i : σ, p i * eval q (pderiv i G) := by
  have hhom : (binaryLineRestriction p q G).IsHomogeneous 3 :=
    binaryLineRestriction_isHomogeneous hG p q
  have hdeh := coeff_one_dehom_binaryCubic (binaryLineRestriction p q G) hhom
  have hline :
      aeval (fun i : Fin 2 => if i = 0 then Polynomial.X else Polynomial.C 1)
          (binaryLineRestriction p q G) =
        aeval (fun i : σ => Polynomial.C (p i) * Polynomial.X + Polynomial.C (q i)) G := by
    unfold binaryLineRestriction
    rw [MvPolynomial.comp_aeval_apply
      (S₁ := MvPolynomial (Fin 2) R)
      (f := fun i : σ => (C (p i) * X 0 + C (q i) * X 1 : MvPolynomial (Fin 2) R))
      (φ := aeval (fun i : Fin 2 => if i = 0 then Polynomial.X else Polynomial.C 1))
      G]
    refine congrArg (fun φ : σ → Polynomial R => aeval φ G) ?_
    funext i
    simp only [map_add, map_mul, aeval_C, aeval_X]
    simp
  have hcomm :
      aeval (fun i : σ => Polynomial.C (p i) * Polynomial.X + Polynomial.C (q i)) G =
        aeval (fun i : σ => Polynomial.C (q i) + Polynomial.C (p i) * Polynomial.X) G := by
    apply congrArg (fun φ => aeval φ G)
    funext i
    ring
  rw [← hdeh, hline, hcomm, coeff_one_line_eval]

/-- The `X₁³` coefficient of a line restriction is `G(q)`. -/
theorem coeff03_of_binaryLineRestriction
    {σ : Type v} [Fintype σ]
    (G : MvPolynomial σ R) (hG : G.IsHomogeneous 3) (p q : σ → R) :
    coeff (binaryExponent 0 3) (binaryLineRestriction p q G) = eval q G := by
  have hhom : (binaryLineRestriction p q G).IsHomogeneous 3 :=
    binaryLineRestriction_isHomogeneous hG p q
  have h2 : eval (binarySecondEndpoint (R := R)) (binaryLineRestriction p q G) =
      coeff (binaryExponent 0 3) (binaryLineRestriction p q G) := by
    conv_lhs => rw [binaryCubic_eq_sum_monomials _ hhom]
    simp [binarySecondEndpoint, eval_monomial, binaryExponent]
  rw [← h2, eval_binaryLineRestriction_second]

end

end BConicBundleMultisections
