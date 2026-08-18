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

def CV_002_0_pre : Polynomial ℚ := interpQ 17279915862 [-25973079712951, -457593761883076, -910399862665079, -1479229646770067, -2250021209440933, -2717955160028331, -3148281964924258, -3432715040565944, -3375069609535708, -3420341274925652, -3455038029916647, -3441935618193450, -2997444268033571, -2509941412260573, -1895839962765641, -1083354971132723, -590633104287732, -160306299391805, 99338859992288]
def CV_002_0_pim : Polynomial ℚ := interpQ 17279915862 [328555058648113, 657110117296226, 798433373725875, 1000671384611136, 868507582647850, 524532115399664, 259014078619832, -222148133408714, -497500462597266, -504237472648311, -534058667638764, -906650782955452, -1279242898272140, -1450387349692242, -1659362370628548, -1507889089460736, -1125731116888122, -814006525746052, -294661808393078]
theorem CV_002_0_pre_eq :
    CV_0_re_000 * Fplus_dU_re_002 - CV_0_im_000 * Fplus_dU_im_002 = CV_002_0_pre := by
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_002_0_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_002_0_pim_eq :
    CV_0_re_000 * Fplus_dU_im_002 + CV_0_im_000 * Fplus_dU_re_002 = CV_002_0_pim := by
  simp only [CV_0_re_000_def, CV_0_im_000_def, Fplus_dU_re_002_def, Fplus_dU_im_002_def, CV_002_0_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_002_0_mul :
    CV_0_c_000 * Fplus_dU_c_002 = ofLadj CV_002_0_pre CV_002_0_pim := by
  rw [CV_0_c_000_def, Fplus_dU_c_002_def, ofLadj_mul, CV_002_0_pre_eq, CV_002_0_pim_eq]

def CV_002_1_pre : Polynomial ℚ := interpQ 17279915862 [2475223974192, -54015337685120, -115095630157327, -196843467999374, -313538098832667, -405596703909726, -477852749781559, -499042605200028, -450987106548594, -417113379674632, -391351879595871, -384138593533874, -337336541910751, -302017749517305, -254143638549220, -168489490095524, -94909364781581, -22653318909748, 17015016271837]
def CV_002_1_pim : Polynomial ℚ := interpQ 17279915862 [58010102283988, 116020204567976, 143757168213500, 182700808957796, 178831212018020, 126325535177206, 53581265036006, -46581534822129, -101818985116190, -96930848354441, -74579035315721, -99790095490496, -125001155665271, -130386306272075, -164441810254622, -174830644934308, -151003973246995, -112462813379233, -40979018674599]
theorem CV_002_1_pre_eq :
    CV_1_re_000 * Fplus_dV_re_002 - CV_1_im_000 * Fplus_dV_im_002 = CV_002_1_pre := by
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_002_1_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_002_1_pim_eq :
    CV_1_re_000 * Fplus_dV_im_002 + CV_1_im_000 * Fplus_dV_re_002 = CV_002_1_pim := by
  simp only [CV_1_re_000_def, CV_1_im_000_def, Fplus_dV_re_002_def, Fplus_dV_im_002_def, CV_002_1_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_002_1_mul :
    CV_1_c_000 * Fplus_dV_c_002 = ofLadj CV_002_1_pre CV_002_1_pim := by
  rw [CV_1_c_000_def, Fplus_dV_c_002_def, ofLadj_mul, CV_002_1_pre_eq, CV_002_1_pim_eq]

def CV_002_2_pre : Polynomial ℚ := interpQ 17279915862 [5760664312125, 0, -15013518728826, -34785463168872, -52830139385583, -63657773343180, -63657773343180, -52830139385583, -34785463168872, -15013518728826]
def CV_002_2_pim : Polynomial ℚ := interpQ 17279915862 [19202292014370, 38404584028740, 51288039591513, 54301365945513, 45804028932753, 29341512578658, 9063071450082, -7399444904013, -15896781916773, -12883455562773]
theorem CV_002_2_pre_eq :
    CV_2_re_000 * Fplus_dW_re_002 - CV_2_im_000 * Fplus_dW_im_002 = CV_002_2_pre := by
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_002_2_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_002_2_pim_eq :
    CV_2_re_000 * Fplus_dW_im_002 + CV_2_im_000 * Fplus_dW_re_002 = CV_002_2_pim := by
  simp only [CV_2_re_000_def, CV_2_im_000_def, Fplus_dW_re_002_def, Fplus_dW_im_002_def, CV_002_2_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_002_2_mul :
    CV_2_c_000 * Fplus_dW_c_002 = ofLadj CV_002_2_pre CV_002_2_pim := by
  rw [CV_2_c_000_def, Fplus_dW_c_002_def, ofLadj_mul, CV_002_2_pre_eq, CV_002_2_pim_eq]

def CV_002_3_pre : Polynomial ℚ := interpQ 17279915862 [-2578506358560, 0, 6078263816592, 14452269740656, 21843999374912, 26362196838032, 26362196838032, 21843999374912, 14452269740656, 6078263816592]
def CV_002_3_pim : Polynomial ℚ := interpQ 17279915862 [-7964277455008, -15928554910016, -21342628521056, -22507081585760, -19060792158064, -12101775974896, -3826778935120, 3132237248048, 6578526675744, 5414073611040]
theorem CV_002_3_neg_re : -CV_3_re_002 = CV_002_3_pre := by
  simp only [CV_3_re_002_def, CV_002_3_pre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_002_3_neg_im : -CV_3_im_002 = CV_002_3_pim := by
  simp only [CV_3_im_002_def, CV_002_3_pim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_002_3_mul : -CV_3_c_002 = ofLadj CV_002_3_pre CV_002_3_pim := by
  rw [CV_3_c_002_def, ofLadj_neg, CV_002_3_neg_re, CV_002_3_neg_im]

@[expose] public def CV_coeff_002 : Ki := CV_0_c_000 * Fplus_dU_c_002 + CV_1_c_000 * Fplus_dV_c_002 + CV_2_c_000 * Fplus_dW_c_002 + (-CV_3_c_002)

theorem CV_coeff_002_sum :
    CV_coeff_002 = ofLadj (CV_002_0_pre + CV_002_1_pre + CV_002_2_pre + CV_002_3_pre) (CV_002_0_pim + CV_002_1_pim + CV_002_2_pim + CV_002_3_pim) := by
  simp only [CV_coeff_002, CV_002_0_mul, CV_002_1_mul, CV_002_2_mul, CV_002_3_mul]
  simpa [add_assoc] using ofLadj_add4 CV_002_0_pre CV_002_0_pim CV_002_1_pre CV_002_1_pim CV_002_2_pre CV_002_2_pim CV_002_3_pre CV_002_3_pim

def CV_002_qre : Polynomial ℚ := interpQ 17279915862 [-20315697785194, -491293401783002, -522821648166444, -661975560463017, -898139140086614, -566301992158934, -502582850767760, -299313494565678, 116353876264125]
def CV_002_qim : Polynomial ℚ := interpQ 17279915862 [397803175491463, 397803175491463, 176529602026906, 243030524918853, -141084446488126, -405984644259927, -350265751009832, -590828512057608, -335640827067677]
theorem CV_coeff_002_poly_re :
    CV_002_0_pre + CV_002_1_pre + CV_002_2_pre + CV_002_3_pre = (0 : Polynomial ℚ) + Phi11 * CV_002_qre := by
  rw [phi11_interpQ]
  simp only [CV_002_0_pre, CV_002_1_pre, CV_002_2_pre, CV_002_3_pre, CV_002_qre]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
theorem CV_coeff_002_poly_im :
    CV_002_0_pim + CV_002_1_pim + CV_002_2_pim + CV_002_3_pim = (0 : Polynomial ℚ) + Phi11 * CV_002_qim := by
  rw [phi11_interpQ]
  simp only [CV_002_0_pim, CV_002_1_pim, CV_002_2_pim, CV_002_3_pim, CV_002_qim]
  simp (disch := decide) only [interp_zero, interp_one, interp_ofNat,
    interp_neg, interp_mul, interp_add, interp_sub, interp_add_gen,
    interp_sub_gen, Nat.reduceMul]
  apply interp_eq
  · decide
  · decide
  · decide
public theorem CV_coeff_002_eq :
    CV_coeff_002 = (0 : Ki) := by
  rw [CV_coeff_002_sum, CV_coeff_002_poly_re,
    CV_coeff_002_poly_im, ofLadj_add_Phi11]
  exact ofLadj_zero

end V14Formalization.D12SigmaPlusSegreCore
