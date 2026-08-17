/-
Plus Segre span matrix spanU.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore

@[expose] public def spanU_re_0_0 : Polynomial ℚ := C ((1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 44 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 8 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_0_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_0_0 : Ki := ofLadj spanU_re_0_0 spanU_im_0_0

@[expose] public def spanU_re_0_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((1 / 44 : ℚ)) * X ^ 7 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_0_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X + C ((1 / 44 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((3 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_0_1 : Ki := ofLadj spanU_re_0_1 spanU_im_0_1

@[expose] public def spanU_re_0_2 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((-1 / 88 : ℚ)) * X ^ 2 + C ((-3 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-3 / 88 : ℚ)) * X ^ 8 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_0_2 : Polynomial ℚ := C ((3 / 88 : ℚ)) + C ((3 / 44 : ℚ)) * X + C ((3 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((3 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((5 / 88 : ℚ)) * X ^ 6 + C ((3 / 88 : ℚ)) * X ^ 7 + C ((5 / 88 : ℚ)) * X ^ 8 + C ((3 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_0_2 : Ki := ofLadj spanU_re_0_2 spanU_im_0_2

@[expose] public def spanU_re_0_3 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((1 / 44 : ℚ)) * X ^ 7 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_0_3 : Polynomial ℚ := C ((-1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X + C ((-1 / 44 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-3 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_0_3 : Ki := ofLadj spanU_re_0_3 spanU_im_0_3

@[expose] public def spanU_re_0_4 : Polynomial ℚ := C ((-1 / 44 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 5 + C ((1 / 44 : ℚ)) * X ^ 6 + C ((-1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_0_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_0_4 : Ki := ofLadj spanU_re_0_4 spanU_im_0_4

@[expose] public def spanU_re_0_5 : Polynomial ℚ := C ((3 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((1 / 44 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_0_5 : Polynomial ℚ := C ((-3 / 88 : ℚ)) + C ((-3 / 44 : ℚ)) * X + C ((-5 / 88 : ℚ)) * X ^ 2 + C ((-3 / 88 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 22 : ℚ)) * X ^ 5 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((-1 / 22 : ℚ)) * X ^ 7 + C ((-3 / 88 : ℚ)) * X ^ 8 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_0_5 : Ki := ofLadj spanU_re_0_5 spanU_im_0_5

@[expose] public def spanU_re_0_6 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((-1 / 88 : ℚ)) * X ^ 2 + C ((-3 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-3 / 88 : ℚ)) * X ^ 8 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_0_6 : Polynomial ℚ := C ((-3 / 88 : ℚ)) + C ((-3 / 44 : ℚ)) * X + C ((-3 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-3 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-5 / 88 : ℚ)) * X ^ 6 + C ((-3 / 88 : ℚ)) * X ^ 7 + C ((-5 / 88 : ℚ)) * X ^ 8 + C ((-3 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_0_6 : Ki := ofLadj spanU_re_0_6 spanU_im_0_6

@[expose] public def spanU_re_0_7 : Polynomial ℚ := C ((3 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((1 / 44 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_0_7 : Polynomial ℚ := C ((3 / 88 : ℚ)) + C ((3 / 44 : ℚ)) * X + C ((5 / 88 : ℚ)) * X ^ 2 + C ((3 / 88 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((1 / 22 : ℚ)) * X ^ 5 + C ((1 / 44 : ℚ)) * X ^ 6 + C ((1 / 22 : ℚ)) * X ^ 7 + C ((3 / 88 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_0_7 : Ki := ofLadj spanU_re_0_7 spanU_im_0_7

@[expose] public def spanU_re_0_8 : Polynomial ℚ := C ((1 / 22 : ℚ)) * X ^ 3 + C ((-1 / 22 : ℚ)) * X ^ 5 + C ((-1 / 22 : ℚ)) * X ^ 6 + C ((1 / 22 : ℚ)) * X ^ 8
@[expose] public def spanU_im_0_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_0_8 : Ki := ofLadj spanU_re_0_8 spanU_im_0_8

@[expose] public def spanU_re_1_0 : Polynomial ℚ := C ((1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 44 : ℚ)) * X ^ 7 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_1_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_1_0 : Ki := ofLadj spanU_re_1_0 spanU_im_1_0

@[expose] public def spanU_re_1_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((3 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((3 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_1_1 : Polynomial ℚ := C ((1 / 44 : ℚ)) + C ((1 / 22 : ℚ)) * X + C ((1 / 88 : ℚ)) * X ^ 2 + C ((3 / 88 : ℚ)) * X ^ 3 + C ((3 / 88 : ℚ)) * X ^ 4 + C ((1 / 22 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((3 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_1_1 : Ki := ofLadj spanU_re_1_1 spanU_im_1_1

@[expose] public def spanU_re_1_2 : Polynomial ℚ := C ((5 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_1_2 : Polynomial ℚ := C ((-1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X + C ((-1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 22 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((1 / 44 : ℚ)) * X ^ 5 + C ((-1 / 22 : ℚ)) * X ^ 6 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_1_2 : Ki := ofLadj spanU_re_1_2 spanU_im_1_2

@[expose] public def spanU_re_1_3 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((3 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((3 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_1_3 : Polynomial ℚ := C ((-1 / 44 : ℚ)) + C ((-1 / 22 : ℚ)) * X + C ((-1 / 88 : ℚ)) * X ^ 2 + C ((-3 / 88 : ℚ)) * X ^ 3 + C ((-3 / 88 : ℚ)) * X ^ 4 + C ((-1 / 22 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((-3 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_1_3 : Ki := ofLadj spanU_re_1_3 spanU_im_1_3

@[expose] public def spanU_re_1_4 : Polynomial ℚ := C ((-1 / 44 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((-1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_1_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_1_4 : Ki := ofLadj spanU_re_1_4 spanU_im_1_4

@[expose] public def spanU_re_1_5 : Polynomial ℚ := C ((1 / 44 : ℚ)) + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_1_5 : Polynomial ℚ := C ((1 / 44 : ℚ)) + C ((1 / 22 : ℚ)) * X + C ((1 / 44 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((3 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((5 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((3 / 88 : ℚ)) * X ^ 8 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_1_5 : Ki := ofLadj spanU_re_1_5 spanU_im_1_5

@[expose] public def spanU_re_1_6 : Polynomial ℚ := C ((5 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_1_6 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 22 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 44 : ℚ)) * X ^ 5 + C ((1 / 22 : ℚ)) * X ^ 6 + C ((-1 / 44 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_1_6 : Ki := ofLadj spanU_re_1_6 spanU_im_1_6

@[expose] public def spanU_re_1_7 : Polynomial ℚ := C ((1 / 44 : ℚ)) + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_1_7 : Polynomial ℚ := C ((-1 / 44 : ℚ)) + C ((-1 / 22 : ℚ)) * X + C ((-1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-3 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((-5 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-3 / 88 : ℚ)) * X ^ 8 + C ((-1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_1_7 : Ki := ofLadj spanU_re_1_7 spanU_im_1_7

@[expose] public def spanU_re_1_8 : Polynomial ℚ := C ((-1 / 22 : ℚ)) * X ^ 3 + C ((1 / 22 : ℚ)) * X ^ 4 + C ((1 / 22 : ℚ)) * X ^ 7 + C ((-1 / 22 : ℚ)) * X ^ 8
@[expose] public def spanU_im_1_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_1_8 : Ki := ofLadj spanU_re_1_8 spanU_im_1_8

@[expose] public def spanU_re_2_0 : Polynomial ℚ := C ((1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 44 : ℚ)) * X ^ 5 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_2_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_2_0 : Ki := ofLadj spanU_re_2_0 spanU_im_2_0

@[expose] public def spanU_re_2_1 : Polynomial ℚ := C ((1 / 44 : ℚ)) + C ((1 / 44 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((3 / 88 : ℚ)) * X ^ 4 + C ((3 / 88 : ℚ)) * X ^ 5 + C ((3 / 88 : ℚ)) * X ^ 6 + C ((3 / 88 : ℚ)) * X ^ 7 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_2_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X + C ((3 / 88 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((3 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_2_1 : Ki := ofLadj spanU_re_2_1 spanU_im_2_1

@[expose] public def spanU_re_2_2 : Polynomial ℚ := C ((1 / 44 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_2_2 : Polynomial ℚ := C ((-1 / 44 : ℚ)) + C ((-1 / 22 : ℚ)) * X + C ((-5 / 88 : ℚ)) * X ^ 2 + C ((-3 / 88 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-3 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 44 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_2_2 : Ki := ofLadj spanU_re_2_2 spanU_im_2_2

@[expose] public def spanU_re_2_3 : Polynomial ℚ := C ((1 / 44 : ℚ)) + C ((1 / 44 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((3 / 88 : ℚ)) * X ^ 4 + C ((3 / 88 : ℚ)) * X ^ 5 + C ((3 / 88 : ℚ)) * X ^ 6 + C ((3 / 88 : ℚ)) * X ^ 7 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_2_3 : Polynomial ℚ := C ((-1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X + C ((-3 / 88 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-3 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((-1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_2_3 : Ki := ofLadj spanU_re_2_3 spanU_im_2_3

@[expose] public def spanU_re_2_4 : Polynomial ℚ := C ((-1 / 44 : ℚ)) + C ((-1 / 22 : ℚ)) * X ^ 2 + C ((-1 / 44 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 44 : ℚ)) * X ^ 5 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((-1 / 44 : ℚ)) * X ^ 7 + C ((-1 / 44 : ℚ)) * X ^ 8 + C ((-1 / 22 : ℚ)) * X ^ 9
@[expose] public def spanU_im_2_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_2_4 : Ki := ofLadj spanU_re_2_4 spanU_im_2_4

@[expose] public def spanU_re_2_5 : Polynomial ℚ := C ((5 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_2_5 : Polynomial ℚ := C ((-1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X + C ((1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 44 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 22 : ℚ)) * X ^ 7 + C ((-1 / 22 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_2_5 : Ki := ofLadj spanU_re_2_5 spanU_im_2_5

@[expose] public def spanU_re_2_6 : Polynomial ℚ := C ((1 / 44 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_2_6 : Polynomial ℚ := C ((1 / 44 : ℚ)) + C ((1 / 22 : ℚ)) * X + C ((5 / 88 : ℚ)) * X ^ 2 + C ((3 / 88 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((3 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 44 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_2_6 : Ki := ofLadj spanU_re_2_6 spanU_im_2_6

@[expose] public def spanU_re_2_7 : Polynomial ℚ := C ((5 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_2_7 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X + C ((-1 / 44 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 22 : ℚ)) * X ^ 7 + C ((1 / 22 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_2_7 : Ki := ofLadj spanU_re_2_7 spanU_im_2_7

@[expose] public def spanU_re_2_8 : Polynomial ℚ := C ((1 / 22 : ℚ)) + C ((1 / 22 : ℚ)) * X ^ 2 + C ((1 / 22 : ℚ)) * X ^ 3 + C ((1 / 22 : ℚ)) * X ^ 4 + C ((1 / 11 : ℚ)) * X ^ 5 + C ((1 / 11 : ℚ)) * X ^ 6 + C ((1 / 22 : ℚ)) * X ^ 7 + C ((1 / 22 : ℚ)) * X ^ 8 + C ((1 / 22 : ℚ)) * X ^ 9
@[expose] public def spanU_im_2_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_2_8 : Ki := ofLadj spanU_re_2_8 spanU_im_2_8

@[expose] public def spanU_re_3_0 : Polynomial ℚ := C ((1 / 44 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 44 : ℚ)) * X ^ 7 + C ((1 / 44 : ℚ)) * X ^ 8
@[expose] public def spanU_im_3_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_3_0 : Ki := ofLadj spanU_re_3_0 spanU_im_3_0

@[expose] public def spanU_re_3_1 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_3_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_3_1 : Ki := ofLadj spanU_re_3_1 spanU_im_3_1

@[expose] public def spanU_re_3_2 : Polynomial ℚ := C ((-3 / 88 : ℚ)) + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 44 : ℚ)) * X ^ 5 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_3_2 : Polynomial ℚ := C ((-1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X + C ((-1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_3_2 : Ki := ofLadj spanU_re_3_2 spanU_im_3_2

@[expose] public def spanU_re_3_3 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_3_3 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_3_3 : Ki := ofLadj spanU_re_3_3 spanU_im_3_3

@[expose] public def spanU_re_3_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_3_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_3_4 : Ki := ofLadj spanU_re_3_4 spanU_im_3_4

@[expose] public def spanU_re_3_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_3_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_3_5 : Ki := ofLadj spanU_re_3_5 spanU_im_3_5

@[expose] public def spanU_re_3_6 : Polynomial ℚ := C ((-3 / 88 : ℚ)) + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 44 : ℚ)) * X ^ 5 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_3_6 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X + C ((1 / 44 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 44 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_3_6 : Ki := ofLadj spanU_re_3_6 spanU_im_3_6

@[expose] public def spanU_re_3_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_3_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_3_7 : Ki := ofLadj spanU_re_3_7 spanU_im_3_7

@[expose] public def spanU_re_3_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_3_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_3_8 : Ki := ofLadj spanU_re_3_8 spanU_im_3_8

@[expose] public def spanU_re_4_0 : Polynomial ℚ := C ((1 / 44 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 5 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((1 / 44 : ℚ)) * X ^ 8
@[expose] public def spanU_im_4_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_4_0 : Ki := ofLadj spanU_re_4_0 spanU_im_4_0

@[expose] public def spanU_re_4_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 44 : ℚ)) * X ^ 5 + C ((1 / 44 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_4_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_4_1 : Ki := ofLadj spanU_re_4_1 spanU_im_4_1

@[expose] public def spanU_re_4_2 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 44 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((-1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_4_2 : Polynomial ℚ := C ((-1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X + C ((-1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_4_2 : Ki := ofLadj spanU_re_4_2 spanU_im_4_2

@[expose] public def spanU_re_4_3 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 44 : ℚ)) * X ^ 5 + C ((1 / 44 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_4_3 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_4_3 : Ki := ofLadj spanU_re_4_3 spanU_im_4_3

@[expose] public def spanU_re_4_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_4_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_4_4 : Ki := ofLadj spanU_re_4_4 spanU_im_4_4

@[expose] public def spanU_re_4_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_4_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_4_5 : Ki := ofLadj spanU_re_4_5 spanU_im_4_5

@[expose] public def spanU_re_4_6 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 44 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((-1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_4_6 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X + C ((1 / 44 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_4_6 : Ki := ofLadj spanU_re_4_6 spanU_im_4_6

@[expose] public def spanU_re_4_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_4_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_4_7 : Ki := ofLadj spanU_re_4_7 spanU_im_4_7

@[expose] public def spanU_re_4_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_4_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_4_8 : Ki := ofLadj spanU_re_4_8 spanU_im_4_8

@[expose] public def spanU_re_5_0 : Polynomial ℚ := C ((1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 44 : ℚ)) * X ^ 5 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((1 / 44 : ℚ)) * X ^ 7
@[expose] public def spanU_im_5_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_5_0 : Ki := ofLadj spanU_re_5_0 spanU_im_5_0

@[expose] public def spanU_re_5_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_5_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_5_1 : Ki := ofLadj spanU_re_5_1 spanU_im_5_1

@[expose] public def spanU_re_5_2 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_5_2 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_5_2 : Ki := ofLadj spanU_re_5_2 spanU_im_5_2

@[expose] public def spanU_re_5_3 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_5_3 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_5_3 : Ki := ofLadj spanU_re_5_3 spanU_im_5_3

@[expose] public def spanU_re_5_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_5_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_5_4 : Ki := ofLadj spanU_re_5_4 spanU_im_5_4

@[expose] public def spanU_re_5_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_5_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_5_5 : Ki := ofLadj spanU_re_5_5 spanU_im_5_5

@[expose] public def spanU_re_5_6 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_5_6 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_5_6 : Ki := ofLadj spanU_re_5_6 spanU_im_5_6

@[expose] public def spanU_re_5_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_5_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_5_7 : Ki := ofLadj spanU_re_5_7 spanU_im_5_7

@[expose] public def spanU_re_5_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_5_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_5_8 : Ki := ofLadj spanU_re_5_8 spanU_im_5_8

@[expose] public def spanU_re_6_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_6_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_6_0 : Ki := ofLadj spanU_re_6_0 spanU_im_6_0

@[expose] public def spanU_re_6_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_6_1 : Polynomial ℚ := C ((-1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((-1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_6_1 : Ki := ofLadj spanU_re_6_1 spanU_im_6_1

@[expose] public def spanU_re_6_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_6_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_6_2 : Ki := ofLadj spanU_re_6_2 spanU_im_6_2

@[expose] public def spanU_re_6_3 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_6_3 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_6_3 : Ki := ofLadj spanU_re_6_3 spanU_im_6_3

@[expose] public def spanU_re_6_4 : Polynomial ℚ := C ((-1 / 44 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 5 + C ((1 / 44 : ℚ)) * X ^ 6 + C ((-1 / 44 : ℚ)) * X ^ 8
@[expose] public def spanU_im_6_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_6_4 : Ki := ofLadj spanU_re_6_4 spanU_im_6_4

@[expose] public def spanU_re_6_5 : Polynomial ℚ := C ((-3 / 88 : ℚ)) + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 44 : ℚ)) * X ^ 5 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_6_5 : Polynomial ℚ := C ((-1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X + C ((-1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_6_5 : Ki := ofLadj spanU_re_6_5 spanU_im_6_5

@[expose] public def spanU_re_6_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_6_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_6_6 : Ki := ofLadj spanU_re_6_6 spanU_im_6_6

@[expose] public def spanU_re_6_7 : Polynomial ℚ := C ((-3 / 88 : ℚ)) + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 44 : ℚ)) * X ^ 5 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_6_7 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X + C ((1 / 44 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 44 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_6_7 : Ki := ofLadj spanU_re_6_7 spanU_im_6_7

@[expose] public def spanU_re_6_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_6_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_6_8 : Ki := ofLadj spanU_re_6_8 spanU_im_6_8

@[expose] public def spanU_re_7_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_7_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_7_0 : Ki := ofLadj spanU_re_7_0 spanU_im_7_0

@[expose] public def spanU_re_7_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_7_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 7
@[expose] public def spanU_entry_7_1 : Ki := ofLadj spanU_re_7_1 spanU_im_7_1

@[expose] public def spanU_re_7_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_7_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_7_2 : Ki := ofLadj spanU_re_7_2 spanU_im_7_2

@[expose] public def spanU_re_7_3 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_7_3 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 7
@[expose] public def spanU_entry_7_3 : Ki := ofLadj spanU_re_7_3 spanU_im_7_3

@[expose] public def spanU_re_7_4 : Polynomial ℚ := C ((1 / 44 : ℚ)) + C ((1 / 44 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((1 / 22 : ℚ)) * X ^ 5 + C ((1 / 22 : ℚ)) * X ^ 6 + C ((1 / 44 : ℚ)) * X ^ 7 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_7_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_7_4 : Ki := ofLadj spanU_re_7_4 spanU_im_7_4

@[expose] public def spanU_re_7_5 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 44 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((-1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_7_5 : Polynomial ℚ := C ((-1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X + C ((-1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_7_5 : Ki := ofLadj spanU_re_7_5 spanU_im_7_5

@[expose] public def spanU_re_7_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_7_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_7_6 : Ki := ofLadj spanU_re_7_6 spanU_im_7_6

@[expose] public def spanU_re_7_7 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 44 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((-1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_7_7 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X + C ((1 / 44 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_7_7 : Ki := ofLadj spanU_re_7_7 spanU_im_7_7

@[expose] public def spanU_re_7_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_7_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_7_8 : Ki := ofLadj spanU_re_7_8 spanU_im_7_8

@[expose] public def spanU_re_8_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_8_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_8_0 : Ki := ofLadj spanU_re_8_0 spanU_im_8_0

@[expose] public def spanU_re_8_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7
@[expose] public def spanU_im_8_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_8_1 : Ki := ofLadj spanU_re_8_1 spanU_im_8_1

@[expose] public def spanU_re_8_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_8_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_8_2 : Ki := ofLadj spanU_re_8_2 spanU_im_8_2

@[expose] public def spanU_re_8_3 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7
@[expose] public def spanU_im_8_3 : Polynomial ℚ := C ((-1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X + C ((-1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_8_3 : Ki := ofLadj spanU_re_8_3 spanU_im_8_3

@[expose] public def spanU_re_8_4 : Polynomial ℚ := C ((1 / 44 : ℚ)) + C ((1 / 44 : ℚ)) * X ^ 2 + C ((1 / 22 : ℚ)) * X ^ 3 + C ((1 / 44 : ℚ)) * X ^ 4 + C ((1 / 44 : ℚ)) * X ^ 5 + C ((1 / 44 : ℚ)) * X ^ 6 + C ((1 / 44 : ℚ)) * X ^ 7 + C ((1 / 22 : ℚ)) * X ^ 8 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_8_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_8_4 : Ki := ofLadj spanU_re_8_4 spanU_im_8_4

@[expose] public def spanU_re_8_5 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_8_5 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_8_5 : Ki := ofLadj spanU_re_8_5 spanU_im_8_5

@[expose] public def spanU_re_8_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_8_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_8_6 : Ki := ofLadj spanU_re_8_6 spanU_im_8_6

@[expose] public def spanU_re_8_7 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_8_7 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_8_7 : Ki := ofLadj spanU_re_8_7 spanU_im_8_7

@[expose] public def spanU_re_8_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_8_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_8_8 : Ki := ofLadj spanU_re_8_8 spanU_im_8_8

@[expose] public def spanU_re_9_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_9_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_9_0 : Ki := ofLadj spanU_re_9_0 spanU_im_9_0

@[expose] public def spanU_re_9_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_9_1 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_9_1 : Ki := ofLadj spanU_re_9_1 spanU_im_9_1

@[expose] public def spanU_re_9_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_9_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_9_2 : Ki := ofLadj spanU_re_9_2 spanU_im_9_2

@[expose] public def spanU_re_9_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_9_3 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_9_3 : Ki := ofLadj spanU_re_9_3 spanU_im_9_3

@[expose] public def spanU_re_9_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_9_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_9_4 : Ki := ofLadj spanU_re_9_4 spanU_im_9_4

@[expose] public def spanU_re_9_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_9_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_9_5 : Ki := ofLadj spanU_re_9_5 spanU_im_9_5

@[expose] public def spanU_re_9_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_9_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_9_6 : Ki := ofLadj spanU_re_9_6 spanU_im_9_6

@[expose] public def spanU_re_9_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_9_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_9_7 : Ki := ofLadj spanU_re_9_7 spanU_im_9_7

@[expose] public def spanU_re_9_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_9_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_9_8 : Ki := ofLadj spanU_re_9_8 spanU_im_9_8

@[expose] public def spanU_re_10_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_10_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_10_0 : Ki := ofLadj spanU_re_10_0 spanU_im_10_0

@[expose] public def spanU_re_10_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_10_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_10_1 : Ki := ofLadj spanU_re_10_1 spanU_im_10_1

@[expose] public def spanU_re_10_2 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_10_2 : Polynomial ℚ := C ((-1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((-1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_10_2 : Ki := ofLadj spanU_re_10_2 spanU_im_10_2

@[expose] public def spanU_re_10_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_10_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_10_3 : Ki := ofLadj spanU_re_10_3 spanU_im_10_3

@[expose] public def spanU_re_10_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_10_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_10_4 : Ki := ofLadj spanU_re_10_4 spanU_im_10_4

@[expose] public def spanU_re_10_5 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_10_5 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_10_5 : Ki := ofLadj spanU_re_10_5 spanU_im_10_5

@[expose] public def spanU_re_10_6 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_10_6 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_10_6 : Ki := ofLadj spanU_re_10_6 spanU_im_10_6

@[expose] public def spanU_re_10_7 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_10_7 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_10_7 : Ki := ofLadj spanU_re_10_7 spanU_im_10_7

@[expose] public def spanU_re_10_8 : Polynomial ℚ := C ((-3 / 44 : ℚ)) + C ((-1 / 44 : ℚ)) * X ^ 3 + C ((-1 / 44 : ℚ)) * X ^ 4 + C ((-1 / 22 : ℚ)) * X ^ 5 + C ((-1 / 22 : ℚ)) * X ^ 6 + C ((-1 / 44 : ℚ)) * X ^ 7 + C ((-1 / 44 : ℚ)) * X ^ 8
@[expose] public def spanU_im_10_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_10_8 : Ki := ofLadj spanU_re_10_8 spanU_im_10_8

@[expose] public def spanU_re_11_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_11_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_11_0 : Ki := ofLadj spanU_re_11_0 spanU_im_11_0

@[expose] public def spanU_re_11_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_11_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_11_1 : Ki := ofLadj spanU_re_11_1 spanU_im_11_1

@[expose] public def spanU_re_11_2 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_11_2 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 7
@[expose] public def spanU_entry_11_2 : Ki := ofLadj spanU_re_11_2 spanU_im_11_2

@[expose] public def spanU_re_11_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_11_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_11_3 : Ki := ofLadj spanU_re_11_3 spanU_im_11_3

@[expose] public def spanU_re_11_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_11_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_11_4 : Ki := ofLadj spanU_re_11_4 spanU_im_11_4

@[expose] public def spanU_re_11_5 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 44 : ℚ)) * X ^ 5 + C ((1 / 44 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_11_5 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_11_5 : Ki := ofLadj spanU_re_11_5 spanU_im_11_5

@[expose] public def spanU_re_11_6 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_im_11_6 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 7
@[expose] public def spanU_entry_11_6 : Ki := ofLadj spanU_re_11_6 spanU_im_11_6

@[expose] public def spanU_re_11_7 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 44 : ℚ)) * X ^ 5 + C ((1 / 44 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_11_7 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_11_7 : Ki := ofLadj spanU_re_11_7 spanU_im_11_7

@[expose] public def spanU_re_11_8 : Polynomial ℚ := C ((1 / 44 : ℚ)) + C ((-1 / 22 : ℚ)) * X ^ 2 + C ((-1 / 44 : ℚ)) * X ^ 3 + C ((-1 / 22 : ℚ)) * X ^ 4 + C ((-1 / 44 : ℚ)) * X ^ 5 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((-1 / 22 : ℚ)) * X ^ 7 + C ((-1 / 44 : ℚ)) * X ^ 8 + C ((-1 / 22 : ℚ)) * X ^ 9
@[expose] public def spanU_im_11_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_11_8 : Ki := ofLadj spanU_re_11_8 spanU_im_11_8

@[expose] public def spanU_re_12_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_12_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_12_0 : Ki := ofLadj spanU_re_12_0 spanU_im_12_0

@[expose] public def spanU_re_12_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_12_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_12_1 : Ki := ofLadj spanU_re_12_1 spanU_im_12_1

@[expose] public def spanU_re_12_2 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7
@[expose] public def spanU_im_12_2 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 44 : ℚ)) * X + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_12_2 : Ki := ofLadj spanU_re_12_2 spanU_im_12_2

@[expose] public def spanU_re_12_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_12_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_12_3 : Ki := ofLadj spanU_re_12_3 spanU_im_12_3

@[expose] public def spanU_re_12_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_12_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_12_4 : Ki := ofLadj spanU_re_12_4 spanU_im_12_4

@[expose] public def spanU_re_12_5 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_12_5 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_12_5 : Ki := ofLadj spanU_re_12_5 spanU_im_12_5

@[expose] public def spanU_re_12_6 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7
@[expose] public def spanU_im_12_6 : Polynomial ℚ := C ((-1 / 88 : ℚ)) + C ((-1 / 44 : ℚ)) * X + C ((-1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 5 + C ((-1 / 88 : ℚ)) * X ^ 6 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 8 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_12_6 : Ki := ofLadj spanU_re_12_6 spanU_im_12_6

@[expose] public def spanU_re_12_7 : Polynomial ℚ := C ((1 / 88 : ℚ)) + C ((1 / 88 : ℚ)) * X ^ 2 + C ((1 / 44 : ℚ)) * X ^ 3 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 5 + C ((1 / 88 : ℚ)) * X ^ 6 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((1 / 44 : ℚ)) * X ^ 8 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_im_12_7 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 3 + C ((-1 / 88 : ℚ)) * X ^ 8
@[expose] public def spanU_entry_12_7 : Ki := ofLadj spanU_re_12_7 spanU_im_12_7

@[expose] public def spanU_re_12_8 : Polynomial ℚ := C ((1 / 44 : ℚ)) * X ^ 2 + C ((-1 / 44 : ℚ)) * X ^ 5 + C ((-1 / 44 : ℚ)) * X ^ 6 + C ((1 / 44 : ℚ)) * X ^ 9
@[expose] public def spanU_im_12_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_12_8 : Ki := ofLadj spanU_re_12_8 spanU_im_12_8

@[expose] public def spanU_re_13_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_13_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_13_0 : Ki := ofLadj spanU_re_13_0 spanU_im_13_0

@[expose] public def spanU_re_13_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_13_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_13_1 : Ki := ofLadj spanU_re_13_1 spanU_im_13_1

@[expose] public def spanU_re_13_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_13_2 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_13_2 : Ki := ofLadj spanU_re_13_2 spanU_im_13_2

@[expose] public def spanU_re_13_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_13_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_13_3 : Ki := ofLadj spanU_re_13_3 spanU_im_13_3

@[expose] public def spanU_re_13_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_13_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_13_4 : Ki := ofLadj spanU_re_13_4 spanU_im_13_4

@[expose] public def spanU_re_13_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_13_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_13_5 : Ki := ofLadj spanU_re_13_5 spanU_im_13_5

@[expose] public def spanU_re_13_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_13_6 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_13_6 : Ki := ofLadj spanU_re_13_6 spanU_im_13_6

@[expose] public def spanU_re_13_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_13_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_13_7 : Ki := ofLadj spanU_re_13_7 spanU_im_13_7

@[expose] public def spanU_re_13_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_13_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_13_8 : Ki := ofLadj spanU_re_13_8 spanU_im_13_8

@[expose] public def spanU_re_14_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_14_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_14_0 : Ki := ofLadj spanU_re_14_0 spanU_im_14_0

@[expose] public def spanU_re_14_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_14_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_14_1 : Ki := ofLadj spanU_re_14_1 spanU_im_14_1

@[expose] public def spanU_re_14_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_14_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_14_2 : Ki := ofLadj spanU_re_14_2 spanU_im_14_2

@[expose] public def spanU_re_14_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_14_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_14_3 : Ki := ofLadj spanU_re_14_3 spanU_im_14_3

@[expose] public def spanU_re_14_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_14_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_14_4 : Ki := ofLadj spanU_re_14_4 spanU_im_14_4

@[expose] public def spanU_re_14_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_14_5 : Polynomial ℚ := C ((1 / 88 : ℚ)) * X ^ 2 + C ((-1 / 88 : ℚ)) * X ^ 4 + C ((1 / 88 : ℚ)) * X ^ 7 + C ((-1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_14_5 : Ki := ofLadj spanU_re_14_5 spanU_im_14_5

@[expose] public def spanU_re_14_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_14_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_14_6 : Ki := ofLadj spanU_re_14_6 spanU_im_14_6

@[expose] public def spanU_re_14_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_14_7 : Polynomial ℚ := C ((-1 / 88 : ℚ)) * X ^ 2 + C ((1 / 88 : ℚ)) * X ^ 4 + C ((-1 / 88 : ℚ)) * X ^ 7 + C ((1 / 88 : ℚ)) * X ^ 9
@[expose] public def spanU_entry_14_7 : Ki := ofLadj spanU_re_14_7 spanU_im_14_7

@[expose] public def spanU_re_14_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_im_14_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanU_entry_14_8 : Ki := ofLadj spanU_re_14_8 spanU_im_14_8

@[expose] public def spanU : Matrix (Fin 15) (Fin 9) Ki :=
  fun i j =>
    match i.val, j.val with
    | 0, 0 => spanU_entry_0_0
    | 0, 1 => spanU_entry_0_1
    | 0, 2 => spanU_entry_0_2
    | 0, 3 => spanU_entry_0_3
    | 0, 4 => spanU_entry_0_4
    | 0, 5 => spanU_entry_0_5
    | 0, 6 => spanU_entry_0_6
    | 0, 7 => spanU_entry_0_7
    | 0, 8 => spanU_entry_0_8
    | 1, 0 => spanU_entry_1_0
    | 1, 1 => spanU_entry_1_1
    | 1, 2 => spanU_entry_1_2
    | 1, 3 => spanU_entry_1_3
    | 1, 4 => spanU_entry_1_4
    | 1, 5 => spanU_entry_1_5
    | 1, 6 => spanU_entry_1_6
    | 1, 7 => spanU_entry_1_7
    | 1, 8 => spanU_entry_1_8
    | 2, 0 => spanU_entry_2_0
    | 2, 1 => spanU_entry_2_1
    | 2, 2 => spanU_entry_2_2
    | 2, 3 => spanU_entry_2_3
    | 2, 4 => spanU_entry_2_4
    | 2, 5 => spanU_entry_2_5
    | 2, 6 => spanU_entry_2_6
    | 2, 7 => spanU_entry_2_7
    | 2, 8 => spanU_entry_2_8
    | 3, 0 => spanU_entry_3_0
    | 3, 1 => spanU_entry_3_1
    | 3, 2 => spanU_entry_3_2
    | 3, 3 => spanU_entry_3_3
    | 3, 4 => spanU_entry_3_4
    | 3, 5 => spanU_entry_3_5
    | 3, 6 => spanU_entry_3_6
    | 3, 7 => spanU_entry_3_7
    | 3, 8 => spanU_entry_3_8
    | 4, 0 => spanU_entry_4_0
    | 4, 1 => spanU_entry_4_1
    | 4, 2 => spanU_entry_4_2
    | 4, 3 => spanU_entry_4_3
    | 4, 4 => spanU_entry_4_4
    | 4, 5 => spanU_entry_4_5
    | 4, 6 => spanU_entry_4_6
    | 4, 7 => spanU_entry_4_7
    | 4, 8 => spanU_entry_4_8
    | 5, 0 => spanU_entry_5_0
    | 5, 1 => spanU_entry_5_1
    | 5, 2 => spanU_entry_5_2
    | 5, 3 => spanU_entry_5_3
    | 5, 4 => spanU_entry_5_4
    | 5, 5 => spanU_entry_5_5
    | 5, 6 => spanU_entry_5_6
    | 5, 7 => spanU_entry_5_7
    | 5, 8 => spanU_entry_5_8
    | 6, 0 => spanU_entry_6_0
    | 6, 1 => spanU_entry_6_1
    | 6, 2 => spanU_entry_6_2
    | 6, 3 => spanU_entry_6_3
    | 6, 4 => spanU_entry_6_4
    | 6, 5 => spanU_entry_6_5
    | 6, 6 => spanU_entry_6_6
    | 6, 7 => spanU_entry_6_7
    | 6, 8 => spanU_entry_6_8
    | 7, 0 => spanU_entry_7_0
    | 7, 1 => spanU_entry_7_1
    | 7, 2 => spanU_entry_7_2
    | 7, 3 => spanU_entry_7_3
    | 7, 4 => spanU_entry_7_4
    | 7, 5 => spanU_entry_7_5
    | 7, 6 => spanU_entry_7_6
    | 7, 7 => spanU_entry_7_7
    | 7, 8 => spanU_entry_7_8
    | 8, 0 => spanU_entry_8_0
    | 8, 1 => spanU_entry_8_1
    | 8, 2 => spanU_entry_8_2
    | 8, 3 => spanU_entry_8_3
    | 8, 4 => spanU_entry_8_4
    | 8, 5 => spanU_entry_8_5
    | 8, 6 => spanU_entry_8_6
    | 8, 7 => spanU_entry_8_7
    | 8, 8 => spanU_entry_8_8
    | 9, 0 => spanU_entry_9_0
    | 9, 1 => spanU_entry_9_1
    | 9, 2 => spanU_entry_9_2
    | 9, 3 => spanU_entry_9_3
    | 9, 4 => spanU_entry_9_4
    | 9, 5 => spanU_entry_9_5
    | 9, 6 => spanU_entry_9_6
    | 9, 7 => spanU_entry_9_7
    | 9, 8 => spanU_entry_9_8
    | 10, 0 => spanU_entry_10_0
    | 10, 1 => spanU_entry_10_1
    | 10, 2 => spanU_entry_10_2
    | 10, 3 => spanU_entry_10_3
    | 10, 4 => spanU_entry_10_4
    | 10, 5 => spanU_entry_10_5
    | 10, 6 => spanU_entry_10_6
    | 10, 7 => spanU_entry_10_7
    | 10, 8 => spanU_entry_10_8
    | 11, 0 => spanU_entry_11_0
    | 11, 1 => spanU_entry_11_1
    | 11, 2 => spanU_entry_11_2
    | 11, 3 => spanU_entry_11_3
    | 11, 4 => spanU_entry_11_4
    | 11, 5 => spanU_entry_11_5
    | 11, 6 => spanU_entry_11_6
    | 11, 7 => spanU_entry_11_7
    | 11, 8 => spanU_entry_11_8
    | 12, 0 => spanU_entry_12_0
    | 12, 1 => spanU_entry_12_1
    | 12, 2 => spanU_entry_12_2
    | 12, 3 => spanU_entry_12_3
    | 12, 4 => spanU_entry_12_4
    | 12, 5 => spanU_entry_12_5
    | 12, 6 => spanU_entry_12_6
    | 12, 7 => spanU_entry_12_7
    | 12, 8 => spanU_entry_12_8
    | 13, 0 => spanU_entry_13_0
    | 13, 1 => spanU_entry_13_1
    | 13, 2 => spanU_entry_13_2
    | 13, 3 => spanU_entry_13_3
    | 13, 4 => spanU_entry_13_4
    | 13, 5 => spanU_entry_13_5
    | 13, 6 => spanU_entry_13_6
    | 13, 7 => spanU_entry_13_7
    | 13, 8 => spanU_entry_13_8
    | 14, 0 => spanU_entry_14_0
    | 14, 1 => spanU_entry_14_1
    | 14, 2 => spanU_entry_14_2
    | 14, 3 => spanU_entry_14_3
    | 14, 4 => spanU_entry_14_4
    | 14, 5 => spanU_entry_14_5
    | 14, 6 => spanU_entry_14_6
    | 14, 7 => spanU_entry_14_7
    | 14, 8 => spanU_entry_14_8
    | _, _ => spanU_entry_0_0

end V14Formalization.D12SigmaPlusSegreCore
