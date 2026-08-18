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

def CV_121_0_pre : Polynomial ℚ := interpQ 17279915862 [-1357721397556, 6111976113280, 9948759818748, 18937947267748, 31127729357613, 40638010284346, 49263782268552, 57286557840473, 57168775675073, 59115382461448, 61011376598244, 62793112102848, 54899400484964, 49166622642700, 38230828407325, 24021656031002, 13455140064560, 4829368080354, -2137172451858]
def CV_121_0_pim : Polynomial ℚ := interpQ 17279915862 [-6043919527428, -12087839054856, -15717115188934, -22365489967834, -23905239146911, -20413696677838, -19515870992676, -11106922547551, -6993771536475, -6489287196428, -5277696668218, 2939057564924, 11155811798066, 15996678460354, 23149537579301, 23437932861628, 18559931141496, 15159912604010, 5364504907826]
theorem CV_121_0_pre_eq :
    CV_0_re_101 * Fplus_dU_re_020 - CV_0_im_101 * Fplus_dU_im_020 = CV_121_0_pre := by
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_121_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_121_0_pim_eq :
    CV_0_re_101 * Fplus_dU_im_020 + CV_0_im_101 * Fplus_dU_re_020 = CV_121_0_pim := by
  simp only [CV_0_re_101_def, CV_0_im_101_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_121_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_121_0_mul :
    CV_0_c_101 * Fplus_dU_c_020 = ofLadj CV_121_0_pre CV_121_0_pim := by
  rw [CV_0_c_101_def, Fplus_dU_c_020_def, ofLadj_mul, CV_121_0_pre_eq, CV_121_0_pim_eq]

def CV_121_1_pre : Polynomial ℚ := interpQ 17279915862 [2369053772991, 39774615553860, 67443298683027, 110877553218834, 168339326565453, 190516496712102, 218278378510698, 252085638022926, 256219610266029, 277001219332236, 292103623498998, 296028821904606, 252329007945138, 209557920649209, 145342057047195, 69383480143971, 35895994378170, 8134112579574, -14362831313502]
def CV_121_1_pim : Polynomial ℚ := interpQ 17279915862 [-23674607834667, -47349215669334, -53116944708741, -70869827288784, -52958396756823, -24215927525658, -19039125809100, 11393335163226, 31942824956709, 34572549776652, 48285482419014, 91651594646742, 135017706874470, 154498368556239, 174880975956225, 148838969264763, 102260483620398, 76948543338510, 28680065952984]
theorem CV_121_1_pre_eq :
    CV_1_re_101 * Fplus_dV_re_020 - CV_1_im_101 * Fplus_dV_im_020 = CV_121_1_pre := by
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_121_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_121_1_pim_eq :
    CV_1_re_101 * Fplus_dV_im_020 + CV_1_im_101 * Fplus_dV_re_020 = CV_121_1_pim := by
  simp only [CV_1_re_101_def, CV_1_im_101_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_121_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_121_1_mul :
    CV_1_c_101 * Fplus_dV_c_020 = ofLadj CV_121_1_pre CV_121_1_pim := by
  rw [CV_1_c_101_def, Fplus_dV_c_020_def, ofLadj_mul, CV_121_1_pre_eq, CV_121_1_pim_eq]

def CV_121_2_pre : Polynomial ℚ := interpQ 17279915862 [21038190276400, 300611614918160, 595995035022834, 976941528118502, 1456921279620672, 1734398823575203, 1962672500195934, 2099417854602778, 2000675095439393, 1978037545118405, 1960830411905211, 1933282448704064, 1660218796987051, 1382042510095571, 1023733567320891, 564490859027532, 299400765876182, 71127089255451, -78005715954574]
def CV_121_2_pim : Polynomial ℚ := interpQ 17279915862 [-204796723840680, -409593447681360, -479866963714322, -576646461848438, -441919696382190, -171226209388675, 49201853919010, 380294044904180, 573644448652743, 570347527973435, 555434820651659, 738300571428412, 921166322205165, 976527130916351, 1070009708371159, 944820389690446, 693263974997258, 495768075647871, 183812956963028]
theorem CV_121_2_pre_eq :
    CV_2_re_101 * Fplus_dW_re_020 - CV_2_im_101 * Fplus_dW_im_020 = CV_121_2_pre := by
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_121_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_121_2_pim_eq :
    CV_2_re_101 * Fplus_dW_im_020 + CV_2_im_101 * Fplus_dW_re_020 = CV_121_2_pim := by
  simp only [CV_2_re_101_def, CV_2_im_101_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_121_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_121_2_mul :
    CV_2_c_101 * Fplus_dW_c_020 = ofLadj CV_121_2_pre CV_121_2_pim := by
  rw [CV_2_c_101_def, Fplus_dW_c_020_def, ofLadj_mul, CV_121_2_pre_eq, CV_121_2_pim_eq]

theorem CV_121_3_mul : CV_3_c_111 = ofLadj CV_3_re_111 CV_3_im_111 := CV_3_c_111_def

@[expose] public def CV_coeff_121 : Ki := CV_0_c_101 * Fplus_dU_c_020 + CV_1_c_101 * Fplus_dV_c_020 + CV_2_c_101 * Fplus_dW_c_020 + CV_3_c_111

theorem CV_coeff_121_sum :
    CV_coeff_121 = ofLadj (CV_121_0_pre + CV_121_1_pre + CV_121_2_pre + CV_3_re_111) (CV_121_0_pim + CV_121_1_pim + CV_121_2_pim + CV_3_im_111) := by
  simp only [CV_coeff_121, CV_121_0_mul, CV_121_1_mul, CV_121_2_mul, CV_121_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_121_0_pre CV_121_0_pim CV_121_1_pre CV_121_1_pim CV_121_2_pre CV_121_2_pim CV_3_re_111 CV_3_im_111

def CV_121_qre : Polynomial ℚ := interpQ 17279915862 [21841029290935, 324657177294365, 326680152029673, 433460600612069, 549410457572906, 309144094883593, 264661330403533, 178596289635313, -94505719719934]
def CV_121_qim : Polynomial ℚ := interpQ 17279915862 [-234448617237623, -234448617237623, -79682337055243, -121018043973741, 150942930089848, 303012902057685, 226207858168761, 370019003766553, 217857527823838]
theorem CV_coeff_121_poly_re :
    CV_121_0_pre + CV_121_1_pre + CV_121_2_pre + CV_3_re_111 = (0 : Polynomial ℚ) + Phi11 * CV_121_qre := by
  rw [phi11_interpQ]
  simp only [CV_121_0_pre, CV_121_1_pre, CV_121_2_pre, CV_3_re_111_def, CV_121_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_121_poly_im :
    CV_121_0_pim + CV_121_1_pim + CV_121_2_pim + CV_3_im_111 = (0 : Polynomial ℚ) + Phi11 * CV_121_qim := by
  rw [phi11_interpQ]
  simp only [CV_121_0_pim, CV_121_1_pim, CV_121_2_pim, CV_3_im_111_def, CV_121_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_121_eq :
    CV_coeff_121 = (0 : Ki) := by
  rw [CV_coeff_121_sum, CV_coeff_121_poly_re,
    CV_coeff_121_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
