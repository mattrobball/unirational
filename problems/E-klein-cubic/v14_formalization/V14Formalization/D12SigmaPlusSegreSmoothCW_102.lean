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

def CW_102_0_pre : Polynomial ℚ := interpQ 17279915862 [-4989319647258, -97311910998792, -192252799231186, -313857674496065, -478228734179271, -576261485486884, -669274104073017, -728409158804892, -716037102845744, -725791719534830, -733002666998916, -730858789160594, -635690756000124, -533538920303644, -402179428349679, -228980563126121, -125623683625093, -32611065038960, 21199861499500]
def CW_102_0_pim : Polynomial ℚ := interpQ 17279915862 [70078246332712, 140156492665424, 169761508760862, 214561033411633, 184780936895561, 112963694492872, 56264624856567, -46774962788586, -104213434305034, -105717507012044, -112048220966676, -191477072727012, -270905924487348, -306841654537418, -353145251895199, -319229692210675, -239322864803251, -172703107334788, -61573934684900]
theorem CW_102_0_pre_eq :
    CW_0_re_100 * Fplus_dU_re_002 - CW_0_im_100 * Fplus_dU_im_002 = CW_102_0_pre := by
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CW_102_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_102_0_pim_eq :
    CW_0_re_100 * Fplus_dU_im_002 + CW_0_im_100 * Fplus_dU_re_002 = CW_102_0_pim := by
  simp only [CW_0_re_100_def, CW_0_im_100_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CW_102_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_102_0_mul :
    CW_0_c_100 * Fplus_dU_c_002 = ofLadj CW_102_0_pre CW_102_0_pim := by
  rw [CW_0_c_100_def, Fplus_dU_c_002_def, ofLadj_mul, CW_102_0_pre_eq, CW_102_0_pim_eq]

def CW_102_1_pre : Polynomial ℚ := interpQ 17279915862 [553279432724, -8621696174992, -18234028555075, -31203842056468, -49784937321986, -64327555014379, -75936199593278, -79159053871001, -71568361502985, -66181861667929, -62167472283071, -61123452429210, -53545776108079, -47947833112854, -40364519446517, -26701807370755, -15177890359574, -3569245780675, 2672309178260]
def CW_102_1_pim : Polynomial ℚ := interpQ 17279915862 [9298872044110, 18597744088220, 22841897465835, 29260872335384, 28503741283556, 20285171278889, 8713011321192, -7185386219061, -15936572326157, -15077586390273, -11546177144981, -15664623627662, -19783070110343, -20495814242666, -26055803176331, -27587308136769, -23884715147124, -17844970620061, -6462550094830]
theorem CW_102_1_pre_eq :
    CW_1_re_100 * Fplus_dV_re_002 - CW_1_im_100 * Fplus_dV_im_002 = CW_102_1_pre := by
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CW_102_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_102_1_pim_eq :
    CW_1_re_100 * Fplus_dV_im_002 + CW_1_im_100 * Fplus_dV_re_002 = CW_102_1_pim := by
  simp only [CW_1_re_100_def, CW_1_im_100_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CW_102_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_102_1_mul :
    CW_1_c_100 * Fplus_dV_c_002 = ofLadj CW_102_1_pre CW_102_1_pim := by
  rw [CW_1_c_100_def, Fplus_dV_c_002_def, ofLadj_mul, CW_102_1_pre_eq, CW_102_1_pim_eq]

def CW_102_2_pre : Polynomial ℚ := interpQ 17279915862 [630378873057, 0, -1052608612734, -2688407871042, -3968135372142, -4838860936413, -4838860936413, -3968135372142, -2688407871042, -1052608612734]
def CW_102_2_pim : Polynomial ℚ := interpQ 17279915862 [1493901462669, 2987802925338, 3959813278272, 4278935803008, 3436998946134, 2309570341497, 678232583841, -449196020796, -1291132877670, -972010352934]
theorem CW_102_2_pre_eq :
    CW_2_re_100 * Fplus_dW_re_002 - CW_2_im_100 * Fplus_dW_im_002 = CW_102_2_pre := by
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CW_102_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_102_2_pim_eq :
    CW_2_re_100 * Fplus_dW_im_002 + CW_2_im_100 * Fplus_dW_re_002 = CW_102_2_pim := by
  simp only [CW_2_re_100_def, CW_2_im_100_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CW_102_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_102_2_mul :
    CW_2_c_100 * Fplus_dW_c_002 = ofLadj CW_102_2_pre CW_102_2_pim := by
  rw [CW_2_c_100_def, Fplus_dW_c_002_def, ofLadj_mul, CW_102_2_pre_eq, CW_102_2_pim_eq]

theorem CW_102_3_mul : CW_3_c_101 = ofLadj CW_3_re_101 CW_3_im_101 := CW_3_c_101_def

@[expose] public def CW_coeff_102 : Ki := CW_0_c_100 * Fplus_dU_c_002 + CW_1_c_100 * Fplus_dV_c_002 + CW_2_c_100 * Fplus_dW_c_002 + CW_3_c_101

theorem CW_coeff_102_sum :
    CW_coeff_102 = ofLadj (CW_102_0_pre + CW_102_1_pre + CW_102_2_pre + CW_3_re_101) (CW_102_0_pim + CW_102_1_pim + CW_102_2_pim + CW_3_im_101) := by
  simp only [CW_coeff_102, CW_102_0_mul, CW_102_1_mul, CW_102_2_mul, CW_102_3_mul]
  simpa [add_assoc] using ofLadj_add4 CW_102_0_pre CW_102_0_pim CW_102_1_pre CW_102_1_pim CW_102_2_pre CW_102_2_pim CW_3_re_101 CW_3_im_101

def CW_102_qre : Polynomial ℚ := interpQ 17279915862 [-3187897692183, -102745709481601, -107749778691705, -138942805620302, -186861577299320, -114880796512209, -104621263165032, -60052481497395, 23872170677760]
def CW_102_qim : Polynomial ℚ := interpQ 17279915862 [83547298243017, 83547298243017, 36648474182393, 51863586291446, -32384054724086, -83609420397069, -72659501995526, -122511593175119, -68036484779730]
theorem CW_coeff_102_poly_re :
    CW_102_0_pre + CW_102_1_pre + CW_102_2_pre + CW_3_re_101 = (0 : Polynomial ℚ) + Phi11 * CW_102_qre := by
  rw [phi11_interpQ]
  simp only [CW_102_0_pre, CW_102_1_pre, CW_102_2_pre, CW_3_re_101_def, CW_102_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CW_coeff_102_poly_im :
    CW_102_0_pim + CW_102_1_pim + CW_102_2_pim + CW_3_im_101 = (0 : Polynomial ℚ) + Phi11 * CW_102_qim := by
  rw [phi11_interpQ]
  simp only [CW_102_0_pim, CW_102_1_pim, CW_102_2_pim, CW_3_im_101_def, CW_102_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CW_coeff_102_eq :
    CW_coeff_102 = (0 : Ki) := by
  rw [CW_coeff_102_sum, CW_coeff_102_poly_re,
    CW_coeff_102_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
