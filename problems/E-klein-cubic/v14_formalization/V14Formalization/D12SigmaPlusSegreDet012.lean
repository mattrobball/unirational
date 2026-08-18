/-
Auto-generated Fplus / det(bilinearN) coefficient identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def DC012_0_pre : Polynomial ℚ := C (48) + C (52) * X ^ 2 + C (90) * X ^ 3 + C (20) * X ^ 4 + C (104) * X ^ 5 + C (92) * X ^ 6 + C (4) * X ^ 7 + C (132) * X ^ 8 + C (38) * X ^ 9 + C (-8) * X ^ 10 + C (76) * X ^ 11 + C (-8) * X ^ 12 + C (-14) * X ^ 13 + C (42) * X ^ 14 + C (-32) * X ^ 15 + C (4) * X ^ 16 + C (16) * X ^ 17 + C (-16) * X ^ 18
def DC012_0_pim : Polynomial ℚ := C (24) + C (48) * X + C (-12) * X ^ 2 + C (66) * X ^ 3 + C (36) * X ^ 4 + C (-28) * X ^ 5 + C (88) * X ^ 6 + C (-4) * X ^ 7 + C (-4) * X ^ 8 + C (130) * X ^ 9 + C (-12) * X ^ 10 + C (36) * X ^ 11 + C (84) * X ^ 12 + C (2) * X ^ 13 + C (58) * X ^ 14 + C (56) * X ^ 15 + C (20) * X ^ 16 + C (40) * X ^ 17 + C (32) * X ^ 18
theorem DC012_0_pre_eq :
    N_re_0_0 * N_re_1_4 - N_im_0_0 * N_im_1_4 =
      DC012_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_4, N_im_1_4, DC012_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_0_pim_eq :
    N_re_0_0 * N_im_1_4 + N_im_0_0 * N_re_1_4 =
      DC012_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_4, N_im_1_4, DC012_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_0_mul :
    N_entry_0_0 * N_entry_1_4 =
      ofLadj DC012_0_pre DC012_0_pim := by
  rw [N_entry_0_0, N_entry_1_4, ofLadj_mul,
    DC012_0_pre_eq, DC012_0_pim_eq]

def DC012_1_pre : Polynomial ℚ := C (223) + C (-384) * X + C (-151) * X ^ 2 + C ((801 / 2 : ℚ)) * X ^ 3 + C ((-2019 / 2 : ℚ)) * X ^ 4 + C (305) * X ^ 5 + C ((339 / 2 : ℚ)) * X ^ 6 + C (-1390) * X ^ 7 + C (906) * X ^ 8 + C (-610) * X ^ 9 + C (-1391) * X ^ 10 + C (881) * X ^ 11 + C (-1007) * X ^ 12 + C (-459) * X ^ 13 + C ((1011 / 2 : ℚ)) * X ^ 14 + C ((-1601 / 2 : ℚ)) * X ^ 15 + C ((-45 / 2 : ℚ)) * X ^ 16 + C (113) * X ^ 17 + C (-420) * X ^ 18
def DC012_1_pim : Polynomial ℚ := C (364) + C (728) * X + C (79) * X ^ 2 + C ((2475 / 2 : ℚ)) * X ^ 3 + C ((2177 / 2 : ℚ)) * X ^ 4 + C (322) * X ^ 5 + C ((4535 / 2 : ℚ)) * X ^ 6 + C (1016) * X ^ 7 + C (844) * X ^ 8 + C (3174) * X ^ 9 + C (538) * X ^ 10 + C (1336) * X ^ 11 + C (2134) * X ^ 12 + C (147) * X ^ 13 + C ((2637 / 2 : ℚ)) * X ^ 14 + C ((2111 / 2 : ℚ)) * X ^ 15 + C ((29 / 2 : ℚ)) * X ^ 16 + C (796) * X ^ 17 + C (240) * X ^ 18
theorem DC012_1_pre_eq :
    N_re_0_1 * N_re_1_3 - N_im_0_1 * N_im_1_3 =
      DC012_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_3, N_im_1_3, DC012_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_1_pim_eq :
    N_re_0_1 * N_im_1_3 + N_im_0_1 * N_re_1_3 =
      DC012_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_3, N_im_1_3, DC012_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_1_mul :
    N_entry_0_1 * N_entry_1_3 =
      ofLadj DC012_1_pre DC012_1_pim := by
  rw [N_entry_0_1, N_entry_1_3, ofLadj_mul,
    DC012_1_pre_eq, DC012_1_pim_eq]

def DC012_1_spre : Polynomial ℚ := C (-223) + C (384) * X + C (151) * X ^ 2 + C ((-801 / 2 : ℚ)) * X ^ 3 + C ((2019 / 2 : ℚ)) * X ^ 4 + C (-305) * X ^ 5 + C ((-339 / 2 : ℚ)) * X ^ 6 + C (1390) * X ^ 7 + C (-906) * X ^ 8 + C (610) * X ^ 9 + C (1391) * X ^ 10 + C (-881) * X ^ 11 + C (1007) * X ^ 12 + C (459) * X ^ 13 + C ((-1011 / 2 : ℚ)) * X ^ 14 + C ((1601 / 2 : ℚ)) * X ^ 15 + C ((45 / 2 : ℚ)) * X ^ 16 + C (-113) * X ^ 17 + C (420) * X ^ 18
def DC012_1_spim : Polynomial ℚ := C (-364) + C (-728) * X + C (-79) * X ^ 2 + C ((-2475 / 2 : ℚ)) * X ^ 3 + C ((-2177 / 2 : ℚ)) * X ^ 4 + C (-322) * X ^ 5 + C ((-4535 / 2 : ℚ)) * X ^ 6 + C (-1016) * X ^ 7 + C (-844) * X ^ 8 + C (-3174) * X ^ 9 + C (-538) * X ^ 10 + C (-1336) * X ^ 11 + C (-2134) * X ^ 12 + C (-147) * X ^ 13 + C ((-2637 / 2 : ℚ)) * X ^ 14 + C ((-2111 / 2 : ℚ)) * X ^ 15 + C ((-29 / 2 : ℚ)) * X ^ 16 + C (-796) * X ^ 17 + C (-240) * X ^ 18
theorem DC012_1_spre_eq : -DC012_1_pre = DC012_1_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC012_1_pre, DC012_1_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC012_1_spim_eq : -DC012_1_pim = DC012_1_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC012_1_pim, DC012_1_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC012_1_smul :
    -(N_entry_0_1 * N_entry_1_3) =
      ofLadj DC012_1_spre DC012_1_spim := by
  rw [DC012_1_mul, ofLadj_neg, DC012_1_spre_eq, DC012_1_spim_eq]

def DC012_2_pre : Polynomial ℚ := C (88) + C (100) * X ^ 2 + C (170) * X ^ 3 + C (20) * X ^ 4 + C (186) * X ^ 5 + C (162) * X ^ 6 + C (-20) * X ^ 7 + C (244) * X ^ 8 + C (70) * X ^ 9 + C (-14) * X ^ 10 + C (164) * X ^ 11 + C (-14) * X ^ 12 + C (-30) * X ^ 13 + C (74) * X ^ 14 + C (-76) * X ^ 15 + C (-6) * X ^ 16 + C (18) * X ^ 17 + C (-36) * X ^ 18
def DC012_2_pim : Polynomial ℚ := C (48) + C (96) * X + C (-28) * X ^ 2 + C (118) * X ^ 3 + C (68) * X ^ 4 + C (-58) * X ^ 5 + C (178) * X ^ 6 + C (16) * X ^ 8 + C (278) * X ^ 9 + C (-14) * X ^ 10 + C (72) * X ^ 11 + C (158) * X ^ 12 + C (-10) * X ^ 13 + C (106) * X ^ 14 + C (104) * X ^ 15 + C (34) * X ^ 16 + C (86) * X ^ 17 + C (68) * X ^ 18
theorem DC012_2_pre_eq :
    N_re_0_0 * N_re_2_5 - N_im_0_0 * N_im_2_5 =
      DC012_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_2_5, N_im_2_5, DC012_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_2_pim_eq :
    N_re_0_0 * N_im_2_5 + N_im_0_0 * N_re_2_5 =
      DC012_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_2_5, N_im_2_5, DC012_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_2_mul :
    N_entry_0_0 * N_entry_2_5 =
      ofLadj DC012_2_pre DC012_2_pim := by
  rw [N_entry_0_0, N_entry_2_5, ofLadj_mul,
    DC012_2_pre_eq, DC012_2_pim_eq]

def DC012_3_pre : Polynomial ℚ := C ((537 / 2 : ℚ)) + C (-282) * X + C ((-203 / 2 : ℚ)) * X ^ 2 + C ((917 / 2 : ℚ)) * X ^ 3 + C (-873) * X ^ 4 + C (250) * X ^ 5 + C (114) * X ^ 6 + C (-1455) * X ^ 7 + C ((1247 / 2 : ℚ)) * X ^ 8 + C ((-1507 / 2 : ℚ)) * X ^ 9 + C (-1459) * X ^ 10 + C (580) * X ^ 11 + C (-1177) * X ^ 12 + C (-652) * X ^ 13 + C (165) * X ^ 14 + C (-1034) * X ^ 15 + C (-231) * X ^ 16 + C (-95) * X ^ 17 + C (-452) * X ^ 18
def DC012_3_pim : Polynomial ℚ := C ((621 / 2 : ℚ)) + C (621) * X + C ((-235 / 2 : ℚ)) * X ^ 2 + C ((1633 / 2 : ℚ)) * X ^ 3 + C (634) * X ^ 4 + C (-205) * X ^ 5 + C (1576) * X ^ 6 + C (439) * X ^ 7 + C ((423 / 2 : ℚ)) * X ^ 8 + C ((4717 / 2 : ℚ)) * X ^ 9 + C (-93) * X ^ 10 + C (652) * X ^ 11 + C (1397) * X ^ 12 + C (-316) * X ^ 13 + C (897) * X ^ 14 + C (712) * X ^ 15 + C (-103) * X ^ 16 + C (657) * X ^ 17 + C (140) * X ^ 18
theorem DC012_3_pre_eq :
    N_re_0_2 * N_re_2_3 - N_im_0_2 * N_im_2_3 =
      DC012_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_2_3, N_im_2_3, DC012_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_3_pim_eq :
    N_re_0_2 * N_im_2_3 + N_im_0_2 * N_re_2_3 =
      DC012_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_2_3, N_im_2_3, DC012_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_3_mul :
    N_entry_0_2 * N_entry_2_3 =
      ofLadj DC012_3_pre DC012_3_pim := by
  rw [N_entry_0_2, N_entry_2_3, ofLadj_mul,
    DC012_3_pre_eq, DC012_3_pim_eq]

def DC012_3_spre : Polynomial ℚ := C ((-537 / 2 : ℚ)) + C (282) * X + C ((203 / 2 : ℚ)) * X ^ 2 + C ((-917 / 2 : ℚ)) * X ^ 3 + C (873) * X ^ 4 + C (-250) * X ^ 5 + C (-114) * X ^ 6 + C (1455) * X ^ 7 + C ((-1247 / 2 : ℚ)) * X ^ 8 + C ((1507 / 2 : ℚ)) * X ^ 9 + C (1459) * X ^ 10 + C (-580) * X ^ 11 + C (1177) * X ^ 12 + C (652) * X ^ 13 + C (-165) * X ^ 14 + C (1034) * X ^ 15 + C (231) * X ^ 16 + C (95) * X ^ 17 + C (452) * X ^ 18
def DC012_3_spim : Polynomial ℚ := C ((-621 / 2 : ℚ)) + C (-621) * X + C ((235 / 2 : ℚ)) * X ^ 2 + C ((-1633 / 2 : ℚ)) * X ^ 3 + C (-634) * X ^ 4 + C (205) * X ^ 5 + C (-1576) * X ^ 6 + C (-439) * X ^ 7 + C ((-423 / 2 : ℚ)) * X ^ 8 + C ((-4717 / 2 : ℚ)) * X ^ 9 + C (93) * X ^ 10 + C (-652) * X ^ 11 + C (-1397) * X ^ 12 + C (316) * X ^ 13 + C (-897) * X ^ 14 + C (-712) * X ^ 15 + C (103) * X ^ 16 + C (-657) * X ^ 17 + C (-140) * X ^ 18
theorem DC012_3_spre_eq : -DC012_3_pre = DC012_3_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC012_3_pre, DC012_3_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC012_3_spim_eq : -DC012_3_pim = DC012_3_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC012_3_pim, DC012_3_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC012_3_smul :
    -(N_entry_0_2 * N_entry_2_3) =
      ofLadj DC012_3_spre DC012_3_spim := by
  rw [DC012_3_mul, ofLadj_neg, DC012_3_spre_eq, DC012_3_spim_eq]

def DC012_4_pre : Polynomial ℚ := C (342) + C (-304) * X + C (98) * X ^ 2 + C ((1217 / 2 : ℚ)) * X ^ 3 + C ((-1545 / 2 : ℚ)) * X ^ 4 + C (528) * X ^ 5 + C ((793 / 2 : ℚ)) * X ^ 6 + C (-1216) * X ^ 7 + C (1114) * X ^ 8 + C (-405) * X ^ 9 + C (-1185) * X ^ 10 + C (967) * X ^ 11 + C (-881) * X ^ 12 + C (-503) * X ^ 13 + C ((1011 / 2 : ℚ)) * X ^ 14 + C ((-1659 / 2 : ℚ)) * X ^ 15 + C ((-73 / 2 : ℚ)) * X ^ 16 + C (95) * X ^ 17 + C (-386) * X ^ 18
def DC012_4_pim : Polynomial ℚ := C (361) + C (722) * X + C ((2259 / 2 : ℚ)) * X ^ 3 + C ((1879 / 2 : ℚ)) * X ^ 4 + C (65) * X ^ 5 + C ((4153 / 2 : ℚ)) * X ^ 6 + C (700) * X ^ 7 + C (634) * X ^ 8 + C (2965) * X ^ 9 + C (330) * X ^ 10 + C (1132) * X ^ 11 + C (1934) * X ^ 12 + C (21) * X ^ 13 + C ((2445 / 2 : ℚ)) * X ^ 14 + C ((1997 / 2 : ℚ)) * X ^ 15 + C ((129 / 2 : ℚ)) * X ^ 16 + C (780) * X ^ 17 + C (348) * X ^ 18
theorem DC012_4_pre_eq :
    N_re_0_3 * N_re_1_1 - N_im_0_3 * N_im_1_1 =
      DC012_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_1, N_im_1_1, DC012_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_4_pim_eq :
    N_re_0_3 * N_im_1_1 + N_im_0_3 * N_re_1_1 =
      DC012_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_1, N_im_1_1, DC012_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_4_mul :
    N_entry_0_3 * N_entry_1_1 =
      ofLadj DC012_4_pre DC012_4_pim := by
  rw [N_entry_0_3, N_entry_1_1, ofLadj_mul,
    DC012_4_pre_eq, DC012_4_pim_eq]

def DC012_5_pre : Polynomial ℚ := C (12) + C (-24) * X + C (-18) * X ^ 2 + C (22) * X ^ 3 + C (-50) * X ^ 4 + C (34) * X ^ 5 + C (20) * X ^ 6 + C (-46) * X ^ 7 + C (70) * X ^ 8 + C (-20) * X ^ 9 + C (-64) * X ^ 10 + C (48) * X ^ 11 + C (-40) * X ^ 12 + C (-2) * X ^ 13 + C (48) * X ^ 14 + C (-14) * X ^ 15 + C (14) * X ^ 16 + C (28) * X ^ 17 + C (-18) * X ^ 18
def DC012_5_pim : Polynomial ℚ := C (24) + C (48) * X + C (18) * X ^ 2 + C (102) * X ^ 3 + C (86) * X ^ 4 + C (58) * X ^ 5 + C (152) * X ^ 6 + C (94) * X ^ 7 + C (70) * X ^ 8 + C (196) * X ^ 9 + C (64) * X ^ 10 + C (108) * X ^ 11 + C (152) * X ^ 12 + C (50) * X ^ 13 + C (92) * X ^ 14 + C (78) * X ^ 15 + C (10) * X ^ 16 + C (44) * X ^ 17 + C (6) * X ^ 18
theorem DC012_5_pre_eq :
    N_re_0_4 * N_re_1_0 - N_im_0_4 * N_im_1_0 =
      DC012_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_0, N_im_1_0, DC012_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_5_pim_eq :
    N_re_0_4 * N_im_1_0 + N_im_0_4 * N_re_1_0 =
      DC012_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_0, N_im_1_0, DC012_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_5_mul :
    N_entry_0_4 * N_entry_1_0 =
      ofLadj DC012_5_pre DC012_5_pim := by
  rw [N_entry_0_4, N_entry_1_0, ofLadj_mul,
    DC012_5_pre_eq, DC012_5_pim_eq]

def DC012_5_spre : Polynomial ℚ := C (-12) + C (24) * X + C (18) * X ^ 2 + C (-22) * X ^ 3 + C (50) * X ^ 4 + C (-34) * X ^ 5 + C (-20) * X ^ 6 + C (46) * X ^ 7 + C (-70) * X ^ 8 + C (20) * X ^ 9 + C (64) * X ^ 10 + C (-48) * X ^ 11 + C (40) * X ^ 12 + C (2) * X ^ 13 + C (-48) * X ^ 14 + C (14) * X ^ 15 + C (-14) * X ^ 16 + C (-28) * X ^ 17 + C (18) * X ^ 18
def DC012_5_spim : Polynomial ℚ := C (-24) + C (-48) * X + C (-18) * X ^ 2 + C (-102) * X ^ 3 + C (-86) * X ^ 4 + C (-58) * X ^ 5 + C (-152) * X ^ 6 + C (-94) * X ^ 7 + C (-70) * X ^ 8 + C (-196) * X ^ 9 + C (-64) * X ^ 10 + C (-108) * X ^ 11 + C (-152) * X ^ 12 + C (-50) * X ^ 13 + C (-92) * X ^ 14 + C (-78) * X ^ 15 + C (-10) * X ^ 16 + C (-44) * X ^ 17 + C (-6) * X ^ 18
theorem DC012_5_spre_eq : -DC012_5_pre = DC012_5_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC012_5_pre, DC012_5_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC012_5_spim_eq : -DC012_5_pim = DC012_5_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC012_5_pim, DC012_5_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC012_5_smul :
    -(N_entry_0_4 * N_entry_1_0) =
      ofLadj DC012_5_spre DC012_5_spim := by
  rw [DC012_5_mul, ofLadj_neg, DC012_5_spre_eq, DC012_5_spim_eq]

def DC012_6_pre : Polynomial ℚ := C (361) + C (-228) * X + C (114) * X ^ 2 + C (665) * X ^ 3 + C (-565) * X ^ 4 + C (660) * X ^ 5 + C (644) * X ^ 6 + C (-762) * X ^ 7 + C (1492) * X ^ 8 + C (114) * X ^ 9 + C (-593) * X ^ 10 + C (1352) * X ^ 11 + C (-365) * X ^ 12 + C (827) * X ^ 14 + C (-473) * X ^ 15 + C (230) * X ^ 16 + C (246) * X ^ 17 + C (-276) * X ^ 18
def DC012_6_pim : Polynomial ℚ := C (323) + C (646) * X + C (6) * X ^ 2 + C (1133) * X ^ 3 + C (1047) * X ^ 4 + C (230) * X ^ 5 + C (2156) * X ^ 6 + C (954) * X ^ 7 + C (856) * X ^ 8 + C (3002) * X ^ 9 + C (551) * X ^ 10 + C (1286) * X ^ 11 + C (2021) * X ^ 12 + C (210) * X ^ 13 + C (1229) * X ^ 14 + C (949) * X ^ 15 + C (110) * X ^ 16 + C (722) * X ^ 17 + C (268) * X ^ 18
theorem DC012_6_pre_eq :
    N_re_0_3 * N_re_2_2 - N_im_0_3 * N_im_2_2 =
      DC012_6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_2_2, N_im_2_2, DC012_6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_6_pim_eq :
    N_re_0_3 * N_im_2_2 + N_im_0_3 * N_re_2_2 =
      DC012_6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_2_2, N_im_2_2, DC012_6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_6_mul :
    N_entry_0_3 * N_entry_2_2 =
      ofLadj DC012_6_pre DC012_6_pim := by
  rw [N_entry_0_3, N_entry_2_2, ofLadj_mul,
    DC012_6_pre_eq, DC012_6_pim_eq]

def DC012_7_pre : Polynomial ℚ := C (-12) + C (-48) * X + C (-36) * X ^ 2 + C (31) * X ^ 3 + C (-122) * X ^ 4 + C (18) * X ^ 5 + C (4) * X ^ 6 + C (-167) * X ^ 7 + C (57) * X ^ 8 + C (-113) * X ^ 9 + C (-193) * X ^ 10 + C (78) * X ^ 11 + C (-145) * X ^ 12 + C (-77) * X ^ 13 + C (26) * X ^ 14 + C (-117) * X ^ 15 + C (-25) * X ^ 16 + C (-11) * X ^ 17 + C (-72) * X ^ 18
def DC012_7_pim : Polynomial ℚ := C (36) + C (72) * X + C (12) * X ^ 2 + C (121) * X ^ 3 + C (108) * X ^ 4 + C (42) * X ^ 5 + C (214) * X ^ 6 + C (107) * X ^ 7 + C (81) * X ^ 8 + C (337) * X ^ 9 + C (49) * X ^ 10 + C (144) * X ^ 11 + C (239) * X ^ 12 + C (11) * X ^ 13 + C (158) * X ^ 14 + C (121) * X ^ 15 + C (-3) * X ^ 16 + C (107) * X ^ 17 + C (24) * X ^ 18
theorem DC012_7_pre_eq :
    N_re_0_5 * N_re_2_0 - N_im_0_5 * N_im_2_0 =
      DC012_7_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_2_0, N_im_2_0, DC012_7_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_7_pim_eq :
    N_re_0_5 * N_im_2_0 + N_im_0_5 * N_re_2_0 =
      DC012_7_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_2_0, N_im_2_0, DC012_7_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_7_mul :
    N_entry_0_5 * N_entry_2_0 =
      ofLadj DC012_7_pre DC012_7_pim := by
  rw [N_entry_0_5, N_entry_2_0, ofLadj_mul,
    DC012_7_pre_eq, DC012_7_pim_eq]

def DC012_7_spre : Polynomial ℚ := C (12) + C (48) * X + C (36) * X ^ 2 + C (-31) * X ^ 3 + C (122) * X ^ 4 + C (-18) * X ^ 5 + C (-4) * X ^ 6 + C (167) * X ^ 7 + C (-57) * X ^ 8 + C (113) * X ^ 9 + C (193) * X ^ 10 + C (-78) * X ^ 11 + C (145) * X ^ 12 + C (77) * X ^ 13 + C (-26) * X ^ 14 + C (117) * X ^ 15 + C (25) * X ^ 16 + C (11) * X ^ 17 + C (72) * X ^ 18
def DC012_7_spim : Polynomial ℚ := C (-36) + C (-72) * X + C (-12) * X ^ 2 + C (-121) * X ^ 3 + C (-108) * X ^ 4 + C (-42) * X ^ 5 + C (-214) * X ^ 6 + C (-107) * X ^ 7 + C (-81) * X ^ 8 + C (-337) * X ^ 9 + C (-49) * X ^ 10 + C (-144) * X ^ 11 + C (-239) * X ^ 12 + C (-11) * X ^ 13 + C (-158) * X ^ 14 + C (-121) * X ^ 15 + C (3) * X ^ 16 + C (-107) * X ^ 17 + C (-24) * X ^ 18
theorem DC012_7_spre_eq : -DC012_7_pre = DC012_7_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC012_7_pre, DC012_7_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC012_7_spim_eq : -DC012_7_pim = DC012_7_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC012_7_pim, DC012_7_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC012_7_smul :
    -(N_entry_0_5 * N_entry_2_0) =
      ofLadj DC012_7_spre DC012_7_spim := by
  rw [DC012_7_mul, ofLadj_neg, DC012_7_spre_eq, DC012_7_spim_eq]

def DC012_8_pre : Polynomial ℚ := C (-194) + C (192) * X + C (-50) * X ^ 2 + C (-361) * X ^ 3 + C (485) * X ^ 4 + C (-311) * X ^ 5 + C (-226) * X ^ 6 + C (778) * X ^ 7 + C (-658) * X ^ 8 + C (287) * X ^ 9 + C (761) * X ^ 10 + C (-594) * X ^ 11 + C (569) * X ^ 12 + C (337) * X ^ 13 + C (-297) * X ^ 14 + C (539) * X ^ 15 + C (50) * X ^ 16 + C (-35) * X ^ 17 + C (246) * X ^ 18
def DC012_8_pim : Polynomial ℚ := C (-220) + C (-440) * X + C (-4) * X ^ 2 + C (-681) * X ^ 3 + C (-561) * X ^ 4 + C (-27) * X ^ 5 + C (-1272) * X ^ 6 + C (-422) * X ^ 7 + C (-378) * X ^ 8 + C (-1823) * X ^ 9 + C (-197) * X ^ 10 + C (-688) * X ^ 11 + C (-1179) * X ^ 12 + C (11) * X ^ 13 + C (-757) * X ^ 14 + C (-615) * X ^ 15 + C (-32) * X ^ 16 + C (-485) * X ^ 17 + C (-218) * X ^ 18
theorem DC012_8_pre_eq :
    N_re_1_1 * N_re_2_5 - N_im_1_1 * N_im_2_5 =
      DC012_8_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_1, N_im_1_1, N_re_2_5, N_im_2_5, DC012_8_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_8_pim_eq :
    N_re_1_1 * N_im_2_5 + N_im_1_1 * N_re_2_5 =
      DC012_8_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_1, N_im_1_1, N_re_2_5, N_im_2_5, DC012_8_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_8_mul :
    N_entry_1_1 * N_entry_2_5 =
      ofLadj DC012_8_pre DC012_8_pim := by
  rw [N_entry_1_1, N_entry_2_5, ofLadj_mul,
    DC012_8_pre_eq, DC012_8_pim_eq]

def DC012_9_pre : Polynomial ℚ := C (-74) + C (144) * X + C (49) * X ^ 2 + C (-83) * X ^ 3 + C (328) * X ^ 4 + C (-50) * X ^ 5 + C (-25) * X ^ 6 + C (402) * X ^ 7 + C (-268) * X ^ 8 + C (159) * X ^ 9 + C (373) * X ^ 10 + C (-266) * X ^ 11 + C (229) * X ^ 12 + C (110) * X ^ 13 + C (-185) * X ^ 14 + C (183) * X ^ 15 + C (-27) * X ^ 16 + C (-52) * X ^ 17 + C (109) * X ^ 18
def DC012_9_pim : Polynomial ℚ := C (-126) + C (-252) * X + C (-69) * X ^ 2 + C (-447) * X ^ 3 + C (-434) * X ^ 4 + C (-230) * X ^ 5 + C (-835) * X ^ 6 + C (-468) * X ^ 7 + C (-464) * X ^ 8 + C (-1127) * X ^ 9 + C (-375) * X ^ 10 + C (-570) * X ^ 11 + C (-765) * X ^ 12 + C (-196) * X ^ 13 + C (-481) * X ^ 14 + C (-377) * X ^ 15 + C (-73) * X ^ 16 + C (-254) * X ^ 17 + C (-113) * X ^ 18
theorem DC012_9_pre_eq :
    N_re_1_2 * N_re_2_4 - N_im_1_2 * N_im_2_4 =
      DC012_9_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_2, N_im_1_2, N_re_2_4, N_im_2_4, DC012_9_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_9_pim_eq :
    N_re_1_2 * N_im_2_4 + N_im_1_2 * N_re_2_4 =
      DC012_9_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_2, N_im_1_2, N_re_2_4, N_im_2_4, DC012_9_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_9_mul :
    N_entry_1_2 * N_entry_2_4 =
      ofLadj DC012_9_pre DC012_9_pim := by
  rw [N_entry_1_2, N_entry_2_4, ofLadj_mul,
    DC012_9_pre_eq, DC012_9_pim_eq]

def DC012_9_spre : Polynomial ℚ := C (74) + C (-144) * X + C (-49) * X ^ 2 + C (83) * X ^ 3 + C (-328) * X ^ 4 + C (50) * X ^ 5 + C (25) * X ^ 6 + C (-402) * X ^ 7 + C (268) * X ^ 8 + C (-159) * X ^ 9 + C (-373) * X ^ 10 + C (266) * X ^ 11 + C (-229) * X ^ 12 + C (-110) * X ^ 13 + C (185) * X ^ 14 + C (-183) * X ^ 15 + C (27) * X ^ 16 + C (52) * X ^ 17 + C (-109) * X ^ 18
def DC012_9_spim : Polynomial ℚ := C (126) + C (252) * X + C (69) * X ^ 2 + C (447) * X ^ 3 + C (434) * X ^ 4 + C (230) * X ^ 5 + C (835) * X ^ 6 + C (468) * X ^ 7 + C (464) * X ^ 8 + C (1127) * X ^ 9 + C (375) * X ^ 10 + C (570) * X ^ 11 + C (765) * X ^ 12 + C (196) * X ^ 13 + C (481) * X ^ 14 + C (377) * X ^ 15 + C (73) * X ^ 16 + C (254) * X ^ 17 + C (113) * X ^ 18
theorem DC012_9_spre_eq : -DC012_9_pre = DC012_9_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC012_9_pre, DC012_9_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC012_9_spim_eq : -DC012_9_pim = DC012_9_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC012_9_pim, DC012_9_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC012_9_smul :
    -(N_entry_1_2 * N_entry_2_4) =
      ofLadj DC012_9_spre DC012_9_spim := by
  rw [DC012_9_mul, ofLadj_neg, DC012_9_spre_eq, DC012_9_spim_eq]

def DC012_10_pre : Polynomial ℚ := C (-114) + C (72) * X + C (-32) * X ^ 2 + C (-204) * X ^ 3 + C (170) * X ^ 4 + C (-216) * X ^ 5 + C (-208) * X ^ 6 + C (214) * X ^ 7 + C (-488) * X ^ 8 + C (-58) * X ^ 9 + C (156) * X ^ 10 + C (-444) * X ^ 11 + C (84) * X ^ 12 + C (-26) * X ^ 13 + C (-284) * X ^ 14 + C (124) * X ^ 15 + C (-80) * X ^ 16 + C (-88) * X ^ 17 + C (80) * X ^ 18
def DC012_10_pim : Polynomial ℚ := C (-102) + C (-204) * X + C (-12) * X ^ 2 + C (-372) * X ^ 3 + C (-338) * X ^ 4 + C (-96) * X ^ 5 + C (-700) * X ^ 6 + C (-326) * X ^ 7 + C (-288) * X ^ 8 + C (-954) * X ^ 9 + C (-200) * X ^ 10 + C (-420) * X ^ 11 + C (-640) * X ^ 12 + C (-78) * X ^ 13 + C (-384) * X ^ 14 + C (-300) * X ^ 15 + C (-32) * X ^ 16 + C (-216) * X ^ 17 + C (-80) * X ^ 18
theorem DC012_10_pre_eq :
    N_re_1_4 * N_re_2_2 - N_im_1_4 * N_im_2_2 =
      DC012_10_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_4, N_im_1_4, N_re_2_2, N_im_2_2, DC012_10_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_10_pim_eq :
    N_re_1_4 * N_im_2_2 + N_im_1_4 * N_re_2_2 =
      DC012_10_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_4, N_im_1_4, N_re_2_2, N_im_2_2, DC012_10_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_10_mul :
    N_entry_1_4 * N_entry_2_2 =
      ofLadj DC012_10_pre DC012_10_pim := by
  rw [N_entry_1_4, N_entry_2_2, ofLadj_mul,
    DC012_10_pre_eq, DC012_10_pim_eq]

def DC012_11_pre : Polynomial ℚ := C ((-559 / 2 : ℚ)) + C (156) * X + C ((-133 / 2 : ℚ)) * X ^ 2 + C ((-871 / 2 : ℚ)) * X ^ 3 + C (401) * X ^ 4 + C (-437) * X ^ 5 + C (-391) * X ^ 6 + C (562) * X ^ 7 + C ((-1907 / 2 : ℚ)) * X ^ 8 + C ((-11 / 2 : ℚ)) * X ^ 9 + C (470) * X ^ 10 + C (-812) * X ^ 11 + C (314) * X ^ 12 + C (61) * X ^ 13 + C (-518) * X ^ 14 + C (341) * X ^ 15 + C (-112) * X ^ 16 + C (-158) * X ^ 17 + C (180) * X ^ 18
def DC012_11_pim : Polynomial ℚ := C ((-463 / 2 : ℚ)) + C (-463) * X + C ((-25 / 2 : ℚ)) * X ^ 2 + C ((-1575 / 2 : ℚ)) * X ^ 3 + C (-680) * X ^ 4 + C (-120) * X ^ 5 + C (-1437) * X ^ 6 + C (-588) * X ^ 7 + C ((-971 / 2 : ℚ)) * X ^ 8 + C ((-3879 / 2 : ℚ)) * X ^ 9 + C (-302) * X ^ 10 + C (-782) * X ^ 11 + C (-1262) * X ^ 12 + C (-75) * X ^ 13 + C (-754) * X ^ 14 + C (-599) * X ^ 15 + C (-36) * X ^ 16 + C (-434) * X ^ 17 + C (-160) * X ^ 18
theorem DC012_11_pre_eq :
    N_re_1_5 * N_re_2_1 - N_im_1_5 * N_im_2_1 =
      DC012_11_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_5, N_im_1_5, N_re_2_1, N_im_2_1, DC012_11_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_11_pim_eq :
    N_re_1_5 * N_im_2_1 + N_im_1_5 * N_re_2_1 =
      DC012_11_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_5, N_im_1_5, N_re_2_1, N_im_2_1, DC012_11_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC012_11_mul :
    N_entry_1_5 * N_entry_2_1 =
      ofLadj DC012_11_pre DC012_11_pim := by
  rw [N_entry_1_5, N_entry_2_1, ofLadj_mul,
    DC012_11_pre_eq, DC012_11_pim_eq]

def DC012_11_spre : Polynomial ℚ := C ((559 / 2 : ℚ)) + C (-156) * X + C ((133 / 2 : ℚ)) * X ^ 2 + C ((871 / 2 : ℚ)) * X ^ 3 + C (-401) * X ^ 4 + C (437) * X ^ 5 + C (391) * X ^ 6 + C (-562) * X ^ 7 + C ((1907 / 2 : ℚ)) * X ^ 8 + C ((11 / 2 : ℚ)) * X ^ 9 + C (-470) * X ^ 10 + C (812) * X ^ 11 + C (-314) * X ^ 12 + C (-61) * X ^ 13 + C (518) * X ^ 14 + C (-341) * X ^ 15 + C (112) * X ^ 16 + C (158) * X ^ 17 + C (-180) * X ^ 18
def DC012_11_spim : Polynomial ℚ := C ((463 / 2 : ℚ)) + C (463) * X + C ((25 / 2 : ℚ)) * X ^ 2 + C ((1575 / 2 : ℚ)) * X ^ 3 + C (680) * X ^ 4 + C (120) * X ^ 5 + C (1437) * X ^ 6 + C (588) * X ^ 7 + C ((971 / 2 : ℚ)) * X ^ 8 + C ((3879 / 2 : ℚ)) * X ^ 9 + C (302) * X ^ 10 + C (782) * X ^ 11 + C (1262) * X ^ 12 + C (75) * X ^ 13 + C (754) * X ^ 14 + C (599) * X ^ 15 + C (36) * X ^ 16 + C (434) * X ^ 17 + C (160) * X ^ 18
theorem DC012_11_spre_eq : -DC012_11_pre = DC012_11_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC012_11_pre, DC012_11_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC012_11_spim_eq : -DC012_11_pim = DC012_11_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC012_11_pim, DC012_11_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC012_11_smul :
    -(N_entry_1_5 * N_entry_2_1) =
      ofLadj DC012_11_spre DC012_11_spim := by
  rw [DC012_11_mul, ofLadj_neg, DC012_11_spre_eq, DC012_11_spim_eq]

@[expose] public def detCoeff_012 : Ki :=
  N_entry_0_0 * N_entry_1_4 + (-(N_entry_0_1 * N_entry_1_3)) + N_entry_0_0 * N_entry_2_5 + (-(N_entry_0_2 * N_entry_2_3)) + N_entry_0_3 * N_entry_1_1 + (-(N_entry_0_4 * N_entry_1_0)) + N_entry_0_3 * N_entry_2_2 + (-(N_entry_0_5 * N_entry_2_0)) + N_entry_1_1 * N_entry_2_5 + (-(N_entry_1_2 * N_entry_2_4)) + N_entry_1_4 * N_entry_2_2 + (-(N_entry_1_5 * N_entry_2_1))

theorem detCoeff_012_sum :
    detCoeff_012 = ofLadj (DC012_0_pre + DC012_1_spre + DC012_2_pre + DC012_3_spre + DC012_4_pre + DC012_5_spre + DC012_6_pre + DC012_7_spre + DC012_8_pre + DC012_9_spre + DC012_10_pre + DC012_11_spre) (DC012_0_pim + DC012_1_spim + DC012_2_pim + DC012_3_spim + DC012_4_pim + DC012_5_spim + DC012_6_pim + DC012_7_spim + DC012_8_pim + DC012_9_spim + DC012_10_pim + DC012_11_spim) := by
  simp only [detCoeff_012, DC012_0_mul, DC012_1_smul, DC012_2_mul, DC012_3_smul, DC012_4_mul, DC012_5_smul, DC012_6_mul, DC012_7_smul, DC012_8_mul, DC012_9_smul, DC012_10_mul, DC012_11_smul]
  simpa [add_assoc] using ofLadj_add12 DC012_0_pre DC012_0_pim DC012_1_spre DC012_1_spim DC012_2_pre DC012_2_pim DC012_3_spre DC012_3_spim DC012_4_pre DC012_4_pim DC012_5_spre DC012_5_spim DC012_6_pre DC012_6_pim DC012_7_spre DC012_7_spim DC012_8_pre DC012_8_pim DC012_9_spre DC012_9_spim DC012_10_pre DC012_10_pim DC012_11_spre DC012_11_spim

def DC012_qre : Polynomial ℚ := C (369) + C (-199) * X + C (428) * X ^ 2 + C (-43) * X ^ 3 + C (132) * X ^ 4 + C (129) * X ^ 5 + C (138) * X ^ 6 + C (142) * X ^ 7 + C (285) * X ^ 8
def DC012_qim : Polynomial ℚ := C (47) + C (47) * X + C (-52) * X ^ 2 + C (291) * X ^ 3 + C (42) * X ^ 4 + C (-153) * X ^ 5 + C (344) * X ^ 6 + C (-270) * X ^ 7 + C (281) * X ^ 8

theorem detCoeff_012_sum_poly_re :
    DC012_0_pre + DC012_1_spre + DC012_2_pre + DC012_3_spre + DC012_4_pre + DC012_5_spre + DC012_6_pre + DC012_7_spre + DC012_8_pre + DC012_9_spre + DC012_10_pre + DC012_11_spre = Fplus_re_012 + Phi11 * DC012_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC012_0_pre, DC012_1_spre, DC012_2_pre, DC012_3_spre, DC012_4_pre, DC012_5_spre, DC012_6_pre, DC012_7_spre, DC012_8_pre, DC012_9_spre, DC012_10_pre, DC012_11_spre, Fplus_re_012, DC012_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind

theorem detCoeff_012_sum_poly_im :
    DC012_0_pim + DC012_1_spim + DC012_2_pim + DC012_3_spim + DC012_4_pim + DC012_5_spim + DC012_6_pim + DC012_7_spim + DC012_8_pim + DC012_9_spim + DC012_10_pim + DC012_11_spim = Fplus_im_012 + Phi11 * DC012_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC012_0_pim, DC012_1_spim, DC012_2_pim, DC012_3_spim, DC012_4_pim, DC012_5_spim, DC012_6_pim, DC012_7_spim, DC012_8_pim, DC012_9_spim, DC012_10_pim, DC012_11_spim, Fplus_im_012, DC012_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind

public theorem detCoeff_012_eq :
    detCoeff_012 = ofLadj Fplus_re_012 Fplus_im_012 := by
  rw [detCoeff_012_sum, detCoeff_012_sum_poly_re,
    detCoeff_012_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
