/- PP split identity entry (4,3). Auto-generated. -/
import V14Formalization.D12PiecePPData

noncomputable section
open Matrix
namespace V14Formalization.D12PiecePPSplitEntry4_3
open D12CyclotomicVec D12PiecePPData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def xaProduct0 : Vec := mul XCell4_0 ACell0_3

def xaProduct0Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-19 / 121 : ℚ)
  | 1 => (30 / 121 : ℚ)
  | 2 => (107 / 363 : ℚ)
  | 3 => (-98 / 363 : ℚ)
  | 4 => (-15 / 121 : ℚ)
  | 5 => (86 / 363 : ℚ)
  | 6 => (71 / 363 : ℚ)
  | 7 => (-17 / 363 : ℚ)
  | 8 => (-28 / 363 : ℚ)
  | 9 => (67 / 363 : ℚ)
  | _ => 0

theorem xaProduct0_apply_0 :
    xaProduct0 (0 : Fin 10) = xaProduct0Value (0 : Fin 10) := by
  norm_num [xaProduct0, xaProduct0Value, XCell4_0, ACell0_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct0_apply_1 :
    xaProduct0 (1 : Fin 10) = xaProduct0Value (1 : Fin 10) := by
  norm_num [xaProduct0, xaProduct0Value, XCell4_0, ACell0_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct0_apply_2 :
    xaProduct0 (2 : Fin 10) = xaProduct0Value (2 : Fin 10) := by
  norm_num [xaProduct0, xaProduct0Value, XCell4_0, ACell0_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct0_apply_3 :
    xaProduct0 (3 : Fin 10) = xaProduct0Value (3 : Fin 10) := by
  norm_num [xaProduct0, xaProduct0Value, XCell4_0, ACell0_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct0_apply_4 :
    xaProduct0 (4 : Fin 10) = xaProduct0Value (4 : Fin 10) := by
  norm_num [xaProduct0, xaProduct0Value, XCell4_0, ACell0_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct0_apply_5 :
    xaProduct0 (5 : Fin 10) = xaProduct0Value (5 : Fin 10) := by
  norm_num [xaProduct0, xaProduct0Value, XCell4_0, ACell0_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct0_apply_6 :
    xaProduct0 (6 : Fin 10) = xaProduct0Value (6 : Fin 10) := by
  norm_num [xaProduct0, xaProduct0Value, XCell4_0, ACell0_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct0_apply_7 :
    xaProduct0 (7 : Fin 10) = xaProduct0Value (7 : Fin 10) := by
  norm_num [xaProduct0, xaProduct0Value, XCell4_0, ACell0_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct0_apply_8 :
    xaProduct0 (8 : Fin 10) = xaProduct0Value (8 : Fin 10) := by
  norm_num [xaProduct0, xaProduct0Value, XCell4_0, ACell0_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct0_apply_9 :
    xaProduct0 (9 : Fin 10) = xaProduct0Value (9 : Fin 10) := by
  norm_num [xaProduct0, xaProduct0Value, XCell4_0, ACell0_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct0_eq : xaProduct0 = xaProduct0Value := by
  funext n
  fin_cases n
  · exact xaProduct0_apply_0
  · exact xaProduct0_apply_1
  · exact xaProduct0_apply_2
  · exact xaProduct0_apply_3
  · exact xaProduct0_apply_4
  · exact xaProduct0_apply_5
  · exact xaProduct0_apply_6
  · exact xaProduct0_apply_7
  · exact xaProduct0_apply_8
  · exact xaProduct0_apply_9

theorem XAMatrixProduct0 :
    mul (XVec (4 : Fin 10) (0 : Fin 20))
      (AVec (0 : Fin 20) (3 : Fin 10)) = xaProduct0Value := by
  change xaProduct0 = _
  exact xaProduct0_eq

def xaProduct1 : Vec := mul XCell4_1 ACell1_3

def xaProduct1Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-13 / 363 : ℚ)
  | 1 => (-40 / 121 : ℚ)
  | 2 => (41 / 363 : ℚ)
  | 3 => (-27 / 121 : ℚ)
  | 4 => (-113 / 363 : ℚ)
  | 5 => (76 / 363 : ℚ)
  | 6 => (-29 / 121 : ℚ)
  | 7 => (-53 / 363 : ℚ)
  | 8 => (67 / 363 : ℚ)
  | 9 => (-91 / 363 : ℚ)
  | _ => 0

theorem xaProduct1_apply_0 :
    xaProduct1 (0 : Fin 10) = xaProduct1Value (0 : Fin 10) := by
  norm_num [xaProduct1, xaProduct1Value, XCell4_1, ACell1_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct1_apply_1 :
    xaProduct1 (1 : Fin 10) = xaProduct1Value (1 : Fin 10) := by
  norm_num [xaProduct1, xaProduct1Value, XCell4_1, ACell1_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct1_apply_2 :
    xaProduct1 (2 : Fin 10) = xaProduct1Value (2 : Fin 10) := by
  norm_num [xaProduct1, xaProduct1Value, XCell4_1, ACell1_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct1_apply_3 :
    xaProduct1 (3 : Fin 10) = xaProduct1Value (3 : Fin 10) := by
  norm_num [xaProduct1, xaProduct1Value, XCell4_1, ACell1_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct1_apply_4 :
    xaProduct1 (4 : Fin 10) = xaProduct1Value (4 : Fin 10) := by
  norm_num [xaProduct1, xaProduct1Value, XCell4_1, ACell1_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct1_apply_5 :
    xaProduct1 (5 : Fin 10) = xaProduct1Value (5 : Fin 10) := by
  norm_num [xaProduct1, xaProduct1Value, XCell4_1, ACell1_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct1_apply_6 :
    xaProduct1 (6 : Fin 10) = xaProduct1Value (6 : Fin 10) := by
  norm_num [xaProduct1, xaProduct1Value, XCell4_1, ACell1_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct1_apply_7 :
    xaProduct1 (7 : Fin 10) = xaProduct1Value (7 : Fin 10) := by
  norm_num [xaProduct1, xaProduct1Value, XCell4_1, ACell1_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct1_apply_8 :
    xaProduct1 (8 : Fin 10) = xaProduct1Value (8 : Fin 10) := by
  norm_num [xaProduct1, xaProduct1Value, XCell4_1, ACell1_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct1_apply_9 :
    xaProduct1 (9 : Fin 10) = xaProduct1Value (9 : Fin 10) := by
  norm_num [xaProduct1, xaProduct1Value, XCell4_1, ACell1_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct1_eq : xaProduct1 = xaProduct1Value := by
  funext n
  fin_cases n
  · exact xaProduct1_apply_0
  · exact xaProduct1_apply_1
  · exact xaProduct1_apply_2
  · exact xaProduct1_apply_3
  · exact xaProduct1_apply_4
  · exact xaProduct1_apply_5
  · exact xaProduct1_apply_6
  · exact xaProduct1_apply_7
  · exact xaProduct1_apply_8
  · exact xaProduct1_apply_9

theorem XAMatrixProduct1 :
    mul (XVec (4 : Fin 10) (1 : Fin 20))
      (AVec (1 : Fin 20) (3 : Fin 10)) = xaProduct1Value := by
  change xaProduct1 = _
  exact xaProduct1_eq

def xaProduct2 : Vec := mul XCell4_2 ACell2_3

def xaProduct2Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (28 / 363 : ℚ)
  | 1 => (-2 / 11 : ℚ)
  | 2 => (-35 / 363 : ℚ)
  | 3 => (31 / 121 : ℚ)
  | 4 => (16 / 121 : ℚ)
  | 5 => (-8 / 33 : ℚ)
  | 6 => (-46 / 363 : ℚ)
  | 7 => (47 / 363 : ℚ)
  | 8 => (-8 / 121 : ℚ)
  | 9 => (-89 / 363 : ℚ)
  | _ => 0

theorem xaProduct2_apply_0 :
    xaProduct2 (0 : Fin 10) = xaProduct2Value (0 : Fin 10) := by
  norm_num [xaProduct2, xaProduct2Value, XCell4_2, ACell2_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct2_apply_1 :
    xaProduct2 (1 : Fin 10) = xaProduct2Value (1 : Fin 10) := by
  norm_num [xaProduct2, xaProduct2Value, XCell4_2, ACell2_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct2_apply_2 :
    xaProduct2 (2 : Fin 10) = xaProduct2Value (2 : Fin 10) := by
  norm_num [xaProduct2, xaProduct2Value, XCell4_2, ACell2_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct2_apply_3 :
    xaProduct2 (3 : Fin 10) = xaProduct2Value (3 : Fin 10) := by
  norm_num [xaProduct2, xaProduct2Value, XCell4_2, ACell2_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct2_apply_4 :
    xaProduct2 (4 : Fin 10) = xaProduct2Value (4 : Fin 10) := by
  norm_num [xaProduct2, xaProduct2Value, XCell4_2, ACell2_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct2_apply_5 :
    xaProduct2 (5 : Fin 10) = xaProduct2Value (5 : Fin 10) := by
  norm_num [xaProduct2, xaProduct2Value, XCell4_2, ACell2_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct2_apply_6 :
    xaProduct2 (6 : Fin 10) = xaProduct2Value (6 : Fin 10) := by
  norm_num [xaProduct2, xaProduct2Value, XCell4_2, ACell2_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct2_apply_7 :
    xaProduct2 (7 : Fin 10) = xaProduct2Value (7 : Fin 10) := by
  norm_num [xaProduct2, xaProduct2Value, XCell4_2, ACell2_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct2_apply_8 :
    xaProduct2 (8 : Fin 10) = xaProduct2Value (8 : Fin 10) := by
  norm_num [xaProduct2, xaProduct2Value, XCell4_2, ACell2_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct2_apply_9 :
    xaProduct2 (9 : Fin 10) = xaProduct2Value (9 : Fin 10) := by
  norm_num [xaProduct2, xaProduct2Value, XCell4_2, ACell2_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct2_eq : xaProduct2 = xaProduct2Value := by
  funext n
  fin_cases n
  · exact xaProduct2_apply_0
  · exact xaProduct2_apply_1
  · exact xaProduct2_apply_2
  · exact xaProduct2_apply_3
  · exact xaProduct2_apply_4
  · exact xaProduct2_apply_5
  · exact xaProduct2_apply_6
  · exact xaProduct2_apply_7
  · exact xaProduct2_apply_8
  · exact xaProduct2_apply_9

theorem XAMatrixProduct2 :
    mul (XVec (4 : Fin 10) (2 : Fin 20))
      (AVec (2 : Fin 20) (3 : Fin 10)) = xaProduct2Value := by
  change xaProduct2 = _
  exact xaProduct2_eq

def xaProduct3 : Vec := mul XCell4_3 ACell3_3

def xaProduct3Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (13 / 11 : ℚ)
  | 1 => (196 / 363 : ℚ)
  | 2 => (74 / 363 : ℚ)
  | 3 => (20 / 33 : ℚ)
  | 4 => (62 / 121 : ℚ)
  | 5 => (118 / 363 : ℚ)
  | 6 => (10 / 121 : ℚ)
  | 7 => (19 / 121 : ℚ)
  | 8 => (137 / 121 : ℚ)
  | 9 => (46 / 121 : ℚ)
  | _ => 0

theorem xaProduct3_apply_0 :
    xaProduct3 (0 : Fin 10) = xaProduct3Value (0 : Fin 10) := by
  norm_num [xaProduct3, xaProduct3Value, XCell4_3, ACell3_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct3_apply_1 :
    xaProduct3 (1 : Fin 10) = xaProduct3Value (1 : Fin 10) := by
  norm_num [xaProduct3, xaProduct3Value, XCell4_3, ACell3_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct3_apply_2 :
    xaProduct3 (2 : Fin 10) = xaProduct3Value (2 : Fin 10) := by
  norm_num [xaProduct3, xaProduct3Value, XCell4_3, ACell3_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct3_apply_3 :
    xaProduct3 (3 : Fin 10) = xaProduct3Value (3 : Fin 10) := by
  norm_num [xaProduct3, xaProduct3Value, XCell4_3, ACell3_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct3_apply_4 :
    xaProduct3 (4 : Fin 10) = xaProduct3Value (4 : Fin 10) := by
  norm_num [xaProduct3, xaProduct3Value, XCell4_3, ACell3_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct3_apply_5 :
    xaProduct3 (5 : Fin 10) = xaProduct3Value (5 : Fin 10) := by
  norm_num [xaProduct3, xaProduct3Value, XCell4_3, ACell3_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct3_apply_6 :
    xaProduct3 (6 : Fin 10) = xaProduct3Value (6 : Fin 10) := by
  norm_num [xaProduct3, xaProduct3Value, XCell4_3, ACell3_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct3_apply_7 :
    xaProduct3 (7 : Fin 10) = xaProduct3Value (7 : Fin 10) := by
  norm_num [xaProduct3, xaProduct3Value, XCell4_3, ACell3_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct3_apply_8 :
    xaProduct3 (8 : Fin 10) = xaProduct3Value (8 : Fin 10) := by
  norm_num [xaProduct3, xaProduct3Value, XCell4_3, ACell3_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct3_apply_9 :
    xaProduct3 (9 : Fin 10) = xaProduct3Value (9 : Fin 10) := by
  norm_num [xaProduct3, xaProduct3Value, XCell4_3, ACell3_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct3_eq : xaProduct3 = xaProduct3Value := by
  funext n
  fin_cases n
  · exact xaProduct3_apply_0
  · exact xaProduct3_apply_1
  · exact xaProduct3_apply_2
  · exact xaProduct3_apply_3
  · exact xaProduct3_apply_4
  · exact xaProduct3_apply_5
  · exact xaProduct3_apply_6
  · exact xaProduct3_apply_7
  · exact xaProduct3_apply_8
  · exact xaProduct3_apply_9

theorem XAMatrixProduct3 :
    mul (XVec (4 : Fin 10) (3 : Fin 20))
      (AVec (3 : Fin 20) (3 : Fin 10)) = xaProduct3Value := by
  change xaProduct3 = _
  exact xaProduct3_eq

def xaProduct4 : Vec := mul XCell4_4 ACell4_3

def xaProduct4Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-17 / 121 : ℚ)
  | 1 => (14 / 363 : ℚ)
  | 2 => (-28 / 363 : ℚ)
  | 3 => (40 / 363 : ℚ)
  | 4 => (-49 / 363 : ℚ)
  | 5 => (7 / 121 : ℚ)
  | 6 => (71 / 363 : ℚ)
  | 7 => (-1 / 363 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (71 / 363 : ℚ)
  | _ => 0

theorem xaProduct4_apply_0 :
    xaProduct4 (0 : Fin 10) = xaProduct4Value (0 : Fin 10) := by
  norm_num [xaProduct4, xaProduct4Value, XCell4_4, ACell4_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct4_apply_1 :
    xaProduct4 (1 : Fin 10) = xaProduct4Value (1 : Fin 10) := by
  norm_num [xaProduct4, xaProduct4Value, XCell4_4, ACell4_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct4_apply_2 :
    xaProduct4 (2 : Fin 10) = xaProduct4Value (2 : Fin 10) := by
  norm_num [xaProduct4, xaProduct4Value, XCell4_4, ACell4_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct4_apply_3 :
    xaProduct4 (3 : Fin 10) = xaProduct4Value (3 : Fin 10) := by
  norm_num [xaProduct4, xaProduct4Value, XCell4_4, ACell4_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct4_apply_4 :
    xaProduct4 (4 : Fin 10) = xaProduct4Value (4 : Fin 10) := by
  norm_num [xaProduct4, xaProduct4Value, XCell4_4, ACell4_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct4_apply_5 :
    xaProduct4 (5 : Fin 10) = xaProduct4Value (5 : Fin 10) := by
  norm_num [xaProduct4, xaProduct4Value, XCell4_4, ACell4_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct4_apply_6 :
    xaProduct4 (6 : Fin 10) = xaProduct4Value (6 : Fin 10) := by
  norm_num [xaProduct4, xaProduct4Value, XCell4_4, ACell4_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct4_apply_7 :
    xaProduct4 (7 : Fin 10) = xaProduct4Value (7 : Fin 10) := by
  norm_num [xaProduct4, xaProduct4Value, XCell4_4, ACell4_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct4_apply_8 :
    xaProduct4 (8 : Fin 10) = xaProduct4Value (8 : Fin 10) := by
  norm_num [xaProduct4, xaProduct4Value, XCell4_4, ACell4_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct4_apply_9 :
    xaProduct4 (9 : Fin 10) = xaProduct4Value (9 : Fin 10) := by
  norm_num [xaProduct4, xaProduct4Value, XCell4_4, ACell4_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct4_eq : xaProduct4 = xaProduct4Value := by
  funext n
  fin_cases n
  · exact xaProduct4_apply_0
  · exact xaProduct4_apply_1
  · exact xaProduct4_apply_2
  · exact xaProduct4_apply_3
  · exact xaProduct4_apply_4
  · exact xaProduct4_apply_5
  · exact xaProduct4_apply_6
  · exact xaProduct4_apply_7
  · exact xaProduct4_apply_8
  · exact xaProduct4_apply_9

theorem XAMatrixProduct4 :
    mul (XVec (4 : Fin 10) (4 : Fin 20))
      (AVec (4 : Fin 20) (3 : Fin 10)) = xaProduct4Value := by
  change xaProduct4 = _
  exact xaProduct4_eq

def xaProduct5 : Vec := mul XCell4_5 ACell5_3

def xaProduct5Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-25 / 121 : ℚ)
  | 1 => (1 / 121 : ℚ)
  | 2 => (-17 / 121 : ℚ)
  | 3 => (-9 / 121 : ℚ)
  | 4 => (-4 / 121 : ℚ)
  | 5 => (-31 / 121 : ℚ)
  | 6 => (13 / 121 : ℚ)
  | 7 => 0
  | 8 => (-3 / 11 : ℚ)
  | 9 => (-5 / 121 : ℚ)
  | _ => 0

theorem xaProduct5_apply_0 :
    xaProduct5 (0 : Fin 10) = xaProduct5Value (0 : Fin 10) := by
  norm_num [xaProduct5, xaProduct5Value, XCell4_5, ACell5_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct5_apply_1 :
    xaProduct5 (1 : Fin 10) = xaProduct5Value (1 : Fin 10) := by
  norm_num [xaProduct5, xaProduct5Value, XCell4_5, ACell5_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct5_apply_2 :
    xaProduct5 (2 : Fin 10) = xaProduct5Value (2 : Fin 10) := by
  norm_num [xaProduct5, xaProduct5Value, XCell4_5, ACell5_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct5_apply_3 :
    xaProduct5 (3 : Fin 10) = xaProduct5Value (3 : Fin 10) := by
  norm_num [xaProduct5, xaProduct5Value, XCell4_5, ACell5_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct5_apply_4 :
    xaProduct5 (4 : Fin 10) = xaProduct5Value (4 : Fin 10) := by
  norm_num [xaProduct5, xaProduct5Value, XCell4_5, ACell5_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct5_apply_5 :
    xaProduct5 (5 : Fin 10) = xaProduct5Value (5 : Fin 10) := by
  norm_num [xaProduct5, xaProduct5Value, XCell4_5, ACell5_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct5_apply_6 :
    xaProduct5 (6 : Fin 10) = xaProduct5Value (6 : Fin 10) := by
  norm_num [xaProduct5, xaProduct5Value, XCell4_5, ACell5_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct5_apply_7 :
    xaProduct5 (7 : Fin 10) = xaProduct5Value (7 : Fin 10) := by
  norm_num [xaProduct5, xaProduct5Value, XCell4_5, ACell5_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct5_apply_8 :
    xaProduct5 (8 : Fin 10) = xaProduct5Value (8 : Fin 10) := by
  norm_num [xaProduct5, xaProduct5Value, XCell4_5, ACell5_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct5_apply_9 :
    xaProduct5 (9 : Fin 10) = xaProduct5Value (9 : Fin 10) := by
  norm_num [xaProduct5, xaProduct5Value, XCell4_5, ACell5_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct5_eq : xaProduct5 = xaProduct5Value := by
  funext n
  fin_cases n
  · exact xaProduct5_apply_0
  · exact xaProduct5_apply_1
  · exact xaProduct5_apply_2
  · exact xaProduct5_apply_3
  · exact xaProduct5_apply_4
  · exact xaProduct5_apply_5
  · exact xaProduct5_apply_6
  · exact xaProduct5_apply_7
  · exact xaProduct5_apply_8
  · exact xaProduct5_apply_9

theorem XAMatrixProduct5 :
    mul (XVec (4 : Fin 10) (5 : Fin 20))
      (AVec (5 : Fin 20) (3 : Fin 10)) = xaProduct5Value := by
  change xaProduct5 = _
  exact xaProduct5_eq

def xaProduct6 : Vec := mul XCell4_6 ACell6_3

def xaProduct6Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-82 / 121 : ℚ)
  | 1 => (-10 / 121 : ℚ)
  | 2 => (-1 / 11 : ℚ)
  | 3 => (-59 / 121 : ℚ)
  | 4 => (4 / 121 : ℚ)
  | 5 => (-27 / 121 : ℚ)
  | 6 => (-27 / 121 : ℚ)
  | 7 => (8 / 121 : ℚ)
  | 8 => (-72 / 121 : ℚ)
  | 9 => (-21 / 121 : ℚ)
  | _ => 0

theorem xaProduct6_apply_0 :
    xaProduct6 (0 : Fin 10) = xaProduct6Value (0 : Fin 10) := by
  norm_num [xaProduct6, xaProduct6Value, XCell4_6, ACell6_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct6_apply_1 :
    xaProduct6 (1 : Fin 10) = xaProduct6Value (1 : Fin 10) := by
  norm_num [xaProduct6, xaProduct6Value, XCell4_6, ACell6_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct6_apply_2 :
    xaProduct6 (2 : Fin 10) = xaProduct6Value (2 : Fin 10) := by
  norm_num [xaProduct6, xaProduct6Value, XCell4_6, ACell6_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct6_apply_3 :
    xaProduct6 (3 : Fin 10) = xaProduct6Value (3 : Fin 10) := by
  norm_num [xaProduct6, xaProduct6Value, XCell4_6, ACell6_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct6_apply_4 :
    xaProduct6 (4 : Fin 10) = xaProduct6Value (4 : Fin 10) := by
  norm_num [xaProduct6, xaProduct6Value, XCell4_6, ACell6_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct6_apply_5 :
    xaProduct6 (5 : Fin 10) = xaProduct6Value (5 : Fin 10) := by
  norm_num [xaProduct6, xaProduct6Value, XCell4_6, ACell6_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct6_apply_6 :
    xaProduct6 (6 : Fin 10) = xaProduct6Value (6 : Fin 10) := by
  norm_num [xaProduct6, xaProduct6Value, XCell4_6, ACell6_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct6_apply_7 :
    xaProduct6 (7 : Fin 10) = xaProduct6Value (7 : Fin 10) := by
  norm_num [xaProduct6, xaProduct6Value, XCell4_6, ACell6_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct6_apply_8 :
    xaProduct6 (8 : Fin 10) = xaProduct6Value (8 : Fin 10) := by
  norm_num [xaProduct6, xaProduct6Value, XCell4_6, ACell6_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct6_apply_9 :
    xaProduct6 (9 : Fin 10) = xaProduct6Value (9 : Fin 10) := by
  norm_num [xaProduct6, xaProduct6Value, XCell4_6, ACell6_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct6_eq : xaProduct6 = xaProduct6Value := by
  funext n
  fin_cases n
  · exact xaProduct6_apply_0
  · exact xaProduct6_apply_1
  · exact xaProduct6_apply_2
  · exact xaProduct6_apply_3
  · exact xaProduct6_apply_4
  · exact xaProduct6_apply_5
  · exact xaProduct6_apply_6
  · exact xaProduct6_apply_7
  · exact xaProduct6_apply_8
  · exact xaProduct6_apply_9

theorem XAMatrixProduct6 :
    mul (XVec (4 : Fin 10) (6 : Fin 20))
      (AVec (6 : Fin 20) (3 : Fin 10)) = xaProduct6Value := by
  change xaProduct6 = _
  exact xaProduct6_eq

def xaProduct7 : Vec := mul XCell4_7 ACell7_3

def xaProduct7Value (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-5 / 121 : ℚ)
  | 1 => (-29 / 121 : ℚ)
  | 2 => (-25 / 121 : ℚ)
  | 3 => (10 / 121 : ℚ)
  | 4 => (-9 / 121 : ℚ)
  | 5 => (-13 / 121 : ℚ)
  | 6 => (1 / 121 : ℚ)
  | 7 => (-19 / 121 : ℚ)
  | 8 => (-26 / 121 : ℚ)
  | 9 => (-6 / 121 : ℚ)
  | _ => 0

theorem xaProduct7_apply_0 :
    xaProduct7 (0 : Fin 10) = xaProduct7Value (0 : Fin 10) := by
  norm_num [xaProduct7, xaProduct7Value, XCell4_7, ACell7_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct7_apply_1 :
    xaProduct7 (1 : Fin 10) = xaProduct7Value (1 : Fin 10) := by
  norm_num [xaProduct7, xaProduct7Value, XCell4_7, ACell7_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct7_apply_2 :
    xaProduct7 (2 : Fin 10) = xaProduct7Value (2 : Fin 10) := by
  norm_num [xaProduct7, xaProduct7Value, XCell4_7, ACell7_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct7_apply_3 :
    xaProduct7 (3 : Fin 10) = xaProduct7Value (3 : Fin 10) := by
  norm_num [xaProduct7, xaProduct7Value, XCell4_7, ACell7_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct7_apply_4 :
    xaProduct7 (4 : Fin 10) = xaProduct7Value (4 : Fin 10) := by
  norm_num [xaProduct7, xaProduct7Value, XCell4_7, ACell7_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct7_apply_5 :
    xaProduct7 (5 : Fin 10) = xaProduct7Value (5 : Fin 10) := by
  norm_num [xaProduct7, xaProduct7Value, XCell4_7, ACell7_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct7_apply_6 :
    xaProduct7 (6 : Fin 10) = xaProduct7Value (6 : Fin 10) := by
  norm_num [xaProduct7, xaProduct7Value, XCell4_7, ACell7_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct7_apply_7 :
    xaProduct7 (7 : Fin 10) = xaProduct7Value (7 : Fin 10) := by
  norm_num [xaProduct7, xaProduct7Value, XCell4_7, ACell7_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct7_apply_8 :
    xaProduct7 (8 : Fin 10) = xaProduct7Value (8 : Fin 10) := by
  norm_num [xaProduct7, xaProduct7Value, XCell4_7, ACell7_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct7_apply_9 :
    xaProduct7 (9 : Fin 10) = xaProduct7Value (9 : Fin 10) := by
  norm_num [xaProduct7, xaProduct7Value, XCell4_7, ACell7_3,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem xaProduct7_eq : xaProduct7 = xaProduct7Value := by
  funext n
  fin_cases n
  · exact xaProduct7_apply_0
  · exact xaProduct7_apply_1
  · exact xaProduct7_apply_2
  · exact xaProduct7_apply_3
  · exact xaProduct7_apply_4
  · exact xaProduct7_apply_5
  · exact xaProduct7_apply_6
  · exact xaProduct7_apply_7
  · exact xaProduct7_apply_8
  · exact xaProduct7_apply_9

theorem XAMatrixProduct7 :
    mul (XVec (4 : Fin 10) (7 : Fin 20))
      (AVec (7 : Fin 20) (3 : Fin 10)) = xaProduct7Value := by
  change xaProduct7 = _
  exact xaProduct7_eq

def xaProduct8 : Vec := mul XCell4_8 ACell8_3

theorem xaProduct8_left_eq_zero : XCell4_8 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct8_eq : xaProduct8 = 0 := by
  rw [xaProduct8, xaProduct8_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct8 :
    mul (XVec (4 : Fin 10) (8 : Fin 20))
      (AVec (8 : Fin 20) (3 : Fin 10)) = 0 := by
  change xaProduct8 = _
  exact xaProduct8_eq

def xaProduct9 : Vec := mul XCell4_9 ACell9_3

theorem xaProduct9_left_eq_zero : XCell4_9 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct9_eq : xaProduct9 = 0 := by
  rw [xaProduct9, xaProduct9_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct9 :
    mul (XVec (4 : Fin 10) (9 : Fin 20))
      (AVec (9 : Fin 20) (3 : Fin 10)) = 0 := by
  change xaProduct9 = _
  exact xaProduct9_eq

def xaProduct10 : Vec := mul XCell4_10 ACell10_3

theorem xaProduct10_left_eq_zero : XCell4_10 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct10_eq : xaProduct10 = 0 := by
  rw [xaProduct10, xaProduct10_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct10 :
    mul (XVec (4 : Fin 10) (10 : Fin 20))
      (AVec (10 : Fin 20) (3 : Fin 10)) = 0 := by
  change xaProduct10 = _
  exact xaProduct10_eq

def xaProduct11 : Vec := mul XCell4_11 ACell11_3

theorem xaProduct11_left_eq_zero : XCell4_11 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct11_eq : xaProduct11 = 0 := by
  rw [xaProduct11, xaProduct11_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct11 :
    mul (XVec (4 : Fin 10) (11 : Fin 20))
      (AVec (11 : Fin 20) (3 : Fin 10)) = 0 := by
  change xaProduct11 = _
  exact xaProduct11_eq

def xaProduct12 : Vec := mul XCell4_12 ACell12_3

theorem xaProduct12_left_eq_zero : XCell4_12 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct12_eq : xaProduct12 = 0 := by
  rw [xaProduct12, xaProduct12_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct12 :
    mul (XVec (4 : Fin 10) (12 : Fin 20))
      (AVec (12 : Fin 20) (3 : Fin 10)) = 0 := by
  change xaProduct12 = _
  exact xaProduct12_eq

def xaProduct13 : Vec := mul XCell4_13 ACell13_3

theorem xaProduct13_left_eq_zero : XCell4_13 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct13_eq : xaProduct13 = 0 := by
  rw [xaProduct13, xaProduct13_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct13 :
    mul (XVec (4 : Fin 10) (13 : Fin 20))
      (AVec (13 : Fin 20) (3 : Fin 10)) = 0 := by
  change xaProduct13 = _
  exact xaProduct13_eq

def xaProduct14 : Vec := mul XCell4_14 ACell14_3

theorem xaProduct14_left_eq_zero : XCell4_14 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct14_eq : xaProduct14 = 0 := by
  rw [xaProduct14, xaProduct14_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct14 :
    mul (XVec (4 : Fin 10) (14 : Fin 20))
      (AVec (14 : Fin 20) (3 : Fin 10)) = 0 := by
  change xaProduct14 = _
  exact xaProduct14_eq

def xaProduct15 : Vec := mul XCell4_15 ACell15_3

theorem xaProduct15_left_eq_zero : XCell4_15 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct15_eq : xaProduct15 = 0 := by
  rw [xaProduct15, xaProduct15_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct15 :
    mul (XVec (4 : Fin 10) (15 : Fin 20))
      (AVec (15 : Fin 20) (3 : Fin 10)) = 0 := by
  change xaProduct15 = _
  exact xaProduct15_eq

def xaProduct16 : Vec := mul XCell4_16 ACell16_3

theorem xaProduct16_left_eq_zero : XCell4_16 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct16_eq : xaProduct16 = 0 := by
  rw [xaProduct16, xaProduct16_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct16 :
    mul (XVec (4 : Fin 10) (16 : Fin 20))
      (AVec (16 : Fin 20) (3 : Fin 10)) = 0 := by
  change xaProduct16 = _
  exact xaProduct16_eq

def xaProduct17 : Vec := mul XCell4_17 ACell17_3

theorem xaProduct17_left_eq_zero : XCell4_17 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct17_eq : xaProduct17 = 0 := by
  rw [xaProduct17, xaProduct17_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct17 :
    mul (XVec (4 : Fin 10) (17 : Fin 20))
      (AVec (17 : Fin 20) (3 : Fin 10)) = 0 := by
  change xaProduct17 = _
  exact xaProduct17_eq

def xaProduct18 : Vec := mul XCell4_18 ACell18_3

theorem xaProduct18_left_eq_zero : XCell4_18 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct18_eq : xaProduct18 = 0 := by
  rw [xaProduct18, xaProduct18_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct18 :
    mul (XVec (4 : Fin 10) (18 : Fin 20))
      (AVec (18 : Fin 20) (3 : Fin 10)) = 0 := by
  change xaProduct18 = _
  exact xaProduct18_eq

def xaProduct19 : Vec := mul XCell4_19 ACell19_3

theorem xaProduct19_left_eq_zero : XCell4_19 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem xaProduct19_eq : xaProduct19 = 0 := by
  rw [xaProduct19, xaProduct19_left_eq_zero, mul_zero_left]

theorem XAMatrixProduct19 :
    mul (XVec (4 : Fin 10) (19 : Fin 20))
      (AVec (19 : Fin 20) (3 : Fin 10)) = 0 := by
  change xaProduct19 = _
  exact xaProduct19_eq

def XAMatrixTerm (k : Fin 20) : Vec :=
  mul (XVec (4 : Fin 10) k) (AVec k (3 : Fin 10))

def XAResult (k : Fin 20) : Vec :=
  match k.val with
  | 0 => xaProduct0Value
  | 1 => xaProduct1Value
  | 2 => xaProduct2Value
  | 3 => xaProduct3Value
  | 4 => xaProduct4Value
  | 5 => xaProduct5Value
  | 6 => xaProduct6Value
  | 7 => xaProduct7Value
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
  norm_num [XAResult, Fin.sum_univ_succ,
    xaProduct0Value,
    xaProduct1Value,
    xaProduct2Value,
    xaProduct3Value,
    xaProduct4Value,
    xaProduct5Value,
    xaProduct6Value,
    xaProduct7Value]

theorem XAResult_sum_apply_1 :
    (∑ k : Fin 20, XAResult k) (1 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ,
    xaProduct0Value,
    xaProduct1Value,
    xaProduct2Value,
    xaProduct3Value,
    xaProduct4Value,
    xaProduct5Value,
    xaProduct6Value,
    xaProduct7Value]

theorem XAResult_sum_apply_2 :
    (∑ k : Fin 20, XAResult k) (2 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ,
    xaProduct0Value,
    xaProduct1Value,
    xaProduct2Value,
    xaProduct3Value,
    xaProduct4Value,
    xaProduct5Value,
    xaProduct6Value,
    xaProduct7Value]

theorem XAResult_sum_apply_3 :
    (∑ k : Fin 20, XAResult k) (3 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ,
    xaProduct0Value,
    xaProduct1Value,
    xaProduct2Value,
    xaProduct3Value,
    xaProduct4Value,
    xaProduct5Value,
    xaProduct6Value,
    xaProduct7Value]

theorem XAResult_sum_apply_4 :
    (∑ k : Fin 20, XAResult k) (4 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ,
    xaProduct0Value,
    xaProduct1Value,
    xaProduct2Value,
    xaProduct3Value,
    xaProduct4Value,
    xaProduct5Value,
    xaProduct6Value,
    xaProduct7Value]

theorem XAResult_sum_apply_5 :
    (∑ k : Fin 20, XAResult k) (5 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ,
    xaProduct0Value,
    xaProduct1Value,
    xaProduct2Value,
    xaProduct3Value,
    xaProduct4Value,
    xaProduct5Value,
    xaProduct6Value,
    xaProduct7Value]

theorem XAResult_sum_apply_6 :
    (∑ k : Fin 20, XAResult k) (6 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ,
    xaProduct0Value,
    xaProduct1Value,
    xaProduct2Value,
    xaProduct3Value,
    xaProduct4Value,
    xaProduct5Value,
    xaProduct6Value,
    xaProduct7Value]

theorem XAResult_sum_apply_7 :
    (∑ k : Fin 20, XAResult k) (7 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ,
    xaProduct0Value,
    xaProduct1Value,
    xaProduct2Value,
    xaProduct3Value,
    xaProduct4Value,
    xaProduct5Value,
    xaProduct6Value,
    xaProduct7Value]

theorem XAResult_sum_apply_8 :
    (∑ k : Fin 20, XAResult k) (8 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ,
    xaProduct0Value,
    xaProduct1Value,
    xaProduct2Value,
    xaProduct3Value,
    xaProduct4Value,
    xaProduct5Value,
    xaProduct6Value,
    xaProduct7Value]

theorem XAResult_sum_apply_9 :
    (∑ k : Fin 20, XAResult k) (9 : Fin 10) =
      0 := by
  norm_num [XAResult, Fin.sum_univ_succ,
    xaProduct0Value,
    xaProduct1Value,
    xaProduct2Value,
    xaProduct3Value,
    xaProduct4Value,
    xaProduct5Value,
    xaProduct6Value,
    xaProduct7Value]

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

def kyProduct0 : Vec := mul KCell4_0 YCell0_3

theorem kyProduct0_right_eq_zero : YCell0_3 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem kyProduct0_eq : kyProduct0 = 0 := by
  rw [kyProduct0, kyProduct0_right_eq_zero, mul_zero_right]

theorem KYMatrixProduct0 :
    mul (KVec (4 : Fin 10) (0 : Fin 2))
      (YVec (0 : Fin 2) (3 : Fin 10)) = 0 := by
  change kyProduct0 = _
  exact kyProduct0_eq

def kyProduct1 : Vec := mul KCell4_1 YCell1_3

theorem kyProduct1_right_eq_zero : YCell1_3 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem kyProduct1_eq : kyProduct1 = 0 := by
  rw [kyProduct1, kyProduct1_right_eq_zero, mul_zero_right]

theorem KYMatrixProduct1 :
    mul (KVec (4 : Fin 10) (1 : Fin 2))
      (YVec (1 : Fin 2) (3 : Fin 10)) = 0 := by
  change kyProduct1 = _
  exact kyProduct1_eq

def KYMatrixTerm (k : Fin 2) : Vec :=
  mul (KVec (4 : Fin 10) k) (YVec k (3 : Fin 10))

def KYResult (k : Fin 2) : Vec :=
  match k.val with
  | 0 => 0
  | 1 => 0
  | _ => 0

theorem KYMatrixProduct (k : Fin 2) :
    KYMatrixTerm k = KYResult k := by
  fin_cases k
  · exact KYMatrixProduct0
  · exact KYMatrixProduct1

theorem KYMatrixTerm_sum_eq :
    (∑ k : Fin 2, KYMatrixTerm k) =
      ∑ k : Fin 2, KYResult k := by
  apply Finset.sum_congr rfl
  intro k _
  exact KYMatrixProduct k

theorem KYResult_sum_apply_0 :
    (∑ k : Fin 2, KYResult k) (0 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_1 :
    (∑ k : Fin 2, KYResult k) (1 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_2 :
    (∑ k : Fin 2, KYResult k) (2 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_3 :
    (∑ k : Fin 2, KYResult k) (3 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_4 :
    (∑ k : Fin 2, KYResult k) (4 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_5 :
    (∑ k : Fin 2, KYResult k) (5 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_6 :
    (∑ k : Fin 2, KYResult k) (6 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_7 :
    (∑ k : Fin 2, KYResult k) (7 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_8 :
    (∑ k : Fin 2, KYResult k) (8 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_apply_9 :
    (∑ k : Fin 2, KYResult k) (9 : Fin 10) =
      0 := by
  norm_num [KYResult, Fin.sum_univ_succ]

theorem KYResult_sum_eq :
    (∑ k : Fin 2, KYResult k) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
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
        (4 : Fin 10) (3 : Fin 10) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  change (∑ k : Fin 20, XAMatrixTerm k) +
    (∑ k : Fin 2, KYMatrixTerm k) = _
  rw [XAMatrixTerm_sum_eq, KYMatrixTerm_sum_eq,
    XAResult_sum_eq, KYResult_sum_eq]
  funext n
  fin_cases n <;> norm_num

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec + matrixMul KVec YVec)
        (4 : Fin 10) (3 : Fin 10) =
      matrixOne (Fin 10) (4 : Fin 10) (3 : Fin 10) := by
  rw [entry_eq]
  have hne : (4 : Fin 10) ≠ (3 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePPSplitEntry4_3
