/-
Auto-generated Fplus / det(bilinearN) coefficient identities.
-/
import V14Formalization.D12SigmaPlusSegreEval
import V14Formalization.D12SigmaPlusSegreMul

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData

def DC111_0_ab_pre : Polynomial ℚ := C (-342) + C (456) * X + C (130) * X ^ 2 + C (-504) * X ^ 3 + C (1168) * X ^ 4 + C (-452) * X ^ 5 + C (-316) * X ^ 6 + C (1494) * X ^ 7 + C (-1372) * X ^ 8 + C (404) * X ^ 9 + C (1338) * X ^ 10 + C (-1360) * X ^ 11 + C (882) * X ^ 12 + C (274) * X ^ 13 + C (-868) * X ^ 14 + C (766) * X ^ 15 + C (-120) * X ^ 16 + C (-256) * X ^ 17 + C (440) * X ^ 18
def DC111_0_ab_pim : Polynomial ℚ := C (-456) + C (-912) * X + C (-118) * X ^ 2 + C (-1622) * X ^ 3 + C (-1480) * X ^ 4 + C (-572) * X ^ 5 + C (-3064) * X ^ 6 + C (-1530) * X ^ 7 + C (-1384) * X ^ 8 + C (-4182) * X ^ 9 + C (-976) * X ^ 10 + C (-1888) * X ^ 11 + C (-2800) * X ^ 12 + C (-388) * X ^ 13 + C (-1682) * X ^ 14 + C (-1358) * X ^ 15 + C (-100) * X ^ 16 + C (-952) * X ^ 17 + C (-320) * X ^ 18
def DC111_0_pre : Polynomial ℚ := C (2052) + C (-31920) * X + C (-22516) * X ^ 2 + C (-14628) * X ^ 3 + C (-120124) * X ^ 4 + C (-36996) * X ^ 5 + C (-85644) * X ^ 6 + C (-240720) * X ^ 7 + C (-30864) * X ^ 8 + C (-240572) * X ^ 9 + C (-335620) * X ^ 10 + C (-33608) * X ^ 11 + C (-398108) * X ^ 12 + C (-282340) * X ^ 13 + C (-68576) * X ^ 14 + C (-450392) * X ^ 15 + C (-157856) * X ^ 16 + C (-121048) * X ^ 17 + C (-363460) * X ^ 18 + C (-52956) * X ^ 19 + C (-127720) * X ^ 20 + C (-180920) * X ^ 21 + C (-6704) * X ^ 22 + C (-86512) * X ^ 23 + C (-63436) * X ^ 24 + C (-616) * X ^ 25 + C (-33664) * X ^ 26 + C (-11840) * X ^ 27
def DC111_0_pim : Polynomial ℚ := C (14136) + C (22800) * X + C (-6944) * X ^ 2 + C (63692) * X ^ 3 + C (46436) * X ^ 4 + C (-796) * X ^ 5 + C (172268) * X ^ 6 + C (46272) * X ^ 7 + C (64256) * X ^ 8 + C (311184) * X ^ 9 + C (4592) * X ^ 10 + C (184168) * X ^ 11 + C (340052) * X ^ 12 + C (-29284) * X ^ 13 + C (308476) * X ^ 14 + C (252336) * X ^ 15 + C (-16468) * X ^ 16 + C (327268) * X ^ 17 + C (108796) * X ^ 18 + C (15880) * X ^ 19 + C (211368) * X ^ 20 + C (13512) * X ^ 21 + C (38392) * X ^ 22 + C (92436) * X ^ 23 + C (-12932) * X ^ 24 + C (21088) * X ^ 25 + C (19552) * X ^ 26 + C (-8880) * X ^ 27
theorem DC111_0_ab_pre_eq :
    N_re_0_3 * N_re_1_4 - N_im_0_3 * N_im_1_4 =
      DC111_0_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_4, N_im_1_4, DC111_0_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_0_ab_pim_eq :
    N_re_0_3 * N_im_1_4 + N_im_0_3 * N_re_1_4 =
      DC111_0_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_4, N_im_1_4, DC111_0_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_0_ab_mul :
    N_entry_0_3 * N_entry_1_4 =
      ofLadj DC111_0_ab_pre DC111_0_ab_pim := by
  rw [N_entry_0_3, N_entry_1_4, ofLadj_mul,
    DC111_0_ab_pre_eq, DC111_0_ab_pim_eq]

theorem DC111_0_pre_eq :
    DC111_0_ab_pre * N_re_2_5 - DC111_0_ab_pim * N_im_2_5 =
      DC111_0_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_0_ab_pre, DC111_0_ab_pim, N_re_2_5, N_im_2_5, DC111_0_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_0_pim_eq :
    DC111_0_ab_pre * N_im_2_5 + DC111_0_ab_pim * N_re_2_5 =
      DC111_0_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_0_ab_pre, DC111_0_ab_pim, N_re_2_5, N_im_2_5, DC111_0_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_0_mul :
    N_entry_0_3 * N_entry_1_4 * N_entry_2_5 =
      ofLadj DC111_0_pre DC111_0_pim := by
  rw [DC111_0_ab_mul, N_entry_2_5, ofLadj_mul, DC111_0_pre_eq, DC111_0_pim_eq]

def DC111_1_ab_pre : Polynomial ℚ := C (-198) + C (144) * X + C (-42) * X ^ 2 + C (-338) * X ^ 3 + C (388) * X ^ 4 + C (-316) * X ^ 5 + C (-244) * X ^ 6 + C (568) * X ^ 7 + C (-674) * X ^ 8 + C (130) * X ^ 9 + C (552) * X ^ 10 + C (-576) * X ^ 11 + C (408) * X ^ 12 + C (172) * X ^ 13 + C (-336) * X ^ 14 + C (372) * X ^ 15 + C (-32) * X ^ 16 + C (-104) * X ^ 17 + C (192) * X ^ 18
def DC111_1_ab_pim : Polynomial ℚ := C (-186) + C (-372) * X + C (18) * X ^ 2 + C (-622) * X ^ 3 + C (-512) * X ^ 4 + C (-48) * X ^ 5 + C (-1116) * X ^ 6 + C (-400) * X ^ 7 + C (-326) * X ^ 8 + C (-1562) * X ^ 9 + C (-168) * X ^ 10 + C (-600) * X ^ 11 + C (-1032) * X ^ 12 + C (-28) * X ^ 13 + C (-624) * X ^ 14 + C (-516) * X ^ 15 + C (-16) * X ^ 16 + C (-392) * X ^ 17 + C (-144) * X ^ 18
def DC111_1_pre : Polynomial ℚ := C (6816) + C (-25620) * X + C (-9456) * X ^ 2 + C (8608) * X ^ 3 + C (-92552) * X ^ 4 + C (5104) * X ^ 5 + C (-30248) * X ^ 6 + C (-179592) * X ^ 7 + C (50872) * X ^ 8 + C (-151576) * X ^ 9 + C (-239892) * X ^ 10 + C (71724) * X ^ 11 + C (-294608) * X ^ 12 + C (-181048) * X ^ 13 + C (29832) * X ^ 14 + C (-360484) * X ^ 15 + C (-77168) * X ^ 16 + C (-53312) * X ^ 17 + C (-304212) * X ^ 18 + C (-10608) * X ^ 19 + C (-94568) * X ^ 20 + C (-155496) * X ^ 21 + C (7728) * X ^ 22 + C (-75160) * X ^ 23 + C (-55640) * X ^ 24 + C (1824) * X ^ 25 + C (-30768) * X ^ 26 + C (-11496) * X ^ 27
def DC111_1_pim : Polynomial ℚ := C (15162) + C (26940) * X + C (-5424) * X ^ 2 + C (70164) * X ^ 3 + C (52226) * X ^ 4 + C (-2644) * X ^ 5 + C (173842) * X ^ 6 + C (38836) * X ^ 7 + C (48656) * X ^ 8 + C (298172) * X ^ 9 + C (-22768) * X ^ 10 + C (152504) * X ^ 11 + C (302800) * X ^ 12 + C (-75004) * X ^ 13 + C (258448) * X ^ 14 + C (200336) * X ^ 15 + C (-64694) * X ^ 16 + C (279932) * X ^ 17 + C (68094) * X ^ 18 + C (-17152) * X ^ 19 + C (178840) * X ^ 20 + C (-8244) * X ^ 21 + C (21388) * X ^ 22 + C (79380) * X ^ 23 + C (-18476) * X ^ 24 + C (17992) * X ^ 25 + C (18616) * X ^ 26 + C (-8328) * X ^ 27
theorem DC111_1_ab_pre_eq :
    N_re_0_4 * N_re_1_5 - N_im_0_4 * N_im_1_5 =
      DC111_1_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_5, N_im_1_5, DC111_1_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_1_ab_pim_eq :
    N_re_0_4 * N_im_1_5 + N_im_0_4 * N_re_1_5 =
      DC111_1_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_5, N_im_1_5, DC111_1_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_1_ab_mul :
    N_entry_0_4 * N_entry_1_5 =
      ofLadj DC111_1_ab_pre DC111_1_ab_pim := by
  rw [N_entry_0_4, N_entry_1_5, ofLadj_mul,
    DC111_1_ab_pre_eq, DC111_1_ab_pim_eq]

theorem DC111_1_pre_eq :
    DC111_1_ab_pre * N_re_2_3 - DC111_1_ab_pim * N_im_2_3 =
      DC111_1_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_1_ab_pre, DC111_1_ab_pim, N_re_2_3, N_im_2_3, DC111_1_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_1_pim_eq :
    DC111_1_ab_pre * N_im_2_3 + DC111_1_ab_pim * N_re_2_3 =
      DC111_1_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_1_ab_pre, DC111_1_ab_pim, N_re_2_3, N_im_2_3, DC111_1_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_1_mul :
    N_entry_0_4 * N_entry_1_5 * N_entry_2_3 =
      ofLadj DC111_1_pre DC111_1_pim := by
  rw [DC111_1_ab_mul, N_entry_2_3, ofLadj_mul, DC111_1_pre_eq, DC111_1_pim_eq]

def DC111_2_ab_pre : Polynomial ℚ := C (-450) + C (288) * X + C (-174) * X ^ 2 + C (-808) * X ^ 3 + C (872) * X ^ 4 + C (-666) * X ^ 5 + C (-494) * X ^ 6 + C (1402) * X ^ 7 + C (-1436) * X ^ 8 + C (348) * X ^ 9 + C (1284) * X ^ 10 + C (-1316) * X ^ 11 + C (996) * X ^ 12 + C (522) * X ^ 13 + C (-628) * X ^ 14 + C (1010) * X ^ 15 + C (32) * X ^ 16 + C (-140) * X ^ 17 + C (480) * X ^ 18
def DC111_2_ab_pim : Polynomial ℚ := C (-390) + C (-780) * X + C (150) * X ^ 2 + C (-1214) * X ^ 3 + C (-946) * X ^ 4 + C (160) * X ^ 5 + C (-2270) * X ^ 6 + C (-626) * X ^ 7 + C (-518) * X ^ 8 + C (-3326) * X ^ 9 + C (-108) * X ^ 10 + C (-1092) * X ^ 11 + C (-2076) * X ^ 12 + C (212) * X ^ 13 + C (-1232) * X ^ 14 + C (-1032) * X ^ 15 + C (36) * X ^ 16 + C (-890) * X ^ 17 + C (-360) * X ^ 18
def DC111_2_pre : Polynomial ℚ := C (5220) + C (-25056) * X + C (-9162) * X ^ 2 + C (8002) * X ^ 3 + C (-88892) * X ^ 4 + C (4766) * X ^ 5 + C (-29294) * X ^ 6 + C (-175104) * X ^ 7 + C (47162) * X ^ 8 + C (-150346) * X ^ 9 + C (-236826) * X ^ 10 + C (70684) * X ^ 11 + C (-290162) * X ^ 12 + C (-179152) * X ^ 13 + C (28882) * X ^ 14 + C (-359506) * X ^ 15 + C (-78092) * X ^ 16 + C (-56752) * X ^ 17 + C (-306974) * X ^ 18 + C (-10666) * X ^ 19 + C (-96538) * X ^ 20 + C (-157718) * X ^ 21 + C (6144) * X ^ 22 + C (-79326) * X ^ 23 + C (-58570) * X ^ 24 + C (-388) * X ^ 25 + C (-33680) * X ^ 26 + C (-12720) * X ^ 27
def DC111_2_pim : Polynomial ℚ := C (13980) + C (24504) * X + C (-6294) * X ^ 2 + C (63806) * X ^ 3 + C (44212) * X ^ 4 + C (-11512) * X ^ 5 + C (154926) * X ^ 6 + C (20454) * X ^ 7 + C (26146) * X ^ 8 + C (265404) * X ^ 9 + C (-51410) * X ^ 10 + C (117252) * X ^ 11 + C (262104) * X ^ 12 + C (-114918) * X ^ 13 + C (214268) * X ^ 14 + C (156250) * X ^ 15 + C (-105734) * X ^ 16 + C (241752) * X ^ 17 + C (33046) * X ^ 18 + C (-47274) * X ^ 19 + C (154290) * X ^ 20 + C (-31594) * X ^ 21 + C (3504) * X ^ 22 + C (65868) * X ^ 23 + C (-29010) * X ^ 24 + C (12526) * X ^ 25 + C (15510) * X ^ 26 + C (-9960) * X ^ 27
theorem DC111_2_ab_pre_eq :
    N_re_0_5 * N_re_1_3 - N_im_0_5 * N_im_1_3 =
      DC111_2_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_3, N_im_1_3, DC111_2_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_2_ab_pim_eq :
    N_re_0_5 * N_im_1_3 + N_im_0_5 * N_re_1_3 =
      DC111_2_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_3, N_im_1_3, DC111_2_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_2_ab_mul :
    N_entry_0_5 * N_entry_1_3 =
      ofLadj DC111_2_ab_pre DC111_2_ab_pim := by
  rw [N_entry_0_5, N_entry_1_3, ofLadj_mul,
    DC111_2_ab_pre_eq, DC111_2_ab_pim_eq]

theorem DC111_2_pre_eq :
    DC111_2_ab_pre * N_re_2_4 - DC111_2_ab_pim * N_im_2_4 =
      DC111_2_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_2_ab_pre, DC111_2_ab_pim, N_re_2_4, N_im_2_4, DC111_2_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_2_pim_eq :
    DC111_2_ab_pre * N_im_2_4 + DC111_2_ab_pim * N_re_2_4 =
      DC111_2_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_2_ab_pre, DC111_2_ab_pim, N_re_2_4, N_im_2_4, DC111_2_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_2_mul :
    N_entry_0_5 * N_entry_1_3 * N_entry_2_4 =
      ofLadj DC111_2_pre DC111_2_pim := by
  rw [DC111_2_ab_mul, N_entry_2_4, ofLadj_mul, DC111_2_pre_eq, DC111_2_pim_eq]

def DC111_3_ab_pre : Polynomial ℚ := C (-380) + C (456) * X + C (117) * X ^ 2 + C (-541) * X ^ 3 + C (1172) * X ^ 4 + C (-481) * X ^ 5 + C (-345) * X ^ 6 + C (1498) * X ^ 7 + C (-1409) * X ^ 8 + C (391) * X ^ 9 + C (1338) * X ^ 10 + C (-1360) * X ^ 11 + C (882) * X ^ 12 + C (274) * X ^ 13 + C (-868) * X ^ 14 + C (766) * X ^ 15 + C (-120) * X ^ 16 + C (-256) * X ^ 17 + C (440) * X ^ 18
def DC111_3_ab_pim : Polynomial ℚ := C (-475) + C (-950) * X + C (-115) * X ^ 2 + C (-1656) * X ^ 3 + C (-1506) * X ^ 4 + C (-572) * X ^ 5 + C (-3102) * X ^ 6 + C (-1542) * X ^ 7 + C (-1388) * X ^ 8 + C (-4223) * X ^ 9 + C (-976) * X ^ 10 + C (-1888) * X ^ 11 + C (-2800) * X ^ 12 + C (-388) * X ^ 13 + C (-1682) * X ^ 14 + C (-1358) * X ^ 15 + C (-100) * X ^ 16 + C (-952) * X ^ 17 + C (-320) * X ^ 18
def DC111_3_pre : Polynomial ℚ := C (2660) + C (-32832) * X + C (-23144) * X ^ 2 + C (-13542) * X ^ 3 + C (-122265) * X ^ 4 + C (-36924) * X ^ 5 + C (-84184) * X ^ 6 + C (-242998) * X ^ 7 + C (-28838) * X ^ 8 + C (-239585) * X ^ 9 + C (-337478) * X ^ 10 + C (-31576) * X ^ 11 + C (-397436) * X ^ 12 + C (-282339) * X ^ 13 + C (-67638) * X ^ 14 + C (-449216) * X ^ 15 + C (-157058) * X ^ 16 + C (-121198) * X ^ 17 + C (-361963) * X ^ 18 + C (-52894) * X ^ 19 + C (-128064) * X ^ 20 + C (-179156) * X ^ 21 + C (-6844) * X ^ 22 + C (-86366) * X ^ 23 + C (-62166) * X ^ 24 + C (-552) * X ^ 25 + C (-33480) * X ^ 26 + C (-11400) * X ^ 27
def DC111_3_pim : Polynomial ℚ := C (15010) + C (24548) * X + C (-7253) * X ^ 2 + C (65253) * X ^ 3 + C (47626) * X ^ 4 + C (-3633) * X ^ 5 + C (171883) * X ^ 6 + C (42593) * X ^ 7 + C (56491) * X ^ 8 + C (306094) * X ^ 9 + C (-6729) * X ^ 10 + C (169862) * X ^ 11 + C (325799) * X ^ 12 + C (-46875) * X ^ 13 + C (289698) * X ^ 14 + C (233466) * X ^ 15 + C (-34051) * X ^ 16 + C (309825) * X ^ 17 + C (92859) * X ^ 18 + C (3666) * X ^ 19 + C (198840) * X ^ 20 + C (4454) * X ^ 21 + C (32540) * X ^ 22 + C (86752) * X ^ 23 + C (-15982) * X ^ 24 + C (19716) * X ^ 25 + C (18280) * X ^ 26 + C (-9200) * X ^ 27
theorem DC111_3_ab_pre_eq :
    N_re_0_3 * N_re_1_5 - N_im_0_3 * N_im_1_5 =
      DC111_3_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_5, N_im_1_5, DC111_3_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_3_ab_pim_eq :
    N_re_0_3 * N_im_1_5 + N_im_0_3 * N_re_1_5 =
      DC111_3_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_3, N_im_0_3, N_re_1_5, N_im_1_5, DC111_3_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_3_ab_mul :
    N_entry_0_3 * N_entry_1_5 =
      ofLadj DC111_3_ab_pre DC111_3_ab_pim := by
  rw [N_entry_0_3, N_entry_1_5, ofLadj_mul,
    DC111_3_ab_pre_eq, DC111_3_ab_pim_eq]

theorem DC111_3_pre_eq :
    DC111_3_ab_pre * N_re_2_4 - DC111_3_ab_pim * N_im_2_4 =
      DC111_3_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_3_ab_pre, DC111_3_ab_pim, N_re_2_4, N_im_2_4, DC111_3_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_3_pim_eq :
    DC111_3_ab_pre * N_im_2_4 + DC111_3_ab_pim * N_re_2_4 =
      DC111_3_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_3_ab_pre, DC111_3_ab_pim, N_re_2_4, N_im_2_4, DC111_3_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_3_mul :
    N_entry_0_3 * N_entry_1_5 * N_entry_2_4 =
      ofLadj DC111_3_pre DC111_3_pim := by
  rw [DC111_3_ab_mul, N_entry_2_4, ofLadj_mul, DC111_3_pre_eq, DC111_3_pim_eq]

def DC111_3_spre : Polynomial ℚ := C (-2660) + C (32832) * X + C (23144) * X ^ 2 + C (13542) * X ^ 3 + C (122265) * X ^ 4 + C (36924) * X ^ 5 + C (84184) * X ^ 6 + C (242998) * X ^ 7 + C (28838) * X ^ 8 + C (239585) * X ^ 9 + C (337478) * X ^ 10 + C (31576) * X ^ 11 + C (397436) * X ^ 12 + C (282339) * X ^ 13 + C (67638) * X ^ 14 + C (449216) * X ^ 15 + C (157058) * X ^ 16 + C (121198) * X ^ 17 + C (361963) * X ^ 18 + C (52894) * X ^ 19 + C (128064) * X ^ 20 + C (179156) * X ^ 21 + C (6844) * X ^ 22 + C (86366) * X ^ 23 + C (62166) * X ^ 24 + C (552) * X ^ 25 + C (33480) * X ^ 26 + C (11400) * X ^ 27
def DC111_3_spim : Polynomial ℚ := C (-15010) + C (-24548) * X + C (7253) * X ^ 2 + C (-65253) * X ^ 3 + C (-47626) * X ^ 4 + C (3633) * X ^ 5 + C (-171883) * X ^ 6 + C (-42593) * X ^ 7 + C (-56491) * X ^ 8 + C (-306094) * X ^ 9 + C (6729) * X ^ 10 + C (-169862) * X ^ 11 + C (-325799) * X ^ 12 + C (46875) * X ^ 13 + C (-289698) * X ^ 14 + C (-233466) * X ^ 15 + C (34051) * X ^ 16 + C (-309825) * X ^ 17 + C (-92859) * X ^ 18 + C (-3666) * X ^ 19 + C (-198840) * X ^ 20 + C (-4454) * X ^ 21 + C (-32540) * X ^ 22 + C (-86752) * X ^ 23 + C (15982) * X ^ 24 + C (-19716) * X ^ 25 + C (-18280) * X ^ 26 + C (9200) * X ^ 27
theorem DC111_3_spre_eq : -DC111_3_pre = DC111_3_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_3_pre, DC111_3_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC111_3_spim_eq : -DC111_3_pim = DC111_3_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_3_pim, DC111_3_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC111_3_smul :
    -(N_entry_0_3 * N_entry_1_5 * N_entry_2_4) =
      ofLadj DC111_3_spre DC111_3_spim := by
  rw [DC111_3_mul, ofLadj_neg, DC111_3_spre_eq, DC111_3_spim_eq]

def DC111_4_ab_pre : Polynomial ℚ := C (-450) + C (288) * X + C (-174) * X ^ 2 + C (-808) * X ^ 3 + C (872) * X ^ 4 + C (-666) * X ^ 5 + C (-494) * X ^ 6 + C (1402) * X ^ 7 + C (-1436) * X ^ 8 + C (348) * X ^ 9 + C (1284) * X ^ 10 + C (-1316) * X ^ 11 + C (996) * X ^ 12 + C (522) * X ^ 13 + C (-628) * X ^ 14 + C (1010) * X ^ 15 + C (32) * X ^ 16 + C (-140) * X ^ 17 + C (480) * X ^ 18
def DC111_4_ab_pim : Polynomial ℚ := C (-390) + C (-780) * X + C (150) * X ^ 2 + C (-1214) * X ^ 3 + C (-946) * X ^ 4 + C (160) * X ^ 5 + C (-2270) * X ^ 6 + C (-626) * X ^ 7 + C (-518) * X ^ 8 + C (-3326) * X ^ 9 + C (-108) * X ^ 10 + C (-1092) * X ^ 11 + C (-2076) * X ^ 12 + C (212) * X ^ 13 + C (-1232) * X ^ 14 + C (-1032) * X ^ 15 + C (36) * X ^ 16 + C (-890) * X ^ 17 + C (-360) * X ^ 18
def DC111_4_pre : Polynomial ℚ := C (5220) + C (-25056) * X + C (-8712) * X ^ 2 + C (8164) * X ^ 3 + C (-88556) * X ^ 4 + C (6360) * X ^ 5 + C (-28860) * X ^ 6 + C (-174280) * X ^ 7 + C (49576) * X ^ 8 + C (-150380) * X ^ 9 + C (-236016) * X ^ 10 + C (72800) * X ^ 11 + C (-291572) * X ^ 12 + C (-179112) * X ^ 13 + C (29852) * X ^ 14 + C (-362444) * X ^ 15 + C (-79232) * X ^ 16 + C (-57212) * X ^ 17 + C (-310740) * X ^ 18 + C (-12320) * X ^ 19 + C (-97876) * X ^ 20 + C (-161032) * X ^ 21 + C (4976) * X ^ 22 + C (-80420) * X ^ 23 + C (-60432) * X ^ 24 + C (-760) * X ^ 25 + C (-34020) * X ^ 26 + C (-13200) * X ^ 27
def DC111_4_pim : Polynomial ℚ := C (13980) + C (24504) * X + C (-5904) * X ^ 2 + C (64976) * X ^ 3 + C (45232) * X ^ 4 + C (-8888) * X ^ 5 + C (159276) * X ^ 6 + C (24104) * X ^ 7 + C (32500) * X ^ 8 + C (273480) * X ^ 9 + C (-44580) * X ^ 10 + C (127952) * X ^ 11 + C (273848) * X ^ 12 + C (-105048) * X ^ 13 + C (227968) * X ^ 14 + C (169488) * X ^ 15 + C (-95768) * X ^ 16 + C (254092) * X ^ 17 + C (43528) * X ^ 18 + C (-40072) * X ^ 19 + C (162988) * X ^ 20 + C (-25256) * X ^ 21 + C (7624) * X ^ 22 + C (70596) * X ^ 23 + C (-26404) * X ^ 24 + C (13740) * X ^ 25 + C (16760) * X ^ 26 + C (-9600) * X ^ 27
theorem DC111_4_ab_pre_eq :
    N_re_0_4 * N_re_1_3 - N_im_0_4 * N_im_1_3 =
      DC111_4_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_3, N_im_1_3, DC111_4_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_4_ab_pim_eq :
    N_re_0_4 * N_im_1_3 + N_im_0_4 * N_re_1_3 =
      DC111_4_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_4, N_im_0_4, N_re_1_3, N_im_1_3, DC111_4_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_4_ab_mul :
    N_entry_0_4 * N_entry_1_3 =
      ofLadj DC111_4_ab_pre DC111_4_ab_pim := by
  rw [N_entry_0_4, N_entry_1_3, ofLadj_mul,
    DC111_4_ab_pre_eq, DC111_4_ab_pim_eq]

theorem DC111_4_pre_eq :
    DC111_4_ab_pre * N_re_2_5 - DC111_4_ab_pim * N_im_2_5 =
      DC111_4_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_4_ab_pre, DC111_4_ab_pim, N_re_2_5, N_im_2_5, DC111_4_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_4_pim_eq :
    DC111_4_ab_pre * N_im_2_5 + DC111_4_ab_pim * N_re_2_5 =
      DC111_4_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_4_ab_pre, DC111_4_ab_pim, N_re_2_5, N_im_2_5, DC111_4_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_4_mul :
    N_entry_0_4 * N_entry_1_3 * N_entry_2_5 =
      ofLadj DC111_4_pre DC111_4_pim := by
  rw [DC111_4_ab_mul, N_entry_2_5, ofLadj_mul, DC111_4_pre_eq, DC111_4_pim_eq]

def DC111_4_spre : Polynomial ℚ := C (-5220) + C (25056) * X + C (8712) * X ^ 2 + C (-8164) * X ^ 3 + C (88556) * X ^ 4 + C (-6360) * X ^ 5 + C (28860) * X ^ 6 + C (174280) * X ^ 7 + C (-49576) * X ^ 8 + C (150380) * X ^ 9 + C (236016) * X ^ 10 + C (-72800) * X ^ 11 + C (291572) * X ^ 12 + C (179112) * X ^ 13 + C (-29852) * X ^ 14 + C (362444) * X ^ 15 + C (79232) * X ^ 16 + C (57212) * X ^ 17 + C (310740) * X ^ 18 + C (12320) * X ^ 19 + C (97876) * X ^ 20 + C (161032) * X ^ 21 + C (-4976) * X ^ 22 + C (80420) * X ^ 23 + C (60432) * X ^ 24 + C (760) * X ^ 25 + C (34020) * X ^ 26 + C (13200) * X ^ 27
def DC111_4_spim : Polynomial ℚ := C (-13980) + C (-24504) * X + C (5904) * X ^ 2 + C (-64976) * X ^ 3 + C (-45232) * X ^ 4 + C (8888) * X ^ 5 + C (-159276) * X ^ 6 + C (-24104) * X ^ 7 + C (-32500) * X ^ 8 + C (-273480) * X ^ 9 + C (44580) * X ^ 10 + C (-127952) * X ^ 11 + C (-273848) * X ^ 12 + C (105048) * X ^ 13 + C (-227968) * X ^ 14 + C (-169488) * X ^ 15 + C (95768) * X ^ 16 + C (-254092) * X ^ 17 + C (-43528) * X ^ 18 + C (40072) * X ^ 19 + C (-162988) * X ^ 20 + C (25256) * X ^ 21 + C (-7624) * X ^ 22 + C (-70596) * X ^ 23 + C (26404) * X ^ 24 + C (-13740) * X ^ 25 + C (-16760) * X ^ 26 + C (9600) * X ^ 27
theorem DC111_4_spre_eq : -DC111_4_pre = DC111_4_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_4_pre, DC111_4_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC111_4_spim_eq : -DC111_4_pim = DC111_4_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_4_pim, DC111_4_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC111_4_smul :
    -(N_entry_0_4 * N_entry_1_3 * N_entry_2_5) =
      ofLadj DC111_4_spre DC111_4_spim := by
  rw [DC111_4_mul, ofLadj_neg, DC111_4_spre_eq, DC111_4_spim_eq]

def DC111_5_ab_pre : Polynomial ℚ := C (-180) + C (144) * X + C (-36) * X ^ 2 + C (-324) * X ^ 3 + C (384) * X ^ 4 + C (-308) * X ^ 5 + C (-236) * X ^ 6 + C (564) * X ^ 7 + C (-660) * X ^ 8 + C (136) * X ^ 9 + C (552) * X ^ 10 + C (-576) * X ^ 11 + C (408) * X ^ 12 + C (172) * X ^ 13 + C (-336) * X ^ 14 + C (372) * X ^ 15 + C (-32) * X ^ 16 + C (-104) * X ^ 17 + C (192) * X ^ 18
def DC111_5_ab_pim : Polynomial ℚ := C (-180) + C (-360) * X + C (12) * X ^ 2 + C (-612) * X ^ 3 + C (-504) * X ^ 4 + C (-52) * X ^ 5 + C (-1100) * X ^ 6 + C (-396) * X ^ 7 + C (-324) * X ^ 8 + C (-1544) * X ^ 9 + C (-168) * X ^ 10 + C (-600) * X ^ 11 + C (-1032) * X ^ 12 + C (-28) * X ^ 13 + C (-624) * X ^ 14 + C (-516) * X ^ 15 + C (-16) * X ^ 16 + C (-392) * X ^ 17 + C (-144) * X ^ 18
def DC111_5_pre : Polynomial ℚ := C (5940) + C (-25056) * X + C (-9744) * X ^ 2 + C (7008) * X ^ 3 + C (-90876) * X ^ 4 + C (3760) * X ^ 5 + C (-31340) * X ^ 6 + C (-176904) * X ^ 7 + C (47904) * X ^ 8 + C (-150968) * X ^ 9 + C (-237416) * X ^ 10 + C (69032) * X ^ 11 + C (-292696) * X ^ 12 + C (-180152) * X ^ 13 + C (28464) * X ^ 14 + C (-358560) * X ^ 15 + C (-77228) * X ^ 16 + C (-53624) * X ^ 17 + C (-303300) * X ^ 18 + C (-10608) * X ^ 19 + C (-94568) * X ^ 20 + C (-155496) * X ^ 21 + C (7728) * X ^ 22 + C (-75160) * X ^ 23 + C (-55640) * X ^ 24 + C (1824) * X ^ 25 + C (-30768) * X ^ 26 + C (-11496) * X ^ 27
def DC111_5_pim : Polynomial ℚ := C (14400) + C (25416) * X + C (-5160) * X ^ 2 + C (67752) * X ^ 3 + C (50256) * X ^ 4 + C (-2364) * X ^ 5 + C (169268) * X ^ 6 + C (37504) * X ^ 7 + C (47608) * X ^ 8 + C (291548) * X ^ 9 + C (-23028) * X ^ 10 + C (150260) * X ^ 11 + C (298572) * X ^ 12 + C (-74656) * X ^ 13 + C (255896) * X ^ 14 + C (198280) * X ^ 15 + C (-64656) * X ^ 16 + C (278176) * X ^ 17 + C (67440) * X ^ 18 + C (-17152) * X ^ 19 + C (178840) * X ^ 20 + C (-8244) * X ^ 21 + C (21388) * X ^ 22 + C (79380) * X ^ 23 + C (-18476) * X ^ 24 + C (17992) * X ^ 25 + C (18616) * X ^ 26 + C (-8328) * X ^ 27
theorem DC111_5_ab_pre_eq :
    N_re_0_5 * N_re_1_4 - N_im_0_5 * N_im_1_4 =
      DC111_5_ab_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_4, N_im_1_4, DC111_5_ab_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_5_ab_pim_eq :
    N_re_0_5 * N_im_1_4 + N_im_0_5 * N_re_1_4 =
      DC111_5_ab_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [N_re_0_5, N_im_0_5, N_re_1_4, N_im_1_4, DC111_5_ab_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_5_ab_mul :
    N_entry_0_5 * N_entry_1_4 =
      ofLadj DC111_5_ab_pre DC111_5_ab_pim := by
  rw [N_entry_0_5, N_entry_1_4, ofLadj_mul,
    DC111_5_ab_pre_eq, DC111_5_ab_pim_eq]

theorem DC111_5_pre_eq :
    DC111_5_ab_pre * N_re_2_3 - DC111_5_ab_pim * N_im_2_3 =
      DC111_5_pre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_5_ab_pre, DC111_5_ab_pim, N_re_2_3, N_im_2_3, DC111_5_pre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_5_pim_eq :
    DC111_5_ab_pre * N_im_2_3 + DC111_5_ab_pim * N_re_2_3 =
      DC111_5_pim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_5_ab_pre, DC111_5_ab_pim, N_re_2_3, N_im_2_3, DC111_5_pim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring

theorem DC111_5_mul :
    N_entry_0_5 * N_entry_1_4 * N_entry_2_3 =
      ofLadj DC111_5_pre DC111_5_pim := by
  rw [DC111_5_ab_mul, N_entry_2_3, ofLadj_mul, DC111_5_pre_eq, DC111_5_pim_eq]

def DC111_5_spre : Polynomial ℚ := C (-5940) + C (25056) * X + C (9744) * X ^ 2 + C (-7008) * X ^ 3 + C (90876) * X ^ 4 + C (-3760) * X ^ 5 + C (31340) * X ^ 6 + C (176904) * X ^ 7 + C (-47904) * X ^ 8 + C (150968) * X ^ 9 + C (237416) * X ^ 10 + C (-69032) * X ^ 11 + C (292696) * X ^ 12 + C (180152) * X ^ 13 + C (-28464) * X ^ 14 + C (358560) * X ^ 15 + C (77228) * X ^ 16 + C (53624) * X ^ 17 + C (303300) * X ^ 18 + C (10608) * X ^ 19 + C (94568) * X ^ 20 + C (155496) * X ^ 21 + C (-7728) * X ^ 22 + C (75160) * X ^ 23 + C (55640) * X ^ 24 + C (-1824) * X ^ 25 + C (30768) * X ^ 26 + C (11496) * X ^ 27
def DC111_5_spim : Polynomial ℚ := C (-14400) + C (-25416) * X + C (5160) * X ^ 2 + C (-67752) * X ^ 3 + C (-50256) * X ^ 4 + C (2364) * X ^ 5 + C (-169268) * X ^ 6 + C (-37504) * X ^ 7 + C (-47608) * X ^ 8 + C (-291548) * X ^ 9 + C (23028) * X ^ 10 + C (-150260) * X ^ 11 + C (-298572) * X ^ 12 + C (74656) * X ^ 13 + C (-255896) * X ^ 14 + C (-198280) * X ^ 15 + C (64656) * X ^ 16 + C (-278176) * X ^ 17 + C (-67440) * X ^ 18 + C (17152) * X ^ 19 + C (-178840) * X ^ 20 + C (8244) * X ^ 21 + C (-21388) * X ^ 22 + C (-79380) * X ^ 23 + C (18476) * X ^ 24 + C (-17992) * X ^ 25 + C (-18616) * X ^ 26 + C (8328) * X ^ 27
theorem DC111_5_spre_eq : -DC111_5_pre = DC111_5_spre := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_5_pre, DC111_5_spre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC111_5_spim_eq : -DC111_5_pim = DC111_5_spim := by
  refine Polynomial.funext fun r => ?_
  simp only [DC111_5_pim, DC111_5_spim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero]
  try ring
theorem DC111_5_smul :
    -(N_entry_0_5 * N_entry_1_4 * N_entry_2_3) =
      ofLadj DC111_5_spre DC111_5_spim := by
  rw [DC111_5_mul, ofLadj_neg, DC111_5_spre_eq, DC111_5_spim_eq]

def detCoeff_111 : Ki :=
  N_entry_0_3 * N_entry_1_4 * N_entry_2_5 + N_entry_0_4 * N_entry_1_5 * N_entry_2_3 + N_entry_0_5 * N_entry_1_3 * N_entry_2_4 + (-(N_entry_0_3 * N_entry_1_5 * N_entry_2_4)) + (-(N_entry_0_4 * N_entry_1_3 * N_entry_2_5)) + (-(N_entry_0_5 * N_entry_1_4 * N_entry_2_3))

theorem detCoeff_111_sum :
    detCoeff_111 = ofLadj (DC111_0_pre + DC111_1_pre + DC111_2_pre + DC111_3_spre + DC111_4_spre + DC111_5_spre) (DC111_0_pim + DC111_1_pim + DC111_2_pim + DC111_3_spim + DC111_4_spim + DC111_5_spim) := by
  simp only [detCoeff_111, DC111_0_mul, DC111_1_mul, DC111_2_mul, DC111_3_smul, DC111_4_smul, DC111_5_smul]
  simpa [add_assoc] using ofLadj_add6 DC111_0_pre DC111_0_pim DC111_1_pre DC111_1_pim DC111_2_pre DC111_2_pim DC111_3_spre DC111_3_spim DC111_4_spre DC111_4_spim DC111_5_spre DC111_5_spim

def DC111_qre : Polynomial ℚ := C (270) + C (78) * X + C (119) * X ^ 2 + C (-113) * X ^ 3 + C (-226) * X ^ 4 + C (-448) * X ^ 5 + C (-480) * X ^ 6 + C (-435) * X ^ 7 + C (-235) * X ^ 8 + C (-90) * X ^ 9 + C (132) * X ^ 10 + C (242) * X ^ 11 + C (360) * X ^ 12 + C (356) * X ^ 13 + C (284) * X ^ 14 + C (152) * X ^ 15 + C (116) * X ^ 16 + C (40) * X ^ 17
def DC111_qim : Polynomial ℚ := C (-111) + C (-111) * X + C (-124) * X ^ 2 + C (29) * X ^ 3 + C (78) * X ^ 4 + C (171) * X ^ 5 + C (680) * X ^ 6 + C (750) * X ^ 7 + C (1097) * X ^ 8 + C (1182) * X ^ 9 + C (1110) * X ^ 10 + C (988) * X ^ 11 + C (776) * X ^ 12 + C (512) * X ^ 13 + C (286) * X ^ 14 + C (136) * X ^ 15 + C (62) * X ^ 16 + C (-40) * X ^ 17

theorem detCoeff_111_sum_poly_re :
    DC111_0_pre + DC111_1_pre + DC111_2_pre + DC111_3_spre + DC111_4_spre + DC111_5_spre = Fplus_re_111 + Phi11 * DC111_qre := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC111_0_pre, DC111_1_pre, DC111_2_pre, DC111_3_spre, DC111_4_spre, DC111_5_spre, Fplus_re_111, DC111_qre]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring

theorem detCoeff_111_sum_poly_im :
    DC111_0_pim + DC111_1_pim + DC111_2_pim + DC111_3_spim + DC111_4_spim + DC111_5_spim = Fplus_im_111 + Phi11 * DC111_qim := by
  refine Polynomial.funext fun r => ?_
  rw [Phi11_expand]
  simp only [DC111_0_pim, DC111_1_pim, DC111_2_pim, DC111_3_spim, DC111_4_spim, DC111_5_spim, Fplus_im_111, DC111_qim]
  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,
    Polynomial.eval_neg, Polynomial.eval_zero, Polynomial.eval_one]
  try ring

theorem detCoeff_111_eq :
    detCoeff_111 = ofLadj Fplus_re_111 Fplus_im_111 := by
  rw [detCoeff_111_sum, detCoeff_111_sum_poly_re,
    detCoeff_111_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
