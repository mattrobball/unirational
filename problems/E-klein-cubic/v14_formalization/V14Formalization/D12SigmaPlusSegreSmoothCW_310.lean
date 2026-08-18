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

def CW_310_0_pre : Polynomial ℚ := interpQ 34559831724 [-3353140383372, 0, -830253057036, 3834719752209, 14167867281033, 23717456963733, 36118420851003, 44238605535612, 47165693867271, 48338919096333, 49597202218134, 52989008215974, 49597202218134, 49169172153369, 43330974115062, 31197271364805, 21054789449826, 8653825562556, 1126533110226]
def CW_310_0_pim : Polynomial ℚ := interpQ 34559831724 [-7110438577542, -14220877155084, -22014496863762, -35568011512731, -40950190052205, -46118329970325, -46513037051835, -39480560685738, -35600956364265, -35666344595265, -34438606667154, -26071608117654, -17704609568154, -8683251931365, 4804874486604, 10027523471793, 13644036114822, 12623237516946, 4039133875758]
theorem CW_310_0_pre_eq :
    CW_0_re_110 * Fplus_dU_re_200 - CW_0_im_110 * Fplus_dU_im_200 = CW_310_0_pre := by
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_310_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_310_0_pim_eq :
    CW_0_re_110 * Fplus_dU_im_200 + CW_0_im_110 * Fplus_dU_re_200 = CW_310_0_pim := by
  simp only [CW_0_re_110_def, CW_0_im_110_def, Fplus_dU_re_200_def, Fplus_dU_im_200_def, CW_310_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_310_0_mul :
    CW_0_c_110 * Fplus_dU_c_200 = ofLadj CW_310_0_pre CW_310_0_pim := by
  rw [CW_0_c_110_def, Fplus_dU_c_200_def, ofLadj_mul, CW_310_0_pre_eq, CW_310_0_pim_eq]

def CW_310_1_pre : Polynomial ℚ := interpQ 34559831724 [-706729095993, 3055286878488, 5199761604867, 9073270632936, 16226407655673, 19781144214224, 25108587597838, 26480423001584, 24121705946855, 23193475696612, 21761720888848, 22701730165610, 18706434010360, 17993714091745, 15048435313919, 9522121153751, 6596422621670, 1268979238056, -731894192160]
def CW_310_1_pim : Polynomial ℚ := interpQ 34559831724 [-3093533394567, -6187066789134, -7257502112143, -11122648096352, -10338872979319, -8156352736866, -5689145509524, 935298786762, 2986907909385, 3079767452744, 1942869375086, 3878709449746, 5814549524406, 5748086769757, 9706092297325, 8951487638205, 8484884174830, 6930966181918, 2022438664710]
theorem CW_310_1_pre_eq :
    CW_1_re_110 * Fplus_dV_re_200 - CW_1_im_110 * Fplus_dV_im_200 = CW_310_1_pre := by
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_310_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_310_1_pim_eq :
    CW_1_re_110 * Fplus_dV_im_200 + CW_1_im_110 * Fplus_dV_re_200 = CW_310_1_pim := by
  simp only [CW_1_re_110_def, CW_1_im_110_def, Fplus_dV_re_200_def, Fplus_dV_im_200_def, CW_310_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_310_1_mul :
    CW_1_c_110 * Fplus_dV_c_200 = ofLadj CW_310_1_pre CW_310_1_pim := by
  rw [CW_1_c_110_def, Fplus_dV_c_200_def, ofLadj_mul, CW_310_1_pre_eq, CW_310_1_pim_eq]

def CW_310_2_pre : Polynomial ℚ := interpQ 34559831724 [1904126432424, 1359413386368, 4316892814316, 6134310937644, 6429033606740, 11327482702950, 8370141915286, 11121403405603, 10256758006131, 10011763027312, 10185234713275, 8009162485614, 8825821326907, 5694870212996, 4122447068487, 4001456758255, -933138132146, 2024202655518, -690913040608]
def CW_310_2_pim : Polynomial ℚ := interpQ 34559831724 [533068704000, 1066137408000, -897421098748, 3470765794898, 1132848721480, 4919064332996, 7408104849460, 7324609797699, 10069426959551, 10041955647192, 9951115796739, 9319180440688, 8687245084637, 10559963740932, 6164305534927, 8632581704717, 4682076589214, 2695252517706, 2614458065480]
theorem CW_310_2_pre_eq :
    CW_2_re_110 * Fplus_dW_re_200 - CW_2_im_110 * Fplus_dW_im_200 = CW_310_2_pre := by
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_310_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_310_2_pim_eq :
    CW_2_re_110 * Fplus_dW_im_200 + CW_2_im_110 * Fplus_dW_re_200 = CW_310_2_pim := by
  simp only [CW_2_re_110_def, CW_2_im_110_def, Fplus_dW_re_200_def, Fplus_dW_im_200_def, CW_310_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_310_2_mul :
    CW_2_c_110 * Fplus_dW_c_200 = ofLadj CW_310_2_pre CW_310_2_pim := by
  rw [CW_2_c_110_def, Fplus_dW_c_200_def, ofLadj_mul, CW_310_2_pre_eq, CW_310_2_pim_eq]

@[expose] public def CW_coeff_310 : Ki := CW_0_c_110 * Fplus_dU_c_200 + CW_1_c_110 * Fplus_dV_c_200 + CW_2_c_110 * Fplus_dW_c_200

theorem CW_coeff_310_sum :
    CW_coeff_310 = ofLadj (CW_310_0_pre + CW_310_1_pre + CW_310_2_pre) (CW_310_0_pim + CW_310_1_pim + CW_310_2_pim) := by
  simp only [CW_coeff_310, CW_310_0_mul, CW_310_1_mul, CW_310_2_mul]
  simpa [add_assoc] using ofLadj_add3 CW_310_0_pre CW_310_0_pim CW_310_1_pre CW_310_1_pim CW_310_2_pre CW_310_2_pim

def CW_310_qre : Polynomial ℚ := interpQ 34559831724 [-2155743046941, 6570443311797, 4271701097291, 10355899960642, 17781007220657, 18002775337461, 14771066483220, 12243281578672, -296274122542]
def CW_310_qim : Polynomial ℚ := interpQ 34559831724 [-9670903268109, -9670903268109, -10827613538435, -13050473739532, -6936320495859, 800595935849, 4561540662296, 13573425610622, 8676030605948]
theorem CW_coeff_310_poly_re :
    CW_310_0_pre + CW_310_1_pre + CW_310_2_pre = (0 : Polynomial ℚ) + Phi11 * CW_310_qre := by
  rw [phi11_interpQ]
  simp only [CW_310_0_pre, CW_310_1_pre, CW_310_2_pre, CW_310_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_310_poly_im :
    CW_310_0_pim + CW_310_1_pim + CW_310_2_pim = (0 : Polynomial ℚ) + Phi11 * CW_310_qim := by
  rw [phi11_interpQ]
  simp only [CW_310_0_pim, CW_310_1_pim, CW_310_2_pim, CW_310_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_310_eq :
    CW_coeff_310 = (0 : Ki) := by
  rw [CW_coeff_310_sum, CW_coeff_310_poly_re,
    CW_coeff_310_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
