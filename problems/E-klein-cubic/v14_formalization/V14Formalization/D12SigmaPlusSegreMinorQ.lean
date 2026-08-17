/-
Plus Segre span matrix minorQ.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore

@[expose] public def minorQ_re_0_0 : Polynomial ℚ := C (-6) + C (-6) * X ^ 2 + C (2) * X ^ 3 + C (-2) * X ^ 4 + C (-2) * X ^ 5 + C (-2) * X ^ 6 + C (-2) * X ^ 7 + C (2) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_0_0 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_0 : Ki := ofLadj minorQ_re_0_0 minorQ_im_0_0

@[expose] public def minorQ_re_0_1 : Polynomial ℚ := C (6) + C (-2) * X ^ 2 + C (-6) * X ^ 3 + C (-4) * X ^ 4 + C (-2) * X ^ 5 + C (-2) * X ^ 6 + C (-4) * X ^ 7 + C (-6) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_0_1 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_1 : Ki := ofLadj minorQ_re_0_1 minorQ_im_0_1

@[expose] public def minorQ_re_0_2 : Polynomial ℚ := C (-14) + C (8) * X ^ 2 + C (20) * X ^ 3 + C (30) * X ^ 4 + C (48) * X ^ 5 + C (48) * X ^ 6 + C (30) * X ^ 7 + C (20) * X ^ 8 + C (8) * X ^ 9
@[expose] public def minorQ_im_0_2 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_2 : Ki := ofLadj minorQ_re_0_2 minorQ_im_0_2

@[expose] public def minorQ_re_0_3 : Polynomial ℚ := C (-4) + C (-2) * X ^ 3 + C (-8) * X ^ 4 + C (-10) * X ^ 5 + C (-10) * X ^ 6 + C (-8) * X ^ 7 + C (-2) * X ^ 8
@[expose] public def minorQ_im_0_3 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_3 : Ki := ofLadj minorQ_re_0_3 minorQ_im_0_3

@[expose] public def minorQ_re_0_4 : Polynomial ℚ := C (-14) + C (4) * X ^ 2 + C (22) * X ^ 3 + C (26) * X ^ 4 + C (32) * X ^ 5 + C (32) * X ^ 6 + C (26) * X ^ 7 + C (22) * X ^ 8 + C (4) * X ^ 9
@[expose] public def minorQ_im_0_4 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_4 : Ki := ofLadj minorQ_re_0_4 minorQ_im_0_4

@[expose] public def minorQ_re_0_5 : Polynomial ℚ := C (-8) * X ^ 2 + C (-16) * X ^ 3 + C (-36) * X ^ 4 + C (-28) * X ^ 5 + C (-28) * X ^ 6 + C (-36) * X ^ 7 + C (-16) * X ^ 8 + C (-8) * X ^ 9
@[expose] public def minorQ_im_0_5 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_5 : Ki := ofLadj minorQ_re_0_5 minorQ_im_0_5

public def minorQ_re_0_6 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_im_0_6 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_6 : Ki := ofLadj minorQ_re_0_6 minorQ_im_0_6

@[expose] public def minorQ_re_0_7 : Polynomial ℚ := C (8) + C (-2) * X ^ 2 + C (-2) * X ^ 3 + C (2) * X ^ 4 + C (-2) * X ^ 5 + C (-2) * X ^ 6 + C (2) * X ^ 7 + C (-2) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_0_7 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_7 : Ki := ofLadj minorQ_re_0_7 minorQ_im_0_7

@[expose] public def minorQ_re_0_8 : Polynomial ℚ := C (2) + C (-2) * X ^ 2 + C (-8) * X ^ 3 + C (-12) * X ^ 4 + C (-12) * X ^ 5 + C (-12) * X ^ 6 + C (-12) * X ^ 7 + C (-8) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_0_8 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_8 : Ki := ofLadj minorQ_re_0_8 minorQ_im_0_8

@[expose] public def minorQ_re_0_9 : Polynomial ℚ := C (2) * X ^ 2 + C (-8) * X ^ 3 + C (-10) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (-10) * X ^ 7 + C (-8) * X ^ 8 + C (2) * X ^ 9
@[expose] public def minorQ_im_0_9 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_9 : Ki := ofLadj minorQ_re_0_9 minorQ_im_0_9

@[expose] public def minorQ_re_0_10 : Polynomial ℚ := C (-8) * X ^ 2 + C (4) * X ^ 4 + C (4) * X ^ 5 + C (4) * X ^ 6 + C (4) * X ^ 7 + C (-8) * X ^ 9
@[expose] public def minorQ_im_0_10 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_10 : Ki := ofLadj minorQ_re_0_10 minorQ_im_0_10

@[expose] public def minorQ_re_0_11 : Polynomial ℚ := C (14) + C (12) * X ^ 2 + C (10) * X ^ 4 + C (4) * X ^ 5 + C (4) * X ^ 6 + C (10) * X ^ 7 + C (12) * X ^ 9
@[expose] public def minorQ_im_0_11 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_11 : Ki := ofLadj minorQ_re_0_11 minorQ_im_0_11

@[expose] public def minorQ_re_0_12 : Polynomial ℚ := C (-6) + C (-6) * X ^ 3 + C (-14) * X ^ 4 + C (-10) * X ^ 5 + C (-10) * X ^ 6 + C (-14) * X ^ 7 + C (-6) * X ^ 8
@[expose] public def minorQ_im_0_12 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_12 : Ki := ofLadj minorQ_re_0_12 minorQ_im_0_12

@[expose] public def minorQ_re_0_13 : Polynomial ℚ := C (-8) + C (-24) * X ^ 2 + C (-18) * X ^ 3 + C (-28) * X ^ 4 + C (-36) * X ^ 5 + C (-36) * X ^ 6 + C (-28) * X ^ 7 + C (-18) * X ^ 8 + C (-24) * X ^ 9
@[expose] public def minorQ_im_0_13 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_13 : Ki := ofLadj minorQ_re_0_13 minorQ_im_0_13

@[expose] public def minorQ_re_0_14 : Polynomial ℚ := C (-16) + C (-40) * X ^ 2 + C (-24) * X ^ 3 + C (-52) * X ^ 4 + C (-52) * X ^ 5 + C (-52) * X ^ 6 + C (-52) * X ^ 7 + C (-24) * X ^ 8 + C (-40) * X ^ 9
@[expose] public def minorQ_im_0_14 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_14 : Ki := ofLadj minorQ_re_0_14 minorQ_im_0_14

public def minorQ_re_0_15 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_im_0_15 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_15 : Ki := ofLadj minorQ_re_0_15 minorQ_im_0_15

@[expose] public def minorQ_re_0_16 : Polynomial ℚ := C (2) + C (-4) * X ^ 2 + C (-2) * X ^ 4 + C (-6) * X ^ 5 + C (-6) * X ^ 6 + C (-2) * X ^ 7 + C (-4) * X ^ 9
@[expose] public def minorQ_im_0_16 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_16 : Ki := ofLadj minorQ_re_0_16 minorQ_im_0_16

@[expose] public def minorQ_re_0_17 : Polynomial ℚ := C (8) * X ^ 2 + C (-4) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (-4) * X ^ 7 + C (8) * X ^ 9
@[expose] public def minorQ_im_0_17 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_17 : Ki := ofLadj minorQ_re_0_17 minorQ_im_0_17

@[expose] public def minorQ_re_0_18 : Polynomial ℚ := C (-8) + C (-6) * X ^ 2 + C (-12) * X ^ 3 + C (-22) * X ^ 4 + C (-22) * X ^ 5 + C (-22) * X ^ 6 + C (-22) * X ^ 7 + C (-12) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_0_18 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_18 : Ki := ofLadj minorQ_re_0_18 minorQ_im_0_18

@[expose] public def minorQ_re_0_19 : Polynomial ℚ := C (32) + C (16) * X ^ 2 + C (-8) * X ^ 3 + C (-4) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (-4) * X ^ 7 + C (-8) * X ^ 8 + C (16) * X ^ 9
@[expose] public def minorQ_im_0_19 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_19 : Ki := ofLadj minorQ_re_0_19 minorQ_im_0_19

@[expose] public def minorQ_re_0_20 : Polynomial ℚ := C (-8) + C (-8) * X ^ 2 + C (16) * X ^ 3 + C (16) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (16) * X ^ 7 + C (16) * X ^ 8 + C (-8) * X ^ 9
@[expose] public def minorQ_im_0_20 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_0_20 : Ki := ofLadj minorQ_re_0_20 minorQ_im_0_20

@[expose] public def minorQ_re_1_0 : Polynomial ℚ := C (-2) + C (-2) * X ^ 2 + C (2) * X ^ 3 + C (10) * X ^ 4 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (10) * X ^ 7 + C (2) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_1_0 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_0 : Ki := ofLadj minorQ_re_1_0 minorQ_im_1_0

@[expose] public def minorQ_re_1_1 : Polynomial ℚ := C (-8) + C (-4) * X ^ 2 + C (-6) * X ^ 3 + C (-8) * X ^ 4 + C (-8) * X ^ 7 + C (-6) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def minorQ_im_1_1 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_1 : Ki := ofLadj minorQ_re_1_1 minorQ_im_1_1

@[expose] public def minorQ_re_1_2 : Polynomial ℚ := C (-14) + C (-8) * X ^ 2 + C (8) * X ^ 3 + C (8) * X ^ 4 + C (10) * X ^ 5 + C (10) * X ^ 6 + C (8) * X ^ 7 + C (8) * X ^ 8 + C (-8) * X ^ 9
@[expose] public def minorQ_im_1_2 : Polynomial ℚ := C (8) + C (16) * X + C (24) * X ^ 2 + C (32) * X ^ 3 + C (18) * X ^ 4 + C (4) * X ^ 5 + C (12) * X ^ 6 + C (-2) * X ^ 7 + C (-16) * X ^ 8 + C (-8) * X ^ 9
public def minorQ_entry_1_2 : Ki := ofLadj minorQ_re_1_2 minorQ_im_1_2

@[expose] public def minorQ_re_1_3 : Polynomial ℚ := C (4) + C (-4) * X ^ 2 + C (-6) * X ^ 4 + C (-14) * X ^ 5 + C (-14) * X ^ 6 + C (-6) * X ^ 7 + C (-4) * X ^ 9
@[expose] public def minorQ_im_1_3 : Polynomial ℚ := C (6) + C (12) * X + C (18) * X ^ 2 + C (24) * X ^ 3 + C (8) * X ^ 4 + C (14) * X ^ 5 + C (-2) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-6) * X ^ 9
public def minorQ_entry_1_3 : Ki := ofLadj minorQ_re_1_3 minorQ_im_1_3

@[expose] public def minorQ_re_1_4 : Polynomial ℚ := C (10) + C (4) * X ^ 2 + C (-14) * X ^ 3 + C (-24) * X ^ 4 + C (-26) * X ^ 5 + C (-26) * X ^ 6 + C (-24) * X ^ 7 + C (-14) * X ^ 8 + C (4) * X ^ 9
@[expose] public def minorQ_im_1_4 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_4 : Ki := ofLadj minorQ_re_1_4 minorQ_im_1_4

@[expose] public def minorQ_re_1_5 : Polynomial ℚ := C (-8) + C (-4) * X ^ 2 + C (-4) * X ^ 3 + C (8) * X ^ 4 + C (4) * X ^ 5 + C (4) * X ^ 6 + C (8) * X ^ 7 + C (-4) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def minorQ_im_1_5 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_5 : Ki := ofLadj minorQ_re_1_5 minorQ_im_1_5

public def minorQ_re_1_6 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_im_1_6 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_6 : Ki := ofLadj minorQ_re_1_6 minorQ_im_1_6

@[expose] public def minorQ_re_1_7 : Polynomial ℚ := C (-2) * X ^ 2 + C (-8) * X ^ 3 + C (-8) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (-8) * X ^ 7 + C (-8) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_1_7 : Polynomial ℚ := C (-4) + C (-8) * X + C (-12) * X ^ 2 + C (-16) * X ^ 3 + C (2) * X ^ 4 + C (-2) * X ^ 5 + C (-6) * X ^ 6 + C (-10) * X ^ 7 + C (8) * X ^ 8 + C (4) * X ^ 9
public def minorQ_entry_1_7 : Ki := ofLadj minorQ_re_1_7 minorQ_im_1_7

@[expose] public def minorQ_re_1_8 : Polynomial ℚ := C (-6) + C (-4) * X ^ 2 + C (-2) * X ^ 3 + C (-2) * X ^ 4 + C (-2) * X ^ 7 + C (-2) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def minorQ_im_1_8 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_8 : Ki := ofLadj minorQ_re_1_8 minorQ_im_1_8

@[expose] public def minorQ_re_1_9 : Polynomial ℚ := C (-2) + C (4) * X ^ 4 + C (8) * X ^ 5 + C (8) * X ^ 6 + C (4) * X ^ 7
@[expose] public def minorQ_im_1_9 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_9 : Ki := ofLadj minorQ_re_1_9 minorQ_im_1_9

@[expose] public def minorQ_re_1_10 : Polynomial ℚ := C (8) * X ^ 2 + C (-4) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (-4) * X ^ 7 + C (8) * X ^ 9
@[expose] public def minorQ_im_1_10 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_10 : Ki := ofLadj minorQ_re_1_10 minorQ_im_1_10

@[expose] public def minorQ_re_1_11 : Polynomial ℚ := C (28) + C (20) * X ^ 2 + C (-4) * X ^ 3 + C (12) * X ^ 4 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (12) * X ^ 7 + C (-4) * X ^ 8 + C (20) * X ^ 9
@[expose] public def minorQ_im_1_11 : Polynomial ℚ := C (-4) + C (-8) * X + C (10) * X ^ 2 + C (-16) * X ^ 3 + C (24) * X ^ 4 + C (-24) * X ^ 5 + C (16) * X ^ 6 + C (-32) * X ^ 7 + C (8) * X ^ 8 + C (-18) * X ^ 9
public def minorQ_entry_1_11 : Ki := ofLadj minorQ_re_1_11 minorQ_im_1_11

@[expose] public def minorQ_re_1_12 : Polynomial ℚ := C (-14) + C (-14) * X ^ 2 + C (8) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (8) * X ^ 8 + C (-14) * X ^ 9
@[expose] public def minorQ_im_1_12 : Polynomial ℚ := C (-8) + C (-16) * X + C (-24) * X ^ 2 + C (-10) * X ^ 3 + C (-40) * X ^ 4 + C (-4) * X ^ 5 + C (-12) * X ^ 6 + C (24) * X ^ 7 + C (-6) * X ^ 8 + C (8) * X ^ 9
public def minorQ_entry_1_12 : Ki := ofLadj minorQ_re_1_12 minorQ_im_1_12

@[expose] public def minorQ_re_1_13 : Polynomial ℚ := C (-16) + C (-22) * X ^ 2 + C (-14) * X ^ 3 + C (-36) * X ^ 4 + C (-30) * X ^ 5 + C (-30) * X ^ 6 + C (-36) * X ^ 7 + C (-14) * X ^ 8 + C (-22) * X ^ 9
@[expose] public def minorQ_im_1_13 : Polynomial ℚ := C (8) + C (16) * X + C (2) * X ^ 2 + C (10) * X ^ 3 + C (-4) * X ^ 4 + C (26) * X ^ 5 + C (-10) * X ^ 6 + C (20) * X ^ 7 + C (6) * X ^ 8 + C (14) * X ^ 9
public def minorQ_entry_1_13 : Ki := ofLadj minorQ_re_1_13 minorQ_im_1_13

@[expose] public def minorQ_re_1_14 : Polynomial ℚ := C (36) + C (40) * X ^ 2 + C (4) * X ^ 3 + C (28) * X ^ 4 + C (20) * X ^ 5 + C (20) * X ^ 6 + C (28) * X ^ 7 + C (4) * X ^ 8 + C (40) * X ^ 9
@[expose] public def minorQ_im_1_14 : Polynomial ℚ := C (-12) + C (-24) * X + C (-36) * X ^ 2 + C (-48) * X ^ 3 + C (-16) * X ^ 4 + C (-28) * X ^ 5 + C (4) * X ^ 6 + C (-8) * X ^ 7 + C (24) * X ^ 8 + C (12) * X ^ 9
public def minorQ_entry_1_14 : Ki := ofLadj minorQ_re_1_14 minorQ_im_1_14

public def minorQ_re_1_15 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_im_1_15 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_15 : Ki := ofLadj minorQ_re_1_15 minorQ_im_1_15

@[expose] public def minorQ_re_1_16 : Polynomial ℚ := C (8) + C (6) * X ^ 2 + C (2) * X ^ 3 + C (8) * X ^ 4 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (8) * X ^ 7 + C (2) * X ^ 8 + C (6) * X ^ 9
@[expose] public def minorQ_im_1_16 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_16 : Ki := ofLadj minorQ_re_1_16 minorQ_im_1_16

@[expose] public def minorQ_re_1_17 : Polynomial ℚ := C (-4) + C (-28) * X ^ 2 + C (-28) * X ^ 3 + C (-48) * X ^ 4 + C (-48) * X ^ 5 + C (-48) * X ^ 6 + C (-48) * X ^ 7 + C (-28) * X ^ 8 + C (-28) * X ^ 9
@[expose] public def minorQ_im_1_17 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_17 : Ki := ofLadj minorQ_re_1_17 minorQ_im_1_17

@[expose] public def minorQ_re_1_18 : Polynomial ℚ := C (-6) + C (-6) * X ^ 2 + C (-2) * X ^ 3 + C (-12) * X ^ 4 + C (-10) * X ^ 5 + C (-10) * X ^ 6 + C (-12) * X ^ 7 + C (-2) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_1_18 : Polynomial ℚ := C (6) + C (12) * X + C (18) * X ^ 2 + C (24) * X ^ 3 + C (8) * X ^ 4 + C (14) * X ^ 5 + C (-2) * X ^ 6 + C (4) * X ^ 7 + C (-12) * X ^ 8 + C (-6) * X ^ 9
public def minorQ_entry_1_18 : Ki := ofLadj minorQ_re_1_18 minorQ_im_1_18

@[expose] public def minorQ_re_1_19 : Polynomial ℚ := C (-24) + C (-8) * X ^ 2 + C (4) * X ^ 3 + C (-4) * X ^ 4 + C (20) * X ^ 5 + C (20) * X ^ 6 + C (-4) * X ^ 7 + C (4) * X ^ 8 + C (-8) * X ^ 9
@[expose] public def minorQ_im_1_19 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_19 : Ki := ofLadj minorQ_re_1_19 minorQ_im_1_19

@[expose] public def minorQ_re_1_20 : Polynomial ℚ := C (8) + C (8) * X ^ 2 + C (-16) * X ^ 3 + C (-16) * X ^ 4 + C (-24) * X ^ 5 + C (-24) * X ^ 6 + C (-16) * X ^ 7 + C (-16) * X ^ 8 + C (8) * X ^ 9
@[expose] public def minorQ_im_1_20 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_1_20 : Ki := ofLadj minorQ_re_1_20 minorQ_im_1_20

@[expose] public def minorQ_re_2_0 : Polynomial ℚ := C (1) + C (-1) * X ^ 2 + C (-13) * X ^ 3 + C (-23) * X ^ 4 + C (-24) * X ^ 5 + C (-24) * X ^ 6 + C (-23) * X ^ 7 + C (-13) * X ^ 8 + C (-1) * X ^ 9
@[expose] public def minorQ_im_2_0 : Polynomial ℚ := C (9) + C (18) * X + C (27) * X ^ 2 + C (25) * X ^ 3 + C (23) * X ^ 4 + C (10) * X ^ 5 + C (8) * X ^ 6 + C (-5) * X ^ 7 + C (-7) * X ^ 8 + C (-9) * X ^ 9
public def minorQ_entry_2_0 : Ki := ofLadj minorQ_re_2_0 minorQ_im_2_0

@[expose] public def minorQ_re_2_1 : Polynomial ℚ := C (3) + C (-4) * X ^ 2 + C (1) * X ^ 3 + C (4) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (4) * X ^ 7 + C (1) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def minorQ_im_2_1 : Polynomial ℚ := C (3) + C (6) * X + C (-2) * X ^ 2 + C (1) * X ^ 3 + C (4) * X ^ 4 + C (7) * X ^ 5 + C (-1) * X ^ 6 + C (2) * X ^ 7 + C (5) * X ^ 8 + C (8) * X ^ 9
public def minorQ_entry_2_1 : Ki := ofLadj minorQ_re_2_1 minorQ_im_2_1

@[expose] public def minorQ_re_2_2 : Polynomial ℚ := C (-13) + C (-10) * X ^ 2 + C (9) * X ^ 3 + C (15) * X ^ 4 + C (20) * X ^ 5 + C (20) * X ^ 6 + C (15) * X ^ 7 + C (9) * X ^ 8 + C (-10) * X ^ 9
@[expose] public def minorQ_im_2_2 : Polynomial ℚ := C (-5) + C (-10) * X + C (-4) * X ^ 2 + C (-9) * X ^ 3 + C (-3) * X ^ 4 + C (-8) * X ^ 5 + C (-2) * X ^ 6 + C (-7) * X ^ 7 + C (-1) * X ^ 8 + C (-6) * X ^ 9
public def minorQ_entry_2_2 : Ki := ofLadj minorQ_re_2_2 minorQ_im_2_2

@[expose] public def minorQ_re_2_3 : Polynomial ℚ := C (4) + C (14) * X ^ 2 + C (11) * X ^ 3 + C (18) * X ^ 4 + C (21) * X ^ 5 + C (21) * X ^ 6 + C (18) * X ^ 7 + C (11) * X ^ 8 + C (14) * X ^ 9
@[expose] public def minorQ_im_2_3 : Polynomial ℚ := C (-2) + C (-4) * X + C (-6) * X ^ 2 + C (3) * X ^ 3 + C (-10) * X ^ 4 + C (-1) * X ^ 5 + C (-3) * X ^ 6 + C (6) * X ^ 7 + C (-7) * X ^ 8 + C (2) * X ^ 9
public def minorQ_entry_2_3 : Ki := ofLadj minorQ_re_2_3 minorQ_im_2_3

@[expose] public def minorQ_re_2_4 : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (-8) * X ^ 3 + C (-8) * X ^ 4 + C (-18) * X ^ 5 + C (-18) * X ^ 6 + C (-8) * X ^ 7 + C (-8) * X ^ 8 + C (3) * X ^ 9
@[expose] public def minorQ_im_2_4 : Polynomial ℚ := C (-5) + C (-10) * X + C (-15) * X ^ 2 + C (-20) * X ^ 3 + C (-14) * X ^ 4 + C (-8) * X ^ 5 + C (-2) * X ^ 6 + C (4) * X ^ 7 + C (10) * X ^ 8 + C (5) * X ^ 9
public def minorQ_entry_2_4 : Ki := ofLadj minorQ_re_2_4 minorQ_im_2_4

@[expose] public def minorQ_re_2_5 : Polynomial ℚ := C (-6) + C (-6) * X ^ 2 + C (8) * X ^ 3 + C (2) * X ^ 4 + C (10) * X ^ 5 + C (10) * X ^ 6 + C (2) * X ^ 7 + C (8) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_2_5 : Polynomial ℚ := C (2) + C (4) * X + C (6) * X ^ 2 + C (8) * X ^ 3 + C (10) * X ^ 4 + C (-10) * X ^ 5 + C (14) * X ^ 6 + C (-6) * X ^ 7 + C (-4) * X ^ 8 + C (-2) * X ^ 9
public def minorQ_entry_2_5 : Ki := ofLadj minorQ_re_2_5 minorQ_im_2_5

public def minorQ_re_2_6 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_im_2_6 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_2_6 : Ki := ofLadj minorQ_re_2_6 minorQ_im_2_6

@[expose] public def minorQ_re_2_7 : Polynomial ℚ := C (-4) + C (6) * X ^ 2 + C (-6) * X ^ 3 + C (-10) * X ^ 4 + C (-10) * X ^ 5 + C (-10) * X ^ 6 + C (-10) * X ^ 7 + C (-6) * X ^ 8 + C (6) * X ^ 9
@[expose] public def minorQ_im_2_7 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_2_7 : Ki := ofLadj minorQ_re_2_7 minorQ_im_2_7

@[expose] public def minorQ_re_2_8 : Polynomial ℚ := C (-2) + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C (4) * X ^ 7 + C (4) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_2_8 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_2_8 : Ki := ofLadj minorQ_re_2_8 minorQ_im_2_8

@[expose] public def minorQ_re_2_9 : Polynomial ℚ := C (7) + C (1) * X ^ 2 + C (2) * X ^ 4 + C (-1) * X ^ 5 + C (-1) * X ^ 6 + C (2) * X ^ 7 + C (1) * X ^ 9
@[expose] public def minorQ_im_2_9 : Polynomial ℚ := C (3) + C (6) * X + C (9) * X ^ 2 + C (12) * X ^ 3 + C (4) * X ^ 4 + C (7) * X ^ 5 + C (-1) * X ^ 6 + C (2) * X ^ 7 + C (-6) * X ^ 8 + C (-3) * X ^ 9
public def minorQ_entry_2_9 : Ki := ofLadj minorQ_re_2_9 minorQ_im_2_9

@[expose] public def minorQ_re_2_10 : Polynomial ℚ := C (-4) * X ^ 2 + C (2) * X ^ 4 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (2) * X ^ 7 + C (-4) * X ^ 9
@[expose] public def minorQ_im_2_10 : Polynomial ℚ := C (-4) + C (-8) * X + C (-12) * X ^ 2 + C (-16) * X ^ 3 + C (2) * X ^ 4 + C (-2) * X ^ 5 + C (-6) * X ^ 6 + C (-10) * X ^ 7 + C (8) * X ^ 8 + C (4) * X ^ 9
public def minorQ_entry_2_10 : Ki := ofLadj minorQ_re_2_10 minorQ_im_2_10

@[expose] public def minorQ_re_2_11 : Polynomial ℚ := C (18) + C (18) * X ^ 2 + C (6) * X ^ 3 + C (14) * X ^ 4 + C (8) * X ^ 5 + C (8) * X ^ 6 + C (14) * X ^ 7 + C (6) * X ^ 8 + C (18) * X ^ 9
@[expose] public def minorQ_im_2_11 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_2_11 : Ki := ofLadj minorQ_re_2_11 minorQ_im_2_11

@[expose] public def minorQ_re_2_12 : Polynomial ℚ := C (-8) + C (-20) * X ^ 2 + C (-8) * X ^ 3 + C (-16) * X ^ 4 + C (-18) * X ^ 5 + C (-18) * X ^ 6 + C (-16) * X ^ 7 + C (-8) * X ^ 8 + C (-20) * X ^ 9
@[expose] public def minorQ_im_2_12 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_2_12 : Ki := ofLadj minorQ_re_2_12 minorQ_im_2_12

@[expose] public def minorQ_re_2_13 : Polynomial ℚ := C (-12) + C (-12) * X ^ 2 + C (-12) * X ^ 3 + C (-22) * X ^ 4 + C (-14) * X ^ 5 + C (-14) * X ^ 6 + C (-22) * X ^ 7 + C (-12) * X ^ 8 + C (-12) * X ^ 9
@[expose] public def minorQ_im_2_13 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_2_13 : Ki := ofLadj minorQ_re_2_13 minorQ_im_2_13

@[expose] public def minorQ_re_2_14 : Polynomial ℚ := C (-4) + C (-6) * X ^ 2 + C (-20) * X ^ 3 + C (-28) * X ^ 4 + C (-32) * X ^ 5 + C (-32) * X ^ 6 + C (-28) * X ^ 7 + C (-20) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_2_14 : Polynomial ℚ := C (-4) + C (-8) * X + C (10) * X ^ 2 + C (-16) * X ^ 3 + C (24) * X ^ 4 + C (-24) * X ^ 5 + C (16) * X ^ 6 + C (-32) * X ^ 7 + C (8) * X ^ 8 + C (-18) * X ^ 9
public def minorQ_entry_2_14 : Ki := ofLadj minorQ_re_2_14 minorQ_im_2_14

public def minorQ_re_2_15 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_im_2_15 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_2_15 : Ki := ofLadj minorQ_re_2_15 minorQ_im_2_15

@[expose] public def minorQ_re_2_16 : Polynomial ℚ := C (4) + C (8) * X ^ 2 + C (2) * X ^ 3 + C (4) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C (4) * X ^ 7 + C (2) * X ^ 8 + C (8) * X ^ 9
@[expose] public def minorQ_im_2_16 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_2_16 : Ki := ofLadj minorQ_re_2_16 minorQ_im_2_16

@[expose] public def minorQ_re_2_17 : Polynomial ℚ := C (8) + C (16) * X ^ 2 + C (-2) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 7 + C (-2) * X ^ 8 + C (16) * X ^ 9
@[expose] public def minorQ_im_2_17 : Polynomial ℚ := C (-8) + C (-16) * X + C (-24) * X ^ 2 + C (-10) * X ^ 3 + C (-40) * X ^ 4 + C (-4) * X ^ 5 + C (-12) * X ^ 6 + C (24) * X ^ 7 + C (-6) * X ^ 8 + C (8) * X ^ 9
public def minorQ_entry_2_17 : Ki := ofLadj minorQ_re_2_17 minorQ_im_2_17

@[expose] public def minorQ_re_2_18 : Polynomial ℚ := C (-4) + C (12) * X ^ 3 + C (16) * X ^ 4 + C (18) * X ^ 5 + C (18) * X ^ 6 + C (16) * X ^ 7 + C (12) * X ^ 8
@[expose] public def minorQ_im_2_18 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_2_18 : Ki := ofLadj minorQ_re_2_18 minorQ_im_2_18

@[expose] public def minorQ_re_2_19 : Polynomial ℚ := C (-2) * X ^ 2 + C (18) * X ^ 3 + C (24) * X ^ 4 + C (26) * X ^ 5 + C (26) * X ^ 6 + C (24) * X ^ 7 + C (18) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_2_19 : Polynomial ℚ := C (8) + C (16) * X + C (2) * X ^ 2 + C (10) * X ^ 3 + C (-4) * X ^ 4 + C (26) * X ^ 5 + C (-10) * X ^ 6 + C (20) * X ^ 7 + C (6) * X ^ 8 + C (14) * X ^ 9
public def minorQ_entry_2_19 : Ki := ofLadj minorQ_re_2_19 minorQ_im_2_19

@[expose] public def minorQ_re_2_20 : Polynomial ℚ := C (-4) + C (-4) * X ^ 2 + C (8) * X ^ 3 + C (8) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (8) * X ^ 7 + C (8) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def minorQ_im_2_20 : Polynomial ℚ := C (-12) + C (-24) * X + C (-36) * X ^ 2 + C (-48) * X ^ 3 + C (-16) * X ^ 4 + C (-28) * X ^ 5 + C (4) * X ^ 6 + C (-8) * X ^ 7 + C (24) * X ^ 8 + C (12) * X ^ 9
public def minorQ_entry_2_20 : Ki := ofLadj minorQ_re_2_20 minorQ_im_2_20

@[expose] public def minorQ_re_3_0 : Polynomial ℚ := C (-2) + C (-2) * X ^ 2 + C (2) * X ^ 3 + C (10) * X ^ 4 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (10) * X ^ 7 + C (2) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_3_0 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_0 : Ki := ofLadj minorQ_re_3_0 minorQ_im_3_0

@[expose] public def minorQ_re_3_1 : Polynomial ℚ := C (-8) + C (-4) * X ^ 2 + C (-6) * X ^ 3 + C (-8) * X ^ 4 + C (-8) * X ^ 7 + C (-6) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def minorQ_im_3_1 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_1 : Ki := ofLadj minorQ_re_3_1 minorQ_im_3_1

@[expose] public def minorQ_re_3_2 : Polynomial ℚ := C (-14) + C (-8) * X ^ 2 + C (8) * X ^ 3 + C (8) * X ^ 4 + C (10) * X ^ 5 + C (10) * X ^ 6 + C (8) * X ^ 7 + C (8) * X ^ 8 + C (-8) * X ^ 9
@[expose] public def minorQ_im_3_2 : Polynomial ℚ := C (-8) + C (-16) * X + C (-24) * X ^ 2 + C (-32) * X ^ 3 + C (-18) * X ^ 4 + C (-4) * X ^ 5 + C (-12) * X ^ 6 + C (2) * X ^ 7 + C (16) * X ^ 8 + C (8) * X ^ 9
public def minorQ_entry_3_2 : Ki := ofLadj minorQ_re_3_2 minorQ_im_3_2

@[expose] public def minorQ_re_3_3 : Polynomial ℚ := C (4) + C (-4) * X ^ 2 + C (-6) * X ^ 4 + C (-14) * X ^ 5 + C (-14) * X ^ 6 + C (-6) * X ^ 7 + C (-4) * X ^ 9
@[expose] public def minorQ_im_3_3 : Polynomial ℚ := C (-6) + C (-12) * X + C (-18) * X ^ 2 + C (-24) * X ^ 3 + C (-8) * X ^ 4 + C (-14) * X ^ 5 + C (2) * X ^ 6 + C (-4) * X ^ 7 + C (12) * X ^ 8 + C (6) * X ^ 9
public def minorQ_entry_3_3 : Ki := ofLadj minorQ_re_3_3 minorQ_im_3_3

@[expose] public def minorQ_re_3_4 : Polynomial ℚ := C (10) + C (4) * X ^ 2 + C (-14) * X ^ 3 + C (-24) * X ^ 4 + C (-26) * X ^ 5 + C (-26) * X ^ 6 + C (-24) * X ^ 7 + C (-14) * X ^ 8 + C (4) * X ^ 9
@[expose] public def minorQ_im_3_4 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_4 : Ki := ofLadj minorQ_re_3_4 minorQ_im_3_4

@[expose] public def minorQ_re_3_5 : Polynomial ℚ := C (-8) + C (-4) * X ^ 2 + C (-4) * X ^ 3 + C (8) * X ^ 4 + C (4) * X ^ 5 + C (4) * X ^ 6 + C (8) * X ^ 7 + C (-4) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def minorQ_im_3_5 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_5 : Ki := ofLadj minorQ_re_3_5 minorQ_im_3_5

public def minorQ_re_3_6 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_im_3_6 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_6 : Ki := ofLadj minorQ_re_3_6 minorQ_im_3_6

@[expose] public def minorQ_re_3_7 : Polynomial ℚ := C (-2) * X ^ 2 + C (-8) * X ^ 3 + C (-8) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (-8) * X ^ 7 + C (-8) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_3_7 : Polynomial ℚ := C (4) + C (8) * X + C (12) * X ^ 2 + C (16) * X ^ 3 + C (-2) * X ^ 4 + C (2) * X ^ 5 + C (6) * X ^ 6 + C (10) * X ^ 7 + C (-8) * X ^ 8 + C (-4) * X ^ 9
public def minorQ_entry_3_7 : Ki := ofLadj minorQ_re_3_7 minorQ_im_3_7

@[expose] public def minorQ_re_3_8 : Polynomial ℚ := C (-6) + C (-4) * X ^ 2 + C (-2) * X ^ 3 + C (-2) * X ^ 4 + C (-2) * X ^ 7 + C (-2) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def minorQ_im_3_8 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_8 : Ki := ofLadj minorQ_re_3_8 minorQ_im_3_8

@[expose] public def minorQ_re_3_9 : Polynomial ℚ := C (-2) + C (4) * X ^ 4 + C (8) * X ^ 5 + C (8) * X ^ 6 + C (4) * X ^ 7
@[expose] public def minorQ_im_3_9 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_9 : Ki := ofLadj minorQ_re_3_9 minorQ_im_3_9

@[expose] public def minorQ_re_3_10 : Polynomial ℚ := C (8) * X ^ 2 + C (-4) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (-4) * X ^ 7 + C (8) * X ^ 9
@[expose] public def minorQ_im_3_10 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_10 : Ki := ofLadj minorQ_re_3_10 minorQ_im_3_10

@[expose] public def minorQ_re_3_11 : Polynomial ℚ := C (28) + C (20) * X ^ 2 + C (-4) * X ^ 3 + C (12) * X ^ 4 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (12) * X ^ 7 + C (-4) * X ^ 8 + C (20) * X ^ 9
@[expose] public def minorQ_im_3_11 : Polynomial ℚ := C (4) + C (8) * X + C (-10) * X ^ 2 + C (16) * X ^ 3 + C (-24) * X ^ 4 + C (24) * X ^ 5 + C (-16) * X ^ 6 + C (32) * X ^ 7 + C (-8) * X ^ 8 + C (18) * X ^ 9
public def minorQ_entry_3_11 : Ki := ofLadj minorQ_re_3_11 minorQ_im_3_11

@[expose] public def minorQ_re_3_12 : Polynomial ℚ := C (-14) + C (-14) * X ^ 2 + C (8) * X ^ 3 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (8) * X ^ 8 + C (-14) * X ^ 9
@[expose] public def minorQ_im_3_12 : Polynomial ℚ := C (8) + C (16) * X + C (24) * X ^ 2 + C (10) * X ^ 3 + C (40) * X ^ 4 + C (4) * X ^ 5 + C (12) * X ^ 6 + C (-24) * X ^ 7 + C (6) * X ^ 8 + C (-8) * X ^ 9
public def minorQ_entry_3_12 : Ki := ofLadj minorQ_re_3_12 minorQ_im_3_12

@[expose] public def minorQ_re_3_13 : Polynomial ℚ := C (-16) + C (-22) * X ^ 2 + C (-14) * X ^ 3 + C (-36) * X ^ 4 + C (-30) * X ^ 5 + C (-30) * X ^ 6 + C (-36) * X ^ 7 + C (-14) * X ^ 8 + C (-22) * X ^ 9
@[expose] public def minorQ_im_3_13 : Polynomial ℚ := C (-8) + C (-16) * X + C (-2) * X ^ 2 + C (-10) * X ^ 3 + C (4) * X ^ 4 + C (-26) * X ^ 5 + C (10) * X ^ 6 + C (-20) * X ^ 7 + C (-6) * X ^ 8 + C (-14) * X ^ 9
public def minorQ_entry_3_13 : Ki := ofLadj minorQ_re_3_13 minorQ_im_3_13

@[expose] public def minorQ_re_3_14 : Polynomial ℚ := C (36) + C (40) * X ^ 2 + C (4) * X ^ 3 + C (28) * X ^ 4 + C (20) * X ^ 5 + C (20) * X ^ 6 + C (28) * X ^ 7 + C (4) * X ^ 8 + C (40) * X ^ 9
@[expose] public def minorQ_im_3_14 : Polynomial ℚ := C (12) + C (24) * X + C (36) * X ^ 2 + C (48) * X ^ 3 + C (16) * X ^ 4 + C (28) * X ^ 5 + C (-4) * X ^ 6 + C (8) * X ^ 7 + C (-24) * X ^ 8 + C (-12) * X ^ 9
public def minorQ_entry_3_14 : Ki := ofLadj minorQ_re_3_14 minorQ_im_3_14

public def minorQ_re_3_15 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_im_3_15 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_15 : Ki := ofLadj minorQ_re_3_15 minorQ_im_3_15

@[expose] public def minorQ_re_3_16 : Polynomial ℚ := C (8) + C (6) * X ^ 2 + C (2) * X ^ 3 + C (8) * X ^ 4 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (8) * X ^ 7 + C (2) * X ^ 8 + C (6) * X ^ 9
@[expose] public def minorQ_im_3_16 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_16 : Ki := ofLadj minorQ_re_3_16 minorQ_im_3_16

@[expose] public def minorQ_re_3_17 : Polynomial ℚ := C (-4) + C (-28) * X ^ 2 + C (-28) * X ^ 3 + C (-48) * X ^ 4 + C (-48) * X ^ 5 + C (-48) * X ^ 6 + C (-48) * X ^ 7 + C (-28) * X ^ 8 + C (-28) * X ^ 9
@[expose] public def minorQ_im_3_17 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_17 : Ki := ofLadj minorQ_re_3_17 minorQ_im_3_17

@[expose] public def minorQ_re_3_18 : Polynomial ℚ := C (-6) + C (-6) * X ^ 2 + C (-2) * X ^ 3 + C (-12) * X ^ 4 + C (-10) * X ^ 5 + C (-10) * X ^ 6 + C (-12) * X ^ 7 + C (-2) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_3_18 : Polynomial ℚ := C (-6) + C (-12) * X + C (-18) * X ^ 2 + C (-24) * X ^ 3 + C (-8) * X ^ 4 + C (-14) * X ^ 5 + C (2) * X ^ 6 + C (-4) * X ^ 7 + C (12) * X ^ 8 + C (6) * X ^ 9
public def minorQ_entry_3_18 : Ki := ofLadj minorQ_re_3_18 minorQ_im_3_18

@[expose] public def minorQ_re_3_19 : Polynomial ℚ := C (-24) + C (-8) * X ^ 2 + C (4) * X ^ 3 + C (-4) * X ^ 4 + C (20) * X ^ 5 + C (20) * X ^ 6 + C (-4) * X ^ 7 + C (4) * X ^ 8 + C (-8) * X ^ 9
@[expose] public def minorQ_im_3_19 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_19 : Ki := ofLadj minorQ_re_3_19 minorQ_im_3_19

@[expose] public def minorQ_re_3_20 : Polynomial ℚ := C (8) + C (8) * X ^ 2 + C (-16) * X ^ 3 + C (-16) * X ^ 4 + C (-24) * X ^ 5 + C (-24) * X ^ 6 + C (-16) * X ^ 7 + C (-16) * X ^ 8 + C (8) * X ^ 9
@[expose] public def minorQ_im_3_20 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_3_20 : Ki := ofLadj minorQ_re_3_20 minorQ_im_3_20

@[expose] public def minorQ_re_4_0 : Polynomial ℚ := C (2) + C (2) * X ^ 2 + C (-2) * X ^ 3 + C (-10) * X ^ 4 + C (-2) * X ^ 5 + C (-2) * X ^ 6 + C (-10) * X ^ 7 + C (-2) * X ^ 8 + C (2) * X ^ 9
@[expose] public def minorQ_im_4_0 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_0 : Ki := ofLadj minorQ_re_4_0 minorQ_im_4_0

@[expose] public def minorQ_re_4_1 : Polynomial ℚ := C (-4) * X ^ 2 + C (10) * X ^ 3 + C (16) * X ^ 4 + C (16) * X ^ 7 + C (10) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def minorQ_im_4_1 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_1 : Ki := ofLadj minorQ_re_4_1 minorQ_im_4_1

@[expose] public def minorQ_re_4_2 : Polynomial ℚ := C (10) + C (-14) * X ^ 2 + C (-26) * X ^ 3 + C (-34) * X ^ 4 + C (-52) * X ^ 5 + C (-52) * X ^ 6 + C (-34) * X ^ 7 + C (-26) * X ^ 8 + C (-14) * X ^ 9
@[expose] public def minorQ_im_4_2 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_2 : Ki := ofLadj minorQ_re_4_2 minorQ_im_4_2

@[expose] public def minorQ_re_4_3 : Polynomial ℚ := C (-10) + C (-6) * X ^ 2 + C (-10) * X ^ 3 + C (-2) * X ^ 4 + C (-10) * X ^ 5 + C (-10) * X ^ 6 + C (-2) * X ^ 7 + C (-10) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_4_3 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_3 : Ki := ofLadj minorQ_re_4_3 minorQ_im_4_3

@[expose] public def minorQ_re_4_4 : Polynomial ℚ := C (-14) + C (-6) * X ^ 2 + C (6) * X ^ 3 + C (24) * X ^ 4 + C (16) * X ^ 5 + C (16) * X ^ 6 + C (24) * X ^ 7 + C (6) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_4_4 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_4 : Ki := ofLadj minorQ_re_4_4 minorQ_im_4_4

@[expose] public def minorQ_re_4_5 : Polynomial ℚ := C (8) + C (4) * X ^ 2 + C (4) * X ^ 3 + C (-8) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (-8) * X ^ 7 + C (4) * X ^ 8 + C (4) * X ^ 9
@[expose] public def minorQ_im_4_5 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_5 : Ki := ofLadj minorQ_re_4_5 minorQ_im_4_5

@[expose] public def minorQ_re_4_6 : Polynomial ℚ := C (-2) + C (-6) * X ^ 2 + C (-12) * X ^ 3 + C (-12) * X ^ 4 + C (-2) * X ^ 5 + C (-2) * X ^ 6 + C (-12) * X ^ 7 + C (-12) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_4_6 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_6 : Ki := ofLadj minorQ_re_4_6 minorQ_im_4_6

@[expose] public def minorQ_re_4_7 : Polynomial ℚ := C (-34) + C (-14) * X ^ 2 + C (12) * X ^ 3 + C (6) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (6) * X ^ 7 + C (12) * X ^ 8 + C (-14) * X ^ 9
@[expose] public def minorQ_im_4_7 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_7 : Ki := ofLadj minorQ_re_4_7 minorQ_im_4_7

@[expose] public def minorQ_re_4_8 : Polynomial ℚ := C (10) + C (-2) * X ^ 2 + C (-16) * X ^ 3 + C (-26) * X ^ 4 + C (-38) * X ^ 5 + C (-38) * X ^ 6 + C (-26) * X ^ 7 + C (-16) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_4_8 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_8 : Ki := ofLadj minorQ_re_4_8 minorQ_im_4_8

@[expose] public def minorQ_re_4_9 : Polynomial ℚ := C (2) + C (6) * X ^ 2 + C (-8) * X ^ 3 + C (-16) * X ^ 4 + C (-16) * X ^ 5 + C (-16) * X ^ 6 + C (-16) * X ^ 7 + C (-8) * X ^ 8 + C (6) * X ^ 9
@[expose] public def minorQ_im_4_9 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_9 : Ki := ofLadj minorQ_re_4_9 minorQ_im_4_9

@[expose] public def minorQ_re_4_10 : Polynomial ℚ := C (-8) + C (-20) * X ^ 2 + C (-20) * X ^ 3 + C (-24) * X ^ 4 + C (-20) * X ^ 5 + C (-20) * X ^ 6 + C (-24) * X ^ 7 + C (-20) * X ^ 8 + C (-20) * X ^ 9
@[expose] public def minorQ_im_4_10 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_10 : Ki := ofLadj minorQ_re_4_10 minorQ_im_4_10

@[expose] public def minorQ_re_4_11 : Polynomial ℚ := C (-72) + C (-66) * X ^ 2 + C (-30) * X ^ 3 + C (-74) * X ^ 4 + C (-58) * X ^ 5 + C (-58) * X ^ 6 + C (-74) * X ^ 7 + C (-30) * X ^ 8 + C (-66) * X ^ 9
@[expose] public def minorQ_im_4_11 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_11 : Ki := ofLadj minorQ_re_4_11 minorQ_im_4_11

@[expose] public def minorQ_re_4_12 : Polynomial ℚ := C (56) + C (52) * X ^ 2 + C (24) * X ^ 3 + C (76) * X ^ 4 + C (62) * X ^ 5 + C (62) * X ^ 6 + C (76) * X ^ 7 + C (24) * X ^ 8 + C (52) * X ^ 9
@[expose] public def minorQ_im_4_12 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_12 : Ki := ofLadj minorQ_re_4_12 minorQ_im_4_12

@[expose] public def minorQ_re_4_13 : Polynomial ℚ := C (16) + C (24) * X ^ 2 + C (4) * X ^ 3 + C (10) * X ^ 4 + C (20) * X ^ 5 + C (20) * X ^ 6 + C (10) * X ^ 7 + C (4) * X ^ 8 + C (24) * X ^ 9
@[expose] public def minorQ_im_4_13 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_13 : Ki := ofLadj minorQ_re_4_13 minorQ_im_4_13

@[expose] public def minorQ_re_4_14 : Polynomial ℚ := C (-64) + C (-52) * X ^ 2 + C (-4) * X ^ 3 + C (-32) * X ^ 4 + C (-12) * X ^ 5 + C (-12) * X ^ 6 + C (-32) * X ^ 7 + C (-4) * X ^ 8 + C (-52) * X ^ 9
@[expose] public def minorQ_im_4_14 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_14 : Ki := ofLadj minorQ_re_4_14 minorQ_im_4_14

@[expose] public def minorQ_re_4_15 : Polynomial ℚ := C (2) + C (16) * X ^ 2 + C (28) * X ^ 3 + C (36) * X ^ 4 + C (40) * X ^ 5 + C (40) * X ^ 6 + C (36) * X ^ 7 + C (28) * X ^ 8 + C (16) * X ^ 9
@[expose] public def minorQ_im_4_15 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_15 : Ki := ofLadj minorQ_re_4_15 minorQ_im_4_15

@[expose] public def minorQ_re_4_16 : Polynomial ℚ := C (28) + C (-24) * X ^ 3 + C (-50) * X ^ 4 + C (-50) * X ^ 5 + C (-50) * X ^ 6 + C (-50) * X ^ 7 + C (-24) * X ^ 8
@[expose] public def minorQ_im_4_16 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_16 : Ki := ofLadj minorQ_re_4_16 minorQ_im_4_16

@[expose] public def minorQ_re_4_17 : Polynomial ℚ := C (36) * X ^ 2 + C (36) * X ^ 3 + C (72) * X ^ 4 + C (76) * X ^ 5 + C (76) * X ^ 6 + C (72) * X ^ 7 + C (36) * X ^ 8 + C (36) * X ^ 9
@[expose] public def minorQ_im_4_17 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_17 : Ki := ofLadj minorQ_re_4_17 minorQ_im_4_17

@[expose] public def minorQ_re_4_18 : Polynomial ℚ := C (20) + C (10) * X ^ 2 + C (12) * X ^ 3 + C (18) * X ^ 4 + C (16) * X ^ 5 + C (16) * X ^ 6 + C (18) * X ^ 7 + C (12) * X ^ 8 + C (10) * X ^ 9
@[expose] public def minorQ_im_4_18 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_18 : Ki := ofLadj minorQ_re_4_18 minorQ_im_4_18

@[expose] public def minorQ_re_4_19 : Polynomial ℚ := C (8) + C (-12) * X ^ 2 + C (-20) * X ^ 3 + C (-16) * X ^ 4 + C (-44) * X ^ 5 + C (-44) * X ^ 6 + C (-16) * X ^ 7 + C (-20) * X ^ 8 + C (-12) * X ^ 9
@[expose] public def minorQ_im_4_19 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_19 : Ki := ofLadj minorQ_re_4_19 minorQ_im_4_19

@[expose] public def minorQ_re_4_20 : Polynomial ℚ := C (-8) + C (-8) * X ^ 2 + C (16) * X ^ 3 + C (16) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (16) * X ^ 7 + C (16) * X ^ 8 + C (-8) * X ^ 9
@[expose] public def minorQ_im_4_20 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_4_20 : Ki := ofLadj minorQ_re_4_20 minorQ_im_4_20

@[expose] public def minorQ_re_5_0 : Polynomial ℚ := C (-1) + C (-1) * X ^ 2 + C (1) * X ^ 3 + C (5) * X ^ 4 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (5) * X ^ 7 + C (1) * X ^ 8 + C (-1) * X ^ 9
@[expose] public def minorQ_im_5_0 : Polynomial ℚ := C (-1) + C (-2) * X + C (-3) * X ^ 2 + C (-15) * X ^ 3 + C (-5) * X ^ 4 + C (5) * X ^ 5 + C (-7) * X ^ 6 + C (3) * X ^ 7 + C (13) * X ^ 8 + C (1) * X ^ 9
public def minorQ_entry_5_0 : Ki := ofLadj minorQ_re_5_0 minorQ_im_5_0

@[expose] public def minorQ_re_5_1 : Polynomial ℚ := C (-17) * X ^ 3 + C (-26) * X ^ 4 + C (-23) * X ^ 5 + C (-23) * X ^ 6 + C (-26) * X ^ 7 + C (-17) * X ^ 8
@[expose] public def minorQ_im_5_1 : Polynomial ℚ := C (-2) + C (-4) * X + C (16) * X ^ 2 + C (25) * X ^ 3 + C (12) * X ^ 4 + C (-1) * X ^ 5 + C (-3) * X ^ 6 + C (-16) * X ^ 7 + C (-29) * X ^ 8 + C (-20) * X ^ 9
public def minorQ_entry_5_1 : Ki := ofLadj minorQ_re_5_1 minorQ_im_5_1

@[expose] public def minorQ_re_5_2 : Polynomial ℚ := C (-2) + C (1) * X ^ 3 + C (12) * X ^ 4 + C (10) * X ^ 5 + C (10) * X ^ 6 + C (12) * X ^ 7 + C (1) * X ^ 8
@[expose] public def minorQ_im_5_2 : Polynomial ℚ := C (-20) + C (-40) * X + C (-38) * X ^ 2 + C (-47) * X ^ 3 + C (-34) * X ^ 4 + C (-32) * X ^ 5 + C (-8) * X ^ 6 + C (-6) * X ^ 7 + C (7) * X ^ 8 + C (-2) * X ^ 9
public def minorQ_entry_5_2 : Ki := ofLadj minorQ_re_5_2 minorQ_im_5_2

@[expose] public def minorQ_re_5_3 : Polynomial ℚ := C (2) + C (2) * X ^ 2 + C (24) * X ^ 3 + C (22) * X ^ 4 + C (28) * X ^ 5 + C (28) * X ^ 6 + C (22) * X ^ 7 + C (24) * X ^ 8 + C (2) * X ^ 9
@[expose] public def minorQ_im_5_3 : Polynomial ℚ := C (4) + C (8) * X + C (-10) * X ^ 2 + C (-6) * X ^ 3 + C (-2) * X ^ 4 + C (2) * X ^ 5 + C (6) * X ^ 6 + C (10) * X ^ 7 + C (14) * X ^ 8 + C (18) * X ^ 9
public def minorQ_entry_5_3 : Ki := ofLadj minorQ_re_5_3 minorQ_im_5_3

@[expose] public def minorQ_re_5_4 : Polynomial ℚ := C (3) + C (-1) * X ^ 2 + C (-12) * X ^ 3 + C (-19) * X ^ 4 + C (-19) * X ^ 5 + C (-19) * X ^ 6 + C (-19) * X ^ 7 + C (-12) * X ^ 8 + C (-1) * X ^ 9
@[expose] public def minorQ_im_5_4 : Polynomial ℚ := C (21) + C (42) * X + C (41) * X ^ 2 + C (62) * X ^ 3 + C (39) * X ^ 4 + C (27) * X ^ 5 + C (15) * X ^ 6 + C (3) * X ^ 7 + C (-20) * X ^ 8 + C (1) * X ^ 9
public def minorQ_entry_5_4 : Ki := ofLadj minorQ_re_5_4 minorQ_im_5_4

@[expose] public def minorQ_re_5_5 : Polynomial ℚ := C (-4) + C (-2) * X ^ 2 + C (-2) * X ^ 3 + C (4) * X ^ 4 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (4) * X ^ 7 + C (-2) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_5_5 : Polynomial ℚ := C (-12) + C (-24) * X + C (-14) * X ^ 2 + C (-26) * X ^ 3 + C (-16) * X ^ 4 + C (-6) * X ^ 5 + C (-18) * X ^ 6 + C (-8) * X ^ 7 + C (2) * X ^ 8 + C (-10) * X ^ 9
public def minorQ_entry_5_5 : Ki := ofLadj minorQ_re_5_5 minorQ_im_5_5

@[expose] public def minorQ_re_5_6 : Polynomial ℚ := C (-3) * X ^ 2 + C (4) * X ^ 3 + C (6) * X ^ 4 + C (4) * X ^ 5 + C (4) * X ^ 6 + C (6) * X ^ 7 + C (4) * X ^ 8 + C (-3) * X ^ 9
@[expose] public def minorQ_im_5_6 : Polynomial ℚ := C (4) + C (8) * X + C (1) * X ^ 2 + C (-6) * X ^ 3 + C (-2) * X ^ 4 + C (2) * X ^ 5 + C (6) * X ^ 6 + C (10) * X ^ 7 + C (14) * X ^ 8 + C (7) * X ^ 9
public def minorQ_entry_5_6 : Ki := ofLadj minorQ_re_5_6 minorQ_im_5_6

@[expose] public def minorQ_re_5_7 : Polynomial ℚ := C (-8) + C (-1) * X ^ 2 + C (4) * X ^ 3 + C (-1) * X ^ 4 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (-1) * X ^ 7 + C (4) * X ^ 8 + C (-1) * X ^ 9
@[expose] public def minorQ_im_5_7 : Polynomial ℚ := C (10) + C (20) * X + C (19) * X ^ 2 + C (18) * X ^ 3 + C (17) * X ^ 4 + C (16) * X ^ 5 + C (4) * X ^ 6 + C (3) * X ^ 7 + C (2) * X ^ 8 + C (1) * X ^ 9
public def minorQ_entry_5_7 : Ki := ofLadj minorQ_re_5_7 minorQ_im_5_7

@[expose] public def minorQ_re_5_8 : Polynomial ℚ := C (2) + C (1) * X ^ 2 + C (-10) * X ^ 3 + C (-13) * X ^ 4 + C (-12) * X ^ 5 + C (-12) * X ^ 6 + C (-13) * X ^ 7 + C (-10) * X ^ 8 + C (1) * X ^ 9
@[expose] public def minorQ_im_5_8 : Polynomial ℚ := C (-10) + C (-20) * X + C (-19) * X ^ 2 + C (-18) * X ^ 3 + C (-17) * X ^ 4 + C (-16) * X ^ 5 + C (-4) * X ^ 6 + C (-3) * X ^ 7 + C (-2) * X ^ 8 + C (-1) * X ^ 9
public def minorQ_entry_5_8 : Ki := ofLadj minorQ_re_5_8 minorQ_im_5_8

@[expose] public def minorQ_re_5_9 : Polynomial ℚ := C (11) + C (15) * X ^ 2 + C (12) * X ^ 3 + C (28) * X ^ 4 + C (22) * X ^ 5 + C (22) * X ^ 6 + C (28) * X ^ 7 + C (12) * X ^ 8 + C (15) * X ^ 9
@[expose] public def minorQ_im_5_9 : Polynomial ℚ := C (-13) + C (-26) * X + C (-39) * X ^ 2 + C (-30) * X ^ 3 + C (-32) * X ^ 4 + C (-12) * X ^ 5 + C (-14) * X ^ 6 + C (6) * X ^ 7 + C (4) * X ^ 8 + C (13) * X ^ 9
public def minorQ_entry_5_9 : Ki := ofLadj minorQ_re_5_9 minorQ_im_5_9

@[expose] public def minorQ_re_5_10 : Polynomial ℚ := C (-6) + C (2) * X ^ 2 + C (16) * X ^ 3 + C (18) * X ^ 4 + C (22) * X ^ 5 + C (22) * X ^ 6 + C (18) * X ^ 7 + C (16) * X ^ 8 + C (2) * X ^ 9
@[expose] public def minorQ_im_5_10 : Polynomial ℚ := C (-6) + C (-12) * X + C (-18) * X ^ 2 + C (-24) * X ^ 3 + C (-30) * X ^ 4 + C (-14) * X ^ 5 + C (2) * X ^ 6 + C (18) * X ^ 7 + C (12) * X ^ 8 + C (6) * X ^ 9
public def minorQ_entry_5_10 : Ki := ofLadj minorQ_re_5_10 minorQ_im_5_10

@[expose] public def minorQ_re_5_11 : Polynomial ℚ := C (42) + C (41) * X ^ 2 + C (2) * X ^ 3 + C (27) * X ^ 4 + C (8) * X ^ 5 + C (8) * X ^ 6 + C (27) * X ^ 7 + C (2) * X ^ 8 + C (41) * X ^ 9
@[expose] public def minorQ_im_5_11 : Polynomial ℚ := C (6) + C (12) * X + C (-15) * X ^ 2 + C (24) * X ^ 3 + C (-25) * X ^ 4 + C (36) * X ^ 5 + C (-24) * X ^ 6 + C (37) * X ^ 7 + C (-12) * X ^ 8 + C (27) * X ^ 9
public def minorQ_entry_5_11 : Ki := ofLadj minorQ_re_5_11 minorQ_im_5_11

@[expose] public def minorQ_re_5_12 : Polynomial ℚ := C (-60) + C (-60) * X ^ 2 + C (-8) * X ^ 3 + C (-46) * X ^ 4 + C (-21) * X ^ 5 + C (-21) * X ^ 6 + C (-46) * X ^ 7 + C (-8) * X ^ 8 + C (-60) * X ^ 9
@[expose] public def minorQ_im_5_12 : Polynomial ℚ := C (-6) + C (-12) * X + C (26) * X ^ 2 + C (-24) * X ^ 3 + C (36) * X ^ 4 + C (-47) * X ^ 5 + C (35) * X ^ 6 + C (-48) * X ^ 7 + C (12) * X ^ 8 + C (-38) * X ^ 9
public def minorQ_entry_5_12 : Ki := ofLadj minorQ_re_5_12 minorQ_im_5_12

@[expose] public def minorQ_re_5_13 : Polynomial ℚ := C (-8) + C (-16) * X ^ 2 + C (-4) * X ^ 3 + C (-19) * X ^ 4 + C (-12) * X ^ 5 + C (-12) * X ^ 6 + C (-19) * X ^ 7 + C (-4) * X ^ 8 + C (-16) * X ^ 9
@[expose] public def minorQ_im_5_13 : Polynomial ℚ := C (8) + C (16) * X + C (24) * X ^ 2 + C (10) * X ^ 3 + C (29) * X ^ 4 + C (4) * X ^ 5 + C (12) * X ^ 6 + C (-13) * X ^ 7 + C (6) * X ^ 8 + C (-8) * X ^ 9
public def minorQ_entry_5_13 : Ki := ofLadj minorQ_re_5_13 minorQ_im_5_13

@[expose] public def minorQ_re_5_14 : Polynomial ℚ := C (30) + C (26) * X ^ 2 + C (-18) * X ^ 3 + C (-8) * X ^ 4 + C (-26) * X ^ 5 + C (-26) * X ^ 6 + C (-8) * X ^ 7 + C (-18) * X ^ 8 + C (26) * X ^ 9
@[expose] public def minorQ_im_5_14 : Polynomial ℚ := C (22) + C (44) * X + C (22) * X ^ 2 + C (66) * X ^ 3 + C (66) * X ^ 5 + C (-22) * X ^ 6 + C (44) * X ^ 7 + C (-22) * X ^ 8 + C (22) * X ^ 9
public def minorQ_entry_5_14 : Ki := ofLadj minorQ_re_5_14 minorQ_im_5_14

@[expose] public def minorQ_re_5_15 : Polynomial ℚ := C (24) + C (27) * X ^ 2 + C (6) * X ^ 3 + C (25) * X ^ 4 + C (18) * X ^ 5 + C (18) * X ^ 6 + C (25) * X ^ 7 + C (6) * X ^ 8 + C (27) * X ^ 9
@[expose] public def minorQ_im_5_15 : Polynomial ℚ := C (8) + C (16) * X + C (13) * X ^ 2 + C (32) * X ^ 3 + C (7) * X ^ 4 + C (26) * X ^ 5 + C (-10) * X ^ 6 + C (9) * X ^ 7 + C (-16) * X ^ 8 + C (3) * X ^ 9
public def minorQ_entry_5_15 : Ki := ofLadj minorQ_re_5_15 minorQ_im_5_15

@[expose] public def minorQ_re_5_16 : Polynomial ℚ := C (-6) * X ^ 2 + C (-16) * X ^ 3 + C (-15) * X ^ 4 + C (-29) * X ^ 5 + C (-29) * X ^ 6 + C (-15) * X ^ 7 + C (-16) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_5_16 : Polynomial ℚ := C (-6) + C (-12) * X + C (-18) * X ^ 2 + C (-24) * X ^ 3 + C (-19) * X ^ 4 + C (-3) * X ^ 5 + C (-9) * X ^ 6 + C (7) * X ^ 7 + C (12) * X ^ 8 + C (6) * X ^ 9
public def minorQ_entry_5_16 : Ki := ofLadj minorQ_re_5_16 minorQ_im_5_16

@[expose] public def minorQ_re_5_17 : Polynomial ℚ := C (-16) + C (-28) * X ^ 2 + C (4) * X ^ 3 + C (-10) * X ^ 4 + C (-2) * X ^ 5 + C (-2) * X ^ 6 + C (-10) * X ^ 7 + C (4) * X ^ 8 + C (-28) * X ^ 9
@[expose] public def minorQ_im_5_17 : Polynomial ℚ := C (20) + C (40) * X + C (60) * X ^ 2 + C (36) * X ^ 3 + C (78) * X ^ 4 + C (10) * X ^ 5 + C (30) * X ^ 6 + C (-38) * X ^ 7 + C (4) * X ^ 8 + C (-20) * X ^ 9
public def minorQ_entry_5_17 : Ki := ofLadj minorQ_re_5_17 minorQ_im_5_17

@[expose] public def minorQ_re_5_18 : Polynomial ℚ := C (-6) + C (1) * X ^ 2 + C (15) * X ^ 3 + C (16) * X ^ 4 + C (26) * X ^ 5 + C (26) * X ^ 6 + C (16) * X ^ 7 + C (15) * X ^ 8 + C (1) * X ^ 9
@[expose] public def minorQ_im_5_18 : Polynomial ℚ := C (-6) + C (-12) * X + C (-7) * X ^ 2 + C (-13) * X ^ 3 + C (-8) * X ^ 4 + C (-14) * X ^ 5 + C (2) * X ^ 6 + C (-4) * X ^ 7 + C (1) * X ^ 8 + C (-5) * X ^ 9
public def minorQ_entry_5_18 : Ki := ofLadj minorQ_re_5_18 minorQ_im_5_18

@[expose] public def minorQ_re_5_19 : Polynomial ℚ := C (-2) + C (4) * X ^ 2 + C (-4) * X ^ 3 + C (-8) * X ^ 4 + C (-2) * X ^ 5 + C (-2) * X ^ 6 + C (-8) * X ^ 7 + C (-4) * X ^ 8 + C (4) * X ^ 9
@[expose] public def minorQ_im_5_19 : Polynomial ℚ := C (-18) + C (-36) * X + C (-32) * X ^ 2 + C (-28) * X ^ 3 + C (-24) * X ^ 4 + C (-42) * X ^ 5 + C (6) * X ^ 6 + C (-12) * X ^ 7 + C (-8) * X ^ 8 + C (-4) * X ^ 9
public def minorQ_entry_5_19 : Ki := ofLadj minorQ_re_5_19 minorQ_im_5_19

@[expose] public def minorQ_re_5_20 : Polynomial ℚ := C (4) + C (4) * X ^ 2 + C (-8) * X ^ 3 + C (-8) * X ^ 4 + C (-12) * X ^ 5 + C (-12) * X ^ 6 + C (-8) * X ^ 7 + C (-8) * X ^ 8 + C (4) * X ^ 9
@[expose] public def minorQ_im_5_20 : Polynomial ℚ := C (12) + C (24) * X + C (36) * X ^ 2 + C (48) * X ^ 3 + C (16) * X ^ 4 + C (28) * X ^ 5 + C (-4) * X ^ 6 + C (8) * X ^ 7 + C (-24) * X ^ 8 + C (-12) * X ^ 9
public def minorQ_entry_5_20 : Ki := ofLadj minorQ_re_5_20 minorQ_im_5_20

@[expose] public def minorQ_re_6_0 : Polynomial ℚ := C (1) + C (-1) * X ^ 2 + C (-13) * X ^ 3 + C (-23) * X ^ 4 + C (-24) * X ^ 5 + C (-24) * X ^ 6 + C (-23) * X ^ 7 + C (-13) * X ^ 8 + C (-1) * X ^ 9
@[expose] public def minorQ_im_6_0 : Polynomial ℚ := C (-9) + C (-18) * X + C (-27) * X ^ 2 + C (-25) * X ^ 3 + C (-23) * X ^ 4 + C (-10) * X ^ 5 + C (-8) * X ^ 6 + C (5) * X ^ 7 + C (7) * X ^ 8 + C (9) * X ^ 9
public def minorQ_entry_6_0 : Ki := ofLadj minorQ_re_6_0 minorQ_im_6_0

@[expose] public def minorQ_re_6_1 : Polynomial ℚ := C (3) + C (-4) * X ^ 2 + C (1) * X ^ 3 + C (4) * X ^ 4 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (4) * X ^ 7 + C (1) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def minorQ_im_6_1 : Polynomial ℚ := C (-3) + C (-6) * X + C (2) * X ^ 2 + C (-1) * X ^ 3 + C (-4) * X ^ 4 + C (-7) * X ^ 5 + C (1) * X ^ 6 + C (-2) * X ^ 7 + C (-5) * X ^ 8 + C (-8) * X ^ 9
public def minorQ_entry_6_1 : Ki := ofLadj minorQ_re_6_1 minorQ_im_6_1

@[expose] public def minorQ_re_6_2 : Polynomial ℚ := C (-13) + C (-10) * X ^ 2 + C (9) * X ^ 3 + C (15) * X ^ 4 + C (20) * X ^ 5 + C (20) * X ^ 6 + C (15) * X ^ 7 + C (9) * X ^ 8 + C (-10) * X ^ 9
@[expose] public def minorQ_im_6_2 : Polynomial ℚ := C (5) + C (10) * X + C (4) * X ^ 2 + C (9) * X ^ 3 + C (3) * X ^ 4 + C (8) * X ^ 5 + C (2) * X ^ 6 + C (7) * X ^ 7 + C (1) * X ^ 8 + C (6) * X ^ 9
public def minorQ_entry_6_2 : Ki := ofLadj minorQ_re_6_2 minorQ_im_6_2

@[expose] public def minorQ_re_6_3 : Polynomial ℚ := C (4) + C (14) * X ^ 2 + C (11) * X ^ 3 + C (18) * X ^ 4 + C (21) * X ^ 5 + C (21) * X ^ 6 + C (18) * X ^ 7 + C (11) * X ^ 8 + C (14) * X ^ 9
@[expose] public def minorQ_im_6_3 : Polynomial ℚ := C (2) + C (4) * X + C (6) * X ^ 2 + C (-3) * X ^ 3 + C (10) * X ^ 4 + C (1) * X ^ 5 + C (3) * X ^ 6 + C (-6) * X ^ 7 + C (7) * X ^ 8 + C (-2) * X ^ 9
public def minorQ_entry_6_3 : Ki := ofLadj minorQ_re_6_3 minorQ_im_6_3

@[expose] public def minorQ_re_6_4 : Polynomial ℚ := C (7) + C (3) * X ^ 2 + C (-8) * X ^ 3 + C (-8) * X ^ 4 + C (-18) * X ^ 5 + C (-18) * X ^ 6 + C (-8) * X ^ 7 + C (-8) * X ^ 8 + C (3) * X ^ 9
@[expose] public def minorQ_im_6_4 : Polynomial ℚ := C (5) + C (10) * X + C (15) * X ^ 2 + C (20) * X ^ 3 + C (14) * X ^ 4 + C (8) * X ^ 5 + C (2) * X ^ 6 + C (-4) * X ^ 7 + C (-10) * X ^ 8 + C (-5) * X ^ 9
public def minorQ_entry_6_4 : Ki := ofLadj minorQ_re_6_4 minorQ_im_6_4

@[expose] public def minorQ_re_6_5 : Polynomial ℚ := C (-6) + C (-6) * X ^ 2 + C (8) * X ^ 3 + C (2) * X ^ 4 + C (10) * X ^ 5 + C (10) * X ^ 6 + C (2) * X ^ 7 + C (8) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_6_5 : Polynomial ℚ := C (-2) + C (-4) * X + C (-6) * X ^ 2 + C (-8) * X ^ 3 + C (-10) * X ^ 4 + C (10) * X ^ 5 + C (-14) * X ^ 6 + C (6) * X ^ 7 + C (4) * X ^ 8 + C (2) * X ^ 9
public def minorQ_entry_6_5 : Ki := ofLadj minorQ_re_6_5 minorQ_im_6_5

public def minorQ_re_6_6 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_im_6_6 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_6_6 : Ki := ofLadj minorQ_re_6_6 minorQ_im_6_6

@[expose] public def minorQ_re_6_7 : Polynomial ℚ := C (-4) + C (6) * X ^ 2 + C (-6) * X ^ 3 + C (-10) * X ^ 4 + C (-10) * X ^ 5 + C (-10) * X ^ 6 + C (-10) * X ^ 7 + C (-6) * X ^ 8 + C (6) * X ^ 9
@[expose] public def minorQ_im_6_7 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_6_7 : Ki := ofLadj minorQ_re_6_7 minorQ_im_6_7

@[expose] public def minorQ_re_6_8 : Polynomial ℚ := C (-2) + C (-2) * X ^ 2 + C (4) * X ^ 3 + C (4) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C (4) * X ^ 7 + C (4) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_6_8 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_6_8 : Ki := ofLadj minorQ_re_6_8 minorQ_im_6_8

@[expose] public def minorQ_re_6_9 : Polynomial ℚ := C (7) + C (1) * X ^ 2 + C (2) * X ^ 4 + C (-1) * X ^ 5 + C (-1) * X ^ 6 + C (2) * X ^ 7 + C (1) * X ^ 9
@[expose] public def minorQ_im_6_9 : Polynomial ℚ := C (-3) + C (-6) * X + C (-9) * X ^ 2 + C (-12) * X ^ 3 + C (-4) * X ^ 4 + C (-7) * X ^ 5 + C (1) * X ^ 6 + C (-2) * X ^ 7 + C (6) * X ^ 8 + C (3) * X ^ 9
public def minorQ_entry_6_9 : Ki := ofLadj minorQ_re_6_9 minorQ_im_6_9

@[expose] public def minorQ_re_6_10 : Polynomial ℚ := C (-4) * X ^ 2 + C (2) * X ^ 4 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (2) * X ^ 7 + C (-4) * X ^ 9
@[expose] public def minorQ_im_6_10 : Polynomial ℚ := C (4) + C (8) * X + C (12) * X ^ 2 + C (16) * X ^ 3 + C (-2) * X ^ 4 + C (2) * X ^ 5 + C (6) * X ^ 6 + C (10) * X ^ 7 + C (-8) * X ^ 8 + C (-4) * X ^ 9
public def minorQ_entry_6_10 : Ki := ofLadj minorQ_re_6_10 minorQ_im_6_10

@[expose] public def minorQ_re_6_11 : Polynomial ℚ := C (18) + C (18) * X ^ 2 + C (6) * X ^ 3 + C (14) * X ^ 4 + C (8) * X ^ 5 + C (8) * X ^ 6 + C (14) * X ^ 7 + C (6) * X ^ 8 + C (18) * X ^ 9
@[expose] public def minorQ_im_6_11 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_6_11 : Ki := ofLadj minorQ_re_6_11 minorQ_im_6_11

@[expose] public def minorQ_re_6_12 : Polynomial ℚ := C (-8) + C (-20) * X ^ 2 + C (-8) * X ^ 3 + C (-16) * X ^ 4 + C (-18) * X ^ 5 + C (-18) * X ^ 6 + C (-16) * X ^ 7 + C (-8) * X ^ 8 + C (-20) * X ^ 9
@[expose] public def minorQ_im_6_12 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_6_12 : Ki := ofLadj minorQ_re_6_12 minorQ_im_6_12

@[expose] public def minorQ_re_6_13 : Polynomial ℚ := C (-12) + C (-12) * X ^ 2 + C (-12) * X ^ 3 + C (-22) * X ^ 4 + C (-14) * X ^ 5 + C (-14) * X ^ 6 + C (-22) * X ^ 7 + C (-12) * X ^ 8 + C (-12) * X ^ 9
@[expose] public def minorQ_im_6_13 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_6_13 : Ki := ofLadj minorQ_re_6_13 minorQ_im_6_13

@[expose] public def minorQ_re_6_14 : Polynomial ℚ := C (-4) + C (-6) * X ^ 2 + C (-20) * X ^ 3 + C (-28) * X ^ 4 + C (-32) * X ^ 5 + C (-32) * X ^ 6 + C (-28) * X ^ 7 + C (-20) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_6_14 : Polynomial ℚ := C (4) + C (8) * X + C (-10) * X ^ 2 + C (16) * X ^ 3 + C (-24) * X ^ 4 + C (24) * X ^ 5 + C (-16) * X ^ 6 + C (32) * X ^ 7 + C (-8) * X ^ 8 + C (18) * X ^ 9
public def minorQ_entry_6_14 : Ki := ofLadj minorQ_re_6_14 minorQ_im_6_14

public def minorQ_re_6_15 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_im_6_15 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_6_15 : Ki := ofLadj minorQ_re_6_15 minorQ_im_6_15

@[expose] public def minorQ_re_6_16 : Polynomial ℚ := C (4) + C (8) * X ^ 2 + C (2) * X ^ 3 + C (4) * X ^ 4 + C (6) * X ^ 5 + C (6) * X ^ 6 + C (4) * X ^ 7 + C (2) * X ^ 8 + C (8) * X ^ 9
@[expose] public def minorQ_im_6_16 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_6_16 : Ki := ofLadj minorQ_re_6_16 minorQ_im_6_16

@[expose] public def minorQ_re_6_17 : Polynomial ℚ := C (8) + C (16) * X ^ 2 + C (-2) * X ^ 3 + C (4) * X ^ 4 + C (4) * X ^ 7 + C (-2) * X ^ 8 + C (16) * X ^ 9
@[expose] public def minorQ_im_6_17 : Polynomial ℚ := C (8) + C (16) * X + C (24) * X ^ 2 + C (10) * X ^ 3 + C (40) * X ^ 4 + C (4) * X ^ 5 + C (12) * X ^ 6 + C (-24) * X ^ 7 + C (6) * X ^ 8 + C (-8) * X ^ 9
public def minorQ_entry_6_17 : Ki := ofLadj minorQ_re_6_17 minorQ_im_6_17

@[expose] public def minorQ_re_6_18 : Polynomial ℚ := C (-4) + C (12) * X ^ 3 + C (16) * X ^ 4 + C (18) * X ^ 5 + C (18) * X ^ 6 + C (16) * X ^ 7 + C (12) * X ^ 8
@[expose] public def minorQ_im_6_18 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_6_18 : Ki := ofLadj minorQ_re_6_18 minorQ_im_6_18

@[expose] public def minorQ_re_6_19 : Polynomial ℚ := C (-2) * X ^ 2 + C (18) * X ^ 3 + C (24) * X ^ 4 + C (26) * X ^ 5 + C (26) * X ^ 6 + C (24) * X ^ 7 + C (18) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_6_19 : Polynomial ℚ := C (-8) + C (-16) * X + C (-2) * X ^ 2 + C (-10) * X ^ 3 + C (4) * X ^ 4 + C (-26) * X ^ 5 + C (10) * X ^ 6 + C (-20) * X ^ 7 + C (-6) * X ^ 8 + C (-14) * X ^ 9
public def minorQ_entry_6_19 : Ki := ofLadj minorQ_re_6_19 minorQ_im_6_19

@[expose] public def minorQ_re_6_20 : Polynomial ℚ := C (-4) + C (-4) * X ^ 2 + C (8) * X ^ 3 + C (8) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (8) * X ^ 7 + C (8) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def minorQ_im_6_20 : Polynomial ℚ := C (12) + C (24) * X + C (36) * X ^ 2 + C (48) * X ^ 3 + C (16) * X ^ 4 + C (28) * X ^ 5 + C (-4) * X ^ 6 + C (8) * X ^ 7 + C (-24) * X ^ 8 + C (-12) * X ^ 9
public def minorQ_entry_6_20 : Ki := ofLadj minorQ_re_6_20 minorQ_im_6_20

@[expose] public def minorQ_re_7_0 : Polynomial ℚ := C (-1) + C (-1) * X ^ 2 + C (1) * X ^ 3 + C (5) * X ^ 4 + C (1) * X ^ 5 + C (1) * X ^ 6 + C (5) * X ^ 7 + C (1) * X ^ 8 + C (-1) * X ^ 9
@[expose] public def minorQ_im_7_0 : Polynomial ℚ := C (1) + C (2) * X + C (3) * X ^ 2 + C (15) * X ^ 3 + C (5) * X ^ 4 + C (-5) * X ^ 5 + C (7) * X ^ 6 + C (-3) * X ^ 7 + C (-13) * X ^ 8 + C (-1) * X ^ 9
public def minorQ_entry_7_0 : Ki := ofLadj minorQ_re_7_0 minorQ_im_7_0

@[expose] public def minorQ_re_7_1 : Polynomial ℚ := C (-17) * X ^ 3 + C (-26) * X ^ 4 + C (-23) * X ^ 5 + C (-23) * X ^ 6 + C (-26) * X ^ 7 + C (-17) * X ^ 8
@[expose] public def minorQ_im_7_1 : Polynomial ℚ := C (2) + C (4) * X + C (-16) * X ^ 2 + C (-25) * X ^ 3 + C (-12) * X ^ 4 + C (1) * X ^ 5 + C (3) * X ^ 6 + C (16) * X ^ 7 + C (29) * X ^ 8 + C (20) * X ^ 9
public def minorQ_entry_7_1 : Ki := ofLadj minorQ_re_7_1 minorQ_im_7_1

@[expose] public def minorQ_re_7_2 : Polynomial ℚ := C (-2) + C (1) * X ^ 3 + C (12) * X ^ 4 + C (10) * X ^ 5 + C (10) * X ^ 6 + C (12) * X ^ 7 + C (1) * X ^ 8
@[expose] public def minorQ_im_7_2 : Polynomial ℚ := C (20) + C (40) * X + C (38) * X ^ 2 + C (47) * X ^ 3 + C (34) * X ^ 4 + C (32) * X ^ 5 + C (8) * X ^ 6 + C (6) * X ^ 7 + C (-7) * X ^ 8 + C (2) * X ^ 9
public def minorQ_entry_7_2 : Ki := ofLadj minorQ_re_7_2 minorQ_im_7_2

@[expose] public def minorQ_re_7_3 : Polynomial ℚ := C (2) + C (2) * X ^ 2 + C (24) * X ^ 3 + C (22) * X ^ 4 + C (28) * X ^ 5 + C (28) * X ^ 6 + C (22) * X ^ 7 + C (24) * X ^ 8 + C (2) * X ^ 9
@[expose] public def minorQ_im_7_3 : Polynomial ℚ := C (-4) + C (-8) * X + C (10) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 4 + C (-2) * X ^ 5 + C (-6) * X ^ 6 + C (-10) * X ^ 7 + C (-14) * X ^ 8 + C (-18) * X ^ 9
public def minorQ_entry_7_3 : Ki := ofLadj minorQ_re_7_3 minorQ_im_7_3

@[expose] public def minorQ_re_7_4 : Polynomial ℚ := C (3) + C (-1) * X ^ 2 + C (-12) * X ^ 3 + C (-19) * X ^ 4 + C (-19) * X ^ 5 + C (-19) * X ^ 6 + C (-19) * X ^ 7 + C (-12) * X ^ 8 + C (-1) * X ^ 9
@[expose] public def minorQ_im_7_4 : Polynomial ℚ := C (-21) + C (-42) * X + C (-41) * X ^ 2 + C (-62) * X ^ 3 + C (-39) * X ^ 4 + C (-27) * X ^ 5 + C (-15) * X ^ 6 + C (-3) * X ^ 7 + C (20) * X ^ 8 + C (-1) * X ^ 9
public def minorQ_entry_7_4 : Ki := ofLadj minorQ_re_7_4 minorQ_im_7_4

@[expose] public def minorQ_re_7_5 : Polynomial ℚ := C (-4) + C (-2) * X ^ 2 + C (-2) * X ^ 3 + C (4) * X ^ 4 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (4) * X ^ 7 + C (-2) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def minorQ_im_7_5 : Polynomial ℚ := C (12) + C (24) * X + C (14) * X ^ 2 + C (26) * X ^ 3 + C (16) * X ^ 4 + C (6) * X ^ 5 + C (18) * X ^ 6 + C (8) * X ^ 7 + C (-2) * X ^ 8 + C (10) * X ^ 9
public def minorQ_entry_7_5 : Ki := ofLadj minorQ_re_7_5 minorQ_im_7_5

@[expose] public def minorQ_re_7_6 : Polynomial ℚ := C (-3) * X ^ 2 + C (4) * X ^ 3 + C (6) * X ^ 4 + C (4) * X ^ 5 + C (4) * X ^ 6 + C (6) * X ^ 7 + C (4) * X ^ 8 + C (-3) * X ^ 9
@[expose] public def minorQ_im_7_6 : Polynomial ℚ := C (-4) + C (-8) * X + C (-1) * X ^ 2 + C (6) * X ^ 3 + C (2) * X ^ 4 + C (-2) * X ^ 5 + C (-6) * X ^ 6 + C (-10) * X ^ 7 + C (-14) * X ^ 8 + C (-7) * X ^ 9
public def minorQ_entry_7_6 : Ki := ofLadj minorQ_re_7_6 minorQ_im_7_6

@[expose] public def minorQ_re_7_7 : Polynomial ℚ := C (-8) + C (-1) * X ^ 2 + C (4) * X ^ 3 + C (-1) * X ^ 4 + C (2) * X ^ 5 + C (2) * X ^ 6 + C (-1) * X ^ 7 + C (4) * X ^ 8 + C (-1) * X ^ 9
@[expose] public def minorQ_im_7_7 : Polynomial ℚ := C (-10) + C (-20) * X + C (-19) * X ^ 2 + C (-18) * X ^ 3 + C (-17) * X ^ 4 + C (-16) * X ^ 5 + C (-4) * X ^ 6 + C (-3) * X ^ 7 + C (-2) * X ^ 8 + C (-1) * X ^ 9
public def minorQ_entry_7_7 : Ki := ofLadj minorQ_re_7_7 minorQ_im_7_7

@[expose] public def minorQ_re_7_8 : Polynomial ℚ := C (2) + C (1) * X ^ 2 + C (-10) * X ^ 3 + C (-13) * X ^ 4 + C (-12) * X ^ 5 + C (-12) * X ^ 6 + C (-13) * X ^ 7 + C (-10) * X ^ 8 + C (1) * X ^ 9
@[expose] public def minorQ_im_7_8 : Polynomial ℚ := C (10) + C (20) * X + C (19) * X ^ 2 + C (18) * X ^ 3 + C (17) * X ^ 4 + C (16) * X ^ 5 + C (4) * X ^ 6 + C (3) * X ^ 7 + C (2) * X ^ 8 + C (1) * X ^ 9
public def minorQ_entry_7_8 : Ki := ofLadj minorQ_re_7_8 minorQ_im_7_8

@[expose] public def minorQ_re_7_9 : Polynomial ℚ := C (11) + C (15) * X ^ 2 + C (12) * X ^ 3 + C (28) * X ^ 4 + C (22) * X ^ 5 + C (22) * X ^ 6 + C (28) * X ^ 7 + C (12) * X ^ 8 + C (15) * X ^ 9
@[expose] public def minorQ_im_7_9 : Polynomial ℚ := C (13) + C (26) * X + C (39) * X ^ 2 + C (30) * X ^ 3 + C (32) * X ^ 4 + C (12) * X ^ 5 + C (14) * X ^ 6 + C (-6) * X ^ 7 + C (-4) * X ^ 8 + C (-13) * X ^ 9
public def minorQ_entry_7_9 : Ki := ofLadj minorQ_re_7_9 minorQ_im_7_9

@[expose] public def minorQ_re_7_10 : Polynomial ℚ := C (-6) + C (2) * X ^ 2 + C (16) * X ^ 3 + C (18) * X ^ 4 + C (22) * X ^ 5 + C (22) * X ^ 6 + C (18) * X ^ 7 + C (16) * X ^ 8 + C (2) * X ^ 9
@[expose] public def minorQ_im_7_10 : Polynomial ℚ := C (6) + C (12) * X + C (18) * X ^ 2 + C (24) * X ^ 3 + C (30) * X ^ 4 + C (14) * X ^ 5 + C (-2) * X ^ 6 + C (-18) * X ^ 7 + C (-12) * X ^ 8 + C (-6) * X ^ 9
public def minorQ_entry_7_10 : Ki := ofLadj minorQ_re_7_10 minorQ_im_7_10

@[expose] public def minorQ_re_7_11 : Polynomial ℚ := C (42) + C (41) * X ^ 2 + C (2) * X ^ 3 + C (27) * X ^ 4 + C (8) * X ^ 5 + C (8) * X ^ 6 + C (27) * X ^ 7 + C (2) * X ^ 8 + C (41) * X ^ 9
@[expose] public def minorQ_im_7_11 : Polynomial ℚ := C (-6) + C (-12) * X + C (15) * X ^ 2 + C (-24) * X ^ 3 + C (25) * X ^ 4 + C (-36) * X ^ 5 + C (24) * X ^ 6 + C (-37) * X ^ 7 + C (12) * X ^ 8 + C (-27) * X ^ 9
public def minorQ_entry_7_11 : Ki := ofLadj minorQ_re_7_11 minorQ_im_7_11

@[expose] public def minorQ_re_7_12 : Polynomial ℚ := C (-60) + C (-60) * X ^ 2 + C (-8) * X ^ 3 + C (-46) * X ^ 4 + C (-21) * X ^ 5 + C (-21) * X ^ 6 + C (-46) * X ^ 7 + C (-8) * X ^ 8 + C (-60) * X ^ 9
@[expose] public def minorQ_im_7_12 : Polynomial ℚ := C (6) + C (12) * X + C (-26) * X ^ 2 + C (24) * X ^ 3 + C (-36) * X ^ 4 + C (47) * X ^ 5 + C (-35) * X ^ 6 + C (48) * X ^ 7 + C (-12) * X ^ 8 + C (38) * X ^ 9
public def minorQ_entry_7_12 : Ki := ofLadj minorQ_re_7_12 minorQ_im_7_12

@[expose] public def minorQ_re_7_13 : Polynomial ℚ := C (-8) + C (-16) * X ^ 2 + C (-4) * X ^ 3 + C (-19) * X ^ 4 + C (-12) * X ^ 5 + C (-12) * X ^ 6 + C (-19) * X ^ 7 + C (-4) * X ^ 8 + C (-16) * X ^ 9
@[expose] public def minorQ_im_7_13 : Polynomial ℚ := C (-8) + C (-16) * X + C (-24) * X ^ 2 + C (-10) * X ^ 3 + C (-29) * X ^ 4 + C (-4) * X ^ 5 + C (-12) * X ^ 6 + C (13) * X ^ 7 + C (-6) * X ^ 8 + C (8) * X ^ 9
public def minorQ_entry_7_13 : Ki := ofLadj minorQ_re_7_13 minorQ_im_7_13

@[expose] public def minorQ_re_7_14 : Polynomial ℚ := C (30) + C (26) * X ^ 2 + C (-18) * X ^ 3 + C (-8) * X ^ 4 + C (-26) * X ^ 5 + C (-26) * X ^ 6 + C (-8) * X ^ 7 + C (-18) * X ^ 8 + C (26) * X ^ 9
@[expose] public def minorQ_im_7_14 : Polynomial ℚ := C (-22) + C (-44) * X + C (-22) * X ^ 2 + C (-66) * X ^ 3 + C (-66) * X ^ 5 + C (22) * X ^ 6 + C (-44) * X ^ 7 + C (22) * X ^ 8 + C (-22) * X ^ 9
public def minorQ_entry_7_14 : Ki := ofLadj minorQ_re_7_14 minorQ_im_7_14

@[expose] public def minorQ_re_7_15 : Polynomial ℚ := C (24) + C (27) * X ^ 2 + C (6) * X ^ 3 + C (25) * X ^ 4 + C (18) * X ^ 5 + C (18) * X ^ 6 + C (25) * X ^ 7 + C (6) * X ^ 8 + C (27) * X ^ 9
@[expose] public def minorQ_im_7_15 : Polynomial ℚ := C (-8) + C (-16) * X + C (-13) * X ^ 2 + C (-32) * X ^ 3 + C (-7) * X ^ 4 + C (-26) * X ^ 5 + C (10) * X ^ 6 + C (-9) * X ^ 7 + C (16) * X ^ 8 + C (-3) * X ^ 9
public def minorQ_entry_7_15 : Ki := ofLadj minorQ_re_7_15 minorQ_im_7_15

@[expose] public def minorQ_re_7_16 : Polynomial ℚ := C (-6) * X ^ 2 + C (-16) * X ^ 3 + C (-15) * X ^ 4 + C (-29) * X ^ 5 + C (-29) * X ^ 6 + C (-15) * X ^ 7 + C (-16) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def minorQ_im_7_16 : Polynomial ℚ := C (6) + C (12) * X + C (18) * X ^ 2 + C (24) * X ^ 3 + C (19) * X ^ 4 + C (3) * X ^ 5 + C (9) * X ^ 6 + C (-7) * X ^ 7 + C (-12) * X ^ 8 + C (-6) * X ^ 9
public def minorQ_entry_7_16 : Ki := ofLadj minorQ_re_7_16 minorQ_im_7_16

@[expose] public def minorQ_re_7_17 : Polynomial ℚ := C (-16) + C (-28) * X ^ 2 + C (4) * X ^ 3 + C (-10) * X ^ 4 + C (-2) * X ^ 5 + C (-2) * X ^ 6 + C (-10) * X ^ 7 + C (4) * X ^ 8 + C (-28) * X ^ 9
@[expose] public def minorQ_im_7_17 : Polynomial ℚ := C (-20) + C (-40) * X + C (-60) * X ^ 2 + C (-36) * X ^ 3 + C (-78) * X ^ 4 + C (-10) * X ^ 5 + C (-30) * X ^ 6 + C (38) * X ^ 7 + C (-4) * X ^ 8 + C (20) * X ^ 9
public def minorQ_entry_7_17 : Ki := ofLadj minorQ_re_7_17 minorQ_im_7_17

@[expose] public def minorQ_re_7_18 : Polynomial ℚ := C (-6) + C (1) * X ^ 2 + C (15) * X ^ 3 + C (16) * X ^ 4 + C (26) * X ^ 5 + C (26) * X ^ 6 + C (16) * X ^ 7 + C (15) * X ^ 8 + C (1) * X ^ 9
@[expose] public def minorQ_im_7_18 : Polynomial ℚ := C (6) + C (12) * X + C (7) * X ^ 2 + C (13) * X ^ 3 + C (8) * X ^ 4 + C (14) * X ^ 5 + C (-2) * X ^ 6 + C (4) * X ^ 7 + C (-1) * X ^ 8 + C (5) * X ^ 9
public def minorQ_entry_7_18 : Ki := ofLadj minorQ_re_7_18 minorQ_im_7_18

@[expose] public def minorQ_re_7_19 : Polynomial ℚ := C (-2) + C (4) * X ^ 2 + C (-4) * X ^ 3 + C (-8) * X ^ 4 + C (-2) * X ^ 5 + C (-2) * X ^ 6 + C (-8) * X ^ 7 + C (-4) * X ^ 8 + C (4) * X ^ 9
@[expose] public def minorQ_im_7_19 : Polynomial ℚ := C (18) + C (36) * X + C (32) * X ^ 2 + C (28) * X ^ 3 + C (24) * X ^ 4 + C (42) * X ^ 5 + C (-6) * X ^ 6 + C (12) * X ^ 7 + C (8) * X ^ 8 + C (4) * X ^ 9
public def minorQ_entry_7_19 : Ki := ofLadj minorQ_re_7_19 minorQ_im_7_19

@[expose] public def minorQ_re_7_20 : Polynomial ℚ := C (4) + C (4) * X ^ 2 + C (-8) * X ^ 3 + C (-8) * X ^ 4 + C (-12) * X ^ 5 + C (-12) * X ^ 6 + C (-8) * X ^ 7 + C (-8) * X ^ 8 + C (4) * X ^ 9
@[expose] public def minorQ_im_7_20 : Polynomial ℚ := C (-12) + C (-24) * X + C (-36) * X ^ 2 + C (-48) * X ^ 3 + C (-16) * X ^ 4 + C (-28) * X ^ 5 + C (4) * X ^ 6 + C (-8) * X ^ 7 + C (24) * X ^ 8 + C (12) * X ^ 9
public def minorQ_entry_7_20 : Ki := ofLadj minorQ_re_7_20 minorQ_im_7_20

@[expose] public def minorQ_re_8_0 : Polynomial ℚ := C (-1) + C (9) * X ^ 2 + C (19) * X ^ 3 + C (34) * X ^ 4 + C (32) * X ^ 5 + C (32) * X ^ 6 + C (34) * X ^ 7 + C (19) * X ^ 8 + C (9) * X ^ 9
@[expose] public def minorQ_im_8_0 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_0 : Ki := ofLadj minorQ_re_8_0 minorQ_im_8_0

@[expose] public def minorQ_re_8_1 : Polynomial ℚ := C (-6) + C (-14) * X ^ 2 + C (-42) * X ^ 3 + C (-53) * X ^ 4 + C (-53) * X ^ 5 + C (-53) * X ^ 6 + C (-53) * X ^ 7 + C (-42) * X ^ 8 + C (-14) * X ^ 9
@[expose] public def minorQ_im_8_1 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_1 : Ki := ofLadj minorQ_re_8_1 minorQ_im_8_1

@[expose] public def minorQ_re_8_2 : Polynomial ℚ := C (10) + C (17) * X ^ 2 + C (21) * X ^ 3 + C (35) * X ^ 4 + C (43) * X ^ 5 + C (43) * X ^ 6 + C (35) * X ^ 7 + C (21) * X ^ 8 + C (17) * X ^ 9
@[expose] public def minorQ_im_8_2 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_2 : Ki := ofLadj minorQ_re_8_2 minorQ_im_8_2

@[expose] public def minorQ_re_8_3 : Polynomial ℚ := C (-13) + C (-11) * X ^ 2 + C (17) * X ^ 3 + C (19) * X ^ 4 + C (20) * X ^ 5 + C (20) * X ^ 6 + C (19) * X ^ 7 + C (17) * X ^ 8 + C (-11) * X ^ 9
@[expose] public def minorQ_im_8_3 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_3 : Ki := ofLadj minorQ_re_8_3 minorQ_im_8_3

@[expose] public def minorQ_re_8_4 : Polynomial ℚ := C (10) + C (-10) * X ^ 2 + C (-30) * X ^ 3 + C (-57) * X ^ 4 + C (-62) * X ^ 5 + C (-62) * X ^ 6 + C (-57) * X ^ 7 + C (-30) * X ^ 8 + C (-10) * X ^ 9
@[expose] public def minorQ_im_8_4 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_4 : Ki := ofLadj minorQ_re_8_4 minorQ_im_8_4

@[expose] public def minorQ_re_8_5 : Polynomial ℚ := C (6) + C (10) * X ^ 2 + C (-4) * X ^ 3 + C (28) * X ^ 4 + C (18) * X ^ 5 + C (18) * X ^ 6 + C (28) * X ^ 7 + C (-4) * X ^ 8 + C (10) * X ^ 9
@[expose] public def minorQ_im_8_5 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_5 : Ki := ofLadj minorQ_re_8_5 minorQ_im_8_5

@[expose] public def minorQ_re_8_6 : Polynomial ℚ := C (-4) + C (3) * X ^ 2 + C (11) * X ^ 3 + C (12) * X ^ 4 + C (9) * X ^ 5 + C (9) * X ^ 6 + C (12) * X ^ 7 + C (11) * X ^ 8 + C (3) * X ^ 9
@[expose] public def minorQ_im_8_6 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_6 : Ki := ofLadj minorQ_re_8_6 minorQ_im_8_6

@[expose] public def minorQ_re_8_7 : Polynomial ℚ := C (2) + C (-3) * X ^ 2 + C (1) * X ^ 3 + C (-10) * X ^ 5 + C (-10) * X ^ 6 + C (1) * X ^ 8 + C (-3) * X ^ 9
@[expose] public def minorQ_im_8_7 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_7 : Ki := ofLadj minorQ_re_8_7 minorQ_im_8_7

@[expose] public def minorQ_re_8_8 : Polynomial ℚ := C (1) + C (1) * X ^ 2 + C (1) * X ^ 3 + C (3) * X ^ 5 + C (3) * X ^ 6 + C (1) * X ^ 8 + C (1) * X ^ 9
@[expose] public def minorQ_im_8_8 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_8 : Ki := ofLadj minorQ_re_8_8 minorQ_im_8_8

@[expose] public def minorQ_re_8_9 : Polynomial ℚ := C (6) + C (16) * X ^ 2 + C (30) * X ^ 3 + C (44) * X ^ 4 + C (61) * X ^ 5 + C (61) * X ^ 6 + C (44) * X ^ 7 + C (30) * X ^ 8 + C (16) * X ^ 9
@[expose] public def minorQ_im_8_9 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_9 : Ki := ofLadj minorQ_re_8_9 minorQ_im_8_9

@[expose] public def minorQ_re_8_10 : Polynomial ℚ := C (-10) + C (34) * X ^ 2 + C (28) * X ^ 3 + C (40) * X ^ 4 + C (46) * X ^ 5 + C (46) * X ^ 6 + C (40) * X ^ 7 + C (28) * X ^ 8 + C (34) * X ^ 9
@[expose] public def minorQ_im_8_10 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_10 : Ki := ofLadj minorQ_re_8_10 minorQ_im_8_10

@[expose] public def minorQ_re_8_11 : Polynomial ℚ := C (32) + C (30) * X ^ 2 + C (7) * X ^ 3 + C (21) * X ^ 4 + C (14) * X ^ 5 + C (14) * X ^ 6 + C (21) * X ^ 7 + C (7) * X ^ 8 + C (30) * X ^ 9
@[expose] public def minorQ_im_8_11 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_11 : Ki := ofLadj minorQ_re_8_11 minorQ_im_8_11

@[expose] public def minorQ_re_8_12 : Polynomial ℚ := C (-53) + C (-44) * X ^ 2 + C (-16) * X ^ 3 + C (-44) * X ^ 4 + C (-29) * X ^ 5 + C (-29) * X ^ 6 + C (-44) * X ^ 7 + C (-16) * X ^ 8 + C (-44) * X ^ 9
@[expose] public def minorQ_im_8_12 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_12 : Ki := ofLadj minorQ_re_8_12 minorQ_im_8_12

@[expose] public def minorQ_re_8_13 : Polynomial ℚ := C (-6) + C (-17) * X ^ 2 + C (-17) * X ^ 3 + C (-22) * X ^ 4 + C (-29) * X ^ 5 + C (-29) * X ^ 6 + C (-22) * X ^ 7 + C (-17) * X ^ 8 + C (-17) * X ^ 9
@[expose] public def minorQ_im_8_13 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_13 : Ki := ofLadj minorQ_re_8_13 minorQ_im_8_13

@[expose] public def minorQ_re_8_14 : Polynomial ℚ := C (78) + C (62) * X ^ 2 + C (-8) * X ^ 3 + C (24) * X ^ 4 + C (-18) * X ^ 5 + C (-18) * X ^ 6 + C (24) * X ^ 7 + C (-8) * X ^ 8 + C (62) * X ^ 9
@[expose] public def minorQ_im_8_14 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_14 : Ki := ofLadj minorQ_re_8_14 minorQ_im_8_14

@[expose] public def minorQ_re_8_15 : Polynomial ℚ := C (24) + C (16) * X ^ 2 + C (-5) * X ^ 3 + C (3) * X ^ 4 + C (-4) * X ^ 5 + C (-4) * X ^ 6 + C (3) * X ^ 7 + C (-5) * X ^ 8 + C (16) * X ^ 9
@[expose] public def minorQ_im_8_15 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_15 : Ki := ofLadj minorQ_re_8_15 minorQ_im_8_15

@[expose] public def minorQ_re_8_16 : Polynomial ℚ := C (3) + C (-1) * X ^ 2 + C (3) * X ^ 3 + C (2) * X ^ 4 + C (2) * X ^ 7 + C (3) * X ^ 8 + C (-1) * X ^ 9
@[expose] public def minorQ_im_8_16 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_16 : Ki := ofLadj minorQ_re_8_16 minorQ_im_8_16

@[expose] public def minorQ_re_8_17 : Polynomial ℚ := C (-46) + C (-82) * X ^ 2 + C (-40) * X ^ 3 + C (-88) * X ^ 4 + C (-86) * X ^ 5 + C (-86) * X ^ 6 + C (-88) * X ^ 7 + C (-40) * X ^ 8 + C (-82) * X ^ 9
@[expose] public def minorQ_im_8_17 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_17 : Ki := ofLadj minorQ_re_8_17 minorQ_im_8_17

@[expose] public def minorQ_re_8_18 : Polynomial ℚ := C (-10) + C (3) * X ^ 2 + C (10) * X ^ 3 + C (16) * X ^ 4 + C (20) * X ^ 5 + C (20) * X ^ 6 + C (16) * X ^ 7 + C (10) * X ^ 8 + C (3) * X ^ 9
@[expose] public def minorQ_im_8_18 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_18 : Ki := ofLadj minorQ_re_8_18 minorQ_im_8_18

@[expose] public def minorQ_re_8_19 : Polynomial ℚ := C (-18) + C (-14) * X ^ 2 + C (4) * X ^ 3 + C (-24) * X ^ 4 + C (10) * X ^ 5 + C (10) * X ^ 6 + C (-24) * X ^ 7 + C (4) * X ^ 8 + C (-14) * X ^ 9
@[expose] public def minorQ_im_8_19 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_19 : Ki := ofLadj minorQ_re_8_19 minorQ_im_8_19

@[expose] public def minorQ_re_8_20 : Polynomial ℚ := C (20) + C (20) * X ^ 2 + C (-40) * X ^ 3 + C (-40) * X ^ 4 + C (-60) * X ^ 5 + C (-60) * X ^ 6 + C (-40) * X ^ 7 + C (-40) * X ^ 8 + C (20) * X ^ 9
@[expose] public def minorQ_im_8_20 : Polynomial ℚ := (0 : Polynomial ℚ)
public def minorQ_entry_8_20 : Ki := ofLadj minorQ_re_8_20 minorQ_im_8_20

public def minorQ : Matrix (Fin 9) (Fin 21) Ki :=
  fun i j =>
    match i.val, j.val with
    | 0, 0 => minorQ_entry_0_0
    | 0, 1 => minorQ_entry_0_1
    | 0, 2 => minorQ_entry_0_2
    | 0, 3 => minorQ_entry_0_3
    | 0, 4 => minorQ_entry_0_4
    | 0, 5 => minorQ_entry_0_5
    | 0, 6 => minorQ_entry_0_6
    | 0, 7 => minorQ_entry_0_7
    | 0, 8 => minorQ_entry_0_8
    | 0, 9 => minorQ_entry_0_9
    | 0, 10 => minorQ_entry_0_10
    | 0, 11 => minorQ_entry_0_11
    | 0, 12 => minorQ_entry_0_12
    | 0, 13 => minorQ_entry_0_13
    | 0, 14 => minorQ_entry_0_14
    | 0, 15 => minorQ_entry_0_15
    | 0, 16 => minorQ_entry_0_16
    | 0, 17 => minorQ_entry_0_17
    | 0, 18 => minorQ_entry_0_18
    | 0, 19 => minorQ_entry_0_19
    | 0, 20 => minorQ_entry_0_20
    | 1, 0 => minorQ_entry_1_0
    | 1, 1 => minorQ_entry_1_1
    | 1, 2 => minorQ_entry_1_2
    | 1, 3 => minorQ_entry_1_3
    | 1, 4 => minorQ_entry_1_4
    | 1, 5 => minorQ_entry_1_5
    | 1, 6 => minorQ_entry_1_6
    | 1, 7 => minorQ_entry_1_7
    | 1, 8 => minorQ_entry_1_8
    | 1, 9 => minorQ_entry_1_9
    | 1, 10 => minorQ_entry_1_10
    | 1, 11 => minorQ_entry_1_11
    | 1, 12 => minorQ_entry_1_12
    | 1, 13 => minorQ_entry_1_13
    | 1, 14 => minorQ_entry_1_14
    | 1, 15 => minorQ_entry_1_15
    | 1, 16 => minorQ_entry_1_16
    | 1, 17 => minorQ_entry_1_17
    | 1, 18 => minorQ_entry_1_18
    | 1, 19 => minorQ_entry_1_19
    | 1, 20 => minorQ_entry_1_20
    | 2, 0 => minorQ_entry_2_0
    | 2, 1 => minorQ_entry_2_1
    | 2, 2 => minorQ_entry_2_2
    | 2, 3 => minorQ_entry_2_3
    | 2, 4 => minorQ_entry_2_4
    | 2, 5 => minorQ_entry_2_5
    | 2, 6 => minorQ_entry_2_6
    | 2, 7 => minorQ_entry_2_7
    | 2, 8 => minorQ_entry_2_8
    | 2, 9 => minorQ_entry_2_9
    | 2, 10 => minorQ_entry_2_10
    | 2, 11 => minorQ_entry_2_11
    | 2, 12 => minorQ_entry_2_12
    | 2, 13 => minorQ_entry_2_13
    | 2, 14 => minorQ_entry_2_14
    | 2, 15 => minorQ_entry_2_15
    | 2, 16 => minorQ_entry_2_16
    | 2, 17 => minorQ_entry_2_17
    | 2, 18 => minorQ_entry_2_18
    | 2, 19 => minorQ_entry_2_19
    | 2, 20 => minorQ_entry_2_20
    | 3, 0 => minorQ_entry_3_0
    | 3, 1 => minorQ_entry_3_1
    | 3, 2 => minorQ_entry_3_2
    | 3, 3 => minorQ_entry_3_3
    | 3, 4 => minorQ_entry_3_4
    | 3, 5 => minorQ_entry_3_5
    | 3, 6 => minorQ_entry_3_6
    | 3, 7 => minorQ_entry_3_7
    | 3, 8 => minorQ_entry_3_8
    | 3, 9 => minorQ_entry_3_9
    | 3, 10 => minorQ_entry_3_10
    | 3, 11 => minorQ_entry_3_11
    | 3, 12 => minorQ_entry_3_12
    | 3, 13 => minorQ_entry_3_13
    | 3, 14 => minorQ_entry_3_14
    | 3, 15 => minorQ_entry_3_15
    | 3, 16 => minorQ_entry_3_16
    | 3, 17 => minorQ_entry_3_17
    | 3, 18 => minorQ_entry_3_18
    | 3, 19 => minorQ_entry_3_19
    | 3, 20 => minorQ_entry_3_20
    | 4, 0 => minorQ_entry_4_0
    | 4, 1 => minorQ_entry_4_1
    | 4, 2 => minorQ_entry_4_2
    | 4, 3 => minorQ_entry_4_3
    | 4, 4 => minorQ_entry_4_4
    | 4, 5 => minorQ_entry_4_5
    | 4, 6 => minorQ_entry_4_6
    | 4, 7 => minorQ_entry_4_7
    | 4, 8 => minorQ_entry_4_8
    | 4, 9 => minorQ_entry_4_9
    | 4, 10 => minorQ_entry_4_10
    | 4, 11 => minorQ_entry_4_11
    | 4, 12 => minorQ_entry_4_12
    | 4, 13 => minorQ_entry_4_13
    | 4, 14 => minorQ_entry_4_14
    | 4, 15 => minorQ_entry_4_15
    | 4, 16 => minorQ_entry_4_16
    | 4, 17 => minorQ_entry_4_17
    | 4, 18 => minorQ_entry_4_18
    | 4, 19 => minorQ_entry_4_19
    | 4, 20 => minorQ_entry_4_20
    | 5, 0 => minorQ_entry_5_0
    | 5, 1 => minorQ_entry_5_1
    | 5, 2 => minorQ_entry_5_2
    | 5, 3 => minorQ_entry_5_3
    | 5, 4 => minorQ_entry_5_4
    | 5, 5 => minorQ_entry_5_5
    | 5, 6 => minorQ_entry_5_6
    | 5, 7 => minorQ_entry_5_7
    | 5, 8 => minorQ_entry_5_8
    | 5, 9 => minorQ_entry_5_9
    | 5, 10 => minorQ_entry_5_10
    | 5, 11 => minorQ_entry_5_11
    | 5, 12 => minorQ_entry_5_12
    | 5, 13 => minorQ_entry_5_13
    | 5, 14 => minorQ_entry_5_14
    | 5, 15 => minorQ_entry_5_15
    | 5, 16 => minorQ_entry_5_16
    | 5, 17 => minorQ_entry_5_17
    | 5, 18 => minorQ_entry_5_18
    | 5, 19 => minorQ_entry_5_19
    | 5, 20 => minorQ_entry_5_20
    | 6, 0 => minorQ_entry_6_0
    | 6, 1 => minorQ_entry_6_1
    | 6, 2 => minorQ_entry_6_2
    | 6, 3 => minorQ_entry_6_3
    | 6, 4 => minorQ_entry_6_4
    | 6, 5 => minorQ_entry_6_5
    | 6, 6 => minorQ_entry_6_6
    | 6, 7 => minorQ_entry_6_7
    | 6, 8 => minorQ_entry_6_8
    | 6, 9 => minorQ_entry_6_9
    | 6, 10 => minorQ_entry_6_10
    | 6, 11 => minorQ_entry_6_11
    | 6, 12 => minorQ_entry_6_12
    | 6, 13 => minorQ_entry_6_13
    | 6, 14 => minorQ_entry_6_14
    | 6, 15 => minorQ_entry_6_15
    | 6, 16 => minorQ_entry_6_16
    | 6, 17 => minorQ_entry_6_17
    | 6, 18 => minorQ_entry_6_18
    | 6, 19 => minorQ_entry_6_19
    | 6, 20 => minorQ_entry_6_20
    | 7, 0 => minorQ_entry_7_0
    | 7, 1 => minorQ_entry_7_1
    | 7, 2 => minorQ_entry_7_2
    | 7, 3 => minorQ_entry_7_3
    | 7, 4 => minorQ_entry_7_4
    | 7, 5 => minorQ_entry_7_5
    | 7, 6 => minorQ_entry_7_6
    | 7, 7 => minorQ_entry_7_7
    | 7, 8 => minorQ_entry_7_8
    | 7, 9 => minorQ_entry_7_9
    | 7, 10 => minorQ_entry_7_10
    | 7, 11 => minorQ_entry_7_11
    | 7, 12 => minorQ_entry_7_12
    | 7, 13 => minorQ_entry_7_13
    | 7, 14 => minorQ_entry_7_14
    | 7, 15 => minorQ_entry_7_15
    | 7, 16 => minorQ_entry_7_16
    | 7, 17 => minorQ_entry_7_17
    | 7, 18 => minorQ_entry_7_18
    | 7, 19 => minorQ_entry_7_19
    | 7, 20 => minorQ_entry_7_20
    | 8, 0 => minorQ_entry_8_0
    | 8, 1 => minorQ_entry_8_1
    | 8, 2 => minorQ_entry_8_2
    | 8, 3 => minorQ_entry_8_3
    | 8, 4 => minorQ_entry_8_4
    | 8, 5 => minorQ_entry_8_5
    | 8, 6 => minorQ_entry_8_6
    | 8, 7 => minorQ_entry_8_7
    | 8, 8 => minorQ_entry_8_8
    | 8, 9 => minorQ_entry_8_9
    | 8, 10 => minorQ_entry_8_10
    | 8, 11 => minorQ_entry_8_11
    | 8, 12 => minorQ_entry_8_12
    | 8, 13 => minorQ_entry_8_13
    | 8, 14 => minorQ_entry_8_14
    | 8, 15 => minorQ_entry_8_15
    | 8, 16 => minorQ_entry_8_16
    | 8, 17 => minorQ_entry_8_17
    | 8, 18 => minorQ_entry_8_18
    | 8, 19 => minorQ_entry_8_19
    | 8, 20 => minorQ_entry_8_20
    | _, _ => minorQ_entry_0_0

end V14Formalization.D12SigmaPlusSegreCore
