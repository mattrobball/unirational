/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.MvFracConstantField

/-!
# Projective descent of a nonsingular binary quadratic

A nonzero solution of a nonsingular binary quadratic over a pure
transcendental extension is a scalar multiple of a base-field solution.
-/

noncomputable section

open Polynomial

namespace V14Formalization.BinaryQuadraticDescent

open EllipticPolynomialConstancy MvFracConstantField

variable {K : Type*} [Field K] [CharZero K]

private lemma binary_poly_ne_zero {qA qB qC : K}
    (hdisc : qB ^ 2 - 4 * qA * qC ≠ 0) :
    (Polynomial.C qA * X ^ 2 + Polynomial.C qB * X + Polynomial.C qC : Polynomial K) ≠ 0 := by
  intro hp
  have hA : qA = 0 := by
    have := congrArg (fun p : Polynomial K => coeff p 2) hp
    simpa using this
  have hB : qB = 0 := by
    have := congrArg (fun p : Polynomial K => coeff p 1) hp
    simpa using this
  have hC : qC = 0 := by
    have := congrArg (fun p : Polynomial K => coeff p 0) hp
    simpa using this
  exact hdisc (by simp [hA, hB, hC])

theorem binaryQuadratic_projective_descends_mvfrac
    (n : ℕ) (A B C : K) (hdisc : B ^ 2 - 4 * A * C ≠ 0)
    (s t : MvFrac K n) (hst : s ≠ 0 ∨ t ≠ 0)
    (hq : (algebraMap K (MvFrac K n) A) * s ^ 2 +
      (algebraMap K (MvFrac K n) B) * s * t +
      (algebraMap K (MvFrac K n) C) * t ^ 2 = 0) :
    ∃ (s0 t0 : K) (c : MvFrac K n),
      (s0 ≠ 0 ∨ t0 ≠ 0) ∧ c ≠ 0 ∧
      s = c * algebraMap K (MvFrac K n) s0 ∧
      t = c * algebraMap K (MvFrac K n) t0 := by
  rcases eq_or_ne t 0 with ht | ht
  · subst t
    have hs : s ≠ 0 := by
      simpa using hst
    refine ⟨1, 0, s, by simp, hs, ?_, by simp⟩
    simp
  · set r : MvFrac K n := s * t⁻¹
    have hst' : s = r * t := by
      simp [r, mul_assoc, inv_mul_cancel₀ ht]
    have hquad :
        (algebraMap K (MvFrac K n) A) * r ^ 2 +
          (algebraMap K (MvFrac K n) B) * r +
          algebraMap K (MvFrac K n) C = 0 := by
      apply (mul_right_inj' (pow_ne_zero 2 ht)).mp
      convert hq using 1
      · simp [hst', pow_two]
        ring
      · simp
    have hrAlg : IsAlgebraic K r :=
      ⟨Polynomial.C A * X ^ 2 + Polynomial.C B * X + Polynomial.C C,
        binary_poly_ne_zero hdisc, by
          simp [aeval_add, aeval_mul, aeval_X, Polynomial.aeval_C, hquad]⟩
    obtain ⟨s0, hs0⟩ := (mvFrac_isAlgebraic_iff_constant n r).mp hrAlg
    refine ⟨s0, 1, t, by simp, ht, ?_, by simp⟩
    simp [hst', hs0, mul_comm]

end V14Formalization.BinaryQuadraticDescent
