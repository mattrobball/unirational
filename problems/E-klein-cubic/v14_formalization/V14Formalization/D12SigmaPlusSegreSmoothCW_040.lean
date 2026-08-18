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

def CW_040_0_pre : Polynomial ℚ := interpQ 8639957931 [2527651894980, -3689654057860, -2341398642386, -7712045753982, -15293188629808, -16173670661330, -24434404919488, -25055576665326, -26320052316690, -25834787061582, -28576874437366, -29344230543152, -24887220379506, -23493388419196, -18608006562708, -8908539662132, -8018642060782, 242092197376, 853848373386]
def CW_040_0_pim : Polynomial ℚ := interpQ 8639957931 [4150931069606, 8301862139212, 7716345647644, 16587512929186, 12553403218346, 15365147353466, 13382074322690, 9874055632012, 8381963301138, 9601244799698, 8038878718494, 3106442527872, -1825993662750, -2802843252386, -10454729035368, -7736785125840, -7617143463040, -6615331018160, -175926529562]
theorem CW_040_0_pre_eq :
    CW_0_re_020 * Fplus_dU_re_020 - CW_0_im_020 * Fplus_dU_im_020 = CW_040_0_pre := by
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CW_040_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_040_0_pim_eq :
    CW_0_re_020 * Fplus_dU_im_020 + CW_0_im_020 * Fplus_dU_re_020 = CW_040_0_pim := by
  simp only [CW_0_re_020_def, CW_0_im_020_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CW_040_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_040_0_mul :
    CW_0_c_020 * Fplus_dU_c_020 = ofLadj CW_040_0_pre CW_040_0_pim := by
  rw [CW_0_c_020_def, Fplus_dU_c_020_def, ofLadj_mul, CW_040_0_pre_eq, CW_040_0_pim_eq]

def CW_040_1_pre : Polynomial ℚ := interpQ 8639957931 [-481613403552, 1431871581552, 1383375506814, 3483155617782, 6019779468762, 4719215714166, 7955207459940, 7544570701254, 7686983350986, 8778075685338, 9162224978394, 9616201503648, 7730353396842, 7394700178524, 4203827733204, 903325232046, 2113874772624, -1122116973150, -621466000446]
def CW_040_1_pim : Polynomial ℚ := interpQ 8639957931 [-1135726440246, -2271452880492, -1812049302168, -4292876471424, -1567340065320, -2108372508756, -2136121192302, 68273017146, -700240989120, -416114293164, 376759951884, 2014790602644, 3652821253404, 3986291920128, 6751245785340, 3326938116828, 3185975716896, 2816646308958, -69742743858]
theorem CW_040_1_pre_eq :
    CW_1_re_020 * Fplus_dV_re_020 - CW_1_im_020 * Fplus_dV_im_020 = CW_040_1_pre := by
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CW_040_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_040_1_pim_eq :
    CW_1_re_020 * Fplus_dV_im_020 + CW_1_im_020 * Fplus_dV_re_020 = CW_040_1_pim := by
  simp only [CW_1_re_020_def, CW_1_im_020_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CW_040_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_040_1_mul :
    CW_1_c_020 * Fplus_dV_c_020 = ofLadj CW_040_1_pre CW_040_1_pim := by
  rw [CW_1_c_020_def, Fplus_dV_c_020_def, ofLadj_mul, CW_040_1_pre_eq, CW_040_1_pim_eq]

def CW_040_2_pre : Polynomial ℚ := interpQ 8639957931 [-9880423390492, -203706884864, -15734745459026, -22440602658090, -20243874344098, -37984356322282, -29720410667424, -41501150314128, -35908017795896, -37484375385356, -35126437302628, -26978672823032, -34922730417764, -21749629926330, -13467415137806, -17018588826370, 802491796004, -7461453858854, 4238687143660]
def CW_040_2_pim : Polynomial ℚ := interpQ 8639957931 [-3923760624900, -7847521249800, 5441130721964, -15299301995448, -5217297181940, -18758693839020, -24201892987714, -29081551683370, -38698345270746, -40201753465262, -39432261629106, -35229300093704, -31026338558302, -43545498693910, -24308474171014, -32375541920802, -21083536218274, -14261998392200, -11631730651096]
theorem CW_040_2_pre_eq :
    CW_2_re_020 * Fplus_dW_re_020 - CW_2_im_020 * Fplus_dW_im_020 = CW_040_2_pre := by
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CW_040_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_040_2_pim_eq :
    CW_2_re_020 * Fplus_dW_im_020 + CW_2_im_020 * Fplus_dW_re_020 = CW_040_2_pim := by
  simp only [CW_2_re_020_def, CW_2_im_020_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CW_040_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_040_2_mul :
    CW_2_c_020 * Fplus_dW_c_020 = ofLadj CW_040_2_pre CW_040_2_pim := by
  rw [CW_2_c_020_def, Fplus_dW_c_020_def, ofLadj_mul, CW_040_2_pre_eq, CW_040_2_pim_eq]

@[expose] public def CW_coeff_040 : Ki := CW_0_c_020 * Fplus_dU_c_020 + CW_1_c_020 * Fplus_dV_c_020 + CW_2_c_020 * Fplus_dW_c_020

theorem CW_coeff_040_sum :
    CW_coeff_040 = ofLadj (CW_040_0_pre + CW_040_1_pre + CW_040_2_pre) (CW_040_0_pim + CW_040_1_pim + CW_040_2_pim) := by
  simp only [CW_coeff_040, CW_040_0_mul, CW_040_1_mul, CW_040_2_mul]
  simpa [add_assoc] using ofLadj_add3 CW_040_0_pre CW_040_0_pim CW_040_1_pre CW_040_1_pim CW_040_2_pre CW_040_2_pim

def CW_040_qre : Polynomial ℚ := interpQ 8639957931 [-7834384899064, 5372895537892, -14231279233426, -9976724199692, -2847790710854, -19921527764302, 3239203142474, -12812548151228, 4471069516600]
def CW_040_qim : Polynomial ℚ := interpQ 8639957931 [-908555995540, -908555995540, 13162539058520, -14350092605126, 8773431508772, -11270684965396, -7454020863016, -6183283176886, -11877399924516]
theorem CW_coeff_040_poly_re :
    CW_040_0_pre + CW_040_1_pre + CW_040_2_pre = (0 : Polynomial ℚ) + Phi11 * CW_040_qre := by
  rw [phi11_interpQ]
  simp only [CW_040_0_pre, CW_040_1_pre, CW_040_2_pre, CW_040_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_040_poly_im :
    CW_040_0_pim + CW_040_1_pim + CW_040_2_pim = (0 : Polynomial ℚ) + Phi11 * CW_040_qim := by
  rw [phi11_interpQ]
  simp only [CW_040_0_pim, CW_040_1_pim, CW_040_2_pim, CW_040_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_040_eq :
    CW_coeff_040 = (0 : Ki) := by
  rw [CW_coeff_040_sum, CW_coeff_040_poly_re,
    CW_coeff_040_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
