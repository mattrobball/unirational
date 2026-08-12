/-
Plus Segre span matrix Qplus.
-/
import V14Formalization.D12SigmaPlusSegreEval

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore

def Qplus_re_0_0 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 8
def Qplus_im_0_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_0 : Ki := ofLadj Qplus_re_0_0 Qplus_im_0_0

def Qplus_re_0_1 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6
def Qplus_im_0_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_1 : Ki := ofLadj Qplus_re_0_1 Qplus_im_0_1

def Qplus_re_0_2 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_0_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_2 : Ki := ofLadj Qplus_re_0_2 Qplus_im_0_2

def Qplus_re_0_3 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_0_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_3 : Ki := ofLadj Qplus_re_0_3 Qplus_im_0_3

def Qplus_re_0_4 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 7
def Qplus_im_0_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_4 : Ki := ofLadj Qplus_re_0_4 Qplus_im_0_4

def Qplus_re_0_5 : Polynomial ℚ := C (-1)
def Qplus_im_0_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_5 : Ki := ofLadj Qplus_re_0_5 Qplus_im_0_5

def Qplus_re_0_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_6 : Ki := ofLadj Qplus_re_0_6 Qplus_im_0_6

def Qplus_re_0_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_7 : Ki := ofLadj Qplus_re_0_7 Qplus_im_0_7

def Qplus_re_0_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_8 : Ki := ofLadj Qplus_re_0_8 Qplus_im_0_8

def Qplus_re_0_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_9 : Ki := ofLadj Qplus_re_0_9 Qplus_im_0_9

def Qplus_re_0_10 : Polynomial ℚ := C (-1)
def Qplus_im_0_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_10 : Ki := ofLadj Qplus_re_0_10 Qplus_im_0_10

def Qplus_re_0_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_11 : Ki := ofLadj Qplus_re_0_11 Qplus_im_0_11

def Qplus_re_0_12 : Polynomial ℚ := C ((-1 / 2 : ℚ))
def Qplus_im_0_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_12 : Ki := ofLadj Qplus_re_0_12 Qplus_im_0_12

def Qplus_re_0_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_13 : Ki := ofLadj Qplus_re_0_13 Qplus_im_0_13

def Qplus_re_0_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_14 : Ki := ofLadj Qplus_re_0_14 Qplus_im_0_14

def Qplus_re_0_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_15 : Ki := ofLadj Qplus_re_0_15 Qplus_im_0_15

def Qplus_re_0_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_16 : Ki := ofLadj Qplus_re_0_16 Qplus_im_0_16

def Qplus_re_0_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_17 : Ki := ofLadj Qplus_re_0_17 Qplus_im_0_17

def Qplus_re_0_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_18 : Ki := ofLadj Qplus_re_0_18 Qplus_im_0_18

def Qplus_re_0_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_19 : Ki := ofLadj Qplus_re_0_19 Qplus_im_0_19

def Qplus_re_0_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_0_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_0_20 : Ki := ofLadj Qplus_re_0_20 Qplus_im_0_20

def Qplus_re_1_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_0 : Ki := ofLadj Qplus_re_1_0 Qplus_im_1_0

def Qplus_re_1_1 : Polynomial ℚ := C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_1_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_1 : Ki := ofLadj Qplus_re_1_1 Qplus_im_1_1

def Qplus_re_1_2 : Polynomial ℚ := C ((-1 / 2 : ℚ))
def Qplus_im_1_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_2 : Ki := ofLadj Qplus_re_1_2 Qplus_im_1_2

def Qplus_re_1_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_3 : Ki := ofLadj Qplus_re_1_3 Qplus_im_1_3

def Qplus_re_1_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_4 : Ki := ofLadj Qplus_re_1_4 Qplus_im_1_4

def Qplus_re_1_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_5 : Ki := ofLadj Qplus_re_1_5 Qplus_im_1_5

def Qplus_re_1_6 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_1_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_6 : Ki := ofLadj Qplus_re_1_6 Qplus_im_1_6

def Qplus_re_1_7 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 8
def Qplus_im_1_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_7 : Ki := ofLadj Qplus_re_1_7 Qplus_im_1_7

def Qplus_re_1_8 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 7
def Qplus_im_1_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_8 : Ki := ofLadj Qplus_re_1_8 Qplus_im_1_8

def Qplus_re_1_9 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6
def Qplus_im_1_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_9 : Ki := ofLadj Qplus_re_1_9 Qplus_im_1_9

def Qplus_re_1_10 : Polynomial ℚ := C (1)
def Qplus_im_1_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_10 : Ki := ofLadj Qplus_re_1_10 Qplus_im_1_10

def Qplus_re_1_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_11 : Ki := ofLadj Qplus_re_1_11 Qplus_im_1_11

def Qplus_re_1_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_12 : Ki := ofLadj Qplus_re_1_12 Qplus_im_1_12

def Qplus_re_1_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_13 : Ki := ofLadj Qplus_re_1_13 Qplus_im_1_13

def Qplus_re_1_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_14 : Ki := ofLadj Qplus_re_1_14 Qplus_im_1_14

def Qplus_re_1_15 : Polynomial ℚ := C ((-1 / 2 : ℚ))
def Qplus_im_1_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_15 : Ki := ofLadj Qplus_re_1_15 Qplus_im_1_15

def Qplus_re_1_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_16 : Ki := ofLadj Qplus_re_1_16 Qplus_im_1_16

def Qplus_re_1_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_17 : Ki := ofLadj Qplus_re_1_17 Qplus_im_1_17

def Qplus_re_1_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_18 : Ki := ofLadj Qplus_re_1_18 Qplus_im_1_18

def Qplus_re_1_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_19 : Ki := ofLadj Qplus_re_1_19 Qplus_im_1_19

def Qplus_re_1_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_1_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_1_20 : Ki := ofLadj Qplus_re_1_20 Qplus_im_1_20

def Qplus_re_2_0 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_2_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_0 : Ki := ofLadj Qplus_re_2_0 Qplus_im_2_0

def Qplus_re_2_1 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7
def Qplus_im_2_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_1 : Ki := ofLadj Qplus_re_2_1 Qplus_im_2_1

def Qplus_re_2_2 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_2_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_2 : Ki := ofLadj Qplus_re_2_2 Qplus_im_2_2

def Qplus_re_2_3 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_2_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_3 : Ki := ofLadj Qplus_re_2_3 Qplus_im_2_3

def Qplus_re_2_4 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_2_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_4 : Ki := ofLadj Qplus_re_2_4 Qplus_im_2_4

def Qplus_re_2_5 : Polynomial ℚ := C (1)
def Qplus_im_2_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_5 : Ki := ofLadj Qplus_re_2_5 Qplus_im_2_5

def Qplus_re_2_6 : Polynomial ℚ := C ((-1 / 2 : ℚ))
def Qplus_im_2_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_6 : Ki := ofLadj Qplus_re_2_6 Qplus_im_2_6

def Qplus_re_2_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_7 : Ki := ofLadj Qplus_re_2_7 Qplus_im_2_7

def Qplus_re_2_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_8 : Ki := ofLadj Qplus_re_2_8 Qplus_im_2_8

def Qplus_re_2_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_9 : Ki := ofLadj Qplus_re_2_9 Qplus_im_2_9

def Qplus_re_2_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_10 : Ki := ofLadj Qplus_re_2_10 Qplus_im_2_10

def Qplus_re_2_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_11 : Ki := ofLadj Qplus_re_2_11 Qplus_im_2_11

def Qplus_re_2_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_12 : Ki := ofLadj Qplus_re_2_12 Qplus_im_2_12

def Qplus_re_2_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_13 : Ki := ofLadj Qplus_re_2_13 Qplus_im_2_13

def Qplus_re_2_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_14 : Ki := ofLadj Qplus_re_2_14 Qplus_im_2_14

def Qplus_re_2_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_15 : Ki := ofLadj Qplus_re_2_15 Qplus_im_2_15

def Qplus_re_2_16 : Polynomial ℚ := C ((-1 / 2 : ℚ))
def Qplus_im_2_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_16 : Ki := ofLadj Qplus_re_2_16 Qplus_im_2_16

def Qplus_re_2_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_17 : Ki := ofLadj Qplus_re_2_17 Qplus_im_2_17

def Qplus_re_2_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_18 : Ki := ofLadj Qplus_re_2_18 Qplus_im_2_18

def Qplus_re_2_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_19 : Ki := ofLadj Qplus_re_2_19 Qplus_im_2_19

def Qplus_re_2_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_2_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_2_20 : Ki := ofLadj Qplus_re_2_20 Qplus_im_2_20

def Qplus_re_3_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_0 : Ki := ofLadj Qplus_re_3_0 Qplus_im_3_0

def Qplus_re_3_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_1 : Ki := ofLadj Qplus_re_3_1 Qplus_im_3_1

def Qplus_re_3_2 : Polynomial ℚ := C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_3_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_2 : Ki := ofLadj Qplus_re_3_2 Qplus_im_3_2

def Qplus_re_3_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_3 : Ki := ofLadj Qplus_re_3_3 Qplus_im_3_3

def Qplus_re_3_4 : Polynomial ℚ := C ((1 / 2 : ℚ))
def Qplus_im_3_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_4 : Ki := ofLadj Qplus_re_3_4 Qplus_im_3_4

def Qplus_re_3_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_5 : Ki := ofLadj Qplus_re_3_5 Qplus_im_3_5

def Qplus_re_3_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_6 : Ki := ofLadj Qplus_re_3_6 Qplus_im_3_6

def Qplus_re_3_7 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_3_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_7 : Ki := ofLadj Qplus_re_3_7 Qplus_im_3_7

def Qplus_re_3_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_8 : Ki := ofLadj Qplus_re_3_8 Qplus_im_3_8

def Qplus_re_3_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_9 : Ki := ofLadj Qplus_re_3_9 Qplus_im_3_9

def Qplus_re_3_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_10 : Ki := ofLadj Qplus_re_3_10 Qplus_im_3_10

def Qplus_re_3_11 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 8
def Qplus_im_3_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_11 : Ki := ofLadj Qplus_re_3_11 Qplus_im_3_11

def Qplus_re_3_12 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 7
def Qplus_im_3_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_12 : Ki := ofLadj Qplus_re_3_12 Qplus_im_3_12

def Qplus_re_3_13 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6
def Qplus_im_3_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_13 : Ki := ofLadj Qplus_re_3_13 Qplus_im_3_13

def Qplus_re_3_14 : Polynomial ℚ := C (1)
def Qplus_im_3_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_14 : Ki := ofLadj Qplus_re_3_14 Qplus_im_3_14

def Qplus_re_3_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_15 : Ki := ofLadj Qplus_re_3_15 Qplus_im_3_15

def Qplus_re_3_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_16 : Ki := ofLadj Qplus_re_3_16 Qplus_im_3_16

def Qplus_re_3_17 : Polynomial ℚ := C (1)
def Qplus_im_3_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_17 : Ki := ofLadj Qplus_re_3_17 Qplus_im_3_17

def Qplus_re_3_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_18 : Ki := ofLadj Qplus_re_3_18 Qplus_im_3_18

def Qplus_re_3_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_19 : Ki := ofLadj Qplus_re_3_19 Qplus_im_3_19

def Qplus_re_3_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_3_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_3_20 : Ki := ofLadj Qplus_re_3_20 Qplus_im_3_20

def Qplus_re_4_0 : Polynomial ℚ := C ((-1 / 2 : ℚ))
def Qplus_im_4_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_0 : Ki := ofLadj Qplus_re_4_0 Qplus_im_4_0

def Qplus_re_4_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_1 : Ki := ofLadj Qplus_re_4_1 Qplus_im_4_1

def Qplus_re_4_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_2 : Ki := ofLadj Qplus_re_4_2 Qplus_im_4_2

def Qplus_re_4_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_3 : Ki := ofLadj Qplus_re_4_3 Qplus_im_4_3

def Qplus_re_4_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_4 : Ki := ofLadj Qplus_re_4_4 Qplus_im_4_4

def Qplus_re_4_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_5 : Ki := ofLadj Qplus_re_4_5 Qplus_im_4_5

def Qplus_re_4_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_6 : Ki := ofLadj Qplus_re_4_6 Qplus_im_4_6

def Qplus_re_4_7 : Polynomial ℚ := C ((-1 / 2 : ℚ))
def Qplus_im_4_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_7 : Ki := ofLadj Qplus_re_4_7 Qplus_im_4_7

def Qplus_re_4_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_8 : Ki := ofLadj Qplus_re_4_8 Qplus_im_4_8

def Qplus_re_4_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_9 : Ki := ofLadj Qplus_re_4_9 Qplus_im_4_9

def Qplus_re_4_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_10 : Ki := ofLadj Qplus_re_4_10 Qplus_im_4_10

def Qplus_re_4_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_11 : Ki := ofLadj Qplus_re_4_11 Qplus_im_4_11

def Qplus_re_4_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_12 : Ki := ofLadj Qplus_re_4_12 Qplus_im_4_12

def Qplus_re_4_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_13 : Ki := ofLadj Qplus_re_4_13 Qplus_im_4_13

def Qplus_re_4_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_14 : Ki := ofLadj Qplus_re_4_14 Qplus_im_4_14

def Qplus_re_4_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_15 : Ki := ofLadj Qplus_re_4_15 Qplus_im_4_15

def Qplus_re_4_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_16 : Ki := ofLadj Qplus_re_4_16 Qplus_im_4_16

def Qplus_re_4_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_17 : Ki := ofLadj Qplus_re_4_17 Qplus_im_4_17

def Qplus_re_4_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_18 : Ki := ofLadj Qplus_re_4_18 Qplus_im_4_18

def Qplus_re_4_19 : Polynomial ℚ := C (1)
def Qplus_im_4_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_19 : Ki := ofLadj Qplus_re_4_19 Qplus_im_4_19

def Qplus_re_4_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_4_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_4_20 : Ki := ofLadj Qplus_re_4_20 Qplus_im_4_20

def Qplus_re_5_0 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_5_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_0 : Ki := ofLadj Qplus_re_5_0 Qplus_im_5_0

def Qplus_re_5_1 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_5_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_1 : Ki := ofLadj Qplus_re_5_1 Qplus_im_5_1

def Qplus_re_5_2 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_5_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_2 : Ki := ofLadj Qplus_re_5_2 Qplus_im_5_2

def Qplus_re_5_3 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7
def Qplus_im_5_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_3 : Ki := ofLadj Qplus_re_5_3 Qplus_im_5_3

def Qplus_re_5_4 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8
def Qplus_im_5_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_4 : Ki := ofLadj Qplus_re_5_4 Qplus_im_5_4

def Qplus_re_5_5 : Polynomial ℚ := C (-1)
def Qplus_im_5_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_5 : Ki := ofLadj Qplus_re_5_5 Qplus_im_5_5

def Qplus_re_5_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_5_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_6 : Ki := ofLadj Qplus_re_5_6 Qplus_im_5_6

def Qplus_re_5_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_5_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_7 : Ki := ofLadj Qplus_re_5_7 Qplus_im_5_7

def Qplus_re_5_8 : Polynomial ℚ := C ((-1 / 2 : ℚ))
def Qplus_im_5_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_8 : Ki := ofLadj Qplus_re_5_8 Qplus_im_5_8

def Qplus_re_5_9 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_5_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_9 : Ki := ofLadj Qplus_re_5_9 Qplus_im_5_9

def Qplus_re_5_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_5_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_10 : Ki := ofLadj Qplus_re_5_10 Qplus_im_5_10

def Qplus_re_5_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_5_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_11 : Ki := ofLadj Qplus_re_5_11 Qplus_im_5_11

def Qplus_re_5_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_5_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_12 : Ki := ofLadj Qplus_re_5_12 Qplus_im_5_12

def Qplus_re_5_13 : Polynomial ℚ := C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 8
def Qplus_im_5_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_13 : Ki := ofLadj Qplus_re_5_13 Qplus_im_5_13

def Qplus_re_5_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_5_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_14 : Ki := ofLadj Qplus_re_5_14 Qplus_im_5_14

def Qplus_re_5_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_5_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_15 : Ki := ofLadj Qplus_re_5_15 Qplus_im_5_15

def Qplus_re_5_16 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 7
def Qplus_im_5_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_16 : Ki := ofLadj Qplus_re_5_16 Qplus_im_5_16

def Qplus_re_5_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_5_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_17 : Ki := ofLadj Qplus_re_5_17 Qplus_im_5_17

def Qplus_re_5_18 : Polynomial ℚ := C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6
def Qplus_im_5_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_18 : Ki := ofLadj Qplus_re_5_18 Qplus_im_5_18

def Qplus_re_5_19 : Polynomial ℚ := C (-1)
def Qplus_im_5_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_19 : Ki := ofLadj Qplus_re_5_19 Qplus_im_5_19

def Qplus_re_5_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_5_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_5_20 : Ki := ofLadj Qplus_re_5_20 Qplus_im_5_20

def Qplus_re_6_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_0 : Ki := ofLadj Qplus_re_6_0 Qplus_im_6_0

def Qplus_re_6_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_1 : Ki := ofLadj Qplus_re_6_1 Qplus_im_6_1

def Qplus_re_6_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_2 : Ki := ofLadj Qplus_re_6_2 Qplus_im_6_2

def Qplus_re_6_3 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 8
def Qplus_im_6_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_3 : Ki := ofLadj Qplus_re_6_3 Qplus_im_6_3

def Qplus_re_6_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_4 : Ki := ofLadj Qplus_re_6_4 Qplus_im_6_4

def Qplus_re_6_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_5 : Ki := ofLadj Qplus_re_6_5 Qplus_im_6_5

def Qplus_re_6_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_6 : Ki := ofLadj Qplus_re_6_6 Qplus_im_6_6

def Qplus_re_6_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_7 : Ki := ofLadj Qplus_re_6_7 Qplus_im_6_7

def Qplus_re_6_8 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6
def Qplus_im_6_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_8 : Ki := ofLadj Qplus_re_6_8 Qplus_im_6_8

def Qplus_re_6_9 : Polynomial ℚ := C ((1 / 2 : ℚ))
def Qplus_im_6_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_9 : Ki := ofLadj Qplus_re_6_9 Qplus_im_6_9

def Qplus_re_6_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_10 : Ki := ofLadj Qplus_re_6_10 Qplus_im_6_10

def Qplus_re_6_11 : Polynomial ℚ := C ((1 / 2 : ℚ))
def Qplus_im_6_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_11 : Ki := ofLadj Qplus_re_6_11 Qplus_im_6_11

def Qplus_re_6_12 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_6_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_12 : Ki := ofLadj Qplus_re_6_12 Qplus_im_6_12

def Qplus_re_6_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_13 : Ki := ofLadj Qplus_re_6_13 Qplus_im_6_13

def Qplus_re_6_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_14 : Ki := ofLadj Qplus_re_6_14 Qplus_im_6_14

def Qplus_re_6_15 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_6_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_15 : Ki := ofLadj Qplus_re_6_15 Qplus_im_6_15

def Qplus_re_6_16 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 7
def Qplus_im_6_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_16 : Ki := ofLadj Qplus_re_6_16 Qplus_im_6_16

def Qplus_re_6_17 : Polynomial ℚ := C (-1)
def Qplus_im_6_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_17 : Ki := ofLadj Qplus_re_6_17 Qplus_im_6_17

def Qplus_re_6_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_18 : Ki := ofLadj Qplus_re_6_18 Qplus_im_6_18

def Qplus_re_6_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_19 : Ki := ofLadj Qplus_re_6_19 Qplus_im_6_19

def Qplus_re_6_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_6_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_6_20 : Ki := ofLadj Qplus_re_6_20 Qplus_im_6_20

def Qplus_re_7_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_7_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_0 : Ki := ofLadj Qplus_re_7_0 Qplus_im_7_0

def Qplus_re_7_1 : Polynomial ℚ := C ((-1 / 2 : ℚ))
def Qplus_im_7_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_1 : Ki := ofLadj Qplus_re_7_1 Qplus_im_7_1

def Qplus_re_7_2 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_7_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_2 : Ki := ofLadj Qplus_re_7_2 Qplus_im_7_2

def Qplus_re_7_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_7_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_3 : Ki := ofLadj Qplus_re_7_3 Qplus_im_7_3

def Qplus_re_7_4 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 8
def Qplus_im_7_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_4 : Ki := ofLadj Qplus_re_7_4 Qplus_im_7_4

def Qplus_re_7_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_7_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_5 : Ki := ofLadj Qplus_re_7_5 Qplus_im_7_5

def Qplus_re_7_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_7_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_6 : Ki := ofLadj Qplus_re_7_6 Qplus_im_7_6

def Qplus_re_7_7 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7
def Qplus_im_7_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_7 : Ki := ofLadj Qplus_re_7_7 Qplus_im_7_7

def Qplus_re_7_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_7_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_8 : Ki := ofLadj Qplus_re_7_8 Qplus_im_7_8

def Qplus_re_7_9 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6
def Qplus_im_7_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_9 : Ki := ofLadj Qplus_re_7_9 Qplus_im_7_9

def Qplus_re_7_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_7_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_10 : Ki := ofLadj Qplus_re_7_10 Qplus_im_7_10

def Qplus_re_7_11 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_7_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_11 : Ki := ofLadj Qplus_re_7_11 Qplus_im_7_11

def Qplus_re_7_12 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_7_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_12 : Ki := ofLadj Qplus_re_7_12 Qplus_im_7_12

def Qplus_re_7_13 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 8
def Qplus_im_7_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_13 : Ki := ofLadj Qplus_re_7_13 Qplus_im_7_13

def Qplus_re_7_14 : Polynomial ℚ := C (-1)
def Qplus_im_7_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_14 : Ki := ofLadj Qplus_re_7_14 Qplus_im_7_14

def Qplus_re_7_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_7_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_15 : Ki := ofLadj Qplus_re_7_15 Qplus_im_7_15

def Qplus_re_7_16 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_7_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_16 : Ki := ofLadj Qplus_re_7_16 Qplus_im_7_16

def Qplus_re_7_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_7_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_17 : Ki := ofLadj Qplus_re_7_17 Qplus_im_7_17

def Qplus_re_7_18 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 7
def Qplus_im_7_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_18 : Ki := ofLadj Qplus_re_7_18 Qplus_im_7_18

def Qplus_re_7_19 : Polynomial ℚ := C (-1)
def Qplus_im_7_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_19 : Ki := ofLadj Qplus_re_7_19 Qplus_im_7_19

def Qplus_re_7_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_7_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_7_20 : Ki := ofLadj Qplus_re_7_20 Qplus_im_7_20

def Qplus_re_8_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_8_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_0 : Ki := ofLadj Qplus_re_8_0 Qplus_im_8_0

def Qplus_re_8_1 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_8_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_1 : Ki := ofLadj Qplus_re_8_1 Qplus_im_8_1

def Qplus_re_8_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_8_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_2 : Ki := ofLadj Qplus_re_8_2 Qplus_im_8_2

def Qplus_re_8_3 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_8_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_3 : Ki := ofLadj Qplus_re_8_3 Qplus_im_8_3

def Qplus_re_8_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_8_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_4 : Ki := ofLadj Qplus_re_8_4 Qplus_im_8_4

def Qplus_re_8_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_8_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_5 : Ki := ofLadj Qplus_re_8_5 Qplus_im_8_5

def Qplus_re_8_6 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_8_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_6 : Ki := ofLadj Qplus_re_8_6 Qplus_im_8_6

def Qplus_re_8_7 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_8_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_7 : Ki := ofLadj Qplus_re_8_7 Qplus_im_8_7

def Qplus_re_8_8 : Polynomial ℚ := C ((1 / 2 : ℚ))
def Qplus_im_8_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_8 : Ki := ofLadj Qplus_re_8_8 Qplus_im_8_8

def Qplus_re_8_9 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_8_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_9 : Ki := ofLadj Qplus_re_8_9 Qplus_im_8_9

def Qplus_re_8_10 : Polynomial ℚ := C (-1)
def Qplus_im_8_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_10 : Ki := ofLadj Qplus_re_8_10 Qplus_im_8_10

def Qplus_re_8_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_8_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_11 : Ki := ofLadj Qplus_re_8_11 Qplus_im_8_11

def Qplus_re_8_12 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_8_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_12 : Ki := ofLadj Qplus_re_8_12 Qplus_im_8_12

def Qplus_re_8_13 : Polynomial ℚ := C ((-1 / 2 : ℚ))
def Qplus_im_8_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_13 : Ki := ofLadj Qplus_re_8_13 Qplus_im_8_13

def Qplus_re_8_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_8_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_14 : Ki := ofLadj Qplus_re_8_14 Qplus_im_8_14

def Qplus_re_8_15 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_8_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_15 : Ki := ofLadj Qplus_re_8_15 Qplus_im_8_15

def Qplus_re_8_16 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_8_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_16 : Ki := ofLadj Qplus_re_8_16 Qplus_im_8_16

def Qplus_re_8_17 : Polynomial ℚ := C (-1)
def Qplus_im_8_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_17 : Ki := ofLadj Qplus_re_8_17 Qplus_im_8_17

def Qplus_re_8_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_8_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_18 : Ki := ofLadj Qplus_re_8_18 Qplus_im_8_18

def Qplus_re_8_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_8_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_19 : Ki := ofLadj Qplus_re_8_19 Qplus_im_8_19

def Qplus_re_8_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_8_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_8_20 : Ki := ofLadj Qplus_re_8_20 Qplus_im_8_20

def Qplus_re_9_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_0 : Ki := ofLadj Qplus_re_9_0 Qplus_im_9_0

def Qplus_re_9_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_1 : Ki := ofLadj Qplus_re_9_1 Qplus_im_9_1

def Qplus_re_9_2 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_9_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_2 : Ki := ofLadj Qplus_re_9_2 Qplus_im_9_2

def Qplus_re_9_3 : Polynomial ℚ := C ((1 / 2 : ℚ))
def Qplus_im_9_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_3 : Ki := ofLadj Qplus_re_9_3 Qplus_im_9_3

def Qplus_re_9_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_4 : Ki := ofLadj Qplus_re_9_4 Qplus_im_9_4

def Qplus_re_9_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_5 : Ki := ofLadj Qplus_re_9_5 Qplus_im_9_5

def Qplus_re_9_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_6 : Ki := ofLadj Qplus_re_9_6 Qplus_im_9_6

def Qplus_re_9_7 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_9_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_7 : Ki := ofLadj Qplus_re_9_7 Qplus_im_9_7

def Qplus_re_9_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_8 : Ki := ofLadj Qplus_re_9_8 Qplus_im_9_8

def Qplus_re_9_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_9 : Ki := ofLadj Qplus_re_9_9 Qplus_im_9_9

def Qplus_re_9_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_10 : Ki := ofLadj Qplus_re_9_10 Qplus_im_9_10

def Qplus_re_9_11 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_9_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_11 : Ki := ofLadj Qplus_re_9_11 Qplus_im_9_11

def Qplus_re_9_12 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7
def Qplus_im_9_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_12 : Ki := ofLadj Qplus_re_9_12 Qplus_im_9_12

def Qplus_re_9_13 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_9_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_13 : Ki := ofLadj Qplus_re_9_13 Qplus_im_9_13

def Qplus_re_9_14 : Polynomial ℚ := C (-1)
def Qplus_im_9_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_14 : Ki := ofLadj Qplus_re_9_14 Qplus_im_9_14

def Qplus_re_9_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_15 : Ki := ofLadj Qplus_re_9_15 Qplus_im_9_15

def Qplus_re_9_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_16 : Ki := ofLadj Qplus_re_9_16 Qplus_im_9_16

def Qplus_re_9_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_17 : Ki := ofLadj Qplus_re_9_17 Qplus_im_9_17

def Qplus_re_9_18 : Polynomial ℚ := C ((1 / 2 : ℚ))
def Qplus_im_9_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_18 : Ki := ofLadj Qplus_re_9_18 Qplus_im_9_18

def Qplus_re_9_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_19 : Ki := ofLadj Qplus_re_9_19 Qplus_im_9_19

def Qplus_re_9_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_9_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_9_20 : Ki := ofLadj Qplus_re_9_20 Qplus_im_9_20

def Qplus_re_10_0 : Polynomial ℚ := C ((1 / 4 : ℚ)) * X ^ 5 + C ((1 / 4 : ℚ)) * X ^ 6
def Qplus_im_10_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_0 : Ki := ofLadj Qplus_re_10_0 Qplus_im_10_0

def Qplus_re_10_1 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 8
def Qplus_im_10_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_1 : Ki := ofLadj Qplus_re_10_1 Qplus_im_10_1

def Qplus_re_10_2 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 5 + C ((1 / 4 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_10_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_2 : Ki := ofLadj Qplus_re_10_2 Qplus_im_10_2

def Qplus_re_10_3 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 4 : ℚ)) * X ^ 8 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_10_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_3 : Ki := ofLadj Qplus_re_10_3 Qplus_im_10_3

def Qplus_re_10_4 : Polynomial ℚ := C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((-3 / 4 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-3 / 4 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_10_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_4 : Ki := ofLadj Qplus_re_10_4 Qplus_im_10_4

def Qplus_re_10_5 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C (1) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C (1) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_10_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_5 : Ki := ofLadj Qplus_re_10_5 Qplus_im_10_5

def Qplus_re_10_6 : Polynomial ℚ := C ((-1 / 4 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 5 + C ((1 / 4 : ℚ)) * X ^ 6 + C ((-1 / 4 : ℚ)) * X ^ 7 + C ((-1 / 4 : ℚ)) * X ^ 8
def Qplus_im_10_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_6 : Ki := ofLadj Qplus_re_10_6 Qplus_im_10_6

def Qplus_re_10_7 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((-1 / 4 : ℚ)) * X ^ 2 + C ((-1 / 4 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 4 + C ((-1 / 4 : ℚ)) * X ^ 7 + C ((-1 / 4 : ℚ)) * X ^ 8 + C ((-1 / 4 : ℚ)) * X ^ 9
def Qplus_im_10_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_7 : Ki := ofLadj Qplus_re_10_7 Qplus_im_10_7

def Qplus_re_10_8 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 7
def Qplus_im_10_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_8 : Ki := ofLadj Qplus_re_10_8 Qplus_im_10_8

def Qplus_re_10_9 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((1 / 4 : ℚ)) * X ^ 8 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_10_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_9 : Ki := ofLadj Qplus_re_10_9 Qplus_im_10_9

def Qplus_re_10_10 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_10_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_10 : Ki := ofLadj Qplus_re_10_10 Qplus_im_10_10

def Qplus_re_10_11 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 7 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_10_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_11 : Ki := ofLadj Qplus_re_10_11 Qplus_im_10_11

def Qplus_re_10_12 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((-3 / 4 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 4 : ℚ)) * X ^ 5 + C ((-1 / 4 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-3 / 4 : ℚ)) * X ^ 9
def Qplus_im_10_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_12 : Ki := ofLadj Qplus_re_10_12 Qplus_im_10_12

def Qplus_re_10_13 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 4 + C ((-1 / 4 : ℚ)) * X ^ 7 + C ((1 / 4 : ℚ)) * X ^ 8 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_10_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_13 : Ki := ofLadj Qplus_re_10_13 Qplus_im_10_13

def Qplus_re_10_14 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_10_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_14 : Ki := ofLadj Qplus_re_10_14 Qplus_im_10_14

def Qplus_re_10_15 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 7 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_10_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_15 : Ki := ofLadj Qplus_re_10_15 Qplus_im_10_15

def Qplus_re_10_16 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 4 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 4 + C ((-1 / 4 : ℚ)) * X ^ 5 + C ((-1 / 4 : ℚ)) * X ^ 6 + C ((-1 / 4 : ℚ)) * X ^ 7 + C ((-1 / 4 : ℚ)) * X ^ 8
def Qplus_im_10_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_16 : Ki := ofLadj Qplus_re_10_16 Qplus_im_10_16

def Qplus_re_10_17 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_10_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_17 : Ki := ofLadj Qplus_re_10_17 Qplus_im_10_17

def Qplus_re_10_18 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 3 + C ((1 / 4 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 4 : ℚ)) * X ^ 7 + C ((1 / 4 : ℚ)) * X ^ 8
def Qplus_im_10_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_18 : Ki := ofLadj Qplus_re_10_18 Qplus_im_10_18

def Qplus_re_10_19 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7
def Qplus_im_10_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_19 : Ki := ofLadj Qplus_re_10_19 Qplus_im_10_19

def Qplus_re_10_20 : Polynomial ℚ := C (1)
def Qplus_im_10_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_10_20 : Ki := ofLadj Qplus_re_10_20 Qplus_im_10_20

def Qplus_re_11_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_11_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_0 : Ki := ofLadj Qplus_re_11_0 Qplus_im_11_0

def Qplus_re_11_1 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((-1 / 4 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 8
def Qplus_im_11_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_1 : Ki := ofLadj Qplus_re_11_1 Qplus_im_11_1

def Qplus_re_11_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_11_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_2 : Ki := ofLadj Qplus_re_11_2 Qplus_im_11_2

def Qplus_re_11_3 : Polynomial ℚ := C ((1 / 4 : ℚ))
def Qplus_im_11_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_3 : Ki := ofLadj Qplus_re_11_3 Qplus_im_11_3

def Qplus_re_11_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_11_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_4 : Ki := ofLadj Qplus_re_11_4 Qplus_im_11_4

def Qplus_re_11_5 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_11_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_5 : Ki := ofLadj Qplus_re_11_5 Qplus_im_11_5

def Qplus_re_11_6 : Polynomial ℚ := C ((-1 / 4 : ℚ)) * X ^ 5 + C ((-1 / 4 : ℚ)) * X ^ 6
def Qplus_im_11_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_6 : Ki := ofLadj Qplus_re_11_6 Qplus_im_11_6

def Qplus_re_11_7 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((-1 / 4 : ℚ)) * X ^ 2 + C ((-1 / 4 : ℚ)) * X ^ 9
def Qplus_im_11_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_7 : Ki := ofLadj Qplus_re_11_7 Qplus_im_11_7

def Qplus_re_11_8 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 3 + C ((1 / 4 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 5 + C ((1 / 4 : ℚ)) * X ^ 6 + C ((1 / 4 : ℚ)) * X ^ 7 + C ((1 / 4 : ℚ)) * X ^ 8 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_11_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_8 : Ki := ofLadj Qplus_re_11_8 Qplus_im_11_8

def Qplus_re_11_9 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((-1 / 4 : ℚ)) * X ^ 4 + C ((-1 / 4 : ℚ)) * X ^ 7
def Qplus_im_11_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_9 : Ki := ofLadj Qplus_re_11_9 Qplus_im_11_9

def Qplus_re_11_10 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7
def Qplus_im_11_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_10 : Ki := ofLadj Qplus_re_11_10 Qplus_im_11_10

def Qplus_re_11_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_11_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_11 : Ki := ofLadj Qplus_re_11_11 Qplus_im_11_11

def Qplus_re_11_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_11_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_12 : Ki := ofLadj Qplus_re_11_12 Qplus_im_11_12

def Qplus_re_11_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_11_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_13 : Ki := ofLadj Qplus_re_11_13 Qplus_im_11_13

def Qplus_re_11_14 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_11_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_14 : Ki := ofLadj Qplus_re_11_14 Qplus_im_11_14

def Qplus_re_11_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_11_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_15 : Ki := ofLadj Qplus_re_11_15 Qplus_im_11_15

def Qplus_re_11_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_11_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_16 : Ki := ofLadj Qplus_re_11_16 Qplus_im_11_16

def Qplus_re_11_17 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_11_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_17 : Ki := ofLadj Qplus_re_11_17 Qplus_im_11_17

def Qplus_re_11_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_11_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_18 : Ki := ofLadj Qplus_re_11_18 Qplus_im_11_18

def Qplus_re_11_19 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_11_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_19 : Ki := ofLadj Qplus_re_11_19 Qplus_im_11_19

def Qplus_re_11_20 : Polynomial ℚ := C (-1)
def Qplus_im_11_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_11_20 : Ki := ofLadj Qplus_re_11_20 Qplus_im_11_20

def Qplus_re_12_0 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 4 : ℚ)) * X ^ 7
def Qplus_im_12_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_0 : Ki := ofLadj Qplus_re_12_0 Qplus_im_12_0

def Qplus_re_12_1 : Polynomial ℚ := C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 4 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_12_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_1 : Ki := ofLadj Qplus_re_12_1 Qplus_im_12_1

def Qplus_re_12_2 : Polynomial ℚ := C ((3 / 4 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((3 / 4 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((3 / 4 : ℚ)) * X ^ 9
def Qplus_im_12_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_2 : Ki := ofLadj Qplus_re_12_2 Qplus_im_12_2

def Qplus_re_12_3 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 5 + C ((1 / 4 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_12_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_3 : Ki := ofLadj Qplus_re_12_3 Qplus_im_12_3

def Qplus_re_12_4 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-3 / 4 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_12_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_4 : Ki := ofLadj Qplus_re_12_4 Qplus_im_12_4

def Qplus_re_12_5 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C (1) * X ^ 2 + C (1) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C (1) * X ^ 8 + C (1) * X ^ 9
def Qplus_im_12_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_5 : Ki := ofLadj Qplus_re_12_5 Qplus_im_12_5

def Qplus_re_12_6 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 4 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_12_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_6 : Ki := ofLadj Qplus_re_12_6 Qplus_im_12_6

def Qplus_re_12_7 : Polynomial ℚ := C ((-1 / 4 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 4 : ℚ)) * X ^ 9
def Qplus_im_12_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_7 : Ki := ofLadj Qplus_re_12_7 Qplus_im_12_7

def Qplus_re_12_8 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_12_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_8 : Ki := ofLadj Qplus_re_12_8 Qplus_im_12_8

def Qplus_re_12_9 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((3 / 4 : ℚ)) * X ^ 7 + C ((1 / 4 : ℚ)) * X ^ 8 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_12_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_9 : Ki := ofLadj Qplus_re_12_9 Qplus_im_12_9

def Qplus_re_12_10 : Polynomial ℚ := C (1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_12_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_10 : Ki := ofLadj Qplus_re_12_10 Qplus_im_12_10

def Qplus_re_12_11 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((1 / 4 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8
def Qplus_im_12_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_11 : Ki := ofLadj Qplus_re_12_11 Qplus_im_12_11

def Qplus_re_12_12 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 4 + C ((-1 / 4 : ℚ)) * X ^ 5 + C ((-1 / 4 : ℚ)) * X ^ 6 + C ((-1 / 4 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_12_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_12 : Ki := ofLadj Qplus_re_12_12 Qplus_im_12_12

def Qplus_re_12_13 : Polynomial ℚ := C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 4 + C ((-1 / 4 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_12_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_13 : Ki := ofLadj Qplus_re_12_13 Qplus_im_12_13

def Qplus_re_12_14 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_12_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_14 : Ki := ofLadj Qplus_re_12_14 Qplus_im_12_14

def Qplus_re_12_15 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_12_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_15 : Ki := ofLadj Qplus_re_12_15 Qplus_im_12_15

def Qplus_re_12_16 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((-1 / 4 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 5 + C ((-1 / 4 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 4 : ℚ)) * X ^ 9
def Qplus_im_12_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_16 : Ki := ofLadj Qplus_re_12_16 Qplus_im_12_16

def Qplus_re_12_17 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C (-1) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_12_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_17 : Ki := ofLadj Qplus_re_12_17 Qplus_im_12_17

def Qplus_re_12_18 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 3 + C ((1 / 4 : ℚ)) * X ^ 5 + C ((1 / 4 : ℚ)) * X ^ 6 + C ((1 / 4 : ℚ)) * X ^ 8
def Qplus_im_12_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_18 : Ki := ofLadj Qplus_re_12_18 Qplus_im_12_18

def Qplus_re_12_19 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 5 + C (-1) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_12_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_19 : Ki := ofLadj Qplus_re_12_19 Qplus_im_12_19

def Qplus_re_12_20 : Polynomial ℚ := C (1)
def Qplus_im_12_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_12_20 : Ki := ofLadj Qplus_re_12_20 Qplus_im_12_20

def Qplus_re_13_0 : Polynomial ℚ := C ((-1 / 4 : ℚ)) * X ^ 2 + C ((-1 / 4 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 4 + C ((-1 / 4 : ℚ)) * X ^ 5 + C ((-1 / 4 : ℚ)) * X ^ 6 + C ((-1 / 4 : ℚ)) * X ^ 7 + C ((-1 / 4 : ℚ)) * X ^ 8 + C ((-1 / 4 : ℚ)) * X ^ 9
def Qplus_im_13_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_0 : Ki := ofLadj Qplus_re_13_0 Qplus_im_13_0

def Qplus_re_13_1 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_13_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_1 : Ki := ofLadj Qplus_re_13_1 Qplus_im_13_1

def Qplus_re_13_2 : Polynomial ℚ := C ((1 / 4 : ℚ)) * X ^ 3 + C ((1 / 4 : ℚ)) * X ^ 8
def Qplus_im_13_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_2 : Ki := ofLadj Qplus_re_13_2 Qplus_im_13_2

def Qplus_re_13_3 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 7
def Qplus_im_13_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_3 : Ki := ofLadj Qplus_re_13_3 Qplus_im_13_3

def Qplus_re_13_4 : Polynomial ℚ := C ((1 / 4 : ℚ)) * X ^ 5 + C ((1 / 4 : ℚ)) * X ^ 6
def Qplus_im_13_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_4 : Ki := ofLadj Qplus_re_13_4 Qplus_im_13_4

def Qplus_re_13_5 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_13_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_5 : Ki := ofLadj Qplus_re_13_5 Qplus_im_13_5

def Qplus_re_13_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_13_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_6 : Ki := ofLadj Qplus_re_13_6 Qplus_im_13_6

def Qplus_re_13_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_13_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_7 : Ki := ofLadj Qplus_re_13_7 Qplus_im_13_7

def Qplus_re_13_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_13_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_8 : Ki := ofLadj Qplus_re_13_8 Qplus_im_13_8

def Qplus_re_13_9 : Polynomial ℚ := C ((1 / 4 : ℚ))
def Qplus_im_13_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_9 : Ki := ofLadj Qplus_re_13_9 Qplus_im_13_9

def Qplus_re_13_10 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_13_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_10 : Ki := ofLadj Qplus_re_13_10 Qplus_im_13_10

def Qplus_re_13_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_13_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_11 : Ki := ofLadj Qplus_re_13_11 Qplus_im_13_11

def Qplus_re_13_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_13_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_12 : Ki := ofLadj Qplus_re_13_12 Qplus_im_13_12

def Qplus_re_13_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_13_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_13 : Ki := ofLadj Qplus_re_13_13 Qplus_im_13_13

def Qplus_re_13_14 : Polynomial ℚ := C (-1) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_13_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_14 : Ki := ofLadj Qplus_re_13_14 Qplus_im_13_14

def Qplus_re_13_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_13_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_15 : Ki := ofLadj Qplus_re_13_15 Qplus_im_13_15

def Qplus_re_13_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_13_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_16 : Ki := ofLadj Qplus_re_13_16 Qplus_im_13_16

def Qplus_re_13_17 : Polynomial ℚ := C (1) + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7
def Qplus_im_13_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_17 : Ki := ofLadj Qplus_re_13_17 Qplus_im_13_17

def Qplus_re_13_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_im_13_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_18 : Ki := ofLadj Qplus_re_13_18 Qplus_im_13_18

def Qplus_re_13_19 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_13_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_19 : Ki := ofLadj Qplus_re_13_19 Qplus_im_13_19

def Qplus_re_13_20 : Polynomial ℚ := C (-1)
def Qplus_im_13_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_13_20 : Ki := ofLadj Qplus_re_13_20 Qplus_im_13_20

def Qplus_re_14_0 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 4 : ℚ)) * X ^ 7 + C ((1 / 4 : ℚ)) * X ^ 8 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_14_0 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_0 : Ki := ofLadj Qplus_re_14_0 Qplus_im_14_0

def Qplus_re_14_1 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 4 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((1 / 4 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8
def Qplus_im_14_1 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_1 : Ki := ofLadj Qplus_re_14_1 Qplus_im_14_1

def Qplus_re_14_2 : Polynomial ℚ := C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 4 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 5 + C ((1 / 4 : ℚ)) * X ^ 6 + C ((1 / 4 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8
def Qplus_im_14_2 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_2 : Ki := ofLadj Qplus_re_14_2 Qplus_im_14_2

def Qplus_re_14_3 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 8
def Qplus_im_14_3 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_3 : Ki := ofLadj Qplus_re_14_3 Qplus_im_14_3

def Qplus_re_14_4 : Polynomial ℚ := C ((-1 / 4 : ℚ)) + C ((-1 / 4 : ℚ)) * X ^ 2 + C ((-3 / 4 : ℚ)) * X ^ 3 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((-3 / 4 : ℚ)) * X ^ 6 + C ((-3 / 4 : ℚ)) * X ^ 8 + C ((-1 / 4 : ℚ)) * X ^ 9
def Qplus_im_14_4 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_4 : Ki := ofLadj Qplus_re_14_4 Qplus_im_14_4

def Qplus_re_14_5 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C (1) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C (1) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_14_5 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_5 : Ki := ofLadj Qplus_re_14_5 Qplus_im_14_5

def Qplus_re_14_6 : Polynomial ℚ := C ((-1 / 4 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 5 + C ((1 / 4 : ℚ)) * X ^ 6 + C ((-1 / 4 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 4 : ℚ)) * X ^ 9
def Qplus_im_14_6 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_6 : Ki := ofLadj Qplus_re_14_6 Qplus_im_14_6

def Qplus_re_14_7 : Polynomial ℚ := C ((-1 / 4 : ℚ)) * X ^ 3 + C ((-1 / 4 : ℚ)) * X ^ 4 + C ((-1 / 4 : ℚ)) * X ^ 7 + C ((-1 / 4 : ℚ)) * X ^ 8
def Qplus_im_14_7 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_7 : Ki := ofLadj Qplus_re_14_7 Qplus_im_14_7

def Qplus_re_14_8 : Polynomial ℚ := C ((1 / 4 : ℚ)) * X ^ 3 + C ((1 / 4 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 7 + C ((1 / 4 : ℚ)) * X ^ 8
def Qplus_im_14_8 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_8 : Ki := ofLadj Qplus_re_14_8 Qplus_im_14_8

def Qplus_re_14_9 : Polynomial ℚ := C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 5 + C ((1 / 4 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((1 / 2 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_14_9 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_9 : Ki := ofLadj Qplus_re_14_9 Qplus_im_14_9

def Qplus_re_14_10 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_14_10 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_10 : Ki := ofLadj Qplus_re_14_10 Qplus_im_14_10

def Qplus_re_14_11 : Polynomial ℚ := C (1) + C (1) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 3 + C ((3 / 4 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((3 / 4 : ℚ)) * X ^ 7 + C ((1 / 4 : ℚ)) * X ^ 8 + C (1) * X ^ 9
def Qplus_im_14_11 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_11 : Ki := ofLadj Qplus_re_14_11 Qplus_im_14_11

def Qplus_re_14_12 : Polynomial ℚ := C ((-5 / 4 : ℚ)) + C ((-3 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C ((-3 / 4 : ℚ)) * X ^ 5 + C ((-3 / 4 : ℚ)) * X ^ 6 + C (-1) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-3 / 2 : ℚ)) * X ^ 9
def Qplus_im_14_12 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_12 : Ki := ofLadj Qplus_re_14_12 Qplus_im_14_12

def Qplus_re_14_13 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 4 : ℚ)) * X ^ 2 + C ((-1 / 4 : ℚ)) * X ^ 3 + C ((-1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 4 : ℚ)) * X ^ 5 + C ((-1 / 4 : ℚ)) * X ^ 6 + C ((-1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 4 : ℚ)) * X ^ 8 + C ((-1 / 4 : ℚ)) * X ^ 9
def Qplus_im_14_13 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_13 : Ki := ofLadj Qplus_re_14_13 Qplus_im_14_13

def Qplus_re_14_14 : Polynomial ℚ := C ((3 / 2 : ℚ)) + C (1) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C (1) * X ^ 9
def Qplus_im_14_14 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_14 : Ki := ofLadj Qplus_re_14_14 Qplus_im_14_14

def Qplus_re_14_15 : Polynomial ℚ := C ((1 / 2 : ℚ)) + C ((1 / 2 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 3 + C ((1 / 4 : ℚ)) * X ^ 4 + C ((1 / 4 : ℚ)) * X ^ 7 + C ((1 / 4 : ℚ)) * X ^ 8 + C ((1 / 2 : ℚ)) * X ^ 9
def Qplus_im_14_15 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_15 : Ki := ofLadj Qplus_re_14_15 Qplus_im_14_15

def Qplus_re_14_16 : Polynomial ℚ := C ((1 / 4 : ℚ)) + C ((1 / 4 : ℚ)) * X ^ 2 + C ((1 / 4 : ℚ)) * X ^ 3 + C ((1 / 2 : ℚ)) * X ^ 5 + C ((1 / 2 : ℚ)) * X ^ 6 + C ((1 / 4 : ℚ)) * X ^ 8 + C ((1 / 4 : ℚ)) * X ^ 9
def Qplus_im_14_16 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_16 : Ki := ofLadj Qplus_re_14_16 Qplus_im_14_16

def Qplus_re_14_17 : Polynomial ℚ := C ((-3 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((-1 / 2 : ℚ)) * X ^ 3 + C (-1) * X ^ 4 + C (-1) * X ^ 5 + C (-1) * X ^ 6 + C (-1) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 8 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_14_17 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_17 : Ki := ofLadj Qplus_re_14_17 Qplus_im_14_17

def Qplus_re_14_18 : Polynomial ℚ := C ((-1 / 4 : ℚ)) * X ^ 2 + C ((-1 / 4 : ℚ)) * X ^ 9
def Qplus_im_14_18 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_18 : Ki := ofLadj Qplus_re_14_18 Qplus_im_14_18

def Qplus_re_14_19 : Polynomial ℚ := C ((-1 / 2 : ℚ)) + C ((-1 / 2 : ℚ)) * X ^ 2 + C ((1 / 2 : ℚ)) * X ^ 4 + C ((-1 / 2 : ℚ)) * X ^ 5 + C ((-1 / 2 : ℚ)) * X ^ 6 + C ((1 / 2 : ℚ)) * X ^ 7 + C ((-1 / 2 : ℚ)) * X ^ 9
def Qplus_im_14_19 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_19 : Ki := ofLadj Qplus_re_14_19 Qplus_im_14_19

def Qplus_re_14_20 : Polynomial ℚ := C (1)
def Qplus_im_14_20 : Polynomial ℚ := (0 : Polynomial ℚ)
def Qplus_entry_14_20 : Ki := ofLadj Qplus_re_14_20 Qplus_im_14_20

def Qplus : Matrix (Fin 15) (Fin 21) Ki :=
  fun i j =>
    match i.val, j.val with
    | 0, 0 => Qplus_entry_0_0
    | 0, 1 => Qplus_entry_0_1
    | 0, 2 => Qplus_entry_0_2
    | 0, 3 => Qplus_entry_0_3
    | 0, 4 => Qplus_entry_0_4
    | 0, 5 => Qplus_entry_0_5
    | 0, 6 => Qplus_entry_0_6
    | 0, 7 => Qplus_entry_0_7
    | 0, 8 => Qplus_entry_0_8
    | 0, 9 => Qplus_entry_0_9
    | 0, 10 => Qplus_entry_0_10
    | 0, 11 => Qplus_entry_0_11
    | 0, 12 => Qplus_entry_0_12
    | 0, 13 => Qplus_entry_0_13
    | 0, 14 => Qplus_entry_0_14
    | 0, 15 => Qplus_entry_0_15
    | 0, 16 => Qplus_entry_0_16
    | 0, 17 => Qplus_entry_0_17
    | 0, 18 => Qplus_entry_0_18
    | 0, 19 => Qplus_entry_0_19
    | 0, 20 => Qplus_entry_0_20
    | 1, 0 => Qplus_entry_1_0
    | 1, 1 => Qplus_entry_1_1
    | 1, 2 => Qplus_entry_1_2
    | 1, 3 => Qplus_entry_1_3
    | 1, 4 => Qplus_entry_1_4
    | 1, 5 => Qplus_entry_1_5
    | 1, 6 => Qplus_entry_1_6
    | 1, 7 => Qplus_entry_1_7
    | 1, 8 => Qplus_entry_1_8
    | 1, 9 => Qplus_entry_1_9
    | 1, 10 => Qplus_entry_1_10
    | 1, 11 => Qplus_entry_1_11
    | 1, 12 => Qplus_entry_1_12
    | 1, 13 => Qplus_entry_1_13
    | 1, 14 => Qplus_entry_1_14
    | 1, 15 => Qplus_entry_1_15
    | 1, 16 => Qplus_entry_1_16
    | 1, 17 => Qplus_entry_1_17
    | 1, 18 => Qplus_entry_1_18
    | 1, 19 => Qplus_entry_1_19
    | 1, 20 => Qplus_entry_1_20
    | 2, 0 => Qplus_entry_2_0
    | 2, 1 => Qplus_entry_2_1
    | 2, 2 => Qplus_entry_2_2
    | 2, 3 => Qplus_entry_2_3
    | 2, 4 => Qplus_entry_2_4
    | 2, 5 => Qplus_entry_2_5
    | 2, 6 => Qplus_entry_2_6
    | 2, 7 => Qplus_entry_2_7
    | 2, 8 => Qplus_entry_2_8
    | 2, 9 => Qplus_entry_2_9
    | 2, 10 => Qplus_entry_2_10
    | 2, 11 => Qplus_entry_2_11
    | 2, 12 => Qplus_entry_2_12
    | 2, 13 => Qplus_entry_2_13
    | 2, 14 => Qplus_entry_2_14
    | 2, 15 => Qplus_entry_2_15
    | 2, 16 => Qplus_entry_2_16
    | 2, 17 => Qplus_entry_2_17
    | 2, 18 => Qplus_entry_2_18
    | 2, 19 => Qplus_entry_2_19
    | 2, 20 => Qplus_entry_2_20
    | 3, 0 => Qplus_entry_3_0
    | 3, 1 => Qplus_entry_3_1
    | 3, 2 => Qplus_entry_3_2
    | 3, 3 => Qplus_entry_3_3
    | 3, 4 => Qplus_entry_3_4
    | 3, 5 => Qplus_entry_3_5
    | 3, 6 => Qplus_entry_3_6
    | 3, 7 => Qplus_entry_3_7
    | 3, 8 => Qplus_entry_3_8
    | 3, 9 => Qplus_entry_3_9
    | 3, 10 => Qplus_entry_3_10
    | 3, 11 => Qplus_entry_3_11
    | 3, 12 => Qplus_entry_3_12
    | 3, 13 => Qplus_entry_3_13
    | 3, 14 => Qplus_entry_3_14
    | 3, 15 => Qplus_entry_3_15
    | 3, 16 => Qplus_entry_3_16
    | 3, 17 => Qplus_entry_3_17
    | 3, 18 => Qplus_entry_3_18
    | 3, 19 => Qplus_entry_3_19
    | 3, 20 => Qplus_entry_3_20
    | 4, 0 => Qplus_entry_4_0
    | 4, 1 => Qplus_entry_4_1
    | 4, 2 => Qplus_entry_4_2
    | 4, 3 => Qplus_entry_4_3
    | 4, 4 => Qplus_entry_4_4
    | 4, 5 => Qplus_entry_4_5
    | 4, 6 => Qplus_entry_4_6
    | 4, 7 => Qplus_entry_4_7
    | 4, 8 => Qplus_entry_4_8
    | 4, 9 => Qplus_entry_4_9
    | 4, 10 => Qplus_entry_4_10
    | 4, 11 => Qplus_entry_4_11
    | 4, 12 => Qplus_entry_4_12
    | 4, 13 => Qplus_entry_4_13
    | 4, 14 => Qplus_entry_4_14
    | 4, 15 => Qplus_entry_4_15
    | 4, 16 => Qplus_entry_4_16
    | 4, 17 => Qplus_entry_4_17
    | 4, 18 => Qplus_entry_4_18
    | 4, 19 => Qplus_entry_4_19
    | 4, 20 => Qplus_entry_4_20
    | 5, 0 => Qplus_entry_5_0
    | 5, 1 => Qplus_entry_5_1
    | 5, 2 => Qplus_entry_5_2
    | 5, 3 => Qplus_entry_5_3
    | 5, 4 => Qplus_entry_5_4
    | 5, 5 => Qplus_entry_5_5
    | 5, 6 => Qplus_entry_5_6
    | 5, 7 => Qplus_entry_5_7
    | 5, 8 => Qplus_entry_5_8
    | 5, 9 => Qplus_entry_5_9
    | 5, 10 => Qplus_entry_5_10
    | 5, 11 => Qplus_entry_5_11
    | 5, 12 => Qplus_entry_5_12
    | 5, 13 => Qplus_entry_5_13
    | 5, 14 => Qplus_entry_5_14
    | 5, 15 => Qplus_entry_5_15
    | 5, 16 => Qplus_entry_5_16
    | 5, 17 => Qplus_entry_5_17
    | 5, 18 => Qplus_entry_5_18
    | 5, 19 => Qplus_entry_5_19
    | 5, 20 => Qplus_entry_5_20
    | 6, 0 => Qplus_entry_6_0
    | 6, 1 => Qplus_entry_6_1
    | 6, 2 => Qplus_entry_6_2
    | 6, 3 => Qplus_entry_6_3
    | 6, 4 => Qplus_entry_6_4
    | 6, 5 => Qplus_entry_6_5
    | 6, 6 => Qplus_entry_6_6
    | 6, 7 => Qplus_entry_6_7
    | 6, 8 => Qplus_entry_6_8
    | 6, 9 => Qplus_entry_6_9
    | 6, 10 => Qplus_entry_6_10
    | 6, 11 => Qplus_entry_6_11
    | 6, 12 => Qplus_entry_6_12
    | 6, 13 => Qplus_entry_6_13
    | 6, 14 => Qplus_entry_6_14
    | 6, 15 => Qplus_entry_6_15
    | 6, 16 => Qplus_entry_6_16
    | 6, 17 => Qplus_entry_6_17
    | 6, 18 => Qplus_entry_6_18
    | 6, 19 => Qplus_entry_6_19
    | 6, 20 => Qplus_entry_6_20
    | 7, 0 => Qplus_entry_7_0
    | 7, 1 => Qplus_entry_7_1
    | 7, 2 => Qplus_entry_7_2
    | 7, 3 => Qplus_entry_7_3
    | 7, 4 => Qplus_entry_7_4
    | 7, 5 => Qplus_entry_7_5
    | 7, 6 => Qplus_entry_7_6
    | 7, 7 => Qplus_entry_7_7
    | 7, 8 => Qplus_entry_7_8
    | 7, 9 => Qplus_entry_7_9
    | 7, 10 => Qplus_entry_7_10
    | 7, 11 => Qplus_entry_7_11
    | 7, 12 => Qplus_entry_7_12
    | 7, 13 => Qplus_entry_7_13
    | 7, 14 => Qplus_entry_7_14
    | 7, 15 => Qplus_entry_7_15
    | 7, 16 => Qplus_entry_7_16
    | 7, 17 => Qplus_entry_7_17
    | 7, 18 => Qplus_entry_7_18
    | 7, 19 => Qplus_entry_7_19
    | 7, 20 => Qplus_entry_7_20
    | 8, 0 => Qplus_entry_8_0
    | 8, 1 => Qplus_entry_8_1
    | 8, 2 => Qplus_entry_8_2
    | 8, 3 => Qplus_entry_8_3
    | 8, 4 => Qplus_entry_8_4
    | 8, 5 => Qplus_entry_8_5
    | 8, 6 => Qplus_entry_8_6
    | 8, 7 => Qplus_entry_8_7
    | 8, 8 => Qplus_entry_8_8
    | 8, 9 => Qplus_entry_8_9
    | 8, 10 => Qplus_entry_8_10
    | 8, 11 => Qplus_entry_8_11
    | 8, 12 => Qplus_entry_8_12
    | 8, 13 => Qplus_entry_8_13
    | 8, 14 => Qplus_entry_8_14
    | 8, 15 => Qplus_entry_8_15
    | 8, 16 => Qplus_entry_8_16
    | 8, 17 => Qplus_entry_8_17
    | 8, 18 => Qplus_entry_8_18
    | 8, 19 => Qplus_entry_8_19
    | 8, 20 => Qplus_entry_8_20
    | 9, 0 => Qplus_entry_9_0
    | 9, 1 => Qplus_entry_9_1
    | 9, 2 => Qplus_entry_9_2
    | 9, 3 => Qplus_entry_9_3
    | 9, 4 => Qplus_entry_9_4
    | 9, 5 => Qplus_entry_9_5
    | 9, 6 => Qplus_entry_9_6
    | 9, 7 => Qplus_entry_9_7
    | 9, 8 => Qplus_entry_9_8
    | 9, 9 => Qplus_entry_9_9
    | 9, 10 => Qplus_entry_9_10
    | 9, 11 => Qplus_entry_9_11
    | 9, 12 => Qplus_entry_9_12
    | 9, 13 => Qplus_entry_9_13
    | 9, 14 => Qplus_entry_9_14
    | 9, 15 => Qplus_entry_9_15
    | 9, 16 => Qplus_entry_9_16
    | 9, 17 => Qplus_entry_9_17
    | 9, 18 => Qplus_entry_9_18
    | 9, 19 => Qplus_entry_9_19
    | 9, 20 => Qplus_entry_9_20
    | 10, 0 => Qplus_entry_10_0
    | 10, 1 => Qplus_entry_10_1
    | 10, 2 => Qplus_entry_10_2
    | 10, 3 => Qplus_entry_10_3
    | 10, 4 => Qplus_entry_10_4
    | 10, 5 => Qplus_entry_10_5
    | 10, 6 => Qplus_entry_10_6
    | 10, 7 => Qplus_entry_10_7
    | 10, 8 => Qplus_entry_10_8
    | 10, 9 => Qplus_entry_10_9
    | 10, 10 => Qplus_entry_10_10
    | 10, 11 => Qplus_entry_10_11
    | 10, 12 => Qplus_entry_10_12
    | 10, 13 => Qplus_entry_10_13
    | 10, 14 => Qplus_entry_10_14
    | 10, 15 => Qplus_entry_10_15
    | 10, 16 => Qplus_entry_10_16
    | 10, 17 => Qplus_entry_10_17
    | 10, 18 => Qplus_entry_10_18
    | 10, 19 => Qplus_entry_10_19
    | 10, 20 => Qplus_entry_10_20
    | 11, 0 => Qplus_entry_11_0
    | 11, 1 => Qplus_entry_11_1
    | 11, 2 => Qplus_entry_11_2
    | 11, 3 => Qplus_entry_11_3
    | 11, 4 => Qplus_entry_11_4
    | 11, 5 => Qplus_entry_11_5
    | 11, 6 => Qplus_entry_11_6
    | 11, 7 => Qplus_entry_11_7
    | 11, 8 => Qplus_entry_11_8
    | 11, 9 => Qplus_entry_11_9
    | 11, 10 => Qplus_entry_11_10
    | 11, 11 => Qplus_entry_11_11
    | 11, 12 => Qplus_entry_11_12
    | 11, 13 => Qplus_entry_11_13
    | 11, 14 => Qplus_entry_11_14
    | 11, 15 => Qplus_entry_11_15
    | 11, 16 => Qplus_entry_11_16
    | 11, 17 => Qplus_entry_11_17
    | 11, 18 => Qplus_entry_11_18
    | 11, 19 => Qplus_entry_11_19
    | 11, 20 => Qplus_entry_11_20
    | 12, 0 => Qplus_entry_12_0
    | 12, 1 => Qplus_entry_12_1
    | 12, 2 => Qplus_entry_12_2
    | 12, 3 => Qplus_entry_12_3
    | 12, 4 => Qplus_entry_12_4
    | 12, 5 => Qplus_entry_12_5
    | 12, 6 => Qplus_entry_12_6
    | 12, 7 => Qplus_entry_12_7
    | 12, 8 => Qplus_entry_12_8
    | 12, 9 => Qplus_entry_12_9
    | 12, 10 => Qplus_entry_12_10
    | 12, 11 => Qplus_entry_12_11
    | 12, 12 => Qplus_entry_12_12
    | 12, 13 => Qplus_entry_12_13
    | 12, 14 => Qplus_entry_12_14
    | 12, 15 => Qplus_entry_12_15
    | 12, 16 => Qplus_entry_12_16
    | 12, 17 => Qplus_entry_12_17
    | 12, 18 => Qplus_entry_12_18
    | 12, 19 => Qplus_entry_12_19
    | 12, 20 => Qplus_entry_12_20
    | 13, 0 => Qplus_entry_13_0
    | 13, 1 => Qplus_entry_13_1
    | 13, 2 => Qplus_entry_13_2
    | 13, 3 => Qplus_entry_13_3
    | 13, 4 => Qplus_entry_13_4
    | 13, 5 => Qplus_entry_13_5
    | 13, 6 => Qplus_entry_13_6
    | 13, 7 => Qplus_entry_13_7
    | 13, 8 => Qplus_entry_13_8
    | 13, 9 => Qplus_entry_13_9
    | 13, 10 => Qplus_entry_13_10
    | 13, 11 => Qplus_entry_13_11
    | 13, 12 => Qplus_entry_13_12
    | 13, 13 => Qplus_entry_13_13
    | 13, 14 => Qplus_entry_13_14
    | 13, 15 => Qplus_entry_13_15
    | 13, 16 => Qplus_entry_13_16
    | 13, 17 => Qplus_entry_13_17
    | 13, 18 => Qplus_entry_13_18
    | 13, 19 => Qplus_entry_13_19
    | 13, 20 => Qplus_entry_13_20
    | 14, 0 => Qplus_entry_14_0
    | 14, 1 => Qplus_entry_14_1
    | 14, 2 => Qplus_entry_14_2
    | 14, 3 => Qplus_entry_14_3
    | 14, 4 => Qplus_entry_14_4
    | 14, 5 => Qplus_entry_14_5
    | 14, 6 => Qplus_entry_14_6
    | 14, 7 => Qplus_entry_14_7
    | 14, 8 => Qplus_entry_14_8
    | 14, 9 => Qplus_entry_14_9
    | 14, 10 => Qplus_entry_14_10
    | 14, 11 => Qplus_entry_14_11
    | 14, 12 => Qplus_entry_14_12
    | 14, 13 => Qplus_entry_14_13
    | 14, 14 => Qplus_entry_14_14
    | 14, 15 => Qplus_entry_14_15
    | 14, 16 => Qplus_entry_14_16
    | 14, 17 => Qplus_entry_14_17
    | 14, 18 => Qplus_entry_14_18
    | 14, 19 => Qplus_entry_14_19
    | 14, 20 => Qplus_entry_14_20
    | _, _ => Qplus_entry_0_0

end V14Formalization.D12SigmaPlusSegreCore
