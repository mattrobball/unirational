/-
Copyright (c) 2026 BConicBundleMultisections contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: BConicBundleMultisections contributors
-/
module

public import Mathlib.RingTheory.Polynomial.Resultant.Basic

/-!
# Explicit cubic–quadratic resultants

The fixed-degree Sylvester resultant of a monic-degree-at-most cubic and a monic-degree-at-most
quadratic, expanded as a polynomial identity in their coefficients.  This is the algebraic engine
behind the binary cubic–quadratic residual formula used for plane cubics restricted to a line.
-/

@[expose] public section

open Matrix

namespace Polynomial

/-- Explicit expansion of the fixed-degree `(3,2)` Sylvester resultant. -/
theorem resultant_cubic_quadratic_explicit
    {R : Type*} [CommRing R] (a b c d A B γ : R) :
    resultant
        (C a * X ^ 3 + C b * X ^ 2 + C c * X + C d)
        (C A * X ^ 2 + C B * X + C γ) 3 2 =
      A ^ 3 * d ^ 2
        - A ^ 2 * B * c * d
        - 2 * A ^ 2 * γ * b * d
        + A ^ 2 * γ * c ^ 2
        + A * B ^ 2 * b * d
        + 3 * A * B * γ * a * d
        - A * B * γ * b * c
        - 2 * A * γ ^ 2 * a * c
        + A * γ ^ 2 * b ^ 2
        - B ^ 3 * a * d
        + B ^ 2 * γ * a * c
        - B * γ ^ 2 * a * b
        + γ ^ 3 * a ^ 2 := by
  classical
  set p : R[X] := C a * X ^ 3 + C b * X ^ 2 + C c * X + C d
  set q : R[X] := C A * X ^ 2 + C B * X + C γ
  have hp0 : p.coeff 0 = d := by simp [p]
  have hp1 : p.coeff 1 = c := by simp [p]
  have hp2 : p.coeff 2 = b := by simp [p]
  have hp3 : p.coeff 3 = a := by simp [p]
  have hq0 : q.coeff 0 = γ := by simp [q]
  have hq1 : q.coeff 1 = B := by simp [q]
  have hq2 : q.coeff 2 = A := by simp [q]
  rw [resultant]
  have hsylvester :
      sylvester p q 3 2 =
        !![γ, 0, 0, d, 0;
           B, γ, 0, c, d;
           A, B, γ, b, c;
           0, A, B, a, b;
           0, 0, A, 0, a] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [sylvester, Fin.addCases, Set.mem_Icc,
        hp0, hp1, hp2, hp3, hq0, hq1, hq2]
  rw [hsylvester]
  simp [Matrix.det_succ_row_zero (n := 4), Matrix.det_succ_row_zero (n := 3),
    Fin.succAbove, Matrix.det_fin_three, Finset.sum_fin_eq_sum_range,
    Finset.sum_range_succ]
  ring

end Polynomial
