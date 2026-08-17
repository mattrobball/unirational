/-
Plus Segre span matrix spanV.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore

@[expose] public def spanV_re_0_0 : Polynomial ℚ := C (16) + C (-64) * X ^ 2 + C (-124) * X ^ 3 + C (-200) * X ^ 4 + C (-236) * X ^ 5 + C (-236) * X ^ 6 + C (-200) * X ^ 7 + C (-124) * X ^ 8 + C (-64) * X ^ 9
@[expose] public def spanV_im_0_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_0 : Ki := ofLadj spanV_re_0_0 spanV_im_0_0

@[expose] public def spanV_re_0_1 : Polynomial ℚ := C (-68) * X ^ 2 + C (-112) * X ^ 3 + C (-180) * X ^ 4 + C (-212) * X ^ 5 + C (-212) * X ^ 6 + C (-180) * X ^ 7 + C (-112) * X ^ 8 + C (-68) * X ^ 9
@[expose] public def spanV_im_0_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_1 : Ki := ofLadj spanV_re_0_1 spanV_im_0_1

@[expose] public def spanV_re_0_2 : Polynomial ℚ := C (20) + C (-20) * X ^ 3 + C (-24) * X ^ 4 + C (-32) * X ^ 5 + C (-32) * X ^ 6 + C (-24) * X ^ 7 + C (-20) * X ^ 8
@[expose] public def spanV_im_0_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_2 : Ki := ofLadj spanV_re_0_2 spanV_im_0_2

@[expose] public def spanV_re_0_3 : Polynomial ℚ := C (-20) + C (4) * X ^ 2 + C (56) * X ^ 3 + C (68) * X ^ 4 + C (80) * X ^ 5 + C (80) * X ^ 6 + C (68) * X ^ 7 + C (56) * X ^ 8 + C (4) * X ^ 9
@[expose] public def spanV_im_0_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_3 : Ki := ofLadj spanV_re_0_3 spanV_im_0_3

@[expose] public def spanV_re_0_4 : Polynomial ℚ := C (4) + C (108) * X ^ 2 + C (204) * X ^ 3 + C (316) * X ^ 4 + C (360) * X ^ 5 + C (360) * X ^ 6 + C (316) * X ^ 7 + C (204) * X ^ 8 + C (108) * X ^ 9
@[expose] public def spanV_im_0_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_4 : Ki := ofLadj spanV_re_0_4 spanV_im_0_4

@[expose] public def spanV_re_0_5 : Polynomial ℚ := C (8) + C (64) * X ^ 2 + C (112) * X ^ 3 + C (188) * X ^ 4 + C (204) * X ^ 5 + C (204) * X ^ 6 + C (188) * X ^ 7 + C (112) * X ^ 8 + C (64) * X ^ 9
@[expose] public def spanV_im_0_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_5 : Ki := ofLadj spanV_re_0_5 spanV_im_0_5

@[expose] public def spanV_re_0_6 : Polynomial ℚ := C (-4) + C (28) * X ^ 2 + C (72) * X ^ 3 + C (108) * X ^ 4 + C (124) * X ^ 5 + C (124) * X ^ 6 + C (108) * X ^ 7 + C (72) * X ^ 8 + C (28) * X ^ 9
@[expose] public def spanV_im_0_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_6 : Ki := ofLadj spanV_re_0_6 spanV_im_0_6

@[expose] public def spanV_re_0_7 : Polynomial ℚ := C (-40) + C (24) * X ^ 2 + C (96) * X ^ 3 + C (132) * X ^ 4 + C (164) * X ^ 5 + C (164) * X ^ 6 + C (132) * X ^ 7 + C (96) * X ^ 8 + C (24) * X ^ 9
@[expose] public def spanV_im_0_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_7 : Ki := ofLadj spanV_re_0_7 spanV_im_0_7

@[expose] public def spanV_re_0_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_0_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_8 : Ki := ofLadj spanV_re_0_8 spanV_im_0_8

@[expose] public def spanV_re_0_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_0_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_9 : Ki := ofLadj spanV_re_0_9 spanV_im_0_9

@[expose] public def spanV_re_0_10 : Polynomial ℚ := C (-8) + C (-8) * X ^ 2 + C (16) * X ^ 3 + C (16) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (16) * X ^ 7 + C (16) * X ^ 8 + C (-8) * X ^ 9
@[expose] public def spanV_im_0_10 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_10 : Ki := ofLadj spanV_re_0_10 spanV_im_0_10

@[expose] public def spanV_re_0_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_0_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_11 : Ki := ofLadj spanV_re_0_11 spanV_im_0_11

@[expose] public def spanV_re_0_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_0_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_12 : Ki := ofLadj spanV_re_0_12 spanV_im_0_12

@[expose] public def spanV_re_0_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_0_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_13 : Ki := ofLadj spanV_re_0_13 spanV_im_0_13

@[expose] public def spanV_re_0_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_0_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_0_14 : Ki := ofLadj spanV_re_0_14 spanV_im_0_14

@[expose] public def spanV_re_1_0 : Polynomial ℚ := C (-56) + C (48) * X ^ 2 + C (156) * X ^ 3 + C (236) * X ^ 4 + C (292) * X ^ 5 + C (292) * X ^ 6 + C (236) * X ^ 7 + C (156) * X ^ 8 + C (48) * X ^ 9
@[expose] public def spanV_im_1_0 : Polynomial ℚ := C (-76) + C (-152) * X + C (-228) * X ^ 2 + C (-216) * X ^ 3 + C (-204) * X ^ 4 + C (-104) * X ^ 5 + C (-48) * X ^ 6 + C (52) * X ^ 7 + C (64) * X ^ 8 + C (76) * X ^ 9
@[expose] public def spanV_entry_1_0 : Ki := ofLadj spanV_re_1_0 spanV_im_1_0

@[expose] public def spanV_re_1_1 : Polynomial ℚ := C (-40) + C (52) * X ^ 2 + C (144) * X ^ 3 + C (216) * X ^ 4 + C (268) * X ^ 5 + C (268) * X ^ 6 + C (216) * X ^ 7 + C (144) * X ^ 8 + C (52) * X ^ 9
@[expose] public def spanV_im_1_1 : Polynomial ℚ := C (-76) + C (-152) * X + C (-228) * X ^ 2 + C (-216) * X ^ 3 + C (-204) * X ^ 4 + C (-104) * X ^ 5 + C (-48) * X ^ 6 + C (52) * X ^ 7 + C (64) * X ^ 8 + C (76) * X ^ 9
@[expose] public def spanV_entry_1_1 : Ki := ofLadj spanV_re_1_1 spanV_im_1_1

@[expose] public def spanV_re_1_2 : Polynomial ℚ := C (4) + C (20) * X ^ 2 + C (28) * X ^ 3 + C (52) * X ^ 4 + C (52) * X ^ 5 + C (52) * X ^ 6 + C (52) * X ^ 7 + C (28) * X ^ 8 + C (20) * X ^ 9
@[expose] public def spanV_im_1_2 : Polynomial ℚ := C (-12) + C (-24) * X + C (-36) * X ^ 2 + C (-48) * X ^ 3 + C (-16) * X ^ 4 + C (-28) * X ^ 5 + C (4) * X ^ 6 + C (-8) * X ^ 7 + C (24) * X ^ 8 + C (12) * X ^ 9
@[expose] public def spanV_entry_1_2 : Ki := ofLadj spanV_re_1_2 spanV_im_1_2

@[expose] public def spanV_re_1_3 : Polynomial ℚ := C (4) + C (-52) * X ^ 2 + C (-108) * X ^ 3 + C (-164) * X ^ 4 + C (-184) * X ^ 5 + C (-184) * X ^ 6 + C (-164) * X ^ 7 + C (-108) * X ^ 8 + C (-52) * X ^ 9
@[expose] public def spanV_im_1_3 : Polynomial ℚ := C (60) + C (120) * X + C (136) * X ^ 2 + C (152) * X ^ 3 + C (124) * X ^ 4 + C (96) * X ^ 5 + C (24) * X ^ 6 + C (-4) * X ^ 7 + C (-32) * X ^ 8 + C (-16) * X ^ 9
@[expose] public def spanV_entry_1_3 : Ki := ofLadj spanV_re_1_3 spanV_im_1_3

@[expose] public def spanV_re_1_4 : Polynomial ℚ := C (40) + C (-100) * X ^ 2 + C (-244) * X ^ 3 + C (-376) * X ^ 4 + C (-444) * X ^ 5 + C (-444) * X ^ 6 + C (-376) * X ^ 7 + C (-244) * X ^ 8 + C (-100) * X ^ 9
@[expose] public def spanV_im_1_4 : Polynomial ℚ := C (136) + C (272) * X + C (364) * X ^ 2 + C (368) * X ^ 3 + C (328) * X ^ 4 + C (200) * X ^ 5 + C (72) * X ^ 6 + C (-56) * X ^ 7 + C (-96) * X ^ 8 + C (-92) * X ^ 9
@[expose] public def spanV_entry_1_4 : Ki := ofLadj spanV_re_1_4 spanV_im_1_4

@[expose] public def spanV_re_1_5 : Polynomial ℚ := C (64) + C (-16) * X ^ 2 + C (-116) * X ^ 3 + C (-168) * X ^ 4 + C (-216) * X ^ 5 + C (-216) * X ^ 6 + C (-168) * X ^ 7 + C (-116) * X ^ 8 + C (-16) * X ^ 9
@[expose] public def spanV_im_1_5 : Polynomial ℚ := C (64) + C (128) * X + C (192) * X ^ 2 + C (168) * X ^ 3 + C (188) * X ^ 4 + C (76) * X ^ 5 + C (52) * X ^ 6 + C (-60) * X ^ 7 + C (-40) * X ^ 8 + C (-64) * X ^ 9
@[expose] public def spanV_entry_1_5 : Ki := ofLadj spanV_re_1_5 spanV_im_1_5

@[expose] public def spanV_re_1_6 : Polynomial ℚ := C (-8) + C (-56) * X ^ 2 + C (-96) * X ^ 3 + C (-152) * X ^ 4 + C (-176) * X ^ 5 + C (-176) * X ^ 6 + C (-152) * X ^ 7 + C (-96) * X ^ 8 + C (-56) * X ^ 9
@[expose] public def spanV_im_1_6 : Polynomial ℚ := C (60) + C (120) * X + C (136) * X ^ 2 + C (152) * X ^ 3 + C (124) * X ^ 4 + C (96) * X ^ 5 + C (24) * X ^ 6 + C (-4) * X ^ 7 + C (-32) * X ^ 8 + C (-16) * X ^ 9
@[expose] public def spanV_entry_1_6 : Ki := ofLadj spanV_re_1_6 spanV_im_1_6

@[expose] public def spanV_re_1_7 : Polynomial ℚ := C (4) + C (-72) * X ^ 2 + C (-128) * X ^ 3 + C (-204) * X ^ 4 + C (-236) * X ^ 5 + C (-236) * X ^ 6 + C (-204) * X ^ 7 + C (-128) * X ^ 8 + C (-72) * X ^ 9
@[expose] public def spanV_im_1_7 : Polynomial ℚ := C (72) + C (144) * X + C (172) * X ^ 2 + C (200) * X ^ 3 + C (140) * X ^ 4 + C (124) * X ^ 5 + C (20) * X ^ 6 + C (4) * X ^ 7 + C (-56) * X ^ 8 + C (-28) * X ^ 9
@[expose] public def spanV_entry_1_7 : Ki := ofLadj spanV_re_1_7 spanV_im_1_7

@[expose] public def spanV_re_1_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_1_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_1_8 : Ki := ofLadj spanV_re_1_8 spanV_im_1_8

@[expose] public def spanV_re_1_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_1_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_1_9 : Ki := ofLadj spanV_re_1_9 spanV_im_1_9

@[expose] public def spanV_re_1_10 : Polynomial ℚ := C (8) + C (8) * X ^ 2 + C (-16) * X ^ 3 + C (-16) * X ^ 4 + C (-24) * X ^ 5 + C (-24) * X ^ 6 + C (-16) * X ^ 7 + C (-16) * X ^ 8 + C (8) * X ^ 9
@[expose] public def spanV_im_1_10 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_1_10 : Ki := ofLadj spanV_re_1_10 spanV_im_1_10

@[expose] public def spanV_re_1_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_1_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_1_11 : Ki := ofLadj spanV_re_1_11 spanV_im_1_11

@[expose] public def spanV_re_1_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_1_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_1_12 : Ki := ofLadj spanV_re_1_12 spanV_im_1_12

@[expose] public def spanV_re_1_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_1_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_1_13 : Ki := ofLadj spanV_re_1_13 spanV_im_1_13

@[expose] public def spanV_re_1_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_1_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_1_14 : Ki := ofLadj spanV_re_1_14 spanV_im_1_14

@[expose] public def spanV_re_2_0 : Polynomial ℚ := C (8) + C (-44) * X ^ 2 + C (-90) * X ^ 3 + C (-142) * X ^ 4 + C (-168) * X ^ 5 + C (-168) * X ^ 6 + C (-142) * X ^ 7 + C (-90) * X ^ 8 + C (-44) * X ^ 9
@[expose] public def spanV_im_2_0 : Polynomial ℚ := C (88) + C (176) * X + C (220) * X ^ 2 + C (242) * X ^ 3 + C (198) * X ^ 4 + C (132) * X ^ 5 + C (44) * X ^ 6 + C (-22) * X ^ 7 + C (-66) * X ^ 8 + C (-44) * X ^ 9
@[expose] public def spanV_entry_2_0 : Ki := ofLadj spanV_re_2_0 spanV_im_2_0

@[expose] public def spanV_re_2_1 : Polynomial ℚ := C (-46) * X ^ 2 + C (-84) * X ^ 3 + C (-132) * X ^ 4 + C (-156) * X ^ 5 + C (-156) * X ^ 6 + C (-132) * X ^ 7 + C (-84) * X ^ 8 + C (-46) * X ^ 9
@[expose] public def spanV_im_2_1 : Polynomial ℚ := C (68) + C (136) * X + C (182) * X ^ 2 + C (184) * X ^ 3 + C (164) * X ^ 4 + C (100) * X ^ 5 + C (36) * X ^ 6 + C (-28) * X ^ 7 + C (-48) * X ^ 8 + C (-46) * X ^ 9
@[expose] public def spanV_entry_2_1 : Ki := ofLadj spanV_re_2_1 spanV_im_2_1

@[expose] public def spanV_re_2_2 : Polynomial ℚ := C (6) + C (2) * X ^ 2 + C (-16) * X ^ 3 + C (-20) * X ^ 4 + C (-24) * X ^ 5 + C (-24) * X ^ 6 + C (-20) * X ^ 7 + C (-16) * X ^ 8 + C (2) * X ^ 9
@[expose] public def spanV_im_2_2 : Polynomial ℚ := C (10) + C (20) * X + C (30) * X ^ 2 + C (40) * X ^ 3 + C (28) * X ^ 4 + C (16) * X ^ 5 + C (4) * X ^ 6 + C (-8) * X ^ 7 + C (-20) * X ^ 8 + C (-10) * X ^ 9
@[expose] public def spanV_entry_2_2 : Ki := ofLadj spanV_re_2_2 spanV_im_2_2

@[expose] public def spanV_re_2_3 : Polynomial ℚ := C (-10) + C (22) * X ^ 2 + C (38) * X ^ 3 + C (60) * X ^ 4 + C (72) * X ^ 5 + C (72) * X ^ 6 + C (60) * X ^ 7 + C (38) * X ^ 8 + C (22) * X ^ 9
@[expose] public def spanV_im_2_3 : Polynomial ℚ := C (-30) + C (-60) * X + C (-90) * X ^ 2 + C (-98) * X ^ 3 + C (-84) * X ^ 4 + C (-48) * X ^ 5 + C (-12) * X ^ 6 + C (24) * X ^ 7 + C (38) * X ^ 8 + C (30) * X ^ 9
@[expose] public def spanV_entry_2_3 : Ki := ofLadj spanV_re_2_3 spanV_im_2_3

@[expose] public def spanV_re_2_4 : Polynomial ℚ := C (-16) + C (66) * X ^ 2 + C (148) * X ^ 3 + C (226) * X ^ 4 + C (272) * X ^ 5 + C (272) * X ^ 6 + C (226) * X ^ 7 + C (148) * X ^ 8 + C (66) * X ^ 9
@[expose] public def spanV_im_2_4 : Polynomial ℚ := C (-116) + C (-232) * X + C (-326) * X ^ 2 + C (-332) * X ^ 3 + C (-294) * X ^ 4 + C (-168) * X ^ 5 + C (-64) * X ^ 6 + C (62) * X ^ 7 + C (100) * X ^ 8 + C (94) * X ^ 9
@[expose] public def spanV_entry_2_4 : Ki := ofLadj spanV_re_2_4 spanV_im_2_4

@[expose] public def spanV_re_2_5 : Polynomial ℚ := C (6) + C (48) * X ^ 2 + C (62) * X ^ 3 + C (108) * X ^ 4 + C (120) * X ^ 5 + C (120) * X ^ 6 + C (108) * X ^ 7 + C (62) * X ^ 8 + C (48) * X ^ 9
@[expose] public def spanV_im_2_5 : Polynomial ℚ := C (-58) + C (-116) * X + C (-152) * X ^ 2 + C (-166) * X ^ 3 + C (-136) * X ^ 4 + C (-84) * X ^ 5 + C (-32) * X ^ 6 + C (20) * X ^ 7 + C (50) * X ^ 8 + C (36) * X ^ 9
@[expose] public def spanV_entry_2_5 : Ki := ofLadj spanV_re_2_5 spanV_im_2_5

@[expose] public def spanV_re_2_6 : Polynomial ℚ := C (-10) + C (22) * X ^ 2 + C (48) * X ^ 3 + C (74) * X ^ 4 + C (92) * X ^ 5 + C (92) * X ^ 6 + C (74) * X ^ 7 + C (48) * X ^ 8 + C (22) * X ^ 9
@[expose] public def spanV_im_2_6 : Polynomial ℚ := C (-38) + C (-76) * X + C (-114) * X ^ 2 + C (-108) * X ^ 3 + C (-102) * X ^ 4 + C (-52) * X ^ 5 + C (-24) * X ^ 6 + C (26) * X ^ 7 + C (32) * X ^ 8 + C (38) * X ^ 9
@[expose] public def spanV_entry_2_6 : Ki := ofLadj spanV_re_2_6 spanV_im_2_6

@[expose] public def spanV_re_2_7 : Polynomial ℚ := C (-24) + C (18) * X ^ 2 + C (66) * X ^ 3 + C (94) * X ^ 4 + C (120) * X ^ 5 + C (120) * X ^ 6 + C (94) * X ^ 7 + C (66) * X ^ 8 + C (18) * X ^ 9
@[expose] public def spanV_im_2_7 : Polynomial ℚ := C (-60) + C (-120) * X + C (-158) * X ^ 2 + C (-174) * X ^ 3 + C (-146) * X ^ 4 + C (-96) * X ^ 5 + C (-24) * X ^ 6 + C (26) * X ^ 7 + C (54) * X ^ 8 + C (38) * X ^ 9
@[expose] public def spanV_entry_2_7 : Ki := ofLadj spanV_re_2_7 spanV_im_2_7

@[expose] public def spanV_re_2_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_2_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_2_8 : Ki := ofLadj spanV_re_2_8 spanV_im_2_8

@[expose] public def spanV_re_2_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_2_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_2_9 : Ki := ofLadj spanV_re_2_9 spanV_im_2_9

@[expose] public def spanV_re_2_10 : Polynomial ℚ := C (-4) + C (-4) * X ^ 2 + C (8) * X ^ 3 + C (8) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (8) * X ^ 7 + C (8) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def spanV_im_2_10 : Polynomial ℚ := C (-12) + C (-24) * X + C (-36) * X ^ 2 + C (-48) * X ^ 3 + C (-16) * X ^ 4 + C (-28) * X ^ 5 + C (4) * X ^ 6 + C (-8) * X ^ 7 + C (24) * X ^ 8 + C (12) * X ^ 9
@[expose] public def spanV_entry_2_10 : Ki := ofLadj spanV_re_2_10 spanV_im_2_10

@[expose] public def spanV_re_2_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_2_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_2_11 : Ki := ofLadj spanV_re_2_11 spanV_im_2_11

@[expose] public def spanV_re_2_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_2_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_2_12 : Ki := ofLadj spanV_re_2_12 spanV_im_2_12

@[expose] public def spanV_re_2_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_2_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_2_13 : Ki := ofLadj spanV_re_2_13 spanV_im_2_13

@[expose] public def spanV_re_2_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_2_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_2_14 : Ki := ofLadj spanV_re_2_14 spanV_im_2_14

@[expose] public def spanV_re_3_0 : Polynomial ℚ := C (-56) + C (48) * X ^ 2 + C (156) * X ^ 3 + C (236) * X ^ 4 + C (292) * X ^ 5 + C (292) * X ^ 6 + C (236) * X ^ 7 + C (156) * X ^ 8 + C (48) * X ^ 9
@[expose] public def spanV_im_3_0 : Polynomial ℚ := C (76) + C (152) * X + C (228) * X ^ 2 + C (216) * X ^ 3 + C (204) * X ^ 4 + C (104) * X ^ 5 + C (48) * X ^ 6 + C (-52) * X ^ 7 + C (-64) * X ^ 8 + C (-76) * X ^ 9
@[expose] public def spanV_entry_3_0 : Ki := ofLadj spanV_re_3_0 spanV_im_3_0

@[expose] public def spanV_re_3_1 : Polynomial ℚ := C (-40) + C (52) * X ^ 2 + C (144) * X ^ 3 + C (216) * X ^ 4 + C (268) * X ^ 5 + C (268) * X ^ 6 + C (216) * X ^ 7 + C (144) * X ^ 8 + C (52) * X ^ 9
@[expose] public def spanV_im_3_1 : Polynomial ℚ := C (76) + C (152) * X + C (228) * X ^ 2 + C (216) * X ^ 3 + C (204) * X ^ 4 + C (104) * X ^ 5 + C (48) * X ^ 6 + C (-52) * X ^ 7 + C (-64) * X ^ 8 + C (-76) * X ^ 9
@[expose] public def spanV_entry_3_1 : Ki := ofLadj spanV_re_3_1 spanV_im_3_1

@[expose] public def spanV_re_3_2 : Polynomial ℚ := C (4) + C (20) * X ^ 2 + C (28) * X ^ 3 + C (52) * X ^ 4 + C (52) * X ^ 5 + C (52) * X ^ 6 + C (52) * X ^ 7 + C (28) * X ^ 8 + C (20) * X ^ 9
@[expose] public def spanV_im_3_2 : Polynomial ℚ := C (12) + C (24) * X + C (36) * X ^ 2 + C (48) * X ^ 3 + C (16) * X ^ 4 + C (28) * X ^ 5 + C (-4) * X ^ 6 + C (8) * X ^ 7 + C (-24) * X ^ 8 + C (-12) * X ^ 9
@[expose] public def spanV_entry_3_2 : Ki := ofLadj spanV_re_3_2 spanV_im_3_2

@[expose] public def spanV_re_3_3 : Polynomial ℚ := C (4) + C (-52) * X ^ 2 + C (-108) * X ^ 3 + C (-164) * X ^ 4 + C (-184) * X ^ 5 + C (-184) * X ^ 6 + C (-164) * X ^ 7 + C (-108) * X ^ 8 + C (-52) * X ^ 9
@[expose] public def spanV_im_3_3 : Polynomial ℚ := C (-60) + C (-120) * X + C (-136) * X ^ 2 + C (-152) * X ^ 3 + C (-124) * X ^ 4 + C (-96) * X ^ 5 + C (-24) * X ^ 6 + C (4) * X ^ 7 + C (32) * X ^ 8 + C (16) * X ^ 9
@[expose] public def spanV_entry_3_3 : Ki := ofLadj spanV_re_3_3 spanV_im_3_3

@[expose] public def spanV_re_3_4 : Polynomial ℚ := C (40) + C (-100) * X ^ 2 + C (-244) * X ^ 3 + C (-376) * X ^ 4 + C (-444) * X ^ 5 + C (-444) * X ^ 6 + C (-376) * X ^ 7 + C (-244) * X ^ 8 + C (-100) * X ^ 9
@[expose] public def spanV_im_3_4 : Polynomial ℚ := C (-136) + C (-272) * X + C (-364) * X ^ 2 + C (-368) * X ^ 3 + C (-328) * X ^ 4 + C (-200) * X ^ 5 + C (-72) * X ^ 6 + C (56) * X ^ 7 + C (96) * X ^ 8 + C (92) * X ^ 9
@[expose] public def spanV_entry_3_4 : Ki := ofLadj spanV_re_3_4 spanV_im_3_4

@[expose] public def spanV_re_3_5 : Polynomial ℚ := C (64) + C (-16) * X ^ 2 + C (-116) * X ^ 3 + C (-168) * X ^ 4 + C (-216) * X ^ 5 + C (-216) * X ^ 6 + C (-168) * X ^ 7 + C (-116) * X ^ 8 + C (-16) * X ^ 9
@[expose] public def spanV_im_3_5 : Polynomial ℚ := C (-64) + C (-128) * X + C (-192) * X ^ 2 + C (-168) * X ^ 3 + C (-188) * X ^ 4 + C (-76) * X ^ 5 + C (-52) * X ^ 6 + C (60) * X ^ 7 + C (40) * X ^ 8 + C (64) * X ^ 9
@[expose] public def spanV_entry_3_5 : Ki := ofLadj spanV_re_3_5 spanV_im_3_5

@[expose] public def spanV_re_3_6 : Polynomial ℚ := C (-8) + C (-56) * X ^ 2 + C (-96) * X ^ 3 + C (-152) * X ^ 4 + C (-176) * X ^ 5 + C (-176) * X ^ 6 + C (-152) * X ^ 7 + C (-96) * X ^ 8 + C (-56) * X ^ 9
@[expose] public def spanV_im_3_6 : Polynomial ℚ := C (-60) + C (-120) * X + C (-136) * X ^ 2 + C (-152) * X ^ 3 + C (-124) * X ^ 4 + C (-96) * X ^ 5 + C (-24) * X ^ 6 + C (4) * X ^ 7 + C (32) * X ^ 8 + C (16) * X ^ 9
@[expose] public def spanV_entry_3_6 : Ki := ofLadj spanV_re_3_6 spanV_im_3_6

@[expose] public def spanV_re_3_7 : Polynomial ℚ := C (4) + C (-72) * X ^ 2 + C (-128) * X ^ 3 + C (-204) * X ^ 4 + C (-236) * X ^ 5 + C (-236) * X ^ 6 + C (-204) * X ^ 7 + C (-128) * X ^ 8 + C (-72) * X ^ 9
@[expose] public def spanV_im_3_7 : Polynomial ℚ := C (-72) + C (-144) * X + C (-172) * X ^ 2 + C (-200) * X ^ 3 + C (-140) * X ^ 4 + C (-124) * X ^ 5 + C (-20) * X ^ 6 + C (-4) * X ^ 7 + C (56) * X ^ 8 + C (28) * X ^ 9
@[expose] public def spanV_entry_3_7 : Ki := ofLadj spanV_re_3_7 spanV_im_3_7

@[expose] public def spanV_re_3_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_3_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_3_8 : Ki := ofLadj spanV_re_3_8 spanV_im_3_8

@[expose] public def spanV_re_3_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_3_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_3_9 : Ki := ofLadj spanV_re_3_9 spanV_im_3_9

@[expose] public def spanV_re_3_10 : Polynomial ℚ := C (8) + C (8) * X ^ 2 + C (-16) * X ^ 3 + C (-16) * X ^ 4 + C (-24) * X ^ 5 + C (-24) * X ^ 6 + C (-16) * X ^ 7 + C (-16) * X ^ 8 + C (8) * X ^ 9
@[expose] public def spanV_im_3_10 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_3_10 : Ki := ofLadj spanV_re_3_10 spanV_im_3_10

@[expose] public def spanV_re_3_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_3_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_3_11 : Ki := ofLadj spanV_re_3_11 spanV_im_3_11

@[expose] public def spanV_re_3_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_3_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_3_12 : Ki := ofLadj spanV_re_3_12 spanV_im_3_12

@[expose] public def spanV_re_3_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_3_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_3_13 : Ki := ofLadj spanV_re_3_13 spanV_im_3_13

@[expose] public def spanV_re_3_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_3_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_3_14 : Ki := ofLadj spanV_re_3_14 spanV_im_3_14

@[expose] public def spanV_re_4_0 : Polynomial ℚ := C (48) + C (28) * X ^ 2 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (28) * X ^ 9
@[expose] public def spanV_im_4_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_0 : Ki := ofLadj spanV_re_4_0 spanV_im_4_0

@[expose] public def spanV_re_4_1 : Polynomial ℚ := C (24) + C (12) * X ^ 2 + C (-8) * X ^ 3 + C (-8) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (-8) * X ^ 7 + C (-8) * X ^ 8 + C (12) * X ^ 9
@[expose] public def spanV_im_4_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_1 : Ki := ofLadj spanV_re_4_1 spanV_im_4_1

@[expose] public def spanV_re_4_2 : Polynomial ℚ := C (-8) + C (8) * X ^ 3 + C (-8) * X ^ 4 + C (4) * X ^ 5 + C (4) * X ^ 6 + C (-8) * X ^ 7 + C (8) * X ^ 8
@[expose] public def spanV_im_4_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_2 : Ki := ofLadj spanV_re_4_2 spanV_im_4_2

@[expose] public def spanV_re_4_3 : Polynomial ℚ := C (16) + C (24) * X ^ 2 + C (8) * X ^ 3 + C (20) * X ^ 4 + C (28) * X ^ 5 + C (28) * X ^ 6 + C (20) * X ^ 7 + C (8) * X ^ 8 + C (24) * X ^ 9
@[expose] public def spanV_im_4_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_3 : Ki := ofLadj spanV_re_4_3 spanV_im_4_3

@[expose] public def spanV_re_4_4 : Polynomial ℚ := C (-4) + C (8) * X ^ 2 + C (8) * X ^ 3 + C (24) * X ^ 4 + C (28) * X ^ 5 + C (28) * X ^ 6 + C (24) * X ^ 7 + C (8) * X ^ 8 + C (8) * X ^ 9
@[expose] public def spanV_im_4_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_4 : Ki := ofLadj spanV_re_4_4 spanV_im_4_4

@[expose] public def spanV_re_4_5 : Polynomial ℚ := C (-60) + C (-40) * X ^ 2 + C (-4) * X ^ 3 + C (-24) * X ^ 4 + C (-12) * X ^ 5 + C (-12) * X ^ 6 + C (-24) * X ^ 7 + C (-4) * X ^ 8 + C (-40) * X ^ 9
@[expose] public def spanV_im_4_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_5 : Ki := ofLadj spanV_re_4_5 spanV_im_4_5

@[expose] public def spanV_re_4_6 : Polynomial ℚ := C (32) + C (20) * X ^ 2 + C (-12) * X ^ 3 + C (-16) * X ^ 4 + C (-8) * X ^ 5 + C (-8) * X ^ 6 + C (-16) * X ^ 7 + C (-12) * X ^ 8 + C (20) * X ^ 9
@[expose] public def spanV_im_4_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_6 : Ki := ofLadj spanV_re_4_6 spanV_im_4_6

@[expose] public def spanV_re_4_7 : Polynomial ℚ := C (44) + C (56) * X ^ 2 + C (28) * X ^ 3 + C (64) * X ^ 4 + C (72) * X ^ 5 + C (72) * X ^ 6 + C (64) * X ^ 7 + C (28) * X ^ 8 + C (56) * X ^ 9
@[expose] public def spanV_im_4_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_7 : Ki := ofLadj spanV_re_4_7 spanV_im_4_7

@[expose] public def spanV_re_4_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_4_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_8 : Ki := ofLadj spanV_re_4_8 spanV_im_4_8

@[expose] public def spanV_re_4_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_4_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_9 : Ki := ofLadj spanV_re_4_9 spanV_im_4_9

@[expose] public def spanV_re_4_10 : Polynomial ℚ := C (-8) + C (-8) * X ^ 2 + C (16) * X ^ 3 + C (16) * X ^ 4 + C (24) * X ^ 5 + C (24) * X ^ 6 + C (16) * X ^ 7 + C (16) * X ^ 8 + C (-8) * X ^ 9
@[expose] public def spanV_im_4_10 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_10 : Ki := ofLadj spanV_re_4_10 spanV_im_4_10

@[expose] public def spanV_re_4_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_4_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_11 : Ki := ofLadj spanV_re_4_11 spanV_im_4_11

@[expose] public def spanV_re_4_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_4_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_12 : Ki := ofLadj spanV_re_4_12 spanV_im_4_12

@[expose] public def spanV_re_4_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_4_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_13 : Ki := ofLadj spanV_re_4_13 spanV_im_4_13

@[expose] public def spanV_re_4_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_4_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_4_14 : Ki := ofLadj spanV_re_4_14 spanV_im_4_14

@[expose] public def spanV_re_5_0 : Polynomial ℚ := C (-14) + C (-38) * X ^ 2 + C (-66) * X ^ 3 + C (-96) * X ^ 4 + C (-112) * X ^ 5 + C (-112) * X ^ 6 + C (-96) * X ^ 7 + C (-66) * X ^ 8 + C (-38) * X ^ 9
@[expose] public def spanV_im_5_0 : Polynomial ℚ := C (-50) + C (-100) * X + C (-106) * X ^ 2 + C (-134) * X ^ 3 + C (-96) * X ^ 4 + C (-80) * X ^ 5 + C (-20) * X ^ 6 + C (-4) * X ^ 7 + C (34) * X ^ 8 + C (6) * X ^ 9
@[expose] public def spanV_entry_5_0 : Ki := ofLadj spanV_re_5_0 spanV_im_5_0

@[expose] public def spanV_re_5_1 : Polynomial ℚ := C (-12) + C (-38) * X ^ 2 + C (-56) * X ^ 3 + C (-86) * X ^ 4 + C (-100) * X ^ 5 + C (-100) * X ^ 6 + C (-86) * X ^ 7 + C (-56) * X ^ 8 + C (-38) * X ^ 9
@[expose] public def spanV_im_5_1 : Polynomial ℚ := C (-40) + C (-80) * X + C (-98) * X ^ 2 + C (-116) * X ^ 3 + C (-90) * X ^ 4 + C (-64) * X ^ 5 + C (-16) * X ^ 6 + C (10) * X ^ 7 + C (36) * X ^ 8 + C (18) * X ^ 9
@[expose] public def spanV_entry_5_1 : Ki := ofLadj spanV_re_5_1 spanV_im_5_1

@[expose] public def spanV_re_5_2 : Polynomial ℚ := C (10) + C (10) * X ^ 2 + C (-16) * X ^ 3 + C (-10) * X ^ 4 + C (-22) * X ^ 5 + C (-22) * X ^ 6 + C (-10) * X ^ 7 + C (-16) * X ^ 8 + C (10) * X ^ 9
@[expose] public def spanV_im_5_2 : Polynomial ℚ := C (-2) + C (-4) * X + C (-6) * X ^ 2 + C (-8) * X ^ 3 + C (-10) * X ^ 4 + C (10) * X ^ 5 + C (-14) * X ^ 6 + C (6) * X ^ 7 + C (4) * X ^ 8 + C (2) * X ^ 9
@[expose] public def spanV_entry_5_2 : Ki := ofLadj spanV_re_5_2 spanV_im_5_2

@[expose] public def spanV_re_5_3 : Polynomial ℚ := C (-8) + C (12) * X ^ 2 + C (30) * X ^ 3 + C (52) * X ^ 4 + C (64) * X ^ 5 + C (64) * X ^ 6 + C (52) * X ^ 7 + C (30) * X ^ 8 + C (12) * X ^ 9
@[expose] public def spanV_im_5_3 : Polynomial ℚ := C (20) + C (40) * X + C (60) * X ^ 2 + C (58) * X ^ 3 + C (56) * X ^ 4 + C (32) * X ^ 5 + C (8) * X ^ 6 + C (-16) * X ^ 7 + C (-18) * X ^ 8 + C (-20) * X ^ 9
@[expose] public def spanV_entry_5_3 : Ki := ofLadj spanV_re_5_3 spanV_im_5_3

@[expose] public def spanV_re_5_4 : Polynomial ℚ := C (2) + C (52) * X ^ 2 + C (90) * X ^ 3 + C (140) * X ^ 4 + C (168) * X ^ 5 + C (168) * X ^ 6 + C (140) * X ^ 7 + C (90) * X ^ 8 + C (52) * X ^ 9
@[expose] public def spanV_im_5_4 : Polynomial ℚ := C (58) + C (116) * X + C (152) * X ^ 2 + C (166) * X ^ 3 + C (136) * X ^ 4 + C (84) * X ^ 5 + C (32) * X ^ 6 + C (-20) * X ^ 7 + C (-50) * X ^ 8 + C (-36) * X ^ 9
@[expose] public def spanV_entry_5_4 : Ki := ofLadj spanV_re_5_4 spanV_im_5_4

@[expose] public def spanV_re_5_5 : Polynomial ℚ := C (26) + C (54) * X ^ 2 + C (56) * X ^ 3 + C (94) * X ^ 4 + C (102) * X ^ 5 + C (102) * X ^ 6 + C (94) * X ^ 7 + C (56) * X ^ 8 + C (54) * X ^ 9
@[expose] public def spanV_im_5_5 : Polynomial ℚ := C (38) + C (76) * X + C (70) * X ^ 2 + C (108) * X ^ 3 + C (58) * X ^ 4 + C (74) * X ^ 5 + C (2) * X ^ 6 + C (18) * X ^ 7 + C (-32) * X ^ 8 + C (6) * X ^ 9
@[expose] public def spanV_entry_5_5 : Ki := ofLadj spanV_re_5_5 spanV_im_5_5

@[expose] public def spanV_re_5_6 : Polynomial ℚ := C (24) * X ^ 2 + C (18) * X ^ 3 + C (44) * X ^ 4 + C (46) * X ^ 5 + C (46) * X ^ 6 + C (44) * X ^ 7 + C (18) * X ^ 8 + C (24) * X ^ 9
@[expose] public def spanV_im_5_6 : Polynomial ℚ := C (16) + C (32) * X + C (48) * X ^ 2 + C (42) * X ^ 3 + C (36) * X ^ 4 + C (30) * X ^ 5 + C (2) * X ^ 6 + C (-4) * X ^ 7 + C (-10) * X ^ 8 + C (-16) * X ^ 9
@[expose] public def spanV_entry_5_6 : Ki := ofLadj spanV_re_5_6 spanV_im_5_6

@[expose] public def spanV_re_5_7 : Polynomial ℚ := C (-20) + C (-4) * X ^ 2 + C (40) * X ^ 3 + C (54) * X ^ 4 + C (74) * X ^ 5 + C (74) * X ^ 6 + C (54) * X ^ 7 + C (40) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def spanV_im_5_7 : Polynomial ℚ := C (32) + C (64) * X + C (96) * X ^ 2 + C (84) * X ^ 3 + C (94) * X ^ 4 + C (38) * X ^ 5 + C (26) * X ^ 6 + C (-30) * X ^ 7 + C (-20) * X ^ 8 + C (-32) * X ^ 9
@[expose] public def spanV_entry_5_7 : Ki := ofLadj spanV_re_5_7 spanV_im_5_7

@[expose] public def spanV_re_5_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_5_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_5_8 : Ki := ofLadj spanV_re_5_8 spanV_im_5_8

@[expose] public def spanV_re_5_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_5_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_5_9 : Ki := ofLadj spanV_re_5_9 spanV_im_5_9

@[expose] public def spanV_re_5_10 : Polynomial ℚ := C (4) + C (4) * X ^ 2 + C (-8) * X ^ 3 + C (-8) * X ^ 4 + C (-12) * X ^ 5 + C (-12) * X ^ 6 + C (-8) * X ^ 7 + C (-8) * X ^ 8 + C (4) * X ^ 9
@[expose] public def spanV_im_5_10 : Polynomial ℚ := C (12) + C (24) * X + C (36) * X ^ 2 + C (48) * X ^ 3 + C (16) * X ^ 4 + C (28) * X ^ 5 + C (-4) * X ^ 6 + C (8) * X ^ 7 + C (-24) * X ^ 8 + C (-12) * X ^ 9
@[expose] public def spanV_entry_5_10 : Ki := ofLadj spanV_re_5_10 spanV_im_5_10

@[expose] public def spanV_re_5_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_5_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_5_11 : Ki := ofLadj spanV_re_5_11 spanV_im_5_11

@[expose] public def spanV_re_5_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_5_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_5_12 : Ki := ofLadj spanV_re_5_12 spanV_im_5_12

@[expose] public def spanV_re_5_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_5_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_5_13 : Ki := ofLadj spanV_re_5_13 spanV_im_5_13

@[expose] public def spanV_re_5_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_5_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_5_14 : Ki := ofLadj spanV_re_5_14 spanV_im_5_14

@[expose] public def spanV_re_6_0 : Polynomial ℚ := C (8) + C (-44) * X ^ 2 + C (-90) * X ^ 3 + C (-142) * X ^ 4 + C (-168) * X ^ 5 + C (-168) * X ^ 6 + C (-142) * X ^ 7 + C (-90) * X ^ 8 + C (-44) * X ^ 9
@[expose] public def spanV_im_6_0 : Polynomial ℚ := C (-88) + C (-176) * X + C (-220) * X ^ 2 + C (-242) * X ^ 3 + C (-198) * X ^ 4 + C (-132) * X ^ 5 + C (-44) * X ^ 6 + C (22) * X ^ 7 + C (66) * X ^ 8 + C (44) * X ^ 9
@[expose] public def spanV_entry_6_0 : Ki := ofLadj spanV_re_6_0 spanV_im_6_0

@[expose] public def spanV_re_6_1 : Polynomial ℚ := C (-46) * X ^ 2 + C (-84) * X ^ 3 + C (-132) * X ^ 4 + C (-156) * X ^ 5 + C (-156) * X ^ 6 + C (-132) * X ^ 7 + C (-84) * X ^ 8 + C (-46) * X ^ 9
@[expose] public def spanV_im_6_1 : Polynomial ℚ := C (-68) + C (-136) * X + C (-182) * X ^ 2 + C (-184) * X ^ 3 + C (-164) * X ^ 4 + C (-100) * X ^ 5 + C (-36) * X ^ 6 + C (28) * X ^ 7 + C (48) * X ^ 8 + C (46) * X ^ 9
@[expose] public def spanV_entry_6_1 : Ki := ofLadj spanV_re_6_1 spanV_im_6_1

@[expose] public def spanV_re_6_2 : Polynomial ℚ := C (6) + C (2) * X ^ 2 + C (-16) * X ^ 3 + C (-20) * X ^ 4 + C (-24) * X ^ 5 + C (-24) * X ^ 6 + C (-20) * X ^ 7 + C (-16) * X ^ 8 + C (2) * X ^ 9
@[expose] public def spanV_im_6_2 : Polynomial ℚ := C (-10) + C (-20) * X + C (-30) * X ^ 2 + C (-40) * X ^ 3 + C (-28) * X ^ 4 + C (-16) * X ^ 5 + C (-4) * X ^ 6 + C (8) * X ^ 7 + C (20) * X ^ 8 + C (10) * X ^ 9
@[expose] public def spanV_entry_6_2 : Ki := ofLadj spanV_re_6_2 spanV_im_6_2

@[expose] public def spanV_re_6_3 : Polynomial ℚ := C (-10) + C (22) * X ^ 2 + C (38) * X ^ 3 + C (60) * X ^ 4 + C (72) * X ^ 5 + C (72) * X ^ 6 + C (60) * X ^ 7 + C (38) * X ^ 8 + C (22) * X ^ 9
@[expose] public def spanV_im_6_3 : Polynomial ℚ := C (30) + C (60) * X + C (90) * X ^ 2 + C (98) * X ^ 3 + C (84) * X ^ 4 + C (48) * X ^ 5 + C (12) * X ^ 6 + C (-24) * X ^ 7 + C (-38) * X ^ 8 + C (-30) * X ^ 9
@[expose] public def spanV_entry_6_3 : Ki := ofLadj spanV_re_6_3 spanV_im_6_3

@[expose] public def spanV_re_6_4 : Polynomial ℚ := C (-16) + C (66) * X ^ 2 + C (148) * X ^ 3 + C (226) * X ^ 4 + C (272) * X ^ 5 + C (272) * X ^ 6 + C (226) * X ^ 7 + C (148) * X ^ 8 + C (66) * X ^ 9
@[expose] public def spanV_im_6_4 : Polynomial ℚ := C (116) + C (232) * X + C (326) * X ^ 2 + C (332) * X ^ 3 + C (294) * X ^ 4 + C (168) * X ^ 5 + C (64) * X ^ 6 + C (-62) * X ^ 7 + C (-100) * X ^ 8 + C (-94) * X ^ 9
@[expose] public def spanV_entry_6_4 : Ki := ofLadj spanV_re_6_4 spanV_im_6_4

@[expose] public def spanV_re_6_5 : Polynomial ℚ := C (6) + C (48) * X ^ 2 + C (62) * X ^ 3 + C (108) * X ^ 4 + C (120) * X ^ 5 + C (120) * X ^ 6 + C (108) * X ^ 7 + C (62) * X ^ 8 + C (48) * X ^ 9
@[expose] public def spanV_im_6_5 : Polynomial ℚ := C (58) + C (116) * X + C (152) * X ^ 2 + C (166) * X ^ 3 + C (136) * X ^ 4 + C (84) * X ^ 5 + C (32) * X ^ 6 + C (-20) * X ^ 7 + C (-50) * X ^ 8 + C (-36) * X ^ 9
@[expose] public def spanV_entry_6_5 : Ki := ofLadj spanV_re_6_5 spanV_im_6_5

@[expose] public def spanV_re_6_6 : Polynomial ℚ := C (-10) + C (22) * X ^ 2 + C (48) * X ^ 3 + C (74) * X ^ 4 + C (92) * X ^ 5 + C (92) * X ^ 6 + C (74) * X ^ 7 + C (48) * X ^ 8 + C (22) * X ^ 9
@[expose] public def spanV_im_6_6 : Polynomial ℚ := C (38) + C (76) * X + C (114) * X ^ 2 + C (108) * X ^ 3 + C (102) * X ^ 4 + C (52) * X ^ 5 + C (24) * X ^ 6 + C (-26) * X ^ 7 + C (-32) * X ^ 8 + C (-38) * X ^ 9
@[expose] public def spanV_entry_6_6 : Ki := ofLadj spanV_re_6_6 spanV_im_6_6

@[expose] public def spanV_re_6_7 : Polynomial ℚ := C (-24) + C (18) * X ^ 2 + C (66) * X ^ 3 + C (94) * X ^ 4 + C (120) * X ^ 5 + C (120) * X ^ 6 + C (94) * X ^ 7 + C (66) * X ^ 8 + C (18) * X ^ 9
@[expose] public def spanV_im_6_7 : Polynomial ℚ := C (60) + C (120) * X + C (158) * X ^ 2 + C (174) * X ^ 3 + C (146) * X ^ 4 + C (96) * X ^ 5 + C (24) * X ^ 6 + C (-26) * X ^ 7 + C (-54) * X ^ 8 + C (-38) * X ^ 9
@[expose] public def spanV_entry_6_7 : Ki := ofLadj spanV_re_6_7 spanV_im_6_7

@[expose] public def spanV_re_6_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_6_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_6_8 : Ki := ofLadj spanV_re_6_8 spanV_im_6_8

@[expose] public def spanV_re_6_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_6_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_6_9 : Ki := ofLadj spanV_re_6_9 spanV_im_6_9

@[expose] public def spanV_re_6_10 : Polynomial ℚ := C (-4) + C (-4) * X ^ 2 + C (8) * X ^ 3 + C (8) * X ^ 4 + C (12) * X ^ 5 + C (12) * X ^ 6 + C (8) * X ^ 7 + C (8) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def spanV_im_6_10 : Polynomial ℚ := C (12) + C (24) * X + C (36) * X ^ 2 + C (48) * X ^ 3 + C (16) * X ^ 4 + C (28) * X ^ 5 + C (-4) * X ^ 6 + C (8) * X ^ 7 + C (-24) * X ^ 8 + C (-12) * X ^ 9
@[expose] public def spanV_entry_6_10 : Ki := ofLadj spanV_re_6_10 spanV_im_6_10

@[expose] public def spanV_re_6_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_6_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_6_11 : Ki := ofLadj spanV_re_6_11 spanV_im_6_11

@[expose] public def spanV_re_6_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_6_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_6_12 : Ki := ofLadj spanV_re_6_12 spanV_im_6_12

@[expose] public def spanV_re_6_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_6_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_6_13 : Ki := ofLadj spanV_re_6_13 spanV_im_6_13

@[expose] public def spanV_re_6_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_6_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_6_14 : Ki := ofLadj spanV_re_6_14 spanV_im_6_14

@[expose] public def spanV_re_7_0 : Polynomial ℚ := C (-14) + C (-38) * X ^ 2 + C (-66) * X ^ 3 + C (-96) * X ^ 4 + C (-112) * X ^ 5 + C (-112) * X ^ 6 + C (-96) * X ^ 7 + C (-66) * X ^ 8 + C (-38) * X ^ 9
@[expose] public def spanV_im_7_0 : Polynomial ℚ := C (50) + C (100) * X + C (106) * X ^ 2 + C (134) * X ^ 3 + C (96) * X ^ 4 + C (80) * X ^ 5 + C (20) * X ^ 6 + C (4) * X ^ 7 + C (-34) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def spanV_entry_7_0 : Ki := ofLadj spanV_re_7_0 spanV_im_7_0

@[expose] public def spanV_re_7_1 : Polynomial ℚ := C (-12) + C (-38) * X ^ 2 + C (-56) * X ^ 3 + C (-86) * X ^ 4 + C (-100) * X ^ 5 + C (-100) * X ^ 6 + C (-86) * X ^ 7 + C (-56) * X ^ 8 + C (-38) * X ^ 9
@[expose] public def spanV_im_7_1 : Polynomial ℚ := C (40) + C (80) * X + C (98) * X ^ 2 + C (116) * X ^ 3 + C (90) * X ^ 4 + C (64) * X ^ 5 + C (16) * X ^ 6 + C (-10) * X ^ 7 + C (-36) * X ^ 8 + C (-18) * X ^ 9
@[expose] public def spanV_entry_7_1 : Ki := ofLadj spanV_re_7_1 spanV_im_7_1

@[expose] public def spanV_re_7_2 : Polynomial ℚ := C (10) + C (10) * X ^ 2 + C (-16) * X ^ 3 + C (-10) * X ^ 4 + C (-22) * X ^ 5 + C (-22) * X ^ 6 + C (-10) * X ^ 7 + C (-16) * X ^ 8 + C (10) * X ^ 9
@[expose] public def spanV_im_7_2 : Polynomial ℚ := C (2) + C (4) * X + C (6) * X ^ 2 + C (8) * X ^ 3 + C (10) * X ^ 4 + C (-10) * X ^ 5 + C (14) * X ^ 6 + C (-6) * X ^ 7 + C (-4) * X ^ 8 + C (-2) * X ^ 9
@[expose] public def spanV_entry_7_2 : Ki := ofLadj spanV_re_7_2 spanV_im_7_2

@[expose] public def spanV_re_7_3 : Polynomial ℚ := C (-8) + C (12) * X ^ 2 + C (30) * X ^ 3 + C (52) * X ^ 4 + C (64) * X ^ 5 + C (64) * X ^ 6 + C (52) * X ^ 7 + C (30) * X ^ 8 + C (12) * X ^ 9
@[expose] public def spanV_im_7_3 : Polynomial ℚ := C (-20) + C (-40) * X + C (-60) * X ^ 2 + C (-58) * X ^ 3 + C (-56) * X ^ 4 + C (-32) * X ^ 5 + C (-8) * X ^ 6 + C (16) * X ^ 7 + C (18) * X ^ 8 + C (20) * X ^ 9
@[expose] public def spanV_entry_7_3 : Ki := ofLadj spanV_re_7_3 spanV_im_7_3

@[expose] public def spanV_re_7_4 : Polynomial ℚ := C (2) + C (52) * X ^ 2 + C (90) * X ^ 3 + C (140) * X ^ 4 + C (168) * X ^ 5 + C (168) * X ^ 6 + C (140) * X ^ 7 + C (90) * X ^ 8 + C (52) * X ^ 9
@[expose] public def spanV_im_7_4 : Polynomial ℚ := C (-58) + C (-116) * X + C (-152) * X ^ 2 + C (-166) * X ^ 3 + C (-136) * X ^ 4 + C (-84) * X ^ 5 + C (-32) * X ^ 6 + C (20) * X ^ 7 + C (50) * X ^ 8 + C (36) * X ^ 9
@[expose] public def spanV_entry_7_4 : Ki := ofLadj spanV_re_7_4 spanV_im_7_4

@[expose] public def spanV_re_7_5 : Polynomial ℚ := C (26) + C (54) * X ^ 2 + C (56) * X ^ 3 + C (94) * X ^ 4 + C (102) * X ^ 5 + C (102) * X ^ 6 + C (94) * X ^ 7 + C (56) * X ^ 8 + C (54) * X ^ 9
@[expose] public def spanV_im_7_5 : Polynomial ℚ := C (-38) + C (-76) * X + C (-70) * X ^ 2 + C (-108) * X ^ 3 + C (-58) * X ^ 4 + C (-74) * X ^ 5 + C (-2) * X ^ 6 + C (-18) * X ^ 7 + C (32) * X ^ 8 + C (-6) * X ^ 9
@[expose] public def spanV_entry_7_5 : Ki := ofLadj spanV_re_7_5 spanV_im_7_5

@[expose] public def spanV_re_7_6 : Polynomial ℚ := C (24) * X ^ 2 + C (18) * X ^ 3 + C (44) * X ^ 4 + C (46) * X ^ 5 + C (46) * X ^ 6 + C (44) * X ^ 7 + C (18) * X ^ 8 + C (24) * X ^ 9
@[expose] public def spanV_im_7_6 : Polynomial ℚ := C (-16) + C (-32) * X + C (-48) * X ^ 2 + C (-42) * X ^ 3 + C (-36) * X ^ 4 + C (-30) * X ^ 5 + C (-2) * X ^ 6 + C (4) * X ^ 7 + C (10) * X ^ 8 + C (16) * X ^ 9
@[expose] public def spanV_entry_7_6 : Ki := ofLadj spanV_re_7_6 spanV_im_7_6

@[expose] public def spanV_re_7_7 : Polynomial ℚ := C (-20) + C (-4) * X ^ 2 + C (40) * X ^ 3 + C (54) * X ^ 4 + C (74) * X ^ 5 + C (74) * X ^ 6 + C (54) * X ^ 7 + C (40) * X ^ 8 + C (-4) * X ^ 9
@[expose] public def spanV_im_7_7 : Polynomial ℚ := C (-32) + C (-64) * X + C (-96) * X ^ 2 + C (-84) * X ^ 3 + C (-94) * X ^ 4 + C (-38) * X ^ 5 + C (-26) * X ^ 6 + C (30) * X ^ 7 + C (20) * X ^ 8 + C (32) * X ^ 9
@[expose] public def spanV_entry_7_7 : Ki := ofLadj spanV_re_7_7 spanV_im_7_7

@[expose] public def spanV_re_7_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_7_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_7_8 : Ki := ofLadj spanV_re_7_8 spanV_im_7_8

@[expose] public def spanV_re_7_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_7_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_7_9 : Ki := ofLadj spanV_re_7_9 spanV_im_7_9

@[expose] public def spanV_re_7_10 : Polynomial ℚ := C (4) + C (4) * X ^ 2 + C (-8) * X ^ 3 + C (-8) * X ^ 4 + C (-12) * X ^ 5 + C (-12) * X ^ 6 + C (-8) * X ^ 7 + C (-8) * X ^ 8 + C (4) * X ^ 9
@[expose] public def spanV_im_7_10 : Polynomial ℚ := C (-12) + C (-24) * X + C (-36) * X ^ 2 + C (-48) * X ^ 3 + C (-16) * X ^ 4 + C (-28) * X ^ 5 + C (4) * X ^ 6 + C (-8) * X ^ 7 + C (24) * X ^ 8 + C (12) * X ^ 9
@[expose] public def spanV_entry_7_10 : Ki := ofLadj spanV_re_7_10 spanV_im_7_10

@[expose] public def spanV_re_7_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_7_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_7_11 : Ki := ofLadj spanV_re_7_11 spanV_im_7_11

@[expose] public def spanV_re_7_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_7_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_7_12 : Ki := ofLadj spanV_re_7_12 spanV_im_7_12

@[expose] public def spanV_re_7_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_7_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_7_13 : Ki := ofLadj spanV_re_7_13 spanV_im_7_13

@[expose] public def spanV_re_7_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_7_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_7_14 : Ki := ofLadj spanV_re_7_14 spanV_im_7_14

@[expose] public def spanV_re_8_0 : Polynomial ℚ := C (-44) + C (20) * X ^ 2 + C (90) * X ^ 3 + C (138) * X ^ 4 + C (170) * X ^ 5 + C (170) * X ^ 6 + C (138) * X ^ 7 + C (90) * X ^ 8 + C (20) * X ^ 9
@[expose] public def spanV_im_8_0 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_0 : Ki := ofLadj spanV_re_8_0 spanV_im_8_0

@[expose] public def spanV_re_8_1 : Polynomial ℚ := C (-14) + C (44) * X ^ 2 + C (88) * X ^ 3 + C (138) * X ^ 4 + C (166) * X ^ 5 + C (166) * X ^ 6 + C (138) * X ^ 7 + C (88) * X ^ 8 + C (44) * X ^ 9
@[expose] public def spanV_im_8_1 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_1 : Ki := ofLadj spanV_re_8_1 spanV_im_8_1

@[expose] public def spanV_re_8_2 : Polynomial ℚ := C (4) + C (2) * X ^ 2 + C (8) * X ^ 3 + C (22) * X ^ 4 + C (10) * X ^ 5 + C (10) * X ^ 6 + C (22) * X ^ 7 + C (8) * X ^ 8 + C (2) * X ^ 9
@[expose] public def spanV_im_8_2 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_2 : Ki := ofLadj spanV_re_8_2 spanV_im_8_2

@[expose] public def spanV_re_8_3 : Polynomial ℚ := C (-4) + C (-30) * X ^ 2 + C (-52) * X ^ 3 + C (-74) * X ^ 4 + C (-84) * X ^ 5 + C (-84) * X ^ 6 + C (-74) * X ^ 7 + C (-52) * X ^ 8 + C (-30) * X ^ 9
@[expose] public def spanV_im_8_3 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_3 : Ki := ofLadj spanV_re_8_3 spanV_im_8_3

@[expose] public def spanV_re_8_4 : Polynomial ℚ := C (12) + C (-74) * X ^ 2 + C (-148) * X ^ 3 + C (-236) * X ^ 4 + C (-274) * X ^ 5 + C (-274) * X ^ 6 + C (-236) * X ^ 7 + C (-148) * X ^ 8 + C (-74) * X ^ 9
@[expose] public def spanV_im_8_4 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_4 : Ki := ofLadj spanV_re_8_4 spanV_im_8_4

@[expose] public def spanV_re_8_5 : Polynomial ℚ := C (32) + C (-8) * X ^ 2 + C (-58) * X ^ 3 + C (-84) * X ^ 4 + C (-108) * X ^ 5 + C (-108) * X ^ 6 + C (-84) * X ^ 7 + C (-58) * X ^ 8 + C (-8) * X ^ 9
@[expose] public def spanV_im_8_5 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_5 : Ki := ofLadj spanV_re_8_5 spanV_im_8_5

@[expose] public def spanV_re_8_6 : Polynomial ℚ := C (2) + C (-28) * X ^ 2 + C (-52) * X ^ 3 + C (-76) * X ^ 4 + C (-98) * X ^ 5 + C (-98) * X ^ 6 + C (-76) * X ^ 7 + C (-52) * X ^ 8 + C (-28) * X ^ 9
@[expose] public def spanV_im_8_6 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_6 : Ki := ofLadj spanV_re_8_6 spanV_im_8_6

@[expose] public def spanV_re_8_7 : Polynomial ℚ := C (8) + C (-42) * X ^ 2 + C (-84) * X ^ 3 + C (-128) * X ^ 4 + C (-146) * X ^ 5 + C (-146) * X ^ 6 + C (-128) * X ^ 7 + C (-84) * X ^ 8 + C (-42) * X ^ 9
@[expose] public def spanV_im_8_7 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_7 : Ki := ofLadj spanV_re_8_7 spanV_im_8_7

@[expose] public def spanV_re_8_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_8_8 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_8 : Ki := ofLadj spanV_re_8_8 spanV_im_8_8

@[expose] public def spanV_re_8_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_8_9 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_9 : Ki := ofLadj spanV_re_8_9 spanV_im_8_9

@[expose] public def spanV_re_8_10 : Polynomial ℚ := C (20) + C (20) * X ^ 2 + C (-40) * X ^ 3 + C (-40) * X ^ 4 + C (-60) * X ^ 5 + C (-60) * X ^ 6 + C (-40) * X ^ 7 + C (-40) * X ^ 8 + C (20) * X ^ 9
@[expose] public def spanV_im_8_10 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_10 : Ki := ofLadj spanV_re_8_10 spanV_im_8_10

@[expose] public def spanV_re_8_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_8_11 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_11 : Ki := ofLadj spanV_re_8_11 spanV_im_8_11

@[expose] public def spanV_re_8_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_8_12 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_12 : Ki := ofLadj spanV_re_8_12 spanV_im_8_12

@[expose] public def spanV_re_8_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_8_13 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_13 : Ki := ofLadj spanV_re_8_13 spanV_im_8_13

@[expose] public def spanV_re_8_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_im_8_14 : Polynomial ℚ := (0 : Polynomial ℚ)
@[expose] public def spanV_entry_8_14 : Ki := ofLadj spanV_re_8_14 spanV_im_8_14

@[expose] public def spanV : Matrix (Fin 9) (Fin 15) Ki :=
  fun i j =>
    match i.val, j.val with
    | 0, 0 => spanV_entry_0_0
    | 0, 1 => spanV_entry_0_1
    | 0, 2 => spanV_entry_0_2
    | 0, 3 => spanV_entry_0_3
    | 0, 4 => spanV_entry_0_4
    | 0, 5 => spanV_entry_0_5
    | 0, 6 => spanV_entry_0_6
    | 0, 7 => spanV_entry_0_7
    | 0, 8 => spanV_entry_0_8
    | 0, 9 => spanV_entry_0_9
    | 0, 10 => spanV_entry_0_10
    | 0, 11 => spanV_entry_0_11
    | 0, 12 => spanV_entry_0_12
    | 0, 13 => spanV_entry_0_13
    | 0, 14 => spanV_entry_0_14
    | 1, 0 => spanV_entry_1_0
    | 1, 1 => spanV_entry_1_1
    | 1, 2 => spanV_entry_1_2
    | 1, 3 => spanV_entry_1_3
    | 1, 4 => spanV_entry_1_4
    | 1, 5 => spanV_entry_1_5
    | 1, 6 => spanV_entry_1_6
    | 1, 7 => spanV_entry_1_7
    | 1, 8 => spanV_entry_1_8
    | 1, 9 => spanV_entry_1_9
    | 1, 10 => spanV_entry_1_10
    | 1, 11 => spanV_entry_1_11
    | 1, 12 => spanV_entry_1_12
    | 1, 13 => spanV_entry_1_13
    | 1, 14 => spanV_entry_1_14
    | 2, 0 => spanV_entry_2_0
    | 2, 1 => spanV_entry_2_1
    | 2, 2 => spanV_entry_2_2
    | 2, 3 => spanV_entry_2_3
    | 2, 4 => spanV_entry_2_4
    | 2, 5 => spanV_entry_2_5
    | 2, 6 => spanV_entry_2_6
    | 2, 7 => spanV_entry_2_7
    | 2, 8 => spanV_entry_2_8
    | 2, 9 => spanV_entry_2_9
    | 2, 10 => spanV_entry_2_10
    | 2, 11 => spanV_entry_2_11
    | 2, 12 => spanV_entry_2_12
    | 2, 13 => spanV_entry_2_13
    | 2, 14 => spanV_entry_2_14
    | 3, 0 => spanV_entry_3_0
    | 3, 1 => spanV_entry_3_1
    | 3, 2 => spanV_entry_3_2
    | 3, 3 => spanV_entry_3_3
    | 3, 4 => spanV_entry_3_4
    | 3, 5 => spanV_entry_3_5
    | 3, 6 => spanV_entry_3_6
    | 3, 7 => spanV_entry_3_7
    | 3, 8 => spanV_entry_3_8
    | 3, 9 => spanV_entry_3_9
    | 3, 10 => spanV_entry_3_10
    | 3, 11 => spanV_entry_3_11
    | 3, 12 => spanV_entry_3_12
    | 3, 13 => spanV_entry_3_13
    | 3, 14 => spanV_entry_3_14
    | 4, 0 => spanV_entry_4_0
    | 4, 1 => spanV_entry_4_1
    | 4, 2 => spanV_entry_4_2
    | 4, 3 => spanV_entry_4_3
    | 4, 4 => spanV_entry_4_4
    | 4, 5 => spanV_entry_4_5
    | 4, 6 => spanV_entry_4_6
    | 4, 7 => spanV_entry_4_7
    | 4, 8 => spanV_entry_4_8
    | 4, 9 => spanV_entry_4_9
    | 4, 10 => spanV_entry_4_10
    | 4, 11 => spanV_entry_4_11
    | 4, 12 => spanV_entry_4_12
    | 4, 13 => spanV_entry_4_13
    | 4, 14 => spanV_entry_4_14
    | 5, 0 => spanV_entry_5_0
    | 5, 1 => spanV_entry_5_1
    | 5, 2 => spanV_entry_5_2
    | 5, 3 => spanV_entry_5_3
    | 5, 4 => spanV_entry_5_4
    | 5, 5 => spanV_entry_5_5
    | 5, 6 => spanV_entry_5_6
    | 5, 7 => spanV_entry_5_7
    | 5, 8 => spanV_entry_5_8
    | 5, 9 => spanV_entry_5_9
    | 5, 10 => spanV_entry_5_10
    | 5, 11 => spanV_entry_5_11
    | 5, 12 => spanV_entry_5_12
    | 5, 13 => spanV_entry_5_13
    | 5, 14 => spanV_entry_5_14
    | 6, 0 => spanV_entry_6_0
    | 6, 1 => spanV_entry_6_1
    | 6, 2 => spanV_entry_6_2
    | 6, 3 => spanV_entry_6_3
    | 6, 4 => spanV_entry_6_4
    | 6, 5 => spanV_entry_6_5
    | 6, 6 => spanV_entry_6_6
    | 6, 7 => spanV_entry_6_7
    | 6, 8 => spanV_entry_6_8
    | 6, 9 => spanV_entry_6_9
    | 6, 10 => spanV_entry_6_10
    | 6, 11 => spanV_entry_6_11
    | 6, 12 => spanV_entry_6_12
    | 6, 13 => spanV_entry_6_13
    | 6, 14 => spanV_entry_6_14
    | 7, 0 => spanV_entry_7_0
    | 7, 1 => spanV_entry_7_1
    | 7, 2 => spanV_entry_7_2
    | 7, 3 => spanV_entry_7_3
    | 7, 4 => spanV_entry_7_4
    | 7, 5 => spanV_entry_7_5
    | 7, 6 => spanV_entry_7_6
    | 7, 7 => spanV_entry_7_7
    | 7, 8 => spanV_entry_7_8
    | 7, 9 => spanV_entry_7_9
    | 7, 10 => spanV_entry_7_10
    | 7, 11 => spanV_entry_7_11
    | 7, 12 => spanV_entry_7_12
    | 7, 13 => spanV_entry_7_13
    | 7, 14 => spanV_entry_7_14
    | 8, 0 => spanV_entry_8_0
    | 8, 1 => spanV_entry_8_1
    | 8, 2 => spanV_entry_8_2
    | 8, 3 => spanV_entry_8_3
    | 8, 4 => spanV_entry_8_4
    | 8, 5 => spanV_entry_8_5
    | 8, 6 => spanV_entry_8_6
    | 8, 7 => spanV_entry_8_7
    | 8, 8 => spanV_entry_8_8
    | 8, 9 => spanV_entry_8_9
    | 8, 10 => spanV_entry_8_10
    | 8, 11 => spanV_entry_8_11
    | 8, 12 => spanV_entry_8_12
    | 8, 13 => spanV_entry_8_13
    | 8, 14 => spanV_entry_8_14
    | _, _ => spanV_entry_0_0

end V14Formalization.D12SigmaPlusSegreCore
