/-
Polynomial representative of the concrete plus carrier Bplus.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore

@[expose] public def Bplus_poly_0_0 : Polynomial ℚ := C (1)

@[expose] public def Bplus_poly_0_1 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_0_2 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_0_3 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_0_4 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_0_5 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_row0 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_0_0
  | 1 => Bplus_poly_0_1
  | 2 => Bplus_poly_0_2
  | 3 => Bplus_poly_0_3
  | 4 => Bplus_poly_0_4
  | 5 => Bplus_poly_0_5
  | _ => Bplus_poly_0_0

@[expose] public def Bplus_poly_1_0 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_1_1 : Polynomial ℚ := C (1)

@[expose] public def Bplus_poly_1_2 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_1_3 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_1_4 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_1_5 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_row1 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_1_0
  | 1 => Bplus_poly_1_1
  | 2 => Bplus_poly_1_2
  | 3 => Bplus_poly_1_3
  | 4 => Bplus_poly_1_4
  | 5 => Bplus_poly_1_5
  | _ => Bplus_poly_1_0

@[expose] public def Bplus_poly_2_0 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_2_1 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_2_2 : Polynomial ℚ := C (1)

@[expose] public def Bplus_poly_2_3 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_2_4 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_2_5 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_row2 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_2_0
  | 1 => Bplus_poly_2_1
  | 2 => Bplus_poly_2_2
  | 3 => Bplus_poly_2_3
  | 4 => Bplus_poly_2_4
  | 5 => Bplus_poly_2_5
  | _ => Bplus_poly_2_0

@[expose] public def Bplus_poly_3_0 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_3_1 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_3_2 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_3_3 : Polynomial ℚ := C (1)

@[expose] public def Bplus_poly_3_4 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_3_5 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_row3 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_3_0
  | 1 => Bplus_poly_3_1
  | 2 => Bplus_poly_3_2
  | 3 => Bplus_poly_3_3
  | 4 => Bplus_poly_3_4
  | 5 => Bplus_poly_3_5
  | _ => Bplus_poly_3_0

@[expose] public def Bplus_poly_4_0 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_4_1 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_4_2 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_4_3 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_4_4 : Polynomial ℚ := C (1)

@[expose] public def Bplus_poly_4_5 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_row4 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_4_0
  | 1 => Bplus_poly_4_1
  | 2 => Bplus_poly_4_2
  | 3 => Bplus_poly_4_3
  | 4 => Bplus_poly_4_4
  | 5 => Bplus_poly_4_5
  | _ => Bplus_poly_4_0

@[expose] public def Bplus_poly_5_0 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_5_1 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_5_2 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_5_3 : Polynomial ℚ := C ((-1 / 2 : ℚ))

@[expose] public def Bplus_poly_5_4 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_5_5 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_row5 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_5_0
  | 1 => Bplus_poly_5_1
  | 2 => Bplus_poly_5_2
  | 3 => Bplus_poly_5_3
  | 4 => Bplus_poly_5_4
  | 5 => Bplus_poly_5_5
  | _ => Bplus_poly_5_0

@[expose] public def Bplus_poly_6_0 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_6_1 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_6_2 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_6_3 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_6_4 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_6_5 : Polynomial ℚ := C (1)

@[expose] public def Bplus_poly_row6 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_6_0
  | 1 => Bplus_poly_6_1
  | 2 => Bplus_poly_6_2
  | 3 => Bplus_poly_6_3
  | 4 => Bplus_poly_6_4
  | 5 => Bplus_poly_6_5
  | _ => Bplus_poly_6_0

@[expose] public def Bplus_poly_7_0 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9

@[expose] public def Bplus_poly_7_1 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 9

@[expose] public def Bplus_poly_7_2 : Polynomial ℚ := C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 8

@[expose] public def Bplus_poly_7_3 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 7

@[expose] public def Bplus_poly_7_4 : Polynomial ℚ := C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6

@[expose] public def Bplus_poly_7_5 : Polynomial ℚ := C (-1)

@[expose] public def Bplus_poly_row7 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_7_0
  | 1 => Bplus_poly_7_1
  | 2 => Bplus_poly_7_2
  | 3 => Bplus_poly_7_3
  | 4 => Bplus_poly_7_4
  | 5 => Bplus_poly_7_5
  | _ => Bplus_poly_7_0

@[expose] public def Bplus_poly_8_0 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_8_1 : Polynomial ℚ := C ((1 / 2 : ℚ))

@[expose] public def Bplus_poly_8_2 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_8_3 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_8_4 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_8_5 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_row8 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_8_0
  | 1 => Bplus_poly_8_1
  | 2 => Bplus_poly_8_2
  | 3 => Bplus_poly_8_3
  | 4 => Bplus_poly_8_4
  | 5 => Bplus_poly_8_5
  | _ => Bplus_poly_8_0

@[expose] public def Bplus_poly_9_0 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 8

@[expose] public def Bplus_poly_9_1 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6

@[expose] public def Bplus_poly_9_2 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 9

@[expose] public def Bplus_poly_9_3 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9

@[expose] public def Bplus_poly_9_4 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 7

@[expose] public def Bplus_poly_9_5 : Polynomial ℚ := C (-1)

@[expose] public def Bplus_poly_row9 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_9_0
  | 1 => Bplus_poly_9_1
  | 2 => Bplus_poly_9_2
  | 3 => Bplus_poly_9_3
  | 4 => Bplus_poly_9_4
  | 5 => Bplus_poly_9_5
  | _ => Bplus_poly_9_0

@[expose] public def Bplus_poly_10_0 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_10_1 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_10_2 : Polynomial ℚ := C ((-1 / 2 : ℚ))

@[expose] public def Bplus_poly_10_3 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_10_4 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_10_5 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_row10 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_10_0
  | 1 => Bplus_poly_10_1
  | 2 => Bplus_poly_10_2
  | 3 => Bplus_poly_10_3
  | 4 => Bplus_poly_10_4
  | 5 => Bplus_poly_10_5
  | _ => Bplus_poly_10_0

@[expose] public def Bplus_poly_11_0 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9

@[expose] public def Bplus_poly_11_1 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7

@[expose] public def Bplus_poly_11_2 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 9

@[expose] public def Bplus_poly_11_3 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 9

@[expose] public def Bplus_poly_11_4 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9

@[expose] public def Bplus_poly_11_5 : Polynomial ℚ := C (1)

@[expose] public def Bplus_poly_row11 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_11_0
  | 1 => Bplus_poly_11_1
  | 2 => Bplus_poly_11_2
  | 3 => Bplus_poly_11_3
  | 4 => Bplus_poly_11_4
  | 5 => Bplus_poly_11_5
  | _ => Bplus_poly_11_0

@[expose] public def Bplus_poly_12_0 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_12_1 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_12_2 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_12_3 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_12_4 : Polynomial ℚ := C ((1 / 2 : ℚ))

@[expose] public def Bplus_poly_12_5 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_row12 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_12_0
  | 1 => Bplus_poly_12_1
  | 2 => Bplus_poly_12_2
  | 3 => Bplus_poly_12_3
  | 4 => Bplus_poly_12_4
  | 5 => Bplus_poly_12_5
  | _ => Bplus_poly_12_0

@[expose] public def Bplus_poly_13_0 : Polynomial ℚ := C ((-1 / 2 : ℚ))

@[expose] public def Bplus_poly_13_1 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_13_2 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_13_3 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_13_4 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_13_5 : Polynomial ℚ := (0 : Polynomial ℚ)

@[expose] public def Bplus_poly_row13 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_13_0
  | 1 => Bplus_poly_13_1
  | 2 => Bplus_poly_13_2
  | 3 => Bplus_poly_13_3
  | 4 => Bplus_poly_13_4
  | 5 => Bplus_poly_13_5
  | _ => Bplus_poly_13_0

@[expose] public def Bplus_poly_14_0 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9

@[expose] public def Bplus_poly_14_1 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9

@[expose] public def Bplus_poly_14_2 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 9

@[expose] public def Bplus_poly_14_3 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7

@[expose] public def Bplus_poly_14_4 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 9

@[expose] public def Bplus_poly_14_5 : Polynomial ℚ := C (-1)

@[expose] public def Bplus_poly_row14 : Fin 6 → Polynomial ℚ := fun j =>
  match j.val with
  | 0 => Bplus_poly_14_0
  | 1 => Bplus_poly_14_1
  | 2 => Bplus_poly_14_2
  | 3 => Bplus_poly_14_3
  | 4 => Bplus_poly_14_4
  | 5 => Bplus_poly_14_5
  | _ => Bplus_poly_14_0

@[expose] public def Bplus_poly : Matrix (Fin 15) (Fin 6) (Polynomial ℚ) :=
  fun i =>
    match i.val with
    | 0 => Bplus_poly_row0
    | 1 => Bplus_poly_row1
    | 2 => Bplus_poly_row2
    | 3 => Bplus_poly_row3
    | 4 => Bplus_poly_row4
    | 5 => Bplus_poly_row5
    | 6 => Bplus_poly_row6
    | 7 => Bplus_poly_row7
    | 8 => Bplus_poly_row8
    | 9 => Bplus_poly_row9
    | 10 => Bplus_poly_row10
    | 11 => Bplus_poly_row11
    | 12 => Bplus_poly_row12
    | 13 => Bplus_poly_row13
    | 14 => Bplus_poly_row14
    | _ => Bplus_poly_row0

end V14Formalization.D12SigmaPlusSegreCore
