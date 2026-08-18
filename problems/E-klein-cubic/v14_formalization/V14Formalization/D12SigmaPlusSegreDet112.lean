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

def DC112_0_pre : Polynomial ℚ := interpQ 1 [-342, 456, 130, -504, 1168, -452, -316, 1494, -1372, 404, 1338, -1360, 882, 274, -868, 766, -120, -256, 440]
def DC112_0_pim : Polynomial ℚ := interpQ 1 [-456, -912, -118, -1622, -1480, -572, -3064, -1530, -1384, -4182, -976, -1888, -2800, -388, -1682, -1358, -100, -952, -320]
theorem DC112_0_pre_eq :
    N_re_0_3 * N_re_1_4 - N_im_0_3 * N_im_1_4 =
      DC112_0_pre := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_4, z_N_im_1_4, DC112_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC112_0_pim_eq :
    N_re_0_3 * N_im_1_4 + N_im_0_3 * N_re_1_4 =
      DC112_0_pim := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_1_4, z_N_im_1_4, DC112_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC112_0_mul :
    N_entry_0_3 * N_entry_1_4 =
      ofLadj DC112_0_pre DC112_0_pim := by
  rw [N_entry_0_3, N_entry_1_4, ofLadj_mul,
    DC112_0_pre_eq, DC112_0_pim_eq]

def DC112_1_pre : Polynomial ℚ := interpQ 1 [-450, 288, -174, -808, 872, -666, -494, 1402, -1436, 348, 1284, -1316, 996, 522, -628, 1010, 32, -140, 480]
def DC112_1_pim : Polynomial ℚ := interpQ 1 [-390, -780, 150, -1214, -946, 160, -2270, -626, -518, -3326, -108, -1092, -2076, 212, -1232, -1032, 36, -890, -360]
theorem DC112_1_pre_eq :
    N_re_0_4 * N_re_1_3 - N_im_0_4 * N_im_1_3 =
      DC112_1_pre := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_3, z_N_im_1_3, DC112_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC112_1_pim_eq :
    N_re_0_4 * N_im_1_3 + N_im_0_4 * N_re_1_3 =
      DC112_1_pim := by
  simp only [z_N_re_0_4, z_N_im_0_4, z_N_re_1_3, z_N_im_1_3, DC112_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC112_1_mul :
    N_entry_0_4 * N_entry_1_3 =
      ofLadj DC112_1_pre DC112_1_pim := by
  rw [N_entry_0_4, N_entry_1_3, ofLadj_mul,
    DC112_1_pre_eq, DC112_1_pim_eq]

def DC112_1_spre : Polynomial ℚ := interpQ 1 [450, -288, 174, 808, -872, 666, 494, -1402, 1436, -348, -1284, 1316, -996, -522, 628, -1010, -32, 140, -480]
def DC112_1_spim : Polynomial ℚ := interpQ 1 [390, 780, -150, 1214, 946, -160, 2270, 626, 518, 3326, 108, 1092, 2076, -212, 1232, 1032, -36, 890, 360]
theorem DC112_1_spre_eq : -DC112_1_pre = DC112_1_spre := by
  simp only [DC112_1_pre, DC112_1_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC112_1_spim_eq : -DC112_1_pim = DC112_1_spim := by
  simp only [DC112_1_pim, DC112_1_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC112_1_smul :
    -(N_entry_0_4 * N_entry_1_3) =
      ofLadj DC112_1_spre DC112_1_spim := by
  rw [DC112_1_mul, ofLadj_neg, DC112_1_spre_eq, DC112_1_spim_eq]

def DC112_2_pre : Polynomial ℚ := interpQ 1 [-608, 912, 248, -1010, 2334, -800, -560, 3194, -2452, 1140, 3016, -2456, 2104, 892, -1442, 1822, -74, -314, 962]
def DC112_2_pim : Polynomial ℚ := interpQ 1 [-874, -1748, -166, -2986, -2730, -834, -5742, -2660, -2382, -7990, -1588, -3472, -5356, -536, -3324, -2636, -168, -1948, -666]
theorem DC112_2_pre_eq :
    N_re_0_3 * N_re_2_5 - N_im_0_3 * N_im_2_5 =
      DC112_2_pre := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_2_5, z_N_im_2_5, DC112_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC112_2_pim_eq :
    N_re_0_3 * N_im_2_5 + N_im_0_3 * N_re_2_5 =
      DC112_2_pim := by
  simp only [z_N_re_0_3, z_N_im_0_3, z_N_re_2_5, z_N_im_2_5, DC112_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC112_2_mul :
    N_entry_0_3 * N_entry_2_5 =
      ofLadj DC112_2_pre DC112_2_pim := by
  rw [N_entry_0_3, N_entry_2_5, ofLadj_mul,
    DC112_2_pre_eq, DC112_2_pim_eq]

def DC112_3_pre : Polynomial ℚ := interpQ 1 [-876, 564, -288, -1600, 1676, -1344, -1092, 2688, -2968, 608, 2476, -2692, 1912, 896, -1368, 1924, -60, -312, 912]
def DC112_3_pim : Polynomial ℚ := interpQ 1 [-762, -1524, 264, -2412, -1970, 280, -4574, -1332, -1048, -6624, -260, -2244, -4228, 348, -2552, -2056, 38, -1756, -654]
theorem DC112_3_pre_eq :
    N_re_0_5 * N_re_2_3 - N_im_0_5 * N_im_2_3 =
      DC112_3_pre := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_2_3, z_N_im_2_3, DC112_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC112_3_pim_eq :
    N_re_0_5 * N_im_2_3 + N_im_0_5 * N_re_2_3 =
      DC112_3_pim := by
  simp only [z_N_re_0_5, z_N_im_0_5, z_N_re_2_3, z_N_im_2_3, DC112_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC112_3_mul :
    N_entry_0_5 * N_entry_2_3 =
      ofLadj DC112_3_pre DC112_3_pim := by
  rw [N_entry_0_5, N_entry_2_3, ofLadj_mul,
    DC112_3_pre_eq, DC112_3_pim_eq]

def DC112_3_spre : Polynomial ℚ := interpQ 1 [876, -564, 288, 1600, -1676, 1344, 1092, -2688, 2968, -608, -2476, 2692, -1912, -896, 1368, -1924, 60, 312, -912]
def DC112_3_spim : Polynomial ℚ := interpQ 1 [762, 1524, -264, 2412, 1970, -280, 4574, 1332, 1048, 6624, 260, 2244, 4228, -348, 2552, 2056, -38, 1756, 654]
theorem DC112_3_spre_eq : -DC112_3_pre = DC112_3_spre := by
  simp only [DC112_3_pre, DC112_3_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC112_3_spim_eq : -DC112_3_pim = DC112_3_spim := by
  simp only [DC112_3_pim, DC112_3_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC112_3_smul :
    -(N_entry_0_5 * N_entry_2_3) =
      ofLadj DC112_3_spre DC112_3_spim := by
  rw [DC112_3_mul, ofLadj_neg, DC112_3_spre_eq, DC112_3_spim_eq]

def DC112_4_pre : Polynomial ℚ := interpQ 1 [192, -288, -92, 288, -736, 260, 172, -968, 796, -304, -884, 800, -596, -212, 508, -512, 48, 136, -280]
def DC112_4_pim : Polynomial ℚ := interpQ 1 [276, 552, 72, 972, 888, 332, 1868, 916, 832, 2560, 576, 1152, 1728, 224, 1052, 852, 64, 592, 200]
theorem DC112_4_pre_eq :
    N_re_1_4 * N_re_2_5 - N_im_1_4 * N_im_2_5 =
      DC112_4_pre := by
  simp only [z_N_re_1_4, z_N_im_1_4, z_N_re_2_5, z_N_im_2_5, DC112_4_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC112_4_pim_eq :
    N_re_1_4 * N_im_2_5 + N_im_1_4 * N_re_2_5 =
      DC112_4_pim := by
  simp only [z_N_re_1_4, z_N_im_1_4, z_N_re_2_5, z_N_im_2_5, DC112_4_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC112_4_mul :
    N_entry_1_4 * N_entry_2_5 =
      ofLadj DC112_4_pre DC112_4_pim := by
  rw [N_entry_1_4, N_entry_2_5, ofLadj_mul,
    DC112_4_pre_eq, DC112_4_pim_eq]

def DC112_5_pre : Polynomial ℚ := interpQ 1 [214, -288, -97, 297, -757, 236, 148, -1015, 753, -357, -942, 728, -654, -260, 456, -542, 32, 120, -284]
def DC112_5_pim : Polynomial ℚ := interpQ 1 [288, 576, 64, 974, 886, 296, 1836, 874, 774, 2512, 520, 1092, 1664, 184, 1012, 812, 48, 580, 188]
theorem DC112_5_pre_eq :
    N_re_1_5 * N_re_2_4 - N_im_1_5 * N_im_2_4 =
      DC112_5_pre := by
  simp only [z_N_re_1_5, z_N_im_1_5, z_N_re_2_4, z_N_im_2_4, DC112_5_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC112_5_pim_eq :
    N_re_1_5 * N_im_2_4 + N_im_1_5 * N_re_2_4 =
      DC112_5_pim := by
  simp only [z_N_re_1_5, z_N_im_1_5, z_N_re_2_4, z_N_im_2_4, DC112_5_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem DC112_5_mul :
    N_entry_1_5 * N_entry_2_4 =
      ofLadj DC112_5_pre DC112_5_pim := by
  rw [N_entry_1_5, N_entry_2_4, ofLadj_mul,
    DC112_5_pre_eq, DC112_5_pim_eq]

def DC112_5_spre : Polynomial ℚ := interpQ 1 [-214, 288, 97, -297, 757, -236, -148, 1015, -753, 357, 942, -728, 654, 260, -456, 542, -32, -120, 284]
def DC112_5_spim : Polynomial ℚ := interpQ 1 [-288, -576, -64, -974, -886, -296, -1836, -874, -774, -2512, -520, -1092, -1664, -184, -1012, -812, -48, -580, -188]
theorem DC112_5_spre_eq : -DC112_5_pre = DC112_5_spre := by
  simp only [DC112_5_pre, DC112_5_spre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem DC112_5_spim_eq : -DC112_5_pim = DC112_5_spim := by
  simp only [DC112_5_pim, DC112_5_spim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
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

def DC112_qre : Polynomial ℚ := interpQ 1 [388, 128, 340, 58, 54, -166, -48, -116, 14]
def DC112_qim : Polynomial ℚ := interpQ 1 [-176, -176, -344, -262, -316, -540, -84, -282, 40]

theorem detCoeff_112_sum_poly_re :
    DC112_0_pre + DC112_1_spre + DC112_2_pre + DC112_3_spre + DC112_4_pre + DC112_5_spre = Fplus_re_112 + Phi11 * DC112_qre := by
  rw [phi11_interpQ]
  simp only [DC112_0_pre, DC112_1_spre, DC112_2_pre, DC112_3_spre, DC112_4_pre, DC112_5_spre, z_Fplus_re_112, DC112_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

theorem detCoeff_112_sum_poly_im :
    DC112_0_pim + DC112_1_spim + DC112_2_pim + DC112_3_spim + DC112_4_pim + DC112_5_spim = Fplus_im_112 + Phi11 * DC112_qim := by
  rw [phi11_interpQ]
  simp only [DC112_0_pim, DC112_1_spim, DC112_2_pim, DC112_3_spim, DC112_4_pim, DC112_5_spim, z_Fplus_im_112, DC112_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide

public theorem detCoeff_112_eq :
    detCoeff_112 = ofLadj Fplus_re_112 Fplus_im_112 := by
  rw [detCoeff_112_sum, detCoeff_112_sum_poly_re,
    detCoeff_112_sum_poly_im, ofLadj_add_Phi11]

end V14Formalization.D12SigmaPlusSegreCore
