/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
import V14Formalization.D12U6PolynomialData

/-!
# Evaluation of the six-dimensional D12 polynomial seal

The generated coordinate certificates are evaluated at `WeilRep.ζ` and
assembled in two bounded stages: six columns per row, then six rows.  The
result identifies the generated matrix with the actual Weil rotation matrix.
-/

noncomputable section

open Polynomial Matrix

namespace V14Formalization.D12U6PolynomialSeal

open D12PolynomialData D12PolynomialEvaluation
open D12U6Semantic D12U6PolynomialData

theorem Phi11_eq_WeilRep :
    D12PolynomialData.Phi11 = WeilRep.Φ11 := by
  symm
  simpa [WeilRep.Φ11, D12PolynomialData.Phi11] using
    (cyclotomic_prime (R := ℚ) 11)

theorem evalPhi11_ζ :
    evalPolyAt WeilRep.ζ D12PolynomialData.Phi11 = 0 := by
  change aeval WeilRep.ζ D12PolynomialData.Phi11 = 0
  rw [Phi11_eq_WeilRep]
  exact WeilRep.aeval_ζ_Φ11

private theorem direct_sub_R6_row0 (j : Fin 6) :
    ∃ q : Polynomial ℚ,
      directEntryPoly (0 : Fin 6) j - R6_poly 0 j = Phi11 * q := by
  fin_cases j
  · exact ⟨quotient_0_0, direct_sub_R6_0_0⟩
  · exact ⟨quotient_0_1, direct_sub_R6_0_1⟩
  · exact ⟨quotient_0_2, direct_sub_R6_0_2⟩
  · exact ⟨quotient_0_3, direct_sub_R6_0_3⟩
  · exact ⟨quotient_0_4, direct_sub_R6_0_4⟩
  · exact ⟨quotient_0_5, direct_sub_R6_0_5⟩

private theorem direct_sub_R6_row1 (j : Fin 6) :
    ∃ q : Polynomial ℚ,
      directEntryPoly (1 : Fin 6) j - R6_poly 1 j = Phi11 * q := by
  fin_cases j
  · exact ⟨quotient_1_0, direct_sub_R6_1_0⟩
  · exact ⟨quotient_1_1, direct_sub_R6_1_1⟩
  · exact ⟨quotient_1_2, direct_sub_R6_1_2⟩
  · exact ⟨quotient_1_3, direct_sub_R6_1_3⟩
  · exact ⟨quotient_1_4, direct_sub_R6_1_4⟩
  · exact ⟨quotient_1_5, direct_sub_R6_1_5⟩

private theorem direct_sub_R6_row2 (j : Fin 6) :
    ∃ q : Polynomial ℚ,
      directEntryPoly (2 : Fin 6) j - R6_poly 2 j = Phi11 * q := by
  fin_cases j
  · exact ⟨quotient_2_0, direct_sub_R6_2_0⟩
  · exact ⟨quotient_2_1, direct_sub_R6_2_1⟩
  · exact ⟨quotient_2_2, direct_sub_R6_2_2⟩
  · exact ⟨quotient_2_3, direct_sub_R6_2_3⟩
  · exact ⟨quotient_2_4, direct_sub_R6_2_4⟩
  · exact ⟨quotient_2_5, direct_sub_R6_2_5⟩

private theorem direct_sub_R6_row3 (j : Fin 6) :
    ∃ q : Polynomial ℚ,
      directEntryPoly (3 : Fin 6) j - R6_poly 3 j = Phi11 * q := by
  fin_cases j
  · exact ⟨quotient_3_0, direct_sub_R6_3_0⟩
  · exact ⟨quotient_3_1, direct_sub_R6_3_1⟩
  · exact ⟨quotient_3_2, direct_sub_R6_3_2⟩
  · exact ⟨quotient_3_3, direct_sub_R6_3_3⟩
  · exact ⟨quotient_3_4, direct_sub_R6_3_4⟩
  · exact ⟨quotient_3_5, direct_sub_R6_3_5⟩

private theorem direct_sub_R6_row4 (j : Fin 6) :
    ∃ q : Polynomial ℚ,
      directEntryPoly (4 : Fin 6) j - R6_poly 4 j = Phi11 * q := by
  fin_cases j
  · exact ⟨quotient_4_0, direct_sub_R6_4_0⟩
  · exact ⟨quotient_4_1, direct_sub_R6_4_1⟩
  · exact ⟨quotient_4_2, direct_sub_R6_4_2⟩
  · exact ⟨quotient_4_3, direct_sub_R6_4_3⟩
  · exact ⟨quotient_4_4, direct_sub_R6_4_4⟩
  · exact ⟨quotient_4_5, direct_sub_R6_4_5⟩

private theorem direct_sub_R6_row5 (j : Fin 6) :
    ∃ q : Polynomial ℚ,
      directEntryPoly (5 : Fin 6) j - R6_poly 5 j = Phi11 * q := by
  fin_cases j
  · exact ⟨quotient_5_0, direct_sub_R6_5_0⟩
  · exact ⟨quotient_5_1, direct_sub_R6_5_1⟩
  · exact ⟨quotient_5_2, direct_sub_R6_5_2⟩
  · exact ⟨quotient_5_3, direct_sub_R6_5_3⟩
  · exact ⟨quotient_5_4, direct_sub_R6_5_4⟩
  · exact ⟨quotient_5_5, direct_sub_R6_5_5⟩

private theorem direct_sub_R6 (i j : Fin 6) :
    ∃ q : Polynomial ℚ,
      directEntryPoly i j - R6_poly i j = Phi11 * q := by
  fin_cases i
  · exact direct_sub_R6_row0 j
  · exact direct_sub_R6_row1 j
  · exact direct_sub_R6_row2 j
  · exact direct_sub_R6_row3 j
  · exact direct_sub_R6_row4 j
  · exact direct_sub_R6_row5 j

theorem eval_R6_entry (i j : Fin 6) :
    evalPolyAt WeilRep.ζ (R6_poly i j) = actualU6 i j := by
  obtain ⟨q, hq⟩ := direct_sub_R6 i j
  have hq' := congrArg (evalPolyAt WeilRep.ζ) hq
  have hz :
      evalPolyAt WeilRep.ζ (directEntryPoly i j) -
        evalPolyAt WeilRep.ζ (R6_poly i j) = 0 := by
    simpa [map_sub, map_mul, evalPhi11_ζ] using hq'
  calc
    evalPolyAt WeilRep.ζ (R6_poly i j) =
        evalPolyAt WeilRep.ζ (directEntryPoly i j) := (sub_eq_zero.mp hz).symm
    _ = directValue i j := eval_directEntryPoly i j
    _ = actualU6 i j := (actualU6_apply_eq_directValue i j).symm

/-- The generated polynomial matrix evaluates to the actual six-dimensional
Weil rotation matrix. -/
theorem evalMatrixK_R6_eq_actualU6 :
    evalMatrixK R6_poly = actualU6 := by
  apply Matrix.ext
  intro i j
  exact eval_R6_entry i j

end V14Formalization.D12U6PolynomialSeal
