/- PA split identity, entry (2,4). Auto-generated. -/
import V14Formalization.D12PiecePAData

noncomputable section
open Matrix
namespace V14Formalization.D12PiecePASplitEntry2_4
open D12CyclotomicVec D12PiecePAData
def payloadSha256 : String := "76c6196f29afe1a8398af99502447f48ebeed4bcb3805fc5dbec693940bc04b0"

def product0 : Vec := mul XCell2_0 ACell0_4

def productValue0 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 22 : ℚ)
  | 1 => (-1 / 242 : ℚ)
  | 2 => (1 / 22 : ℚ)
  | 3 => (7 / 242 : ℚ)
  | 4 => (13 / 242 : ℚ)
  | 5 => (-45 / 242 : ℚ)
  | 6 => (-6 / 121 : ℚ)
  | 7 => (-1 / 22 : ℚ)
  | 8 => (9 / 121 : ℚ)
  | 9 => (9 / 242 : ℚ)
  | _ => 0

theorem product0_apply_0 :
    product0 (0 : Fin 10) =
      productValue0 (0 : Fin 10) := by
  norm_num [product0, productValue0, XCell2_0, ACell0_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product0_apply_1 :
    product0 (1 : Fin 10) =
      productValue0 (1 : Fin 10) := by
  norm_num [product0, productValue0, XCell2_0, ACell0_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product0_apply_2 :
    product0 (2 : Fin 10) =
      productValue0 (2 : Fin 10) := by
  norm_num [product0, productValue0, XCell2_0, ACell0_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product0_apply_3 :
    product0 (3 : Fin 10) =
      productValue0 (3 : Fin 10) := by
  norm_num [product0, productValue0, XCell2_0, ACell0_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product0_apply_4 :
    product0 (4 : Fin 10) =
      productValue0 (4 : Fin 10) := by
  norm_num [product0, productValue0, XCell2_0, ACell0_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product0_apply_5 :
    product0 (5 : Fin 10) =
      productValue0 (5 : Fin 10) := by
  norm_num [product0, productValue0, XCell2_0, ACell0_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product0_apply_6 :
    product0 (6 : Fin 10) =
      productValue0 (6 : Fin 10) := by
  norm_num [product0, productValue0, XCell2_0, ACell0_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product0_apply_7 :
    product0 (7 : Fin 10) =
      productValue0 (7 : Fin 10) := by
  norm_num [product0, productValue0, XCell2_0, ACell0_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product0_apply_8 :
    product0 (8 : Fin 10) =
      productValue0 (8 : Fin 10) := by
  norm_num [product0, productValue0, XCell2_0, ACell0_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product0_apply_9 :
    product0 (9 : Fin 10) =
      productValue0 (9 : Fin 10) := by
  norm_num [product0, productValue0, XCell2_0, ACell0_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product0_eq : product0 = productValue0 := by
  funext n
  fin_cases n
  · exact product0_apply_0
  · exact product0_apply_1
  · exact product0_apply_2
  · exact product0_apply_3
  · exact product0_apply_4
  · exact product0_apply_5
  · exact product0_apply_6
  · exact product0_apply_7
  · exact product0_apply_8
  · exact product0_apply_9

theorem matrixProduct0_eq :
    mul (XVec (2 : Fin 10) (0 : Fin 20))
      (AVec (0 : Fin 20) (4 : Fin 10)) = productValue0 := by
  change product0 = _
  exact product0_eq

def product1 : Vec := mul XCell2_1 ACell1_4

def productValue1 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 121 : ℚ)
  | 1 => (14 / 121 : ℚ)
  | 2 => (3 / 242 : ℚ)
  | 3 => (-10 / 121 : ℚ)
  | 4 => (-6 / 121 : ℚ)
  | 5 => (6 / 121 : ℚ)
  | 6 => (-8 / 121 : ℚ)
  | 7 => (-3 / 121 : ℚ)
  | 8 => (14 / 121 : ℚ)
  | 9 => (18 / 121 : ℚ)
  | _ => 0

theorem product1_apply_0 :
    product1 (0 : Fin 10) =
      productValue1 (0 : Fin 10) := by
  norm_num [product1, productValue1, XCell2_1, ACell1_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product1_apply_1 :
    product1 (1 : Fin 10) =
      productValue1 (1 : Fin 10) := by
  norm_num [product1, productValue1, XCell2_1, ACell1_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product1_apply_2 :
    product1 (2 : Fin 10) =
      productValue1 (2 : Fin 10) := by
  norm_num [product1, productValue1, XCell2_1, ACell1_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product1_apply_3 :
    product1 (3 : Fin 10) =
      productValue1 (3 : Fin 10) := by
  norm_num [product1, productValue1, XCell2_1, ACell1_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product1_apply_4 :
    product1 (4 : Fin 10) =
      productValue1 (4 : Fin 10) := by
  norm_num [product1, productValue1, XCell2_1, ACell1_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product1_apply_5 :
    product1 (5 : Fin 10) =
      productValue1 (5 : Fin 10) := by
  norm_num [product1, productValue1, XCell2_1, ACell1_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product1_apply_6 :
    product1 (6 : Fin 10) =
      productValue1 (6 : Fin 10) := by
  norm_num [product1, productValue1, XCell2_1, ACell1_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product1_apply_7 :
    product1 (7 : Fin 10) =
      productValue1 (7 : Fin 10) := by
  norm_num [product1, productValue1, XCell2_1, ACell1_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product1_apply_8 :
    product1 (8 : Fin 10) =
      productValue1 (8 : Fin 10) := by
  norm_num [product1, productValue1, XCell2_1, ACell1_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product1_apply_9 :
    product1 (9 : Fin 10) =
      productValue1 (9 : Fin 10) := by
  norm_num [product1, productValue1, XCell2_1, ACell1_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product1_eq : product1 = productValue1 := by
  funext n
  fin_cases n
  · exact product1_apply_0
  · exact product1_apply_1
  · exact product1_apply_2
  · exact product1_apply_3
  · exact product1_apply_4
  · exact product1_apply_5
  · exact product1_apply_6
  · exact product1_apply_7
  · exact product1_apply_8
  · exact product1_apply_9

theorem matrixProduct1_eq :
    mul (XVec (2 : Fin 10) (1 : Fin 20))
      (AVec (1 : Fin 20) (4 : Fin 10)) = productValue1 := by
  change product1 = _
  exact product1_eq

def product2 : Vec := mul XCell2_2 ACell2_4

def productValue2 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (63 / 242 : ℚ)
  | 1 => (30 / 121 : ℚ)
  | 2 => (3 / 242 : ℚ)
  | 3 => (-19 / 242 : ℚ)
  | 4 => (59 / 242 : ℚ)
  | 5 => (67 / 242 : ℚ)
  | 6 => (8 / 121 : ℚ)
  | 7 => (4 / 121 : ℚ)
  | 8 => (47 / 242 : ℚ)
  | 9 => (13 / 121 : ℚ)
  | _ => 0

theorem product2_apply_0 :
    product2 (0 : Fin 10) =
      productValue2 (0 : Fin 10) := by
  norm_num [product2, productValue2, XCell2_2, ACell2_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product2_apply_1 :
    product2 (1 : Fin 10) =
      productValue2 (1 : Fin 10) := by
  norm_num [product2, productValue2, XCell2_2, ACell2_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product2_apply_2 :
    product2 (2 : Fin 10) =
      productValue2 (2 : Fin 10) := by
  norm_num [product2, productValue2, XCell2_2, ACell2_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product2_apply_3 :
    product2 (3 : Fin 10) =
      productValue2 (3 : Fin 10) := by
  norm_num [product2, productValue2, XCell2_2, ACell2_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product2_apply_4 :
    product2 (4 : Fin 10) =
      productValue2 (4 : Fin 10) := by
  norm_num [product2, productValue2, XCell2_2, ACell2_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product2_apply_5 :
    product2 (5 : Fin 10) =
      productValue2 (5 : Fin 10) := by
  norm_num [product2, productValue2, XCell2_2, ACell2_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product2_apply_6 :
    product2 (6 : Fin 10) =
      productValue2 (6 : Fin 10) := by
  norm_num [product2, productValue2, XCell2_2, ACell2_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product2_apply_7 :
    product2 (7 : Fin 10) =
      productValue2 (7 : Fin 10) := by
  norm_num [product2, productValue2, XCell2_2, ACell2_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product2_apply_8 :
    product2 (8 : Fin 10) =
      productValue2 (8 : Fin 10) := by
  norm_num [product2, productValue2, XCell2_2, ACell2_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product2_apply_9 :
    product2 (9 : Fin 10) =
      productValue2 (9 : Fin 10) := by
  norm_num [product2, productValue2, XCell2_2, ACell2_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product2_eq : product2 = productValue2 := by
  funext n
  fin_cases n
  · exact product2_apply_0
  · exact product2_apply_1
  · exact product2_apply_2
  · exact product2_apply_3
  · exact product2_apply_4
  · exact product2_apply_5
  · exact product2_apply_6
  · exact product2_apply_7
  · exact product2_apply_8
  · exact product2_apply_9

theorem matrixProduct2_eq :
    mul (XVec (2 : Fin 10) (2 : Fin 20))
      (AVec (2 : Fin 20) (4 : Fin 10)) = productValue2 := by
  change product2 = _
  exact product2_eq

def product3 : Vec := mul XCell2_3 ACell3_4

def productValue3 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-3 / 121 : ℚ)
  | 1 => (-1 / 11 : ℚ)
  | 2 => (5 / 242 : ℚ)
  | 3 => (-17 / 242 : ℚ)
  | 4 => (-12 / 121 : ℚ)
  | 5 => (-1 / 242 : ℚ)
  | 6 => (-1 / 11 : ℚ)
  | 7 => (-2 / 121 : ℚ)
  | 8 => (-1 / 22 : ℚ)
  | 9 => (-4 / 121 : ℚ)
  | _ => 0

theorem product3_apply_0 :
    product3 (0 : Fin 10) =
      productValue3 (0 : Fin 10) := by
  norm_num [product3, productValue3, XCell2_3, ACell3_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product3_apply_1 :
    product3 (1 : Fin 10) =
      productValue3 (1 : Fin 10) := by
  norm_num [product3, productValue3, XCell2_3, ACell3_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product3_apply_2 :
    product3 (2 : Fin 10) =
      productValue3 (2 : Fin 10) := by
  norm_num [product3, productValue3, XCell2_3, ACell3_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product3_apply_3 :
    product3 (3 : Fin 10) =
      productValue3 (3 : Fin 10) := by
  norm_num [product3, productValue3, XCell2_3, ACell3_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product3_apply_4 :
    product3 (4 : Fin 10) =
      productValue3 (4 : Fin 10) := by
  norm_num [product3, productValue3, XCell2_3, ACell3_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product3_apply_5 :
    product3 (5 : Fin 10) =
      productValue3 (5 : Fin 10) := by
  norm_num [product3, productValue3, XCell2_3, ACell3_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product3_apply_6 :
    product3 (6 : Fin 10) =
      productValue3 (6 : Fin 10) := by
  norm_num [product3, productValue3, XCell2_3, ACell3_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product3_apply_7 :
    product3 (7 : Fin 10) =
      productValue3 (7 : Fin 10) := by
  norm_num [product3, productValue3, XCell2_3, ACell3_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product3_apply_8 :
    product3 (8 : Fin 10) =
      productValue3 (8 : Fin 10) := by
  norm_num [product3, productValue3, XCell2_3, ACell3_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product3_apply_9 :
    product3 (9 : Fin 10) =
      productValue3 (9 : Fin 10) := by
  norm_num [product3, productValue3, XCell2_3, ACell3_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product3_eq : product3 = productValue3 := by
  funext n
  fin_cases n
  · exact product3_apply_0
  · exact product3_apply_1
  · exact product3_apply_2
  · exact product3_apply_3
  · exact product3_apply_4
  · exact product3_apply_5
  · exact product3_apply_6
  · exact product3_apply_7
  · exact product3_apply_8
  · exact product3_apply_9

theorem matrixProduct3_eq :
    mul (XVec (2 : Fin 10) (3 : Fin 20))
      (AVec (3 : Fin 20) (4 : Fin 10)) = productValue3 := by
  change product3 = _
  exact product3_eq

def product4 : Vec := mul XCell2_4 ACell4_4

def productValue4 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (51 / 242 : ℚ)
  | 1 => (-49 / 121 : ℚ)
  | 2 => (-34 / 121 : ℚ)
  | 3 => (151 / 242 : ℚ)
  | 4 => (38 / 121 : ℚ)
  | 5 => (-64 / 121 : ℚ)
  | 6 => (-3 / 242 : ℚ)
  | 7 => (7 / 11 : ℚ)
  | 8 => (-15 / 121 : ℚ)
  | 9 => (-69 / 121 : ℚ)
  | _ => 0

theorem product4_apply_0 :
    product4 (0 : Fin 10) =
      productValue4 (0 : Fin 10) := by
  norm_num [product4, productValue4, XCell2_4, ACell4_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product4_apply_1 :
    product4 (1 : Fin 10) =
      productValue4 (1 : Fin 10) := by
  norm_num [product4, productValue4, XCell2_4, ACell4_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product4_apply_2 :
    product4 (2 : Fin 10) =
      productValue4 (2 : Fin 10) := by
  norm_num [product4, productValue4, XCell2_4, ACell4_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product4_apply_3 :
    product4 (3 : Fin 10) =
      productValue4 (3 : Fin 10) := by
  norm_num [product4, productValue4, XCell2_4, ACell4_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product4_apply_4 :
    product4 (4 : Fin 10) =
      productValue4 (4 : Fin 10) := by
  norm_num [product4, productValue4, XCell2_4, ACell4_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product4_apply_5 :
    product4 (5 : Fin 10) =
      productValue4 (5 : Fin 10) := by
  norm_num [product4, productValue4, XCell2_4, ACell4_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product4_apply_6 :
    product4 (6 : Fin 10) =
      productValue4 (6 : Fin 10) := by
  norm_num [product4, productValue4, XCell2_4, ACell4_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product4_apply_7 :
    product4 (7 : Fin 10) =
      productValue4 (7 : Fin 10) := by
  norm_num [product4, productValue4, XCell2_4, ACell4_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product4_apply_8 :
    product4 (8 : Fin 10) =
      productValue4 (8 : Fin 10) := by
  norm_num [product4, productValue4, XCell2_4, ACell4_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product4_apply_9 :
    product4 (9 : Fin 10) =
      productValue4 (9 : Fin 10) := by
  norm_num [product4, productValue4, XCell2_4, ACell4_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product4_eq : product4 = productValue4 := by
  funext n
  fin_cases n
  · exact product4_apply_0
  · exact product4_apply_1
  · exact product4_apply_2
  · exact product4_apply_3
  · exact product4_apply_4
  · exact product4_apply_5
  · exact product4_apply_6
  · exact product4_apply_7
  · exact product4_apply_8
  · exact product4_apply_9

theorem matrixProduct4_eq :
    mul (XVec (2 : Fin 10) (4 : Fin 20))
      (AVec (4 : Fin 20) (4 : Fin 10)) = productValue4 := by
  change product4 = _
  exact product4_eq

def product5 : Vec := mul XCell2_5 ACell5_4

def productValue5 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (3 / 242 : ℚ)
  | 1 => (-15 / 242 : ℚ)
  | 2 => (-57 / 242 : ℚ)
  | 3 => (-24 / 121 : ℚ)
  | 4 => (-18 / 121 : ℚ)
  | 5 => (3 / 242 : ℚ)
  | 6 => (-3 / 242 : ℚ)
  | 7 => (-30 / 121 : ℚ)
  | 8 => (-45 / 242 : ℚ)
  | 9 => (-3 / 121 : ℚ)
  | _ => 0

theorem product5_apply_0 :
    product5 (0 : Fin 10) =
      productValue5 (0 : Fin 10) := by
  norm_num [product5, productValue5, XCell2_5, ACell5_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product5_apply_1 :
    product5 (1 : Fin 10) =
      productValue5 (1 : Fin 10) := by
  norm_num [product5, productValue5, XCell2_5, ACell5_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product5_apply_2 :
    product5 (2 : Fin 10) =
      productValue5 (2 : Fin 10) := by
  norm_num [product5, productValue5, XCell2_5, ACell5_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product5_apply_3 :
    product5 (3 : Fin 10) =
      productValue5 (3 : Fin 10) := by
  norm_num [product5, productValue5, XCell2_5, ACell5_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product5_apply_4 :
    product5 (4 : Fin 10) =
      productValue5 (4 : Fin 10) := by
  norm_num [product5, productValue5, XCell2_5, ACell5_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product5_apply_5 :
    product5 (5 : Fin 10) =
      productValue5 (5 : Fin 10) := by
  norm_num [product5, productValue5, XCell2_5, ACell5_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product5_apply_6 :
    product5 (6 : Fin 10) =
      productValue5 (6 : Fin 10) := by
  norm_num [product5, productValue5, XCell2_5, ACell5_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product5_apply_7 :
    product5 (7 : Fin 10) =
      productValue5 (7 : Fin 10) := by
  norm_num [product5, productValue5, XCell2_5, ACell5_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product5_apply_8 :
    product5 (8 : Fin 10) =
      productValue5 (8 : Fin 10) := by
  norm_num [product5, productValue5, XCell2_5, ACell5_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product5_apply_9 :
    product5 (9 : Fin 10) =
      productValue5 (9 : Fin 10) := by
  norm_num [product5, productValue5, XCell2_5, ACell5_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product5_eq : product5 = productValue5 := by
  funext n
  fin_cases n
  · exact product5_apply_0
  · exact product5_apply_1
  · exact product5_apply_2
  · exact product5_apply_3
  · exact product5_apply_4
  · exact product5_apply_5
  · exact product5_apply_6
  · exact product5_apply_7
  · exact product5_apply_8
  · exact product5_apply_9

theorem matrixProduct5_eq :
    mul (XVec (2 : Fin 10) (5 : Fin 20))
      (AVec (5 : Fin 20) (4 : Fin 10)) = productValue5 := by
  change product5 = _
  exact product5_eq

def product6 : Vec := mul XCell2_6 ACell6_4

def productValue6 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-21 / 242 : ℚ)
  | 1 => (15 / 242 : ℚ)
  | 2 => (-3 / 121 : ℚ)
  | 3 => (-27 / 242 : ℚ)
  | 4 => (-6 / 121 : ℚ)
  | 5 => (27 / 242 : ℚ)
  | 6 => (3 / 242 : ℚ)
  | 7 => (-9 / 242 : ℚ)
  | 8 => (18 / 121 : ℚ)
  | 9 => (27 / 242 : ℚ)
  | _ => 0

theorem product6_apply_0 :
    product6 (0 : Fin 10) =
      productValue6 (0 : Fin 10) := by
  norm_num [product6, productValue6, XCell2_6, ACell6_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product6_apply_1 :
    product6 (1 : Fin 10) =
      productValue6 (1 : Fin 10) := by
  norm_num [product6, productValue6, XCell2_6, ACell6_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product6_apply_2 :
    product6 (2 : Fin 10) =
      productValue6 (2 : Fin 10) := by
  norm_num [product6, productValue6, XCell2_6, ACell6_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product6_apply_3 :
    product6 (3 : Fin 10) =
      productValue6 (3 : Fin 10) := by
  norm_num [product6, productValue6, XCell2_6, ACell6_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product6_apply_4 :
    product6 (4 : Fin 10) =
      productValue6 (4 : Fin 10) := by
  norm_num [product6, productValue6, XCell2_6, ACell6_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product6_apply_5 :
    product6 (5 : Fin 10) =
      productValue6 (5 : Fin 10) := by
  norm_num [product6, productValue6, XCell2_6, ACell6_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product6_apply_6 :
    product6 (6 : Fin 10) =
      productValue6 (6 : Fin 10) := by
  norm_num [product6, productValue6, XCell2_6, ACell6_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product6_apply_7 :
    product6 (7 : Fin 10) =
      productValue6 (7 : Fin 10) := by
  norm_num [product6, productValue6, XCell2_6, ACell6_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product6_apply_8 :
    product6 (8 : Fin 10) =
      productValue6 (8 : Fin 10) := by
  norm_num [product6, productValue6, XCell2_6, ACell6_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product6_apply_9 :
    product6 (9 : Fin 10) =
      productValue6 (9 : Fin 10) := by
  norm_num [product6, productValue6, XCell2_6, ACell6_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product6_eq : product6 = productValue6 := by
  funext n
  fin_cases n
  · exact product6_apply_0
  · exact product6_apply_1
  · exact product6_apply_2
  · exact product6_apply_3
  · exact product6_apply_4
  · exact product6_apply_5
  · exact product6_apply_6
  · exact product6_apply_7
  · exact product6_apply_8
  · exact product6_apply_9

theorem matrixProduct6_eq :
    mul (XVec (2 : Fin 10) (6 : Fin 20))
      (AVec (6 : Fin 20) (4 : Fin 10)) = productValue6 := by
  change product6 = _
  exact product6_eq

def product7 : Vec := mul XCell2_7 ACell7_4

def productValue7 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-24 / 121 : ℚ)
  | 1 => 0
  | 2 => (27 / 121 : ℚ)
  | 3 => (-27 / 242 : ℚ)
  | 4 => (-21 / 121 : ℚ)
  | 5 => (27 / 121 : ℚ)
  | 6 => (24 / 121 : ℚ)
  | 7 => (-39 / 242 : ℚ)
  | 8 => (-21 / 242 : ℚ)
  | 9 => (27 / 121 : ℚ)
  | _ => 0

theorem product7_apply_0 :
    product7 (0 : Fin 10) =
      productValue7 (0 : Fin 10) := by
  norm_num [product7, productValue7, XCell2_7, ACell7_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product7_apply_1 :
    product7 (1 : Fin 10) =
      productValue7 (1 : Fin 10) := by
  norm_num [product7, productValue7, XCell2_7, ACell7_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product7_apply_2 :
    product7 (2 : Fin 10) =
      productValue7 (2 : Fin 10) := by
  norm_num [product7, productValue7, XCell2_7, ACell7_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product7_apply_3 :
    product7 (3 : Fin 10) =
      productValue7 (3 : Fin 10) := by
  norm_num [product7, productValue7, XCell2_7, ACell7_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product7_apply_4 :
    product7 (4 : Fin 10) =
      productValue7 (4 : Fin 10) := by
  norm_num [product7, productValue7, XCell2_7, ACell7_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product7_apply_5 :
    product7 (5 : Fin 10) =
      productValue7 (5 : Fin 10) := by
  norm_num [product7, productValue7, XCell2_7, ACell7_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product7_apply_6 :
    product7 (6 : Fin 10) =
      productValue7 (6 : Fin 10) := by
  norm_num [product7, productValue7, XCell2_7, ACell7_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product7_apply_7 :
    product7 (7 : Fin 10) =
      productValue7 (7 : Fin 10) := by
  norm_num [product7, productValue7, XCell2_7, ACell7_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product7_apply_8 :
    product7 (8 : Fin 10) =
      productValue7 (8 : Fin 10) := by
  norm_num [product7, productValue7, XCell2_7, ACell7_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product7_apply_9 :
    product7 (9 : Fin 10) =
      productValue7 (9 : Fin 10) := by
  norm_num [product7, productValue7, XCell2_7, ACell7_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product7_eq : product7 = productValue7 := by
  funext n
  fin_cases n
  · exact product7_apply_0
  · exact product7_apply_1
  · exact product7_apply_2
  · exact product7_apply_3
  · exact product7_apply_4
  · exact product7_apply_5
  · exact product7_apply_6
  · exact product7_apply_7
  · exact product7_apply_8
  · exact product7_apply_9

theorem matrixProduct7_eq :
    mul (XVec (2 : Fin 10) (7 : Fin 20))
      (AVec (7 : Fin 20) (4 : Fin 10)) = productValue7 := by
  change product7 = _
  exact product7_eq

def product8 : Vec := mul XCell2_8 ACell8_4

theorem left8_eq_zero : XCell2_8 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem product8_eq : product8 = 0 := by
  rw [product8, left8_eq_zero, mul_zero_left]

theorem matrixProduct8_eq :
    mul (XVec (2 : Fin 10) (8 : Fin 20))
      (AVec (8 : Fin 20) (4 : Fin 10)) = 0 := by
  change product8 = _
  exact product8_eq

def product9 : Vec := mul XCell2_9 ACell9_4

theorem left9_eq_zero : XCell2_9 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem product9_eq : product9 = 0 := by
  rw [product9, left9_eq_zero, mul_zero_left]

theorem matrixProduct9_eq :
    mul (XVec (2 : Fin 10) (9 : Fin 20))
      (AVec (9 : Fin 20) (4 : Fin 10)) = 0 := by
  change product9 = _
  exact product9_eq

def product10 : Vec := mul XCell2_10 ACell10_4

def productValue10 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (1 / 22 : ℚ)
  | 1 => (2 / 11 : ℚ)
  | 2 => (2 / 11 : ℚ)
  | 3 => (1 / 22 : ℚ)
  | 4 => 0
  | 5 => (1 / 22 : ℚ)
  | 6 => 0
  | 7 => (-1 / 22 : ℚ)
  | 8 => 0
  | 9 => (1 / 22 : ℚ)
  | _ => 0

theorem product10_apply_0 :
    product10 (0 : Fin 10) =
      productValue10 (0 : Fin 10) := by
  norm_num [product10, productValue10, XCell2_10, ACell10_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product10_apply_1 :
    product10 (1 : Fin 10) =
      productValue10 (1 : Fin 10) := by
  norm_num [product10, productValue10, XCell2_10, ACell10_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product10_apply_2 :
    product10 (2 : Fin 10) =
      productValue10 (2 : Fin 10) := by
  norm_num [product10, productValue10, XCell2_10, ACell10_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product10_apply_3 :
    product10 (3 : Fin 10) =
      productValue10 (3 : Fin 10) := by
  norm_num [product10, productValue10, XCell2_10, ACell10_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product10_apply_4 :
    product10 (4 : Fin 10) =
      productValue10 (4 : Fin 10) := by
  norm_num [product10, productValue10, XCell2_10, ACell10_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product10_apply_5 :
    product10 (5 : Fin 10) =
      productValue10 (5 : Fin 10) := by
  norm_num [product10, productValue10, XCell2_10, ACell10_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product10_apply_6 :
    product10 (6 : Fin 10) =
      productValue10 (6 : Fin 10) := by
  norm_num [product10, productValue10, XCell2_10, ACell10_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product10_apply_7 :
    product10 (7 : Fin 10) =
      productValue10 (7 : Fin 10) := by
  norm_num [product10, productValue10, XCell2_10, ACell10_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product10_apply_8 :
    product10 (8 : Fin 10) =
      productValue10 (8 : Fin 10) := by
  norm_num [product10, productValue10, XCell2_10, ACell10_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product10_apply_9 :
    product10 (9 : Fin 10) =
      productValue10 (9 : Fin 10) := by
  norm_num [product10, productValue10, XCell2_10, ACell10_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product10_eq : product10 = productValue10 := by
  funext n
  fin_cases n
  · exact product10_apply_0
  · exact product10_apply_1
  · exact product10_apply_2
  · exact product10_apply_3
  · exact product10_apply_4
  · exact product10_apply_5
  · exact product10_apply_6
  · exact product10_apply_7
  · exact product10_apply_8
  · exact product10_apply_9

theorem matrixProduct10_eq :
    mul (XVec (2 : Fin 10) (10 : Fin 20))
      (AVec (10 : Fin 20) (4 : Fin 10)) = productValue10 := by
  change product10 = _
  exact product10_eq

def product11 : Vec := mul XCell2_11 ACell11_4

def productValue11 (i : Fin 10) : ℚ :=
  match i.val with
  | 0 => (-1 / 11 : ℚ)
  | 1 => (-1 / 22 : ℚ)
  | 2 => (1 / 22 : ℚ)
  | 3 => (-1 / 22 : ℚ)
  | 4 => (-1 / 11 : ℚ)
  | 5 => 0
  | 6 => (-1 / 22 : ℚ)
  | 7 => (-1 / 11 : ℚ)
  | 8 => (-1 / 11 : ℚ)
  | 9 => (-1 / 22 : ℚ)
  | _ => 0

theorem product11_apply_0 :
    product11 (0 : Fin 10) =
      productValue11 (0 : Fin 10) := by
  norm_num [product11, productValue11, XCell2_11, ACell11_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product11_apply_1 :
    product11 (1 : Fin 10) =
      productValue11 (1 : Fin 10) := by
  norm_num [product11, productValue11, XCell2_11, ACell11_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product11_apply_2 :
    product11 (2 : Fin 10) =
      productValue11 (2 : Fin 10) := by
  norm_num [product11, productValue11, XCell2_11, ACell11_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product11_apply_3 :
    product11 (3 : Fin 10) =
      productValue11 (3 : Fin 10) := by
  norm_num [product11, productValue11, XCell2_11, ACell11_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product11_apply_4 :
    product11 (4 : Fin 10) =
      productValue11 (4 : Fin 10) := by
  norm_num [product11, productValue11, XCell2_11, ACell11_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product11_apply_5 :
    product11 (5 : Fin 10) =
      productValue11 (5 : Fin 10) := by
  norm_num [product11, productValue11, XCell2_11, ACell11_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product11_apply_6 :
    product11 (6 : Fin 10) =
      productValue11 (6 : Fin 10) := by
  norm_num [product11, productValue11, XCell2_11, ACell11_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product11_apply_7 :
    product11 (7 : Fin 10) =
      productValue11 (7 : Fin 10) := by
  norm_num [product11, productValue11, XCell2_11, ACell11_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product11_apply_8 :
    product11 (8 : Fin 10) =
      productValue11 (8 : Fin 10) := by
  norm_num [product11, productValue11, XCell2_11, ACell11_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product11_apply_9 :
    product11 (9 : Fin 10) =
      productValue11 (9 : Fin 10) := by
  norm_num [product11, productValue11, XCell2_11, ACell11_4,
    mul, conv, coeffAt, Fin.sum_univ_succ]

theorem product11_eq : product11 = productValue11 := by
  funext n
  fin_cases n
  · exact product11_apply_0
  · exact product11_apply_1
  · exact product11_apply_2
  · exact product11_apply_3
  · exact product11_apply_4
  · exact product11_apply_5
  · exact product11_apply_6
  · exact product11_apply_7
  · exact product11_apply_8
  · exact product11_apply_9

theorem matrixProduct11_eq :
    mul (XVec (2 : Fin 10) (11 : Fin 20))
      (AVec (11 : Fin 20) (4 : Fin 10)) = productValue11 := by
  change product11 = _
  exact product11_eq

def product12 : Vec := mul XCell2_12 ACell12_4

theorem left12_eq_zero : XCell2_12 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem product12_eq : product12 = 0 := by
  rw [product12, left12_eq_zero, mul_zero_left]

theorem matrixProduct12_eq :
    mul (XVec (2 : Fin 10) (12 : Fin 20))
      (AVec (12 : Fin 20) (4 : Fin 10)) = 0 := by
  change product12 = _
  exact product12_eq

def product13 : Vec := mul XCell2_13 ACell13_4

theorem left13_eq_zero : XCell2_13 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem product13_eq : product13 = 0 := by
  rw [product13, left13_eq_zero, mul_zero_left]

theorem matrixProduct13_eq :
    mul (XVec (2 : Fin 10) (13 : Fin 20))
      (AVec (13 : Fin 20) (4 : Fin 10)) = 0 := by
  change product13 = _
  exact product13_eq

def product14 : Vec := mul XCell2_14 ACell14_4

theorem left14_eq_zero : XCell2_14 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem product14_eq : product14 = 0 := by
  rw [product14, left14_eq_zero, mul_zero_left]

theorem matrixProduct14_eq :
    mul (XVec (2 : Fin 10) (14 : Fin 20))
      (AVec (14 : Fin 20) (4 : Fin 10)) = 0 := by
  change product14 = _
  exact product14_eq

def product15 : Vec := mul XCell2_15 ACell15_4

theorem left15_eq_zero : XCell2_15 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem product15_eq : product15 = 0 := by
  rw [product15, left15_eq_zero, mul_zero_left]

theorem matrixProduct15_eq :
    mul (XVec (2 : Fin 10) (15 : Fin 20))
      (AVec (15 : Fin 20) (4 : Fin 10)) = 0 := by
  change product15 = _
  exact product15_eq

def product16 : Vec := mul XCell2_16 ACell16_4

theorem left16_eq_zero : XCell2_16 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem product16_eq : product16 = 0 := by
  rw [product16, left16_eq_zero, mul_zero_left]

theorem matrixProduct16_eq :
    mul (XVec (2 : Fin 10) (16 : Fin 20))
      (AVec (16 : Fin 20) (4 : Fin 10)) = 0 := by
  change product16 = _
  exact product16_eq

def product17 : Vec := mul XCell2_17 ACell17_4

theorem left17_eq_zero : XCell2_17 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem product17_eq : product17 = 0 := by
  rw [product17, left17_eq_zero, mul_zero_left]

theorem matrixProduct17_eq :
    mul (XVec (2 : Fin 10) (17 : Fin 20))
      (AVec (17 : Fin 20) (4 : Fin 10)) = 0 := by
  change product17 = _
  exact product17_eq

def product18 : Vec := mul XCell2_18 ACell18_4

theorem left18_eq_zero : XCell2_18 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem product18_eq : product18 = 0 := by
  rw [product18, left18_eq_zero, mul_zero_left]

theorem matrixProduct18_eq :
    mul (XVec (2 : Fin 10) (18 : Fin 20))
      (AVec (18 : Fin 20) (4 : Fin 10)) = 0 := by
  change product18 = _
  exact product18_eq

def product19 : Vec := mul XCell2_19 ACell19_4

theorem left19_eq_zero : XCell2_19 = 0 := by
  funext n
  fin_cases n <;> rfl

theorem product19_eq : product19 = 0 := by
  rw [product19, left19_eq_zero, mul_zero_left]

theorem matrixProduct19_eq :
    mul (XVec (2 : Fin 10) (19 : Fin 20))
      (AVec (19 : Fin 20) (4 : Fin 10)) = 0 := by
  change product19 = _
  exact product19_eq

def productResult (k : Fin 20) : Vec :=
  match k.val with
  | 0 => productValue0
  | 1 => productValue1
  | 2 => productValue2
  | 3 => productValue3
  | 4 => productValue4
  | 5 => productValue5
  | 6 => productValue6
  | 7 => productValue7
  | 8 => 0
  | 9 => 0
  | 10 => productValue10
  | 11 => productValue11
  | 12 => 0
  | 13 => 0
  | 14 => 0
  | 15 => 0
  | 16 => 0
  | 17 => 0
  | 18 => 0
  | 19 => 0
  | _ => 0

theorem matrixProduct (k : Fin 20) :
    mul (XVec (2 : Fin 10) k) (AVec k (4 : Fin 10)) =
      productResult k := by
  fin_cases k
  · exact matrixProduct0_eq
  · exact matrixProduct1_eq
  · exact matrixProduct2_eq
  · exact matrixProduct3_eq
  · exact matrixProduct4_eq
  · exact matrixProduct5_eq
  · exact matrixProduct6_eq
  · exact matrixProduct7_eq
  · exact matrixProduct8_eq
  · exact matrixProduct9_eq
  · exact matrixProduct10_eq
  · exact matrixProduct11_eq
  · exact matrixProduct12_eq
  · exact matrixProduct13_eq
  · exact matrixProduct14_eq
  · exact matrixProduct15_eq
  · exact matrixProduct16_eq
  · exact matrixProduct17_eq
  · exact matrixProduct18_eq
  · exact matrixProduct19_eq

theorem productResult_sum_apply_0 :
    (∑ k : Fin 20, productResult k) (0 : Fin 10) =
      0 := by
  norm_num [productResult, Fin.sum_univ_succ,
    productValue0,
    productValue1,
    productValue2,
    productValue3,
    productValue4,
    productValue5,
    productValue6,
    productValue7,
    productValue10,
    productValue11]

theorem productResult_sum_apply_1 :
    (∑ k : Fin 20, productResult k) (1 : Fin 10) =
      0 := by
  norm_num [productResult, Fin.sum_univ_succ,
    productValue0,
    productValue1,
    productValue2,
    productValue3,
    productValue4,
    productValue5,
    productValue6,
    productValue7,
    productValue10,
    productValue11]

theorem productResult_sum_apply_2 :
    (∑ k : Fin 20, productResult k) (2 : Fin 10) =
      0 := by
  norm_num [productResult, Fin.sum_univ_succ,
    productValue0,
    productValue1,
    productValue2,
    productValue3,
    productValue4,
    productValue5,
    productValue6,
    productValue7,
    productValue10,
    productValue11]

theorem productResult_sum_apply_3 :
    (∑ k : Fin 20, productResult k) (3 : Fin 10) =
      0 := by
  norm_num [productResult, Fin.sum_univ_succ,
    productValue0,
    productValue1,
    productValue2,
    productValue3,
    productValue4,
    productValue5,
    productValue6,
    productValue7,
    productValue10,
    productValue11]

theorem productResult_sum_apply_4 :
    (∑ k : Fin 20, productResult k) (4 : Fin 10) =
      0 := by
  norm_num [productResult, Fin.sum_univ_succ,
    productValue0,
    productValue1,
    productValue2,
    productValue3,
    productValue4,
    productValue5,
    productValue6,
    productValue7,
    productValue10,
    productValue11]

theorem productResult_sum_apply_5 :
    (∑ k : Fin 20, productResult k) (5 : Fin 10) =
      0 := by
  norm_num [productResult, Fin.sum_univ_succ,
    productValue0,
    productValue1,
    productValue2,
    productValue3,
    productValue4,
    productValue5,
    productValue6,
    productValue7,
    productValue10,
    productValue11]

theorem productResult_sum_apply_6 :
    (∑ k : Fin 20, productResult k) (6 : Fin 10) =
      0 := by
  norm_num [productResult, Fin.sum_univ_succ,
    productValue0,
    productValue1,
    productValue2,
    productValue3,
    productValue4,
    productValue5,
    productValue6,
    productValue7,
    productValue10,
    productValue11]

theorem productResult_sum_apply_7 :
    (∑ k : Fin 20, productResult k) (7 : Fin 10) =
      0 := by
  norm_num [productResult, Fin.sum_univ_succ,
    productValue0,
    productValue1,
    productValue2,
    productValue3,
    productValue4,
    productValue5,
    productValue6,
    productValue7,
    productValue10,
    productValue11]

theorem productResult_sum_apply_8 :
    (∑ k : Fin 20, productResult k) (8 : Fin 10) =
      0 := by
  norm_num [productResult, Fin.sum_univ_succ,
    productValue0,
    productValue1,
    productValue2,
    productValue3,
    productValue4,
    productValue5,
    productValue6,
    productValue7,
    productValue10,
    productValue11]

theorem productResult_sum_apply_9 :
    (∑ k : Fin 20, productResult k) (9 : Fin 10) =
      0 := by
  norm_num [productResult, Fin.sum_univ_succ,
    productValue0,
    productValue1,
    productValue2,
    productValue3,
    productValue4,
    productValue5,
    productValue6,
    productValue7,
    productValue10,
    productValue11]

theorem productResult_sum_eq :
    (∑ k : Fin 20, productResult k) = ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  funext n
  fin_cases n
  · exact productResult_sum_apply_0
  · exact productResult_sum_apply_1
  · exact productResult_sum_apply_2
  · exact productResult_sum_apply_3
  · exact productResult_sum_apply_4
  · exact productResult_sum_apply_5
  · exact productResult_sum_apply_6
  · exact productResult_sum_apply_7
  · exact productResult_sum_apply_8
  · exact productResult_sum_apply_9

theorem entry_eq :
    (matrixMul XVec AVec) (2 : Fin 10) (4 : Fin 10) =
      ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0] := by
  unfold matrixMul
  calc
    (∑ k : Fin 20, mul (XVec (2 : Fin 10) k)
        (AVec k (4 : Fin 10))) = ∑ k : Fin 20, productResult k := by
      apply Finset.sum_congr rfl
      intro k _
      exact matrixProduct k
    _ = _ := productResult_sum_eq

theorem entry_eq_matrixOne :
    (matrixMul XVec AVec) (2 : Fin 10) (4 : Fin 10) =
      matrixOne (Fin 10) (2 : Fin 10) (4 : Fin 10) := by
  rw [entry_eq]
  have hne : (2 : Fin 10) ≠ (4 : Fin 10) := by decide
  funext n
  fin_cases n <;> simp [matrixOne, constVec, basis, *]

end V14Formalization.D12PiecePASplitEntry2_4
