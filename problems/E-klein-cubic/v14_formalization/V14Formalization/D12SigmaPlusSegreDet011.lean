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

def DC011_0_ab_pre : Polynomial ℚ := C (48) + C (52) * X ^ 2 + C (90) * X ^ 3 + C (20) * X ^ 4 + C (104) * X ^ 5 + C (92) * X ^ 6 + C (4) * X ^ 7 + C (132) * X ^ 8 + C (38) * X ^ 9 + C (-8) * X ^ 10 + C (76) * X ^ 11 + C (-8) * X ^ 12 + C (-14) * X ^ 13 + C (42) * X ^ 14 + C (-32) * X ^ 15 + C (4) * X ^ 16 + C (16) * X ^ 17 + C (-16) * X ^ 18
def DC011_0_ab_pim : Polynomial ℚ := C (24) + C (48) * X + C (-12) * X ^ 2 + C (66) * X ^ 3 + C (36) * X ^ 4 + C (-28) * X ^ 5 + C (88) * X ^ 6 + C (-4) * X ^ 7 + C (-4) * X ^ 8 + C (130) * X ^ 9 + C (-12) * X ^ 10 + C (36) * X ^ 11 + C (84) * X ^ 12 + C (2) * X ^ 13 + C (58) * X ^ 14 + C (56) * X ^ 15 + C (20) * X ^ 16 + C (40) * X ^ 17 + C (32) * X ^ 18
def DC011_0_pre : Polynomial ℚ := C (-768) + C (1152) * X + C (-568) * X ^ 2 + C (-2148) * X ^ 3 + C (2720) * X ^ 4 + C (-4092) * X ^ 5 + C (-2804) * X ^ 6 + C (3496) * X ^ 7 + C (-9572) * X ^ 8 + C (456) * X ^ 9 + C (3288) * X ^ 10 + C (-11400) * X ^ 11 + C (5640) * X ^ 12 + C (740) * X ^ 13 + C (-7864) * X ^ 14 + C (10136) * X ^ 15 + C (-672) * X ^ 16 + C (-1000) * X ^ 17 + C (10752) * X ^ 18 + C (48) * X ^ 19 + C (2860) * X ^ 20 + C (6740) * X ^ 21 + C (360) * X ^ 22 + C (3236) * X ^ 23 + C (3144) * X ^ 24 + C (488) * X ^ 25 + C (1392) * X ^ 26 + C (960) * X ^ 27
def DC011_0_pim : Polynomial ℚ := C (-1104) + C (-2208) * X + C (-456) * X ^ 2 + C (-5652) * X ^ 3 + C (-4720) * X ^ 4 + C (-2476) * X ^ 5 + C (-12364) * X ^ 6 + C (-5040) * X ^ 7 + C (-6500) * X ^ 8 + C (-18952) * X ^ 9 + C (-2776) * X ^ 10 + C (-11768) * X ^ 11 + C (-17648) * X ^ 12 + C (-428) * X ^ 13 + C (-14632) * X ^ 14 + C (-11792) * X ^ 15 + C (64) * X ^ 16 + C (-13944) * X ^ 17 + C (-5632) * X ^ 18 + C (-824) * X ^ 19 + C (-8492) * X ^ 20 + C (-1636) * X ^ 21 + C (-1408) * X ^ 22 + C (-4292) * X ^ 23 + C (-232) * X ^ 24 + C (-952) * X ^ 25 + C (-1376) * X ^ 26 + C (160) * X ^ 27
theorem DC011_0_ab_pre_eq :
    N_re_0_0 * N_re_1_4 - N_im_0_0 * N_im_1_4 =
      DC011_0_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_4, N_im_1_4, DC011_0_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_0_ab_pim_eq :
    N_re_0_0 * N_im_1_4 + N_im_0_0 * N_re_1_4 =
      DC011_0_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_4, N_im_1_4, DC011_0_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_0_ab_mul :
    N_entry_0_0 * N_entry_1_4 =
      ofLadj DC011_0_ab_pre DC011_0_ab_pim := by
  rw [N_entry_0_0, N_entry_1_4, ofLadj_mul,
    DC011_0_ab_pre_eq, DC011_0_ab_pim_eq]

theorem DC011_0_pre_eq :
    DC011_0_ab_pre * N_re_2_5 - DC011_0_ab_pim * N_im_2_5 =
      DC011_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_0_ab_pre, DC011_0_ab_pim, N_re_2_5, N_im_2_5, DC011_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_0_pim_eq :
    DC011_0_ab_pre * N_im_2_5 + DC011_0_ab_pim * N_re_2_5 =
      DC011_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_0_ab_pre, DC011_0_ab_pim, N_re_2_5, N_im_2_5, DC011_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_0_mul :
    N_entry_0_0 * N_entry_1_4 * N_entry_2_5 =
      ofLadj DC011_0_pre DC011_0_pim := by
  rw [DC011_0_ab_mul, N_entry_2_5, ofLadj_mul, DC011_0_pre_eq, DC011_0_pim_eq]

def DC011_1_ab_pre : Polynomial ℚ := C (95) + C (-192) * X + C (-115) * X ^ 2 + C (116) * X ^ 3 + C (-510) * X ^ 4 + C (80) * X ^ 5 + C (28) * X ^ 6 + C (-628) * X ^ 7 + C (406) * X ^ 8 + C (-223) * X ^ 9 + C (-560) * X ^ 10 + C (452) * X ^ 11 + C (-368) * X ^ 12 + C (-108) * X ^ 13 + C (290) * X ^ 14 + C (-286) * X ^ 15 + C (28) * X ^ 16 + C (80) * X ^ 17 + C (-168) * X ^ 18
def DC011_1_ab_pim : Polynomial ℚ := C (170) + C (340) * X + C (63) * X ^ 2 + C (607) * X ^ 3 + C (570) * X ^ 4 + C (275) * X ^ 5 + C (1169) * X ^ 6 + C (644) * X ^ 7 + C (581) * X ^ 8 + C (1587) * X ^ 9 + C (422) * X ^ 10 + C (740) * X ^ 11 + C (1058) * X ^ 12 + C (170) * X ^ 13 + C (632) * X ^ 14 + C (510) * X ^ 15 + C (24) * X ^ 16 + C (352) * X ^ 17 + C (96) * X ^ 18
def DC011_1_pre : Polynomial ℚ := C ((-2745 / 2 : ℚ)) + C (26828) * X + C ((41361 / 2 : ℚ)) * X ^ 2 + C (12984) * X ^ 3 + C (101722) * X ^ 4 + C (33647) * X ^ 5 + C (72172) * X ^ 6 + C ((405381 / 2 : ℚ)) * X ^ 7 + C (28563) * X ^ 8 + C (199733) * X ^ 9 + C ((562741 / 2 : ℚ)) * X ^ 10 + C (28630) * X ^ 11 + C ((659975 / 2 : ℚ)) * X ^ 12 + C ((467515 / 2 : ℚ)) * X ^ 13 + C (56118) * X ^ 14 + C ((742899 / 2 : ℚ)) * X ^ 15 + C ((257143 / 2 : ℚ)) * X ^ 16 + C ((196821 / 2 : ℚ)) * X ^ 17 + C (297909) * X ^ 18 + C (39661) * X ^ 19 + C (104455) * X ^ 20 + C (145834) * X ^ 21 + C (2608) * X ^ 22 + C (70389) * X ^ 23 + C (49750) * X ^ 24 + C (-878) * X ^ 25 + C (27428) * X ^ 26 + C (8364) * X ^ 27
def DC011_1_pim : Polynomial ℚ := C ((-23675 / 2 : ℚ)) + C (-19163) * X + C ((12189 / 2 : ℚ)) * X ^ 2 + C (-51653) * X ^ 3 + C (-38431) * X ^ 4 + C (2585) * X ^ 5 + C (-140395) * X ^ 6 + C ((-74331 / 2 : ℚ)) * X ^ 7 + C (-47735) * X ^ 8 + C (-253115) * X ^ 9 + C ((4067 / 2 : ℚ)) * X ^ 10 + C (-142655) * X ^ 11 + C ((-546373 / 2 : ℚ)) * X ^ 12 + C ((69009 / 2 : ℚ)) * X ^ 13 + C (-244834) * X ^ 14 + C ((-396445 / 2 : ℚ)) * X ^ 15 + C ((49135 / 2 : ℚ)) * X ^ 16 + C ((-523037 / 2 : ℚ)) * X ^ 17 + C (-78790) * X ^ 18 + C (-6165) * X ^ 19 + C (-168145) * X ^ 20 + C (-4174) * X ^ 21 + C (-28982) * X ^ 22 + C (-72459) * X ^ 23 + C (13712) * X ^ 24 + C (-16562) * X ^ 25 + C (-14340) * X ^ 26 + C (7812) * X ^ 27
theorem DC011_1_ab_pre_eq :
    N_re_0_1 * N_re_1_5 - N_im_0_1 * N_im_1_5 =
      DC011_1_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_5, N_im_1_5, DC011_1_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_1_ab_pim_eq :
    N_re_0_1 * N_im_1_5 + N_im_0_1 * N_re_1_5 =
      DC011_1_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_5, N_im_1_5, DC011_1_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_1_ab_mul :
    N_entry_0_1 * N_entry_1_5 =
      ofLadj DC011_1_ab_pre DC011_1_ab_pim := by
  rw [N_entry_0_1, N_entry_1_5, ofLadj_mul,
    DC011_1_ab_pre_eq, DC011_1_ab_pim_eq]

theorem DC011_1_pre_eq :
    DC011_1_ab_pre * N_re_2_3 - DC011_1_ab_pim * N_im_2_3 =
      DC011_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_1_ab_pre, DC011_1_ab_pim, N_re_2_3, N_im_2_3, DC011_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_1_pim_eq :
    DC011_1_ab_pre * N_im_2_3 + DC011_1_ab_pim * N_re_2_3 =
      DC011_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_1_ab_pre, DC011_1_ab_pim, N_re_2_3, N_im_2_3, DC011_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_1_mul :
    N_entry_0_1 * N_entry_1_5 * N_entry_2_3 =
      ofLadj DC011_1_pre DC011_1_pim := by
  rw [DC011_1_ab_mul, N_entry_2_3, ofLadj_mul, DC011_1_pre_eq, DC011_1_pim_eq]

def DC011_2_ab_pre : Polynomial ℚ := C (138) + C (-144) * X + C (-42) * X ^ 2 + C ((469 / 2 : ℚ)) * X ^ 3 + C ((-901 / 2 : ℚ)) * X ^ 4 + C (125) * X ^ 5 + C (38) * X ^ 6 + C ((-1483 / 2 : ℚ)) * X ^ 7 + C ((601 / 2 : ℚ)) * X ^ 8 + C (-385) * X ^ 9 + C (-735) * X ^ 10 + C (294) * X ^ 11 + C (-591) * X ^ 12 + C (-343) * X ^ 13 + C (66) * X ^ 14 + C (-531) * X ^ 15 + C (-143) * X ^ 16 + C (-56) * X ^ 17 + C (-240) * X ^ 18
def DC011_2_ab_pim : Polynomial ℚ := C (159) + C (318) * X + C (-64) * X ^ 2 + C ((823 / 2 : ℚ)) * X ^ 3 + C ((601 / 2 : ℚ)) * X ^ 4 + C (-112) * X ^ 5 + C (781) * X ^ 6 + C ((409 / 2 : ℚ)) * X ^ 7 + C ((201 / 2 : ℚ)) * X ^ 8 + C (1183) * X ^ 9 + C (-57) * X ^ 10 + C (306) * X ^ 11 + C (669) * X ^ 12 + C (-189) * X ^ 13 + C (418) * X ^ 14 + C (345) * X ^ 15 + C (-67) * X ^ 16 + C (328) * X ^ 17 + C (80) * X ^ 18
def DC011_2_pre : Polynomial ℚ := C (-1128) + C (10800) * X + C (6504) * X ^ 2 + C (-1103) * X ^ 3 + C (36433) * X ^ 4 + C ((4831 / 2 : ℚ)) * X ^ 5 + C (14384) * X ^ 6 + C (72657) * X ^ 7 + C ((-19377 / 2 : ℚ)) * X ^ 8 + C ((127177 / 2 : ℚ)) * X ^ 9 + C ((201415 / 2 : ℚ)) * X ^ 10 + C (-18364) * X ^ 11 + C ((235875 / 2 : ℚ)) * X ^ 12 + C ((152515 / 2 : ℚ)) * X ^ 13 + C ((-5165 / 2 : ℚ)) * X ^ 14 + C (145838) * X ^ 15 + C (38322) * X ^ 16 + C ((60227 / 2 : ℚ)) * X ^ 17 + C (123894) * X ^ 18 + C (7190) * X ^ 19 + C (42699) * X ^ 20 + C (62324) * X ^ 21 + C (-466) * X ^ 22 + C (34294) * X ^ 23 + C (23526) * X ^ 24 + C (1187) * X ^ 25 + C (14280) * X ^ 26 + C (3760) * X ^ 27
def DC011_2_pim : Polynomial ℚ := C (-5154) + C (-8580) * X + C (4531) * X ^ 2 + C (-19472) * X ^ 3 + C (-11680) * X ^ 4 + C ((25797 / 2 : ℚ)) * X ^ 5 + C (-47566) * X ^ 6 + C (4609) * X ^ 7 + C ((18899 / 2 : ℚ)) * X ^ 8 + C ((-158121 / 2 : ℚ)) * X ^ 9 + C ((88103 / 2 : ℚ)) * X ^ 10 + C (-13542) * X ^ 11 + C ((-137855 / 2 : ℚ)) * X ^ 12 + C ((153709 / 2 : ℚ)) * X ^ 13 + C ((-96529 / 2 : ℚ)) * X ^ 14 + C (-26029) * X ^ 15 + C (73956) * X ^ 16 + C ((-122049 / 2 : ℚ)) * X ^ 17 + C (18604) * X ^ 18 + C (42388) * X ^ 19 + C (-38319) * X ^ 20 + C (31538) * X ^ 21 + C (10668) * X ^ 22 + C (-14138) * X ^ 23 + C (19938) * X ^ 24 + C (-157) * X ^ 25 + C (-1560) * X ^ 26 + C (5680) * X ^ 27
theorem DC011_2_ab_pre_eq :
    N_re_0_2 * N_re_1_3 - N_im_0_2 * N_im_1_3 =
      DC011_2_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_3, N_im_1_3, DC011_2_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_2_ab_pim_eq :
    N_re_0_2 * N_im_1_3 + N_im_0_2 * N_re_1_3 =
      DC011_2_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_3, N_im_1_3, DC011_2_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_2_ab_mul :
    N_entry_0_2 * N_entry_1_3 =
      ofLadj DC011_2_ab_pre DC011_2_ab_pim := by
  rw [N_entry_0_2, N_entry_1_3, ofLadj_mul,
    DC011_2_ab_pre_eq, DC011_2_ab_pim_eq]

theorem DC011_2_pre_eq :
    DC011_2_ab_pre * N_re_2_4 - DC011_2_ab_pim * N_im_2_4 =
      DC011_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_2_ab_pre, DC011_2_ab_pim, N_re_2_4, N_im_2_4, DC011_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_2_pim_eq :
    DC011_2_ab_pre * N_im_2_4 + DC011_2_ab_pim * N_re_2_4 =
      DC011_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_2_ab_pre, DC011_2_ab_pim, N_re_2_4, N_im_2_4, DC011_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_2_mul :
    N_entry_0_2 * N_entry_1_3 * N_entry_2_4 =
      ofLadj DC011_2_pre DC011_2_pim := by
  rw [DC011_2_ab_mul, N_entry_2_4, ofLadj_mul, DC011_2_pre_eq, DC011_2_pim_eq]

def DC011_3_ab_pre : Polynomial ℚ := C (52) + C (54) * X ^ 2 + C (91) * X ^ 3 + C (20) * X ^ 4 + C (104) * X ^ 5 + C (92) * X ^ 6 + C (4) * X ^ 7 + C (133) * X ^ 8 + C (40) * X ^ 9 + C (-8) * X ^ 10 + C (76) * X ^ 11 + C (-8) * X ^ 12 + C (-14) * X ^ 13 + C (42) * X ^ 14 + C (-32) * X ^ 15 + C (4) * X ^ 16 + C (16) * X ^ 17 + C (-16) * X ^ 18
def DC011_3_ab_pim : Polynomial ℚ := C (24) + C (48) * X + C (-14) * X ^ 2 + C (65) * X ^ 3 + C (36) * X ^ 4 + C (-30) * X ^ 5 + C (90) * X ^ 6 + C (-4) * X ^ 7 + C (-3) * X ^ 8 + C (132) * X ^ 9 + C (-12) * X ^ 10 + C (36) * X ^ 11 + C (84) * X ^ 12 + C (2) * X ^ 13 + C (58) * X ^ 14 + C (56) * X ^ 15 + C (20) * X ^ 16 + C (40) * X ^ 17 + C (32) * X ^ 18
def DC011_3_pre : Polynomial ℚ := C (-856) + C (1152) * X + C (-616) * X ^ 2 + C (-2266) * X ^ 3 + C (2806) * X ^ 4 + C (-4029) * X ^ 5 + C (-2697) * X ^ 6 + C (3891) * X ^ 7 + C (-9258) * X ^ 8 + C (914) * X ^ 9 + C (3924) * X ^ 10 + C (-10830) * X ^ 11 + C (6226) * X ^ 12 + C (1368) * X ^ 13 + C (-7332) * X ^ 14 + C (10559) * X ^ 15 + C (-333) * X ^ 16 + C (-721) * X ^ 17 + C (10866) * X ^ 18 + C (152) * X ^ 19 + C (2938) * X ^ 20 + C (6704) * X ^ 21 + C (380) * X ^ 22 + C (3250) * X ^ 23 + C (3100) * X ^ 24 + C (492) * X ^ 25 + C (1392) * X ^ 26 + C (944) * X ^ 27
def DC011_3_pim : Polynomial ℚ := C (-1152) + C (-2304) * X + C (-404) * X ^ 2 + C (-5698) * X ^ 3 + C (-4730) * X ^ 4 + C (-2271) * X ^ 5 + C (-12311) * X ^ 6 + C (-4877) * X ^ 7 + C (-6246) * X ^ 8 + C (-18914) * X ^ 9 + C (-2568) * X ^ 10 + C (-11508) * X ^ 11 + C (-17446) * X ^ 12 + C (-180) * X ^ 13 + C (-14316) * X ^ 14 + C (-11451) * X ^ 15 + C (347) * X ^ 16 + C (-13557) * X ^ 17 + C (-5238) * X ^ 18 + C (-480) * X ^ 19 + C (-8050) * X ^ 20 + C (-1268) * X ^ 21 + C (-1140) * X ^ 22 + C (-4014) * X ^ 23 + C (-52) * X ^ 24 + C (-860) * X ^ 25 + C (-1304) * X ^ 26 + C (192) * X ^ 27
theorem DC011_3_ab_pre_eq :
    N_re_0_0 * N_re_1_5 - N_im_0_0 * N_im_1_5 =
      DC011_3_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_5, N_im_1_5, DC011_3_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_3_ab_pim_eq :
    N_re_0_0 * N_im_1_5 + N_im_0_0 * N_re_1_5 =
      DC011_3_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_5, N_im_1_5, DC011_3_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_3_ab_mul :
    N_entry_0_0 * N_entry_1_5 =
      ofLadj DC011_3_ab_pre DC011_3_ab_pim := by
  rw [N_entry_0_0, N_entry_1_5, ofLadj_mul,
    DC011_3_ab_pre_eq, DC011_3_ab_pim_eq]

theorem DC011_3_pre_eq :
    DC011_3_ab_pre * N_re_2_4 - DC011_3_ab_pim * N_im_2_4 =
      DC011_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_3_ab_pre, DC011_3_ab_pim, N_re_2_4, N_im_2_4, DC011_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_3_pim_eq :
    DC011_3_ab_pre * N_im_2_4 + DC011_3_ab_pim * N_re_2_4 =
      DC011_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_3_ab_pre, DC011_3_ab_pim, N_re_2_4, N_im_2_4, DC011_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_3_mul :
    N_entry_0_0 * N_entry_1_5 * N_entry_2_4 =
      ofLadj DC011_3_pre DC011_3_pim := by
  rw [DC011_3_ab_mul, N_entry_2_4, ofLadj_mul, DC011_3_pre_eq, DC011_3_pim_eq]

def DC011_3_spre : Polynomial ℚ := C (856) + C (-1152) * X + C (616) * X ^ 2 + C (2266) * X ^ 3 + C (-2806) * X ^ 4 + C (4029) * X ^ 5 + C (2697) * X ^ 6 + C (-3891) * X ^ 7 + C (9258) * X ^ 8 + C (-914) * X ^ 9 + C (-3924) * X ^ 10 + C (10830) * X ^ 11 + C (-6226) * X ^ 12 + C (-1368) * X ^ 13 + C (7332) * X ^ 14 + C (-10559) * X ^ 15 + C (333) * X ^ 16 + C (721) * X ^ 17 + C (-10866) * X ^ 18 + C (-152) * X ^ 19 + C (-2938) * X ^ 20 + C (-6704) * X ^ 21 + C (-380) * X ^ 22 + C (-3250) * X ^ 23 + C (-3100) * X ^ 24 + C (-492) * X ^ 25 + C (-1392) * X ^ 26 + C (-944) * X ^ 27
def DC011_3_spim : Polynomial ℚ := C (1152) + C (2304) * X + C (404) * X ^ 2 + C (5698) * X ^ 3 + C (4730) * X ^ 4 + C (2271) * X ^ 5 + C (12311) * X ^ 6 + C (4877) * X ^ 7 + C (6246) * X ^ 8 + C (18914) * X ^ 9 + C (2568) * X ^ 10 + C (11508) * X ^ 11 + C (17446) * X ^ 12 + C (180) * X ^ 13 + C (14316) * X ^ 14 + C (11451) * X ^ 15 + C (-347) * X ^ 16 + C (13557) * X ^ 17 + C (5238) * X ^ 18 + C (480) * X ^ 19 + C (8050) * X ^ 20 + C (1268) * X ^ 21 + C (1140) * X ^ 22 + C (4014) * X ^ 23 + C (52) * X ^ 24 + C (860) * X ^ 25 + C (1304) * X ^ 26 + C (-192) * X ^ 27
theorem DC011_3_spre_eq : -DC011_3_pre = DC011_3_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_3_pre, DC011_3_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_3_spim_eq : -DC011_3_pim = DC011_3_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_3_pim, DC011_3_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_3_smul :
    -(N_entry_0_0 * N_entry_1_5 * N_entry_2_4) =
      ofLadj DC011_3_spre DC011_3_spim := by
  rw [DC011_3_mul, ofLadj_neg, DC011_3_spre_eq, DC011_3_spim_eq]

def DC011_4_ab_pre : Polynomial ℚ := C (223) + C (-384) * X + C (-151) * X ^ 2 + C ((801 / 2 : ℚ)) * X ^ 3 + C ((-2019 / 2 : ℚ)) * X ^ 4 + C (305) * X ^ 5 + C ((339 / 2 : ℚ)) * X ^ 6 + C (-1390) * X ^ 7 + C (906) * X ^ 8 + C (-610) * X ^ 9 + C (-1391) * X ^ 10 + C (881) * X ^ 11 + C (-1007) * X ^ 12 + C (-459) * X ^ 13 + C ((1011 / 2 : ℚ)) * X ^ 14 + C ((-1601 / 2 : ℚ)) * X ^ 15 + C ((-45 / 2 : ℚ)) * X ^ 16 + C (113) * X ^ 17 + C (-420) * X ^ 18
def DC011_4_ab_pim : Polynomial ℚ := C (364) + C (728) * X + C (79) * X ^ 2 + C ((2475 / 2 : ℚ)) * X ^ 3 + C ((2177 / 2 : ℚ)) * X ^ 4 + C (322) * X ^ 5 + C ((4535 / 2 : ℚ)) * X ^ 6 + C (1016) * X ^ 7 + C (844) * X ^ 8 + C (3174) * X ^ 9 + C (538) * X ^ 10 + C (1336) * X ^ 11 + C (2134) * X ^ 12 + C (147) * X ^ 13 + C ((2637 / 2 : ℚ)) * X ^ 14 + C ((2111 / 2 : ℚ)) * X ^ 15 + C ((29 / 2 : ℚ)) * X ^ 16 + C (796) * X ^ 17 + C (240) * X ^ 18
def DC011_4_pre : Polynomial ℚ := C (-538) + C (25920) * X + C (19230) * X ^ 2 + C (11925) * X ^ 3 + C (95745) * X ^ 4 + C (28599) * X ^ 5 + C (65341) * X ^ 6 + C (190395) * X ^ 7 + C (20040) * X ^ 8 + C (188575) * X ^ 9 + C (268101) * X ^ 10 + C (18996) * X ^ 11 + C (319625) * X ^ 12 + C (225933) * X ^ 13 + C (51168) * X ^ 14 + C (369846) * X ^ 15 + C (128498) * X ^ 16 + C (101356) * X ^ 17 + C (305188) * X ^ 18 + C (44548) * X ^ 19 + C (111128) * X ^ 20 + C (154170) * X ^ 21 + C (7768) * X ^ 22 + C (76726) * X ^ 23 + C (54540) * X ^ 24 + C (1495) * X ^ 25 + C (29992) * X ^ 26 + C (9600) * X ^ 27
def DC011_4_pim : Polynomial ℚ := C (-10684) + C (-16760) * X + C (6824) * X ^ 2 + C (-47467) * X ^ 3 + C (-32827) * X ^ 4 + C (8171) * X ^ 5 + C (-127477) * X ^ 6 + C (-22559) * X ^ 7 + C (-29548) * X ^ 8 + C (-225173) * X ^ 9 + C (29973) * X ^ 10 + C (-110610) * X ^ 11 + C (-236387) * X ^ 12 + C (72785) * X ^ 13 + C (-205700) * X ^ 14 + C (-158788) * X ^ 15 + C (63268) * X ^ 16 + C (-227578) * X ^ 17 + C (-47536) * X ^ 18 + C (21274) * X ^ 19 + C (-149232) * X ^ 20 + C (13390) * X ^ 21 + C (-16014) * X ^ 22 + C (-64832) * X ^ 23 + C (20180) * X ^ 24 + C (-13175) * X ^ 25 + C (-12906) * X ^ 26 + C (9000) * X ^ 27
theorem DC011_4_ab_pre_eq :
    N_re_0_1 * N_re_1_3 - N_im_0_1 * N_im_1_3 =
      DC011_4_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_3, N_im_1_3, DC011_4_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_4_ab_pim_eq :
    N_re_0_1 * N_im_1_3 + N_im_0_1 * N_re_1_3 =
      DC011_4_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_3, N_im_1_3, DC011_4_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_4_ab_mul :
    N_entry_0_1 * N_entry_1_3 =
      ofLadj DC011_4_ab_pre DC011_4_ab_pim := by
  rw [N_entry_0_1, N_entry_1_3, ofLadj_mul,
    DC011_4_ab_pre_eq, DC011_4_ab_pim_eq]

theorem DC011_4_pre_eq :
    DC011_4_ab_pre * N_re_2_5 - DC011_4_ab_pim * N_im_2_5 =
      DC011_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_4_ab_pre, DC011_4_ab_pim, N_re_2_5, N_im_2_5, DC011_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_4_pim_eq :
    DC011_4_ab_pre * N_im_2_5 + DC011_4_ab_pim * N_re_2_5 =
      DC011_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_4_ab_pre, DC011_4_ab_pim, N_re_2_5, N_im_2_5, DC011_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_4_mul :
    N_entry_0_1 * N_entry_1_3 * N_entry_2_5 =
      ofLadj DC011_4_pre DC011_4_pim := by
  rw [DC011_4_ab_mul, N_entry_2_5, ofLadj_mul, DC011_4_pre_eq, DC011_4_pim_eq]

def DC011_4_spre : Polynomial ℚ := C (538) + C (-25920) * X + C (-19230) * X ^ 2 + C (-11925) * X ^ 3 + C (-95745) * X ^ 4 + C (-28599) * X ^ 5 + C (-65341) * X ^ 6 + C (-190395) * X ^ 7 + C (-20040) * X ^ 8 + C (-188575) * X ^ 9 + C (-268101) * X ^ 10 + C (-18996) * X ^ 11 + C (-319625) * X ^ 12 + C (-225933) * X ^ 13 + C (-51168) * X ^ 14 + C (-369846) * X ^ 15 + C (-128498) * X ^ 16 + C (-101356) * X ^ 17 + C (-305188) * X ^ 18 + C (-44548) * X ^ 19 + C (-111128) * X ^ 20 + C (-154170) * X ^ 21 + C (-7768) * X ^ 22 + C (-76726) * X ^ 23 + C (-54540) * X ^ 24 + C (-1495) * X ^ 25 + C (-29992) * X ^ 26 + C (-9600) * X ^ 27
def DC011_4_spim : Polynomial ℚ := C (10684) + C (16760) * X + C (-6824) * X ^ 2 + C (47467) * X ^ 3 + C (32827) * X ^ 4 + C (-8171) * X ^ 5 + C (127477) * X ^ 6 + C (22559) * X ^ 7 + C (29548) * X ^ 8 + C (225173) * X ^ 9 + C (-29973) * X ^ 10 + C (110610) * X ^ 11 + C (236387) * X ^ 12 + C (-72785) * X ^ 13 + C (205700) * X ^ 14 + C (158788) * X ^ 15 + C (-63268) * X ^ 16 + C (227578) * X ^ 17 + C (47536) * X ^ 18 + C (-21274) * X ^ 19 + C (149232) * X ^ 20 + C (-13390) * X ^ 21 + C (16014) * X ^ 22 + C (64832) * X ^ 23 + C (-20180) * X ^ 24 + C (13175) * X ^ 25 + C (12906) * X ^ 26 + C (-9000) * X ^ 27
theorem DC011_4_spre_eq : -DC011_4_pre = DC011_4_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_4_pre, DC011_4_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_4_spim_eq : -DC011_4_pim = DC011_4_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_4_pim, DC011_4_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_4_smul :
    -(N_entry_0_1 * N_entry_1_3 * N_entry_2_5) =
      ofLadj DC011_4_spre DC011_4_spim := by
  rw [DC011_4_mul, ofLadj_neg, DC011_4_spre_eq, DC011_4_spim_eq]

def DC011_5_ab_pre : Polynomial ℚ := C (54) + C (-72) * X + C (-36) * X ^ 2 + C (84) * X ^ 3 + C (-204) * X ^ 4 + C (52) * X ^ 5 + C (12) * X ^ 6 + C (-324) * X ^ 7 + C (116) * X ^ 8 + C (-188) * X ^ 9 + C (-356) * X ^ 10 + C (96) * X ^ 11 + C (-284) * X ^ 12 + C (-152) * X ^ 13 + C (32) * X ^ 14 + C (-216) * X ^ 15 + C (-48) * X ^ 16 + C (-8) * X ^ 17 + C (-96) * X ^ 18
def DC011_5_ab_pim : Polynomial ℚ := C (72) + C (144) * X + C (-12) * X ^ 2 + C (204) * X ^ 3 + C (160) * X ^ 4 + C (-14) * X ^ 5 + C (374) * X ^ 6 + C (120) * X ^ 7 + C (72) * X ^ 8 + C (536) * X ^ 9 + C (12) * X ^ 10 + C (180) * X ^ 11 + C (348) * X ^ 12 + C (-20) * X ^ 13 + C (228) * X ^ 14 + C (192) * X ^ 15 + C (-8) * X ^ 16 + C (152) * X ^ 17 + C (32) * X ^ 18
def DC011_5_pre : Polynomial ℚ := C (-1359) + C (10836) * X + C (6891) * X ^ 2 + C (-381) * X ^ 3 + C (37804) * X ^ 4 + C (3635) * X ^ 5 + C (16337) * X ^ 6 + C (75151) * X ^ 7 + C (-7507) * X ^ 8 + C (66964) * X ^ 9 + C (104996) * X ^ 10 + C (-12652) * X ^ 11 + C (125144) * X ^ 12 + C (83619) * X ^ 13 + C (5204) * X ^ 14 + C (153345) * X ^ 15 + C (45960) * X ^ 16 + C (36746) * X ^ 17 + C (129686) * X ^ 18 + C (13718) * X ^ 19 + C (47826) * X ^ 20 + C (66438) * X ^ 21 + C (2828) * X ^ 22 + C (35454) * X ^ 23 + C (24280) * X ^ 24 + C (1388) * X ^ 25 + C (13688) * X ^ 26 + C (3488) * X ^ 27
def DC011_5_pim : Polynomial ℚ := C (-5337) + C (-8982) * X + C (4161) * X ^ 2 + C (-20763) * X ^ 3 + C (-13618) * X ^ 4 + C (9949) * X ^ 5 + C (-52157) * X ^ 6 + C (-611) * X ^ 7 + C (2951) * X ^ 8 + C (-86816) * X ^ 9 + C (36008) * X ^ 10 + C (-22938) * X ^ 11 + C (-79432) * X ^ 12 + C (64771) * X ^ 13 + C (-61084) * X ^ 14 + C (-39383) * X ^ 15 + C (60572) * X ^ 16 + C (-73162) * X ^ 17 + C (6846) * X ^ 18 + C (31854) * X ^ 19 + C (-47250) * X ^ 20 + C (22490) * X ^ 21 + C (3308) * X ^ 22 + C (-20018) * X ^ 23 + C (15200) * X ^ 24 + C (-2892) * X ^ 25 + C (-3168) * X ^ 26 + C (4864) * X ^ 27
theorem DC011_5_ab_pre_eq :
    N_re_0_2 * N_re_1_4 - N_im_0_2 * N_im_1_4 =
      DC011_5_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_4, N_im_1_4, DC011_5_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_5_ab_pim_eq :
    N_re_0_2 * N_im_1_4 + N_im_0_2 * N_re_1_4 =
      DC011_5_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_4, N_im_1_4, DC011_5_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_5_ab_mul :
    N_entry_0_2 * N_entry_1_4 =
      ofLadj DC011_5_ab_pre DC011_5_ab_pim := by
  rw [N_entry_0_2, N_entry_1_4, ofLadj_mul,
    DC011_5_ab_pre_eq, DC011_5_ab_pim_eq]

theorem DC011_5_pre_eq :
    DC011_5_ab_pre * N_re_2_3 - DC011_5_ab_pim * N_im_2_3 =
      DC011_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_5_ab_pre, DC011_5_ab_pim, N_re_2_3, N_im_2_3, DC011_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_5_pim_eq :
    DC011_5_ab_pre * N_im_2_3 + DC011_5_ab_pim * N_re_2_3 =
      DC011_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_5_ab_pre, DC011_5_ab_pim, N_re_2_3, N_im_2_3, DC011_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_5_mul :
    N_entry_0_2 * N_entry_1_4 * N_entry_2_3 =
      ofLadj DC011_5_pre DC011_5_pim := by
  rw [DC011_5_ab_mul, N_entry_2_3, ofLadj_mul, DC011_5_pre_eq, DC011_5_pim_eq]

def DC011_5_spre : Polynomial ℚ := C (1359) + C (-10836) * X + C (-6891) * X ^ 2 + C (381) * X ^ 3 + C (-37804) * X ^ 4 + C (-3635) * X ^ 5 + C (-16337) * X ^ 6 + C (-75151) * X ^ 7 + C (7507) * X ^ 8 + C (-66964) * X ^ 9 + C (-104996) * X ^ 10 + C (12652) * X ^ 11 + C (-125144) * X ^ 12 + C (-83619) * X ^ 13 + C (-5204) * X ^ 14 + C (-153345) * X ^ 15 + C (-45960) * X ^ 16 + C (-36746) * X ^ 17 + C (-129686) * X ^ 18 + C (-13718) * X ^ 19 + C (-47826) * X ^ 20 + C (-66438) * X ^ 21 + C (-2828) * X ^ 22 + C (-35454) * X ^ 23 + C (-24280) * X ^ 24 + C (-1388) * X ^ 25 + C (-13688) * X ^ 26 + C (-3488) * X ^ 27
def DC011_5_spim : Polynomial ℚ := C (5337) + C (8982) * X + C (-4161) * X ^ 2 + C (20763) * X ^ 3 + C (13618) * X ^ 4 + C (-9949) * X ^ 5 + C (52157) * X ^ 6 + C (611) * X ^ 7 + C (-2951) * X ^ 8 + C (86816) * X ^ 9 + C (-36008) * X ^ 10 + C (22938) * X ^ 11 + C (79432) * X ^ 12 + C (-64771) * X ^ 13 + C (61084) * X ^ 14 + C (39383) * X ^ 15 + C (-60572) * X ^ 16 + C (73162) * X ^ 17 + C (-6846) * X ^ 18 + C (-31854) * X ^ 19 + C (47250) * X ^ 20 + C (-22490) * X ^ 21 + C (-3308) * X ^ 22 + C (20018) * X ^ 23 + C (-15200) * X ^ 24 + C (2892) * X ^ 25 + C (3168) * X ^ 26 + C (-4864) * X ^ 27
theorem DC011_5_spre_eq : -DC011_5_pre = DC011_5_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_5_pre, DC011_5_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_5_spim_eq : -DC011_5_pim = DC011_5_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_5_pim, DC011_5_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_5_smul :
    -(N_entry_0_2 * N_entry_1_4 * N_entry_2_3) =
      ofLadj DC011_5_spre DC011_5_spim := by
  rw [DC011_5_mul, ofLadj_neg, DC011_5_spre_eq, DC011_5_spim_eq]

def DC011_6_ab_pre : Polynomial ℚ := C (342) + C (-304) * X + C (98) * X ^ 2 + C ((1217 / 2 : ℚ)) * X ^ 3 + C ((-1545 / 2 : ℚ)) * X ^ 4 + C (528) * X ^ 5 + C ((793 / 2 : ℚ)) * X ^ 6 + C (-1216) * X ^ 7 + C (1114) * X ^ 8 + C (-405) * X ^ 9 + C (-1185) * X ^ 10 + C (967) * X ^ 11 + C (-881) * X ^ 12 + C (-503) * X ^ 13 + C ((1011 / 2 : ℚ)) * X ^ 14 + C ((-1659 / 2 : ℚ)) * X ^ 15 + C ((-73 / 2 : ℚ)) * X ^ 16 + C (95) * X ^ 17 + C (-386) * X ^ 18
def DC011_6_ab_pim : Polynomial ℚ := C (361) + C (722) * X + C ((2259 / 2 : ℚ)) * X ^ 3 + C ((1879 / 2 : ℚ)) * X ^ 4 + C (65) * X ^ 5 + C ((4153 / 2 : ℚ)) * X ^ 6 + C (700) * X ^ 7 + C (634) * X ^ 8 + C (2965) * X ^ 9 + C (330) * X ^ 10 + C (1132) * X ^ 11 + C (1934) * X ^ 12 + C (21) * X ^ 13 + C ((2445 / 2 : ℚ)) * X ^ 14 + C ((1997 / 2 : ℚ)) * X ^ 15 + C ((129 / 2 : ℚ)) * X ^ 16 + C (780) * X ^ 17 + C (348) * X ^ 18
def DC011_6_pre : Polynomial ℚ := C (-3192) + C (24016) * X + C (11714) * X ^ 2 + C (851) * X ^ 3 + C (82865) * X ^ 4 + C (6609) * X ^ 5 + C (39631) * X ^ 6 + C (162217) * X ^ 7 + C (-20036) * X ^ 8 + C (150671) * X ^ 9 + C (224039) * X ^ 10 + C (-28260) * X ^ 11 + C (273859) * X ^ 12 + C (182309) * X ^ 13 + C (9378) * X ^ 14 + C (333272) * X ^ 15 + C (97858) * X ^ 16 + C (76972) * X ^ 17 + C (283324) * X ^ 18 + C (34504) * X ^ 19 + C (98930) * X ^ 20 + C (148148) * X ^ 21 + C (7528) * X ^ 22 + C (74312) * X ^ 23 + C (55578) * X ^ 24 + C (4239) * X ^ 25 + C (29404) * X ^ 26 + C (12136) * X ^ 27
def DC011_6_pim : Polynomial ℚ := C (-12046) + C (-20444) * X + C (3916) * X ^ 2 + C (-55669) * X ^ 3 + C (-39639) * X ^ 4 + C (2249) * X ^ 5 + C (-138463) * X ^ 6 + C (-27217) * X ^ 7 + C (-36496) * X ^ 8 + C (-236017) * X ^ 9 + C (26563) * X ^ 10 + C (-117682) * X ^ 11 + C (-238505) * X ^ 12 + C (73709) * X ^ 13 + C (-202594) * X ^ 14 + C (-154614) * X ^ 15 + C (66424) * X ^ 16 + C (-221186) * X ^ 17 + C (-47432) * X ^ 18 + C (23662) * X ^ 19 + C (-142998) * X ^ 20 + C (12268) * X ^ 21 + C (-12134) * X ^ 22 + C (-63606) * X ^ 23 + C (17666) * X ^ 24 + C (-12627) * X ^ 25 + C (-14822) * X ^ 26 + C (7252) * X ^ 27
theorem DC011_6_ab_pre_eq :
    N_re_0_3 * N_re_1_1 - N_im_0_3 * N_im_1_1 =
      DC011_6_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_1, N_im_1_1, DC011_6_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_6_ab_pim_eq :
    N_re_0_3 * N_im_1_1 + N_im_0_3 * N_re_1_1 =
      DC011_6_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_1, N_im_1_1, DC011_6_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_6_ab_mul :
    N_entry_0_3 * N_entry_1_1 =
      ofLadj DC011_6_ab_pre DC011_6_ab_pim := by
  rw [N_entry_0_3, N_entry_1_1, ofLadj_mul,
    DC011_6_ab_pre_eq, DC011_6_ab_pim_eq]

theorem DC011_6_pre_eq :
    DC011_6_ab_pre * N_re_2_5 - DC011_6_ab_pim * N_im_2_5 =
      DC011_6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_6_ab_pre, DC011_6_ab_pim, N_re_2_5, N_im_2_5, DC011_6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_6_pim_eq :
    DC011_6_ab_pre * N_im_2_5 + DC011_6_ab_pim * N_re_2_5 =
      DC011_6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_6_ab_pre, DC011_6_ab_pim, N_re_2_5, N_im_2_5, DC011_6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_6_mul :
    N_entry_0_3 * N_entry_1_1 * N_entry_2_5 =
      ofLadj DC011_6_pre DC011_6_pim := by
  rw [DC011_6_ab_mul, N_entry_2_5, ofLadj_mul, DC011_6_pre_eq, DC011_6_pim_eq]

def DC011_7_ab_pre : Polynomial ℚ := C (72) + C (-72) * X + C (24) * X ^ 2 + C (124) * X ^ 3 + C (-152) * X ^ 4 + C (120) * X ^ 5 + C (100) * X ^ 6 + C (-208) * X ^ 7 + C (256) * X ^ 8 + C (-48) * X ^ 9 + C (-216) * X ^ 10 + C (216) * X ^ 11 + C (-144) * X ^ 12 + C (-72) * X ^ 13 + C (132) * X ^ 14 + C (-128) * X ^ 15 + C (24) * X ^ 16 + C (44) * X ^ 17 + C (-72) * X ^ 18
def DC011_7_ab_pim : Polynomial ℚ := C (84) + C (168) * X + C (24) * X ^ 2 + C (284) * X ^ 3 + C (256) * X ^ 4 + C (84) * X ^ 5 + C (496) * X ^ 6 + C (212) * X ^ 7 + C (216) * X ^ 8 + C (680) * X ^ 9 + C (156) * X ^ 10 + C (312) * X ^ 11 + C (468) * X ^ 12 + C (88) * X ^ 13 + C (292) * X ^ 14 + C (240) * X ^ 15 + C (40) * X ^ 16 + C (172) * X ^ 17 + C (84) * X ^ 18
def DC011_7_pre : Polynomial ℚ := C (-2094) + C (11964) * X + C (5046) * X ^ 2 + C (298) * X ^ 3 + C (41008) * X ^ 4 + C (3678) * X ^ 5 + C (19806) * X ^ 6 + C (77880) * X ^ 7 + C (-8878) * X ^ 8 + C (72646) * X ^ 9 + C (106576) * X ^ 10 + C (-10104) * X ^ 11 + C (129996) * X ^ 12 + C (88048) * X ^ 13 + C (7994) * X ^ 14 + C (153914) * X ^ 15 + C (46790) * X ^ 16 + C (36668) * X ^ 17 + C (130100) * X ^ 18 + C (18562) * X ^ 19 + C (45436) * X ^ 20 + C (68052) * X ^ 21 + C (4528) * X ^ 22 + C (32668) * X ^ 23 + C (24988) * X ^ 24 + C (1392) * X ^ 25 + C (13058) * X ^ 26 + C (6006) * X ^ 27
def DC011_7_pim : Polynomial ℚ := C (-6438) + C (-11184) * X + C (678) * X ^ 2 + C (-30786) * X ^ 3 + C (-23860) * X ^ 4 + C (-4922) * X ^ 5 + C (-74926) * X ^ 6 + C (-22940) * X ^ 7 + C (-31166) * X ^ 8 + C (-127162) * X ^ 9 + C (-5736) * X ^ 10 + C (-75560) * X ^ 11 + C (-132604) * X ^ 12 + C (9404) * X ^ 13 + C (-115898) * X ^ 14 + C (-94134) * X ^ 15 + C (6470) * X ^ 16 + C (-121280) * X ^ 17 + C (-41940) * X ^ 18 + C (-5190) * X ^ 19 + C (-77784) * X ^ 20 + C (-6964) * X ^ 21 + C (-14032) * X ^ 22 + C (-35572) * X ^ 23 + C (2804) * X ^ 24 + C (-9020) * X ^ 25 + C (-9186) * X ^ 26 + C (2598) * X ^ 27
theorem DC011_7_ab_pre_eq :
    N_re_0_4 * N_re_1_2 - N_im_0_4 * N_im_1_2 =
      DC011_7_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_2, N_im_1_2, DC011_7_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_7_ab_pim_eq :
    N_re_0_4 * N_im_1_2 + N_im_0_4 * N_re_1_2 =
      DC011_7_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_2, N_im_1_2, DC011_7_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_7_ab_mul :
    N_entry_0_4 * N_entry_1_2 =
      ofLadj DC011_7_ab_pre DC011_7_ab_pim := by
  rw [N_entry_0_4, N_entry_1_2, ofLadj_mul,
    DC011_7_ab_pre_eq, DC011_7_ab_pim_eq]

theorem DC011_7_pre_eq :
    DC011_7_ab_pre * N_re_2_3 - DC011_7_ab_pim * N_im_2_3 =
      DC011_7_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_7_ab_pre, DC011_7_ab_pim, N_re_2_3, N_im_2_3, DC011_7_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_7_pim_eq :
    DC011_7_ab_pre * N_im_2_3 + DC011_7_ab_pim * N_re_2_3 =
      DC011_7_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_7_ab_pre, DC011_7_ab_pim, N_re_2_3, N_im_2_3, DC011_7_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_7_mul :
    N_entry_0_4 * N_entry_1_2 * N_entry_2_3 =
      ofLadj DC011_7_pre DC011_7_pim := by
  rw [DC011_7_ab_mul, N_entry_2_3, ofLadj_mul, DC011_7_pre_eq, DC011_7_pim_eq]

def DC011_8_ab_pre : Polynomial ℚ := C (12) + C (-24) * X + C (-18) * X ^ 2 + C (22) * X ^ 3 + C (-50) * X ^ 4 + C (34) * X ^ 5 + C (20) * X ^ 6 + C (-46) * X ^ 7 + C (70) * X ^ 8 + C (-20) * X ^ 9 + C (-64) * X ^ 10 + C (48) * X ^ 11 + C (-40) * X ^ 12 + C (-2) * X ^ 13 + C (48) * X ^ 14 + C (-14) * X ^ 15 + C (14) * X ^ 16 + C (28) * X ^ 17 + C (-18) * X ^ 18
def DC011_8_ab_pim : Polynomial ℚ := C (24) + C (48) * X + C (18) * X ^ 2 + C (102) * X ^ 3 + C (86) * X ^ 4 + C (58) * X ^ 5 + C (152) * X ^ 6 + C (94) * X ^ 7 + C (70) * X ^ 8 + C (196) * X ^ 9 + C (64) * X ^ 10 + C (108) * X ^ 11 + C (152) * X ^ 12 + C (50) * X ^ 13 + C (92) * X ^ 14 + C (78) * X ^ 15 + C (10) * X ^ 16 + C (44) * X ^ 17 + C (6) * X ^ 18
def DC011_8_pre : Polynomial ℚ := C (24) + C (1680) * X + C (1632) * X ^ 2 + C (1472) * X ^ 3 + C (6578) * X ^ 4 + C (2848) * X ^ 5 + C (5498) * X ^ 6 + C (12022) * X ^ 7 + C (3160) * X ^ 8 + C (12510) * X ^ 9 + C (16740) * X ^ 10 + C (4234) * X ^ 11 + C (20016) * X ^ 12 + C (14692) * X ^ 13 + C (5940) * X ^ 14 + C (21326) * X ^ 15 + C (9274) * X ^ 16 + C (6906) * X ^ 17 + C (17232) * X ^ 18 + C (3960) * X ^ 19 + C (6610) * X ^ 20 + C (8664) * X ^ 21 + C (802) * X ^ 22 + C (3708) * X ^ 23 + C (2796) * X ^ 24 + C (-292) * X ^ 25 + C (1350) * X ^ 26 + C (282) * X ^ 27
def DC011_8_pim : Polynomial ℚ := C (-672) + C (-1056) * X + C (252) * X ^ 2 + C (-3204) * X ^ 3 + C (-2582) * X ^ 4 + C (-932) * X ^ 5 + C (-8746) * X ^ 6 + C (-3438) * X ^ 7 + C (-4576) * X ^ 8 + C (-15042) * X ^ 9 + C (-1912) * X ^ 10 + C (-9726) * X ^ 11 + C (-16368) * X ^ 12 + C (-1116) * X ^ 13 + C (-15240) * X ^ 14 + C (-12938) * X ^ 15 + C (-1498) * X ^ 16 + C (-15650) * X ^ 17 + C (-6352) * X ^ 18 + C (-2084) * X ^ 19 + C (-10378) * X ^ 20 + C (-2056) * X ^ 21 + C (-2802) * X ^ 22 + C (-5008) * X ^ 23 + C (-116) * X ^ 24 + C (-1296) * X ^ 25 + C (-1090) * X ^ 26 + C (426) * X ^ 27
theorem DC011_8_ab_pre_eq :
    N_re_0_5 * N_re_1_0 - N_im_0_5 * N_im_1_0 =
      DC011_8_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_0, N_im_1_0, DC011_8_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_8_ab_pim_eq :
    N_re_0_5 * N_im_1_0 + N_im_0_5 * N_re_1_0 =
      DC011_8_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_0, N_im_1_0, DC011_8_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_8_ab_mul :
    N_entry_0_5 * N_entry_1_0 =
      ofLadj DC011_8_ab_pre DC011_8_ab_pim := by
  rw [N_entry_0_5, N_entry_1_0, ofLadj_mul,
    DC011_8_ab_pre_eq, DC011_8_ab_pim_eq]

theorem DC011_8_pre_eq :
    DC011_8_ab_pre * N_re_2_4 - DC011_8_ab_pim * N_im_2_4 =
      DC011_8_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_8_ab_pre, DC011_8_ab_pim, N_re_2_4, N_im_2_4, DC011_8_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_8_pim_eq :
    DC011_8_ab_pre * N_im_2_4 + DC011_8_ab_pim * N_re_2_4 =
      DC011_8_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_8_ab_pre, DC011_8_ab_pim, N_re_2_4, N_im_2_4, DC011_8_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_8_mul :
    N_entry_0_5 * N_entry_1_0 * N_entry_2_4 =
      ofLadj DC011_8_pre DC011_8_pim := by
  rw [DC011_8_ab_mul, N_entry_2_4, ofLadj_mul, DC011_8_pre_eq, DC011_8_pim_eq]

def DC011_9_ab_pre : Polynomial ℚ := C (133) + C (-228) * X + C (-59) * X ^ 2 + C (158) * X ^ 3 + C (-507) * X ^ 4 + C (127) * X ^ 5 + C (93) * X ^ 6 + C (-583) * X ^ 7 + C (525) * X ^ 8 + C (-156) * X ^ 9 + C (-504) * X ^ 10 + C (526) * X ^ 11 + C (-276) * X ^ 12 + C (-97) * X ^ 13 + C (367) * X ^ 14 + C (-242) * X ^ 15 + C (81) * X ^ 16 + C (115) * X ^ 17 + C (-166) * X ^ 18
def DC011_9_ab_pim : Polynomial ℚ := C (209) + C (418) * X + C (119) * X ^ 2 + C (758) * X ^ 3 + C (743) * X ^ 4 + C (423) * X ^ 5 + C (1417) * X ^ 6 + C (825) * X ^ 7 + C (829) * X ^ 8 + C (1906) * X ^ 9 + C (672) * X ^ 10 + C (982) * X ^ 11 + C (1292) * X ^ 12 + C (357) * X ^ 13 + C (795) * X ^ 14 + C (626) * X ^ 15 + C (127) * X ^ 16 + C (415) * X ^ 17 + C (188) * X ^ 18
def DC011_9_pre : Polynomial ℚ := C (-418) + C (15048) * X + C (11409) * X ^ 2 + C (10623) * X ^ 3 + C (55594) * X ^ 4 + C (24531) * X ^ 5 + C (47160) * X ^ 6 + C (110385) * X ^ 7 + C (31378) * X ^ 8 + C (117817) * X ^ 9 + C (156388) * X ^ 10 + C (42722) * X ^ 11 + C (182701) * X ^ 12 + C (139941) * X ^ 13 + C (57709) * X ^ 14 + C (199154) * X ^ 15 + C (87142) * X ^ 16 + C (70563) * X ^ 17 + C (158586) * X ^ 18 + C (39608) * X ^ 19 + C (61373) * X ^ 20 + C (79245) * X ^ 21 + C (11322) * X ^ 22 + C (37884) * X ^ 23 + C (27840) * X ^ 24 + C (2654) * X ^ 25 + C (14223) * X ^ 26 + C (6050) * X ^ 27
def DC011_9_pim : Polynomial ℚ := C (-6194) + C (-9652) * X + C (2365) * X ^ 2 + C (-27587) * X ^ 3 + C (-20306) * X ^ 4 + C (-2577) * X ^ 5 + C (-72316) * X ^ 6 + C (-23433) * X ^ 7 + C (-33498) * X ^ 8 + C (-130663) * X ^ 9 + C (-13036) * X ^ 10 + C (-84496) * X ^ 11 + C (-144603) * X ^ 12 + C (-5435) * X ^ 13 + C (-132843) * X ^ 14 + C (-112376) * X ^ 15 + C (-11186) * X ^ 16 + C (-138489) * X ^ 17 + C (-56274) * X ^ 18 + C (-17738) * X ^ 19 + C (-88885) * X ^ 20 + C (-14571) * X ^ 21 + C (-20094) * X ^ 22 + C (-39706) * X ^ 23 + C (1050) * X ^ 24 + C (-9902) * X ^ 25 + C (-9179) * X ^ 26 + C (3000) * X ^ 27
theorem DC011_9_ab_pre_eq :
    N_re_0_3 * N_re_1_2 - N_im_0_3 * N_im_1_2 =
      DC011_9_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_2, N_im_1_2, DC011_9_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_9_ab_pim_eq :
    N_re_0_3 * N_im_1_2 + N_im_0_3 * N_re_1_2 =
      DC011_9_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_2, N_im_1_2, DC011_9_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_9_ab_mul :
    N_entry_0_3 * N_entry_1_2 =
      ofLadj DC011_9_ab_pre DC011_9_ab_pim := by
  rw [N_entry_0_3, N_entry_1_2, ofLadj_mul,
    DC011_9_ab_pre_eq, DC011_9_ab_pim_eq]

theorem DC011_9_pre_eq :
    DC011_9_ab_pre * N_re_2_4 - DC011_9_ab_pim * N_im_2_4 =
      DC011_9_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_9_ab_pre, DC011_9_ab_pim, N_re_2_4, N_im_2_4, DC011_9_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_9_pim_eq :
    DC011_9_ab_pre * N_im_2_4 + DC011_9_ab_pim * N_re_2_4 =
      DC011_9_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_9_ab_pre, DC011_9_ab_pim, N_re_2_4, N_im_2_4, DC011_9_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_9_mul :
    N_entry_0_3 * N_entry_1_2 * N_entry_2_4 =
      ofLadj DC011_9_pre DC011_9_pim := by
  rw [DC011_9_ab_mul, N_entry_2_4, ofLadj_mul, DC011_9_pre_eq, DC011_9_pim_eq]

def DC011_9_spre : Polynomial ℚ := C (418) + C (-15048) * X + C (-11409) * X ^ 2 + C (-10623) * X ^ 3 + C (-55594) * X ^ 4 + C (-24531) * X ^ 5 + C (-47160) * X ^ 6 + C (-110385) * X ^ 7 + C (-31378) * X ^ 8 + C (-117817) * X ^ 9 + C (-156388) * X ^ 10 + C (-42722) * X ^ 11 + C (-182701) * X ^ 12 + C (-139941) * X ^ 13 + C (-57709) * X ^ 14 + C (-199154) * X ^ 15 + C (-87142) * X ^ 16 + C (-70563) * X ^ 17 + C (-158586) * X ^ 18 + C (-39608) * X ^ 19 + C (-61373) * X ^ 20 + C (-79245) * X ^ 21 + C (-11322) * X ^ 22 + C (-37884) * X ^ 23 + C (-27840) * X ^ 24 + C (-2654) * X ^ 25 + C (-14223) * X ^ 26 + C (-6050) * X ^ 27
def DC011_9_spim : Polynomial ℚ := C (6194) + C (9652) * X + C (-2365) * X ^ 2 + C (27587) * X ^ 3 + C (20306) * X ^ 4 + C (2577) * X ^ 5 + C (72316) * X ^ 6 + C (23433) * X ^ 7 + C (33498) * X ^ 8 + C (130663) * X ^ 9 + C (13036) * X ^ 10 + C (84496) * X ^ 11 + C (144603) * X ^ 12 + C (5435) * X ^ 13 + C (132843) * X ^ 14 + C (112376) * X ^ 15 + C (11186) * X ^ 16 + C (138489) * X ^ 17 + C (56274) * X ^ 18 + C (17738) * X ^ 19 + C (88885) * X ^ 20 + C (14571) * X ^ 21 + C (20094) * X ^ 22 + C (39706) * X ^ 23 + C (-1050) * X ^ 24 + C (9902) * X ^ 25 + C (9179) * X ^ 26 + C (-3000) * X ^ 27
theorem DC011_9_spre_eq : -DC011_9_pre = DC011_9_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_9_pre, DC011_9_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_9_spim_eq : -DC011_9_pim = DC011_9_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_9_pim, DC011_9_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_9_smul :
    -(N_entry_0_3 * N_entry_1_2 * N_entry_2_4) =
      ofLadj DC011_9_spre DC011_9_spim := by
  rw [DC011_9_mul, ofLadj_neg, DC011_9_spre_eq, DC011_9_spim_eq]

def DC011_10_ab_pre : Polynomial ℚ := C (12) + C (-24) * X + C (-18) * X ^ 2 + C (22) * X ^ 3 + C (-50) * X ^ 4 + C (34) * X ^ 5 + C (20) * X ^ 6 + C (-46) * X ^ 7 + C (70) * X ^ 8 + C (-20) * X ^ 9 + C (-64) * X ^ 10 + C (48) * X ^ 11 + C (-40) * X ^ 12 + C (-2) * X ^ 13 + C (48) * X ^ 14 + C (-14) * X ^ 15 + C (14) * X ^ 16 + C (28) * X ^ 17 + C (-18) * X ^ 18
def DC011_10_ab_pim : Polynomial ℚ := C (24) + C (48) * X + C (18) * X ^ 2 + C (102) * X ^ 3 + C (86) * X ^ 4 + C (58) * X ^ 5 + C (152) * X ^ 6 + C (94) * X ^ 7 + C (70) * X ^ 8 + C (196) * X ^ 9 + C (64) * X ^ 10 + C (108) * X ^ 11 + C (152) * X ^ 12 + C (50) * X ^ 13 + C (92) * X ^ 14 + C (78) * X ^ 15 + C (10) * X ^ 16 + C (44) * X ^ 17 + C (6) * X ^ 18
def DC011_10_pre : Polynomial ℚ := C (24) + C (1680) * X + C (1620) * X ^ 2 + C (1484) * X ^ 3 + C (6608) * X ^ 4 + C (2844) * X ^ 5 + C (5568) * X ^ 6 + C (12088) * X ^ 7 + C (3160) * X ^ 8 + C (12588) * X ^ 9 + C (16748) * X ^ 10 + C (4168) * X ^ 11 + C (20076) * X ^ 12 + C (14676) * X ^ 13 + C (5888) * X ^ 14 + C (21444) * X ^ 15 + C (9296) * X ^ 16 + C (6872) * X ^ 17 + C (17304) * X ^ 18 + C (3896) * X ^ 19 + C (6512) * X ^ 20 + C (8648) * X ^ 21 + C (704) * X ^ 22 + C (3640) * X ^ 23 + C (2804) * X ^ 24 + C (-316) * X ^ 25 + C (1340) * X ^ 26 + C (300) * X ^ 27
def DC011_10_pim : Polynomial ℚ := C (-672) + C (-1056) * X + C (228) * X ^ 2 + C (-3276) * X ^ 3 + C (-2672) * X ^ 4 + C (-1148) * X ^ 5 + C (-9096) * X ^ 6 + C (-3840) * X ^ 7 + C (-5184) * X ^ 8 + C (-15812) * X ^ 9 + C (-2684) * X ^ 10 + C (-10712) * X ^ 11 + C (-17436) * X ^ 12 + C (-2108) * X ^ 13 + C (-16400) * X ^ 14 + C (-14084) * X ^ 15 + C (-2496) * X ^ 16 + C (-16720) * X ^ 17 + C (-7304) * X ^ 18 + C (-2824) * X ^ 19 + C (-11088) * X ^ 20 + C (-2576) * X ^ 21 + C (-3136) * X ^ 22 + C (-5288) * X ^ 23 + C (-260) * X ^ 24 + C (-1356) * X ^ 25 + C (-1140) * X ^ 26 + C (420) * X ^ 27
theorem DC011_10_ab_pre_eq :
    N_re_0_4 * N_re_1_0 - N_im_0_4 * N_im_1_0 =
      DC011_10_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_0, N_im_1_0, DC011_10_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_10_ab_pim_eq :
    N_re_0_4 * N_im_1_0 + N_im_0_4 * N_re_1_0 =
      DC011_10_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_0, N_im_1_0, DC011_10_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_10_ab_mul :
    N_entry_0_4 * N_entry_1_0 =
      ofLadj DC011_10_ab_pre DC011_10_ab_pim := by
  rw [N_entry_0_4, N_entry_1_0, ofLadj_mul,
    DC011_10_ab_pre_eq, DC011_10_ab_pim_eq]

theorem DC011_10_pre_eq :
    DC011_10_ab_pre * N_re_2_5 - DC011_10_ab_pim * N_im_2_5 =
      DC011_10_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_10_ab_pre, DC011_10_ab_pim, N_re_2_5, N_im_2_5, DC011_10_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_10_pim_eq :
    DC011_10_ab_pre * N_im_2_5 + DC011_10_ab_pim * N_re_2_5 =
      DC011_10_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_10_ab_pre, DC011_10_ab_pim, N_re_2_5, N_im_2_5, DC011_10_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_10_mul :
    N_entry_0_4 * N_entry_1_0 * N_entry_2_5 =
      ofLadj DC011_10_pre DC011_10_pim := by
  rw [DC011_10_ab_mul, N_entry_2_5, ofLadj_mul, DC011_10_pre_eq, DC011_10_pim_eq]

def DC011_10_spre : Polynomial ℚ := C (-24) + C (-1680) * X + C (-1620) * X ^ 2 + C (-1484) * X ^ 3 + C (-6608) * X ^ 4 + C (-2844) * X ^ 5 + C (-5568) * X ^ 6 + C (-12088) * X ^ 7 + C (-3160) * X ^ 8 + C (-12588) * X ^ 9 + C (-16748) * X ^ 10 + C (-4168) * X ^ 11 + C (-20076) * X ^ 12 + C (-14676) * X ^ 13 + C (-5888) * X ^ 14 + C (-21444) * X ^ 15 + C (-9296) * X ^ 16 + C (-6872) * X ^ 17 + C (-17304) * X ^ 18 + C (-3896) * X ^ 19 + C (-6512) * X ^ 20 + C (-8648) * X ^ 21 + C (-704) * X ^ 22 + C (-3640) * X ^ 23 + C (-2804) * X ^ 24 + C (316) * X ^ 25 + C (-1340) * X ^ 26 + C (-300) * X ^ 27
def DC011_10_spim : Polynomial ℚ := C (672) + C (1056) * X + C (-228) * X ^ 2 + C (3276) * X ^ 3 + C (2672) * X ^ 4 + C (1148) * X ^ 5 + C (9096) * X ^ 6 + C (3840) * X ^ 7 + C (5184) * X ^ 8 + C (15812) * X ^ 9 + C (2684) * X ^ 10 + C (10712) * X ^ 11 + C (17436) * X ^ 12 + C (2108) * X ^ 13 + C (16400) * X ^ 14 + C (14084) * X ^ 15 + C (2496) * X ^ 16 + C (16720) * X ^ 17 + C (7304) * X ^ 18 + C (2824) * X ^ 19 + C (11088) * X ^ 20 + C (2576) * X ^ 21 + C (3136) * X ^ 22 + C (5288) * X ^ 23 + C (260) * X ^ 24 + C (1356) * X ^ 25 + C (1140) * X ^ 26 + C (-420) * X ^ 27
theorem DC011_10_spre_eq : -DC011_10_pre = DC011_10_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_10_pre, DC011_10_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_10_spim_eq : -DC011_10_pim = DC011_10_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_10_pim, DC011_10_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_10_smul :
    -(N_entry_0_4 * N_entry_1_0 * N_entry_2_5) =
      ofLadj DC011_10_spre DC011_10_spim := by
  rw [DC011_10_mul, ofLadj_neg, DC011_10_spre_eq, DC011_10_spim_eq]

def DC011_11_ab_pre : Polynomial ℚ := C (174) + C (-96) * X + C (102) * X ^ 2 + C (306) * X ^ 3 + C (-294) * X ^ 4 + C (248) * X ^ 5 + C (186) * X ^ 6 + C (-510) * X ^ 7 + C (514) * X ^ 8 + C (-106) * X ^ 9 + C (-440) * X ^ 10 + C (484) * X ^ 11 + C (-344) * X ^ 12 + C (-208) * X ^ 13 + C (208) * X ^ 14 + C (-384) * X ^ 15 + C (-32) * X ^ 16 + C (30) * X ^ 17 + C (-168) * X ^ 18
def DC011_11_ab_pim : Polynomial ℚ := C (138) + C (276) * X + C (-66) * X ^ 2 + C (400) * X ^ 3 + C (304) * X ^ 4 + C (-102) * X ^ 5 + C (786) * X ^ 6 + C (174) * X ^ 7 + C (176) * X ^ 8 + C (1172) * X ^ 9 + C (16) * X ^ 10 + C (360) * X ^ 11 + C (704) * X ^ 12 + C (-110) * X ^ 13 + C (420) * X ^ 14 + C (362) * X ^ 15 + C (-8) * X ^ 16 + C (320) * X ^ 17 + C (156) * X ^ 18
def DC011_11_pre : Polynomial ℚ := C (-6588) + C (18396) * X + C (1302) * X ^ 2 + C (-14957) * X ^ 3 + C (63309) * X ^ 4 + C (-18224) * X ^ 5 + C (7936) * X ^ 6 + C (128028) * X ^ 7 + C (-62324) * X ^ 8 + C (101043) * X ^ 9 + C (168467) * X ^ 10 + C (-87985) * X ^ 11 + C (211073) * X ^ 12 + C (120211) * X ^ 13 + C (-50703) * X ^ 14 + C (274282) * X ^ 15 + C (43820) * X ^ 16 + C (29414) * X ^ 17 + C (236448) * X ^ 18 + C (-1805) * X ^ 19 + C (68705) * X ^ 20 + C (123227) * X ^ 21 + C (-7617) * X ^ 22 + C (62225) * X ^ 23 + C (48235) * X ^ 24 + C (1531) * X ^ 25 + C (26885) * X ^ 26 + C (11754) * X ^ 27
def DC011_11_pim : Polynomial ℚ := C (-11886) + C (-21516) * X + C (5082) * X ^ 2 + C (-54205) * X ^ 3 + C (-36625) * X ^ 4 + C (10914) * X ^ 5 + C (-129428) * X ^ 6 + C (-14402) * X ^ 7 + C (-21782) * X ^ 8 + C (-222299) * X ^ 9 + C (42677) * X ^ 10 + C (-99537) * X ^ 11 + C (-217459) * X ^ 12 + C (95461) * X ^ 13 + C (-177053) * X ^ 14 + C (-129378) * X ^ 15 + C (85858) * X ^ 16 + C (-200126) * X ^ 17 + C (-31690) * X ^ 18 + C (37183) * X ^ 19 + C (-126439) * X ^ 20 + C (24049) * X ^ 21 + C (-1587) * X ^ 22 + C (-53771) * X ^ 23 + C (22175) * X ^ 24 + C (-10163) * X ^ 25 + C (-13925) * X ^ 26 + C (6762) * X ^ 27
theorem DC011_11_ab_pre_eq :
    N_re_0_5 * N_re_1_1 - N_im_0_5 * N_im_1_1 =
      DC011_11_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_1, N_im_1_1, DC011_11_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_11_ab_pim_eq :
    N_re_0_5 * N_im_1_1 + N_im_0_5 * N_re_1_1 =
      DC011_11_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_1, N_im_1_1, DC011_11_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_11_ab_mul :
    N_entry_0_5 * N_entry_1_1 =
      ofLadj DC011_11_ab_pre DC011_11_ab_pim := by
  rw [N_entry_0_5, N_entry_1_1, ofLadj_mul,
    DC011_11_ab_pre_eq, DC011_11_ab_pim_eq]

theorem DC011_11_pre_eq :
    DC011_11_ab_pre * N_re_2_3 - DC011_11_ab_pim * N_im_2_3 =
      DC011_11_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_11_ab_pre, DC011_11_ab_pim, N_re_2_3, N_im_2_3, DC011_11_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_11_pim_eq :
    DC011_11_ab_pre * N_im_2_3 + DC011_11_ab_pim * N_re_2_3 =
      DC011_11_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_11_ab_pre, DC011_11_ab_pim, N_re_2_3, N_im_2_3, DC011_11_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_11_mul :
    N_entry_0_5 * N_entry_1_1 * N_entry_2_3 =
      ofLadj DC011_11_pre DC011_11_pim := by
  rw [DC011_11_ab_mul, N_entry_2_3, ofLadj_mul, DC011_11_pre_eq, DC011_11_pim_eq]

def DC011_11_spre : Polynomial ℚ := C (6588) + C (-18396) * X + C (-1302) * X ^ 2 + C (14957) * X ^ 3 + C (-63309) * X ^ 4 + C (18224) * X ^ 5 + C (-7936) * X ^ 6 + C (-128028) * X ^ 7 + C (62324) * X ^ 8 + C (-101043) * X ^ 9 + C (-168467) * X ^ 10 + C (87985) * X ^ 11 + C (-211073) * X ^ 12 + C (-120211) * X ^ 13 + C (50703) * X ^ 14 + C (-274282) * X ^ 15 + C (-43820) * X ^ 16 + C (-29414) * X ^ 17 + C (-236448) * X ^ 18 + C (1805) * X ^ 19 + C (-68705) * X ^ 20 + C (-123227) * X ^ 21 + C (7617) * X ^ 22 + C (-62225) * X ^ 23 + C (-48235) * X ^ 24 + C (-1531) * X ^ 25 + C (-26885) * X ^ 26 + C (-11754) * X ^ 27
def DC011_11_spim : Polynomial ℚ := C (11886) + C (21516) * X + C (-5082) * X ^ 2 + C (54205) * X ^ 3 + C (36625) * X ^ 4 + C (-10914) * X ^ 5 + C (129428) * X ^ 6 + C (14402) * X ^ 7 + C (21782) * X ^ 8 + C (222299) * X ^ 9 + C (-42677) * X ^ 10 + C (99537) * X ^ 11 + C (217459) * X ^ 12 + C (-95461) * X ^ 13 + C (177053) * X ^ 14 + C (129378) * X ^ 15 + C (-85858) * X ^ 16 + C (200126) * X ^ 17 + C (31690) * X ^ 18 + C (-37183) * X ^ 19 + C (126439) * X ^ 20 + C (-24049) * X ^ 21 + C (1587) * X ^ 22 + C (53771) * X ^ 23 + C (-22175) * X ^ 24 + C (10163) * X ^ 25 + C (13925) * X ^ 26 + C (-6762) * X ^ 27
theorem DC011_11_spre_eq : -DC011_11_pre = DC011_11_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_11_pre, DC011_11_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_11_spim_eq : -DC011_11_pim = DC011_11_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_11_pim, DC011_11_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_11_smul :
    -(N_entry_0_5 * N_entry_1_1 * N_entry_2_3) =
      ofLadj DC011_11_spre DC011_11_spim := by
  rw [DC011_11_mul, ofLadj_neg, DC011_11_spre_eq, DC011_11_spim_eq]

def DC011_12_ab_pre : Polynomial ℚ := C (-342) + C (456) * X + C (130) * X ^ 2 + C (-504) * X ^ 3 + C (1168) * X ^ 4 + C (-452) * X ^ 5 + C (-316) * X ^ 6 + C (1494) * X ^ 7 + C (-1372) * X ^ 8 + C (404) * X ^ 9 + C (1338) * X ^ 10 + C (-1360) * X ^ 11 + C (882) * X ^ 12 + C (274) * X ^ 13 + C (-868) * X ^ 14 + C (766) * X ^ 15 + C (-120) * X ^ 16 + C (-256) * X ^ 17 + C (440) * X ^ 18
def DC011_12_ab_pim : Polynomial ℚ := C (-456) + C (-912) * X + C (-118) * X ^ 2 + C (-1622) * X ^ 3 + C (-1480) * X ^ 4 + C (-572) * X ^ 5 + C (-3064) * X ^ 6 + C (-1530) * X ^ 7 + C (-1384) * X ^ 8 + C (-4182) * X ^ 9 + C (-976) * X ^ 10 + C (-1888) * X ^ 11 + C (-2800) * X ^ 12 + C (-388) * X ^ 13 + C (-1682) * X ^ 14 + C (-1358) * X ^ 15 + C (-100) * X ^ 16 + C (-952) * X ^ 17 + C (-320) * X ^ 18
def DC011_12_pre : Polynomial ℚ := C (-2394) + C (10488) * X + C (4976) * X ^ 2 + C (-654) * X ^ 3 + C (39274) * X ^ 4 + C (3626) * X ^ 5 + C (18438) * X ^ 6 + C (76692) * X ^ 7 + C (-10146) * X ^ 8 + C (67736) * X ^ 9 + C (101760) * X ^ 10 + C (-16808) * X ^ 11 + C (121502) * X ^ 12 + C (77524) * X ^ 13 + C (-4534) * X ^ 14 + C (141716) * X ^ 15 + C (32290) * X ^ 16 + C (21798) * X ^ 17 + C (115290) * X ^ 18 + C (3478) * X ^ 19 + C (34148) * X ^ 20 + C (56750) * X ^ 21 + C (-4904) * X ^ 22 + C (26520) * X ^ 23 + C (19384) * X ^ 24 + C (-1480) * X ^ 25 + C (10992) * X ^ 26 + C (4320) * X ^ 27
def DC011_12_pim : Polynomial ℚ := C (-6042) + C (-10716) * X + C (688) * X ^ 2 + C (-29746) * X ^ 3 + C (-25082) * X ^ 4 + C (-7318) * X ^ 5 + C (-78354) * X ^ 6 + C (-31856) * X ^ 7 + C (-40586) * X ^ 8 + C (-140920) * X ^ 9 + C (-23872) * X ^ 10 + C (-95024) * X ^ 11 + C (-156362) * X ^ 12 + C (-15392) * X ^ 13 + C (-142854) * X ^ 14 + C (-120668) * X ^ 15 + C (-18194) * X ^ 16 + C (-145642) * X ^ 17 + C (-60606) * X ^ 18 + C (-23322) * X ^ 19 + C (-91852) * X ^ 20 + C (-16318) * X ^ 21 + C (-22568) * X ^ 22 + C (-40000) * X ^ 23 + C (208) * X ^ 24 + C (-10760) * X ^ 25 + C (-9056) * X ^ 26 + C (2240) * X ^ 27
theorem DC011_12_ab_pre_eq :
    N_re_0_3 * N_re_1_4 - N_im_0_3 * N_im_1_4 =
      DC011_12_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_4, N_im_1_4, DC011_12_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_12_ab_pim_eq :
    N_re_0_3 * N_im_1_4 + N_im_0_3 * N_re_1_4 =
      DC011_12_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_4, N_im_1_4, DC011_12_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_12_ab_mul :
    N_entry_0_3 * N_entry_1_4 =
      ofLadj DC011_12_ab_pre DC011_12_ab_pim := by
  rw [N_entry_0_3, N_entry_1_4, ofLadj_mul,
    DC011_12_ab_pre_eq, DC011_12_ab_pim_eq]

theorem DC011_12_pre_eq :
    DC011_12_ab_pre * N_re_2_2 - DC011_12_ab_pim * N_im_2_2 =
      DC011_12_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_12_ab_pre, DC011_12_ab_pim, N_re_2_2, N_im_2_2, DC011_12_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_12_pim_eq :
    DC011_12_ab_pre * N_im_2_2 + DC011_12_ab_pim * N_re_2_2 =
      DC011_12_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_12_ab_pre, DC011_12_ab_pim, N_re_2_2, N_im_2_2, DC011_12_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_12_mul :
    N_entry_0_3 * N_entry_1_4 * N_entry_2_2 =
      ofLadj DC011_12_pre DC011_12_pim := by
  rw [DC011_12_ab_mul, N_entry_2_2, ofLadj_mul, DC011_12_pre_eq, DC011_12_pim_eq]

def DC011_13_ab_pre : Polynomial ℚ := C (-198) + C (144) * X + C (-42) * X ^ 2 + C (-338) * X ^ 3 + C (388) * X ^ 4 + C (-316) * X ^ 5 + C (-244) * X ^ 6 + C (568) * X ^ 7 + C (-674) * X ^ 8 + C (130) * X ^ 9 + C (552) * X ^ 10 + C (-576) * X ^ 11 + C (408) * X ^ 12 + C (172) * X ^ 13 + C (-336) * X ^ 14 + C (372) * X ^ 15 + C (-32) * X ^ 16 + C (-104) * X ^ 17 + C (192) * X ^ 18
def DC011_13_ab_pim : Polynomial ℚ := C (-186) + C (-372) * X + C (18) * X ^ 2 + C (-622) * X ^ 3 + C (-512) * X ^ 4 + C (-48) * X ^ 5 + C (-1116) * X ^ 6 + C (-400) * X ^ 7 + C (-326) * X ^ 8 + C (-1562) * X ^ 9 + C (-168) * X ^ 10 + C (-600) * X ^ 11 + C (-1032) * X ^ 12 + C (-28) * X ^ 13 + C (-624) * X ^ 14 + C (-516) * X ^ 15 + C (-16) * X ^ 16 + C (-392) * X ^ 17 + C (-144) * X ^ 18
def DC011_13_pre : Polynomial ℚ := C (372) + C (1488) * X + C (1452) * X ^ 2 + C (1235) * X ^ 3 + C (5558) * X ^ 4 + C (2462) * X ^ 5 + C (4432) * X ^ 6 + C (10885) * X ^ 7 + C (2791) * X ^ 8 + C (11453) * X ^ 9 + C (15927) * X ^ 10 + C (2666) * X ^ 11 + C (19025) * X ^ 12 + C (14031) * X ^ 13 + C (4850) * X ^ 14 + C (22195) * X ^ 15 + C (8977) * X ^ 16 + C (7583) * X ^ 17 + C (19060) * X ^ 18 + C (3586) * X ^ 19 + C (7686) * X ^ 20 + C (9884) * X ^ 21 + C (1128) * X ^ 22 + C (5298) * X ^ 23 + C (3656) * X ^ 24 + C (292) * X ^ 25 + C (2192) * X ^ 26 + C (576) * X ^ 27
def DC011_13_pim : Polynomial ℚ := C (-396) + C (-504) * X + C (492) * X ^ 2 + C (-1903) * X ^ 3 + C (-1284) * X ^ 4 + C (638) * X ^ 5 + C (-5926) * X ^ 6 + C (-901) * X ^ 7 + C (-1129) * X ^ 8 + C (-10957) * X ^ 9 + C (2225) * X ^ 10 + C (-5048) * X ^ 11 + C (-11995) * X ^ 12 + C (4751) * X ^ 13 + C (-10510) * X ^ 14 + C (-7899) * X ^ 15 + C (4355) * X ^ 16 + C (-12147) * X ^ 17 + C (-1644) * X ^ 18 + C (1914) * X ^ 19 + C (-8222) * X ^ 20 + C (1436) * X ^ 21 + C (-712) * X ^ 22 + C (-3474) * X ^ 23 + C (1624) * X ^ 24 + C (-684) * X ^ 25 + C (-584) * X ^ 26 + C (768) * X ^ 27
theorem DC011_13_ab_pre_eq :
    N_re_0_4 * N_re_1_5 - N_im_0_4 * N_im_1_5 =
      DC011_13_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_5, N_im_1_5, DC011_13_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_13_ab_pim_eq :
    N_re_0_4 * N_im_1_5 + N_im_0_4 * N_re_1_5 =
      DC011_13_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_5, N_im_1_5, DC011_13_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_13_ab_mul :
    N_entry_0_4 * N_entry_1_5 =
      ofLadj DC011_13_ab_pre DC011_13_ab_pim := by
  rw [N_entry_0_4, N_entry_1_5, ofLadj_mul,
    DC011_13_ab_pre_eq, DC011_13_ab_pim_eq]

theorem DC011_13_pre_eq :
    DC011_13_ab_pre * N_re_2_0 - DC011_13_ab_pim * N_im_2_0 =
      DC011_13_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_13_ab_pre, DC011_13_ab_pim, N_re_2_0, N_im_2_0, DC011_13_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_13_pim_eq :
    DC011_13_ab_pre * N_im_2_0 + DC011_13_ab_pim * N_re_2_0 =
      DC011_13_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_13_ab_pre, DC011_13_ab_pim, N_re_2_0, N_im_2_0, DC011_13_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_13_mul :
    N_entry_0_4 * N_entry_1_5 * N_entry_2_0 =
      ofLadj DC011_13_pre DC011_13_pim := by
  rw [DC011_13_ab_mul, N_entry_2_0, ofLadj_mul, DC011_13_pre_eq, DC011_13_pim_eq]

def DC011_14_ab_pre : Polynomial ℚ := C (-450) + C (288) * X + C (-174) * X ^ 2 + C (-808) * X ^ 3 + C (872) * X ^ 4 + C (-666) * X ^ 5 + C (-494) * X ^ 6 + C (1402) * X ^ 7 + C (-1436) * X ^ 8 + C (348) * X ^ 9 + C (1284) * X ^ 10 + C (-1316) * X ^ 11 + C (996) * X ^ 12 + C (522) * X ^ 13 + C (-628) * X ^ 14 + C (1010) * X ^ 15 + C (32) * X ^ 16 + C (-140) * X ^ 17 + C (480) * X ^ 18
def DC011_14_ab_pim : Polynomial ℚ := C (-390) + C (-780) * X + C (150) * X ^ 2 + C (-1214) * X ^ 3 + C (-946) * X ^ 4 + C (160) * X ^ 5 + C (-2270) * X ^ 6 + C (-626) * X ^ 7 + C (-518) * X ^ 8 + C (-3326) * X ^ 9 + C (-108) * X ^ 10 + C (-1092) * X ^ 11 + C (-2076) * X ^ 12 + C (212) * X ^ 13 + C (-1232) * X ^ 14 + C (-1032) * X ^ 15 + C (36) * X ^ 16 + C (-890) * X ^ 17 + C (-360) * X ^ 18
def DC011_14_pre : Polynomial ℚ := C (-8490) + C (17196) * X + C (-228) * X ^ 2 + C (-18655) * X ^ 3 + C (62093) * X ^ 4 + C (-22294) * X ^ 5 + C (2152) * X ^ 6 + C (124196) * X ^ 7 + C (-72690) * X ^ 8 + C (90197) * X ^ 9 + C (158731) * X ^ 10 + C (-100645) * X ^ 11 + C (199755) * X ^ 12 + C (108115) * X ^ 13 + C (-64207) * X ^ 14 + C (259558) * X ^ 15 + C (29408) * X ^ 16 + C (14862) * X ^ 17 + C (221040) * X ^ 18 + C (-12107) * X ^ 19 + C (59669) * X ^ 20 + C (113491) * X ^ 21 + C (-13837) * X ^ 22 + C (55271) * X ^ 23 + C (41979) * X ^ 24 + C (-1935) * X ^ 25 + C (23585) * X ^ 26 + C (9900) * X ^ 27
def DC011_14_pim : Polynomial ℚ := C (-12480) + C (-23088) * X + C (5388) * X ^ 2 + C (-57243) * X ^ 3 + C (-41045) * X ^ 4 + C (8188) * X ^ 5 + C (-138008) * X ^ 6 + C (-23458) * X ^ 7 + C (-30688) * X ^ 8 + C (-237829) * X ^ 9 + C (29413) * X ^ 10 + C (-114417) * X ^ 11 + C (-236021) * X ^ 12 + C (76069) * X ^ 13 + C (-196385) * X ^ 14 + C (-149242) * X ^ 15 + C (64690) * X ^ 16 + C (-217938) * X ^ 17 + C (-48078) * X ^ 18 + C (20853) * X ^ 19 + C (-137363) * X ^ 20 + C (12245) * X ^ 21 + C (-11787) * X ^ 22 + C (-59917) * X ^ 23 + C (16367) * X ^ 24 + C (-13905) * X ^ 25 + C (-15545) * X ^ 26 + C (5700) * X ^ 27
theorem DC011_14_ab_pre_eq :
    N_re_0_5 * N_re_1_3 - N_im_0_5 * N_im_1_3 =
      DC011_14_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_3, N_im_1_3, DC011_14_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_14_ab_pim_eq :
    N_re_0_5 * N_im_1_3 + N_im_0_5 * N_re_1_3 =
      DC011_14_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_3, N_im_1_3, DC011_14_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_14_ab_mul :
    N_entry_0_5 * N_entry_1_3 =
      ofLadj DC011_14_ab_pre DC011_14_ab_pim := by
  rw [N_entry_0_5, N_entry_1_3, ofLadj_mul,
    DC011_14_ab_pre_eq, DC011_14_ab_pim_eq]

theorem DC011_14_pre_eq :
    DC011_14_ab_pre * N_re_2_1 - DC011_14_ab_pim * N_im_2_1 =
      DC011_14_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_14_ab_pre, DC011_14_ab_pim, N_re_2_1, N_im_2_1, DC011_14_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_14_pim_eq :
    DC011_14_ab_pre * N_im_2_1 + DC011_14_ab_pim * N_re_2_1 =
      DC011_14_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_14_ab_pre, DC011_14_ab_pim, N_re_2_1, N_im_2_1, DC011_14_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_14_mul :
    N_entry_0_5 * N_entry_1_3 * N_entry_2_1 =
      ofLadj DC011_14_pre DC011_14_pim := by
  rw [DC011_14_ab_mul, N_entry_2_1, ofLadj_mul, DC011_14_pre_eq, DC011_14_pim_eq]

def DC011_15_ab_pre : Polynomial ℚ := C (-380) + C (456) * X + C (117) * X ^ 2 + C (-541) * X ^ 3 + C (1172) * X ^ 4 + C (-481) * X ^ 5 + C (-345) * X ^ 6 + C (1498) * X ^ 7 + C (-1409) * X ^ 8 + C (391) * X ^ 9 + C (1338) * X ^ 10 + C (-1360) * X ^ 11 + C (882) * X ^ 12 + C (274) * X ^ 13 + C (-868) * X ^ 14 + C (766) * X ^ 15 + C (-120) * X ^ 16 + C (-256) * X ^ 17 + C (440) * X ^ 18
def DC011_15_ab_pim : Polynomial ℚ := C (-475) + C (-950) * X + C (-115) * X ^ 2 + C (-1656) * X ^ 3 + C (-1506) * X ^ 4 + C (-572) * X ^ 5 + C (-3102) * X ^ 6 + C (-1542) * X ^ 7 + C (-1388) * X ^ 8 + C (-4223) * X ^ 9 + C (-976) * X ^ 10 + C (-1888) * X ^ 11 + C (-2800) * X ^ 12 + C (-388) * X ^ 13 + C (-1682) * X ^ 14 + C (-1358) * X ^ 15 + C (-100) * X ^ 16 + C (-952) * X ^ 17 + C (-320) * X ^ 18
def DC011_15_pre : Polynomial ℚ := C ((-12445 / 2 : ℚ)) + C (23522) * X + C ((21953 / 2 : ℚ)) * X ^ 2 + C (-2943) * X ^ 3 + C (85832) * X ^ 4 + C (4763) * X ^ 5 + C (36646) * X ^ 6 + C ((330705 / 2 : ℚ)) * X ^ 7 + C (-28638) * X ^ 8 + C (142714) * X ^ 9 + C ((435495 / 2 : ℚ)) * X ^ 10 + C (-42356) * X ^ 11 + C ((519885 / 2 : ℚ)) * X ^ 12 + C ((328213 / 2 : ℚ)) * X ^ 13 + C (-13730) * X ^ 14 + C ((610913 / 2 : ℚ)) * X ^ 15 + C ((138975 / 2 : ℚ)) * X ^ 16 + C ((93009 / 2 : ℚ)) * X ^ 17 + C (248976) * X ^ 18 + C (9075) * X ^ 19 + C (74501) * X ^ 20 + C (122920) * X ^ 21 + C (-9480) * X ^ 22 + C (57203) * X ^ 23 + C (42132) * X ^ 24 + C (-2890) * X ^ 25 + C (23040) * X ^ 26 + C (8900) * X ^ 27
def DC011_15_pim : Polynomial ℚ := C ((-28215 / 2 : ℚ)) + C (-25251) * X + C ((4037 / 2 : ℚ)) * X ^ 2 + C (-65282) * X ^ 3 + C (-52901) * X ^ 4 + C (-10085) * X ^ 5 + C (-165069) * X ^ 6 + C ((-113523 / 2 : ℚ)) * X ^ 7 + C (-70556) * X ^ 8 + C (-287544) * X ^ 9 + C ((-47323 / 2 : ℚ)) * X ^ 10 + C (-173895) * X ^ 11 + C ((-605951 / 2 : ℚ)) * X ^ 12 + C ((15251 / 2 : ℚ)) * X ^ 13 + C (-268310) * X ^ 14 + C ((-440119 / 2 : ℚ)) * X ^ 15 + C ((2923 / 2 : ℚ)) * X ^ 16 + C ((-553313 / 2 : ℚ)) * X ^ 17 + C (-98007) * X ^ 18 + C (-21951) * X ^ 19 + C (-173603) * X ^ 20 + C (-16892) * X ^ 21 + C (-34522) * X ^ 22 + C (-76269) * X ^ 23 + C (6454) * X ^ 24 + C (-18950) * X ^ 25 + C (-17320) * X ^ 26 + C (5300) * X ^ 27
theorem DC011_15_ab_pre_eq :
    N_re_0_3 * N_re_1_5 - N_im_0_3 * N_im_1_5 =
      DC011_15_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_5, N_im_1_5, DC011_15_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_15_ab_pim_eq :
    N_re_0_3 * N_im_1_5 + N_im_0_3 * N_re_1_5 =
      DC011_15_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_5, N_im_1_5, DC011_15_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_15_ab_mul :
    N_entry_0_3 * N_entry_1_5 =
      ofLadj DC011_15_ab_pre DC011_15_ab_pim := by
  rw [N_entry_0_3, N_entry_1_5, ofLadj_mul,
    DC011_15_ab_pre_eq, DC011_15_ab_pim_eq]

theorem DC011_15_pre_eq :
    DC011_15_ab_pre * N_re_2_1 - DC011_15_ab_pim * N_im_2_1 =
      DC011_15_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_15_ab_pre, DC011_15_ab_pim, N_re_2_1, N_im_2_1, DC011_15_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_15_pim_eq :
    DC011_15_ab_pre * N_im_2_1 + DC011_15_ab_pim * N_re_2_1 =
      DC011_15_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_15_ab_pre, DC011_15_ab_pim, N_re_2_1, N_im_2_1, DC011_15_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_15_mul :
    N_entry_0_3 * N_entry_1_5 * N_entry_2_1 =
      ofLadj DC011_15_pre DC011_15_pim := by
  rw [DC011_15_ab_mul, N_entry_2_1, ofLadj_mul, DC011_15_pre_eq, DC011_15_pim_eq]

def DC011_15_spre : Polynomial ℚ := C ((12445 / 2 : ℚ)) + C (-23522) * X + C ((-21953 / 2 : ℚ)) * X ^ 2 + C (2943) * X ^ 3 + C (-85832) * X ^ 4 + C (-4763) * X ^ 5 + C (-36646) * X ^ 6 + C ((-330705 / 2 : ℚ)) * X ^ 7 + C (28638) * X ^ 8 + C (-142714) * X ^ 9 + C ((-435495 / 2 : ℚ)) * X ^ 10 + C (42356) * X ^ 11 + C ((-519885 / 2 : ℚ)) * X ^ 12 + C ((-328213 / 2 : ℚ)) * X ^ 13 + C (13730) * X ^ 14 + C ((-610913 / 2 : ℚ)) * X ^ 15 + C ((-138975 / 2 : ℚ)) * X ^ 16 + C ((-93009 / 2 : ℚ)) * X ^ 17 + C (-248976) * X ^ 18 + C (-9075) * X ^ 19 + C (-74501) * X ^ 20 + C (-122920) * X ^ 21 + C (9480) * X ^ 22 + C (-57203) * X ^ 23 + C (-42132) * X ^ 24 + C (2890) * X ^ 25 + C (-23040) * X ^ 26 + C (-8900) * X ^ 27
def DC011_15_spim : Polynomial ℚ := C ((28215 / 2 : ℚ)) + C (25251) * X + C ((-4037 / 2 : ℚ)) * X ^ 2 + C (65282) * X ^ 3 + C (52901) * X ^ 4 + C (10085) * X ^ 5 + C (165069) * X ^ 6 + C ((113523 / 2 : ℚ)) * X ^ 7 + C (70556) * X ^ 8 + C (287544) * X ^ 9 + C ((47323 / 2 : ℚ)) * X ^ 10 + C (173895) * X ^ 11 + C ((605951 / 2 : ℚ)) * X ^ 12 + C ((-15251 / 2 : ℚ)) * X ^ 13 + C (268310) * X ^ 14 + C ((440119 / 2 : ℚ)) * X ^ 15 + C ((-2923 / 2 : ℚ)) * X ^ 16 + C ((553313 / 2 : ℚ)) * X ^ 17 + C (98007) * X ^ 18 + C (21951) * X ^ 19 + C (173603) * X ^ 20 + C (16892) * X ^ 21 + C (34522) * X ^ 22 + C (76269) * X ^ 23 + C (-6454) * X ^ 24 + C (18950) * X ^ 25 + C (17320) * X ^ 26 + C (-5300) * X ^ 27
theorem DC011_15_spre_eq : -DC011_15_pre = DC011_15_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_15_pre, DC011_15_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_15_spim_eq : -DC011_15_pim = DC011_15_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_15_pim, DC011_15_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_15_smul :
    -(N_entry_0_3 * N_entry_1_5 * N_entry_2_1) =
      ofLadj DC011_15_spre DC011_15_spim := by
  rw [DC011_15_mul, ofLadj_neg, DC011_15_spre_eq, DC011_15_spim_eq]

def DC011_16_ab_pre : Polynomial ℚ := C (-450) + C (288) * X + C (-174) * X ^ 2 + C (-808) * X ^ 3 + C (872) * X ^ 4 + C (-666) * X ^ 5 + C (-494) * X ^ 6 + C (1402) * X ^ 7 + C (-1436) * X ^ 8 + C (348) * X ^ 9 + C (1284) * X ^ 10 + C (-1316) * X ^ 11 + C (996) * X ^ 12 + C (522) * X ^ 13 + C (-628) * X ^ 14 + C (1010) * X ^ 15 + C (32) * X ^ 16 + C (-140) * X ^ 17 + C (480) * X ^ 18
def DC011_16_ab_pim : Polynomial ℚ := C (-390) + C (-780) * X + C (150) * X ^ 2 + C (-1214) * X ^ 3 + C (-946) * X ^ 4 + C (160) * X ^ 5 + C (-2270) * X ^ 6 + C (-626) * X ^ 7 + C (-518) * X ^ 8 + C (-3326) * X ^ 9 + C (-108) * X ^ 10 + C (-1092) * X ^ 11 + C (-2076) * X ^ 12 + C (212) * X ^ 13 + C (-1232) * X ^ 14 + C (-1032) * X ^ 15 + C (36) * X ^ 16 + C (-890) * X ^ 17 + C (-360) * X ^ 18
def DC011_16_pre : Polynomial ℚ := C (-3780) + C (7848) * X + C (-264) * X ^ 2 + C (-8714) * X ^ 3 + C (28378) * X ^ 4 + C (-10562) * X ^ 5 + C (328) * X ^ 6 + C (56442) * X ^ 7 + C (-34318) * X ^ 8 + C (40896) * X ^ 9 + C (72750) * X ^ 10 + C (-47060) * X ^ 11 + C (92528) * X ^ 12 + C (50594) * X ^ 13 + C (-29224) * X ^ 14 + C (120990) * X ^ 15 + C (14186) * X ^ 16 + C (8096) * X ^ 17 + C (104286) * X ^ 18 + C (-4340) * X ^ 19 + C (29400) * X ^ 20 + C (54376) * X ^ 21 + C (-5316) * X ^ 22 + C (26750) * X ^ 23 + C (19966) * X ^ 24 + C (-720) * X ^ 25 + C (11360) * X ^ 26 + C (4800) * X ^ 27
def DC011_16_pim : Polynomial ℚ := C (-5640) + C (-10416) * X + C (2196) * X ^ 2 + C (-27118) * X ^ 3 + C (-20402) * X ^ 4 + C (1490) * X ^ 5 + C (-66788) * X ^ 6 + C (-15290) * X ^ 7 + C (-19650) * X ^ 8 + C (-116292) * X ^ 9 + C (5970) * X ^ 10 + C (-61956) * X ^ 11 + C (-119824) * X ^ 12 + C (24122) * X ^ 13 + C (-102592) * X ^ 14 + C (-80746) * X ^ 15 + C (18694) * X ^ 16 + C (-112084) * X ^ 17 + C (-31570) * X ^ 18 + C (1452) * X ^ 19 + C (-71396) * X ^ 20 + C (-364) * X ^ 21 + C (-10548) * X ^ 22 + C (-31654) * X ^ 23 + C (5082) * X ^ 24 + C (-8380) * X ^ 25 + C (-8280) * X ^ 26 + C (2400) * X ^ 27
theorem DC011_16_ab_pre_eq :
    N_re_0_4 * N_re_1_3 - N_im_0_4 * N_im_1_3 =
      DC011_16_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_3, N_im_1_3, DC011_16_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_16_ab_pim_eq :
    N_re_0_4 * N_im_1_3 + N_im_0_4 * N_re_1_3 =
      DC011_16_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_3, N_im_1_3, DC011_16_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_16_ab_mul :
    N_entry_0_4 * N_entry_1_3 =
      ofLadj DC011_16_ab_pre DC011_16_ab_pim := by
  rw [N_entry_0_4, N_entry_1_3, ofLadj_mul,
    DC011_16_ab_pre_eq, DC011_16_ab_pim_eq]

theorem DC011_16_pre_eq :
    DC011_16_ab_pre * N_re_2_2 - DC011_16_ab_pim * N_im_2_2 =
      DC011_16_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_16_ab_pre, DC011_16_ab_pim, N_re_2_2, N_im_2_2, DC011_16_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_16_pim_eq :
    DC011_16_ab_pre * N_im_2_2 + DC011_16_ab_pim * N_re_2_2 =
      DC011_16_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_16_ab_pre, DC011_16_ab_pim, N_re_2_2, N_im_2_2, DC011_16_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_16_mul :
    N_entry_0_4 * N_entry_1_3 * N_entry_2_2 =
      ofLadj DC011_16_pre DC011_16_pim := by
  rw [DC011_16_ab_mul, N_entry_2_2, ofLadj_mul, DC011_16_pre_eq, DC011_16_pim_eq]

def DC011_16_spre : Polynomial ℚ := C (3780) + C (-7848) * X + C (264) * X ^ 2 + C (8714) * X ^ 3 + C (-28378) * X ^ 4 + C (10562) * X ^ 5 + C (-328) * X ^ 6 + C (-56442) * X ^ 7 + C (34318) * X ^ 8 + C (-40896) * X ^ 9 + C (-72750) * X ^ 10 + C (47060) * X ^ 11 + C (-92528) * X ^ 12 + C (-50594) * X ^ 13 + C (29224) * X ^ 14 + C (-120990) * X ^ 15 + C (-14186) * X ^ 16 + C (-8096) * X ^ 17 + C (-104286) * X ^ 18 + C (4340) * X ^ 19 + C (-29400) * X ^ 20 + C (-54376) * X ^ 21 + C (5316) * X ^ 22 + C (-26750) * X ^ 23 + C (-19966) * X ^ 24 + C (720) * X ^ 25 + C (-11360) * X ^ 26 + C (-4800) * X ^ 27
def DC011_16_spim : Polynomial ℚ := C (5640) + C (10416) * X + C (-2196) * X ^ 2 + C (27118) * X ^ 3 + C (20402) * X ^ 4 + C (-1490) * X ^ 5 + C (66788) * X ^ 6 + C (15290) * X ^ 7 + C (19650) * X ^ 8 + C (116292) * X ^ 9 + C (-5970) * X ^ 10 + C (61956) * X ^ 11 + C (119824) * X ^ 12 + C (-24122) * X ^ 13 + C (102592) * X ^ 14 + C (80746) * X ^ 15 + C (-18694) * X ^ 16 + C (112084) * X ^ 17 + C (31570) * X ^ 18 + C (-1452) * X ^ 19 + C (71396) * X ^ 20 + C (364) * X ^ 21 + C (10548) * X ^ 22 + C (31654) * X ^ 23 + C (-5082) * X ^ 24 + C (8380) * X ^ 25 + C (8280) * X ^ 26 + C (-2400) * X ^ 27
theorem DC011_16_spre_eq : -DC011_16_pre = DC011_16_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_16_pre, DC011_16_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_16_spim_eq : -DC011_16_pim = DC011_16_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_16_pim, DC011_16_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_16_smul :
    -(N_entry_0_4 * N_entry_1_3 * N_entry_2_2) =
      ofLadj DC011_16_spre DC011_16_spim := by
  rw [DC011_16_mul, ofLadj_neg, DC011_16_spre_eq, DC011_16_spim_eq]

def DC011_17_ab_pre : Polynomial ℚ := C (-180) + C (144) * X + C (-36) * X ^ 2 + C (-324) * X ^ 3 + C (384) * X ^ 4 + C (-308) * X ^ 5 + C (-236) * X ^ 6 + C (564) * X ^ 7 + C (-660) * X ^ 8 + C (136) * X ^ 9 + C (552) * X ^ 10 + C (-576) * X ^ 11 + C (408) * X ^ 12 + C (172) * X ^ 13 + C (-336) * X ^ 14 + C (372) * X ^ 15 + C (-32) * X ^ 16 + C (-104) * X ^ 17 + C (192) * X ^ 18
def DC011_17_ab_pim : Polynomial ℚ := C (-180) + C (-360) * X + C (12) * X ^ 2 + C (-612) * X ^ 3 + C (-504) * X ^ 4 + C (-52) * X ^ 5 + C (-1100) * X ^ 6 + C (-396) * X ^ 7 + C (-324) * X ^ 8 + C (-1544) * X ^ 9 + C (-168) * X ^ 10 + C (-600) * X ^ 11 + C (-1032) * X ^ 12 + C (-28) * X ^ 13 + C (-624) * X ^ 14 + C (-516) * X ^ 15 + C (-16) * X ^ 16 + C (-392) * X ^ 17 + C (-144) * X ^ 18
def DC011_17_pre : Polynomial ℚ := C (360) + C (1440) * X + C (1416) * X ^ 2 + C (1266) * X ^ 3 + C (5436) * X ^ 4 + C (2480) * X ^ 5 + C (4436) * X ^ 6 + C (10718) * X ^ 7 + C (2848) * X ^ 8 + C (11340) * X ^ 9 + C (15734) * X ^ 10 + C (2744) * X ^ 11 + C (18880) * X ^ 12 + C (13954) * X ^ 13 + C (4876) * X ^ 14 + C (22078) * X ^ 15 + C (8952) * X ^ 16 + C (7572) * X ^ 17 + C (18988) * X ^ 18 + C (3586) * X ^ 19 + C (7686) * X ^ 20 + C (9884) * X ^ 21 + C (1128) * X ^ 22 + C (5298) * X ^ 23 + C (3656) * X ^ 24 + C (292) * X ^ 25 + C (2192) * X ^ 26 + C (576) * X ^ 27
def DC011_17_pim : Polynomial ℚ := C (-360) + C (-432) * X + C (504) * X ^ 2 + C (-1782) * X ^ 3 + C (-1176) * X ^ 4 + C (680) * X ^ 5 + C (-5712) * X ^ 6 + C (-794) * X ^ 7 + C (-1048) * X ^ 8 + C (-10620) * X ^ 9 + C (2274) * X ^ 10 + C (-4904) * X ^ 11 + C (-11756) * X ^ 12 + C (4762) * X ^ 13 + C (-10352) * X ^ 14 + C (-7778) * X ^ 15 + C (4352) * X ^ 16 + C (-12040) * X ^ 17 + C (-1620) * X ^ 18 + C (1914) * X ^ 19 + C (-8222) * X ^ 20 + C (1436) * X ^ 21 + C (-712) * X ^ 22 + C (-3474) * X ^ 23 + C (1624) * X ^ 24 + C (-684) * X ^ 25 + C (-584) * X ^ 26 + C (768) * X ^ 27
theorem DC011_17_ab_pre_eq :
    N_re_0_5 * N_re_1_4 - N_im_0_5 * N_im_1_4 =
      DC011_17_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_4, N_im_1_4, DC011_17_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_17_ab_pim_eq :
    N_re_0_5 * N_im_1_4 + N_im_0_5 * N_re_1_4 =
      DC011_17_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_4, N_im_1_4, DC011_17_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_17_ab_mul :
    N_entry_0_5 * N_entry_1_4 =
      ofLadj DC011_17_ab_pre DC011_17_ab_pim := by
  rw [N_entry_0_5, N_entry_1_4, ofLadj_mul,
    DC011_17_ab_pre_eq, DC011_17_ab_pim_eq]

theorem DC011_17_pre_eq :
    DC011_17_ab_pre * N_re_2_0 - DC011_17_ab_pim * N_im_2_0 =
      DC011_17_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_17_ab_pre, DC011_17_ab_pim, N_re_2_0, N_im_2_0, DC011_17_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_17_pim_eq :
    DC011_17_ab_pre * N_im_2_0 + DC011_17_ab_pim * N_re_2_0 =
      DC011_17_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_17_ab_pre, DC011_17_ab_pim, N_re_2_0, N_im_2_0, DC011_17_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC011_17_mul :
    N_entry_0_5 * N_entry_1_4 * N_entry_2_0 =
      ofLadj DC011_17_pre DC011_17_pim := by
  rw [DC011_17_ab_mul, N_entry_2_0, ofLadj_mul, DC011_17_pre_eq, DC011_17_pim_eq]

def DC011_17_spre : Polynomial ℚ := C (-360) + C (-1440) * X + C (-1416) * X ^ 2 + C (-1266) * X ^ 3 + C (-5436) * X ^ 4 + C (-2480) * X ^ 5 + C (-4436) * X ^ 6 + C (-10718) * X ^ 7 + C (-2848) * X ^ 8 + C (-11340) * X ^ 9 + C (-15734) * X ^ 10 + C (-2744) * X ^ 11 + C (-18880) * X ^ 12 + C (-13954) * X ^ 13 + C (-4876) * X ^ 14 + C (-22078) * X ^ 15 + C (-8952) * X ^ 16 + C (-7572) * X ^ 17 + C (-18988) * X ^ 18 + C (-3586) * X ^ 19 + C (-7686) * X ^ 20 + C (-9884) * X ^ 21 + C (-1128) * X ^ 22 + C (-5298) * X ^ 23 + C (-3656) * X ^ 24 + C (-292) * X ^ 25 + C (-2192) * X ^ 26 + C (-576) * X ^ 27
def DC011_17_spim : Polynomial ℚ := C (360) + C (432) * X + C (-504) * X ^ 2 + C (1782) * X ^ 3 + C (1176) * X ^ 4 + C (-680) * X ^ 5 + C (5712) * X ^ 6 + C (794) * X ^ 7 + C (1048) * X ^ 8 + C (10620) * X ^ 9 + C (-2274) * X ^ 10 + C (4904) * X ^ 11 + C (11756) * X ^ 12 + C (-4762) * X ^ 13 + C (10352) * X ^ 14 + C (7778) * X ^ 15 + C (-4352) * X ^ 16 + C (12040) * X ^ 17 + C (1620) * X ^ 18 + C (-1914) * X ^ 19 + C (8222) * X ^ 20 + C (-1436) * X ^ 21 + C (712) * X ^ 22 + C (3474) * X ^ 23 + C (-1624) * X ^ 24 + C (684) * X ^ 25 + C (584) * X ^ 26 + C (-768) * X ^ 27
theorem DC011_17_spre_eq : -DC011_17_pre = DC011_17_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_17_pre, DC011_17_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_17_spim_eq : -DC011_17_pim = DC011_17_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_17_pim, DC011_17_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_17_smul :
    -(N_entry_0_5 * N_entry_1_4 * N_entry_2_0) =
      ofLadj DC011_17_spre DC011_17_spim := by
  rw [DC011_17_mul, ofLadj_neg, DC011_17_spre_eq, DC011_17_spim_eq]

@[expose] public def detCoeff_011 : Ki :=
  N_entry_0_0 * N_entry_1_4 * N_entry_2_5 + N_entry_0_1 * N_entry_1_5 * N_entry_2_3 + N_entry_0_2 * N_entry_1_3 * N_entry_2_4 + (-(N_entry_0_0 * N_entry_1_5 * N_entry_2_4)) + (-(N_entry_0_1 * N_entry_1_3 * N_entry_2_5)) + (-(N_entry_0_2 * N_entry_1_4 * N_entry_2_3)) + N_entry_0_3 * N_entry_1_1 * N_entry_2_5 + N_entry_0_4 * N_entry_1_2 * N_entry_2_3 + N_entry_0_5 * N_entry_1_0 * N_entry_2_4 + (-(N_entry_0_3 * N_entry_1_2 * N_entry_2_4)) + (-(N_entry_0_4 * N_entry_1_0 * N_entry_2_5)) + (-(N_entry_0_5 * N_entry_1_1 * N_entry_2_3)) + N_entry_0_3 * N_entry_1_4 * N_entry_2_2 + N_entry_0_4 * N_entry_1_5 * N_entry_2_0 + N_entry_0_5 * N_entry_1_3 * N_entry_2_1 + (-(N_entry_0_3 * N_entry_1_5 * N_entry_2_1)) + (-(N_entry_0_4 * N_entry_1_3 * N_entry_2_2)) + (-(N_entry_0_5 * N_entry_1_4 * N_entry_2_0))

theorem detCoeff_011_sum :
    detCoeff_011 = ofLadj (DC011_0_pre + DC011_1_pre + DC011_2_pre + DC011_3_spre + DC011_4_spre + DC011_5_spre + DC011_6_pre + DC011_7_pre + DC011_8_pre + DC011_9_spre + DC011_10_spre + DC011_11_spre + DC011_12_pre + DC011_13_pre + DC011_14_pre + DC011_15_spre + DC011_16_spre + DC011_17_spre) (DC011_0_pim + DC011_1_pim + DC011_2_pim + DC011_3_spim + DC011_4_spim + DC011_5_spim + DC011_6_pim + DC011_7_pim + DC011_8_pim + DC011_9_spim + DC011_10_spim + DC011_11_spim + DC011_12_pim + DC011_13_pim + DC011_14_pim + DC011_15_spim + DC011_16_spim + DC011_17_spim) := by
  simp only [detCoeff_011, DC011_0_mul, DC011_1_mul, DC011_2_mul, DC011_3_smul, DC011_4_smul, DC011_5_smul, DC011_6_mul, DC011_7_mul, DC011_8_mul, DC011_9_smul, DC011_10_smul, DC011_11_smul, DC011_12_mul, DC011_13_mul, DC011_14_mul, DC011_15_smul, DC011_16_smul, DC011_17_smul]
  simpa [add_assoc] using ofLadj_add18 DC011_0_pre DC011_0_pim DC011_1_pre DC011_1_pim DC011_2_pre DC011_2_pim DC011_3_spre DC011_3_spim DC011_4_spre DC011_4_spim DC011_5_spre DC011_5_spim DC011_6_pre DC011_6_pim DC011_7_pre DC011_7_pim DC011_8_pre DC011_8_pim DC011_9_spre DC011_9_spim DC011_10_spre DC011_10_spim DC011_11_spre DC011_11_spim DC011_12_pre DC011_12_pim DC011_13_pre DC011_13_pim DC011_14_pre DC011_14_pim DC011_15_spre DC011_15_spim DC011_16_spre DC011_16_spim DC011_17_spre DC011_17_spim

def DC011_s0_re : Polynomial ℚ := DC011_0_pre + DC011_1_pre + DC011_2_pre + DC011_3_spre + DC011_4_spre + DC011_5_spre
def DC011_s0_im : Polynomial ℚ := DC011_0_pim + DC011_1_pim + DC011_2_pim + DC011_3_spim + DC011_4_spim + DC011_5_spim
def DC011_g0_qre : Polynomial ℚ := C (1053) + C (-181) * X + C (724) * X ^ 2 + C ((563 / 2 : ℚ)) * X ^ 3 + C (2352) * X ^ 4 + C (553) * X ^ 5 + C ((2011 / 2 : ℚ)) * X ^ 6 + C (3328) * X ^ 7 + C (-1666) * X ^ 8 + C (359) * X ^ 9 + C (536) * X ^ 10 + C (-3940) * X ^ 11 + C (-963) * X ^ 12 + C (-2011) * X ^ 13 + C (-2922) * X ^ 14 + C (-606) * X ^ 15 + C (-1024) * X ^ 16 + C (-948) * X ^ 17
def DC011_g0_qim : Polynomial ℚ := C (-203) + C (-263) * X + C (-167) * X ^ 2 + C ((-1961 / 2 : ℚ)) * X ^ 3 + C (-1055) * X ^ 4 + C (-316) * X ^ 5 + C ((-7627 / 2 : ℚ)) * X ^ 6 + C (-2300) * X ^ 7 + C (-2641) * X ^ 8 + C (-6825) * X ^ 9 + C (-1540) * X ^ 10 + C (-3008) * X ^ 11 + C (-3851) * X ^ 12 + C (-115) * X ^ 13 + C (-1166) * X ^ 14 + C (-846) * X ^ 15 + C (506) * X ^ 16 + C (-404) * X ^ 17
def DC011_g0_rre : Polynomial ℚ := C ((-3137 / 2 : ℚ)) + C ((-969 / 2 : ℚ)) * X ^ 2 + C ((-2845 / 2 : ℚ)) * X ^ 3 + C ((581 / 2 : ℚ)) * X ^ 4 + C (-1017) * X ^ 5 + C (-1017) * X ^ 6 + C ((581 / 2 : ℚ)) * X ^ 7 + C ((-2845 / 2 : ℚ)) * X ^ 8 + C ((-969 / 2 : ℚ)) * X ^ 9
def DC011_g0_rim : Polynomial ℚ := C ((-1439 / 2 : ℚ)) + C (-1439) * X + C ((443 / 2 : ℚ)) * X ^ 2 + C ((-2471 / 2 : ℚ)) * X ^ 3 + C ((-1975 / 2 : ℚ)) * X ^ 4 + C (143) * X ^ 5 + C (-1582) * X ^ 6 + C ((-903 / 2 : ℚ)) * X ^ 7 + C ((-407 / 2 : ℚ)) * X ^ 8 + C ((-3321 / 2 : ℚ)) * X ^ 9
def DC011_g0a_qre : Polynomial ℚ := C (598896) + C (-560116) * X + C (174309) * X ^ 2 + C ((681413 / 2 : ℚ)) * X ^ 3 + C (-524055) * X ^ 4 + C (391218) * X ^ 5 + C ((103563 / 2 : ℚ)) * X ^ 6 + C (-305031) * X ^ 7 + C (385656) * X ^ 8 + C (-103115) * X ^ 9 + C (-64884) * X ^ 10 + C (212396) * X ^ 11 + C (-105417) * X ^ 12 + C (31499) * X ^ 13 + C (75623) * X ^ 14 + C (-42303) * X ^ 15 + C (30016) * X ^ 16 + C (13084) * X ^ 17
def DC011_g0a_rre : Polynomial ℚ := C ((-1204329 / 2 : ℚ)) + C ((-372945 / 2 : ℚ)) * X ^ 2 + C ((-1088125 / 2 : ℚ)) * X ^ 3 + C ((222269 / 2 : ℚ)) * X ^ 4 + C (-388988) * X ^ 5 + C (-388988) * X ^ 6 + C ((222269 / 2 : ℚ)) * X ^ 7 + C ((-1088125 / 2 : ℚ)) * X ^ 8 + C ((-372945 / 2 : ℚ)) * X ^ 9
theorem DC011_g0a_re :
    DC011_0_pre + DC011_1_pre + DC011_2_pre =
      DC011_g0a_rre + Phi11 * DC011_g0a_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_0_pre, DC011_1_pre, DC011_2_pre, DC011_g0a_rre, DC011_g0a_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
def DC011_g0b_qre : Polynomial ℚ := C (-597843) + C (559935) * X + C (-173585) * X ^ 2 + C (-340425) * X ^ 3 + C (526407) * X ^ 4 + C (-390665) * X ^ 5 + C (-50776) * X ^ 6 + C (308359) * X ^ 7 + C (-387322) * X ^ 8 + C (103474) * X ^ 9 + C (65420) * X ^ 10 + C (-216336) * X ^ 11 + C (104454) * X ^ 12 + C (-33510) * X ^ 13 + C (-78545) * X ^ 14 + C (41697) * X ^ 15 + C (-31040) * X ^ 16 + C (-14032) * X ^ 17
def DC011_g0b_rre : Polynomial ℚ := C (600596) + C (185988) * X ^ 2 + C (542640) * X ^ 3 + C (-110844) * X ^ 4 + C (387971) * X ^ 5 + C (387971) * X ^ 6 + C (-110844) * X ^ 7 + C (542640) * X ^ 8 + C (185988) * X ^ 9
theorem DC011_g0b_re :
    DC011_3_spre + DC011_4_spre + DC011_5_spre =
      DC011_g0b_rre + Phi11 * DC011_g0b_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_3_spre, DC011_4_spre, DC011_5_spre, DC011_g0b_rre, DC011_g0b_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem DC011_g0_rre_split :
    DC011_g0a_rre + DC011_g0b_rre = DC011_g0_rre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_g0a_rre, DC011_g0b_rre, DC011_g0_rre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_g0_qre_split :
    DC011_g0a_qre + DC011_g0b_qre = DC011_g0_qre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_g0a_qre, DC011_g0b_qre, DC011_g0_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
def DC011_g0a_qim : Polynomial ℚ := C (256724) + C (262964) * X + C (-595000) * X ^ 2 + C ((939501 / 2 : ℚ)) * X ^ 3 + C (-72082) * X ^ 4 + C (-365559) * X ^ 5 + C ((897453 / 2 : ℚ)) * X ^ 6 + C (-270669) * X ^ 7 + C (-101217) * X ^ 8 + C (250355) * X ^ 9 + C (-240684) * X ^ 10 + C (45450) * X ^ 11 + C (71167) * X ^ 12 + C (-124307) * X ^ 13 + C (51089) * X ^ 14 + C (-395) * X ^ 15 + C (-30928) * X ^ 16 + C (13652) * X ^ 17
def DC011_g0a_rim : Polynomial ℚ := C ((-549639 / 2 : ℚ)) + C (-549639) * X + C ((170963 / 2 : ℚ)) * X ^ 2 + C ((-942431 / 2 : ℚ)) * X ^ 3 + C ((-754375 / 2 : ℚ)) * X ^ 4 + C (56210) * X ^ 5 + C (-605849) * X ^ 6 + C ((-344903 / 2 : ℚ)) * X ^ 7 + C ((-156847 / 2 : ℚ)) * X ^ 8 + C ((-1270241 / 2 : ℚ)) * X ^ 9
theorem DC011_g0a_im :
    DC011_0_pim + DC011_1_pim + DC011_2_pim =
      DC011_g0a_rim + Phi11 * DC011_g0a_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_0_pim, DC011_1_pim, DC011_2_pim, DC011_g0a_rim, DC011_g0a_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
def DC011_g0b_qim : Polynomial ℚ := C (-256927) + C (-263227) * X + C (594833) * X ^ 2 + C (-470731) * X ^ 3 + C (71027) * X ^ 4 + C (365243) * X ^ 5 + C (-452540) * X ^ 6 + C (268369) * X ^ 7 + C (98576) * X ^ 8 + C (-257180) * X ^ 9 + C (239144) * X ^ 10 + C (-48458) * X ^ 11 + C (-75018) * X ^ 12 + C (124192) * X ^ 13 + C (-52255) * X ^ 14 + C (-451) * X ^ 15 + C (31434) * X ^ 16 + C (-14056) * X ^ 17
def DC011_g0b_rim : Polynomial ℚ := C (274100) + C (548200) * X + C (-85260) * X ^ 2 + C (469980) * X ^ 3 + C (376200) * X ^ 4 + C (-56067) * X ^ 5 + C (604267) * X ^ 6 + C (172000) * X ^ 7 + C (78220) * X ^ 8 + C (633460) * X ^ 9
theorem DC011_g0b_im :
    DC011_3_spim + DC011_4_spim + DC011_5_spim =
      DC011_g0b_rim + Phi11 * DC011_g0b_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_3_spim, DC011_4_spim, DC011_5_spim, DC011_g0b_rim, DC011_g0b_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem DC011_g0_rim_split :
    DC011_g0a_rim + DC011_g0b_rim = DC011_g0_rim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_g0a_rim, DC011_g0b_rim, DC011_g0_rim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_g0_qim_split :
    DC011_g0a_qim + DC011_g0b_qim = DC011_g0_qim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_g0a_qim, DC011_g0b_qim, DC011_g0_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_g0_re :
    DC011_s0_re = DC011_g0_rre + Phi11 * DC011_g0_qre := by
  unfold DC011_s0_re
  calc
    DC011_0_pre + DC011_1_pre + DC011_2_pre + DC011_3_spre + DC011_4_spre + DC011_5_spre =
        (DC011_0_pre + DC011_1_pre + DC011_2_pre) + (DC011_3_spre + DC011_4_spre + DC011_5_spre) := by
      ring
    _ = (DC011_g0a_rre + Phi11 * DC011_g0a_qre) +
          (DC011_g0b_rre + Phi11 * DC011_g0b_qre) := by
      rw [DC011_g0a_re, DC011_g0b_re]
    _ = (DC011_g0a_rre + DC011_g0b_rre) +
          Phi11 * (DC011_g0a_qre + DC011_g0b_qre) := by
      ring
    _ = DC011_g0_rre + Phi11 * DC011_g0_qre := by
      rw [DC011_g0_rre_split, DC011_g0_qre_split]
theorem DC011_g0_im :
    DC011_s0_im = DC011_g0_rim + Phi11 * DC011_g0_qim := by
  unfold DC011_s0_im
  calc
    DC011_0_pim + DC011_1_pim + DC011_2_pim + DC011_3_spim + DC011_4_spim + DC011_5_spim =
        (DC011_0_pim + DC011_1_pim + DC011_2_pim) + (DC011_3_spim + DC011_4_spim + DC011_5_spim) := by
      ring
    _ = (DC011_g0a_rim + Phi11 * DC011_g0a_qim) +
          (DC011_g0b_rim + Phi11 * DC011_g0b_qim) := by
      rw [DC011_g0a_im, DC011_g0b_im]
    _ = (DC011_g0a_rim + DC011_g0b_rim) +
          Phi11 * (DC011_g0a_qim + DC011_g0b_qim) := by
      ring
    _ = DC011_g0_rim + Phi11 * DC011_g0_qim := by
      rw [DC011_g0_rim_split, DC011_g0_qim_split]

def DC011_s1_re : Polynomial ℚ := DC011_6_pre + DC011_7_pre + DC011_8_pre + DC011_9_spre + DC011_10_spre + DC011_11_spre
def DC011_s1_im : Polynomial ℚ := DC011_6_pim + DC011_7_pim + DC011_8_pim + DC011_9_spim + DC011_10_spim + DC011_11_spim
def DC011_g1_qre : Polynomial ℚ := C (4082) + C (-1546) * X + C (2256) * X ^ 2 + C (2816) * X ^ 3 + C (-3108) * X ^ 4 + C (1012) * X ^ 5 + C (287) * X ^ 6 + C (-4621) * X ^ 7 + C (2991) * X ^ 8 + C (941) * X ^ 9 + C (642) * X ^ 10 + C (5295) * X ^ 11 + C (1510) * X ^ 12 + C (2456) * X ^ 13 + C (3013) * X ^ 14 + C (106) * X ^ 15 + C (1044) * X ^ 16 + C (320) * X ^ 17
def DC011_g1_qim : Polynomial ℚ := C (678) + C (1026) * X + C (-4868) * X ^ 2 + C (426) * X ^ 3 + C (-2256) * X ^ 4 + C (-6016) * X ^ 5 + C (2095) * X ^ 6 + C (-2325) * X ^ 7 + C (-223) * X ^ 8 + C (4515) * X ^ 9 + C (-1094) * X ^ 10 + C (497) * X ^ 11 + C (1270) * X ^ 12 + C (-2810) * X ^ 13 + C (-1089) * X ^ 14 + C (-668) * X ^ 15 + C (-948) * X ^ 16 + C (94) * X ^ 17
def DC011_g1_rre : Polynomial ℚ := C (-2362) + C (-731) * X ^ 2 + C (-2137) * X ^ 3 + C (440) * X ^ 4 + C (-1528) * X ^ 5 + C (-1528) * X ^ 6 + C (440) * X ^ 7 + C (-2137) * X ^ 8 + C (-731) * X ^ 9
def DC011_g1_rim : Polynomial ℚ := C (-1082) + C (-2164) * X + C (335) * X ^ 2 + C (-1853) * X ^ 3 + C (-1484) * X ^ 4 + C (216) * X ^ 5 + C (-2380) * X ^ 6 + C (-680) * X ^ 7 + C (-311) * X ^ 8 + C (-2499) * X ^ 9
def DC011_g1a_qre : Polynomial ℚ := C (593491) + C (-555831) * X + C (166148) * X ^ 2 + C (339760) * X ^ 3 + C (-523673) * X ^ 4 + C (379978) * X ^ 5 + C (51800) * X ^ 6 + C (-310110) * X ^ 7 + C (373630) * X ^ 8 + C (-93950) * X ^ 9 + C (-73888) * X ^ 10 + C (212006) * X ^ 11 + C (-97830) * X ^ 12 + C (27326) * X ^ 13 + C (78023) * X ^ 14 + C (-38473) * X ^ 15 + C (25388) * X ^ 16 + C (18424) * X ^ 17
def DC011_g1a_rre : Polynomial ℚ := C (-598753) + C (-185416) * X ^ 2 + C (-540947) * X ^ 3 + C (110556) * X ^ 4 + C (-386738) * X ^ 5 + C (-386738) * X ^ 6 + C (110556) * X ^ 7 + C (-540947) * X ^ 8 + C (-185416) * X ^ 9
theorem DC011_g1a_re :
    DC011_6_pre + DC011_7_pre + DC011_8_pre =
      DC011_g1a_rre + Phi11 * DC011_g1a_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_6_pre, DC011_7_pre, DC011_8_pre, DC011_g1a_rre, DC011_g1a_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
def DC011_g1b_qre : Polynomial ℚ := C (-589409) + C (554285) * X + C (-163892) * X ^ 2 + C (-336944) * X ^ 3 + C (520565) * X ^ 4 + C (-378966) * X ^ 5 + C (-51513) * X ^ 6 + C (305489) * X ^ 7 + C (-370639) * X ^ 8 + C (94891) * X ^ 9 + C (74530) * X ^ 10 + C (-206711) * X ^ 11 + C (99340) * X ^ 12 + C (-24870) * X ^ 13 + C (-75010) * X ^ 14 + C (38579) * X ^ 15 + C (-24344) * X ^ 16 + C (-18104) * X ^ 17
def DC011_g1b_rre : Polynomial ℚ := C (596391) + C (184685) * X ^ 2 + C (538810) * X ^ 3 + C (-110116) * X ^ 4 + C (385210) * X ^ 5 + C (385210) * X ^ 6 + C (-110116) * X ^ 7 + C (538810) * X ^ 8 + C (184685) * X ^ 9
theorem DC011_g1b_re :
    DC011_9_spre + DC011_10_spre + DC011_11_spre =
      DC011_g1b_rre + Phi11 * DC011_g1b_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_9_spre, DC011_10_spre, DC011_11_spre, DC011_g1b_rre, DC011_g1b_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem DC011_g1_rre_split :
    DC011_g1a_rre + DC011_g1b_rre = DC011_g1_rre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_g1a_rre, DC011_g1b_rre, DC011_g1_rre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_g1_qre_split :
    DC011_g1a_qre + DC011_g1b_qre = DC011_g1_qre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_g1a_qre, DC011_g1b_qre, DC011_g1_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
def DC011_g1a_qim : Polynomial ℚ := C (254099) + C (259727) * X + C (-594014) * X ^ 2 + C (459026) * X ^ 3 + C (-69891) * X ^ 4 + C (-368456) * X ^ 5 + C (439788) * X ^ 6 + C (-262392) * X ^ 7 + C (-112112) * X ^ 8 + C (247548) * X ^ 9 + C (-234408) * X ^ 10 + C (32216) * X ^ 11 + C (75218) * X ^ 12 + C (-124540) * X ^ 13 + C (43297) * X ^ 14 + C (2155) * X ^ 15 + C (-35374) * X ^ 16 + C (10276) * X ^ 17
def DC011_g1a_rim : Polynomial ℚ := C (-273255) + C (-546510) * X + C (85034) * X ^ 2 + C (-468497) * X ^ 3 + C (-375028) * X ^ 4 + C (55904) * X ^ 5 + C (-602414) * X ^ 6 + C (-171482) * X ^ 7 + C (-78013) * X ^ 8 + C (-631544) * X ^ 9
theorem DC011_g1a_im :
    DC011_6_pim + DC011_7_pim + DC011_8_pim =
      DC011_g1a_rim + Phi11 * DC011_g1a_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_6_pim, DC011_7_pim, DC011_8_pim, DC011_g1a_rim, DC011_g1a_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
def DC011_g1b_qim : Polynomial ℚ := C (-253421) + C (-258701) * X + C (589146) * X ^ 2 + C (-458600) * X ^ 3 + C (67635) * X ^ 4 + C (362440) * X ^ 5 + C (-437693) * X ^ 6 + C (260067) * X ^ 7 + C (111889) * X ^ 8 + C (-243033) * X ^ 9 + C (233314) * X ^ 10 + C (-31719) * X ^ 11 + C (-73948) * X ^ 12 + C (121730) * X ^ 13 + C (-44386) * X ^ 14 + C (-2823) * X ^ 15 + C (34426) * X ^ 16 + C (-10182) * X ^ 17
def DC011_g1b_rim : Polynomial ℚ := C (272173) + C (544346) * X + C (-84699) * X ^ 2 + C (466644) * X ^ 3 + C (373544) * X ^ 4 + C (-55688) * X ^ 5 + C (600034) * X ^ 6 + C (170802) * X ^ 7 + C (77702) * X ^ 8 + C (629045) * X ^ 9
theorem DC011_g1b_im :
    DC011_9_spim + DC011_10_spim + DC011_11_spim =
      DC011_g1b_rim + Phi11 * DC011_g1b_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_9_spim, DC011_10_spim, DC011_11_spim, DC011_g1b_rim, DC011_g1b_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem DC011_g1_rim_split :
    DC011_g1a_rim + DC011_g1b_rim = DC011_g1_rim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_g1a_rim, DC011_g1b_rim, DC011_g1_rim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_g1_qim_split :
    DC011_g1a_qim + DC011_g1b_qim = DC011_g1_qim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_g1a_qim, DC011_g1b_qim, DC011_g1_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_g1_re :
    DC011_s1_re = DC011_g1_rre + Phi11 * DC011_g1_qre := by
  unfold DC011_s1_re
  calc
    DC011_6_pre + DC011_7_pre + DC011_8_pre + DC011_9_spre + DC011_10_spre + DC011_11_spre =
        (DC011_6_pre + DC011_7_pre + DC011_8_pre) + (DC011_9_spre + DC011_10_spre + DC011_11_spre) := by
      ring
    _ = (DC011_g1a_rre + Phi11 * DC011_g1a_qre) +
          (DC011_g1b_rre + Phi11 * DC011_g1b_qre) := by
      rw [DC011_g1a_re, DC011_g1b_re]
    _ = (DC011_g1a_rre + DC011_g1b_rre) +
          Phi11 * (DC011_g1a_qre + DC011_g1b_qre) := by
      ring
    _ = DC011_g1_rre + Phi11 * DC011_g1_qre := by
      rw [DC011_g1_rre_split, DC011_g1_qre_split]
theorem DC011_g1_im :
    DC011_s1_im = DC011_g1_rim + Phi11 * DC011_g1_qim := by
  unfold DC011_s1_im
  calc
    DC011_6_pim + DC011_7_pim + DC011_8_pim + DC011_9_spim + DC011_10_spim + DC011_11_spim =
        (DC011_6_pim + DC011_7_pim + DC011_8_pim) + (DC011_9_spim + DC011_10_spim + DC011_11_spim) := by
      ring
    _ = (DC011_g1a_rim + Phi11 * DC011_g1a_qim) +
          (DC011_g1b_rim + Phi11 * DC011_g1b_qim) := by
      rw [DC011_g1a_im, DC011_g1b_im]
    _ = (DC011_g1a_rim + DC011_g1b_rim) +
          Phi11 * (DC011_g1a_qim + DC011_g1b_qim) := by
      ring
    _ = DC011_g1_rim + Phi11 * DC011_g1_qim := by
      rw [DC011_g1_rim_split, DC011_g1_qim_split]

def DC011_s2_re : Polynomial ℚ := DC011_12_pre + DC011_13_pre + DC011_14_pre + DC011_15_spre + DC011_16_spre + DC011_17_spre
def DC011_s2_im : Polynomial ℚ := DC011_12_pim + DC011_13_pim + DC011_14_pim + DC011_15_spim + DC011_16_spim + DC011_17_spim
def DC011_g2_qre : Polynomial ℚ := C ((-9617 / 2 : ℚ)) + C ((2341 / 2 : ℚ)) * X + C (-3511) * X ^ 2 + C ((-8203 / 2 : ℚ)) * X ^ 3 + C ((-1479 / 2 : ℚ)) * X ^ 4 + C (-3448) * X ^ 5 + C (-3501) * X ^ 6 + C ((-2139 / 2 : ℚ)) * X ^ 7 + C (-3496) * X ^ 8 + C (-3280) * X ^ 9 + C (-3029) * X ^ 10 + C (-3110) * X ^ 11 + C (-1783) * X ^ 12 + C (-1427) * X ^ 13 + C (-930) * X ^ 14 + C (18) * X ^ 15 + C (-343) * X ^ 16 + C (520) * X ^ 17
def DC011_g2_qim : Polynomial ℚ := C ((-1229 / 2 : ℚ)) + C ((-2405 / 2 : ℚ)) * X + C (4226) * X ^ 2 + C ((-425 / 2 : ℚ)) * X ^ 3 + C ((4793 / 2 : ℚ)) * X ^ 4 + C (5190) * X ^ 5 + C (1530) * X ^ 6 + C ((8369 / 2 : ℚ)) * X ^ 7 + C (2839) * X ^ 8 + C (2246) * X ^ 9 + C (2601) * X ^ 10 + C (2468) * X ^ 11 + C (2709) * X ^ 12 + C (2967) * X ^ 13 + C (2374) * X ^ 14 + C (1666) * X ^ 15 + C (759) * X ^ 16 + C (240) * X ^ 17
def DC011_g2_rre : Polynomial ℚ := C (3939) + C ((2441 / 2 : ℚ)) * X ^ 2 + C ((7135 / 2 : ℚ)) * X ^ 3 + C (-731) * X ^ 4 + C (2551) * X ^ 5 + C (2551) * X ^ 6 + C (-731) * X ^ 7 + C ((7135 / 2 : ℚ)) * X ^ 8 + C ((2441 / 2 : ℚ)) * X ^ 9
def DC011_g2_rim : Polynomial ℚ := C (1804) + C (3608) * X + C ((-1119 / 2 : ℚ)) * X ^ 2 + C ((6187 / 2 : ℚ)) * X ^ 3 + C (2475) * X ^ 4 + C (-360) * X ^ 5 + C (3968) * X ^ 6 + C (1133) * X ^ 7 + C ((1029 / 2 : ℚ)) * X ^ 8 + C ((8335 / 2 : ℚ)) * X ^ 9
def DC011_g2a_qre : Polynomial ℚ := C (588943) + C (-559771) * X + C (162682) * X ^ 2 + C (331703) * X ^ 3 + C (-527252) * X ^ 4 + C (374767) * X ^ 5 + C (41228) * X ^ 6 + C (-311147) * X ^ 7 + C (360433) * X ^ 8 + C (-106546) * X ^ 9 + C (-78622) * X ^ 10 + C (197738) * X ^ 11 + C (-104702) * X ^ 12 + C (22070) * X ^ 13 + C (68142) * X ^ 14 + C (-39892) * X ^ 15 + C (21973) * X ^ 16 + C (14796) * X ^ 17
def DC011_g2a_rre : Polynomial ℚ := C (-599455) + C (-185654) * X ^ 2 + C (-541631) * X ^ 3 + C (110620) * X ^ 4 + C (-387278) * X ^ 5 + C (-387278) * X ^ 6 + C (110620) * X ^ 7 + C (-541631) * X ^ 8 + C (-185654) * X ^ 9
theorem DC011_g2a_re :
    DC011_12_pre + DC011_13_pre + DC011_14_pre =
      DC011_g2a_rre + Phi11 * DC011_g2a_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_12_pre, DC011_13_pre, DC011_14_pre, DC011_g2a_rre, DC011_g2a_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
def DC011_g2b_qre : Polynomial ℚ := C ((-1187503 / 2 : ℚ)) + C ((1121883 / 2 : ℚ)) * X + C (-166193) * X ^ 2 + C ((-671609 / 2 : ℚ)) * X ^ 3 + C ((1053025 / 2 : ℚ)) * X ^ 4 + C (-378215) * X ^ 5 + C (-44729) * X ^ 6 + C ((620155 / 2 : ℚ)) * X ^ 7 + C (-363929) * X ^ 8 + C (103266) * X ^ 9 + C (75593) * X ^ 10 + C (-200848) * X ^ 11 + C (102919) * X ^ 12 + C (-23497) * X ^ 13 + C (-69072) * X ^ 14 + C (39910) * X ^ 15 + C (-22316) * X ^ 16 + C (-14276) * X ^ 17
def DC011_g2b_rre : Polynomial ℚ := C (603394) + C ((373749 / 2 : ℚ)) * X ^ 2 + C ((1090397 / 2 : ℚ)) * X ^ 3 + C (-111351) * X ^ 4 + C (389829) * X ^ 5 + C (389829) * X ^ 6 + C (-111351) * X ^ 7 + C ((1090397 / 2 : ℚ)) * X ^ 8 + C ((373749 / 2 : ℚ)) * X ^ 9
theorem DC011_g2b_re :
    DC011_15_spre + DC011_16_spre + DC011_17_spre =
      DC011_g2b_rre + Phi11 * DC011_g2b_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_15_spre, DC011_16_spre, DC011_17_spre, DC011_g2b_rre, DC011_g2b_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem DC011_g2_rre_split :
    DC011_g2a_rre + DC011_g2b_rre = DC011_g2_rre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_g2a_rre, DC011_g2b_rre, DC011_g2_rre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_g2_qre_split :
    DC011_g2a_qre + DC011_g2b_qre = DC011_g2_qre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_g2a_qre, DC011_g2b_qre, DC011_g2_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
def DC011_g2a_qim : Polynomial ℚ := C (254685) + C (258213) * X + C (-591396) * X ^ 2 + C (458725) * X ^ 3 + C (-72104) * X ^ 4 + C (-362553) * X ^ 5 + C (435286) * X ^ 6 + C (-265399) * X ^ 7 + C (-109773) * X ^ 8 + C (236882) * X ^ 9 + C (-234800) * X ^ 10 + C (32430) * X ^ 11 + C (68324) * X ^ 12 + C (-121590) * X ^ 13 + C (43548) * X ^ 14 + C (-164) * X ^ 15 + C (-33893) * X ^ 16 + C (8708) * X ^ 17
def DC011_g2a_rim : Polynomial ℚ := C (-273603) + C (-547206) * X + C (85066) * X ^ 2 + C (-469119) * X ^ 3 + C (-375534) * X ^ 4 + C (55938) * X ^ 5 + C (-603144) * X ^ 6 + C (-171672) * X ^ 7 + C (-78087) * X ^ 8 + C (-632272) * X ^ 9
theorem DC011_g2a_im :
    DC011_12_pim + DC011_13_pim + DC011_14_pim =
      DC011_g2a_rim + Phi11 * DC011_g2a_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_12_pim, DC011_13_pim, DC011_14_pim, DC011_g2a_rim, DC011_g2a_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
def DC011_g2b_qim : Polynomial ℚ := C ((-510599 / 2 : ℚ)) + C ((-518831 / 2 : ℚ)) * X + C (595622) * X ^ 2 + C ((-917875 / 2 : ℚ)) * X ^ 3 + C ((149001 / 2 : ℚ)) * X ^ 4 + C (367743) * X ^ 5 + C (-433756) * X ^ 6 + C ((539167 / 2 : ℚ)) * X ^ 7 + C (112612) * X ^ 8 + C (-234636) * X ^ 9 + C (237401) * X ^ 10 + C (-29962) * X ^ 11 + C (-65615) * X ^ 12 + C (124557) * X ^ 13 + C (-41174) * X ^ 14 + C (1830) * X ^ 15 + C (34652) * X ^ 16 + C (-8468) * X ^ 17
def DC011_g2b_rim : Polynomial ℚ := C (275407) + C (550814) * X + C ((-171251 / 2 : ℚ)) * X ^ 2 + C ((944425 / 2 : ℚ)) * X ^ 3 + C (378009) * X ^ 4 + C (-56298) * X ^ 5 + C (607112) * X ^ 6 + C (172805) * X ^ 7 + C ((157203 / 2 : ℚ)) * X ^ 8 + C ((1272879 / 2 : ℚ)) * X ^ 9
theorem DC011_g2b_im :
    DC011_15_spim + DC011_16_spim + DC011_17_spim =
      DC011_g2b_rim + Phi11 * DC011_g2b_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_15_spim, DC011_16_spim, DC011_17_spim, DC011_g2b_rim, DC011_g2b_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem DC011_g2_rim_split :
    DC011_g2a_rim + DC011_g2b_rim = DC011_g2_rim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_g2a_rim, DC011_g2b_rim, DC011_g2_rim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_g2_qim_split :
    DC011_g2a_qim + DC011_g2b_qim = DC011_g2_qim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC011_g2a_qim, DC011_g2b_qim, DC011_g2_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC011_g2_re :
    DC011_s2_re = DC011_g2_rre + Phi11 * DC011_g2_qre := by
  unfold DC011_s2_re
  calc
    DC011_12_pre + DC011_13_pre + DC011_14_pre + DC011_15_spre + DC011_16_spre + DC011_17_spre =
        (DC011_12_pre + DC011_13_pre + DC011_14_pre) + (DC011_15_spre + DC011_16_spre + DC011_17_spre) := by
      ring
    _ = (DC011_g2a_rre + Phi11 * DC011_g2a_qre) +
          (DC011_g2b_rre + Phi11 * DC011_g2b_qre) := by
      rw [DC011_g2a_re, DC011_g2b_re]
    _ = (DC011_g2a_rre + DC011_g2b_rre) +
          Phi11 * (DC011_g2a_qre + DC011_g2b_qre) := by
      ring
    _ = DC011_g2_rre + Phi11 * DC011_g2_qre := by
      rw [DC011_g2_rre_split, DC011_g2_qre_split]
theorem DC011_g2_im :
    DC011_s2_im = DC011_g2_rim + Phi11 * DC011_g2_qim := by
  unfold DC011_s2_im
  calc
    DC011_12_pim + DC011_13_pim + DC011_14_pim + DC011_15_spim + DC011_16_spim + DC011_17_spim =
        (DC011_12_pim + DC011_13_pim + DC011_14_pim) + (DC011_15_spim + DC011_16_spim + DC011_17_spim) := by
      ring
    _ = (DC011_g2a_rim + Phi11 * DC011_g2a_qim) +
          (DC011_g2b_rim + Phi11 * DC011_g2b_qim) := by
      rw [DC011_g2a_im, DC011_g2b_im]
    _ = (DC011_g2a_rim + DC011_g2b_rim) +
          Phi11 * (DC011_g2a_qim + DC011_g2b_qim) := by
      ring
    _ = DC011_g2_rim + Phi11 * DC011_g2_qim := by
      rw [DC011_g2_rim_split, DC011_g2_qim_split]
def DC011_g3_qre : Polynomial ℚ := (0 : Polynomial ℚ)
def DC011_g3_qim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem DC011_rem_re :
    DC011_g0_rre + DC011_g1_rre + DC011_g2_rre =
      Fplus_re_011 + Phi11 * DC011_g3_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_g0_rre, DC011_g1_rre, DC011_g2_rre, Fplus_re_011, DC011_g3_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind
theorem DC011_rem_im :
    DC011_g0_rim + DC011_g1_rim + DC011_g2_rim =
      Fplus_im_011 + Phi11 * DC011_g3_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC011_g0_rim, DC011_g1_rim, DC011_g2_rim, Fplus_im_011, DC011_g3_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind

theorem DC011_sum18_re :
    DC011_0_pre + DC011_1_pre + DC011_2_pre + DC011_3_spre + DC011_4_spre + DC011_5_spre + DC011_6_pre + DC011_7_pre + DC011_8_pre + DC011_9_spre + DC011_10_spre + DC011_11_spre + DC011_12_pre + DC011_13_pre + DC011_14_pre + DC011_15_spre + DC011_16_spre + DC011_17_spre = DC011_s0_re + DC011_s1_re + DC011_s2_re := by
  unfold DC011_s0_re DC011_s1_re DC011_s2_re
  ring
theorem DC011_sum18_im :
    DC011_0_pim + DC011_1_pim + DC011_2_pim + DC011_3_spim + DC011_4_spim + DC011_5_spim + DC011_6_pim + DC011_7_pim + DC011_8_pim + DC011_9_spim + DC011_10_spim + DC011_11_spim + DC011_12_pim + DC011_13_pim + DC011_14_pim + DC011_15_spim + DC011_16_spim + DC011_17_spim = DC011_s0_im + DC011_s1_im + DC011_s2_im := by
  unfold DC011_s0_im DC011_s1_im DC011_s2_im
  ring

theorem detCoeff_011_sum_poly_re :
    DC011_0_pre + DC011_1_pre + DC011_2_pre + DC011_3_spre + DC011_4_spre + DC011_5_spre + DC011_6_pre + DC011_7_pre + DC011_8_pre + DC011_9_spre + DC011_10_spre + DC011_11_spre + DC011_12_pre + DC011_13_pre + DC011_14_pre + DC011_15_spre + DC011_16_spre + DC011_17_spre =
      Fplus_re_011 + Phi11 * (DC011_g0_qre + DC011_g1_qre + DC011_g2_qre + DC011_g3_qre) := by
  calc
    DC011_0_pre + DC011_1_pre + DC011_2_pre + DC011_3_spre + DC011_4_spre + DC011_5_spre + DC011_6_pre + DC011_7_pre + DC011_8_pre + DC011_9_spre + DC011_10_spre + DC011_11_spre + DC011_12_pre + DC011_13_pre + DC011_14_pre + DC011_15_spre + DC011_16_spre + DC011_17_spre = DC011_s0_re + DC011_s1_re + DC011_s2_re :=
      DC011_sum18_re
    _ = (DC011_g0_rre + Phi11 * DC011_g0_qre) +
          (DC011_g1_rre + Phi11 * DC011_g1_qre) +
            (DC011_g2_rre + Phi11 * DC011_g2_qre) := by
      rw [DC011_g0_re, DC011_g1_re, DC011_g2_re]
    _ = (DC011_g0_rre + DC011_g1_rre + DC011_g2_rre) +
          Phi11 * (DC011_g0_qre + DC011_g1_qre + DC011_g2_qre) := by
      ring
    _ = (Fplus_re_011 + Phi11 * DC011_g3_qre) +
          Phi11 * (DC011_g0_qre + DC011_g1_qre + DC011_g2_qre) := by
      rw [DC011_rem_re]
    _ = Fplus_re_011 + Phi11 * (DC011_g0_qre + DC011_g1_qre + DC011_g2_qre + DC011_g3_qre) := by
      ring

theorem detCoeff_011_sum_poly_im :
    DC011_0_pim + DC011_1_pim + DC011_2_pim + DC011_3_spim + DC011_4_spim + DC011_5_spim + DC011_6_pim + DC011_7_pim + DC011_8_pim + DC011_9_spim + DC011_10_spim + DC011_11_spim + DC011_12_pim + DC011_13_pim + DC011_14_pim + DC011_15_spim + DC011_16_spim + DC011_17_spim =
      Fplus_im_011 + Phi11 * (DC011_g0_qim + DC011_g1_qim + DC011_g2_qim + DC011_g3_qim) := by
  calc
    DC011_0_pim + DC011_1_pim + DC011_2_pim + DC011_3_spim + DC011_4_spim + DC011_5_spim + DC011_6_pim + DC011_7_pim + DC011_8_pim + DC011_9_spim + DC011_10_spim + DC011_11_spim + DC011_12_pim + DC011_13_pim + DC011_14_pim + DC011_15_spim + DC011_16_spim + DC011_17_spim = DC011_s0_im + DC011_s1_im + DC011_s2_im :=
      DC011_sum18_im
    _ = (DC011_g0_rim + Phi11 * DC011_g0_qim) +
          (DC011_g1_rim + Phi11 * DC011_g1_qim) +
            (DC011_g2_rim + Phi11 * DC011_g2_qim) := by
      rw [DC011_g0_im, DC011_g1_im, DC011_g2_im]
    _ = (DC011_g0_rim + DC011_g1_rim + DC011_g2_rim) +
          Phi11 * (DC011_g0_qim + DC011_g1_qim + DC011_g2_qim) := by
      ring
    _ = (Fplus_im_011 + Phi11 * DC011_g3_qim) +
          Phi11 * (DC011_g0_qim + DC011_g1_qim + DC011_g2_qim) := by
      rw [DC011_rem_im]
    _ = Fplus_im_011 + Phi11 * (DC011_g0_qim + DC011_g1_qim + DC011_g2_qim + DC011_g3_qim) := by
      ring

public theorem detCoeff_011_eq :
    detCoeff_011 = ofLadj Fplus_re_011 Fplus_im_011 := by
  rw [detCoeff_011_sum, detCoeff_011_sum_poly_re,
    detCoeff_011_sum_poly_im, ofLadj_add_Phi11]
end V14Formalization.D12SigmaPlusSegreCore
