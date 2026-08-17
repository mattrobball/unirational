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

def DC112_0_pre : Polynomial ℚ := C (-342) + C (456) * X + C (130) * X ^ 2 + C (-504) * X ^ 3 + C (1168) * X ^ 4 + C (-452) * X ^ 5 + C (-316) * X ^ 6 + C (1494) * X ^ 7 + C (-1372) * X ^ 8 + C (404) * X ^ 9 + C (1338) * X ^ 10 + C (-1360) * X ^ 11 + C (882) * X ^ 12 + C (274) * X ^ 13 + C (-868) * X ^ 14 + C (766) * X ^ 15 + C (-120) * X ^ 16 + C (-256) * X ^ 17 + C (440) * X ^ 18
def DC112_0_pim : Polynomial ℚ := C (-456) + C (-912) * X + C (-118) * X ^ 2 + C (-1622) * X ^ 3 + C (-1480) * X ^ 4 + C (-572) * X ^ 5 + C (-3064) * X ^ 6 + C (-1530) * X ^ 7 + C (-1384) * X ^ 8 + C (-4182) * X ^ 9 + C (-976) * X ^ 10 + C (-1888) * X ^ 11 + C (-2800) * X ^ 12 + C (-388) * X ^ 13 + C (-1682) * X ^ 14 + C (-1358) * X ^ 15 + C (-100) * X ^ 16 + C (-952) * X ^ 17 + C (-320) * X ^ 18
theorem DC112_0_pre_eq :
    N_re_0_3 * N_re_1_4 - N_im_0_3 * N_im_1_4 =
      DC112_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_4, N_im_1_4, DC112_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC112_0_pim_eq :
    N_re_0_3 * N_im_1_4 + N_im_0_3 * N_re_1_4 =
      DC112_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_4, N_im_1_4, DC112_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC112_0_mul :
    N_entry_0_3 * N_entry_1_4 =
      ofLadj DC112_0_pre DC112_0_pim := by
  rw [N_entry_0_3, N_entry_1_4, ofLadj_mul,
    DC112_0_pre_eq, DC112_0_pim_eq]

def DC112_1_pre : Polynomial ℚ := C (-450) + C (288) * X + C (-174) * X ^ 2 + C (-808) * X ^ 3 + C (872) * X ^ 4 + C (-666) * X ^ 5 + C (-494) * X ^ 6 + C (1402) * X ^ 7 + C (-1436) * X ^ 8 + C (348) * X ^ 9 + C (1284) * X ^ 10 + C (-1316) * X ^ 11 + C (996) * X ^ 12 + C (522) * X ^ 13 + C (-628) * X ^ 14 + C (1010) * X ^ 15 + C (32) * X ^ 16 + C (-140) * X ^ 17 + C (480) * X ^ 18
def DC112_1_pim : Polynomial ℚ := C (-390) + C (-780) * X + C (150) * X ^ 2 + C (-1214) * X ^ 3 + C (-946) * X ^ 4 + C (160) * X ^ 5 + C (-2270) * X ^ 6 + C (-626) * X ^ 7 + C (-518) * X ^ 8 + C (-3326) * X ^ 9 + C (-108) * X ^ 10 + C (-1092) * X ^ 11 + C (-2076) * X ^ 12 + C (212) * X ^ 13 + C (-1232) * X ^ 14 + C (-1032) * X ^ 15 + C (36) * X ^ 16 + C (-890) * X ^ 17 + C (-360) * X ^ 18
theorem DC112_1_pre_eq :
    N_re_0_4 * N_re_1_3 - N_im_0_4 * N_im_1_3 =
      DC112_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_3, N_im_1_3, DC112_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC112_1_pim_eq :
    N_re_0_4 * N_im_1_3 + N_im_0_4 * N_re_1_3 =
      DC112_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_3, N_im_1_3, DC112_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC112_1_mul :
    N_entry_0_4 * N_entry_1_3 =
      ofLadj DC112_1_pre DC112_1_pim := by
  rw [N_entry_0_4, N_entry_1_3, ofLadj_mul,
    DC112_1_pre_eq, DC112_1_pim_eq]

def DC112_1_spre : Polynomial ℚ := C (450) + C (-288) * X + C (174) * X ^ 2 + C (808) * X ^ 3 + C (-872) * X ^ 4 + C (666) * X ^ 5 + C (494) * X ^ 6 + C (-1402) * X ^ 7 + C (1436) * X ^ 8 + C (-348) * X ^ 9 + C (-1284) * X ^ 10 + C (1316) * X ^ 11 + C (-996) * X ^ 12 + C (-522) * X ^ 13 + C (628) * X ^ 14 + C (-1010) * X ^ 15 + C (-32) * X ^ 16 + C (140) * X ^ 17 + C (-480) * X ^ 18
def DC112_1_spim : Polynomial ℚ := C (390) + C (780) * X + C (-150) * X ^ 2 + C (1214) * X ^ 3 + C (946) * X ^ 4 + C (-160) * X ^ 5 + C (2270) * X ^ 6 + C (626) * X ^ 7 + C (518) * X ^ 8 + C (3326) * X ^ 9 + C (108) * X ^ 10 + C (1092) * X ^ 11 + C (2076) * X ^ 12 + C (-212) * X ^ 13 + C (1232) * X ^ 14 + C (1032) * X ^ 15 + C (-36) * X ^ 16 + C (890) * X ^ 17 + C (360) * X ^ 18
theorem DC112_1_spre_eq : -DC112_1_pre = DC112_1_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC112_1_pre, DC112_1_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC112_1_spim_eq : -DC112_1_pim = DC112_1_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC112_1_pim, DC112_1_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC112_1_smul :
    -(N_entry_0_4 * N_entry_1_3) =
      ofLadj DC112_1_spre DC112_1_spim := by
  rw [DC112_1_mul, ofLadj_neg, DC112_1_spre_eq, DC112_1_spim_eq]

def DC112_2_pre : Polynomial ℚ := C (-608) + C (912) * X + C (248) * X ^ 2 + C (-1010) * X ^ 3 + C (2334) * X ^ 4 + C (-800) * X ^ 5 + C (-560) * X ^ 6 + C (3194) * X ^ 7 + C (-2452) * X ^ 8 + C (1140) * X ^ 9 + C (3016) * X ^ 10 + C (-2456) * X ^ 11 + C (2104) * X ^ 12 + C (892) * X ^ 13 + C (-1442) * X ^ 14 + C (1822) * X ^ 15 + C (-74) * X ^ 16 + C (-314) * X ^ 17 + C (962) * X ^ 18
def DC112_2_pim : Polynomial ℚ := C (-874) + C (-1748) * X + C (-166) * X ^ 2 + C (-2986) * X ^ 3 + C (-2730) * X ^ 4 + C (-834) * X ^ 5 + C (-5742) * X ^ 6 + C (-2660) * X ^ 7 + C (-2382) * X ^ 8 + C (-7990) * X ^ 9 + C (-1588) * X ^ 10 + C (-3472) * X ^ 11 + C (-5356) * X ^ 12 + C (-536) * X ^ 13 + C (-3324) * X ^ 14 + C (-2636) * X ^ 15 + C (-168) * X ^ 16 + C (-1948) * X ^ 17 + C (-666) * X ^ 18
theorem DC112_2_pre_eq :
    N_re_0_3 * N_re_2_5 - N_im_0_3 * N_im_2_5 =
      DC112_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_2_5, N_im_2_5, DC112_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC112_2_pim_eq :
    N_re_0_3 * N_im_2_5 + N_im_0_3 * N_re_2_5 =
      DC112_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_2_5, N_im_2_5, DC112_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC112_2_mul :
    N_entry_0_3 * N_entry_2_5 =
      ofLadj DC112_2_pre DC112_2_pim := by
  rw [N_entry_0_3, N_entry_2_5, ofLadj_mul,
    DC112_2_pre_eq, DC112_2_pim_eq]

def DC112_3_pre : Polynomial ℚ := C (-876) + C (564) * X + C (-288) * X ^ 2 + C (-1600) * X ^ 3 + C (1676) * X ^ 4 + C (-1344) * X ^ 5 + C (-1092) * X ^ 6 + C (2688) * X ^ 7 + C (-2968) * X ^ 8 + C (608) * X ^ 9 + C (2476) * X ^ 10 + C (-2692) * X ^ 11 + C (1912) * X ^ 12 + C (896) * X ^ 13 + C (-1368) * X ^ 14 + C (1924) * X ^ 15 + C (-60) * X ^ 16 + C (-312) * X ^ 17 + C (912) * X ^ 18
def DC112_3_pim : Polynomial ℚ := C (-762) + C (-1524) * X + C (264) * X ^ 2 + C (-2412) * X ^ 3 + C (-1970) * X ^ 4 + C (280) * X ^ 5 + C (-4574) * X ^ 6 + C (-1332) * X ^ 7 + C (-1048) * X ^ 8 + C (-6624) * X ^ 9 + C (-260) * X ^ 10 + C (-2244) * X ^ 11 + C (-4228) * X ^ 12 + C (348) * X ^ 13 + C (-2552) * X ^ 14 + C (-2056) * X ^ 15 + C (38) * X ^ 16 + C (-1756) * X ^ 17 + C (-654) * X ^ 18
theorem DC112_3_pre_eq :
    N_re_0_5 * N_re_2_3 - N_im_0_5 * N_im_2_3 =
      DC112_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_2_3, N_im_2_3, DC112_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC112_3_pim_eq :
    N_re_0_5 * N_im_2_3 + N_im_0_5 * N_re_2_3 =
      DC112_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_2_3, N_im_2_3, DC112_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC112_3_mul :
    N_entry_0_5 * N_entry_2_3 =
      ofLadj DC112_3_pre DC112_3_pim := by
  rw [N_entry_0_5, N_entry_2_3, ofLadj_mul,
    DC112_3_pre_eq, DC112_3_pim_eq]

def DC112_3_spre : Polynomial ℚ := C (876) + C (-564) * X + C (288) * X ^ 2 + C (1600) * X ^ 3 + C (-1676) * X ^ 4 + C (1344) * X ^ 5 + C (1092) * X ^ 6 + C (-2688) * X ^ 7 + C (2968) * X ^ 8 + C (-608) * X ^ 9 + C (-2476) * X ^ 10 + C (2692) * X ^ 11 + C (-1912) * X ^ 12 + C (-896) * X ^ 13 + C (1368) * X ^ 14 + C (-1924) * X ^ 15 + C (60) * X ^ 16 + C (312) * X ^ 17 + C (-912) * X ^ 18
def DC112_3_spim : Polynomial ℚ := C (762) + C (1524) * X + C (-264) * X ^ 2 + C (2412) * X ^ 3 + C (1970) * X ^ 4 + C (-280) * X ^ 5 + C (4574) * X ^ 6 + C (1332) * X ^ 7 + C (1048) * X ^ 8 + C (6624) * X ^ 9 + C (260) * X ^ 10 + C (2244) * X ^ 11 + C (4228) * X ^ 12 + C (-348) * X ^ 13 + C (2552) * X ^ 14 + C (2056) * X ^ 15 + C (-38) * X ^ 16 + C (1756) * X ^ 17 + C (654) * X ^ 18
theorem DC112_3_spre_eq : -DC112_3_pre = DC112_3_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC112_3_pre, DC112_3_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC112_3_spim_eq : -DC112_3_pim = DC112_3_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC112_3_pim, DC112_3_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC112_3_smul :
    -(N_entry_0_5 * N_entry_2_3) =
      ofLadj DC112_3_spre DC112_3_spim := by
  rw [DC112_3_mul, ofLadj_neg, DC112_3_spre_eq, DC112_3_spim_eq]

def DC112_4_pre : Polynomial ℚ := C (192) + C (-288) * X + C (-92) * X ^ 2 + C (288) * X ^ 3 + C (-736) * X ^ 4 + C (260) * X ^ 5 + C (172) * X ^ 6 + C (-968) * X ^ 7 + C (796) * X ^ 8 + C (-304) * X ^ 9 + C (-884) * X ^ 10 + C (800) * X ^ 11 + C (-596) * X ^ 12 + C (-212) * X ^ 13 + C (508) * X ^ 14 + C (-512) * X ^ 15 + C (48) * X ^ 16 + C (136) * X ^ 17 + C (-280) * X ^ 18
def DC112_4_pim : Polynomial ℚ := C (276) + C (552) * X + C (72) * X ^ 2 + C (972) * X ^ 3 + C (888) * X ^ 4 + C (332) * X ^ 5 + C (1868) * X ^ 6 + C (916) * X ^ 7 + C (832) * X ^ 8 + C (2560) * X ^ 9 + C (576) * X ^ 10 + C (1152) * X ^ 11 + C (1728) * X ^ 12 + C (224) * X ^ 13 + C (1052) * X ^ 14 + C (852) * X ^ 15 + C (64) * X ^ 16 + C (592) * X ^ 17 + C (200) * X ^ 18
theorem DC112_4_pre_eq :
    N_re_1_4 * N_re_2_5 - N_im_1_4 * N_im_2_5 =
      DC112_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_4, N_im_1_4, N_re_2_5, N_im_2_5, DC112_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC112_4_pim_eq :
    N_re_1_4 * N_im_2_5 + N_im_1_4 * N_re_2_5 =
      DC112_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_4, N_im_1_4, N_re_2_5, N_im_2_5, DC112_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC112_4_mul :
    N_entry_1_4 * N_entry_2_5 =
      ofLadj DC112_4_pre DC112_4_pim := by
  rw [N_entry_1_4, N_entry_2_5, ofLadj_mul,
    DC112_4_pre_eq, DC112_4_pim_eq]

def DC112_5_pre : Polynomial ℚ := C (214) + C (-288) * X + C (-97) * X ^ 2 + C (297) * X ^ 3 + C (-757) * X ^ 4 + C (236) * X ^ 5 + C (148) * X ^ 6 + C (-1015) * X ^ 7 + C (753) * X ^ 8 + C (-357) * X ^ 9 + C (-942) * X ^ 10 + C (728) * X ^ 11 + C (-654) * X ^ 12 + C (-260) * X ^ 13 + C (456) * X ^ 14 + C (-542) * X ^ 15 + C (32) * X ^ 16 + C (120) * X ^ 17 + C (-284) * X ^ 18
def DC112_5_pim : Polynomial ℚ := C (288) + C (576) * X + C (64) * X ^ 2 + C (974) * X ^ 3 + C (886) * X ^ 4 + C (296) * X ^ 5 + C (1836) * X ^ 6 + C (874) * X ^ 7 + C (774) * X ^ 8 + C (2512) * X ^ 9 + C (520) * X ^ 10 + C (1092) * X ^ 11 + C (1664) * X ^ 12 + C (184) * X ^ 13 + C (1012) * X ^ 14 + C (812) * X ^ 15 + C (48) * X ^ 16 + C (580) * X ^ 17 + C (188) * X ^ 18
theorem DC112_5_pre_eq :
    N_re_1_5 * N_re_2_4 - N_im_1_5 * N_im_2_4 =
      DC112_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_5, N_im_1_5, N_re_2_4, N_im_2_4, DC112_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC112_5_pim_eq :
    N_re_1_5 * N_im_2_4 + N_im_1_5 * N_re_2_4 =
      DC112_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_1_5, N_im_1_5, N_re_2_4, N_im_2_4, DC112_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC112_5_mul :
    N_entry_1_5 * N_entry_2_4 =
      ofLadj DC112_5_pre DC112_5_pim := by
  rw [N_entry_1_5, N_entry_2_4, ofLadj_mul,
    DC112_5_pre_eq, DC112_5_pim_eq]

def DC112_5_spre : Polynomial ℚ := C (-214) + C (288) * X + C (97) * X ^ 2 + C (-297) * X ^ 3 + C (757) * X ^ 4 + C (-236) * X ^ 5 + C (-148) * X ^ 6 + C (1015) * X ^ 7 + C (-753) * X ^ 8 + C (357) * X ^ 9 + C (942) * X ^ 10 + C (-728) * X ^ 11 + C (654) * X ^ 12 + C (260) * X ^ 13 + C (-456) * X ^ 14 + C (542) * X ^ 15 + C (-32) * X ^ 16 + C (-120) * X ^ 17 + C (284) * X ^ 18
def DC112_5_spim : Polynomial ℚ := C (-288) + C (-576) * X + C (-64) * X ^ 2 + C (-974) * X ^ 3 + C (-886) * X ^ 4 + C (-296) * X ^ 5 + C (-1836) * X ^ 6 + C (-874) * X ^ 7 + C (-774) * X ^ 8 + C (-2512) * X ^ 9 + C (-520) * X ^ 10 + C (-1092) * X ^ 11 + C (-1664) * X ^ 12 + C (-184) * X ^ 13 + C (-1012) * X ^ 14 + C (-812) * X ^ 15 + C (-48) * X ^ 16 + C (-580) * X ^ 17 + C (-188) * X ^ 18
theorem DC112_5_spre_eq : -DC112_5_pre = DC112_5_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC112_5_pre, DC112_5_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC112_5_spim_eq : -DC112_5_pim = DC112_5_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC112_5_pim, DC112_5_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC112_5_smul :
    -(N_entry_1_5 * N_entry_2_4) =
      ofLadj DC112_5_spre DC112_5_spim := by
  rw [DC112_5_mul, ofLadj_neg, DC112_5_spre_eq, DC112_5_spim_eq]

@[expose] public def detCoeff_112 : Ki :=
  N_entry_0_3 * N_entry_1_4 + (-(N_entry_0_4 * N_entry_1_3)) + N_entry_0_3 * N_entry_2_5 + (-(N_entry_0_5 * N_entry_2_3)) + N_entry_1_4 * N_entry_2_5 + (-(N_entry_1_5 * N_entry_2_4))

theorem detCoeff_112_sum :
    detCoeff_112 = ofLadj (DC112_0_pre + DC112_1_spre + DC112_2_pre + DC112_3_spre + DC112_4_pre + DC112_5_spre) (DC112_0_pim + DC112_1_spim + DC112_2_pim + DC112_3_spim + DC112_4_pim + DC112_5_spim) := by
  simp only [detCoeff_112, DC112_0_mul, DC112_1_smul, DC112_2_mul, DC112_3_smul, DC112_4_mul, DC112_5_smul]
  simpa [add_assoc] using ofLadj_add6 DC112_0_pre DC112_0_pim DC112_1_spre DC112_1_spim DC112_2_pre DC112_2_pim DC112_3_spre DC112_3_spim DC112_4_pre DC112_4_pim DC112_5_spre DC112_5_spim

def DC112_qre : Polynomial ℚ := C (388) + C (128) * X + C (340) * X ^ 2 + C (58) * X ^ 3 + C (54) * X ^ 4 + C (-166) * X ^ 5 + C (-48) * X ^ 6 + C (-116) * X ^ 7 + C (14) * X ^ 8
def DC112_qim : Polynomial ℚ := C (-176) + C (-176) * X + C (-344) * X ^ 2 + C (-262) * X ^ 3 + C (-316) * X ^ 4 + C (-540) * X ^ 5 + C (-84) * X ^ 6 + C (-282) * X ^ 7 + C (40) * X ^ 8

theorem detCoeff_112_sum_poly_re :
    DC112_0_pre + DC112_1_spre + DC112_2_pre + DC112_3_spre + DC112_4_pre + DC112_5_spre = Fplus_re_112 + Phi11 * DC112_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC112_0_pre, DC112_1_spre, DC112_2_pre, DC112_3_spre, DC112_4_pre, DC112_5_spre, Fplus_re_112, DC112_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring

theorem detCoeff_112_sum_poly_im :
    DC112_0_pim + DC112_1_spim + DC112_2_pim + DC112_3_spim + DC112_4_pim + DC112_5_spim = Fplus_im_112 + Phi11 * DC112_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC112_0_pim, DC112_1_spim, DC112_2_pim, DC112_3_spim, DC112_4_pim, DC112_5_spim, Fplus_im_112, DC112_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring

public theorem detCoeff_112_eq :
    detCoeff_112 = ofLadj Fplus_re_112 Fplus_im_112 := by
  rw [detCoeff_112_sum, detCoeff_112_sum_poly_re,
    detCoeff_112_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
