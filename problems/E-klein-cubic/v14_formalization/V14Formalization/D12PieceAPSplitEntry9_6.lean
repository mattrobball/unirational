/- AP split identity entry (9,6). Auto-generated. -/
import V14Formalization.D12PieceAPData

noncomputable section
open Matrix
namespace V14Formalization.D12PieceAPSplitEntry9_6
open D12CyclotomicVec D12PieceAPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def xaProduct0 : Vec := mul XCell9_0 ACell0_6

theorem xaProduct0_left_eq_zero : XCell9_0 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct0_eq : xaProduct0 = 0 := by
  rw [xaProduct0, xaProduct0_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct0 :
    mul (XVec (9 : Fin 10) (0 : Fin 20))
      (AVec (0 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct0 = _
  exact xaProduct0_eq

def xaProduct1 : Vec := mul XCell9_1 ACell1_6

theorem xaProduct1_left_eq_zero : XCell9_1 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct1_eq : xaProduct1 = 0 := by
  rw [xaProduct1, xaProduct1_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct1 :
    mul (XVec (9 : Fin 10) (1 : Fin 20))
      (AVec (1 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct1 = _
  exact xaProduct1_eq

def xaProduct2 : Vec := mul XCell9_2 ACell2_6

theorem xaProduct2_left_eq_zero : XCell9_2 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct2_eq : xaProduct2 = 0 := by
  rw [xaProduct2, xaProduct2_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct2 :
    mul (XVec (9 : Fin 10) (2 : Fin 20))
      (AVec (2 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct2 = _
  exact xaProduct2_eq

def xaProduct3 : Vec := mul XCell9_3 ACell3_6

theorem xaProduct3_left_eq_zero : XCell9_3 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct3_eq : xaProduct3 = 0 := by
  rw [xaProduct3, xaProduct3_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct3 :
    mul (XVec (9 : Fin 10) (3 : Fin 20))
      (AVec (3 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct3 = _
  exact xaProduct3_eq

def xaProduct4 : Vec := mul XCell9_4 ACell4_6

theorem xaProduct4_left_eq_zero : XCell9_4 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct4_eq : xaProduct4 = 0 := by
  rw [xaProduct4, xaProduct4_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct4 :
    mul (XVec (9 : Fin 10) (4 : Fin 20))
      (AVec (4 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct4 = _
  exact xaProduct4_eq

def xaProduct5 : Vec := mul XCell9_5 ACell5_6

theorem xaProduct5_left_eq_zero : XCell9_5 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct5_eq : xaProduct5 = 0 := by
  rw [xaProduct5, xaProduct5_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct5 :
    mul (XVec (9 : Fin 10) (5 : Fin 20))
      (AVec (5 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct5 = _
  exact xaProduct5_eq

def xaProduct6 : Vec := mul XCell9_6 ACell6_6

theorem xaProduct6_left_eq_zero : XCell9_6 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct6_eq : xaProduct6 = 0 := by
  rw [xaProduct6, xaProduct6_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct6 :
    mul (XVec (9 : Fin 10) (6 : Fin 20))
      (AVec (6 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct6 = _
  exact xaProduct6_eq

def xaProduct7 : Vec := mul XCell9_7 ACell7_6

theorem xaProduct7_left_eq_zero : XCell9_7 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct7_eq : xaProduct7 = 0 := by
  rw [xaProduct7, xaProduct7_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct7 :
    mul (XVec (9 : Fin 10) (7 : Fin 20))
      (AVec (7 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct7 = _
  exact xaProduct7_eq

def xaProduct8 : Vec := mul XCell9_8 ACell8_6

theorem xaProduct8_left_eq_zero : XCell9_8 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct8_eq : xaProduct8 = 0 := by
  rw [xaProduct8, xaProduct8_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct8 :
    mul (XVec (9 : Fin 10) (8 : Fin 20))
      (AVec (8 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct8 = _
  exact xaProduct8_eq

def xaProduct9 : Vec := mul XCell9_9 ACell9_6

theorem xaProduct9_left_eq_zero : XCell9_9 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct9_eq : xaProduct9 = 0 := by
  rw [xaProduct9, xaProduct9_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct9 :
    mul (XVec (9 : Fin 10) (9 : Fin 20))
      (AVec (9 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct9 = _
  exact xaProduct9_eq

def xaProduct10 : Vec := mul XCell9_10 ACell10_6

theorem xaProduct10_left_eq_zero : XCell9_10 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct10_eq : xaProduct10 = 0 := by
  rw [xaProduct10, xaProduct10_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct10 :
    mul (XVec (9 : Fin 10) (10 : Fin 20))
      (AVec (10 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct10 = _
  exact xaProduct10_eq

def xaProduct11 : Vec := mul XCell9_11 ACell11_6

theorem xaProduct11_left_eq_zero : XCell9_11 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct11_eq : xaProduct11 = 0 := by
  rw [xaProduct11, xaProduct11_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct11 :
    mul (XVec (9 : Fin 10) (11 : Fin 20))
      (AVec (11 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct11 = _
  exact xaProduct11_eq

def xaProduct12 : Vec := mul XCell9_12 ACell12_6

theorem xaProduct12_left_eq_zero : XCell9_12 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct12_eq : xaProduct12 = 0 := by
  rw [xaProduct12, xaProduct12_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct12 :
    mul (XVec (9 : Fin 10) (12 : Fin 20))
      (AVec (12 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct12 = _
  exact xaProduct12_eq

def xaProduct13 : Vec := mul XCell9_13 ACell13_6

theorem xaProduct13_left_eq_zero : XCell9_13 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct13_eq : xaProduct13 = 0 := by
  rw [xaProduct13, xaProduct13_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct13 :
    mul (XVec (9 : Fin 10) (13 : Fin 20))
      (AVec (13 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct13 = _
  exact xaProduct13_eq

def xaProduct14 : Vec := mul XCell9_14 ACell14_6

theorem xaProduct14_left_eq_zero : XCell9_14 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct14_eq : xaProduct14 = 0 := by
  rw [xaProduct14, xaProduct14_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct14 :
    mul (XVec (9 : Fin 10) (14 : Fin 20))
      (AVec (14 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct14 = _
  exact xaProduct14_eq

def xaProduct15 : Vec := mul XCell9_15 ACell15_6

theorem xaProduct15_left_eq_zero : XCell9_15 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct15_eq : xaProduct15 = 0 := by
  rw [xaProduct15, xaProduct15_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct15 :
    mul (XVec (9 : Fin 10) (15 : Fin 20))
      (AVec (15 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct15 = _
  exact xaProduct15_eq

def xaProduct16 : Vec := mul XCell9_16 ACell16_6

theorem xaProduct16_left_eq_zero : XCell9_16 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct16_eq : xaProduct16 = 0 := by
  rw [xaProduct16, xaProduct16_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct16 :
    mul (XVec (9 : Fin 10) (16 : Fin 20))
      (AVec (16 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct16 = _
  exact xaProduct16_eq

def xaProduct17 : Vec := mul XCell9_17 ACell17_6

theorem xaProduct17_left_eq_zero : XCell9_17 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct17_eq : xaProduct17 = 0 := by
  rw [xaProduct17, xaProduct17_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct17 :
    mul (XVec (9 : Fin 10) (17 : Fin 20))
      (AVec (17 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct17 = _
  exact xaProduct17_eq

def xaProduct18 : Vec := mul XCell9_18 ACell18_6

theorem xaProduct18_left_eq_zero : XCell9_18 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct18_eq : xaProduct18 = 0 := by
  rw [xaProduct18, xaProduct18_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct18 :
    mul (XVec (9 : Fin 10) (18 : Fin 20))
      (AVec (18 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct18 = _
  exact xaProduct18_eq

def xaProduct19 : Vec := mul XCell9_19 ACell19_6

theorem xaProduct19_left_eq_zero : XCell9_19 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct19_eq : xaProduct19 = 0 := by
  rw [xaProduct19, xaProduct19_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct19 :
    mul (XVec (9 : Fin 10) (19 : Fin 20))
      (AVec (19 : Fin 20) (6 : Fin 10)) = 0 := by
  change xaProduct19 = _
  exact xaProduct19_eq

def XAMatrixTerm (k : Fin 20) : Vec :=
  mul (XVec (9 : Fin 10) k) (AVec k (6 : Fin 10))

def XAResult (k : Fin 20) : Vec :=
  match k.val with
  | 0 => 0
  | 1 => 0
  | 2 => 0
  | 3 => 0
  | 4 => 0
  | 5 => 0
  | 6 => 0
  | 7 => 0
  | 8 => 0
  | 9 => 0
  | 10 => 0
  | 11 => 0
  | 12 => 0
  | 13 => 0
  | 14 => 0
  | 15 => 0
  | 16 => 0
  | 17 => 0
  | 18 => 0
  | 19 => 0
  | _ => 0

theorem XAMatrixProduct (k : Fin 20) :
    XAMatrixTerm k = XAResult k := by
  fin_cases k
  · exact XAMatrixProduct0
  · exact XAMatrixProduct1
  · exact XAMatrixProduct2
  · exact XAMatrixProduct3
  · exact XAMatrixProduct4
  · exact XAMatrixProduct5
  · exact XAMatrixProduct6
  · exact XAMatrixProduct7
  · exact XAMatrixProduct8
  · exact XAMatrixProduct9
  · exact XAMatrixProduct10
  · exact XAMatrixProduct11
  · exact XAMatrixProduct12
  · exact XAMatrixProduct13
  · exact XAMatrixProduct14
  · exact XAMatrixProduct15
  · exact XAMatrixProduct16
  · exact XAMatrixProduct17
  · exact XAMatrixProduct18
  · exact XAMatrixProduct19

theorem XAMatrixTerm_sum_eq :
    (∑ k : Fin 20, XAMatrixTerm k) =
      ∑ k : Fin 20, XAResult k := by
  apply Finset.sum_congr rfl
  intro k _
  exact XAMatrixProduct k

theorem XAResult_sum_apply_0 :
    (∑ k : Fin 20, XAResult k) (0 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ]

theorem XAResult_sum_apply_1 :
    (∑ k : Fin 20, XAResult k) (1 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ]

theorem XAResult_sum_apply_2 :
    (∑ k : Fin 20, XAResult k) (2 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ]

theorem XAResult_sum_apply_3 :
    (∑ k : Fin 20, XAResult k) (3 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ]

theorem XAResult_sum_apply_4 :
    (∑ k : Fin 20, XAResult k) (4 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ]

theorem XAResult_sum_apply_5 :
    (∑ k : Fin 20, XAResult k) (5 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ]

theorem XAResult_sum_apply_6 :
    (∑ k : Fin 20, XAResult k) (6 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ]

theorem XAResult_sum_apply_7 :
    (∑ k : Fin 20, XAResult k) (7 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ]

theorem XAResult_sum_apply_8 :
    (∑ k : Fin 20, XAResult k) (8 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ]

theorem XAResult_sum_apply_9 :
    (∑ k : Fin 20, XAResult k) (9 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ]

theorem XAResult_sum_eq :
    (∑ k : Fin 20, XAResult k) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext n
  fin_cases n
  · exact XAResult_sum_apply_0
  · exact XAResult_sum_apply_1
  · exact XAResult_sum_apply_2
  · exact XAResult_sum_apply_3
  · exact XAResult_sum_apply_4
  · exact XAResult_sum_apply_5
  · exact XAResult_sum_apply_6
  · exact XAResult_sum_apply_7
  · exact XAResult_sum_apply_8
  · exact XAResult_sum_apply_9

def kyProduct0 : Vec := mul KCell9_0 YCell0_6

theorem kyProduct0_right_eq_zero : YCell0_6 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem kyProduct0_eq : kyProduct0 = 0 := by
  rw [kyProduct0, kyProduct0_right_eq_zero, mul_zero_right]

theorem KYMatrixProduct0 :
    mul (KVec (9 : Fin 10) (0 : Fin 1))
      (YVec (0 : Fin 1) (6 : Fin 10)) = 0 := by
  change kyProduct0 = _
  exact kyProduct0_eq

def KYMatrixTerm (k : Fin 1) : Vec :=
  mul (KVec (9 : Fin 10) k) (YVec k (6 : Fin 10))

def KYResult (k : Fin 1) : Vec :=
  match k.val with
  | 0 => 0
  | _ => 0

theorem KYMatrixProduct (k : Fin 1) :
    KYMatrixTerm k = KYResult k := by
  fin_cases k
  · exact KYMatrixProduct0

theorem KYMatrixTerm_sum_eq :
    (∑ k : Fin 1, KYMatrixTerm k) =
      ∑ k : Fin 1, KYResult k := by
  apply Finset.sum_congr rfl
  intro k _
  exact KYMatrixProduct k

theorem KYResult_sum_apply_0 :
    (∑ k : Fin 1, KYResult k) (0 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_1 :
    (∑ k : Fin 1, KYResult k) (1 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_2 :
    (∑ k : Fin 1, KYResult k) (2 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_3 :
    (∑ k : Fin 1, KYResult k) (3 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_4 :
    (∑ k : Fin 1, KYResult k) (4 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_5 :
    (∑ k : Fin 1, KYResult k) (5 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_6 :
    (∑ k : Fin 1, KYResult k) (6 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_7 :
    (∑ k : Fin 1, KYResult k) (7 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_8 :
    (∑ k : Fin 1, KYResult k) (8 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_9 :
    (∑ k : Fin 1, KYResult k) (9 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_eq :
    (∑ k : Fin 1, KYResult k) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext n
  fin_cases n
  · exact KYResult_sum_apply_0
  · exact KYResult_sum_apply_1
  · exact KYResult_sum_apply_2
  · exact KYResult_sum_apply_3
  · exact KYResult_sum_apply_4
  · exact KYResult_sum_apply_5
  · exact KYResult_sum_apply_6
  · exact KYResult_sum_apply_7
  · exact KYResult_sum_apply_8
  · exact KYResult_sum_apply_9

theorem entry_eq :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (9 : Fin 10) (6 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, XAMatrixTerm k) +
    (∑ k : Fin 1, KYMatrixTerm k) = _
  rw [XAMatrixTerm_sum_eq, KYMatrixTerm_sum_eq,
    XAResult_sum_eq, KYResult_sum_eq]
  funext n
  fin_cases n <;> norm_num

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (9 : Fin 10) (6 : Fin 10) =
      matrixOne (Fin 10) (9 : Fin 10) (6 : Fin 10) := by
  rw [entry_eq]
  have hne : (9 : Fin 10) ≠ (6 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PieceAPSplitEntry9_6
