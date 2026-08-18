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

def CU_020_0_pre : Polynomial ℚ := interpQ 235794999 [-43069159064, -3254371442110, -6193828496386, -10953068999157, -17632416645332, -22653670422513, -27914345748139, -31836188965975, -32265304699713, -33432030273007, -34288662691921, -34509286391230, -31034291249811, -27238201776621, -21312235700556, -13564671234168, -7980956085348, -2720280759722, 639101086475]
def CU_020_0_pim : Polynomial ℚ := interpQ 235794999 [2992840343871, 5985680687742, 8277240989129, 11556894712335, 11857569046019, 10729373998105, 9339364808532, 5273946242456, 2573029825127, 2401594342019, 1598722110447, -2457046080648, -6512814271743, -9607246804702, -13058336011016, -12849953810172, -10730598216573, -8266552063618, -3209972951857]
theorem CU_020_0_pre_eq :
    CU_0_re_000 * Fplus_dU_re_020 - CU_0_im_000 * Fplus_dU_im_020 = CU_020_0_pre := by
  simp only [CU_0_re_000_def, CU_0_im_000_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CU_020_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_020_0_pim_eq :
    CU_0_re_000 * Fplus_dU_im_020 + CU_0_im_000 * Fplus_dU_re_020 = CU_020_0_pim := by
  simp only [CU_0_re_000_def, CU_0_im_000_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CU_020_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_020_0_mul :
    CU_0_c_000 * Fplus_dU_c_020 = ofLadj CU_020_0_pre CU_020_0_pim := by
  rw [CU_0_c_000_def, Fplus_dU_c_020_def, ofLadj_mul, CU_020_0_pre_eq, CU_020_0_pim_eq]

def CU_020_1_pre : Polynomial ℚ := interpQ 235794999 [-2045461745844, -19771322829432, -34435610320290, -55593242118702, -83992663935081, -95518692762051, -109523738950845, -125722656155592, -128735365741803, -138777467033148, -146456221704735, -147277771080576, -126684898875303, -104341856712858, -73142123623101, -35508653250600, -18484393472046, -4479347283252, 6221338969911]
def CU_020_1_pim : Polynomial ℚ := interpQ 235794999 [11334345895473, 22668691790946, 26113548139647, 33857499443856, 25480813554270, 11465829140175, 7716374248359, -6499820735616, -17358915021942, -18800189652522, -25442169651897, -46524802125396, -67607434598895, -77694270946971, -86879496881760, -74293323325263, -51737519427210, -37825596421170, -15068581953237]
theorem CU_020_1_pre_eq :
    CU_1_re_000 * Fplus_dV_re_020 - CU_1_im_000 * Fplus_dV_im_020 = CU_020_1_pre := by
  simp only [CU_1_re_000_def, CU_1_im_000_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CU_020_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_020_1_pim_eq :
    CU_1_re_000 * Fplus_dV_im_020 + CU_1_im_000 * Fplus_dV_re_020 = CU_020_1_pim := by
  simp only [CU_1_re_000_def, CU_1_im_000_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CU_020_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_020_1_mul :
    CU_1_c_000 * Fplus_dV_c_020 = ofLadj CU_020_1_pre CU_020_1_pim := by
  rw [CU_1_c_000_def, Fplus_dV_c_020_def, ofLadj_mul, CU_020_1_pre_eq, CU_020_1_pim_eq]

def CU_020_2_pre : Polynomial ℚ := interpQ 235794999 [-10637275996012, -149300994117184, -296154828448288, -484695170135424, -723205188959509, -861646843204176, -974144826323120, -1042226268023336, -993404444086958, -982155717850367, -973601581484794, -959816452781524, -824300587367610, -686000889402079, -508709273951534, -280528615492760, -148168232043956, -35670248925012, 38492463571067]
def CU_020_2_pim : Polynomial ℚ := interpQ 235794999 [101636197303340, 203272394606680, 238098212735602, 285957261710394, 219932562944492, 84861844215914, -24750750279557, -188494399217396, -284631550184901, -283008763894837, -275544575174826, -366335702308156, -457126829441486, -484488458850397, -530724721535125, -469439415665670, -343922325935679, -245587778010310, -91397758071058]
theorem CU_020_2_pre_eq :
    CU_2_re_000 * Fplus_dW_re_020 - CU_2_im_000 * Fplus_dW_im_020 = CU_020_2_pre := by
  simp only [CU_2_re_000_def, CU_2_im_000_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CU_020_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_020_2_pim_eq :
    CU_2_re_000 * Fplus_dW_im_020 + CU_2_im_000 * Fplus_dW_re_020 = CU_020_2_pim := by
  simp only [CU_2_re_000_def, CU_2_im_000_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CU_020_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_020_2_mul :
    CU_2_c_000 * Fplus_dW_c_020 = ofLadj CU_020_2_pre CU_020_2_pim := by
  rw [CU_2_c_000_def, Fplus_dW_c_020_def, ofLadj_mul, CU_020_2_pre_eq, CU_020_2_pim_eq]

def CU_020_3_pre : Polynomial ℚ := interpQ 235794999 [-17148727200, 0, 18749275072, 58648647024, 85743636000, 106322108640, 106322108640, 85743636000, 58648647024, 18749275072]
def CU_020_3_pim : Polynomial ℚ := interpQ 235794999 [-33855744760, -67711489520, -87047978584, -97124154960, -76275459952, -54626491008, -13084998512, 8563970432, 29412665440, 19336489064]
theorem CU_020_3_neg_re : -CU_3_re_020 = CU_020_3_pre := by
  simp only [CU_3_re_020_def, CU_020_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_020_3_neg_im : -CU_3_im_020 = CU_020_3_pim := by
  simp only [CU_3_im_020_def, CU_020_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_020_3_mul : -CU_3_c_020 = ofLadj CU_020_3_pre CU_020_3_pim := by
  rw [CU_3_c_020_def, ofLadj_neg, CU_020_3_neg_re, CU_020_3_neg_im]

@[expose] public def CU_coeff_020 : Ki := CU_0_c_000 * Fplus_dU_c_020 + CU_1_c_000 * Fplus_dV_c_020 + CU_2_c_000 * Fplus_dW_c_020 + (-CU_3_c_020)

theorem CU_coeff_020_sum :
    CU_coeff_020 = ofLadj (CU_020_0_pre + CU_020_1_pre + CU_020_2_pre + CU_020_3_pre) (CU_020_0_pim + CU_020_1_pim + CU_020_2_pim + CU_020_3_pim) := by
  simp only [CU_coeff_020, CU_020_0_mul, CU_020_1_mul, CU_020_2_mul, CU_020_3_mul]
  simpa [add_assoc] using ofLadj_add4 CU_020_0_pre CU_020_0_pim CU_020_1_pre CU_020_1_pim CU_020_2_pre CU_020_2_pim CU_020_3_pre CU_020_3_pim

def CU_020_qre : Polynomial ℚ := interpQ 235794999 [-12742955628120, -159583732760606, -164438829601166, -214417314616367, -273561693297663, -154968358376178, -131763704633364, -88222780595439, 45352903627453]
def CU_020_qim : Polynomial ℚ := interpQ 235794999 [115929527797924, 115929527797924, 40542898289946, 58872577825831, -74079861626796, -150192249221643, -114710517084364, -182003613518946, -109676312976152]
theorem CU_coeff_020_poly_re :
    CU_020_0_pre + CU_020_1_pre + CU_020_2_pre + CU_020_3_pre = (0 : Polynomial ℚ) + Phi11 * CU_020_qre := by
  rw [phi11_interpQ]
  simp only [CU_020_0_pre, CU_020_1_pre, CU_020_2_pre, CU_020_3_pre, CU_020_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CU_coeff_020_poly_im :
    CU_020_0_pim + CU_020_1_pim + CU_020_2_pim + CU_020_3_pim = (0 : Polynomial ℚ) + Phi11 * CU_020_qim := by
  rw [phi11_interpQ]
  simp only [CU_020_0_pim, CU_020_1_pim, CU_020_2_pim, CU_020_3_pim, CU_020_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CU_coeff_020_eq :
    CU_coeff_020 = (0 : Ki) := by
  rw [CU_coeff_020_sum, CU_coeff_020_poly_re,
    CU_coeff_020_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
