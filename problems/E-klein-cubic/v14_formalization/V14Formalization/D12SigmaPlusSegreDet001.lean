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

def DC001_0_ab_pre : Polynomial ℚ := C (-44) + C (-50) * X ^ 2 + C (-61) * X ^ 3 + C (2) * X ^ 4 + C (-54) * X ^ 5 + C (-44) * X ^ 6 + C (28) * X ^ 7 + C (-85) * X ^ 8 + C (-41) * X ^ 9 + C (2) * X ^ 10 + C (-86) * X ^ 11 + C (2) * X ^ 12 + C (9) * X ^ 13 + C (-24) * X ^ 14 + C (38) * X ^ 15 + C (8) * X ^ 16 + C (-2) * X ^ 17 + C (12) * X ^ 18
def DC001_0_ab_pim : Polynomial ℚ := C (-16) + C (-32) * X + C (26) * X ^ 2 + C (-27) * X ^ 3 + C (-14) * X ^ 4 + C (44) * X ^ 5 + C (-77) * X ^ 6 + C (5) * X ^ 7 + C (-27) * X ^ 8 + C (-121) * X ^ 9 + C (1) * X ^ 10 + C (-24) * X ^ 11 + C (-49) * X ^ 12 + C (15) * X ^ 13 + C (-26) * X ^ 14 + C (-39) * X ^ 15 + C (-9) * X ^ 16 + C (-38) * X ^ 17 + C (-32) * X ^ 18
def DC001_0_pre : Polynomial ℚ := C (776) + C (-768) * X + C (1028) * X ^ 2 + C (2354) * X ^ 3 + C (-1584) * X ^ 4 + C (3822) * X ^ 5 + C (2538) * X ^ 6 + C (-3232) * X ^ 7 + C (7294) * X ^ 8 + C (-1286) * X ^ 9 + C (-3614) * X ^ 10 + C (8746) * X ^ 11 + C (-5254) * X ^ 12 + C (-1244) * X ^ 13 + C (6102) * X ^ 14 + C (-8786) * X ^ 15 + C (422) * X ^ 16 + C (778) * X ^ 17 + C (-8502) * X ^ 18 + C (548) * X ^ 19 + C (-1756) * X ^ 20 + C (-5016) * X ^ 21 + C (-206) * X ^ 22 + C (-2608) * X ^ 23 + C (-2826) * X ^ 24 + C (-614) * X ^ 25 + C (-1364) * X ^ 26 + C (-928) * X ^ 27
def DC001_0_pim : Polynomial ℚ := C (880) + C (1760) * X + C (68) * X ^ 2 + C (4014) * X ^ 3 + C (2784) * X ^ 4 + C (314) * X ^ 5 + C (8272) * X ^ 6 + C (1682) * X ^ 7 + C (3112) * X ^ 8 + C (13506) * X ^ 9 + C (386) * X ^ 10 + C (8012) * X ^ 11 + C (12910) * X ^ 12 + C (-1280) * X ^ 13 + C (10682) * X ^ 14 + C (8448) * X ^ 15 + C (-1012) * X ^ 16 + C (10642) * X ^ 17 + C (4234) * X ^ 18 + C (-132) * X ^ 19 + C (6224) * X ^ 20 + C (358) * X ^ 21 + C (188) * X ^ 22 + C (2746) * X ^ 23 + C (-358) * X ^ 24 + C (484) * X ^ 25 + C (1012) * X ^ 26 + C (-56) * X ^ 27
theorem DC001_0_ab_pre_eq :
    N_re_0_0 * N_re_1_1 - N_im_0_0 * N_im_1_1 =
      DC001_0_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_1, N_im_1_1, DC001_0_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_0_ab_pim_eq :
    N_re_0_0 * N_im_1_1 + N_im_0_0 * N_re_1_1 =
      DC001_0_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_1, N_im_1_1, DC001_0_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_0_ab_mul :
    N_entry_0_0 * N_entry_1_1 =
      ofLadj DC001_0_ab_pre DC001_0_ab_pim := by
  rw [N_entry_0_0, N_entry_1_1, ofLadj_mul,
    DC001_0_ab_pre_eq, DC001_0_ab_pim_eq]

theorem DC001_0_pre_eq :
    DC001_0_ab_pre * N_re_2_5 - DC001_0_ab_pim * N_im_2_5 =
      DC001_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_0_ab_pre, DC001_0_ab_pim, N_re_2_5, N_im_2_5, DC001_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_0_pim_eq :
    DC001_0_ab_pre * N_im_2_5 + DC001_0_ab_pim * N_re_2_5 =
      DC001_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_0_ab_pre, DC001_0_ab_pim, N_re_2_5, N_im_2_5, DC001_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_0_mul :
    N_entry_0_0 * N_entry_1_1 * N_entry_2_5 =
      ofLadj DC001_0_pre DC001_0_pim := by
  rw [DC001_0_ab_mul, N_entry_2_5, ofLadj_mul, DC001_0_pre_eq, DC001_0_pim_eq]

def DC001_1_ab_pre : Polynomial ℚ := C (-31) + C (96) * X + C (59) * X ^ 2 + C (-18) * X ^ 3 + C (231) * X ^ 4 + C (5) * X ^ 5 + C (21) * X ^ 6 + C (257) * X ^ 7 + C (-143) * X ^ 8 + C (102) * X ^ 9 + C (212) * X ^ 10 + C (-166) * X ^ 11 + C (116) * X ^ 12 + C (43) * X ^ 13 + C (-125) * X ^ 14 + C (92) * X ^ 15 + C (-21) * X ^ 16 + C (-37) * X ^ 17 + C (66) * X ^ 18
def DC001_1_ab_pim : Polynomial ℚ := C (-73) + C (-146) * X + C (-49) * X ^ 2 + C (-278) * X ^ 3 + C (-277) * X ^ 4 + C (-185) * X ^ 5 + C (-537) * X ^ 6 + C (-349) * X ^ 7 + C (-337) * X ^ 8 + C (-728) * X ^ 9 + C (-280) * X ^ 10 + C (-386) * X ^ 11 + C (-492) * X ^ 12 + C (-141) * X ^ 13 + C (-303) * X ^ 14 + C (-232) * X ^ 15 + C (-45) * X ^ 16 + C (-151) * X ^ 17 + C (-60) * X ^ 18
def DC001_1_pre : Polynomial ℚ := C (36) + C (-12286) * X + C (-10111) * X ^ 2 + C (-9534) * X ^ 3 + C (-46474) * X ^ 4 + C (-21737) * X ^ 5 + C (-40439) * X ^ 6 + C (-92439) * X ^ 7 + C (-28206) * X ^ 8 + C (-98571) * X ^ 9 + C (-130436) * X ^ 10 + C (-36728) * X ^ 11 + C (-151742) * X ^ 12 + C (-116005) * X ^ 13 + C (-47777) * X ^ 14 + C (-164648) * X ^ 15 + C (-71500) * X ^ 16 + C (-57343) * X ^ 17 + C (-130224) * X ^ 18 + C (-30736) * X ^ 19 + C (-49724) * X ^ 20 + C (-64290) * X ^ 21 + C (-7716) * X ^ 22 + C (-30698) * X ^ 23 + C (-22179) * X ^ 24 + C (-1631) * X ^ 25 + C (-11541) * X ^ 26 + C (-4545) * X ^ 27
def DC001_1_pim : Polynomial ℚ := C (4853) + C (7450) * X + C (-2147) * X ^ 2 + C (21693) * X ^ 3 + C (16160) * X ^ 4 + C (2129) * X ^ 5 + C (58953) * X ^ 6 + C (20232) * X ^ 7 + C (28106) * X ^ 8 + C (108480) * X ^ 9 + C (12391) * X ^ 10 + C (71170) * X ^ 11 + C (121499) * X ^ 12 + C (6644) * X ^ 13 + C (112634) * X ^ 14 + C (95485) * X ^ 15 + C (11363) * X ^ 16 + C (117176) * X ^ 17 + C (47791) * X ^ 18 + C (16350) * X ^ 19 + C (75073) * X ^ 20 + C (12493) * X ^ 21 + C (17448) * X ^ 22 + C (33109) * X ^ 23 + C (-1108) * X ^ 24 + C (8159) * X ^ 25 + C (7274) * X ^ 26 + C (-2679) * X ^ 27
theorem DC001_1_ab_pre_eq :
    N_re_0_1 * N_re_1_2 - N_im_0_1 * N_im_1_2 =
      DC001_1_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_2, N_im_1_2, DC001_1_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_1_ab_pim_eq :
    N_re_0_1 * N_im_1_2 + N_im_0_1 * N_re_1_2 =
      DC001_1_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_2, N_im_1_2, DC001_1_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_1_ab_mul :
    N_entry_0_1 * N_entry_1_2 =
      ofLadj DC001_1_ab_pre DC001_1_ab_pim := by
  rw [N_entry_0_1, N_entry_1_2, ofLadj_mul,
    DC001_1_ab_pre_eq, DC001_1_ab_pim_eq]

theorem DC001_1_pre_eq :
    DC001_1_ab_pre * N_re_2_3 - DC001_1_ab_pim * N_im_2_3 =
      DC001_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_1_ab_pre, DC001_1_ab_pim, N_re_2_3, N_im_2_3, DC001_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_1_pim_eq :
    DC001_1_ab_pre * N_im_2_3 + DC001_1_ab_pim * N_re_2_3 =
      DC001_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_1_ab_pre, DC001_1_ab_pim, N_re_2_3, N_im_2_3, DC001_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_1_mul :
    N_entry_0_1 * N_entry_1_2 * N_entry_2_3 =
      ofLadj DC001_1_pre DC001_1_pim := by
  rw [DC001_1_ab_mul, N_entry_2_3, ofLadj_mul, DC001_1_pre_eq, DC001_1_pim_eq]

def DC001_2_ab_pre : Polynomial ℚ := C (-3) + C (12) * X + C (13) * X ^ 2 + C (-1) * X ^ 3 + C (27) * X ^ 4 + C (-3) * X ^ 5 + C (5) * X ^ 6 + C (35) * X ^ 7 + C (-1) * X ^ 8 + C (29) * X ^ 9 + C (56) * X ^ 10 + C (4) * X ^ 11 + C (44) * X ^ 12 + C (16) * X ^ 13 + C (16) * X ^ 15 + C (2) * X ^ 16 + C (-6) * X ^ 17 + C (8) * X ^ 18
def DC001_2_ab_pim : Polynomial ℚ := C (-9) + C (-18) * X + C (-4) * X ^ 2 + C (-32) * X ^ 3 + C (-27) * X ^ 4 + C (-12) * X ^ 5 + C (-50) * X ^ 6 + C (-23) * X ^ 7 + C (-18) * X ^ 8 + C (-60) * X ^ 9 + C (-14) * X ^ 10 + C (-34) * X ^ 11 + C (-54) * X ^ 12 + C (-22) * X ^ 13 + C (-36) * X ^ 14 + C (-36) * X ^ 15 + C (-4) * X ^ 16 + C (-20) * X ^ 17
def DC001_2_pre : Polynomial ℚ := C (-42) + C (-696) * X + C (-727) * X ^ 2 + C (-623) * X ^ 3 + C (-2540) * X ^ 4 + C (-1188) * X ^ 5 + C (-2111) * X ^ 6 + C (-4744) * X ^ 7 + C (-1500) * X ^ 8 + C (-4989) * X ^ 9 + C (-6901) * X ^ 10 + C (-2150) * X ^ 11 + C (-8349) * X ^ 12 + C (-6490) * X ^ 13 + C (-3353) * X ^ 14 + C (-9355) * X ^ 15 + C (-4829) * X ^ 16 + C (-3962) * X ^ 17 + C (-7797) * X ^ 18 + C (-2508) * X ^ 19 + C (-3652) * X ^ 20 + C (-4094) * X ^ 21 + C (-1028) * X ^ 22 + C (-1950) * X ^ 23 + C (-1424) * X ^ 24 + C (-32) * X ^ 25 + C (-646) * X ^ 26 + C (-56) * X ^ 27
def DC001_2_pim : Polynomial ℚ := C (234) + C (324) * X + C (-299) * X ^ 2 + C (803) * X ^ 3 + C (489) * X ^ 4 + C (-440) * X ^ 5 + C (2323) * X ^ 6 + C (-30) * X ^ 7 + C (-48) * X ^ 8 + C (3480) * X ^ 9 + C (-1813) * X ^ 10 + C (636) * X ^ 11 + C (3101) * X ^ 12 + C (-2831) * X ^ 13 + C (2611) * X ^ 14 + C (1775) * X ^ 15 + C (-2375) * X ^ 16 + C (3228) * X ^ 17 + C (30) * X ^ 18 + C (-1194) * X ^ 19 + C (2510) * X ^ 20 + C (-456) * X ^ 21 + C (394) * X ^ 22 + C (1372) * X ^ 23 + C (-332) * X ^ 24 + C (356) * X ^ 25 + C (264) * X ^ 26 + C (-208) * X ^ 27
theorem DC001_2_ab_pre_eq :
    N_re_0_2 * N_re_1_0 - N_im_0_2 * N_im_1_0 =
      DC001_2_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_0, N_im_1_0, DC001_2_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_2_ab_pim_eq :
    N_re_0_2 * N_im_1_0 + N_im_0_2 * N_re_1_0 =
      DC001_2_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_0, N_im_1_0, DC001_2_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_2_ab_mul :
    N_entry_0_2 * N_entry_1_0 =
      ofLadj DC001_2_ab_pre DC001_2_ab_pim := by
  rw [N_entry_0_2, N_entry_1_0, ofLadj_mul,
    DC001_2_ab_pre_eq, DC001_2_ab_pim_eq]

theorem DC001_2_pre_eq :
    DC001_2_ab_pre * N_re_2_4 - DC001_2_ab_pim * N_im_2_4 =
      DC001_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_2_ab_pre, DC001_2_ab_pim, N_re_2_4, N_im_2_4, DC001_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_2_pim_eq :
    DC001_2_ab_pre * N_im_2_4 + DC001_2_ab_pim * N_re_2_4 =
      DC001_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_2_ab_pre, DC001_2_ab_pim, N_re_2_4, N_im_2_4, DC001_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_2_mul :
    N_entry_0_2 * N_entry_1_0 * N_entry_2_4 =
      ofLadj DC001_2_pre DC001_2_pim := by
  rw [DC001_2_ab_mul, N_entry_2_4, ofLadj_mul, DC001_2_pre_eq, DC001_2_pim_eq]

def DC001_3_ab_pre : Polynomial ℚ := C (-20) + C (-28) * X ^ 2 + C (-40) * X ^ 3 + C (-18) * X ^ 4 + C (-50) * X ^ 5 + C (-48) * X ^ 6 + C (-12) * X ^ 7 + C (-56) * X ^ 8 + C (-24) * X ^ 9 + C (4) * X ^ 10 + C (-34) * X ^ 11 + C (4) * X ^ 12 + C (4) * X ^ 13 + C (-16) * X ^ 14 + C (10) * X ^ 15 + C (-4) * X ^ 16 + C (-6) * X ^ 17 + C (4) * X ^ 18
def DC001_3_ab_pim : Polynomial ℚ := C (-12) + C (-24) * X + C (-30) * X ^ 3 + C (-22) * X ^ 4 + C (8) * X ^ 5 + C (-38) * X ^ 6 + C (6) * X ^ 7 + C (-4) * X ^ 8 + C (-50) * X ^ 9 + C (-18) * X ^ 11 + C (-36) * X ^ 12 + C (-10) * X ^ 13 + C (-26) * X ^ 14 + C (-28) * X ^ 15 + C (-10) * X ^ 16 + C (-20) * X ^ 17 + C (-16) * X ^ 18
def DC001_3_pre : Polynomial ℚ := C (296) + C (-576) * X + C (204) * X ^ 2 + C (748) * X ^ 3 + C (-1164) * X ^ 4 + C (1532) * X ^ 5 + C (1094) * X ^ 6 + C (-1308) * X ^ 7 + C (3776) * X ^ 8 + C (-170) * X ^ 9 + C (-1280) * X ^ 10 + C (4342) * X ^ 11 + C (-2168) * X ^ 12 + C (-478) * X ^ 13 + C (2804) * X ^ 14 + C (-4018) * X ^ 15 + C (-20) * X ^ 16 + C (-26) * X ^ 17 + C (-4500) * X ^ 18 + C (-518) * X ^ 19 + C (-1496) * X ^ 20 + C (-2898) * X ^ 21 + C (-546) * X ^ 22 + C (-1434) * X ^ 23 + C (-1392) * X ^ 24 + C (-294) * X ^ 25 + C (-626) * X ^ 26 + C (-444) * X ^ 27
def DC001_3_pim : Polynomial ℚ := C (504) + C (1008) * X + C (380) * X ^ 2 + C (2632) * X ^ 3 + C (2368) * X ^ 4 + C (1618) * X ^ 5 + C (5664) * X ^ 6 + C (2804) * X ^ 7 + C (3592) * X ^ 8 + C (8388) * X ^ 9 + C (2242) * X ^ 10 + C (5668) * X ^ 11 + C (7862) * X ^ 12 + C (1292) * X ^ 13 + C (6490) * X ^ 14 + C (5328) * X ^ 15 + C (776) * X ^ 16 + C (5854) * X ^ 17 + C (2804) * X ^ 18 + C (700) * X ^ 19 + C (3590) * X ^ 20 + C (960) * X ^ 21 + C (788) * X ^ 22 + C (1848) * X ^ 23 + C (270) * X ^ 24 + C (506) * X ^ 25 + C (616) * X ^ 26 + C (8) * X ^ 27
theorem DC001_3_ab_pre_eq :
    N_re_0_0 * N_re_1_2 - N_im_0_0 * N_im_1_2 =
      DC001_3_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_2, N_im_1_2, DC001_3_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_3_ab_pim_eq :
    N_re_0_0 * N_im_1_2 + N_im_0_0 * N_re_1_2 =
      DC001_3_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_2, N_im_1_2, DC001_3_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_3_ab_mul :
    N_entry_0_0 * N_entry_1_2 =
      ofLadj DC001_3_ab_pre DC001_3_ab_pim := by
  rw [N_entry_0_0, N_entry_1_2, ofLadj_mul,
    DC001_3_ab_pre_eq, DC001_3_ab_pim_eq]

theorem DC001_3_pre_eq :
    DC001_3_ab_pre * N_re_2_4 - DC001_3_ab_pim * N_im_2_4 =
      DC001_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_3_ab_pre, DC001_3_ab_pim, N_re_2_4, N_im_2_4, DC001_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_3_pim_eq :
    DC001_3_ab_pre * N_im_2_4 + DC001_3_ab_pim * N_re_2_4 =
      DC001_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_3_ab_pre, DC001_3_ab_pim, N_re_2_4, N_im_2_4, DC001_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_3_mul :
    N_entry_0_0 * N_entry_1_2 * N_entry_2_4 =
      ofLadj DC001_3_pre DC001_3_pim := by
  rw [DC001_3_ab_mul, N_entry_2_4, ofLadj_mul, DC001_3_pre_eq, DC001_3_pim_eq]

def DC001_3_spre : Polynomial ℚ := C (-296) + C (576) * X + C (-204) * X ^ 2 + C (-748) * X ^ 3 + C (1164) * X ^ 4 + C (-1532) * X ^ 5 + C (-1094) * X ^ 6 + C (1308) * X ^ 7 + C (-3776) * X ^ 8 + C (170) * X ^ 9 + C (1280) * X ^ 10 + C (-4342) * X ^ 11 + C (2168) * X ^ 12 + C (478) * X ^ 13 + C (-2804) * X ^ 14 + C (4018) * X ^ 15 + C (20) * X ^ 16 + C (26) * X ^ 17 + C (4500) * X ^ 18 + C (518) * X ^ 19 + C (1496) * X ^ 20 + C (2898) * X ^ 21 + C (546) * X ^ 22 + C (1434) * X ^ 23 + C (1392) * X ^ 24 + C (294) * X ^ 25 + C (626) * X ^ 26 + C (444) * X ^ 27
def DC001_3_spim : Polynomial ℚ := C (-504) + C (-1008) * X + C (-380) * X ^ 2 + C (-2632) * X ^ 3 + C (-2368) * X ^ 4 + C (-1618) * X ^ 5 + C (-5664) * X ^ 6 + C (-2804) * X ^ 7 + C (-3592) * X ^ 8 + C (-8388) * X ^ 9 + C (-2242) * X ^ 10 + C (-5668) * X ^ 11 + C (-7862) * X ^ 12 + C (-1292) * X ^ 13 + C (-6490) * X ^ 14 + C (-5328) * X ^ 15 + C (-776) * X ^ 16 + C (-5854) * X ^ 17 + C (-2804) * X ^ 18 + C (-700) * X ^ 19 + C (-3590) * X ^ 20 + C (-960) * X ^ 21 + C (-788) * X ^ 22 + C (-1848) * X ^ 23 + C (-270) * X ^ 24 + C (-506) * X ^ 25 + C (-616) * X ^ 26 + C (-8) * X ^ 27
theorem DC001_3_spre_eq : -DC001_3_pre = DC001_3_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_3_pre, DC001_3_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_3_spim_eq : -DC001_3_pim = DC001_3_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_3_pim, DC001_3_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_3_smul :
    -(N_entry_0_0 * N_entry_1_2 * N_entry_2_4) =
      ofLadj DC001_3_spre DC001_3_spim := by
  rw [DC001_3_mul, ofLadj_neg, DC001_3_spre_eq, DC001_3_spim_eq]

def DC001_4_ab_pre : Polynomial ℚ := C (-3) + C (32) * X + C (38) * X ^ 2 + C (21) * X ^ 3 + C (88) * X ^ 4 + C (25) * X ^ 5 + C (34) * X ^ 6 + C (80) * X ^ 7 + C (-23) * X ^ 8 + C (17) * X ^ 9 + C (57) * X ^ 10 + C (-64) * X ^ 11 + C (25) * X ^ 12 + C (-21) * X ^ 13 + C (-44) * X ^ 14 + C (7) * X ^ 15 + C (-11) * X ^ 16 + C (-20) * X ^ 17 + C (15) * X ^ 18
def DC001_4_ab_pim : Polynomial ℚ := C (-19) + C (-38) * X + C (-15) * X ^ 2 + C (-84) * X ^ 3 + C (-90) * X ^ 4 + C (-79) * X ^ 5 + C (-182) * X ^ 6 + C (-139) * X ^ 7 + C (-143) * X ^ 8 + C (-230) * X ^ 9 + C (-115) * X ^ 10 + C (-134) * X ^ 11 + C (-153) * X ^ 12 + C (-61) * X ^ 13 + C (-79) * X ^ 14 + C (-74) * X ^ 15 + C (-4) * X ^ 16 + C (-41) * X ^ 17 + C (-3) * X ^ 18
def DC001_4_pre : Polynomial ℚ := C (-162) + C (-1616) * X + C (-1866) * X ^ 2 + C (-2324) * X ^ 3 + C (-7086) * X ^ 4 + C (-5220) * X ^ 5 + C (-8560) * X ^ 6 + C (-15170) * X ^ 7 + C (-9280) * X ^ 8 + C (-17752) * X ^ 9 + C (-21922) * X ^ 10 + C (-11712) * X ^ 11 + C (-24782) * X ^ 12 + C (-19920) * X ^ 13 + C (-12068) * X ^ 14 + C (-24066) * X ^ 15 + C (-12904) * X ^ 16 + C (-9762) * X ^ 17 + C (-17230) * X ^ 18 + C (-4816) * X ^ 19 + C (-6538) * X ^ 20 + C (-7598) * X ^ 21 + C (-856) * X ^ 22 + C (-3122) * X ^ 23 + C (-2504) * X ^ 24 + C (296) * X ^ 25 + C (-1248) * X ^ 26 + C (-198) * X ^ 27
def DC001_4_pim : Polynomial ℚ := C (454) + C (524) * X + C (-748) * X ^ 2 + C (1530) * X ^ 3 + C (784) * X ^ 4 + C (-712) * X ^ 5 + C (5750) * X ^ 6 + C (1646) * X ^ 7 + C (3388) * X ^ 8 + C (12490) * X ^ 9 + C (2798) * X ^ 10 + C (9922) * X ^ 11 + C (16352) * X ^ 12 + C (4362) * X ^ 13 + C (16820) * X ^ 14 + C (15124) * X ^ 15 + C (5674) * X ^ 16 + C (17242) * X ^ 17 + C (9180) * X ^ 18 + C (4682) * X ^ 19 + C (11252) * X ^ 20 + C (3194) * X ^ 21 + C (3418) * X ^ 22 + C (4720) * X ^ 23 + C (232) * X ^ 24 + C (1168) * X ^ 25 + C (854) * X ^ 26 + C (-366) * X ^ 27
theorem DC001_4_ab_pre_eq :
    N_re_0_1 * N_re_1_0 - N_im_0_1 * N_im_1_0 =
      DC001_4_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_0, N_im_1_0, DC001_4_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_4_ab_pim_eq :
    N_re_0_1 * N_im_1_0 + N_im_0_1 * N_re_1_0 =
      DC001_4_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_0, N_im_1_0, DC001_4_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_4_ab_mul :
    N_entry_0_1 * N_entry_1_0 =
      ofLadj DC001_4_ab_pre DC001_4_ab_pim := by
  rw [N_entry_0_1, N_entry_1_0, ofLadj_mul,
    DC001_4_ab_pre_eq, DC001_4_ab_pim_eq]

theorem DC001_4_pre_eq :
    DC001_4_ab_pre * N_re_2_5 - DC001_4_ab_pim * N_im_2_5 =
      DC001_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_4_ab_pre, DC001_4_ab_pim, N_re_2_5, N_im_2_5, DC001_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_4_pim_eq :
    DC001_4_ab_pre * N_im_2_5 + DC001_4_ab_pim * N_re_2_5 =
      DC001_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_4_ab_pre, DC001_4_ab_pim, N_re_2_5, N_im_2_5, DC001_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_4_mul :
    N_entry_0_1 * N_entry_1_0 * N_entry_2_5 =
      ofLadj DC001_4_pre DC001_4_pim := by
  rw [DC001_4_ab_mul, N_entry_2_5, ofLadj_mul, DC001_4_pre_eq, DC001_4_pim_eq]

def DC001_4_spre : Polynomial ℚ := C (162) + C (1616) * X + C (1866) * X ^ 2 + C (2324) * X ^ 3 + C (7086) * X ^ 4 + C (5220) * X ^ 5 + C (8560) * X ^ 6 + C (15170) * X ^ 7 + C (9280) * X ^ 8 + C (17752) * X ^ 9 + C (21922) * X ^ 10 + C (11712) * X ^ 11 + C (24782) * X ^ 12 + C (19920) * X ^ 13 + C (12068) * X ^ 14 + C (24066) * X ^ 15 + C (12904) * X ^ 16 + C (9762) * X ^ 17 + C (17230) * X ^ 18 + C (4816) * X ^ 19 + C (6538) * X ^ 20 + C (7598) * X ^ 21 + C (856) * X ^ 22 + C (3122) * X ^ 23 + C (2504) * X ^ 24 + C (-296) * X ^ 25 + C (1248) * X ^ 26 + C (198) * X ^ 27
def DC001_4_spim : Polynomial ℚ := C (-454) + C (-524) * X + C (748) * X ^ 2 + C (-1530) * X ^ 3 + C (-784) * X ^ 4 + C (712) * X ^ 5 + C (-5750) * X ^ 6 + C (-1646) * X ^ 7 + C (-3388) * X ^ 8 + C (-12490) * X ^ 9 + C (-2798) * X ^ 10 + C (-9922) * X ^ 11 + C (-16352) * X ^ 12 + C (-4362) * X ^ 13 + C (-16820) * X ^ 14 + C (-15124) * X ^ 15 + C (-5674) * X ^ 16 + C (-17242) * X ^ 17 + C (-9180) * X ^ 18 + C (-4682) * X ^ 19 + C (-11252) * X ^ 20 + C (-3194) * X ^ 21 + C (-3418) * X ^ 22 + C (-4720) * X ^ 23 + C (-232) * X ^ 24 + C (-1168) * X ^ 25 + C (-854) * X ^ 26 + C (366) * X ^ 27
theorem DC001_4_spre_eq : -DC001_4_pre = DC001_4_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_4_pre, DC001_4_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_4_spim_eq : -DC001_4_pim = DC001_4_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_4_pim, DC001_4_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_4_smul :
    -(N_entry_0_1 * N_entry_1_0 * N_entry_2_5) =
      ofLadj DC001_4_spre DC001_4_spim := by
  rw [DC001_4_mul, ofLadj_neg, DC001_4_spre_eq, DC001_4_spim_eq]

def DC001_5_ab_pre : Polynomial ℚ := C (-54) + C (48) * X + C (1) * X ^ 2 + C ((-187 / 2 : ℚ)) * X ^ 3 + C ((309 / 2 : ℚ)) * X ^ 4 + C (-50) * X ^ 5 + C (-19) * X ^ 6 + C ((531 / 2 : ℚ)) * X ^ 7 + C ((-235 / 2 : ℚ)) * X ^ 8 + C (130) * X ^ 9 + C (239) * X ^ 10 + C (-116) * X ^ 11 + C (191) * X ^ 12 + C (129) * X ^ 13 + C (-24) * X ^ 14 + C (199) * X ^ 15 + C (61) * X ^ 16 + C (30) * X ^ 17 + C (88) * X ^ 18
def DC001_5_ab_pim : Polynomial ℚ := C (-57) + C (-114) * X + C (25) * X ^ 2 + C ((-279 / 2 : ℚ)) * X ^ 3 + C ((-191 / 2 : ℚ)) * X ^ 4 + C (49) * X ^ 5 + C (-272) * X ^ 6 + C ((-135 / 2 : ℚ)) * X ^ 7 + C ((-69 / 2 : ℚ)) * X ^ 8 + C (-428) * X ^ 9 + C (23) * X ^ 10 + C (-100) * X ^ 11 + C (-223) * X ^ 12 + C (89) * X ^ 13 + C (-140) * X ^ 14 + C (-111) * X ^ 15 + C (23) * X ^ 16 + C (-114) * X ^ 17 + C (-40) * X ^ 18
def DC001_5_pre : Polynomial ℚ := C ((3423 / 2 : ℚ)) + C (-8070) * X + C ((-6681 / 2 : ℚ)) * X ^ 2 + C (3787) * X ^ 3 + C (-27088) * X ^ 4 + C ((5085 / 2 : ℚ)) * X ^ 5 + C ((-14075 / 2 : ℚ)) * X ^ 6 + C ((-110617 / 2 : ℚ)) * X ^ 7 + C (15119) * X ^ 8 + C (-46039) * X ^ 9 + C (-74850) * X ^ 10 + C (24085) * X ^ 11 + C (-88340) * X ^ 12 + C ((-108593 / 2 : ℚ)) * X ^ 13 + C (10886) * X ^ 14 + C ((-226191 / 2 : ℚ)) * X ^ 15 + C (-24929) * X ^ 16 + C (-19149) * X ^ 17 + C (-96457) * X ^ 18 + C (-2248) * X ^ 19 + C (-30942) * X ^ 20 + C (-48808) * X ^ 21 + C (1679) * X ^ 22 + C (-27248) * X ^ 23 + C (-19344) * X ^ 24 + C (-1802) * X ^ 25 + C (-11582) * X ^ 26 + C (-3800) * X ^ 27
def DC001_5_pim : Polynomial ℚ := C ((8979 / 2 : ℚ)) + C (7851) * X + C ((-6415 / 2 : ℚ)) * X ^ 2 + C ((34983 / 2 : ℚ)) * X ^ 3 + C ((21291 / 2 : ℚ)) * X ^ 4 + C (-9579) * X ^ 5 + C ((83055 / 2 : ℚ)) * X ^ 6 + C ((-3757 / 2 : ℚ)) * X ^ 7 + C ((-9523 / 2 : ℚ)) * X ^ 8 + C ((141641 / 2 : ℚ)) * X ^ 9 + C (-31874) * X ^ 10 + C (17476) * X ^ 11 + C (62491) * X ^ 12 + C (-58513) * X ^ 13 + C (44990) * X ^ 14 + C (26344) * X ^ 15 + C (-56141) * X ^ 16 + C ((109391 / 2 : ℚ)) * X ^ 17 + C (-10588) * X ^ 18 + C (-31408) * X ^ 19 + C (32883) * X ^ 20 + C (-23980) * X ^ 21 + C (-8850) * X ^ 22 + C (11743) * X ^ 23 + C (-15752) * X ^ 24 + C (-81) * X ^ 25 + C (1708) * X ^ 26 + C (-4272) * X ^ 27
theorem DC001_5_ab_pre_eq :
    N_re_0_2 * N_re_1_1 - N_im_0_2 * N_im_1_1 =
      DC001_5_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_1, N_im_1_1, DC001_5_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_5_ab_pim_eq :
    N_re_0_2 * N_im_1_1 + N_im_0_2 * N_re_1_1 =
      DC001_5_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_1, N_im_1_1, DC001_5_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_5_ab_mul :
    N_entry_0_2 * N_entry_1_1 =
      ofLadj DC001_5_ab_pre DC001_5_ab_pim := by
  rw [N_entry_0_2, N_entry_1_1, ofLadj_mul,
    DC001_5_ab_pre_eq, DC001_5_ab_pim_eq]

theorem DC001_5_pre_eq :
    DC001_5_ab_pre * N_re_2_3 - DC001_5_ab_pim * N_im_2_3 =
      DC001_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_5_ab_pre, DC001_5_ab_pim, N_re_2_3, N_im_2_3, DC001_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_5_pim_eq :
    DC001_5_ab_pre * N_im_2_3 + DC001_5_ab_pim * N_re_2_3 =
      DC001_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_5_ab_pre, DC001_5_ab_pim, N_re_2_3, N_im_2_3, DC001_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_5_mul :
    N_entry_0_2 * N_entry_1_1 * N_entry_2_3 =
      ofLadj DC001_5_pre DC001_5_pim := by
  rw [DC001_5_ab_mul, N_entry_2_3, ofLadj_mul, DC001_5_pre_eq, DC001_5_pim_eq]

def DC001_5_spre : Polynomial ℚ := C ((-3423 / 2 : ℚ)) + C (8070) * X + C ((6681 / 2 : ℚ)) * X ^ 2 + C (-3787) * X ^ 3 + C (27088) * X ^ 4 + C ((-5085 / 2 : ℚ)) * X ^ 5 + C ((14075 / 2 : ℚ)) * X ^ 6 + C ((110617 / 2 : ℚ)) * X ^ 7 + C (-15119) * X ^ 8 + C (46039) * X ^ 9 + C (74850) * X ^ 10 + C (-24085) * X ^ 11 + C (88340) * X ^ 12 + C ((108593 / 2 : ℚ)) * X ^ 13 + C (-10886) * X ^ 14 + C ((226191 / 2 : ℚ)) * X ^ 15 + C (24929) * X ^ 16 + C (19149) * X ^ 17 + C (96457) * X ^ 18 + C (2248) * X ^ 19 + C (30942) * X ^ 20 + C (48808) * X ^ 21 + C (-1679) * X ^ 22 + C (27248) * X ^ 23 + C (19344) * X ^ 24 + C (1802) * X ^ 25 + C (11582) * X ^ 26 + C (3800) * X ^ 27
def DC001_5_spim : Polynomial ℚ := C ((-8979 / 2 : ℚ)) + C (-7851) * X + C ((6415 / 2 : ℚ)) * X ^ 2 + C ((-34983 / 2 : ℚ)) * X ^ 3 + C ((-21291 / 2 : ℚ)) * X ^ 4 + C (9579) * X ^ 5 + C ((-83055 / 2 : ℚ)) * X ^ 6 + C ((3757 / 2 : ℚ)) * X ^ 7 + C ((9523 / 2 : ℚ)) * X ^ 8 + C ((-141641 / 2 : ℚ)) * X ^ 9 + C (31874) * X ^ 10 + C (-17476) * X ^ 11 + C (-62491) * X ^ 12 + C (58513) * X ^ 13 + C (-44990) * X ^ 14 + C (-26344) * X ^ 15 + C (56141) * X ^ 16 + C ((-109391 / 2 : ℚ)) * X ^ 17 + C (10588) * X ^ 18 + C (31408) * X ^ 19 + C (-32883) * X ^ 20 + C (23980) * X ^ 21 + C (8850) * X ^ 22 + C (-11743) * X ^ 23 + C (15752) * X ^ 24 + C (81) * X ^ 25 + C (-1708) * X ^ 26 + C (4272) * X ^ 27
theorem DC001_5_spre_eq : -DC001_5_pre = DC001_5_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_5_pre, DC001_5_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_5_spim_eq : -DC001_5_pim = DC001_5_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_5_pim, DC001_5_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_5_smul :
    -(N_entry_0_2 * N_entry_1_1 * N_entry_2_3) =
      ofLadj DC001_5_spre DC001_5_spim := by
  rw [DC001_5_mul, ofLadj_neg, DC001_5_spre_eq, DC001_5_spim_eq]

def DC001_6_ab_pre : Polynomial ℚ := C (48) + C (52) * X ^ 2 + C (90) * X ^ 3 + C (20) * X ^ 4 + C (104) * X ^ 5 + C (92) * X ^ 6 + C (4) * X ^ 7 + C (132) * X ^ 8 + C (38) * X ^ 9 + C (-8) * X ^ 10 + C (76) * X ^ 11 + C (-8) * X ^ 12 + C (-14) * X ^ 13 + C (42) * X ^ 14 + C (-32) * X ^ 15 + C (4) * X ^ 16 + C (16) * X ^ 17 + C (-16) * X ^ 18
def DC001_6_ab_pim : Polynomial ℚ := C (24) + C (48) * X + C (-12) * X ^ 2 + C (66) * X ^ 3 + C (36) * X ^ 4 + C (-28) * X ^ 5 + C (88) * X ^ 6 + C (-4) * X ^ 7 + C (-4) * X ^ 8 + C (130) * X ^ 9 + C (-12) * X ^ 10 + C (36) * X ^ 11 + C (84) * X ^ 12 + C (2) * X ^ 13 + C (58) * X ^ 14 + C (56) * X ^ 15 + C (20) * X ^ 16 + C (40) * X ^ 17 + C (32) * X ^ 18
def DC001_6_pre : Polynomial ℚ := C (456) + C (-288) * X + C (560) * X ^ 2 + C (1296) * X ^ 3 + C (-460) * X ^ 4 + C (2264) * X ^ 5 + C (1948) * X ^ 6 + C (-448) * X ^ 7 + C (4812) * X ^ 8 + C (1044) * X ^ 9 + C (24) * X ^ 10 + C (5656) * X ^ 11 + C (-828) * X ^ 12 + C (904) * X ^ 13 + C (4192) * X ^ 14 + C (-2764) * X ^ 15 + C (1320) * X ^ 16 + C (1316) * X ^ 17 + C (-3192) * X ^ 18 + C (644) * X ^ 19 + C (-540) * X ^ 20 + C (-2036) * X ^ 21 + C (164) * X ^ 22 + C (-896) * X ^ 23 + C (-960) * X ^ 24 + C (-32) * X ^ 25 + C (-416) * X ^ 26 + C (-320) * X ^ 27
def DC001_6_pim : Polynomial ℚ := C (408) + C (816) * X + C (24) * X ^ 2 + C (2028) * X ^ 3 + C (1588) * X ^ 4 + C (472) * X ^ 5 + C (4356) * X ^ 6 + C (1364) * X ^ 7 + C (1888) * X ^ 8 + C (6700) * X ^ 9 + C (476) * X ^ 10 + C (3952) * X ^ 11 + C (6332) * X ^ 12 + C (-136) * X ^ 13 + C (5352) * X ^ 14 + C (4384) * X ^ 15 + C (180) * X ^ 16 + C (5432) * X ^ 17 + C (2496) * X ^ 18 + C (644) * X ^ 19 + C (3548) * X ^ 20 + C (968) * X ^ 21 + C (860) * X ^ 22 + C (1848) * X ^ 23 + C (304) * X ^ 24 + C (528) * X ^ 25 + C (608) * X ^ 26
theorem DC001_6_ab_pre_eq :
    N_re_0_0 * N_re_1_4 - N_im_0_0 * N_im_1_4 =
      DC001_6_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_4, N_im_1_4, DC001_6_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_6_ab_pim_eq :
    N_re_0_0 * N_im_1_4 + N_im_0_0 * N_re_1_4 =
      DC001_6_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_4, N_im_1_4, DC001_6_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_6_ab_mul :
    N_entry_0_0 * N_entry_1_4 =
      ofLadj DC001_6_ab_pre DC001_6_ab_pim := by
  rw [N_entry_0_0, N_entry_1_4, ofLadj_mul,
    DC001_6_ab_pre_eq, DC001_6_ab_pim_eq]

theorem DC001_6_pre_eq :
    DC001_6_ab_pre * N_re_2_2 - DC001_6_ab_pim * N_im_2_2 =
      DC001_6_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_6_ab_pre, DC001_6_ab_pim, N_re_2_2, N_im_2_2, DC001_6_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_6_pim_eq :
    DC001_6_ab_pre * N_im_2_2 + DC001_6_ab_pim * N_re_2_2 =
      DC001_6_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_6_ab_pre, DC001_6_ab_pim, N_re_2_2, N_im_2_2, DC001_6_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_6_mul :
    N_entry_0_0 * N_entry_1_4 * N_entry_2_2 =
      ofLadj DC001_6_pre DC001_6_pim := by
  rw [DC001_6_ab_mul, N_entry_2_2, ofLadj_mul, DC001_6_pre_eq, DC001_6_pim_eq]

def DC001_7_ab_pre : Polynomial ℚ := C (95) + C (-192) * X + C (-115) * X ^ 2 + C (116) * X ^ 3 + C (-510) * X ^ 4 + C (80) * X ^ 5 + C (28) * X ^ 6 + C (-628) * X ^ 7 + C (406) * X ^ 8 + C (-223) * X ^ 9 + C (-560) * X ^ 10 + C (452) * X ^ 11 + C (-368) * X ^ 12 + C (-108) * X ^ 13 + C (290) * X ^ 14 + C (-286) * X ^ 15 + C (28) * X ^ 16 + C (80) * X ^ 17 + C (-168) * X ^ 18
def DC001_7_ab_pim : Polynomial ℚ := C (170) + C (340) * X + C (63) * X ^ 2 + C (607) * X ^ 3 + C (570) * X ^ 4 + C (275) * X ^ 5 + C (1169) * X ^ 6 + C (644) * X ^ 7 + C (581) * X ^ 8 + C (1587) * X ^ 9 + C (422) * X ^ 10 + C (740) * X ^ 11 + C (1058) * X ^ 12 + C (170) * X ^ 13 + C (632) * X ^ 14 + C (510) * X ^ 15 + C (24) * X ^ 16 + C (352) * X ^ 17 + C (96) * X ^ 18
def DC001_7_pre : Polynomial ℚ := C (-340) + C (-1360) * X + C (-1486) * X ^ 2 + C ((-3477 / 2 : ℚ)) * X ^ 3 + C (-5503) * X ^ 4 + C (-3897) * X ^ 5 + C ((-12485 / 2 : ℚ)) * X ^ 6 + C ((-24575 / 2 : ℚ)) * X ^ 7 + C (-6751) * X ^ 8 + C (-14415) * X ^ 9 + C ((-37731 / 2 : ℚ)) * X ^ 10 + C (-8373) * X ^ 11 + C ((-43983 / 2 : ℚ)) * X ^ 12 + C (-17915) * X ^ 13 + C ((-20111 / 2 : ℚ)) * X ^ 14 + C ((-48015 / 2 : ℚ)) * X ^ 15 + C (-12303) * X ^ 16 + C ((-20683 / 2 : ℚ)) * X ^ 17 + C (-19147) * X ^ 18 + C (-5315) * X ^ 19 + C (-8376) * X ^ 20 + C (-9431) * X ^ 21 + C (-1827) * X ^ 22 + C (-4945) * X ^ 23 + C (-3390) * X ^ 24 + C (-272) * X ^ 25 + C (-1924) * X ^ 26 + C (-384) * X ^ 27
def DC001_7_pim : Polynomial ℚ := C (190) + C (-4) * X + C (-998) * X ^ 2 + C (482) * X ^ 3 + C (-262) * X ^ 4 + C ((-4353 / 2 : ℚ)) * X ^ 5 + C ((6059 / 2 : ℚ)) * X ^ 6 + C ((-2421 / 2 : ℚ)) * X ^ 7 + C ((-1779 / 2 : ℚ)) * X ^ 8 + C (6969) * X ^ 9 + C (-3247) * X ^ 10 + C (2844) * X ^ 11 + C (9198) * X ^ 12 + C (-4113) * X ^ 13 + C ((17937 / 2 : ℚ)) * X ^ 14 + C ((14149 / 2 : ℚ)) * X ^ 15 + C ((-5557 / 2 : ℚ)) * X ^ 16 + C ((21651 / 2 : ℚ)) * X ^ 17 + C (2234) * X ^ 18 + C (-973) * X ^ 19 + C (7714) * X ^ 20 + C (-844) * X ^ 21 + C (1080) * X ^ 22 + C (3125) * X ^ 23 + C (-1344) * X ^ 24 + C (640) * X ^ 25 + C (392) * X ^ 26 + C (-672) * X ^ 27
theorem DC001_7_ab_pre_eq :
    N_re_0_1 * N_re_1_5 - N_im_0_1 * N_im_1_5 =
      DC001_7_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_5, N_im_1_5, DC001_7_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_7_ab_pim_eq :
    N_re_0_1 * N_im_1_5 + N_im_0_1 * N_re_1_5 =
      DC001_7_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_5, N_im_1_5, DC001_7_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_7_ab_mul :
    N_entry_0_1 * N_entry_1_5 =
      ofLadj DC001_7_ab_pre DC001_7_ab_pim := by
  rw [N_entry_0_1, N_entry_1_5, ofLadj_mul,
    DC001_7_ab_pre_eq, DC001_7_ab_pim_eq]

theorem DC001_7_pre_eq :
    DC001_7_ab_pre * N_re_2_0 - DC001_7_ab_pim * N_im_2_0 =
      DC001_7_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_7_ab_pre, DC001_7_ab_pim, N_re_2_0, N_im_2_0, DC001_7_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_7_pim_eq :
    DC001_7_ab_pre * N_im_2_0 + DC001_7_ab_pim * N_re_2_0 =
      DC001_7_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_7_ab_pre, DC001_7_ab_pim, N_re_2_0, N_im_2_0, DC001_7_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_7_mul :
    N_entry_0_1 * N_entry_1_5 * N_entry_2_0 =
      ofLadj DC001_7_pre DC001_7_pim := by
  rw [DC001_7_ab_mul, N_entry_2_0, ofLadj_mul, DC001_7_pre_eq, DC001_7_pim_eq]

def DC001_8_ab_pre : Polynomial ℚ := C (138) + C (-144) * X + C (-42) * X ^ 2 + C ((469 / 2 : ℚ)) * X ^ 3 + C ((-901 / 2 : ℚ)) * X ^ 4 + C (125) * X ^ 5 + C (38) * X ^ 6 + C ((-1483 / 2 : ℚ)) * X ^ 7 + C ((601 / 2 : ℚ)) * X ^ 8 + C (-385) * X ^ 9 + C (-735) * X ^ 10 + C (294) * X ^ 11 + C (-591) * X ^ 12 + C (-343) * X ^ 13 + C (66) * X ^ 14 + C (-531) * X ^ 15 + C (-143) * X ^ 16 + C (-56) * X ^ 17 + C (-240) * X ^ 18
def DC001_8_ab_pim : Polynomial ℚ := C (159) + C (318) * X + C (-64) * X ^ 2 + C ((823 / 2 : ℚ)) * X ^ 3 + C ((601 / 2 : ℚ)) * X ^ 4 + C (-112) * X ^ 5 + C (781) * X ^ 6 + C ((409 / 2 : ℚ)) * X ^ 7 + C ((201 / 2 : ℚ)) * X ^ 8 + C (1183) * X ^ 9 + C (-57) * X ^ 10 + C (306) * X ^ 11 + C (669) * X ^ 12 + C (-189) * X ^ 13 + C (418) * X ^ 14 + C (345) * X ^ 15 + C (-67) * X ^ 16 + C (328) * X ^ 17 + C (80) * X ^ 18
def DC001_8_pre : Polynomial ℚ := C ((4695 / 2 : ℚ)) + C (-7662) * X + C ((-5993 / 2 : ℚ)) * X ^ 2 + C (4819) * X ^ 3 + C (-27310) * X ^ 4 + C ((6501 / 2 : ℚ)) * X ^ 5 + C ((-11731 / 2 : ℚ)) * X ^ 6 + C ((-110621 / 2 : ℚ)) * X ^ 7 + C (17142) * X ^ 8 + C (-44189) * X ^ 9 + C (-73991) * X ^ 10 + C (25540) * X ^ 11 + C (-88137) * X ^ 12 + C ((-107897 / 2 : ℚ)) * X ^ 13 + C (11449) * X ^ 14 + C ((-224125 / 2 : ℚ)) * X ^ 15 + C (-24064) * X ^ 16 + C (-18148) * X ^ 17 + C (-94702) * X ^ 18 + C (-1974) * X ^ 19 + C (-30796) * X ^ 20 + C (-47832) * X ^ 21 + C (1931) * X ^ 22 + C (-26024) * X ^ 23 + C (-18040) * X ^ 24 + C (-1100) * X ^ 25 + C (-10640) * X ^ 26 + C (-3200) * X ^ 27
def DC001_8_pim : Polynomial ℚ := C ((9585 / 2 : ℚ)) + C (8649) * X + C ((-6283 / 2 : ℚ)) * X ^ 2 + C ((37519 / 2 : ℚ)) * X ^ 3 + C ((24991 / 2 : ℚ)) * X ^ 4 + C (-8282) * X ^ 5 + C ((89935 / 2 : ℚ)) * X ^ 6 + C ((3721 / 2 : ℚ)) * X ^ 7 + C ((-1807 / 2 : ℚ)) * X ^ 8 + C ((154575 / 2 : ℚ)) * X ^ 9 + C (-26335) * X ^ 10 + C (23579) * X ^ 11 + C (70016) * X ^ 12 + C (-50426) * X ^ 13 + C (53424) * X ^ 14 + C (35301) * X ^ 15 + C (-46540) * X ^ 16 + C ((126763 / 2 : ℚ)) * X ^ 17 + C (-2570) * X ^ 18 + C (-23588) * X ^ 19 + C (38559) * X ^ 20 + C (-17904) * X ^ 21 + C (-3408) * X ^ 22 + C (15501) * X ^ 23 + C (-12352) * X ^ 24 + C (2235) * X ^ 25 + C (2840) * X ^ 26 + C (-3600) * X ^ 27
theorem DC001_8_ab_pre_eq :
    N_re_0_2 * N_re_1_3 - N_im_0_2 * N_im_1_3 =
      DC001_8_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_3, N_im_1_3, DC001_8_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_8_ab_pim_eq :
    N_re_0_2 * N_im_1_3 + N_im_0_2 * N_re_1_3 =
      DC001_8_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_3, N_im_1_3, DC001_8_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_8_ab_mul :
    N_entry_0_2 * N_entry_1_3 =
      ofLadj DC001_8_ab_pre DC001_8_ab_pim := by
  rw [N_entry_0_2, N_entry_1_3, ofLadj_mul,
    DC001_8_ab_pre_eq, DC001_8_ab_pim_eq]

theorem DC001_8_pre_eq :
    DC001_8_ab_pre * N_re_2_1 - DC001_8_ab_pim * N_im_2_1 =
      DC001_8_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_8_ab_pre, DC001_8_ab_pim, N_re_2_1, N_im_2_1, DC001_8_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_8_pim_eq :
    DC001_8_ab_pre * N_im_2_1 + DC001_8_ab_pim * N_re_2_1 =
      DC001_8_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_8_ab_pre, DC001_8_ab_pim, N_re_2_1, N_im_2_1, DC001_8_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_8_mul :
    N_entry_0_2 * N_entry_1_3 * N_entry_2_1 =
      ofLadj DC001_8_pre DC001_8_pim := by
  rw [DC001_8_ab_mul, N_entry_2_1, ofLadj_mul, DC001_8_pre_eq, DC001_8_pim_eq]

def DC001_9_ab_pre : Polynomial ℚ := C (52) + C (54) * X ^ 2 + C (91) * X ^ 3 + C (20) * X ^ 4 + C (104) * X ^ 5 + C (92) * X ^ 6 + C (4) * X ^ 7 + C (133) * X ^ 8 + C (40) * X ^ 9 + C (-8) * X ^ 10 + C (76) * X ^ 11 + C (-8) * X ^ 12 + C (-14) * X ^ 13 + C (42) * X ^ 14 + C (-32) * X ^ 15 + C (4) * X ^ 16 + C (16) * X ^ 17 + C (-16) * X ^ 18
def DC001_9_ab_pim : Polynomial ℚ := C (24) + C (48) * X + C (-14) * X ^ 2 + C (65) * X ^ 3 + C (36) * X ^ 4 + C (-30) * X ^ 5 + C (90) * X ^ 6 + C (-4) * X ^ 7 + C (-3) * X ^ 8 + C (132) * X ^ 9 + C (-12) * X ^ 10 + C (36) * X ^ 11 + C (84) * X ^ 12 + C (2) * X ^ 13 + C (58) * X ^ 14 + C (56) * X ^ 15 + C (20) * X ^ 16 + C (40) * X ^ 17 + C (32) * X ^ 18
def DC001_9_pre : Polynomial ℚ := C (1118) + C (-624) * X + C (1288) * X ^ 2 + C (2867) * X ^ 3 + C (-1139) * X ^ 4 + C (4736) * X ^ 5 + C (3808) * X ^ 6 + C (-1756) * X ^ 7 + C (9625) * X ^ 8 + C (1164) * X ^ 9 + C (-1280) * X ^ 10 + C (10967) * X ^ 11 + C (-3130) * X ^ 12 + C (726) * X ^ 13 + C (8058) * X ^ 14 + C (-6905) * X ^ 15 + C (2134) * X ^ 16 + C (2382) * X ^ 17 + C (-7180) * X ^ 18 + C (1176) * X ^ 19 + C (-1274) * X ^ 20 + C (-4434) * X ^ 21 + C (288) * X ^ 22 + C (-1960) * X ^ 23 + C (-2124) * X ^ 24 + C (-124) * X ^ 25 + C (-892) * X ^ 26 + C (-680) * X ^ 27
def DC001_9_pim : Polynomial ℚ := C (926) + C (1852) * X + C (-46) * X ^ 2 + C (4340) * X ^ 3 + C (3231) * X ^ 4 + C (571) * X ^ 5 + C (9133) * X ^ 6 + C (2354) * X ^ 7 + C (3490) * X ^ 8 + C (14106) * X ^ 9 + C (439) * X ^ 10 + C (8001) * X ^ 11 + C (13157) * X ^ 12 + C (-904) * X ^ 13 + C (10976) * X ^ 14 + C (8877) * X ^ 15 + C (-321) * X ^ 16 + C (10927) * X ^ 17 + C (4644) * X ^ 18 + C (576) * X ^ 19 + C (6810) * X ^ 20 + C (1344) * X ^ 21 + C (1208) * X ^ 22 + C (3478) * X ^ 23 + C (304) * X ^ 24 + C (888) * X ^ 25 + C (1164) * X ^ 26 + C (-40) * X ^ 27
theorem DC001_9_ab_pre_eq :
    N_re_0_0 * N_re_1_5 - N_im_0_0 * N_im_1_5 =
      DC001_9_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_5, N_im_1_5, DC001_9_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_9_ab_pim_eq :
    N_re_0_0 * N_im_1_5 + N_im_0_0 * N_re_1_5 =
      DC001_9_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_0, N_im_0_0, N_re_1_5, N_im_1_5, DC001_9_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_9_ab_mul :
    N_entry_0_0 * N_entry_1_5 =
      ofLadj DC001_9_ab_pre DC001_9_ab_pim := by
  rw [N_entry_0_0, N_entry_1_5, ofLadj_mul,
    DC001_9_ab_pre_eq, DC001_9_ab_pim_eq]

theorem DC001_9_pre_eq :
    DC001_9_ab_pre * N_re_2_1 - DC001_9_ab_pim * N_im_2_1 =
      DC001_9_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_9_ab_pre, DC001_9_ab_pim, N_re_2_1, N_im_2_1, DC001_9_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_9_pim_eq :
    DC001_9_ab_pre * N_im_2_1 + DC001_9_ab_pim * N_re_2_1 =
      DC001_9_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_9_ab_pre, DC001_9_ab_pim, N_re_2_1, N_im_2_1, DC001_9_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_9_mul :
    N_entry_0_0 * N_entry_1_5 * N_entry_2_1 =
      ofLadj DC001_9_pre DC001_9_pim := by
  rw [DC001_9_ab_mul, N_entry_2_1, ofLadj_mul, DC001_9_pre_eq, DC001_9_pim_eq]

def DC001_9_spre : Polynomial ℚ := C (-1118) + C (624) * X + C (-1288) * X ^ 2 + C (-2867) * X ^ 3 + C (1139) * X ^ 4 + C (-4736) * X ^ 5 + C (-3808) * X ^ 6 + C (1756) * X ^ 7 + C (-9625) * X ^ 8 + C (-1164) * X ^ 9 + C (1280) * X ^ 10 + C (-10967) * X ^ 11 + C (3130) * X ^ 12 + C (-726) * X ^ 13 + C (-8058) * X ^ 14 + C (6905) * X ^ 15 + C (-2134) * X ^ 16 + C (-2382) * X ^ 17 + C (7180) * X ^ 18 + C (-1176) * X ^ 19 + C (1274) * X ^ 20 + C (4434) * X ^ 21 + C (-288) * X ^ 22 + C (1960) * X ^ 23 + C (2124) * X ^ 24 + C (124) * X ^ 25 + C (892) * X ^ 26 + C (680) * X ^ 27
def DC001_9_spim : Polynomial ℚ := C (-926) + C (-1852) * X + C (46) * X ^ 2 + C (-4340) * X ^ 3 + C (-3231) * X ^ 4 + C (-571) * X ^ 5 + C (-9133) * X ^ 6 + C (-2354) * X ^ 7 + C (-3490) * X ^ 8 + C (-14106) * X ^ 9 + C (-439) * X ^ 10 + C (-8001) * X ^ 11 + C (-13157) * X ^ 12 + C (904) * X ^ 13 + C (-10976) * X ^ 14 + C (-8877) * X ^ 15 + C (321) * X ^ 16 + C (-10927) * X ^ 17 + C (-4644) * X ^ 18 + C (-576) * X ^ 19 + C (-6810) * X ^ 20 + C (-1344) * X ^ 21 + C (-1208) * X ^ 22 + C (-3478) * X ^ 23 + C (-304) * X ^ 24 + C (-888) * X ^ 25 + C (-1164) * X ^ 26 + C (40) * X ^ 27
theorem DC001_9_spre_eq : -DC001_9_pre = DC001_9_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_9_pre, DC001_9_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_9_spim_eq : -DC001_9_pim = DC001_9_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_9_pim, DC001_9_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_9_smul :
    -(N_entry_0_0 * N_entry_1_5 * N_entry_2_1) =
      ofLadj DC001_9_spre DC001_9_spim := by
  rw [DC001_9_mul, ofLadj_neg, DC001_9_spre_eq, DC001_9_spim_eq]

def DC001_10_ab_pre : Polynomial ℚ := C (223) + C (-384) * X + C (-151) * X ^ 2 + C ((801 / 2 : ℚ)) * X ^ 3 + C ((-2019 / 2 : ℚ)) * X ^ 4 + C (305) * X ^ 5 + C ((339 / 2 : ℚ)) * X ^ 6 + C (-1390) * X ^ 7 + C (906) * X ^ 8 + C (-610) * X ^ 9 + C (-1391) * X ^ 10 + C (881) * X ^ 11 + C (-1007) * X ^ 12 + C (-459) * X ^ 13 + C ((1011 / 2 : ℚ)) * X ^ 14 + C ((-1601 / 2 : ℚ)) * X ^ 15 + C ((-45 / 2 : ℚ)) * X ^ 16 + C (113) * X ^ 17 + C (-420) * X ^ 18
def DC001_10_ab_pim : Polynomial ℚ := C (364) + C (728) * X + C (79) * X ^ 2 + C ((2475 / 2 : ℚ)) * X ^ 3 + C ((2177 / 2 : ℚ)) * X ^ 4 + C (322) * X ^ 5 + C ((4535 / 2 : ℚ)) * X ^ 6 + C (1016) * X ^ 7 + C (844) * X ^ 8 + C (3174) * X ^ 9 + C (538) * X ^ 10 + C (1336) * X ^ 11 + C (2134) * X ^ 12 + C (147) * X ^ 13 + C ((2637 / 2 : ℚ)) * X ^ 14 + C ((2111 / 2 : ℚ)) * X ^ 15 + C ((29 / 2 : ℚ)) * X ^ 16 + C (796) * X ^ 17 + C (240) * X ^ 18
def DC001_10_pre : Polynomial ℚ := C (1361) + C (-8592) * X + C (-4646) * X ^ 2 + C (185) * X ^ 3 + C (-32046) * X ^ 4 + C (-3420) * X ^ 5 + C (-14916) * X ^ 6 + C (-62693) * X ^ 7 + C (7083) * X ^ 8 + C (-56264) * X ^ 9 + C (-85280) * X ^ 10 + C (11786) * X ^ 11 + C (-102754) * X ^ 12 + C (-67510) * X ^ 13 + C (-393) * X ^ 14 + C (-122357) * X ^ 15 + C (-31930) * X ^ 16 + C (-24034) * X ^ 17 + C (-101826) * X ^ 18 + C (-7027) * X ^ 19 + C (-33546) * X ^ 20 + C (-51227) * X ^ 21 + C (1458) * X ^ 22 + C (-25161) * X ^ 23 + C (-17654) * X ^ 24 + C (264) * X ^ 25 + C (-10116) * X ^ 26 + C (-3600) * X ^ 27
def DC001_10_pim : Polynomial ℚ := C (4673) + C (8194) * X + C (-878) * X ^ 2 + C (22566) * X ^ 3 + C (18421) * X ^ 4 + C (3120) * X ^ 5 + C (58559) * X ^ 6 + C (20002) * X ^ 7 + C (24123) * X ^ 8 + C (104266) * X ^ 9 + C (6725) * X ^ 10 + C (62776) * X ^ 11 + C (112473) * X ^ 12 + C (-5335) * X ^ 13 + C (100184) * X ^ 14 + C (81790) * X ^ 15 + C (-2729) * X ^ 16 + C (105604) * X ^ 17 + C (35453) * X ^ 18 + C (7623) * X ^ 19 + C (67329) * X ^ 20 + C (5368) * X ^ 21 + C (13628) * X ^ 22 + C (29394) * X ^ 23 + C (-3228) * X ^ 24 + C (7658) * X ^ 25 + C (6488) * X ^ 26 + C (-2400) * X ^ 27
theorem DC001_10_ab_pre_eq :
    N_re_0_1 * N_re_1_3 - N_im_0_1 * N_im_1_3 =
      DC001_10_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_3, N_im_1_3, DC001_10_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_10_ab_pim_eq :
    N_re_0_1 * N_im_1_3 + N_im_0_1 * N_re_1_3 =
      DC001_10_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_1, N_im_0_1, N_re_1_3, N_im_1_3, DC001_10_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_10_ab_mul :
    N_entry_0_1 * N_entry_1_3 =
      ofLadj DC001_10_ab_pre DC001_10_ab_pim := by
  rw [N_entry_0_1, N_entry_1_3, ofLadj_mul,
    DC001_10_ab_pre_eq, DC001_10_ab_pim_eq]

theorem DC001_10_pre_eq :
    DC001_10_ab_pre * N_re_2_2 - DC001_10_ab_pim * N_im_2_2 =
      DC001_10_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_10_ab_pre, DC001_10_ab_pim, N_re_2_2, N_im_2_2, DC001_10_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_10_pim_eq :
    DC001_10_ab_pre * N_im_2_2 + DC001_10_ab_pim * N_re_2_2 =
      DC001_10_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_10_ab_pre, DC001_10_ab_pim, N_re_2_2, N_im_2_2, DC001_10_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_10_mul :
    N_entry_0_1 * N_entry_1_3 * N_entry_2_2 =
      ofLadj DC001_10_pre DC001_10_pim := by
  rw [DC001_10_ab_mul, N_entry_2_2, ofLadj_mul, DC001_10_pre_eq, DC001_10_pim_eq]

def DC001_10_spre : Polynomial ℚ := C (-1361) + C (8592) * X + C (4646) * X ^ 2 + C (-185) * X ^ 3 + C (32046) * X ^ 4 + C (3420) * X ^ 5 + C (14916) * X ^ 6 + C (62693) * X ^ 7 + C (-7083) * X ^ 8 + C (56264) * X ^ 9 + C (85280) * X ^ 10 + C (-11786) * X ^ 11 + C (102754) * X ^ 12 + C (67510) * X ^ 13 + C (393) * X ^ 14 + C (122357) * X ^ 15 + C (31930) * X ^ 16 + C (24034) * X ^ 17 + C (101826) * X ^ 18 + C (7027) * X ^ 19 + C (33546) * X ^ 20 + C (51227) * X ^ 21 + C (-1458) * X ^ 22 + C (25161) * X ^ 23 + C (17654) * X ^ 24 + C (-264) * X ^ 25 + C (10116) * X ^ 26 + C (3600) * X ^ 27
def DC001_10_spim : Polynomial ℚ := C (-4673) + C (-8194) * X + C (878) * X ^ 2 + C (-22566) * X ^ 3 + C (-18421) * X ^ 4 + C (-3120) * X ^ 5 + C (-58559) * X ^ 6 + C (-20002) * X ^ 7 + C (-24123) * X ^ 8 + C (-104266) * X ^ 9 + C (-6725) * X ^ 10 + C (-62776) * X ^ 11 + C (-112473) * X ^ 12 + C (5335) * X ^ 13 + C (-100184) * X ^ 14 + C (-81790) * X ^ 15 + C (2729) * X ^ 16 + C (-105604) * X ^ 17 + C (-35453) * X ^ 18 + C (-7623) * X ^ 19 + C (-67329) * X ^ 20 + C (-5368) * X ^ 21 + C (-13628) * X ^ 22 + C (-29394) * X ^ 23 + C (3228) * X ^ 24 + C (-7658) * X ^ 25 + C (-6488) * X ^ 26 + C (2400) * X ^ 27
theorem DC001_10_spre_eq : -DC001_10_pre = DC001_10_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_10_pre, DC001_10_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_10_spim_eq : -DC001_10_pim = DC001_10_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_10_pim, DC001_10_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_10_smul :
    -(N_entry_0_1 * N_entry_1_3 * N_entry_2_2) =
      ofLadj DC001_10_spre DC001_10_spim := by
  rw [DC001_10_mul, ofLadj_neg, DC001_10_spre_eq, DC001_10_spim_eq]

def DC001_11_ab_pre : Polynomial ℚ := C (54) + C (-72) * X + C (-36) * X ^ 2 + C (84) * X ^ 3 + C (-204) * X ^ 4 + C (52) * X ^ 5 + C (12) * X ^ 6 + C (-324) * X ^ 7 + C (116) * X ^ 8 + C (-188) * X ^ 9 + C (-356) * X ^ 10 + C (96) * X ^ 11 + C (-284) * X ^ 12 + C (-152) * X ^ 13 + C (32) * X ^ 14 + C (-216) * X ^ 15 + C (-48) * X ^ 16 + C (-8) * X ^ 17 + C (-96) * X ^ 18
def DC001_11_ab_pim : Polynomial ℚ := C (72) + C (144) * X + C (-12) * X ^ 2 + C (204) * X ^ 3 + C (160) * X ^ 4 + C (-14) * X ^ 5 + C (374) * X ^ 6 + C (120) * X ^ 7 + C (72) * X ^ 8 + C (536) * X ^ 9 + C (12) * X ^ 10 + C (180) * X ^ 11 + C (348) * X ^ 12 + C (-20) * X ^ 13 + C (228) * X ^ 14 + C (192) * X ^ 15 + C (-8) * X ^ 16 + C (152) * X ^ 17 + C (32) * X ^ 18
def DC001_11_pre : Polynomial ℚ := C (-144) + C (-576) * X + C (-552) * X ^ 2 + C (-441) * X ^ 3 + C (-1946) * X ^ 4 + C (-891) * X ^ 5 + C (-1511) * X ^ 6 + C (-3950) * X ^ 7 + C (-985) * X ^ 8 + C (-4056) * X ^ 9 + C (-5916) * X ^ 10 + C (-872) * X ^ 11 + C (-7032) * X ^ 12 + C (-5322) * X ^ 13 + C (-1944) * X ^ 14 + C (-8648) * X ^ 15 + C (-3664) * X ^ 16 + C (-3172) * X ^ 17 + C (-7524) * X ^ 18 + C (-1508) * X ^ 19 + C (-3298) * X ^ 20 + C (-3900) * X ^ 21 + C (-632) * X ^ 22 + C (-2208) * X ^ 23 + C (-1480) * X ^ 24 + C (-108) * X ^ 25 + C (-880) * X ^ 26 + C (-128) * X ^ 27
def DC001_11_pim : Polynomial ℚ := C (108) + C (72) * X + C (-360) * X ^ 2 + C (366) * X ^ 3 + C (108) * X ^ 4 + C (-850) * X ^ 5 + C (1438) * X ^ 6 + C (-698) * X ^ 7 + C (-989) * X ^ 8 + C (2291) * X ^ 9 + C (-2815) * X ^ 10 + C (-562) * X ^ 11 + C (2013) * X ^ 12 + C (-4475) * X ^ 13 + C (1233) * X ^ 14 + C (192) * X ^ 15 + C (-4334) * X ^ 16 + C (2010) * X ^ 17 + C (-1674) * X ^ 18 + C (-2686) * X ^ 19 + C (1636) * X ^ 20 + C (-1946) * X ^ 21 + C (-606) * X ^ 22 + C (556) * X ^ 23 + C (-1212) * X ^ 24 + C (-44) * X ^ 25 + C (-48) * X ^ 26 + C (-384) * X ^ 27
theorem DC001_11_ab_pre_eq :
    N_re_0_2 * N_re_1_4 - N_im_0_2 * N_im_1_4 =
      DC001_11_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_4, N_im_1_4, DC001_11_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_11_ab_pim_eq :
    N_re_0_2 * N_im_1_4 + N_im_0_2 * N_re_1_4 =
      DC001_11_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_2, N_im_0_2, N_re_1_4, N_im_1_4, DC001_11_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_11_ab_mul :
    N_entry_0_2 * N_entry_1_4 =
      ofLadj DC001_11_ab_pre DC001_11_ab_pim := by
  rw [N_entry_0_2, N_entry_1_4, ofLadj_mul,
    DC001_11_ab_pre_eq, DC001_11_ab_pim_eq]

theorem DC001_11_pre_eq :
    DC001_11_ab_pre * N_re_2_0 - DC001_11_ab_pim * N_im_2_0 =
      DC001_11_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_11_ab_pre, DC001_11_ab_pim, N_re_2_0, N_im_2_0, DC001_11_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_11_pim_eq :
    DC001_11_ab_pre * N_im_2_0 + DC001_11_ab_pim * N_re_2_0 =
      DC001_11_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_11_ab_pre, DC001_11_ab_pim, N_re_2_0, N_im_2_0, DC001_11_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_11_mul :
    N_entry_0_2 * N_entry_1_4 * N_entry_2_0 =
      ofLadj DC001_11_pre DC001_11_pim := by
  rw [DC001_11_ab_mul, N_entry_2_0, ofLadj_mul, DC001_11_pre_eq, DC001_11_pim_eq]

def DC001_11_spre : Polynomial ℚ := C (144) + C (576) * X + C (552) * X ^ 2 + C (441) * X ^ 3 + C (1946) * X ^ 4 + C (891) * X ^ 5 + C (1511) * X ^ 6 + C (3950) * X ^ 7 + C (985) * X ^ 8 + C (4056) * X ^ 9 + C (5916) * X ^ 10 + C (872) * X ^ 11 + C (7032) * X ^ 12 + C (5322) * X ^ 13 + C (1944) * X ^ 14 + C (8648) * X ^ 15 + C (3664) * X ^ 16 + C (3172) * X ^ 17 + C (7524) * X ^ 18 + C (1508) * X ^ 19 + C (3298) * X ^ 20 + C (3900) * X ^ 21 + C (632) * X ^ 22 + C (2208) * X ^ 23 + C (1480) * X ^ 24 + C (108) * X ^ 25 + C (880) * X ^ 26 + C (128) * X ^ 27
def DC001_11_spim : Polynomial ℚ := C (-108) + C (-72) * X + C (360) * X ^ 2 + C (-366) * X ^ 3 + C (-108) * X ^ 4 + C (850) * X ^ 5 + C (-1438) * X ^ 6 + C (698) * X ^ 7 + C (989) * X ^ 8 + C (-2291) * X ^ 9 + C (2815) * X ^ 10 + C (562) * X ^ 11 + C (-2013) * X ^ 12 + C (4475) * X ^ 13 + C (-1233) * X ^ 14 + C (-192) * X ^ 15 + C (4334) * X ^ 16 + C (-2010) * X ^ 17 + C (1674) * X ^ 18 + C (2686) * X ^ 19 + C (-1636) * X ^ 20 + C (1946) * X ^ 21 + C (606) * X ^ 22 + C (-556) * X ^ 23 + C (1212) * X ^ 24 + C (44) * X ^ 25 + C (48) * X ^ 26 + C (384) * X ^ 27
theorem DC001_11_spre_eq : -DC001_11_pre = DC001_11_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_11_pre, DC001_11_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_11_spim_eq : -DC001_11_pim = DC001_11_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_11_pim, DC001_11_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_11_smul :
    -(N_entry_0_2 * N_entry_1_4 * N_entry_2_0) =
      ofLadj DC001_11_spre DC001_11_spim := by
  rw [DC001_11_mul, ofLadj_neg, DC001_11_spre_eq, DC001_11_spim_eq]

def DC001_12_ab_pre : Polynomial ℚ := C (342) + C (-304) * X + C (98) * X ^ 2 + C ((1217 / 2 : ℚ)) * X ^ 3 + C ((-1545 / 2 : ℚ)) * X ^ 4 + C (528) * X ^ 5 + C ((793 / 2 : ℚ)) * X ^ 6 + C (-1216) * X ^ 7 + C (1114) * X ^ 8 + C (-405) * X ^ 9 + C (-1185) * X ^ 10 + C (967) * X ^ 11 + C (-881) * X ^ 12 + C (-503) * X ^ 13 + C ((1011 / 2 : ℚ)) * X ^ 14 + C ((-1659 / 2 : ℚ)) * X ^ 15 + C ((-73 / 2 : ℚ)) * X ^ 16 + C (95) * X ^ 17 + C (-386) * X ^ 18
def DC001_12_ab_pim : Polynomial ℚ := C (361) + C (722) * X + C ((2259 / 2 : ℚ)) * X ^ 3 + C ((1879 / 2 : ℚ)) * X ^ 4 + C (65) * X ^ 5 + C ((4153 / 2 : ℚ)) * X ^ 6 + C (700) * X ^ 7 + C (634) * X ^ 8 + C (2965) * X ^ 9 + C (330) * X ^ 10 + C (1132) * X ^ 11 + C (1934) * X ^ 12 + C (21) * X ^ 13 + C ((2445 / 2 : ℚ)) * X ^ 14 + C ((1997 / 2 : ℚ)) * X ^ 15 + C ((129 / 2 : ℚ)) * X ^ 16 + C (780) * X ^ 17 + C (348) * X ^ 18
def DC001_12_pre : Polynomial ℚ := C (2679) + C (-7676) * X + C (-1164) * X ^ 2 + C (4787) * X ^ 3 + C (-26536) * X ^ 4 + C (5212) * X ^ 5 + C (-4880) * X ^ 6 + C (-52053) * X ^ 7 + C (22039) * X ^ 8 + C (-41866) * X ^ 9 + C (-68942) * X ^ 10 + C (29072) * X ^ 11 + C (-86450) * X ^ 12 + C (-52246) * X ^ 13 + C (13947) * X ^ 14 + C (-110063) * X ^ 15 + C (-21620) * X ^ 16 + C (-15856) * X ^ 17 + C (-94266) * X ^ 18 + C (-3751) * X ^ 19 + C (-29734) * X ^ 20 + C (-49351) * X ^ 21 + C (1090) * X ^ 22 + C (-24167) * X ^ 23 + C (-18190) * X ^ 24 + C (-446) * X ^ 25 + C (-9720) * X ^ 26 + C (-4328) * X ^ 27
def DC001_12_pim : Polynomial ℚ := C (4997) + C (9082) * X + C (-770) * X ^ 2 + C (23996) * X ^ 3 + C (18939) * X ^ 4 + C (2256) * X ^ 5 + C (59509) * X ^ 6 + C (17294) * X ^ 7 + C (22419) * X ^ 8 + C (102940) * X ^ 9 + C (2405) * X ^ 10 + C (59356) * X ^ 11 + C (107573) * X ^ 12 + C (-11087) * X ^ 13 + C (94138) * X ^ 14 + C (75840) * X ^ 15 + C (-7137) * X ^ 16 + C (100114) * X ^ 17 + C (33613) * X ^ 18 + C (4765) * X ^ 19 + C (64123) * X ^ 20 + C (5130) * X ^ 21 + C (12170) * X ^ 22 + C (28856) * X ^ 23 + C (-2160) * X ^ 24 + C (7728) * X ^ 25 + C (7360) * X ^ 26 + C (-1696) * X ^ 27
theorem DC001_12_ab_pre_eq :
    N_re_0_3 * N_re_1_1 - N_im_0_3 * N_im_1_1 =
      DC001_12_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_1, N_im_1_1, DC001_12_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_12_ab_pim_eq :
    N_re_0_3 * N_im_1_1 + N_im_0_3 * N_re_1_1 =
      DC001_12_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_1, N_im_1_1, DC001_12_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_12_ab_mul :
    N_entry_0_3 * N_entry_1_1 =
      ofLadj DC001_12_ab_pre DC001_12_ab_pim := by
  rw [N_entry_0_3, N_entry_1_1, ofLadj_mul,
    DC001_12_ab_pre_eq, DC001_12_ab_pim_eq]

theorem DC001_12_pre_eq :
    DC001_12_ab_pre * N_re_2_2 - DC001_12_ab_pim * N_im_2_2 =
      DC001_12_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_12_ab_pre, DC001_12_ab_pim, N_re_2_2, N_im_2_2, DC001_12_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_12_pim_eq :
    DC001_12_ab_pre * N_im_2_2 + DC001_12_ab_pim * N_re_2_2 =
      DC001_12_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_12_ab_pre, DC001_12_ab_pim, N_re_2_2, N_im_2_2, DC001_12_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_12_mul :
    N_entry_0_3 * N_entry_1_1 * N_entry_2_2 =
      ofLadj DC001_12_pre DC001_12_pim := by
  rw [DC001_12_ab_mul, N_entry_2_2, ofLadj_mul, DC001_12_pre_eq, DC001_12_pim_eq]

def DC001_13_ab_pre : Polynomial ℚ := C (72) + C (-72) * X + C (24) * X ^ 2 + C (124) * X ^ 3 + C (-152) * X ^ 4 + C (120) * X ^ 5 + C (100) * X ^ 6 + C (-208) * X ^ 7 + C (256) * X ^ 8 + C (-48) * X ^ 9 + C (-216) * X ^ 10 + C (216) * X ^ 11 + C (-144) * X ^ 12 + C (-72) * X ^ 13 + C (132) * X ^ 14 + C (-128) * X ^ 15 + C (24) * X ^ 16 + C (44) * X ^ 17 + C (-72) * X ^ 18
def DC001_13_ab_pim : Polynomial ℚ := C (84) + C (168) * X + C (24) * X ^ 2 + C (284) * X ^ 3 + C (256) * X ^ 4 + C (84) * X ^ 5 + C (496) * X ^ 6 + C (212) * X ^ 7 + C (216) * X ^ 8 + C (680) * X ^ 9 + C (156) * X ^ 10 + C (312) * X ^ 11 + C (468) * X ^ 12 + C (88) * X ^ 13 + C (292) * X ^ 14 + C (240) * X ^ 15 + C (40) * X ^ 16 + C (172) * X ^ 17 + C (84) * X ^ 18
def DC001_13_pre : Polynomial ℚ := C (-168) + C (-672) * X + C (-720) * X ^ 2 + C (-736) * X ^ 3 + C (-2572) * X ^ 4 + C (-1456) * X ^ 5 + C (-2446) * X ^ 6 + C (-4992) * X ^ 7 + C (-2006) * X ^ 8 + C (-5656) * X ^ 9 + C (-7368) * X ^ 10 + C (-2512) * X ^ 11 + C (-8778) * X ^ 12 + C (-7004) * X ^ 13 + C (-3498) * X ^ 14 + C (-9988) * X ^ 15 + C (-4948) * X ^ 16 + C (-4294) * X ^ 17 + C (-8520) * X ^ 18 + C (-2546) * X ^ 19 + C (-3744) * X ^ 20 + C (-4496) * X ^ 21 + C (-1016) * X ^ 22 + C (-2414) * X ^ 23 + C (-1676) * X ^ 24 + C (-318) * X ^ 25 + C (-952) * X ^ 26 + C (-336) * X ^ 27
def DC001_13_pim : Polynomial ℚ := C (144) + C (144) * X + C (-240) * X ^ 2 + C (770) * X ^ 3 + C (456) * X ^ 4 + C (-194) * X ^ 5 + C (2416) * X ^ 6 + C (576) * X ^ 7 + C (726) * X ^ 8 + C (4578) * X ^ 9 + C (-468) * X ^ 10 + C (2508) * X ^ 11 + C (5122) * X ^ 12 + C (-1162) * X ^ 13 + C (4664) * X ^ 14 + C (3710) * X ^ 15 + C (-858) * X ^ 16 + C (5260) * X ^ 17 + C (1280) * X ^ 18 + C (-166) * X ^ 19 + C (3566) * X ^ 20 + C (-54) * X ^ 21 + C (516) * X ^ 22 + C (1592) * X ^ 23 + C (-406) * X ^ 24 + C (342) * X ^ 25 + C (314) * X ^ 26 + C (-288) * X ^ 27
theorem DC001_13_ab_pre_eq :
    N_re_0_4 * N_re_1_2 - N_im_0_4 * N_im_1_2 =
      DC001_13_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_2, N_im_1_2, DC001_13_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_13_ab_pim_eq :
    N_re_0_4 * N_im_1_2 + N_im_0_4 * N_re_1_2 =
      DC001_13_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_2, N_im_1_2, DC001_13_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_13_ab_mul :
    N_entry_0_4 * N_entry_1_2 =
      ofLadj DC001_13_ab_pre DC001_13_ab_pim := by
  rw [N_entry_0_4, N_entry_1_2, ofLadj_mul,
    DC001_13_ab_pre_eq, DC001_13_ab_pim_eq]

theorem DC001_13_pre_eq :
    DC001_13_ab_pre * N_re_2_0 - DC001_13_ab_pim * N_im_2_0 =
      DC001_13_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_13_ab_pre, DC001_13_ab_pim, N_re_2_0, N_im_2_0, DC001_13_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_13_pim_eq :
    DC001_13_ab_pre * N_im_2_0 + DC001_13_ab_pim * N_re_2_0 =
      DC001_13_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_13_ab_pre, DC001_13_ab_pim, N_re_2_0, N_im_2_0, DC001_13_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_13_mul :
    N_entry_0_4 * N_entry_1_2 * N_entry_2_0 =
      ofLadj DC001_13_pre DC001_13_pim := by
  rw [DC001_13_ab_mul, N_entry_2_0, ofLadj_mul, DC001_13_pre_eq, DC001_13_pim_eq]

def DC001_14_ab_pre : Polynomial ℚ := C (12) + C (-24) * X + C (-18) * X ^ 2 + C (22) * X ^ 3 + C (-50) * X ^ 4 + C (34) * X ^ 5 + C (20) * X ^ 6 + C (-46) * X ^ 7 + C (70) * X ^ 8 + C (-20) * X ^ 9 + C (-64) * X ^ 10 + C (48) * X ^ 11 + C (-40) * X ^ 12 + C (-2) * X ^ 13 + C (48) * X ^ 14 + C (-14) * X ^ 15 + C (14) * X ^ 16 + C (28) * X ^ 17 + C (-18) * X ^ 18
def DC001_14_ab_pim : Polynomial ℚ := C (24) + C (48) * X + C (18) * X ^ 2 + C (102) * X ^ 3 + C (86) * X ^ 4 + C (58) * X ^ 5 + C (152) * X ^ 6 + C (94) * X ^ 7 + C (70) * X ^ 8 + C (196) * X ^ 9 + C (64) * X ^ 10 + C (108) * X ^ 11 + C (152) * X ^ 12 + C (50) * X ^ 13 + C (92) * X ^ 14 + C (78) * X ^ 15 + C (10) * X ^ 16 + C (44) * X ^ 17 + C (6) * X ^ 18
def DC001_14_pre : Polynomial ℚ := C (138) + C (-1212) * X + C (-984) * X ^ 2 + C (-400) * X ^ 3 + C (-4460) * X ^ 4 + C (-740) * X ^ 5 + C (-2558) * X ^ 6 + C (-7662) * X ^ 7 + C (458) * X ^ 8 + C (-7348) * X ^ 9 + C (-10454) * X ^ 10 + C (150) * X ^ 11 + C (-12644) * X ^ 12 + C (-8286) * X ^ 13 + C (-856) * X ^ 14 + C (-13772) * X ^ 15 + C (-4118) * X ^ 16 + C (-2540) * X ^ 17 + C (-11466) * X ^ 18 + C (-1288) * X ^ 19 + C (-3634) * X ^ 20 + C (-5712) * X ^ 21 + C (302) * X ^ 22 + C (-2310) * X ^ 23 + C (-1712) * X ^ 24 + C (426) * X ^ 25 + C (-896) * X ^ 26 + C (-240) * X ^ 27
def DC001_14_pim : Polynomial ℚ := C (666) + C (1176) * X + C (138) * X ^ 2 + C (3470) * X ^ 3 + C (2968) * X ^ 4 + C (1682) * X ^ 5 + C (8402) * X ^ 6 + C (4080) * X ^ 7 + C (4790) * X ^ 8 + C (14078) * X ^ 9 + C (3032) * X ^ 10 + C (9844) * X ^ 11 + C (15296) * X ^ 12 + C (2600) * X ^ 13 + C (14106) * X ^ 14 + C (12026) * X ^ 15 + C (2398) * X ^ 16 + C (13792) * X ^ 17 + C (6008) * X ^ 18 + C (2550) * X ^ 19 + C (8904) * X ^ 20 + C (2216) * X ^ 21 + C (2492) * X ^ 22 + C (4284) * X ^ 23 + C (284) * X ^ 24 + C (1088) * X ^ 25 + C (922) * X ^ 26 + C (-270) * X ^ 27
theorem DC001_14_ab_pre_eq :
    N_re_0_5 * N_re_1_0 - N_im_0_5 * N_im_1_0 =
      DC001_14_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_0, N_im_1_0, DC001_14_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_14_ab_pim_eq :
    N_re_0_5 * N_im_1_0 + N_im_0_5 * N_re_1_0 =
      DC001_14_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_0, N_im_1_0, DC001_14_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_14_ab_mul :
    N_entry_0_5 * N_entry_1_0 =
      ofLadj DC001_14_ab_pre DC001_14_ab_pim := by
  rw [N_entry_0_5, N_entry_1_0, ofLadj_mul,
    DC001_14_ab_pre_eq, DC001_14_ab_pim_eq]

theorem DC001_14_pre_eq :
    DC001_14_ab_pre * N_re_2_1 - DC001_14_ab_pim * N_im_2_1 =
      DC001_14_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_14_ab_pre, DC001_14_ab_pim, N_re_2_1, N_im_2_1, DC001_14_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_14_pim_eq :
    DC001_14_ab_pre * N_im_2_1 + DC001_14_ab_pim * N_re_2_1 =
      DC001_14_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_14_ab_pre, DC001_14_ab_pim, N_re_2_1, N_im_2_1, DC001_14_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_14_mul :
    N_entry_0_5 * N_entry_1_0 * N_entry_2_1 =
      ofLadj DC001_14_pre DC001_14_pim := by
  rw [DC001_14_ab_mul, N_entry_2_1, ofLadj_mul, DC001_14_pre_eq, DC001_14_pim_eq]

def DC001_15_ab_pre : Polynomial ℚ := C (133) + C (-228) * X + C (-59) * X ^ 2 + C (158) * X ^ 3 + C (-507) * X ^ 4 + C (127) * X ^ 5 + C (93) * X ^ 6 + C (-583) * X ^ 7 + C (525) * X ^ 8 + C (-156) * X ^ 9 + C (-504) * X ^ 10 + C (526) * X ^ 11 + C (-276) * X ^ 12 + C (-97) * X ^ 13 + C (367) * X ^ 14 + C (-242) * X ^ 15 + C (81) * X ^ 16 + C (115) * X ^ 17 + C (-166) * X ^ 18
def DC001_15_ab_pim : Polynomial ℚ := C (209) + C (418) * X + C (119) * X ^ 2 + C (758) * X ^ 3 + C (743) * X ^ 4 + C (423) * X ^ 5 + C (1417) * X ^ 6 + C (825) * X ^ 7 + C (829) * X ^ 8 + C (1906) * X ^ 9 + C (672) * X ^ 10 + C (982) * X ^ 11 + C (1292) * X ^ 12 + C (357) * X ^ 13 + C (795) * X ^ 14 + C (626) * X ^ 15 + C (127) * X ^ 16 + C (415) * X ^ 17 + C (188) * X ^ 18
def DC001_15_pre : Polynomial ℚ := C (1900) + C (-11020) * X + C (-5715) * X ^ 2 + C (-2584) * X ^ 3 + C (-38678) * X ^ 4 + C (-8173) * X ^ 5 + C (-22967) * X ^ 6 + C (-73347) * X ^ 7 + C (-594) * X ^ 8 + C (-69529) * X ^ 9 + C (-98254) * X ^ 10 + C (-746) * X ^ 11 + C (-115880) * X ^ 12 + C (-80161) * X ^ 13 + C (-11973) * X ^ 14 + C (-130702) * X ^ 15 + C (-40926) * X ^ 16 + C (-30667) * X ^ 17 + C (-105598) * X ^ 18 + C (-14056) * X ^ 19 + C (-34794) * X ^ 20 + C (-52654) * X ^ 21 + C (-1216) * X ^ 22 + C (-24008) * X ^ 23 + C (-18447) * X ^ 24 + C (-93) * X ^ 25 + C (-9565) * X ^ 26 + C (-4535) * X ^ 27
def DC001_15_pim : Polynomial ℚ := C (5985) + C (10488) * X + C (537) * X ^ 2 + C (28521) * X ^ 3 + C (24124) * X ^ 4 + C (9915) * X ^ 5 + C (71895) * X ^ 6 + C (30950) * X ^ 7 + C (41022) * X ^ 8 + C (125482) * X ^ 9 + C (26499) * X ^ 10 + C (86834) * X ^ 11 + C (136483) * X ^ 12 + C (20156) * X ^ 13 + C (124058) * X ^ 14 + C (105695) * X ^ 15 + C (21439) * X ^ 16 + C (123864) * X ^ 17 + C (56329) * X ^ 18 + C (22598) * X ^ 19 + C (77727) * X ^ 20 + C (17489) * X ^ 21 + C (19990) * X ^ 22 + C (34659) * X ^ 23 + C (1716) * X ^ 24 + C (9419) * X ^ 25 + C (8520) * X ^ 26 + C (-1495) * X ^ 27
theorem DC001_15_ab_pre_eq :
    N_re_0_3 * N_re_1_2 - N_im_0_3 * N_im_1_2 =
      DC001_15_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_2, N_im_1_2, DC001_15_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_15_ab_pim_eq :
    N_re_0_3 * N_im_1_2 + N_im_0_3 * N_re_1_2 =
      DC001_15_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_2, N_im_1_2, DC001_15_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_15_ab_mul :
    N_entry_0_3 * N_entry_1_2 =
      ofLadj DC001_15_ab_pre DC001_15_ab_pim := by
  rw [N_entry_0_3, N_entry_1_2, ofLadj_mul,
    DC001_15_ab_pre_eq, DC001_15_ab_pim_eq]

theorem DC001_15_pre_eq :
    DC001_15_ab_pre * N_re_2_1 - DC001_15_ab_pim * N_im_2_1 =
      DC001_15_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_15_ab_pre, DC001_15_ab_pim, N_re_2_1, N_im_2_1, DC001_15_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_15_pim_eq :
    DC001_15_ab_pre * N_im_2_1 + DC001_15_ab_pim * N_re_2_1 =
      DC001_15_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_15_ab_pre, DC001_15_ab_pim, N_re_2_1, N_im_2_1, DC001_15_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_15_mul :
    N_entry_0_3 * N_entry_1_2 * N_entry_2_1 =
      ofLadj DC001_15_pre DC001_15_pim := by
  rw [DC001_15_ab_mul, N_entry_2_1, ofLadj_mul, DC001_15_pre_eq, DC001_15_pim_eq]

def DC001_15_spre : Polynomial ℚ := C (-1900) + C (11020) * X + C (5715) * X ^ 2 + C (2584) * X ^ 3 + C (38678) * X ^ 4 + C (8173) * X ^ 5 + C (22967) * X ^ 6 + C (73347) * X ^ 7 + C (594) * X ^ 8 + C (69529) * X ^ 9 + C (98254) * X ^ 10 + C (746) * X ^ 11 + C (115880) * X ^ 12 + C (80161) * X ^ 13 + C (11973) * X ^ 14 + C (130702) * X ^ 15 + C (40926) * X ^ 16 + C (30667) * X ^ 17 + C (105598) * X ^ 18 + C (14056) * X ^ 19 + C (34794) * X ^ 20 + C (52654) * X ^ 21 + C (1216) * X ^ 22 + C (24008) * X ^ 23 + C (18447) * X ^ 24 + C (93) * X ^ 25 + C (9565) * X ^ 26 + C (4535) * X ^ 27
def DC001_15_spim : Polynomial ℚ := C (-5985) + C (-10488) * X + C (-537) * X ^ 2 + C (-28521) * X ^ 3 + C (-24124) * X ^ 4 + C (-9915) * X ^ 5 + C (-71895) * X ^ 6 + C (-30950) * X ^ 7 + C (-41022) * X ^ 8 + C (-125482) * X ^ 9 + C (-26499) * X ^ 10 + C (-86834) * X ^ 11 + C (-136483) * X ^ 12 + C (-20156) * X ^ 13 + C (-124058) * X ^ 14 + C (-105695) * X ^ 15 + C (-21439) * X ^ 16 + C (-123864) * X ^ 17 + C (-56329) * X ^ 18 + C (-22598) * X ^ 19 + C (-77727) * X ^ 20 + C (-17489) * X ^ 21 + C (-19990) * X ^ 22 + C (-34659) * X ^ 23 + C (-1716) * X ^ 24 + C (-9419) * X ^ 25 + C (-8520) * X ^ 26 + C (1495) * X ^ 27
theorem DC001_15_spre_eq : -DC001_15_pre = DC001_15_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_15_pre, DC001_15_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_15_spim_eq : -DC001_15_pim = DC001_15_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_15_pim, DC001_15_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_15_smul :
    -(N_entry_0_3 * N_entry_1_2 * N_entry_2_1) =
      ofLadj DC001_15_spre DC001_15_spim := by
  rw [DC001_15_mul, ofLadj_neg, DC001_15_spre_eq, DC001_15_spim_eq]

def DC001_16_ab_pre : Polynomial ℚ := C (12) + C (-24) * X + C (-18) * X ^ 2 + C (22) * X ^ 3 + C (-50) * X ^ 4 + C (34) * X ^ 5 + C (20) * X ^ 6 + C (-46) * X ^ 7 + C (70) * X ^ 8 + C (-20) * X ^ 9 + C (-64) * X ^ 10 + C (48) * X ^ 11 + C (-40) * X ^ 12 + C (-2) * X ^ 13 + C (48) * X ^ 14 + C (-14) * X ^ 15 + C (14) * X ^ 16 + C (28) * X ^ 17 + C (-18) * X ^ 18
def DC001_16_ab_pim : Polynomial ℚ := C (24) + C (48) * X + C (18) * X ^ 2 + C (102) * X ^ 3 + C (86) * X ^ 4 + C (58) * X ^ 5 + C (152) * X ^ 6 + C (94) * X ^ 7 + C (70) * X ^ 8 + C (196) * X ^ 9 + C (64) * X ^ 10 + C (108) * X ^ 11 + C (152) * X ^ 12 + C (50) * X ^ 13 + C (92) * X ^ 14 + C (78) * X ^ 15 + C (10) * X ^ 16 + C (44) * X ^ 17 + C (6) * X ^ 18
def DC001_16_pre : Polynomial ℚ := C (60) + C (-552) * X + C (-444) * X ^ 2 + C (-196) * X ^ 3 + C (-2092) * X ^ 4 + C (-420) * X ^ 5 + C (-1268) * X ^ 6 + C (-3636) * X ^ 7 + C (112) * X ^ 8 + C (-3468) * X ^ 9 + C (-4868) * X ^ 10 + C (76) * X ^ 11 + C (-5848) * X ^ 12 + C (-3848) * X ^ 13 + C (-416) * X ^ 14 + C (-6408) * X ^ 15 + C (-1904) * X ^ 16 + C (-1176) * X ^ 17 + C (-5284) * X ^ 18 + C (-492) * X ^ 19 + C (-1560) * X ^ 20 + C (-2520) * X ^ 21 + C (268) * X ^ 22 + C (-988) * X ^ 23 + C (-736) * X ^ 24 + C (232) * X ^ 25 + C (-420) * X ^ 26 + C (-120) * X ^ 27
def DC001_16_pim : Polynomial ℚ := C (300) + C (528) * X + C (72) * X ^ 2 + C (1632) * X ^ 3 + C (1456) * X ^ 4 + C (936) * X ^ 5 + C (4144) * X ^ 6 + C (2288) * X ^ 7 + C (2768) * X ^ 8 + C (7188) * X ^ 9 + C (2208) * X ^ 10 + C (5456) * X ^ 11 + C (8060) * X ^ 12 + C (2212) * X ^ 13 + C (7568) * X ^ 14 + C (6616) * X ^ 15 + C (2148) * X ^ 16 + C (7412) * X ^ 17 + C (3700) * X ^ 18 + C (1972) * X ^ 19 + C (4796) * X ^ 20 + C (1512) * X ^ 21 + C (1504) * X ^ 22 + C (2212) * X ^ 23 + C (252) * X ^ 24 + C (580) * X ^ 25 + C (460) * X ^ 26 + C (-120) * X ^ 27
theorem DC001_16_ab_pre_eq :
    N_re_0_4 * N_re_1_0 - N_im_0_4 * N_im_1_0 =
      DC001_16_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_0, N_im_1_0, DC001_16_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_16_ab_pim_eq :
    N_re_0_4 * N_im_1_0 + N_im_0_4 * N_re_1_0 =
      DC001_16_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_0, N_im_1_0, DC001_16_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_16_ab_mul :
    N_entry_0_4 * N_entry_1_0 =
      ofLadj DC001_16_ab_pre DC001_16_ab_pim := by
  rw [N_entry_0_4, N_entry_1_0, ofLadj_mul,
    DC001_16_ab_pre_eq, DC001_16_ab_pim_eq]

theorem DC001_16_pre_eq :
    DC001_16_ab_pre * N_re_2_2 - DC001_16_ab_pim * N_im_2_2 =
      DC001_16_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_16_ab_pre, DC001_16_ab_pim, N_re_2_2, N_im_2_2, DC001_16_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_16_pim_eq :
    DC001_16_ab_pre * N_im_2_2 + DC001_16_ab_pim * N_re_2_2 =
      DC001_16_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_16_ab_pre, DC001_16_ab_pim, N_re_2_2, N_im_2_2, DC001_16_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_16_mul :
    N_entry_0_4 * N_entry_1_0 * N_entry_2_2 =
      ofLadj DC001_16_pre DC001_16_pim := by
  rw [DC001_16_ab_mul, N_entry_2_2, ofLadj_mul, DC001_16_pre_eq, DC001_16_pim_eq]

def DC001_16_spre : Polynomial ℚ := C (-60) + C (552) * X + C (444) * X ^ 2 + C (196) * X ^ 3 + C (2092) * X ^ 4 + C (420) * X ^ 5 + C (1268) * X ^ 6 + C (3636) * X ^ 7 + C (-112) * X ^ 8 + C (3468) * X ^ 9 + C (4868) * X ^ 10 + C (-76) * X ^ 11 + C (5848) * X ^ 12 + C (3848) * X ^ 13 + C (416) * X ^ 14 + C (6408) * X ^ 15 + C (1904) * X ^ 16 + C (1176) * X ^ 17 + C (5284) * X ^ 18 + C (492) * X ^ 19 + C (1560) * X ^ 20 + C (2520) * X ^ 21 + C (-268) * X ^ 22 + C (988) * X ^ 23 + C (736) * X ^ 24 + C (-232) * X ^ 25 + C (420) * X ^ 26 + C (120) * X ^ 27
def DC001_16_spim : Polynomial ℚ := C (-300) + C (-528) * X + C (-72) * X ^ 2 + C (-1632) * X ^ 3 + C (-1456) * X ^ 4 + C (-936) * X ^ 5 + C (-4144) * X ^ 6 + C (-2288) * X ^ 7 + C (-2768) * X ^ 8 + C (-7188) * X ^ 9 + C (-2208) * X ^ 10 + C (-5456) * X ^ 11 + C (-8060) * X ^ 12 + C (-2212) * X ^ 13 + C (-7568) * X ^ 14 + C (-6616) * X ^ 15 + C (-2148) * X ^ 16 + C (-7412) * X ^ 17 + C (-3700) * X ^ 18 + C (-1972) * X ^ 19 + C (-4796) * X ^ 20 + C (-1512) * X ^ 21 + C (-1504) * X ^ 22 + C (-2212) * X ^ 23 + C (-252) * X ^ 24 + C (-580) * X ^ 25 + C (-460) * X ^ 26 + C (120) * X ^ 27
theorem DC001_16_spre_eq : -DC001_16_pre = DC001_16_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_16_pre, DC001_16_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_16_spim_eq : -DC001_16_pim = DC001_16_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_16_pim, DC001_16_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_16_smul :
    -(N_entry_0_4 * N_entry_1_0 * N_entry_2_2) =
      ofLadj DC001_16_spre DC001_16_spim := by
  rw [DC001_16_mul, ofLadj_neg, DC001_16_spre_eq, DC001_16_spim_eq]

def DC001_17_ab_pre : Polynomial ℚ := C (174) + C (-96) * X + C (102) * X ^ 2 + C (306) * X ^ 3 + C (-294) * X ^ 4 + C (248) * X ^ 5 + C (186) * X ^ 6 + C (-510) * X ^ 7 + C (514) * X ^ 8 + C (-106) * X ^ 9 + C (-440) * X ^ 10 + C (484) * X ^ 11 + C (-344) * X ^ 12 + C (-208) * X ^ 13 + C (208) * X ^ 14 + C (-384) * X ^ 15 + C (-32) * X ^ 16 + C (30) * X ^ 17 + C (-168) * X ^ 18
def DC001_17_ab_pim : Polynomial ℚ := C (138) + C (276) * X + C (-66) * X ^ 2 + C (400) * X ^ 3 + C (304) * X ^ 4 + C (-102) * X ^ 5 + C (786) * X ^ 6 + C (174) * X ^ 7 + C (176) * X ^ 8 + C (1172) * X ^ 9 + C (16) * X ^ 10 + C (360) * X ^ 11 + C (704) * X ^ 12 + C (-110) * X ^ 13 + C (420) * X ^ 14 + C (362) * X ^ 15 + C (-8) * X ^ 16 + C (320) * X ^ 17 + C (156) * X ^ 18
def DC001_17_pre : Polynomial ℚ := C (-276) + C (-1104) * X + C (-972) * X ^ 2 + C (-515) * X ^ 3 + C (-3726) * X ^ 4 + C (-856) * X ^ 5 + C (-2202) * X ^ 6 + C (-7100) * X ^ 7 + C (-243) * X ^ 8 + C (-7401) * X ^ 9 + C (-10683) * X ^ 10 + C (167) * X ^ 11 + C (-12908) * X ^ 12 + C (-8924) * X ^ 13 + C (-1289) * X ^ 14 + C (-15780) * X ^ 15 + C (-5153) * X ^ 16 + C (-4431) * X ^ 17 + C (-14262) * X ^ 18 + C (-1918) * X ^ 19 + C (-5417) * X ^ 20 + C (-7580) * X ^ 21 + C (-573) * X ^ 22 + C (-4251) * X ^ 23 + C (-2922) * X ^ 24 + C (-357) * X ^ 25 + C (-1856) * X ^ 26 + C (-624) * X ^ 27
def DC001_17_pim : Polynomial ℚ := C (348) + C (504) * X + C (-180) * X ^ 2 + C (1887) * X ^ 3 + C (1248) * X ^ 4 + C (-314) * X ^ 5 + C (4743) * X ^ 6 + C (561) * X ^ 7 + C (287) * X ^ 8 + C (8309) * X ^ 9 + C (-2635) * X ^ 10 + C (3396) * X ^ 11 + C (8752) * X ^ 12 + C (-5170) * X ^ 13 + C (7175) * X ^ 14 + C (4799) * X ^ 15 + C (-5333) * X ^ 16 + C (8224) * X ^ 17 + C (-302) * X ^ 18 + C (-2911) * X ^ 19 + C (5483) * X ^ 20 + C (-2184) * X ^ 21 + C (-420) * X ^ 22 + C (2211) * X ^ 23 + C (-1794) * X ^ 24 + C (210) * X ^ 25 + C (342) * X ^ 26 + C (-672) * X ^ 27
theorem DC001_17_ab_pre_eq :
    N_re_0_5 * N_re_1_1 - N_im_0_5 * N_im_1_1 =
      DC001_17_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_1, N_im_1_1, DC001_17_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_17_ab_pim_eq :
    N_re_0_5 * N_im_1_1 + N_im_0_5 * N_re_1_1 =
      DC001_17_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_1, N_im_1_1, DC001_17_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_17_ab_mul :
    N_entry_0_5 * N_entry_1_1 =
      ofLadj DC001_17_ab_pre DC001_17_ab_pim := by
  rw [N_entry_0_5, N_entry_1_1, ofLadj_mul,
    DC001_17_ab_pre_eq, DC001_17_ab_pim_eq]

theorem DC001_17_pre_eq :
    DC001_17_ab_pre * N_re_2_0 - DC001_17_ab_pim * N_im_2_0 =
      DC001_17_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_17_ab_pre, DC001_17_ab_pim, N_re_2_0, N_im_2_0, DC001_17_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_17_pim_eq :
    DC001_17_ab_pre * N_im_2_0 + DC001_17_ab_pim * N_re_2_0 =
      DC001_17_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_17_ab_pre, DC001_17_ab_pim, N_re_2_0, N_im_2_0, DC001_17_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC001_17_mul :
    N_entry_0_5 * N_entry_1_1 * N_entry_2_0 =
      ofLadj DC001_17_pre DC001_17_pim := by
  rw [DC001_17_ab_mul, N_entry_2_0, ofLadj_mul, DC001_17_pre_eq, DC001_17_pim_eq]

def DC001_17_spre : Polynomial ℚ := C (276) + C (1104) * X + C (972) * X ^ 2 + C (515) * X ^ 3 + C (3726) * X ^ 4 + C (856) * X ^ 5 + C (2202) * X ^ 6 + C (7100) * X ^ 7 + C (243) * X ^ 8 + C (7401) * X ^ 9 + C (10683) * X ^ 10 + C (-167) * X ^ 11 + C (12908) * X ^ 12 + C (8924) * X ^ 13 + C (1289) * X ^ 14 + C (15780) * X ^ 15 + C (5153) * X ^ 16 + C (4431) * X ^ 17 + C (14262) * X ^ 18 + C (1918) * X ^ 19 + C (5417) * X ^ 20 + C (7580) * X ^ 21 + C (573) * X ^ 22 + C (4251) * X ^ 23 + C (2922) * X ^ 24 + C (357) * X ^ 25 + C (1856) * X ^ 26 + C (624) * X ^ 27
def DC001_17_spim : Polynomial ℚ := C (-348) + C (-504) * X + C (180) * X ^ 2 + C (-1887) * X ^ 3 + C (-1248) * X ^ 4 + C (314) * X ^ 5 + C (-4743) * X ^ 6 + C (-561) * X ^ 7 + C (-287) * X ^ 8 + C (-8309) * X ^ 9 + C (2635) * X ^ 10 + C (-3396) * X ^ 11 + C (-8752) * X ^ 12 + C (5170) * X ^ 13 + C (-7175) * X ^ 14 + C (-4799) * X ^ 15 + C (5333) * X ^ 16 + C (-8224) * X ^ 17 + C (302) * X ^ 18 + C (2911) * X ^ 19 + C (-5483) * X ^ 20 + C (2184) * X ^ 21 + C (420) * X ^ 22 + C (-2211) * X ^ 23 + C (1794) * X ^ 24 + C (-210) * X ^ 25 + C (-342) * X ^ 26 + C (672) * X ^ 27
theorem DC001_17_spre_eq : -DC001_17_pre = DC001_17_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_17_pre, DC001_17_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_17_spim_eq : -DC001_17_pim = DC001_17_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_17_pim, DC001_17_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_17_smul :
    -(N_entry_0_5 * N_entry_1_1 * N_entry_2_0) =
      ofLadj DC001_17_spre DC001_17_spim := by
  rw [DC001_17_mul, ofLadj_neg, DC001_17_spre_eq, DC001_17_spim_eq]

@[expose] public def detCoeff_001 : Ki :=
  N_entry_0_0 * N_entry_1_1 * N_entry_2_5 + N_entry_0_1 * N_entry_1_2 * N_entry_2_3 + N_entry_0_2 * N_entry_1_0 * N_entry_2_4 + (-(N_entry_0_0 * N_entry_1_2 * N_entry_2_4)) + (-(N_entry_0_1 * N_entry_1_0 * N_entry_2_5)) + (-(N_entry_0_2 * N_entry_1_1 * N_entry_2_3)) + N_entry_0_0 * N_entry_1_4 * N_entry_2_2 + N_entry_0_1 * N_entry_1_5 * N_entry_2_0 + N_entry_0_2 * N_entry_1_3 * N_entry_2_1 + (-(N_entry_0_0 * N_entry_1_5 * N_entry_2_1)) + (-(N_entry_0_1 * N_entry_1_3 * N_entry_2_2)) + (-(N_entry_0_2 * N_entry_1_4 * N_entry_2_0)) + N_entry_0_3 * N_entry_1_1 * N_entry_2_2 + N_entry_0_4 * N_entry_1_2 * N_entry_2_0 + N_entry_0_5 * N_entry_1_0 * N_entry_2_1 + (-(N_entry_0_3 * N_entry_1_2 * N_entry_2_1)) + (-(N_entry_0_4 * N_entry_1_0 * N_entry_2_2)) + (-(N_entry_0_5 * N_entry_1_1 * N_entry_2_0))

theorem detCoeff_001_sum :
    detCoeff_001 = ofLadj (DC001_0_pre + DC001_1_pre + DC001_2_pre + DC001_3_spre + DC001_4_spre + DC001_5_spre + DC001_6_pre + DC001_7_pre + DC001_8_pre + DC001_9_spre + DC001_10_spre + DC001_11_spre + DC001_12_pre + DC001_13_pre + DC001_14_pre + DC001_15_spre + DC001_16_spre + DC001_17_spre) (DC001_0_pim + DC001_1_pim + DC001_2_pim + DC001_3_spim + DC001_4_spim + DC001_5_spim + DC001_6_pim + DC001_7_pim + DC001_8_pim + DC001_9_spim + DC001_10_spim + DC001_11_spim + DC001_12_pim + DC001_13_pim + DC001_14_pim + DC001_15_spim + DC001_16_spim + DC001_17_spim) := by
  simp only [detCoeff_001, DC001_0_mul, DC001_1_mul, DC001_2_mul, DC001_3_smul, DC001_4_smul, DC001_5_smul, DC001_6_mul, DC001_7_mul, DC001_8_mul, DC001_9_smul, DC001_10_smul, DC001_11_smul, DC001_12_mul, DC001_13_mul, DC001_14_mul, DC001_15_smul, DC001_16_smul, DC001_17_smul]
  simpa [add_assoc] using ofLadj_add18 DC001_0_pre DC001_0_pim DC001_1_pre DC001_1_pim DC001_2_pre DC001_2_pim DC001_3_spre DC001_3_spim DC001_4_spre DC001_4_spim DC001_5_spre DC001_5_spim DC001_6_pre DC001_6_pim DC001_7_pre DC001_7_pim DC001_8_pre DC001_8_pim DC001_9_spre DC001_9_spim DC001_10_spre DC001_10_spim DC001_11_spre DC001_11_spim DC001_12_pre DC001_12_pim DC001_13_pre DC001_13_pim DC001_14_pre DC001_14_pim DC001_15_spre DC001_15_spim DC001_16_spre DC001_16_spim DC001_17_spre DC001_17_spim

def DC001_s0_re : Polynomial ℚ := DC001_0_pre + DC001_1_pre + DC001_2_pre + DC001_3_spre + DC001_4_spre + DC001_5_spre
def DC001_s0_im : Polynomial ℚ := DC001_0_pim + DC001_1_pim + DC001_2_pim + DC001_3_spim + DC001_4_spim + DC001_5_spim
def DC001_g0_qre : Polynomial ℚ := C (-921) + C (-2567) * X + C ((-2547 / 2 : ℚ)) * X ^ 2 + C ((-10213 / 2 : ℚ)) * X ^ 3 + C ((-10845 / 2 : ℚ)) * X ^ 4 + C ((-5127 / 2 : ℚ)) * X ^ 5 + C (-7551) * X ^ 6 + C (-3254) * X ^ 7 + C (-3222) * X ^ 8 + C (-8958) * X ^ 9 + C (-2060) * X ^ 10 + C (-4869) * X ^ 11 + C (-5775) * X ^ 12 + C (-263) * X ^ 13 + C (-2712) * X ^ 14 + C (-382) * X ^ 15 + C (992) * X ^ 16 + C (-1087) * X ^ 17
def DC001_g0_qim : Polynomial ℚ := C (593) + C (-295) * X + C (877) * X ^ 2 + C (3811) * X ^ 3 + C (749) * X ^ 4 + C (4930) * X ^ 5 + C ((12199 / 2 : ℚ)) * X ^ 6 + C ((5191 / 2 : ℚ)) * X ^ 7 + C (9609) * X ^ 8 + C (4968) * X ^ 9 + C (3861) * X ^ 10 + C (9547) * X ^ 11 + C (3758) * X ^ 12 + C (5464) * X ^ 13 + C (6046) * X ^ 14 + C (2034) * X ^ 15 + C (3685) * X ^ 16 + C (1687) * X ^ 17
def DC001_g0_rre : Polynomial ℚ := C ((-309 / 2 : ℚ)) + C (-46) * X ^ 2 + C (-146) * X ^ 3 + C ((61 / 2 : ℚ)) * X ^ 4 + C ((-207 / 2 : ℚ)) * X ^ 5 + C ((-207 / 2 : ℚ)) * X ^ 6 + C ((61 / 2 : ℚ)) * X ^ 7 + C (-146) * X ^ 8 + C (-46) * X ^ 9
def DC001_g0_rim : Polynomial ℚ := C ((-147 / 2 : ℚ)) + C (-147) * X + C ((45 / 2 : ℚ)) * X ^ 2 + C ((-259 / 2 : ℚ)) * X ^ 3 + C ((-199 / 2 : ℚ)) * X ^ 4 + C (11) * X ^ 5 + C (-158) * X ^ 6 + C ((-95 / 2 : ℚ)) * X ^ 7 + C ((-35 / 2 : ℚ)) * X ^ 8 + C ((-339 / 2 : ℚ)) * X ^ 9
def DC001_g0a_qre : Polynomial ℚ := C (-175269) + C (161519) * X + C (-50433) * X ^ 2 + C (-102863) * X ^ 3 + C (149035) * X ^ 4 + C (-114904) * X ^ 5 + C (-20909) * X ^ 6 + C (85996) * X ^ 7 + C (-113827) * X ^ 8 + C (22436) * X ^ 9 + C (18268) * X ^ 10 + C (-64450) * X ^ 11 + C (26306) * X ^ 12 + C (-8827) * X ^ 13 + C (-24152) * X ^ 14 + C (11274) * X ^ 15 + C (-8022) * X ^ 16 + C (-5529) * X ^ 17
def DC001_g0a_rre : Polynomial ℚ := C (176039) + C (54373) * X ^ 2 + C (159243) * X ^ 3 + C (-32587) * X ^ 4 + C (113812) * X ^ 5 + C (113812) * X ^ 6 + C (-32587) * X ^ 7 + C (159243) * X ^ 8 + C (54373) * X ^ 9
theorem DC001_g0a_re :
    DC001_0_pre + DC001_1_pre + DC001_2_pre =
      DC001_g0a_rre + Phi11 * DC001_g0a_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_0_pre, DC001_1_pre, DC001_2_pre, DC001_g0a_rre, DC001_g0a_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
def DC001_g0b_qre : Polynomial ℚ := C (174348) + C (-164086) * X + C ((98319 / 2 : ℚ)) * X ^ 2 + C ((195513 / 2 : ℚ)) * X ^ 3 + C ((-308915 / 2 : ℚ)) * X ^ 4 + C ((224681 / 2 : ℚ)) * X ^ 5 + C (13358) * X ^ 6 + C (-89250) * X ^ 7 + C (110605) * X ^ 8 + C (-31394) * X ^ 9 + C (-20328) * X ^ 10 + C (59581) * X ^ 11 + C (-32081) * X ^ 12 + C (8564) * X ^ 13 + C (21440) * X ^ 14 + C (-11656) * X ^ 15 + C (9014) * X ^ 16 + C (4442) * X ^ 17
def DC001_g0b_rre : Polynomial ℚ := C ((-352387 / 2 : ℚ)) + C (-54419) * X ^ 2 + C (-159389) * X ^ 3 + C ((65235 / 2 : ℚ)) * X ^ 4 + C ((-227831 / 2 : ℚ)) * X ^ 5 + C ((-227831 / 2 : ℚ)) * X ^ 6 + C ((65235 / 2 : ℚ)) * X ^ 7 + C (-159389) * X ^ 8 + C (-54419) * X ^ 9
theorem DC001_g0b_re :
    DC001_3_spre + DC001_4_spre + DC001_5_spre =
      DC001_g0b_rre + Phi11 * DC001_g0b_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_3_spre, DC001_4_spre, DC001_5_spre, DC001_g0b_rre, DC001_g0b_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem DC001_g0_rre_split :
    DC001_g0a_rre + DC001_g0b_rre = DC001_g0_rre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_g0a_rre, DC001_g0b_rre, DC001_g0_rre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_g0_qre_split :
    DC001_g0a_qre + DC001_g0b_qre = DC001_g0_qre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_g0a_qre, DC001_g0b_qre, DC001_g0_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
def DC001_g0a_qim : Polynomial ℚ := C (-74489) + C (-76889) * X + C (174002) * X ^ 2 + C (-134191) * X ^ 3 + C (20668) * X ^ 4 + C (109225) * X ^ 5 + C (-126013) * X ^ 6 + C (78991) * X ^ 7 + C (37031) * X ^ 8 + C (-68783) * X ^ 9 + C (71412) * X ^ 10 + C (-5635) * X ^ 11 + C (-19197) * X ^ 12 + C (39025) * X ^ 13 + C (-10797) * X ^ 14 + C (449) * X ^ 15 + C (11493) * X ^ 16 + C (-2943) * X ^ 17
def DC001_g0a_rim : Polynomial ℚ := C (80456) + C (160912) * X + C (-25002) * X ^ 2 + C (138077) * X ^ 3 + C (110332) * X ^ 4 + C (-16323) * X ^ 5 + C (177235) * X ^ 6 + C (50580) * X ^ 7 + C (22835) * X ^ 8 + C (185914) * X ^ 9
theorem DC001_g0a_im :
    DC001_0_pim + DC001_1_pim + DC001_2_pim =
      DC001_g0a_rim + Phi11 * DC001_g0a_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_0_pim, DC001_1_pim, DC001_2_pim, DC001_g0a_rim, DC001_g0a_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
def DC001_g0b_qim : Polynomial ℚ := C (75082) + C (76594) * X + C (-173125) * X ^ 2 + C (138002) * X ^ 3 + C (-19919) * X ^ 4 + C (-104295) * X ^ 5 + C ((264225 / 2 : ℚ)) * X ^ 6 + C ((-152791 / 2 : ℚ)) * X ^ 7 + C (-27422) * X ^ 8 + C (73751) * X ^ 9 + C (-67551) * X ^ 10 + C (15182) * X ^ 11 + C (22955) * X ^ 12 + C (-33561) * X ^ 13 + C (16843) * X ^ 14 + C (1585) * X ^ 15 + C (-7808) * X ^ 16 + C (4630) * X ^ 17
def DC001_g0b_rim : Polynomial ℚ := C ((-161059 / 2 : ℚ)) + C (-161059) * X + C ((50049 / 2 : ℚ)) * X ^ 2 + C ((-276413 / 2 : ℚ)) * X ^ 3 + C ((-220863 / 2 : ℚ)) * X ^ 4 + C (16334) * X ^ 5 + C (-177393) * X ^ 6 + C ((-101255 / 2 : ℚ)) * X ^ 7 + C ((-45705 / 2 : ℚ)) * X ^ 8 + C ((-372167 / 2 : ℚ)) * X ^ 9
theorem DC001_g0b_im :
    DC001_3_spim + DC001_4_spim + DC001_5_spim =
      DC001_g0b_rim + Phi11 * DC001_g0b_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_3_spim, DC001_4_spim, DC001_5_spim, DC001_g0b_rim, DC001_g0b_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem DC001_g0_rim_split :
    DC001_g0a_rim + DC001_g0b_rim = DC001_g0_rim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_g0a_rim, DC001_g0b_rim, DC001_g0_rim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_g0_qim_split :
    DC001_g0a_qim + DC001_g0b_qim = DC001_g0_qim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_g0a_qim, DC001_g0b_qim, DC001_g0_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_g0_re :
    DC001_s0_re = DC001_g0_rre + Phi11 * DC001_g0_qre := by
  unfold DC001_s0_re
  calc
    DC001_0_pre + DC001_1_pre + DC001_2_pre + DC001_3_spre + DC001_4_spre + DC001_5_spre =
        (DC001_0_pre + DC001_1_pre + DC001_2_pre) + (DC001_3_spre + DC001_4_spre + DC001_5_spre) := by
      ring
    _ = (DC001_g0a_rre + Phi11 * DC001_g0a_qre) +
          (DC001_g0b_rre + Phi11 * DC001_g0b_qre) := by
      rw [DC001_g0a_re, DC001_g0b_re]
    _ = (DC001_g0a_rre + DC001_g0b_rre) +
          Phi11 * (DC001_g0a_qre + DC001_g0b_qre) := by
      ring
    _ = DC001_g0_rre + Phi11 * DC001_g0_qre := by
      rw [DC001_g0_rre_split, DC001_g0_qre_split]
theorem DC001_g0_im :
    DC001_s0_im = DC001_g0_rim + Phi11 * DC001_g0_qim := by
  unfold DC001_s0_im
  calc
    DC001_0_pim + DC001_1_pim + DC001_2_pim + DC001_3_spim + DC001_4_spim + DC001_5_spim =
        (DC001_0_pim + DC001_1_pim + DC001_2_pim) + (DC001_3_spim + DC001_4_spim + DC001_5_spim) := by
      ring
    _ = (DC001_g0a_rim + Phi11 * DC001_g0a_qim) +
          (DC001_g0b_rim + Phi11 * DC001_g0b_qim) := by
      rw [DC001_g0a_im, DC001_g0b_im]
    _ = (DC001_g0a_rim + DC001_g0b_rim) +
          Phi11 * (DC001_g0a_qim + DC001_g0b_qim) := by
      ring
    _ = DC001_g0_rim + Phi11 * DC001_g0_qim := by
      rw [DC001_g0_rim_split, DC001_g0_qim_split]

def DC001_s1_re : Polynomial ℚ := DC001_6_pre + DC001_7_pre + DC001_8_pre + DC001_9_spre + DC001_10_spre + DC001_11_spre
def DC001_s1_im : Polynomial ℚ := DC001_6_pim + DC001_7_pim + DC001_8_pim + DC001_9_spim + DC001_10_spim + DC001_11_spim
def DC001_g1_qre : Polynomial ℚ := C ((-381 / 2 : ℚ)) + C ((1345 / 2 : ℚ)) * X + C (-591) * X ^ 2 + C (1586) * X ^ 3 + C ((889 / 2 : ℚ)) * X ^ 4 + C (-933) * X ^ 5 + C ((2533 / 2 : ℚ)) * X ^ 6 + C ((-3677 / 2 : ℚ)) * X ^ 7 + C (-1225) * X ^ 8 + C (2308) * X ^ 9 + C (-1856) * X ^ 10 + C (1108) * X ^ 11 + C (1690) * X ^ 12 + C (-1404) * X ^ 13 + C (304) * X ^ 14 + C (-344) * X ^ 15 + C (-1596) * X ^ 16 + C (504) * X ^ 17
def DC001_g1_qim : Polynomial ℚ := C (-463) + C (-487) * X + C (-1834) * X ^ 2 + C ((-6939 / 2 : ℚ)) * X ^ 3 + C (-1884) * X ^ 4 + C (-4661) * X ^ 5 + C ((-8601 / 2 : ℚ)) * X ^ 6 + C (-2639) * X ^ 7 + C (-6833) * X ^ 8 + C (-3476) * X ^ 9 + C (-3408) * X ^ 10 + C (-6848) * X ^ 11 + C (-2744) * X ^ 12 + C (-3698) * X ^ 13 + C (-4157) * X ^ 14 + C (-1335) * X ^ 15 + C (-2316) * X ^ 16 + C (-1448) * X ^ 17
def DC001_g1_rre : Polynomial ℚ := C (319) + C ((193 / 2 : ℚ)) * X ^ 2 + C ((577 / 2 : ℚ)) * X ^ 3 + C ((-127 / 2 : ℚ)) * X ^ 4 + C (204) * X ^ 5 + C (204) * X ^ 6 + C ((-127 / 2 : ℚ)) * X ^ 7 + C ((577 / 2 : ℚ)) * X ^ 8 + C ((193 / 2 : ℚ)) * X ^ 9
def DC001_g1_rim : Polynomial ℚ := C ((293 / 2 : ℚ)) + C (293) * X + C ((-95 / 2 : ℚ)) * X ^ 2 + C (251) * X ^ 3 + C (199) * X ^ 4 + C (-29) * X ^ 5 + C (322) * X ^ 6 + C (94) * X ^ 7 + C (42) * X ^ 8 + C ((681 / 2 : ℚ)) * X ^ 9
def DC001_g1a_qre : Polynomial ℚ := C ((-350445 / 2 : ℚ)) + C ((331825 / 2 : ℚ)) * X + C (-49472) * X ^ 2 + C (-97531) * X ^ 3 + C ((311991 / 2 : ℚ)) * X ^ 4 + C (-112863) * X ^ 5 + C ((-23555 / 2 : ℚ)) * X ^ 6 + C ((179735 / 2 : ℚ)) * X ^ 7 + C (-110396) * X ^ 8 + C (33067) * X ^ 9 + C (19587) * X ^ 10 + C (-59567) * X ^ 11 + C (32133) * X ^ 12 + C (-9475) * X ^ 13 + C (-20986) * X ^ 14 + C (11576) * X ^ 15 + C (-9076) * X ^ 16 + C (-3904) * X ^ 17
def DC001_g1a_rre : Polynomial ℚ := C (177686) + C ((109719 / 2 : ℚ)) * X ^ 2 + C ((321379 / 2 : ℚ)) * X ^ 3 + C ((-65911 / 2 : ℚ)) * X ^ 4 + C (114798) * X ^ 5 + C (114798) * X ^ 6 + C ((-65911 / 2 : ℚ)) * X ^ 7 + C ((321379 / 2 : ℚ)) * X ^ 8 + C ((109719 / 2 : ℚ)) * X ^ 9
theorem DC001_g1a_re :
    DC001_6_pre + DC001_7_pre + DC001_8_pre =
      DC001_g1a_rre + Phi11 * DC001_g1a_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_6_pre, DC001_7_pre, DC001_8_pre, DC001_g1a_rre, DC001_g1a_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
def DC001_g1b_qre : Polynomial ℚ := C (175032) + C (-165240) * X + C (48881) * X ^ 2 + C (99117) * X ^ 3 + C (-155551) * X ^ 4 + C (111930) * X ^ 5 + C (13044) * X ^ 6 + C (-91706) * X ^ 7 + C (109171) * X ^ 8 + C (-30759) * X ^ 9 + C (-21443) * X ^ 10 + C (60675) * X ^ 11 + C (-30443) * X ^ 12 + C (8071) * X ^ 13 + C (21290) * X ^ 14 + C (-11920) * X ^ 15 + C (7480) * X ^ 16 + C (4408) * X ^ 17
def DC001_g1b_rre : Polynomial ℚ := C (-177367) + C (-54763) * X ^ 2 + C (-160401) * X ^ 3 + C (32892) * X ^ 4 + C (-114594) * X ^ 5 + C (-114594) * X ^ 6 + C (32892) * X ^ 7 + C (-160401) * X ^ 8 + C (-54763) * X ^ 9
theorem DC001_g1b_re :
    DC001_9_spre + DC001_10_spre + DC001_11_spre =
      DC001_g1b_rre + Phi11 * DC001_g1b_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_9_spre, DC001_10_spre, DC001_11_spre, DC001_g1b_rre, DC001_g1b_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem DC001_g1_rre_split :
    DC001_g1a_rre + DC001_g1b_rre = DC001_g1_rre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_g1a_rre, DC001_g1b_rre, DC001_g1_rre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_g1_qre_split :
    DC001_g1a_qre + DC001_g1b_qre = DC001_g1_qre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_g1a_qre, DC001_g1b_qre, DC001_g1_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
def DC001_g1a_qim : Polynomial ℚ := C (-75793) + C (-77113) * X + C (174087) * X ^ 2 + C ((-278429 / 2 : ℚ)) * X ^ 3 + C (20548) * X ^ 4 + C (104010) * X ^ 5 + C ((-266099 / 2 : ℚ)) * X ^ 6 + C (77479) * X ^ 7 + C (26077) * X ^ 8 + C (-73738) * X ^ 9 + C (67601) * X ^ 10 + C (-16312) * X ^ 11 + C (-21942) * X ^ 12 + C (33866) * X ^ 13 + C (-16795) * X ^ 14 + C (-437) * X ^ 15 + C (8112) * X ^ 16 + C (-4272) * X ^ 17
def DC001_g1a_rim : Polynomial ℚ := C ((162367 / 2 : ℚ)) + C (162367) * X + C ((-50593 / 2 : ℚ)) * X ^ 2 + C (139303) * X ^ 3 + C (111307) * X ^ 4 + C (-16511) * X ^ 5 + C (178878) * X ^ 6 + C (51060) * X ^ 7 + C (23064) * X ^ 8 + C ((375327 / 2 : ℚ)) * X ^ 9
theorem DC001_g1a_im :
    DC001_6_pim + DC001_7_pim + DC001_8_pim =
      DC001_g1a_rim + Phi11 * DC001_g1a_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_6_pim, DC001_7_pim, DC001_8_pim, DC001_g1a_rim, DC001_g1a_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
def DC001_g1b_qim : Polynomial ℚ := C (75330) + C (76626) * X + C (-175921) * X ^ 2 + C (135745) * X ^ 3 + C (-22432) * X ^ 4 + C (-108671) * X ^ 5 + C (128749) * X ^ 6 + C (-80118) * X ^ 7 + C (-32910) * X ^ 8 + C (70262) * X ^ 9 + C (-71009) * X ^ 10 + C (9464) * X ^ 11 + C (19198) * X ^ 12 + C (-37564) * X ^ 13 + C (12638) * X ^ 14 + C (-898) * X ^ 15 + C (-10428) * X ^ 16 + C (2824) * X ^ 17
def DC001_g1b_rim : Polynomial ℚ := C (-81037) + C (-162074) * X + C (25249) * X ^ 2 + C (-139052) * X ^ 3 + C (-111108) * X ^ 4 + C (16482) * X ^ 5 + C (-178556) * X ^ 6 + C (-50966) * X ^ 7 + C (-23022) * X ^ 8 + C (-187323) * X ^ 9
theorem DC001_g1b_im :
    DC001_9_spim + DC001_10_spim + DC001_11_spim =
      DC001_g1b_rim + Phi11 * DC001_g1b_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_9_spim, DC001_10_spim, DC001_11_spim, DC001_g1b_rim, DC001_g1b_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem DC001_g1_rim_split :
    DC001_g1a_rim + DC001_g1b_rim = DC001_g1_rim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_g1a_rim, DC001_g1b_rim, DC001_g1_rim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_g1_qim_split :
    DC001_g1a_qim + DC001_g1b_qim = DC001_g1_qim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_g1a_qim, DC001_g1b_qim, DC001_g1_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_g1_re :
    DC001_s1_re = DC001_g1_rre + Phi11 * DC001_g1_qre := by
  unfold DC001_s1_re
  calc
    DC001_6_pre + DC001_7_pre + DC001_8_pre + DC001_9_spre + DC001_10_spre + DC001_11_spre =
        (DC001_6_pre + DC001_7_pre + DC001_8_pre) + (DC001_9_spre + DC001_10_spre + DC001_11_spre) := by
      ring
    _ = (DC001_g1a_rre + Phi11 * DC001_g1a_qre) +
          (DC001_g1b_rre + Phi11 * DC001_g1b_qre) := by
      rw [DC001_g1a_re, DC001_g1b_re]
    _ = (DC001_g1a_rre + DC001_g1b_rre) +
          Phi11 * (DC001_g1a_qre + DC001_g1b_qre) := by
      ring
    _ = DC001_g1_rre + Phi11 * DC001_g1_qre := by
      rw [DC001_g1_rre_split, DC001_g1_qre_split]
theorem DC001_g1_im :
    DC001_s1_im = DC001_g1_rim + Phi11 * DC001_g1_qim := by
  unfold DC001_s1_im
  calc
    DC001_6_pim + DC001_7_pim + DC001_8_pim + DC001_9_spim + DC001_10_spim + DC001_11_spim =
        (DC001_6_pim + DC001_7_pim + DC001_8_pim) + (DC001_9_spim + DC001_10_spim + DC001_11_spim) := by
      ring
    _ = (DC001_g1a_rim + Phi11 * DC001_g1a_qim) +
          (DC001_g1b_rim + Phi11 * DC001_g1b_qim) := by
      rw [DC001_g1a_im, DC001_g1b_im]
    _ = (DC001_g1a_rim + DC001_g1b_rim) +
          Phi11 * (DC001_g1a_qim + DC001_g1b_qim) := by
      ring
    _ = DC001_g1_rim + Phi11 * DC001_g1_qim := by
      rw [DC001_g1_rim_split, DC001_g1_qim_split]

def DC001_s2_re : Polynomial ℚ := DC001_12_pre + DC001_13_pre + DC001_14_pre + DC001_15_spre + DC001_16_spre + DC001_17_spre
def DC001_s2_im : Polynomial ℚ := DC001_12_pim + DC001_13_pim + DC001_14_pim + DC001_15_spim + DC001_16_spim + DC001_17_spim
def DC001_g2_qre : Polynomial ℚ := C (1126) + C (1990) * X + C (1196) * X ^ 2 + C (2773) * X ^ 3 + C (3811) * X ^ 4 + C (1668) * X ^ 5 + C (4088) * X ^ 6 + C (2692) * X ^ 7 + C (2011) * X ^ 8 + C (4222) * X ^ 9 + C (1464) * X ^ 10 + C (1298) * X ^ 11 + C (1541) * X ^ 12 + C (-171) * X ^ 13 + C (647) * X ^ 14 + C (-393) * X ^ 15 + C (-102) * X ^ 16 + C (375) * X ^ 17
def DC001_g2_qim : Polynomial ℚ := C (-754) + C (-220) * X + C (-351) * X ^ 2 + C (-2359) * X ^ 3 + C (-684) * X ^ 4 + C (-2442) * X ^ 5 + C (-3484) * X ^ 6 + C (-1508) * X ^ 7 + C (-4316) * X ^ 8 + C (-3097) * X ^ 9 + C (-1888) * X ^ 10 + C (-3629) * X ^ 11 + C (-1546) * X ^ 12 + C (-1894) * X ^ 13 + C (-1405) * X ^ 14 + C (-325) * X ^ 15 + C (-759) * X ^ 16 + C (33) * X ^ 17
def DC001_g2_rre : Polynomial ℚ := C (-161) + C (-49) * X ^ 2 + C (-139) * X ^ 3 + C (32) * X ^ 4 + C (-99) * X ^ 5 + C (-99) * X ^ 6 + C (32) * X ^ 7 + C (-139) * X ^ 8 + C (-49) * X ^ 9
def DC001_g2_rim : Polynomial ℚ := C (-72) + C (-144) * X + C (24) * X ^ 2 + C (-120) * X ^ 3 + C (-97) * X ^ 4 + C (17) * X ^ 5 + C (-161) * X ^ 6 + C (-47) * X ^ 7 + C (-24) * X ^ 8 + C (-168) * X ^ 9
def DC001_g2a_qre : Polynomial ℚ := C (-173409) + C (163849) * X + C (-47649) * X ^ 2 + C (-98369) * X ^ 3 + C (154646) * X ^ 4 + C (-109801) * X ^ 5 + C (-12900) * X ^ 6 + C (91562) * X ^ 7 + C (-106667) * X ^ 8 + C (29527) * X ^ 9 + C (22447) * X ^ 10 + C (-59935) * X ^ 11 + C (29267) * X ^ 12 + C (-7313) * X ^ 13 + C (-21240) * X ^ 14 + C (11230) * X ^ 15 + C (-6664) * X ^ 16 + C (-4904) * X ^ 17
def DC001_g2a_rre : Polynomial ℚ := C (176058) + C (54341) * X ^ 2 + C (159229) * X ^ 3 + C (-32636) * X ^ 4 + C (113749) * X ^ 5 + C (113749) * X ^ 6 + C (-32636) * X ^ 7 + C (159229) * X ^ 8 + C (54341) * X ^ 9
theorem DC001_g2a_re :
    DC001_12_pre + DC001_13_pre + DC001_14_pre =
      DC001_g2a_rre + Phi11 * DC001_g2a_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_12_pre, DC001_13_pre, DC001_14_pre, DC001_g2a_rre, DC001_g2a_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
def DC001_g2b_qre : Polynomial ℚ := C (174535) + C (-161859) * X + C (48845) * X ^ 2 + C (101142) * X ^ 3 + C (-150835) * X ^ 4 + C (111469) * X ^ 5 + C (16988) * X ^ 6 + C (-88870) * X ^ 7 + C (108678) * X ^ 8 + C (-25305) * X ^ 9 + C (-20983) * X ^ 10 + C (61233) * X ^ 11 + C (-27726) * X ^ 12 + C (7142) * X ^ 13 + C (21887) * X ^ 14 + C (-11623) * X ^ 15 + C (6562) * X ^ 16 + C (5279) * X ^ 17
def DC001_g2b_rre : Polynomial ℚ := C (-176219) + C (-54390) * X ^ 2 + C (-159368) * X ^ 3 + C (32668) * X ^ 4 + C (-113848) * X ^ 5 + C (-113848) * X ^ 6 + C (32668) * X ^ 7 + C (-159368) * X ^ 8 + C (-54390) * X ^ 9
theorem DC001_g2b_re :
    DC001_15_spre + DC001_16_spre + DC001_17_spre =
      DC001_g2b_rre + Phi11 * DC001_g2b_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_15_spre, DC001_16_spre, DC001_17_spre, DC001_g2b_rre, DC001_g2b_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem DC001_g2_rre_split :
    DC001_g2a_rre + DC001_g2b_rre = DC001_g2_rre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_g2a_rre, DC001_g2b_rre, DC001_g2_rre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_g2_qre_split :
    DC001_g2a_qre + DC001_g2b_qre = DC001_g2_qre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_g2a_qre, DC001_g2b_qre, DC001_g2_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
def DC001_g2a_qim : Polynomial ℚ := C (-74625) + C (-75837) * X + C (174654) * X ^ 2 + C (-133997) * X ^ 3 + C (21894) * X ^ 4 + C (108023) * X ^ 5 + C (-127017) * X ^ 6 + C (78265) * X ^ 7 + C (33752) * X ^ 8 + C (-69444) * X ^ 9 + C (69301) * X ^ 10 + C (-7886) * X ^ 11 + C (-19554) * X ^ 12 + C (37014) * X ^ 13 + C (-11440) * X ^ 14 + C (562) * X ^ 15 + C (10850) * X ^ 16 + C (-2254) * X ^ 17
def DC001_g2a_rim : Polynomial ℚ := C (80432) + C (160864) * X + C (-25064) * X ^ 2 + C (138041) * X ^ 3 + C (110274) * X ^ 4 + C (-16368) * X ^ 5 + C (177232) * X ^ 6 + C (50590) * X ^ 7 + C (22823) * X ^ 8 + C (185928) * X ^ 9
theorem DC001_g2a_im :
    DC001_12_pim + DC001_13_pim + DC001_14_pim =
      DC001_g2a_rim + Phi11 * DC001_g2a_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_12_pim, DC001_13_pim, DC001_14_pim, DC001_g2a_rim, DC001_g2a_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
def DC001_g2b_qim : Polynomial ℚ := C (73871) + C (75617) * X + C (-175005) * X ^ 2 + C (131638) * X ^ 3 + C (-22578) * X ^ 4 + C (-110465) * X ^ 5 + C (123533) * X ^ 6 + C (-79773) * X ^ 7 + C (-38068) * X ^ 8 + C (66347) * X ^ 9 + C (-71189) * X ^ 10 + C (4257) * X ^ 11 + C (18008) * X ^ 12 + C (-38908) * X ^ 13 + C (10035) * X ^ 14 + C (-887) * X ^ 15 + C (-11609) * X ^ 16 + C (2287) * X ^ 17
def DC001_g2b_rim : Polynomial ℚ := C (-80504) + C (-161008) * X + C (25088) * X ^ 2 + C (-138161) * X ^ 3 + C (-110371) * X ^ 4 + C (16385) * X ^ 5 + C (-177393) * X ^ 6 + C (-50637) * X ^ 7 + C (-22847) * X ^ 8 + C (-186096) * X ^ 9
theorem DC001_g2b_im :
    DC001_15_spim + DC001_16_spim + DC001_17_spim =
      DC001_g2b_rim + Phi11 * DC001_g2b_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_15_spim, DC001_16_spim, DC001_17_spim, DC001_g2b_rim, DC001_g2b_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem DC001_g2_rim_split :
    DC001_g2a_rim + DC001_g2b_rim = DC001_g2_rim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_g2a_rim, DC001_g2b_rim, DC001_g2_rim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_g2_qim_split :
    DC001_g2a_qim + DC001_g2b_qim = DC001_g2_qim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC001_g2a_qim, DC001_g2b_qim, DC001_g2_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC001_g2_re :
    DC001_s2_re = DC001_g2_rre + Phi11 * DC001_g2_qre := by
  unfold DC001_s2_re
  calc
    DC001_12_pre + DC001_13_pre + DC001_14_pre + DC001_15_spre + DC001_16_spre + DC001_17_spre =
        (DC001_12_pre + DC001_13_pre + DC001_14_pre) + (DC001_15_spre + DC001_16_spre + DC001_17_spre) := by
      ring
    _ = (DC001_g2a_rre + Phi11 * DC001_g2a_qre) +
          (DC001_g2b_rre + Phi11 * DC001_g2b_qre) := by
      rw [DC001_g2a_re, DC001_g2b_re]
    _ = (DC001_g2a_rre + DC001_g2b_rre) +
          Phi11 * (DC001_g2a_qre + DC001_g2b_qre) := by
      ring
    _ = DC001_g2_rre + Phi11 * DC001_g2_qre := by
      rw [DC001_g2_rre_split, DC001_g2_qre_split]
theorem DC001_g2_im :
    DC001_s2_im = DC001_g2_rim + Phi11 * DC001_g2_qim := by
  unfold DC001_s2_im
  calc
    DC001_12_pim + DC001_13_pim + DC001_14_pim + DC001_15_spim + DC001_16_spim + DC001_17_spim =
        (DC001_12_pim + DC001_13_pim + DC001_14_pim) + (DC001_15_spim + DC001_16_spim + DC001_17_spim) := by
      ring
    _ = (DC001_g2a_rim + Phi11 * DC001_g2a_qim) +
          (DC001_g2b_rim + Phi11 * DC001_g2b_qim) := by
      rw [DC001_g2a_im, DC001_g2b_im]
    _ = (DC001_g2a_rim + DC001_g2b_rim) +
          Phi11 * (DC001_g2a_qim + DC001_g2b_qim) := by
      ring
    _ = DC001_g2_rim + Phi11 * DC001_g2_qim := by
      rw [DC001_g2_rim_split, DC001_g2_qim_split]
def DC001_g3_qre : Polynomial ℚ := (0 : Polynomial ℚ)
def DC001_g3_qim : Polynomial ℚ := (0 : Polynomial ℚ)
theorem DC001_rem_re :
    DC001_g0_rre + DC001_g1_rre + DC001_g2_rre =
      Fplus_re_001 + Phi11 * DC001_g3_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_g0_rre, DC001_g1_rre, DC001_g2_rre, Fplus_re_001, DC001_g3_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring
theorem DC001_rem_im :
    DC001_g0_rim + DC001_g1_rim + DC001_g2_rim =
      Fplus_im_001 + Phi11 * DC001_g3_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC001_g0_rim, DC001_g1_rim, DC001_g2_rim, Fplus_im_001, DC001_g3_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring

theorem DC001_sum18_re :
    DC001_0_pre + DC001_1_pre + DC001_2_pre + DC001_3_spre + DC001_4_spre + DC001_5_spre + DC001_6_pre + DC001_7_pre + DC001_8_pre + DC001_9_spre + DC001_10_spre + DC001_11_spre + DC001_12_pre + DC001_13_pre + DC001_14_pre + DC001_15_spre + DC001_16_spre + DC001_17_spre = DC001_s0_re + DC001_s1_re + DC001_s2_re := by
  unfold DC001_s0_re DC001_s1_re DC001_s2_re
  ring
theorem DC001_sum18_im :
    DC001_0_pim + DC001_1_pim + DC001_2_pim + DC001_3_spim + DC001_4_spim + DC001_5_spim + DC001_6_pim + DC001_7_pim + DC001_8_pim + DC001_9_spim + DC001_10_spim + DC001_11_spim + DC001_12_pim + DC001_13_pim + DC001_14_pim + DC001_15_spim + DC001_16_spim + DC001_17_spim = DC001_s0_im + DC001_s1_im + DC001_s2_im := by
  unfold DC001_s0_im DC001_s1_im DC001_s2_im
  ring

theorem detCoeff_001_sum_poly_re :
    DC001_0_pre + DC001_1_pre + DC001_2_pre + DC001_3_spre + DC001_4_spre + DC001_5_spre + DC001_6_pre + DC001_7_pre + DC001_8_pre + DC001_9_spre + DC001_10_spre + DC001_11_spre + DC001_12_pre + DC001_13_pre + DC001_14_pre + DC001_15_spre + DC001_16_spre + DC001_17_spre =
      Fplus_re_001 + Phi11 * (DC001_g0_qre + DC001_g1_qre + DC001_g2_qre + DC001_g3_qre) := by
  calc
    DC001_0_pre + DC001_1_pre + DC001_2_pre + DC001_3_spre + DC001_4_spre + DC001_5_spre + DC001_6_pre + DC001_7_pre + DC001_8_pre + DC001_9_spre + DC001_10_spre + DC001_11_spre + DC001_12_pre + DC001_13_pre + DC001_14_pre + DC001_15_spre + DC001_16_spre + DC001_17_spre = DC001_s0_re + DC001_s1_re + DC001_s2_re :=
      DC001_sum18_re
    _ = (DC001_g0_rre + Phi11 * DC001_g0_qre) +
          (DC001_g1_rre + Phi11 * DC001_g1_qre) +
            (DC001_g2_rre + Phi11 * DC001_g2_qre) := by
      rw [DC001_g0_re, DC001_g1_re, DC001_g2_re]
    _ = (DC001_g0_rre + DC001_g1_rre + DC001_g2_rre) +
          Phi11 * (DC001_g0_qre + DC001_g1_qre + DC001_g2_qre) := by
      ring
    _ = (Fplus_re_001 + Phi11 * DC001_g3_qre) +
          Phi11 * (DC001_g0_qre + DC001_g1_qre + DC001_g2_qre) := by
      rw [DC001_rem_re]
    _ = Fplus_re_001 + Phi11 * (DC001_g0_qre + DC001_g1_qre + DC001_g2_qre + DC001_g3_qre) := by
      ring

theorem detCoeff_001_sum_poly_im :
    DC001_0_pim + DC001_1_pim + DC001_2_pim + DC001_3_spim + DC001_4_spim + DC001_5_spim + DC001_6_pim + DC001_7_pim + DC001_8_pim + DC001_9_spim + DC001_10_spim + DC001_11_spim + DC001_12_pim + DC001_13_pim + DC001_14_pim + DC001_15_spim + DC001_16_spim + DC001_17_spim =
      Fplus_im_001 + Phi11 * (DC001_g0_qim + DC001_g1_qim + DC001_g2_qim + DC001_g3_qim) := by
  calc
    DC001_0_pim + DC001_1_pim + DC001_2_pim + DC001_3_spim + DC001_4_spim + DC001_5_spim + DC001_6_pim + DC001_7_pim + DC001_8_pim + DC001_9_spim + DC001_10_spim + DC001_11_spim + DC001_12_pim + DC001_13_pim + DC001_14_pim + DC001_15_spim + DC001_16_spim + DC001_17_spim = DC001_s0_im + DC001_s1_im + DC001_s2_im :=
      DC001_sum18_im
    _ = (DC001_g0_rim + Phi11 * DC001_g0_qim) +
          (DC001_g1_rim + Phi11 * DC001_g1_qim) +
            (DC001_g2_rim + Phi11 * DC001_g2_qim) := by
      rw [DC001_g0_im, DC001_g1_im, DC001_g2_im]
    _ = (DC001_g0_rim + DC001_g1_rim + DC001_g2_rim) +
          Phi11 * (DC001_g0_qim + DC001_g1_qim + DC001_g2_qim) := by
      ring
    _ = (Fplus_im_001 + Phi11 * DC001_g3_qim) +
          Phi11 * (DC001_g0_qim + DC001_g1_qim + DC001_g2_qim) := by
      rw [DC001_rem_im]
    _ = Fplus_im_001 + Phi11 * (DC001_g0_qim + DC001_g1_qim + DC001_g2_qim + DC001_g3_qim) := by
      ring

public theorem detCoeff_001_eq :
    detCoeff_001 = ofLadj Fplus_re_001 Fplus_im_001 := by
  rw [detCoeff_001_sum, detCoeff_001_sum_poly_re,
    detCoeff_001_sum_poly_im, ofLadj_add_Phi11]
end V14Formalization.D12SigmaPlusSegreCore
