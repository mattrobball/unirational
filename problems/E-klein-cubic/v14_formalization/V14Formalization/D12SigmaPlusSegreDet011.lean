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

def DC011_0_ab_pre : Polynomial ℚ := interpQ 2 [96, 0, 104, 180, 40, 208, 184, 8, 264, 76, -16, 152, -16, -28, 84, -64, 8, 32, -32]
def DC011_0_ab_pim : Polynomial ℚ := interpQ 2 [48, 96, -24, 132, 72, -56, 176, -8, -8, 260, -24, 72, 168, 4, 116, 112, 40, 80, 64]
def DC011_0_pre : Polynomial ℚ := interpQ 2 [-1536, 2304, -1136, -4296, 5440, -8184, -5608, 6992, -19144, 912, 6576, -22800, 11280, 1480, -15728, 20272, -1344, -2000, 21504, 96, 5720, 13480, 720, 6472, 6288, 976, 2784, 1920]
def DC011_0_pim : Polynomial ℚ := interpQ 2 [-2208, -4416, -912, -11304, -9440, -4952, -24728, -10080, -13000, -37904, -5552, -23536, -35296, -856, -29264, -23584, 128, -27888, -11264, -1648, -16984, -3272, -2816, -8584, -464, -1904, -2752, 320]
theorem DC011_0_ab_pre_eq :
    N_re_0_0 * N_re_1_4 - N_im_0_0 * N_im_1_4 =
      DC011_0_ab_pre := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_4, z_N_im_1_4, DC011_0_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_0_ab_pim_eq :
    N_re_0_0 * N_im_1_4 + N_im_0_0 * N_re_1_4 =
      DC011_0_ab_pim := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_4, z_N_im_1_4, DC011_0_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_0_ab_mul :
    N_entry_0_0 * N_entry_1_4 =
      ofLadj DC011_0_ab_pre DC011_0_ab_pim := by
  rw [N_entry_0_0, N_entry_1_4, ofLadj_mul,
    DC011_0_ab_pre_eq, DC011_0_ab_pim_eq]

theorem DC011_0_pre_eq :
    DC011_0_ab_pre * N_re_2_5 - DC011_0_ab_pim * N_im_2_5 =
      DC011_0_pre := by
  simp only [DC011_0_ab_pre, DC011_0_ab_pim, z_N_re_2_5, z_N_im_2_5, DC011_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_0_pim_eq :
    DC011_0_ab_pre * N_im_2_5 + DC011_0_ab_pim * N_re_2_5 =
      DC011_0_pim := by
  simp only [DC011_0_ab_pre, DC011_0_ab_pim, z_N_re_2_5, z_N_im_2_5, DC011_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_0_mul :
    N_entry_0_0 * N_entry_1_4 * N_entry_2_5 =
      ofLadj DC011_0_pre DC011_0_pim := by
  rw [DC011_0_ab_mul, N_entry_2_5, ofLadj_mul, DC011_0_pre_eq, DC011_0_pim_eq]

def DC011_1_ab_pre : Polynomial ℚ := interpQ 2 [190, -384, -230, 232, -1020, 160, 56, -1256, 812, -446, -1120, 904, -736, -216, 580, -572, 56, 160, -336]
def DC011_1_ab_pim : Polynomial ℚ := interpQ 2 [340, 680, 126, 1214, 1140, 550, 2338, 1288, 1162, 3174, 844, 1480, 2116, 340, 1264, 1020, 48, 704, 192]
def DC011_1_pre : Polynomial ℚ := interpQ 2 [-2745, 53656, 41361, 25968, 203444, 67294, 144344, 405381, 57126, 399466, 562741, 57260, 659975, 467515, 112236, 742899, 257143, 196821, 595818, 79322, 208910, 291668, 5216, 140778, 99500, -1756, 54856, 16728]
def DC011_1_pim : Polynomial ℚ := interpQ 2 [-23675, -38326, 12189, -103306, -76862, 5170, -280790, -74331, -95470, -506230, 4067, -285310, -546373, 69009, -489668, -396445, 49135, -523037, -157580, -12330, -336290, -8348, -57964, -144918, 27424, -33124, -28680, 15624]
theorem DC011_1_ab_pre_eq :
    N_re_0_1 * N_re_1_5 - N_im_0_1 * N_im_1_5 =
      DC011_1_ab_pre := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_5, z_N_im_1_5, DC011_1_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_1_ab_pim_eq :
    N_re_0_1 * N_im_1_5 + N_im_0_1 * N_re_1_5 =
      DC011_1_ab_pim := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_5, z_N_im_1_5, DC011_1_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_1_ab_mul :
    N_entry_0_1 * N_entry_1_5 =
      ofLadj DC011_1_ab_pre DC011_1_ab_pim := by
  rw [N_entry_0_1, N_entry_1_5, ofLadj_mul,
    DC011_1_ab_pre_eq, DC011_1_ab_pim_eq]

theorem DC011_1_pre_eq :
    DC011_1_ab_pre * N_re_2_3 - DC011_1_ab_pim * N_im_2_3 =
      DC011_1_pre := by
  simp only [DC011_1_ab_pre, DC011_1_ab_pim, z_N_re_2_3, z_N_im_2_3, DC011_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_1_pim_eq :
    DC011_1_ab_pre * N_im_2_3 + DC011_1_ab_pim * N_re_2_3 =
      DC011_1_pim := by
  simp only [DC011_1_ab_pre, DC011_1_ab_pim, z_N_re_2_3, z_N_im_2_3, DC011_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_1_mul :
    N_entry_0_1 * N_entry_1_5 * N_entry_2_3 =
      ofLadj DC011_1_pre DC011_1_pim := by
  rw [DC011_1_ab_mul, N_entry_2_3, ofLadj_mul, DC011_1_pre_eq, DC011_1_pim_eq]

def DC011_2_ab_pre : Polynomial ℚ := interpQ 2 [276, -288, -84, 469, -901, 250, 76, -1483, 601, -770, -1470, 588, -1182, -686, 132, -1062, -286, -112, -480]
def DC011_2_ab_pim : Polynomial ℚ := interpQ 2 [318, 636, -128, 823, 601, -224, 1562, 409, 201, 2366, -114, 612, 1338, -378, 836, 690, -134, 656, 160]
def DC011_2_pre : Polynomial ℚ := interpQ 2 [-2256, 21600, 13008, -2206, 72866, 4831, 28768, 145314, -19377, 127177, 201415, -36728, 235875, 152515, -5165, 291676, 76644, 60227, 247788, 14380, 85398, 124648, -932, 68588, 47052, 2374, 28560, 7520]
def DC011_2_pim : Polynomial ℚ := interpQ 2 [-10308, -17160, 9062, -38944, -23360, 25797, -95132, 9218, 18899, -158121, 88103, -27084, -137855, 153709, -96529, -52058, 147912, -122049, 37208, 84776, -76638, 63076, 21336, -28276, 39876, -314, -3120, 11360]
theorem DC011_2_ab_pre_eq :
    N_re_0_2 * N_re_1_3 - N_im_0_2 * N_im_1_3 =
      DC011_2_ab_pre := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_3, z_N_im_1_3, DC011_2_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_2_ab_pim_eq :
    N_re_0_2 * N_im_1_3 + N_im_0_2 * N_re_1_3 =
      DC011_2_ab_pim := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_3, z_N_im_1_3, DC011_2_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_2_ab_mul :
    N_entry_0_2 * N_entry_1_3 =
      ofLadj DC011_2_ab_pre DC011_2_ab_pim := by
  rw [N_entry_0_2, N_entry_1_3, ofLadj_mul,
    DC011_2_ab_pre_eq, DC011_2_ab_pim_eq]

theorem DC011_2_pre_eq :
    DC011_2_ab_pre * N_re_2_4 - DC011_2_ab_pim * N_im_2_4 =
      DC011_2_pre := by
  simp only [DC011_2_ab_pre, DC011_2_ab_pim, z_N_re_2_4, z_N_im_2_4, DC011_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_2_pim_eq :
    DC011_2_ab_pre * N_im_2_4 + DC011_2_ab_pim * N_re_2_4 =
      DC011_2_pim := by
  simp only [DC011_2_ab_pre, DC011_2_ab_pim, z_N_re_2_4, z_N_im_2_4, DC011_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_2_mul :
    N_entry_0_2 * N_entry_1_3 * N_entry_2_4 =
      ofLadj DC011_2_pre DC011_2_pim := by
  rw [DC011_2_ab_mul, N_entry_2_4, ofLadj_mul, DC011_2_pre_eq, DC011_2_pim_eq]

def DC011_3_ab_pre : Polynomial ℚ := interpQ 2 [104, 0, 108, 182, 40, 208, 184, 8, 266, 80, -16, 152, -16, -28, 84, -64, 8, 32, -32]
def DC011_3_ab_pim : Polynomial ℚ := interpQ 2 [48, 96, -28, 130, 72, -60, 180, -8, -6, 264, -24, 72, 168, 4, 116, 112, 40, 80, 64]
def DC011_3_pre : Polynomial ℚ := interpQ 2 [-1712, 2304, -1232, -4532, 5612, -8058, -5394, 7782, -18516, 1828, 7848, -21660, 12452, 2736, -14664, 21118, -666, -1442, 21732, 304, 5876, 13408, 760, 6500, 6200, 984, 2784, 1888]
def DC011_3_pim : Polynomial ℚ := interpQ 2 [-2304, -4608, -808, -11396, -9460, -4542, -24622, -9754, -12492, -37828, -5136, -23016, -34892, -360, -28632, -22902, 694, -27114, -10476, -960, -16100, -2536, -2280, -8028, -104, -1720, -2608, 384]
theorem DC011_3_ab_pre_eq :
    N_re_0_0 * N_re_1_5 - N_im_0_0 * N_im_1_5 =
      DC011_3_ab_pre := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_5, z_N_im_1_5, DC011_3_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_3_ab_pim_eq :
    N_re_0_0 * N_im_1_5 + N_im_0_0 * N_re_1_5 =
      DC011_3_ab_pim := by
  simp only [z_N_re_0_0, z_N_im_0_0, z_N_re_1_5, z_N_im_1_5, DC011_3_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_3_ab_mul :
    N_entry_0_0 * N_entry_1_5 =
      ofLadj DC011_3_ab_pre DC011_3_ab_pim := by
  rw [N_entry_0_0, N_entry_1_5, ofLadj_mul,
    DC011_3_ab_pre_eq, DC011_3_ab_pim_eq]

theorem DC011_3_pre_eq :
    DC011_3_ab_pre * N_re_2_4 - DC011_3_ab_pim * N_im_2_4 =
      DC011_3_pre := by
  simp only [DC011_3_ab_pre, DC011_3_ab_pim, z_N_re_2_4, z_N_im_2_4, DC011_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_3_pim_eq :
    DC011_3_ab_pre * N_im_2_4 + DC011_3_ab_pim * N_re_2_4 =
      DC011_3_pim := by
  simp only [DC011_3_ab_pre, DC011_3_ab_pim, z_N_re_2_4, z_N_im_2_4, DC011_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_3_mul :
    N_entry_0_0 * N_entry_1_5 * N_entry_2_4 =
      ofLadj DC011_3_pre DC011_3_pim := by
  rw [DC011_3_ab_mul, N_entry_2_4, ofLadj_mul, DC011_3_pre_eq, DC011_3_pim_eq]

def DC011_3_spre : Polynomial ℚ := interpQ 2 [1712, -2304, 1232, 4532, -5612, 8058, 5394, -7782, 18516, -1828, -7848, 21660, -12452, -2736, 14664, -21118, 666, 1442, -21732, -304, -5876, -13408, -760, -6500, -6200, -984, -2784, -1888]
def DC011_3_spim : Polynomial ℚ := interpQ 2 [2304, 4608, 808, 11396, 9460, 4542, 24622, 9754, 12492, 37828, 5136, 23016, 34892, 360, 28632, 22902, -694, 27114, 10476, 960, 16100, 2536, 2280, 8028, 104, 1720, 2608, -384]
theorem DC011_3_spre_eq : -DC011_3_pre = DC011_3_spre := by
  simp only [DC011_3_pre, DC011_3_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_3_spim_eq : -DC011_3_pim = DC011_3_spim := by
  simp only [DC011_3_pim, DC011_3_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_3_smul :
    -(N_entry_0_0 * N_entry_1_5 * N_entry_2_4) =
      ofLadj DC011_3_spre DC011_3_spim := by
  rw [DC011_3_mul, ofLadj_neg, DC011_3_spre_eq, DC011_3_spim_eq]

def DC011_4_ab_pre : Polynomial ℚ := interpQ 2 [446, -768, -302, 801, -2019, 610, 339, -2780, 1812, -1220, -2782, 1762, -2014, -918, 1011, -1601, -45, 226, -840]
def DC011_4_ab_pim : Polynomial ℚ := interpQ 2 [728, 1456, 158, 2475, 2177, 644, 4535, 2032, 1688, 6348, 1076, 2672, 4268, 294, 2637, 2111, 29, 1592, 480]
def DC011_4_pre : Polynomial ℚ := interpQ 2 [-1076, 51840, 38460, 23850, 191490, 57198, 130682, 380790, 40080, 377150, 536202, 37992, 639250, 451866, 102336, 739692, 256996, 202712, 610376, 89096, 222256, 308340, 15536, 153452, 109080, 2990, 59984, 19200]
def DC011_4_pim : Polynomial ℚ := interpQ 2 [-21368, -33520, 13648, -94934, -65654, 16342, -254954, -45118, -59096, -450346, 59946, -221220, -472774, 145570, -411400, -317576, 126536, -455156, -95072, 42548, -298464, 26780, -32028, -129664, 40360, -26350, -25812, 18000]
theorem DC011_4_ab_pre_eq :
    N_re_0_1 * N_re_1_3 - N_im_0_1 * N_im_1_3 =
      DC011_4_ab_pre := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_3, z_N_im_1_3, DC011_4_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_4_ab_pim_eq :
    N_re_0_1 * N_im_1_3 + N_im_0_1 * N_re_1_3 =
      DC011_4_ab_pim := by
  simp only [z_N_re_0_1, z_N_im_0_1, z_N_re_1_3, z_N_im_1_3, DC011_4_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_4_ab_mul :
    N_entry_0_1 * N_entry_1_3 =
      ofLadj DC011_4_ab_pre DC011_4_ab_pim := by
  rw [N_entry_0_1, N_entry_1_3, ofLadj_mul,
    DC011_4_ab_pre_eq, DC011_4_ab_pim_eq]

theorem DC011_4_pre_eq :
    DC011_4_ab_pre * N_re_2_5 - DC011_4_ab_pim * N_im_2_5 =
      DC011_4_pre := by
  simp only [DC011_4_ab_pre, DC011_4_ab_pim, z_N_re_2_5, z_N_im_2_5, DC011_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_4_pim_eq :
    DC011_4_ab_pre * N_im_2_5 + DC011_4_ab_pim * N_re_2_5 =
      DC011_4_pim := by
  simp only [DC011_4_ab_pre, DC011_4_ab_pim, z_N_re_2_5, z_N_im_2_5, DC011_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_4_mul :
    N_entry_0_1 * N_entry_1_3 * N_entry_2_5 =
      ofLadj DC011_4_pre DC011_4_pim := by
  rw [DC011_4_ab_mul, N_entry_2_5, ofLadj_mul, DC011_4_pre_eq, DC011_4_pim_eq]

def DC011_4_spre : Polynomial ℚ := interpQ 2 [1076, -51840, -38460, -23850, -191490, -57198, -130682, -380790, -40080, -377150, -536202, -37992, -639250, -451866, -102336, -739692, -256996, -202712, -610376, -89096, -222256, -308340, -15536, -153452, -109080, -2990, -59984, -19200]
def DC011_4_spim : Polynomial ℚ := interpQ 2 [21368, 33520, -13648, 94934, 65654, -16342, 254954, 45118, 59096, 450346, -59946, 221220, 472774, -145570, 411400, 317576, -126536, 455156, 95072, -42548, 298464, -26780, 32028, 129664, -40360, 26350, 25812, -18000]
theorem DC011_4_spre_eq : -DC011_4_pre = DC011_4_spre := by
  simp only [DC011_4_pre, DC011_4_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_4_spim_eq : -DC011_4_pim = DC011_4_spim := by
  simp only [DC011_4_pim, DC011_4_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_4_smul :
    -(N_entry_0_1 * N_entry_1_3 * N_entry_2_5) =
      ofLadj DC011_4_spre DC011_4_spim := by
  rw [DC011_4_mul, ofLadj_neg, DC011_4_spre_eq, DC011_4_spim_eq]

def DC011_5_ab_pre : Polynomial ℚ := interpQ 2 [108, -144, -72, 168, -408, 104, 24, -648, 232, -376, -712, 192, -568, -304, 64, -432, -96, -16, -192]
def DC011_5_ab_pim : Polynomial ℚ := interpQ 2 [144, 288, -24, 408, 320, -28, 748, 240, 144, 1072, 24, 360, 696, -40, 456, 384, -16, 304, 64]
def DC011_5_pre : Polynomial ℚ := interpQ 2 [-2718, 21672, 13782, -762, 75608, 7270, 32674, 150302, -15014, 133928, 209992, -25304, 250288, 167238, 10408, 306690, 91920, 73492, 259372, 27436, 95652, 132876, 5656, 70908, 48560, 2776, 27376, 6976]
def DC011_5_pim : Polynomial ℚ := interpQ 2 [-10674, -17964, 8322, -41526, -27236, 19898, -104314, -1222, 5902, -173632, 72016, -45876, -158864, 129542, -122168, -78766, 121144, -146324, 13692, 63708, -94500, 44980, 6616, -40036, 30400, -5784, -6336, 9728]
theorem DC011_5_ab_pre_eq :
    N_re_0_2 * N_re_1_4 - N_im_0_2 * N_im_1_4 =
      DC011_5_ab_pre := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_4, z_N_im_1_4, DC011_5_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_5_ab_pim_eq :
    N_re_0_2 * N_im_1_4 + N_im_0_2 * N_re_1_4 =
      DC011_5_ab_pim := by
  simp only [z_N_re_0_2, z_N_im_0_2, z_N_re_1_4, z_N_im_1_4, DC011_5_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_5_ab_mul :
    N_entry_0_2 * N_entry_1_4 =
      ofLadj DC011_5_ab_pre DC011_5_ab_pim := by
  rw [N_entry_0_2, N_entry_1_4, ofLadj_mul,
    DC011_5_ab_pre_eq, DC011_5_ab_pim_eq]

theorem DC011_5_pre_eq :
    DC011_5_ab_pre * N_re_2_3 - DC011_5_ab_pim * N_im_2_3 =
      DC011_5_pre := by
  simp only [DC011_5_ab_pre, DC011_5_ab_pim, z_N_re_2_3, z_N_im_2_3, DC011_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_5_pim_eq :
    DC011_5_ab_pre * N_im_2_3 + DC011_5_ab_pim * N_re_2_3 =
      DC011_5_pim := by
  simp only [DC011_5_ab_pre, DC011_5_ab_pim, z_N_re_2_3, z_N_im_2_3, DC011_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_5_mul :
    N_entry_0_2 * N_entry_1_4 * N_entry_2_3 =
      ofLadj DC011_5_pre DC011_5_pim := by
  rw [DC011_5_ab_mul, N_entry_2_3, ofLadj_mul, DC011_5_pre_eq, DC011_5_pim_eq]

def DC011_5_spre : Polynomial ℚ := interpQ 2 [2718, -21672, -13782, 762, -75608, -7270, -32674, -150302, 15014, -133928, -209992, 25304, -250288, -167238, -10408, -306690, -91920, -73492, -259372, -27436, -95652, -132876, -5656, -70908, -48560, -2776, -27376, -6976]
def DC011_5_spim : Polynomial ℚ := interpQ 2 [10674, 17964, -8322, 41526, 27236, -19898, 104314, 1222, -5902, 173632, -72016, 45876, 158864, -129542, 122168, 78766, -121144, 146324, -13692, -63708, 94500, -44980, -6616, 40036, -30400, 5784, 6336, -9728]
theorem DC011_5_spre_eq : -DC011_5_pre = DC011_5_spre := by
  simp only [DC011_5_pre, DC011_5_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_5_spim_eq : -DC011_5_pim = DC011_5_spim := by
  simp only [DC011_5_pim, DC011_5_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_5_smul :
    -(N_entry_0_2 * N_entry_1_4 * N_entry_2_3) =
      ofLadj DC011_5_spre DC011_5_spim := by
  rw [DC011_5_mul, ofLadj_neg, DC011_5_spre_eq, DC011_5_spim_eq]

def DC011_6_ab_pre : Polynomial ℚ := interpQ 2 [684, -608, 196, 1217, -1545, 1056, 793, -2432, 2228, -810, -2370, 1934, -1762, -1006, 1011, -1659, -73, 190, -772]
def DC011_6_ab_pim : Polynomial ℚ := interpQ 2 [722, 1444, 0, 2259, 1879, 130, 4153, 1400, 1268, 5930, 660, 2264, 3868, 42, 2445, 1997, 129, 1560, 696]
def DC011_6_pre : Polynomial ℚ := interpQ 2 [-6384, 48032, 23428, 1702, 165730, 13218, 79262, 324434, -40072, 301342, 448078, -56520, 547718, 364618, 18756, 666544, 195716, 153944, 566648, 69008, 197860, 296296, 15056, 148624, 111156, 8478, 58808, 24272]
def DC011_6_pim : Polynomial ℚ := interpQ 2 [-24092, -40888, 7832, -111338, -79278, 4498, -276926, -54434, -72992, -472034, 53126, -235364, -477010, 147418, -405188, -309228, 132848, -442372, -94864, 47324, -285996, 24536, -24268, -127212, 35332, -25254, -29644, 14504]
theorem DC011_6_ab_pre_eq :
    N_re_0_3 * N_re_1_1 - N_im_0_3 * N_im_1_1 =
      DC011_6_ab_pre := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_1, z_N_im_1_1, DC011_6_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_6_ab_pim_eq :
    N_re_0_3 * N_im_1_1 + N_im_0_3 * N_re_1_1 =
      DC011_6_ab_pim := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_1, z_N_im_1_1, DC011_6_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_6_ab_mul :
    N_entry_0_3 * N_entry_1_1 =
      ofLadj DC011_6_ab_pre DC011_6_ab_pim := by
  rw [N_entry_0_3, N_entry_1_1, ofLadj_mul,
    DC011_6_ab_pre_eq, DC011_6_ab_pim_eq]

theorem DC011_6_pre_eq :
    DC011_6_ab_pre * N_re_2_5 - DC011_6_ab_pim * N_im_2_5 =
      DC011_6_pre := by
  simp only [DC011_6_ab_pre, DC011_6_ab_pim, z_N_re_2_5, z_N_im_2_5, DC011_6_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_6_pim_eq :
    DC011_6_ab_pre * N_im_2_5 + DC011_6_ab_pim * N_re_2_5 =
      DC011_6_pim := by
  simp only [DC011_6_ab_pre, DC011_6_ab_pim, z_N_re_2_5, z_N_im_2_5, DC011_6_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_6_mul :
    N_entry_0_3 * N_entry_1_1 * N_entry_2_5 =
      ofLadj DC011_6_pre DC011_6_pim := by
  rw [DC011_6_ab_mul, N_entry_2_5, ofLadj_mul, DC011_6_pre_eq, DC011_6_pim_eq]

def DC011_7_ab_pre : Polynomial ℚ := interpQ 2 [144, -144, 48, 248, -304, 240, 200, -416, 512, -96, -432, 432, -288, -144, 264, -256, 48, 88, -144]
def DC011_7_ab_pim : Polynomial ℚ := interpQ 2 [168, 336, 48, 568, 512, 168, 992, 424, 432, 1360, 312, 624, 936, 176, 584, 480, 80, 344, 168]
def DC011_7_pre : Polynomial ℚ := interpQ 2 [-4188, 23928, 10092, 596, 82016, 7356, 39612, 155760, -17756, 145292, 213152, -20208, 259992, 176096, 15988, 307828, 93580, 73336, 260200, 37124, 90872, 136104, 9056, 65336, 49976, 2784, 26116, 12012]
def DC011_7_pim : Polynomial ℚ := interpQ 2 [-12876, -22368, 1356, -61572, -47720, -9844, -149852, -45880, -62332, -254324, -11472, -151120, -265208, 18808, -231796, -188268, 12940, -242560, -83880, -10380, -155568, -13928, -28064, -71144, 5608, -18040, -18372, 5196]
theorem DC011_7_ab_pre_eq :
    N_re_0_4 * N_re_1_2 - N_im_0_4 * N_im_1_2 =
      DC011_7_ab_pre := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_2, z_N_im_1_2, DC011_7_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_7_ab_pim_eq :
    N_re_0_4 * N_im_1_2 + N_im_0_4 * N_re_1_2 =
      DC011_7_ab_pim := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_2, z_N_im_1_2, DC011_7_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_7_ab_mul :
    N_entry_0_4 * N_entry_1_2 =
      ofLadj DC011_7_ab_pre DC011_7_ab_pim := by
  rw [N_entry_0_4, N_entry_1_2, ofLadj_mul,
    DC011_7_ab_pre_eq, DC011_7_ab_pim_eq]

theorem DC011_7_pre_eq :
    DC011_7_ab_pre * N_re_2_3 - DC011_7_ab_pim * N_im_2_3 =
      DC011_7_pre := by
  simp only [DC011_7_ab_pre, DC011_7_ab_pim, z_N_re_2_3, z_N_im_2_3, DC011_7_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_7_pim_eq :
    DC011_7_ab_pre * N_im_2_3 + DC011_7_ab_pim * N_re_2_3 =
      DC011_7_pim := by
  simp only [DC011_7_ab_pre, DC011_7_ab_pim, z_N_re_2_3, z_N_im_2_3, DC011_7_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_7_mul :
    N_entry_0_4 * N_entry_1_2 * N_entry_2_3 =
      ofLadj DC011_7_pre DC011_7_pim := by
  rw [DC011_7_ab_mul, N_entry_2_3, ofLadj_mul, DC011_7_pre_eq, DC011_7_pim_eq]

def DC011_8_ab_pre : Polynomial ℚ := interpQ 2 [24, -48, -36, 44, -100, 68, 40, -92, 140, -40, -128, 96, -80, -4, 96, -28, 28, 56, -36]
def DC011_8_ab_pim : Polynomial ℚ := interpQ 2 [48, 96, 36, 204, 172, 116, 304, 188, 140, 392, 128, 216, 304, 100, 184, 156, 20, 88, 12]
def DC011_8_pre : Polynomial ℚ := interpQ 2 [48, 3360, 3264, 2944, 13156, 5696, 10996, 24044, 6320, 25020, 33480, 8468, 40032, 29384, 11880, 42652, 18548, 13812, 34464, 7920, 13220, 17328, 1604, 7416, 5592, -584, 2700, 564]
def DC011_8_pim : Polynomial ℚ := interpQ 2 [-1344, -2112, 504, -6408, -5164, -1864, -17492, -6876, -9152, -30084, -3824, -19452, -32736, -2232, -30480, -25876, -2996, -31300, -12704, -4168, -20756, -4112, -5604, -10016, -232, -2592, -2180, 852]
theorem DC011_8_ab_pre_eq :
    N_re_0_5 * N_re_1_0 - N_im_0_5 * N_im_1_0 =
      DC011_8_ab_pre := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_0, z_N_im_1_0, DC011_8_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_8_ab_pim_eq :
    N_re_0_5 * N_im_1_0 + N_im_0_5 * N_re_1_0 =
      DC011_8_ab_pim := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_0, z_N_im_1_0, DC011_8_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_8_ab_mul :
    N_entry_0_5 * N_entry_1_0 =
      ofLadj DC011_8_ab_pre DC011_8_ab_pim := by
  rw [N_entry_0_5, N_entry_1_0, ofLadj_mul,
    DC011_8_ab_pre_eq, DC011_8_ab_pim_eq]

theorem DC011_8_pre_eq :
    DC011_8_ab_pre * N_re_2_4 - DC011_8_ab_pim * N_im_2_4 =
      DC011_8_pre := by
  simp only [DC011_8_ab_pre, DC011_8_ab_pim, z_N_re_2_4, z_N_im_2_4, DC011_8_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_8_pim_eq :
    DC011_8_ab_pre * N_im_2_4 + DC011_8_ab_pim * N_re_2_4 =
      DC011_8_pim := by
  simp only [DC011_8_ab_pre, DC011_8_ab_pim, z_N_re_2_4, z_N_im_2_4, DC011_8_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_8_mul :
    N_entry_0_5 * N_entry_1_0 * N_entry_2_4 =
      ofLadj DC011_8_pre DC011_8_pim := by
  rw [DC011_8_ab_mul, N_entry_2_4, ofLadj_mul, DC011_8_pre_eq, DC011_8_pim_eq]

def DC011_9_ab_pre : Polynomial ℚ := interpQ 2 [266, -456, -118, 316, -1014, 254, 186, -1166, 1050, -312, -1008, 1052, -552, -194, 734, -484, 162, 230, -332]
def DC011_9_ab_pim : Polynomial ℚ := interpQ 2 [418, 836, 238, 1516, 1486, 846, 2834, 1650, 1658, 3812, 1344, 1964, 2584, 714, 1590, 1252, 254, 830, 376]
def DC011_9_pre : Polynomial ℚ := interpQ 2 [-836, 30096, 22818, 21246, 111188, 49062, 94320, 220770, 62756, 235634, 312776, 85444, 365402, 279882, 115418, 398308, 174284, 141126, 317172, 79216, 122746, 158490, 22644, 75768, 55680, 5308, 28446, 12100]
def DC011_9_pim : Polynomial ℚ := interpQ 2 [-12388, -19304, 4730, -55174, -40612, -5154, -144632, -46866, -66996, -261326, -26072, -168992, -289206, -10870, -265686, -224752, -22372, -276978, -112548, -35476, -177770, -29142, -40188, -79412, 2100, -19804, -18358, 6000]
theorem DC011_9_ab_pre_eq :
    N_re_0_3 * N_re_1_2 - N_im_0_3 * N_im_1_2 =
      DC011_9_ab_pre := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_2, z_N_im_1_2, DC011_9_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_9_ab_pim_eq :
    N_re_0_3 * N_im_1_2 + N_im_0_3 * N_re_1_2 =
      DC011_9_ab_pim := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_2, z_N_im_1_2, DC011_9_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_9_ab_mul :
    N_entry_0_3 * N_entry_1_2 =
      ofLadj DC011_9_ab_pre DC011_9_ab_pim := by
  rw [N_entry_0_3, N_entry_1_2, ofLadj_mul,
    DC011_9_ab_pre_eq, DC011_9_ab_pim_eq]

theorem DC011_9_pre_eq :
    DC011_9_ab_pre * N_re_2_4 - DC011_9_ab_pim * N_im_2_4 =
      DC011_9_pre := by
  simp only [DC011_9_ab_pre, DC011_9_ab_pim, z_N_re_2_4, z_N_im_2_4, DC011_9_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_9_pim_eq :
    DC011_9_ab_pre * N_im_2_4 + DC011_9_ab_pim * N_re_2_4 =
      DC011_9_pim := by
  simp only [DC011_9_ab_pre, DC011_9_ab_pim, z_N_re_2_4, z_N_im_2_4, DC011_9_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_9_mul :
    N_entry_0_3 * N_entry_1_2 * N_entry_2_4 =
      ofLadj DC011_9_pre DC011_9_pim := by
  rw [DC011_9_ab_mul, N_entry_2_4, ofLadj_mul, DC011_9_pre_eq, DC011_9_pim_eq]

def DC011_9_spre : Polynomial ℚ := interpQ 2 [836, -30096, -22818, -21246, -111188, -49062, -94320, -220770, -62756, -235634, -312776, -85444, -365402, -279882, -115418, -398308, -174284, -141126, -317172, -79216, -122746, -158490, -22644, -75768, -55680, -5308, -28446, -12100]
def DC011_9_spim : Polynomial ℚ := interpQ 2 [12388, 19304, -4730, 55174, 40612, 5154, 144632, 46866, 66996, 261326, 26072, 168992, 289206, 10870, 265686, 224752, 22372, 276978, 112548, 35476, 177770, 29142, 40188, 79412, -2100, 19804, 18358, -6000]
theorem DC011_9_spre_eq : -DC011_9_pre = DC011_9_spre := by
  simp only [DC011_9_pre, DC011_9_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_9_spim_eq : -DC011_9_pim = DC011_9_spim := by
  simp only [DC011_9_pim, DC011_9_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_9_smul :
    -(N_entry_0_3 * N_entry_1_2 * N_entry_2_4) =
      ofLadj DC011_9_spre DC011_9_spim := by
  rw [DC011_9_mul, ofLadj_neg, DC011_9_spre_eq, DC011_9_spim_eq]

def DC011_10_ab_pre : Polynomial ℚ := interpQ 2 [24, -48, -36, 44, -100, 68, 40, -92, 140, -40, -128, 96, -80, -4, 96, -28, 28, 56, -36]
def DC011_10_ab_pim : Polynomial ℚ := interpQ 2 [48, 96, 36, 204, 172, 116, 304, 188, 140, 392, 128, 216, 304, 100, 184, 156, 20, 88, 12]
def DC011_10_pre : Polynomial ℚ := interpQ 2 [48, 3360, 3240, 2968, 13216, 5688, 11136, 24176, 6320, 25176, 33496, 8336, 40152, 29352, 11776, 42888, 18592, 13744, 34608, 7792, 13024, 17296, 1408, 7280, 5608, -632, 2680, 600]
def DC011_10_pim : Polynomial ℚ := interpQ 2 [-1344, -2112, 456, -6552, -5344, -2296, -18192, -7680, -10368, -31624, -5368, -21424, -34872, -4216, -32800, -28168, -4992, -33440, -14608, -5648, -22176, -5152, -6272, -10576, -520, -2712, -2280, 840]
theorem DC011_10_ab_pre_eq :
    N_re_0_4 * N_re_1_0 - N_im_0_4 * N_im_1_0 =
      DC011_10_ab_pre := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_0, z_N_im_1_0, DC011_10_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_10_ab_pim_eq :
    N_re_0_4 * N_im_1_0 + N_im_0_4 * N_re_1_0 =
      DC011_10_ab_pim := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_0, z_N_im_1_0, DC011_10_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_10_ab_mul :
    N_entry_0_4 * N_entry_1_0 =
      ofLadj DC011_10_ab_pre DC011_10_ab_pim := by
  rw [N_entry_0_4, N_entry_1_0, ofLadj_mul,
    DC011_10_ab_pre_eq, DC011_10_ab_pim_eq]

theorem DC011_10_pre_eq :
    DC011_10_ab_pre * N_re_2_5 - DC011_10_ab_pim * N_im_2_5 =
      DC011_10_pre := by
  simp only [DC011_10_ab_pre, DC011_10_ab_pim, z_N_re_2_5, z_N_im_2_5, DC011_10_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_10_pim_eq :
    DC011_10_ab_pre * N_im_2_5 + DC011_10_ab_pim * N_re_2_5 =
      DC011_10_pim := by
  simp only [DC011_10_ab_pre, DC011_10_ab_pim, z_N_re_2_5, z_N_im_2_5, DC011_10_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_10_mul :
    N_entry_0_4 * N_entry_1_0 * N_entry_2_5 =
      ofLadj DC011_10_pre DC011_10_pim := by
  rw [DC011_10_ab_mul, N_entry_2_5, ofLadj_mul, DC011_10_pre_eq, DC011_10_pim_eq]

def DC011_10_spre : Polynomial ℚ := interpQ 2 [-48, -3360, -3240, -2968, -13216, -5688, -11136, -24176, -6320, -25176, -33496, -8336, -40152, -29352, -11776, -42888, -18592, -13744, -34608, -7792, -13024, -17296, -1408, -7280, -5608, 632, -2680, -600]
def DC011_10_spim : Polynomial ℚ := interpQ 2 [1344, 2112, -456, 6552, 5344, 2296, 18192, 7680, 10368, 31624, 5368, 21424, 34872, 4216, 32800, 28168, 4992, 33440, 14608, 5648, 22176, 5152, 6272, 10576, 520, 2712, 2280, -840]
theorem DC011_10_spre_eq : -DC011_10_pre = DC011_10_spre := by
  simp only [DC011_10_pre, DC011_10_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_10_spim_eq : -DC011_10_pim = DC011_10_spim := by
  simp only [DC011_10_pim, DC011_10_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_10_smul :
    -(N_entry_0_4 * N_entry_1_0 * N_entry_2_5) =
      ofLadj DC011_10_spre DC011_10_spim := by
  rw [DC011_10_mul, ofLadj_neg, DC011_10_spre_eq, DC011_10_spim_eq]

def DC011_11_ab_pre : Polynomial ℚ := interpQ 2 [348, -192, 204, 612, -588, 496, 372, -1020, 1028, -212, -880, 968, -688, -416, 416, -768, -64, 60, -336]
def DC011_11_ab_pim : Polynomial ℚ := interpQ 2 [276, 552, -132, 800, 608, -204, 1572, 348, 352, 2344, 32, 720, 1408, -220, 840, 724, -16, 640, 312]
def DC011_11_pre : Polynomial ℚ := interpQ 2 [-13176, 36792, 2604, -29914, 126618, -36448, 15872, 256056, -124648, 202086, 336934, -175970, 422146, 240422, -101406, 548564, 87640, 58828, 472896, -3610, 137410, 246454, -15234, 124450, 96470, 3062, 53770, 23508]
def DC011_11_pim : Polynomial ℚ := interpQ 2 [-23772, -43032, 10164, -108410, -73250, 21828, -258856, -28804, -43564, -444598, 85354, -199074, -434918, 190922, -354106, -258756, 171716, -400252, -63380, 74366, -252878, 48098, -3174, -107542, 44350, -20326, -27850, 13524]
theorem DC011_11_ab_pre_eq :
    N_re_0_5 * N_re_1_1 - N_im_0_5 * N_im_1_1 =
      DC011_11_ab_pre := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_1, z_N_im_1_1, DC011_11_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_11_ab_pim_eq :
    N_re_0_5 * N_im_1_1 + N_im_0_5 * N_re_1_1 =
      DC011_11_ab_pim := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_1, z_N_im_1_1, DC011_11_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_11_ab_mul :
    N_entry_0_5 * N_entry_1_1 =
      ofLadj DC011_11_ab_pre DC011_11_ab_pim := by
  rw [N_entry_0_5, N_entry_1_1, ofLadj_mul,
    DC011_11_ab_pre_eq, DC011_11_ab_pim_eq]

theorem DC011_11_pre_eq :
    DC011_11_ab_pre * N_re_2_3 - DC011_11_ab_pim * N_im_2_3 =
      DC011_11_pre := by
  simp only [DC011_11_ab_pre, DC011_11_ab_pim, z_N_re_2_3, z_N_im_2_3, DC011_11_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_11_pim_eq :
    DC011_11_ab_pre * N_im_2_3 + DC011_11_ab_pim * N_re_2_3 =
      DC011_11_pim := by
  simp only [DC011_11_ab_pre, DC011_11_ab_pim, z_N_re_2_3, z_N_im_2_3, DC011_11_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_11_mul :
    N_entry_0_5 * N_entry_1_1 * N_entry_2_3 =
      ofLadj DC011_11_pre DC011_11_pim := by
  rw [DC011_11_ab_mul, N_entry_2_3, ofLadj_mul, DC011_11_pre_eq, DC011_11_pim_eq]

def DC011_11_spre : Polynomial ℚ := interpQ 2 [13176, -36792, -2604, 29914, -126618, 36448, -15872, -256056, 124648, -202086, -336934, 175970, -422146, -240422, 101406, -548564, -87640, -58828, -472896, 3610, -137410, -246454, 15234, -124450, -96470, -3062, -53770, -23508]
def DC011_11_spim : Polynomial ℚ := interpQ 2 [23772, 43032, -10164, 108410, 73250, -21828, 258856, 28804, 43564, 444598, -85354, 199074, 434918, -190922, 354106, 258756, -171716, 400252, 63380, -74366, 252878, -48098, 3174, 107542, -44350, 20326, 27850, -13524]
theorem DC011_11_spre_eq : -DC011_11_pre = DC011_11_spre := by
  simp only [DC011_11_pre, DC011_11_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_11_spim_eq : -DC011_11_pim = DC011_11_spim := by
  simp only [DC011_11_pim, DC011_11_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_11_smul :
    -(N_entry_0_5 * N_entry_1_1 * N_entry_2_3) =
      ofLadj DC011_11_spre DC011_11_spim := by
  rw [DC011_11_mul, ofLadj_neg, DC011_11_spre_eq, DC011_11_spim_eq]

def DC011_12_ab_pre : Polynomial ℚ := interpQ 2 [-684, 912, 260, -1008, 2336, -904, -632, 2988, -2744, 808, 2676, -2720, 1764, 548, -1736, 1532, -240, -512, 880]
def DC011_12_ab_pim : Polynomial ℚ := interpQ 2 [-912, -1824, -236, -3244, -2960, -1144, -6128, -3060, -2768, -8364, -1952, -3776, -5600, -776, -3364, -2716, -200, -1904, -640]
def DC011_12_pre : Polynomial ℚ := interpQ 2 [-4788, 20976, 9952, -1308, 78548, 7252, 36876, 153384, -20292, 135472, 203520, -33616, 243004, 155048, -9068, 283432, 64580, 43596, 230580, 6956, 68296, 113500, -9808, 53040, 38768, -2960, 21984, 8640]
def DC011_12_pim : Polynomial ℚ := interpQ 2 [-12084, -21432, 1376, -59492, -50164, -14636, -156708, -63712, -81172, -281840, -47744, -190048, -312724, -30784, -285708, -241336, -36388, -291284, -121212, -46644, -183704, -32636, -45136, -80000, 416, -21520, -18112, 4480]
theorem DC011_12_ab_pre_eq :
    N_re_0_3 * N_re_1_4 - N_im_0_3 * N_im_1_4 =
      DC011_12_ab_pre := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_4, z_N_im_1_4, DC011_12_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_12_ab_pim_eq :
    N_re_0_3 * N_im_1_4 + N_im_0_3 * N_re_1_4 =
      DC011_12_ab_pim := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_4, z_N_im_1_4, DC011_12_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_12_ab_mul :
    N_entry_0_3 * N_entry_1_4 =
      ofLadj DC011_12_ab_pre DC011_12_ab_pim := by
  rw [N_entry_0_3, N_entry_1_4, ofLadj_mul,
    DC011_12_ab_pre_eq, DC011_12_ab_pim_eq]

theorem DC011_12_pre_eq :
    DC011_12_ab_pre * N_re_2_2 - DC011_12_ab_pim * N_im_2_2 =
      DC011_12_pre := by
  simp only [DC011_12_ab_pre, DC011_12_ab_pim, z_N_re_2_2, z_N_im_2_2, DC011_12_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_12_pim_eq :
    DC011_12_ab_pre * N_im_2_2 + DC011_12_ab_pim * N_re_2_2 =
      DC011_12_pim := by
  simp only [DC011_12_ab_pre, DC011_12_ab_pim, z_N_re_2_2, z_N_im_2_2, DC011_12_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_12_mul :
    N_entry_0_3 * N_entry_1_4 * N_entry_2_2 =
      ofLadj DC011_12_pre DC011_12_pim := by
  rw [DC011_12_ab_mul, N_entry_2_2, ofLadj_mul, DC011_12_pre_eq, DC011_12_pim_eq]

def DC011_13_ab_pre : Polynomial ℚ := interpQ 2 [-396, 288, -84, -676, 776, -632, -488, 1136, -1348, 260, 1104, -1152, 816, 344, -672, 744, -64, -208, 384]
def DC011_13_ab_pim : Polynomial ℚ := interpQ 2 [-372, -744, 36, -1244, -1024, -96, -2232, -800, -652, -3124, -336, -1200, -2064, -56, -1248, -1032, -32, -784, -288]
def DC011_13_pre : Polynomial ℚ := interpQ 2 [744, 2976, 2904, 2470, 11116, 4924, 8864, 21770, 5582, 22906, 31854, 5332, 38050, 28062, 9700, 44390, 17954, 15166, 38120, 7172, 15372, 19768, 2256, 10596, 7312, 584, 4384, 1152]
def DC011_13_pim : Polynomial ℚ := interpQ 2 [-792, -1008, 984, -3806, -2568, 1276, -11852, -1802, -2258, -21914, 4450, -10096, -23990, 9502, -21020, -15798, 8710, -24294, -3288, 3828, -16444, 2872, -1424, -6948, 3248, -1368, -1168, 1536]
theorem DC011_13_ab_pre_eq :
    N_re_0_4 * N_re_1_5 - N_im_0_4 * N_im_1_5 =
      DC011_13_ab_pre := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_5, z_N_im_1_5, DC011_13_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_13_ab_pim_eq :
    N_re_0_4 * N_im_1_5 + N_im_0_4 * N_re_1_5 =
      DC011_13_ab_pim := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_5, z_N_im_1_5, DC011_13_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_13_ab_mul :
    N_entry_0_4 * N_entry_1_5 =
      ofLadj DC011_13_ab_pre DC011_13_ab_pim := by
  rw [N_entry_0_4, N_entry_1_5, ofLadj_mul,
    DC011_13_ab_pre_eq, DC011_13_ab_pim_eq]

theorem DC011_13_pre_eq :
    DC011_13_ab_pre * N_re_2_0 - DC011_13_ab_pim * N_im_2_0 =
      DC011_13_pre := by
  simp only [DC011_13_ab_pre, DC011_13_ab_pim, z_N_re_2_0, z_N_im_2_0, DC011_13_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_13_pim_eq :
    DC011_13_ab_pre * N_im_2_0 + DC011_13_ab_pim * N_re_2_0 =
      DC011_13_pim := by
  simp only [DC011_13_ab_pre, DC011_13_ab_pim, z_N_re_2_0, z_N_im_2_0, DC011_13_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_13_mul :
    N_entry_0_4 * N_entry_1_5 * N_entry_2_0 =
      ofLadj DC011_13_pre DC011_13_pim := by
  rw [DC011_13_ab_mul, N_entry_2_0, ofLadj_mul, DC011_13_pre_eq, DC011_13_pim_eq]

def DC011_14_ab_pre : Polynomial ℚ := interpQ 2 [-900, 576, -348, -1616, 1744, -1332, -988, 2804, -2872, 696, 2568, -2632, 1992, 1044, -1256, 2020, 64, -280, 960]
def DC011_14_ab_pim : Polynomial ℚ := interpQ 2 [-780, -1560, 300, -2428, -1892, 320, -4540, -1252, -1036, -6652, -216, -2184, -4152, 424, -2464, -2064, 72, -1780, -720]
def DC011_14_pre : Polynomial ℚ := interpQ 2 [-16980, 34392, -456, -37310, 124186, -44588, 4304, 248392, -145380, 180394, 317462, -201290, 399510, 216230, -128414, 519116, 58816, 29724, 442080, -24214, 119338, 226982, -27674, 110542, 83958, -3870, 47170, 19800]
def DC011_14_pim : Polynomial ℚ := interpQ 2 [-24960, -46176, 10776, -114486, -82090, 16376, -276016, -46916, -61376, -475658, 58826, -228834, -472042, 152138, -392770, -298484, 129380, -435876, -96156, 41706, -274726, 24490, -23574, -119834, 32734, -27810, -31090, 11400]
theorem DC011_14_ab_pre_eq :
    N_re_0_5 * N_re_1_3 - N_im_0_5 * N_im_1_3 =
      DC011_14_ab_pre := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_3, z_N_im_1_3, DC011_14_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_14_ab_pim_eq :
    N_re_0_5 * N_im_1_3 + N_im_0_5 * N_re_1_3 =
      DC011_14_ab_pim := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_3, z_N_im_1_3, DC011_14_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_14_ab_mul :
    N_entry_0_5 * N_entry_1_3 =
      ofLadj DC011_14_ab_pre DC011_14_ab_pim := by
  rw [N_entry_0_5, N_entry_1_3, ofLadj_mul,
    DC011_14_ab_pre_eq, DC011_14_ab_pim_eq]

theorem DC011_14_pre_eq :
    DC011_14_ab_pre * N_re_2_1 - DC011_14_ab_pim * N_im_2_1 =
      DC011_14_pre := by
  simp only [DC011_14_ab_pre, DC011_14_ab_pim, z_N_re_2_1, z_N_im_2_1, DC011_14_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_14_pim_eq :
    DC011_14_ab_pre * N_im_2_1 + DC011_14_ab_pim * N_re_2_1 =
      DC011_14_pim := by
  simp only [DC011_14_ab_pre, DC011_14_ab_pim, z_N_re_2_1, z_N_im_2_1, DC011_14_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_14_mul :
    N_entry_0_5 * N_entry_1_3 * N_entry_2_1 =
      ofLadj DC011_14_pre DC011_14_pim := by
  rw [DC011_14_ab_mul, N_entry_2_1, ofLadj_mul, DC011_14_pre_eq, DC011_14_pim_eq]

def DC011_15_ab_pre : Polynomial ℚ := interpQ 2 [-760, 912, 234, -1082, 2344, -962, -690, 2996, -2818, 782, 2676, -2720, 1764, 548, -1736, 1532, -240, -512, 880]
def DC011_15_ab_pim : Polynomial ℚ := interpQ 2 [-950, -1900, -230, -3312, -3012, -1144, -6204, -3084, -2776, -8446, -1952, -3776, -5600, -776, -3364, -2716, -200, -1904, -640]
def DC011_15_pre : Polynomial ℚ := interpQ 2 [-12445, 47044, 21953, -5886, 171664, 9526, 73292, 330705, -57276, 285428, 435495, -84712, 519885, 328213, -27460, 610913, 138975, 93009, 497952, 18150, 149002, 245840, -18960, 114406, 84264, -5780, 46080, 17800]
def DC011_15_pim : Polynomial ℚ := interpQ 2 [-28215, -50502, 4037, -130564, -105802, -20170, -330138, -113523, -141112, -575088, -47323, -347790, -605951, 15251, -536620, -440119, 2923, -553313, -196014, -43902, -347206, -33784, -69044, -152538, 12908, -37900, -34640, 10600]
theorem DC011_15_ab_pre_eq :
    N_re_0_3 * N_re_1_5 - N_im_0_3 * N_im_1_5 =
      DC011_15_ab_pre := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_5, z_N_im_1_5, DC011_15_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_15_ab_pim_eq :
    N_re_0_3 * N_im_1_5 + N_im_0_3 * N_re_1_5 =
      DC011_15_ab_pim := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_5, z_N_im_1_5, DC011_15_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_15_ab_mul :
    N_entry_0_3 * N_entry_1_5 =
      ofLadj DC011_15_ab_pre DC011_15_ab_pim := by
  rw [N_entry_0_3, N_entry_1_5, ofLadj_mul,
    DC011_15_ab_pre_eq, DC011_15_ab_pim_eq]

theorem DC011_15_pre_eq :
    DC011_15_ab_pre * N_re_2_1 - DC011_15_ab_pim * N_im_2_1 =
      DC011_15_pre := by
  simp only [DC011_15_ab_pre, DC011_15_ab_pim, z_N_re_2_1, z_N_im_2_1, DC011_15_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_15_pim_eq :
    DC011_15_ab_pre * N_im_2_1 + DC011_15_ab_pim * N_re_2_1 =
      DC011_15_pim := by
  simp only [DC011_15_ab_pre, DC011_15_ab_pim, z_N_re_2_1, z_N_im_2_1, DC011_15_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_15_mul :
    N_entry_0_3 * N_entry_1_5 * N_entry_2_1 =
      ofLadj DC011_15_pre DC011_15_pim := by
  rw [DC011_15_ab_mul, N_entry_2_1, ofLadj_mul, DC011_15_pre_eq, DC011_15_pim_eq]

def DC011_15_spre : Polynomial ℚ := interpQ 2 [12445, -47044, -21953, 5886, -171664, -9526, -73292, -330705, 57276, -285428, -435495, 84712, -519885, -328213, 27460, -610913, -138975, -93009, -497952, -18150, -149002, -245840, 18960, -114406, -84264, 5780, -46080, -17800]
def DC011_15_spim : Polynomial ℚ := interpQ 2 [28215, 50502, -4037, 130564, 105802, 20170, 330138, 113523, 141112, 575088, 47323, 347790, 605951, -15251, 536620, 440119, -2923, 553313, 196014, 43902, 347206, 33784, 69044, 152538, -12908, 37900, 34640, -10600]
theorem DC011_15_spre_eq : -DC011_15_pre = DC011_15_spre := by
  simp only [DC011_15_pre, DC011_15_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_15_spim_eq : -DC011_15_pim = DC011_15_spim := by
  simp only [DC011_15_pim, DC011_15_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_15_smul :
    -(N_entry_0_3 * N_entry_1_5 * N_entry_2_1) =
      ofLadj DC011_15_spre DC011_15_spim := by
  rw [DC011_15_mul, ofLadj_neg, DC011_15_spre_eq, DC011_15_spim_eq]

def DC011_16_ab_pre : Polynomial ℚ := interpQ 2 [-900, 576, -348, -1616, 1744, -1332, -988, 2804, -2872, 696, 2568, -2632, 1992, 1044, -1256, 2020, 64, -280, 960]
def DC011_16_ab_pim : Polynomial ℚ := interpQ 2 [-780, -1560, 300, -2428, -1892, 320, -4540, -1252, -1036, -6652, -216, -2184, -4152, 424, -2464, -2064, 72, -1780, -720]
def DC011_16_pre : Polynomial ℚ := interpQ 2 [-7560, 15696, -528, -17428, 56756, -21124, 656, 112884, -68636, 81792, 145500, -94120, 185056, 101188, -58448, 241980, 28372, 16192, 208572, -8680, 58800, 108752, -10632, 53500, 39932, -1440, 22720, 9600]
def DC011_16_pim : Polynomial ℚ := interpQ 2 [-11280, -20832, 4392, -54236, -40804, 2980, -133576, -30580, -39300, -232584, 11940, -123912, -239648, 48244, -205184, -161492, 37388, -224168, -63140, 2904, -142792, -728, -21096, -63308, 10164, -16760, -16560, 4800]
theorem DC011_16_ab_pre_eq :
    N_re_0_4 * N_re_1_3 - N_im_0_4 * N_im_1_3 =
      DC011_16_ab_pre := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_3, z_N_im_1_3, DC011_16_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_16_ab_pim_eq :
    N_re_0_4 * N_im_1_3 + N_im_0_4 * N_re_1_3 =
      DC011_16_ab_pim := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_3, z_N_im_1_3, DC011_16_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_16_ab_mul :
    N_entry_0_4 * N_entry_1_3 =
      ofLadj DC011_16_ab_pre DC011_16_ab_pim := by
  rw [N_entry_0_4, N_entry_1_3, ofLadj_mul,
    DC011_16_ab_pre_eq, DC011_16_ab_pim_eq]

theorem DC011_16_pre_eq :
    DC011_16_ab_pre * N_re_2_2 - DC011_16_ab_pim * N_im_2_2 =
      DC011_16_pre := by
  simp only [DC011_16_ab_pre, DC011_16_ab_pim, z_N_re_2_2, z_N_im_2_2, DC011_16_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_16_pim_eq :
    DC011_16_ab_pre * N_im_2_2 + DC011_16_ab_pim * N_re_2_2 =
      DC011_16_pim := by
  simp only [DC011_16_ab_pre, DC011_16_ab_pim, z_N_re_2_2, z_N_im_2_2, DC011_16_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_16_mul :
    N_entry_0_4 * N_entry_1_3 * N_entry_2_2 =
      ofLadj DC011_16_pre DC011_16_pim := by
  rw [DC011_16_ab_mul, N_entry_2_2, ofLadj_mul, DC011_16_pre_eq, DC011_16_pim_eq]

def DC011_16_spre : Polynomial ℚ := interpQ 2 [7560, -15696, 528, 17428, -56756, 21124, -656, -112884, 68636, -81792, -145500, 94120, -185056, -101188, 58448, -241980, -28372, -16192, -208572, 8680, -58800, -108752, 10632, -53500, -39932, 1440, -22720, -9600]
def DC011_16_spim : Polynomial ℚ := interpQ 2 [11280, 20832, -4392, 54236, 40804, -2980, 133576, 30580, 39300, 232584, -11940, 123912, 239648, -48244, 205184, 161492, -37388, 224168, 63140, -2904, 142792, 728, 21096, 63308, -10164, 16760, 16560, -4800]
theorem DC011_16_spre_eq : -DC011_16_pre = DC011_16_spre := by
  simp only [DC011_16_pre, DC011_16_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_16_spim_eq : -DC011_16_pim = DC011_16_spim := by
  simp only [DC011_16_pim, DC011_16_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_16_smul :
    -(N_entry_0_4 * N_entry_1_3 * N_entry_2_2) =
      ofLadj DC011_16_spre DC011_16_spim := by
  rw [DC011_16_mul, ofLadj_neg, DC011_16_spre_eq, DC011_16_spim_eq]

def DC011_17_ab_pre : Polynomial ℚ := interpQ 2 [-360, 288, -72, -648, 768, -616, -472, 1128, -1320, 272, 1104, -1152, 816, 344, -672, 744, -64, -208, 384]
def DC011_17_ab_pim : Polynomial ℚ := interpQ 2 [-360, -720, 24, -1224, -1008, -104, -2200, -792, -648, -3088, -336, -1200, -2064, -56, -1248, -1032, -32, -784, -288]
def DC011_17_pre : Polynomial ℚ := interpQ 2 [720, 2880, 2832, 2532, 10872, 4960, 8872, 21436, 5696, 22680, 31468, 5488, 37760, 27908, 9752, 44156, 17904, 15144, 37976, 7172, 15372, 19768, 2256, 10596, 7312, 584, 4384, 1152]
def DC011_17_pim : Polynomial ℚ := interpQ 2 [-720, -864, 1008, -3564, -2352, 1360, -11424, -1588, -2096, -21240, 4548, -9808, -23512, 9524, -20704, -15556, 8704, -24080, -3240, 3828, -16444, 2872, -1424, -6948, 3248, -1368, -1168, 1536]
theorem DC011_17_ab_pre_eq :
    N_re_0_5 * N_re_1_4 - N_im_0_5 * N_im_1_4 =
      DC011_17_ab_pre := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_4, z_N_im_1_4, DC011_17_ab_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_17_ab_pim_eq :
    N_re_0_5 * N_im_1_4 + N_im_0_5 * N_re_1_4 =
      DC011_17_ab_pim := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_1_4, z_N_im_1_4, DC011_17_ab_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_17_ab_mul :
    N_entry_0_5 * N_entry_1_4 =
      ofLadj DC011_17_ab_pre DC011_17_ab_pim := by
  rw [N_entry_0_5, N_entry_1_4, ofLadj_mul,
    DC011_17_ab_pre_eq, DC011_17_ab_pim_eq]

theorem DC011_17_pre_eq :
    DC011_17_ab_pre * N_re_2_0 - DC011_17_ab_pim * N_im_2_0 =
      DC011_17_pre := by
  simp only [DC011_17_ab_pre, DC011_17_ab_pim, z_N_re_2_0, z_N_im_2_0, DC011_17_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_17_pim_eq :
    DC011_17_ab_pre * N_im_2_0 + DC011_17_ab_pim * N_re_2_0 =
      DC011_17_pim := by
  simp only [DC011_17_ab_pre, DC011_17_ab_pim, z_N_re_2_0, z_N_im_2_0, DC011_17_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC011_17_mul :
    N_entry_0_5 * N_entry_1_4 * N_entry_2_0 =
      ofLadj DC011_17_pre DC011_17_pim := by
  rw [DC011_17_ab_mul, N_entry_2_0, ofLadj_mul, DC011_17_pre_eq, DC011_17_pim_eq]

def DC011_17_spre : Polynomial ℚ := interpQ 2 [-720, -2880, -2832, -2532, -10872, -4960, -8872, -21436, -5696, -22680, -31468, -5488, -37760, -27908, -9752, -44156, -17904, -15144, -37976, -7172, -15372, -19768, -2256, -10596, -7312, -584, -4384, -1152]
def DC011_17_spim : Polynomial ℚ := interpQ 2 [720, 864, -1008, 3564, 2352, -1360, 11424, 1588, 2096, 21240, -4548, 9808, 23512, -9524, 20704, 15556, -8704, 24080, 3240, -3828, 16444, -2872, 1424, 6948, -3248, 1368, 1168, -1536]
theorem DC011_17_spre_eq : -DC011_17_pre = DC011_17_spre := by
  simp only [DC011_17_pre, DC011_17_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_17_spim_eq : -DC011_17_pim = DC011_17_spim := by
  simp only [DC011_17_pim, DC011_17_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
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
def DC011_g0_qre : Polynomial ℚ := interpQ 2 [2106, -362, 1448, 563, 4704, 1106, 2011, 6656, -3332, 718, 1072, -7880, -1926, -4022, -5844, -1212, -2048, -1896]
def DC011_g0_qim : Polynomial ℚ := interpQ 2 [-406, -526, -334, -1961, -2110, -632, -7627, -4600, -5282, -13650, -3080, -6016, -7702, -230, -2332, -1692, 1012, -808]
def DC011_g0_rre : Polynomial ℚ := interpQ 2 [-3137, 0, -969, -2845, 581, -2034, -2034, 581, -2845, -969]
def DC011_g0_rim : Polynomial ℚ := interpQ 2 [-1439, -2878, 443, -2471, -1975, 286, -3164, -903, -407, -3321]
def DC011_g0a_qre : Polynomial ℚ := interpQ 2 [1197792, -1120232, 348618, 681413, -1048110, 782436, 103563, -610062, 771312, -206230, -129768, 424792, -210834, 62998, 151246, -84606, 60032, 26168]
def DC011_g0a_rre : Polynomial ℚ := interpQ 2 [-1204329, 0, -372945, -1088125, 222269, -777976, -777976, 222269, -1088125, -372945]
theorem DC011_g0a_re :
    DC011_0_pre + DC011_1_pre + DC011_2_pre =
      DC011_g0a_rre + Phi11 * DC011_g0a_qre := by
  rw [phi11_interpQ]
  simp only [DC011_0_pre, DC011_1_pre, DC011_2_pre, DC011_g0a_rre, DC011_g0a_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC011_g0b_qre : Polynomial ℚ := interpQ 2 [-1195686, 1119870, -347170, -680850, 1052814, -781330, -101552, 616718, -774644, 206948, 130840, -432672, 208908, -67020, -157090, 83394, -62080, -28064]
def DC011_g0b_rre : Polynomial ℚ := interpQ 2 [1201192, 0, 371976, 1085280, -221688, 775942, 775942, -221688, 1085280, 371976]
theorem DC011_g0b_re :
    DC011_3_spre + DC011_4_spre + DC011_5_spre =
      DC011_g0b_rre + Phi11 * DC011_g0b_qre := by
  rw [phi11_interpQ]
  simp only [DC011_3_spre, DC011_4_spre, DC011_5_spre, DC011_g0b_rre, DC011_g0b_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_g0_rre_split :
    DC011_g0a_rre + DC011_g0b_rre = DC011_g0_rre := by
  simp only [DC011_g0a_rre, DC011_g0b_rre, DC011_g0_rre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_g0_qre_split :
    DC011_g0a_qre + DC011_g0b_qre = DC011_g0_qre := by
  simp only [DC011_g0a_qre, DC011_g0b_qre, DC011_g0_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC011_g0a_qim : Polynomial ℚ := interpQ 2 [513448, 525928, -1190000, 939501, -144164, -731118, 897453, -541338, -202434, 500710, -481368, 90900, 142334, -248614, 102178, -790, -61856, 27304]
def DC011_g0a_rim : Polynomial ℚ := interpQ 2 [-549639, -1099278, 170963, -942431, -754375, 112420, -1211698, -344903, -156847, -1270241]
theorem DC011_g0a_im :
    DC011_0_pim + DC011_1_pim + DC011_2_pim =
      DC011_g0a_rim + Phi11 * DC011_g0a_qim := by
  rw [phi11_interpQ]
  simp only [DC011_0_pim, DC011_1_pim, DC011_2_pim, DC011_g0a_rim, DC011_g0a_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC011_g0b_qim : Polynomial ℚ := interpQ 2 [-513854, -526454, 1189666, -941462, 142054, 730486, -905080, 536738, 197152, -514360, 478288, -96916, -150036, 248384, -104510, -902, 62868, -28112]
def DC011_g0b_rim : Polynomial ℚ := interpQ 2 [548200, 1096400, -170520, 939960, 752400, -112134, 1208534, 344000, 156440, 1266920]
theorem DC011_g0b_im :
    DC011_3_spim + DC011_4_spim + DC011_5_spim =
      DC011_g0b_rim + Phi11 * DC011_g0b_qim := by
  rw [phi11_interpQ]
  simp only [DC011_3_spim, DC011_4_spim, DC011_5_spim, DC011_g0b_rim, DC011_g0b_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_g0_rim_split :
    DC011_g0a_rim + DC011_g0b_rim = DC011_g0_rim := by
  simp only [DC011_g0a_rim, DC011_g0b_rim, DC011_g0_rim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_g0_qim_split :
    DC011_g0a_qim + DC011_g0b_qim = DC011_g0_qim := by
  simp only [DC011_g0a_qim, DC011_g0b_qim, DC011_g0_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
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
def DC011_g1_qre : Polynomial ℚ := interpQ 2 [8164, -3092, 4512, 5632, -6216, 2024, 574, -9242, 5982, 1882, 1284, 10590, 3020, 4912, 6026, 212, 2088, 640]
def DC011_g1_qim : Polynomial ℚ := interpQ 2 [1356, 2052, -9736, 852, -4512, -12032, 4190, -4650, -446, 9030, -2188, 994, 2540, -5620, -2178, -1336, -1896, 188]
def DC011_g1_rre : Polynomial ℚ := interpQ 2 [-4724, 0, -1462, -4274, 880, -3056, -3056, 880, -4274, -1462]
def DC011_g1_rim : Polynomial ℚ := interpQ 2 [-2164, -4328, 670, -3706, -2968, 432, -4760, -1360, -622, -4998]
def DC011_g1a_qre : Polynomial ℚ := interpQ 2 [1186982, -1111662, 332296, 679520, -1047346, 759956, 103600, -620220, 747260, -187900, -147776, 424012, -195660, 54652, 156046, -76946, 50776, 36848]
def DC011_g1a_rre : Polynomial ℚ := interpQ 2 [-1197506, 0, -370832, -1081894, 221112, -773476, -773476, 221112, -1081894, -370832]
theorem DC011_g1a_re :
    DC011_6_pre + DC011_7_pre + DC011_8_pre =
      DC011_g1a_rre + Phi11 * DC011_g1a_qre := by
  rw [phi11_interpQ]
  simp only [DC011_6_pre, DC011_7_pre, DC011_8_pre, DC011_g1a_rre, DC011_g1a_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC011_g1b_qre : Polynomial ℚ := interpQ 2 [-1178818, 1108570, -327784, -673888, 1041130, -757932, -103026, 610978, -741278, 189782, 149060, -413422, 198680, -49740, -150020, 77158, -48688, -36208]
def DC011_g1b_rre : Polynomial ℚ := interpQ 2 [1192782, 0, 369370, 1077620, -220232, 770420, 770420, -220232, 1077620, 369370]
theorem DC011_g1b_re :
    DC011_9_spre + DC011_10_spre + DC011_11_spre =
      DC011_g1b_rre + Phi11 * DC011_g1b_qre := by
  rw [phi11_interpQ]
  simp only [DC011_9_spre, DC011_10_spre, DC011_11_spre, DC011_g1b_rre, DC011_g1b_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_g1_rre_split :
    DC011_g1a_rre + DC011_g1b_rre = DC011_g1_rre := by
  simp only [DC011_g1a_rre, DC011_g1b_rre, DC011_g1_rre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_g1_qre_split :
    DC011_g1a_qre + DC011_g1b_qre = DC011_g1_qre := by
  simp only [DC011_g1a_qre, DC011_g1b_qre, DC011_g1_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC011_g1a_qim : Polynomial ℚ := interpQ 2 [508198, 519454, -1188028, 918052, -139782, -736912, 879576, -524784, -224224, 495096, -468816, 64432, 150436, -249080, 86594, 4310, -70748, 20552]
def DC011_g1a_rim : Polynomial ℚ := interpQ 2 [-546510, -1093020, 170068, -936994, -750056, 111808, -1204828, -342964, -156026, -1263088]
theorem DC011_g1a_im :
    DC011_6_pim + DC011_7_pim + DC011_8_pim =
      DC011_g1a_rim + Phi11 * DC011_g1a_qim := by
  rw [phi11_interpQ]
  simp only [DC011_6_pim, DC011_7_pim, DC011_8_pim, DC011_g1a_rim, DC011_g1a_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC011_g1b_qim : Polynomial ℚ := interpQ 2 [-506842, -517402, 1178292, -917200, 135270, 724880, -875386, 520134, 223778, -486066, 466628, -63438, -147896, 243460, -88772, -5646, 68852, -20364]
def DC011_g1b_rim : Polynomial ℚ := interpQ 2 [544346, 1088692, -169398, 933288, 747088, -111376, 1200068, 341604, 155404, 1258090]
theorem DC011_g1b_im :
    DC011_9_spim + DC011_10_spim + DC011_11_spim =
      DC011_g1b_rim + Phi11 * DC011_g1b_qim := by
  rw [phi11_interpQ]
  simp only [DC011_9_spim, DC011_10_spim, DC011_11_spim, DC011_g1b_rim, DC011_g1b_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_g1_rim_split :
    DC011_g1a_rim + DC011_g1b_rim = DC011_g1_rim := by
  simp only [DC011_g1a_rim, DC011_g1b_rim, DC011_g1_rim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_g1_qim_split :
    DC011_g1a_qim + DC011_g1b_qim = DC011_g1_qim := by
  simp only [DC011_g1a_qim, DC011_g1b_qim, DC011_g1_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
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
def DC011_g2_qre : Polynomial ℚ := interpQ 2 [-9617, 2341, -7022, -8203, -1479, -6896, -7002, -2139, -6992, -6560, -6058, -6220, -3566, -2854, -1860, 36, -686, 1040]
def DC011_g2_qim : Polynomial ℚ := interpQ 2 [-1229, -2405, 8452, -425, 4793, 10380, 3060, 8369, 5678, 4492, 5202, 4936, 5418, 5934, 4748, 3332, 1518, 480]
def DC011_g2_rre : Polynomial ℚ := interpQ 2 [7878, 0, 2441, 7135, -1462, 5102, 5102, -1462, 7135, 2441]
def DC011_g2_rim : Polynomial ℚ := interpQ 2 [3608, 7216, -1119, 6187, 4950, -720, 7936, 2266, 1029, 8335]
def DC011_g2a_qre : Polynomial ℚ := interpQ 2 [1177886, -1119542, 325364, 663406, -1054504, 749534, 82456, -622294, 720866, -213092, -157244, 395476, -209404, 44140, 136284, -79784, 43946, 29592]
def DC011_g2a_rre : Polynomial ℚ := interpQ 2 [-1198910, 0, -371308, -1083262, 221240, -774556, -774556, 221240, -1083262, -371308]
theorem DC011_g2a_re :
    DC011_12_pre + DC011_13_pre + DC011_14_pre =
      DC011_g2a_rre + Phi11 * DC011_g2a_qre := by
  rw [phi11_interpQ]
  simp only [DC011_12_pre, DC011_13_pre, DC011_14_pre, DC011_g2a_rre, DC011_g2a_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC011_g2b_qre : Polynomial ℚ := interpQ 2 [-1187503, 1121883, -332386, -671609, 1053025, -756430, -89458, 620155, -727858, 206532, 151186, -401696, 205838, -46994, -138144, 79820, -44632, -28552]
def DC011_g2b_rre : Polynomial ℚ := interpQ 2 [1206788, 0, 373749, 1090397, -222702, 779658, 779658, -222702, 1090397, 373749]
theorem DC011_g2b_re :
    DC011_15_spre + DC011_16_spre + DC011_17_spre =
      DC011_g2b_rre + Phi11 * DC011_g2b_qre := by
  rw [phi11_interpQ]
  simp only [DC011_15_spre, DC011_16_spre, DC011_17_spre, DC011_g2b_rre, DC011_g2b_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_g2_rre_split :
    DC011_g2a_rre + DC011_g2b_rre = DC011_g2_rre := by
  simp only [DC011_g2a_rre, DC011_g2b_rre, DC011_g2_rre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_g2_qre_split :
    DC011_g2a_qre + DC011_g2b_qre = DC011_g2_qre := by
  simp only [DC011_g2a_qre, DC011_g2b_qre, DC011_g2_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC011_g2a_qim : Polynomial ℚ := interpQ 2 [509370, 516426, -1182792, 917450, -144208, -725106, 870572, -530798, -219546, 473764, -469600, 64860, 136648, -243180, 87096, -328, -67786, 17416]
def DC011_g2a_rim : Polynomial ℚ := interpQ 2 [-547206, -1094412, 170132, -938238, -751068, 111876, -1206288, -343344, -156174, -1264544]
theorem DC011_g2a_im :
    DC011_12_pim + DC011_13_pim + DC011_14_pim =
      DC011_g2a_rim + Phi11 * DC011_g2a_qim := by
  rw [phi11_interpQ]
  simp only [DC011_12_pim, DC011_13_pim, DC011_14_pim, DC011_g2a_rim, DC011_g2a_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
def DC011_g2b_qim : Polynomial ℚ := interpQ 2 [-510599, -518831, 1191244, -917875, 149001, 735486, -867512, 539167, 225224, -469272, 474802, -59924, -131230, 249114, -82348, 3660, 69304, -16936]
def DC011_g2b_rim : Polynomial ℚ := interpQ 2 [550814, 1101628, -171251, 944425, 756018, -112596, 1214224, 345610, 157203, 1272879]
theorem DC011_g2b_im :
    DC011_15_spim + DC011_16_spim + DC011_17_spim =
      DC011_g2b_rim + Phi11 * DC011_g2b_qim := by
  rw [phi11_interpQ]
  simp only [DC011_15_spim, DC011_16_spim, DC011_17_spim, DC011_g2b_rim, DC011_g2b_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_g2_rim_split :
    DC011_g2a_rim + DC011_g2b_rim = DC011_g2_rim := by
  simp only [DC011_g2a_rim, DC011_g2b_rim, DC011_g2_rim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_g2_qim_split :
    DC011_g2a_qim + DC011_g2b_qim = DC011_g2_qim := by
  simp only [DC011_g2a_qim, DC011_g2b_qim, DC011_g2_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
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
def DC011_g3_qre : Polynomial ℚ := interpQ 1 []
def DC011_g3_qim : Polynomial ℚ := interpQ 1 []
theorem DC011_rem_re :
    DC011_g0_rre + DC011_g1_rre + DC011_g2_rre =
      Fplus_re_011 + Phi11 * DC011_g3_qre := by
  rw [phi11_interpQ]
  simp only [DC011_g0_rre, DC011_g1_rre, DC011_g2_rre, z_Fplus_re_011, DC011_g3_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC011_rem_im :
    DC011_g0_rim + DC011_g1_rim + DC011_g2_rim =
      Fplus_im_011 + Phi11 * DC011_g3_qim := by
  rw [phi11_interpQ]
  simp only [DC011_g0_rim, DC011_g1_rim, DC011_g2_rim, z_Fplus_im_011, DC011_g3_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

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
