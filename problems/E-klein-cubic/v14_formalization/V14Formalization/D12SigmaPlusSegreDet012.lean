/-
Auto-generated Fplus / det(bilinearN) coefficient identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12PolyZReflection
public import V14Formalization.D12SigmaPlusSegreApplyN
public import V14Formalization.D12SigmaPlusSegreFplusZ

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

def DC012_0_pre : Polynomial ℚ := interpQ 2 [96, 0, 104, 180, 40, 208, 184, 8, 264, 76, -16, 152, -16, -28, 84, -64, 8, 32, -32]
def DC012_0_pim : Polynomial ℚ := interpQ 2 [48, 96, -24, 132, 72, -56, 176, -8, -8, 260, -24, 72, 168, 4, 116, 112, 40, 80, 64]
theorem DC012_0_pre_eq :
    N_re_0_0 * N_re_1_4 - N_im_0_0 * N_im_1_4 =
      DC012_0_pre := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_4, z_N_im_1_4, DC012_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_0_pim_eq :
    N_re_0_0 * N_im_1_4 + N_im_0_0 * N_re_1_4 =
      DC012_0_pim := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_4, z_N_im_1_4, DC012_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_0_mul :
    N_entry_0_0 * N_entry_1_4 =
      ofLadj DC012_0_pre DC012_0_pim := by
  rw [N_entry_0_0, N_entry_1_4, ofLadj_mul,
    DC012_0_pre_eq, DC012_0_pim_eq]

def DC012_1_pre : Polynomial ℚ := interpQ 2 [446, -768, -302, 801, -2019, 610, 339, -2780, 1812, -1220, -2782, 1762, -2014, -918, 1011, -1601, -45, 226, -840]
def DC012_1_pim : Polynomial ℚ := interpQ 2 [728, 1456, 158, 2475, 2177, 644, 4535, 2032, 1688, 6348, 1076, 2672, 4268, 294, 2637, 2111, 29, 1592, 480]
theorem DC012_1_pre_eq :
    N_re_0_1 * N_re_1_3 - N_im_0_1 * N_im_1_3 =
      DC012_1_pre := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_3, z_N_im_1_3, DC012_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_1_pim_eq :
    N_re_0_1 * N_im_1_3 + N_im_0_1 * N_re_1_3 =
      DC012_1_pim := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_3, z_N_im_1_3, DC012_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_1_mul :
    N_entry_0_1 * N_entry_1_3 =
      ofLadj DC012_1_pre DC012_1_pim := by
  rw [N_entry_0_1, N_entry_1_3, ofLadj_mul,
    DC012_1_pre_eq, DC012_1_pim_eq]

def DC012_1_spre : Polynomial ℚ := interpQ 2 [-446, 768, 302, -801, 2019, -610, -339, 2780, -1812, 1220, 2782, -1762, 2014, 918, -1011, 1601, 45, -226, 840]
def DC012_1_spim : Polynomial ℚ := interpQ 2 [-728, -1456, -158, -2475, -2177, -644, -4535, -2032, -1688, -6348, -1076, -2672, -4268, -294, -2637, -2111, -29, -1592, -480]
theorem DC012_1_spre_eq : -DC012_1_pre = DC012_1_spre := by
  simp only [DC012_1_pre, DC012_1_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC012_1_spim_eq : -DC012_1_pim = DC012_1_spim := by
  simp only [DC012_1_pim, DC012_1_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC012_1_smul :
    -(N_entry_0_1 * N_entry_1_3) =
      ofLadj DC012_1_spre DC012_1_spim := by
  rw [DC012_1_mul, ofLadj_neg, DC012_1_spre_eq, DC012_1_spim_eq]

def DC012_2_pre : Polynomial ℚ := interpQ 2 [176, 0, 200, 340, 40, 372, 324, -40, 488, 140, -28, 328, -28, -60, 148, -152, -12, 36, -72]
def DC012_2_pim : Polynomial ℚ := interpQ 2 [96, 192, -56, 236, 136, -116, 356, 0, 32, 556, -28, 144, 316, -20, 212, 208, 68, 172, 136]
theorem DC012_2_pre_eq :
    N_re_0_0 * N_re_2_5 - N_im_0_0 * N_im_2_5 =
      DC012_2_pre := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_2_5, z_N_im_2_5, DC012_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_2_pim_eq :
    N_re_0_0 * N_im_2_5 + N_im_0_0 * N_re_2_5 =
      DC012_2_pim := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_2_5, z_N_im_2_5, DC012_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_2_mul :
    N_entry_0_0 * N_entry_2_5 =
      ofLadj DC012_2_pre DC012_2_pim := by
  rw [N_entry_0_0, N_entry_2_5, ofLadj_mul,
    DC012_2_pre_eq, DC012_2_pim_eq]

def DC012_3_pre : Polynomial ℚ := interpQ 2 [537, -564, -203, 917, -1746, 500, 228, -2910, 1247, -1507, -2918, 1160, -2354, -1304, 330, -2068, -462, -190, -904]
def DC012_3_pim : Polynomial ℚ := interpQ 2 [621, 1242, -235, 1633, 1268, -410, 3152, 878, 423, 4717, -186, 1304, 2794, -632, 1794, 1424, -206, 1314, 280]
theorem DC012_3_pre_eq :
    N_re_0_2 * N_re_2_3 - N_im_0_2 * N_im_2_3 =
      DC012_3_pre := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_2_3, z_N_im_2_3, DC012_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_3_pim_eq :
    N_re_0_2 * N_im_2_3 + N_im_0_2 * N_re_2_3 =
      DC012_3_pim := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_2_3, z_N_im_2_3, DC012_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_3_mul :
    N_entry_0_2 * N_entry_2_3 =
      ofLadj DC012_3_pre DC012_3_pim := by
  rw [N_entry_0_2, N_entry_2_3, ofLadj_mul,
    DC012_3_pre_eq, DC012_3_pim_eq]

def DC012_3_spre : Polynomial ℚ := interpQ 2 [-537, 564, 203, -917, 1746, -500, -228, 2910, -1247, 1507, 2918, -1160, 2354, 1304, -330, 2068, 462, 190, 904]
def DC012_3_spim : Polynomial ℚ := interpQ 2 [-621, -1242, 235, -1633, -1268, 410, -3152, -878, -423, -4717, 186, -1304, -2794, 632, -1794, -1424, 206, -1314, -280]
theorem DC012_3_spre_eq : -DC012_3_pre = DC012_3_spre := by
  simp only [DC012_3_pre, DC012_3_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC012_3_spim_eq : -DC012_3_pim = DC012_3_spim := by
  simp only [DC012_3_pim, DC012_3_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC012_3_smul :
    -(N_entry_0_2 * N_entry_2_3) =
      ofLadj DC012_3_spre DC012_3_spim := by
  rw [DC012_3_mul, ofLadj_neg, DC012_3_spre_eq, DC012_3_spim_eq]

def DC012_4_pre : Polynomial ℚ := interpQ 2 [684, -608, 196, 1217, -1545, 1056, 793, -2432, 2228, -810, -2370, 1934, -1762, -1006, 1011, -1659, -73, 190, -772]
def DC012_4_pim : Polynomial ℚ := interpQ 2 [722, 1444, 0, 2259, 1879, 130, 4153, 1400, 1268, 5930, 660, 2264, 3868, 42, 2445, 1997, 129, 1560, 696]
theorem DC012_4_pre_eq :
    N_re_0_3 * N_re_1_1 - N_im_0_3 * N_im_1_1 =
      DC012_4_pre := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_1, z_N_im_1_1, DC012_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_4_pim_eq :
    N_re_0_3 * N_im_1_1 + N_im_0_3 * N_re_1_1 =
      DC012_4_pim := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_1, z_N_im_1_1, DC012_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_4_mul :
    N_entry_0_3 * N_entry_1_1 =
      ofLadj DC012_4_pre DC012_4_pim := by
  rw [N_entry_0_3, N_entry_1_1, ofLadj_mul,
    DC012_4_pre_eq, DC012_4_pim_eq]

def DC012_5_pre : Polynomial ℚ := interpQ 2 [24, -48, -36, 44, -100, 68, 40, -92, 140, -40, -128, 96, -80, -4, 96, -28, 28, 56, -36]
def DC012_5_pim : Polynomial ℚ := interpQ 2 [48, 96, 36, 204, 172, 116, 304, 188, 140, 392, 128, 216, 304, 100, 184, 156, 20, 88, 12]
theorem DC012_5_pre_eq :
    N_re_0_4 * N_re_1_0 - N_im_0_4 * N_im_1_0 =
      DC012_5_pre := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_0, z_N_im_1_0, DC012_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_5_pim_eq :
    N_re_0_4 * N_im_1_0 + N_im_0_4 * N_re_1_0 =
      DC012_5_pim := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_0, z_N_im_1_0, DC012_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_5_mul :
    N_entry_0_4 * N_entry_1_0 =
      ofLadj DC012_5_pre DC012_5_pim := by
  rw [N_entry_0_4, N_entry_1_0, ofLadj_mul,
    DC012_5_pre_eq, DC012_5_pim_eq]

def DC012_5_spre : Polynomial ℚ := interpQ 2 [-24, 48, 36, -44, 100, -68, -40, 92, -140, 40, 128, -96, 80, 4, -96, 28, -28, -56, 36]
def DC012_5_spim : Polynomial ℚ := interpQ 2 [-48, -96, -36, -204, -172, -116, -304, -188, -140, -392, -128, -216, -304, -100, -184, -156, -20, -88, -12]
theorem DC012_5_spre_eq : -DC012_5_pre = DC012_5_spre := by
  simp only [DC012_5_pre, DC012_5_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC012_5_spim_eq : -DC012_5_pim = DC012_5_spim := by
  simp only [DC012_5_pim, DC012_5_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC012_5_smul :
    -(N_entry_0_4 * N_entry_1_0) =
      ofLadj DC012_5_spre DC012_5_spim := by
  rw [DC012_5_mul, ofLadj_neg, DC012_5_spre_eq, DC012_5_spim_eq]

def DC012_6_pre : Polynomial ℚ := interpQ 2 [722, -456, 228, 1330, -1130, 1320, 1288, -1524, 2984, 228, -1186, 2704, -730, 0, 1654, -946, 460, 492, -552]
def DC012_6_pim : Polynomial ℚ := interpQ 2 [646, 1292, 12, 2266, 2094, 460, 4312, 1908, 1712, 6004, 1102, 2572, 4042, 420, 2458, 1898, 220, 1444, 536]
theorem DC012_6_pre_eq :
    N_re_0_3 * N_re_2_2 - N_im_0_3 * N_im_2_2 =
      DC012_6_pre := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_2_2, z_N_im_2_2, DC012_6_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_6_pim_eq :
    N_re_0_3 * N_im_2_2 + N_im_0_3 * N_re_2_2 =
      DC012_6_pim := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_2_2, z_N_im_2_2, DC012_6_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_6_mul :
    N_entry_0_3 * N_entry_2_2 =
      ofLadj DC012_6_pre DC012_6_pim := by
  rw [N_entry_0_3, N_entry_2_2, ofLadj_mul,
    DC012_6_pre_eq, DC012_6_pim_eq]

def DC012_7_pre : Polynomial ℚ := interpQ 2 [-24, -96, -72, 62, -244, 36, 8, -334, 114, -226, -386, 156, -290, -154, 52, -234, -50, -22, -144]
def DC012_7_pim : Polynomial ℚ := interpQ 2 [72, 144, 24, 242, 216, 84, 428, 214, 162, 674, 98, 288, 478, 22, 316, 242, -6, 214, 48]
theorem DC012_7_pre_eq :
    N_re_0_5 * N_re_2_0 - N_im_0_5 * N_im_2_0 =
      DC012_7_pre := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_2_0, z_N_im_2_0, DC012_7_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_7_pim_eq :
    N_re_0_5 * N_im_2_0 + N_im_0_5 * N_re_2_0 =
      DC012_7_pim := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_2_0, z_N_im_2_0, DC012_7_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_7_mul :
    N_entry_0_5 * N_entry_2_0 =
      ofLadj DC012_7_pre DC012_7_pim := by
  rw [N_entry_0_5, N_entry_2_0, ofLadj_mul,
    DC012_7_pre_eq, DC012_7_pim_eq]

def DC012_7_spre : Polynomial ℚ := interpQ 2 [24, 96, 72, -62, 244, -36, -8, 334, -114, 226, 386, -156, 290, 154, -52, 234, 50, 22, 144]
def DC012_7_spim : Polynomial ℚ := interpQ 2 [-72, -144, -24, -242, -216, -84, -428, -214, -162, -674, -98, -288, -478, -22, -316, -242, 6, -214, -48]
theorem DC012_7_spre_eq : -DC012_7_pre = DC012_7_spre := by
  simp only [DC012_7_pre, DC012_7_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC012_7_spim_eq : -DC012_7_pim = DC012_7_spim := by
  simp only [DC012_7_pim, DC012_7_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC012_7_smul :
    -(N_entry_0_5 * N_entry_2_0) =
      ofLadj DC012_7_spre DC012_7_spim := by
  rw [DC012_7_mul, ofLadj_neg, DC012_7_spre_eq, DC012_7_spim_eq]

def DC012_8_pre : Polynomial ℚ := interpQ 2 [-388, 384, -100, -722, 970, -622, -452, 1556, -1316, 574, 1522, -1188, 1138, 674, -594, 1078, 100, -70, 492]
def DC012_8_pim : Polynomial ℚ := interpQ 2 [-440, -880, -8, -1362, -1122, -54, -2544, -844, -756, -3646, -394, -1376, -2358, 22, -1514, -1230, -64, -970, -436]
theorem DC012_8_pre_eq :
    N_re_1_1 * N_re_2_5 - N_im_1_1 * N_im_2_5 =
      DC012_8_pre := by
  simp only [z_N_re_1_1, z_N_im_1_1, z_N_re_2_5, z_N_im_2_5, DC012_8_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_8_pim_eq :
    N_re_1_1 * N_im_2_5 + N_im_1_1 * N_re_2_5 =
      DC012_8_pim := by
  simp only [z_N_re_1_1, z_N_im_1_1, z_N_re_2_5, z_N_im_2_5, DC012_8_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_8_mul :
    N_entry_1_1 * N_entry_2_5 =
      ofLadj DC012_8_pre DC012_8_pim := by
  rw [N_entry_1_1, N_entry_2_5, ofLadj_mul,
    DC012_8_pre_eq, DC012_8_pim_eq]

def DC012_9_pre : Polynomial ℚ := interpQ 2 [-148, 288, 98, -166, 656, -100, -50, 804, -536, 318, 746, -532, 458, 220, -370, 366, -54, -104, 218]
def DC012_9_pim : Polynomial ℚ := interpQ 2 [-252, -504, -138, -894, -868, -460, -1670, -936, -928, -2254, -750, -1140, -1530, -392, -962, -754, -146, -508, -226]
theorem DC012_9_pre_eq :
    N_re_1_2 * N_re_2_4 - N_im_1_2 * N_im_2_4 =
      DC012_9_pre := by
  simp only [z_N_re_1_2, z_N_im_1_2, z_N_re_2_4, z_N_im_2_4, DC012_9_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_9_pim_eq :
    N_re_1_2 * N_im_2_4 + N_im_1_2 * N_re_2_4 =
      DC012_9_pim := by
  simp only [z_N_re_1_2, z_N_im_1_2, z_N_re_2_4, z_N_im_2_4, DC012_9_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_9_mul :
    N_entry_1_2 * N_entry_2_4 =
      ofLadj DC012_9_pre DC012_9_pim := by
  rw [N_entry_1_2, N_entry_2_4, ofLadj_mul,
    DC012_9_pre_eq, DC012_9_pim_eq]

def DC012_9_spre : Polynomial ℚ := interpQ 2 [148, -288, -98, 166, -656, 100, 50, -804, 536, -318, -746, 532, -458, -220, 370, -366, 54, 104, -218]
def DC012_9_spim : Polynomial ℚ := interpQ 2 [252, 504, 138, 894, 868, 460, 1670, 936, 928, 2254, 750, 1140, 1530, 392, 962, 754, 146, 508, 226]
theorem DC012_9_spre_eq : -DC012_9_pre = DC012_9_spre := by
  simp only [DC012_9_pre, DC012_9_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC012_9_spim_eq : -DC012_9_pim = DC012_9_spim := by
  simp only [DC012_9_pim, DC012_9_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC012_9_smul :
    -(N_entry_1_2 * N_entry_2_4) =
      ofLadj DC012_9_spre DC012_9_spim := by
  rw [DC012_9_mul, ofLadj_neg, DC012_9_spre_eq, DC012_9_spim_eq]

def DC012_10_pre : Polynomial ℚ := interpQ 2 [-228, 144, -64, -408, 340, -432, -416, 428, -976, -116, 312, -888, 168, -52, -568, 248, -160, -176, 160]
def DC012_10_pim : Polynomial ℚ := interpQ 2 [-204, -408, -24, -744, -676, -192, -1400, -652, -576, -1908, -400, -840, -1280, -156, -768, -600, -64, -432, -160]
theorem DC012_10_pre_eq :
    N_re_1_4 * N_re_2_2 - N_im_1_4 * N_im_2_2 =
      DC012_10_pre := by
  simp only [z_N_re_1_4, z_N_im_1_4, z_N_re_2_2, z_N_im_2_2, DC012_10_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_10_pim_eq :
    N_re_1_4 * N_im_2_2 + N_im_1_4 * N_re_2_2 =
      DC012_10_pim := by
  simp only [z_N_re_1_4, z_N_im_1_4, z_N_re_2_2, z_N_im_2_2, DC012_10_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_10_mul :
    N_entry_1_4 * N_entry_2_2 =
      ofLadj DC012_10_pre DC012_10_pim := by
  rw [N_entry_1_4, N_entry_2_2, ofLadj_mul,
    DC012_10_pre_eq, DC012_10_pim_eq]

def DC012_11_pre : Polynomial ℚ := interpQ 2 [-559, 312, -133, -871, 802, -874, -782, 1124, -1907, -11, 940, -1624, 628, 122, -1036, 682, -224, -316, 360]
def DC012_11_pim : Polynomial ℚ := interpQ 2 [-463, -926, -25, -1575, -1360, -240, -2874, -1176, -971, -3879, -604, -1564, -2524, -150, -1508, -1198, -72, -868, -320]
theorem DC012_11_pre_eq :
    N_re_1_5 * N_re_2_1 - N_im_1_5 * N_im_2_1 =
      DC012_11_pre := by
  simp only [z_N_re_1_5, z_N_im_1_5, z_N_re_2_1, z_N_im_2_1, DC012_11_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_11_pim_eq :
    N_re_1_5 * N_im_2_1 + N_im_1_5 * N_re_2_1 =
      DC012_11_pim := by
  simp only [z_N_re_1_5, z_N_im_1_5, z_N_re_2_1, z_N_im_2_1, DC012_11_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC012_11_mul :
    N_entry_1_5 * N_entry_2_1 =
      ofLadj DC012_11_pre DC012_11_pim := by
  rw [N_entry_1_5, N_entry_2_1, ofLadj_mul,
    DC012_11_pre_eq, DC012_11_pim_eq]

def DC012_11_spre : Polynomial ℚ := interpQ 2 [559, -312, 133, 871, -802, 874, 782, -1124, 1907, 11, -940, 1624, -628, -122, 1036, -682, 224, 316, -360]
def DC012_11_spim : Polynomial ℚ := interpQ 2 [463, 926, 25, 1575, 1360, 240, 2874, 1176, 971, 3879, 604, 1564, 2524, 150, 1508, 1198, 72, 868, 320]
theorem DC012_11_spre_eq : -DC012_11_pre = DC012_11_spre := by
  simp only [DC012_11_pre, DC012_11_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC012_11_spim_eq : -DC012_11_pim = DC012_11_spim := by
  simp only [DC012_11_pim, DC012_11_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
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

def DC012_qre : Polynomial ℚ := interpQ 2 [738, -398, 856, -86, 264, 258, 276, 284, 570]
def DC012_qim : Polynomial ℚ := interpQ 2 [94, 94, -104, 582, 84, -306, 688, -540, 562]

theorem detCoeff_012_sum_poly_re :
    DC012_0_pre + DC012_1_spre + DC012_2_pre + DC012_3_spre + DC012_4_pre + DC012_5_spre + DC012_6_pre + DC012_7_spre + DC012_8_pre + DC012_9_spre + DC012_10_pre + DC012_11_spre = Fplus_re_012 + Phi11 * DC012_qre := by
  rw [phi11_interpQ]
  simp only [DC012_0_pre, DC012_1_spre, DC012_2_pre, DC012_3_spre, DC012_4_pre, DC012_5_spre, DC012_6_pre, DC012_7_spre, DC012_8_pre, DC012_9_spre, DC012_10_pre, DC012_11_spre, z_Fplus_re_012, DC012_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem detCoeff_012_sum_poly_im :
    DC012_0_pim + DC012_1_spim + DC012_2_pim + DC012_3_spim + DC012_4_pim + DC012_5_spim + DC012_6_pim + DC012_7_spim + DC012_8_pim + DC012_9_spim + DC012_10_pim + DC012_11_spim = Fplus_im_012 + Phi11 * DC012_qim := by
  rw [phi11_interpQ]
  simp only [DC012_0_pim, DC012_1_spim, DC012_2_pim, DC012_3_spim, DC012_4_pim, DC012_5_spim, DC012_6_pim, DC012_7_spim, DC012_8_pim, DC012_9_spim, DC012_10_pim, DC012_11_spim, z_Fplus_im_012, DC012_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

public theorem detCoeff_012_eq :
    detCoeff_012 = ofLadj Fplus_re_012 Fplus_im_012 := by
  rw [detCoeff_012_sum, detCoeff_012_sum_poly_re,
    detCoeff_012_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
