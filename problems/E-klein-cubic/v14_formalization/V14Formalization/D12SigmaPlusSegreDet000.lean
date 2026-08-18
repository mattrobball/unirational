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

def DC000_0_ab_pre : Polynomial ℚ := C (-44) + C (-50) * X ^ 2 + C (-61) * X ^ 3 + C (2) * X ^ 4 + C (-54) * X ^ 5 + C (-44) * X ^ 6 + C (28) * X ^ 7 + C (-85) * X ^ 8 + C (-41) * X ^ 9 + C (2) * X ^ 10 + C (-86) * X ^ 11 + C (2) * X ^ 12 + C (9) * X ^ 13 + C (-24) * X ^ 14 + C (38) * X ^ 15 + C (8) * X ^ 16 + C (-2) * X ^ 17 + C (12) * X ^ 18
def DC000_0_ab_pim : Polynomial ℚ := C (-16) + C (-32) * X + C (26) * X ^ 2 + C (-27) * X ^ 3 + C (-14) * X ^ 4 + C (44) * X ^ 5 + C (-77) * X ^ 6 + C (5) * X ^ 7 + C (-27) * X ^ 8 + C (-121) * X ^ 9 + C (1) * X ^ 10 + C (-24) * X ^ 11 + C (-49) * X ^ 12 + C (15) * X ^ 13 + C (-26) * X ^ 14 + C (-39) * X ^ 15 + C (-9) * X ^ 16 + C (-38) * X ^ 17 + C (-32) * X ^ 18
def DC000_0_pre : Polynomial ℚ := C (-436) + C (192) * X + C (-644) * X ^ 2 + C (-1154) * X ^ 3 + C (306) * X ^ 4 + C (-1792) * X ^ 5 + C (-1425) * X ^ 6 + C (793) * X ^ 7 + C (-3446) * X ^ 8 + C (-392) * X ^ 9 + C (558) * X ^ 10 + C (-4286) * X ^ 11 + C (1179) * X ^ 12 + C (-378) * X ^ 13 + C (-3072) * X ^ 14 + C (2586) * X ^ 15 + C (-919) * X ^ 16 + C (-982) * X ^ 17 + C (2515) * X ^ 18 + C (-652) * X ^ 19 + C (322) * X ^ 20 + C (1638) * X ^ 21 + C (-66) * X ^ 22 + C (825) * X ^ 23 + C (952) * X ^ 24 + C (128) * X ^ 25 + C (416) * X ^ 26 + C (304) * X ^ 27
def DC000_0_pim : Polynomial ℚ := C (-308) + C (-616) * X + C (160) * X ^ 2 + C (-1332) * X ^ 3 + C (-866) * X ^ 4 + C (296) * X ^ 5 + C (-2955) * X ^ 6 + C (-253) * X ^ 7 + C (-958) * X ^ 8 + C (-4862) * X ^ 9 + C (188) * X ^ 10 + C (-2710) * X ^ 11 + C (-4687) * X ^ 12 + C (608) * X ^ 13 + C (-3920) * X ^ 14 + C (-3286) * X ^ 15 + C (189) * X ^ 16 + C (-4238) * X ^ 17 + C (-1847) * X ^ 18 + C (-158) * X ^ 19 + C (-2548) * X ^ 20 + C (-394) * X ^ 21 + C (-352) * X ^ 22 + C (-1231) * X ^ 23 + C (-98) * X ^ 24 + C (-372) * X ^ 25 + C (-488) * X ^ 26 + C (-32) * X ^ 27
theorem DC000_0_ab_pre_eq :
    N_re_0_0 * N_re_1_1 - N_im_0_0 * N_im_1_1 =
      DC000_0_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_1, N_im_1_1, DC000_0_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_0_ab_pim_eq :
    N_re_0_0 * N_im_1_1 + N_im_0_0 * N_re_1_1 =
      DC000_0_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_1, N_im_1_1, DC000_0_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_0_ab_mul :
    N_entry_0_0 * N_entry_1_1 =
      ofLadj DC000_0_ab_pre DC000_0_ab_pim := by
  rw [N_entry_0_0, N_entry_1_1, ofLadj_mul,
    DC000_0_ab_pre_eq, DC000_0_ab_pim_eq]

theorem DC000_0_pre_eq :
    DC000_0_ab_pre * N_re_2_2 - DC000_0_ab_pim * N_im_2_2 =
      DC000_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_0_ab_pre, DC000_0_ab_pim, N_re_2_2, N_im_2_2, DC000_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_0_pim_eq :
    DC000_0_ab_pre * N_im_2_2 + DC000_0_ab_pim * N_re_2_2 =
      DC000_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_0_ab_pre, DC000_0_ab_pim, N_re_2_2, N_im_2_2, DC000_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_0_mul :
    N_entry_0_0 * N_entry_1_1 * N_entry_2_2 =
      ofLadj DC000_0_pre DC000_0_pim := by
  rw [DC000_0_ab_mul, N_entry_2_2, ofLadj_mul, DC000_0_pre_eq, DC000_0_pim_eq]

def DC000_1_ab_pre : Polynomial ℚ := C (-31) + C (96) * X + C (59) * X ^ 2 + C (-18) * X ^ 3 + C (231) * X ^ 4 + C (5) * X ^ 5 + C (21) * X ^ 6 + C (257) * X ^ 7 + C (-143) * X ^ 8 + C (102) * X ^ 9 + C (212) * X ^ 10 + C (-166) * X ^ 11 + C (116) * X ^ 12 + C (43) * X ^ 13 + C (-125) * X ^ 14 + C (92) * X ^ 15 + C (-21) * X ^ 16 + C (-37) * X ^ 17 + C (66) * X ^ 18
def DC000_1_ab_pim : Polynomial ℚ := C (-73) + C (-146) * X + C (-49) * X ^ 2 + C (-278) * X ^ 3 + C (-277) * X ^ 4 + C (-185) * X ^ 5 + C (-537) * X ^ 6 + C (-349) * X ^ 7 + C (-337) * X ^ 8 + C (-728) * X ^ 9 + C (-280) * X ^ 10 + C (-386) * X ^ 11 + C (-492) * X ^ 12 + C (-141) * X ^ 13 + C (-303) * X ^ 14 + C (-232) * X ^ 15 + C (-45) * X ^ 16 + C (-151) * X ^ 17 + C (-60) * X ^ 18
def DC000_1_pre : Polynomial ℚ := C (146) + C (584) * X + C (682) * X ^ 2 + C ((1787 / 2 : ℚ)) * X ^ 3 + C (2521) * X ^ 4 + C (2037) * X ^ 5 + C ((6485 / 2 : ℚ)) * X ^ 6 + C (5783) * X ^ 7 + C ((7817 / 2 : ℚ)) * X ^ 8 + C (7192) * X ^ 9 + C (9083) * X ^ 10 + C ((10495 / 2 : ℚ)) * X ^ 11 + C ((21165 / 2 : ℚ)) * X ^ 12 + C ((17979 / 2 : ℚ)) * X ^ 13 + C (6059) * X ^ 14 + C ((22275 / 2 : ℚ)) * X ^ 15 + C (6593) * X ^ 16 + C ((11255 / 2 : ℚ)) * X ^ 17 + C ((17409 / 2 : ℚ)) * X ^ 18 + C ((6673 / 2 : ℚ)) * X ^ 19 + C (4024) * X ^ 20 + C (4363) * X ^ 21 + C ((2455 / 2 : ℚ)) * X ^ 22 + C ((4559 / 2 : ℚ)) * X ^ 23 + C ((3089 / 2 : ℚ)) * X ^ 24 + C ((585 / 2 : ℚ)) * X ^ 25 + C (829) * X ^ 26 + C (240) * X ^ 27
def DC000_1_pim : Polynomial ℚ := C (-62) + C (68) * X + C (502) * X ^ 2 + C ((-151 / 2 : ℚ)) * X ^ 3 + C (324) * X ^ 4 + C (1082) * X ^ 5 + C ((-1875 / 2 : ℚ)) * X ^ 6 + C (674) * X ^ 7 + C ((845 / 2 : ℚ)) * X ^ 8 + C (-2640) * X ^ 9 + C (1189) * X ^ 10 + C ((-2767 / 2 : ℚ)) * X ^ 11 + C ((-7785 / 2 : ℚ)) * X ^ 12 + C ((1953 / 2 : ℚ)) * X ^ 13 + C (-4020) * X ^ 14 + C ((-7033 / 2 : ℚ)) * X ^ 15 + C (228) * X ^ 16 + C ((-9889 / 2 : ℚ)) * X ^ 17 + C ((-3115 / 2 : ℚ)) * X ^ 18 + C ((-657 / 2 : ℚ)) * X ^ 19 + C (-3440) * X ^ 20 + C (-218) * X ^ 21 + C ((-1417 / 2 : ℚ)) * X ^ 22 + C ((-2909 / 2 : ℚ)) * X ^ 23 + C ((587 / 2 : ℚ)) * X ^ 24 + C ((-613 / 2 : ℚ)) * X ^ 25 + C (-232) * X ^ 26 + C (264) * X ^ 27
theorem DC000_1_ab_pre_eq :
    N_re_0_1 * N_re_1_2 - N_im_0_1 * N_im_1_2 =
      DC000_1_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_2, N_im_1_2, DC000_1_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_1_ab_pim_eq :
    N_re_0_1 * N_im_1_2 + N_im_0_1 * N_re_1_2 =
      DC000_1_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_2, N_im_1_2, DC000_1_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_1_ab_mul :
    N_entry_0_1 * N_entry_1_2 =
      ofLadj DC000_1_ab_pre DC000_1_ab_pim := by
  rw [N_entry_0_1, N_entry_1_2, ofLadj_mul,
    DC000_1_ab_pre_eq, DC000_1_ab_pim_eq]

theorem DC000_1_pre_eq :
    DC000_1_ab_pre * N_re_2_0 - DC000_1_ab_pim * N_im_2_0 =
      DC000_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_1_ab_pre, DC000_1_ab_pim, N_re_2_0, N_im_2_0, DC000_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_1_pim_eq :
    DC000_1_ab_pre * N_im_2_0 + DC000_1_ab_pim * N_re_2_0 =
      DC000_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_1_ab_pre, DC000_1_ab_pim, N_re_2_0, N_im_2_0, DC000_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_1_mul :
    N_entry_0_1 * N_entry_1_2 * N_entry_2_0 =
      ofLadj DC000_1_pre DC000_1_pim := by
  rw [DC000_1_ab_mul, N_entry_2_0, ofLadj_mul, DC000_1_pre_eq, DC000_1_pim_eq]

def DC000_2_ab_pre : Polynomial ℚ := C (-3) + C (12) * X + C (13) * X ^ 2 + C (-1) * X ^ 3 + C (27) * X ^ 4 + C (-3) * X ^ 5 + C (5) * X ^ 6 + C (35) * X ^ 7 + C (-1) * X ^ 8 + C (29) * X ^ 9 + C (56) * X ^ 10 + C (4) * X ^ 11 + C (44) * X ^ 12 + C (16) * X ^ 13 + C (16) * X ^ 15 + C (2) * X ^ 16 + C (-6) * X ^ 17 + C (8) * X ^ 18
def DC000_2_ab_pim : Polynomial ℚ := C (-9) + C (-18) * X + C (-4) * X ^ 2 + C (-32) * X ^ 3 + C (-27) * X ^ 4 + C (-12) * X ^ 5 + C (-50) * X ^ 6 + C (-23) * X ^ 7 + C (-18) * X ^ 8 + C (-60) * X ^ 9 + C (-14) * X ^ 10 + C (-34) * X ^ 11 + C (-54) * X ^ 12 + C (-22) * X ^ 13 + C (-36) * X ^ 14 + C (-36) * X ^ 15 + C (-4) * X ^ 16 + C (-20) * X ^ 17
def DC000_2_pre : Polynomial ℚ := C (-15) + C (528) * X + C ((1031 / 2 : ℚ)) * X ^ 2 + C ((603 / 2 : ℚ)) * X ^ 3 + C ((3745 / 2 : ℚ)) * X ^ 4 + C ((1127 / 2 : ℚ)) * X ^ 5 + C (1255) * X ^ 6 + C ((6801 / 2 : ℚ)) * X ^ 7 + C ((1065 / 2 : ℚ)) * X ^ 8 + C (3462) * X ^ 9 + C (5073) * X ^ 10 + C (983) * X ^ 11 + C (6119) * X ^ 12 + C ((8817 / 2 : ℚ)) * X ^ 13 + C (1805) * X ^ 14 + C ((13377 / 2 : ℚ)) * X ^ 15 + C ((6033 / 2 : ℚ)) * X ^ 16 + C (2385) * X ^ 17 + C ((11227 / 2 : ℚ)) * X ^ 18 + C (1550) * X ^ 19 + C (2413) * X ^ 20 + C (2952) * X ^ 21 + C (499) * X ^ 22 + C (1378) * X ^ 23 + C (951) * X ^ 24 + C (-24) * X ^ 25 + C (453) * X ^ 26 + C (60) * X ^ 27
def DC000_2_pim : Polynomial ℚ := C (-240) + C (-402) * X + C ((177 / 2 : ℚ)) * X ^ 2 + C ((-2029 / 2 : ℚ)) * X ^ 3 + C ((-1583 / 2 : ℚ)) * X ^ 4 + C ((-117 / 2 : ℚ)) * X ^ 5 + C (-2494) * X ^ 6 + C ((-1205 / 2 : ℚ)) * X ^ 7 + C ((-1263 / 2 : ℚ)) * X ^ 8 + C (-3826) * X ^ 9 + C (509) * X ^ 10 + C (-1758) * X ^ 11 + C (-3843) * X ^ 12 + C ((1963 / 2 : ℚ)) * X ^ 13 + C (-3378) * X ^ 14 + C ((-5541 / 2 : ℚ)) * X ^ 15 + C ((1819 / 2 : ℚ)) * X ^ 16 + C (-3679) * X ^ 17 + C ((-1533 / 2 : ℚ)) * X ^ 18 + C (186) * X ^ 19 + C (-2525) * X ^ 20 + C (-112) * X ^ 21 + C (-593) * X ^ 22 + C (-1334) * X ^ 23 + C (99) * X ^ 24 + C (-344) * X ^ 25 + C (-251) * X ^ 26 + C (140) * X ^ 27
theorem DC000_2_ab_pre_eq :
    N_re_0_2 * N_re_1_0 - N_im_0_2 * N_im_1_0 =
      DC000_2_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_0, N_im_1_0, DC000_2_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_2_ab_pim_eq :
    N_re_0_2 * N_im_1_0 + N_im_0_2 * N_re_1_0 =
      DC000_2_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_0, N_im_1_0, DC000_2_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_2_ab_mul :
    N_entry_0_2 * N_entry_1_0 =
      ofLadj DC000_2_ab_pre DC000_2_ab_pim := by
  rw [N_entry_0_2, N_entry_1_0, ofLadj_mul,
    DC000_2_ab_pre_eq, DC000_2_ab_pim_eq]

theorem DC000_2_pre_eq :
    DC000_2_ab_pre * N_re_2_1 - DC000_2_ab_pim * N_im_2_1 =
      DC000_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_2_ab_pre, DC000_2_ab_pim, N_re_2_1, N_im_2_1, DC000_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_2_pim_eq :
    DC000_2_ab_pre * N_im_2_1 + DC000_2_ab_pim * N_re_2_1 =
      DC000_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_2_ab_pre, DC000_2_ab_pim, N_re_2_1, N_im_2_1, DC000_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_2_mul :
    N_entry_0_2 * N_entry_1_0 * N_entry_2_1 =
      ofLadj DC000_2_pre DC000_2_pim := by
  rw [DC000_2_ab_mul, N_entry_2_1, ofLadj_mul, DC000_2_pre_eq, DC000_2_pim_eq]

def DC000_3_ab_pre : Polynomial ℚ := C (-20) + C (-28) * X ^ 2 + C (-40) * X ^ 3 + C (-18) * X ^ 4 + C (-50) * X ^ 5 + C (-48) * X ^ 6 + C (-12) * X ^ 7 + C (-56) * X ^ 8 + C (-24) * X ^ 9 + C (4) * X ^ 10 + C (-34) * X ^ 11 + C (4) * X ^ 12 + C (4) * X ^ 13 + C (-16) * X ^ 14 + C (10) * X ^ 15 + C (-4) * X ^ 16 + C (-6) * X ^ 17 + C (4) * X ^ 18
def DC000_3_ab_pim : Polynomial ℚ := C (-12) + C (-24) * X + C (-30) * X ^ 3 + C (-22) * X ^ 4 + C (8) * X ^ 5 + C (-38) * X ^ 6 + C (6) * X ^ 7 + C (-4) * X ^ 8 + C (-50) * X ^ 9 + C (-18) * X ^ 11 + C (-36) * X ^ 12 + C (-10) * X ^ 13 + C (-26) * X ^ 14 + C (-28) * X ^ 15 + C (-10) * X ^ 16 + C (-20) * X ^ 17 + C (-16) * X ^ 18
def DC000_3_pre : Polynomial ℚ := C (-412) + C (312) * X + C (-578) * X ^ 2 + C (-1113) * X ^ 3 + C (322) * X ^ 4 + C (-2028) * X ^ 5 + C (-1772) * X ^ 6 + C (304) * X ^ 7 + C (-4060) * X ^ 8 + C (-867) * X ^ 9 + C (153) * X ^ 10 + C (-4608) * X ^ 11 + C (884) * X ^ 12 + C (-588) * X ^ 13 + C (-3253) * X ^ 14 + C (2396) * X ^ 15 + C (-892) * X ^ 16 + C (-838) * X ^ 17 + C (2801) * X ^ 18 + C (-218) * X ^ 19 + C (631) * X ^ 20 + C (1875) * X ^ 21 + C (92) * X ^ 22 + C (832) * X ^ 23 + C (930) * X ^ 24 + C (88) * X ^ 25 + C (387) * X ^ 26 + C (310) * X ^ 27
def DC000_3_pim : Polynomial ℚ := C (-424) + C (-848) * X + C (-182) * X ^ 2 + C (-2011) * X ^ 3 + C (-1682) * X ^ 4 + C (-738) * X ^ 5 + C (-4144) * X ^ 6 + C (-1412) * X ^ 7 + C (-2170) * X ^ 8 + C (-6087) * X ^ 9 + C (-1007) * X ^ 10 + C (-3898) * X ^ 11 + C (-5856) * X ^ 12 + C (-576) * X ^ 13 + C (-4879) * X ^ 14 + C (-4152) * X ^ 15 + C (-510) * X ^ 16 + C (-4758) * X ^ 17 + C (-2405) * X ^ 18 + C (-650) * X ^ 19 + C (-3023) * X ^ 20 + C (-919) * X ^ 21 + C (-778) * X ^ 22 + C (-1570) * X ^ 23 + C (-332) * X ^ 24 + C (-490) * X ^ 25 + C (-549) * X ^ 26 + C (-50) * X ^ 27
theorem DC000_3_ab_pre_eq :
    N_re_0_0 * N_re_1_2 - N_im_0_0 * N_im_1_2 =
      DC000_3_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_2, N_im_1_2, DC000_3_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_3_ab_pim_eq :
    N_re_0_0 * N_im_1_2 + N_im_0_0 * N_re_1_2 =
      DC000_3_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_2, N_im_1_2, DC000_3_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_3_ab_mul :
    N_entry_0_0 * N_entry_1_2 =
      ofLadj DC000_3_ab_pre DC000_3_ab_pim := by
  rw [N_entry_0_0, N_entry_1_2, ofLadj_mul,
    DC000_3_ab_pre_eq, DC000_3_ab_pim_eq]

theorem DC000_3_pre_eq :
    DC000_3_ab_pre * N_re_2_1 - DC000_3_ab_pim * N_im_2_1 =
      DC000_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_3_ab_pre, DC000_3_ab_pim, N_re_2_1, N_im_2_1, DC000_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_3_pim_eq :
    DC000_3_ab_pre * N_im_2_1 + DC000_3_ab_pim * N_re_2_1 =
      DC000_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_3_ab_pre, DC000_3_ab_pim, N_re_2_1, N_im_2_1, DC000_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_3_mul :
    N_entry_0_0 * N_entry_1_2 * N_entry_2_1 =
      ofLadj DC000_3_pre DC000_3_pim := by
  rw [DC000_3_ab_mul, N_entry_2_1, ofLadj_mul, DC000_3_pre_eq, DC000_3_pim_eq]

def DC000_3_spre : Polynomial ℚ := C (412) + C (-312) * X + C (578) * X ^ 2 + C (1113) * X ^ 3 + C (-322) * X ^ 4 + C (2028) * X ^ 5 + C (1772) * X ^ 6 + C (-304) * X ^ 7 + C (4060) * X ^ 8 + C (867) * X ^ 9 + C (-153) * X ^ 10 + C (4608) * X ^ 11 + C (-884) * X ^ 12 + C (588) * X ^ 13 + C (3253) * X ^ 14 + C (-2396) * X ^ 15 + C (892) * X ^ 16 + C (838) * X ^ 17 + C (-2801) * X ^ 18 + C (218) * X ^ 19 + C (-631) * X ^ 20 + C (-1875) * X ^ 21 + C (-92) * X ^ 22 + C (-832) * X ^ 23 + C (-930) * X ^ 24 + C (-88) * X ^ 25 + C (-387) * X ^ 26 + C (-310) * X ^ 27
def DC000_3_spim : Polynomial ℚ := C (424) + C (848) * X + C (182) * X ^ 2 + C (2011) * X ^ 3 + C (1682) * X ^ 4 + C (738) * X ^ 5 + C (4144) * X ^ 6 + C (1412) * X ^ 7 + C (2170) * X ^ 8 + C (6087) * X ^ 9 + C (1007) * X ^ 10 + C (3898) * X ^ 11 + C (5856) * X ^ 12 + C (576) * X ^ 13 + C (4879) * X ^ 14 + C (4152) * X ^ 15 + C (510) * X ^ 16 + C (4758) * X ^ 17 + C (2405) * X ^ 18 + C (650) * X ^ 19 + C (3023) * X ^ 20 + C (919) * X ^ 21 + C (778) * X ^ 22 + C (1570) * X ^ 23 + C (332) * X ^ 24 + C (490) * X ^ 25 + C (549) * X ^ 26 + C (50) * X ^ 27
theorem DC000_3_spre_eq : -DC000_3_pre = DC000_3_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_3_pre, DC000_3_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC000_3_spim_eq : -DC000_3_pim = DC000_3_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_3_pim, DC000_3_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC000_3_smul :
    -(N_entry_0_0 * N_entry_1_2 * N_entry_2_1) =
      ofLadj DC000_3_spre DC000_3_spim := by
  rw [DC000_3_mul, ofLadj_neg, DC000_3_spre_eq, DC000_3_spim_eq]

def DC000_4_ab_pre : Polynomial ℚ := C (-3) + C (32) * X + C (38) * X ^ 2 + C (21) * X ^ 3 + C (88) * X ^ 4 + C (25) * X ^ 5 + C (34) * X ^ 6 + C (80) * X ^ 7 + C (-23) * X ^ 8 + C (17) * X ^ 9 + C (57) * X ^ 10 + C (-64) * X ^ 11 + C (25) * X ^ 12 + C (-21) * X ^ 13 + C (-44) * X ^ 14 + C (7) * X ^ 15 + C (-11) * X ^ 16 + C (-20) * X ^ 17 + C (15) * X ^ 18
def DC000_4_ab_pim : Polynomial ℚ := C (-19) + C (-38) * X + C (-15) * X ^ 2 + C (-84) * X ^ 3 + C (-90) * X ^ 4 + C (-79) * X ^ 5 + C (-182) * X ^ 6 + C (-139) * X ^ 7 + C (-143) * X ^ 8 + C (-230) * X ^ 9 + C (-115) * X ^ 10 + C (-134) * X ^ 11 + C (-153) * X ^ 12 + C (-61) * X ^ 13 + C (-79) * X ^ 14 + C (-74) * X ^ 15 + C (-4) * X ^ 16 + C (-41) * X ^ 17 + C (-3) * X ^ 18
def DC000_4_pre : Polynomial ℚ := C (24) + C (580) * X + C (641) * X ^ 2 + C (709) * X ^ 3 + C (2504) * X ^ 4 + C (1582) * X ^ 5 + C (2653) * X ^ 6 + C (4995) * X ^ 7 + C (2380) * X ^ 8 + C (5391) * X ^ 9 + C (6833) * X ^ 10 + C (2637) * X ^ 11 + C (7537) * X ^ 12 + C (5532) * X ^ 13 + C (2555) * X ^ 14 + C (7096) * X ^ 15 + C (2980) * X ^ 16 + C (1993) * X ^ 17 + C (5003) * X ^ 18 + C (690) * X ^ 19 + C (1445) * X ^ 20 + C (2128) * X ^ 21 + C (-229) * X ^ 22 + C (844) * X ^ 23 + C (663) * X ^ 24 + C (-194) * X ^ 25 + C (398) * X ^ 26 + C (84) * X ^ 27
def DC000_4_pim : Polynomial ℚ := C (-218) + C (-340) * X + C (71) * X ^ 2 + C (-1057) * X ^ 3 + C (-958) * X ^ 4 + C (-568) * X ^ 5 + C (-3347) * X ^ 6 + C (-2021) * X ^ 7 + C (-2858) * X ^ 8 + C (-6653) * X ^ 9 + C (-3015) * X ^ 10 + C (-5887) * X ^ 11 + C (-8325) * X ^ 12 + C (-3724) * X ^ 13 + C (-8207) * X ^ 14 + C (-7538) * X ^ 15 + C (-3624) * X ^ 16 + C (-7881) * X ^ 17 + C (-4441) * X ^ 18 + C (-2688) * X ^ 19 + C (-4779) * X ^ 20 + C (-1676) * X ^ 21 + C (-1551) * X ^ 22 + C (-1956) * X ^ 23 + C (-227) * X ^ 24 + C (-502) * X ^ 25 + C (-354) * X ^ 26 + C (108) * X ^ 27
theorem DC000_4_ab_pre_eq :
    N_re_0_1 * N_re_1_0 - N_im_0_1 * N_im_1_0 =
      DC000_4_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_0, N_im_1_0, DC000_4_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_4_ab_pim_eq :
    N_re_0_1 * N_im_1_0 + N_im_0_1 * N_re_1_0 =
      DC000_4_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_0, N_im_1_0, DC000_4_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_4_ab_mul :
    N_entry_0_1 * N_entry_1_0 =
      ofLadj DC000_4_ab_pre DC000_4_ab_pim := by
  rw [N_entry_0_1, N_entry_1_0, ofLadj_mul,
    DC000_4_ab_pre_eq, DC000_4_ab_pim_eq]

theorem DC000_4_pre_eq :
    DC000_4_ab_pre * N_re_2_2 - DC000_4_ab_pim * N_im_2_2 =
      DC000_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_4_ab_pre, DC000_4_ab_pim, N_re_2_2, N_im_2_2, DC000_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_4_pim_eq :
    DC000_4_ab_pre * N_im_2_2 + DC000_4_ab_pim * N_re_2_2 =
      DC000_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_4_ab_pre, DC000_4_ab_pim, N_re_2_2, N_im_2_2, DC000_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_4_mul :
    N_entry_0_1 * N_entry_1_0 * N_entry_2_2 =
      ofLadj DC000_4_pre DC000_4_pim := by
  rw [DC000_4_ab_mul, N_entry_2_2, ofLadj_mul, DC000_4_pre_eq, DC000_4_pim_eq]

def DC000_4_spre : Polynomial ℚ := C (-24) + C (-580) * X + C (-641) * X ^ 2 + C (-709) * X ^ 3 + C (-2504) * X ^ 4 + C (-1582) * X ^ 5 + C (-2653) * X ^ 6 + C (-4995) * X ^ 7 + C (-2380) * X ^ 8 + C (-5391) * X ^ 9 + C (-6833) * X ^ 10 + C (-2637) * X ^ 11 + C (-7537) * X ^ 12 + C (-5532) * X ^ 13 + C (-2555) * X ^ 14 + C (-7096) * X ^ 15 + C (-2980) * X ^ 16 + C (-1993) * X ^ 17 + C (-5003) * X ^ 18 + C (-690) * X ^ 19 + C (-1445) * X ^ 20 + C (-2128) * X ^ 21 + C (229) * X ^ 22 + C (-844) * X ^ 23 + C (-663) * X ^ 24 + C (194) * X ^ 25 + C (-398) * X ^ 26 + C (-84) * X ^ 27
def DC000_4_spim : Polynomial ℚ := C (218) + C (340) * X + C (-71) * X ^ 2 + C (1057) * X ^ 3 + C (958) * X ^ 4 + C (568) * X ^ 5 + C (3347) * X ^ 6 + C (2021) * X ^ 7 + C (2858) * X ^ 8 + C (6653) * X ^ 9 + C (3015) * X ^ 10 + C (5887) * X ^ 11 + C (8325) * X ^ 12 + C (3724) * X ^ 13 + C (8207) * X ^ 14 + C (7538) * X ^ 15 + C (3624) * X ^ 16 + C (7881) * X ^ 17 + C (4441) * X ^ 18 + C (2688) * X ^ 19 + C (4779) * X ^ 20 + C (1676) * X ^ 21 + C (1551) * X ^ 22 + C (1956) * X ^ 23 + C (227) * X ^ 24 + C (502) * X ^ 25 + C (354) * X ^ 26 + C (-108) * X ^ 27
theorem DC000_4_spre_eq : -DC000_4_pre = DC000_4_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_4_pre, DC000_4_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC000_4_spim_eq : -DC000_4_pim = DC000_4_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_4_pim, DC000_4_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC000_4_smul :
    -(N_entry_0_1 * N_entry_1_0 * N_entry_2_2) =
      ofLadj DC000_4_spre DC000_4_spim := by
  rw [DC000_4_mul, ofLadj_neg, DC000_4_spre_eq, DC000_4_spim_eq]

def DC000_5_ab_pre : Polynomial ℚ := C (-54) + C (48) * X + C (1) * X ^ 2 + C ((-187 / 2 : ℚ)) * X ^ 3 + C ((309 / 2 : ℚ)) * X ^ 4 + C (-50) * X ^ 5 + C (-19) * X ^ 6 + C ((531 / 2 : ℚ)) * X ^ 7 + C ((-235 / 2 : ℚ)) * X ^ 8 + C (130) * X ^ 9 + C (239) * X ^ 10 + C (-116) * X ^ 11 + C (191) * X ^ 12 + C (129) * X ^ 13 + C (-24) * X ^ 14 + C (199) * X ^ 15 + C (61) * X ^ 16 + C (30) * X ^ 17 + C (88) * X ^ 18
def DC000_5_ab_pim : Polynomial ℚ := C (-57) + C (-114) * X + C (25) * X ^ 2 + C ((-279 / 2 : ℚ)) * X ^ 3 + C ((-191 / 2 : ℚ)) * X ^ 4 + C (49) * X ^ 5 + C (-272) * X ^ 6 + C ((-135 / 2 : ℚ)) * X ^ 7 + C ((-69 / 2 : ℚ)) * X ^ 8 + C (-428) * X ^ 9 + C (23) * X ^ 10 + C (-100) * X ^ 11 + C (-223) * X ^ 12 + C (89) * X ^ 13 + C (-140) * X ^ 14 + C (-111) * X ^ 15 + C (23) * X ^ 16 + C (-114) * X ^ 17 + C (-40) * X ^ 18
def DC000_5_pre : Polynomial ℚ := C (114) + C (456) * X + C (406) * X ^ 2 + C (215) * X ^ 3 + C (1379) * X ^ 4 + C ((741 / 2 : ℚ)) * X ^ 5 + C ((3235 / 4 : ℚ)) * X ^ 6 + C ((10947 / 4 : ℚ)) * X ^ 7 + C ((813 / 4 : ℚ)) * X ^ 8 + C (2748) * X ^ 9 + C ((8511 / 2 : ℚ)) * X ^ 10 + C (-97) * X ^ 11 + C ((9857 / 2 : ℚ)) * X ^ 12 + C ((6627 / 2 : ℚ)) * X ^ 13 + C ((2013 / 4 : ℚ)) * X ^ 14 + C ((23931 / 4 : ℚ)) * X ^ 15 + C ((7627 / 4 : ℚ)) * X ^ 16 + C ((3257 / 2 : ℚ)) * X ^ 17 + C (5341) * X ^ 18 + C (604) * X ^ 19 + C (2043) * X ^ 20 + C ((5587 / 2 : ℚ)) * X ^ 21 + C ((297 / 2 : ℚ)) * X ^ 22 + C ((3329 / 2 : ℚ)) * X ^ 23 + C ((2143 / 2 : ℚ)) * X ^ 24 + C (89) * X ^ 25 + C (716) * X ^ 26 + C (160) * X ^ 27
def DC000_5_pim : Polynomial ℚ := C (-108) + C (-120) * X + C (194) * X ^ 2 + C ((-975 / 2 : ℚ)) * X ^ 3 + C (-257) * X ^ 4 + C (543) * X ^ 5 + C ((-5319 / 4 : ℚ)) * X ^ 6 + C ((1827 / 4 : ℚ)) * X ^ 7 + C ((2985 / 4 : ℚ)) * X ^ 8 + C ((-4075 / 2 : ℚ)) * X ^ 9 + C ((4321 / 2 : ℚ)) * X ^ 10 + C ((309 / 2 : ℚ)) * X ^ 11 + C ((-3851 / 2 : ℚ)) * X ^ 12 + C (3450) * X ^ 13 + C ((-4427 / 4 : ℚ)) * X ^ 14 + C ((-1075 / 4 : ℚ)) * X ^ 15 + C ((14929 / 4 : ℚ)) * X ^ 16 + C ((-3123 / 2 : ℚ)) * X ^ 17 + C (1697) * X ^ 18 + C (2379) * X ^ 19 + C (-1035) * X ^ 20 + C ((3691 / 2 : ℚ)) * X ^ 21 + C ((1643 / 2 : ℚ)) * X ^ 22 + C ((-449 / 2 : ℚ)) * X ^ 23 + C ((2329 / 2 : ℚ)) * X ^ 24 + C (205) * X ^ 25 + C (108) * X ^ 26 + C (352) * X ^ 27
theorem DC000_5_ab_pre_eq :
    N_re_0_2 * N_re_1_1 - N_im_0_2 * N_im_1_1 =
      DC000_5_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_1, N_im_1_1, DC000_5_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_5_ab_pim_eq :
    N_re_0_2 * N_im_1_1 + N_im_0_2 * N_re_1_1 =
      DC000_5_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_1, N_im_1_1, DC000_5_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_5_ab_mul :
    N_entry_0_2 * N_entry_1_1 =
      ofLadj DC000_5_ab_pre DC000_5_ab_pim := by
  rw [N_entry_0_2, N_entry_1_1, ofLadj_mul,
    DC000_5_ab_pre_eq, DC000_5_ab_pim_eq]

theorem DC000_5_pre_eq :
    DC000_5_ab_pre * N_re_2_0 - DC000_5_ab_pim * N_im_2_0 =
      DC000_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_5_ab_pre, DC000_5_ab_pim, N_re_2_0, N_im_2_0, DC000_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_5_pim_eq :
    DC000_5_ab_pre * N_im_2_0 + DC000_5_ab_pim * N_re_2_0 =
      DC000_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_5_ab_pre, DC000_5_ab_pim, N_re_2_0, N_im_2_0, DC000_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind

theorem DC000_5_mul :
    N_entry_0_2 * N_entry_1_1 * N_entry_2_0 =
      ofLadj DC000_5_pre DC000_5_pim := by
  rw [DC000_5_ab_mul, N_entry_2_0, ofLadj_mul, DC000_5_pre_eq, DC000_5_pim_eq]

def DC000_5_spre : Polynomial ℚ := C (-114) + C (-456) * X + C (-406) * X ^ 2 + C (-215) * X ^ 3 + C (-1379) * X ^ 4 + C ((-741 / 2 : ℚ)) * X ^ 5 + C ((-3235 / 4 : ℚ)) * X ^ 6 + C ((-10947 / 4 : ℚ)) * X ^ 7 + C ((-813 / 4 : ℚ)) * X ^ 8 + C (-2748) * X ^ 9 + C ((-8511 / 2 : ℚ)) * X ^ 10 + C (97) * X ^ 11 + C ((-9857 / 2 : ℚ)) * X ^ 12 + C ((-6627 / 2 : ℚ)) * X ^ 13 + C ((-2013 / 4 : ℚ)) * X ^ 14 + C ((-23931 / 4 : ℚ)) * X ^ 15 + C ((-7627 / 4 : ℚ)) * X ^ 16 + C ((-3257 / 2 : ℚ)) * X ^ 17 + C (-5341) * X ^ 18 + C (-604) * X ^ 19 + C (-2043) * X ^ 20 + C ((-5587 / 2 : ℚ)) * X ^ 21 + C ((-297 / 2 : ℚ)) * X ^ 22 + C ((-3329 / 2 : ℚ)) * X ^ 23 + C ((-2143 / 2 : ℚ)) * X ^ 24 + C (-89) * X ^ 25 + C (-716) * X ^ 26 + C (-160) * X ^ 27
def DC000_5_spim : Polynomial ℚ := C (108) + C (120) * X + C (-194) * X ^ 2 + C ((975 / 2 : ℚ)) * X ^ 3 + C (257) * X ^ 4 + C (-543) * X ^ 5 + C ((5319 / 4 : ℚ)) * X ^ 6 + C ((-1827 / 4 : ℚ)) * X ^ 7 + C ((-2985 / 4 : ℚ)) * X ^ 8 + C ((4075 / 2 : ℚ)) * X ^ 9 + C ((-4321 / 2 : ℚ)) * X ^ 10 + C ((-309 / 2 : ℚ)) * X ^ 11 + C ((3851 / 2 : ℚ)) * X ^ 12 + C (-3450) * X ^ 13 + C ((4427 / 4 : ℚ)) * X ^ 14 + C ((1075 / 4 : ℚ)) * X ^ 15 + C ((-14929 / 4 : ℚ)) * X ^ 16 + C ((3123 / 2 : ℚ)) * X ^ 17 + C (-1697) * X ^ 18 + C (-2379) * X ^ 19 + C (1035) * X ^ 20 + C ((-3691 / 2 : ℚ)) * X ^ 21 + C ((-1643 / 2 : ℚ)) * X ^ 22 + C ((449 / 2 : ℚ)) * X ^ 23 + C ((-2329 / 2 : ℚ)) * X ^ 24 + C (-205) * X ^ 25 + C (-108) * X ^ 26 + C (-352) * X ^ 27
theorem DC000_5_spre_eq : -DC000_5_pre = DC000_5_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_5_pre, DC000_5_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC000_5_spim_eq : -DC000_5_pim = DC000_5_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC000_5_pim, DC000_5_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try grind
theorem DC000_5_smul :
    -(N_entry_0_2 * N_entry_1_1 * N_entry_2_0) =
      ofLadj DC000_5_spre DC000_5_spim := by
  rw [DC000_5_mul, ofLadj_neg, DC000_5_spre_eq, DC000_5_spim_eq]

@[expose] public def detCoeff_000 : Ki :=
  N_entry_0_0 * N_entry_1_1 * N_entry_2_2 + N_entry_0_1 * N_entry_1_2 * N_entry_2_0 + N_entry_0_2 * N_entry_1_0 * N_entry_2_1 + (-(N_entry_0_0 * N_entry_1_2 * N_entry_2_1)) + (-(N_entry_0_1 * N_entry_1_0 * N_entry_2_2)) + (-(N_entry_0_2 * N_entry_1_1 * N_entry_2_0))

theorem detCoeff_000_sum :
    detCoeff_000 = ofLadj (DC000_0_pre + DC000_1_pre + DC000_2_pre + DC000_3_spre + DC000_4_spre + DC000_5_spre) (DC000_0_pim + DC000_1_pim + DC000_2_pim + DC000_3_spim + DC000_4_spim + DC000_5_spim) := by
  simp only [detCoeff_000, DC000_0_mul, DC000_1_mul, DC000_2_mul, DC000_3_smul, DC000_4_smul, DC000_5_smul]
  simpa [add_assoc] using ofLadj_add6 DC000_0_pre DC000_0_pim DC000_1_pre DC000_1_pim DC000_2_pre DC000_2_pim DC000_3_spre DC000_3_spim DC000_4_spre DC000_4_spim DC000_5_spre DC000_5_spim

def DC000_qre : Polynomial ℚ := C ((-65 / 2 : ℚ)) + C ((-23 / 2 : ℚ)) * X + C ((255 / 2 : ℚ)) * X ^ 2 + C ((581 / 4 : ℚ)) * X ^ 3 + C (266) * X ^ 4 + C ((777 / 2 : ℚ)) * X ^ 5 + C ((1995 / 4 : ℚ)) * X ^ 6 + C (559) * X ^ 7 + C ((1059 / 2 : ℚ)) * X ^ 8 + C ((1037 / 2 : ℚ)) * X ^ 9 + C ((967 / 2 : ℚ)) * X ^ 10 + C ((1015 / 2 : ℚ)) * X ^ 11 + C (507) * X ^ 12 + C (359) * X ^ 13 + C ((739 / 2 : ℚ)) * X ^ 14 + C ((433 / 2 : ℚ)) * X ^ 15 + C (147) * X ^ 16 + C (50) * X ^ 17
def DC000_qim : Polynomial ℚ := C (140) + C (218) * X + C (310) * X ^ 2 + C ((1863 / 4 : ℚ)) * X ^ 3 + C ((859 / 2 : ℚ)) * X ^ 4 + C ((1039 / 2 : ℚ)) * X ^ 5 + C ((1405 / 4 : ℚ)) * X ^ 6 + C (361) * X ^ 7 + C ((639 / 2 : ℚ)) * X ^ 8 + C ((669 / 2 : ℚ)) * X ^ 9 + C ((597 / 2 : ℚ)) * X ^ 10 + C ((343 / 2 : ℚ)) * X ^ 11 + C (123) * X ^ 12 + C (42) * X ^ 13 + C ((-151 / 2 : ℚ)) * X ^ 14 + C ((-119 / 2 : ℚ)) * X ^ 15 + C (-138) * X ^ 16 + C (-38) * X ^ 17

theorem detCoeff_000_sum_poly_re :
    DC000_0_pre + DC000_1_pre + DC000_2_pre + DC000_3_spre + DC000_4_spre + DC000_5_spre = Fplus_re_000 + Phi11 * DC000_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC000_0_pre, DC000_1_pre, DC000_2_pre, DC000_3_spre, DC000_4_spre, DC000_5_spre, Fplus_re_000, DC000_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind

theorem detCoeff_000_sum_poly_im :
    DC000_0_pim + DC000_1_pim + DC000_2_pim + DC000_3_spim + DC000_4_spim + DC000_5_spim = Fplus_im_000 + Phi11 * DC000_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC000_0_pim, DC000_1_pim, DC000_2_pim, DC000_3_spim, DC000_4_spim, DC000_5_spim, Fplus_im_000, DC000_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try grind

public theorem detCoeff_000_eq :
    detCoeff_000 = ofLadj Fplus_re_000 Fplus_im_000 := by
  rw [detCoeff_000_sum, detCoeff_000_sum_poly_re,
    detCoeff_000_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
