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

def CV_120_0_pre : Polynomial ℚ := interpQ 17279915862 [-254439753580, 4787298222380, 8546723605033, 14971157736293, 24901041495591, 31958814146477, 39179040059238, 44626984360144, 45486815116468, 46906650727405, 48268483104070, 48803279743060, 43481184881690, 38359927122372, 30515657380175, 18978200467283, 11000773395673, 3780547482912, -747742397270]
def CV_120_0_pim : Polynomial ℚ := interpQ 17279915862 [-4496045932898, -8992091865796, -11770775805891, -17140542105223, -17661094813779, -15902498025391, -13964062816390, -8645387137456, -4855874242914, -4695498872081, -3587795833706, 2424532739114, 8436861311934, 12323248290404, 17853389960569, 17912808238871, 14611139457275, 11112394996938, 4250647324796]
theorem CV_120_0_pre_eq :
    CV_0_re_100 * Fplus_dU_re_020 - CV_0_im_100 * Fplus_dU_im_020 = CV_120_0_pre := by
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_120_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_120_0_pim_eq :
    CV_0_re_100 * Fplus_dU_im_020 + CV_0_im_100 * Fplus_dU_re_020 = CV_120_0_pim := by
  simp only [CV_0_re_100_def, CV_0_im_100_def, Fplus_dU_re_020_def, Fplus_dU_im_020_def, CV_120_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_120_0_mul :
    CV_0_c_100 * Fplus_dU_c_020 = ofLadj CV_120_0_pre CV_120_0_pim := by
  rw [CV_0_c_100_def, Fplus_dU_c_020_def, ofLadj_mul, CV_120_0_pre_eq, CV_120_0_pim_eq]

def CV_120_1_pre : Polynomial ℚ := interpQ 17279915862 [-2302393756020, -23564768580000, -40867024427034, -66103522975581, -99947396279805, -113342180289234, -130244017785126, -149481375270633, -153049824046014, -165044679753978, -174114523013913, -175192159831764, -150549754433913, -124177655326944, -86946301070433, -42094920469260, -22187931281034, -5286093785142, 7439058521568]
def CV_120_1_pim : Polynomial ℚ := interpQ 17279915862 [13576783484490, 27153566968980, 31088680060698, 40555649370723, 30328570315557, 13843691753178, 9583109934186, -7498701616731, -20271025216950, -22014920550870, -29966698418523, -55087183465416, -80207668512309, -92094559471680, -103305424115625, -88048444311582, -61380085095312, -45067516553904, -17802224349096]
theorem CV_120_1_pre_eq :
    CV_1_re_100 * Fplus_dV_re_020 - CV_1_im_100 * Fplus_dV_im_020 = CV_120_1_pre := by
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_120_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_120_1_pim_eq :
    CV_1_re_100 * Fplus_dV_im_020 + CV_1_im_100 * Fplus_dV_re_020 = CV_120_1_pim := by
  simp only [CV_1_re_100_def, CV_1_im_100_def, Fplus_dV_re_020_def, Fplus_dV_im_020_def, CV_120_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_120_1_mul :
    CV_1_c_100 * Fplus_dV_c_020 = ofLadj CV_120_1_pre CV_120_1_pim := by
  rw [CV_1_c_100_def, Fplus_dV_c_020_def, ofLadj_mul, CV_120_1_pre_eq, CV_120_1_pim_eq]

def CV_120_2_pre : Polynomial ℚ := interpQ 17279915862 [-9779595458248, -141130774971984, -279223146214606, -456545899952242, -681534364942851, -810898932247807, -917809879276163, -981619008365640, -936231936412330, -925527188165125, -917624431577581, -904746010225886, -776493656605597, -646304041950519, -479686036460088, -264340024245938, -140727596830999, -33816649802643, 35744619176851]
def CV_120_2_pim : Polynomial ℚ := interpQ 17279915862 [96187817711584, 192375635423168, 224407640509918, 270505038617114, 207486804063997, 81318840484909, -21677759563785, -175494385620702, -265884929240440, -264274397257999, -257290773559579, -343269741444312, -429248709329045, -454297090717375, -498783956842130, -440330119805340, -323042413798775, -230762514587805, -85826146103411]
theorem CV_120_2_pre_eq :
    CV_2_re_100 * Fplus_dW_re_020 - CV_2_im_100 * Fplus_dW_im_020 = CV_120_2_pre := by
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_120_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_120_2_pim_eq :
    CV_2_re_100 * Fplus_dW_im_020 + CV_2_im_100 * Fplus_dW_re_020 = CV_120_2_pim := by
  simp only [CV_2_re_100_def, CV_2_im_100_def, Fplus_dW_re_020_def, Fplus_dW_im_020_def, CV_120_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_120_2_mul :
    CV_2_c_100 * Fplus_dW_c_020 = ofLadj CV_120_2_pre CV_120_2_pim := by
  rw [CV_2_c_100_def, Fplus_dW_c_020_def, ofLadj_mul, CV_120_2_pre_eq, CV_120_2_pim_eq]

theorem CV_120_3_mul : CV_3_c_110 = ofLadj CV_3_re_110 CV_3_im_110 := CV_3_c_110_def

@[expose] public def CV_coeff_120 : Ki := CV_0_c_100 * Fplus_dU_c_020 + CV_1_c_100 * Fplus_dV_c_020 + CV_2_c_100 * Fplus_dW_c_020 + CV_3_c_110

theorem CV_coeff_120_sum :
    CV_coeff_120 = ofLadj (CV_120_0_pre + CV_120_1_pre + CV_120_2_pre + CV_3_re_110) (CV_120_0_pim + CV_120_1_pim + CV_120_2_pim + CV_3_im_110) := by
  simp only [CV_coeff_120, CV_120_0_mul, CV_120_1_mul, CV_120_2_mul, CV_120_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_120_0_pre CV_120_0_pim CV_120_1_pre CV_120_1_pim CV_120_2_pre CV_120_2_pim CV_3_re_110 CV_3_im_110

def CV_120_qre : Polynomial ℚ := interpQ 17279915862 [-12335581172834, -147572664156770, -151440456002729, -196005090004745, -248659935902431, -135541989531555, -116592558611487, -77758131406022, 42435935301149]
def CV_120_qim : Polynomial ℚ := interpQ 17279915862 [105087124358806, 105087124358806, 33048885369231, 50167589098535, -73770235119135, -140654396441239, -105093723292041, -165339913017060, -99377723127711]
theorem CV_coeff_120_poly_re :
    CV_120_0_pre + CV_120_1_pre + CV_120_2_pre + CV_3_re_110 = (0 : Polynomial ℚ) + Phi11 * CV_120_qre := by
  rw [phi11_interpQ]
  simp only [CV_120_0_pre, CV_120_1_pre, CV_120_2_pre, CV_3_re_110_def, CV_120_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_120_poly_im :
    CV_120_0_pim + CV_120_1_pim + CV_120_2_pim + CV_3_im_110 = (0 : Polynomial ℚ) + Phi11 * CV_120_qim := by
  rw [phi11_interpQ]
  simp only [CV_120_0_pim, CV_120_1_pim, CV_120_2_pim, CV_3_im_110_def, CV_120_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_120_eq :
    CV_coeff_120 = (0 : Ki) := by
  rw [CV_coeff_120_sum, CV_coeff_120_poly_re,
    CV_coeff_120_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
