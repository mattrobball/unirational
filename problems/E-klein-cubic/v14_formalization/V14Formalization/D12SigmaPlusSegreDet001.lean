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

def DC001_0_ab_pre : Polynomial ℚ := interpQ 2 [-88, 0, -100, -122, 4, -108, -88, 56, -170, -82, 4, -172, 4, 18, -48, 76, 16, -4, 24]
def DC001_0_ab_pim : Polynomial ℚ := interpQ 2 [-32, -64, 52, -54, -28, 88, -154, 10, -54, -242, 2, -48, -98, 30, -52, -78, -18, -76, -64]
def DC001_0_pre : Polynomial ℚ := interpQ 2 [1552, -1536, 2056, 4708, -3168, 7644, 5076, -6464, 14588, -2572, -7228, 17492, -10508, -2488, 12204, -17572, 844, 1556, -17004, 1096, -3512, -10032, -412, -5216, -5652, -1228, -2728, -1856]
def DC001_0_pim : Polynomial ℚ := interpQ 2 [1760, 3520, 136, 8028, 5568, 628, 16544, 3364, 6224, 27012, 772, 16024, 25820, -2560, 21364, 16896, -2024, 21284, 8468, -264, 12448, 716, 376, 5492, -716, 968, 2024, -112]
theorem DC001_0_ab_pre_eq :
    N_re_0_0 * N_re_1_1 - N_im_0_0 * N_im_1_1 =
      DC001_0_ab_pre := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_1, z_N_im_1_1, DC001_0_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_0_ab_pim_eq :
    N_re_0_0 * N_im_1_1 + N_im_0_0 * N_re_1_1 =
      DC001_0_ab_pim := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_1, z_N_im_1_1, DC001_0_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_0_ab_mul :
    N_entry_0_0 * N_entry_1_1 =
      ofLadj DC001_0_ab_pre DC001_0_ab_pim := by
  rw [N_entry_0_0, N_entry_1_1, ofLadj_mul,
    DC001_0_ab_pre_eq, DC001_0_ab_pim_eq]

theorem DC001_0_pre_eq :
    DC001_0_ab_pre * N_re_2_5 - DC001_0_ab_pim * N_im_2_5 =
      DC001_0_pre := by
  simp only [DC001_0_ab_pre, DC001_0_ab_pim, z_N_re_2_5, z_N_im_2_5, DC001_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_0_pim_eq :
    DC001_0_ab_pre * N_im_2_5 + DC001_0_ab_pim * N_re_2_5 =
      DC001_0_pim := by
  simp only [DC001_0_ab_pre, DC001_0_ab_pim, z_N_re_2_5, z_N_im_2_5, DC001_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_0_mul :
    N_entry_0_0 * N_entry_1_1 * N_entry_2_5 =
      ofLadj DC001_0_pre DC001_0_pim := by
  rw [DC001_0_ab_mul, N_entry_2_5, ofLadj_mul, DC001_0_pre_eq, DC001_0_pim_eq]

def DC001_1_ab_pre : Polynomial ℚ := interpQ 2 [-62, 192, 118, -36, 462, 10, 42, 514, -286, 204, 424, -332, 232, 86, -250, 184, -42, -74, 132]
def DC001_1_ab_pim : Polynomial ℚ := interpQ 2 [-146, -292, -98, -556, -554, -370, -1074, -698, -674, -1456, -560, -772, -984, -282, -606, -464, -90, -302, -120]
def DC001_1_pre : Polynomial ℚ := interpQ 2 [72, -24572, -20222, -19068, -92948, -43474, -80878, -184878, -56412, -197142, -260872, -73456, -303484, -232010, -95554, -329296, -143000, -114686, -260448, -61472, -99448, -128580, -15432, -61396, -44358, -3262, -23082, -9090]
def DC001_1_pim : Polynomial ℚ := interpQ 2 [9706, 14900, -4294, 43386, 32320, 4258, 117906, 40464, 56212, 216960, 24782, 142340, 242998, 13288, 225268, 190970, 22726, 234352, 95582, 32700, 150146, 24986, 34896, 66218, -2216, 16318, 14548, -5358]
theorem DC001_1_ab_pre_eq :
    N_re_0_1 * N_re_1_2 - N_im_0_1 * N_im_1_2 =
      DC001_1_ab_pre := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_2, z_N_im_1_2, DC001_1_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_1_ab_pim_eq :
    N_re_0_1 * N_im_1_2 + N_im_0_1 * N_re_1_2 =
      DC001_1_ab_pim := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_2, z_N_im_1_2, DC001_1_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_1_ab_mul :
    N_entry_0_1 * N_entry_1_2 =
      ofLadj DC001_1_ab_pre DC001_1_ab_pim := by
  rw [N_entry_0_1, N_entry_1_2, ofLadj_mul,
    DC001_1_ab_pre_eq, DC001_1_ab_pim_eq]

theorem DC001_1_pre_eq :
    DC001_1_ab_pre * N_re_2_3 - DC001_1_ab_pim * N_im_2_3 =
      DC001_1_pre := by
  simp only [DC001_1_ab_pre, DC001_1_ab_pim, z_N_re_2_3, z_N_im_2_3, DC001_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_1_pim_eq :
    DC001_1_ab_pre * N_im_2_3 + DC001_1_ab_pim * N_re_2_3 =
      DC001_1_pim := by
  simp only [DC001_1_ab_pre, DC001_1_ab_pim, z_N_re_2_3, z_N_im_2_3, DC001_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_1_mul :
    N_entry_0_1 * N_entry_1_2 * N_entry_2_3 =
      ofLadj DC001_1_pre DC001_1_pim := by
  rw [DC001_1_ab_mul, N_entry_2_3, ofLadj_mul, DC001_1_pre_eq, DC001_1_pim_eq]

def DC001_2_ab_pre : Polynomial ℚ := interpQ 2 [-6, 24, 26, -2, 54, -6, 10, 70, -2, 58, 112, 8, 88, 32, 0, 32, 4, -12, 16]
def DC001_2_ab_pim : Polynomial ℚ := interpQ 2 [-18, -36, -8, -64, -54, -24, -100, -46, -36, -120, -28, -68, -108, -44, -72, -72, -8, -40]
def DC001_2_pre : Polynomial ℚ := interpQ 2 [-84, -1392, -1454, -1246, -5080, -2376, -4222, -9488, -3000, -9978, -13802, -4300, -16698, -12980, -6706, -18710, -9658, -7924, -15594, -5016, -7304, -8188, -2056, -3900, -2848, -64, -1292, -112]
def DC001_2_pim : Polynomial ℚ := interpQ 2 [468, 648, -598, 1606, 978, -880, 4646, -60, -96, 6960, -3626, 1272, 6202, -5662, 5222, 3550, -4750, 6456, 60, -2388, 5020, -912, 788, 2744, -664, 712, 528, -416]
theorem DC001_2_ab_pre_eq :
    N_re_0_2 * N_re_1_0 - N_im_0_2 * N_im_1_0 =
      DC001_2_ab_pre := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_0, z_N_im_1_0, DC001_2_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_2_ab_pim_eq :
    N_re_0_2 * N_im_1_0 + N_im_0_2 * N_re_1_0 =
      DC001_2_ab_pim := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_0, z_N_im_1_0, DC001_2_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_2_ab_mul :
    N_entry_0_2 * N_entry_1_0 =
      ofLadj DC001_2_ab_pre DC001_2_ab_pim := by
  rw [N_entry_0_2, N_entry_1_0, ofLadj_mul,
    DC001_2_ab_pre_eq, DC001_2_ab_pim_eq]

theorem DC001_2_pre_eq :
    DC001_2_ab_pre * N_re_2_4 - DC001_2_ab_pim * N_im_2_4 =
      DC001_2_pre := by
  simp only [DC001_2_ab_pre, DC001_2_ab_pim, z_N_re_2_4, z_N_im_2_4, DC001_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_2_pim_eq :
    DC001_2_ab_pre * N_im_2_4 + DC001_2_ab_pim * N_re_2_4 =
      DC001_2_pim := by
  simp only [DC001_2_ab_pre, DC001_2_ab_pim, z_N_re_2_4, z_N_im_2_4, DC001_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_2_mul :
    N_entry_0_2 * N_entry_1_0 * N_entry_2_4 =
      ofLadj DC001_2_pre DC001_2_pim := by
  rw [DC001_2_ab_mul, N_entry_2_4, ofLadj_mul, DC001_2_pre_eq, DC001_2_pim_eq]

def DC001_3_ab_pre : Polynomial ℚ := interpQ 2 [-40, 0, -56, -80, -36, -100, -96, -24, -112, -48, 8, -68, 8, 8, -32, 20, -8, -12, 8]
def DC001_3_ab_pim : Polynomial ℚ := interpQ 2 [-24, -48, 0, -60, -44, 16, -76, 12, -8, -100, 0, -36, -72, -20, -52, -56, -20, -40, -32]
def DC001_3_pre : Polynomial ℚ := interpQ 2 [592, -1152, 408, 1496, -2328, 3064, 2188, -2616, 7552, -340, -2560, 8684, -4336, -956, 5608, -8036, -40, -52, -9000, -1036, -2992, -5796, -1092, -2868, -2784, -588, -1252, -888]
def DC001_3_pim : Polynomial ℚ := interpQ 2 [1008, 2016, 760, 5264, 4736, 3236, 11328, 5608, 7184, 16776, 4484, 11336, 15724, 2584, 12980, 10656, 1552, 11708, 5608, 1400, 7180, 1920, 1576, 3696, 540, 1012, 1232, 16]
theorem DC001_3_ab_pre_eq :
    N_re_0_0 * N_re_1_2 - N_im_0_0 * N_im_1_2 =
      DC001_3_ab_pre := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_2, z_N_im_1_2, DC001_3_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_3_ab_pim_eq :
    N_re_0_0 * N_im_1_2 + N_im_0_0 * N_re_1_2 =
      DC001_3_ab_pim := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_2, z_N_im_1_2, DC001_3_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_3_ab_mul :
    N_entry_0_0 * N_entry_1_2 =
      ofLadj DC001_3_ab_pre DC001_3_ab_pim := by
  rw [N_entry_0_0, N_entry_1_2, ofLadj_mul,
    DC001_3_ab_pre_eq, DC001_3_ab_pim_eq]

theorem DC001_3_pre_eq :
    DC001_3_ab_pre * N_re_2_4 - DC001_3_ab_pim * N_im_2_4 =
      DC001_3_pre := by
  simp only [DC001_3_ab_pre, DC001_3_ab_pim, z_N_re_2_4, z_N_im_2_4, DC001_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_3_pim_eq :
    DC001_3_ab_pre * N_im_2_4 + DC001_3_ab_pim * N_re_2_4 =
      DC001_3_pim := by
  simp only [DC001_3_ab_pre, DC001_3_ab_pim, z_N_re_2_4, z_N_im_2_4, DC001_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_3_mul :
    N_entry_0_0 * N_entry_1_2 * N_entry_2_4 =
      ofLadj DC001_3_pre DC001_3_pim := by
  rw [DC001_3_ab_mul, N_entry_2_4, ofLadj_mul, DC001_3_pre_eq, DC001_3_pim_eq]

def DC001_3_spre : Polynomial ℚ := interpQ 2 [-592, 1152, -408, -1496, 2328, -3064, -2188, 2616, -7552, 340, 2560, -8684, 4336, 956, -5608, 8036, 40, 52, 9000, 1036, 2992, 5796, 1092, 2868, 2784, 588, 1252, 888]
def DC001_3_spim : Polynomial ℚ := interpQ 2 [-1008, -2016, -760, -5264, -4736, -3236, -11328, -5608, -7184, -16776, -4484, -11336, -15724, -2584, -12980, -10656, -1552, -11708, -5608, -1400, -7180, -1920, -1576, -3696, -540, -1012, -1232, -16]
theorem DC001_3_spre_eq : -DC001_3_pre = DC001_3_spre := by
  simp only [DC001_3_pre, DC001_3_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_3_spim_eq : -DC001_3_pim = DC001_3_spim := by
  simp only [DC001_3_pim, DC001_3_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_3_smul :
    -(N_entry_0_0 * N_entry_1_2 * N_entry_2_4) =
      ofLadj DC001_3_spre DC001_3_spim := by
  rw [DC001_3_mul, ofLadj_neg, DC001_3_spre_eq, DC001_3_spim_eq]

def DC001_4_ab_pre : Polynomial ℚ := interpQ 2 [-6, 64, 76, 42, 176, 50, 68, 160, -46, 34, 114, -128, 50, -42, -88, 14, -22, -40, 30]
def DC001_4_ab_pim : Polynomial ℚ := interpQ 2 [-38, -76, -30, -168, -180, -158, -364, -278, -286, -460, -230, -268, -306, -122, -158, -148, -8, -82, -6]
def DC001_4_pre : Polynomial ℚ := interpQ 2 [-324, -3232, -3732, -4648, -14172, -10440, -17120, -30340, -18560, -35504, -43844, -23424, -49564, -39840, -24136, -48132, -25808, -19524, -34460, -9632, -13076, -15196, -1712, -6244, -5008, 592, -2496, -396]
def DC001_4_pim : Polynomial ℚ := interpQ 2 [908, 1048, -1496, 3060, 1568, -1424, 11500, 3292, 6776, 24980, 5596, 19844, 32704, 8724, 33640, 30248, 11348, 34484, 18360, 9364, 22504, 6388, 6836, 9440, 464, 2336, 1708, -732]
theorem DC001_4_ab_pre_eq :
    N_re_0_1 * N_re_1_0 - N_im_0_1 * N_im_1_0 =
      DC001_4_ab_pre := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_0, z_N_im_1_0, DC001_4_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_4_ab_pim_eq :
    N_re_0_1 * N_im_1_0 + N_im_0_1 * N_re_1_0 =
      DC001_4_ab_pim := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_0, z_N_im_1_0, DC001_4_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_4_ab_mul :
    N_entry_0_1 * N_entry_1_0 =
      ofLadj DC001_4_ab_pre DC001_4_ab_pim := by
  rw [N_entry_0_1, N_entry_1_0, ofLadj_mul,
    DC001_4_ab_pre_eq, DC001_4_ab_pim_eq]

theorem DC001_4_pre_eq :
    DC001_4_ab_pre * N_re_2_5 - DC001_4_ab_pim * N_im_2_5 =
      DC001_4_pre := by
  simp only [DC001_4_ab_pre, DC001_4_ab_pim, z_N_re_2_5, z_N_im_2_5, DC001_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_4_pim_eq :
    DC001_4_ab_pre * N_im_2_5 + DC001_4_ab_pim * N_re_2_5 =
      DC001_4_pim := by
  simp only [DC001_4_ab_pre, DC001_4_ab_pim, z_N_re_2_5, z_N_im_2_5, DC001_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_4_mul :
    N_entry_0_1 * N_entry_1_0 * N_entry_2_5 =
      ofLadj DC001_4_pre DC001_4_pim := by
  rw [DC001_4_ab_mul, N_entry_2_5, ofLadj_mul, DC001_4_pre_eq, DC001_4_pim_eq]

def DC001_4_spre : Polynomial ℚ := interpQ 2 [324, 3232, 3732, 4648, 14172, 10440, 17120, 30340, 18560, 35504, 43844, 23424, 49564, 39840, 24136, 48132, 25808, 19524, 34460, 9632, 13076, 15196, 1712, 6244, 5008, -592, 2496, 396]
def DC001_4_spim : Polynomial ℚ := interpQ 2 [-908, -1048, 1496, -3060, -1568, 1424, -11500, -3292, -6776, -24980, -5596, -19844, -32704, -8724, -33640, -30248, -11348, -34484, -18360, -9364, -22504, -6388, -6836, -9440, -464, -2336, -1708, 732]
theorem DC001_4_spre_eq : -DC001_4_pre = DC001_4_spre := by
  simp only [DC001_4_pre, DC001_4_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_4_spim_eq : -DC001_4_pim = DC001_4_spim := by
  simp only [DC001_4_pim, DC001_4_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_4_smul :
    -(N_entry_0_1 * N_entry_1_0 * N_entry_2_5) =
      ofLadj DC001_4_spre DC001_4_spim := by
  rw [DC001_4_mul, ofLadj_neg, DC001_4_spre_eq, DC001_4_spim_eq]

def DC001_5_ab_pre : Polynomial ℚ := interpQ 2 [-108, 96, 2, -187, 309, -100, -38, 531, -235, 260, 478, -232, 382, 258, -48, 398, 122, 60, 176]
def DC001_5_ab_pim : Polynomial ℚ := interpQ 2 [-114, -228, 50, -279, -191, 98, -544, -135, -69, -856, 46, -200, -446, 178, -280, -222, 46, -228, -80]
def DC001_5_pre : Polynomial ℚ := interpQ 2 [3423, -16140, -6681, 7574, -54176, 5085, -14075, -110617, 30238, -92078, -149700, 48170, -176680, -108593, 21772, -226191, -49858, -38298, -192914, -4496, -61884, -97616, 3358, -54496, -38688, -3604, -23164, -7600]
def DC001_5_pim : Polynomial ℚ := interpQ 2 [8979, 15702, -6415, 34983, 21291, -19158, 83055, -3757, -9523, 141641, -63748, 34952, 124982, -117026, 89980, 52688, -112282, 109391, -21176, -62816, 65766, -47960, -17700, 23486, -31504, -162, 3416, -8544]
theorem DC001_5_ab_pre_eq :
    N_re_0_2 * N_re_1_1 - N_im_0_2 * N_im_1_1 =
      DC001_5_ab_pre := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_1, z_N_im_1_1, DC001_5_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_5_ab_pim_eq :
    N_re_0_2 * N_im_1_1 + N_im_0_2 * N_re_1_1 =
      DC001_5_ab_pim := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_1, z_N_im_1_1, DC001_5_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_5_ab_mul :
    N_entry_0_2 * N_entry_1_1 =
      ofLadj DC001_5_ab_pre DC001_5_ab_pim := by
  rw [N_entry_0_2, N_entry_1_1, ofLadj_mul,
    DC001_5_ab_pre_eq, DC001_5_ab_pim_eq]

theorem DC001_5_pre_eq :
    DC001_5_ab_pre * N_re_2_3 - DC001_5_ab_pim * N_im_2_3 =
      DC001_5_pre := by
  simp only [DC001_5_ab_pre, DC001_5_ab_pim, z_N_re_2_3, z_N_im_2_3, DC001_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_5_pim_eq :
    DC001_5_ab_pre * N_im_2_3 + DC001_5_ab_pim * N_re_2_3 =
      DC001_5_pim := by
  simp only [DC001_5_ab_pre, DC001_5_ab_pim, z_N_re_2_3, z_N_im_2_3, DC001_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_5_mul :
    N_entry_0_2 * N_entry_1_1 * N_entry_2_3 =
      ofLadj DC001_5_pre DC001_5_pim := by
  rw [DC001_5_ab_mul, N_entry_2_3, ofLadj_mul, DC001_5_pre_eq, DC001_5_pim_eq]

def DC001_5_spre : Polynomial ℚ := interpQ 2 [-3423, 16140, 6681, -7574, 54176, -5085, 14075, 110617, -30238, 92078, 149700, -48170, 176680, 108593, -21772, 226191, 49858, 38298, 192914, 4496, 61884, 97616, -3358, 54496, 38688, 3604, 23164, 7600]
def DC001_5_spim : Polynomial ℚ := interpQ 2 [-8979, -15702, 6415, -34983, -21291, 19158, -83055, 3757, 9523, -141641, 63748, -34952, -124982, 117026, -89980, -52688, 112282, -109391, 21176, 62816, -65766, 47960, 17700, -23486, 31504, 162, -3416, 8544]
theorem DC001_5_spre_eq : -DC001_5_pre = DC001_5_spre := by
  simp only [DC001_5_pre, DC001_5_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_5_spim_eq : -DC001_5_pim = DC001_5_spim := by
  simp only [DC001_5_pim, DC001_5_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_5_smul :
    -(N_entry_0_2 * N_entry_1_1 * N_entry_2_3) =
      ofLadj DC001_5_spre DC001_5_spim := by
  rw [DC001_5_mul, ofLadj_neg, DC001_5_spre_eq, DC001_5_spim_eq]

def DC001_6_ab_pre : Polynomial ℚ := interpQ 2 [96, 0, 104, 180, 40, 208, 184, 8, 264, 76, -16, 152, -16, -28, 84, -64, 8, 32, -32]
def DC001_6_ab_pim : Polynomial ℚ := interpQ 2 [48, 96, -24, 132, 72, -56, 176, -8, -8, 260, -24, 72, 168, 4, 116, 112, 40, 80, 64]
def DC001_6_pre : Polynomial ℚ := interpQ 2 [912, -576, 1120, 2592, -920, 4528, 3896, -896, 9624, 2088, 48, 11312, -1656, 1808, 8384, -5528, 2640, 2632, -6384, 1288, -1080, -4072, 328, -1792, -1920, -64, -832, -640]
def DC001_6_pim : Polynomial ℚ := interpQ 2 [816, 1632, 48, 4056, 3176, 944, 8712, 2728, 3776, 13400, 952, 7904, 12664, -272, 10704, 8768, 360, 10864, 4992, 1288, 7096, 1936, 1720, 3696, 608, 1056, 1216]
theorem DC001_6_ab_pre_eq :
    N_re_0_0 * N_re_1_4 - N_im_0_0 * N_im_1_4 =
      DC001_6_ab_pre := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_4, z_N_im_1_4, DC001_6_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_6_ab_pim_eq :
    N_re_0_0 * N_im_1_4 + N_im_0_0 * N_re_1_4 =
      DC001_6_ab_pim := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_4, z_N_im_1_4, DC001_6_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_6_ab_mul :
    N_entry_0_0 * N_entry_1_4 =
      ofLadj DC001_6_ab_pre DC001_6_ab_pim := by
  rw [N_entry_0_0, N_entry_1_4, ofLadj_mul,
    DC001_6_ab_pre_eq, DC001_6_ab_pim_eq]

theorem DC001_6_pre_eq :
    DC001_6_ab_pre * N_re_2_2 - DC001_6_ab_pim * N_im_2_2 =
      DC001_6_pre := by
  simp only [DC001_6_ab_pre, DC001_6_ab_pim, z_N_re_2_2, z_N_im_2_2, DC001_6_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_6_pim_eq :
    DC001_6_ab_pre * N_im_2_2 + DC001_6_ab_pim * N_re_2_2 =
      DC001_6_pim := by
  simp only [DC001_6_ab_pre, DC001_6_ab_pim, z_N_re_2_2, z_N_im_2_2, DC001_6_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_6_mul :
    N_entry_0_0 * N_entry_1_4 * N_entry_2_2 =
      ofLadj DC001_6_pre DC001_6_pim := by
  rw [DC001_6_ab_mul, N_entry_2_2, ofLadj_mul, DC001_6_pre_eq, DC001_6_pim_eq]

def DC001_7_ab_pre : Polynomial ℚ := interpQ 2 [190, -384, -230, 232, -1020, 160, 56, -1256, 812, -446, -1120, 904, -736, -216, 580, -572, 56, 160, -336]
def DC001_7_ab_pim : Polynomial ℚ := interpQ 2 [340, 680, 126, 1214, 1140, 550, 2338, 1288, 1162, 3174, 844, 1480, 2116, 340, 1264, 1020, 48, 704, 192]
def DC001_7_pre : Polynomial ℚ := interpQ 2 [-680, -2720, -2972, -3477, -11006, -7794, -12485, -24575, -13502, -28830, -37731, -16746, -43983, -35830, -20111, -48015, -24606, -20683, -38294, -10630, -16752, -18862, -3654, -9890, -6780, -544, -3848, -768]
def DC001_7_pim : Polynomial ℚ := interpQ 2 [380, -8, -1996, 964, -524, -4353, 6059, -2421, -1779, 13938, -6494, 5688, 18396, -8226, 17937, 14149, -5557, 21651, 4468, -1946, 15428, -1688, 2160, 6250, -2688, 1280, 784, -1344]
theorem DC001_7_ab_pre_eq :
    N_re_0_1 * N_re_1_5 - N_im_0_1 * N_im_1_5 =
      DC001_7_ab_pre := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_5, z_N_im_1_5, DC001_7_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_7_ab_pim_eq :
    N_re_0_1 * N_im_1_5 + N_im_0_1 * N_re_1_5 =
      DC001_7_ab_pim := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_5, z_N_im_1_5, DC001_7_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_7_ab_mul :
    N_entry_0_1 * N_entry_1_5 =
      ofLadj DC001_7_ab_pre DC001_7_ab_pim := by
  rw [N_entry_0_1, N_entry_1_5, ofLadj_mul,
    DC001_7_ab_pre_eq, DC001_7_ab_pim_eq]

theorem DC001_7_pre_eq :
    DC001_7_ab_pre * N_re_2_0 - DC001_7_ab_pim * N_im_2_0 =
      DC001_7_pre := by
  simp only [DC001_7_ab_pre, DC001_7_ab_pim, z_N_re_2_0, z_N_im_2_0, DC001_7_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_7_pim_eq :
    DC001_7_ab_pre * N_im_2_0 + DC001_7_ab_pim * N_re_2_0 =
      DC001_7_pim := by
  simp only [DC001_7_ab_pre, DC001_7_ab_pim, z_N_re_2_0, z_N_im_2_0, DC001_7_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_7_mul :
    N_entry_0_1 * N_entry_1_5 * N_entry_2_0 =
      ofLadj DC001_7_pre DC001_7_pim := by
  rw [DC001_7_ab_mul, N_entry_2_0, ofLadj_mul, DC001_7_pre_eq, DC001_7_pim_eq]

def DC001_8_ab_pre : Polynomial ℚ := interpQ 2 [276, -288, -84, 469, -901, 250, 76, -1483, 601, -770, -1470, 588, -1182, -686, 132, -1062, -286, -112, -480]
def DC001_8_ab_pim : Polynomial ℚ := interpQ 2 [318, 636, -128, 823, 601, -224, 1562, 409, 201, 2366, -114, 612, 1338, -378, 836, 690, -134, 656, 160]
def DC001_8_pre : Polynomial ℚ := interpQ 2 [4695, -15324, -5993, 9638, -54620, 6501, -11731, -110621, 34284, -88378, -147982, 51080, -176274, -107897, 22898, -224125, -48128, -36296, -189404, -3948, -61592, -95664, 3862, -52048, -36080, -2200, -21280, -6400]
def DC001_8_pim : Polynomial ℚ := interpQ 2 [9585, 17298, -6283, 37519, 24991, -16564, 89935, 3721, -1807, 154575, -52670, 47158, 140032, -100852, 106848, 70602, -93080, 126763, -5140, -47176, 77118, -35808, -6816, 31002, -24704, 4470, 5680, -7200]
theorem DC001_8_ab_pre_eq :
    N_re_0_2 * N_re_1_3 - N_im_0_2 * N_im_1_3 =
      DC001_8_ab_pre := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_3, z_N_im_1_3, DC001_8_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_8_ab_pim_eq :
    N_re_0_2 * N_im_1_3 + N_im_0_2 * N_re_1_3 =
      DC001_8_ab_pim := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_3, z_N_im_1_3, DC001_8_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_8_ab_mul :
    N_entry_0_2 * N_entry_1_3 =
      ofLadj DC001_8_ab_pre DC001_8_ab_pim := by
  rw [N_entry_0_2, N_entry_1_3, ofLadj_mul,
    DC001_8_ab_pre_eq, DC001_8_ab_pim_eq]

theorem DC001_8_pre_eq :
    DC001_8_ab_pre * N_re_2_1 - DC001_8_ab_pim * N_im_2_1 =
      DC001_8_pre := by
  simp only [DC001_8_ab_pre, DC001_8_ab_pim, z_N_re_2_1, z_N_im_2_1, DC001_8_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_8_pim_eq :
    DC001_8_ab_pre * N_im_2_1 + DC001_8_ab_pim * N_re_2_1 =
      DC001_8_pim := by
  simp only [DC001_8_ab_pre, DC001_8_ab_pim, z_N_re_2_1, z_N_im_2_1, DC001_8_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_8_mul :
    N_entry_0_2 * N_entry_1_3 * N_entry_2_1 =
      ofLadj DC001_8_pre DC001_8_pim := by
  rw [DC001_8_ab_mul, N_entry_2_1, ofLadj_mul, DC001_8_pre_eq, DC001_8_pim_eq]

def DC001_9_ab_pre : Polynomial ℚ := interpQ 2 [104, 0, 108, 182, 40, 208, 184, 8, 266, 80, -16, 152, -16, -28, 84, -64, 8, 32, -32]
def DC001_9_ab_pim : Polynomial ℚ := interpQ 2 [48, 96, -28, 130, 72, -60, 180, -8, -6, 264, -24, 72, 168, 4, 116, 112, 40, 80, 64]
def DC001_9_pre : Polynomial ℚ := interpQ 2 [2236, -1248, 2576, 5734, -2278, 9472, 7616, -3512, 19250, 2328, -2560, 21934, -6260, 1452, 16116, -13810, 4268, 4764, -14360, 2352, -2548, -8868, 576, -3920, -4248, -248, -1784, -1360]
def DC001_9_pim : Polynomial ℚ := interpQ 2 [1852, 3704, -92, 8680, 6462, 1142, 18266, 4708, 6980, 28212, 878, 16002, 26314, -1808, 21952, 17754, -642, 21854, 9288, 1152, 13620, 2688, 2416, 6956, 608, 1776, 2328, -80]
theorem DC001_9_ab_pre_eq :
    N_re_0_0 * N_re_1_5 - N_im_0_0 * N_im_1_5 =
      DC001_9_ab_pre := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_5, z_N_im_1_5, DC001_9_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_9_ab_pim_eq :
    N_re_0_0 * N_im_1_5 + N_im_0_0 * N_re_1_5 =
      DC001_9_ab_pim := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_5, z_N_im_1_5, DC001_9_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_9_ab_mul :
    N_entry_0_0 * N_entry_1_5 =
      ofLadj DC001_9_ab_pre DC001_9_ab_pim := by
  rw [N_entry_0_0, N_entry_1_5, ofLadj_mul,
    DC001_9_ab_pre_eq, DC001_9_ab_pim_eq]

theorem DC001_9_pre_eq :
    DC001_9_ab_pre * N_re_2_1 - DC001_9_ab_pim * N_im_2_1 =
      DC001_9_pre := by
  simp only [DC001_9_ab_pre, DC001_9_ab_pim, z_N_re_2_1, z_N_im_2_1, DC001_9_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_9_pim_eq :
    DC001_9_ab_pre * N_im_2_1 + DC001_9_ab_pim * N_re_2_1 =
      DC001_9_pim := by
  simp only [DC001_9_ab_pre, DC001_9_ab_pim, z_N_re_2_1, z_N_im_2_1, DC001_9_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_9_mul :
    N_entry_0_0 * N_entry_1_5 * N_entry_2_1 =
      ofLadj DC001_9_pre DC001_9_pim := by
  rw [DC001_9_ab_mul, N_entry_2_1, ofLadj_mul, DC001_9_pre_eq, DC001_9_pim_eq]

def DC001_9_spre : Polynomial ℚ := interpQ 2 [-2236, 1248, -2576, -5734, 2278, -9472, -7616, 3512, -19250, -2328, 2560, -21934, 6260, -1452, -16116, 13810, -4268, -4764, 14360, -2352, 2548, 8868, -576, 3920, 4248, 248, 1784, 1360]
def DC001_9_spim : Polynomial ℚ := interpQ 2 [-1852, -3704, 92, -8680, -6462, -1142, -18266, -4708, -6980, -28212, -878, -16002, -26314, 1808, -21952, -17754, 642, -21854, -9288, -1152, -13620, -2688, -2416, -6956, -608, -1776, -2328, 80]
theorem DC001_9_spre_eq : -DC001_9_pre = DC001_9_spre := by
  simp only [DC001_9_pre, DC001_9_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_9_spim_eq : -DC001_9_pim = DC001_9_spim := by
  simp only [DC001_9_pim, DC001_9_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_9_smul :
    -(N_entry_0_0 * N_entry_1_5 * N_entry_2_1) =
      ofLadj DC001_9_spre DC001_9_spim := by
  rw [DC001_9_mul, ofLadj_neg, DC001_9_spre_eq, DC001_9_spim_eq]

def DC001_10_ab_pre : Polynomial ℚ := interpQ 2 [446, -768, -302, 801, -2019, 610, 339, -2780, 1812, -1220, -2782, 1762, -2014, -918, 1011, -1601, -45, 226, -840]
def DC001_10_ab_pim : Polynomial ℚ := interpQ 2 [728, 1456, 158, 2475, 2177, 644, 4535, 2032, 1688, 6348, 1076, 2672, 4268, 294, 2637, 2111, 29, 1592, 480]
def DC001_10_pre : Polynomial ℚ := interpQ 2 [2722, -17184, -9292, 370, -64092, -6840, -29832, -125386, 14166, -112528, -170560, 23572, -205508, -135020, -786, -244714, -63860, -48068, -203652, -14054, -67092, -102454, 2916, -50322, -35308, 528, -20232, -7200]
def DC001_10_pim : Polynomial ℚ := interpQ 2 [9346, 16388, -1756, 45132, 36842, 6240, 117118, 40004, 48246, 208532, 13450, 125552, 224946, -10670, 200368, 163580, -5458, 211208, 70906, 15246, 134658, 10736, 27256, 58788, -6456, 15316, 12976, -4800]
theorem DC001_10_ab_pre_eq :
    N_re_0_1 * N_re_1_3 - N_im_0_1 * N_im_1_3 =
      DC001_10_ab_pre := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_3, z_N_im_1_3, DC001_10_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_10_ab_pim_eq :
    N_re_0_1 * N_im_1_3 + N_im_0_1 * N_re_1_3 =
      DC001_10_ab_pim := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_3, z_N_im_1_3, DC001_10_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_10_ab_mul :
    N_entry_0_1 * N_entry_1_3 =
      ofLadj DC001_10_ab_pre DC001_10_ab_pim := by
  rw [N_entry_0_1, N_entry_1_3, ofLadj_mul,
    DC001_10_ab_pre_eq, DC001_10_ab_pim_eq]

theorem DC001_10_pre_eq :
    DC001_10_ab_pre * N_re_2_2 - DC001_10_ab_pim * N_im_2_2 =
      DC001_10_pre := by
  simp only [DC001_10_ab_pre, DC001_10_ab_pim, z_N_re_2_2, z_N_im_2_2, DC001_10_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_10_pim_eq :
    DC001_10_ab_pre * N_im_2_2 + DC001_10_ab_pim * N_re_2_2 =
      DC001_10_pim := by
  simp only [DC001_10_ab_pre, DC001_10_ab_pim, z_N_re_2_2, z_N_im_2_2, DC001_10_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_10_mul :
    N_entry_0_1 * N_entry_1_3 * N_entry_2_2 =
      ofLadj DC001_10_pre DC001_10_pim := by
  rw [DC001_10_ab_mul, N_entry_2_2, ofLadj_mul, DC001_10_pre_eq, DC001_10_pim_eq]

def DC001_10_spre : Polynomial ℚ := interpQ 2 [-2722, 17184, 9292, -370, 64092, 6840, 29832, 125386, -14166, 112528, 170560, -23572, 205508, 135020, 786, 244714, 63860, 48068, 203652, 14054, 67092, 102454, -2916, 50322, 35308, -528, 20232, 7200]
def DC001_10_spim : Polynomial ℚ := interpQ 2 [-9346, -16388, 1756, -45132, -36842, -6240, -117118, -40004, -48246, -208532, -13450, -125552, -224946, 10670, -200368, -163580, 5458, -211208, -70906, -15246, -134658, -10736, -27256, -58788, 6456, -15316, -12976, 4800]
theorem DC001_10_spre_eq : -DC001_10_pre = DC001_10_spre := by
  simp only [DC001_10_pre, DC001_10_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_10_spim_eq : -DC001_10_pim = DC001_10_spim := by
  simp only [DC001_10_pim, DC001_10_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_10_smul :
    -(N_entry_0_1 * N_entry_1_3 * N_entry_2_2) =
      ofLadj DC001_10_spre DC001_10_spim := by
  rw [DC001_10_mul, ofLadj_neg, DC001_10_spre_eq, DC001_10_spim_eq]

def DC001_11_ab_pre : Polynomial ℚ := interpQ 2 [108, -144, -72, 168, -408, 104, 24, -648, 232, -376, -712, 192, -568, -304, 64, -432, -96, -16, -192]
def DC001_11_ab_pim : Polynomial ℚ := interpQ 2 [144, 288, -24, 408, 320, -28, 748, 240, 144, 1072, 24, 360, 696, -40, 456, 384, -16, 304, 64]
def DC001_11_pre : Polynomial ℚ := interpQ 2 [-288, -1152, -1104, -882, -3892, -1782, -3022, -7900, -1970, -8112, -11832, -1744, -14064, -10644, -3888, -17296, -7328, -6344, -15048, -3016, -6596, -7800, -1264, -4416, -2960, -216, -1760, -256]
def DC001_11_pim : Polynomial ℚ := interpQ 2 [216, 144, -720, 732, 216, -1700, 2876, -1396, -1978, 4582, -5630, -1124, 4026, -8950, 2466, 384, -8668, 4020, -3348, -5372, 3272, -3892, -1212, 1112, -2424, -88, -96, -768]
theorem DC001_11_ab_pre_eq :
    N_re_0_2 * N_re_1_4 - N_im_0_2 * N_im_1_4 =
      DC001_11_ab_pre := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_4, z_N_im_1_4, DC001_11_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_11_ab_pim_eq :
    N_re_0_2 * N_im_1_4 + N_im_0_2 * N_re_1_4 =
      DC001_11_ab_pim := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_4, z_N_im_1_4, DC001_11_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_11_ab_mul :
    N_entry_0_2 * N_entry_1_4 =
      ofLadj DC001_11_ab_pre DC001_11_ab_pim := by
  rw [N_entry_0_2, N_entry_1_4, ofLadj_mul,
    DC001_11_ab_pre_eq, DC001_11_ab_pim_eq]

theorem DC001_11_pre_eq :
    DC001_11_ab_pre * N_re_2_0 - DC001_11_ab_pim * N_im_2_0 =
      DC001_11_pre := by
  simp only [DC001_11_ab_pre, DC001_11_ab_pim, z_N_re_2_0, z_N_im_2_0, DC001_11_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_11_pim_eq :
    DC001_11_ab_pre * N_im_2_0 + DC001_11_ab_pim * N_re_2_0 =
      DC001_11_pim := by
  simp only [DC001_11_ab_pre, DC001_11_ab_pim, z_N_re_2_0, z_N_im_2_0, DC001_11_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_11_mul :
    N_entry_0_2 * N_entry_1_4 * N_entry_2_0 =
      ofLadj DC001_11_pre DC001_11_pim := by
  rw [DC001_11_ab_mul, N_entry_2_0, ofLadj_mul, DC001_11_pre_eq, DC001_11_pim_eq]

def DC001_11_spre : Polynomial ℚ := interpQ 2 [288, 1152, 1104, 882, 3892, 1782, 3022, 7900, 1970, 8112, 11832, 1744, 14064, 10644, 3888, 17296, 7328, 6344, 15048, 3016, 6596, 7800, 1264, 4416, 2960, 216, 1760, 256]
def DC001_11_spim : Polynomial ℚ := interpQ 2 [-216, -144, 720, -732, -216, 1700, -2876, 1396, 1978, -4582, 5630, 1124, -4026, 8950, -2466, -384, 8668, -4020, 3348, 5372, -3272, 3892, 1212, -1112, 2424, 88, 96, 768]
theorem DC001_11_spre_eq : -DC001_11_pre = DC001_11_spre := by
  simp only [DC001_11_pre, DC001_11_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_11_spim_eq : -DC001_11_pim = DC001_11_spim := by
  simp only [DC001_11_pim, DC001_11_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_11_smul :
    -(N_entry_0_2 * N_entry_1_4 * N_entry_2_0) =
      ofLadj DC001_11_spre DC001_11_spim := by
  rw [DC001_11_mul, ofLadj_neg, DC001_11_spre_eq, DC001_11_spim_eq]

def DC001_12_ab_pre : Polynomial ℚ := interpQ 2 [684, -608, 196, 1217, -1545, 1056, 793, -2432, 2228, -810, -2370, 1934, -1762, -1006, 1011, -1659, -73, 190, -772]
def DC001_12_ab_pim : Polynomial ℚ := interpQ 2 [722, 1444, 0, 2259, 1879, 130, 4153, 1400, 1268, 5930, 660, 2264, 3868, 42, 2445, 1997, 129, 1560, 696]
def DC001_12_pre : Polynomial ℚ := interpQ 2 [5358, -15352, -2328, 9574, -53072, 10424, -9760, -104106, 44078, -83732, -137884, 58144, -172900, -104492, 27894, -220126, -43240, -31712, -188532, -7502, -59468, -98702, 2180, -48334, -36380, -892, -19440, -8656]
def DC001_12_pim : Polynomial ℚ := interpQ 2 [9994, 18164, -1540, 47992, 37878, 4512, 119018, 34588, 44838, 205880, 4810, 118712, 215146, -22174, 188276, 151680, -14274, 200228, 67226, 9530, 128246, 10260, 24340, 57712, -4320, 15456, 14720, -3392]
theorem DC001_12_ab_pre_eq :
    N_re_0_3 * N_re_1_1 - N_im_0_3 * N_im_1_1 =
      DC001_12_ab_pre := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_1, z_N_im_1_1, DC001_12_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_12_ab_pim_eq :
    N_re_0_3 * N_im_1_1 + N_im_0_3 * N_re_1_1 =
      DC001_12_ab_pim := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_1, z_N_im_1_1, DC001_12_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_12_ab_mul :
    N_entry_0_3 * N_entry_1_1 =
      ofLadj DC001_12_ab_pre DC001_12_ab_pim := by
  rw [N_entry_0_3, N_entry_1_1, ofLadj_mul,
    DC001_12_ab_pre_eq, DC001_12_ab_pim_eq]

theorem DC001_12_pre_eq :
    DC001_12_ab_pre * N_re_2_2 - DC001_12_ab_pim * N_im_2_2 =
      DC001_12_pre := by
  simp only [DC001_12_ab_pre, DC001_12_ab_pim, z_N_re_2_2, z_N_im_2_2, DC001_12_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_12_pim_eq :
    DC001_12_ab_pre * N_im_2_2 + DC001_12_ab_pim * N_re_2_2 =
      DC001_12_pim := by
  simp only [DC001_12_ab_pre, DC001_12_ab_pim, z_N_re_2_2, z_N_im_2_2, DC001_12_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_12_mul :
    N_entry_0_3 * N_entry_1_1 * N_entry_2_2 =
      ofLadj DC001_12_pre DC001_12_pim := by
  rw [DC001_12_ab_mul, N_entry_2_2, ofLadj_mul, DC001_12_pre_eq, DC001_12_pim_eq]

def DC001_13_ab_pre : Polynomial ℚ := interpQ 2 [144, -144, 48, 248, -304, 240, 200, -416, 512, -96, -432, 432, -288, -144, 264, -256, 48, 88, -144]
def DC001_13_ab_pim : Polynomial ℚ := interpQ 2 [168, 336, 48, 568, 512, 168, 992, 424, 432, 1360, 312, 624, 936, 176, 584, 480, 80, 344, 168]
def DC001_13_pre : Polynomial ℚ := interpQ 2 [-336, -1344, -1440, -1472, -5144, -2912, -4892, -9984, -4012, -11312, -14736, -5024, -17556, -14008, -6996, -19976, -9896, -8588, -17040, -5092, -7488, -8992, -2032, -4828, -3352, -636, -1904, -672]
def DC001_13_pim : Polynomial ℚ := interpQ 2 [288, 288, -480, 1540, 912, -388, 4832, 1152, 1452, 9156, -936, 5016, 10244, -2324, 9328, 7420, -1716, 10520, 2560, -332, 7132, -108, 1032, 3184, -812, 684, 628, -576]
theorem DC001_13_ab_pre_eq :
    N_re_0_4 * N_re_1_2 - N_im_0_4 * N_im_1_2 =
      DC001_13_ab_pre := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_2, z_N_im_1_2, DC001_13_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_13_ab_pim_eq :
    N_re_0_4 * N_im_1_2 + N_im_0_4 * N_re_1_2 =
      DC001_13_ab_pim := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_2, z_N_im_1_2, DC001_13_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_13_ab_mul :
    N_entry_0_4 * N_entry_1_2 =
      ofLadj DC001_13_ab_pre DC001_13_ab_pim := by
  rw [N_entry_0_4, N_entry_1_2, ofLadj_mul,
    DC001_13_ab_pre_eq, DC001_13_ab_pim_eq]

theorem DC001_13_pre_eq :
    DC001_13_ab_pre * N_re_2_0 - DC001_13_ab_pim * N_im_2_0 =
      DC001_13_pre := by
  simp only [DC001_13_ab_pre, DC001_13_ab_pim, z_N_re_2_0, z_N_im_2_0, DC001_13_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_13_pim_eq :
    DC001_13_ab_pre * N_im_2_0 + DC001_13_ab_pim * N_re_2_0 =
      DC001_13_pim := by
  simp only [DC001_13_ab_pre, DC001_13_ab_pim, z_N_re_2_0, z_N_im_2_0, DC001_13_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_13_mul :
    N_entry_0_4 * N_entry_1_2 * N_entry_2_0 =
      ofLadj DC001_13_pre DC001_13_pim := by
  rw [DC001_13_ab_mul, N_entry_2_0, ofLadj_mul, DC001_13_pre_eq, DC001_13_pim_eq]

def DC001_14_ab_pre : Polynomial ℚ := interpQ 2 [24, -48, -36, 44, -100, 68, 40, -92, 140, -40, -128, 96, -80, -4, 96, -28, 28, 56, -36]
def DC001_14_ab_pim : Polynomial ℚ := interpQ 2 [48, 96, 36, 204, 172, 116, 304, 188, 140, 392, 128, 216, 304, 100, 184, 156, 20, 88, 12]
def DC001_14_pre : Polynomial ℚ := interpQ 2 [276, -2424, -1968, -800, -8920, -1480, -5116, -15324, 916, -14696, -20908, 300, -25288, -16572, -1712, -27544, -8236, -5080, -22932, -2576, -7268, -11424, 604, -4620, -3424, 852, -1792, -480]
def DC001_14_pim : Polynomial ℚ := interpQ 2 [1332, 2352, 276, 6940, 5936, 3364, 16804, 8160, 9580, 28156, 6064, 19688, 30592, 5200, 28212, 24052, 4796, 27584, 12016, 5100, 17808, 4432, 4984, 8568, 568, 2176, 1844, -540]
theorem DC001_14_ab_pre_eq :
    N_re_0_5 * N_re_1_0 - N_im_0_5 * N_im_1_0 =
      DC001_14_ab_pre := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_0, z_N_im_1_0, DC001_14_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_14_ab_pim_eq :
    N_re_0_5 * N_im_1_0 + N_im_0_5 * N_re_1_0 =
      DC001_14_ab_pim := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_0, z_N_im_1_0, DC001_14_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_14_ab_mul :
    N_entry_0_5 * N_entry_1_0 =
      ofLadj DC001_14_ab_pre DC001_14_ab_pim := by
  rw [N_entry_0_5, N_entry_1_0, ofLadj_mul,
    DC001_14_ab_pre_eq, DC001_14_ab_pim_eq]

theorem DC001_14_pre_eq :
    DC001_14_ab_pre * N_re_2_1 - DC001_14_ab_pim * N_im_2_1 =
      DC001_14_pre := by
  simp only [DC001_14_ab_pre, DC001_14_ab_pim, z_N_re_2_1, z_N_im_2_1, DC001_14_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_14_pim_eq :
    DC001_14_ab_pre * N_im_2_1 + DC001_14_ab_pim * N_re_2_1 =
      DC001_14_pim := by
  simp only [DC001_14_ab_pre, DC001_14_ab_pim, z_N_re_2_1, z_N_im_2_1, DC001_14_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_14_mul :
    N_entry_0_5 * N_entry_1_0 * N_entry_2_1 =
      ofLadj DC001_14_pre DC001_14_pim := by
  rw [DC001_14_ab_mul, N_entry_2_1, ofLadj_mul, DC001_14_pre_eq, DC001_14_pim_eq]

def DC001_15_ab_pre : Polynomial ℚ := interpQ 2 [266, -456, -118, 316, -1014, 254, 186, -1166, 1050, -312, -1008, 1052, -552, -194, 734, -484, 162, 230, -332]
def DC001_15_ab_pim : Polynomial ℚ := interpQ 2 [418, 836, 238, 1516, 1486, 846, 2834, 1650, 1658, 3812, 1344, 1964, 2584, 714, 1590, 1252, 254, 830, 376]
def DC001_15_pre : Polynomial ℚ := interpQ 2 [3800, -22040, -11430, -5168, -77356, -16346, -45934, -146694, -1188, -139058, -196508, -1492, -231760, -160322, -23946, -261404, -81852, -61334, -211196, -28112, -69588, -105308, -2432, -48016, -36894, -186, -19130, -9070]
def DC001_15_pim : Polynomial ℚ := interpQ 2 [11970, 20976, 1074, 57042, 48248, 19830, 143790, 61900, 82044, 250964, 52998, 173668, 272966, 40312, 248116, 211390, 42878, 247728, 112658, 45196, 155454, 34978, 39980, 69318, 3432, 18838, 17040, -2990]
theorem DC001_15_ab_pre_eq :
    N_re_0_3 * N_re_1_2 - N_im_0_3 * N_im_1_2 =
      DC001_15_ab_pre := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_2, z_N_im_1_2, DC001_15_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_15_ab_pim_eq :
    N_re_0_3 * N_im_1_2 + N_im_0_3 * N_re_1_2 =
      DC001_15_ab_pim := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_2, z_N_im_1_2, DC001_15_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_15_ab_mul :
    N_entry_0_3 * N_entry_1_2 =
      ofLadj DC001_15_ab_pre DC001_15_ab_pim := by
  rw [N_entry_0_3, N_entry_1_2, ofLadj_mul,
    DC001_15_ab_pre_eq, DC001_15_ab_pim_eq]

theorem DC001_15_pre_eq :
    DC001_15_ab_pre * N_re_2_1 - DC001_15_ab_pim * N_im_2_1 =
      DC001_15_pre := by
  simp only [DC001_15_ab_pre, DC001_15_ab_pim, z_N_re_2_1, z_N_im_2_1, DC001_15_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_15_pim_eq :
    DC001_15_ab_pre * N_im_2_1 + DC001_15_ab_pim * N_re_2_1 =
      DC001_15_pim := by
  simp only [DC001_15_ab_pre, DC001_15_ab_pim, z_N_re_2_1, z_N_im_2_1, DC001_15_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_15_mul :
    N_entry_0_3 * N_entry_1_2 * N_entry_2_1 =
      ofLadj DC001_15_pre DC001_15_pim := by
  rw [DC001_15_ab_mul, N_entry_2_1, ofLadj_mul, DC001_15_pre_eq, DC001_15_pim_eq]

def DC001_15_spre : Polynomial ℚ := interpQ 2 [-3800, 22040, 11430, 5168, 77356, 16346, 45934, 146694, 1188, 139058, 196508, 1492, 231760, 160322, 23946, 261404, 81852, 61334, 211196, 28112, 69588, 105308, 2432, 48016, 36894, 186, 19130, 9070]
def DC001_15_spim : Polynomial ℚ := interpQ 2 [-11970, -20976, -1074, -57042, -48248, -19830, -143790, -61900, -82044, -250964, -52998, -173668, -272966, -40312, -248116, -211390, -42878, -247728, -112658, -45196, -155454, -34978, -39980, -69318, -3432, -18838, -17040, 2990]
theorem DC001_15_spre_eq : -DC001_15_pre = DC001_15_spre := by
  simp only [DC001_15_pre, DC001_15_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_15_spim_eq : -DC001_15_pim = DC001_15_spim := by
  simp only [DC001_15_pim, DC001_15_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_15_smul :
    -(N_entry_0_3 * N_entry_1_2 * N_entry_2_1) =
      ofLadj DC001_15_spre DC001_15_spim := by
  rw [DC001_15_mul, ofLadj_neg, DC001_15_spre_eq, DC001_15_spim_eq]

def DC001_16_ab_pre : Polynomial ℚ := interpQ 2 [24, -48, -36, 44, -100, 68, 40, -92, 140, -40, -128, 96, -80, -4, 96, -28, 28, 56, -36]
def DC001_16_ab_pim : Polynomial ℚ := interpQ 2 [48, 96, 36, 204, 172, 116, 304, 188, 140, 392, 128, 216, 304, 100, 184, 156, 20, 88, 12]
def DC001_16_pre : Polynomial ℚ := interpQ 2 [120, -1104, -888, -392, -4184, -840, -2536, -7272, 224, -6936, -9736, 152, -11696, -7696, -832, -12816, -3808, -2352, -10568, -984, -3120, -5040, 536, -1976, -1472, 464, -840, -240]
def DC001_16_pim : Polynomial ℚ := interpQ 2 [600, 1056, 144, 3264, 2912, 1872, 8288, 4576, 5536, 14376, 4416, 10912, 16120, 4424, 15136, 13232, 4296, 14824, 7400, 3944, 9592, 3024, 3008, 4424, 504, 1160, 920, -240]
theorem DC001_16_ab_pre_eq :
    N_re_0_4 * N_re_1_0 - N_im_0_4 * N_im_1_0 =
      DC001_16_ab_pre := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_0, z_N_im_1_0, DC001_16_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_16_ab_pim_eq :
    N_re_0_4 * N_im_1_0 + N_im_0_4 * N_re_1_0 =
      DC001_16_ab_pim := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_0, z_N_im_1_0, DC001_16_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_16_ab_mul :
    N_entry_0_4 * N_entry_1_0 =
      ofLadj DC001_16_ab_pre DC001_16_ab_pim := by
  rw [N_entry_0_4, N_entry_1_0, ofLadj_mul,
    DC001_16_ab_pre_eq, DC001_16_ab_pim_eq]

theorem DC001_16_pre_eq :
    DC001_16_ab_pre * N_re_2_2 - DC001_16_ab_pim * N_im_2_2 =
      DC001_16_pre := by
  simp only [DC001_16_ab_pre, DC001_16_ab_pim, z_N_re_2_2, z_N_im_2_2, DC001_16_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_16_pim_eq :
    DC001_16_ab_pre * N_im_2_2 + DC001_16_ab_pim * N_re_2_2 =
      DC001_16_pim := by
  simp only [DC001_16_ab_pre, DC001_16_ab_pim, z_N_re_2_2, z_N_im_2_2, DC001_16_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_16_mul :
    N_entry_0_4 * N_entry_1_0 * N_entry_2_2 =
      ofLadj DC001_16_pre DC001_16_pim := by
  rw [DC001_16_ab_mul, N_entry_2_2, ofLadj_mul, DC001_16_pre_eq, DC001_16_pim_eq]

def DC001_16_spre : Polynomial ℚ := interpQ 2 [-120, 1104, 888, 392, 4184, 840, 2536, 7272, -224, 6936, 9736, -152, 11696, 7696, 832, 12816, 3808, 2352, 10568, 984, 3120, 5040, -536, 1976, 1472, -464, 840, 240]
def DC001_16_spim : Polynomial ℚ := interpQ 2 [-600, -1056, -144, -3264, -2912, -1872, -8288, -4576, -5536, -14376, -4416, -10912, -16120, -4424, -15136, -13232, -4296, -14824, -7400, -3944, -9592, -3024, -3008, -4424, -504, -1160, -920, 240]
theorem DC001_16_spre_eq : -DC001_16_pre = DC001_16_spre := by
  simp only [DC001_16_pre, DC001_16_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_16_spim_eq : -DC001_16_pim = DC001_16_spim := by
  simp only [DC001_16_pim, DC001_16_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_16_smul :
    -(N_entry_0_4 * N_entry_1_0 * N_entry_2_2) =
      ofLadj DC001_16_spre DC001_16_spim := by
  rw [DC001_16_mul, ofLadj_neg, DC001_16_spre_eq, DC001_16_spim_eq]

def DC001_17_ab_pre : Polynomial ℚ := interpQ 2 [348, -192, 204, 612, -588, 496, 372, -1020, 1028, -212, -880, 968, -688, -416, 416, -768, -64, 60, -336]
def DC001_17_ab_pim : Polynomial ℚ := interpQ 2 [276, 552, -132, 800, 608, -204, 1572, 348, 352, 2344, 32, 720, 1408, -220, 840, 724, -16, 640, 312]
def DC001_17_pre : Polynomial ℚ := interpQ 2 [-552, -2208, -1944, -1030, -7452, -1712, -4404, -14200, -486, -14802, -21366, 334, -25816, -17848, -2578, -31560, -10306, -8862, -28524, -3836, -10834, -15160, -1146, -8502, -5844, -714, -3712, -1248]
def DC001_17_pim : Polynomial ℚ := interpQ 2 [696, 1008, -360, 3774, 2496, -628, 9486, 1122, 574, 16618, -5270, 6792, 17504, -10340, 14350, 9598, -10666, 16448, -604, -5822, 10966, -4368, -840, 4422, -3588, 420, 684, -1344]
theorem DC001_17_ab_pre_eq :
    N_re_0_5 * N_re_1_1 - N_im_0_5 * N_im_1_1 =
      DC001_17_ab_pre := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_1, z_N_im_1_1, DC001_17_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_17_ab_pim_eq :
    N_re_0_5 * N_im_1_1 + N_im_0_5 * N_re_1_1 =
      DC001_17_ab_pim := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_1, z_N_im_1_1, DC001_17_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_17_ab_mul :
    N_entry_0_5 * N_entry_1_1 =
      ofLadj DC001_17_ab_pre DC001_17_ab_pim := by
  rw [N_entry_0_5, N_entry_1_1, ofLadj_mul,
    DC001_17_ab_pre_eq, DC001_17_ab_pim_eq]

theorem DC001_17_pre_eq :
    DC001_17_ab_pre * N_re_2_0 - DC001_17_ab_pim * N_im_2_0 =
      DC001_17_pre := by
  simp only [DC001_17_ab_pre, DC001_17_ab_pim, z_N_re_2_0, z_N_im_2_0, DC001_17_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_17_pim_eq :
    DC001_17_ab_pre * N_im_2_0 + DC001_17_ab_pim * N_re_2_0 =
      DC001_17_pim := by
  simp only [DC001_17_ab_pre, DC001_17_ab_pim, z_N_re_2_0, z_N_im_2_0, DC001_17_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC001_17_mul :
    N_entry_0_5 * N_entry_1_1 * N_entry_2_0 =
      ofLadj DC001_17_pre DC001_17_pim := by
  rw [DC001_17_ab_mul, N_entry_2_0, ofLadj_mul, DC001_17_pre_eq, DC001_17_pim_eq]

def DC001_17_spre : Polynomial ℚ := interpQ 2 [552, 2208, 1944, 1030, 7452, 1712, 4404, 14200, 486, 14802, 21366, -334, 25816, 17848, 2578, 31560, 10306, 8862, 28524, 3836, 10834, 15160, 1146, 8502, 5844, 714, 3712, 1248]
def DC001_17_spim : Polynomial ℚ := interpQ 2 [-696, -1008, 360, -3774, -2496, 628, -9486, -1122, -574, -16618, 5270, -6792, -17504, 10340, -14350, -9598, 10666, -16448, 604, 5822, -10966, 4368, 840, -4422, 3588, -420, -684, 1344]
theorem DC001_17_spre_eq : -DC001_17_pre = DC001_17_spre := by
  simp only [DC001_17_pre, DC001_17_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_17_spim_eq : -DC001_17_pim = DC001_17_spim := by
  simp only [DC001_17_pim, DC001_17_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
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
def DC001_g0_qre : Polynomial ℚ := interpQ 2 [-1842, -5134, -2547, -10213, -10845, -5127, -15102, -6508, -6444, -17916, -4120, -9738, -11550, -526, -5424, -764, 1984, -2174]
def DC001_g0_qim : Polynomial ℚ := interpQ 2 [1186, -590, 1754, 7622, 1498, 9860, 12199, 5191, 19218, 9936, 7722, 19094, 7516, 10928, 12092, 4068, 7370, 3374]
def DC001_g0_rre : Polynomial ℚ := interpQ 2 [-309, 0, -92, -292, 61, -207, -207, 61, -292, -92]
def DC001_g0_rim : Polynomial ℚ := interpQ 2 [-147, -294, 45, -259, -199, 22, -316, -95, -35, -339]
def DC001_g0a_qre : Polynomial ℚ := interpQ 2 [-350538, 323038, -100866, -205726, 298070, -229808, -41818, 171992, -227654, 44872, 36536, -128900, 52612, -17654, -48304, 22548, -16044, -11058]
def DC001_g0a_rre : Polynomial ℚ := interpQ 2 [352078, 0, 108746, 318486, -65174, 227624, 227624, -65174, 318486, 108746]
theorem DC001_g0a_re :
    DC001_0_pre + DC001_1_pre + DC001_2_pre =
      DC001_g0a_rre + Phi11 * DC001_g0a_qre := by
  rw [phi11_interpQ]
  simp only [DC001_0_pre, DC001_1_pre, DC001_2_pre, DC001_g0a_rre, DC001_g0a_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC001_g0b_qre : Polynomial ℚ := interpQ 2 [348696, -328172, 98319, 195513, -308915, 224681, 26716, -178500, 221210, -62788, -40656, 119162, -64162, 17128, 42880, -23312, 18028, 8884]
def DC001_g0b_rre : Polynomial ℚ := interpQ 2 [-352387, 0, -108838, -318778, 65235, -227831, -227831, 65235, -318778, -108838]
theorem DC001_g0b_re :
    DC001_3_spre + DC001_4_spre + DC001_5_spre =
      DC001_g0b_rre + Phi11 * DC001_g0b_qre := by
  rw [phi11_interpQ]
  simp only [DC001_3_spre, DC001_4_spre, DC001_5_spre, DC001_g0b_rre, DC001_g0b_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_g0_rre_split :
    DC001_g0a_rre + DC001_g0b_rre = DC001_g0_rre := by
  simp only [DC001_g0a_rre, DC001_g0b_rre, DC001_g0_rre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_g0_qre_split :
    DC001_g0a_qre + DC001_g0b_qre = DC001_g0_qre := by
  simp only [DC001_g0a_qre, DC001_g0b_qre, DC001_g0_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC001_g0a_qim : Polynomial ℚ := interpQ 2 [-148978, -153778, 348004, -268382, 41336, 218450, -252026, 157982, 74062, -137566, 142824, -11270, -38394, 78050, -21594, 898, 22986, -5886]
def DC001_g0a_rim : Polynomial ℚ := interpQ 2 [160912, 321824, -50004, 276154, 220664, -32646, 354470, 101160, 45670, 371828]
theorem DC001_g0a_im :
    DC001_0_pim + DC001_1_pim + DC001_2_pim =
      DC001_g0a_rim + Phi11 * DC001_g0a_qim := by
  rw [phi11_interpQ]
  simp only [DC001_0_pim, DC001_1_pim, DC001_2_pim, DC001_g0a_rim, DC001_g0a_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC001_g0b_qim : Polynomial ℚ := interpQ 2 [150164, 153188, -346250, 276004, -39838, -208590, 264225, -152791, -54844, 147502, -135102, 30364, 45910, -67122, 33686, 3170, -15616, 9260]
def DC001_g0b_rim : Polynomial ℚ := interpQ 2 [-161059, -322118, 50049, -276413, -220863, 32668, -354786, -101255, -45705, -372167]
theorem DC001_g0b_im :
    DC001_3_spim + DC001_4_spim + DC001_5_spim =
      DC001_g0b_rim + Phi11 * DC001_g0b_qim := by
  rw [phi11_interpQ]
  simp only [DC001_3_spim, DC001_4_spim, DC001_5_spim, DC001_g0b_rim, DC001_g0b_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_g0_rim_split :
    DC001_g0a_rim + DC001_g0b_rim = DC001_g0_rim := by
  simp only [DC001_g0a_rim, DC001_g0b_rim, DC001_g0_rim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_g0_qim_split :
    DC001_g0a_qim + DC001_g0b_qim = DC001_g0_qim := by
  simp only [DC001_g0a_qim, DC001_g0b_qim, DC001_g0_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
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
def DC001_g1_qre : Polynomial ℚ := interpQ 2 [-381, 1345, -1182, 3172, 889, -1866, 2533, -3677, -2450, 4616, -3712, 2216, 3380, -2808, 608, -688, -3192, 1008]
def DC001_g1_qim : Polynomial ℚ := interpQ 2 [-926, -974, -3668, -6939, -3768, -9322, -8601, -5278, -13666, -6952, -6816, -13696, -5488, -7396, -8314, -2670, -4632, -2896]
def DC001_g1_rre : Polynomial ℚ := interpQ 2 [638, 0, 193, 577, -127, 408, 408, -127, 577, 193]
def DC001_g1_rim : Polynomial ℚ := interpQ 2 [293, 586, -95, 502, 398, -58, 644, 188, 84, 681]
def DC001_g1a_qre : Polynomial ℚ := interpQ 2 [-350445, 331825, -98944, -195062, 311991, -225726, -23555, 179735, -220792, 66134, 39174, -119134, 64266, -18950, -41972, 23152, -18152, -7808]
def DC001_g1a_rre : Polynomial ℚ := interpQ 2 [355372, 0, 109719, 321379, -65911, 229596, 229596, -65911, 321379, 109719]
theorem DC001_g1a_re :
    DC001_6_pre + DC001_7_pre + DC001_8_pre =
      DC001_g1a_rre + Phi11 * DC001_g1a_qre := by
  rw [phi11_interpQ]
  simp only [DC001_6_pre, DC001_7_pre, DC001_8_pre, DC001_g1a_rre, DC001_g1a_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC001_g1b_qre : Polynomial ℚ := interpQ 2 [350064, -330480, 97762, 198234, -311102, 223860, 26088, -183412, 218342, -61518, -42886, 121350, -60886, 16142, 42580, -23840, 14960, 8816]
def DC001_g1b_rre : Polynomial ℚ := interpQ 2 [-354734, 0, -109526, -320802, 65784, -229188, -229188, 65784, -320802, -109526]
theorem DC001_g1b_re :
    DC001_9_spre + DC001_10_spre + DC001_11_spre =
      DC001_g1b_rre + Phi11 * DC001_g1b_qre := by
  rw [phi11_interpQ]
  simp only [DC001_9_spre, DC001_10_spre, DC001_11_spre, DC001_g1b_rre, DC001_g1b_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_g1_rre_split :
    DC001_g1a_rre + DC001_g1b_rre = DC001_g1_rre := by
  simp only [DC001_g1a_rre, DC001_g1b_rre, DC001_g1_rre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_g1_qre_split :
    DC001_g1a_qre + DC001_g1b_qre = DC001_g1_qre := by
  simp only [DC001_g1a_qre, DC001_g1b_qre, DC001_g1_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC001_g1a_qim : Polynomial ℚ := interpQ 2 [-151586, -154226, 348174, -278429, 41096, 208020, -266099, 154958, 52154, -147476, 135202, -32624, -43884, 67732, -33590, -874, 16224, -8544]
def DC001_g1a_rim : Polynomial ℚ := interpQ 2 [162367, 324734, -50593, 278606, 222614, -33022, 357756, 102120, 46128, 375327]
theorem DC001_g1a_im :
    DC001_6_pim + DC001_7_pim + DC001_8_pim =
      DC001_g1a_rim + Phi11 * DC001_g1a_qim := by
  rw [phi11_interpQ]
  simp only [DC001_6_pim, DC001_7_pim, DC001_8_pim, DC001_g1a_rim, DC001_g1a_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC001_g1b_qim : Polynomial ℚ := interpQ 2 [150660, 153252, -351842, 271490, -44864, -217342, 257498, -160236, -65820, 140524, -142018, 18928, 38396, -75128, 25276, -1796, -20856, 5648]
def DC001_g1b_rim : Polynomial ℚ := interpQ 2 [-162074, -324148, 50498, -278104, -222216, 32964, -357112, -101932, -46044, -374646]
theorem DC001_g1b_im :
    DC001_9_spim + DC001_10_spim + DC001_11_spim =
      DC001_g1b_rim + Phi11 * DC001_g1b_qim := by
  rw [phi11_interpQ]
  simp only [DC001_9_spim, DC001_10_spim, DC001_11_spim, DC001_g1b_rim, DC001_g1b_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_g1_rim_split :
    DC001_g1a_rim + DC001_g1b_rim = DC001_g1_rim := by
  simp only [DC001_g1a_rim, DC001_g1b_rim, DC001_g1_rim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_g1_qim_split :
    DC001_g1a_qim + DC001_g1b_qim = DC001_g1_qim := by
  simp only [DC001_g1a_qim, DC001_g1b_qim, DC001_g1_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
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
def DC001_g2_qre : Polynomial ℚ := interpQ 2 [2252, 3980, 2392, 5546, 7622, 3336, 8176, 5384, 4022, 8444, 2928, 2596, 3082, -342, 1294, -786, -204, 750]
def DC001_g2_qim : Polynomial ℚ := interpQ 2 [-1508, -440, -702, -4718, -1368, -4884, -6968, -3016, -8632, -6194, -3776, -7258, -3092, -3788, -2810, -650, -1518, 66]
def DC001_g2_rre : Polynomial ℚ := interpQ 2 [-322, 0, -98, -278, 64, -198, -198, 64, -278, -98]
def DC001_g2_rim : Polynomial ℚ := interpQ 2 [-144, -288, 48, -240, -194, 34, -322, -94, -48, -336]
def DC001_g2a_qre : Polynomial ℚ := interpQ 2 [-346818, 327698, -95298, -196738, 309292, -219602, -25800, 183124, -213334, 59054, 44894, -119870, 58534, -14626, -42480, 22460, -13328, -9808]
def DC001_g2a_rre : Polynomial ℚ := interpQ 2 [352116, 0, 108682, 318458, -65272, 227498, 227498, -65272, 318458, 108682]
theorem DC001_g2a_re :
    DC001_12_pre + DC001_13_pre + DC001_14_pre =
      DC001_g2a_rre + Phi11 * DC001_g2a_qre := by
  rw [phi11_interpQ]
  simp only [DC001_12_pre, DC001_13_pre, DC001_14_pre, DC001_g2a_rre, DC001_g2a_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC001_g2b_qre : Polynomial ℚ := interpQ 2 [349070, -323718, 97690, 202284, -301670, 222938, 33976, -177740, 217356, -50610, -41966, 122466, -55452, 14284, 43774, -23246, 13124, 10558]
def DC001_g2b_rre : Polynomial ℚ := interpQ 2 [-352438, 0, -108780, -318736, 65336, -227696, -227696, 65336, -318736, -108780]
theorem DC001_g2b_re :
    DC001_15_spre + DC001_16_spre + DC001_17_spre =
      DC001_g2b_rre + Phi11 * DC001_g2b_qre := by
  rw [phi11_interpQ]
  simp only [DC001_15_spre, DC001_16_spre, DC001_17_spre, DC001_g2b_rre, DC001_g2b_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_g2_rre_split :
    DC001_g2a_rre + DC001_g2b_rre = DC001_g2_rre := by
  simp only [DC001_g2a_rre, DC001_g2b_rre, DC001_g2_rre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_g2_qre_split :
    DC001_g2a_qre + DC001_g2b_qre = DC001_g2_qre := by
  simp only [DC001_g2a_qre, DC001_g2b_qre, DC001_g2_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC001_g2a_qim : Polynomial ℚ := interpQ 2 [-149250, -151674, 349308, -267994, 43788, 216046, -254034, 156530, 67504, -138888, 138602, -15772, -39108, 74028, -22880, 1124, 21700, -4508]
def DC001_g2a_rim : Polynomial ℚ := interpQ 2 [160864, 321728, -50128, 276082, 220548, -32736, 354464, 101180, 45646, 371856]
theorem DC001_g2a_im :
    DC001_12_pim + DC001_13_pim + DC001_14_pim =
      DC001_g2a_rim + Phi11 * DC001_g2a_qim := by
  rw [phi11_interpQ]
  simp only [DC001_12_pim, DC001_13_pim, DC001_14_pim, DC001_g2a_rim, DC001_g2a_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC001_g2b_qim : Polynomial ℚ := interpQ 2 [147742, 151234, -350010, 263276, -45156, -220930, 247066, -159546, -76136, 132694, -142378, 8514, 36016, -77816, 20070, -1774, -23218, 4574]
def DC001_g2b_rim : Polynomial ℚ := interpQ 2 [-161008, -322016, 50176, -276322, -220742, 32770, -354786, -101274, -45694, -372192]
theorem DC001_g2b_im :
    DC001_15_spim + DC001_16_spim + DC001_17_spim =
      DC001_g2b_rim + Phi11 * DC001_g2b_qim := by
  rw [phi11_interpQ]
  simp only [DC001_15_spim, DC001_16_spim, DC001_17_spim, DC001_g2b_rim, DC001_g2b_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_g2_rim_split :
    DC001_g2a_rim + DC001_g2b_rim = DC001_g2_rim := by
  simp only [DC001_g2a_rim, DC001_g2b_rim, DC001_g2_rim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_g2_qim_split :
    DC001_g2a_qim + DC001_g2b_qim = DC001_g2_qim := by
  simp only [DC001_g2a_qim, DC001_g2b_qim, DC001_g2_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
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
def DC001_g3_qre : Polynomial ℚ := interpQ 1 []
def DC001_g3_qim : Polynomial ℚ := interpQ 1 []
theorem DC001_rem_re :
    DC001_g0_rre + DC001_g1_rre + DC001_g2_rre =
      Fplus_re_001 + Phi11 * DC001_g3_qre := by
  rw [phi11_interpQ]
  simp only [DC001_g0_rre, DC001_g1_rre, DC001_g2_rre, z_Fplus_re_001, DC001_g3_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC001_rem_im :
    DC001_g0_rim + DC001_g1_rim + DC001_g2_rim =
      Fplus_im_001 + Phi11 * DC001_g3_qim := by
  rw [phi11_interpQ]
  simp only [DC001_g0_rim, DC001_g1_rim, DC001_g2_rim, z_Fplus_im_001, DC001_g3_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

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
