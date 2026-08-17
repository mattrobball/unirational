/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.D12PiecePPCoeff0_0
public import V14Formalization.D12PiecePPCoeff0_1
public import V14Formalization.D12PiecePPCoeff0_2
public import V14Formalization.D12PiecePPCoeff1_0
public import V14Formalization.D12PiecePPCoeff1_1
public import V14Formalization.D12PiecePPCoeff1_2
public import V14Formalization.D12PiecePPCoeff2_0
public import V14Formalization.D12PiecePPCoeff2_1
public import V14Formalization.D12PiecePPCoeff2_2
public import V14Formalization.D12PiecePPDeterminant

/-! # The normalized Plucker certificate for the `(+,+)` character plane. -/

noncomputable section

open Matrix

namespace V14Formalization.D12PiecePPPlucker

open D12Certificate D12CyclotomicVec D12PiecePPPluckerBase

public abbrev C : Matrix (Fin 3) (Fin 3) WeilRep.K := evalMatrix CVec

theorem mulVec_fin2 (M : Matrix (Fin 15) (Fin 2) WeilRep.K)
    (t : Fin 2 → WeilRep.K) (i : Fin 15) :
    M.mulVec t i = M i 0 * t 0 + M i 1 * t 1 := by
  simp [Matrix.mulVec, Fin.sum_univ_succ]

theorem plucker_row0 (t : Fin 2 → WeilRep.K) :
    pluckerValue ((evalMatrix BKVec).mulVec t) 1 =
      eval CCell0_0 * (t 0 * t 0) +
      eval CCell0_1 * (t 0 * t 1) +
      eval CCell0_2 * (t 1 * t 1) := by
  change ((evalMatrix BKVec).mulVec t) 0 * ((evalMatrix BKVec).mulVec t) 10 -
      ((evalMatrix BKVec).mulVec t) 1 * ((evalMatrix BKVec).mulVec t) 7 +
      ((evalMatrix BKVec).mulVec t) 3 * ((evalMatrix BKVec).mulVec t) 5 = _
  simp_rw [mulVec_fin2]
  change (eval (BKVec 0 0) * t 0 + eval (BKVec 0 1) * t 1) *
        (eval (BKVec 10 0) * t 0 + eval (BKVec 10 1) * t 1) -
      (eval (BKVec 1 0) * t 0 + eval (BKVec 1 1) * t 1) *
        (eval (BKVec 7 0) * t 0 + eval (BKVec 7 1) * t 1) +
      (eval (BKVec 3 0) * t 0 + eval (BKVec 3 1) * t 1) *
        (eval (BKVec 5 0) * t 0 + eval (BKVec 5 1) * t 1) = _
  rw [BKVec_0_0, BKVec_0_1, BKVec_10_0, BKVec_10_1,
    BKVec_1_0, BKVec_1_1, BKVec_7_0, BKVec_7_1,
    BKVec_3_0, BKVec_3_1, BKVec_5_0, BKVec_5_1]
  calc
    _ = (eval BKCoord0_0 * eval BKCoord10_0 -
          eval BKCoord1_0 * eval BKCoord7_0 +
          eval BKCoord3_0 * eval BKCoord5_0) * (t 0 * t 0) +
        (eval BKCoord0_0 * eval BKCoord10_1 +
          eval BKCoord0_1 * eval BKCoord10_0 -
          eval BKCoord1_0 * eval BKCoord7_1 -
          eval BKCoord1_1 * eval BKCoord7_0 +
          eval BKCoord3_0 * eval BKCoord5_1 +
          eval BKCoord3_1 * eval BKCoord5_0) * (t 0 * t 1) +
        (eval BKCoord0_1 * eval BKCoord10_1 -
          eval BKCoord1_1 * eval BKCoord7_1 +
          eval BKCoord3_1 * eval BKCoord5_1) * (t 1 * t 1) := by ring
    _ = _ := by
      rw [D12PiecePPCoeff0_0.eval_coefficient,
        D12PiecePPCoeff0_1.eval_coefficient,
        D12PiecePPCoeff0_2.eval_coefficient]

theorem plucker_row1 (t : Fin 2 → WeilRep.K) :
    pluckerValue ((evalMatrix BKVec).mulVec t) 2 =
      eval CCell1_0 * (t 0 * t 0) +
      eval CCell1_1 * (t 0 * t 1) +
      eval CCell1_2 * (t 1 * t 1) := by
  change ((evalMatrix BKVec).mulVec t) 0 * ((evalMatrix BKVec).mulVec t) 11 -
      ((evalMatrix BKVec).mulVec t) 1 * ((evalMatrix BKVec).mulVec t) 8 +
      ((evalMatrix BKVec).mulVec t) 4 * ((evalMatrix BKVec).mulVec t) 5 = _
  simp_rw [mulVec_fin2]
  change (eval (BKVec 0 0) * t 0 + eval (BKVec 0 1) * t 1) *
        (eval (BKVec 11 0) * t 0 + eval (BKVec 11 1) * t 1) -
      (eval (BKVec 1 0) * t 0 + eval (BKVec 1 1) * t 1) *
        (eval (BKVec 8 0) * t 0 + eval (BKVec 8 1) * t 1) +
      (eval (BKVec 4 0) * t 0 + eval (BKVec 4 1) * t 1) *
        (eval (BKVec 5 0) * t 0 + eval (BKVec 5 1) * t 1) = _
  rw [BKVec_0_0, BKVec_0_1, BKVec_11_0, BKVec_11_1,
    BKVec_1_0, BKVec_1_1, BKVec_8_0, BKVec_8_1,
    BKVec_4_0, BKVec_4_1, BKVec_5_0, BKVec_5_1]
  calc
    _ = (eval BKCoord0_0 * eval BKCoord11_0 -
          eval BKCoord1_0 * eval BKCoord8_0 +
          eval BKCoord4_0 * eval BKCoord5_0) * (t 0 * t 0) +
        (eval BKCoord0_0 * eval BKCoord11_1 +
          eval BKCoord0_1 * eval BKCoord11_0 -
          eval BKCoord1_0 * eval BKCoord8_1 -
          eval BKCoord1_1 * eval BKCoord8_0 +
          eval BKCoord4_0 * eval BKCoord5_1 +
          eval BKCoord4_1 * eval BKCoord5_0) * (t 0 * t 1) +
        (eval BKCoord0_1 * eval BKCoord11_1 -
          eval BKCoord1_1 * eval BKCoord8_1 +
          eval BKCoord4_1 * eval BKCoord5_1) * (t 1 * t 1) := by ring
    _ = _ := by
      rw [D12PiecePPCoeff1_0.eval_coefficient,
        D12PiecePPCoeff1_1.eval_coefficient,
        D12PiecePPCoeff1_2.eval_coefficient]

theorem plucker_row2 (t : Fin 2 → WeilRep.K) :
    pluckerValue ((evalMatrix BKVec).mulVec t) 9 =
      eval CCell2_0 * (t 0 * t 0) +
      eval CCell2_1 * (t 0 * t 1) +
      eval CCell2_2 * (t 1 * t 1) := by
  change ((evalMatrix BKVec).mulVec t) 2 * ((evalMatrix BKVec).mulVec t) 14 -
      ((evalMatrix BKVec).mulVec t) 3 * ((evalMatrix BKVec).mulVec t) 13 +
      ((evalMatrix BKVec).mulVec t) 4 * ((evalMatrix BKVec).mulVec t) 12 = _
  simp_rw [mulVec_fin2]
  change (eval (BKVec 2 0) * t 0 + eval (BKVec 2 1) * t 1) *
        (eval (BKVec 14 0) * t 0 + eval (BKVec 14 1) * t 1) -
      (eval (BKVec 3 0) * t 0 + eval (BKVec 3 1) * t 1) *
        (eval (BKVec 13 0) * t 0 + eval (BKVec 13 1) * t 1) +
      (eval (BKVec 4 0) * t 0 + eval (BKVec 4 1) * t 1) *
        (eval (BKVec 12 0) * t 0 + eval (BKVec 12 1) * t 1) = _
  rw [BKVec_2_0, BKVec_2_1, BKVec_14_0, BKVec_14_1,
    BKVec_3_0, BKVec_3_1, BKVec_13_0, BKVec_13_1,
    BKVec_4_0, BKVec_4_1, BKVec_12_0, BKVec_12_1]
  calc
    _ = (eval BKCoord2_0 * eval BKCoord14_0 -
          eval BKCoord3_0 * eval BKCoord13_0 +
          eval BKCoord4_0 * eval BKCoord12_0) * (t 0 * t 0) +
        (eval BKCoord2_0 * eval BKCoord14_1 +
          eval BKCoord2_1 * eval BKCoord14_0 -
          eval BKCoord3_0 * eval BKCoord13_1 -
          eval BKCoord3_1 * eval BKCoord13_0 +
          eval BKCoord4_0 * eval BKCoord12_1 +
          eval BKCoord4_1 * eval BKCoord12_0) * (t 0 * t 1) +
        (eval BKCoord2_1 * eval BKCoord14_1 -
          eval BKCoord3_1 * eval BKCoord13_1 +
          eval BKCoord4_1 * eval BKCoord12_1) * (t 1 * t 1) := by ring
    _ = _ := by
      rw [D12PiecePPCoeff2_0.eval_coefficient,
        D12PiecePPCoeff2_1.eval_coefficient,
        D12PiecePPCoeff2_2.eval_coefficient]

public theorem coefficient_identity (t : Fin 2 → WeilRep.K) :
    C.mulVec (squareMonomials t) =
      ![pluckerValue ((evalMatrix BKVec).mulVec t) 1,
        pluckerValue ((evalMatrix BKVec).mulVec t) 2,
        pluckerValue ((evalMatrix BKVec).mulVec t) 9] := by
  funext i
  fin_cases i
  · change (C.mulVec (squareMonomials t)) 0 =
      pluckerValue ((evalMatrix BKVec).mulVec t) 1
    rw [plucker_row0]
    simp [C, Matrix.mulVec, dotProduct, squareMonomials, evalMatrix, CVec, CRow0,
      Fin.sum_univ_three]
  · change (C.mulVec (squareMonomials t)) 1 =
      pluckerValue ((evalMatrix BKVec).mulVec t) 2
    rw [plucker_row1]
    simp [C, Matrix.mulVec, dotProduct, squareMonomials, evalMatrix, CVec, CRow1,
      Fin.sum_univ_three]
  · change (C.mulVec (squareMonomials t)) 2 =
      pluckerValue ((evalMatrix BKVec).mulVec t) 9
    rw [plucker_row2]
    simp [C, Matrix.mulVec, dotProduct, squareMonomials, evalMatrix, CVec, CRow2,
      Fin.sum_univ_three]

public theorem det_ne_zero : C.det ≠ 0 :=
  D12PiecePPDeterminant.det_ne_zero

end V14Formalization.D12PiecePPPlucker
