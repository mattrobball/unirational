/-
Last three columns of T⁻¹, the invertible completion of (L; N).
-/
module

public import V14Formalization.D12SigmaPlusSegreEval

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore

@[expose] public def K_re_0_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_0_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_0_0 : Ki := ofLadj K_re_0_0 K_im_0_0

@[expose] public def K_re_0_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_0_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_0_1 : Ki := ofLadj K_re_0_1 K_im_0_1

@[expose] public def K_re_0_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_0_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_0_2 : Ki := ofLadj K_re_0_2 K_im_0_2

@[expose] public def K_re_1_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_1_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_1_0 : Ki := ofLadj K_re_1_0 K_im_1_0

@[expose] public def K_re_1_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_1_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_1_1 : Ki := ofLadj K_re_1_1 K_im_1_1

@[expose] public def K_re_1_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_1_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_1_2 : Ki := ofLadj K_re_1_2 K_im_1_2

@[expose] public def K_re_2_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_2_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_2_0 : Ki := ofLadj K_re_2_0 K_im_2_0

@[expose] public def K_re_2_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_2_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_2_1 : Ki := ofLadj K_re_2_1 K_im_2_1

@[expose] public def K_re_2_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_2_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_2_2 : Ki := ofLadj K_re_2_2 K_im_2_2

@[expose] public def K_re_3_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_3_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_3_0 : Ki := ofLadj K_re_3_0 K_im_3_0

@[expose] public def K_re_3_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_3_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_3_1 : Ki := ofLadj K_re_3_1 K_im_3_1

@[expose] public def K_re_3_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_3_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_3_2 : Ki := ofLadj K_re_3_2 K_im_3_2

@[expose] public def K_re_4_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_4_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_4_0 : Ki := ofLadj K_re_4_0 K_im_4_0

@[expose] public def K_re_4_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_4_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_4_1 : Ki := ofLadj K_re_4_1 K_im_4_1

@[expose] public def K_re_4_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_4_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_4_2 : Ki := ofLadj K_re_4_2 K_im_4_2

@[expose] public def K_re_5_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_5_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_5_0 : Ki := ofLadj K_re_5_0 K_im_5_0

@[expose] public def K_re_5_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_5_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_5_1 : Ki := ofLadj K_re_5_1 K_im_5_1

@[expose] public def K_re_5_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_5_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_5_2 : Ki := ofLadj K_re_5_2 K_im_5_2

@[expose] public def K_re_6_0 : Polynomial ℚ := C (1)
@[expose] public def K_im_6_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_6_0 : Ki := ofLadj K_re_6_0 K_im_6_0

@[expose] public def K_re_6_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_6_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_6_1 : Ki := ofLadj K_re_6_1 K_im_6_1

@[expose] public def K_re_6_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_6_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_6_2 : Ki := ofLadj K_re_6_2 K_im_6_2

@[expose] public def K_re_7_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_7_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_7_0 : Ki := ofLadj K_re_7_0 K_im_7_0

@[expose] public def K_re_7_1 : Polynomial ℚ := C (1)
@[expose] public def K_im_7_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_7_1 : Ki := ofLadj K_re_7_1 K_im_7_1

@[expose] public def K_re_7_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_7_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_7_2 : Ki := ofLadj K_re_7_2 K_im_7_2

@[expose] public def K_re_8_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_8_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_8_0 : Ki := ofLadj K_re_8_0 K_im_8_0

@[expose] public def K_re_8_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_im_8_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_8_1 : Ki := ofLadj K_re_8_1 K_im_8_1

@[expose] public def K_re_8_2 : Polynomial ℚ := C (1)
@[expose] public def K_im_8_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def K_entry_8_2 : Ki := ofLadj K_re_8_2 K_im_8_2

@[expose] public def K : Matrix (Fin 9) (Fin 3) Ki :=
  Matrix.of fun i j =>
    match i.val, j.val with
    | 0, 0 => K_entry_0_0
    | 0, 1 => K_entry_0_1
    | 0, 2 => K_entry_0_2
    | 1, 0 => K_entry_1_0
    | 1, 1 => K_entry_1_1
    | 1, 2 => K_entry_1_2
    | 2, 0 => K_entry_2_0
    | 2, 1 => K_entry_2_1
    | 2, 2 => K_entry_2_2
    | 3, 0 => K_entry_3_0
    | 3, 1 => K_entry_3_1
    | 3, 2 => K_entry_3_2
    | 4, 0 => K_entry_4_0
    | 4, 1 => K_entry_4_1
    | 4, 2 => K_entry_4_2
    | 5, 0 => K_entry_5_0
    | 5, 1 => K_entry_5_1
    | 5, 2 => K_entry_5_2
    | 6, 0 => K_entry_6_0
    | 6, 1 => K_entry_6_1
    | 6, 2 => K_entry_6_2
    | 7, 0 => K_entry_7_0
    | 7, 1 => K_entry_7_1
    | 7, 2 => K_entry_7_2
    | 8, 0 => K_entry_8_0
    | 8, 1 => K_entry_8_1
    | 8, 2 => K_entry_8_2
    | _, _ => K_entry_0_0

end V14Formalization.D12SigmaPlusSegreCore
