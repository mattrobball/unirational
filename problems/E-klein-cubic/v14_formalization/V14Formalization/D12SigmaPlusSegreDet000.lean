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

def DC000_0_ab_pre : Polynomial ℚ := interpQ 4 [-176, 0, -200, -244, 8, -216, -176, 112, -340, -164, 8, -344, 8, 36, -96, 152, 32, -8, 48]
def DC000_0_ab_pim : Polynomial ℚ := interpQ 4 [-64, -128, 104, -108, -56, 176, -308, 20, -108, -484, 4, -96, -196, 60, -104, -156, -36, -152, -128]
def DC000_0_pre : Polynomial ℚ := interpQ 4 [-1744, 768, -2576, -4616, 1224, -7168, -5700, 3172, -13784, -1568, 2232, -17144, 4716, -1512, -12288, 10344, -3676, -3928, 10060, -2608, 1288, 6552, -264, 3300, 3808, 512, 1664, 1216]
def DC000_0_pim : Polynomial ℚ := interpQ 4 [-1232, -2464, 640, -5328, -3464, 1184, -11820, -1012, -3832, -19448, 752, -10840, -18748, 2432, -15680, -13144, 756, -16952, -7388, -632, -10192, -1576, -1408, -4924, -392, -1488, -1952, -128]
theorem DC000_0_ab_pre_eq :
    N_re_0_0 * N_re_1_1 - N_im_0_0 * N_im_1_1 =
      DC000_0_ab_pre := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_1, z_N_im_1_1, DC000_0_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_0_ab_pim_eq :
    N_re_0_0 * N_im_1_1 + N_im_0_0 * N_re_1_1 =
      DC000_0_ab_pim := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_1, z_N_im_1_1, DC000_0_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_0_ab_mul :
    N_entry_0_0 * N_entry_1_1 =
      ofLadj DC000_0_ab_pre DC000_0_ab_pim := by
  rw [N_entry_0_0, N_entry_1_1, ofLadj_mul,
    DC000_0_ab_pre_eq, DC000_0_ab_pim_eq]

theorem DC000_0_pre_eq :
    DC000_0_ab_pre * N_re_2_2 - DC000_0_ab_pim * N_im_2_2 =
      DC000_0_pre := by
  simp only [DC000_0_ab_pre, DC000_0_ab_pim, z_N_re_2_2, z_N_im_2_2, DC000_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_0_pim_eq :
    DC000_0_ab_pre * N_im_2_2 + DC000_0_ab_pim * N_re_2_2 =
      DC000_0_pim := by
  simp only [DC000_0_ab_pre, DC000_0_ab_pim, z_N_re_2_2, z_N_im_2_2, DC000_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_0_mul :
    N_entry_0_0 * N_entry_1_1 * N_entry_2_2 =
      ofLadj DC000_0_pre DC000_0_pim := by
  rw [DC000_0_ab_mul, N_entry_2_2, ofLadj_mul, DC000_0_pre_eq, DC000_0_pim_eq]

def DC000_1_ab_pre : Polynomial ℚ := interpQ 4 [-124, 384, 236, -72, 924, 20, 84, 1028, -572, 408, 848, -664, 464, 172, -500, 368, -84, -148, 264]
def DC000_1_ab_pim : Polynomial ℚ := interpQ 4 [-292, -584, -196, -1112, -1108, -740, -2148, -1396, -1348, -2912, -1120, -1544, -1968, -564, -1212, -928, -180, -604, -240]
def DC000_1_pre : Polynomial ℚ := interpQ 4 [584, 2336, 2728, 3574, 10084, 8148, 12970, 23132, 15634, 28768, 36332, 20990, 42330, 35958, 24236, 44550, 26372, 22510, 34818, 13346, 16096, 17452, 4910, 9118, 6178, 1170, 3316, 960]
def DC000_1_pim : Polynomial ℚ := interpQ 4 [-248, 272, 2008, -302, 1296, 4328, -3750, 2696, 1690, -10560, 4756, -5534, -15570, 3906, -16080, -14066, 912, -19778, -6230, -1314, -13760, -872, -2834, -5818, 1174, -1226, -928, 1056]
theorem DC000_1_ab_pre_eq :
    N_re_0_1 * N_re_1_2 - N_im_0_1 * N_im_1_2 =
      DC000_1_ab_pre := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_2, z_N_im_1_2, DC000_1_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_1_ab_pim_eq :
    N_re_0_1 * N_im_1_2 + N_im_0_1 * N_re_1_2 =
      DC000_1_ab_pim := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_2, z_N_im_1_2, DC000_1_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_1_ab_mul :
    N_entry_0_1 * N_entry_1_2 =
      ofLadj DC000_1_ab_pre DC000_1_ab_pim := by
  rw [N_entry_0_1, N_entry_1_2, ofLadj_mul,
    DC000_1_ab_pre_eq, DC000_1_ab_pim_eq]

theorem DC000_1_pre_eq :
    DC000_1_ab_pre * N_re_2_0 - DC000_1_ab_pim * N_im_2_0 =
      DC000_1_pre := by
  simp only [DC000_1_ab_pre, DC000_1_ab_pim, z_N_re_2_0, z_N_im_2_0, DC000_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_1_pim_eq :
    DC000_1_ab_pre * N_im_2_0 + DC000_1_ab_pim * N_re_2_0 =
      DC000_1_pim := by
  simp only [DC000_1_ab_pre, DC000_1_ab_pim, z_N_re_2_0, z_N_im_2_0, DC000_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_1_mul :
    N_entry_0_1 * N_entry_1_2 * N_entry_2_0 =
      ofLadj DC000_1_pre DC000_1_pim := by
  rw [DC000_1_ab_mul, N_entry_2_0, ofLadj_mul, DC000_1_pre_eq, DC000_1_pim_eq]

def DC000_2_ab_pre : Polynomial ℚ := interpQ 4 [-12, 48, 52, -4, 108, -12, 20, 140, -4, 116, 224, 16, 176, 64, 0, 64, 8, -24, 32]
def DC000_2_ab_pim : Polynomial ℚ := interpQ 4 [-36, -72, -16, -128, -108, -48, -200, -92, -72, -240, -56, -136, -216, -88, -144, -144, -16, -80]
def DC000_2_pre : Polynomial ℚ := interpQ 4 [-60, 2112, 2062, 1206, 7490, 2254, 5020, 13602, 2130, 13848, 20292, 3932, 24476, 17634, 7220, 26754, 12066, 9540, 22454, 6200, 9652, 11808, 1996, 5512, 3804, -96, 1812, 240]
def DC000_2_pim : Polynomial ℚ := interpQ 4 [-960, -1608, 354, -4058, -3166, -234, -9976, -2410, -2526, -15304, 2036, -7032, -15372, 3926, -13512, -11082, 3638, -14716, -3066, 744, -10100, -448, -2372, -5336, 396, -1376, -1004, 560]
theorem DC000_2_ab_pre_eq :
    N_re_0_2 * N_re_1_0 - N_im_0_2 * N_im_1_0 =
      DC000_2_ab_pre := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_0, z_N_im_1_0, DC000_2_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_2_ab_pim_eq :
    N_re_0_2 * N_im_1_0 + N_im_0_2 * N_re_1_0 =
      DC000_2_ab_pim := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_0, z_N_im_1_0, DC000_2_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_2_ab_mul :
    N_entry_0_2 * N_entry_1_0 =
      ofLadj DC000_2_ab_pre DC000_2_ab_pim := by
  rw [N_entry_0_2, N_entry_1_0, ofLadj_mul,
    DC000_2_ab_pre_eq, DC000_2_ab_pim_eq]

theorem DC000_2_pre_eq :
    DC000_2_ab_pre * N_re_2_1 - DC000_2_ab_pim * N_im_2_1 =
      DC000_2_pre := by
  simp only [DC000_2_ab_pre, DC000_2_ab_pim, z_N_re_2_1, z_N_im_2_1, DC000_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_2_pim_eq :
    DC000_2_ab_pre * N_im_2_1 + DC000_2_ab_pim * N_re_2_1 =
      DC000_2_pim := by
  simp only [DC000_2_ab_pre, DC000_2_ab_pim, z_N_re_2_1, z_N_im_2_1, DC000_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_2_mul :
    N_entry_0_2 * N_entry_1_0 * N_entry_2_1 =
      ofLadj DC000_2_pre DC000_2_pim := by
  rw [DC000_2_ab_mul, N_entry_2_1, ofLadj_mul, DC000_2_pre_eq, DC000_2_pim_eq]

def DC000_3_ab_pre : Polynomial ℚ := interpQ 4 [-80, 0, -112, -160, -72, -200, -192, -48, -224, -96, 16, -136, 16, 16, -64, 40, -16, -24, 16]
def DC000_3_ab_pim : Polynomial ℚ := interpQ 4 [-48, -96, 0, -120, -88, 32, -152, 24, -16, -200, 0, -72, -144, -40, -104, -112, -40, -80, -64]
def DC000_3_pre : Polynomial ℚ := interpQ 4 [-1648, 1248, -2312, -4452, 1288, -8112, -7088, 1216, -16240, -3468, 612, -18432, 3536, -2352, -13012, 9584, -3568, -3352, 11204, -872, 2524, 7500, 368, 3328, 3720, 352, 1548, 1240]
def DC000_3_pim : Polynomial ℚ := interpQ 4 [-1696, -3392, -728, -8044, -6728, -2952, -16576, -5648, -8680, -24348, -4028, -15592, -23424, -2304, -19516, -16608, -2040, -19032, -9620, -2600, -12092, -3676, -3112, -6280, -1328, -1960, -2196, -200]
theorem DC000_3_ab_pre_eq :
    N_re_0_0 * N_re_1_2 - N_im_0_0 * N_im_1_2 =
      DC000_3_ab_pre := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_2, z_N_im_1_2, DC000_3_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_3_ab_pim_eq :
    N_re_0_0 * N_im_1_2 + N_im_0_0 * N_re_1_2 =
      DC000_3_ab_pim := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_2, z_N_im_1_2, DC000_3_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_3_ab_mul :
    N_entry_0_0 * N_entry_1_2 =
      ofLadj DC000_3_ab_pre DC000_3_ab_pim := by
  rw [N_entry_0_0, N_entry_1_2, ofLadj_mul,
    DC000_3_ab_pre_eq, DC000_3_ab_pim_eq]

theorem DC000_3_pre_eq :
    DC000_3_ab_pre * N_re_2_1 - DC000_3_ab_pim * N_im_2_1 =
      DC000_3_pre := by
  simp only [DC000_3_ab_pre, DC000_3_ab_pim, z_N_re_2_1, z_N_im_2_1, DC000_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_3_pim_eq :
    DC000_3_ab_pre * N_im_2_1 + DC000_3_ab_pim * N_re_2_1 =
      DC000_3_pim := by
  simp only [DC000_3_ab_pre, DC000_3_ab_pim, z_N_re_2_1, z_N_im_2_1, DC000_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_3_mul :
    N_entry_0_0 * N_entry_1_2 * N_entry_2_1 =
      ofLadj DC000_3_pre DC000_3_pim := by
  rw [DC000_3_ab_mul, N_entry_2_1, ofLadj_mul, DC000_3_pre_eq, DC000_3_pim_eq]

def DC000_3_spre : Polynomial ℚ := interpQ 4 [1648, -1248, 2312, 4452, -1288, 8112, 7088, -1216, 16240, 3468, -612, 18432, -3536, 2352, 13012, -9584, 3568, 3352, -11204, 872, -2524, -7500, -368, -3328, -3720, -352, -1548, -1240]
def DC000_3_spim : Polynomial ℚ := interpQ 4 [1696, 3392, 728, 8044, 6728, 2952, 16576, 5648, 8680, 24348, 4028, 15592, 23424, 2304, 19516, 16608, 2040, 19032, 9620, 2600, 12092, 3676, 3112, 6280, 1328, 1960, 2196, 200]
theorem DC000_3_spre_eq : -DC000_3_pre = DC000_3_spre := by
  simp only [DC000_3_pre, DC000_3_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC000_3_spim_eq : -DC000_3_pim = DC000_3_spim := by
  simp only [DC000_3_pim, DC000_3_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC000_3_smul :
    -(N_entry_0_0 * N_entry_1_2 * N_entry_2_1) =
      ofLadj DC000_3_spre DC000_3_spim := by
  rw [DC000_3_mul, ofLadj_neg, DC000_3_spre_eq, DC000_3_spim_eq]

def DC000_4_ab_pre : Polynomial ℚ := interpQ 4 [-12, 128, 152, 84, 352, 100, 136, 320, -92, 68, 228, -256, 100, -84, -176, 28, -44, -80, 60]
def DC000_4_ab_pim : Polynomial ℚ := interpQ 4 [-76, -152, -60, -336, -360, -316, -728, -556, -572, -920, -460, -536, -612, -244, -316, -296, -16, -164, -12]
def DC000_4_pre : Polynomial ℚ := interpQ 4 [96, 2320, 2564, 2836, 10016, 6328, 10612, 19980, 9520, 21564, 27332, 10548, 30148, 22128, 10220, 28384, 11920, 7972, 20012, 2760, 5780, 8512, -916, 3376, 2652, -776, 1592, 336]
def DC000_4_pim : Polynomial ℚ := interpQ 4 [-872, -1360, 284, -4228, -3832, -2272, -13388, -8084, -11432, -26612, -12060, -23548, -33300, -14896, -32828, -30152, -14496, -31524, -17764, -10752, -19116, -6704, -6204, -7824, -908, -2008, -1416, 432]
theorem DC000_4_ab_pre_eq :
    N_re_0_1 * N_re_1_0 - N_im_0_1 * N_im_1_0 =
      DC000_4_ab_pre := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_0, z_N_im_1_0, DC000_4_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_4_ab_pim_eq :
    N_re_0_1 * N_im_1_0 + N_im_0_1 * N_re_1_0 =
      DC000_4_ab_pim := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_0, z_N_im_1_0, DC000_4_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_4_ab_mul :
    N_entry_0_1 * N_entry_1_0 =
      ofLadj DC000_4_ab_pre DC000_4_ab_pim := by
  rw [N_entry_0_1, N_entry_1_0, ofLadj_mul,
    DC000_4_ab_pre_eq, DC000_4_ab_pim_eq]

theorem DC000_4_pre_eq :
    DC000_4_ab_pre * N_re_2_2 - DC000_4_ab_pim * N_im_2_2 =
      DC000_4_pre := by
  simp only [DC000_4_ab_pre, DC000_4_ab_pim, z_N_re_2_2, z_N_im_2_2, DC000_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_4_pim_eq :
    DC000_4_ab_pre * N_im_2_2 + DC000_4_ab_pim * N_re_2_2 =
      DC000_4_pim := by
  simp only [DC000_4_ab_pre, DC000_4_ab_pim, z_N_re_2_2, z_N_im_2_2, DC000_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_4_mul :
    N_entry_0_1 * N_entry_1_0 * N_entry_2_2 =
      ofLadj DC000_4_pre DC000_4_pim := by
  rw [DC000_4_ab_mul, N_entry_2_2, ofLadj_mul, DC000_4_pre_eq, DC000_4_pim_eq]

def DC000_4_spre : Polynomial ℚ := interpQ 4 [-96, -2320, -2564, -2836, -10016, -6328, -10612, -19980, -9520, -21564, -27332, -10548, -30148, -22128, -10220, -28384, -11920, -7972, -20012, -2760, -5780, -8512, 916, -3376, -2652, 776, -1592, -336]
def DC000_4_spim : Polynomial ℚ := interpQ 4 [872, 1360, -284, 4228, 3832, 2272, 13388, 8084, 11432, 26612, 12060, 23548, 33300, 14896, 32828, 30152, 14496, 31524, 17764, 10752, 19116, 6704, 6204, 7824, 908, 2008, 1416, -432]
theorem DC000_4_spre_eq : -DC000_4_pre = DC000_4_spre := by
  simp only [DC000_4_pre, DC000_4_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC000_4_spim_eq : -DC000_4_pim = DC000_4_spim := by
  simp only [DC000_4_pim, DC000_4_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC000_4_smul :
    -(N_entry_0_1 * N_entry_1_0 * N_entry_2_2) =
      ofLadj DC000_4_spre DC000_4_spim := by
  rw [DC000_4_mul, ofLadj_neg, DC000_4_spre_eq, DC000_4_spim_eq]

def DC000_5_ab_pre : Polynomial ℚ := interpQ 4 [-216, 192, 4, -374, 618, -200, -76, 1062, -470, 520, 956, -464, 764, 516, -96, 796, 244, 120, 352]
def DC000_5_ab_pim : Polynomial ℚ := interpQ 4 [-228, -456, 100, -558, -382, 196, -1088, -270, -138, -1712, 92, -400, -892, 356, -560, -444, 92, -456, -160]
def DC000_5_pre : Polynomial ℚ := interpQ 4 [456, 1824, 1624, 860, 5516, 1482, 3235, 10947, 813, 10992, 17022, -388, 19714, 13254, 2013, 23931, 7627, 6514, 21364, 2416, 8172, 11174, 594, 6658, 4286, 356, 2864, 640]
def DC000_5_pim : Polynomial ℚ := interpQ 4 [-432, -480, 776, -1950, -1028, 2172, -5319, 1827, 2985, -8150, 8642, 618, -7702, 13800, -4427, -1075, 14929, -6246, 6788, 9516, -4140, 7382, 3286, -898, 4658, 820, 432, 1408]
theorem DC000_5_ab_pre_eq :
    N_re_0_2 * N_re_1_1 - N_im_0_2 * N_im_1_1 =
      DC000_5_ab_pre := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_1, z_N_im_1_1, DC000_5_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_5_ab_pim_eq :
    N_re_0_2 * N_im_1_1 + N_im_0_2 * N_re_1_1 =
      DC000_5_ab_pim := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_1, z_N_im_1_1, DC000_5_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_5_ab_mul :
    N_entry_0_2 * N_entry_1_1 =
      ofLadj DC000_5_ab_pre DC000_5_ab_pim := by
  rw [N_entry_0_2, N_entry_1_1, ofLadj_mul,
    DC000_5_ab_pre_eq, DC000_5_ab_pim_eq]

theorem DC000_5_pre_eq :
    DC000_5_ab_pre * N_re_2_0 - DC000_5_ab_pim * N_im_2_0 =
      DC000_5_pre := by
  simp only [DC000_5_ab_pre, DC000_5_ab_pim, z_N_re_2_0, z_N_im_2_0, DC000_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_5_pim_eq :
    DC000_5_ab_pre * N_im_2_0 + DC000_5_ab_pim * N_re_2_0 =
      DC000_5_pim := by
  simp only [DC000_5_ab_pre, DC000_5_ab_pim, z_N_re_2_0, z_N_im_2_0, DC000_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC000_5_mul :
    N_entry_0_2 * N_entry_1_1 * N_entry_2_0 =
      ofLadj DC000_5_pre DC000_5_pim := by
  rw [DC000_5_ab_mul, N_entry_2_0, ofLadj_mul, DC000_5_pre_eq, DC000_5_pim_eq]

def DC000_5_spre : Polynomial ℚ := interpQ 4 [-456, -1824, -1624, -860, -5516, -1482, -3235, -10947, -813, -10992, -17022, 388, -19714, -13254, -2013, -23931, -7627, -6514, -21364, -2416, -8172, -11174, -594, -6658, -4286, -356, -2864, -640]
def DC000_5_spim : Polynomial ℚ := interpQ 4 [432, 480, -776, 1950, 1028, -2172, 5319, -1827, -2985, 8150, -8642, -618, 7702, -13800, 4427, 1075, -14929, 6246, -6788, -9516, 4140, -7382, -3286, 898, -4658, -820, -432, -1408]
theorem DC000_5_spre_eq : -DC000_5_pre = DC000_5_spre := by
  simp only [DC000_5_pre, DC000_5_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC000_5_spim_eq : -DC000_5_pim = DC000_5_spim := by
  simp only [DC000_5_pim, DC000_5_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
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

def DC000_qre : Polynomial ℚ := interpQ 4 [-130, -46, 510, 581, 1064, 1554, 1995, 2236, 2118, 2074, 1934, 2030, 2028, 1436, 1478, 866, 588, 200]
def DC000_qim : Polynomial ℚ := interpQ 4 [560, 872, 1240, 1863, 1718, 2078, 1405, 1444, 1278, 1338, 1194, 686, 492, 168, -302, -238, -552, -152]

theorem detCoeff_000_sum_poly_re :
    DC000_0_pre + DC000_1_pre + DC000_2_pre + DC000_3_spre + DC000_4_spre + DC000_5_spre = Fplus_re_000 + Phi11 * DC000_qre := by
  rw [phi11_interpQ]
  simp only [DC000_0_pre, DC000_1_pre, DC000_2_pre, DC000_3_spre, DC000_4_spre, DC000_5_spre, z_Fplus_re_000, DC000_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem detCoeff_000_sum_poly_im :
    DC000_0_pim + DC000_1_pim + DC000_2_pim + DC000_3_spim + DC000_4_spim + DC000_5_spim = Fplus_im_000 + Phi11 * DC000_qim := by
  rw [phi11_interpQ]
  simp only [DC000_0_pim, DC000_1_pim, DC000_2_pim, DC000_3_spim, DC000_4_spim, DC000_5_spim, z_Fplus_im_000, DC000_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

public theorem detCoeff_000_eq :
    detCoeff_000 = ofLadj Fplus_re_000 Fplus_im_000 := by
  rw [detCoeff_000_sum, detCoeff_000_sum_poly_re,
    detCoeff_000_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
