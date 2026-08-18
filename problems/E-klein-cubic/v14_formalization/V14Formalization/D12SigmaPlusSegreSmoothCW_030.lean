/-
Auto-generated Fplus chart Nullstellensatz identities.
-/
module

public import V14Formalization.D12SigmaPlusSegreEval
public import V14Formalization.D12SigmaPlusSegreMul
public import V14Formalization.D12SigmaPlusSegrePartials
public import V14Formalization.D12SigmaPlusSegreBezoutData
public import V14Formalization.D12PolyZReflection
public import V14Formalization.D12SigmaPlusSegreFplusZ

noncomputable section
open Matrix Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open D12PolynomialData
open V14Formalization.D12PolyZReflection

def CW_030_0_pre : Polynomial ℚ := interpQ 8639957931 [-473382199786, 11159748055040, 20038843588845, 35506066195009, 58276419726292, 74266566311604, 91819940372176, 104409950888066, 106312088869021, 109753109779603, 113061320905437, 114095666001636, 101901572850397, 89714266190758, 70806022674012, 44351173420234, 26554046607048, 9000672546476, -1782357741540]
def CW_030_0_pim : Polynomial ℚ := interpQ 8639957931 [-10445585615474, -20891171230948, -27532193521205, -39840484090395, -40459340262635, -37151467730383, -32597826637019, -19774265881387, -11009466974424, -10824056520322, -8141338200946, 5887927370282, 19917192941510, 29240933551143, 41734634574435, 41148806484192, 34211741399040, 26422236477978, 9969483169446]
theorem CW_030_0_pre_eq :
    CW_0_re_010 * Fplus_dU_re_020 - CW_0_im_010 * Fplus_dU_im_020 = CW_030_0_pre := by
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CW_030_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_030_0_pim_eq :
    CW_0_re_010 * Fplus_dU_im_020 + CW_0_im_010 * Fplus_dU_re_020 = CW_030_0_pim := by
  simp only [CW_0_re_010_def, CW_0_im_010_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CW_030_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_030_0_mul :
    CW_0_c_010 * Fplus_dU_c_020 = ofLadj CW_030_0_pre CW_030_0_pim := by
  rw [CW_0_c_010_def, Fplus_dU_c_020_def, ofLadj_mul, CW_030_0_pre_eq, CW_030_0_pim_eq]

def CW_030_1_pre : Polynomial ℚ := interpQ 8639957931 [-566792036079, -7447676277660, -12753445608960, -20455575318105, -31497990113943, -35567756508645, -40750673889474, -46851347013417, -48007276139169, -51529640039931, -54574931182257, -55309028376120, -47127254904597, -38776194430971, -27551700821064, -13134956976936, -6755944946547, -1573027565718, 2218399922538]
def CW_030_1_pim : Polynomial ℚ := interpQ 8639957931 [4371401655498, 8742803310996, 9662115520998, 13082781246819, 9906071571252, 4453260382977, 3248666422386, -1953748154832, -6113631334143, -6531973384584, -8824402683459, -17024271444132, -25224140204805, -28435881713682, -32274889489944, -27730100441832, -19124536100211, -13883130282420, -5527962551856]
theorem CW_030_1_pre_eq :
    CW_1_re_010 * Fplus_dV_re_020 - CW_1_im_010 * Fplus_dV_im_020 = CW_030_1_pre := by
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CW_030_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_030_1_pim_eq :
    CW_1_re_010 * Fplus_dV_im_020 + CW_1_im_010 * Fplus_dV_re_020 = CW_030_1_pim := by
  simp only [CW_1_re_010_def, CW_1_im_010_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CW_030_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_030_1_mul :
    CW_1_c_010 * Fplus_dV_c_020 = ofLadj CW_030_1_pre CW_030_1_pim := by
  rw [CW_1_c_010_def, Fplus_dV_c_020_def, ofLadj_mul, CW_030_1_pre_eq, CW_030_1_pim_eq]

def CW_030_2_pre : Polynomial ℚ := interpQ 8639957931 [4076762967172, 3011157845920, 10840729348644, 11029090167632, 14036850963596, 24470613596441, 17726996579416, 24973821447362, 24691592642327, 24954180999139, 24132797008959, 21189978547028, 21121639163039, 14113451650495, 13662502474695, 11410627491240, 485932717318, 7229549734343, 473657007474]
def CW_030_2_pim : Polynomial ℚ := interpQ 8639957931 [-459508004948, -919016009896, -3911834854070, 3539382648586, -4873057952781, 4417511251345, 6824286022644, 5866193364378, 10739360170425, 11282601867644, 10656946501103, 11186054141464, 11715161781825, 14082325259458, 7174349454021, 14992206800542, 6772071762554, 3439223236489, 5467750060893]
theorem CW_030_2_pre_eq :
    CW_2_re_010 * Fplus_dW_re_020 - CW_2_im_010 * Fplus_dW_im_020 = CW_030_2_pre := by
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CW_030_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_030_2_pim_eq :
    CW_2_re_010 * Fplus_dW_im_020 + CW_2_im_010 * Fplus_dW_re_020 = CW_030_2_pim := by
  simp only [CW_2_re_010_def, CW_2_im_010_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CW_030_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_030_2_mul :
    CW_2_c_010 * Fplus_dW_c_020 = ofLadj CW_030_2_pre CW_030_2_pim := by
  rw [CW_2_c_010_def, Fplus_dW_c_020_def, ofLadj_mul, CW_030_2_pre_eq, CW_030_2_pim_eq]

def CW_030_3_pre : Polynomial ℚ := interpQ 8639957931 [-394018171712, 0, -558464006672, -377218640040, -822937778344, -834271045080, -834271045080, -822937778344, -377218640040, -558464006672]
def CW_030_3_pim : Polynomial ℚ := interpQ 8639957931 [175187514008, 350375028016, 585741374056, 275431273176, 706619417960, 112624651376, 237750376640, -356244389944, 74943754840, -235366346040]
theorem CW_030_3_neg_re : -CW_3_re_030 = CW_030_3_pre := by
  simp only [CW_3_re_030_def, CW_030_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_030_3_neg_im : -CW_3_im_030 = CW_030_3_pim := by
  simp only [CW_3_im_030_def, CW_030_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_030_3_mul : -CW_3_c_030 = ofLadj CW_030_3_pre CW_030_3_pim := by
  rw [CW_3_c_030_def, ofLadj_neg, CW_030_3_neg_re, CW_030_3_neg_im]

@[expose] public def CW_coeff_030 : Ki := CW_0_c_010 * Fplus_dU_c_020 + CW_1_c_010 * Fplus_dV_c_020 + CW_2_c_010 * Fplus_dW_c_020 + (-CW_3_c_030)

theorem CW_coeff_030_sum :
    CW_coeff_030 = ofLadj (CW_030_0_pre + CW_030_1_pre + CW_030_2_pre + CW_030_3_pre) (CW_030_0_pim + CW_030_1_pim + CW_030_2_pim + CW_030_3_pim) := by
  simp only [CW_coeff_030, CW_030_0_mul, CW_030_1_mul, CW_030_2_mul, CW_030_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_030_0_pre CW_030_0_pim CW_030_1_pre CW_030_1_pim CW_030_2_pre CW_030_2_pim CW_030_3_pre CW_030_3_pim

def CW_030_qre : Polynomial ℚ := interpQ 8639957931 [2642570559595, 4080659063705, 10844433698557, 8134699082639, 14289980393105, 22342809556719, 5626839662718, 13747495526629, 909699188472]
def CW_030_qim : Polynomial ℚ := interpQ 8639957931 [-6358504450916, -6358504450916, -8479162578389, -1746717441593, -11776818304390, 6551635781519, 5880947629336, 6069058753564, 9909270678483]
theorem CW_coeff_030_poly_re :
    CW_030_0_pre + CW_030_1_pre + CW_030_2_pre + CW_030_3_pre = (0 : Polynomial ℚ) + Phi11 * CW_030_qre := by
  rw [phi11_interpQ]
  simp only [CW_030_0_pre, CW_030_1_pre, CW_030_2_pre, CW_030_3_pre, CW_030_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_030_poly_im :
    CW_030_0_pim + CW_030_1_pim + CW_030_2_pim + CW_030_3_pim = (0 : Polynomial ℚ) + Phi11 * CW_030_qim := by
  rw [phi11_interpQ]
  simp only [CW_030_0_pim, CW_030_1_pim, CW_030_2_pim, CW_030_3_pim, CW_030_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_030_eq :
    CW_coeff_030 = (0 : Ki) := by
  rw [CW_coeff_030_sum, CW_coeff_030_poly_re,
    CW_coeff_030_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
